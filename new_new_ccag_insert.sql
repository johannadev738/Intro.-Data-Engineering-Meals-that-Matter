-- ============================================================
-- COP 3710 - Course Project
-- Organization: Collaborative Care Advocacy Group
-- Program: Meals That Matter
-- File: Data Population (INSERT) - Version 3 (Adapted for DDL)
-- ============================================================

-- ============================================================
-- ORGANIZATIONS
-- ============================================================
INSERT INTO Organization (org_id, org_name, phone_number, email, contact_person) VALUES
(1, 'Easterseals Southwest Florida', '239-334-6285', 'contact@easterseals-swfl.org', 'Maria Lopez'),
(2, 'Community Resource Network', '239-278-1111', 'info@crn-swfl.org', 'James Turner'),
(3, 'Trailways Camps', '239-455-2200', 'info@trailwayscamps.org', 'Sandra Kim'),
(4, 'Sunshine Adult Day Center', '239-591-4400', 'info@sunshineadc.org', 'Robert Nguyen'),
(5, 'Hope Harbor Shelter', '239-774-5500', 'info@hopeharbor.org', 'Angela White'),
(6, 'Gulf Coast Abilities Center', '239-334-7700', 'info@gcac.org', 'Derek Brown'),
(7, 'Ability Works Florida', '239-992-8800', 'info@abilityworks.org', 'Tina Morales'),
(8, 'LARC Inc.', '239-334-6285', 'info@larcinc.org', 'Paul Henderson'),
(9, 'David Lawrence Centers', '239-455-8500', 'info@dlcmhc.com', 'Christine Adams'),
(10, 'Senior Friendship Centers', '239-275-1224', 'info@seniorfriendship.org', 'Patricia Wilson'),
(11, 'St. Matthew House', '239-774-2532', 'info@stmatthewshouse.org', 'John Rivera'),
(12, 'Boys & Girls Club of Collier County', '239-417-0461', 'info@bgccc.com', 'Karen Johnson'),
(13, 'New Horizons of SWFL', '239-695-2461', 'info@newhorizonsofswfl.org', 'Brian Martinez'),
(14, 'United Cerebral Palsy of SWFL', '239-772-0552', 'info@ucpswfl.org', 'Steven Harris'),
(15, 'Lighthouse of SWFL', '239-936-0111', 'info@lhswfl.org', 'Michael Green');

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
-- DISABILITY TYPES
-- ============================================================
INSERT INTO Disability_Type (disability_type_id, disability_name) VALUES
(1, 'Physical Disability'),
(2, 'Intellectual Disability'),
(3, 'Developmental Disability'),
(4, 'Visual Impairment'),
(5, 'Hearing Impairment'),
(6, 'Traumatic Brain Injury'),
(7, 'Autism Spectrum Disorder'),
(8, 'Multiple Disabilities');

-- ============================================================
-- EVENTS
-- ============================================================
INSERT INTO Event (event_id, org_id, event_name, event_type, event_location_name, individuals_served, notes) VALUES
(1, 1, 'Meals That Matter - Easterseals October', 'Lunch', 'Easterseals Southwest Florida', 40, 'Survey confirmed. Individuals felt appreciated and cared for.'),
(2, 2, 'Meals That Matter - Thanksgiving Life Skills', 'Thanksgiving Meal', 'Community Resource Network', 100, 'Only Thanksgiving meal some individuals received this year.'),
(3, 3, 'Meals That Matter - Trailways Last Day Lunch', 'Camp Lunch', 'Trailways Camps', 28, 'Last day of camp. Extra staff/volunteer meals included in order.'),
(4, 1, 'Meals That Matter - Easterseals January', 'Lunch', 'Easterseals Southwest Florida', 38, NULL),
(5, 2, 'Meals That Matter - CRN February', 'Lunch', 'Community Resource Network', 55, NULL),
(6, 3, 'Meals That Matter - Trailways Winter Camp', 'Camp Lunch', 'Trailways Camps', 25, NULL),
(7, 4, 'Meals That Matter - Sunshine Feb', 'Lunch', 'Sunshine Adult Day Center', 30, NULL),
(8, 5, 'Meals That Matter - Hope Harbor March', 'Lunch', 'Hope Harbor Shelter', 60, NULL),
(9, 6, 'Meals That Matter - GCAC March', 'Lunch', 'Gulf Coast Abilities Center', 42, NULL),
(10, 7, 'Meals That Matter - Ability Works April', 'Lunch', 'Ability Works Florida', 48, NULL);

-- ============================================================
-- EVENT_ADDRESS
-- ============================================================
INSERT INTO Event_Address (event_id, address_id) VALUES
(1, 1), (2, 2), (3, 3), (4, 1), (5, 2), (6, 3), (7, 4), (8, 5), (9, 6), (10, 7);

-- ============================================================
-- PERSONNEL (Staff and Volunteers)
-- ============================================================
INSERT INTO Personnel (person_id, name) VALUES
(1, 'John Smith'), (2, 'Jane Doe'), (3, 'Mike Johnson'), (4, 'Sarah Williams'),
(5, 'David Brown'), (6, 'Lisa Garcia'), (7, 'Tom Martinez'), (8, 'Amy Rodriguez'),
(9, 'Chris Lee'), (10, 'Patricia Taylor');

