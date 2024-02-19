<%@ Page Language="VB" AutoEventWireup="false" CodeFile="FrmEdoCuentaVac.aspx.vb" Inherits="FrmEdoCuentaVac" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Vacaciones: Estado de Cuenta</title>
    <link href="estilo.css" type="text/css" rel="stylesheet" />
    </head>
<body>
    <form id="form1" runat="server">
    <div id="sub_main">        
        <div class="Titulo">
            <label>Estado de Cuenta Vacaciones</label>
            <br />
          
            <hr class="linea2" />
               <div id="Div1" class="cintilla">
                &nbsp;
        </div>
        </div>

        <br />
        
        <div id="sub_footer" >
        
            <asp:LinkButton ID="btnImprimir" runat="server" CssClass="btnImprimir" Width="106px">Imprimir</asp:LinkButton>
            
            <label style="text-align: right">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Numero de Elementos Mostrados </label>
            <asp:DropDownList ID="DdlElementos" runat="server" AutoPostBack="True" >
            </asp:DropDownList>
            <br />

         <br />
        <br />
        </div> 
         <div id="Div2" class="cintilla">
                &nbsp;
        </div>
        <asp:Label ID="lbExcepcion" runat="server"></asp:Label><br />
       
        &nbsp;<br />
        
        <asp:GridView ID="gvVacaciones" runat="server" GridLines="None" UseAccessibleHeader="False" Width="550px" AllowPaging="True" CellPadding="4" ForeColor="Black" >
            <RowStyle HorizontalAlign="Center" VerticalAlign="Middle" BackColor="#F7F6F3" ForeColor="#333333" />
            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Font-Bold="True" BackColor="Transparent" ForeColor="Black" />
            <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
            <PagerStyle BackColor="Transparent" ForeColor="Black" HorizontalAlign="Center" />
            <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
            <EditRowStyle BackColor="#999999" />
            <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
        </asp:GridView>
         &nbsp;<br />
      
        </div>
        
    </form>
</body>
</html>
