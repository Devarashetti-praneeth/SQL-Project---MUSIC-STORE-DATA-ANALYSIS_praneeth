create database project;

use project;


create table employee_table(
employee_id INT primary key,
last_name varchar(100),
first_name varchar(100),
title varchar(100),
reports_to int,
levels varchar(100),
birthdate varchar(100),
hire_date varchar(100),
address varchar(100),
city varchar(100),
state varchar(100), 
country varchar(100),
postal_code varchar(100),
phone varchar(100), 
fax varchar(100),
email varchar(100));

select* from employee_table;



create table customer_table(
customer_id INT primary key,
first_name varchar(100),
last_name varchar(100),
company varchar(100),
adress varchar(100),
city varchar(100),
state varchar(100),
country varchar(100),
postal_code varchar(100),
phone varchar(100),
fax varchar(100),
email varchar(100),
support_rep_id int not null,
FOREIGN KEY (support_rep_id)
REFERENCES employee_table (employee_id)  ON DELETE CASCADE ON UPDATE CASCADE);

select * from customer_table;

create table invoice_table(
invoice_id INT primary key,
customer_id int not null,
invoice_date varchar(100),
billing_address varchar(100),
billing_city varchar(100),
billing_state varchar(100),
billing_country varchar(100),
billing_postal_code varchar(100),
total float,
FOREIGN KEY (customer_id) 
references customer_table (customer_id) ON DELETE CASCADE ON UPDATE CASCADE );
select* from invoice_table;

create table invoice_line(
invoice_line_id int primary key,
invoice_id int not null,
track_id varchar(100),
unit_price varchar(100),
quantity varchar(100),
foreign key(invoice_id)
references invoice_table(invoice_id) on delete cascade on update cascade );
select*from invoice_line;

drop table track_table;
create table track_table(
track_id int primary key,
name varchar(100),
media_type_id int not null,
genre_id int not null,
album_id int not null,
composer varchar(100),
milliseconds int,
bytes int,
unit_price float,
foreign key(media_type_id)
references media_type_table(media_type_id) on delete cascade on update cascade,
foreign key(genre_id)
references genre_table(genre_id) on delete cascade on update cascade,
foreign key(album_id)
references album_table(album_id) on delete cascade on update cascade);
select*from track_table;
drop table playlist_table;
create table playlist_table(
playlist_id int primary key,
name varchar(100));
select*from playlist_table;
drop table playlist_track;
create table playlist_track(
playlist_id int not null,
track_id int not null,
foreign key (playlist_id)
references playlist_table (playlist_id) on delete cascade on update cascade,
foreign key(track_id)
references track_table(track_id) on delete cascade on update cascade);

select*from playlist_track;

create table media_type_table(
media_type_id int primary key,
name varchar(100));
select * from media_type_table;

create table genre_table(
genre_id int primary key,
name varchar(100));

select* from genre_table;


create table album_table(
album_id int primary key,
title varchar(100),
artist_id int not null,
foreign key(artist_id)
references artist_table (artist_id) on delete cascade on update cascade);

select *from album_table;


create  table artist_table(
artist_id int primary key,
name varchar(100));
select*from artist_table;

/----- Question Set 1 - Easy ----------/
/-- 1.Who is the senior most employee based on job title? --/ 
select *from employee_table;

select concat(first_name,'',last_name) as name ,title from employee_table
order by levels desc
limit 1;

select title
from employee_table
order by levels desc 
limit 1;

/-- 2.Which countries have the most Invoices?  --/
select*from invoice_table;

select billing_country from invoice_table
order by total desc
limit 5;


/-- 3.What are top 3 values of total invoice? --/
select total from invoice_table
order by total desc
limit 3;


/-- 4.Which city has the best customers? We would like to throw a promotional Music Festival in 
-- the city we made the most money. Write a query that returns one city that has the highest 
-- sum of invoice totals. Return both the city name & sum of all invoice totals --/
select*from customer_table;
select*from invoice_table;
select customer_table.city,sum(invoice_table.total) as max_total
from customer_table join invoice_table
on customer_table.customer_id=invoice_table.customer_id
group by city
order by max_total desc limit 1;

