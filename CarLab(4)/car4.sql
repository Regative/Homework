-- Удаляем представление, если оно существует
DROP VIEW IF EXISTS RepairsView;

-- Создаем представление
CREATE VIEW RepairsView AS
SELECT 
    r.RepairID,
    r.RepairDate,
    c.CarBrand AS CarBrand,
    c.Discount,
    cb.CarBrandName,
    r.Quantity,
    r.RepairCost * (1 - c.Discount / 100.0) AS RepairCostWithDiscount
FROM 
    Repairs r
JOIN 
    Cars c ON r.CarID = c.CarID
JOIN 
    CarBrands cb ON r.CarBrandID = cb.CarBrandID;

-- Проверяем представление
SELECT * FROM RepairsView;

-- Обновляем скидку для автомобиля
UPDATE Cars
SET Discount = 10
WHERE CarID = 1;

-- Проверяем представление после обновления скидки
SELECT * FROM RepairsView;
