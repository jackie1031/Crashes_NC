<head>
	<title>Top Crash Types In Selected City</title>
</head>

<body>

	<?php
		$dbhost = 'dbase.cs.jhu.edu:3306';
		$dbuser = 'ycao29';
		$dbpass = 'wyxjaycqli';
		$dbname = 'cs41518_ycao29_db';
		$db = new mysqli($dbhost,$dbuser,$dbpass,$dbname);

		if(mysqli_connect_errno()){
			echo mysqli_connect_error();
		}

		$condition = $_POST['condition'];

		if ($condition==="light") {

			$result = $db->query("CALL light_ped");
			if (!$result) {
				echo "Fail to retrieve info for pedestrian crashes!\n";
				print mysql_error();
			} else {
				echo "Pedestrian crashes:\n";
				echo "<table border=1>\n";
				echo "<tr><td>Light Condition</td><td>Count</td><td>Percentage</td><td>Most Frequent Severity</td></tr>\n";
		    	while($row = mysqli_fetch_array($result)) {
					$light_cond = $row['light_cond'];
			    	$type_count = $row['type_count'];
			    	$percentage = $row['percentage'];
			    	$most_frequent_severity = $row['most_frequent_severity'];
			    	echo "<tr><td>".$light_cond."</td><td>".$type_count."</td><td>".$percentage."</td><td>".$most_frequent_severity."</td></tr>";
				}
		    	echo "</table>\n";
		    	$result->close();
		    	$db->next_result();
			}

			$result = $db->query("CALL light_bike");
			if (!$result) {
				echo "Fail to retrieve info for bike crashes!\n";
				print mysql_error();
			} else {
				echo "Bike crashes:\n";
				echo "<table border=1>\n";
				echo "<tr><td>Light Condition</td><td>Count</td><td>Percentage</td><td>Most Frequent Severity</td></tr>\n";
		    	while($row = mysqli_fetch_array($result)) {
					$light_cond = $row['light_cond'];
			    	$type_count = $row['type_count'];
			    	$percentage = $row['percentage'];
			    	$most_frequent_severity = $row['most_frequent_severity'];
			    	echo "<tr><td>".$light_cond."</td><td>".$type_count."</td><td>".$percentage."</td><td>".$most_frequent_severity."</td></tr>";
				}
		    	echo "</table>\n";
		    	$result->close();
		    	$db->next_result();
			}

		} elseif ($condition==="roadSurface") {

			$result = $db->query("CALL road_charact_ped");
			if (!$result) {
				echo "Fail to retrieve info for pedestrian crashes!\n";
				print mysql_error();
			} else {
				echo "Pedestrian crashes:\n";
				echo "<table border=1>\n";
				echo "<tr><td>Surface Condition</td><td>Count</td><td>Percentage</td><td>Most Frequent Severity</td><td>Most Frequent Weather</td></tr>\n";
		    	while($row = mysqli_fetch_array($result)) {
					$rd_surface = $row['rd_surface'];
			    	$type_count = $row['type_count'];
			    	$percentage = $row['percentage'];
			    	$most_frequent_severity = $row['most_frequent_severity'];
			    	$most_frequent_weather = $row['most_frequent_weather'];
			    	echo "<tr><td>".$rd_surface."</td><td>".$type_count."</td><td>".$percentage."</td><td>".$most_frequent_severity."</td><td>".$most_frequent_weather."</td></tr>";
				}
		    	echo "</table>\n";
		    	$result->close();
		    	$db->next_result();
			}

			$result = $db->query("CALL road_charact_bike");
			if (!$result) {
				echo "Fail to retrieve info for bike crashes!\n";
				print mysql_error();
			} else {
				echo "Bike crashes:\n";
				echo "<table border=1>\n";
				echo "<tr><td>Surface Condition</td><td>Count</td><td>Percentage</td><td>Most Frequent Severity</td><td>Most Frequent Weather</td></tr>\n";
		    	while($row = mysqli_fetch_array($result)) {
					$rd_surface = $row['rd_surface'];
			    	$type_count = $row['type_count'];
			    	$percentage = $row['percentage'];
			    	$most_frequent_severity = $row['most_frequent_severity'];
			    	$most_frequent_weather = $row['most_frequent_weather'];
			    	echo "<tr><td>".$rd_surface."</td><td>".$type_count."</td><td>".$percentage."</td><td>".$most_frequent_severity."</td><td>".$most_frequent_weather."</td></tr>";
				}
		    	echo "</table>\n";
		    	$result->close();
		    	$db->next_result();
			}

		} elseif ($condition==="weather") {

			$result = $db->query("CALL weather_ped");
			if (!$result) {
				echo "Fail to retrieve info for pedestrian crashes!\n";
				print mysql_error();
			} else {
				echo "Pedestrian crashes:\n";
				echo "<table border=1>\n";
				echo "<tr><td>Weather</td><td>Count</td><td>Percentage</td><td>Most Frequent Severity</td><td>Most Frequent Month</td></tr>\n";
		    	while($row = mysqli_fetch_array($result)) {
					$weather = $row['weather'];
			    	$type_count = $row['type_count'];
			    	$percentage = $row['percentage'];
			    	$most_frequent_severity = $row['most_frequent_severity'];
			    	$most_frequent_month = $row['most_frequent_month'];
			    	echo "<tr><td>".$weather."</td><td>".$type_count."</td><td>".$percentage."</td><td>".$most_frequent_severity."</td><td>".$most_frequent_month."</td></tr>";
				}
		    	echo "</table>\n";
		    	$result->close();
		    	$db->next_result();
			}

			$result = $db->query("CALL weather_bike");
			if (!$result) {
				echo "Fail to retrieve info for bike crashes!\n";
				print mysql_error();
			} else {
				echo "Bike crashes:\n";
				echo "<table border=1>\n";
				echo "<tr><td>Weather</td><td>Count</td><td>Percentage</td><td>Most Frequent Severity</td><td>Most Frequent Month</td></tr>\n";
		    	while($row = mysqli_fetch_array($result)) {
					$weather = $row['weather'];
			    	$type_count = $row['type_count'];
			    	$percentage = $row['percentage'];
			    	$most_frequent_severity = $row['most_frequent_severity'];
			    	$most_frequent_month = $row['most_frequent_month'];
			    	echo "<tr><td>".$weather."</td><td>".$type_count."</td><td>".$percentage."</td><td>".$most_frequent_severity."</td><td>".$most_frequent_month."</td></tr>";
				}
		    	echo "</table>\n";
		    	$result->close();
		    	$db->next_result();
			}

		} elseif ($condition==="speedLimit") {

			$result = $db->query("CALL ExceedSp_Ped");
			if (!$result) {
				echo "Fail to retrieve info for pedestrian crashes!\n";
				print mysql_error();
			} else {
				echo "Pedestrian crashes:\n";
				echo "<table border=1>\n";
				echo "<tr><td>Exceed Speed Limit Percentage</td><td>Below Speed Limit Percentage</td></tr>\n";
		    	while($row = mysqli_fetch_array($result)) {
					$ExceedLim_percentage = $row['ExceedLim_percentage'];
			    	$BelowLim_percentage = $row['BelowLim_percentage'];
			    	echo "<tr><td>".$ExceedLim_percentage."</td><td>".$BelowLim_percentage."</td></tr>";
				}
		    	echo "</table>\n";
		    	$result->close();
		    	$db->next_result();
			}

			$result = $db->query("CALL ExceedSp_Bike");
			if (!$result) {
				echo "Fail to retrieve info for bike crashes!\n";
				print mysql_error();
			} else {
				echo "Bike crashes:\n";
				echo "<table border=1>\n";
				echo "<tr><td>Exceed Speed Limit Percentage</td><td>Below Speed Limit Percentage</td></tr>\n";
		    	while($row = mysqli_fetch_array($result)) {
					$ExceedLim_percentage = $row['ExceedLim_percentage'];
			    	$BelowLim_percentage = $row['BelowLim_percentage'];
			    	echo "<tr><td>".$ExceedLim_percentage."</td><td>".$BelowLim_percentage."</td></tr>";
				}
		    	echo "</table>\n";
		    	$result->close();
		    	$db->next_result();
			}


		} elseif ($condition==="alcohol") {

			$result = $db->query("CALL alcohol_bike");
			if (!$result) {
				echo "Fail to retrieve info for bike crashes!\n";
				print mysql_error();
			} else {
				echo "Bike crashes:\n";
				echo "<table border=1>\n";
				echo "<tr><td>Driver Drink Alcohol</td><td>Count</td><td>Percentage</td><td>Most Frequent Hour</td></tr>\n";
		    	while($row = mysqli_fetch_array($result)) {
					$drvr_alc_d = $row['drvr_alc_d'];
			    	$type_count = $row['type_count'];
			    	$driver_drink_percentage = $row['driver_drink_percentage'];
			    	$the_hour = $row['the_hour'];
			    	echo "<tr><td>".$drvr_alc_d."</td><td>".$type_count."</td><td>".$driver_drink_percentage."</td><td>".$the_hour."</td></tr>";
				}
		    	echo "</table>\n";
		    	$result->close();
		    	$db->next_result();
			}

		}

		mysql_close();
	?>

</body>