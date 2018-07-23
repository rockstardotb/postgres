/* List places with ratings >= 90 made from 2017-01-01 to present*/

select l.id, l.price, l.review_scores_rating, r.date
from Listings l left join Reviews r on r.listing_id=l.id
join Summary_Reviews sr on r.date=sr.date
where sr.date >= '2017-01-01' and l.review_scores_rating >= '90'
order by l.review_scores_rating desc
limit 10;

/* List places with price < $150 available during 2017 SXSW*/

select l.id, l.price, c.date
from Listings l right join Calendar c on c.listing_id=l.id
where l.price::money::numeric::decimal(15,2) < '150' and c.date >= '2017-03-09' and c.date <= '2017-03-13'
order by l.price asc
limit 10; 


/* List places in austin, sorted by proximity in miles to downtown */

select l.id, l.price, SQRT(
    POW(69.1 * (s.latitude::float - 30.2729), 2) +
    POW(69.1 * (-97.7444 - s.longitude::float) * COS(s.latitude::float / 57.3), 2)) AS proximity
from Listings l left join Summary_Listings s on s.id=l.id
join Neighbourhoods n on n.neighbourhood=l.neighbourhood_cleansed::varchar::integer
where n.neighbourhood in ('78703','78756','78751','78705','78712','78701')
order by proximity asc
limit 10;

/* List places that allow pets*/

select l.id, l.price, l.neighbourhood
from Listings l
where l.house_rules like '%no pets%'
order by l.price asc
limit 10;

/* List places whose host as 2+ years of experience*/

select l.id, l.price, l.host_since
from Listings l
where l.host_since >= '2015-02-07'
order by l.host_since asc
limit 10;

/* List places with a minimum of 3 bedrooms in an entire home/apartment */

select l.id, l.price, l.bedrooms
from Listings l left join Summary_Listings sl on sl.id=l.id
where l.bedrooms >= '3' and sl.room_type='Entire home/apt'
order by l.price asc
limit 10;

/* List places that have a private room with real beds on 2018 Valentines day*/

Select l.id, l.price, c.date, l.room_type, l.bed_type
From Listings l right join Calendar c on l.id= c.listing_id
Where l.bed_type = 'Real Bed' and l.room_type = 'Private room' and c.date = '2018-02-14'
Order by l.price asc
Limit 10;


/* List places with security deposits < $100  and cleaning fee < $20*/

Select l.id, l.price, l.security_deposit, l.cleaning_fee
From Listings l
Where l.security_deposit::money::numeric::decimal(15,2) < '100' and l.cleaning_fee::money::numeric::decimal(15,2) < '20'
Order by l.price asc
Limit 10;


/* List places with cancellation was flexible during Winter Break*/

Select l.id, c.date, l.price, l.cancellation_policy
From Listings l right join Calendar c on l.id= c.listing_id
Where l.cancellation_policy = 'flexible' and c.date >= '2017-12-20' and c.date <= '2018-01-15'
Order by c.date
Limit 10;

/* List places where instant booking is allowed */

Select l.id, l.price, l.instant_bookable
From Listings l
Where l.instant_bookable = 't'
Order by l.price asc
Limit 10;

/* List places where fee for extra people <= $20 and the number of reviews >= 30 */

Select l.id, l.price, l.extra_people, sl.number_of_reviews
From Listings l join Summary_Listings sl on sl.id=l.id
Where l.extra_people::money::numeric::decimal(15,2) <= '20' and sl.number_of_reviews >= '30'
Order by sl.number_of_reviews desc
Limit 10;

/* List places of houses where I could have a graduation party on Feb, 2018 */

Select l.id, c.date, l.price, l.property_type
From Listings l join Calendar c on l.id= c.listing_id
Where l.property_type = 'House' and c.date >= '2018-02-01' and c.date < '2018-03-01'
Order by c.date
Limit 10;
