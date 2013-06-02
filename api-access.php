<?php
require_once("db-connect.php");
require_once("SelectQuery.php");
/**
	File: api-access.php
	Version: 0.1
	Author: Nikolas Wolfe
**/
class APIAccess {
	
	/* Table Constants */
	const TBL_AREA = 'area';
	const TBL_AREA_QUALIFIER = 'area_qualifier';
	const TBL_COUNTRY = 'country';
	const TBL_DIALECT = 'dialect';
	const TBL_DIALECT_MAP = 'dialect_map';
	const TBL_LANG = 'lang';
	const TBL_LANG_MAP = 'lang_map';
	const TBL_REGION = 'region';
	
	/* Column Constants */
	const COL_ID = 'ID';
	const COL_AREA_ID = 'AREA_ID';
	const COL_REGION_ID = 'REGION_ID';
	const COL_QUALIFIER_ID = 'QUALIFIER_ID';
	const COL_DIALECT_ID = 'DIALECT_ID';
	const COL_COUNTRY_ID = 'COUNTRY_ID';
	const COL_LANG_ID = 'LANG_ID';
	const COL_QUALIFIER = 'QUALIFIER';
	const COL_NAME = 'NAME';
	const COL_LESSON_NAME = 'DISPLAY_NAME';
	const COL_PHRASE_KEY = 'PHRASE_KEY';
	const COL_PHRASE_TEXT = 'PHRASE_TEXT';
	const COL_TRANSLATION_TEXT = 'TRANSLATION_TEXT';
	const COL_URL_MP3 = 'URL_MP3';
	const COL_JSON_STRING = "JSON_STRING";
	
	/* API CONSTANTS */
	const ACTION = 'action';
	const P_COUNTRY = 'country';
	const P_REGION = 'region';
	const P_AREA = 'area';
	const P_LANG = 'lang';
	const P_ID = 'id';
	const P_KEY = 'key';
	
	// db access members / request object
	private $db = NULL;
	private $req = NULL;
	private $Q = NULL;
	
	
	/********* PUBLIC INTERFACE *********/
	/********* PUBLIC INTERFACE *********/
	/********* PUBLIC INTERFACE *********/
	
	/* Default constructor */
	public function __construct($reqObj) {
		$this->db = get_db_access_obj();
		$this->req = $reqObj;
		$this->Q = new Query; 
	}
	
	/* api hello -- here for fun */
	public function hello() {
		return array( "I" => "am", "a" => "sample", "json" => "array" );
	}
	
	/***************************************************
		returns a list of country keys 
	*/
	public function get_country_list() {
		$s = "SELECT " . self::COL_NAME . " FROM " . self::TBL_COUNTRY;
		return $this->run($s, self::COL_NAME);
	}
	
	/***************************************************
		returns a list of languages in a given country 
	*/
	public function get_lang_list_by_country() {
		$country = $this->escape_string( self::P_COUNTRY );
		$s = sql_search_by_country( $country );
		return $this->run($s, self::COL_NAME);
	}
	
	/*************************************************** 	
		returns a list of languages based on a parameter 
		either country, region, or area
	*/
	public function get_lang_list_by() {
		$param = ""; $s = "";
		
		// higest priority: area
		if (isset($this->req[ self::P_AREA ])) { 
			$param = $this->escape_string( self::P_AREA );
			$s = $this->sql_search_by_area( $param );
		
		// second priority: region
		} else if (isset($this->req[ self::P_REGION ])) {
			$param = $this->escape_string( self::P_REGION );
			$s = $this->sql_search_by_region( $param );
		
		// lowest priority: country
		} else if (isset($this->req[ self::P_COUNTRY ])) {
			$param = $this->escape_string( self::P_COUNTRY );
			$s = $this->sql_search_by_country( $param );
		} 
		// error out
		else {
			return $this->error();
		}
		return $this->run($s, self::COL_NAME);
	}
	
	/***************************************************
		Returns a set of "Lesson Name" and "ID" pairs
	*/
	public function get_lessons_by_lang() {
		$param = $this->escape_string( self::P_LANG );
		$s = $this->sql_search_lessons_by_lang( $param );
		$result = $this->db->query( $s ); 
		$arr = array();
		while ($r = $result->fetch_assoc()) {
			$add = array($r[self::COL_LESSON_NAME] => $r[self::COL_ID]);
			array_push($arr, $add);
		}
		return $arr;
	}
	
	/***************************************************
		Returns a set of phrases and their associated information
	*/
	public function get_phrases_by_lesson_id() {
		$param = intval($this->escape_string( self::P_ID )); // make int, it's a number!
		$s = $this->sql_search_phrases_by_lesson_id( $param );
		$result = $this->db->query( $s );
		$arr = array();
		while($r = $result->fetch_assoc()) {
			// generate web url for the mp3 resource
			$url = $this->get_resource_url( $r[self::COL_URL_MP3] );
			$add = array(	$r[self::COL_PHRASE_KEY], 
							$r[self::COL_PHRASE_TEXT],
							$r[self::COL_TRANSLATION_TEXT],
							$url ); 
			array_push($arr, $add);
		}
		return $arr; 
	}
	
