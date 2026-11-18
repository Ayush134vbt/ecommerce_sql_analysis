--Q15: Which areas experience the highest delivery delays?

select
    c.customer_state,
    count(*) as delivered_orders,
    count(*) filter (where o.order_delivered_customer_date > o.order_estimated_delivery_date) as late_orders,
    round(100.0 * count(*) filter (where o.order_delivered_customer_date > o.order_estimated_delivery_date) / count(*), 2) as pct_late,
    round((avg(extract(epoch from (o.order_delivered_customer_date - o.order_estimated_delivery_date)) / 86400)
           filter (where o.order_delivered_customer_date > o.order_estimated_delivery_date))::numeric, 1) as avg_days_late
from orders as o
inner join customers as c
    on o.customer_id = c.customer_id
where o.order_status = 'delivered'
  and o.order_delivered_customer_date is not null
group by c.customer_state
order by pct_late desc;

--Q15: Delivery delays are worst in the Northeast: AL (23.9% late), MA (19.7%), PI (16.0%), CE (15.3%),
--SE (15.2%) and BA (14.0%), versus 5.9% in SP and 5.6% in MG. RJ is also high at 13.5% and, as the second
--largest market, has 1,664 late orders. SP and RJ together account for about 52% of all 7,826 late orders.
--Small states (RR, AP, AC; under 100 orders) have too few orders for reliable rates.

--Q16: How does delivery performance differ across locations?

select
    c.customer_state,
    count(*) as delivered_orders,
    round(avg(extract(epoch from (o.order_delivered_customer_date - o.order_purchase_timestamp)) / 86400)::numeric, 1) as avg_days_to_deliver,
    round(avg(extract(epoch from (o.order_estimated_delivery_date - o.order_purchase_timestamp)) / 86400)::numeric, 1) as avg_days_estimated,
    round(100.0 * count(*) filter (where o.order_delivered_customer_date > o.order_estimated_delivery_date) / count(*), 2) as pct_late
from orders as o
inner join customers as c
    on o.customer_id = c.customer_id
where o.order_status = 'delivered'
  and o.order_delivered_customer_date is not null
group by c.customer_state
order by avg_days_to_deliver desc;

--Q16: Delivery speed varies about 3x by state: SP is fastest (8.8 days), RR slowest (29.4), and speed
--worsens with distance from the South-East. Late rates depend more on estimate padding than speed: remote
--northern states (RR, AP, AM, AC, RO) are slow but have 17-20 day buffers and under 5% late, while Northeast
--states (AL, MA, SE) have only 8-9 day buffers and 15-24% late. RJ is an outlier: average speed similar to RS
--(15.3 days) but 13.5% late, which suggests inconsistent delivery times.
