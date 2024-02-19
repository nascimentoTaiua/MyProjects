<%@ Page Language="VB" AutoEventWireup="false" CodeFile="ReciboNom.aspx.vb" Inherits="ReciboNom" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Recibo de Nomina</title>
    <link href="recibonom.css" type="text/css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div id="main">
            <div>
            <asp:PlaceHolder ID="phRecibo" runat="server"></asp:PlaceHolder>
            </div>
            <br />
            <br />
            <br />
            <div id="sub_footer">
                <div style=" height:20px;">
                 <asp:LinkButton ID="lnkImprimir" runat="server" CssClass="btnImprimir" OnClientClick="window.print();" Width="60px">Imprimir</asp:LinkButton>
                &nbsp;
                 <asp:LinkButton ID="lnkBack" runat="server" CssClass="btnRegresar" Width="60px">Regresar</asp:LinkButton>
                </div>
                 <br />
                 <hr class="linea2"/>
                <br />
                <br />
            </div>
            <br />
       </div>     
    </form>
</body>
</html>
