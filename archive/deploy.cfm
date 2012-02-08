
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
	
	
	<cfset variables.buildDirExists = true />
	<cfparam name="variables.deployDir" default="#variables.archive.buildDir#" />
	
	<cfif NOT directoryExists(variables.archive.buildDir)>
		<cfset variables.buildDirExists = false />
		<cfset variables.deployDir = expandPath("/") />
	</cfif>
	
	<cfif right(variables.deployDir,1) EQ application.settings.pathSeperator>
		<cfset variables.deployDir = left(variables.deployDir,len(variables.deployDir)-1) />
	</cfif>
	
	<cfset variables.userDefinedDir = false />
	<cfif structKeyExists(url,"deployDir") AND len(trim(url.deployDir))>
		<cfif right(url.deployDir,1) EQ application.settings.pathSeperator>
			<cfset url.deployDir = left(url.deployDir,len(url.deployDir)-1) />
		</cfif>
	 	<cfif url.deployDir NEQ variables.deployDir>
			<cfset variables.deployDir = url.deployDir />
			<cfset variables.userDefinedDir = true />
		</cfif>
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
									<tr>
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
									</tr>
									<tr>
										<th>
											&nbsp;
										</th>
										<td colspan="2">
											<input type="checkbox" value="true" name="createDeployDir" id="createDeployDir" <cfif url.createDeployDir>checked="true"</cfif>>
											<lable for="createDeployDir">Create Deploy Dir If It Doesn't Already Exist</label>
										</td>
									</tr>
									<tr>
										<th>
											&nbsp;
										</th>
										<td colspan="2">
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
















