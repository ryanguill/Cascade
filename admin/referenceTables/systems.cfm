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
	
	<cfif NOT session.login.isUserInGroup("ADMINISTRATORS")>
		<cflocation url="#application.settings.appBaseDir#/" />
	</cfif>
	
	<cfinvoke component="#application.daos.referenceTables#" method="getAllSystems" returnvariable="variables.systems">
		<cfinvokeargument name="dsn" value="#application.settings.dsn#" />
	</cfinvoke>
	
	
	<cfparam name="session.tempFormVars" default="#structNew()#" />
	<cfparam name="session.tempFormVars.createSystemForm" default="#structNew()#" />
	
	<cfif NOT structKeyExists(session.tempFormVars.createSystemForm,"populateTime") OR abs(dateDiff("n",now(),session.tempFormVars.createSystemForm.populateTime)) GT 7>
		<cfset structClear(session.tempFormVars.createSystemForm) />
	</cfif>
		
	<cfparam name="session.tempFormVars.createSystemForm.systemName" default="" />
	<cfparam name="session.tempFormVars.createSystemForm.systemDesc" default="" />
	<cfparam name="session.tempFormVars.createSystemForm.systemAbbr" default="" />
	
</cfsilent>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
	<head>
		
		<cfinclude template="#application.settings.appBaseDir#/inc/head.cfm" />
		<cfoutput>
			<title>#application.settings.appTitle# - Admin - Manage Reference Tables - System</title>
		</cfoutput>
		
		<script type="text/javascript">
		
			function showUpdateRow ( _rowID )
			{
				$('#displayRow_' + _rowID).hide();
				$('#updateRow_' + _rowID).show();
			}
		
			function hideUpdateRow ( _rowID )
			{
				$('#displayRow_' + _rowID).show();
				$('#updateRow_' + _rowID).hide();
			}
			
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
						<h1>Admin - Manage Reference Tables - System</h1>
					</div>
					
					<cfoutput>
						<div class="contentSection">
							
							<a href="#application.settings.appBaseDir#/admin/referenceTables/">Back to Admin - Manage Reference Tables</a>
							<br /><br />
							<h3 class="sectionTitle">System</h3>
							
							<table width="100%" class="dataTable">
								<tr>
									<th width="50">
										ID
									</th>
									<th>
										System Name
									</th>
									<th>
										System Description
									</th>
									<th>
										Abbr
									</th>
									<th width="40" class="center">
										Active
									</th>
									<th width="40" class="center">
										Sort
									</th>
									<th colspan="2" class="center">
										Reorder
									</th>
									<th width="200">
										&nbsp;
									</th>
								</tr>
								<cfloop query="variables.systems">
									<tr id="displayRow_#variables.systems.systemID#" <cfif variables.systems.currentRow MOD 2 EQ 0>class="alt"</cfif>>
										<td>
											#variables.systems.systemID#
										</td>
										<td>
											#variables.systems.systemName#
										</td>
										<td>
											#variables.systems.systemDesc#
										</td>
										<td>
											#variables.systems.systemAbbr#
										</td>
										<td class="center">
											#yesNoFormat(variables.systems.activeFlag)#
										</td>
										<td class="center">
											#variables.systems.sort#
										</td>
										<td class="center" width="40">
											<cfif variables.systems.currentRow NEQ 1>
												<a href="action.cfm?action=moveSystem&dir=UP&systemID=#variables.systems.systemID#">Up</a>
											</cfif>
										</td>
										<td class="center" width="40">
											<cfif variables.systems.currentRow NEQ variables.systems.recordCount>
												<a href="action.cfm?action=moveSystem&dir=DOWN&systemID=#variables.systems.systemID#">Down</a>
											</cfif>
										</td>
										<td>
											<a href="javascript:showUpdateRow(#variables.systems.systemID#);" class="button">Update</a>
										</td>
									</tr>
									<form action="action.cfm" method="post">
										<tr id="updateRow_#variables.systems.systemID#" style="display:none;">
											<td>
												<input type="hidden" name="systemID" value="#variables.systems.systemID#" />
												#variables.systems.systemID#
											</td>
											<td>
												<input type="text" name="systemName" value="#variables.systems.systemName#" size="30" />
											</td>
											<td>
												<input type="text" name="systemDesc" value="#variables.systems.systemDesc#" size="30" />
											</td>
											<td>
												<input type="text" name="systemAbbr" value="#variables.systems.systemAbbr#" size="10" />
											</td>
											<td class="center">
												<input name="activeFlag" type="checkbox" value="true" <cfif variables.systems.activeFlag>checked="true"</cfif> />
											</td>
											<td class="center">
												#variables.systems.sort#
											</td>
											<td class="center" width="40">
												&nbsp;
											</td>
											<td class="center" width="40">
												&nbsp;
											</td>
											<td>
												<input type="hidden" name="action" value="updateSystem" />
												<input type="button" class="button" onclick="hideUpdateRow(#variables.systems.systemID#);" value="Cancel" />
												<input type="submit" value="Update" class="button" />
											</td>
										</tr>
									</form>
								</cfloop>
							</table>
							
							<br />
							
							<h3 class="sectionTitle">Add a New System</h3>
							
							<form action="action.cfm" method="post">
								<table class="formTable">
									<tr>
										<th>
											System Name:
										</th>
										<td>
											<input type="input" name="systemName" id="systemName" value="#session.tempFormVars.createSystemForm.systemName#" size="45" />
										</td>
									</tr>
									<tr>
										<th>
											System Description:
										</th>
										<td>
											<input type="input" name="systemDesc" id="systemDesc" value="#session.tempFormVars.createSystemForm.systemDesc#" size="45" />
										</td>
									</tr>
									<tr>
										<th>
											System Abbr:
										</th>
										<td>
											<input type="input" name="systemAbbr" id="systemAbbr" value="#session.tempFormVars.createSystemForm.systemAbbr#" size="45" />
										</td>
									</tr>
									<tr>
										<th>
											&nbsp;
										</th>
										<td>
											<input type="hidden" name="action" value="createSystem" />
											<input type="submit" value="Submit" class="button" />
										</td>
									</tr>
								</table>
							</form>
							
						</div>
					</cfoutput>
				</div>
			</div>
		</div>
		
		<cfinclude template="#application.settings.appBaseDir#/inc/footer.cfm" />
		
		
	</body>
</html>
