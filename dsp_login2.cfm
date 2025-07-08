<!---
FILENAME : CLAIMS/root/dsp_login.cfm
DESCRIPTION :
Generate the login page (first page upon entry).

INPUT/ATTR: UserID - Pre-fill UserID field in login [ for login retries ].
RetryID - The no of tries for displaying error message.

OUTPUT : None.

CREATED BY : Andrew
CREATED ON : 12 Oct 2002

REVISION HISTORY
BY          ON          REMARKS
=========   ==========  ======================================================================================
--->

<cfif IsDefined("SESSION.VARS")>
  <cfif IsDefined("SESSION.VARS.MACID")>
    <cfif Not IsDefined("COOKIE.MACID") OR (SESSION.VARS.MACID IS NOT COOKIE.MACID)>
      <cfthrow TYPE="EX_SECFAILED" ErrorCode="BADCLI">
    </cfif>
  </cfif>
  <cflock SCOPE="Session" Type="Exclusive" TimeOut=60>
    <cfscript>StructClear(session.vars);</cfscript>
  </cflock>
	<CFSET request.inSession=0>
</cfif>
<!---CFPARAM NAME=Attributes.SKIP_BROWSERTEST DEFAULT=0--->
<CFSET APPNAME=Application.ApplicationName>
<CFSET APPLOCID=Application.APPLOCID>
<!--- If user preferred language not set, then set default language based on locale --->
<cfif APPLOCID IS 7>
<cfset request.lgid=2>
</cfif>
<!---cfif Len(APPNAME) GT 6 AND Right(APPNAME,6) IS "_train">
	<CFSET Attributes.SKIP_BROWSERTEST=1>
</CFIF--->
<cfmodule TEMPLATE="#Request.LOGPATH#CustomTags\SETTOKEN.cfm" CLEARSESSION NOSCRIPT>
<cfmodule TEMPLATE="#Request.LOGPATH#CustomTags\MTRHEADER.cfm" nolayout>
<cfmodule TEMPLATE="#request.apppath#services/CustomTags\SVCADDFILE.cfm" FNAME="SVCLOGIN">
<cfmodule TEMPLATE="#request.apppath#services/CustomTags\SVCADDFILE.cfm" FNAME="SVCTAB">
<cfset FN=Request.DS.FN>

<CFIF IsDefined("Arguments.LF")>
	<CFSET Arguments.LF=Request.DS.FN.SVCSanitizeInput(Arguments.LF,'JS-NQ')>
<CFELSE>
	<CFSET Arguments.LF="">
</CFIF>

<!--- ID disable training mode and reset password --->
<cfset disableTrainingMod=0>
<cfset disableForgotPswd=0>
<cfif NOT StructKeyExists(URL,"fuseaction") and Arguments.LF neq "">
<cfif application.APPLOCID IS 7>
<cfif ListFind("UAT,DEV",Application.DB_MODE) OR (Arguments.LF neq "tokopedia" AND ListFind("PROD",Application.DB_MODE))> <!--- #26720 disable PROD --->
<cfset disableTrainingMod=1>
<cfset disableForgotPswd=1>
</cfif> <!--- #26720 disable PROD --->
</cfif>
</cfif>

<CFQUERY name=q_getcodetails datasource="#request.MTRDSN#">
	select aFAXNO,aTELNO from SEC0005 with (nolock) where icoid=1
</CFQUERY>

<CFOUTPUT>
<script>
	<!---cfif Application.APPDEVMODE IS 0--->
	<!---cfif Attributes.SKIP_BROWSERTEST IS 0>
	if(navigator.userAgent.indexOf('MSIE')<0)
		if(navigator.userAgent.indexOf('Trident/')<0)
			window.location.href=request.webroot+"incompatibility.htm";
	</CFIF--->
	<!---var retryid = <CFIF IsDefined("attributes.retryid") AND IsNumeric(Attributes.retryid)>#attributes.retryid#<CFELSE>0</cfif>;
	var userid = <CFIF IsDefined("attributes.userid")>'#FN.SVCSanitizeInput(attributes.userid,'JS-NQ')#'<CFELSE>''</cfif>;--->
	var retryid = #ARGUMENTS.retryid#;
	var userid = "";
	<!---CFIF Len(APPNAME) GT 6 AND Right(APPNAME,6) IS "_train">
	document.write("<h4 align=center style=color:darkred>( Training Mode )</h4>");
	</CFIF--->
	<cfset currenttime="#DateFormat(now(),'mm/dd/yyyy')# #TimeFormat(now(),'HH:mm:ss')#">
	<cfset nonce=ToBase64(currenttime&Hash(currenttime&"boo$ga56"))><!--- that is our private key --->

	<cfset GIARMC=0>
	<CFIF (CGI.HTTP_HOST IS "www.giarmc.org.sg" OR CGI.HTTP_HOST IS "202.157.152.91" OR CGI.HTTP_HOST IS "giauat.merimen.com") AND NOT(REQUEST.DS.MTRFN.DisableSGGIA(1))><cfset GIARMC=1></CFIF>