	/***************************************************
		Returns a set of phrases and their associated information
	*/
	public function get_order_by_lesson_id() {
		$param = intval($this->escape_string( self::P_ID )); 
		$s = $this->sql_search_order_by_lesson_id( $param );
		$result = $this->db->query( $s );
		$j = $result->fetch_assoc();
		$json_arr  = json_decode($j[self::COL_JSON_STRING]); // convert back into array
		return $json_arr;
	}
	
	/***************************************************
		Returns the informatin about a phrase based on its key, eg L1_M_5
	*/
	public function get_phrase_by_key() {
		$key = $this->escape_string( self::P_KEY ); // get 'key' parameter
		$lang = $this->escape_string( self::P_LANG ); // get 'lang' parameter
		$s = $this->sql_search_phrase_by_key( $key, $lang );
		$result = $this->db->query( $s );
		$r = $result->fetch_assoc();
		$url = $this->get_resource_url($r[self::COL_URL_MP3]);
		if( $r[self::COL_PHRASE_KEY] == NULL ) { return array("ERROR"); }
		$arr = array(	$r[self::COL_PHRASE_KEY], 
						$r[self::COL_PHRASE_TEXT], 
						$r[self::COL_TRANSLATION_TEXT], 
						$url);			
		return $arr;
	}
	
	
	/********* PRIVATE INTERFACE *********/
	/********* PRIVATE INTERFACE *********/
	/********* PRIVATE INTERFACE *********/
	
	
	
	/********* SQL INTERFACE *********/
	
	/* returns information about a phrase based on its key / language */
	private function sql_search_phrase_by_key( $key, $lang ) {
		$s = $this->Q->get_sql_search_phrase_by_key();
		$s = str_replace("@1@", $key, $s);
		$s = str_replace("@2@", $lang, $s);
		return $s;
	}
	
	/* returns SQL to get the ordering for a lesson */
	private function sql_search_order_by_lesson_id( $id ) {
		/* order based on lesson id */
		$s = $this->Q->get_sql_search_order_by_lesson_id();
		return str_replace("@@", $id, $s);
	}
	
	/* returns SQL query to search langauges / dialects by country */
	private function sql_search_by_country( $country ) {
		/* languages specific to areas and regions */
		$s = $this->Q->get_sql_search_by_country();
		return str_replace("@@", $country, $s);
	}
	
	/* returns SQL query to search langauges by region */
	private function sql_search_by_region( $region ) {
		/* languages specific to regions */		
		$s = $this->Q->get_sql_search_by_region();
		return str_replace("@@", $region, $s);
	}
	
	/* returns SQL query to search langauges by area */
	private function sql_search_by_area( $area ) {
		/* languages specific to areas */
		$s = $this->Q->get_sql_search_by_area();
		return str_replace("@@", $area, $s);
	}
	
	/* returns SQL query to search lessons by language */
	private function sql_search_lessons_by_lang( $lang ) {
		/* lessons specific to a language */
		$s = $this->Q->get_sql_search_lessons_by_lang();
		return str_replace("@@", $lang, $s);
	}
	
	/* returns SQL query to search lessons by language */
	private function sql_search_phrases_by_lesson_id( $id ) {
		/* get phrases grouped by lesson id */
		$s = $this->Q->get_sql_search_phrases_by_lesson_id();
		return str_replace("@@", $id, $s);
	}
	
	
	
	/********* PRIVATE UTILITY INTERFACE *********/
	
	/* fix the url to get the absolute location of the resource */
	private function get_resource_url( $url ) {
		return "http://" . $_SERVER['HTTP_HOST'] . str_replace("/index.php", "", $_SERVER['PHP_SELF']) . $url;
	}
	
	/* sanitizes an input parameter from the GET array */
	private function escape_string( $param ) {
		$item = "";
		if (isset($this->req[$param])) {
			$item = $this->db->real_escape_string($this->req[$param]);
		}
		return $item;
	}

	/* does the querying, fetches the result, pulls out the column, returns an array */
	private function run( $query, $col ) {
		$result = $this->db->query( $query ); 
		$r = $result->fetch_assoc();
		$arr = array(0 => $r[ $col ]);
		while ($r = $result->fetch_assoc()) {
			array_push($arr, $r[ $col ]);
		}
		return $arr;
	}
	
	/* on error detection, this array can be provided */
	private function error() {
		return array(0 => "ERROR");
	}
	
	/* debug */
	public function debug( $x ) { var_dump( $x ); die(); }
}
?>