/* Index to speed-up the following query #1:
Select property_type, count(*), round(avg(price), 2)
From listing
Group by property_type
Having avg(price) < 300
Order by avg(price) desc;
*/
/* Note, sometimes it works better without index. */

create index listing_price_idx on listing(price);

/* Index to speed-up the following query #2:
Select id, price, count(*)
From listing l full join amenity a on l.id=a.listing_id
Where amenity_name = 'Gym' or amenity_name = 'Pool'
Group by id
<<<<<<< HEAD
Having price > 130 and price < 150
=======
Having price > 130 and price > 150
>>>>>>> 68981df3832564a8baa8794529212382e00d780d
Order by price asc;
*/

create index listing_price_idx on listing(price);
create index amenity_amenity_name on amenity(amenity_name);

/* Index to speed-up the following query #3:
Select id, date, l.price, bedrooms, beds
From listing l left join calendar c on l.id= c.listing_id
Where l.bedrooms >= '3' and l.beds >= '5' and date = '2018-02-24'
Group by id, date, l.price, l.bedrooms, l.beds
Having l.price >= 100 and l.price <= 300
Order by l.price asc;
*/

create index listing_bedrooms_beds_idx on listing(bedrooms, beds);

/* create the index for query 4 */
Create Index superhost_by_city on host(superhost, city);

/* create the index for query 5 */
Create Index review_scores on listing(review_scores_rating);
Create Index review_listing_id on review(id, listing_id);

/* create the index for query 6 */
/* Note, the followig index works best (better than w/out index),
   when enable_seqscan=on */
Create Index neighborhood_idx on listing(id, neighborhood);
