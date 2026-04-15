/************************************************
CCAG FINAL ANALYSIS QUERIES
Purpose: Analyze participation, satisfaction,
retention, and operational effectiveness, 
**This is a clean organize file of file ccag_insert.sql ** 
************************************************/






--Question Template:

/*--------------------------------------------------------------------------------(START-Task ##)-----------------------------------------------------------------------------------*/
/*-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Task: 

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/* ---------------T.##----Put"/" next to star"------*/




-------------------*/
/*--------------------------------------------------------------------------------(END-Task ##)-----------------------------------------------------------------------------------*/






--
--
--

/*--------------------------------------------------------------------------------(START-Task 01)-----------------------------------------------------------------------------------*/
/*-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Task: 
CCAG administrators want to identify which meal distribution collabs had the highest 
participant satisfaction so they can replicate the most effective event practices in future programs.

-evaluate which partner organization produce the stringest participant satisfaction outcomes.

-join: organziation, event, and participant_survey tables
-average; calaualating te avaerage score per location(based off of satisfaction and needs_met)
-couting: counting the amount of surveys recieved from each organization. 

Results: Based off of the locations provided we were able to see that the orgaization has ben doing quite
well throughout. Ou top 3 locations are "Senior Friendship Centers", "United Cerebral Palsy of SWFL", and "Community Resource Network".
To conitue the quality of work that was put into the listed events toward future events as well as reviewing training and 
update on current resources to improve coordintion, adapitlity and convienece for the team.This analysis evaluates participant satisfaction 
across collaborating organizations by calculating average satisfaction and needs-met ratings for each partner. The results highlight which 
organizations consistently deliver high-quality experiences, with Senior Friendship Centers and United Cerebral Palsy of SWFL showing the highest 
satisfaction levels. Additionally, organizations with both high satisfaction and a large number of responses provide the most reliable indicators of
effective event practices. These insights enable CCAG to replicate successful strategies, improve lower-performing collaborations, and make informed 
decisions when planning future Meals That Matter distributions.
for example Senior Friendship Centers had an avaerage satisfaction score of 4.67 and an avaerage needs-met score of 4.89 based across 9 responses.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/* ---------------T.01----Put"/" next to star"------*
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



-------------------*/
/*--------------------------------------------------------------------------------(END-Task 01)-----------------------------------------------------------------------------------*/





/*--------------------------------------------------------------------------------(START-Task 02)-----------------------------------------------------------------------------------*/
/*-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Task: 
CCAG administrators want to evaluate the relationship between event attendance, 
staffing levels, and volunteer needs to determine whether events are adequately 
staffed and to establish data-driven planning guidelines.

This analysis examines how event attendance compares to staffing levels, including both staff and volunteers, in order to evaluate operational efficiency. By calculating the number
of attendees per worker and separating staff from volunteers, the query provides insight into how workload is distributed across each event. Providing two examples from instance #1 and instance #8.
Upon Event 1, the estimated attendance was 15 participants, which falls under the Low category. Based on this estimate, the recommended number of volunteers was 3. After the event, the actual number 
of participants served was 40, resulting in an increase of 25 attendees. Despite the increase, the event still remained within the Low category, meaning the original volunteer recommendation was
still sufficient. This analysis compares estimated and actual attendance across events by categorizing both into defined attendance levels and calculating the difference between expected and
actual participation. The results show that many events were overestimated, particularly those classified as high or above high, where actual attendance was significantly lower than expected. 
These discrepancies highlight inefficiencies in planning,such as excess volunteer allocation and potential resource waste. By using this analysis, CCAG can improve forecasting accuracy, optimize 
staffing levels, and better align resources with actual community demand.
 Close look: Another example can be seen in Event 8, where the estimated attendance was 138 participants, categorized as Above High, with a recommended 15 volunteers. However, the actual number 
 of participants served was only 58, which falls under the Medium category, requiring approximately 6 volunteers. This resulted in an overestimation of 80 participants, indicating that significantly 
 more resources were planned than necessary.





------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/* ---------------T.02----Put"/" next to star"------*
SELECT
    e.event_id,
    e.event_name,
    e.individuals_estimated,
    est.level_name AS estimated_level,
    est.recommended_volunteers AS recommended_volunteers_by_estimate,
    e.individuals_served,
    act.level_name AS actual_level,
    act.recommended_volunteers AS recommended_volunteers_by_actual,
    (e.individuals_served - e.individuals_estimated) AS attendance_difference

FROM event e

JOIN attendance_levels est
    ON e.individuals_estimated BETWEEN est.min_people AND est.max_people

JOIN attendance_levels act
    ON e.individuals_served BETWEEN act.min_people AND act.max_people

ORDER BY e.event_id;



-------------------*/
/*--------------------------------------------------------------------------------(END-Task 02)-----------------------------------------------------------------------------------*/








