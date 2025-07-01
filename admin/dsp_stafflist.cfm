<cfquery name="q_getStaff" datasource="claims_dev">
    SELECT iUSID, vaUSName, siROLE
    FROM SEC0001
    WHERE siROLE IN (30)
    ORDER BY vaUSName
</cfquery>



<!DOCTYPE = html>
<html lang="en">  
  <head>
    <meta charset="UTF-8">
    <title>Staff List</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  </head>
  <body>
    
    <div class="container mt-4">
        <h2>Staff List</h2>
        <table class="table table-bordered table-striped mx-auto w-auto">
        <thead>
            <tr>
                <th>Username</th>
                <th>Full Name</th>
                <th>Role</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <cfoutput query="q_getStaff">
                <tr>
                    <td>#iUSID#</td>
                    <td>#vaUSName#</td>
                    <td>#siROLE#</td>
                    <td class="d-flex gap-2">
                        <!-- Edit button -->
                        <form action="index.cfm?fusebox=admin&fuseaction=dsp_upsertstaff&iUSID=#iUSID#" method="post" style="display:inline;">
                            <button type="submit" class="btn btn-sm btn-primary">Edit</button>
                        </form>

                        <!-- Delete button -->
                        <form action="index.cfm?fusebox=admin&fuseaction=act_deletestaff&iUSID=#iUSID#" method="post" style="display:inline;" onsubmit="return confirm('Delete this staff?');">
                            <button type="submit" class="btn btn-sm btn-danger">Delete</button>
                        </form>
                    </td>
                </tr>
            </cfoutput>
        </tbody>
    </table>
    </div>
    

  </body> 
</html>

