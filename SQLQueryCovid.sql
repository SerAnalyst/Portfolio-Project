/*
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/

select *
from CovidDeaths
order by 3,4

select *
from CovidVaccinations
order by 3,4

-- Select Data that we are going to be starting with

SELECT  Location, date, total_cases, new_cases, total_deaths, population
from CovidDeaths
order by 1,2

--Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

SELECT  Location, date, total_cases, total_deaths, (total_deaths /total_cases)*100 as DeathPercentage
from CovidDeaths
where location like '%states%'
order by 1,2

-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

SELECT  Location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
from CovidDeaths
where location like '%Venezuela%'
order by 1,2

-- Countries with Highest Infection Rate compared to Population


SELECT Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
from CovidDeaths
where location like '%Venezuela%'
Group by location , population 
order by PercentPopulationInfected desc

-- Countries with Highest Death Count per Population

SELECT Location, population  ,  MAX(cast(total_deaths as int)) as HighestDeathsCount  , (MAX(cast(total_deaths as int))/population )*100 as DeathPrecentajePop 
from CovidDeaths
WHERE continent is not null
Group by location,  population
order by  HighestDeathsCount   desc


-- BREAKING THINGS DOWN BY CONTINENT
-- Showing contintents with the highest death count per population

SELECT continent,  MAX(cast(total_deaths as int)) as HighestDeathsCount   
from CovidDeaths
WHERE continent is not null
Group by continent
order by  HighestDeathsCount   desc

-- GLOBAL NUMBERS

Select   SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
from CovidDeaths
WHERE continent is not null
Group by population
order by  1,2  desc

SELECT *
FROM CovidVaccinations
where location like 'Chile'
ORDER BY 4 , 1


-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine


SELECT *
FROM CovidDeaths dea
join CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date


SELECT dea.continent , dea.location , dea.date , dea.population , vac.new_vaccinations
FROM CovidDeaths dea
join CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3



Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated

From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3



-- Using Temp Table to perform Calculation on Partition By in previous query


DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3

Select *
From #PercentPopulationVaccinated

-- Max death as PercentPopulationVaccinated

Select *, ((RollingPeopleVaccinated)/Population)*100  as PercentPopulationVaccinated
From #PercentPopulationVaccinated

SELECT location , population , Max(cast (total_deaths as int))
from CovidDeaths 
where continent is not null
group by location , population 
order by 3 desc



-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100 as PercentageVaccinated
From PopvsVac