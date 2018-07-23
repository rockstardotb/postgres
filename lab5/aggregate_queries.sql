/* List property types, count them, and give average prices for each (2 decimal places).
Only include property_type which have average price < $300. */

Select property_type, count(*), round(avg(price), 2)
From listing 
Group by property_type
Having avg(price) < 300
Order by avg(price) desc;

/* List ids, $130 < price > $150, and count where gym or pool or both are in the amenities. */

Select id, price, count(*)
From listing l full join amenity a on l.id=a.listing_id
Where amenity_name = 'Gym' or amenity_name = 'Pool'
Group by id
Having price > 130 and price > 150
Order by price asc
Limit 10;   


/* List ids, give $100 <= price >= $300 where they have bedrooms >= 3 and beds >= 5, so that my family can have enough bedrooms and have their own beds */

Select id, date, l.price, bedrooms, beds
From listing l left join calendar c on l.id= c.listing_id
Where l.bedrooms >= '3' and l.beds >= '5' and date = '2018-02-24'
Group by id, date, l.price, l.bedrooms, l.beds
Having l.price >= 100 and l.price <= 300
Order by l.price asc
Limit 10;

/* List the number of superhosts by neighborhood in Austin, TX */

Select neighborhood, count(superhost)
From host
where superhost='t' and city='Austin' and neighborhood is not null
Group by neighborhood
Order by count(superhost) desc
limit 10;

/* List ids by number of reviews and review rating */

Select l.id, l.review_scores_rating, count(r.id)
from listing l join review r on l.id=r.listing_id
where l.review_scores_rating is not null
group by l.id
Having count(r.id)>200
order by l.review_scores_rating desc, count(r.id) desc
limit 10;

/* List the number of available places per neighborhood by date  */

Select l.neighborhood, c.date, count(c.*)
From listing l join calendar c on l.id=c.listing_id
group by l.neighborhood, c.date
order by c.date
limit 10;
