<cfparam name="attributes.iUSID" default="0">

<cfdump var="#attributes#" label="Attributes for Deleting Staff">
<!--- <cfabort> --->

<cfif NOT IsNumeric(attributes.iUSID) OR attributes.iUSID EQ 0>
    <cfoutput><div class="alert alert-danger">Invalid user ID.</div></cfoutput>
    <cfabort>
</cfif>

<cfquery name="runDelUsr" datasource="#Request.MTRDSN#">
    DECLARE @retCF integer = 0;
    DECLARE @cresult integer;
    DECLARE @rcuusid integer = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.iUSID#">;
    DECLARE @vusridlist nvarchar(max) = '';

    SET @vusridlist += CAST(@rcuusid AS nvarchar(100)) + ',';

    EXECUTE @cresult = sspFSECUserProfile 
        @ai_usid = @rcuusid, 
        @ai_byusid = 1, 
        @asi_status = 1;

    IF (@cresult < 0 OR @@ERROR <> 0)
    BEGIN
        SET @retCF = @cresult;
        RAISERROR ('Error deleting user', 11, 1);
    END

    SELECT ret = @retCF, ulist = @vusridlist;
</cfquery>

<cfif runDelUsr.ret LT 0>
    <cfoutput><div class="alert alert-danger">Error occurred deleting user.</div></cfoutput>
<cfelse>
    <!--- redirect or display success --->
    <cflocation url="index.cfm?fusebox=admin&fuseaction=home" addtoken="no">
</cfif>
