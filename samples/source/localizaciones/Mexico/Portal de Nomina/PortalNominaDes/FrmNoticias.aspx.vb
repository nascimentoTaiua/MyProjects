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



Partial Class FrmNoticias
    Inherits System.Web.UI.Page


    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim wx_obj_Srv As New WSPTALNOM.WSPTALNOM()
        If Not Session("cve_emp") Is Nothing Then
            Try
                Dim rssURL As String '= "http://news.google.com.mx/news?pz=1&hdlOnly=1&cf=all&ned=es_mx&hl=es&output=rss"
                rssURL = wx_obj_Srv.GETPARAMETRO("PT_NOTPOR", Session("fil_act"), Session("emp_act"))
                ProcessRssItem(rssURL)
            Catch ex As WebException
                lbMsgEx.Text = ex.Message
            Catch ex As Exception
                lbMsgEx.Text = ex.Message
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

        Dim title As String = ""
        Dim link As String = ""
        Dim description As String = ""
        Dim i As Integer = 0
        Dim rssDetail As XmlNode

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

            rssDetail = rssItems.Item(i).SelectSingleNode("description")

            If Not rssDetail Is Nothing Then
                description = rssDetail.InnerText
            Else
                description = ""
            End If
            wx_literal = New Literal()
            wx_literal.Text = "<p class='noticia'><b><a href='" & link & "' target='_blank'>" & title & "</a></b></p>"

            phNoticias.Controls.Add(wx_literal)
        Next

    End Sub
End Class
