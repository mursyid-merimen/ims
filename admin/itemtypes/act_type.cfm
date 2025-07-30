<cfparam name="url.TYPEID" default="">
<cfparam name="form.iTYPEID" default="">
<cfparam name="form.vaTYPENAME" default="">
<cfparam name="form.vaTYPEDESC" default="">
<cfset operation = "">



<!--- Determine operation type --->
<cfif structKeyExists(URL, "OPERATION") AND uCase(URL.OPERATION) EQ "DELETE" AND len(trim(url.TYPEID))>
    <cfset operation = "DELETE">
    <cfset form.iTYPEID = url.TYPEID> <!-- Ensure TYPEID is passed into the form scope for consistency -->
<cfelseif isNumeric(form.iTYPEID) AND form.iTYPEID NEQ "">
    <cfset operation = "EDIT">
<cfelse>
    <cfset operation = "ADD">
</cfif>

<!--- <cfdump var="#form#" label="Form Data">
<cfdump var="#url#" label="URL Data">
<cfdump var="#operation#" label="Operation Type">
<cfabort> --->

<!--- Validate required fields for ADD/EDIT --->
<cfif operation EQ "DELETE" OR (Len(form.vaTYPENAME) GT 0)>

    <cfstoredproc procedure="sspIMSCRTTypeWThreshold" datasource="#request.MTRDSN#" returncode="yes">
        <cfprocparam type="in" dbvarname="@as_operation" cfsqltype="cf_sql_nvarchar" value="#operation#">
        <!--- If operation is ADD, set value to null --->
        <cfprocparam type="in" dbvarname="@ai_typeid" cfsqltype="cf_sql_integer" value="#form.iTYPEID#" null="#NOT isNumeric(form.iTYPEID)#">
        <cfprocparam type="in" dbvarname="@as_typename" cfsqltype="cf_sql_nvarchar" value="#form.vaTYPENAME#">
        <cfprocparam type="in" dbvarname="@as_typedesc" cfsqltype="cf_sql_nvarchar" value="#form.vaTYPEDESC#">
        <cfprocparam type="in" dbvarname="@ai_crtby" cfsqltype="cf_sql_integer" value="#SESSION.VARS.USID#">
    </cfstoredproc>

    <!--- Outcome --->
    <cfif cfstoredproc.StatusCode EQ 1>
        <cflocation url="index.cfm?fusebox=admin&fuseaction=dsp_listtype&#Request.MToken#">
    <cfelse>
        <cfthrow TYPE="EX_DBERROR" ErrorCode="DBERROR">
    </cfif>

<cfelse>
    <cfoutput><div class="alert alert-warning">Form not submitted properly.</div></cfoutput>
</cfif>
