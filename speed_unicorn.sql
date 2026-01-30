-- Q16 = Speed to unicorn

-- How long does it take companies to reach $1B valuation? Has this changed over time?


SELECT 
    YEAR([Date_Joined]) AS Year_Unicorn_Reached,
    AVG(YEAR([Date_Joined]) - Year_Founded) AS Avg_Years_To_Unicorn,
    MIN(YEAR([Date_Joined]) - Year_Founded) AS Min_Years_To_Unicorn,
    MAX(YEAR([Date_Joined]) - Year_Founded) AS Max_Years_To_Unicorn,
    -- Using a CASE statement with the full calculation
    CASE 
        WHEN AVG(YEAR([Date_Joined]) - Year_Founded) <= 3 THEN 'Rocket Ship (0-3 years)'
        WHEN AVG(YEAR([Date_Joined]) - Year_Founded) <= 7 THEN 'Fast Growth (4-7 years)'
        ELSE 'Steady Growth (8+ years)'
    END AS Average_Speed_Category
FROM Unicorn_Companies
GROUP BY YEAR([Date_Joined])
ORDER BY Year_Unicorn_Reached;

