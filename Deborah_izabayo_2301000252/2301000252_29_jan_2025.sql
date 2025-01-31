-- FLIGHT MONITORS SYSTEMS

/* A flight monitor system is an advanced device designed to replicate the experience of fling an aircraft or spacecraft for training, 
research or development purpose. It provides an environment where pilots and crew members can interact with the cockpit controls and 
system while simulating various flight conditions and scenarios*/


create database Flight_Simulator_System;
use  Flight_Simulator_System;
show databases;
CREATE USER 'DEBORAH'@'127.0.0.1' identified by '2345';
grant select, insert,update on flight_simulator_system.*To 'DEBORAH'@'127.0.0.1';
Flush privileges;
-- Users table
CREATE TABLE Users (
    User_id INT PRIMARY KEY,
    FirstName VARCHAR(100),
    LastName VARCHAR(100),
    Email VARCHAR(100),
    Password VARCHAR(255)
);
-- Aircraft table
CREATE TABLE Aircraft (
    Aircraft_id INT PRIMARY KEY,
    ModelName VARCHAR(100),
    Type VARCHAR(50),
    MaxSpeed int,
    MaxAltitude int,
	empty_weight INT
);
-- Flights table
CREATE TABLE Flights (
    Flight_id INT PRIMARY KEY,
    User_id INT,
    Aircraft_id INT,
    StartTime datetime,
    EndTime datetime,
    Scenario_id int,
    FOREIGN KEY (User_id) REFERENCES Users(User_id),
    FOREIGN KEY (Aircraft_id) REFERENCES Aircraft(Aircraft_id)
);

-- Flight Logs table
CREATE TABLE Flight_Logs (
    Log_id INT PRIMARY KEY,
    Flight_id INT,
    LogTime DATETIME,
    Location VARCHAR(255),
    Altitude int,
    Speed int,
    FOREIGN KEY (Flight_id) REFERENCES Flights(Flight_id)
);

-- Flight Scenarios table
CREATE TABLE Flight_Scenarios (
    Scenario_id INT PRIMARY KEY,
    Name VARCHAR(100),
    Description TEXT,
    DifficultyLevel INT
);

-- Flight Controllers table
CREATE TABLE Flight_Controllers (
    Controller_id INT PRIMARY KEY,
    User_id INT,
    Role VARCHAR(50),
    FOREIGN KEY (User_id) REFERENCES Users(User_id)
);

-- insert users 
INSERT INTO Users (User_id,FirstName, LastName, Email, Password) 
VALUES 
(5,'John', 'Doe', 'john.doe@example.com', 'password1'),
(6,'will', 'Smith', 'will.smith@example.com', 'password2'),
(7,'Alice', 'Johnson', 'alice.johnson@example.com', 'password3'),
(8,'Peter', 'John', 'peter.john@example.com', 'password4');
select *from users;
-- insert Aircraft 
INSERT INTO Aircraft (Aircraft_id, ModelName,Type, Maxspeed, MaxAltitude,empty_weight)
VALUES (1,'Boeing 737',  'Turbofan','commercial','570', 120000, 20000),
      (2,'Airbus A320', 'Turbofan','commercial', 140,'115000', 23000),
	  (3,'RwandaAir 777', 'general', 'Trading',130000,'567' ,30000),
	 (4,'Airbugesera A420', 'Turbofan', 'increase',140,'116000', 25000);
     
