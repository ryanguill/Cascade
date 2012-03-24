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
		<cfcase value="moveChangeType,moveCertificationType">
			<cfloop collection="#url#" item="variables.item">
				<cfset form[item] = url[item] />
			</cfloop>
		</cfcase>
		<cfdefaultcase />
	</cfswitch>
</cfif>

<cfif structKeyExists(form,"action")>
	<cfswitch expression="#form.action#">
		<cfcase value="createChangeType">
		
			<cfset populateTempFormVariables(form,"createChangeTypeForm") />
			
			<cfif NOT structKeyExists(form,"changeTypeName") OR NOT len(trim(form.changeTypeName))>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/admin/userManagement/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="ChangeType Name is required." />
				</cfinvoke>
			</cfif>
			
			<cfif NOT structKeyExists(form,"changeTypeDesc") OR NOT len(trim(form.changeTypeDesc))>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/admin/userManagement/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="ChangeType Description is required." />
				</cfinvoke>
			</cfif>
			
			<cfif session.messenger.hasAlerts()>
				<cflocation url="#application.settings.appBaseDir#/admin/referenceTables/changeTypes.cfm" />
			<cfelse>
				<cfset structClear(session.tempFormVars.createChangeTypeForm) />
			</cfif>
			
			<cfinvoke component="#application.daos.referenceTables#" method="getAllChangeTypes" returnvariable="variables.changeType">
				<cfinvokeargument name="dsn" value="#application.settings.dsn#" />	<!---Type:string  --->				
			</cfinvoke>
			
			<cfinvoke component="#application.daos.referenceTables#" method="createChangeType">
				<cfinvokeargument name="dsn" value="#application.settings.dsn#" />	<!---Type:string  --->
				<cfinvokeargument name="changeTypeName" value="#trim(form.changeTypeName)#" />	<!---Type:String Hint:  - varchar (15) --->
				<cfinvokeargument name="sort" value="#(variables.changeType.recordCount + 1) * 10#" />	<!---Type:Numeric Hint:  - int  --->
				<cfinvokeargument name="changeTypeDesc" value="#trim(form.changeTypeDesc)#" />	<!---Type:String Hint:  - varchar (250) --->
				<cfinvokeargument name="changeTypeAbbr" value="#trim(form.changeTypeAbbr)#" />	<!---Type:String Hint:  - varchar (250) --->
				<cfinvokeargument name="activeFlag" value="true" />	<!---Type:Boolean Hint:  - int  --->
			</cfinvoke>
			
			<cflocation url="#application.settings.appBaseDir#/admin/referenceTables/changeTypes.cfm" />
		
		</cfcase>
		
		<cfcase value="moveChangeType">
			
			<cfif NOT structKeyExists(url,"dir") OR (url.dir NEQ "UP" AND url.dir NEQ "DOWN") OR NOT structKeyExists(url,"changeTypeID") OR NOT isNumeric(url.changeTypeID)>
				<cflocation url="#application.settings.appBaseDir#/admin/referenceTables/changeType.cfm" />
			</cfif>
			
			<cfinvoke component="#application.daos.referenceTables#" method="getChangeTypeByChangeTypeID" returnvariable="variables.changeType">
				<cfinvokeargument name="dsn" value="#application.settings.dsn#" />	<!---Type:string  --->	
				<cfinvokeargument name="changeTypeID" value="#url.changeTypeID#" />			
			</cfinvoke>
			
			<cfif NOT variables.changeType.recordCount>
				<cflocation url="#application.settings.appBaseDir#/admin/referenceTables/changeTypes.cfm" />
			</cfif>
			
			<cfif url.dir eq "UP">
				<cfinvoke component="#application.daos.referenceTables#" method="updateChangeType" returnvariable="updateChangeTypeRet">
					<cfinvokeargument name="dsn" value="#application.settings.dsn#" />	<!---Type:string  --->	
					<cfinvokeargument name="changeTypeID" value="#url.changeTypeID#" />	
					<cfinvokeargument name="changeTypeName" value="#variables.changeType.changeTypeName#" />	<!---Type:String Hint:  - varchar (15) --->
					<cfinvokeargument name="sort" value="#variables.changeType.sort - 15#" />	<!---Type:Numeric Hint:  - int  --->
					<cfinvokeargument name="changeTypeDesc" value="#variables.changeType.changeTypeDesc#" />	<!---Type:String Hint:  - varchar (250) --->
					<cfinvokeargument name="changeTypeAbbr" value="#variables.changeType.changeTypeAbbr#" />	<!---Type:String Hint:  - varchar (250) --->
					<cfinvokeargument name="activeFlag" value="#variables.changeType.activeFlag#" />	<!---Type:Boolean Hint:  - int  --->
				</cfinvoke>
			<cfelse>
				<cfinvoke component="#application.daos.referenceTables#" method="updateChangeType" returnvariable="updateChangeTypeRet">
					<cfinvokeargument name="dsn" value="#application.settings.dsn#" />	<!---Type:string  --->	
					<cfinvokeargument name="changeTypeID" value="#url.changeTypeID#" />	
					<cfinvokeargument name="changeTypeName" value="#variables.changeType.changeTypeName#" />	<!---Type:String Hint:  - varchar (15) --->
					<cfinvokeargument name="sort" value="#variables.changeType.sort + 15#" />	<!---Type:Numeric Hint:  - int  --->
					<cfinvokeargument name="changeTypeDesc" value="#variables.changeType.changeTypeDesc#" />	<!---Type:String Hint:  - varchar (250) --->
					<cfinvokeargument name="changeTypeAbbr" value="#variables.changeType.changeTypeAbbr#" />	<!---Type:String Hint:  - varchar (250) --->
					<cfinvokeargument name="activeFlag" value="#variables.changeType.activeFlag#" />	<!---Type:Boolean Hint:  - int  --->
				</cfinvoke>
			</cfif>

			<cfinvoke component="#application.daos.referenceTables#" method="getAllChangeTypes" returnvariable="variables.changeTypes">
				<cfinvokeargument name="dsn" value="#application.settings.dsn#" />
			</cfinvoke>
			
			<cfloop query="variables.changeTypes">
				<cfinvoke component="#application.daos.referenceTables#" method="updateChangeType" returnvariable="updateChangeTypeRet">
					<cfinvokeargument name="dsn" value="#application.settings.dsn#" />	<!---Type:string  --->	
					<cfinvokeargument name="changeTypeID" value="#variables.changeTypes.changeTypeID#" />	
					<cfinvokeargument name="changeTypeName" value="#variables.changeTypes.changeTypeName#" />	<!---Type:String Hint:  - varchar (15) --->
					<cfinvokeargument name="sort" value="#variables.changeTypes.currentRow * 10#" />	<!---Type:Numeric Hint:  - int  --->
					<cfinvokeargument name="changeTypeDesc" value="#variables.changeTypes.changeTypeDesc#" />	<!---Type:String Hint:  - varchar (250) --->
					<cfinvokeargument name="changeTypeAbbr" value="#variables.changeTypes.changeTypeAbbr#" />	<!---Type:String Hint:  - varchar (250) --->
					<cfinvokeargument name="activeFlag" value="#variables.changeTypes.activeFlag#" />	<!---Type:Boolean Hint:  - int  --->
				</cfinvoke>
			</cfloop>
				
			<cflocation url="#application.settings.appBaseDir#/admin/referenceTables/changeTypes.cfm" />
		</cfcase>
		
		<cfcase value="updateChangeType">
		
			<cfif NOT structKeyExists(form,"changeTypeID") OR NOT isNumeric(form.changeTypeID)>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/admin/userManagement/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="ChangeType ID is required." />
				</cfinvoke>
			</cfif>
			
			<cfif session.messenger.hasAlerts()>
				<cflocation url="#application.settings.appBaseDir#/admin/referenceTables/changeTypes.cfm" />
			</cfif>
			
			<cfparam name="form.activeFlag" default="false" />

			<cfif NOT structKeyExists(form,"changeTypeName") OR NOT len(trim(form.changeTypeName))>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/admin/userManagement/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="ChangeType Name is required." />
				</cfinvoke>
			</cfif>
			
			<cfif NOT structKeyExists(form,"changeTypeDesc") OR NOT len(trim(form.changeTypeDesc))>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/admin/userManagement/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="ChangeType Description is required." />
				</cfinvoke>
			</cfif>
			
			<cfif session.messenger.hasAlerts()>
				<cflocation url="#application.settings.appBaseDir#/admin/referenceTables/changeTypes.cfm?changeTypeID=#form.changeTypeID#" />
			</cfif>
			
			<cfinvoke component="#application.daos.referenceTables#" method="getChangeTypeByChangeTypeID" returnvariable="variables.changeType">
				<cfinvokeargument name="dsn" value="#application.settings.dsn#" />	<!---Type:string  --->	
				<cfinvokeargument name="changeTypeID" value="#form.changeTypeID#" />			
			</cfinvoke>
			
			<cfinvoke component="#application.daos.referenceTables#" method="updateChangeType" returnvariable="updateChangeTypeRet">
				<cfinvokeargument name="dsn" value="#application.settings.dsn#" />	<!---Type:string  --->	
				<cfinvokeargument name="changeTypeID" value="#form.changeTypeID#" />	
				<cfinvokeargument name="changeTypeName" value="#trim(form.changeTypeName)#" />	<!---Type:String Hint:  - varchar (15) --->
				<cfinvokeargument name="sort" value="#variables.changeType.sort#" />	<!---Type:Numeric Hint:  - int  --->
				<cfinvokeargument name="changeTypeDesc" value="#trim(form.changeTypeDesc)#" />	<!---Type:String Hint:  - varchar (250) --->
				<cfinvokeargument name="changeTypeAbbr" value="#trim(form.changeTypeAbbr)#" />	<!---Type:String Hint:  - varchar (250) --->
				<cfinvokeargument name="activeFlag" value="#form.activeFlag#" />	<!---Type:Boolean Hint:  - int  --->
			</cfinvoke>
			
			<cflocation url="#application.settings.appBaseDir#/admin/referenceTables/changeTypes.cfm?changeTypeID=#form.changeTypeID#" />
		
		</cfcase>
		
		<cfcase value="createCertificationType">
		
			<cfset populateTempFormVariables(form,"createCertificationTypeForm") />
			
			<cfif NOT structKeyExists(form,"certificationTypeName") OR NOT len(trim(form.certificationTypeName))>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/admin/userManagement/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="CertificationType Name is required." />
				</cfinvoke>
			</cfif>
			
			<cfif NOT structKeyExists(form,"certificationTypeDesc") OR NOT len(trim(form.certificationTypeDesc))>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/admin/userManagement/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="CertificationType Description is required." />
				</cfinvoke>
			</cfif>
			
			<cfif session.messenger.hasAlerts()>
				<cflocation url="#application.settings.appBaseDir#/admin/referenceTables/certificationTypes.cfm" />
			<cfelse>
				<cfset structClear(session.tempFormVars.createCertificationTypeForm) />
			</cfif>
			
			<cfinvoke component="#application.daos.referenceTables#" method="getAllCertificationTypes" returnvariable="variables.certificationType">
				<cfinvokeargument name="dsn" value="#application.settings.dsn#" />	<!---Type:string  --->				
			</cfinvoke>
			
			<cfinvoke component="#application.daos.referenceTables#" method="createCertificationType">
				<cfinvokeargument name="dsn" value="#application.settings.dsn#" />	<!---Type:string  --->
				<cfinvokeargument name="certificationTypeName" value="#trim(form.certificationTypeName)#" />	<!---Type:String Hint:  - varchar (15) --->
				<cfinvokeargument name="sort" value="#(variables.certificationType.recordCount + 1) * 10#" />	<!---Type:Numeric Hint:  - int  --->
				<cfinvokeargument name="certificationTypeDesc" value="#trim(form.certificationTypeDesc)#" />	<!---Type:String Hint:  - varchar (250) --->
				<cfinvokeargument name="certificationTypeAbbr" value="#trim(form.certificationTypeAbbr)#" />	<!---Type:String Hint:  - varchar (15) --->
				<cfinvokeargument name="requiredUserGroupName" value="#trim(form.requiredUserGroupName)#" />	<!---Type:String Hint:  - varchar (50) --->
				<cfinvokeargument name="activeFlag" value="true" />	<!---Type:Boolean Hint:  - int  --->
			</cfinvoke>
			
			<cflocation url="#application.settings.appBaseDir#/admin/referenceTables/certificationTypes.cfm" />
		
		</cfcase>
		
		<cfcase value="moveCertificationType">
			
			<cfif NOT structKeyExists(url,"dir") OR (url.dir NEQ "UP" AND url.dir NEQ "DOWN") OR NOT structKeyExists(url,"certificationTypeID") OR NOT isNumeric(url.certificationTypeID)>
				<cflocation url="#application.settings.appBaseDir#/admin/referenceTables/certificationType.cfm" />
			</cfif>
			
			<cfinvoke component="#application.daos.referenceTables#" method="getCertificationTypeByCertificationTypeID" returnvariable="variables.certificationType">
				<cfinvokeargument name="dsn" value="#application.settings.dsn#" />	<!---Type:string  --->	
				<cfinvokeargument name="certificationTypeID" value="#url.certificationTypeID#" />			
			</cfinvoke>
			
			<cfif NOT variables.certificationType.recordCount>
				<cflocation url="#application.settings.appBaseDir#/admin/referenceTables/certificationTypes.cfm" />
			</cfif>
			
			
			<cfif url.dir eq "UP">
				<cfinvoke component="#application.daos.referenceTables#" method="updateCertificationType" returnvariable="updateCertificationTypeRet">
					<cfinvokeargument name="dsn" value="#application.settings.dsn#" />	<!---Type:string  --->	
					<cfinvokeargument name="certificationTypeID" value="#url.certificationTypeID#" />	
					<cfinvokeargument name="certificationTypeName" value="#variables.certificationType.certificationTypeName#" />	<!---Type:String Hint:  - varchar (15) --->
					<cfinvokeargument name="sort" value="#variables.certificationType.sort - 15#" />	<!---Type:Numeric Hint:  - int  --->
					<cfinvokeargument name="certificationTypeDesc" value="#variables.certificationType.certificationTypeDesc#" />	<!---Type:String Hint:  - varchar (250) --->
					<cfinvokeargument name="certificationTypeAbbr" value="#variables.certificationType.certificationTypeAbbr#" />	<!---Type:String Hint:  - varchar (15) --->
					<cfinvokeargument name="requiredUserGroupName" value="#variables.certificationType.requiredUserGroupName#" />	<!---Type:String Hint:  - varchar (50) --->
					<cfinvokeargument name="activeFlag" value="#variables.certificationType.activeFlag#" />	<!---Type:Boolean Hint:  - int  --->
				</cfinvoke>
			<cfelse>
				<cfinvoke component="#application.daos.referenceTables#" method="updateCertificationType" returnvariable="updateCertificationTypeRet">
					<cfinvokeargument name="dsn" value="#application.settings.dsn#" />	<!---Type:string  --->	
					<cfinvokeargument name="certificationTypeID" value="#url.certificationTypeID#" />	
					<cfinvokeargument name="certificationTypeName" value="#variables.certificationType.certificationTypeName#" />	<!---Type:String Hint:  - varchar (15) --->
					<cfinvokeargument name="sort" value="#variables.certificationType.sort + 15#" />	<!---Type:Numeric Hint:  - int  --->
					<cfinvokeargument name="certificationTypeDesc" value="#variables.certificationType.certificationTypeDesc#" />	<!---Type:String Hint:  - varchar (250) --->
					<cfinvokeargument name="certificationTypeAbbr" value="#variables.certificationType.certificationTypeAbbr#" />	<!---Type:String Hint:  - varchar (15) --->
					<cfinvokeargument name="requiredUserGroupName" value="#variables.certificationType.requiredUserGroupName#" />	<!---Type:String Hint:  - varchar (50) --->
					<cfinvokeargument name="activeFlag" value="#variables.certificationType.activeFlag#" />	<!---Type:Boolean Hint:  - int  --->
				</cfinvoke>
			</cfif>

			<cfinvoke component="#application.daos.referenceTables#" method="getAllCertificationTypes" returnvariable="variables.certificationTypes">
				<cfinvokeargument name="dsn" value="#application.settings.dsn#" />
			</cfinvoke>
			
			<cfloop query="variables.certificationTypes">
				<cfinvoke component="#application.daos.referenceTables#" method="updateCertificationType" returnvariable="updateCertificationTypeRet">
					<cfinvokeargument name="dsn" value="#application.settings.dsn#" />	<!---Type:string  --->	
					<cfinvokeargument name="certificationTypeID" value="#variables.certificationTypes.certificationTypeID#" />	
					<cfinvokeargument name="certificationTypeName" value="#variables.certificationTypes.certificationTypeName#" />	<!---Type:String Hint:  - varchar (15) --->
					<cfinvokeargument name="sort" value="#variables.certificationTypes.currentRow * 10#" />	<!---Type:Numeric Hint:  - int  --->
					<cfinvokeargument name="certificationTypeDesc" value="#variables.certificationTypes.certificationTypeDesc#" />	<!---Type:String Hint:  - varchar (250) --->
					<cfinvokeargument name="certificationTypeAbbr" value="#variables.certificationTypes.certificationTypeAbbr#" />	<!---Type:String Hint:  - varchar (15) --->
					<cfinvokeargument name="requiredUserGroupName" value="#variables.certificationTypes.requiredUserGroupName#" />	<!---Type:String Hint:  - varchar (50) --->
					<cfinvokeargument name="activeFlag" value="#variables.certificationTypes.activeFlag#" />	<!---Type:Boolean Hint:  - int  --->
				</cfinvoke>
			</cfloop>
				
			<cflocation url="#application.settings.appBaseDir#/admin/referenceTables/certificationTypes.cfm" />
		</cfcase>
		
		<cfcase value="updateCertificationType">
		
			<cfif NOT structKeyExists(form,"certificationTypeID") OR NOT isNumeric(form.certificationTypeID)>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/admin/userManagement/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="CertificationType ID is required." />
				</cfinvoke>
			</cfif>
			
			<cfif session.messenger.hasAlerts()>
				<cflocation url="#application.settings.appBaseDir#/admin/referenceTables/certificationTypes.cfm" />
			</cfif>
			
			<cfparam name="form.activeFlag" default="false" />

			<cfif NOT structKeyExists(form,"certificationTypeName") OR NOT len(trim(form.certificationTypeName))>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/admin/userManagement/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="CertificationType Name is required." />
				</cfinvoke>
			</cfif>
			
			<cfif NOT structKeyExists(form,"certificationTypeDesc") OR NOT len(trim(form.certificationTypeDesc))>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/admin/userManagement/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="CertificationType Description is required." />
				</cfinvoke>
			</cfif>
			
			<cfif session.messenger.hasAlerts()>
				<cflocation url="#application.settings.appBaseDir#/admin/referenceTables/certificationTypes.cfm?certificationTypeID=#form.certificationTypeID#" />
			</cfif>
			
			<cfinvoke component="#application.daos.referenceTables#" method="getCertificationTypeByCertificationTypeID" returnvariable="variables.certificationType">
				<cfinvokeargument name="dsn" value="#application.settings.dsn#" />	<!---Type:string  --->	
				<cfinvokeargument name="certificationTypeID" value="#form.certificationTypeID#" />			
			</cfinvoke>
			
			<cfinvoke component="#application.daos.referenceTables#" method="updateCertificationType" returnvariable="updateCertificationTypeRet">
				<cfinvokeargument name="dsn" value="#application.settings.dsn#" />	<!---Type:string  --->	
				<cfinvokeargument name="certificationTypeID" value="#form.certificationTypeID#" />	
				<cfinvokeargument name="certificationTypeName" value="#trim(form.certificationTypeName)#" />	<!---Type:String Hint:  - varchar (15) --->
				<cfinvokeargument name="sort" value="#variables.certificationType.sort#" />	<!---Type:Numeric Hint:  - int  --->
				<cfinvokeargument name="certificationTypeDesc" value="#trim(form.certificationTypeDesc)#" />	<!---Type:String Hint:  - varchar (250) --->
				<cfinvokeargument name="certificationTypeAbbr" value="#trim(form.certificationTypeAbbr)#" />	<!---Type:String Hint:  - varchar (15) --->
				<cfinvokeargument name="requiredUserGroupName" value="#trim(form.requiredUserGroupName)#" />	<!---Type:String Hint:  - varchar (50) --->
				<cfinvokeargument name="activeFlag" value="#form.activeFlag#" />	<!---Type:Boolean Hint:  - int  --->
			</cfinvoke>
			
			<cflocation url="#application.settings.appBaseDir#/admin/referenceTables/certificationTypes.cfm?certificationTypeID=#form.certificationTypeID#" />
		
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
