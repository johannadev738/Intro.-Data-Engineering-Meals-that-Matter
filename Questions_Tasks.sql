
--==================
--Task 1
--==================
/*CCAG administrators want to identify which meal distribution collabs had the
 highest participant satisfaction so they can replicate the most effective event
  practices in future programs.
*/
WITH participant_satisfaction AS (
    SELECT 
        s.event_id,
        sr.response_id,
        CAST(a.answer_value AS INTEGER) AS satisfaction_score
    FROM Survey s
    JOIN Survey_Response sr ON s.survey_id = sr.survey_id
    JOIN Answer a ON sr.response_id = a.response_id
    JOIN Question q ON a.question_id = q.question_id
    WHERE s.survey_type = 'participant'
      AND q.question_text = 'Program satisfaction (1-5 rating)'
      AND a.answer_value ~ '^[0-9]+$'
),
event_satisfaction_stats AS (
    SELECT 
        event_id,
        COUNT(response_id) AS survey_count,
        ROUND(AVG(satisfaction_score), 2) AS avg_satisfaction
    FROM participant_satisfaction
    GROUP BY event_id
)
SELECT 
    o.org_name AS organization,
    e.event_id,
    e.event_name,
    e.event_type,
    e.individuals_served AS participants,
    COALESCE(ess.survey_count, 0) AS survey_count,
    COALESCE(ess.avg_satisfaction, 0) AS avg_satisfaction,
    CASE 
        WHEN COALESCE(ess.survey_count, 0) = 0 THEN 'No Data'
        WHEN ess.avg_satisfaction >= 4.5 THEN 'Excellent'
        WHEN ess.avg_satisfaction >= 4.0 THEN 'Good'
        WHEN ess.avg_satisfaction >= 3.0 THEN 'Average'
        WHEN ess.avg_satisfaction >= 2.0 THEN 'Poor'
        ELSE 'Very Poor'
    END AS satisfaction_rating
FROM Organization o
JOIN Event e ON o.org_id = e.org_id
LEFT JOIN event_satisfaction_stats ess ON e.event_id = ess.event_id
ORDER BY avg_satisfaction DESC, e.event_id;
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
    COALESCE(COUNT(DISTINCT CASE WHEN ep.role = 'staff' THEN ep.person_id END), 0) AS staff_count,
    COALESCE(COUNT(DISTINCT CASE WHEN ep.role = 'volunteer' THEN ep.person_id END), 0) AS volunteer_count,
    COALESCE(COUNT(DISTINCT ep.person_id), 0) AS total_personnel,
    CASE 
        WHEN COUNT(DISTINCT ep.person_id) = 0 THEN 0
        ELSE ROUND(e.individuals_served::numeric / COUNT(DISTINCT ep.person_id), 1)
    END AS attendees_per_personnel,
    CASE 
        WHEN COUNT(DISTINCT CASE WHEN ep.role = 'staff' THEN ep.person_id END) = 0 THEN 0
        ELSE ROUND(e.individuals_served::numeric / COUNT(DISTINCT CASE WHEN ep.role = 'staff' THEN ep.person_id END), 1)
    END AS attendees_per_staff,
    CASE 
        WHEN COUNT(DISTINCT CASE WHEN ep.role = 'volunteer' THEN ep.person_id END) = 0 THEN 0
        ELSE ROUND(e.individuals_served::numeric / COUNT(DISTINCT CASE WHEN ep.role = 'volunteer' THEN ep.person_id END), 1)
    END AS attendees_per_volunteer,
    CASE 
        WHEN COUNT(DISTINCT ep.person_id) = 0 THEN 'No personnel assigned'
        WHEN e.individuals_served::numeric / COUNT(DISTINCT ep.person_id) <= 10 THEN 'Well staffed'
        WHEN e.individuals_served::numeric / COUNT(DISTINCT ep.person_id) <= 20 THEN 'Adequately staffed'
        WHEN e.individuals_served::numeric / COUNT(DISTINCT ep.person_id) <= 30 THEN 'Under staffed'
        ELSE 'Critically under staffed'
    END AS staffing_status  -- Removed the extra comma here
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

WITH survey_ratings AS (
    SELECT 
        sr.disability_type_id,
        dt.disability_name,
        q.question_text,
        CAST(a.answer_value AS DECIMAL) AS rating_value
    FROM Survey s
    JOIN Survey_Response sr ON s.survey_id = sr.survey_id
    JOIN Answer a ON sr.response_id = a.response_id
    JOIN Question q ON a.question_id = q.question_id
    LEFT JOIN Disability_Type dt ON sr.disability_type_id = dt.disability_type_id
    WHERE s.survey_type = 'participant'  -- Only participant surveys
      AND q.question_type = 'rating'
      AND a.answer_value ~ '^[0-9]+\.?[0-9]*$'  -- Only numeric values
      AND (q.question_text ILIKE '%needs%' OR q.question_text ILIKE '%satisfied%' OR q.question_text ILIKE '%satisfaction%')
),
needs_met AS (
    SELECT 
        disability_type_id,
        disability_name,
        AVG(rating_value) AS avg_needs_met
    FROM survey_ratings
    WHERE question_text ILIKE '%needs%'
    GROUP BY disability_type_id, disability_name
),
satisfaction AS (
    SELECT 
        disability_type_id,
        disability_name,
        AVG(rating_value) AS avg_satisfaction
    FROM survey_ratings
    WHERE question_text ILIKE '%satisfied%' OR question_text ILIKE '%satisfaction%'
    GROUP BY disability_type_id, disability_name
)
SELECT 
    COALESCE(s.disability_name, 'All Participants') AS disability_group,
    COALESCE(s.survey_count, 0) AS response_count,
    ROUND(n.avg_needs_met, 2) AS avg_needs_met,
    ROUND(sat.avg_satisfaction, 2) AS avg_satisfaction,
    ROUND(sat.avg_satisfaction - n.avg_needs_met, 2) AS gap_score,
    ROUND((sat.avg_satisfaction - n.avg_needs_met) / NULLIF(n.avg_needs_met, 0) * 100, 1) AS percent_gap,
    CASE 
        WHEN sat.avg_satisfaction >= n.avg_needs_met THEN 'Program IS meeting community needs'
        ELSE 'Program is NOT fully meeting community needs'
    END AS community_needs_assessment,
    CASE 
        WHEN sat.avg_satisfaction >= 4.5 THEN 'Excellent - Continue current strategy'
        WHEN sat.avg_satisfaction >= 4.0 THEN 'Good - Minor adjustments recommended'
        WHEN sat.avg_satisfaction >= 3.0 THEN 'Average - Review for improvements'
        ELSE 'Poor - Immediate action required'
    END AS recommendation
