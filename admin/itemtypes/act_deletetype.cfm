<cfparam name="url.TYPEID" default="">

<cfif len(trim(url.TYPEID)) GT 0>
    <cfstoredproc procedure="sspIMSCRTTypeWThreshold" datasource="#request.MTRDSN#" returncode="yes">
        <cfprocparam type="in" dbvarname="@as_operation" cfsqltype="cf_sql_nvarchar" value="DELETE">
        <cfprocparam type="in" dbvarname="@ai_typeid" cfsqltype="cf_sql_integer" value="#url.TYPEID#">
        <cfprocparam type="in" dbvarname="@as_typename" cfsqltype="cf_sql_nvarchar" value="">
        <cfprocparam type="in" dbvarname="@as_typedesc" cfsqltype="cf_sql_nvarchar" value="">
        <cfprocparam type="in" dbvarname="@ai_crtedby" cfsqltype="cf_sql_integer" value="#SESSION.VARS.USID#">
    </cfstoredproc>

    <cfif cfstoredproc.StatusCode EQ 1>
        <cflocation url="index.cfm?fusebox=admin&fuseaction=dsp_listtype&#Request.MToken#">
    <cfelse>
        <cfoutput><div class="alert alert-danger">Error: Failed to delete item type.</div></cfoutput>
    </cfif>
<cfelse>
    <cfoutput><div class="alert alert-warning">Missing TYPEID.</div></cfoutput>
</cfif>
