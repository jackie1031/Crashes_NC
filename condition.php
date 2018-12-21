<head>
	<title>Top Crash Types In Selected City</title>
</head>

<body>

	<?php
		$dbhost = 'dbase.cs.jhu.edu:3306';
		$dbuser = 'ycao29';
		$dbpass = 'wyxjaycqli';
		$conn = mysql_connect($dbhost, $dbuser, $dbpass);

		if (!$conn) {
			die ('Error connecting to mysql');
		}

		$condition = $_POST['condition'];

		$dbname = 'cs41518_ycao29_db';
		mysql_select_db($dbname, $conn);

		if ($condition==="light") {

			$result_ped = mysql_query("CALL light_ped", $conn);
			if (!$result_ped) {
				echo "Fail to retrieve info for pedestrian crashes!\n";
				print mysql_error();
			} else {
				echo "Pedestrian crashes:\n";
				echo "<table border=1>\n";
				echo "<tr><td>LightCondition</td><td>Count</td><td>Percentage</td><td>MostFrequentSeverity</td></tr>\n";
				while ($myrow = mysql_fetch_array($result_ped)) {
					printf("<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>\n", $myrow["light_cond"], $myrow["type_count"], $myrow["percentage"], $myrow["most_frequent_severity"]);
				}
				echo "</table>\n";
			}

			$result_bike = mysql_query("CALL light_bike", $conn);
			if (!$result_bike) {
				echo "Fail to retrieve info for bike crashes!\n";
				print mysql_error();
			} else {
				echo "Bike crashes:\n";
				echo "<table border=1>\n";
				echo "<tr><td>LightCondition</td><td>Count</td><td>Percentage</td><td>MostFrequentSeverity</td></tr>\n";
				while ($myrow = mysql_fetch_array($result_bike)) {
					printf("<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>\n", $myrow["light_cond"], $myrow["type_count"], $myrow["percentage"], $myrow["most_frequent_severity"]);
				}
				echo "</table>\n";
			}

		} elseif ($condition==="roadSurface") {

			$result_ped = mysql_query("CALL road_charact_ped", $conn);
			if (!$result_ped) {
				echo "Fail to retrieve info for pedestrian crashes!\n";
				print mysql_error();
			} else {
				echo "Pedestrian crashes:\n";
				echo "<table border=1>\n";
				echo "<tr><td>SurfaceCondition</td><td>Count</td><td>Percentage</td><td>MostFrequentSeverity</td><td>MostFrequentWeather</td></tr>\n";
				while ($myrow = mysql_fetch_array($result_ped)) {
					printf("<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>\n", $myrow["rd_surface"], $myrow["type_count"], $myrow["percentage"], $myrow["most_frequent_severity"], $myrow["most_frequent_weather"]);
				}
				echo "</table>\n";
			}

			$result_bike = mysql_query("CALL road_charact_bike", $conn);
			if (!$result_ped) {
				echo "Fail to retrieve info for bike crashes!\n";
				print mysql_error();
			} else {
				echo "Bike crashes:\n";
				echo "<table border=1>\n";
				echo "<tr><td>SurfaceCondition</td><td>Count</td><td>Percentage</td><td>MostFrequentSeverity</td><td>MostFrequentWeather</td></tr>\n";
				while ($myrow = mysql_fetch_array($result_bike)) {
					printf("<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>\n", $myrow["rd_surface"], $myrow["type_count"], $myrow["percentage"], $myrow["most_frequent_severity"], $myrow["most_frequent_weather"]);
				}
				echo "</table>\n";
			}

		} elseif ($condition==="weather") {

			$result_ped = mysql_query("CALL weather_ped", $conn);
			if (!$result_ped) {
				echo "Fail to retrieve info for pedestrian crashes!\n";
				print mysql_error();
			} else {
				echo "Pedestrian crashes:\n";
				echo "<table border=1>\n";
				echo "<tr><td>Weather</td><td>Count</td><td>Percentage</td><td>MostFrequentSeverity</td><td>MostFrequentMonth</td></tr>\n";
				while ($myrow = mysql_fetch_array($result_ped)) {
					printf("<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>\n", $myrow["weather"], $myrow["type_count"], $myrow["percentage"], $myrow["most_frequent_severity"], $myrow["most_frequent_month"]);
				}
				echo "</table>\n";
			}

			$result_bike = mysql_query("CALL weather_bike", $conn);
			if (!$result_ped) {
				echo "Fail to retrieve info for bike crashes!\n";
				print mysql_error();
			} else {
				echo "Bike crashes:\n";
				echo "<table border=1>\n";
				echo "<tr><td>Weather</td><td>Count</td><td>Percentage</td><td>MostFrequentSeverity</td><td>MostFrequentMonth</td></tr>\n";
				while ($myrow = mysql_fetch_array($result_bike)) {
					printf("<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>\n", $myrow["weather"], $myrow["type_count"], $myrow["percentage"], $myrow["most_frequent_severity"], $myrow["most_frequent_month"]);
				}
				echo "</table>\n";
			}

		} elseif ($condition==="speedLimit") {

			$result_ped = mysql_query("CALL ExceedSp_Ped", $conn);
			if (!$result_ped) {
				echo "Fail to retrieve info for pedestrian crashes!\n";
				print mysql_error();
			} else {
				echo "Pedestrian crashes:\n";
				echo "<table border=1>\n";
				echo "<tr><td>Exceed Speed Limit Percentage</td><td>Below Speed Limit Percentage</td></tr>\n";
				while ($myrow = mysql_fetch_array($result_ped)) {
					printf("<tr><td>%s</td><td>%s</td></tr>\n", $myrow["ExceedLim_percentage"], $myrow["BelowLim_percentage"]);
				}
				echo "</table>\n";
			}

			$result_bike = mysql_query("CALL ExceedSp_Bike", $conn);
			if (!$result_ped) {
				echo "Fail to retrieve info for bike crashes!\n";
				print mysql_error();
			} else {
				echo "Bike crashes:\n";
				echo "<table border=1>\n";
				echo "<tr><td>Exceed Speed Limit Percentage</td><td>Below Speed Limit Percentage</td></tr>\n";
				while ($myrow = mysql_fetch_array($result_bike)) {
					printf("<tr><td>%s</td><td>%s</td></tr>\n", $myrow["ExceedLim_percentage"], $myrow["BelowLim_percentage"]);
				}
				echo "</table>\n";
			}

		} elseif ($condition==="alcohol") {

			$result_bike = mysql_query("CALL alcohol_bike", $conn);
			if (!$result_ped) {
				echo "Fail to retrieve info for bike crashes!\n";
				print mysql_error();
			} else {
				echo "Bike crashes:\n";
				echo "<table border=1>\n";
				echo "<tr><td>DriverDrinkAlcohol</td><td>Count</td><td>Percentage</td><td>MostFrequentHour</td></tr>\n";
				while ($myrow = mysql_fetch_array($result_ped)) {
					printf("<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>\n", $myrow["drvr_alc_d"], $myrow["type_count"], $myrow["driver_drink_percentage"], $myrow["the_hour"]);
				}
				echo "</table>\n";
			}			

		}

		mysql_close();
	?>

</body>