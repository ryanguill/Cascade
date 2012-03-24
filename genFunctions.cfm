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
