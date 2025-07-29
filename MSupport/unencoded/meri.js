	// COPYRIGHT NOTICE
	// ----------------
	// Copyright (c) 10 July 2000. All rights reserved.
	//
	// Any unauthorised copying, reproduction or publishing in any form
	// or manner whatsoever, of either a part of or this entire script,
	// is strictly prohibited and will constitute an infringement of this
	// copyright.
	//
	// Modification Track
	//////////////////////////////////////////////////////////////////////////////////

function Toggle2(obj)
{
	var vshow,vgif,vlen,tbod;
	vgif=obj.firstChild.firstChild;
	if(!(vgif.tagName=="IMG" && vgif.id=="GF"))
	{vgif=vgif.firstChild;if(!(vgif.tagName=="IMG" && vgif.id=="GF"))return;}
	vlen = vgif.src.length;
	if (vgif.src.substring(vlen - 8,vlen) == "plus.gif")
	{
		vshow = "";
		vgif.src = request.webroot+"common/minus.gif";
	} else
	{
		vshow = "none";
		vgif.src = request.webroot+"common/plus.gif";
	}
	tbod=obj.parentNode.nextSibling;
	tbod.style.display=vshow;
	return (vshow!="none"?1:0);
}
function ToggleHide(obj)
{
	var vshow,vgif,vlen,tbod,col,o;
	vgif=obj.all("GF");
	vlen = vgif.src.length;
	if (vgif.src.substring(vlen - 8,vlen) == "plus.gif")
	{
		vshow = "";
		vgif.src = request.webroot+"common/minus.gif";
	} else
	{
		vshow = "none";
		vgif.src = request.webroot+"common/plus.gif";
	}
	tbod=obj.parentElement.nextSibling;
	tbod.style.display=vshow;
	col=tbod.getElementsByTagName("select");
	if(col!=null)
	{
		for (o = 0; o < col.length; o++)
		{
			if(vshow!="none" && col[o].getAttribute("SELHIDE")==tbod)
			{
				col[o].removeAttribute("SELHIDE");
				col[o].style.display="inline";
				col[o].style.visibility="inherit";
			}
			else if(vshow=="none" && col[o].getAttribute("SELHIDE")==null)
			{
				//alert('oi');
				col[o].setAttribute("SELHIDE",tbod);
				col[o].style.display="none";
				col[o].style.visibility="hidden";
			}
		}
	}
	return (vshow!="none"?1:0);
}
// Related to combo-damage condition
function RevertKey(dd,fixedval)
{
	if(event.keyCode==13)
	{
		Revert(dd,fixedval);
		dd.curtxt.focus();
	}
}
function Revert(dd,fixedval)
{
	var val;
	// Fixedval for fixed value in the select options not by text
	if (dd.curtxt != null)
	{
		dd.style.display = "none";
		if(dd.selectedIndex<0)
			val=""
		else
		{
			val=dd.options[dd.selectedIndex].text;
			if(val==null)
				val="";
		}
		dd.curtxt.value = val;
		DoReq(dd.curtxt);
		if(fixedval!=null)
		{
			val=dd.value;
			if(val==null)
				val="";
			if(fixedval=="")
			{
				if(dd.curtxt.nextSibling.tagName=="INPUT")
					dd.curtxt.nextSibling.value=val;
			} else
				document.getElementById(fixedval).value=val;
		}
		dd.curtxt.style.display = "inline";
	}
}
function GetCommonPos(str1,str2)
{
	var t;
	var maxi=Math.min(str1.length,str2.length);
	for(t=0;t<maxi;t++)
		if (str1.charAt(t) != str2.charAt(t))
		{
			return t;
		}
	return maxi;
}
function Invert(txt,dd,fixedval)
{
	if (txt.disabled == true) return;
	dd.curtxt = txt;
	txt.style.display = "none";
	//txt.parentElement.style.overflow = "visible";
	txt.parentNode.insertBefore(dd,txt);
	//txt.insertAdjacentElement("beforeBegin",dd);
	dd.style.display = "inline";
	dd.focus();
	if(fixedval==null)
	{
	// Find closest fit
	var olist = dd.options;
	var val = Trim(txt.value).toUpperCase();
	if ((val != '') && (olist != null))
	{
		var selidx = 0;
		var maxi = 0;
		var vlen = olist.length;
		if (vlen != null)
		{
			var i;
			var l;
        	for (i=0; i<vlen; i++)
			{
				l = GetCommonPos(olist[i].text.toUpperCase(),val);
				if (l > maxi)
				{
					selidx = i;
					maxi = l;
				}
			}
		}
		dd.selectedIndex = selidx;
	}
	} else
	{
		if(fixedval=="")
			dd.value=txt.nextSibling.value;
		else
			dd.value=document.getElementById(fixedval).value;
	}
}
function InvertKey(txt,dd,fixedval)
{
	if(event.keyCode==40 || event.keyCode==38 || event.keyCode==13)
		Invert(txt,dd,fixedval);
}
function TabClick(vTabThisPos)
{
	if(vTabThisPos != vTabLastPos)
	{
		var tab;
		if(vTabLastPos != '')
		{
			tab=document.getElementById("TAG"+vTabLastPos);
			tab.className="clsTab";
			document.getElementById("TABLE" + vTabLastPos).style.display = "none";
		}
		tab=document.getElementById("TAG"+vTabThisPos);
		tab.className="clsTabSelected";
		document.getElementById("TABLE" + vTabThisPos).style.display = "";
		vTabLastPos = vTabThisPos;
	}
}
function warn(warningstr)
{
	return confirm(JSVClang("Remember to save any changes before you "+"{0}"+".\nOtherwise, all the changes you made could be lost.\n\nClick 'OK' if you want to proceed without saving.\n\nClick 'Cancel' if you wish to save first.",5003,0,warningstr));
}
function CheckDisable(chk)
{
	var col = document.all(chk.id);
	var stat = chk.checked;
	if (col!=null)
	{
		var vlen = col.length;
		if(vlen!=null && col.tagName == null)
		{
			var i;
        	for (i=0; i<vlen; i++)
				if (col(i) != chk)
				{
					col(i).disabled = !stat;
				}
		}
	}
	return stat;
}
/*function ObjInt(obj,minval,maxval)
{
	JSVCNumLOC(obj,maxval,minval,0);
}*/
function MrmGetRecentLink(userid,threshold)
{
	var cur,arr,str,pos,nm,dom,id,val,first;
	cur=MrmGetPersistUserData("MCLM"+userid);
	if(cur==null)
		return;
	arr=cur.split("\\");
	for(str in arr)
	{
		pos=arr[str].indexOf(":");
		if(pos > 0)
		{
			nm=arr[str].substring(0,pos);
			val=unescape(arr[str].slice(pos+1));
			pos=arr[str].indexOf("&");
			if(pos>0)
			{
				dom=nm.substring(0,pos);
				id=nm.slice(pos+1);
				switch(dom)
				{
					case "MTR":
						if(A_MENUS)
							A_MENUS[0].insertMenu(JSVClang("Recent Claims",5015),val,request.webroot+"index.cfm?fusebox=MTRroot&fuseaction=dsp_clmheader&caseid="+id+"&"+request.mtoken);
						break;
					case "MTP":
						if(A_MENUS)
							A_MENUS[0].insertMenu(JSVClang("Recent Claims",5015),val,request.webroot+"index.cfm?fusebox=MTRroot&fuseaction=dsp_clmheader&caseid="+id+"&tpins=1&"+request.mtoken);
						break;
				}
			}
		}
	}
}
function MrmNewRecentLink(userid,dom,id,desc,threshold)
{
	var cur,arr,pos,posend,nm;
//	MrmSetPersistUserData("MCLM"+userid,"");
//	return;

	cur=MrmGetPersistUserData("MCLM"+userid);
	if(cur==null)
		cur="";
	nm=dom+"&"+id;
	pos = cur.indexOf("\\"+nm+":");
	if(pos>=0)
	{
		// Update
		posend=cur.indexOf("\\",pos+1);
		if(posend==-1)
			cur=cur.substring(0,pos+nm.length+2)+desc
		else
			cur=cur.substring(0,pos+nm.length+2)+desc+cur.slice(posend);
	} else
		// Insert
		cur=cur+"\\"+nm+":"+desc;
	if(threshold>0)
	{
		// Truncate if exceeds threshold
		arr=cur.split("\\");
//		alert(arr.length+","+threshold);
//		alert(arr.valueOf());
		if(arr.length-1>threshold)
		{
//			alert(arr.toString());
			arr=arr.slice(arr.length-threshold,arr.length+1);
//			alert(arr.toString());
			cur="\\"+arr.join("\\");
//			alert(cur);
		}
	}
	MrmSetPersistUserData("MCLM"+userid,cur);
}
function RptFormVerify(frm,days,noprompt)
{
	var dt1,dt2,obj2;
	if(noprompt==null)
		noprompt=false;
	if(FormVerify(frm,noprompt))
	{
		obj2=document.getElementById("DrTo");
		if(obj2==null)
			return true;
		obj1=document.getElementById("DrFrom");
		if(obj1==null)
			return true;
		if(!(obj1.value!=''&&obj2.value!='')) {
			return true;
		}
		dt1=CalParseDate(obj1.value);
		if(days==null)
		{
			days=obj2.getAttribute("MAXDAYS");
			if(days==null || days=="")
				days=366;
		}
		dt1.setDate( dt1.getDate()+parseInt(days) );
		dt2=CalParseDate(obj2.value);
		if(dt2>=dt1)
		{
			if(!noprompt)
				alert(JSVClang("The maximum allowable period is {0} days.\nPlease set your 'To' date to within {1} days from the 'From' date.",5016,0,days,days));
			obj2.focus();
			obj2.select();
			return false;
		}
		return true;
	} else
		return false;
}
function RptDispTime(begintime,o) {
	var a=new Date();
	var b=new Date(a-begintime);
	b=b.getTime()/1000; // seconds
	var c=Math.floor((b/60)%60);
	var d=Math.floor(b%60);
	/* IE 7 not compatible // window.status="Report running..."+Math.floor((b/3600)%24)+" hour(s) "+Math.floor((b/60)%60)+" min(s) "+Math.floor(b%60)+" sec(s)";*/
	o=JSVCall(o);
	o.innerHTML="<span style=color:white>"+JSVClang("Processing...",12886)+(c.toString().length==1?"0"+c:c)+":"+(d.toString().length==1?"0"+d:d)+"</span>";
}
function RptQuerySetDate(obj)
{
	ObjDate(obj);
}
//to hide applets and select elements which always show on top of absolutely positioned objects, an internet explorer bug
function StartHide(id)
{
	var obj=document.getElementById(id);
	if(obj!=null && (obj.style.visibility=="show" || obj.style.visibility=="visible" || obj.style.display=="block"))
	{
		HideElements('SELECT', obj);
		HideElements('APPLET', obj);
	}
}

