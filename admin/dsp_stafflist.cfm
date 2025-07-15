<cfquery name="q_getStaff" datasource="claims_dev">
    SELECT 
        u.iUSID,
        u.vaUSID,
        u.vaUSName,
        u.siRole,
        r.vaDESC 
    FROM SEC0001 u
    LEFT JOIN SEC0002 r ON u.siRole = r.siROLE
    WHERE u.iCOID = 1
    ORDER BY u.vaUSName
</cfquery>



<cfdump var="#session#">

<cfset Attributes.COID = 1>




<!--- <!DOCTYPE = html>
<html lang="en">  
  <head>
    <meta charset="UTF-8">
    <title>Staff List</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  </head>
  <body> --->
    
    <!--- <div class="container mt-4"> --->
        <h2>Staff List</h2>
        <table class="table table-bordered table-striped mx-auto w-auto">
        <thead>
            <tr>
                <th>Username</th>
                <th>Full Name</th>
                <!--- <th>Department</th> --->
                <th>Role</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <cfoutput query="q_getStaff">
                <tr>
                    <td>#vaUSID#</td>
                    <td>#vaUSName#</td>
                    <!--- <td>#vaDept#</td> --->
                    <td>#vaDESC#</td>
                    <td class="d-flex gap-2">
                        <!-- Edit button -->
                        <form action="index.cfm?fusebox=admin&fuseaction=dsp_upsertstaff&COID=#Attributes.COID#&#Request.MToken#&iUSID=#iUSID#" method="post" style="display:inline;">
                            <button type="submit" class="btn btn-sm btn-primary">Edit</button>
                        </form>

                        <!-- Delete button -->
                        <form action="index.cfm?fusebox=admin&fuseaction=act_deletestaff&#Request.MToken#&iUSID=#iUSID#" method="post" style="display:inline;" onsubmit="return confirm('Delete this staff?');">
                            <button type="submit" class="btn btn-sm btn-danger">Delete</button>
                        </form>
                    </td>
                </tr>
            </cfoutput>
        </tbody>
    </table>
    <!--- </div>
    

  </body> 
</html> --->

