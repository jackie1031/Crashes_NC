# Procedures for:
# Input: city (drop down for user to select)
# output:
#       table 1: top 3 most frequent crash types, type count, total count for bike crashes in input city
#       table 2: top 3 most frequent crash types, type count, total count for pedestrian crashes in input city
#       table 3: legend, show crash types for both bike and pedestrian crashes

# table 1
DROP PROCEDURE IF EXISTS CrashTypeRate_Bike;
delimiter |
CREATE PROCEDURE CrashTypeRate_Bike(city VARCHAR(18))
BEGIN
SELECT BikeCrashResult.crash_type, COUNT(*) AS type_count, T.total_count
FROM BikeCrashResult, BikeCrashLoc,
(
	SELECT COUNT(*) as total_count
	FROM BikeCrashLoc as BL
	WHERE BL.city=city
) as T
WHERE BikeCrashResult.BikeCrashID=BikeCrashLoc.BikeCrashID AND BikeCrashLoc.city=city
GROUP BY crash_type
ORDER BY type_count DESC
LIMIT 3;
END|
delimiter ;

# table 2
DROP PROCEDURE IF EXISTS CrashTypeRate_Ped;
delimiter |
CREATE PROCEDURE CrashTypeRate_Ped(city VARCHAR(18))
BEGIN
SELECT PedCrashDetail.crash_type, COUNT(*) AS type_count, T.total_count
FROM PedCrashDetail,
(
	SELECT COUNT(*) as total_count
	FROM PedCrashDetail as P
	WHERE P.city=city
) as T
WHERE PedCrashDetail.city=city
GROUP BY crash_type
ORDER BY type_count DESC
LIMIT 3;
END|
delimiter ;

# table 3
DROP PROCEDURE IF EXISTS ShowCrashTypes_Comb;
delimiter |
CREATE PROCEDURE ShowCrashTypes_Comb()
BEGIN
	DECLARE Pcnt INT;
	DECLARE Bcnt INT;
	DECLARE dif INT;
	DECLARE i INT;
	DECLARE Pval VARCHAR(50);
	DECLARE Bval VARCHAR(62);

	DROP TABLE IF EXISTS PedCrashType;
	CREATE TABLE PedCrashType AS (SELECT DISTINCT crash_type AS Ped_crashtype FROM PedCrashDetail);
	DROP TABLE IF EXISTS BikeCrashType;
	CREATE TABLE BikeCrashType AS (SELECT DISTINCT crash_type AS Bike_crashtype FROM BikeCrashResult);
	ALTER TABLE PedCrashType ADD id INT NOT NULL AUTO_INCREMENT PRIMARY KEY;
	ALTER TABLE BikeCrashType ADD id INT NOT NULL AUTO_INCREMENT PRIMARY KEY;
	DROP TABLE IF EXISTS CrashType;
	CREATE TABLE CrashType AS (SELECT Ped_crashtype, Bike_crashtype FROM PedCrashType, BikeCrashType WHERE PedCrashType.id=BikeCrashType.id);

	SELECT COUNT(*) FROM PedCrashType INTO Pcnt;
	SELECT COUNT(*) FROM BikeCrashType INTO Bcnt;

	IF (Pcnt >= Bcnt) THEN
	SET dif=Pcnt-Bcnt;
	SET i=Bcnt+1;
	WHILE i<=Pcnt DO
	SELECT Ped_crashtype FROM PedCrashType WHERE id=i INTO Pval;
	INSERT INTO CrashType(Ped_crashtype, Bike_crashtype) VALUES (Pval, '');
	SET i=i+1;
	END WHILE;
	ELSE
	SET dif=Bcnt-Pcnt;
	SET i=Pcnt+1;
	WHILE i<=Bcnt DO
	SELECT Bike_crashtype FROM BikeCrashType WHERE id=i INTO Bval;
	INSERT INTO CrashType(Ped_crashtype, Bike_crashtype) VALUES ('', Bval);
	SET i=i+1;
	END WHILE;
	END IF;
	
	SELECT * FROM CrashType;
	DROP TABLE PedCrashType;
	DROP TABLE BikeCrashType;
	DROP TABLE CrashType;
END|
delimiter ;



