-- Global overall Information about Total Cases, Deaths and DeathPercentage
CREATE VIEW Global_Numbers AS
SELECT 	SUM(new_cases) AS Total_Cases, 
	  	SUM(new_deaths) AS Total_Deaths, 
		SUM(new_deaths)/SUM(new_cases) * 100 AS "Death%"
FROM covid_deaths
WHERE continent IS NOT NULL
ORDER BY 1,2
;


-- Grouping Data based on Each Continent. Europe includes numbers from Eruope Union Hence excluding it.
CREATE VIEW CONTINENT AS
SELECT	location, SUM(new_deaths) AS Total_deaths
FROM covid_deaths
WHERE continent IS NULL 
AND location NOT IN ('World','European Union','International')
GROUP BY 1
ORDER BY 2 DESC
;

-- Grouping Based on Each Country
CREATE VIEW COUNTRY_GRP AS
SELECT 	location, population, 
		MAX(total_cases) AS HighestInfected, 
		MAX(total_cases/population)*100 AS Percent_of_Population_Infected
FROM covid_deaths
GROUP BY 1,2
ORDER BY 4 DESC
;

CREATE VIEW TOTAL AS
SELECT 	location, population, date,
		MAX(total_cases) AS HighestInfected, 
		MAX(total_cases/population)*100 AS Percent_of_Population_Infected
FROM covid_deaths
GROUP BY 1,2,3
ORDER BY 5 DESC
;

-- Rolling Vacchination Counts

CREATE VIEW Rolling_Vaccination_Count AS
SELECT 	cd.continent, cd.location, cd.date,
		cd.population, cv.new_vaccinations,
		SUM(cv.new_vaccinations) OVER (Partition by cd.location ORDER BY cd.location,cd.date) AS Rolling_Vaccinations
FROM covid_deaths CD
JOIN covid_vaccinations CV
ON CD.location = CV.location AND CD.DATE = CV.Date
WHERE CD.continent IS NOT NULL
ORDER BY 2,3
;

-- 

CREATE VIEW PercentPeopleVaccinated AS
SELECT cd.continent, cd.location, cd.date,cd.population, cv.new_vaccinations,
			sum(cv.new_vaccinations) OVER (Partition by cd.location ORDER BY cd.location,cd.date) as Rolling_Vaccinations
FROM covid_deaths CD
JOIN covid_vaccinations CV
ON CD.location = CV.location AND CD.DATE = CV.Date
WHERE CD.continent is not null --and cd.location = 'India'
ORDER BY 2,3;

SELECT current_user,now()