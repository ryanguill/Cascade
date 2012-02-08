<cfif structKeyExists(url,"action")>
	<cfswitch expression="#url.action#">
		<cfcase value="removeUserFromGroup,removeUserGroup">
			<cfloop collection="#url#" item="variables.item">
				<cfset form[item] = url[item] />
			</cfloop>
		</cfcase>
		<cfdefaultcase />
	</cfswitch>
</cfif>

<cfif structKeyExists(form,"action")>
	<cfswitch expression="#form.action#">
		<cfcase value="addUser">
		
			<cfset populateTempFormVariables(form,"addUserForm") />
			
			<cfif NOT structKeyExists(form,"username") OR NOT len(trim(form.username))>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/admin/userManagement/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="Username is required." />
				</cfinvoke>
			</cfif>
			
			<cfif NOT structKeyExists(form,"firstname") OR NOT len(trim(form.firstname))>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/admin/userManagement/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="Firstname is required." />
				</cfinvoke>
			</cfif>
			
			<cfif NOT structKeyExists(form,"lastname") OR NOT len(trim(form.lastname))>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/admin/userManagement/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="Lastname is required." />
				</cfinvoke>
			</cfif>			
			
			<cfif NOT structKeyExists(form,"email") OR NOT len(trim(form.email))>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/admin/userManagement/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="Email is required." />
				</cfinvoke>
			<cfelseif NOT isValid("email",form.email)>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/admin/userManagement/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="Email must be a correctly formatted email address." />
				</cfinvoke>
			</cfif>
			
			<cfif NOT structKeyExists(form,"password") OR NOT len(trim(form.password))>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/admin/userManagement/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="Password is required." />
				</cfinvoke>
			</cfif>
			
			<cfif NOT structKeyExists(form,"password2") OR NOT len(trim(form.password2))>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/admin/userManagement/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="Password Again is required." />
				</cfinvoke>
			</cfif>
			
			<cfif structKeyExists(form,"password") AND structKeyExists(form,"password2") AND len(trim(form.password)) AND len(trim(form.password2))>
				<cfif form.password NEQ form.password2>
					<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
						<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/admin/userManagement/action.cfm" />
						<cfinvokeargument name="messageType" value="Error" />
						<cfinvokeargument name="messageText" value="Passwords do not match." />
					</cfinvoke>
				</cfif>
			</cfif>
			
			<cfif session.messenger.hasAlerts()>
				<cflocation url="#application.settings.appBaseDir#/admin/userManagement/addUser.cfm" />
			<cfelse>
				<cfset structClear(session.tempFormVars.addUserForm) />
			</cfif>
			
			
			<cfinvoke component="#application.daos.userManagement#" method="getUserByUsername" returnvariable="variables.user">
				<cfinvokeargument name="dsn" value="#application.settings.dsn#" />	<!---Type:string  --->
				<cfinvokeargument name="username" value="#form.username#" />	<!---Type:string  --->
			</cfinvoke>
			
			<cfif NOT variables.user.recordCount>			
				<cfinvoke component="#application.daos.userManagement#" method="addUser" returnvariable="variables.addUserRet">
					<cfinvokeargument name="dsn" value="#application.settings.dsn#" />	<!---Type:string  --->
					<cfinvokeargument name="username" value="#form.username#" />	<!---Type:String Hint:  - varchar (100) --->
					<cfinvokeargument name="email" value="#form.email#" />	<!---Type:String Hint:  - varchar (255) --->
					<cfinvokeargument name="firstname" value="#form.firstname#" />	<!---Type:String Hint:  - varchar (50) --->
					<cfinvokeargument name="lastname" value="#form.lastname#" />	<!---Type:String Hint:  - varchar (50) --->
					<cfinvokeargument name="password" value="#form.password#" />	<!---Type:String Hint:  - varchar (50) --->
					<cfinvokeargument name="createdBy" value="#session.login.getUser()#" />	<!---Type:String Hint:  - varchar (100) --->
				</cfinvoke>	
			<cfelse>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/admin/userManagement/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="User Already Exists." />
				</cfinvoke>		
				
				<cflocation url="#application.settings.appBaseDir#/admin/userManagement/user.cfm?userID=#variables.user.userID#" />
			</cfif>			
			
			<cflocation url="#application.settings.appBaseDir#/admin/userManagement/user.cfm?userID=#variables.addUserRet.userID#" />
		
		</cfcase>
		<cfcase value="updateUserPassword">
			
			<cfif NOT structKeyExists(form,"userid") OR NOT len(trim(form.userid))>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/admin/userManagement/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="UserID is required." />
				</cfinvoke>
			</cfif>
			
			<cfif session.messenger.hasAlerts()>
				<cflocation url="#application.settings.appBaseDir#/admin/userManagement/" />
			</cfif>
			
			<cfif NOT structKeyExists(form,"password") OR NOT len(trim(form.password))>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/admin/userManagement/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="Password is required." />
				</cfinvoke>
			</cfif>
			
			<cfif NOT structKeyExists(form,"password2") OR NOT len(trim(form.password2))>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/admin/userManagement/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="Password Again is required." />
				</cfinvoke>
			</cfif>
			
			<cfif structKeyExists(form,"password") AND structKeyExists(form,"password2") AND len(trim(form.password)) AND len(trim(form.password2))>
				<cfif form.password NEQ form.password2>
					<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
						<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/admin/userManagement/action.cfm" />
						<cfinvokeargument name="messageType" value="Error" />
						<cfinvokeargument name="messageText" value="Passwords do not match." />
					</cfinvoke>
				</cfif>
			</cfif>
			
			<cfif session.messenger.hasAlerts()>
				<cflocation url="#application.settings.appBaseDir#/admin/userManagement/user.cfm?userid=#form.userid#" />
			</cfif>
				
			
			<cfinvoke component="#application.daos.userManagement#" method="updateUserPassword" returnvariable="updateUserRet">
				<cfinvokeargument name="dsn" value="#application.settings.dsn#" />	<!---Type:string  --->
				<cfinvokeargument name="userID" value="#form.userID#" />	<!---Type:numeric Hint:  - bigint --->
				<cfinvokeargument name="password" value="#form.password#" />	<!---Type:String Hint:  - varchar (100) --->
			</cfinvoke>

			<cflocation url="#application.settings.appBaseDir#/admin/userManagement/user.cfm?userID=#form.userID#" />
		</cfcase>
		
		<cfcase value="removeUserFromGroup">
		
			<cfif structKeyExists(form,"userGroupMemberID") AND len(trim(form.userGroupMemberID))>
				<cfinvoke component="#application.daos.userManagement#" method="removeUserFromGroup" returnvariable="variables.removeUserFromGroupRet">
					<cfinvokeargument name="dsn" value="#application.settings.dsn#" />	<!---Type:string  --->
					<cfinvokeargument name="userGroupMemberID" value="#form.userGroupMemberID#" />
				</cfinvoke>
			</cfif>
			
			<cfif structKeyExists(form,"userID")>
				<cflocation url="#application.settings.appBaseDir#/admin/userManagement/user.cfm?userID=#form.userID#" />
			<cfelse>
				<cflocation url="#application.settings.appBaseDir#/admin/userManagement/search.cfm" />
			</cfif>
		
		</cfcase>
		
		<cfcase value="removeUserGroup">
		
			<cfif structKeyExists(form,"userGroupID") AND len(trim(form.userGroupID))>
				<cfinvoke component="#application.daos.userManagement#" method="removeUserGroup" returnvariable="variables.removeUserGroupRet">
					<cfinvokeargument name="dsn" value="#application.settings.dsn#" />	<!---Type:string  --->
					<cfinvokeargument name="userGroupID" value="#form.userGroupID#" />
				</cfinvoke>
				
				<cfif NOT variables.removeUserGroupRet>
					<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
						<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/admin/userManagement/action.cfm" />
						<cfinvokeargument name="messageType" value="Error" />
						<cfinvokeargument name="messageText" value="Group cannot be removed because it has one or more members." />
					</cfinvoke>
				</cfif>
			</cfif>
			
			<cflocation url="#application.settings.appBaseDir#/admin/userManagement/userGroups.cfm" />
		
		</cfcase>
		
		<cfcase value="addUserToGroup">
			
			<cfif NOT structKeyExists(form,"userID") OR NOT len(trim(form.userID))>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/admin/userManagement/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="User ID is required." />
				</cfinvoke>
			</cfif>
			
			<cfif session.messenger.hasAlerts()>
				<cflocation url="#application.settings.appBaseDir#/admin/userManagement/search.cfm" />
			</cfif>
			
			<cfif NOT structKeyExists(form,"userGroupID") OR NOT len(trim(form.userGroupID))>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/admin/userManagement/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="User Group is required." />
				</cfinvoke>
			</cfif>
			
			<cfif session.messenger.hasAlerts()>
				<cflocation url="#application.settings.appBaseDir#/admin/userManagement/user.cfm?userID=#form.userID#" />
			</cfif>
			
			<cfinvoke component="#application.daos.userManagement#" method="addUserToGroup" returnvariable="variables.addUserToGroupRet">
				<cfinvokeargument name="dsn" value="#application.settings.dsn#" />	<!---Type:string  --->
				<cfinvokeargument name="userID" value="#form.userID#" />
				<cfinvokeargument name="userGroupID" value="#form.userGroupID#" />
			</cfinvoke>
			
			<cflocation url="#application.settings.appBaseDir#/admin/userManagement/user.cfm?userID=#form.userID#" />
		
		</cfcase>
		
		<cfcase value="updateUser">
		
			<cfif NOT structKeyExists(form,"userID") OR NOT len(trim(form.userID))>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/admin/userManagement/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="User ID is required." />
				</cfinvoke>
			</cfif>
			
			<cfif session.messenger.hasAlerts()>
				<cflocation url="#application.settings.appBaseDir#/admin/userManagement/search.cfm" />
			</cfif>
		
			<cfif NOT structKeyExists(form,"username") OR NOT len(trim(form.username))>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/admin/userManagement/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="Username is required." />
				</cfinvoke>
			</cfif>
			
			<cfif NOT structKeyExists(form,"firstname") OR NOT len(trim(form.firstname))>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/admin/userManagement/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="Firstname is required." />
				</cfinvoke>
			</cfif>
			
			<cfif NOT structKeyExists(form,"lastname") OR NOT len(trim(form.lastname))>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/admin/userManagement/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="Lastname is required." />
				</cfinvoke>
			</cfif>
			
			<cfif NOT structKeyExists(form,"email") OR NOT len(trim(form.email))>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/admin/userManagement/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="Email is required." />
				</cfinvoke>
			<cfelseif NOT isValid("email",form.email)>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/admin/userManagement/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="Email must be a correctly formatted email address." />
				</cfinvoke>
			</cfif>
			
			<cfif session.messenger.hasAlerts()>
				<cflocation url="#application.settings.appBaseDir#/admin/userManagement/user.cfm?userID=#form.userID#" />
			</cfif>
			
			<cfinvoke component="#application.daos.userManagement#" method="updateUser" returnvariable="updateUserRet">
				<cfinvokeargument name="dsn" value="#application.settings.dsn#" />	<!---Type:string  --->
				<cfinvokeargument name="userID" value="#form.userID#" />	<!---Type:numeric Hint:  - bigint --->
				<cfinvokeargument name="username" value="#form.username#" />	<!---Type:String Hint:  - varchar (100) --->
				<cfinvokeargument name="email" value="#form.email#" />	<!---Type:String Hint:  - varchar (255) --->
				<cfinvokeargument name="firstname" value="#form.firstname#" />	<!---Type:String Hint:  - varchar (50) --->
				<cfinvokeargument name="lastname" value="#form.lastname#" />	<!---Type:String Hint:  - varchar (50) --->
				<cfinvokeargument name="updatedBy" value="#session.login.getUser()#" />	<!---Type:String Hint:  - varchar (100) --->
			</cfinvoke>

			<cflocation url="#application.settings.appBaseDir#/admin/userManagement/user.cfm?userID=#form.userID#" />
			
		</cfcase>
		
		<cfcase value="addUserGroup">
		
			<cfset populateTempFormVariables(form,"addUserGroupForm") />
			
			<cfif NOT structKeyExists(form,"userGroupName") OR NOT len(trim(form.userGroupName))>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/admin/userManagement/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="User Group Name is required." />
				</cfinvoke>
			</cfif>
			
			<cfif NOT structKeyExists(form,"userGroupDesc") OR NOT len(trim(form.userGroupDesc))>
				<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
					<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/admin/userManagement/action.cfm" />
					<cfinvokeargument name="messageType" value="Error" />
					<cfinvokeargument name="messageText" value="User Group Description is required." />
				</cfinvoke>
			</cfif>
			
			<cfif session.messenger.hasAlerts()>
				<cflocation url="#application.settings.appBaseDir#/admin/userManagement/userGroups.cfm" />
			<cfelse>
				<cfset structClear(session.tempFormVars.addUserGroupForm) />
			</cfif>
			
			
			<cfinvoke component="#application.daos.userManagement#" method="addUserGroup" returnvariable="addUserGroupRet">
				<cfinvokeargument name="dsn" value="#application.settings.dsn#" />	<!---Type:string  --->
				<cfinvokeargument name="userGroupName" value="#form.userGroupName#" />	<!---Type:String Hint:  - varchar (50) --->
				<cfinvokeargument name="userGroupDesc" value="#form.userGroupDesc#" />	<!---Type:String Hint:  - varchar (250) --->
			</cfinvoke>

			<cflocation url="#application.settings.appBaseDir#/admin/userManagement/userGroups.cfm" />
		
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
