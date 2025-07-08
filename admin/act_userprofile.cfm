<cfmodule TEMPLATE="#request.apppath#services/CustomTags\SVCDISABLEDIRECT.cfm" Path="#GetCurrentTemplatePath()#">
<!--- Attributes:MODE,COID,FROMCOID --->
<cfmodule TEMPLATE="#request.apppath#services/CustomTags\SVCchkguid.cfm" REQUIRED>
<cfset Form.USERID = Trim(Form.USERID)>
<cfparam NAME=Attributes.MODE DEFAULT=0>
<cfparam NAME=FORM.PERCHK DEFAULT="">
<cfparam NAME=FORM.DEFPLIST DEFAULT="">
<cfparam NAME=FORM.CLMTYPEACCLIST DEFAULT="">
<cfparam NAME=FORM.VASIGLOGO default="">
<cfparam name="GETFILENAME" default="">
<cfif Not IsDefined("SESSION.VARS.USERID")>
	<cfthrow TYPE="EX_SECFAILED" ErrorCode="NOLOGIN">
</cfif>
<cfset CLMTYPEACCLIST=0>
<cfif FORM.CLMTYPEACCLIST IS NOT "">
	<cfloop LIST=#FORM.CLMTYPEACCLIST# INDEX=X>
		<cfif IsNumeric(X)>
			<cfset CLMTYPEACCLIST=CLMTYPEACCLIST+X>
		</cfif>
	</cfloop>
</cfif>

<!--- ZH #31234 --->
<CFSET RESVCLMMASK=0>
<CFIF isDefined("FORM.RESVCLMMASK") AND FORM.RESVCLMMASK IS NOT "">
	<CFSET RESVCLMMASK=arraySum(listToArray(FORM.RESVCLMMASK))>
</CFIF>

<cfif Form.VASIGLOGO NEQ "">
<cfmodule template="#Request.LOGPATH#admin/act_userprofile_signature.cfm" COID="#Attributes.COID#" USERID="#SESSION.VARS.USERID#" FORM="#FORM#" GETFILENAME="GETFILENAME">
</cfif>
<!--- begin : validation checking --->
<cfset mode=#attributes.mode#>

<cfif mode IS 1><!--- edit mode --->
	<cfquery name=q_co datasource=#Request.MTRDSN#>
	SELECT b.iCOID,b.iGCOID,b.siCOTYPEID,a.iUSID,b.iPWDSTRENGTHMASK,a.siPWDSENSITIVE,hqPwsStrMask=c.iPWDSTRENGTHMASK
	FROM SEC0001 a,SEC0005 b
	INNER JOIN SEC0005 c WITH (NOLOCK) ON b.iGCOID=c.iCOID
	WHERE a.vaUSID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.USERID#"> AND a.iCOID=b.iCOID
	</cfquery>

	<cfif q_co.recordcount IS NOT 1><cfthrow TYPE="EX_SECFAILED" ErrorCode="BADCO"></cfif>
	<cfset USER_ICOID=#q_co.icoid#>
	<cfset USER_IGCOID=#q_co.igcoid#>
	<cfset USER_COTYPEID=#q_co.siCOTYPEID#>
	<cfset li_coid = q_co.iCOID>
	<cfset gcoid = q_co.iGCOID>
	<cfset cotypeid=q_co.siCOTYPEID>
	<cfset USID=q_co.iUSID><!--- Mike --->
	<CFSET PWDMASK = q_co.iPWDSTRENGTHMASK>
	<CFSET PWDCASES = q_co.siPWDSENSITIVE>
	<CFSET HQPWDMASK = q_co.hqPwsStrMask>
<cfelse><!--- new mode --->
	<cfif NOT (IsDefined("Attributes.COID") AND attributes.coid GT 0)><cfthrow TYPE="EX_SECFAILED" ErrorCode="BADPARAM"></cfif>
	<!--- cst(50): ACE Jerneh, default SSO User ID as User ID if it's blank --->
	<cfif Isdefined("attributes.FROMCOID") AND attributes.FROMCOID IS 50 AND attributes.coid GT 0 AND Isdefined("FORM.FSSO_usid1") AND FORM.FSSO_usid1 IS "">
		<cfset FORM.FSSO_usid1=#UCASE(Form.USERID)#>
	</cfif>
	<!--- <cfmodule TEMPLATE="#Request.LOGPATH#CustomTags\CHKCASE.cfm" ChkCoID=1 COID="#Attributes.COID#"> --->
	<cfquery name=q_co datasource=#Request.MTRDSN#>
	SELECT b.iCOID,b.iGCOID,b.siCOTYPEID,b.iPWDSTRENGTHMASK,hqPwsStrMask=c.iPWDSTRENGTHMASK
	FROM SEC0005 b
	INNER JOIN SEC0005 c WITH (NOLOCK) ON B.iGCOID=c.iCOID
	WHERE b.iCOID=<cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.COID#">
	</cfquery>

	<cfif q_co.recordcount IS NOT 1><cfthrow TYPE="EX_SECFAILED" ErrorCode="BADCO"></cfif>
	<cfset USER_ICOID=#attributes.coid#>
	<cfset USER_IGCOID=#q_co.igcoid#>
	<cfset USER_COTYPEID=#q_co.siCOTYPEID#>
	<cfset li_coid = q_co.iCOID>
	<cfset gcoid = q_co.iGCOID>
	<cfset cotypeid=q_co.siCOTYPEID>
	<cfset USID=0><!--- Mike --->
	<CFSET PWDMASK = q_co.iPWDSTRENGTHMASK>
	<CFSET HQPWDMASK = q_co.hqPwsStrMask>
</cfif>

<!--- <cfoutput>
user:
USER_ICOID:<cfdump var="#USER_ICOID#"><br>
USER_IGCOID:<cfdump var="#USER_IGCOID#"><br>
USER_COTYPEID:<cfdump var="#USER_COTYPEID#"><br>
</cfoutput> --->

<cfif Isdefined("attributes.FROMCOID") AND attributes.FROMCOID GT 0>
	<!--- created from FROMCOID --->
	<cfquery name="q_fromcoid" datasource=#Request.MTRDSN#>
	SELECT sicotypeid, igcoid FROM SEC0005 with (nolock) WHERE icoid=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.fromcoid#">
	</cfquery>
	<cfset FROM_ICOID=#attributes.fromcoid#>
	<cfset FROM_IGCOID=#q_fromcoid.igcoid#>
	<cfset FROM_COTYPEID=#q_fromcoid.sicotypeid#>
<cfelse>
	<cfif SESSION.VARS.ORGTYPE IS "D">
		<cfset FROM_ICOID=#USER_ICOID#>
		<cfset FROM_IGCOID=#USER_IGCOID#>
		<cfset FROM_COTYPEID=#USER_COTYPEID#>
	<cfelse>
		<cfset FROM_ICOID=#session.vars.orgid#>
		<cfset FROM_IGCOID=#session.vars.gcoid#>
		<cfset FROM_COTYPEID=#session.vars.cotypeid#>
	</cfif>
</cfif>

<!--- <cfoutput>
<br>
from:
FROM_ICOID:<cfdump var="#FROM_ICOID#"><br>
FROM_IGCOID:<cfdump var="#FROM_IGCOID#"><br>
FROM_COTYPEID:<cfdump var="#FROM_COTYPEID#"><br>
</cfoutput> --->

