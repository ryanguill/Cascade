
<cfsilent>
	<cfset session.login.setCurrentArea("admin") />
	
	<cfinclude template="#application.settings.appBaseDir#/inc/preProcess.cfm" />
	
	<cfif NOT session.login.isUserInGroup("ADMIN")>
		<cflocation url="#application.settings.appBaseDir#" />
	</cfif>
	
	<cfinvoke component="#application.daos.referenceTables#" method="getAllChangeTypes" returnvariable="variables.changeTypes">
		<cfinvokeargument name="dsn" value="#application.settings.dsn#" />
	</cfinvoke>
	
	
	<cfparam name="session.tempFormVars" default="#structNew()#" />
	<cfparam name="session.tempFormVars.createChangeTypeForm" default="#structNew()#" />
	
	<cfif NOT structKeyExists(session.tempFormVars.createChangeTypeForm,"populateTime") OR abs(dateDiff("n",now(),session.tempFormVars.createChangeTypeForm.populateTime)) GT 7>
		<cfset structClear(session.tempFormVars.createChangeTypeForm) />
	</cfif>
		
	<cfparam name="session.tempFormVars.createChangeTypeForm.changeTypeName" default="" />
	<cfparam name="session.tempFormVars.createChangeTypeForm.changeTypeDesc" default="" />
	<cfparam name="session.tempFormVars.createChangeTypeForm.changeTypeAbbr" default="" />
	
</cfsilent>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
	<head>
		
		<cfinclude template="#application.settings.appBaseDir#/inc/head.cfm" />
		<cfoutput>
			<title>#application.settings.appTitle# - Admin - Manage Reference Tables - ChangeType</title>
		</cfoutput>
		
		<script type="text/javascript">
		
			Event.observe(window, 'load', init, false);
	
			function init() {
			
			}		
		
			function showUpdateRow ( _rowID )
			{
				Element.hide('displayRow_' + _rowID);
				Element.show('updateRow_' + _rowID);
			}
		
			function hideUpdateRow ( _rowID )
			{
				Element.show('displayRow_' + _rowID);
				Element.hide('updateRow_' + _rowID);
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
						<h1>Admin - Manage Reference Tables - ChangeType</h1>
					</div>
					
					<cfoutput>
						<div class="contentSection">
							
							<a href="#application.settings.appBaseDir#/admin/referenceTables/">Back to Admin - Manage Reference Tables</a>
							<br /><br />
							<h3 class="sectionTitle">ChangeType</h3>
							
							<table width="100%" class="dataTable">
								<tr>
									<th width="50">
										ID
									</th>
									<th>
										ChangeType Name
									</th>
									<th>
										ChangeType Description
									</th>
									<th>
										Abbr
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
								<cfloop query="variables.changeTypes">
									<tr id="displayRow_#variables.changeTypes.changeTypeID#" <cfif variables.changeTypes.currentRow MOD 2 EQ 0>class="alt"</cfif>>
										<td>
											#variables.changeTypes.changeTypeID#
										</td>
										<td>
											#variables.changeTypes.changeTypeName#
										</td>
										<td>
											#variables.changeTypes.changeTypeDesc#
										</td>
										<td>
											#variables.changeTypes.changeTypeAbbr#
										</td>
										<td class="center">
											#yesNoFormat(variables.changeTypes.activeFlag)#
										</td>
										<td class="center">
											#variables.changeTypes.sort#
										</td>
										<td class="center" width="40">
											<cfif variables.changeTypes.currentRow NEQ 1>
												<a href="action.cfm?action=moveChangeType&dir=UP&changeTypeID=#variables.changeTypes.changeTypeID#">Up</a>
											</cfif>
										</td>
										<td class="center" width="40">
											<cfif variables.changeTypes.currentRow NEQ variables.changeTypes.recordCount>
												<a href="action.cfm?action=moveChangeType&dir=DOWN&changeTypeID=#variables.changeTypes.changeTypeID#">Down</a>
											</cfif>
										</td>
										<td>
											<a href="javascript:showUpdateRow(#variables.changeTypes.changeTypeID#);" class="button">Update</a>
										</td>
									</tr>
									<form action="action.cfm" method="post">
										<tr id="updateRow_#variables.changeTypes.changeTypeID#" style="display:none;">
											<td>
												<input type="hidden" name="changeTypeID" value="#variables.changeTypes.changeTypeID#" />
												#variables.changeTypes.changeTypeID#
											</td>
											<td>
												<input type="text" name="changeTypeName" value="#variables.changeTypes.changeTypeName#" size="30" />
											</td>
											<td>
												<input type="text" name="changeTypeDesc" value="#variables.changeTypes.changeTypeDesc#" size="30" />
											</td>
											<td>
												<input type="text" name="changeTypeAbbr" value="#variables.changeTypes.changeTypeAbbr#" size="10" />
											</td>
											<td class="center">
												<input name="activeFlag" type="checkbox" value="true" <cfif variables.changeTypes.activeFlag>checked="true"</cfif> />
											</td>
											<td class="center">
												#variables.changeTypes.sort#
											</td>
											<td class="center" width="40">
												&nbsp;
											</td>
											<td class="center" width="40">
												&nbsp;
											</td>
											<td>
												<input type="hidden" name="action" value="updateChangeType" />
												<input type="button" class="button" onclick="hideUpdateRow(#variables.changeTypes.changeTypeID#);" value="Cancel" />
												<input type="submit" value="Update" class="button" />
											</td>
										</tr>
									</form>
								</cfloop>
							</table>
							
							<br />
							
							<h3 class="sectionTitle">Add a New ChangeType</h3>
							
							<form action="action.cfm" method="post">
								<table class="formTable">
									<tr>
										<th>
											ChangeType Name:
										</th>
										<td>
											<input type="input" name="changeTypeName" id="changeTypeName" value="#session.tempFormVars.createChangeTypeForm.changeTypeName#" size="45" />
										</td>
									</tr>
									<tr>
										<th>
											ChangeType Description:
										</th>
										<td>
											<input type="input" name="changeTypeDesc" id="changeTypeDesc" value="#session.tempFormVars.createChangeTypeForm.changeTypeDesc#" size="45" />
										</td>
									</tr>
									<tr>
										<th>
											ChangeType Abbr:
										</th>
										<td>
											<input type="input" name="changeTypeAbbr" id="changeTypeAbbr" value="#session.tempFormVars.createChangeTypeForm.changeTypeAbbr#" size="45" />
										</td>
									</tr>
									<tr>
										<th>
											&nbsp;
										</th>
										<td>
											<input type="hidden" name="action" value="createChangeType" />
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
