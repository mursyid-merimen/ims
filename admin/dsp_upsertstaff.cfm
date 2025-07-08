<!---
Notes:

Modification on Submit Entry part - added checking for checked box - Kian Yee - April 2008

--->
<script>
var request=new Object();
<CFOUTPUT>
request.apppath="#request.apppath#";
request.approot="#request.approot#";
</CFOUTPUT>
sysdt=new Date();
</script>
<CFMODULE TEMPLATE="#request.apppath#services/CustomTags/SVCaddfile.cfm" FNAME="JQUERY">
<CFMODULE TEMPLATE="#request.apppath#services/CustomTags/SVCaddfile.cfm" FNAME="SVCMAIN">



<!--- Debugger here --->
<!--- <CFMODULE TEMPLATE="#request.apppath#services/CustomTags/SVCaddfile.cfm" FNAME="SVCCAL"> --->
<!--- 
<CFMODULE TEMPLATE="#request.apppath#services/CustomTags/SVCaddfile.cfm" FNAME="SVCCSS"> --->

<!--- <cfmodule TEMPLATE="#request.apppath#services/CustomTags/SVCADDFILE.cfm" FNAME="SVCMAIN"> --->
	<!--- <cfmodule TEMPLATE="#request.apppath#services/CustomTags/SVCADDFILE.cfm" FNAME="TOOLBAR"> --->
<!--- <cfmodule TEMPLATE="#request.apppath#services/CustomTags\SVCDISABLEDIRECT.cfm" Path="#GetCurrentTemplatePath()#">
<cfmodule TEMPLATE="#request.apppath#services/CustomTags\SVCurlback.cfm" NEW>  --->
<!--- begin : validation checking --->





<cfif IsDefined("Attributes.IUSID") OR IsDefined("Attributes.USERID")>
	<cfset mode=1><!--- edit --->
<cfelse>
	<cfset mode=0><!--- new --->
</cfif>

<!--- #19393 --->
<cfset speciallogout = false>

<cfif NOT IsDefined("Attributes.COID")>
	<cfif IsDefined("SESSION.VARS.ORGID")>
		<cfif SESSION.VARS.ORGTYPE IS NOT "D">
			<cfset Attributes.COID=SESSION.VARS.ORGID>
		<cfelse>
			<cfset Attributes.COID=0>
		</cfif>
	<cfelse>
		<cfthrow TYPE="EX_SECFAILED" ErrorCode="NOLOGIN">
	</cfif>
</cfif>
<cfif Not IsDefined("Attributes.COID")>
	<cfif Not IsDefined("SESSION.VARS.ORGID")>
		<cfthrow TYPE="EX_SECFAILED" ErrorCode="NOLOGIN">
	</cfif>
	<cfset Attributes.COID=SESSION.VARS.ORGID>
</cfif>



<cfif mode IS 1><!--- edit mode --->
	<cfquery name="q_co" datasource=#Request.MTRDSN#>
	SELECT a.igcoid, iCOID=a.iCOID,a.siCOTYPEID,a.iSUBCOTYPEFLAG,a.vaCONAME,a.vaCOBRNAME,siESOURCE=IsNull(a.siESOURCE,0),b.vaUSID,b.iUSID,a.siFRANCHISE,a.vaFINCONAME,a.iGCOID,
	hq.iPWDMAXATTEMPTSTOT,hq.iPWDMAXATTEMPTS,iPWDSTRENGTHMASK=IsNull(a.iPWDSTRENGTHMASK,0),a.iLOCID,
	MINSDIFF=CASE WHEN b.dtPWDATTEMPT>IsNull(b.dtLASTLOGON,'1900/01/01') THEN 30-datediff(minute,b.dtPWDATTEMPT,getdate()) ELSE 0 END,a.siFRANCHISE,b.vasesscode,a.siNOCONCTYPE
	,DATECREATED=b.dtCRTON,DATEEND=b.dtUSERENDDATE,hq_iPWDSTRENGTHMASK=IsNull(hq.iPWDSTRENGTHMASK,0)
	FROM SEC0005 a WITH (NOLOCK)
	JOIN SEC0005 hq WITH (NOLOCK) ON a.iGCOID=hq.iCOID
	,SEC0001 b WITH (NOLOCK) WHERE
	a.iCOID=b.iCOID <CFIF IsDefined("Attributes.IUSID")> AND b.iUSID=<cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.IUSID#"><CFELSE>AND b.vaUSID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Attributes.USERID#"></CFIF>
	</cfquery>
	<cfif q_co.recordcount IS NOT 1><cfthrow TYPE="EX_SECFAILED" ErrorCode="BADCO"></cfif>
	<CFSET LOCID=q_co.iLOCID>
	<CFSET Attributes.IUSID=q_co.iUSID>
	<CFSET Attributes.USERID=q_co.vaUSID>
	<!--- <cfmodule TEMPLATE="#Request.LOGPATH#CustomTags\CHKCASE.cfm" CHKCOID=1 COID=#q_co.iCOID#> --->
	<cfset USER_ICOID=#q_co.icoid#>
	<cfset USER_IGCOID=#q_co.igcoid#>
	<cfset USER_COTYPEID=#q_co.siCOTYPEID#>
	<cfset ESOURCE=q_co.siESOURCE>
	<cfoutput>
	<h3 align=center class=clsColorNote>#Server.SVClang("User Profile",2257)# - #UCase(Attributes.USERID)# (#q_co.vaCOBRNAME#)</h3>
	</cfoutput>
	<cfif q_co.siNOCONCTYPE eq 1 and bitAND(q_co.iPWDSTRENGTHMASK,32) gt 0>
		<cfset speciallogout = true>
	</cfif>
<cfelse><!--- new mode --->
	<cfif NOT (IsDefined("Attributes.COID") AND attributes.coid GT 0)><cfthrow TYPE="EX_SECFAILED" ErrorCode="BADPARAM"></cfif>
	<!--- <cfmodule TEMPLATE="#Request.LOGPATH#CustomTags\CHKCASE.cfm" ChkCoID=1 COID="#Attributes.COID#"> --->
	<cfquery name="q_co" datasource=#Request.MTRDSN#>
	SELECT a.igcoid, a.iCOID,a.siCOTYPEID,a.iSUBCOTYPEFLAG,a.vaCONAME,a.vaCOBRNAME,siESOURCE=IsNull(a.siESOURCE,0),a.siFRANCHISE,a.vaFINCONAME,a.iGCOID,
	hq.iPWDMAXATTEMPTSTOT,hq.iPWDMAXATTEMPTS,iPWDSTRENGTHMASK=IsNull(a.iPWDSTRENGTHMASK,0),a.iLOCID,
	MINSDIFF=NULL,hq_iPWDSTRENGTHMASK=IsNull(hq.iPWDSTRENGTHMASK,0)
	FROM SEC0005 a WITH (NOLOCK)
	JOIN SEC0005 hq WITH (NOLOCK) ON a.iGCOID=hq.iCOID
	WHERE a.iCOID=<cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.coid#">
	</cfquery>
	<cfif q_co.recordcount IS NOT 1><cfthrow TYPE="EX_SECFAILED" ErrorCode="BADCO"></cfif>
	<cfset Attributes.USERID=""><CFSET Attributes.IUSID=0><cfset ESOURCE=q_co.siESOURCE>
	<CFSET LOCID=q_co.iLOCID>
	<cfset USER_ICOID=#attributes.coid#>
	<cfset USER_IGCOID=#q_co.igcoid#>
	<cfset USER_COTYPEID=#q_co.siCOTYPEID#>
	<cfoutput>
	<h3 align=center class=clsColorNote>#Server.SVClang("Create New User",1822)# (#q_co.vaCOBRNAME#)</h3>
	</cfoutput>
</cfif>
<CFPARAM NAME=Attributes.DUPLICATE DEFAULT=0>
<CFPARAM NAME=Attributes.USID DEFAULT=0>

<CFIF speciallogout><!--- #19393: [SG] GIA - Accident Reporting - Disable concurrent user login --->
	<script>
	function logout()
	{
		<cfoutput>
		document.location.href= request.webroot+"index.cfm?fusebox=SVCsec&fuseaction=act_sesslogout&loguotusid=#Attributes.IUSID#&USERID=#Attributes.USERID#&#newurlback#&"+request.mtoken;
		</cfoutput>
	}
	</script>

	<!--- we have to put it here as well, to force vaSESSCODE to be empty - when user attempts to log in, the same code below will run. --->
	<!---cfset sessionTracker = createObject("java","coldfusion.runtime.SessionTracker")/>
	<cfset sessArr = StructFindValue( sessionTracker.getSessionCollection( application.applicationName ), q_co.vasesscode , "one")>
	<cfif arrayLen(sessArr) eq 0><!--- session no longer valid, blank out vasesscode in sec0001. --->
		<CFSTOREDPROC PROCEDURE="sspFSECUserLogout" DATASOURCE="#Request.MTRDSN#" RETURNCODE="YES">
		<CFPROCPARAM TYPE="IN" DBVARNAME=@iUSID VALUE="#Attributes.IUSID#" CFSQLTYPE="CF_SQL_INTEGER">
		<CFPROCPARAM TYPE="IN" DBVARNAME=@vaSESSCODE VALUE="" CFSQLTYPE="CF_SQL_VARCHAR">
		<CFPROCPARAM TYPE="IN" DBVARNAME=@siIGNORELAST VALUE="1" CFSQLTYPE="CF_SQL_INTEGER">
		</CFSTOREDPROC>
		<cfset q_co.vasesscode = "">
	</cfif--->
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


<cfoutput>
<br>

FROM_ICOID:<cfdump var="#FROM_ICOID#"><br>
FROM_IGCOID:<cfdump var="#FROM_IGCOID#"><br>
FROM_COTYPEID:<cfdump var="#FROM_COTYPEID#"><br>
ORGTYPE:<cfdump var="#SESSION.VARS.ORGTYPE#"><br>
iUSID:<cfdump var="#Attributes.IUSID#"><br>
MODE:<cfdump var="#mode#"><br>
</cfoutput>


