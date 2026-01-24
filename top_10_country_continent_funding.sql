-- top 10  funded countries in asia ,europe etc

SELECT TOP 10 Country,Funding
FROM Unicorn_Companies
WHERE Continent IN(
'Asia'
);

SELECT TOP 10 Country,Funding
FROM Unicorn_Companies
WHERE Continent IN(
'Europe'
);

SELECT TOP 10 Country,Funding
FROM Unicorn_Companies
WHERE Continent IN(
'North America'
);

SELECT TOP 10 Country,Funding
FROM Unicorn_Companies
WHERE Continent IN(
'South America'
);