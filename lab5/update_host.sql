/* The Host.response_rate field converted to a numeric type */

alter table Host add column response_rate2 varchar(10);
UPDATE Host SET response_rate2 = REPLACE(response_rate, '%', '');
UPDATE Host SET response_rate2 = REPLACE(response_rate2, 'N/A', NULL);
alter table Host alter column response_rate2 type numeric(10,2) using response_rate2::numeric(10,2);
alter table Host drop column response_rate;
alter table Host rename column response_rate2 to response_rate;

/* The Host.location field split into 3 fields:  Host.city,
Host.state, Host.country */

alter table Host add column city varchar(100);
alter table Host add column state varchar(50);
alter table Host add column country varchar(100);
UPDATE Host SET city = split_part(location, ',', 1);
UPDATE Host SET state = split_part(location,',',2);
UPDATE Host SET country = split_part(location, ',', 3);
alter table Host drop column location;


