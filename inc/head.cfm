<!--- 
Copyright 2012 Ryan Guill

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
 --->

	<!-- BEGIN HEAD -->
	<meta http-equiv="Pragma" content="no-cache">
	<meta http-equiv="CACHE-CONTROL" content="NO-CACHE">
	<meta http-equiv="EXPIRES" content="0">
	<meta name="ROBOTS" content="NONE">
	<meta name="GOOGLEBOT" content="NOARCHIVE">
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	
	<cfoutput>
		<!---
		<script type="text/javascript" src="#application.settings.appBaseDir#/inc/js/jquery-1.7.1.min.js"></script>
		<script type="text/javascript" src="#application.settings.appBaseDir#/inc/js/jquery-ui-1.8.18.custom.min.js"></script>

		<script type="text/javascript" src="#application.settings.appBaseDir#/inc/js/global.js"></script>
		
		<link rel="stylesheet" media="screen" href="#application.settings.appBaseDir#/inc/css/main.css" />
		<link type="text/css" href="#application.settings.appBaseDir#/inc/css/flick/jquery-ui-1.8.18.custom.css" rel="Stylesheet" />
		
		--->
		
		<link rel="stylesheet" href="#application.settings.appBaseDir#/inc/css/bootstrap.min.css" />
		<cfif application.settings.serverEnviron EQ "PROD">
			<link rel="stylesheet" href="//ajax.googleapis.com/ajax/libs/jqueryui/1/themes/blitzer/jquery-ui.css" />
		<cfelse>
			<link rel="stylesheet" href="#application.settings.appBaseDir#/inc/css/jquery-ui.css" />
		</cfif>
		
		 <style type="text/css">
	      body {
	        padding-top: 0px;
	        padding-bottom: 40px;
	      }
		  ##mainContainer {
		  	padding-top:60px;
			}
		
	    </style>
   
		<link rel="stylesheet"href="#application.settings.appBaseDir#/inc/css/bootstrap-responsive.min.css" />
		
	</cfoutput>
	<!-- END HEAD -->