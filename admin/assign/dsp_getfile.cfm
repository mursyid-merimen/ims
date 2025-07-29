<!---
=========================== Modification Track ===============================
///////////////////////////////////////////////////////////////////////////////
Mike	22 NOV 2005 3:03PM	Added support for *.TIF and *.PDF view support [Line 55-58]
LISA	10 APR 2017 		#20668 optimization for multipage TIF to jpg extraction.
///////////////////////////////////////////////////////////////////////////////
--->
<cfsilent><cfmodule TEMPLATE="#request.apppath#services/CustomTags\SVCDISABLEDIRECT.cfm" Path="#GetCurrentTemplatePath()#">
    <CFSET RPT_GENERATION_MODE=0>
    <CFIF Not(Arguments.PRINTCTRLTYPE IS 1 OR Arguments.PRINTCTRLTYPE IS 2 OR Arguments.PRINTCTRLTYPE IS 3 OR Arguments.PRINTCTRLTYPE IS 4 OR Arguments.PRINTCTRLTYPE IS 5 OR Arguments.PRINTCTRLTYPE IS 6 OR Arguments.PRINTCTRLTYPE IS 7 OR Arguments.PRINTCTRLTYPE IS 8)>
        <CFSET Arguments.PRINTCTRLTYPE=0>
    </CFIF>
    <CFSET DOCCANRESETCOUNT=0><CFSET SECURITYBYPASS = false>
    <CFIF IsDefined("Arguments.BYPASSSEC") and Arguments.BYPASSSEC EQ 1>
        <cfset Request.DS.FN.SVCRequestIpChk()>
        <CFSET SECURITYBYPASS = true>
    </CFIF>
    <!--- for r&d, pls ask lisa --->
    <CFIF (IsDefined("Arguments.BYPASSSEC") and Arguments.BYPASSSEC EQ 1) OR (structKeyExists(session,"vars") and listfindnocase("MMANDREW,MMYWWONG",session.vars.userid) gt 0)> 
        <CFSET SECURITYBYPASS = true>
    </CFIF>
    <CFSET SECURITYBYPASS = true>
    <cfif NOT(IsDefined("Request.RPTGENERATIONMODE") AND Request.RPTGENERATIONMODE GT 0)>
        <!--- Not in generation mode so have more strigent security checking --->
        <CFIF Arguments.PARENTSEC_DOCID GT 0>
            <!--- Cannot use for PRINTCTRL --->
            <CFIF Arguments.PRINTCTRLTYPE GT 0>
                <cfthrow TYPE="EX_SECFAILED" ErrorCode="BADFILE" ExtendedInfo="Print control not available for embedded docs/imgs">
            </CFIF>
            <!--- Check parent's security context --->
    
    
            <cfif SECURITYBYPASS IS false>
              <cfmodule TEMPLATE="#request.apppath#services/CustomTags\SVCOBJSEC.cfm" DOCID=#Arguments.PARENTSEC_DOCID# COROLE=#Arguments.COROLE#>
            </CFIF>
    
            <cfstoredproc PROCEDURE="sspFDOCGetDocDetails" DATASOURCE=#Request.SVCDSN# RETURNCODE="YES">
            <cfprocparam TYPE=IN CFSQLTYPE=CF_SQL_INTEGER VALUE=#Arguments.PARENTSEC_DOCID# DBVARNAME=@ai_docid>
            <cfprocparam TYPE=IN CFSQLTYPE=CF_SQL_INTEGER NULL=YES VALUE=0 DBVARNAME=@ai_usid>
            <cfprocresult NAME=q_getfile RESULTSET=1>
            </cfstoredproc>
            <cfset RETROWS=CFSTOREDPROC.STATUSCODE>
            <cfif RETROWS LTE 0>
                <cfthrow TYPE="EX_DBERROR" ErrorCode="SVCDOC-GETFILE-GETDOCDTLS5(#RETROWS#)">
            </cfif>
            <CFIF BitAnd(q_getfile.idocstat,64) IS 0>
                <cfthrow TYPE="EX_SECFAILED" ErrorCode="BADFILE" ExtendedInfo="Embeded IMGTAG not activated for parent doc">
            </CFIF>
            <cfset FNAME=q_getfile.FILELOCPATH&q_getfile.FNAME>
            <!--- Read the parent's HTM to determine if the IMGTAG is really there --->
            <cffile action="READ" FILE="#fname#" VARIABLE=VARN>
            <cfif Find("<!--IMGTAG(#Arguments.DOCID#)-->",VARN) LTE 0>
                <cfthrow TYPE="EX_SECFAILED" ErrorCode="BADFILE" ExtendedInfo="Not an embedded image">
            </CFIF>
        <CFELSE>
            <cfquery NAME=q_doc DATASOURCE=#Request.SVCDSN#>
            SELECT TOP 1 idomainid,iobjid FROM fdoc3003 with (nolock) WHERE idocid=<cfqueryparam cfsqltype="CF_SQL_INTEGER" Value="#Arguments.DOCID#">
            </cfquery>
            
            <!--- Temporary Ugly code to enforce file access checking --->
            <cfif APPLICATION.APPMODE IS "CLAIMS" and q_doc.idomainid is 1 AND Arguments.corole IS 2>
                <cfmodule TEMPLATE="#request.apppath#services/CustomTags\SVCchkgrp.cfm" GrpList="54R">
                <cfif CANREAD IS 1>
                    <cfquery NAME=q_trx DATASOURCE=#Request.SVCDSN#>
                        SELECT 1 FROM FOBJ3006 a WITH (NOLOCK)
                        WHERE a.iDOMAINID=1 AND a.iOBJID=<cfqueryparam value="#q_doc.iobjid#" cfsqltype="CF_SQL_INTEGER"> AND a.iGCOID=<cfqueryparam value="#SESSION.VARS.GCOID#" cfsqltype="CF_SQL_INTEGER">
                            AND a.iUSID=<cfqueryparam value="#session.vars.usid#" cfsqltype="CF_SQL_INTEGER">
                    </cfquery>
                    <cfif q_trx.recordcount IS 0>
                        <cfthrow TYPE="EX_SECFAILED" ErrorCode="CANNOTREAD" ExtendedInfo="Personal Folders Only">
                    </cfif>
                </cfif>
            </cfif>
    
            <CFIF (q_doc.idomainid eq 9 or q_doc.idomainid IS 1) AND isDefined("SESSION.VARS.CASEUUID") and SESSION.VARS.CASEUUID neq "">
                <cfif q_doc.idomainid is 1>
                    <cfquery NAME=q_coid DATASOURCE=#Request.SVCDSN#>
                    SELECT TOP 1 icmtnotid, iCOID, vaUUID ,iinscoid FROM CMT0001_pro with (nolock) WHERE idomid=1 AND iobjid=<cfqueryparam cfsqltype="CF_SQL_INTEGER" Value="#q_doc.iobjid#">
                    </cfquery>
                    <cfset obj_cmtnotid=#q_coid.icmtnotid#>
    
                    <cfquery NAME=q_coid_trx8 DATASOURCE=#Request.SVCDSN#>
                    SELECT top 1 icoid, vaUUID FROM trx0008 with (nolock) 
                    WHERE icaseid=<cfqueryparam cfsqltype="CF_SQL_INTEGER" Value="#q_doc.iobjid#">
                    </cfquery>
    
                <cfelseif q_doc.idomainid is 9>
                    <cfquery NAME=q_coid DATASOURCE=#Request.SVCDSN#>
                    SELECT TOP 1 icmtnotid, iCOID, iinscoid, vaUUID FROM CMT0001 with (nolock) WHERE icmtnotid=<cfqueryparam cfsqltype="CF_SQL_INTEGER" Value="#q_doc.iobjid#">
                    UNION
                    SELECT TOP 1 icmtnotid, iCOID, iinscoid, vaUUID FROM CMT0001_pro with (nolock) WHERE icmtnotid=<cfqueryparam cfsqltype="CF_SQL_INTEGER" Value="#q_doc.iobjid#">
                    </cfquery>
                <cfelse>
                    <cfthrow type="EX_SECFAILED" Errorcode="BADPARAM">
                </cfif>
                <CFIF q_coid.recordcount GT 0 AND (q_coid.icoid eq 0 or q_coid.iinscoid eq 69)><!--- only retail portal user --->
                    <CFIF SESSION.VARS.CASEUUID eq q_coid.vauuid>
                        <CFSET SECURITYBYPASS = true>
                    </CFIF>
                </CFIF>
                <CFIF IsDefined("q_coid_trx8") and (q_coid_trx8.recordcount GT 0) AND (SESSION.VARS.CASEUUID eq q_coid_trx8.vauuid)>
                    <CFSET SECURITYBYPASS = true>
                </CFIF>
            <!--- EPL Document Direct Download for Controlled documets. --->
            <CFELSEIF application.appmode eq "EPL" and q_doc.idomainid eq 201 and isDefined("SESSION.VARS.POLGETUUID") and SESSION.VARS.POLGETUUID neq "">
                <cfquery NAME=q_coid DATASOURCE=#Request.SVCDSN#>
                select b.vaGUID from POL4004 a with (nolock) inner join POL4004_DOWNLOAD b with (nolock) on a.iPOLID=b.IPOLID
                where a.IPOLID=<cfqueryparam cfsqltype="CF_SQL_INTEGER" Value="#q_doc.iobjid#"> and b.siSTATUS=0
                </cfquery>
                <cfif q_coid.recordCount gt 0 and q_coid.vaGUID eq SESSION.VARS.POLGETUUID>
                    <CFSET SECURITYBYPASS = true>
                    <CFSET SESSION.VARS.POLGETUUID = "">
                </cfif>
            </cfif>
    
            <cfif SECURITYBYPASS IS false>
                <cfmodule TEMPLATE="#request.apppath#services/CustomTags\SVCOBJSEC.cfm" DOCID=#Arguments.DOCID# COROLE=#Arguments.COROLE# COSECPOS="#Arguments.cosecpos#">
            </cfif>
            <!---CFSET DOC_DOMAINID=MODRESULT.DOMAINID>
            <CFSET DOC_OBJID=MODRESULT.OBJID--->
        </CFIF>
        <!---CFIF MODRESULT.DOCSEC IS 2><CFSET ISCREATOR=1><CFELSE><CFSET ISCREATOR=0></CFIF--->
        <cfif SECURITYBYPASS IS false>
            <cfmodule TEMPLATE="#request.apppath#services/CustomTags\SVCchkgrp.cfm" GrpList="602R">
            <CFIF CanRead eq 1>
                <CFSET DOCCANRESETCOUNT=1>
            </CFIF>
        </cfif>
    <cfelse>
        <!---cfmodule TEMPLATE="#request.apppath#services/CustomTags\SVCOBJSEC.cfm"--->  <!--- DOC access checked in DOCGetDocDetails --->
        <CFSET ISCREATOR=1>
        <CFSET RPT_GENERATION_MODE=1>
        <CFSET Arguments.PRINTCTRLTYPE=0>
    </cfif>
    <CFIF Arguments.FTYPE IS 5>
        <!--- Preview existing letter --->
        <cfstoredproc PROCEDURE="sspFDOCGetDocDetails" DATASOURCE=#Request.SVCDSN# RETURNCODE="YES">
        <cfprocparam TYPE=IN CFSQLTYPE=CF_SQL_INTEGER VALUE=#Arguments.DOCID# DBVARNAME=@ai_docid>
        <cfprocparam TYPE=IN CFSQLTYPE=CF_SQL_INTEGER NULL=YES VALUE=0 DBVARNAME=@ai_usid>
        <cfprocparam TYPE=IN CFSQLTYPE=CF_SQL_INTEGER NULL=YES VALUE=0 DBVARNAME=@ai_corole>
        <cfprocparam TYPE=IN CFSQLTYPE=CF_SQL_INTEGER VALUE=1 DBVARNAME=@ai_gettext>
        <cfprocresult NAME=q_getfile RESULTSET=1>
        <cfprocresult NAME=q_gettext RESULTSET=2>
        </cfstoredproc>
        <cfset RETROWS=CFSTOREDPROC.STATUSCODE>
        <cfif RETROWS IS -3>
            <cfthrow TYPE="EX_SECFAILED" ErrorCode="CANNOTREAD">
        <cfelseif RETROWS LTE 0>
            <cfthrow TYPE="EX_DBERROR" ErrorCode="SVCDOC-GETFILE-GETDOCDTLS5(#RETROWS#)">
        </cfif>
        <CFIF q_getfile.DTFINALON IS NOT "" OR q_gettext.recordcount IS NOT 1 OR q_getfile.IFILEID IS NOT "">
            <cfthrow TYPE="EX_SECFAILED" ErrorCode="CANNOTREAD" ExtendedInfo="Not an unfinalized, previewable letter">
        </CFIF>
    <CFELSE>
    
        <cfstoredproc PROCEDURE="sspFDOCGetDocDetails" DATASOURCE=#Request.SVCDSN# RETURNCODE="YES">
        <cfprocparam TYPE=IN CFSQLTYPE=CF_SQL_INTEGER VALUE=#Arguments.DOCID# DBVARNAME=@ai_docid>
        <cfif SECURITYBYPASS IS false>
            <cfif Arguments.PRINTCTRLTYPE GT 0 AND NOT((IsDefined("SESSION.VARS.MMUSERID") AND SESSION.VARS.MMUSERID IS NOT "") OR SESSION.VARS.ORGTYPE EQ "D")>
                <cfprocparam TYPE=IN CFSQLTYPE=CF_SQL_INTEGER NULL=YES VALUE=0 DBVARNAME=@ai_usid>
                <cfprocparam TYPE=IN CFSQLTYPE=CF_SQL_INTEGER NULL=YES VALUE=0 DBVARNAME=@ai_corole>
                <cfprocparam TYPE=IN CFSQLTYPE=CF_SQL_INTEGER NULL=YES VALUE=0 DBVARNAME=@ai_gettext>
                <cfprocparam TYPE=IN CFSQLTYPE=CF_SQL_INTEGER NULL=YES VALUE=0 DBVARNAME=@ai_gettextinfo>
                <cfprocparam TYPE=IN CFSQLTYPE=CF_SQL_INTEGER VALUE=#Arguments.PRINTCTRLTYPE# DBVARNAME=@ai_printctrlread>
                <cfprocparam TYPE=IN CFSQLTYPE=CF_SQL_INTEGER VALUE=#session.vars.usid# DBVARNAME=@ai_printusid>
            <cfelseif Arguments.corole GT 0 AND NOT((IsDefined("SESSION.VARS.MMUSERID") AND SESSION.VARS.MMUSERID IS NOT "") OR SESSION.VARS.ORGTYPE EQ "D" OR Arguments.PARENTSEC_DOCID GT 0)>
                <cfprocparam TYPE=IN CFSQLTYPE=CF_SQL_INTEGER VALUE=#session.vars.usid# DBVARNAME=@ai_usid>
                <cfprocparam TYPE=IN CFSQLTYPE=CF_SQL_INTEGER VALUE=#Arguments.corole# DBVARNAME=@ai_corole>
            </CFIF>
        </cfif>
        <cfprocresult NAME=q_getfile RESULTSET=1>
        </cfstoredproc>
        <cfset RETROWS=CFSTOREDPROC.STATUSCODE>
        <cfif RETROWS IS -3>
            <cfthrow TYPE="EX_SECFAILED" ErrorCode="CANNOTREAD" ExtendedInfo="No read rights">
        <cfelseif RETROWS IS -4>
            <!--- <cfthrow TYPE="EX_SECFAILED" ErrorCode="CANNOTREAD" ExtendedInfo="Print-control count exceeded"> --->
        <cfelseif RETROWS LTE 0>
            <cfthrow TYPE="EX_DBERROR" ErrorCode="SVCDOC-GETFILE-GETDOCDTLS(#RETROWS#)">
        </cfif>
        <!--- TEMPORARY: For DOMAINID=1 only, check for permission ; UPDATED ON 10/08/2011: discard checking for doc/photo uploaded by the repairer for retail portal purpose ; UPDATED ON 19/08/2011: remove q_getfile.ICRTCOROLE checking --->
        <!---CFIF q_getfile.IDOMAINID IS 1 AND q_getfile.ICRTCOROLE NEQ 1 --->
            <CFIF q_getfile.IDOMAINID IS 1>
                <CFIF q_getfile.IDOCCLASSID IS 1 OR q_getfile.IDOCCLASSID IS 2>
                    <cfif ((structKeyExists(request,"SECURITYBYPASS") IS "YES" AND request.SECURITYBYPASS IS 1) OR (SECURITYBYPASS IS true))>
                        <!--- do nothing ... discard permission checking ... --->
                    <cfelse>
                        <cfmodule TEMPLATE="#request.apppath#services/CustomTags\SVCchkgrp.cfm" GrpList="113R">
                        <CFIF CanRead IS 1>
                            <cfthrow TYPE="EX_SECFAILED" ErrorCode="CANNOTREAD" ExtendedInfo="Access denied to Claim Documentation and Photos (permission setting)">
                        </CFIF>
                    </cfif>
                </CFIF>
            <cfelseif q_getfile.idomainid IS 2 AND q_getfile.idocdefid IS 983>
                <!--- restrict view sensitive document based on user permission (done by allan) --->
                <!--- tender bid letter (docdefid:983) --->
                <CFMODULE TEMPLATE="#request.apppath#services/CustomTags\SVCchkgrp.cfm" grplist="210R,204R,201R,216R" CHKREAD>
                <!--- allan: to check whether insurer has the right time to view the bid/ not allow insurer to view sealed bid --->
                <cfif BITAND(9,Arguments.corole) IS 0><!--- non-bidder (non original workshop as well) = insurer/adjuster --->
                    <cfquery NAME=q_tender DATASOURCE=#Request.SVCDSN#>
                    select tenderstat=a.sitenderstat from trx0070 a with (nolock) 
                    where a.itender=<cfqueryparam cfsqltype="CF_SQL_INTEGER" Value="#q_doc.iobjid#">
                    </cfquery>
                    <cfif q_tender.recordcount IS 0><cfthrow TYPE="EX_SECFAILED" ErrorCode="BADFILE" ExtendedInfo="Unable to identify tender case."></cfif>
                    <cfif q_tender.tenderstat GTE 30 AND q_tender.tenderstat LT 40><!--- still on bidding status ---><cfthrow TYPE="EX_SECFAILED" ErrorCode="BADFILE" ExtendedInfo="Sealed Bid - The bid is not opened yet."></cfif>
                </cfif>
            </CFIF>
    <!--- 	</CFIF> --->
    </CFIF>
    <cfif q_getfile.recordcount IS NOT 1>
        <cfthrow Type="EX_SECFAILED" ErrorCode="BADFILE">
    </cfif>
    <!--- Get image file: FTYPE=1 means thumbnail --->
    <cfif Arguments.FTYPE IS 1>
        <cfset FNAME=q_getfile.FILELOCPATH&q_getfile.THUMBFNAME>
    <cfelse>
        <cfset FNAME=q_getfile.FILELOCPATH&q_getfile.FNAME>
    </cfif>
    <CFIF Arguments.FTYPE IS NOT 5>
        <cfif Len(FNAME) LTE 0 OR NOT FileExists(FNAME)>
            <cfthrow Type="EX_SECFAILED" ErrorCode="MISSINGFILE" ExtendedInfo="DOCID:#Arguments.DOCID#" DETAIL="Please check this file : #FNAME#">
        </cfif>
        <!---CFSET destfile=FNAME--->
        <cfif Arguments.FTYPE IS 1>
            <cfset type="JPG">
        <cfelse>
            <cfset type=UCase(Trim(q_getfile.FILEEXT))>
        </cfif>
    </CFIF>
    
    <CFIF q_getfile.iCOHDRDEFHIDE eq -1>
        <cfset COHDRDEFHIDE = FALSE>
        <CFSET DEFLINES = 5>
    <CFELSE>
        <cfset COHDRDEFHIDE = TRUE>
        <CFSET DEFLINES = q_getfile.iCOHDRDEFHIDE>
    </CFIF>
    <!--- Remove new line character appended to end of file, to support AlternaTIFF viewer: http://livedocs.macromedia.com/coldfusion/6/CFML_Reference/Tags-pt118.htm --->
    
    <CFIF application.appmode eq "EPL" and isdefined("q_doc") and q_doc.idomainid eq 201><!---EPL: generate PDF for signing--->
        <cfquery NAME=q_docdtls DATASOURCE=#Request.SVCDSN#>
            SELECT top 1 g.vaparam
            FROM fdoc3003 c with (nolock)
            left join pol4004 h with (nolock) on c.iobjid=h.ipolid
            left join pole4002 g with (nolock) on g.idocdefid=c.idocdefid and g.vadoctitle=c.vadocdesc and g.iprodid=h.iprodid
            WHERE c.idocid=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.docid#">
        </cfquery>
    </CFIF>
    </cfsilent>
    <CFIF BitAnd(q_getfile.idocstat,16) IS 16 AND RPT_GENERATION_MODE IS 0>
        <!--- Print control section --->
        <CFIF Arguments.PRINTCTRLTYPE IS 0>
            <cfmodule TEMPLATE="#request.apppath#services/CustomTags\SVCHEADER.cfm" TITLE="#q_getfile.vaDOCDESC#" NOLAYOUT=1>
            <cfset ftype=4>
            <!--- No print-control-doctype: Ask for selection --->
            <div id=PrintCtrlDiv style=color:darkred;font-weight:bold;padding:2px align=center><cfoutput>#Server.SVClang("Print Control",8367)#</cfoutput></div>
            <table align=center border=1 style=text-align:center onmouseup="SVCDOCPrintResetSelect(event);">
            <CFOUTPUT query=q_getfile>
                <cfif DOCCANRESETCOUNT EQ 1 AND Arguments.FROMCTXMENU IS 1 AND
                        ((iORIGLEFT IS NOT "" and (iORIGLEFT gte 0) and (iORIGLEFT lt iDEFORIGCNT)) OR
                            (iDUPLEFT IS NOT "" and (iDUPLEFT gte 0) and (iDUPLEFT lt iDEFDUPCNT)) OR
                            (iTRILEFT IS NOT "" and (iTRILEFT gte 0) and (iTRILEFT lt iDEFTRICNT)) OR
                            (iQUADLEFT IS NOT "" and (iQUADLEFT gte 0) and (iQUADLEFT lt iDEFQUADCNT)) OR
                            (iNonNegoLEFT IS NOT "" and (iNonNegoLEFT gte 0) and (iNonNegoLEFT lt iDEFNonNegoCNT)) OR
                            (iCPYLEFT IS NOT "" and (iCPYLEFT gte 0) and (iCPYLEFT lt iDEFCPYCNT)) OR
                            (iQUINTLEFT IS NOT "" and (iQUINTLEFT gte 0) and (iQUINTLEFT lt iDEFQUINTCNT)) OR
                            (iSEXTLEFT IS NOT "" and (iSEXTLEFT gte 0) and (iSEXTLEFT lt iDEFSEXTCNT)))>
                    <cfset DocToReset = true>
                <cfelse>
                    <cfset DocToReset = false>
                </cfif>
            <tr><th>#Server.SVClang("Type",1632)#</th><th>#Server.SVClang("No. Left",12044)#</th><!---th>No. Max</th---><CFIF DocToReset><th>&nbsp;</th></cfif></tr>
            <CFIF iORIGLEFT IS NOT "">
                <tr><td><CFIF iORIGLEFT IS NOT 0><input type=button style=width:98% class=clsSVCButton onclick="var href1='#request.webroot#index.cfm?fusebox=SVCdoc&fuseaction=dsp_getfile&docid=#Arguments.docid#&corole=#Arguments.corole#&printctrltype=1&ftype=#ftype#&#request.mtoken#';try{SVCDOCPrintCtrlClk(event,this,href1)}catch(e){window.location.href=href1;}" value="#Server.SVClang("Original",8368)#"><CFELSE>#Server.SVClang("Original",8368)#</CFIF></td><td><CFIF iORIGLEFT LT 0>n/a<CFELSE>#iORIGLEFT#</CFIF></td><cfif DocToReset><td><cfif (iORIGLEFT gte 0) and (iORIGLEFT lt iDEFORIGCNT)><input type="checkbox" name="printreset" value="1" checked><cfelse>&nbsp;</cfif></td></cfif><!---td><CFIF iDEFORIGCNT IS -1>n/a<CFELSE>#iDEFORIGCNT#</CFIF></td---></tr>
            </CFIF>
            <CFIF iDUPLEFT IS NOT "">
                <tr><td><CFIF iDUPLEFT IS NOT 0><input type=button style=width:98% class=clsSVCButton onclick="var href1='#request.webroot#index.cfm?fusebox=SVCdoc&fuseaction=dsp_getfile&docid=#Arguments.docid#&corole=#Arguments.corole#&printctrltype=2&ftype=#ftype#&#request.mtoken#';try{SVCDOCPrintCtrlClk(event,this,href1)}catch(e){window.location.href=href1;}" value="#Server.SVClang("Duplicate",6895)#"><CFELSE>#Server.SVClang("Duplicate",6895)#</CFIF></td><td><CFIF iDUPLEFT LT 0>n/a<CFELSE>#iDUPLEFT#</CFIF></td><cfif DocToReset><td><cfif (iDUPLEFT gte 0) and (iDUPLEFT lt iDEFDUPCNT)><input type="checkbox" name="printreset" value="2" checked><cfelse>&nbsp;</cfif></td></cfif><!---td><CFIF iDEFDUPCNT IS -1>n/a<CFELSE>#iDEFDUPCNT#</CFIF></td---></tr>
            </CFIF>
            <CFIF iTRILEFT IS NOT "">
                <tr><td><CFIF iTRILEFT IS NOT 0><input type=button style=width:98% class=clsSVCButton onclick="var href1='#request.webroot#index.cfm?fusebox=SVCdoc&fuseaction=dsp_getfile&docid=#Arguments.docid#&corole=#Arguments.corole#&printctrltype=4&ftype=#ftype#&#request.mtoken#';try{SVCDOCPrintCtrlClk(event,this,href1)}catch(e){window.location.href=href1;}" value="#Server.SVClang("Triplicate",8369)#"><CFELSE>#Server.SVClang("Triplicate",8369)#</CFIF></td><td><CFIF iTRILEFT LT 0>n/a<CFELSE>#iTRILEFT#</CFIF></td><cfif DocToReset><td><cfif (iTRILEFT gte 0) and (iTRILEFT lt iDEFTRICNT)><input type="checkbox" name="printreset" value="8" checked><cfelse>&nbsp;</cfif></td></cfif><!---td><CFIF iDEFTRICNT IS -1>n/a<CFELSE>#iDEFTRICNT#</CFIF></td---></tr>
            </CFIF>
            <CFIF iQUADLEFT IS NOT "">
                <tr><td><CFIF iQUADLEFT IS NOT 0><input type=button style=width:98% class=clsSVCButton onclick="var href1='#request.webroot#index.cfm?fusebox=SVCdoc&fuseaction=dsp_getfile&docid=#Arguments.docid#&corole=#Arguments.corole#&printctrltype=5&ftype=#ftype#&#request.mtoken#';try{SVCDOCPrintCtrlClk(event,this,href1)}catch(e){window.location.href=href1;}" value="#Server.SVClang("Quadruplicate",17471)#"><CFELSE>#Server.SVClang("Quadruplicate",17471)#</CFIF></td><td><CFIF iQUADLEFT LT 0>n/a<CFELSE>#iQUADLEFT#</CFIF></td><cfif DocToReset><td><cfif (iQUADLEFT gte 0) and (iQUADLEFT lt iDEFQUADCNT)><input type="checkbox" name="printreset" value="16" checked><cfelse>&nbsp;</cfif></td></cfif><!---td><CFIF iDEFQUADCNT IS -1>n/a<CFELSE>#iDEFQUADCNT#</CFIF></td---></tr>
            </CFIF>
            <CFIF iCPYLEFT IS NOT "">
                <tr><td><CFIF iCPYLEFT IS NOT 0><input type=button style=width:98% class=clsSVCButton onclick="var href1='#request.webroot#index.cfm?fusebox=SVCdoc&fuseaction=dsp_getfile&docid=#Arguments.docid#&corole=#Arguments.corole#&printctrltype=3&ftype=#ftype#&#request.mtoken#';try{SVCDOCPrintCtrlClk(event,this,href1)}catch(e){window.location.href=href1;}" value="#Server.SVClang("Copy",8370)#"><CFELSE>#Server.SVClang("Copy",8370)#</CFIF></td><td><CFIF iCPYLEFT LT 0>n/a<CFELSE>#iCPYLEFT#</CFIF></td><cfif DocToReset><td><cfif (iCPYLEFT gte 0) and (iCPYLEFT lt iDEFCPYCNT)><input type="checkbox" name="printreset" value="4" checked><cfelse>&nbsp;</cfif></td></cfif><!---td><CFIF iDEFCPYCNT IS -1>n/a<CFELSE>#iDEFCPYCNT#</CFIF></td---></tr>
            </CFIF>
            <CFIF iNonNegoLEFT IS NOT "">
                <tr><td><CFIF iNonNegoLEFT IS NOT 0><input type=button style=width:98% class=clsSVCButton onclick="var href1='#request.webroot#index.cfm?fusebox=SVCdoc&fuseaction=dsp_getfile&docid=#Arguments.docid#&corole=#Arguments.corole#&printctrltype=6&ftype=#ftype#&#request.mtoken#';try{SVCDOCPrintCtrlClk(event,this,href1)}catch(e){window.location.href=href1;}" value="#Server.SVClang("Non-Negotiable",27494)#"><CFELSE>#Server.SVClang("Non-Negotiable",27494)#</CFIF></td><td><CFIF iNonNegoLEFT LT 0>n/a<CFELSE>#iNonNegoLEFT#</CFIF></td><cfif DocToReset><td><cfif (iNonNegoLEFT gte 0) and (iNonNegoLEFT lt iDEFNonNegoCNT)><input type="checkbox" name="printreset" value="32" checked><cfelse>&nbsp;</cfif></td></cfif></tr>
            </CFIF>
            <CFIF iQUINTLEFT IS NOT "">
                <tr><td><CFIF iQUINTLEFT IS NOT 0><input type=button style=width:98% class=clsSVCButton onclick="var href1='#request.webroot#index.cfm?fusebox=SVCdoc&fuseaction=dsp_getfile&docid=#Arguments.docid#&corole=#Arguments.corole#&printctrltype=7&ftype=#ftype#&#request.mtoken#';try{SVCDOCPrintCtrlClk(event,this,href1)}catch(e){window.location.href=href1;}" value="#Server.SVClang("Quintuplicate",0)#"><CFELSE>#Server.SVClang("Quintuplicate",0)#</CFIF></td><td><CFIF iQUINTLEFT LT 0>n/a<CFELSE>#iQUINTLEFT#</CFIF></td><cfif DocToReset><td><cfif (iQUINTLEFT gte 0) and (iQUINTLEFT lt iDEFQUINTCNT)><input type="checkbox" name="printreset" value="64" checked><cfelse>&nbsp;</cfif></td></cfif></tr>
            </CFIF>
            <CFIF iSEXTLEFT IS NOT "">
                <tr><td><CFIF iSEXTLEFT IS NOT 0><input type=button style=width:98% class=clsSVCButton onclick="var href1='#request.webroot#index.cfm?fusebox=SVCdoc&fuseaction=dsp_getfile&docid=#Arguments.docid#&corole=#Arguments.corole#&printctrltype=8&ftype=#ftype#&#request.mtoken#';try{SVCDOCPrintCtrlClk(event,this,href1)}catch(e){window.location.href=href1;}" value="#Server.SVClang("Sextuplicate",0)#"><CFELSE>#Server.SVClang("Sextuplicate",0)#</CFIF></td><td><CFIF iSEXTLEFT LT 0>n/a<CFELSE>#iSEXTLEFT#</CFIF></td><cfif DocToReset><td><cfif (iSEXTLEFT gte 0) and (iSEXTLEFT lt iDEFQUINTCNT)><input type="checkbox" name="printreset" value="128" checked><cfelse>&nbsp;</cfif></td></cfif></tr>
            </CFIF>
            <CFIF DocToReset>
                <tr><td colspan=3 align=right><a href="javascript:void(null);" onclick="SVCDOCPrintCtrlReset(event,this,#Arguments.docid#,#Arguments.corole#);return false;"><b>#Server.SVClang("Reset Counts",8371)#</b></a></td></tr>
            </CFIF>
            </table>
            </CFOUTPUT>
            <cfmodule TEMPLATE="#request.apppath#services/CustomTags\SVCFOOTER.cfm">
            <CFEXIT METHOD=EXITTEMPLATE>
        <CFELSE>
            <cffile action="READ" FILE="#fname#" VARIABLE=VARN>
    
                <CFIF Arguments.PRINTCTRLTYPE IS 1>
                    <CFSET CTRLTYPESTR="ORIG">
                <CFELSEIF Arguments.PRINTCTRLTYPE IS 2>
                    <CFSET CTRLTYPESTR="DUP">
                <CFELSEIF Arguments.PRINTCTRLTYPE IS 3>
                    <CFSET CTRLTYPESTR="COPY">
                <CFELSEIF Arguments.PRINTCTRLTYPE IS 4>
                    <CFSET CTRLTYPESTR="TRI">
                <CFELSEIF Arguments.PRINTCTRLTYPE IS 5>
                    <CFSET CTRLTYPESTR="QUAD">
                <CFELSEIF Arguments.PRINTCTRLTYPE IS 6>
                    <CFSET CTRLTYPESTR="NNEGO">
                <CFELSEIF Arguments.PRINTCTRLTYPE IS 7>
                    <CFSET CTRLTYPESTR="QUINT">
                <CFELSEIF Arguments.PRINTCTRLTYPE IS 8>
                    <CFSET CTRLTYPESTR="SEXT">
                </CFIF>
    
            <!--- Replace <!--PRNCTRL:DELETE--> in HTM files --->
            <CFSET startpos=FindNoCase("<!--PRNCTRL:DELETE-->",varn)>
            <CFLOOP CONDITION="startpos GT 0">
                <CFSET endpos=Find("<!--/PRNCTRL:DELETE-->",varn,startpos+1)>
                <CFIF endpos GT 0>
                    <CFSET varn=Left(varn,startpos-1) & Right(varn,Len(varn)-endpos-21)>
                </CFIF>
                <CFSET startpos=FindNoCase("<!--PRNCTRL:DELETE-->",varn,startpos+1)>
            </CFLOOP>
            <!--- Replace <!--PRNCTRL:ORIG:....--> in HTM files --->
            <CFSET startpos=FindNoCase("<!--PRNCTRL:#CTRLTYPESTR#:",varn)>
            <CFLOOP CONDITION="startpos GT 0">
                <CFSET endpos=Find("-->",varn,startpos+1)>
                <CFIF endpos GT 0>
                    <CFSET varn=Left(varn,startpos-1) & Mid(varn,startpos+13+Len(CTRLTYPESTR),endpos-startpos-13-Len(CTRLTYPESTR)) & Right(varn,Len(varn)-endpos-2)>
                </CFIF>
                <CFSET startpos=FindNoCase("<!--PRNCTRL:#CTRLTYPESTR#:",varn,startpos+1)>
            </CFLOOP>
            <CFIF Arguments.NOPRINTOPTIONS IS 0>
            <cfset PDFSAVEDOCID="">
            <cfif Arguments.PDFSAVEDOC IS 1>
                <cfset PDFSAVEDOCID=Arguments.DOCID>
            </cfif>
            <!---cfif ISCREATOR IS 1><!---COSECPOS IS q_getfile.ICRTCOSECPOS--->
                <cfmodule TEMPLATE="#request.apppath#services/CustomTags\SVCPRINTOPTIONS.cfm" SHOW=1 PDFSAVEDOCID=#PDFSAVEDOCID#>
            <cfelse--->
            <CFIF APPLICATION.APPMODE IS "CLAIMS" AND structKeyExists(APPLICATION, "APPLOCID") AND APPLICATION.APPLOCID NEQ 11>
                <cfmodule TEMPLATE="#request.apppath#services/CustomTags\SVCPRINTOPTIONS.cfm" SHOW=1 PDFSAVEDOCID=#PDFSAVEDOCID# COROLE=#Arguments.COROLE# COHDRDEFHIDE=#COHDRDEFHIDE# LINES=#DEFLINES# wkhtmltopdf=1>
            <cfelse>
                <cfmodule TEMPLATE="#request.apppath#services/CustomTags\SVCPRINTOPTIONS.cfm" SHOW=1 PDFSAVEDOCID=#PDFSAVEDOCID# COROLE=#Arguments.COROLE# COHDRDEFHIDE=#COHDRDEFHIDE# LINES=#DEFLINES#>
            </cfif>
            <!---/cfif--->
            </CFIF>
            <cfif q_getfile.DTFINALON IS ""><div align="center" style="color:darkred;font-weight:bold"><cfoutput>#Server.SVClang("Note: This document has not been finalised.",1600)#</cfoutput></div></cfif>
            <cfif q_getfile.DTREVOKEDON IS NOT ""><div align="center" style="color:red;font-weight:bold"><cfoutput>#Server.SVClang("THIS DOCUMENT HAS BEEN REVOKED.",1601)#</cfoutput></div></cfif>
    
            <!--- convert HTML to PDF and get it signed --->
            <cfif application.appmode eq "EPL" and q_doc.idomainid eq 201 and arguments.ftype eq 4 and not (isdefined('arguments.skippdfsign') and arguments.skippdfsign eq 1) and q_docdtls.vaparam eq "PDFSIGNUPONPRINT">
                <cfset genfile = APPLICATION.TMPDIR & createUUID() & ".PDF">
                <cfinvoke component="#Request.APPPATHCFC#services.cfc.EPLGenPDF" method="HTMtoPDF" content="#varn#" title="#q_getfile.VADOCDESC#" OUTPUTFILE="#genfile#" replaceImgPath="true" wkhtmltopdf=1 idocid="#q_getfile.idocid#" openfont="true">
    
                <cfmodule template="#Request.logpath#index.cfm" FUSEBOX="SVCdoc" FUSEACTION="ACT_DOCEDIT" NOHEADER
                DOMAINID="#q_getfile.idomainid#"
                OBJID="#q_getfile.iobjid#"
                LINKID="#q_getfile.iobjid#"
                DOCSTAT="3"
                DOCDESC="#q_getfile.VADOCDESC#"
                CRTCOROLE="#q_getfile.ICRTCOROLE#"
                DOCDEFID="#q_getfile.IDOCDEFID#"
                BCOREAD="#q_getfile.BCOREAD#"
                CRTCOID="#q_getfile.iCRTCOID#"
                CRTCOSECPOS="#q_getfile.ICRTCOSECPOS#"
                USID="#session.vars.usid#"
                COPYFILE="#genfile#"
                PRESERVE_ORIGINAL="0"
                DOCID="0"
                FILEEXT="PDF"
                >
                <cfset Arguments.DOCID=MODRESULT.DOCID>
                <cfset Arguments.ftype=2>
                <cfset type="PDF">
                <cfset DOCARR = arrayNew(1)>
                <cfset arrayAppend(DOCARR,Arguments.DOCID)>
                <cfmodule template="#Request.logpath#index.cfm" FUSEBOX=SVCdoc FUSEACTION=ACT_DOCSIGN NOHEADER
                DOMAINID=201 OBJID=#q_getfile.iobjid# DOCID_TOSIGN=#DOCARR# SIGN_TYPE=1 GCOID=#q_getfile.iCRTCOID# MERGEPDFSIGN=1>
    
                <cfquery name="q_hidetemppdf" datasource="#REQUEST.MICDSN#">
                    update fdoc3003 set sistatus=1 where idocid=<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.DOCID#">
                </cfquery>
                <cfif StructIsEmpty(MODRESULT.SIGNED_STRUCT) eq "YES">
                    Unable to sign PDF. Please try again later.
                    <cfexit METHOD=EXITTEMPLATE>
                <cfelse>
                    <cfstoredproc PROCEDURE="sspFDOCGetDocDetails" DATASOURCE=#Request.SVCDSN# RETURNCODE="YES">
                    <cfprocparam TYPE=IN CFSQLTYPE=CF_SQL_INTEGER VALUE=#Arguments.DOCID# DBVARNAME=@ai_docid>
                    <cfprocparam TYPE=IN CFSQLTYPE=CF_SQL_INTEGER NULL=YES VALUE=0 DBVARNAME=@ai_usid>
                    <cfprocresult NAME=q_getfile RESULTSET=1>
                    </cfstoredproc>
                    <cfset RETROWS=CFSTOREDPROC.STATUSCODE>
                    <cfif RETROWS LTE 0>
                        <cfthrow TYPE="EX_DBERROR" ErrorCode="SVCDOC-GETFILE-GETDOCDTLS5(#RETROWS#)">
                    </cfif>
    
                    <cfset FNAME=q_getfile.FILELOCPATH&q_getfile.FNAME>
                    <cfcontent reset="yes" type="application/pdf" file="#FNAME#" deletefile="yes">
                    <CFEXIT METHOD=EXITTEMPLATE>
                </cfif>
            <cfelse>
            <cfoutput>#varn#</cfoutput>
            <CFEXIT METHOD=EXITTEMPLATE>
            </cfif>
    
            <!---cfdocument name=pdfdoc format="PDF">
            <cfif q_getfile.DTFINALON IS ""><div align="center" style="color:darkred;font-weight:bold"><cfoutput>#Server.SVClang("Note: This document has not been finalised.",1600)#</cfoutput></div></cfif>
            <cfif q_getfile.DTREVOKEDON IS NOT ""><div align="center" style="color:red;font-weight:bold"><cfoutput>#Server.SVClang("THIS DOCUMENT HAS BEEN REVOKED.",1601)#</cfoutput></div></cfif>
            <CFOUTPUT>#varn#</CFOUTPUT>
            </cfdocument>
            <cfcontent reset="yes" type="application/pdf" variable="#pdfdoc#"--->
    
        </CFIF>
    </CFIF>
    <CFIF BitAnd(q_getfile.idocstat,64) IS 64>
        <cfif not isdefined("imgformat")><cfset imgformat="jpg"></cfif>
        <cffile action="READ" FILE="#fname#" VARIABLE=VARN>
        <!--- Replace all <!--IMGTAG(docid)--> in HTM file --->
        <cfset re="<!--IMGTAG\((\d+)\)-->">
        <cfset result=REMatch(re,varn)>
        <cfloop array=#result# index=x>
            <cfset curdocid=REReplace(x,re,"\1")>
            <CFMODULE TEMPLATE="#request.apppath#services/CustomTags\SVCgenimgtag.cfm" PARENTSEC_DOCID="#Arguments.DOCID#" DOCID="#curdocid#" COROLE="#Arguments.COROLE#" VARMODRESULT="MODRESULT" format="#imgformat#">
            <cfset varn=Replace(varn,x,MODRESULT.HTMLStr,"all")>
        </cfloop>
        <CFIF Arguments.NOPRINTOPTIONS IS 0>
            <cfset PDFSAVEDOCID="">
            <cfif Arguments.PDFSAVEDOC IS 1>
                <cfset PDFSAVEDOCID=Arguments.DOCID>
            </cfif>
            <cfmodule TEMPLATE="#request.apppath#services/CustomTags\SVCPRINTOPTIONS.cfm" PDFSAVEDOCID=#PDFSAVEDOCID# COROLE=#Arguments.COROLE# COHDRDEFHIDE=#COHDRDEFHIDE# LINES=#DEFLINES#>
        </CFIF>
        <cfif q_getfile.DTFINALON IS ""><div align="center" style="color:darkred;font-weight:bold"><cfoutput>#Server.SVClang("Note: This document has not been finalised.",1600)#</cfoutput></div></cfif>
        <cfif q_getfile.DTREVOKEDON IS NOT ""><div align="center" style="color:red;font-weight:bold"><cfoutput>#Server.SVClang("THIS DOCUMENT HAS BEEN REVOKED.",1601)#</cfoutput></div></cfif>
        <cfoutput>#varn#</cfoutput>
        <CFEXIT METHOD=EXITTEMPLATE>
    </CFIF>
    <cfif Arguments.FTYPE IS 4 OR Arguments.FTYPE IS 5>
        <!--- Type 4: View as HTM with print options --->
        <!--- Type 5: View draft as HTM with print options --->
        <CFIF NOT BitAnd(q_getfile.idocstat,32) IS 32>
            <cfif NOT(IsDefined("Request.RPTGENERATIONMODE") AND Request.RPTGENERATIONMODE GT 0)>
                <CFIF Arguments.NOPRINTOPTIONS IS 0>
                <cfset PDFSAVEDOCID="">
                <cfif Arguments.PDFSAVEDOC IS 1>
                    <cfset PDFSAVEDOCID=Arguments.DOCID>
                </cfif>
                <!---cfif ISCREATOR IS 1><!---COSECPOS IS q_getfile.ICRTCOSECPOS--->
                    <cfmodule TEMPLATE="#request.apppath#services/CustomTags\SVCPRINTOPTIONS.cfm" SHOW=1 PDFSAVEDOCID=#PDFSAVEDOCID#>
                <cfelse--->
                    <cfmodule TEMPLATE="#request.apppath#services/CustomTags\SVCPRINTOPTIONS.cfm" SHOW=1 PDFSAVEDOCID=#PDFSAVEDOCID# COROLE=#Arguments.COROLE# COHDRDEFHIDE=#COHDRDEFHIDE# LINES=#DEFLINES#>
                <!---/cfif--->
                </CFIF>
                <cfif q_getfile.DTFINALON IS ""><div align="center" style="color:darkred;font-weight:bold"><cfoutput>#Server.SVClang("Note: This document has not been finalised.",1600)#</cfoutput></div></cfif>
                <cfif q_getfile.DTREVOKEDON IS NOT ""><div align="center" style="color:red;font-weight:bold"><cfoutput>#Server.SVClang("THIS DOCUMENT HAS BEEN REVOKED.",1601)#</cfoutput></div></cfif>
            </cfif>
            <CFIF Arguments.FTYPE IS 5>
                <cfmodule TEMPLATE="#request.apppath#services/CustomTags\SVCPRINTHEADER.cfm" TITLE="#q_getfile.VADOCDESC#"><div class=clsSVCFCKArea><cfoutput>#q_gettext.txtFILE#</cfoutput></div></body></html>
            <CFELSE>
                <cffile action="READ" FILE="#fname#" VARIABLE=varn>
                <cfset varn = rereplacenocase(varn,'<title>([^<])*</title>','<title>#q_getfile.vaDOCDESC#</title>','one')>
                <CFIF isDefined("arguments.NOHEAD") AND arguments.NOHEAD is true>
                    <!--- #24301: [SG] TMiS - WiCA - Hide company header when export template to external email --->
                    <cfset varn = rereplacenocase(varn,'(?i)id=[\"\'']*COHEADER[\"\'']*','id="COHEADER" style=display:none','one')>
                </CFIF>
                <cfoutput>#varn#</cfoutput>
                <CFSET varn="">
            </CFIF>
        <CFELSE>
            <cffile action="read" file="#FNAME#" variable="FILEVAR" charset="UTF-16">
            <cfcontent reset="yes"><cfif q_getfile.DTREVOKEDON IS NOT ""><div align="center" style="color:red;font-weight:bold"><cfoutput>#Server.SVClang("THIS DOCUMENT HAS BEEN REVOKED.",1601)#</cfoutput></div></cfif><cfoutput>#FILEVAR#</cfoutput>
        </CFIF>
        <cfexit METHOD=EXITTEMPLATE>
    <CFELSE>
        <!---cfset destfile=GetTempFile(Application.TMPDIR,"ATT")>
        <cffile action="COPY" source="#FNAME#" destination="#destfile#">
        <cfif Arguments.FTYPE IS 1 or Arguments.FTYPE IS 2>
            <!--- Type 1-2: View using viewer/or other recommended tools --->
            <cfif type IS "JPG" OR type IS "JPE">
            <cfcontent reset="yes" type="image/jpeg" file="#destfile#"  deletefile="Yes">
            <cfelseif type IS "GIF">
            <cfcontent reset="yes" type="image/gif" file="#destfile#" deletefile="Yes">
            <cfelseif type IS "PNG">
            <cfcontent reset="yes" type="image/x-png" file="#destfile#" deletefile="Yes">
            <cfelseif type IS "TIF">
            <cfcontent reset="yes" type="image/tiff" file="#destfile#" deletefile="Yes">
            <cfelseif type IS "PDF">
            <cfcontent reset="yes" type="application/pdf" file="#destfile#" deletefile="Yes">
            <cfelse>
            <cfcontent reset="yes" type="text/plain" file="#destfile#" deletefile="Yes">
            </CFIF>
        <cfelse>
            <!--- Other file types: Force download --->
            <cfheader name="Content-Disposition" value="attachment;filename=#q_getfile.VADOCDESC#.#type#">
            <cfcontent reset="yes" type="application/download" file="#destfile#" deletefile="Yes"> <!---  deletefile="Yes" --->
        </cfif--->
    
        <CFIF StructKeyExists(Request.DS.FDOC_DOCDEFS,q_getfile.IDOCDEFID)>
            <CFSET LTRDOC_OBJ=StructFind(Request.DS.FDOC_DOCDEFS,q_getfile.IDOCDEFID)>
        </CFIF>
        <CFIF IsDefined("LTRDOC_OBJ") AND LTRDOC_OBJ.DESC EQ q_getfile.VADOCDESC AND LTRDOC_OBJ.LID GT 0>
            <CFSET DSC=Server.SVClang(LTRDOC_OBJ.DESC,LTRDOC_OBJ.LID)>
        <CFELSE>
            <CFSET DSC=q_getfile.vaDOCDESC>
        </CFIF>
        <CFIF IsDefined("Arguments.Prefix") AND Arguments.Prefix NEQ "">
            <CFSET DSC = Arguments.Prefix & '_' & DSC>
        </CFIF>
        <CFSET DownloadFileName=REReplaceNoCase(DSC,"[\/\\\:\*\?\""\<\>\|]","","ALL")>
        <cfif DownloadFileName IS "">
            <cfset DownloadFileName="Unnamed">
        </cfif>
        <cfset DownloadFileName&=".#type#">
    
        <cfif Arguments.FTYPE IS 1 or Arguments.FTYPE IS 2>
            <!--- get PDF signed --->
            <cfif application.appmode eq "EPL" and q_doc.idomainid eq 201 and type eq "PDF" and (q_getfile.VADOCDESC eq "PDFSIGNUPONPRINT" OR q_docdtls.vaparam eq "PDFSIGNUPONPRINT")>
                <cfif isdefined('arguments.skippdfsign') and arguments.skippdfsign eq 1>
                    <cfquery name="q_hidetemppdf" datasource="#REQUEST.MICDSN#">
                        update fdoc3003 set sistatus=1 where idocid=<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.DOCID#">
                    </cfquery>
                    <cfcontent reset="yes" type="application/pdf" file="#FNAME#" deletefile="no">
                <cfelse>
                <cfset DOCARR = arrayNew(1)>
                <cfset arrayAppend(DOCARR,Arguments.DOCID)>
                <cfmodule template="#Request.logpath#index.cfm" FUSEBOX=SVCdoc FUSEACTION=ACT_DOCSIGN NOHEADER
                DOMAINID=201 OBJID=#q_getfile.iobjid# DOCID_TOSIGN=#DOCARR# SIGN_TYPE=3 GCOID=#q_getfile.iCRTCOID# MERGEPDFSIGN=1>
    
                <cfif StructIsEmpty(MODRESULT.SIGNED_STRUCT) eq "YES">
                    Unable to sign PDF. Please try again later.
                    <cfexit METHOD=EXITTEMPLATE>
                <cfelse>
                    <cfstoredproc PROCEDURE="sspFDOCGetDocDetails" DATASOURCE=#Request.SVCDSN# RETURNCODE="YES">
                    <cfprocparam TYPE=IN CFSQLTYPE=CF_SQL_INTEGER VALUE=#MODRESULT.SIGNED_STRUCT[Arguments.DOCID]# DBVARNAME=@ai_docid>
                    <cfprocparam TYPE=IN CFSQLTYPE=CF_SQL_INTEGER NULL=YES VALUE=0 DBVARNAME=@ai_usid>
                    <cfprocresult NAME=q_getfile RESULTSET=1>
                    </cfstoredproc>
                    <cfset RETROWS=CFSTOREDPROC.STATUSCODE>
                    <cfif RETROWS LTE 0>
                        <cfthrow TYPE="EX_DBERROR" ErrorCode="SVCDOC-GETFILE-GETDOCDTLS5(#RETROWS#)">
                    </cfif>
                    <cfquery name="q_hidetemppdf" datasource="#REQUEST.MICDSN#">
                        update fdoc3003 set sistatus=1 where idocid=<cfqueryparam cfsqltype="cf_sql_integer" value="#MODRESULT.SIGNED_STRUCT[Arguments.DOCID]#">
                    </cfquery>
                    <cfset FNAME=q_getfile.FILELOCPATH&q_getfile.FNAME>
                    <cfcontent reset="yes" type="application/pdf" file="#FNAME#" deletefile="no">
                </cfif>
                </cfif>
            <cfelse>
                <!--- Type 1-2: View using viewer/or other recommended tools --->
                <cfheader name="Content-Disposition" value="inline;filename=""#DownloadFileName#""" charset="utf-8"><!--- Redmine 4469 --->
                <cfif type IS "JPG" OR type IS "JPE" OR type IS "JPEG">
                    <cfcontent reset="yes" type="image/jpeg" file="#FNAME#" deletefile="no">
                <cfelseif type IS "GIF">
                    <cfcontent reset="yes" type="image/gif" file="#FNAME#" deletefile="no">
                <cfelseif type IS "PNG">
                    <cfcontent reset="yes" type="image/x-png" file="#FNAME#" deletefile="no">
                <cfelseif type IS "TIF" or type IS "TIFF">
                    <cfcontent reset="yes" type="image/tiff" file="#FNAME#" deletefile="no">
                <cfelseif type IS "PDF">
                    <cfcontent reset="yes" type="application/pdf" file="#FNAME#" deletefile="no">
                <cfelse>
                    <cfcontent reset="yes" type="text/plain" file="#FNAME#" deletefile="no">
                </CFIF>
            </cfif>
        <cfelseif Arguments.FTYPE is 6><!--- for the signature viewer iframe --->
             <cffile action="read" file="#FNAME#" variable="FILEVAR" charset="UTF-16">
            <cfcontent reset="yes"><cfoutput>#FILEVAR#</cfoutput>
        <cfelse>
            <!--- Other file types: Force download --->
            <cfheader name="Content-Disposition" value="attachment;filename=""#DownloadFileName#"";filename*=UTF-8''#urlEncodedFormat(DownloadFileName)#;" charset="utf-8"><!--- Redmine 4469 --->
            <cfcontent reset="yes" type="application/download" file="#FNAME#" deletefile="no">
        </cfif>
    
    </CFIF>