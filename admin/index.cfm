<!--- <cfdump var="#attributes#"> --->
<cfset attributes.COID = 1>
<!--- find user and role to hide path --->
<cfquery name="q_users" datasource="#Request.MTRDSN#">
    SELECT 
        u.vaUSID,
        u.siROLE,
        r.siROLE,
        r.vaDESC

    FROM SEC0001 u WITH (NOLOCK)
    LEFT JOIN SEC0002 r ON u.siROLE = r.siROLE
    WHERE u.iCOID = <cfqueryparam value="#attributes.COID#" cfsqltype="CF_SQL_INTEGER">
    AND iUSID = <cfqueryparam value="#session.vars.USID#" cfsqltype="cf_sql_integer">
</cfquery>

<!--- Set isAdmin flag --->
<cfset isAdmin = (trim(q_users.vaDESC) EQ "Administrator")>

<!--- List of fuseactions that only admin can access --->
<cfset adminOnlyFuseactions = "act_upsertstaff,dsp_upsertstaff,dsp_stafflist,act_userprofile,act_deletestaff">
<!--- <cfoutput>
<pre>
fuseaction: #fuseaction#
isAdmin: #isAdmin#
q_users.recordCount: #q_users.recordCount#
roleDesc: #q_users.roleDesc#
</pre>
</cfoutput> --->

<!--- If fuseaction is admin-only and user is not admin, deny access --->
<cfif ListFindNoCase(adminOnlyFuseactions, fuseaction) AND NOT isAdmin>
    <cfthrow TYPE="EX_SECFAILED" ErrorCode="CANNOTWRITE">
</cfif>

