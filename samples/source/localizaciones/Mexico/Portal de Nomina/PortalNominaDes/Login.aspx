<%@ Page Language="VB" AutoEventWireup="true" CodeFile="Login.aspx.vb" Inherits="_Login" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head2" runat="server">
    <title>Portal de Nomina</title>
    <link href="estilo.css" type="text/css" rel="stylesheet" />
    <script language="javascript" type="text/javascript" >    
        function recargar()
        {
            if (top.location != self.location)
            {
                top.location = self.location;
            }
        }        
    </script>
</head>
<body onload="recargar();" class="bodystyle" >
    <form id="form1" runat="server">
          <div id="index">
        <div id="container">
             <div id="header">
                <div id="sub_header">
                    <div id="logo">
                        <img alt="logo_clientes" src="images/logo_cliente.png" />
                    </div>
                   <div id="header_sup_der">
                        <div id="superior">
                            <img src="images/barra_sup_header.png" alt="img" class="esquina_inf_der" />
                        </div>                                                                                                     
                    </div> 
                </div>
                 <div id="datos_empresa" style="width: 794px">
                    <img src="images/nombre_empresa.png" alt="" />
                 </div>   
                 <div id="login">
                    <label class="label1">N&oacute;mina OnLine<asp:Label ID="Label2" runat="server" CssClass="espaciocierre"></asp:Label></label>
                 </div>   
                 <div id="datos_acceso" class="datos_acceso">        
                        <div class="menu_opcion">
                            
                        </div>    
                        <div id="bienvenidos" class="acceso">
                            Bienvenido a Nómina Online</div>                                    
                 </div>                                    
            </div>             
            <div id="content">
                <div id="sidebar">                                
                </div>
                <div id="main" style=" height: 400px; text-align:center;">
                    <div id="logindiv">
                    <center>
                     
                      <asp:Login ID="Login1" runat="server"   OnAuthenticate="Login1_Autenticate" CssClass="Login1" >
                        <LoginButtonStyle CssClass="button" />
                        <LayoutTemplate>
                            <table>
                                <tr>
                                    <td >
                                        <table class="Login1">
                                            <tr>
                                                <td>
                                                    <br />
                                                    <br />
                                                    <br />
                                                    <br />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="text-align: left; height: 40px;">
                                                    <asp:Label ID="UserNameLabel" runat="server" AssociatedControlID="UserName" CssClass="negrita" >Matrícula:</asp:Label>
                                                    <br />
                                                    <asp:TextBox ID="UserName" runat="server" Width="180px"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="UserNameRequired" runat="server" ControlToValidate="UserName" ErrorMessage="User Name is required." ToolTip="User Name is required." ValidationGroup="Login1">*</asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="text-align: left; height: 40px;">
                                                    <asp:Label ID="PasswordLabel" runat="server" AssociatedControlID="Password" CssClass="negrita" >Contraseña</asp:Label><br />
                                                    <asp:TextBox ID="Password" runat="server" TextMode="Password" OnTextChanged="Password_TextChanged" Width="180px"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="PasswordRequired" runat="server" ControlToValidate="Password" ErrorMessage="Password is required." ToolTip="Password is required." ValidationGroup="Login1">*</asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>                                        
                                                <td style="text-align: left; height: 27px;">
                                                    <asp:Label ID="FilialLabel" runat="server" AssociatedControlID="UserFilial" CssClass="negrita" >Sucursal </asp:Label><br />
                                                    <asp:DropDownList ID="UserFilial" runat="server" Width="185px" AppendDataBoundItems="True" DataSourceID="XmlDataSource1" DataTextField="nombre" DataValueField="id" OnSelectedIndexChanged="UserFilial_SelectedIndexChanged">
                                                        <asp:ListItem Value=" ">Seleccione</asp:ListItem>
                                                    </asp:DropDownList>
                                                    <asp:RequiredFieldValidator ID="UserFilialRequired" runat="server" ErrorMessage="Filial es Requerida" ControlToValidate="UserFilial" ToolTip="Filial is required." ValidationGroup="Login1">*</asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <%--<td colspan="2" style="height: 25px" align="left">
                                                    <br />
                                                    <asp:CheckBox ID="RememberMe" runat="server" Text="&nbsp;&nbsp; Recordar la proxima vez" Width="199px"  />
                                                    <br />
                                                </td>--%>
                                            </tr>
                                            <tr>
                                                <td align="center" colspan="2" style="color: red">
                                                    <asp:Literal ID="FailureText" runat="server" EnableViewState="False"></asp:Literal>
                                                    <br />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="left" colspan="2" style="height: 40px; text-align: left;">
                                                    <asp:Button ID="LoginButton" runat="server" CommandName="Login" Text="Entrar" CssClass="boton002" ValidationGroup="Login1" /><br />
                                                    <br />
                                                    <asp:LinkButton ID="LinkButton1" runat="server" OnClick="LinkButton1_Click" CssClass="link002" >Cambiar Contraseña </asp:LinkButton>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </LayoutTemplate>
                    </asp:Login>    
                    <asp:XmlDataSource ID="XmlDataSource1" runat="server"></asp:XmlDataSource>
                    <asp:Label ID="lbExcepcion" runat="server"></asp:Label>   
                    </center> 
                  </div>                    
                </div>
                <div id="sidebar_der" style=" background-image: none;">                   
                        
                </div>
            </div>
            <div id="footer" >
            
            </div>
        </div>
    </div>
    </form>
</body>
</html>
 
