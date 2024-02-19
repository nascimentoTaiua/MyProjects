<%@ page language="VB" autoeventwireup="false" inherits="Empleados, App_Web_x0mxaknu" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Datos Personales</title>
    <link href="estilo.css" type="text/css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div id="sub_main">
            <div class="Titulo">
             <label>Consultar</label>
             <hr class="linea2" />
            </div>
            <asp:Label ID="lbExcepcion" runat="server"></asp:Label><br />
            <div id="carpetas">
                <asp:PlaceHolder ID="phCarpetas" runat="server"></asp:PlaceHolder>
            </div>
            <br />
            <div id="datos_emp">
                <asp:PlaceHolder ID="phDatosPersonales" runat="server"></asp:PlaceHolder>
            </div> 
            <br/>
            <br />
            <div id="sub_footer">
                <hr class="linea2" />
                <br />
                <br />
            </div>           
        </div>
    </form>
</body>
</html>
