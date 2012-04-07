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
	
	<cfif NOT structKeyExists(url,"archiveID") OR NOT isValid("UUID",url.archiveID)>
		<cflocation url="#application.settings.appBaseDir#/archive/browse.cfm" />
	</cfif>
	
	<cfinvoke component="#application.daos.cascade#" method="getArchiveByArchiveID" returnvariable="variables.archive">
		<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
		<cfinvokeargument name="archiveID" value="#url.archiveID#" />	<!---Type:string  --->
	</cfinvoke>

	<cfif NOT variables.archive.recordCount>
		<cflocation url="#application.settings.appBaseDir#/archive/browse.cfm" />
	</cfif>
	
	<cfif NOT structKeyExists(url,"fileID") OR NOT isValid("UUID",url.fileID)>
		<cflocation url="#application.settings.appBaseDir#/archive/archive.cfm?archiveID=#url.archiveID#" />
	</cfif>
	
	<cfinvoke component="#application.daos.cascade#" method="getFileForFileID" returnvariable="variables.file">
		<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
		<cfinvokeargument name="fileID" value="#url.fileID#" />	<!---Type:String Hint:  - CHAR (35) --->
	</cfinvoke>

	<cfif NOT variables.file.recordCount>
		<cflocation url="#application.settings.appBaseDir#/archive/archive.cfm?archiveID=#url.archiveID#" />
	</cfif>
	 
	<cfset variables.tempDir = application.config.archiveDirectory & "/temp/" />
	<cfif NOT directoryExists(variables.tempDir)>
		<cfdirectory action="create" directory="#variables.tempDir#" />
	</cfif> 
	
	<cfset variables.tempZipFilePath = variables.tempDir & "/" & url.archiveID & ".zip" /> 
	 
	<cfset variables.zipFilePath = application.config.archiveDirectory & "/" & url.archiveID & ".zip" />
	
	<cfset variables.fileEntryPath = replaceNoCase(variables.file.filePath,variables.archive.builddir,"") />
	
	<!--- extract the archive zip to the temp directory --->
	<cfzip action="unzip" file="#variables.zipFilePath#" destination="#variables.tempDir#" filter="*.zip" />
							
	<cfset variables.fileContent = application.objs.global.getContentsOfFileInZip(variables.tempZipFilePath,variables.fileEntryPath) />
	
	<!--- delete the temp file --->
	<cffile action="delete" file="#variables.tempZipFilePath#" />
	
	<cfset variables.newLine = chr(10) />
	
	<cfset variables.data = listToArray(variables.fileContent,variables.newline,true) />
	<cfset variables.totalLines = arrayLen(variables.data) />
	
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
				copyCodeArea_hide();
			}		
		
			function copyCodeArea_show () 
			{
				$('copyCodeArea').show();
				$('copyCodeArea_show_link').hide();
				$('codeTextArea').select();
			}
		
			function copyCodeArea_hide () 
			{
				$('copyCodeArea').hide();
				$('copyCodeArea_show_link').show();
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
							<h1>View Source: <a href="#application.settings.appBaseDir#/archive/archive.cfm?archiveID=#variables.archive.archiveID#">#variables.archive.archiveID#</a>: <a href="#application.settings.appBaseDir#/archive/viewFileSource.cfm?archiveID=#variables.archive.archiveID#&fileID=#variables.file.fileID#">#variables.fileEntryPath#</a></h1>
						</div>
						
						<div class="contentSection">
							
							<a href="javascript:copyCodeArea_show()" id="copyCodeArea_show_link">Copy Code</a>
							
							<div id="copyCodeArea" style="display:none;">
								<a href="javascript:copyCodeArea_hide()">Hide Copy Code</a><br />
								<textarea id="codeTextArea" cols="100" rows="15">#variables.fileContent#</textarea>
							</div>
							
							<table class="dataTable">
								<tr>
									<th width="75" class="right">
										Line
									</th>
									<th>
										&nbsp;
									</th>
								</tr>
								<cfloop from="1" to="#variables.totalLines#" index="variables.line">
									<tr <cfif variables.line MOD 2 EQ 0>class="alt"</cfif>>
										<td class="right">
											<a name="line#variables.line#">##&nbsp;</a><a href="#request.currentPage###line#variables.line#" style="text-decoration:none;">#numberFormat(variables.line,repeatString("0",len(variables.totalLines)))#</a>
										</td>
										<td>
											#htmlCodeFormat(variables.data[variables.line])#
										</td>
									</tr>
								</cfloop>
							</table>
							
						</div>
					
					</cfoutput>
				</div>
			</div>
		</div>
		
		<cfinclude template="#application.settings.appBaseDir#/inc/footer.cfm" />
		
		
	</body>
</html>
















