/* Assignment 2 - Introduction to Data Management */
/* Authors:            EID:           Section:
Aatheep Gurubaran    adg3966         MIS 381N Monday, Wednesday 3:30-5:00
Anthony Huang        ash3776
Branda Huang         yh23933
Daniel Shen          ms85344
Jonathan Jan         jj39582
Prashanti Kodi       pk9759 */


/* Drop statements */
ALTER TABLE customer_payment DROP CONSTRAINT payment_fk_customer;
ALTER TABLE reservation DROP CONSTRAINT reserve_fk_customer;
ALTER TABLE room DROP CONSTRAINT room_fk_location;
ALTER TABLE reservation_details DROP CONSTRAINT room_id_fk;
ALTER TABLE reservation_details DROP CONSTRAINT reservation_id_fk;
ALTER TABLE location_features_linking DROP CONSTRAINT location_features_pk1;
ALTER TABLE location_features_linking DROP CONSTRAINT location_features_pk2;
ALTER TABLE location_features_linking DROP CONSTRAINT location_features_pk3;

/* Dropping all the tables */


/* Creating the table with constraints */

/* Customer Table */
DROP TABLE customer;
DROP TABLE customer_payment;
DROP TABLE reservation;
DROP TABLE US_location;
DROP TABLE room;
DROP TABLE features;
DROP TABLE reservation_details;
DROP TABLE location_features_linking;

/* Dropping all the sequences */
DROP SEQUENCE customer_id_seq;
DROP SEQUENCE payment_id_seq;
DROP SEQUENCE reservation_id_seq;
DROP SEQUENCE room_id_seq;
DROP SEQUENCE location_id_seq;
DROP SEQUENCE feature_id_seq;

/* Dropping the indexes */
DROP INDEX customer_payment_cust_id_idx;
DROP INDEX reservation_cust_id_idx;
DROP INDEX room_loc_id_idx;
DROP INDEX reservation_confirm_num_idx;
DROP INDEX location_loc_name_idx;

/* Creating the sequences for primary keys */

/* Customer ID */
CREATE SEQUENCE customer_id_seq
  START WITH 100001;
  
/* Payment ID */
CREATE SEQUENCE payment_id_seq; 

/* Reservation ID */
CREATE SEQUENCE reservation_id_seq;

/* Room ID */
CREATE SEQUENCE room_id_seq;

/* Location ID */
CREATE SEQUENCE location_id_seq;

/* Feature ID */
CREATE SEQUENCE feature_id_seq;

/* Creating the table with constraints */

/* Customer Table */
CREATE TABLE customer
(
  customer_id       NUMBER     DEFAULT  customer_id_seq.NEXTVAL    CONSTRAINT customer_pk PRIMARY KEY, /* Specifying default value from sequence and primary key */
  first_name        VARCHAR2(30)    NOT NULL, 
  last_name    VARCHAR2(30)     NOT NULL,    
  email    VARCHAR2(50)     NOT NULL   UNIQUE   CONSTRAINT email_length_check   CHECK (LENGTH(email) >= 7), /* Specifying the length constraint for emails */
  phone    CHAR(12)     NOT NULL,   
  address_line_1    VARCHAR(100)     NOT NULL,
  address_line_2    VARCHAR(100),      
  city    VARCHAR2(40)     NOT NULL,   
  us_state    CHAR(2)     NOT NULL,   
  zip    CHAR(5)     NOT NULL,   
  birthdate    DATE,  
  stay_credits_earned    NUMBER(9)     DEFAULT 0   CONSTRAINT stay_credits_earned_ck   CHECK (stay_credits_earned >= 0), /* Specifying non-negativity constraint for credits earned */
  stay_credits_used    NUMBER(9)     DEFAULT 0   CONSTRAINT stay_credits_used_ck   CHECK (stay_credits_used >= 0), /* Specifying non-negativity and upper limit constraints for credits spent*/
  CONSTRAINT stay_credits_used_earned_ck CHECK (stay_credits_used <= stay_credits_earned)
);

/* Customer Payments Table */
CREATE TABLE customer_payment
(
  payment_id       NUMBER     DEFAULT  payment_id_seq.NEXTVAL     CONSTRAINT payment_pk PRIMARY KEY, /* Specifying default value from sequence and primary key */
  customer_id        NUMBER          CONSTRAINT payment_fk_customer REFERENCES customer (customer_id), /* Specifying reference to customer table for Customer ID */
  cardholder_first_name    VARCHAR2(30)     NOT NULL,    
  cardholder_mid_name    VARCHAR2(30), 
  cardholder_last_name    VARCHAR2(30)     NOT NULL,
  card_type    CHAR(4)     NOT NULL,
  card_number    CHAR(16)     NOT NULL,
  expiration_date    DATE     NOT NULL,
  cc_id    CHAR(3)     NOT NULL,
  billing_address    VARCHAR2(80)     NOT NULL,
  billing_city    VARCHAR2(40)     NOT NULL,
  billing_state    CHAR(2)     NOT NULL,
  billing_zip    CHAR(5)     NOT NULL
);

