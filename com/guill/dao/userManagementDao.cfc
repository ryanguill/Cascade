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
	
	<cffunction name="getUserGroups" access="public" returntype="query" output="false" hint="">
    	<cfargument name="dsn" type="string" required="True" />
    	
		<cfset var qGetUserGroups = "" />
		
        <cftry>
        	<cfquery name="qGetUserGroups" datasource="#arguments.dsn#">
        		SELECT
					  userGroups.userGroupID	 --  char(35) 
					, userGroups.userGroupName	 --  varchar (50)
					, userGroups.userGroupDesc	 --  varchar (250)
					
					, COUNT(userGroupMemberID) memberCount
				FROM userGroups 
				LEFT OUTER
					JOIN userGroupMembers 
					ON userGroups.userGroupID = userGroupMembers.userGroupID        
				GROUP BY
					  userGroups.userGroupID	 --  char(35) 
					, userGroups.userGroupName	 --  varchar (50)
					, userGroups.userGroupDesc	 --  varchar (250)	
        	</cfquery>
        <cfcatch>
        	<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
        <cfrethrow />
        </cfcatch>
        </cftry>

    <cfreturn qGetUserGroups />	
    </cffunction>

	<cffunction name="getUserGroupByUserGroupID" access="public" returntype="query" output="false" hint="">
    	<cfargument name="dsn" type="string" required="True" />
		<cfargument name="userGroupID" type="string" required="true" />
    	
		<cfset var qGetUserGroups = "" />
		
        <cftry>
        	<cfquery name="qGetUserGroups" datasource="#arguments.dsn#">
        		SELECT
					  userGroups.userGroupID	 --  char(35) 
					, userGroups.userGroupName	 --  varchar (50)
					, userGroups.userGroupDesc	 --  varchar (250)
					
					, COUNT(userGroupMemberID) memberCount
				FROM userGroups 
				LEFT OUTER
					JOIN userGroupMembers 
					ON userGroups.userGroupID = userGroupMembers.userGroupID
				WHERE
					userGroups.userGroupID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userGroupID#" />  
				GROUP BY
					  userGroups.userGroupID	 --  char(35) 
					, userGroups.userGroupName	 --  varchar (50)
					, userGroups.userGroupDesc	 --  varchar (250)	
        	</cfquery>
        <cfcatch>
        	<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
        <cfrethrow />
        </cfcatch>
        </cftry>

    <cfreturn qGetUserGroups />	
    </cffunction>
	
	<cffunction name="addUserGroup" access="public" returntype="query" output="false" hint="">
    	<cfargument name="dsn" type="string" required="True" />
    	<cfargument name="userGroupName" type="String" required="true" hint=" - varchar (50)" />
		<cfargument name="userGroupDesc" type="String" required="true" hint=" - varchar (250)" />

		<cfset var qAddUserGroup = "" />
		<cfset var nextUserGroupID = createUUID() />
		
        <cftry>
        	<cfquery name="qAddUserGroup" datasource="#arguments.dsn#">
        		INSERT INTO userGroups
				(
					  userGroupID	 --  char(35) 
					, userGroupName	 --  varchar (50)
					, userGroupDesc	 --  varchar (250)
					
				)
				VALUES
				(
					  <cfqueryparam cfsqltype="cf_sql_char" value="#nextUserGroupID#" />  -- userGroupID 
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userGroupName#" />  -- userGroupName 
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userGroupDesc#" />  -- userGroupDesc 
					
				)        	
        	</cfquery>
        <cfcatch>
        	<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
        <cfrethrow />
        </cfcatch>
        </cftry>

	<cfreturn getUserGroupByUserGroupID(arguments.dsn,nextUserGroupID) />    	
    </cffunction>
	
	<cffunction name="updateUserGroup" access="public" returntype="query" output="false" hint="">
    	<cfargument name="dsn" type="string" required="True" />
    	<cfargument name="userGroupID" type="string" required="true" hint=" - char(35) " />
		<cfargument name="userGroupName" type="String" required="true" hint=" - varchar (50)" />
		<cfargument name="userGroupDesc" type="String" required="true" hint=" - varchar (250)" />

		<cfset var qUpdateUserGroup = "" />
		
        <cftry>
        	<cfquery name="qUpdateUserGroup" datasource="#arguments.dsn#">
        		UPDATE userGroups
				SET
					  userGroupName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userGroupName#" />	 --  varchar (50)
					, userGroupDesc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userGroupDesc#" />	 --  varchar (250)
					
				WHERE
					userGroupID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userGroupID#" />	 --  char(35) 
        	
        	</cfquery>
        <cfcatch>
        	<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
        <cfrethrow />
        </cfcatch>
        </cftry>

    <cfreturn getUserGroupByUserGroupID(arguments.dsn,nextUserGroupID) />   	
    </cffunction>
	
	<cffunction name="removeUserGroup" access="public" returntype="boolean" output="false" hint="">
    	<cfargument name="dsn" type="string" required="True" />
    	<cfargument name="userGroupID" type="string" required="true" hint=" - char(35) " />
		
		<cfset var qRemoveUserGroup = "" />
		<cfset var userGroupByUserGroupID = getUserGroupByUserGroupID(arguments.dsn,arguments.userGroupID) />
		
		<cfif userGroupByUserGroupID.memberCount EQ 0>
	        <cftry>
	        	<cfquery name="qRemoveUserGroup" datasource="#arguments.dsn#">
	        		DELETE 
					FROM
						userGroups
					WHERE
						userGroupID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userGroupID#" />	 --  char(35) 
	        	
	        	</cfquery>
	        <cfcatch>
	        	<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
	        <cfrethrow />
	        </cfcatch>
	        </cftry>
		<cfelse>
			<cfreturn false />
		</cfif>

    <cfreturn true />   	
    </cffunction>
	
	<cffunction name="getUserGroupMembers" access="public" returntype="query" output="false" hint="">
    	<cfargument name="dsn" type="string" required="True" />
    	<cfargument name="userGroupID" type="string" required="true" hint=" - char(35) " />
		
		<cfset var qGetUserGroupMembers = "" />
		
        <cftry>
        	<cfquery name="qGetUserGroupMembers" datasource="#arguments.dsn#">
        		SELECT
					  userGroupMembers.userGroupMemberID	 --  char(35) 
					, userGroupMembers.userID		 --  char(35) 
					, userGroupMembers.userGroupID		 --  char(35) 
					
					, userGroups.userGroupName	 --  varchar (50)
					, userGroups.userGroupDesc	 --  varchar (250)
					
					, users.username	 --  varchar (100)
					, users.email		 --  varchar (255)
					, users.firstname		 --  varchar (50)
					, users.lastname		 --  varchar (50)
					
				FROM userGroupMembers 
        		INNER
					JOIN userGroups 
        			ON userGroups.userGroupID = userGroupMembers.userGroupID
				INNER
					JOIN users 
					ON userGroupMembers.userID = users.userID
				WHERE
					userGroupMembers.userGroupID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userGroupID#" />	 --  char(35) 
        	</cfquery>
        <cfcatch>
        	<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
        <cfrethrow />
        </cfcatch>
        </cftry>

	<cfreturn qGetUserGroupMembers />    	
    </cffunction>
	
	<cffunction name="getUserGroupsForUserID" access="public" returntype="query" output="false" hint="">
    	<cfargument name="dsn" type="string" required="True" />
    	<cfargument name="userID" type="string" required="true" hint=" - char(35) " />
		
		<cfset var qGetUserGroupsForUserID = "" />
		
        <cftry>
        	<cfquery name="qGetUserGroupsForUserID" datasource="#arguments.dsn#">
        		SELECT
					  userGroupMembers.userGroupMemberID	 --  char(35) 
					, userGroupMembers.userID		 --  char(35) 
					, userGroupMembers.userGroupID		 --  char(35) 
					
					, userGroups.userGroupName	 --  varchar (50)
					, userGroups.userGroupDesc	 --  varchar (250)
					
					, users.username	 --  varchar (100)
					, users.email		 --  varchar (255)
					, users.firstname		 --  varchar (50)
					, users.lastname		 --  varchar (50)
					
				FROM userGroupMembers 
        		INNER
					JOIN userGroups 
        			ON userGroups.userGroupID = userGroupMembers.userGroupID
				INNER
					JOIN users 
					ON userGroupMembers.userID = users.userID
				WHERE
					userGroupMembers.userID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#" />	 --  char(35) 
        	</cfquery>
        <cfcatch>
        	<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
        <cfrethrow />
        </cfcatch>
        </cftry>

	<cfreturn qGetUserGroupsForUserID />    	
    </cffunction>
	
	<cffunction name="getAvailableUserGroupsForUserID" access="public" returntype="query" output="false" hint="">
    	<cfargument name="dsn" type="string" required="True" />
    	<cfargument name="userID" type="string" required="true" hint=" - char(35) " />
		
		<cfset var qGetAvailableUserGroupsForUserID = "" />
		
        <cftry>
        	<cfquery name="qGetAvailableUserGroupsForUserID" datasource="#arguments.dsn#">
        		SELECT
					  userGroups.userGroupID	 --  char(35) 
					, userGroups.userGroupName	 --  varchar (50)
					, userGroups.userGroupDesc	 --  varchar (250)
					
					, COUNT(userGroupMemberID) memberCount
				FROM userGroups 
				LEFT OUTER
					JOIN userGroupMembers 
					ON userGroups.userGroupID = userGroupMembers.userGroupID
				WHERE
					NOT EXISTS
					(
						SELECT 1
						FROM userGroupMembers
						WHERE
							userGroupMembers.userGroupID = userGroups.userGroupID
						AND
							userGroupMembers.userID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#" />
					)  
				GROUP BY
					  userGroups.userGroupID	 --  char(35) 
					, userGroups.userGroupName	 --  varchar (50)
					, userGroups.userGroupDesc	 --  varchar (250)	
        	</cfquery>
        <cfcatch>
        	<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
        <cfrethrow />
        </cfcatch>
        </cftry>

	<cfreturn qGetAvailableUserGroupsForUserID />    	
    </cffunction>
	
	<cffunction name="getUserGroupMemberByUserGroupMemberID" access="public" returntype="query" output="false" hint="">
    	<cfargument name="dsn" type="string" required="True" />
    	<cfargument name="userGroupMemberID" type="string" required="true" hint=" - char(35) " />
		
		<cfset var qGetUserGroupMemberByUserGroupMemberID = "" />
		
        <cftry>
        	<cfquery name="qGetUserGroupMemberByUserGroupMemberID" datasource="#arguments.dsn#">
        		SELECT
					  userGroupMembers.userGroupMemberID	 --  char(35) 
					, userGroupMembers.userID		 --  char(35) 
					, userGroupMembers.userGroupID		 --  char(35) 
					
					, userGroups.userGroupName	 --  varchar (50)
					, userGroups.userGroupDesc	 --  varchar (250)
					
					, users.username	 --  varchar (100)
					, users.email		 --  varchar (255)
					, users.firstname		 --  varchar (50)
					, users.lastname		 --  varchar (50)
					
				FROM userGroupMembers 
        		INNER
					JOIN userGroups 
        			ON userGroups.userGroupID = userGroupMembers.userGroupID
				INNER
					JOIN users 
					ON userGroupMembers.userID = users.userID
				WHERE
					userGroupMembers.userGroupMemberID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userGroupMemberID#" />	 --  char(35) 
        	</cfquery>
        <cfcatch>
        	<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
        <cfrethrow />
        </cfcatch>
        </cftry>

	<cfreturn qGetUserGroupMemberByUserGroupMemberID />    	
    </cffunction>
	
	<cffunction name="addUserToGroup" access="public" returntype="query" output="false" hint="">
    	<cfargument name="dsn" type="string" required="True" />
    	<cfargument name="userID" type="string" required="true" hint=" - char(35) " />
		<cfargument name="userGroupID" type="string" required="true" hint=" - char(35) " />
		
		<cfset var qAddUserToGroup = "" />
		<cfset var nextUserGroupMemberID = createUUID() />
		
        <cftry>
        	<cfquery name="qAddUserToGroup" datasource="#arguments.dsn#">
        		INSERT INTO userGroupMembers
				(
					  userGroupMemberID	 --  char(35) 
					, userID		 --  char(35) 
					, userGroupID		 --  char(35) 					
				)
				VALUES
				(
					  <cfqueryparam cfsqltype="cf_sql_char" value="#nextUserGroupMemberID#" />  -- userGroupMemberID 
					, <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#" />  -- userID 
					, <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userGroupID#" />  -- userGroupID 					
				)
        	</cfquery>
        <cfcatch>
        	<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
        <cfrethrow />
        </cfcatch>
        </cftry>

    <cfreturn getUserGroupMemberByUserGroupMemberID(arguments.dsn,nextUserGroupMemberID) />
    </cffunction>
	
	<cffunction name="removeUserFromGroup" access="public" returntype="boolean" output="false" hint="">
    	<cfargument name="dsn" type="string" required="True" />
    	<cfargument name="userGroupMemberID" type="string" required="true" hint=" - char(35) " />
		
		<cfset var qRemoveUserFromGroup = "" />
		
        <cftry>
        	<cfquery name="qRemoveUserFromGroup" datasource="#arguments.dsn#">
        		DELETE
        		FROM userGroupMembers 
				WHERE
					userGroupMembers.userGroupMemberID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userGroupMemberID#" />	 --  char(35)         	
        	</cfquery>
        <cfcatch>
        	<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
        <cfrethrow />
        </cfcatch>
        </cftry>

    <cfreturn True />
    </cffunction>
	
	<cffunction name="getAllUsers" access="public" returntype="query" output="false" hint="">
    	<cfargument name="dsn" type="string" required="True" />
    	
		<cfset var qGetAllUsers = "" />
		
        <cftry>
        	<cfquery name="qGetAllUsers" datasource="#arguments.dsn#">
        		SELECT
					  users.userID	 --  char(35) 
					, users.username	 --  varchar (100)
					, users.email		 --  varchar (255)
					, users.firstname	 --  varchar (50)
					, users.lastname	 --  varchar (50)
					, users.createdBy	 --  varchar (100)
					, users.createdOn	 --  datetime 
					, users.lastUpdatedBy	 --  varchar (100)
					, users.lastUpdatedOn	 --  datetime 
					, users.passwordLastSetOn  -- - datetime 
					
				FROM users
				ORDER BY
					users.username ASC 
        	
        	</cfquery>
        <cfcatch>
        	<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
        <cfrethrow />
        </cfcatch>
        </cftry>

	<cfreturn qGetAllUsers />    	
    </cffunction>
	
	<cffunction name="searchUsers" access="public" returntype="query" output="false" hint="">
    	<cfargument name="dsn" type="string" required="True" />
		<cfargument name="searchString" type="String" required="True" />
    	
		<cfset var qGetAllUsers = "" />
		
        <cftry>
        	<cfquery name="qGetAllUsers" datasource="#arguments.dsn#">
        		SELECT
					  users.userID	 --  char(35) 
					, users.username	 --  varchar (100)
					, users.email		 --  varchar (255)
					, users.firstname	 --  varchar (50)
					, users.lastname	 --  varchar (50)
					, users.createdBy	 --  varchar (100)
					, users.createdOn	 --  datetime 
					, users.lastUpdatedBy	 --  varchar (100)
					, users.lastUpdatedOn	 --  datetime 
					, users.passwordLastSetOn  -- - datetime 
					
				FROM users
				WHERE
					users.userID LIKE <cfqueryparam cfsqltype="cf_sql_char" value="%#arguments.searchString#%" />
				OR	
					users.username LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchString#%" />
				OR
					users.email LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchString#%" />
				OR
					users.firstname || ' ' || users.lastname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchString#%" />
				ORDER BY
					users.username ASC 
        	
        	</cfquery>
        <cfcatch>
        	<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
        <cfrethrow />
        </cfcatch>
        </cftry>

	<cfreturn qGetAllUsers />    	
    </cffunction>
	
	<cffunction name="getUserByUserID" access="public" returntype="query" output="false" hint="">
    	<cfargument name="dsn" type="string" required="True" />
		<cfargument name="userID" type="string" required="True" />
    	
		<cfset var qGetUserByUserID = "" />
		
        <cftry>
        	<cfquery name="qGetUserByUserID" datasource="#arguments.dsn#">
        		SELECT
					  users.userID	 --  char(35) 
					, users.username	 --  varchar (100)
					, users.email		 --  varchar (255)
					, users.firstname	 --  varchar (50)
					, users.lastname	 --  varchar (50)
					, users.createdBy	 --  varchar (100)
					, users.createdOn	 --  datetime 
					, users.lastUpdatedBy	 --  varchar (100)
					, users.lastUpdatedOn	 --  datetime 
					, users.passwordLastSetOn  -- - datetime 
					
				FROM users
				WHERE
					users.userID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#" />        	
        	</cfquery>
        <cfcatch>
        	<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
        <cfrethrow />
        </cfcatch>
        </cftry>

	<cfreturn qGetUserByUserID />    	
    </cffunction>
	
	<cffunction name="getUserByUsername" access="public" returntype="query" output="false" hint="">
    	<cfargument name="dsn" type="string" required="True" />
		<cfargument name="username" type="string" required="True" />
    	
		<cfset var qGetUserByUsername = "" />
		
        <cftry>
        	<cfquery name="qGetUserByUsername" datasource="#arguments.dsn#">
        		SELECT
					  users.userID	 --  char(35) 
					, users.username	 --  varchar (100)
					, users.email		 --  varchar (255)
					, users.firstname	 --  varchar (50)
					, users.lastname	 --  varchar (50)
					, users.createdBy	 --  varchar (100)
					, users.createdOn	 --  datetime 
					, users.lastUpdatedBy	 --  varchar (100)
					, users.lastUpdatedOn	 --  datetime 
					, users.passwordLastSetOn  -- - datetime 
					
				FROM users
				WHERE
					users.username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#" />        	
        	</cfquery>
        <cfcatch>
        	<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
        <cfrethrow />
        </cfcatch>
        </cftry>

	<cfreturn qGetUserByUsername />    	
    </cffunction>
	
	
	<cffunction name="authenticateUser" access="public" returntype="query" output="false" hint="">
    	<cfargument name="dsn" type="string" required="True" />
		<cfargument name="username" type="string" required="True" />
		<cfargument name="password" type="string" required="True" />
    	
		<cfset var qAuthenticateUser = "" />
		
        <cftry>
        	<cfquery name="qAuthenticateUser" datasource="#arguments.dsn#">
        		SELECT
					  users.userID	 --  char(35) 
					, users.username	 --  varchar (100)
					, users.email		 --  varchar (255)
					, users.firstname	 --  varchar (50)
					, users.lastname	 --  varchar (50)
					, users.createdBy	 --  varchar (100)
					, users.createdOn	 --  datetime 
					, users.lastUpdatedBy	 --  varchar (100)
					, users.lastUpdatedOn	 --  datetime 
					, users.passwordLastSetOn  -- - datetime 
					
				FROM users
				WHERE
					users.username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#" /> 
				AND
					users.password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#hashPassword(arguments.password)#" />       	
        	</cfquery>
        <cfcatch>
        	<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
        <cfrethrow />
        </cfcatch>
        </cftry>

	<cfreturn qAuthenticateUser />    	
    </cffunction>
	
	<cffunction name="addUser" access="public" returntype="query" output="false" hint="">
    	<cfargument name="dsn" type="string" required="True" />
    	<cfargument name="username" type="String" required="true" hint=" - varchar (100)" />
		<cfargument name="email" type="String" required="true" hint=" - varchar (255)" />
		<cfargument name="firstname" type="String" required="true" hint=" - varchar (50)" />
		<cfargument name="lastname" type="String" required="true" hint=" - varchar (50)" />
		<cfargument name="password" type="String" required="true" hint=" - varchar (100)" />
		<cfargument name="createdBy" type="String" required="true" hint=" - varchar (100)" />
		
		<cfset var qAddUser = "" />
		<cfset var nextUserID = createUUID() />
		<cfset var currentTimestamp = now() />
		
        <cftry>
        	<cfquery name="qAddUser" datasource="#arguments.dsn#">
        		INSERT INTO users
				(
					  userID	 --  char(35) 
					, username	 --  varchar (100)
					, email		 --  varchar (255)
					, firstname	 --  varchar (50)
					, lastname	 --  varchar (50)
					, password  /*	- varchar (100
					, createdBy	 --  varchar (100)
					, createdOn	 --  datetime 
					, lastUpdatedBy	 --  varchar (100)
					, lastUpdatedOn	 --  datetime 
					, passwordLastSetOn  -- - datetime 
					
					
				)
				VALUES
				(
					  <cfqueryparam cfsqltype="cf_sql_char" value="#nextUserID#" />  -- userID 
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#" />  -- username 
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.email#" />  -- email 
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.firstname#" />  -- firstname 
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.lastname#" />  -- lastname 
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#hashPassword(arguments.password)#" />  -- password
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.createdBy#" />  -- createdBy 
					, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#currentTimestamp#" />  -- createdOn 
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.createdBy#" />  -- lastUpdatedBy 
					, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#currentTimestamp#" />  -- lastUpdatedOn 
					, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#currentTimestamp#" />  -- passwordLastSetOn 
					
				)
        	</cfquery>
        <cfcatch>
        	<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
        	<!---<cfrethrow />--->
			<cfabort />
        </cfcatch>
        </cftry>

    <cfreturn getUserByUserID(arguments.dsn,nextUserID) />
    </cffunction>
	
	<cffunction name="updateUser" access="public" returntype="query" output="false" hint="">
    	<cfargument name="dsn" type="string" required="True" />
		<cfargument name="userID" type="string" required="true" hint=" - char(35)" />
    	<cfargument name="username" type="String" required="true" hint=" - varchar (100)" />
		<cfargument name="email" type="String" required="true" hint=" - varchar (255)" />
		<cfargument name="firstname" type="String" required="true" hint=" - varchar (50)" />
		<cfargument name="lastname" type="String" required="true" hint=" - varchar (50)" />
		<cfargument name="updatedBy" type="String" required="true" hint=" - varchar (100)" />
    	
		<cfset var qUpdateUser = "" />
		
        <cftry>
        	<cfquery name="qUpdateUser" datasource="#arguments.dsn#">
        		UPDATE users
				SET
					  username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#" />	 --  varchar (100)
					, email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.email#" />		 --  varchar (255)
					, firstname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.firstname#" />	 --  varchar (50)
					, lastname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.lastname#" />	 --  varchar (50)
					, lastUpdatedBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.updatedBy#" />	 --  varchar (100)
					, lastUpdatedOn = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#" />	 --  datetime 					
				WHERE
					userID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#" />	 --  char(35) 
        	
        	</cfquery>
        <cfcatch>
        	<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
        <cfrethrow />
        </cfcatch>
        </cftry>

	<cfreturn getUserByUserID(arguments.dsn,arguments.userID) />
    </cffunction>
	
	
	<cffunction name="updateUserPassword" access="public" returntype="query" output="false" hint="">
    	<cfargument name="dsn" type="string" required="True" />
		<cfargument name="userID" type="string" required="true" hint=" - char(35)" />
    	<cfargument name="password" type="String" required="true" hint=" - varchar (100)" />
    	
		<cfset var qUpdateUser = "" />
		
        <cftry>
        	<cfquery name="qUpdateUser" datasource="#arguments.dsn#">
        		UPDATE users
				SET
					  password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#hashPassword(arguments.password)#" />	 --  varchar (100)
					, passwordLastSetOn = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#" />	 --  datetime 					
				WHERE
					userID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#" />	 --  char(35) 
        	
        	</cfquery>
        <cfcatch>
        	<cfthrow message="Query failed. Message: #cfcatch.Message# Detail: #cfcatch.Detail#" />
        <cfrethrow />
        </cfcatch>
        </cftry>

	<cfreturn getUserByUserID(arguments.dsn,arguments.userID) />
    </cffunction>
	
	<cffunction name="hashPassword" access="public" returntype="string" output="false">
		<cfargument name="password" type="string" required="true" />
		
	<cfreturn hash(arguments.password) />
	</cffunction>
	
	

</cfcomponent>