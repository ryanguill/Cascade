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
	
	<cfset session.login.setCurrentArea("remote") />
	
	<!---<cfinvoke component="#application.objs.remoteService#" method="getRemoteServers" returnvariable="variables.remoteServers" />--->
	
</cfsilent>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
	<head>
		
		<cfinclude template="#application.settings.appBaseDir#/inc/head.cfm" />
		<cfoutput>
			<title>#application.settings.appTitle# - Browse Remote Servers</title>
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
							<h1>Browse Remote Servers</h1>
						</div>
						
						<div class="contentSection">
							
							<table width="100%" class="dataTable">
								<tr>
									<th width="300">
										Server Name
									</th>
									<th>
										Server URL
									</th>
								</tr>
								<cfif variables.remoteServers.recordCount>
									<cfloop query="variables.remoteServers">
										<tr>
											<td>
												<a href="#application.settings.appBaseDir#/remote/server.cfm?serverID=#variables.remoteServers.serverID#">#variables.remoteServers.serverName#</a>
											</td>
											<td>
												<a href="#variables.remoteServers.serverURL#">#variables.remoteServers.serverURL#</a>
											</td>
										</tr>
									</cfloop>
								<cfelse>
									<tr>
										<td colspan="2">
											<em>There are no registered remote servers at this time.</em>
										</td>
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