<cffunction name="RptGenFilter">
<!--- Examples for predefined option:
CLAIMS
---------
Show adjuster GCOID:
	#RptGenFilter("Adjuster","ADJ-COGRP","AdjBy")#
Show insurer GCOID:
	#RptGenFilter("Insurer","INS-COGRP","InsBy")#
Show adjuster surveyor:
	#RptGenFilter("Surveyor","ADJ-SURVEYOR","AdjSurBy","",CHCOLIST)#
Show supplementary option (param4 is the default value,1=All,2=MainCaseOnly,3=SuppOnly):
	#RptGenFilter("Select","CLM-SUPP","Suppl",2)#
Show panel selection:
	#RptGenFilter("","CLM-PANEL","RepBy","1")#
Show LOOKUP for all repairers (include branches):
	#RptGenFilter("","REP-COBR","ddlbRepairer","","",0)#
	OR #RptGenFilter("Repairer Branch","LOOKUP","ddlbRepairer","","",0,70,"","","","xml_SVCSelectorCompany&COLOCID=#SESSION.VARS.LOCID#&COTYPEID=1&cancreate=0","CONAME,COID")#
Show LOOKUP for repairer GCOID:
	#RptGenFilter("","REP-COGRP","ddlbRepairerGroup","","",0)#
	OR #RptGenFilter("Repairer Group","LOOKUP","ddlbRepairerGroup","","",0,70,"","","","xml_SVCSelectorCompany&COLOCID=#SESSION.VARS.LOCID#&COTYPEID=1&cancreate=0&SHOWCONAME=1&subscribe=1","CONAME,COID")#
Show model selection:
	#RptGenFilter("","CLM-MODEL","ModelBy","","",0)#
Show offer selection:
	#RptGenFilter("","CLM-OFRTYPE","OfrTypeBy")#
Show vehicle class selection:
	#RptGenFilter("","CLM-VEHCLS","VehClassBy")#
Show Labels:
	#RptGenFilter("Tags","CLM-LABEL","LabelBy","2,3,4")#
Show Claim Types:
	#RptGenFilter("Claim Type","CLM-TYPE","1073725439","1073725439")#
