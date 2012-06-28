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
	
	<cfif NOT structKeyExists(url,"userID") OR NOT len(trim(url.userID))>
		<cflocation url="#application.settings.appBaseDir#/admin/userManagement/" />
	</cfif>
	
	<cfinvoke component="#application.daos.userManagement#" method="getUserByUserID" returnvariable="variables.user">
		<cfinvokeargument name="dsn" value="#application.settings.dsn#" />
		<cfinvokeargument name="userID" value="#url.userID#" />
	</cfinvoke>
	
	<cfif NOT variables.user.recordCount>
		<cflocation url="#application.settings.appBaseDir#/admin/userManagement/search.cfm" />
	</cfif>
	
	<cfinvoke component="#application.daos.userManagement#" method="getUserGroupsForUserID" returnvariable="variables.groups">
		<cfinvokeargument name="dsn" value="#application.settings.dsn#" />
		<cfinvokeargument name="userID" value="#url.userID#" />
	</cfinvoke>
	
	<cfinvoke component="#application.daos.userManagement#" method="getAvailableUserGroupsForUserID" returnvariable="variables.availableUserGroups">
		<cfinvokeargument name="dsn" value="#application.settings.dsn#" />
		<cfinvokeargument name="userID" value="#url.userID#" />
	</cfinvoke>
	
	
