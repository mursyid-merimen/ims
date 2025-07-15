<cfquery name="q_types" datasource="#request.MTRDSN#">
    SELECT iTYPEID, vaTYPENAME, vaTYPEDESC
    FROM IMS_TYPES
    WHERE siSTATUS = 0
    ORDER BY vaTYPENAME
</cfquery>

<h2>Item Types</h2>
<cfoutput>
    <a href="index.cfm?fusebox=admin&fuseaction=dsp_formtype&&#Request.MToken#">Add New Type</a>
</cfoutput>
<table class="table table-bordered table-striped mx-auto w-auto">
    <thead>   
        <tr>
            <th>Name</th>
            <th>Description</th>
            <th>Action</th>
        </tr>
    </thead>
    <tbody>
        <cfoutput query="q_types">
            <tr>
                <td>#vaTYPENAME#</td>
                <td>#vaTYPEDESC#</td>
                <td>
                    <a href="index.cfm?fusebox=admin&fuseaction=dsp_formtype&TYPEID=#iTYPEID#&#Request.MToken#">Edit</a> |
                    <a href="index.cfm?fusebox=admin&fuseaction=act_type&TYPEID=#iTYPEID#&OPERATION=DELETE&#Request.MToken#" onclick="return confirm('Delete this type?')">Delete</a>
                </td>
            </tr>
        </cfoutput>
    </tbody>
</table>

