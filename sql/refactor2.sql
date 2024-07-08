CREATE OR REPLACE PROCEDURE create_trips_age_sex_report(
    IN granularity TEXT,
    IN validate BOOLEAN DEFAULT FALSE
)
LANGUAGE plpgsql
AS $procedure$
-- Процедура для создания отчетов по поездкам с различной гранулярностью
-- Аргументы:
--   granularity - гранулярность таблицы (daly/weekly/monthly)
--   validate - флаг для проверки запросов. Выводит SQL, но не выполняет его
-- Результат: таблица со статистикой поездок, агрегированная по возрасту и полу
DECLARE
    -- Внутренние переменные для создания запросов
    create_query_template TEXT;
    create_query TEXT;
    drop_query TEXT;
BEGIN
    -- Шаблон запроса для создания таблицы
    create_query_template := '
        CREATE TABLE trips_age_sex_%s AS
        SELECT
            %s,
            age,
            coalesce(sex, ''UNKNOWN'') as sex,
            count(*) as trips,
            sum(price_rub) as revenue_rub
        FROM (
            SELECT
                started_at,
                CAST(price AS DECIMAL(20, 2)) / 100 as price_rub,
                EXTRACT(YEAR FROM t.started_at) -
                    EXTRACT(YEAR FROM u.birth_date) as age,
                u.sex
            FROM
                scooters_raw.trips AS t
                LEFT JOIN scooters_raw.users AS u
                  ON t.user_id = u.id
            ) AS subquery
        GROUP BY
            1,
            2,
            3';
    -- Формирование SQL-запроса в зависимости от гранулярности
    IF granularity = 'daily' THEN
        create_query := format(
            create_query_template, granularity,
            'date(started_at) as "date"'
        );
    ELSIF granularity = 'weekly' THEN
        create_query := format(
            create_query_template, granularity,
            'date_trunc(''week'', started_at)::date as week'
        );
    ELSIF granularity = 'monthly' THEN
        create_query := format(
            create_query_template, granularity,
            'date_trunc(''month'', started_at)::date as month'
        );
    ELSE
        RAISE EXCEPTION 'Неверная гранулярность: %', granularity;
    END IF;
    -- Создание запроса на удаление таблицы
    drop_query := format('DROP TABLE IF EXISTS trips_age_sex_%s', granularity);
    IF validate THEN
        -- Вывод запросов для проверки без запуска
        RAISE NOTICE '-- Drop query: %', drop_query;
        RAISE NOTICE '-- Create query: %', create_query;
    ELSE
        -- Выполнение запроса на удаление таблицы
        RAISE NOTICE 'Recreating table from scratch';
        EXECUTE drop_query;
        -- Выполнение CTAS-запроса для создания таблицы
        EXECUTE create_query;
    END IF;
END;
$procedure$;
