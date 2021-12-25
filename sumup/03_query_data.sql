select order_id, order_timestamp, turnover
from orders
where order_date = '2021-06-21'
order by order_timestamp desc
limit 1;

select restaurant_id, sum(turnover)
from orders
where order_date = '2021-06-21'
group by restaurant_id;

select country, sum(turnover)
from orders
         join restaurants r on orders.restaurant_id = r.restaurant_id
where order_date = '2021-06-21'
group by country;
