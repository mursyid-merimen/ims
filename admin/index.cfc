<cfcomponent displayname="admin" hint="Admin Page">
	<cffunction name="dsp_addrecord" hint="">
		<CFMODULE template="dsp_addrecord.cfm" >
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

	<!--- TYPE --->
	<cffunction name="dsp_listtype" hint="">
		<CFMODULE template="itemtypes/dsp_listtype.cfm" AttributeCollection=#Arguments#>
		<CFRETURN>
	</cffunction>
	<cffunction name="dsp_formtype" hint="">
		<CFMODULE template="itemtypes/dsp_formtype.cfm" AttributeCollection=#Arguments#>
		<CFRETURN>
	</cffunction>
	<cffunction name="act_type" hint="">
		<CFMODULE template="itemtypes/act_type.cfm" AttributeCollection=#Arguments#>
		<CFRETURN>
	</cffunction>
	

	<!--- ITEM --->
	<cffunction name="dsp_listitem" hint="">
		<CFMODULE template="item/dsp_listitem.cfm" AttributeCollection=#Arguments#>
		<CFRETURN>
	</cffunction>
	<cffunction name="dsp_formitem" hint="">
		<CFMODULE template="item/dsp_formitem.cfm" AttributeCollection=#Arguments#>
		<CFRETURN>
	</cffunction>
	<cffunction name="act_item" hint="">
		<CFMODULE template="item/act_item.cfm" AttributeCollection=#Arguments#>
		<CFRETURN>
	</cffunction>
	

	<!--- THRESHOLD --->
	<cffunction name="dsp_listthresh" hint="">
		<CFMODULE template="threshold/dsp_listthresh.cfm" AttributeCollection=#Arguments#>
		<CFRETURN>
	</cffunction>
	<cffunction name="dsp_formthresh" hint="">
		<CFMODULE template="threshold/dsp_formthresh.cfm" AttributeCollection=#Arguments#>
		<CFRETURN>
	</cffunction>
	<cffunction name="act_editthresh" hint="">
		<CFMODULE template="threshold/act_editthresh.cfm" AttributeCollection=#Arguments#>
		<CFRETURN>
	</cffunction>

	<!--- ASSIGN --->
	<cffunction name="dsp_assign" hint="">
		<CFMODULE template="assign/dsp_assign.cfm" AttributeCollection=#Arguments#>
		<CFRETURN>
	</cffunction>
	<cffunction name="dsp_listassign" hint="">
		<CFMODULE template="assign/dsp_listassign.cfm" AttributeCollection=#Arguments#>
		<CFRETURN>
	</cffunction>
</cfcomponent>