function ShowElements(tagname)
{
var element;
	for( i = 0; i < document.getElementsByTagName(tagname).length; i++ )
	{
		element = document.getElementsByTagName(tagname)[i];
		if( !element || !element.offsetParent )
			continue;
		element.style.visibility = "";
	}
}

/* hides elements that overlaps with obj*/
function HideElements(tagname, obj)
{
var element, elementPos, elementHeight, elementWidth;
	for( i = 0; i < document.getElementsByTagName(tagname).length; i++ )
    {
      element = document.getElementsByTagName(tagname)[i];
      if( !element || !element.offsetParent )
      {
        continue;
      }

	  elementPos=FindObjPos(element);
      elementHeight = element.offsetHeight;
      elementWidth = element.offsetWidth;

      if(( obj.offsetLeft + obj.offsetWidth ) <= elementPos[0] );
      else if(( obj.offsetTop + obj.offsetHeight ) <= elementPos[1] );
      else if( obj.offsetTop >= ( elementPos[1] + elementHeight ));
      else if( obj.offsetLeft >= ( elementPos[0] + elementWidth ));
      else
      {
		element.style.visibility = "hidden";
      }
    }
}

// Find an object's offsetTop and offsetLeft relative to the a certain parent tag (defaults to BODY tag), returns an array of length 2.
function FindObjPos(obj, parenttag)
{
 	if (parenttag==null) parenttag="BODY";
	var objLeft   = obj.offsetLeft-obj.scrollLeft;
 	var objTop    = obj.offsetTop-obj.scrollTop;
 	var objParent = obj.offsetParent;
 	while( objParent.tagName.toUpperCase() != parenttag )
 	{
		objLeft  += objParent.offsetLeft-objParent.scrollLeft;
	   	objTop   += objParent.offsetTop-objParent.scrollTop;
	   	objParent = objParent.offsetParent;
	}
	var objPos = new Array(objLeft, objTop);
	return objPos;
}

var appversion = null; //ie version is stored in this float variable
try {appversion = parseFloat(navigator.appVersion.substr(navigator.appVersion.indexOf('MSIE')+4));}
	catch(e){}
/*----------------Drag and Drop-----------------------------------------*/
// To use, you must have an abosultely-positioned visibility:hidden div on the page.
// attach StartDrag to the onmousedown event of the object you want to drag.
// attach StartDrop to the onmouseup event of same object.
// attach FollowMouse to the onmousemove event of the same object.
// the object to be drag must also have the following attributes: eventoffsetX='-999' eventoffsetY='-999' backgroundcolor='' cursorstyle=''
// for example, see custom tag CF_ManageLists

