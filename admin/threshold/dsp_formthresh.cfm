<cfparam name="iTHRESHID" default="">
<cfset q_get = {}>

<!--- <cfif THRESHID NEQ "">
    <cfquery name="q_get" datasource="#request.MTRDSN#">
        SELECT iTHRESHID, nMINQTY, nMAXQTY, iTYPEID
        FROM IMS_THRESH
        WHERE iTHRESHID = <cfqueryparam value="#THRESHID#" cfsqltype="cf_sql_integer">

    </cfquery>
</cfif> --->

<cfif THRESHID NEQ "">
    <cfquery name="q_get" datasource="#request.MTRDSN#">
        SELECT 
            th.iTHRESHID,
            th.nMINQTY,
            th.nMAXQTY,
            th.iTYPEID,
            ty.vaTYPENAME,
            ty.vaTYPEDESC
        FROM IMS_THRESH th
        LEFT JOIN IMS_TYPES ty ON ty.iTYPEID = th.iTYPEID
        WHERE th.iTHRESHID = <cfqueryparam value="#THRESHID#" cfsqltype="cf_sql_integer">
    </cfquery>
</cfif>


<cfoutput>
<form action="<cfif THRESHID EQ "">act_add.cfm<cfelse>index.cfm?fusebox=admin&fuseaction=act_editthresh&#request.mtoken#</cfif>" method="post">
    <input type="hidden" name="iTHRESHID" value="#THRESHID#">

    
    
    <p><strong>Type:</strong> #q_get.vaTYPENAME#</p>

    <label>Minimum Quantity:</label><br>
    <input type="number" name="nMINQTY" step="1"
        value="<cfif StructKeyExists(q_get, 'nMINQTY')>#q_get.nMINQTY#</cfif>"
        required><br><br>

    <label>Maximum Quantity:</label><br>
    <input type="number" name="nMAXQTY" step="1"
        value="<cfif StructKeyExists(q_get, 'nMAXQTY')>#q_get.nMAXQTY#</cfif>"
        required><br><br>

    <button type="submit">Save</button>
</form>
</cfoutput>
