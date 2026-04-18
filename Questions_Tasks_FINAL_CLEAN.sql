-- ============================================================
-- COP 3710 - Course Project - Questions/Tasks (FINAL CLEAN)
-- Organization: Collaborative Care Advocacy Group
-- Program: Meals That Matter
-- ============================================================

-- ==================
-- Task 1
-- ==================
/*
CCAG administrators want to identify which organizations hosted the most
successful events based on participant count and event frequency to determine
which partnerships should be prioritized for future collaborations.
*/

SELECT 
    o.org_name AS organization,
    COUNT(DISTINCT e.event_id) AS total_events,
    SUM(e.individuals_served) AS total_participants_served,
    ROUND(AVG(e.individuals_served), 2) AS avg_participants_per_event,
    a.city,
    a.zip_code
FROM Organization o
JOIN Event e ON o.org_id = e.org_id
JOIN Address a ON o.address_id = a.address_id
GROUP BY o.org_name, a.city, a.zip_code
ORDER BY total_participants_served DESC;


-- ==================
-- Task 2
-- ==================
/*
CCAG administrators want to evaluate staffing patterns across events to
determine optimal staff-to-participant ratios and identify which events
may need additional volunteer support.
*/

SELECT 
    e.event_id,
    e.event_name,
    o.org_name,
    e.individuals_served,
    COUNT(DISTINCT CASE WHEN ep.role = 'staff' THEN ep.person_id END) AS staff_count,
    COUNT(DISTINCT CASE WHEN ep.role = 'volunteer' THEN ep.person_id END) AS volunteer_count,
    COUNT(DISTINCT ep.person_id) AS total_personnel,
    ROUND(e.individuals_served::numeric / NULLIF(COUNT(DISTINCT ep.person_id), 0), 1) AS participants_per_person,
    CASE 
        WHEN e.individuals_served::numeric / NULLIF(COUNT(DISTINCT ep.person_id), 0) <= 15 THEN 'Well staffed'
        WHEN e.individuals_served::numeric / NULLIF(COUNT(DISTINCT ep.person_id), 0) <= 30 THEN 'Adequately staffed'
        ELSE 'Needs more support'
    END AS staffing_level
FROM Event e
JOIN Organization o ON e.org_id = o.org_id
INNER JOIN Event_Personnel ep ON e.event_id = ep.event_id
GROUP BY e.event_id, e.event_name, o.org_name, e.individuals_served
ORDER BY e.event_id;


-- ==================
-- Task 3
-- ==================
/*
CCAG administrators want to analyze event distribution across different
cities and zip codes to identify geographic coverage gaps and opportunities
for expansion.
*/

SELECT 
    a.city,
    a.zip_code,
    COUNT(DISTINCT e.event_id) AS number_of_events,
    COUNT(DISTINCT o.org_id) AS partner_organizations,
    SUM(e.individuals_served) AS total_people_served,
    ROUND(AVG(e.individuals_served), 2) AS avg_attendance
FROM Event e
JOIN Address a ON e.address_id = a.address_id
JOIN Organization o ON e.org_id = o.org_id
GROUP BY a.city, a.zip_code
ORDER BY total_people_served DESC;


-- ==================
-- Task 4
-- ==================
/*
CCAG administrators want to examine the types of events offered and their
reach to determine which event formats are most effective for serving
the community.
*/

SELECT 
    e.event_type,
    COUNT(DISTINCT e.event_id) AS number_of_events,
    SUM(e.individuals_served) AS total_participants,
    ROUND(AVG(e.individuals_served), 2) AS avg_participants,
    MIN(e.individuals_served) AS min_participants,
    MAX(e.individuals_served) AS max_participants
FROM Event e
GROUP BY e.event_type
ORDER BY total_participants DESC;


-- ==================
-- Task 5
-- ==================
/*
CCAG administrators want to create a comprehensive organization directory
showing all partner details, their location information, and event activity
to support partnership management and communication.
*/

SELECT 
    o.org_name,
    o.contact_person,
    o.phone_number,
    o.email,
    a.street,
    a.city,
    a.state,
    a.zip_code,
    COUNT(DISTINCT e.event_id) AS events_hosted,
    COALESCE(SUM(e.individuals_served), 0) AS total_served
FROM Organization o
JOIN Address a ON o.address_id = a.address_id
LEFT JOIN Event e ON o.org_id = e.org_id
GROUP BY o.org_name, o.contact_person, o.phone_number, o.email, 
         a.street, a.city, a.state, a.zip_code
