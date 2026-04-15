-- ============================================================
-- COP 3710 - Course Project
-- Organization: Collaborative Care Advocacy Group
-- Program: Meals That Matter
-- File: Data Population (INSERT) - Version 4 (normalized insert with new ddl)
-- ============================================================

-- ============================================================
-- ============================================================
TRUNCATE TABLE Answer CASCADE;
TRUNCATE TABLE Survey_Response CASCADE;
TRUNCATE TABLE Question CASCADE;
TRUNCATE TABLE Survey CASCADE;
TRUNCATE TABLE Event_Personnel CASCADE;
TRUNCATE TABLE Personnel CASCADE;
TRUNCATE TABLE Event CASCADE;
TRUNCATE TABLE Organization CASCADE;
TRUNCATE TABLE Address CASCADE;
TRUNCATE TABLE Disability_Type CASCADE;

-- Restart sequences if using SERIAL
ALTER SEQUENCE IF EXISTS address_address_id_seq RESTART WITH 1;
ALTER SEQUENCE IF EXISTS organization_org_id_seq RESTART WITH 1;
ALTER SEQUENCE IF EXISTS event_event_id_seq RESTART WITH 1;
ALTER SEQUENCE IF EXISTS personnel_person_id_seq RESTART WITH 1;
ALTER SEQUENCE IF EXISTS disability_type_disability_type_id_seq RESTART WITH 1;
ALTER SEQUENCE IF EXISTS survey_survey_id_seq RESTART WITH 1;
ALTER SEQUENCE IF EXISTS question_question_id_seq RESTART WITH 1;
ALTER SEQUENCE IF EXISTS survey_response_response_id_seq RESTART WITH 1;
ALTER SEQUENCE IF EXISTS answer_answer_id_seq RESTART WITH 1;

-- ============================================================
-- ADDRESSES
-- ============================================================
INSERT INTO Address (address_id, street, city, state, zip_code) VALUES
(1, '350 Corbett St', 'Fort Myers', 'FL', '33901'),
(2, '5631 Halifax Ave', 'Naples', 'FL', '34102'),
(3, '3000 Bonita Beach Rd', 'Bonita Springs', 'FL', '34134'),
(4, '2345 Immokalee Rd', 'Naples', 'FL', '34110'),
(5, '1010 Sixth Ave S', 'Naples', 'FL', '34102'),
(6, '11120 Carissa Commerce Ct', 'Fort Myers', 'FL', '33966'),
(7, '9250 Corkscrew Rd', 'Bonita Springs', 'FL', '34135'),
(8, '2570 Hanson St', 'Fort Myers', 'FL', '33901'),
(9, '6075 Bathey Ln', 'Naples', 'FL', '34116'),
(10, '1820 Ortiz Ave', 'Fort Myers', 'FL', '33905'),
(11, '2001 Airport Rd S', 'Naples', 'FL', '34112'),
(12, '8225 Collier Blvd', 'Naples', 'FL', '34114'),
(13, '1000 S Collier Blvd', 'Marco Island', 'FL', '34145'),
(14, '2606 Hanson St', 'Fort Myers', 'FL', '33901'),
(15, '35 Mann St', 'Fort Myers', 'FL', '33907');

-- ============================================================
-- ORGANIZATIONS
-- ============================================================
INSERT INTO Organization (org_id, org_name, address_id, phone_number, email, contact_person) VALUES
(1, 'Easterseals Southwest Florida', 1, '239-334-6285', 'contact@easterseals-swfl.org', 'Maria Lopez'),
(2, 'Community Resource Network', 2, '239-278-1111', 'info@crn-swfl.org', 'James Turner'),
(3, 'Trailways Camps', 3, '239-455-2200', 'info@trailwayscamps.org', 'Sandra Kim'),
(4, 'Sunshine Adult Day Center', 4, '239-591-4400', 'info@sunshineadc.org', 'Robert Nguyen'),
(5, 'Hope Harbor Shelter', 5, '239-774-5500', 'info@hopeharbor.org', 'Angela White'),
(6, 'Gulf Coast Abilities Center', 6, '239-334-7700', 'info@gcac.org', 'Derek Brown'),
(7, 'Ability Works Florida', 7, '239-992-8800', 'info@abilityworks.org', 'Tina Morales'),
(8, 'LARC Inc.', 8, '239-334-6285', 'info@larcinc.org', 'Paul Henderson'),
(9, 'David Lawrence Centers', 9, '239-455-8500', 'info@dlcmhc.com', 'Christine Adams'),
(10, 'Senior Friendship Centers', 10, '239-275-1224', 'info@seniorfriendship.org', 'Patricia Wilson'),
(11, 'St. Matthew House', 11, '239-774-2532', 'info@stmatthewshouse.org', 'John Rivera'),
(12, 'Boys & Girls Club of Collier County', 12, '239-417-0461', 'info@bgccc.com', 'Karen Johnson'),
(13, 'New Horizons of SWFL', 13, '239-695-2461', 'info@newhorizonsofswfl.org', 'Brian Martinez'),
(14, 'United Cerebral Palsy of SWFL', 14, '239-772-0552', 'info@ucpswfl.org', 'Steven Harris'),
(15, 'Lighthouse of SWFL', 15, '239-936-0111', 'info@lhswfl.org', 'Michael Green');

