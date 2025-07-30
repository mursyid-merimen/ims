<!--- <cfdump var="#FORM#">
<!--- <cfabort> --->

<cfif structKeyExists(FORM, "vaITEMNAME") AND len(FORM.vaITEMNAME)>
    <cfstoredproc procedure="sspIMSCRTItem" datasource="#request.MTRDSN#" returncode="yes">
        <cfprocparam type="in" dbvarname="@as_operation" cfsqltype="cf_sql_nvarchar" value="ADD">
        <!--- <cfprocparam type="in" dbvarname="@ai_itemid" cfsqltype="cf_sql_integer" value="#FORM.iITEMID#" > --->
        <cfprocparam type="in" dbvarname="@as_itemname" cfsqltype="cf_sql_nvarchar" value="#FORM.vaITEMNAME#" >
        <cfprocparam type="in" dbvarname="@ai_typeid" cfsqltype="cf_sql_integer" value="#FORM.iTYPEID#" >
        <cfprocparam type="in" dbvarname="@as_brand" cfsqltype="cf_sql_nvarchar" value="#FORM.vaBRAND#" >
        <cfprocparam type="in" dbvarname="@as_model" cfsqltype="cf_sql_nvarchar" value="#FORM.vaMODEL#" >
        <cfprocparam type="in" dbvarname="@as_location" cfsqltype="cf_sql_nvarchar" value="#FORM.vaLOCATION#" >
        <cfprocparam type="in" dbvarname="@as_itemdesc" cfsqltype="cf_sql_nvarchar" value="#FORM.vaITEMDESC#" >
        <cfprocparam type="in" dbvarname="@as_serialno" cfsqltype="cf_sql_nvarchar" value="#FORM.vaSERIALNO#">
        <cfprocparam type="in" dbvarname="@as_tag" cfsqltype="cf_sql_nvarchar" value="#FORM.vaTAG#" >
        <cfprocparam type="in" dbvarname="@ad_purchased" cfsqltype="cf_sql_date" value="#FORM.dtPURCHASED#">
        <cfprocparam type="in" dbvarname="@ai_crtby" cfsqltype="cf_sql_integer" value="#SESSION.VARS.USID#">
    </cfstoredproc>

    <cfif cfstoredproc.StatusCode EQ 1>
        <cflocation url="index.cfm?fusebox=admin&fuseaction=dsp_listitem&#Request.MToken#">
    <cfelse>
        <cfoutput><div class="alert alert-danger">Error: Item was not saved.</div></cfoutput>
    </cfif>
<cfelse>
    <cfoutput><div class="alert alert-warning">Form not submitted properly.</div></cfoutput>
</cfif> --->

<cfparam name="url.ITEMID" default="">
<cfparam name="form.iITEMID" default="">
<cfparam name="form.vaITEMNAME" default="">
<cfparam name="form.iTYPEID" default="">
<cfparam name="form.vaBRAND" default="">
<cfparam name="form.vaMODEL" default="">
<cfparam name="form.vaLOCATION" default="">
<cfparam name="form.vaITEMDESC" default="">
<cfparam name="form.vaSERIALNO" default="">
<cfparam name="form.vaTAG" default="">
<cfparam name="form.dtPURCHASED" default="">
<cfset operation = "">

<!--- Determine operation type --->
<cfif structKeyExists(URL, "OPERATION") AND uCase(URL.OPERATION) EQ "DELETE" AND len(trim(url.ITEMID))>
    <cfset operation = "DELETE">
    <cfset form.iITEMID = url.ITEMID> <!-- Ensure consistency -->
<cfelseif isNumeric(form.iITEMID) AND form.iITEMID NEQ "">
    <cfset operation = "EDIT">
<cfelse>
    <cfset operation = "ADD">
</cfif>

<!--- Validate required fields for ADD/EDIT ---> 
<cfif operation EQ "DELETE" OR len(form.vaITEMNAME) GT 0>

    <cfstoredproc procedure="sspIMSCRTItem" datasource="#request.MTRDSN#" returncode="yes">
        <cfprocparam type="in" dbvarname="@as_operation" cfsqltype="cf_sql_nvarchar" value="#operation#">
        <cfprocparam type="in" dbvarname="@ai_itemid" cfsqltype="cf_sql_integer" value="#form.iITEMID#" null="#NOT isNumeric(form.iITEMID)#">
        <cfprocparam type="in" dbvarname="@as_itemname" cfsqltype="cf_sql_nvarchar" value="#form.vaITEMNAME#" null="#operation EQ 'DELETE'#">
        <cfprocparam type="in" dbvarname="@ai_typeid" cfsqltype="cf_sql_integer" value="#form.iTYPEID#" null="#NOT isNumeric(form.iTYPEID)#">
        <cfprocparam type="in" dbvarname="@as_brand" cfsqltype="cf_sql_nvarchar" value="#form.vaBRAND#" null="#form.vaBRAND EQ ''#">
        <cfprocparam type="in" dbvarname="@as_model" cfsqltype="cf_sql_nvarchar" value="#form.vaMODEL#" null="#form.vaMODEL EQ ''#">
        <cfprocparam type="in" dbvarname="@as_location" cfsqltype="cf_sql_nvarchar" value="#form.vaLOCATION#" null="#form.vaLOCATION EQ ''#">
        <cfprocparam type="in" dbvarname="@as_itemdesc" cfsqltype="cf_sql_nvarchar" value="#form.vaITEMDESC#" null="#form.vaITEMDESC EQ ''#">
        <cfprocparam type="in" dbvarname="@as_serialno" cfsqltype="cf_sql_nvarchar" value="#form.vaSERIALNO#" null="#form.vaSERIALNO EQ ''#">
        <cfprocparam type="in" dbvarname="@as_tag" cfsqltype="cf_sql_nvarchar" value="#form.vaTAG#" null="#form.vaTAG EQ ''#">
        <cfprocparam type="in" dbvarname="@ad_purchased" cfsqltype="cf_sql_date" value="#form.dtPURCHASED#" null="#form.dtPURCHASED EQ ''#">
        <cfprocparam type="in" dbvarname="@ai_crtby" cfsqltype="cf_sql_integer" value="#SESSION.VARS.USID#" null="#NOT isNumeric(SESSION.VARS.USID)#">
    </cfstoredproc>

    <!--- Outcome --->
    <cfif cfstoredproc.StatusCode EQ 1>
        <cflocation url="index.cfm?fusebox=admin&fuseaction=dsp_listitem&#Request.MToken#">
    <cfelse>
        <cfthrow TYPE="EX_DBERROR" ErrorCode="DBERROR">
    </cfif>

<cfelse>
    <cfoutput><div class="alert alert-warning">Form not submitted properly.</div></cfoutput>
</cfif>
