<?php
require_once("rest.php");
require_once("api-access.php");
/**
	File: api.php
	Version: 0.1
	Author: Nikolas Wolfe
**/
class API extends REST {

	/* MySQL DB access object */
	private $access = NULL; 
	private $request = NULL;
	
	/* API CONSTANTS */
	const ACTION = 'action';
	
	
	/********* PUBLIC INTERFACE *********/
	
	/* Default constructor */
	public function __contruct() {
		parent::__construct();
	}

	/* parse the incoming request */
	public function parse_request() {
	
		// Version 0.1 -- GET Requests only. 
		if( $this->is_get_request() ) {
		
			// get the sanitized get array
			$this->request = $this->get_sanitized_REQ();
			
			// initialize our APIAccess object
			$this->access = new APIAccess($this->request);
			
			// check that GET parameters are set
			if( is_array($this->request) ) {
				
				// try to execute the method
				$this->try_request_action(); 
			
			// no GET parameters? forbidden!
			} else {
				$this->set_response_forbidden();
			}
		} else {
			$this->set_response_forbidden();
		}
	}
	
	/********* PRIVATE CLASS FUNCTIONS *********/
	private function try_request_action() {

		// request action
		$action = NULL;
		
		// check that the action parameter is set
		if (isset($this->request[self::ACTION])) {
			
			// set action variable
			$action = $this->request[self::ACTION];
			
			// check that it's an actual method we have defined
			if (method_exists($this->access, $action)) {
			
				/*** PHP BLACK MAGIC! ***/
				$arr = $this->access->$action(); 	// call the function on APIAccess
				$this->prepare_send( $arr );		// send the data back
			
			// method does not exist		
			} else {
				$this->set_response_forbidden();
			}
		}
	}
	
	// package the "good" data into an appropriate array and send
	private function prepare_send( $data ) {
		$arr = array(
			'DATA' => $data,
			'STATUS' => 200,
			'FORMAT' => self::JSON
		);	
		$this->http_response( $arr ); // send response
	}
}
?>