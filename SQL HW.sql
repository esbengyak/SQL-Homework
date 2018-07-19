use sakila
select first_name, last_name 
from actor;

select CONCAT(first_name," ", last_name) as 'Actor Name' from actor;

SELECT actor_id, first_name, last_name FROM actor WHERE first_name = "Joe";

SELECT first_name, last_name FROM actor WHERE last_name like "%GEN%";

SELECT last_name,first_name FROM actor WHERE last_name like "%LI%" order by last_name, first_name;

SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh','China');

alter table actor add middle_name varchar(50);
#need to insert the column into the correct position but seems to be very difficult 
ALTER TABLE actor modify COLUMN middle_name blob;
alter table actor drop column middle_name;

select last_name, count(last_name) from actor group by last_name;

select last_name, count(last_name) from actor group by last_name having count(last_name) > 1;

UPDATE actor SET first_name='Harpo' WHERE first_name='Hapro' and last_name = 'Williams';
#i accidentally changed his name to HaPRO instead of HaRPO
select first_name, last_name, actor_id FROM actor where last_name = 'Williams' and first_name = 'Harpo';

 UPDATE actor
 SET first_name = 
 CASE 
 WHEN first_name = 'HARPO' 
 THEN 'GROUCHO'
 ELSE 'MUCHO GROUCHO'
 END
 WHERE actor_id = 172;
 
 
SHOW CREATE TABLE sakila.address;
#do i need to actually recreate the table?

#6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:

SELECT staff.first_name, staff.last_name, address.address 
FROM staff 
INNER JOIN address 
ON (staff.address_id = address.address_id);
# it doesn't return anything

#6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.

select s.first_name, s.last_name, sum(p.amount) from staff as s
inner join payment as p
on p.staff_id = s.staff_id
WHERE MONTH(p.payment_date) = 08 AND YEAR(p.payment_date) = 2005
group by s.staff_id;
#and again there is nothing here

#6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
SELECT f.title, COUNT(fa.actor_id) AS 'Actors'
FROM film_actor AS fa
INNER JOIN film as f
ON f.film_id = fa.film_id
GROUP BY f.title
ORDER BY Actors desc;

#6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT title, COUNT(inventory_id) AS 'Total copies'
FROM film
INNER JOIN inventory
USING (film_id)
WHERE title = 'Hunchback Impossible'
GROUP BY title;

#6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
select c.last_name, c.first_name, sum(p.amount) as 'Payment Amount'
from payment as p
join customer as c
on (p.customer_id = c.customer_id)
group by c.customer_id
order by c.last_name desc;

#7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
select title from film
where title like 'K%' or title like 'Q%'
and language_id in 
( 
select language_id
from language
where name = 'English'
);

#7b. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT first_name, last_name
FROM actor 
WHERE actor_id IN 
(
SELECT actor_id
FROM film_actor
WHERE film_id = 
(
SELECT film_id
FROM film
WHERE title = 'Alone Trip'
)
);

#7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT first_name, last_name, email, country
FROM customer cus
JOIN address a
ON (cus.address_id = a.address_id)
JOIN city cit
ON (a.city_id = cit.city_id)
JOIN country ctr
ON (cit.country_id = ctr.country_id)
WHERE ctr.country = 'canada';

#7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as famiy films.
select title, c.name
from film f
join film_category fc
on (f.film_id = fc. film_id)
join category c
on (c.category_id = fc.category_id)
where name = 'family';

#7e. Display the most frequently rented movies in descending order.

select title, count(title) as 'Rentals' 
from film
join inventory
on (film.film_id = inventory.film_id)
join rental
on (inventory.inventory_id = rental.inventory_id)
group by title
order by rentals desc; 

#7f. Write a query to display how much business, in dollars, each store brought in.
SELECT s.store_id, SUM(amount) AS Gross
FROM payment p
JOIN rental r
ON (p.rental_id = r.rental_id)
jOIN inventory i
ON (i.inventory_id = r.inventory_id)
JOIN store s
ON (s.store_id = i.store_id)
GROUP BY s.store_id;  
#nothing here

#7g. Write a query to display for each store its store ID, city, and country.

select store_id, city, country
from store s
join address a
on (s.address_id = a.address_id)
join city cit
on(cit.city_id = a.city_id)
join country ctr
on (cit.country_id = ctr.country_id)
#nothing here though

#7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

select sum(amount) as 'Total Revenue', c.name as 'Genre'
from payment p
join rental r
on (p.rental_id = r.rental_id)
join inventory i
on (r.inventory_id = i.inventory_id)
join film_category fc
on (i.film_id = fc.film_id)
join category c
on (fc.category_id = c.category_id)
group by c.name
order by sum(amount) desc
limit 5;

#create view
create view top_5_genres as 
select sum(amount) as 'Total Revenue', c.name as 'Genre'
from payment p
join rental r
on (p.rental_id = r.rental_id)
join inventory i
on (r.inventory_id = i.inventory_id)
join film_category fc
on (i.film_id = fc.film_id)
join category c
on (fc.category_id = c.category_id)
group by c.name
order by sum(amount) desc
limit 5;

select * from top_5_genres;

drop view top_5_genres;









