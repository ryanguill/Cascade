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


<cfsilent>
	<cfset session.login.setCurrentArea("admin") />
	
	<cfinclude template="#application.settings.appBaseDir#/inc/preProcess.cfm" />
	
	<cfif NOT session.login.isUserInGroup("ADMIN")>
		<cflocation url="#application.settings.appBaseDir#" />
	</cfif>
	
	<cfinvoke component="#application.daos.referenceTables#" method="getAllCertificationTypes" returnvariable="variables.certificationTypes">
		<cfinvokeargument name="dsn" value="#application.config.dsn#" />
	</cfinvoke>
	
	<cfinvoke component="#application.daos.userManagement#" method="getUserGroups" returnvariable="variables.userGroups">
		<cfinvokeargument name="dsn" value="#application.config.dsn#" />
	</cfinvoke>
	
	
	<cfparam name="session.tempFormVars" default="#structNew()#" />
	<cfparam name="session.tempFormVars.createCertificationTypeForm" default="#structNew()#" />
	
	<cfif NOT structKeyExists(session.tempFormVars.createCertificationTypeForm,"populateTime") OR abs(dateDiff("n",now(),session.tempFormVars.createCertificationTypeForm.populateTime)) GT 7>
		<cfset structClear(session.tempFormVars.createCertificationTypeForm) />
	</cfif>
		
	<cfparam name="session.tempFormVars.createCertificationTypeForm.certificationTypeName" default="" />
	<cfparam name="session.tempFormVars.createCertificationTypeForm.certificationTypeDesc" default="" />
	<cfparam name="session.tempFormVars.createCertificationTypeForm.certificationTypeAbbr" default="" />
	<cfparam name="session.tempFormVars.createCertificationTypeForm.requiredUserGroupName" default="" />
	
