-- Covid19 Data Exploration
-- Skills USed: Joins, CTE, Temp Table, Window Functions, Aggregate Functions, Creating Views, Converting Data Types



SELECT *
FROM CovidPortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
order by 3, 4


SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM CovidPortfolioProject..CovidDeaths
WHERE continent is not null
order by 1, 2

-- Looking at Total Cases vs Total Deaths
-- This shows the chance of a person dying from contracting Covid from their country

SELECT Location, date, total_cases, total_deaths, (convert(float,total_deaths)/convert(float, total_cases))*100 as DeathPercentage
FROM CovidPortfolioProject..CovidDeaths
-- WHERE location like '%States'
WHERE continent is not null
order by 1, 2


-- Looking at Total Cases vs Population
-- This shows what percentage of the population has been infected with Covid

SELECT Location, date, population, total_cases, (convert(float,total_cases)/convert(float, population))*100 as InfectionPercentage
FROM CovidPortfolioProject..CovidDeaths
-- WHERE location like '%States'
WHERE continent is not null
order by 1, 2


-- Looking at Countries with the Highest Infection Rate per Population

SELECT Location, population, MAX(total_cases) as HighestInfectionCount, MAX((convert(float,total_cases)/convert(float, population)))*100 as InfectionPercentage
FROM CovidPortfolioProject..CovidDeaths
-- WHERE location like '%States'
GROUP BY Location, population
order by 4 desc

-- Looking at the Countries with the Highest Death Count per Population

SELECT Location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM CovidPortfolioProject..CovidDeaths
-- WHERE location like '%States'
WHERE continent is not null
GROUP BY Location
order by 2 desc


-- Looking at Numbers by Continent
-- Here we will start analyzing the data based off of Continents

-- Looking at the Continents with the Highest Death Count per Population

SELECT location, MAX(CAST(total_deaths as int)) as TotalDeathCount
FROM CovidPortfolioProject..CovidDeaths
-- WHERE location like '%States'
WHERE continent is null
	and location not like '%income%'
GROUP BY location
order by 2 desc


-- Global Numbers


SELECT date, SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS INT)) as total_deaths, CASE WHEN (SUM(new_cases) = 0) THEN 0 ELSE SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 END  AS DeathPercentage
FROM CovidPortfolioProject..CovidDeaths
WHERE continent is not null
GROUP BY date
order by 1, 2;


SELECT SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS INT)) as total_deaths, CASE WHEN (SUM(new_cases) = 0) THEN 0 ELSE SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 END  AS DeathPercentage
FROM CovidPortfolioProject..CovidDeaths
WHERE continent is not null
-- GROUP BY date
order by 1, 2;



-- Looking at Total Population vs Vaccinations
-- This shows the percentage of each population that has receiveda t least one Covid vaccine

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingVaccinatedCounts
-- (RollingVaccinatedCounts/population)*100
FROM CovidPortfolioProject..CovidDeaths dea
JOIN CovidPortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
order by 2, 3



-- Using CTE to perform calculations on Partition By in the above query

WITH PopVsVac (Continent, Location, Date, Population, new_vaccinations, RollingVaccinatedCounts)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingVaccinatedCounts
-- (RollingVaccinatedCounts/population)*100
FROM CovidPortfolioProject..CovidDeaths dea
JOIN CovidPortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
-- order by 2, 3
)
SELECT *, (RollingVaccinatedCounts/Population)*100
FROM PopVsVac;





-- Using a Temp Table to perform calculation on Partition By in the above query

Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255), 
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingVaccinatedCounts numeric
)

Insert into #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingVaccinatedCounts
-- (RollingVaccinatedCounts/population)*100
FROM CovidPortfolioProject..CovidDeaths dea
JOIN CovidPortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
-- order by 2, 3

SELECT *, (RollingVaccinatedCounts/Population)*100
FROM #PercentPopulationVaccinated




Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255), 
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingVaccinatedCounts numeric
)

Insert into #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingVaccinatedCounts
-- (RollingVaccinatedCounts/population)*100
FROM CovidPortfolioProject..CovidDeaths dea
JOIN CovidPortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
-- WHERE dea.continent IS NOT NULL
-- order by 2, 3

SELECT *, (RollingVaccinatedCounts/Population)*100
FROM #PercentPopulationVaccinated



-- Creating Views to store data for later visualizations

Create View PercentPopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingVaccinatedCounts
-- (RollingVaccinatedCounts/population)*100
FROM CovidPortfolioProject..CovidDeaths dea
JOIN CovidPortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
-- order by 2, 3


Create View HighestInfectionRate as
SELECT Location, population, MAX(total_cases) as HighestInfectionCount, MAX((convert(float,total_cases)/convert(float, population)))*100 as InfectionPercentage
FROM CovidPortfolioProject..CovidDeaths
-- WHERE location like '%States'
GROUP BY Location, population
-- order by 4 desc


Create View TotalVaccinationsPerPopulation as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingVaccinatedCounts
-- (RollingVaccinatedCounts/population)*100
FROM CovidPortfolioProject..CovidDeaths dea
JOIN CovidPortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
-- order by 2, 3