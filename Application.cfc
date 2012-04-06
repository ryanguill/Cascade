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

<cfcomponent displayname="Application" output="true">
 
 	<cfset this.name = "cascade" />
	<cfset this.applicationTimeout = CreateTimeSpan(1,0,0,0 ) />
	<cfset this.sessionManagement = true />
	<cfset this.sessionTimeout = createTimeSpan(0,2,0,0) />
	<cfset this.clientManagement = false />
  
 
	<cffunction	name="OnApplicationStart" access="public" returntype="boolean" output="false">
 
 		<cfset var local = structNew() />
 
 		<cfset variables.instance = structNew() />
		<cfset variables.instance.initComplete = false />
		
		<cfset application.settings = structNew() />
		<cfset application.settings.appBaseDir = "/cascade" />
		<cfset application.settings.appMapping = "cascade" />	
		<cfset application.settings.serverEnviron = "DEV" />
		<cfset application.settings.appTitle = "Cascade" />
		
		<cfset application.settings.dateFormat = "yyyy-mm-dd" />
		<cfset application.settings.timeFormat = "HH:mm" />
		<cfset application.settings.never = createDateTime(1970,1,1,0,0,0) />
		
		<cfset application.daos = structNew() />
	
		<cfset application.daos.cascade = createObject("component","#application.settings.appMapping#.com.guill.dao.cascadeDao") />
		<cfset application.daos.userManagement = createObject("component","#application.settings.appMapping#.com.guill.dao.userManagementDao") />
		<cfset application.daos.referenceTables = createObject("component","#application.settings.appMapping#.com.guill.dao.referenceTablesDao") />
		
		<cfset local.fileObj = createObject("java","java.io.File") />
		
		<cfset application.settings.pathSeperator = local.fileObj.separator />
		
		<cfif application.settings.pathSeperator EQ "/" >
			<cfset application.settings.antiPathSeperator = "\" />
		<cfelseif application.settings.pathSeperator EQ "\" >
			<cfset application.settings.antiPathSeperator = "/" />
		<cfelse>
			<cfset application.settings.antiPathSeperator = "" />
		</cfif>
		
		<cfset application.settings.showFirstXCharsOfSHA = 10 />
		<cfset application.settings.zipMimeTypes = "application/zip,application/x-zip,application/x-zip-compressed" />
		
		<cfset application.objs.global = createObject("component","#application.settings.appMapping#.com.guill.global") />
		
		<cfset application.config = structNew() />
		
		<cfif application.objs.global.doesConfigXMLExist()>
			<cfset application.config = application.objs.global.loadConfigXML() />
			
			<!--- lots of code expects the dsn to be in the settings, so copy it over there --->
			<cfset application.settings.dsn = application.config.dsn />
		<cfelse>
			<cfset application.daos.install = createObject("component","#application.settings.appMapping#.com.guill.dao.installDao") />
		</cfif>
		
		<cfset application.objs.remoteService = createObject("component","#application.settings.appMapping#.com.remoteService") />
				
 	<cfreturn true />
	</cffunction>
	
 
	<cffunction name="OnApplicationEnd"	access="public"	returntype="void" output="false">
 		<cfargument name="applicationScope" type="struct" required="true" />
		
	</cffunction>
 
 
	<cffunction	name="OnRequestStart" access="public" returntype="boolean" output="false">
 		<cfargument name="targetPage" type="string" required="true" />
 
 		
 
 		<cfif cgi.server_port NEQ "80">
			<cfparam name="request.currentPage" default="http://#cgi.server_name#:#cgi.server_port##cgi.script_name#?#cgi.query_string#" />
			<cfparam name="request.baseLink" default="http://#cgi.server_name#:#cgi.server_port#" />
		<cfelse>
			<cfparam name="request.currentPage" default="http://#cgi.server_name##cgi.script_name#?#cgi.query_string#" />
			<cfparam name="request.baseLink" default="http://#cgi.server_name#" />
		</cfif>
		
		<cfif structKeyExists(url,"reinit") AND url.reinit EQ "true">
			<cfset OnApplicationStart() />
		</cfif>	
		
		<cfif structKeyExists(url,"clearlogin") and url.clearLogin EQ "true">
			<cfset onSessionStart('clearlogin') />
		</cfif>		
		
		<cfset session.login.setCurrentPage(request.currentPage) />
		
		
	
 	<cfreturn true />
	</cffunction>
 
	<!--- 
	<cffunction	name="OnRequest" access="public" returntype="void" output="true">
 		<cfargument name="targetPage" type="string" required="true" />
		
		<!--- Do not implement the onRequest method in any Application.cfc file that 
			affects .cfc files that implement web services, process Flash Remoting or 
			event gateway requests; ColdFusion will not execute the requests if you 
			implement this method.  --->
		<!--- If you implement this method, you MUST include the page! --->
		<cfinclude template="#arguments.targetPage#" />
 
	</cffunction>
	--->
 
 
	<cffunction	name="OnRequestEnd"	access="public"	returntype="void" output="true">
 
 	</cffunction>
 
 
	<cffunction	name="OnSessionStart" access="public" returntype="void"	output="false">
  
 		<cfif structKeyExists(session,"tempFormVars")>
 			<cfset structClear(session.tempFormVars) />
 		</cfif>
  
 		<cfset session.messenger = createObject("component","#application.settings.appMapping#.com.guill.session.messenger").init() />
		<cfset session.login = createObject("component","#application.settings.appMapping#.com.guill.session.login").init(application.daos.userManagement) />
 
	</cffunction>
 
 
	<cffunction	name="OnSessionEnd"	access="public"	returntype="void" output="false">
 		<cfargument name="sessionScope" type="struct" required="true" />
		<cfargument name="applicationScope" type="struct" required="true" />
	
	</cffunction>
 
 	<!---
	<cffunction name="OnError" access="public" returntype="void" output="true">
 		<cfargument name="exception" type="any" required="true" />
		<cfargument name="eventName" type="string" required="true" />
		
		<cfdump var="#arguments#" />
		<cfabort />
		
	</cffunction>
	--->
	
	<!---
	<cffunction name="onMissingTemplate" access="public" returntype="boolean" output="true">
		<cfargument name="targetPage" type="string" required="true" />
		
		
	<cfreturn True />
	</cffunction>
 	--->
	 
</cfcomponent>