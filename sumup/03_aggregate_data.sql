drop table if exists agg_orders;

create table agg_orders
(
    order_date          date,
    restaurant_id       text,
    country             text,
    turnover            numeric(15, 2),
    number_of_orders    integer,
    number_of_customers integer
);
insert into agg_orders (order_date, restaurant_id, country, turnover, number_of_orders, number_of_customers)
select order_date,
       r.restaurant_id,
       country,
       sum(turnover)              as turnover,
       count(number_of_customers) as number_of_orders,
       sum(number_of_customers)   as number_of_customers
from orders
         left join restaurants r on orders.restaurant_id = r.restaurant_id
group by r.restaurant_id, country, order_date;
