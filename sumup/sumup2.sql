drop table if exists restaurants;
drop table if exists orders;
drop table if exists agg_orders;

create table restaurants
(
    restaurant_id text,
    created_at    timestamp,
    country       text
);
insert into restaurants (restaurant_id, created_at, country)
select id,
       cast(created_at as timestamp),
       case
           when language = 'es' then 'Spain'
           when language = 'fr' then 'France'
           else language
           end
from raw_restaurants
where _fivetran_deleted = 'FALSE';

create table orders
(
    order_id            text,
    restaurant_id       text,
    order_date          date,
    order_timestamp     timestamp,
    number_of_customers integer,
    turnover            numeric(15, 2)
);
insert into orders (order_id, restaurant_id, order_date, order_timestamp, number_of_customers, turnover)
select id,
       restaurant_id,
       cast(open_date as date),
       cast(open_date as timestamp),
       cast(nb_customers as integer),
       cast(cached_price as numeric)
from raw_orders
where _fivetran_deleted = 'FALSE'
  and status = 'CLOSED';


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