
<!--- use template --->

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Adaptation Training Form</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- Bootstrap 5 CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        input[readonly] {
            background-color: #f8f9fa;
        }
    </style>
</head>
<body>
<cfparam name="attributes.iRecordID" default="#url.iRecordID#">


<cfquery name="q_rec" datasource="SimpleDB">
    SELECT *
    FROM Records 
    WHERE iRecordID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#Attributes.iRecordID#">
</cfquery>
<cfquery name="q_hby" datasource="SimpleDB">
    SELECT iHobbyID, vaHobbyName
    FROM ListHobbies
    ORDER BY vaHobbyName
</cfquery>

<cfquery name="q_rec" datasource="SimpleDB">
    SELECT *
    FROM Records 
    WHERE iRecordID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#Attributes.iRecordID#">
    <cfparam name="attributes.iRecordID" default="0">
</cfquery>
<cfset isEdit = structKeyExists(attributes, "iRecordID") and q_rec.recordcount eq 1>
<cfif isEdit>
    <cfset record = q_rec>
</cfif>
<cfset isEdit = structKeyExists(attributes, "iRecordID") and q_rec.recordcount eq 1>
<cfif isEdit>
    <cfset record = q_rec>
</cfif>
<!--- <cfdump var="#attributes#" label="Attributes Scope" expand="yes"> --->

<cfoutput>

<div class="container py-5">
    
    <form id="adaptationForm" method="post" autocomplete="off">
        <cfif isEdit>
            <input type="hidden" name="RecordID" value="#attributes.iRecordID#">
        </cfif>
        
        <div class="mb-3">
            <label for="name" class="form-label">Name</label>
            <input id="name" name="name" type="text" class="form-control" required value="<cfif isEdit>#record.name#</cfif>">
        </div>
        <div class="mb-3">
            <label for="email" class="form-label">Email</label>
            <input id="email" name="email" type="email" class="form-control" required value="<cfif isEdit>#record.email#</cfif>">
        </div>
        <div class="mb-3">
            <label for="dob" class="form-label">Date of Birth</label>
            <input id="dob" name="dob" type="date" class="form-control" required value="<cfif isEdit>#DateFormat(record.dob, 'yyyy-mm-dd')#</cfif>">
        </div>
        <div class="mb-3">
            <label for="about" class="form-label">About Me</label>
            <textarea id="about" name="about" rows="3" class="form-control"><cfif isEdit>#record.about#</cfif></textarea>
        </div>
        <div class="mb-3">
            <label for="profession" class="form-label">Profession</label>
            <select id="profession" name="profession" class="form-select" required>
                <option value="">-- Select Profession --</option>
                <cfloop array="#['Account','Medical','IT','Education','Other']#" index="p">
                    <option value="#p#" <cfif isEdit and record.profession eq p>selected</cfif>>#p#</option>
                </cfloop>
            </select>
        </div>
        </cfoutput>
        <div class="mb-3">
            <label class="form-label">Hobbies</label>
            <div class="d-flex flex-wrap gap-3">
                <cfoutput query="q_hby">
                    <cfset selectedHobbies = isEdit ? listToArray(record.hobbies) : []>
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" name="hobbies" value="#vaHobbyName#" id="hobby#iHobbyID#" <cfif arrayFind(selectedHobbies, vaHobbyName)>checked</cfif>>
                        <label class="form-check-label" for="hobby#iHobbyID#">#vaHobbyName#</label>
                    </div>
                </cfoutput>
            </div>
        </div>
        <cfoutput>
        <div class="mb-3">
            <label for="ic" class="form-label">IC</label>
            <input id="ic" name="ic" type="text" maxlength="14" class="form-control" placeholder="e.g. 951111-11-1234" required value="<cfif isEdit>#record.ic#</cfif>">
        </div>
        <div class="mb-3">
            <label for="age" class="form-label">Age</label>
            <input id="age" name="age" type="number" class="form-control" readonly value="<cfif isEdit>#record.age#</cfif>">
        </div>
        <div class="mb-4">
            <label class="form-label">Gender</label>
            <div class="d-flex gap-3">
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="gender" value="Male" id="genderMale" disabled>
                    <label class="form-check-label" for="genderMale">Male</label>
                </div>
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="gender" value="Female" id="genderFemale" disabled>
                    <label class="form-check-label" for="genderFemale">Female</label>
                </div>
            </div>
        </div>
        <button type="submit" class="btn btn-<cfif isEdit>warning<cfelse>primary</cfif> w-100">
            <cfif isEdit>Update Record<cfelse>Submit</cfif>
        </button>
    </form>
</div>
</cfoutput>
<script>
    function updateRecord() {
        const form = document.getElementById('adaptationForm');
        const formData = new FormData(form);
        const url = 'index.cfm?fusebox=admin&fuseaction=act_submit';

        fetch(url, {
            method: 'POST',
            body: formData
        })
        .then(response => response.text())
        .then(data => {
            // Handle success response
            console.log('Success:', data);
            window.location.href = 'index.cfm?fusebox=MTRroot&fuseaction=dsp_home';
        })
        .catch((error) => {
            console.error('Error:', error);
        });
    }
</script>

</body>
<html lang="en">


