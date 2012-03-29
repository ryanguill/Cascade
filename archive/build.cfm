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
	
	<cfinclude template="#application.settings.appBaseDir#/inc/preProcess.cfm" />
	
	<cfset session.login.setCurrentArea("archive") />
	
	<cfif NOT session.login.isUserInGroup("build")>
		<cflocation url="#application.settings.appBaseDir#/index.cfm" />
	</cfif>
	
	<cfparam name="url.dir" default="-1" />
	<cfparam name="url.excludeExtensions" default="" />
	<cfparam name="url.includeHidden" default="false" />
	<cfparam name="url.previousArchiveID" default="" />
	
	<cfset variables.showFiles = false />
	<cfset variables.previouslySelectedFiles = "" />
	
	
	<cfif len(trim(url.previousArchiveID)) and isValid("UUID",url.previousArchiveID)>
		<cfinvoke component="#application.daos.cascade#" method="getFilesForArchiveID" returnvariable="variables.files">
			<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
			<cfinvokeargument name="archiveID" value="#url.previousArchiveID#" />	<!---Type:string  --->
		</cfinvoke>
		
		<cfset variables.previouslySelectedFiles = valueList(variables.files.filepath) />
	</cfif>
	
	<cfif url.dir EQ -1>
		<cfset variables.appBaseDirDepth = listLen(expandPath(application.settings.appBaseDir),application.settings.pathSeperator)>
		<cfset url.dir = listDeleteAt(expandPath(application.settings.appBaseDir),variables.appBaseDirDepth,application.settings.pathSeperator) & application.settings.pathSeperator />
	<cfelse>
		
	
		<cfif directoryExists(url.dir)>
			<cfset variables.showFiles = true />
			
			<cfdirectory name="variables.results" directory="#url.dir#" recurse="true" sort="directory ASC, name ASC" />
		<cfelse>
			<cfinvoke component="#session.messenger#" method="setAlert" returnvariable="variables.setAlert">
				<cfinvokeargument name="alertingTemplate" value="#application.settings.appBaseDir#/action.cfm" />
				<cfinvokeargument name="messageType" value="Error" />
				<cfinvokeargument name="messageText" value="#url.dir# is not a valid directory." />
			</cfinvoke>
		</cfif>
	</cfif>
	
	<cfif right(url.dir,1) EQ "/">
		<cfset url.dir = left(url.dir,len(url.dir)-1) />
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
			Event.observe(window, 'load', init, false);
	
			function init() {
			
			}		
			
			function selectAll () {
				$$('.filecheckbox').each(function(s){s.checked = true});				
			}
			function selectNone () {
				$$('.filecheckbox').each(function(s){s.checked = false});				
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

					<cfoutput>
					
						<div id="projectHeading">
							<h1>Build a New Archive</h1>
						</div>
						
						<div class="contentSection">
							
							<h3 class="sectionTitle">Select Archive Root</h3>
							
							<form action="build.cfm" method="get">
								<table width="100%">
									<tr>
										<th>
											Directory:
										</th>
										<td class="noBorder">
											<input type="text" name="dir" value="#url.dir#" size="90" />
										</td>
										<td class="noBorder">
											&nbsp;
										</td>
									</tr>
									<tr>
										<th>
											Exclude File Extensions:
										</th>
										<td class="noBorder">
											<input type="text" name="excludeExtensions" value="#url.excludeExtensions#" size="30" />
										</td>
										<td class="noBorder">
											<em>Comma Delimited list of extensions - do not include the period (ex: pdf,txt)</em>
										</td>
									</tr>
									<tr>
										<th>
											&nbsp;
										</th>
										<td class="noBorder">
											<input type="checkbox" name="includeHidden" id="includeHidden" value="true" <cfif url.includeHidden>checked="True"</cfif>><lable for="includeHidden">Include Hidden Files and Directories</lable>
										</td>
										<td class="noBorder">
											<input type="hidden" name="previousArchiveID" value="#url.previousArchiveID#" />
											<input type="submit" value="List Directory Contents" />
										</td>
									</tr>
								</table>
							</form>
							
							<cfif listLen(variables.previouslySelectedFiles)>
								<p style="color:blue;">Only files included in the previous archive: <a href="archive.cfm?archiveid=#url.previousArchiveID#">#url.previousArchiveID#</a> are being selected below.  Please ensure that all files you want to include are selected.</p>
							</cfif>
							
							<cfif variables.showFiles>
								<form action="action.cfm" method="post">
									
									<input type="button" value="Select All" onclick="selectAll();" />
									<input type="button" value="Select None" onclick="selectNone();" />
									
									<table class="dataTable" width="100%">
										<tr>
											<th>
												&nbsp;
											</th>
											<th>
												Path
											</th>
											<th>
												File
											</th>
											<th width="100" class="center">
												Last Modified
											</th>
											<th width="100" class="right">
												Size
											</th>
										</tr>
										<cfif variables.results.recordCount>
											<cfset variables.row = 0 />
											<cfloop query="variables.results">
												<cftry>
													<cfif NOT url.includeHidden>
														<cfif left(variables.results.name,1) EQ ".">
															<!--- cf8 doesnt have cfcontinue, so have to use an old hack - if we ever drop support for cf8, change this back to cfcontinue instead --->
															<cfthrow type="cfcontinue_hack"/><!---  message="hidden filename #variables.results.name#"  --->
														</cfif>
														<cfloop from="1" to="#listLen(variables.results.directory,application.settings.pathSeperator)#" index="i">
															<cfif left(listGetAt(variables.results.directory,i,application.settings.pathSeperator),1) EQ ".">
																<cfthrow type="cfcontinue_hack" /><!---  message="hidden directory #variables.results.directory#" --->
															</cfif>
														</cfloop>
													</cfif>
													
													<cfif listLen(url.excludeExtensions)>
														<cfset url.excludeExtensions = replaceNoCase(url.excludeExtensions,".","","all") />
														<cfif listContainsNoCase(url.excludeExtensions,listLast(variables.results.name,"."))>
															<cfthrow type="cfcontinue_hack" /><!---  message="excluded extension #variables.results.name#" --->
														</cfif>
													</cfif>
													
													<cfset variables.row = variables.row + 1 />
													
													<cfif variables.results.type EQ "DIR">
														
														<tr <cfif variables.row MOD 2 EQ 0>class="alt"</cfif>>
															<td>
																&nbsp;
															</td>
															<td>
																#replaceNoCase(variables.results.directory,url.dir,".")##application.settings.pathSeperator#
															</td>
															<td>
																#variables.results.name##application.settings.pathSeperator#
															</td>
															<td class="center">
																#application.objs.global.formatDate(variables.results.datelastModified)#
															</td>
															<td class="right">
																#application.objs.global.formatFileSize(variables.results.size)#
															</td>
														</tr>
													<cfelse>
														<cfif listLen(variables.previouslySelectedFiles)>
															<cfset variables.temp.checked = false />
															
															<cfif listContains(variables.previouslySelectedFiles,variables.results.directory & application.settings.pathSeperator & variables.results.name)>
																<cfset variables.temp.checked = true />
															</cfif>
														<cfelse>
															<cfset variables.temp.checked = true />
																
															<cfif left(variables.results.name,1) EQ "." OR findNoCase(".",variables.results.directory)>
																<cfset variables.temp.checked = false />
															</cfif> 
														</cfif>
														
													
														<tr <cfif variables.row MOD 2 EQ 0>class="alt"</cfif>>
															<td>
																<input class="filecheckbox" name="file" type="checkbox" value="#variables.results.directory##application.settings.pathSeperator##variables.results.name#" id="file_#variables.row#" <cfif variables.temp.checked>checked="True"</cfif> />
															</td>
															<td>
																<label for="file_#variables.row#">#replaceNoCase(variables.results.directory,url.dir,".")##application.settings.pathSeperator#</label>
															</td>
															<td>
																<label for="file_#variables.row#">#variables.results.name#<cfif variables.results.type EQ "DIR">#application.settings.pathSeperator#</cfif></label>
															</td>
															<td class="center">
																#application.objs.global.formatDate(variables.results.datelastModified)#
															</td>
															<td class="right">
																#application.objs.global.formatFileSize(variables.results.size)#
															</td>
														</tr>
													</cfif>
												<cfcatch type="cfcontinue_hack">
													<!--- do nothing, this is just a continue for cf8 --->
												</cfcatch>
												</cftry>
											</cfloop>
										<cfelse>
											<tr>
												<td colspan="5">
													<em>There are no files in that directory.</em>
												</td>
											</tr>
										</cfif>
										<tr>
											<td colspan="5" class="right">
												<input type="hidden" name="dir" value="#url.dir#" />
												<input type="hidden" name="action" value="buildArchive" />
												<input type="hidden" name="previousArchiveID" value="#url.previousArchiveID#" />
												<input type="submit" value="Select Files and Continue" />
											</td>
										</tr>
									</table>
								</form>
							</cfif>
						</div>
					
					</cfoutput>
				</div>
			</div>
		</div>
		
		<cfinclude template="#application.settings.appBaseDir#/inc/footer.cfm" />
		
		
	</body>
</html>
















