<!--- <cfdump var="#application#"> --->
<cfswitch expression="#fuseaction#">
    <cfcase value=act_login>
        <cfinvoke component="ims.sec.index" method="act_login" >
    </cfcase>
    <cfcase value=act_logout>
        <cfinvoke component="ims.sec.index" method="act_logout" >
    </cfcase>
</cfswitch>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<!--- this style needed for nav --->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="/assets/override.css?v=20250708">