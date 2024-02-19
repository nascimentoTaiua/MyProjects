<%@ Page Language="VB" AutoEventWireup="false" CodeFile="FrmEdoCtaNomina.aspx.vb" Inherits="_Default" Culture="es-ES" UICulture="es-Es" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="asp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
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
    </script>
</head>
<body>
    <form id="form1" runat="server">
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
        <div id="submain">
        <div class="Titulo"> 
            <label>Estado de Cuenta</label>
            <hr class="linea2" />
        </div>
        
        <br />
        <div id="cintilla1" class="cintilla" >
            &nbsp;Seleccione los Datos para la Búsqueda</div>
        <br />
        <div id="DivDatos">
            <div id="fechas">
                <table id="up1">
                    <tr>
                        <td>
                             <label> Del:</label>&nbsp;
                            <asp:TextBox ID="txtFechaInicio" runat="server" Width="80px" CssClass="combo" />
                            <img id="btnCal1" src="images/calendar_icon.gif" alt="" height="17" class="imgcal"/>                           
                            <br />
                             <cc1:CalendarExtender ID="CalendarExtender1" runat="server" PopupButtonID="btnCal1"  TargetControlID="txtFechaInicio" Format="dd/MM/yyyy" OnClientDateSelectionChanged="checkDate"></cc1:CalendarExtender>
            
                        </td>
                        <td>
                             Al:&nbsp;&nbsp;<asp:TextBox ID="txtFechaFin" runat="server" Width="80px" CssClass="combo" />        
                            <img id="btnCal2" src="images/calendar_icon.gif" alt="" height="17" class="imgcal"/>
                            <br />
                            <cc1:CalendarExtender ID="CalendarExtender2" runat="server" PopupButtonID="btnCal2"  TargetControlID="txtFechaFin"    Format="dd/MM/yyyy" OnClientDateSelectionChanged="checkDate"></cc1:CalendarExtender>


                        </td>
                        <td style="text-align: right">
                             y/o Importe ($)
                             <asp:TextBox ID="txtimporte" runat="server" Width="100px" CssClass="estilo01"></asp:TextBox>

                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:RequiredFieldValidator ID="rfvFechaInicio" runat="server" ControlToValidate="txtFechaInicio" ValidationGroup="grpConsulta">Obligatorio</asp:RequiredFieldValidator>&nbsp;&nbsp;
                            </td>
                        <td>
                               <asp:RequiredFieldValidator ID="rfvFechaFin" runat="server" ControlToValidate="txtFechaFin" ValidationGroup="grpConsulta">Obligatorio</asp:RequiredFieldValidator>&nbsp;&nbsp;
                        </td>
                        <td>
                            &nbsp;<asp:RegularExpressionValidator ID="revImporte" runat="server" ControlToValidate="txtimporte"  ErrorMessage="El importe debe ser un valor numérico" ValidationExpression="/^([0-9])*$/"  ValidationGroup="grpConsulta"></asp:RegularExpressionValidator></td>
                    </tr>                    
                    <tr>
                        <td colspan="2">
                            Concepto:
                            <asp:DropDownList ID="ddlConceptos" runat="server" Width="200px" AppendDataBoundItems="True" CssClass="combo">
                                <asp:ListItem Value=" ">Todos</asp:ListItem>
                            </asp:DropDownList>
                        </td>
                        <td style="text-align: right">
                             <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" CssClass="boton001" />
                         <asp:Button ID="btnConsultar" runat="server" Text="Consultar" ValidationGroup="grpConsulta" CssClass="boton001" />

                        </td>
                    </tr>  
                    <tr>
                        <td colspan="3" style="height: 48px">
                             <asp:CompareValidator ID="cvFechaInicio" runat="server" ControlToValidate="txtFechaInicio"   ErrorMessage='La fecha de inicio no tiene un formato válido("DD/MM/AAAA")' Operator="DataTypeCheck" Type="Date" ValidationGroup="grpConsulta" SetFocusOnError="True"></asp:CompareValidator><br />
                             <asp:CompareValidator ID="cvFechaFin" runat="server" ControlToValidate="txtFechaFin" ErrorMessage='La fecha Final no tiene un formato válido ("DD/MM/AAAA")' Operator="DataTypeCheck" Type="Date" ValidationGroup="grpConsulta" SetFocusOnError="True"></asp:CompareValidator><br />
                             <asp:CompareValidator ID="cpvFechaFin" runat="server" ControlToCompare="txtFechaInicio" ControlToValidate="txtFechaFin" ErrorMessage="La Fecha (Al)  debe ser mayor a la Fecha(De)"  Operator="GreaterThanEqual" SetFocusOnError="True" Type="Date" ValidationGroup="grpConsulta"></asp:CompareValidator>&nbsp;
                        </td>
                    </tr>               
            </table>
            </div>
        </div> 
        <div class="sub_footer">
             <hr class="linea2" />
        </div>
        &nbsp;
        <asp:Label ID="lbMensaje" runat="server" Text=" "></asp:Label>
        <asp:Label ID="lbExcepcion" runat="server"></asp:Label>
        <div id="gr_datos" >
            <asp:GridView ID="gvEdoCta" runat="server" Width="560px" GridLines="None" CellPadding="4" ForeColor="#333333">
                <RowStyle HorizontalAlign="Center" VerticalAlign="Middle" BackColor="#F7F6F3" ForeColor="#333333" />
                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" BackColor="Transparent" Font-Bold="True" ForeColor="Black" />
                <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
                <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                <EditRowStyle BackColor="#999999" />
                <AlternatingRowStyle BackColor="White" ForeColor="Black" />
            </asp:GridView>
            <br />
        </div>
        <div id="imp" class="sub_footer" style=" height: 100px;">
            <div style=" height: 40px;">
            <br />
            <br />
            <asp:LinkButton ID="btnImprimir" runat="server" CssClass="btnImprimir" Visible="False" Width="60px">Imprimir</asp:LinkButton>&nbsp;
            <br />
            <br />
            </div>
            <hr class="linea2" />
        </div>
        <br />
     
     </div>
    </form>
</body>
</html>