</cfsilent>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
	<head>
		
		<cfinclude template="#application.settings.appBaseDir#/inc/head.cfm" />
		<cfoutput>
			<title>#application.settings.appTitle# - Admin - Manage Reference Tables - CertificationType</title>
		</cfoutput>
		
		<script type="text/javascript">
		
			function showUpdateRow ( _rowID )
			{
				$('#displayRow_' + _rowID).hide();
				$('#updateRow_' + _rowID).show();
			}
		
			function hideUpdateRow ( _rowID )
			{
				$('#displayRow_' + _rowID).show();
				$('#updateRow_' + _rowID).hide();
			}
			
		</script>
		
		<style type="text/css">
	
		</style>
		
	</head>
	<body>
		<div id="container">
		
			<cfinclude template="#application.settings.appBaseDir#/inc/header.cfm" />
			
			<div id="main" class="clearfix">
				<cfinclude template="#application.settings.appBaseDir#/inc/nav.cfm" />
				
				<div id="content">
					
					<cfinclude template="#application.settings.appBaseDir#/inc/notice.cfm" />
					
					<div id="projectHeading">
						<h1>Admin - Manage Reference Tables - CertificationType</h1>
					</div>
					
					<cfoutput>
						<div class="contentSection">
							
							<a href="#application.settings.appBaseDir#/admin/referenceTables/">Back to Admin - Manage Reference Tables</a>
							<br /><br />
							<h3 class="sectionTitle">CertificationType</h3>
							
							<table width="100%" class="dataTable">
								<tr>
									<th width="50">
										ID
									</th>
									<th>
										CertificationType Name
									</th>
									<th>
										CertificationType Description
									</th>
									<th>
										Abbr
									</th>
									<th>
										Req.UserGroup
									</th>
									<th width="40" class="center">
										Active
									</th>
									<th width="40" class="center">
										Sort
									</th>
									<th colspan="2" class="center">
										Reorder
									</th>
									<th width="200">
										&nbsp;
									</th>
								</tr>
								<cfloop query="variables.certificationTypes">
									<tr id="displayRow_#variables.certificationTypes.certificationTypeID#" <cfif variables.certificationTypes.currentRow MOD 2 EQ 0>class="alt"</cfif>>
										<td>
											#variables.certificationTypes.certificationTypeID#
										</td>
										<td>
											#variables.certificationTypes.certificationTypeName#
										</td>
										<td>
											#variables.certificationTypes.certificationTypeDesc#
										</td>
										<td>
											#variables.certificationTypes.certificationTypeAbbr#
										</td>
										<td>
											#variables.certificationTypes.requiredUserGroupName#
										</td>
										<td class="center">
											#yesNoFormat(variables.certificationTypes.activeFlag)#
										</td>
										<td class="center">
											#variables.certificationTypes.sort#
										</td>
										<td class="center" width="40">
											<cfif variables.certificationTypes.currentRow NEQ 1>
												<a href="action.cfm?action=moveCertificationType&dir=UP&certificationTypeID=#variables.certificationTypes.certificationTypeID#">Up</a>
											</cfif>
										</td>
										<td class="center" width="40">
											<cfif variables.certificationTypes.currentRow NEQ variables.certificationTypes.recordCount>
												<a href="action.cfm?action=moveCertificationType&dir=DOWN&certificationTypeID=#variables.certificationTypes.certificationTypeID#">Down</a>
											</cfif>
										</td>
										<td>
											<a href="javascript:showUpdateRow(#variables.certificationTypes.certificationTypeID#);" class="button">Update</a>
										</td>
									</tr>
									<form action="action.cfm" method="post">
										<tr id="updateRow_#variables.certificationTypes.certificationTypeID#" style="display:none;">
											<td>
												<input type="hidden" name="certificationTypeID" value="#variables.certificationTypes.certificationTypeID#" />
												#variables.certificationTypes.certificationTypeID#
											</td>
											<td>
												<input type="text" name="certificationTypeName" value="#variables.certificationTypes.certificationTypeName#" size="30" />
											</td>
											<td>
												<input type="text" name="certificationTypeDesc" value="#variables.certificationTypes.certificationTypeDesc#" size="30" />
											</td>
											<td>
												<input type="text" name="certificationTypeAbbr" value="#variables.certificationTypes.certificationTypeAbbr#" size="10" />
											</td>
											<td>
												<select name="requiredUserGroupName">
													<cfloop query="variables.userGroups">
														<option value="#variables.userGroups.userGroupName#" <cfif variables.userGroups.userGroupName EQ variables.certificationTypes.requiredUserGroupName>selected="True"</cfif>>#variables.userGroups.userGroupName#</option>
													</cfloop>
												</select>
											</td>
											<td class="center">
												<input name="activeFlag" type="checkbox" value="true" <cfif variables.certificationTypes.activeFlag>checked="true"</cfif> />
											</td>
											<td class="center">
												#variables.certificationTypes.sort#
											</td>
											<td class="center" width="40">
												&nbsp;
											</td>
											<td class="center" width="40">
												&nbsp;
											</td>
											<td>
												<input type="hidden" name="action" value="updateCertificationType" />
												<input type="button" class="button" onclick="hideUpdateRow(#variables.certificationTypes.certificationTypeID#);" value="Cancel" />
												<input type="submit" value="Update" class="button" />
											</td>
										</tr>
									</form>
								</cfloop>
							</table>
							
							<br />
							
							<h3 class="sectionTitle">Add a New CertificationType</h3>
							
							<form action="action.cfm" method="post">
								<table class="formTable">
									<tr>
										<th>
											CertificationType Name:
										</th>
										<td>
											<input type="input" name="certificationTypeName" id="certificationTypeName" value="#session.tempFormVars.createCertificationTypeForm.certificationTypeName#" size="45" />
										</td>
									</tr>
									<tr>
										<th>
											CertificationType Description:
										</th>
										<td>
											<input type="input" name="certificationTypeDesc" id="certificationTypeDesc" value="#session.tempFormVars.createCertificationTypeForm.certificationTypeDesc#" size="45" />
										</td>
									</tr>
									<tr>
										<th>
											CertificationType Abbr:
										</th>
										<td>
											<input type="input" name="certificationTypeAbbr" id="certificationTypeAbbr" value="#session.tempFormVars.createCertificationTypeForm.certificationTypeAbbr#" size="45" />
										</td>
									</tr>
									<tr>
										<th>
											Req. UserGroup:
										</th>
										<td>
											<select name="requiredUserGroupName">
												<cfloop query="variables.userGroups">
													<option value="#variables.userGroups.userGroupName#" <cfif variables.userGroups.userGroupName EQ session.tempFormVars.createCertificationTypeForm.requiredUserGroupName>selected="True"</cfif>>#variables.userGroups.userGroupName#</option>
												</cfloop>
											</select>
										</td>
									</tr>
									<tr>
										<th>
											&nbsp;
										</th>
										<td>
											<input type="hidden" name="action" value="createCertificationType" />
											<input type="submit" value="Submit" class="button" />
										</td>
									</tr>
								</table>
							</form>
							
						</div>
					</cfoutput>
				</div>
			</div>
		</div>
		
		<cfinclude template="#application.settings.appBaseDir#/inc/footer.cfm" />
		
		
	</body>
</html>