<cfif USER_IGCOID IS FROM_IGCOID><!--- user from the same gco branch --->
	<cfmodule TEMPLATE="#Request.LOGPATH#CustomTags\CHKCASE.cfm" ChkCoID=1 COID="#USER_ICOID#">
<cfelse><!--- from different cotype? --->
	<cfif FROM_COTYPEID IS 2 AND USER_COTYPEID IS 6><!--- insurer creating/modify agent/broker user ID --->
		<cfquery name="q_colink" datasource=#Request.MTRDSN#>
		SELECT ilinkcoid FROM fsec0035 with (nolock)
		WHERE iowncoid=<cfqueryparam cfsqltype="cf_sql_integer" value="#FROM_ICOID#"> AND ilinkcoid=<cfqueryparam cfsqltype="cf_sql_integer" value="#USER_ICOID#"> AND sicotypeid=<cfqueryparam cfsqltype="CF_SQL_SMALLINT" value="#USER_COTYPEID#"> and sistatus=0
		</cfquery>
		<cfif NOT(q_colink.recordcount GTE 1)><cfthrow TYPE="EX_SECFAILED" ErrorCode="BADCO"></cfif>
		<cfmodule TEMPLATE="#Request.LOGPATH#CustomTags\CHKCASE.cfm" ChkCoID=1 COID="#FROM_ICOID#">
		<cfmodule TEMPLATE="#request.apppath#services/CustomTags\SVCchkgrp.cfm" GRPLIST="67W" CHKWRITE><!--- administration on agent/broker registration --->
		<CFSET AttrVal=Request.DS.FN.SVCgetExtAttrLogic("COADMIN",0,"COATTR124",10,request.ds.co[FROM_ICOID].gcoid)>
		<CFIF NOT(isNumeric(AttrVal) AND BITAND(AttrVal,1) IS 1)><cfthrow TYPE="EX_SECFAILED" ErrorCode="BADPARAM"><!--- can't create user because module has been deactivated ---></cfif>
	<cfelse>
		<cfthrow TYPE="EX_SECFAILED" ErrorCode="BADPARAM"><!--- any other module that using attributes.FROMCOID? has no ideal where it comes from ... --->
	</cfif>
</cfif>

<cfif ORGTYPE IS "D">
	<cfmodule TEMPLATE="#request.apppath#services/CustomTags\SVCchkgrp.cfm" GRPLIST="21W" CHKWRITE>
	<CFIF BITAND(HQPWDMASK,2048)><!--- Merimen staff cannot perform admin on users: unless have 306 permission --->
	   <CFMODULE TEMPLATE="#request.apppath#services/CustomTags\SVCchkgrp.cfm" GrpList="306W" CHKWRITE>
	</CFIF>
</cfif>
<!--- end : validation checking --->

<!---REMARKS: Special 3 char check for MSIG Thai--->
<cfif GCOID eq 1100001>
	<cfset userminchar=3>
<cfelse>
	<cfset userminchar=5>
</cfif>

<cfset CURPER=ArrayToList(SESSION.VARS.PLIST)>
<cfset CURUSERID=SESSION.VARS.USERID>
<!--- <cfparam NAME=Attributes.FROMCOID DEFAULT=#li_coid#> --->
<cfif len(FORM.UserID) lt userminchar>
	<cfthrow TYPE="EX_SECFAILED" ErrorCode="BADUSRPWDLENGTH">
</cfif>
<!---
<cfif len(FORM.RSAPWD) IS NOT 0 AND len(FORM.RSAPWD) IS NOT 32>
	<cfthrow TYPE="EX_SECFAILED" ErrorCode="BADUSRPWDLENGTH">
</cfif>
--->
<cfif IsDefined("FORM.APPLIMIT")>
	<cfset Form.APPLIMIT=Request.DS.FN.SVCNumLocToDB(Form.APPLIMIT)>
	<cfif Form.AppLIMIT LT 0 AND Form.AppLimit IS NOT -1>
		<cfset Form.APPLIMIT = 0>
	</cfif>
<cfelse>
	<cfset Form.APPLIMIT = "NULL">
</cfif>
<cfset FORM.USERID=UCASE(REPLACE(FORM.USERID,' ','','ALL'))>
<CFPARAM NAME=FORM.USRCODE DEFAULT="~~NODATA~~">
<cfset FORM.USRCODE=Trim(FORM.USRCODE)>
<!---cfset FORM.USRCODE=UCASE(REPLACE(FORM.USRCODE,' ','','ALL'))--->
<cfif FORM.USRCODE IS NOT "~~NODATA~~">
	<!--- Check if USRCODE is repeated for group --->
	<cfif Len(Form.USRCODE) GT 0>
		<cfquery name=q_co datasource=#Request.MTRDSN#>
		SELECT a.iCOID,b.vaCOBRNAME,a.vaUSID FROM SEC0001 a WITH (NOLOCK),SEC0005 b WITH (NOLOCK)
		WHERE b.iGCOID=<cfqueryparam cfsqltype="cf_sql_integer" value="#GCOID#"> AND b.iCOID=a.iCOID AND a.vaUSRCODE=<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.USRCODE#"> AND a.vaUSID!=<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.USERID#">
		</cfquery>
		<cfif q_co.recordcount GT 0>
			<cfthrow TYPE="EX_SECFAILED" ERRORCODE="CODEEXIST" EXTENDEDINFO="#q_co.iCOID#:#q_co.vaCOBRNAME#-#q_co.vaUSID#/#FORM.USRCODE#">
		</cfif>
	</cfif>
</cfif>
<CFPARAM NAME=FORM.USRCODE2 DEFAULT="~~NODATA~~">
<cfset FORM.USRCODE2=Trim(FORM.USRCODE2)>

<!---cfif Attributes.MODE IS 1>
	<!--- Update new user details --->
	<cfquery name="q_user" datasource=#Request.MTRDSN#>
	UPDATE SEC0001 SET siROLE=<cfqueryparam value="#FORM.ROLE#" cfsqltype="CF_SQL_NUMERIC">,vaUSNAME=<cfqueryparam value="#FORM.USNAME#" cfsqltype="CF_SQL_NVARCHAR">,
		<!---
		<cfif FORM.RSAPWD IS NOT "">aPWDHASH='#Trim(UCase(PWD))#',</cfif>
		--->
		<cfif IsDefined("FORM.STATUS")>siSTATUS=<cfqueryparam value="#FORM.STATUS#" cfsqltype="CF_SQL_NUMERIC">,</cfif>
		<cfif IsDefined("FORM.USRCODE")>vaUSRCODE=<cfqueryparam value="#FORM.USRCODE#" cfsqltype="CF_SQL_NVARCHAR">,</cfif>
		iCLMTYPEACCMASK=<cfqueryparam value="#CLMTYPEACCLIST#" cfsqltype="CF_SQL_INTEGER">,
		mnAPPLIMIT=<cfqueryparam value="#Form.APPLIMIT#" cfsqltype="CF_SQL_NUMERIC">,
		vaDESIGNATION=<cfqueryparam value="#Form.Designation#" cfsqltype="CF_SQL_NVARCHAR">, vaDEPT=<cfqueryparam value="#Form.Department#" cfsqltype="CF_SQL_NVARCHAR">, aTELNO=<cfqueryparam value="#Form.DIDNo#" cfsqltype="CF_SQL_NVARCHAR">,vaEMAIL=<cfqueryparam value="#Form.EMail#" cfsqltype="CF_SQL_NVARCHAR">,
		iCHILDCOACCESS=<cfqueryparam value="#Form.ICHILDCOACCESS#" cfsqltype="CF_SQL_INTEGER">,
		<CFIF IsDefined("FORM.CLRSUSPEND") AND UCase(FORM.CLRSUSPEND) IS "CLEAR">
		siSUSPENDED=0,siLOCKED=0,
		</CFIF>
		aMODBY=<cfqueryparam value="#curuserid#" cfsqltype="CF_SQL_NVARCHAR">,dtMODON=getdate()
		WHERE vaUSID = <cfqueryparam value="#FORM.USERID#" cfsqltype="CF_SQL_NVARCHAR">
	</cfquery>
