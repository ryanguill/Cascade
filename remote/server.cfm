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
	
	<cfif NOT variables.server.recordCount>
		<cflocation url="#application.settings.appBaseDir#/remote/index.cfm" />
	</cfif>
	
	<cftry>
		<cfinvoke webservice="#variables.server.serverURL#" method="getAvailableArchives" returnvariable="variables.archives" timeout="15">
		<!---<cfinvoke component="#application.objs.remoteService#" method="getAvailableArchives" returnvariable="variables.archives">--->
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
							<h1>Remote Server: #variables.server.serverName#</h1>
						</div>
						
						<div class="contentSection">
							<h3>Server URL: #variables.server.serverURL#</h3>
							
							<h3 class="sectionTitle">Browse Archives</h3>
							
							<cfif len(trim(variables.server.minimumCertificationID))>
								<p>Showing archives with a certification level of ____ or higher</p>
							<cfelse>
								<p>Showing all archives regardless of certification level</p>
							</cfif>
							
							<div class="contentSection">
							<table width="100%" class="dataTable">
								<tr>
									<th width="300">
										ID
									</th>
									<!---
									<th width="100">
										SHA
									</th>
									--->
									<th>
										Application
									</th>
									<th width="80">
										Version
									</th>
									<th width="50" class="right">
										Files
									</th>
									<th>
										Build By
									</th>
									<th width="120" class="center">
										Built On
									</th>
									<th width="170">
										Built System
									</th>
								</tr>
								<cfif variables.archives.recordCount>
									<cfloop query="variables.archives">
										<!--- check to see if we already have this archive in this system --->
										<cfinvoke component="#application.daos.cascade#" method="getArchiveByArchiveID" returnvariable="variables.localArchive">
											<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
											<cfinvokeargument name="archiveID" value="#variables.archives.archiveID#" />	<!---Type:string  --->
										</cfinvoke>
										
										<tr <cfif variables.archives.currentRow MOD 2 EQ 0>class="alt"</cfif>>
											<td class="monospace">
												<a href="#application.settings.appBaseDir#/remote/archive.cfm?serverID=#url.serverID#&archiveID=#variables.archives.archiveID#">#variables.archives.archiveID#</a>
											</td>
											<!---
											<td class="monospace">
												<cftooltip tooltip="#lcase(variables.archives.archiveSHAHAsh)#">#lcase(left(variables.archives.archiveSHAHash,application.settings.showFirstXCharsOfSHA))#</cftooltip>
											</td>
											--->
											<td class="<cfif variables.localArchive.recordCount>pass</cfif>">
												#variables.archives.applicationName#
											</td>
											<td class="<cfif variables.localArchive.recordCount>pass<cfelseif variables.archives.isObsolete>fail</cfif>">
												#variables.archives.versionName#
											</td>
											<td class="right">
												#numberFormat(variables.archives.fileCount)#
											</td>
											<td>
												#variables.archives.buildByUserFullname#
											</td>
											<td class="center">
												#application.objs.global.formatDate(variables.archives.buildOn)# #application.objs.global.formatTime(variables.archives.buildOn)#
											</td>
											<td>
												<cftooltip tooltip="#variables.archives.buildSystemName#">#left(variables.archives.buildSystemName,20)#<cfif len(variables.archives.buildSystemName) GT 20>...</cfif></a></cftooltip>
											</td>
										</tr>
									</cfloop>
								<cfelse>
									<tr>
										<td colspan="7">
											<em>There are no archives available from this system.</em>
										</td>
									</tr>
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

















