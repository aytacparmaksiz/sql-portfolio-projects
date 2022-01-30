/*
Covid 19 Data Exploration 

The data taken from https://ourworldindata.org/covid-deaths.

After the data set was received, data cleaning was performed to import it into the database. 

The analysis starts since the day the Covid cases started to be registered on https://ourworldindata.org/covid-deaths.

The data was converted to appropriate data types, cleaned and imported into PostgreSQL for analysis in the appropriate format.

*/


-- Total cases against total deaths in Turkey
-- Shows the probability of dying if you get covid in Turkey

	SELECT locations, dates, total_cases, total_deaths, 
	       ROUND(((total_deaths/total_cases) * 100),2) AS Death_Percentage
	FROM coviddeaths
	WHERE locations = 'Turkey'
	Order By 2

-- The average of the death percentage in Turkey.

SELECT ROUND(AVG((total_deaths/total_cases) * 100),2) AS Avg_Death_Percentage   
FROM coviddeaths
WHERE locations = 'Turkey';

-- The result is 1.53%.

-- Query about total cases against the population of Turkey. It shows what percentage of population got Covid19 per day.

	SELECT locations, dates, population, total_cases,
	       ROUND(((total_cases/population) * 100),2) AS Percentage_of_Population
	FROM coviddeaths
	WHERE locations = 'Turkey'
	Order By 2

-- This query shows what is the average percentage of the total population got covid19 in Turkey.

	SELECT ROUND(AVG((total_cases/population) * 100),2) AS Avg_Percentage_of_Population
	FROM coviddeaths
	WHERE locations = 'Turkey'
	
-- The result is 4.14%

-- Looking at countries with highest infection rate and Turkey's position in this analysis.

SELECT locations, population, MAX(total_cases) AS Highest_Infection_Count, 
	MAX((total_cases/population) * 100) AS Percentage_Infected_Population
FROM coviddeaths
GROUP BY 1,2
ORDER BY Percentage_Infected_Population DESC NULLS LAST;

-- Wee see that Andorra has the highest percentage of infected population with 45.97% and Turkey is in 61th position with 13.45% of infected population so far.


-- Showing countries with the highest death count per population. 

SELECT locations, MAX(total_deaths) AS Highest_Death_Count
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY 1
ORDER BY Highest_Death_Count DESC NULLS LAST;

-- United States has the highest total death witn 883939 and Turkey is in 19th position with total 87045 deaths.