// obj: object to be drag
// bgcolor: background color of dragged object when active
// followobj: a mirror of the dragged object that will follow mouse
// followHTML: innerHTML of followobj
function StartDrag(obj, bgcolor, followobj, followHTML)
{
		obj.setCapture(true);
		obj.backgroundcolor = obj.style.backgroundColor;
		obj.cursorstyle = document.body.style.cursor;
		var srcoffset=new Array(0,0); // to store the offset of event.srcElement from obj; event.offset is measured to the parent container (eg div, button, img)
		if (event.srcElement!=obj && (event.srcElement.tagName=="DIV" || event.srcElement.tagName=="IMG"))
			srcoffset=FindObjPos(event.srcElement,obj.tagName); //this may not work for nested tags (eg div within a div within a div)
		obj.eventoffsetX=event.offsetX+srcoffset[0];
		obj.eventoffsetY=event.offsetY+srcoffset[1];;
		obj.style.backgroundColor = bgcolor;
		if (appversion >= 6) document.body.style.cursor = 'move';
		var objPos = FindObjPos(obj);
		followobj.style.posTop=objPos[1];
		followobj.style.posLeft=objPos[0];
		followobj.innerHTML=followHTML;
		followobj.style.visibility="visible";
//document.all("test").innerHTML="offsetparent="+event.srcElement.offsetParent.tagName+";display="+event.srcElement.currentStyle.display+"; tag="+event.srcElement.tagName+"; scrollLeft="+document.body.scrollLeft+"; clientX="+event.clientX+"; eventoffsetX="+obj.eventoffsetX+";offsetParentX="+event.srcElement.offsetLeft;
}
function StartDrop(obj, followobj)
{
	if (obj.eventoffsetX!='-999')
	{
		obj.style.backgroundColor = obj.backgroundcolor;
		document.body.style.cursor=obj.cursorstyle;
		followobj.style.visibility="hidden";
		followobj.style.posLeft=0;
		followobj.style.posTop=0;
		obj.cursorstyle='';
		obj.backgroundcolor = '';
		obj.eventoffsetX='-999';
		eventoffsetY='-999';
	}
}
function FollowMouse(obj, followobj)
{
if (obj.eventoffsetX!='-999')
	{
	//document.all("test").innerHTML="scrollLeft="+document.body.scrollLeft+"; clientX="+event.clientX+"; eventoffsetX="+obj.eventoffsetX;
	followobj.style.posLeft=document.body.scrollLeft+event.clientX-obj.eventoffsetX;
	followobj.style.posTop=document.body.scrollTop+event.clientY-obj.eventoffsetY;
	}
}
/*-----------------------------------------------------------------------*/
function MTRtoggleClmCls(cls)
{
	var x=JSVCgetAllElementsByTagNameAndId(document,"INPUT","MTRCTL");
	var y=document.getElementById("MTRCTLTOGGLE"+cls);
	for(var i=0;i<x.length;i++)
		if(x[i].getAttribute("CLMCLS")==cls) x[i].checked=y.value&1;
	y.value=~y.value;
}
function MTRClmTypeSel(start)
{
	var col,itms,tot,url,rgexp;
	tot=0;
	col=JSVCgetAllElementsByTagNameAndId(document,"INPUT","MTRCTL");
	if(col!=null && col.length>0)
	{
		for(itms=0;itms<col.length;itms++)
			if(col[itms].checked)
				tot=tot+parseInt(col[itms].value);
		if(tot==start)
			JSVCcloseCtxMenu(document.getElementById('MTRCTContextMenu'));
		else
		{
			rgexp = /[&](ct)[=][^&]*/gi;
			url=window.location.href.replace(rgexp,"");
			window.location.href=url+"&CT="+tot;
		}
	}
}

function InsFilterSel(Inscoid) // Lim Soon Eng #45564: [TH] All - Enhance on the ecosystem (Search by "Insurer" on the "Claims Home" screen) //
{
	var url,rgexp;
	//rgexp = /[&](INSCOIDSELECT)[=][^&]*/gi;
	//url=window.location.href.replace(rgexp,"");
	url=JSVCremoveURL(window.location.href,"INSCOIDSELECT");
	console.log(url);
	window.location.href=url+"&INSCOIDSELECT="+Inscoid;
}

function MRMComfirmPrompt(action,confirmtext)
{
	if(confirmtext==null || confirmtext=="")
		confirmtext=JSVClang("CONFIRM",5018)
	else
		confirmtext=Trim(confirmtext).toUpperCase();
	if(Trim(window.prompt(JSVClang("Are you sure you want to {0}?\nType {1} to confirm.",5019,0,action,confirmtext),"")).toUpperCase()==confirmtext)
		return true
	else
	{
		alert(JSVClang("You didn't "+"{0}"+". "+"{1}"+" cancelled.",5020,0,confirmtext,action));
		return false;
	}
}

function MTRprofilelink(coid,nodisp)
{
	var a="<a onmouseover='this.style.textDecorationNone=true' onmousedown='event.cancelBubble=true;' onmouseup='event.cancelBubble=true;' onclick='event.cancelBubble=true;' target=_blank href='"+request.webroot+"index.cfm?fusebox=MTRadminwprep&fuseaction=dsp_repReport&COID="+coid+"&"+request.mtoken+"' class=clsMTRprofilelink>&nbsp;"+JSVClang("PROFILE",3591)+"&nbsp;</a>";
	if(nodisp>0) return a;
	document.write(a);
	return a;
}
function LinkBack(type,dowarn,urlparams,urlin)
{
	var v,nm,pos;
	nm='';
	v='';
	if(urlparams==null)
		urlparams="";
	if(type==1)
	{
		nm=JSVClang("return to Claim Subfolder",3530);
		if(urlparams=="")
		{
			if((typeof(jscaseid))!="undefined" && jscaseid>0)
			{
				urlparams="caseid="+jscaseid;
			} else
				type=-1;
		}
		if((window.location.search).toUpperCase().indexOf("TPINS=1")>=0 && request.mtoken.toUpperCase().indexOf("TPINS=1")<0 && urlparams.toUpperCase().indexOf("TPINS=1")<0)
			urlparams+="&tpins=1";
	}
	nm=(nm==""?JSVClang("go back",5012):nm);
	if(dowarn)
		if(!warn(nm))
			return;
	if(type==-1)
		window.history.go(-1)
	else if(type==1)
	{
		window.location.href=request.webroot+"index.cfm?fusebox=MTRroot&fuseaction=dsp_clmheader&"+(urlparams==""?"":urlparams+"&")+request.mtoken;
	}
	else if(urlin==null || urlin=="")
		window.location.href=urlback
	else
		window.location.href=urlin;
}
function MTRrepPcBar(pc,rpdesc,noofr,vrepcardid)
{	// noofr: show (no offerr)
	// vrepcardid: clickable to show repstgid (don't pass in to make non-clickable)
	var amt1,amt2,txt;
	amt1=(200-parseInt(pc/100*200)).toString(16);if((amt1.length)==1)amt1+="0";
	amt2=(parseInt(pc/100*200)).toString(16);if((amt2.length)==1)amt2+="0";
	txt=(vrepcardid>0?"<a style=cursor:pointer target=repstage href=\""+request.webroot+"index.cfm?fusebox=MTRrepmgmt&fuseaction=dsp_viewrepairstages&irepcardid="+vrepcardid+"&"+request.mtoken+"\">":"")+"<span"+(pc>40?" style=color:white>":">")+rpdesc+" - "+pc+"%"+(noofr>0?" "+JSVClang("(without offer)",3502):"")+"</span>"+(vrepcardid>0?"</a>":"");
	document.write("<table border=0 cellspacing=0 cellpadding=0 width=100% style=font-weight:bold;padding:0><tr>"+
		// Left part
		(pc>0?"<td style=\"width:"+pc+"%;text-align:right;background-color:"+(pc<=50?"red":(pc<100?"orange":"green"))+";color:white;filter:progid:DXImageTransform.Microsoft.Gradient(GradientType=1,StartColorStr='#EE0000',EndColorStr='#"+amt1+amt2+"00')\">"+(pc>40?txt:"")+"&nbsp;</td>":"")+
		// Right part
		(pc<100?"<td>&nbsp;"+(pc<=40?txt:"")+"</td>":"")+"</tr></table>");
}
function MTRDirSearch(obj,obj2)
{	var s,o,t,u,supper, minSearchString=3;
	var isRFQ=0;

	if(jSVClocid && jSVClocid == 17) minSearchString = 2;
	if(obj.value.indexOf("#")==0)isRFQ=1; // reserve for search for RFQ when start with #
	if (typeof obj2 != "undefined" && obj2){o=obj2.value;} //lisa note: does not seem to be used.
	else{o=document.getElementById('SRCHTYPE').value;} // search type
	if(o==12) { // Date of Loss
		u=obj.value.replace(/[^0-9\/\-]/gi,"");
		s=CalParseDate(u);
		if(s!=null)	s=s.getDate().toString().padLeft("0",2)+"/"+(s.getMonth()+1).toString().padLeft("0",2)+"/"+s.getFullYear();
		else {
			SVCalert(JSVClang("Invalid date format",18083));s="";return;
		}
	}
	else if(jSVClocid && typeof request.DS.LOCALES[jSVClocid] != 'undefined' && typeof request.DS.LOCALES[jSVClocid].UNICODE != 'undefined' && request.DS.LOCALES[jSVClocid].UNICODE == 1 ) /*21208*/
		s=obj.value.replace(/[\s]/gi,"");
	else
		s=obj.value.replace(/[^A-Z0-9\/\- ]/gi,"");
	if(o==1)
	{
		if(s.length<minSearchString)
			{SVCalert(JSVClang("Search string too short",18084));return;}
	}
	else if(o==8)
	{
		if(s.length<=0)
			{SVCalert(JSVClang("Search string too short",18084));return;}
	}
	else if(s.length<minSearchString)
		{SVCalert(JSVClang("Search string too short",18084));return;}
	supper=s.toUpperCase();
	if(supper=="MOHD"||supper=="SDN"||supper=="BIN"||supper=="BINTI"||supper=="BHD"||supper=="SDNBHD")
		{SVCalert(JSVClang("Search string too common, try another",18085));return;}
	t=obj.getAttribute("SEARCHED");
	if(t=="1")return;
	obj.setAttribute("SEARCHED","1");

	if(o==8 || isRFQ) { // RFQ No.
		window.location=request.webroot+"index.cfm?fusebox=MTRsupplier&fuseaction=dsp_quotemain&esid="+s+"&"+request.mtoken;
	}
	else
		window.location=request.webroot+"index.cfm?fusebox=MTRclaim&fuseaction=dsp_clmdirsearch&srch="+s+"&srchtype="+o+"&"+request.mtoken;
}

