<cfparam name="attributes.ITEMID" default="">

<cfquery name="q_history" datasource="#Request.MTRDSN#">
    SELECT 
        a.iASGMTID,
        a.iITEMID,
        a.dtASGNDON,
        r.iRETID,
        r.dtRETURNED,
        r.vaCONDITION,
        DATEDIFF(DAY, a.dtASGNDON, r.dtRETURNED) AS DurationDays,
        a.iUSID,
        s.vaUSID
    FROM 
        IMS_ASGMT a
    LEFT JOIN 
        IMS_RET r ON a.iASGMTID = r.iASGMTID
    LEFT JOIN 
        SEC0001 s ON a.iUSID = s.iUSID
    WHERE 
        a.iITEMID = <cfqueryparam value="#attributes.ITEMID#" cfsqltype="cf_sql_integer">
        AND a.siSTATUS = 0
    ORDER BY 
        a.dtASGNDON DESC
</cfquery>



<cfoutput>
<h2>Assignment History</h2>

<div class="mb-3 d-flex flex-wrap gap-3 align-items-end justify-content-center" style="width: fit-content; margin: 0 auto;">
    
    <div class="form-group">
        <label for="filterUsername">Username:</label>
        <input type="text" id="filterUsername" class="form-control" placeholder="Search Username">
    </div>

    

</div>
<cfset cfData=[]>
<table class="table table-bordered table-striped">
    <thead>
        <tr>
            <th>Assigned To</th>
            <th>Assignment Date</th>
            <th>Return Date</th>
            <th>Duration (Days)</th>
            <th>Asset Transfer Document</th>
            <th>Asset Return Document</th>
        </tr>
    </thead>
    <tbody id="tableBody">
        <cfif q_history.recordCount EQ 0>
            <tr><td colspan="4">No history found for this item.</td></tr>
        <cfelse>
            <cfloop query="q_history">
                <cfquery name="q_assignmentdoc" datasource="#Request.MTRDSN#" result="result">
                    SELECT MAX(IDOCID) AS LATESTIDOCID, VADOCDESC
                    FROM FDOC3003 a with (nolock)
                    WHERE IOBJID = <cfqueryparam value=#q_history.iASGMTID# cfsqltype="CF_SQL_INTEGER">
                    AND IDOCDEFID = 32
                    
                    GROUP BY VADOCDESC
                </cfquery>
                <cfset returnDocID = "">
                <cfset returnDocDesc = "">
                <cfif len(q_history.iRETID)>
                    <cfquery name="q_returndoc" datasource="#Request.MTRDSN#" result="result">
                        SELECT MAX(IDOCID) AS LATESTIDOCID, VADOCDESC
                        FROM FDOC3003 a with (nolock)
                        WHERE IOBJID = <cfqueryparam value=#q_history.iRETID# cfsqltype="CF_SQL_INTEGER">
                        AND IDOCDEFID = 32
                        GROUP BY VADOCDESC
                    </cfquery>
                    <cfset returnDocID = q_returndoc.LATESTIDOCID>
                    <cfset returnDocDesc = q_returndoc.VADOCDESC>
                <cfelse>
                    <cfset q_returndoc = StructNew()>
                    <cfset q_returndoc.LATESTIDOCID = "">
                    <cfset q_returndoc.VADOCDESC = "">
                </cfif>
                <cfset ArrayAppend(cfData, {
                    "iASGMTID": q_history.iASGMTID,
                    "iITEMID": q_history.iITEMID,
                    "dtASGNDON": DateFormat(q_history.dtASGNDON, "yyyy-mm-dd"),
                    "dtRETURNED": len(q_history.dtRETURNED) ? DateFormat(q_history.dtRETURNED, "yyyy-mm-dd") : "",
                    "DurationDays": len(q_history.dtRETURNED) ? q_history.DurationDays : "",
                    "vaUSID": q_history.vaUSID,
                    "assignmentDocID": q_assignmentdoc.LATESTIDOCID,
                    "assignDesc": q_assignmentdoc.VADOCDESC,
                    "returnDocID": returnDocID,
                    "returnDesc": returnDocDesc
                })>
                <tr>
                    <td>#vaUSID#</td>
                    <td>#DateFormat(dtASGNDON, "dd-mmm-yyyy")#</td>
                    <td>
                        <cfif len(dtRETURNED)>
                            #DateFormat(dtRETURNED, "dd-mmm-yyyy")#
                        <cfelse>
                            <span class="text-warning">Not Returned</span>
                        </cfif>
                    </td>
                    <td>
                        <cfif len(dtRETURNED)>
                            #DurationDays#
                        <cfelse>
                            <span class="text-muted">N/A</span>
                        </cfif>
                    </td>
                    <td>
                        <cfif len(trim(q_assignmentdoc.LATESTIDOCID)) AND trim(lcase(q_assignmentdoc.VADOCDESC)) EQ "Assignment Document">
                            <a href="#request.webroot#index.cfm?fusebox=admin&fuseaction=dsp_getfile&corole=1&cosecpos=1&ftype=2&docid=#q_assignmentdoc.LATESTIDOCID#&#request.mtoken#" target="_blank">View</a>
                        <cfelse>
                            <span class="text-muted">N/A</span>
                        </cfif>

                    </td>
                    <td>
                        <cfif len(trim(q_returndoc.LATESTIDOCID)) AND trim(lcase(q_returndoc.VADOCDESC)) EQ "Return Document">
                            <a href="#request.webroot#index.cfm?fusebox=admin&fuseaction=dsp_getfile&corole=1&cosecpos=1&ftype=2&docid=#q_returndoc.LATESTIDOCID#&#request.mtoken#" target="_blank">View</a>
                        <cfelse>
                            <span class="text-muted">N/A</span>
                        </cfif>

                    </td>

                </tr>
            </cfloop>
        </cfif>
    </tbody>
