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

<cfif structKeyExists(url,"action")>
	<cfswitch expression="#url.action#">
		<cfcase value="logout">
			<cfloop collection="#url#" item="variables.item">
				<cfset form[item] = url[item] />
			</cfloop>
		</cfcase>
		<cfdefaultcase />
	</cfswitch>
</cfif>

<cfif structKeyExists(form,"action")>
	<cfswitch expression="#form.action#">
		<cfcase value="login">
		
			<cfset populateTempFormVariables(form,"loginForm") />
			
			<cfif NOT structKeyExists(form,"username") OR NOT len(trim(form.username))>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="Username is required." />
				</cfinvoke>
			</cfif>
			
			<cfif NOT structKeyExists(form,"password") OR NOT len(trim(form.password))>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="Password is required." />
				</cfinvoke>
			</cfif>
			
			<cfif session.messenger.hasAlerts()>
				<cflocation url="#application.settings.appBaseDir#/login.cfm" />
			</cfif>
			
			
			<cfinvoke component="#session.login#" method="validateAndLogin" returnvariable="variables.authRet">
				<cfinvokeargument name="dsn" value="#application.settings.dsn#" />
				<cfinvokeargument name="username" value="#form.username#" />
				<cfinvokeargument name="password" value="#form.password#" />
			</cfinvoke>
			
			<cfif NOT variables.authRet>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="Invalid Login" />
				</cfinvoke>
			</cfif>
			
			<cfif session.messenger.hasAlerts()>
				<cflocation url="#application.settings.appBaseDir#/login.cfm" />
			<cfelse>
				<cfset structClear(session.tempFormVars.loginForm) />
			</cfif>
			
			<cfif structKeyExists(form,"referringPage") AND len(trim(form.referringPage)) AND NOT findNoCase("clearlogin",form.referringPage)>
				<cflocation url="#form.referringPage#" />
			<cfelse>
				<cflocation url="#application.settings.appBaseDir#/" />
			</cfif>
		
		</cfcase>
		
		<cfcase value="logout">
			<cfif session.login.isLoggedIn()>
				<cfset session.login.logout() />
			</cfif>
			
			<cflocation url="#application.settings.appBaseDir#/" />
		</cfcase>
		
		<cfcase value="createConfig">
		
			<cfparam name="form.showPasswords" default="false" />
		
			<cfset populateTempFormVariables(form,"createConfigForm") />
			
			<cfif NOT structKeyExists(form,"serverName") OR NOT LEN(TRIM(form.serverName))>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="Server Name is required." />
				</cfinvoke>
			</cfif>
			
			<cfif NOT structKeyExists(form,"firstname") OR NOT LEN(TRIM(form.firstname))>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="Admin First Name is required." />
				</cfinvoke>
			</cfif>
			
			<cfif NOT structKeyExists(form,"lastname") OR NOT LEN(TRIM(form.lastname))>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="Admin Last Name is required." />
				</cfinvoke>
			</cfif>
			
			<cfif NOT structKeyExists(form,"username") OR NOT LEN(TRIM(form.username))>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="Admin Username is required." />
				</cfinvoke>
			</cfif>
			
			<cfif NOT structKeyExists(form,"email") OR NOT LEN(TRIM(form.email))>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="Admin Email is required." />
				</cfinvoke>
			<cfelseif NOT isValid("email",form.email)>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="Admin Email: #form.email# does not appear to be a valid format." />
				</cfinvoke>
			</cfif>
			
			<cfif NOT structKeyExists(form,"password") OR NOT LEN(TRIM(form.password))>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="Admin Password is required." />
				</cfinvoke>
			</cfif>
			
			<cfif NOT structKeyExists(form,"password2") OR NOT LEN(TRIM(form.password2))>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="Admin Password Repeat is required." />
				</cfinvoke>
			</cfif>
			
			<cfif structKeyExists(form,"password") AND structKeyExists(form,"password2") AND len(trim(form.password)) AND len(trim(form.password2))>
				<cfif form.password NEQ form.password2>
					<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
						<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/action.cfm" />
						<cfinvokeargument name="messageType" value="Error" />
						<cfinvokeargument name="messageText" value="Admin Passwords do not match." />
					</cfinvoke>
				</cfif>
			</cfif>
			
			<cfif NOT structKeyExists(form,"archiveDirectory") OR NOT LEN(TRIM(form.archiveDirectory))>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="Archive Directory is required." />
				</cfinvoke>
			<cfelseif NOT directoryExists(form.archiveDirectory)>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="Archive Directory must already exist." />
				</cfinvoke>
			</cfif>
						
			<cfif NOT structKeyExists(form,"cfAdminPassword") OR NOT LEN(TRIM(form.cfAdminPassword))>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="ColdFusion Administrator Password is required." />
				</cfinvoke>
			</cfif>
			
			<cfif NOT structKeyExists(form,"dsnName") OR NOT LEN(TRIM(form.dsnName))>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="DerbyDB DSN Name is required." />
				</cfinvoke>
			</cfif>
			
			<cfif NOT structKeyExists(form,"databaseName") OR NOT LEN(TRIM(form.databaseName))>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="DerbyDB Database Name is required." />
				</cfinvoke>
			</cfif>
			
			<cfif NOT structKeyExists(form,"databaseDirectory") OR NOT LEN(TRIM(form.databaseDirectory))>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="DerbyDB Database Directory is required." />
				</cfinvoke>
			<cfelse>
				<cfif right(form.databaseDirectory,1) NEQ application.settings.pathSeperator>
					<cfset form.databaseDirectory = form.databaseDirectory & application.settings.pathSeperator />
				</cfif>
				
				<cfif structKeyExists(form,"databaseName") AND len(trim(form.databaseName)) AND directoryExists(form.databaseDirectory & form.databaseName) >
					<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
						<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/action.cfm" />
						<cfinvokeargument name="messageType" value="Error" />
						<cfinvokeargument name="messageText" value="DerbyDB Database Name already exists in that location." />
						<cfinvokeargument name="messageDetail" value="This directory: #form.databaseDirectory & form.databaseName# cannot already exist." />
					</cfinvoke>
				</cfif>
			</cfif>
			
			<cfif session.messenger.hasAlerts()>
				<cflocation url="#application.settings.appBaseDir#/createConfig.cfm" />
			</cfif>
			
			<!--- try to log into the admin api with the cfadmin password provided so we can give an error if it isnt right --->
			
			<cftry>
				<cfset variables.tempAdminObj = createObject("component","cfide.adminapi.administrator").login(form.cfAdminPassword) />
				<cfset variables.dsnObj = createObject("component","cfide.adminapi.datasource") />
				<cfset variables.existingDSNs = dsnObj.getDatasources() />
				
			<cfcatch>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="The ColdFusion Administrator password provided does not seem to be correct." />
					<cfinvokeargument name="messageDetail" value="#cfcatch.message#" />
				</cfinvoke>
			</cfcatch>
			</cftry>
					
			<cfif session.messenger.hasAlerts()>
				<cflocation url="#application.settings.appBaseDir#/createConfig.cfm" />
			<cfelse>
				<cfset structClear(session.tempFormVars.createConfigForm) />
			</cfif>
			
			<!--- do the work --->
			
			<!--- create the database first --->
			<cfinvoke component="#application.daos.install#" method="createNewDerbyDatabase" 
					returnvariable="variables.createNewDerbyDatabaseRet">
				<cfinvokeargument name="administratorPassword" value="#form.cfAdminPassword#" />	<!---Type:string  --->
				<cfinvokeargument name="dsnName" value="#form.dsnName#" />	<!---Type:string  --->
				<cfinvokeargument name="databaseName" value="#form.databaseName#" />	<!---Type:string  --->
				<cfinvokeargument name="databaseDirectory" value="#form.databaseDirectory#" />	<!---Type:string  --->
			</cfinvoke>
			
			<cfset application.config.dsn = form.dsnName />
			
			<!--- lots of code expects the dsn to be in the settings, so copy it over there --->
			<cfset application.settings.dsn = application.config.dsn />
			
			<cfset application.config.cascadeID = createUUID() />
			<cfset application.config.databaseName = form.databaseName />
			<cfset application.config.databaseDirectory = form.databaseDirectory />
			<cfset application.config.serverName = form.serverName />
			<cfset application.config.adminFirstName = form.firstname />
			<cfset application.config.adminLastName = form.lastname />
			<cfset application.config.adminUsername = form.username />
			<cfset application.config.adminEmail = form.email />
			<cfset application.config.archiveDirectory = form.archiveDirectory />
			<cfset application.config.cascadeVersion = "1.0" />
		
			<cfset application.daos.install.createTable_cascadeConfig(application.config.dsn) />
			<cfset application.daos.install.createTable_users(application.config.dsn) />
			<cfset application.daos.install.createTable_userGroupMembers(application.config.dsn) />
			<cfset application.daos.install.createTable_userGroups(application.config.dsn) />
			
			<cfset application.daos.install.createTable_archives(application.config.dsn) />
			<cfset application.daos.install.createTable_archiveDeployments(application.config.dsn) />
			<cfset application.daos.install.createTable_deploymentFilesManifest(application.config.dsn) />
			<cfset application.daos.install.createTable_archiveFiles(application.config.dsn) />
			<cfset application.daos.install.createTable_archiveCertifications(application.config.dsn) />
			<cfset application.daos.install.createTable_archiveLog(application.config.dsn) />
					
			<cfset application.daos.install.createTable_ref_changeTypes(application.config.dsn) />
			<cfset application.daos.install.createTable_ref_certificationTypes(application.config.dsn) />

			<cfset application.daos.install.createTable_remoteValidationCodes(application.config.dsn) />
			<cfset application.daos.install.createTable_remoteServers(application.config.dsn) />
			
			<!--- added in 1.1 --->
			<cfset application.daos.install.createTable_remoteServer_certificationTypes(application.config.dsn) />
			
			<cfloop collection="#application.config#" item="key">
				<cfset application.daos.cascade.setConfigValue(application.config.dsn,key,application.config[key]) />
			</cfloop>			
			
			<!--- create the groups --->
			
			<cfinvoke component="#application.daos.userManagement#" method="addUserGroup" returnvariable="variables.adminGroup">
				<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
				<cfinvokeargument name="userGroupName" value="Admin" />	<!---Type:String Hint:  - varchar (50) --->
				<cfinvokeargument name="userGroupDesc" value="Administrators" />	<!---Type:String Hint:  - varchar (250) --->
			</cfinvoke>
			
			<cfinvoke component="#application.daos.userManagement#" method="addUserGroup" returnvariable="variables.creatorGroup">
				<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
				<cfinvokeargument name="userGroupName" value="Build" />	<!---Type:String Hint:  - varchar (50) --->
				<cfinvokeargument name="userGroupDesc" value="Ability to Build Archives" />	<!---Type:String Hint:  - varchar (250) --->
			</cfinvoke>
			
			<cfinvoke component="#application.daos.userManagement#" method="addUserGroup" returnvariable="variables.deployerGroup">
				<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
				<cfinvokeargument name="userGroupName" value="Deploy" />	<!---Type:String Hint:  - varchar (50) --->
				<cfinvokeargument name="userGroupDesc" value="Ability To Deploy Archives" />	<!---Type:String Hint:  - varchar (250) --->
			</cfinvoke>
			
			<cfinvoke component="#application.daos.userManagement#" method="addUserGroup" returnvariable="variables.deployerGroup">
				<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
				<cfinvokeargument name="userGroupName" value="Upload" />	<!---Type:String Hint:  - varchar (50) --->
				<cfinvokeargument name="userGroupDesc" value="Ability To Upload Archives" />	<!---Type:String Hint:  - varchar (250) --->
			</cfinvoke>
						
			<cfinvoke component="#application.daos.userManagement#" method="addUserGroup" returnvariable="variables.devCertifyGroup">
				<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
				<cfinvokeargument name="userGroupName" value="DevCert" />	<!---Type:String Hint:  - varchar (50) --->
				<cfinvokeargument name="userGroupDesc" value="Ability To Certify Archives for Development" />	<!---Type:String Hint:  - varchar (250) --->
			</cfinvoke>
						
			<cfinvoke component="#application.daos.userManagement#" method="addUserGroup" returnvariable="variables.QACertifyGroup">
				<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
				<cfinvokeargument name="userGroupName" value="QACert" />	<!---Type:String Hint:  - varchar (50) --->
				<cfinvokeargument name="userGroupDesc" value="Ability To Certify Archives for QA" />	<!---Type:String Hint:  - varchar (250) --->
			</cfinvoke>
						
			<cfinvoke component="#application.daos.userManagement#" method="addUserGroup" returnvariable="variables.deployCertifyGroup">
				<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
				<cfinvokeargument name="userGroupName" value="DeployCert" />	<!---Type:String Hint:  - varchar (50) --->
				<cfinvokeargument name="userGroupDesc" value="Ability To Certify Archives for Deployment" />	<!---Type:String Hint:  - varchar (250) --->
			</cfinvoke>
						
			<cfinvoke component="#application.daos.userManagement#" method="addUserGroup" returnvariable="variables.prodCertifyGroup">
				<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
				<cfinvokeargument name="userGroupName" value="ProdCert" />	<!---Type:String Hint:  - varchar (50) --->
				<cfinvokeargument name="userGroupDesc" value="Ability To Certify Archives In Production" />	<!---Type:String Hint:  - varchar (250) --->
			</cfinvoke>
			
			
			<!--- create the admin user --->
			
			<cfinvoke component="#application.daos.userManagement#" method="addUser" returnvariable="variables.adminUser">
				<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
				<cfinvokeargument name="username" value="#form.username#" />	<!---Type:String Hint:  - varchar (100) --->
				<cfinvokeargument name="email" value="#form.email#" />	<!---Type:String Hint:  - varchar (255) --->
				<cfinvokeargument name="firstname" value="#form.firstname#" />	<!---Type:String Hint:  - varchar (50) --->
				<cfinvokeargument name="lastname" value="#form.lastname#" />	<!---Type:String Hint:  - varchar (50) --->
				<cfinvokeargument name="password" value="#form.password#" />	<!---Type:String Hint:  - varchar (100) --->
				<cfinvokeargument name="createdBy" value="INSTALL" />	<!---Type:String Hint:  - varchar (100) --->
			</cfinvoke>
			
			<cfinvoke component="#application.daos.userManagement#" method="addUserToGroup" returnvariable="addUserToGroupRet">
				<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
				<cfinvokeargument name="userID" value="#variables.adminUser.userID#" />	<!---Type:string Hint:  - char(32)  --->
				<cfinvokeargument name="userGroupID" value="#variables.adminGroup.userGroupID#" />	<!---Type:string Hint:  - char(32)  --->
			</cfinvoke>
			
			<!--- fill up the reference tables --->
			
			<cfinvoke component="#application.daos.referenceTables#" method="createChangeType">
				<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
				<cfinvokeargument name="changeTypeName" value="Break/Fix" />	<!---Type:String Hint:  - varchar (15) --->
				<cfinvokeargument name="sort" value="10" />	<!---Type:Numeric Hint:  - int  --->
				<cfinvokeargument name="changeTypeDesc" value="Break/Fix" />	<!---Type:String Hint:  - varchar (250) --->
				<cfinvokeargument name="changeTypeAbbr" value="BREAK/FIX" />	<!---Type:String Hint:  - varchar (250) --->
				<cfinvokeargument name="activeFlag" value="true" />	<!---Type:Boolean Hint:  - int  --->
			</cfinvoke>			
			
			<cfinvoke component="#application.daos.referenceTables#" method="createChangeType">
				<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
				<cfinvokeargument name="changeTypeName" value="Enhancement" />	<!---Type:String Hint:  - varchar (15) --->
				<cfinvokeargument name="sort" value="20" />	<!---Type:Numeric Hint:  - int  --->
				<cfinvokeargument name="changeTypeDesc" value="Enhancement" />	<!---Type:String Hint:  - varchar (250) --->
				<cfinvokeargument name="changeTypeAbbr" value="ENHANCEMENT" />	<!---Type:String Hint:  - varchar (250) --->
				<cfinvokeargument name="activeFlag" value="true" />	<!---Type:Boolean Hint:  - int  --->
			</cfinvoke>
			
			<cfinvoke component="#application.daos.referenceTables#" method="createChangeType">
				<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
				<cfinvokeargument name="changeTypeName" value="General" />	<!---Type:String Hint:  - varchar (15) --->
				<cfinvokeargument name="sort" value="30" />	<!---Type:Numeric Hint:  - int  --->
				<cfinvokeargument name="changeTypeDesc" value="General" />	<!---Type:String Hint:  - varchar (250) --->
				<cfinvokeargument name="changeTypeAbbr" value="GENERAL" />	<!---Type:String Hint:  - varchar (250) --->
				<cfinvokeargument name="activeFlag" value="true" />	<!---Type:Boolean Hint:  - int  --->
			</cfinvoke>
			
			
			<cfinvoke component="#application.daos.referenceTables#" method="createCertificationType">
				<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
				<cfinvokeargument name="certificationTypeName" value="Development" />	<!---Type:String Hint:  - varchar (15) --->
				<cfinvokeargument name="sort" value="10" />	<!---Type:Numeric Hint:  - int  --->
				<cfinvokeargument name="certificationTypeDesc" value="Development" />	<!---Type:String Hint:  - varchar (250) --->
				<cfinvokeargument name="certificationTypeAbbr" value="DEVELOP" />	<!---Type:String Hint:  - varchar (250) --->
				<cfinvokeargument name="requiredUserGroupName" value="DevCert" />	<!---Type:String Hint:  - varchar (250) --->
				<cfinvokeargument name="activeFlag" value="true" />	<!---Type:Boolean Hint:  - int  --->
			</cfinvoke>			
			
			<cfinvoke component="#application.daos.referenceTables#" method="createCertificationType">
				<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
				<cfinvokeargument name="certificationTypeName" value="QA" />	<!---Type:String Hint:  - varchar (15) --->
				<cfinvokeargument name="sort" value="20" />	<!---Type:Numeric Hint:  - int  --->
				<cfinvokeargument name="certificationTypeDesc" value="QA" />	<!---Type:String Hint:  - varchar (250) --->
				<cfinvokeargument name="certificationTypeAbbr" value="QA" />	<!---Type:String Hint:  - varchar (250) --->
				<cfinvokeargument name="requiredUserGroupName" value="QACert" />	<!---Type:String Hint:  - varchar (250) --->
				<cfinvokeargument name="activeFlag" value="true" />	<!---Type:Boolean Hint:  - int  --->
			</cfinvoke>
						
			<cfinvoke component="#application.daos.referenceTables#" method="createCertificationType">
				<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
				<cfinvokeargument name="certificationTypeName" value="Deployment" />	<!---Type:String Hint:  - varchar (15) --->
				<cfinvokeargument name="sort" value="30" />	<!---Type:Numeric Hint:  - int  --->
				<cfinvokeargument name="certificationTypeDesc" value="Deployment" />	<!---Type:String Hint:  - varchar (250) --->
				<cfinvokeargument name="certificationTypeAbbr" value="DEPLOY" />	<!---Type:String Hint:  - varchar (250) --->
				<cfinvokeargument name="requiredUserGroupName" value="DeployCert" />	<!---Type:String Hint:  - varchar (250) --->
				<cfinvokeargument name="activeFlag" value="true" />	<!---Type:Boolean Hint:  - int  --->
			</cfinvoke>
			
			<cfinvoke component="#application.daos.referenceTables#" method="createCertificationType">
				<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
				<cfinvokeargument name="certificationTypeName" value="Production" />	<!---Type:String Hint:  - varchar (15) --->
				<cfinvokeargument name="sort" value="40" />	<!---Type:Numeric Hint:  - int  --->
				<cfinvokeargument name="certificationTypeDesc" value="Production" />	<!---Type:String Hint:  - varchar (250) --->
				<cfinvokeargument name="certificationTypeAbbr" value="PROD" />	<!---Type:String Hint:  - varchar (250) --->
				<cfinvokeargument name="requiredUserGroupName" value="ProdCert" />	<!---Type:String Hint:  - varchar (250) --->
				<cfinvokeargument name="activeFlag" value="true" />	<!---Type:Boolean Hint:  - int  --->
			</cfinvoke>			
			

			<cfset application.objs.global.createConfigXML(application.config) />
			
			<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
				<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/action.cfm" />
				<cfinvokeargument name="messageType" value="Information" />
				<cfinvokeargument name="messageText" value="Configuration Successfully Created!" />
			</cfinvoke>

			<cflocation url="#application.settings.appBaseDir#/login.cfm?username=#form.username#" />
		
		</cfcase>
		
		<cfdefaultcase>
			<cflocation url="#application.settings.appBaseDir#/" />
		</cfdefaultcase>
	</cfswitch>
<cfelse>
	<cflocation url="#application.settings.appBaseDir#/" />
</cfif>

<cffunction name="populateTempFormVariables" access="public" returntype="struct" output="false" hint="">
	<cfargument name="formStruct" type="Struct" required="True" />
	<cfargument name="formName" type="string" required="True" />
	
	<cfset VAR formitem = "" />
	
	<cfloop collection="#arguments.formStruct#" item="formitem">
		<cfset session.tempFormVars[arguments.formName][formItem] = arguments.formStruct[formItem] />				
	</cfloop>
	
	<cfset session.tempFormVars[arguments.formName]["populateTime"] = now() />
	<cfset session.tempFormVars[arguments.formName]["formShown"] = True />

<cfreturn session.tempFormVars />
</cffunction>
