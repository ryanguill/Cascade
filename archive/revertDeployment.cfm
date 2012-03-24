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
	
	<cfif NOT variables.deployment.recordCount OR NOT variables.deploymentManifest.recordCount>
		<cflocation url="#application.settings.appBaseDir#/archive/archive.cfm?archiveID=#url.archiveID#" />
	</cfif>
	
	<cfif NOT structKeyExists(url,"backupArchiveID") OR NOT isValid("UUID",url.backupArchiveID)>
		<cflocation url="#application.settings.appBaseDir#/archive/archive.cfm?archiveID=#url.archiveID#" />
	</cfif>
	
	<cfinvoke component="#application.daos.cascade#" method="getArchiveByArchiveID" returnvariable="variables.backupArchive">
		<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
		<cfinvokeargument name="archiveID" value="#url.backupArchiveID#" />	<!---Type:string  --->
	</cfinvoke>
	
	<cfif NOT variables.backupArchive.recordCount>
		<cflocation url="#application.settings.appBaseDir#/archive/archive.cfm?archiveID=#url.archiveID#" />
	</cfif>
	
	<cfset variables.zipFilePath = application.config.archiveDirectory & "/" & variables.archive.archiveID & ".zip" />
	<cfset variables.currentSHAHash = application.objs.global.getArchiveZipFileHash(variables.zipFilePath,variables.archive.archiveID)/>
	<cfset variables.manifest = application.objs.global.getZipManifest(variables.zipFilePath) />
	
	<cfif variables.archive.archiveSHAHash NEQ variables.currentSHAHash OR variables.manifest.archiveSHAHash NEQ variables.currentSHAHash>
		<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
			<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/action.cfm" />
			<cfinvokeargument name="messageType" value="Error" />
			<cfinvokeargument name="messageText" value="WARNING! The archive may have been tampered with!" />
			<cfinvokeargument name="messageDetail" value="The hash of the archive at build (#variables.archive.archiveSHAHash#)<BR /> does NOT match the hash of the archive currently on disk (#variables.currentSHAHash#)<BR />Manifest hash (#variables.manifest.archiveSHAHAsh#)" />
		</cfinvoke>
	</cfif>
	
	
	<cfset variables.backupArchiveZipFilePath = application.config.archiveDirectory & "/" & variables.backupArchive.archiveID & ".zip" />
	<cfset variables.backupArchiveCurrentSHAHash = application.objs.global.getArchiveZipFileHash(variables.backupArchiveZipFilePath,variables.backupArchive.archiveID)/>
	<cfset variables.backupArchiveManifest = application.objs.global.getZipManifest(variables.backupArchiveZipFilePath) />
	
	<cfif variables.backupArchive.archiveSHAHash NEQ variables.backupArchiveCurrentSHAHash OR variables.backupArchiveManifest.archiveSHAHash NEQ variables.backupArchiveCurrentSHAHash>
		<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
			<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/action.cfm" />
			<cfinvokeargument name="messageType" value="Error" />
			<cfinvokeargument name="messageText" value="WARNING! The backup archive may have been tampered with!" />
			<cfinvokeargument name="messageDetail" value="The hash of the archive at build (#variables.backupArchive.archiveSHAHash#)<BR /> does NOT match the hash of the archive currently on disk (#variables.backupArchiveCurrentSHAHash#)<BR />Manifest hash (#variables.backupArchiveManifest.archiveSHAHAsh#)" />
		</cfinvoke>
	</cfif>
	
	<cfset variables.willBeUpdatedFiles = arrayNew(2) />
	<cfset variables.willBeRemovedFiles = arrayNew(2) />
	
	<cfset variables.willBeUpdatedFilesIndex = 0 />
	<cfset variables.willBeRemovedFilesIndex = 0 />
	
	<cfloop query="variables.deploymentManifest">
		<tr <cfif variables.deploymentManifest.currentRow MOD 2 EQ 0>class="alt"</cfif>>
			
			<cfif NOT len(trim(variables.deploymentManifest.previousFileSHAHash))>
				<cfset variables.willBeRemovedFilesIndex = variables.willBeRemovedFilesIndex + 1 />
				
				<cfset variables.willBeRemovedFiles[variables.willBeRemovedFilesIndex][1] = variables.deploymentManifest.deployedfilepath />
				<cfset variables.willBeRemovedFiles[variables.willBeRemovedFilesIndex][2] = "" />
				
			<cfelseif variables.deploymentManifest.fileSHAHAsh NEQ variables.deploymentManifest.previousFileSHAHash>
				<cfset variables.willBeUpdatedFilesIndex = variables.willBeUpdatedFilesIndex + 1 />
				
				<cfset variables.willBeUpdatedFiles[variables.willBeUpdatedFilesIndex][1] = variables.deploymentManifest.deployedfilepath />
				<cfset variables.willBeUpdatedFiles[variables.willBeUpdatedFilesIndex][2] = variables.deploymentManifest.previousFileSHAHash />
				<cfset variables.willBeUpdatedFiles[variables.willBeUpdatedFilesIndex][3] = variables.deploymentManifest.backupArchiveFileID />
			</cfif>										
			
			
	</cfloop>
	
	