/*--------------------------------------------------------------------------------(START-Task 03)-----------------------------------------------------------------------------------*/
/*-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Task: 
CCAG administrators want to compare pre-event expectations and post-event outcomes to measure
change in participant experience and determine whether Meals That Matter is meeting community needs.

Notes: 
To plan accuracy uppon participant outcomes. 
classifications are based on Underestimated, Overestimated, and Accurate under the collun named 'planning_status' using the CASE logic.
This query compares estimated attendance with actual attendance and participant outcomes for each Meals That Matter event. By calculating 
the attendance difference and assigning a planning status of underestimated, overestimated, or accurate, the analysis helps evaluate
planning accuracy. It also incorporates participant satisfaction and needs-met ratings to determine whether events are still meeting
community needs despite attendance differences. The results suggest that many events were overestimated, which may indicate inefficient
resource planning, while participant outcomes remained generally positive. This helps CCAG improve forecasting, reduce waste, and better
align future event preparation with actual community demand.



------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/* ---------------T.03----Put"/" next to star"------*

SELECT
    e.event_id,
    e.event_name,
    e.event_date,
    e.individuals_estimated,
    e.individuals_served,
    (e.individuals_served - e.individuals_estimated) AS attendance_difference,

    CASE
        WHEN e.individuals_served > e.individuals_estimated THEN 'Underestimated'
        WHEN e.individuals_served < e.individuals_estimated THEN 'Overestimated'
        ELSE 'Accurate'
    END AS planning_status,

    ROUND(AVG(ps.program_satisfaction), 2) AS avg_satisfaction,
    ROUND(AVG(ps.event_met_needs), 2) AS avg_needs_met,
    COUNT(ps.response_id) AS total_participant_responses

FROM event e
LEFT JOIN participant_survey ps
    ON e.event_id = ps.event_id

GROUP BY
    e.event_id,
    e.event_name,
    e.event_date,
    e.individuals_estimated,
    e.individuals_served

ORDER BY e.event_date;



-------------------*/
/*--------------------------------------------------------------------------------(END-Task 03)-----------------------------------------------------------------------------------*/







/*--------------------------------------------------------------------------------(START-Task 04)-----------------------------------------------------------------------------------*/
/*-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Task: 
CCAG administrators want to identify which disability groups reported the highest and lowest satisfaction 
levels so that future activities and food distribution strategies can be better tailored to participant needs.

Notes: 
This analysis evaluates participant satisfaction across different disability groups by calculating the average satisfaction and needs-met ratings for each group. The results show that participants with
hearing impairments reported the highest satisfaction levels, while participants with traumatic brain injury reported the lowest satisfaction.
However, it is important to consider the number of responses per group. Some groups, such as hearing impairment and traumatic brain injury, have very
small sample sizes, which may limit the reliability of their results. In contrast, groups such as physical disability, intellectual disability, and developmental
disability have higher response counts, making their averages more representative of overall participant experience.
These findings suggest that while overall satisfaction is high across most groups, there may be opportunities to improve services for specific populations.
CCAG can use this information to better tailor food distribution strategies and support services to meet the needs of different disability groups.


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/* ---------------T.04----Put"/" next to star"------*

SELECT
    COALESCE(dt.disability_name, 'Not Specified') AS disability_group,
    
    ROUND(AVG(ps.program_satisfaction), 2) AS avg_satisfaction,
    ROUND(AVG(ps.event_met_needs), 2) AS avg_needs_met,
    
    COUNT(ps.response_id) AS total_responses

FROM participant_survey ps

LEFT JOIN disability_type dt
    ON ps.disability_type_id = dt.disability_type_id

GROUP BY COALESCE(dt.disability_name, 'Not Specified')

ORDER BY avg_satisfaction DESC;


-------------------*/
/*--------------------------------------------------------------------------------(END-Task 04)-----------------------------------------------------------------------------------*/









