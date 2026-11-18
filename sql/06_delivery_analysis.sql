--- Business Question 3: How long do deliveries take, and how often are orders late?

---3a: Average Delivery Time vs Estimate
select
    count(*) as delivered_orders,
    round(avg(extract(epoch from (order_delivered_customer_date - order_purchase_timestamp)) / 86400)::numeric, 1) as avg_days_to_deliver,
    round(avg(extract(epoch from (order_estimated_delivery_date - order_purchase_timestamp)) / 86400)::numeric, 1) as avg_days_estimated
from orders
where order_status = 'delivered'
  and order_delivered_customer_date is not null;

---3b: How many orders arrived late? 
select
    count(*) as delivered_orders,
    count(*) filter (where order_delivered_customer_date > order_estimated_delivery_date) as late_orders,
    round(100.0 * count(*) filter (where order_delivered_customer_date > order_estimated_delivery_date) / count(*), 2) as pct_late
from orders
where order_status = 'delivered'
  and order_delivered_customer_date is not null;


--- Q3: Of 96,470 delivered orders (excluding 8 with no delivery date), average delivery time
--- was 12.6 days vs an average estimate of 23.7 days. 7,826 orders (8.11%) arrived late.
--- Delivery is generally fast and estimates are conservative (about 11 days of buffer),
--- but roughly 1 in 12 orders still missed its estimate. Next: how late are the late orders?

select
    count(*) as late_orders,
    round(avg(extract(epoch from (order_delivered_customer_date - order_estimated_delivery_date)) / 86400)::numeric, 1) as avg_days_late,
    round(max(extract(epoch from (order_delivered_customer_date - order_estimated_delivery_date)) / 86400)::numeric, 1) as max_days_late
from orders
where order_status = 'delivered'
  and order_delivered_customer_date > order_estimated_delivery_date;

--- The late orders aren’t just slightly late. They average 9.6 days past the estimate, and the worst one is 189 days late. So the 8.11% is a real customer experience problem.