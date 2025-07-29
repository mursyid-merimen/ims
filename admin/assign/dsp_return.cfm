<cfif structKeyExists(URL, "ITEMID")>
    <cfset ITEMID = URL.ITEMID>
<cfelse>
    <cfoutput><div class="alert alert-danger">Missing item ID.</div></cfoutput>
    <cfabort>
</cfif>

<cfquery name="q_asgmt" datasource="#request.MTRDSN#">
    SELECT TOP 1
        a.iASGMTID, a.iITEMID, a.iUSID, a.dtASGNDON, a.vaREMARKS,
        i.vaITEMNAME, i.vaTAG, i.vaBRAND, i.vaMODEL,
        u.vaUSNAME, u.vaUSID
    FROM IMS_ASGMT a
    INNER JOIN IMS_ITEMS i ON i.iITEMID = a.iITEMID
    INNER JOIN SEC0001 u ON u.iUSID = a.iUSID
    WHERE a.iITEMID = <cfqueryparam value="#ITEMID#" cfsqltype="cf_sql_integer">
      AND a.siACTIVE = 1
    ORDER BY a.dtASGNDON DESC
</cfquery>

<cfif q_asgmt.recordCount EQ 0>
    <cfoutput><div class="alert alert-warning">No active assignment found for this item.</div></cfoutput>
    <cfabort>
</cfif>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Return Form</title>
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
<form id="returnForm" name="returnForm"
    action="index.cfm?fusebox=admin&fuseaction=act_assign&#request.mtoken#" 
    method="post" enctype="multipart/form-data">
    <!-- Hidden fields -->
    <cfoutput>
        <input type="hidden" name="operation" value="RETURN">
        <input type="hidden" name="iASGMTID" value="#q_asgmt.iASGMTID#">
    </cfoutput>

    <!-- Display item info -->
    <div class="mb-3">
        <label>Item Name:</label><br>
        <cfoutput>#q_asgmt.vaITEMNAME#</cfoutput><br><br>
    </div>

    <div class="mb-3">
        <label>Brand:</label><br>
        <cfoutput>#q_asgmt.vaBRAND#</cfoutput><br><br>
    </div>

    <div class="mb-3">
        <label>Tag:</label><br>
        <cfoutput>#q_asgmt.vaTAG#</cfoutput><br><br>
    </div>

    <div class="mb-3">
        <label>Assigned To:</label><br>
        <cfoutput>#q_asgmt.vaUSNAME# (#q_asgmt.vaUSID#)</cfoutput><br><br>
    </div>

    <div class="mb-3">
        <label>Assigned On:</label><br>
        <cfoutput>#DateFormat(q_asgmt.dtASGNDON)#</cfoutput><br><br>
    </div>
    <!--- <cfdump var="#DateFormat(q_asgmt.dtASGNDON, "dd/mm/yyyy")#"> --->

    <!--- Date --->
    <div class="mb-3">
        <label for="dtRETURNED" class="form-label">Returned On</label>
        <cfoutput>
            <input id="dtRETURNED" name="dtRETURNED" type="text" MRMOBJ=CALDATE CHKREQUIRED CHKNAME="Return Date" class="form-control"
                DTMIN="#DateFormat(q_asgmt.dtASGNDON, "dd/mm/yyyy")#"
                >
        </cfoutput>
    </div>

    <!-- Condition and comments -->
    <div class="mb-3">
        <label for="vaCONDITION">Condition:</label><br>
        <select name="vaCONDITION" id="vaCONDITION" class="form-select"
            CHKREQUIRED CHKNAME="Condition"
            onblur="DoReq(this);"
            >
            <option value="">-- Select Condition --</option>
            <option value="Available">Available</option>
            <option value="Retired">Retired</option>
        </select>
    </div>

    <!-- File upload -->
    <div class="mb-3">
        <label>Asset Return Document:</label>
            <input type="file" class="form-control" name="FNDOCUP" accept=".pdf">
                <small class="text-danger">*PDF only</small>
            <input type="hidden" name="fileUploaded" value="0">
        <input type="hidden" name="ONMDOCUP" value="Return Document">
    </div>
    

    

    <div class="mb-3">
        <label for="vaCOMMENTS">Comments:</label><br>
        <textarea 
            name="vaCOMMENTS" 
            id="vaCOMMENTS" 
            class="form-control"
            rows="4"
            MRMOBJ=TEXTAREA 
            MAXCHAR=250>
        </textarea>
    </div>

    <input 
            type="button" 
            value="Submit" 
            onclick="if(FormVerify(document.all('returnForm'))) document.returnForm.submit();" 
            class="btn btn-<cfif q_asgmt.iASGMTID EQ "">primary<cfelse>warning</cfif> w-100">
</form>
</div>
</body>
</html>