
--==================
--Task 1
--==================
/*CCAG administrators want to identify which meal distribution collabs had the
 highest participant satisfaction so they can replicate the most effective event
  practices in future programs.
*/
SELECT 
    o.org_name AS organization,
    e.event_id,
    e.event_name,
    e.event_type,
    e.individuals_served AS participants,
    COUNT(DISTINCT sr.response_id) AS survey_count,
    ROUND(AVG(CAST(a.answer_value AS DECIMAL)), 2) AS avg_satisfaction,
    CASE 
        WHEN AVG(CAST(a.answer_value AS DECIMAL)) >= 4.5 THEN 'Excellent'
        WHEN AVG(CAST(a.answer_value AS DECIMAL)) >= 4.0 THEN 'Good'
        WHEN AVG(CAST(a.answer_value AS DECIMAL)) >= 3.0 THEN 'Average'
        WHEN AVG(CAST(a.answer_value AS DECIMAL)) >= 2.0 THEN 'Poor'
        ELSE 'Very Poor'
    END AS satisfaction_rating
FROM Organization o
JOIN Event e ON o.org_id = e.org_id
LEFT JOIN Survey s ON e.event_id = s.event_id AND s.target_type = 'participant'
LEFT JOIN Survey_Response sr ON s.survey_id = sr.survey_id
LEFT JOIN Answer a ON sr.response_id = a.response_id
LEFT JOIN Question q ON a.question_id = q.question_id
WHERE q.question_text = 'How satisfied are you with the program? (1-5)'
   OR q.question_text ILIKE '%satisfied%'
GROUP BY o.org_name, e.event_id, e.event_name, e.event_type, e.individuals_served
ORDER BY e.event_id;
--==================
--Task 2
--==================
/*CCAG administrators want to evaluate the relationship between event attendance, 
staffing levels, and volunteer needs to determine whether events are adequately 
staffed and to establish data-driven planning guidelines.
*/
-- Query 1: Staffing adequacy analysis per event
SELECT 
    e.event_id,
    o.org_name,
    e.event_name,
    e.event_type,
    e.individuals_served AS actual_attendees,
    COUNT(DISTINCT CASE WHEN ep.role = 'staff' THEN ep.person_id END) AS staff_count,
    COUNT(DISTINCT CASE WHEN ep.role = 'volunteer' THEN ep.person_id END) AS volunteer_count,
    COUNT(DISTINCT ep.person_id) AS total_personnel,
    ROUND(e.individuals_served::numeric / NULLIF(COUNT(DISTINCT ep.person_id), 0), 1) AS attendees_per_personnel,
    ROUND(e.individuals_served::numeric / NULLIF(COUNT(DISTINCT CASE WHEN ep.role = 'staff' THEN ep.person_id END), 0), 1) AS attendees_per_staff,
    ROUND(e.individuals_served::numeric / NULLIF(COUNT(DISTINCT CASE WHEN ep.role = 'volunteer' THEN ep.person_id END), 0), 1) AS attendees_per_volunteer,
    CASE 
        WHEN COUNT(DISTINCT ep.person_id) = 0 THEN 'No personnel assigned'
        WHEN e.individuals_served::numeric / COUNT(DISTINCT ep.person_id) <= 10 THEN 'Well staffed'
        WHEN e.individuals_served::numeric / COUNT(DISTINCT ep.person_id) <= 20 THEN 'Adequately staffed'
        WHEN e.individuals_served::numeric / COUNT(DISTINCT ep.person_id) <= 30 THEN 'Under staffed'
        ELSE 'Critically under staffed'
    END AS staffing_status
FROM Event e
JOIN Organization o ON e.org_id = o.org_id
LEFT JOIN Event_Personnel ep ON e.event_id = ep.event_id
GROUP BY e.event_id, o.org_name, e.event_name, e.event_type, e.individuals_served
ORDER BY attendees_per_personnel DESC;



