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
	
	<!--- Dont think I need this, but I might later so im going to leave it commented out here for now just in case.
	<cfinvoke component="#application.daos.cascade#" method="getFilesForArchiveID" returnvariable="variables.files">
		<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
		<cfinvokeargument name="archiveID" value="#url.archiveID#" />	<!---Type:string  --->
	</cfinvoke>
	--->
	
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
	
	
	
	
	<cfparam name="url.createDeployDir" default="false" />
	
</cfsilent>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
	<head>
		
		<cfinclude template="#application.settings.appBaseDir#/inc/head.cfm" />
		<cfoutput>
			<title>#application.settings.appTitle#</title>
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
							<h1>Deploy Archive #variables.archive.archiveID#</h1>
						</div>
						
						<div class="contentSection">
							<a href="#application.settings.appBaseDir#/archive/archive.cfm?archiveID=#variables.archive.archiveID#">Back to Archive Details</a>
							<cfinclude template="#application.settings.appBaseDir#/archive/inc/_archiveInfo.cfm" />
							
						</div>
						
						<div class="contentSection">
							<h2 class="sectionTitle">Deploy this Archive</h2>
							
							<form action="deploy-step-2.cfm" method="get">
								<table width="100%" class="formTable">
									<!---<tr>
										<th>
											Deploy Directory:
										</th>
										<td>
											<input type="text" name="deployDir" value="#variables.deployDir#" size="75" />
										</td>
										<td width="200">
											<cfif variables.userDefinedDir>
												
											<cfelse>
												<cfif variables.buildDirExists>
													Defaulting to Build Directory.
												<cfelse>
													Build Directory does not exist, defaulting to web root.
												</cfif>
											</cfif>
										</td>
									</tr>--->
									<tr>
										<th valign="top">
											Deploy Directory:
										</th>
										<td>
											<table width="100%">
												<cfset variables.dirFound = false />
												<cfset variables.selected = false />
												
												<cfloop from="1" to="#listLen(variables.archive.deployDirSuggestions)#" index="variables.i">
													<cfset variables.tempDir = trim(listGetAt(variables.archive.deployDirSuggestions,variables.i)) />
													<cfset variables.tempDirExists = directoryExists(variables.tempDir)>
													
													<cfif variables.tempDirExists AND NOT variables.dirFound>
														<cfset variables.dirFound = true />
														<cfset variables.selected = true />
													</cfif>
													
													<tr>
														<td class="<cfif variables.tempDirExists>pass<cfelse>fail</cfif>">
															<input type="radio" value="#variables.tempDir#" name="deployDir" id="deployDir_#variables.i#" <cfif variables.selected>checked="true"</cfif>>
															<label for="deployDir_#variables.i#">#variables.tempDir#</label><br />
														</td>
														<td class="<cfif variables.tempDirExists>pass<cfelse>fail</cfif>">
															Suggested Deploy Dir #variables.i#
														</td>
													</tr>
													<cfset variables.selected = false />
												</cfloop>
												<cfif NOT listContains(variables.archive.deployDirSuggestions,variables.archive.buildDir)>
													<cfset variables.tempDirExists = directoryExists(variables.archive.buildDir) />
												
													<cfif variables.tempDirExists AND NOT variables.dirFound>
														<cfset variables.dirFound = true />
														<cfset variables.selected = true />
													</cfif>
												
													<tr>
														<td class="<cfif variables.tempDirExists>pass<cfelse>fail</cfif>">
															<input type="radio" value="#variables.archive.buildDir#" name="deployDir" id="deployDir_0" <cfif variables.selected>checked="true"</cfif>>
															<label for="deployDir_0">#variables.archive.buildDir#</label>
														</td>
														<td class="<cfif variables.tempDirExists>pass<cfelse>fail</cfif>">
															Build Dir
														</td>
													</tr>
													<cfset variables.selected = false />
												</cfif>
												<cfset variables.webroot = expandPath("/") />
												
												<cfif NOT variables.dirFound>
													<cfset variables.selected = true />
												</cfif>
												
												<tr>
													<td>
														<input type="radio" value="deployDir_custom" name="deployDir" id="deployDir_custom" <cfif variables.selected>checked="True"</cfif>>
														<input type="text" name="customDeployDir" value="#variables.webroot#" size="70" />
													</td>
													<td>
														Custom Deploy Dir
													</td>
												</tr>
											
											</table>
											
		
										</td>
									</tr>
									<tr>
										<th>
											&nbsp;
										</th>
										<td>
											<input type="checkbox" value="true" name="createDeployDir" id="createDeployDir" <cfif url.createDeployDir>checked="true"</cfif>>
											<lable for="createDeployDir">Create Deploy Dir If It Doesn't Already Exist</label>
										</td>
									</tr>
									<tr>
										<th>
											&nbsp;
										</th>
										<td>
											<input type="checkbox" value="true" name="skipBackupArchive" id="skipBackupArchive">
											Skip Backup Archive
											<em>Do this at your own risk! Not recommended!</em>
										</td>
									</tr>
									<tr>
										<td colspan="3" class="right">
											<input type="hidden" name="archiveID" value="#variables.archive.archiveID#" />
											<input type="submit" value="Validate Deployment Plan" />
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
















