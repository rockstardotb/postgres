select date, zipcode, bedrooms, airbnb_price_day, zillow_price_month, max(zillow_price_month/airbnb_price_day) as crossover_pt
from(
    select date, zipcode, bedrooms, percentile_cont(airbnb_price,0.5 IGNORE NULLS) Over(partition by zipcode) as airbnb_price_day, zillow_price_month
    from(
          select date_trunc(c.date, MONTH) as date, l.zipcode as zipcode, l.bedrooms as bedrooms,
          Case
            When c.price is null then l.price
            Else c.price
          End
          as airbnb_price, zillow_price_month
          from austin.Listing l join austin.Calendar c on l.id=c.listing_id 
          join (
          /* one bedroom */
          select z.date as date, z.zipcode as zipcode, z.price as zillow_price_month, 1 as bedrooms
          from zillow.Rental_Price_1Bedroom z
          UNION ALL
          /* two bedroom */
          select z.date as date, z.zipcode as zipcode, z.price as zillow_price_month, 2 as bedrooms
          from zillow.Rental_Price_2Bedroom z
          UNION ALL
          /* three bedroom */
          select z.date as date, z.zipcode as zipcode, z.price as zillow_price_month, 3 as bedrooms
          from zillow.Rental_Price_3Bedroom z
          UNION ALL
          /* four bedroom */
          select z.date as date, z.zipcode as zipcode, z.price as zillow_price_month, 4 as bedrooms
          from zillow.Rental_Price_4Bedroom z
          UNION ALL
          /* five or  more */
          select z.date as date, z.zipcode as zipcode, z.price as zillow_price_month, 5 as bedrooms
          from zillow.Rental_Price_5BedroomOrMore z 
          ) z on l.zipcode=z.zipcode
       where l.room_type = 'Entire home/apt' and l.bedrooms > 0 and l.zipcode is not null and l.bedrooms is not null and c.date is not null
       group by zipcode, date, bedrooms, airbnb_price, zillow_price_month
       )
     )
where airbnb_price_day is not null and zillow_price_month is not null
Group by date, zipcode, bedrooms, airbnb_price_day, zillow_price_month;
