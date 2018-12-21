
# question #3
-- Does light condition correlate with bicycle/pedestrian crash rate?
-- input:condition
-- output: both table with columns of: type of light condition && 
-- corresponding # of crashes, % of light condition = && crash most frequent severity


DROP PROCEDURE IF EXISTS light_bike;
delimiter |
CREATE PROCEDURE light_bike( )
BEGIN
SELECT BikeCrashRdCond.light_cond, COUNT(*) AS type_count, COUNT(*)/T.total_count*100 as percentage, 
sevei_temp.crsh_sevri as most_frequent_severity
FROM BikeCrashRdCond,
(
 SELECT COUNT(*) as total_count
 FROM BikeCrashRdCond as B
) as T,
(
 SELECT count(*) as most_count, crsh_sevri, light_cond
 FROM BikeCrashRdCond, BikeCrashResult
 WHERE BikeCrashRdCond.BikeCrashID = BikeCrashResult.BikeCrashID
 GROUP BY light_cond,crsh_sevri
 HAVING COUNT(*) >= ALL(
 	 select count(*) 
	 FROM BikeCrashRdCond, BikeCrashResult
	 WHERE BikeCrashRdCond.BikeCrashID = BikeCrashResult.BikeCrashID
	 GROUP BY light_cond,crsh_sevri
 	)
 ) as sevei_temp
GROUP BY light_cond
ORDER BY type_count DESC;
END|
delimiter ;

DROP PROCEDURE IF EXISTS light_ped;
delimiter |
CREATE PROCEDURE light_ped( )
BEGIN
SELECT PedCrashRdCond.light_cond, COUNT(*) AS type_count, COUNT(*)/T.total_count*100 as percentage, 
sevei_temp.crsh_sevri as most_frequent_severity
FROM PedCrashRdCond,
(
 SELECT COUNT(*) as total_count
 FROM PedCrashRdCond as B
) as T,
(
 SELECT count(*) as most_count, crsh_sevri, light_cond
 FROM PedCrashRdCond, PedCrashDetail
 WHERE PedCrashRdCond.PedCrashID = PedCrashDetail.PedCrashID
 GROUP BY light_cond,crsh_sevri
 HAVING COUNT(*) >= ALL(
 	 select count(*) 
	 FROM PedCrashRdCond, PedCrashDetail
	 WHERE PedCrashRdCond.PedCrashID = PedCrashDetail.PedCrashID
	 GROUP BY light_cond,crsh_sevri
 	)
 ) as sevei_temp
GROUP BY light_cond
ORDER BY type_count DESC;
END|
delimiter ;


#4
-- Does road surface correlated with bicycle/pedestrian crash rate?
-- input:
-- output: road surface type, count of crash, weather, severity


DROP PROCEDURE IF EXISTS road_charact_bike;
delimiter |
CREATE PROCEDURE road_charact_bike( )
BEGIN
SELECT BikeCrashRdCond.rd_surface, COUNT(*) AS type_count, COUNT(*)/T.total_count*100 as percentage, 
sevei_temp.crsh_sevri as most_frequent_severity, weather_temp.weather AS most_frequent_weather
FROM BikeCrashRdCond,
(
 SELECT COUNT(*) as total_count
 FROM BikeCrashRdCond as B
) as T,
(
 SELECT count(*) as most_count, crsh_sevri, rd_surface
 FROM BikeCrashRdCond, BikeCrashResult
 WHERE BikeCrashRdCond.BikeCrashID = BikeCrashResult.BikeCrashID
 GROUP BY rd_surface,crsh_sevri
 HAVING COUNT(*) >= ALL(
 	 select count(*) 
	 FROM BikeCrashRdCond, BikeCrashResult
	 WHERE BikeCrashRdCond.BikeCrashID = BikeCrashResult.BikeCrashID
	 GROUP BY rd_surface,crsh_sevri
 	)
 ) as sevei_temp,
(
 SELECT count(*) as most_count, weather, rd_surface
 FROM BikeCrashRdCond, BikeCrashResult
 WHERE BikeCrashRdCond.BikeCrashID = BikeCrashResult.BikeCrashID
 GROUP BY rd_surface,weather
 HAVING COUNT(*) >= ALL(
 	 select count(*) 
	 FROM BikeCrashRdCond, BikeCrashResult
	 WHERE BikeCrashRdCond.BikeCrashID = BikeCrashResult.BikeCrashID
	 GROUP BY rd_surface,weather
 	)
 ) as weather_temp
GROUP BY rd_surface
ORDER BY type_count DESC;
END|
delimiter ;

