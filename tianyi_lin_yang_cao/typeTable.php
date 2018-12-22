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

		echo nl2br("To give the idea of distribution of driver's sex, race, age, etc. we display the count of each category below: \n");

		$result = $db->query("CALL DriverInfo('$type')");
		if (!$result){
			echo "Fail to retrieve info for pedestrian crashes!\n";
			print mysql_error();
		} else {
			echo "<table border=1>\n";
			echo "<tr><td>Category</td><td>Count For Each Category</td></tr>\n";
			while ($row = mysqli_fetch_array($result)) {
			    $type = $row['type'];
			    $count = $row['count'];
			    echo "<tr><td>".$type."</td><td>".$count."</td></tr>";
			}
			echo nl2br("</table>\n");
			$result->close();
		    $db->next_result();
		}

		$db->close();
	?>

</body>