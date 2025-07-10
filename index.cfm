<cfparam NAME="attributes.FUSEBOX" DEFAULT="">
<cfparam NAME="attributes.FUSEACTION" DEFAULT="">

<cfif request.inSession IS 0 AND attributes.FUSEACTION eq ""
		AND ListFind("7,15,17,11",Application.APPLOCID)>
	<cfset Request.DS.FN.SVClangSet("",5)><!--- Similar settings in \CustomTags\settoken.cfm and \index.cfm --->
</cfif>

<cfif isDefined("Attributes.UID") AND NOT StructKeyExists(SESSION,"SSO_UID") AND Attributes.FUSEACTION NEQ "act_login">
	<!--- Check if needed to recreate session, else show timeout error --->
	<cfmodule template="#Request.SSOPATH#?FUSEBOX=MRMRoot&ENVIRONMENT=1&MODE=2&#REQUEST.MTOKEN#">
</cfif>

<CFIF IsDefined("session.vars") AND StructKeyExists(session.vars,"BLOCKLOGIN") AND SESSION.VARS.BLOCKLOGIN IS 1>
	<cfif NOT((attributes.FUSEBOX IS "SVCbill" AND ListFind("dsp_viewinvoice,dsp_uploadPaySlip,act_uploadPaySlip",attributes.FUSEACTION) GT 0) 
				OR (attributes.FUSEBOX IS "SVCdoc" AND ListFind("dsp_viewersmart,dsp_getfile,ACT_DOCEDIT",attributes.FUSEACTION) GT 0))>
		<cfset REQUEST.DS.FN.SVCBlckLogin(1,1)>
		<cfexit method = "exitTemplate">
	</cfif>
</CFIF>

<CFIF IsDefined("session.vars") AND StructKeyExists(session.vars,"LOGIN2FA") AND SESSION.VARS.LOGIN2FA IS 0>
	<cfif NOT(IsDefined("Request.FROMINTERGRATION") AND Request.FROMINTERGRATION EQ 1)
		AND NOT((attributes.FUSEBOX IS "MTRsec" AND ListFind("act_login,act_logout",attributes.FUSEACTION) GT 0)
		OR (attributes.FUSEBOX IS "MTRroot" AND ListFind("dsp_subscriberhelp",attributes.FUSEACTION) GT 0)
		OR (StructKeyExists(session.vars,"LOGINTYPE") AND listFindNoCase("1,2",SESSION.VARS.LOGINTYPE) GT 0)
		OR (attributes.FUSEBOX IS "MTRadmin" AND ListFind("dsp_csbar",attributes.FUSEACTION) GT 0)
		OR ListFind("SVCTwoFA,SVCQR,SVCsec",attributes.FUSEBOX) GT 0)>
			<cfset REQUEST.DS.FN.SVCChk2FA(1,1)>
			<cfexit method = "exitTemplate">
	</cfif>
</CFIF>