</cfsilent>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
	<head>
		
		<cfinclude template="#application.settings.appBaseDir#/inc/head.cfm" />
		<cfoutput>
			<title>#application.settings.appTitle#</title>
		</cfoutput>
		
		<script type="text/javascript">
		
			Event.observe(window, 'load', init, false);
	
			function init() {
				
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
							<h1 style="background-color:red;color:white;">Revert Deployment: #variables.deployment.deployedSystemName# #application.objs.global.formatDate(variables.deployment.deployedon)# #application.objs.global.formatTime(variables.deployment.deployedon)#</h1>
							<h2>Archive: <a href="#application.settings.appBaseDir#/archive/archive.cfm?archiveID=#variables.archive.archiveID#">#variables.archive.archiveID#</a></h2>
							<h2>Backup Archive: <a href="#application.settings.appBaseDir#/archive/archive.cfm?archiveID=#variables.backupArchive.archiveID#">#variables.backupArchive.archiveID#</a></h2>
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
							
							
								
								
							
							<h2 class="sectionTitle">Revert Deployment Summary</h2>
							
							<p>The following explains how the files will be affected:</p>
							
							<h3>Files that will be updated back to their previous state:</h3>
							<table width="100%" class="dataTable">
								<tr>
									<th>
										File
									</th>
									<th>
										&nbsp;
									</th>
								</tr>
								<cfloop from="1" to="#arrayLen(variables.willBeUpdatedFiles)#" index="i">
									<tr>
										<td>
											#variables.willBeUpdatedFiles[i][1]#
										</td>
										<td width="100" class="center monospace">
											<a href="#application.settings.appBaseDir#/archive/viewFileSource.cfm?archiveID=#variables.backupArchive.archiveID#&fileID=#variables.willBeUpdatedFiles[i][3]#">
												#lcase(left(variables.willBeUpdatedFiles[i][2],application.settings.showFirstXCharsOfSHA))#
											</a>
										</td>
									</tr>
								</cfloop>
							</table>
							
							<h3>Files that will be REMOVED:</h3>
							<table width="100%" class="dataTable">
								<tr>
									<th>
										File
									</th>
									<th>
										&nbsp;
									</th>
								</tr>
								<cfloop from="1" to="#arrayLen(variables.willBeRemovedFiles)#" index="i">
									<tr>
										<td>
											#variables.willBeRemovedFiles[i][1]#
										</td>
										<td width="100" class="center monospace">
											#variables.willBeRemovedFiles[i][2]#
										</td>
									</tr>
								</cfloop>
							</table>
							
							<p style="background-color:red;color:white;font-weight:bold;">If you understand how the files will be affected and wish to continue, please click the revert deployment button below.</p>
							
							<form action="action.cfm" method="POST">
								<input type="hidden" name="action" value="revertDeployment" />
								<input type="hidden" name="deploymentID" value="#url.deploymentID#" />
								<input type="hidden" name="archiveID" value="#variables.archive.archiveID#" />
								<input type="hidden" name="backupArchiveID" value="#variables.backupArchive.archiveID#" />
								<input type="submit" value="Revert" class="button" />
							</form>
						</div>
					
					</cfoutput>
				</div>
			</div>
		</div>
		
		<cfinclude template="#application.settings.appBaseDir#/inc/footer.cfm" />
		
		
	</body>
</html>
















