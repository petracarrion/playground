drop view if exists orders;
drop view if exists valid_restaurants;
drop view if exists valid_orders;
drop table if exists restaurants;
drop table if exists all_orders;

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
    number_of_customers text,
    turnover            numeric(15, 2),
    order_date          date,
    order_timestamp     timestamp
);
insert into orders (order_id, restaurant_id, number_of_customers, turnover, order_date, order_timestamp)
select id,
       restaurant_id,
       nb_customers,
       cast(cached_price as numeric),
       cast(open_date as date),
       cast(open_date as timestamp)
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
