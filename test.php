<head>
	<title>Top Crash Types In Selected City</title>
</head>

<body>
<?php

    $city = $_POST['city'];

    if ($city == "chapelHill")
       echo "chapelHill selected";

    else if ($city == "durham")
       echo "we selected $city";

    else if ($city == "carrboro")
       echo "we selected $city";

    else if ($city == "none")
       echo "we selected $city";

    else
       echo "Doesn't work";
?>

</body>