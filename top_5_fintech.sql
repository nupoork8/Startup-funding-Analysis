-- top 5 fintech industry funded startup

SELECT TOP 5 Company, Funding
FROM Unicorn_Companies
WHERE Industry = 'Fintech'
ORDER BY Funding DESC;