/*--------------------------------------------------------------------------------(START-Task 05)-----------------------------------------------------------------------------------*/
/*-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Task: 
CCAG administrators want to generate a summary report of participants served by event location, 
date, and zip code, and compare average participation levels across locations to identify above- and below-average community reach.

Notes: 
This analysis evaluates community reach by summarizing total and average participation across event locations and zip codes. By calculating the average number 
of participants served per event and comparing it to the overall program average, each location is classified as above or below average. The results show that 
locations such as St. Matthew House and Senior Friendship Centers consistently serve higher numbers of participants per event, indicating strong community 
engagement. In contrast, locations with lower averages may require additional outreach or support. This analysis enables CCAG to identify high-performing locations, 
improve lower-performing areas, and make data-driven decisions for future event planning and resource allocation.
Some locations may have high total participation due to frequent events, but average participation per event provides a more accurate measure of engagement, allowing CCAG to fairly compare performance across locations.

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/* ---------------T.05----Put"/" next to star"------*

WITH location_stats AS (
    SELECT 
        e.event_location_name,
        e.zip_code,

        COUNT(e.event_id) AS total_events,
        SUM(e.individuals_served) AS total_participants_served,
        ROUND(AVG(e.individuals_served), 2) AS avg_participants_served

    FROM event e

    GROUP BY 
        e.event_location_name,
        e.zip_code
),

overall_avg AS (
    SELECT 
        AVG(individuals_served) AS overall_avg_participants
    FROM event
)

SELECT
    ls.*,

    CASE
        WHEN ls.avg_participants_served > oa.overall_avg_participants THEN 'Above Average'
        WHEN ls.avg_participants_served < oa.overall_avg_participants THEN 'Below Average'
        ELSE 'Average'
    END AS performance_level

FROM location_stats ls
CROSS JOIN overall_avg oa

ORDER BY ls.avg_participants_served DESC;



-------------------*/
/*--------------------------------------------------------------------------------(END-Task 05)-----------------------------------------------------------------------------------*/









/*--------------------------------------------------------------------------------(START-Task 06)-----------------------------------------------------------------------------------*/
/*-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Task: 
CCAG administrators want to analyze participant engagement and retention by examining visit frequency 
and willingness to participate again, in order to identify patterns in repeat participation and potential drop-off rates.



Notes: 
This analysis evaluates participant engagement and retention by grouping participants according
to visit frequency and measuring the percentage willing to participate again. The results show that 
monthly and weekly participants have the highest return rates, indicating strong ongoing engagement 
with the program. Although return rates are positive across all groups, first-time participants show 
the lowest retention intent, suggesting a possible area for improvement. These findings help CCAG identify 
loyal participant groups, better understand potential drop-off patterns, and develop strategies to improve 
long-term engagement and program continuity.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/* ---------------T.06----Put"/" next to star"------*
SELECT
    ps.visit_frequency,

    COUNT(ps.response_id) AS total_participants,

    ROUND(
        100.0 * SUM(CASE WHEN ps.would_participate_again = TRUE THEN 1 ELSE 0 END)
        / COUNT(ps.response_id),
        2
    ) AS participation_rate

FROM participant_survey ps

GROUP BY ps.visit_frequency

ORDER BY participation_rate DESC;




-------------------*/
/*--------------------------------------------------------------------------------(END-Task 06)-----------------------------------------------------------------------------------*/












/*--------------------------------------------------------------------------------(START-Task 07)-----------------------------------------------------------------------------------*/
/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
Task: 
CCAG administrators want to analyze which disability groups are most frequently served at each event location or zip code in order to identify dominant demographics and 
improve targeted outreach, marketing efforts, and resource distribution for future Meals That Matter events.

Notes:
The location-based query identifies dominant disability groups at specific event sites, while the zip-code-based query identifies dominant disability groups across broader 
geographic areas. The location query is more useful for site-level planning, whereas the zip code query is more useful for outreach, marketing, and geographic resource allocation.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/* ---------------T.##----Put"/" next to star"------*/

