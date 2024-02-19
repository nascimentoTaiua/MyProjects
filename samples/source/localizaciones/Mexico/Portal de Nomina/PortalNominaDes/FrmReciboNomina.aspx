<%@ Page Language="VB" AutoEventWireup="false" CodeFile="FrmReciboNomina.aspx.vb" Inherits="FrmReciboNomina" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Recibos de N&oacute;mina</title>
    <link href="estilo.css" type="text/css" rel="stylesheet" />
    <script language="javascript" type="text/javascript" >
        function imprime(id)
            {                        
                var w=window.open("ReciboNom.aspx","","")
                w.document.body.innerHTML=document.getElementById(id).innerHTML
                w.print();
                w.close();
            }
        
   
    </script>
</head>
<body>
    <form id="form1" runat="server">
     <div id="Recibo">
        <div id="sub_main" style=" height: 150px;">
            <br />
            <div class="Titulo">
                <label>Recibos de N&oacute;mina    </label>        
                <hr class="linea2" />
            </div>
            <asp:Label ID="lbExcepcion" runat="server"></asp:Label><br />
            <br />
            <div id="DivDatos" >
                <label id="label1" class="label004">Periodo </label>
                <asp:DropDownList ID="ddlPeriodos" runat="server" Width="200px" AppendDataBoundItems="True">
                    <asp:ListItem Value=" ">Seleccione</asp:ListItem>
                </asp:DropDownList>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="ddlPeriodos" ErrorMessage="Debe Seleccionar Fecha de Recibo" ValidationGroup="gpFechas">*</asp:RequiredFieldValidator>
                <asp:Button ID="btnBuscar" runat="server" Text="Buscar" ValidationGroup="gpFechas" CssClass="boton001" /><br />
                <br />
                <asp:ValidationSummary ID="vsFechas" runat="server" DisplayMode="List" ValidationGroup="gpFechas" />            
                <br />
                       
            </div>
            <div id="sub_footer">
            <hr class="linea2"/>     
            </div>
            <br />
            <div class="estilo02" id="imp">
               <asp:LinkButton ID="btImprimir" runat="server" CssClass="btnImprimir" Height="24px" OnClientClick="imprime('rec_nom')" ValidationGroup="gpFechas" Visible="False">Imprimir</asp:LinkButton>&nbsp;
            </div>
            
           </div>  
               <br />
               <br />
               <br />
               <br />     
           <!--<div id="rec_nom">
                <asp:PlaceHolder ID="phRecibo" runat="server"></asp:PlaceHolder>   
                <br /> 
           </div>   -->
                  
        </div>
          
        </form>
</body>
</html>
