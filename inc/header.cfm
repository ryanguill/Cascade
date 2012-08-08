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
	<div class="navbar">
		<div class="navbar-inner navbar-fixed-top">
			<div class="container">
				<a class="brand" style="color: ##fff;" href="#application.settings.appBaseDir#/">
					#application.settings.appTitle# 
					<cfif structKeyExists(application.config,"serverName")>
						v#application.config.cascadeVersion# - #application.config.serverName#
					</cfif>
				</a>
				<ul class="nav pull-right">
					<cfif session.login.isLoggedIn()>
						<li><a href="#application.settings.appBaseDir#/">Home</a></li>							
						<cfif session.login.isUserInGroup("ADMIN")>
							<li><a href="#application.settings.appBaseDir#/admin/index.cfm">Admin</a></li>
						</cfif>
						<li><a href="#application.settings.appBaseDir#/remote/">Remote Servers</a></li>
					<cfelseif cgi.SCRIPT_NAME NEQ "#application.settings.appBaseDir#/createConfig.cfm">
						<li><a href="#application.settings.appBaseDir#/login.cfm">Login</a></li>	
					</cfif>
				</ul>
				
			</div>
		</div>
	</div>
</cfoutput>

			