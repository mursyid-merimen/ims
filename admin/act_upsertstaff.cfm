<!--‐- Disable direct access and get current path --->
<cfmodule template="/services/CustomTags/SVCDISABLEDIRECT.cfm"
          path    ="#GetCurrentTemplatePath()#">

<!--‐- Only run if the form was posted with a name field --->
<cfdump var="#form#">
<cfif structKeyExists(form, "username")>

    <!--- Grab posted / optional values --->
    <cfset department  = structKeyExists(form, "department")  ? form.department  : "">
    <cfset designation = structKeyExists(form, "designation") ? form.designation : "">

    <!--- Get iUSID from URL (0 = insert, >0 = update) --->
    <cfset iUSID = ( structKeyExists(url, "iUSID")
                     AND isNumeric(url.iUSID) )
                     ? val(url.iUSID)
                     : 0 >

    <!--- Call the upsert stored procedure --->
    <cfstoredproc procedure="sspStaffDataUpsert"
                  datasource="claims_dev"
                  returncode="yes">

        <!-- primary key -->
        <cfprocparam type="in"  cfsqltype="cf_sql_integer" value="#iUSID#"           dbvarname="@iUSID">

        <!-- main columns -->
        <cfprocparam type="in"  cfsqltype="cf_sql_varchar" value="#form.username#"       dbvarname="@vaUSID">
        <cfprocparam type="in"  cfsqltype="cf_sql_varchar" value="#form.fullname#"       dbvarname="@vaUSName">
        <cfprocparam type="in"  cfsqltype="cf_sql_varchar" value="#form.email#"      dbvarname="@vaEmail">
        <cfprocparam type="in"  cfsqltype="cf_sql_varchar" value="#department#"      dbvarname="@vaDept">
        <cfprocparam type="in"  cfsqltype="cf_sql_varchar" value="#designation#"     dbvarname="@vaDesignation">

    </cfstoredproc>


    <!--- Redirect or show error --->
    <cfif cfstoredproc.StatusCode EQ 1>
        <cflocation url="index.cfm?fusebox=admin&fuseaction=dsp_stafflist" addtoken="no">
    <cfelse>
        <cfoutput>
            <div class="alert alert-danger">
                Error: Staff record was not saved.
            </div>
        </cfoutput>
    </cfif>

<cfelse>
    <cfoutput>
        <div class="alert alert-warning">
            Form not submitted properly.
        </div>
    </cfoutput>
</cfif>
