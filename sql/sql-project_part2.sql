create database GroupProject2;
use GroupProject2;

/* Create tables */
CREATE TABLE APARTMENT
(
  ApartmentKey INT AUTO_INCREMENT NOT NULL,
  AptNo VARCHAR(3) NOT NULL,
  BuildingID CHAR(3) NOT NULL,
  Bedrooms INT NOT NULL,
  PRIMARY KEY (ApartmentKey)
);

CREATE TABLE MSTAFF
(
  MStaffKey INT AUTO_INCREMENT NOT NULL,
  MStaffID CHAR(4) NOT NULL,
  Certification VARCHAR(50) NOT NULL,
  MSName VARCHAR(50) NOT NULL,
  PRIMARY KEY (MStaffKey)
);

CREATE TABLE CALENDAR
(
  CalendarKey INT AUTO_INCREMENT NOT NULL,
  FullDate DATE NOT NULL,
  DayofWeek VARCHAR(10) NOT NULL,
  DayofMonth INT NOT NULL,
  Month INT NOT NULL,
  Quarter INT NOT NULL,
  Year INT NOT NULL,
  PRIMARY KEY (CalendarKey)
);

CREATE TABLE CLIENTS
(
  CCName VARCHAR(100) NOT NULL,
  ClientKey INT AUTO_INCREMENT NOT NULL,
  CCID CHAR(4) NOT NULL,
  CCIndustry VARCHAR(50) NOT NULL,
  PRIMARY KEY (ClientKey)
);

CREATE TABLE MANAGER
(
  ManagerKey INT AUTO_INCREMENT NOT NULL,
  ManagerID CHAR(5) NOT NULL,
  ManagerName VARCHAR(50) NOT NULL,
  Salary NUMERIC(9, 2) NOT NULL,
  PRIMARY KEY (ManagerKey)
);

CREATE TABLE PAYROLL
(
  EmployeeID CHAR(5) NOT NULL,
  MonthlySalary INT NOT NULL,
  PayrollKey INT AUTO_INCREMENT NOT NULL,
  CalendarKey INT NOT NULL,
  ManagerKey INT NOT NULL,
  PRIMARY KEY (PayrollKey),
  FOREIGN KEY (CalendarKey) REFERENCES CALENDAR(CalendarKey),
  FOREIGN KEY (ManagerKey) REFERENCES MANAGER(ManagerKey)
);

CREATE TABLE REVENUE
(
  RevenueKey INT AUTO_INCREMENT NOT NULL,
  LeaseID CHAR(10) NOT NULL,
  StartDate DATE NOT NULL,
  EndDate DATE NOT NULL,
  MonthlyRent INT NOT NULL,
  SecurityDeposit INT NOT NULL,
  TotalRevenue INT NOT NULL,
  ClientKey INT NOT NULL,
  CalendarKey INT NOT NULL,
  ApartmentKey INT NOT NULL,
  PRIMARY KEY (RevenueKey),
  FOREIGN KEY (ClientKey) REFERENCES CLIENTS(ClientKey),
  FOREIGN KEY (CalendarKey) REFERENCES CALENDAR(CalendarKey),
  FOREIGN KEY (ApartmentKey) REFERENCES APARTMENT(ApartmentKey)
);

CREATE TABLE MAINTENANCE
(
  MaintenanceKey INT AUTO_INCREMENT NOT NULL,
  RequestID CHAR(6) NOT NULL,
  ReqType VARCHAR(10) NOT NULL,
  IssueDescription VARCHAR(200) NOT NULL,
  DateSubmitted DATE NOT NULL,
  DateResolved DATE NULL,
  CalendarKey INT NOT NULL,
  ApartmentKey INT NOT NULL,
  MStaffKey INT NOT NULL,
  PRIMARY KEY (MaintenanceKey),
  FOREIGN KEY (CalendarKey) REFERENCES CALENDAR(CalendarKey),
  FOREIGN KEY (ApartmentKey) REFERENCES APARTMENT(ApartmentKey),
  FOREIGN KEY (MStaffKey) REFERENCES MSTAFF(MStaffKey)
);

/* ETL Process */

/* insert data into APARTMENT dimension table */
insert into GroupProject2.APARTMENT (AptNo, BuildingID, Bedrooms)
select
	AptNo,
    BuildingID, 
    AptNoofBedrooms
from GroupProject.APARTMENT;

