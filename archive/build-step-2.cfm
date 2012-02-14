
<cfsilent>
	
	<cfinclude template="#application.settings.appBaseDir#/inc/preProcess.cfm" />
	
	<cfset session.login.setCurrentArea("archive") />
	
	<cfif NOT session.login.isUserInGroup("build")>
		<cflocation url="#application.settings.appBaseDir#/index.cfm" />
	</cfif>
	
	<cfif NOT structKeyExists(session,"tempFormVars") 
		OR NOT structKeyExists(session.tempFormVars,"buildArchiveForm") 
		OR NOT structKeyExists(session.tempformVars.buildArchiveForm,"fileList")
		OR NOT structKeyExists(session.tempformVars.buildArchiveForm,"dir")
		OR NOT arrayLen(session.tempFormVars.buildArchiveForm.filelist)
		OR NOT structKeyExists(session.tempFormVars.buildArchiveForm,"previousArchiveID")>
		
		<cflocation url="build.cfm" />
		
	</cfif>
	
	<cfset variables.dir = session.tempFormVars.buildArchiveForm.dir />
	<cfset variables.files = session.tempFormVars.buildArchiveForm.fileList />
		
		
	<cfset variables.changeTypes = application.daos.referenceTables.getAllChangeTypes(application.config.dsn) />	
	
	<cfset variables.newLine = chr(10) />
	
	<cfparam name="session.tempFormVars" default="#structNew()#" />
	<cfparam name="session.tempFormVars.buildStep2Form" default="#structNew()#" />
	
	<cfif NOT structKeyExists(session.tempFormVars.buildStep2Form,"populateTime") OR abs(dateDiff("n",now(),session.tempFormVars.buildStep2Form.populateTime)) GT 7>
		<cfset structClear(session.tempFormVars.buildStep2Form) />
	</cfif>
		
	<cfparam name="session.tempFormVars.buildStep2Form.applicationName" default="" />
	<cfparam name="session.tempFormVars.buildStep2Form.versionNumber" default="" />
	<cfparam name="session.tempFormVars.buildStep2Form.projectName" default="" />
	<cfparam name="session.tempFormVars.buildStep2Form.projectNumber" default="" />
	<cfparam name="session.tempFormVars.buildStep2Form.ticketNumber" default="" />
	<cfparam name="session.tempFormVars.buildStep2Form.author" default="" />
	<cfparam name="session.tempFormVars.buildStep2Form.changeReason" default="" />
	<cfparam name="session.tempFormVars.buildStep2Form.changeDescription" default="" />	
	<cfparam name="session.tempFormVars.buildStep2Form.deployDirSuggestions" default="" />	
	
	<cfset variables.basedOnPreviousArchive = false />
	<cfset variables.previousArchiveID = "" />
	
	<cfif isValid("UUID",session.tempFormVars.buildArchiveForm.previousArchiveID)>
		<cfinvoke component="#application.daos.cascade#" method="getArchiveByArchiveID" returnvariable="variables.archive">
			<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
			<cfinvokeargument name="archiveID" value="#session.tempFormVars.buildArchiveForm.previousArchiveID#" />	<!---Type:string  --->
		</cfinvoke>
	
		<cfif variables.archive.recordCount>
			<cfset variables.basedOnPreviousArchive = true />
			<cfset variables.previousArchiveID = session.tempFormVars.buildArchiveForm.previousArchiveID />
	
			<cfset session.tempFormVars.buildStep2Form.applicationName = variables.archive.applicationName />
			<cfset session.tempFormVars.buildStep2Form.versionNumber = "" />
			<cfset session.tempFormVars.buildStep2Form.projectName = variables.archive.projectName />
			<cfset session.tempFormVars.buildStep2Form.projectNumber = variables.archive.projectNumber />
			<cfset session.tempFormVars.buildStep2Form.ticketNumber = variables.archive.ticketNumber />
			<cfset session.tempFormVars.buildStep2Form.author = variables.archive.author />
			<cfset session.tempFormVars.buildStep2Form.changeReason = variables.archive.changeReason />
			<cfset session.tempFormVars.buildStep2Form.changeDescription = variables.archive.changeDescription />	
			<cfset session.tempFormVars.buildStep2Form.deployDirSuggestions = replaceNoCase(variables.archive.deployDirSuggestions,",",variables.newline,"all") />	
		</cfif>
	</cfif>

