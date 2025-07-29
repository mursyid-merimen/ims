<cfmodule TEMPLATE="/services/CustomTags\SVCDISABLEDIRECT.cfm" Path="#GetCurrentTemplatePath()#">

<!--- <cfdump var="#Attributes#"> --->
<!--- <cfdump var="#session#" label="Session Variables"> --->
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


<cfquery name="q_dashboard" datasource="#Request.MTRDSN#">
    SELECT 
        t.iTYPEID,
        t.vaTYPENAME,
        th.nMINQTY,
        th.nMAXQTY,
        COUNT(i.iITEMID) AS ItemCount
    FROM 
        IMS_TYPES t
    LEFT JOIN 
        IMS_THRESH th ON t.iTYPEID = th.iTYPEID AND th.siSTATUS = 0
    LEFT JOIN 
        IMS_ITEMS i ON t.iTYPEID = i.iTYPEID AND i.siSTATUS = 0
		WHERE 
				t.siSTATUS = 0
    GROUP BY 
        t.iTYPEID, t.vaTYPENAME, th.nMINQTY, th.nMAXQTY
    ORDER BY 
        t.vaTYPENAME
</cfquery>

<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1"> 
  <script src="https://code.jquery.com/jquery-2.1.3.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/chart.js@3.9.1/dist/chart.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-annotation@1.4.0/dist/chartjs-plugin-annotation.min.js"></script>



</head>
<body>

    <h2>Inventory Threshold Overview</h2>

    <style>
      .chart-grid {
        display: inline-block;
        width: 32%;
        margin: 0.5%;
        vertical-align: top;
      }

      .chart-row {
        display: flex;
        justify-content: center;
        margin: 0.5%;
        flex-wrap: wrap;
        margin-bottom: 1rem;
      }
    </style>

    <cfset chartCounter = 0>

    <cfoutput query="q_dashboard">
      <!--- Start new row every 3 charts --->
      <cfif chartCounter MOD 3 EQ 0>
        <div class="chart-row">
      </cfif>

      <div class="chart-grid">
        <h4>#vaTYPENAME#</h4>
        <canvas id="chart_#iTYPEID#" ></canvas>
      </div>

      <!--- End row after 3rd chart --->
      <cfif chartCounter MOD 3 EQ 2 OR q_dashboard.currentRow EQ q_dashboard.recordCount>
        </div>
      </cfif>

      <cfset chartCounter = chartCounter + 1>
    </cfoutput>


    <script>
      <cfoutput query="q_dashboard">
        const ctx_#iTYPEID# = document.getElementById('chart_#iTYPEID#').getContext('2d');

        const itemCount_#iTYPEID# = [#ItemCount#];
        const minThreshold_#iTYPEID# = #nMINQTY#;
        const maxThreshold_#iTYPEID# = #nMAXQTY#;

        new Chart(ctx_#iTYPEID#, {
          type: 'bar',
          data: {
            labels: ['#vaTYPENAME#'],
            datasets: [{
              label: 'Item Count',
              data: itemCount_#iTYPEID#,
              backgroundColor: 'rgba(54, 162, 235, 0.8)',
              borderWidth: 1
            }]
          },
          options: {
            responsive: true,
            plugins: {
              title: {
                display: true,
                text: 'Item Usage vs Threshold'
              },
              annotation: {
                annotations: {
                  maxLine: {
                    type: 'line',
                    yMin: maxThreshold_#iTYPEID#,
                    yMax: maxThreshold_#iTYPEID#,
                    borderColor: 'rgb(255, 99, 132)',
                    borderWidth: 2,
                    label: {
                      content: 'Max Threshold',
                      enabled: true,
                      position: 'end'
                    }
                  },
                  minLine: {
                    type: 'line',
                    yMin: minThreshold_#iTYPEID#,
                    yMax: minThreshold_#iTYPEID#,
                    borderColor: 'rgb(75, 192, 192)',
                    borderWidth: 2,
                    label: {
                      content: 'Min Threshold',
                      enabled: true,
                      position: 'end'
                    }
                  }
                }
              }
            },
            scales: {
              y: {
                beginAtZero: true,
                suggestedMax: Math.max(itemCount_#iTYPEID#[0], minThreshold_#iTYPEID#, maxThreshold_#iTYPEID#) + 10
              }
            }
          }
        });
        </cfoutput>

    </script>
    

</body>
</html>







