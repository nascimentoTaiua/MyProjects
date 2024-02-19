<%@ Page Language="VB" AutoEventWireup="false" CodeFile="FrmVacaciones.aspx.vb" Inherits="FrmVacaciones" Culture="es-Es" UICulture="es-Es" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="asp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>Vacaciones</title>
    <link href="estilo.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript" language="javascript">
    // mantiene los valores de los textbox
        function checkDate(sender,args)
        {
            var dt = new Date();
            if(sender._selectedDate != null)
            {
                sender
                    ._textbox
                    /*.set_Value(dt.format(sender._format));*/
                    .set_Value(sender._selectedDate.format(sender._format))
            }
        }
        // Selecciona todos los checkbox del grid
        function SelectAllCheckboxes(spanChk){

            // Added as ASPX uses SPAN for checkbox
            var oItem = spanChk.children;
            
            var theBox=(spanChk.type=="checkbox")?spanChk:spanChk.children.item[0];
            xState=theBox.checked;

            elm=theBox.form.elements;
            for(i=0;i<elm.length;i++)
            if(elm[i].type=="checkbox" && elm[i].id!=theBox.id)
            {
            if(elm[i].checked!=xState)
            elm[i].click();
            }
        }
    // posiciona un popup al dar click en una celda del grid
    function toggleDiv(flagit,htmltext) {
    if (flagit=="1"){
	    if (document.layers) {
		    document.layers['overdiv'].visibility = "show"
		     document.getElementById('overdiv').innerHTML = "<a href='#' onclick =\"toggleDiv(0,'');\">Cerrar</a><br/><br/>"				
		     document.getElementById('overdiv').innerHTML += htmltext;

	    }
	    else if (document.all) {
		    document.all['overdiv'].style.visibility = "visible"
		     document.getElementById('overdiv').innerHTML = "<a href='#' class='link' onclick =\"toggleDiv(0,'');\">Cerrar</a><br/><br/>"				
		     document.getElementById('overdiv').innerHTML += htmltext;

	    }
	    else if (document.getElementById) { 
		    document.getElementById('overdiv').style.visibility = "visible"	
		    document.getElementById('overdiv').innerHTML = "<a href='#' class='link' onclick =\"toggleDiv(0,'');\">Cerrar</a> <br/><br/>"				
		    document.getElementById('overdiv').innerHTML += htmltext;
	    }
    	
    	
	    }
    else
     if (flagit=="0"){
	    if (document.layers) document.layers['overdiv'].visibility = "hide"
	    else if (document.all) document.all['overdiv'].style.visibility = "hidden"
	    else if (document.getElementById) document.getElementById('overdiv').style.visibility = "hidden"							}
    }

    </script>
