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
	<cfinclude template="#application.settings.appBaseDir#/inc/preProcess.cfm" />
	
	<cfif application.objs.global.doesConfigXMLExist()>
		<cflocation url="#application.settings.appBaseDir#/index.cfm" />
	</cfif>
	
	<cfparam name="session.tempFormVars" default="#structNew()#" />
	<cfparam name="session.tempFormVars.createConfigForm" default="#structNew()#" />
	
	<cfif NOT structKeyExists(session.tempFormVars.createConfigForm,"populateTime") OR abs(dateDiff("n",now(),session.tempFormVars.createConfigForm.populateTime)) GT 7>
		<cfset structClear(session.tempFormVars.createConfigForm) />
	</cfif>
	
	<cfset variables.appBaseDirDepth = listLen(expandPath(application.settings.appBaseDir),application.settings.pathSeperator)>
	<cfset variables.databaseDefaultPath = listDeleteAt(expandPath(application.settings.appBaseDir),variables.appBaseDirDepth,application.settings.pathSeperator) & application.settings.pathSeperator & "db" & application.settings.pathSeperator />
	
	
		
	<cfparam name="session.tempFormVars.createConfigForm.servername" default="" />
	<cfparam name="session.tempFormVars.createConfigForm.firstname" default="" />
	<cfparam name="session.tempFormVars.createConfigForm.lastname" default="" />
	<cfparam name="session.tempFormVars.createConfigForm.username" default="" />
	<cfparam name="session.tempFormVars.createConfigForm.email" default="" />
	<cfparam name="session.tempFormVars.createConfigForm.showPasswords" default="false" />
	<cfparam name="session.tempFormVars.createConfigForm.password" default="" />
	<cfparam name="session.tempFormVars.createConfigForm.password2" default="" />
	<cfparam name="session.tempFormVars.createConfigForm.archiveDirectory" default="" />
	<cfparam name="session.tempFormVars.createConfigForm.cfAdminPassword" default="" />
	<cfparam name="session.tempFormVars.createConfigForm.dsnName" default="cascade" />
	<cfparam name="session.tempFormVars.createConfigForm.databaseName" default="cascade" />
	<cfparam name="session.tempFormVars.createConfigForm.databaseDirectory" default="#variables.databaseDefaultPath#" />
	
	
