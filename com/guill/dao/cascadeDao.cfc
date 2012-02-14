<cfcomponent>

	<cffunction name="getAllArchives" access="public" returntype="query" output="false" hint="">
    	<cfargument name="dsn" type="string" required="True" />
    	
		<cfset var qGetAllArchives = "" />
		
        <cftry>
        	<cfquery name="qGetAllArchives" datasource="#arguments.dsn#">
        		SELECT
					  archives.archiveid		/*  - CHAR (35)*/
					, archives.archiveshahash	/*  - CHAR (40)*/
					, archives.buildsystemname	/*  - VARCHAR (255)*/
					, archives.applicationname	/*  - VARCHAR (255)*/
					, archives.versionname		/*  - VARCHAR (50)*/
					, archives.projectname		/*  - VARCHAR (255)*/
					, archives.projectnumber		/*  - VARCHAR (50)*/
					, archives.ticketnumber		/*  - VARCHAR (150)*/
					, archives.changereason		/*  - VARCHAR (50)*/
					, archives.author		/*  - VARCHAR (255)*/
					, archives.changedescription	/*  - LONG VARCHAR (32700)*/
					, archives.buildbyuserid		/*  - CHAR (35)*/
					, archives.buildbyusername	/*  - VARCHAR (100)*/
					, archives.buildbyuserfullname	/*  - VARCHAR (100)*/
					, archives.buildbyuseremail	/*  - VARCHAR (255)*/
					, archives.buildon		/*  - TIMESTAMP (26)*/
					, archives.builddir		/*  - VARCHAR (1000)*/
					, archives.deployDirSuggestions		/*  - VARCHAR (5000)*/
					, archives.filecount		/*  - INTEGER (10)*/
					, archives.isnativebuild		/*  - INTEGER (10)*/
					, archives.isbackuparchive	/*  - INTEGER (10)*/
					, archives.isObsolete		/*  - INTEGER (10)*/	
					, archives.backupforarchiveid	/*  - CHAR (35)*/
					
				FROM archives  
				ORDER BY
					archives.buildOn DESC        	
        	</cfquery>
        <cfcatch>
        	<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
        <cfrethrow />
        </cfcatch>
        </cftry>
		
    <cfreturn qGetAllArchives />
    </cffunction>
	
	
	<cffunction name="searchArchives" access="public" returntype="query" output="false" hint="">
    	<cfargument name="dsn" type="string" required="True" />
    	<cfargument name="archiveid" type="String" required="true" hint="pass -1 to ignore." />
		<cfargument name="archiveshahash" type="String" required="true" hint="pass -1 to ignore." />
		<cfargument name="buildsystemname" type="String" required="true" hint="pass -1 to ignore." />
		<cfargument name="applicationname" type="String" required="true" hint="pass -1 to ignore." />
		<cfargument name="versionname" type="String" required="true" hint="pass -1 to ignore." />
		<cfargument name="projectname" type="String" required="true" hint="pass -1 to ignore." />
		<cfargument name="projectnumber" type="String" required="true" hint="pass -1 to ignore." />
		<cfargument name="ticketnumber" type="String" required="true" hint="pass -1 to ignore." />
		<cfargument name="changereason" type="String" required="true" hint="pass -1 to ignore." />
		<cfargument name="author" type="String" required="true" hint="pass -1 to ignore." />
		<cfargument name="changedescription" type="String" required="true" hint="pass -1 to ignore." />
		<cfargument name="buildbyuserid" type="String" required="true" hint="pass -1 to ignore." />
		<cfargument name="buildbyusername" type="String" required="true" hint="pass -1 to ignore." />
		<cfargument name="buildbyuserfullname" type="String" required="true" hint="pass -1 to ignore." />
		<cfargument name="buildbyuseremail" type="String" required="true" hint="pass -1 to ignore." />
		<cfargument name="buildonAfter" type="date" required="true" hint="pass 1970-01-01 to ignore" />
		<cfargument name="buildonBefore" type="date" required="true" hint="pass 1970-01-01 to ignore" />
		<cfargument name="builddir" type="String" required="true" hint="pass -1 to ignore." />
		<cfargument name="deployDirSuggestions" type="String" required="true" hint="pass -1 to ignore." />
		<cfargument name="filecount" type="numeric" required="true" hint="pass -1 to ignore." />
		<cfargument name="isnativebuild" type="numeric" required="true" hint=" pass -1 to ignore." />
		<cfargument name="isbackuparchive" type="numeric" required="true" hint="pass -1 to ignore." />
		<cfargument name="isObsolete" type="numeric" required="true" hint="pass -1 to ignore." />
		<cfargument name="backupForArchiveID" type="string" required="true" hint="pass -1 to ignore" />
		
		<cfset var qSearchArchives = "" />
		
        <cftry>
        	<cfquery name="qSearchArchives" datasource="#arguments.dsn#" result="result">
        		SELECT
					  archives.archiveid		/*  - CHAR (35)*/
					, archives.archiveshahash	/*  - CHAR (40)*/
					, archives.buildsystemname	/*  - VARCHAR (255)*/
					, archives.applicationname	/*  - VARCHAR (255)*/
					, archives.versionname		/*  - VARCHAR (50)*/
					, archives.projectname		/*  - VARCHAR (255)*/
					, archives.projectnumber		/*  - VARCHAR (50)*/
					, archives.ticketnumber		/*  - VARCHAR (150)*/
					, archives.changereason		/*  - VARCHAR (50)*/
					, archives.author		/*  - VARCHAR (255)*/
					, archives.changedescription	/*  - LONG VARCHAR (32700)*/
					, archives.buildbyuserid		/*  - CHAR (35)*/
					, archives.buildbyusername	/*  - VARCHAR (100)*/
					, archives.buildbyuserfullname	/*  - VARCHAR (100)*/
					, archives.buildbyuseremail	/*  - VARCHAR (255)*/
					, archives.buildon		/*  - TIMESTAMP (26)*/
					, archives.builddir		/*  - VARCHAR (1000)*/
					, archives.deployDirSuggestions		/*  - VARCHAR (5000)*/
					, archives.filecount		/*  - INTEGER (10)*/
					, archives.isnativebuild		/*  - INTEGER (10)*/
					, archives.isbackuparchive	/*  - INTEGER (10)*/
					, archives.isObsolete		/*  - INTEGER (10)*/	
					, archives.backupforarchiveid	/*  - CHAR (35)*/
					
				FROM archives  
				WHERE 1 = 1
				<cfif arguments.archiveID NEQ -1>
					AND archiveid LIKE <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.archiveid#" />		/*  - CHAR (35)*/
				</cfif>
				<cfif arguments.archiveshahash NEQ -1>
					AND archiveshahash LIKE <cfqueryparam cfsqltype="cf_sql_char" value="%#arguments.archiveshahash#%" />	/*  - CHAR (40)*/
				</cfif>
				<cfif arguments.buildsystemname NEQ -1>	
					AND buildsystemname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.buildsystemname#%" />	/*  - VARCHAR (255)*/
				</cfif>
				<cfif arguments.applicationname NEQ -1>	
					AND applicationname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.applicationname#%" />	/*  - VARCHAR (255)*/
				</cfif>
				<cfif arguments.versionname NEQ -1>	
					AND versionname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.versionname#%" />		/*  - VARCHAR (50)*/
				</cfif>
				<cfif arguments.projectname NEQ -1>	
					AND projectname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.projectname#%" />		/*  - VARCHAR (255)*/
				</cfif>
				<cfif arguments.projectnumber NEQ -1>	
					AND projectnumber LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.projectnumber#%" />		/*  - VARCHAR (50)*/
				</cfif>
				<cfif arguments.ticketnumber NEQ -1>	
					AND ticketnumber LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.ticketnumber#%" />		/*  - VARCHAR (150)*/
				</cfif>
				<cfif arguments.changereason NEQ -1>	
					AND changereason LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.changereason#%" />		/*  - VARCHAR (50)*/
				</cfif>
				<cfif arguments.author NEQ -1>	
					AND author LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.author#%" />		/*  - VARCHAR (255)*/
				</cfif>
				<cfif arguments.changedescription NEQ -1>	
					AND changedescription LIKE <cfqueryparam cfsqltype="cf_sql_longvarchar" value="%#arguments.changedescription#%" />	/*  - LONG VARCHAR (32700)*/
				</cfif>
				<cfif arguments.buildbyuserid NEQ -1>	
					AND buildbyuserid LIKE <cfqueryparam cfsqltype="cf_sql_char" value="%#arguments.buildbyuserid#%" />		/*  - CHAR (35)*/
				</cfif>
				<cfif arguments.buildbyusername NEQ -1>	
					AND buildbyusername LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.buildbyusername#%" />	/*  - VARCHAR (100)*/
				</cfif>
				<cfif arguments.buildbyuserfullname NEQ -1>	
					AND buildbyuserfullname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.buildbyuserfullname#%" />	/*  - VARCHAR (100)*/
				</cfif>
				<cfif arguments.buildbyuseremail NEQ -1>	
					AND buildbyuseremail LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.buildbyuseremail#%" />	/*  - VARCHAR (255)*/
				</cfif>
				<cfif dateFormat(arguments.buildonafter,"yyyymmdd") NEQ "19700101">	
					AND buildonafter => <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.buildonafter#" />		/*  - TIMESTAMP (26)*/
				</cfif>
				<cfif dateFormat(arguments.buildonbefore,"yyyymmdd") NEQ "19700101">	
					AND buildonbefore <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.buildonbefore#" />		/*  - TIMESTAMP (26)*/
				</cfif>
				<cfif arguments.builddir NEQ -1>	
					AND builddir LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.builddir#%" />		/*  - VARCHAR (1000)*/
				</cfif>
				<cfif arguments.deployDirSuggestions NEQ -1>	
					AND deployDirSuggestions LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.deployDirSuggestions#%" />		/*  - VARCHAR (5000)*/
				</cfif>
				<cfif arguments.filecount NEQ -1>	
					AND filecount = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.filecount#" />		/*  - INTEGER (10)*/
				</cfif>
				<cfif arguments.isnativebuild NEQ -1>	
					AND isnativebuild = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.isnativebuild#" />		/*  - INTEGER (10)*/
				</cfif>
				<cfif arguments.isbackuparchive NEQ -1>	
					AND isbackuparchive = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.isbackuparchive#" />	/*  - INTEGER (10)*/
				</cfif>
				<cfif arguments.isObsolete NEQ -1>	
					AND isObsolete = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.isObsolete#" />	/*  - INTEGER (10)*/
				</cfif>
				<cfif arguments.backupforarchiveid NEQ -1>	
					AND backupforarchiveid LIKE <cfqueryparam cfsqltype="cf_sql_char" value="%#arguments.backupforarchiveid#%" />	/*  - CHAR (35)*/
				</cfif>
				ORDER BY
					archives.buildOn DESC        	
        	</cfquery>
        <cfcatch>
        	<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
        <cfrethrow />
        </cfcatch>
        </cftry>
		
    <cfreturn qSearchArchives />
    </cffunction>
	
	<cffunction name="simpleSearchArchives" access="public" returntype="query" output="false" hint="">
    	<cfargument name="dsn" type="string" required="True" />
    	<cfargument name="applicationname" type="String" required="true" hint="pass -1 to ignore." />
		<cfargument name="projectname" type="String" required="true" hint="pass -1 to ignore." />
		<cfargument name="author" type="String" required="true" hint="pass -1 to ignore." />
		<cfargument name="isbackuparchive" type="numeric" required="true" hint="pass -1 to ignore." />
		<cfargument name="isObsolete" type="numeric" required="true" hint="pass -1 to ignore." />
		<cfargument name="searchString" type="string" required="true" hint="" />
		
		<cfset var qSearchArchives = "" />
		
        <cftry>
        	<cfquery name="qSearchArchives" datasource="#arguments.dsn#" result="result">
        		SELECT
					  archives.archiveid		/*  - CHAR (35)*/
					, archives.archiveshahash	/*  - CHAR (40)*/
					, archives.buildsystemname	/*  - VARCHAR (255)*/
					, archives.applicationname	/*  - VARCHAR (255)*/
					, archives.versionname		/*  - VARCHAR (50)*/
					, archives.projectname		/*  - VARCHAR (255)*/
					, archives.projectnumber		/*  - VARCHAR (50)*/
					, archives.ticketnumber		/*  - VARCHAR (150)*/
					, archives.changereason		/*  - VARCHAR (50)*/
					, archives.author		/*  - VARCHAR (255)*/
					, archives.changedescription	/*  - LONG VARCHAR (32700)*/
					, archives.buildbyuserid		/*  - CHAR (35)*/
					, archives.buildbyusername	/*  - VARCHAR (100)*/
					, archives.buildbyuserfullname	/*  - VARCHAR (100)*/
					, archives.buildbyuseremail	/*  - VARCHAR (255)*/
					, archives.buildon		/*  - TIMESTAMP (26)*/
					, archives.builddir		/*  - VARCHAR (1000)*/
					, archives.deployDirSuggestions		/*  - VARCHAR (5000)*/
					, archives.filecount		/*  - INTEGER (10)*/
					, archives.isnativebuild		/*  - INTEGER (10)*/
					, archives.isbackuparchive	/*  - INTEGER (10)*/
					, archives.isObsolete		/*  - INTEGER (10)*/	
					, archives.backupforarchiveid	/*  - CHAR (35)*/
					
				FROM archives  
				WHERE 1 = 1
			
				<cfif arguments.applicationname NEQ -1>	
					AND applicationname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.applicationname#%" />	/*  - VARCHAR (255)*/
				</cfif>
				<cfif arguments.projectname NEQ -1>	
					AND projectname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.projectname#%" />		/*  - VARCHAR (255)*/
				</cfif>
				
				<cfif arguments.author NEQ -1>	
					AND author LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.author#%" />		/*  - VARCHAR (255)*/
				</cfif>
				<cfif arguments.isbackuparchive NEQ 1>	
					AND isbackuparchive = <cfqueryparam cfsqltype="cf_sql_integer" value="0" />	/*  - INTEGER (10)*/
				</cfif>
				<cfif arguments.isObsolete NEQ 1>	
					AND isObsolete = <cfqueryparam cfsqltype="cf_sql_integer" value="0" />	/*  - INTEGER (10)*/
				</cfif>
				
				
				<cfif len(trim(arguments.searchString))>
					AND
						(
							 archiveid LIKE <cfqueryparam cfsqltype="cf_sql_char" value="%#arguments.searchString#%" />		/*  - CHAR (35)*/
							OR archiveshahash LIKE <cfqueryparam cfsqltype="cf_sql_char" value="%#arguments.searchString#%" />	/*  - CHAR (40)*/
							OR backupforarchiveid LIKE <cfqueryparam cfsqltype="cf_sql_char" value="%#arguments.searchString#%" />	/*  - CHAR (35)*/
							OR deployDirSuggestions LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchString#%" />		/*  - VARCHAR (5000)*/
							OR changedescription LIKE <cfqueryparam cfsqltype="cf_sql_longvarchar" value="%#arguments.searchString#%" />	/*  - LONG VARCHAR (32700)*/
							OR changereason LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchString#%" />		/*  - VARCHAR (50)*/
							OR versionname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchString#%" />		/*  - VARCHAR (50)*/
							OR projectnumber LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchString#%" />		/*  - VARCHAR (50)*/
							OR ticketnumber LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchString#%" />		/*  - VARCHAR (150)*/
							OR applicationname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchString#%" />	/*  - VARCHAR (255)*/
							OR projectname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchString#%" />		/*  - VARCHAR (255)*/
						)
				</cfif>
				
				ORDER BY
					archives.buildOn DESC        	
        	</cfquery>
        <cfcatch>
        	<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
        <cfrethrow />
        </cfcatch>
        </cftry>
		
    <cfreturn qSearchArchives />
    </cffunction>
	
	
	<cffunction name="getArchiveByArchiveID" access="public" returntype="query" output="false" hint="">
    	<cfargument name="dsn" type="string" required="True" />
		<cfargument name="archiveID" type="string" required="True" />
    	
		<cfset var qGetArchiveByArchiveID = "" />
		
        <cftry>
        	<cfquery name="qGetArchiveByArchiveID" datasource="#arguments.dsn#">
        		SELECT
					  archives.archiveid		/*  - CHAR (35)*/
					, archives.archiveshahash	/*  - CHAR (40)*/
					, archives.buildsystemname	/*  - VARCHAR (255)*/
					, archives.applicationname	/*  - VARCHAR (255)*/
					, archives.versionname		/*  - VARCHAR (50)*/
					, archives.projectname		/*  - VARCHAR (255)*/
					, archives.projectnumber		/*  - VARCHAR (50)*/
					, archives.ticketnumber		/*  - VARCHAR (150)*/
					, archives.changereason		/*  - VARCHAR (50)*/
					, archives.author		/*  - VARCHAR (255)*/
					, archives.changedescription	/*  - LONG VARCHAR (32700)*/
					, archives.buildbyuserid		/*  - CHAR (35)*/
					, archives.buildbyusername	/*  - VARCHAR (100)*/
					, archives.buildbyuserfullname	/*  - VARCHAR (100)*/
					, archives.buildbyuseremail	/*  - VARCHAR (255)*/
					, archives.buildon		/*  - TIMESTAMP (26)*/
					, archives.builddir		/*  - VARCHAR (1000)*/
					, archives.deployDirSuggestions		/*  - VARCHAR (5000)*/
					, archives.filecount		/*  - INTEGER (10)*/
					, archives.isnativebuild		/*  - INTEGER (10)*/
					, archives.isbackuparchive	/*  - INTEGER (10)*/
					, archives.isObsolete		/*  - INTEGER (10)*/	
					, archives.backupforarchiveid	/*  - CHAR (35)*/
					
				FROM archives 
				WHERE
					archives.archiveID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.archiveID#" /> 
				ORDER BY
					archives.buildOn DESC        	
        	</cfquery>
        <cfcatch>
        	<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
        <cfrethrow />
        </cfcatch>
        </cftry>
		
    <cfreturn qGetArchiveByArchiveID />
    </cffunction>
	
	<cffunction name="getArchiveByArchiveSHAHash" access="public" returntype="query" output="false" hint="">
    	<cfargument name="dsn" type="string" required="True" />
		<cfargument name="archiveSHAHash" type="string" required="True" />
    	
		<cfset var qGetArchiveByArchiveSHAHash = "" />
		
        <cftry>
        	<cfquery name="qGetArchiveByArchiveSHAHash" datasource="#arguments.dsn#">
        		SELECT
					  archives.archiveid		/*  - CHAR (35)*/
					, archives.archiveshahash	/*  - CHAR (40)*/
					, archives.buildsystemname	/*  - VARCHAR (255)*/
					, archives.applicationname	/*  - VARCHAR (255)*/
					, archives.versionname		/*  - VARCHAR (50)*/
					, archives.projectname		/*  - VARCHAR (255)*/
					, archives.projectnumber		/*  - VARCHAR (50)*/
					, archives.ticketnumber		/*  - VARCHAR (150)*/
					, archives.changereason		/*  - VARCHAR (50)*/
					, archives.author		/*  - VARCHAR (255)*/
					, archives.changedescription	/*  - LONG VARCHAR (32700)*/
					, archives.buildbyuserid		/*  - CHAR (35)*/
					, archives.buildbyusername	/*  - VARCHAR (100)*/
					, archives.buildbyuserfullname	/*  - VARCHAR (100)*/
					, archives.buildbyuseremail	/*  - VARCHAR (255)*/
					, archives.buildon		/*  - TIMESTAMP (26)*/
					, archives.builddir		/*  - VARCHAR (1000)*/
					, archives.deployDirSuggestions		/*  - VARCHAR (5000)*/
					, archives.filecount		/*  - INTEGER (10)*/
					, archives.isnativebuild		/*  - INTEGER (10)*/
					, archives.isbackuparchive	/*  - INTEGER (10)*/
					, archives.isObsolete		/*  - INTEGER (10)*/	
					, archives.backupforarchiveid	/*  - CHAR (35)*/
					
				FROM archives 
				WHERE
					archives.archiveSHAHash = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.archiveSHAHash#" /> 
				ORDER BY
					archives.buildOn DESC        	
        	</cfquery>
        <cfcatch>
        	<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
        <cfrethrow />
        </cfcatch>
        </cftry>
		
    <cfreturn qGetArchiveByArchiveSHAHash />
    </cffunction>
	
	<cffunction name="createArchive" access="public" returntype="string" output="false" hint="">
    	<cfargument name="dsn" type="string" required="True" />
		<cfargument name="archiveID" type="String" required="true" hint=" - CHAR (35)" />
		<cfargument name="archiveshahash" type="String" required="true" hint=" - CHAR (40)" />
		<cfargument name="buildsystemname" type="String" required="true" hint=" - VARCHAR (255)" />
		<cfargument name="applicationname" type="String" required="true" hint=" - VARCHAR (255)" />
		<cfargument name="versionname" type="String" required="true" hint=" - VARCHAR (50)" />
		<cfargument name="projectname" type="String" required="true" hint=" - VARCHAR (255)" />
		<cfargument name="projectnumber" type="String" required="true" hint=" - VARCHAR (50)" />
		<cfargument name="ticketnumber" type="String" required="true" hint=" - VARCHAR (150)" />
		<cfargument name="changereason" type="String" required="true" hint=" - VARCHAR (50)" />
		<cfargument name="author" type="String" required="true" hint=" - VARCHAR (255)" />
		<cfargument name="changedescription" type="String" required="true" hint=" - LONG VARCHAR (32700)" />
		<cfargument name="buildbyuserid" type="String" required="true" hint=" - CHAR (35)" />
		<cfargument name="buildbyusername" type="String" required="true" hint=" - VARCHAR (100)" />
		<cfargument name="buildbyuserfullname" type="String" required="true" hint=" - VARCHAR (100)" />
		<cfargument name="buildbyuseremail" type="String" required="true" hint=" - VARCHAR (255)" />
		<cfargument name="builddir" type="String" required="true" hint=" - VARCHAR (1000)" />
		<cfargument name="deployDirSuggestions" type="String" required="true" hint=" - VARCHAR (5000)" />
		<cfargument name="filecount" type="Numeric" required="true" hint=" - INTEGER (10)" />
		<cfargument name="isnativebuild" type="Numeric" required="true" hint=" - INTEGER (10)" />
		<cfargument name="isbackuparchive" type="Numeric" required="true" hint=" - INTEGER (10)" />
		<cfargument name="isObsolete" type="Numeric" required="true" hint=" - INTEGER (10)" />
		<cfargument name="backupforarchiveid" type="String" required="true" hint=" - CHAR (35)" />

		<cfset var qCreateArchive = "" />
		
        <cftry>
        	<cfquery name="qCreateArchive" datasource="#arguments.dsn#">
        		INSERT INTO archives
				(
					  archiveid		/*  - CHAR (35)*/
					, archiveshahash	/*  - CHAR (40)*/
					, buildsystemname	/*  - VARCHAR (255)*/
					, applicationname	/*  - VARCHAR (255)*/
					, versionname		/*  - VARCHAR (50)*/
					, projectname		/*  - VARCHAR (255)*/
					, projectnumber		/*  - VARCHAR (50)*/
					, ticketnumber		/*  - VARCHAR (150)*/
					, changereason		/*  - VARCHAR (50)*/
					, author		/*  - VARCHAR (255)*/
					, changedescription	/*  - LONG VARCHAR (32700)*/
					, buildbyuserid		/*  - CHAR (35)*/
					, buildbyusername	/*  - VARCHAR (100)*/
					, buildbyuserfullname	/*  - VARCHAR (100)*/
					, buildbyuseremail	/*  - VARCHAR (255)*/
					, buildon		/*  - TIMESTAMP (26)*/
					, builddir		/*  - VARCHAR (1000)*/
					, deployDirSuggestions		/*  - VARCHAR (5000)*/
					, filecount		/*  - INTEGER (10)*/
					, isnativebuild		/*  - INTEGER (10)*/
					, isbackuparchive	/*  - INTEGER (10)*/
					, isObsolete		/*  - INTEGER (10)*/	
					, backupforarchiveid	/*  - CHAR (35)*/		
				)
				VALUES
				(
					  <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.archiveid#" /> /* archiveid */
					, <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.archiveshahash#" /> /* archiveshahash */
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.buildsystemname#" /> /* buildsystemname */
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.applicationname#" /> /* applicationname */
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.versionname#" /> /* versionname */
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.projectname#" /> /* projectname */
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.projectnumber#" /> /* projectnumber */
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ticketnumber#" /> /* ticketnumber */
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.changereason#" /> /* changereason */
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.author#" /> /* author */
					, <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.changedescription#" /> /* changedescription */
					, <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.buildbyuserid#" /> /* buildbyuserid */
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.buildbyusername#" /> /* buildbyusername */
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.buildbyuserfullname#" /> /* buildbyuserfullname */
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.buildbyuseremail#" /> /* buildbyuseremail */
					, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#" /> /* buildon */
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.builddir#" /> /* builddir */
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.deployDirSuggestions#" /> /* deployDirSuggestions */
					, <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.filecount#" /> /* filecount */
					, <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.isnativebuild#" /> /* isnativebuild */
					, <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.isbackuparchive#" /> /* isbackuparchive */
					, <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.isObsolete#" /> /* isObsolete */
					, <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.backupforarchiveid#" /> /* backupforarchiveid */					
				)
        	</cfquery>
        <cfcatch>
        	<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
        <cfrethrow />
        </cfcatch>
        </cftry>

	<cfreturn archiveID />	
    </cffunction>
	
	<cffunction name="deleteArchive" access="public" returntype="boolean" output="false" hint="">
    	<cfargument name="dsn" type="string" required="True" />
    	<cfargument name="archiveID" type="string" required="true" />
		
		<cfset var qDeleteArchive = "" />
        <cftry>
        	<cfquery name="qDeleteArchive" datasource="#arguments.dsn#">
        		DELETE
				FROM archives
				WHERE
					archiveid = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.archiveid#" />		/*  - CHAR (35)*/
        	</cfquery>
        <cfcatch>
        	<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
        <cfrethrow />
        </cfcatch>
        </cftry>

    <cfreturn True />
    </cffunction>
	
	<cffunction name="setArchiveIsObsolete" access="public" returntype="boolean" output="false" hint="">
    	<cfargument name="dsn" type="string" required="True" />
    	<cfargument name="archiveID" type="string" required="true" />
    	<cfargument name="isObsolete" type="boolean" required="true" />
		
		<cfset var qMarkAsObsolete = "" />
        <cftry>
        	<cfquery name="qDeleteArchive" datasource="#arguments.dsn#">
        		UPDATE archives
				SET isObsolete = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.isObsolete#" />
				WHERE
					archiveid = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.archiveid#" />		/*  - CHAR (35)*/
        	</cfquery>
        <cfcatch>
        	<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
        <cfrethrow />
        </cfcatch>
        </cftry>

    <cfreturn True />
    </cffunction>


	<!--- I dont think we will need this actually, I dont think there will ever be a reason to update an archive -
	if you need to update any of this information you need to rebuild the archive --->
	
	<!---
	<cffunction name="updateArchive" access="public" returntype="boolean" output="false" hint="">
    	<cfargument name="dsn" type="string" required="True" />
    	<cfargument name="archiveid" type="String" required="true" hint=" - CHAR (35)" />
		<cfargument name="archiveshahash" type="String" required="true" hint=" - CHAR (40)" />
		<cfargument name="buildsystemname" type="String" required="true" hint=" - VARCHAR (255)" />
		<cfargument name="applicationname" type="String" required="true" hint=" - VARCHAR (255)" />
		<cfargument name="versionname" type="String" required="true" hint=" - VARCHAR (50)" />
		<cfargument name="projectname" type="String" required="true" hint=" - VARCHAR (255)" />
		<cfargument name="projectnumber" type="String" required="true" hint=" - VARCHAR (50)" />
		<cfargument name="ticketnumber" type="String" required="true" hint=" - VARCHAR (150)" />
		<cfargument name="changereason" type="String" required="true" hint=" - VARCHAR (50)" />
		<cfargument name="author" type="String" required="true" hint=" - VARCHAR (255)" />
		<cfargument name="changedescription" type="String" required="true" hint=" - LONG VARCHAR (32700)" />
		<cfargument name="buildbyuserid" type="String" required="true" hint=" - CHAR (35)" />
		<cfargument name="buildbyusername" type="String" required="true" hint=" - VARCHAR (100)" />
		<cfargument name="buildbyuserfullname" type="String" required="true" hint=" - VARCHAR (100)" />
		<cfargument name="buildbyuseremail" type="String" required="true" hint=" - VARCHAR (255)" />
		<cfargument name="buildon" type="date" required="true" hint=" - TIMESTAMP (26)" />
		<cfargument name="builddir" type="String" required="true" hint=" - VARCHAR (1000)" />
		<cfargument name="filecount" type="Numeric" required="true" hint=" - INTEGER (10)" />
		<cfargument name="isnativebuild" type="Numeric" required="true" hint=" - INTEGER (10)" />
		<cfargument name="isbackuparchive" type="Numeric" required="true" hint=" - INTEGER (10)" />
		<cfargument name="backupforarchiveid" type="String" required="true" hint=" - CHAR (35)" />

		<cfset var qUpdateArchive = "" />
		
        <cftry>
        	<cfquery name="qUpdateArchive" datasource="#arguments.dsn#">
        		UPDATE archives
				SET
					  archiveshahash = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.archiveshahash#" />	/*  - CHAR (40)*/
					, buildsystemname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.buildsystemname#" />	/*  - VARCHAR (255)*/
					, applicationname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.applicationname#" />	/*  - VARCHAR (255)*/
					, versionname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.versionname#" />		/*  - VARCHAR (50)*/
					, projectname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.projectname#" />		/*  - VARCHAR (255)*/
					, projectnumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.projectnumber#" />		/*  - VARCHAR (50)*/
					, ticketnumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ticketnumber#" />		/*  - VARCHAR (150)*/
					, changereason = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.changereason#" />		/*  - VARCHAR (50)*/
					, author = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.author#" />		/*  - VARCHAR (255)*/
					, changedescription = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.changedescription#" />	/*  - LONG VARCHAR (32700)*/
					, builddir = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.builddir#" />		/*  - VARCHAR (1000)*/
					, filecount = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.filecount#" />		/*  - INTEGER (10)*/
					, isnativebuild = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.isnativebuild#" />		/*  - INTEGER (10)*/
					, isbackuparchive = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.isbackuparchive#" />	/*  - INTEGER (10)*/
					, backupforarchiveid = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.backupforarchiveid#" />	/*  - CHAR (35)*/
				WHERE
					archiveid = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.archiveid#" />		/*  - CHAR (35)*/
        	
        	</cfquery>
        <cfcatch>
        	<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
        <cfrethrow />
        </cfcatch>
        </cftry>		
		
    <cfreturn true />	
    </cffunction>
	--->
	
	<cffunction name="getFilesForArchiveID" access="public" returntype="query" output="false" hint="">
    	<cfargument name="dsn" type="string" required="True" />
    	<cfargument name="archiveid" type="String" required="true" hint=" - CHAR (35)" />
		
		<cfset var qGetFilesForArchiveID = "" />
		
        <cftry>
        	<cfquery name="qGetFilesForArchiveID" datasource="#arguments.dsn#">
        		SELECT
					  archivefiles.fileid	/*  - CHAR (35)*/
					, archivefiles.archiveid	/*  - CHAR (35)*/
					, archivefiles.fileshahash	/*  - CHAR (40)*/
					, archivefiles.filepath	/*  - VARCHAR (255)*/
					
				FROM archivefiles
				WHERE
					 archiveFiles.archiveid = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.archiveid#" />	/*  - CHAR (35)*/    	
        	</cfquery>
        <cfcatch>
        	<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
        <cfrethrow />
        </cfcatch>
        </cftry>

    <cfreturn qGetFilesForArchiveID />	
    </cffunction>
	
	
	<cffunction name="getFileForFileID" access="public" returntype="query" output="false" hint="">
    	<cfargument name="dsn" type="string" required="True" />
    	<cfargument name="fileID" type="String" required="true" hint=" - CHAR (35)" />
		
		<cfset var qGetFileForFileID = "" />
		
        <cftry>
        	<cfquery name="qGetFileForFileID" datasource="#arguments.dsn#">
        		SELECT
					  archivefiles.fileid	/*  - CHAR (35)*/
					, archivefiles.archiveid	/*  - CHAR (35)*/
					, archivefiles.fileshahash	/*  - CHAR (40)*/
					, archivefiles.filepath	/*  - VARCHAR (255)*/
					
				FROM archivefiles
				WHERE
					 archiveFiles.fileid = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.fileid#" />	/*  - CHAR (35)*/    	
        	</cfquery>
        <cfcatch>
        	<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
        <cfrethrow />
        </cfcatch>
        </cftry>

    <cfreturn qGetFileForFileID />	
    </cffunction>
	
	
	<cffunction name="getFileForFileSHAHash" access="public" returntype="query" output="false" hint="">
    	<cfargument name="dsn" type="string" required="True" />
    	<cfargument name="fileSHAHash" type="String" required="true" hint=" - CHAR (35)" />
		
		<cfset var qGetFileForFileSHAHash = "" />
		
        <cftry>
        	<cfquery name="qGetFileForFileSHAHash" datasource="#arguments.dsn#">
        		SELECT
					  archivefiles.fileid	/*  - CHAR (35)*/
					, archivefiles.archiveid	/*  - CHAR (35)*/
					, archivefiles.fileshahash	/*  - CHAR (40)*/
					, archivefiles.filepath	/*  - VARCHAR (255)*/
					
				FROM archivefiles
				WHERE
					 archiveFiles.fileshahash = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.fileshahash#" />	/*  - CHAR (35)*/    	
        	</cfquery>
        <cfcatch>
        	<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
        <cfrethrow />
        </cfcatch>
        </cftry>

    <cfreturn qGetFileForFileSHAHash />	
    </cffunction>
	
	<cffunction name="insertArchiveFile" access="public" returntype="string" output="false" hint="">
    	<cfargument name="dsn" type="string" required="True" />
    	<cfargument name="archiveid" type="String" required="true" hint=" - CHAR (35)" />
		<cfargument name="fileshahash" type="String" required="true" hint=" - CHAR (40)" />
		<cfargument name="filepath" type="String" required="true" hint=" - VARCHAR (255)" />

		<cfset var fileID = createUUID() />
		<cfset var qInsertArchiveFile = "" />
		
        <cftry>
        	<cfquery name="qInsertArchiveFile" datasource="#arguments.dsn#">
        		INSERT INTO archivefiles
				(
					  fileid	/*  - CHAR (35)*/
					, archiveid	/*  - CHAR (35)*/
					, fileshahash	/*  - CHAR (40)*/
					, filepath	/*  - VARCHAR (255)*/
					
				)
				VALUES
				(
					  <cfqueryparam cfsqltype="cf_sql_char" value="#fileid#" /> /* fileid */
					, <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.archiveid#" /> /* archiveid */
					, <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.fileshahash#" /> /* fileshahash */
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filepath#" /> /* filepath */
					
				)
        	</cfquery>
        <cfcatch>
        	<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
        <cfrethrow />
        </cfcatch>
        </cftry>

	<cfreturn fileID />	
    </cffunction>
	
	<cffunction name="getDeploymentsForArchiveID" access="public" returntype="query" output="false" hint="">
    	<cfargument name="dsn" type="string" required="True" />
    	<cfargument name="archiveID" type="string" required="True" />
		
		<cfset var qGetDeploymentsForArchiveID = "" />
		
        <cftry>
        	<cfquery name="qGetDeploymentsForArchiveID" datasource="#arguments.dsn#">
        		SELECT
					  archivedeployments.deploymentid			/*  - CHAR (35)*/
					, archivedeployments.archiveid			/*  - CHAR (35)*/
					, archivedeployments.archiveshahash		/*  - CHAR (40)*/
					, archivedeployments.buildsystemname		/*  - VARCHAR (255)*/
					, archiveDeployments.deployedSystemName		/*  - VARCHAR (255)*/
					, archivedeployments.deployedbyuserid		/*  - CHAR (35)*/
					, archivedeployments.deployedbyusername		/*  - VARCHAR (100)*/
					, archivedeployments.deployedbyuserfullname	/*  - VARCHAR (100)*/
					, archivedeployments.deployedbyuseremail		/*  - VARCHAR (255)*/
					, archivedeployments.deployedon			/*  - TIMESTAMP (26)*/
					, archivedeployments.deploymentdir			/*  - VARCHAR (1000)*/
					, archivedeployments.deploymentNotes		/* - long varchar */
					, archivedeployments.wasbackuptaken		/*  - INTEGER (10)*/
					, archivedeployments.backupArchiveID		/*  - CHAR (35)*/
					
				FROM archivedeployments 
				WHERE
					archiveDeployments.archiveid = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.archiveid#" />			/*  - CHAR (35)*/
        		ORDER BY
					archiveDeployments.deployedOn DESC
        	</cfquery>
        <cfcatch>
        	<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
        <cfrethrow />
        </cfcatch>
        </cftry>

	<cfreturn qGetDeploymentsForArchiveID />    	
    </cffunction>
	
	<cffunction name="getDeploymentsForDeploymentID" access="public" returntype="query" output="false" hint="">
    	<cfargument name="dsn" type="string" required="True" />
    	<cfargument name="deploymentid" type="string" required="True" />
		
		<cfset var qGetDeploymentsForDeploymentID = "" />
		
        <cftry>
        	<cfquery name="qGetDeploymentsForDeploymentID" datasource="#arguments.dsn#">
        		SELECT
					  archivedeployments.deploymentid			/*  - CHAR (35)*/
					, archivedeployments.archiveid			/*  - CHAR (35)*/
					, archivedeployments.archiveshahash		/*  - CHAR (40)*/
					, archivedeployments.buildsystemname		/*  - VARCHAR (255)*/
					, archiveDeployments.deployedSystemName		/*  - VARCHAR (255)*/
					, archivedeployments.deployedbyuserid		/*  - CHAR (35)*/
					, archivedeployments.deployedbyusername		/*  - VARCHAR (100)*/
					, archivedeployments.deployedbyuserfullname	/*  - VARCHAR (100)*/
					, archivedeployments.deployedbyuseremail		/*  - VARCHAR (255)*/
					, archivedeployments.deployedon			/*  - TIMESTAMP (26)*/
					, archivedeployments.deploymentdir			/*  - VARCHAR (1000)*/
					, archivedeployments.deploymentNotes		/* - long varchar */
					, archivedeployments.wasbackuptaken		/*  - INTEGER (10)*/
					, archivedeployments.backupArchiveID		/*  - CHAR (35)*/
					
				FROM archivedeployments 
				WHERE
					archiveDeployments.deploymentid = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.deploymentid#" />			/*  - CHAR (35)*/
        		ORDER BY
					archiveDeployments.deployedOn DESC
        	</cfquery>
        <cfcatch>
        	<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
        <cfrethrow />
        </cfcatch>
        </cftry>

	<cfreturn qGetDeploymentsForDeploymentID />    	
    </cffunction>
	
	
	<cffunction name="getAllDeployments" access="public" returntype="query" output="false" hint="">
    	<cfargument name="dsn" type="string" required="True" />
		
		<cfset var qGetAllDeployments = "" />
		
        <cftry>
        	<cfquery name="qGetAllDeployments" datasource="#arguments.dsn#">
        		SELECT
					  archivedeployments.deploymentid			/*  - CHAR (35)*/
					, archivedeployments.archiveid			/*  - CHAR (35)*/
					, archivedeployments.archiveshahash		/*  - CHAR (40)*/
					, archivedeployments.buildsystemname		/*  - VARCHAR (255)*/
					, archiveDeployments.deployedSystemName		/*  - VARCHAR (255)*/
					, archivedeployments.deployedbyuserid		/*  - CHAR (35)*/
					, archivedeployments.deployedbyusername		/*  - VARCHAR (100)*/
					, archivedeployments.deployedbyuserfullname	/*  - VARCHAR (100)*/
					, archivedeployments.deployedbyuseremail		/*  - VARCHAR (255)*/
					, archivedeployments.deployedon			/*  - TIMESTAMP (26)*/
					, archivedeployments.deploymentdir			/*  - VARCHAR (1000)*/
					, archivedeployments.deploymentNotes		/* - long varchar */
					, archivedeployments.wasbackuptaken		/*  - INTEGER (10)*/
					, archivedeployments.backupArchiveID		/*  - CHAR (35)*/
					
				FROM archivedeployments 
        		ORDER BY
					archiveDeployments.deployedOn DESC
        	</cfquery>
        <cfcatch>
        	<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
        <cfrethrow />
        </cfcatch>
        </cftry>

	<cfreturn qGetAllDeployments />    	
    </cffunction>
	
	<cffunction name="createDeployment" access="public" returntype="string" output="false" hint="">
    	<cfargument name="dsn" type="string" required="True" />
		<cfargument name="deploymentID" type="string" required="True" />
    	<cfargument name="archiveid" type="String" required="true" hint=" - CHAR (35)" />
		<cfargument name="archiveshahash" type="String" required="true" hint=" - CHAR (40)" />
		<cfargument name="buildsystemname" type="String" required="true" hint=" - VARCHAR (255)" />
		<cfargument name="deployedSystemname" type="String" required="true" hint=" - VARCHAR (255)" />
		<cfargument name="deployedbyuserid" type="String" required="true" hint=" - CHAR (35)" />
		<cfargument name="deployedbyusername" type="String" required="true" hint=" - VARCHAR (100)" />
		<cfargument name="deployedbyuserfullname" type="String" required="true" hint=" - VARCHAR (100)" />
		<cfargument name="deployedbyuseremail" type="String" required="true" hint=" - VARCHAR (255)" />
		<cfargument name="deployedon" type="date" required="true" hint=" - TIMESTAMP (26)" />
		<cfargument name="deploymentdir" type="String" required="true" hint=" - VARCHAR (1000)" />
		<cfargument name="deploymentNotes" type="String" required="true" hint=" - LONG VARCHAR" />
		<cfargument name="wasbackuptaken" type="Numeric" required="true" hint=" - INTEGER (10)" />
		<cfargument name="backupArchiveID" type="String" required="true" hint=" - CHAR (35)" />

		<cfset var qCreateDeployment = "" />
		
        <cftry>
        	<cfquery name="qCreateDeployment" datasource="#arguments.dsn#">
        		INSERT INTO archivedeployments
				(
					  deploymentid			/*  - CHAR (35)*/
					, archiveid			/*  - CHAR (35)*/
					, archiveshahash		/*  - CHAR (40)*/
					, buildsystemname		/*  - VARCHAR (255)*/
					, deployedSystemname		/*  - VARCHAR (255)*/
					, deployedbyuserid		/*  - CHAR (35)*/
					, deployedbyusername		/*  - VARCHAR (100)*/
					, deployedbyuserfullname	/*  - VARCHAR (100)*/
					, deployedbyuseremail		/*  - VARCHAR (255)*/
					, deployedon			/*  - TIMESTAMP (26)*/
					, deploymentdir			/*  - VARCHAR (1000)*/
					, deploymentnotes			/*  - long varchar*/
					, wasbackuptaken		/*  - INTEGER (10)*/
					, backupArchiveID		/*  - CHAR (35)*/					
				)
				VALUES
				(
					  <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.deploymentID#" /> /* deploymentid */
					, <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.archiveid#" /> /* archiveid */
					, <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.archiveshahash#" /> /* archiveshahash */
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.buildsystemname#" /> /* buildsystemname */
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.deployedSystemname#" /> /* deployedsystemname */
					, <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.deployedbyuserid#" /> /* deployedbyuserid */
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.deployedbyusername#" /> /* deployedbyusername */
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.deployedbyuserfullname#" /> /* deployedbyuserfullname */
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.deployedbyuseremail#" /> /* deployedbyuseremail */
					, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.deployedon#" /> /* deployedon */
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.deploymentdir#" /> /* deploymentdir */
					, <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.deploymentnotes#" /> /* deploymentdir */
					, <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.wasbackuptaken#" /> /* wasbackuptaken */
					, <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.backupArchiveID#" /> /* backupArchiveID */					
				)        	
        	</cfquery>
        <cfcatch>
        	<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
        <cfrethrow />
        </cfcatch>
        </cftry>

	<cfreturn arguments.deploymentID />    	
    </cffunction>
	
	<cffunction name="insertDeploymentFileManifest" access="public" returntype="string" output="false" hint="">
    	<cfargument name="dsn" type="string" required="True" />
		<cfargument name="deploymentid" type="String" required="true" hint=" - CHAR (35)" />
		<cfargument name="archiveid" type="String" required="true" hint=" - CHAR (35)" />
		<cfargument name="deployedsystemname" type="String" required="true" hint=" - VARCHAR (255)" />
		<cfargument name="archivefileid" type="String" required="true" hint=" - CHAR (35)" />
		<cfargument name="deployedfilepath" type="String" required="true" hint=" - VARCHAR (255)" />
		<cfargument name="backupArchiveID" type="String" required="true" hint=" - CHAR (35)" />
		<cfargument name="backupArchiveFileID" type="String" required="true" hint=" - CHAR (35)" />
		<cfargument name="previousfileshahash" type="String" required="true" hint=" - CHAR (40)" />
    	<cfargument name="deploymentFileManifestID" type="string" required="false" default="#createUUID()#" />

		<cfset var qInsertDeploymentFileManifest = "" />
		
        <cftry>
        	<cfquery name="qInsertDeploymentFileManifest" datasource="#arguments.dsn#">
        		INSERT INTO deploymentfilesmanifest
				(
					  deploymentfilemanifestid	/*  - CHAR (35)*/
					, deploymentid			/*  - CHAR (35)*/
					, archiveid			/*  - CHAR (35)*/
					, deployedsystemname		/*  - VARCHAR (255)*/
					, archivefileid			/*  - CHAR (35)*/
					, deployedfilepath		/*  - VARCHAR (255)*/
					, backuparchiveid		/*  - CHAR (35)*/
					, backuparchivefileid		/*  - CHAR (35)*/
					, previousfileshahash		/*  - CHAR (40)*/
					
				)
				VALUES
				(
					  <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.deploymentfilemanifestid#" /> /* deploymentfilemanifestid */
					, <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.deploymentid#" /> /* deploymentid */
					, <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.archiveid#" /> /* archiveid */
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.deployedsystemname#" /> /* deployedsystemname */
					, <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.archivefileid#" /> /* archivefileid */
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.deployedfilepath#" /> /* deployedfilepath */
					, <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.backuparchiveid#" /> /* backuparchiveid */
					, <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.backuparchivefileid#" /> /* backuparchivefileid */
					, <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.previousfileshahash#" /> /* previousfileshahash */
					
				)
  	
        	</cfquery>
        <cfcatch>
        	<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
        <cfrethrow />
        </cfcatch>
        </cftry>

	<cfreturn arguments.deploymentfilemanifestid />    	
    </cffunction>

	<cffunction name="getDeploymentFilesManifestForDeploymentID" access="public" returntype="query" output="false" hint="">
    	<cfargument name="dsn" type="string" required="True" />
    	<cfargument name="deploymentID" type="string" required="true" />
		
		<cfset var qGetDeploymentFilesManifestForDeploymentID = "" />
        <cftry>
        	<cfquery name="qGetDeploymentFilesManifestForDeploymentID" datasource="#arguments.dsn#">
        		SELECT
					  deploymentfilesmanifest.deploymentfilemanifestid	/*  - CHAR (35)*/
					, deploymentfilesmanifest.deploymentid			/*  - CHAR (35)*/
					, deploymentfilesmanifest.archiveid			/*  - CHAR (35)*/
					, deploymentfilesmanifest.deployedsystemname		/*  - VARCHAR (255)*/
					, deploymentfilesmanifest.archivefileid			/*  - CHAR (35)*/
					, deploymentfilesmanifest.deployedfilepath		/*  - VARCHAR (255)*/
					, deploymentfilesmanifest.backuparchiveid		/*  - CHAR (35)*/
					, deploymentfilesmanifest.backuparchivefileid		/*  - CHAR (35)*/
					, deploymentfilesmanifest.previousfileshahash		/*  - CHAR (40)*/
					
					, archivefiles.archiveid	/*  - CHAR (35)*/
					, archivefiles.fileshahash	/*  - CHAR (40)*/
					, archivefiles.filepath	/*  - VARCHAR (255)*/
					
				FROM deploymentfilesmanifest
				INNER
					JOIN archiveFiles
					ON deploymentFilesManifest.archiveFileID = archiveFiles.fileID
				WHERE
					deploymentfilesmanifest.deploymentid = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.deploymentid#" /> /* deploymentid */
        	
        	</cfquery>
        <cfcatch>
        	<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
        <cfrethrow />
        </cfcatch>
        </cftry>

   	<cfreturn qGetDeploymentFilesManifestForDeploymentID />
    </cffunction>	

	<cffunction name="getDeploymentFilesManifestForArchiveID" access="public" returntype="query" output="false" hint="">
    	<cfargument name="dsn" type="string" required="True" />
    	<cfargument name="archiveID" type="string" required="true" />
		
		<cfset var qGetDeploymentFilesManifestForArchiveID = "" />
        <cftry>
        	<cfquery name="qGetDeploymentFilesManifestForArchiveID" datasource="#arguments.dsn#">
        		SELECT
					  deploymentfilesmanifest.deploymentfilemanifestid	/*  - CHAR (35)*/
					, deploymentfilesmanifest.deploymentid			/*  - CHAR (35)*/
					, deploymentfilesmanifest.archiveid			/*  - CHAR (35)*/
					, deploymentfilesmanifest.deployedsystemname		/*  - VARCHAR (255)*/
					, deploymentfilesmanifest.archivefileid			/*  - CHAR (35)*/
					, deploymentfilesmanifest.deployedfilepath		/*  - VARCHAR (255)*/
					, deploymentfilesmanifest.backuparchiveid		/*  - CHAR (35)*/
					, deploymentfilesmanifest.backuparchivefileid		/*  - CHAR (35)*/
					, deploymentfilesmanifest.previousfileshahash		/*  - CHAR (40)*/

					, archivefiles.archiveid	/*  - CHAR (35)*/
					, archivefiles.fileshahash	/*  - CHAR (40)*/
					, archivefiles.filepath	/*  - VARCHAR (255)*/
					
				FROM deploymentfilesmanifest
				INNER
					JOIN archiveFiles
					ON deploymentFilesManifest.archiveFileID = archiveFiles.fileID
				WHERE
					deploymentfilesmanifest.archiveID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.archiveID#" /> /* archiveID */
        	
        	</cfquery>
        <cfcatch>
        	<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
        <cfrethrow />
        </cfcatch>
        </cftry>

   	<cfreturn qGetDeploymentFilesManifestForArchiveID />
    </cffunction>	
	
	<cffunction name="getArchiveCertificationsForArchiveID" access="public" returntype="query" output="false" hint="">
    	<cfargument name="dsn" type="string" required="True" />
    	<cfargument name="archiveID" type="string" required="True" />
		
		<cfset var qGetArchiveCertificationsForArchiveID = "" />
		
        <cftry>
        	<cfquery name="qGetArchiveCertificationsForArchiveID" datasource="#arguments.dsn#">
        		SELECT
					  archivecertifications.certificationid		/*  - CHAR (35)*/
					, archivecertifications.archiveid			/*  - CHAR (35)*/
					, archivecertifications.archiveshahash		/*  - CHAR (40)*/
					, archivecertifications.userid			/*  - CHAR (35)*/
					, archivecertifications.userfullname			/*  - VARCHAR (100)*/
					, archivecertifications.useremail			/*  - VARCHAR (255)*/
					, archivecertifications.certificationtypename		/*  - VARCHAR (25)*/
					, archivecertifications.certificationnotes		/*  - LONG VARCHAR (32700)*/
					, archivecertifications.certificationhash		/*  - CHAR (40)*/
					, archivecertifications.certificationon		/*  - TIMESTAMP (26)*/
					, archivecertifications.certificationsystemname	/*  - VARCHAR (255)*/
					
				FROM archivecertifications 
				WHERE
					archiveCertifications.archiveID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.archiveID#" />
        	
        	</cfquery>
        <cfcatch>
        	<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
        <cfrethrow />
        </cfcatch>
        </cftry>

    <cfreturn qGetArchiveCertificationsForArchiveID />
    </cffunction>
	
	
	<cffunction name="getArchiveCertificationForCertificationID" access="public" returntype="query" output="false" hint="">
    	<cfargument name="dsn" type="string" required="True" />
    	<cfargument name="certificationID" type="string" required="True" />
		
		<cfset var qGetArchiveCertificationForCertificationID = "" />
		
        <cftry>
        	<cfquery name="qGetArchiveCertificationForCertificationID" datasource="#arguments.dsn#">
        		SELECT
					  archivecertifications.certificationid		/*  - CHAR (35)*/
					, archivecertifications.archiveid			/*  - CHAR (35)*/
					, archivecertifications.archiveshahash		/*  - CHAR (40)*/
					, archivecertifications.userid			/*  - CHAR (35)*/
					, archivecertifications.userfullname			/*  - VARCHAR (100)*/
					, archivecertifications.useremail			/*  - VARCHAR (255)*/
					, archivecertifications.certificationtypename		/*  - VARCHAR (25)*/
					, archivecertifications.certificationnotes		/*  - LONG VARCHAR (32700)*/
					, archivecertifications.certificationhash		/*  - CHAR (40)*/
					, archivecertifications.certificationon		/*  - TIMESTAMP (26)*/
					, archivecertifications.certificationsystemname	/*  - VARCHAR (255)*/
					
				FROM archivecertifications 
				WHERE
					archiveCertifications.certificationID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.certificationID#" />
        	
        	</cfquery>
        <cfcatch>
        	<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
        <cfrethrow />
        </cfcatch>
        </cftry>

    <cfreturn qGetArchiveCertificationForCertificationID />
    </cffunction>
	
	<cffunction name="insertArchiveCertification" access="public" returntype="string" output="false" hint="">
    	<cfargument name="dsn" type="string" required="True" />
    	<cfargument name="certificationID" type="String" required="true" hint=" - CHAR (35)" />
    	<cfargument name="archiveid" type="String" required="true" hint=" - CHAR (35)" />
		<cfargument name="archiveshahash" type="String" required="true" hint=" - CHAR (40)" />
		<cfargument name="userid" type="String" required="true" hint=" - CHAR (35)" />
		<cfargument name="userfullname" type="String" required="true" hint=" - VARCHAR (100)" />
		<cfargument name="useremail" type="String" required="true" hint=" - VARCHAR (255)" />
		<cfargument name="certificationtypename" type="String" required="true" hint=" - VARCHAR (25) " />
		<cfargument name="certificationhash" type="String" required="true" hint=" - CHAR (40)" />
		<cfargument name="certificationon" type="date" required="true" hint=" - TIMESTAMP (26)" />
		<cfargument name="certificationnotes" type="String" required="true" hint=" - LONG VARCHAR" />
		<cfargument name="certificationsystemname" type="String" required="true" hint=" - VARCHAR (255)" />


		<cfset var qInsertArchiveCertification = "" />
		
        <cftry>
        	<cfquery name="qInsertArchiveCertification" datasource="#arguments.dsn#">
        		INSERT INTO archivecertifications
				(
					  certificationid		/*  - CHAR (35)*/
					, archiveid			/*  - CHAR (35)*/
					, archiveshahash		/*  - CHAR (40)*/
					, userid			/*  - CHAR (35)*/
					, userfullname			/*  - VARCHAR (100)*/
					, useremail			/*  - VARCHAR (255)*/
					, certificationtypename		/*  - VARCHAR (25)*/
					, certificationnotes		/*  - LONG VARCHAR (32700)*/
					, certificationhash		/*  - CHAR (40)*/
					, certificationon		/*  - TIMESTAMP (26)*/
					, certificationsystemname	/*  - VARCHAR (255)*/
					
				)
				VALUES
				(
					  <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.certificationid#" /> /* certificationid */
					, <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.archiveid#" /> /* archiveid */
					, <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.archiveshahash#" /> /* archiveshahash */
					, <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userid#" /> /* userid */
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userfullname#" /> /* userfullname */
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.useremail#" /> /* useremail */
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.certificationtypename#" /> /* certificationtypename */
					, <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.certificationnotes#" /> /* certificationnotes */
					, <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.certificationhash#" /> /* certificationhash */
					, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.certificationon#" /> /* certificationon */
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.certificationsystemname#" /> /* certificationsystemname */
					
				)
        	</cfquery>
        <cfcatch>
        	<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
        <cfrethrow />
        </cfcatch>
        </cftry>

    <cfreturn certificationid />
    </cffunction>
	
	<cffunction name="removeArchiveCertification" access="public" returntype="boolean" output="false" hint="">
    	<cfargument name="dsn" type="string" required="True" />
    	<cfargument name="certificationID" type="string" required="True" />
		
		<cfset var qRemoveArchiveCertification = "" />
        <cftry>
        	<cfquery name="qRemoveArchiveCertification" datasource="#arguments.dsn#">
        		DELETE
				FROM archiveCertifications
				WHERE
        			archiveCertifications.certificationID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.certificationID#" />
        	</cfquery>
        <cfcatch>
        	<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
        <cfrethrow />
        </cfcatch>
        </cftry>

    <cfreturn True />
    </cffunction>
	
	<cffunction name="getArchiveLog" access="public" returntype="query" output="false" hint="">
    	<cfargument name="dsn" type="string" required="True" />
    	<cfargument name="maxrows" type="numeric" required="True" />
		
		<cfset var qGetArchiveLog = "" />
		
        <cftry>
        	<cfquery name="qGetArchiveLog" datasource="#arguments.dsn#" maxrows="#arguments.maxrows#">
        		SELECT
					  archivelog.logid			/*  - CHAR (35)*/
					, archivelog.archiveid		/*  - CHAR (35)*/
					, archivelog.archiveshahash	/*  - CHAR (40)*/
					, archivelog.buildsystemname	/*  - VARCHAR (255)*/
					, archivelog.logSystemName	/*  - VARCHAR (255)*/
					, archivelog.logaction		/*  - VARCHAR (50)*/
					, archivelog.deployflag		/*  - INTEGER (10)*/
					, archivelog.backupcreatedflag	/*  - INTEGER (10)*/
					, archivelog.backuparchiveid	/*  - CHAR (35)*/
					, archivelog.userid		/*  - CHAR (35)*/
					, archivelog.logmessage		/*  - VARCHAR (1000)*/
					, archivelog.logdatetime		/*  - TIMESTAMP (26)*/
					
				FROM archivelog 
				ORDER BY logdatetime desc
        	
        	</cfquery>
        <cfcatch>
        	<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
        <cfrethrow />
        </cfcatch>
        </cftry>

	<cfreturn qGetArchiveLog />
    </cffunction>
	
	<cffunction name="getArchiveLogForArchiveID" access="public" returntype="query" output="false" hint="">
    	<cfargument name="dsn" type="string" required="True" />
    	<cfargument name="archiveID" type="string" required="True" />
		
		<cfset var qGetArchiveLogForArchiveID = "" />
		
        <cftry>
        	<cfquery name="qGetArchiveLogForArchiveID" datasource="#arguments.dsn#">
        		SELECT
					  archivelog.logid			/*  - CHAR (35)*/
					, archivelog.archiveid		/*  - CHAR (35)*/
					, archivelog.archiveshahash	/*  - CHAR (40)*/
					, archivelog.buildsystemname	/*  - VARCHAR (255)*/
					, archivelog.logSystemName	/*  - VARCHAR (255)*/
					, archivelog.logaction		/*  - VARCHAR (50)*/
					, archivelog.deployflag		/*  - INTEGER (10)*/
					, archivelog.backupcreatedflag	/*  - INTEGER (10)*/
					, archivelog.backuparchiveid	/*  - CHAR (35)*/
					, archivelog.userid		/*  - CHAR (35)*/
					, archivelog.logmessage		/*  - VARCHAR (1000)*/
					, archivelog.logdatetime		/*  - TIMESTAMP (26)*/
					
				FROM archivelog
				WHERE archiveID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.archiveID#" />
				ORDER BY logdatetime desc
        	
        	</cfquery>
        <cfcatch>
        	<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
        <cfrethrow />
        </cfcatch>
        </cftry>

	<cfreturn qGetArchiveLogForArchiveID />
    </cffunction>
	
	<cffunction name="insertArchiveLog" access="public" returntype="void" output="false" hint="">
    	<cfargument name="dsn" type="string" required="True" />
    	<cfargument name="archiveid" type="String" required="true" hint=" - CHAR (35)" />
		<cfargument name="archiveshahash" type="String" required="true" hint=" - CHAR (40)" />
		<cfargument name="buildsystemname" type="String" required="true" hint=" - VARCHAR (255)" />
		<cfargument name="logSystemName" type="String" required="true" hint=" - VARCHAR (255)" />
		<cfargument name="logaction" type="String" required="true" hint=" - VARCHAR (50)" />
		<cfargument name="deployflag" type="Numeric" required="true" hint=" - INTEGER (10)" />
		<cfargument name="backupcreatedflag" type="Numeric" required="true" hint=" - INTEGER (10)" />
		<cfargument name="backuparchiveid" type="String" required="true" hint=" - CHAR (35)" />
		<cfargument name="userid" type="String" required="true" hint=" - CHAR (35)" />
		<cfargument name="logmessage" type="String" required="true" hint=" - VARCHAR (1000)" />
		<cfargument name="logDateTime" type="date" required="true" hint=" - TIMESTAMP" />
		<cfargument name="logID" type="string" required="false" default="#createUUID()#" hint=" - CHAR (35)" />

		<cfset var qInsertArchiveLog = "" />
        <cftry>
        	<cfquery name="qInsertArchiveLog" datasource="#arguments.dsn#">
        		INSERT INTO archivelog
				(
					  logid			/*  - CHAR (35)*/
					, archiveid		/*  - CHAR (35)*/
					, archiveshahash	/*  - CHAR (40)*/
					, buildsystemname	/*  - VARCHAR (255)*/
					, logSystemName	/*  - VARCHAR (255)*/
					, logaction		/*  - VARCHAR (50)*/
					, deployflag		/*  - INTEGER (10)*/
					, backupcreatedflag	/*  - INTEGER (10)*/
					, backuparchiveid	/*  - CHAR (35)*/
					, userid		/*  - CHAR (35)*/
					, logmessage		/*  - VARCHAR (1000)*/
					, logdatetime		/*  - TIMESTAMP (26)*/	
				)
				VALUES
				(
					  <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.logID#" /> /* logid */
					, <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.archiveid#" /> /* archiveid */
					, <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.archiveshahash#" /> /* archiveshahash */
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.buildsystemname#" /> /* buildsystemname */
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.logSystemName#" /> /* logSystemName */
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.logaction#" /> /* logaction */
					, <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.deployflag#" /> /* deployflag */
					, <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.backupcreatedflag#" /> /* backupcreatedflag */
					, <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.backuparchiveid#" /> /* backuparchiveid */
					, <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userid#" /> /* userid */
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.logmessage#" /> /* logmessage */
					, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.logDateTime#" /> /* logdatetime */
				)        	
        	</cfquery>
        <cfcatch>
        	<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
        <cfrethrow />
        </cfcatch>
        </cftry>
    	
    </cffunction>
	
	<cffunction name="setConfigValue" access="public" returntype="void" output="false" hint="">
    	<cfargument name="dsn" type="string" required="True" />
    	<cfargument name="key" type="string" required="True" />
		<cfargument name="value" type="string" required="true" />
		
		<cfset var qGetConfigValue = getConfigValue(arguments.dsn,arguments.key) />
		<cfset var qSetConfigValue = "" />
		
		<cfif qGetConfigValue EQ -1>
			
            <cftry>
            	<cfquery name="qSetConfigValue" datasource="#arguments.dsn#">
            		INSERT INTO cascadeConfig
					(
						  configKey
						, configValue
					)
					VALUES
					(
						  <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.key)#" />
						, <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.value)#" />
					)            	
            	</cfquery>
            <cfcatch>
            	<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
            <cfrethrow />
            </cfcatch>
            </cftry>

		<cfelse>
					
            <cftry>
            	<cfquery name="qSetConfigValue" datasource="#arguments.dsn#">
            		UPDATE cascadeConfig
					SET
						configValue = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.value)#" />
					WHERE
						configKey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.key)#" />        	
            	</cfquery>
            <cfcatch>
            	<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
            <cfrethrow />
            </cfcatch>
            </cftry>
		
		</cfif>
    	
		
    </cffunction>
	
	<cffunction name="getConfigValue" access="public" returntype="string" output="false" hint="">
    	<cfargument name="dsn" type="string" required="True" />
    	<cfargument name="key" type="string" required="true" />
		
		<cfset var qGetConfigValue = "" />
		
        <cftry>
        	<cfquery name="qGetConfigValue" datasource="#arguments.dsn#">
        		SELECT
					configValue
				FROM
					cascadeConfig
				WHERE
					configKey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.key)#" />  
        	</cfquery>
        <cfcatch>
        	<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
        <cfrethrow />
        </cfcatch>
        </cftry>

		<cfif qGetConfigValue.recordCount>
			<cfreturn qGetConfigValue.configValue />
		</cfif>
	
    <cfreturn -1 />
    </cffunction>


</cfcomponent>