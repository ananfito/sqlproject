/* Create the database */ 
create database GroupProject;
use GroupProject;

/* Create the tables */ 
CREATE TABLE MANAGER (
  ManagerID CHAR(5) NOT NULL,
  LastName VARCHAR(25) NOT NULL,
  FirstName VARCHAR(25) NOT NULL,
  Salary NUMERIC(9,2) NOT NULL,
  MBuildingID CHAR(3) NULL,
  PRIMARY KEY (ManagerID)
);

CREATE TABLE BUILDING (
  BuildingID CHAR(3) NOT NULL,
  BManagerID CHAR(5) NOT NULL,
  PRIMARY KEY (BuildingID),
  FOREIGN KEY (BManagerID) REFERENCES MANAGER(ManagerID)
);

INSERT INTO MANAGER (ManagerID, LastName, FirstName, Salary, MBuildingID)
VALUES 
('M1001', 'Smith', 'Jordan', 70068.00, null),
('M1002', 'Johnson', 'Alex', 100237.00, null),
('M1003', 'Williams', 'Casey', 90470.00, null),
('M1004', 'Davis', 'Jordan', 101661.00, null),
('M1005', 'Lopez', 'Morgan', 112305.00, null),
('M1006', 'Martinez', 'Casey', 111145.00, null),
('M1007', 'Brown', 'Pat', 98181.00, null),
('M1008', 'Taylor', 'Andy', 79886.00, null),
('M1009', 'Jones', 'Dave', 91942.00, null),
('M1010', 'Hernandez', 'Jane', 88556.00, null);

INSERT INTO BUILDING (BuildingID, BManagerID)
VALUES
  ('B01', 'M1001'),
  ('B02', 'M1001'),
  ('B03', 'M1002'),
  ('B04', 'M1002'),
  ('B05', 'M1003'),
  ('B06', 'M1003'),
  ('B07', 'M1004'),
  ('B08', 'M1004'),
  ('B09', 'M1005'),
  ('B10', 'M1005'),
  ('B11', 'M1006'),
  ('B12', 'M1007'),
  ('B13', 'M1008'),
  ('B14', 'M1009'),
  ('B15', 'M1010');

ALTER TABLE MANAGER
ADD CONSTRAINT fk_Manager_MBuilding
FOREIGN KEY (MBuildingID) REFERENCES BUILDING(BuildingID);

UPDATE MANAGER
SET MBuildingID = "B01"
WHERE ManagerID = "M1001";

UPDATE MANAGER
SET MBuildingID = "B03"
WHERE ManagerID = "M1002";

UPDATE MANAGER
SET MBuildingID = "B05"
WHERE ManagerID = "M1003";

UPDATE MANAGER
SET MBuildingID = "B07"
WHERE ManagerID = "M1004";

UPDATE MANAGER
SET MBuildingID = "B09"
WHERE ManagerID = "M1005";

UPDATE MANAGER
SET MBuildingID = "B11"
WHERE ManagerID = "M1006";

UPDATE MANAGER
SET MBuildingID = "B12"
WHERE ManagerID = "M1007";

UPDATE MANAGER
SET MBuildingID = "B13"
WHERE ManagerID = "M1008";

UPDATE MANAGER
SET MBuildingID = "B14"
WHERE ManagerID = "M1009";

UPDATE MANAGER
SET MBuildingID = "B15"
WHERE ManagerID = "M1010";

ALTER TABLE MANAGER
MODIFY MBuildingID CHAR(3) NOT NULL;

/* test to make sure alter statement worked; error msg "cannot be null" is correct result  */
INSERT INTO MANAGER (ManagerID, LastName, FirstName, Salary, MBuildingID)
VALUES ('M1011', 'Doe', 'John', 70068.00, null);

CREATE TABLE INSPECTOR (
  InsID CHAR(3) NOT NULL,
  InsLastName VARCHAR(20) NOT NULL,
  InsFirstName VARCHAR(20) NOT NULL,
  PRIMARY KEY (InsID)
);

