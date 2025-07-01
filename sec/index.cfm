<!--- <cfdump var="#application#"> --->
<cfswitch expression="#fuseaction#">
    <cfcase value=act_login>
        <cfinvoke component="ims.sec.index" method="act_login" >
    </cfcase>
    <cfcase value=act_logout>
        <cfinvoke component="ims.sec.index" method="act_logout" >
    </cfcase>
</cfswitch>