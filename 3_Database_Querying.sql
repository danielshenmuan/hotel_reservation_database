/* Introduction to Data Management - Assignment 3 */

--Q1

--(i)
select cardholder_first_name, cardholder_last_name, card_type, expiration_date
from customer_payment;

--(ii)
select cardholder_first_name, cardholder_last_name, card_type, expiration_date
from customer_payment
order by expiration_date;

--Q2
select first_name || ' ' || last_name as customer_full_name
from customer
  where substr(first_name, 1, 1) in ('A', 'B', 'C')
order by last_name desc;

--Q3
select customer_id, confirmation_nbr, date_created, check_in_date, number_of_guests
from reservation
  where status like 'U'
    and check_in_date >= sysdate
    and check_in_date <= '31-DEC-2021';


--Q4

--(i)
select customer_id, confirmation_nbr, date_created, check_in_date, number_of_guests
from reservation
  where status like 'U'
    and check_in_date between sysdate and '31-DEC-2021';

--(ii)
select *
from
(
  select customer_id, confirmation_nbr, date_created, check_in_date, number_of_guests
  from reservation
    where status like 'U'
      and check_in_date >= sysdate
      and check_in_date <= '31-DEC-2021'
)
  minus
(
  select customer_id, confirmation_nbr, date_created, check_in_date, number_of_guests
  from reservation
    where status like 'U'
      and check_in_date between sysdate and '31-DEC-2021'
);

--Q5

--(i)
select customer_id, location_id, check_out_date - check_in_date as length_of_stay
from reservation
  where status like 'C';

--(ii)
select customer_id, location_id, check_out_date - check_in_date as length_of_stay
from reservation
  where status like 'C'
  and rownum <=10;

--(iii)
select customer_id, location_id, check_out_date - check_in_date as length_of_stay
from reservation
  where status like 'C'
order by length_of_stay desc, customer_id;

--Q6
select * from
(
  select first_name, last_name, email, stay_credits_earned - stay_credits_used as credits_available
  from customer
)
  where credits_available >= 10   
order by credits_available;

--Q7
select cardholder_first_name, cardholder_mid_name, cardholder_last_name
from customer_payment
  where cardholder_mid_name is not null
order by 2, 3;

--Q8
select sysdate as today_unformatted, to_char(sysdate, 'MM/DD/YY') as today_formatted,
       25 as credits_earned, (25/10) as stays_earned, floor(25/10) as redeemable_stays,
       round(25/10) as next_stay_to_earn
from dual;

--Q9
select customer_id, location_id, check_out_date - check_in_date as length_of_stay
from reservation
  where status like 'C'
order by length_of_stay desc, customer_id
fetch first 20 rows only;

--Q10
select a.first_name, a.last_name, b.confirmation_nbr, b.date_created, b.check_in_date, b.check_out_date
from customer a
  inner join reservation b
    on a.customer_id = b.customer_id
  where status like 'C'
order by a.customer_id, b.check_out_date desc;


--Q11
select distinct a.first_name || ' ' || a.last_name as full_name, b.location_id, b.confirmation_nbr, b.check_in_date, d.room_number
from customer a
  inner join reservation b
    on a.customer_id = b.customer_id
  inner join reservation_details c
    on b.reservation_id = c.reservation_id
  inner join room d
    on c.room_id = d.room_id
  where b.status like 'U'
    and a.stay_credits_earned > 40;
    

--Q12
select a.first_name, a.last_name, b.confirmation_nbr, b.date_created, b.check_in_date, b.check_out_date
from customer a
  left join reservation b
    on a.customer_id = b.customer_id
  where a.customer_id not in
  (
    select distinct customer_id
    from reservation
  );

--Q13
select * from
(
  select '1-Gold Member' as status_level, first_name, last_name, email, stay_credits_earned
  from customer
    where stay_credits_earned < 10
  union
  select '2-Platinum Member' as status_level, first_name, last_name, email, stay_credits_earned
  from customer
    where stay_credits_earned between 10 and 40
  union
  select '3-Diamond Club' as status_level, first_name, last_name, email, stay_credits_earned
  from customer
    where stay_credits_earned > 40
)
order by 1, 3;
