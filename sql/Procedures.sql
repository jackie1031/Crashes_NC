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

# table 2
DROP PROCEDURE IF EXISTS CrashTypeRate_Ped;
delimiter |
CREATE PROCEDURE CrashTypeRate_Ped(city VARCHAR(18))
BEGIN
SELECT PedestrianCrash.crash_type, COUNT(*) AS type_count, T.total_count
FROM PedestrianCrash,
(
	SELECT COUNT(*) as total_count
	FROM PedestrianCrash as P
	WHERE P.city=city
) as T
WHERE PedestrianCrash.city=city
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
	CREATE TABLE PedCrashType AS (SELECT DISTINCT crash_type AS Ped_crashtype FROM PedestrianCrash);
	DROP TABLE IF EXISTS BikeCrashType;
	CREATE TABLE BikeCrashType AS (SELECT DISTINCT crash_type AS Bike_crashtype FROM BikeCrash);
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



# Procedure required for:
# Input: time range
DROP PROCEDURE IF EXISTS AccidentRate_Bike;
delimiter |
CREATE PROCEDURE AccidentRate_Bike(t_from NUMERIC(4,1), t_to NUMERIC(4,1))
BEGIN
	DECLARE time_from NUMERIC(4,1);
	DECLARE time_to NUMERIC(4,1);
	IF (t_from IS NOT NULL) THEN SET time_from=t_from;
	ELSEIF (t_from IS NULL) THEN SET time_from=0.0;
	ELSEIF (t_to IS NOT NULL) THEN SET time_to = t_to;
	ELSEIF (t_to IS NULL) THEN SET time_to = 24.0;
	END IF;
	SELECT COUNT(*) AS 
END|
delimiter ;