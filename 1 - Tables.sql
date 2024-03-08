DROP SCHEMA DB1;
CREATE DATABASE DB1;
USE DB1;

CREATE TABLE CUSTOMER
(Customer_id			INT     		NOT NULL,
Customer_name			VARCHAR(50)   	NOT NULL,
Phone           		VARCHAR(10)   	NOT NULL,
PRIMARY KEY (Customer_id));

CREATE TABLE SEARCH_HISTORY
(Customer_id			INT     		NOT NULL,
Search          		VARCHAR(255)  	NOT NULL,
PRIMARY KEY (Customer_id, Search),
FOREIGN KEY (Customer_id) REFERENCES CUSTOMER(Customer_id) ON UPDATE CASCADE ON DELETE CASCADE);

CREATE TABLE PREFERENCE_LOG
(Customer_id			INT     		NOT NULL,
Preference      		VARCHAR(255)  	NOT NULL,
PRIMARY KEY (Customer_id, Preference),
FOREIGN KEY (Customer_id) REFERENCES CUSTOMER(Customer_id) ON UPDATE CASCADE ON DELETE CASCADE);

CREATE TABLE TRANSPORTATION_HISTORY
(Customer_id			INT     		NOT NULL,
Transportation  		VARCHAR(255)  	NOT NULL,
PRIMARY KEY (Customer_id, Transportation),
FOREIGN KEY (Customer_id) REFERENCES CUSTOMER(Customer_id) ON UPDATE CASCADE ON DELETE CASCADE);



CREATE TABLE TERMINAL
(Terminal_code			VARCHAR(50)		NOT NULL,
Terminal_name	 		VARCHAR(255)	NOT NULL,
Location				VARCHAR(255)	NOT NULL,
PRIMARY KEY (Terminal_code));

CREATE TABLE SCHEDULED_TRIPS
(Trip_code				VARCHAR(50)		NOT NULL,
Dep_terminal_code 		VARCHAR(50)		NOT NULL,
Dep_date				DATE	        CHECK	(Dep_date >= '2024-01-01' AND Dep_date <= '2024-03-31'),
Arr_terminal_code		VARCHAR(50)		NOT NULL,
Arr_date				DATE	        CHECK	(Arr_date >= '2024-01-01' AND Arr_date <= '2024-03-31'),
PRIMARY KEY (Trip_code),
FOREIGN KEY (Dep_terminal_code) REFERENCES TERMINAL(Terminal_code) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (Arr_terminal_code) REFERENCES TERMINAL(Terminal_code) ON UPDATE CASCADE ON DELETE CASCADE);

CREATE TABLE FARE
(Trip_code				VARCHAR(50)		NOT NULL,
Fare_code	 			VARCHAR(50)		NOT NULL		CHECK	(Fare_code IN ('Child', 'Student', 'Adult', 'Elderly')),
Amount					INT				NOT NULL		CHECK	(Amount > 0),
PRIMARY KEY (Trip_code, Fare_code),
FOREIGN KEY (Trip_code) REFERENCES SCHEDULED_TRIPS(Trip_code) ON UPDATE CASCADE ON DELETE CASCADE);

CREATE TABLE VEHICLE
(Vehicle_id						VARCHAR(50)		NOT NULL,
Seat_capacity					INT             NOT NULL,
PRIMARY KEY (Vehicle_id));

CREATE TABLE TRIP_INSTANCE
(Trip_code								VARCHAR(50)		NOT NULL,
Trip_date	 							TIME			NOT NULL,
Available_seats							INT				NOT NULL		DEFAULT 0,
Available_beds							INT				NOT NULL		DEFAULT 0,
Available_vehicle_carrying_capacity		INT				NOT NULL		DEFAULT 0,
Vehicle_id								VARCHAR(50)		NOT NULL,
PRIMARY KEY (Trip_code, Trip_date),
FOREIGN KEY (Trip_code) REFERENCES SCHEDULED_TRIPS(Trip_code) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (Vehicle_id) REFERENCES VEHICLE(Vehicle_id) ON UPDATE CASCADE ON DELETE CASCADE);

