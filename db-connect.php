<?php
require_once('db-config.php');

/* return a MySQL database access object using above parameters */
function get_db_access_obj() {
	
	// connect to MySQL
	$db = mysqli_connect(SERVER, USER, PASSWORD);

	// test connection
	if(mysqli_connect_errno()) {
		echo "<h1>Error establishing connection with database</h1>";
	
	// pick our database
	} else  {
		$db->select_db(DB);
	}
	
	// return db access object
	return $db;
}
?>