<cfif USER_IGCOID IS FROM_IGCOID><!--- user from the same gco branch --->
	<cfmodule TEMPLATE="#Request.LOGPATH#CustomTags\CHKCASE.cfm" ChkCoID=1 COID="#USER_ICOID#">
<cfelse><!--- from different cotype? --->
	<cfif FROM_COTYPEID IS 2 AND USER_COTYPEID IS 6><!--- insurer creating/modify agent/broker user ID --->
		<cfquery name="q_colink" datasource=#Request.MTRDSN#>
		SELECT counter=count(*) FROM fsec0035 with (nolock)
		WHERE iowncoid=<cfqueryparam cfsqltype="cf_sql_integer" value="#FROM_ICOID#"> AND ilinkcoid=<cfqueryparam cfsqltype="cf_sql_integer" value="#USER_ICOID#"> AND sicotypeid=<cfqueryparam cfsqltype="cf_sql_smallint" value="#USER_COTYPEID#"> and sistatus=0
		</cfquery>
		<cfif NOT(q_colink.recordcount IS 1 AND q_colink.counter GT 0)><cfthrow TYPE="EX_SECFAILED" ErrorCode="BADCO"></cfif>
		<cfmodule TEMPLATE="#Request.LOGPATH#CustomTags\CHKCASE.cfm" ChkCoID=1 COID="#FROM_ICOID#">
		<cfmodule TEMPLATE="#request.apppath#services/CustomTags\SVCchkgrp.cfm" GRPLIST="67W" CHKWRITE><!--- administration on agent/broker registration --->
		<CFSET AttrVal=Request.DS.FN.SVCgetExtAttrLogic("COADMIN",0,"COATTR124",10,request.ds.co[FROM_ICOID].gcoid)>
		<CFIF NOT(isNumeric(AttrVal) AND BITAND(AttrVal,1) IS 1)><cfthrow TYPE="EX_SECFAILED" ErrorCode="BADPARAM"><!--- can't create user because module has been deactivated ---></cfif>
	<cfelse>
		<cfthrow TYPE="EX_SECFAILED" ErrorCode="BADPARAM"><!--- any other module that using attributes.FROMCOID? has no ideal where it comes from ... --->
	</cfif>
</cfif>

<!--- end : validation checking --->


<CFSET li_cotypeid=q_co.siCOTYPEID>
<CFSET li_subcotypeid=q_co.iSUBCOTYPEFLAG>
<CFSET ls_coname="#q_co.vaCONAME# (#q_co.vaCOBRNAME#)">
<cfset REPFINANCE=q_co.vaFINCONAME>
<cfset REPFRANCHISE=q_co.siFRANCHISE>
<cfset CURGCOID=q_co.iGCOID>

<!---REMARKS: Special 3 char check for MSIG Thai--->
<cfif CURGCOID eq 1100001>
	<cfset userminchar=3>
<cfelse>
	<cfset userminchar=5>
</cfif>

<cfparam name="attributes.coid" default=#q_co.iCOID#>
<cfif SESSION.VARS.ORGTYPE IS "D">
	<cfparam NAME="Attributes.FROMCOID" DEFAULT=#attributes.coid#>
<cfelse>
	<cfparam NAME="Attributes.FROMCOID" DEFAULT=#session.vars.orgid#>
</cfif>

<!--- #46290 --->
<CFSET AttrSAPIVal=val(Request.DS.FN.SVCgetExtAttrLogic("COADMIN",0,"COATTR-SAPI-MODULES",10,CURGCOID))>

<script>
function FormatUser(obj,minlength)
{
	var txt,msg;
	msg="";
	txt=obj.value;
	txt=txt.replace(/\W/gi,'').toUpperCase();
	if(txt.length!=obj.value.length)
		msg=msg+JSVClang("Only alphanumeric characters are allowed in User ID (A-Z, 0-9,_ or -). ",6783);
	if(txt!="" && minlength>0 && txt.length<minlength)
		msg=msg+JSVClang("Minimum length for User ID is {0} characters. ",35977,0,minlength);
	if(msg!="")
	{
		alert(msg);
		obj.value="";
	}
	DoReq(obj);
}
function SetApprvLimit(obj)
{
	if(parseInt(obj.value)=="-1")
		DoReq(obj)
	else
		JSVCCurr(obj);
}

function getusrcode(obj)
{
	var txt;
	usrcode=JSVCall("UsrCode");
	usrcode.setAttribute('CHKREQUIRED',1);DoReq(usrcode);
	txt=obj.value;
	if (txt.indexOf('@')>0)
	{
		txt=obj.value;
		usrcode.value=txt.substring(0,txt.indexOf("@"));
	}
}

function preview(obj)
{
	file=obj.value;
	extension=file.slice(file.lastIndexOf(".")+1).toUpperCase();
	if(extension=="JPEG" || extension=="JPG" || extension=="PNG" || extension=="JPE" || extension=="GIF")
	{
		newimg=new Image();
		obj.setAttribute("CURIMG",newimg);
		newimg.setAttribute("CURFILE",obj);

		if (window.FileReader) {
			var	oFReader = new window.FileReader()

			oFReader.onload = function (oFREvent) {
				newimg.src = oFREvent.target.result;
			};

			oFReader.readAsDataURL(obj.files[0]);
			newimg.setAttribute("ASSOCNAME", 'img_' +obj.name);
		}
		newimg.onload=loadPreview;
	}
	else if(file != "")
	{
		alert(JSVClang("Invalid file format. Only .jpeg/.jpg/.gif/.jpe is allowed.",25134));
		document.getElementById("imgPreview").innerHTML="";
		obj.value="";
	}
}

function loadPreview(e)
{
	var obj,newobj,objnext,fname,idx,ext,axsize,event,filesize;
	if (e) { // fix for firefox
		obj=document.getElementsByName( this.getAttribute("ASSOCNAME").split("_")[1] )[0];
		event = e;
	}
	else {
		obj=this.getAttribute("CURFILE");
		event = window.event;
	}

	if(obj!=null)
		obj.removeAttribute("CURIMG");

	if(obj!=null)
	{
		var h,w,objlink;
		objnext=obj.parentNode.parentNode.lastChild;
		h=parseInt(this.height);
		w=parseInt(this.width);
		if(h>0 && w>0)
		{
			objlink=document.getElementById("imgPreview")
			objlink.href=this.src;

			if(this.width > 200){
				if(this.height > 200){
					alert(JSVClang("The image width and height exceed the allowed limit.",25135));
				} else	{
					alert(JSVClang("The image width exceed the allowed limit.",25136));
				}
				document.getElementById("signatureFile").value="";
				objnext.innerHTML="";
				objlink.innerHTML="";
			}
			else if(this.height > 200) {
				alert(JSVClang("The image height exceed the allowed limit.",25137));
				document.getElementById("signatureFile").value="";
				objnext.innerHTML="";
				objlink.innerHTML="";
			}
			else {
				this.height=50;
				this.width=parseInt(50*w/h);
				objnext.innerHTML="";
				objlink.innerHTML="";
				objlink.appendChild(this);
				//objnext.appendChild(objlink);
			}
		}
	}
}
<CFSET GIA_ARCSOL_PERCHK = false>
<CFSET GIA_IDCHK = false>
<CFIF LOCID IS 2 and session.vars.orgType eq "D"><CFSET GIA_IDCHK = true></cfif>
<CFIF LOCID IS 2 AND ListFindNoCase("1,12",USER_COTYPEID) gt 0><CFSET GIA_ARCSOL_PERCHK = true></CFIF>

<cfif GIA_IDCHK>
var LAST_NRIC = "";
function GIAValidateNRIC() {
	var ID = $('#USRID1').val();
	var dup_str = "";
	if(ID!='' && LAST_NRIC!=ID)
	{
		LAST_NRIC=ID;
		$('#loadtext_val').remove();
		$('#USRID1').after("<span id=loadtext> <img style='vertical-align:middle;height:20px;' src='<cfoutput>#request.approot#</cfoutput>services/images/loading-anim.gif'></span>")
		var request = $.ajax({
		  url: "<cfoutput>#request.webroot#index.cfm?fusebox=MTRadmin&fuseaction=json_duplicateNRIC_check&#request.mtoken#</cfoutput>",
		  method: "POST",
		  <cfoutput>data: { NRIC : ID, COID : "#attributes.coid#", USID : "#attributes.IUSID#" }</cfoutput>
		});
		request.done(function( msg )
		{
			$('#loadtext').remove();

			if(typeof(msg) == "object" && msg.DATA)
			{
				if(msg.DATA.length > 0)
				{
					for (var i=0;i<msg.DATA.length;i++)
						dup_str += (dup_str==""?"":", ") + msg.DATA[i][1] <cfif session.vars.orgtype eq "D">+ " (COID:" + msg.DATA[i][0] + ")"</cfif>;

					$('#USRID1').after("<div id='loadtext_val' style=color:red>Duplicate Identification detected in : "+dup_str+"</div>");
				}

			}
		});

		request.fail(function( jqXHR, textStatus ) {
			$('#loadtext').remove();
		});
	}
	else if (ID=="")
	{
		$('#loadtext_val').remove();
	}
}
</CFIF>
<CFIF GIA_ARCSOL_PERCHK>
function GIAReqNRIC()
{
	if( $('#PerChk_440').prop("checked") == true)
		document.getElementById('USRID1').setAttribute("CHKREQUIRED","");
	else
		document.getElementById('USRID1').removeAttribute("CHKREQUIRED");
	DoReq(document.getElementById('USRID1'))
}
</CFIF>
AddOnloadCode("<CFIF GIA_ARCSOL_PERCHK>GIAReqNRIC();$('#PerChk_440').on('click',function(){ GIAReqNRIC() });</CFIF><CFIF GIA_IDCHK>GIAValidateNRIC();JSVCaddEvent(document.getElementById('USRID1'),'blur',function(){GIAValidateNRIC(event);});</cfif>if(document.getElementById('cpwdchange'))JSVCaddEvent(document.getElementById('cpwdchange'),'click',function(){sendloginfunc(event);});DoReq(UserInfo);MrmPreprocessForm();");
GenerateMenubar("UserMenu",90);
<CFOUTPUT>
<CFIF Attributes.DUPLICATE IS 1>
	<CFSET MODE=0>
