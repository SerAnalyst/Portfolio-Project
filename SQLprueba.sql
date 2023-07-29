--CREATE PROCEDURE TEST
--AS
--SELECT *
--FROM EmployeeDemographics

--EXEC TEST

--CREATE PROCEDURE Temp_Employee
--AS
--CREATE TABLE #Temp_Employee (
--JobTitle varchar(100),
--EmployeePerJob int,
--AvgAge int,
--AveSalary int)

-- INSERT INTO #Temp_Employee
-- SELECT Jobtittle , Count (JobTittle ), Avg (age), Avg (Salary)
-- FROM EmployeeDemographics emp
-- join EmployeeSalary sal
--	ON emp.EmployeeId = sal.EmployeeID
--GROUP BY JobTittle

--SELECT *
--FROM #Temp_Employee


--EXEC Temp_Employee


ALTER PROCEDURE Temp_Employee
@JobTitle nvarchar (100)
AS
CREATE TABLE #Temp_Employee (
JobTitle varchar(100),
EmployeePerJob int,
AvgAge int,
AveSalary int)

 INSERT INTO #Temp_Employee
 SELECT Jobtittle , Count (JobTittle ), Avg (age), Avg (Salary)
 FROM EmployeeDemographics emp
 join EmployeeSalary sal
	ON emp.EmployeeId = sal.EmployeeID
WHERE JobTittle = @JobTitle
GROUP BY JobTittle

SELECT *
FROM #Temp_Employee 

EXEC Temp_Employee @JobTitle = 'Accountant'
