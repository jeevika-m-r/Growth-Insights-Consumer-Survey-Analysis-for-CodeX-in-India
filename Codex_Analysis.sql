-- Codex Analysis --

-- created a new table respondents_by_cities--
use codex;
-- Create the new table --
CREATE TABLE CodeX.respondents_by_city AS
SELECT 
    dc.City_ID,
    dc.City,
    COUNT(dr.Respondent_ID) AS Total_Respondents
FROM 
    CodeX.dim_cities dc
LEFT JOIN 
    CodeX.dim_repondents dr ON dc.City_ID = dr.City_ID
GROUP BY 
    dc.City_ID, dc.City
ORDER BY 
    Total_Respondents DESC;
    
-- to retrieve entire data from respondents_by_city table --
SELECT *
FROM respondents_by_city;

-- to retrieve entire data from dim_cities table --
SELECT *
FROM dim_cities;

-- to retrieve entire data from dim_repondents table --
SELECT *
FROM dim_repondents;

-- to retrieve entire data from fact_survey_responses --
SELECT *
FROM fact_survey_responses;

-- Demographic Insights --

-- Which gender prefer energy drinks more ? --
SELECT 
    dr.Gender, COUNT(*) AS Frequent_Consumers
FROM
    dim_repondents dr
        JOIN
    fact_survey_responses fsr ON dr.Respondent_ID = fsr.Respondent_ID
WHERE
    fsr.Consume_frequency IN ('Daily' , '2-3 times a week', 'Once a week')
GROUP BY dr.Gender;

-- Which age group prefer energy drink more ? --
SELECT 
    dr.Age, COUNT(*) AS Total_Respondents
FROM
    dim_repondents dr
        JOIN
    fact_survey_responses fsr ON dr.Respondent_ID = fsr.Respondent_ID
GROUP BY dr.Age;

-- Which type of marketing reaches the youth? --
SELECT 
    dr.Age,
    COUNT(*) AS Total_Respondents,
    fsr.Marketing_channels
FROM
    dim_repondents dr
        LEFT JOIN
    fact_survey_responses fsr ON dr.Respondent_ID = fsr.Respondent_ID
WHERE
    dr.Age = '19-30'
GROUP BY fsr.Marketing_channels;

-- Which tier show the highest energy drink consumption ? --
SELECT 
    dc.Tier, COUNT(*) AS Total_Respondent
FROM
    dim_cities dc
        JOIN
    dim_repondents dr ON dc.City_ID = dr.City_ID
        JOIN
    fact_survey_responses fsr ON dr.Respondent_ID = fsr.Respondent_ID
WHERE
    fsr.Consume_frequency IN ('Daily' , '2-3 times a week',
        'Once a week',
        '2-3 times a month')
GROUP BY dc.Tier
ORDER BY Total_Respondent DESC;

-- Consumer Preferences --

-- What are the preferred ingredients of energy drink among respondents ? --
SELECT 
    fsr.Ingredients_expected, COUNT(*) AS Total_Respondents
FROM
    dim_repondents dr
        LEFT JOIN
    fact_survey_responses fsr ON dr.Respondent_ID = fsr.Respondent_ID
GROUP BY fsr.Ingredients_expected
ORDER BY Total_Respondents DESC;

-- What packaging preferences do respondents have for energy drink? --
SELECT 
    fsr.Packaging_preference, COUNT(*) AS Total_Respondents
FROM
    dim_repondents dr
        LEFT JOIN
    fact_survey_responses fsr ON dr.Respondent_ID = fsr.Respondent_ID
GROUP BY fsr.Packaging_preference
ORDER BY Total_Respondents DESC;

-- What are the preferred ingredients among the age group with the highest energy drink consumption ? --
-- Age Group : 15-18 --
SELECT 
    fsr.Ingredients_expected,
    dr.Age,
    COUNT(*) AS Total_Respondent
FROM
    dim_repondents dr
        JOIN
    fact_survey_responses fsr ON dr.Respondent_ID = fsr.Respondent_ID
WHERE
    dr.Age = '15-18'
GROUP BY fsr.Ingredients_expected , dr.Age
ORDER BY Total_Respondent DESC;

-- Age Group : 19-30 --
SELECT 
    fsr.Ingredients_expected,
    dr.Age,
    COUNT(*) AS Total_Respondent
FROM
    dim_repondents dr
        JOIN
    fact_survey_responses fsr ON dr.Respondent_ID = fsr.Respondent_ID
