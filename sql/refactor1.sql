/*
Профилирование пользователей по пользованию сервисом и расчет
групповой статистики. На начальных этапах осуществляется маркировка
каждого пользователя в зависимости от его поведения.
Затем все признаки объединяются в общую таблицу пользователей
и происходит расчет групповой статистики.
Результат: количество пользователей в каждой группе за все время
*/
with
class_weekly_trips_cte as (
    /* Классификация пользователей по поездкам в течение недели. Признаки:
      regular - регулярный пользователь, катается не менее 3 дней в неделю
      fan - фанат, пользуется сервисом в среднем не менее 6 дней в неделю */
    select
        user_id,
        avg(days_per_week) >= 6 as fan,
        avg(days_per_week) >= 3 as regular
    from (
        /* Для каждого пользователя находим статистику поездок по неделям:
          days_per_week - количество дней с поездками в неделю */
        select
            user_id,
            date_trunc('week', started_at) as "week",
            count(distinct date(started_at)) as days_per_week
        from
            scooters_raw.trips
        group by
            1,
            2
        )
    group by
        1
),
prep_weekly_destination_trips_cte as (
    /* Подготовка данных для профилирования пользователей по поездкам
    в определенное место в течение недели.
    Для каждого пользователя находим список уникальных точек назначения
    и статистику по поездкам туда:
      avg_morning_trip_days - среднее число дней с утренними поездками в неделю */
    select
        user_id,
        destination,
        avg(morning_trip_days) as avg_morning_trip_days
    from (
        /* Для каждого пользователя находим статистику поездок в каждую точку
        на каждую неделю:
          morning_trip_days - количество дней с утренними поездками */
        select
            user_id,
            destination,
            date_trunc('week', "date") as "week",
            count(distinct
                case when morning_trips > 0 then "date" end
            ) as morning_trip_days
        from (
            /* Для каждого пользователя находим статистику поездок в каждую точку
            на каждый день:
              morning_trips - количество утренних поездок */
            select
                user_id,
                st_reduceprecision(
                    st_makepoint(finish_lon, finish_lat), 0.001
                    ) as destination,
                date(started_at) as "date",
        count(
            case when extract(
                hour from started_at
            ) between 6 and 10 then 1 end
        ) as morning_trips
            from
                scooters_raw.trips
            group by
                1,
                2,
                3
            )
        group by
            1,
            2,
            3
        )
    group by
        1,
        2
),
class_weekly_destination_trips_cte as (
    /* Классификация пользователей по поездкам в течение недели
    с учетом точки назначения:
      to_work - в утреннее время ездит в одно и то же место (на работу)
        минимум три раза в неделю */
    select
        user_id,
        max(avg_morning_trip_days) >= 3 as to_work
    from
        prep_weekly_destination_trips_cte
    group by
        1
),
class_monthly_trips_cte as (
    /* Классификация пользователей по количеству поездок в месяц:
      rare - редкие/разовые поездки, не более 2 поездок в месяц */
    select
        user_id,
        "month",
        sum(trips_per_month) <= 2 as rare
    from (
        /* Для каждого пользователя находим месячную статистику поездок:
          trips_per_month - количество поездок в месяц */
        select
            user_id,
            date_trunc('month', started_at) as "month",
            count(*) as trips_per_month
        from
            scooters_raw.trips
        group by
            1,
            2
    )
    group by
        1,
        2
),
join_cte as (
    select
        id as user_id,
        fan,
        regular,
        rare,
        to_work,
        not (fan or regular or rare or to_work) as no_class
    from
        scooters_raw.users
        full outer join class_weekly_trips_cte
            on user_id = id
        full outer join class_weekly_destination_trips_cte
            using (user_id)
        full outer join class_monthly_trips_cte
            using (user_id)
)
/* Расчет групповой статистики за все время:
  - количество пользователей в каждой группе
  - общее число пользователей для информации и валидации */
select
    count(fan or null) as fan_count,
    count(regular or null) as regular_count,
    count(rare or null) as rare_count,
    count(to_work or null) as to_work_count,
    count(no_class or null) as no_class_count,
    count(*) as total_count
from
    join_cte
