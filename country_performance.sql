-- Q17 = Country Performance
-- "Which countries (with at least 5 unicorns) are building strong startup ecosystems?"

WITH Cleaned_Funding AS (
    SELECT 
        Country,
        -- 1. Remove the '$'
        -- 2. Check for 'B' or 'M'
        -- 3. Convert to decimal and multiply
        CASE 
            WHEN Funding LIKE '%B' THEN 
                TRY_CAST(REPLACE(REPLACE(Funding, '$', ''), 'B', '') AS DECIMAL(18,2)) * 1000000000
            WHEN Funding LIKE '%M' THEN 
                TRY_CAST(REPLACE(REPLACE(Funding, '$', ''), 'M', '') AS DECIMAL(18,2)) * 1000000
            ELSE 
                TRY_CAST(REPLACE(Funding, '$', '') AS DECIMAL(18,2))
        END AS Funding_Numeric
    FROM Unicorn_Companies
)
SELECT
    Country,
    COUNT(*) AS Total_Companies,
    SUM(Funding_Numeric) AS Total_Funding,
    AVG(Funding_Numeric) AS Avg_Funding_Per_Company
FROM Cleaned_Funding
WHERE Funding_Numeric IS NOT NULL  -- Excludes 'Unknown' or unparseable rows
GROUP BY Country
HAVING COUNT(*) >= 5
ORDER BY Total_Funding DESC;