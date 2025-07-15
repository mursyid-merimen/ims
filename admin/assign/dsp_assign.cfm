<cfquery name="q_items" datasource="#request.MTRDSN#">
    SELECT iITEMID, vaITEMNAME, vaTAG
    FROM IMS_ITEMS
    WHERE siSTATUS = 0
    ORDER BY vaITEMNAME
</cfquery>

<cfquery name="q_users" datasource="#request.MTRDSN#">
    SELECT iUSID, vaUSNAME
    FROM SEC0001
    WHERE siSTATUS = 0 and iCOID=1
    ORDER BY vaUSNAME
</cfquery>

<cfoutput>
<h2>Assign Asset</h2>

<form action="index.cfm?fusebox=admin&fuseaction=act_assignitem&#request.mtoken#" method="post">

    <label for="iITEMID">Select Item:</label><br>
    <select name="iITEMID" id="iITEMID" required>
        <option value="">-- Select Item --</option>
        <cfloop query="q_items">
            <option value="#iITEMID#">#vaITEMNAME# - #vaTAG#</option>
        </cfloop>
    </select><br><br>

    <label for="iUSERID">Assign To User:</label><br>
    <select name="iUSERID" id="iUSERID" required>
        <option value="">-- Select User --</option>
        <cfloop query="q_users">
            <option value="#iUSID#">#vaUSNAME#</option>
        </cfloop>
    </select><br><br>

    <label for="vaCONDITION">Condition (Optional):</label><br>
    <input type="text" name="vaCONDITION" id="vaCONDITION" maxlength="100"><br><br>

    <label for="vaNOTES">Notes:</label><br>
    <textarea name="vaNOTES" id="vaNOTES" rows="4" cols="50"></textarea><br><br>

    <button type="submit" class="btn btn-primary">Assign</button>
</form>
</cfoutput>
