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



<p class=clsRptSubTitle style=text-align:center>REPORT ON ITEMS</br><cfoutput>#DRText#</cfoutput></p>
<CFIF IsDefined("processrpt") AND processrpt IS 1>
	<cfquery datasource="#Request.MTRDSN#" name="Query_GetIMSInfo">
		SELECT 
			i.vaITEMNAME,
			i.vaTAG,
			i.iTYPEID,
			i.vaSERIALNO,
			i.vaBRAND,
			i.vaMODEL,
			i.vaLOCATION,
			i.dtPURCHASED,
			YEAR(i.dtPURCHASED) AS iYear,
			t.vaTYPENAME AS type_name
		FROM IMS_ITEMS i WITH (NOLOCK)
		LEFT JOIN IMS_TYPES t ON i.iTYPEID = t.iTYPEID
		WHERE 
			i.dtPURCHASED >= <cfqueryparam value="#DrFromStr#" cfsqltype="CF_SQL_TIMESTAMP"> 
			AND i.dtPURCHASED < DATEADD(day, 1, <cfqueryparam value="#DrToStr#" cfsqltype="CF_SQL_TIMESTAMP">)
		ORDER BY 
			i.vaBRAND, i.vaMODEL, i.dtPURCHASED
	</cfquery>

	



	<cfif Query_GetIMSInfo.recordcount GT 0>
    <table border="1" align="center" cellpadding="4" cellspacing="0" style="width:90%; font-size:90%;">
        <thead>
            <tr class="clsColumnHeader">
                <th>Item Name</th>
								<th>Type</th>
                <th>Brand</th>
                <th>Model</th>
                <th>Tag</th>
                <th>Serial No</th>
                <th>Location</th>
                <th>Year Purchased</th>
                <th>Date Purchased</th>
            </tr>
        </thead>
        <tbody>
            <cfoutput query="Query_GetIMSInfo">
                <tr>
                    <td>#vaITEMNAME#</td>
										<td>#type_name#</td>
                    <td>#vaBRAND#</td>
                    <td>#vaMODEL#</td>
                    <td>#vaTAG#</td>
                    <td>#vaSERIALNO#</td>
                    <td>#vaLOCATION#</td>
                    <td>#iYear#</td>
                    <td>#DateFormat(dtPURCHASED, "yyyy-mm-dd")#</td>
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
	<script>
		console.log("CSV download requested");
	</script>
	<!--- Initialize CSV object --->
	<cfset obj = createObject("component", "#Request.APPPATHCFC#services.cfc.QuickCSV").init()>

	<!--- Set header row --->
	<cfset obj.setHeader('"Item Name","Type Name","Brand","Model","Tag","Serial No","Location","Purchase Year","Purchase Date"')>

	<!--- Loop through query and add rows --->
	<cfoutput query="Query_GetIMSInfo">
			<cfset obj.addRow(
					'"#vaITEMNAME#","#type_name#","#vaBRAND#","#vaMODEL#","#vaTAG#","#vaSERIALNO#","#vaLOCATION#","#iYear#","#request.ds.fn.SVCdtDBtoLOC(dtPURCHASED,'','short')#"'
			)>
	</cfoutput>

	<!--- Trigger download --->
	<cfset obj.download("IMS_Report_Items")>
	<cfexit METHOD=EXITTEMPLATE>
</cfif>





