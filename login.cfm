
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


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
	<head>
		
		<cfinclude template="#application.settings.appBaseDir#/inc/head.cfm" />
		<cfoutput>
			<title>#application.settings.appTitle# - Please Login</title>
		</cfoutput>
		
		<script type="text/javascript">
		
			Event.observe(window, 'load', init, false);
	
			function init() {
				<cfif len(trim(url.username))>
					$('password').focus();
				<cfelse>
					$('username').focus();
				</cfif>
					
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
						<cfoutput>
							<h1>Welcome to #application.settings.appTitle#</h1>
						</cfoutput>
					</div>
					
					<div id="loginFormDiv" class="contentSection">
						<h2 class="sectionTitle">Please Login</h2>
						
						<cfoutput>
							<form action="action.cfm" method="post">
								<table class="formTable">
									<tr>
										<th>
											Username:
										</th>
										<td>
											<input type="text" name="username" id="username" value="#session.tempFormVars.loginForm.username#" size="45" />
										</td>
									</tr>
									<tr>
										<th>
											Password:
										</th>
										<td>
											<input type="password" name="password" id="password" value="#session.tempFormVars.loginForm.password#" size="45" />
										</td>
									</tr>
									<tr>
										<th>
											&nbsp;
										</th>
										<td>
											<input type="hidden" name="action" value="login" />
											<input type="hidden" name="referringPage" value="#session.login.getReferringPage()#" />
											<input type="submit" value="Login" class="button" />
										</td>
									</tr>								
								</table>
							</cfoutput>
						</form>
					
					</div>
				</div>
			</div>
		</div>
		
		<cfinclude template="#application.settings.appBaseDir#/inc/footer.cfm" />
		
		
	</body>
</html>
