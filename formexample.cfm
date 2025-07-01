<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
	<title>Merimen Form Validation JS Functions (FRAMEWORK)</title>
</head>
<body class=clsBody style="font-size:12px;padding:10px;"><div class=clsDocBody>
<BR>
<h3 align=center>Merimen Form Validation JS Functions (FRAMEWORK)</h3>
<!--- This section mimics SETTOKEN.cfm in CUSTOMTAGS. Don't need it if calling from app --->
<CFPARAM NAME=URL.locid DEFAULT=1>
<cfapplication NAME="formexample" CLIENTMANAGEMENT=No SETCLIENTCOOKIES=No SESSIONMANAGEMENT=Yes>
<CFSET Application.APPLOCID=1>
<CFSET Application.APPFullname="DEV">
<CFIF CGI.HTTP_HOST IS "192.168.1.48">
	<!--- Old: 192.168.1.231 --->
	<CFSET REQUEST.APPPATH="/Internal/">
	<CFSET REQUEST.APPROOT="/Internal/">
<CFELSE>
	<CFSET REQUEST.APPPATH="/">
	<CFSET REQUEST.APPROOT="/">
</CFIF>
<CFSET REQUEST.SVCDSN="claims_dev">
<CFSET REQUEST.LOGPATH="/claims/">
<CFSET DS=StructNew()>
<cfmodule TEMPLATE="#request.apppath#services/CustomTags/SVCcffunctions.cfm" DS=#DS#>
<CFSET Request.DS=DS>
<CFSET Request.DS.FN.SVCSvrFileDSUpdate()>
<style>
.code {color:blue; font-family: 'courier sans ms'}
.quest { color:red;}
</style>
<!--- Include these using AddFile --->
<script>
var request=new Object();
<CFOUTPUT>
request.apppath="#request.apppath#";
request.approot="#request.approot#";
</CFOUTPUT>
sysdt=new Date();
</script>
<CFMODULE TEMPLATE="#request.apppath#services/CustomTags/SVCaddfile.cfm" FNAME="JQUERY">
<CFMODULE TEMPLATE="#request.apppath#services/CustomTags/SVCaddfile.cfm" FNAME="SVCMAIN">
<CFMODULE TEMPLATE="#request.apppath#services/CustomTags/SVCaddfile.cfm" FNAME="SVCCAL">
<CFMODULE TEMPLATE="#request.apppath#services/CustomTags/SVCaddfile.cfm" FNAME="SVCCSS">
<script>
<CFSET IDDEF="">
<CFIF URL.locid IS 1>
	<CFSET IDDEF="1!Co Reg No|*2!NRIC~FN:JSVCIDChkMyIC(obj)|*3!Passport No|+4!Old IC|+5!Birth Cert No|*6!Army/Police ID">
	<CFSET CURRSYMBOL="RM">
	JSVCSetLocale(1);
<CFELSEIF URL.locid IS 7>
	<CFSET CURRSYMBOL="Rp">
	JSVCSetLocale(7,("-|.|0|,|3".split("|")));
<CFELSEIF URL.locid IS 4>
	<CFSET CURRSYMBOL="Rp">
	JSVCSetLocale(4);
<CFELSEIF URL.locid IS 100>
	<CFSET CURRSYMBOL="$">
	JSVCSetLocale(100,null,"mm/dd/yyyy");
<CFELSEIF URL.locid IS 101>
	<CFSET CURRSYMBOL="&euro;">
	JSVCSetLocale(101,("-|,|2|.|3".split("|")),"dd/mm/yyyy");
<CFELSEIF URL.locid IS 102>
	<CFSET CURRSYMBOL="&yen;">
	JSVCSetLocale(102,("-|.|2|,|3".split("|")),"yyyy/mm/dd");
</CFIF>
function TestLocale(obj)
{
	window.location.href=request.approot+"services/formexample.cfm?locid="+obj.value;
}

</script>
<br>
<p>
Note : To explore the source code, right-click on the page and click on "View-source". <br><br>

