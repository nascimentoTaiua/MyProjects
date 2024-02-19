<%@ page language="VB" autoeventwireup="false" inherits="FrmNoticias, App_Web_x0mxaknu" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>Noticias</title>
    <link href="ESTILO.CSS" type="text/css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div id="form_news">
            <h2>&Uacute;ltimas Noticias</h2>
            <br />
            <asp:Label ID="lbMsgEx" runat="server"></asp:Label>
            <asp:PlaceHolder ID="phNoticias" runat="server"></asp:PlaceHolder>
        </div>
    </form>
</body>
</html>

