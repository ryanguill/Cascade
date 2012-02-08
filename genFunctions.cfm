<cffunction name="_formatDate" access="public" returntype="string" output="false" hint="">
	<cfargument name="date" type="date" required="True" />
	
	<cfif dateCompare(arguments.date,application.settings.never) NEQ 0>
		<cfreturn dateFormat(arguments.date,application.settings.dateFormat) />
	</cfif>

<cfreturn ''/>	
</cffunction>

<cffunction name="_formatTime" access="public" returntype="string" output="false" hint="">
	<cfargument name="date" type="date" required="True" />
	
	<cfif dateCompare(arguments.date,application.settings.never) NEQ 0>
		<cfreturn timeFormat(arguments.date,application.settings.timeFormat) />
	</cfif>

<cfreturn ''/>	
</cffunction>

<cffunction name="_doesConfigXMLExist" access="public" returntype="boolean" output="false">
	
<cfreturn fileExists(expandPath("#application.settings.appBaseDir#/config.xml.cfm")) />
</cffunction>


<cffunction name="_createConfigXML" access="public" returntype="boolean" output="false">
	<cfargument name="adminUsername" type="string" required="true" />
	<cfargument name="backupDirectory" type="string" required="true" />
	<cfargument name="repositoryDirectory" type="string" required="true" />
	
	<cfset var output = "" />
	
	<cfset arguments.configCreatedTimestamp = now() />
	
	<cfwddx action="cfml2wddx" input="#arguments#" output="output" />
	
	<cffile action="write" file="#expandPath("#application.settings.appBaseDir#/config.xml.cfm")#" output="#output#" nameconflict="overwrite" />
	
</cffunction>
