
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
		OR NOT arrayLen(session.tempFormVars.buildArchiveForm.filelist)>
		
		<cflocation url="build.cfm" />
		
	</cfif>
	
	<cfset variables.dir = session.tempFormVars.buildArchiveForm.dir />
	<cfset variables.files = session.tempFormVars.buildArchiveForm.fileList />
		
		
	<cfset variables.changeTypes = application.daos.referenceTables.getAllChangeTypes(application.config.dsn) />	
		
		
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
							
							<form action="action.cfm" method="post">
								<table class="formTable" width="100%">
									<tr>
										<th width="200">
											Application Name:
										</th>
										<td>
											<input type="text" name="applicationName" id="applicationName" value="" size="45" />
										</td>
									</tr>
									<tr>
										<th width="200">
											Version Number:
										</th>
										<td>
											<input type="text" name="versionNumber" id="versionNumber" value="" size="15" />
										</td>
									</tr>
									<tr>
										<th>
											Project Name:
										</th>
										<td>
											<input type="text" name="projectName" id="projectName" value="" size="45" />
										</td>
									</tr>
									<tr>
										<th>
											Project Number:
										</th>
										<td>
											<input type="text" name="projectNumber" id="projectNumber" value="" size="45" />
										</td>
									</tr>
									<tr>
										<th>
											Ticket/Issue Number(s):
										</th>
										<td>
											<input type="text" name="ticketNumber" id="ticketNumber" value="" size="45" />
										</td>
									</tr>
									<tr>
										<th>
											Change Author(s):
										</th>
										<td>
											<input type="text" name="author" id="author" value="" size="45" />
										</td>
									</tr>
									<tr>
										<th>
											Change Reason:
										</th>
										<td>
											<select name="changeReason" id="changeReason">
												<cfloop query="variables.changeTypes">
													<option value="#variables.changeTypes.changeTypeName#">#variables.changeTypes.changeTypeName#</option>
												</cfloop>
											</select>
										</td>
									</tr>
									<tr>
										<th valign="top">
											Change Description:
										</th>
										<td>
											<textarea name="changeDescription" id="changeDescription" cols="100" rows="10"></textarea>
										</td>
									</tr>
									<tr>
										<th>
										
										</th>
										<td>
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
