CREATE TABLE STAFFMEMBER (
  StaffMID CHAR(4) NOT NULL,
  StaffLastName VARCHAR(25) NOT NULL,
  StaffFirstName VARCHAR(25) NOT NULL,
  PRIMARY KEY (StaffMID)
);

CREATE TABLE CORPCLIENT (
  CCID CHAR(4) NOT NULL,
  CCName VARCHAR(100) NOT NULL,
  CCIndustry VARCHAR(50) NOT NULL,
  CCLocation VARCHAR(50) NOT NULL,
  Refers_CCID CHAR(4) NULL,
  PRIMARY KEY (CCID),
  FOREIGN KEY (Refers_CCID) REFERENCES CORPCLIENT(CCID)
);

CREATE TABLE APARTMENT (
  AptNo VARCHAR(3) NOT NULL,
  BuildingID CHAR(3) NOT NULL,
  AptNoofBedrooms INT NOT NULL,
  OccupancyStatus VARCHAR(10) NOT NULL,
  CCID CHAR(4) NULL,
  StaffMID CHAR(4) NOT NULL,
  PRIMARY KEY (AptNo, BuildingID),
  FOREIGN KEY (BuildingID) REFERENCES BUILDING(BuildingID),
  FOREIGN KEY (CCID) REFERENCES CORPCLIENT(CCID),
  FOREIGN KEY (StaffMID) REFERENCES STAFFMEMBER(StaffMID)
);

CREATE TABLE MAINTENANCEREQUEST (
  RequestID VARCHAR(10) NOT NULL,
  ReqStatus VARCHAR(9) NOT NULL,
  DateSubmitted DATE NOT NULL,
  IssueDescription VARCHAR(200) NOT NULL,
  AptNo VARCHAR(3) NOT NULL,
  BuildingID CHAR(3) NOT NULL,
  PRIMARY KEY (RequestID),
  FOREIGN KEY (AptNo, BuildingID) REFERENCES APARTMENT(AptNo, BuildingID)
);

CREATE TABLE LEASE (
  LeaseID CHAR(10) NOT NULL,
  LeaseStartDate DATE NOT NULL,
  LeaseEndDate DATE NOT NULL,
  MonthlyRent INT NOT NULL,
  SecurityDeposit INT NOT NULL,
  AptNo VARCHAR(3) NOT NULL,
  BuildingID CHAR(3) NOT NULL,
  CCID CHAR(4) NOT NULL,
  PRIMARY KEY (LeaseID),
  FOREIGN KEY (AptNo, BuildingID) REFERENCES APARTMENT(AptNo, BuildingID),
  FOREIGN KEY (CCID) REFERENCES CORPCLIENT(CCID)
);

CREATE TABLE Inspects (
  InsID CHAR(3) NOT NULL,
  BuildingID CHAR(3) NOT NULL,
  DateLast DATE NOT NULL,
  DateNext DATE NOT NULL,
  PRIMARY KEY (InsID, BuildingID),
  FOREIGN KEY (InsID) REFERENCES INSPECTOR(InsID),
  FOREIGN KEY (BuildingID) REFERENCES BUILDING(BuildingID)
);

CREATE TABLE MANAGER_ContactInfo (
  ManagerID CHAR(5) NOT NULL,
  ContactInfo VARCHAR(14) NOT NULL,
  PRIMARY KEY (ManagerID, ContactInfo),
  FOREIGN KEY (ManagerID) REFERENCES MANAGER(ManagerID)
);

show tables;

