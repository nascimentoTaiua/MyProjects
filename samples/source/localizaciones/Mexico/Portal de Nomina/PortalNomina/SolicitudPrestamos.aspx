<%@ page language="VB" autoeventwireup="false" inherits="SolicitudPrestamos, App_Web_fvutkeaf" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Solicitud de pr&eacute;stamos</title>
    <link href="ESTILO.CSS" type="text/css" rel="stylesheet" />
    
    
    <script type="text/javascript" language="javascript">
        
        
        function SelectAllCheckboxes(spanChk){

            // Added as ASPX uses SPAN for checkbox
            var oItem = spanChk.children;
            var theBox=(spanChk.type=="checkbox")?spanChk:spanChk.children.item[0];
            xState=theBox.checked;

            elm=theBox.form.elements;
            for(i=0;i<elm.length;i++)
            if(elm[i].type=="checkbox" && elm[i].id!=theBox.id)
            {
            //elm[i].click();
            if(elm[i].checked!=xState)
            elm[i].click();
            //elm[i].checked=xState;
            }
        }
    </script>
    <script type="text/javascript" language="JavaScript">
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
<body id="bdy">
    <form id="FmSolPres" runat="server">
    <div id="overdiv"  class="overdiv" onclick="toggleDiv(0,'');" style="left: 17%; top: 183px" ></div>
    <div id="sub_main">
        <div class='Titulo'>
            <label>Solicitud</label><br />
            <hr class="linea2" />
        </div>
        <br/>
        <div id="cintilla1"   class="cintilla">
            Redacte su solicitud
        </div>
        <div id="DivDatos">
            <!--<div id="fechas">-->
                <table id="up2">
                    <tr>
                        <td style="text-align: left; height: 38px;">
                             Concepto
                            <asp:DropDownList ID="LisConPres" runat="server" CssClass="combo" Width="168px" TabIndex="1" AppendDataBoundItems="True">
                                <asp:ListItem Value=" ">Seleccione</asp:ListItem>
                                </asp:DropDownList>&nbsp; 
                                <br />
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="LisConPres"  ErrorMessage="*" ValidationGroup="VldImpGpo">Obligatorio</asp:RequiredFieldValidator>

                        </td>
                        <td style="text-align: left; padding-left: 35px; width: 50%; height: 38px;">
                              Importe($)<asp:TextBox ID="tx_imp_pres" runat="server" Width="120px" CssClass="espacioetiqueta" Font-Names="Arial" Font-Size="Small" TabIndex="2" MaxLength="11"></asp:TextBox>
                              <br />
                              <asp:RequiredFieldValidator ID="VldImporte" runat="server" ControlToValidate="tx_imp_pres" ErrorMessage="El importe debe ser mayor que cero!" Text="obligatorio" ValidationGroup="VldImpGpo"></asp:RequiredFieldValidator>                   
                            <asp:CompareValidator ID="cpvImporte" runat="server" ControlToValidate="tx_imp_pres"
                                ErrorMessage="Valor incorrecto" Operator="DataTypeCheck" Type="Double" ValidationGroup="VldImpGpo"></asp:CompareValidator></td>
                    </tr>
                    <tr>
                        <td colspan="2" style="height:20px; padding-left:400px;"> 
                            <asp:LinkButton ID="btnEnvSolPres2" runat="server" CssClass="btnEnviar" ValidationGroup="VldImpGpo" Width="40px">Enviar</asp:LinkButton>
                        </td>
                    </tr>
                </table>
            <!--</div>-->
        <asp:Label ID="lbExcepcion" runat="server"></asp:Label></div>
        <div id="cintilla2"   class="cintilla">
            Historial de Solicitudes&nbsp;
        </div>
        <br />
        
        <asp:GridView ID="lis_sol_pres" runat="server" Width="550px" GridLines="None" AllowPaging="True" PageSize="5" CssClass="estilo2" CellPadding="4" ForeColor="#333333">
            <Columns>
                <asp:TemplateField HeaderText="Select All">
                    <HeaderTemplate>
                        <asp:CheckBox ID="chkAll" runat="server" onclick="javascript:SelectAllCheckboxes(this);" />
                    </HeaderTemplate>
                    <ItemTemplate>
                        <asp:CheckBox ID="chkActive" runat="server" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <RowStyle HorizontalAlign="Center" BackColor="#F7F6F3" ForeColor="#333333" />
                <HeaderStyle HorizontalAlign="Center" BackColor="White" Font-Bold="True" ForeColor="Black" />
            <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
            <PagerStyle BackColor="White" ForeColor="Black" HorizontalAlign="Center" />
            <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
            <EditRowStyle BackColor="#999999" />
            <AlternatingRowStyle BackColor="White" ForeColor="Black" />
        </asp:GridView>      &nbsp;
        <br />
        <div class="estilo02" style=" text-align: left;">
            <div style=" height: 20px;">
                <asp:LinkButton ID="btnDel" runat="server" CssClass="btnEliminar" Width="60px" Visible="False">Eliminar</asp:LinkButton>

            </div>
            <hr class="linea2"/>
        </div>
        
        <br />
     </div> 
    </form>
    
</body>
</html>
