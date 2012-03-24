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
	
		<h2 class="sectionTitle">Archive Deployments</h2>
		
		<table class="dataTable" width="100%">
			<tr>
				<th width="175">
					Deployed By
				</th>
				<th>
					System
				</th>
				<th width="130">
					Deployed On
				</th>
				<th>
					Deployed Dir
				</th>
				<th width="300">
					Backup Archive
				</th>
				<!---
				<th>
					Notes
				</th>
				--->
				<cfif variables.isLocalArchive>
					<th>
						Action
					</th>
				</cfif>
			</tr>
			<cfif variables.deployments.recordCount>
				<cfloop query="variables.deployments">
					<tr <cfif variables.deployments.currentRow MOD 2 EQ 0>class="alt"</cfif>>
						<td>
							#variables.deployments.deployedByUserFullname#
						</td>
						<td>
							#variables.deployments.deployedSystemName#
						</td>
						<td>
							<cfif variables.isLocalArchive>
								<a href="#application.settings.appBaseDir#/archive/deployment.cfm?archiveID=#url.archiveID#&deploymentID=#variables.deployments.deploymentID#">#application.objs.global.formatDate(variables.deployments.deployedon)# #application.objs.global.formatTime(variables.deployments.deployedon)#</a>
							<cfelse>
								#application.objs.global.formatDate(variables.deployments.deployedon)# #application.objs.global.formatTime(variables.deployments.deployedon)#
							</cfif>
						</td>										
						<td>
							#variables.deployments.deploymentDir#
						</td>
						<td class="monospace">
							<cfif variables.isLocalArchive AND variables.deployments.deployedSystemName EQ application.config.serverName>
								<a href="#application.settings.appBaseDir#/archive/archive.cfm?archiveID=#variables.deployments.backupArchiveID#">#variables.deployments.backupArchiveID#</a>
							<cfelse>
								#variables.deployments.backupArchiveID#
							</cfif>
						</td>
						<!---
						<td>
							<cfif len(trim(variables.deployments.deploymentNotes)) GT 50>
								<cftooltip tooltip="#variables.deployments.deploymentNotes#">#left(variables.deployments.deploymentNotes,50)#...</cftooltip>
							<cfelse>
								#variables.deployments.deploymentNotes#
							</cfif>
						</td>
						--->
						<cfif variables.isLocalArchive AND variables.deployments.deployedSystemName EQ application.config.serverName>
							<td width="100">
								<cfif session.login.isUserInGroup("deploy") AND variables.deployments.wasBackupTaken>
									<form action="#application.settings.appBaseDir#/archive/revertDeployment.cfm" method="get">
										<input type="hidden" name="action" value="revertDeployment" />
										<input type="hidden" name="deploymentID" value="#variables.deployments.deploymentID#" />
										<input type="hidden" name="archiveID" value="#variables.archive.archiveID#" />
										<input type="hidden" name="backupArchiveID" value="#variables.deployments.backupArchiveID#" />
										<input type="submit" value="Revert" class="smallButton" />
									</form>
								</cfif>
							</td>
						</cfif>
					</tr>
				</cfloop>	
			<cfelse>
				<tr>
					<td colspan="<cfif variables.isLocalArchive>6<cfelse>5</cfif>">
						<em>This archive has never been deployed.</em>
					</td>
				</tr>
			</cfif>							
		</table>
	</div>
</cfoutput>