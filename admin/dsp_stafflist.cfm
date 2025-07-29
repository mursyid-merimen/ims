<cfquery name="q_getStaff" datasource="#Request.MTRDSN#">
    SELECT 
        u.iUSID,
        u.vaUSID,
        u.vaUSName,
        u.siRole,
        r.vaDESC 
    FROM SEC0001 u
    LEFT JOIN SEC0002 r ON u.siRole = r.siROLE
    WHERE u.iCOID = 1
    AND u.siSTATUS = 0
    ORDER BY u.vaUSName
</cfquery>

<cfset Attributes.COID = 1>

<h2>Staff List</h2>

<!-- Filters -->
<div class="mb-3 d-flex flex-wrap gap-3 align-items-end justify-content-center" style="width: fit-content; margin: 0 auto;">
    <div class="form-group">
        <label for="filterUsername">Username:</label>
        <input type="text" id="filterUsername" class="form-control" placeholder="Search Username">
    </div>

    <div class="form-group">
        <label for="filterFullName">Full Name:</label>
        <input type="text" id="filterFullName" class="form-control" placeholder="Search Full Name">
    </div>

    <div class="form-group">
        <label for="filterRole">Role:</label>
        <input type="text" id="filterRole" class="form-control" placeholder="Search Role">
    </div>
</div>

<!-- Table -->
<table class="table table-bordered table-striped mx-auto w-auto" id="staffTable">
    <thead>
        <tr>
            <th>Username</th>
            <th>Full Name</th>
            <th>Role</th>
            <th>Actions</th>
        </tr>
    </thead>
    <tbody></tbody>
</table>

<div id="pagination" style="text-align:center;"></div>

<!-- Pass ColdFusion data to JS -->
<script>
    const staffData = [
        <cfoutput query="q_getStaff">
            {
                iUSID: "#iUSID#",
                vaUSID: "#jsStringFormat(vaUSID)#",
                vaUSName: "#jsStringFormat(vaUSName)#",
                vaDESC: "#jsStringFormat(vaDESC)#"
            }<cfif currentrow LT recordcount>,</cfif>
        </cfoutput>
    ];

    const rowsPerPage = 10;
    let currentPage = 1;

    function filterData() {
        const usernameVal = document.getElementById('filterUsername').value.toLowerCase().trim();
        const fullNameVal = document.getElementById('filterFullName').value.toLowerCase().trim();
        const roleVal = document.getElementById('filterRole').value.toLowerCase().trim();

        return staffData.filter(item =>
            (usernameVal === "" || item.vaUSID.toLowerCase().includes(usernameVal)) &&
            (fullNameVal === "" || item.vaUSName.toLowerCase().includes(fullNameVal)) &&
            (roleVal === "" || item.vaDESC.toLowerCase().includes(roleVal))
        );
    }

    function renderTable(page = 1) {
        const filtered = filterData();
        const start = (page - 1) * rowsPerPage;
        const end = start + rowsPerPage;
        const pageData = filtered.slice(start, end);

        const tbody = document.querySelector("#staffTable tbody");
        tbody.innerHTML = "";

        pageData.forEach(item => {
            const row = document.createElement("tr");
            row.innerHTML = `
                <td>${item.vaUSID}</td>
                <td>${item.vaUSName}</td>
                <td>${item.vaDESC}</td>
                <td class="d-flex gap-2">
                    <cfoutput>
                        <form action="index.cfm?fusebox=admin&fuseaction=dsp_upsertstaff&COID=1&#Request.MToken#&iUSID=${item.iUSID}" method="post" style="display:inline;">
                            <button type="submit" class="btn btn-sm btn-primary">Edit</button>
                        </form>
                        <form action="index.cfm?fusebox=admin&fuseaction=act_deletestaff&COID=1&#Request.MToken#&iUSID=${item.iUSID}" method="post" style="display:inline;" onsubmit="return confirm('Delete this staff?');">
                            <button type="submit" class="btn btn-sm btn-danger">Delete</button>
                        </form>
                    </cfoutput>
                </td>
            `;
            tbody.appendChild(row);
        });

        renderPagination(filtered.length, page);
    }

    function renderPagination(totalItems, current) {
        const pagination = document.getElementById("pagination");
        pagination.innerHTML = "";

        const pageCount = Math.ceil(totalItems / rowsPerPage);
        for (let i = 1; i <= pageCount; i++) {
            const btn = document.createElement("a");
            btn.href = "#";
            btn.textContent = i;
            btn.style.margin = "0 5px";
            btn.style.fontWeight = i === current ? "bold" : "normal";
            btn.onclick = function (e) {
                e.preventDefault();
                currentPage = i;
                renderTable(currentPage);
            };
            pagination.appendChild(btn);
        }
    }

    document.addEventListener("DOMContentLoaded", () => {
        document.getElementById("filterUsername").addEventListener("input", () => renderTable(1));
        document.getElementById("filterFullName").addEventListener("input", () => renderTable(1));
        document.getElementById("filterRole").addEventListener("input", () => renderTable(1));
        renderTable(currentPage);
    });
</script>