# query 2 Procedure required for:
# Input: time range
DROP PROCEDURE IF EXISTS AccidentRate_Bike;
delimiter |
CREATE PROCEDURE AccidentRate_Bike(t_from NUMERIC(4,1), t_to NUMERIC(4,1))
BEGIN
	DECLARE time_from NUMERIC(4,1) DEFAULT 0.0;
	DECLARE time_to NUMERIC(4,1) DEFAULT 24.0;
	IF (t_from IS NOT NULL) THEN SET time_from=t_from;
	END IF;
	IF (t_to IS NOT NULL) THEN SET time_to=t_to;
	END IF;

	SELECT CrashC.crash_count, TotalC.total_count, CrashC.crash_count/TotalC.total_count*100 AS percentage, CrashC.city, Type.crash_type, Severity.crsh_sevri
	FROM
	(
	SELECT COUNT(*) AS crash_count, BikeCrashLoc.city
	FROM BikeCrashLoc, BikeCrashTime
	WHERE BikeCrashLoc.BikeCrashID=BikeCrashTime.BikeCrashID AND
	BikeCrashTime.crash_hour>=time_from AND BikeCrashTime.crash_hour<time_to
	GROUP BY BikeCrashLoc.city
	) AS CrashC,
	(
	SELECT COUNT(*) AS total_count
	FROM BikeCrashTime
	WHERE BikeCrashTime.crash_hour>=time_from AND BikeCrashTime.crash_hour<time_to
	) AS TotalC,
	(
	SELECT COUNT(*), city, crash_type
	FROM BikeCrashResult, BikeCrashLoc, BikeCrashTime
	WHERE BikeCrashResult.BikeCrashID=BikeCrashLoc.BikeCrashID AND BikeCrashLoc.BikeCrashID=BikeCrashTime.BikeCrashID
	AND BikeCrashTime.crash_hour>=time_from AND BikeCrashTime.crash_hour<time_to
	GROUP BY city, crash_type
	HAVING COUNT(*) >= ALL
	(
	SELECT COUNT(*)
	FROM BikeCrashResult AS Result, BikeCrashLoc AS L, BikeCrashTime AS T
	WHERE Result.BikeCrashID=L.BikeCrashID AND L.BikeCrashID=T.BikeCrashID AND
	T.crash_hour>=time_from AND T.crash_hour<time_to AND L.city=BikeCrashLoc.city
	GROUP BY city, crash_type
	)
	) AS Type,
	(
	SELECT COUNT(*), city, crsh_sevri
	FROM BikeCrashResult, BikeCrashLoc, BikeCrashTime
	WHERE BikeCrashResult.BikeCrashID=BikeCrashLoc.BikeCrashID AND BikeCrashLoc.BikeCrashID=BikeCrashTime.BikeCrashID
	AND BikeCrashTime.crash_hour>=time_from AND BikeCrashTime.crash_hour<time_to
	GROUP BY city, crsh_sevri
	HAVING COUNT(*) >= ALL
	(
	SELECT COUNT(*)
	FROM BikeCrashResult AS Result, BikeCrashLoc AS L, BikeCrashTime AS T
	WHERE Result.BikeCrashID=L.BikeCrashID AND L.BikeCrashID=T.BikeCrashID AND
	T.crash_hour>=time_from AND T.crash_hour<time_to AND L.city=BikeCrashLoc.city
	GROUP BY L.city, Result.crsh_sevri
	)
	) AS Severity
	WHERE Type.city=CrashC.city AND Severity.city=CrashC.city
	ORDER BY percentage DESC, city ASC;
END|
delimiter ;


