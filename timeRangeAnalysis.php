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

		$time_f = $_POST['time_f'];
		$time_to = $_POST['time_to'];

		if (empty($time_f)) {
			$time_f = NULL;
		}

		if (empty($time_to)) {
			$time_to = NULL;
		}

		echo "Note: If the table is empty, it means there are no crashes during this time range.\n";


		echo "Cities with higher accident rate during entered time:\n";
		echo "Pedestrian crash:\n";
		$result = $db->query("CALL AccidentRate_Ped($time_f, $time_to)");
		if (!$result){
			echo "Fail to retrieve info for pedestrian crashes!\n";
			print mysql_error();
		} else {
			echo "<table border=1>\n";
			echo "<tr><td>Crash Count</td><td>Total Count</td><td>Percentage</td><td>City</td><td>Crash Type</td></tr>\n";
			while ($row = mysqli_fetch_array($result)) {
				$crash_count = $row['crash_count'];
			    $total_count = $row['total_count'];
			    $percentage = $row['percentage'];
				$city = $row['city'];
			    $crash_type = $row['crash_type'];
			    echo "<tr><td>".$crash_count."</td><td>".$total_count."</td><td>".$percentage."</td><td>".$city."</td><td>".$crash_type."</td></tr>";
			}
			echo "</table>\n";
			$result->close();
		    $db->next_result();
		}
		echo "Bike crash:\n";
		$result = $db->query("CALL AccidentRate_Bike($time_f, $time_to)");
		if (!$result){
			echo "Fail to retrieve info for bike crashes!\n";
			print mysql_error();
		} else {
			echo "<table border=1>\n";
			echo "<tr><td>Crash Count</td><td>Total Count</td><td>Percentage</td><td>City</td><td>Crash Type</td></tr>\n";
			while ($row = mysqli_fetch_array($result)) {
				$crash_count = $row['crash_count'];
			    $total_count = $row['total_count'];
			    $percentage = $row['percentage'];
				$city = $row['city'];
			    $crash_type = $row['crash_type'];
			    echo "<tr><td>".$crash_count."</td><td>".$total_count."</td><td>".$percentage."</td><td>".$city."</td><td>".$crash_type."</td></tr>";
			}
			echo "</table>\n";
			$result->close();
		    $db->next_result();
		}


		echo "Correlation between ambulance response and severity of injury during entered time:\n";
		echo "Pedestrian crash:\n";
		$result = $db->query("CALL AmbulanceSevri_Ped($time_f, $time_to)");
		if (!$result){
			echo "Fail to retrieve info for pedestrian crashes!\n";
			print mysql_error();
		} else {
			echo "<table border=1>\n";
			echo "<tr><td>Ambulance Response</td><td>Crash Severity</td><td>Total Crash Count</td></tr>\n";
			while ($row = mysqli_fetch_array($result)) {
				$ambulancer = $row['ambulancer'];
			    $crsh_sevri = $row['crsh_sevri'];
			    $count = $row['count'];
			    echo "<tr><td>".$ambulancer."</td><td>".$crsh_sevri."</td><td>".$count."</td></tr>";
			}
			echo "</table>\n";
			$result->close();
		    $db->next_result();
		}

		echo "Bike crash:\n";
		$result = $db->query("CALL AmbulanceSevri_Bike($time_f, $time_to)");
		if (!$result){
			echo "Fail to retrieve info for bike crashes!\n";
			print mysql_error();
		} else {
			echo "<table border=1>\n";
			echo "<tr><td>Ambulance Response</td><td>Crash Severity</td><td>Total Crash Count</td></tr>\n";
			while ($row = mysqli_fetch_array($result)) {
				$ambulancer = $row['ambulancer'];
			    $crsh_sevri = $row['crsh_sevri'];
			    $count = $row['count'];
			    echo "<tr><td>".$ambulancer."</td><td>".$crsh_sevri."</td><td>".$count."</td></tr>";
			}
			echo "</table>\n";
			$result->close();
		    $db->next_result();
		}


		echo "Hit and run rate during entered time:\n";
		echo "Pedestrian crash:\n";
		$result = $db->query("CALL HitRun_Ped($time_f, $time_to)");
		if (!$result){
			echo "Fail to retrieve info for pedestrian crashes!\n";
			print mysql_error();
		} else {
			echo "<table border=1>\n";
			echo "<tr><td>Hit And Run</td><td>Percentage</td><td>Weather</td></tr>\n";
			while ($row = mysqli_fetch_array($result)) {
				$hit_run = $row['hit_run'];
			    $percentage = $row['percentage'];
			    $crash_hour = $row['crash_hour'];
			    $weather = $row['weather'];
			    echo "<tr><td>".$hit_run."</td><td>".$percentage."</td><td>".$weather."</td></tr>";
			}
			echo "</table>\n";
			$result->close();
		    $db->next_result();
		}

		echo "Bike crash:\n";
		$result = $db->query("CALL HitRun_Bike($time_f, $time_to)");
		if (!$result){
			echo "Fail to retrieve info for bike crashes!\n";
			print mysql_error();
		} else {
			echo "<table border=1>\n";
			echo "<tr><td>Hit And Run</td><td>Percentage</td><td>Weather</td></tr>\n";
			while ($row = mysqli_fetch_array($result)) {
				$hit_run = $row['hit_run'];
			    $percentage = $row['percentage'];
			    $crash_hour = $row['crash_hour'];
			    $weather = $row['weather'];
			    echo "<tr><td>".$hit_run."</td><td>".$percentage."</td><td>".$weather."</td></tr>";
			}
			echo "</table>\n";
			$result->close();
		    $db->next_result();
		}

		$db->close();
	?>

</body>