/* insert data */
INSERT INTO MANAGER_ContactInfo (ManagerID, ContactInfo)
VALUES
('M1001', '(213) 456-7890'),
('M1001', '(415) 678-9012'),
('M1002', '(312) 234-5678'),
('M1002', '(646) 890-1234'),
('M1003', '(702) 345-6789'),
('M1003', '(503) 567-8901'),
('M1004', '(407) 678-2345'),
('M1005', '(919) 789-0123'),
('M1005', '(303) 456-1234'),
('M1005', '(818) 901-3456'),
('M1006', '(212) 987-6543'),
('M1007', '(415) 555-7890'),
('M1008', '(703) 456-7890'),
('M1008', '(312) 345-6789'),
('M1009', '(404) 567-8901'),
('M1010', '(713) 456-7891');
  
INSERT INTO INSPECTOR (InsID, InsFirstName, InsLastName)
VALUES 
('I01', 'Sarah', 'Kim'),
('I02', 'David', 'Patel'),
('I03', 'Maria', 'Lopez'),
('I04', 'John', 'Thompson'),
('I05', 'Emily', 'Wong'),
('I06', 'Ahmed', 'Khan'),
('I07', 'Hannah', 'Wilson'),
('I08', 'James', 'O’Connor'),
('I09', 'Priya', 'Desai'),
('I10', 'Marcus', 'Brown');

INSERT INTO STAFFMEMBER (StaffMID, StaffLastName, StaffFirstName)
VALUES
(2001, 'Vexley', 'Jasper'),
(2002, 'Corwin', 'Liana'),
(2003, 'Dreston', 'Orion'),
(2004, 'Renshaw', 'Sylvie'),
(2005, 'Fairbrooke', 'Tobias'),
(2006, 'Ellsworth', 'Mira'),
(2007, 'Valtieri', 'Callum'),
(2008, 'Winscott', 'Elara'),
(2009, 'Graves', 'Finnian'),
(2010, 'Dalloway', 'Seraphine'),
(2011, 'Henry', 'Isla'),
(2012, 'Chloe', 'Caleb'),
(2013, 'Owen', 'Ruby'),
(2014, 'Hazel', 'Atticus'),
(2015, 'Asher', 'Violet');

INSERT INTO CORPCLIENT (CCID, CCName, CCIndustry, CCLocation, Refers_CCID)
VALUES
('C101', 'GlobalTech Solutions Inc.', 'Maritime Industry', 'Newport', NULL),
('C102', 'Bridgeview Financial Group', 'Education', 'Sacramento', NULL),
('C103', 'Innovate Healthcare Systems', 'Research & Development', 'Portland', NULL),
('C104', 'Strategic Business Consultants LLC', 'Energy & Utilities', 'Portland', 'C102'),
('C105', 'Dynamic Digital Solutions', 'Arts & Entertainment', 'Newport', NULL),
('C106', 'Pioneer Construction & Development', 'Non-profit Sector', 'Sacramento', NULL),
('C107', 'Harbor Freight Transportation', 'Healthcare', 'San Jose', 'C105'),
('C108', 'Bloomfield Educational Group', 'Transportation & Logistics', 'Los Angeles', 'C105'),
('C109', 'Summit Retail Ventures', 'Education', 'San Jose', NULL),
('C110', 'Precision Engineering Associates', 'Security Services', 'Sacramento', NULL),
('C111', 'Quantum Software Innovations', 'Financial Services', 'San Jose', 'C104'),
('C112', 'United Medical Staffing', 'Technology', 'Portland', NULL),
('C113', 'Continental Project Management', 'Marine Science & Exploration', 'Newport', NULL),
('C114', 'Horizon Renewable Energy LLC', 'Agriculture', 'Sacramento', 'C111'),
('C115', 'Liberty Financial Planning', 'Environmental Services', 'Los Angeles', 'C114');