1. To make a field compulsory, add the <span class="code">CHKREQUIRED</span> attribute to your form element. <span class="quest"></span><br><br>
2. Then, call <b>AddOnloadCode("MrmPreprocessForm()");</b> to make the fields with <b>CHKREQUIRED</b> attribute pink/required. <span class="quest">Explain why this is required.</span> <br><br>
3. If there are still pink fields when the submit button is clicked, user will be alerted and that field receives focus. During alert, the text in the previous &lt;TD&gt; cell will be used to refer to the field name, unless the <span class="code">CHKNAME</span> attribute is defined. <span class="quest">Explain how this works.</span>
</p>
<br>
<div align=center>Locale: <select id=testlocale onchange="TestLocale(this)"><option value=1>Malaysia</option><option value=7<CFIF URL.LOCID IS 7> SELECTED</CFIF>>Indonesia (no decimal currency)</option>
<option value=4<CFIF URL.LOCID IS 4> SELECTED</CFIF>>India (weird thousand separators)</option><option value=100<CFIF URL.LOCID IS 100> SELECTED</CFIF>>US (mm/dd/yyyy)</option><option value=101<CFIF URL.LOCID IS 101> SELECTED</CFIF>>Netherlands (number . and , switched)</option><option value=102<CFIF URL.LOCID IS 102> SELECTED</CFIF>>Japan (yyyy/mm/dd)</option></select>
</div>
<br><br>
<!---p>
These functions are the same in all our apps, only thing is that 
Obj2DP, Obj1DP, ObjInt will alert user that an invalid data is entered for Non-Motor and ESource, but not in Claims.
</p--->
<script>AddOnloadCode("MrmPreprocessForm()");</script>
<form action="test" method="post" name="testform">
<table border=0 cellpadding=3 width=100%>
<col width=25% style=font-weight:bold;background-color:lightyellow><col width=75% style=background-color:gainsboro>
<tr>
	<td class=clsField1>Integer Field<br>(JSVCInt)</td>
	<td class=clsValue1><input type=text onblur="JSVCInt(this)" CHKREQUIRED></td>
</tr>
<tr>
	<td class=clsField1>Integer Field<br>(JSVCInt)</td>
	<td class=clsValue1><input type=text onblur="JSVCInt(this,1000,0)" CHKREQUIRED><br>Maximum 1,000(2nd param of JSVCInt), Minimum: 0 (3rd param of JSVCInt).</td>
</tr>
<tr>
	<td class=clsField1>Integer Field<br>(JSVCInt)</td>
	<td class=clsValue1><input type=text onblur="JSVCInt(this)"><br>Not Required</td>
</tr>
<tr>
	<td class=clsField1>Integer Field<br>(JSVCInt)</td>
	<td class=clsValue1><input type=text onblur="JSVCInt(this)" CHKREQUIRED CHKNAME="This very important field"><br>Required With CHKNAME Defined</td>
</tr>
<tr>
	<td class=clsField1>1 Decimal Place Field<br>(JSVC1DP)</td>
	<td class=clsValue1><input type=text onblur="JSVC1DP(this)"><br>Not Required</td>
</tr>
<tr>
	<td class=clsField1>2 Decimal Place Field<br>(JSVC2DP)</td>
	<td class=clsValue1><input type=text onblur="JSVC2DP(this)" CHKREQUIRED><br>Note: Do NOT assume currency fields are 2DP! See JSVCCurr below.</td>
