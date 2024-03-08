/*
-- 5.A.1
INSERT INTO CUSTOMER
VALUES
  (41, 'Cemux', '5336573210');
  
DELETE FROM CUSTOMER
WHERE Customer_id BETWEEN 10 AND 12;

UPDATE CUSTOMER
SET Phone = '0000000000'
WHERE Customer_id = '1';

-- Proof of ON UPDATE CASCADE and ON DELETE CASCADE
SELECT Customer_id, Customer_name, Phone, Search
FROM SEARCH_HISTORY
NATURAL JOIN CUSTOMER;
*/

/*
-- 5.A.2
INSERT INTO VEHICLE
VALUES
  ('V_AP_03', 500);

INSERT INTO AIRPLANE
VALUES
  ('V_AP_03', 'Cessna 172');
  
DELETE FROM VEHICLE
WHERE Vehicle_id = 'V_AP_01';

UPDATE VEHICLE
SET Vehicle_id = 'V_AP_04'
WHERE Vehicle_id = 'V_AP_02';

-- Proof of ON UPDATE CASCADE and ON DELETE CASCADE
SELECT *
FROM TRIP_INSTANCE
NATURAL JOIN VEHICLE
WHERE Trip_code LIKE ('%AP%');

-- Proof of INSERT
SELECT *
FROM VEHICLE
NATURAL JOIN AIRPLANE
WHERE Vehicle_id LIKE ('%AP%');
*/

/*
-- 5.A.3
INSERT INTO TERMINAL
VALUES
  ('BU_9999', 'Batman Terminal', 'Batman'),
  ('BU_3333', 'Mersin Terminal', 'Mersin');
  
DELETE FROM TERMINAL
WHERE Terminal_code = 'BU_0002';

UPDATE TERMINAL
SET Terminal_name = 'Sivas Terminal', Location = 'Sivas'
WHERE Terminal_code = 'BU_0004';

-- Proof of ON UPDATE CASCADE and ON DELETE CASCADE
SELECT *
FROM SCHEDULED_TRIPS, TERMINAL
WHERE Dep_terminal_code = Terminal_code
	AND Trip_code LIKE ('%BU%');

-- Proof of INSERT
SELECT *
FROM TERMINAL
WHERE Terminal_code LIKE ('%BU%');
*/



/*
-- 5.B.1 (2 Tables)
-- The counts of total trip instances and reserved trip instances for each trip type

SELECT
CASE
    WHEN SUBSTRING(TI.Trip_code, 4, 2) LIKE 'AP' THEN 'Airplane Trip'
    WHEN SUBSTRING(TI.Trip_code, 4, 2) LIKE 'SH' THEN 'Ship Trip'
    WHEN SUBSTRING(TI.Trip_code, 4, 2) LIKE 'TR' THEN 'Train Trip'
    WHEN SUBSTRING(TI.Trip_code, 4, 2) LIKE 'BU' THEN 'Bus Trip'
    ELSE 'Unknown'
END AS Trip_type,
COUNT(DISTINCT TI.Trip_code) AS Total_trip_instances, COUNT(DISTINCT R.Trip_code) AS Reserved_trip_instances
FROM TRIP_INSTANCE AS TI
LEFT JOIN RESERVATION AS R ON TI.Trip_code = R.Trip_code
GROUP BY Trip_type;
*/

/*
-- 5.B.2 (2 Tables)
-- Customers who haven't rented any micromobility or car services

SELECT *
FROM CUSTOMER AS C
WHERE NOT EXISTS (SELECT R.Customer_id
					FROM RENTAL AS R
                    WHERE C.Customer_id = R.Customer_id);

*/

/*
-- 5.B.3 (3 Tables)
-- Customers who made reservations for Obilet trips during the period from 01.02.2024 to 31.03.2024

SELECT Trip_code, Customer_id, Customer_name, Seat_number, Seat_type, Trip_date, Dep_terminal_code, Dep_date, Arr_terminal_code, Arr_date
FROM CUSTOMER AS C
NATURAL JOIN RESERVATION AS R
NATURAL JOIN SCHEDULED_TRIPS AS S
WHERE (S.Dep_date BETWEEN '2024-02-01' AND '2024-03-31')
	AND (R.Trip_code LIKE ('OB%'));
*/