</cfsilent>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
	<head>
		
		<cfinclude template="#application.settings.appBaseDir#/inc/head.cfm" />
		<cfoutput>
			<title>#application.settings.appTitle#</title>
		</cfoutput>
		
		<script type="text/javascript">
		/*
			Event.observe(window, 'load', init, false);
	
			function init() {
			
			}		
		*/	
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

					<cfoutput>
					
						<h2 class="sectionTitle">Build a New Archive - Step 2</h2>
						
						<div class="contentSection">
							
							<h3 class="sectionTitle">Selected Files - #arrayLen(variables.files)#</h3>
							
							<table class="dataTable" width="100%">
								<tr>
									<th width="25">
										&nbsp;
									</th>
									<th>
										File
									</th>
								</tr>
								<cfloop from="1" to="#arrayLen(variables.files)#" index="i">
									<tr <cfif i mod 2 eq 0>class="alt"</cfif>>
										<td class="right">
											#i#
										</td>
										<td>
											<span class="notImportaint">#variables.dir#</span>#replaceNoCase(variables.files[i],variables.dir,"")#
										</td>
									</tr>
								</cfloop>
							</table>
							
							<a href="build.cfm?dir=#variables.dir#" class="button">Change Selected Files</a> 
							
							<h2 class="sectionTitle">Archive Details</h2>
							
							<cfif variables.basedOnPreviousArchive>
								<p style="color:blue;">The data below is based on the previous archive: <a href="archive.cfm?archiveid=#session.tempFormVars.buildArchiveForm.previousArchiveID#">#session.tempFormVars.buildArchiveForm.previousArchiveID#</a>.  Please check all of the information to ensure its accuracy to this archive.</p>
							</cfif>
							
							
							<form action="action.cfm" method="post">
								<table class="formTable" width="100%">
									<tr>
										<th width="200">
											Application Name:
										</th>
										<td>
											<input type="text" name="applicationName" id="applicationName" value="#session.tempFormVars.buildStep2Form.applicationName#" size="45" />
										</td>
									</tr>
									<tr>
										<th width="200">
											Version Number:
										</th>
										<td>
											<input type="text" name="versionNumber" id="versionNumber" value="#session.tempFormVars.buildStep2Form.versionNumber#" size="15" />
											<cfif variables.basedOnPreviousArchive>
												<em>Previous version was: #variables.archive.versionName#</em>
											</cfif>
										</td>
									</tr>
									<tr>
										<th>
											Project Name:
										</th>
										<td>
											<input type="text" name="projectName" id="projectName" value="#session.tempFormVars.buildStep2Form.projectName#" size="45" />
										</td>
									</tr>
									<tr>
										<th>
											Project Number:
										</th>
										<td>
											<input type="text" name="projectNumber" id="projectNumber" value="#session.tempFormVars.buildStep2Form.projectNumber#" size="45" />
										</td>
									</tr>
									<tr>
										<th>
											Ticket/Issue Number(s):
										</th>
										<td>
											<input type="text" name="ticketNumber" id="ticketNumber" value="#session.tempFormVars.buildStep2Form.ticketNumber#" size="45" />
										</td>
									</tr>
									<tr>
										<th>
											Change Author(s):
										</th>
										<td>
											<input type="text" name="author" id="author" value="#session.tempFormVars.buildStep2Form.author#" size="45" />
										</td>
									</tr>
									<tr>
										<th>
											Change Reason:
										</th>
										<td>
											<select name="changeReason" id="changeReason">
												<cfloop query="variables.changeTypes">
													<option value="#variables.changeTypes.changeTypeName#" <cfif variables.changeTypes.changeTypeName EQ session.tempFormVars.buildStep2Form.changeReason>selected="True"</cfif>>#variables.changeTypes.changeTypeName#</option>
												</cfloop>
											</select>
										</td>
									</tr>
									<tr>
										<th valign="top">
											Change Description:
										</th>
										<td>
											<textarea name="changeDescription" id="changeDescription" cols="100" rows="10">#session.tempFormVars.buildStep2Form.changeDescription#</textarea>
										</td>
									</tr>
									<tr>
										<th valign="top">
											Deployment Directory Suggestions: (one per line)
										</th>
										<td>
											<textarea name="deployDirSuggestions" id="deployDirSuggestions" cols="100" rows="10">#session.tempFormVars.buildStep2Form.deployDirSuggestions#</textarea>
										</td>
									</tr>
									<cfif variables.basedOnPreviousArchive>
									<tr>
										<th>
											Mark Previous Version as Obsolete?
										</th>
										<td>
											<select name="markPreviousArchiveAsObsolete">
												<option value="true">Yes</option>
												<option value="false">No</option>
											</select>
										</td>
									</tr>
									<cfelse>
										<input type="hidden" name="markPreviousArchiveAsObsolete" value="false" />
									</cfif>
									<tr>
										<th>
										
										</th>
										<td>
											<input type="hidden" name="previousArchiveID" value="#variables.previousArchiveID#" />
											<input type="hidden" name="action" value="buildArchive2" />
											<input type="submit" value="Create Archive" />
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
















