<cfquery name="q_items" datasource="#request.MTRDSN#">
    SELECT a.iITEMID, a.vaITEMNAME, a.vaBRAND, a.vaMODEL, a.vaLOCATION, a.siSTATUS,
           t.vaTYPENAME
    FROM IMS_ITEMS a
    LEFT JOIN IMS_TYPES t ON a.iTYPEID = t.iTYPEID
    WHERE a.siSTATUS = 0
    ORDER BY a.vaITEMNAME
</cfquery>

<h2>Inventory Items</h2>
<cfoutput>

  <a href="index.cfm?fusebox=admin&fuseaction=dsp_formitem&#Request.MToken#">Add New Item</a>
</cfoutput>

<table class="table table-bordered table-striped mx-auto w-auto">
  <thead>
    <tr>
          <th>Name</th>
          <th>Type</th>
          <th>Brand / Model</th>
          <th>Location</th>
          <th>Actions</th>
      </tr>
  </thead>  
  <tbody>
    <cfoutput query="q_items">
        <tr>
            <td>#vaITEMNAME#</td>
            <td>#vaTYPENAME#</td>
            <td>#vaBRAND# / #vaMODEL#</td>
            <td>#vaLOCATION#</td>
            <td>
                <a href="index.cfm?fusebox=admin&fuseaction=dsp_formitem&#Request.MToken#&ITEMID=#iITEMID#">Edit</a> |
                <a href="index.cfm?fusebox=admin&fuseaction=act_item&#Request.MToken#&ITEMID=#iITEMID#&OPERATION=DELETE" onclick="return confirm('Delete this item?')">Delete</a>
            </td>
        </tr>
    </cfoutput>
  </tbody>
</table>
