Imports System.Data
Imports System.Configuration
Imports System.Collections
Imports System.Web
Imports System.Web.Security
Imports System.Web.UI
Imports System.Web.UI.WebControls
Imports System.Web.UI.WebControls.WebParts
Imports System.Web.UI.HtmlControls
Imports System.Net
Imports System.Xml
Imports System.IO
Partial Class home
    Inherits System.Web.UI.Page
    Public frameName As String
    Public ws_cve_emp As String
    Public vs_emp_act As String
    Public vs_fil_act As String

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim wd_fecha As DateTime
        wd_fecha = DateTime.Now
        lbFecha.Text = wd_fecha.ToString("dddd") & " " & wd_fecha.ToString()
        If Me.User.Identity.IsAuthenticated And Not Session("cve_emp") Is Nothing Then
            ws_cve_emp = Session("cve_emp")
            lbNombre.Text = Session("nom_emp")
            lbempresa.Text = Session("nom_empresa")
            vs_emp_act = Session("emp_act")
            vs_fil_act = Session("fil_act")
            genera_menu()
            gen_news()
            obten_contacto()
        Else
            Response.Redirect("Login.aspx")
        End If

    End Sub
    Protected Sub obten_contacto()
        Dim ws_tel_con As String
        Dim wx_obj_srv As New WSPTALNOM.WSPTALNOM()

        lbExcepcion.Text = " "

        Try
            ws_tel_con = wx_obj_srv.GETTELCONT(vs_fil_act, vs_emp_act)
            lbTelefono.Text = ws_tel_con

        Catch ex As Exception
            lbExcepcion.Text = "ERROR: Funcion obten_contacto()-" & ex.Message
        End Try

        Try
            ws_tel_con = wx_obj_srv.GETMAIL(vs_fil_act, vs_emp_act)
            lbMail.Text = ws_tel_con

        Catch ex As Exception
            lbExcepcion.Text = "ERROR: Funcion obten_contacto()-" & ex.Message
        End Try



    End Sub
    Protected Sub genera_menu()

        Try
            Dim oSrv As New WSPTALNOM.WSPTALNOM()
            Dim cXml As String
            Dim wx_doc As New XmlDocument()

            Dim wx_xmlCampo As XmlNodeList
            Dim wx_xmlElement As XmlNodeList
            Dim wx_literal As Literal
            Dim x As Integer = 0
            Dim j As Integer = 0

            cXml = oSrv.GENERAMENU(vs_fil_act, vs_emp_act)

            wx_doc.LoadXml(cXml)
            wx_xmlCampo = wx_doc.GetElementsByTagName("Home")
            wx_xmlElement = DirectCast(wx_xmlCampo(0), XmlElement).GetElementsByTagName("Menu")

            wx_literal = New Literal()

            For Each wx_nodo As XmlElement In wx_xmlElement
                j = 0
                wx_literal.Text += "<ul><li><a href='" & wx_nodo.Attributes("url").Value & "' target='IFRAME1' onclick=""menu_tag('menu" + x.ToString() + "'); call_opcion('" + wx_nodo.Attributes("text").Value + "');"">" & wx_nodo.Attributes("text").Value & " </a>"
                wx_literal.Text += "<ul id='menu" & x.ToString() & "' style='display: none' >"

                For Each wx_subnodo As XmlElement In wx_nodo
                    
                    wx_literal.Text += "<li><a href='" & wx_subnodo.Attributes("url").Value & "' target='IFRAME1' onclick=""call_opcion('" + wx_nodo.Attributes("text").Value + "  >>  " + wx_subnodo.Attributes("text").Value + "');"">" & wx_subnodo.Attributes("text").Value & " </a></li>"
                    j += 1
                Next
                If j <> 0 Then
                    wx_literal.Text += "<li class='last' id='last'><a class='invisible'>XXXXX</a></li>"
                End If

                wx_literal.Text += "</ul></li></ul>"
                x += 1
            Next

            MenuGen.Controls.Add(wx_literal)
            lbExcepcion.Text = ""

        Catch ex As Exception
            lbExcepcion.Text = " ERROR: Function Genera_menu()-" & ex.Message
        End Try

    End Sub

    Protected Sub gen_news()
        Dim wx_obj_Srv As New WSPTALNOM.WSPTALNOM()
        If Not Session("cve_emp") Is Nothing Then
            Try
                Dim rssURL As String '= "http://news.google.com.mx/news?pz=1&cf=all&ned=es_mx&hl=es&output=rss"
                rssURL = wx_obj_Srv.GETPARAMETRO("PT_NOTPOR", Session("fil_act"), Session("emp_act"))
                ProcessRssItem(rssURL)
            Catch ex As Exception
                lbExcepcion.Text = ex.Message
            End Try
        Else
            Response.Redirect("Login.aspx")
        End If
    End Sub
    Public Sub ProcessRssItem(ByVal rssURL As String)
        Dim myRequest As WebRequest = WebRequest.Create(rssURL)
        Dim myResponse As WebResponse = myRequest.GetResponse()

        Dim rssStream As Stream = myResponse.GetResponseStream()
        Dim rssDoc As New XmlDocument()
        Dim wx_literal As Literal

        rssDoc.Load(rssStream)

        Dim rssItems As XmlNodeList = rssDoc.SelectNodes("rss/channel/item")
        Dim r As Random
        Dim wa_arr_rss(rssItems.Count - 1) As String
        Dim rssList As New ArrayList()
        Dim title As String = ""
        Dim link As String = ""
        Dim description As String = ""
        Dim i As Integer = 0
        Dim rssDetail As XmlNode
        Dim wn_num_itm As Integer = 3


        For i = 0 To rssItems.Count - 1
            rssDetail = rssItems.Item(i).SelectSingleNode("title")

            If Not rssDetail Is Nothing Then
                title = rssDetail.InnerText
            Else
                title = ""
            End If

            rssDetail = rssItems.Item(i).SelectSingleNode("link")

            If Not rssDetail Is Nothing Then
                link = rssDetail.InnerText
            Else
                link = ""
            End If

            wa_arr_rss(i) = "<span><a href='" & link & "' target='_blank'>" & title & "</a><br/><hr class='linea2'/><br/></span>"

        Next
        Dim num As Integer

        r = New Random()

        wx_literal = New Literal()
        wx_literal.Text = "<p>"
        plhNoticias.Controls.Add(wx_literal)

        For i = 0 To 3

            num = r.Next(wa_arr_rss.Length)
            While (rssList.BinarySearch(wa_arr_rss(num)) > -1)
                num = r.Next(wa_arr_rss.Length)
            End While
            rssList.Add(wa_arr_rss(num))
            rssList.Sort()

            wx_literal = New Literal()
            wx_literal.Text = wa_arr_rss(num)
            plhNoticias.Controls.Add(wx_literal)

        Next



        wx_literal.Text = "</p>"
        plhNoticias.Controls.Add(wx_literal)

    End Sub

    Protected Sub LoginStatus1_LoggingOut(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.LoginCancelEventArgs) Handles LoginStatus1.LoggingOut
        Session.Abandon()
    End Sub
End Class
