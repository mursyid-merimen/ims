<cfparam name="iITEMID" type="numeric">

<cfquery datasource="#request.MTRDSN#">
    UPDATE IMS_ITEMS SET
        siSTATUS = 0,
        iMODBY = <cfqueryparam value="#SESSION.USERID#" cfsqltype="cf_sql_integer">,
        dtMODON = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">
    WHERE iITEMID = <cfqueryparam value="#iITEMID#" cfsqltype="cf_sql_integer">
</cfquery>

<cflocation url="dsp_list.cfm">
