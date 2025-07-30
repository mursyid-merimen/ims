<cfparam name="form.operation" default="">
<cfset operation = ucase(trim(form.operation))>
<!--- <cfdump var="#form#">
<cfdump var="#Application.TMPDIR#"> --->
<!--- <cfabort> --->

<!-- Validation -->
<cfif operation EQ "ASSIGN" AND structKeyExists(form, "iITEMID") AND structKeyExists(form, "iUSID")>
  <!--- upload doc --->
    <cfstoredproc procedure="sspIMSAsgnRet" datasource="#request.MTRDSN#" returncode="yes">
      <cfprocparam type="in" dbvarname="@as_operation" value="ASSIGN" cfsqltype="cf_sql_nvarchar">
      <cfprocparam type="in" dbvarname="@ai_itemid" value="#form.iITEMID#" cfsqltype="cf_sql_integer">
      <cfprocparam type="in" dbvarname="@ai_userid" value="#form.iUSID#" cfsqltype="cf_sql_integer">
      <cfprocparam type="in" dbvarname="@ad_asgndon" value="#form.dtASGNDON#" cfsqltype="cf_sql_date">
      <cfprocparam type="in" dbvarname="@as_remarks" value="#form.vaREMARKS#" cfsqltype="cf_sql_nvarchar">
      <cfprocparam type="in" dbvarname="@ai_crtby" value="#SESSION.VARS.USID#" cfsqltype="cf_sql_integer">
      <cfprocparam type="out" dbvarname="@ao_asgmtid" cfsqltype="cf_sql_integer" variable="newAsgmtID">
      <cfprocparam type="out" dbvarname="@ao_retid" cfsqltype="cf_sql_integer" variable="newRetID">
    </cfstoredproc>

    <cfif len(FORM.FNDOCUP)>
      <!--- AND structKeyExists(FORM.FNDOCUP, "filename") 
      AND len(trim(FORM.FNDOCUP.filename))> --->

      <!--- <cfdump var="#FORM.FNDOCUP#">
      <cfabort> --->
      
      <!-- File was uploaded, safe to call module -->
      <cfmodule template="#request.apppath#services/index.cfm" 
          FUSEBOX="SVCdoc" 
          FUSEACTION="ACT_DOCEDIT" 
          

          DOMAINID="1"
          <!--- OWNER ID --->
          OBJID="#newAsgmtID#" 
          CRTCOROLE="-1" 
          <!--- DOCUMENT DEFINITION --->
          DOCDEFID="32" 
          DOCSTAT="3" 
          CRTCOSECPOS="1" 
          UPLOADNAME="Form.FNDOCUP" 
          DOCDESC=#evaluate("FORM.ONMDOCUP")#
          NOHEADER>
    </cfif>
    

    

    

    <cfif cfstoredproc.statusCode EQ 1>
        <cflocation url="index.cfm?fusebox=admin&fuseaction=dsp_listassign&#Request.MToken#">
    <cfelse>
        <cfthrow TYPE="EX_DBERROR" ErrorCode="DBERROR">
    </cfif>

<cfelseif operation EQ "RETURN" AND structKeyExists(form, "iASGMTID")>
    <cfstoredproc procedure="sspIMSAsgnRet" datasource="#request.MTRDSN#" returncode="yes">
        <cfprocparam type="in" dbvarname="@as_operation" cfsqltype="cf_sql_nvarchar" value="RETURN">
        <cfprocparam type="in" dbvarname="@ai_asgmtid" cfsqltype="cf_sql_integer" value="#form.iASGMTID#">
        <cfprocparam type="in" dbvarname="@ad_returned" cfsqltype="cf_sql_date" value="#form.dtRETURNED#">
        <cfprocparam type="in" dbvarname="@as_condition" cfsqltype="cf_sql_nvarchar" value="#form.vaCONDITION#">
        <cfprocparam type="in" dbvarname="@as_comments" cfsqltype="cf_sql_nvarchar" value="#form.vaCOMMENTS#">
        <cfprocparam type="in" dbvarname="@ai_crtby" cfsqltype="cf_sql_integer" value="#session.vars.USID#">
        <cfprocparam type="out" dbvarname="@ao_asgmtid" cfsqltype="cf_sql_integer" variable="newAsgmtID">
        <cfprocparam type="out" dbvarname="@ao_retid" cfsqltype="cf_sql_integer" variable="newRetID">
    </cfstoredproc>

    <cfif len(FORM.FNDOCUP)>
      
      <!-- File was uploaded, safe to call module -->
      <cfmodule template="#request.apppath#services/index.cfm" 
          FUSEBOX="SVCdoc" 
          FUSEACTION="ACT_DOCEDIT" 
          

          DOMAINID="1"
          <!--- OWNER ID --->
          OBJID="#newRetID#" 
          CRTCOROLE="-1" 
          <!--- DOCUMENT DEFINITION --->
          DOCDEFID="32" 
          DOCSTAT="3" 
          CRTCOSECPOS="1" 
          UPLOADNAME="Form.FNDOCUP" 
          DOCDESC="Return Document"
          NOHEADER>
    </cfif>

    <cfif cfstoredproc.statusCode EQ 1>
        <cflocation url="index.cfm?fusebox=admin&fuseaction=dsp_listassign&#Request.MToken#">
    <cfelse>
        <cfthrow TYPE="EX_DBERROR" ErrorCode="DBERROR">
    </cfif>

<cfelse>
    <cfoutput><div class="alert alert-warning">Invalid or incomplete form submission.</div></cfoutput>
</cfif>