function MTRGenSearchCustom(orgtype,preselect,gcoid,pretext,clmtypemask)
{
    var str = ""; var btnclass="clsButton";

	if (clmtypemask==null) clmtypemask=-1;
//	document.write("<div style=position:absolute;left:300px;top:76px;width:600px id=clmdirsearchbox>");
//	SkinBorderBegin(12);

    if (JSVCGetResp())
        str="<div class='text-right col-sm-12 col-md-12 col-xs-12 clsNoPrint' id='multiSearchTbl'><div class='input-group input-search pull-right'>";
    else
    	if (orgtype=="G"&&jSVClocid==11)
        	str="<table cellpadding=0 cellspacing=0 align=right class=clsNoPrint id='multiSearchTbl'><tr>"+"<td style=text-align:right>"+"<span style=color:darkred;font-weight:bold;font-size:90%><b>"+JSVClang("Enter Search Information Here:",40096)+"</b>&nbsp;</span>";
        else
        	str="<table cellpadding=0 cellspacing=0 align=right class=clsNoPrint id='multiSearchTbl'><tr>"+"<td style=text-align:right>";

	str +="<select style=font-weight:bold;color:maroon URLVAR name=SRCHTYPE id=SRCHTYPE onkeypress=\"if(event.type=='keypress'&&event.keyCode==13)MTRDirSearch( document.getElementById('SRCH') )\">"+
	"<OPTION VALUE=0 "+(preselect==0?" selected":"")+">"+JSVClang("Multi-Search",25461)+
	(parseInt(clmtypemask&2449407)>0||orgtype=="S"||orgtype=='EA'?"<OPTION VALUE=1 "+(preselect==1?" selected":"")+">"+JSVCsymbol("REGNO",(parseInt(clmtypemask&2097152)>0||orgtype=='EA'?JSVClang("Invoice",2020)+"/":"")+JSVClang("Vehicle Reg. No.",1534)        ):"")+
	(orgtype=="S"?"":"<OPTION VALUE=2"+(preselect==2?" selected":"")+">"+JSVClang("Ins/Clmt Name",25462)+"<OPTION VALUE=3"+(preselect==3?" selected":"")+">"+(gcoid==900014?JSVClang('Emirates ID',0):JSVClang('Ins/Clmt NRIC',25463)))+
	"<OPTION VALUE=4"+(preselect==4?" selected":"")+">"+JSVClang("Ins Claim No",25464)+
	((gcoid==200036)&&orgtype=="I"?"<OPTION VALUE=45"+(preselect==45?" selected":"")+">"+JSVClang("Insured Driver Name",0):"")+
	((gcoid==200036)&&orgtype=="I"?"<OPTION VALUE=46"+(preselect==46?" selected":"")+">"+JSVClang("Insured Driver's ID",0):"")+
	((gcoid==200036)&&orgtype=="I"?"<OPTION VALUE=47"+(preselect==47?" selected":"")+">"+JSVClang("External Ref. No.",0):"")+
	((orgtype=="I"||((orgtype=="A"||orgtype=='G'||orgtype=='R')&&(jSVClocid==11)))?"<OPTION VALUE=29"+(preselect==29?" selected":"")+">"+JSVClang("Claim Notification No.",8794):"")+
	((orgtype=="P")?"<OPTION VALUE=30"+(preselect==30?" selected":"")+">"+JSVClang("Claim Notification No.",8794):"")+
	(gcoid!=900014&&(parseInt(clmtypemask&67108864)>0||orgtype=="A"||orgtype=="I"||orgtype=='R')?"<OPTION VALUE=5"+(preselect==5?" selected":"")+">"+JSVClang("Certificate No",9708):"")+
	"<OPTION VALUE=6"+(preselect==6?" selected":"")+">"+JSVClang("Ins Policy No",25465)+
	((jSVClocid==7)&&orgtype=="I"?"<OPTION VALUE=33"+(preselect==33?" selected":"")+">"+JSVClang("Case ID",25466):"")+
	(parseInt(clmtypemask&~352255)>0||orgtype=="G"?"<OPTION VALUE=12"+(preselect==12?" selected":"")+">"+JSVClang("Date of Loss",2919):"")+
	(gcoid!=900014&&orgtype=="I"?"<OPTION VALUE=37"+(preselect==37?" selected":"")+">"+JSVClang("Internal File No",6759):"")+
	((gcoid==700162||gcoid==701479)&&orgtype=="I"?"<OPTION VALUE=7"+(preselect==7?" selected":"")+">"+JSVClang("Agent/Intermediary Code",25467):"")+
	(orgtype=="S"?"<OPTION VALUE=8"+(preselect==8?" selected":"")+">"+JSVClang("RFQ No.",25468):"")+
	(orgtype=="A"?"<OPTION VALUE=32"+(preselect==32?" selected":"")+">"+JSVClang("Adj File Ref No.",25469):"")+
	(orgtype=="L"?"<OPTION VALUE=11"+(preselect==11?" selected":"")+">"+JSVClang("Solicitor Own Ref No.",25470):"")+
	(orgtype=="EA"||orgtype=="R"?"<OPTION VALUE=51"+(preselect==51?" selected":"")+">"+JSVClang("Internal Claim/File Ref No.",0):"")+
    ((gcoid==3060||gcoid==1600001||gcoid==200035)&&orgtype=="I"?"<OPTION VALUE=13"+(preselect==13?" selected":"")+">"+JSVClang("Leader Name",10618):"")+
    ((gcoid==3060||gcoid==1600001||gcoid==200035)&&orgtype=="I"?"<OPTION VALUE=14"+(preselect==14?" selected":"")+">"+JSVClang("Leader Ref No",25471):"")+
	  ((gcoid==1700019)&&orgtype=="I"?"<OPTION VALUE=52"+(preselect==52?" selected":"")+">"+JSVClang("Contact Number",28870)+" 1":"")+
	(parseInt(clmtypemask&1048576)>0&&gcoid==200045&&orgtype=="I"?"<OPTION VALUE=23"+(preselect==23?" selected":"")+">"+JSVClang("I-Report No",25472):"")+
    /*(gcoid==3060&&orgtype=="I"?"<OPTION VALUE=15"+(preselect==15?" selected":"")+">"+JSVClang("Acc/Loss Place",1167):"")+*/
	(orgtype=="I"?"<OPTION VALUE=24"+(preselect==24?" selected":"")+">"+JSVClang("Injured Person Name/ID",25473):"")+
	(gcoid!=900014&&orgtype=="I"?"<OPTION VALUE=34"+(preselect==34?" selected":"")+">"+JSVClang("Payment Voucher No",4328):"")+
	(gcoid!=900014&&orgtype=="I"?"<OPTION VALUE=36"+(preselect==36?" selected":"")+">"+JSVClang("Claim Form No",4292):"")+
	(gcoid==200036 && orgtype=="I" ? "<OPTION VALUE=58"+(preselect==58?" selected":"")+">"+JSVClang("Adjuster Ref No",0) : "")+
	(gcoid==200036 && orgtype=="I" ? "<OPTION VALUE=57"+(preselect==57?" selected":"")+">"+JSVClang("Claim Acknowledgement Number",0) : "")+
	(orgtype=="S"?"<OPTION VALUE=38"+(preselect==38?" selected":"")+">"+JSVClang("Invoice No.",4573):"")+
	(gcoid==200036 && orgtype=="I" ? "<OPTION VALUE=17"+(preselect==17?" selected":"")+">"+JSVClang("Vessel Name",0) : "")+
	(gcoid==200036 && orgtype=="I" ? "<OPTION VALUE=54"+(preselect==54?" selected":"")+">"+JSVClang("Storage Place",0) : "")+
	(gcoid==200036 && orgtype=="I" ? "<OPTION VALUE=55"+(preselect==55?" selected":"")+">"+JSVClang("Flight No.",0) : "")+
	(gcoid==200036 && orgtype=="I" ? "<OPTION VALUE=56"+(preselect==56?" selected":"")+">"+JSVClang("Truck No.",0) : "")+
	(gcoid==200036 && orgtype=="I" ? "<OPTION VALUE=59"+(preselect==59?" selected":"")+">"+JSVClang("Intermediary Ref. No.",0) : "")+
	(gcoid==200036 && orgtype=="I" ? "<OPTION VALUE=61"+(preselect==61?" selected":"")+">"+JSVClang("Certificate No.",0) : "")+
	(gcoid==200036 && orgtype=="I" ? "<OPTION VALUE=62"+(preselect==62?" selected":"")+">"+JSVClang("Intimation Ref. No.",0) : "")+
	"</SELECT>&nbsp;<INPUT SEARCHED=0 maxlength=50 size=20 URLVAR NAME=SRCH id=SRCH onkeypress=\"if(event.type=='keypress'&&event.keyCode==13)MTRDirSearch( document.getElementById('SRCH') )\" value=\""+(pretext?pretext:"")+"\">";
    if (JSVCGetResp())
    {
        btnclass = "mrm-btn btn btn-xs"
        str += "<span class='input-group-btn'>";
    }
	str += "<input type=button class=\""+btnclass+"\" onclick=\"MTRDirSearch( document.getElementById('SRCH') )\" value=\""+JSVClang("Go",11203)+"\" style=margin-bottom:1;margin-right:2 id=clmdirgobtn>";
	if(gcoid==1700019 && orgtype=="I"){
		if (JSVCGetResp())
        	str+="</span></div><div><span>";
		else
			str += "</td></tr><tr><td>";
		
		str += "<span style='color:red; font-size: 130%;'>"+JSVClang("Search information: Please search by EW order number, customer name, or phone number.",53306)+"</span>";
	}
    if (JSVCGetResp())
        str+="</span></div></div>";
    else
        str += "</td></tr></table>";

	document.write(str);
//	SkinBorderEnd(12);
//	document.write("</div>");
}