/* Reservations Table */
CREATE TABLE reservation
(
  reservation_id NUMBER DEFAULT reservation_id_seq.NEXTVAL CONSTRAINT reservation_pk PRIMARY KEY, /* Specifying default value from sequence and primary key */
  customer_id NUMBER CONSTRAINT reserve_fk_customer REFERENCES customer (customer_id), /* Specifying reference to customer table for Customer ID */
  confirmation_nbr CHAR(8) NOT NULL UNIQUE, /* Specifying that the confirmation number has a unique value */
  date_created DATE DEFAULT SYSDATE, /* Specifying the default value of a reservation to be the system date */
  check_in_date DATE NOT NULL,
  check_out_date DATE,
  status CHAR(1) NOT NULL,
  discount_code VARCHAR2(20),
  reservation_total NUMBER(9,2) NOT NULL,
  customer_rating NUMBER(1),
  notes VARCHAR2(300),
  CONSTRAINT status_ck CHECK (Status='U' or Status='I' or Status='C' or Status='N' or Status = 'R'), /* Specifying permissible values for status */
  CONSTRAINT customer_rating_ck  CHECK (customer_rating >= 0) /* Specifying non-negativity criteria for customer rating */
);

/* Locations Table */ 
CREATE TABLE us_location
(
  location_id NUMBER DEFAULT location_id_seq.NEXTVAL CONSTRAINT location_pk PRIMARY KEY, /* Specifying default value from sequence and primary key */
  location_name VARCHAR(40) NOT NULL UNIQUE, /* Specifying uniqueness of location name */
  address VARCHAR(50) NOT NULL,
  city VARCHAR(20) NOT NULL,
  us_state CHAR(2) NOT NULL,
  zip CHAR(5) NOT NULL,
  phone CHAR(12) NOT NULL,
  site_url VARCHAR(50) NOT NULL
);


/* Room Table */
CREATE TABLE room
(
  room_id NUMBER DEFAULT room_id_seq.NEXTVAL CONSTRAINT room_pk PRIMARY KEY, /* Specifying default value from sequence and primary key */
  location_id  NUMBER CONSTRAINT room_fk_location REFERENCES us_location (location_id), /* Specifying reference to location id from location table */ 
  floor CHAR(1) NOT NULL,  
  room_number VARCHAR2(4) NOT NULL,
  room_type CHAR(1) NOT NULL CONSTRAINT room_type_ck CHECK (room_type='D' or room_type='Q' or room_type='K' or room_type='S' or room_type = 'C'), /* Specifying permissible room types */
  square_footage NUMBER(9,2)     NOT NULL   CONSTRAINT square_footage_ck   CHECK (square_footage > 0), 
  max_people    NUMBER(2)     NOT NULL   CONSTRAINT max_people_ck   CHECK (max_people > 0), /* Specifying positivity of max occupants in room */
  weekday_rate    NUMBER(9,2)     NOT NULL   CONSTRAINT weekday_rate_ck   CHECK (weekday_rate > 0), /* Specifying positivity of room weekday rate */
  weekend_rate    NUMBER(9,2)     NOT NULL   CONSTRAINT weekend_rate_ck   CHECK (weekend_rate > 0) /* Specifying positivity of room weekend rate */
);

/* Features Table */
CREATE TABLE features
(
  features_ID NUMBER DEFAULT feature_id_seq.NEXTVAL CONSTRAINT feature_pk PRIMARY KEY, /* Specifying default value from sequence and primary key */
  feature_name VARCHAR2(40) NOT NULL UNIQUE /* Specifying uniqueness of feature name */
);

/* Reservation Details Table */
CREATE TABLE reservation_details
(
  reservation_id       NUMBER DEFAULT reservation_id_seq.NEXTVAL, /* Specifying default value from sequence */ 
  room_id        NUMBER,
  number_of_guests    NUMBER(2)     NOT NULL,
  /* Specifying table level constraints */
  CONSTRAINT reservation_room_id_pk   PRIMARY KEY (reservation_id, room_id), /* Specifying composite primary key */
  CONSTRAINT reservation_id_fk   FOREIGN KEY (reservation_id) REFERENCES reservation (reservation_id), /* Specifying reference to reservation id from reservation table */
  CONSTRAINT room_id_fk   FOREIGN KEY (room_id) REFERENCES room (room_id), /* Specifying reference to room id from room table */
  CONSTRAINT number_of_guests_ck   CHECK (number_of_guests > 0) /* Specifying positivity constraint for number of guests */
);

