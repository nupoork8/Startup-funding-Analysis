-- Q12
-- TOP 10 CITIES

SELECT TOP 10
	City,
	Country,
COUNT(*) AS Companies
FROM Unicorn_Companies
GROUP BY City, Country
ORDER BY Companies DESC;