-- ============================================================
-- DISABILITY TYPES
-- ============================================================
INSERT INTO Disability_Type (disability_type_id, disability_name, disability_description) VALUES
(1, 'Physical Disability', 'Impairment affecting mobility or physical function'),
(2, 'Intellectual Disability', 'Limitations in cognitive functioning and adaptive behaviors'),
(3, 'Developmental Disability', 'Chronic conditions that develop before age 22'),
(4, 'Visual Impairment', 'Significant vision loss including blindness'),
(5, 'Hearing Impairment', 'Significant hearing loss including deafness'),
(6, 'Traumatic Brain Injury', 'Brain damage caused by external physical force'),
(7, 'Autism Spectrum Disorder', 'Neurodevelopmental condition affecting social interaction and communication'),
(8, 'Multiple Disabilities', 'Combination of two or more disabilities');

-- ============================================================
-- EVENTS
-- ============================================================
INSERT INTO Event (event_id, org_id, address_id, event_name, event_type, event_location_name, individuals_served, notes) VALUES
(1, 1, 1, 'Meals That Matter - Easterseals October', 'Lunch', 'Easterseals Southwest Florida', 40, 'Survey confirmed. Individuals felt appreciated and cared for.'),
(2, 2, 2, 'Meals That Matter - Thanksgiving Life Skills', 'Thanksgiving Meal', 'Community Resource Network', 100, 'Only Thanksgiving meal some individuals received this year.'),
(3, 3, 3, 'Meals That Matter - Trailways Last Day Lunch', 'Camp Lunch', 'Trailways Camps', 28, 'Last day of camp. Extra staff/volunteer meals included in order.'),
(4, 1, 1, 'Meals That Matter - Easterseals January', 'Lunch', 'Easterseals Southwest Florida', 38, NULL),
(5, 2, 2, 'Meals That Matter - CRN February', 'Lunch', 'Community Resource Network', 55, NULL),
(6, 3, 3, 'Meals That Matter - Trailways Winter Camp', 'Camp Lunch', 'Trailways Camps', 25, NULL),
(7, 4, 4, 'Meals That Matter - Sunshine Feb', 'Lunch', 'Sunshine Adult Day Center', 30, NULL),
(8, 5, 5, 'Meals That Matter - Hope Harbor March', 'Lunch', 'Hope Harbor Shelter', 60, NULL),
(9, 6, 6, 'Meals That Matter - GCAC March', 'Lunch', 'Gulf Coast Abilities Center', 42, NULL),
(10, 7, 7, 'Meals That Matter - Ability Works April', 'Lunch', 'Ability Works Florida', 48, NULL),
(11, 8, 8, 'Meals That Matter - LARC April', 'Lunch', 'LARC Inc.', 35, NULL),
(12, 9, 9, 'Meals That Matter - DLC May', 'Breakfast', 'David Lawrence Centers', 28, NULL),
(13, 10, 10, 'Meals That Matter - Senior Friendship May', 'Lunch', 'Senior Friendship Centers', 65, NULL),
(14, 11, 11, 'Meals That Matter - St Matthew June', 'Lunch', 'St. Matthew House', 80, NULL),
(15, 12, 12, 'Meals That Matter - BGC June', 'Camp Lunch', 'Boys & Girls Club of Collier County', 50, NULL);

