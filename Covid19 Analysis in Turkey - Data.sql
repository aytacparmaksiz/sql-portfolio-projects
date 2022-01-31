
-- Total cases against total deaths in Turkey
-- Shows the probability of dying if you get covid in Turkey

	SELECT locations, dates, total_cases, total_deaths, 
		   ROUND(((total_deaths/total_cases) * 100),2) AS Death_Percentage
	FROM coviddeaths
	WHERE locations = 'Turkey'
	Order By 2;

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
	Order By 2;

-- This query shows what is the average percentage of the total population got covid19.

	SELECT ROUND(AVG((total_cases/population) * 100),2) AS Avg_Percentage_of_Population
	FROM coviddeaths
	WHERE locations = 'Turkey';
	
-- The result is 4.14%

-- Looking at countries with highest infection rate and Turkey's position in this analysis.

	SELECT locations, population, MAX(total_cases) AS Highest_Infection_Count, 
			MAX((total_cases/population) * 100) AS Percentage_Infected_Population
	FROM coviddeaths
	GROUP BY 1,2
	ORDER BY Percentage_Infected_Population DESC NULLS LAST;

-- Wee see that Andorra has the highest percentage of infected population with 45.97% and Turkey is in 61th position with 13.45% of infected population so far.


-- Showing countries with the highest death count per population as well as Turkey's.

	SELECT locations, MAX(total_deaths) AS Highest_Death_Count
	FROM coviddeaths
	WHERE continent IS NOT NULL
	GROUP BY 1
	ORDER BY Highest_Death_Count DESC NULLS LAST;

-- United States has the highest total death with 883939 and Turkey is in 19th position with total 87045 deaths.

-- Showing Turkey's new death rate against the new cases per day. The days of new deaths are shown.

	SELECT dates, SUM(new_cases) AS Total_New_Case, SUM(new_deaths) AS Total_New_Death,
		ROUND((SUM(new_deaths) / SUM(new_cases) * 100),2) AS New_Death_Percentage
	FROM coviddeaths
	WHERE locations = 'Turkey'
	GROUP BY dates
	HAVING SUM(new_deaths) IS NOT NULL AND SUM(new_deaths) != 0
	ORDER BY 1;

-- Showing world's death percentage in order to comparison of Turkey's rate.

	SELECT SUM(new_cases) AS Total_New_Case, SUM(new_deaths) AS Total_New_Death,
		ROUND((SUM(new_deaths) / SUM(new_cases) * 100),2) AS New_Death_Percentage
	FROM coviddeaths
	WHERE continent IS NOT NULL;

-- The total new death percentage is 1.51% of the world.

	SELECT SUM(new_cases) AS Total_New_Case, SUM(new_deaths) AS Total_New_Death,
		ROUND((SUM(new_deaths) / SUM(new_cases) * 100),2) AS New_Death_Percentage
	FROM coviddeaths
	WHERE locations = 'Turkey';

-- While Turkey's is 0.82%.

--Query showing the increase of new vaccines over time and their rate by population.

	SELECT cd.locations, cd.dates, cd.population, cv.new_vaccinations, 
		SUM(cv.new_vaccinations) OVER (Partition by cd.locations Order By cd.locations, cd.dates) AS New_Vaccinations_Over_Time,
		ROUND((cv.new_vaccinations / cd.population) * 100,2) AS Vaccinate_Percentage,
		SUM(ROUND(((cv.new_vaccinations / cd.population) * 100),2)) OVER (Partition by cd.locations Order By cd.locations, cd.dates)  AS Vaccinate_Perc_Over_Time
	FROM coviddeaths AS cd
	JOIN covidvaccinations AS cv
		ON cd.locations = cv.locations 
		AND cd.dates = cv.dates
	WHERE cd.locations = 'Turkey'
	ORDER BY 2;

-- New_Vaccinations_Over_Time and Vaccinate_Perc_Over_Time calculation with using CTE.

WITH VaccinatedPopulation (locations, dates, population, new_vaccinations, New_Vaccinations_Over_Time)
	AS
	(SELECT cd.locations, cd.dates, cd.population, cv.new_vaccinations, 
	SUM(cv.new_vaccinations) OVER (Partition by cd.locations Order By cd.locations, cd.dates) AS New_Vaccinations_Over_Time 
	FROM coviddeaths AS cd
	JOIN covidvaccinations AS cv
		ON cd.locations = cv.locations 
		AND cd.dates = cv.dates
	WHERE cd.locations = 'Turkey')

	SELECT *, ROUND((New_Vaccinations_Over_Time / Population), 2) AS Vaccinate_Perc_Over_Time
	FROM VaccinatedPopulation;

--
