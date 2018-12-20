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

		$city = $_POST['city'];

		$dbname = 'cs41518_ycao29_db';
		mysql_select_db($dbname, $conn);

		$result_types = mysql_query("CALL ShowCrashTypes_Comb", $conn);
		if (!$result_types){
			echo "Fail to retrieve list of crash types!\n";
			print mysql_error();
		} else {
			echo "<table border=1>\n";
			echo "<tr><td>PedestrianCrashTypes</td><td>BikeCrashTypes</td></tr>\n";
			while ($myrow = mysql_fetch_array($result_types)) {
				printf("<tr><td>%s</td><td>%s</td></tr>\n", $myrow["Ped_crashtype"], $myrow["Bike_crashtype"]);
			}
			echo "</table?\n";
		}

		$result_ped = mysql_query("CALL CrashTypeRate_Ped(\"$city\")", $conn);
		if (!$result_ped){
			echo "Fail to retrieve result for pedestrian crashes!\n";
			print mysql_error();
		} else {
			echo "<table border=1>\n";
			echo "<tr><td>CrashType</td><td>Count</td><td>TotalCount</td></tr>\n";
			while ($myrow = mysql_fetch_array($result_ped)) {
				printf("<tr><td>%s</td><td>%s</td><td>%s</td></tr>\n", $myrow["crash_type"], $myrow["type_count"], $myrow["total_count"]);
			}
			echo "</table?\n";
		}

		$result_bike = mysql_query("CALL CrashTypeRate_Bike(\"$city\")", $conn);
		if (!$result_bike) {
			echo "Fail to retrieve result for bike crashes!\n";
    		print mysql_error();
		} else {
			echo "<table border=1>\n";
			echo "<tr><td>CrashType</td><td>Count</td><td>TotalCount</td></tr>\n";
			while ($myrow = mysql_fetch_array($result_bike)) {
				printf("<tr><td>%s</td><td>%s</td><td>%s</td></tr>\n", $myrow["crash_type"], $myrow["type_count"], $myrow["total_count"]);
			}
			echo "</table?\n";
		}

		mysql_close();
	?>

</body>