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

<cfif session.messenger.hasAlerts()>
	
	<cfparam name="variables.i" default="0" />
	<cfset variables.alerts = session.messenger.getAlerts() />
				
	<cfoutput>
					
		<cfloop from="1" to="#session.messenger.alertsLen()#" index="variables.i">
			<cfswitch expression="#variables.alerts[variables.i].messageType#">
				<cfcase value="Error">
					<div class="alert alert-error">
						<h2>#variables.alerts[variables.i].messageText#</h2>
						<p>#variables.alerts[variables.i].messageDetail#</p>
					</div>
				</cfcase>
				<cfcase value="Warning">
					<div class="alert">
						<h2>#variables.alerts[variables.i].messageText#</h2>
						<p>#variables.alerts[variables.i].messageDetail#</p>
					</div>
				</cfcase>
				<cfcase value="Information">
					<div class="alert alert-info">
						<h2>#variables.alerts[variables.i].messageText#</h2>
						<p>#variables.alerts[variables.i].messageDetail#</p>
					</div>
				</cfcase>
				<cfcase value="Success">
					<div class="alert alert-success">
						<h2>#variables.alerts[variables.i].messageText#</h2>
						<p>#variables.alerts[variables.i].messageDetail#</p>
					</div>
				</cfcase>
				<cfdefaultcase>
				
				</cfdefaultcase>
			</cfswitch>
		</cfloop>
		
	</cfoutput>
	
	<cfset session.messenger.reset() />
	<!--- 
	<cfif comparenocase(cgi.SCRIPT_NAME,"/docsrv/error.cfm") NEQ 0>
		<cfset session.messenger.reset() />
	</cfif> --->
</cfif>