</tr>
<tr>
	<td class=clsField1>Currency Field (<CFOUTPUT>#CURRSYMBOL#</CFOUTPUT>)<br>(JSVCCurr)</td>
	<td class=clsValue1><input type=text onblur="JSVCCurr(this)" CHKREQUIRED><br>Note: Some countries like Indonesia do not use decimal point usually in currency.</td>
</tr>
<tr>
	<td class=clsField1>5 Decimal Place Field<br>(JSVCNumLOC)</td>
	<td class=clsValue1><input type=text onblur="JSVCNumLOC(this,null,null,5)" CHKREQUIRED><br>JSVC2DP/1DP/Int/Curr are actually shortcut functions. JSVCNumLOC is the base function that give much more flexibility.</td>
</tr>
<tr>
	<td class=clsField1>Date Field</td>
	<td class=clsValue1><input MRMOBJ=DATE type=text></td>
</tr>
<tr>
	<td class=clsField1>Date Field</td>
	<td class=clsValue1><input MRMOBJ=CALDATE CHKREQUIRED name=GUIdate id=GUIdate type=text><br> With Date Entry GUI</td>
</tr>
<tr>
	<td class=clsField1>Date Field</td>
	<td class=clsValue1><input MRMOBJ=CALDATE DTMAX="TODAY{+7}" DTMIN="TODAY{-7}" DTDEF="TODAY" CHKREQUIRED name=GUIdate2 id=GUIdate2 type=text><br>DTMAX: maximum allowed date, DTMIN: minimun allowed date, DTDEF: default date when click on scroll buttons.</td>
</tr>
<tr>
	<td class=clsField1>Text Area Field</td>
	<td class=clsValue1>
		<textarea rows=8 name=area1 id=area1 style="width:100%;" MRMOBJ=TEXTAREA MAXCHAR=100></textarea>
		Textarea with maximum allowed characters MAXCHAR=100.
	</td>
</tr>
<tr>
	<td class=clsField1>Name/IC Field</td>
	<td>
		<button id="displayButton1" onclick="displayIDRE()" type="button">Show claimant's ID format details</button>
		<div id="displayIDRE" style="display:none">
			Regular expression for passport ID option: ^(A|a|H|h|K|k)([0-9]{8})$ <br>
			Pattern format: [lxxxxxxxx] 
			(l: A for Peninsular Malaysia & Labuan, H for Sabah, K for Sarawak x: 8 number digits)<br><br>
			Regular expression for army/police ID option: ^([0-9]{2})([0-1]{1})([0-9]{1})([0-3]{1})([0-9]{1})(-)(88|99)(-)([0-9]{4})$ <br>
			Pattern format: [yymmdd-zz-xxxx] 
			(yymmdd: Date of birth zz: 88 for policemen & 99 for armed forces xxxx: 4 number digits)
		</div>
		<script>
			function displayIDRE() {
				var el = document.getElementById("displayIDRE");
				if (el.style.display === "none") {
					el.style.display = "block";			
				}
				else {
					el.style.display = "none";
				}
			}
		</script>
	</td>
	<td class=clsValue1>
		<script>
		<CFOUTPUT>JSVCSetIDDefStr("#IDDEF#");</CFOUTPUT>
		document.write(JSVCGenNameIDStr(new Array("Claimant's Name","Claimant's ID"),1,1,"sleI",0,1,1,"",2,null,""));
		
		// Regular Expressions for passport ID and army/police ID
		var passportRE = "^(A|a|H|h|K|k)([0-9]{8})$";
		var armyRE = "^([0-9]{2})([0-1]{1})([0-9]{1})([0-3]{1})([0-9]{1})(-)(88|99)(-)([0-9]{4})$";
		
		// Input field
		var fieldObj = document.getElementById("sleIID1");
		
		// NRIC
		var nricObj = document.getElementById("_sleIID11sel");
		if(nricObj!=null){ nricObj.addEventListener("click", function() {
			fieldObj.removeAttribute("CHKREFORMAT");
			fieldObj.removeAttribute("CHKRESAMPLE");
			fieldObj.removeAttribute("CHKNAMECUSTOM");
			DoReq(fieldObj);
		});}

		// Passport ID
		var passportObj = document.getElementById("_sleIID12sel");
		if(passportObj!=null){passportObj.addEventListener("click", function() {
			fieldObj.setAttribute("CHKREFORMAT", passportRE);
			fieldObj.setAttribute("CHKRESAMPLE", "<br>[lxxxxxxxx] l: A for Peninsular Malaysia & Labuan, H for Sabah, K for Sarawak <br>x: 8 number digits");
			fieldObj.setAttribute("CHKNAMECUSTOM", 0);
			DoReq(fieldObj);
		});}
		
		// Army/Police ID
		var armyObj = document.getElementById("_sleIID15sel");
		if(armyObj!=null){armyObj.addEventListener("click", function() {
			fieldObj.setAttribute("CHKREFORMAT", armyRE);
			fieldObj.setAttribute("CHKRESAMPLE", "<br>[yymmdd-zz-xxxx] <br>yymmdd: Date of birth <br>zz: 88 for policemen & 99 for armed forces <br>xxxx: 4 number digits");
			fieldObj.setAttribute("CHKNAMECUSTOM", 0);
			DoReq(fieldObj);
		});}	
		</script>
	</td>
</tr>
<tr>
	<td class=clsField1>Contact Number</td>
	<td class=clsValue1>
		<input type=text onblur="DoReq(this);" CHKREFORMAT="^([0-9]{1,3})[-\s]?([0-9]{2,4})[\s]?([0-9]{4})$" CHKRESAMPLE="<br>Accepted number formats are: <br>[Only number digits]<br> or[xxx-xxx xxxx]<br> or [xx-xxxx xxxx]<br> or [xxx-xxxx xxxx]<br> or [xx-xxx xxxx]<br> or [xxx-xxx xxx]" CHKNAMECUSTOM=0> <br>Only Malaysian number formats accepted, please omit country code and brackets.
		<button id="displayButton2" onclick="displayContactRE()" type="button">Show contact number format details</button>
		<div id="displayContactRE" style="display:none">
			Regular expression for contact number field: ^([0-9]{1,3})[-\s]?([0-9]{2,4})[\s]?([0-9]{4})$ <br>
			Pattern format: [Only number digits] or [xxx-xxx xxxx] or [xx-xxxx xxxx] or [xxx-xxxx xxxx] or [xx-xxx xxxx] or [xxx-xxx xxx]
		</div>
		<script>
			function displayContactRE() {
				var el = document.getElementById("displayContactRE");
				if (el.style.display === "none") {
					el.style.display = "block";			
				}
				else {
					el.style.display = "none";
				}
			}
		</script>
	</td>
</tr>
</table>
<input type=button value="TEST SUBMIT" onclick="if (FormVerify(document.all('testform'))) alert('Everything OK');" class="clsButton">
</form>
		
<p>
In some of our code (esp. in esource) the GUI calendar is called differently (not by declaring the MRMOBJ attribute); the old way still works but should standardized to the way shown here.<br>
In the future, we may rework the codes such that all the JSVC* functions are called by declaring the MRMOBJ attribute.
</p>
<p>
To include these Javascript in COLD FUSION (the ADDFILE custom-tag is responsible for including the latest version of JS):<br><br>
<u>FRAMEWORK:</u><Br>
&lt;CFMODULE TEMPLATE="#request.apppath#services/CustomTags/SVCaddfile.cfm" FNAME="JQUERY"&gt; [ For JQUERY functions ]<br>
&lt;cfmodule TEMPLATE="#request.apppath#services/CustomTags/SVCADDFILE.cfm" FNAME="SVCMAIN"&gt; [ for generic functions ]<Br>
&lt;cfmodule TEMPLATE="#request.apppath#services/CustomTags/SVCADDFILE.cfm" FNAME="SVCCAL"&gt; [ for calendar functions ]<Br>
&lt;CFMODULE TEMPLATE="#request.apppath#services/CustomTags/SVCaddfile.cfm" FNAME="SVCCSS"&gt; [ for css functions ]<br>

<hr>
<center><h4>Merimen Javascript GUIs</h4></center>
<hr>

<center><h4>Merimen helper functions</h4></center>

<hr>
    <h4> 
        getValueByName(name:string, fnFilter:fn ,isSimplified:boolean) 
        <br>, @name         = element name
        <br>, @fnFilter     = function (iterated element) { return true/ false}, exclude assigning values to returned element
        <br>, @isSimplified = flag to indicate result returned in raw/ simplified form, defaults to simplified
        <br>
        <br>
        setValueByName(value:(string,array,object), name:string, fnFilter:fn, isSimplified:boolean) 
        <br>, @value        = value to set onto elements
        <br>, @name         = element name
        <br>, @fnFilter     = function (iterated element) { return true/ false}, exclude assigning values to returned element
        <br>, @isSimplified = flag to indicate result returned in raw/ simplified form, defaults to simplified
    </h4>
    <div>
        <b>Single named form element (textbox)</b>
        <br><input type="text" name="text1" value="test">
        <pre>
            &lt;input type=&quot;text&quot; name=&quot;text1&quot; value=&quot;test&quot;&gt; 

            var value_text1 = getValueByName("text1"); console.log(value_text1) // ["test"]
            setValueByName("hello bello","text1");                   // approach1, string value: text1.value changed to hello bello
            setValueByName(["hello123"] ,"text1");                   // approach2, array values: text1.value changed to hello bello
            setValueByName({"input.text":["hello123xxxx"]},"text1"); // approach2, obj values:   text1.value changed to hello bello
        </pre>
        <script>
            var value_text1 = getValueByName("text1"); console.log(value_text1) // ["test"]
            setValueByName("hello bello","text1");                   // approach1, string value: text1.value changed to hello bello
            setValueByName(["hello123"] ,"text1");                   // approach2, array values: text1.value changed to hello bello
            setValueByName({"input.text":["hello123xxxx"]},"text1"); // approach2, obj values:   text1.value changed to hello bello
        </script>
    </div>
    <div>
        <b> Multiple named form element (textbox) </b>
        <br><input type="text" value="va11" name="text2">
        <br><input type="text" value="va12" name="text2">
        <br><input type="text" value="va13" name="text2">
        <pre>
            &lt;br&gt;&lt;input type=&quot;text&quot; value=&quot;va11&quot; name=&quot;text2&quot;&gt;
            &lt;br&gt;&lt;input type=&quot;text&quot; value=&quot;va12&quot; name=&quot;text2&quot;&gt;
            &lt;br&gt;&lt;input type=&quot;text&quot; value=&quot;va13&quot; name=&quot;text2&quot;&gt;

            var value_text2 = getValueByName("text2"); console.log(value_text2) // ["va11", "va12", "va13"]
            setValueByName("hello bello,something,item2","text2");      // approach1, string value:  
            setValueByName(["helloa","hb","hc"],"text2");               // approach2, array values:  
            setValueByName({"input.text":["bbb","ccc","ddd"]},"text2"); // approach2, obj values:    
            // textbox values changes in order
            //val1 -> hello bello
            //val2 -> something
            //val3 -> item2
        </pre>
        <script>
            var value_text2 = getValueByName("text2"); console.log(value_text2) // ["va11", "va12", "va13"]
            setValueByName("hello bello,something,item2","text2");      // approach1, string value:  
            setValueByName(["helloa","hb","hc"],"text2");               // approach2, array values:  
            setValueByName({"input.text":["bbb","ccc","ddd"]},"text2"); // approach2, obj values:    
            // textbox values changes in order
            //val1 -> hello bello
            //val2 -> something
            //val3 -> item2
        </script>
    </div>
    <div>
        <p><b>Exclude/ include assignment </b></p>
        Default behaviour is to loop through all elements and perform assignment.
        <br> Although assignment can be skipped for element whose callback returns false 
        <br>
        <br>
        <b> -- Default behaviour </b>
        <br><input type="text" value="va11" name="text20">
        <br><input type="text" value="va12" name="text20" disabled>
        <br><input type="text" value="va13" name="text20">
        <pre>
            setValueByName(["helloa","hb","hc"],"text20");               // approach2, array values:  
            // textbox values changes in order
            //val1 -> hello bello
            //val2 -> hb
            //val3 -> hc
        </pre>
        <script>
            setValueByName(["helloa","hb","hc"],"text20");               // approach2, array values:  
            // textbox values changes in order
            //val1 -> hello bello
            //val2 -> hb
            //val3 -> hc
        </script>

        <b> -- Modified behaviour (example: only assign those NOT disabled) </b>
        <br><input type="text" value="va11" name="text21">
        <br><input type="text" value="va12" name="text21" disabled>
        <br><input type="text" value="va13" name="text21">
        <pre>
            setValueByName("helloa,hb,hc","text21",function(el){ return !el.disabled; });               // approach2, array values:  
            // NOTE: <b>function(el){ return !el.disabled; } </b> callback is evaluated against all elements with name "text21"

            // textbox values changes in order
            //val1 -> hello bello  (changed, because enabled)
            //val2 -> val2         (remained)
            //val3 -> hc           (changed, because enabled)
        </pre>
        <script>
            setValueByName("helloa,hb,hc","text21",function(el){ return !el.disabled; });               // approach2, array values:  
            // textbox values changes in order
            //val1 -> hello bello  (changed, because enabled)
            //val2 -> val2         (remained)
            //val3 -> hc           (changed, because enabled)
        </script>
    </div>

    <div>
        <b> Mixed Multiple named form elements (rare, but still possible to happen) </b>
        <br><input type="text" value="va11" name="text3">
        <br><input type="text" value="va12" name="text3">
        <br><input type="radio" value="radio1" name="text3">
        <br><input type="radio" value="radio2" name="text3" checked>
        <br><input type="radio" value="radio3" name="text3">
        <pre>
            &lt;br&gt;&lt;input type=&quot;text&quot; value=&quot;va11&quot; name=&quot;text3&quot;&gt;
            &lt;br&gt;&lt;input type=&quot;text&quot; value=&quot;va12&quot; name=&quot;text3&quot;&gt;
            &lt;br&gt;&lt;input type=&quot;radio&quot; value=&quot;radio1&quot; name=&quot;text3&quot;&gt;
            &lt;br&gt;&lt;input type=&quot;radio&quot; value=&quot;radio2&quot; name=&quot;text3&quot; checked&gt;
            &lt;br&gt;&lt;input type=&quot;radio&quot; value=&quot;radio3&quot; name=&quot;text3&quot;&gt;

            var value_text3 = getValueByName("text3"); console.log(value_text3);
            // input.radio: ["radio2"]
            // input.text: (2) ["va11", "va12"]
            setValueByName({
            "input.text":["text1val","text2val"]
            ,"input.radio":["radio3"]
            },"text3"); 
            // textbox values changes in order
            //val1 -> hello bello
            //val2 -> something
            //val3 -> item2
        </pre>
        <script>
            var value_text3 = getValueByName("text3"); console.log(value_text3);
            // input.radio: ["radio2"]
            // input.text: (2) ["va11", "va12"]
            setValueByName({
                "input.text":["text1val","text2val"]
                ,"input.radio":["radio3"]
            },"text3"); 
            // textbox values changes in order
            //val1 -> hello bello
            //val2 -> something
            // radio values changed
            // selected -> item2
        </script>
    </div>
    <div>
        <b> Full range of supported elements: </b>
        <pre>
        -- "textarea"       
        -- "input.text"     
        -- "input.hidden"   
        -- "input.password" 
        -- "input.radio"    
        -- "input.checkbox" 
        -- "select"         
        -- "select.multiple"
        </pre>
    </div>
    <div>
        <b>Radios and checkboxes</b>
        <div>
            <input type="radio" name="rr" value="rr1">
            <input type="radio" name="rr" value="rr2">
            <input type="radio" name="rr" value="rr3">
            <input type="radio" name="rr" value="rr4">
            
            <input type="checkbox" name="cb" value="cb1">
            <input type="checkbox" name="cb" value="cb2">
            <input type="checkbox" name="cb" value="cb3">
            <input type="checkbox" name="cb" value="cb4">
        </div>
        <pre>
            &lt;input type=&quot;radio&quot; name=&quot;rr&quot; value=&quot;rr1&quot;&gt;
            &lt;input type=&quot;radio&quot; name=&quot;rr&quot; value=&quot;rr2&quot;&gt;
            &lt;input type=&quot;radio&quot; name=&quot;rr&quot; value=&quot;rr3&quot;&gt;
            &lt;input type=&quot;radio&quot; name=&quot;rr&quot; value=&quot;rr4&quot;&gt;

            &lt;input type=&quot;checkbox&quot; name=&quot;cb&quot; value=&quot;cb1&quot;&gt;
            &lt;input type=&quot;checkbox&quot; name=&quot;cb&quot; value=&quot;cb2&quot;&gt;
            &lt;input type=&quot;checkbox&quot; name=&quot;cb&quot; value=&quot;cb3&quot;&gt;
            &lt;input type=&quot;checkbox&quot; name=&quot;cb&quot; value=&quot;cb4&quot;&gt;

            setValueByName(["rr1"],"rr")       // approach1: first value will be marked
            setValueByName(["rr2","rr3"],"rr") // approach2: first member in array will take effect. The rest ignored because radio allows only one selection

            setValueByName("cb1,cb3","cb")                         // approach1: checkbox values in string
            setValueByName(["cb1","cb2"],"cb")                     // approach2: checkbox values in arr
            setValueByName({"input.checkbox":["cb1","cb2"]},"cb")  // approach2: checkbox values in obj
        </pre>

        <script>
            setValueByName(["rr1"],"rr")       // approach1: first value will be marked
            setValueByName(["rr2","rr3"],"rr") // approach2: first member in array will take effect. The rest ignored because radio allows only one selection

            setValueByName("cb1,cb3","cb")                         // approach1: checkbox values in string
            setValueByName(["cb1","cb2"],"cb")                     // approach2: checkbox values in arr
            setValueByName({"input.checkbox":["cb1","cb2"]},"cb")  // approach2: checkbox values in obj
        </script>
    </div>
    <div>
        <b> Selects/ Dropdowns</b>
        <div>
            <select id="ss1" name="ss1">
                <option value="test1">aa</option>
                <option value="test2">bb</option>
                <option value="test3">cc</option>
                <option value="test4">dd</option>
            </select>
            <pre>
                setValueByName("test1","ss1")                 // approach1: first value will be marked
                setValueByName(["test2"],"ss1")               // approach2: first value will be marked
                setValueByName({"select":["test3"]},"ss1")    // approach3: first value will be marked
            </pre>
            <script>
                setValueByName("test1","ss1")                 // approach1: first value will be marked
                setValueByName(["test2"],"ss1")               // approach2: first value will be marked
                setValueByName({"select":["test3"]},"ss1")    // approach3: first value will be marked
            </script>
            
            <select id="ss2" name="ss2" multiple size=7>
                <optgroup label="group1">
                    <option value="test1">aa</option>
                    <option value="test2">bb</option>
                </optgroup>
                <optgroup label="group2">
                    <option value="test3">cc</option>
                    <option value="test4">dd</option>
                </optgroup>
            </select>
            <pre>
                setValueByName("test1,test2","ss2")                         // approach1: first value will be marked
                setValueByName(["test2","test3"],"ss2")                     // approach2: first value will be marked
                setValueByName({"select.multiple":["test1","test3"]},"ss2") // approach3: first value will be marked
            </pre>
            <script>
                setValueByName("test1,test2","ss2")                 // approach1: first value will be marked
                setValueByName(["test2","test3"],"ss2")               // approach2: first value will be marked
                setValueByName({"select.multiple":["test1","test3"]},"ss2")    // approach3: first value will be marked
            </script>
        </div>
    </div>
    <div>
        <b> Additional: Get/ Set values onto form</b>
        <div>
            <form id="f" action="">
                    <input type="text" name="ftext1">
                <br><input type="text" name="ftext1">
                <br><input type="text" name="ftext1">
                <br><input type="text" name="ftext1">

                <br> 
                <select id="sel" name="fsel1">
                    <option value="1">opt1</option>
                    <option value="10">opt10</option>
                    <option value="100">opt100</option>
                    <option value="1000">opt1000</option>
                </select>
                <br> 
                <select id="sel" name="fsel2" multiple size=6>
                    <option value="1">opt1</option>
                    <option value="10">opt10</option>
                    <option value="100">opt100</option>
                    <option value="1000">opt1000</option>
                </select>
                <br> My radios
                <br> <input type="radio" name="frad" value=11>
                <br> <input type="radio" name="frad" value=12>
                <br> <input type="radio" name="frad" value=13>
                <br> <input type="radio" name="frad" value=14>
                <br> My checkboxes 
                <br> <input type="checkbox" name="fcb" value=11>
                <br> <input type="checkbox" name="fcb" value=12>
                <br> <input type="checkbox" name="fcb" value=13>
                <br> <input type="checkbox" name="fcb" value=14>
            </form>
            <pre>
                setValuesByForm({
                        "ftext1":["this is text","","line2","GST bugs"]
                        ,"fsel1":["10"]
                        ,"fsel2":["10","100"]
                        ,"frad":"11"
                        ,"fcb":"12,14"
                    },document.getElementById("f")
                )
                var formvalues = getValuesByForm(document.getElementById("f"))
                console.log(formvalues)
            </pre>
            <script>
                setValuesByForm({
                        "ftext1":["this is text","","line2","GST bugs"]
                        ,"fsel1":["10"]
                        ,"fsel2":["10","100"]
                        ,"frad":"11"
                        ,"fcb":"12,14"
                    },document.getElementById("f")
                )
                var formvalues = getValuesByForm(document.getElementById("f"))
                console.log(formvalues)
            </script>
        </div>
    </div>

<br>
</p>
</div></body>
</html>