INSERT INTO APARTMENT (AptNo, BuildingID, AptNoOfBedrooms, OccupancyStatus, CCID, StaffMID)
VALUES
(11, 'B01', 2, 'Occupied', 'C101', 2001),
(12, 'B01', 3, 'Occupied', 'C101', 2001),
(13, 'B01', 1, 'Occupied', 'C114', 2001),
(21, 'B02', 2, 'Occupied', 'C115', 2002),
(22, 'B02', 1, 'Occupied', 'C115', 2002),
(31, 'B03', 2, 'Unoccupied', NULL, 2003),
(32, 'B03', 3, 'Occupied', 'C102', 2003),
(33, 'B03', 1, 'Unoccupied', NULL, 2003),
(41, 'B04', 2, 'Occupied', 'C113', 2004),
(42, 'B04', 1, 'Unoccupied', NULL, 2004),
(51, 'B05', 2, 'Occupied', 'C104', 2005),
(52, 'B05', 3, 'Occupied', 'C104', 2005),
(53, 'B05', 1, 'Occupied', 'C103', 2005),
(61, 'B06', 2, 'Occupied', 'C108', 2006),
(62, 'B06', 1, 'Occupied', 'C110', 2006),
(71, 'B07', 2, 'Occupied', 'C112', 2007),
(72, 'B07', 3, 'Unoccupied', NULL, 2007),
(73, 'B07', 1, 'Occupied', 'C106', 2007),
(81, 'B08', 2, 'Occupied', 'C107', 2008),
(82, 'B08', 1, 'Occupied', 'C113', 2008),
(91, 'B09', 2, 'Occupied', 'C108', 2009),
(92, 'B09', 3, 'Occupied', 'C109', 2009),
(93, 'B09', 1, 'Occupied', 'C112', 2009),
(101, 'B10', 2, 'Unoccupied', NULL, 2010),
(102, 'B10', 1, 'Occupied', 'C111', 2010),
(111, 'B11', 2, 'Occupied', 'C108', 2011),
(112, 'B11', 3, 'Unoccupied', NULL, 2011),
(113, 'B11', 1, 'Unoccupied', NULL, 2011),
(121, 'B12', 2, 'Occupied', 'C103', 2012),
(122, 'B12', 1, 'Occupied', 'C103', 2012),
(131, 'B13', 2, 'Occupied', 'C115', 2013),
(132, 'B13', 3, 'Occupied', 'C114', 2013),
(133, 'B13', 1, 'Unoccupied', NULL, 2013),
(141, 'B14', 2, 'Occupied', 'C106', 2014),
(142, 'B14', 1, 'Unoccupied', NULL, 2014),
(151, 'B15', 2, 'Occupied', 'C102', 2015),
(152, 'B15', 3, 'Occupied', 'C102', 2015),
(153, 'B15', 1, 'Unoccupied', NULL, 2015);

INSERT INTO MAINTENANCEREQUEST (RequestID, ReqStatus, DateSubmitted, IssueDescription, AptNo, BuildingID)
VALUES
('ELE-01', 'Completed', '2024-05-12', 'Broken light fixture in kitchen', 52, 'B05'),
('STR-01', 'Completed', '2024-05-14', 'Door lock replacement', 61, 'B06'),
('HVAC-01', 'Completed', '2024-07-23', 'Air condition not working properly', 121, 'B12'),
('ELE-02', 'Canceled', '2024-07-30', 'Broken light fixture in bathroom', 22, 'B02'),
('PLM-01', 'Completed', '2024-08-03', 'Kitchen Faucet is leaking', 73, 'B07'),
('HVAC-02', 'Completed', '2024-08-04', 'Air condition not working properly', 133, 'B13'),
('ELE-03', 'Completed', '2024-10-12', 'Smoke/CO detector maintenance', 81, 'B08'),
('HVAC-03', 'Pending', '2024-11-30', 'Heater not working properly', 122, 'B12'),
('STR-02', 'Pending', '2024-12-17', 'Roof leak', 13, 'B01'),
('STR-03', 'Pending', '2024-12-17', 'Roof leak', 11, 'B01');

