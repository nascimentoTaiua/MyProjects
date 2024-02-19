
<%@ page language="VB" autoeventwireup="false" inherits="home, App_Web_fvutkeaf" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>Portal de Nomina</title>
    <link href="ESTILO.CSS" type="text/css" rel="stylesheet" />
    <script language="javascript" type="text/javascript"   >
    /* Programa que controla la visualización de los menus */

        function collapse_menus(menuID) {
	        var x=0;
	        var hideElement;
	        for (x=0;x<999;x=x+1) {
		        try {
			        if (menuID != 'menu' + x) {
				        hideElement = document.getElementById('menu' + x).style;
				        hideElement.display = 'none';
			        }
		        } catch (e) {
			        x=1000;
		        }
	        }
        }
        function menu_tag(menuID) {
	        collapse_menus(menuID);
	        if (document.getElementById) {
		        var abra = document.getElementById(menuID).style;
		        if (abra.display == 'block') {
			        abra.display = 'none';
		        } else {
			        abra.display = 'block';
		        }
	        return false;
	        } else {
	        return true;
	        }
        }

    
    function getWindowData(n,i)
    { 
        var ifr=document.getElementById(i).contentWindow.document || document.getElementById(i).contentDocument; 
        var widthViewport,heightViewport,xScroll,yScroll,widthTotal,heightTotal; 
        if (typeof window.frames[n].innerWidth != 'undefined'){ 
            widthViewport= window.frames[n].innerWidth; 
            heightViewport= window.frames[n].innerHeight; 
        }else if(typeof ifr.documentElement != 'undefined' && typeof ifr.documentElement.clientWidth !='undefined' && ifr.documentElement.clientWidth != 0){ 
            widthViewport=ifr.documentElement.clientWidth; 
            heightViewport=ifr.documentElement.clientHeight; 
        }else{ 
            widthViewport= ifr.getElementsByTagName('body')[0].clientWidth; 
            heightViewport=ifr.getElementsByTagName('body')[0].clientHeight; 
        } 
        xScroll=window.frames[n].pageXOffset || (ifr.documentElement.scrollLeft+ifr.body.scrollLeft); 
        yScroll=window.frames[n].pageYOffset || (ifr.documentElement.scrollTop+ifr.body.scrollTop); 
        widthTotal=Math.max(ifr.documentElement.scrollWidth,ifr.body.scrollWidth,widthViewport); 
        heightTotal=Math.max(ifr.documentElement.scrollHeight,ifr.body.scrollHeight,heightViewport); 
        return [widthViewport,heightViewport,xScroll,yScroll,widthTotal,heightTotal]; 
    }  
    function resizeIframe(ID,NOMBRE)
    { 
        document.getElementById(ID).height=null; 
        document.getElementById(ID).width=null; 
        var m=getWindowData(NOMBRE,ID);  
        document.getElementById(ID).height=m[5]; 
        /*document.getElementById(ID).width=m[4]+22; */
    } 
    
    function call_opcion(texto)
    {
         document.getElementById("lbOpcion").innerHTML=texto;
         return true;
    }   

    </script>
</head>
<body class="bodystyle" >
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
                 <div id="datos_empresa" >
                    <asp:Label ID="lbempresa" runat="server"  Text="Nombre del Cliente S.A. de C.V." CssClass="Title"></asp:Label>                
                 </div>   
                 <div id="login">
                    <label class="label1">N&oacute;mina OnLine</label>
                    <asp:LoginStatus ID="LoginStatus1" runat="server"  ForeColor="Black" CssClass="espaciocierre" LoginText="Iniciar Sesión" LogoutText="Cerrar Sesión" />        
                 </div>   
                 <div id="datos_acceso" class="datos_acceso">        
                        <div class="menu_opcion">
                            USTED ESTA AQUI: 
                            <asp:Label ID="lbOpcion" runat="server" Text="PRINCIPAL"></asp:Label>
                        </div>    
                        <div id="bienvenidos" class="acceso">
                            <label> Bienvenido&nbsp;:</label>
                            <asp:Label ID="lbNombre" runat="server"></asp:Label>                        
                        </div>                                    
                    </div>                                    
            </div>             
            <div id="content">
                <div id="sidebar">            
                    <div id="Menu" class="MenuGen" >                                          
                        <asp:PlaceHolder ID="MenuGen" runat="server"></asp:PlaceHolder>
                        <asp:Label ID="lbExcepcion" runat="server"></asp:Label>                        
                   </div>
                </div>
                <div id="main">
                    <iframe name="IFRAME1" src="Frmprincipal.aspx" frameborder="0" class="frame"  id="IFRAME1" scrolling="no" onload="resizeIframe('IFRAME1','IFRAME1');" ></iframe>            
                </div>
                <div id="sidebar_der">
                    <div id="logo_totvs">
                        <img alt="logo totvs" src="images/logo_totvs.png" />
                    </div>
                    <div id="info" class="info">
                        Dudas y asesoria llame al<br />
                        <br />
                        <asp:Label ID="lbTelefono" runat="server"></asp:Label><br />
                        <br />
                        Contacto<br />
                        &nbsp;<asp:Label ID="lbMail" runat="server"></asp:Label>
                    </div>
                    <div id="news">
                        <div id="Fecha">
                            <p><asp:Label ID="lbFecha" runat="server" Text="Fecha"></asp:Label></p>
                        </div>
                        <div id="enc_news" class="enc_news">
                            <img alt="news" src="images/ico_noticias.png" class="esquina_inf_izq"/>
                            <div class="enc_label"><a href="FrmNoticias.aspx" target="IFRAME1">Noticias</a></div>                             
                        </div> 
                        <div id="Content_news">       
                              <asp:PlaceHolder runat="server" ID="plhNoticias"></asp:PlaceHolder> 
                        </div> 
                    </div>
                </div>
            </div>
            <div id="footer" >
                
            </div>
        </div>
    </div>
    </form>
</body>
</html>
