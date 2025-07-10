
<cfset attributes.COID = 1>

<cfquery name="q_users" datasource="#Request.MTRDSN#">
    SELECT vaUSID
    FROM SEC0001 WITH (NOLOCK)
    WHERE iUSID = <cfqueryparam value="#Session.VARS.USID#" cfsqltype="cf_sql_integer">
</cfquery>



<!DOCTYPE html>
<html lang="en">    
<head>
    <meta charset="UTF-8">
    <title>Inventory System</title>

    <!-- ✅ Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Optional: Your custom styles -->
    <link rel="stylesheet" href="/assets/css/override.css?v=20250708">
</head>
<body>

    <!-- ✅ Bootstrap Navbar -->
    <nav class="navbar navbar-expand-lg navbar-light bg-light">
        <div class="container-fluid">

            <!-- App Name -->
            <cfoutput>
                <a class="navbar-brand fw-bold" href="index.cfm?fusebox=MTRroot&fuseaction=dsp_home&#request.mtoken#">
                    #APPLICATION.APPLICATIONNAME#
                </a>
            </cfoutput>

            <!-- Mobile toggle button -->
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarIMS"
                aria-controls="navbarIMS" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>

            <!-- Navbar content -->
            <div class="collapse navbar-collapse" id="navbarIMS">
                <!-- Left nav items -->
                <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                    <!-- Uncomment if needed
                    <li class="nav-item">
                        <a class="nav-link" href="index.cfm?fusebox=admin&fuseaction=dsp_home">Home</a>
                    </li>
                    -->

                    <!-- Staff Dropdown -->
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdownStaff" role="button"
                            data-bs-toggle="dropdown" aria-expanded="false">
                            Staff
                        </a>
                        <cfoutput>
                            <ul class="dropdown-menu" aria-labelledby="navbarDropdownStaff">
                                <li><a class="dropdown-item" href="index.cfm?fusebox=admin&fuseaction=dsp_stafflist&#Request.MToken#">Manage Staff</a></li>
                                <li><a class="dropdown-item" href="index.cfm?fusebox=admin&fuseaction=dsp_upsertstaff&COID=#Attributes.COID#&#Request.MToken#">Add Staff</a></li>
                                <li><a class="dropdown-item" href="index.cfm?fusebox=admin&fuseaction=dsp_upsertstaff&COID=#Attributes.COID#&#Request.MToken#&USERID=#q_users.vaUSID#">Edit My Profile</a></li>
                            </ul>
                        </cfoutput>
                    </li>
                    <!-- Item Types Dropdown -->
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdownStaff" role="button"
                            data-bs-toggle="dropdown" aria-expanded="false">
                            Item Types
                        </a>
                        <cfoutput>
                            <ul class="dropdown-menu" aria-labelledby="navbarDropdownStaff">
                                <li><a class="dropdown-item" href="index.cfm?fusebox=admin&fuseaction=dsp_listtype&#Request.MToken#">Manage Item Types</a></li>
                                <li><a class="dropdown-item" href="index.cfm?fusebox=admin&fuseaction=dsp_formtype&#Request.MToken#">Add Item Types</a></li>
                            </ul>
                        </cfoutput>
                    </li>
                    <!-- Items Dropdown -->
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdownStaff" role="button"
                            data-bs-toggle="dropdown" aria-expanded="false">
                            Items
                        </a>
                        <cfoutput>
                            <ul class="dropdown-menu" aria-labelledby="navbarDropdownStaff">
                                <li><a class="dropdown-item" href="index.cfm?fusebox=admin&fuseaction=dsp_listitem&#Request.MToken#">Manage Item</a></li>
                                <li><a class="dropdown-item" href="index.cfm?fusebox=admin&fuseaction=dsp_formitem&#Request.MToken#">Add Item</a></li>
                            </ul>
                        </cfoutput>
                    </li>
                    <!-- Threshold Dropdown -->
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdownStaff" role="button"
                            data-bs-toggle="dropdown" aria-expanded="false">
                            Threshold
                        </a>
                        <cfoutput>
                            <ul class="dropdown-menu" aria-labelledby="navbarDropdownStaff">
                                <li><a class="dropdown-item" href="index.cfm?fusebox=admin&fuseaction=dsp_listthresh&#Request.MToken#">Manage Thresholds</a></li>
                                <!--- <li><a class="dropdown-item" href="index.cfm?fusebox=admin&fuseaction=dsp_formthresh&#Request.MToken#">Add Threshold</a></li> --->
                            </ul>
                        </cfoutput>
                    </li>
                </ul>
                

                <!-- Right nav items -->
                <ul class="navbar-nav ms-auto mb-2 mb-lg-0">
                    <li class="nav-item">
                        <a class="nav-link" href="index.cfm?fusebox=MTRsec&fuseaction=act_logout">Sign Out</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- ✅ Bootstrap JS Bundle (includes Popper) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
