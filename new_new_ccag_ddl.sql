-- ============================================================
-- COP 3710 - Course Project
-- Organization: Collaborative Care Advocacy Group
-- Program: Meals That Matter
-- File: Database Schema (DDL) - Version 3
-- ============================================================

-- ============================================================
-- Drop tables if they exist (for clean re-creation)
-- ============================================================
DROP TABLE IF EXISTS Answer CASCADE;
DROP TABLE IF EXISTS Survey_Response CASCADE;
DROP TABLE IF EXISTS Question CASCADE;
DROP TABLE IF EXISTS Survey CASCADE;
DROP TABLE IF EXISTS Event_Personnel CASCADE;
DROP TABLE IF EXISTS Personnel CASCADE;
DROP TABLE IF EXISTS Event_Address CASCADE;
DROP TABLE IF EXISTS Event CASCADE;
DROP TABLE IF EXISTS Organization CASCADE;
DROP TABLE IF EXISTS Address CASCADE;
DROP TABLE IF EXISTS Disability_Type CASCADE;

-- ============================================================
-- Address Table
--New table
-- ============================================================
CREATE TABLE Address (
    address_id INT PRIMARY KEY,
    street VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(100),
    zip_code VARCHAR(20)
);

-- ============================================================
-- Organization Table
-- ============================================================
CREATE TABLE Organization (
    org_id INT PRIMARY KEY,
    address_id INT NOT NULL,
    org_name VARCHAR(255) UNIQUE,
    phone_number VARCHAR(20),
    email VARCHAR(100),
    contact_person VARCHAR(100),
    FOREIGN KEY (address_id) REFERENCES Address(address_id)
);

-- ============================================================
-- Event Table
-- ============================================================
CREATE TABLE Event (
    event_id INT PRIMARY KEY,
    org_id INT NOT NULL,
    address_id INT NOT NULL,
    event_name VARCHAR(255) NOT NULL,
    event_type VARCHAR(50) NOT NULL,
    event_location_name VARCHAR(150),
    individuals_served INT CHECK (individuals_served > 0),
    notes TEXT,
    FOREIGN KEY (org_id) REFERENCES Organization(org_id)
    FOREIGN KEY (address_id) REFERENCES Address(address_id)
);

/*-- ============================================================
-- Event_Address being deleted
--new table 
-- ============================================================
CREATE TABLE Event_Address (
    event_id INT,
    address_id INT,
    PRIMARY KEY (event_id, address_id),
    FOREIGN KEY (event_id) REFERENCES Event(event_id),
    FOREIGN KEY (address_id) REFERENCES Address(address_id)
);*/

-- ============================================================
-- Personnel Table (Staff and Volunteers)
--new table
-- ============================================================
CREATE TABLE Personnel (
    person_id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

-- ============================================================
-- Event_Personnel
-- new table
-- ============================================================
CREATE TABLE Event_Personnel (
    event_id INT,
    person_id INT,
    role VARCHAR(50) CHECK (role IN ('staff', 'volunteer')),
    PRIMARY KEY (event_id, person_id),
    FOREIGN KEY (event_id) REFERENCES Event(event_id),
    FOREIGN KEY (person_id) REFERENCES Personnel(person_id)
);

-- ============================================================
-- Disability_Type Lookup Table
-- ============================================================
CREATE TABLE Disability_Type (
    disability_type_id INT PRIMARY KEY,
    disability_name VARCHAR(100) UNIQUE,
    disability_description TEXT
);

-- ============================================================
-- Survey Table
-- ============================================================
CREATE TABLE Survey (
    survey_id INT PRIMARY KEY,
    event_id INT NOT NULL,
    target_type VARCHAR(50) NOT NULL CHECK (
        target_type IN ('participant', 'staff', 'volunteer')
    ),
    FOREIGN KEY (event_id) REFERENCES Event(event_id)
);

-- ============================================================
-- Question Table
--new table
-- ============================================================
CREATE TABLE Question (
    question_id INT PRIMARY KEY,
    survey_id INT NOT NULL,
    question_text TEXT NOT NULL,
    question_type VARCHAR(20) CHECK (
        question_type IN ('rating', 'boolean', 'number', 'text', 'multiple_choice')
    ),
    question_order INT,
    FOREIGN KEY (survey_id) REFERENCES Survey(survey_id)
);

-- ============================================================
-- Survey_Response Table
--new table
-- ============================================================
CREATE TABLE Survey_Response (
    response_id INT PRIMARY KEY,
    survey_id INT NOT NULL,
    person_id INT NULL,
    disability_type_id INT NULL,
    is_anonymous BOOLEAN NOT NULL,
    response_date DATE,
    FOREIGN KEY (survey_id) REFERENCES Survey(survey_id),
    FOREIGN KEY (person_id) REFERENCES Personnel(person_id),
    FOREIGN KEY (disability_type_id) REFERENCES Disability_Type(disability_type_id),
    CHECK (
        (is_anonymous = TRUE AND person_id IS NULL) OR
        (is_anonymous = FALSE AND person_id IS NOT NULL)
    )
);

-- ============================================================
-- Answer Table
--new table
-- ============================================================
CREATE TABLE Answer (
    answer_id INT PRIMARY KEY,
    response_id INT NOT NULL,
    question_id INT NOT NULL,
    answer_value TEXT,
    FOREIGN KEY (response_id) REFERENCES Survey_Response(response_id),
    FOREIGN KEY (question_id) REFERENCES Question(question_id)
);