<CFSWITCH expression="#fuseaction#">

    <CFCASE VALUE="act_upsertstaff">
        <CFMODULE TEMPLATE="..\header.cfm">
        <cfinvoke component="ims.admin.index" method="act_upsertstaff" ArgumentCollection="#Attributes#">
        <CFMODULE TEMPLATE="..\footer.cfm">
    </CFCASE>
    <CFCASE VALUE="dsp_upsertstaff">
        <CFMODULE TEMPLATE="..\header.cfm">
        <cfinvoke component="ims.admin.index" method="dsp_upsertstaff" ArgumentCollection="#Attributes#">
        <CFMODULE TEMPLATE="..\footer.cfm">
    </CFCASE>
    <CFCASE VALUE="dsp_stafflist">
        <CFMODULE TEMPLATE="..\header.cfm">
        <cfinvoke component="ims.admin.index" method="dsp_stafflist" ArgumentCollection="#Attributes#">
        <CFMODULE TEMPLATE="..\footer.cfm">
    </CFCASE>
    <CFCASE VALUE="act_userprofile">
        <CFMODULE TEMPLATE="..\header.cfm">
        <cfinvoke component="ims.admin.index" method="act_userprofile" ArgumentCollection="#Attributes#">
        <CFMODULE TEMPLATE="..\footer.cfm">
    </CFCASE>
    <CFCASE VALUE="act_deletestaff">
        <CFMODULE TEMPLATE="..\header.cfm">
        <cfinvoke component="ims.admin.index" method="act_deletestaff" ArgumentCollection="#Attributes#">
        <CFMODULE TEMPLATE="..\footer.cfm">
    </CFCASE>
    
        

    
    

    <!--- TYPE --->
    <CFCASE VALUE="dsp_listtype">
        <CFMODULE TEMPLATE="..\header.cfm">
        <cfinvoke component="ims.admin.index" method="dsp_listtype" ArgumentCollection="#Attributes#">
        <CFMODULE TEMPLATE="..\footer.cfm">
    </CFCASE>
    <CFCASE VALUE="dsp_formtype">
        <CFMODULE TEMPLATE="..\header.cfm">
        <cfinvoke component="ims.admin.index" method="dsp_formtype" ArgumentCollection="#Attributes#">
        <CFMODULE TEMPLATE="..\footer.cfm">
    </CFCASE>
    <CFCASE VALUE="act_type">
        <CFMODULE TEMPLATE="..\header.cfm">
        <cfinvoke component="ims.admin.index" method="act_type" ArgumentCollection="#Attributes#">
        <CFMODULE TEMPLATE="..\footer.cfm">
    </CFCASE>
    

    <!--- ITEM --->
    <CFCASE VALUE="dsp_listitem">
        <CFMODULE TEMPLATE="..\header.cfm">
        <cfinvoke component="ims.admin.index" method="dsp_listitem" ArgumentCollection="#Attributes#">
        <CFMODULE TEMPLATE="..\footer.cfm">
    </CFCASE>
    <CFCASE VALUE="dsp_formitem">
        <CFMODULE TEMPLATE="..\header.cfm">
        <cfinvoke component="ims.admin.index" method="dsp_formitem" ArgumentCollection="#Attributes#">
        <CFMODULE TEMPLATE="..\footer.cfm">
    </CFCASE>
    <CFCASE VALUE="act_item">
        <CFMODULE TEMPLATE="..\header.cfm">
        <cfinvoke component="ims.admin.index" method="act_item" ArgumentCollection="#Attributes#">
        <CFMODULE TEMPLATE="..\footer.cfm">
    </CFCASE>
    

    <!--- THRESHOLD --->
    <CFCASE VALUE="dsp_listthresh">
        <CFMODULE TEMPLATE="..\header.cfm">
        <cfinvoke component="ims.admin.index" method="dsp_listthresh" ArgumentCollection="#Attributes#">
        <CFMODULE TEMPLATE="..\footer.cfm">
    </CFCASE>
    <CFCASE VALUE="dsp_formthresh">
        <CFMODULE TEMPLATE="..\header.cfm">
        <cfinvoke component="ims.admin.index" method="dsp_formthresh" ArgumentCollection="#Attributes#">
        <CFMODULE TEMPLATE="..\footer.cfm">
    </CFCASE>
    <CFCASE VALUE="act_editthresh">
        <CFMODULE TEMPLATE="..\header.cfm">
        <cfinvoke component="ims.admin.index" method="act_editthresh" ArgumentCollection="#Attributes#">
        <CFMODULE TEMPLATE="..\footer.cfm">
    </CFCASE>

    <!--- ASSIGN --->
    <CFCASE VALUE="dsp_assign">
        <CFMODULE TEMPLATE="..\header.cfm">
        <cfinvoke component="ims.admin.index" method="dsp_assign" ArgumentCollection="#Attributes#">
        <CFMODULE TEMPLATE="..\footer.cfm">
    </CFCASE>
    <CFCASE VALUE="dsp_return">
        <CFMODULE TEMPLATE="..\header.cfm">
        <cfinvoke component="ims.admin.index" method="dsp_return" ArgumentCollection="#Attributes#">
        <CFMODULE TEMPLATE="..\footer.cfm">
    </CFCASE>
    <CFCASE VALUE="dsp_listassign">
        <CFMODULE TEMPLATE="..\header.cfm">
        <cfinvoke component="ims.admin.index" method="dsp_listassign" ArgumentCollection="#Attributes#">
        <CFMODULE TEMPLATE="..\footer.cfm">
    </CFCASE>
    <CFCASE VALUE="act_assign">
        <CFMODULE TEMPLATE="..\header.cfm">
        <cfinvoke component="ims.admin.index" method="act_assign" ArgumentCollection="#Attributes#">
        <CFMODULE TEMPLATE="..\footer.cfm">
    </CFCASE>
    <CFCASE VALUE="dsp_getfile">
        <CFMODULE TEMPLATE="..\header.cfm">
        <cfinvoke component="ims.admin.index" method="dsp_getfile" ArgumentCollection="#Attributes#">
        <CFMODULE TEMPLATE="..\footer.cfm">
    </CFCASE>
    <CFCASE VALUE="dsp_itemhistory">
        <CFMODULE TEMPLATE="..\header.cfm">
        <cfinvoke component="ims.admin.index" method="dsp_itemhistory" ArgumentCollection="#Attributes#">
        <CFMODULE TEMPLATE="..\footer.cfm">
    </CFCASE>
    

    <!--- REPORT --->
    <CFCASE VALUE="dsp_rptItem">
        <CFMODULE TEMPLATE="..\header.cfm">
        <cfinvoke component="ims.admin.index" method="dsp_rptItem" ArgumentCollection="#Attributes#">
        <CFMODULE TEMPLATE="..\footer.cfm">
    </CFCASE>
    <CFCASE VALUE="dsp_rptAsgmt">
        <CFMODULE TEMPLATE="..\header.cfm">
        <cfinvoke component="ims.admin.index" method="dsp_rptAsgmt" ArgumentCollection="#Attributes#">
        <CFMODULE TEMPLATE="..\footer.cfm">
    </CFCASE>
</cfswitch>