</CFIF>
<cfset urlparam="&mode=#mode#">
<cfif isdefined("attributes.coid")><cfset urlparam=urlparam & "&COID=#attributes.coid#"></cfif>
<cfif isdefined("attributes.fromcoid")><cfset urlparam=urlparam & "&FROMCOID=#attributes.fromcoid#"></cfif>
<cfif isdefined("attributes.urlback")><cfset urlparam=urlparam & "&URLBACK=#URLencodedformat(attributes.urlback)#"></cfif>

<cfif Isdefined("attributes.URLBACK") AND attributes.URLBACK NEQ "">
	AddToMenubar("UserMenu",JSVClang("<< Back",4781),request.webroot+"#URLDecode(attributes.URLBACK)#&"+request.mtoken);
<cfelse>
	AddToMenubar("UserMenu",JSVClang("<< Back (Company Profile)",2196),request.webroot+"index.cfm?fusebox=MTRadmin&fuseaction=dsp_coprofile&COID=#Attributes.FROMCOID#&"+request.mtoken);
</cfif>
<cfif LOCID IS NOT 5 AND mode IS 1>
AddToMenubar("UserMenu",JSVClang("Create Leave",11945),request.webroot+"index.cfm?fusebox=SVCSEC&fuseaction=dsp_createLeave&iusid=#Attributes.IUSID#&userid=#Attributes.USERID#&mode=0&from=MTRAdmin&"+request.mtoken);
</cfif>

<CFIF ORGTYPE IS "D" and attributes.iusid gt 0>
AddToMenubar("UserMenu",JSVClang("Change Branch",25138),request.webroot+"index.cfm?fusebox=MTRadmin&fuseaction=dsp_changeBranch&IUSID=#Attributes.IUSID##urlparam#&"+request.mtoken);
</CFIF>

<CFIF BITAND(q_co.iPWDSTRENGTHMASK,2048) AND  ORGTYPE IS "D">
	<CFMODULE TEMPLATE="#request.apppath#services/CustomTags\SVCchkgrp.cfm" GrpList="306R">
	<CFIF CANREAD IS 1>
	    AddToMenubar("UserMenu",JSVClang("Save",6804),"JavaScript:SubmitEntry(0)");
		<CFIF mode IS 1>
		AddToMenubar("UserMenu",JSVClang("Duplicate User",8769),request.webroot+"index.cfm?fusebox=MTRadmin&fuseaction=dsp_userprofile&IUSID=#Attributes.IUSID#&duplicate=1#urlparam#&"+request.mtoken);
		</CFIF>
		AddToMenubar("UserMenu",JSVClang("Next (Save &amp; Back) >>",2264),"JavaScript:SubmitEntry(1)");
	</CFIF>
<CFELSE>
    AddToMenubar("UserMenu",JSVClang("Save",6804),"JavaScript:SubmitEntry(0)");
	<!--- #17423 --->
	<CFIF mode IS 1 and (ORGTYPE IS "D" OR ORGTYPE IS "I" OR ORGTYPE IS "A" OR ORGTYPE IS "P" OR (ORGTYPE IS "R" AND q_co.siFRANCHISE GT 0 AND session.vars.gcoid IS session.vars.orgid) OR ORGTYPE IS "EA" OR ORGTYPE IS "L")>
		AddToMenubar("UserMenu",JSVClang("Duplicate User",8769),request.webroot+"index.cfm?fusebox=MTRadmin&fuseaction=dsp_userprofile&IUSID=#Attributes.IUSID#&duplicate=1#urlparam#&"+request.mtoken);
    </CFIF>
    AddToMenubar("UserMenu",JSVClang("Next (Save &amp; Back) >>",2264),"JavaScript:SubmitEntry(1)");
</CFIF>
</CFOUTPUT>
function SubmitEntry(val)
{
	var frm=document.UserInfo;
//	GroupListCheck(frm); //call function from group assign module
	if(FormVerify(frm))
	{
		if(!(MRMcheckPwd()))
			return;
		frm.submittype.value = val;
		FormSubmit(frm);
	}
}

<cfif AttrSAPIVal GT 0>
	function genAPIKey(obj) 
		{
			<CFOUTPUT>
				var url=request.webroot+'index.cfm?fusebox=SVCsec&fuseaction=json_regenpassword&#Request.MTOKEN#';
				var orgid=#SESSION.VARS.ORGID#;
			</CFOUTPUT>
			if(obj.value!= ""){
				$.ajax({
					type: 'POST',
					contentType: 'application/json',
					url: url
				}).done(function(response) {
					if(response != "Error"){
						obj=document.getElementById(obj);obj.value=response;
						DoReq(obj);
					}else{
						alert('Ops.. Something just went wrong, please contact support.');
					}
				}).fail(function(error) {
					alert('Ops.. Something just went wrong, please contact support.');
				});
			}
		}
</cfif>

</script>
<cfif Attributes.USERID IS NOT "">
	<cfquery name=q_user datasource=#Request.MTRDSN#>
	SELECT a.iUSID,a.vaUSID,a.siROLE,a.vaUSNAME,PWD='******',mnAPPLIMIT=a.mnAPPLIMIT,a.siSTATUS,a.vaMPHONE,a.VAID1,a.siID1TYPE,a.VAID2,a.siID2TYPE,
	a.vaDESIGNATION,a.vaDEPT,TELNO=RTrim(a.aTELNO),a.vaEMAIL,a.vaUSRCODE,a.vaUSRCODE2,siUSRACCTYPE=IsNull(a.siUSRACCTYPE,0),CHGPWD=IsNull(a.siCHGPWD,0),a.dtPWDCHG,a.dtLASTLOGON,a.dtLASTLOGOUT,
	iCLMTYPEACCMASK=IsNull(a.iCLMTYPEACCMASK,0),a.ICHILDCOACCESS,a.siSUSPENDED,a.siLOCKED,a.iLOCKTOT,a.dtMODON,MODUSNAME=b.vaUSNAME,a.dtCRTON,CRTUSNAME=c.vaUSNAME,a.dtPWDATTEMPT
	,a.vaLineID,a.vaVCID,iRESVCLMMASK=IsNull(a.iRESVCLMMASK,0)
	FROM SEC0001 a WITH (NOLOCK) LEFT JOIN SEC0001 b WITH (NOLOCK) ON a.aMODBY=b.vaUSID
	 LEFT JOIN SEC0001 c WITH (NOLOCK) ON a.aCRTBY=c.vaUSID
	WHERE UPPER(a.vaUSID)=<cfqueryparam cfsqltype="cf_sql_varchar" value="#UCASE(Attributes.USERID)#">
	</cfquery>
	<CFIF Attributes.DUPLICATE IS 1>
		<CFSET QuerySetCell(q_user,"iUSID",0)>
		<CFSET QuerySetCell(q_user,"CHGPWD",1)>
		<CFSET QuerySetCell(q_user,"vaUSID","")>
		<CFSET QuerySetCell(q_user,"vaUSNAME","")>
		<CFSET QuerySetCell(q_user,"vaID1","")>
		<CFSET QuerySetCell(q_user,"VAID2","")>
		<CFSET QuerySetCell(q_user,"vaUSRCODE","")>
		<CFSET QuerySetCell(q_user,"vaUSRCODE2","")>
		<CFSET QuerySetCell(q_user,"vaVCID","")>
		<CFSET QuerySetCell(q_user,"TELNO","")>
		<CFSET QuerySetCell(q_user,"vaEMAIL","")>
	</CFIF>
<cfelse>
	<cfset q_user=QueryNew("iUSID,vaUSID,siROLE,vaUSNAME,PWD,mnAPPLIMIT,siSTATUS,vaDESIGNATION,vaDEPT,TELNO,vaEMAIL,vaUSRCODE,vaUSRCODE2,siUSRACCTYPE,iCLMTYPEACCMASK,ICHILDCOACCESS,siSUSPENDED,siLOCKED,iLOCKTOT,dtMODON,MODUSNAME,dtCRTON,CRTUSNAME,dtPWDATTEMPT,CHGPWD,dtPWDCHG,dtLASTLOGON,dtLASTLOGOUT,vaMPHONE,vaID1,siID1TYPE,vaID2,siID2TYPE,vaLineID,vaVCID,iRESVCLMMASK")>
	<cfset QueryAddRow(q_user)>
	<cfset QuerySetCell(q_user,"CHGPWD",1)>
	<cfset QuerySetCell(q_user,"iUSID",0)>
	<!---cfif li_cotypeid IS 1 OR li_cotypeid IS 2 OR li_cotypeid IS 3 OR li_cotypeid IS 6--->
		<cfset QuerySetCell(q_user,"iCLMTYPEACCMASK",0)>
		<cfset QuerySetCell(q_user,"iRESVCLMMASK",0)>
	<!---/cfif--->
	<cfif LOCID IS 5>
		<!---
		select SUM(iCLMTYPEMASK) from CLMD0010 where vaCLMTYPE in ('LU','TP','TP UL','OD TAC','SC','TP BI','OD','OD TFR','TF','TP PD')
		--->
		<cfset QuerySetCell(q_user,"iCLMTYPEACCMASK",335155)>
	</cfif>
</cfif>
<CFSET userID=#attributes.USID#>
<cfoutput query=q_user>




