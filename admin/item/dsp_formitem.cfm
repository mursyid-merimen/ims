<cfparam name="ITEMID" default="">
<cfset q_get = QueryNew("")>

<cfif ITEMID NEQ "">
    <cfquery name="q_get" datasource="#request.MTRDSN#">
        SELECT * FROM IMS_ITEMS WHERE iITEMID = <cfqueryparam value="#ITEMID#" cfsqltype="cf_sql_integer">
    </cfquery>
</cfif>

<cfquery name="q_types" datasource="#request.MTRDSN#">
    SELECT iTYPEID, vaTYPENAME FROM IMS_TYPES WHERE siSTATUS = 0 ORDER BY vaTYPENAME
</cfquery>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Item Type Form</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- Bootstrap 5 CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
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
<cfoutput>
<div class="container py-5">
    <form id="itemForm" name="itemForm" 
          action="index.cfm?fusebox=admin&fuseaction=act_item&#request.mtoken#" 
          method="post" autocomplete="off">

        <input type="hidden" name="iITEMID" value="#ITEMID#">

        <!-- Tag -->
        <div class="mb-3">
            <label for="vaTAG" class="form-label">Tag (Unique)</label>
            <input type="text" class="form-control" id="vaTAG" name="vaTAG" 
                    CHKREQUIRED CHKNAME="Tag"
                    onblur="DoReq(this);"
                    value="<cfif StructKeyExists(q_get, 'vaTAG')>#q_get.vaTAG#<cfelse></cfif>"
                    >
        </div>

        <!-- Item Name -->
        <div class="mb-3">
            <label for="vaITEMNAME" class="form-label">Item Name</label>
            <input type="text" class="form-control" id="vaITEMNAME" name="vaITEMNAME" 
                    CHKREQUIRED CHKNAME="Item Name"
                    onblur="DoReq(this);"
                    value="<cfif StructKeyExists(q_get, 'vaITEMNAME')>#q_get.vaITEMNAME#<cfelse></cfif>"
                    >
        </div>

        <!-- Item Type -->
        <div class="mb-3">
            <label for="iTYPEID" class="form-label">Item Type</label>
            <select class="form-select" id="iTYPEID" name="iTYPEID" 
                CHKREQUIRED CHKNAME="Type"
                onblur="DoReq(this);">
                
                <option value="">-- Select Type --</option>
                <cfloop query="q_types">
                    <option value="#iTYPEID#" <cfif StructKeyExists(q_get, "iTYPEID") AND iTYPEID EQ q_get.iTYPEID>selected</cfif>>#vaTYPENAME#</option>
                </cfloop>
            </select>
        </div>

        <!-- Brand -->
        <div class="mb-3">
            <label for="vaBRAND" class="form-label">Brand</label>
            <input type="text" class="form-control" id="vaBRAND" name="vaBRAND" 
                    CHKREQUIRED CHKNAME="Item Brand"
                    onblur="DoReq(this);"
                    value="<cfif StructKeyExists(q_get, 'vaBRAND')>#q_get.vaBRAND#<cfelse></cfif>"
                    >
        </div>

        <!-- Model -->
        <div class="mb-3">
            <label for="vaMODEL" class="form-label">Model</label>
            <input type="text" class="form-control" id="vaMODEL" name="vaMODEL" 
                    CHKREQUIRED CHKNAME="Item Model"
                    onblur="DoReq(this);"
                    value="<cfif StructKeyExists(q_get, 'vaMODEL')>#q_get.vaMODEL#<cfelse></cfif>"
                    >
        </div>

        <!-- Location -->
        <div class="mb-3">
            <label for="vaLOCATION" class="form-label">Location</label>
            <input type="text" class="form-control" id="vaLOCATION" name="vaLOCATION" 
                    
                    value="<cfif StructKeyExists(q_get, 'vaLOCATION')>#q_get.vaLOCATION#<cfelse></cfif>"
                    >
        </div>

        <!-- Description -->
        <div class="mb-3">
            <label for="vaITEMDESC" class="form-label">Description</label>
            <textarea class="form-control" id="vaITEMDESC" name="vaITEMDESC" rows="3"
                    MRMOBJ="TEXTAREA" 
                    MAXCHAR="500"><cfif StructKeyExists(q_get, 'vaITEMDESC')>#q_get.vaITEMDESC#<cfelse></cfif>
                    </textarea>
        </div>

        <!-- Serial No. -->
        <div class="mb-3">
            <label for="vaSERIALNO" class="form-label">Serial No.</label>
            <input type="text" class="form-control" id="vaSERIALNO" name="vaSERIALNO" 
                    CHKREQUIRED CHKNAME="Serial No."
                    onblur="DoReq(this);"
                    value="<cfif StructKeyExists(q_get, 'vaSERIALNO')>#q_get.vaSERIALNO#<cfelse></cfif>"
                    >
        </div>

        

        <!-- Purchase Date -->
        <div class="mb-3">
            <label for="dtPURCHASED" class="form-label">Purchase Date</label>
            <input id="dtPURCHASED" name="dtPURCHASED" type="text" 
                MRMOBJ="CALDATE" CHKREQUIRED CHKNAME="Purchase Date" 
                class="form-control"
                value="<cfif StructKeyExists(q_get, 'dtPURCHASED')>#DateFormat(q_get.dtPURCHASED, 'yyyy-mm-dd')#</cfif>">
        </div>


        <!-- Submit -->
        <button type="button" onclick="if(FormVerify(document.itemForm)) document.itemForm.submit();" 
                class="btn btn-<cfif ITEMID EQ "">primary<cfelse>warning</cfif> w-100">
            <cfif ITEMID EQ "">Save<cfelse>Update</cfif>
        </button>
    </form>
</div>
</cfoutput>

<!-- Bootstrap 5 JS -->

</body>
</html>

