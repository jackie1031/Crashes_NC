# Divide BikeCrash table into smaller tables
DROP PROCEDURE IF EXISTS DivideBikeCrashTable;
delimiter |
CREATE PROCEDURE DivideBikeCrashTable()
BEGIN
  DROP TABLE IF EXISTS BikeCrashTime;
  CREATE TABLE BikeCrashTime AS
  SELECT BikeCrashID, crash_time, crash_hour, crashday, crash_mont, crash_year
  FROM BikeCrash;

  DROP TABLE IF EXISTS BikeCrashLoc;
  CREATE TABLE BikeCrashLoc AS
  SELECT BikeCrashID, lat, lon, county, city, rural_urba, crash_loc, developmen
  FROM BikeCrash;

  DROP TABLE IF EXISTS BikeCrashRdCond;
  CREATE TABLE BikeCrashRdCond AS
  SELECT BikeCrashID, rd_defects, rd_feature, rd_charact, rd_surface, rd_conditi, speed_limi, traff_cntr, weather, rd_config, num_lanes, developmen
  FROM BikeCrash;

  DROP TABLE IF EXISTS BikeCrashResult;
  CREATE TABLE BikeCrashResult AS
  SELECT BikeCrashID, ambulancer, crash_type, crsh_sevri, hit_run, bike_injur, drvr_injur
  FROM BikeCrash;

  DROP TABLE IF EXISTS Biker;
  CREATE TABLE Biker AS
  SELECT BikeCrashID, bike_injur, bike_race, bike_dir, bike_age, bikeage_gr, bike_sex, bike_pos, bike_alc_d
  FROM BikeCrash;

  DROP TABLE IF EXISTS Driver_BikeCrash;
  CREATE TABLE Driver_BikeCrash AS
  SELECT BikeCrashID, drvr_vehty, drvr_injur, drvr_sex, drvr_race, drvr_age, drvrage_gr, drvr_estsp, drvr_alc_d
  FROM BikeCrash;

  DROP TABLE IF EXISTS BikeCrashReason;
  CREATE TABLE BikeCrashReason AS
  SELECT BikeCrashID, crashalcoh, excsspdind, drvr_alc_d, bike_alc_d, bike_pos, bike_dir, drvr_estsp, on_rd
  FROM BikeCrash;
END|
delimiter ;

CALL DivideBikeCrashTable;



# Combine crsh_sevri and crash_sevr as crsh_sevri in PedestrianCrash
DROP PROCEDURE IF EXISTS CombineColumns;
delimiter |
CREATE PROCEDURE CombineColumns()
BEGIN
  DECLARE n INT;
  DECLARE i INT;
  DECLARE temp VARCHAR(19);
  SELECT COUNT(*) FROM PedestrianCrash INTO n;
  SET i=1;
  WHILE i<=n DO
    SELECT crsh_sevri FROM PedestrianCrash WHERE PedCrashID=i INTO temp;
    IF (temp IS NULL) THEN UPDATE PedestrianCrash SET crsh_sevri=PedestrianCrash.crash_sevr WHERE PedCrashID=i;
    END IF;
    SET i=i+1;
  END WHILE;
END|
delimiter ;

CALL CombineColumns;



# Divide PedestrianCrash table into smaller tables
DROP PROCEDURE IF EXISTS DividePedCrashTable;
delimiter |
CREATE PROCEDURE DividePedCrashTable()
BEGIN
  DROP TABLE IF EXISTS PedCrashRdCond;
  CREATE TABLE PedCrashRdCond AS
  SELECT PedCrashID, rd_defects, rural_urba, city, locality, rd_feature, light_cond, rd_charact, rd_surface, developmen, traff_cntr, rd_conditi, region, rd_class, weather, num_lanes, rd_config
  FROM PedestrianCrash;

  DROP TABLE IF EXISTS DiverBiker_PedCrash;
  CREATE TABLE DiverBiker_PedCrash AS
  SELECT PedCrashID, drvr_age, drvrage_gr, drvr_estsp, speed_limi, drvr_vehty, drvr_injur, drvr_sex, drvr_race
  FROM PedestrianCrash;

  DROP TABLE IF EXISTS PedCrashDetail;
  CREATE TABLE PedCrashDetail AS
  SELECT PedCrashID, crsh_sevri, ambulancer, crash_time, crash_year, county, longitude, latitude, crash_mont, crash_type, city, locality, ped_pos, drvr_injur, crashday, crash_loc, crash_hour, geo_shape, crash_date, crash_grp, hit_run
  FROM PedestrianCrash;
END|
delimiter ;

CALL DividePedCrashTable;