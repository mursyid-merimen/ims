<!DOCTYPE html>
<head>
<html lang="en">    
</head>
<body>

    <nav class="navbar navbar-expand-lg navbar-light bg-light">
        <div class="container-fluid">

            <!-- App Name -->
            <cfoutput>
                <a class="navbar-brand fw-bold" href="index.cfm?fusebox=admin&fuseaction=dsp_home">
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

                <!-- Left-aligned nav items -->
                <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                    <!--- <!-- Home -->
                    <li class="nav-item">
                        <a class="nav-link" href="index.cfm?fusebox=admin&fuseaction=dsp_home">Home</a>
                    </li> --->

                    <!-- Staff Dropdown -->
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdownStaff" role="button"
                            data-bs-toggle="dropdown" aria-expanded="false">
                            Staff
                        </a>
                        <ul class="dropdown-menu" aria-labelledby="navbarDropdownStaff">
                            <li><a class="dropdown-item" href="index.cfm?fusebox=admin&fuseaction=dsp_stafflist">Manage Staff</a></li>
                            <li><a class="dropdown-item" href="index.cfm?fusebox=admin&fuseaction=dsp_upsertstaff">Add Staff</a></li>
                        </ul>
                    </li>
                </ul>

                <!-- Right-aligned nav items -->
                <ul class="navbar-nav ms-auto mb-2 mb-lg-0">
                    <li class="nav-item">
                        <a class="nav-link" href="index.cfm?fusebox=MTRsec&fuseaction=act_logout">Sign Out</a>
                    </li>
                </ul>

            </div>
        </div>
    </nav>

    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
<!--- header for inventory management system ---> 







