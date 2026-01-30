-- Q19 = Valuation Tiers
-- How many companies are at each valustion level ? whats the pyramid structure

WITH Valuation_Tiers AS (
    SELECT 
        Company,
        CASE 
            WHEN TRY_CAST(REPLACE(REPLACE(Valuation, '$', ''), 'B', '') AS DECIMAL(18,2)) >= 100 THEN 'Hectocorn ($100B+)'
            WHEN TRY_CAST(REPLACE(REPLACE(Valuation, '$', ''), 'B', '') AS DECIMAL(18,2)) >= 10 THEN 'Decacorn ($10B - $99B)'
            ELSE 'Unicorn ($1B - $9B)'
        END AS Tier,
        -- Creating a numeric rank for the pyramid structure
        CASE 
            WHEN TRY_CAST(REPLACE(REPLACE(Valuation, '$', ''), 'B', '') AS DECIMAL(18,2)) >= 100 THEN 1
            WHEN TRY_CAST(REPLACE(REPLACE(Valuation, '$', ''), 'B', '') AS DECIMAL(18,2)) >= 10 THEN 2
            ELSE 3
        END AS Tier_Rank
    FROM Unicorn_Companies
)
SELECT 
    Tier, 
    COUNT(*) AS Company_Count,
    -- Simple bar visual using REPLICATE
    REPLICATE('■', COUNT(*) / 5) AS Visual_Pyramid
FROM Valuation_Tiers
GROUP BY Tier, Tier_Rank
ORDER BY Tier_Rank ASC;