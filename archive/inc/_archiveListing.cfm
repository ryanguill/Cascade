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

<cfoutput>
	<div class="contentSection">
		<table width="100%" class="dataTable">
			<tr>
				<th width="300">
					ID
				</th>
				<!---
				<th width="100">
					SHA
				</th>
				--->
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
						<!---
						<td class="monospace">
							<cftooltip tooltip="#lcase(variables.archives.archiveSHAHAsh)#">#lcase(left(variables.archives.archiveSHAHash,application.settings.showFirstXCharsOfSHA))#</cftooltip>
						</td>
						--->
						<td>
							#variables.archives.applicationName#
						</td>
						<td class="<cfif variables.archives.isObsolete>fail</cfif>">
							<cfif variables.archives.isBackupArchive>BACKUP<cfelse>#variables.archives.versionName#</cfif>
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
					<td colspan="7">
						<em>There are no results for that search.</a>
					</td>
				</tr>
			</cfif>
		</table>
		
	</div>
</cfoutput>