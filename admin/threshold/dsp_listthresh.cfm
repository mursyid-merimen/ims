<cfquery name="q_thresh" datasource="#Request.MTRDSN#">
    SELECT t.iTHRESHID, ty.vaTYPENAME, t.nMINQTY, t.nMAXQTY
    FROM IMS_THRESH t
    JOIN IMS_TYPES ty ON t.iTYPEID = ty.iTYPEID
    WHERE t.siSTATUS = 0
    ORDER BY ty.vaTYPENAME
</cfquery>

<h2>Threshold Settings</h2>
<!--- <a href="form_addedit.cfm">Add New Threshold</a> --->
<table class="table table-bordered table-striped mx-auto w-auto">
  <thead>
    <tr>
        <th>Item Type</th>
        <th>Min Qty</th>
        <th>Max Qty</th>
      
        <th>Actions</th>
    </tr>
  </thead>
  <tbody>
    <cfoutput query="q_thresh">
        <tr>
            <td>#vaTYPENAME#</td>
            <td>#NumberFormat(nMINQTY, "9")#</td>
            <td>#NumberFormat(nMAXQTY, "9")#</td>
    
            <td>
                <a href="index.cfm?fusebox=admin&fuseaction=dsp_formthresh&THRESHID=#iTHRESHID#&&#Request.MToken#">Edit</a>
                <!--- <a href="act_delete.cfm?iTHRESHID=#iTHRESHID#" onclick="return confirm('Delete this threshold?')">Delete</a> --->
            </td>
        </tr>
    </cfoutput>
  </tbody>
</table>