--location 
/*

WITH ranked_groups AS (
    SELECT
        e.event_location_name,
        dt.disability_name,
        COUNT(ps.response_id) AS total_participants,

        ROW_NUMBER() OVER (
            PARTITION BY e.event_location_name
            ORDER BY COUNT(ps.response_id) DESC
        ) AS rank

    FROM participant_survey ps

    JOIN event e
        ON ps.event_id = e.event_id

    LEFT JOIN disability_type dt
        ON ps.disability_type_id = dt.disability_type_id

    GROUP BY
        e.event_location_name,
        dt.disability_name
)

SELECT
    event_location_name,
    disability_name,
    total_participants,
    rank

FROM ranked_groups

WHERE rank <= 3

ORDER BY event_location_name, rank; 
*/

--------------------------------------------zip
/*

WITH ranked_groups AS (
    SELECT
        e.zip_code,
        dt.disability_name,
        COUNT(ps.response_id) AS total_participants,

        ROW_NUMBER() OVER (
            PARTITION BY e.zip_code
            ORDER BY COUNT(ps.response_id) DESC
        ) AS rank

    FROM participant_survey ps

    JOIN event e
        ON ps.event_id = e.event_id

    LEFT JOIN disability_type dt
        ON ps.disability_type_id = dt.disability_type_id

    GROUP BY
        e.zip_code,
        dt.disability_name
)

SELECT
    zip_code,
    disability_name,
    total_participants,
    rank

FROM ranked_groups

WHERE rank <= 3

ORDER BY zip_code, rank;

/*

-------------------
/*--------------------------------------------------------------------------------(END-Task 07)-----------------------------------------------------------------------------------*/









/*--------------------------------------------------------------------------------(START-Task 08)-----------------------------------------------------------------------------------*/
/*-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Task: 
CCAG administrators want to create a view that displays participant
experience metrics, including satisfaction, needs-met ratings, meal completeness,
and willingness to participate again, in order to monitor participant experience and evaluate program effectiveness.

Notes: 
This task creates a reusable participant experience view that combines survey responses with event details and disability group information. The view includes participant
satisfaction, needs-met ratings, meal completeness, visit frequency, and willingness to participate again, allowing CCAG to monitor participant experience and evaluate 
overall program effectiveness. By centralizing these measures into one view, CCAG can simplify future reporting, support deeper analysis across demographic groups and events, 
and make more informed decisions about service improvement and outreach strategies.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/* ---------------T.08----Put"/" next to star"------*

CREATE VIEW participant_experience_view AS
SELECT
    ps.response_id,
    e.event_id,
    e.event_name,
    e.event_date,
    dt.disability_name,
    ps.visit_frequency,
    ps.program_satisfaction,
    ps.event_met_needs,
    ps.felt_complete_meal,
    ps.would_participate_again
FROM participant_survey ps
LEFT JOIN event e
    ON ps.event_id = e.event_id
LEFT JOIN disability_type dt
    ON ps.disability_type_id = dt.disability_type_id;
*/



--SELECT * FROM participant_experience_view;


-------------------*/
/*--------------------------------------------------------------------------------(END-Task 08)-----------------------------------------------------------------------------------*/










/*--------------------------------------------------------------------------------(START-Task 09)-----------------------------------------------------------------------------------*/
/*-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Task: 
CCAG administrators want to compare participant satisfaction, meal completeness, and return
interest across event locations to determine which locations are the most effective for future Meals That Matter distributions.

Notes:
This analysis compares participant outcomes across event locations by measuring average satisfaction, needs-met ratings, meal completeness, and willingness to 
participate again. The results show that meal completeness is consistently strong across all locations, while differences in satisfaction and return interest
help distinguish higher-performing and lower-performing sites. Locations such as Senior Friendship Centers and United Cerebral Palsy of SWFL demonstrate especially 
strong participant outcomes, suggesting that their practices may serve as effective models for future Meals That Matter distributions. This analysis helps CCAG
identify successful locations, improve lower-performing sites, and make more informed decisions about future program planning and resource allocation.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/* ---------------T.09----Put"/" next to star"------*
SELECT
    e.event_location_name,
    e.zip_code,

    COUNT(ps.response_id) AS total_responses,

    ROUND(AVG(ps.program_satisfaction), 2) AS avg_satisfaction,
    ROUND(AVG(ps.event_met_needs), 2) AS avg_needs_met,

    ROUND(
        100.0 * SUM(CASE
            WHEN ps.felt_complete_meal = TRUE THEN 1
            ELSE 0
        END) / COUNT(ps.response_id),
        2
    ) AS meal_complete_percentage,

    ROUND(
        100.0 * SUM(CASE
            WHEN ps.would_participate_again = TRUE THEN 1
            ELSE 0
        END) / COUNT(ps.response_id),
        2
    ) AS return_interest_percentage

FROM participant_survey ps
JOIN event e
    ON ps.event_id = e.event_id

GROUP BY
    e.event_location_name,
    e.zip_code

ORDER BY
    avg_satisfaction DESC,
    return_interest_percentage DESC;



-------------------*/
/*--------------------------------------------------------------------------------(END-Task 09)-----------------------------------------------------------------------------------*/