SELECT * FROM Aircraft;
-- insert flight 
insert into flights(Flight_id,User_id,Aircraft_id,StartTime,EndTime,Scenario_id)
values

        (1, 'JFK123',1,2,'2023-10-01 10:00:00', '2023-10-01 12:00:00'),
        (2, 'FL123',2,2,'2023-10-01 10:00:00', '2023-10-01 12:00:00'),
		(3, 'JK 123',3,3,'2023-10-01 10:00:00', '2023-10-01 12:00:00'),
		(4, 'FK123',4,4,'2023-10-01 10:00:00', '2023-10-01 12:00:00');
    
    SELECT *FROM flights;
    -- insert flight_logs 
    insert into Flight_Log(Log_id,Flight_id, LogTime,Location, Altitude,Speed)
    values
    (1, '2025-02-30 20:15:00', 'Takeoff', 'Successfully takeoff'),
    (2, '2025-15-30 11:00:00', 'Cruise', 'Cruising at 35000 feet'),
    (3, '2025-01-30 09:30:00', 'Approaching Destination', 'Starting JFK'),
    (4, '2025-05-30 14:00:00', 'Landing', 'Successfully landed at JFK');
    select *from flight_logs;

    -- insert flight scenario 
    INSERT INTO Flight_Scenario (flight_id, scenario_type, scenario_description, start_time, end_time)
VALUES
    (1, 'Emergency',  '2025-01-30 13:45:00', '2025-02-31 14:00:00'),
    (2, 'Emergency', '2025-01-30 13:45:00', '2025-11-27 14:00:00'),
    (3, 'Emergency','2025-01-30 13:45:00', '2025-12-30 14:00:00'),
    (4, 'Emergency', '2025-01-30 13:45:00', '2025-01-30 14:00:00');
select *from flight_logs;
-- insert flight controller
INSERT INTO Flight_Controllers (Controller_id,User_id,Role)
VALUES
('Alice Igihozo', 'Tower', '08:00:00', '16:00:00'),
('Chris Brown', 'Enroute', '09:00:00', '17:00:00'),
('Calmel Davis', 'Approach', '12:00:00', '20:00:00');
    select *from flight_controllers;
    
UPDATE Aircraft SET Capacity = 420
WHERE Aircraft_id = 1;
DELETE FROM Aircraft WHERE Aircraft_id = 1;

SELECT COUNT(*) FROM Flight;
-- AVG 
SELECT AVG(DATEDIFF(ArrivalTime,DepartureTime)) as AverageFlightDuration from flight;
SELECT SUM(Capacity) FROM Aircraft;
-- create a view
CREATE VIEW FlightDetails AS
SELECT Flight.Flight_id, Flight.FlightDate, Aircraft.Model, Pilot.Name
FROM Flight
JOIN Aircraft ON Flight.Aircraft_id = Aircraft.Aircraft_id
JOIN Pilot ON Flight.Pilot_id = Pilot.Pilot_id;

DELIMITER $$
CREATE PROCEDURE GetFlightDetailsByPilot (IN pilot_Id INT)
BEGIN
    SELECT * FROM Flight WHERE Pilot_id= pilot_id;
END $$

CREATE PROCEDURE UpdateAircraftCapacity (IN aircraft_Id INT, IN newCapacity INT)
BEGIN
    UPDATE Aircraft SET Capacity = newCapacity WHERE Aircraft_id = aircraft_Id;
END;
DELIMITER;
DELIMITER $$

CREATE TRIGGER Aircraft_AfterInsert
AFTER INSERT ON Aircraft
FOR EACH ROW
BEGIN
    UPDATE Aircraft
    SET Aircraft_id= UUID()
    WHERE Aircraft_id = NEW.Aircraft_id;
END$$

DELIMITER ;
DELIMITER $$
CREATE TRIGGER Flights_AfterInsert
AFTER INSERT ON Flights
FOR EACH ROW
BEGIN
    UPDATE Flights
    SET Flight_id= UUID()
    WHERE Flight_id = NEW.Flight_id;
END$$

DELIMITER ;
DELIMITER $$
CREATE TRIGGER FlightLogs_AfterInsert
AFTER INSERT ON FlightLogs
FOR EACH ROW
BEGIN
    UPDATE FlightLogs
    SET Log_id = UUID()
    WHERE Log_id= NEW.Log_id;
END$$


DELIMITER ;
DELIMITER $$

CREATE TRIGGER FlightControllers_AfterInsert
AFTER INSERT ON FlightControllers
FOR EACH ROW
BEGIN
    UPDATE FlightControllers
    SET Controller_id = UUID()
    WHERE Controller_id = NEW.Controller_id;
END$$

DELIMITER ;

