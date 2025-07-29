<CFMODULE TEMPLATE="#request.apppath#services/CustomTags\SVCDISABLEDIRECT.cfm" Path="#GetCurrentTemplatePath()#">
<cfinclude TEMPLATE="cffunctions.cfm">
<cfmodule TEMPLATE="#request.apppath#services/CustomTags\SVCADDFILE.cfm" FNAME="SVCTOOLBAR">
	<!--- <CFMODULE TEMPLATE="#request.apppath#services/CustomTags\SVCchkgrp.cfm" GrpList="42R" ChkRead=1> --->
<br>&nbsp;
<!--- <cfdump var="#Attributes#"> --->
<style>
.code {color:blue; font-family: 'courier sans ms'}
.quest { color:red;}
</style>

<!--- <cfdump var="#request.mtoken#"> --->
<script>
var request=new Object();

request.apppath="/";
request.approot="/";

sysdt=new Date();
</script>
<script src="/services/scripts/JQuery/jquery-3.7.1.min.js"></script> <script src="/services/scripts/unencoded/SVCmain.js"></script>  <link href="/services/scripts/SVCcss.css" rel=stylesheet type=text/css></link> 
<script>

	JSVCSetLocale(1);

function TestLocale(obj)
{
	window.location.href=request.approot+"services/formexample.cfm?locid="+obj.value;
}

</script>

<div class=clsNoPrint>
	<script>
		GenerateMenubar("ClaimMenu",90);
		AddToMenubar("ClaimMenu","<< " + JSVClang("Back",1057),"index.cfm?fusebox=admin&fuseaction=dsp_rptItem&"+request.mtoken);
		AddToMenubar("ClaimMenu",JSVClang("Process",9204),"JavaScript:ProcessReport()");
		<CFIF IsDefined("processrpt") AND processrpt IS 1>

			AddToMenubar("ClaimMenu",JSVClang("Download CSV",9204),"JavaScript:downloadCSV()");
		</CFIF>
		function ProcessReport()
			{
				<CFOUTPUT>
				
				if(RptFormVerify(StatRpt))
					window.location="index.cfm?fusebox=#Attributes.FUSEBOX#&fuseaction=#Attributes.FUSEACTION#<CFIF IsDefined("Attributes.RPTNAME")>&RPTNAME=#Attributes.RPTNAME#</cfif>&ProcessRpt=1&#request.mtoken#" + FormURLVAR(StatRpt);
				</cfoutput>
			}

		function downloadCSV() {
			// Create a form element
			var form = document.createElement("form");
			form.method = "post";
			form.target = "_blank";
			form.style.display = "none"; // Hide it

			// Add the hidden input
			var input = document.createElement("input");
			input.type = "hidden";
			input.name = "CsvDown";
			input.value = "1";
			form.appendChild(input);

			// Optional: set form action if needed
			// form.action = "your-download-endpoint.cfm";

			document.body.appendChild(form);
			form.submit();
			document.body.removeChild(form);
	}
	</script>
</div>

<FORM NAME="StatRpt">
	<CFMODULE TEMPLATE="#request.apppath#services/CustomTags\SVCDATERANGE.cfm">
<!--- <CFINCLUDE template="../../dsp_makes.cfm"> --->
</FORM>


<!--- <CFOUTPUT>
	#RptGenFilter("CSV File","CSV-DOWNLOAD","CsvDown")#
</CFOUTPUT> --->



