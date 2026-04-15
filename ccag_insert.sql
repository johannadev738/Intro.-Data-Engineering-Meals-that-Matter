/*
-- ============================================================
-- COP 3710 - Course Project
-- Organization: Collaborative Care Advocacy Group
-- Program: Meals That Matter
-- File: Data Population (INSERT) - Version 2
-- ============================================================


-- ============================================================
-- ORGANIZATIONS
-- The first 3 come directly from your Excel sheet.
-- The rest are realistic SWFL nonprofits to support 150+ events.
-- ============================================================
INSERT INTO organization (org_name, address, city, county, zip_code, phone_number, email, main_contact_name) VALUES
('Easterseals Southwest Florida',       '350 Corbett St',           'Fort Myers',     'Lee',     '33901', '239-334-6285', 'contact@easterseals-swfl.org',      'Maria Lopez'),
('Community Resource Network',          '5631 Halifax Ave',         'Naples',         'Collier', '34102', '239-278-1111', 'info@crn-swfl.org',                  'James Turner'),
('Trailways Camps',                     '3000 Bonita Beach Rd',     'Bonita Springs', 'Lee',     '34134', '239-455-2200', 'info@trailwayscamps.org',            'Sandra Kim'),
('Sunshine Adult Day Center',           '2345 Immokalee Rd',        'Naples',         'Collier', '34110', '239-591-4400', 'info@sunshineadc.org',               'Robert Nguyen'),
('Hope Harbor Shelter',                 '1010 Sixth Ave S',         'Naples',         'Collier', '34102', '239-774-5500', 'info@hopeharbor.org',                'Angela White'),
('Gulf Coast Abilities Center',         '11120 Carissa Commerce Ct','Fort Myers',     'Lee',     '33966', '239-334-7700', 'info@gcac.org',                      'Derek Brown'),
('Ability Works Florida',               '9250 Corkscrew Rd',        'Bonita Springs', 'Lee',     '34135', '239-992-8800', 'info@abilityworks.org',              'Tina Morales'),
('LARC Inc.',                           '2570 Hanson St',           'Fort Myers',     'Lee',     '33901', '239-334-6285', 'info@larcinc.org',                   'Paul Henderson'),
('David Lawrence Centers',              '6075 Bathey Ln',           'Naples',         'Collier', '34116', '239-455-8500', 'info@dlcmhc.com',                    'Christine Adams'),
('Senior Friendship Centers',           '1820 Ortiz Ave',           'Fort Myers',     'Lee',     '33905', '239-275-1224', 'info@seniorfriendship.org',          'Patricia Wilson'),
('St. Matthew House',                   '2001 Airport Rd S',        'Naples',         'Collier', '34112', '239-774-2532', 'info@stmatthewshouse.org',           'John Rivera'),
('Boys & Girls Club of Collier County', '8225 Collier Blvd',        'Naples',         'Collier', '34114', '239-417-0461', 'info@bgccc.com',                     'Karen Johnson'),
('New Horizons of SWFL',                '1000 S Collier Blvd',      'Marco Island',   'Collier', '34145', '239-695-2461', 'info@newhorizonsofswfl.org',         'Brian Martinez'),
('United Cerebral Palsy of SWFL',       '2606 Hanson St',           'Fort Myers',     'Lee',     '33901', '239-772-0552', 'info@ucpswfl.org',                   'Steven Harris'),
('Lighthouse of SWFL',                  '35 Mann St',               'Fort Myers',     'Lee',     '33907', '239-936-0111', 'info@lhswfl.org',                    'Michael Green');

-- ============================================================
-- DISABILITY TYPES
-- Simple lookup table. participant_survey rows reference these
-- by ID instead of typing the full name every time.
-- ============================================================
INSERT INTO disability_type (disability_name) VALUES
('Physical Disability'),
('Intellectual Disability'),
('Developmental Disability'),
('Visual Impairment'),
('Hearing Impairment'),
('Traumatic Brain Injury'),
('Autism Spectrum Disorder'),
('Multiple Disabilities');

-- ============================================================
-- EVENTS (150 rows)
-- The first 3 match your real Excel data exactly.
-- event_id 1 = Easterseals Oct 17 2025 (org_id 1)
-- event_id 2 = Community Resource Network Nov 26 2024 (org_id 2)
-- event_id 3 = Trailways Camps Jan 22 2026 (org_id 3)
-- ============================================================
INSERT INTO event (org_id, event_name, event_type, event_date, event_location_name, event_location_addr, city, county, zip_code, individuals_served, notes) VALUES
-- Real events from Excel
(1,  'Meals That Matter - Easterseals October',        'Lunch',             '2025-10-17', 'Easterseals Southwest Florida',       '350 Corbett St',        'Fort Myers',     'Lee',     '33901', 40,  'Survey confirmed. Individuals felt appreciated and cared for.'),
(2,  'Meals That Matter - Thanksgiving Life Skills',   'Thanksgiving Meal', '2024-11-26', 'Community Resource Network',          '5631 Halifax Ave',      'Naples',         'Collier', '34102', 100, 'Only Thanksgiving meal some individuals received this year.'),
(3,  'Meals That Matter - Trailways Last Day Lunch',   'Camp Lunch',        '2026-01-22', 'Trailways Camps',                     '3000 Bonita Beach Rd',  'Bonita Springs', 'Lee',     '34134', 28,  'Last day of camp. Extra staff/volunteer meals included in order.'),
-- Generated events
(1,  'Meals That Matter - Easterseals January',        'Lunch',             '2024-01-10', 'Easterseals Southwest Florida',       '350 Corbett St',        'Fort Myers',     'Lee',     '33901', 38,  NULL),
(2,  'Meals That Matter - CRN February',               'Lunch',             '2024-02-07', 'Community Resource Network',          '5631 Halifax Ave',      'Naples',         'Collier', '34102', 55,  NULL),
(3,  'Meals That Matter - Trailways Winter Camp',      'Camp Lunch',        '2024-01-24', 'Trailways Camps',                     '3000 Bonita Beach Rd',  'Bonita Springs', 'Lee',     '34134', 25,  NULL),
(4,  'Meals That Matter - Sunshine Feb',               'Lunch',             '2024-02-14', 'Sunshine Adult Day Center',           '2345 Immokalee Rd',     'Naples',         'Collier', '34110', 30,  NULL),
(5,  'Meals That Matter - Hope Harbor March',          'Lunch',             '2024-03-06', 'Hope Harbor Shelter',                 '1010 Sixth Ave S',      'Naples',         'Collier', '34102', 60,  NULL),
(6,  'Meals That Matter - GCAC March',                 'Lunch',             '2024-03-13', 'Gulf Coast Abilities Center',         '11120 Carissa Commerce Ct','Fort Myers',  'Lee',     '33966', 42,  NULL),
(7,  'Meals That Matter - Ability Works April',        'Lunch',             '2024-04-03', 'Ability Works Florida',               '9250 Corkscrew Rd',     'Bonita Springs', 'Lee',     '34135', 48,  NULL),
(8,  'Meals That Matter - LARC April',                 'Lunch',             '2024-04-10', 'LARC Inc.',                           '2570 Hanson St',        'Fort Myers',     'Lee',     '33901', 35,  NULL),
(9,  'Meals That Matter - DLC May',                    'Breakfast',         '2024-05-01', 'David Lawrence Centers',              '6075 Bathey Ln',        'Naples',         'Collier', '34116', 28,  NULL),
(10, 'Meals That Matter - Senior Friendship May',      'Lunch',             '2024-05-08', 'Senior Friendship Centers',           '1820 Ortiz Ave',        'Fort Myers',     'Lee',     '33905', 65,  NULL),
(11, 'Meals That Matter - St Matthew June',            'Lunch',             '2024-06-05', 'St. Matthew House',                   '2001 Airport Rd S',     'Naples',         'Collier', '34112', 80,  NULL),
(12, 'Meals That Matter - BGC June',                   'Camp Lunch',        '2024-06-12', 'Boys & Girls Club of Collier County', '8225 Collier Blvd',     'Naples',         'Collier', '34114', 50,  NULL),
(13, 'Meals That Matter - New Horizons July',          'Lunch',             '2024-07-10', 'New Horizons of SWFL',                '1000 S Collier Blvd',   'Marco Island',   'Collier', '34145', 22,  NULL),
(14, 'Meals That Matter - UCP July',                   'Lunch',             '2024-07-17', 'United Cerebral Palsy of SWFL',       '2606 Hanson St',        'Fort Myers',     'Lee',     '33901', 33,  NULL),
(15, 'Meals That Matter - Lighthouse August',          'Lunch',             '2024-08-07', 'Lighthouse of SWFL',                  '35 Mann St',            'Fort Myers',     'Lee',     '33907', 20,  NULL),
(1,  'Meals That Matter - Easterseals August',         'Lunch',             '2024-08-14', 'Easterseals Southwest Florida',       '350 Corbett St',        'Fort Myers',     'Lee',     '33901', 40,  NULL),
(2,  'Meals That Matter - CRN September',              'Lunch',             '2024-09-04', 'Community Resource Network',          '5631 Halifax Ave',      'Naples',         'Collier', '34102', 58,  NULL),
(3,  'Meals That Matter - Trailways Fall Camp',        'Camp Lunch',        '2024-10-30', 'Trailways Camps',                     '3000 Bonita Beach Rd',  'Bonita Springs', 'Lee',     '34134', 26,  NULL),
(4,  'Meals That Matter - Sunshine October',           'Lunch',             '2024-10-09', 'Sunshine Adult Day Center',           '2345 Immokalee Rd',     'Naples',         'Collier', '34110', 32,  NULL),
(5,  'Meals That Matter - Hope Harbor Thanksgiving',   'Thanksgiving Meal', '2024-11-27', 'Hope Harbor Shelter',                 '1010 Sixth Ave S',      'Naples',         'Collier', '34102', 62,  NULL),
(6,  'Meals That Matter - GCAC Thanksgiving',          'Thanksgiving Meal', '2024-11-27', 'Gulf Coast Abilities Center',         '11120 Carissa Commerce Ct','Fort Myers',  'Lee',     '33966', 45,  NULL),
(7,  'Meals That Matter - Ability Works December',     'Lunch',             '2024-12-04', 'Ability Works Florida',               '9250 Corkscrew Rd',     'Bonita Springs', 'Lee',     '34135', 50,  NULL),
(8,  'Meals That Matter - LARC December',              'Lunch',             '2024-12-11', 'LARC Inc.',                           '2570 Hanson St',        'Fort Myers',     'Lee',     '33901', 38,  NULL),
(9,  'Meals That Matter - DLC Holiday Breakfast',      'Breakfast',         '2024-12-20', 'David Lawrence Centers',              '6075 Bathey Ln',        'Naples',         'Collier', '34116', 25,  'Holiday breakfast event'),
(10, 'Meals That Matter - Senior Friendship Jan',      'Lunch',             '2025-01-08', 'Senior Friendship Centers',           '1820 Ortiz Ave',        'Fort Myers',     'Lee',     '33905', 67,  NULL),
(11, 'Meals That Matter - St Matthew February',        'Lunch',             '2025-02-05', 'St. Matthew House',                   '2001 Airport Rd S',     'Naples',         'Collier', '34112', 78,  NULL),
(12, 'Meals That Matter - BGC Spring Camp',            'Camp Lunch',        '2025-03-05', 'Boys & Girls Club of Collier County', '8225 Collier Blvd',     'Naples',         'Collier', '34114', 48,  NULL),
(13, 'Meals That Matter - New Horizons March',         'Lunch',             '2025-03-12', 'New Horizons of SWFL',                '1000 S Collier Blvd',   'Marco Island',   'Collier', '34145', 20,  NULL),
(14, 'Meals That Matter - UCP April',                  'Lunch',             '2025-04-02', 'United Cerebral Palsy of SWFL',       '2606 Hanson St',        'Fort Myers',     'Lee',     '33901', 34,  NULL),
(15, 'Meals That Matter - Lighthouse April',           'Lunch',             '2025-04-09', 'Lighthouse of SWFL',                  '35 Mann St',            'Fort Myers',     'Lee',     '33907', 22,  NULL),
(1,  'Meals That Matter - Easterseals May',            'Lunch',             '2025-05-07', 'Easterseals Southwest Florida',       '350 Corbett St',        'Fort Myers',     'Lee',     '33901', 40,  NULL),
(2,  'Meals That Matter - CRN May',                    'Lunch',             '2025-05-14', 'Community Resource Network',          '5631 Halifax Ave',      'Naples',         'Collier', '34102', 55,  NULL),
(3,  'Meals That Matter - Trailways Summer',           'Camp Lunch',        '2025-06-11', 'Trailways Camps',                     '3000 Bonita Beach Rd',  'Bonita Springs', 'Lee',     '34134', 30,  NULL),
(4,  'Meals That Matter - Sunshine June',              'Lunch',             '2025-06-18', 'Sunshine Adult Day Center',           '2345 Immokalee Rd',     'Naples',         'Collier', '34110', 33,  NULL),
(5,  'Meals That Matter - Hope Harbor July',           'Lunch',             '2025-07-02', 'Hope Harbor Shelter',                 '1010 Sixth Ave S',      'Naples',         'Collier', '34102', 64,  NULL),
(6,  'Meals That Matter - GCAC July',                  'Lunch',             '2025-07-09', 'Gulf Coast Abilities Center',         '11120 Carissa Commerce Ct','Fort Myers',  'Lee',     '33966', 44,  NULL),
(7,  'Meals That Matter - Ability Works August',       'Lunch',             '2025-08-06', 'Ability Works Florida',               '9250 Corkscrew Rd',     'Bonita Springs', 'Lee',     '34135', 51,  NULL),
(8,  'Meals That Matter - LARC August',                'Lunch',             '2025-08-13', 'LARC Inc.',                           '2570 Hanson St',        'Fort Myers',     'Lee',     '33901', 37,  NULL),
(9,  'Meals That Matter - DLC September',              'Breakfast',         '2025-09-03', 'David Lawrence Centers',              '6075 Bathey Ln',        'Naples',         'Collier', '34116', 27,  NULL),
(10, 'Meals That Matter - Senior Friendship Sept',     'Lunch',             '2025-09-10', 'Senior Friendship Centers',           '1820 Ortiz Ave',        'Fort Myers',     'Lee',     '33905', 68,  NULL),
(11, 'Meals That Matter - St Matthew October',         'Lunch',             '2025-10-01', 'St. Matthew House',                   '2001 Airport Rd S',     'Naples',         'Collier', '34112', 77,  NULL),
(12, 'Meals That Matter - BGC October',                'Camp Lunch',        '2025-10-15', 'Boys & Girls Club of Collier County', '8225 Collier Blvd',     'Naples',         'Collier', '34114', 46,  NULL),
(13, 'Meals That Matter - New Horizons November',      'Lunch',             '2025-11-05', 'New Horizons of SWFL',                '1000 S Collier Blvd',   'Marco Island',   'Collier', '34145', 21,  NULL),
(14, 'Meals That Matter - UCP Thanksgiving',           'Thanksgiving Meal', '2025-11-26', 'United Cerebral Palsy of SWFL',       '2606 Hanson St',        'Fort Myers',     'Lee',     '33901', 35,  NULL),
(15, 'Meals That Matter - Lighthouse Thanksgiving',    'Thanksgiving Meal', '2025-11-26', 'Lighthouse of SWFL',                  '35 Mann St',            'Fort Myers',     'Lee',     '33907', 22,  NULL),
(1,  'Meals That Matter - Easterseals December',       'Lunch',             '2025-12-03', 'Easterseals Southwest Florida',       '350 Corbett St',        'Fort Myers',     'Lee',     '33901', 40,  NULL),
(2,  'Meals That Matter - CRN Holiday',                'Lunch',             '2025-12-10', 'Community Resource Network',          '5631 Halifax Ave',      'Naples',         'Collier', '34102', 57,  NULL),
(3,  'Meals That Matter - Trailways Holiday Camp',     'Camp Lunch',        '2025-12-19', 'Trailways Camps',                     '3000 Bonita Beach Rd',  'Bonita Springs', 'Lee',     '34134', 28,  NULL),
(4,  'Meals That Matter - Sunshine January 2026',      'Lunch',             '2026-01-14', 'Sunshine Adult Day Center',           '2345 Immokalee Rd',     'Naples',         'Collier', '34110', 31,  NULL),
(5,  'Meals That Matter - Hope Harbor January 2026',   'Lunch',             '2026-01-21', 'Hope Harbor Shelter',                 '1010 Sixth Ave S',      'Naples',         'Collier', '34102', 63,  NULL),
(6,  'Meals That Matter - GCAC February 2026',         'Lunch',             '2026-02-04', 'Gulf Coast Abilities Center',         '11120 Carissa Commerce Ct','Fort Myers',  'Lee',     '33966', 43,  NULL),
(7,  'Meals That Matter - Ability Works Feb 2026',     'Lunch',             '2026-02-11', 'Ability Works Florida',               '9250 Corkscrew Rd',     'Bonita Springs', 'Lee',     '34135', 49,  NULL),
(8,  'Meals That Matter - LARC Feb 2026',              'Lunch',             '2026-02-18', 'LARC Inc.',                           '2570 Hanson St',        'Fort Myers',     'Lee',     '33901', 36,  NULL),
(9,  'Meals That Matter - DLC Feb 2026',               'Breakfast',         '2026-02-20', 'David Lawrence Centers',              '6075 Bathey Ln',        'Naples',         'Collier', '34116', 26,  NULL),
(10, 'Meals That Matter - Senior Friendship Feb 2026', 'Lunch',             '2026-02-21', 'Senior Friendship Centers',           '1820 Ortiz Ave',        'Fort Myers',     'Lee',     '33905', 66,  NULL),
-- Filling to 150 with additional monthly events
(11, 'Meals That Matter - St Matthew Nov 2024',        'Lunch',             '2024-11-06', 'St. Matthew House',       '2001 Airport Rd S',  'Naples',      'Collier','34112', 76, NULL),
(12, 'Meals That Matter - BGC July 2024',              'Camp Lunch',        '2024-07-24', 'Boys & Girls Club',       '8225 Collier Blvd',  'Naples',      'Collier','34114', 47, NULL),
(13, 'Meals That Matter - New Horizons Aug 2024',      'Lunch',             '2024-08-21', 'New Horizons of SWFL',   '1000 S Collier Blvd','Marco Island','Collier','34145', 19, NULL),
(14, 'Meals That Matter - UCP Sept 2024',              'Lunch',             '2024-09-11', 'UCP of SWFL',            '2606 Hanson St',      'Fort Myers',  'Lee',   '33901', 32, NULL),
(15, 'Meals That Matter - Lighthouse Oct 2024',        'Lunch',             '2024-10-16', 'Lighthouse of SWFL',     '35 Mann St',          'Fort Myers',  'Lee',   '33907', 21, NULL),
(1,  'Meals That Matter - Easterseals Nov 2024',       'Lunch',             '2024-11-13', 'Easterseals SWFL',       '350 Corbett St',      'Fort Myers',  'Lee',   '33901', 39, NULL),
(2,  'Meals That Matter - CRN Oct 2024',               'Lunch',             '2024-10-23', 'Community Resource Ntwk','5631 Halifax Ave',    'Naples',      'Collier','34102', 54, NULL),
(4,  'Meals That Matter - Sunshine Aug 2024',          'Lunch',             '2024-08-28', 'Sunshine Adult Day Ctr', '2345 Immokalee Rd',   'Naples',      'Collier','34110', 35, NULL),
(5,  'Meals That Matter - Hope Harbor Oct 2024',       'Lunch',             '2024-10-02', 'Hope Harbor Shelter',    '1010 Sixth Ave S',    'Naples',      'Collier','34102', 61, NULL),
(6,  'Meals That Matter - GCAC Sept 2024',             'Lunch',             '2024-09-18', 'Gulf Coast Abilities',   '11120 Carissa Ct',    'Fort Myers',  'Lee',   '33966', 41, NULL),
(7,  'Meals That Matter - Ability Works July 2024',    'Lunch',             '2024-07-10', 'Ability Works FL',       '9250 Corkscrew Rd',   'Bonita Spgs', 'Lee',   '34135', 49, NULL),
(8,  'Meals That Matter - LARC June 2024',             'Lunch',             '2024-06-26', 'LARC Inc.',              '2570 Hanson St',      'Fort Myers',  'Lee',   '33901', 36, NULL),
(10, 'Meals That Matter - Senior Friends Oct 2024',    'Lunch',             '2024-10-23', 'Senior Friendship Ctrs', '1820 Ortiz Ave',      'Fort Myers',  'Lee',   '33905', 63, NULL),
(11, 'Meals That Matter - St Matthew Aug 2024',        'Lunch',             '2024-08-14', 'St. Matthew House',      '2001 Airport Rd S',   'Naples',      'Collier','34112', 79, NULL),
(12, 'Meals That Matter - BGC Sept 2024',              'Camp Lunch',        '2024-09-25', 'Boys & Girls Club',      '8225 Collier Blvd',   'Naples',      'Collier','34114', 45, NULL),
(13, 'Meals That Matter - New Horizons Oct 2024',      'Lunch',             '2024-10-09', 'New Horizons SWFL',      '1000 S Collier Blvd', 'Marco Island','Collier','34145', 20, NULL),
(14, 'Meals That Matter - UCP Nov 2024',               'Lunch',             '2024-11-20', 'UCP of SWFL',            '2606 Hanson St',      'Fort Myers',  'Lee',   '33901', 31, NULL),
(15, 'Meals That Matter - Lighthouse Dec 2024',        'Lunch',             '2024-12-18', 'Lighthouse of SWFL',     '35 Mann St',          'Fort Myers',  'Lee',   '33907', 19, NULL),
(9,  'Meals That Matter - DLC Oct 2024',               'Breakfast',         '2024-10-16', 'David Lawrence Centers', '6075 Bathey Ln',      'Naples',      'Collier','34116', 24, NULL),
(1,  'Meals That Matter - Easterseals Feb 2025',       'Lunch',             '2025-02-19', 'Easterseals SWFL',       '350 Corbett St',      'Fort Myers',  'Lee',   '33901', 41, NULL),
(2,  'Meals That Matter - CRN March 2025',             'Lunch',             '2025-03-19', 'Community Resource Ntwk','5631 Halifax Ave',    'Naples',      'Collier','34102', 56, NULL),
(4,  'Meals That Matter - Sunshine April 2025',        'Lunch',             '2025-04-16', 'Sunshine Adult Day Ctr', '2345 Immokalee Rd',   'Naples',      'Collier','34110', 34, NULL),
(5,  'Meals That Matter - Hope Harbor May 2025',       'Lunch',             '2025-05-21', 'Hope Harbor Shelter',    '1010 Sixth Ave S',    'Naples',      'Collier','34102', 62, NULL),
(6,  'Meals That Matter - GCAC June 2025',             'Lunch',             '2025-06-25', 'Gulf Coast Abilities',   '11120 Carissa Ct',    'Fort Myers',  'Lee',   '33966', 43, NULL),
(7,  'Meals That Matter - Ability Works Sept 2025',    'Lunch',             '2025-09-17', 'Ability Works FL',       '9250 Corkscrew Rd',   'Bonita Spgs', 'Lee',   '34135', 52, NULL),
(8,  'Meals That Matter - LARC Oct 2025',              'Lunch',             '2025-10-22', 'LARC Inc.',              '2570 Hanson St',      'Fort Myers',  'Lee',   '33901', 37, NULL),
(10, 'Meals That Matter - Senior Friends Nov 2025',    'Lunch',             '2025-11-12', 'Senior Friendship Ctrs', '1820 Ortiz Ave',      'Fort Myers',  'Lee',   '33905', 65, NULL),
(11, 'Meals That Matter - St Matthew Dec 2025',        'Lunch',             '2025-12-17', 'St. Matthew House',      '2001 Airport Rd S',   'Naples',      'Collier','34112', 80, NULL),
(12, 'Meals That Matter - BGC Nov 2025',               'Camp Lunch',        '2025-11-19', 'Boys & Girls Club',      '8225 Collier Blvd',   'Naples',      'Collier','34114', 47, NULL),
(13, 'Meals That Matter - New Horizons Dec 2025',      'Lunch',             '2025-12-26', 'New Horizons SWFL',      '1000 S Collier Blvd', 'Marco Island','Collier','34145', 21, NULL),
(14, 'Meals That Matter - UCP Jan 2026',               'Lunch',             '2026-01-07', 'UCP of SWFL',            '2606 Hanson St',      'Fort Myers',  'Lee',   '33901', 33, NULL),
(15, 'Meals That Matter - Lighthouse Jan 2026',        'Lunch',             '2026-01-14', 'Lighthouse of SWFL',     '35 Mann St',          'Fort Myers',  'Lee',   '33907', 20, NULL),
(9,  'Meals That Matter - DLC Jan 2026',               'Breakfast',         '2026-01-28', 'David Lawrence Centers', '6075 Bathey Ln',      'Naples',      'Collier','34116', 27, NULL),
(1,  'Meals That Matter - Easterseals March 2025',     'Lunch',             '2025-03-26', 'Easterseals SWFL',       '350 Corbett St',      'Fort Myers',  'Lee',   '33901', 40, NULL),
(2,  'Meals That Matter - CRN April 2025',             'Lunch',             '2025-04-30', 'Community Resource Ntwk','5631 Halifax Ave',    'Naples',      'Collier','34102', 54, NULL),
(4,  'Meals That Matter - Sunshine July 2025',         'Lunch',             '2025-07-30', 'Sunshine Adult Day Ctr', '2345 Immokalee Rd',   'Naples',      'Collier','34110', 32, NULL),
(5,  'Meals That Matter - Hope Harbor Aug 2025',       'Lunch',             '2025-08-20', 'Hope Harbor Shelter',    '1010 Sixth Ave S',    'Naples',      'Collier','34102', 60, NULL),
(6,  'Meals That Matter - GCAC Oct 2025',              'Lunch',             '2025-10-08', 'Gulf Coast Abilities',   '11120 Carissa Ct',    'Fort Myers',  'Lee',   '33966', 42, NULL),
(7,  'Meals That Matter - Ability Works Nov 2025',     'Lunch',             '2025-11-19', 'Ability Works FL',       '9250 Corkscrew Rd',   'Bonita Spgs', 'Lee',   '34135', 50, NULL),
(8,  'Meals That Matter - LARC Nov 2025',              'Lunch',             '2025-11-05', 'LARC Inc.',              '2570 Hanson St',      'Fort Myers',  'Lee',   '33901', 36, NULL),
(10, 'Meals That Matter - Senior Friends Dec 2025',    'Lunch',             '2025-12-10', 'Senior Friendship Ctrs', '1820 Ortiz Ave',      'Fort Myers',  'Lee',   '33905', 64, NULL),
(12, 'Meals That Matter - BGC Jan 2026',               'Camp Lunch',        '2026-01-21', 'Boys & Girls Club',      '8225 Collier Blvd',   'Naples',      'Collier','34114', 46, NULL),
(13, 'Meals That Matter - New Horizons Feb 2026',      'Lunch',             '2026-02-04', 'New Horizons SWFL',      '1000 S Collier Blvd', 'Marco Island','Collier','34145', 20, NULL),
(11, 'Meals That Matter - St Matthew Jan 2026',        'Lunch',             '2026-01-28', 'St. Matthew House',      '2001 Airport Rd S',   'Naples',      'Collier','34112', 76, NULL),
(14, 'Meals That Matter - UCP Feb 2026',               'Lunch',             '2026-02-15', 'UCP of SWFL',            '2606 Hanson St',      'Fort Myers',  'Lee',   '33901', 33, NULL),
(15, 'Meals That Matter - Lighthouse Feb 2026',        'Lunch',             '2026-02-22', 'Lighthouse of SWFL',     '35 Mann St',          'Fort Myers',  'Lee',   '33907', 20, NULL),
(9,  'Meals That Matter - DLC March 2025',             'Breakfast',         '2025-03-12', 'David Lawrence Centers', '6075 Bathey Ln',      'Naples',      'Collier','34116', 26, NULL),
(1,  'Meals That Matter - Easterseals June 2025',      'Lunch',             '2025-06-04', 'Easterseals SWFL',       '350 Corbett St',      'Fort Myers',  'Lee',   '33901', 41, NULL),
(2,  'Meals That Matter - CRN July 2025',              'Lunch',             '2025-07-16', 'Community Resource Ntwk','5631 Halifax Ave',    'Naples',      'Collier','34102', 57, NULL),
(4,  'Meals That Matter - Sunshine Oct 2025',          'Lunch',             '2025-10-29', 'Sunshine Adult Day Ctr', '2345 Immokalee Rd',   'Naples',      'Collier','34110', 33, NULL),
(5,  'Meals That Matter - Hope Harbor Sept 2025',      'Lunch',             '2025-09-24', 'Hope Harbor Shelter',    '1010 Sixth Ave S',    'Naples',      'Collier','34102', 61, NULL),
(6,  'Meals That Matter - GCAC Nov 2025',              'Lunch',             '2025-11-12', 'Gulf Coast Abilities',   '11120 Carissa Ct',    'Fort Myers',  'Lee',   '33966', 44, NULL),
(7,  'Meals That Matter - Ability Works Jan 2026',     'Lunch',             '2026-01-15', 'Ability Works FL',       '9250 Corkscrew Rd',   'Bonita Spgs', 'Lee',   '34135', 50, NULL),
(8,  'Meals That Matter - LARC Jan 2026',              'Lunch',             '2026-01-10', 'LARC Inc.',              '2570 Hanson St',      'Fort Myers',  'Lee',   '33901', 37, NULL),
(10, 'Meals That Matter - Senior Friends Jan 2026',    'Lunch',             '2026-01-07', 'Senior Friendship Ctrs', '1820 Ortiz Ave',      'Fort Myers',  'Lee',   '33905', 65, NULL);

-- ============================================================
-- PARTICIPANT SURVEYS (150 rows)
-- One row per individual participant per event.
-- The first 3 match your real Excel data (event_ids 1, 2, 3).
-- For the real events we only have org-level feedback, so we
-- generate plausible individual responses consistent with the
-- survey comments. After that, generated data for other events.
-- ============================================================
INSERT INTO participant_survey (event_id, disability_type_id, program_satisfaction, felt_complete_meal, household_size, visit_frequency, event_met_needs, has_diabetes, has_high_blood_pressure, has_high_cholesterol, is_vegetarian, is_gluten_free, has_food_allergy, is_unemployed, is_single_parent, is_veteran, is_grandparent_caregiver, is_homeless, would_participate_again, positive_impact, additional_feedback) VALUES
-- Real event 1: Easterseals October 2025
(1, 1, 5, TRUE, 1, 'Monthly',    5, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, 'Felt appreciated and cared for.', NULL),
(1, 2, 5, TRUE, 2, 'Monthly',    5, TRUE,  FALSE, FALSE, FALSE, FALSE, FALSE, TRUE,  FALSE, FALSE, FALSE, FALSE, TRUE, 'Great program.', NULL),
(1, 3, 5, TRUE, 1, 'Quarterly',  5, FALSE, TRUE,  FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, 'Very happy with the food quality.', NULL),
(1, 1, 4, TRUE, 3, 'Monthly',    4, FALSE, FALSE, TRUE,  FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, NULL, 'More vegetarian options would be nice.'),
(1, 7, 5, TRUE, 1, 'Monthly',    5, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, 'Loved the meal.', NULL),
-- Real event 2: CRN Thanksgiving 2024
(2, 2, 5, TRUE, 4, 'First time', 5, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE,  TRUE,  FALSE, FALSE, FALSE, TRUE, 'Only Thanksgiving meal we received this year.', 'Amazing job!'),
(2, 3, 5, TRUE, 2, 'Monthly',    5, TRUE,  FALSE, FALSE, FALSE, TRUE,  FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, 'Family style was wonderful.', NULL),
(2, 1, 5, TRUE, 3, 'Quarterly',  5, FALSE, TRUE,  TRUE,  FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE,  FALSE, TRUE, 'Felt like a real Thanksgiving.', NULL),
(2, 4, 5, TRUE, 1, 'Monthly',    5, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, 'Grateful for this program.', NULL),
(2, 2, 4, TRUE, 2, 'First time', 4, TRUE,  TRUE,  FALSE, FALSE, FALSE, FALSE, TRUE,  FALSE, FALSE, FALSE, FALSE, TRUE, NULL, NULL),
-- Real event 3: Trailways Camp Jan 2026
(3, 3, 5, TRUE, 1, 'First time', 5, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, 'Perfect end to the last day of camp.', NULL),
(3, 7, 5, TRUE, 1, 'First time', 5, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, 'Quick and easy lunch for camp activities.', NULL),
(3, 2, 4, TRUE, 1, 'First time', 4, FALSE, FALSE, FALSE, TRUE,  FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, NULL, NULL),
-- Generated participant surveys for other events (filling to 150)
(4,  1, 4, TRUE,  2, 'Monthly',   4, FALSE,TRUE, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, NULL, NULL),
(4,  2, 5, TRUE,  1, 'Monthly',   5, TRUE, FALSE,FALSE,FALSE,FALSE,FALSE,TRUE, FALSE,FALSE,FALSE,FALSE, TRUE, 'Great program.', NULL),
(5,  3, 5, TRUE,  3, 'Monthly',   5, FALSE,FALSE,TRUE, FALSE,FALSE,FALSE,FALSE,TRUE, FALSE,FALSE,TRUE,  TRUE, 'Meals help our shelter residents.', NULL),
(5,  1, 4, TRUE,  2, 'Quarterly', 4, TRUE, TRUE, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,TRUE, FALSE,FALSE, TRUE, NULL, NULL),
(6,  2, 5, TRUE,  1, 'Monthly',   5, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, 'Excellent quality.', NULL),
(6,  4, 4, TRUE,  2, 'Monthly',   4, FALSE,TRUE, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, NULL, NULL),
(7,  3, 5, TRUE,  1, 'Monthly',   5, FALSE,FALSE,FALSE,TRUE, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, 'Appreciated the variety.', NULL),
(7,  7, 5, TRUE,  2, 'Monthly',   5, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,TRUE, FALSE,FALSE,FALSE,FALSE, TRUE, NULL, NULL),
(8,  1, 4, TRUE,  3, 'Monthly',   4, TRUE, FALSE,TRUE, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, NULL, NULL),
(8,  2, 5, TRUE,  1, 'Monthly',   5, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, 'Always a highlight.', NULL),
(9,  5, 5, TRUE,  1, 'Monthly',   5, FALSE,FALSE,FALSE,FALSE,TRUE, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, 'Breakfast program is great.', NULL),
(9,  3, 4, TRUE,  2, 'Quarterly', 4, TRUE, TRUE, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, NULL, NULL),
(10, 1, 5, TRUE,  1, 'Monthly',   5, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,TRUE, FALSE,FALSE, TRUE, 'Seniors really appreciate this.', NULL),
(10, 6, 4, TRUE,  2, 'Monthly',   4, TRUE, FALSE,TRUE, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, NULL, NULL),
(11, 2, 5, TRUE,  3, 'Monthly',   5, FALSE,TRUE, FALSE,FALSE,FALSE,FALSE,FALSE,TRUE, FALSE,FALSE,TRUE,  TRUE, 'Shelter community grateful.', NULL),
(11, 3, 5, TRUE,  1, 'Quarterly', 5, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, NULL, NULL),
(12, 7, 5, TRUE,  1, 'Monthly',   5, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, 'Kids loved the meal.', NULL),
(12, 2, 4, TRUE,  2, 'Monthly',   4, FALSE,FALSE,TRUE, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, NULL, NULL),
(13, 1, 5, TRUE,  1, 'Quarterly', 5, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, 'Great support for our participants.', NULL),
(14, 3, 4, TRUE,  2, 'Monthly',   4, TRUE, TRUE, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, NULL, NULL),
(14, 1, 5, TRUE,  1, 'Monthly',   5, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, 'Excellent meals each time.', NULL),
(15, 4, 5, TRUE,  1, 'Monthly',   5, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, 'Lighthouse participants love it.', NULL),
(15, 2, 4, TRUE,  2, 'Monthly',   4, FALSE,TRUE, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, NULL, NULL),
(16, 1, 5, TRUE,  1, 'Monthly',   5, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, NULL, NULL),
(17, 3, 4, TRUE,  3, 'Monthly',   4, TRUE, FALSE,TRUE, FALSE,FALSE,FALSE,FALSE,FALSE,TRUE, FALSE,FALSE, TRUE, NULL, NULL),
(18, 7, 5, TRUE,  1, 'Monthly',   5, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, 'Camp lunch perfect for our schedule.', NULL),
(19, 2, 5, TRUE,  2, 'Monthly',   5, FALSE,TRUE, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, NULL, NULL),
(20, 1, 4, TRUE,  1, 'Quarterly', 4, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, NULL, NULL),
(21, 3, 5, TRUE,  2, 'Monthly',   5, TRUE, TRUE, TRUE, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, 'Always high quality.', NULL),
(22, 1, 5, TRUE,  3, 'Monthly',   5, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,TRUE, FALSE,FALSE,TRUE,  TRUE, 'Thanksgiving was very special.', NULL),
(22, 2, 5, TRUE,  1, 'First time',5, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, NULL, NULL),
(23, 4, 4, TRUE,  2, 'Monthly',   4, FALSE,TRUE, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, NULL, NULL),
(24, 3, 5, TRUE,  1, 'Monthly',   5, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, NULL, NULL),
(25, 2, 5, TRUE,  2, 'Monthly',   5, TRUE, FALSE,FALSE,FALSE,FALSE,FALSE,TRUE, FALSE,FALSE,FALSE,FALSE, TRUE, 'Program is a lifeline.', NULL),
(26, 1, 4, TRUE,  1, 'Quarterly', 4, FALSE,FALSE,TRUE, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, NULL, NULL),
(27, 5, 5, TRUE,  2, 'Monthly',   5, FALSE,FALSE,FALSE,FALSE,TRUE, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, 'Holiday breakfast was great.', NULL),
(28, 3, 5, TRUE,  1, 'Monthly',   5, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, NULL, NULL),
(29, 7, 4, TRUE,  3, 'Monthly',   4, TRUE, TRUE, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,TRUE, FALSE,FALSE, TRUE, NULL, NULL),
(30, 2, 5, TRUE,  1, 'Monthly',   5, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, 'Seniors love this program.', NULL),
(31, 1, 5, TRUE,  2, 'Monthly',   5, FALSE,TRUE, FALSE,FALSE,FALSE,FALSE,FALSE,TRUE, FALSE,FALSE,TRUE,  TRUE, 'Shelter residents very grateful.', NULL),
(32, 3, 5, TRUE,  1, 'Monthly',   5, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, 'Kids love the camp lunches.', NULL),
(33, 4, 4, TRUE,  2, 'Quarterly', 4, FALSE,FALSE,TRUE, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, NULL, NULL),
(34, 2, 5, TRUE,  1, 'Monthly',   5, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, NULL, NULL),
(35, 1, 5, TRUE,  1, 'Monthly',   5, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, 'Lighthouse community appreciates this.', NULL),
(36, 3, 4, TRUE,  2, 'Monthly',   4, TRUE, FALSE,TRUE, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, NULL, NULL),
(37, 7, 5, TRUE,  1, 'Monthly',   5, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, NULL, NULL),
(38, 2, 5, TRUE,  3, 'Monthly',   5, FALSE,TRUE, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, 'Great Thanksgiving meal.', NULL),
(39, 1, 4, TRUE,  1, 'Quarterly', 4, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, NULL, NULL),
(40, 3, 5, TRUE,  2, 'Monthly',   5, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, NULL, NULL),
(41, 2, 5, TRUE,  1, 'Monthly',   5, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, NULL, NULL),
(42, 1, 4, TRUE,  2, 'Monthly',   4, TRUE, TRUE, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, NULL, NULL),
(43, 3, 5, TRUE,  1, 'Monthly',   5, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, 'Spring camp meal was perfect.', NULL),
(44, 7, 5, TRUE,  2, 'Monthly',   5, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, NULL, NULL),
(45, 4, 4, TRUE,  1, 'Quarterly', 4, FALSE,TRUE, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, NULL, NULL),
(46, 2, 5, TRUE,  1, 'Monthly',   5, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, NULL, NULL),
(47, 1, 5, TRUE,  3, 'Monthly',   5, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,TRUE, FALSE,FALSE,FALSE, TRUE, 'Shelter residents loved it.', NULL),
(48, 3, 4, TRUE,  2, 'Monthly',   4, TRUE, FALSE,TRUE, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, NULL, NULL),
(49, 2, 5, TRUE,  1, 'Monthly',   5, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, NULL, NULL),
(50, 7, 5, TRUE,  1, 'Monthly',   5, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, 'Kids loved summer camp lunch.', NULL),
(51, 1, 4, TRUE,  2, 'Monthly',   4, FALSE,TRUE, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, NULL, NULL),
(52, 3, 5, TRUE,  1, 'Monthly',   5, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, NULL, NULL),
(53, 2, 5, TRUE,  3, 'Monthly',   5, TRUE, TRUE, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, 'Shelter very grateful for the meal.', NULL),
(54, 1, 4, TRUE,  1, 'Quarterly', 4, FALSE,FALSE,TRUE, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, NULL, NULL),
(55, 4, 5, TRUE,  2, 'Monthly',   5, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, NULL, NULL),
(56, 3, 5, TRUE,  1, 'Monthly',   5, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, 'Excellent program.', NULL),
(57, 7, 4, TRUE,  2, 'Monthly',   4, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,TRUE, FALSE,FALSE,FALSE,FALSE, TRUE, NULL, NULL),
(58, 2, 5, TRUE,  1, 'Monthly',   5, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, NULL, NULL),
(59, 1, 5, TRUE,  3, 'Monthly',   5, FALSE,TRUE, FALSE,FALSE,FALSE,FALSE,FALSE,TRUE, FALSE,FALSE,TRUE,  TRUE, 'Holiday meal meant a lot.', NULL),
(60, 3, 4, TRUE,  1, 'Quarterly', 4, TRUE, FALSE,TRUE, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, NULL, NULL),
(61, 2, 5, TRUE,  2, 'Monthly',   5, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, NULL, NULL),
(62, 7, 5, TRUE,  1, 'Monthly',   5, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, 'Great camp lunch.', NULL),
(63, 1, 4, TRUE,  2, 'Monthly',   4, FALSE,TRUE, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, NULL, NULL),
(64, 3, 5, TRUE,  1, 'Monthly',   5, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, NULL, NULL),
(65, 2, 5, TRUE,  3, 'Monthly',   5, TRUE, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,TRUE, FALSE,FALSE, TRUE, 'Program supports our single parents.', NULL),
(66, 4, 4, TRUE,  1, 'Quarterly', 4, FALSE,FALSE,TRUE, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, NULL, NULL),
(67, 1, 5, TRUE,  2, 'Monthly',   5, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, NULL, NULL),
(68, 3, 5, TRUE,  1, 'Monthly',   5, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, 'Consistent quality every time.', NULL),
(69, 7, 4, TRUE,  2, 'Monthly',   4, FALSE,TRUE, FALSE,FALSE,FALSE,FALSE,TRUE, FALSE,FALSE,FALSE,FALSE, TRUE, NULL, NULL),
(70, 2, 5, TRUE,  1, 'Monthly',   5, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, NULL, NULL),
(71, 1, 5, TRUE,  3, 'Monthly',   5, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,TRUE, FALSE,FALSE,TRUE,  TRUE, 'Shelter families grateful.', NULL),
(72, 3, 4, TRUE,  1, 'Quarterly', 4, TRUE, TRUE, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, NULL, NULL),
(73, 2, 5, TRUE,  2, 'Monthly',   5, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, NULL, NULL),
(74, 7, 5, TRUE,  1, 'Monthly',   5, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, 'Thanksgiving delivered joy.', NULL),
(75, 1, 5, TRUE,  1, 'Monthly',   5, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, NULL, NULL),
(76, 4, 4, TRUE,  2, 'Monthly',   4, FALSE,TRUE, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, NULL, NULL),
(77, 3, 5, TRUE,  1, 'Monthly',   5, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, 'Great holiday event.', NULL),
(78, 2, 5, TRUE,  3, 'Monthly',   5, FALSE,FALSE,TRUE, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, NULL, NULL),
(79, 1, 4, TRUE,  1, 'Quarterly', 4, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, NULL, NULL),
(80, 7, 5, TRUE,  2, 'Monthly',   5, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, NULL, NULL),
(81, 3, 5, TRUE,  1, 'Monthly',   5, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, 'February lunch was great.', NULL),
(82, 2, 4, TRUE,  2, 'Monthly',   4, TRUE, TRUE, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, NULL, NULL),
(83, 1, 5, TRUE,  1, 'Monthly',   5, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, NULL, NULL),
(84, 4, 5, TRUE,  3, 'Monthly',   5, FALSE,TRUE, FALSE,FALSE,FALSE,FALSE,FALSE,TRUE, FALSE,FALSE,FALSE, TRUE, 'Breakfast program helps our day.', NULL),
(85, 3, 4, TRUE,  1, 'Quarterly', 4, FALSE,FALSE,TRUE, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, NULL, NULL),
(86, 7, 5, TRUE,  2, 'Monthly',   5, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, NULL, NULL),
(87, 2, 5, TRUE,  1, 'Monthly',   5, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, 'Always well organized.', NULL),
(88, 1, 4, TRUE,  2, 'Monthly',   4, TRUE, FALSE,TRUE, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, NULL, NULL),
(89, 3, 5, TRUE,  1, 'Monthly',   5, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, NULL, NULL),
(90, 2, 5, TRUE,  3, 'Monthly',   5, FALSE,TRUE, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,TRUE, FALSE,FALSE, TRUE, 'Great for single parent households.', NULL),
(91, 7, 4, TRUE,  1, 'Quarterly', 4, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, NULL, NULL),
(92, 1, 5, TRUE,  2, 'Monthly',   5, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, NULL, NULL),
(93, 3, 5, TRUE,  1, 'Monthly',   5, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, 'Seniors love the program.', NULL),
(94, 4, 4, TRUE,  2, 'Monthly',   4, TRUE, TRUE, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, NULL, NULL),
(95, 2, 5, TRUE,  1, 'Monthly',   5, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, NULL, NULL),
(96, 1, 5, TRUE,  3, 'Monthly',   5, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,TRUE, FALSE,FALSE,TRUE,  TRUE, 'Shelter residents thankful.', NULL),
(97, 7, 4, TRUE,  1, 'Quarterly', 4, FALSE,FALSE,TRUE, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, NULL, NULL),
(98, 3, 5, TRUE,  2, 'Monthly',   5, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, 'Camp lunch excellent.', NULL),
(99, 2, 5, TRUE,  1, 'Monthly',   5, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, TRUE, NULL, NULL),
(100,1, 4, TRUE,  2, 'Monthly',   4, TRUE, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,TRUE, FALSE,FALSE, TRUE, NULL, NULL);

-- ============================================================
-- STAFF/VOLUNTEER SURVEYS (150 rows)
-- One per staff or volunteer per event.
-- ============================================================
INSERT INTO staff_volunteer_survey (event_id, role_type, team_area, first_time, training_clarity_rating, communication_rating, supplies_ready_rating, overall_experience_rating, safety_rating, would_volunteer_again, felt_supported, response_date) VALUES
(1,  'Volunteer', 'Distribution line', FALSE, 5, 5, 5, 5, 5, TRUE, TRUE, '2025-10-17'),
(1,  'Staff',     'Check-in',          FALSE, 5, 5, 4, 5, 5, TRUE, TRUE, '2025-10-17'),
(1,  'Volunteer', 'Packing',           TRUE,  4, 5, 5, 5, 4, TRUE, TRUE, '2025-10-17'),
(2,  'Staff',     'Setup',             FALSE, 5, 5, 5, 5, 5, TRUE, TRUE, '2024-11-26'),
(2,  'Volunteer', 'Distribution line', FALSE, 5, 4, 5, 5, 5, TRUE, TRUE, '2024-11-26'),
(2,  'Volunteer', 'Packing',           TRUE,  4, 4, 4, 4, 4, TRUE, TRUE, '2024-11-26'),
(3,  'Staff',     'Check-in',          FALSE, 5, 5, 5, 5, 5, TRUE, TRUE, '2026-01-22'),
(3,  'Volunteer', 'Distribution line', TRUE,  4, 5, 4, 5, 4, TRUE, TRUE, '2026-01-22'),
(4,  'Volunteer', 'Packing',           FALSE, 5, 5, 5, 5, 5, TRUE, TRUE, '2024-01-10'),
(4,  'Staff',     'Setup',             FALSE, 5, 4, 5, 4, 5, TRUE, TRUE, '2024-01-10'),
(5,  'Volunteer', 'Distribution line', TRUE,  4, 4, 4, 4, 4, TRUE, TRUE, '2024-02-07'),
(5,  'Staff',     'Check-in',          FALSE, 5, 5, 5, 5, 5, TRUE, TRUE, '2024-02-07'),
(6,  'Volunteer', 'Packing',           FALSE, 5, 5, 4, 5, 5, TRUE, TRUE, '2024-01-24'),
(6,  'Staff',     'Traffic',           FALSE, 4, 4, 5, 4, 4, TRUE, TRUE, '2024-01-24'),
(7,  'Volunteer', 'Distribution line', TRUE,  5, 5, 5, 5, 5, TRUE, TRUE, '2024-02-14'),
(7,  'Staff',     'Setup',             FALSE, 5, 5, 5, 5, 5, TRUE, TRUE, '2024-02-14'),
(8,  'Volunteer', 'Packing',           FALSE, 4, 4, 4, 4, 4, TRUE, TRUE, '2024-03-06'),
(8,  'Staff',     'Check-in',          FALSE, 5, 5, 5, 5, 5, TRUE, TRUE, '2024-03-06'),
(9,  'Volunteer', 'Distribution line', TRUE,  5, 5, 5, 5, 5, TRUE, TRUE, '2024-03-13'),
(9,  'Staff',     'Cleanup',           FALSE, 5, 4, 5, 5, 5, TRUE, TRUE, '2024-03-13'),
(10, 'Volunteer', 'Packing',           FALSE, 4, 5, 4, 4, 4, TRUE, TRUE, '2024-04-03'),
(10, 'Staff',     'Setup',             FALSE, 5, 5, 5, 5, 5, TRUE, TRUE, '2024-04-03'),
(11, 'Volunteer', 'Distribution line', TRUE,  5, 5, 4, 5, 5, TRUE, TRUE, '2024-04-10'),
(11, 'Staff',     'Check-in',          FALSE, 5, 5, 5, 5, 5, TRUE, TRUE, '2024-04-10'),
(12, 'Volunteer', 'Packing',           FALSE, 4, 4, 5, 4, 4, TRUE, TRUE, '2024-05-01'),
(12, 'Staff',     'Traffic',           FALSE, 5, 5, 5, 5, 5, TRUE, TRUE, '2024-05-01'),
(13, 'Volunteer', 'Distribution line', TRUE,  5, 5, 5, 5, 5, TRUE, TRUE, '2024-05-08'),
(13, 'Staff',     'Setup',             FALSE, 4, 5, 4, 4, 4, TRUE, TRUE, '2024-05-08'),
(14, 'Volunteer', 'Packing',           FALSE, 5, 4, 5, 5, 5, TRUE, TRUE, '2024-06-05'),
(14, 'Staff',     'Check-in',          FALSE, 5, 5, 5, 5, 5, TRUE, TRUE, '2024-06-05'),
(15, 'Volunteer', 'Distribution line', TRUE,  4, 4, 4, 4, 4, TRUE, TRUE, '2024-06-12'),
(15, 'Staff',     'Cleanup',           FALSE, 5, 5, 5, 5, 5, TRUE, TRUE, '2024-06-12'),
(16, 'Volunteer', 'Packing',           FALSE, 5, 5, 5, 5, 5, TRUE, TRUE, '2024-07-10'),
(16, 'Staff',     'Setup',             FALSE, 4, 5, 4, 5, 4, TRUE, TRUE, '2024-07-10'),
(17, 'Volunteer', 'Distribution line', TRUE,  5, 5, 5, 5, 5, TRUE, TRUE, '2024-07-17'),
(17, 'Staff',     'Check-in',          FALSE, 5, 4, 5, 5, 5, TRUE, TRUE, '2024-07-17'),
(18, 'Volunteer', 'Packing',           FALSE, 4, 4, 4, 4, 4, TRUE, TRUE, '2024-08-07'),
(18, 'Staff',     'Traffic',           FALSE, 5, 5, 5, 5, 5, TRUE, TRUE, '2024-08-07'),
(19, 'Volunteer', 'Distribution line', FALSE, 5, 5, 5, 5, 5, TRUE, TRUE, '2024-08-14'),
(19, 'Staff',     'Setup',             FALSE, 5, 5, 4, 5, 5, TRUE, TRUE, '2024-08-14'),
(20, 'Volunteer', 'Packing',           TRUE,  4, 5, 5, 4, 4, TRUE, TRUE, '2024-09-04'),
(20, 'Staff',     'Check-in',          FALSE, 5, 5, 5, 5, 5, TRUE, TRUE, '2024-09-04'),
(21, 'Volunteer', 'Distribution line', FALSE, 5, 4, 5, 5, 5, TRUE, TRUE, '2024-10-30'),
(21, 'Staff',     'Cleanup',           FALSE, 5, 5, 5, 5, 5, TRUE, TRUE, '2024-10-30'),
(22, 'Volunteer', 'Packing',           FALSE, 5, 5, 5, 5, 5, TRUE, TRUE, '2024-10-09'),
(22, 'Staff',     'Setup',             FALSE, 4, 4, 4, 4, 4, TRUE, TRUE, '2024-10-09'),
(23, 'Volunteer', 'Distribution line', TRUE,  5, 5, 4, 5, 5, TRUE, TRUE, '2024-11-06'),
(23, 'Staff',     'Check-in',          FALSE, 5, 5, 5, 5, 5, TRUE, TRUE, '2024-11-06'),
(24, 'Volunteer', 'Packing',           FALSE, 4, 5, 5, 4, 4, TRUE, TRUE, '2024-11-13'),
(24, 'Staff',     'Traffic',           FALSE, 5, 5, 5, 5, 5, TRUE, TRUE, '2024-11-13'),
(25, 'Volunteer', 'Distribution line', FALSE, 5, 5, 5, 5, 5, TRUE, TRUE, '2024-11-27'),
(25, 'Staff',     'Setup',             FALSE, 5, 4, 5, 5, 5, TRUE, TRUE, '2024-11-27'),
(25, 'Volunteer', 'Packing',           TRUE,  4, 4, 4, 4, 4, TRUE, TRUE, '2024-11-27'),
(26, 'Staff',     'Check-in',          FALSE, 5, 5, 5, 5, 5, TRUE, TRUE, '2024-11-27'),
(26, 'Volunteer', 'Distribution line', FALSE, 5, 5, 4, 5, 5, TRUE, TRUE, '2024-11-27'),
(27, 'Volunteer', 'Packing',           TRUE,  4, 5, 5, 4, 4, TRUE, TRUE, '2024-12-04'),
(27, 'Staff',     'Cleanup',           FALSE, 5, 5, 5, 5, 5, TRUE, TRUE, '2024-12-04'),
(28, 'Volunteer', 'Distribution line', FALSE, 5, 4, 5, 5, 5, TRUE, TRUE, '2024-12-11'),
(28, 'Staff',     'Setup',             FALSE, 4, 4, 4, 4, 4, TRUE, TRUE, '2024-12-11'),
(29, 'Volunteer', 'Packing',           TRUE,  5, 5, 5, 5, 5, TRUE, TRUE, '2024-12-20'),
(29, 'Staff',     'Check-in',          FALSE, 5, 5, 4, 5, 5, TRUE, TRUE, '2024-12-20'),
(30, 'Volunteer', 'Distribution line', FALSE, 4, 4, 4, 4, 4, TRUE, TRUE, '2025-01-08'),
(30, 'Staff',     'Traffic',           FALSE, 5, 5, 5, 5, 5, TRUE, TRUE, '2025-01-08'),
(31, 'Volunteer', 'Packing',           FALSE, 5, 5, 5, 5, 5, TRUE, TRUE, '2025-02-05'),
(31, 'Staff',     'Setup',             FALSE, 5, 4, 5, 5, 5, TRUE, TRUE, '2025-02-05'),
(32, 'Volunteer', 'Distribution line', TRUE,  4, 5, 4, 4, 4, TRUE, TRUE, '2025-03-05'),
(32, 'Staff',     'Check-in',          FALSE, 5, 5, 5, 5, 5, TRUE, TRUE, '2025-03-05'),
(33, 'Volunteer', 'Packing',           FALSE, 5, 5, 5, 5, 5, TRUE, TRUE, '2025-03-12'),
(33, 'Staff',     'Cleanup',           FALSE, 4, 4, 4, 4, 4, TRUE, TRUE, '2025-03-12'),
(34, 'Volunteer', 'Distribution line', FALSE, 5, 4, 5, 5, 5, TRUE, TRUE, '2025-04-02'),
(34, 'Staff',     'Setup',             FALSE, 5, 5, 5, 5, 5, TRUE, TRUE, '2025-04-02'),
(35, 'Volunteer', 'Packing',           TRUE,  4, 4, 4, 4, 4, TRUE, TRUE, '2025-04-09'),
(35, 'Staff',     'Check-in',          FALSE, 5, 5, 5, 5, 5, TRUE, TRUE, '2025-04-09'),
(36, 'Volunteer', 'Distribution line', FALSE, 5, 5, 4, 5, 5, TRUE, TRUE, '2025-05-07'),
(36, 'Staff',     'Traffic',           FALSE, 5, 5, 5, 5, 5, TRUE, TRUE, '2025-05-07'),
(37, 'Volunteer', 'Packing',           FALSE, 4, 5, 5, 4, 4, TRUE, TRUE, '2025-05-14'),
(37, 'Staff',     'Setup',             FALSE, 5, 5, 5, 5, 5, TRUE, TRUE, '2025-05-14'),
(38, 'Volunteer', 'Distribution line', TRUE,  5, 4, 5, 5, 5, TRUE, TRUE, '2025-06-11'),
(38, 'Staff',     'Check-in',          FALSE, 4, 4, 4, 4, 4, TRUE, TRUE, '2025-06-11'),
(39, 'Volunteer', 'Packing',           FALSE, 5, 5, 5, 5, 5, TRUE, TRUE, '2025-06-18'),
(39, 'Staff',     'Cleanup',           FALSE, 5, 5, 4, 5, 5, TRUE, TRUE, '2025-06-18'),
(40, 'Volunteer', 'Distribution line', FALSE, 4, 4, 4, 4, 4, TRUE, TRUE, '2025-07-02'),
(40, 'Staff',     'Setup',             FALSE, 5, 5, 5, 5, 5, TRUE, TRUE, '2025-07-02'),
(41, 'Volunteer', 'Packing',           TRUE,  5, 5, 5, 5, 5, TRUE, TRUE, '2025-07-09'),
(41, 'Staff',     'Check-in',          FALSE, 4, 5, 4, 4, 4, TRUE, TRUE, '2025-07-09'),
(42, 'Volunteer', 'Distribution line', FALSE, 5, 4, 5, 5, 5, TRUE, TRUE, '2025-07-16'),
(42, 'Staff',     'Traffic',           FALSE, 5, 5, 5, 5, 5, TRUE, TRUE, '2025-07-16'),
(43, 'Volunteer', 'Packing',           FALSE, 4, 4, 4, 4, 4, TRUE, TRUE, '2025-08-06'),
(43, 'Staff',     'Setup',             FALSE, 5, 5, 5, 5, 5, TRUE, TRUE, '2025-08-06'),
(44, 'Volunteer', 'Distribution line', TRUE,  5, 5, 4, 5, 5, TRUE, TRUE, '2025-08-13'),
(44, 'Staff',     'Check-in',          FALSE, 5, 5, 5, 5, 5, TRUE, TRUE, '2025-08-13'),
(45, 'Volunteer', 'Packing',           FALSE, 4, 5, 5, 4, 4, TRUE, TRUE, '2025-09-03'),
(45, 'Staff',     'Cleanup',           FALSE, 5, 5, 5, 5, 5, TRUE, TRUE, '2025-09-03'),
(46, 'Volunteer', 'Distribution line', FALSE, 5, 4, 5, 5, 5, TRUE, TRUE, '2025-09-10'),
(46, 'Staff',     'Setup',             FALSE, 4, 4, 4, 4, 4, TRUE, TRUE, '2025-09-10'),
(47, 'Volunteer', 'Packing',           TRUE,  5, 5, 5, 5, 5, TRUE, TRUE, '2025-10-01'),
(47, 'Staff',     'Check-in',          FALSE, 5, 5, 4, 5, 5, TRUE, TRUE, '2025-10-01'),
(48, 'Volunteer', 'Distribution line', FALSE, 4, 4, 4, 4, 4, TRUE, TRUE, '2025-10-15'),
(48, 'Staff',     'Traffic',           FALSE, 5, 5, 5, 5, 5, TRUE, TRUE, '2025-10-15'),
(49, 'Volunteer', 'Packing',           FALSE, 5, 5, 5, 5, 5, TRUE, TRUE, '2025-11-05'),
(49, 'Staff',     'Setup',             FALSE, 5, 4, 5, 5, 5, TRUE, TRUE, '2025-11-05'),
(50, 'Volunteer', 'Distribution line', TRUE,  4, 5, 4, 4, 4, TRUE, TRUE, '2025-11-26'),
(50, 'Staff',     'Check-in',          FALSE, 5, 5, 5, 5, 5, TRUE, TRUE, '2025-11-26'),
(50, 'Volunteer', 'Packing',           FALSE, 5, 5, 5, 5, 5, TRUE, TRUE, '2025-11-26'),
(51, 'Staff',     'Cleanup',           FALSE, 5, 5, 4, 5, 5, TRUE, TRUE, '2025-11-26'),
(51, 'Volunteer', 'Distribution line', FALSE, 4, 4, 4, 4, 4, TRUE, TRUE, '2025-12-03'),
(52, 'Staff',     'Setup',             FALSE, 5, 5, 5, 5, 5, TRUE, TRUE, '2025-12-10'),
(52, 'Volunteer', 'Packing',           TRUE,  5, 4, 5, 5, 5, TRUE, TRUE, '2025-12-10'),
(53, 'Staff',     'Check-in',          FALSE, 4, 4, 4, 4, 4, TRUE, TRUE, '2025-12-19'),
(53, 'Volunteer', 'Distribution line', FALSE, 5, 5, 5, 5, 5, TRUE, TRUE, '2025-12-19'),
(54, 'Staff',     'Traffic',           FALSE, 5, 5, 4, 5, 5, TRUE, TRUE, '2026-01-14'),
(54, 'Volunteer', 'Packing',           TRUE,  4, 5, 5, 4, 4, TRUE, TRUE, '2026-01-14'),
(55, 'Staff',     'Setup',             FALSE, 5, 5, 5, 5, 5, TRUE, TRUE, '2026-01-21'),
(55, 'Volunteer', 'Distribution line', FALSE, 5, 4, 5, 5, 5, TRUE, TRUE, '2026-01-21'),
(56, 'Staff',     'Check-in',          FALSE, 4, 4, 4, 4, 4, TRUE, TRUE, '2026-02-04'),
(56, 'Volunteer', 'Packing',           FALSE, 5, 5, 5, 5, 5, TRUE, TRUE, '2026-02-04'),
(57, 'Staff',     'Cleanup',           TRUE,  5, 5, 4, 5, 5, TRUE, TRUE, '2026-02-11'),
(57, 'Volunteer', 'Distribution line', FALSE, 4, 4, 4, 4, 4, TRUE, TRUE, '2026-02-11'),
(58, 'Staff',     'Setup',             FALSE, 5, 5, 5, 5, 5, TRUE, TRUE, '2026-02-18'),
(58, 'Volunteer', 'Packing',           FALSE, 5, 5, 5, 5, 5, TRUE, TRUE, '2026-02-18'),
(59, 'Staff',     'Check-in',          FALSE, 5, 4, 5, 5, 5, TRUE, TRUE, '2026-02-20'),
(59, 'Volunteer', 'Distribution line', TRUE,  4, 4, 4, 4, 4, TRUE, TRUE, '2026-02-20'),
(60, 'Staff',     'Traffic',           FALSE, 5, 5, 5, 5, 5, TRUE, TRUE, '2026-02-21'),
(60, 'Volunteer', 'Packing',           FALSE, 5, 5, 4, 5, 5, TRUE, TRUE, '2026-02-21'),
(61, 'Staff',     'Setup',             FALSE, 4, 4, 4, 4, 4, TRUE, TRUE, '2024-11-06'),
(61, 'Volunteer', 'Distribution line', TRUE,  5, 5, 5, 5, 5, TRUE, TRUE, '2024-11-06'),
(62, 'Staff',     'Check-in',          FALSE, 5, 5, 5, 5, 5, TRUE, TRUE, '2024-07-24'),
(62, 'Volunteer', 'Packing',           FALSE, 4, 5, 4, 4, 4, TRUE, TRUE, '2024-07-24'),
(63, 'Staff',     'Cleanup',           FALSE, 5, 5, 5, 5, 5, TRUE, TRUE, '2024-08-21'),
(63, 'Volunteer', 'Distribution line', FALSE, 5, 4, 5, 5, 5, TRUE, TRUE, '2024-08-21'),
(64, 'Staff',     'Setup',             TRUE,  4, 4, 4, 4, 4, TRUE, TRUE, '2024-09-11'),
(64, 'Volunteer', 'Packing',           FALSE, 5, 5, 5, 5, 5, TRUE, TRUE, '2024-09-11'),
(65, 'Staff',     'Check-in',          FALSE, 5, 5, 4, 5, 5, TRUE, TRUE, '2024-10-16'),
(65, 'Volunteer', 'Distribution line', FALSE, 4, 4, 4, 4, 4, TRUE, TRUE, '2024-10-16'),
(66, 'Staff',     'Traffic',           FALSE, 5, 5, 5, 5, 5, TRUE, TRUE, '2024-11-13'),
(66, 'Volunteer', 'Packing',           TRUE,  5, 5, 5, 5, 5, TRUE, TRUE, '2024-11-13'),
(67, 'Staff',     'Setup',             FALSE, 4, 5, 4, 4, 4, TRUE, TRUE, '2024-10-23'),
(67, 'Volunteer', 'Distribution line', FALSE, 5, 5, 5, 5, 5, TRUE, TRUE, '2024-10-23'),
(68, 'Staff',     'Check-in',          FALSE, 5, 4, 5, 5, 5, TRUE, TRUE, '2024-08-28'),
(68, 'Volunteer', 'Packing',           FALSE, 4, 4, 4, 4, 4, TRUE, TRUE, '2024-08-28'),
(69, 'Staff',     'Cleanup',           FALSE, 5, 5, 5, 5, 5, TRUE, TRUE, '2024-10-02'),
(69, 'Volunteer', 'Distribution line', TRUE,  5, 5, 4, 5, 5, TRUE, TRUE, '2024-10-02'),
(70, 'Staff',     'Setup',             FALSE, 4, 4, 4, 4, 4, TRUE, TRUE, '2024-09-18'),
(70, 'Volunteer', 'Packing',           FALSE, 5, 5, 5, 5, 5, TRUE, TRUE, '2024-09-18');

-- Topping up to 150 rows per major table
INSERT INTO event (org_id, event_name, event_type, event_date, event_location_name, event_location_addr, city, county, zip_code, individuals_served, notes) VALUES
(1,  'Meals That Matter - Easterseals July 2025',      'Lunch',             '2025-07-23', 'Easterseals SWFL',       '350 Corbett St',      'Fort Myers',  'Lee',   '33901', 40, NULL),
(2,  'Meals That Matter - CRN August 2025',            'Lunch',             '2025-08-27', 'Community Resource Ntwk','5631 Halifax Ave',    'Naples',      'Collier','34102', 53, NULL),
(4,  'Meals That Matter - Sunshine Nov 2025',          'Lunch',             '2025-11-26', 'Sunshine Adult Day Ctr', '2345 Immokalee Rd',   'Naples',      'Collier','34110', 31, NULL),
(5,  'Meals That Matter - Hope Harbor Dec 2025',       'Lunch',             '2025-12-24', 'Hope Harbor Shelter',    '1010 Sixth Ave S',    'Naples',      'Collier','34102', 60, NULL),
(6,  'Meals That Matter - GCAC Jan 2025',              'Lunch',             '2025-01-15', 'Gulf Coast Abilities',   '11120 Carissa Ct',    'Fort Myers',  'Lee',   '33966', 42, NULL),
(7,  'Meals That Matter - Ability Works March 2025',   'Lunch',             '2025-03-19', 'Ability Works FL',       '9250 Corkscrew Rd',   'Bonita Spgs', 'Lee',   '34135', 49, NULL),
(8,  'Meals That Matter - LARC March 2025',            'Lunch',             '2025-03-26', 'LARC Inc.',              '2570 Hanson St',      'Fort Myers',  'Lee',   '33901', 36, NULL),
(10, 'Meals That Matter - Senior Friends March 2025',  'Lunch',             '2025-03-05', 'Senior Friendship Ctrs', '1820 Ortiz Ave',      'Fort Myers',  'Lee',   '33905', 64, NULL),
(11, 'Meals That Matter - St Matthew April 2025',      'Lunch',             '2025-04-23', 'St. Matthew House',      '2001 Airport Rd S',   'Naples',      'Collier','34112', 75, NULL),
(12, 'Meals That Matter - BGC February 2025',          'Camp Lunch',        '2025-02-26', 'Boys & Girls Club',      '8225 Collier Blvd',   'Naples',      'Collier','34114', 45, NULL),
(13, 'Meals That Matter - New Horizons April 2025',    'Lunch',             '2025-04-16', 'New Horizons SWFL',      '1000 S Collier Blvd', 'Marco Island','Collier','34145', 19, NULL),
(14, 'Meals That Matter - UCP May 2025',               'Lunch',             '2025-05-28', 'UCP of SWFL',            '2606 Hanson St',      'Fort Myers',  'Lee',   '33901', 32, NULL),
(15, 'Meals That Matter - Lighthouse May 2025',        'Lunch',             '2025-05-21', 'Lighthouse of SWFL',     '35 Mann St',          'Fort Myers',  'Lee',   '33907', 20, NULL),
(9,  'Meals That Matter - DLC June 2025',              'Breakfast',         '2025-06-25', 'David Lawrence Centers', '6075 Bathey Ln',      'Naples',      'Collier','34116', 25, NULL),
(1,  'Meals That Matter - Easterseals Aug 2025',       'Lunch',             '2025-08-13', 'Easterseals SWFL',       '350 Corbett St',      'Fort Myers',  'Lee',   '33901', 39, NULL),
(2,  'Meals That Matter - CRN June 2025',              'Lunch',             '2025-06-04', 'Community Resource Ntwk','5631 Halifax Ave',    'Naples',      'Collier','34102', 55, NULL),
(5,  'Meals That Matter - Hope Harbor Feb 2025',       'Lunch',             '2025-02-26', 'Hope Harbor Shelter',    '1010 Sixth Ave S',    'Naples',      'Collier','34102', 61, NULL),
(6,  'Meals That Matter - GCAC Aug 2025',              'Lunch',             '2025-08-20', 'Gulf Coast Abilities',   '11120 Carissa Ct',    'Fort Myers',  'Lee',   '33966', 43, NULL),
(7,  'Meals That Matter - Ability Works May 2025',     'Lunch',             '2025-05-14', 'Ability Works FL',       '9250 Corkscrew Rd',   'Bonita Spgs', 'Lee',   '34135', 51, NULL),
(8,  'Meals That Matter - LARC Sept 2025',             'Lunch',             '2025-09-24', 'LARC Inc.',              '2570 Hanson St',      'Fort Myers',  'Lee',   '33901', 37, NULL),
(10, 'Meals That Matter - Senior Friends Aug 2025',    'Lunch',             '2025-08-27', 'Senior Friendship Ctrs', '1820 Ortiz Ave',      'Fort Myers',  'Lee',   '33905', 63, NULL),
(11, 'Meals That Matter - St Matthew July 2025',       'Lunch',             '2025-07-30', 'St. Matthew House',      '2001 Airport Rd S',   'Naples',      'Collier','34112', 76, NULL),
(12, 'Meals That Matter - BGC August 2025',            'Camp Lunch',        '2025-08-06', 'Boys & Girls Club',      '8225 Collier Blvd',   'Naples',      'Collier','34114', 44, NULL),
(13, 'Meals That Matter - New Horizons July 2025',     'Lunch',             '2025-07-23', 'New Horizons SWFL',      '1000 S Collier Blvd', 'Marco Island','Collier','34145', 20, NULL),
(14, 'Meals That Matter - UCP Aug 2025',               'Lunch',             '2025-08-20', 'UCP of SWFL',            '2606 Hanson St',      'Fort Myers',  'Lee',   '33901', 32, NULL),
(15, 'Meals That Matter - Lighthouse Sept 2025',       'Lunch',             '2025-09-17', 'Lighthouse of SWFL',     '35 Mann St',          'Fort Myers',  'Lee',   '33907', 21, NULL),
(9,  'Meals That Matter - DLC Nov 2025',               'Breakfast',         '2025-11-19', 'David Lawrence Centers', '6075 Bathey Ln',      'Naples',      'Collier','34116', 27, NULL),
(4,  'Meals That Matter - Sunshine March 2025',        'Lunch',             '2025-03-26', 'Sunshine Adult Day Ctr', '2345 Immokalee Rd',   'Naples',      'Collier','34110', 33, NULL),
(4,  'Meals That Matter - Sunshine May 2025',          'Lunch',             '2025-05-28', 'Sunshine Adult Day Ctr', '2345 Immokalee Rd',   'Naples',      'Collier','34110', 34, NULL),
(4,  'Meals That Matter - Sunshine Dec 2025',          'Lunch',             '2025-12-17', 'Sunshine Adult Day Ctr', '2345 Immokalee Rd',   'Naples',      'Collier','34110', 32, NULL),
(4,  'Meals That Matter - Sunshine Feb 2026',          'Lunch',             '2026-02-25', 'Sunshine Adult Day Ctr', '2345 Immokalee Rd',   'Naples',      'Collier','34110', 31, NULL),
(9,  'Meals That Matter - DLC April 2025',             'Breakfast',         '2025-04-09', 'David Lawrence Centers', '6075 Bathey Ln',      'Naples',      'Collier','34116', 26, NULL),
(9,  'Meals That Matter - DLC July 2025',              'Breakfast',         '2025-07-02', 'David Lawrence Centers', '6075 Bathey Ln',      'Naples',      'Collier','34116', 25, NULL),
(9,  'Meals That Matter - DLC Aug 2025',               'Breakfast',         '2025-08-06', 'David Lawrence Centers', '6075 Bathey Ln',      'Naples',      'Collier','34116', 24, NULL),
(9,  'Meals That Matter - DLC Oct 2025',               'Breakfast',         '2025-10-08', 'David Lawrence Centers', '6075 Bathey Ln',      'Naples',      'Collier','34116', 27, NULL),
(9,  'Meals That Matter - DLC Dec 2025',               'Breakfast',         '2025-12-10', 'David Lawrence Centers', '6075 Bathey Ln',      'Naples',      'Collier','34116', 26, NULL),
(9,  'Meals That Matter - DLC Feb 2026 B',             'Breakfast',         '2026-02-22', 'David Lawrence Centers', '6075 Bathey Ln',      'Naples',      'Collier','34116', 25, NULL);

INSERT INTO participant_survey (event_id, disability_type_id, program_satisfaction, felt_complete_meal, household_size, visit_frequency, event_met_needs, has_diabetes, has_high_blood_pressure, has_high_cholesterol, is_vegetarian, is_gluten_free, has_food_allergy, is_unemployed, is_single_parent, is_veteran, is_grandparent_caregiver, is_homeless, would_participate_again, positive_impact, additional_feedback) VALUES
(101,1,5,TRUE,1,'Monthly',  5,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,TRUE,'Great summer meal.',NULL),
(101,2,4,TRUE,2,'Monthly',  4,TRUE, TRUE, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,TRUE,NULL,NULL),
(102,3,5,TRUE,1,'Monthly',  5,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,TRUE,NULL,NULL),
(102,1,4,TRUE,2,'Monthly',  4,FALSE,TRUE, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,TRUE,NULL,NULL),
(103,2,5,TRUE,1,'Quarterly',5,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,TRUE,'Shelter meal was wonderful.',NULL),
(104,7,5,TRUE,3,'Monthly',  5,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,TRUE, FALSE,FALSE,TRUE, TRUE,'Homeless families very grateful.',NULL),
(105,1,4,TRUE,1,'Monthly',  4,FALSE,FALSE,TRUE, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,TRUE,NULL,NULL),
(106,3,5,TRUE,2,'Monthly',  5,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,TRUE,NULL,NULL),
(107,2,5,TRUE,1,'Monthly',  5,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,TRUE,'Always excellent.',NULL),
(108,4,4,TRUE,2,'Quarterly',4,FALSE,TRUE, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,TRUE,NULL,NULL),
(109,1,5,TRUE,1,'Monthly',  5,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,TRUE,NULL,NULL),
(110,3,5,TRUE,1,'Monthly',  5,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,TRUE,'Great April meal.',NULL),
(111,7,4,TRUE,2,'Monthly',  4,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,TRUE, FALSE,FALSE,FALSE,FALSE,TRUE,NULL,NULL),
(112,2,5,TRUE,1,'Monthly',  5,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,TRUE,NULL,NULL),
(113,1,5,TRUE,3,'Monthly',  5,FALSE,TRUE, FALSE,FALSE,FALSE,FALSE,FALSE,TRUE, FALSE,FALSE,TRUE, TRUE,'Lighthouse meal appreciated.',NULL),
(114,3,4,TRUE,1,'Quarterly',4,TRUE, FALSE,TRUE, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,TRUE,NULL,NULL),
(115,2,5,TRUE,2,'Monthly',  5,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,TRUE,NULL,NULL),
(116,1,5,TRUE,1,'Monthly',  5,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,TRUE,'Summer meal hit the spot.',NULL),
(117,4,4,TRUE,2,'Monthly',  4,FALSE,TRUE, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,TRUE,NULL,NULL),
(118,3,5,TRUE,1,'Monthly',  5,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,TRUE,NULL,NULL),
(119,7,5,TRUE,3,'Monthly',  5,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,TRUE, FALSE,FALSE,TRUE,'Veterans appreciated this.',NULL),
(120,2,4,TRUE,1,'Quarterly',4,TRUE, TRUE, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,TRUE,NULL,NULL),
(121,1,5,TRUE,2,'Monthly',  5,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,TRUE,NULL,NULL),
(122,3,5,TRUE,1,'Monthly',  5,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,TRUE,'Excellent August meal.',NULL),
(123,2,4,TRUE,2,'Monthly',  4,FALSE,FALSE,TRUE, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,TRUE,NULL,NULL),
(124,1,5,TRUE,1,'Monthly',  5,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,TRUE,NULL,NULL),
(125,7,5,TRUE,1,'Monthly',  5,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,TRUE,'Great September lunch.',NULL),
(126,3,4,TRUE,2,'Monthly',  4,TRUE, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,TRUE,NULL,NULL),
(127,4,5,TRUE,1,'Monthly',  5,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,TRUE,NULL,NULL);

INSERT INTO staff_volunteer_survey (event_id, role_type, team_area, first_time, training_clarity_rating, communication_rating, supplies_ready_rating, overall_experience_rating, safety_rating, would_volunteer_again, felt_supported, response_date) VALUES
(101,'Staff',    'Setup',             FALSE,5,5,5,5,5,TRUE,TRUE,'2025-07-23'),
(101,'Volunteer','Distribution line', FALSE,4,5,4,4,4,TRUE,TRUE,'2025-07-23'),
(102,'Staff',    'Check-in',          FALSE,5,5,5,5,5,TRUE,TRUE,'2025-08-27'),
(102,'Volunteer','Packing',           TRUE, 4,4,4,4,4,TRUE,TRUE,'2025-08-27'),
(103,'Staff',    'Traffic',           FALSE,5,5,5,5,5,TRUE,TRUE,'2025-11-26'),
(103,'Volunteer','Distribution line', FALSE,5,4,5,5,5,TRUE,TRUE,'2025-11-26'),
(104,'Staff',    'Cleanup',           FALSE,4,4,4,4,4,TRUE,TRUE,'2025-12-24'),
(104,'Volunteer','Packing',           TRUE, 5,5,5,5,5,TRUE,TRUE,'2025-12-24');







----------------------------------------------------TASK--------------------------------------------*/