INSERT INTO LEASE (LeaseID, LeaseStartDate, LeaseEndDate, MonthlyRent, SecurityDeposit, AptNO, BuildingID, CCID)
VALUES
('L000000001', '2025-01-01', '2026-01-01', 1200, 600, 11, 'B01', 'C101'),
('L000000002', '2024-06-01', '2025-06-01', 1500, 750, 12, 'B01', 'C101'),
('L000000003', '2024-04-01', '2025-05-01', 1000, 500, 13, 'B01', 'C114'),
('L000000004', '2024-05-01', '2025-05-01', 1200, 600, 21, 'B02', 'C115'),
('L000000006', '2024-08-01', '2025-08-01', 1000, 500, 22, 'B02', 'C115'),
('L000000007', '2023-04-01', '2024-04-01', 1200, 600, 31, 'B03', 'C104'),
('L000000008', '2024-07-01', '2025-07-01', 1500, 750, 32, 'B03', 'C102'),
('L000000009', '2023-11-01', '2024-11-01', 1000, 500, 33, 'B03', 'C102'),
('L000000010', '2024-12-01', '2025-12-01', 1200, 600, 41, 'B04', 'C113'),
('L000000012', '2023-04-15', '2024-04-15', 1000, 500, 42, 'B04', 'C115'),
('L000000013', '2024-04-30', '2025-04-30', 1200, 600, 51, 'B05', 'C104'),
('L000000014', '2024-05-15', '2025-05-15', 1500, 750, 52, 'B05', 'C104'),
('L000000015', '2024-05-30', '2025-05-30', 1000, 500, 53, 'B05', 'C103'),
('L000000016', '2024-06-15', '2025-06-15', 1200, 600, 61, 'B06', 'C108'),
('L000000018', '2024-07-15', '2025-07-15', 1000, 500, 62, 'B06', 'C110'),
('L000000019', '2024-07-30', '2025-07-30', 1500, 600, 71, 'B07', 'C112'),
('L000000020', '2023-08-15', '2024-08-15', 1200, 750, 72, 'B07', 'C106'),
('L000000021', '2024-08-30', '2025-08-30', 1000, 500, 73, 'B07', 'C106'),
('L000000022', '2024-09-15', '2025-09-15', 1200, 600, 81, 'B08', 'C107'),
('L000000024', '2024-10-15', '2025-10-15', 1000, 500, 82, 'B08', 'C113'),
('L000000025', '2024-10-30', '2025-10-30', 1200, 600, 91, 'B09', 'C108'),
('L000000026', '2024-11-15', '2025-11-15', 1500, 750, 92, 'B09', 'C109'),
('L000000027', '2024-11-30', '2025-11-30', 1000, 500, 93, 'B09', 'C112'),
('L000000028', '2023-12-15', '2024-12-15', 1200, 600, 101, 'B10', 'C112'),
('L000000030', '2025-01-01', '2026-01-01', 1000, 500, 102, 'B10', 'C111'),
('L000000031', '2024-11-01', '2025-11-01', 1200, 600, 111, 'B11', 'C108'),
('L000000032', '2023-12-01', '2024-12-01', 1500, 750, 112, 'B11', 'C102'),
('L000000033', '2023-04-15', '2024-04-15', 1000, 500, 113, 'B11', 'C108'),
('L000000034', '2024-04-30', '2025-04-30', 1200, 600, 121, 'B12', 'C103'),
('L000000035', '2024-05-15', '2025-05-15', 1000, 500, 122, 'B12', 'C103'),
('L000000036', '2024-05-30', '2025-05-30', 1200, 600, 131, 'B13', 'C115'),
('L000000037', '2024-06-15', '2025-06-15', 1500, 750, 132, 'B13', 'C114'),
('L000000038', '2023-06-01', '2024-06-01', 1000, 500, 133, 'B13', 'C103'),
('L000000039', '2024-04-01', '2025-05-01', 1200, 600, 141, 'B14', 'C106'),
('L000000040', '2023-05-01', '2024-05-01', 1000, 500, 142, 'B14', 'C106'),
('L000000041', '2024-11-30', '2025-11-30', 1200, 600, 151, 'B15', 'C102'),
('L000000042', '2024-12-15', '2025-12-15', 1500, 750, 152, 'B15', 'C102'),
('L000000043', '2023-01-01', '2024-01-01', 1000, 500, 153, 'B15', 'C107');

