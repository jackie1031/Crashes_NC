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

		if ($type==="pedestrian") {
			echo "Pedestrian crash:\n";
			$result = $db->query("CALL LocAccidentRate_Ped('$location')");
			if (!$result){
				echo "Fail to retrieve info for pedestrian crashes!\n";
				print mysql_error();
			} else {
				echo "<table border=1>\n";
				echo "<tr><td>Percentage</td><td>Hit&Run</td><td>Driver Drink Alcohol</td><td>Most Frequent Weather</td><td>Most Frequent Severity</td></tr>\n";
				while ($row = mysqli_fetch_array($result)) {
			    	$percentage = $row['percentage'];
			    	$hit_run = $row['hit_run'];
			    	$drvr_alc_d = $row['drvr_alc_d'];
			    	$weather = $row['weather'];
			    	$crsh_sevri = $row['crsh_sevri'];
			    	echo "<tr><td>".$percentage."</td><td>".$hit_run."</td><td>".$drvr_alc_d."</td><td>".$weather."</td><td>".$crsh_sevri."</td></tr>";
				}
				echo "</table>\n";
				$result->close();
		    	$db->next_result();
			}
		} elseif ($type==="bike") {

		}



		echo "Pedestrian crash:\n";
		$result = $db->query("CALL LocAccidentRate_Ped('$location')");
		if (!$result){
			echo "Fail to retrieve info for pedestrian crashes!\n";
			print mysql_error();
		} else {
			echo "<table border=1>\n";
			echo "<tr><td>Percentage</td><td>Hit&Run</td><td>Driver Drink Alcohol</td><td>Most Frequent Weather</td><td>Most Frequent Severity</td></tr>\n";
			while ($row = mysqli_fetch_array($result)) {
			    $percentage = $row['percentage'];
			    $hit_run = $row['hit_run'];
			    $drvr_alc_d = $row['drvr_alc_d'];
			    $weather = $row['weather'];
			    $crsh_sevri = $row['crsh_sevri'];
			    echo "<tr><td>".$percentage."</td><td>".$hit_run."</td><td>".$drvr_alc_d."</td><td>".$weather."</td><td>".$crsh_sevri."</td></tr>";
			}
			echo "</table>\n";
			$result->close();
		    $db->next_result();
		}

		echo "Bike crash:\n";
		$result = $db->query("CALL LocAccidentRate_Bike('$location')");
		if (!$result){
			echo "Fail to retrieve info for bike crashes!\n";
			print mysql_error();
		} else {
			echo "<table border=1>\n";
			echo "<tr><td>Percentage</td><td>Hit&Run</td><td>Driver Drink Alcohol</td><td>Most Frequent Weather</td><td>Most Frequent Severity</td></tr>\n";
			while ($row = mysqli_fetch_array($result)) {
			    $percentage = $row['percentage'];
			    $hit_run = $row['hit_run'];
			    $drvr_alc_d = $row['drvr_alc_d'];
			    $weather = $row['weather'];
			    $crsh_sevri = $row['crsh_sevri'];
			    echo "<tr><td>".$percentage."</td><td>".$hit_run."</td><td>".$drvr_alc_d."</td><td>".$weather."</td><td>".$crsh_sevri."</td></tr>";
			}
			echo "</table>\n";
			$result->close();
		    $db->next_result();
		}

		$db->close();
	?>

</body>