function MTRGenSearch(orgtype,preselect,gcoid,pretext,clmtypemask)
{
	if(gcoid==1700019 && orgtype=="I"){
		MTRGenSearchCustom(orgtype,preselect,gcoid,pretext,clmtypemask);
		return;
	}

    var str = ""; var btnclass="clsButton";

	if (clmtypemask==null) clmtypemask=-1;
//	document.write("<div style=position:absolute;left:300px;top:76px;width:600px id=clmdirsearchbox>");
//	SkinBorderBegin(12);

    if (JSVCGetResp())
        str="<div class='text-right col-sm-12 col-md-12 col-xs-12 clsNoPrint'><div class='input-group input-search pull-right'>";
    else
    	if (orgtype=="G"&&jSVClocid==11)
        	str="<table cellpadding=0 cellspacing=0 align=right class=clsNoPrint><tr>"+"<td style=text-align:right>"+"<span style=color:darkred;font-weight:bold;font-size:90%><b>"+JSVClang("Enter Search Information Here:",40096)+"</b>&nbsp;</span>";
        else
        	str="<table cellpadding=0 cellspacing=0 align=right class=clsNoPrint><tr>"+"<td style=text-align:right>";

	str +="<select style=font-weight:bold;color:maroon URLVAR name=SRCHTYPE id=SRCHTYPE onkeypress=\"if(event.type=='keypress'&&event.keyCode==13)MTRDirSearch( document.getElementById('SRCH') )\">"+
	"<OPTION VALUE=0 "+(preselect==0?" selected":"")+">"+JSVClang("Multi-Search",25461)+
	(parseInt(clmtypemask&2449407)>0||orgtype=="S"||orgtype=='EA'?"<OPTION VALUE=1 "+(preselect==1?" selected":"")+">"+JSVCsymbol("REGNO",(parseInt(clmtypemask&2097152)>0||orgtype=='EA'?JSVClang("Invoice",2020)+"/":"")+JSVClang("Vehicle Reg. No.",1534)        ):"")+
	(orgtype=="S"?"":"<OPTION VALUE=2"+(preselect==2?" selected":"")+">"+JSVClang("Ins/Clmt Name",25462)+"<OPTION VALUE=3"+(preselect==3?" selected":"")+">"+(gcoid==900014?JSVClang('Emirates ID',0):JSVClang('Ins/Clmt NRIC',25463)))+
	"<OPTION VALUE=4"+(preselect==4?" selected":"")+">"+JSVClang("Ins Claim No",25464)+
	((gcoid==200036)&&orgtype=="I"?"<OPTION VALUE=45"+(preselect==45?" selected":"")+">"+JSVClang("Insured Driver Name",0):"")+
	((gcoid==200036)&&orgtype=="I"?"<OPTION VALUE=46"+(preselect==46?" selected":"")+">"+JSVClang("Insured Driver's ID",0):"")+
	((gcoid==200036)&&orgtype=="I"?"<OPTION VALUE=47"+(preselect==47?" selected":"")+">"+JSVClang("External Ref. No.",0):"")+
	((orgtype=="I"||((orgtype=="A"||orgtype=='G'||orgtype=='R')&&(jSVClocid==11)))?"<OPTION VALUE=29"+(preselect==29?" selected":"")+">"+JSVClang("Claim Notification No.",8794):"")+
	((orgtype=="P")?"<OPTION VALUE=30"+(preselect==30?" selected":"")+">"+JSVClang("Claim Notification No.",8794):"")+
	(gcoid!=900014&&(parseInt(clmtypemask&67108864)>0||orgtype=="A"||orgtype=="I"||orgtype=='R')?"<OPTION VALUE=5"+(preselect==5?" selected":"")+">"+JSVClang("Certificate No",9708):"")+
	"<OPTION VALUE=6"+(preselect==6?" selected":"")+">"+JSVClang("Ins Policy No",25465)+
	((jSVClocid==7)&&orgtype=="I"?"<OPTION VALUE=33"+(preselect==33?" selected":"")+">"+JSVClang("Case ID",25466):"")+
	(parseInt(clmtypemask&~352255)>0||orgtype=="G"?"<OPTION VALUE=12"+(preselect==12?" selected":"")+">"+JSVClang("Date of Loss",2919):"")+
	(gcoid!=900014&&orgtype=="I"?"<OPTION VALUE=37"+(preselect==37?" selected":"")+">"+JSVClang("Internal File No",6759):"")+
	((gcoid==700162||gcoid==701479)&&orgtype=="I"?"<OPTION VALUE=7"+(preselect==7?" selected":"")+">"+JSVClang("Agent/Intermediary Code",25467):"")+
	(orgtype=="S"?"<OPTION VALUE=8"+(preselect==8?" selected":"")+">"+JSVClang("RFQ No.",25468):"")+
	(orgtype=="A"?"<OPTION VALUE=32"+(preselect==32?" selected":"")+">"+JSVClang("Adj File Ref No.",25469):"")+
	(orgtype=="L"?"<OPTION VALUE=11"+(preselect==11?" selected":"")+">"+JSVClang("Solicitor Own Ref No.",25470):"")+
	(orgtype=="EA"||orgtype=="R"?"<OPTION VALUE=51"+(preselect==51?" selected":"")+">"+JSVClang("Internal Claim/File Ref No.",0):"")+
    ((gcoid==3060||gcoid==1600001||gcoid==200035)&&orgtype=="I"?"<OPTION VALUE=13"+(preselect==13?" selected":"")+">"+JSVClang("Leader Name",10618):"")+
    ((gcoid==3060||gcoid==1600001||gcoid==200035)&&orgtype=="I"?"<OPTION VALUE=14"+(preselect==14?" selected":"")+">"+JSVClang("Leader Ref No",25471):"")+
	  ((gcoid==1700019)&&orgtype=="I"?"<OPTION VALUE=52"+(preselect==52?" selected":"")+">"+JSVClang("Contact Number",28870)+" 1":"")+
	(parseInt(clmtypemask&1048576)>0&&gcoid==200045&&orgtype=="I"?"<OPTION VALUE=23"+(preselect==23?" selected":"")+">"+JSVClang("I-Report No",25472):"")+
    /*(gcoid==3060&&orgtype=="I"?"<OPTION VALUE=15"+(preselect==15?" selected":"")+">"+JSVClang("Acc/Loss Place",1167):"")+*/
	(orgtype=="I"?"<OPTION VALUE=24"+(preselect==24?" selected":"")+">"+JSVClang("Injured Person Name/ID",25473):"")+
	(gcoid!=900014&&orgtype=="I"?"<OPTION VALUE=34"+(preselect==34?" selected":"")+">"+JSVClang("Payment Voucher No",4328):"")+
	(gcoid!=900014&&orgtype=="I"?"<OPTION VALUE=36"+(preselect==36?" selected":"")+">"+JSVClang("Claim Form No",4292):"")+
	(gcoid==200036 && orgtype=="I" ? "<OPTION VALUE=58"+(preselect==58?" selected":"")+">"+JSVClang("Adjuster Ref No",0) : "")+
	(gcoid==200036 && orgtype=="I" ? "<OPTION VALUE=57"+(preselect==57?" selected":"")+">"+JSVClang("Claim Acknowledgement Number",0) : "")+
	(orgtype=="S"?"<OPTION VALUE=38"+(preselect==38?" selected":"")+">"+JSVClang("Invoice No.",4573):"")+
	(gcoid==200036 && orgtype=="I" ? "<OPTION VALUE=17"+(preselect==17?" selected":"")+">"+JSVClang("Vessel Name",0) : "")+
	(gcoid==200036 && orgtype=="I" ? "<OPTION VALUE=54"+(preselect==54?" selected":"")+">"+JSVClang("Storage Place",0) : "")+
	(gcoid==200036 && orgtype=="I" ? "<OPTION VALUE=55"+(preselect==55?" selected":"")+">"+JSVClang("Flight No.",0) : "")+
	(gcoid==200036 && orgtype=="I" ? "<OPTION VALUE=56"+(preselect==56?" selected":"")+">"+JSVClang("Truck No.",0) : "")+
	(gcoid==200036 && orgtype=="I" ? "<OPTION VALUE=59"+(preselect==59?" selected":"")+">"+JSVClang("Intermediary Ref. No.",0) : "")+
	(gcoid==200036 && orgtype=="I" ? "<OPTION VALUE=61"+(preselect==61?" selected":"")+">"+JSVClang("Certificate No.",0) : "")+
	(gcoid==200036 && orgtype=="I" ? "<OPTION VALUE=62"+(preselect==62?" selected":"")+">"+JSVClang("Intimation Ref. No.",0) : "")+
	"</SELECT>&nbsp;<INPUT SEARCHED=0 maxlength=50 size=20 URLVAR NAME=SRCH id=SRCH onkeypress=\"if(event.type=='keypress'&&event.keyCode==13)MTRDirSearch( document.getElementById('SRCH') )\" value=\""+(pretext?pretext:"")+"\">";
    if (JSVCGetResp())
    {
        btnclass = "mrm-btn btn btn-xs"
        str += "<span class='input-group-btn'>";
    }
	str += "<input type=button class=\""+btnclass+"\" onclick=\"MTRDirSearch( document.getElementById('SRCH') )\" value=\""+JSVClang("Go",11203)+"\" style=margin-bottom:1;margin-right:2 id=clmdirgobtn>";

    if (JSVCGetResp())
        str+="</span></div></div>";
    else
        str += "</td></tr></table>";

	document.write(str);
//	SkinBorderEnd(12);
//	document.write("</div>");
}
function MTRGLink(o,col,p3)
{	var caseid,tpins,ocol,args,rno,t2,postfix,extid;
	if(o.rowstore!=null)
	{caseid=o.rowstore[0];tpins=o.rowstore[1];}
	else
	{caseid=o.rowcur[0];tpins=0;}
//	MTRGLink
	if(p3=="P"||p3=="P2")
		extid=o.rowcur[2];
	else if(p3=="A")
		extid=o.rowcur[15];
	ocol=o.collist[col];
	rno=o.rowcur[ocol.ord];
	t2=rno.split("#");postfix=SVChtm(t2[1],2,new Array(/{([^}]*)}/g),new Array("<div style=color:darkred;font-weight:bold;font-size:90%>$1</div>"));rno=t2[0];if(postfix==null)postfix="";
