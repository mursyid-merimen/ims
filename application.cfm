<cfif NOT findNoCase("/index.cfm", cgi.script_name)><cfif StructKeyExists(URL,"CFID")><CFLOCATION URL="index.cfm?CFID=#url.CFID#&CFTOKEN=#url.CFTOKEN#&USID=#url.USID#&RID=#RandRange(1000000,9999999)#" ADDTOKEN="no"><cfelse><CFLOCATION url="index.cfm" ADDTOKEN="no"></cfif></cfif><cfinclude TEMPLATE="app_globals.cfm">

<!--- add hardcode --->
	<CFSET APPLICATION.DB_MODE = "DEV">
	<CFSET APPLICATION.APPLICATIONNAME = "IMS">
	<CFSET APPLICATION.MTRDSN = "claims_dev">	
	<CFSET APPLICATION.MTRPATH = "/ims/">
	<CFSET APPLICATION.LOGPATH = "/ims/">
	<CFSET APPLICATION.APPPATHCFC = "/">
	<cfset request.apppathcfc=APPLICATION.APPPATHCFC>
<!--- 
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<!--- this style needed for nav --->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"> --->