create table Calendar(
   listing_id int,
   date date,
   available boolean,
   price varchar(20),
   primary key (listing_id, date)
);
