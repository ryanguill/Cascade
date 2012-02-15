
<cfsilent>
	
	<cfinclude template="#application.settings.appBaseDir#/inc/preProcess.cfm" />
	
	<cfset session.login.setCurrentArea("archive") />
	
	<cfparam name="url.searchString" default="" />
	<cfparam name="url.appname" default="" />
	<cfparam name="url.projectname" default="" />
	<cfparam name="url.author" default="" />
	<cfparam name="url.inclObsolete" default="0" />
	<cfparam name="url.inclBackup" default="0" />
	
	<cfif NOT len(trim(url.appname))>
		<cfset url.appname = -1 />
	</cfif>
	
	<cfif NOT len(trim(url.projectname))>
		<cfset url.projectname = -1 />
	</cfif>
	
	<cfif NOT len(trim(url.author))>
		<cfset url.author = -1 />
	</cfif>
	
	<cfset url.searchString = trim(url.searchString) />
	
	<cfif url.inclObsolete NEQ 1>
		<cfset url.inclObsolete = 0 />
	</cfif>
	
	<cfif url.inclBackup NEQ 1>
		<cfset url.inclBackup = 0 />
	</cfif>
	
	
	<cfinvoke component="#application.daos.cascade#" method="simpleSearchArchives" returnvariable="variables.archives">
		<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
		<cfinvokeargument name="applicationname" value="#url.appName#" />	<!---Type:String Hint: pass -1 to ignore. --->
		<cfinvokeargument name="projectname" value="#url.projectName#" />	<!---Type:String Hint: pass -1 to ignore. --->
		<cfinvokeargument name="author" value="#url.author#" />	<!---Type:String Hint: pass -1 to ignore. --->
		<cfinvokeargument name="isbackuparchive" value="#url.inclBackup#" />	<!---Type:numeric Hint: pass -1 to ignore. --->
		<cfinvokeargument name="isObsolete" value="#url.inclObsolete#" />	<!---Type:numeric Hint: pass -1 to ignore. --->
		<cfinvokeargument name="searchString" value="#url.searchString#" />	<!---Type:string Hint:  --->
	</cfinvoke>
	
	
	<cfinvoke component="#application.daos.cascade#" method="getApplicationNames" returnvariable="variables.applicationNames">
		<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
	</cfinvoke>
	
	

	
</cfsilent>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
	<head>
		
		<cfinclude template="#application.settings.appBaseDir#/inc/head.cfm" />
		<cfoutput>
			<title>#application.settings.appTitle# - Search Results</title>
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
					
						<div class="contentSection">
							<form action="search.cfm" method="get">
								<table width="100%" class="formTable">
									<tr>
										<th width="200">
											Search String:
										</th>
										<td colspan="3">
											<input type="text" name="searchString" value="#url.searchString#" size="100" />
										</td>
									</tr>
									<tr>
										<th>
											Application:
										</th>
										<td>
											<select name="appName">
												<option value="" <cfif url.appName EQ -1>selected="True"</cfif>>All Applications</option>
												<cfloop query="variables.applicationNames">
													<option value="#variables.applicationNames.applicationName#" <cfif url.appName EQ variables.applicationNames.applicationName>selected="True"</cfif>>#variables.applicationNames.applicationName#</option>
												</cfloop>
											</select>
										</td>
										<th width="200">
											&nbsp;
										</th>
										<td>
											&nbsp;
										</td>
									</tr>
									<tr>
										<th>
											Include Obsolete Archives?
										</th>
										<td>
											<input type="checkbox" value="1" name="inclObsolete" id="inclObsolete" <cfif url.inclObsolete>checked="true"</cfif>  />
											<label for="inclObsolete">Include Obsolete Archives</label>
										</td>
										<th width="200">
											Include Backup Archives?
										</th>
										<td>
											<input type="checkbox" value="1" name="inclBackup" id="inclBackup" <cfif url.inclBackup>checked="true"</cfif>  />
											<label for="inclBackup">Include Backup Archivess</label>
										</td>
									</tr>
									<tr>
										<td class="noBorder">
											&nbsp;
										</th>
										<td class="noBorder" colspan="3">
											<input type="submit" value="Search" /.
										</td>
									</tr>
								</table>
							</form>
						</div>
					
						<div id="projectHeading">
							<h1>Search Results</h1>
						</div>
						
						<cfinclude template="#application.settings.appBaseDir#/archive/inc/_archiveListing.cfm" />
					
					</cfoutput>
				</div>
			</div>
		</div>
		
		<cfinclude template="#application.settings.appBaseDir#/inc/footer.cfm" />
		
	</body>
</html>