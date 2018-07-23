/* change data type of price to numeric */
alter table Calendar add column price2 varchar(10);
UPDATE Calendar SET price2 = REPLACE(price, '$', '');
UPDATE Calendar SET price2 = REPLACE(price2, ',', '');
alter table Calendar alter column price2 type numeric(10,2) using price2::numeric(10,2);
alter table Calendar drop column price;
alter table Calendar rename column price2 to price;
