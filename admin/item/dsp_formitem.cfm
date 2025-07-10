<cfparam name="iITEMID" default="">
<cfset q_get = QueryNew("")>

<cfif iITEMID NEQ "">
    <cfquery name="q_get" datasource="#request.MTRDSN#">
        SELECT * FROM IMS_ITEMS WHERE iITEMID = <cfqueryparam value="#iITEMID#" cfsqltype="cf_sql_integer">
    </cfquery>
</cfif>

<cfquery name="q_types" datasource="#request.MTRDSN#">
    SELECT iTYPEID, vaTYPENAME FROM IMS_TYPES WHERE siSTATUS = 1 ORDER BY vaTYPENAME
</cfquery>

<cfoutput>
<form action="<cfif iITEMID EQ "">act_add.cfm<cfelse>act_edit.cfm</cfif>" method="post">
    <input type="hidden" name="iITEMID" value="#iITEMID#">

    <label>Name:</label><br>
    <input type="text" name="vaITEMNAME" value="<cfif StructKeyExists(q_get, 'vaITEMNAME')>#q_get.vaITEMNAME#<cfelse></cfif>" required><br><br>

    <label>Type:</label><br>
    <select name="iTYPEID">
        <cfloop query="q_types">
            <option value="#iTYPEID#" <cfif StructKeyExists(q_get, "iTYPEID") AND iTYPEID EQ q_get.iTYPEID>selected</cfif>>#vaTYPENAME#</option>
        </cfloop>
    </select><br><br>

    <label>Brand:</label><br>
    <input type="text" name="vaBRAND" value="<cfif StructKeyExists(q_get, 'vaBRAND')>#q_get.vaBRAND#<cfelse></cfif>"><br><br>

    <label>Model:</label><br>
    <input type="text" name="vaMODEL" value="<cfif StructKeyExists(q_get, 'vaMODEL')>#q_get.vaMODEL#<cfelse></cfif>"><br><br>

    <label>Location:</label><br>
    <input type="text" name="vaLOCATION" value="<cfif StructKeyExists(q_get, 'vaLOCATION')>#q_get.vaLOCATION#<cfelse></cfif>"><br><br>

    <label>Description:</label><br>
    <textarea name="vaITEMDESC"><cfif StructKeyExists(q_get, "vaITEMDESC")>#q_get.vaITEMDESC#</cfif></textarea><br><br>

    <label>Serial No.:</label><br>
    <input type="text" name="vaSERIALNO" value="<cfif StructKeyExists(q_get, 'vaSERIALNO')>#q_get.vaSERIALNO#<cfelse></cfif>"><br><br>

    <label>Tag:</label><br>
    <input type="text" name="vaTAG" value="<cfif StructKeyExists(q_get, 'vaTAG')>#q_get.vaTAG#<cfelse></cfif>"><br><br>

    <label>Purchase Date:</label><br>
    <input type="date" name="dtPURCHASED" value="<cfif StructKeyExists(q_get, 'dtPURCHASED')>#DateFormat(q_get.dtPURCHASED, 'yyyy-mm-dd')#</cfif>"><br><br>

    <button type="submit">Save</button>
</form>
</cfoutput>