CREATE TABLE SEAT
(Trip_code								VARCHAR(50)		NOT NULL,
Trip_date	 							TIME			NOT NULL,
Seat_number								INT             NOT NULL		DEFAULT 0,
Seat_type								VARCHAR(50)		NOT NULL		DEFAULT "None",
PRIMARY KEY (Trip_code, Trip_date, Seat_number, Seat_type),
FOREIGN KEY (Trip_code) REFERENCES SCHEDULED_TRIPS(Trip_code) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (Trip_code, Trip_date) REFERENCES TRIP_INSTANCE(Trip_code, Trip_date) ON UPDATE CASCADE ON DELETE CASCADE);

CREATE TABLE RESERVATION
(Trip_code								VARCHAR(50)		NOT NULL,
Trip_date	 							TIME			NOT NULL,
Seat_number								INT             NOT NULL		DEFAULT 0,
Seat_type								VARCHAR(50)		NOT NULL		DEFAULT "None",
Customer_id								INT     		NOT NULL,
PRIMARY KEY (Trip_code, Trip_date, Seat_number, Seat_type, Customer_id),
FOREIGN KEY (Customer_id) REFERENCES CUSTOMER(Customer_id) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (Trip_code) REFERENCES SCHEDULED_TRIPS(Trip_code) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (Trip_code, Trip_date) REFERENCES TRIP_INSTANCE(Trip_code, Trip_date) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (Trip_code, Trip_date, Seat_number, Seat_type) REFERENCES SEAT(Trip_code, Trip_date, Seat_number, Seat_type) ON UPDATE CASCADE ON DELETE CASCADE);



CREATE TABLE AIRPLANE
(Vehicle_id						VARCHAR(50)		NOT NULL,
Aircraft_type					VARCHAR(50)		NOT NULL,
PRIMARY KEY (Vehicle_id),
FOREIGN KEY (Vehicle_id) REFERENCES VEHICLE(Vehicle_id) ON UPDATE CASCADE ON DELETE CASCADE);

CREATE TABLE SHIP
(Vehicle_id						VARCHAR(50)		NOT NULL,
Ship_type						VARCHAR(50)		NOT NULL,
Vehicle_carrying_capacity		INT				NOT NULL		DEFAULT 0,
PRIMARY KEY (Vehicle_id),
FOREIGN KEY (Vehicle_id) REFERENCES VEHICLE(Vehicle_id) ON UPDATE CASCADE ON DELETE CASCADE);

CREATE TABLE TRAIN
(Vehicle_id						VARCHAR(50)		NOT NULL,
Train_type						VARCHAR(50)		NOT NULL,
Bed_capacity					INT				NOT NULL		DEFAULT 0,
PRIMARY KEY (Vehicle_id),
FOREIGN KEY (Vehicle_id) REFERENCES VEHICLE(Vehicle_id) ON UPDATE CASCADE ON DELETE CASCADE);

CREATE TABLE BUS
(Vehicle_id						VARCHAR(50)		NOT NULL,
Bus_type						VARCHAR(50)		NOT NULL,
PRIMARY KEY (Vehicle_id),
FOREIGN KEY (Vehicle_id) REFERENCES VEHICLE(Vehicle_id) ON UPDATE CASCADE ON DELETE CASCADE);



CREATE TABLE RENTAL_LOCATION
(Address						VARCHAR(255)	NOT NULL,
PRIMARY KEY (Address));

CREATE TABLE RENTAL_INSTANCE
(Rental_code					VARCHAR(50)		NOT NULL,
Pick_up_address					VARCHAR(255)	NOT NULL,
Pick_up_date					DATETIME		NOT NULL	CHECK	(Pick_up_date >= '2024-01-01' AND Pick_up_date <= '2024-03-31'),
Drop_off_address				VARCHAR(255)	NOT NULL,
Drop_off_date					DATETIME		NOT NULL	CHECK	(Drop_off_date >= '2024-01-01' AND Drop_off_date <= '2024-03-31'),
PRIMARY KEY (Rental_code),
FOREIGN KEY (Pick_up_address) REFERENCES RENTAL_LOCATION(Address) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (Drop_off_address) REFERENCES RENTAL_LOCATION(Address) ON UPDATE CASCADE ON DELETE CASCADE);

CREATE TABLE RVEHICLE
(RVehicle_id					VARCHAR(50)		NOT NULL,
Price							INT				NOT NULL	CHECK	(Price > 0),
PRIMARY KEY (RVehicle_id));

