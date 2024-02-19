<%@ Page Language="VB" AutoEventWireup="false" CodeFile="FrmDiasFestivos.aspx.vb" Inherits="FrmDiasFestivos" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>D&iacute;as Festivos</title>
    <link href="estilo.css" type="text/css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
    <div id="sub_main">
        <div class="Titulo">
            <label>D&iacute;as Festivos</label><br />
            <hr class="linea2" />
        </div>
        <asp:Label ID="lbExcepcion" runat="server"></asp:Label>
        <br />
        <center>
            <asp:GridView ID="gvDiasFestivos" runat="server" Width="550px" GridLines="None">
                <RowStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
            </asp:GridView>
        </center>
        <br />
        <br />
        <div style=" width:550px;">
            <hr class="linea2" />
            <br />
            <br />
        </div>
        
    </div>
    </form>
</body>
</html>
