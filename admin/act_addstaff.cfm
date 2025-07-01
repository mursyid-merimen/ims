<cfmodule TEMPLATE="/services/CustomTags\SVCDISABLEDIRECT.cfm" Path="#GetCurrentTemplatePath()#">
  
<!--- Include the modular form --->
<cfmodule template=".\dsp_staffform.cfm"
          iUSID="#iUSID#"
          isEdit="#isEdit#"
          staff="#staff#">