/-- 5. Who is the best customer? The customer who has spent the most money will be declared 
-- the best customer. Write a query that returns the person who has spent the most money --/

select customer_table.customer_id,concat(customer_table.first_name,' ',customer_table.last_name) as customer_name,sum(invoice_line.unit_price*invoice_line.quantity) as money_spent
from customer_table join invoice_table
on customer_table.customer_id=invoice_table.customer_id
join invoice_line 
on invoice_table.invoice_id=invoice_line.invoice_id
group by customer_id
order by money_spent desc limit 1;


/----- Question Set 2 – Moderate -----/

/-- 1. Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
/-- Return your list ordered alphabetically by email starting with A --/
select*from customer_table;
select*from invoice_table;
select*from genre_table;
select*from track_table;

select distinct customer_table.email,concat(customer_table.first_name,' ',customer_table.last_name) as person,genre_table.name
from customer_table join invoice_table
on customer_table.customer_id=invoice_table.customer_id
join invoice_line 
on invoice_table.invoice_id=invoice_line.invoice_id
join track_table
on invoice_line.track_id=track_table.track_id
join genre_table
on track_table.genre_id=genre_table.genre_id
where genre_table.name='rock' and customer_table.email like 'a%'
order by email asc;


-- 2. Let's invite the artists who have written the most rock music in our dataset. 
-- Write a query that returns the Artist name and total track count of the top 10 rock bands

select artist_table.name,artist_table.artist_id,count(*) as track_count
from artist_table join album_table
on artist_table.artist_id=album_table.artist_id
join track_table
on album_table.album_id=track_table.album_id
join genre_table
on track_table.genre_id=genre_table.genre_id
where genre_table.name='rock'
group by artist_table.artist_id
order by track_count desc limit 10;

/-- 3. Return all the track names that have a song length longer than the average song length. Return 
/-- the Name and Milliseconds for each track. Order by the song length with the longest songs listed first
select*from track_table;
select name,milliseconds
from track_table
where milliseconds>(select avg(milliseconds)from track_table)
order by milliseconds desc;

/------------ Question Set 3 – Advance -----------/

/-- 1. Find how much amount spent by each customer on artists? Write a query to return customer name,
/-- artist name and total spent

select concat(customer_table.first_name,' ',customer_table.last_name) as customer_name,artist_table.name,sum(invoice_line.unit_price*invoice_line.quantity) as total_spent
from customer_table join invoice_table
on customer_table.customer_id=invoice_table.customer_id
join invoice_line
on invoice_table.invoice_id=invoice_line.invoice_id
join track_table
on invoice_line.track_id=track_table.track_id
join album_table
on  album_table.album_id=track_table.album_id
join artist_table
on album_table.artist_id=artist_table.artist_id
group by customer_table.customer_id,artist_table.artist_id
order by total_spent desc;

/-- 2. We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre with the 
/-- highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where the maximum 
/-- number of purchases is shared return all Genres.

with table1 as(select genre_table.name as Popular_genre,customer_table.country,sum(invoice_line.quantity) as purchases
from customer_table join invoice_table
on customer_table.customer_id=invoice_table.customer_id
join invoice_line 
on invoice_table.invoice_id=invoice_line.invoice_id
join track_table
on invoice_line.track_id=track_table.track_id
join genre_table
on track_table.genre_id=genre_table.genre_id
group by genre_table.name,customer_table.country
order by customer_table.country ,purchases desc)
select country,coalesce(max(popular_genre),'unknown') as max_purchases from table1
group by country;

/-- 3. Write a query that determines the customer that has spent the most on music for each country. 
/-- Write a query that returns the country along with the top customer and how much they spent. For countries where the top amount 
/-- spent is shared, provide all customers who spent this amount.

with tablec as(select customer_table.country,concat(customer_table.first_name,' ',customer_table.last_name) as customer_name,sum(invoice_line.unit_price*invoice_line.quantity) as top_spent
from customer_table join invoice_table
on customer_table.customer_id=invoice_table.customer_id
join invoice_line 
on invoice_table.invoice_id=invoice_line.invoice_id
group by customer_table.customer_id, customer_table.country)
select country,customer_name,top_spent from tablec
where (country,top_spent) in (select country,max(top_spent) as max_spent from tablec group by country)
order by country;

