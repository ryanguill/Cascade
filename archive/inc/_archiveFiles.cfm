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

<cfparam name="variables.isLocalArchive" default="false" />

<cfoutput>
	<div class="contentSection">
															
		<h2 class="sectionTitle">Archive Files (#variables.files.recordCount#)</h2>
		
		<a href="javascript:archiveFilesTable_show()" id="archiveFilesTable_show_link">Expand Archive Files</a>
		
		<div id="archiveFilesTable" style="display:none;">
			<a href="javascript:archiveFilesTable_hide()">Collapse Archive Files</a>
			<table class="dataTable" width="100%">
				<tr>
					<th width="25">
						&nbsp;
					</th>
					<th>
						SHA
					</th>
					<th>
						File
					</th>
				</tr>
				<cfloop query="variables.files">
					<tr <cfif variables.files.currentRow MOD 2 EQ 0>class="alt"</cfif>>
						<td class="right">
							#numberFormat(variables.files.currentRow,repeatString("0",len(variables.files.recordCount)))#
						</td>
						<td width="100" class="monospace">
							<cftooltip tooltip="#lcase(variables.files.fileSHAHash)#">#lcase(left(variables.files.fileSHAHash,application.settings.showFirstXCharsOfSHA))#</cftooltip>
						</td>
						<td>
							<cfif variables.isLocalArchive>
								<a href="#application.settings.appBaseDir#/archive/viewFileSource.cfm?archiveID=#variables.archive.archiveID#&fileID=#variables.files.fileID#">#variables.files.filePath#</a>
							<cfelse>
								#variables.files.filePath#
							</cfif>
						</td>
					</tr>
				</cfloop>
			</table>
			<a href="javascript:archiveFilesTable_hide()">Collapse Archive Files</a>
		</div>
		
	</div>
</cfoutput>