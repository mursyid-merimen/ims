<cfif structKeyExists(FORM, "iTHRESHID") AND Len(FORM.iTHRESHID) GT 0>

  <cfquery datasource="#request.MTRDSN#">
    UPDATE IMS_THRESH
    SET 
        nMINQTY = <cfqueryparam value="#FORM.nMINQTY#" cfsqltype="cf_sql_numeric">,
        nMAXQTY = <cfqueryparam value="#FORM.nMAXQTY#" cfsqltype="cf_sql_numeric">,
        iMODBY = <cfqueryparam value="#SESSION.VARS.USID#" cfsqltype="cf_sql_integer">,
        dtMODON = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">
    WHERE iTHRESHID = <cfqueryparam value="#FORM.iTHRESHID#" cfsqltype="cf_sql_integer">
  </cfquery>

  <cflocation url="index.cfm?fusebox=admin&fuseaction=dsp_listthresh&#Request.MToken#">

<cfelse>
    <cfoutput><div class="alert alert-warning">Form not submitted properly.</div></cfoutput>
</cfif>
  


