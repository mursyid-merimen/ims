<cfquery name="q_list" datasource="#request.MTRDSN#">
SELECT 
    i.iITEMID,
    i.vaITEMNAME,
    i.vaBRAND,
    i.vaMODEL,
    a.iUSID,
    u.vaUSNAME,
    a.dtASGNDON,
    a.vaREMARKS
FROM IMS_ITEMS i
LEFT JOIN (
    SELECT * FROM IMS_ASGMT WHERE siACTIVE = 1 AND siSTATUS = 0
) a ON i.iITEMID = a.iITEMID
LEFT JOIN SEC0001 u ON a.iUSID = u.iUSID
WHERE i.siSTATUS = 0
ORDER BY i.vaITEMNAME
</cfquery>


<cfoutput>
<h2>Asset Assignment List</h2>

<table class="table table-bordered table-striped">
    <thead>
        <tr>
            <th>Item</th>
            <th>Brand</th>
            <th>Model</th>
            <th>Assigned To</th>
            <th>Assigned Date</th>
            <th>Status</th>
            <th>Action</th>
        </tr>
    </thead>
    <tbody>
        <cfloop query="q_list">
            <tr>
                <td>#vaITEMNAME#</td>
                <td>#vaBRAND#</td>
                <td>#vaMODEL#</td>
                <td><cfif len(trim(vaUSNAME))>#vaUSNAME#<cfelse>-</cfif></td>
                <td>
                    <cfif isDate(dtASGNDON)>
                        #DateFormat(dtASGNDON, "yyyy-mm-dd")#
                    <cfelse>
                        -
                    </cfif>
                </td>
                <td>
                    <cfif NOT len(vaUSNAME)>
                        <span class="badge bg-warning text-dark">Unassigned</span>
                    <cfelse>
                        <span class="badge bg-success">Assigned</span>
                    </cfif>
                </td>
                <td>
                    <cfif NOT len(vaUSNAME)>
                        <a href="index.cfm?fusebox=admin&fuseaction=dsp_assign&ITEMID=#iITEMID#&#request.mtoken#" class="btn btn-sm btn-primary">Assign</a>
                    <cfelse>
                        <a href="index.cfm?fusebox=admin&fuseaction=act_returnitem&ITEMID=#iITEMID#&#request.mtoken#" class="btn btn-sm btn-danger">Mark Returned</a>
                    </cfif>
                </td>
            </tr>
        </cfloop>
    </tbody>
</table>

</cfoutput>
