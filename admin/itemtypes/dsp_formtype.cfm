<cfparam name="TYPEID" default="">
<cfset q_get = {}>

<cfif TYPEID NEQ "">
    <cfquery name="q_get" datasource="#request.MTRDSN#">
        SELECT vaTYPENAME, vaTYPEDESC  
        FROM IMS_TYPES 
        WHERE iTYPEID = <cfqueryparam value="#TYPEID#" cfsqltype="cf_sql_integer">
    </cfquery>
</cfif>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Item Type Form</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- Bootstrap 5 CDN -->
    <!--- <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"> --->
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
    <form id="typeForm" name="typeForm" 
          action="index.cfm?fusebox=admin&fuseaction=act_type&#request.mtoken#" 
          method="post" autocomplete="off">
        
        <input type="hidden" name="iTYPEID" value="#TYPEID#">

        <div class="mb-3">
            <label for="vaTYPENAME" class="form-label">Name</label>
            <input 
                type="text" 
                class="form-control" 
                id="vaTYPENAME" 
                name="vaTYPENAME" 
                onblur="DoReq(this);"
                CHKREQUIRED 
                CHKNAME="Name"
                value="<cfif StructKeyExists(q_get, 'vaTYPENAME')>#q_get.vaTYPENAME#</cfif>">
        </div>

        <div class="mb-3">
            <label for="vaTYPEDESC" class="form-label">Description</label>
            <textarea 
                id="vaTYPEDESC" 
                name="vaTYPEDESC" 
                class="form-control" 
                rows="3"
                MRMOBJ=TEXTAREA 
                MAXCHAR=250><cfif StructKeyExists(q_get, 'vaTYPEDESC')>#q_get.vaTYPEDESC#</cfif></textarea>
        </div>

        <input 
            type="button" 
            value="<cfif TYPEID EQ "">Submit<cfelse>Update</cfif>" 
            onclick="if(FormVerify(document.all('typeForm'))) document.typeForm.submit();" 
            class="btn btn-<cfif TYPEID EQ "">primary<cfelse>warning</cfif> w-100">
    </form>
</div>
</cfoutput>

<!-- Bootstrap JS Bundle -->

</body>
</html>
