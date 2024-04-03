-- Entire Covid Deaths Data
SELECT * FROM
covid_deaths 
ORDER BY 3,4
LIMIT 10;

/*SELECT * FROM 
covid_deaths
where date IN ('2020-01-22')
and continent is not null;*/
-- Data Exploration

-- Filtering out columns 
SELECT location,date,total_cases,new_cases,total_deaths,population
FROM covid_deaths
WHERE continent is not null
ORDER BY 1,2;

-- Death percentage off total infected for each loaction on each day
SELECT location,date, total_cases, total_deaths, ((total_deaths / total_cases) * 100) as Death_Percentage
FROM covid_deaths
WHERE location like 'India' and continent is not null
ORDER BY 1,2;

-- Percentage of population infected with covid
SELECT location,date, total_cases, Population, ((total_cases / Population) * 100) as Infection_Percentage
FROM covid_deaths
WHERE location like 'India'
ORDER BY 1,2;

-- Countries with Highest Infection Rates
SELECT location, Population,max(total_cases) as Highest_cases, (Max(total_cases / Population)) * 100 as Infection_Percentage
FROM covid_deaths
--WHERE location like 'India'
GROUP BY 1,2
ORDER BY 4 DESC;

-- Countries with Highest Death Rate
SELECT location, max(total_deaths) AS Highest_Deaths, MAX(total_deaths / population) * 100 as Highest_Death_Percentage
FROM covid_deaths
--WHERE location like 'India'
WHERE continent IS not null
GROUP BY 1
ORDER BY 2 DESC,3 DESC;

-- Exploring the data based on continent : Continents with Highest Death Count
SELECT continent, Max(total_deaths) AS Highest_Deaths
FROM covid_deaths
WHERE continent is not null
group by 1
order by 2 DESC;

-- Total cases and deaths each day accross the world
SELECT date, SUM(new_cases) as Total_cases_eachdy, SUM(new_deaths) as Total_deaths_eachday, SUM(new_deaths)/Sum(new_cases)*100 
FROM covid_deaths
WHERE continent is not null
GROUP BY 1
ORDER BY 1;

-- Vaccinations Data
SELECT *
FROM covid_vaccinations
;

-- JOINING VACCINES AND DEATHS TABLES : Comparing Population and vaccinated population each day
SELECT cd.continent, cd.location, cd.date,cd.population, cv.new_vaccinations
FROM covid_deaths CD
JOIN covid_vaccinations CV
ON CD.location = CV.location AND CD.DATE = CV.Date
WHERE CD.continent is not null and cd.location = 'India'
ORDER BY 1,2,3,5
;



-- Rolling Vaccination Count
SELECT cd.continent, cd.location, cd.date,cd.population, cv.new_vaccinations,
		sum(cv.new_vaccinations) OVER (Partition by cd.location ORDER BY cd.location,cd.date) as Rolling_Vaccinations
FROM covid_deaths CD
JOIN covid_vaccinations CV
ON CD.location = CV.location AND CD.DATE = CV.Date
WHERE CD.continent is not null --and cd.location = 'India'
ORDER BY 2,3
;


-- Ratio of People Vaccinated
WITH RatioVaccinated
AS
(
	SELECT cd.continent, cd.location, cd.date,cd.population, cv.new_vaccinations,
			sum(cv.new_vaccinations) OVER (Partition by cd.location ORDER BY cd.location,cd.date) as Rolling_Vaccinations
	FROM covid_deaths CD
	JOIN covid_vaccinations CV
	ON CD.location = CV.location AND CD.DATE = CV.Date
	WHERE CD.continent is not null --and cd.location = 'India'
	ORDER BY 2,3
)
SELECT continent, location, Max((rolling_vaccinations/population)*100) as ratio_vaccinated
FROM RatioVaccinated
GROUP BY 1,2
ORDER BY 3 DESC
;


-- Above Ration using Temp Table
DROP TABLE IF EXISTS PercentPeopleVaccinated;
CREATE TEMP TABLE PercentPeopleVaccinated
(
	CONTINENT VARCHAR(55),
	LOCATION VARCHAR(55),
	DATE DATE,
	POPULATION NUMERIC,
	NEW_VACCINATIONS NUMERIC,
	RATION_VACCINATED NUMERIC
)
;
INSERT INTO PercentPeopleVaccinated
SELECT cd.continent, cd.location, cd.date,cd.population, cv.new_vaccinations,
			sum(cv.new_vaccinations) OVER (Partition by cd.location ORDER BY cd.location,cd.date) as Rolling_Vaccinations
FROM covid_deaths CD
JOIN covid_vaccinations CV
ON CD.location = CV.location AND CD.DATE = CV.Date
WHERE CD.continent is not null --and cd.location = 'India'
ORDER BY 2,3
;

select * from percentpeoplevaccinated;



-- Views Creation to store queries data

CREATE VIEW PercentPeopleVaccinated AS
SELECT cd.continent, cd.location, cd.date,cd.population, cv.new_vaccinations,
			sum(cv.new_vaccinations) OVER (Partition by cd.location ORDER BY cd.location,cd.date) as Rolling_Vaccinations
FROM covid_deaths CD
JOIN covid_vaccinations CV
ON CD.location = CV.location AND CD.DATE = CV.Date
WHERE CD.continent is not null --and cd.location = 'India'
ORDER BY 2,3;


CREATE VIEW Global_Databases AS
SELECT continent, Max(total_deaths) as Highest_Deaths
FROM covid_deaths
WHERE continent is not null
group by 1
order by 2 DESC;

CREATE VIEW Death_Rate AS
SELECT location, max(total_deaths) AS Highest_Deaths, MAX(total_deaths / population) * 100 as Highest_Death_Percentage
FROM covid_deaths
--WHERE location like 'India'
WHERE continent IS not null
GROUP BY 1
ORDER BY 2 DESC,3 DESC;

