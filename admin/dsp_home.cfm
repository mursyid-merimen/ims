<cfmodule TEMPLATE="/services/CustomTags\SVCDISABLEDIRECT.cfm" Path="#GetCurrentTemplatePath()#">

<!--- <cfdump var="#Attributes#"> --->
<cfdump var="#session#" label="Session Variables">
<cfset Attributes.USID=Session.VARS.USID>


<!--- Attributes:COID*,PCOID*,ERROR* --->
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

<!---cfif session.vars.orgtype IS "D" AND UCASE(CGI.HTTP_HOST) IS "LOCALHOST" AND IsDefined("Attributes.LOCID") AND Attributes.LOCID IS NOT "" AND IsNumeric(Attributes.LOCID) --->
<cfif SESSION.VARS.ORGTYPE IS "D" AND IsDefined("Attributes.LOCID") AND Attributes.LOCID IS NOT "" AND IsNumeric(Attributes.LOCID)>
	<cfset LOCID=#Attributes.LOCID#>
<cfelse>
	<cfset LOCID=SESSION.VARS.LOCID>
</cfif>
<!--- cfset LOCID=SESSION.VARS.LOCID --->
<cfset LOCALE=Request.DS.LOCALES[LOCID]>

<cfmodule TEMPLATE="#request.apppath#services/CustomTags\SVCchkgrp.cfm" GrpList="15W"><!--- Level 4 --->
<cfset Level4=CanWrite>
<cfmodule TEMPLATE="#request.apppath#services/CustomTags\SVCchkgrp.cfm" GrpList="741W"><!--- Level 5 --->
<cfset Level5=CanWrite>

<cfif Attributes.COID GT 0>
	<!--- Edit mode --->
	<cfmodule TEMPLATE="#Request.LOGPATH#CustomTags\CHKCASE.cfm" CHKORGTYPE="D,I,A,R,P,S,G,GR,L,EA" COID="#Attributes.COID#" CHKCOID=1>
	<cfmodule TEMPLATE="#request.apppath#services/CustomTags\SVCchkgrp.cfm" GRPLIST="7W,8W,9W,41W,10W,21W,22W,70W" CHKWRITE>
<cfelse>
	<cfmodule TEMPLATE="#Request.LOGPATH#CustomTags\CHKCASE.cfm" CHKORGTYPE="D">
	<!--- <cfmodule TEMPLATE="#request.apppath#services/CustomTags\SVCchkgrp.cfm" GRPLIST="10W,21W,22W" CHKWRITE> --->
	<cfparam NAME=Attributes.PCOID DEFAULT=0>
</cfif>
<cfif IsDefined("URL.NEXTLOC")>
	<cfmodule TEMPLATE="#Request.LOGPATH#CustomTags\SETTOKEN.cfm" NONEXTLOC>
	<CFLOCATION URL="#URL.NEXTLOC#&#REQUEST.MTOKEN#" ADDTOKEN="no">
</cfif>

<cfset Attributes.COID=1>

--->
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Inventory Management System</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- Bootstrap 5 CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        input[readonly] {
            background-color: #f8f9fa;
        }
    </style>
</head>
<body>
    
<cfdump var="#Attributes#">  

</body>
</html>

