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

		$result_ped = mysql_query("CALL AccidentRate_Ped($time_f, $time_to)", $conn);
		if (!$result_ped){
			echo "Fail to retrieve info for pedestrian crashes!\n";
			print mysql_error();
		} else {
			echo "<table border=1>\n";
			echo "<tr><td>CrashCount</td><td>TotalCount</td><td>Percentage</td><td>City</td><td>CrashType</td></tr>\n";
			while ($myrow = mysql_fetch_array($result_ped)) {
				printf("<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>\n", $myrow["crash_count"], $myrow["total_count"], myrow["percentage"], myrow["city"], myrow["crash_type"]);
			}
			echo "</table>\n";
		}

		$result_bike = mysql_query("CALL AccidentRate_Bike($time_f, $time_to)", $conn);
		if (!$result_bike){
			echo "Fail to retrieve info for bike crashes!\n";
			print mysql_error();
		} else {
			echo "<table border=1>\n";
			echo "<tr><td>CrashCount</td><td>TotalCount</td><td>Percentage</td><td>City</td><td>CrashType</td></tr>\n";
			while ($myrow = mysql_fetch_array($result_bike)) {
				printf("<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>\n", $myrow["crash_count"], $myrow["total_count"], myrow["percentage"], myrow["city"], myrow["crash_type"]);
			}
			echo "</table>\n";
		}


		mysql_close();
	?>

</body>