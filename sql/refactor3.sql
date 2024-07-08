-- 1
drop table if exists revenue_user_monthly

-- 2
create table revenue_user_monthly as
select
    user_id,
    date(date_trunc('month', "date")) as "month",
    sum(price_rub) as revenue_total
from
    dbt.trips_users
where
    not is_free
    and date_trunc('month', "date") = date '2023-06-01'
group by
    1,
    2

-- 3
drop table if exists revenue_monthly

-- 4
create table revenue_monthly as
select
    "month",
    count(*) as users,
    percentile_cont(0.5) within group (order by revenue_total) as revenue_median,
    percentile_cont(0.95) within group (order by revenue_total) as revenue_95,
    max(revenue_total) as revenue_max,
    sum(revenue_total) as revenue_total
from
    revenue_user_monthly
group by
    1

-- 5
select
    *
from
    revenue_monthly
where
    users < 1000
    or revenue_median < 500

-- 6
create table if not exists public.revenue_monthly_report (
    "month" date null,
    users int8 null,
    revenue_median numeric null,
    revenue_95 numeric null,
    revenue_max numeric null,
    revenue_total numeric null
)

-- 7
delete
from
    revenue_monthly_report
using
    revenue_monthly
where
    revenue_monthly_report."month" = revenue_monthly."month";

-- 8
insert into
    revenue_monthly_report
select
    *
from
    revenue_monthly

-- 9
select
    "month",
    count(*)
from
    revenue_monthly_report
group by
    1
having
    count(*) > 1
