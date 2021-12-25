drop table if exists restaurants;
drop table if exists orders;

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
