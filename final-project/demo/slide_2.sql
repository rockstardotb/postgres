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