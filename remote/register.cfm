
<cfsilent>
	
	<cfinclude template="#application.settings.appBaseDir#/inc/preProcess.cfm" />
	
	<cfset session.login.setCurrentArea("remote") />

	<cfparam name="session.tempFormVars" default="#structNew()#" />
	<cfparam name="session.tempFormVars.registerRemoteServerForm" default="#structNew()#" />
	
	<cfif NOT structKeyExists(session.tempFormVars.registerRemoteServerForm,"populateTime") OR abs(dateDiff("n",now(),session.tempFormVars.registerRemoteServerForm.populateTime)) GT 7>
		<cfset structClear(session.tempFormVars.registerRemoteServerForm) />
	</cfif>
		
	<cfparam name="session.tempFormVars.registerRemoteServerForm.serverURL" default="" />
	<cfparam name="session.tempFormVars.registerRemoteServerForm.validationCode" default="" />
	
</cfsilent>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
	<head>
		
		<cfinclude template="#application.settings.appBaseDir#/inc/head.cfm" />
		<cfoutput>
			<title>#application.settings.appTitle# - Register New Remote Server</title>
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
							<h1>Register a New Remote Server</h1>
						</div>
						
						<div class="contentSection">
							
							<form action="action.cfm" method="post">
								<table width="100%" class="formTable">
									<tr>
										<th width="200">
											Server Remote Service URL:
										</th>
										<td>
											<input type="text" name="serverURL" size="100" value="#session.tempFormVars.registerRemoteServerForm.serverURL#" />
										</td>
									</tr>
									<tr>
										<th>
											Validation Code:
										</th>
										<td>
											<input type="text" name="validationCode" size="60" value="#session.tempFormVars.registerRemoteServerForm.validationCode#" />
										</td>
									</tr>
									<tr>
										<td colspan="2">
											<input type="hidden" name="action" value="registerServer" />
											<input type="submit" value="Register" />
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

