DROP PROCEDURE IF EXISTS AccidentRate_Ped;
delimiter |
CREATE PROCEDURE AccidentRate_Ped(t_from NUMERIC(4,1), t_to NUMERIC(4,1))
BEGIN
	DECLARE time_from NUMERIC(4,1) DEFAULT 0.0;
	DECLARE time_to NUMERIC(4,1) DEFAULT 24.0;
	IF (t_from IS NOT NULL) THEN SET time_from=t_from;
	END IF;
	IF (t_to IS NOT NULL) THEN SET time_to=t_to;
	END IF;

	SELECT CrashC.crash_count, TotalC.total_count, CrashC.crash_count/TotalC.total_count*100 AS percentage, CrashC.city, Type.crash_type, Severity.crsh_sevri
	FROM
	(
	SELECT COUNT(*) AS crash_count, PedCrashDetail.city
	FROM PedCrashDetail
	WHERE PedCrashDetail.crash_hour>=time_from AND PedCrashDetail.crash_hour<time_to
	GROUP BY PedCrashDetail.city
	) AS CrashC,
	(
	SELECT COUNT(*) AS total_count
	FROM PedCrashDetail
	WHERE PedCrashDetail.crash_hour>=time_from AND PedCrashDetail.crash_hour<time_to
	) AS TotalC,
	(
	SELECT COUNT(*), PedCrashDetail.city, crash_type
	FROM PedCrashDetail, PedCrashRdCond
	WHERE PedCrashDetail.PedCrashID=PedCrashRdCond.PedCrashID
	AND PedCrashDetail.crash_hour>=time_from AND PedCrashDetail.crash_hour<time_to
	GROUP BY PedCrashDetail.city, crash_type
	HAVING COUNT(*) >= ALL
	(
	SELECT COUNT(*)
	FROM PedCrashDetail AS D, PedCrashRdCond AS R
	WHERE D.PedCrashID=R.PedCrashID AND
	D.crash_hour>=time_from AND D.crash_hour<time_to AND R.city=PedCrashDetail.city
	GROUP BY D.city, crash_type
	)
	) AS Type,
	(
	SELECT COUNT(*), PedCrashDetail.city, crsh_sevri
	FROM PedCrashDetail
	WHERE PedCrashDetail.crash_hour>=time_from AND PedCrashDetail.crash_hour<time_to
	GROUP BY PedCrashDetail.city, crsh_sevri
	HAVING COUNT(*) >= ALL
	(
	SELECT COUNT(*)
	FROM PedCrashDetail AS D
	WHERE D.crash_hour>=time_from AND D.crash_hour<time_to AND D.city=PedCrashDetail.city
	GROUP BY D.city, D.crsh_sevri
	)
	) AS Severity
	WHERE Type.city=CrashC.city AND Severity.city=CrashC.city
	ORDER BY percentage DESC, CrashC.city ASC;
END|
delimiter ;


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

# query 6
DROP PROCEDURE IF EXISTS ExceedSp_Bike;
delimiter |
CREATE PROCEDURE ExceedSp_Bike()
BEGIN
	SELECT COUNT(*)/T.total_count * 100 AS ExceedLim_percentage, 100 - COUNT(*)/T.total_count * 100 AS BelowLim_percentage
	FROM BikeCrashRdCond, Driver_BikeCrash,
	(
	SELECT COUNT(*) as total_count
	FROM BikeCrashRdCond
	) AS T
	WHERE BikeCrashRdCond.BikeCrashID=Driver_BikeCrash.BikeCrashID AND speed_limi<drvr_estsp;
END|
delimiter ;

DROP PROCEDURE IF EXISTS ExceedSp_Ped;
delimiter |
CREATE PROCEDURE ExceedSp_Ped()
BEGIN
	SELECT COUNT(*)/T.total_count * 100 AS ExceedLim_percentage, 100 - COUNT(*)/T.total_count * 100 AS BelowLim_percentage
	FROM DiverBiker_PedCrash,
	(
	SELECT COUNT(*) as total_count
	FROM DiverBiker_PedCrash
	) AS T
	WHERE speed_limi<drvr_estsp;
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



# query 8
DROP PROCEDURE IF EXISTS ShowInjuryTypes;
delimiter |
CREATE PROCEDURE ShowInjuryTypes()
BEGIN
	SELECT DISTINCT crsh_sevri
	FROM BikeCrashResult
	ORDER BY crsh_sevri ASC;
END|
delimiter ;

DROP PROCEDURE IF EXISTS Injury_Bike;
delimiter |
CREATE PROCEDURE Injury_Bike()
BEGIN
	DECLARE total_count INT;
	SELECT COUNT(*) FROM BikeCrashResult INTO total_count;
	SELECT crsh_sevri, COUNT(*)/total_count * 100 AS percentage
	FROM BikeCrashResult
	GROUP BY crsh_sevri
	HAVING percentage >= ALL
	(
	SELECT COUNT(*)/total_count * 100
	FROM BikeCrashResult AS B
	GROUP BY crsh_sevri
	);
END|
delimiter ;

