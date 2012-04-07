<cfcomponent>

	<cffunction name="performUpgrades" access="public" returntype="string" output="false" hint="">
    	<cfargument name="dsn" type="string" required="True" />
    	<cfargument name="targetVersion" type="string" requried="true" />
		
		<cfset var currentVersion = getCurrentVersion(arguments.dsn) />
		
		<cfloop condition="arguments.targetVersion NEQ currentVersion">
		
			<cfswitch expression="#currentVersion#">
				<cfcase value="1.0">
					
					<cfset upgradeTo_1_1(arguments.dsn) />
					
					<cfset updateVersion(arguments.dsn,"1.1") />
					
				</cfcase>
				<cfdefaultcase>
					<cfthrow message="No upgrade path specified for #currentVersion#" />
				</cfdefaultcase>
			</cfswitch>
		
		
			<cfset currentVersion = getCurrentVersion(arguments.dsn) />
		</cfloop>
		
    <cfreturn currentVersion />
    </cffunction>

	<cffunction name="getCurrentVersion" access="public" returntype="numeric" output="false" hint="">
    	<cfargument name="dsn" type="string" required="True" />
    	
		<cfset var qGetCurrentVersion = "" />
        <cftry>
        	<cfquery name="qGetCurrentVersion" datasource="#arguments.dsn#">
        		SELECT
					configValue version
				FROM
					cascadeConfig
				WHERE
					configKey = <cfqueryparam cfsqltype="cf_sql_varchar" value="CASCADEVERSION" />        	
        	</cfquery>
        <cfcatch>
        	<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
        <cfrethrow />
        </cfcatch>
        </cftry>
		
		<cfif NOT qGetCurrentVersion.recordCount>
			<cfthrow message="No Version in the DB... thats a problem." />
		</cfif>

    <cfreturn qGetCurrentVersion.version />
    </cffunction>
	
	<cffunction name="updateVersion" access="private" returntype="boolean" output="false" hint="">
    	<cfargument name="dsn" type="string" required="True" />
		<cfargument name="newVersion" type="string" required="true" />
    	
		<cfset var qUpdateVersion = "" />
    
	    <cftry>
        	<cfquery name="qUpdateVersion" datasource="#arguments.dsn#">
        		UPDATE
        			cascadeConfig
				SET
					configValue = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.newVersion#" />
				WHERE
					configKey = <cfqueryparam cfsqltype="cf_sql_varchar" value="CASCADEVERSION" />        	      	
        	</cfquery>
        <cfcatch>
        	<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
        <cfrethrow />
        </cfcatch>
        </cftry>

	<cfreturn true />    	
    </cffunction>

	<cffunction name="upgradeTo_1_1" access="private" returntype="boolean" output="false" hint="">
    	<cfargument name="dsn" type="string" required="True" />
    	
		<cfset var local = structNew() />
		
		<!--- alter remotes --->
        <cftry>
        	<cfquery name="local.qAlterRemoteServers" datasource="#arguments.dsn#">
        		ALTER TABLE remoteServers
				ADD COLUMN 
					minimumCertificationID		char(35)		NOT NULL DEFAULT ''
        	</cfquery>
        <cfcatch>
        	<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
        <cfrethrow />
        </cfcatch>
        </cftry>
		
        <cftry>
        	<cfquery name="local.qAlterRemoteServers" datasource="#arguments.dsn#">
        		ALTER TABLE remoteServers
				ADD COLUMN 
					minimumCertificationName		varchar(25)		NOT NULL DEFAULT ''
        	</cfquery>
        <cfcatch>
        	<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
        <cfrethrow />
        </cfcatch>
        </cftry> 
		
        <cftry>
        	<cfquery name="local.qAlterRemoteServers" datasource="#arguments.dsn#">
        		ALTER TABLE remoteServers
				ADD COLUMN 
					updatedByUserID				char(35)		NOT NULL DEFAULT ''
        	</cfquery>
        <cfcatch>
        	<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
        <cfrethrow />
        </cfcatch>
        </cftry>
		
        <cftry>
        	<cfquery name="local.qAlterRemoteServers" datasource="#arguments.dsn#">
        		ALTER TABLE remoteServers
				ADD COLUMN 
					updatedByUserName			varchar(100)		NOT NULL DEFAULT ''
        	</cfquery>
        <cfcatch>
        	<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
        <cfrethrow />
        </cfcatch>
        </cftry>
		
        <cftry>
        	<cfquery name="local.qAlterRemoteServers" datasource="#arguments.dsn#">
        		ALTER TABLE remoteServers
				ADD COLUMN 
					updatedByUserFullname		varchar(100)		NOT NULL DEFAULT ''
        	</cfquery>
        <cfcatch>
        	<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
        <cfrethrow />
        </cfcatch>
        </cftry>
		
        <cftry>
        	<cfquery name="local.qAlterRemoteServers" datasource="#arguments.dsn#">
        		ALTER TABLE remoteServers
				ADD COLUMN 
					updatedByUserEmail			varchar(255)		NOT NULL DEFAULT ''
        	</cfquery>
        <cfcatch>
        	<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
        <cfrethrow />
        </cfcatch>
        </cftry>
		
        <cftry>
        	<cfquery name="local.qAlterRemoteServers" datasource="#arguments.dsn#">
        		ALTER TABLE remoteServers
				ADD COLUMN 
					updatedOn					timestamp		NOT NULL DEFAULT '1970-01-01 00:00:00'
        	</cfquery>
        <cfcatch>
        	<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
        <cfrethrow />
        </cfcatch>
        </cftry>

    <cfreturn true />
    </cffunction>


</cfcomponent>