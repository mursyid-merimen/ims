<cfquery name="q_items" datasource="#request.MTRDSN#">
    SELECT a.iITEMID, a.vaITEMNAME, a.vaBRAND, a.vaMODEL, a.vaLOCATION, a.siSTATUS, a.vaTAG,
           t.vaTYPENAME
    FROM IMS_ITEMS a
    LEFT JOIN IMS_TYPES t ON a.iTYPEID = t.iTYPEID
    WHERE a.siSTATUS = 0
    ORDER BY a.vaITEMNAME
</cfquery>

<h2>Inventory Items</h2>
<cfoutput>
    <a href="index.cfm?fusebox=admin&fuseaction=dsp_formitem&#Request.MToken#">Add New Item</a>
</cfoutput>

<!-- Filters -->
<div class="mb-3 d-flex flex-wrap gap-3 align-items-end justify-content-center" style="width: fit-content; margin: 0 auto;">
    <div class="form-group">
        <label for="filterType">Type:</label>
        <select id="filterType" class="form-control">
            <option value="">-- All Types --</option>
            <cfoutput query="q_items" group="vaTYPENAME">
                <option value="#vaTYPENAME#">#vaTYPENAME#</option>
            </cfoutput>
        </select>
    </div>

    <div class="form-group">
        <label for="filterTag">Tag:</label>
        <input type="text" id="filterTag" class="form-control" placeholder="Search Tag">
    </div>

    <div class="form-group">
        <label for="filterModel">Model:</label>
        <input type="text" id="filterModel" class="form-control" placeholder="Search Model">
    </div>
</div>

<table class="table table-bordered table-striped mx-auto w-auto" id="itemsTable">
  <thead>
    <tr>  
        <th>Tag</th>
        <th>Name</th>
        <th>Type</th>
        <th>Brand / Model</th>
        <th>Location</th>
        <th>Actions</th>
    </tr>
  </thead>  
  <tbody>
  </tbody>
</table>

<div id="pagination" style="text-align: center;"></div>

<!-- Pass CF query to JS -->
<script>
    const cfData = [
        <cfoutput query="q_items" startrow="1" maxrows="#q_items.recordcount#">
            {
                tag: "#jsStringFormat(vaTAG)#",
                name: "#jsStringFormat(vaITEMNAME)#",
                type: "#jsStringFormat(vaTYPENAME)#",
                brand: "#jsStringFormat(vaBRAND)#",
                model: "#jsStringFormat(vaMODEL)#",
                location: "#jsStringFormat(vaLOCATION)#",
                itemid: "#iITEMID#"
            }<cfif q_items.currentrow LT q_items.recordcount>,</cfif>
        </cfoutput>
    ];

    const rowsPerPage = 10;
    let currentPage = 1;

    function displayTable(page) {
        const tableBody = document.querySelector("#itemsTable tbody");
        tableBody.innerHTML = "";

        const start = (page - 1) * rowsPerPage;
        const end = start + rowsPerPage;

        const filtered = filterData();

        const pageItems = filtered.slice(start, end);
        pageItems.forEach(item => {
            const row = document.createElement("tr");
            row.innerHTML = `
                <td>${item.tag}</td>
                <td>${item.name}</td>
                <td>${item.type}</td>
                <td>${item.brand} / ${item.model}</td>
                <td>${item.location}</td>
                <cfoutput>
                    <td>
                        <a href="index.cfm?fusebox=admin&fuseaction=dsp_formitem&#Request.MToken#&ITEMID=${item.itemid}">Edit</a> |
                        <a href="index.cfm?fusebox=admin&fuseaction=act_item&#Request.MToken#&ITEMID=${item.itemid}&OPERATION=DELETE" onclick="return confirm('Delete this item?')">Delete</a>
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
            link.onclick = () => {
                displayTable(i);
            };
            pagination.appendChild(link);
        }
    }

    // Filtering
    function filterData() {
        const typeVal = document.getElementById('filterType').value.toLowerCase();
        const tagVal = document.getElementById('filterTag').value.toLowerCase();
        const modelVal = document.getElementById('filterModel').value.toLowerCase();

        return cfData.filter(item =>
            (typeVal === "" || item.type.toLowerCase().includes(typeVal)) &&
            (tagVal === "" || item.tag.toLowerCase().includes(tagVal)) &&
            (modelVal === "" || item.model.toLowerCase().includes(modelVal))
        );
    }

    // Event Listeners
    document.getElementById('filterType').addEventListener('change', () => displayTable(1));
    document.getElementById('filterTag').addEventListener('input', () => displayTable(1));
    document.getElementById('filterModel').addEventListener('input', () => displayTable(1));

    // Init
    displayTable(currentPage);
</script>