/* Join table for locations and features tables */ 
CREATE TABLE location_features_linking
(
  location_id NUMBER,
  features_id NUMBER,
  /* Specifying table level constraints */
  CONSTRAINT location_features_pk1 PRIMARY KEY (location_id, features_id), /* Specifying composite primary key */
  CONSTRAINT location_features_pk2 FOREIGN KEY (location_id) REFERENCES us_location (location_id), /* Specifying reference to location id from location table */
  CONSTRAINT location_features_pk3 FOREIGN KEY (features_id) REFERENCES features (features_id) /* Specifying reference to feature id from features table */
);

/* Creating the required indexes */
/* The foreign keys which are not a part of primary key as well, are as follows:
    1. Customer_payment table - customer_id
    2. Reservation table - customer_id
    3. Room table - location_id */

/* Customer_payment table */
CREATE UNIQUE INDEX customer_payment_cust_id_idx /* Because each customer has only 1 credit card associated with them */
  ON customer_payment (customer_id);


/* Reservation table */
CREATE INDEX reservation_cust_id_idx 
  ON reservation (customer_id);
  
/* Room table */
CREATE INDEX room_loc_id_idx 
  ON room (location_id);

/* Other indexes could be confirmation_nbr from reservation table and location_name from location table */
/*CREATE UNIQUE INDEX reservation_confirm_num_idx /* Because each reservation has only 1 confirmation number */
  /*ON reservation (confirmation_nbr); 
  
CREATE UNIQUE INDEX location_loc_name_idx /* Because each location will have a unique name 
  ON location (location_name);*/
  
/* Data Creation */

/* Location information in location table */
INSERT INTO us_location 
(location_id, location_name, address, city, us_state, zip, phone, site_url) 
VALUES (DEFAULT, 'The Sour Apple Hotel', 'South Congress', 'Austin', 'TX', '78704', '+11472341357', 'https://www.sourapplehotel.com');

INSERT INTO us_location 
(location_id, location_name, address, city, us_state, zip, phone, site_url) 
VALUES (DEFAULT, 'The East 7th Lofts', 'East 7th Street', 'Austin', 'TX', '78701', '+11234567890', 'https://www.east7thlofts.com');

INSERT INTO us_location 
(location_id, location_name, address, city, us_state, zip, phone, site_url) 
VALUES (DEFAULT, 'Balcones Canyonland Cabins', 'Ranch Rd', 'Marble Falls', 'TX', '78654', '+19876543210', 'https://www.balconescanyonlandscabins.com');

COMMIT;

/* Features in the features table */
INSERT INTO features
(features_id, feature_name)
  VALUES (DEFAULT, 'Lake View');
  
INSERT INTO features
(features_id, feature_name)
  VALUES (DEFAULT, 'Swimming Pool');
  
INSERT INTO features
(features_id, feature_name)
  VALUES (DEFAULT, 'Spa');

COMMIT;

/* Linking the features to the rooms */
/* Location 1 */
INSERT INTO location_features_linking
(location_id, features_id)
  VALUES (1, 2);

INSERT INTO location_features_linking
(location_id, features_id)
  VALUES (1, 3);

/* Location 2 */
INSERT INTO location_features_linking
(location_id, features_id)
  VALUES (2, 1);

/* Location 3 */
INSERT INTO location_features_linking
(location_id, features_id)
  VALUES (3, 1);
  
INSERT INTO location_features_linking
(location_id, features_id)
  VALUES (3, 3);

COMMIT;

/* Creating rooms for the locations */

/* Location 1 */
INSERT INTO room
(room_id, location_id, floor, room_number, room_type, square_footage, max_people, weekday_rate, weekend_rate)
  VALUES (DEFAULT, 1, 1, 101, 'K', 800, 6, 1000, 1200);

INSERT INTO room
(room_id, location_id, floor, room_number, room_type, square_footage, max_people, weekday_rate, weekend_rate)
  VALUES (DEFAULT, 1, 1, 102, 'Q', 700, 5, 800, 950);

/* Location 2 */
INSERT INTO room
(room_id, location_id, floor, room_number, room_type, square_footage, max_people, weekday_rate, weekend_rate)
  VALUES (DEFAULT, 2, 2, 201, 'D', 500, 4, 400, 500);

