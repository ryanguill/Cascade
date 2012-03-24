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
		
		<h2 class="sectionTitle">Archive Certifications</h2>
		
		<table class="dataTable" width="100%">
			<tr>
				<th width="100">
					SHA
				</th>
				<th width="100">
					Type
				</th>
				<th width="175">
					Name
				</th>
				<th width="150">
					Certified On
				</th>
				<th width="175">
					System
				</th>
				<th width="100">
					Verification
				</th>
				<th>
					Notes
				</th>
				<th width="100">
					Action
				</th>
			</tr>
			<cfif variables.certifications.recordCount>
				<cfloop query="variables.certifications">
					<cfset variables.certificationHashCheck = hash(variables.certifications.certificationSystemName & variables.certifications.userEmail & variables.currentSHAHash & variables.certifications.certificationTypeName & dateFormat(variables.certifications.certificationOn,"YYYYMMDD") & timeFormat(variables.certifications.certificationOn,"HHmmss"),"SHA") />
					
					<tr <cfif variables.certifications.currentRow MOD 2 EQ 0>class="alt"</cfif>>
						<td class="monospace <cfif variables.certifications.archiveSHAHash NEQ variables.currentSHAHash> fail<cfelse> pass</cfif>">
							#lcase(left(variables.certifications.archiveSHAHash,application.settings.showFirstXCharsOfSHA))#
						</td>
						<td>
							#variables.certifications.certificationTypeName#
						</td>
						<td>
							<cftooltip tooltip="#variables.certifications.userEmail#">#variables.certifications.userFullname#</cftooltip>
						</td>
						<td>
							#application.objs.global.formatDate(variables.certifications.certificationOn)# #application.objs.global.formatTime(variables.certifications.certificationOn)#
						</td>
						<td>
							#variables.certifications.certificationSystemName#
						</td>
						<td class="monospace <cfif variables.certificationHashCheck NEQ variables.certifications.certificationHash> fail<cfelse> pass</cfif>">
							#lcase(left(variables.certifications.certificationHash,application.settings.showFirstXCharsOfSHA))#
						</td>
						<td>
							<cfif len(trim(variables.certifications.certificationNotes)) GT 50>
								<cftooltip tooltip="#variables.certifications.certificationNotes#">#left(variables.certifications.certificationNotes,50)#...</cftooltip>
							<cfelse>
								#variables.certifications.certificationNotes#
							</cfif>
						</td>
						<td>
							<cfif variables.certifications.userID EQ session.login.getUserID()>
								<!--- TODO: add a chicken switch here. --->
								<a href="action.cfm?action=removeCertification&certificationID=#variables.certifications.certificationID#&archiveID=#variables.archive.archiveID#">Remove</a>
							<cfelse>
								&nbsp;
							</cfif>
						</td>
					</tr>
				</cfloop>
			<cfelse>
				<tr>
					<td colspan="8">
						<em>This archive does not currently have any certifications.</em>
					</td>
				</tr>
			</cfif>
		</table>
		
		<cfif variables.isLocalArchive>
			<cfif variables.certifications.recordCount NEQ variables.certificationTypes.recordCount>
				<a href="javascript:certificationFormDiv_show()" id="certificationFormDiv_show_link">Certify this Archive</a>
			</cfif>
		</cfif>
	</div>
	
	<cfif variables.isLocalArchive>
		<div class="contentSection" id="certificationFormDiv" style="display:none;">
			
			<h2 class="sectionTitle">Certify This Archive</h2>
			
			<form action="action.cfm" method="post">
				<table class="formTable" width="100%">
					<tr>
						<th>
							Certification Type:
						</th>
						<td>
							<select name="certificationTypeName" id="certificationTypeName">
								<cfloop query="variables.certificationTypes">
									<cfif NOT listContains(valueList(variables.certifications.certificationTypeName),variables.certificationTypes.certificationTypeName) AND session.login.isUserInGroup(variables.certificationTypes.requiredUserGroupName)>
										<option value="#variables.certificationTypes.certificationTypeName#">#variables.certificationTypes.certificationTypeName#</option>
									</cfif>
								</cfloop>
							</select>
						</td>
					</tr>
					<tr>
						<th valign="top">
							Certification Notes:
						</th>
						<td>
							<textarea name="certificationNotes" id="certificationNotes" cols="100" rows="5"></textarea>
						</td>
					</tr>
					<tr>
						<td colspan="2" class="right">
							<input type="hidden" name="archiveID" value="#url.archiveID#" />
							<input type="hidden" name="action" value="certifyArchive" />
							<input type="submit" value="Certify Archive" />
						</td>
					</tr>
				</table>
				
				<a href="javascript:certificationFormDiv_hide()">Cancel</a>
			</form>
			
		</div>
	</cfif>
</cfoutput>