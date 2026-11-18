---Q9: How many unique customers have placed orders?

select count(distinct c.customer_unique_id) as unique_customers
from orders as o
inner join customers as c
    on o.customer_id = c.customer_id;

--- Q9: 96,096 unique customers have placed an order (out of 99,441 orders).

---Q10: What percentage of customers make repeat purchases?
with customer_orders as (
    select
        c.customer_unique_id,
        count(distinct o.order_id) as order_count
    from orders as o
    inner join customers as c
        on o.customer_id = c.customer_id
    group by c.customer_unique_id
)
select
    count(*) as total_customers,
    count(*) filter (where order_count > 1) as repeat_customers,
    round(100.0 * count(*) filter (where order_count > 1) / count(*), 2) as pct_repeat
from customer_orders;

--- Q10: Only 3.12% of customers made a repeat purchase. Almost all customers buy once,
--- so growth depends on acquiring new customers rather than retaining existing ones.

-- Q11: Which customers contribute the most revenue?

select
    c.customer_unique_id,
    count(distinct o.order_id) as orders,
    round(sum(oi.price), 2) as revenue,
    round(100.0 * sum(oi.price) / sum(sum(oi.price)) over (), 4) as pct_of_total_revenue
from orders as o
inner join customers as c
    on o.customer_id = c.customer_id
inner join order_items as oi
    on o.order_id = oi.order_id
where o.order_status = 'delivered'
group by c.customer_unique_id
order by revenue desc
limit 10;
--- Q11: Revenue is very evenly spread. The top customer contributes only 0.10% of total
--- revenue and the top 10 together about 0.51%, so there is no dependence on a few big spenders.


--Q12: How has the number of purchasing customers changed over time?

select
    date_trunc('month', o.order_purchase_timestamp) as order_month,
    count(distinct c.customer_unique_id) as purchasing_customers
from orders as o
inner join customers as c
    on o.customer_id = c.customer_id
where o.order_purchase_timestamp >= '2017-01-01'
group by order_month
order by order_month;

--- Q12: Purchasing customers grew from 765 (Jan 2017) to a peak of 7,430 (Nov 2017),
--- then plateaued at about 6,100-7,200/month through Aug 2018. The near-zero counts in
--- Sep (14) and Oct (4) 2018 reflect the dataset ending in Aug 2018, not a real decline.