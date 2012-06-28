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
	
	<cfif NOT structKeyExists(url,"archiveID") OR NOT isValid("UUID",url.archiveID)>
		<cflocation url="#application.settings.appBaseDir#/archive/browse.cfm" />
	</cfif>
	
	<cfinvoke component="#application.daos.cascade#" method="getArchiveByArchiveID" returnvariable="variables.archive">
		<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
		<cfinvokeargument name="archiveID" value="#url.archiveID#" />	<!---Type:string  --->
	</cfinvoke>

	<cfif NOT variables.archive.recordCount>
		<cflocation url="#application.settings.appBaseDir#/archive/browse.cfm" />
	</cfif>
	
	<cfif NOT structKeyExists(url,"deploymentID") OR NOT isValid("UUID",url.deploymentID)>
		<cflocation url="#application.settings.appBaseDir#/archive/archive.cfm?archiveID=#url.archiveID#" />
	</cfif>
	
	<cfinvoke component="#application.daos.cascade#" method="getDeploymentsForDeploymentID" returnvariable="variables.deployment">
		<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
		<cfinvokeargument name="deploymentid" value="#url.deploymentid#" />	<!---Type:string  --->
	</cfinvoke>

	<cfinvoke component="#application.daos.cascade#" method="getDeploymentFilesManifestForDeploymentID" returnvariable="variables.deploymentManifest">
		<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
		<cfinvokeargument name="deploymentid" value="#url.deploymentid#" />	<!---Type:string  --->
	</cfinvoke>
	
	<cfset variables.zipFilePath = application.config.archiveDirectory & "/" & variables.archive.archiveID & ".zip" />
	
	<cfset variables.currentSHAHash = application.objs.global.getArchiveZipFileHash(variables.zipFilePath,variables.archive.archiveID)/>
	
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
							<h1>Deployment: #variables.deployment.deployedSystemName# #application.objs.global.formatDate(variables.deployment.deployedon)# #application.objs.global.formatTime(variables.deployment.deployedon)#</h1>
							<h2>Archive: <a href="#application.settings.appBaseDir#/archive/archive.cfm?archiveID=#variables.archive.archiveID#">#variables.archive.archiveID#</a></h2>
						</div>
						
						<div class="contentSection">
														
							<cfinclude template="#application.settings.appBaseDir#/archive/inc/_archiveInfo.cfm" />
							
							<h2 class="sectionTitle">Deployment Info</h2>
							
							<table width="100%" class="dataTable">
								
								<tr>
									<th width="15%">
										Deployment ID:
									</th>
									<td class="monospace" width="35%">
										#variables.deployment.deploymentID#
									</td>
									<th width="15%">
										Deployed By:
									</th>
									<td width="35%">
										#variables.deployment.deployedByUserFullname# (#variables.deployment.deployedByUserEmail#)
									</td>
								</tr>
								<tr>
									<th>
										Deployed To:
									</th>
									<td>
										#variables.deployment.deployedSystemName# 
									</td>
									<th>
										Deployed On:
									</th>
									<td>
										#application.objs.global.formatDate(variables.deployment.deployedon)# #application.objs.global.formatTime(variables.deployment.deployedon)#
									</td>
								</tr>
								<tr>
									<th>
										Build System Name:
									</th>
									<td>
										#variables.deployment.buildSystemName# 
									</td>
									<th>
										Backup Archive:
									</th>
									<td class="monospace">
										<cfif variables.deployment.wasBackupTaken>
											<a href="#application.settings.appBaseDir#/archive/archive.cfm?archiveID=#variables.deployment.backupArchiveID#">#variables.deployment.backupArchiveID#</a>
										</cfif>
									</td>
								</tr>
								<tr>
									<th>
										Build Dir:
									</th>
									<td colspan="3">
										#variables.archive.buildDir# 
									</td>
								</tr>
								<tr>
									<th>
										Deployment Dir:
									</th>
									<td colspan="3">
										#variables.deployment.deploymentDir# 
									</td>
								</tr>
								<tr>
									<th valign="top">
										Deployment Notes:
									</th>
									<td colspan="3">
										#variables.deployment.deploymentNotes# 
									</td>
								</tr>
							</table>
							
							<h2 class="sectionTitle">Deployment Manifest</h2>
							
							<table width="100%" class="dataTable">
								<tr>
									<th>
										&nbsp;
									</th>
									<th>
										File Path
									</th>
									<th>
										File Hash
									</th>
									<th>
										Prev.&nbsp;File&nbsp;Hash
									</th>
								</tr>
								
								<cfset variables.newCount = 0 />
								<cfset variables.changedCount = 0 />
								
								<cfloop query="variables.deploymentManifest">
									<tr <cfif variables.deploymentManifest.currentRow MOD 2 EQ 0>class="alt"</cfif>>
										<td style="text-align:right;">
											#numberFormat(variables.deploymentManifest.currentRow,repeatString("0",len(variables.deploymentManifest.recordCount)))#
										</td>
										<td>
											<span class="notImportaint">#variables.deployment.deploymentDir#</span>#replaceNoCase(variables.deploymentManifest.filePath,variables.archive.buildDir,"")#
										</td>
										<cfset variables.isNew = false />
										<cfset variables.hasChanged = false />
										
										<cfif NOT len(trim(variables.deploymentManifest.previousFileSHAHash))>
											<cfset variables.isNew = true />
											<cfset variables.newCount = variables.newCount + 1 />
										<cfelseif variables.deploymentManifest.fileSHAHAsh NEQ variables.deploymentManifest.previousFileSHAHash>
											<cfset variables.hasChanged = true />
											<cfset variables.changedCount = variables.changedCount + 1 />
										</cfif>										
										
										<td width="100" class="center monospace<cfif variables.hasChanged OR variables.isNew> pass</cfif>">
											<a href="#application.settings.appBaseDir#/archive/viewFileSource.cfm?archiveID=#variables.archive.archiveID#&fileID=#variables.deploymentManifest.archivefileID#" <cfif variables.hasChanged OR variables.isNew>class="coloredTDLink"</cfif>>
												#lcase(left(variables.deploymentManifest.fileSHAHash,application.settings.showFirstXCharsOfSHA))#
											</a>
										</td>
										<td width="100" class="center monospace<cfif variables.hasChanged> pass</cfif>">
											<a href="#application.settings.appBaseDir#/archive/viewFileSource.cfm?archiveID=#variables.deploymentManifest.backupArchiveID#&fileID=#variables.deploymentManifest.backupArchiveFileID#" <cfif variables.hasChanged>class="coloredTDLink"</cfif>>
												#lcase(left(variables.deploymentManifest.previousFileSHAHash,application.settings.showFirstXCharsOfSHA))#
											</a>
										</td>
									</tr>
								</cfloop>
							</table>
							
							<h2 class="sectionTitle">Deployment Summary</h2>
							
							<table width="100%" class="dataTable">
								<tr>
									<th width="10%">
										Files Deployed:
									</th>
									<td>
										#variables.deploymentManifest.recordCount#
									</td>
								</tr>
								<tr>
									<th width="10%">
										Files Updated:
									</th>
									<td>
										#variables.changedCount#
									</td>
								</tr>
								<tr>
									<th width="10%">
										Files Added:
									</th>
									<td>
										#variables.newCount#
									</td>
								</tr>
							</table>
						</div>
					
					</cfoutput>
				</div>
			</div>
		</div>
		
		<cfinclude template="#application.settings.appBaseDir#/inc/footer.cfm" />
		
		
	</body>
</html>
