<CFIF StructKeyExists(SESSION,"VARS") AND StructKeyExists(session.vars,"gcoid") AND Session.VARS.GCOID IS 61>
	<cfset READ_ONLY = false>
	<cfset PENDINGKFKAPI = false>

	<CFIF IsDefined("Attributes")>
		<CFIF StructKeyExists(Attributes,"CASEID") AND StructKeyExists(Attributes,"FuseAction") AND LEFT(Attributes.FuseAction,4) IS "act_">
			<!--- General Save --->
			<cfmodule TEMPLATE="#Request.LOGPATH#CustomTags\chklabel.cfm" CASEID=#Attributes.CASEID#>
			<CFIF LISTFIND(CASELABEL,700170300)>
				<cfset READ_ONLY = true>
			</CFIF>
		<CFELSEIF StructKeyExists(Attributes,"FuseBox") AND Attributes.FuseBox IS "SVCtask" AND StructKeyExists(Attributes,"FuseAction") AND Attributes.FuseAction IS "dsp_viewtask" AND StructKeyExists(Attributes,"assocobj") AND StructKeyExists(Attributes,"assocdomain") AND Attributes.assocdomain IS 1>
			<!--- create task --->
			<cfmodule TEMPLATE="#Request.LOGPATH#CustomTags\chklabel.cfm" CASEID=#Attributes.assocobj#>
			<CFIF LISTFIND(CASELABEL,700170300)>
				<cfset READ_ONLY = true>
			</CFIF>
		<CFELSEIF StructKeyExists(Attributes,"FuseBox") AND Attributes.FuseBox IS "SVCdoc" AND StructKeyExists(Attributes,"FuseAction") AND ListFindNoCase("dsp_docupload,act_docupload,dsp_docltrlist,dsp_docsec,dsp_docinfo",Attributes.FuseAction) AND StructKeyExists(Attributes,"objid") AND StructKeyExists(Attributes,"domainid") AND Attributes.domainid IS 1>
			<!--- docs section --->
			<cfmodule TEMPLATE="#Request.LOGPATH#CustomTags\chklabel.cfm" CASEID=#Attributes.objid#>
			<CFIF LISTFIND(CASELABEL,700170300)>
				<cfset READ_ONLY = true>
			</CFIF>
		</CFIF>

		<!--- BEGIN Block on KFK Related module and affecting action toward KFK --->
		<CFIF StructKeyExists(Attributes,"FuseBox") AND Attributes.FuseBox IS "MTRtp" AND StructKeyExists(Attributes,"FuseAction") AND LEFT(Attributes.FuseAction,4) IS "act_" AND StructKeyExists(Attributes,"caseid") AND Attributes.caseid GT 0>
			<!--- KFK Related Module --->
			<cfmodule TEMPLATE="#Request.LOGPATH#CustomTags\chklabel.cfm" CASEID=#Attributes.caseid#>
			<CFIF LISTFIND(CASELABEL,700171330)>
				<cfset PENDINGKFKAPI = true>
			</CFIF>
		<CFELSEIF StructKeyExists(Attributes,"FuseBox") AND Attributes.FuseBox IS "MTRinsurer" AND StructKeyExists(Attributes,"FuseAction") AND LISTFINDNOCASE('act_inssubcase',Attributes.FuseAction) GT 0 AND StructKeyExists(Attributes,"caseid") AND Attributes.caseid GT 0>
			<!--- Cherry Pick action --->
			<cfmodule TEMPLATE="#Request.LOGPATH#CustomTags\chklabel.cfm" CASEID=#Attributes.caseid#>
			<CFIF LISTFIND(CASELABEL,700171330)>
				<cfset PENDINGKFKAPI = true>
			</CFIF>
		</CFIF>
		<!--- END Block on KFK Related module and affecting action toward KFK --->
	</CFIF>
	<CFIF READ_ONLY>
		<CFSET AMGMIG_BLOCK_START = Request.DS.FN.SVCgetExtAttrLogic("COPARAM",61,"AMGEN-MIG-BLOCK-START",10,61)>
		<CFSET AMGMIG_BLOCK_END = Request.DS.FN.SVCgetExtAttrLogic("COPARAM",61,"AMGEN-MIG-BLOCK-END",10,61)>

		<cfif AMGMIG_BLOCK_START neq "" AND AMGMIG_BLOCK_END neq "">
			<cfset AMGMIG_BLOCK_START = parseDateTime(AMGMIG_BLOCK_START,"dd/MM/yyyy")>
			<cfset AMGMIG_BLOCK_END = parseDateTime(AMGMIG_BLOCK_END,"dd/MM/yyyy")>
			<CFSET DTNOW = parseDateTime(Now(),"dd/MM/yyyy")>
			<cfif AMGMIG_BLOCK_START neq "" AND AMGMIG_BLOCK_END neq "" AND AMGMIG_BLOCK_START LT DTNOW AND DTNOW LT AMGMIG_BLOCK_END>
				<cfthrow TYPE="EX_SECFAILED" ErrorCode="BADCASE" EXTENDEDINFO="Migrated Case Locked">
			</cfif>
		</cfif>	
	</CFIF>

	<CFIF PENDINGKFKAPI>
		<cfthrow TYPE="EX_SECFAILED" ErrorCode="BADCASE" EXTENDEDINFO="Case pending response to get update from MRC API. Please proceed after MRC API successfully update toward this case.">
	</CFIF>
</CFIF>

<CFIF request.inSession IS 1 AND SESSION.VARS.ORGTYPE IS "D" AND Left(Attributes.FUSEACTION,4) IS "act_" AND NOT(Attributes.FUSEACTION IS "act_logout" OR Attributes.FUSEACTION IS "act_setlogin" OR Attributes.FUSEACTION IS "act_2FAvalidation")>
	<cfmodule TEMPLATE="#request.apppath#services/CustomTags\SVCchkgrp.cfm" GrpList="740W">
	<CFIF CanWrite IS 1>
		<CFTHROW TYPE="EX_SECFAILED" ErrorCode="CANNOTWRITE" ExtendedInfo="You are denied from making any changes to the system.">
	</CFIF>
</CFIF>

<!--- GLOBAL CHECK --->
<!--- <cfif Len(attributes.FUSEACTION) GT 0 AND ListFindNoCase("dsp_home", attributes.fuseaction)>
  <cftry>
    <CFSET Request.DS.FN.SVCsessionChk()>
    <cfcatch type="any">
      <cfset structClear(session)>
      <cflocation url="index.cfm" addtoken="no">
    </cfcatch>
  </cftry>
</cfif> --->


<cfswitch expression="#attributes.fusebox#">
    <cfcase value="admin">
        <cfinclude template="admin/index.cfm">
    </cfcase>
    <cfcase value="MTRsec">
        <cfinclude template="sec/index.cfm">
    </cfcase>
		<cfcase value="MTRroot">
			<cfparam NAME="attributes.FUSEACTION" DEFAULT="">
				<cfswitch EXPRESSION=#attributes.fuseaction#>
					<CFCASE VALUE="dsp_home">
						<CFMODULE TEMPLATE="header.cfm">
						<cfinvoke component="ims.index" method="dsp_home">
						<CFMODULE TEMPLATE="footer.cfm">
					</CFCASE>
					<cfdefaultcase>
						<cfif Application.APPLOCID IS 5>
							<cfinvoke component="ims.index" method="dsp_login" ArgumentCollection=#Attributes#>
							<!---cfinclude TEMPLATE="dsp_login__motobiz.cfm"--->
						<cfelse>
							<cfinvoke component="ims.index" method="dsp_login" ArgumentCollection=#Attributes#>
						</cfif>
					</cfdefaultcase>
				</cfswitch>
		
			

    </cfcase>
    
    <cfdefaultcase>
			<cfif Len(Attributes.FUSEBOX) GT 3 AND Left(attributes.FUSEBOX,3) IS "SVC">
				<cfinclude TEMPLATE="#request.apppath#services/index.cfm">
			<cfelse>
        <cfinvoke component="ims.index" method="dsp_login" ArgumentCollection=#Attributes#>
			</cfif>
    </cfdefaultcase>
</cfswitch>



