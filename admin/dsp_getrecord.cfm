<cfparam name="iRecordID" default="0">

<cfquery name="q_rec" datasource="SimpleDB">
    SELECT *
    FROM Records 
    WHERE iRecordID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#iRecordID#">
</cfquery>