//	if(p3=="I" && o.rowcur.length>=14 && o.rowcur[13]!=null && o.rowcur[13]!='')
//		postfix+="<div style=padding:1px>"+o.rowcur[13]+"</div>";
	if(p3.substring(0,3)=='TEN') //tender
		return "<td style=text-align:left class="+ocol.sty+"><a href=\""+request.webroot+"index.cfm?fusebox=MTR"+(p3=="TENI"?"insureretender":(p3=="TENA"?"adjusteretender": "repaireretender"))+"&fuseaction=dsp_tender&itender="+o.rowcur[0]+(p3=="TENR"?"&repcoid="+o.rowstore[1]:"")+"&"+request.mtoken+"\"><b>"+(rno==""?o.rowcur[1]+"</b>":rno+"</b>")+"</a>"+postfix+"</td>";
	else if(p3.substring(0,3)=='NMC') //new NM claim module
		return "<td style=text-align:left class="+ocol.sty+"><a href=\""+request.webroot+"index.cfm?fusebox=MTRinsurer&fuseaction=dsp_clmcrt&caseid="+o.rowcur[0]+(caseid!=o.rowcur[0]?"&vcaseid="+caseid:"")+(p3=="I"&&tpins==1?"&tpins="+tpins:"")+(extid!=null?"&extid="+extid:"")+"&"+request.mtoken+"\"><b>"+(p3=="P2"?rno+"</b>":(rno==""?o.rowcur[1]+"</b>":rno+"</b><br>"+o.rowcur[1]))+"</a>"+postfix+"</td>";
	else if(jSVClocid==11)
		return "<td style=text-align:center class="+ocol.sty+"><a href=\""+request.webroot+"index.cfm?fusebox=MTR"+(p3=="I"?"insurer":(p3=="A"?"adjuster":(p3=="P"||p3=="P2"?"other":"repairer")))+"&fuseaction=dsp_clmheader&caseid="+o.rowcur[0]+(caseid!=o.rowcur[0]?"&vcaseid="+caseid:"")+(p3=="I"&&tpins==1?"&tpins="+tpins:"")+(extid!=null?"&extid="+extid:"")+"&"+request.mtoken+"\"><b>"+(p3=="P2"?rno+"</b>":(rno==""?o.rowcur[1]+"</b>":rno+"</b><br>"+o.rowcur[1]))+"</a>"+postfix+"</td>";
	else if(jSVClocid==2 && o.rowcur[o.rowcur.length-1]==0 && o.rowcur[2].substring(0,5)=="NM WC")
		return "<td style=text-align:left class="+ocol.sty+"><a href=\""+request.webroot+"index.cfm?fusebox=MTRclaim&fuseaction=dsp_clmreg&caseid="+o.rowcur[0]+(caseid!=o.rowcur[0]?"&vcaseid="+caseid:"")+(p3=="I"&&tpins==1?"&tpins="+tpins:"")+(extid!=null?"&extid="+extid:"")+"&"+request.mtoken+"\"><b>"+(p3=="P2"?rno+"</b>":(rno==""?o.rowcur[1]+"</b>":rno+"</b><br>"+o.rowcur[1]))+"</a>"+postfix+"</td>";
	else
		return "<td style=text-align:left class="+ocol.sty+"><a href=\""+request.webroot+"index.cfm?fusebox=MTR"+(p3=="I"?"insurer":(p3=="A"?"adjuster":(p3=="P"||p3=="P2"?"other":"repairer")))+"&fuseaction=dsp_clmheader&caseid="+o.rowcur[0]+(caseid!=o.rowcur[0]?"&vcaseid="+caseid:"")+(p3=="I"&&tpins==1?"&tpins="+tpins:"")+(extid!=null?"&extid="+extid:"")+"&"+request.mtoken+"\"><b>"+(p3=="P2"?rno+"</b>":(rno==""?o.rowcur[1]+"</b>":rno+"</b><br>"+o.rowcur[1]))+"</a>"+postfix+"</td>";
}
function MTRGLink2(o,col,p3) /* for TH MSIG, link for the clm notification no.*/
{	var caseid,tpins,ocol,args,rno,t2,postfix,extid;
	if(o.rowstore!=null)
	{caseid=o.rowstore[0];tpins=o.rowstore[1];}
	else
	{caseid=o.rowcur[0];tpins=0;}
//	MTRGLink

	if(p3=="P"||p3=="P2")
		extid=o.rowcur[2];
	ocol=o.collist[col];
	rno=o.rowcur[ocol.ord];
	t2=rno.split("#");postfix=SVChtm(t2[1],2,new Array(/{([^}]*)}/g),new Array("<div style=color:darkred;font-weight:bold;font-size:90%>$1</div>"));rno=t2[0];if(postfix==null)postfix="";
	if(jSVClocid==17 && p3=="I")
		return "<td style=text-align:center class="+ocol.sty+"><a href=\""+request.webroot+"index.cfm?fusebox=MTR"+(p3=="I"?"insurer":(p3=="A"?"adjuster":(p3=="P"||p3=="P2"?"other":"repairer")))+"&fuseaction=dsp_clmheader&caseid="+o.rowcur[0]+(caseid!=o.rowcur[0]?"&vcaseid="+caseid:"")+(p3=="I"&&tpins==1?"&tpins="+tpins:"")+(extid!=null?"&extid="+extid:"")+"&"+request.mtoken+"\"><b>"+(p3=="P2"?rno+"</b>":(rno==""?o.rowcur[1]+"</b>":rno+"</b>"))+"</a>"+postfix+"</td>";
	else
		return "<td style=text-align:left class="+ocol.sty+"><a href=\""+request.webroot+"index.cfm?fusebox=MTR"+(p3=="I"?"insurer":(p3=="A"?"adjuster":(p3=="P"||p3=="P2"?"other":"repairer")))+"&fuseaction=dsp_clmheader&caseid="+o.rowcur[0]+(caseid!=o.rowcur[0]?"&vcaseid="+caseid:"")+(p3=="I"&&tpins==1?"&tpins="+tpins:"")+(extid!=null?"&extid="+extid:"")+"&"+request.mtoken+"\"><b>"+(p3=="P2"?rno+"</b>":(rno==""?o.rowcur[1]+"</b>":rno+"</b>"))+"</a>"+postfix+"</td>";
}

