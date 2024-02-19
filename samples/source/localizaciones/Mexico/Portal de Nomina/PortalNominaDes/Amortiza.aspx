<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Amortiza.aspx.vb" Inherits="Amortiza" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="asp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Amortizaciones</title>
    <link href="estilo.css" type="text/css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <div style=" width:500px;">
           <asp:Label ID="Lb_amor_tiz" runat="server" Font-Names="Arial" Font-Size="8pt" Text="Movimientos del  préstamo"
            Width="370px"></asp:Label>&nbsp;
        <asp:LinkButton ID="BtnCerrar" runat="server" target="_parent" Visible="False" >Cerrar</asp:LinkButton>&nbsp;<br />
        </div>
         
        <asp:Label ID="lbExcepcion" runat="server"></asp:Label><br />
                  
        <asp:GridView ID="gv_amor_tiz" runat="server" Width="440px"  Font-Names="Arial" Font-Size="X-Small" RowStyle-HorizontalAlign="Center" Height="72px" GridLines="None">
            <HeaderStyle HorizontalAlign="Center" />
            <RowStyle HorizontalAlign="Center" Wrap="True" />
        </asp:GridView>
        <br />
        <br />
        
           
        <asp:LinkButton ID="btnImpAmor" runat="server" CssClass="btnImprimir" Width="60px">Imprimir</asp:LinkButton><br />
        <br />
    </div>
    </form>
</body>
</html>
