<cfcomponent>
	<cffunction name="createChangeType" access="public" returntype="void" output="false">
		<cfargument name="dsn" type="string" required="true" />
		<cfargument name="changeTypeName" type="String" required="true" hint=" - varchar (25)" />
		<cfargument name="sort" type="Numeric" required="true" hint=" - int " />
		<cfargument name="changeTypeDesc" type="String" required="true" hint=" - varchar (250)" />
		<cfargument name="changeTypeAbbr" type="String" required="true" hint=" - varchar (15)" />
		<cfargument name="activeFlag" type="Boolean" required="true" hint=" - int " />
		
		<cfset var qCreateChangeType = "" />
		
		<cftry>
			<cfquery name="qCreateChangeType" datasource="#arguments.dsn#">
				INSERT INTO ref_changeTypes
				(
					  changeTypeName	/*  - varchar (50)*/
					, sort		/*  - int */
					, changeTypeDesc	/*  - varchar (250)*/
					, changeTypeAbbr	/*  - varchar (15)*/
					, activeFlag	/*  - int */
				)
				VALUES
				(
					  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.changeTypeName#" /> /* changeTypeName */
					, <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sort#" /> /* sort */
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.changeTypeDesc#" /> /* changeTypeDesc */
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.changeTypeAbbr#" /> /* changeTypeAbbr */
					, <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.activeFlag#" /> /* activeFlag */
				)
			</cfquery>
		<cfcatch>
			<cfrethrow />
		</cfcatch>
		</cftry>
		
	</cffunction>
	
	<cffunction name="getAllChangeTypes" access="public" returntype="query" output="false">
		<cfargument name="dsn" type="string" required="true" />
		
		<cfset var qGetAllChangeTypes = "" />
		
		<cftry>
			<cfquery name="qGetAllChangeTypes" datasource="#arguments.dsn#">
				SELECT
					  changeTypeID	/*  - int */
					, changeTypeName	/*  - varchar (50)*/
					, sort		/*  - int */
					, changeTypeDesc	/*  - varchar (250)*/
					, changeTypeAbbr	/*  - varchar (15)*/
					, activeFlag	/*  - int */					
				FROM ref_changeTypes 
				ORDER BY
					sort ASC
			</cfquery>
		<cfcatch>
			<cfrethrow />
		</cfcatch>
		</cftry>
		
	<cfreturn qGetAllChangeTypes />
	</cffunction>
	
	
	<cffunction name="getChangeTypeByChangeTypeID" access="public" returntype="query" output="false">
		<cfargument name="dsn" type="string" required="true" />
		<cfargument name="changeTypeID" type="string" required="true" />
		
		<cfset var qGetChangeTypeByChangeTypeID = "" />
		
		<cftry>
			<cfquery name="qGetChangeTypeByChangeTypeID" datasource="#arguments.dsn#">
				SELECT
					  changeTypeID	/*  - int */
					, changeTypeName	/*  - varchar (50)*/
					, sort		/*  - int */
					, changeTypeDesc	/*  - varchar (250)*/
					, changeTypeAbbr	/*  - varchar (15)*/
					, activeFlag	/*  - int */					
				FROM ref_changeTypes 
				WHERE
					changeTypeID = <cfqueryparam cfsqltype="cf_sql_int" value="#arguments.changeTypeID#" />
			</cfquery>
		<cfcatch>
			<cfrethrow />
		</cfcatch>
		</cftry>
		
	<cfreturn qGetChangeTypeByChangeTypeID />
	</cffunction>
	
	<cffunction name="updateChangeType" access="public" returntype="void" output="false">
		<cfargument name="dsn" type="string" required="true" />
		<cfargument name="changeTypeID" type="Numeric" required="true" hint=" - int " />
		<cfargument name="changeTypeName" type="String" required="true" hint=" - varchar (50)" />
		<cfargument name="sort" type="Numeric" required="true" hint=" - int " />
		<cfargument name="changeTypeDesc" type="String" required="true" hint=" - varchar (250)" />
		<cfargument name="changeTypeAbbr" type="String" required="true" hint=" - varchar (15)" />
		<cfargument name="activeFlag" type="Boolean" required="true" hint=" - int " />
		
		<cfset var qUpdateChangeType = "" />
		
		<cftry>
			<cfquery name="qCreateChangeType" datasource="#arguments.dsn#">
				UPDATE ref_changeTypes
				SET
					  changeTypeName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.changeTypeName#" />	/*  - varchar (50)*/
					, sort = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sort#" />		/*  - int */
					, changeTypeDesc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.changeTypeDesc#" />	/*  - varchar (250)*/
					, changeTypeAbbr = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.changeTypeAbbr#" />	/*  - varchar (15)*/
					, activeFlag = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.activeFlag#" />	/*  - int */					
				WHERE
					changeTypeID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.changeTypeID#" />	/*  - int */
			</cfquery>
		<cfcatch>
			<cfrethrow />
		</cfcatch>
		</cftry>
		
	</cffunction>
	
	<cffunction name="createCertificationType" access="public" returntype="void" output="false">
		<cfargument name="dsn" type="string" required="true" />
		<cfargument name="certificationTypeName" type="String" required="true" hint=" - varchar (25)" />
		<cfargument name="sort" type="Numeric" required="true" hint=" - int " />
		<cfargument name="certificationTypeDesc" type="String" required="true" hint=" - varchar (250)" />
		<cfargument name="certificationTypeAbbr" type="String" required="true" hint=" - varchar (15)" />
		<cfargument name="requiredUserGroupName" type="String" required="true" hint=" - VARCHAR (50)" />
		<cfargument name="activeFlag" type="Boolean" required="true" hint=" - int " />
		
		<cfset var qCreateCertificationType = "" />
		
		<cftry>
			<cfquery name="qCreateCertificationType" datasource="#arguments.dsn#">
				INSERT INTO ref_certificationTypes
				(
					  certificationTypeName	/*  - varchar (50)*/
					, sort		/*  - int */
					, certificationTypeDesc	/*  - varchar (250)*/
					, certificationTypeAbbr	/*  - varchar (15)*/
					, requiredUserGroupName /*  - varchar (50)*/
					, activeFlag	/*  - int */
				)
				VALUES
				(
					  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.certificationTypeName#" /> /* certificationTypeName */
					, <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sort#" /> /* sort */
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.certificationTypeDesc#" /> /* certificationTypeDesc */
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.certificationTypeAbbr#" /> /* certificationTypeAbbr */
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.requiredUserGroupName#" /> /* requiredUserGroupName */
					, <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.activeFlag#" /> /* activeFlag */
				)
			</cfquery>
		<cfcatch>
			<cfrethrow />
		</cfcatch>
		</cftry>
		
	</cffunction>
	
	<cffunction name="getAllCertificationTypes" access="public" returntype="query" output="false">
		<cfargument name="dsn" type="string" required="true" />
		
		<cfset var qGetAllCertificationTypes = "" />
		
		<cftry>
			<cfquery name="qGetAllCertificationTypes" datasource="#arguments.dsn#">
				SELECT
					  certificationTypeID	/*  - int */
					, certificationTypeName	/*  - varchar (50)*/
					, sort		/*  - int */
					, certificationTypeDesc	/*  - varchar (250)*/
					, certificationTypeAbbr	/*  - varchar (15)*/
					, requiredUserGroupName /*  - varchar (50)*/
					, activeFlag	/*  - int */					
				FROM ref_certificationTypes 
				ORDER BY
					sort ASC
			</cfquery>
		<cfcatch>
			<cfrethrow />
		</cfcatch>
		</cftry>
		
	<cfreturn qGetAllCertificationTypes />
	</cffunction>
	
	
	<cffunction name="getCertificationTypeByCertificationTypeID" access="public" returntype="query" output="false">
		<cfargument name="dsn" type="string" required="true" />
		<cfargument name="certificationTypeID" type="string" required="true" />
		
		<cfset var qGetCertificationTypeByCertificationTypeID = "" />
		
		<cftry>
			<cfquery name="qGetCertificationTypeByCertificationTypeID" datasource="#arguments.dsn#">
				SELECT
					  certificationTypeID	/*  - int */
					, certificationTypeName	/*  - varchar (50)*/
					, sort		/*  - int */
					, certificationTypeDesc	/*  - varchar (250)*/
					, certificationTypeAbbr	/*  - varchar (15)*/
					, requiredUserGroupName /*  - varchar (50)*/
					, activeFlag	/*  - int */					
				FROM ref_certificationTypes 
				WHERE
					certificationTypeID = <cfqueryparam cfsqltype="cf_sql_int" value="#arguments.certificationTypeID#" />
			</cfquery>
		<cfcatch>
			<cfrethrow />
		</cfcatch>
		</cftry>
		
	<cfreturn qGetCertificationTypeByCertificationTypeID />
	</cffunction>
	
	<cffunction name="updateCertificationType" access="public" returntype="void" output="false">
		<cfargument name="dsn" type="string" required="true" />
		<cfargument name="certificationTypeID" type="Numeric" required="true" hint=" - int " />
		<cfargument name="certificationTypeName" type="String" required="true" hint=" - varchar (50)" />
		<cfargument name="sort" type="Numeric" required="true" hint=" - int " />
		<cfargument name="certificationTypeDesc" type="String" required="true" hint=" - varchar (250)" />
		<cfargument name="certificationTypeAbbr" type="String" required="true" hint=" - varchar (15)" />
		<cfargument name="requiredUserGroupName" type="String" required="true" hint=" - VARCHAR (50)" />
		<cfargument name="activeFlag" type="Boolean" required="true" hint=" - int " />
		
		<cfset var qUpdateCertificationType = "" />
		
		<cftry>
			<cfquery name="qCreateCertificationType" datasource="#arguments.dsn#">
				UPDATE ref_certificationTypes
				SET
					  certificationTypeName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.certificationTypeName#" />	/*  - varchar (50)*/
					, sort = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sort#" />		/*  - int */
					, certificationTypeDesc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.certificationTypeDesc#" />	/*  - varchar (250)*/
					, certificationTypeAbbr = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.certificationTypeAbbr#" />	/*  - varchar (15)*/
					, requiredusergroupname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.requiredusergroupname#" />	/*  - VARCHAR (50)*/
					, activeFlag = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.activeFlag#" />	/*  - int */					
				WHERE
					certificationTypeID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.certificationTypeID#" />	/*  - int */
			</cfquery>
		<cfcatch>
			<cfrethrow />
		</cfcatch>
		</cftry>
		
	</cffunction>
	
	
</cfcomponent>