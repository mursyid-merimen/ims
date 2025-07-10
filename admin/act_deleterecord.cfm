<cfparam name="url.RecordID" default="0">
<cfif isNumeric(url.RecordID) AND url.RecordID GT 0>
    <cfquery name="q_dltrcd" datasource="SimpleDB">
        UPDATE Records
        SET sistatus = 1
        WHERE iRecordID = <cfqueryparam value="#url.RecordID#" cfsqltype="cf_sql_integer">
    </cfquery>

    <cflocation url="index.cfm?fusebox=MTRroot&fuseaction=dsp_home" addtoken="no">
<cfelse>
    <cfoutput><div class="alert alert-danger">Invalid Record ID</div></cfoutput>
</cfif>
