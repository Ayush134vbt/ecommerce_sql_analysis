
-- Q4:
-- What is the total product revenue from delivered orders?


SELECT
    o.order_id,
    o.order_status,
    oi.order_item_id,
    oi.product_id,
    oi.price
FROM orders AS o
INNER JOIN order_items AS oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
;


select
    round(sum(oi.price), 2) as total_product_revenue,
    count(distinct o.order_id) as delivered_orders,
    count(*) as items_sold
from orders as o
inner join order_items as oi
    on o.order_id = oi.order_id
where o.order_status = 'delivered';

--- Q4: Delivered orders generated 13,221,498.11 in product revenue (excluding shipping)
--- across 96,478 orders and 110,197 items. All delivered orders have at least one item.
--- Average order value is about 137.04, with about 1.14 items per order.


--- Q5: What is the average order value?
--- Average order value for delivered orders is 137.04 (total product revenue / delivered orders).
select
    round(sum(oi.price), 2) as total_product_revenue,
    count(distinct o.order_id) as delivered_orders,
    count(*) as items_sold,
    round(sum(oi.price) / count(distinct o.order_id), 2) as avg_order_value
from orders as o
inner join order_items as oi
    on o.order_id = oi.order_id
where o.order_status = 'delivered';

--- Q6: How does product revenue change by month?
select
    date_trunc('month', o.order_purchase_timestamp) as order_month,
    round(sum(oi.price), 2) as revenue,
    count(distinct o.order_id) as orders
from orders as o
inner join order_items as oi
    on o.order_id = oi.order_id
where o.order_status = 'delivered'
group by order_month
order by order_month;

--- Q6: Revenue grew rapidly through 2017 (about 112k in Jan to 607k in Sep), with a spike in Nov 2017
--- (987,765, +52% vs Oct, likely Black Friday). In 2018 revenue plateaued at about 826k-977k per month,
--- peaking in May 2018 (977,545). 2016 has very few orders (a launch period), and Nov 2016 has none.
--- Totals reconcile to Q4: 2016 = 40,471, 2017 = 5,962,902, 2018 (Jan-Aug) = 7,218,125.


-- Q7: How does revenue change month over month?

with monthly_sales as (
    select
        date_trunc('month', o.order_purchase_timestamp) as order_month,
        sum(oi.price) as revenue
    from orders as o
    inner join order_items as oi
        on o.order_id = oi.order_id
    where o.order_status = 'delivered'  and o.order_purchase_timestamp >= '2017-01-01'
    group by order_month
)

select
    order_month,
    round(revenue, 2) as revenue,
    round(lag(revenue) over (order by order_month), 2) as prev_month_revenue,
    round(revenue - lag(revenue) over (order by order_month), 2) as change_amount,
    round(100.0 * (revenue - lag(revenue) over (order by order_month))
          / lag(revenue) over (order by order_month), 2) as pct_change
from monthly_sales
order by order_month;

--- Q7: Month-over-month revenue (from Jan 2017, where data is continuous).
--- 2017 shows strong but uneven growth (e.g. +109.5% Feb, +52.4% Nov), with a −26.5% fall in Dec 2017
--- as the Nov spike reversed. In 2018 changes are small (mostly within ±15%) after a +27.4% rebound in Jan:
--- revenue peaked in May (977,545), dropped 12.4% in Jun, and has been flat to slightly down since.

-- Business Question 8:
-- Is revenue growth driven by order volume or average order value?

-- Q8: Is revenue growth driven by order volume or average order value?

with monthly_sales as (
    select
        date_trunc('month', o.order_purchase_timestamp) as order_month,
        sum(oi.price) as revenue,
        count(distinct o.order_id) as total_orders
    from orders as o
    inner join order_items as oi
        on o.order_id = oi.order_id
    where o.order_status = 'delivered'
      and o.order_purchase_timestamp >= '2017-01-01'
    group by order_month
)

select
    to_char(order_month, 'Mon YYYY') as order_month,
    round(revenue, 2) as revenue,
    total_orders,
    round(revenue / total_orders, 2) as avg_order_value
from monthly_sales
order by monthly_sales.order_month;

--- Q8: Revenue growth is driven by order volume, not average order value.
--- Jan 2017 to Aug 2018: orders rose about 8.5x (750 to 6,351) and revenue about 7.5x,
--- while AOV stayed in a narrow band of about 124-149 and drifted down about 11% (149 to 132).
--- The Nov 2017 spike was volume-led: orders +63% while AOV fell about 6%.
--- The 2018 plateau reflects flat order volume (about 6,000-7,000/month), not changes in basket size.