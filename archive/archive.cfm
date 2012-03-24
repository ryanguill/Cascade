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
	
	<cfinvoke component="#application.daos.cascade#" method="getFilesForArchiveID" returnvariable="variables.files">
		<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
		<cfinvokeargument name="archiveID" value="#url.archiveID#" />	<!---Type:string  --->
	</cfinvoke>
	
	<cfinvoke component="#application.daos.cascade#" method="getArchiveCertificationsForArchiveID" returnvariable="variables.certifications">
		<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
		<cfinvokeargument name="archiveID" value="#url.archiveID#" />	<!---Type:string  --->
	</cfinvoke>

	<cfinvoke component="#application.daos.cascade#" method="getArchiveLogForArchiveID" returnvariable="variables.log">
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
	
	<cfinvoke component="#application.daos.cascade#" method="getDeploymentsForArchiveID" returnvariable="variables.deployments">
		<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
		<cfinvokeargument name="archiveID" value="#url.archiveID#" />	<!---Type:string  --->
	</cfinvoke>
	
	<cfinvoke component="#application.daos.cascade#" method="searchArchivesByApplicationNameNonObsolete" returnvariable="variables.nonObsoleteAppArchives">
		<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
		<cfinvokeargument name="applicationName" value="#variables.archive.applicationName#" />	<!---Type:string  --->
	</cfinvoke>
	
	<cfif variables.nonObsoleteAppArchives.recordCount GT 1>
		<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
			<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/action.cfm" />
			<cfinvokeargument name="messageType" value="Information" />
			<cfinvokeargument name="messageText" value="There is more than one non-obsolete version of this application." />
			<cfinvokeargument name="messageDetail" value="<a href=""#application.settings.appBaseDir#/archive/search.cfm?appName=#variables.archive.applicationName#&inclObsolete=1"">Click here</a> to see all of the versions for this application." />
		</cfinvoke>
	</cfif>
	
	<cfinvoke component="#application.daos.referenceTables#" method="getAllCertificationTypes" returnvariable="variables.certificationTypes">
		<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->		
	</cfinvoke>

	<cfset variables.isLocalArchive = true />
	
	
	
	
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
				archiveFilesTable_hide();
				certificationFormDiv_hide();
			}		
		
			function archiveFilesTable_show ( )
			{
				$('archiveFilesTable_show_link').hide();
				$('archiveFilesTable').show();
			}
		
			function archiveFilesTable_hide ( )
			{
				$('archiveFilesTable_show_link').show();
				$('archiveFilesTable').hide();
			}
			
			function certificationFormDiv_show()
			{
				$('certificationFormDiv').show();
				$('certificationFormDiv_show_link').hide();	
			}
			
			function certificationFormDiv_hide()
			{
				$('certificationFormDiv').hide();
				$('certificationFormDiv_show_link').show();
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
							<h1><a href="#application.settings.appBaseDir#/archive/archive.cfm?archiveID=#variables.archive.archiveID#">Archive: #variables.archive.archiveID#</a></h1>
						</div>
						
						<cfif structKeyExists(url,"action") AND url.action EQ "deleteArchive">
							<div class="contentSection">
								<h2 class="sectionTitle" style="background-color:red">Delete Archive</h2>
								
								<p>Are you certain that you want to delete this archive and all of its associated information?  This is a permanant action and cannot be undone.  It is suggested that you download the archive before you continue.</p>
								
								<form action="action.cfm" method="post">
									<input type="hidden" name="action" value="deleteArchive" />
									<input type="hidden" name="archiveID" value="#variables.archive.archiveID#" />
									<input type="submit" value="Yes, I understand, delete this Archive" class="button" />
									<a href="#application.settings.appBaseDir#/archive/archive.cfm?archiveID=#variables.archive.archiveID#" class="bigButton">Cancel</a>
								</form>
								
								<hr />
							</div>
						</cfif>
						
						<div class="contentSection">
							<table width="100%">
								<tr>
									<td colspan="50" class="noBorder">
										<a href="#application.settings.appBaseDir#/archive/action.cfm?action=downloadArchive&archiveID=#variables.archive.archiveID#&nameFormat=application" class="bigButton">Download Archive as #replaceNoCase(variables.archive.applicationName," ","-","all")#-#replaceNoCase(variables.archive.versionName," ","-","all")#-#dateformat(variables.archive.buildOn,"yyyymmdd")#.zip</a> 
									</td>
									<td colspan="50" class="right noBorder">
										<a href="#application.settings.appBaseDir#/archive/action.cfm?action=downloadArchive&archiveID=#variables.archive.archiveID#" class="bigButton">Download Archive as #variables.archive.archiveID#.zip</a> 
									</td>
								</tr>
							</table>

							<cfinclude template="#application.settings.appBaseDir#/archive/inc/_archiveInfo.cfm" />
							
						</div>
						
						
						<div class="contentSection">
							<cfif session.login.isUserInGroup("deploy")>
								<a href="#application.settings.appBaseDir#/archive/deploy.cfm?archiveID=#variables.archive.archiveID#" class="bigButton">Deploy This Archive</a>
							</cfif>
									
							<cfif session.login.isUserInGroup("build") and variables.archive.buildSystemName EQ application.config.serverName>
								<a href="#application.settings.appBaseDir#/archive/build.cfm?dir=#URLEncodedFormat(variables.archive.builddir)#&previousArchiveID=#variables.archive.archiveID#" class="bigButton">Re-Build This Archive (New Version)</a>
							</cfif>
					
						</div>
						
						
						<cfinclude template="#application.settings.appBaseDir#/archive/inc/_archiveCertifications.cfm" />

						<cfinclude template="#application.settings.appBaseDir#/archive/inc/_archiveFiles.cfm" />

						<cfinclude template="#application.settings.appBaseDir#/archive/inc/_archiveDeployments.cfm" />
						
						<cfinclude template="#application.settings.appBaseDir#/archive/inc/_archiveLog.cfm" />
						
						<div class="contentSection">
							<table>
								<tr>
									<td width="200" class="noBorder">
										<a href="#application.settings.appBaseDir#/archive/viewManifest.cfm?archiveID=#variables.archive.archiveID#" class="bigButton">View Raw Manifest</a>
									</td>
									<td width="200"  class="noBorder">
										<cfif structKeyExists(url,"action") AND url.action EQ "deleteArchive">
											&nbsp;
										<cfelse>
											<a href="#application.settings.appBaseDir#/archive/archive.cfm?archiveID=#variables.archive.archiveID#&action=deleteArchive" class="bigButton">Delete Archive</a>
										</cfif>
										
									</td>
									<td width="200" class="noBorder">
										<cfif variables.archive.isObsolete>
											<a href="#application.settings.appBaseDir#/archive/action.cfm?archiveID=#variables.archive.archiveID#&action=unmarkAsObsolete" class="bigButton">Unmark as Obsolete</a>
										<cfelse>
											<a href="#application.settings.appBaseDir#/archive/action.cfm?archiveID=#variables.archive.archiveID#&action=markAsObsolete" class="bigButton">Mark as Obsolete</a>
										</cfif>
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