/* create a new calendar_summary table that summarizes the availability for a listings over 30, 60, and 90 days. */

Create table calendar_summary as select distinct id, calendar_updated, calendar_last_scraped, availability_30, availability_60, availability_90 from listings;


/* create backup for calendar_summary table. */

Create table calendar_summary_bkp as select * from calendar_summary;

/* rename the id to listings_id & calendar_last_scraped to from_date.*/

Alter table calendar_summary_bkp rename column id to listing_id;
Alter table calendar_summary_bkp rename column calendar_last_scraped to from_date;

/* add the primary key */

alter table calendar_summary_bkp add primary key(listing_id,from_date);


/* add the foreign key */

Alter table calendar_summary_bkp add foreign key(listing_id) references listings(id);

/* drop the fields from listings table with the exception of listing_id. */

Alter table listings drop column calendar_updated;
Alter table listings drop column calendar_last_scraped;
Alter table listings drop column availability_30;
Alter table listings drop column availability_60;
Alter table listings drop column availability_90;