</head>
<body>
    <form id="form1" runat="server" >
    <div id="overdiv"  class="overdiv"  >        
    </div>
    <div>
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnableScriptGlobalization="true" EnableScriptLocalization="true" >
        </asp:ScriptManager>
         <!--- Permite que los controles de ajax puedan ejecutarse dentro de un iframe --->
        <script type= "text/javascript">

            if (Sys.Browser.agent == Sys.Browser.InternetExplorer){

                Sys.UI.DomElement.getLocation=function(a){

                if(a.self||a.nodeType===9)

                    return new Sys.UI.Point(0,0);

                var b=a.getBoundingClientRect();

                if(!b)

                    return new Sys.UI.Point(0,0);

                var c=a.document.documentElement,d=b.left-2+c.scrollLeft,e=b.top-2+c.scrollTop;

                try{

                    var g=a.ownerDocument.parentWindow.frameElement||null;

                    if(g){

                        var f=2-(g.frameBorder||1)*2;

                    d+=f;e+=f

                    }

               }catch(h){}

               return new Sys.UI.Point(d,e)};

			}

		</script>

        <!-- --->
        <div id="sub_main">
            <div class="Titulo">
                <label>Solicitud de Vacaciones</label>
                <br />
                <hr class="linea2"/>
            </div>
            <br />
            
            <div id="cintilla1" class="cintilla" >
                &nbsp;Envíe su Solicitud
            </div>
            <div id="DivDatos" >
                
                    <div id="up">
                        <label class="label003">Del:</label>
                        <asp:TextBox ID="txtFechaInicio" runat="server" Width="100px" CssClass="combo" />
                        <img id="btnCal1" src="images/calendar_icon.gif" alt="" height="17" class="imgcal"/>
                        &nbsp; &nbsp; &nbsp; &nbsp;
                        <asp:RequiredFieldValidator ID="rfvFechaInicio" runat="server" ControlToValidate="txtFechaInicio" ValidationGroup="vldDatos">*</asp:RequiredFieldValidator>
                        &nbsp; &nbsp;&nbsp; &nbsp; &nbsp;&nbsp;
                        <label class="label003">Al:</label>
                        <asp:TextBox ID="txtFechaFin" runat="server" Width="100px" CssClass="combo" />        
                        <img id="btnCal2" src="images/calendar_icon.gif" alt="" height="17" class="imgcal"/>
                        &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;
                        <asp:RequiredFieldValidator ID="rfvFechaFin" runat="server" ControlToValidate="txtFechaFin" ValidationGroup="vldDatos">*</asp:RequiredFieldValidator>
                        &nbsp;
                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" PopupButtonID="btnCal1"  TargetControlID="txtFechaInicio" Format="dd/MM/yyyy" OnClientDateSelectionChanged="checkDate"></cc1:CalendarExtender>
                        <cc1:CalendarExtender ID="CalendarExtender2" runat="server" PopupButtonID="btnCal2"  TargetControlID="txtFechaFin"    Format="dd/MM/yyyy" OnClientDateSelectionChanged="checkDate"></cc1:CalendarExtender>
                    </div>
                    <div id="down">
                        Concepto:
                        <asp:DropDownList ID="ddlConceptos" runat="server" Width="200px" AppendDataBoundItems="True" CssClass="combo">
                            <asp:ListItem Value=" ">Seleccione</asp:ListItem>
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="ddlConceptos" ValidationGroup="vldDatos">*</asp:RequiredFieldValidator>&nbsp;&nbsp;
                        &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp; 
                        <asp:LinkButton ID="btnEnviar" runat="server" CssClass="btnEnviar" ValidationGroup="vldDatos" Width="50px">Enviar</asp:LinkButton><br />
                        <asp:ValidationSummary ID="vsGrp1" runat="server" HeaderText="(*) Campos Obligatorios"  ValidationGroup="vldDatos" />
                        <br />
                        <asp:CompareValidator ID="CompareValidator1" runat="server" ControlToValidate="txtFechaInicio"  ErrorMessage='La fecha de inicio no tiene un formato válido("DD/MM/AAAA")' Operator="DataTypeCheck" Type="Date" ValidationGroup="vldDatos"></asp:CompareValidator>
                        <asp:CompareValidator ID="cpvFechaFin" runat="server" ControlToValidate="txtFechaFin"  ErrorMessage='La fecha Final no tiene un formato válido("DD/MM/AAAA")' Operator="DataTypeCheck"  Type="Date" ValidationGroup="vldDatos"></asp:CompareValidator>
                        <asp:CompareValidator ID="cpvFechafin2" runat="server" ControlToCompare="txtFechaInicio"  ControlToValidate="txtFechaFin" ErrorMessage="La fecha final (Al) debe ser mayor a la fecha inicial (De)"  Operator="GreaterThanEqual" Type="Date" ValidationGroup="vldDatos"></asp:CompareValidator><br />
                    </div>
                <br />
                <br />
                <br />
            </div>
            <br />
            <div id="Div2" class="cintilla">
                &nbsp;Historial de Solicitudes
            </div>
            <br />
            <asp:Label ID="lbExcepcion" runat="server"></asp:Label>
            <br />
            <asp:GridView ID="gvSolicitudes" runat="server" DataKeyNames="RECNO" Width="550px" AllowPaging="True" PageSize="5" GridLines="None" CellPadding="4" ForeColor="Black">
                <Columns>
                    <asp:TemplateField HeaderText="Select All">
                        <ItemTemplate>
                            <asp:CheckBox ID="chkActive" runat="server" />
                        </ItemTemplate>
                        <HeaderTemplate>
                            <asp:CheckBox ID="chkAll" runat="server" onclick="javascript:SelectAllCheckboxes(this);" />
                        </HeaderTemplate>
                    </asp:TemplateField>
                </Columns>
                <RowStyle HorizontalAlign="Center" VerticalAlign="Middle" BackColor="#F7F6F3" ForeColor="#333333" />
                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" BackColor="Transparent" Font-Bold="True" ForeColor="Black" />
                <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                <PagerStyle BackColor="Transparent" ForeColor="Black" HorizontalAlign="Center" />
                <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                <EditRowStyle BackColor="#999999" />
                <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
            </asp:GridView>
            <br />
            <br />
            <br />
            <div class="estilo02" style="text-align:left;">
              <asp:LinkButton ID="btnEliminar" runat="server" CssClass="btnEliminar" Width="50px" Visible="False">Eliminar</asp:LinkButton><br />
                <hr class="linea2"/>
                <br />
            </div>                 
          </div> 
            

          
           
        </div>
    </form>
</body>
</html>
