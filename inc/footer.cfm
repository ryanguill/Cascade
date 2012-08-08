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

<cfoutput>

	<!-- BEGIN FOOTER -->
	<footer>
		&nbsp;
	</footer>
	<!-- END FOOTER -->
	
	<!-- Placed at the end of the document so the pages load faster -->
    <cfif application.settings.serverEnviron EQ "PROD">
		<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
		<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.21/jquery-ui.min.js"></script>
	<cfelse>
		<script type="text/javascript" src="#application.settings.appBaseDir#/inc/js/jquery.min.js"></script>
		<script type="text/javascript" src="#application.settings.appBaseDir#/inc/js/jquery-ui.min.js"></script>
	</cfif>
    <script type="text/javascript" src="#application.settings.appBaseDir#/inc/js/bootstrap.min.js"></script>
</cfoutput>