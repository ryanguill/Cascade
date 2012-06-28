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
	
	<cfset session.login.setCurrentArea("remote") />

	<cfparam name="url.serverID" default="" />
	
	<cfinvoke component="#application.objs.remoteService#" method="getRemoteServers" returnvariable="variables.remoteServers" />
	
	<cfif findNoCase("localhost",request.baseLink)>
		
		<cfset variables.serverIP = application.objs.global.getServerIPAddress() />
		
		
	
		<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
			<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/remote/index.cfm" />
			<cfinvokeargument name="messageType" value="Warning" />
			<cfinvokeargument name="messageText" value="You are currently accessing Cascade through localhost,<br /> the server's remote service URL provided below will not be accessible from other servers." />
			<cfinvokeargument name="messageDetail" value="Use this link to access cascade using the IP address: <a href=""http://#variables.serverIP##application.settings.appBaseDir#/remote/"">http://#variables.serverIP##application.settings.appBaseDir#/remote/</a>" />
		</cfinvoke>
	</cfif>
	
</cfsilent>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
	<head>
		
		<cfinclude template="#application.settings.appBaseDir#/inc/head.cfm" />
		<cfoutput>
			<title>#application.settings.appTitle# - Remote Servers</title>
		</cfoutput>
		
		<script type="text/javascript">
		
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
							<h1>Remote Servers</h1>
						</div>
						
						<div class="contentSection">
							
							<ul class="menuIndex">
								<li><a href="#application.settings.appBaseDir#/remote/register.cfm">Register A New Remote Server</a></li>
								<cfif variables.remoteServers.recordCount>
									<li><a href="#application.settings.appBaseDir#/remote/browse.cfm">Browse Remote Servers</a></li>
								</cfif>
							</ul>
							
							<hr />
							
							<h2>This server's remote service URL:</h2>
							
							<input type="text" size="100%" value="#request.baseLink##application.settings.appBaseDir#/com/remoteService.cfc?wsdl" />
							
							<!--
							<h2>This server's ServerID:</h2>
							
							<input type="text" size="100%" value="#application.config.cascadeID#" />
							-->
							
							
							<h2>Enter Remote Server's ID to get a validation Code:</h2>
							
							<form action="index.cfm" method="get">
								<table class="dataTable" width="100%">
									<tr>
										<th width="125">
											Server ID:
										</th>
										<td width="400" class="noBorder">
											<input type="text" name="serverID" value="#url.serverID#" size="60" />
										</td>
										<td class="noBorder">											
											<input type="submit" value="Get Validation Code" class="bigButton" />
										</td>
									</tr>
									<cfif structKeyExists(url,"serverID") AND len(trim(url.serverID)) AND isValid("uuid",url.serverID)>
										<tr>
											<cfinvoke component="#application.objs.remoteService#" method="createValidationCodeForServerID" returnvariable="variables.validationCode">
												<cfinvokeargument name="serverID" value="#trim(url.serverID)#" />
												<cfinvokeargument name="createdbyuserid" value="#session.login.getUserID()#" />	<!---Type:String Hint:  - CHAR (35) --->
												<cfinvokeargument name="createdbyusername" value="#session.login.getUsername()#" />	<!---Type:String Hint:  - VARCHAR (100) --->
												<cfinvokeargument name="createdbyuserfullname" value="#session.login.getFullname()#" />	<!---Type:String Hint:  - VARCHAR (100) --->
												<cfinvokeargument name="createdbyuseremail" value="#session.login.getEmail()#" />	<!---Type:String Hint:  - VARCHAR (255) --->
											</cfinvoke>
									
											<th width="125">
												Validation Code:
											</th>
											<td class="noBorder">
												<input type="text" size="60" value="#formatValidationCode(variables.validationCode.validationCode)#" />
											</td>
										</tr>
									</cfif>
									
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


<cffunction name="formatValidationCode" access="public" returntype="string" output="false" hint="">
	<cfargument name="input" type="string" required="True" />
	
	<cfset var output = "" />
	
	<cfloop from="1" to="#len(arguments.input)#" index="i" step="5">
		<cfif i NEQ 1>
			<cfset output = output & "-" />
		</cfif>
		
		<cfset output = output & mid(arguments.input,i,5) />
	</cfloop>
	
<cfreturn output />
</cffunction>
















