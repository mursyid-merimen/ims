<cfquery datasource="#request.MTRDSN#">
    UPDATE IMS_ITEMS SET
        vaITEMNAME = <cfqueryparam value="#FORM.vaITEMNAME#" cfsqltype="cf_sql_varchar">,
        vaITEMDESC = <cfqueryparam value="#FORM.vaITEMDESC#" cfsqltype="cf_sql_varchar">,
        iTYPEID = <cfqueryparam value="#FORM.iTYPEID#" cfsqltype="cf_sql_integer">,
        vaSERIALNO = <cfqueryparam value="#FORM.vaSERIALNO#" cfsqltype="cf_sql_varchar" null="#NOT LEN(Trim(FORM.vaSERIALNO))#">,
        vaTAG = <cfqueryparam value="#FORM.vaTAG#" cfsqltype="cf_sql_varchar" null="#NOT LEN(Trim(FORM.vaTAG))#">,
        dtPURCHASED = <cfqueryparam value="#FORM.dtPURCHASED#" cfsqltype="cf_sql_date" null="#NOT LEN(Trim(FORM.dtPURCHASED))#">,
        vaBRAND = <cfqueryparam value="#FORM.vaBRAND#" cfsqltype="cf_sql_varchar">,
        vaMODEL = <cfqueryparam value="#FORM.vaMODEL#" cfsqltype="cf_sql_varchar">,
        vaLOCATION = <cfqueryparam value="#FORM.vaLOCATION#" cfsqltype="cf_sql_varchar">,
        iMODBY = <cfqueryparam value="#SESSION.USERID#" cfsqltype="cf_sql_integer">,
        dtMODON = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">
    WHERE iITEMID = <cfqueryparam value="#FORM.iITEMID#" cfsqltype="cf_sql_integer">
</cfquery>

<cflocation url="dsp_list.cfm">
