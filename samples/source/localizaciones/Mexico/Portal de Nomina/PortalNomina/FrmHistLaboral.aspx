<%@ page language="VB" autoeventwireup="false" inherits="FrmHistLaboral, App_Web_fvutkeaf" culture="es-ES" uiculture="es-ES" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="asp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Historial Laboral</title>
    <link href="estilo.css" type="text/css" rel="stylesheet" />
    <script language="javascript" type="text/javascript" >
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
        
       function checkAll(field)
        {
        for (i = 0; i < field.Lenght; i++)
	        field[i].checked = true ;
        }

        function uncheckAll(field)
        {
        for (i = 0; i < field.length; i++)
	        field[i].checked = false ;
        }
    </script>
</head>
<body>
    <form id="form1" runat="server" >
    <div id="sub_main">
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
        <div class="Titulo">
            <label>Historial Laboral</label><br />
            <hr class="linea2"  />
        </div>
        <br />
        <div id="cintilla1" class="cintilla" >
            &nbsp;Seleccione los Datos para la Búsqueda
        </div>
        <div id="DivDatos">
            <table id="up2">
                <tr>
                    <td class="td1">
                        Del:
                        <asp:TextBox ID="txtFechaInicio" runat="server" Width="100px" CssClass="combo" />
                        <img id="btnCal1" src="images/calendar_icon.gif" alt="" height="17" class="imgcal"/>&nbsp;
                        <br />
                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" PopupButtonID="btnCal1"  TargetControlID="txtFechaInicio" Format="dd/MM/yyyy" OnClientDateSelectionChanged="checkDate"></cc1:CalendarExtender>

                    </td>
                    <td class="td1">
                         Al:
                        <asp:TextBox ID="txtFechaFin" runat="server" Width="100px" CssClass="combo" />                
                        <img id="btnCal2" src="images/calendar_icon.gif" alt="" height="17" class="imgcal"/>
                        <br />
                         <cc1:CalendarExtender ID="CalendarExtender2" runat="server" PopupButtonID="btnCal2"  TargetControlID="txtFechaFin"    Format="dd/MM/yyyy" OnClientDateSelectionChanged="checkDate"></cc1:CalendarExtender>
                    </td>
                    <td class="td2" style=" text-align:right;">
                        <asp:Button ID="Button1" runat="server" Text="Limpiar" CssClass="boton001" />
                        <asp:Button ID="btnConsultar" runat="server" Text="Consultar" ValidationGroup="grpConsulta" CssClass="boton001" />

                    </td>
                </tr>
                <tr>
                    <td> 
                        <asp:RequiredFieldValidator ID="rfvFechaInicio" runat="server" ControlToValidate="txtFechaInicio" ErrorMessage="Obligatorio" ValidationGroup="grpConsulta">Obligatorio</asp:RequiredFieldValidator>
                    </td>
                    <td><asp:RequiredFieldValidator ID="rfvFechaFin" runat="server" ControlToValidate="txtFechaFin"  ErrorMessage="Debe elegir fecha de fin" ValidationGroup="grpConsulta">Obligatorio</asp:RequiredFieldValidator></td>
                    <td></td>
                </tr>
                <tr>
                    <td colspan="3" >
                        <fieldset class="fieldset" id="combo" >
                            <legend class="legenda">
                                <asp:CheckBox ID="cbxTodos" runat="server" Text="  Todos"  AutoPostBack="True" CssClass="cbxAll"/>
                            </legend>
                            <br />
                             <asp:CheckBox ID="cbxAltas" runat="server" Text=" Altas" CssClass="cbxAll" Width="115px" />
                             <asp:CheckBox ID="cbxMod" runat="server" Text=" Modificación" CssClass="cbxAll" Width="115px" />
                             <asp:CheckBox ID="cbxLocalPago" runat="server" Text=" Localidad de Pago" CssClass="cbxAll" Width="115px" />
                             <asp:CheckBox ID="cbxFunciones" runat="server" Text=" Funciones" CssClass="cbxAll" Width="115px"  />
                             <asp:CheckBox ID="cbxBajas" runat="server" Text=" Bajas" CssClass="cbxAll" Width="115px" />
                             <asp:CheckBox ID="cbxDepartamentos" runat="server" Text=" Departamentos" CssClass="cbxAll" Width="115px"  />
                             <asp:CheckBox ID="cbxCenCos" runat="server" Text=" Centros de costo" CssClass="cbxAll" Width="115px"  />
                             <asp:CheckBox ID="cbxCargos" runat="server" Text=" Cargos" CssClass="cbxAll" Width="115px" />
                            <br />
                            <br />
                        </fieldset>
                    </td>
                </tr>
                <tr>
                    <td colspan="3">
                        <asp:CompareValidator ID="cvFechaInicio1" runat="server" ErrorMessage='La fecha de inicio no tiene un formato válido("DD/MM/AAAA"' ControlToValidate="txtFechaInicio" Operator="DataTypeCheck" Type="Date" ValidationGroup="grpConsulta" CssClass="izq_alig"></asp:CompareValidator>
                        <asp:CompareValidator ID="cvFechaFin1" runat="server" ErrorMessage='La fecha de Fin(Al) no tiene un formato válido("DD/MM/AAAA")' ControlToValidate="txtFechaFin" Operator="DataTypeCheck" Type="Date" ValidationGroup="grpConsulta" CssClass="izq_alig"></asp:CompareValidator>
                        <asp:CompareValidator ID="cvFechaFin2" runat="server" ControlToCompare="txtFechaInicio"  ControlToValidate="txtFechaFin" ErrorMessage="La fecha Final(Al) debe ser mayor o igual a la Fecha de Inicio (De)" Operator="GreaterThanEqual" Type="Date" ValidationGroup="grpConsulta" CssClass="izq_alig"></asp:CompareValidator><br />
                    </td>
                </tr>
            </table>
        </div>
        <div id="cbxAll">
            <hr class="linea2" />  
       </div>
       <asp:Label ID="lbMsg" runat="server"></asp:Label><br />
       <asp:GridView ID="gvHisLab" runat="server" Width="550px" GridLines="None" CellPadding="4" ForeColor="Black">
            <RowStyle HorizontalAlign="Center" VerticalAlign="Middle" BackColor="#F7F6F3" ForeColor="#333333" />
            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" BackColor="Transparent" Font-Bold="True" ForeColor="Black" />
           <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
           <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
           <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
           <EditRowStyle BackColor="#999999" />
           <AlternatingRowStyle BackColor="White" ForeColor="Black" />
        </asp:GridView>
        <br />
        <br />
        <br />
        <div id="sub_footer">
             <div style=" height: 20px;">
               <asp:LinkButton ID="btnImprimir" runat="server" CssClass="btnImprimir" Width="60px" Visible="false" >Imprimir</asp:LinkButton><br />
             </div>
              <hr class="linea2" />
            <br />
        </div>
       
    </div>
        
    </form>
</body>
</html>