-- ============================================================
-- PERSONNEL
-- ============================================================
INSERT INTO Personnel (person_id, name) VALUES
(1, 'John Smith'),
(2, 'Jane Doe'),
(3, 'Mike Johnson'),
(4, 'Sarah Williams'),
(5, 'David Brown'),
(6, 'Lisa Garcia'),
(7, 'Tom Martinez'),
(8, 'Amy Rodriguez'),
(9, 'Chris Lee'),
(10, 'Patricia Taylor');

-- ============================================================
-- EVENT_PERSONNEL
-- ============================================================
INSERT INTO Event_Personnel (event_id, person_id, role) VALUES
(1, 1, 'staff'),
(1, 2, 'volunteer'),
(2, 3, 'staff'),
(2, 4, 'volunteer'),
(3, 5, 'staff'),
(3, 6, 'volunteer'),
(4, 1, 'staff'),
(4, 7, 'volunteer'),
(5, 3, 'staff'),
(5, 8, 'volunteer'),
(6, 5, 'staff'),
(6, 9, 'volunteer'),
(7, 2, 'staff'),
(7, 10, 'volunteer'),
(8, 4, 'staff'),
(8, 1, 'volunteer'),
(9, 6, 'staff'),
(9, 3, 'volunteer'),
(10, 8, 'staff'),
(10, 2, 'volunteer');

-- ============================================================
-- SURVEYS
-- ============================================================
INSERT INTO Survey (survey_id, event_id, survey_type) VALUES
(1, 1, 'participant'),
(2, 1, 'staff'),
(3, 2, 'participant'),
(4, 2, 'volunteer'),
(5, 3, 'participant'),
(6, 3, 'staff'),
(7, 4, 'participant'),
(8, 5, 'participant'),
(9, 6, 'participant'),
(10, 7, 'participant'),
(11, 8, 'participant'),
(12, 9, 'participant'),
(13, 10, 'participant'),
(14, 11, 'participant'),
(15, 12, 'participant'),
(16, 13, 'participant'),
(17, 14, 'participant'),
(18, 15, 'participant');

-- ============================================================
-- QUESTIONS
-- ============================================================
INSERT INTO Question (question_id, survey_id, question_text, question_type, question_order) VALUES
-- Questions for survey 1 (participant)
(1, 1, 'Program satisfaction (1-5 rating)', 'rating', 1),
(2, 1, 'Felt the meal was complete?', 'boolean', 2),
(3, 1, 'Household size', 'number', 3),
(4, 1, 'Visit frequency', 'multiple_choice', 4),
(5, 1, 'Event met needs (1-5 rating)', 'rating', 5),
-- Questions for survey 2 (staff)
(6, 2, 'Training clarity rating (1-5)', 'rating', 1),
(7, 2, 'Communication rating (1-5)', 'rating', 2),
(8, 2, 'Supplies ready rating (1-5)', 'rating', 3),
(9, 2, 'Overall experience rating (1-5)', 'rating', 4),
(10, 2, 'Felt supported?', 'boolean', 5);

-- ============================================================
-- SURVEY_RESPONSES
-- ============================================================
INSERT INTO Survey_Response (response_id, survey_id, person_id, disability_type_id, is_anonymous, response_date) VALUES
-- Event 1 responses
(1, 1, NULL, 1, TRUE, '2025-10-17'),
(2, 1, NULL, 2, TRUE, '2025-10-17'),
(3, 1, NULL, 3, TRUE, '2025-10-17'),
(4, 2, 1, NULL, FALSE, '2025-10-17'),
(5, 2, 2, NULL, FALSE, '2025-10-17'),
-- Event 2 responses
(6, 3, NULL, 2, TRUE, '2024-11-26'),
(7, 3, NULL, 3, TRUE, '2024-11-26'),
(8, 3, NULL, 1, TRUE, '2024-11-26'),
(9, 4, 3, NULL, FALSE, '2024-11-26'),
(10, 4, 4, NULL, FALSE, '2024-11-26'),
-- Event 3 responses
(11, 5, NULL, 3, TRUE, '2026-01-22'),
(12, 5, NULL, 7, TRUE, '2026-01-22'),
(13, 6, 5, NULL, FALSE, '2026-01-22'),
(14, 6, 6, NULL, FALSE, '2026-01-22'),
-- Additional participant responses for events 4-15
(15, 7, NULL, 1, TRUE, '2024-01-10'),
(16, 7, NULL, 2, TRUE, '2024-01-10'),
(17, 8, NULL, 3, TRUE, '2024-02-07'),
(18, 8, NULL, 1, TRUE, '2024-02-07'),
(19, 9, NULL, 2, TRUE, '2024-01-24'),
(20, 9, NULL, 4, TRUE, '2024-01-24'),
(21, 10, NULL, 3, TRUE, '2024-02-14'),
(22, 10, NULL, 7, TRUE, '2024-02-14'),
(23, 11, NULL, 1, TRUE, '2024-03-06'),
(24, 11, NULL, 2, TRUE, '2024-03-06'),
(25, 12, NULL, 5, TRUE, '2024-03-13'),
(26, 12, NULL, 3, TRUE, '2024-03-13'),
(27, 13, NULL, 1, TRUE, '2024-04-03'),
(28, 13, NULL, 6, TRUE, '2024-04-03'),
(29, 14, NULL, 2, TRUE, '2024-04-10'),
(30, 14, NULL, 3, TRUE, '2024-04-10'),
(31, 15, NULL, 7, TRUE, '2024-05-01'),
(32, 15, NULL, 2, TRUE, '2024-05-01'),
(33, 16, NULL, 1, TRUE, '2024-05-08'),
(34, 16, NULL, 3, TRUE, '2024-05-08'),
(35, 17, NULL, 2, TRUE, '2024-06-05'),
(36, 17, NULL, 1, TRUE, '2024-06-05'),
(37, 18, NULL, 3, TRUE, '2024-06-12'),
(38, 18, NULL, 4, TRUE, '2024-06-12');

