<cfparam name="attributes.iRecordID" default="#StructKeyExists(attributes.record, 'recordid') ? attributes.record.recordid : ''#">
<cfparam name="attributes.isEdit" default="false">
<cfparam name="attributes.record" default="#structNew()#">

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

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title><cfif attributes.isEdit>Edit Staff<cfelse>Add Staff</cfif></title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>

<body>
<cfoutput>
<div class="container py-5">
    <h3 class="mb-4"><cfif attributes.isEdit>Edit Staff Record<cfelse>Add New Staff</cfif></h3>
    <form id="staffForm" name="staffForm" action="index.cfm?fusebox=admin&fuseaction=act_upsertrecord&RecordID=#attributes.irecordid#" method="post" autocomplete="off">

        <div class="mb-3">
            <label for="fullname" class="form-label">Full Name</label>
            <input id="fullname" name="fullname" type="text" class="form-control" CHKREQUIRED CHKNAME="Full Name" value="<cfif attributes.isEdit>#attributes.record.vafullname#</cfif>">
        </div>

        <div class="mb-3">
            <label for="email" class="form-label">Email</label>
            <input id="email" name="email" type="text" class="form-control" CHKREQUIRED CHKNAME="Email"
                CHKREFORMAT="^[\w\-\.]+@([\w-]+\.)+[\w-]{2,4}$"
                CHKRESAMPLE="Valid email format: example@domain.com"
                value="<cfif attributes.isEdit>#attributes.record.vaemail#</cfif>">
        </div>

        <div class="mb-3">
            <label for="department" class="form-label">Department</label>
            <input id="department" name="department" type="text" class="form-control" CHKREQUIRED CHKNAME="Department"
                value="<cfif attributes.isEdit>#attributes.record.vadepartment#</cfif>">
        </div>

        <div class="mb-3">
            <label for="role" class="form-label">Role</label>
            <input id="role" name="role" type="text" class="form-control" CHKREQUIRED CHKNAME="Role"
                value="<cfif attributes.isEdit>#attributes.record.varole#</cfif>">
        </div>

        <div class="mb-3">
            <label for="username" class="form-label">Username</label>
            <input id="username" name="username" type="text" class="form-control" CHKREQUIRED CHKNAME="Username"
                value="<cfif attributes.isEdit>#attributes.record.vausername#</cfif>">
        </div>

        <input type="button" value="<cfif attributes.isEdit>Update Staff<cfelse>Submit</cfif>" 
            onclick="if(FormVerify(document.all('staffForm'))) document.staffForm.submit();" 
            class="btn btn-<cfif attributes.isEdit>warning<cfelse>primary</cfif> w-100">
    </form>
</div>
</cfoutput>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