</cfsilent>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
	<head>
		
		<cfinclude template="#application.settings.appBaseDir#/inc/head.cfm" />
		<cfoutput>
			<title>#application.settings.appTitle# - Create Config</title>
		</cfoutput>
		
		<script type="text/javascript">
		
			Event.observe(window, 'load', init, false);
			
			function init() {
				$('showPasswords').observe('change',showPasswords_onChange);
				$('password2').observe('keyup',checkPasswords);
				$('password').observe('keyup',checkPasswords);
				$('firstname').observe('keyup',onAdminNameChanges);
				$('lastname').observe('keyup',onAdminNameChanges);
				$('dsnName').observe('keyup',onDSNNameChange);
				
				$('password2').observe('blur',checkPasswords);
				$('password').observe('blur',checkPasswords);
				$('firstname').observe('blur',onAdminNameChanges);
				$('lastname').observe('blur',onAdminNameChanges);
				
				$('databaseName').observe('keyup',onDatabaseFullPathChange);
				$('databaseDirectory').observe('keyup',onDatabaseFullPathChange);
				
				
				
				showPasswords_onChange();
				onDatabaseFullPathChange();
				
				$('serverName').focus();
			}		
			
			function showPasswords_onChange ( )
			{
				if ( $('showPasswords').checked == true )
				{
					$('password').type = 'text';
					$('password2').type = 'text';
					$('cfAdminPassword').type = 'text';
				}
				else
				{
					$('password').type = 'password';
					$('password2').type = 'password';
					$('cfAdminPassword').type = 'password';
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
			
			function onAdminNameChanges ( ) 
			{
				$('username').value = $('firstname').value.toLowerCase() + $('lastname').value.toLowerCase();
				
			}
			
			function onDSNNameChange ( )
			{
				$('databaseName').value = $('dsnName').value;
			}
			
			function onDatabaseFullPathChange ( )
			{
				$('databaseFullPath').update($('databaseDirectory').value + $('databaseName').value);
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
							<h1>Welcome to #application.settings.appTitle#!</h1>
						</div>
						
						<div class="contentSection">
							<p>Since this is the first run of this application, you will be asked for some initial configuration settings.  If you do not know what these values should be, please exit the application and refer to the documentation.  You will be asked for these values again the next time.</p>
							<!---<p>Don't worry though, if you do something wrong you will always be able to change these values later, just dont forget the admin username and password!</p>--->
						</div>
						
						<div id="configFormDiv" class="contentSection">
							<h2 class="sectionTitle">Create Initial Configuration</h2>
							
							<cfoutput>
								<form action="action.cfm" method="post">
									<table class="formTable" width="100%">
										<tr>
											<th valign="top">
												Server Name:
											</th>
											<td valign="top">
												<input type="text" name="serverName" id="serverName" value="#session.tempFormVars.createConfigForm.servername#" size="60" />
											</td>
											<td class="note" width="30%">
												<em>This name will be on all archives created, and is how remote systems will identify this installation.</em>
											</td>
										</tr>
										<tr>
											<th valign="top">
												Admin User Firstname:
											</th>
											<td valign="top">
												<input type="text" name="firstname" id="firstname" value="#session.tempFormVars.createConfigForm.firstname#" size="45" />
											</td>
											<td class="note">
												&nbsp;
											</td>
										</tr>
										<tr>
											<th valign="top">
												Admin User Lastname:
											</th>
											<td valign="top">
												<input type="text" name="lastname" id="lastname" value="#session.tempFormVars.createConfigForm.lastname#" size="45" />
											</td>
											<td class="note">
												&nbsp;
											</td>
										</tr>
										<tr>
											<th valign="top">
												Admin Username:
											</th>
											<td valign="top">
												<input type="text" name="username" id="username" value="#session.tempFormVars.createConfigForm.username#" size="45" />
											</td>
											<td class="note">
												&nbsp;
											</td>
										</tr>
										<tr>
											<th valign="top">
												Admin Email:
											</th>
											<td valign="top">
												<input type="text" name="email" id="email" value="#session.tempFormVars.createConfigForm.email#" size="45" />
											</td>
											<td class="note">
												&nbsp;
											</td>
										</tr>
										<tr>
											<th valign="top">
												&nbsp;
											</th>
											<td valign="top">
												<input type="checkbox" name="showPasswords" id="showPasswords" value="true" <cfif session.tempFormVars.createConfigForm.showPasswords>checked="true"</cfif> />
												<label for="showPasswords">Show Passwords</label>
											</td>
											<td class="note">
												<em>Check this box to see the passwords as you type them in.</em>
											</td>
										</tr>
										<tr>
											<th valign="top">
												Admin Password:
											</th>
											<td valign="top">
												<input type="password" name="password" id="password" value="#session.tempFormVars.createConfigForm.password#" size="45" />
											</td>
											<td class="note">
												&nbsp;
											</td>
										</tr>
										<tr>
											<th valign="top">
												Admin Password again:
											</th>
											<td id="password2_cell" valign="top">
												<input type="password" name="password2" id="password2" value="#session.tempFormVars.createConfigForm.password2#" size="45" />
											</td>
											<td class="note">
												&nbsp;
											</td>
										</tr>
										<tr>
											<th valign="top">
												Archive Directory:
											</th>
											<td valign="top">
												<input type="text" name="archiveDirectory" id="archiveDirectory" value="#session.tempFormVars.createConfigForm.archiveDirectory#" size="60" />
											</td>
											<td class="note">
												<em>This is the directory where the archive files will be stored. It is suggested to not have this directory in your webroot.</em>
											</td>
										</tr>
										<tr>
											<th valign="top">
												ColdFusion Administrator Password:
											</th>
											<td valign="top">
												<input type="password" name="cfAdminPassword" id="cfAdminPassword" value="#session.tempFormVars.createConfigForm.cfAdminPassword#" size="45" />
											</td>
											<td class="note">
												<em>This is the only time you will be asked to enter this password.  It is only used to create the derby database and set up the DSN. It is not stored.</em>
											</td>
										</tr>
										<tr>
											<th valign="top">
												DerbyDB DSN Name:
											</th>
											<td valign="top">
												<input type="text" name="dsnName" id="dsnName" value="#session.tempFormVars.createConfigForm.dsnName#" size="45" />
											</td>
											<td class="note">
												&nbsp;
											</td>
										</tr>
										<tr>
											<th valign="top">
												DerbyDB Database Name:
											</th>
											<td valign="top">
												<input type="text" name="databaseName" id="databaseName" value="#session.tempFormVars.createConfigForm.databaseName#" size="45" />
											</td>
											<td class="note">
												&nbsp;
											</td>
										</tr>
										<tr>
											<th valign="top">
												DerbyDB Database Directory:
											</th>
											<td valign="top">
												<input type="text" name="databaseDirectory" id="databaseDirectory" value="#session.tempFormVars.createConfigForm.databaseDirectory#" size="60" />
											</td>
											<td class="note">
												<em>This is the directory the DerbyDB will be created in. It is suggested to not have this directory in your webroot.</em>
											</td>
										</tr>
										<tr>
											<th valign="top">
												Full Path To Derby DB:
											</th>
											<td valign="top">
												<span id="databaseFullPath" style="font-weight:bold;"></span>
											</td>
										</tr>
										<tr>
											<th valign="top">
												&nbsp;
											</th>
											<td>
												<input type="hidden" name="action" value="createConfig" />
												<input type="hidden" name="referringPage" value="#request.currentPage#" />
												<input type="submit" value="Create Config" class="button" />
											</td>
										</tr>								
									</table>
								</cfoutput>
							</form>
						
						</div>
					</cfoutput>
				</div>
			</div>
		</div>
		
		<cfinclude template="#application.settings.appBaseDir#/inc/footer.cfm" />
		
		
	</body>
</html>
