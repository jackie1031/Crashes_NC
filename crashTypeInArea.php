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
	    $city = $_POST['city'];
		
		echo "Data analysis for pedestrian crashes in $city\n";

		$result = $db->query("CALL CrashTypeRate_Ped('$city')");
		if($result){
		     // Cycle through results
			echo "<table border=1>\n";
			echo "<tr><td>CrashType</td><td>Count</td><td>TotalCount</td></tr>\n";
		    while($row = mysqli_fetch_array($result)) {
		        // $user_arr[] = $row;
				// printf("<tr><td>%s</td><td>%s</td><td>%s</td></tr>\n", $row["crash_type"], $row["type_count"], $row["total_count"]);

				$crash_type = $row['crash_type'];
			    $type_count = $row['type_count'];
			    $total_count = $row['total_count'];
			    echo "<tr><td>".$crash_type."</td><td>".$type_count."</td><td>".$total_count."</td></tr>";
			} 
		    
		    echo "</table>\n";
		    // Free result set
		    $result->close();
		    $db->next_result();
		}


		echo "\n \n Data analysis for bike crashes $city\n";
		$result = $db->query("CALL CrashTypeRate_Bike('$city')");
		if($result){
		     // Cycle through results
			echo "<table border=1>\n";
			echo "<tr><td>CrashType</td><td>Count</td><td>TotalCount</td></tr>\n";
		    while($row = mysqli_fetch_array($result)) {

				$crash_type = $row['crash_type'];
			    $type_count = $row['type_count'];
			    $total_count = $row['total_count'];
			    echo "<tr><td>".$crash_type."</td><td>".$type_count."</td><td>".$total_count."</td></tr>";
			} 
		    
		    echo "</table>\n";
		    // Free result set
		    $result->close();
		    $db->next_result();
		}

		echo "All possible crash type for pedestrian and bike \n";

		$result = $db->query("CALL ShowCrashTypes_Comb");
		if($result){
		     // Cycle through results
			echo "<table border=1>\n";
			echo "<tr><td>ALL Pedestrian Crash Types</td><td>All Bike Crash Types</td></tr>\n";
		    while($row = mysqli_fetch_array($result)) {
				$Ped_crashtype = $row['Ped_crashtype'];
			    $Bike_crashtype = $row['Bike_crashtype'];
			    echo "<tr><td>".$Ped_crashtype."</td><td>".$Bike_crashtype."</td></tr>";
			} 
		    
		    echo "</table>\n";
		    // Free result set
		    $result->close();
		    $db->next_result();
		}

		$db->close();
	?>

</body>