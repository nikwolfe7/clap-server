<?php
/**
	File: rest.php
	Version: 0.1
	Author: Nikolas Wolfe
	Credit: 'Rest.inc.php', by Arun Kumar Sekar
	Reference: https://github.com/mnzuki/data/blob/master/rest/rest.inc.php
**/
class REST {

	// Request Constants
	const GET = 'GET';
	const POST = 'POST';
	const DELETE = 'DELETE';
	const PUT = 'PUT';
	
	// JSON, XML Constants
	const JSON_CONTENT_TYPE = "application/json";
	const XML_CONTENT_TYPE = "application/xml";
	const JSON = 'json';
	const XML = 'xml';
	
	// HTTP Header Constants
	const HTTP_HEADER = "HTTP/1.1 "; 
	const CONTENT_TYPE = "Content-Type:"; 
	
	// array of HTTP status codes
	protected $HTTP_STATUS_CATS = array(
		100 => 'Continue',  
		101 => 'Switching Protocols',  
		200 => 'OK',
		201 => 'Created',  
		202 => 'Accepted',  
		203 => 'Non-Authoritative Information',  
		204 => 'No Content',  
		205 => 'Reset Content',  
		206 => 'Partial Content',  
		300 => 'Multiple Choices',  
		301 => 'Moved Permanently',  
		302 => 'Found',  
		303 => 'See Other',  
		304 => 'Not Modified',  
		305 => 'Use Proxy',  
		306 => '(Unused)',  
		307 => 'Temporary Redirect',  
		400 => 'Bad Request',  
		401 => 'Unauthorized',  
		402 => 'Payment Required',  
		403 => 'Forbidden',  
		404 => 'Not Found',  
		405 => 'Method Not Allowed',  
		406 => 'Not Acceptable',  
		407 => 'Proxy Authentication Required',  
		408 => 'Request Timeout',  
		409 => 'Conflict',  
		410 => 'Gone',  
		411 => 'Length Required',  
		412 => 'Precondition Failed',  
		413 => 'Request Entity Too Large',  
		414 => 'Request-URI Too Long',  
		415 => 'Unsupported Media Type',  
		416 => 'Requested Range Not Satisfiable',  
		417 => 'Expectation Failed',  
		500 => 'Internal Server Error',  
		501 => 'Not Implemented',  
		502 => 'Bad Gateway',  
		503 => 'Service Unavailable',  
		504 => 'Gateway Timeout',  
		505 => 'HTTP Version Not Supported'
	); // end $HTTP_STATUS_CATS
	
	/* If you don't get the joke, http://httpstatuscats.com/ */
	
	// Default return code OK
	protected $CODE = 200;
	
	// The current request array
	protected $REQ = array();
	
	// The HTTP Response
	protected $RESPONSE = array(
		"DATA" => '',
		"STATUS" => 200,
		"FORMAT" => '');
	
	
	
	
	/********* PUBLIC INTERFACE *********/
	
	/* Default constructor */
	public function __construct() {
		$this->sanitize_globals(); // sets the REQ
		$this->get_inputs(); // sets the RESPONSE
	}
	
	
	/********* PROTECTED INTERFACE *********/
	
	/* 	THE BIG KAHUNA BURGER REPLY FUNCTION -- protected so it can be overridden 
		$response_array passed here MUST have following params:
			['DATA'] => something
			['STATUS'] => HTTP status code
			['FORMAT'] => The type of format we want (JSON, XML, etc...)
	*/
	protected function http_response( $response_array ) {
		
		if (array_key_exists('DATA', $response_array) && 
			array_key_exists('STATUS', $response_array) &&
			array_key_exists('FORMAT', $response_array)) {
				
				// all or nothing
				$this->RESPONSE['DATA'] = $response_array['DATA'];
				$this->RESPONSE['STATUS'] = $response_array['STATUS'];
				$this->RESPONSE['FORMAT'] = $response_array['FORMAT'];
			
		} else {
			// Version 0.1 NOT IMPLEMENTED
			$this->set_response_forbidden();
		}
		
		// send the HTTP headers
		$this->send_headers();
		exit;
	}
	
