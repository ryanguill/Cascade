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

	<cfif NOT structKeyExists(url,"serverID") OR NOT isValid("UUID",url.serverID)>
		<cflocation url="#application.settings.appBaseDir#/remote/index.cfm" />
	</cfif>
	
	<cfset url.serverID = trim(url.serverID) />
	
	<cfinvoke component="#application.objs.remoteService#" method="getRemoteServerByServerID" returnvariable="variables.server">
		<cfinvokeargument name="serverID" value="#url.serverID#" />
	</cfinvoke>
	
	<cfinvoke component="#application.objs.remoteService#" method="getRemoteServer_certificationTypes" returnvariable="variables.remoteService_certificationTypes">
		<cfinvokeargument name="serverID" value="#url.serverID#" />
	</cfinvoke>
	
	<cfset variables.certificationIDList = ""/>
	
	<cfif variables.remoteService_certificationTypes.recordCount>
		<cfloop query="variables.remoteService_certificationTypes">
			<cfif variables.remoteService_certificationTypes.includeinremotearchivesearch>
				<cfset variables.certificationIDList = listAppend(variables.certificationIDList,variables.remoteService_certificationTypes.certificationTypeID) />
			</cfif>
		</cfloop>
	</cfif>
	
	<cfif NOT variables.server.recordCount>
		<cflocation url="#application.settings.appBaseDir#/remote/index.cfm" />
	</cfif>
	
	<cftry>
		<cfinvoke webservice="#variables.server.serverURL#" method="getCertificationTypes" returnvariable="variables.certificationTypes" timeout="15">
			<cfinvokeargument name="serverID" value="#application.config.cascadeID#" />
			<cfinvokeargument name="validationCode" value="#variables.server.validationCode#" />
		</cfinvoke>
	<cfcatch>
		
		<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
			<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/archive/action.cfm" />
			<cfinvokeargument name="messageType" value="Error" />
			<cfinvokeargument name="messageText" value="The remote server #variables.server.serverName# is not currently available." />
			<cfinvokeargument name="messageDetail" value="The error code returned was: #cfcatch.message#" />
		</cfinvoke>
		
		<cflocation url="#application.settings.appBaseDir#/remote/browse.cfm" />
		
	</cfcatch>
	</cftry>


</cfsilent>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
	<head>
		
		<cfinclude template="#application.settings.appBaseDir#/inc/head.cfm" />
		<cfoutput>
			<title>#application.settings.appTitle# - Remote Server: #variables.server.serverName#</title>
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
							<h1>Remote Server: #variables.server.serverName#</h1>
						</div>
						
						<div class="contentSection">
							<h3>Server URL: #variables.server.serverURL#</h3>
							
							<h3 class="sectionTitle">Certification Types</h3>
							
							<p>If you do not select any certification types, all certification types will be shown.</p>

							#certificationIDList#
							
							<form action="action.cfm" method="post">
								<table width="600" class="dataTable">
									<tr>
										<th width="50">
											ID
										</th>
										<th>
											CertificationType Name
										</th>
										<th>
											CertificationType Description
										</th>
										<th>
											Abbr
										</th>
										<th width="50">
											Include
										</th>
									</tr>
									<cfloop query="variables.certificationTypes">
										<tr id="displayRow_#variables.certificationTypes.certificationTypeID#" <cfif variables.certificationTypes.currentRow MOD 2 EQ 0>class="alt"</cfif>>
											<td>
												#variables.certificationTypes.certificationTypeID#
											</td>
											<td>
												#variables.certificationTypes.certificationTypeName#
											</td>
											<td>
												#variables.certificationTypes.certificationTypeDesc#
											</td>
											<td>
												#variables.certificationTypes.certificationTypeAbbr#
											</td>
											<td>
												<input type="checkbox" name="certid" value="#variables.certificationTypes.certificationTypeID#" <cfif listContains(variables.certificationIDList,variables.certificationTypes.certificationTypeID)>checked="true"</cfif> />
											</td>
										</tr>
									</cfloop>
								</table>
								
								<input type="hidden" name="action" value="setRemoteServerCertificationTypes" />
								<input type="hidden" name="serverID" value="#url.serverID#" />
								<input type="submit" value="Update" />
							</form>
							
						</div>
					
					</cfoutput>
				</div>
			</div>
		</div>
		
		<cfinclude template="#application.settings.appBaseDir#/inc/footer.cfm" />
		
		
	</body>
</html>

