</cfsilent>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
	<head>
		
		<cfinclude template="#application.settings.appBaseDir#/inc/head.cfm" />
		<cfoutput>
			<title>#application.settings.appTitle# - Admin - Manage Users - View User: #variables.user.username#</title>
		</cfoutput>
		
		<script type="text/javascript">
		
			$( init );
	
			function init() {
				$('#showPasswords').bind('change',showPasswords_onChange);
				$('#password2').bind('keyup',checkPasswords);
				$('#password').bind('keyup',checkPasswords);
				$('#password2').bind('blur',checkPasswords);
				$('#password').bind('blur',checkPasswords);
				
				
				showPasswords_onChange();	
			}		
			
			
			function showPasswords_onChange ( )
			{
				if ( $('#showPasswords').is(':checked') )
				{
					$('#password').get(0).type = 'text';
					$('#password2').get(0).type = 'text';
				}
				else
				{
					$('#password').get(0).type = 'password';
					$('#password2').get(0).type = 'password';
				}
			}
			
			function checkPasswords(){
				doPasswordsMatch = true;
				
				if ($('#password').val().length > 0 && $('#password2').val().length > 0) {
					if ($('#password').val() != $('#password2').val()) {
						doPasswordsMatch = false;
					}
				}
			
				if ( !doPasswordsMatch )
				{
					$('#password2_cell').addClass('fail');
				}
				else
				{
					$('#password2_cell').removeClass('fail');
				}
				
			}
			
		
			function showUpdateUserForm ()
			{
				$('#updateUserDiv').show();
				$('#showUpdateUserFormLink').hide();
			}
		
			function hideUpdateUserForm ()
			{
				$('#updateUserDiv').hide();
				$('#showUpdateUserFormLink').show();
			}
			
			<cfif variables.availableUserGroups.recordCount>
				function showAddGroupToUserForm ()
				{
					$('#addGroupToUserDiv').show();
					$('#showAddGroupToUserLink').hide();
				}
				
				function hideAddGroupToUserForm ()
				{
					$('#addGroupToUserDiv').hide();
					$('#showAddGroupToUserLink').show();
				}
			</cfif>
			
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
							<h1>Admin - Manage Users - View User: #variables.user.username#</h1>
						</div>					
					
						<div class="contentSection">
							
							<a href="#application.settings.appBaseDir#/admin/userManagement/search.cfm">Back to Admin - Search Users</a>
							<br /><br />
							<h3 class="sectionTitle">User Information</h3>
							<table class="dataTable" width="500">
								<tr>
									<th width="100">
										UserID
									</th>
									<td>
										#variables.user.userID#
									</td>
								</tr>
								<tr>
									<th>
										Username
									</th>
									<td>
										#variables.user.username#
									</td>
								</tr>
								<tr>
									<th>
										Name
									</th>
									<td>
										#variables.user.firstname# #variables.user.lastname#
									</td>
								</tr>
								<tr>
									<th>
										Email
									</th>
									<td>
										#variables.user.email#
									</td>
								</tr>
								<tr>
									<th>
										Created
									</th>
									<td>
										#variables.user.createdBy# - #dateFormat(variables.user.createdOn,application.settings.dateFormat)#
									</td>
								</tr>
								<tr>
									<th>
										Last Updated
									</th>
									<td>
										#variables.user.lastUpdatedBy# - #dateFormat(variables.user.lastUpdatedOn,application.settings.dateFormat)#
									</td>
								</tr>
							</table>
							<br />
							<a href="javascript:showUpdateUserForm()" id="showUpdateUserFormLink">Update User</a>
							
						</div>
						
						<div id="updateUserDiv" class="contentSection" style="display:none;">
							
							<h3 class="sectionTitle">Update User</h3>
							
							<table width="100%">
								<tr>
									<td width="50%" valign="top">
										<form action="action.cfm" method="post">
											<table class="formTable">
												<tr>
													<th>
														Username:
													</th>
													<td>
														<input type="hidden" name="username" id="username" value="#variables.user.username#"/>
														#variables.user.username#
													</td>
												</tr>
												<tr>
													<th>
														Firstname:
													</th>
													<td>
														<input type="text" name="firstname" id="firstname" value="#variables.user.firstname#" size="30" />
													</td>
												</tr>
												<tr>
													<th>
														Lastname:
													</th>
													<td>
														<input type="text" name="lastname" id="lastname" value="#variables.user.lastname#" size="30" />
													</td>
												</tr>
												<tr>
													<th>
														Email:
													</th>
													<td>
														<input type="text" name="email" id="email" value="#variables.user.email#" size="50" />
													</td>
												</tr>
												<tr>
													<th>
														&nbsp;
													</th>
													<td>
														<input type="hidden" name="action" value="updateUser" />
														<input type="hidden" name="userID" value="#variables.user.userID#" />
														<input type="submit" value="Update User" class="button"/>
														&nbsp;&nbsp;<a href="javascript:hideUpdateUserForm()">Cancel</a>
													</td>
												</tr>
											</table>
										</form>
									</td>
									<td width="50%" valign="top">
										<h3 class="sectionTitle">Change User Password</h3>
										<form action="action.cfm" method="post">
											<table class="formTable">
												<tr>
													<th>
														&nbsp;
													</th>
													<td>
														<input type="checkbox" name="showPasswords" id="showPasswords" value="true" />
														<label for="showPasswords">Show Passwords</label>
													</td>
												</tr>
												<tr>
													<th>
														New Password:
													</th>
													<td>
														<input type="password" name="password" id="password" value="" size="45" />
													</td>
												</tr>
												<tr>
													<th>
														New Password again:
													</th>
													<td id="password2_cell">
														<input type="password" name="password2" id="password2" value="" size="45" />
													</td>
												</tr>
												<tr>
													<th>
														&nbsp;
													</th>
													<td>
														<input type="hidden" name="username" id="username" value="#variables.user.username#"/>
														<input type="hidden" name="action" value="updateUserPassword" />
														<input type="hidden" name="userID" value="#variables.user.userID#" />
														<input type="submit" value="Change Password" class="button"/>
														&nbsp;&nbsp;<a href="javascript:hideUpdateUserForm()">Cancel</a>
													</td>
												</tr>
											</table>
										</form>
									</td>
								</tr>
							</table>
						</div>
						
						<div class="contentSection">
							
							<h3 class="sectionTitle">User's Groups</h3>
							<table width="700" class="dataTable">
								<tr>
									<th>
										Group Name
									</th>
									<th>
										Group Description
									</th>
									<th width="200" class="center">
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
											<td class="center">
												<a href="action.cfm?action=removeUserFromGroup&userID=#variables.user.userID#&userGroupID=#variables.groups.userGroupID#&userGroupMemberID=#variables.groups.userGroupMemberID#" class="button">Remove User from Group</a>
											</td>
										</tr>
									</cfloop>
								<cfelse>
									<tr>
										<td colspan="3" class="center"">
											<em>This user does not belong to any groups.</em>
										</td>
									</tr>
								</cfif>
							</table>
							<br />
							<cfif variables.availableUserGroups.recordCount>
								<a href="javascript:showAddGroupToUserForm()" id="showAddGroupToUserLink">Add Group to User</a>
							</cfif>
							
							<hr />
						</div>
						
						<cfif variables.availableUserGroups.recordCount>
							<div id="addGroupToUserDiv" class="contentSection" style="display:none;">
								
								<h3 class="sectionTitle">Add Group to User</h3>
								
								<form action="action.cfm" method="post">
									<table class="formTable" width="400">
										<tr>
											<th>
												Group:
											</th>
											<td>
												<select name="userGroupID">
													<cfloop query="variables.availableUserGroups">
														<option value="#variables.availableUserGroups.userGroupID#">#variables.availableUserGroups.userGroupName#</option>
													</cfloop>
												</select>
											</td>
										</tr>
										<tr>
											<th>
												&nbsp;
											</th>
											<td>
												<input type="hidden" name="action" value="addUserToGroup" />
												<input type="hidden" name="userID" value="#variables.user.userID#" />
												<input type="submit" value="Add Group to User" class="button" />
												<a href="javascript:hideAddGroupToUserForm()">Cancel</a>
											</td>
										</tr>
									</table>
								</form>
								
							</div>
						</cfif>
					</cfoutput>
				</div>
			</div>
		</div>
		
		<cfinclude template="#application.settings.appBaseDir#/inc/footer.cfm" />
		
		
	</body>
</html>
