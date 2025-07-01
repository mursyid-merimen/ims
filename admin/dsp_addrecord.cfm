<!--- <cfdump var="#request.mtoken#"> --->

<!--- <cfset Request.DS.FN.SVCsessionChk()> --->
<cfquery name="q_hby" datasource="SimpleDB">
    SELECT iHobbyID, vaHobbyName
    FROM ListHobbies
    WHERE siStatus = 0
    ORDER BY vaHobbyName
    
</cfquery>

<cfif structKeyExists(url, "RecordID")>
    <cfset iRecordID = url.RecordID>
<cfelse>
    <cfset iRecordID = "">
</cfif>
<cfset isEdit = false>
<cfset record = structNew()>

<cfif len(trim(iRecordID))>
    <cfinclude template="dsp_getrecord.cfm"> <!-- assume it sets q_rec -->
    <cfif q_rec.recordcount EQ 1>
        <cfset isEdit = true>
        <cfset record = q_rec>
    </cfif>
</cfif>

<!--- <cfdump var="#record#" > --->


<!--- Include the modular form --->
<cfmodule template="../customtags/form_adaptation.cfm"
          iRecordID="#iRecordID#"
          isEdit="#isEdit#"
          record="#record#"
          q_hby="#q_hby#">
