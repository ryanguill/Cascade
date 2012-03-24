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
		
		<h2 class="sectionTitle">Archive Log</h2>
		
		<table class="dataTable" width="100%">
			<tr>
				<th width="125">
					System
				</th>
				<th width="150">
					Action
				</th>
				<th>
					Message
				</th>
				<th width="130">
					When
				</th>
			</tr>
			<cfloop query="variables.log">
				<tr <cfif variables.log.currentRow MOD 2 EQ 0>class="alt"</cfif>>
					<td valign="top">
						#variables.log.logSystemName#
					</td>
					<td valign="top">
						#variables.log.logAction#
					</td>
					<td>
						#variables.log.logMessage#
					</td>
					<td valign="top">
						#application.objs.global.formatDate(variables.log.logDateTime)# #application.objs.global.formatTime(variables.log.logDateTime)#
					</td>										
				</tr>
			</cfloop>								
		</table>
	</div>
</cfoutput>