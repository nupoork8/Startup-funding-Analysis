-- largest funded industry

SELECT 
    Industry, 
    SUM(CASE 
        WHEN Funding LIKE '%B' THEN CAST(REPLACE(REPLACE(Funding, '$', ''), 'B', '') AS DECIMAL(10,2))
        WHEN Funding LIKE '%M' THEN CAST(REPLACE(REPLACE(Funding, '$', ''), 'M', '') AS DECIMAL(10,2)) / 1000
        ELSE 0 
    END) AS Total_Funding_In_Billions
FROM Unicorn_Companies
GROUP BY Industry
ORDER BY Total_Funding_In_Billions DESC;