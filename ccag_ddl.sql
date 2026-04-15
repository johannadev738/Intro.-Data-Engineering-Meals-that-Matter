-- ============================================================
-- COP 3710 - Course Project
-- Organization: Collaborative Care Advocacy Group
-- Program: Meals That Matter
-- File: Table Creation (DDL) - Version 2
-- ============================================================

-- Drop tables if they exist so this script can be re-run cleanly.
DROP TABLE IF EXISTS staff_volunteer_survey CASCADE;
DROP TABLE IF EXISTS participant_survey CASCADE;
DROP TABLE IF EXISTS event CASCADE;
DROP TABLE IF EXISTS disability_type CASCADE;
DROP TABLE IF EXISTS organization CASCADE;

-- ============================================================
-- TABLE 1: organization
-- Stores the partner orgs that HOST the meal events.
-- The 3 real orgs from CCAG post meals data excel sheet are: Easterseals,
-- Community Resource Network, and Trailways Camps.
-- ============================================================
CREATE TABLE organization (
    org_id              SERIAL PRIMARY KEY,
    org_name            VARCHAR(100) NOT NULL,
    address             VARCHAR(150),
    city                VARCHAR(50),
    county              VARCHAR(50),
    zip_code            VARCHAR(10),
    phone_number        VARCHAR(20),
    email               VARCHAR(100),
    main_contact_name   VARCHAR(100),
    active              BOOLEAN DEFAULT TRUE,
    CONSTRAINT unique_org_name UNIQUE (org_name)
);

-- ============================================================
-- TABLE 2: disability_type
-- A small lookup table for disability categories.
-- ============================================================
CREATE TABLE disability_type (
    disability_type_id  SERIAL PRIMARY KEY,
    disability_name     VARCHAR(100) NOT NULL,
    CONSTRAINT unique_disability UNIQUE (disability_name)
);

-- ============================================================
-- TABLE 3: event
-- One row per meal distribution event.
-- Directly based on Johanna's "Event coordination table."
-- The event_type column covers things like "Lunch", "Thanksgiving
-- Meal", "Camp Lunch" etc. — pulled from CCAG post meals data excel sheet.
-- The individuals_served column comes directly from CCAG post meals data excel sheet.
-- ============================================================
CREATE TABLE event (
    event_id            SERIAL PRIMARY KEY,
    org_id              INT NOT NULL,
    event_name          VARCHAR(150) NOT NULL,
    event_type          VARCHAR(50) NOT NULL,
    event_date          DATE NOT NULL,
    event_location_name VARCHAR(150),
    event_location_addr VARCHAR(150),
    city                VARCHAR(50),
    county              VARCHAR(50),
    zip_code            VARCHAR(10),
    -- How many individuals with disabilities were served?
    -- This comes directly from CCAG post meals data excel sheet.
    individuals_served  INT CHECK (individuals_served > 0),
    notes               TEXT,
    CONSTRAINT fk_event_org
        FOREIGN KEY (org_id) REFERENCES organization(org_id)
);

-- ============================================================ 
-- TABLE 4: participant_survey
-- One row per participant (person with disability) per event.
-- Based on Johanna's Table 2 / the food pantry survey link.
-- Captures food satisfaction, dietary needs, demographics.
-- response_id is the PK. event_id is the FK back to event.
-- ============================================================
CREATE TABLE participant_survey (
    response_id             SERIAL PRIMARY KEY,
    event_id                INT NOT NULL,
    disability_type_id      INT,
    -- Satisfaction with Meals That Matter program (1-5)
    program_satisfaction    INT CHECK (program_satisfaction BETWEEN 1 AND 5),
    -- Did the meal feel complete, not just a snack? (Y/N)
    felt_complete_meal      BOOLEAN,
    -- How many people in household including themselves
    household_size          INT CHECK (household_size > 0),
    -- How often do they visit Meals That Matter programs
    visit_frequency         VARCHAR(50),
    -- How well did the event meet their needs (1-5)
    event_met_needs         INT CHECK (event_met_needs BETWEEN 1 AND 5),
    -- Food preferences / dietary needs
    has_diabetes            BOOLEAN DEFAULT FALSE,
    has_high_blood_pressure BOOLEAN DEFAULT FALSE,
    has_high_cholesterol    BOOLEAN DEFAULT FALSE,
    is_vegetarian           BOOLEAN DEFAULT FALSE,
    is_gluten_free          BOOLEAN DEFAULT FALSE,
    has_food_allergy        BOOLEAN DEFAULT FALSE,
    -- Social situation checkboxes from the survey
    is_unemployed           BOOLEAN DEFAULT FALSE,
    is_single_parent        BOOLEAN DEFAULT FALSE,
    is_veteran              BOOLEAN DEFAULT FALSE,
    is_grandparent_caregiver BOOLEAN DEFAULT FALSE,
    is_homeless             BOOLEAN DEFAULT FALSE,
    -- Would the org participate again? (from CCAG post meals data excel sheet)
    would_participate_again BOOLEAN,
    positive_impact         TEXT,
    additional_feedback     TEXT,
    CONSTRAINT fk_participant_event
        FOREIGN KEY (event_id) REFERENCES event(event_id),
    CONSTRAINT fk_participant_disability
        FOREIGN KEY (disability_type_id) REFERENCES disability_type(disability_type_id)
);

-- ============================================================
-- TABLE 5: staff_volunteer_survey
-- One row per staff member or volunteer per event.
-- Based on Johanna's Table 3.
-- Captures their role, experience ratings, and feedback.
-- ============================================================
CREATE TABLE staff_volunteer_survey (
    staff_response_id       SERIAL PRIMARY KEY,
    event_id                INT NOT NULL,
    -- Were they staff or a volunteer?
    role_type               VARCHAR(20) NOT NULL
                                CHECK (role_type IN ('Staff', 'Volunteer')),
    -- What area did they work?
    team_area               VARCHAR(50)
                                CHECK (team_area IN (
                                    'Check-in', 'Packing',
                                    'Distribution line', 'Traffic',
                                    'Setup', 'Cleanup', 'Other'
                                )),
    first_time              BOOLEAN DEFAULT FALSE,
    -- Experience ratings 1-5
    training_clarity_rating     INT CHECK (training_clarity_rating BETWEEN 1 AND 5),
    communication_rating        INT CHECK (communication_rating BETWEEN 1 AND 5),
    supplies_ready_rating       INT CHECK (supplies_ready_rating BETWEEN 1 AND 5),
    overall_experience_rating   INT CHECK (overall_experience_rating BETWEEN 1 AND 5),
    safety_rating               INT CHECK (safety_rating BETWEEN 1 AND 5),
    -- Yes/No wrap-up questions
    would_volunteer_again   BOOLEAN,
    felt_supported          BOOLEAN,
    response_date           DATE,
    CONSTRAINT fk_staff_event
        FOREIGN KEY (event_id) REFERENCES event(event_id)
);

---------------------------------------------------------------------------------------------------------------------












