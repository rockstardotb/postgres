/* update street field in Listings */

alter table Listings add column street2 varchar(40);
update Listings set street2 = split_part(street, ',', 1);;

alter table Listings drop column street;
alter table Listings rename column street2 to street;

/* dollar signs and commas should be removed from the values
of the fields price, weekly_price, monthly_price,
security_deposit, and cleaning_fee.*/

alter table Listings add column price2 varchar(10);
UPDATE Listings SET price2 = REPLACE(price, '$', '');
UPDATE Listings SET price2 = REPLACE(price2, ',', '');
alter table Listings alter column price2 type numeric(10,2) using price2::numeric(10,2);
alter table Listings drop column price;
alter table Listings rename column price2 to price;

alter table Listings add column weekly_price2 varchar(10);
UPDATE Listings SET weekly_price2 = REPLACE(weekly_price, '$', '');
UPDATE Listings SET weekly_price2 = REPLACE(weekly_price2, ',', '');
alter table Listings alter column weekly_price2 type numeric(10,2) using weekly_price2::numeric(10,2);
alter table Listings drop column weekly_price;
alter table Listings rename column weekly_price2 to weekly_price;

alter table Listings add column monthly_price2 varchar(10);
UPDATE Listings SET monthly_price2 = REPLACE(monthly_price, '$', '');
UPDATE Listings SET monthly_price2 = REPLACE(monthly_price2, ',', '');
alter table Listings alter column monthly_price2 type numeric(10,2) using monthly_price2::numeric(10,2);
alter table Listings drop column monthly_price;
alter table Listings rename column monthly_price2 to monthly_price;

alter table Listings add column security_deposit2 varchar(10);
UPDATE Listings SET security_deposit2 = REPLACE(security_deposit, '$', '');
UPDATE Listings SET security_deposit2 = REPLACE(security_deposit2, ',', '');
alter table Listings alter column security_deposit2 type numeric(10,2) using security_deposit2::numeric(10,2);
alter table Listings drop column security_deposit;
alter table Listings rename column security_deposit2 to security_deposit;

alter table Listings add column cleaning_fee2 varchar(10);
UPDATE Listings SET cleaning_fee2 = REPLACE(cleaning_fee, '$', '');
UPDATE Listings SET cleaning_fee2 = REPLACE(cleaning_fee2, ',', '');
alter table Listings alter column cleaning_fee2 type numeric(10,2) using cleaning_fee2::numeric(10,2);
alter table Listings drop column cleaning_fee;
alter table Listings rename column cleaning_fee2 to cleaning_fee;
