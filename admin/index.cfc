<cfcomponent displayname="admin" hint="Admin Page">
	<cffunction name="dsp_addrecord" hint="">
		<CFMODULE template="dsp_addrecord.cfm" >
		<CFRETURN>
	</cffunction>
	<cffunction name="dsp_home" hint="">
		<CFMODULE template="dsp_home.cfm" AttributeCollection=#Arguments#>
		<CFRETURN>
	</cffunction>
	<cffunction name="act_deleterecord" hint="">
		<CFMODULE template="act_deleterecord.cfm"  >
		<CFRETURN>
	</cffunction>
	<cffunction name="dsp_details" hint="">
		<CFMODULE template="dsp_details.cfm" >
		<CFRETURN>
	</cffunction>
	<cffunction name="dsp_form" hint="">
		<CFMODULE template="dsp_form.cfm" >
		<CFRETURN>
	</cffunction>
	<cffunction name="act_upsertrecord" hint="">
		<CFMODULE template="act_upsertrecord.cfm" >
		<CFRETURN>
	</cffunction>
	<cffunction name="dsp_upsertstaff" hint="">
		<CFMODULE template="dsp_upsertstaff.cfm" AttributeCollection=#Arguments#>
		<CFRETURN>
	</cffunction>
	<cffunction name="act_upsertstaff" hint="">
		<CFMODULE template="act_upsertstaff.cfm" AttributeCollection=#Arguments#>
		<CFRETURN>
	</cffunction>

	<cffunction name="dsp_stafflist" hint="">
		<CFMODULE template="dsp_stafflist.cfm" AttributeCollection=#Arguments#>
		<CFRETURN>
	</cffunction>
	<cffunction name="act_userprofile" hint="">
		<CFMODULE template="act_userprofile.cfm" AttributeCollection=#Arguments#>
		<CFRETURN>
	</cffunction>
	
</cfcomponent>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<!--- this style needed for nav --->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
