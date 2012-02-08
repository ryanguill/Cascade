
<cfsilent>
	<cfset session.login.setCurrentArea("admin") />
		
	<cfinclude template="#application.settings.appBaseDir#/inc/preProcess.cfm" />
	
	<cfif NOT session.login.isUserInGroup("Admin")>
		<cflocation url="#application.settings.appBaseDir#/" />
	</cfif>
	
	<cfinvoke component="#application.daos.userManagement#" method="getUserGroups" returnvariable="variables.groups">
		<cfinvokeargument name="dsn" value="#application.settings.dsn#" />
	</cfinvoke>
	
	<cfparam name="session.tempFormVars" default="#structNew()#" />
	<cfparam name="session.tempFormVars.addUserGroupForm" default="#structNew()#" />
	
	<cfif NOT structKeyExists(session.tempFormVars.addUserGroupForm,"populateTime") OR abs(dateDiff("n",now(),session.tempFormVars.addUserGroupForm.populateTime)) GT 7>
		<cfset structClear(session.tempFormVars.addUserGroupForm) />
	</cfif>
		
	<cfparam name="session.tempFormVars.addUserGroupForm.userGroupName" default="" />
	<cfparam name="session.tempFormVars.addUserGroupForm.userGroupDesc" default="" />
	
	
</cfsilent>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
	<head>
		
		<cfinclude template="#application.settings.appBaseDir#/inc/head.cfm" />
		<cfoutput>
			<title>#application.settings.appTitle# - Admin - Manage User Groups</title>
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
					
					<cfoutput>
					
						<div id="projectHeading">
							<h1>Admin - Manage User Groups</h1>
						</div>
						
						<div class="contentSection">
							
							<a href="#application.settings.appBaseDir#/admin/userManagement">Back to Admin - User Management</a>
							<br /><br />
							
							<h3 class="sectionTitle">User Groups</h3>
							
							<table class="dataTable" width="100%">
								<tr>
									<th>
										User Group Name
									</th>
									<th>
										User Group Desc
									</th>
									<th>
										Member Count
									</th>
									<th>
										&nbsp;
									</th>
								</tr>
								<cfif variables.groups.recordCount>
									<cfloop query="variables.groups">	
										<tr <cfif variables.groups.currentRow MOD 2 EQ 0>class="alt"</cfif>>
											<td>
												#variables.groups.userGroupName#
											</td>
											<td>
												#variables.groups.userGroupDesc#
											</td>
											<td>
												#variables.groups.memberCount#
											</td>
											<td>
												<cfif variables.groups.memberCount EQ 0>
													<a href="action.cfm?action=removeUserGroup&userGroupID=#variables.groups.userGroupID#" class="button">Remove User Group</a>
												</cfif>
											</td>
										</tr>
									</cfloop>
								<cfelse>
									<tr>
										<td colspan="5">
											<em>There are no user groups... this should never happen.</em>
										</td>
									</tr>
								</cfif>
							</table>
							
							<br />
							
							<h3 class="sectionTitle">Add a New User Group</h3>
							
							<form action="action.cfm" method="post">
								<table class="formTable">
									<tr>
										<th>
											User Group Name
										</th>
										<td>
											<input type="text" name="userGroupName" id="userGroupName" value="#session.tempFormVars.addUserGroupForm.userGroupName#" size="45" maxlength="50" />
										</td>
									</tr>
									<tr>
										<th>
											User Group Desription
										</th>
										<td>
											<input type="text" name="userGroupDesc" id="userGroupDesc" value="#session.tempFormVars.addUserGroupForm.userGroupDesc#" size="45" maxlength="250" />
										</td>
									</tr>
									<tr>
										<th>
											&nbsp;
										</th>
										<td>
											<input type="hidden" name="action" value="addUserGroup" />
											<input type="Submit" value="Add User Group" class="button"/>
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
