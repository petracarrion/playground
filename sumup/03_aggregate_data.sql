drop table if exists agg_orders;

create table agg_orders
(
    restaurant_id       text,
    order_date          date,
    turnover            numeric(15, 2),
    number_of_orders    integer,
    number_of_customers integer
);
insert into agg_orders (restaurant_id, order_date, turnover, number_of_orders, number_of_customers)
select restaurant_id,
       order_date,
       sum(turnover)              as turnover,
       count(number_of_customers) as number_of_orders,
       sum(number_of_customers)   as number_of_customers
from orders
group by restaurant_id, order_date;