<cfelse>
	<!--- Create new user --->
	<cfstoredproc PROCEDURE="sspSECCreateUser" DATASOURCE=#Request.MTRDSN# RETURNCODE=YES>
	<cfprocparam TYPE=IN CFSQLTYPE=CF_SQL_VARCHAR VALUE="#FORM.USERID#" DBVARNAME=@as_userid>
	<!---
	<cfprocparam TYPE=IN CFSQLTYPE=CF_SQL_VARCHAR VALUE="#TRIM(UCase(PWD))#" DBVARNAME=@as_pwdhash>
	--->
	<cfprocparam TYPE=IN CFSQLTYPE=CF_SQL_INTEGER VALUE=#li_coid# DBVARNAME=@ai_coid>
	<cfprocparam TYPE=IN CFSQLTYP=CF_SQL_VARCHAR VALUE="#FORM.USNAME#" DBVARNAME=@as_usrname>
	<cfprocparam TYPE=IN CFSQLTYPE=CF_SQL_VARCHAR VALUE="#FORM.Designation#" DBVARNAME=@as_designation>
	<cfprocparam TYPE=IN CFSQLTYPE=CF_SQL_VARCHAR VALUE="#FORM.Department#" DBVARNAME=@as_department>
	<cfprocparam TYPE=IN CFSQLTYPE=CF_SQL_VARCHAR VALUE="#FORM.DIDNo#" DBVARNAME=@as_phone>
	<cfprocparam TYPE=IN CFSQLTYPE=CF_SQL_VARCHAR VALUE="#FORM.Email#" DBVARNAME=@as_email>
	<cfprocparam TYPE=IN CFSQLTYPE=CF_SQL_VARCHAR VALUE="#SESSION.VARS.USERID#" DBVARNAME=@as_crtby>
	<cfif FORM.APPLIMIT IS "NULL">
		<cfprocparam TYPE=IN CFSQLTYPE=CF_SQL_MONEY NULL=YES VALUE="0" DBVARNAME=@amn_applimit>
	<cfelse>
		<cfprocparam TYPE=IN CFSQLTYPE=CF_SQL_MONEY VALUE="#FORM.APPLIMIT#" DBVARNAME=@amn_applimit>
	</cfif>
	<cfif COTYPEID IS 1>
		<cfset CLMTYPEACCLIST=1+2+4+8+32>
	</cfif>
	<cfprocparam TYPE=IN CFSQLTYPE=CF_SQL_INTEGER VALUE=#CLMTYPEACCLIST# DBVARNAME=@ai_clmtypeaccmask>
	<cfprocparam TYPE=IN CFSQLTYPE=CF_SQL_INTEGER VALUE=#FORM.ICHILDCOACCESS# DBVARNAME=@ICHILDCOACCESS>
	<cfif COTYPEID IS 2>
		<cfprocparam TYPE=IN CFSQLTYPE=CF_SQL_VARCHAR VALUE="#FORM.USRCODE#" DBVARNAME=@as_usrcode>
	</cfif>
	</cfstoredproc>
	<cfset returncode = CFSTOREDPROC.StatusCode>
	<cfif returncode IS -2>
		<cfthrow TYPE="EX_SECFAILED" ErrorCode="USREXIST">
	<cfelseif returncode LT 0>
		<cfthrow TYPE="EX_DBERROR" ErrorCode="ADMIN-CRTUSER(#returncode#)">
	</cfif>
	<cfquery name="q_user2" datasource=#Request.MTRDSN#>
	SELECT iUSID FROM SEC0001 WHERE vaUSID=<cfqueryparam value="#FORM.USERID#" cfsqltype="CF_SQL_NVARCHAR">
	</cfquery>
	<cfset USID=q_user2.iUSID><!--- Mike --->
