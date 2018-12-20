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

		$time_f = $_POST['time_f'];
		$time_to = $_POST['time_to'];

		$dbname = 'cs41518_ycao29_db';
		mysql_select_db($dbname, $conn);

		echo "Cities with higher accident rate during entered time:\n";
		echo "Pedestrian crash:\n";
		$result_ped = mysql_query("CALL AccidentRate_Ped($time_f, $time_to)", $conn);
		if (!$result_ped){
			echo "Fail to retrieve info for pedestrian crashes!\n";
			print mysql_error();
		} else {
			echo "<table border=1>\n";
			echo "<tr><td>CrashCount</td><td>TotalCount</td><td>Percentage</td><td>City</td><td>CrashType</td></tr>\n";
			while ($myrow = mysql_fetch_array($result_ped)) {
				printf("<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>\n", $myrow["crash_count"], $myrow["total_count"], $myrow["percentage"], $myrow["city"], $myrow["crash_type"]);
			}
			echo "</table>\n";
		}
		echo "Bike crash:\n";
		$result_bike = mysql_query("CALL AccidentRate_Bike($time_f, $time_to)", $conn);
		if (!$result_bike){
			echo "Fail to retrieve info for bike crashes!\n";
			print mysql_error();
		} else {
			echo "<table border=1>\n";
			echo "<tr><td>CrashCount</td><td>TotalCount</td><td>Percentage</td><td>City</td><td>CrashType</td></tr>\n";
			while ($myrow = mysql_fetch_array($result_bike)) {
				printf("<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>\n", $myrow["crash_count"], $myrow["total_count"], $myrow["percentage"], $myrow["city"], $myrow["crash_type"]);
			}
			echo "</table>\n";
		}


		echo "Correlation between ambulance response and severity of injury during entered time:\n";
		echo "Pedestrian crash:\n";
		$result_ped = mysql_query("CALL AmbulanceSevri_Ped($time_f, $time_to)", $conn);
		if (!$result_ped){
			echo "Fail to retrieve info for pedestrian crashes!\n";
			print mysql_error();
		} else {
			echo "<table border=1>\n";
			echo "<tr><td>AmbulanceResponse</td><td>CrashSeverity</td><td>TotalCrashCount</td></tr>\n";
			while ($myrow = mysql_fetch_array($result_ped)) {
				printf("<tr><td>%s</td><td>%s</td><td>%s</td></tr>\n", $myrow["ambulancer"], $myrow["crsh_sevri"], $myrow["count"]);
			}
			echo "</table>\n";
		}
		echo "Bike crash:\n";
		$result_bike = mysql_query("CALL AmbulanceSevri_Bike($time_f, $time_to)", $conn);
		if (!$result_bike){
			echo "Fail to retrieve info for pedestrian crashes!\n";
			print mysql_error();
		} else {
			echo "<table border=1>\n";
			echo "<tr><td>AmbulanceResponse</td><td>CrashSeverity</td><td>TotalCrashCount</td></tr>\n";
			while ($myrow = mysql_fetch_array($result_bike)) {
				printf("<tr><td>%s</td><td>%s</td><td>%s</td></tr>\n", $myrow["ambulancer"], $myrow["crsh_sevri"], $myrow["count"]);
			}
			echo "</table>\n";
		}


		echo "Hit and run rate during entered time:\n";
		echo "Pedestrian crash:\n";
		$result_ped = mysql_query("CALL HitRun_Ped($time_f, $time_to)", $conn);
		if (!$result_ped){
			echo "Fail to retrieve info for pedestrian crashes!\n";
			print mysql_error();
		} else {
			echo "<table border=1>\n";
			echo "<tr><td>HitAndRun</td><td>Percentage</td><td>CrashHour</td><td>Weather</td></tr>\n";
			while ($myrow = mysql_fetch_array($result_ped)) {
				printf("<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>\n", $myrow["hit_run"], $myrow["percentage"], $myrow["crash_hour"], $myrow["weather"]);
			}
			echo "</table>\n";
		}
		echo "Bike crash:\n";
		$result_bike = mysql_query("CALL HitRun_Bike($time_f, $time_to)", $conn);
		if (!$result_bike){
			echo "Fail to retrieve info for pedestrian crashes!\n";
			print mysql_error();
		} else {
			echo "<table border=1>\n";
			echo "<tr><td>HitAndRun</td><td>Percentage</td><td>CrashHour</td><td>Weather</td></tr>\n";
			while ($myrow = mysql_fetch_array($result_bike)) {
				printf("<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>\n", $myrow["hit_run"], $myrow["percentage"], $myrow["crash_hour"], $myrow["weather"]);
			}
			echo "</table>\n";
		}
		mysql_close();
	?>

</body>