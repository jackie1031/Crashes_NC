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

	SELECT CrashC.crash_count, TotalC.total_count, CrashC.crash_count/TotalC.total_count*100 AS percentage, L.city, R.crash_type, R.crsh_sevri
	FROM BikeCrashTime AS T, BikeCrashResult AS R, BikeCrashLoc AS L,
	(
	SELECT COUNT(*) AS crash_count, BikeCrashLoc.city
	FROM BikeCrashLoc, BikeCrashTime
	WHERE BikeCrashLoc.BikeCrashID=BikeCrashTime.BikeCrashID AND
	BikeCrashTime.crash_hour>=time_from AND BikeCrashTime.crash_hour<time_to
	GROUP BY BikeCrashLoc.city
	) AS CrashC,
	(
	SELECT COUNT(*) AS total_count, BikeCrashLoc.city
	FROM BikeCrashLoc
	GROUP BY BikeCrashLoc.city
	) AS TotalC
	WHERE T.BikeCrashID=R.BikeCrashID AND R.BikeCrashID=L.BikeCrashID AND
	T.crash_hour>=time_from AND T.crash_hour<time_to AND CrashC.city=TotalC.city
	AND L.city=CrashC.city
	ORDER BY percentage DESC;
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

	SELECT CrashC.crash_count, TotalC.total_count, CrashC.crash_count/TotalC.total_count*100 AS percentage, R.city, R.crash_type, R.crsh_sevri
	FROM PedCrashDetail AS R,
	(
	SELECT COUNT(*) AS crash_count, PedCrashDetail.city
	FROM PedCrashDetail
	WHERE PedCrashDetail.crash_hour>=time_from AND PedCrashDetail.crash_hour<time_to
	GROUP BY PedCrashDetail.city
	) AS CrashC,
	(
	SELECT COUNT(*) AS total_count, PedCrashDetail.city
	FROM PedCrashDetail
	GROUP BY PedCrashDetail.city
	) AS TotalC
	WHERE R.crash_hour>=time_from AND R.crash_hour<time_to AND CrashC.city=TotalC.city
	AND R.city=CrashC.city
	ORDER BY percentage DESC;
END|
delimiter ;

call AccidentRate_Ped(2.0, 10.0);



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

call AgeGpAccidentRate_Ped("25-29");



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

	SELECT Result.hit_run, HitC.hit_count/TotalC.total_count*100 AS percentage, T.crash_hour, R.weather
	FROM BikeCrashResult AS Result, BikeCrashTime AS T, BikeCrashRdCond AS R,
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
	) AS TotalC
	WHERE Result.BikeCrashID=T.BikeCrashID AND T.BikeCrashID=R.BikeCrashID AND
	T.crash_hour>=time_from AND T.crash_hour<time_to AND HitC.hit_run=Result.hit_run
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

	SELECT D.hit_run, HitC.hit_count/TotalC.total_count*100 AS percentage, D.crash_hour, R.weather
	FROM PedCrashRdCond AS R, PedCrashDetail AS D,
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
	) AS TotalC
	WHERE R.PedCrashID=D.PedCrashID AND
	D.crash_hour>=time_from AND D.crash_hour<time_to AND HitC.hit_run=D.hit_run
	ORDER BY percentage DESC;
END|
delimiter ;

call HitRun_Ped(2.0, 17.0);




# query 12
DROP PROCEDURE IF EXISTS LocAccidentRate_Bike;
delimiter |
CREATE PROCEDURE LocAccidentRate_Bike(loc VARCHAR(5))
BEGIN
	DECLARE total_count INT;
	SELECT COUNT(*) FROM BikeCrashLoc INTO total_count;
	IF (EXISTS (SELECT * FROM BikeCrashLoc WHERE rural_urba=loc)) THEN
	SELECT P.percentage, hit_run, drvr_alc_d, weather, crsh_sevri
	FROM BikeCrashLoc AS BL, BikeCrashRdCond AS BC, BikeCrashResult AS BR, Driver_BikeCrash AS D,
	(
	SELECT COUNT(*)/total_count*100 AS percentage
	FROM BikeCrashLoc as L
	WHERE rural_urba=loc
	) as P
	WHERE BL.BikeCrashID=BC.BikeCrashID AND BC.BikeCrashID=BR.BikeCrashID AND BR.BikeCrashID=D.BikeCrashID AND
	BL.rural_urba=loc;
	END IF;
END|
delimiter ;

