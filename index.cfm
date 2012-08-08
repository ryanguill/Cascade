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


<cfsilent>
	
	<cfinclude template="#application.settings.appBaseDir#/inc/preProcess.cfm" />
	
	<cfset session.login.setCurrentArea("home") />
	
</cfsilent>

<!DOCTYPE html>
<html lang="en">
	<head>
		
		<cfinclude template="#application.settings.appBaseDir#/inc/head.cfm" />
		<cfoutput>
			<title>#application.settings.appTitle#</title>
		</cfoutput>
		
		<script type="text/javascript">
		
		</script>
		
		<style type="text/css">
	
		</style>
		
	</head>
	<body>
		
		
			<cfinclude template="#application.settings.appBaseDir#/inc/header.cfm" />
			
			<div class="container" id="mainContainer">
				<div class="row">
					<cfinclude template="#application.settings.appBaseDir#/inc/nav.cfm" />
				
					<div id="content" class="span9">
				
						<cfinclude template="#application.settings.appBaseDir#/inc/notice.cfm" />

						<cfoutput>
					
							<div class="hero-unit">
								<h1>Welcome to #application.settings.appTitle#</h1>
							
								<h2 class="sectionTitle">What would you like to do?</h2>
								
								<ul class="nav nav-list">
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
			
		
					<cfinclude template="#application.settings.appBaseDir#/inc/footer.cfm" />
				</div>
			</div>
		
		
	</body>
</html>
















