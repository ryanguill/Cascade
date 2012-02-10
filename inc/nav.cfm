				<!-- BEGIN NAV -->
			<cfoutput>
				<div id="nav">
					<!---<div id="nMenu">
					<!--- these elements have to be in-line for ie6 to play nice. joyous will be the day that ie6 dies. --->
					<ul>
						<li><a href="/">Home</a></li><li><a href="">Projects</a></li><li><a href="">Search</a></li><li><a href="">Reports</a></li><li><a href="">Users</a></li>
					</ul>
					</div>--->
					
					<cfif session.login.isLoggedIn()>
						<div class="nSec">
							Welcome #session.login.getFirstname()# #session.login.getLastName()#<br />
							<a href="#application.settings.appBaseDir#/action.cfm?action=logout" />Logout</a>
							
							
						</div>
					</cfif>
					
					<!---
						<div class="nSec">
							<h3 class="title">Jump to Section:</h3>
							<ul>
								<li><a href="##overview">Overview</a></li>
								<li><a href="##description">Description</a></li>
								<li><a href="##acceptance">Acceptance</a></li>
								<li><a href="##information">Project Information</a></li>
								<cfif variables.project.acceptanceType EQ "ACCEPTED">
									<li><a href="##resources">Resources</a></li>
									<li><a href="##events">Events</a></li>
									<li><a href="##issues">IssueManager</a></li>
									<li><a href="##testing">Testing</a></li>
								</cfif>
								<li><a href="##discussion">Discussion</a></li>
							</ul>
						</div>
					--->
					
					<cfif session.login.getCurrentArea() EQ "Admin">
						<div class="nSec">
							<h3 class="title">Reference Tables:</h3>
							<ul>
								<li><a href="#application.settings.appBaseDir#/admin/referenceTables/changeTypes.cfm">Change Types</a></li>
								<li><a href="#application.settings.appBaseDir#/admin/referenceTables/certificationTypes.cfm">Certification Types</a></li>
							</ul>
						</div>
						<div class="nSec">
							<h3 class="title">Manage Users:</h3>
							<ul>
								<li><a href="#application.settings.appBaseDir#/admin/userManagement/search.cfm?">Search Users</a></li>
								<li><a href="#application.settings.appBaseDir#/admin/userManagement/addUser.cfm">Add a User</a></li>
								<li><a href="#application.settings.appBaseDir#/admin/userManagement/userGroups.cfm">User Groups</a></li>	
							</ul>
						</div>
					</cfif>
					
					
					<cfif session.login.isLoggedIn()>
						<div class="nSec">
							<h3 class="title">Useful Links</h3>
							<ul>
								<cfif session.login.isUserInGroup("build")>
									<li><a href="#application.settings.appBaseDir#/archive/build.cfm">Build a New Archive</a></li>
								</cfif>
								<cfif session.login.isUserInGroup("Upload")>
									<li><a href="#application.settings.appBaseDir#/archive/upload.cfm">Upload an Archive</a></li>
								</cfif>
								<li><a href="#application.settings.appBaseDir#/archive/browse.cfm">Browse Archives</a></li>
							</ul>
						</div>
					</cfif>
					
					
					<cfif session.login.isLoggedIn()>
						<div class="nSec">
							<h3 class="title">Remote Servers:</h3>
							<ul>
								<li><a href="#application.settings.appBaseDir#/remote/index.cfm">Remote Servers Home</a></li>
								<cfif session.login.isUserInGroup("admin")>
									<li><a href="#application.settings.appBaseDir#/remote/register.cfm">Register Remote Server</a></li>
								</cfif>	
							</ul>
						</div>
						<div class="nSec">
							<cfinvoke component="#application.objs.remoteService#" method="getRemoteServers" returnvariable="variables.remoteServers" />
							<!---<cfset variables.remoteServersList = valueList(variables.remoteServers.serverName) />--->
							<h3 class="title">Remote Server Listing:</h3>
							<ul>
								<cfloop query="variables.remoteServers">
									<li><cftooltip tooltip="#variables.remoteServers.serverName#"><a href="#application.settings.appBaseDir#/remote/server.cfm?serverid=#variables.remoteServers.serverID#">#left(variables.remoteServers.serverName,20)#<cfif len(variables.remoteServers.serverName) GT 20>...</cfif></a></cftooltip></li>
								</cfloop>
							</ul>
						</div>
					</cfif>
					
				</div>
			</cfoutput>
				<!-- END NAV -->