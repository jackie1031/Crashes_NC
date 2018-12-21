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
		
		$location = $_POST['typeLoc'];

		echo nl2br("Pedestrian crash:\n");
		$result = $db->query("CALL LocAccidentRate_Ped('$location')");
		if (!$result){
			echo "Fail to retrieve info for pedestrian crashes!\n";
			print mysql_error();
		} else {
			echo "<table border=1>\n";
			echo "<tr><td>Percentage</td><td>Driver Drink Alcohol</td><td>Most Frequent Severity</td></tr>\n";
			while ($row = mysqli_fetch_array($result)) {
			    $percentage = $row['percentage'];
			    $drvr_alc_d = $row['drvr_alc_d'];
			    $crsh_sevri = $row['crsh_sevri'];
			    echo "<tr><td>".$percentage."</td><td>".$drvr_alc_d."</td><td>".$crsh_sevri."</td></tr>";
			}
			echo nl2br("</table>\n");
			$result->close();
		    $db->next_result();
		}

		echo nl2br("Bike crash:\n");
		$result = $db->query("CALL LocAccidentRate_Bike('$location')");
		if (!$result){
			echo "Fail to retrieve info for bike crashes!\n";
			print mysql_error();
		} else {
			echo "<table border=1>\n";
			echo "<tr><td>Percentage</td><td>Driver Drink Alcohol</td><td>Most Frequent Severity</td></tr>\n";
			while ($row = mysqli_fetch_array($result)) {
			    $percentage = $row['percentage'];
			    $drvr_alc_d = $row['drvr_alc_d'];
			    $crsh_sevri = $row['crsh_sevri'];
			    echo "<tr><td>".$percentage."</td><td>".$drvr_alc_d."</td><td>".$crsh_sevri."</td></tr>";
			}
			echo "</table>\n";
			$result->close();
		    $db->next_result();
		}

		$db->close();
	?>

</body>