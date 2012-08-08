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
	
	<cfset session.login.setCurrentArea("archive") />
	
	<cfinvoke component="#application.daos.cascade#" method="searchArchives" returnvariable="variables.archives">
		<cfinvokeargument name="dsn" value="#application.config.dsn#" />	<!---Type:string  --->
		<cfinvokeargument name="archiveid" value="-1" />	<!---Type:String Hint: pass -1 to ignore. --->
		<cfinvokeargument name="archiveshahash" value="-1" />	<!---Type:String Hint: pass -1 to ignore. --->
		<cfinvokeargument name="buildsystemname" value="-1" />	<!---Type:String Hint: pass -1 to ignore. --->
		<cfinvokeargument name="applicationname" value="-1" />	<!---Type:String Hint: pass -1 to ignore. --->
		<cfinvokeargument name="versionname" value="-1" />	<!---Type:String Hint: pass -1 to ignore. --->
		<cfinvokeargument name="projectname" value="-1" />	<!---Type:String Hint: pass -1 to ignore. --->
		<cfinvokeargument name="projectnumber" value="-1" />	<!---Type:String Hint: pass -1 to ignore. --->
		<cfinvokeargument name="ticketnumber" value="-1" />	<!---Type:String Hint: pass -1 to ignore. --->
		<cfinvokeargument name="changereason" value="-1" />	<!---Type:String Hint: pass -1 to ignore. --->
		<cfinvokeargument name="author" value="-1" />	<!---Type:String Hint: pass -1 to ignore. --->
		<cfinvokeargument name="changedescription" value="-1" />	<!---Type:String Hint: pass -1 to ignore. --->
		<cfinvokeargument name="buildbyuserid" value="-1" />	<!---Type:String Hint: pass -1 to ignore. --->
		<cfinvokeargument name="buildbyusername" value="-1" />	<!---Type:String Hint: pass -1 to ignore. --->
		<cfinvokeargument name="buildbyuserfullname" value="-1" />	<!---Type:String Hint: pass -1 to ignore. --->
		<cfinvokeargument name="buildbyuseremail" value="-1" />	<!---Type:String Hint: pass -1 to ignore. --->
		<cfinvokeargument name="buildonAfter" value="1970-01-01" />	<!---Type:date Hint: pass 1970-01-01 to ignore --->
		<cfinvokeargument name="buildonBefore" value="1970-01-01" />	<!---Type:date Hint: pass 1970-01-01 to ignore --->
		<cfinvokeargument name="builddir" value="-1" />	<!---Type:String Hint: pass -1 to ignore. --->
		<cfinvokeargument name="deployDirSuggestions" value="-1" />	<!---Type:String Hint: pass -1 to ignore. --->
		<cfinvokeargument name="filecount" value="-1" />	<!---Type:numeric Hint: pass -1 to ignore. --->
		<cfinvokeargument name="isnativebuild" value="-1" />	<!---Type:numeric Hint:  pass -1 to ignore. --->
		<cfinvokeargument name="isbackuparchive" value="0" />	<!---Type:numeric Hint: pass -1 to ignore. --->
		<cfinvokeargument name="isObsolete" value="0" />	<!---Type:numeric Hint: pass -1 to ignore. --->
		<cfinvokeargument name="backupForArchiveID" value="-1" />	<!---Type:numeric Hint: pass -1 to ignore. --->
		<cfinvokeargument name="minimumCertificationID" value="-1" />	<!---Type:numeric Hint: pass -1 to ignore. --->
		<cfinvokeargument name="includeCertificationIDList" value="-1" />	<!---Type:string pass -1 to ignore, otherwise pass a comma delim list of certification IDs to included. --->
	</cfinvoke>

	
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
					
						<div id="projectHeading">
							<h1>Browse Archives</h1>
						</div>
						
						<cfinclude template="#application.settings.appBaseDir#/archive/inc/_archiveListing.cfm" />
					
					</cfoutput>
				</div>
			</div>
		</div>
		
		<cfinclude template="#application.settings.appBaseDir#/inc/footer.cfm" />
		
		
	</body>
</html>
















