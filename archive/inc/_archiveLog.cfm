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