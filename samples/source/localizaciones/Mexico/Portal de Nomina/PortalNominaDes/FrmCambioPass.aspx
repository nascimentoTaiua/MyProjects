<%@ Page Language="VB" AutoEventWireup="false" CodeFile="FrmCambioPass.aspx.vb" Inherits="FrmCambioPass" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Cambio de Contraseña</title>
    <link href="estilo.css" type="text/css" rel="Stylesheet" />
</head>
<body class="bodystyle">
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
                 <div id="datos_empresa">
                    <asp:Label ID="lbempresa" runat="server"  Text="Nombre del Cliente S.A. de C.V." CssClass="Title"></asp:Label>                
                 </div>   
                 <div id="login">
                    <label class="label1">N&oacute;mina OnLine</label>
                 </div>   
                 <div id="datos_acceso" class="datos_acceso">        
                        <div class="menu_opcion">
                            USTED ESTA AQUI: 
                            <asp:Label ID="lbOpcion" runat="server" Text="CAMBIO DE CONTRASEÑA"></asp:Label></div>    
                        <div id="bienvenidos" class="acceso">
                            <label>Bienvenido&nbsp; a N&oacute;mina Online</label>                    
                        </div>                                    
                    </div>                                    
            </div>
             
            <div id="content">
                <div id="sidebar">            
                    
                </div>
                <div id="main" style=" height: 400px;">
                      <div id="centro" > 
                      <div class="Titulo" style="text-align: left">
                            Cambiar Contraseña
                            <br />
                            <hr  class="linea2"/>
                        </div>   
                          <br />
                          <br />
                        <div id="pass">  
                            <table id="pass_int"> 
                                    <tr>
                                        <td class="td1">
                                             Matr&iacute;cula
                                        </td>     
                                        <td class="td2">
                                        <asp:TextBox ID="txtMatricula" runat="server" Width="150px"></asp:TextBox><asp:RequiredFieldValidator ID="rfvMatricula" runat="server" ErrorMessage="Falta ingresar Matrícula" ControlToValidate="txtMatricula" ValidationGroup="Form1">*</asp:RequiredFieldValidator>

                                        </td>
                                     </tr>                                    
                                    <tr> 
                                        <td class="td1"> Contraseña</td>   
                                       <td class="td2"><asp:TextBox ID="txtPassword" runat="server" TextMode="Password" Width="150px"></asp:TextBox><asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword" ErrorMessage="Falta ingresar Contraseña" ValidationGroup="Form1">*</asp:RequiredFieldValidator></td>
                                    </tr> 
                                    <tr>    
                                        <td class="td1">Sucursal</td>
                                        <td class="td2">
                                        <asp:DropDownList ID="ddlSucursal" runat="server" Width="155px" AppendDataBoundItems="True">
                                        <asp:ListItem Value=" ">Seleccione</asp:ListItem>
                                        </asp:DropDownList><asp:RequiredFieldValidator ID="rfvSucursal" runat="server" ErrorMessage="Debe Elegir la sucursal" ControlToValidate="ddlSucursal" ValidationGroup="Form1">*</asp:RequiredFieldValidator>
                                        </td>
                                    </tr> 
                                    <tr>                                           
                                        <td class="td1">
                                            Nueva Contraseña
                                        </td>
                                        <td class="td2">
                                            <asp:TextBox ID="txtNewPassword" runat="server" TextMode="Password" Width="150px"></asp:TextBox><asp:RequiredFieldValidator ID="rfvNewPassword" runat="server" ErrorMessage="Introduzca su nueva Contraseña" ControlToValidate="txtPassword" ValidationGroup="Form1">*</asp:RequiredFieldValidator>
                                        </td>                                    
                                    </tr> 
                                    <tr>    
                                        <td class="td1">Confirmar Contraseña</td>
                                        <td class="td2">
                                            <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" Width="150px"></asp:TextBox><asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtConfirmPassword" ErrorMessage="Debe Confirmar la nueva contraseña" ValidationGroup="Form1">*</asp:RequiredFieldValidator>
                                        </td>                                    
                                    </tr> 
                                    <tr>   
                                        <td colspan="2"> 
                                            <asp:ValidationSummary ID="vlsForm1" runat="server" HeaderText="Faltan algunos datos" ValidationGroup="Form1" />
                                        </td>
                                   </tr>
                                   <tr>
                                        <td class="td1">    
                                            
                                        </td>    
                                        <td class="td2">
                                            <asp:LinkButton ID="lnkAceptar" runat="server" OnClick="lnkAceptar_Click" ValidationGroup="Form1" CssClass="link001" Height="20px">Aceptar</asp:LinkButton>
                                            &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;<asp:LinkButton ID="lnkCancelar" runat="server" OnClick="lnkCancelar_Click" CssClass="link001" Height="20px">Cancelar</asp:LinkButton>
                                        </td>
                                   </tr>
                                   <tr>         
                                        <td colspan="2">                                                            
                                            <asp:Label ID="lbError" runat="server"></asp:Label>
                                        </td>
                                    </tr> 
                            </table>
                            <br />
                            <br />
                            <div id="sub_footer">
                                <hr class="linea2" /> 
                            </div>  
                            
                        </div>                       
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