WHERE
    dr.Age = '19-30'
GROUP BY fsr.Ingredients_expected , dr.Age
ORDER BY Total_Respondent DESC;

-- Age Group: 31-45 --
SELECT 
    fsr.Ingredients_expected,
    dr.Age,
    COUNT(*) AS Total_Respondent
FROM
    dim_repondents dr
        JOIN
    fact_survey_responses fsr ON dr.Respondent_ID = fsr.Respondent_ID
WHERE
    dr.Age = '31-45'
GROUP BY fsr.Ingredients_expected , dr.Age
ORDER BY Total_Respondent DESC;

-- Age Group : 46-65 --
SELECT 
    fsr.Ingredients_expected,
    dr.Age,
    COUNT(*) AS Total_Respondent
FROM
    dim_repondents dr
        JOIN
    fact_survey_responses fsr ON dr.Respondent_ID = fsr.Respondent_ID
WHERE
    dr.Age = '46-65'
GROUP BY fsr.Ingredients_expected , dr.Age
ORDER BY Total_Respondent DESC;

-- Age Group : 65+ --
SELECT 
    fsr.Ingredients_expected,
    dr.Age,
    COUNT(*) AS Total_Respondent
FROM
    dim_repondents dr
        JOIN
    fact_survey_responses fsr ON dr.Respondent_ID = fsr.Respondent_ID
WHERE
    dr.Age = '65+'
GROUP BY fsr.Ingredients_expected , dr.Age
ORDER BY Total_Respondent DESC;

-- How does taste experience vary across different age group when it comes to energy drink ? --
SELECT 
    fsr.Taste_experience, dr.Age, COUNT(*) AS Total_Respondent
FROM
    dim_repondents dr
        JOIN
    fact_survey_responses fsr ON dr.Respondent_ID = fsr.Respondent_ID
WHERE
    dr.Age = '19-30'
GROUP BY fsr.Taste_experience , dr.Age
ORDER BY Total_Respondent DESC;

-- At what time do respondents prefer to have energy drink and how frequently do they consume them ? --
SELECT 
    fsr.Consume_time,
    fsr.Consume_frequency,
    COUNT(fsr.Respondent_ID) AS Total_Respondents
FROM
    fact_survey_responses fsr
GROUP BY fsr.Consume_time , fsr.Consume_frequency
ORDER BY fsr.Consume_time , Total_Respondents DESC;

-- How do respondents perceive the brand in terms of design and -- 
-- how does this reltaed to their general perception of energy drinks ? --
SELECT 
    fsr.Brand_perception, 
    fsr.General_perception, 
    COUNT(*) AS count_responses
FROM 
    fact_survey_responses fsr
WHERE 
    fsr.Brand_perception = 'Positive' 
    AND fsr.General_perception IN ('Healthy', 'Effective')
GROUP BY 
    fsr.Brand_perception, 
    fsr.General_perception
ORDER BY 
    count_responses DESC;
    
-- Percentage of the positive perception --
   SELECT 
    COUNT(*) * 100.0 / (SELECT COUNT(*) FROM fact_survey_responses WHERE Brand_perception = 'Positive') AS percentage_positive_healthy_effective
FROM 
    fact_survey_responses fsr
WHERE 
    fsr.Brand_perception = 'Positive' 
    AND fsr.General_perception IN ('Healthy', 'Effective');
 
-- Negative perception --
SELECT 
    fsr.Brand_perception, 
    fsr.General_perception, 
    COUNT(*) AS count_responses
FROM 
    fact_survey_responses fsr
WHERE 
    fsr.Brand_perception = 'Negative' 
    AND fsr.General_perception = 'Dangerous'
GROUP BY 
    fsr.Brand_perception, 
    fsr.General_perception
ORDER BY 
    count_responses DESC;
    
-- Percentage of Negative Perception --
SELECT 
    COUNT(*) * 100.0 / (SELECT COUNT(*) FROM fact_survey_responses WHERE Brand_perception = 'Negative') AS percentage_negative_dangerous
FROM 
    fact_survey_responses fsr
WHERE 
    fsr.Brand_perception = 'Negative' 
    AND fsr.General_perception = 'Dangerous';

-- How does taste experience vary across different gender when it comes to energy drink ? --
 -- Gender : Female --
SELECT 
    fsr.Ingredients_expected,
    dr.Gender,
    COUNT(*) AS Total_Respondent