<p class=clsRptSubTitle style=text-align:center>REPORT ON ASSET ASSIGNMENTS</br><cfoutput>#DRText#</cfoutput></p>
<CFIF IsDefined("processrpt") AND processrpt IS 1>
	<cfquery datasource="#Request.MTRDSN#" name="Query_GetIMSInfo">
		SELECT 
			a.iASGMTID,
			a.iITEMID,
			a.iUSID,
			a.dtASGNDON,
			a.vaREMARKS,
			a.siACTIVE,
      a.siSTATUS,
			YEAR(a.dtASGNDON) AS iYear,
			r.dtRETURNED,
      i.vaITEMNAME,
      i.vaTAG,
      i.vaSERIALNO,
      i.vaBRAND,
      i.vaMODEL,
      u.vaUSNAME
		FROM IMS_ASGMT a WITH (NOLOCK)
		LEFT JOIN IMS_RET r ON a.iASGMTID = r.iASGMTID
    LEFT JOIN IMS_ITEMS i ON a.iITEMID = i.iITEMID
    LEFT JOIN SEC0001 u ON a.iUSID = u.iUSID
		WHERE 
			a.dtASGNDON >= <cfqueryparam value="#DrFromStr#" cfsqltype="CF_SQL_TIMESTAMP"> 
			AND a.dtASGNDON < DATEADD(day, 1, <cfqueryparam value="#DrToStr#" cfsqltype="CF_SQL_TIMESTAMP">)
      AND a.siSTATUS = 0
			AND r.siSTATUS = 0
		ORDER BY 
			a.dtASGNDON
	</cfquery>

	



	<cfif Query_GetIMSInfo.recordcount GT 0>
    <table border="1" align="center" cellpadding="4" cellspacing="0" style="width:90%; font-size:90%;">
        <thead>
            <tr class="clsColumnHeader">
                <th>Tag</th>
								<th>Item</th>
                <th>Brand</th>
                <th>Model</th>
                <th>Assigned To</th>
                <th>Status</th>
                <th>Assigned Date</th>
                <th>Return Date</th>

            </tr>
        </thead>
        <tbody>
            <cfoutput query="Query_GetIMSInfo">
                <tr>
                    <td>#vaTAG#</td>
										<td>#vaITEMNAME#</td>
                    <td>#vaBRAND#</td>
                    <td>#vaMODEL#</td>
                    <td>#vaUSNAME#</td>
                    <td>
											<cfif siACTIVE EQ 1>
												Active
											<cfelse>
												Returned
											</cfif>
										</td>

                    <td>#DateFormat(dtASGNDON, "yyyy-mm-dd")#</td>
                    <td>#DateFormat(dtRETURNED, "yyyy-mm-dd")#</td>
                </tr>
            </cfoutput>
        </tbody>
    </table>
    <br>
    <table border="0" align="center" cellpadding="1" cellspacing="0" style="width:90%; font-size:90%;">
        <tr class="clsRptNote">
            <td colspan="2"><strong>Note:</strong> Items listed above were filtered based on the <strong>Purchase Date</strong> range you selected.</td>
        </tr>
    </table>

<cfelse>
    <table border="0" align="center" cellpadding="4" cellspacing="0" style="width:90%;">
        <tr><td>There are no items matching the selected criteria.</td></tr>
    </table>
</cfif>
</CFIF>


<!--- <cfdump var="#request.apppathcfc#"> --->
<cfif isDefined("CsvDown") AND CsvDown EQ 1>
	<!--- Debug log --->
	<script>
		console.log("CSV download requested");
	</script>

	<!--- Initialize CSV object --->
	<cfset obj = createObject("component", "#Request.APPPATHCFC#services.cfc.QuickCSV").init()>

	<!--- Set header row to match the visible HTML table --->
	<cfset obj.setHeader('"Tag","Item","Brand","Model","Assigned To","Status","Assigned Date","Return Date"')>

	<!--- Loop through query and add rows --->
	<cfoutput query="Query_GetIMSInfo">
		<cfset status = siACTIVE EQ 1 ? "Active" : "Returned">
		<cfset assignedDate = isDate(dtASGNDON) ? request.ds.fn.SVCdtDBtoLOC(dtASGNDON,'','short') : "">
		<cfset returnDate = isDate(dtRETURNED) ? request.ds.fn.SVCdtDBtoLOC(dtRETURNED,'','short') : "">

		<cfset obj.addRow(
			'"#vaTAG#","#vaITEMNAME#","#vaBRAND#","#vaMODEL#","#vaUSNAME#","#status#","#assignedDate#","#returnDate#"'
		)>
	</cfoutput>

	<!--- Trigger download --->
	<cfset obj.download("IMS_Report_Asset_Assignments")>
	<cfexit METHOD="EXITTEMPLATE">
</cfif>






