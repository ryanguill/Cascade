
<cfsilent>
	
	<cfinclude template="#application.settings.appBaseDir#/inc/preProcess.cfm" />
	
	<cfset session.login.setCurrentArea("home") />
	
</cfsilent>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
	<head>
		
		<cfinclude template="#application.settings.appBaseDir#/inc/head.cfm" />
		<cfoutput>
			<title>#application.settings.appTitle#</title>
		</cfoutput>
		
		<script type="text/javascript">
		/*
			Event.observe(window, 'load', init, false);
	
			function init() {
			
			}		
		*/	
		</script>
		
		<style type="text/css">
	
		</style>
		
	</head>
	<body>
		<div id="container">
		
			<cfinclude template="#application.settings.appBaseDir#/inc/header.cfm" />
			
			<div id="main" class="clearfix">
				<cfinclude template="#application.settings.appBaseDir#/inc/nav.cfm" />
				
				<div id="content">
					<cfinclude template="#application.settings.appBaseDir#/inc/notice.cfm" />

					<cfoutput>
					
						<div id="projectHeading">
							<h1>Welcome to #application.settings.appTitle#</h1>
						</div>
						
						<div class="contentSection">
							<h2 class="sectionTitle">What would you like to do?</h2>
							
							<ul class="menuIndex">
								<cfif session.login.isUserInGroup("build")>
									<li><a href="#application.settings.appBaseDir#/archive/build.cfm">Build a New Archive</a></li>
								</cfif>
								<cfif session.login.isUserInGroup("Upload")>
									<li><a href="#application.settings.appBaseDir#/archive/upload.cfm">Upload an Archive</a></li>
								</cfif>
								<li><a href="#application.settings.appBaseDir#/archive/browse.cfm">Browse Previously Built Archives</a></li>
								
							</ul>
							
						</div>
					
					</cfoutput>
				</div>
			</div>
		</div>
		
		<cfinclude template="#application.settings.appBaseDir#/inc/footer.cfm" />
		
		
	</body>
</html>
