/*--------------------------------------------------------------------------------(START-Task 10)-----------------------------------------------------------------------------------*/
/*-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Task: CCAG administrators want to evaluate staff and volunteer experience by event in order to identify 
trends in training clarity, communication, safety, overall experience, and willingness to volunteer again for future service.

Notes: 
This analysis evaluates staff and volunteer experience across events by calculating average ratings for training clarity, communication, supplies readiness, safety, 
and overall experience, along with return rates and perceived support. The results indicate consistently high satisfaction levels and strong willingness to volunteer 
again, suggesting that CCAG events are well-organized and supportive for staff and volunteers. However, the relatively small number of survey responses per event may 
limit the reliability of these findings. Overall, this analysis helps CCAG confirm effective operational practices, monitor volunteer satisfaction, and identify areas
for continued improvement.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/* ---------------T.10----Put"/" next to star"------*

SELECT
    e.event_id,
    e.event_name,
    e.event_date,
    e.event_location_name,

    COUNT(svs.staff_response_id) AS total_staff_volunteer_responses,

    ROUND(AVG(svs.training_clarity_rating), 2) AS avg_training_clarity,
    ROUND(AVG(svs.communication_rating), 2) AS avg_communication,
    ROUND(AVG(svs.supplies_ready_rating), 2) AS avg_supplies_ready,
    ROUND(AVG(svs.safety_rating), 2) AS avg_safety,
    ROUND(AVG(svs.overall_experience_rating), 2) AS avg_overall_experience,

    ROUND(
        100.0 * SUM(CASE
            WHEN svs.would_volunteer_again = TRUE THEN 1
            ELSE 0
        END) / COUNT(svs.staff_response_id),
        2
    ) AS return_rate_percentage,

    ROUND(
        100.0 * SUM(CASE
            WHEN svs.felt_supported = TRUE THEN 1
            ELSE 0
        END) / COUNT(svs.staff_response_id),
        2
    ) AS felt_supported_percentage

FROM staff_volunteer_survey svs
JOIN event e
    ON svs.event_id = e.event_id

GROUP BY
    e.event_id,
    e.event_name,
    e.event_date,
    e.event_location_name

ORDER BY
    avg_overall_experience DESC,
    return_rate_percentage DESC;


-------------------*/
/*--------------------------------------------------------------------------------(END-Task 10)-----------------------------------------------------------------------------------*/










/*--------------------------------------------------------------------------------(START-Task 11)-----------------------------------------------------------------------------------*/
/*-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Task: CCAG administrators want to evaluate staff and volunteer experience by event to identify
trends in training clarity, communication, safety, and willingness to return for future service.

Notes:
This analysis evaluates staff and volunteer experience across events by calculating average ratings for training clarity, communication, 
supplies readiness, safety, and overall experience, along with return rates and perceived support. The results indicate consistently high 
satisfaction and strong willingness to return, suggesting that CCAG events are well-organized and supportive for staff and volunteers. However,
the relatively small number of survey responses per event may limit the reliability of these findings. Overall, this analysis helps CCAG confirm
effective operational practices, maintain volunteer engagement, and identify opportunities for improved feedback collection.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/* ---------------T.11----Put"/" next to star"------*


SELECT
    e.event_id,
    e.event_name,
    e.event_date,
    e.event_location_name,

    COUNT(svs.staff_response_id) AS total_responses,

    ROUND(AVG(svs.training_clarity_rating), 2) AS avg_training_clarity,
    ROUND(AVG(svs.communication_rating), 2) AS avg_communication,
    ROUND(AVG(svs.supplies_ready_rating), 2) AS avg_supplies_ready,
    ROUND(AVG(svs.safety_rating), 2) AS avg_safety,
    ROUND(AVG(svs.overall_experience_rating), 2) AS avg_overall_experience,

    ROUND(
        100.0 * SUM(CASE
            WHEN svs.would_volunteer_again = TRUE THEN 1
            ELSE 0
        END) / COUNT(svs.staff_response_id),
        2
    ) AS return_rate_percentage,

    ROUND(
        100.0 * SUM(CASE
            WHEN svs.felt_supported = TRUE THEN 1
            ELSE 0
        END) / COUNT(svs.staff_response_id),
        2
    ) AS felt_supported_percentage

FROM staff_volunteer_survey svs
JOIN event e
    ON svs.event_id = e.event_id

GROUP BY
    e.event_id,
    e.event_name,
    e.event_date,
    e.event_location_name

ORDER BY
    avg_overall_experience DESC,
    return_rate_percentage DESC;





-------------------*/
/*--------------------------------------------------------------------------------(END-Task 11)-----------------------------------------------------------------------------------*/










