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
		
		$type = $_POST['typeTable'];


		$result = $db->query("CALL DriverInfo('$type')");
		if (!$result){
			echo "Fail to retrieve info for pedestrian crashes!\n";
			print mysql_error();
		} else {
			echo "<table border=1>\n";
			echo "<tr><td>Sex</td><td>Age</td><td>Vehicle Type</td><td>Injury</td><td>Crash Type</td></tr>\n";
			while ($row = mysqli_fetch_array($result)) {
			    $drvr_sex = $row['drvr_sex'];
			    $drvr_age = $row['drvr_age'];
			    $drvr_vehty = $row['drvr_vehty'];
			    $drvr_injur = $row['drvr_injur'];
			    $crash_type = $row['crash_type'];
			    echo "<tr><td>".$percentage."</td><td>".$hit_run."</td><td>".$drvr_alc_d."</td><td>".$weather."</td><td>".$crsh_sevri."</td></tr>";
			}
			echo "</table>\n";
			$result->close();
		    $db->next_result();
		}

		$db->close();
	?>

</body>