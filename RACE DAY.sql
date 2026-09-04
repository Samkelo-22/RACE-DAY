USE RACE_DAY

-- CREATE TABLES

-- Users table
CREATE TABLE Ussers (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    role VARCHAR(20) NOT NULL CHECK (role IN ('Organiser', 'Participant')),
    created_at DATETIME DEFAULT GETDATE()
);

SELECT * FROM Ussers

-- Organisers table
CREATE TABLE Organissers (
    organiser_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    company VARCHAR(100),
    phone VARCHAR(20),
    FOREIGN KEY (user_id) REFERENCES Ussers(user_id)
);

SELECT * FROM Organissers

-- Participants table
CREATE TABLE Participantss (
    participant_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    dob DATE NOT NULL,
    gender VARCHAR(10) CHECK (gender IN ('Male', 'Female', 'Other')),
    emergency_contact VARCHAR(100) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Ussers(user_id)
);

SELECT * FROM Participantss

-- Events table
CREATE TABLE Eventss (
    event_id INT IDENTITY(1,1) PRIMARY KEY,
    organiser_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    description VARCHAR(500),
    event_date DATE NOT NULL,
    location VARCHAR(200) NOT NULL,
    max_participants INT NOT NULL,
    status VARCHAR(20) DEFAULT 'Open' CHECK (status IN ('Open', 'Closed', 'Cancelled', 'Completed')),
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (organiser_id) REFERENCES Organissers(organiser_id)
);

SELECT * FROM Eventss

-- Categories table
CREATE TABLE Categoriess (
    category_id INT IDENTITY(1,1) PRIMARY KEY,
    event_id INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    distance_km DECIMAL(5,2) NOT NULL,
    start_time TIME NOT NULL,
    entry_fee DECIMAL(10,2) NOT NULL,
    max_capacity INT NOT NULL,
    FOREIGN KEY (event_id) REFERENCES Eventss(event_id)
);

SELECT * FROM Categoriess

-- Enrolments table
CREATE TABLE Enrolments (
    enrolment_id INT IDENTITY(1,1) PRIMARY KEY,
    event_id INT NOT NULL,
    participant_id INT NOT NULL,
    category_id INT NOT NULL,
    registration_date DATETIME DEFAULT GETDATE(),
    status VARCHAR(20) DEFAULT 'Pending' CHECK (status IN ('Pending', 'Confirmed', 'Cancelled')),
    bib_number INT NULL UNIQUE,
    payment_status VARCHAR(20) DEFAULT 'Pending' CHECK (payment_status IN ('Pending', 'Paid')),
    FOREIGN KEY (event_id) REFERENCES Eventss(event_id),
    FOREIGN KEY (participant_id) REFERENCES Participantss(participant_id),
    FOREIGN KEY (category_id) REFERENCES Categoriess(category_id)
);

SELECT * FROM Enrolments

-- Results table
CREATE TABLE Results (
    result_id INT IDENTITY(1,1) PRIMARY KEY,
    enrolment_id INT NOT NULL UNIQUE,
    finish_time TIME NULL,
    position INT NULL,
    status VARCHAR(20) DEFAULT 'Registered' CHECK (status IN ('Registered', 'Finished', 'DNF')),
    recorded_date DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (enrolment_id) REFERENCES Enrolments(enrolment_id)
);

SELECT * FROM Results


-- INSERT SAMPLE DATA

-- Users (2 Organisers, 4 Participants)
INSERT INTO Ussers (username, email, password, first_name, last_name, role)
VALUES('john_org', 'john@gmail.com', 'pass123', 'John', 'Smith', 'Organiser'),
      ('sarah_org', 'sarah@gmail.com', 'pass123', 'Sarah', 'Johnson', 'Organiser'),
      ('mike_run', 'mike@gmail.com', 'pass123', 'Michael', 'Brown', 'Participant'),
      ('emma_run', 'emma@gmail.com', 'pass123', 'Emma', 'Wilson', 'Participant'),
      ('david_run', 'david@gmail.com', 'pass123', 'David', 'Lee', 'Participant'),
      ('lisa_run', 'lisa@gmail.com', 'pass123', 'Lisa', 'Martinez', 'Participant');

      SELECT * FROM Ussers

