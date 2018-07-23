/* create a new host table that stores distinct host records. */

Create table host as select distinct host_id, host_url, host_name, host_since, host_location, host_about, host_response_time, host_response_rate, host_acceptance_rate, host_is_superhost, host_thumbnail_url, host_picture_url, host_neighbourhood, host_listings_count, host_total_listings_count, host_verifications, host_has_profile_pic, host_identity_verified, calculated_host_listings_count from listings;

/* create backup for host table. */

Create table host_bkp as select * from host;

/* rename the host_bkp table: drop 'host_' prefix. */

Alter table host_bkp rename column host_id to id;
Alter table host_bkp rename column host_url to url;
Alter table host_bkp rename column host_name to name;
Alter table host_bkp rename column host_since to since;
Alter table host_bkp rename column host_location to location;
Alter table host_bkp rename column host_about to about;
Alter table host_bkp rename column host_response_time to response_time;
Alter table host_bkp rename column host_response_rate to response_rate;
Alter table host_bkp rename column host_acceptance_rate to acceptance_rate;
Alter table host_bkp rename column host_is_superhost to superhost;
Alter table host_bkp rename column host_thumbnail_url to thumbnail_url;
Alter table host_bkp rename column host_picture_url to picture_url;
Alter table host_bkp rename column host_neighbourhood to neighbourhood;
Alter table host_bkp rename column host_listings_count to listings_count;
Alter table host_bkp rename column host_total_listings_count to total_listings_count;
Alter table host_bkp rename column host_verifications to verifications;
Alter table host_bkp rename column host_has_profile_pic to has_profile_pic;
Alter table host_bkp rename column host_identity_verified to identity_verified;


/* drop the host fields from listings table with the exception of host_id. */

Alter table listings drop column host_url;
Alter table listings drop column host_name;
Alter table listings drop column host_since;
Alter table listings drop column host_location;
Alter table listings drop column host_about;
Alter table listings drop column host_response_time;
Alter table listings drop column host_response_rate;
Alter table listings drop column host_acceptance_rate;
Alter table listings drop column host_is_superhost;
Alter table listings drop column host_thumbnail_url;
Alter table listings drop column host_picture_url;
Alter table listings drop column host_neighbourhood;
Alter table listings drop column host_listings_count;
Alter table listings drop column host_total_listings_count;
Alter table listings drop column host_verifications;
Alter table listings drop column host_has_profile_pic;
Alter table listings drop column host_identity_verified;
Alter table listings drop column calculated_host_listings_count;

/* add the primary key */

Alter table host_bkp add primary key(id);

/* add the foreign key */

Alter table listings add foreign key(host_id) references host_bkp(id);