</cfif>
<!--- Delete rights removed (if got permission) --->
<cfif FORM.DEFPLIST IS NOT "">
	<cfquery name="q_user" datasource=#Request.MTRDSN#>
	DELETE a FROM SEC0004 a,SEC0003 b WHERE
	a.iUSID=<cfqueryparam value="#USID#" cfsqltype="CF_SQL_INTEGER"> AND a.siPGROUP IN (<cfqueryparam value="#FORM.DEFPLIST#" cfsqltype="CF_SQL_NUMERIC" list="true">)
	AND a.siPGROUP=b.siPGROUP
	<cfif FORM.PERCHK IS NOT "">AND a.siPGROUP NOT IN (<cfqueryparam value="#FORM.PERCHK#" cfsqltype="CF_SQL_NUMERIC" list="true">)</cfif>
	<cfif CURPER IS "">AND IsNull(b.siPREQUIRED,0)=0
	<cfelse>AND IsNull(b.siPREQUIRED,0) IN (0,#CURPER#)
	</cfif>
	</cfquery>
</cfif>
<!--- Add new rights (if got permission) --->
<cfif FORM.PERCHK IS NOT "">
	<cfquery name="q_user" datasource=#Request.MTRDSN#>
	INSERT SEC0004 (siPGROUP,iUSID,aCRTBY)
		SELECT b.siPGROUP,#USID#,'#CURUSERID#'
		FROM SEC0003 b WHERE b.siPGROUP IN (<cfqueryparam value="#FORM.PERCHK#" cfsqltype="CF_SQL_NUMERIC" list="true">)
		<cfif FORM.DEFPLIST IS NOT "">AND b.siPGROUP NOT IN (<cfqueryparam value="#FORM.DEFPLIST#" cfsqltype="CF_SQL_NUMERIC" list="true">)</cfif>
		<cfif CURPER IS "">AND IsNull(b.siPREQUIRED,0)=0
		<cfelse>AND IsNull(b.siPREQUIRED,0) IN (0,#CURPER#)
		</cfif>
	</cfquery>
</cfif--->
<!--- Generated Using a LazyTool --->

<!--- <br>
usid : <cfdump var=#USID#> ... user ID : <cfdump var="#FORM.USERID#"><br>
<br> --->
<CFSTOREDPROC PROCEDURE="sspFSECUserProfile" DATASOURCE="#Request.MTRDSN#" RETURNCODE="YES">
	<CFPROCPARAM TYPE="IN" DBVARNAME=@ai_usid VALUE="#USID#" CFSQLTYPE="CF_SQL_INTEGER">
	<CFPROCPARAM TYPE="IN" DBVARNAME=@ai_byusid VALUE="#SESSION.VARS.USID#" CFSQLTYPE="CF_SQL_INTEGER">
	<CFIF IsDefined("FORM.ROLE") AND FORM.ROLE IS NOT "">
		<CFPROCPARAM TYPE="IN" DBVARNAME=@asi_role VALUE="#FORM.ROLE#" CFSQLTYPE="CF_SQL_SMALLINT">
	<CFELSE>
		<CFPROCPARAM TYPE="IN" DBVARNAME=@asi_role NULL="YES" CFSQLTYPE="CF_SQL_SMALLINT">
	</CFIF>
	<CFIF IsDefined("FORM.USRNM")>
		<CFPROCPARAM TYPE="IN" DBVARNAME=@as_usname VALUE="#FORM.USRNM#" CFSQLTYPE="CF_SQL_VARCHAR">
	<CFELSE>
		<CFPROCPARAM TYPE="IN" DBVARNAME=@as_usname NULL="YES" CFSQLTYPE="CF_SQL_VARCHAR">
	</CFIF>

	<!---CFIF IsDefined("FORM.USNAME")>
		<CFPROCPARAM TYPE="IN" DBVARNAME=@as_usname VALUE="#FORM.USNAME#" CFSQLTYPE="CF_SQL_VARCHAR">
	<CFELSE>
		<CFPROCPARAM TYPE="IN" DBVARNAME=@as_usname NULL="YES" CFSQLTYPE="CF_SQL_VARCHAR">
	</CFIF--->
	<CFIF IsDefined("FORM.STATUS") AND FORM.STATUS IS NOT "">
		<CFPROCPARAM TYPE="IN" DBVARNAME=@asi_status VALUE="#FORM.STATUS#" CFSQLTYPE="CF_SQL_SMALLINT">
	<CFELSE>
		<CFPROCPARAM TYPE="IN" DBVARNAME=@asi_status NULL="YES" CFSQLTYPE="CF_SQL_SMALLINT">
	</CFIF>
	<CFIF IsDefined("FORM.USRCODE") AND FORM.USRCODE IS NOT "~~NODATA~~">
		<CFPROCPARAM TYPE="IN" DBVARNAME=@as_usrcode VALUE="#FORM.USRCODE#" CFSQLTYPE="CF_SQL_VARCHAR">
	<CFELSE>
		<CFPROCPARAM TYPE="IN" DBVARNAME=@as_usrcode NULL="YES" CFSQLTYPE="CF_SQL_VARCHAR">
	</CFIF>
	<CFIF IsDefined("FORM.USRCODE2") AND FORM.USRCODE2 IS NOT "~~NODATA~~">
		<CFPROCPARAM TYPE="IN" DBVARNAME=@as_usrcode2 VALUE="#FORM.USRCODE2#" CFSQLTYPE="CF_SQL_VARCHAR">
	<CFELSE>
		<CFPROCPARAM TYPE="IN" DBVARNAME=@as_usrcode2 NULL="YES" CFSQLTYPE="CF_SQL_VARCHAR">
	</CFIF>
	<!---cfif USID IS 0 AND COTYPEID IS 1>
		<cfset CLMTYPEACCLIST=1+2+4+8+32>
	</cfif--->
	<CFIF IsDefined("CLMTYPEACCLIST") AND CLMTYPEACCLIST IS NOT "">
		<CFPROCPARAM TYPE="IN" DBVARNAME=@ai_clmtypeaccmask VALUE="#CLMTYPEACCLIST#" CFSQLTYPE="CF_SQL_INTEGER">
	<CFELSE>
		<CFPROCPARAM TYPE="IN" DBVARNAME=@ai_clmtypeaccmask NULL="YES" CFSQLTYPE="CF_SQL_INTEGER">
	</CFIF>
	<CFIF IsDefined("FORM.APPLIMIT") AND FORM.APPLIMIT IS NOT "">
		<cfif FORM.APPLIMIT IS "NULL">
			<CFPROCPARAM TYPE="IN" DBVARNAME=@amn_applimit VALUE=0 CFSQLTYPE="CF_SQL_MONEY">
		<cfelse>
			<CFPROCPARAM TYPE="IN" DBVARNAME=@amn_applimit VALUE="#FORM.APPLIMIT#" CFSQLTYPE="CF_SQL_MONEY">
		</cfif>
	<CFELSE>
		<CFPROCPARAM TYPE="IN" DBVARNAME=@amn_applimit NULL="YES" CFSQLTYPE="CF_SQL_MONEY">
	</CFIF>
	<CFIF IsDefined("FORM.DESIGNATION")>
		<CFPROCPARAM TYPE="IN" DBVARNAME=@as_designation VALUE="#FORM.DESIGNATION#" CFSQLTYPE="CF_SQL_VARCHAR">
	<CFELSE>
		<CFPROCPARAM TYPE="IN" DBVARNAME=@as_designation NULL="YES" CFSQLTYPE="CF_SQL_VARCHAR">
	</CFIF>
	<CFIF IsDefined("FORM.DEPARTMENT")>
		<CFPROCPARAM TYPE="IN" DBVARNAME=@as_dept VALUE="#FORM.DEPARTMENT#" CFSQLTYPE="CF_SQL_VARCHAR">
	<CFELSE>
		<CFPROCPARAM TYPE="IN" DBVARNAME=@as_dept NULL="YES" CFSQLTYPE="CF_SQL_VARCHAR">
	</CFIF>
	<CFIF IsDefined("FORM.DIDNO")>
		<CFPROCPARAM TYPE="IN" DBVARNAME=@aa_telno VALUE="#FORM.DIDNO#" CFSQLTYPE="CF_SQL_CHAR">
	<CFELSE>
		<CFPROCPARAM TYPE="IN" DBVARNAME=@aa_telno NULL="YES" CFSQLTYPE="CF_SQL_CHAR">
	</CFIF>
	<CFIF IsDefined("FORM.EMAIL")>
		<CFPROCPARAM TYPE="IN" DBVARNAME=@as_email VALUE="#FORM.EMAIL#" CFSQLTYPE="CF_SQL_VARCHAR">
	<CFELSE>
		<CFPROCPARAM TYPE="IN" DBVARNAME=@as_email NULL="YES" CFSQLTYPE="CF_SQL_VARCHAR">
	</CFIF>
	<CFIF IsDefined("FORM.ICHILDCOACCESS") AND FORM.ICHILDCOACCESS IS NOT "">
		<CFPROCPARAM TYPE="IN" DBVARNAME=@ai_childcoaccess VALUE="#FORM.ICHILDCOACCESS#" CFSQLTYPE="CF_SQL_INTEGER">
	<CFELSE>
		<CFPROCPARAM TYPE="IN" DBVARNAME=@ai_childcoaccess NULL="YES" CFSQLTYPE="CF_SQL_INTEGER">
	</CFIF>
	<CFIF IsDefined("FORM.CLRSUSPEND")>
		<CFIF UCase(FORM.CLRSUSPEND) IS "CLEAR">
			<CFPROCPARAM TYPE="IN" DBVARNAME=@asi_clearsuspend VALUE=1 CFSQLTYPE="CF_SQL_SMALLINT">
		<CFELSEIF UCase(FORM.CLRSUSPEND) IS "CLEARALL">
			<CFPROCPARAM TYPE="IN" DBVARNAME=@asi_clearsuspend VALUE=2 CFSQLTYPE="CF_SQL_SMALLINT">
		<CFELSE>
			<CFPROCPARAM TYPE="IN" DBVARNAME=@asi_clearsuspend NULL="YES" CFSQLTYPE="CF_SQL_SMALLINT">
		</CFIF>
	<CFELSE>
		<CFPROCPARAM TYPE="IN" DBVARNAME=@asi_clearsuspend NULL="YES" CFSQLTYPE="CF_SQL_SMALLINT">
	</CFIF>
	<CFIF IsDefined("FORM.DEFPLIST")>
		<!---CFPROCPARAM TYPE="IN" DBVARNAME=@as_defplist VALUE="#FORM.DEFPLIST#" CFSQLTYPE="CF_SQL_VARCHAR"--->
		<CFPROCPARAM TYPE="IN" DBVARNAME=@as_defplist NULL="YES" CFSQLTYPE="CF_SQL_VARCHAR">
	<CFELSE>
		<CFPROCPARAM TYPE="IN" DBVARNAME=@as_defplist NULL="YES" CFSQLTYPE="CF_SQL_VARCHAR">
	</CFIF>
	<CFIF IsDefined("FORM.PERCHK")>
		<CFPROCPARAM TYPE="IN" DBVARNAME=@as_perchk VALUE="#FORM.PERCHK#" CFSQLTYPE="CF_SQL_VARCHAR">
	<CFELSE>
		<CFPROCPARAM TYPE="IN" DBVARNAME=@as_perchk NULL="YES" CFSQLTYPE="CF_SQL_VARCHAR">
	</CFIF>
	<CFPARAM NAME=FORM.GRPLIST DEFAULT="">
	<CFPARAM NAME=FORM.DEFGRPLIST DEFAULT="">
	<CFPARAM NAME=FORM.DEFGRPLEAD DEFAULT="">
	<CFPARAM NAME=FORM.GRPLEAD DEFAULT="">
	<CFIF IsDefined("FORM.DEFGRPLIST")>
		<!---CFPROCPARAM TYPE="IN" DBVARNAME=@as_defgrplist VALUE="#FORM.DEFGRPLIST#" CFSQLTYPE="CF_SQL_VARCHAR"--->
		<CFPROCPARAM TYPE="IN" DBVARNAME=@as_defgrplist NULL="YES" CFSQLTYPE="CF_SQL_VARCHAR">
	<CFELSE>
		<CFPROCPARAM TYPE="IN" DBVARNAME=@as_defgrplist NULL="YES" CFSQLTYPE="CF_SQL_VARCHAR">
	</CFIF>
	<CFIF IsDefined("FORM.GRPLIST")>
		<CFPROCPARAM TYPE="IN" DBVARNAME=@as_grpchk VALUE="#FORM.GRPLIST#" CFSQLTYPE="CF_SQL_VARCHAR">
	<CFELSE>
		<CFPROCPARAM TYPE="IN" DBVARNAME=@as_grpchk NULL="YES" CFSQLTYPE="CF_SQL_VARCHAR">
	</CFIF>
	<CFIF IsDefined("FORM.DEFGRPLEAD")>
		<CFPROCPARAM TYPE="IN" DBVARNAME=@as_defgrplead NULL="YES" CFSQLTYPE="CF_SQL_VARCHAR">
		<!---CFPROCPARAM TYPE="IN" DBVARNAME=@as_defgrplead VALUE="#FORM.DEFGRPLEAD#" CFSQLTYPE="CF_SQL_VARCHAR"--->
	<CFELSE>
		<CFPROCPARAM TYPE="IN" DBVARNAME=@as_defgrplead NULL="YES" CFSQLTYPE="CF_SQL_VARCHAR">
	</CFIF>
	<CFIF IsDefined("FORM.GRPLEAD")>
		<CFPROCPARAM TYPE="IN" DBVARNAME=@as_grplead VALUE="#FORM.GRPLEAD#" CFSQLTYPE="CF_SQL_VARCHAR">
	<CFELSE>
		<CFPROCPARAM TYPE="IN" DBVARNAME=@as_grplead NULL="YES" CFSQLTYPE="CF_SQL_VARCHAR">
	</CFIF>
	<CFIF USID IS 0>
		<CFPROCPARAM TYPE="IN" DBVARNAME=@as_userid VALUE="#FORM.USERID#" CFSQLTYPE="CF_SQL_VARCHAR">
		<CFPROCPARAM TYPE="IN" DBVARNAME=@ai_coid VALUE="#li_coid#" CFSQLTYPE="CF_SQL_INTEGER">
		<CFPROCPARAM TYPE="OUT" DBVARNAME=@ai_outusid VARIABLE=USID CFSQLTYPE="CF_SQL_INTEGER">
	<CFELSE>
		<CFPROCPARAM TYPE="IN" DBVARNAME=@as_userid NULL=YES VALUE="" CFSQLTYPE="CF_SQL_VARCHAR">
		<CFPROCPARAM TYPE="IN" DBVARNAME=@ai_coid NULL=YES VALUE="" CFSQLTYPE="CF_SQL_INTEGER">
		<CFPROCPARAM TYPE="OUT" DBVARNAME=@ai_outusid VARIABLE=USIDOUT CFSQLTYPE="CF_SQL_INTEGER">
	</CFIF>
	<CFIF IsDefined("FORM.CHGPWDFLAGEXISTS")>
		<CFPARAM NAME=FORM.CHGPWDFLAG DEFAULT=0>
		<CFPROCPARAM TYPE="IN" DBVARNAME=@asi_chgpwd VALUE="#FORM.CHGPWDFLAG#" CFSQLTYPE="CF_SQL_SMALLINT">
	<CFELSE>
		<CFPROCPARAM TYPE="IN" DBVARNAME=@asi_chgpwd NULL=YES VALUE="0" CFSQLTYPE="CF_SQL_SMALLINT">
	</CFIF>
	<CFIF isdefined("FORM.USRID1") and FORM.USRID1 neq "">
		<CFPROCPARAM TYPE="IN" DBVARNAME=@as_usrid1 VALUE="#UCASE(TRIM(FORM.USRID1))#" CFSQLTYPE="CF_SQL_VARCHAR">
		<CFIF isdefined("FORM.USRID1SEL")>
			<CFPROCPARAM TYPE="IN" DBVARNAME=@asi_usrid1type VALUE="#FORM.USRID1SEL#" CFSQLTYPE="CF_SQL_SMALLINT">
		<CFELSE>
			<CFPROCPARAM TYPE="IN" DBVARNAME=@asi_usrid1type NULL=YES CFSQLTYPE="CF_SQL_SMALLINT">
		</CFIF>
	<CFELSE>
		<CFPROCPARAM TYPE="IN" DBVARNAME=@as_usrid1 NULL=YES CFSQLTYPE="CF_SQL_VARCHAR">
		<CFPROCPARAM TYPE="IN" DBVARNAME=@asi_usrid1type NULL=YES CFSQLTYPE="CF_SQL_SMALLINT">
	</CFIF>
	<CFIF isdefined("FORM.USRID2") and FORM.USRID2 neq "">
		<CFPROCPARAM TYPE="IN" DBVARNAME=@as_usrid2 VALUE="#UCASE(TRIM(FORM.USRID2))#" CFSQLTYPE="CF_SQL_VARCHAR">
		<CFIF isdefined("FORM.USRID2SEL")>
			<CFPROCPARAM TYPE="IN" DBVARNAME=@asi_usrid2type VALUE="#FORM.USRID2SEL#" CFSQLTYPE="CF_SQL_SMALLINT">
		<CFELSE>
			<CFPROCPARAM TYPE="IN" DBVARNAME=@asi_usrid2type NULL=YES CFSQLTYPE="CF_SQL_SMALLINT">
		</CFIF>
	<CFELSE>
		<CFPROCPARAM TYPE="IN" DBVARNAME=@as_usrid2 NULL=YES CFSQLTYPE="CF_SQL_VARCHAR">
		<CFPROCPARAM TYPE="IN" DBVARNAME=@asi_usrid2type NULL=YES CFSQLTYPE="CF_SQL_SMALLINT">
	</CFIF>
	<CFIF IsDefined("FORM.MPHONE")>
		<CFIF IsDefined("FORM.MPHONEPREF")>
			<cfif FORM.MPHONE NEQ "">
				<CFSET PHONE=TRIM(FORM.MPHONEPREF)&TRIM(FORM.MPHONE)>
			<cfelse>
				<cfset PHONE="">
			</cfif>
			<CFPROCPARAM TYPE="IN" DBVARNAME=@as_mphone VALUE="#PHONE#" CFSQLTYPE="CF_SQL_VARCHAR">
		<cfelse>
			<CFPROCPARAM TYPE="IN" DBVARNAME=@as_mphone VALUE="#TRIM(FORM.MPHONE)#" CFSQLTYPE="CF_SQL_VARCHAR">
		</CFIF>
	<CFELSE>
		<CFPROCPARAM TYPE="IN" DBVARNAME=@as_mphone NULL=YES CFSQLTYPE="CF_SQL_VARCHAR">
	</CFIF>
	<CFIF IsDefined("FORM.siUSRACCTYPE")>
		<CFPROCPARAM TYPE="IN" DBVARNAME=@asi_usracctype VALUE="#FORM.siUSRACCTYPE#" CFSQLTYPE="CF_SQL_SMALLINT">
	<CFELSE>
		<CFPROCPARAM TYPE="IN" DBVARNAME=@asi_usracctype NULL=YES VALUE="0" CFSQLTYPE="CF_SQL_SMALLINT">
	</CFIF>
	<cfif Form.VASIGLOGO NEQ "">
		<CFPROCPARAM TYPE="IN" DBVARNAME=@as_ussignature VALUE="#GETFILENAME#" CFSQLTYpe="CF_SQL_VARCHAR">
	<cfelse>
		<CFPROCPARAM TYPE="IN" DBVARNAME=@as_ussignature NULL="YES" VALUE="" CFSQLTYpe="CF_SQL_VARCHAR">
	</cfif>
	<CFIF IsDefined("FORM.BANKACCOUNT")>
		<CFPROCPARAM TYPE="IN" DBVARNAME=@as_bankaccount VALUE="#Trim(FORM.BANKACCOUNT)#" CFSQLTYPE="CF_SQL_VARCHAR">
	<CFELSE>
		<CFPROCPARAM TYPE="IN" DBVARNAME=@as_bankaccount NULL="YES" CFSQLTYPE="CF_SQL_VARCHAR">
	</CFIF>
	<CFIF IsDefined("FORM.BANKCOID") AND FORM.BANKCOID IS NOT "">
		<CFPROCPARAM TYPE="IN" DBVARNAME=@ai_bankcoid VALUE="#FORM.BANKCOID#" CFSQLTYPE="CF_SQL_INTEGER">
	<CFELSE>
		<CFPROCPARAM TYPE="IN" DBVARNAME=@ai_bankcoid NULL="YES" CFSQLTYPE="CF_SQL_INTEGER">
	</CFIF>
	<CFIF IsDefined("FORM.BANKACCNAME")>
		<CFPROCPARAM TYPE="IN" DBVARNAME=@as_bankaccname VALUE="#Trim(FORM.BANKACCNAME)#" CFSQLTYPE="CF_SQL_VARCHAR">
	<CFELSE>
		<CFPROCPARAM TYPE="IN" DBVARNAME=@as_bankaccname NULL="YES" CFSQLTYPE="CF_SQL_VARCHAR">
	</CFIF>
	<CFIF IsDefined("FORM.VACCNO")>
		<CFPROCPARAM TYPE="IN" DBVARNAME=@as_vaccno VALUE="#Trim(FORM.VACCNO)#" CFSQLTYPE="CF_SQL_VARCHAR">
	<CFELSE>
		<CFPROCPARAM TYPE="IN" DBVARNAME=@as_vaccno NULL="YES" CFSQLTYPE="CF_SQL_VARCHAR">
	</CFIF>
	<CFIF IsDefined("FORM.slcsegment") AND FORM.slcsegment IS NOT "">
		<CFPROCPARAM TYPE="IN" DBVARNAME=@ai_segment VALUE="#Trim(FORM.slcsegment)#" CFSQLTYPE="CF_SQL_INTEGER">
	<CFELSE>
		<CFPROCPARAM TYPE="IN" DBVARNAME=@ai_segment NULL="YES" CFSQLTYPE="CF_SQL_INTEGER">
	</CFIF>
	<CFPROCPARAM TYPE="IN" DBVARNAME=@as_remarks NULL="YES" CFSQLTYPE="CF_SQL_VARCHAR">
	<cfif IsDefined("attributes.ssologin") AND attributes.ssologin eq 1>
		<CFPROCPARAM TYPE="IN" DBVARNAME=@ai_cstid value="#attributes.iCSTID#" CFSQLTYPE="CF_SQL_INTEGER">
	<cfelse>
		<CFPROCPARAM TYPE="IN" DBVARNAME=@ai_cstid NULL="YES" CFSQLTYPE="CF_SQL_INTEGER">
	</cfif>
	<CFIF IsDefined("FORM.LineID") AND FORM.LineID IS NOT "">
		<CFPROCPARAM TYPE="IN" DBVARNAME=@as_lineID VALUE="#Trim(FORM.LineID)#" CFSQLTYPE="CF_SQL_VARCHAR">
	<CFELSE>
		<CFPROCPARAM TYPE="IN" DBVARNAME=@as_lineID NULL="YES" CFSQLTYPE="CF_SQL_VARCHAR">
	</CFIF>
	<!---CFIF IsDefined("FORM.CHGPWDFLAGEXISTS")>
		<CFPARAM NAME=FORM.CHGPWDFLAG DEFAULT=0>
		<CFPROCPARAM TYPE="IN" DBVARNAME=@asi_chgpwd VALUE="#FORM.CHGPWDFLAG#" CFSQLTYPE="CF_SQL_SMALLINT">
	</CFIF--->
	<CFIF IsDefined("FORM.VCID") AND FORM.VCID IS NOT "">
		<CFPROCPARAM TYPE="IN" DBVARNAME=@as_vcid VALUE="#Trim(FORM.VCID)#" CFSQLTYPE="CF_SQL_VARCHAR">
	<CFELSE>
		<CFPROCPARAM TYPE="IN" DBVARNAME=@as_vcid NULL="YES" CFSQLTYPE="CF_SQL_VARCHAR">
	</CFIF>
	<CFIF IsDefined("FORM.sleUSRENDDT") AND FORM.sleUSRENDDT IS NOT "">
		<CFPROCPARAM TYPE="IN" DBVARNAME=@adt_USRENDDATE VALUE="#Request.DS.FN.SVCDtLocToDB(FORM.sleUSRENDDT)#" CFSQLTYPE="CF_SQL_TIMESTAMP">
	<CFELSE>
		<CFPROCPARAM TYPE="IN" DBVARNAME=@adt_USRENDDATE NULL="YES" CFSQLTYPE="CF_SQL_TIMESTAMP">
	</CFIF>
	
	<!--- ZH #31234 --->
	<CFIF IsDefined("RESVCLMMASK") AND RESVCLMMASK IS NOT "">
		<CFPROCPARAM TYPE="IN" DBVARNAME=@ai_resvclmmask VALUE="#RESVCLMMASK#" CFSQLTYPE="CF_SQL_INTEGER">
	<CFELSE>
		<CFPROCPARAM TYPE="IN" DBVARNAME=@ai_resvclmmask NULL="YES" CFSQLTYPE="CF_SQL_INTEGER">
	</CFIF>
</CFSTOREDPROC>
<cfset returncode=CFSTOREDPROC.StatusCode>
<cfif returncode IS -20>
	<cfthrow TYPE="EX_SECFAILED" ErrorCode="USREXIST">
<cfelseif returncode LTE 0>
	<cfthrow TYPE="EX_DBERROR" ErrorCode="ADMIN-USRPROF(#returncode#)">
</cfif>

<!--- BEGIN: #39432 custom setup for SG MSI : section --->
<cfif Isdefined("FORM.sleDeptSecAvail") AND FORM.sleDeptSecAvail NEQ "">
	<cfparam name="FORM.sleDeptSec" default="">
	<CFSTOREDPROC PROCEDURE="sspSECUserDeptSectionSet" DATASOURCE="#Request.MTRDSN#" RETURNCODE="YES">
		<CFPROCPARAM TYPE="IN" DBVARNAME=@ai_USID VALUE="#USID#" CFSQLTYPE="CF_SQL_INTEGER">
		<CFPROCPARAM TYPE="IN" DBVARNAME=@as_SET VALUE="#FORM.sleDeptSec#" CFSQLTYPE="CF_SQL_VARCHAR">
		<CFPROCPARAM TYPE="IN" DBVARNAME=@ai_byusid VALUE="#SESSION.VARS.USID#" CFSQLTYPE="CF_SQL_INTEGER">
	</CFSTOREDPROC>
	<cfset returncode=CFSTOREDPROC.StatusCode>
	<cfif returncode LT 0><cfthrow TYPE="EX_DBERROR" ErrorCode="ADMIN-DEPTSEC(#returncode#)"></cfif>
</cfif>
<!--- END: #39432 custom setup for SG MSI : section --->

<!--- FORM.slePOLICYGRPID = <cfdump var=#FORM.slePOLICYGRPID#>
FORM.sleLIMITCODELIST = <cfdump var=#FORM.sleLIMITCODELIST#>
<cfabort> --->


<!--- 	<cfloop list=#FORM.slePOLICYGRPID# index="elem">
		<cfloop list=#FORM.sleLIMITCODELIST# index="code">


				<cfif IsDefined("FORM.slePOLICYGRPRIGHTS#elem##code#")>
					<cfset FORMFIELD=#evaluate("FORM.slePOLICYGRPRIGHTS#elem##code#")#>
					<cfif FORMFIELD IS ""><cfset FORMFIELD="-1"></cfif>
					applying asi_POLGRPRIGHTS as #FORMFIELD#<br>
				<cfelse>
					asi_POLGRPRIGHTS as null <br>
				</cfif>
				<CFIF IsDefined("FORM.slePOLICYGRPLIMIT#elem##code#") AND evaluate("FORM.slePOLICYGRPLIMIT#elem##code#") NEQ "">
					<cfset FORMFIELD=#evaluate("FORM.slePOLICYGRPLIMIT#elem##code#")#>
					<cfif FORMFIELD LT 0 AND FORMFIELD IS NOT -1><cfset FORMFIELD=0></cfif>
					applying amn_POLGRPAPPLIMIT as #FORMFIELD#<br>
				<CFELSE>
					amn_POLGRPAPPLIMIT as null<br>
				</CFIF>

		</cfloop>
	</cfloop>


		<cfabort> --->


<cfif IsDefined("FORM.slePOLICYGRPID") AND FORM.slePOLICYGRPID NEQ "" AND IsDefined("USID") AND USID NEQ "" AND Isdefined("FORM.sleLIMITCODELIST") AND FORM.sleLIMITCODELIST NEQ "">
	<!--- policy group access --->
	<cfloop list=#FORM.slePOLICYGRPID# index="elem">
		<cfloop list=#FORM.sleLIMITCODELIST# index="code">
			<CFSTOREDPROC PROCEDURE="sspDEVUserPolicyGrpAccess" DATASOURCE="#Request.MTRDSN#" RETURNCODE="YES">
				<CFPROCPARAM TYPE="IN" DBVARNAME=@ai_USID VALUE="#USID#" CFSQLTYPE="CF_SQL_INTEGER">
				<CFPROCPARAM TYPE="IN" DBVARNAME=@ai_byusid VALUE="#SESSION.VARS.USID#" CFSQLTYPE="CF_SQL_INTEGER">
				<CFPROCPARAM TYPE="IN" DBVARNAME=@ai_POLGRPID VALUE="#elem#" CFSQLTYPE="CF_SQL_INTEGER">
				<CFPROCPARAM TYPE="IN" DBVARNAME=@as_LIMITCODE VALUE="#code#" CFSQLTYPE="CF_SQL_VARCHAR">
				<cfif IsDefined("FORM.slePOLICYGRPRIGHTS#elem##code#")>
					<cfset FORMFIELD=#evaluate("FORM.slePOLICYGRPRIGHTS#elem##code#")#>
					<cfif FORMFIELD IS ""><cfset FORMFIELD="-1"></cfif>
					<CFPROCPARAM TYPE="IN" DBVARNAME=@asi_POLGRPRIGHTS VALUE=#FORMFIELD# CFSQLTYPE="CF_SQL_SMALLINT">
				<cfelse>
					<CFPROCPARAM TYPE="IN" DBVARNAME=@asi_POLGRPRIGHTS NULL="YES" CFSQLTYPE="CF_SQL_SMALLINT">
				</cfif>
				<CFIF IsDefined("FORM.slePOLICYGRPLIMIT#elem##code#") AND evaluate("FORM.slePOLICYGRPLIMIT#elem##code#") NEQ "">
					<cfset FORMFIELD=#evaluate("FORM.slePOLICYGRPLIMIT#elem##code#")#>
					<cfif FORMFIELD LT 0 AND FORMFIELD IS NOT -1><cfset FORMFIELD=0></cfif>
					<CFPROCPARAM TYPE="IN" DBVARNAME=@amn_POLGRPAPPLIMIT VALUE=#Request.DS.FN.SVCNumLocToDB(FORMFIELD)# CFSQLTYPE="CF_SQL_MONEY">
				<CFELSE>
					<CFPROCPARAM TYPE="IN" DBVARNAME=@amn_POLGRPAPPLIMIT NULL="YES" CFSQLTYPE="CF_SQL_MONEY">
				</CFIF>
		        <CFPROCPARAM TYPE="IN" DBVARNAME=@as_userid VALUE="#FORM.USERID#" CFSQLTYPE="CF_SQL_VARCHAR">
		        <CFPROCPARAM TYPE="IN" DBVARNAME=@ai_coid VALUE="#li_coid#" CFSQLTYPE="CF_SQL_INTEGER">
			</CFSTOREDPROC>
		</cfloop>
	</cfloop>
</cfif>

<cfmodule TEMPLATE="#request.apppath#services/index.cfm" FUSEBOX=SVCSec FUSEACTION=act_ssouserlist usid=#USID# coid=#Attributes.FROMCOID# vaUSERID=#FORM.USERID#>
<CFIF listfindnocase("DEV",application.DB_MODE) GT 0>
	<cfmodule TEMPLATE="#request.apppath#services/index.cfm" FUSEBOX=SVCSec FUSEACTION=act_eplclmsso usid=#USID# coid=#Attributes.FROMCOID# vaUSERID=#FORM.USERID#>
</CFIF>
<CFSET SSOENABLE=Val(Request.DS.FN.SVCgetExtAttrLogic("COADMIN",0,"COATTR-SSO-SERVICE",10,#li_coid#))>

<CFIF SSOENABLE IS 1 AND IsDefined("FORM.PERCHK") AND IsDefined("FORM.DEFPLIST")>
	<CFIF LISTCONTAINS(FORM.PERCHK,6000) GT 0 AND LISTFINDNOCASE(FORM.DEFPLIST,6000) EQ 0>
		<cfmodule TEMPLATE="#request.apppath#services/CustomTags\SVCchkgrp.cfm" GRPLIST="6000">
		<cfmodule TEMPLATE="#request.apppath#services/index.cfm" FUSEBOX=SVCSec FUSEACTION=act_createssoacc usid=#USID# coid=#USER_ICOID# USERID=#FORM.USERID#>
	</CFIF>
</CFIF>

<CFSET AttrSAPIVal=val(Request.DS.FN.SVCgetExtAttrLogic("COADMIN",0,"COATTR-SAPI-MODULES",10,FROM_IGCOID))>
<CFIF AttrSAPIVal GT 0 AND IsDefined("FORM.APIKEY") AND IsDefined("FORM.SecretKey") AND BITAND(FORM.siUSRACCTYPE,2) EQ 2>
	<cfif FORM.APIKEY EQ "">
		<cfset FORM.APIKEY = Request.DS.FN.SVCGenSAPIToken()>
	</cfif>
	<cfif FORM.SecretKey EQ "">
		<cfset FORM.SecretKey = Request.DS.FN.SVCGenSAPIToken()>
	</cfif>
	<cfmodule TEMPLATE="#request.apppath#services/index.cfm" FUSEBOX=SVCSec FUSEACTION=act_SAPIApiKey usid=#USID# mode=#Attributes.MODE#>
</CFIF>

<!---cfmodule TEMPLATE="#request.apppath#services/index.cfm" FUSEBOX=SVCsec FUSEACTION=act_usergroupassign AddGroupList=#form.AddGroupList# DelGroupList=#form.DelGroupList# ModGroupList=#form.ModGroupList# cur_user=#USID#--->

<!--- Mike: Commit security groups --->
<!---cfmodule TEMPLATE="#Request.LOGPATH#index.cfm" fusebox=SVCadmin fuseaction=act_pgroupformcommit USID="#USID#"--->
<cfif FORM.RSAPWD IS NOT "">
	<cfif BitAnd(HQPWDMASK,4097) IS 4097>
		<cfmodule TEMPLATE="#request.apppath#services/index.cfm" FUSEBOX=SVCSec FUSEACTION=act_changePWD iusid=#USID# VARRESULT=VARRESULT ADMINMODE=1 CASESENSITIVE=1>
	<cfelse>
		<cfmodule TEMPLATE="#request.apppath#services/index.cfm" FUSEBOX=SVCSec FUSEACTION=act_changePWD iusid=#USID# VARRESULT=VARRESULT ADMINMODE=1>
	</cfif>
	<!--- return result in VARRESULT.RESULTSTR --->
</cfif>



<cfif FORM.RSAPWD IS NOT "" AND VARRESULT.RESULTSTR IS NOT "">
	<cfset urlparam="index.cfm?fusebox=admin&fuseaction=dsp_stafflist&iusid=#usid#&pwdrejectstr=#URLEncodedFormat(VARRESULT.RESULTSTR)#">
	<cfif IsDefined("url.COID")><cfset urlparam = urlparam & "&COID=#attributes.coid#"></cfif>
	<cfif IsDefined("url.FROMCOID")><cfset urlparam = urlparam & "&FROMCOID=#attributes.FROMCOID#"></cfif>
<cfelse>
	<cfif IsDefined("FORM.SUBMITTYPE") AND FORM.SUBMITTYPE IS 1>
		<cfif Isdefined("attributes.URLBACK") AND attributes.URLBACK NEQ "">
			<cfset urlparam=#attributes.URLBACK#>
		<cfelse>
			<cfset urlparam="index.cfm?fusebox=admin&fuseaction=dsp_stafflist&COID=#FROM_ICOID#">
		</cfif>
	<cfelse>
		<cfset urlparam="index.cfm?fusebox=admin&fuseaction=dsp_stafflist&USERID=#FORM.USERID#">
		<!--- <cfif IsDefined("url.COID")><cfset urlparam = urlparam & "&COID=#attributes.coid#"></cfif> --->
		<cfif IsDefined("url.FROMCOID")><cfset urlparam = urlparam & "&FROMCOID=#attributes.FROMCOID#"></cfif>
	</cfif>

	<cfif IsDefined("FORM.sendlogin") and FORM.sendlogin eq 1 and isdefined("FORM.encpwd") and FORM.encpwd neq "" and IsDefined("FORM.EMAIL") and FORM.EMAIL neq "">
		<CFTRY>
			<cfmodule TEMPLATE="#request.apppath#services/index.cfm" FUSEBOX=SVCSec FUSEACTION=act_regemail AttributeCollection="#attributes#" cotypeid="#cotypeid#" modusid="#USID#" gcoid="#gcoid#" mode="#attributes.mode#">
			<CFCATCH>
				<cfthrow TYPE="EX_SECFAILED" ErrorCode="BADREGMAIL">
			</CFCATCH>
		</CFTRY>
	</cfif>

</cfif>

<cfif NOT(IsDefined("FORM.SUBMITTYPE") AND FORM.SUBMITTYPE IS 1)><!--- append with URLBACK param if return back to same page --->
	<cfif IsDefined("url.URLBACK")><cfset urlparam = urlparam & "&URLBACK=#URLEncodedFormat(attributes.URLBACK)#"></cfif>
</cfif>

<CFLOCATION URL="#request.webroot##urlparam#&#Request.MToken#" ADDTOKEN="no">
