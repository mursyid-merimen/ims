<cfquery name="q_list" datasource="#request.MTRDSN#">
SELECT 
    i.iITEMID,
    i.vaTAG,
    i.vaITEMNAME,
    i.vaBRAND,
    i.vaMODEL,
    a.iUSID,
    u.vaUSNAME,
    a.dtASGNDON,
    a.vaREMARKS
FROM IMS_ITEMS i
LEFT JOIN (
    SELECT iITEMID, iUSID, dtASGNDON, vaREMARKS  FROM IMS_ASGMT WHERE siACTIVE = 1 AND siSTATUS = 0
) a ON i.iITEMID = a.iITEMID
LEFT JOIN SEC0001 u ON a.iUSID = u.iUSID
WHERE i.siSTATUS = 0
ORDER BY i.vaITEMNAME
</cfquery>


<cfoutput>
<h2>Asset Assignment List</h2>

<div class="mb-3 d-flex flex-wrap gap-3 align-items-end justify-content-center" style="width: fit-content; margin: 0 auto;">
    
    <div class="form-group">
        <label for="filterTag">Tag:</label>
        <input type="text" id="filterTag" class="form-control" placeholder="Search Tag">
    </div>

    <div class="form-group">
        <label for="filterItem">Item:</label>
        <input type="text" id="filterItem" class="form-control" placeholder="Search Item">
    </div>

    <div class="form-group">
        <label for="filterBrand">Brand:</label>
        <input type="text" id="filterBrand" class="form-control" placeholder="Search Brand">
    </div>

    <div class="form-group">
        <label for="filterModel">Model:</label>
        <input type="text" id="filterModel" class="form-control" placeholder="Search Model">
    </div>

    <div class="form-group">
        <label for="filterUser">Assigned To:</label>
        <input type="text" id="filterUser" class="form-control" placeholder="Search User">
    </div>

    <div class="form-group">
        <label for="filterStatus">Status:</label>
        <select id="filterStatus" class="form-control">
            <option value="">-- All --</option>
            <option value="assigned">Assigned</option>
            <option value="unassigned">Unassigned</option>
        </select>
    </div>

</div>


<table class="table table-bordered table-striped">
    <thead>
        <tr>
            <th>Tag</th>
            <th>Item</th>
            <th>Brand</th>
            <th>Model</th>
            <th>Assigned To</th>
            <th>Assigned Date</th>
            <th>Status</th>
            <th>Action</th>
        </tr>
    </thead>
    <tbody id="tableBody">
        <cfloop query="q_list">
            <tr>
                <td onclick="window.location.href='index.cfm?fusebox=admin&fuseaction=dsp_itemhistory&ITEMID=#iITEMID#&#request.mtoken#';" style="cursor:pointer; color:blue; text-decoration:underline;">#vaTAG#</td>
                <td>#vaITEMNAME#</td>
                <td>#vaBRAND#</td>
                <td>#vaMODEL#</td>
                <td><cfif len(trim(vaUSNAME))>#vaUSNAME#<cfelse>-</cfif></td>
                <td>
                    <cfif isDate(dtASGNDON)>
                        #DateFormat(dtASGNDON, "yyyy-mm-dd")#
                    <cfelse>
                        -
                    </cfif>
                </td>
                <td>
                    <cfif NOT len(vaUSNAME)>
                        <span class="badge bg-warning text-dark">Unassigned</span>
                    <cfelse>
                        <span class="badge bg-success">Assigned</span>
                    </cfif>
                </td>
                <td>
                    <cfif NOT len(vaUSNAME)>
                        <a href="index.cfm?fusebox=admin&fuseaction=dsp_assign&ITEMID=#iITEMID#&#request.mtoken#" class="btn btn-sm btn-primary">Assign</a>
                    <cfelse>
                        <a href="index.cfm?fusebox=admin&fuseaction=dsp_return&ITEMID=#iITEMID#&#request.mtoken#" class="btn btn-sm btn-danger">Mark Returned</a>
                    </cfif>
                </td>
            </tr>
        </cfloop>
    </tbody>