-- ============================================================
-- EVENT_PERSONNEL
-- ============================================================
INSERT INTO Event_Personnel (event_id, person_id, role) VALUES
(1, 1, 'staff'), (1, 2, 'volunteer'), (2, 3, 'staff'), (2, 4, 'volunteer'),
(3, 5, 'staff'), (3, 6, 'volunteer'), (4, 1, 'staff'), (4, 7, 'volunteer'),
(5, 3, 'staff'), (5, 8, 'volunteer'), (6, 5, 'staff'), (6, 9, 'volunteer'),
(7, 2, 'staff'), (7, 10, 'volunteer'), (8, 4, 'staff'), (8, 1, 'volunteer'),
(9, 6, 'staff'), (9, 3, 'volunteer'), (10, 8, 'staff'), (10, 2, 'volunteer');

-- ============================================================
-- SURVEYS
-- ============================================================
INSERT INTO Survey (survey_id, event_id, target_type) VALUES
(1, 1, 'participant'), (2, 1, 'staff'), (3, 2, 'participant'), (4, 2, 'volunteer'),
(5, 3, 'participant'), (6, 3, 'staff'), (7, 4, 'participant'), (8, 5, 'participant'),
(9, 6, 'participant'), (10, 7, 'participant');

-- ============================================================
-- QUESTIONS
-- ============================================================
INSERT INTO Question (question_id, survey_id, question_text, question_type, question_order) VALUES
(1, 1, 'How satisfied were you with the program?', 'rating', 1),
(2, 1, 'Did you feel you received a complete meal?', 'boolean', 2),
(3, 1, 'How many people live in your household?', 'number', 3),
(4, 1, 'How often do you visit our program?', 'multiple_choice', 4),
(5, 1, 'Did the event meet your needs?', 'rating', 5),
(6, 2, 'How clear was the training?', 'rating', 1),
(7, 2, 'How was communication during the event?', 'rating', 2),
(8, 2, 'Were supplies ready on time?', 'rating', 3),
(9, 2, 'Overall experience rating?', 'rating', 4),
(10, 2, 'Did you feel supported?', 'boolean', 5);

-- ============================================================
-- SURVEY_RESPONSES
-- ============================================================
INSERT INTO Survey_Response (response_id, survey_id, person_id, disability_type_id, is_anonymous, response_date) VALUES
(1, 1, NULL, 1, TRUE, '2025-10-17'),
(2, 1, NULL, 2, TRUE, '2025-10-17'),
(3, 1, NULL, 3, TRUE, '2025-10-17'),
(4, 2, 1, NULL, FALSE, '2025-10-17'),
(5, 2, 2, NULL, FALSE, '2025-10-17'),
(6, 3, NULL, 2, TRUE, '2024-11-26'),
(7, 3, NULL, 3, TRUE, '2024-11-26'),
(8, 3, NULL, 1, TRUE, '2024-11-26'),
(9, 4, 3, NULL, FALSE, '2024-11-26'),
(10, 4, 4, NULL, FALSE, '2024-11-26'),
(11, 5, NULL, 3, TRUE, '2026-01-22'),
(12, 5, NULL, 7, TRUE, '2026-01-22'),
(13, 6, 5, NULL, FALSE, '2026-01-22'),
(14, 6, 6, NULL, FALSE, '2026-01-22');

-- ============================================================
-- ANSWERS
-- ============================================================
INSERT INTO Answer (answer_id, response_id, question_id, answer_value) VALUES
(1, 1, 1, '5'), (2, 1, 2, 'true'), (3, 1, 3, '1'), (4, 1, 4, 'Monthly'), (5, 1, 5, '5'),
(6, 2, 1, '5'), (7, 2, 2, 'true'), (8, 2, 3, '2'), (9, 2, 4, 'Monthly'), (10, 2, 5, '5'),
(11, 3, 1, '5'), (12, 3, 2, 'true'), (13, 3, 3, '1'), (14, 3, 4, 'Quarterly'), (15, 3, 5, '5'),
(16, 4, 6, '5'), (17, 4, 7, '5'), (18, 4, 8, '4'), (19, 4, 9, '5'), (20, 4, 10, 'true'),
(21, 5, 6, '4'), (22, 5, 7, '5'), (23, 5, 8, '5'), (24, 5, 9, '5'), (25, 5, 10, 'true'),
(26, 6, 1, '5'), (27, 6, 2, 'true'), (28, 6, 3, '4'), (29, 6, 4, 'First time'), (30, 6, 5, '5'),
(31, 7, 1, '5'), (32, 7, 2, 'true'), (33, 7, 3, '2'), (34, 7, 4, 'Monthly'), (35, 7, 5, '5'),
(36, 8, 1, '5'), (37, 8, 2, 'true'), (38, 8, 3, '3'), (39, 8, 4, 'Quarterly'), (40, 8, 5, '5'),
(41, 9, 6, '5'), (42, 9, 7, '5'), (43, 9, 8, '5'), (44, 9, 9, '5'), (45, 9, 10, 'true'),
(46, 10, 6, '4'), (47, 10, 7, '4'), (48, 10, 8, '4'), (49, 10, 9, '4'), (50, 10, 10, 'true'),
(51, 11, 1, '5'), (52, 11, 2, 'true'), (53, 11, 3, '1'), (54, 11, 4, 'First time'), (55, 11, 5, '5'),
(56, 12, 1, '5'), (57, 12, 2, 'true'), (58, 12, 3, '1'), (59, 12, 4, 'First time'), (60, 12, 5, '5'),
(61, 13, 6, '5'), (62, 13, 7, '5'), (63, 13, 8, '5'), (64, 13, 9, '5'), (65, 13, 10, 'true'),
(66, 14, 6, '4'), (67, 14, 7, '5'), (68, 14, 8, '4'), (69, 14, 9, '5'), (70, 14, 10, 'true');