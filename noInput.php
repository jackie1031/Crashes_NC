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
		echo nl2br( "\n <strong> Part 1: which type of crash (pedestrian or bike) has higher severity of injury? \n");
		echo nl2br("Pedestrian crash:\n");
		$result = $db->query("CALL Injury_Ped");
		if (!$result){
			echo "Fail to retrieve info for pedestrian crashes!\n";
			print mysql_error();
		} else {
			echo "<table border=1>\n";
			echo "<tr><td>Crash Severity Level</td><td>Percentage</td></tr>\n";
			while ($row = mysqli_fetch_array($result)) {
				$crsh_sevri = $row['crsh_sevri'];
			    $percentage = $row['percentage'];
			    echo "<tr><td>".$crsh_sevri."</td><td>".$percentage."</td></tr>";
			}
			echo nl2br("</table>\n");
			$result->close();
		    $db->next_result();
		}

		echo nl2br("Bike crash:\n");
		$result = $db->query("CALL Injury_Bike");
		if (!$result){
			echo "Fail to retrieve info for bike crashes!\n";
			print mysql_error();
		} else {
			echo "<table border=1>\n";
			echo "<tr><td>Crash Severity Level</td><td>Percentage</td></tr>\n";
			while ($row = mysqli_fetch_array($result)) {
				$crsh_sevri = $row['crsh_sevri'];
			    $percentage = $row['percentage'];
			    echo "<tr><td>".$crsh_sevri."</td><td>".$percentage."</td></tr>";
			}
			echo nl2br("</table>\n");
			$result->close();
		    $db->next_result();
		}

		echo nl2br("A list of all injury types:\n");
		$result = $db->query("CALL ShowInjuryTypes");
		if (!$result){
			echo "Fail to retrieve info!\n";
			print mysql_error();
		} else {
			echo "<table border=1>\n";
			echo "<tr><td>Crash Severity Level</td></tr>\n";
			while ($row = mysqli_fetch_array($result)) {
				$crsh_sevri = $row['crsh_sevri'];
			    echo "<tr><td>".$crsh_sevri."</td></tr>";
			}
			echo nl2br("</table>\n");
			$result->close();
		    $db->next_result();
		}


		echo nl2br("Part 2: for both pedestrian and bike crashes, do crashes happen more often at intersection/non-intersection?\n");
		$result = $db->query("CALL IntersectAccidentRate");
		if (!$result){
			echo "Fail to retrieve info!\n";
			print mysql_error();
		} else {
			echo "<table border=1>\n";
			echo "<tr><td>Crash Location</td><td>Percentage</td><td>Most Frequent Weather</td><td>Most Frequent Light Condition</td></tr>\n";
			while ($row = mysqli_fetch_array($result)) {
				$crash_loc = $row['crash_loc'];
			    $percentage = $row['percentage'];
			    $weather = $row['weather'];
			    $light_cond = $row['light_cond'];
			    echo "<tr><td>".$crash_loc."</td><td>".$percentage."</td><td>".$weather."</td><td>".$light_cond."</td></tr>";
			}
			echo nl2br("</table>\n");
			$result->close();
		    $db->next_result();
		}

		echo nl2br(" \n Part 3: do crashes happen more often when there is no traffic control?\n");
		echo nl2br("Pedestrian crash:\n");
		$result = $db->query("CALL Traffic_Ped");
		if (!$result){
			echo "Fail to retrieve info for pedestrian crashes!\n";
			print mysql_error();
		} else {
			echo "<table border=1>\n";
			echo "<tr><td>Traffic Control</td><td>Percentage</td><td>Most Frequent Severity</td><td>Most Frequent # of Lanes</td></tr>\n";
			while ($row = mysqli_fetch_array($result)) {
				$traff_cntr = $row['traff_cntr'];
			    $TrafficControlRate = $row['TrafficControlRate'];
			    $crsh_sevri = $row['crsh_sevri'];
			    $num_lanes = $row['num_lanes'];
			    echo "<tr><td>".$traff_cntr."</td><td>".$TrafficControlRate."</td><td>".$crsh_sevri."</td><td>".$num_lanes."</td></tr>";
			}
			echo nl2br("</table>\n");
			$result->close();
		    $db->next_result();
		}

		echo nl2br("Bike crash:\n");
		$result = $db->query("CALL Traffic_Bike");
		if (!$result){
			echo "Fail to retrieve info for bike crashes!\n";
			print mysql_error();
		} else {
			echo "<table border=1>\n";
			echo "<tr><td>Traffic Control</td><td>Percentage</td><td>Most Frequent Severity</td><td>Most Frequent # of Lanes</td></tr>\n";
			while ($row = mysqli_fetch_array($result)) {
				$traff_cntr = $row['traff_cntr'];
			    $TrafficControlRate = $row['TrafficControlRate'];
			    $crsh_sevri = $row['crsh_sevri'];
			    $num_lanes = $row['num_lanes'];
			    echo "<tr><td>".$traff_cntr."</td><td>".$TrafficControlRate."</td><td>".$crsh_sevri."</td><td>".$num_lanes."</td></tr>";
			}
			echo "</table>\n";
			$result->close();
		    $db->next_result();
		}

		$db->close();
	?>

</body>