</table>
<div id="pagination" style="text-align:center;"></div>

</cfoutput>

<script>
    const cfData = [
        <cfoutput query="q_list">
            {
                tag: "#jsStringFormat(vaTAG)#",
                item: "#jsStringFormat(vaITEMNAME)#",
                brand: "#jsStringFormat(vaBRAND)#",
                model: "#jsStringFormat(vaMODEL)#",
                user: "#jsStringFormat(vaUSNAME)#",
                assignedDate: "#isDate(dtASGNDON) ? DateFormat(dtASGNDON, 'yyyy-mm-dd') : ''#",
                status: "#len(trim(vaUSNAME)) ? 'assigned' : 'unassigned'#",
                itemid: "#iITEMID#"
            }<cfif currentrow LT recordcount>,</cfif>
        </cfoutput>
    ];

    const rowsPerPage = 10;
    let currentPage = 1;

    function filterData() {
        const tagVal = document.getElementById('filterTag').value.toLowerCase();
        const itemVal = document.getElementById('filterItem').value.toLowerCase();
        const brandVal = document.getElementById('filterBrand').value.toLowerCase();
        const modelVal = document.getElementById('filterModel').value.toLowerCase();
        const userVal = document.getElementById('filterUser').value.toLowerCase();
        const statusVal = document.getElementById('filterStatus').value.toLowerCase();

        return cfData.filter(item => {
            return (
                (tagVal === '' || item.tag.toLowerCase().includes(tagVal)) &&
                (itemVal === '' || item.item.toLowerCase().includes(itemVal)) &&
                (brandVal === '' || item.brand.toLowerCase().includes(brandVal)) &&
                (modelVal === '' || item.model.toLowerCase().includes(modelVal)) &&
                (userVal === '' || item.user.toLowerCase().includes(userVal)) &&
                (statusVal === '' || item.status === statusVal)
            );
        });
    }

    function displayTable(page = 1) {
        const tableBody = document.getElementById("tableBody");
        tableBody.innerHTML = "";

        const filtered = filterData();
        const start = (page - 1) * rowsPerPage;
        const end = start + rowsPerPage;
        const pageItems = filtered.slice(start, end);

        pageItems.forEach(item => {
            const row = document.createElement("tr");
            row.innerHTML = `
                <cfoutput>
                    <td onclick="window.location.href='index.cfm?fusebox=admin&fuseaction=dsp_itemhistory&ITEMID=${item.itemid}&#request.mtoken#';" style="cursor:pointer; color:blue; text-decoration:underline;">${item.tag}</td>
                    <td>${item.item}</td>
                    <td>${item.brand}</td>
                    <td>${item.model}</td>
                    <td>${item.user || '-'}</td>
                    <td>${item.assignedDate || '-'}</td>
                    <td><span class="badge bg-${item.status === 'assigned' ? 'success' : 'warning'}">${item.status.charAt(0).toUpperCase() + item.status.slice(1)}</span></td>
                    <td>
                        <a href="index.cfm?fusebox=admin&fuseaction=${item.status === 'unassigned' ? 'dsp_assign' : 'dsp_return'}&ITEMID=${item.itemid}&#request.mtoken#" class="btn btn-sm ${item.status === 'unassigned' ? 'btn-primary' : 'btn-danger'}">
                            ${item.status === 'unassigned' ? 'Assign' : 'Mark Returned'}
                        </a>
                    </td>
                </cfoutput>
            `;
            tableBody.appendChild(row);
        });

        updatePagination(filtered.length, page);
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
            'filterTag', 'filterItem', 'filterBrand',
            'filterModel', 'filterUser', 'filterStatus'
        ];

        inputs.forEach(id => {
            document.getElementById(id).addEventListener('input', () => displayTable(1));
            document.getElementById(id).addEventListener('change', () => displayTable(1));
        });

        displayTable();
    });
</script>


