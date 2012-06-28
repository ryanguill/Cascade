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

	<cfif NOT session.login.isUserInGroup("deploy")>
		<cflocation url="#application.settings.appBaseDir#/index.cfm" />
	</cfif>		
	
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
	
	<cfinvoke component="#application.daos.cascade#" method="getFilesForArchiveID" returnvariable="variables.files">
		<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
		<cfinvokeargument name="archiveID" value="#url.archiveID#" />	<!---Type:string  --->
	</cfinvoke>
	
	<cfinvoke component="#application.daos.cascade#" method="getArchiveCertificationsForArchiveID" returnvariable="variables.certifications">
		<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
		<cfinvokeargument name="archiveID" value="#url.archiveID#" />	<!---Type:string  --->
	</cfinvoke>

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
	
	<cfif NOT structKeyExists(url,"deployDir") OR NOT len(trim(url.deployDir))>
		<cflocation url="#application.settings.appBaseDir#/archive/deploy.cfm?archiveID=#variables.archive.archiveID#" />
	</cfif>
	
	<cfparam name="url.createDeployDir" default="false">
	
	<cfif url.deployDir EQ "deployDir_custom">
		<cfset url.deployDir = trim(url.customDeployDir) />
	</cfif>
	
	<cfif NOT directoryExists(url.deployDir) AND NOT url.createDeployDir>
		<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
			<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/archive/deploy-step-2.cfm" />
			<cfinvokeargument name="messageType" value="Error" />
			<cfinvokeargument name="messageText" value="#url.deployDir# is not a valid deployment directory." />
		</cfinvoke>	
	
		<cflocation url="#application.settings.appBaseDir#/archive/deploy.cfm?archiveID=#variables.archive.archiveID#&deployDir=#url.deployDir#" />
	</cfif>
	
	<cfset variables.deployDir = url.deployDir />
	<cfparam name="url.skipBackupArchive" default="false" />
	
	<cfif right(variables.deployDir,1) EQ application.settings.pathSeperator>
		<cfset variables.deployDir = left(variables.deployDir,len(variables.deployDir)-1) />
	</cfif>
	
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
							<h1>Deploy Archive #variables.archive.archiveID#</h1>
						</div>
						
						<div class="contentSection">
							<a href="#application.settings.appBaseDir#/archive/archive.cfm?archiveID=#variables.archive.archiveID#">Back to Archive Details</a>
							<cfinclude template="#application.settings.appBaseDir#/archive/inc/_archiveInfo.cfm" />
							
						</div>
						
						<div class="contentSection">
							
							<h1>Deploy Dir: #variables.deployDir#</h1>
							
							<h2 class="sectionTitle">File Deployement Details (#variables.files.recordCount# file<cfif variables.files.recordCount NEQ 1>s</cfif>)</h2>
							
							<table class="dataTable" width="100%">
								<tr>
									<th width="40">
										&nbsp;
									</td>
									<th width="50" class="center">
										Exists?
									</th>
									<th>
										File
									</th>
								</tr>
								
								<cfset variables.fileExistsCount = 0 />
								
								<cfloop query="variables.files">
									<cfset variables.filePath = replaceNoCase(replaceNoCase(replaceNoCase(variables.files.filePath,variables.archive.builddir,""),"\",application.settings.pathSeperator,"all"),"/",application.settings.pathSeperator,"all") />
									<cfset variables.fileDeployPath = variables.deployDir & variables.filePath />
									
									<tr <cfif variables.files.currentRow MOD 2 EQ 0>class="alt"</cfif>>
										<td class="right">
											#numberFormat(variables.files.currentRow,repeatString("0",len(variables.files.recordCount)))#
										</td>
										<cfset variables.fileExists = fileExists(variables.fileDeployPath)>
										<cfif variables.fileExists>
											<cfset variables.fileExistsCount++ />
											<td class="center pass">YES</TD>
										<cfelse>
											<td class="center fail">NO</td>
										</cfif>
										<td>
											<span class="notImportaint">#variables.deployDir#</span>#variables.filePath#
										</td>
									</tr>
								</cfloop>
							</table>
						</div>
						
						<div class="contentSection">
							<h2 class="sectionTitle">Execute Deployment</h2>
							
							<form action="action.cfm" method="post">
								<table width="100%" class="formTable">
									<tr>
										<th width="200">
											Deploy Directory:
										</th>
										<td <cfif directoryExists(variables.deployDir)>class="pass"<cfelse>class="fail"</cfif>>
											#variables.deployDir#
											(<a href="#application.settings.appBaseDir#/archive/deploy.cfm?archiveID=#variables.archive.archiveID#&deployDir=#url.deployDir#" style="color:white;">Change</a>)
											<cfif NOT directoryExists(variables.deployDir) AND url.createDeployDir>
												<em>This directory does not already exist, but will be created.</em>
											<cfelse>
												<em>This directory already exists.</em>
											</cfif>
										</td>
									</tr>
								
									<cfif url.skipBackupArchive>
									<tr>
										<td colspan="2">
											You have chosen to skip a backup archive! Please reconsider! (<a href="#application.settings.appBaseDir#/archive/deploy.cfm?archiveID=#variables.archive.archiveID#&deployDir=#url.deployDir#">Change</a>)
										</td>
									</tr>
									</cfif>
									<tr>
										<th valign="top">
											Notes:
										</th>
										<td>
											<textarea name="deploymentNotes" id="deploymentNotes" cols="100" rows="10"></textarea>
										</td>
									</tr>
									<tr>
										<td class="noBorder" colspan="2">
											<p>You are about to deploy this archive. All of the specifics about the deployment will be logged.  If you have not opted out of a backup archive, all of the files in green above will be created in a new backup archive.  If you have reviewed the file list above and validated that the paths are proper, click the button below to execute the deployment of this archive.</p>
										</td>
									</tr>
									<tr>
										<td colspan="2" class="right">
											<input type="hidden" name="archiveID" value="#variables.archive.archiveID#" />
											<input type="hidden" name="deployDir" value="#variables.deployDir#" />
											<input type="hidden" name="skipBackupArchive" value="#url.skipBackupArchive#" />
											<input type="hidden" name="createDeployDir" value="#url.createDeployDir#" />
											<input type="hidden" name="action" value="deployArchive" />
											<input type="submit" value="Execute Deployment" />
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
















