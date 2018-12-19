DROP PROCEDURE IF EXISTS CrashTypeRate_Bike;
delimiter |
CREATE PROCEDURE CrashTypeRate_Bike(city VARCHAR(18))
BEGIN
SELECT BikeCrash.crash_type, COUNT(*) AS type_count, T.total_count
FROM BikeCrash,
(
 SELECT COUNT(*) as total_count
 FROM BikeCrash as B
 WHERE B.city=city
) as T
WHERE BikeCrash.city=city
GROUP BY crash_type
ORDER BY type_count DESC
LIMIT 3;
END|
delimiter ;