--==================
--Task 3
--==================
/*CCAG administrators want to compare pre-event expectations and post-event outcomes 
to measure change in participant experience and determine whether Meals That Matter 
is meeting community needs.
*/
-- Compare whether event needs were met vs overall satisfaction
SELECT 
    COALESCE(dt.disability_name, 'All Participants') AS disability_group,
    COUNT(*) AS response_count,
    ROUND(AVG(CASE WHEN q.question_text ILIKE '%needs%' THEN CAST(a.answer_value AS DECIMAL) END), 2) AS avg_needs_met,
    ROUND(AVG(CASE WHEN q.question_text ILIKE '%satisfied%' THEN CAST(a.answer_value AS DECIMAL) END), 2) AS avg_satisfaction,
    ROUND(AVG(CASE WHEN q.question_text ILIKE '%satisfied%' THEN CAST(a.answer_value AS DECIMAL) END) - 
          AVG(CASE WHEN q.question_text ILIKE '%needs%' THEN CAST(a.answer_value AS DECIMAL) END), 2) AS gap_score,
    ROUND((AVG(CASE WHEN q.question_text ILIKE '%satisfied%' THEN CAST(a.answer_value AS DECIMAL) END) - 
           AVG(CASE WHEN q.question_text ILIKE '%needs%' THEN CAST(a.answer_value AS DECIMAL) END)) / 
          NULLIF(AVG(CASE WHEN q.question_text ILIKE '%needs%' THEN CAST(a.answer_value AS DECIMAL) END), 0) * 100, 1) AS percent_gap,
    CASE 
        WHEN AVG(CASE WHEN q.question_text ILIKE '%satisfied%' THEN CAST(a.answer_value AS DECIMAL) END) >= 
             AVG(CASE WHEN q.question_text ILIKE '%needs%' THEN CAST(a.answer_value AS DECIMAL) END) 
        THEN 'Program IS meeting community needs'
        ELSE 'Program is NOT fully meeting community needs'
    END AS community_needs_assessment,
    CASE 
        WHEN AVG(CASE WHEN q.question_text ILIKE '%satisfied%' THEN CAST(a.answer_value AS DECIMAL) END) >= 4.5 
        THEN 'Excellent - Continue current strategy'
        WHEN AVG(CASE WHEN q.question_text ILIKE '%satisfied%' THEN CAST(a.answer_value AS DECIMAL) END) >= 4.0 
        THEN 'Good - Minor adjustments recommended'
        WHEN AVG(CASE WHEN q.question_text ILIKE '%satisfied%' THEN CAST(a.answer_value AS DECIMAL) END) >= 3.0 
        THEN 'Average - Review for improvements'
        ELSE 'Poor - Immediate action required'
    END AS recommendation
FROM Disability_Type dt
JOIN Survey_Response sr ON dt.disability_type_id = sr.disability_type_id
JOIN Answer a ON sr.response_id = a.response_id
JOIN Question q ON a.question_id = q.question_id
WHERE q.question_type = 'rating'
  AND (q.question_text ILIKE '%needs%' OR q.question_text ILIKE '%satisfied%')
GROUP BY ROLLUP(dt.disability_name)
ORDER BY gap_score DESC;


--==================
--Task 4
--==================
/*
CCAG administrators want to identify which disability groups reported the highest
 and lowest satisfaction levels so that future activities and food distribution 
 strategies can be better tailored to participant needs.*/
SELECT 
    COALESCE(dt.disability_name, 'No Disability Reported') AS disability_name,
    COUNT(*) AS response_count,
    ROUND(AVG(CASE WHEN q.question_text LIKE '%needs%' THEN CAST(a.answer_value AS DECIMAL) END), 2) AS avg_needs_met,
    ROUND(AVG(CASE WHEN q.question_text LIKE '%satisfied%' THEN CAST(a.answer_value AS DECIMAL) END), 2) AS avg_satisfaction,
    ROUND(AVG(CASE WHEN q.question_text LIKE '%satisfied%' THEN CAST(a.answer_value AS DECIMAL) END) - 
          AVG(CASE WHEN q.question_text LIKE '%needs%' THEN CAST(a.answer_value AS DECIMAL) END), 2) AS gap_score,
    CASE 
        WHEN AVG(CASE WHEN q.question_text LIKE '%satisfied%' THEN CAST(a.answer_value AS DECIMAL) END) >= 
             AVG(CASE WHEN q.question_text LIKE '%needs%' THEN CAST(a.answer_value AS DECIMAL) END) 
        THEN 'Program is meeting or exceeding needs'
        ELSE 'Program is falling short of needs'
    END AS community_needs_assessment
FROM Disability_Type dt
LEFT JOIN Survey_Response sr ON dt.disability_type_id = sr.disability_type_id
LEFT JOIN Answer a ON sr.response_id = a.response_id
LEFT JOIN Question q ON a.question_id = q.question_id AND q.question_type = 'rating'
GROUP BY dt.disability_name
ORDER BY gap_score DESC;
