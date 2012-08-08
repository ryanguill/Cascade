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
	
	<cfset session.login.setCurrentArea("archive") />
	
	<cfinvoke component="#application.daos.cascade#" method="getAllDeployments" returnvariable="variables.deployments">
		<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
	</cfinvoke>
	
</cfsilent>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
	<head>
		
		<cfinclude template="#application.settings.appBaseDir#/inc/head.cfm" />
		<cfoutput>
			<title>#application.settings.appTitle#</title>
		</cfoutput>
		
		<script type="text/javascript">
		
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
							<h1>Deployment Report (Deployed to #application.config.serverName#)</h1>
						</div>
						
						<table class="dataTable" width="100%">
							<tr>
								<!---
								<th>
									deploymentid
								</th>
								--->
								<th>
									archiveid
								</th>
								<!---
								<th>
									archiveshahash
								</th>
								--->
								<!---
								<th>
									buildsystemname
								</th>
								<th>
									deployedsystemname
								</th>

								<th>
									deployedbyuserid
								</th>
								--->
								<th>
									deployedbyusername
								</th>
								<!---
								<th>
									deployedbyuserfullname
								</th>
								<th>
									deployedbyuseremail
								</th>
								--->
								<th>
									deployedon
								</th>
								<th>
									deploymentdir
								</th>
								<!---
								<th>
									deploymentnotes
								</th>
								<th>
									wasbackuptaken
								</th>
								<th>
									backuparchiveid
								</th>
								--->
							</tr>
							<cfif variables.deployments.recordCount>
								<cfloop query="variables.deployments">
									<tr <cfif variables.deployments.currentrow MOD 2 EQ 0>class="alt"</cfif>>
										<!---
										<td>
											#variables.deployments.deploymentid#
										</td>
										--->
										<td>
											#variables.deployments.archiveid#
										</td>
										<!---
										<td>
											#variables.deployments.archiveshahash#
										</td>
										<td>
											#variables.deployments.buildsystemname#
										</td>
										<td>
											#variables.deployments.deployedsystemname#
										</td>
										<td>
											#variables.deployments.deployedbyuserid#
										</td>
										--->
										<td>
											#variables.deployments.deployedbyusername#
										</td>
										<!---
										<td>
											#variables.deployments.deployedbyuserfullname#
										</td>
										<td>
											#variables.deployments.deployedbyuseremail#
										</td>
										--->
										<td>
											#variables.deployments.deployedon#
										</td>
										<td>
											#variables.deployments.deploymentdir#
										</td>
										<!---
										<td>
											#variables.deployments.deploymentnotes#
										</td>
										<td>
											#variables.deployments.wasbackuptaken#
										</td>
										<td>
											#variables.deployments.backuparchiveid#
										</td>
										--->
									</tr>
								</cfloop>
							<cfelse>
								<tr>
									<td colspan="14">
										<p>No Records Returned</p>
									</td>
								</tr>
							</cfif>
						</table>

						
					
					</cfoutput>
				</div>
			</div>
		</div>
		
		<cfinclude template="#application.settings.appBaseDir#/inc/footer.cfm" />
		
		
	</body>
</html>
















