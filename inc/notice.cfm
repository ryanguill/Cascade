<cfif session.messenger.hasAlerts()>
	
	<cfparam name="variables.i" default="0" />
	<cfset variables.alerts = session.messenger.getAlerts() />
				
	<cfoutput>
					
		<cfloop from="1" to="#session.messenger.alertsLen()#" index="variables.i">
			<cfswitch expression="#variables.alerts[variables.i].messageType#">
				<cfcase value="Error">
					<div class="notice clearfix">
						<h2 class="alert">#variables.alerts[variables.i].messageText#</h2>
						<p>#variables.alerts[variables.i].messageDetail#</p>
					</div>
				</cfcase>
				<cfcase value="Warning">
					<div class="notice clearfix">
						<h2 class="alert">#variables.alerts[variables.i].messageText#</h2>
						<p>#variables.alerts[variables.i].messageDetail#</p>
					</div>
				</cfcase>
				<cfcase value="Information">
					<div class="notice clearfix">
						<h2 class="info">#variables.alerts[variables.i].messageText#</h2>
						<p>#variables.alerts[variables.i].messageDetail#</p>
					</div>
				</cfcase>
				<cfdefaultcase>
				
				</cfdefaultcase>
			</cfswitch>
		</cfloop>
		
	</cfoutput>
	
	<cfset session.messenger.reset() />
	<!--- 
	<cfif comparenocase(cgi.SCRIPT_NAME,"/docsrv/error.cfm") NEQ 0>
		<cfset session.messenger.reset() />
	</cfif> --->
</cfif>