ORDER BY events_hosted DESC, o.org_name;


-- ==================
-- Task 6
-- ==================
/*
CCAG administrators want to identify the personnel who have contributed
to multiple events to recognize dedicated staff and volunteers and
understand resource allocation patterns.
*/

SELECT 
    p.name,
    COUNT(DISTINCT ep.event_id) AS events_worked,
    STRING_AGG(DISTINCT ep.role, ', ' ORDER BY ep.role) AS roles,
    STRING_AGG(DISTINCT e.event_name, '; ' ORDER BY e.event_name) AS event_list
FROM Personnel p
JOIN Event_Personnel ep ON p.person_id = ep.person_id
JOIN Event e ON ep.event_id = e.event_id
GROUP BY p.name
ORDER BY events_worked DESC, p.name;


-- ==================
-- Task 7
-- ==================
/*
CCAG administrators want to analyze participant feedback collection across
completed events to evaluate data quality and identify which events have
strong survey completion rates.
*/

SELECT 
    e.event_id,
    e.event_name,
    o.org_name,
    e.individuals_served,
    COUNT(DISTINCT sr.response_id) AS completed_surveys,
    ROUND(100.0 * COUNT(DISTINCT sr.response_id) / NULLIF(e.individuals_served, 0), 2) AS completion_rate_percent,
    CASE 
        WHEN 100.0 * COUNT(DISTINCT sr.response_id) / NULLIF(e.individuals_served, 0) >= 10 THEN 'Strong data collection'
        WHEN COUNT(DISTINCT sr.response_id) > 0 THEN 'Moderate data collection'
        ELSE 'No survey data'
    END AS data_quality
FROM Event e
JOIN Organization o ON e.org_id = o.org_id
LEFT JOIN Survey s ON e.event_id = s.event_id
LEFT JOIN Survey_Response sr ON s.survey_id = sr.survey_id
LEFT JOIN (
    SELECT DISTINCT response_id 
    FROM Answer
) a ON sr.response_id = a.response_id
WHERE a.response_id IS NOT NULL OR sr.response_id IS NULL
GROUP BY e.event_id, e.event_name, o.org_name, e.individuals_served
HAVING COUNT(DISTINCT sr.response_id) > 0
ORDER BY completion_rate_percent DESC, e.event_id;


-- ==================
-- Task 8
-- ==================
/*
CCAG administrators want to understand the distribution of disability types
represented in participant feedback to ensure the program is collecting data
from diverse populations.
*/

SELECT 
    dt.disability_name,
    dt.disability_description,
    COUNT(DISTINCT sr.response_id) AS completed_surveys,
    COUNT(DISTINCT s.event_id) AS events_represented,
    ROUND(100.0 * COUNT(DISTINCT sr.response_id) / 
          (SELECT COUNT(DISTINCT sr2.response_id) 
           FROM Survey_Response sr2 
           INNER JOIN Answer a2 ON sr2.response_id = a2.response_id
           WHERE sr2.disability_type_id IS NOT NULL), 2) AS percentage_of_responses
FROM Disability_Type dt
INNER JOIN Survey_Response sr ON dt.disability_type_id = sr.disability_type_id
INNER JOIN Survey s ON sr.survey_id = s.survey_id
INNER JOIN Answer a ON sr.response_id = a.response_id
GROUP BY dt.disability_name, dt.disability_description
ORDER BY completed_surveys DESC;


-- ==================
-- Task 9
-- ==================
/*
CCAG administrators want to compare participant satisfaction, meal completeness,
and return interest across event locations to determine which locations are the
most effective for future Meals That Matter distributions.
*/

SELECT
    e.event_location_name,
    COUNT(DISTINCT sr.response_id) AS total_responses,

    ROUND(AVG(CASE
        WHEN q.question_text = 'Program satisfaction (1-5 rating)'
        THEN CAST(a.answer_value AS DECIMAL)
    END), 2) AS avg_satisfaction,

    ROUND(AVG(CASE
        WHEN q.question_text = 'Event met needs (1-5 rating)'
        THEN CAST(a.answer_value AS DECIMAL)
    END), 2) AS avg_needs_met,

    ROUND(
        100.0 * COUNT(CASE
            WHEN q.question_text = 'Felt the meal was complete?'
             AND a.answer_value = 'true' THEN 1
        END)
        / NULLIF(COUNT(DISTINCT sr.response_id), 0),
    2) AS meal_complete_percentage

