select * from orders
limit 10;


-- Busines Question 1: What portion of orders were succesfully delivered? 

--- Ordering based on total orders in descending order
select
    order_status,
    count(*) as total_orders,
    round(100.0 * count(*) / sum(count(*)) over (), 2) as pct_of_orders
from orders
group by order_status
order by total_orders desc;

---97.02% of recorded orders have a delivered status. Although this represents a high proportion, delivery timeliness must also be considered when evaluating operational performance.

--- Business Question 2: Are there missing values in the orders table?

select
    count(*)                                         as total_rows,
    count(*) - count(order_id)                       as null_order_id,
    count(*) - count(customer_id)                    as null_customer_id,
    count(*) - count(order_status)                   as null_order_status,
    count(*) - count(order_purchase_timestamp)       as null_purchase_ts,
    count(*) - count(order_approved_at)              as null_approved_at,
    count(*) - count(order_delivered_carrier_date)   as null_carrier_date,
    count(*) - count(order_delivered_customer_date)  as null_customer_date,
    count(*) - count(order_estimated_delivery_date)  as null_estimated_date
from orders;


select order_status,
       count(*) as total_orders,
       count(*) - count(order_approved_at)             as null_approved,
       count(*) - count(order_delivered_carrier_date)  as null_carrier,
       count(*) - count(order_delivered_customer_date) as null_customer
from orders
group by order_status
order by total_orders desc;

--- Out of 99,441 orders: order_approved_at has 160 nulls, order_delivered_carrier_date 1,783,
--- order_delivered_customer_date 2,965. No nulls in order_id, customer_id, order_status,
--- purchase timestamp or estimated delivery date.
--- Most nulls are expected, as they come from orders not yet shipped, delivered or approved (e.g. shipped, canceled, processing).
--- Data quality flags: delivered orders with missing dates (14 approval, 2 carrier, 8 customer delivery),
--- and 6 canceled orders with a customer delivery date. These are small, but the 8 delivered orders
--- without a delivery date will need excluding from delivery time analysis.



-- Check for duplicated order IDs
SELECT
    order_id,
    COUNT(*) AS occurrences
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;
