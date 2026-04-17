
--==================
--Task 1
--==================
/*CCAG administrators want to identify which meal distribution collabs had the
 highest participant satisfaction so they can replicate the most effective event
  practices in future programs.
*/
/*----------------------------------------------------------------------------------------------
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
-----------------------------------------------------------------------------------------*/


--==================
--Task 2
--==================
/*CCAG administrators want to evaluate the relationship between event attendance, 
staffing levels, and volunteer needs to determine whether events are adequately 
staffed and to establish data-driven planning guidelines.
*/
-- Query 1: Staffing adequacy analysis per event
/*-------------------------------------------------------------------------------
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

----------------------------------------------------------------------------------------------*/

--==================
--Task 3
--==================
/*CCAG administrators want to compare pre-event expectations and post-event outcomes 
to measure change in participant experience and determine whether Meals That Matter 
is meeting community needs.
*/
-- Compare whether event needs were met vs overall satisfaction
/*-----------------------------------------------------------------------
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
-------------------------------------------------------------------------------------------------------------*/
---==================
--Task 4
--==================
/*
CCAG administrators want to identify which disability groups reported the highest
 and lowest satisfaction levels so that future activities and food distribution 
 strategies can be better tailored to participant needs.*/
 /*------------------------------------------------------------------------------------------------------
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
--------------------------------------------------------------------------------------------------*/


-- ==================
-- Task 5
-- ==================
/*
CCAG administrators want to generate a summary report of participants served
by event location, date, and zip code, and compare average participation levels
across locations to identify above- and below-average community reach.
*/
/*
SELECT
    e.event_location_name,
    a.zip_code,
    COUNT(DISTINCT e.event_id) AS total_events,
    MIN(sr.response_date) AS first_event_date,
    MAX(sr.response_date) AS last_event_date,
    SUM(e.individuals_served) AS total_participants_served,
    ROUND(AVG(e.individuals_served), 2) AS avg_participants_per_event,
    ROUND(AVG(AVG(e.individuals_served)) OVER (), 2) AS overall_avg_participation,
    CASE
        WHEN AVG(e.individuals_served) > AVG(AVG(e.individuals_served)) OVER ()
        THEN 'Above Average Reach'
        WHEN AVG(e.individuals_served) < AVG(AVG(e.individuals_served)) OVER ()
        THEN 'Below Average Reach'
        ELSE 'At Average Reach'
    END AS community_reach_status
FROM Event e
JOIN Organization o
    ON e.org_id = o.org_id
LEFT JOIN Address a
    ON e.address_id = a.address_id
LEFT JOIN Survey s
    ON e.event_id = s.event_id
LEFT JOIN Survey_Response sr
    ON s.survey_id = sr.survey_id
GROUP BY
    e.event_location_name,
    a.zip_code
ORDER BY
    avg_participants_per_event DESC;

*/


-- ==================
-- Task 6
-- ==================
/*
CCAG administrators want to analyze participant engagement and retention
by examining visit frequency and willingness to participate again.
*/
/*
SELECT
    vf.answer_value AS visit_frequency,

    COUNT(DISTINCT sr.response_id) AS total_responses,

    -- Average satisfaction (proxy for willingness to return)
    ROUND(AVG(CAST(ps.answer_value AS DECIMAL)), 2) AS avg_satisfaction,

    -- Estimated returning participants
    COUNT(CASE 
        WHEN CAST(ps.answer_value AS DECIMAL) >= 4 THEN 1 
    END) AS likely_to_return,

    -- Estimated drop-off participants
    COUNT(CASE 
        WHEN CAST(ps.answer_value AS DECIMAL) < 4 THEN 1 
    END) AS potential_drop_off,

    -- Drop-off percentage
    ROUND(
        100.0 * COUNT(CASE WHEN CAST(ps.answer_value AS DECIMAL) < 4 THEN 1 END)
        / NULLIF(COUNT(ps.answer_value), 0),
    2) AS drop_off_rate_percent

FROM Survey s
JOIN Survey_Response sr
    ON s.survey_id = sr.survey_id
JOIN Answer vf
    ON sr.response_id = vf.response_id
JOIN Question qf
    ON vf.question_id = qf.question_id

-- Join again for satisfaction question
JOIN Answer ps
    ON sr.response_id = ps.response_id
JOIN Question qs
    ON ps.question_id = qs.question_id

WHERE
    s.survey_target_type = 'participant'
    AND qf.question_text ILIKE '%visit frequency%'
    AND qs.question_text ILIKE '%satisfaction%'

GROUP BY
    vf.answer_value

ORDER BY
    total_responses DESC;

*/

-- ==================
-- Task 7A
-- ==================
/*
CCAG administrators want to analyze which disability groups are most frequently
served at each event location in order to identify dominant demographics and
improve targeted outreach, marketing efforts, and resource distribution.
*/

