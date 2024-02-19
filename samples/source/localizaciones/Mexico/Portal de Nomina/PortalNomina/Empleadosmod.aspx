<%@ page language="VB" autoeventwireup="false" inherits="Empleadosmod, App_Web_x0mxaknu" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Modificar Datos Personales</title>
    <link href="estilo.css" type="text/css" rel="Stylesheet" />
    <style type="text/css" >
        body{ background: none;}
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div id="sub_main">
        <div class="Titulo">
            <label>Modificar</label>
            <br />
            <hr class="linea2" id="linea1"/>
        </div>
        <br />
        <div id="cintilla1" class="cintilla">
            &nbsp;Redacte su Solicitud
        </div>
        <br />
        <table id="mod" >
        <tr>
            <td valign="top" >
                <label class="label1">Cambiar :</label>
            </td>
            <td valign="top" style="width: 390px" >  <asp:TextBox ID="txtBody" runat="server" Rows="10" TextMode="MultiLine" Columns="50" Width="390px" CssClass="combo"></asp:TextBox><br />
                <asp:RequiredFieldValidator ID="rfvTexto" runat="server" ControlToValidate="txtBody"  CssClass=".estilo1" ErrorMessage="Introduzca la información que desea modificar"></asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            <td colspan="2" style="height: 38px; text-align: right">
                 <asp:LinkButton ID="btnEnviar" runat="server" CssClass="btnEnviar" Width="40px" Font-Overline="False">Enviar</asp:LinkButton>
            </td>
        
        </tr>
       
        </table>
        <br />
         <div class="sub_footer" style="">
                               <br />
                <hr class="linea2" id="linea2"/>
         </div>
     <asp:Label ID="lbExcepcion" runat="server"></asp:Label><br />
        <br />
     
     </div>
    </form>
</body>
</html>
