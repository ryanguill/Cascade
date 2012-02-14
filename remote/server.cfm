
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
	<cfinvoke webservice="#variables.server.serverURL#" method="getAvailableArchives" returnvariable="variables.archives">
	<!---<cfinvoke component="#application.objs.remoteService#" method="getAvailableArchives" returnvariable="variables.archives">--->
		<cfinvokeargument name="serverID" value="#application.config.cascadeID#" />
		<cfinvokeargument name="validationCode" value="#variables.server.validationCode#" />
	</cfinvoke>
	<cfcatch>
		<cfdump var="#variables#" />
		<cfdump var="#application.config.cascadeID#" />
		<cfabort />
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
						
						<h3>Server URL: #variables.server.serverURL#</h3>
					
						<cfinclude template="#application.settings.appBaseDir#/archive/inc/_archiveListing.cfm" />
					
					</cfoutput>
				</div>
			</div>
		</div>
		
		<cfinclude template="#application.settings.appBaseDir#/inc/footer.cfm" />
		
		
	</body>
</html>

