function MTRIDay(o,col,p3)
{	var clmflow,ocol,val,valint,sty;
	clmflow=o.rowcur[2].substring(0,2);
	ocol=o.collist[col];sty="";val=o.rowcur[ocol.ord];
	if(val!="")
	{	valint=parseInt(o.rowcur[ocol.ord]);
		if((clmflow=="TF"&&valint>=90)||(clmflow!="TF"&&valint>=14))sty=" style=color:red"
		else if((clmflow=="TF"&&valint>=60)||(clmflow!="TF"&&valint>=7))sty=" style=color:orange";
	}
	return "<td align=center "+sty+">"+(val==""||val==null?"&nbsp;":val)+"</td>";
}
function DocRpt(orgtype,caseid,corole,extid)
{
	var doctype;
	doctype='';
	if(corole==null)
		corole=0;
	if(orgtype=='R')
		doctype='REPEST'
	else if(orgtype=='I')
		doctype='INSRPT'
	else if(orgtype=='RI')
		doctype='INSOFF'
	else if(orgtype=='A')
		doctype='ADJRPT'
	else if(orgtype=='AL')
		doctype='ADJLAST';
	else if(orgtype=='ARO')//#38270
		doctype='ADJRO'
	if(doctype!='')
		window.open(request.webroot+'index.cfm?fusebox=MTRclaim&fuseaction=gen_docview&caseid='+caseid+(extid!=null?'&extid='+extid:'')+'&doctype='+doctype+'&corole='+corole+'&'+request.mtoken,'_blank');
}
function MTRConfirmDecision(dec,cotype,urlparam)
{
	var conf,fb,fa;
	if(cotype=="R")
	{fb="MTRrepairer";fa="rep";}
	else
	{fb="MTRother";fa="oth";}
	if(urlparam==null)urlparam="";
	if(dec==1)
		conf=confirm(JSVClang("You are about to accept an offer. Please click OK to confirm or CANCEL to abort.",1026))
	else
	if(dec==2)
		conf=confirm(JSVClang("You are about to reject an offer and Close the Claim as TOWED-OUT. Please click OK to confirm or CANCEL to abort.",5192))
	else
	if(dec==4)
		conf=confirm(JSVClang("You are about to withdraw an appeal you submitted earlier. Please click OK to confirm or CANCEL to abort.",6338))
	else
	{
		location.href=request.webroot+"index.cfm?fusebox="+fb+"&fuseaction=dsp_"+fa+"appeal&"+urlparam+"&"+request.mtoken;
		return;
	}
	if(conf)
		location.href=request.webroot+"index.cfm?fusebox="+fb+"&fuseaction=act_"+fa+"ofrdec&"+urlparam+"&acceptid="+dec+"&"+request.mtoken;
}
function MTRPolDesc(p1val,p2val,p3val,p1,p2,p3)
{
	var htm='';
	p1val=(p1val==null||p1val==0?'':p1val);
	p2val=(p2val==null||p2val==0?'':p2val);
	p3val=(p3val==null||p3val==0?'':p3val);

	if(p1!='' && p1val!='' && p1[p1val] !== undefined)
		p1=p1[p1val].name;
	else
		p1='';

	if(p2!='' && p1val!='' && p2val!='' && p2[p2val] !== undefined)
		p2=p2[p2val].name;
	else
		p2='';

	if(p3!='' && p3val!='' && p3val!='' && p3[p3val] !== undefined)
		p3=p3[p3val].name;
	else
		p3='';

	//htm+='<tr><td>Policy Class</td><td>'+p1+'</td><td>Policy Type</td><td>'+p2+'</td></tr>';
	//htm+='<tr><td>Policy Category</td><td>'+p3+'</td><td></td><td></td></tr>';
	//htm+='<tr><td>Policy Classification:</td><td colspan=3>'+p1+(p2!=''? ' / '+p2:'')+(p3!=''? ' / '+p3:'')+'</td></tr>';
	htm+=(p1!=''?p1:'')+(p2!=''? ' / '+p2:'')+(p3!=''? ' / '+p3:'');
	//document.write(htm);
	return htm;
}

