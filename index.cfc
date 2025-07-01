<cfcomponent>
    <cffunction name="dsp_login" hint="Display the main login page." returntype="any" output="true">
	<cfargument name="RETRYID" required="false" default=0 type="numeric"
		displayname="The number of retries"
		hint="">
	<cfargument name="USERID" required="false" default="" type="string"
		displayname="The UserID last attempted to login"
		hint="">
	<cfargument name="LF" required="false" default="" type="string"
		displayname="Link From"
		hint="">
	<cfargument name="LOCKTIME" required="false" default="" type="string"
		displayname="User locked duration"
		hint="">

	
		<cfinclude template="dsp_login.cfm">
	
	
	<cfreturn>
</cffunction>
</cfcomponent>