-- Удаляем функцию, если она существует
DROP FUNCTION IF EXISTS calculate_repair_cost;

-- Создаем функцию для вычисления стоимости ремонта
CREATE OR REPLACE FUNCTION calculate_repair_cost()
RETURNS TRIGGER AS $$
DECLARE
    cost_per_unit NUMERIC;
BEGIN
    -- Если стоимость ремонта не указана, вычисляем её
    IF NEW.RepairCost IS NULL THEN
        -- Получаем стоимость ремонта для данной марки автомобиля
        SELECT RepairCost INTO cost_per_unit
        FROM CarBrands 
        WHERE CarBrandID = NEW.CarBrandID;

        -- Вычисляем общую стоимость ремонта
        NEW.RepairCost := NEW.Quantity * cost_per_unit;

        -- Выводим сообщение о вычисленной стоимости
        RAISE NOTICE 'Стоимость ремонта не указана. Вычислено автоматически: %', NEW.RepairCost;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Удаляем триггер, если он существует
DROP TRIGGER IF EXISTS calculate_repair_cost_trigger ON Repairs;

-- Создаем триггер
CREATE TRIGGER calculate_repair_cost_trigger
BEFORE INSERT ON Repairs
FOR EACH ROW EXECUTE FUNCTION calculate_repair_cost();

-- Вставляем запись без указания стоимости
INSERT INTO Repairs (CarID, GarageID, CarBrandID, RepairDate, Quantity)
VALUES (1, 1, 1, '2023-10-01', 2);

-- Проверяем результат
SELECT * FROM Repairs WHERE Quantity = 2;

-- Вставляем запись с указанием стоимости
INSERT INTO Repairs (CarID, GarageID, CarBrandID, RepairDate, Quantity, RepairCost)
VALUES (1, 1, 1, '2023-10-01', 3, 15000);

-- Проверяем результат
SELECT * FROM Repairs WHERE Quantity = 3;