--->
	<cfargument name="TITLE">
	<cfargument name="UI" default="SELECT">
	<cfargument name="VARNAME">
	<cfargument name="DEFVALUE" default=0>
	<cfargument name="OPTLIST" default="">
	<cfargument name="COMPULSORY" default=0>
	<cfargument name="SIZE" default=20>
	<cfargument name="onblur" default="">
	<cfargument name="DEFUNIT" default="">
	<cfargument name="OPTLISTSEP" default=",">
	<cfargument name="LOOKUPURL" default="">
	<cfargument name="LOOKUPARGS" default="">
	<cfargument name="RADIOWIDTH" default=140>
	<cfargument name="RADIOCOLS" default=4>
	<cfargument name="APPEND_TITLE" default=1><!--- Report Title - Bit 1:default,Bit 2:don't show subheader --->
	<cfargument name="onclick" default=""><!--- Param 16 --->
	<cfargument name="MULTIPLE" default=""><!--- Multiple row for SELECT, integer value to indicate how many rows to display --->
	<cfargument name="siSUBSCRIBE" default="-1"><!--- SEC0005.siSUBSCRIBE ---><!--- Lim Soon Eng #40302: [TH] ALL - Add field for search report on "Pending Report Surveyor" - Surveyor side --->
	<cfargument name="BUTTON_LABEL" default="">	
	<cfargument name="DOMAINID" default="">
	<cfargument name="CLMTYPEMASK" default=""> <!--- #56413 --->

	<cfset process=0>
	<cfif UI IS "ADJ-COGRP">
		<CFQUERY NAME=q_trx DATASOURCE=#Request.RPTDSN#>
		SELECT id=a.iCOID,name=a.vaCONAME
		FROM SEC0005 a WITH (NOLOCK)
		WHERE a.siCOTYPEID=3 AND a.siACCEPTCASE>0 AND a.siSTATUS<>1 AND a.siSUBSCRIBE&1=1 AND a.iLOCID=<cfqueryparam value="#SESSION.VARS.LOCID#" cfsqltype="CF_SQL_INTEGER"> AND
		<cfif OPTLIST IS "BR">a.iCOUNTRYID=(SELECT iCOUNTRYID FROM SEC0005 WHERE iCOID=<cfqueryparam value="#SESSION.VARS.ORGID#" cfsqltype="CF_SQL_INTEGER">)<cfelse>a.iPCOID=0</cfif>
		AND CASE WHEN a.iPCOID=0 THEN 3 ELSE (SELECT siCOTYPEID FROM SEC0005 WHERE iCOID=a.iPCOID) END=3 AND IsNull(a.iPASCCOID,0)=0
		UNION
		SELECT coid=a.iCOID,coname=a.vaCONAME + ' (' + a.vaCOBRNAME + ')'
		FROM SEC0005 a WITH (NOLOCK)
		WHERE a.siCOTYPEID=3 AND a.iPASCCOID=<cfqueryparam value="#SESSION.VARS.ORGID#" cfsqltype="CF_SQL_INTEGER">
		ORDER BY name
		</CFQUERY>
		<cfset process=1>
	<cfelseif UI IS "INS-COGRP">
		<CFQUERY NAME=q_trx DATASOURCE=#Request.RPTDSN#>
		SELECT id=iCOID,name=vaCONAME
		FROM SEC0005 a WITH (NOLOCK)
		WHERE a.siCOTYPEID=2 AND a.iCOUNTRYID=(SELECT iCOUNTRYID FROM SEC0005 WHERE iCOID=<cfqueryparam value="#SESSION.VARS.ORGID#" cfsqltype="CF_SQL_INTEGER">)
		AND a.iCOID=a.iGCOID AND a.siSTATUS=0
		<cfif siSUBSCRIBE GTE 0>
			AND a.siSUBSCRIBE=<cfqueryparam value="#siSUBSCRIBE#" cfsqltype="CF_SQL_INTEGER">
		</cfif>
		ORDER BY name
		</CFQUERY>
		<cfset process=1>
	<cfelseif UI IS "ADJ-SURVEYOR">
		<CFQUERY NAME=q_trx DATASOURCE=#Request.RPTDSN#>
		SELECT DISTINCT id=a.vaUSID,name='('+b.vaCOBRNAME+') '+a.vaUSNAME
		FROM SEC0001 a WITH (NOLOCK),SEC0005 b WITH (NOLOCK),dbo.fFSECUserPermissionByCoGroup(<cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.VARS.GCOID#">,'3,5,6,12') c
		WHERE a.iCOID=b.iCOID AND a.iUSID=c.iUSID AND b.siCOTYPEID=3 AND
		b.iCOID IN (<cfqueryparam value="#OPTLIST#" cfsqltype="CF_SQL_INTEGER" list="true">) AND a.siSTATUS<>1 AND b.siSTATUS<>1
		ORDER BY name
		</CFQUERY>
		<cfset process=1>
	<cfelseif UI IS "CLM-SUPP">
		<!---cfset q_trx=QueryNew("id,name")>
		<cfset QueryAddRow(q_trx)><cfset QuerySetCell(q_trx,"id",1)><cfset QuerySetCell(q_trx,"name","All")>
		<cfset QueryAddRow(q_trx)><cfset QuerySetCell(q_trx,"id",2)><cfset QuerySetCell(q_trx,"name","Exclude Supplementary")>
		<cfset QueryAddRow(q_trx)><cfset QuerySetCell(q_trx,"id",3)><cfset QuerySetCell(q_trx,"name","Supplementary Only")>
		<cfset APPEND_TITLE=3>
		<cfset process=1--->
		<cfset Request.DS.FN.SVCRptGenFilter("Supplementary","RADIO",VARNAME,"1","1|All|2|Main Only|3|Supp Only",COMPULSORY,SIZE,onblur,DEFUNIT,OPTLISTSEP,LOOKUPURL,LOOKUPARGS,RADIOWIDTH,3,APPEND_TITLE,onclick)>
		<cfexit METHOD=EXITTEMPLATE>
	<cfelseif UI IS "CLM-PANEL">
		<cfset Request.DS.FN.SVCRptGenFilter(#Server.SVClang("Panel Selection",37616)#,"RADIO",VARNAME,"1","1|#Server.SVClang("All",1626)#|2|#Server.SVClang("Panel only",3665)#|3|#Server.SVClang("Non Panel only",4619)#|4|#Server.SVClang("Franchise only",4618)#|5|#Server.SVClang("Non Franchise only",5103)#|6|#Server.SVClang("Franchise Authorized only",18015)#",COMPULSORY,SIZE,onblur,DEFUNIT,OPTLISTSEP,LOOKUPURL,LOOKUPARGS,RADIOWIDTH,3,APPEND_TITLE,onclick)>
		<cfexit METHOD=EXITTEMPLATE>
	<cfelseif UI IS "REP-COBR">
		<cfset Request.DS.FN.SVCRptGenFilter("Repairer Branch","LOOKUP",VARNAME,"","",COMPULSORY,70,"","","","xml_SVCSelectorCompany&COLOCID=#SESSION.VARS.LOCID#&COTYPEID=1&cancreate=0&SHOWCONAME=0&INCMONITORCOM=1","CONAME,COID")>
		<cfexit METHOD=EXITTEMPLATE>
	<cfelseif UI IS "REP-COGRP">
		<cfset Request.DS.FN.SVCRptGenFilter("Repairer Group","LOOKUP",VARNAME,"","",COMPULSORY,70,"","","","xml_SVCSelectorCompany&COLOCID=#SESSION.VARS.LOCID#&COTYPEID=1&cancreate=0&SHOWCONAME=1&INCMONITORCOM=1","CONAME,COID")>
		<cfexit METHOD=EXITTEMPLATE>
	<cfelseif UI IS "CLM-MODEL">
		<cfset Request.DS.FN.SVCRptGenFilter("Vehicle Model/Variant","LOOKUP",VARNAME,"","",COMPULSORY,70,"","","","xml_SVCSelectorCarModel&COLOCID=#LOCID#&COTYPEID=2","MODEL,VARID")>
		<cfexit METHOD=EXITTEMPLATE>
	<cfelseif UI IS "CLM-MODEL-NOVAR">
		<cfset Request.DS.FN.SVCRptGenFilter("Vehicle Model","LOOKUP",VARNAME,"","",COMPULSORY,70,"","","","xml_SVCSelectorCarModelNoVar&COLOCID=#LOCID#&COTYPEID=2","MODEL,ID")>
		<cfexit METHOD=EXITTEMPLATE>
	<cfelseif UI IS "CLM-VEH-MAKE">
		<CFQUERY NAME=q_trx DATASOURCE=#Request.MTRCATDSN#>
		SELECT id=a.iMANID,name=a.vaMAN
		FROM CAT0002 a WITH (NOLOCK),CAT0004 b WITH (NOLOCK)
		WHERE a.siSTATUS=0 AND a.iMANID=b.iMANID AND b.iLOCID=<cfqueryparam value="#REQUEST.DS.LOCALES[SESSION.VARS.LOCID].PDBLOCID#" cfsqltype="CF_SQL_INTEGER">
		ORDER BY name
		</CFQUERY>
		<cfset process=1>
	<cfelseif UI IS "CLM-OFRTYPE">
		<cfset Request.DS.FN.SVCRptGenFilter("Offer Type","RADIO",VARNAME,"1","1|All|2|Non TL only|3|TL only|4|Contract Repair only",COMPULSORY,SIZE,onblur,DEFUNIT,OPTLISTSEP,LOOKUPURL,LOOKUPARGS,RADIOWIDTH,3,APPEND_TITLE,onclick)>
		<cfexit METHOD=EXITTEMPLATE>
	<cfelseif UI IS "CLM-VEHCLS">
		<cfset Request.DS.FN.SVCRptGenFilter("Vehicle Class","RADIO",VARNAME,"0","0|All|1|Private/Company|2|Commercial/Others",COMPULSORY,SIZE,onblur,DEFUNIT,OPTLISTSEP,LOOKUPURL,LOOKUPARGS,RADIOWIDTH,RADIOCOLS,APPEND_TITLE,onclick)>
		<cfexit METHOD=EXITTEMPLATE>
	<cfelseif UI IS "CO-BRANCH">
		<CFQUERY NAME=q_trx DATASOURCE=#Request.RPTDSN#>
		SELECT id=iCOID,name=vaCOBRNAME
		FROM SEC0005 a WITH (NOLOCK)
		WHERE a.iGCOID=<cfqueryparam value="#SESSION.VARS.GCOID#" cfsqltype="CF_SQL_INTEGER"> AND a.iCOID IN (<cfqueryparam value="#OPTLIST#" cfsqltype="CF_SQL_INTEGER" list="true">)
		AND a.siSTATUS=0 AND a.siSUBSCRIBE&1=1
		ORDER BY name
		</CFQUERY>
		<cfset process=1>
	<cfelseif UI IS "INS-AGENT">
		<cfset Request.DS.FN.SVCRptGenFilter("Agent","LOOKUP",VARNAME,"","",COMPULSORY,70,"","","","xml_SVCSelectorAgentContactNo&gcoid=#SESSION.VARS.GCOID#&reqmobile=0&cancreate=0&subcotypeflag=4","AGENTNAME,AGENTPNLID")>
		<cfexit METHOD=EXITTEMPLATE>
	<cfelseif UI IS "INS-BROKER">
		<cfset Request.DS.FN.SVCRptGenFilter("Agent","LOOKUP",VARNAME,"","",COMPULSORY,70,"","","","xml_SVCSelectorAgentContactNo&gcoid=#SESSION.VARS.GCOID#&reqmobile=0&cancreate=0&subcotypeflag=2","AGENTNAME,AGENTPNLID")>
		<cfexit METHOD=EXITTEMPLATE>
	<cfelseif UI IS "INS-SURVEYOR">
		<CFQUERY NAME=q_trx DATASOURCE=#Request.RPTDSN#>
		SELECT DISTINCT id=a.vaUSID,name='('+b.vaCOBRNAME+') '+a.vaUSNAME
		FROM SEC0001 a WITH (NOLOCK),SEC0005 b WITH (NOLOCK),dbo.fFSECUserPermissionByCoGroup(<cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.VARS.GCOID#">,'2,4,25,30') c
		WHERE a.iCOID=b.iCOID AND a.iUSID=c.iUSID AND b.siCOTYPEID=2 AND
		b.iCOID IN (<cfqueryparam value="#OPTLIST#" cfsqltype="CF_SQL_INTEGER" list="true">) AND a.siSTATUS<>1 AND b.siSTATUS<>1
		ORDER BY name
		</CFQUERY>
		<cfset process=1>
	<cfelseif UI IS "INS-SUPPLIER">
		<CFQUERY NAME=q_trx DATASOURCE=#Request.RPTDSN#>
		SELECT ID=a.iCOID,NAME=a.vaCONAME FROM SEC0005 a WITH (NOLOCK)
		INNER JOIN TRX0030 b WITH (NOLOCK) ON b.iCOID=<cfqueryparam value="#SESSION.VARS.GCOID#" cfsqltype="CF_SQL_INTEGER"> AND b.iPNLCOID=a.iCOID AND b.siPNLTYPE=9 AND b.siPNLSTAT=1
		WHERE a.siCOTYPEID=9 AND a.siSUBSCRIBE&1=1 AND a.siSTATUS=0
		ORDER BY a.vaCONAME
		</CFQUERY>
		<cfset process=1>
	<CFELSEIF UI IS "INS-STAFF">
		<CFQUERY NAME=q_trx DATASOURCE=#Request.RPTDSN#>
		select ID = a.vausid, name = (CASE WHEN a.siSTATUS = 1 THEN '[Deleted] ' ELSE '' END) + '('+b.vaCOBRNAME+') '+a.vausname
		from SEC0001 a WITH (NOLOCK) INNER JOIN SEC0005 b WITH (NOLOCK) ON a.iCOID=b.iCOID
		where a.iCOID IN (<cfqueryparam value="#CHCOLIST#" cfsqltype="CF_SQL_INTEGER" list="true">)
		ORDER BY a.siSTATUS, vaUSName
		</CFQUERY>
		<cfset process=1>
	<CFELSEIF UI IS "ADJ-BRANCH">
		<CFQUERY NAME=q_trx DATASOURCE=#Request.RPTDSN#>
			SELECT id=a.iCOID,name=a.vaCONAME + ' (' + a.vaCOBRNAME + ')'
			FROM SEC0005 a WITH (NOLOCK)
			WHERE a.siCOTYPEID=3 AND a.siACCEPTCASE>0 AND a.siSTATUS<>1 AND a.siSUBSCRIBE&1=1 AND a.iLOCID=<cfqueryparam value="#SESSION.VARS.LOCID#" cfsqltype="CF_SQL_INTEGER"> --AND
			-- <cfif OPTLIST IS "BR">a.iCOUNTRYID=(SELECT iCOUNTRYID FROM SEC0005 WHERE iCOID=<cfqueryparam value="#SESSION.VARS.ORGID#" cfsqltype="CF_SQL_INTEGER">)<cfelse>a.iPCOID=0</cfif>
			AND CASE WHEN a.iPCOID=0 THEN 3 ELSE (SELECT siCOTYPEID FROM SEC0005 WHERE iCOID=a.iPCOID) END=3 AND IsNull(a.iPASCCOID,0)=0
			UNION
			SELECT coid=a.iCOID,coname=a.vaCONAME + ' (' + a.vaCOBRNAME + ')'
			FROM SEC0005 a WITH (NOLOCK)
			WHERE a.siCOTYPEID=3 AND a.iPASCCOID=<cfqueryparam value="#SESSION.VARS.ORGID#" cfsqltype="CF_SQL_INTEGER">
			ORDER BY name
		</CFQUERY>
		<cfset process=1>
	</cfif>
	<cfif process IS 1>
		<cfset _list=" | |">
		<cfloop query=q_trx><cfset _list=_list & "#id#|#name#|"></cfloop>
		<cfset Request.DS.FN.SVCRptGenFilter(TITLE,"SELECT",VARNAME,"",_list,COMPULSORY,SIZE,onblur,DEFUNIT,OPTLISTSEP,LOOKUPURL,LOOKUPARGS,RADIOWIDTH,RADIOCOLS,APPEND_TITLE,onclick,MULTIPLE,BUTTON_LABEL,DOMAINID,CLMTYPEMASK)>
		<cfexit METHOD=EXITTEMPLATE>
	</cfif>

	<cfset Request.DS.FN.SVCRptGenFilter(TITLE,UI,VARNAME,DEFVALUE,OPTLIST,COMPULSORY,SIZE,onblur,DEFUNIT,OPTLISTSEP,LOOKUPURL,LOOKUPARGS,RADIOWIDTH,RADIOCOLS,APPEND_TITLE,onclick,MULTIPLE,BUTTON_LABEL,DOMAINID,CLMTYPEMASK)>
</cffunction>

<cffunction name="RptGenTableMatrix" output="yes">
<cfargument name="ST" type="struct" required="yes">
<cfset FN=Request.DS.FN>
<cfset rowspan=1>
<cfset xsubtotal=false><!--- Display Subtotal column --->
<cfset ysubtotal=false><!--- Display Subtotal row --->
<cfif NOT IsDefined("ST.FMT")>
	<cfset ST.FMT={
		TOTCOL=true,<!--- Display Total column --->
		TOTROW=true,<!--- Display Total row --->
		TOTROWGRP=1,<!--- No. of row grouping--->
		TOTROWGRP_NM=[""],<!--- If no. of row grouping is 2, then must have 2 items, etc --->
		TOTROWGRP_NUMFMT=["0"],
		OVRCOL=false,
		OVRROW=false,<!--- Display Overall Avg row --->
		OVRROWGRP=1,<!--- No. of row grouping--->
		OVRROWGRP_NM=[""],
		OVRROWGRP_NUMFMT=["2"],
		OVRROWGRP_DATA=[[]],
		OVRCOLGRP_DATA=[[]],
		ROWADDINFO=[],<!--- Additional Info to display in the header for each row --->
		ROWGRP = false, <!--- Display Row Subgroup Header --->
		ROWGRP_NM = [""], <!--- Row Subgroup Header Names --->
		ROWGRP_POS = [], <!--- Row Subgroup Header position, add before specific row. Must same item count with ROWGRP_NM --->
		ROWHIDE = [], <!--- To hide rows --->
		V={}<!--- Individual data formatting attributes: .NUMFMT/.COLOR/.BGCOLOR --->
	}>
</cfif>
<cfif NOT StructKeyExists(ST.FMT,"ROWADDINFO")>
	<cfset ST.FMT.ROWADDINFO=[]>
</cfif>
<cfif NOT StructKeyExists(ST.FMT,"V")>
	<cfset ST.FMT.V={}>
</cfif>
<cfif NOT StructKeyExists(ST.FMT,"ROWGRP")>
	<cfset ST.FMT.ROWGRP = false>
</cfif>
<cfif NOT StructKeyExists(ST.FMT,"ROWHIDE")>
	<cfset ST.FMT.ROWHIDE=[]>
</cfif>
<cfset st.XLEN=ListLen(st.X,st.DLM)>
<cfset st.YLEN=ListLen(st.Y,st.DLM)>
<cfif IsDefined("ST.X3") AND ListLen(ST.X3,ST.DLM) GT 0>
	<cfset rowspan=3>
	<cfset st.X2LEN=ListLen(st.X2,st.DLM)>
	<cfset st.X3LEN=ListLen(st.X3,st.DLM)>
<cfelseif IsDefined("ST.X2") AND ListLen(ST.X2,ST.DLM) GT 0>
	<cfset rowspan=2>
	<cfset st.X2LEN=ListLen(st.X2,st.DLM)>
</cfif>
<cfif IsDefined("ST.XSUB") AND ST.XSUB>
	<cfset xsubtotal=true>
</cfif>
<cfif IsDefined("ST.YSUB") AND ST.YSUB>
	<cfset ysubtotal=true>
	<cfif NOT IsDefined("ST.YSUBPAIR")>
		<cfthrow TYPE="EX_SECFAILED" ErrorCode="BADPARAM" ExtendedInfo="ST.YSUBPAIR must be specified">
	</cfif>
	<cfif ListLen(ST.YSUBPAIR.Y,ST.DLM) NEQ ListLen(ST.YSUBPAIR.G,ST.DLM)>
		<cfthrow TYPE="EX_SECFAILED" ErrorCode="BADPARAM" ExtendedInfo="List length must be equal for ST.YSUBPAIR.Y and ST.YSUBPAIR.G">
	</cfif>
</cfif>
<TABLE border=1 align=center cellpadding=2 cellspacing=0 style="font-size:100%">
<col class=clsSVCColText>
<cfloop list="#ST.X#" index=a delimiters="#ST.DLM#">
	<col class=clsSVCColMoney>
	<cfif rowspan GTE 2>
		<cfloop list="#ST.X2#" index=b delimiters="#ST.DLM#">
		<col class=clsSVCColMoney>
		</cfloop>
		<cfif rowspan GTE 3>
			<cfloop list="#ST.X3#" index=b delimiters="#ST.DLM#">
			<col class=clsSVCColMoney>
			</cfloop>
		</cfif>
		<cfif xsubtotal>
			<col class=clsSVCColMoney>
		</cfif>
	</cfif>
</cfloop>
<cfif ST.FMT.TOTCOL>
	<col class=clsSVCColMoney>
</cfif>
<cfif ST.FMT.OVRCOL>
	<col class=clsSVCColMoney>
</cfif>
<tr class=clsColumnHeader>
	<td rowspan=#rowspan#>&nbsp;</td>
	<cfloop list="#ST.X#" index=a delimiters="#ST.DLM#">
		<cfset c=0>
		<cfif rowspan GTE 2>
			<cfset c=ST.X2LEN>
			<cfif rowspan GTE 3>
				<cfset c=ST.X2LEN*ST.X3LEN>
			</cfif>
		</cfif>
		<cfif xsubtotal>
			<cfset c+=1>
		</cfif>
		<td colspan=#c# align=center>#HTMLEditFormat(a)#</td>
	</cfloop>
	<cfif ST.FMT.TOTCOL>
		<td rowspan=#rowspan# align=center>#Server.SVCLang("Total",1737)#</td>
	</cfif>
	<cfif ST.FMT.OVRCOL>
		<td rowspan=#rowspan# align=center>#Server.SVCLang("Overall Avg",25546)#</td>
	</cfif>
</tr>
<cfif rowspan GTE 2>
	<tr class=clsColumnHeader>
		<cfloop list="#ST.X#" index=a delimiters="#ST.DLM#">
			<cfloop list="#ST.X2#" index=b delimiters="#ST.DLM#">
			<td<cfif rowspan GTE 3> colspan=#ST.X3LEN#</cfif> align=center>#HTMLEditFormat(b)#</td>
			</cfloop>
			<cfif session.vars.gcoid IS 16529>
				<cfif xsubtotal>
					<td rowspan=#rowspan-1# align=center>#Server.SVCLang("Mitsubishi Make",6647)#</td>
				</cfif>
			<cfelse>
				<cfif xsubtotal>
					<td rowspan=#rowspan-1# align=center>#Server.SVCLang("Subtotal",6647)#</td>
				</cfif>
			</cfif>
		</cfloop>
	</tr>
	<cfif rowspan GTE 3>
		<tr class=clsColumnHeader>
		<cfloop list="#ST.X#" index=a delimiters="#ST.DLM#">
			<cfloop list="#ST.X2#" index=b delimiters="#ST.DLM#">
				<cfloop list="#ST.X3#" index=c delimiters="#ST.DLM#">
				<td align=center>#HTMLEditFormat(c)#</td>
				</cfloop>
			</cfloop>
		</cfloop>
		</tr>
	</cfif>
</cfif>
<cfset cntx=ListLen(ST.X,ST.DLM)>
<cfif rowspan GTE 3>
	<cfset cntx=ListLen(ST.X,ST.DLM)*ListLen(ST.X2,ST.DLM)*ListLen(ST.X3,ST.DLM)>
<cfelseif rowspan GTE 2>
	<cfset cntx=ListLen(ST.X,ST.DLM)*ListLen(ST.X2,ST.DLM)>
</cfif>
<cfset a=0>
<cfset ygrplast="">
<cfset ygrplastidx=1>
<cfloop list="#ST.Y#" index=c delimiters="#ST.DLM#">
	<cfset a+=1>
	<cfset b=0>
	<cfset tx=0>
	<cfset tx2=0>
	<CFIF ArrayFind(ST.FMT.ROWHIDE, a) GT 0>
		<CFCONTINUE>
	</CFIF>
	<CFIF ST.FMT.ROWGRP>
		<CFIF ArrayLen(ST.FMT.ROWGRP_NM) GT 0 AND ArrayFind(ST.FMT.ROWGRP_POS, a) GT 0>
			<tr class="clsColumnSubHeader"><td colspan="#st.YLEN + iif(ST.FMT.TOTCOL, 1, 0) + iif(ST.FMT.OVRCOL, 1, 0) - ArrayLen(st.FMT.ROWHIDE)#">#ST.FMT.ROWGRP_NM[ArrayFind(ST.FMT.ROWGRP_POS, a)]#</td></tr>
		</CFIF>
	</CFIF>
	<cfif ysubtotal>
		<cfset ygrpcur=ListGetAt(ST.YSUBPAIR.G,ListFind(ST.YSUBPAIR.Y,c,ST.DLM),ST.DLM)>
		<cfif ygrplast IS NOT ygrpcur>
			<cfif ygrplast IS NOT "">
				<cfset RptGenTableMatrixTotal("#Server.SVCLang("Subtotal for",25547)# "&ygrplast,ygrplastidx,a-1)>
			</cfif>
			<cfset ygrplastidx=a>
			<cfset ygrplast=ygrpcur>
		</cfif>
	</cfif>
	<CFSET ABC=IIf(a MOD ST.FMT.TOTROWGRP EQ 0,ST.FMT.TOTROWGRP,a MOD ST.FMT.TOTROWGRP)>
	<tr<CFIF ABC MOD 2 IS 0> style="background-color:##DCDCDC"</CFIF>>
		<td style="background-color:##ADD8E6;font-weight:bold">#HTMLEditFormat(c)#<cfif ArrayLen(st.FMT.ROWADDINFO) AND ArrayIsDefined(st.FMT.ROWADDINFO,a)>#st.FMT.ROWADDINFO[a]#</cfif></td>
		<cfloop from=1 to=#cntx# index=d>
			<cfset b+=1>
			<!--- Initialize variable if not defined --->
			<cfif ArrayLen(ST.V[a]) LT b OR NOT ArrayIsDefined(ST.V[a],b)>
				<cfset ST.V[a][b]=0>
			</cfif>
			<cfif NOT StructKeyExists(ST.FMT.V,a)>
				<cfset ST.FMT.V[a]={}>
			</cfif>
			<cfif NOT StructKeyExists(ST.FMT.V[a],b)>
				<cfset ST.FMT.V[a][b]={NUMFMT="",CSSSTYLE=""}>
			</cfif>
			<td<CFIF ST.FMT.V[a][b].CSSSTYLE IS NOT ""> style="#ST.FMT.V[a][b].CSSSTYLE#"</CFIF>>
				<CFIF ST.FMT.TOTROWGRP_NUMFMT[ABC] GTE 0>
					<cfset tx+=ST.V[a][b]>
					<cfif xsubtotal>
						<cfset tx2+=ST.V[a][b]>
					</cfif>
					<cfif ST.FMT.V[a][b].NUMFMT IS NOT "">
						#FN.SVCnum(ST.V[a][b],ST.FMT.V[a][b].NUMFMT)#
					<cfelse>
						#FN.SVCnum(ST.V[a][b],ST.FMT.TOTROWGRP_NUMFMT[ABC])#
					</cfif>
				<CFELSE>
					<cfif ST.FMT.V[a][b].NUMFMT IS NOT "">
						#FN.SVCnum(ST.V[a][b],ST.FMT.V[a][b].NUMFMT)#
					<cfelse>
						#HTMLEditFormat(ST.V[a][b])#
					</cfif>
				</CFIF>
			</td>
			<cfif xsubtotal>
				<cfif rowspan GTE 3>
					<cfset g=ST.X2LEN*ST.X3LEN>
				<cfelse>
					<cfset g=ST.X2LEN>
				</cfif>
				<cfif (d MOD g EQ 0)>
					<td>#FN.SVCnum(tx2,ST.FMT.TOTROWGRP_NUMFMT[ABC])#</td>
					<cfset tx2=0>
				</cfif>
			</cfif>
		</cfloop>
		<cfif ST.FMT.TOTCOL>
			<td style="background-color:##ADD8E6;font-weight:bold" align="right">#FN.SVCnum(tx,ST.FMT.TOTROWGRP_NUMFMT[ABC])#</td>
		</cfif>
		<cfif ST.FMT.OVRCOL>
			<td style="background-color:##ADD8E6;font-weight:bold" align="right">
			<cfif ArrayLen(ST.FMT.OVRCOLGRP_DATA) AND ArrayLen(ST.FMT.OVRCOLGRP_DATA[ABC]) AND ArrayIsDefined(ST.FMT.OVRCOLGRP_DATA[ABC],a)>
				<cfif IsNumeric(ST.FMT.OVRCOLGRP_DATA[ABC][a])>
					#FN.SVCnum(ST.FMT.OVRCOLGRP_DATA[ABC][a],ST.FMT.OVRROWGRP_NUMFMT[ABC])#
				<cfelse>
					#ST.FMT.OVRCOLGRP_DATA[ABC][a]#
				</cfif>
			<cfelse>
				<cfif cntx GT 0>#FN.SVCnum(tx/cntx,ST.FMT.OVRROWGRP_NUMFMT[ABC])#<cfelse>#FN.SVCnum(0,ST.FMT.OVRROWGRP_NUMFMT[ABC])#</cfif>
			</cfif>
			</td>
		</cfif>
	</tr>
	<cfif ysubtotal AND a EQ ST.YLEN>
		<cfset RptGenTableMatrixTotal("#Server.SVCLang("Subtotal for",25547)# "&ygrplast,ygrplastidx,a)>
	</cfif>
</cfloop>
<cfset RptGenTableMatrixTotal()>
</TABLE>
</cffunction>

<cffunction name="RptGenTableMatrixTotal" output="yes">
<cfargument name="title" type="string" required="no" default="">
<cfargument name="start" type="numeric" required="no" default=0>
<cfargument name="end" type="numeric" required="no" default=0>
<cfset var subtotal=true>
<cfif start EQ 0>
	<cfset start=1>
	<cfset end=ListLen(ST.Y,ST.DLM)>
	<cfset subtotal=false>
</cfif>
<cfif ST.FMT.TOTROW>
<CFLOOP FROM=1 TO=#ST.FMT.TOTROWGRP# INDEX=DEF>
<tr class=<cfif subtotal>clsRptTone2<cfelse>clsRptTotal</cfif>>
	<td align=right><cfif title IS NOT "">#HTMLEditFormat(title)#<cfelse>Total #HTMLEditFormat(ST.FMT.TOTROWGRP_NM[DEF])#</cfif></td>
	<cfset ty=[]>
	<cfset tyg=0>
	<cfset tyg2=0>
	<cfloop from=1 to=#cntx# index=e>
		<CFIF ST.FMT.TOTROWGRP_NUMFMT[DEF] GTE 0>
			<CFSET ty[e]=0>
		</CFIF>
		<td>
			<cfloop from=#start# to=#end# index=f>
				<CFSET ABC=IIf(f MOD ST.FMT.TOTROWGRP EQ 0,ST.FMT.TOTROWGRP,f MOD ST.FMT.TOTROWGRP)>
				<CFIF DEF EQ ABC AND ST.FMT.TOTROWGRP_NUMFMT[ABC] GTE 0>
					<cfset ty[e]+=ST.V[f][e]>
					<cfif xsubtotal>
						<cfset tyg2+=ST.V[f][e]>
					</cfif>
				</CFIF>
			</cfloop>
			#FN.SVCnum(ty[e],ST.FMT.TOTROWGRP_NUMFMT[DEF])#
			<cfset tyg+=ty[e]>
		</td>
		<cfif xsubtotal>
			<cfif rowspan GTE 3>
				<cfset g=ST.X2LEN*ST.X3LEN>
			<cfelse>
				<cfset g=ST.X2LEN>
			</cfif>
			<cfif (e MOD g EQ 0)>
				<td>#FN.SVCnum(tyg2,ST.FMT.TOTROWGRP_NUMFMT[DEF])#</td>
				<cfset tyg2=0>
			</cfif>
		</cfif>
	</cfloop>
	<cfif ST.FMT.TOTCOL>
		<td>#FN.SVCnum(tyg,ST.FMT.TOTROWGRP_NUMFMT[DEF])#</td>
	</cfif>
</tr>
</CFLOOP>
</cfif>
<cfif ST.FMT.OVRROW AND NOT subtotal>
<CFLOOP FROM=1 TO=#ST.FMT.OVRROWGRP# INDEX=DEF>
<tr class=<cfif subtotal>clsRptTone2<cfelse>clsRptTotal</cfif>>
	<td align=right><cfif title IS NOT "">#HTMLEditFormat(title)#<cfelse>#Server.SVCLang("Overall Avg",25546)# #HTMLEditFormat(ST.FMT.OVRROWGRP_NM[DEF])#</cfif></td>
	<cfset ty=[]><cfset tyc=[]>
	<cfset tyg=0><cfset tygc=0>
	<cfset tyg2=0><cfset tyg2c=0>
	<cfloop from=1 to=#cntx# index=e>
		<CFIF ST.FMT.OVRROWGRP_NUMFMT[DEF] GTE 0>
			<CFSET ty[e]=0>
			<CFSET tyc[e]=0>
		</CFIF>
		<td>
			<cfloop from=#start# to=#end# index=f>
				<CFSET ABC=IIf(f MOD ST.FMT.OVRROWGRP EQ 0,ST.FMT.OVRROWGRP,f MOD ST.FMT.OVRROWGRP)>
				<CFIF DEF EQ ABC AND ST.FMT.OVRROWGRP_NUMFMT[ABC] GTE 0>
					<cfset ty[e]+=ST.V[f][e]>
					<cfset tyc[e]+=1>
					<cfif xsubtotal>
						<cfset tyg2+=ST.V[f][e]>
						<cfset tyg2c+=1>
					</cfif>
				</CFIF>
			</cfloop>
			<cfif ArrayLen(ST.FMT.OVRROWGRP_DATA) AND ArrayLen(ST.FMT.OVRROWGRP_DATA[DEF])>
				#FN.SVCnum(ST.FMT.OVRROWGRP_DATA[DEF][e],ST.FMT.OVRROWGRP_NUMFMT[DEF])#
			<cfelse>
				#FN.SVCnum(ty[e]/tyc[e],ST.FMT.OVRROWGRP_NUMFMT[DEF])#
			</cfif>
			<cfset tyg+=ty[e]/tyc[e]>
			<cfset tygc+=1>
		</td>
		<cfif xsubtotal>
			<cfif rowspan GTE 3>
				<cfset g=ST.X2LEN*ST.X3LEN>
			<cfelse>
				<cfset g=ST.X2LEN>
			</cfif>
			<cfif (e MOD g EQ 0)>
				<td>#FN.SVCnum(tyg2/tyg2c,ST.FMT.OVRROWGRP_NUMFMT[DEF])#</td>
				<cfset tyg2=0>
				<cfset tyg2c=0>
			</cfif>
		</cfif>
	</cfloop>
	<cfif ST.FMT.TOTCOL>
		<td>#FN.SVCnum(tyg/tygc,ST.FMT.OVRROWGRP_NUMFMT[DEF])#</td>
	</cfif>
</tr>
</CFLOOP>
</cfif>
</cffunction>

<cffunction name="ValueListUnique" output="no" returntype="string">
	<cfargument name="QRY" type="query" required="yes">
	<cfargument name="FIELD" type="string" required="yes">
	<cfargument name="DELIM" type="string" required="no" default="|">
	<cfset LST="">
	<cfloop query=QRY>
		<cfif ListFind(LST,"#Evaluate(FIELD)#",DELIM,"yes") IS 0>
			<cfset LST=ListAppend(LST,"#Evaluate(FIELD)#",DELIM)>
		</cfif>
	</cfloop>
	<cfreturn LST>
</cffunction>

<cffunction name="RptGenHeader">
<cfargument name="TYPE" type=numeric required=yes><!--- 0:Gen header,1:Gen title,2:Disallow report access on working day --->
<cfargument name="RPTTITLE" type=string required=no default=""><!--- For TYPE=1 --->
<cfargument name="URLBACK" type=string required=no default=""><!--- For TYPE=0 --->
<cfargument name="HIDEDRTEXT" type=string required=no default=0><!--- For TYPE=1 --->
<cfargument name="CHKREAD" type=numeric required=no default=1><!--- For TYPE=0 --->
<cfargument name="SHOWDATERANGE" type=numeric required=no default=1>
<cfargument name="SHOWDATERANGE_DTMAX" type=string required=no default="TODAY">
<cfargument name="SHOWCLAIMTYPE" type=numeric required=no default=1>
<cfargument name="SHOWDATERANGE_MAXDAYS" type=string required=no default="366">
<cfargument name="SHOWRPTTOEXCEL" type=numeric required=no default=1><!---22480show save to excel button if SHOWRPTTOEXCEL=0--->
<cfargument name="SHOWRPTTOEXCEL_DIVID" type=string required=no default=""><!---22480to display excel content--->
<cfargument name="SHOWRPTTOEXCEL_NAME" type=string required=no default="default"><!---22480excel file name--->
<cfargument name="CLAIMTYPEFILTER" type=numeric required=no default=0>
<cfargument name="URLVAR" type=string required=no default=""> <!---44145 pass url var--->
<cfparam name="DRTEXT" default="">
<CFIF TYPE EQ 0>
	<cfset FN=Request.DS.FN>
	<cfset LOCID=SESSION.VARS.LOCID>
	<cfset LOCALE=Request.DS.LOCALES[LOCID]>
	<cfset ORGTYPE=SESSION.VARS.ORGTYPE>
	<CFIF CHKREAD IS 1>
		<CFMODULE TEMPLATE="#request.apppath#services/CustomTags\SVCchkgrp.cfm" GrpList="33R" ChkRead=1>
	</CFIF>
	<CFMODULE TEMPLATE="#request.apppath#services/CustomTags\SVCaddfile.cfm" FNAME="SVCTABLE">
	<CFMODULE TEMPLATE="#request.apppath#services/CustomTags\SVCaddfile.cfm" FNAME="SVCMAIN">
	<CFOUTPUT>
	<br>
	<!---cfif NOT IsDefined("Attributes.NOLAYOUT")--->
		<div class=clsNoPrint>
		<script>
		JSVCSetLocale(#LOCID#,null,"#LOCALE.DTFORMAT#","#LOCALE.TMFORMAT#","#LOCALE.TIMEZONE#");
		GenerateMenubar("ReportMenu",90);
		<cfif URLBACK IS NOT "">
			AddToMenubar("ReportMenu","<< " + JSVClang("Back",7436),"#URLBACK#");
		<cfelse>
			AddToMenubar("ReportMenu","<< " + JSVClang("Reports",1057),request.webroot+"index.cfm?fusebox=MTRreports#ORGTYPE#&fuseaction=dsp_reports&"+request.mtoken);
		</cfif>
		AddToMenubar("ReportMenu",JSVClang("Process",9204),"JavaScript:ProcessReport()");
		<!----22480--->
		<cfif SHOWRPTTOEXCEL IS 0 AND IsDefined("processrpt") AND processrpt IS 1>
			AddToMenubar("ReportMenu",JSVClang("Save As Excel",7635),"javascript:saveToExcel('#Arguments.SHOWRPTTOEXCEL_DIVID#','#Arguments.SHOWRPTTOEXCEL_NAME#')");
		</cfif><!---22480--->
		function ProcessReport()
		{
			if(RptFormVerify(StatRpt))
				window.location=request.webroot+"index.cfm?fusebox=#Attributes.FUSEBOX#&fuseaction=#Attributes.FUSEACTION#<CFIF IsDefined("Attributes.RPTNAME")>&RPTNAME=#Attributes.RPTNAME#</cfif>&ProcessRpt=1<CFIF URLVAR NEQ "">&#URLVAR#</CFIF><CFIF URLBACK NEQ "">&urlback=#URLEncodedFormat(URLBACK)#</cfif>&"+request.mtoken+FormURLVAR(StatRpt);
		}
		function openRFQ(caseid,esid) {
			JSVCopenWin(request.webroot+"index.cfm?fusebox=MTResource&fuseaction=dsp_essubmit&caseid="+caseid+"&esid="+esid+"&"+request.mtoken);
		}
		function openClm(caseid) {
			JSVCopenWin(request.webroot+"index.cfm?fusebox=MTRroot&fuseaction=dsp_clmheader&caseid="+caseid+"&"+request.mtoken);
		}
		<!---22480--->
		function saveToExcel(divid,excelname) {
			var selector = divid.startsWith('##') ? divid : '##' + divid;
		    var div = divid;
			$(selector).find('script').remove() <!---prevent script block from being written in excel--->
			var c=JSVCall(div);
			if(c!=null)
			JSVCopenWinPost(request.webroot+"index.cfm?fusebox=SVCdoc&fuseaction=dsp_exportinexcel&formobjname="+div+"&filename="+excelname+"&"+request.mtoken,"newwin",[[div,c.innerHTML]]);
		} <!---22480--->
		</script>
		</div>
		<FORM NAME="StatRpt">
		<CFIF SHOWDATERANGE IS 1>
			<CFMODULE TEMPLATE="#request.apppath#services/CustomTags\SVCDATERANGE.cfm" DTMAX="#Arguments.SHOWDATERANGE_DTMAX#" MAXDAYS="#Arguments.SHOWDATERANGE_MAXDAYS#">
		</CFIF>
	<!---/cfif--->
		<CFIF CLAIMTYPEFILTER NEQ 0>
			<CFMODULE TEMPLATE="#Request.LOGPATH#CustomTags\MTRCLMTYPE.cfm" CLMTYPEMASK=#CLAIMTYPEFILTER#>
		<CFELSE>
			<CFMODULE TEMPLATE="#Request.LOGPATH#CustomTags\MTRCLMTYPE.cfm">
		</CFIF>
		<cfif Len(CLMTYPELIST) AND SHOWCLAIMTYPE EQ 1>
		<CFSET DRText=DRText & "<br>("&CLMTYPELIST&")">
		</cfif>


	</CFOUTPUT>
<CFELSEIF TYPE EQ 1>
	<CFOUTPUT>
	<!---cfif NOT IsDefined("Attributes.NOLAYOUT")---></FORM><!---/cfif--->
	<cfif RPTTITLE IS NOT ""><p class=clsRptSubTitle style=text-align:center>#RPTTITLE#<cfif HIDEDRTEXT IS 0><br>#DRText#</cfif></p></cfif>
	</CFOUTPUT>
<CFELSEIF TYPE EQ 2>
	<!--- Exclude DEV mode / Msia Reporting Server / UAT / PH,TH,VN --->
	<cfif Application.APPDEVMODE IS 1
			OR CGI.HTTP_HOST IS "203.115.234.147"
			OR CGI.HTTP_HOST IS "report.merimen.com.my"
			OR listfindnocase("UAT",application.DB_MODE) GT 0
			OR ListFind("10,11,15",Application.APPLOCID) GT 0>
		<cfexit METHOD=EXITTEMPLATE>
	</cfif>
	<cfset Request.DS.MTRFN.ReportQuery_BlockTime()>
</CFIF>
</cffunction>

<cffunction name=GetInjuryClassDesc returntype=string output=no>
	<cfargument name=INJCLASS type=numeric>
	<cfargument name=INJSUB type=numeric>
	<cfset var LST=Request.DS.INJCLASS[INJCLASS].SUBCLASS>
	<cfset var a=ListFind(LST,INJSUB,"|")>
	<cfif a GT 0>
		<cfreturn ListGetAt(LST,a+1,"|")>
	<cfelse>
		<cfreturn "">
	</cfif>
</cffunction>

<cffunction name=GenInjuryClassFilter output=yes>
<CFQUERY name=q_injparts datasource=#Request.MTRCATDSN#>
SELECT PGRPID=b.iPGRPID/1000000,a.vaDESCCODE,a.vaDESC FROM PDB0004 b WITH (NOLOCK),PDB0003 a WITH (NOLOCK)
WHERE b.iPSCID=6 AND a.iPSCID=6 AND b.vaDESCCODE=a.vaDESCCODE AND a.siSTATUS=0
ORDER BY b.iPGRPID,b.iPGRPSUBORDER,a.vaDESC
</CFQUERY>
<script>
var g_injuryClass=#SerializeJSON(Request.DS.INJCLASS)#;
function MTRinjuryClassChange(obj,target) {
	var injclass=obj.value;
	target=JSVCall(target);
	target.options.length=0;
	if(injclass=="")
		target.options[target.options.length]=new Option("[ Select Class first ]","")
	else
	{
		var s=g_injuryClass[injclass].SUBCLASS.split("|");
		if(s.length>2)
			target.options[target.options.length]=new Option("","");
		for(var x=0;x<s.length;x+=2) {
			target.options[target.options.length]=new Option(s[x+1],s[x]);
		}
	}
}
</script>
<CFOUTPUT>
<table class=clsNoPrint border=0 align=center cellpadding=1 cellspacing=1 style="width:90%">
<tr>
	<td style="font-weight:bold;width:25%" valign=top>#Server.SVCLang("Injury Part",25548)#:</td>
	<td><select name=sleINJPART URLVAR><option value=""><cfset curpgrpid=""><cfset cls=0><cfloop query=q_injparts><cfif curpgrpid IS NOT PGRPID><optgroup label="#Request.DS.PGrp[PGRPID]#"><cfset curpgrpid=PGRPID><cfset cls=1></cfif><option value="#vaDESCCODE#"<cfif IsDefined("sleINJPART") AND sleINJPART IS vaDESCCODE> selected</cfif>>#HTMLEditFormat(vaDESC)#</cfloop><cfif cls IS 1></optgroup><cfset cls=0></cfif></select></td>
</tr>
<!---<tr>
	<td style="font-weight:bold;width:25%" valign=top>#Server.SVCLang("Injury Class",25549)#:</td>
	<td><select name=sleINJCLASS URLVAR onchange="MTRinjuryClassChange(this,'sleINJTYPE')"><option value=""><cfloop collection="#Request.DS.INJCLASS#" item=a><option value="#a#"<cfif IsDefined("sleINJCLASS") AND sleINJCLASS IS a> selected</cfif>>#HTMLEditFormat(Request.DS.INJCLASS[a].NAME)#</cfloop></select></td>
</tr>--->
<!--- <tr>
	<td style="font-weight:bold;width:25%" valign=top>#Server.SVCLang("Injury Type",25550)#:</td>
	<td><select name=sleINJTYPE URLVAR><option value=""><cfif IsDefined("sleINJCLASS") AND sleINJCLASS IS NOT "" AND IsDefined("sleINJTYPE")><script>document.write(JSVCgenOptions("#Request.DS.INJCLASS[sleINJCLASS].SUBCLASS#","|","#sleINJTYPE#"))</script><cfelse>[ Select Class first ]</cfif></select></td>
</tr>--->

<!--- 32922 --->
<tr>
	<td style="font-weight:bold;width:25%" valign=top>#Server.SVCLang("Injury Type",25550)#:</td>
	<td><select name=sleINJTYPE URLVAR><option value="">
		<cfif !IsDefined("sleINJTYPE")>
			<cfset sleINJTYPE = "">
		</cfif>
		<cfloop collection="#Request.DS.INJCLASS#" item=a>
			<script>document.write(JSVCgenOptions("#Request.DS.INJCLASS[a].SUBCLASS#","|","#sleINJTYPE#"))</script>
		</cfloop>
	</select></td>
</tr>

</table>
</CFOUTPUT>
</cffunction>

<cffunction name="TH_RegionDefine" returntype=struct output=no>
<cfset var StructRegion={
	"Bangkok and Suburb"="316,338,342,373",
	"Central"="324,332,337,346,365,377,378,380,386,390",
	"East"="321,322,323,330,344,363,376",
	"North"="319,327,328,331,340,347,350,351,353,354,366,367,379,389",
	"Northeast"="318,320,325,334,335,341,356,357,359,361,368,369,370,382,383,384,385,387,388,391",
	"South"="315,326,329,336,339,345,348,349,355,360,362,371,372,381",
	"West"="317,333,343,352,364,374,375"
}>
<cfreturn StructRegion>
</cffunction>
<cffunction name="TH_RegionFilterGen" returntype=any output=yes>
<TABLE class=clsNoPrint border=0 align=center cellpadding=1 cellspacing=1 style=WIDTH:90%>
<tr>
	<td style=font-weight:bold;width:25%>Region:</td>
	<td>
		<select urlvar name="ddlbRegion"><option value=""></option>
		<cfloop list="#ListSort(StructKeyList(StructRegion), "text", "ASC")#" index="region"><option <CFIF isdefined("attributes.DDLBREGION") AND attributes.DDLBREGION is '#region#'> SELECTED </CFIF> value="#region#">#region#</option>
		</cfloop>
		</select>
	</td>
</tr>
</table>
<cfreturn>
</cffunction>



<script>
<!---22480 moved from genrptheader for reusability--->
function saveToExcel(divid,excelname) {
	var div = divid;
	$(div).remove() <!---prevent script block from being written in excel--->
	var c=JSVCall(div);
	if(c!=null)
	JSVCopenWinPost(request.webroot+"index.cfm?fusebox=SVCdoc&fuseaction=dsp_exportinexcel&formobjname="+div+"&filename="+excelname+"&"+request.mtoken,"newwin",[[div,c.innerHTML]]);
} <!---22480--->
function RptGenLink(orgtype,ar,sort,addnum,customrpt) { // ar:[group,fuseaction,title]
	var sf=function(a,b) {
		var a1=a[2],b1=b[2],c=0;
		if(a1>b1) c=1;
		else if(a1<b1) c=-1;
		else c=0;
		return c;
	}
	sort=(sort==null?1:sort);
	addnum=(addnum==null?0:addnum);
	customrpt=(customrpt==null?0:customrpt);
	if(sort==1)
		ar.sort(sf); // sort by title
	var t="";
	if(addnum==1)
		t="<ol style=line-height:150%;color:#454545>";
	else
		t="<ul style=line-height:150%>";
	for(var i in ar) {
		t+="<li><a onmouseover=\"window.status=unescape('"+(ar[i][2]).toString().replace(/['"]/g,'%27')+"');return true;\" onmouseout=window.status='';return true; href=\"javascript:location.href=request.webroot+'index.cfm?fusebox=MTRreports"+orgtype+"&fuseaction="+(customrpt==1?"dsp_custom&rptname="+ar[i][1]:ar[i][1])+"&'+request.mtoken;\">"+ar[i][2]+"</a></li>";
	}
	if(addnum==1)
		t+="</ol>";
	else
		t+="</ul>";
	document.write(t);
}

/********************************************************* NEW VERSION BEGIN *********************************************************/
function RptGenLink2(grpKey, title, orgtype, ar, sort, addnum, customrpt, grpbit) { // ar:[group,fuseaction,title]
	var grpID;
	if(ar.length == 0) return;
	var sf=function(a,b) {
		var a1=a[2],b1=b[2],c=0;
		if(a1>b1) c=1;
		else if(a1<b1) c=-1;
		else c=0;
		return c;
	}
	var icnt = 0;
	sort=(sort==null?1:sort);
	addnum=(addnum==null?0:addnum);
	customrpt=(customrpt==null?0:customrpt);
	grpbit = (grpbit == null ? 3 : grpbit);
	grpID = grpKey + "_" + grpbit;
	if(sort==1)
		ar.sort(sf); // sort by title
	var t="";
	if(addnum==1)
		t="<ol style=line-height:150%;color:#454545>";
	else
		t="<ul style=line-height:150%>";
	for(var i in ar) {
		if ((grpbit & ar[i][0]) > 0) {
			icnt += 1;
			t+="<li><a onmouseover=\"window.status=unescape('"+(ar[i][2]).toString().replace(/['"]/g,'%27')+"');return true;\" onmouseout=window.status='';return true; href=\"javascript:location.href=request.webroot+'index.cfm?fusebox=MTRreports"+orgtype+"&fuseaction="+(customrpt==1?"dsp_custom&rptname="+ar[i][1]:ar[i][1])+"&'+request.mtoken;\">"+ar[i][2]+"</a></li>";
		}
	}
	if(addnum==1)
		t+="</ol>";
	else
		t+="</ul>";
	if(icnt > 0) {
		t = "<table id=\"" + grpID + "\" class=\"lclsRptSubGrp\" style=\"width: 100%;\"><tr><td id=\"" + grpID + "_title\" class=\"lclsRptSubGrpTitle\" onclick=\"RptExpandCollapse('" + grpID + "');\" onmouseover=\"RptMouseIn('" + grpID + "');\" onmouseout=\"RptMouseOut('" + grpID + "');\">&nbsp;<img id=\"" + grpID + "_title_sign\" src=\"<cfoutput>#request.webroot#MSupport/minus.gif</cfoutput>\" height=\"9px\" width=\"9px\">&nbsp;" + title + "</td></tr><tr id=\"" + grpID + "_list\"><td style=\"font-weight:bold;\">" + t + "</td></tr></table>";
		document.write(t);
	}
}

function populateRpt(obj, addnum, customrpt, grpbit) {
	for (var g in obj) {
		if (g != "EOF") {
			RptGenLink2(g, obj[g]["title"], obj[g]["orgtype"], obj[g]["list"], obj[g]["sort"], addnum, customrpt, grpbit);
		}
	}
}

function RptMouseIn(grpID) {
	var tb = document.getElementById(grpID);
	var title = document.getElementById(grpID + '_title');

	title.className = "lclsRptSubGrpTitleHover";
}

function RptMouseOut(grpID) {
	var tb = document.getElementById(grpID);
	var title = document.getElementById(grpID + '_title');

	if ((tb.getAttribute('_ONSEARCH') == null && tb.getAttribute('HIDE_GRP') == null) || (tb.getAttribute('_ONSEARCH') == 1 && tb.getAttribute('SEARCH_HIDE_GRP') == null)) {
		title.className = "lclsRptSubGrpTitle";
	}
	else {
		title.className = "lclsRptSubGrpTitleHide";
	}
}

function RptExpandCollapse(grpID) {
	var tb = document.getElementById(grpID);
	var title = document.getElementById(grpID + '_title');
	var list = document.getElementById(grpID + '_list');

	if (tb != null) {
		if ((tb.getAttribute('_ONSEARCH') == null && tb.getAttribute('HIDE_GRP') == 1) || (tb.getAttribute('_ONSEARCH') == 1 && tb.getAttribute('SEARCH_HIDE_GRP') == 1)) {	// to Expand
			RptExpand(grpID);
		}
		else {
			RptCollapse(grpID);
		}
	}
}

function RptExpand(grpID) {
	var tb = document.getElementById(grpID);
	var title = document.getElementById(grpID + '_title');
	var sign = document.getElementById(grpID + '_title_sign');
	var list = document.getElementById(grpID + '_list');

	if (title != null) {
		title.className = "lclsRptSubGrpTitle";
		sign.src = "<cfoutput>#request.webroot#MSupport/minus.gif</cfoutput>";
		list.style.display = "";

		if (tb.getAttribute('_ONSEARCH') == 1) {
			if (tb.getAttribute('SEARCH_HIDE_GRP') == 1)
				tb.removeAttribute('SEARCH_HIDE_GRP');
		}
		else if (tb.getAttribute('HIDE_GRP') == 1) {	// to Expand
			tb.removeAttribute('HIDE_GRP');
		}
	}
}

function RptCollapse(grpID) {
	var tb = document.getElementById(grpID);
	var title = document.getElementById(grpID + '_title');
	var sign = document.getElementById(grpID + '_title_sign');
	var list = document.getElementById(grpID + '_list');

	if (title != null) {
		title.className = "lclsRptSubGrpTitleHide";
		sign.src = "<cfoutput>#request.webroot#MSupport/plus.gif</cfoutput>";
		list.style.display = "none";

		if (tb.getAttribute('_ONSEARCH') == 1)
			tb.setAttribute('SEARCH_HIDE_GRP', 1);
		else
			tb.setAttribute('HIDE_GRP', 1);
	}
}

function RptExpandAll(obj, grpbit) {
	var grpID;
	for (var g in obj) {
		if (g != "EOF") {
			grpID = g + "_" + grpbit;
			RptExpand(grpID);
		}
	}
}

function RptCollapseAll(obj, grpbit) {
	var grpID;
	for (var g in obj) {
		if (g != "EOF") {
			grpID = g + "_" + grpbit;
			RptCollapse(grpID);
		}
	}
}

function RptSearch(obj, grpbit) {
	var arg = arguments;
	var t = obj.value;
	var cnt, grpID, grp, itms, txt;
	var btn = document.getElementById('btnRptCancelSearch' + grpbit);

	if(t.length > 0) {
		t = t.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&");	// escape RegExp special character before use to search.
		btn.style.visibility = "visible";

		for (var i = 2; i < arg.length; i ++) {
			if (arg[i] != null)	{
				for (var g in arg[i]) {
					if (g != "EOF") {
						cnt = 0;
						grpID = g + "_" + grpbit;
						grp = document.getElementById(grpID);
						if (grp != null) {
							grp.setAttribute("_ONSEARCH", 1);
							itms = document.getElementById(grpID + "_list").firstChild.firstChild.childNodes;

							for (var x = 0; x < itms.length; x ++) {
								if (itms[x].tagName == 'LI') {
									txt = JSVCgetInnerText(itms[x]);
									if (txt == undefined) txt = itms[x].textContent;
									if (new RegExp(t, 'gi').test(txt)) {
										itms[x].style.display = '';
										cnt += 1;
									}
									else
										itms[x].style.display = 'none';
								}
							}

							if (cnt == 0)
								grp.style.display = 'none';
							else {
								grp.style.display = '';
								if (grp.getAttribute("SEARCH_HIDE_GRP") == null) {
									RptExpand(grpID);
								}
							}
						}
					}
				}
			}
		}
	}
	else {
		RptCancelSearch.apply(this, arg);
	}
}

function RptCancelSearch(obj, grpbit) {
	var arg = arguments;
	var cnt, grpID, grp, itms;
	var btn = document.getElementById('btnRptCancelSearch' + grpbit);

	obj.value = "";
	btn.style.visibility = "hidden";

	for (var i = 2; i < arg.length; i ++) {
		if (arg[i] != null)	{
			for (var g in arg[i]) {
				if (g != "EOF") {
					grpID = g + "_" + grpbit;
					grp = document.getElementById(grpID);
					if (grp != null) {
						if (grp.getAttribute("_ONSEARCH") != null) grp.removeAttribute("_ONSEARCH");
						itms = document.getElementById(grpID + "_list").firstChild.firstChild.childNodes;

						for (var x = 0; x < itms.length; x ++) {
							if (itms[x].tagName == 'LI') {
								itms[x].style.display = '';
							}
						}

						grp.style.display = '';
						if (grp.getAttribute("SEARCH_HIDE_GRP") != null) grp.removeAttribute("SEARCH_HIDE_GRP");
						if (grp.getAttribute("HIDE_GRP") == null)
							RptExpand(grpID);
						else
							RptCollapse(grpID);
					}
				}
			}
		}
	}
}
/********************************************************* NEW VERSION END *********************************************************/

// Javascript Solution for alignment of "col" tag no longer support by all browser including IE
function repopulateColGrpAlignment() {
	var tbs = document.getElementsByTagName('TABLE');
	var cols, rows, cells;

	for (var i = 0; i < tbs.length; i ++) {
		if (tbs[i].getElementsByTagName('colgroup').length > 0) {
			cols = tbs[i].getElementsByTagName('colgroup')[0].children;
			rows = tbs[i].rows;
			for (var j = 0; j < cols.length; j ++) {
				if (cols[j].className != '' && cols[j].className.toLowerCase() != 'clscoltext') {
					for (var k = 0; k < rows.length; k ++) {
						if (rows[k].cells[j] && rows[k].cells[j].align == '' && rows[k].cells[j].style.textAlign == '' && rows[k].cells[j].className == '') {
							if (cols[j].className.toLowerCase() == 'clscolmoney' || cols[j].className.toLowerCase() == 'clscolno')
								rows[k].cells[j].style.textAlign = 'right';
							else
								rows[k].cells[j].style.textAlign = 'center';
						}
					}
				}
			}
		}
	}
}
//AddOnloadCode('repopulateColGrpAlignment();');
<!---22480--->
function rptToExcel(divid,excelname) {
    var div = divid;
	if (excelname == undefined)
	  excelname = 'default';
	$(div).remove() <!---prevent script block from being written in excel--->
	var c=JSVCall(div);
	if(c!=null)
		JSVCopenWinPost(request.webroot+"index.cfm?fusebox=SVCdoc&fuseaction=dsp_exportinexcel&formobjname="+div+"&filename="+excelname+"&"+request.mtoken,"newwin",[[div,c.innerHTML]]);
}
<!---22480--->
</script>

<cffunction name="UDF_LogExecTime" output="no" returntype="numeric">
<cfargument name="usid" type="numeric">
<cfargument name="fusebox" type="string">
<cfargument name="fuseaction" type="string">
<cfargument name="form" type="struct">
<cfargument name="url" type="struct">
<cfargument name="attributes" type="struct">
<cfargument name="start_time" type="date">
<cfargument name="end_time" type="date">

<cfset var form_str="">
<cfset var url_str="">
<cfset var attributes_str="">
<cfset form_str&="<br>FORM:">
<cfset url_str&="<br>URL:">
<cfset attributes_str&="<br>ATTRIBUTES:">

<!--- Report run more than 15 seconds then log entry --->
<cfif NOT(DateDiff("s",TIME_START,TIME_END) GT 15)>
	<cfreturn 0>
</cfif>

<cfloop collection=#form# item=abc>
	<cfif UCase(abc) IS NOT "FIELDNAMES" AND LEN(abc) GT 0>
		<cfset sim=StructFind(form,abc)>
		<cfif IsSimpleValue(sim) IS true><cfset form_str&="@#abc#:#sim#, "><cfelse><cfset form_str&="@#abc#:(complex), "></cfif>
	</cfif>
</cfloop>
<cfloop collection=#url# item=abc>
	<cfif LEN(abc) GT 0>
		<cfset sim=StructFind(url,abc)>
		<cfif IsSimpleValue(sim) IS true><cfset url_str&="@#abc#:#sim#, "><cfelse><cfset url_str&="@#abc#:(complex), "></cfif>
	</cfif>
</cfloop>
<cfloop collection=#attributes# item=abc>
	<cfif LEN(abc) GT 0>
		<cfset sim=StructFind(attributes,abc)>
		<cfif IsSimpleValue(sim) IS true><cfset attributes_str&="@#abc#:#sim#, "><cfelse><cfset attributes_str&="@#abc#:(complex), "></cfif>
	</cfif>
</cfloop>

<cfif fuseaction IS "dsp_custom" AND Find("@RPTNAME:",url_str) GT 0>
	<cfset m = REMatch("@RPTNAME:(.+?)(\.cfm)?,", url_str)>
	<cfset rptname="#SESSION.VARS.GCOID#\"&REReplace(m[1],"@RPTNAME:(.+?)(\.cfm)?,","\1")>
<cfelse>
	<cfset rptname=fuseaction>
</cfif>

<CFQUERY name=q_trx datasource=#Request.SVCDSN#>
INSERT RPT0004 (iUSID,vaFUSEBOX,vaFUSEACTION,vaFORM,vaURL,vaATTRIBUTES,dtSTART,dtEND,vaRPTNAME)
VALUES (
	<cfqueryparam cfsqltype="cf_sql_integer" value="#usid#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#fusebox#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#fuseaction#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form_str#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#url_str#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes_str#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#start_time#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#end_time#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#rptname#">
)
</CFQUERY>
<cfreturn 1>
</cffunction>
