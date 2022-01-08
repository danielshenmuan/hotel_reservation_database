/* Introduction to Data Management - Assignment 5 */

--Q1
set serveroutput on;

--(i)
declare count_reservations number(9);
begin
    select count(customer_id) 
    into count_reservations
    from reservation 
    where customer_id = '100002';
    if count_reservations > 15 then 
        dbms_output.put_line('The customer has placed more than 15 reservations.');
    else
        dbms_output.put_line('The customer has placed 15 or fewer reservations.');
    end if;
end;
--(ii)
delete from reservation_details where reservation_id = 318;
delete from reservation where reservation_id = 318;
--(iii)
declare count_reservations number(9);
begin
    select count(customer_id) 
    into count_reservations
    from reservation 
    where customer_id = '100002';
    if count_reservations > 15 then 
        dbms_output.put_line('The customer has placed more than 15 reservations.');
    else
        dbms_output.put_line('The customer has placed 15 or fewer reservations.');
    end if;
end;
--(vi)
rollback;

--Q2
set define on;

declare 
    count_reservations number(9);
    customer_id_input number(9) := &customer_id;
begin
    select count(customer_id) 
    into count_reservations
    from reservation 
    where customer_id = customer_id_input;
    if count_reservations > 15 then 
        dbms_output.put_line('The customers with customer ID:' || customer_id_input ||', has placed more than 15 reservations.');
    else
        dbms_output.put_line('The customers with customer ID:' || customer_id_input ||', has placed 15 or fewer reservations.');
    end if;
end;

--Q3
declare 
    customer_id number := customer_id_seq.nextval;
    first_name varchar(30) := 'Daniel';
    last_name varchar(30) := 'Shen';
    email varchar(50) := 'muanshen@gmail.com';
    phone char(12) := '123-456-7890';
    address_line_1 varchar2(100) := '706 W 24th Street';
    city varchar(20) := 'Austin';
    c_state char(2) := 'TX';
    zip char(5) := '78705';
begin 
    insert into customer (customer_id, first_name, last_name, email, phone, address_line_1, city, state, zip)
    values (customer_id, first_name, last_name, email, phone, address_line_1, city, c_state, zip);
end;
commit;

--Q4
declare 
    type p_names_table  is table of varchar2(40);
    feature_names  p_names_table;
begin
    select feature_name 
    bulk collect into feature_names
    from features
    where feature_name like 'P%';
    
    for i in 1..feature_names.count loop
        dbms_output.put_line('Hotel feature'||i||': '||feature_names(i));
    end loop;
end;

--Q5
--(i)
declare 
    cursor lcf_cursor is 
        select l.location_name, l.city, f.feature_name
        from location l join location_features_linking lfl on l.location_id = lfl.location_id
                        join features f on f.feature_id = lfl.feature_id
        order by l.location_name,l.city,f.feature_name; 
    lcf_row location%rowtype;
begin
    for lcf_row in lcf_cursor loop
        dbms_output.put_line(lcf_row.location_name||' in '||lcf_row.city||' has feature: '||lcf_row.feature_name);
    end loop;
end;
--(bonus)
declare 
    city_input varchar(40):= '&city';
    
    cursor lcf_cursor is 
        select l.location_name, l.city, f.feature_name
        from location l join location_features_linking lfl on l.location_id = lfl.location_id
                        join features f on f.feature_id = lfl.feature_id
        where l.city = city_input
        order by l.location_name,f.feature_name; 
    lcf_row location%rowtype;
begin
    for lcf_row in lcf_cursor loop
        dbms_output.put_line(lcf_row.location_name||' in '||lcf_row.city||' has feature: '||lcf_row.feature_name);
    end loop;
end;


--Q6
create or replace procedure insert_customer
(
    first_name varchar,
    last_name varchar,
    email varchar,
    phone char,
    address_line_1 varchar2,
    city varchar,
    c_state char,
    zip char
)
as 
begin
    insert into customer (first_name, last_name, email, phone, address_line_1, city, state, zip)
    values (first_name, last_name, email, phone, address_line_1, city, c_state, zip);
end;

CALL insert_customer ('Joseph', 'Lee', 'jo12@yahoo.com', '773-222-3344', 'Happy street', 'Chicago', 'Il', '60602');
BEGIN
Insert_customer ('Mary', 'Lee', 'jo34@yahoo.com', '773-222-3344', 'Happy street', 'Chicago', 'Il', '60602');
END;

--Q7 
create or replace function hold_count
(
    customer_id_input number
)
return number
as 
    num_room_reserved number;
begin
    select count(reservation_id)
    into num_room_reserved
    from reservation
    where customer_id = customer_id_input;
    
    return num_room_reserved;
end;

select customer_id, hold_count(customer_id)  
from reservation
group by customer_id
order by customer_id;



