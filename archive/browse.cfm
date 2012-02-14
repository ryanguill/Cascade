
<cfsilent>
	
	<cfinclude template="#application.settings.appBaseDir#/inc/preProcess.cfm" />
	
	<cfset session.login.setCurrentArea("archive") />
	
	<cfinvoke component="#application.daos.cascade#" method="searchArchives" returnvariable="variables.archives">
		<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
		<cfinvokeargument name="archiveid" value="-1" />	<!---Type:String Hint: pass -1 to ignore. --->
		<cfinvokeargument name="archiveshahash" value="-1" />	<!---Type:String Hint: pass -1 to ignore. --->
		<cfinvokeargument name="buildsystemname" value="-1" />	<!---Type:String Hint: pass -1 to ignore. --->
		<cfinvokeargument name="applicationname" value="-1" />	<!---Type:String Hint: pass -1 to ignore. --->
		<cfinvokeargument name="versionname" value="-1" />	<!---Type:String Hint: pass -1 to ignore. --->
		<cfinvokeargument name="projectname" value="-1" />	<!---Type:String Hint: pass -1 to ignore. --->
		<cfinvokeargument name="projectnumber" value="-1" />	<!---Type:String Hint: pass -1 to ignore. --->
		<cfinvokeargument name="ticketnumber" value="-1" />	<!---Type:String Hint: pass -1 to ignore. --->
		<cfinvokeargument name="changereason" value="-1" />	<!---Type:String Hint: pass -1 to ignore. --->
		<cfinvokeargument name="author" value="-1" />	<!---Type:String Hint: pass -1 to ignore. --->
		<cfinvokeargument name="changedescription" value="-1" />	<!---Type:String Hint: pass -1 to ignore. --->
		<cfinvokeargument name="buildbyuserid" value="-1" />	<!---Type:String Hint: pass -1 to ignore. --->
		<cfinvokeargument name="buildbyusername" value="-1" />	<!---Type:String Hint: pass -1 to ignore. --->
		<cfinvokeargument name="buildbyuserfullname" value="-1" />	<!---Type:String Hint: pass -1 to ignore. --->
		<cfinvokeargument name="buildbyuseremail" value="-1" />	<!---Type:String Hint: pass -1 to ignore. --->
		<cfinvokeargument name="buildonAfter" value="1970-01-01" />	<!---Type:date Hint: pass 1970-01-01 to ignore --->
		<cfinvokeargument name="buildonBefore" value="1970-01-01" />	<!---Type:date Hint: pass 1970-01-01 to ignore --->
		<cfinvokeargument name="builddir" value="-1" />	<!---Type:String Hint: pass -1 to ignore. --->
		<cfinvokeargument name="deployDirSuggestions" value="-1" />	<!---Type:String Hint: pass -1 to ignore. --->
		<cfinvokeargument name="filecount" value="-1" />	<!---Type:numeric Hint: pass -1 to ignore. --->
		<cfinvokeargument name="isnativebuild" value="-1" />	<!---Type:numeric Hint:  pass -1 to ignore. --->
		<cfinvokeargument name="isbackuparchive" value="0" />	<!---Type:numeric Hint: pass -1 to ignore. --->
		<cfinvokeargument name="isObsolete" value="0" />	<!---Type:numeric Hint: pass -1 to ignore. --->
		<cfinvokeargument name="backupForArchiveID" value="-1" />	<!---Type:numeric Hint: pass -1 to ignore. --->
	</cfinvoke>

	
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
					
						<div id="projectHeading">
							<h1>Browse Archives</h1>
						</div>
						
						<div class="contentSection">
							<table width="100%" class="dataTable">
								<tr>
									<th width="300">
										ID
									</th>
									<th width="100">
										SHA
									</th>
									<th>
										Application
									</th>
									<th width="80">
										Version
									</th>
									<th width="50" class="right">
										Files
									</th>
									<th>
										Build By
									</th>
									<th width="120" class="center">
										Built On
									</th>
									<th width="170">
										Built System
									</th>
								</tr>
								<cfif variables.archives.recordCount>
									<cfloop query="variables.archives">
										<tr <cfif variables.archives.currentRow MOD 2 EQ 0>class="alt"</cfif>>
											<td class="monospace">
												<a href="#application.settings.appBaseDir#/archive/archive.cfm?archiveID=#variables.archives.archiveID#">#variables.archives.archiveID#</a>
											</td>
											<td class="monospace">
												<cftooltip tooltip="#lcase(variables.archives.archiveSHAHAsh)#">#lcase(left(variables.archives.archiveSHAHash,application.settings.showFirstXCharsOfSHA))#</cftooltip>
											</td>
											<td>
												#variables.archives.applicationName#
											</td>
											<td>
												#variables.archives.versionName#
											</td>
											<td class="right">
												#numberFormat(variables.archives.fileCount)#
											</td>
											<td>
												#variables.archives.buildByUserFullname#
											</td>
											<td class="center">
												#application.objs.global.formatDate(variables.archives.buildOn)# #application.objs.global.formatTime(variables.archives.buildOn)#
											</td>
											<td>
												<cftooltip tooltip="#variables.archives.buildSystemName#">#left(variables.archives.buildSystemName,20)#<cfif len(variables.archives.buildSystemName) GT 20>...</cfif></a></cftooltip>
											</td>
										</tr>
									</cfloop>
								<cfelse>
									<tr>
										<td colspan="8">
											<em>There are no native, non-backup archives in this system yet.  <a href="#application.settings.appBaseDir#/archive/build.cfm">Click here to build one!</a>
										</td>
									</tr>
								</cfif>
							</table>
							
						</div>
					
					</cfoutput>
				</div>
			</div>
		</div>
		
		<cfinclude template="#application.settings.appBaseDir#/inc/footer.cfm" />
		
		
	</body>
</html>
















