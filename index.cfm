<cfparam name="fusebox" default="">
<cfparam name="fuseaction" default="">

<cfparam NAME="attributes.FUSEBOX" DEFAULT="">
<cfparam NAME="attributes.FUSEACTION" DEFAULT="">


<cfif NOT ListFindNoCase("dsp_login,act_login,act_logout,dsp_forgotpass,dsp_custregister", fuseaction)>
	<cftry>
		<cfset Request.DS.FN.SVCsessionChk()>
	<cfcatch type="any">
		<!--- Redirect to login if session check fails --->
		<cflocation url="index.cfm?fuseaction=dsp_login" addtoken="no">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>


<CFIF IsDefined("session.vars") AND StructKeyExists(session.vars,"LOGIN2FA") AND SESSION.VARS.LOGIN2FA IS 0 >
	<CFMODULE TEMPLATE="#request.apppath#services/CustomTags\SVCchkgrp.cfm" GrpList="6013W"><!---42704--->
	<cfif NOT(IsDefined("Request.FROMINTERGRATION") AND Request.FROMINTERGRATION EQ 1)
		AND NOT((StructKeyExists(session.vars,"LOGINTYPE") AND listFindNoCase("1,2",SESSION.VARS.LOGINTYPE) GT 0) <!--- exclude: integration & web service --->
		OR ListFind("SVCTwoFA,SVCQR,SVCsec,MICAdmin,SVCadmin",attributes.FUSEBOX) GT 0) AND CANREAD EQ 0><!---42704--->
			<cfset REQUEST.DS.FN.SVCChk2FA(1,1)>
			<cfexit method = "exitTemplate">
	</cfif>
</CFIF>

<CFIF structKeyExists(request,"inSession") AND request.inSession IS 1 AND StructKeyExists(SESSION.VARS,"ORGTYPE") AND SESSION.VARS.ORGTYPE IS "D" AND Left(Attributes.FUSEACTION,4) IS "act_" AND NOT(Attributes.FUSEACTION IS "act_logout" OR Attributes.FUSEACTION IS "act_setlogin" OR Attributes.FUSEACTION IS "act_2FAvalidation")>
    <cfmodule TEMPLATE="#request.apppath#services/CustomTags\SVCchkgrp.cfm" GrpList="740W">
    <CFIF CanWrite IS 1>
        <CFTHROW TYPE="EX_SECFAILED" ErrorCode="CANNOTWRITE" ExtendedInfo="You are denied from making any changes to the system.">
    </CFIF>
</CFIF>

<cfswitch expression="#fusebox#">
    <cfcase value="admin">
        <cfinclude template="admin/index.cfm">
    </cfcase>
    <cfcase value="MTRsec">
        <cfinclude template="sec/index.cfm">
    </cfcase>
    
    <cfdefaultcase>
			<cfif Len(Attributes.FUSEBOX) GT 3 AND Left(attributes.FUSEBOX,3) IS "SVC">
				<cfinclude TEMPLATE="#request.apppath#services/index.cfm">
			<cfelse>
        <cfinvoke component="ims.index" method="dsp_login">
			</cfif>
    </cfdefaultcase>
</cfswitch>