INSERT INTO Inspects (InsID, BuildingID, DateLast, DateNext)
VALUES
('I01', 'B01', '2024-07-15', '2025-07-15'),
('I01', 'B02', '2024-04-15', '2025-04-15'),
('I02', 'B02', '2024-08-04', '2025-06-27'),
('I02', 'B03', '2024-07-15', '2025-08-10'),
('I03', 'B04', '2024-12-03', '2025-12-03'),
('I03', 'B05', '2024-08-10', '2025-09-01'),
('I04', 'B05', '2024-05-14', '2025-05-14'),
('I04', 'B06', '2024-06-15', '2025-07-15'),
('I05', 'B07', '2024-09-10', '2025-04-17'),
('I05', 'B08', '2024-07-15', '2025-08-10'),
('I06', 'B08', '2024-04-16', '2025-04-16'),
('I06', 'B09', '2024-08-10', '2025-09-01'),
('I07', 'B10', '2024-05-23', '2025-05-23'),
('I07', 'B11', '2024-05-15', '2025-07-15'),
('I08', 'B11', '2024-08-12', '2025-08-12'),
('I08', 'B12', '2024-07-15', '2025-08-10'),
('I09', 'B13', '2024-09-10', '2025-09-10'),
('I09', 'B14', '2024-08-10', '2025-09-01'),
('I10', 'B14', '2024-11-22', '2025-07-16'),
('I10', 'B15', '2024-09-01', '2025-12-30');

select * from Inspects;

/* run queries to answer biz questions */ 
/* Retrieve all Maintenance Requests and corresponding Apartment and Building Information: */
SELECT mr.RequestID, mr.ReqStatus, mr.DateSubmitted, mr.IssueDescription, a.AptNo, b.BuildingID
FROM MaintenanceRequest mr
JOIN Apartment a ON mr.AptNo = a.AptNo
JOIN Building b ON mr.BuildingID = b.BuildingID;

/* Retrieve Apartments with Lease Expiry Date in the Next 3 Months: */
SELECT LeaseID, LeaseStartDate, LeaseEndDate, AptNo, MonthlyRent
FROM Lease
WHERE LeaseEndDate <= (SELECT CURDATE() + INTERVAL 3 MONTH);

/* Which buildings have the highest number of pending maintenance requests? */
SELECT BuildingID, 
COUNT(*) AS PendingRequests
FROM MaintenanceRequest
WHERE ReqStatus = 'Pending'
GROUP BY BuildingID
ORDER BY PendingRequests DESC;

# What is the average rent per building?
SELECT A.BuildingID, AVG(L.MonthlyRent) AS AvgRent
FROM APARTMENT A
JOIN LEASE L ON A.AptNo = L.AptNo AND A.BuildingID = L.BuildingID
GROUP BY A.BuildingID;

# When is the next inspection scheduled for each building?
SELECT BuildingID, MIN(DateNext) AS NextInspection
FROM Inspects
GROUP BY BuildingID
ORDER BY NextInspection;

# What is the occupancy status? 
SELECT AptNo, BuildingID, AptNoofBedrooms, OccupancyStatus, CCID FROM Apartment WHERE OccupancyStatus = 'Unoccupied';

# Total Revenue from leases in 2024
SELECT SUM(MonthlyRent) AS TotalRevenue FROM LEASE WHERE YEAR(LeaseStartDate) = 2024;

# Find the average salary of managers per building
SELECT M.MBuildingID, AVG(M.Salary) AS AverageSalary
FROM Manager M
GROUP BY M.MBuildingID;

