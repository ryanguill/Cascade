
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
							<h1>Manifest: <a href="#application.settings.appBaseDir#/archive/archive.cfm?archiveID=#variables.archive.archiveID#">#variables.archive.archiveID#</a></h1>
						</div>
						
						<div class="contentSection">
							
							<cfdump var="#variables.manifest#" />
							
						</div>
					
					</cfoutput>
				</div>
			</div>
		</div>
		
		<cfinclude template="#application.settings.appBaseDir#/inc/footer.cfm" />
		
		
	</body>
</html>
















