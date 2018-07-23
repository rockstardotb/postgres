/* create the amenity table & apply regexp_split_to_table */

Create table amenity as select id as listing_id, regexp_split_to_table(amenities, ',') as amenity_name from listing;

/* apply regexp_replace */

Update amenity set amenity_name = regexp_replace(amenity_name,'{|}|"','','g');

/* add the primary key */

Alter table amenity add primary key(listing_id, amenity_name);

/* add the foreign key */

Alter table amenity add foreign key(listing_id) references listing(id);

/* Remove amenities from listing */

Alter table listing drop column amenities;


