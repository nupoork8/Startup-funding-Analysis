-- country/continet where funding was less than $110m
SELECT Country, Continent, Funding
FROM Unicorn_Companies
WHERE 
    (Funding LIKE '%M' AND CAST(REPLACE(REPLACE(Funding, '$', ''), 'M', '') AS DECIMAL) < 110)
    OR 
    (Funding = 'Unknown'); --  helps find missing data