DROP PROCEDURE IF EXISTS Injury_Ped;
delimiter |
CREATE PROCEDURE Injury_Ped()
BEGIN
	DECLARE total_count INT;
	SELECT COUNT(*) FROM PedCrashDetail INTO total_count;
	SELECT crsh_sevri, COUNT(*)/total_count * 100 AS percentage
	FROM PedCrashDetail
	GROUP BY crsh_sevri
	HAVING percentage >= ALL
	(
	SELECT COUNT(*)/total_count * 100
	FROM PedCrashDetail
	GROUP BY crsh_sevri
	);
END|
delimiter ;



# query 9
DROP PROCEDURE IF EXISTS AmbulanceSevri_Bike;
delimiter |
CREATE PROCEDURE AmbulanceSevri_Bike(t_from NUMERIC(4,1), t_to NUMERIC(4,1))
BEGIN
	DECLARE time_from NUMERIC(4,1) DEFAULT 0.0;
	DECLARE time_to NUMERIC(4,1) DEFAULT 24.0;
	IF (t_from IS NOT NULL) THEN SET time_from=t_from;
	END IF;
	IF (t_to IS NOT NULL) THEN SET time_to=t_to;
	END IF;

	SELECT ambulancer, crsh_sevri, COUNT(*) as count
	FROM BikeCrashResult AS BR, BikeCrashTime AS BT
	WHERE BR.BikeCrashID=BT.BikeCrashID AND BT.crash_hour >= time_from AND BT.crash_hour < time_to
	GROUP BY BR.ambulancer, BR.crsh_sevri
	HAVING count >= ALL
	(
	SELECT COUNT(*)
	FROM BikeCrashResult, BikeCrashTime
	WHERE BikeCrashResult.BikeCrashID=BikeCrashTime.BikeCrashID
	AND BikeCrashResult.ambulancer=BR.ambulancer AND BikeCrashTime.crash_hour >= time_from
	AND BikeCrashTime.crash_hour < time_to
	GROUP BY BikeCrashResult.crsh_sevri
	);

END|
delimiter ;

DROP PROCEDURE IF EXISTS AmbulanceSevri_Ped;
delimiter |
CREATE PROCEDURE AmbulanceSevri_Ped(t_from NUMERIC(4,1), t_to NUMERIC(4,1))
BEGIN
	DECLARE time_from NUMERIC(4,1) DEFAULT 0.0;
	DECLARE time_to NUMERIC(4,1) DEFAULT 24.0;
	IF (t_from IS NOT NULL) THEN SET time_from=t_from;
	END IF;
	IF (t_to IS NOT NULL) THEN SET time_to=t_to;
	END IF;

	SELECT ambulancer, crsh_sevri, COUNT(*) as count
	FROM PedCrashDetail AS PD
	WHERE PD.crash_hour >= time_from AND PD.crash_hour < time_to
	GROUP BY PD.ambulancer, PD.crsh_sevri
	HAVING count >= ALL
	(
	SELECT COUNT(*)
	FROM PedCrashDetail AS PD1
	WHERE PD1.ambulancer=PD.ambulancer AND PD1.crash_hour >= time_from
	AND PD1.crash_hour < time_to
	GROUP BY PD1.crsh_sevri
	);

END|
delimiter ;



# query 10
DROP PROCEDURE IF EXISTS AgeGpAccidentRate_Bike;
delimiter |
CREATE PROCEDURE AgeGpAccidentRate_Bike(age VARCHAR(7))
BEGIN
	IF (EXISTS (SELECT * FROM Biker WHERE bikeage_gr=age)) THEN
	SELECT C.count, Biker.bikeage_gr, bike_injur, bike_race, bike_dir, bike_sex, bike_pos, bike_alc_d
	FROM
	(
	SELECT COUNT(*) as count, B.bikeage_gr
	FROM Biker as B
	WHERE B.bikeage_gr=age
	) as C, Biker
	WHERE Biker.bikeage_gr=C.bikeage_gr AND Biker.bikeage_gr=age;
	END IF;
END|
delimiter ;

DROP PROCEDURE IF EXISTS AgeGpAccidentRate_Ped;
delimiter |
CREATE PROCEDURE AgeGpAccidentRate_Ped(age VARCHAR(7))
BEGIN
	IF (EXISTS (SELECT * FROM PedInjure WHERE pedage_grp=age)) THEN
	SELECT C.count, PedInjure.pedage_grp, ped_pos, ped_race, ped_injury, ped_sex
	FROM
	(
	SELECT COUNT(*) as count, P.pedage_grp
	FROM PedInjure as P
	WHERE P.pedage_grp=age
	) as C, PedInjure
	WHERE PedInjure.pedage_grp=C.pedage_grp AND PedInjure.pedage_grp=age;
	END IF;