# Identify which apartments have maintenance requests submitted within the past 120 days
SELECT R.RequestID, R.ReqStatus, R.IssueDescription, R.DateSubmitted
FROM MAINTENANCEREQUEST R
WHERE R.DateSubmitted >= CURDATE() - INTERVAL 120 DAY;

# Which companies have been referred by other companies, and what are the names of those referrers?
SELECT c1.CCID AS ReferredCompanyID, c1.CCName AS ReferredCompanyName, c2.CCID AS ReferrerCompanyID, c2.CCName AS ReferrerCompanyName
FROM CORPCLIENT c1
JOIN CORPCLIENT c2 ON c1.Refers_CCID = c2.CCID;

/* insert new entites and data */ 
CREATE TABLE PARKINGPERMITS (
    PermitID CHAR(6)  NOT NULL,
	AptNo VARCHAR(3) NOT NULL,
    BuildingID CHAR(3) NOT NULL,
    VehicleModel VARCHAR(50) NOT NULL,
    VehicleMake VARCHAR(50) NOT NULL,
    PlateNumber CHAR(7) NOT NULL,
    PermitStartDate DATE NOT NULL,
    PermitEndDate DATE NOT NULL,
    PermitStatus CHAR(7) NOT NULL,
    PRIMARY KEY (PermitID),
    FOREIGN KEY (AptNo, BuildingID) REFERENCES APARTMENT(AptNo, BuildingID)
);

CREATE TABLE MAINTENANCESTAFF (
    MStaffID CHAR(4) NOT NULL,
    MSLastName VARCHAR(50) NOT NULL,
    MSFirstName VARCHAR(50) NOT NULL,
    PRIMARY KEY (MStaffID)
);

INSERT INTO MAINTENANCESTAFF (MStaffID, MSLastName, MSFirstName) VALUES
('3001', 'Kissingjer', 'John'),
('3002', 'Jones', 'Olivia'),
('3003', 'Martinez', 'Sophia'),
('3004', 'Johnson', 'Michael'),
('3005', 'Miller', 'James'),
('3006', 'Smith', 'Sarah'),
('3007', 'Williams', 'Emma'),
('3008', 'Garcia', 'Benjamin'),
('3009', 'Garcia', 'Benjamin'),
('3010', 'Martinez', 'Sophia');

# alter MAINTENANCEREQUEST table to include FK from MAINTENANCESTAFF table
ALTER TABLE MAINTENANCEREQUEST
ADD MStaffID CHAR(4) NULL;

UPDATE MAINTENANCEREQUEST
SET MStaffID = "3003"
WHERE RequestID = "ELE-01";

UPDATE MAINTENANCEREQUEST
SET MStaffID = "3006"
WHERE RequestID = "STR-01";

UPDATE MAINTENANCEREQUEST
SET MStaffID = "3001"
WHERE RequestID = "HVAC-01";

UPDATE MAINTENANCEREQUEST
SET MStaffID = "3007"
WHERE RequestID = "ELE-02";

UPDATE MAINTENANCEREQUEST
SET MStaffID = "3001"
WHERE RequestID = "PLM-01";

UPDATE MAINTENANCEREQUEST
SET MStaffID = "3004"
WHERE RequestID = "HVAC-02";

UPDATE MAINTENANCEREQUEST
SET MStaffID = "3008"
WHERE RequestID = "ELE-03";

UPDATE MAINTENANCEREQUEST
SET MStaffID = "3002"
WHERE RequestID = "HVAC-03";

UPDATE MAINTENANCEREQUEST
Set MStaffID = "3005"
WHERE RequestID = "STR-02";

UPDATE MAINTENANCEREQUEST
Set MStaffID = "3005"
WHERE RequestID = "STR-03";

ALTER TABLE MAINTENANCEREQUEST
ADD CONSTRAINT fk_MAINTENANCEREQUEST_MStaffID
FOREIGN KEY (MStaffID) REFERENCES MAINTENANCESTAFF(MStaffID);

