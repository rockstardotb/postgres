/* create backup for table being changed and populate with desired data */

create table neighbourhood_bkp as select distinct neighbourhood, zipcode from listings;
alter table neighbourhood_bkp rename column neighbourhood to neighborhood_name;
delete from neighbourhood_bkp where neighborhood_name is null;
delete from neighbourhood_bkp where zipcode is null;

/* get rid of duplicate neighborhood_name, zipcode combos */

alter table neighbourhood_bkp add column neighborhood_name2 varchar(40);
alter table neighbourhood_bkp add column zipcode2 varchar(10);
update neighbourhood_bkp set neighborhood_name2=neighborhood_name;
update neighbourhood_bkp set zipcode2=zipcode;
alter table neighbourhood_bkp drop column neighborhood_name;
alter table neighbourhood_bkp drop column zipcode;
alter table neighbourhood_bkp rename column neighborhood_name2 to neighborhood_name;
alter table neighbourhood_bkp rename column zipcode2 to zipcode;

/* add primary key constraint */
alter table neighbourhood_bkp add primary key(neighborhood_name,zipcode);

/* remove nonprime attributes from Listings and Summary_Listings */

alter table Listings drop column neighbourhood_cleansed;
alter table Listings drop column neighbourhood_group_cleansed;
alter table Summary_Listings drop column neighbourhood_group;

/* drop the old Neighbourhoods table */

drop table Neighbourhoods;
alter table neighbourhood_bkp rename to Neighborhood;

/* alter column names in Listings */

alter table Listings rename column neighbourhood to neighborhood;
alter table Listings add FOREIGN KEY (neighborhood, zipcode) REFERENCES Neighborhood(neighborhood_name, zipcode);

/* alter the attribute named neighborhood in Summary_Listings */

alter table Summary_Listings rename column neighborhood to zipcode;
