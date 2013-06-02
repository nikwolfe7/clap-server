<?php
/**
	File: api-access.php
	Version: 0.1
	Author: Nikolas Wolfe
	A set of functions returning queries parameterized with @@ (@1@ / @2@, etc...) signs.
**/
class SelectQuery {
				
	public function __construct() { }
	
	public function get_sql_search_phrases_by_lang() {
		
		$q = /* Gets a list of all available phrases for a given language */
			"SELECT ";
		
		return $q;
	}
	
	public function get_sql_search_phrase_by_key() {
		
		$q = /* returns SQL to get info about a phrase key */
			"SELECT phrase_map.PHRASE_KEY, phrase.PHRASE_TEXT, phrase_map.TRANSLATION_TEXT, phrase_map.URL_MP3 ".
			"FROM phrase_map, phrase, lang, dialect WHERE ".
			"LOWER(phrase_map.PHRASE_KEY) = LOWER('@1@') AND phrase_map.PHRASE_ID = phrase.ID AND ".
			"phrase_map.LANG_ID = lang.ID AND LOWER(lang.NAME) = LOWER('@2@') OR ".
			"phrase_map.DIALECT_ID = dialect.ID AND LOWER(dialect.NAME) = LOWER('@2@') LIMIT 1";
	
		return $q;
	}
	
	public function get_sql_search_order_by_lesson_id() {
		
		$q = /* get language order data based on the lesson */
			"SELECT JSON_STRING FROM lesson_order WHERE LESSON_ID = @@";
	
		return $q;
	}
	
	public function get_sql_search_by_country() { 
	
		$q = /* languages specific to areas and regions */
			"SELECT DISTINCT lang.NAME FROM lang, lang_map, area, region, country " .
			"WHERE lang.ID = lang_map.LANG_ID " .
			"AND lang_map.AREA_ID = area.ID " .
			"AND area.REGION_ID = region.ID " .
			"AND region.COUNTRY_ID = country.ID " .
			"AND LOWER(country.NAME) = LOWER('@@') " .
			"UNION " . 
			/* languages general to whole country */
			"SELECT DISTINCT lang.NAME FROM lang, lang_map, country ".
			"WHERE lang.ID = lang_map.LANG_ID ".
			"AND lang_map.COUNTRY_ID = country.ID ".
			"AND LOWER(country.NAME) = LOWER('@@')".
			"UNION " . 
			/* dialects specific to areas and regions */
			"SELECT DISTINCT dialect.NAME FROM dialect, dialect_map, area, region, country " .
			"WHERE dialect.ID = dialect_map.DIALECT_ID " .
			"AND dialect_map.AREA_ID = area.ID " .
			"AND area.REGION_ID = region.ID " .
			"AND region.COUNTRY_ID = country.ID " .
			"AND LOWER(country.NAME) = LOWER('@@') " .
			"UNION " .
			/* dialects general to whole country */
			"SELECT DISTINCT dialect.NAME FROM dialect, dialect_map, country ".
			"WHERE dialect.ID = dialect_map.DIALECT_ID ".
			"AND dialect_map.COUNTRY_ID = country.ID ".
			"AND LOWER(country.NAME) = LOWER('@@')";
			
		return $q;
	}
	
	public function get_sql_search_by_region() {
	
		$q = /* languages specific to regions */
			"SELECT DISTINCT lang.NAME FROM lang, lang_map, region " .
			"WHERE lang.ID = lang_map.LANG_ID " .
			"AND region.ID = lang_map.REGION_ID " .
			"AND LOWER(region.NAME) = LOWER('@@')" .
			"UNION ".
			/* dialects specific to regions */
			"SELECT DISTINCT dialect.NAME FROM dialect, dialect_map, region " .
			"WHERE dialect.ID = dialect_map.dialect_ID " .
			"AND region.ID = dialect_map.REGION_ID " .
			"AND LOWER(region.NAME) = LOWER('@@')";
			
		return $q;
	
	}
	
	public function get_sql_search_by_area() {
		
		$q = /* languages specific to areas */
			"SELECT DISTINCT lang.NAME FROM lang, lang_map, area " .
			"WHERE lang.ID = lang_map.LANG_ID " .
			"AND area.ID = lang_map.AREA_ID " .
			"AND LOWER(area.NAME) = LOWER('@@')" .
			"UNION " .
			/* dialects specific to areas */
			"SELECT DISTINCT dialect.NAME FROM dialect, dialect_map, area " .
			"WHERE dialect.ID = dialect_map.dialect_ID " .
			"AND area.ID = dialect_map.AREA_ID " .
			"AND LOWER(area.NAME) = LOWER('@@')";
		
		return $q;
	}
	
	public function get_sql_search_lessons_by_lang() {
		
		$q = /* lessons specific to a language */
			"SELECT DISTINCT lang_lesson.DISPLAY_NAME, lang_lesson.ID FROM lang_lesson, lang, dialect ".
			"WHERE (lang_lesson.LANG_ID = lang.ID AND LOWER(lang.NAME) = LOWER('@@')) ".
			"OR (lang_lesson.DIALECT_ID = dialect.ID AND LOWER(dialect.NAME) = LOWER('@@'))";
		
		return $q;
	}
	
	public function get_sql_search_phrases_by_lesson_id() {
	
		$q = /* get phrases grouped by lesson id */
			"SELECT phrase_map.PHRASE_KEY, phrase.PHRASE_TEXT, phrase_map.TRANSLATION_TEXT, phrase_map.URL_MP3 FROM ".
			"phrase_map, phrase WHERE ".
			"phrase_map.PHRASE_ID = phrase.ID AND ".
			"phrase_map.LESSON_ID = @@";
			
		return $q;
	
	}
}

?>