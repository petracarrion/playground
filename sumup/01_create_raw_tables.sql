drop table raw_restaurants;
drop table raw_orders;

create table raw_restaurants
(
    id                text,
    currency          text,
    created_at        text,
    _fivetran_deleted text,
    language          text
);

create table raw_orders
(
    id                text,
    restaurant_id     text,
    status            text,
    is_printed        text,
    waiter_id         text,
    nb_customers      text,
    device_id         text,
    _fivetran_deleted text,
    cached_price      text,
    open_date         text,
    close_date        text
);

-- Copy CSV files to the raw tables