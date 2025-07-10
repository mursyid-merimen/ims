<cfquery datasource="#request.MTRDSN#">
    INSERT INTO IMS_ITEMS (
        vaITEMNAME, vaITEMDESC, iTYPEID, vaSERIALNO, vaTAG,
        dtPURCHASED, vaBRAND, vaMODEL, vaLOCATION,
        siSTATUS, iCRTEDBY, dtCRTON
    )
    VALUES (
        <cfqueryparam value="#FORM.vaITEMNAME#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#FORM.vaITEMDESC#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#FORM.iTYPEID#" cfsqltype="cf_sql_integer">,
        <cfqueryparam value="#FORM.vaSERIALNO#" cfsqltype="cf_sql_varchar" null="#NOT LEN(Trim(FORM.vaSERIALNO))#">,
        <cfqueryparam value="#FORM.vaTAG#" cfsqltype="cf_sql_varchar" null="#NOT LEN(Trim(FORM.vaTAG))#">,
        <cfqueryparam value="#FORM.dtPURCHASED#" cfsqltype="cf_sql_date" null="#NOT LEN(Trim(FORM.dtPURCHASED))#">,
        <cfqueryparam value="#FORM.vaBRAND#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#FORM.vaMODEL#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#FORM.vaLOCATION#" cfsqltype="cf_sql_varchar">,
        1,
        <cfqueryparam value="#SESSION.USERID#" cfsqltype="cf_sql_integer">,
        <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">
    )
</cfquery>

<cflocation url="dsp_list.cfm">