END|
delimiter ;



# query 11
DROP PROCEDURE IF EXISTS HitRun_Bike;
delimiter |
CREATE PROCEDURE HitRun_Bike(t_from NUMERIC(4,1), t_to NUMERIC(4,1))
BEGIN
	DECLARE time_from NUMERIC(4,1) DEFAULT 0.0;
	DECLARE time_to NUMERIC(4,1) DEFAULT 24.0;
	IF (t_from IS NOT NULL) THEN SET time_from=t_from;
	END IF;
	IF (t_to IS NOT NULL) THEN SET time_to=t_to;
	END IF;

	SELECT HitC.hit_run, HitC.hit_count/TotalC.total_count*100 AS percentage, MaxCrashHour.weather
	FROM
	(
	SELECT COUNT(*) as hit_count, hit_run
	FROM BikeCrashResult, BikeCrashTime
	WHERE BikeCrashResult.BikeCrashID=BikeCrashTime.BikeCrashID AND
	BikeCrashTime.crash_hour>=time_from AND BikeCrashTime.crash_hour<time_to
	GROUP BY hit_run
	) AS HitC,
	(
	SELECT COUNT(*) as total_count
	FROM BikeCrashTime
	WHERE BikeCrashTime.crash_hour>=time_from AND BikeCrashTime.crash_hour<time_to
	) AS TotalC,
	(
	SELECT COUNT(*) as max_crash_hour, hit_run, weather
	FROM BikeCrashTime, BikeCrashRdCond, BikeCrashResult
	WHERE BikeCrashTime.BikeCrashID=BikeCrashRdCond.BikeCrashID AND
	BikeCrashResult.BikeCrashID=BikeCrashRdCond.BikeCrashID AND
	BikeCrashTime.crash_hour>=time_from AND BikeCrashTime.crash_hour<time_to
	GROUP BY hit_run, weather
	HAVING COUNT(*) >= ALL
	(
	SELECT COUNT(*)
	FROM BikeCrashTime as T, BikeCrashRdCond as R, BikeCrashResult as Result
	WHERE T.BikeCrashID=R.BikeCrashID AND
	R.BikeCrashID=Result.BikeCrashID AND
	T.crash_hour>=time_from AND T.crash_hour<time_to
	AND Result.hit_run=BikeCrashResult.hit_run
	GROUP BY hit_run, weather
	)
	) MaxCrashHour
	WHERE HitC.hit_run=MaxCrashHour.hit_run
	ORDER BY percentage DESC;
END|
delimiter ;


DROP PROCEDURE IF EXISTS HitRun_Ped;
delimiter |
CREATE PROCEDURE HitRun_Ped(t_from NUMERIC(4,1), t_to NUMERIC(4,1))
BEGIN
	DECLARE time_from NUMERIC(4,1) DEFAULT 0.0;
	DECLARE time_to NUMERIC(4,1) DEFAULT 24.0;
	IF (t_from IS NOT NULL) THEN SET time_from=t_from;
	END IF;
	IF (t_to IS NOT NULL) THEN SET time_to=t_to;
	END IF;

	SELECT HitC.hit_run, HitC.hit_count/TotalC.total_count*100 AS percentage, W.weather
	FROM
	(
	SELECT COUNT(*) as hit_count, hit_run
	FROM PedCrashDetail
	WHERE PedCrashDetail.crash_hour>=time_from AND PedCrashDetail.crash_hour<time_to
	GROUP BY hit_run
	) AS HitC,
	(
	SELECT COUNT(*) as total_count
	FROM PedCrashDetail
	WHERE PedCrashDetail.crash_hour>=time_from AND PedCrashDetail.crash_hour<time_to
	) AS TotalC,
	(
	SELECT COUNT(*) AS c, hit_run, weather
	FROM PedCrashDetail, PedCrashRdCond
	WHERE PedCrashRdCond.PedCrashID=PedCrashDetail.PedCrashID AND
	PedCrashDetail.crash_hour>=time_from AND PedCrashDetail.crash_hour<time_to
	GROUP BY hit_run, weather
	HAVING COUNT(*) >= ALL
	(
	SELECT COUNT(*)
	FROM PedCrashDetail AS D, PedCrashRdCond AS R
	WHERE D.PedCrashID=R.PedCrashID AND D.crash_hour>=time_from AND D.crash_hour<time_to
	AND D.hit_run=PedCrashDetail.hit_run
	GROUP BY hit_run, weather
	)
	) AS W
	WHERE HitC.hit_run=W.hit_run
	ORDER BY percentage DESC;
