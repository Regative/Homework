DROP FUNCTION IF EXISTS get_car_info(INT);

CREATE OR REPLACE FUNCTION get_car_info(car_id INT)
RETURNS TEXT AS $$
DECLARE
    result TEXT;
    car_exists BOOLEAN;
    last_repair RECORD;
BEGIN
    -- Проверяем, существует ли автомобиль с таким идентификатором
    SELECT EXISTS(SELECT 1 FROM Cars WHERE CarID = car_id) INTO car_exists;
    
    IF NOT car_exists THEN
        RETURN 'Автомобиль с идентификатором ' || car_id || ' не существует.';
    ELSE
        -- Получаем информацию о последнем ремонте
        SELECT 
            c.CarBrand AS car_brand,
            c.GarageID AS garage_id,
            r.RepairDate AS repair_date,
            g.GarageName AS garage_name,
            r.RepairCost AS repair_cost
        INTO last_repair
        FROM Repairs r
        INNER JOIN Cars c ON c.CarID = r.CarID
        INNER JOIN Garages g ON g.GarageID = r.GarageID
        WHERE r.CarID = car_id
        ORDER BY r.RepairID DESC
        LIMIT 1;
        
        -- Если ремонтов не было
        IF last_repair IS NULL THEN
            RETURN 'Автомобиль "' || car_id || '" существует, но еще не ремонтировался.';
        ELSE
            -- Формируем строку с информацией
            result := 'Автомобиль: ' || last_repair.car_brand || 
                      ', Гараж: ' || last_repair.garage_name || 
                      ', Дата последнего ремонта: ' || last_repair.repair_date || 
                      ', Стоимость ремонта: ' || last_repair.repair_cost || ' руб.';
            RETURN result;
        END IF;
    END IF;
END;
$$ LANGUAGE plpgsql;


-- Примеры вызова функции
SELECT get_car_info(1); -- существует и ремонтировался
SELECT get_car_info(2); -- существует и ремонтировался
SELECT get_car_info(6); -- существует и не ремонтировался
SELECT get_car_info(999); -- не существует
