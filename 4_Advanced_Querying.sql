/* Introduction to Data Management - Assignment 4 */

--Q1

select count(*) as count_of_customers,
    min(stay_credits_earned) as min_credits,
    max(stay_credits_earned) as max_credits
from customer;

--Q2

select customer_id, 
    count(*) as Number_of_Reservations,
    min(check_in_date) as earliest_check_in
from reservation
group by customer_id;

--Q3

select city, state,
    round(avg(stay_credits_earned)) as avg_credits_earned
from customer
group by city, state
order by state, avg_credits_earned DESC;

--Q4

select c.customer_id, c.last_name, rm.room_number, count(r.reservation_id) as stay_count
from customer c
    join reservation r on c.customer_id = r.customer_id
    join reservation_details rd on r.reservation_id = rd.reservation_id
    join room rm on rd.room_id = rm.room_id
where r.location_id = 1
group by c.customer_id, c.last_name, rm.room_number
order by c.customer_id, stay_count DESC;

--Q5

select c.customer_id, c.last_name, rm.room_number, count(r.reservation_id) as stay_count
from customer c
    join reservation r on c.customer_id = r.customer_id
    join reservation_details rd on r.reservation_id = rd.reservation_id
    join room rm on rd.room_id = rm.room_id
where r.location_id = 1 and r.status = 'C'
group by c.customer_id, c.last_name, rm.room_number
having count(r.reservation_id) > 2
order by c.customer_id, stay_count DESC;

--Q6
--(a)
select l.location_name, r.check_in_date, sum(r.number_of_guests) as Number_of_guests
from location l
    join reservation r on l.location_id = r.location_id
where r.check_in_date > sysdate
group by rollup (l.location_name, r.check_in_date);

--(b)
--ROLLUP operators extend the functionality of GROUP BY clauses by calculating subtotals and grand totals for a set of columns; 
--CUBE operators will calculate grand toals and generate subtotals for all combinations of grouping columns specified in the GROUP BY clauses
--In this question, ROLLUP will only return the subtotals grouping by location_name and the grand total.
--CUBE will return the subtotals grouping by location_name, the subtotals grouping by check_in_date, and the grand total.
--Those rows with null location_name and not null check_in_date allow us to check the subtotals for each check_in_date.
--CUBE is useful as it provies more information on subtotals than ROLLUP.
select l.location_name, r.check_in_date, sum(r.number_of_guests) as Number_of_guests
from location l
    join reservation r on l.location_id = r.location_id
where r.check_in_date > sysdate
group by cube (l.location_name, r.check_in_date);

--Q7

select f.feature_name, count(lf.location_id) as count_of_locations
from features f
    join location_features_linking lf on lf.feature_id = f.feature_id
group by f.feature_name
having count(lf.location_id) > 2;

--Q8

select customer_id, first_name, last_name, email
from customer  
where customer_id not in
    (select distinct customer_id
    from reservation);

--Q9

select first_name, last_name, email, phone, stay_credits_earned
from customer
where stay_credits_earned >
    (select avg(stay_credits_earned)
    from customer)
order by stay_credits_earned DESC;

--Q10
--(i)
select city, state, 
    sum(stay_credits_earned) as total_earned,
    sum(stay_credits_used) as total_used
from customer
group by city, state
order by city, state;

--(ii)
select city, state,
    total_earned - total_used as credits_remaining
from
    (select city, state, 
        sum(stay_credits_earned) as total_earned,
        sum(stay_credits_used) as total_used
    from customer
    group by city, state
    order by city, state)
order by credits_remaining DESC;

--Q11

select r.confirmation_nbr, r.date_created, r.check_in_date, r.status, rd.room_id
from reservation r
    join reservation_details rd on r.reservation_id = rd.reservation_id
where room_id in
    (select room_id
    from reservation_details
    group by room_id
    having count(room_id) < 5)
    and status != 'C';

--Q12

select cardholder_first_name, cardholder_last_name, card_number, expiration_date, cc_id
from customer_payment
where customer_id in 
    (select c.customer_id
    from customer c
        join reservation r on c.customer_id = r.customer_id
    where r.status = 'C'
    group by c.customer_id
    having count(r.reservation_id) = 1)
    and card_type = 'MSTR';

    
