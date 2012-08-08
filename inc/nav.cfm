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

<!-- BEGIN NAV -->
<cfoutput>
	<div id="nav" class="span3">
			
		<cfif session.login.isLoggedIn()>
			<div class="well">
				Welcome #session.login.getFirstname()# #session.login.getLastName()#<br />
				<a href="#application.settings.appBaseDir#/action.cfm?action=logout" />Logout</a>
			</div>
		</cfif>
		
		
		<cfif session.login.getCurrentArea() EQ "Admin">
			
				<ul class="nav nav-list">
					<li class="nav-header">Reference Tables:</li>
					
					<li><a href="#application.settings.appBaseDir#/admin/referenceTables/changeTypes.cfm">Change Types</a></li>
					<li><a href="#application.settings.appBaseDir#/admin/referenceTables/certificationTypes.cfm">Certification Types</a></li>
				</ul>
			
				<ul class="nav nav-list">
					<li class="nav-header">Manage Users:</li>
					
					<li><a href="#application.settings.appBaseDir#/admin/userManagement/search.cfm?">Search Users</a></li>
					<li><a href="#application.settings.appBaseDir#/admin/userManagement/addUser.cfm">Add a User</a></li>
					<li><a href="#application.settings.appBaseDir#/admin/userManagement/userGroups.cfm">User Groups</a></li>	
				</ul>
			
				<ul class="nav nav-list">
					<li class="nav-header">Other Admin:</li>
					
					<li><a href="#application.settings.appBaseDir#/admin/viewConfig.cfm">View Config</a></li>	
				</ul>
			
		</cfif>
		
		
		<cfif session.login.isLoggedIn()>
			
				<ul class="nav nav-list">
					<li class="nav-header">Useful Links:</li>
					<cfif session.login.isUserInGroup("build")>
						<li><a href="#application.settings.appBaseDir#/archive/build.cfm">Build a New Archive</a></li>
					</cfif>
					<cfif session.login.isUserInGroup("Upload")>
						<li><a href="#application.settings.appBaseDir#/archive/upload.cfm">Upload an Archive</a></li>
					</cfif>
					<li><a href="#application.settings.appBaseDir#/archive/browse.cfm">Browse Archives</a></li>
					<li><a href="#application.settings.appBaseDir#/archive/search.cfm">Search Archives</a></li>
					<li><a href="#application.settings.appBasedir#/archive/deployments.cfm">Deployment Report</a></li>
				</ul>
			
		</cfif>
		
		
		<cfif session.login.isLoggedIn()>
			
				<ul class="nav nav-list">
					<li class="nav-header">Remote Servers:</li>
					
					<li><a href="#application.settings.appBaseDir#/remote/index.cfm">Remote Servers Home</a></li>
					<cfif session.login.isUserInGroup("admin")>
						<li><a href="#application.settings.appBaseDir#/remote/register.cfm">Register Remote Server</a></li>
					</cfif>	
				</ul>
			
				<cfinvoke component="#application.objs.remoteService#" method="getRemoteServers" returnvariable="variables.remoteServers" />
				<!---<cfset variables.remoteServersList = valueList(variables.remoteServers.serverName) />--->
			
				<cfif variables.remoteServers.recordCount>
					<ul class="nav nav-list">
						<li class="nav-header">Remote Server Listing:</li>
						
						<cfloop query="variables.remoteServers">
							<li><cftooltip tooltip="#variables.remoteServers.serverName#"><a href="#application.settings.appBaseDir#/remote/server.cfm?serverid=#variables.remoteServers.serverID#">#left(variables.remoteServers.serverName,20)#<cfif len(variables.remoteServers.serverName) GT 20>...</cfif></a></cftooltip></li>
						</cfloop>
					</ul>
				</cfif>
			
		</cfif>
		
	</div>
</cfoutput>
<!-- END NAV -->