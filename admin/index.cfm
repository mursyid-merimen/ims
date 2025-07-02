<CFSWITCH expression="#fuseaction#">
    <CFCASE VALUE="dsp_addrecord">
        <CFMODULE TEMPLATE="..\header.cfm">
        <cfinvoke component="ims.admin.index" method="dsp_addrecord">
        <CFMODULE TEMPLATE="..\footer.cfm">
    </CFCASE>
    <CFCASE VALUE="dsp_home">
        <CFMODULE TEMPLATE="..\header.cfm">
        <cfinvoke component="ims.admin.index" method="dsp_home">
        <CFMODULE TEMPLATE="..\footer.cfm">
    </CFCASE>
    <CFCASE VALUE="act_deleterecord">
        <CFMODULE TEMPLATE="..\header.cfm">
        <cfinvoke component="ims.admin.index" method="act_deleterecord">
        <CFMODULE TEMPLATE="..\footer.cfm">
    </CFCASE>
    <CFCASE VALUE="dsp_details">
        <CFMODULE TEMPLATE="..\header.cfm">
        <cfinvoke component="ims.admin.index" method="dsp_details">
        <CFMODULE TEMPLATE="..\footer.cfm">
    </CFCASE>
    <CFCASE VALUE="dsp_form">
        <CFMODULE TEMPLATE="..\header.cfm">
        <cfinvoke component="ims.admin.index" method="dsp_form">
        <CFMODULE TEMPLATE="..\footer.cfm">
    </CFCASE>
    <CFCASE VALUE="act_upsertstaff">
        <CFMODULE TEMPLATE="..\header.cfm">
        <cfinvoke component="ims.admin.index" method="act_upsertstaff">
        <CFMODULE TEMPLATE="..\footer.cfm">
    </CFCASE>
    <CFCASE VALUE="dsp_upsertstaff">
        <CFMODULE TEMPLATE="..\header.cfm">
        <cfinvoke component="ims.admin.index" method="dsp_upsertstaff">
        <CFMODULE TEMPLATE="..\footer.cfm">
    </CFCASE>
    <CFCASE VALUE="dsp_stafflist">
        <CFMODULE TEMPLATE="..\header.cfm">
        <cfinvoke component="ims.admin.index" method="dsp_stafflist">
        <CFMODULE TEMPLATE="..\footer.cfm">
    </CFCASE>
</cfswitch>