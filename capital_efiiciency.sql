-- Q20 = Capital Efficiency Analysis
-- Which comapanies achieved high valuation with minimal funding ? who's capital efficient ?

WITH Cleaned_Data AS (
    SELECT 
        Company,
        Industry,
        -- Convert Valuation string to Billion numeric
        TRY_CAST(REPLACE(REPLACE(Valuation, '$', ''), 'B', '') AS DECIMAL(18,2)) AS Val_B,
        -- Convert Funding string to Billion numeric
        CASE 
            WHEN Funding LIKE '%B' THEN TRY_CAST(REPLACE(REPLACE(Funding, '$', ''), 'B', '') AS DECIMAL(18,2))
            WHEN Funding LIKE '%M' THEN TRY_CAST(REPLACE(REPLACE(Funding, '$', ''), 'M', '') AS DECIMAL(18,2)) / 1000
            ELSE NULL 
        END AS Fund_B
    FROM Unicorn_Companies
),
Efficiency_Base AS (
    SELECT 
        *,
        ROUND(Val_B / NULLIF(Fund_B, 0), 2) AS Efficiency_Ratio
    FROM Cleaned_Data
)
-- Selecting Highly Efficient Companies
SELECT * FROM Efficiency_Base
WHERE Efficiency_Ratio > 5
ORDER BY Efficiency_Ratio DESC;