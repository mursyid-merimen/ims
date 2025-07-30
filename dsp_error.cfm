<!---
FILENAME : CLAIMS/root/dsp_error.cfm
DESCRIPTION :
Error processing page for CLAIMS.
   
INPUT/ATTR:
ERROR structure from Cold Fusion Server.

OUTPUT : None.

CREATED BY : Andrew
CREATED ON : 26 July 2002

REVISION HISTORY
BY          ON          REMARKS
=========   ==========  ======================================================================================
--->

<!--- <cfset HOMEURL="#Request.Webroot#index.cfm?fusebox=MTRroot&fuseaction=dsp_login">	
<CFIF IsDefined("Attributes.TRAIN")>
	<CFSET HOMEURL&="&train=1">
</cfif>
<CFIF IsDefined("Attributes.GCOID") and Attributes.GCOID gt 0>
	<!--- <cfset HOMEURL=Request.DS.FN.SVCGetLoginURLCustom(application.appmode,"",HOMEURL,attributes.GCOID)> --->
</cfif>
<cfif (IsDefined("Attributes.LF") and Attributes.LF neq "")>
	<CFSET HOMEURL&="&lf=#URLEncodedFormat(Request.DS.FN.SVCSanitizeInput(attributes.LF,'JS-NQ'))#">
	<!--- <cfset HOMEURL=Request.DS.FN.SVCGetLoginURLCustom(application.appmode,attributes.LF,HOMEURL)> --->
</cfif> --->

<CFSET ErrorStruct=StructNew()>
<CFSET StructAppend(ErrorStruct,Error,True)>
<cfmodule TEMPLATE="#request.apppath#services/index.cfm" FUSEBOX=SVCroot FUSEACTION=dsp_errordefine ERRORSTRUCT=#ErrorStruct#>
<!DOCTYPE html>
<html>
<head>
    <title><cfoutput>#ErrorStruct.ErrTitle#</cfoutput></title>
    <CFMODULE TEMPLATE="header.cfm">
</head>
<body>
    <div class="error-box">
        <cfoutput>
            <h2>#ErrorStruct.ErrTitle#</h2>
            <p><strong>#ErrorStruct.ErrShortDesc#</strong></p>
            <div>#ErrorStruct.ErrLongHTML#</div>
        </cfoutput>

        <div class="back-btn">
            <button onclick="history.back();">Back</button>
        </div>
    </div>
		<style>
        body {
            font-family: Arial, sans-serif;
            background-color: #fefefe;
            /* padding: 2rem; */
        }
        .error-box {
            border: 1px solid #cc0000;
            padding: 1.5rem;
            background-color: #ffe6e6;
            border-radius: 8px;
            max-width: 600px;
            margin: auto;
        }
        h2 {
            color: #cc0000;
        }
        .back-btn {
            margin-top: 1rem;
        }
    </style>
</body>
</html>