FROM
    dim_repondents dr
        JOIN
    fact_survey_responses fsr ON dr.Respondent_ID = fsr.Respondent_ID
WHERE
    dr.Gender IN ('Female')
GROUP BY fsr.Ingredients_expected , dr.Gender
ORDER BY Total_Respondent DESC;
 
 -- Gender : Male --
SELECT 
    fsr.Ingredients_expected,
    dr.Gender,
    COUNT(*) AS Total_Respondent
FROM
    dim_repondents dr
        JOIN
    fact_survey_responses fsr ON dr.Respondent_ID = fsr.Respondent_ID
WHERE
    dr.Gender IN ('Male')
GROUP BY fsr.Ingredients_expected , dr.Gender
ORDER BY Total_Respondent DESC;

-- Competition Analysis --

-- Who are the current market leaders ? --
SELECT Current_brands,COUNT(*) AS Total_Respondents,
 CONCAT(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM fact_survey_responses),2), '%') AS Market_Share_Percentage
FROM fact_survey_responses
GROUP BY Current_brands
ORDER BY Total_Respondents DESC;

-- What are the primary reasons consumers prefer these brands over ours ? --
SELECT 
    Current_brands,
    Reasons_for_choosing_brands,
    COUNT(*) AS Total_Respondents
FROM
    fact_survey_responses
WHERE
    Current_brands NOT IN ('CodeX')
GROUP BY Current_brands , Reasons_for_choosing_brands
ORDER BY Current_brands ASC , Total_Respondents DESC;  

-- Marketing Channels and Brand Awareness --

-- Which marketing channels can be used to reach more customers ? --
SELECT 
    Marketing_channels, COUNT(*) AS Total_Respondents
FROM
    fact_survey_responses
GROUP BY Marketing_channels
ORDER BY Total_Respondents DESC;

-- How effective are different marketing strategies and channels in reach our customers ? --
 SELECT 
    Marketing_channels,
    COUNT(*) AS Total_Respondents,
    SUM(CASE WHEN Brand_perception = 'Positive' THEN 1 ELSE 0 END) AS Positive_Perception,
    SUM(CASE WHEN Tried_before = 'Yes' THEN 1 ELSE 0 END) AS Tried_Product,
    SUM(CASE WHEN Heard_before = 'Yes' THEN 1 ELSE 0 END) AS Awareness
FROM 
    fact_survey_responses
GROUP BY 
    Marketing_channels
ORDER BY 
    Total_Respondents DESC;

-- How many respondents have tried CodeX ? --
SELECT 
    Reasons_for_choosing_brands,
    COUNT(*) AS Total_Respondents
FROM 
    fact_survey_responses
WHERE 
    Current_brands = 'CodeX'
    AND Tried_before = 'Yes'
GROUP BY 
    Reasons_for_choosing_brands
ORDER BY 
    Total_Respondents DESC;
    
-- Detailed reasons for not trying CodeX
SELECT 
    Reasons_preventing_trying,
    COUNT(*) AS Total_Respondents
FROM 
    fact_survey_responses
WHERE 
    Current_brands = 'CodeX'
    AND Tried_before = 'No'
GROUP BY 
    Reasons_preventing_trying
ORDER BY 
    Total_Respondents DESC;

-- Brand Penetration --

-- what do people think about our brand ? --
SELECT 
    Brand_perception, 
    COUNT(*) AS Total_Respondents,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM fact_survey_responses WHERE Current_brands = 'CodeX'), 2) AS Percentage
FROM 
    fact_survey_responses
WHERE 
    Current_brands = 'CodeX'
GROUP BY 
    Brand_perception
ORDER BY 
    Total_Respondents DESC;

-- Which cities do we need to focus more on ? --
SELECT 
    dc.City, dc.Tier, COUNT(*) AS Total_Respondent
FROM
    dim_cities dc
        JOIN
    dim_repondents dr ON dc.City_ID = dr.City_ID
        JOIN
    fact_survey_responses fsr ON dr.Respondent_ID = fsr.Respondent_ID
WHERE
    fsr.Consume_frequency IN ('Daily' , '2-3 times a week',
        'Once a week',
        '2-3 times a month')
GROUP BY dc.City , dc.Tier
ORDER BY Total_Respondent ASC;

-- why people chose CodeX over other brands ? --
SELECT 
    Reasons_for_choosing_brands, 
    COUNT(*) AS Total_Respondents,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM fact_survey_responses WHERE Current_brands = 'CodeX'), 2) AS Percentage
