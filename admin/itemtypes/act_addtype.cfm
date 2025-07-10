<cfif structKeyExists(FORM, "vaTYPENAME") AND Len(FORM.vaTYPENAME) GT 0>

    <cfstoredproc procedure="sspIMSCRTTypeWThreshold" datasource="#request.MTRDSN#" returncode="yes">
        <cfprocparam type="in" dbvarname="@as_operation" cfsqltype="cf_sql_nvarchar" value="ADD">
        <cfprocparam type="in" dbvarname="@as_typename" cfsqltype="cf_sql_nvarchar" value="#FORM.vaTYPENAME#">
        <cfprocparam type="in" dbvarname="@as_typedesc" cfsqltype="cf_sql_nvarchar" value="#FORM.vaTYPEDESC#">
        <cfprocparam type="in" dbvarname="@ai_crtedby" cfsqltype="cf_sql_integer" value="#SESSION.VARS.USID#">
    </cfstoredproc>

    <!--- Redirect or show message based on result --->
    <cfif cfstoredproc.StatusCode EQ 1>
        <cflocation url="index.cfm?fusebox=admin&fuseaction=dsp_listtype&#Request.MToken#">
    <cfelse>
        <cfoutput><div class="alert alert-danger">Error: Type was not saved.</div></cfoutput>
    </cfif>
<cfelse>
    <cfoutput><div class="alert alert-warning">Form not submitted properly.</div></cfoutput>
</cfif>
  


