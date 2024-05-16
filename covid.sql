SELECT * FROM covidvaccinations;

SELECT * FROM `covid death`;

SELECT location, `date`, total_cases, new_cases, total_deaths, population
FROM `covid death`
ORDER BY 1,2;

-- Looking At Total Cases Vs Total Deaths 
-- Shows Likelyhood Of Dying If Contact With Covid
SELECT  location,`date`, total_cases, total_deaths, ROUND(total_deaths/total_cases * 100, 2)
FROM `covid death`
WHERE location LIKE '%states%'
ORDER BY 1,2;

-- Looking At Total Cases Vs Population 
-- Shows What Percentage Of Populatuon Got Covid
SELECT  location,`date`, population, total_cases, total_deaths, ROUND(total_cases/population * 100, 2) PercentInfected
FROM `covid death`
WHERE location LIKE '%states%'
ORDER BY 1,2;

-- Looking At Countries With Highest Infection Rate Compared To Population

SELECT  location, population, MAX(total_cases) HighestInfenction, MAX(total_cases/population * 100) PercentInfected
FROM `covid death`
-- WHERE location LIKE '%states%'
GROUP BY location, population
ORDER BY PercentInfected DESC ;

-- Showing Countries With Highest Death Count Per Population

SELECT  location, MAX(total_deaths) TotalDeathCount
FROM `covid death`
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC
;

-- Break Things Down By Continent
-- Showing Contintents With The Highest Death Count Per Population 
SELECT  Continent, MAX(total_deaths) TotalDeathCount
FROM `covid death`
WHERE continent IS NOT NULL
GROUP BY Continent
ORDER BY TotalDeathCount DESC
;

-- Global Numbers

SELECT SUM(new_cases) total_cases, SUM(new_deaths) total_death, SUM(new_deaths)/SUM(New_cases) * 100 DeathPercentage
FROM `covid death`
-- WHERE continent IS NOT NULL
WHERE continent IS NOT NULL
-- GROUP BY `date`
ORDER BY 1,2
; 


-- Looking At total population vs vaccinations

SELECT cd.Continent, cd.location, cd.`date`, cd.population, cv.new_vaccinations,
SUM(cv.new_vaccinations) OVER(PARTITION BY  cd.location ORDER BY cd.`date` ) RollingPeopleVacinnated
FROM `covid death` cd
JOIN covidvaccinations cv
ON cd.location = cv.location
AND cd.`date` = cv.`date`
WHERE cd.Continent != '' AND cv.new_vaccinations != ''
ORDER BY 1,2,3;

-- CTE 

WITH PopvsVac AS(
SELECT cd.Continent, cd.location, cd.`date`, cd.population, cv.new_vaccinations,
SUM(cv.new_vaccinations) OVER(PARTITION BY  cd.location ORDER BY cd.`date` ) RollingPeopleVacinnated
FROM `covid death` cd
JOIN covidvaccinations cv
ON cd.location = cv.location
AND cd.`date` = cv.`date`
WHERE cd.Continent != '' AND cv.new_vaccinations != ''
ORDER BY 1,2,3
)
SELECT *, ROUND (RollingPeopleVacinnated/ population * 100, 2)  
FROM PopvsVac;



-- Create View For Later Visualization

CREATE VIEW PercentPopulationVaccinated AS 
SELECT cd.Continent, cd.location, cd.`date`, cd.population, cv.new_vaccinations,
SUM(cv.new_vaccinations) OVER(PARTITION BY  cd.location ORDER BY cd.`date` ) RollingPeopleVacinnated
FROM `covid death` cd
JOIN covidvaccinations cv
ON cd.location = cv.location
AND cd.`date` = cv.`date`
WHERE cd.Continent != '' AND cv.new_vaccinations != ''
ORDER BY 1,2,3;