DROP PROCEDURE IF EXISTS LocAccidentRate_Ped;
delimiter |
CREATE PROCEDURE LocAccidentRate_Ped(loc VARCHAR(5))
BEGIN
	DECLARE total_count INT;
	SELECT COUNT(*) FROM PedCrashRdCond INTO total_count;
	IF (EXISTS (SELECT * FROM PedCrashRdCond WHERE rural_urba=loc)) THEN
	SELECT P.percentage, PD.hit_run, drvr_alc_d, weather, crsh_sevri
	FROM PedCrashRdCond AS PR, ReasonPed AS R, PedCrashDetail AS PD, DiverBiker_PedCrash As D,
	(
	SELECT COUNT(*)/total_count*100 AS percentage
	FROM PedCrashRdCond
	WHERE PedCrashRdCond.rural_urba=loc
	) as P
	WHERE PR.PedCrashID=R.PedCrashID AND R.PedCrashID=PD.PedCrashID AND PD.PedCrashID=D.PedCrashID
	AND PR.rural_urba=loc;
	END IF;
END|
delimiter ;




# query 13
DROP PROCEDURE IF EXISTS DriverInfo;
delimiter |
CREATE PROCEDURE DriverInfo(type VARCHAR(10))
BEGIN
	IF (type="Pedestrian") THEN
	SELECT drvr_sex, drvr_age, drvr_vehty, D.drvr_injur, crash_type
	FROM DiverBiker_PedCrash AS D, PedCrashDetail AS Detail
	WHERE D.PedCrashID=Detail.PedCrashID;
	ELSEIF (type="Bike") THEN
	SELECT drvr_sex, drvr_age, drvr_vehty, D.drvr_injur, crash_type
	FROM Driver_BikeCrash AS D, BikeCrashResult AS R
	WHERE D.BikeCrashID=R.BikeCrashID;
	END IF;
END|
delimiter ;



# query 14
DROP PROCEDURE IF EXISTS IntersectAccidentRate;
delimiter |
CREATE PROCEDURE IntersectAccidentRate()
BEGIN
	DECLARE total_count INT;

	DROP TABLE IF EXISTS InterBike;
	CREATE TABLE InterBike AS
	(
	SELECT crash_loc, crsh_sevri, weather, light_cond, num_lanes
	FROM BikeCrashLoc AS BL, BikeCrashRdCond AS BR, BikeCrashResult AS R
	WHERE BL.BikeCrashID=BR.BikeCrashID AND BR.BikeCrashID=R.BikeCrashID
	);
	DROP TABLE IF EXISTS InterPed;
	CREATE TABLE InterPed AS
	(
	SELECT crash_loc, crsh_sevri, weather, light_cond, num_lanes
	FROM PedCrashRdCond AS PR, PedCrashDetail AS PD
	WHERE PR.PedCrashID=PD.PedCrashID
	);
	DROP TABLE IF EXISTS Inter;
	CREATE TABLE Inter AS
	(
	SELECT * FROM (SELECT * FROM InterBike UNION ALL SELECT * FROM InterPed) AS U
	);

	SELECT COUNT(*) FROM Inter INTO total_count;

	SELECT Inter.crash_loc, P.percentage, Inter.crsh_sevri, Inter.weather, Inter.light_cond, Inter.num_lanes
	FROM Inter,
	(
	SELECT crash_loc, COUNT(*)/total_count*100 AS percentage
	FROM Inter AS I
	GROUP BY crash_loc
	) AS P
	WHERE Inter.crash_loc=P.crash_loc
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
	SELECT R.traff_cntr, TrafficC.traff_count/TotalC.total_count*100 AS TrafficControlRate, Result.crsh_sevri, weather, light_cond, num_lanes
	FROM BikeCrashRdCond AS R, BikeCrashResult AS Result,
	(
	SELECT COUNT(*) AS traff_count, traff_cntr
	FROM BikeCrashRdCond
	GROUP BY traff_cntr
	) AS TrafficC,
	(
	SELECT COUNT(*) AS total_count
	FROM BikeCrashRdCond
	) AS TotalC
	WHERE R.BikeCrashID=Result.BikeCrashID AND TrafficC.traff_cntr=R.traff_cntr
	ORDER BY TrafficControlRate DESC;
END|
delimiter ;

DROP PROCEDURE IF EXISTS Traffic_Ped;
delimiter |
CREATE PROCEDURE Traffic_Ped()
BEGIN
	SELECT R.traff_cntr, TrafficC.traff_count/TotalC.total_count*100 AS TrafficControlRate, D.crsh_sevri, weather, light_cond, num_lanes
	FROM PedCrashRdCond AS R, PedCrashDetail AS D,
	(
	SELECT COUNT(*) AS traff_count, traff_cntr
	FROM PedCrashRdCond
	GROUP BY traff_cntr
	) AS TrafficC,
	(
	SELECT COUNT(*) AS total_count
	FROM PedCrashRdCond
	) AS TotalC
	WHERE R.PedCrashID=D.PedCrashID AND TrafficC.traff_cntr=R.traff_cntr
	ORDER BY TrafficControlRate DESC;
END|
delimiter ;