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


<cfsilent>
	<cfset session.login.setCurrentArea("admin") />
	
	<cfinclude template="#application.settings.appBaseDir#/inc/preProcess.cfm" />
	
	<cfif NOT session.login.isUserInGroup("Admin")>
		<cflocation url="#application.settings.appBaseDir#/" />
	</cfif>
	
	<cfparam name="url.q" default="" />
	
	<cfinvoke component="#application.daos.userManagement#" method="searchUsers" returnvariable="variables.users">
		<cfinvokeargument name="dsn" value="#application.settings.dsn#" />
		<cfinvokeargument name="searchString" value="#url.q#" />
	</cfinvoke>
	
</cfsilent>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
	<head>
		
		<cfinclude template="#application.settings.appBaseDir#/inc/head.cfm" />
		<cfoutput>
			<title>#application.settings.appTitle# - Admin - Manage Users - Search Users</title>
		</cfoutput>
		
		<script type="text/javascript">
		/*
			Event.observe(window, 'load', init, false);
	
			function init() {
			
			}		
		*/	
		</script>
		
		<style type="text/css">
	
		</style>
		
	</head>
	<body>
		<div id="container">
		
			<cfinclude template="#application.settings.appBaseDir#/inc/header.cfm" />
			
			<div id="main" class="clearfix">
				<cfinclude template="#application.settings.appBaseDir#/inc/nav.cfm" />
				
				<div id="content">
					
					<cfinclude template="#application.settings.appBaseDir#/inc/notice.cfm" />
					
					<div id="projectHeading">
						<h1>Admin - Manage Users - Search Users</h1>
					</div>
					
					<cfoutput>
						<div class="contentSection">
							
							<a href="#application.settings.appBaseDir#/admin/userManagement">Back to Admin - User Management</a>
							<br /><br />
							<form action="search.cfm" method="get">
								<table class="formTable">
									<tr>
										<th>
											Search String:
										</th>
										<td style="border:none;">
											<input type="text" name="q" value="#url.q#" size="45" />
										</td>
										<td style="border:none;">
											<input type="submit" value="Search" class="button" />
										</td>
									</tr>
								</table>
							</form>

								
								<h3>Results</h3>
								
								<table width="100%" class="dataTable">
									<tr>
										<th width="120">
											Username
										</th>
										<th width="120">
											Name
										</th>
										<th>
											Email
										</th>
										<th class="date" width="75">
											Updated
										</th>
										<th width="50">
											&nbsp;	
										</th>
									</tr>
									<cfif variables.users.recordCount>
										<cfloop query="variables.users">
											<tr <cfif variables.users.currentRow MOD 2 EQ 0>class="alt"</cfif>>
												<td>
													<a href="#application.settings.appBaseDir#/admin/userManagement/user.cfm?userID=#variables.users.userID#">#variables.users.username#</a>
												</td>
												<td>
													#variables.users.firstname# #variables.users.lastname#
												</td>
												<td>
													#variables.users.email#
												</td>
												<td class="date"">
													#dateFormat(variables.users.lastUpdatedOn,application.settings.dateFormat)#
												</td>
												<td>
													<a href="#application.settings.appBaseDir#/admin/userManagement/user.cfm?userID=#variables.users.userID#" class="button">View</a>
												</td>
											</tr>	
										</cfloop>
									<cfelse>
										<tr>
											<td colspan="5">
													<em>No records matched your search...</em>
											</td>
										</tr>
									</cfif>
								</table>
								
							
						</div>
					</cfoutput>
				</div>
			</div>
		</div>
		
		<cfinclude template="#application.settings.appBaseDir#/inc/footer.cfm" />
		
		
	</body>
</html>