--location: 
/*
WITH location_disability_counts AS (
    SELECT
        e.event_location_name,
        dt.disability_name,
        COUNT(*) AS total_count
    FROM Event e
    JOIN Survey s
        ON e.event_id = s.event_id
    JOIN Survey_Response sr
        ON s.survey_id = sr.survey_id
    JOIN Disability_Type dt
        ON sr.disability_type_id = dt.disability_type_id
    WHERE s.survey_target_type = 'participant'
      AND dt.disability_name IS NOT NULL
    GROUP BY
        e.event_location_name,
        dt.disability_name
),
ranked_locations AS (
    SELECT
        event_location_name,
        disability_name,
        total_count,
        RANK() OVER (
            PARTITION BY event_location_name
            ORDER BY total_count DESC
        ) AS rank_num
    FROM location_disability_counts
)
SELECT
    event_location_name,
    disability_name AS dominant_disability_group,
    total_count AS occurrences
FROM ranked_locations
WHERE rank_num = 1
ORDER BY event_location_name;

*/

--zip

-- ==================
-- Task 7B
-- ==================
/*
CCAG administrators want to analyze which disability groups are most frequently
served at each zip code in order to identify dominant demographics and improve
targeted outreach, marketing efforts, and resource distribution.
*/
/*
WITH zip_disability_counts AS (
    SELECT
        a.zip_code,
        dt.disability_name,
        COUNT(*) AS total_count
    FROM Event e
    JOIN Address a
        ON e.address_id = a.address_id
    JOIN Survey s
        ON e.event_id = s.event_id
    JOIN Survey_Response sr
        ON s.survey_id = sr.survey_id
    JOIN Disability_Type dt
        ON sr.disability_type_id = dt.disability_type_id
    WHERE s.survey_target_type = 'participant'
      AND dt.disability_name IS NOT NULL
    GROUP BY
        a.zip_code,
        dt.disability_name
),
ranked_zips AS (
    SELECT
        zip_code,
        disability_name,
        total_count,
        RANK() OVER (
            PARTITION BY zip_code
            ORDER BY total_count DESC
        ) AS rank_num
    FROM zip_disability_counts
)
SELECT
    zip_code,
    disability_name AS dominant_disability_group,
    total_count AS occurrences
FROM ranked_zips
WHERE rank_num = 1
ORDER BY zip_code;
*/

-- ==================
-- Task 8
-- ==================
/*
CCAG administrators want to create a view that displays each participant’s
pre-score, post-score, change score, and completion status in order to monitor
improvement and measure program impact.
*/
/*
CREATE OR REPLACE VIEW participant_progress_view AS
SELECT
    sr.response_id,
    s.survey_id,
    s.event_id,
    e.event_name,
    e.event_location_name,
    sr.response_date,
    sr.disability_type_id,
    dt.disability_name,

    MAX(CASE
        WHEN q.question_text ILIKE '%met needs%'
        THEN CAST(a.answer_value AS DECIMAL)
    END) AS pre_score,

    MAX(CASE
        WHEN q.question_text ILIKE '%satisfaction%'
        THEN CAST(a.answer_value AS DECIMAL)
    END) AS post_score,

    MAX(CASE
        WHEN q.question_text ILIKE '%satisfaction%'
        THEN CAST(a.answer_value AS DECIMAL)
    END)
    -
    MAX(CASE
        WHEN q.question_text ILIKE '%met needs%'
        THEN CAST(a.answer_value AS DECIMAL)
    END) AS change_score,

    CASE
        WHEN MAX(CASE WHEN q.question_text ILIKE '%met needs%' THEN a.answer_value END) IS NOT NULL
         AND MAX(CASE WHEN q.question_text ILIKE '%satisfaction%' THEN a.answer_value END) IS NOT NULL
        THEN 'Complete'
        ELSE 'Incomplete'
    END AS completion_status

FROM Survey s
JOIN Survey_Response sr
    ON s.survey_id = sr.survey_id
JOIN Event e
    ON s.event_id = e.event_id
LEFT JOIN Disability_Type dt
    ON sr.disability_type_id = dt.disability_type_id
JOIN Answer a
    ON sr.response_id = a.response_id
JOIN Question q
    ON a.question_id = q.question_id

WHERE s.survey_target_type = 'participant'
GROUP BY
    sr.response_id,
    s.survey_id,
    s.event_id,
    e.event_name,
    e.event_location_name,
    sr.response_date,
    sr.disability_type_id,
    dt.disability_name;

SELECT * 
FROM participant_progress_view
ORDER BY response_date, event_id, response_id;
*/

