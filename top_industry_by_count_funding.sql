-- Q11 - INTERMEDIATE
-- TOP Industries by count and Funding

SELECT 
	Industry,
	COUNT(*)AS Company,
	SUM(CASE 
	WHEN Funding LIKE '%B' THEN CAST(REPLACE(REPLACE(Funding, '$' , ''),'B','') AS DECIMAL) * 1000
	WHEN Funding LIKE '%M' THEN CAST(REPLACE(REPLACE(Funding, '$', ''), 'M', '') AS DECIMAL)
	ELSE 0
	END) AS Total_Funding_Millions
FROM Unicorn_Companies
GROUP BY Industry
ORDER BY Total_Funding_Millions DESC;



