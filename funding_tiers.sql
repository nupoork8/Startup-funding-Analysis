-- Q14
-- Funding tiers
SELECT 
    CASE 
        WHEN Funding LIKE '%M' AND CAST(REPLACE(REPLACE(Funding, '$', ''), 'M', '') AS DECIMAL) < 100 THEN 'Under $100M'
        WHEN Funding LIKE '%M' THEN '$100M-$1B'
        ELSE 'Over $1B'
    END AS Funding_Tier,
    COUNT(*) AS Companies
FROM Unicorn_Companies
GROUP BY CASE 
    WHEN Funding LIKE '%M' AND CAST(REPLACE(REPLACE(Funding, '$', ''), 'M', '') AS DECIMAL) < 100 THEN 'Under $100M'
    WHEN Funding LIKE '%M' THEN '$100M-$1B'
    ELSE 'Over $1B'
END;