-- Organisers
INSERT INTO Organissers (user_id, company, phone)
VALUES (1, 'FitRace Events', '0412 345 678'),
       (2, 'RunEvents Sydney', '0423 456 789');

       SELECT * FROM Organissers

-- Participants
INSERT INTO Participantss (user_id, dob, gender, emergency_contact)
VALUES(3, '1990-05-15', 'Male', 'Jane Brown - 0434 567 890'),
      (4, '1988-08-22', 'Female', 'Tom Wilson - 0445 678 901'),
      (5, '1995-03-10', 'Male', 'Sarah Lee - 0456 789 012'),
      (6, '1992-11-30', 'Female', 'Mark Martinez - 0467 890 123');

      SELECT * FROM Participantss

-- Events
INSERT INTO Eventss(organiser_id, name, description, event_date, location, max_participants, status)
VALUES(1, 'Sydney Harbour 10K', 'Scenic run around Sydney Harbour', '2026-11-15', 'Sydney Harbour, NSW', 500, 'Open'),
      (1, 'Melbourne Marathon', 'Full marathon through Melbourne', '2026-12-01', 'Melbourne CBD, VIC', 1000, 'Open'),
      (2, 'Brisbane Fun Run', 'Fun run for all ages', '2026-10-20', 'South Bank, Brisbane', 300, 'Open'),
      (2, 'Perth Coastal Trail', 'Trail run along the coast', '2027-01-10', 'Coastal Park, Perth', 200, 'Open');

      SELECT * FROM Eventss

-- Categories
INSERT INTO Categoriess (event_id, name, distance_km, start_time, entry_fee, max_capacity)
VALUES(1, 'Elite 10K', 10.00, '07:00:00', 50.00, 100),
      (1, 'Open 10K', 10.00, '07:30:00', 35.00, 300),
      (1, 'Fun Run 5K', 5.00, '08:00:00', 20.00, 100),
      (2, 'Full Marathon', 42.20, '06:00:00', 120.00, 500),
      (2, 'Half Marathon', 21.10, '07:00:00', 80.00, 400),
      (2, '10K Challenge', 10.00, '07:30:00', 45.00, 100),
      (3, '5K Walk/Run', 5.00, '08:00:00', 25.00, 200),
      (3, '10K Run', 10.00, '08:30:00', 35.00, 100);

      SELECT * FROM Categoriess

-- Enrolments
INSERT INTO Enrolments (event_id, participant_id, category_id, status, bib_number, payment_status)
VALUES(1, 1, 1, 'Confirmed', 1001, 'Paid'),
      (1, 2, 2, 'Confirmed', 1002, 'Paid'),
      (1, 3, 2, 'Confirmed', 1003, 'Pending'),
      (1, 4, 3, 'Pending', 1004, 'Pending'),
      (2, 1, 4, 'Confirmed', 2001, 'Paid'),
      (2, 2, 5, 'Confirmed', 2002, 'Paid'),
      (2, 3, 5, 'Pending', 2003, 'Pending'),
      (3, 1, 7, 'Confirmed', 3001, 'Paid'),
      (3, 2, 7, 'Confirmed', 3002, 'Paid'),
      (3, 4, 8, 'Pending', 3003, 'Pending');

      SELECT * FROM Enrolments

-- Results
INSERT INTO Results (enrolment_id, finish_time, position, status)
VALUES(1, '00:42:30', 5, 'Finished'),
      (2, '00:48:15', 15, 'Finished'),
      (5, '03:30:45', 22, 'Finished'),
      (6, '01:45:20', 8, 'Finished'),
      (8, '00:28:45', 3, 'Finished'),
      (9, '00:32:10', 7, 'Finished');

      SELECT * FROM Results


