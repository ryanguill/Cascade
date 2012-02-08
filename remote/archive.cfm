
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
	
	<cfif NOT structKeyExists(url,"archiveID") OR NOT isValid("UUID",url.archiveID)>
		<cflocation url="#application.settings.appBaseDir#/remote/server.cfm?serverID=#url.serverID#" />
	</cfif>
	
	<cfinvoke webservice="#variables.server.serverURL#" method="getAllInfoForArchive" returnvariable="variables.getAllInfoForArchiveRet">
		<cfinvokeargument name="serverID" value="#application.config.cascadeID#" />
		<cfinvokeargument name="validationCode" value="#variables.server.validationCode#" />
		<cfinvokeargument name="archiveID" value="#url.archiveID#" />
	</cfinvoke>
	
	<cfif NOT variables.getAllInfoForArchiveRet.validArchive>
		<cflocation url="#application.settings.appBaseDir#/remote/server.cfm?serverID=#url.serverID#" />
	</cfif>
	
	<cfset variables.archive = variables.getAllInfoForArchiveRet.archive />
	<cfset variables.files = variables.getAllInfoForArchiveRet.files />
	<cfset variables.certifications = variables.getAllInfoForArchiveRet.certifications />
	<cfset variables.log = variables.getAllInfoForArchiveRet.log />
	<cfset variables.currentSHAHash = variables.getAllInfoForArchiveRet.currentSHAHash />
	<cfset variables.manifest = variables.getAllInfoForArchiveRet.manifest />
	<cfset variables.deployments = variables.getAllInfoForArchiveRet.deployments />
	
	<cfif variables.archive.archiveSHAHash NEQ variables.currentSHAHash OR variables.manifest.archiveSHAHash NEQ variables.currentSHAHash>
		<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
			<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/action.cfm" />
			<cfinvokeargument name="messageType" value="Error" />
			<cfinvokeargument name="messageText" value="WARNING! The archive may have been tampered with!" />
			<cfinvokeargument name="messageDetail" value="The hash of the archive at build (#variables.archive.archiveSHAHash#)<BR /> does NOT match the hash of the archive currently on disk (#variables.currentSHAHash#)<BR />Manifest hash (#variables.manifest.archiveSHAHAsh#)" />
		</cfinvoke>
	</cfif>
	
	<cfset variables.isLocalArchive = false />
	
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
							<h1>Remote Server: #variables.server.serverName#</h1>
							<h3>Server URL: #variables.server.serverURL#</h3>
							<h1>Archive: #variables.archive.archiveID#</h1>
						</div>
						
						<cfif session.login.isUserInGroup("deploy")>
							<div class="contentSection">
								<a href="action.cfm?action=downloadArchive&serverID=#url.serverID#&archiveID=#variables.archive.archiveID#" class="bigButton">Retrieve this Archive</a>
							</div>
						</cfif>
						
						<div class="contentSection">
							
							<cfinclude template="#application.settings.appBaseDir#/archive/inc/_archiveInfo.cfm" />
							
						</div>
						
						<cfinclude template="#application.settings.appBaseDir#/archive/inc/_archiveCertifications.cfm" />
						
						<cfinclude template="#application.settings.appBaseDir#/archive/inc/_archiveFiles.cfm" />
						
						<cfinclude template="#application.settings.appBaseDir#/archive/inc/_archiveDeployments.cfm" />
						
						<cfinclude template="#application.settings.appBaseDir#/archive/inc/_archiveLog.cfm" />
						
						
					</cfoutput>
				</div>
			</div>
		</div>
		
		<cfinclude template="#application.settings.appBaseDir#/inc/footer.cfm" />
		
		
	</body>
</html>