function MTRnatureList(coid,clmtypemask,cfcode,logicname) {
	var a=request.DS.DMGTYPE;
	if(!a) return "";

	var xcoid=JSVCqueryGetColNo(a,"iCOID");
	var xclmtypemask=JSVCqueryGetColNo(a,"iCLMTYPEMASK");
	var xcfcode=JSVCqueryGetColNo(a,"vaCFCODE");
	var xcfdesc=JSVCqueryGetColNo(a,"vaCFDESC");
	var xlid=JSVCqueryGetColNo(a,"iLID");
	var xlogicname=JSVCqueryGetColNo(a,"vaLOGICNAME");
	var xcfmapcode=JSVCqueryGetColNo(a,"vaCFMAPCODE");

	if(xcoid==-1||xclmtypemask==-1||xcfcode==-1||xcfdesc==-1) return "";

	var q=a;
	//document.write('<textarea>'+q.DATA+'</textarea>');

	if (coid!=null) {
		var chk_data = JSVCqueryFindRows(q,xcoid,coid);

		// if got no matched COID in the request.DS.DMGTYPE, set COID to 0 (default dataset)
		if (chk_data.DATA.length == 0) {
			coid = 0
		}
	} else {
		// if coid is NULL, set COID to 0
		coid = 0
	}
		
	if(coid>0) {
		q=JSVCqueryFindRows(q,xcoid,coid);
	} else if (coid!=null) {
		q=JSVCqueryFindRows(q,xcoid,0); // default iCOID=0
	}

	if(clmtypemask!=null) {
		q=JSVCqueryFindRows(q,xclmtypemask,function(item){return (item&clmtypemask)>0});
	}
	if(logicname!=null && logicname!='') {
		q=JSVCqueryFindRows(q,xlogicname,logicname);
	}
	if(cfcode!=null) {
		q=JSVCqueryFindRows(q,xcfcode,cfcode);
	}
	var rs="";
	for(var i=0;i<q.DATA.length;i++) {
		var desc=q.DATA[i][xcfdesc];
		var cfmapcode=q.DATA[i][xcfmapcode];
		var lid=q.DATA[i][xlid];
		if(lid>0)
			desc=JSVClang(desc,lid);
		rs+=q.DATA[i][xcfcode]+"|"+/*(cfmapcode!=null&&cfmapcode!=''?cfmapcode+' - ':'')+*/desc+"|";
	}
	if(rs.length>0)
		rs=rs.substr(0,rs.length-1);
	return rs;
}

function MTRnatureList_Display(coid,clmtypemask,cfcode,logicname) {
	var a = request.DS.DMGTYPE;
	if(!a) return "";

	var xcoid=JSVCqueryGetColNo(a,"iCOID");
	var xclmtypemask=JSVCqueryGetColNo(a,"iCLMTYPEMASK");
	var xcfcode=JSVCqueryGetColNo(a,"vaCFCODE");
	var xcfdesc=JSVCqueryGetColNo(a,"vaCFDESC");
	var xlid=JSVCqueryGetColNo(a,"iLID");
	var xlogicname=JSVCqueryGetColNo(a,"vaLOGICNAME");
	var xcfmapcode=JSVCqueryGetColNo(a,"vaCFMAPCODE");

	if(xcoid==-1||xclmtypemask==-1||xcfcode==-1||xcfdesc==-1) return "";

	var q=a;
	if(coid > 0 && xcoid == coid) {
		q=JSVCqueryFindRows(q,xcoid,coid);
	} else if (coid!=null) {
		q=JSVCqueryFindRows(q,xcoid,0); // default iCOID=0
	}

	if(clmtypemask!=null) {
		q=JSVCqueryFindRows(q,xclmtypemask,function(item){return (item&clmtypemask)>0});
	}

	if(logicname!=null && logicname!='') {
		q=JSVCqueryFindRows(q,xlogicname,logicname);
	}

	if(cfcode!=null) {
		q=JSVCqueryFindRows(q,xcfcode,cfcode);
	}

	var rs="";
	for(var i=0;i<q.DATA.length;i++) {
		var desc=q.DATA[i][xcfdesc];
		var cfmapcode=q.DATA[i][xcfmapcode];
		var lid=q.DATA[i][xlid];
		if(lid>0)
			desc=JSVClang(desc,lid);
		rs+=q.DATA[i][xcfcode]+"|"+/*(cfmapcode!=null&&cfmapcode!=''?cfmapcode+' - ':'')+*/desc+"|";
	}
	if(rs.length>0)
		rs=rs.substr(0,rs.length-1);
	return rs;
}


function MTRPopUpWinModalDialog(address,width,height,scrollable)
{
	var mtrgmrmview;
	var width = width || 600;
	var height = height || 400;
	var scrollable = scrollable || true;
	try
	{
		if($dialog!=null) return;
		var myNav = navigator.userAgent.toLowerCase();

		/* required jquery-dialog.js*/
		$.showModalDialog({
                 url: address,
                 height: height,
                 width: width,
                 scrollable: scrollable,
                 onClose: function(){ mtrgmrmview = null;  }
            });

    mtrgmrmview = $dialog;

		if(window!=null)
			mtrgmrmview.opener = window;
	} catch(e)
	{
		mtrgmrmview = window.open(address,"Viewer","width="+width+",height="+height+",resizable=yes,status=no");
		if(window!=null)
			mtrgmrmview.opener = window;
	}

}

