<cfif structKeyExists(URL, "ITEMID")>
    <cfset ITEMID = URL.ITEMID>
</cfif>

<cfquery name="q_users" datasource="#request.MTRDSN#">
    SELECT iUSID, vaUSID, vaUSNAME
    FROM SEC0001
    WHERE siSTATUS = 0 AND iCOID=1
    ORDER BY vaUSID
</cfquery>

<cfquery name="q_item" datasource="#request.MTRDSN#">
    SELECT iITEMID, vaITEMNAME, vaTAG, vaBRAND, vaMODEL
    FROM IMS_ITEMS
    WHERE siSTATUS = 0 AND iITEMID = <cfqueryparam value="#ITEMID#" cfsqltype="cf_sql_integer">
</cfquery>

<cfif q_item.iITEMID EQ 0>
    <cfoutput><div class="alert alert-danger">Item not found.</div></cfoutput>
    <cfabort>
</cfif>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Assign Form</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    
    <style>
        input[readonly] {
            background-color: #f8f9fa;
        }
    </style>
</head>


<body>
<!--- <cfdump var="#attributes.iRecordID#"> --->

<style>
.code {color:blue; font-family: 'courier sans ms'}
.quest { color:red;}
</style>

<script>
var request=new Object();

request.apppath="/";
request.approot="/";

sysdt=new Date();
</script>
<script src="/services/scripts/JQuery/jquery-3.7.1.min.js"></script> <script src="/services/scripts/unencoded/SVCmain.js"></script> <script src="/services/scripts/unencoded/SVCcal.js"></script> <link href="/services/scripts/SVCcss.css" rel=stylesheet type=text/css></link> 
<script>

	JSVCSetLocale(1);

function TestLocale(obj)
{
	window.location.href=request.approot+"services/formexample.cfm?locid="+obj.value;
}

</script>
<script>AddOnloadCode("MrmPreprocessForm()");</script>


<div class="container py-5">
<form id="assignForm" name="assignForm"
    action="index.cfm?fusebox=admin&fuseaction=act_assign&#request.mtoken#" 
    method="post" enctype="multipart/form-data">
    <!-- Hidden field to keep the item ID -->
    <input type="hidden" name="operation" value="ASSIGN">
    <cfoutput>
        <input type="hidden" name="iITEMID" value="#q_item.iITEMID#">
    </cfoutput>

    <div class="mb-3">
        <label>Item Name:</label><br>
        <cfoutput>#q_item.vaITEMNAME#</cfoutput><br><br>
    </div>

    <div class="mb-3">
        <label>Brand:</label><br>
        <cfoutput>#q_item.vaBRAND#</cfoutput><br><br>
    </div>

    <div class="mb-3">
        <label>Tag:</label><br>
        <cfoutput>#q_item.vaTAG#</cfoutput><br><br>
    </div>

    <!--- Date --->
    <div class="mb-3">
        <label for="dtASGNDON" class="form-label">Assigned On</label>
        <input id="dtASGNDON" name="dtASGNDON" type="text" MRMOBJ=CALDATE CHKREQUIRED CHKNAME="Assigned Date" class="form-control"
            >
    </div>

    <!-- User selection -->
    <div class="mb-3">
        <label for="iUSID">Assign To User:</label><br>
        <cfoutput>
            <select class="form-select" name="iUSID" id="iUSERID" required
                CHKREQUIRED CHKNAME="User"
                onblur="DoReq(this);">

                <option value="">-- Select User --</option>
                <cfloop query="q_users">
                    <option value="#iUSID#">#vaUSNAME# - #vaUSID#</option>
                </cfloop>
            </select>
        </cfoutput>
    </div>

    <th>Asset Transfer Document</th>
        <td>
            <input type="file" class="form-control" id="FNDOCUP" name="FNDOCUP" accept=".pdf">
            <small style="color: red;">*PDF file</small>
            <input type="hidden" id="ONMDOCUP" name="ONMDOCUP" value="Assignment Document">
        </td>
    <br>
    <!-- Optional condition and notes -->

    <!--- <div class="mb-3">
        <label for="vaCONDITION">Condition (Optional):</label><br>
        <select name="vaCONDITION" id="vaCONDITION" class="form-select">
            <option value="">-- Select Condition --</option>
            <option value="New">New</option>
            <option value="Good">Good</option>
            <option value="Fair">Fair</option>
            <option value="Poor">Poor</option>
            <option value="Damaged">Damaged</option>
        </select>
    </div> --->

    <div class="mb-3">
        <label for="vaREMARKS">Remarks:</label><br>
        <textarea 
            name="vaREMARKS" 
            id="vaREMARKS" 
            class="form-control"
            rows="3"
            MRMOBJ=TEXTAREA 
            MAXCHAR=250>
        </textarea>
    </div>

    <input 
            type="button" 
            value="Submit" 
            onclick="if(FormVerify(document.all('assignForm'))) document.assignForm.submit();" 
            class="btn btn-<cfif q_item.iITEMID EQ "">primary<cfelse>warning</cfif> w-100">
</form>
</div>
</body>
</html>