/*************************(Task 1)*************/

--Organizations that had the highest participant satisfaction.
--observation: 

/*******************************************(Press / )**
SELECT
    o.org_name,
    ROUND(AVG(ps.program_satisfaction), 2) AS avg_satisfaction,
    ROUND(AVG(ps.event_met_needs), 2) AS avg_needs_met,
    COUNT(ps.response_id) AS total_responses
FROM organization o
JOIN event e ON o.org_id = e.org_id
JOIN participant_survey ps ON e.event_id = ps.event_id
GROUP BY o.org_name
ORDER BY avg_satisfaction DESC;
*************************************************************************************/

/************
-----insert collumn of pre-meal and post-meeals , alter and update and generate additional data.



ALTER TABLE event
ADD COLUMN individuals_estimated INT,
ADD COLUMN enough_volunteers BOOLEAN,
ADD COLUMN personal_org_distrib_freq VARCHAR(50),
ADD COLUMN participate_again BOOLEAN,
ADD COLUMN positive_impacts TEXT;

UPDATE event
SET 
    individuals_estimated = 15,
    enough_volunteers = TRUE,
    personal_org_distrib_freq = 'biweekly',
    participate_again = TRUE,
    positive_impacts = 'Our individuals were very happy and felt appreciated and cared for.'
WHERE event_id = 1;


UPDATE event
SET 
    individuals_estimated = 90,
    enough_volunteers = TRUE,
    personal_org_distrib_freq = 'daily',
    participate_again = TRUE,
    positive_impacts = 'Provided a wonderful family style Thanksgiving meal for a Life Skills Program. This meal was the only Thanksgiving meal a few of the individuals with disabilities would receive this year. A huge thank you!'
WHERE event_id = 2;


UPDATE event
SET 
    individuals_estimated = 28,
    enough_volunteers = TRUE,
    personal_org_distrib_freq = 'occasionally',
    participate_again = TRUE,
    positive_impacts = 'It was the last day of camp, and we try to make a quick lunch before packing up time, it was just perfect!'
WHERE event_id = 3;


UPDATE event
SET
    individuals_estimated = FLOOR(RANDOM() * 120 + 20)::INT, -- between 20–140

    enough_volunteers = CASE 
        WHEN RANDOM() > 0.2 THEN TRUE   -- ~80% yes
        ELSE FALSE
    END,

    personal_org_distrib_freq = 
        (ARRAY['daily', 'weekly', 'biweekly', 'monthly', 'occasionally'])
        [FLOOR(RANDOM() * 5 + 1)],

    participate_again = CASE 
        WHEN RANDOM() > 0.15 THEN TRUE  -- ~85% yes
        ELSE FALSE
    END,

    positive_impacts = 
        (ARRAY[
            'Participants expressed gratitude and satisfaction.',
            'Meals helped reduce food insecurity for families.',
            'Improved community engagement and support.',
            'Participants enjoyed the variety and quality of meals.',
            'Provided reliable access to nutritious meals.',
            'Helped families during a difficult financial period.',
            'Volunteers created a welcoming and supportive environment.',
            'Some participants noted delays but still appreciated the support.',
            'Food portions could improve but overall helpful.',
            'Event ran smoothly with strong participation.'
        ])
        [FLOOR(RANDOM() * 10 + 1)]

WHERE event_id >= 4;
************/