/* insert data into MANAGER dimension table */
insert into GroupProject2.MANAGER (ManagerID, ManagerName, Salary)
select
	ManagerID,
    concat(FirstName, ' ', LastName),
    Salary
from GroupProject.MANAGER;

/* insert data into CLIENTS dimension table */
insert into GroupProject2.CLIENTS (CCID, CCIndustry, CCName)
select
	CCID,
    CCIndustry,
    CCName
from GroupProject.CORPCLIENT;

/* insert data into MSTAFF dimension table */
insert into GroupProject2.MSTAFF (MStaffID, Certification, MSName)
select
	ms.MStaffID,
    c.Certifications,
    concat(ms.MSFirstName, ' ', ms.MSLastName) as MSName
from GroupProject.MAINTENANCESTAFF ms
join GroupProject.MAINTENANCESTAFF_Certifications c
	on ms.MStaffID = c.MStaffID;

/* Insert data into fact tables */

/* Insert data into Calendar table first */ 
/* need to reset recursion depth to be able to insert calendar dates recusively */
SET SESSION cte_max_recursion_depth = 1500;

INSERT INTO CALENDAR (FullDate, DayofWeek, DayofMonth, Month, Quarter, Year)
SELECT 
  d,
  DAYNAME(d),
  DAY(d),
  MONTH(d),
  QUARTER(d),
  YEAR(d)
FROM (
  WITH RECURSIVE dates (d) AS (
    SELECT DATE('2022-01-01')
    UNION ALL
    SELECT d + INTERVAL 1 DAY FROM dates WHERE d + INTERVAL 1 DAY <= '2026-01-31'
  )
  SELECT d FROM dates
) AS derived_dates;

/* maintenance fact table */
/* create staging table for maintenance */
CREATE TABLE StagingMaintenance (
  RequestID VARCHAR(10),
  ReqType VARCHAR(9),
  IssueDescription VARCHAR(200),
  AptNo VARCHAR(3),
  BuildingID CHAR(3),
  MStaffID CHAR(4),
  DateSubmitted DATE,
  DateResolved DATE
);

/* Insert from GroupProject.MAINTENANCEREQUEST into StagingMaintenance */ 
INSERT INTO StagingMaintenance (
  RequestID,
  ReqType,
  IssueDescription,
  DateSubmitted,
  DateResolved,
  AptNo,
  BuildingID,
  MStaffID
)
SELECT
  RequestID,
  ReqType,
  IssueDescription,
  DateSubmitted,
  DateResolved,
  AptNo,
  BuildingID,
  MStaffID
FROM GroupProject.MAINTENANCEREQUEST;

/* insert into MAINTENCE from staging table */
INSERT INTO MAINTENANCE (
    RequestID,
    ReqType,
    IssueDescription,
    DateSubmitted,
    DateResolved,
    CalendarKey,
    ApartmentKey,
    MStaffKey
)
SELECT
    s.RequestID,
    MAX(s.ReqType),
    MAX(s.IssueDescription),
    MAX(s.DateSubmitted),
    MAX(s.DateResolved),
    MAX(c1.CalendarKey),
    MAX(a.ApartmentKey),
    MAX(m.MStaffKey)
FROM StagingMaintenance s
JOIN CALENDAR c1 ON s.DateSubmitted = c1.FullDate
JOIN CALENDAR c2 ON s.DateResolved = c2.FullDate
JOIN APARTMENT a ON s.AptNo = a.AptNo AND s.BuildingID = a.BuildingID
JOIN MSTAFF m ON s.MStaffID = m.MStaffID
GROUP BY s.RequestID;

/* create staging table for payroll */
CREATE TEMPORARY TABLE StagingPayroll (
  PayDate DATE,
  ManagerID CHAR(5)
);

/* create PayDates recursively */
WITH RECURSIVE months (PayDate) AS (
  SELECT DATE('2022-01-01')
  UNION ALL
  SELECT DATE_ADD(PayDate, INTERVAL 1 MONTH)
  FROM months
  WHERE PayDate < '2026-12-31'
)
SELECT 
  m.PayDate,
  d.ManagerID
FROM months m
JOIN MANAGER d;

/* insert data into staging payroll table */
INSERT INTO StagingPayroll (PayDate, ManagerID)
SELECT 
  m.PayDate,
  d.ManagerID
