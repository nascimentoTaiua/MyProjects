<%@ Page Language="VB" AutoEventWireup="false" CodeFile="FrmPermisosyAusencias.aspx.vb" Inherits="FrmVacaciones" Culture="es-ES" UICulture="es-ES" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"  Namespace="System.Web.UI" TagPrefix="asp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>Untitled Page</title>
    <link href="estilo.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript" language="javascript">
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
        
        function SelectAllCheckboxes(spanChk){

            // Added as ASPX uses SPAN for checkbox
            var oItem = spanChk.children;
            var theBox=(spanChk.type=="checkbox")?spanChk:spanChk.children.item[0];
            xState=theBox.checked;

            elm=theBox.form.elements;
            for(i=0;i<elm.length;i++)
            if(elm[i].type=="checkbox" && elm[i].id!=theBox.id)
            {
            //elm[i].click();
            if(elm[i].checked!=xState)
            elm[i].click();
            //elm[i].checked=xState;
            }
        }
    function toggleDiv(flagit,htmltext) {
    if (flagit=="1"){
	    if (document.layers) {
		    document.layers['overdiv'].visibility = "show"
		    document.layers['overdiv'].innerHTML = htmltext;
	    }
	    else if (document.all) {
		    document.all['overdiv'].style.visibility = "visible"
		    document.all['overdiv'].innerHTML = htmltext;
	    }
	    else if (document.getElementById) { 
		    document.getElementById('overdiv').style.visibility = "visible"					
		    document.getElementById('overdiv').innerHTML = htmltext;
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
    <div id="sub_main">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnableScriptGlobalization="true" EnableScriptLocalization="true">
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
         <br />
        <div class="Titulo" >
            <label>Permisos y Ausencias</label>
            <br />
            <hr class="linea2" />
        </div>
        <br />
        <div id="cintilla1" class="cintilla" >
            Seleccione los datos para la b&uacute;squeda
        </div>
        <br />
        <div id="DivDatos">
            <table id="up1">
                <tr>
                    <td>
                        <label class="label003">Del:</label>   
                        <asp:TextBox ID="txtFechaInicio" runat="server" Width="100px" />
                        <img id="btnCal1" src="images/calendar_icon.gif" alt="" height="15" width="19"/>
                        <asp:RequiredFieldValidator ID="rfvFechaInicio" runat="server" ControlToValidate="txtFechaInicio" ValidationGroup="grpConsulta">*</asp:RequiredFieldValidator>
                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" PopupButtonID="btnCal1"  TargetControlID="txtFechaInicio" Format="dd/MM/yyyy" OnClientDateSelectionChanged="checkDate"></cc1:CalendarExtender>
                    </td>
                    <td style="text-align: right; width: 242px;">
                        <label class="label003">Al:</label>
                        <asp:TextBox ID="txtFechaFin" runat="server" Width="100px" />        
                        <img id="btnCal2" src="images/calendar_icon.gif" alt="" height="15"/>        
                        <asp:RequiredFieldValidator ID="rfvFechaFin" runat="server" ControlToValidate="txtFechaFin" ValidationGroup="grpConsulta">*</asp:RequiredFieldValidator>&nbsp;
                        <cc1:CalendarExtender ID="CalendarExtender2" runat="server" PopupButtonID="btnCal2"  TargetControlID="txtFechaFin"    Format="dd/MM/yyyy" OnClientDateSelectionChanged="checkDate"></cc1:CalendarExtender>

                    </td>
                </tr>
                <tr>
                   <td>
                         Concepto:
                        <asp:DropDownList ID="ddlConceptos" runat="server" Width="150px" AppendDataBoundItems="True" CssClass="estilo1">
                            <asp:ListItem Value=" ">Todos</asp:ListItem>
                        </asp:DropDownList>
                    </td>
                    <td style="text-align: right; width: 242px;">
                            <asp:Button ID="Button1" runat="server" Text="Limpiar" CssClass="boton001" />
                            <asp:Button ID="btnConsultar" runat="server" Text="Consultar" OnClick="btnEnviar_Click" ValidationGroup="grpConsulta" CssClass="boton001" />
                    </td>
                </tr>
                <tr>
                     <td colspan="2" style="height: 84px">
                        <asp:ValidationSummary ID="vsConsulta" runat="server" HeaderText="(*) Datos Obligatorios" ValidationGroup="grpConsulta" />                        
                         <br />
                         <asp:CompareValidator ID="cpvFechaInicio" runat="server" ControlToValidate="txtFechaInicio" CssClass="izq_alig" ErrorMessage='La fecha de inicio no tiene un formato válido("DD/MM/AAAA")'  Operator="DataTypeCheck" Type="Date" ValidationGroup="grpConsulta"></asp:CompareValidator>                         
                         <br />
                         <asp:CompareValidator ID="cpvFechafin1" runat="server" ControlToValidate="txtFechaFin" CssClass="izq_alig" ErrorMessage='La fecha de fin no tiene un formato válido("DD/MM/AAAA")' Operator="DataTypeCheck" Type="Date" ValidationGroup="grpConsulta"></asp:CompareValidator>
                         <br />
                         <asp:CompareValidator ID="CompareValidator1" runat="server" ControlToCompare="txtFechaInicio" ControlToValidate="txtFechaFin" CssClass="izq_alig" ErrorMessage="La fecha final (Al) debe ser mayor o igual  a la fecha inicial (De)" Operator="GreaterThanEqual" Type="Date" ValidationGroup="grpConsulta"></asp:CompareValidator>
                         <br />
                     </td>

                </tr>
            </table>          
           
        </div> 
        <div class="sub_footer">
             <hr class="linea2" />
        </div>
        <asp:Label ID="lbMensaje" runat="server"></asp:Label><br />
        <asp:GridView ID="gvVacaciones" runat="server" Width="550px" GridLines="None" CellPadding="4" ForeColor="#333333">
            <RowStyle HorizontalAlign="Center" VerticalAlign="Middle" BackColor="#F7F6F3" ForeColor="#333333" />
            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" BackColor="White" BorderColor="Transparent" Font-Bold="True" ForeColor="Black" />
            <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
            <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
            <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
            <EditRowStyle BackColor="#999999" />
            <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
        </asp:GridView>
        <br />
        <br />
        <br />
        <br />
        <br />
        <br />
        <br />
        <br />
        <div id="sub_footer">
            <asp:LinkButton ID="btnImprimir" runat="server" CssClass="btnImprimir" Height="20px" Visible="False">Imprimir</asp:LinkButton>
            <br />
            <br />
            <hr class="linea2" />
            <br />
            <br />
        </div>
     </div>
           
    </form>
</body>
</html>
