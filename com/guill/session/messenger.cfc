<!--- 
===========================================================
Title: 			
FileName: 		
Version:		
Author:			
CreatedOn:		
LastModified:	

Purpose:

Dependancies:

Assumptions:

Outline:


ChangeLog:

===========================================================
 --->

<cfcomponent output="false">
	<cfsilent>
		
		<!--- Constructor Methods --->
		<cffunction name="init" access="public" returntype="any" output="false">
			
			<cfset createProperties() />			
			
		<cfreturn This />
		</cffunction>
		
		<!--- Public Methods --->
		
		<cffunction name="reset" access="public" returntype="boolean" output="false">
			
			<cfset createProperties() />
			
		<cfreturn True />
		</cffunction>
		
		<cffunction name="setAlert" access="public" returntype="struct" output="False">
			<cfargument name="alertingTemplate" type="string" required="true" />
			<cfargument name="messageType" type="string" required="True" />
			<cfargument name="messageText" type="string" required="True" />
			<cfargument name="messageDetail" type="string" required="False" default="" />
			<cfargument name="messageCode" type="string" required="False" default="" />
			<cfargument name="receivingTemplate" type="String" required="false" default="" />
			
			<cfset VAR alert = structNew() />
			
			<cfif NOT isMessageTypeValid(arguments.messageType)>
				<cfthrow message="Invalid Message Type!" detail="The message type you specified: #arguments.messageType# is invalid. Valid message types are: #getValidMessageTypes()#" />
			</cfif>
			
			<cfset alert.messageType = arguments.messageType />
			<cfset alert.messageText = arguments.messageText />
			<cfset alert.messageDetail = arguments.messageDetail />
			
			<cfset alert.metaData = structNew() />
				
				<cfset alert.metaData.alertingTemplate = arguments.alertingTemplate />
				<cfset alert.metaData.receivingTemplate = arguments.receivingTemplate />
			
			<cfset addAlert(alert) />			
			
		<cfreturn alert />
		</cffunction>
		
		<cffunction name="hasAlerts" access="public" returntype="boolean" output="False">
		
			<cfif alertsLen() EQ 0>
				<cfreturn False />
			<cfelse>
				<cfreturn True />
			</cfif>
		</cffunction>
		
		<cffunction name="alertsLen" access="public" returntype="numeric" output="False">
		
		<cfreturn arrayLen(getAlerts()) />
		</cffunction>
		
		<cffunction name="getAlerts" access="public" returntype="array" output="false">
		
		<cfreturn variables.properties.alerts />
		</cffunction>
		
		<cffunction name="getValidMessageTypes" access="public" returntype="string" output="False">
			
			<cfset VAR messageTypes = "Error, Warning, Information" />
			
		<cfreturn messageTypes />
		</cffunction>
		
		<!--- Package Methods --->
		
		<!--- Private Methods --->
		
		<cffunction name="addAlert" access="private" returntype="boolean" output="False">
			<cfargument name="alertStruct" type="struct" required="True" />
			
			<cflock scope="session" timeout="3">
				<cfset variables.properties.alerts[nextAlert()] = arguments.alertStruct />
			</cflock>
			
		<cfreturn True />
		</cffunction>	
		
		<cffunction name="nextAlert" access="private" returntype="numeric" output="false">
		
		<cfreturn (alertsLen() + 1) />
		</cffunction>
		
		<cffunction name="isMessageTypeValid" access="private" returntype="boolean" output="False">
			<cfargument name="messageType" type="string" required="True" />
			
			<cfswitch expression="#arguments.messageType#">
				<cfcase value="Error" />
				<cfcase value="Warning" />
				<cfcase value="Information" />
				<!--- If you add a message type, make sure to add it in the public method getValidMessageTypes() --->
				<cfdefaultcase>
					<cfreturn False />
				</cfdefaultcase>
			</cfswitch>
		
		<cfreturn True />
		</cffunction>
		
		<cffunction name="createProperties" access="public" returntype="boolean" output="False">
			
			<cfset variables.properties = structNew() />
				
				<cfset variables.properties.alerts = arrayNew(1) />
			
		<cfreturn True />
		</cffunction>
	</cfsilent>
</cfcomponent>