/*
-- 5.B.4 (3 Tables)        
-- Information on ferry trips with a available vehicle carrying capacity exceeding 10, excluding those departing from İzmir

SELECT TI.Trip_code, Available_seats, TI.Available_vehicle_carrying_capacity, Trip_date, T1.Terminal_name AS Departure_terminal, Dep_date, T2.Terminal_name AS Arrival_terminal, Arr_date
FROM TRIP_INSTANCE AS TI, TERMINAL AS T1, SCHEDULED_TRIPS AS S, TERMINAL AS T2
WHERE (S.Dep_terminal_code = T1.Terminal_code)
	AND (S.Arr_terminal_code = T2.Terminal_code)
	AND (S.Trip_code = TI.Trip_code)
	AND NOT (T1.Location = 'İzmir')
    AND (TI.Vehicle_id = 'V_SH_01')
    AND (TI.Available_vehicle_carrying_capacity > 10);
*/

/*    
-- 5.B.5 (3 Tables)
-- Statistical information on the prices of trips categorized by trip type, either departing from or arriving at İzmir

SELECT
CASE
    WHEN SUBSTRING(ST.Trip_code, 4, 2) LIKE 'AP' THEN 'Airplane Trip'
    WHEN SUBSTRING(ST.Trip_code, 4, 2) LIKE 'SH' THEN 'Ship Trip'
    WHEN SUBSTRING(ST.Trip_code, 4, 2) LIKE 'TR' THEN 'Train Trip'
    WHEN SUBSTRING(ST.Trip_code, 4, 2) LIKE 'BU' THEN 'Bus Trip'
    ELSE 'Unknown'
END AS Trip_type,
COUNT(*) AS Scheduled_trip_count, FORMAT(MIN(Amount), 2) AS Minimum_cost, FORMAT(MAX(Amount), 2) AS Maximum_cost, FORMAT(AVG(Amount), 2) AS Average_cost
FROM SCHEDULED_TRIPS AS ST, FARE AS F, TERMINAL AS T1, TERMINAL AS T2
WHERE ST.Trip_code = F.Trip_code
	AND ST.Dep_terminal_code = T1.Terminal_code
    AND ST.Arr_terminal_code = T2.Terminal_code
	AND F.Fare_code = 'Adult'
    AND (T1.Location = 'İzmir' OR T2.Location = 'İzmir')
GROUP BY Trip_type;
*/



/*
-- 5.C.1
-- Customers who have made reservations for airplane trips and have indicated a preference for airplane travel

SELECT *
FROM CUSTOMER AS C
NATURAL JOIN PREFERENCE_LOG AS P
NATURAL JOIN RESERVATION AS R
WHERE (P.Preference LIKE ('%plane%'))
    AND (R.Trip_code LIKE ('%AP%'));
*/
   
/*
-- 5.C.2
-- Scheduled trips from İstanbul to Ankara with their prices

SELECT S.Trip_code, T1.Location AS Departure_location, T1.Terminal_name AS Departure_terminal, T2.Location AS Arrival_location, T2.Terminal_name AS Arrival_terminal, Fare_code, Amount
FROM SCHEDULED_TRIPS AS S, TERMINAL AS T1, TERMINAL AS T2, FARE AS F
WHERE (S.Dep_terminal_code = T1.Terminal_code)
	AND (S.Arr_terminal_code = T2.Terminal_code)
    AND (F.Trip_code = S.Trip_code)
	AND	(T1.Location = 'İstanbul')
    AND (T2.Location = 'Ankara');
*/
    
/*
-- 5.C.3
-- Details about rental instances where the vehicles utilize gasoline as their fuel type

SELECT RI.Rental_code, Customer_id, RV.RVehicle_id, Model, Fuel_type, Price, Pick_up_address, Pick_up_date, Drop_off_address, Drop_off_date
FROM RVEHICLE AS RV, CAR AS C, RENTAL_INSTANCE AS RI, RENTAL AS R
WHERE RV.RVehicle_id = C.RVehicle_id
	AND RI.Rental_code = R.Rental_code
    AND R.RVehicle_id = RV.RVehicle_id
    AND Fuel_type = 'Gasoline'
ORDER BY Price DESC;
*/