INSERT INTO room
(room_id, location_id, floor, room_number, room_type, square_footage, max_people, weekday_rate, weekend_rate)
  VALUES (DEFAULT, 2, 2, 202, 'S', 1000, 6, 1500, 1800);

/* Location 3 */
INSERT INTO room
(room_id, location_id, floor, room_number, room_type, square_footage, max_people, weekday_rate, weekend_rate)
  VALUES (DEFAULT, 3, 1, 101, 'C', 1500, 8, 2000, 2400);

INSERT INTO room
(room_id, location_id, floor, room_number, room_type, square_footage, max_people, weekday_rate, weekend_rate)
  VALUES (DEFAULT, 3, 1, 102, 'C', 1700, 8, 2200, 2500);

COMMIT;

/* Creating 2 customers */

/* Customer 1 */
INSERT INTO customer
(customer_id, first_name, last_name, email, phone, address_line_1, address_line_2, city, us_state, zip, birthdate, stay_credits_earned, stay_credits_used)
  VALUES (DEFAULT, 'Aatheep', 'Gurubaran', 'adg3966@utexas.edu', '+17378679388', 'Duval Villa Apartments', 'Apt 147', 'Austin', 'TX', '78751', '28-JUN-97', DEFAULT, DEFAULT);

/* Customer 2 */
INSERT INTO customer
(customer_id, first_name, last_name, email, phone, address_line_1, address_line_2, city, us_state, zip, birthdate, stay_credits_earned, stay_credits_used)
  VALUES (DEFAULT, 'Dwayne', 'Johnson', 'therock@gmail.com', '+11477147737', 'Rock Villa', 'Apt 777', 'Austin', 'TX', '78741', '2-MAY-72', 10000, 100);

COMMIT;

/* Creating credit card information for the customers */

/* Customer 1 */
INSERT INTO customer_payment
(payment_id, customer_id, cardholder_first_name, cardholder_mid_name, cardholder_last_name, card_type, card_number, expiration_date, cc_id, billing_address, billing_city, billing_state, billing_zip)
  VALUES (DEFAULT, 100001, 'Aatheep', 'D', 'Gurubaran', 'MSTR', '7147234135123456', '14-JUL-2025', '747', 'Duval Villa Apartments Apt 147', 'Austin', 'TX', '78751');

/* Customer 2 */
INSERT INTO customer_payment
(payment_id, customer_id, cardholder_first_name, cardholder_mid_name, cardholder_last_name, card_type, card_number, expiration_date, cc_id, billing_address, billing_city, billing_state, billing_zip)
  VALUES (DEFAULT, 100002, 'Dwayne', 'Rock', 'Johnson', 'AMEX', '9999999999999999', '18-SEP-2027', '135', 'Rock Villa', 'Austin', 'TX', '78741');

COMMIT;

/* Creating the reservations */

/* Customer 1 */
INSERT INTO reservation
(reservation_id, customer_id, confirmation_nbr, date_created, check_in_date, check_out_date, status, discount_code, reservation_total, customer_rating, notes)
  VALUES (DEFAULT, 100001, 71472222, '28-AUG-21', '7-SEP-21', '9-SEP-21', 'C', 'ADG147MNM234', 1100, 4, '');

/* Customer 2 */
INSERT INTO reservation
(reservation_id, customer_id, confirmation_nbr, date_created, check_in_date, check_out_date, status, discount_code, reservation_total, customer_rating, notes)
  VALUES (DEFAULT, 100002, 12345678, '12-SEP-21', '21-SEP-21', '28-SEP-21', 'C', '', 40000, 5, 'Loved the place');

INSERT INTO reservation
(reservation_id, customer_id, confirmation_nbr, date_created, check_in_date, check_out_date, status, discount_code, reservation_total, customer_rating, notes)
  VALUES (DEFAULT, 100002, 43210000, '2-OCT-21', '3-OCT-21', '15-OCT-21', 'I', '', 70000, '', '');

COMMIT;

/* Linking the rooms for the reservations */

/* Reservation 1 */
INSERT INTO reservation_details
(reservation_id, room_id, number_of_guests)
  VALUES (1, 3, 2);

/* Reservation 2 */
INSERT INTO reservation_details
(reservation_id, room_id, number_of_guests)
  VALUES (2, 1, 4);

INSERT INTO reservation_details
(reservation_id, room_id, number_of_guests)
  VALUES (2, 2, 4);

/* Reservation 3 */
INSERT INTO reservation_details
(reservation_id, room_id, number_of_guests)
  VALUES (3, 5, 8);

INSERT INTO reservation_details
(reservation_id, room_id, number_of_guests)
  VALUES (3, 6, 8);

COMMIT;