DROP PROCEDURE IF EXISTS road_charact_ped;
delimiter |
CREATE PROCEDURE road_charact_ped( )
BEGIN
SELECT PedCrashRdCond.rd_surface, COUNT(*) AS type_count, COUNT(*)/T.total_count*100 as percentage, 
sevei_temp.crsh_sevri as most_frequent_severity, weather_temp.weather AS most_frequent_weather
FROM PedCrashRdCond,
(
 SELECT COUNT(*) as total_count
 FROM PedCrashRdCond as B
) as T,
(
 SELECT count(*) as most_count, crsh_sevri, rd_surface
 FROM PedCrashRdCond, PedCrashDetail
 WHERE PedCrashRdCond.PedCrashID = PedCrashDetail.PedCrashID
 GROUP BY rd_surface,crsh_sevri
 HAVING COUNT(*) >= ALL(
 	 select count(*) 
	 FROM PedCrashRdCond, PedCrashDetail
	 WHERE PedCrashRdCond.PedCrashID = PedCrashDetail.PedCrashID
	 GROUP BY rd_surface,crsh_sevri
 	)
 ) as sevei_temp,
(
 SELECT count(*) as most_count, weather, rd_surface
 FROM PedCrashRdCond, PedCrashDetail
 WHERE PedCrashRdCond.PedCrashID = PedCrashDetail.PedCrashID
 GROUP BY rd_surface,weather
 HAVING COUNT(*) >= ALL(
 	 select count(*) 
	 FROM PedCrashRdCond, PedCrashDetail
	 WHERE PedCrashRdCond.PedCrashID = PedCrashDetail.PedCrashID
	 GROUP BY rd_surface,weather
 	)
 ) as weather_temp
GROUP BY rd_surface
ORDER BY type_count DESC;
END|
delimiter ;

#5
-- Does weather correlated with bicycle/pedestrian crash rate?
-- input:
-- output: type of weather & # of crashes, several frequent month…

DROP PROCEDURE IF EXISTS weather_bike;
delimiter |
CREATE PROCEDURE weather_bike( )
BEGIN
SELECT BikeCrashRdCond.weather, COUNT(*) AS type_count, COUNT(*)/T.total_count*100 as percentage, 
sevei_temp.crsh_sevri as most_frequent_severity
FROM BikeCrashRdCond,
(
 SELECT COUNT(*) as total_count
 FROM BikeCrashRdCond as B
) as T,
(
 SELECT count(*) as most_count, crsh_sevri, weather
 FROM BikeCrashRdCond, BikeCrashResult
 WHERE BikeCrashRdCond.BikeCrashID = BikeCrashResult.BikeCrashID
 GROUP BY weather,crsh_sevri
 HAVING COUNT(*) >= ALL(
	 SELECT count(*)
	 FROM BikeCrashRdCond, BikeCrashResult
	 WHERE BikeCrashRdCond.BikeCrashID = BikeCrashResult.BikeCrashID
	 GROUP BY weather,crsh_sevri
 	)
 ) as sevei_temp
GROUP BY weather
ORDER BY type_count DESC;
END|
delimiter ;

DROP PROCEDURE IF EXISTS weather_ped;
delimiter |
CREATE PROCEDURE weather_ped( )
BEGIN
SELECT PedCrashRdCond.weather, COUNT(*) AS type_count, COUNT(*)/T.total_count*100 as percentage, 
sevei_temp.crsh_sevri as most_frequent_severity
FROM PedCrashRdCond,
(
 SELECT COUNT(*) as total_count
 FROM PedCrashRdCond as B
) as T,
(
 SELECT crsh_sevri, weather
 FROM PedCrashRdCond, PedCrashDetail
 WHERE PedCrashRdCond.PedCrashID = PedCrashDetail.PedCrashID
 GROUP BY weather
 ORDER BY count(*) DESC
) as sevei_temp
WHERE sevei_temp.weather = PedCrashRdCond.weather
GROUP BY weather
ORDER BY type_count DESC;
END|
delimiter ;

#7
-- For bicycle crashes, what’s the percentage where the Drivers have Alcohol Detected?
-- input:
-- output: percentage of alco/all for biker, percentage of alco/all for driver, time of the day

DROP PROCEDURE IF EXISTS alcohol_bike;
delimiter |
CREATE PROCEDURE alcohol_bike( )
BEGIN
SELECT BikeCrashReason.drvr_alc_d,  COUNT(*) AS type_count,
COUNT(*)/driver_alco.total_count_dri * 100 as driver_drink_percentage, time_of_day.hour as the_hour
FROM BikeCrashReason,
(
 SELECT COUNT(*) as total_count_dri
 FROM BikeCrashReason
 where BikeCrashReason.drvr_alc_d != "Missing"
) as driver_alco,
(
 SELECT drvr_alc_d, BikeCrashTime.crash_hour as hour
 FROM BikeCrashReason, BikeCrashTime
 WHERE BikeCrashReason.BikeCrashID = BikeCrashTime.BikeCrashID
 GROUP BY BikeCrashReason.drvr_alc_d
 ORDER BY count(*) DESC
) as time_of_day
WHERE time_of_day.drvr_alc_d = BikeCrashReason.drvr_alc_d
GROUP BY BikeCrashReason.drvr_alc_d
ORDER BY type_count DESC;
END|
delimiter ;