</table>
<div id="pagination" style="text-align:center;"></div>
<!--- <cfdump var="#cfData#" label="cfData" abort="true" /> --->

</cfoutput>


<script type="text/javascript" language="JavaScript">
    // Convert cfData to JSON string and parse it
    var jsonString = '<cfoutput>#serializeJSON(cfData)#</cfoutput>';
    var cfData = JSON.parse(jsonString);

    
    console.log(cfData);
    const rowsPerPage = 10;
    let currentPage = 1;

    function filterData(){
        const UsernameVal = document.getElementById('filterUsername').value.toLowerCase();

        return cfData.filter(item => {
            return (
                item.vaUSID.toLowerCase().includes(UsernameVal)
            );
        });
    }

    function displayTable(page = 1) {
    const tableBody = document.getElementById("tableBody");
    tableBody.innerHTML = "";

    const filteredData = filterData();
    const startIndex = (page - 1) * rowsPerPage;
    const endIndex = startIndex + rowsPerPage;
    const paginatedData = filteredData.slice(startIndex, endIndex);

    if (paginatedData.length === 0) {
        const noDataRow = document.createElement("tr");
        noDataRow.innerHTML = `<td colspan="6" class="text-center">No history found for this item.</td>`;
        tableBody.appendChild(noDataRow);
        updatePagination(0, page);
        return;
    }

    paginatedData.forEach(item => {
        <cfoutput>

            const row = document.createElement("tr");
    
            const assignmentDoc = item.assignmentDocID && item.assignDesc?.toLowerCase() === "assignment document"
                ? `<a href="index.cfm?fusebox=admin&fuseaction=dsp_getfile&corole=1&cosecpos=1&ftype=2&docid=${item.assignmentDocID}&#request.mtoken#" target="_blank">View</a>`
                : `<span class="text-muted">N/A</span>`;
    
            const returnDoc = item.returnDocID && item.returnDesc?.toLowerCase() === "return document"
                ? `<a href="index.cfm?fusebox=admin&fuseaction=dsp_getfile&corole=1&cosecpos=1&ftype=2&docid=${item.returnDocID}&#request.mtoken#" target="_blank">View</a>`
                : `<span class="text-muted">N/A</span>`;
    
            row.innerHTML = `
                <td>${item.vaUSID}</td>
                <td>${item.dtASGNDON}</td>
                <td>${item.dtRETURNED || '<span class="text-warning">Not Returned</span>'}</td>
                <td>${item.dtRETURNED ? item.DurationDays : '<span class="text-muted">N/A</span>'}</td>
                <td>${assignmentDoc}</td>
                <td>${returnDoc}</td>
            `;
        </cfoutput>

        tableBody.appendChild(row);
    });

    updatePagination(filteredData.length, page);
}


    function updatePagination(totalItems, currentPage) {
        const pagination = document.getElementById("pagination");
        pagination.innerHTML = "";

        const pageCount = Math.ceil(totalItems / rowsPerPage);
        for (let i = 1; i <= pageCount; i++) {
            const link = document.createElement("a");
            link.href = "#";
            link.innerText = i;
            link.style.margin = "0 5px";
            link.style.fontWeight = i === currentPage ? "bold" : "normal";
            link.onclick = (e) => {
                e.preventDefault();
                displayTable(i);
            };
            pagination.appendChild(link);
        }
    }
    document.addEventListener('DOMContentLoaded', function () {
        const inputs = [
            'filterUsername'
        ];

        inputs.forEach(id => {
            document.getElementById(id).addEventListener('input', () => displayTable(1));
            document.getElementById(id).addEventListener('change', () => displayTable(1));
        });

        displayTable();
    });
</script>