END|
delimiter ;

call HitRun_Ped(3,18);


# query 12
DROP PROCEDURE IF EXISTS LocAccidentRate_Bike;
delimiter |
CREATE PROCEDURE LocAccidentRate_Bike(loc VARCHAR(5))
BEGIN
	DECLARE total_count INT;
	SELECT COUNT(*) FROM BikeCrashLoc INTO total_count;
	SELECT P.percentage, A.drvr_alc_d, S.crsh_sevri
	FROM
	(
	SELECT COUNT(*)/total_count*100 AS percentage, rural_urba
	FROM BikeCrashLoc as L
	WHERE rural_urba=loc
	) as P,
	(
	SELECT COUNT(*), rural_urba, drvr_alc_d
	FROM BikeCrashLoc, Driver_BikeCrash
	WHERE BikeCrashLoc.BikeCrashID=Driver_BikeCrash.BikeCrashID
	GROUP BY rural_urba, drvr_alc_d
	HAVING COUNT(*) >= ALL
	(
	SELECT COUNT(*)
	FROM BikeCrashLoc AS L, Driver_BikeCrash AS D
	WHERE L.BikeCrashID=D.BikeCrashID AND L.rural_urba=BikeCrashLoc.rural_urba
	GROUP BY rural_urba, drvr_alc_d
	)
	) AS A,
	(
	SELECT COUNT(*), rural_urba, crsh_sevri
	FROM BikeCrashLoc, BikeCrashResult
	WHERE BikeCrashLoc.BikeCrashID=BikeCrashResult.BikeCrashID
	GROUP BY rural_urba, crsh_sevri
	HAVING COUNT(*) >= ALL
	(
	SELECT COUNT(*)
	FROM BikeCrashLoc AS L, BikeCrashResult AS R
	WHERE L.BikeCrashID=R.BikeCrashID AND L.rural_urba=BikeCrashLoc.rural_urba
	GROUP BY rural_urba, crsh_sevri
	)
	) AS S
	WHERE P.rural_urba=A.rural_urba AND P.rural_urba=S.rural_urba;
END|
delimiter ;


DROP PROCEDURE IF EXISTS LocAccidentRate_Ped;
delimiter |
CREATE PROCEDURE LocAccidentRate_Ped(loc VARCHAR(5))
BEGIN
	DECLARE total_count INT;
	SELECT COUNT(*) FROM PedCrashRdCond INTO total_count;
	SELECT P.percentage, A.drvr_alc_d, S.crsh_sevri
	FROM
	(
	SELECT COUNT(*)/total_count*100 AS percentage, rural_urba
	FROM PedCrashRdCond
	WHERE rural_urba=loc
	) AS P,
	(
	SELECT COUNT(*), rural_urba, drvr_alc_d
	FROM PedCrashRdCond, DiverBiker_PedCrash
	WHERE PedCrashRdCond.PedCrashID=DiverBiker_PedCrash.PedCrashID
	GROUP BY rural_urba, drvr_alc_d
	HAVING COUNT(*) >= ALL
	(
	SELECT COUNT(*)
	FROM PedCrashRdCond AS R, DiverBiker_PedCrash AS D
	WHERE R.PedCrashID=D.PedCrashID AND R.rural_urba=PedCrashRdCond.rural_urba
	GROUP BY rural_urba, drvr_alc_d
	)
	) AS A,
	(
	SELECT COUNT(*), rural_urba, crsh_sevri
	FROM PedCrashRdCond, PedCrashDetail
	WHERE PedCrashRdCond.PedCrashID=PedCrashDetail.PedCrashID
	GROUP BY rural_urba, crsh_sevri
	HAVING COUNT(*) >= ALL
	(
	SELECT COUNT(*)
	FROM PedCrashRdCond AS R, PedCrashDetail AS D
	WHERE R.PedCrashID=D.PedCrashID AND R.rural_urba=PedCrashRdCond.rural_urba
	GROUP BY rural_urba, crsh_sevri
	)
	) AS S
	WHERE P.rural_urba=A.rural_urba AND P.rural_urba=S.rural_urba;
