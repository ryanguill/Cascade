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

<cfcomponent output="false">
	<cfsilent>
		
		<!--- Constructor Methods --->
		<cffunction name="init" access="public" returntype="any" output="false">
			<cfargument name="userManagementDao" type="any" required="true" />
			
			<cfset variables.instance = structNew() />			
			<cfset createInstance() />
			<cfset setUserManagementDao(arguments.userManagementDao) />
			
		
		<cfreturn This />
		</cffunction>
		
		<!--- Public Methods --->
		
		<cffunction name="validateAndLogin" access="public" returntype="boolean" output="false">
			<cfargument name="dsn" type="string" required="True" />
			<cfargument name="username" type="string" required="true" />
			<cfargument name="password" type="string" required="True" />
			
			<cfset var addUserRet = "" />
			<cfset var getUserGroupsForUserIDRet = "" />
			
			<cfset var authenticateUserRet = "" />
			
			<cfinvoke component="#getUserManagementDao()#" method="authenticateUser" returnvariable="authenticateUserRet">
				<cfinvokeargument name="dsn" value="#arguments.dsn#" />
				<cfinvokeargument name="username" value="#arguments.username#" />
				<cfinvokeargument name="password" value="#arguments.password#" />
			</cfinvoke>
		
			<cfif authenticateUserRet.recordCount>
				<cfset variables.instance.loggedIn  = True />
				
				<cfset variables.instance.username = authenticateUserRet.username />
				<cfset variables.instance.firstname = authenticateUserRet.firstname />
				<cfset variables.instance.lastname = authenticateUserRet.lastname />
				<cfset variables.instance.email = authenticateUserRet.email />
				
				<cfinvoke component="#getUserManagementDao()#" method="getUserGroupsForUserID" returnvariable="getUserGroupsForUserIDRet">
					<cfinvokeargument name="dsn" value="#arguments.dsn#" />	<!---Type:string  --->
					<cfinvokeargument name="userID" value="#authenticateUserRet.userID#" />	<!---Type:Numeric Hint:  - bigint  --->
				</cfinvoke>
				
				<cfloop query="getUserGroupsForUserIDRet">
					<cfset arrayAppend(variables.instance.groups,ucase(getUserGroupsForUserIDRet.userGroupName)) />
					<cfif getUserGroupsForUserIDRet.userGroupName EQ "Admin" OR getUserGroupsForUserIDRet.userGroupName EQ "Administrators">
						<cfset variables.instance.isAdmin = true />
					</cfif>
				</cfloop>		
							
				
				<cfset variables.instance.userID = authenticateUserRet.userID />
				<cfset variables.instance.createdOn = authenticateUserRet.createdOn />
				<cfset variables.instance.lastModified = authenticateUserRet.lastUpdatedOn />
				<cfset variables.instance.passwordLastSetOn = authenticateUserRet.passwordLastSetOn />
				<cfset variables.instance.loginTime = now() />
				<cfset variables.instance.currentArea = "" />
								
				<cfreturn True />
			<cfelse>			
				<cfreturn False />
			</cfif>
		</cffunction>
		
		<cffunction name="setUserManagementDao" access="private" returntype="void" output="false">
			<cfargument name="userManagementDao" type="any" required="true" />
			
			<cfset variables.instance.userManagementDao = arguments.userManagementDao />
			
		</cffunction>
		
		<cffunction name="getUserManagementDao" access="public" returntype="any" output="false">
		
		<cfreturn variables.instance.userManagementDao />
		</cffunction>
		
		<cffunction name="logout" access="public" returntype="void" output="false">
			
			<cfset createInstance() />
		
		</cffunction>
				
		<cffunction name="isLoggedIn" access="public" returntype="boolean" output="false">
		
		<cfreturn variables.instance.loggedIn />
		</cffunction>		
		
		<cffunction name="getUsername" access="public" returntype="string" output="false">
		
		<cfreturn variables.instance.username />
		</cffunction>
		
		<cffunction name="getUser" access="public" returntype="string" output="false">
		
		<cfreturn variables.instance.username />
		</cffunction>
		
		<cffunction name="getEmail" access="public" returntype="string" output="false">
		
		<cfreturn variables.instance.email />
		</cffunction>
		
		<cffunction name="getFirstname" access="public" returntype="string" output="false">
			
		<cfreturn variables.instance.firstname />
		</cffunction>
		
		<cffunction name="getLastname" access="public" returntype="string" output="false">
			
		<cfreturn variables.instance.Lastname />
		</cffunction>
		
		<cffunction name="getFirstInitial" access="public" returntype="String" output="false">
		
		<cfreturn ucase(mid(variables.instance.firstname,1,1)) />
		</cffunction>
		
		<cffunction name="getFullname" access="public" returntype="string" output="False">
		
		<cfreturn variables.instance.firstname & " " & variables.instance.lastname />
		</cffunction>
		
		<cffunction name="getCreatedOn" access="public" returntype="date" output="False">
		
		<cfreturn variables.instance.createdOn />
		</cffunction>

		<cffunction name="getLastLoggedInOn" access="public" returntype="date" output="False">
		
		<cfreturn variables.instance.lastLoggedInOn />
		</cffunction>
		
		<cffunction name="getLastModified" access="public" returntype="date" output="False">
		
		<cfreturn variables.instance.LastModified />
		</cffunction>
		
		<cffunction name="getPasswordSetOn" access="public" returntype="date" output="False">
		
		<cfreturn variables.instance.PasswordLastSetOn />
		</cffunction>
		
		<cffunction name="getLoginTime" access="public" returntype="date" output="false">
		
		<cfreturn variables.instance.loginTime />
		</cffunction>
		
		<cffunction name="getUserID" access="public" returntype="string" output="False">
			
		<cfreturn variables.instance.userid />
		</cffunction>
		
		<cffunction name="setCurrentArea" access="public" returntype="void" output="false">
			<cfargument name="currentArea" type="string" required="True" />
			
			<cfset variables.instance.currentArea = arguments.currentArea />
			
		</cffunction>
		
		<cffunction name="getCurrentArea" access="public" returntype="string" output="False">
		
		<cfreturn variables.instance.currentArea />
		</cffunction>
		
		<cffunction name="getUserGroups" access="public" returntype="array" output="False">
		
		<cfreturn variables.instance.groups />
		</cffunction>
		
		<cffunction name="isUserInGroup" access="public" returntype="boolean" output="false">
			<cfargument name="groupName" type="string" required="True" />
			
			<cfset VAR groups = getUserGroups() />
			
			<cfif isAdmin()>
				<cfreturn true />
			</cfif>
			
			<cfloop from="1" to="#arrayLen(groups)#" index="i">
				<cfif trim(groups[i]) EQ trim(arguments.groupName)>
					<cfreturn True />
				</cfif>
			</cfloop>
			
		<cfreturn False />
		</cffunction>
		
		<!--- Package Methods --->
		
		<!--- Private Methods --->
		
		<cffunction name="setUserid" access="private" returntype="void" output="false">
			<cfargument name="userid" type="numeric" required="True" />
			
			<cfset variables.instance.userid = arguments.userid />
		</cffunction>
		
		<cffunction name="setUsername" access="private" returntype="void" output="false">
			<cfargument name="username" type="string" required="True" />
			
			<cfset variables.instance.username = arguments.username />
		</cffunction>
		
		<cffunction name="setEmail" access="private" returntype="void" output="false">
			<cfargument name="email" type="String" required="True" />
			
			<cfset variables.instance.email = arguments.email />
		</cffunction>
		
		<cffunction name="setFirstname" access="private" returntype="void" output="false">
			<cfargument name="firstname" type="String" required="True" />
			
			<cfset variables.instance.firstname = arguments.firstname />
		</cffunction>
		
		<cffunction name="setLastname" access="private" returntype="void" output="False">
			<cfargument name="lastname" type="string" required="True" />
			
			<cfset variables.instance.lastname = arguments.lastname />
		</cffunction>
		
		<cffunction name="setCreatedOn" access="private" returntype="void" output="false">
			<cfargument name="createdOn" type="date" required="True" />
			
			<cfset variables.instance.createdOn = arguments.createdOn />
		</cffunction>
		
		<cffunction name="setLastModified" access="private" returntype="void" output="false">
			<cfargument name="lastModified" type="Date" required="True" />
			
			<cfset variables.instance.lastModified = arguments.lastModified />
		</cffunction>
		
		<cffunction name="setLoginTime" access="private" returntype="void" output="false">
			<cfset variables.instance.loginTime = now() />
		</cffunction>
		
		<cffunction name="setCurrentPage" access="public" returntype="void" output="false">
			<cfargument name="currentPage" type="string" required="true" />
			
			<cfset variables.instance.currentPage = arguments.currentPage />
		
		</cffunction>
		
		<cffunction name="getCurrentPage" access="public" returntype="string" output="false">
			
		<cfreturn variables.instance.currentPage />
		</cffunction>
		
		<cffunction name="setReferringPage" access="public" returntype="void" output="false">
			<cfargument name="referringPage" type="string" required="true" />
			
			<cfset variables.instance.referringPage = arguments.referringPage />
		
		</cffunction>
		
		<cffunction name="getReferringPage" access="public" returntype="string" output="false">
			
		<cfreturn variables.instance.referringPage />
		</cffunction>
		
		<cffunction name="getPassword" access="public" returntype="string" output="false">
			
		<cfreturn variables.instance.password />
		</cffunction>
		
		<cffunction name="createInstance" access="private" returntype="void" output="false">
			
			<cfset variables.instance.loggedIn = False />
			<cfset variables.instance.userID = -1 />
			<cfset variables.instance.username = "" />
			<cfset variables.instance.password = "" />
			<cfset variables.instance.firstname = "Guest" />
			<cfset variables.instance.lastname = "" />
			<cfset variables.instance.email = "" />
			<cfset variables.instance.createdOn = createDate(1970,1,1) />
			<cfset variables.instance.lastModified = createDate(1970,1,1) />
			<cfset variables.instance.passwordLastSetOn = createDate(1970,1,1) />
			<cfset variables.instance.loginTime = createDate(1970,1,1) />
			<cfset variables.instance.currentArea = "" />
			<cfset variables.instance.currentPage = "" />
			<cfset variables.instance.referringPage = "" />
			<cfset variables.instance.isAdmin = false />
			
			
			<cfset variables.instance.groups = arrayNew(1) />
			
		</cffunction>
		
		<cffunction name="getInstance" access="public" returntype="struct" output="false" hint="">
        	
        <cfreturn variables.instance />
        </cffunction>
		
		<cffunction name="isAdmin" access="public" returntype="boolean" output="false">
			
		<cfreturn variables.instance.isAdmin />
		</cffunction>

		
	</cfsilent>
</cfcomponent>