</script>
</cfoutput>
<CFIF GIARMC>
	<link href="<cfoutput>#request.approot#</cfoutput>services/scripts/bootstrap-3.3.5/css/tooltip.css" rel=stylesheet type=text/css></link>
	<script src="<cfoutput>#request.approot#</cfoutput>services/scripts/bootstrap-3.3.5/js/tooltip.js"></script>
</CFIF>
<cfoutput>

<div style="display: flex; width: 100vw; height: 100vh; margin: 0; padding: 0; border-color:white">

  <!-- Left: Background + Branding -->
  <div style="flex: 1; background: url('assets/login.jpg') no-repeat center center; background-size: 80%; display: flex; justify-content: center; align-items: center;">
    
  </div>

  <!-- Right: Login Form -->
  <div style="flex: 1; display: flex; justify-content: center; align-items: center;">
    <div id="login-container">
			<div style="text-align: center; background-color: rgba(0, 0, 0, 0.5); color: white; padding: 20px; border-radius: 10px;">
				<h1>Welcome to #Application.ApplicationName#</h1>
				<p>Please log in to continue.</p>
			</div>
      <script>	
        JSVCDoLogin("#nonce#", 5 * 60 * 1000, "fusebox=MTRsec&fuseaction=act_login");
      </script>
			<a style="font-weight:bold" href="index.cfm?fusebox=SVCsec&fuseaction=dsp_forgotpass">Forgot Password</a>
    </div>
  </div>

</div>




</CFOUTPUT>
<!--- <cfmodule TEMPLATE="#Request.LOGPATH#CustomTags\MTRFOOTER.cfm"> --->

<style>
  /* Full screen dark overlay */
  body {
    margin: 0;
    padding: 0;
    background-color: #f0f2f5;
    font-family: Arial, sans-serif;
  }

  #login-container {
		
		background-color: rgba(211, 211, 211, 0.85);
		padding: 30px 40px;
		border-radius: 10px;
		box-shadow: 0 8px 20px rgba(0, 0, 0, 0.4);
		color: #ffffff;
		min-width: 300px;
		max-width: 400px;
		width: 90%;
		z-index: 1000;
		backdrop-filter: blur(10px);
		-webkit-backdrop-filter: blur(10px);
	}

  .clsLoginTerms {
    font-size: 14px;
    padding: 10px 0;
  }

  input[type="text"],
  input[type="password"] {
    width: 100%;
    padding: 8px 10px;
    margin-top: 5px;
    border: none;
    border-radius: 4px;
  }

  
  table {
    width: 100%;
    border-collapse: collapse;
  }

  td {
    padding: 8px 4px;
  }

	.clsButton,
	.clsButton2,
	.clsButtonSearch {
		height: 40px;
		background: linear-gradient(135deg, #4f7cff, #769ff8);
		width: 100% !important;
		color: #ffffff;
		font-weight: bold;
		border: none;
		border-radius: 8px;
		text-align: center;
		font-size: 15px;
		padding: 10px 18px;
		cursor: pointer;
		box-shadow: 0 4px 12px rgba(118, 159, 248, 0.5);
		transition: all 0.3s ease;

		margin-top: 6px;
	}

	/* Hover effect */
	.clsButton:hover,
	.clsButton2:hover,	
	.clsButtonSearch:hover {
		background: #2e5cb8 !important;         /* solid dark color */
		background-image: none !important;      /* kill gradient/image */
		background-repeat: no-repeat !important;
		background-size: auto !important;
		background-position: center !important;
		box-shadow: none !important;            /* optional: remove highlight */
		transform: none !important;             /* remove hover lift if any */
		border: none !important;                /* optional: flatten look */
	}



	/* Disabled button */
	.clsButtonDisabled {
		background-color: #a0a0a0;
		color: #ffffff;
		font-weight: bold;
		border-radius: 8px;
		text-align: center;
		font-size: 15px;
		cursor: not-allowed;
		opacity: 0.6;
		padding: 10px 18px;
		box-shadow: none;
	}

	/* Specific for search-style button */
	.clsButtonSearch {
		width: 32px;
		height: 32px;
		padding: 0;
		background: linear-gradient(135deg, #4f7cff, #769ff8);
		background-size: cover;
		display: flex;
		align-items: center;
		justify-content: center;
		font-size: 0;
	}

	.clsButtonSearch::before {
		content: "🔍";
		font-size: 16px;
		color: white;
	}

	.clsLoginTerms {
		text-align: center;
	}

	#sleUserName{
		height: 30px !important;
		width: 100% !important;
	}

	#slePassword{
		height: 30px !important;
		width: 100% !important;
	}
</style>