FROM 
    fact_survey_responses
WHERE 
    Current_brands = 'CodeX'
GROUP BY 
    Reasons_for_choosing_brands
ORDER BY 
    Total_Respondents DESC;

-- Purchase Behaviror --

-- WHere do respondents prefer to purchase ? --
SELECT Purchase_location , COUNT(*) AS Total_Respondents,
CONCAT(ROUND(count(*)*100.0/ (SELECT COUNT(*) FROM fact_survey_responses),1), '%') AS Percentage
FROM fact_survey_responses
GROUP BY Purchase_location
ORDER BY Total_Respondents DESC;

-- What are the typical consumption of energy drinks among respondents ? --
SELECT Typical_consumption_situations , COUNT(*) AS Total_Respondents,
CONCAT(ROUND(COUNT(*)*100.0/ (SELECT COUNT(*) FROM fact_survey_responses),1), '%') AS Percentage
FROM fact_survey_responses
GROUP BY Typical_consumption_situations
ORDER BY Total_Respondents DESC;

-- What are the typical consumption of energy drinks particularly CodeX among respondents ? --
SELECT Typical_consumption_situations , COUNT(*) AS Total_Respondents,
CONCAT(ROUND(COUNT(*)*100.0/ (SELECT COUNT(*) FROM fact_survey_responses),1), '%') AS Percentage
FROM fact_survey_responses
WHERE Current_brands = 'CodeX'
GROUP BY Typical_consumption_situations
ORDER BY Total_Respondents DESC;

-- What factors influence respondents purchase decision such as price range and limited edition packaging ?--
-- Analyzing the impact of price range on purchase likelihood with and without limited edition packaging --
SELECT 
    Price_range, 
    COUNT(*) AS Total_Respondents,
    SUM(CASE WHEN Limited_edition_packaging = 'Yes' THEN 1 ELSE 0 END) AS Respondents_With_Limited_Edition,
    SUM(CASE WHEN Limited_edition_packaging = 'No' THEN 1 ELSE 0 END) AS Respondents_Without_Limited_Edition
FROM 
    fact_survey_responses
GROUP BY 
    Price_range
ORDER BY 
    Price_range;
    
-- how preferences for limited edition packaging vary across different price ranges --
SELECT
    Price_range,
    SUM(CASE WHEN Limited_edition_packaging = 'Yes' THEN 1 ELSE 0 END) AS Respondents_With_Limited_Edition,
    SUM(CASE WHEN Limited_edition_packaging = 'No' THEN 1 ELSE 0 END) AS Respondents_Without_Limited_Edition
FROM 
    fact_survey_responses
GROUP BY 
    Price_range
ORDER BY 
    Price_range;

-- Which gender and corresponding age group prefer CodeX over other brands ? --
SELECT 
    dr.Gender, 
    COUNT(*) AS Frequent_Consumers,
    fsr.Current_brands
FROM dim_repondents dr
JOIN fact_survey_responses fsr 
    ON dr.Respondent_ID = fsr.Respondent_ID
WHERE fsr.Consume_frequency IN ('Daily', '2-3 times a week', 'Once a week') AND fsr.Current_brands = "CodeX"
GROUP BY dr.Gender,fsr.Current_brands;

-- Product Development --

-- WHich area of business ( Branding / Taste / Availability) should we focus on our product development ?--
-- Brand Perception Analysis --
SELECT 
    Brand_perception,
    COUNT(*) AS Total_Respondents
FROM 
    fact_survey_responses
WHERE 
    Current_brands = 'CodeX'
GROUP BY 
    Brand_perception
ORDER BY 
    Total_Respondents DESC;
    
-- Taste Experience Analysis --
SELECT 
    Taste_experience,
    COUNT(*) AS Total_Respondents
FROM 
    fact_survey_responses
WHERE 
    Current_brands = 'CodeX'
GROUP BY 
    Taste_experience
ORDER BY 
    Total_Respondents DESC;
    
-- what should be our focus availability or other factors ? --
SELECT 
    Reasons_for_choosing_brands,
    COUNT(*) AS Total_Respondents,
    CONCAT(ROUND(COUNT(*)*100.0 / (SELECT COUNT(*) FROM fact_survey_responses),1), '%') AS Percentage
FROM 
    fact_survey_responses
GROUP BY 
    Reasons_for_choosing_brands
ORDER BY 
    Total_Respondents DESC;







