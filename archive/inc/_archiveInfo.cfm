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
	<h2 class="sectionTitle">Archive Info</h2>
	
	<table width="100%" class="dataTable">
		<tr>
			<th width="15%">
				Archive ID:
			</th>
			<td class="monospace" width="35%">
				#variables.archive.archiveID#
			</td>
			<th width="15%">
				SHA Hash:
			</th>
			<td width="35%" class="monospace <cfif variables.archive.archiveSHAHash NEQ variables.currentSHAHash> fail<cfelse> pass</cfif>">
				#lcase(variables.archive.archiveSHAHash)#
			</td>
		</tr>
		<tr>
			<th>
				Build System Name:
			</th>
			<td>
				#variables.archive.buildSystemName#
			</td>
			<th>
				File Count:
			</th>
			<td>
				#variables.archive.fileCount#
			</td>
		</tr>
		<tr>
			<th>
				Application:
			</th>
			<td>
				<a href="#application.settings.appBaseDir#/archive/search.cfm?appName=#variables.archive.applicationName#&inclObsolete=1">#variables.archive.applicationName#</a>
			</td>
			<th>
				Version:
			</th>
			<td class="<cfif variables.archive.isObsolete>fail</cfif>">
				#variables.archive.versionName# <cfif variables.archive.isObsolete><em>(obsolete)</em</cfif>
			</td>
		</tr>
		<tr>
			<th>
				Project Name / Number:
			</th>
			<td>
				#variables.archive.projectName# / #variables.archive.projectNumber#
			</td>
			<th>
				Ticket / Issue Numbers:
			</th>
			<td>
				#variables.archive.ticketNumber#
			</td>
		</tr>
		<tr>
			<th>
				Author(s):
			</th>
			<td>
				#variables.archive.author#
			</td>
			<th>
				Change Reason:
			</th>
			<td>
				#variables.archive.changeReason#
			</td>
		</tr>
		<tr>
			<th>
				Build By:
			</th>
			<td>
				#variables.archive.buildByUserFullname# (#variables.archive.buildByUserEmail#)
			</td>
			<th>
				Build On:
			</th>
			<td>
				#application.objs.global.formatDate(variables.archive.buildOn)# #application.objs.global.formatTime(variables.archive.buildOn)#
			</td>
		</tr>
		<tr>
			<th>
				Change Description:
			</th>
			<td colspan="3">
				#variables.archive.changeDescription#
			</td>										
		</tr>
		<cfif variables.archive.isBackupArchive>
			<tr>
				<th>
					Backup For Archive:
				</th>
				<td colspan="3">
					<a href="#application.settings.appBaseDir#/archive/archive.cfm?archiveID=#variables.archive.backupForArchiveID#">#variables.archive.backupForArchiveID#</a>
				</td>										
			</tr>
		</cfif>
	</table>
</cfoutput>