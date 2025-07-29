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
	<cffunction name="act_deletestaff" hint="">
		<CFMODULE template="act_deletestaff.cfm" AttributeCollection=#Arguments#>
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
	<cffunction name="dsp_return" hint="">
		<CFMODULE template="assign/dsp_return.cfm" AttributeCollection=#Arguments#>
		<CFRETURN>
	</cffunction>
	<cffunction name="dsp_listassign" hint="">
		<CFMODULE template="assign/dsp_listassign.cfm" AttributeCollection=#Arguments#>
		<CFRETURN>
	</cffunction>
	<cffunction name="act_assign" hint="">
		<CFMODULE template="assign/act_assign.cfm" AttributeCollection=#Arguments#>
		<CFRETURN>
	</cffunction>
	<cffunction name="dsp_itemhistory" hint="">
		<CFMODULE template="assign/dsp_itemhistory.cfm" AttributeCollection=#Arguments#>
		<CFRETURN>
	</cffunction>
	<cffunction name="dsp_getfile" hint="" returntype="any" output="true">
			<cfargument name="DOCID" required="true" type="numeric"
					displayname="Document ID"
					hint="Unique identifier for each document. <FDOC3003.iDOCID>">
			<cfargument name="PARENTSEC_DOCID" required="false" default="0" type="numeric"
					displayname="Document ID of parent document to use for security checking. This is for those HTM who embeds <!--IMGTAGxx--> where each imgtag as a DOCID takes the security context of the parent HTM."
					hint="The parent document ID must be a HTM or HTML, bit 64 of iDOCSTAT must be set, and must contain the IMGTAG to allow the sub-doc to access.">
			<cfargument name="FTYPE" required="false" default="0" type="numeric"
					displayname="File Type"
					hint="(1:Thumbnails; 4:View as HTM with print options; 5:View draft as HTM with print options)">
			<cfargument name="COROLE" required="false" default="0" type="numeric"
					displayname="Company Role"
					hint="Company Role based on Domain ID <FOBJ3003.iCOROLEID>">
			<cfargument name="NOPRINTOPTIONS" required="false" default="0" type="numeric"
					displayname="No Print Options Flag"
					hint="0:Display printing options; 1:Do not display printing options">
			<cfargument name="PDFSAVEDOC" required="false" default="0" type="numeric"
					displayname="Save As PDF"
					hint="(0:No; 1:Yes) Specifies whether to display the options to save as PDF">
			<cfargument name="PRINTCTRLTYPE" required="false" default="0" type="numeric"
					displayname="Print Control Type"
					hint="0:No Print Control; 1:Original; 2:Duplicate; 3:Copy; 4:Triplicate; 6:Non-Negotiable">
			<cfargument name="FROMCTXMENU" required="false" default="0" type="numeric"
					displayname="From Context Menu Flag"
					hint="(0:No; 1:Yes) Specifies that this page is called from context menu.">
			<cfargument name="BYPASSSEC" required="false" default="0" type="numeric"
					displayname="if call outside of session, set to 1 to bypass security checking. Will be check using SVCRequestIpChk()"
					hint="(0:No; 1:Yes)">
			<CFINCLUDE template="assign/dsp_getfile.cfm">
			<CFRETURN>
	</cffunction>


	<!--- REPORT --->
	<cffunction name="dsp_rptItem" hint="">
		<CFMODULE template="ReportQuery/dsp_rptItem.cfm" AttributeCollection=#Arguments#>
		<CFRETURN>
	</cffunction>
	<cffunction name="dsp_rptAsgmt" hint="">
		<CFMODULE template="ReportQuery/dsp_rptAsgmt.cfm" AttributeCollection=#Arguments#>
		<CFRETURN>
	</cffunction>
	
</cfcomponent>


