<cfmodule TEMPLATE="/services/CustomTags/SVCDISABLEDIRECT.cfm" Path="#GetCurrentTemplatePath()#">

<cfparam name="url.iUSID" default="">
<cfset iUSID = trim(url.iUSID)>
<cfset isEdit = len(iUSID) GT 0>
<cfset staff = structNew()>

<cffunction name="queryRowToStruct" access="public" returntype="struct">
    <cfargument name="q" required="true" type="query">
    <cfset var rowStruct = structNew()>
    <cfloop list="#q.columnList#" index="col">
        <cfset rowStruct[col] = q[col][1]>
    </cfloop>
    <cfreturn rowStruct>
</cffunction>

<cfif isEdit>
    <cfquery name="q_staff" datasource="claims_dev">
        SELECT *
        FROM SEC0001
        WHERE iUSID = <cfqueryparam value="#iUSID#" cfsqltype="cf_sql_integer">
    </cfquery>

    <cfif q_staff.recordCount EQ 1>
        <cfset staff = queryRowToStruct(q_staff)>
    <cfelse>
        <cfset isEdit = false>
    </cfif>
</cfif>

<!--- Render the form (modular) --->
<cfmodule template="dsp_staffform.cfm"
          iUSID="#iUSID#"
          isEdit="#isEdit#"
          staff="#staff#">
