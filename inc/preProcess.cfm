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
