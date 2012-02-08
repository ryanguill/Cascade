<cfif NOT application.objs.global.doesConfigXMLExist() AND cgi.SCRIPT_NAME NEQ "#application.settings.appBaseDir#/createConfig.cfm">
	<cflocation url="#application.settings.appBaseDir#/createConfig.cfm" />
</cfif>

<cfif NOT session.login.isLoggedIn() 
	AND cgi.SCRIPT_NAME NEQ "#application.settings.appBaseDir#/login.cfm"
	AND cgi.SCRIPT_NAME NEQ "#application.settings.appBaseDir#/createConfig.cfm">
	
	<cfif NOT findNoCase("action.cfm",cgi.SCRIPT_NAME)> 
		<cfset session.login.setReferringPage(request.currentPage) />
	</cfif>
	
	<cflocation url="#application.settings.appBaseDir#/login.cfm" />
	
</cfif>
