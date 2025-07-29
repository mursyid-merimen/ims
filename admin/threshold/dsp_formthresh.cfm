<cfparam name="iTHRESHID" default="">
<cfset q_get = {}>

<!--- <cfif THRESHID NEQ "">
    <cfquery name="q_get" datasource="#request.MTRDSN#">
        SELECT iTHRESHID, nMINQTY, nMAXQTY, iTYPEID
        FROM IMS_THRESH
        WHERE iTHRESHID = <cfqueryparam value="#THRESHID#" cfsqltype="cf_sql_integer">

    </cfquery>
</cfif> --->

<cfif THRESHID NEQ "">
    <cfquery name="q_get" datasource="#request.MTRDSN#">
        SELECT 
            th.iTHRESHID,
            th.nMINQTY,
            th.nMAXQTY,
            th.iTYPEID,
            ty.vaTYPENAME,
            ty.vaTYPEDESC
        FROM IMS_THRESH th
        LEFT JOIN IMS_TYPES ty ON ty.iTYPEID = th.iTYPEID
        WHERE th.iTHRESHID = <cfqueryparam value="#THRESHID#" cfsqltype="cf_sql_integer">
    </cfquery>
</cfif>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Item Type Form</title>
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
<script src="/services/scripts/JQuery/jquery-3.7.1.min.js"></script> <script src="/services/scripts/unencoded/SVCmain.js"></script> <link href="/services/scripts/SVCcss.css" rel=stylesheet type=text/css></link> 
<script>

	JSVCSetLocale(1);

function TestLocale(obj)
{
	window.location.href=request.approot+"services/formexample.cfm?locid="+obj.value;
}

</script>
<script>AddOnloadCode("MrmPreprocessForm()");</script>

<cfoutput>
<div class="container py-5">
<form id="threshForm" name="threshForm"
    action="index.cfm?fusebox=admin&fuseaction=act_editthresh&#request.mtoken#" 
    method="post" onsubmit="return checkMinMax()">
    
    <input type="hidden" name="iTHRESHID" value="#THRESHID#">

    <div class="mb-3">
        <label class="form-label"><strong>Type:</strong></label>
        <p class="form-control-plaintext">#q_get.vaTYPENAME#</p>
    </div>

    <div class="mb-3">
        <label for="nMINQTY" class="form-label">Minimum Quantity</label>
        <input type="number" name="nMINQTY" id="nMINQTY" class="form-control" step="1" 
            CHKREQUIRED 
            CHKNAME="Minimum Quantity"
            onblur="JSVCInt(this,130,0)"
            value="<cfif StructKeyExists(q_get, 'nMINQTY')>#NumberFormat(q_get.nMINQTY, "9")#</cfif>">
    </div>

    <div class="mb-3">
        <label for="nMAXQTY" class="form-label">Maximum Quantity</label>
        <input type="number" name="nMAXQTY" id="nMAXQTY" class="form-control" step="1" 
            CHKREQUIRED 
            CHKNAME="Maximum Quantity"
            onblur="JSVCInt(this,130,0)"
            value="<cfif StructKeyExists(q_get, 'nMAXQTY')>#NumberFormat(q_get.nMAXQTY, "9")#</cfif>">
    </div>

    <input 
            type="button" 
            value="<cfif THRESHID EQ "">Submit<cfelse>Update</cfif>" 
            onclick="if(FormVerify(document.all('threshForm'))) document.threshForm.submit();" 
            class="btn btn-<cfif THRESHID EQ "">primary<cfelse>warning</cfif> w-100">
</form>
</div>
</cfoutput>
<script>
    function checkMinMax() {
        var minQty = parseInt(document.getElementById('nMINQTY').value);
        var maxQty = parseInt(document.getElementById('nMAXQTY').value);
        
        if (minQty > maxQty) {
            alert("Minimum quantity cannot be greater than maximum quantity.");
            return false;
        }
        return true;
    }
</script>


<!-- Bootstrap 5 JS -->

</body>
</html>

