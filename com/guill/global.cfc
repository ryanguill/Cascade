<cfcomponent>

	<cffunction name="formatDate" access="public" returntype="string" output="false" hint="">
		<cfargument name="date" type="date" required="True" />
		
		<cfif dateCompare(arguments.date,application.settings.never) NEQ 0>
			<cfreturn dateFormat(arguments.date,application.settings.dateFormat) />
		</cfif>
	
	<cfreturn ''/>	
	</cffunction>
	
	<cffunction name="formatTime" access="public" returntype="string" output="false" hint="">
		<cfargument name="date" type="date" required="True" />
		
		<cfif dateCompare(arguments.date,application.settings.never) NEQ 0>
			<cfreturn timeFormat(arguments.date,application.settings.timeFormat) />
		</cfif>
	
	<cfreturn ''/>	
	</cffunction>
	
	<cffunction name="doesConfigXMLExist" access="public" returntype="boolean" output="false">
		
	<cfreturn fileExists(expandPath("#application.settings.appBaseDir#/config.xml.cfm")) />
	</cffunction>
	
	
	<cffunction name="createConfigXML" access="public" returntype="boolean" output="false">
		<cfargument name="configStruct" type="struct" required="true" />
		
		<cfset var output = "" />
		
		<cfset arguments.configStruct.configCreatedTimestamp = now() />
		
		<cfwddx action="cfml2wddx" input="#arguments.configStruct#" output="output" />
		
		<cffile action="write" file="#expandPath("#application.settings.appBaseDir#/config.xml.cfm")#" output="#output#" nameconflict="overwrite" />
		
	<cfreturn true />
	</cffunction>
	
	<cffunction name="loadConfigXML" access="public" returntype="struct" output="false">
		
		<cfset var local = structNew() />
		
		<cffile action="read" file="#expandPath("#application.settings.appBaseDir#/config.xml.cfm")#" variable="local.configFileContents" />
		
		<cfwddx action="wddx2cfml" input="#local.configFileContents#" output="local.configStruct" />
		
	<cfreturn local.configStruct />
	</cffunction>

	<cffunction name="formatFileSize" access="public" returntype="string" output="false">
		<cfargument name="bytes" type="numeric" required="true" />
		
		<cfset var local = structNew() />
		
		<cfset local.kb = 1024 />
		<cfset local.mb = 1048576 />
		<cfset local.gb = 1073741824 />
		
		<cfif arguments.bytes LT local.kb>
			<cfreturn numberFormat(round(arguments.bytes * 100) / 100) & "B" />
		<cfelseif arguments.bytes LT local.mb>
			<cfreturn numberFormat(round((arguments.bytes / local.kb) * 100) / 100) & "K" />
		<cfelseif arguments.bytes LT local.gb>
			<cfreturn numberFormat(round((arguments.bytes / local.mb) * 100) / 100) & "M" />
		<cfelse>
			<cfreturn numberFormat(round((arguments.bytes / local.gb) * 100) / 100) & "G" />
		</cfif>
		
	<cfreturn numberFormat(round(arguments.bytes * 100) / 100) & "B" />
	</cffunction>
	
	<cffunction name="getFileSHAHash" access="public" returntype="string" output="false" hint="">
    	<cfargument name="filePath" type="string" required="True" />
    	
		<!--- <cfset arguments.filepath = expandPath(arguments.filepath) /> --->
		<cfset var output = "" />
		<cfset var fileBinary = "" />
			
		<cfif fileExists(arguments.filePath)>
			<cffile action="readBinary" file="#arguments.filepath#" variable="fileBinary" />
			<cfset output = hash(toBase64(fileBinary),"SHA") />
		</cfif>
    	
	<cfreturn output />
    </cffunction>
		
	<cffunction name="getArchiveZipFileHash" access="public" returntype="string" output="false" hint="">
    	<cfargument name="filePath" type="string" required="True" />
    	<cfargument name="archiveID" type="string" required="True" />
		
		<!--- <cfset arguments.filepath = expandPath(arguments.filepath) /> --->
		<cfset var output = "" />
		<cfset var fileBinary = getBinaryContentsOfFileInZip(arguments.filePath,arguments.archiveID & ".zip") />
		
		<cfset output = hash(toBase64(fileBinary),"SHA") />
		
	<cfreturn output />
    </cffunction>
	
	<cffunction name="getContentsOfFileInZip" access="public" returntype="string" output="false" hint="">
    	<cfargument name="zipFilePath" type="string" required="True" />
    	<cfargument name="filePath" type="string" required="True" />
		
		<cfset var output = "" />
		
		<cfif NOT fileExists(arguments.zipFilePath)>
			<cfreturn output />
		</cfif>
    	
		<cfzip action="read" file="#arguments.zipFilePath#" variable="output" entrypath="#arguments.filePath#" />
		
	<cfreturn output />
    </cffunction>
	
	<cffunction name="getZipManifest" access="public" returntype="struct" output="false">
		<cfargument name="zipFilePath" type="string" required="true" />
		
		<cfset var wddx = getContentsOfFileInZip(arguments.zipFilePath,"META-INF/TITUS-MANIFEST.xml") />
		<cfset var output = "" />
		
		<cfwddx action="wddx2cfml" input="#wddx#" output="output" />
		
	<cfreturn output />		
	</cffunction>	
	
	<cffunction name="setZipManifest" access="public" returntype="void" output="false">
		<cfargument name="zipFilePath" type="string" required="true" />
		<cfargument name="manifestStruct" type="struct" required="true" />
		
		<cfset var wddx = "" />
		
		<cfwddx action="cfml2wddx" input="#arguments.manifestStruct#" output="wddx" />
		
		<cfzip action="zip" file="#arguments.zipFilePath#" overwrite="no" storepath="yes">
			<cfzipparam content="#wddx#" entrypath="META-INF/TITUS-MANIFEST.xml" />
		</cfzip>
		
	</cffunction>
	
	<cffunction name="getBinaryContentsOfFileInZip" access="public" returntype="Binary" output="false" hint="">
    	<cfargument name="zipFilePath" type="string" required="True" />
    	<cfargument name="filePath" type="string" required="True" />
		
		<cfset var output = "" />
		
		<cfif NOT fileExists(arguments.zipFilePath)>
			<cfreturn output />
		</cfif>
    	
		<cfzip action="readBinary" file="#arguments.zipFilePath#" variable="output" entrypath="#arguments.filePath#" />
		
	<cfreturn output />
    </cffunction>

	



</cfcomponent>