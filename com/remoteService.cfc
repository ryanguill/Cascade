<cfcomponent output="false">
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



	<!--- this is bad practice, but the alternative is a lot of code for very little benefit. --->

	<cffunction name="getValidationCodeForServerID" access="public" returntype="query" output="false" hint="">
    	<cfargument name="serverID" type="String" required="True" />
		
		<cfset var qGetValidationCodeForServerID = "" />
		
        <cftry>
        	<cfquery name="qGetValidationCodeForServerID" datasource="#application.config.dsn#">
        		SELECT
					  remotevalidationcodes.serverid		 --  CHAR (35)
					, remotevalidationcodes.validationcode	 --  CHAR (40)
					, remotevalidationcodes.createdbyuserid	 --  CHAR (35)
					, remotevalidationcodes.createdbyusername	 --  VARCHAR (100)
					, remotevalidationcodes.createdbyuserfullname	 --  VARCHAR (100)
					, remotevalidationcodes.createdbyuseremail	 --  VARCHAR (255)
					, remotevalidationcodes.createdon		 --  TIMESTAMP (26)
					
				FROM remotevalidationcodes
				WHERE
					 remotevalidationcodes.serverid = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.serverID#" />
        	
        	</cfquery>
        <cfcatch>
        	<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
        <cfrethrow />
        </cfcatch>
        </cftry>

    <cfreturn qGetValidationCodeForServerID />
    </cffunction>


	<cffunction name="checkValidationCode" access="remote" returntype="boolean" output="false">
		<cfargument name="serverID" type="string" required="true" />
		<cfargument name="validationCode" type="string" required="True" />
		
		<cfset var qGetValidationCodeForServerID = getValidationCodeForServerID(arguments.serverID) />
		
		<cfif qGetValidationCodeForServerID.recordCount>
			<cfif qGetValidationCodeForServerID.validationCode EQ replace(arguments.validationCode,"-","","all")>
				<cfreturn true />
			</cfif>
		</cfif>
		
	<cfreturn false /> 
	</cffunction>
	
	<cffunction name="createValidationCodeForServerID" access="public" returntype="query" output="false" hint="">
    	<cfargument name="serverID" type="string" required="True" />
		<cfargument name="createdbyuserid" type="String" required="true"  />
		<cfargument name="createdbyusername" type="String" required="true"  />
		<cfargument name="createdbyuserfullname" type="String" required="true"  />
		<cfargument name="createdbyuseremail" type="String" required="true"  />
		
		<cfset var qGetValidationCodeForServerID = getValidationCodeForServerID(arguments.serverID) />
		<cfset var qCreateValidationCodeForServerID = "" />
		<cfset var validationCode = hash(arguments.serverID & application.config.cascadeID & createUUID(),"SHA") />
		
		<cfif qGetValidationCodeForServerID.recordCount>
			<cfreturn qGetValidationCodeForServerID />
		</cfif>
		
        <cftry>
        	<cfquery name="qCreateValidationCodeForServerID" datasource="#application.config.dsn#">
        		INSERT INTO remotevalidationcodes
				(
					  serverid		 --  CHAR (35)
					, validationcode	 --  CHAR (40)
					, createdbyuserid	 --  CHAR (35)
					, createdbyusername	 --  VARCHAR (100)
					, createdbyuserfullname	 --  VARCHAR (100)
					, createdbyuseremail	 --  VARCHAR (255)
					, createdon		 --  TIMESTAMP (26)
				)
				VALUES
				(
					  <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.serverid#" />  -- serverid 
					, <cfqueryparam cfsqltype="cf_sql_char" value="#validationcode#" />  -- validationcode 
					, <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.createdbyuserid#" />  -- createdbyuserid 
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.createdbyusername#" />  -- createdbyusername 
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.createdbyuserfullname#" />  -- createdbyuserfullname 
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.createdbyuseremail#" />  -- createdbyuseremail 
					, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#" />  -- createdon 
				)        	
        	</cfquery>
        <cfcatch>
        	<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
        <cfrethrow />
        </cfcatch>
        </cftry>

    <cfreturn getValidationCodeForServerID(arguments.serverID) />
    </cffunction>

	<cffunction name="getRemoteServers" access="public" returntype="query" output="false" hint="">
    	
    	<cfset var qGetRemoteServers = "" />
		
        <cftry>
        	<cfquery name="qGetRemoteServers" datasource="#application.config.dsn#">
        		SELECT
					  remoteservers.serverid			 --  CHAR (35)
					, remoteservers.servername			 --  VARCHAR (255)
					, remoteservers.serverurl			 --  VARCHAR (255)
					, remoteservers.validationcode		 --  CHAR (40)
					, remoteservers.serverversion			 --  VARCHAR (10)
					, remoteservers.configuredbyuserid		 --  CHAR (35)
					, remoteservers.configuredbyusername		 --  VARCHAR (100)
					, remoteservers.configuredbyuserfullname	 --  VARCHAR (100)
					, remoteservers.configuredbyuseremail		 --  VARCHAR (255)
					, remoteservers.configuredon			 --  TIMESTAMP (26)
					
				FROM remoteservers
				ORDER BY remoteservers.servername 		
        	
        	</cfquery>
        <cfcatch>
        	<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
        <cfrethrow />
        </cfcatch>
        </cftry>

    <cfreturn qGetRemoteServers />
    </cffunction>
	
	<cffunction name="getRemoteServerByServerID" access="public" returntype="query" output="false" hint="">
    	<cfargument name="serverID" type="string" required="True" />
    	
		<cfset var qGetRemoteServerByServerID = "" />
		
        <cftry>
        	<cfquery name="qGetRemoteServerByServerID" datasource="#application.config.dsn#">
        		SELECT
					  remoteservers.serverid			 --  CHAR (35)
					, remoteservers.servername			 --  VARCHAR (255)
					, remoteservers.serverurl			 --  VARCHAR (255)
					, remoteservers.validationcode		 --  CHAR (40)
					, remoteservers.serverversion			 --  VARCHAR (10)
					, remoteservers.configuredbyuserid		 --  CHAR (35)
					, remoteservers.configuredbyusername		 --  VARCHAR (100)
					, remoteservers.configuredbyuserfullname	 --  VARCHAR (100)
					, remoteservers.configuredbyuseremail		 --  VARCHAR (255)
					, remoteservers.configuredon			 --  TIMESTAMP (26)
					
				FROM remoteservers
				WHERE
					remoteServers.serverID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.serverID#" />
        	</cfquery>
        <cfcatch>
        	<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
        <cfrethrow />
        </cfcatch>
        </cftry>

	<cfreturn qGetRemoteServerByServerID />    	
    </cffunction>
	
	<cffunction name="registerRemoteServer" access="public" returntype="query" output="false" hint="">
    	<cfargument name="serverid" type="String" required="true" hint=" - CHAR (35)" />
		<cfargument name="servername" type="String" required="true" hint=" - VARCHAR (255)" />
		<cfargument name="serverurl" type="String" required="true" hint=" - VARCHAR (255)" />
		<cfargument name="validationcode" type="String" required="true" hint=" - CHAR (40)" />
		<cfargument name="serverversion" type="String" required="true" hint=" - VARCHAR (10)" />
		<cfargument name="configuredbyuserid" type="String" required="true" hint=" - CHAR (35)" />
		<cfargument name="configuredbyusername" type="String" required="true" hint=" - VARCHAR (100)" />
		<cfargument name="configuredbyuserfullname" type="String" required="true" hint=" - VARCHAR (100)" />
		<cfargument name="configuredbyuseremail" type="String" required="true" hint=" - VARCHAR (255)" />
		
		<cfset var qRegisterRemoteServer = "" />
		<cfset var qRemoteServer = getRemoteServerByServerID(arguments.serverID) />
		
		<cfif qRemoteServer.recordCount>
			<cfreturn qRemoteServer />
		</cfif>
		
        <cftry>
        	<cfquery name="qRegisterRemoteServer" datasource="#application.config.dsn#">
        		INSERT INTO remoteservers
				(
					  serverid			 --  CHAR (35)
					, servername			 --  VARCHAR (255)
					, serverurl			 --  VARCHAR (255)
					, validationcode		 --  CHAR (40)
					, serverversion			 --  VARCHAR (10)
					, configuredbyuserid		 --  CHAR (35)
					, configuredbyusername		 --  VARCHAR (100)
					, configuredbyuserfullname	 --  VARCHAR (100)
					, configuredbyuseremail		 --  VARCHAR (255)
					, configuredon			 --  TIMESTAMP (26)
					
				)
				VALUES
				(
					  <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.serverid#" />  -- serverid 
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.servername#" />  -- servername 
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.serverurl#" />  -- serverurl 
					, <cfqueryparam cfsqltype="cf_sql_char" value="#replaceNoCase(arguments.validationcode,"-","","all")#" />  -- validationcode 
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.serverversion#" />  -- serverversion 
					, <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.configuredbyuserid#" />  -- configuredbyuserid 
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.configuredbyusername#" />  -- configuredbyusername 
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.configuredbyuserfullname#" />  -- configuredbyuserfullname 
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.configuredbyuseremail#" />  -- configuredbyuseremail 
					, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#" />  -- configuredon 
					
				)

        	
        	</cfquery>
        <cfcatch>
        	<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
        <cfrethrow />
        </cfcatch>
        </cftry>

    <cfreturn getRemoteServerByServerID(arguments.serverID) />
    </cffunction>

	<cffunction name="identifyServer" access="remote" returntype="struct" output="false" hint="">
    	<cfargument name="serverID" type="string" required="true" />
		<cfargument name="validationCode" type="string" required="True" />
    	
    	<cfset var output = structNew() />
		<cfset var validationCheck = checkValidationCode(arguments.serverID,arguments.validationCode) />
		
		<cfif NOT validationCheck>
			<cfset throwNotValid() />
		</cfif>
		
		<cfset output.serverID = application.config.cascadeID />
		<cfset output.serverName = application.config.serverName />
		<cfset output.serverVersion = application.config.cascadeVersion />
		
	<cfreturn output />    	
    </cffunction>
	
	<cffunction name="getAvailableArchives" access="remote" returntype="query" output="false" hint="">
    	<cfargument name="serverID" type="string" required="true" />
		<cfargument name="validationCode" type="string" required="True" />
    	
   		<cfset var qArchives = ""/>
		<cfset var validationCheck = checkValidationCode(arguments.serverID,arguments.validationCode) />
		
		<cfif NOT validationCheck>
			<cfset throwNotValid() />
		</cfif>
    	    	
    	<cfinvoke component="#application.daos.cascade#" method="searchArchives" returnvariable="qArchives">
			<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
			<cfinvokeargument name="archiveid" value="-1" />	<!---Type:String Hint: pass -1 to ignore. --->
			<cfinvokeargument name="archiveshahash" value="-1" />	<!---Type:String Hint: pass -1 to ignore. --->
			<cfinvokeargument name="buildsystemname" value="-1" />	<!---Type:String Hint: pass -1 to ignore. --->
			<cfinvokeargument name="applicationname" value="-1" />	<!---Type:String Hint: pass -1 to ignore. --->
			<cfinvokeargument name="versionname" value="-1" />	<!---Type:String Hint: pass -1 to ignore. --->
			<cfinvokeargument name="projectname" value="-1" />	<!---Type:String Hint: pass -1 to ignore. --->
			<cfinvokeargument name="projectnumber" value="-1" />	<!---Type:String Hint: pass -1 to ignore. --->
			<cfinvokeargument name="ticketnumber" value="-1" />	<!---Type:String Hint: pass -1 to ignore. --->
			<cfinvokeargument name="changereason" value="-1" />	<!---Type:String Hint: pass -1 to ignore. --->
			<cfinvokeargument name="author" value="-1" />	<!---Type:String Hint: pass -1 to ignore. --->
			<cfinvokeargument name="changedescription" value="-1" />	<!---Type:String Hint: pass -1 to ignore. --->
			<cfinvokeargument name="buildbyuserid" value="-1" />	<!---Type:String Hint: pass -1 to ignore. --->
			<cfinvokeargument name="buildbyusername" value="-1" />	<!---Type:String Hint: pass -1 to ignore. --->
			<cfinvokeargument name="buildbyuserfullname" value="-1" />	<!---Type:String Hint: pass -1 to ignore. --->
			<cfinvokeargument name="buildbyuseremail" value="-1" />	<!---Type:String Hint: pass -1 to ignore. --->
			<cfinvokeargument name="buildonAfter" value="1970-01-01" />	<!---Type:date Hint: pass 1970-01-01 to ignore --->
			<cfinvokeargument name="buildonBefore" value="1970-01-01" />	<!---Type:date Hint: pass 1970-01-01 to ignore --->
			<cfinvokeargument name="builddir" value="-1" />	<!---Type:String Hint: pass -1 to ignore. --->
			<cfinvokeargument name="deployDirSuggestions" value="-1" />	<!---Type:String Hint: pass -1 to ignore. --->
			<cfinvokeargument name="filecount" value="-1" />	<!---Type:numeric Hint: pass -1 to ignore. --->
			<cfinvokeargument name="isnativebuild" value="-1" />	<!---Type:numeric Hint:  pass -1 to ignore. --->
			<cfinvokeargument name="isbackuparchive" value="0" />	<!---Type:numeric Hint: pass -1 to ignore. --->
			<cfinvokeargument name="isObsolete" value="0" />	<!---Type:numeric Hint: pass -1 to ignore. --->
			<cfinvokeargument name="backupForArchiveID" value="-1" />	<!---Type:numeric Hint: pass -1 to ignore. --->
		</cfinvoke>
    	
    <cfreturn qArchives />
    </cffunction>
	
	<cffunction name="getAllInfoForArchive" access="remote" returntype="struct" output="false">
    	<cfargument name="serverID" type="string" required="true" />
		<cfargument name="validationCode" type="string" required="True" />
		<cfargument name="archiveID" type="string" required="true" />
		
		<cfset var local = structNew() />
		<cfset var validationCheck = checkValidationCode(arguments.serverID,arguments.validationCode) />
		
		<cfif NOT validationCheck>
			<cfset throwNotValid() />
		</cfif>
		
		<cfset local.output = structNew() />
		<cfset local.output.validArchive = true />
    	
    	<cfinvoke component="#application.daos.cascade#" method="getArchiveByArchiveID" returnvariable="local.output.archive">
			<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
			<cfinvokeargument name="archiveID" value="#arguments.archiveID#" />	<!---Type:string  --->
		</cfinvoke>
	
		<cfif NOT local.output.archive.recordCount>
			<cfset local.output.validArchive = false />
			<cfreturn local.output />
		</cfif>
		
		<cfinvoke component="#application.daos.cascade#" method="getFilesForArchiveID" returnvariable="local.output.files">
			<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
			<cfinvokeargument name="archiveID" value="#arguments.archiveID#" />	<!---Type:string  --->
		</cfinvoke>
		
		<cfinvoke component="#application.daos.cascade#" method="getArchiveCertificationsForArchiveID" returnvariable="local.output.certifications">
			<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
			<cfinvokeargument name="archiveID" value="#arguments.archiveID#" />	<!---Type:string  --->
		</cfinvoke>
	
		<cfinvoke component="#application.daos.cascade#" method="getArchiveLogForArchiveID" returnvariable="local.output.log">
			<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
			<cfinvokeargument name="archiveID" value="#arguments.archiveID#" />	<!---Type:string  --->
		</cfinvoke>
	
		<cfset local.zipFilePath = application.config.archiveDirectory & "/" & local.output.archive.archiveID & ".zip" />
		
		<cfset local.output.currentSHAHash = application.objs.global.getArchiveZipFileHash(local.zipFilePath,local.output.archive.archiveID)/>
		<cfset local.output.manifest = application.objs.global.getZipManifest(local.zipFilePath) />
		
		<cfinvoke component="#application.daos.cascade#" method="getDeploymentsForArchiveID" returnvariable="local.output.deployments">
			<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
			<cfinvokeargument name="archiveID" value="#arguments.archiveID#" />	<!---Type:string  --->
		</cfinvoke>
		
	<cfreturn local.output />
    </cffunction>
	
	<cffunction name="downloadArchive" access="remote" returntype="void" output="true">
    	<cfargument name="serverID" type="string" required="true" />
		<cfargument name="validationCode" type="string" required="True" />
		<cfargument name="serverName" type="string" required="True" />
		<cfargument name="archiveID" type="string" required="true" />
		
		<cfset var local = structNew() />
		<cfset var validationCheck = checkValidationCode(arguments.serverID,arguments.validationCode) />
		
		<cfif NOT validationCheck>
			<cfset throwNotValid() />
		</cfif>
		
    	<cfinvoke component="#application.daos.cascade#" method="getArchiveByArchiveID" returnvariable="local.archive">
			<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
			<cfinvokeargument name="archiveID" value="#arguments.archiveID#" />	<!---Type:string  --->
		</cfinvoke>
	
		<cfif NOT local.archive.recordCount>
			<cfthrow message="Invalid ArchiveID" />
		</cfif>
		
		<cfset local.zipFilePath = application.config.archiveDirectory & "/" & local.archive.archiveID & ".zip" />
		
		<cfif NOT fileExists(local.zipFilePath)>
			<cfthrow message="fileNotFound" />
		</cfif>
		
		<!--- get the sha hash of the file to be downloaded --->
		<cfset local.archiveSHAHash = application.objs.global.getArchiveZipFileHash(local.zipFilePath,arguments.archiveID) />
		
		<cfinvoke component="#application.daos.cascade#" method="insertArchiveLog">
			<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
			<cfinvokeargument name="archiveid" value="#arguments.archiveid#" />	<!---Type:String Hint:  - CHAR (35) --->
			<cfinvokeargument name="archiveshahash" value="#local.archiveSHAHash#" />	<!---Type:String Hint:  - CHAR (40) --->
			<cfinvokeargument name="buildsystemname" value="#local.archive.buildSystemName#" />	<!---Type:String Hint:  - VARCHAR (255) --->
			<cfinvokeargument name="logSystemName" value="#application.config.serverName#" />	<!---Type:String Hint:  - VARCHAR (255) --->
			<cfinvokeargument name="logaction" value="DOWNLOADARCHIVE" />	<!---Type:String Hint:  - VARCHAR (50) --->
			<cfinvokeargument name="deployflag" value="0" />	<!---Type:Numeric Hint:  - INTEGER (10) --->
			<cfinvokeargument name="backupcreatedflag" value="0" />	<!---Type:Numeric Hint:  - INTEGER (10) --->
			<cfinvokeargument name="backuparchiveid" value="" />	<!---Type:String Hint:  - CHAR (35) --->
			<cfinvokeargument name="userid" value="#arguments.serverID#" />	<!---Type:String Hint:  - CHAR (35) --->
			<cfinvokeargument name="logmessage" value="#arguments.archiveID# (#lcase(left(local.archiveSHAHash,application.settings.showFirstXCharsOfSHA))#) downloaded by remote server #arguments.servername#" />	<!---Type:String Hint:  - VARCHAR (1000) --->
			<cfinvokeargument name="logDateTime" value="#now()#" />
		</cfinvoke>
				
		<cfset saveDataToManifest(local.zipFilePath,arguments.archiveID) />
				
		<cfset local.filename = arguments.archiveID & ".zip" />
		
		<cfheader name="Content-Disposition" value="attachment;filename=#local.filename#" />
		<cfcontent file="#local.zipFilePath#" type="application/zip" />
		
    </cffunction>


	<cffunction name="throwNotValid" access="public" returntype="void" output="false" hint="">
    	
    	<cfthrow message="You are not authorized to access this system." />
    	
    </cffunction>

	
	<cffunction name="saveDataToManifest" access="public" returntype="void" output="false" hint="">
		<cfargument name="zipFilePath" type="string" required="True" />
		<cfargument name="archiveID" type="string" required="True" />
		
		<cfset var local = structNew() />
		
		<!--- get the manifest struct --->
		<cfset local.manifest = application.objs.global.getZipManifest(arguments.zipFilePath) />
		
		<!--- get the certifications, deployments and log to append to the manifest --->		
				
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


	

</cfcomponent>