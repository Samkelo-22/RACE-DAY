-- Create database
CREATE DATABASE ASSESSMENTS;
USE ASSESSMENTS;


CREATE TABLE Moduless(
    Modules_Code VARCHAR(10) NOT NULL PRIMARY KEY,
    Modules_Name VARCHAR(50) NOT NULL
);


INSERT INTO Modules(Modules_Code, Modules_Name)
VALUES ('DATA6212', 'Database intermediate'),
       ('SQAT632', 'Software Testing'),  
       ('CNO5112', 'Client Systems Configuration'),
       ('WEDE6011', 'Web Development'), 
       ('PROG6212', 'Programming'),
       ('ISEC6311', 'Information Security');

-- Now SELECT will show data
SELECT * FROM Modules;  

-- Query to filter by code
SELECT * FROM Modules
WHERE Modules.Modules_Code = 'DATA6212';

-- Insert new module
INSERT INTO Modules(Modules_Code, Modules_Name)
VALUES ('BUIS6221', 'Business Analysis');

-- Query to filter by name
SELECT * FROM Modules
WHERE Modules.Modules_Name = 'Business Analysis';

-- Update module code
UPDATE Modules 
SET Modules_Code = 'BUSA6212'
WHERE Modules_Name = 'Business Analysis';

-- Create Venues table
CREATE TABLE Venues(
    Venue_Code VARCHAR(5) NOT NULL PRIMARY KEY,
    Venue_Name VARCHAR(50) NOT NULL,
    ADDRESS VARCHAR(50) NOT NULL,
    CITY VARCHAR(50) NOT NULL
);

-- Insert venues
INSERT INTO Venues(Venue_Code, Venue_Name, ADDRESS, CITY)
VALUES ('V0001', 'Auditorium', '12 Rader Drive', 'Durban'),  
       ('V0002', 'Lecture Hall B', '168 Clearwater Road', 'Pretoria'),
       ('V0003', 'Block A Room 5', '1 Watermelon Drive', 'Sandton'),
       ('V0004', 'Lecture Hall 4', '2 Ring Road', 'Port Elizabeth'),
       ('V0005', 'Building 3 Room 2', '1 Belmort Street', 'Cape Town');

-- View venues
SELECT * FROM Venues;


CREATE TABLE ASSESSMENT_BOOKING(
    Modules_Code VARCHAR(10) NOT NULL,
    Venue_Code VARCHAR(5) NOT NULL,
    ASSESSMENT_DATE DATE NOT NULL,
    START_TIME TIME NOT NULL,
    DURATION SMALLINT NOT NULL,
    MARKS SMALLINT NOT NULL,
    CONSTRAINT PK_ASSESSMENT_BOOKING PRIMARY KEY(
        Modules_Code, Venue_Code, ASSESSMENT_DATE, START_TIME
    ),
    FOREIGN KEY(Modules_Code) REFERENCES Modules(Modules_Code),
    FOREIGN KEY(Venue_Code) REFERENCES Venues(Venue_Code)
);


INSERT INTO ASSESSMENT_BOOKING(Modules_Code, Venue_Code, ASSESSMENT_DATE, START_TIME, DURATION, MARKS)
VALUES ('DATA6212', 'V0001', '2026-09-15', '09:00:00', 120, 50),
       ('PROG6212', 'V0002', '2026-09-16', '14:00:00', 90, 40),
       ('SQAT632', 'V0003', '2026-09-17', '11:00:00', 60, 30),
       ('WEDE6011', 'V0004', '2026-09-18', '10:00:00', 100, 45);

-- Self Join: Find modules with similar names 
SELECT A.Modules_Code AS ModuleCode1, 
       A.Modules_Name AS ModuleName1,
       B.Modules_Code AS ModuleCode2, 
       B.Modules_Name AS ModuleName2
FROM Modules A, Modules B
WHERE A.Modules_Code <> B.Modules_Code
  AND A.Modules_Name LIKE '%' + SUBSTRING(B.Modules_Name, 1, 5) + '%'
ORDER BY A.Modules_Name;

-- Inner Join: Modules with their venue information
SELECT Modules.Modules_Code,
       Modules.Modules_Name,
       Venues.Venue_Code,
       Venues.Venue_Name,
       Venues.ADDRESS,
       Venues.CITY
FROM Modules
INNER JOIN ASSESSMENT_BOOKING ON Modules.Modules_Code = ASSESSMENT_BOOKING.Modules_Code
INNER JOIN Venues ON ASSESSMENT_BOOKING.Venue_Code = Venues.Venue_Code
ORDER BY Modules.Modules_Name;

-- Left Join: All modules with venue information (if booked)
SELECT Modules.Modules_Code,
       Modules.Modules_Name,
       Venues.Venue_Code,
       Venues.Venue_Name,
       Venues.CITY,
       ASSESSMENT_BOOKING.ASSESSMENT_DATE
FROM Modules
LEFT JOIN ASSESSMENT_BOOKING ON Modules.Modules_Code = ASSESSMENT_BOOKING.Modules_Code
LEFT JOIN Venues ON ASSESSMENT_BOOKING.Venue_Code = Venues.Venue_Code
ORDER BY Modules.Modules_Code;

-- Right Join: All venues with their booked modules
SELECT Venues.Venue_Code,
       Venues.Venue_Name,
       Venues.ADDRESS,
       Venues.CITY,
       Modules.Modules_Code,
       Modules.Modules_Name,
       ASSESSMENT_BOOKING.ASSESSMENT_DATE
FROM ASSESSMENT_BOOKING
RIGHT JOIN Venues ON ASSESSMENT_BOOKING.Venue_Code = Venues.Venue_Code
LEFT JOIN Modules ON ASSESSMENT_BOOKING.Modules_Code = Modules.Modules_Code
ORDER BY Venues.CITY, Venues.Venue_Name;