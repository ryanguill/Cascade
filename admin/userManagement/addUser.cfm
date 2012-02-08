
<cfsilent>
	<cfset session.login.setCurrentArea("admin") />
	
	<cfinclude template="#application.settings.appBaseDir#/inc/preProcess.cfm" />
	
	<cfif NOT session.login.isUserInGroup("Admin")>
		<cflocation url="#application.settings.appBaseDir#/" />
	</cfif>
	
	<cfparam name="session.tempFormVars" default="#structNew()#" />
	<cfparam name="session.tempFormVars.addUserForm" default="#structNew()#" />
	
	<cfif NOT structKeyExists(session.tempFormVars.addUserForm,"populateTime") OR abs(dateDiff("n",now(),session.tempFormVars.addUserForm.populateTime)) GT 7>
		<cfset structClear(session.tempFormVars.addUserForm) />
	</cfif>
		
	<cfparam name="session.tempFormVars.addUserForm.username" default="" />
	<cfparam name="session.tempFormVars.addUserForm.firstname" default="" />
	<cfparam name="session.tempFormVars.addUserForm.lastname" default="" />
	<cfparam name="session.tempFormVars.addUserForm.email" default="" />
	<cfparam name="session.tempFormVars.addUserForm.showPasswords" default="false" />
	
	
	
</cfsilent>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
	<head>
		
		<cfinclude template="#application.settings.appBaseDir#/inc/head.cfm" />
		<cfoutput>
			<title>#application.settings.appTitle# - Admin - Add User</title>
		</cfoutput>
		
		<script type="text/javascript">
		
			Event.observe(window, 'load', init, false);
	
			function init() {
				$('showPasswords').observe('change',showPasswords_onChange);
				$('password2').observe('keyup',checkPasswords);
				$('password').observe('keyup',checkPasswords);
				$('firstname').observe('keyup',onNameChanges);
				$('lastname').observe('keyup',onNameChanges);
				$('password2').observe('blur',checkPasswords);
				$('password').observe('blur',checkPasswords);
				$('firstname').observe('blur',onNameChanges);
				$('lastname').observe('blur',onNameChanges);
				
				
				showPasswords_onChange();	
				
				$('firstname').focus();
			}		
			
			function showPasswords_onChange ( )
			{
				if ( $('showPasswords').checked == true )
				{
					$('password').type = 'text';
					$('password2').type = 'text';
				}
				else
				{
					$('password').type = 'password';
					$('password2').type = 'password';
				
				}
			}
			
			function checkPasswords(){
				doPasswordsMatch = true;
				
				if ($('password').value.length > 0 && $('password2').value.length > 0) {
					if ($('password').value != $('password2').value) {
						doPasswordsMatch = false;
					}
				}
			
				if ( !doPasswordsMatch )
				{
					$('password2_cell').addClassName('fail');
				}
				else
				{
					$('password2_cell').removeClassName('fail');
				}
				
			}
			
			function onNameChanges ( ) 
			{
				$('username').value = $('firstname').value.toLowerCase() + $('lastname').value.toLowerCase();
				
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
					
					<cfoutput>
					
						<div id="projectHeading">
							<h1>Admin - Add User</h1>
						</div>
						
						<div class="contentSection">
							
							<a href="#application.settings.appBaseDir#/admin/userManagement">Back to Admin - User Management</a>
							<br /><br />
							<form name="addUserForm" action="action.cfm" method="post">
								<table class="formTable">
									<tr>
										<th>
											User Firstname:
										</th>
										<td>
											<input type="text" name="firstname" id="firstname" value="#session.tempFormVars.addUserForm.firstname#" size="45" />
										</td>
									</tr>
									<tr>
										<th>
											User Lastname:
										</th>
										<td>
											<input type="text" name="lastname" id="lastname" value="#session.tempFormVars.addUserForm.lastname#" size="45" />
										</td>
									</tr>
									<tr>
										<th>
											Username:
										</th>
										<td>
											<input type="text" name="username" id="username" value="#session.tempFormVars.addUserForm.username#" size="45" />
										</td>
									</tr>
									<tr>
										<th>
											Email:
										</th>
										<td>
											<input type="text" name="email" id="email" value="#session.tempFormVars.addUserForm.email#" size="45" />
										</td>
									</tr>
									<tr>
										<th>
											&nbsp;
										</th>
										<td>
											<input type="checkbox" name="showPasswords" id="showPasswords" value="true" <cfif session.tempFormVars.addUserForm.showPasswords>checked="true"</cfif> />
											<label for="showPasswords">Show Passwords</label>
										</td>
									</tr>
									<tr>
										<th>
											Password:
										</th>
										<td>
											<input type="password" name="password" id="password" value="" size="45" />
										</td>
									</tr>
									<tr>
										<th>
											Password again:
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
											<input type="hidden" name="action" value="addUser" />
											<input type="submit" value="Add User" />
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
