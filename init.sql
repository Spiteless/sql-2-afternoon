-- ################################################################
--                             Joins
-- ################################################################

-- #1
-- Get all invoices where the unit_price
-- on the invoice_line is greater than $0.99.

select * from
invoice i
join invoice_line il on il.invoice_id = i.invoice_id

-- #2
-- Get the invoice_date, customer first_name and
-- last_name, and total from all invoices.

select i.invoice_date, c.first_name, c.last_name, i.total
from invoice i
join customer c on i.customer_id = c.customer_id

-- #3
-- Get the customer first_name and last_name and the support rep's
-- first_name and last_name from all customers.

select c.first_name, c.last_name, r.first_name, r.last_name
from customer c
join employee r on c.support_rep_id = r.employee_id;

-- #4
-- Get the album title and the artist name from all albums.

select cd.title, a.name
from album cd
join artist a on cd.artist_id = a.artist_id

-- #5
-- Get all playlist_track track_ids
-- where the playlist name is Music.

select pt.track_id
from playlist_track pt
join playlist p on p.playlist_id = pt.playlist_id
where p.name = 'Music';

-- #6
-- Get all track names for playlist_id 5.

select t.name
from track t
join playlist_track pt on pt.track_id = t.track_id
where t.track_id = 5

-- #7
-- Get all track names and
-- the playlist name that they're on ( 2 joins ).

select t.name, p.name
from track t
join playlist_track pt on pt.track_id = t.track_id
join playlist p on pt.playlist_id = p.playlist_id

-- #8
-- Get all track names and
-- album titles that are the genre Alternative & Punk ( 2 joins ).

select t.name, a.title
from track t
join album a on a.album_id = t.album_id
join genre g on g.genre_id = t.genre_id
where g.name = 'Alternative & Punk'

-- Black Diamond
-- Get all tracks on the playlist(s) called Music and show
-- their name, genre name, album name, and artist name.
-- 				At least 5 joins.

SELECT t.name, g.name, a.title, ar.name
from playlist p
join playlist_track pt on pt.playlist_id = p.playlist_id
join track t on pt.track_id = t.track_id
join genre g on g.genre_id = t.genre_id
join album a on a.album_id = t.album_id
join artist ar on ar.artist_id = a.artist_id
where p.name = 'Music'

-- ################################################################
--                        Nested Queries
-- ################################################################

-- #1. Get all invoices where the unit_price on the invoice_line is greater than $0.99.

SELECT *
FROM invoice
WHERE invoice_id IN ( SELECT invoice_id
    FROM invoice_line WHERE unit_price > .99 );

-- #2 Get all playlist tracks where the playlist name is Music.

select *
from playlist_track
where playlist_id in ( select playlist_id
                       from playlist p
                       where p.name = 'Music' )

-- #3 Get all track names for playlist_id 5.

SELECT name
FROM track
WHERE track_id IN ( SELECT track_id FROM playlist_track WHERE playlist_id = 5 )

-- #4 Get all tracks where the genre is Comedy.

select *
from track t
where t.genre_id in ( select genre_id
                       from genre g
                       where g.name = 'Comedy' )

-- #5 Get all tracks where the album is Fireball.

select *
from track t
where t.album_id in ( select album_id
                       from album a
                       where a.title = 'Fireball' )

-- #6 Get all tracks for the artist Queen ( 2 nested subqueries ).

select *
from track t
where t.album_id in
    (   select a.album_id
        from album a
        where a.artist_id in (  select ar.album_id
                                from artist ar
                                where ar.name = 'Queen' ) )

-- ################################################################
--                         Updating Rows
-- ################################################################

-- #1 Find all customers with fax numbers
-- and set those numbers to null.

update customer set fax = null

-- #2 Find all customers with no company
-- (null) and set their company to "Self".

update customer set company = 'self' where company = null

-- #3 Find the customer Julia Barnett and
-- change her last name to Thompson.

update customer set last_name = 'Thompson' where first_name = 'Julia' and last_name = 'Barnett'

-- #4 Find the customer with this email luisrojas@yahoo.cl
-- and change his support rep to 4.

update customer set support_rep_id = '4' where email = 'luisrojas@yahoo.cl'

-- #5 Find all tracks that are the genre Metal and
-- have no composer. Set the composer to "The darkness around us".

update track
set composer = 'The darkness around us'
WHERE genre_id = ( SELECT genre_id FROM genre WHERE name = 'Metal' )
and composer is null

-- #6 Refresh your page to remove all database changes.

update person_grading_this
set informed_about_page_reload = TRUE
returning *