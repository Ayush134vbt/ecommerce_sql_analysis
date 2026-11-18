--Q13: Which product categories generate the most revenue?
select
    coalesce(p.product_category_name, 'unknown') as category,
    round(sum(oi.price), 2) as revenue,
    round(100.0 * sum(oi.price) / sum(sum(oi.price)) over (), 2) as pct_of_total_revenue
from orders as o
inner join order_items as oi
    on o.order_id = oi.order_id
inner join products as p
    on oi.product_id = p.product_id
where o.order_status = 'delivered'
group by category
order by revenue desc
limit 10;
--Q13: beleza_saude (health & beauty) generates the most revenue (9.33% of total), followed by
--relogios_presentes (watches & gifts, 8.82%) and cama_mesa_banho (bed, table & bath, 7.74%).
--Within the top 10, brinquedos (toys) is lowest at 3.56%.

--Q14: Which product categories sell the most units?

select
    coalesce(p.product_category_name, 'unknown') as category,
    count(*) as units_sold,
    round(100.0 * count(*) / sum(count(*)) over (), 2) as pct_of_total_units
from orders as o
inner join order_items as oi
    on o.order_id = oi.order_id
inner join products as p
    on oi.product_id = p.product_id
where o.order_status = 'delivered'
group by category
order by units_sold desc
limit 10;

--Q14: cama_mesa_banho sells the most units (10,953, 9.94% of units) despite ranking third in revenue,
--so it is a high-volume, lower-priced category. relogios_presentes is the opposite: 2nd in revenue
--but 7th in units, which indicates a much higher average price (about 199 per unit).