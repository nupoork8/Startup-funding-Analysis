-- Q15
-- Unicorns per year

SELECT 
    YEAR([Date_Joined]) AS Year, 
    COUNT(*) AS New_Unicorns
FROM Unicorn_Companies
GROUP BY YEAR([Date_Joined])
ORDER BY Year;