END|
delimiter ;


# query 13
DROP PROCEDURE IF EXISTS DriverInfo;
delimiter |
CREATE PROCEDURE DriverInfo(type VARCHAR(10))
BEGIN
	IF (type="pedestrian") THEN
	SELECT *
	FROM
	(
	SELECT "Total" AS type, COUNT(*) AS count
	FROM DiverBiker_PedCrash
	UNION
	SELECT drvr_sex AS type, COUNT(*) AS count
	FROM DiverBiker_PedCrash
	GROUP BY drvr_sex
	UNION
	SELECT drvr_race AS type, COUNT(*) AS count
	FROM DiverBiker_PedCrash
	GROUP BY drvr_race 
	UNION
	SELECT drvrage_gr AS type, COUNT(*) AS count
	FROM DiverBiker_PedCrash
	GROUP BY drvrage_gr
	UNION
	SELECT crash_type AS type, COUNT(*) AS count
	FROM PedCrashDetail
	GROUP BY crash_type
	UNION
	SELECT crsh_sevri AS type, COUNT(*) AS count
	FROM PedCrashDetail
	GROUP BY crsh_sevri
	) AS P;
	ELSEIF (type="bike") THEN
	SELECT *
	FROM
	(
	SELECT "Total" AS type, COUNT(*) AS count
	FROM Driver_BikeCrash
	UNION
	SELECT drvr_sex AS type, COUNT(*) AS count
	FROM Driver_BikeCrash
	GROUP BY drvr_sex
	UNION
	SELECT drvr_race AS type, COUNT(*) AS count
	FROM Driver_BikeCrash
	GROUP BY drvr_race 
	UNION
	SELECT drvrage_gr AS type, COUNT(*) AS count
	FROM Driver_BikeCrash
	GROUP BY drvrage_gr
	UNION
	SELECT crash_type AS type, COUNT(*) AS count
	FROM BikeCrashResult
	GROUP BY crash_type
	UNION
	SELECT crsh_sevri AS type, COUNT(*) AS count
	FROM BikeCrashResult
	GROUP BY crsh_sevri
	) AS P;
	END IF;
END|
delimiter ;

call Driver_Info("bike");

# query 14
DROP PROCEDURE IF EXISTS IntersectAccidentRate;
delimiter |
CREATE PROCEDURE IntersectAccidentRate()
BEGIN
	DECLARE total_count INT;

	DROP TABLE IF EXISTS InterBike;
	CREATE TABLE InterBike AS
	(
	SELECT crash_loc, weather, light_cond
	FROM BikeCrashLoc AS BL, BikeCrashRdCond AS BR
	WHERE BL.BikeCrashID=BR.BikeCrashID
	);
	DROP TABLE IF EXISTS InterPed;
	CREATE TABLE InterPed AS
	(
	SELECT crash_loc, weather, light_cond
	FROM PedCrashRdCond AS PR, PedCrashDetail AS PD
	WHERE PR.PedCrashID=PD.PedCrashID
	);
	DROP TABLE IF EXISTS Inter;
	CREATE TABLE Inter AS
	(
	SELECT * FROM (SELECT * FROM InterBike UNION ALL SELECT * FROM InterPed) AS U
	);

	SELECT COUNT(*) FROM Inter INTO total_count;

	SELECT P.crash_loc, P.percentage, W.weather, L.light_cond
	FROM
	(
	SELECT crash_loc, COUNT(*)/total_count*100 AS percentage
	FROM Inter AS I
	GROUP BY crash_loc
	) AS P,
	(
	SELECT COUNT(*), crash_loc, weather
	FROM Inter
	GROUP BY crash_loc, weather
	HAVING COUNT(*) >= ALL
	(
	SELECT COUNT(*)
	FROM Inter AS I
	WHERE I.crash_loc=Inter.crash_loc
	GROUP BY I.crash_loc, I.weather
	)
	) AS W,
	(
	SELECT COUNT(*), crash_loc, light_cond
	FROM Inter
	GROUP BY crash_loc, light_cond
	HAVING COUNT(*) >= ALL
	(
	SELECT COUNT(*)
	FROM Inter AS I
	WHERE I.crash_loc=Inter.crash_loc
	GROUP BY I.crash_loc, I.light_cond
	)
	) AS L
	WHERE P.crash_loc=W.crash_loc AND P.crash_loc=L.crash_loc
	ORDER BY P.percentage DESC;

	DROP TABLE InterBike;
	DROP TABLE InterPed;
	DROP TABLE Inter;
