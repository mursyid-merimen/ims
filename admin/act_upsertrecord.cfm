<cfmodule TEMPLATE="/services/CustomTags\SVCDISABLEDIRECT.cfm" Path="#GetCurrentTemplatePath()#">
    
<cfif structKeyExists(form, "name")>

    <!--- Prepare optional values --->
    <cfset hobbiesList = isDefined("form.hobbies") ? (isArray(form.hobbies) ? arrayToList(form.hobbies) : form.hobbies) : "">
    <cfset gender = structKeyExists(form, "gender") ? form.gender : "">

    <!--- Get RecordID from URL instead of FORM --->
    <cfset irecordID = (structKeyExists(url, "RecordID") AND isNumeric(url.RecordID)) ? val(url.RecordID) : 0>
    <!--- <cfdump var="#irecordID#">
    <cfabort> --->
    

    <!--- Call the stored procedure --->
    <cfstoredproc procedure="sspRecordDataUpsert" datasource="SimpleDB" returncode="yes">
        <cfprocparam type="in" cfsqltype="cf_sql_integer" value="#iRecordID#" dbvarname="@iRecordID">
        <cfprocparam type="in" cfsqltype="cf_sql_varchar" value="#form.name#" dbvarname="@vaName">
        <cfprocparam type="in" cfsqltype="cf_sql_varchar" value="#form.email#" dbvarname="@vaEmail">
        <cfprocparam type="in" cfsqltype="cf_sql_date" value="#form.dob#" dbvarname="@dtDOB">
        <cfprocparam type="in" cfsqltype="cf_sql_longvarchar" value="#form.about#" dbvarname="@vaAbout">
        <cfprocparam type="in" cfsqltype="cf_sql_varchar" value="#form.profession#" dbvarname="@vaProfession">
        <cfprocparam type="in" cfsqltype="cf_sql_varchar" value="#form.ic#" dbvarname="@vaIC">
        <cfprocparam type="in" cfsqltype="cf_sql_integer" value="#form.age#" dbvarname="@iAge">
        <cfprocparam type="in" cfsqltype="cf_sql_varchar" value="#gender#" dbvarname="@vaGender">
        <cfprocparam type="in" cfsqltype="cf_sql_varchar" value="#hobbiesList#" dbvarname="@vaHobbies">
    </cfstoredproc>


    <!--- Redirect or show message based on result --->
    <cfif cfstoredproc.StatusCode EQ 1>
        <cflocation url="index.cfm?fusebox=admin&fuseaction=dsp_home" addtoken="no">
    <cfelse>
        <cfoutput><div class="alert alert-danger">Error: Record was not saved.</div></cfoutput>
    </cfif>

<cfelse>
    <cfoutput><div class="alert alert-warning">Form not submitted properly.</div></cfoutput>
</cfif>
