			<cfparam name="application.config.serverName" default="" />
			<!-- BEGIN HEADER -->
			<div id="header">
				<cfoutput>
					<div id="hTitle">
						<h1>#application.settings.appTitle# - #application.config.serverName#</h1>
					</div>
					<div id="hMenu">					
						<ul>
							<cfif session.login.isLoggedIn()>
								<li><a href="#application.settings.appBaseDir#/">Home</a></li>							
								<cfif session.login.isUserInGroup("ADMIN")>
									<li><a href="#application.settings.appBaseDir#/admin/index.cfm">Admin</a></li>
								</cfif>
								<li><a href="#application.settings.appBaseDir#/remote/">Remote Servers</a></li>
							<cfelseif cgi.SCRIPT_NAME NEQ "#application.settings.appBaseDir#/createConfig.cfm">
								<li><a href="#application.settings.appBaseDir#/login.cfm">Login</a></li>	
							</cfif>
						</ul>
					</div>
				</cfoutput>
			</div>
			<!-- END HEADER -->
			