FROM (
    SELECT disability_type_id, disability_name, COUNT(*) AS survey_count
    FROM survey_ratings
    GROUP BY disability_type_id, disability_name
) s
LEFT JOIN needs_met n ON s.disability_type_id = n.disability_type_id AND s.disability_name = n.disability_name
LEFT JOIN satisfaction sat ON s.disability_type_id = sat.disability_type_id AND s.disability_name = sat.disability_name
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
    COUNT(DISTINCT sr.response_id) AS response_count,
    ROUND(AVG(CASE 
        WHEN q.question_text LIKE '%needs%' 
        THEN CAST(a.answer_value AS DECIMAL) 
        ELSE NULL 
    END), 2) AS avg_needs_met,
    ROUND(AVG(CASE 
        WHEN q.question_text LIKE '%satisfaction%' OR q.question_text LIKE '%satisfied%'
        THEN CAST(a.answer_value AS DECIMAL) 
        ELSE NULL 
    END), 2) AS avg_satisfaction,
    ROUND(
        AVG(CASE 
            WHEN q.question_text LIKE '%satisfaction%' OR q.question_text LIKE '%satisfied%'
            THEN CAST(a.answer_value AS DECIMAL) 
            ELSE NULL 
        END) - 
        AVG(CASE 
            WHEN q.question_text LIKE '%needs%' 
            THEN CAST(a.answer_value AS DECIMAL) 
            ELSE NULL 
        END), 2
    ) AS gap_score,
    CASE 
        WHEN COALESCE(AVG(CASE 
            WHEN q.question_text LIKE '%satisfaction%' OR q.question_text LIKE '%satisfied%'
            THEN CAST(a.answer_value AS DECIMAL) 
            ELSE NULL 
        END), 0) >= 
             COALESCE(AVG(CASE 
                WHEN q.question_text LIKE '%needs%' 
                THEN CAST(a.answer_value AS DECIMAL) 
                ELSE NULL 
             END), 0) 
        THEN 'Program is meeting or exceeding needs'
        ELSE 'Program is falling short of needs'
    END AS community_needs_assessment
FROM Disability_Type dt
LEFT JOIN Survey_Response sr ON dt.disability_type_id = sr.disability_type_id
LEFT JOIN Survey s ON sr.survey_id = s.survey_id AND s.survey_type = 'participant'
LEFT JOIN Answer a ON sr.response_id = a.response_id
LEFT JOIN Question q ON a.question_id = q.question_id AND q.question_type = 'rating'
WHERE s.survey_type = 'participant' OR s.survey_id IS NULL
GROUP BY dt.disability_name
UNION ALL
SELECT 
    'No Disability Reported' AS disability_name,
    COUNT(DISTINCT sr.response_id) AS response_count,
    ROUND(AVG(CASE 
        WHEN q.question_text LIKE '%needs%' 
        THEN CAST(a.answer_value AS DECIMAL) 
        ELSE NULL 
    END), 2) AS avg_needs_met,
    ROUND(AVG(CASE 
        WHEN q.question_text LIKE '%satisfaction%' OR q.question_text LIKE '%satisfied%'
        THEN CAST(a.answer_value AS DECIMAL) 
        ELSE NULL 
    END), 2) AS avg_satisfaction,
    ROUND(
        AVG(CASE 
            WHEN q.question_text LIKE '%satisfaction%' OR q.question_text LIKE '%satisfied%'
            THEN CAST(a.answer_value AS DECIMAL) 
            ELSE NULL 
        END) - 
        AVG(CASE 
            WHEN q.question_text LIKE '%needs%' 
            THEN CAST(a.answer_value AS DECIMAL) 
            ELSE NULL 
        END), 2
    ) AS gap_score,
    CASE 
        WHEN COALESCE(AVG(CASE 
            WHEN q.question_text LIKE '%satisfaction%' OR q.question_text LIKE '%satisfied%'
            THEN CAST(a.answer_value AS DECIMAL) 
            ELSE NULL 
        END), 0) >= 
             COALESCE(AVG(CASE 
                WHEN q.question_text LIKE '%needs%' 
                THEN CAST(a.answer_value AS DECIMAL) 
                ELSE NULL 
             END), 0) 
        THEN 'Program is meeting or exceeding needs'
        ELSE 'Program is falling short of needs'
    END AS community_needs_assessment
FROM Survey_Response sr
LEFT JOIN Survey s ON sr.survey_id = s.survey_id AND s.survey_type = 'participant'
LEFT JOIN Answer a ON sr.response_id = a.response_id
LEFT JOIN Question q ON a.question_id = q.question_id AND q.question_type = 'rating'
WHERE sr.disability_type_id IS NULL
  AND (s.survey_type = 'participant' OR s.survey_id IS NULL)
ORDER BY gap_score DESC;