-- ==================
-- Task 9
-- ==================
/*
CCAG administrators want to compare participant satisfaction, meal completeness,
and return interest across event locations to determine which locations are the
most effective for future Meals That Matter distributions.
*/
/*
SELECT
    e.event_location_name,
    COUNT(DISTINCT sr.response_id) AS total_responses,

    ROUND(AVG(CASE
        WHEN q.question_text ILIKE '%Program satisfaction%'
        THEN CAST(a.answer_value AS DECIMAL)
    END), 2) AS avg_satisfaction,

    ROUND(AVG(CASE
        WHEN q.question_text ILIKE '%Event met needs%'
        THEN CAST(a.answer_value AS DECIMAL)
    END), 2) AS avg_needs_met,

    ROUND(
        100.0 * COUNT(CASE
            WHEN q.question_text ILIKE '%meal was complete%'
             AND a.answer_value = 'true' THEN 1
        END)
        / NULLIF(COUNT(DISTINCT sr.response_id), 0),
    2) AS meal_complete_percentage

FROM Survey s
JOIN Survey_Response sr ON s.survey_id = sr.survey_id
JOIN Event e ON s.event_id = e.event_id
JOIN Answer a ON sr.response_id = a.response_id
JOIN Question q ON a.question_id = q.question_id

WHERE s.survey_target_type = 'participant'

GROUP BY
    e.event_location_name

ORDER BY
    avg_satisfaction DESC;

*/


-- ==================
-- Task 10
-- ==================
/*
CCAG administrators want to evaluate staff and volunteer experience by event
in order to identify trends in training clarity, communication, supplies readiness,
overall experience, and perceived support.
*/
/*
SELECT
    e.event_id,
    e.event_name,
    e.event_location_name,

    COUNT(DISTINCT sr.response_id) AS total_staff_volunteer_responses,

    ROUND(AVG(CASE
        WHEN q.question_text ILIKE '%Training clarity%'
        THEN CAST(a.answer_value AS DECIMAL)
    END), 2) AS avg_training_clarity,

    ROUND(AVG(CASE
        WHEN q.question_text ILIKE '%Communication rating%'
        THEN CAST(a.answer_value AS DECIMAL)
    END), 2) AS avg_communication,

    ROUND(AVG(CASE
        WHEN q.question_text ILIKE '%Supplies ready%'
        THEN CAST(a.answer_value AS DECIMAL)
    END), 2) AS avg_supplies_ready,

    ROUND(AVG(CASE
        WHEN q.question_text ILIKE '%Overall experience%'
        THEN CAST(a.answer_value AS DECIMAL)
    END), 2) AS avg_overall_experience,

    ROUND(
        100.0 * COUNT(CASE
            WHEN q.question_text ILIKE '%supported%'
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

*/


-- ==================
-- Task 11
-- ==================
/*
CCAG administrators want to evaluate participation and satisfaction across zip codes
to identify which geographic areas have the highest community reach and engagement.
*/
/*
SELECT
    a.zip_code,

    COUNT(DISTINCT e.event_id) AS total_events,

    SUM(e.individuals_served) AS total_participants_served,

    COUNT(DISTINCT sr.response_id) AS total_survey_responses,

    ROUND(AVG(CASE
        WHEN q.question_text ILIKE '%Program satisfaction%'
        THEN CAST(ans.answer_value AS DECIMAL)
    END), 2) AS avg_satisfaction,

    ROUND(AVG(CASE
        WHEN q.question_text ILIKE '%Event met needs%'
        THEN CAST(ans.answer_value AS DECIMAL)
    END), 2) AS avg_needs_met

FROM Event e
JOIN Address a ON e.address_id = a.address_id
JOIN Survey s ON e.event_id = s.event_id
JOIN Survey_Response sr ON s.survey_id = sr.survey_id
JOIN Answer ans ON sr.response_id = ans.response_id
JOIN Question q ON ans.question_id = q.question_id

WHERE s.survey_target_type = 'participant'

GROUP BY
    a.zip_code

ORDER BY
    total_participants_served DESC,
    avg_satisfaction DESC;

*/

-- ==================
-- Task 12
-- ==================
/*
CCAG administrators want to identify which event locations are performing above
the overall average participation level in order to highlight high-impact locations
and guide future resource allocation.
*/
/*
SELECT
    sub.event_location_name,
    sub.zip_code,
    ROUND( sub.avg_participants_served, 2) AS avg_participants_served
FROM (
--	this section below calculates average participants per location as 'sub'
    SELECT
        e.event_location_name,
        a.zip_code,
        AVG(e.individuals_served) AS avg_participants_served
    FROM event e
    LEFT JOIN Address a ON e.address_id = a.address_id
    GROUP BY
        e.event_location_name,
        a.zip_code
) sub
WHERE sub.avg_participants_served > (
    SELECT AVG(individuals_served)
    FROM event
)
ORDER BY sub.avg_participants_served DESC;

*/