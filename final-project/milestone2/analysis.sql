/* Find the number of available places within a 2-mile radius from the center
   of downtown for each city on christmas of each year */
/* ANALYSIS OF RESULTS: Portland's number of available listings on christmas stay relatively constant each year while Texas and Nashville decrease and increase, respectively.
   One possible explanation is that in Portland, approximately the same number of people travel out of state for the christmas holiday, while more people in Texas are choosing
   to stay and, conversly, more people in Nashville are leaving */
select city, date, count(available) as available
from (
  select 'Austin' as city, ca.date, count(ca.available) as available, SQRT(POW(69.1 * (sa.latitude - 30.2672), 2) + POW(69.1 * (-97.7431 - sa.longitude) * COS(sa.latitude / 57.3), 2)) AS proximity
  from austin.Calendar ca left join austin.Summary_Listing sa on sa.id=ca.listing_id
  where ca.available=true and extract(day from ca.date)=25 and extract(month from ca.date)=12
  group by ca.date,proximity
  UNION ALL
  select 'Nashville' as city, cn.date, count(cn.available) as available, SQRT(POW(69.1 * (sn.latitude - 36.1627), 2) + POW(69.1 * (-86.7816 - sn.longitude) * COS(sn.latitude / 57.3), 2)) AS proximity
  from nashville.Calendar cn left join nashville.Summary_Listing sn on sn.id=cn.listing_id
  where cn.available=true and extract(day from cn.date)=25 and extract(month from cn.date)=12
  group by cn.date, proximity
  UNION ALL
  select 'Portland' as city, cp.date, count(cp.available) as available, SQRT(POW(69.1 * (sp.latitude - 45.5135), 2) + POW(69.1 * (-122.6801 - sp.longitude) * COS(sp.latitude / 57.3), 2)) AS proximity
  from portland.Calendar cp left join portland.Summary_Listing sp on sp.id=cp.listing_id
  where cp.available=true and extract(day from cp.date)=25 and extract(month from cp.date)=12
  group by cp.date, proximity
  )
where proximity <= 2
group by date, city
order by date asc;

/* Find the average price as a function of the locations proximity from
   the center of downtown for each city */
/* ANALYSIS OF RESULTS: With the exception of locations very close to downtown having noticeably higher rates, there is no apparent trend in price versus proximity to downtown for any 
   of the three cities.*/
select city, proximity, AVG(price) as price
from (
  select 'Austin' as city, la.price as price, SQRT(POW(69.1 * (sa.latitude - 30.2672), 2) + POW(69.1 * (-97.7431 - sa.longitude) * COS(sa.latitude / 57.3), 2)) AS proximity
  from austin.Listing la left join austin.Summary_Listing sa on sa.id=la.id
  join austin.Neighborhood na on na.zipcode=la.zipcode
  UNION ALL
  select 'Nashville' as city, ln.price as price, SQRT(POW(69.1 * (sn.latitude - 36.1627), 2) + POW(69.1 * (-86.7816 - sn.longitude) * COS(sn.latitude / 57.3), 2)) AS proximity
  from nashville.Listing ln left join nashville.Summary_Listing sn on sn.id=ln.id
  join nashville.Neighborhood nn on nn.zipcode=ln.zipcode
  UNION ALL
  select 'Portland' as city, lp.price as price, SQRT(POW(69.1 * (sp.latitude - 45.5135), 2) + POW(69.1 * (-122.6801 - sp.longitude) * COS(sp.latitude / 57.3), 2)) AS proximity
  from portland.Listing lp left join portland.Summary_Listing sp on sp.id=lp.id
  join portland.Neighborhood np on np.zipcode=lp.zipcode
  )
where proximity <= 10
group by proximity, city;

/* Find the average price of Houses for each city with gym or hot-tub provided */
/* ANALYSIS OF RESULTS: The average price of the house with gym or hot tub are both in order of Austin > Nashville > Portland. 
Also, the average prices for the hot tub is all higher than those of the gym for each city. */

select city, amenity, avg_price
from (
  select 'Austin' as city, al.property_type as type, round(avg(price), 2) as avg_price, amenity_name as amenity
  from austin.Listing al join austin.Amenity aa on al.id=aa.listing_id
  where al.property_type = 'House' and (aa.amenity_name = 'Gym' or aa.amenity_name = 'Hot tub')
  group by al.property_type, amenity_name
  UNION ALL
  select 'Nashville' as city, nl.property_type as type, round(avg(price), 2) as avg_price, amenity_name as amenity
  from nashville.Listing nl join nashville.Amenity na on nl.id=na.listing_id
  where nl.property_type = 'House' and (na.amenity_name = 'Gym' or na.amenity_name = 'Hot tub')
  group by nl.property_type, amenity_name
  UNION ALL
  select 'Portland' as city, pl.property_type as type, round(avg(price), 2) as avg_price, amenity_name as amenity
  from portland.Listing pl join portland.Amenity pa on pl.id=pa.listing_id
  where pl.property_type = 'House' and (pa.amenity_name = 'Gym' or pa.amenity_name = 'Hot tub')
  group by pl.property_type, amenity_name
)
group by city, amenity, avg_price
order by avg_price desc;


/* Find the count of review scores >= 95 for each city*/
/* ANALYSIS OF RESULTS: The count of the review scores >= 95 is mostly in order of Portland > Nashville > Austin, 
meaning that Portland has the highest counts of the hosts with higher review scores. 
One thing to notice is that Austin has more counts on review score 100 than those of Nashville. */

Select city, scores, count
from(
  Select 'Austin' as city, al.review_scores_rating as scores, count(ar.id) as count
  From austin.Listing al join austin.Review ar on al.id=ar.listing_id 
  where al.review_scores_rating is not null and al.review_scores_rating >= 95
  Group by review_scores_rating
  UNION ALL
  Select 'Nashville' as city, nl.review_scores_rating as scores, count(nr.id) as count
  From nashville.Listing nl join nashville.Review nr on nl.id=nr.listing_id 
  where nl.review_scores_rating is not null and nl.review_scores_rating >= 95
  Group by review_scores_rating
  UNION ALL
  Select 'Portland' as city, pl.review_scores_rating as scores, count(pr.id) as count
  From portland.Listing pl join portland.Review pr on pl.id=pr.listing_id 
  where pl.review_scores_rating is not null and pl.review_scores_rating >= 95
  Group by review_scores_rating
)
group by city, scores, count
