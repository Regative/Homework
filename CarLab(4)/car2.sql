-- Удаляем таблицу, если она существует
DROP TABLE IF EXISTS GarageCarBrands;

-- Создаем таблицу, которая связывает гаражи и марки автомобилей
CREATE TABLE GarageCarBrands (
    id SERIAL PRIMARY KEY,
    GarageID INT NOT NULL,
    CarBrandID INT NOT NULL
);

-- Добавляем тестовые данные
INSERT INTO GarageCarBrands (GarageID, CarBrandID) VALUES 
(1, 1), -- Гараж 1 может обслуживать марку 1
(1, 2), -- Гараж 1 может обслуживать марку 2
(2, 2), -- Гараж 2 может обслуживать марку 2
(3, 3); -- Гараж 3 может обслуживать марку 3

-- Удаляем функцию, если она существует
DROP FUNCTION IF EXISTS check_garage_car_brand;

-- Создаем функцию для проверки
CREATE OR REPLACE FUNCTION check_garage_car_brand()
RETURNS TRIGGER AS $$
DECLARE
    error_msg TEXT := '';
BEGIN
    -- Проверка существования автомобиля
    IF NOT EXISTS (
        SELECT 1 FROM Cars WHERE CarID = NEW.CarID
    ) THEN
        RAISE EXCEPTION 'Ошибка: Автомобиль с идентификатором % не существует.', NEW.CarID;
    END IF;
    
    -- Проверка существования марки автомобиля
    IF NOT EXISTS (
        SELECT 1 FROM CarBrands WHERE CarBrandID = NEW.CarBrandID
    ) THEN
        RAISE EXCEPTION 'Ошибка: Марка автомобиля с идентификатором % не существует.', NEW.CarBrandID;
    END IF;

    -- Проверка, может ли гараж работать с данной маркой автомобиля
    IF NOT EXISTS (
        SELECT 1 
        FROM GarageCarBrands 
        WHERE GarageID = NEW.GarageID 
        AND CarBrandID = NEW.CarBrandID
    ) THEN
        RAISE EXCEPTION 'Ошибка: Гараж % не может обслуживать марку автомобиля %.', NEW.GarageID, NEW.CarBrandID;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Удаляем триггер, если он существует
DROP TRIGGER IF EXISTS check_garage_car_brand_trigger ON Repairs;

-- Создаем триггер
CREATE TRIGGER check_garage_car_brand_trigger
BEFORE INSERT ON Repairs
FOR EACH ROW EXECUTE FUNCTION check_garage_car_brand();

-- Примеры тестовых данных
-- Можно ремонтировать
INSERT INTO Repairs (CarID, GarageID, CarBrandID, RepairDate, RepairCost)
VALUES (1, 1, 1, '2023-10-01', 5000);

-- Автомобиль не существует
INSERT INTO Repairs (CarID, GarageID, CarBrandID, RepairDate, RepairCost)
VALUES (999, 1, 1, '2023-10-01', 5000);

-- Марка автомобиля не существует
INSERT INTO Repairs (CarID, GarageID, CarBrandID, RepairDate, RepairCost)
VALUES (1, 1, 999, '2023-10-01', 5000);

-- Гараж не может обслуживать эту марку
INSERT INTO Repairs (CarID, GarageID, CarBrandID, RepairDate, RepairCost)
VALUES (1, 3, 1, '2023-10-01', 5000);