/*--------------------------------------------------------------------------------(START-Task 12)-----------------------------------------------------------------------------------*/
/*-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Task: 
Which zip codes had the highest participation and highest average satisfaction/improvement?

Notes: 
This analysis evaluates participation and participant outcomes across zip codes by measuring total participants served, average satisfaction, needs-met ratings, 
and return interest. The results show that zip codes such as 34102 have the highest participation levels, while areas like 33905 demonstrate the highest satisfaction 
and needs-met scores. These findings highlight that high participation does not always correspond to the highest participant satisfaction, emphasizing the importance 
of balancing reach with service quality. This analysis enables CCAG to identify high-impact regions, improve lower-performing areas, and develop more effective, 
geographically targeted strategies for future Meals That Matter events.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/* ---------------T.12----Put"/" next to star"------*

SELECT
    e.zip_code,

    COUNT(DISTINCT e.event_id) AS total_events,

    SUM(e.individuals_served) AS total_participants_served,

    COUNT(ps.response_id) AS total_survey_responses,

    ROUND(AVG(ps.program_satisfaction), 2) AS avg_satisfaction,
    ROUND(AVG(ps.event_met_needs), 2) AS avg_needs_met,

    ROUND(
        100.0 * SUM(CASE
            WHEN ps.would_participate_again = TRUE THEN 1
            ELSE 0
        END) / COUNT(ps.response_id),
        2
    ) AS return_rate_percentage

FROM event e
LEFT JOIN participant_survey ps
    ON e.event_id = ps.event_id

GROUP BY e.zip_code

ORDER BY
    total_participants_served DESC,
    avg_satisfaction DESC;


-------------------*/
/*--------------------------------------------------------------------------------(END-Task 12)-----------------------------------------------------------------------------------*/










/*--------------------------------------------------------------------------------(START-Task 13)-----------------------------------------------------------------------------------*/
/*-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Task: 
CCAG administrators want to identify which event locations are performing above the overall average participation level in order to highlight high-impact locations and guide future resource allocation.

Notes: 
This analysis identifies event locations that exceed the overall program average in participants served per event, providing a benchmark-based evaluation of performance. By 
focusing on average participation rather than total counts, the analysis highlights locations with consistently strong community engagement. Results show that locations such 
as St. Matthew House and Senior Friendship Centers serve significantly more participants per event, indicating high-impact service areas. These findings suggest that factors 
such as location accessibility, community awareness, and partnership strength may contribute to higher participation. This analysis enables CCAG to allocate resources more 
+strategically, prioritize high-demand areas, and replicate successful outreach strategies in lower-performing regions.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/* ---------------T.13----Put"/" next to star"------*/

/* Task – Locations Above Overall Average Participation *

SELECT
    sub.event_location_name,
    sub.zip_code,
    sub.avg_participants_served
FROM (
    SELECT
        e.event_location_name,
        e.zip_code,
        AVG(e.individuals_served) AS avg_participants_served
    FROM event e
    GROUP BY e.event_location_name, e.zip_code
) sub
WHERE sub.avg_participants_served > (
    SELECT AVG(individuals_served)
    FROM event
)
ORDER BY sub.avg_participants_served DESC;


-------------------*/
/*--------------------------------------------------------------------------------(END-Task 13)-----------------------------------------------------------------------------------*/










/*--------------------------------------------------------------------------------(START-Task ##)-----------------------------------------------------------------------------------*/
/*-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Task: 

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/* ---------------T.##----Put"/" next to star"------*/




-------------------*/
/*--------------------------------------------------------------------------------(END-Task ##)-----------------------------------------------------------------------------------*/
