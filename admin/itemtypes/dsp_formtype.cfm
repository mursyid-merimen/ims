<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">


<cfparam name="TYPEID" default="">
<cfset q_get = {}>

<cfif TYPEID NEQ "">
    <cfquery name="q_get" datasource="#request.MTRDSN#">
        SELECT vaTYPENAME, vaTYPEDESC  FROM IMS_TYPES WHERE iTYPEID = <cfqueryparam value="#TYPEID#" cfsqltype="cf_sql_integer">
    </cfquery>
</cfif>


<cfoutput>
<form action="<cfif TYPEID EQ "">index.cfm?fusebox=admin&fuseaction=act_type&#request.mtoken#<cfelse>index.cfm?fusebox=admin&fuseaction=act_type&#request.mtoken#</cfif>" method="post">
    <input type="hidden" name="iTYPEID" value="#TYPEID#">

    <label>Name:</label><br>
    <input type="text" name="vaTYPENAME" 
           value="<cfif StructKeyExists(q_get, 'vaTYPENAME')>#q_get.vaTYPENAME#</cfif>" required><br><br>

    <label>Description:</label><br>
    <textarea name="vaTYPEDESC"><cfif StructKeyExists(q_get, 'vaTYPEDESC')>#q_get.vaTYPEDESC#</cfif></textarea><br><br>

    <button type="submit">Save</button>
</form>
</cfoutput>
