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