ALTER TABLE MAINTENANCEREQUEST
MODIFY MStaffID CHAR(4) NOT NULL;

INSERT INTO PARKINGPERMITS (
    PermitID, AptNo, BuildingID, VehicleModel, VehicleMake, PlateNumber, PermitStartDate, PermitEndDate, PermitStatus
) VALUES
('P00001', 11, 'B01', 'Toyota', 'Corolla', '7XYZ123', '2025-01-01', '2025-12-31', 'Active'),
('P00002', 21, 'B02', 'Honda', 'Civic', '8ABC456', '2024-06-01', '2025-05-31', 'Active'),
('P00003', 31, 'B03', 'Ford', 'Focus', '9QWE789', '2024-03-01', '2025-02-28', 'Expired'),
('P00004', 53, 'B05', 'Tesla', 'Model 3', '3EVT333', '2024-07-15', '2025-07-14', 'Active'),
('P00005', 71, 'B07', 'Nissan', 'Altima', '5DRT678', '2023-09-01', '2024-08-31', 'Expired'),
('P00006', 101, 'B10', 'Hyundai', 'Sonata', '1LMN234', '2025-04-01', '2026-03-31', 'Active'),
('P00007', 121, 'B12', 'BMW', 'X3', '6GHI901', '2025-01-01', '2025-12-31', 'Active'),
('P00008', 141, 'B14', 'Audi', 'A4', '2JKL567', '2024-10-01', '2025-09-30', 'Active'),
('P00009', 81, 'B08', 'Jeep', 'Wrangler', '4TUV432', '2023-05-01', '2024-04-30', 'Expired'),
('P00010', 132, 'B13', 'Chevrolet', 'Malibu', '0NOP876', '2025-03-15', '2026-03-14', 'Active');

CREATE TABLE MAINTENANCESTAFF_Certifications (
    MStaffID CHAR(4) NOT NULL,
    Certifications VARCHAR(50) NOT NULL,
    PRIMARY KEY (MStaffID, Certifications),
    FOREIGN KEY (MStaffID) REFERENCES MAINTENANCESTAFF(MStaffID)
);

INSERT INTO MAINTENANCESTAFF_Certifications (MStaffID, Certifications) VALUES
('3001', 'HVAC'),
('3001', 'PLM'),
('3002', 'HVAC'),
('3003', 'ELE'),
('3004', 'HVAC'),
('3004', 'STR'),
('3004', 'PLM'),
('3005', 'STR'),
('3006', 'STR'),
('3007', 'ELE'),
('3007', 'HVAC'),
('3008', 'ELE'),
('3009', 'PLM'),
('3010', 'ELE'),
('3010', 'PLM');

select * from maintenancestaff;

/* run new queries on new data */
# Find the total number of vehicles in each building, grouped by their permit status (Active, Expired).
SELECT BuildingID, PermitStatus, COUNT(PermitID) AS VehicleCount
FROM PARKINGPERMITS
GROUP BY BuildingID, PermitStatus;

# List all vehicles with their PermitID, Vehicle Model, and Vehicle Make.
SELECT PermitID, VehicleModel, VehicleMake
FROM PARKINGPERMITS;

# Find the number of active permits for each building.
SELECT BuildingID, COUNT(PermitID) AS ActivePermits
FROM PARKINGPERMITS
WHERE PermitStatus = 'Active'
GROUP BY BuildingID;

# How many maintenance staff members are certified in "HVAC" and what are their names?
SELECT MS.MSFirstName, MS.MSLastName
FROM MaintenanceStaff MS
JOIN MAINTENANCESTAFF_Certifications C ON MS.MStaffID = C.MStaffID
WHERE C.Certifications = 'HVAC';

# List all maintenance staff along with their certifications.
SELECT MS.MSFirstName, MS.MSLastName, C.Certifications
FROM MaintenanceStaff MS
LEFT JOIN MAINTENANCESTAFF_Certifications C ON MS.MStaffID = C.MStaffID;
