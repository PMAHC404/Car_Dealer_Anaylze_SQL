-- Vehicle Table
CREATE TABLE Vehicle (
    VehicleID INTEGER PRIMARY KEY,
    ModelName TEXT,
    VehicleType TEXT,
    Price REAL,
    FuelType TEXT
);

-- Salesperson Table
CREATE TABLE Salesperson (
    SalespersonID INTEGER PRIMARY KEY,
    FirstName TEXT,
    LastName TEXT
);

-- Sales Transaction Table
CREATE TABLE SalesTransaction (
    TransactionID INTEGER PRIMARY KEY,
    VehicleID INTEGER,
    SalespersonID INTEGER,
    SaleDate DATE,
    FOREIGN KEY (VehicleID) REFERENCES Vehicle(VehicleID),
    FOREIGN KEY (SalespersonID) REFERENCES Salesperson(SalespersonID)
);

-- Data for Vehicle Table
INSERT INTO Vehicle (ModelName, VehicleType, Price, FuelType) VALUES
('Sedan A', 'Sedan', 1200000, 'Petrol'),
('SUV X', 'SUV', 1500000, 'Electric'),
('Hatchback B', 'Hatchback', 800000, 'Petrol'),
('Sedan C', 'Sedan', 900000, 'Electric'),
('Truck Y', 'Truck', 2000000, 'Diesel'),
('SUV A', 'SUV', 1700000, 'Electric'),
('SUV Y', 'SUV', 1800000, 'Electric'),
('SUV Z', 'SUV', 1700000, 'Electric'),
('Hatchback C', 'Hatchback', 2100000, 'Petrol'),
('Sedan X', 'Sedan', 1500000, 'Petrol'),
('SUV B', 'SUV', 1300000, 'Electric');

-- Data for Salesperson Table
INSERT INTO Salesperson (FirstName, LastName) VALUES
('John', 'Doe'),
('Jane', 'Smith'),
('Bob', 'Johnson');

-- Data for Sales Transaction Table
INSERT INTO SalesTransaction (VehicleID, SalespersonID, SaleDate) VALUES
(1, 1, '2023-03-01'),
(2, 2, '2023-03-02'),
(3, 1, '2023-03-03'),
(4, 3, '2023-03-03'),
(5, 2, '2023-03-04'),
(6, 2, '2023-03-04'),
(7, 2, '2024-03-04'),
(8, 3, '2024-03-04'),
(9, 3, '2024-03-04'),
(10, 2, '2024-03-04'),
(11, 1, '2024-03-04'),
(12, 2, '2024-03-04');

-- RUN PREVIEW
.print #######################
.print #### SQL Challenge ####
.print #######################

.print \n Vehicle table
.mode box
select * from Vehicle;

.print \n Salesperson table
.mode box
select * from Salesperson;

.print \n SalesTransaction table
.mode box
select * from SalesTransaction;

-- Show a vehicle type from a highest to lowest sales.
SELECT
  ve.VehicleType,
  COUNT(st.TransactionID) as TotalSales
FROM Vehicle as ve
JOIN SalesTransaction as st ON ve.VehicleID = st.VehicleID
GROUP BY ve.VehicleType
ORDER BY TotalSales DESC;


-- Find a firstname and lastname of a salesperson who has highest sale and a quantity of sale.
SELECT
  FirstName,
  LastName,
  COUNT(TransactionID) as TotalTransactions
FROM Salesperson
JOIN SalesTransaction ON Salesperson.SalespersonID = SalesTransaction.SalespersonID
GROUP BY FirstName, LastName
ORDER BY TotalTransactions DESC LIMIT 1;


-- Calculate total sale for each salesperson.
SELECT
  FirstName,
  LastName,
  SUM(Price) AS TotalRevenue
FROM Salesperson
JOIN SalesTransaction ON Salesperson.SalespersonID = SalesTransaction.SalespersonID
JOIN Vehicle ON SalesTransaction.VehicleID = Vehicle.VehicleID
GROUP BY FirstName, LastName
ORDER BY TotalRevenue DESC;


-- In 2023 between petrol and electric which type of vehicle have a highest sale.
SELECT
  FuelType,
  COUNT(FuelType) AS TotalSales
FROM Vehicle
JOIN SalesTransaction ON Vehicle.VehicleID = SalesTransaction.VehicleID
WHERE STRFTIME('%Y', SaleDate) = '2023' AND FuelType in ('Electric', 'Petrol')
GROUP BY FuelType
ORDER BY TotalSales DESC;


-- Grouping for each car model, if a price is greater than 1,000,000 then show as "Flagship model" if not show as "Normal Model"
SELECT
  ModelName,
  CASE
    WHEN Price > 1000000 OR Price = 1000000 THEN 'Flagship Model'
    ELSE 'Normal Model'
  END AS ModelLabel
FROM Vehicle;