<form action="#request.webroot#index.cfm?fusebox=admin&fuseaction=act_userprofile#urlparam#&#Request.MTOKEN#"  enctype="multipart/form-data" method=post name=UserInfo>
	<cfmodule TEMPLATE="#request.apppath#services/CustomTags\SVCchkguid.cfm" START>
	<table class=clsClmTable align=center style=WIDTH:90%>
	<col style=font-weight:bold;width:50ex>
	<tr class=header><td colspan=2>#Server.SVClang("USER PROFILE",2265)# - #ls_CONAME#</td></tr>
	<input type=hidden name=submittype value=0>

	<tr><td><b>#Server.SVClang("User ID*",2266)#</b></td>
		<td>
		<CFIF SESSION.VARS.ORGTYPE IS "D" AND Attributes.USERID IS NOT ""> <!--- Reset password (retrict to developer only) --->
			<span style=float:right>(USID: <b>#iUSID#</b>)</span>
		</CFIF>
		<input <CFIF vaUSID IS NOT "">READONLY </CFIF>CHKREQUIRED value="#vaUSID#" name=USERID autocomplete=off type=Text maxlength=15 size=15 onblur=FormatUser(this,#userminchar#) style=text-transform:uppercase onkeydown="if (event.keyCode==32) event.returnValue=false;">
		<span style="color:red">&nbsp;#Server.SVClang("(min. {0} characters)",17849,0,"#userminchar#")#</span>
		<cfif ISDEFINED("ret")>
			<cfif ret IS 1>
				#Server.SVClang("User ID already exist, Please select another User ID",2268)#
			<cfelse>
				#Server.SVClang("User ID must be at least {0} characters",17850,0,"#userminchar#")#
			</cfif>
		</cfif>
	</td></tr>
	<cfmodule template="#request.apppath#services/index.cfm" FUSEBOX=SVCsec FUSEACTION=dsp_ssouserlist usid=#attributes.iusid# coid=#Attributes.COID# cotypeid=#li_cotypeid#>
	<CFIF listfindnocase("DEV",application.DB_MODE) GT 0>
		<cfmodule template="#request.apppath#services/index.cfm" FUSEBOX=SVCsec FUSEACTION=dsp_eplclmsso usid=#attributes.iusid# coid=#Attributes.COID# userid=#Attributes.USERID# COTYPEID=#li_cotypeid#>
	</CFIF>
	<CFSET GENRNDPWD=0>
	<CFIF SESSION.VARS.ORGTYPE IS "D"> <!--- Reset password (retrict to developer) --->
		<CFSET GENRNDPWD=1>
	<CFELSEIF SESSION.VARS.ORGTYPE IS "I"> <!--- Reset password (insurer admin role only) --->
		<CFQUERY name=q_userrole datasource=#Request.MTRDSN#>
			SELECT a.sirole FROM sec0001 a WITH (NOLOCK)
			WHERE UPPER(a.vaUSID)=<cfqueryparam cfsqltype="cf_sql_varchar" value="#UCASE(SESSION.VARS.USERID)#">
		</CFQUERY>
		<CFIF q_userrole.sirole eq 15>
			<CFSET GENRNDPWD=1>
		</CFIF>
	</CFIF>
	<CFIF vaUSID IS ""><CFSET reqChgPwd=1><CFELSE><CFSET reqChgPwd=0></CFIF>
	<CFPARAM NAME=Attributes.PWDREJECTSTR DEFAULT="">
	<cfmodule TEMPLATE="#request.apppath#services/index.cfm" FUSEBOX=SVCSec FUSEACTION=dsp_changePWD pwdFieldName=1 iUSID=#iUSID# icoid=#Attributes.COID# GenRndpwd=#GENRNDPWD# reqChgPwd=#reqChgPwd# PWDREJECTSTR=#Attributes.PWDREJECTSTR#>
	<cfset trainmode=0>
	<!---cfif Len(Application.ApplicationName) GT 6 AND Right(Application.ApplicationName,6) IS "_train">
		<!--- 24 May 2012: Andrew: Re-Enable change password in Training mode --->
		<cfset trainmode=1>
	</cfif--->
	<cfif trainmode IS 0><tr><td></td><td><input type=hidden name=CHGPWDFLAGEXISTS value=1><input type=checkbox <CFIF CHGPWD IS 1> CHECKED</CFIF> name=CHGPWDFLAG id=_chgpwdflag value=1><label for=_chgpwdflag> User must change password during next login</label></td></tr></cfif>

	<!--- Password Mask (for edit mode) --->
	<!---cfif mode EQ 1>
		<script>
		UserInfo.pwdnew1.value="******";
		UserInfo.pwdnew2.value="******";
		</script>
	</cfif--->

	<td>#Server.SVClang("Name*",2275)#</td>
	<td><input CHKREQUIRED name=USName value="#HTMLEditFormat(vaUSNAME)#" type=Text maxlength=100 size=50 onblur=DoReq(this)></td></tr

	<!--- If 2FA is active --->
	<cfif bitAnd(q_co.hq_iPWDSTRENGTHMASK,8192) IS 8192>
		<input type="hidden" value=<cfif q_user.vaEMAIL NEQ "">1<cfelse>0</cfif> id="eMailStat">
		<cfquery name="q_2FA" datasource="#Request.MTRDSN#">
			SELECT
				tfaCRTON=MAX(FA.dtCRTON)
				,tfaStat=ISNULL(FA.siSTATUS,0)
				,tfaActive=FA.dtACTIVE
			FROM FSEC2000 FA WITH (NOLOCK)
				WHERE iUSERID=<cfqueryparam cfsqltype="cf_sql_integer" value="#iUSID#">
			GROUP BY ISNULL(FA.siSTATUS,0),FA.dtACTIVE,FA.dtINVALIDON
		</cfquery>

		<tr>
			<td><b>#Server.SVClang("2FA Status")#</td>
			<td>
				<b>
					<cfif q_2FA.RecordCount IS 0>
						Not in use
					<cfelseif q_2FA.tfaActive IS "">
						Pending Activation
					<cfelseif q_2FA.tfaStat IS 1>
						Inactive
					<cfelse>
						Active
					</cfif>
				</b>
				<input type="button" value="Reset 2FA Code" class="clsButton" onclick="confirmInfo()">
			</td>
		</tr>

		<cfset checkingPhrase="KAWABANGA">
		<cfset urlHash="#HASH(Attributes.USERID&checkingPhrase,'SHA-256')#">

		<script>
			function confirmInfo() {
				var warningPop=new JSVCpopup("Warn");
					warningPop.width=400;				
				var obj=$('##EMail');
				var isSaved=$('##eMailStat').val();

				if((obj && obj.val()=='') || isSaved==0) {
					warningPop.btnFlag=1;
					warningPop.btnNames=["Ok"];
					if(isSaved==0) {
						warningPop.title="Email is not saved";
						warningPop.msg="<p style=font-size:120%>Please save email address before performing 2FA reset.</p>";
					} else {
						warningPop.title="Email is empty";
						warningPop.msg="<p style=font-size:120%>Please enter and save email address before performing 2FA reset.</p>";
					}
									
				} else {
					warningPop.btnFlag=3;
					warningPop.btnNames=["Confirm","Cancel"];
					warningPop.title="Confirmation";
					warningPop.msg="<p style=font-size:120%>Please confirm that you're going to reset #q_user.vaUSNAME#'s 2FA code.</p>";	
					warningPop.fnOK=function(){
						<!--- perform reset and trigger email --->
						window.location=request.webroot+'index.cfm?fusebox=SVCTwoFA&fuseaction=act_2FAvalidation&modular=1&chkStr=#urlHash#&USERID=#Attributes.USERID#&reset=1&#newurlback#%26USERID%3D#Attributes.USERID#&'+request.mtoken;
					}
				}
				warningPop.gen();
				warningPop.show();
			}
		</script>
	</cfif>



	<cfif iUSID GT 0 AND (Application.DB_COUNTRY IS "TH" OR (Application.APPDEVMODE IS 1 AND LOCID IS 11))>
		<cfinvoke component="#Request.APPPATHCFC#services.language.index" method="dsp_langfunc" logicName='usNAME' domainID=11 userID=#iUSID# langDef=1>
		<cfoutput>
			<script>
				$(function(){
					$("##USRnm").after($("##addLang"));
					$("##addLang").css("margin-left", "1%");
					$("##addLang").after($("##dispusNAME"));
				});
			</script>
		</cfoutput>
	</cfif>

	<tr><td><b>#Server.SVClang("Role*",2276)#</b></td>
		<td><select CHKREQUIRED name=ROLE>
			<cfquery name=q_role datasource=#Request.MTRDSN#>
			SELECT siROLE,vaDESC from SEC0002 WHERE siCOTYPEID=<cfqueryparam value="#li_cotypeid#" cfsqltype="CF_SQL_NUMERIC">
			</cfquery>
			<cfloop query=q_role><option value=#siRole#<CFIF siRole IS q_user.siROLE> SELECTED</CFIF>>#vaDESC#</cfloop>
			</select></td></tr>



	<!--- BEGIN: #39432 custom setup for SG MSI : section --->
	<cfif USER_IGCOID IS 200036 AND li_cotypeid IS 2>   
	<tr><td><b>#Server.SVClang("Section",0)#</b></td>
		<td>
			<cfset deptsec_sel="">
			<cfif Attributes.IUSID GT 0>
				<CFQUERY NAME=q_sel DATASOURCE=#Request.MTRDSN#>
				SELECT i1  FROM FOBJ3025 with (nolock) where silogtype=901 AND idomid=11 and iOBJID=<cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.IUSID#"> and sistatus=0
				</CFQUERY>
				<cfif q_sel.recordcount GT 0><cfset deptsec_sel=#valuelist(q_sel.i1)#></cfif>
			</cfif>	
			<!--- <cfset deptsec_avail=""> --->
			<cfquery name="q_deptsec" datasource="#Request.MTRDSN#">
			selecT val=vacfcode, txt=vacfdesc from biz0025 with (nolock) where icoid=<cfqueryparam cfsqltype="cf_sql_integer" value="#USER_IGCOID#"> and aCFTYPE='DEPTSEC' and sistatus=0
			ORDER BY vacfdesc
			</cfquery>
			<cfif q_deptsec.recordcount GT 0>
				<cfset deptsec_avail=#valuelist(q_deptsec.val)#>
				<input type="hidden" name="sleDeptSecAvail" value="#deptsec_avail#">
			</cfif>
			<cfloop query="q_deptsec">
			<label style="float:left;width:25%">
				<input type="checkbox" name="sleDeptSec" value="#q_deptsec.val#" <cfif LISTFIND(deptsec_sel,q_deptsec.val) GT 0>CHECKED</cfif> > #q_deptsec.txt#</label>
			</cfloop>
		</td></tr>
	</cfif>
	<!--- END: #39432 custom setup for SG MSI : section --->



	<CFIF LISTFIND('1100002,1103448,1103449,1103888',attributes.FROMCOID)>
	<tr><td><b>#Server.SVClang("Line ID",37070)#</b></td>
		<td><input name="LineID" id="LineID" value="#HTMLEditFormat(valineID)#" type=Text maxlength=50 size=50></td></tr>
	</CFIF>

	<!-- mike -->
	<cfif li_cotypeid IS 2 OR li_cotypeid IS 3 OR li_cotypeid IS 4>
		<tr><td><b>#Server.SVClang("Approval Limit*",2280)#</b></td>
		<td><input CHKREQUIRED value="#Request.DS.FN.SVCnum(mnAPPLIMIT)#" type=text name=AppLimit size=15 maxlength=15 onblur=SetApprvLimit(this)> <i>#Server.SVClang("(-1 if unlimited)",2281)#</i></td>
		</tr>
	</cfif>

	<!--- </cfif>
	--->

	<cfif mode IS 1>
		<tr><td><b>#Server.SVClang("User End Date",0)#</b></td>
			<td>	<input <CFIF siSTATUS IS 1>DISABLED</CFIF> MRMOBJ=CALDATE name="sleUSRENDDT" DTMIN="#q_co.DATECREATED#"
						value="#Request.DS.FN.SVCdtDBtoLOC(q_co.DATEEND)#"
						onblur="ObjDate(this);">


					</td>
		</tr>
		<tr><td><b>#Server.SVClang("Status",1352)#</b></td>
		<td><select CHKREQUIRED name="Status" size="1">
			<option value=0<CFIF siSTATUS IS 0> SELECTED</CFIF>>#Server.SVClang("ACTIVE",2010)#<option value=1<CFIF siSTATUS IS 1> SELECTED</CFIF>>#Server.SVClang("DELETED",2011)#</select>
		</td></tr>
	</CFIF>

		<tr><td><b>#Server.SVClang("Access Type",8487)#</b></td><td>
		<CFIF siUSRACCTYPE IS "0" OR siUSRACCTYPE IS "">
			<CFSET USRACCTYPE=4>
		<CFELSE>
			<CFSET USRACCTYPE=siUSRACCTYPE>
		</CFIF>
		<CFIF SESSION.VARS.ORGTYPE IS "D" OR BitAnd(USRACCTYPE,1) IS 0>
			<select id=siUSRACCTYPE NAME=siUSRACCTYPE onblur=DoReq(this)>
			<option value="4"<CFIF USRACCTYPE IS "4"> SELECTED</CFIF>>4 - Online Login Only</option>
			<option value="2"<CFIF USRACCTYPE IS "2"> SELECTED</CFIF>>2 - Web Service Access Only</option>
			<option value="6"<CFIF USRACCTYPE IS "6"> SELECTED</CFIF>>6 - Online + Web Service Access</option>
			<CFIF SESSION.VARS.ORGTYPE IS "D">
				<option value="1"<CFIF USRACCTYPE IS "1"> SELECTED</CFIF>>1 - Integration Access Only</option>
				<option value="3"<CFIF USRACCTYPE IS "3"> SELECTED</CFIF>>3 - Integration + Web Service Access</option>
				<option value="5"<CFIF USRACCTYPE IS "5"> SELECTED</CFIF>>5 - Integration + Online Access</option>
				<option value="7"<CFIF USRACCTYPE IS "7"> SELECTED</CFIF>>7 - Integration + Online + Web Service Access</option>
			</CFIF>
		<CFELSE>
			<select DISABLED>
			<CFIF USRACCTYPE IS 1>
				<option value="1">1 - Integration Access Only</option>
			<CFELSEIF USRACCTYPE IS 3>
				<option value="3">3 - Integration + Web Service Access</option>
			<CFELSEIF USRACCTYPE IS 5>
				<option value="5">5 - Integration + Online Access</option>
			<CFELSEIF USRACCTYPE IS 7>
				<option value="7">7 - Integration + Online + Web Service Access</option>
			</CFIF>
		</CFIF>
		</select></td></tr>

	<CFIF mode IS 1 AND (siSUSPENDED GT 0 OR siLOCKED GT 0 OR iLOCKTOT GT 0)>
		<tr><td><b>#Server.SVClang("Bad Login Attempts",8488)#</b></td>
		<td>Consecutive:<span class=clsColorNote><b>#siLOCKED#</b></span><CFIF q_co.iPWDMAXATTEMPTS GT 0> / #q_co.iPWDMAXATTEMPTS#</CFIF>, <CFIF iLOCKTOT GT 0>Cumulative:<span class=clsColorNote><b>#iLOCKTOT#</b></span><CFIF q_co.iPWDMAXATTEMPTSTOT GT 0> / #q_co.iPWDMAXATTEMPTSTOT#<CFELSE> (No effect)</CFIF>.</CFIF><br>
		<CFIF siSUSPENDED GT 0><span class=clsColorError> <b>SUSPENDED</b> </span>, type CLEAR to unsuspend. <CFELSEIF BitAnd(q_co.iPWDSTRENGTHMASK,8) IS 8> User will be suspended if above limit.<CFELSEIF ((siLOCKED GTE q_co.iPWDMAXATTEMPTS) OR (q_co.iPWDMAXATTEMPTSTOT GT 0 AND (iLOCKTOT GTE q_co.iPWDMAXATTEMPTSTOT))) AND q_co.MINSDIFF GT 0> <span class=clsColorError> <b>LOCKED</b> </span> another <b>#q_co.MINSDIFF#</b> minute(s), type <CFIF (q_co.iPWDMAXATTEMPTSTOT GT 0 AND (iLOCKTOT GTE q_co.iPWDMAXATTEMPTSTOT))>CLEARALL<CFELSE>CLEAR</CFIF> to unlock immediately. <CFELSE> User will be locked 30 mins if above limit.</CFIF><br>Type 'CLEAR' here to reset consecutive, 'CLEARALL' to reset both: <INPUT name=CLRSUSPEND maxlength=8 size=9 onblur=this.value=Trim(this.value)>
		</td></tr>
	</CFIF>

	<cfif AttrSAPIVal GT 0 AND SESSION.VARS.ORGTYPE IS "D" AND BITAND(USRACCTYPE,2) EQ 2>
		<cfquery name="q_apikey" datasource=#Request.MTRDSN#>
			SELECT iKEYID,vaAPIKEY,vaSECRET,dtsuspended from sapi_auth WITH (NOLOCK) 
			WHERE iUSID=<cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.IUSID#">
			AND siSTATUS=0 
		</cfquery>

		<cfif q_apikey.recordcount GT 0>
			<cfset vaAPIKEY = q_apikey.vaAPIKEY>
			<cfset vaSECRET = q_apikey.vaSECRET>
			<cfset dtsuspended = q_apikey.dtsuspended>
			<cfset iKEYID = q_apikey.iKEYID>
		<cfelse>
			<cfset vaAPIKEY = "">
			<cfset vaSECRET = "">
			<cfset dtsuspended = "">
			<cfset iKEYID = 0>
		</cfif>

		<tr>
			<td colspan="2"><b>#Server.SVClang("Web Service SAPI Key",0)#</b></td>
		</tr>
		<input type="hidden" name="keyid" id="keyid" value="#iKEYID#"> 
		<tr>
			<td class="chkboxstyle">#Server.SVClang("Api Key",0)#</td>
			<td>
				<input type="text" maxlength=100 size=50 id="APIKEY" name="APIKEY" readonly="true" value="#vaAPIKEY#" onblur=DoReq(this)>
				<input id="BTNRESET" type="button" class="clsButton" value="#Server.SVClang("Reset and Generate",12485)#" onclick="genAPIKey('APIKEY');">
			</td>
			</tr>
		<tr>
			<td class="chkboxstyle">#Server.SVClang("Secret Key",0)#</td>
			<td><input maxlength=100 size=50 type="text" id="SecretKey" name="SecretKey" readonly="true" value="#vaSECRET#" onblur=DoReq(this)>
					<input id="BTNRESET" type="button" class="clsButton" value="#Server.SVClang("Reset and Generate",12485)#" onclick="genAPIKey('SecretKey');"> 
			</td>
		</tr>
		<tr>
			<td class="chkboxstyle">#Server.SVClang("Date Suspended",0)#</td>
			<td>
				<input MRMOBJ="CALDATE" DTFORMAT="dd/mm/yyyy" DTMIN="TODAY" name="dtSAPIEFFECTIVE" size=15 maxlength=10 VALUE="#Request.DS.FN.SVCdtDBtoLOC(dtsuspended)#" onblur=ObjDate(this)> 
			</td>
		</tr>
	</cfif>


	<tr><td><b>#Server.SVClang("Child Company Access",2284)#</b></td>
	<td><select CHKREQUIRED name=ICHILDCOACCESS><option VALUE=0>#Server.SVClang("No",1311)#<option VALUE=1<CFIF ICHILDCOACCESS IS 1> SELECTED</CFIF>>#Server.SVClang("Yes",1310)#</select>
	</td></tr>

	<!--- Filtering claim types accessible to users. List of cotypeid access should be sync with dsp_userprofile/dsp_clmregdtl --->
	<cfif li_cotypeid IS 1 OR li_cotypeid IS 2 OR li_cotypeid IS 3 OR li_cotypeid IS 5 OR li_cotypeid IS 6 OR li_cotypeid IS 12 OR li_cotypeid IS 15 OR li_cotypeid IS 17>
		<cfset nmmask=0>
		<cfset mtrmask=0>
		<cfloop collection=#request.ds.clmtypereverse# item="IDX">
			<cfif LEFT(IDX,2) IS "NM">
				<cfset nmmask=nmmask+#val(StructFind(request.ds.clmtypereverse, IDX))#>
			<cfelse>
				<cfset mtrmask=mtrmask+#val(StructFind(request.ds.clmtypereverse, IDX))#>
			</cfif>
		</cfloop>
		<!--- only LOCID 1 can have more claim types --->
		<cfif LOCID IS 5>
			<cfset CCAN=BitAnd(-1,BitNot(204))>
		<cfelseIF LOCID IS 7>
			<!--- For now only Motor & 'OD','TP','TF','TP PD','TP BI','SC' & All NM --->
			<!--- #9236: 23/01/2014: Added OD EXW --->
			<cfset CCAN=1+2+16+512+2048+4096+65536+536518656>
		<cfelseif li_cotypeid IS 2 AND NOT (LOCID IS 5 OR LOCID IS 1 OR LOCID IS 11)>
			<cfset CCAN=BitAnd(-1,BitNot(8))>
		<cfelseif (li_cotypeid IS 2 OR li_cotypeid IS 3) AND (LOCID IS 1 OR LOCID IS 11)>
			<cfset CCAN=-1>
		<cfelseif li_cotypeid IS NOT 2 AND (LOCID IS 1 OR LOCID IS 11)>
			<cfset CCAN=BitAnd(-1,BitNot(4))>
		<cfelseif LOCID is 2 or LOCID is 10 or LOCID IS 14 or LOCID IS 9 OR LOCID IS 16><!--- 24120 Enable WS Claimtype for repairers in PH/SG/HK --->
			<cfset CCAN=BitAnd(-1,BitNot(8))>
		<CFELSE>
			<cfset CCAN=BitAnd(-1,BitNot(12))>
		</cfif>
		<cfif LOCID IS 10><!--- phil only can access  OD, OD TAC, OD TFR, TP, WS & TF module + NM (based on nmmask) --->
			<!--- 20828 enable SC claim type 65536--->
			<!--- enable LU 262144 #21221 --->
			<!--- enable MNT for PH #39386 --->
			<cfset CCAN=BitAnd(CCAN,1+2+4+16+32+256+2048+4096+16384+65536+262144+64+nmmask)>
		</cfif>
		<cfif LOCID IS 7>
			<!--- #19039 - OD MNT for indo ---> <!--- #25067 cotypeid 17 --->
			<CFIF li_cotypeid IS 1 OR li_cotypeid IS 6 OR li_cotypeid IS 5 OR li_cotypeid IS 2 OR li_cotypeid IS 17>
				<cfset CCAN=BitOR(CCAN,64)>
			</CFIF>
			<cfset CCAN=BitOR(CCAN,256)>
		</cfif>
		<cfif (LOCID IS 1 OR LOCID IS 11) AND (li_cotypeid IS 1 OR li_cotypeid IS 6 OR li_cotypeid IS 5)>
	<!--- 		<cfset CCAN=BitAnd(-1,BitNot(16+64+128+1024+2048+4096+nmmask))> --->
	<!--- 		<cfset CCAN=BitAnd(-1,BitNot(64+128+1024+2048+4096+nmmask))> --->
			<cfif (LOCID IS 1 OR LOCID IS 11) AND li_cotypeid IS 6><!--- agent/broker, require TP PD bit (2048) #17012, #27149: enable TP UL and TP BI  --->
				<cfset CCAN=BitAnd(-1,BitNot(64+128))>
			<cfelse><!--- non agent/broker --->
				<cfset CCAN=BitAnd(-1,BitNot(64+128+1024+2048+4096))>
			</cfif>
			<cfif li_cotypeid IS 1><cfset CCAN=BITAND(CCAN,BitNot(16))></cfif>
			<cfif REPFRANCHISE IS 1 AND REPFINANCE IS "">
				<cfset CCAN=BitOr(CCAN,64+128)>
			<cfelseif REPFRANCHISE IS 1 AND REPFINANCE IS NOT "">
				<cfset CCAN=BitOr(CCAN,16+64+128)>
			<cfelseif REPFRANCHISE IS NOT 1 AND REPFINANCE IS NOT "">
				<cfset CCAN=BitOr(CCAN,16)>
			</cfif>

			<cfset FRANCHISE_PANEL=false>
			<cfquery name="q_chk" datasource=#Request.MTRDSN#>
			SELECT 1 FROM BIZ0061 a WITH (NOLOCK) WHERE a.iCOID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.fromcoid#"> AND a.siSTATUS=0 AND a.siACTIVE=1
			</cfquery>
			<cfif q_chk.RecordCount GT 0>
				<cfset FRANCHISE_PANEL=true>
			</cfif>
			<cfif REPFRANCHISE IS NOT 1 AND FRANCHISE_PANEL>
				<cfset CCAN=BitOr(CCAN,64)><!--- MNT --->
			</cfif>

			<!--- CCB & Perodua --->
			<cfif CURGCOID IS 535 OR CURGCOID IS 650 OR CURGCOID IS 6575>
				<cfset CCAN=BitOr(CCAN,16+64+128)><!--- TF+MNT+GRG --->
			</cfif>
			<cfif CURGCOID IS 18781><!--- Wing Hin Autohaus --->
				<cfset CCAN=BitOr(CCAN,128)><!--- GRG --->
			</cfif>
			<!--- Insurer Agent notify NM claims --->
	<!--- 		<cfif li_cotypeid IS 6>
				<cfset CCAN=BitOr(CCAN,nmmask)>
			</cfif> --->
		</cfif>

		<cfif li_cotypeid IS 1><!--- repairer --->
			<cfif li_subcotypeid IS 2>
				<cfset CCAN=BITAND(CCAN,mtrmask)><!--- MTR repairer --->
			<cfelseif li_subcotypeid IS 4><!--- NM Repairer --->
				<cfset CCAN=67108864><!--- NM Repairer claim NM EXW only--->
			</cfif>
		<cfelseif li_cotypeid IS 3><!--- adjuster --->
			<cfif li_subcotypeid IS 2><!--- MTR only? ---><cfset CCAN=BITAND(CCAN,mtrmask)>
			<cfelseif li_subcotypeid IS 4><!--- NM only? ---><cfset CCAN=BITAND(CCAN,nmmask)>
			</cfif>
		</cfif>

		<script>
		function ClmTypeChk() {
			var a=document.getElementsByName("CLMTYPEACCLIST");
			var b=JSVCall("CLMTYPECHKALL");
			b.value=(b.value==1?0:1);
			for(var c=0;c<a.length;c++) a[c].checked=(b.value==1?true:false);
		}
		</script>
		<tr><td><b>#Server.SVClang("Claim Type Access",2283)# [<a target=help href="#request.webroot#index.cfm?fusebox=MTRroot&fuseaction=dsp_insurerreq&dirlist=3&NoLayout=1&#request.mtoken#">Help</a>]</b></td>
		<td>
		<!--- table><cfset CNT=0><cfloop COLLECTION=#Request.DS.CLMTYPE# ITEM=ITM><cfif CNT MOD 2 IS 0><cfif CNT IS NOT 0></TR></cfif><tr></cfif><cfset CNT=CNT+1><td style=border:0px><input TYPE=CHECKBOX<CFIF BitAnd(CCAN,ITM) IS 0> DISABLED<CFELSE> NAME=CLMTYPEACCLIST VALUE=#ITM#<CFIF BITAND(iCLMTYPEACCMASK,ITM) GT 0> CHECKED</CFIF></CFIF>> #StructFind(Request.DS.CLMTYPENAMES,ITM)#<br></td></cfloop></TR>
		<tr><td style="border:0"><a href=javascript:ClmTypeChk() style="font-size:90%">[Select All]</a><input type=hidden id=CLMTYPECHKALL value=0></td></tr></table --->

		<!--- ZH #31234 --->
		<CFSET ATTRRESVVIEW=0>
		<CFIF USER_COTYPEID IS 2>
			<CFSET ATTRRESVVIEW=Request.DS.FN.SVCgetExtAttrLogic("COADMIN",0,"COATTR-RESVVIEW",10,request.ds.co[attributes.COID].gcoid)>
		</CFIF>
		<cfset divwidth="33.33%"><cfset vaclmtypelist=#listsort(structkeyList(request.ds.clmtypereverse),"text","asc")#>

		<CFIF ATTRRESVVIEW IS 1>
			<style>
			.tooltip {
					position: relative;
					display: inline-block;
					border-bottom: 1px dotted black;
				}

				.tooltip .tooltiptext {
					visibility: hidden;
					width: 120px;
					background-color: black;
					color: ##fff;
					text-align: center;
					border-radius: 6px;
					padding: 5px 0;

					position: absolute;
					z-index: 1;
					bottom: 100%;
					left: 50%;
					margin-left: -60px;
				}

				.tooltip:hover .tooltiptext {
					visibility: visible;
				}
			</style>

			<table style="border-collapse: collapse;" width="100%">
				<tr class="clsColumnHeader">
					<td width="30%">#Server.SVClang("Claim Type",0)#</td>
					<td width="10%">
						<div class="tooltip">#Server.SVClang("Access",0)#
							<span class="tooltiptext">#Server.SVClang("Grant access to the following claim type",0)#</span>
						</div>
					</td>
					<td width="10%">
						<div class="tooltip">#Server.SVClang("View Reserve",0)#
							<span class="tooltiptext">#Server.SVClang("Grant access to view reserve of the following claim type",0)#</span>
						</div>
					</td>
					<td width="30%">#Server.SVClang("Claim Type",0)#</td>
					<td width="10%">
						<div class="tooltip">#Server.SVClang("Access",0)#
							<span class="tooltiptext">#Server.SVClang("Grant access to the following claim type",0)#</span>
						</div>
					</td>
					<td width="10%">
						<div class="tooltip">#Server.SVClang("View Reserve",0)#
							<span class="tooltiptext">#Server.SVClang("Grant access to view reserve of the following claim type",0)#</span>
						</div>
					</td>
				</tr>

				<CFSET CLMTYPARR=listToArray(vaclmtypelist)>
				<CFLOOP from="1" to="#arrayLen(CLMTYPARR)#" step="2" index="I">
					<tr>
						<CFSET ITM=#request.ds.clmtypereverse[CLMTYPARR[I]]#>
						<td>#request.ds.clmtypenameslookup[CLMTYPARR[I]]#</td>
						<td style="text-align: center;">
							<input TYPE=CHECKBOX id="_clmtype#ITM#"<CFIF BitAnd(CCAN,ITM) IS 0> DISABLED<CFELSE> NAME=CLMTYPEACCLIST VALUE=#ITM#<CFIF BITAND(iCLMTYPEACCMASK,ITM) GT 0> CHECKED</CFIF></CFIF>>
						</td>
						<td style="text-align: center;">
							<input TYPE=CHECKBOX <CFIF BitAnd(CCAN,ITM) IS 0> DISABLED<CFELSE> NAME=RESVCLMMASK VALUE=#ITM#<CFIF BITAND(iRESVCLMMASK,ITM) GT 0> CHECKED</CFIF></CFIF>>
						</td>

						<CFIF I+1 lte arrayLen(CLMTYPARR)>
							<CFSET ITM=#request.ds.clmtypereverse[CLMTYPARR[I+1]]#>
							<td>#request.ds.clmtypenameslookup[CLMTYPARR[I+1]]#</td>
							<td style="text-align: center;">
								<input TYPE=CHECKBOX id="_clmtype#ITM#"<CFIF BitAnd(CCAN,ITM) IS 0> DISABLED<CFELSE> NAME=CLMTYPEACCLIST VALUE=#ITM#<CFIF BITAND(iCLMTYPEACCMASK,ITM) GT 0> CHECKED</CFIF></CFIF>>
							</td>
							<td style="text-align: center;">
								<input TYPE=CHECKBOX <CFIF BitAnd(CCAN,ITM) IS 0> DISABLED<CFELSE> NAME=RESVCLMMASK VALUE=#ITM#<CFIF BITAND(iRESVCLMMASK,ITM) GT 0> CHECKED</CFIF></CFIF>>
							</td>
						</CFIF>
					</tr>
				</CFLOOP>
			</table>
		<CFELSE>
			<cfloop list="#vaclmtypelist#" index="IDX">
				<cfset ITM=#request.ds.clmtypereverse[IDX]#>
				<!--- div style="float:left;width:#divwidth#"><label for="_clmtype#ITM#"><input TYPE=CHECKBOX id="_clmtype#ITM#"<CFIF BitAnd(CCAN,ITM) IS 0> DISABLED<CFELSE> NAME=CLMTYPEACCLIST VALUE=#ITM#<CFIF BITAND(iCLMTYPEACCMASK,ITM) GT 0> CHECKED</CFIF></CFIF>> #IDX#</label></div --->
				<CFIF BitAnd(CCAN,ITM) GT 0>
				<div style="float:left;width:#divwidth#"><label for="_clmtype#ITM#"><input TYPE=CHECKBOX id="_clmtype#ITM#" NAME=CLMTYPEACCLIST VALUE=#ITM#<CFIF BITAND(iCLMTYPEACCMASK,ITM) GT 0> CHECKED</CFIF> > #request.ds.clmtypenameslookup[IDX]#</label></div>
				</CFIF>
			</cfloop>
		</CFIF>

		<div style="clear:both;padding:5px"><a href=javascript:ClmTypeChk() style="font-size:90%">[Select All]</a><input type=hidden id=CLMTYPECHKALL value=0></div>
		</td></tr>
		<cfif li_cotypeid IS 2 OR li_cotypeid IS 3>
			<cfset LIMITCODELIST=#request.ds.co[USER_IGCOID].POLGRP_LIMITCODE#>
			<!--- policy access query --->
			<!--- @CFLintIgnore CFQUERYPARAM_REQ --->
			<cfquery name="q_polaccess" datasource="#Request.MTRDSN#">
			SELECT a.iPRIORITY, vaLIMITCODE=c.val, b.MNLIMIT, POLGRPID=a.iPOLGRPID, GCOID=a.iGCOID, POLGRPNAME=a.vaDESC, POLGRPREMARKS=a.txremarks, POLGRPSTATUS=a.sistatus,ACCESSSTATUS=b.sistatus, applied=CASE WHEN b.iPOLGRPID IS NULL THEN 0 ELSE 1 END, b.bRIGHTS
			FROM
			dbo.StringToTableStr('<!--- @CFIGNORESQL_S --->#LIMITCODELIST#<!--- @CFIGNORESQL_E --->') c
			JOIN BIZ2018 a ON a.igcoid=<cfqueryparam value="#CURGCOID#" cfsqltype="CF_SQL_INTEGER"> AND a.sistatus=0
			LEFT JOIN SEC0018 b WITH (NOLOCK) ON (a.iPOLGRPID=b.iPOLGRPID <cfif Attributes.IUSID NEQ "">AND b.iUSID=<cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.IUSID#"></cfif> AND b.vaLIMITCODE=c.val)
			ORDER BY a.iPRIORITY, a.iPOLGRPID, c.idx
			</cfquery>

			<cfif q_polaccess.recordcount GT 0>
				<script>
				function toggleaccess(obj,objr,objlimit,limitcode) {
					if(typeof(obj)=="string") obj=document.getElementById(obj);
					if(typeof(objr)=="string") objr=document.getElementById(objr);
					if(typeof(objlimit)=="string") objlimit=document.getElementById(objlimit);

					switch(obj.value) {
						case '-': // next would be allow ...
							objr.value='1';
							objlimit.disabled=false;
							objlimit.onblur();
							objlimit.select();
							obj.value='Allow';
							break;
						case 'Allow':
						<!--- /*
							if(limitcode.toUpperCase()=='CLM') {
							objr.value='0';
							objlimit.disabled=true;
							objlimit.onblur();
							obj.value='Deny';
							break;
							}*/ --->
						default: // deny next would be - ...
							objr.value='';
							objlimit.disabled=true;
							objlimit.onblur();
							obj.value='-';
					}
				}
				</script>
				<tr><td><b>#Server.SVClang("Policy Rule Access",7696)#</b></td><td>
				<!--- <cfdump var=#q_polaccess#> --->
				<table cellpadding=0 cellspacing=0 border=1>
				<cfset col=0>
				<cfset cols=#LISTLEN(LIMITCODELIST)#>
				<cfif evaluate(col MOD cols) NEQ 0><cfthrow TYPE="EX_SECFAILED" ErrorCode="BADPARAM"><!--- something wrong with the structure ---></cfif>
				<tr><td rowspan=2>Policy Group</td><td align="center" colspan=#cols#>Rights / Approval Limit</td></tr>
				<tr><cfloop list=#LIMITCODELIST# index="idx"><td align="center" style="font-weight:bold">#idx#</td></cfloop></tr>
				<input type="hidden" name="sleLIMITCODELIST" value="#LIMITCODELIST#">
				<cfloop query="q_polaccess">
					<cfif evaluate(col MOD cols) IS 0>
						<cfif col GT 0></tr></cfif>
						<tr><td style="font-weight:bold"><a href="Javascript:alert('#POLGRPNAME# <cfif POLGRPSTATUS IS 1>(INACTIVE)</cfif>\n\nDescription: #POLGRPREMARKS#')" <cfif POLGRPSTATUS IS 1>class="clsColorNote"</cfif> >#POLGRPNAME#</a><input type="hidden" name="slePOLICYGRPID" value="#POLGRPID#"></td>
					</cfif>
					<td>
						<cfif q_polaccess.applied IS 0 OR q_polaccess.ACCESSSTATUS IS 1>
							<cfset btnname="-">
						<cfelseif q_polaccess.bRIGHTS IS 1>
							<cfset btnname="Allow">
						<cfelse>
							<cfset btnname="Deny">
						</cfif>
						<input type="button" id="allowbtn" value="#btnname#" onclick="toggleaccess(this,'slePOLICYGRPRIGHTS#POLGRPID##vaLIMITCODE#','slePOLICYGRPLIMIT#POLGRPID##vaLIMITCODE#','#vaLIMITCODE#')" style="border-style:ridge;height:20px;width:50px;font-size:11px;font-weight:bold">
						<input type="text" CHKREQUIRED CHKNAME="Approval Limit" onblur=SetApprvLimit(this) id="slePOLICYGRPLIMIT#POLGRPID##vaLIMITCODE#" name="slePOLICYGRPLIMIT#POLGRPID##vaLIMITCODE#" value="<cfif q_polaccess.ACCESSSTATUS IS 0>#request.ds.fn.svcnum(q_polaccess.MNLIMIT)#</cfif>" <cfif NOT(btnname IS "Allow")>DISABLED</cfif> >
						<!--- <input type="hidden" name="slePOLICYGRPID" value="#POLGRPID#"> --->
						<input type="hidden" id="slePOLICYGRPRIGHTS#POLGRPID##vaLIMITCODE#" name="slePOLICYGRPRIGHTS#POLGRPID##vaLIMITCODE#" value="<cfif btnname IS "Allow">1<cfelseif btnname IS "Deny">0</cfif>">
					</td>
					<cfset col=col+1>
				</cfloop>
				</tr>
				</table>
	<!--- 			<cfloop query="q_polaccess">
					<cfif q_polaccess.polgrpstatus IS 0 OR (q_polaccess.polgrpstatus IS 1 AND q_polaccess.applied IS 1 AND q_polaccess.accessstatus IS 0)>
						<cfif q_polaccess.applied IS 0 OR q_polaccess.ACCESSSTATUS IS 1>
							<cfset btnname="-">
						<cfelseif q_polaccess.bRIGHTS IS 1>
							<cfset btnname="Allow">
						<cfelse>
							<cfset btnname="Deny">
						</cfif>
						<div>
						#q_polaccess.vaLIMITCODE# :
						<input type="button" id="allowbtn" value="#btnname#" onclick="toggleaccess(this,'slePOLICYGRPRIGHTS#POLGRPID#','slePOLICYGRPLIMIT#POLGRPID#')" style="border-style:ridge;height:20px;width:50px;font-size:11px;font-weight:bold">
						<a href="Javascript:alert('#POLGRPNAME# <cfif POLGRPSTATUS IS 1>(INACTIVE)</cfif>\n\nDescription: #POLGRPREMARKS#')" <cfif POLGRPSTATUS IS 1>class="clsColorNote"</cfif> >#POLGRPNAME#</a> ... <i>Approval Limit up to </i>
						<input type="text" CHKREQUIRED CHKNAME="Approval Limit" onblur=SetApprvLimit(this) id="slePOLICYGRPLIMIT#POLGRPID#" name="slePOLICYGRPLIMIT#POLGRPID#" value="#request.ds.fn.svcnum(q_polaccess.MNLIMIT)#" <cfif NOT(btnname IS "Allow")>DISABLED</cfif> >
						<input type="hidden" name="slePOLICYGRPID" value="#POLGRPID#">
						<input type="hidden" name="slePOLICYGRPRIGHTS#POLGRPID#" value="<cfif btnname IS "Allow">1<cfelseif btnname IS "Deny">0</cfif>">
						</div>
					</cfif>
				</cfloop> --->
				<div style="padding-top:10px;font-style:italic">
				<u>Access Rights (for case which meet the rules applied)</u><br>
				"Allow": to grant case access<br>
				<!--- "Deny": to revoke case access<br> --->
				"-" : default as general claim type access (and general approval limit)
				<br><br>
				<u>Approval Limit (for case which meet the rules applied)</u><br>
				-1 if unlimited
				</div>
				</td></tr>
			<cfelse>
				<!---tr><td>#Server.SVClang("Policy Rule Access",7696)#</td><td>
				<input type="button" class="clsButton" value="Create New Policy Group" onclick="Javascript:location.href=request.webroot+'index.cfm?fusebox=MTRadmin&fuseaction=dsp_policygrpdtls&COID=#CURGCOID#&'+request.mtoken"></td></tr--->
			</cfif>
			<!--- select name="slePOLICYACCESS" id="slePOLICYACCESS">
				<cfloop query="q_polaccess">
				<option value="#POLGRPID#" REMARKS="#q_polaccess.POLGRPREMARKS#">#q_polaccess.POLGRPNAME#</option>
				</cfloop>
			</select>&nbsp;&nbsp;<input type="button" class="clsButton" value="Add Selected Rule">&nbsp;<input type="button" class="clsButton" value="Show Selected Info" --->

		</cfif>
	</cfif>
	<!---CFIF li_cotypeid IS 2 AND SESION.VARS.ORGTYPE IS "D">
		<tr><td>Acc. Type</td><td><SELECT name=USRACCTYPE><OPTION VALUE=0>Online User<OPTION VALUE=1>Integration User</SELECT></td></tr>
	</CFIF--->

	</table>
	</cfoutput>
	<br><br><br>

	<!--- It is a security loophole to allow the list of allowable permissions to be passed via FORM.DEFPLIST, this can be easily manipulated by an intercepting the form to add a non-editable permissionID to both DEFPLIST and PERCHK.
	The DEFPLIST should be recalculated again in DB and sync from the one passed in from the FORM.
	IMPORTANT: The conditions here must be sync and it should only affect CLAIMS app (claims\admin\dsp_userprofile.cfm and sspFSECUserProfile) --->
	<CFSET PERMGRPNOTLIST="">
	<CFSET PRESELECTLIST="">
	<cfset permdislist="">
	<cfset permhidlist="">
	<cfset permuntick="">

	<CFIF LOCID IS 2>
		<cfset PERMGRPNOTLIST="70">
		<cfif NOT(ORGTYPE IS "I" OR ORGTYPE IS "D")>
			<cfset PERMGRPNOTLIST=ListAppend(PERMGRPNOTLIST,"80,90")>
		</cfif>
		<CFIF ORGTYPE IS NOT "D">
			<cfif ORGTYPE IS "I" AND CURGCOID IS 200045><!--- #43419 --->
				<cfset permhidlist=ListAppend(permhidlist,"500,504,501,502,53,507")>
			<cfelse>
				<cfset permhidlist=ListAppend(permhidlist,"440,503,444,442,441,443,500,504,501,502,53,507,510")>
			</cfif>
		</CFIF>
	<CFELSEIF LOCID IS 1><!---42704--->
		<cfif NOT(ORGTYPE IS "I" OR ORGTYPE IS "D")>
			<cfset permhidlist=ListAppend(permhidlist,"6013")>
		</cfif>	
	<CFELSE>
		<cfset PERMGRPNOTLIST="70,80,90">
		<cfif LOCID IS 5>
			<cfset PRESELECTLIST="7,34,1,35,75,76,63,33,64,401,402,98,99">
		</cfif>
	</CFIF>

	<CFIF USER_COTYPEID IS 6>
		<CFSET AttrCarGradeVal=Request.DS.FN.SVCgetExtAttrLogic("COADMIN",0,"COATTR-CARGRADE-1",10,attributes.COID)>
		<CFIF AttrCarGradeVal IS NOT 1>
			<CFSET permhidlist=ListAppend(permhidlist,"6012")>
		</CFIF>
	</CFIF>

	<!--- special permission 139: for WICA SG --->
	<!--- <cfif NOT(structkeyexists(request.ds.co,attributes.COID) AND ListFindNoCase("200045,200798,200043,200033",request.ds.co[attributes.COID].gcoid) GT 0)> --->
	<cfif NOT(LOCID IS 2)>
		<cfset permdislist=listappend(permdislist,"139")>
	</cfif>

	<cfif USER_COTYPEID IS 2>
		<CFSET AttrVal=Request.DS.FN.SVCgetExtAttrLogic("COADMIN",0,"COATTR124",10,request.ds.co[attributes.COID].gcoid)>
		<CFIF NOT(isNumeric(AttrVal) AND BITAND(AttrVal,1) IS 1)><cfset permdislist=listappend(permdislist,"67")></cfif>
		<cfif NOT(request.ds.co[attributes.COID].gcoid IS 29 OR request.ds.co[attributes.COID].gcoid IS 67)><cfset permdislist=listappend(permdislist,"66")></cfif>
	</cfif>

	<cfif structKeyExists(request.ds.co, attributes.COID)>
		<CFSET AttrSSOVal=Request.DS.FN.SVCgetExtAttrLogic("COADMIN",0,"COATTR-SSO-SERVICE",10,request.ds.co[attributes.COID].gcoid)>
		<CFIF AttrSSOVal IS NOT 1>
			<CFSET permhidlist=ListAppend(permhidlist,"6000")>
		</CFIF>
	</cfif>

	<cfif USER_COTYPEID IS 2>
		<CFSET ATTRVALUE=Request.DS.FN.SVCgetExtAttrLogic("COADMIN",0,"COATTR-TENDERTYPE",10,request.ds.co[attributes.COID].gcoid)>
		<cfif NOT(ATTRVALUE GT 0 AND BITAND(ATTRVALUE,1) IS 1)><!--- NM salvage is unchecked --->
			<cfset permhidlist=ListAppend(permhidlist,282)>
		</cfif>
	</cfif>

	<!--- S: #41378 --->
	<cfif structKeyExists(request.ds.co, attributes.COID)>
		<CFSET AttrAPVVal=Request.DS.FN.SVCgetExtAttrLogic("COADMIN", 2, "COATTR220", 10,request.ds.co[attributes.COID].gcoid)>
		<CFIF AttrAPVVal IS NOT 1>
			<CFSET permhidlist=ListAppend(permhidlist,"230")>
		</CFIF>
	</cfif>
	<!--- E: #41378 --->

	<!--- Note : Have a MTRExcludePerm for the above because need to use it in User Group selection & Access Matrix report. If you update the above list, please update in MTRexcludePerm as well. Leaving it commented out due to no time to test. --->
	<!--- <cfmodule TEMPLATE="#Request.LOGPATH#CustomTags\MTRexcludePerm.cfm" ORGTYPE="#session.vars.orgtype#" LOCID="#LOCID#" COID="#CURGCOID#"> --->

	<cfif LOCID IS 2 AND Attributes.DUPLICATE IS 1>
		<cfset permuntick="440,503,444,442,441,443,500,504,501,502,53">
	</cfif>

	<cfmodule template="#request.apppath#services/index.cfm" fusebox="SVCsec" fuseaction="dsp_userpermNgroup" icoid=#attributes.COID# iusid=#attributes.iusid#
	permgrplist="" permgrpnotlist="#PERMGRPNOTLIST#" preselectlist="#PRESELECTLIST#" permdislist="#permdislist#" permhidlist="#permhidlist#" permuntick=#permuntick#>
	
	
	<input type="button" 
	value="<cfif mode EQ 1>Update Staff<cfelse>Create Staff</cfif>" 
		onclick="SubmitEntry(1);">
		
		
		
	</FORM>
	


<!--- set invisible and check/uncheck with js --->
<!--- <script>
	document.getElementById("PerChk_306").checked = true;
	</script> 
<style>
    #PERMTABLE {
        display: none;
    }
		.clsDocBody {
			display: none;
		}
</style> --->






    
    




