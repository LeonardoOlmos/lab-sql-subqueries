-- Leonardo Olmos Saucedo / SQL Subqueries lab
-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?
select COUNT(distinct I.INVENTORY_ID) as TOTAL_COPIES
from FILM F 
join INVENTORY I 
on F.FILM_ID = I.FILM_ID 
where lower(F.TITLE) = 'hunchback Impossible';

select COUNT(*) as COPIES
from INVENTORY I 
where I.FILM_ID = (
	select F.FILM_ID 
	from FILM F 
	where LOWER(F.TITLE) = 'hunchback impossible');

-- 2. List all films whose length is longer than the average of all the films.
select F.FILM_ID, F.TITLE, F.`length` as `LENGTH`
from FILM F 
where F.`length` > (
	select AVG(F.`length`) as `LENGTH` 
	from FILM F
)
order by 1;

-- 3. Use subqueries to display all actors who appear in the film Alone Trip.
select A.ACTOR_ID, CONCAT(A.FIRST_NAME, ' ', A.LAST_NAME) as NAME
from ACTOR A 
join FILM_ACTOR FA 
on A.ACTOR_ID = FA.ACTOR_ID 
where FA.FILM_ID = (
	select F.FILM_ID 
	from FILM F 
	where LOWER(F.TITLE) = 'alone trip');

-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
select F.FILM_ID, F.TITLE 
from FILM F 
join FILM_CATEGORY FC 
on F.FILM_ID = FC.FILM_ID 
where FC.CATEGORY_ID = (
	select C.CATEGORY_ID 
	from CATEGORY C 
	where LOWER(C.NAME) = 'family');

/* 5. Get name and email from customers from Canada using subqueries. 
 * Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
*/
select * 
from CUSTOMER C 
where C.ADDRESS_ID in (
	select A.ADDRESS_ID 
	from ADDRESS A 
	join CITY C 
	on A.CITY_ID = C.CITY_ID 
	join COUNTRY C2 
	on C.COUNTRY_ID = C2.COUNTRY_ID 
	where LOWER(C2.COUNTRY)  = 'canada')
order by 1;

select CU.*
from CUSTOMER CU
join ADDRESS A 
on CU.ADDRESS_ID = A.ADDRESS_ID 	
join CITY C 
on A.CITY_ID = C.CITY_ID 
join COUNTRY C2 
on C.COUNTRY_ID = C2.COUNTRY_ID 
where LOWER(C2.COUNTRY)  = 'canada'
order by 1;

/* 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. 
 * First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
*/
select F.FILM_ID, F.TITLE, FA.ACTOR_ID, CONCAT(A.FIRST_NAME, ' ', A.LAST_NAME) as NAME
from FILM F 
join FILM_ACTOR FA 
on F.FILM_ID = FA.FILM_ID 
join ACTOR A 
on FA.ACTOR_ID = A.ACTOR_ID 
where FA.ACTOR_ID = (
	select FA.ACTOR_ID
	from FILM_ACTOR FA 
	group by FA.ACTOR_ID
	order by COUNT(FA.FILM_ID) desc 
	limit 1);

-- 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
select distinct F.FILM_ID, F.TITLE, R.CUSTOMER_ID 
from RENTAL R 
join INVENTORY I 
on R.INVENTORY_ID = I.INVENTORY_ID 
join FILM F 
on I.FILM_ID = F.FILM_ID 
where R.CUSTOMER_ID = (
	select C.CUSTOMER_ID
	from CUSTOMER C 
	join PAYMENT P 
	on C.CUSTOMER_ID = P.CUSTOMER_ID 
	group by C.CUSTOMER_ID 
	order by SUM(P.AMOUNT) desc 
	limit 1)
order by 1;

-- 8. Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.
select C.CUSTOMER_ID, SUM(P.AMOUNT) as TOTAL_AMOUNT
from CUSTOMER C 
join PAYMENT P 
on C.CUSTOMER_ID = P.CUSTOMER_ID	
group by C.CUSTOMER_ID
having SUM(P.AMOUNT) > (
	select AVG(S1.TOTAL_AMOUNT) as AVG_AMOUNT 
	from (
		select C.CUSTOMER_ID, SUM(P.AMOUNT) as TOTAL_AMOUNT
		from CUSTOMER C 
		join PAYMENT P 
		on C.CUSTOMER_ID = P.CUSTOMER_ID
		group by C.CUSTOMER_ID) as S1);

