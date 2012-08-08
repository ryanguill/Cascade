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
	<cfset session.login.setCurrentArea("login") />
	
	<cfinclude template="#application.settings.appBaseDir#/inc/preProcess.cfm" />
	
	<cfparam name="url.username" default="" />
	
	<cfparam name="session.tempFormVars" default="#structNew()#" />
	<cfparam name="session.tempFormVars.loginForm" default="#structNew()#" />
	
	<cfif NOT structKeyExists(session.tempFormVars.loginForm,"populateTime") OR abs(dateDiff("n",now(),session.tempFormVars.loginForm.populateTime)) GT 7>
		<cfset structClear(session.tempFormVars.loginForm) />
	</cfif>
		
	<cfparam name="session.tempFormVars.loginForm.username" default="#url.username#" />
	<cfparam name="session.tempFormVars.loginForm.password" default="" />
	
</cfsilent>


<!DOCTYPE html>
<html lang="en">
	<head>
		
		<cfinclude template="#application.settings.appBaseDir#/inc/head.cfm" />
		
		<cfoutput>
			<title>#application.settings.appTitle# - Please Login</title>
		</cfoutput>
		
		
		
		<style type="text/css">
	
		</style>
		
	</head>
	<body>
		
		<cfinclude template="#application.settings.appBaseDir#/inc/header.cfm" />
			
		<div class="container" id="mainContainer">
  			<div class="row">
				<cfinclude template="#application.settings.appBaseDir#/inc/nav.cfm" />
				
				<div id="content" class="span9">
					
					<cfinclude template="#application.settings.appBaseDir#/inc/notice.cfm" />
					
					<div class="well">
						<cfoutput>
							<h1>Welcome to #application.settings.appTitle#</h1>
						</cfoutput>
					</div>
					
					<section>
						
						
						<cfoutput>
							<form action="action.cfm" method="post" class="form-horizontal">
								<fieldset>
									<legend>Please Login</legend>
									<div class="control-group">
										<label class="control-label" for="username">Username:</label>
										<div class="controls">
											<input type="text" name="username" id="username" value="#session.tempFormVars.loginForm.username#" size="45" class="input-xlarge" />
										</div>
									</div>
									<div class="control-group">
										<label class="control-label" for="password">Password:</label>
										<div class="controls">
											<input type="password" name="password" id="password" value="#session.tempFormVars.loginForm.password#" size="45" />
										</div>
									</div>
									<div class="form-actions">
										<input type="hidden" name="action" value="login" />
										<input type="hidden" name="referringPage" value="#session.login.getReferringPage()#" />
										<input type="submit" value="Login" class="btn btn-primary" />
									</div>
								</fieldset>
							</form>
						</cfoutput>
					
					</section>
				</div>
			</div>
	
		
			<cfinclude template="#application.settings.appBaseDir#/inc/footer.cfm" />
			
			<script type="text/javascript">
			
				$( init );
		
				function init() {
					<cfif len(trim(url.username))>
						$('#password').focus();
					<cfelse>
						$('#username').focus();
					</cfif>
				}		
				
			</script>
			
		</div>
		
	</body>
</html>
