<cfcomponent displayname="sec" hint="Security Component for Login and Authentication">
    <cffunction name="act_login" hint="Process login attempts" returntype="any" output="true">
        <CFMODULE template="act_login.cfm" >
        <CFRETURN>
    </cffunction>
    <cffunction name="act_logout" hint="Process login attempts" returntype="any" output="true">
        <CFMODULE template="act_logout.cfm" >
        <CFRETURN>
    </cffunction>
</cfcomponent>