FROM Survey s
JOIN Survey_Response sr ON s.survey_id = sr.survey_id
JOIN Event e ON s.event_id = e.event_id
JOIN Answer a ON sr.response_id = a.response_id
JOIN Question q ON a.question_id = q.question_id

GROUP BY
    e.event_location_name

ORDER BY
    avg_satisfaction DESC;


-- ==================
-- Task 10
-- ==================
/*
CCAG administrators want to evaluate staff and volunteer experience by event
in order to identify trends in training clarity, communication, supplies readiness,
overall experience, and perceived support.
*/

SELECT
    e.event_id,
    e.event_name,
    e.event_location_name,

    COUNT(DISTINCT sr.response_id) AS total_staff_volunteer_responses,

    ROUND(AVG(CASE
        WHEN q.question_text = 'Training clarity rating (1-5)'
        THEN CAST(a.answer_value AS DECIMAL)
    END), 2) AS avg_training_clarity,

    ROUND(AVG(CASE
        WHEN q.question_text = 'Communication rating (1-5)'
        THEN CAST(a.answer_value AS DECIMAL)
    END), 2) AS avg_communication,

    ROUND(AVG(CASE
        WHEN q.question_text = 'Supplies ready rating (1-5)'
        THEN CAST(a.answer_value AS DECIMAL)
    END), 2) AS avg_supplies_ready,

    ROUND(AVG(CASE
        WHEN q.question_text = 'Overall experience rating (1-5)'
        THEN CAST(a.answer_value AS DECIMAL)
    END), 2) AS avg_overall_experience,

    ROUND(
        100.0 * COUNT(CASE
            WHEN q.question_text = 'Felt supported?'
             AND a.answer_value = 'true' THEN 1
        END)
        / NULLIF(COUNT(DISTINCT sr.response_id), 0),
    2) AS felt_supported_percentage

FROM Survey s
JOIN Survey_Response sr ON s.survey_id = sr.survey_id
JOIN Event e ON s.event_id = e.event_id
JOIN Answer a ON sr.response_id = a.response_id
JOIN Question q ON a.question_id = q.question_id

WHERE s.survey_target_type IN ('staff', 'volunteer')

GROUP BY
    e.event_id,
    e.event_name,
    e.event_location_name

ORDER BY
    avg_overall_experience DESC;


-- ==================
-- Task 11
-- ==================
/*
CCAG administrators want to evaluate participation and satisfaction across zip codes
to identify which geographic areas have the highest community reach and engagement.
*/

SELECT
    a.zip_code,

    COUNT(DISTINCT e.event_id) AS total_events,

    SUM(e.individuals_served) AS total_participants_served,

    COUNT(DISTINCT sr.response_id) AS total_survey_responses,

    ROUND(AVG(CASE
        WHEN q.question_text = 'Program satisfaction (1-5 rating)'
        THEN CAST(ans.answer_value AS DECIMAL)
    END), 2) AS avg_satisfaction,

    ROUND(AVG(CASE
        WHEN q.question_text = 'Event met needs (1-5 rating)'
        THEN CAST(ans.answer_value AS DECIMAL)
    END), 2) AS avg_needs_met

FROM Event e
JOIN Address a ON e.address_id = a.address_id
JOIN Survey s ON e.event_id = s.event_id
JOIN Survey_Response sr ON s.survey_id = sr.survey_id
JOIN Answer ans ON sr.response_id = ans.response_id
JOIN Question q ON ans.question_id = q.question_id

GROUP BY
    a.zip_code

ORDER BY
    total_participants_served DESC,
    avg_satisfaction DESC;


-- ==================
-- Task 12
-- ==================
/*
CCAG administrators want to identify which event locations are performing above
the overall average participation level in order to highlight high-impact locations
and guide future resource allocation.
*/

SELECT
    sub.event_location_name,
    sub.zip_code,
    ROUND(sub.avg_participants_served, 2) AS avg_participants_served
FROM (
    SELECT
        e.event_location_name,
        a.zip_code,
        AVG(e.individuals_served) AS avg_participants_served
    FROM Event e
    LEFT JOIN Address a ON e.address_id = a.address_id
    GROUP BY
        e.event_location_name,
        a.zip_code
) sub
WHERE sub.avg_participants_served > (
    SELECT AVG(individuals_served)
    FROM Event
)
ORDER BY sub.avg_participants_served DESC;
