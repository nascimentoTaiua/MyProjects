<%@ Page Language="VB" AutoEventWireup="false" CodeFile="FrmSolDocs.aspx.vb" Inherits="FrmSolDocumentos" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">


<html xmlns="http://www.w3.org/1999/xhtml" >

<head id="Head5" runat="server">
    <title>Untitled Page</title>
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
    function toggleDiv(flagit,htmltext) {
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

function overdiv_onclick() {

}
    </script>
</head>
<body>
    <form id="FmSolPres" runat="server">
    <div id="sub_main">
    <div class="Titulo" >
        <label>Solicitud de Documentos</label>
        <br />
        <hr class="linea2" />
    </div>
    <br/>
    <div class="cintilla">
        &nbsp;Seleccione su documento</div>
    <br/>
    <div id="DivDatos">
        <table id="up2">
            <tr>
                <td style="width: 62px; height: 24px"> Documento :</td>
                <td style="width: 336px; height: 24px">
                    <asp:DropDownList ID="LisDocums" runat="server" Font-Names="Arial" Font-Size="8pt"  ForeColor="Black" CssClass="espacioetiqueta" Width="200px" >
                    </asp:DropDownList>
                </td>
                <td style="height: 24px">
                      <asp:LinkButton ID="LinkButton1" runat="server" CssClass="btnEnviar" Width="40px">Enviar</asp:LinkButton>
                </td>
            </tr>
            <tr>
                <td style="width: 62px">Interesado :</td>
                <td style="width: 336px">
                    <asp:TextBox ID="tx_int_ere" runat="server" Width="300px" CssClass="espacioetiqueta" TabIndex="2"></asp:TextBox>
                </td>
                <td>
                    <asp:RequiredFieldValidator ID="VldInteresado" runat="server" ControlToValidate="tx_int_ere" ErrorMessage="El interesado no puede estar vacio!" Text="obligatorio" ValidationGroup="VldIntGpo"></asp:RequiredFieldValidator>
                </td>
            </tr>
        </table>                 
    </div>
    <br/>
    <div class="cintilla" >
        &nbsp;Historial de las Solicitudes
    </div>
    <asp:Label ID="lbExcepcion" runat="server"></asp:Label>
    <br /> 
    <asp:GridView ID="lis_sol_doc" runat="server" Width="550px" GridLines="None" AllowPaging="True" PageSize="5" CellPadding="4" ForeColor="#333333">
        <Columns>
            <asp:TemplateField HeaderText="Select All">
                <HeaderTemplate>
                    <center>
                        <asp:CheckBox ID="chkAll" runat="server" onclick="javascript:SelectAllCheckboxes(this);" />
                    </center>
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
        </asp:GridView>
        &nbsp;<br />
        <br />
        <br />
        <br />
        <br />
        <br />
        <br />
        <br />
        <br />
        <br />
        <br />
        <br />
        <div id="sub_footer">
            <div style=" height:20px;">
             <asp:LinkButton ID="btnEliSolDoc" runat="server" CssClass="btnEliminar" Width="60px" Visible="False">Eliminar</asp:LinkButton>
            </div> 
             <hr class="linea2"  />
             <br />
             <br />
        </div>
        <br />
      </div>
       
     </form>
    
</body>
</html>
