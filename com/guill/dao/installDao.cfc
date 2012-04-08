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

<cfcomponent>

	
	<cffunction name="createNewDerbyDatabase" access="public" returntype="boolean" output="false" hint="">
    	<cfargument name="administratorPassword" type="string" required="true" />
		<cfargument name="dsnName" type="string" required="True" />
		<cfargument name="databaseName" type="string" required="true" />
		<cfargument name="databaseDirectory" type="string" required="true" />
		
		<cfset var adminObj = createObject("component","cfide.adminapi.administrator").login(arguments.administratorPassword) />
		<cfset var dsnObj = createObject("component","cfide.adminapi.datasource") />
		
		<cfset var existingDSNs = dsnObj.getDatasources() />
		
		<cfset var dsnProperties = structNew() />
		
		<cfif structKeyExists(existingDSNs,arguments.dsnName)>
			<cfreturn false />
		</cfif> 
		
		<cfset dsnProperties = structNew() />
		<cfset dsnProperties.name = arguments.dsnName />
		<cfset dsnProperties.databaseName = arguments.databaseName />
		<cfset dsnProperties.databaseDirectory = arguments.databaseDirectory />
		<cfset dsnProperties.database = arguments.databaseDirectory & arguments.databaseName />
		<cfset dsnProperties.isNewDB = true />
		
		<cfset dsnObj.setDerbyEmbedded(argumentCollection=dsnProperties) />
		<cfset dsnObj.verifyDSN(dsn=arguments.dsnNAme) />
		
		<cfset dsnProperties.isNewDB = false />
		
		<cfset dsnObj.setDerbyEmbedded(argumentCollection=dsnProperties) />
		<cfset temp = dsnObj.verifyDSN(dsn=arguments.dsnNAme) />
		
	<cfreturn true />
    </cffunction>

	<cffunction name="createTable_users" access="public" returntype="boolean" output="false" hint="">
		<cfargument name="dsn" type="String" required="True" />
		
		<cfset var qCreateTable_users = "" />
		
		<cftry>
			<cfquery name="qCreateTable_users" datasource="#arguments.dsn#">
				CREATE 
					TABLE users
				(
					  userID				char(35)			NOT NULL				
					, username				varchar(100)		NOT NULL				
					, email					varchar(255)		NOT NULL
					, firstname				varchar(50)			NOT NULL
					, lastname				varchar(50)			NOT NULL
					, password				varchar(100)		NOT NULL
					, createdBy				varchar(100)		NOT NULL
					, createdOn				timestamp			NOT NULL
					, lastUpdatedBy			varchar(100)		NOT NULL
					, lastUpdatedOn			timestamp			NOT NULL
					, passwordLastSetOn		timestamp			NOT NULL
					
					, PRIMARY KEY (userID) 	
				)
			</cfquery>
		<cfcatch>
			<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
		<cfrethrow />
		</cfcatch>
		</cftry>
		
	<cfreturn true />
	</cffunction>
	
	<cffunction name="createTable_userGroups" access="public" returntype="boolean" output="false" hint="">
		<cfargument name="dsn" type="String" required="True" />
		
		<cfset var qCreateTable_userGroups = "" />
		
		<cftry>
			<cfquery name="qCreateTable_userGroups" datasource="#arguments.dsn#">
				
				CREATE 
					TABLE userGroups
				(
					  userGroupID		char(35) 		NOT NULL				
					, userGroupName		varchar(50)		NOT NULL				
					, userGroupDesc		varchar(250)	NOT NULL				
				
					, PRIMARY KEY (userGroupID)	
				)
				
			</cfquery>
		<cfcatch>
			<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
		<cfrethrow />
		</cfcatch>
		</cftry>
		
	<cfreturn true />
	</cffunction>
	
	
	<cffunction name="createTable_userGroupMembers" access="public" returntype="boolean" output="false" hint="">
		<cfargument name="dsn" type="String" required="True" />
		
		<cfset var qCreateTable_userGroupMembers = "" />
		
		<cftry>
			<cfquery name="qCreateTable_userGroupMembers" datasource="#arguments.dsn#">
				
				CREATE 
					TABLE userGroupMembers
				(
					  userGroupMemberID		char(35)	NOT NULL						
					, userID				char(35)	NOT NULL				
					, userGroupID			char(35)	NOT NULL				
				
					, PRIMARY KEY (userGroupMemberID)	
				
				)
				
			</cfquery>
		<cfcatch>
			<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
		<cfrethrow />
		</cfcatch>
		</cftry>
		
	<cfreturn true />
	</cffunction>
		
	<cffunction name="createTable_archives" access="public" returntype="boolean" output="false" hint="">
		<cfargument name="dsn" type="String" required="True" />
		
		<cfset var qCreateTable_archives = "" />
		
		<cftry>
			<cfquery name="qCreateTable_archives" datasource="#arguments.dsn#">
				
				CREATE 
					TABLE archives
				(
					  archiveID					char(35)		NOT NULL						
					, archiveSHAHash			char(40)		NOT NULL
					, buildSystemName			varchar(255)	NOT NULL				
					, applicationName			varchar(255)	NOT NULL
					, versionName				varchar(50)		NOT NULL
					, projectName				varchar(255)	NOT NULL
					, projectNumber				varchar(50)		NOT NULL
					, ticketNumber				varchar(150)	NOT NULL
					, changeReason				varchar(50)		NOT NULL
					, author					varchar(255)	NOT NULL
					, changeDescription			long varchar	NOT NULL
					, buildByUserID				char(35)		NOT NULL
					, buildByUserName			varchar(100)	NOT NULL
					, buildByUserFullname		varchar(100)	NOT NULL
					, buildByUserEmail			varchar(255)	NOT NULL
					, buildOn					timestamp		NOT NULL
					, buildDir					varchar(1000)	NOT NULL
					, deployDirSuggestions		varchar(5000)	NOT NULL
					, fileCount					integer			NOT NULL
					, isNativeBuild				integer			NOT NULL
					, isBackupArchive			integer			NOT NULL
					, isObsolete				integer			NOT NULL
					, backupForArchiveID		char(35)		NOT NULL				
				
					, PRIMARY KEY (archiveID)	
				
				)
				
			</cfquery>
		<cfcatch>
			<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
		<cfrethrow />
		</cfcatch>
		</cftry>
		
	<cfreturn true />
	</cffunction>
	
		
	<cffunction name="createTable_archiveDeployments" access="public" returntype="boolean" output="false" hint="">
		<cfargument name="dsn" type="String" required="True" />
		
		<cfset var qCreateTable_archiveDeployments = "" />
		
		<cftry>
			<cfquery name="qCreateTable_archiveDeployments" datasource="#arguments.dsn#">
				
				CREATE 
					TABLE archiveDeployments
				(
					  deploymentID				char(35)		NOT NULL
					, archiveID					char(35)		NOT NULL						
					, archiveSHAHash			char(40)		NOT NULL
					, buildSystemName			varchar(255)	NOT NULL				
					, deployedSystemName		varchar(255)	NOT NULL
					, deployedByUserID			char(35)		NOT NULL
					, deployedByUserName		varchar(100)	NOT NULL
					, deployedByUserFullname	varchar(100)	NOT NULL
					, deployedByUserEmail		varchar(255)	NOT NULL
					, deployedOn				timestamp		NOT NULL
					, deploymentDir				varchar(1000)	NOT NULL
					, deploymentNotes			long varchar 	NOT NULL
					, wasBackupTaken			integer			NOT NULL
					, backupArchiveID			char(35)		NOT NULL				
				
					, PRIMARY KEY (deploymentID)	
				
				)
				
			</cfquery>
		<cfcatch>
			<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
		<cfrethrow />
		</cfcatch>
		</cftry>
		
	<cfreturn true />
	</cffunction>
	
	
	<cffunction name="createTable_archiveLog" access="public" returntype="boolean" output="false" hint="">
		<cfargument name="dsn" type="String" required="True" />
		
		<cfset var qCreateTable_archiveLog = "" />
		
		<cftry>
			<cfquery name="qCreateTable_archiveLog" datasource="#arguments.dsn#">
				
				CREATE 
					TABLE archiveLog
				(
					  logID						char(35)		NOT NULL
					, archiveID					char(35)		NOT NULL						
					, archiveSHAHash			char(40)		NOT NULL
					, buildSystemName			varchar(255)	NOT NULL				
					, logSystemName				varchar(255)	NOT NULL
					, logAction					varchar(50)		NOT NULL
					, deployFlag				integer			NOT NULL
					, backupCreatedFlag			integer			NOT NULL
					, backupArchiveID			char(35)		NOT NULL
					, userID					char(35)		NOT NULL
					, logMessage				varchar(1000)	NOT NULL
					, logDateTime				timestamp		NOT NULL
				
					, PRIMARY KEY (logID)	
				
				)
				
			</cfquery>
		<cfcatch>
			<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
		<cfrethrow />
		</cfcatch>
		</cftry>
		
	<cfreturn true />
	</cffunction>
			
	<cffunction name="createTable_archiveFiles" access="public" returntype="boolean" output="false" hint="">
		<cfargument name="dsn" type="String" required="True" />
		
		<cfset var qCreateTable_archiveFiles = "" />
		
		<cftry>
			<cfquery name="qCreateTable_archiveFiles" datasource="#arguments.dsn#">
				
				CREATE 
					TABLE archiveFiles
				(
					  fileID					char(35)		NOT NULL
					, archiveID					char(35)		NOT NULL						
					, fileSHAHash				char(40)		NOT NULL
					, filePath					varchar(255)	NOT NULL		
				
					, PRIMARY KEY (fileID)	
				
				)
				
			</cfquery>
		<cfcatch>
			<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
		<cfrethrow />
		</cfcatch>
		</cftry>
		
	<cfreturn true />
	</cffunction>
	
			
	<cffunction name="createTable_deploymentFilesManifest" access="public" returntype="boolean" output="false" hint="">
		<cfargument name="dsn" type="String" required="True" />
		
		<cfset var qCreateTable_deploymentFilesManifest = "" />
		
		<cftry>
			<cfquery name="qCreateTable_deploymentFilesManifest" datasource="#arguments.dsn#">
				
				CREATE 
					TABLE deploymentFilesManifest
				(
					  deploymentFileManifestID	char(35)		NOT NULL
					, deploymentID				char(35)		NOT NULL
					, archiveID					char(35)		NOT NULL						
					, deployedSystemName		varchar(255)	NOT NULL
					, archiveFileID				char(35)		NOT NULL
					, deployedFilePath			varchar(255)	NOT NULL		
					, backupArchiveID			char(35)		NOT NULL
					, backupArchiveFileID		char(35)		NOT NULL		
					, previousFileSHAHash		char(40)		NOT NULL -- leave empty if file did not previously exist
					
					, PRIMARY KEY (deploymentFileManifestID)	
				
				)
				
			</cfquery>
		<cfcatch>
			<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
		<cfrethrow />
		</cfcatch>
		</cftry>
		
	<cfreturn true />
	</cffunction>
		
	<cffunction name="createTable_archiveCertifications" access="public" returntype="boolean" output="false" hint="">
		<cfargument name="dsn" type="String" required="True" />
		
		<cfset var qCreateTable_archiveCertifications = "" />
		
		<cftry>
			<cfquery name="qCreateTable_archiveCertifications" datasource="#arguments.dsn#">
				
				CREATE 
					TABLE archiveCertifications
				(
					  certificationID			char(35)		NOT NULL
					, archiveID					char(35)		NOT NULL						
					, archiveSHAHash			char(40)		NOT NULL
					, userID					char(35)		NOT NULL
					, userFullname				varchar(100)	NOT NULL
					, userEmail					varchar(255)	NOT NULL
					, certificationTypeName		varchar(25)		NOT NULL
					, certificationNotes		long varchar	NOT NULL
					, certificationHash			char(40)		NOT NULL
					, certificationOn			timestamp		NOT NULL							
					, certificationSystemName	varchar(255)	NOT NULL
					
					, PRIMARY KEY (certificationID)	
				
				)
				
			</cfquery>
		<cfcatch>
			<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
		<cfrethrow />
		</cfcatch>
		</cftry>
		
	<cfreturn true />
	</cffunction>
	
	<cffunction name="createTable_ref_changeTypes" access="public" returntype="boolean" output="false" hint="">
		<cfargument name="dsn" type="String" required="True" />
		
		<cfset var qCreateTable_ref_changeTypes = "" />
		
		<cftry>
			<cfquery name="qCreateTable_ref_changeTypes" datasource="#arguments.dsn#">
				
				CREATE 
					TABLE ref_changeTypes
				(
					  changeTypeID			INTEGER			NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1)						
					, changeTypeName		VARCHAR(25)		NOT NULL				
					, sort					INTEGER			NOT NULL
					, changeTypeDesc		VARCHAR(250)	NOT NULL
					, changetypeAbbr		VARCHAR(15)		NOT NULL	
					, activeFlag			INTEGER			NOT NULL			
				
					, PRIMARY KEY (changeTypeID)					
				)
				
			</cfquery>
		<cfcatch>
			<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
		<cfrethrow />
		</cfcatch>
		</cftry>
		
	<cfreturn true />
	</cffunction>
	
	
	<cffunction name="createTable_ref_certificationTypes" access="public" returntype="boolean" output="false" hint="">
		<cfargument name="dsn" type="String" required="True" />
		
		<cfset var qCreateTable_ref_certificationTypes = "" />
		
		<cftry>
			<cfquery name="qCreateTable_ref_certificationTypes" datasource="#arguments.dsn#">
				
				CREATE 
					TABLE ref_certificationTypes
				(
					  certificationTypeID			INTEGER			NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1)						
					, certificationTypeName			VARCHAR(25)		NOT NULL				
					, sort							INTEGER			NOT NULL
					, certificationTypeDesc			VARCHAR(250)	NOT NULL
					, certificationtypeAbbr			VARCHAR(15)		NOT NULL	
					, requiredUserGroupName			VARCHAR(50)		NOT NULL
					, activeFlag					INTEGER			NOT NULL			
				
					, PRIMARY KEY (certificationTypeID)					
				)
				
			</cfquery>
		<cfcatch>
			<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
		<cfrethrow />
		</cfcatch>
		</cftry>
		
	<cfreturn true />
	</cffunction>
	
	
	<cffunction name="createTable_cascadeConfig" access="public" returntype="boolean" output="false" hint="">
		<cfargument name="dsn" type="String" required="True" />
		
		<cfset var qCreateTable_cascadeConfig = "" />
		
		<cftry>
			<cfquery name="qCreateTable_cascadeConfig" datasource="#arguments.dsn#">
				
				CREATE 
					TABLE cascadeConfig
				(
					  configKey						VARCHAR(255)	NOT NULL				
					, configValue					VARCHAR(5000)	NOT NULL
				
					, PRIMARY KEY (configKey)					
				)
				
			</cfquery>
		<cfcatch>
			<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
		<cfrethrow />
		</cfcatch>
		</cftry>
		
	<cfreturn true />
	</cffunction>
	
	<cffunction name="createTable_remoteValidationCodes" access="public" returntype="boolean" output="false" hint="">
		<cfargument name="dsn" type="String" required="True" />
		
		<cfset var qCreateTable_remoteValidationCodes = "" />
		
		<cftry>
			<cfquery name="qCreateTable_cascadeConfig" datasource="#arguments.dsn#">
				
				CREATE 
					TABLE remoteValidationCodes
				(
					  serverID						char(35)		NOT NULL
					, validationCode				char(40)		NOT NULL
					, createdByUserID				char(35)		NOT NULL
					, createdByUserName				varchar(100)	NOT NULL
					, createdByUserFullname			varchar(100)	NOT NULL
					, createdByUserEmail			varchar(255)	NOT NULL
					, createdOn						timestamp		NOT NULL				
									
					, PRIMARY KEY (serverID)					
				)
				
			</cfquery>
		<cfcatch>
			<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
		<cfrethrow />
		</cfcatch>
		</cftry>
		
	<cfreturn true />
	</cffunction>
	
	<cffunction name="createTable_remoteServers" access="public" returntype="boolean" output="false" hint="">
		<cfargument name="dsn" type="String" required="True" />
		
		<cfset var qCreateTable_remoteServers = "" />
		
		<cftry>
			<cfquery name="qCreateTable_remoteServers" datasource="#arguments.dsn#">
				
				CREATE 
					TABLE remoteServers
				(
					  serverID						char(35)		NOT NULL				
					, serverName					varchar(255)	NOT NULL
					, serverURL						varchar(255)	NOT NULL
					, validationCode				char(40)		NOT NULL
					, serverVersion					varchar(10)		NOT NULL
					, configuredByUserID			char(35)		NOT NULL
					, configuredByUserName			varchar(100)	NOT NULL
					, configuredByUserFullname		varchar(100)	NOT NULL
					, configuredByUserEmail			varchar(255)	NOT NULL
					, configuredOn					timestamp		NOT NULL
					
					, PRIMARY KEY (serverID)					
				)
				
			</cfquery>
		<cfcatch>
			<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
		<cfrethrow />
		</cfcatch>
		</cftry>
		
	<cfreturn true />
	</cffunction>
	
	<!--- added in version 1.1 --->
	<cffunction name="createTable_remoteServer_certificationTypes" access="public" returntype="boolean" output="false" hint="">
		<cfargument name="dsn" type="String" required="True" />
		
		<cfset var qCreateTable_remoteServer_certificationTypes = "" />
		
		<cftry>
			<cfquery name="qCreateTable_remoteServer_certificationTypes" datasource="#arguments.dsn#">
				
				CREATE 
					TABLE remoteServer_certificationTypes
				(
					  serverID						CHAR(35)		NOT NULL
					, certificationTypeID			INTEGER			NOT NULL
					, certificationTypeName			VARCHAR(25)		NOT NULL				
					, sort							INTEGER			NOT NULL
					, certificationTypeDesc			VARCHAR(250)	NOT NULL
					, certificationtypeAbbr			VARCHAR(15)		NOT NULL	
					, activeFlag					INTEGER			NOT NULL			
					, includeInRemoteArchiveSearch	INTEGER			NOT NULL
				
					, PRIMARY KEY (serverID, certificationTypeID)					
				)
				
			</cfquery>
		<cfcatch>
			<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
		<cfrethrow />
		</cfcatch>
		</cftry>
		
	<cfreturn true />
	</cffunction>
	

</cfcomponent>