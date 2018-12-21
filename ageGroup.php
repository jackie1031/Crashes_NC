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

		$age = $_POST['age'];
		echo "Note: If the table is empty, it means there are no crashes within this age group.\n";
		echo "Info about pedestrian crash victims:\n";

		$result = $db->query("CALL AgeGpAccidentRate_Ped('$age')");
		if (!$result){
			echo "Fail to retrieve info for pedestrian crashes!\n";
			print mysql_error();
		} else {
			echo "<table border=1>\n";
			echo "<tr><td>Count</td><td>Age Group</td><td>Pedestrian Position</td><td>Pedestrian Race</td><td>Pedestrian Injury</td><td>Pedestrian Sex</td></tr>\n";
			while ($row = mysqli_fetch_array($result)) {
				$count = $row['count'];
			    $pedage_grp = $row['pedage_grp'];
			    $ped_pos = $row['ped_pos'];
				$ped_race = $row['ped_race'];
			    $ped_injury = $row['ped_injury'];
			    $ped_sex = $row['ped_sex'];
			    echo "<tr><td>".$count."</td><td>".$pedage_grp."</td><td>".$ped_pos."</td><td>".$ped_race."</td><td>".$ped_injury."</td><td>".$ped_sex."</td></tr>";
			}
			echo "</table>\n";
			$result->close();
		    $db->next_result();
		}

		echo "Info about bike crash victims:\n";

		$result = $db->query("CALL AgeGpAccidentRate_Bike('$age')");
		if (!$result){
			echo "Fail to retrieve info for bike crashes!\n";
			print mysql_error();
		} else {
			echo "<table border=1>\n";
			echo "<tr><td>Count</td><td>Age Group</td><td>Biker Position</td><td>Biker Race</td><td>Biker Injury</td><td>Biker Sex</td><td>Biker Drink Alcohol</td></tr>\n";
			while ($row = mysqli_fetch_array($result)) {
				$count = $row['count'];
			    $bikeage_gr = $row['bikeage_gr'];
			    $bike_pos = $row['bike_pos'];
				$bike_race = $row['bike_race'];
			    $bike_injur = $row['bike_injur'];
			    $bike_sex = $row['bike_sex'];
			    $bike_alc_d = $row['bike_alc_d'];
			    echo "<tr><td>".$count."</td><td>".$bikeage_gr."</td><td>".$bike_pos."</td><td>".$bike_race."</td><td>".$bike_injur."</td><td>".$bike_sex."</td><td>".$bike_alc_d."</td></tr>";
			}
			echo "</table>\n";
			$result->close();
		    $db->next_result();
		}
		
		mysql_close();

	?>

</body>