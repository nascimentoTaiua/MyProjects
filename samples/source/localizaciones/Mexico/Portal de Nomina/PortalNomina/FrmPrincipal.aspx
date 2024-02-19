<%@ page language="VB" autoeventwireup="false" inherits="FrmPrincipal, App_Web_fvutkeaf" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Principal</title>
    <link href="estilo.css" type="text/css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
    <div id="sub_main">
        <div class="Titulo">
            <label>N&oacute;mina Online</label>
            <br />
            <hr class="linea2" />
         </div>
        <br />
        <asp:PlaceHolder ID="phContenido" runat="server"></asp:PlaceHolder>
        
    </div>
    </form>
</body>
</html>