FROM (
  WITH RECURSIVE months (PayDate) AS (
    SELECT DATE('2022-01-01')
    UNION ALL
    SELECT DATE_ADD(PayDate, INTERVAL 1 MONTH)
    FROM months
    WHERE PayDate < '2026-12-31'
  )
  SELECT PayDate FROM months
) AS m
JOIN MANAGER d;

/* insert data into payroll from staging table */
INSERT INTO PAYROLL (
  CalendarKey,
  ManagerKey,
  MonthlySalary,
  EmployeeID
)
SELECT
  c.CalendarKey,
  m.ManagerKey,
  ROUND(m.Salary / 12, 2) AS MonthlySalary,
  s.ManagerID
FROM StagingPayroll s
JOIN CALENDAR c
    ON s.PayDate = c.FullDate
JOIN MANAGER m
    ON s.ManagerID = m.ManagerID;

/* revenue fact table */ 
/* create staging table for revenue */
CREATE TEMPORARY TABLE StagingRevenue (
  LeaseID CHAR(10),
  StartDate DATE,
  EndDate DATE,
  MonthlyRent INT,
  SecurityDeposit INT,
  TotalRevenue DECIMAL(10, 2),
  AptNo VARCHAR(3),
  BuildingID CHAR(3),
  CCID CHAR(4)
);

/* insert raw data and revenue calcuation into staging table */
INSERT INTO StagingRevenue (
  LeaseID,
  StartDate,
  EndDate,
  MonthlyRent,
  SecurityDeposit,
  TotalRevenue,
  AptNo,
  BuildingID,
  CCID
)
SELECT
  l.LeaseID,
  l.LeaseStartDate,
  l.LeaseEndDate,
  l.MonthlyRent,
  l.SecurityDeposit,
  l.MonthlyRent * 12 AS TotalRevenue,
  l.AptNo,
  l.BuildingID,
  l.CCID
FROM GroupProject.LEASE l;

/* insert data into revenue fact table from staging revenue */
INSERT INTO REVENUE (
  CalendarKey,
  ApartmentKey,
  ClientKey,
  LeaseID,
  MonthlyRent,
  SecurityDeposit,
  TotalRevenue,
  StartDate,
  EndDate
)
SELECT
  c.CalendarKey,
  a.ApartmentKey,
  cl.ClientKey,
  s.LeaseID,
  s.MonthlyRent,
  s.SecurityDeposit,
  s.TotalRevenue,
  s.StartDate,
  s.EndDate
FROM StagingRevenue s
JOIN CALENDAR c
  ON s.StartDate = c.FullDate
JOIN APARTMENT a
  ON s.AptNo = a.AptNo AND s.BuildingID = a.BuildingID
JOIN CLIENTS cl
  ON s.CCID = cl.CCID;

/* drop staging tables */
DROP TABLE `GroupProject2`.`StagingPayroll`;
DROP TABLE `GroupProject2`.`StagingMaintenance`;
DROP TABLE `GroupProject2`.`StagingRevenue`;


/* Summary Tables */ 



/* BI Reports */
/* Maintenance Load Distribution
How evenly is maintenance workload distributed among staff?
*/
SELECT 
    MS.MStaffID,
    MS.MSName,
    COUNT(M.RequestID) AS RequestsHandled
FROM MSTAFF MS
LEFT JOIN MAINTENANCE M ON MS.MStaffKey = M.MStaffKey
GROUP BY MS.MStaffID, MS.MSName
ORDER BY RequestsHandled DESC;

/*
Revenue Trend by Year and Building
Which buildings have grown or declined in revenue over the past 3 years?
*/
SELECT 
    A.BuildingID,
    YEAR(R.StartDate) AS RevenueYear,
    SUM(R.TotalRevenue) AS TotalRevenue
FROM REVENUE R
JOIN APARTMENT A ON R.ApartmentKey = A.ApartmentKey
WHERE R.StartDate >= DATE_SUB(CURDATE(), INTERVAL 3 YEAR)
GROUP BY A.BuildingID, RevenueYear
ORDER BY A.BuildingID, RevenueYear;


/* Average Rent per Building */
SELECT 
    A.BuildingID,
    ROUND(AVG(R.MonthlyRent), 2) AS AverageMonthlyRent,
    COUNT(DISTINCT A.AptNo) AS NumberOfApartments
FROM REVENUE R
JOIN APARTMENT A ON R.ApartmentKey = A.ApartmentKey
GROUP BY A.BuildingID
ORDER BY A.BuildingID;