CREATE TABLE RENTAL
(Rental_code					VARCHAR(50)		NOT NULL,
RVehicle_id						VARCHAR(50)		NOT NULL,
Customer_id						INT     		NOT NULL,
PRIMARY KEY (Rental_code, RVehicle_id, Customer_id),
FOREIGN KEY (Customer_id) REFERENCES CUSTOMER(Customer_id) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (Rental_code) REFERENCES RENTAL_INSTANCE(Rental_code) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (RVehicle_id) REFERENCES RVEHICLE(RVehicle_id) ON UPDATE CASCADE ON DELETE CASCADE);

CREATE TABLE MICROMOBILITY
(RVehicle_id					VARCHAR(50)		NOT NULL,
Micromobility_type				VARCHAR(50)		NOT NULL,
PRIMARY KEY (RVehicle_id),
FOREIGN KEY (RVehicle_id) REFERENCES RVEHICLE(RVehicle_id) ON UPDATE CASCADE ON DELETE CASCADE);

CREATE TABLE CAR
(RVehicle_id					VARCHAR(50)		NOT NULL,
Model							VARCHAR(50)		NOT NULL,
Transmission_type				VARCHAR(50)		NOT NULL,
Seat_count						INT             NOT NULL,
Fuel_type						VARCHAR(50)		NOT NULL,
PRIMARY KEY (RVehicle_id),
FOREIGN KEY (RVehicle_id) REFERENCES RVEHICLE(RVehicle_id) ON UPDATE CASCADE ON DELETE CASCADE);


/*
-- 3 TRIGGERS

-- 3.1 
-- Adjusts the count of available seats in a trip instance upon the creation of a new reservation within that particular trip instance

CREATE TRIGGER UPDATE_AVAILABLE_SEATS
AFTER INSERT ON RESERVATION
FOR EACH ROW
UPDATE TRIP_INSTANCE
SET TRIP_INSTANCE.Available_seats = TRIP_INSTANCE.Available_seats - 1
WHERE TRIP_INSTANCE.Trip_code = NEW.Trip_code
	AND TRIP_INSTANCE.Trip_date = NEW.Trip_date;


-- 3.2
-- Denies the reservation if an attempt is made on a trip instance with no available seats

DELIMITER //
CREATE TRIGGER VIOLATION_SEAT_CAPACITY_EXCEEDED
BEFORE UPDATE ON TRIP_INSTANCE
FOR EACH ROW
BEGIN
    DECLARE msg VARCHAR(255);
    IF NEW.Available_seats < 0 THEN
        SET msg = 'Reservation rejected: Seat capacity exceeded';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = msg;
    END IF;
END //
DELIMITER ;


-- 3.3
-- Rejects the scheduled trip entry if the departure or arrival terminal is inconsistent with the trip type

DELIMITER //
CREATE TRIGGER VIOLATION_INCORRECT_TERMINAL_TYPE
BEFORE INSERT ON SCHEDULED_TRIPS
FOR EACH ROW
BEGIN
	DECLARE msg VARCHAR(255);
    IF (SUBSTRING(NEW.Dep_terminal_code, 1, 2) != SUBSTRING(NEW.Trip_code, 4, 2)) OR (SUBSTRING(NEW.Arr_terminal_code, 1, 2) != SUBSTRING(NEW.Trip_code, 4, 2)) THEN
		SET msg = 'Entry rejected: Incorrect terminal type';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = msg;
	END IF;
END //
DELIMITER ;
*/


/*
-- 4 CHECK CONSTRAINTS

-- 4.1
FARE: Amount	INT	NOT NULL	CHECK	(Amount > 0)
RVEHICLE:	Price	INT	NOT NULL	CHECK	(Price > 0)

-- 4.2
FARE:	Fare_code	VARCHAR(50)	NOT NULL	CHECK	(Fare_code IN ('Child', 'Student', 'Adult', 'Elderly'))

-- 4.3
SCHEDULED_TRIPS:	Dep_date	DATE	CHECK	(Dep_date >= '2024-01-01' AND Dep_date <= '2024-03-31')
SCHEDULED_TRIPS:	Arr_date	DATE	CHECK	(Arr_date >= '2024-01-01' AND Arr_date <= '2024-03-31')
RENTAL_INSTANCE:	Pick_up_date	DATETIME	NOT NULL	CHECK	(Pick_up_date >= '2024-01-01' AND Pick_up_date <= '2024-03-31')
RENTAL_INSTANCE:	Drop_off_date	DATETIME	NOT NULL	CHECK	(Drop_off_date >= '2024-01-01' AND Drop_off_date <= '2024-03-31')
*/
