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