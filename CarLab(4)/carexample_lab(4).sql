-- Удаляем таблицы, если они существуют
DROP TABLE IF EXISTS Repairs CASCADE;
DROP TABLE IF EXISTS GarageCarBrands CASCADE;
DROP TABLE IF EXISTS CarBrands CASCADE;
DROP TABLE IF EXISTS Garages CASCADE;
DROP TABLE IF EXISTS Cars CASCADE;

-- Создаем таблицу гаражей
CREATE TABLE Garages (
    GarageID SERIAL PRIMARY KEY,
    GarageName VARCHAR(100) NOT NULL,
    Location VARCHAR(100) NOT NULL
);

-- Создаем таблицу марок автомобилей
CREATE TABLE CarBrands (
    CarBrandID SERIAL PRIMARY KEY,
    CarBrandName VARCHAR(100) NOT NULL,
    RepairCost NUMERIC NOT NULL
);

-- Создаем таблицу автомобилей
CREATE TABLE Cars (
    CarID SERIAL PRIMARY KEY,
    CarBrand VARCHAR(100) NOT NULL,
    GarageID INT NOT NULL,
    Discount INT NOT NULL,
    FOREIGN KEY (GarageID) REFERENCES Garages(GarageID)
);

-- Создаем таблицу ремонтов
CREATE TABLE Repairs (
    RepairID SERIAL PRIMARY KEY,
    RepairDate DATE NOT NULL,
    CarID INT NOT NULL,
    GarageID INT NOT NULL,
    CarBrandID INT NOT NULL,
    Quantity INT NOT NULL,
    RepairCost NUMERIC NOT NULL,
    FOREIGN KEY (CarID) REFERENCES Cars(CarID),
    FOREIGN KEY (GarageID) REFERENCES Garages(GarageID),
    FOREIGN KEY (CarBrandID) REFERENCES CarBrands(CarBrandID)
);

-- Заполняем таблицу гаражей
INSERT INTO Garages (GarageName, Location) VALUES 
('Гараж 1', 'Москва'),
('Гараж 2', 'Санкт-Петербург'),
('Гараж 3', 'Казань'),
('Гараж 4', 'Екатеринбург'),
('Гараж 5', 'Новосибирск');

-- Заполняем таблицу марок автомобилей
INSERT INTO CarBrands (CarBrandName, RepairCost) VALUES 
('Toyota', 5000),
('BMW', 10000),
('Audi', 12000),
('Mercedes', 15000),
('Lada', 3000),
('Kia', 7000);

-- Заполняем таблицу автомобилей
INSERT INTO Cars (CarBrand, GarageID, Discount) VALUES 
('Toyota', 1, 10),  -- Гараж 1
('BMW', 2, 5),       -- Гараж 2
('Audi', 3, 15),     -- Гараж 3
('Mercedes', 4, 20), -- Гараж 4
('Lada', 5, 0),      -- Гараж 5
('Kia', 1, 10);      -- Гараж 1

-- Заполняем таблицу ремонтов
INSERT INTO Repairs (RepairDate, CarID, GarageID, CarBrandID, Quantity, RepairCost) VALUES 
('2023-10-01', 1, 1, 1, 1, 5000),   -- Toyota в гараже 1
('2023-10-02', 2, 2, 2, 1, 10000),  -- BMW в гараже 2
('2023-10-03', 3, 3, 3, 1, 12000),  -- Audi в гараже 3
('2023-10-04', 4, 4, 4, 1, 15000),  -- Mercedes в гараже 4
('2023-10-05', 5, 5, 5, 1, 3000),   -- Lada в гараже 5
('2023-10-06', 6, 1, 6, 1, 7000),   -- Kia в гараже 1
('2023-10-07', 1, 1, 1, 2, 10000),  -- Toyota в гараже 1 (2 ремонта)
('2023-10-08', 2, 2, 2, 1, 10000),  -- BMW в гараже 2
('2023-10-09', 3, 3, 3, 1, 12000),  -- Audi в гараже 3
('2023-10-10', 4, 4, 4, 1, 15000); -- Mercedes в гараже 4
