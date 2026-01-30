-- Q18 = Industry by continent
-- What industries dominate in each continent ? do regions specialize ?

SELECT 
	Continent,
	Industry,
	COUNT(*) AS Companies

FROM Unicorn_Companies
GROUP BY Continent,Industry
ORDER BY Continent, Companies DESC;