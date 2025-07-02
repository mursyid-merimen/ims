<cfparam name="attributes.iUSID" default="#StructKeyExists(attributes.staff, 'iUSID') ? attributes.staff.iUSID : ''#">
<cfparam name="attributes.isEdit" default="false">
<cfparam name="attributes.staff" default="#structNew()#">

<cfset vausid      = (attributes.isEdit and StructKeyExists(attributes.staff, "vaUSID"))       ? attributes.staff.vaUSID       : "">
<cfset vausname     = (attributes.isEdit and StructKeyExists(attributes.staff, "vausname"))     ? attributes.staff.vausname     : "">
<cfset iusid   = (attributes.isEdit and StructKeyExists(attributes.staff, "iusid"))   ? attributes.staff.iusid   : "">
<cfset vaemail      = (attributes.isEdit and StructKeyExists(attributes.staff, "vaemail"))      ? attributes.staff.vaemail      : "">
<cfset vadepartment = (attributes.isEdit and StructKeyExists(attributes.staff, "vadepartment")) ? attributes.staff.vadepartment : "">
<cfset sirole       = (attributes.isEdit and StructKeyExists(attributes.staff, "sirole"))       ? attributes.staff.sirole       : "">
<cfset vadesignation = (attributes.isEdit and StructKeyExists(attributes.staff, "vadesignation")) ? attributes.staff.vadesignation : "">

<script>
var request=new Object();

request.apppath="/";
request.approot="/";

sysdt=new Date();
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
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
    <form id="staffForm" name="staffForm" action="index.cfm?fusebox=admin&fuseaction=act_upsertstaff&iUSID=#attributes.iUSID#" method="post" autocomplete="off">
      
        <div class="mb-3">
            <label for="username" class="form-label">Username</label>
            <input id="username" name="username" type="text" class="form-control" Onblur="DoReq(this)" CHKREQUIRED CHKNAME="Username"
                value="#vausid#">
        </div>

        <div class="mb-3">
            <label for="fullname" class="form-label">Full Name</label>
            <input id="fullname" name="fullname" type="text" class="form-control" CHKREQUIRED CHKNAME="Full Name"
                value="#vausname#">
        </div>

        <div class="mb-3">
            <label for="email" class="form-label">Email</label>
            <input id="email" name="email" type="text" class="form-control" CHKREQUIRED CHKNAME="Email"
                CHKREFORMAT="^[\w\-\.]+@([\w-]+\.)+[\w-]{2,4}$"
                CHKRESAMPLE="Valid email format: example@domain.com"
                value="#vaemail#">
        </div>

        <div class="mb-3">
            <label for="department" class="form-label">Department</label>            
            <select id="department" name="department" class="form-select" CHKREQUIRED CHKNAME="Department">
                <option value="">-- Select Department --</option>
                <cfloop array="#['Claims','E-Policy','IT','Integration','RnD']#" index="p">
                    <option value="#p#" <cfif attributes.isEdit AND StructKeyExists(attributes.staff, "vadepartment") and attributes.staff.vadepartment eq p>selected</cfif>>#p#</option>
                </cfloop>
            </select>
        </div>

        <div class="mb-3">
            <label for="role" class="form-label">Role</label>            
            <select id="designation" name="designation" class="form-select" CHKREQUIRED CHKNAME="Role">
                <option value="">-- Select Role --</option>
                <cfloop array="#['Staff','IT','Admin']#" index="p">
                    <option value="#p#" <cfif attributes.isEdit AND StructKeyExists(attributes.staff, "vadepartment") and attributes.staff.vadesignation eq p>selected</cfif>>#p#</option>
                </cfloop>
            </select>
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
