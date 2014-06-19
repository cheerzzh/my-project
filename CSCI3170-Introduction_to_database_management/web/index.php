<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>CSCI3170 Group 5</title>
</head>


<?php
$dbstr = "(DESCRIPTION=
	(ADDRESS_LIST=
		(ADDRESS=
			(PROTOCOL=TCP)
			(HOST=db12.cse.cuhk.edu.hk)
			(PORT=1521)
		)
	)
	(CONNECT_DATA=
		(SERVER=DEDICATED)
		(SERVICE_NAME=db12.cse.cuhk.edu.hk)
	)
)";
$conn = oci_connect('c019', 'lmfjkaed', '137.189.88.200/db12.cse.cuhk.edu.hk');
if(!$conn){
	die("ERROR: cannot establish the connection\n");
}
?>

<?php

$search_m = isset($_POST['sm']) ? true:false;
$search_c = isset($_POST['sc']) ? true:false;
$search_p = isset($_POST['sp']) ? true:false;
$keywd = isset($_POST['keyword']) ? htmlspecialchars($_POST['keyword']):"";
$optionerr = $keyworderr = "";
$proceed = false;
// $keywd_m = $keywd_c = $keywd_p = "%";

$sqlq = "SELECT P.p_id, P.p_name, C.c_name, M.m_name, P.p_aquantity FROM part P, category C, manufacturer M WHERE P.c_id = C.c_id AND P.m_id = M.m_id AND P.p_aquantity >= 1 AND (";



if ($_SERVER["REQUEST_METHOD"] == "POST"){
	
	$proceed = true;
	
	if ((empty($_POST['sm'])) and (empty($_POST['sc'])) and (empty($_POST['sp']))){
		$optionerr = "Please select at least 1 search option.";
		$proceed=false;
	}
	 
	if (empty($_POST['keyword'])){
		$keyworderr = "Please enter a keyword.";
		$proceed=false;
	}
		
	if(($proceed) and ($search_m)){
		$sqlq = $sqlq." M.m_name LIKE '%".$keywd."%' OR";
	 }
	else{
		$sqlq = $sqlq." M.m_name NOT LIKE '%' OR";
	 }
	 
	if(($proceed) and ($search_c)){
		$sqlq = $sqlq." C.c_name LIKE '%".$keywd."%' OR";
	 }
	else{
		$sqlq = $sqlq." C.c_name NOT LIKE '%' OR";
	 }
	 
	if(($proceed) and ($search_p)){
		$sqlq = $sqlq." P.p_name LIKE '%".$keywd."%')";
	 }
	else{
		$sqlq = $sqlq." P.p_name NOT LIKE '%')";
	}
	
	$sqlq = $sqlq." ORDER BY P.p_id ASC";
}
?>

<body>
<p>

<form action="index.php" method="POST">
Keyword: <input type="text" name="keyword"><span style="color:red"><?php echo $keyworderr; ?></span><br>
<input type="checkbox" name="sp" value = "true">By Part Name<br>
<input type="checkbox" name="sc" value = "true">By Category Name<br>
<input type="checkbox" name="sm" value = "true">By Manufacturer Name
<span style="color:red"><?php echo $optionerr; ?></span><br>
<input type="submit" VALUE = "Search">
</form>

<table width="900" border="1">
<tr>
    <th scope="col">Part ID</th>
    <th scope="col">Part Name</th>
    <th scope="col">Category</th>
    <th scope="col">Manufacturer</th>
    <th scope="col">Available Quantity</th>
</tr>

<?php
if (($_SERVER["REQUEST_METHOD"] == "POST") and ($proceed)){
	
	$stid = oci_parse($conn, $sqlq);
	oci_execute($stid);
	while($row = oci_fetch_object($stid)){
		echo "<tr>";
		echo "<td>",$row->P_ID,"</td>";
		echo "<td>",$row->P_NAME,"</td>";
		echo "<td>",$row->C_NAME,"</td>";
		echo "<td>",$row->M_NAME,"</td>";
		echo "<td>",$row->P_AQUANTITY,"</td>";
		echo "</tr>";
	}
	
	oci_close($conn);
	
}
?>
</table>


</body>
</html>