	/* send the return headers -- protected so it can be overridden */
	protected function send_headers() {
		// return data
		$shit = null; 
		
		// Set HTTP response...
		$this->CODE = intval($this->RESPONSE['STATUS']);
		$status_msg = $this->HTTP_STATUS_CATS[$this->CODE];
		
		// Send the headers...
		header( self::HTTP_HEADER . $this->CODE . " " . $status_msg );
		
		// Add format...
		if ($this->RESPONSE['FORMAT'] == self::JSON) {
			header (self::CONTENT_TYPE . self::JSON_CONTENT_TYPE);
			
			// convert data to JSON...
			if (is_array($this->RESPONSE['DATA'])) {
				$shit = json_encode($this->RESPONSE['DATA']);
				$shit = str_replace("\/","/",$shit); // get rid of escape slashes
			}
			
		} else if ($this->RESPONSE['FORMAT'] == self::XML) {
			header (self::CONTENT_TYPE . self::XML_CONTENT_TYPE);

			// convert data to XML... Version 0.1 NOT IMPLEMENTED
			$this->set_response_not_implemented();
			
		} else {
			header (self::CONTENT_TYPE . "text/plain");
			$shit = $this->RESPONSE['DATA'];
		}
		// echo that shit
		echo $shit; 
	}
	
	/* Get the request inputs -- protected so it can be overridden */
	protected function get_inputs() {
		if ($this->is_get_request()) {
			// nothing necessary...
			
		} else if ($this->is_post_request()) {
			// Version 0.1 NOT IMPLEMENTED
			$this->set_response_not_implemented();
			
		} else if ($this->is_delete_request()) {
			// Version 0.1 NOT IMPLEMENTED
			$this->set_response_not_implemented();
			
		} else if ($this->is_put_request()) {
			// Version 0.1 NOT IMPLEMENTED
			$this->set_response_not_implemented();
			
		} else {
			// Default response
			$this->set_response_not_acceptable();
		}			
	}
	
	/* Get request method */
	final protected function get_sanitized_REQ() {
		return $this->REQ;
	}
	
	/* Get request method */
	final protected function get_request_method() { return $_SERVER["REQUEST_METHOD"]; }
	
	/* Get referer */
	final protected function get_referer() { return $_SERVER["HTTP_REFERER"]; }
	
	/* check if GET request */
	final protected function is_get_request() { return $this->get_request_method() == self::GET; }
	
	/* check if POST request */
	final protected function is_post_request() { return $this->get_request_method() == self::POST; }
	
	/* check if DELETE request */
	final protected function is_delete_request() { return $this->get_request_method() == self::DELETE; }
	
	/* check if PUT request */
	final protected function is_put_request() { return $this->get_request_method() == self::PUT; }
	
	/* return 500 server error */
	final protected function set_response_server_error() { $this->set_response_code(500); }
	
	/* return 501 not implemented */
	final protected function set_response_not_implemented() { $this->set_response_code(501); }
	
	/* return 406 not acceptable */
	final protected function set_response_not_acceptable() { $this->set_response_code(406); }
	
	/* return 404 not found */
	final protected function set_response_not_found() { $this->set_response_code(404); }
	
	/* return 403 forbidden */
	final protected function set_response_forbidden() { $this->set_response_code(403); }
	
	/* return 200 okay */
	final protected function set_response_ok() { $this->set_response_code(200); }
	
	
	
	/********** PRIVATE CLASS FUNCTIONS *********/
	
	public function debug( $var ) {
		var_dump($var);
		die();
	}
	
	/* set number for an HTTP response */
	private function set_response_code( $http_response ) {
		$this->RESPONSE = array('DATA' => '', 'STATUS' => $http_response, 'FORMAT' => '');
		$this->http_response( $this->RESPONSE );
	}
	
	/* sanitize appropriate global array */
	private function sanitize_globals() {
		switch ($this->get_request_method()) {
			case "POST":
				$this->REQ = filter_input_array(INPUT_POST, FILTER_SANITIZE_STRING);
				break;
				
			case "GET":
				$this->REQ = filter_input_array(INPUT_GET, FILTER_SANITIZE_STRING);
				break;
			
			case "DELETE":
				//$this->REQ = filter_input_array(INPUT_DELETE, FILTER_SANITIZE_STRING);
				// Version 0.1 NOT IMPLEMENTED
				$this->set_response_not_implemented();
				break;
			
			case "PUT":
				//$this->REQ = filter_input_array(INPUT_PUT, FILTER_SANITIZE_STRING);
				// Version 0.1 NOT IMPLEMENTED
				$this->set_response_not_implemented();
				break;
				
			default: 
				// Version 0.1 NOT IMPLEMENTED
				$this->set_response_forbidden(); 
				break; 
		}
	}
}
?>