END |
delimiter ;


# query 15
DROP PROCEDURE IF EXISTS Traffic_Bike;
delimiter |
CREATE PROCEDURE Traffic_Bike()
BEGIN
	SELECT TrafficC.traff_cntr, TrafficC.traff_count/TotalC.total_count*100 AS TrafficControlRate, Severity.crsh_sevri, Lanes.num_lanes
	FROM
	(
	SELECT COUNT(*) AS traff_count, traff_cntr
	FROM BikeCrashRdCond
	GROUP BY traff_cntr
	) AS TrafficC,
	(
	SELECT COUNT(*) AS total_count
	FROM BikeCrashRdCond
	) AS TotalC,
	(
	SELECT COUNT(*), traff_cntr, crsh_sevri
	FROM BikeCrashRdCond, BikeCrashResult
	WHERE BikeCrashRdCond.BikeCrashID=BikeCrashResult.BikeCrashID
	GROUP BY traff_cntr, crsh_sevri
	HAVING COUNT(*) >= ALL
	(
	SELECT COUNT(*)
	FROM BikeCrashRdCond AS R, BikeCrashResult AS Result
	WHERE R.BikeCrashID=Result.BikeCrashID AND R.traff_cntr=BikeCrashRdCond.traff_cntr
	GROUP BY traff_cntr, crsh_sevri
	)
	) AS Severity,
	(
	SELECT COUNT(*), traff_cntr, num_lanes
	FROM BikeCrashRdCond
	GROUP BY traff_cntr, num_lanes
	HAVING COUNT(*) >= ALL
	(
	SELECT COUNT(*)
	FROM BikeCrashRdCond AS R
	WHERE R.traff_cntr=BikeCrashRdCond.traff_cntr
	GROUP BY traff_cntr, num_lanes
	)
	) AS Lanes
	WHERE Severity.traff_cntr=TrafficC.traff_cntr AND Lanes.traff_cntr=TrafficC.traff_cntr
	ORDER BY TrafficControlRate DESC, TrafficC.traff_cntr ASC;
END|
delimiter ;


DROP PROCEDURE IF EXISTS Traffic_Ped;
delimiter |
CREATE PROCEDURE Traffic_Ped()
BEGIN
	SELECT TrafficC.traff_cntr, TrafficC.traff_count/TotalC.total_count*100 AS TrafficControlRate, Severity.crsh_sevri, Lanes.num_lanes
	FROM
	(
	SELECT COUNT(*) AS traff_count, traff_cntr
	FROM PedCrashRdCond
	GROUP BY traff_cntr
	) AS TrafficC,
	(
	SELECT COUNT(*) AS total_count
	FROM PedCrashRdCond
	) AS TotalC,
	(
	SELECT COUNT(*), traff_cntr, crsh_sevri
	FROM PedCrashRdCond, PedCrashDetail
	WHERE PedCrashRdCond.PedCrashID=PedCrashDetail.PedCrashID
	GROUP BY traff_cntr, crsh_sevri
	HAVING COUNT(*) >= ALL
	(
	SELECT COUNT(*)
	FROM PedCrashRdCond AS R, PedCrashDetail AS D
	WHERE R.PedCrashID=D.PedCrashID AND R.traff_cntr=PedCrashRdCond.traff_cntr
	GROUP BY traff_cntr, crsh_sevri
	)
	) AS Severity,
	(
	SELECT COUNT(*), traff_cntr, num_lanes
	FROM PedCrashRdCond
	GROUP BY traff_cntr, num_lanes
	HAVING COUNT(*) >= ALL
	(
	SELECT COUNT(*)
	FROM PedCrashRdCond AS R
	WHERE R.traff_cntr=PedCrashRdCond.traff_cntr
	GROUP BY traff_cntr, num_lanes
	)
	) AS Lanes
	WHERE TrafficC.traff_cntr=Lanes.traff_cntr AND TrafficC.traff_cntr=Severity.traff_cntr
	ORDER BY TrafficControlRate DESC, TrafficC.traff_cntr ASC;
END|
delimiter ;