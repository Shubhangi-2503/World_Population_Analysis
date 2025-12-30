-- Complete each query under its relevant comment: 


/*
I have reviewed the data and it looks fine. However, I noticed that the population column in the population_years table is of type INTEGER,
while we are inserting decimal values. I wasn�t sure if I could modify the data during the insertion process.
After inserting the data, no additional cleaning or adjustments were necessary.
If I was allow to do that I would update the data in million for population column.  

By changing the value of @continent,@year in DECLARE you can run the same query for any continent or year to get your answer.
*/


-------------------------------------------------------------------------------------------------------------------------------------------
-- 1. How many entries in the database are from Africa?


-- Declare the continent to analyze
DECLARE @continent VARCHAR(100) = 'Africa'

-- Retrieve total population entries and total countries for the specified continent
SELECT COUNT(*) AS total_population_entries, 
(SELECT COUNT(*) AS total_countries_entries
FROM countries c
WHERE c.continent = @continent) AS total_countries
FROM countries c
    INNER JOIN population_years p
    ON c.id= p.country_id
WHERE c.continent = @continent
GO 

/*
Total population entries for Africa: 616
Total countries in Africa: 56
All African countries have corresponding population data in population_years.
Therefore, using an INNER JOIN between countries and population_years is sufficient to calculate totals.
*/

-----------------------------------------------------------------------------------------------------------------------
-- 2. What was the total population of Africa in 2010?

-- Declare the continent and year to analyze
DECLARE @continent VARCHAR(100) = 'Africa',
        @year INT = 2010

-- Calculate the total population of the continent for the specified year
SELECT SUM(population) AS total_population 
FROM countries c
    INNER JOIN population_years p
    ON c.id= p.country_id
WHERE c.continent = @continent
AND p.year = @year
GO 

/*
Total population of Africa in 2010: 991 
Used an INNER JOIN to combine countries with population_years.
Filtered by continent = 'Africa' and year = 2010.
Summed the population column to get the total population of the continent for that year.
*/ 


---------------------------------------------------------------------------------------------------------------------------------
-- 3. What is the average population of countries in South America in 2000?

-- Declare the continent and year to analyze
DECLARE @continent VARCHAR(100) = 'South America',
@year INT = 2000


-- Calculate the average population of the continent for the specified year
SELECT AVG(population) AS average_population 
FROM countries c
    INNER JOIN population_years p
    ON c.id= p.country_id
WHERE c.continent =@continent
AND p.year = @year
AND p.population IS NOT NULL;
GO 


/*
Average population of South America in 2000 : 24 
Used an INNER JOIN to combine countries with population_years.
Excluded NULL population values to ensure accurate averaging
Filtered by continent = 'South America' and year = 2000.
Averaged the population column to get the Average population of the continent for that year.
*/

-----------------------------------------------------------------------------------------------------------------------------------------
-- 4. What country had the smallest population in 2007?

--Declare the year to analyze
DECLARE @year INT = 2007 

-- Find the minimum population for the specified year
DECLARE @minpopulation INT = (SELECT MIN(population)
      FROM dbo.population_years
      WHERE year = @year)

-- Get the list of countries with the minimum population
SELECT c.name AS country_name
FROM countries c
    INNER JOIN population_years p
    ON c.id= p.country_id
WHERE  p.year = @year
AND  population = @minpopulation

/*
total number countries with minimum population are 58. 
Calculated the minimum population for that year.
Joined 'countries' with 'population_years' to find countries matching the minimum population.
Added the list in word document
*/

-----------------------------------------------------------------------------------------------------------------------------------------------
-- 5. How much has the population of Europe grown from 2000 to 2010?

--Declare the both years and continent to analyze
DECLARE @continent VARCHAR(100) = 'Europe',
@year1 INT = 2000,
@year2 INT = 2010


-- Calculate population in 2000, 2010, and the growth
SELECT 
SUM(CASE WHEN year = @year1 THEN p.population ELSE 0 END) AS population_2000,
SUM(CASE WHEN year = @year2 THEN p.population ELSE 0 END) AS population_2010,
SUM(CASE WHEN year = @year2 THEN p.population ELSE 0 END) - SUM(CASE WHEN year = @year1 THEN p.population ELSE 0 END) population_growth
FROM countries c
    INNER JOIN population_years p
    ON c.id= p.country_id
WHERE c.continent ='Europe'
AND p.year IN (@year1,@year2)

/*
The population has decreased to 8 
Declared the continent ('Europe') and the years (2000 and 2010) to analyze.
Used CASE statements to sum the population for each year.
Calculated population growth by subtracting 2000 population from 2010 population.
*/



