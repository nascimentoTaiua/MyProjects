<%@ Page Language="VB" AutoEventWireup="false" CodeFile="EdoCtaPrestamos.aspx.vb" Inherits="EdoCtaPrestamos" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="asp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
    <head id="Head1"  runat="server">
        <title>Estado de Cuenta de Prestamos</title>
        <link href="estilo.css" type="text/css" rel="stylesheet" />
        
        <script type="text/javascript" language="JavaScript">
       
          /* function toggleDiv(flagit,htmltext) {
            if (flagit=="1"){
	            if (document.layers) {
		            document.layers['overdiv'].visibility = "show"
		            document.layers['overdiv'].innerHTML = htmltext;
	            }
	            else if (document.all) {
		            document.all['overdiv'].style.visibility = "visible"
		            document.all['overdiv'].innerHTML = htmltext;
	            }
	            else if (document.getElementById) { 
		            document.getElementById('overdiv').style.visibility = "visible"					
		            document.getElementById('overdiv').innerHTML = htmltext;
	            }
           	
            	
	            }
            else
             if (flagit=="0"){
	            if (document.layers) document.layers['overdiv'].visibility = "hide"
	            else if (document.all) document.all['overdiv'].style.visibility = "hidden"
	            else if (document.getElementById) document.getElementById('overdiv').style.visibility = "hidden"							}
            }
           */
              // posiciona un popup al dar click en una celda del grid
    function toggleDiv(flagit,htmltext) {
    if (flagit=="1"){
	    if (document.layers) {
		    document.layers['overdiv'].visibility = "show"
		     document.getElementById('overdiv').innerHTML = "<a href='#' onclick =\"toggleDiv(0,'');\">Cerrar</a><br/><br/>"				
		     document.getElementById('overdiv').innerHTML += htmltext;

	    }
	    else if (document.all) {
		    document.all['overdiv'].style.visibility = "visible"
		     document.getElementById('overdiv').innerHTML = "<a href='#' class='link' onclick =\"toggleDiv(0,'');\">Cerrar</a><br/><br/>"				
		     document.getElementById('overdiv').innerHTML += htmltext;

	    }
	    else if (document.getElementById) { 
		    document.getElementById('overdiv').style.visibility = "visible"	
		    document.getElementById('overdiv').innerHTML = "<a href='#' class='link' onclick =\"toggleDiv(0,'');\">Cerrar</a> <br/><br/>"				
		    document.getElementById('overdiv').innerHTML += htmltext;
	    }
    	
    	
	    }
    else
     if (flagit=="0"){
	    if (document.layers) document.layers['overdiv'].visibility = "hide"
	    else if (document.all) document.all['overdiv'].style.visibility = "hidden"
	    else if (document.getElementById) document.getElementById('overdiv').style.visibility = "hidden"							}
    }
         </script>
    </head>

    <body>
         <form id="FrmEdoCtaPres" runat="server">
         <asp:ScriptManager id="ScriptManager1" runat="server">
         </asp:ScriptManager>
            <div id="overdiv"  class="overdivamor" style="left: 9%; top: 128px"  ></div>
            <div id="sub_main">
                <div class="Titulo">
                    Estado de Cuenta
                    <hr class="linea2" />
                </div>
                <br />
                <asp:Label ID="lbExcepcion" runat="server"></asp:Label><br />
                <asp:Label ID="lbMensaje" runat="server" Text=" "></asp:Label>
                <asp:GridView ID="gv_cta_pres" runat="server" Width="550px" GridLines="None" CellPadding="4" ForeColor="Black">
                    <RowStyle HorizontalAlign="Center" BackColor="#F7F6F3" ForeColor="#333333" />
                    <HeaderStyle HorizontalAlign="Center" BackColor="White" Font-Bold="True" ForeColor="Black" />
                    <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                    <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
                    <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                    <EditRowStyle BackColor="#999999" />
                    <AlternatingRowStyle BackColor="White" ForeColor="Black" />
                </asp:GridView>
                <br />
                <div id="separador">
                    <asp:LinkButton ID="btnImpPres" runat="server" CssClass="btnImprimir" Width="60px">Imprimir</asp:LinkButton><br />
                    <br />
                    <hr  class="linea2"/>
                </div>
                
             </div>             
           </form>
        </body>
</html>