/*
-- 5.C.4
-- Travel choices for an individual who journeyed from Istanbul to Antalya on 01.02.2024 with trip code TD_TR_0005, and is interested in available trip options from Antalya to Çanakkale after that date

SELECT ST1.Trip_code AS First_trip, ST1.Arr_date AS Arrival_in_Antalya, ST2.Trip_code AS Second_trip_choices, T1.Location AS Departure_location, ST2.Dep_date, T2.Location AS Arrival_location, ST2.Arr_date
FROM SCHEDULED_TRIPS AS ST1, SCHEDULED_TRIPS AS ST2, TERMINAL AS T1, TERMINAL AS T2
WHERE ST2.Dep_terminal_code = T1.Terminal_code
	AND ST2.Arr_terminal_code = T2.Terminal_code
    AND T1.Location = 'Antalya'
    AND T2.Location = 'Çanakkale'
    AND ST1.Trip_code = 'TD_TR_0005'
    AND ST2.Dep_date > ST1.Arr_date;
*/

/*
-- Displays the number of customers for each combination of service provider and transportation type

SELECT 
CASE
	WHEN SUBSTRING(TH.Transportation, 1, 2) LIKE 'TA' THEN 'Turkish Airlines'
	WHEN SUBSTRING(TH.Transportation, 1, 2) LIKE 'TD' THEN 'TCDD'
	WHEN SUBSTRING(TH.Transportation, 1, 2) LIKE 'IZ' THEN 'IZBAN'
	WHEN SUBSTRING(TH.Transportation, 1, 2) LIKE 'ID' THEN 'IDO'
	WHEN SUBSTRING(TH.Transportation, 1, 2) LIKE 'OB' THEN 'Obilet'
	WHEN SUBSTRING(TH.Transportation, 1, 2) LIKE 'MT' THEN 'Martı'
	WHEN SUBSTRING(TH.Transportation, 1, 2) LIKE 'YC' THEN 'Yolcu360'
	ELSE 'Unknown'
END AS Service_provider,
COUNT(CASE WHEN SUBSTRING(TH.Transportation, 4, 2) LIKE 'AP' THEN 1 END) AS Airplane,
COUNT(CASE WHEN SUBSTRING(TH.Transportation, 4, 2) LIKE 'TR' THEN 1 END) AS Train,
COUNT(CASE WHEN SUBSTRING(TH.Transportation, 4, 2) LIKE 'SH' THEN 1 END) AS Ship,
COUNT(CASE WHEN SUBSTRING(TH.Transportation, 4, 2) LIKE 'BU' THEN 1 END) AS Bus,
COUNT(CASE WHEN SUBSTRING(TH.Transportation, 4, 2) LIKE 'MM' THEN 1 END) AS Micromobility,
COUNT(CASE WHEN SUBSTRING(TH.Transportation, 4, 2) LIKE 'CR' THEN 1 END) AS Car_rental,
COUNT(*) AS Total_customers
FROM TRANSPORTATION_HISTORY AS TH
GROUP BY Service_provider;
*/

/*
-- The total number of searches made by customers in their search histories for specific transportation types

SELECT
CASE
	WHEN SH.Search LIKE '%plane%' THEN 'Airplane'
	WHEN SH.Search LIKE '%airport%' THEN 'Airplane'
	WHEN SH.Search LIKE '%train%' THEN 'Train'
	WHEN SH.Search LIKE '%station%' THEN 'Train'
	WHEN SH.Search LIKE '%ship%' THEN 'Ship'
	WHEN SH.Search LIKE '%ferry%' THEN 'Ship'
	WHEN SH.Search LIKE '%bus%' THEN 'Bus'
	WHEN SH.Search LIKE '%martı%' THEN 'Micromobility'
	WHEN SH.Search LIKE '%car%' THEN 'Car Rental'
	ELSE 'Not Specified'
END AS Searches,
COUNT(Customer_id) AS Customer_count
FROM SEARCH_HISTORY AS SH
GROUP BY Searches
ORDER BY Customer_count DESC;
*/