
<cfinclude template="#application.settings.appBaseDir#/inc/preProcess.cfm" />

<cfif structKeyExists(url,"action")>
	<cfswitch expression="#url.action#">
		<cfcase value="downloadArchive">
			<cfloop collection="#url#" item="variables.item">
				<cfset form[item] = url[item] />
			</cfloop>
		</cfcase>
		<cfdefaultcase />
	</cfswitch>
</cfif>


<cfif structKeyExists(form,"action")>
	<cfswitch expression="#form.action#">
		
		<cfcase value="registerServer">
		
			<cfif NOT session.login.isUserInGroup("admin")>
				<cflocation url="#application.settings.appBaseDir#/index.cfm" />
			</cfif>		
		
			<cfset populateTempFormVariables(form,"registerRemoteServerForm") />
		
			<!--- check all of the form variables --->
			<cfif NOT structKeyExists(form,"serverURL") OR NOT isValid("URL",form.serverURL)>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/archive/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="Server Remote Service URL is required." />
				</cfinvoke>
			</cfif>
			
			<cfif NOT structKeyExists(form,"validationCode") OR NOT len(trim(replace(form.validationCode,"-","","all"))) EQ 40>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/archive/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="A Valid Validation Code is required." />
				</cfinvoke>
			</cfif>
		
			
			<cfif session.messenger.hasAlerts()>
				<cflocation url="#application.settings.appBaseDir#/remote/register.cfm" />
			</cfif>
			
			<!--- attempt to contact the remote url wsdl and check the validation code --->
			
			<cftry>
				<cfinvoke webservice="#form.serverURL#" method="checkValidationCode" returnvariable="variables.checkValidationCodeRet">
					<cfinvokeargument name="serverID" value="#application.config.cascadeID#" />
					<cfinvokeargument name="validationCode" value="#form.validationCode#" />
				</cfinvoke>
			<cfcatch>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/archive/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="The Server URL does not appear to be valid." />
					<cfinvokeargument name="messageDetail" value="#cfcatch.message#" />
				</cfinvoke>
			</cfcatch>
			</cftry>
			
			<cfif session.messenger.hasAlerts()>
				<cflocation url="#application.settings.appBaseDir#/remote/register.cfm" />
			</cfif>
			
			<cfif NOT variables.checkValidationCodeRet>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/archive/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="The validation code provided was rejected by the server." />
					<cfinvokeargument name="messageDetail" value="Go to the remote server and provide this server's ID to get a new validation code." />
				</cfinvoke>
			</cfif>			
			
			<cfif session.messenger.hasAlerts()>
				<cflocation url="#application.settings.appBaseDir#/remote/register.cfm" />
			<cfelse>
				<cfset structClear(session.tempFormVars.registerRemoteServerForm) />
			</cfif>
			
			<!--- get the information for the server --->
			
			<cfinvoke webservice="#form.serverURL#" method="identifyServer" returnvariable="variables.identifyServerRet">
				<cfinvokeargument name="serverID" value="#application.config.cascadeID#" />
				<cfinvokeargument name="validationCode" value="#form.validationCode#" />
			</cfinvoke>
			
			<cfinvoke component="#application.objs.remoteService#" method="registerRemoteServer">
				<cfinvokeargument name="serverID" value="#variables.identifyServerRet.serverID#" />
				<cfinvokeargument name="serverName" value="#variables.identifyServerRet.serverName#" />
				<cfinvokeargument name="serverURL" value="#trim(form.serverURL)#" />
				<cfinvokeargument name="validationCode" value="#trim(replace(form.validationCode,"-","","all"))#" />
				<cfinvokeargument name="serverVersion" value="#variables.identifyServerRet.serverVersion#" />
				<cfinvokeargument name="configuredbyuserid" value="#session.login.getUserID()#" />	<!---Type:String Hint:  - CHAR (35) --->
				<cfinvokeargument name="configuredbyusername" value="#session.login.getUsername()#" />	<!---Type:String Hint:  - VARCHAR (100) --->
				<cfinvokeargument name="configuredbyuserfullname" value="#session.login.getFullname()#" />	<!---Type:String Hint:  - VARCHAR (100) --->
				<cfinvokeargument name="configuredbyuseremail" value="#session.login.getEmail()#" />	<!---Type:String Hint:  - VARCHAR (255) --->
			</cfinvoke>
			
			<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
				<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/archive/action.cfm" />
				<cfinvokeargument name="messageType" value="Information" />
				<cfinvokeargument name="messageText" value="The server #variables.identifyServerRet.serverName# was successfully registered." />
			</cfinvoke>
			
			<cflocation url="#application.settings.appBaseDir#/remote/server.cfm?serverID=#variables.identifyServerRet.serverID#" />
		</cfcase>
		
		<cfcase value="downloadArchive">
			
			<cfif NOT session.login.isUserInGroup("admin")>
				<cflocation url="#application.settings.appBaseDir#/index.cfm" />
			</cfif>		
		
			<!--- check all of the form variables --->
			<cfif NOT structKeyExists(form,"serverID") OR NOT isValid("UUID",form.serverID)>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/archive/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="Server ID is required." />
				</cfinvoke>
			</cfif>
			
			<cfif session.messenger.hasAlerts()>
				<cflocation url="#application.settings.appBaseDir#/remote/index.cfm" />
			</cfif>
			
			<cfif NOT structKeyExists(form,"archiveID") OR NOT isValid("UUID",form.archiveID)>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/archive/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="Remote Archive ID is required." />
				</cfinvoke>
			</cfif>

			<cfif session.messenger.hasAlerts()>
				<cflocation url="#application.settings.appBaseDir#/remote/server.cfm?serverID=#form.serverID#" />
			</cfif>
			
			<!--- attempt to contact the remote url wsdl and check the validation code --->
			<cfinvoke component="#application.objs.remoteService#" method="getRemoteServerByServerID" returnvariable="variables.server">
				<cfinvokeargument name="serverID" value="#url.serverID#" />
			</cfinvoke>
					
			<cfif NOT variables.server.recordCount>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/archive/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="Invalid Server ID" />
				</cfinvoke>
			</cfif>		
				
			<cfif session.messenger.hasAlerts()>
				<cflocation url="#application.settings.appBaseDir#/remote/server.cfm?serverID=#form.serverID#" />
			</cfif>			
			
			<cftry>
				<cfinvoke webservice="#variables.server.serverURL#" method="checkValidationCode" returnvariable="variables.checkValidationCodeRet">
					<cfinvokeargument name="serverID" value="#application.config.cascadeID#" />
					<cfinvokeargument name="validationCode" value="#variables.server.validationCode#" />
				</cfinvoke>
			<cfcatch>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/archive/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="The Server URL does not appear to be valid." />
					<cfinvokeargument name="messageDetail" value="#cfcatch.message#" />
				</cfinvoke>
			</cfcatch>
			</cftry>
			
			<cfif session.messenger.hasAlerts()>
				<cflocation url="#application.settings.appBaseDir#/remote/archive.cfm?serverID=#form.serverID#&archiveID=#form.archiveID#" />
			</cfif>
			
			<cfif NOT variables.checkValidationCodeRet>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/archive/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="The validation code provided was rejected by the server." />
					<cfinvokeargument name="messageDetail" value="Go to the remote server and provide this server's ID to get a new validation code." />
				</cfinvoke>
			</cfif>			
			
			<cfif session.messenger.hasAlerts()>
				<cflocation url="#application.settings.appBaseDir#/remote/archive.cfm?serverID=#form.serverID#&archiveID=#form.archiveID#" />
			</cfif>
			
			
			
			<!---<cfdump var="#variables.downloadArchiveResult#" />--->
			
			
			
			<cfset variables.tempDir = application.config.archiveDirectory & "temp" & application.settings.pathSeperator />
			<cfif NOT directoryExists(variables.tempDir)>
				<cfdirectory action="create" directory="#variables.tempDir#" />
			</cfif>
			
			<cfset variables.newFilename = createUUID() & ".zip" />
			<cfset variables.tempFilePath = variables.tempDir & variables.newFilename />
			
			<!---<cffile action="write" file="#variables.tempFilePath#" output="#variables.downloadArchiveResult.fileContent#"/> --->
			
			<cfhttp url="#listFirst(variables.server.serverURL,"?")#" method="GET" result="variables.downloadArchiveResult" path="#variables.tempDir#" file="#variables.newFilename#">
				<cfhttpparam name="method" value="downloadArchive" type="URL" />
				<cfhttpparam name="serverID" value="#application.config.cascadeID#" type="URL" />
				<cfhttpparam name="validationCode" value="#variables.server.validationCode#" type="URL" />
				<cfhttpparam name="serverName" value="#application.config.serverName#" type="URL" />
				<cfhttpparam name="archiveID" value="#form.archiveID#" type="URL" />
			</cfhttp>
		
		
			<cftry>
				<!--- get the manifest --->
				<cfzip action="read" file="#variables.tempFilePath#" variable="variables.manifestWDDX" entrypath="META-INF/TITUS-MANIFEST.xml" />
			
			<cfcatch>
			
				<cfdump var="#cfcatch#" />
				
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/archive/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="This zip file does not seem to be a valid archive." />
					<cfinvokeargument name="messageDetail" value="This archive does not have a META-INF/TITUS-MANIFEST.xml File" />
				</cfinvoke>
								
			</cfcatch>
			</cftry>
			
			<cfif session.messenger.hasAlerts()>				
				
				
				<cfdump var="#variables#" />
				<cfabort />
				<cffile action="delete" file="#variables.tempFilePath#" />				
				<cflocation url="#application.settings.appBaseDir#/remote/archive.cfm?serverID=#form.serverID#&archiveID=#form.archiveID#" />				
			</cfif>

			<cftry>			
				<cfwddx action="wddx2cfml" input="#variables.manifestWDDX#" output="variables.manifest" validate="true" />
			<cfcatch>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/archive/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="This zip file does not seem to be a valid archive." />
					<cfinvokeargument name="messageDetail" value="This META-INF/TITUS-MANIFEST.xml File seems to be malformed." />
				</cfinvoke>
			</cfcatch>
			</cftry>
			
			
			<cfif session.messenger.hasAlerts()>				
				<cffile action="delete" file="#variables.tempFilePath#" />				
				<cflocation url="#application.settings.appBaseDir#/remote/archive.cfm?serverID=#form.serverID#&archiveID=#form.archiveID#" />				
			</cfif>
						
			<!--- check to make sure we have everything. --->
			<cfif structKeyExists(variables.manifest,"fileList") AND isStruct(variables.manifest.fileList)
					AND structKeyExists(variables.manifest,"archiveID") AND isValid("UUID",variables.manifest.archiveID)
					AND structKeyExists(variables.manifest,"buildSystem")
					AND structKeyExists(variables.manifest,"applicationName")
					AND structKeyExists(variables.manifest,"versionName")
					AND structKeyExists(variables.manifest,"projectName")
					AND structKeyExists(variables.manifest,"projectNumber")
					AND structKeyExists(variables.manifest,"ticketNumber")
					AND structKeyExists(variables.manifest,"changeReason")
					AND structKeyExists(variables.manifest,"author")
					AND structKeyExists(variables.manifest,"changeDescription")
					AND structKeyExists(variables.manifest,"buildByUserID")
					AND structKeyExists(variables.manifest,"buildByUsername")
					AND structKeyExists(variables.manifest,"buildByUserFullname")
					AND structKeyExists(variables.manifest,"buildByUserEmail")
					AND structKeyExists(variables.manifest,"buildOn") AND isDate(variables.manifest.buildOn)
					AND structKeyExists(variables.manifest,"buildDir")
					AND structKeyExists(variables.manifest,"backupOfArchiveID")
					AND structKeyExists(variables.manifest,"archiveSHAHash")
					AND structKeyExists(variables.manifest,"certifications")
					AND structKeyExists(variables.manifest,"deployments")
					AND structKeyExists(variables.manifest,"deploymentFilesManifest")
					AND structKeyExists(variables.manifest,"log")>
					
			
			<cfelse>
			
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/archive/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="This zip file does not seem to be a valid archive." />
					<cfinvokeargument name="messageDetail" value="This META-INF/TITUS-MANIFEST.xml File does not have all of the necessary information." />
				</cfinvoke>	
			</cfif>
			
			<cfparam name="variables.manifest.deployDirSuggestions" default="" />
			<cfparam name="variables.manifest.isObsolete" default="0" />			
			
			<cfif session.messenger.hasAlerts()>				
				<cffile action="delete" file="#variables.tempFilePath#" />				
				<cflocation url="#application.settings.appBaseDir#/remote/archive.cfm?serverID=#form.serverID#&archiveID=#form.archiveID#" />			
			</cfif>
			
			
			<!--- check the hashes --->
			<cfset variables.tempZipFilePath = variables.tempFilePath />
			
			<cfset variables.archiveSHAHash = application.objs.global.getArchiveZipFileHash(variables.tempZipFilePath,variables.manifest.archiveID) />
			
			<cfif variables.archiveSHAHash NEQ variables.manifest.archiveSHAHash>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="WARNING! The archive may have been tampered with!" />
					<cfinvokeargument name="messageDetail" value="The hash of the archive according to the manifest (#variables.manifest.archiveSHAHash#)<BR /> does NOT match the hash of the archive that was uploaded (#variables.archiveSHAHash#)<br />The upload was not accepted." />
				</cfinvoke>
			</cfif>			
			
			<cfif session.messenger.hasAlerts()>				
				<cffile action="delete" file="#variables.tempZipFileResult.serverDirectory#application.settings.pathSeperator#variables.tempZipFileResult.serverFile#" />				
				<cflocation url="#application.settings.appBaseDir#/remote/archive.cfm?serverID=#form.serverID#&archiveID=#form.archiveID#" />			
			</cfif>
			
			<!--- okay, we have everything, lets make sure that this archive isnt already in this system --->
						
			<cfinvoke component="#application.daos.cascade#" method="getArchiveByArchiveID" returnvariable="variables.archive">
				<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
				<cfinvokeargument name="archiveID" value="#variables.manifest.archiveID#" />	<!---Type:string  --->
			</cfinvoke>
		
			<cfif variables.archive.recordCount>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/archive/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="This archive already exists on this system." />
					<cfinvokeargument name="messageDetail" value="You cannot upload an already existing archive to the system again." />
				</cfinvoke>
				
				<cffile action="delete" file="#variables.tempFilePath#" />				
				
				<cflocation url="#application.settings.appBasedir#/archive/archive.cfm?archiveID=#variables.manifest.archiveID#" />
			</cfif>
			<!--- okay, we dont already have this file, lets move it to the right place, create the archive record for it and log it --->
			
			<cfset variables.archiveID = variables.manifest.archiveID />
			
			<cfset variables.zipFilePath = application.config.archiveDirectory & application.settings.pathSeperator & variables.archiveID & ".zip" />
			
			<cffile action="move" source="#variables.tempFilePath#" destination="#variables.zipFilePath#" />
			
			<cfset variables.fileCounter = 0 />
			
			<cfloop collection="#variables.manifest.fileList#" item="variables.key">
				<cfinvoke component="#application.daos.cascade#" method="insertArchiveFile">
					<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
					<cfinvokeargument name="archiveid" value="#variables.archiveid#" />	<!---Type:String Hint:  - CHAR (35) --->
					<cfinvokeargument name="fileshahash" value="#variables.manifest.fileList[variables.key]#" />	<!---Type:String Hint:  - CHAR (40) --->
					<cfinvokeargument name="filepath" value="#variables.key#" />	<!---Type:String Hint:  - VARCHAR (255) --->
				</cfinvoke>
				
				<cfset variables.fileCounter++ />
			</cfloop>
							
			<cfinvoke component="#application.daos.cascade#" method="createArchive">
				<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
				<cfinvokeargument name="archiveID" value="#variables.archiveID#" />	<!---Type:String Hint:  - CHAR (35) --->
				<cfinvokeargument name="archiveshahash" value="#variables.archiveSHAHash#" />	<!---Type:String Hint:  - CHAR (40) --->
				<cfinvokeargument name="buildsystemname" value="#variables.manifest.buildSystem#" />	<!---Type:String Hint:  - VARCHAR (255) --->
				<cfinvokeargument name="applicationname" value="#variables.manifest.applicationname#" />	<!---Type:String Hint:  - VARCHAR (255) --->
				<cfinvokeargument name="versionname" value="#variables.manifest.versionName#" />	<!---Type:String Hint:  - VARCHAR (50) --->
				<cfinvokeargument name="projectname" value="#variables.manifest.projectname#" />	<!---Type:String Hint:  - VARCHAR (255) --->
				<cfinvokeargument name="projectnumber" value="#variables.manifest.projectnumber#" />	<!---Type:String Hint:  - VARCHAR (50) --->
				<cfinvokeargument name="ticketnumber" value="#variables.manifest.ticketnumber#" />	<!---Type:String Hint:  - VARCHAR (150) --->
				<cfinvokeargument name="changereason" value="#variables.manifest.changereason#" />	<!---Type:String Hint:  - VARCHAR (50) --->
				<cfinvokeargument name="author" value="#variables.manifest.author#" />	<!---Type:String Hint:  - VARCHAR (255) --->
				<cfinvokeargument name="changedescription" value="#variables.manifest.changedescription#" />	<!---Type:String Hint:  - LONG VARCHAR (32700) --->
				<cfinvokeargument name="buildbyuserid" value="#variables.manifest.buildByUserID#" />	<!---Type:String Hint:  - CHAR (35) --->
				<cfinvokeargument name="buildbyusername" value="#variables.manifest.buildByUsername#" />	<!---Type:String Hint:  - VARCHAR (100) --->
				<cfinvokeargument name="buildbyuserfullname" value="#variables.manifest.buildByUserFullname#" />	<!---Type:String Hint:  - VARCHAR (100) --->
				<cfinvokeargument name="buildbyuseremail" value="#variables.manifest.buildByUserEmail#" />	<!---Type:String Hint:  - VARCHAR (255) --->
				<cfinvokeargument name="builddir" value="#variables.manifest.buildDir#" />	<!---Type:String Hint:  - VARCHAR (1000) --->
				<cfinvokeargument name="deployDirSuggestions" value="#variables.manifest.deployDirSuggestions#" />	<!---Type:String Hint:  - VARCHAR (5000) --->
				<cfinvokeargument name="filecount" value="#variables.fileCounter#" />	<!---Type:Numeric Hint:  - INTEGER (10) --->
				<cfinvokeargument name="isnativebuild" value="0" />	<!---Type:Numeric Hint:  - INTEGER (10) --->
				<cfinvokeargument name="isbackuparchive" value="0" />	<!---Type:Numeric Hint:  - INTEGER (10) --->
				<cfinvokeargument name="isObsolete" value="#variables.manifest.isObsolete#" />	<!---Type:Numeric Hint:  - INTEGER (10) --->
				<cfinvokeargument name="backupforarchiveid" value="" />	<!---Type:String Hint:  - CHAR (35) --->				
			</cfinvoke>
			
			<cfloop query="variables.manifest.certifications">
				<cfinvoke component="#application.daos.cascade#" method="insertArchiveCertification" returnvariable="insertArchiveCertificationRet">
					<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
					<cfinvokeargument name="certificationID" value="#variables.manifest.certifications.certificationID#" />	<!---Type:String Hint:  - CHAR (35) --->
					<cfinvokeargument name="archiveid" value="#variables.manifest.certifications.archiveID#" />	<!---Type:String Hint:  - CHAR (35) --->
					<cfinvokeargument name="archiveshahash" value="#variables.manifest.certifications.archiveSHAHash#" />	<!---Type:String Hint:  - CHAR (40) --->
					<cfinvokeargument name="userid" value="#variables.manifest.certifications.userID#" />	<!---Type:String Hint:  - CHAR (35) --->
					<cfinvokeargument name="userfullname" value="#variables.manifest.certifications.userFullname#" />	<!---Type:String Hint:  - VARCHAR (100) --->
					<cfinvokeargument name="useremail" value="#variables.manifest.certifications.useremail#" />	<!---Type:String Hint:  - VARCHAR (255) --->
					<cfinvokeargument name="certificationTypeName" value="#variables.manifest.certifications.certificationTypeName#" />	<!---Type:Numeric Hint:  - VARCHAR (25) --->
					<cfinvokeargument name="certificationhash" value="#variables.manifest.certifications.certificationHash#" />	<!---Type:String Hint:  - CHAR (40) --->
					<cfinvokeargument name="certificationon" value="#variables.manifest.certifications.certificationOn#" />	<!---Type:date Hint:  - TIMESTAMP (26) --->
					<cfinvokeargument name="certificationnotes" value="#variables.manifest.certifications.certificationNotes#" />	<!---Type:String Hint:  - LONG VARCHAR --->
					<cfinvokeargument name="certificationSystemName" value="#variables.manifest.certifications.certificationSystemName#" />
			</cfinvoke>
			</cfloop>
			
			<cfloop query="variables.manifest.deployments">
				<cfinvoke component="#application.daos.cascade#" method="createDeployment" returnvariable="createDeploymentRet">
					<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
					<cfinvokeargument name="deploymentID" value="#variables.manifest.deployments.deploymentID#" />	<!---Type:String Hint:  - CHAR (35) --->
					<cfinvokeargument name="archiveid" value="#variables.manifest.deployments.archiveID#" />	<!---Type:String Hint:  - CHAR (35) --->
					<cfinvokeargument name="archiveshahash" value="#variables.manifest.deployments.archiveSHAHash#" />	<!---Type:String Hint:  - CHAR (40) --->
					<cfinvokeargument name="buildsystemname" value="#variables.manifest.deployments.buildSystemName#" />	<!---Type:String Hint:  - VARCHAR (255) --->
					<cfinvokeargument name="deployedSystemname" value="#variables.manifest.deployments.deployedSystemName#" />	<!---Type:String Hint:  - VARCHAR (255) --->
					<cfinvokeargument name="deployedbyuserid" value="#variables.manifest.deployments.deployedByUserID#" />	<!---Type:String Hint:  - CHAR (35) --->
					<cfinvokeargument name="deployedbyusername" value="#variables.manifest.deployments.deployedByUsername#" />	<!---Type:String Hint:  - VARCHAR (100) --->
					<cfinvokeargument name="deployedbyuserfullname" value="#variables.manifest.deployments.deployedByUserFullname#" />	<!---Type:String Hint:  - VARCHAR (100) --->
					<cfinvokeargument name="deployedbyuseremail" value="#variables.manifest.deployments.deployedByUserEmail#" />	<!---Type:String Hint:  - VARCHAR (255) --->
					<cfinvokeargument name="deployedon" value="#variables.manifest.deployments.deployedOn#" />	<!---Type:date Hint:  - TIMESTAMP (26) --->
					<cfinvokeargument name="deploymentdir" value="#variables.manifest.deployments.deploymentDir#" />	<!---Type:String Hint:  - VARCHAR (1000) --->
					<cfinvokeargument name="deploymentNotes" value="#variables.manifest.deployments.deploymentNotes#" />	<!---Type:String Hint:  - LONG VARCHAR --->
					<cfinvokeargument name="wasbackuptaken" value="#variables.manifest.deployments.wasBackupTaken#" />	<!---Type:Numeric Hint:  - INTEGER (10) --->
					<cfinvokeargument name="backupArchiveID" value="#variables.manifest.deployments.backupArchiveID#" />	<!---Type:String Hint:  - CHAR (35) --->
				</cfinvoke>	
			</cfloop>
			
			<cfloop query="variables.manifest.deploymentFilesManifest">
				<cfinvoke component="#application.daos.cascade#" method="insertDeploymentFileManifest">
					<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
					<cfinvokeargument name="deploymentFileManifestID" value="#variables.manifest.deploymentFilesManifest.deploymentFileManifestID#" />	<!---Type:String Hint:  - CHAR (35) --->
					<cfinvokeargument name="deploymentid" value="#variables.manifest.deploymentFilesManifest.deploymentid#" />	<!---Type:String Hint:  - CHAR (35) --->
					<cfinvokeargument name="archiveid" value="#variables.manifest.deploymentFilesManifest.archiveid#" />	<!---Type:String Hint:  - CHAR (35) --->
					<cfinvokeargument name="deployedsystemname" value="#variables.manifest.deploymentFilesManifest.deployedsystemname#" />	<!---Type:String Hint:  - VARCHAR (255) --->
					<cfinvokeargument name="archivefileid" value="#variables.manifest.deploymentFilesManifest.archivefileid#" />	<!---Type:String Hint:  - CHAR (35) --->
					<cfinvokeargument name="deployedfilepath" value="#variables.manifest.deploymentFilesManifest.deployedfilepath#" />	<!---Type:String Hint:  - VARCHAR (255) --->
					<cfinvokeargument name="backupArchiveID" value="#variables.manifest.deploymentFilesManifest.backupArchiveID#" />	<!---Type:String Hint:  - CHAR (35) --->
					<cfinvokeargument name="backupArchiveFileID" value="#variables.manifest.deploymentFilesManifest.backupArchiveFileID#" />	<!---Type:String Hint:  - CHAR (35) --->
					<cfinvokeargument name="previousfileshahash" value="#variables.manifest.deploymentFilesManifest.previousfileshahash#" />	<!---Type:String Hint:  - CHAR (40) --->
				</cfinvoke>
			</cfloop>
			
			<cfloop query="variables.manifest.log">
				<cfinvoke component="#application.daos.cascade#" method="insertArchiveLog">
					<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
					<cfinvokeargument name="logID" value="#variables.manifest.log.logID#" />	<!---Type:String Hint:  - CHAR (35) --->
					<cfinvokeargument name="archiveid" value="#variables.manifest.log.archiveid#" />	<!---Type:String Hint:  - CHAR (35) --->
					<cfinvokeargument name="archiveshahash" value="#variables.manifest.log.archiveshahash#" />	<!---Type:String Hint:  - CHAR (40) --->
					<cfinvokeargument name="buildsystemname" value="#variables.manifest.log.buildSystemName#" />	<!---Type:String Hint:  - VARCHAR (255) --->
					<cfinvokeargument name="logSystemName" value="#variables.manifest.log.logSystemName#" />	<!---Type:String Hint:  - VARCHAR (255) --->
					<cfinvokeargument name="logaction" value="#variables.manifest.log.logAction#" />	<!---Type:String Hint:  - VARCHAR (50) --->
					<cfinvokeargument name="deployflag" value="#variables.manifest.log.deployFlag#" />	<!---Type:Numeric Hint:  - INTEGER (10) --->
					<cfinvokeargument name="backupcreatedflag" value="#variables.manifest.log.backupCreatedFlag#" />	<!---Type:Numeric Hint:  - INTEGER (10) --->
					<cfinvokeargument name="backuparchiveid" value="#variables.manifest.log.backupArchiveID#" />	<!---Type:String Hint:  - CHAR (35) --->
					<cfinvokeargument name="userid" value="#variables.manifest.log.userID#" />	<!---Type:String Hint:  - CHAR (35) --->
					<cfinvokeargument name="logmessage" value="#variables.manifest.log.logMessage#" />	<!---Type:String Hint:  - VARCHAR (1000) --->
					<cfinvokeargument name="logDateTime" value="#variables.manifest.log.logDateTime#" />
				</cfinvoke>
			</cfloop>
			
			<cfinvoke component="#application.daos.cascade#" method="insertArchiveLog">
				<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
				<cfinvokeargument name="archiveid" value="#variables.archiveid#" />	<!---Type:String Hint:  - CHAR (35) --->
				<cfinvokeargument name="archiveshahash" value="#variables.archiveshahash#" />	<!---Type:String Hint:  - CHAR (40) --->
				<cfinvokeargument name="buildsystemname" value="#variables.manifest.buildSystem#" />	<!---Type:String Hint:  - VARCHAR (255) --->
				<cfinvokeargument name="logSystemName" value="#application.config.serverName#" />	<!---Type:String Hint:  - VARCHAR (255) --->
				<cfinvokeargument name="logaction" value="REMOTERETRIEVEARCHIVE" />	<!---Type:String Hint:  - VARCHAR (50) --->
				<cfinvokeargument name="deployflag" value="0" />	<!---Type:Numeric Hint:  - INTEGER (10) --->
				<cfinvokeargument name="backupcreatedflag" value="0" />	<!---Type:Numeric Hint:  - INTEGER (10) --->
				<cfinvokeargument name="backuparchiveid" value="" />	<!---Type:String Hint:  - CHAR (35) --->
				<cfinvokeargument name="userid" value="#session.login.getUserID()#" />	<!---Type:String Hint:  - CHAR (35) --->
				<cfinvokeargument name="logmessage" value="#variables.archiveID# (#lcase(left(variables.archiveSHAHash,application.settings.showFirstXCharsOfSHA))#) retrieved from #variables.server.serverName# by #session.login.getUsername()#" />	<!---Type:String Hint:  - VARCHAR (1000) --->
				<cfinvokeargument name="logDateTime" value="#now()#" />
			</cfinvoke>

			<cflocation url="#application.settings.appBasedir#/archive/archive.cfm?archiveID=#variables.archiveID#" />

		
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
