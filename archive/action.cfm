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


<cfinclude template="#application.settings.appBaseDir#/inc/preProcess.cfm" />

<cfif structKeyExists(url,"action")>
	<cfswitch expression="#url.action#">
		<cfcase value="downloadArchive,removeCertification,markAsObsolete,unmarkAsObsolete">
			<cfloop collection="#url#" item="variables.item">
				<cfset form[item] = url[item] />
			</cfloop>
		</cfcase>
		<cfdefaultcase />
	</cfswitch>
</cfif>


<cfif structKeyExists(form,"action")>
	<cfswitch expression="#form.action#">
		<cfcase value="buildArchive">
		
			<cfif NOT session.login.isUserInGroup("build")>
				<cflocation url="#application.settings.appBaseDir#/index.cfm" />
			</cfif>
			
			<cfif right(form.dir,1) EQ application.settings.pathSeperator>
				<cfset form.dir = left(form.dir,len(form.dir)-1) />
			</cfif>	
			
			<cfset populateTempFormVariables(form,"buildArchiveForm") />
			
			<cfif NOT listLen(form.file)>
				<cflocation url="build.cfm" />
			</cfif>
			
			<cfset session.tempFormVars["buildArchiveForm"]["fileList"] = arrayNew(1) />
			
			<cfloop from="1" to="#listLen(form.file)#" index="i">
				<cfset session.tempFormVars["buildArchiveForm"]["fileList"][i] = listGetAt(form.file,i) />
			</cfloop>		
						
			<cflocation url="build-step-2.cfm" />
			
		</cfcase>
		
		<cfcase value="buildArchive2">
		
			<cfif NOT session.login.isUserInGroup("build")>
				<cflocation url="#application.settings.appBaseDir#/index.cfm" />
			</cfif>
			
			<cfset populateTempFormVariables(form,"buildArchiveForm") />
			<cfset populateTempFormVariables(form,"buildStep2Form") />
			
			<!--- <cfdump var="#session.tempFormVars["buildArchiveForm"]#" /> --->
			
			<cfset variables.dir = session.tempFormVars["buildArchiveForm"]["dir"] />
			<cfset variables.files = session.tempFormVars["buildArchiveForm"]["fileList"] />

			<cfif right(variables.dir,1) EQ application.settings.pathSeperator>
				<cfset variables.dir = left(variables.dir,len(variables.dir)-1) />
			</cfif>	

			<cfset variables.newLine = chr(10) />

			<cfset variables.deployDirSuggestions = replaceNoCase(form.deployDirSuggestions,variables.newline,",","all") />
			
			<cfset variables.filesHashes = structNew() />
			
			<!--- create the archiveID --->
			<cfset variables.archiveID = createUUID() />
			
			<cfset variables.tempDir = application.config.archiveDirectory & application.settings.pathSeperator & "temp" & application.settings.pathSeperator />
			<cfif NOT directoryExists(variables.tempDir)>
				<cfdirectory action="create" directory="#variables.tempDir#" />
			</cfif>
			
			<!--- create the zip file --->
			<cfset variables.zipFilePath = application.config.archiveDirectory & application.settings.pathSeperator & variables.archiveID & ".zip" />
			<cfset variables.tempZipFilePath = variables.tempDir & application.settings.pathSeperator & variables.archiveID & ".zip" />
		
			<cfzip action="zip" file="#variables.tempZipFilePath#" overwrite="no" storepath="yes">
				<cfloop from="1" to="#arrayLen(variables.files)#" index="i">
					<cfset variables.filesHashes[variables.files[i]] = application.objs.global.getFileSHAHash(variables.files[i]) />
					
					<cfinvoke component="#application.daos.cascade#" method="insertArchiveFile">
						<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
						<cfinvokeargument name="archiveid" value="#variables.archiveid#" />	<!---Type:String Hint:  - CHAR (35) --->
						<cfinvokeargument name="fileshahash" value="#variables.filesHashes[variables.files[i]]#" />	<!---Type:String Hint:  - CHAR (40) --->
						<cfinvokeargument name="filepath" value="#variables.files[i]#" />	<!---Type:String Hint:  - VARCHAR (255) --->
					</cfinvoke>
				
					<cfzipparam source="#variables.files[i]#" entrypath="#replaceNoCase(variables.files[i],variables.dir,"")#" />
				</cfloop>
				
			</cfzip>
			
			<!--- get the hash of the zip file --->
			<cfset variables.archiveSHAHash = application.objs.global.getFileSHAHash(variables.tempZipFilePath) />
				
				
			<!--- create the manifest file --->
			<cfset variables.manifest = structNew() />
				<cfset variables.manifest.fileList = variables.filesHashes />
				<cfset variables.manifest.archiveID = variables.archiveID />
				<cfset variables.manifest.buildSystem = application.config.serverName />
				<cfset variables.manifest.applicationName = form.applicationName />
				<cfset variables.manifest.versionName = form.versionNumber />
				<cfset variables.manifest.projectName = form.projectName />
				<cfset variables.manifest.projectNumber = form.projectNumber />
				<cfset variables.manifest.ticketNumber = form.ticketNumber />
				<cfset variables.manifest.changeReason = form.changeReason />
				<cfset variables.manifest.author = form.author />
				<cfset variables.manifest.changeDescription = form.changeDescription />
				<cfset variables.manifest.buildByUserID = session.login.getUserID() />
				<cfset variables.manifest.buildByUsername = session.login.getUsername() />
				<cfset variables.manifest.buildByUserFullname = session.login.getFullname() />
				<cfset variables.manifest.buildByUserEmail = session.login.getEmail() />
				<cfset variables.manifest.buildOn = now() />
				<cfset variables.manifest.buildDir = variables.dir />
				<cfset variables.manifest.deployDirSuggestions = variables.deployDirSuggestions />
				<cfset variables.manifest.backupOfArchiveID = '' />
				<cfset variables.manifest.isObsolete = false />
				<cfset variables.manifest.archiveSHAHash = variables.archiveSHAHash />
				<cfset variables.manifest.certifications = queryNew("certificationid,archiveid,archiveshahash,userid,userfullname,useremail,certificationtypename,certificationnotes,certificationhash,certificationon,certificationsystemname",
																	"VarChar,VarChar,VarChar,VarChar,VarChar,VarChar,VarChar,VarChar,VarChar,Date,VarChar") />
				<cfset variables.manifest.deployments = queryNew("deploymentid,archiveid,archiveshahash,buildsystemname,deployedsystemname,deployedbyuserid,deployedbyusername,deployedbyuserfullname,deployedbyuseremail,deployedon,deploymentdir,deploymentnotes,wasbackuptaken,backuparchiveid",
																"VarChar,VarChar,VarChar,VarChar,VarChar,VarChar,VarChar,VarChar,VarChar,Date,VarChar,VarChar,Integer,VarChar") />
				<cfset variables.manifest.log = queryNew("logid,archiveid,archiveshahash,buildsystemname,logSystemName,logaction,deployflag,backupcreatedflag,backuparchiveid,userid,logmessage,logdatetime",
														"VarChar,VarChar,VarChar,VarChar,VarChar,VarChar,Integer,Integer,VarChar,VarChar,VarChar,Date") />
				
			
			<cfwddx action="cfml2wddx" input="#variables.manifest#" output="variables.manifestWDDX" />
			
			
			<cfzip action="zip" file="#variables.zipFilePath#" overwrite="no" storepath="yes">
				<cfzipparam source="#variables.tempZipFilePath#" />
				<cfzipparam content="#variables.manifestWDDX#" entrypath="META-INF/TITUS-MANIFEST.xml" />
			</cfzip>
			
			<!--- delete the temp zip file --->
			<cffile action="delete" file="#variables.tempZipFilePath#" />
				
				
			<cfinvoke component="#application.daos.cascade#" method="createArchive">
				<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
				<cfinvokeargument name="archiveID" value="#variables.archiveID#" />	<!---Type:String Hint:  - CHAR (35) --->
				<cfinvokeargument name="archiveshahash" value="#variables.archiveSHAHash#" />	<!---Type:String Hint:  - CHAR (40) --->
				<cfinvokeargument name="buildsystemname" value="#application.config.serverName#" />	<!---Type:String Hint:  - VARCHAR (255) --->
				<cfinvokeargument name="applicationname" value="#form.applicationname#" />	<!---Type:String Hint:  - VARCHAR (255) --->
				<cfinvokeargument name="versionname" value="#form.versionNumber#" />	<!---Type:String Hint:  - VARCHAR (50) --->
				<cfinvokeargument name="projectname" value="#form.projectname#" />	<!---Type:String Hint:  - VARCHAR (255) --->
				<cfinvokeargument name="projectnumber" value="#form.projectnumber#" />	<!---Type:String Hint:  - VARCHAR (50) --->
				<cfinvokeargument name="ticketnumber" value="#form.ticketnumber#" />	<!---Type:String Hint:  - VARCHAR (150) --->
				<cfinvokeargument name="changereason" value="#form.changereason#" />	<!---Type:String Hint:  - VARCHAR (50) --->
				<cfinvokeargument name="author" value="#form.author#" />	<!---Type:String Hint:  - VARCHAR (255) --->
				<cfinvokeargument name="changedescription" value="#form.changedescription#" />	<!---Type:String Hint:  - LONG VARCHAR (32700) --->
				<cfinvokeargument name="buildbyuserid" value="#session.login.getUserID()#" />	<!---Type:String Hint:  - CHAR (35) --->
				<cfinvokeargument name="buildbyusername" value="#session.login.getUsername()#" />	<!---Type:String Hint:  - VARCHAR (100) --->
				<cfinvokeargument name="buildbyuserfullname" value="#session.login.getFullname()#" />	<!---Type:String Hint:  - VARCHAR (100) --->
				<cfinvokeargument name="buildbyuseremail" value="#session.login.getEmail()#" />	<!---Type:String Hint:  - VARCHAR (255) --->
				<cfinvokeargument name="builddir" value="#variables.dir#" />	<!---Type:String Hint:  - VARCHAR (1000) --->
				<cfinvokeargument name="deployDirSuggestions" value="#variables.deployDirSuggestions#" />	<!---Type:String Hint:  - VARCHAR (5000) --->
				<cfinvokeargument name="filecount" value="#arrayLen(variables.files)#" />	<!---Type:Numeric Hint:  - INTEGER (10) --->
				<cfinvokeargument name="isnativebuild" value="1" />	<!---Type:Numeric Hint:  - INTEGER (10) --->
				<cfinvokeargument name="isbackuparchive" value="0" />	<!---Type:Numeric Hint:  - INTEGER (10) --->
				<cfinvokeargument name="isObsolete" value="0" />	<!---Type:Numeric Hint:  - INTEGER (10) --->
				<cfinvokeargument name="backupforarchiveid" value="" />	<!---Type:String Hint:  - CHAR (35) --->				
			</cfinvoke>
			
			<cfinvoke component="#application.daos.cascade#" method="insertArchiveLog">
				<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
				<cfinvokeargument name="archiveid" value="#variables.archiveid#" />	<!---Type:String Hint:  - CHAR (35) --->
				<cfinvokeargument name="archiveshahash" value="#variables.archiveshahash#" />	<!---Type:String Hint:  - CHAR (40) --->
				<cfinvokeargument name="buildsystemname" value="#application.config.serverName#" />	<!---Type:String Hint:  - VARCHAR (255) --->
				<cfinvokeargument name="logSystemName" value="#application.config.serverName#" />	<!---Type:String Hint:  - VARCHAR (255) --->
				<cfinvokeargument name="logaction" value="BUILDARCHIVE" />	<!---Type:String Hint:  - VARCHAR (50) --->
				<cfinvokeargument name="deployflag" value="0" />	<!---Type:Numeric Hint:  - INTEGER (10) --->
				<cfinvokeargument name="backupcreatedflag" value="0" />	<!---Type:Numeric Hint:  - INTEGER (10) --->
				<cfinvokeargument name="backuparchiveid" value="" />	<!---Type:String Hint:  - CHAR (35) --->
				<cfinvokeargument name="userid" value="#session.login.getUserID()#" />	<!---Type:String Hint:  - CHAR (35) --->
				<cfinvokeargument name="logmessage" value="#variables.archiveID# (#lcase(left(variables.archiveSHAHash,application.settings.showFirstXCharsOfSHA))#) created by #session.login.getUsername()#" />	<!---Type:String Hint:  - VARCHAR (1000) --->
				<cfinvokeargument name="logDateTime" value="#now()#" />
			</cfinvoke>
			
			<cfset structClear(session.tempFormVars.buildArchiveForm) />
			<cfset structClear(session.tempFormVars.buildStep2Form) />
			
			<cfset saveDataToManifest(variables.zipFilePath,variables.archiveID) />
			
			<cfif form.markPreviousArchiveAsObsolete AND isValid("UUID",form.previousArchiveID)>
				<cfinvoke component="#application.daos.cascade#" method="getArchiveByArchiveID" returnvariable="variables.previousArchive">
					<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
					<cfinvokeargument name="archiveID" value="#form.previousArchiveID#" />	<!---Type:string  --->
				</cfinvoke>
			
				<cfif variables.previousArchive.recordCount>
					<cfinvoke component="#application.daos.cascade#" method="setArchiveIsObsolete">
						<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
						<cfinvokeargument name="archiveID" value="#variables.previousArchive.archiveID#" />	<!---Type:String Hint:  - CHAR (35) --->
						<cfinvokeargument name="isObsolete" value="1" />
					</cfinvoke>
					
					<cfset variables.zipFilePath = application.config.archiveDirectory & application.settings.pathSeperator & variables.previousArchive.archiveID & ".zip" />
					<cfset variables.archiveSHAHash = application.objs.global.getFileSHAHash(variables.zipFilePath) />
					
					<cfinvoke component="#application.daos.cascade#" method="insertArchiveLog">
						<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
						<cfinvokeargument name="archiveid" value="#variables.previousArchive.archiveid#" />	<!---Type:String Hint:  - CHAR (35) --->
						<cfinvokeargument name="archiveshahash" value="#variables.archiveshahash#" />	<!---Type:String Hint:  - CHAR (40) --->
						<cfinvokeargument name="buildsystemname" value="#variables.previousArchive.buildSystemName#" />	<!---Type:String Hint:  - VARCHAR (255) --->
						<cfinvokeargument name="logSystemName" value="#application.config.serverName#" />	<!---Type:String Hint:  - VARCHAR (255) --->
						<cfinvokeargument name="logaction" value="OBSOLETEARCHIVE" />	<!---Type:String Hint:  - VARCHAR (50) --->
						<cfinvokeargument name="deployflag" value="0" />	<!---Type:Numeric Hint:  - INTEGER (10) --->
						<cfinvokeargument name="backupcreatedflag" value="0" />	<!---Type:Numeric Hint:  - INTEGER (10) --->
						<cfinvokeargument name="backuparchiveid" value="" />	<!---Type:String Hint:  - CHAR (35) --->
						<cfinvokeargument name="userid" value="#session.login.getUserID()#" />	<!---Type:String Hint:  - CHAR (35) --->
						<cfinvokeargument name="logmessage" value="#variables.previousArchive.archiveID# (#lcase(left(variables.archiveSHAHash,application.settings.showFirstXCharsOfSHA))#) version: #variables.previousArchive.versionName# made obsolete by archive #variables.archiveID# version #form.versionNumber#" />	<!---Type:String Hint:  - VARCHAR (1000) --->
						<cfinvokeargument name="logDateTime" value="#now()#" />
					</cfinvoke>
					
					<cfset saveDataToManifest(variables.zipFilePath,variables.previousArchive.archiveID) />
					
				</cfif>
			</cfif>

			<cflocation url="#application.settings.appBasedir#/archive/archive.cfm?archiveID=#variables.archiveID#" />
		
		</cfcase>
		
		<cfcase value="downloadArchive">
			
			<cfparam name="form.nameFormat" default="default" />
			
			<cfif NOT structKeyExists(form,"archiveID")>
				<cflocation url="#application.settings.appBaseDir#/archive/browse.cfm" />
			</cfif>
			
			<cfset variables.zipFilePath = application.config.archiveDirectory & application.settings.pathSeperator & form.archiveID & ".zip" />
			
			<cfif NOT fileExists(variables.zipFilePath)>
				<cflocation url="#application.settings.appBaseDir#/archive/browse.cfm" />
			</cfif>
			
			<!--- get the sha hash of the file to be downloaded --->
			<cfset variables.archiveSHAHash = application.objs.global.getArchiveZipFileHash(variables.zipFilePath,form.archiveID) />
			
			<cfinvoke component="#application.daos.cascade#" method="getArchiveByArchiveID" returnvariable="variables.archive">
				<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
				<cfinvokeargument name="archiveID" value="#url.archiveID#" />	<!---Type:string  --->
			</cfinvoke>
					
			<cfinvoke component="#application.daos.cascade#" method="insertArchiveLog">
				<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
				<cfinvokeargument name="archiveid" value="#form.archiveid#" />	<!---Type:String Hint:  - CHAR (35) --->
				<cfinvokeargument name="archiveshahash" value="#variables.archiveSHAHash#" />	<!---Type:String Hint:  - CHAR (40) --->
				<cfinvokeargument name="buildsystemname" value="#variables.archive.buildSystemName#" />	<!---Type:String Hint:  - VARCHAR (255) --->
				<cfinvokeargument name="logSystemName" value="#application.config.serverName#" />	<!---Type:String Hint:  - VARCHAR (255) --->
				<cfinvokeargument name="logaction" value="DOWNLOADARCHIVE" />	<!---Type:String Hint:  - VARCHAR (50) --->
				<cfinvokeargument name="deployflag" value="0" />	<!---Type:Numeric Hint:  - INTEGER (10) --->
				<cfinvokeargument name="backupcreatedflag" value="0" />	<!---Type:Numeric Hint:  - INTEGER (10) --->
				<cfinvokeargument name="backuparchiveid" value="" />	<!---Type:String Hint:  - CHAR (35) --->
				<cfinvokeargument name="userid" value="#session.login.getUserID()#" />	<!---Type:String Hint:  - CHAR (35) --->
				<cfinvokeargument name="logmessage" value="#form.archiveID# (#lcase(left(variables.archiveSHAHash,application.settings.showFirstXCharsOfSHA))#) downloaded by #session.login.getUsername()#" />	<!---Type:String Hint:  - VARCHAR (1000) --->
				<cfinvokeargument name="logDateTime" value="#now()#" />
			</cfinvoke>
					
			<cfset saveDataToManifest(variables.zipFilePath,form.archiveID) />
					
			<cfswitch expression="#form.nameFormat#">
				<cfcase value="application">
					<cfset variables.filename = replaceNoCase(variables.archive.applicationName," ","-","all") & "-" & replaceNoCase(variables.archive.versionName," ","-","all") & "-" & dateformat(variables.archive.buildOn,"yyyymmdd") & ".zip" />
				</cfcase>
				<cfdefaultcase>	
					<cfset variables.filename = form.archiveID & ".zip" />
				</cfdefaultcase>
			</cfswitch>
			
			<cfheader name="Content-Disposition" value="attachment;filename=#variables.filename#" />
			<cfcontent file="#variables.zipFilePath#" type="application/zip" />
			
		</cfcase>
		
		<cfcase value="deployArchive">
		
			<cfif NOT session.login.isUserInGroup("deploy")>
				<cflocation url="#application.settings.appBaseDir#/index.cfm" />
			</cfif>		
		
			<!--- check all of the form variables --->
			<cfif NOT structKeyExists(form,"archiveID") OR NOT isValid("UUID",form.archiveID)>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/archive/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="archiveID is required." />
				</cfinvoke>
			</cfif>
			
			<cfinvoke component="#application.daos.cascade#" method="getArchiveByArchiveID" returnvariable="variables.archive">
				<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
				<cfinvokeargument name="archiveID" value="#form.archiveID#" />	<!---Type:string  --->
			</cfinvoke>
		
			<cfif NOT variables.archive.recordCount>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/archive/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="archiveID #form.archiveID# is not valid." />
				</cfinvoke>
			</cfif>
			
			<cfif session.messenger.hasAlerts()>
				<cflocation url="#application.settings.appBaseDir#/archive/browse.cfm" />
			</cfif>
			
			<cfset variables.deploymentID = createUUID() />
			
			<cfset variables.deployDir = form.deployDir />
			
			<cfif right(variables.deployDir,1) EQ application.settings.pathSeperator>
				<cfset variables.deployDir = left(variables.deployDir,len(variables.deployDir)-1) />
			</cfif>
					
			<cfset variables.tempDir = application.config.archiveDirectory & application.settings.pathSeperator & "temp" & application.settings.pathSeperator />
			<cfif NOT directoryExists(variables.tempDir)>
				<cfdirectory action="create" directory="#variables.tempDir#" />
			</cfif> 
			
			<cfinvoke component="#application.daos.cascade#" method="getFilesForArchiveID" returnvariable="variables.archiveFiles">
				<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
				<cfinvokeargument name="archiveID" value="#form.archiveID#" />	<!---Type:string  --->
			</cfinvoke>
			
			<cfset variables.fileExistsCount = 0 />
			<cfset variables.files = arrayNew(2) />
			<cfset variables.filesIndex = 0 />
								
			<cfloop query="variables.archiveFiles">
				
				
				<cfset variables.filePath = replaceNoCase(replaceNoCase(replaceNoCase(variables.archiveFiles.filePath,variables.archive.builddir,""),"\",application.settings.pathSeperator,"all"),"/",application.settings.pathSeperator,"all") />
				<cfset variables.fileDeployPath = variables.deployDir & variables.filePath />
				
				<cfset variables.tempFileHash = "" />
				
				<cfset variables.fileExists = fileExists(variables.fileDeployPath)>
				<cfif variables.fileExists>
					<cfset variables.fileExistsCount++ />
					<cfset variables.filesIndex = variables.filesIndex + 1 />
					<cfset variables.files[variables.filesIndex][1] = variables.fileDeployPath />
					<cfset variables.files[variables.filesIndex][2] = variables.archiveFiles.fileID />
					
				</cfif>
				
				<cfif NOT variables.fileExists OR form.skipBackupArchive>
					<cfinvoke component="#application.daos.cascade#" method="insertDeploymentFileManifest">
						<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
						<cfinvokeargument name="deploymentid" value="#variables.deploymentID#" />	<!---Type:String Hint:  - CHAR (35) --->
						<cfinvokeargument name="archiveid" value="#form.archiveID#" />	<!---Type:String Hint:  - CHAR (35) --->
						<cfinvokeargument name="deployedsystemname" value="#application.config.serverName#" />	<!---Type:String Hint:  - VARCHAR (255) --->
						<cfinvokeargument name="archivefileid" value="#variables.archiveFiles.fileID#" />	<!---Type:String Hint:  - CHAR (35) --->
						<cfinvokeargument name="deployedfilepath" value="#variables.fileDeployPath#" />	<!---Type:String Hint:  - VARCHAR (255) --->
						<cfinvokeargument name="backupArchiveID" value="" />	<!---Type:String Hint:  - CHAR (35) --->
						<cfinvokeargument name="backupArchiveFileID" value="" />	<!---Type:String Hint:  - CHAR (35) --->					
						<cfinvokeargument name="previousfileshahash" value="" />	<!---Type:String Hint:  - CHAR (40) --->
					</cfinvoke>
				</cfif>
				
			</cfloop>	
						
			<cfset variables.backupCreatedFlag = 0 />
			<cfset variables.backupArchiveID = "" />
			
			<cfif variables.fileExistsCount GTE 1 AND NOT form.skipBackupArchive>
				
				<!--- create the archiveID --->
				<cfset variables.archiveID = createUUID() />
				
				<!--- create the zip file --->
				<cfset variables.zipFilePath = application.config.archiveDirectory & application.settings.pathSeperator & variables.archiveID & ".zip" />
				<cfset variables.tempZipFilePath = variables.tempDir & application.settings.pathSeperator & variables.archiveID & ".zip" />
			
				<cfzip action="zip" file="#variables.tempZipFilePath#" overwrite="no" storepath="yes">
					<cfloop from="1" to="#arrayLen(variables.files)#" index="i">
						<cfset variables.filesHashes[variables.files[i][1]] = application.objs.global.getFileSHAHash(variables.files[i][1]) />
						
						<cfinvoke component="#application.daos.cascade#" method="insertArchiveFile" returnvariable="variables.backupArchiveFileID">
							<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
							<cfinvokeargument name="archiveid" value="#variables.archiveid#" />	<!---Type:String Hint:  - CHAR (35) --->
							<cfinvokeargument name="fileshahash" value="#variables.filesHashes[variables.files[i][1]]#" />	<!---Type:String Hint:  - CHAR (40) --->
							<cfinvokeargument name="filepath" value="#variables.files[i][1]#" />	<!---Type:String Hint:  - VARCHAR (255) --->
						</cfinvoke>
						
						<cfinvoke component="#application.daos.cascade#" method="insertDeploymentFileManifest">
							<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
							<cfinvokeargument name="deploymentid" value="#variables.deploymentID#" />	<!---Type:String Hint:  - CHAR (35) --->
							<cfinvokeargument name="archiveid" value="#form.archiveID#" />	<!---Type:String Hint:  - CHAR (35) --->
							<cfinvokeargument name="deployedsystemname" value="#application.config.serverName#" />	<!---Type:String Hint:  - VARCHAR (255) --->
							<cfinvokeargument name="archivefileid" value="#variables.files[i][2]#" />	<!---Type:String Hint:  - CHAR (35) --->
							<cfinvokeargument name="deployedfilepath" value="#variables.files[i][1]#" />	<!---Type:String Hint:  - VARCHAR (255) --->
							<cfinvokeargument name="backupArchiveID" value="#variables.archiveID#" />	<!---Type:String Hint:  - CHAR (35) --->
							<cfinvokeargument name="backupArchiveFileID" value="#variables.backupArchiveFileID#" />	<!---Type:String Hint:  - CHAR (35) --->					
							<cfinvokeargument name="previousfileshahash" value="#variables.filesHashes[variables.files[i][1]]#" />	<!---Type:String Hint:  - CHAR (40) --->
						</cfinvoke>
					
						<cfzipparam source="#variables.files[i][1]#" entrypath="#replaceNoCase(variables.files[i][1],variables.deployDir,"")#" />
					</cfloop>
				
				</cfzip>
				
				<!--- get the hash of the zip file --->
				<cfset variables.archiveSHAHash = application.objs.global.getFileSHAHash(variables.tempZipFilePath) />
				
				<!--- create the manifest file --->
				<cfset variables.manifest = structNew() />
					<cfset variables.manifest.fileList = variables.filesHashes />
					<cfset variables.manifest.archiveID = variables.archiveID />
					<cfset variables.manifest.buildSystem = application.config.serverName />
					<cfset variables.manifest.applicationName = '' />
					<cfset variables.manifest.versionName = '' />
					<cfset variables.manifest.projectName = '' />
					<cfset variables.manifest.projectNumber = '' />
					<cfset variables.manifest.ticketNumber = '' />
					<cfset variables.manifest.changeReason = '' />
					<cfset variables.manifest.author = '' />
					<cfset variables.manifest.changeDescription = 'BACKUP ARCHIVE' />
					<cfset variables.manifest.buildByUserID = '' />
					<cfset variables.manifest.buildByUsername = 'SYSTEM' />
					<cfset variables.manifest.buildByUserFullname = 'SYSTEM' />
					<cfset variables.manifest.buildByUserEmail = '' />
					<cfset variables.manifest.buildOn = now() />
					<cfset variables.manifest.buildDir = variables.deployDir />
					<cfset variables.manifest.deployDirSuggestions = variables.deployDir />
					<cfset variables.manifest.backupOfArchiveID = form.archiveID />
					<cfset variables.manifest.archiveSHAHash = variables.archiveSHAHash />
					<cfset variables.manifest.isObsolete = 0 />
				
				<cfwddx action="cfml2wddx" input="#variables.manifest#" output="variables.manifestWDDX" />
				
				
				<cfzip action="zip" file="#variables.zipFilePath#" overwrite="no" storepath="yes">
					<cfzipparam source="#variables.tempZipFilePath#" />
					<cfzipparam content="#variables.manifestWDDX#" entrypath="META-INF/TITUS-MANIFEST.xml" />
				</cfzip>
				
				<!--- delete the temp zip file --->
				<cffile action="delete" file="#variables.tempZipFilePath#" />				
					
				<cfinvoke component="#application.daos.cascade#" method="createArchive">
					<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
					<cfinvokeargument name="archiveID" value="#variables.archiveID#" />	<!---Type:String Hint:  - CHAR (35) --->
					<cfinvokeargument name="archiveshahash" value="#variables.archiveSHAHash#" />	<!---Type:String Hint:  - CHAR (40) --->
					<cfinvokeargument name="buildsystemname" value="#application.config.serverName#" />	<!---Type:String Hint:  - VARCHAR (255) --->
					<cfinvokeargument name="applicationname" value="#variables.archive.applicationName#" />	<!---Type:String Hint:  - VARCHAR (255) --->
					<cfinvokeargument name="versionname" value="" />	<!---Type:String Hint:  - VARCHAR (50) --->
					<cfinvokeargument name="projectname" value="" />	<!---Type:String Hint:  - VARCHAR (255) --->
					<cfinvokeargument name="projectnumber" value="" />	<!---Type:String Hint:  - VARCHAR (50) --->
					<cfinvokeargument name="ticketnumber" value="" />	<!---Type:String Hint:  - VARCHAR (150) --->
					<cfinvokeargument name="changereason" value="" />	<!---Type:String Hint:  - VARCHAR (50) --->
					<cfinvokeargument name="author" value="" />	<!---Type:String Hint:  - VARCHAR (255) --->
					<cfinvokeargument name="changedescription" value="BACKUP ARCHIVE" />	<!---Type:String Hint:  - LONG VARCHAR (32700) --->
					<cfinvokeargument name="buildbyuserid" value="#session.login.getUserID()#" />	<!---Type:String Hint:  - CHAR (35) --->
					<cfinvokeargument name="buildbyusername" value="#session.login.getUsername()#" />	<!---Type:String Hint:  - VARCHAR (100) --->
					<cfinvokeargument name="buildbyuserfullname" value="#session.login.getFullname()#" />	<!---Type:String Hint:  - VARCHAR (100) --->
					<cfinvokeargument name="buildbyuseremail" value="#session.login.getEmail()#" />	<!---Type:String Hint:  - VARCHAR (255) --->
					<cfinvokeargument name="builddir" value="#variables.deploydir#" />	<!---Type:String Hint:  - VARCHAR (1000) --->
					<cfinvokeargument name="deployDirSuggestions" value="#variables.deploydir#" />	<!---Type:String Hint:  - VARCHAR (5000) --->
					<cfinvokeargument name="filecount" value="#arrayLen(variables.files)#" />	<!---Type:Numeric Hint:  - INTEGER (10) --->
					<cfinvokeargument name="isnativebuild" value="1" />	<!---Type:Numeric Hint:  - INTEGER (10) --->
					<cfinvokeargument name="isbackuparchive" value="1" />	<!---Type:Numeric Hint:  - INTEGER (10) --->
					<cfinvokeargument name="isObsolete" value="0" />	<!---Type:Numeric Hint:  - INTEGER (10) --->
					<cfinvokeargument name="backupforarchiveid" value="#form.archiveID#" />	<!---Type:String Hint:  - CHAR (35) --->				
				</cfinvoke>
				
				<cfinvoke component="#application.daos.cascade#" method="insertArchiveLog">
					<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
					<cfinvokeargument name="archiveid" value="#variables.archiveid#" />	<!---Type:String Hint:  - CHAR (35) --->
					<cfinvokeargument name="archiveshahash" value="#variables.archiveshahash#" />	<!---Type:String Hint:  - CHAR (40) --->
					<cfinvokeargument name="buildsystemname" value="#application.config.serverName#" />	<!---Type:String Hint:  - VARCHAR (255) --->
					<cfinvokeargument name="logSystemName" value="#application.config.serverName#" />	<!---Type:String Hint:  - VARCHAR (255) --->
					<cfinvokeargument name="logaction" value="BUILDBACKUPARCHIVE" />	<!---Type:String Hint:  - VARCHAR (50) --->
					<cfinvokeargument name="deployflag" value="0" />	<!---Type:Numeric Hint:  - INTEGER (10) --->
					<cfinvokeargument name="backupcreatedflag" value="0" />	<!---Type:Numeric Hint:  - INTEGER (10) --->
					<cfinvokeargument name="backuparchiveid" value="" />	<!---Type:String Hint:  - CHAR (35) --->
					<cfinvokeargument name="userid" value="#session.login.getUserID()#" />	<!---Type:String Hint:  - CHAR (35) --->
					<cfinvokeargument name="logmessage" value="BACKUP #variables.archiveID# (#lcase(left(variables.archiveSHAHash,application.settings.showFirstXCharsOfSHA))#) created by #session.login.getUsername()#" />	<!---Type:String Hint:  - VARCHAR (1000) --->
					<cfinvokeargument name="logDateTime" value="#now()#" />
				</cfinvoke>

				<cfset variables.backupCreatedFlag = 1 />
				<cfset variables.backupArchiveID = variables.archiveID />
			</cfif>
			
			<!--- now actually deploy the archive --->
			<!--- check to see if the deployment directory already exists, and if we are supposed to create it if it doesnt --->
			<cfif NOT directoryExists(variables.deployDir)>
				<cfif form.createDeployDir>
					<cfdirectory action="create" directory="#variables.deployDir#" />
				<cfelse>
					<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
						<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/archive/action.cfm" />
						<cfinvokeargument name="messageType" value="Error" />
						<cfinvokeargument name="messageText" value="The deployment directory does not exist." />
					</cfinvoke>
					
					<cflocation url="#application.settings.appBaseDir#/archive/browse.cfm" />
				</cfif>
				
			</cfif>
			
			<cfset variables.zipFilePath = application.config.archiveDirectory & application.settings.pathSeperator & form.archiveID & ".zip" />
			<cfset variables.archiveZipFilePath = variables.tempDir & application.settings.pathSeperator & form.archiveID & ".zip" />
			
			<!--- unzip the actual archive to a temp location --->
			<cfzip action="unzip" file="#variables.zipFilePath#" destination="#variables.tempDir#" filter="*.zip" />
			
			<cfset variables.currentSHAHash = application.objs.global.getArchiveZipFileHash(variables.zipFilePath,form.archiveID) />

			<cfzip action="unzip" file="#variables.archiveZipFilePath#" destination="#variables.deployDir#" overwrite="true" />

			<!--- run through and validate all of the files moved properly by checking their hash against the records --->			
			<cfloop query="variables.archiveFiles">
				<cfset variables.filePath = replaceNoCase(replaceNoCase(replaceNoCase(variables.archiveFiles.filePath,variables.archive.builddir,""),"\",application.settings.pathSeperator,"all"),"/",application.settings.pathSeperator,"all") />
				<cfset variables.fileDeployPath = variables.deployDir & variables.filePath />
				
				<cfset variables.fileExists = fileExists(variables.fileDeployPath)>
				<cfif NOT variables.fileExists OR application.objs.global.getFileSHAHash(variables.fileDeployPath) NEQ variables.archiveFiles.fileSHAHash>
					<!--- something went wrong --->
					<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
						<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/archive/action.cfm" />
						<cfinvokeargument name="messageType" value="Error" />
						<cfinvokeargument name="messageText" value="#variables.fileDeployPath# did not deploy properly!" />
						<cfinvokeargument name="messageDetail" value="The deployed file's hash #application.objs.global.getFileSHAHash(variables.fileDeployPath)# does not match the hash on record: #variables.archiveFiles.fileSHAHash#!." />
					</cfinvoke>
				</cfif>			
			</cfloop>
						
			
			<cfinvoke component="#application.daos.cascade#" method="createDeployment" returnvariable="createDeploymentRet">
				<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
				<cfinvokeargument name="deploymentID" value="#variables.deploymentID#" />	<!---Type:String Hint:  - CHAR (35) --->
				<cfinvokeargument name="archiveid" value="#form.archiveID#" />	<!---Type:String Hint:  - CHAR (35) --->
				<cfinvokeargument name="archiveshahash" value="#variables.currentSHAHash#" />	<!---Type:String Hint:  - CHAR (40) --->
				<cfinvokeargument name="buildsystemname" value="#variables.archive.buildSystemName#" />	<!---Type:String Hint:  - VARCHAR (255) --->
				<cfinvokeargument name="deployedSystemname" value="#application.config.serverName#" />	<!---Type:String Hint:  - VARCHAR (255) --->
				<cfinvokeargument name="deployedbyuserid" value="#session.login.getUserID()#" />	<!---Type:String Hint:  - CHAR (35) --->
				<cfinvokeargument name="deployedbyusername" value="#session.login.getUsername()#" />	<!---Type:String Hint:  - VARCHAR (100) --->
				<cfinvokeargument name="deployedbyuserfullname" value="#session.login.getFullname()#" />	<!---Type:String Hint:  - VARCHAR (100) --->
				<cfinvokeargument name="deployedbyuseremail" value="#session.login.getEmail()#" />	<!---Type:String Hint:  - VARCHAR (255) --->
				<cfinvokeargument name="deployedon" value="#now()#" />	<!---Type:date Hint:  - TIMESTAMP (26) --->
				<cfinvokeargument name="deploymentdir" value="#variables.deployDir#" />	<!---Type:String Hint:  - VARCHAR (1000) --->
				<cfinvokeargument name="deploymentNotes" value="#form.deploymentNotes#" />	<!---Type:String Hint:  - LONG VARCHAR --->
				<cfinvokeargument name="wasbackuptaken" value="#variables.backupCreatedFlag#" />	<!---Type:Numeric Hint:  - INTEGER (10) --->
				<cfinvokeargument name="backupArchiveID" value="#variables.backupArchiveID#" />	<!---Type:String Hint:  - CHAR (35) --->
			</cfinvoke>		
			
			<cfinvoke component="#application.daos.cascade#" method="insertArchiveLog">
				<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
				<cfinvokeargument name="archiveid" value="#form.archiveid#" />	<!---Type:String Hint:  - CHAR (35) --->
				<cfinvokeargument name="archiveshahash" value="#variables.currentSHAHash#" />	<!---Type:String Hint:  - CHAR (40) --->
				<cfinvokeargument name="buildsystemname" value="#variables.archive.buildsystemname#" />	<!---Type:String Hint:  - VARCHAR (255) --->
				<cfinvokeargument name="logSystemName" value="#application.config.serverName#" />	<!---Type:String Hint:  - VARCHAR (255) --->
				<cfinvokeargument name="logaction" value="DEPLOYARCHIVE" />	<!---Type:String Hint:  - VARCHAR (50) --->
				<cfinvokeargument name="deployflag" value="1" />	<!---Type:Numeric Hint:  - INTEGER (10) --->
				<cfinvokeargument name="backupcreatedflag" value="#variables.backupCreatedFlag#" />	<!---Type:Numeric Hint:  - INTEGER (10) --->
				<cfinvokeargument name="backuparchiveid" value="#variables.backupArchiveID#" />	<!---Type:String Hint:  - CHAR (35) --->
				<cfinvokeargument name="userid" value="#session.login.getUserID()#" />	<!---Type:String Hint:  - CHAR (35) --->
				<cfinvokeargument name="logmessage" value="#form.archiveID# (#lcase(left(variables.currentSHAHash,application.settings.showFirstXCharsOfSHA))#) DEPLOYED by #session.login.getUsername()# to #variables.deployDir#" />	<!---Type:String Hint:  - VARCHAR (1000) --->
				<cfinvokeargument name="logDateTime" value="#now()#" />
			</cfinvoke>
			
			<cfset saveDataToManifest(variables.zipFilePath,form.archiveID) />

			<cflocation url="#application.settings.appBasedir#/archive/archive.cfm?archiveID=#form.archiveID#" />
		
		</cfcase>
		
		<cfcase value="certifyArchive">
					
			<!--- check all of the form variables --->
			<cfif NOT structKeyExists(form,"archiveID") OR NOT isValid("UUID",form.archiveID)>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/archive/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="archiveID is required." />
				</cfinvoke>
			</cfif>
			
			<cfinvoke component="#application.daos.cascade#" method="getArchiveByArchiveID" returnvariable="variables.archive">
				<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
				<cfinvokeargument name="archiveID" value="#form.archiveID#" />	<!---Type:string  --->
			</cfinvoke>
		
			<cfif NOT variables.archive.recordCount>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/archive/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="archiveID #form.archiveID# is not valid." />
				</cfinvoke>
			</cfif>
		
			<cfif NOT structKeyExists(form,"certificationTypeName") OR NOT len(trim(form.certificationTypeName))>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/archive/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="Certification Type is Required." />
				</cfinvoke>
			</cfif>
			
			<cfset variables.zipFilePath = application.config.archiveDirectory & application.settings.pathSeperator & form.archiveID & ".zip" />
			
			<cfif NOT fileExists(variables.zipFilePath)>
				<cflocation url="#application.settings.appBaseDir#/archive/browse.cfm" />
			</cfif>
			
			<cfset variables.archiveSHAHash = application.objs.global.getArchiveZipFileHash(variables.zipFilePath,form.archiveID) />
			
			<cfif variables.archiveSHAHash NEQ variables.archive.archiveSHAHash>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="You cannot certify this archive! It does not match the build hash!" />
					<cfinvokeargument name="messageDetail" value="The hash of the archive at build (#variables.archive.archiveSHAHash#) does NOT match the hash of the archive currently on disk (#variables.archive.archiveSHAHash#)" />
				</cfinvoke>
			</cfif>
			
			<cfif session.messenger.hasAlerts()>
				<cflocation url="#application.settings.appBaseDir#/archive/browse.cfm" />
			</cfif>
			
			<cfset variables.certificationOn = now() />
			
			<!--- ID really like to do something more here, but this will work for now. --->
			<cfset variables.certificationHash = hash(application.config.serverName & session.login.getEmail() & variables.archiveSHAHash & form.certificationTypeName & dateFormat(variables.certificationOn,"YYYYMMDD") & timeFormat(variables.certificationOn,"HHmmss"),"SHA") />
		
			<cfinvoke component="#application.daos.cascade#" method="insertArchiveCertification" returnvariable="insertArchiveCertificationRet">
				<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
				<cfinvokeargument name="certificationID" value="#createUUID()#" />	<!---Type:String Hint:  - CHAR (35) --->
				<cfinvokeargument name="archiveid" value="#variables.archive.archiveID#" />	<!---Type:String Hint:  - CHAR (35) --->
				<cfinvokeargument name="archiveshahash" value="#variables.archiveSHAHash#" />	<!---Type:String Hint:  - CHAR (40) --->
				<cfinvokeargument name="userid" value="#session.login.getUserID()#" />	<!---Type:String Hint:  - CHAR (35) --->
				<cfinvokeargument name="userfullname" value="#session.login.getFullname()#" />	<!---Type:String Hint:  - VARCHAR (100) --->
				<cfinvokeargument name="useremail" value="#session.login.getEmail()#" />	<!---Type:String Hint:  - VARCHAR (255) --->
				<cfinvokeargument name="certificationTypeName" value="#form.certificationTypeName#" />	<!---Type:Numeric Hint:  - VARCHAR (25) --->
				<cfinvokeargument name="certificationhash" value="#variables.certificationHash#" />	<!---Type:String Hint:  - CHAR (40) --->
				<cfinvokeargument name="certificationon" value="#variables.certificationOn#" />	<!---Type:date Hint:  - TIMESTAMP (26) --->
				<cfinvokeargument name="certificationnotes" value="#form.certificationNotes#" />	<!---Type:String Hint:  - LONG VARCHAR --->
				<cfinvokeargument name="certificationSystemName" value="#application.config.serverName#" />
			</cfinvoke>
			
			<cfinvoke component="#application.daos.cascade#" method="insertArchiveLog">
				<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
				<cfinvokeargument name="archiveid" value="#form.archiveid#" />	<!---Type:String Hint:  - CHAR (35) --->
				<cfinvokeargument name="archiveshahash" value="#variables.archiveSHAHash#" />	<!---Type:String Hint:  - CHAR (40) --->
				<cfinvokeargument name="buildsystemname" value="#variables.archive.buildsystemname#" />	<!---Type:String Hint:  - VARCHAR (255) --->
				<cfinvokeargument name="logSystemName" value="#application.config.serverName#" />	<!---Type:String Hint:  - VARCHAR (255) --->
				<cfinvokeargument name="logaction" value="CERTIFYARCHIVE" />	<!---Type:String Hint:  - VARCHAR (50) --->
				<cfinvokeargument name="deployflag" value="0" />	<!---Type:Numeric Hint:  - INTEGER (10) --->
				<cfinvokeargument name="backupcreatedflag" value="0" />	<!---Type:Numeric Hint:  - INTEGER (10) --->
				<cfinvokeargument name="backuparchiveid" value="" />	<!---Type:String Hint:  - CHAR (35) --->
				<cfinvokeargument name="userid" value="#session.login.getUserID()#" />	<!---Type:String Hint:  - CHAR (35) --->
				<cfinvokeargument name="logmessage" value="#variables.archive.archiveID# (#lcase(left(variables.archiveSHAHash,application.settings.showFirstXCharsOfSHA))#) #form.certificationTypeName# CERTIFIED by #session.login.getUsername()# on #application.config.serverName#" />	<!---Type:String Hint:  - VARCHAR (1000) --->
				<cfinvokeargument name="logDateTime" value="#now()#" />
			</cfinvoke>
			
			<cfset saveDataToManifest(variables.zipFilePath,form.archiveID) />
					
			<cflocation url="#application.settings.appBasedir#/archive/archive.cfm?archiveID=#form.archiveID#" />
		
		</cfcase>
		
		<cfcase value="removeCertification">
				
			<!--- check all of the form variables --->
			<cfif NOT structKeyExists(form,"archiveID") OR NOT isValid("UUID",form.archiveID)>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/archive/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="archiveID is required." />
				</cfinvoke>
			</cfif>
			
			<cfinvoke component="#application.daos.cascade#" method="getArchiveByArchiveID" returnvariable="variables.archive">
				<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
				<cfinvokeargument name="archiveID" value="#form.archiveID#" />	<!---Type:string  --->
			</cfinvoke>
		
			<cfif NOT variables.archive.recordCount>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/archive/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="archiveID #form.archiveID# is not valid." />
				</cfinvoke>
			</cfif>
			
			<cfif NOT structKeyExists(form,"certificationID") OR NOT isValid("UUID",form.certificationID)>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/archive/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="certificationID is required." />
				</cfinvoke>
			</cfif>
			
			<cfinvoke component="#application.daos.cascade#" method="getArchiveCertificationForCertificationID" returnvariable="variables.certification">
				<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
				<cfinvokeargument name="certificationID" value="#form.certificationID#" />	<!---Type:string  --->
			</cfinvoke>
			
			<cfif NOT variables.archive.recordCount>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/archive/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="certificationID #form.certificationID# is not valid." />
				</cfinvoke>
			</cfif>

					
			<cfset variables.zipFilePath = application.config.archiveDirectory & application.settings.pathSeperator & form.archiveID & ".zip" />
			
			<cfif NOT fileExists(variables.zipFilePath)>
				<cflocation url="#application.settings.appBaseDir#/archive/browse.cfm" />
			</cfif>
			
			<cfset variables.archiveSHAHash = application.objs.global.getArchiveZipFileHash(variables.zipFilePath,form.archiveID) />
						
			<cfif session.messenger.hasAlerts()>
				<cflocation url="#application.settings.appBaseDir#/archive/browse.cfm" />
			</cfif>
			
			<cfinvoke component="#application.daos.cascade#" method="removeArchiveCertification" returnvariable="removeArchiveCertificationRet">
				<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
				<cfinvokeargument name="certificationID" value="#form.certificationID#" />	<!---Type:string  --->
			</cfinvoke>

			<cfinvoke component="#application.daos.cascade#" method="insertArchiveLog">
				<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
				<cfinvokeargument name="archiveid" value="#form.archiveid#" />	<!---Type:String Hint:  - CHAR (35) --->
				<cfinvokeargument name="archiveshahash" value="#variables.archiveSHAHash#" />	<!---Type:String Hint:  - CHAR (40) --->
				<cfinvokeargument name="buildsystemname" value="#variables.archive.buildsystemname#" />	<!---Type:String Hint:  - VARCHAR (255) --->
				<cfinvokeargument name="logSystemName" value="#application.config.serverName#" />	<!---Type:String Hint:  - VARCHAR (255) --->
				<cfinvokeargument name="logaction" value="DECERTIFYARCHIVE" />	<!---Type:String Hint:  - VARCHAR (50) --->
				<cfinvokeargument name="deployflag" value="0" />	<!---Type:Numeric Hint:  - INTEGER (10) --->
				<cfinvokeargument name="backupcreatedflag" value="0" />	<!---Type:Numeric Hint:  - INTEGER (10) --->
				<cfinvokeargument name="backuparchiveid" value="" />	<!---Type:String Hint:  - CHAR (35) --->
				<cfinvokeargument name="userid" value="#session.login.getUserID()#" />	<!---Type:String Hint:  - CHAR (35) --->
				<cfinvokeargument name="logmessage" value="#variables.archive.archiveID# (#lcase(left(variables.archiveSHAHash,application.settings.showFirstXCharsOfSHA))#) #variables.certification.certificationTypeName# DE-CERTIFIED by #session.login.getUsername()#" />	<!---Type:String Hint:  - VARCHAR (1000) --->
				<cfinvokeargument name="logDateTime" value="#now()#" />
			</cfinvoke>
			
			<cfset saveDataToManifest(variables.zipFilePath,form.archiveID) />
			
			<cflocation url="#application.settings.appBasedir#/archive/archive.cfm?archiveID=#form.archiveID#" />
		
		</cfcase>
		
		<cfcase value="uploadArchive">
		
			<cfif NOT session.login.isUserInGroup("upload")>
				<cflocation url="#application.settings.appBaseDir#/index.cfm" />
			</cfif>
			
			<!--- upload to a temp directory --->
			<cfset variables.tempDir = application.config.archiveDirectory & application.settings.pathSeperator & "temp" & application.settings.pathSeperator />
			<cfif NOT directoryExists(variables.tempDir)>
				<cfdirectory action="create" directory="#variables.tempDir#" />
			</cfif>
			
			<cfset variables.tempFilePath = variables.tempDir & createUUID() & ".zip" />
			
			<cffile action="upload" accept="application/zip,application/x-zip-compressed" destination="#variables.tempFilePath#" filefield="archiveZip" nameconflict="makeUnique" result="variables.tempZipFileResult" /> 
		
			<cftry>
				<!--- get the manifest --->
				<cfzip action="read" file="#variables.tempZipFileResult.serverDirectory##application.settings.pathSeperator##variables.tempZipFileResult.serverFile#" variable="variables.manifestWDDX" entrypath="META-INF/TITUS-MANIFEST.xml" />
			
			<cfcatch>
			
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/archive/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="This zip file does not seem to be a valid archive." />
					<cfinvokeargument name="messageDetail" value="This archive does not have a META-INF/TITUS-MANIFEST.xml File" />
				</cfinvoke>
								
			</cfcatch>
			</cftry>
			
			<cfif session.messenger.hasAlerts()>				
				<cffile action="delete" file="#variables.tempZipFileResult.serverDirectory##application.settings.pathSeperator##variables.tempZipFileResult.serverFile#" />				
				<cflocation url="#application.settings.appBaseDir#/archive/upload.cfm" />				
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
				<cffile action="delete" file="#variables.tempZipFileResult.serverDirectory##application.settings.pathSeperator##variables.tempZipFileResult.serverFile#" />				
				<cflocation url="#application.settings.appBaseDir#/archive/upload.cfm" />				
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
				<cffile action="delete" file="#variables.tempZipFileResult.serverDirectory##application.settings.pathSeperator##variables.tempZipFileResult.serverFile#" />				
				<cflocation url="#application.settings.appBaseDir#/archive/upload.cfm" />				
			</cfif>
			
			
			<!--- check the hashes --->
			<cfset variables.tempZipFilePath = variables.tempZipFileResult.serverDirectory & application.settings.pathSeperator & variables.tempZipFileResult.serverFile />
			
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
				<cflocation url="#application.settings.appBaseDir#/archive/upload.cfm" />				
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
				
				<cffile action="delete" file="#variables.tempZipFileResult.serverDirectory##application.settings.pathSeperator##variables.tempZipFileResult.serverFile#" />				
				
				<cflocation url="#application.settings.appBasedir#/archive/archive.cfm?archiveID=#variables.manifest.archiveID#" />
			</cfif>
			<!--- okay, we dont already have this file, lets move it to the right place, create the archive record for it and log it --->
			
			<cfset variables.archiveID = variables.manifest.archiveID />
			
			<cfset variables.zipFilePath = application.config.archiveDirectory & application.settings.pathSeperator & variables.archiveID & ".zip" />
			
			<cffile action="move" source="#variables.tempZipFileResult.serverDirectory##application.settings.pathSeperator##variables.tempZipFileResult.serverFile#" destination="#variables.zipFilePath#" />
			
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
				<cfinvokeargument name="logaction" value="UPLOADARCHIVE" />	<!---Type:String Hint:  - VARCHAR (50) --->
				<cfinvokeargument name="deployflag" value="0" />	<!---Type:Numeric Hint:  - INTEGER (10) --->
				<cfinvokeargument name="backupcreatedflag" value="0" />	<!---Type:Numeric Hint:  - INTEGER (10) --->
				<cfinvokeargument name="backuparchiveid" value="" />	<!---Type:String Hint:  - CHAR (35) --->
				<cfinvokeargument name="userid" value="#session.login.getUserID()#" />	<!---Type:String Hint:  - CHAR (35) --->
				<cfinvokeargument name="logmessage" value="#variables.archiveID# (#lcase(left(variables.archiveSHAHash,application.settings.showFirstXCharsOfSHA))#) uploaded by #session.login.getUsername()#" />	<!---Type:String Hint:  - VARCHAR (1000) --->
				<cfinvokeargument name="logDateTime" value="#now()#" />
			</cfinvoke>

			<cflocation url="#application.settings.appBasedir#/archive/archive.cfm?archiveID=#variables.archiveID#" />

					
		</cfcase>
		
		<cfcase value="deleteArchive">
		
			<!--- check all of the form variables --->
			<cfif NOT structKeyExists(form,"archiveID") OR NOT isValid("UUID",form.archiveID)>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/archive/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="archiveID is required." />
				</cfinvoke>
			</cfif>
			
			<cfinvoke component="#application.daos.cascade#" method="getArchiveByArchiveID" returnvariable="variables.archive">
				<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
				<cfinvokeargument name="archiveID" value="#form.archiveID#" />	<!---Type:string  --->
			</cfinvoke>
		
			<cfif NOT variables.archive.recordCount>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/archive/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="archiveID #form.archiveID# is not valid." />
				</cfinvoke>
			</cfif>
			
			<cfif session.messenger.hasAlerts()>				
				<cflocation url="#application.settings.appBaseDir#/archive/upload.cfm" />				
			</cfif>
			
			<cfinvoke component="#application.daos.cascade#" method="deleteArchive" returnvariable="variables.deleteArchiveRet">
				<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
				<cfinvokeargument name="archiveID" value="#form.archiveID#" />	<!---Type:string  --->
			</cfinvoke>
			
			<cfset variables.zipFilePath = application.config.archiveDirectory & application.settings.pathSeperator & form.archiveID & ".zip" />
			
			<cfif fileExists(variables.zipFilePath)>
				<cffile action="delete" file="#variables.zipFilePath#" />
			</cfif>
			
			<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
				<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/archive/action.cfm" />
				<cfinvokeargument name="messageType" value="Information" />
				<cfinvokeargument name="messageText" value="The archive was successfully deleted." />
			</cfinvoke>
		
			<cflocation url="#application.settings.appBaseDir#/archive/browse.cfm" />
		
		</cfcase>
		
		<cfcase value="revertDeployment">
			
			<cfif NOT session.login.isUserInGroup("deploy")>
				<cflocation url="#application.settings.appBaseDir#/index.cfm" />
			</cfif>		
		
			<!--- check all of the form variables --->
			<cfif NOT structKeyExists(form,"archiveID") OR NOT isValid("UUID",form.archiveID)>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/archive/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="archiveID is required." />
				</cfinvoke>
			</cfif>
			
			<cfif session.messenger.hasAlerts()>
				<cflocation url="#application.settings.appBaseDir#/archive/browse.cfm" />
			</cfif>
			
			<cfinvoke component="#application.daos.cascade#" method="getArchiveByArchiveID" returnvariable="variables.archive">
				<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
				<cfinvokeargument name="archiveID" value="#form.archiveID#" />	<!---Type:string  --->
			</cfinvoke>
		
			<cfif NOT variables.archive.recordCount>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/archive/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="archiveID #form.archiveID# is not valid." />
				</cfinvoke>
			</cfif>
			
			<cfif session.messenger.hasAlerts()>
				<cflocation url="#application.settings.appBaseDir#/archive/browse.cfm" />
			</cfif>
			
			<cfif NOT structKeyExists(form,"deploymentID") OR NOT isValid("UUID",form.deploymentID)>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/archive/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="deploymentID is required." />
				</cfinvoke>
			</cfif>
			
			<cfif session.messenger.hasAlerts()>
				<cflocation url="#application.settings.appBaseDir#/archive/archive.cfm?archiveID=#form.archiveID#" />
			</cfif>
			
			<cfinvoke component="#application.daos.cascade#" method="getDeploymentsForDeploymentID" returnvariable="variables.deployment">
				<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
				<cfinvokeargument name="deploymentid" value="#form.deploymentid#" />	<!---Type:string  --->
			</cfinvoke>
		
			<cfinvoke component="#application.daos.cascade#" method="getDeploymentFilesManifestForDeploymentID" returnvariable="variables.deploymentManifest">
				<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
				<cfinvokeargument name="deploymentid" value="#form.deploymentid#" />	<!---Type:string  --->
			</cfinvoke>
		
			<cfif NOT variables.deployment.recordCount OR NOT variables.deploymentManifest.recordCount>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/archive/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="deploymentID #form.deploymentID# is not valid." />
				</cfinvoke>
			</cfif>			
			
			<cfif session.messenger.hasAlerts()>
				<cflocation url="#application.settings.appBaseDir#/archive/archive.cfm?archiveID=#form.archiveID#" />
			</cfif>
			
			<cfif NOT structKeyExists(form,"backupArchiveID") OR NOT isValid("UUID",form.backupArchiveID)>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/archive/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="backupArchiveID is required." />
				</cfinvoke>
			</cfif>
			
			<cfif session.messenger.hasAlerts()>
				<cflocation url="#application.settings.appBaseDir#/archive/archive.cfm?archiveID=#form.archiveID#" />
			</cfif>
			
			<cfinvoke component="#application.daos.cascade#" method="getArchiveByArchiveID" returnvariable="variables.backupArchive">
				<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
				<cfinvokeargument name="archiveID" value="#form.backupArchiveID#" />	<!---Type:string  --->
			</cfinvoke>
			
			<cfinvoke component="#application.daos.cascade#" method="getFilesForArchiveID" returnvariable="variables.archiveFiles">
				<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
				<cfinvokeargument name="archiveID" value="#form.backupArchiveID#" />	<!---Type:string  --->
			</cfinvoke>
		
			<cfif NOT variables.backupArchive.recordCount>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/archive/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="BackupArchiveID #form.BackupArchiveID# is not valid." />
				</cfinvoke>
			</cfif>			
			
			<cfif session.messenger.hasAlerts()>
				<cflocation url="#application.settings.appBaseDir#/archive/archive.cfm?archiveID=#form.archiveID#" />
			</cfif>
			
			<cfset form.originalArchiveID = form.archiveID />
			<cfset form.archiveID = form.backupArchiveID />
			
			<cfset variables.tempDir = application.config.archiveDirectory & application.settings.pathSeperator & "temp" & application.settings.pathSeperator />
			<cfif NOT directoryExists(variables.tempDir)>
				<cfdirectory action="create" directory="#variables.tempDir#" />
			</cfif> 
			
			<!--- okay, we have everything we need, basically, we just need to deploy the backup archive, then get all of the files that didnt exist prior to the deployment and delete them. --->
			<cfset variables.deployDir = variables.deployment.deploymentdir />
			
			<!--- check to see if the deployment directory already exists, and if we are supposed to create it if it doesnt --->
			<cfif NOT directoryExists(variables.deployDir)>
				
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/archive/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="The deployment directory does not exist." />
				</cfinvoke>
				
				<cflocation url="#application.settings.appBaseDir#/archive/archive.cfm?archiveID=#form.archiveID#" />
			
			</cfif>
			
			<cfset variables.zipFilePath = application.config.archiveDirectory & application.settings.pathSeperator & form.archiveID & ".zip" />
			<cfset variables.archiveZipFilePath = variables.tempDir & application.settings.pathSeperator & form.archiveID & ".zip" />
			
			<!--- unzip the actual archive to a temp location --->
			<cfzip action="unzip" file="#variables.zipFilePath#" destination="#variables.tempDir#" filter="*.zip" />
			
			<cfset variables.currentSHAHash = application.objs.global.getArchiveZipFileHash(variables.zipFilePath,form.archiveID) />

			<cfzip action="unzip" file="#variables.archiveZipFilePath#" destination="#variables.deployDir#" overwrite="true" />

			<!--- run through and validate all of the files moved properly by checking their hash against the records --->			
			<cfloop query="variables.archiveFiles">
				<cfset variables.filePath = replaceNoCase(replaceNoCase(replaceNoCase(variables.archiveFiles.filePath,variables.backupArchive.builddir,""),"\",application.settings.pathSeperator,"all"),"/",application.settings.pathSeperator,"all") />
				<cfset variables.fileDeployPath = variables.deployDir & variables.filePath />
				
				<cfset variables.fileExists = fileExists(variables.fileDeployPath)>
				<cfif NOT variables.fileExists OR application.objs.global.getFileSHAHash(variables.fileDeployPath) NEQ variables.archiveFiles.fileSHAHash>
					<!--- something went wrong --->
					<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
						<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/archive/action.cfm" />
						<cfinvokeargument name="messageType" value="Error" />
						<cfinvokeargument name="messageText" value="#variables.fileDeployPath# did not deploy properly!" />
						<cfinvokeargument name="messageDetail" value="The deployed file's hash #application.objs.global.getFileSHAHash(variables.fileDeployPath)# does not match the hash on record: #variables.archiveFiles.fileSHAHash#!." />
					</cfinvoke>
				</cfif>			
			</cfloop>
			
			<!--- now loop through the deployment manifest and remove any file that did not previously exist --->
			<cfloop query="variables.deploymentManifest">
				<cfif NOT len(trim(variables.deploymentManifest.previousFileSHAHash))>
					<cfset variables.filePath = replaceNoCase(replaceNoCase(replaceNoCase(variables.deploymentManifest.filePath,variables.archive.builddir,""),"\",application.settings.pathSeperator,"all"),"/",application.settings.pathSeperator,"all") />
					<cfset variables.fileDeployPath = variables.deployDir & variables.filePath />
					<cfif fileExists(variables.fileDeployPath)>
						<cffile action="delete" file="#variables.fileDeployPath#" />
					</cfif>
				</cfif>
			</cfloop>
			
			<cfinvoke component="#application.daos.cascade#" method="createDeployment" returnvariable="createDeploymentRet">
				<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
				<cfinvokeargument name="deploymentID" value="#createUUID()#" />	<!---Type:String Hint:  - CHAR (35) --->
				<cfinvokeargument name="archiveid" value="#form.backupArchiveID#" />	<!---Type:String Hint:  - CHAR (35) --->
				<cfinvokeargument name="archiveshahash" value="#variables.currentSHAHash#" />	<!---Type:String Hint:  - CHAR (40) --->
				<cfinvokeargument name="buildsystemname" value="#variables.backupArchive.buildSystemName#" />	<!---Type:String Hint:  - VARCHAR (255) --->
				<cfinvokeargument name="deployedSystemname" value="#application.config.serverName#" />	<!---Type:String Hint:  - VARCHAR (255) --->
				<cfinvokeargument name="deployedbyuserid" value="#session.login.getUserID()#" />	<!---Type:String Hint:  - CHAR (35) --->
				<cfinvokeargument name="deployedbyusername" value="#session.login.getUsername()#" />	<!---Type:String Hint:  - VARCHAR (100) --->
				<cfinvokeargument name="deployedbyuserfullname" value="#session.login.getFullname()#" />	<!---Type:String Hint:  - VARCHAR (100) --->
				<cfinvokeargument name="deployedbyuseremail" value="#session.login.getEmail()#" />	<!---Type:String Hint:  - VARCHAR (255) --->
				<cfinvokeargument name="deployedon" value="#now()#" />	<!---Type:date Hint:  - TIMESTAMP (26) --->
				<cfinvokeargument name="deploymentdir" value="#variables.deployDir#" />	<!---Type:String Hint:  - VARCHAR (1000) --->
				<cfinvokeargument name="deploymentNotes" value="REVERT OF PREVIOUS DEPLOYMENT" />	<!---Type:String Hint:  - LONG VARCHAR --->
				<cfinvokeargument name="wasbackuptaken" value="0" />	<!---Type:Numeric Hint:  - INTEGER (10) --->
				<cfinvokeargument name="backupArchiveID" value="" />	<!---Type:String Hint:  - CHAR (35) --->
			</cfinvoke>		
			
			<cfinvoke component="#application.daos.cascade#" method="insertArchiveLog">
				<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
				<cfinvokeargument name="archiveid" value="#form.backupArchiveid#" />	<!---Type:String Hint:  - CHAR (35) --->
				<cfinvokeargument name="archiveshahash" value="#variables.currentSHAHash#" />	<!---Type:String Hint:  - CHAR (40) --->
				<cfinvokeargument name="buildsystemname" value="#variables.backupArchive.buildsystemname#" />	<!---Type:String Hint:  - VARCHAR (255) --->
				<cfinvokeargument name="logSystemName" value="#application.config.serverName#" />	<!---Type:String Hint:  - VARCHAR (255) --->
				<cfinvokeargument name="logaction" value="DEPLOYBACKUPARCHIVE" />	<!---Type:String Hint:  - VARCHAR (50) --->
				<cfinvokeargument name="deployflag" value="1" />	<!---Type:Numeric Hint:  - INTEGER (10) --->
				<cfinvokeargument name="backupcreatedflag" value="0" />	<!---Type:Numeric Hint:  - INTEGER (10) --->
				<cfinvokeargument name="backuparchiveid" value="" />	<!---Type:String Hint:  - CHAR (35) --->
				<cfinvokeargument name="userid" value="#session.login.getUserID()#" />	<!---Type:String Hint:  - CHAR (35) --->
				<cfinvokeargument name="logmessage" value="#form.archiveID# (#lcase(left(variables.currentSHAHash,application.settings.showFirstXCharsOfSHA))#) BACKUP DEPLOYED by #session.login.getUsername()# to #variables.deployDir# - REVERTED FOR ARCHIVEID: #form.originalArchiveID# - DEPLOYMENTID: #form.deploymentID# - BACKUP ARCHIVEID: #form.backupArchiveID#" />	<!---Type:String Hint:  - VARCHAR (1000) --->
				<cfinvokeargument name="logDateTime" value="#now()#" />
			</cfinvoke>
			
			<cfset saveDataToManifest(variables.zipFilePath,form.backupArchiveID) />
			
			<cfset variables.zipFilePath = application.config.archiveDirectory & "/" & variables.archive.archiveID & ".zip" />
			<cfset variables.currentSHAHash = application.objs.global.getArchiveZipFileHash(variables.zipFilePath,variables.archive.archiveID)/>
			
			<cfinvoke component="#application.daos.cascade#" method="insertArchiveLog">
				<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
				<cfinvokeargument name="archiveid" value="#form.originalArchiveID#" />	<!---Type:String Hint:  - CHAR (35) --->
				<cfinvokeargument name="archiveshahash" value="#variables.currentSHAHash#" />	<!---Type:String Hint:  - CHAR (40) --->
				<cfinvokeargument name="buildsystemname" value="#variables.archive.buildsystemname#" />	<!---Type:String Hint:  - VARCHAR (255) --->
				<cfinvokeargument name="logSystemName" value="#application.config.serverName#" />	<!---Type:String Hint:  - VARCHAR (255) --->
				<cfinvokeargument name="logaction" value="REVERT DEPLOYMENT" />	<!---Type:String Hint:  - VARCHAR (50) --->
				<cfinvokeargument name="deployflag" value="1" />	<!---Type:Numeric Hint:  - INTEGER (10) --->
				<cfinvokeargument name="backupcreatedflag" value="0" />	<!---Type:Numeric Hint:  - INTEGER (10) --->
				<cfinvokeargument name="backuparchiveid" value="" />	<!---Type:String Hint:  - CHAR (35) --->
				<cfinvokeargument name="userid" value="#session.login.getUserID()#" />	<!---Type:String Hint:  - CHAR (35) --->
				<cfinvokeargument name="logmessage" value="#form.archiveID# (#lcase(left(variables.currentSHAHash,application.settings.showFirstXCharsOfSHA))#) DEPLOYMENT REVERTED by #session.login.getUsername()# to #variables.deployDir# - REVERTED FOR ARCHIVEID: #form.originalArchiveID# - DEPLOYMENTID: #form.deploymentID# - BACKUP ARCHIVEID: #form.backupArchiveID#" />	<!---Type:String Hint:  - VARCHAR (1000) --->
				<cfinvokeargument name="logDateTime" value="#now()#" />
			</cfinvoke>
			
			<cfset saveDataToManifest(variables.zipFilePath,form.originalArchiveID) />

			<cflocation url="#application.settings.appBasedir#/archive/archive.cfm?archiveID=#form.originalArchiveID#" />
			
			
		</cfcase>
		
		<cfcase value="markAsObsolete">
		
			<cfif NOT structKeyExists(form,"archiveID") OR NOT isValid("UUID",form.archiveID)>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/archive/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="archiveID is required." />
				</cfinvoke>
			</cfif>
			
			<cfif session.messenger.hasAlerts()>
				<cflocation url="#application.settings.appBaseDir#/archive/browse.cfm" />
			</cfif>
			
			<cfinvoke component="#application.daos.cascade#" method="getArchiveByArchiveID" returnvariable="variables.archive">
				<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
				<cfinvokeargument name="archiveID" value="#form.archiveID#" />	<!---Type:string  --->
			</cfinvoke>
		
			<cfif NOT variables.archive.recordCount>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/archive/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="archiveID #form.archiveID# is not valid." />
				</cfinvoke>
			</cfif>
			
			<cfif session.messenger.hasAlerts()>
				<cflocation url="#application.settings.appBaseDir#/archive/browse.cfm" />
			</cfif>
			
			<cfinvoke component="#application.daos.cascade#" method="setArchiveIsObsolete">
				<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
				<cfinvokeargument name="archiveID" value="#variables.archive.archiveID#" />	<!---Type:String Hint:  - CHAR (35) --->
				<cfinvokeargument name="isObsolete" value="1" />
			</cfinvoke>
			
			<cfset variables.zipFilePath = application.config.archiveDirectory & application.settings.pathSeperator & variables.archive.archiveID & ".zip" />
			<cfset variables.archiveSHAHash = application.objs.global.getFileSHAHash(variables.zipFilePath) />
			
			<cfinvoke component="#application.daos.cascade#" method="insertArchiveLog">
				<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
				<cfinvokeargument name="archiveid" value="#variables.archive.archiveid#" />	<!---Type:String Hint:  - CHAR (35) --->
				<cfinvokeargument name="archiveshahash" value="#variables.archiveshahash#" />	<!---Type:String Hint:  - CHAR (40) --->
				<cfinvokeargument name="buildsystemname" value="#variables.archive.buildSystemName#" />	<!---Type:String Hint:  - VARCHAR (255) --->
				<cfinvokeargument name="logSystemName" value="#application.config.serverName#" />	<!---Type:String Hint:  - VARCHAR (255) --->
				<cfinvokeargument name="logaction" value="OBSOLETEARCHIVE" />	<!---Type:String Hint:  - VARCHAR (50) --->
				<cfinvokeargument name="deployflag" value="0" />	<!---Type:Numeric Hint:  - INTEGER (10) --->
				<cfinvokeargument name="backupcreatedflag" value="0" />	<!---Type:Numeric Hint:  - INTEGER (10) --->
				<cfinvokeargument name="backuparchiveid" value="" />	<!---Type:String Hint:  - CHAR (35) --->
				<cfinvokeargument name="userid" value="#session.login.getUserID()#" />	<!---Type:String Hint:  - CHAR (35) --->
				<cfinvokeargument name="logmessage" value="#variables.archive.archiveID# (#lcase(left(variables.archiveSHAHash,application.settings.showFirstXCharsOfSHA))#) version: #variables.archive.versionName# set as obsolete by #session.login.getUsername()#" />	<!---Type:String Hint:  - VARCHAR (1000) --->
				<cfinvokeargument name="logDateTime" value="#now()#" />
			</cfinvoke>
			
			<cfset saveDataToManifest(variables.zipFilePath,variables.archive.archiveID) />
				
			<cflocation url="#application.settings.appBaseDir#/archive/archive.cfm?archiveID=#form.archiveID#" />	
				
		</cfcase>
		
		<cfcase value="unmarkAsObsolete">
		
			<cfif NOT structKeyExists(form,"archiveID") OR NOT isValid("UUID",form.archiveID)>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/archive/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="archiveID is required." />
				</cfinvoke>
			</cfif>
			
			<cfif session.messenger.hasAlerts()>
				<cflocation url="#application.settings.appBaseDir#/archive/browse.cfm" />
			</cfif>
			
			<cfinvoke component="#application.daos.cascade#" method="getArchiveByArchiveID" returnvariable="variables.archive">
				<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
				<cfinvokeargument name="archiveID" value="#form.archiveID#" />	<!---Type:string  --->
			</cfinvoke>
		
			<cfif NOT variables.archive.recordCount>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/archive/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="archiveID #form.archiveID# is not valid." />
				</cfinvoke>
			</cfif>
			
			<cfif session.messenger.hasAlerts()>
				<cflocation url="#application.settings.appBaseDir#/archive/browse.cfm" />
			</cfif>
			
			<cfinvoke component="#application.daos.cascade#" method="setArchiveIsObsolete">
				<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
				<cfinvokeargument name="archiveID" value="#variables.archive.archiveID#" />	<!---Type:String Hint:  - CHAR (35) --->
				<cfinvokeargument name="isObsolete" value="0" />
			</cfinvoke>
			
			<cfset variables.zipFilePath = application.config.archiveDirectory & application.settings.pathSeperator & variables.archive.archiveID & ".zip" />
			<cfset variables.archiveSHAHash = application.objs.global.getFileSHAHash(variables.zipFilePath) />
			
			<cfinvoke component="#application.daos.cascade#" method="insertArchiveLog">
				<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
				<cfinvokeargument name="archiveid" value="#variables.archive.archiveid#" />	<!---Type:String Hint:  - CHAR (35) --->
				<cfinvokeargument name="archiveshahash" value="#variables.archiveshahash#" />	<!---Type:String Hint:  - CHAR (40) --->
				<cfinvokeargument name="buildsystemname" value="#variables.archive.buildSystemName#" />	<!---Type:String Hint:  - VARCHAR (255) --->
				<cfinvokeargument name="logSystemName" value="#application.config.serverName#" />	<!---Type:String Hint:  - VARCHAR (255) --->
				<cfinvokeargument name="logaction" value="DE-OBSOLETEARCHIVE" />	<!---Type:String Hint:  - VARCHAR (50) --->
				<cfinvokeargument name="deployflag" value="0" />	<!---Type:Numeric Hint:  - INTEGER (10) --->
				<cfinvokeargument name="backupcreatedflag" value="0" />	<!---Type:Numeric Hint:  - INTEGER (10) --->
				<cfinvokeargument name="backuparchiveid" value="" />	<!---Type:String Hint:  - CHAR (35) --->
				<cfinvokeargument name="userid" value="#session.login.getUserID()#" />	<!---Type:String Hint:  - CHAR (35) --->
				<cfinvokeargument name="logmessage" value="#variables.archive.archiveID# (#lcase(left(variables.archiveSHAHash,application.settings.showFirstXCharsOfSHA))#) version: #variables.archive.versionName# obsolete designation removed by #session.login.getUsername()#" />	<!---Type:String Hint:  - VARCHAR (1000) --->
				<cfinvokeargument name="logDateTime" value="#now()#" />
			</cfinvoke>
			
			<cfset saveDataToManifest(variables.zipFilePath,variables.archive.archiveID) />
				
			<cflocation url="#application.settings.appBaseDir#/archive/archive.cfm?archiveID=#form.archiveID#" />	
				
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

<cffunction name="saveDataToManifest" access="public" returntype="void" output="false" hint="">
	<cfargument name="zipFilePath" type="string" required="True" />
	<cfargument name="archiveID" type="string" required="True" />
	
	<cfset var local = structNew() />
	
	<!--- get the manifest struct --->
	<cfset local.manifest = application.objs.global.getZipManifest(arguments.zipFilePath) />
	
	<!--- get the certifications, deployments and log to append to the manifest --->		
	<cfinvoke component="#application.daos.cascade#" method="getArchiveByArchiveID" returnvariable="local.archiveData">
		<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
		<cfinvokeargument name="archiveID" value="#arguments.archiveID#" />	<!---Type:string  --->
	</cfinvoke>
	
	<cfset local.manifest.isObsolete = local.archiveData.isObsolete />	
			
	<cfinvoke component="#application.daos.cascade#" method="getArchiveCertificationsForArchiveID" returnvariable="local.certifications">
		<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
		<cfinvokeargument name="archiveID" value="#arguments.archiveID#" />	<!---Type:string  --->
	</cfinvoke>

	<cfinvoke component="#application.daos.cascade#" method="getArchiveLogForArchiveID" returnvariable="local.log">
		<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
		<cfinvokeargument name="archiveID" value="#arguments.archiveID#" />	<!---Type:string  --->
	</cfinvoke>	
	
	<cfinvoke component="#application.daos.cascade#" method="getDeploymentsForArchiveID" returnvariable="local.deployments">
		<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
		<cfinvokeargument name="archiveID" value="#arguments.archiveID#" />	<!---Type:string  --->
	</cfinvoke>
	
	<cfinvoke component="#application.daos.cascade#" method="getDeploymentFilesManifestForArchiveID" returnvariable="local.deploymentFilesManifest">
		<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
		<cfinvokeargument name="archiveID" value="#arguments.archiveID#" />	<!---Type:string  --->
	</cfinvoke>
	
	<cfset local.manifest.certifications = local.certifications />
	<cfset local.manifest.log = local.log />
	<cfset local.manifest.deployments = local.deployments />
	<cfset local.manifest.deploymentFilesManifest = local.deploymentFilesManifest />
	
	<!--- write out the manifest back to the zip --->
	<cfset application.objs.global.setZipManifest(arguments.zipFilePath,local.manifest) />	
	
	
</cffunction>