-- ============================================================
-- ANSWERS
-- ============================================================
INSERT INTO Answer (answer_id, response_id, question_id, answer_value) VALUES
-- Response 1
(1, 1, 1, '5'),
(2, 1, 2, 'true'),
(3, 1, 3, '1'),
(4, 1, 4, 'Monthly'),
(5, 1, 5, '5'),
-- Response 2
(6, 2, 1, '5'),
(7, 2, 2, 'true'),
(8, 2, 3, '2'),
(9, 2, 4, 'Monthly'),
(10, 2, 5, '5'),
-- Response 3
(11, 3, 1, '5'),
(12, 3, 2, 'true'),
(13, 3, 3, '1'),
(14, 3, 4, 'Quarterly'),
(15, 3, 5, '5'),
-- Response 4
(16, 4, 6, '5'),
(17, 4, 7, '5'),
(18, 4, 8, '4'),
(19, 4, 9, '5'),
(20, 4, 10, 'true'),
-- Response 5
(21, 5, 6, '4'),
(22, 5, 7, '5'),
(23, 5, 8, '5'),
(24, 5, 9, '5'),
(25, 5, 10, 'true'),
-- Response 6
(26, 6, 1, '5'),
(27, 6, 2, 'true'),
(28, 6, 3, '4'),
(29, 6, 4, 'First time'),
(30, 6, 5, '5'),
-- Response 7
(31, 7, 1, '5'),
(32, 7, 2, 'true'),
(33, 7, 3, '2'),
(34, 7, 4, 'Monthly'),
(35, 7, 5, '5'),
-- Response 8
(36, 8, 1, '5'),
(37, 8, 2, 'true'),
(38, 8, 3, '3'),
(39, 8, 4, 'Quarterly'),
(40, 8, 5, '5'),
-- Response 9
(41, 9, 6, '5'),
(42, 9, 7, '5'),
(43, 9, 8, '5'),
(44, 9, 9, '5'),
(45, 9, 10, 'true'),
-- Response 10
(46, 10, 6, '4'),
(47, 10, 7, '4'),
(48, 10, 8, '4'),
(49, 10, 9, '4'),
(50, 10, 10, 'true'),
-- Response 11
(51, 11, 1, '5'),
(52, 11, 2, 'true'),
(53, 11, 3, '1'),
(54, 11, 4, 'First time'),
(55, 11, 5, '5'),
-- Response 12
(56, 12, 1, '5'),
(57, 12, 2, 'true'),
(58, 12, 3, '1'),
(59, 12, 4, 'First time'),
(60, 12, 5, '5'),
-- Response 13
(61, 13, 6, '5'),
(62, 13, 7, '5'),
(63, 13, 8, '5'),
(64, 13, 9, '5'),
(65, 13, 10, 'true'),
-- Response 14
(66, 14, 6, '4'),
(67, 14, 7, '5'),
(68, 14, 8, '4'),
(69, 14, 9, '5'),
(70, 14, 10, 'true');


--===============================
--NORMALIZED INSERT AFTER CHANGES
--===============================