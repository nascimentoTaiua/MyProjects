Imports System.Xml

Partial Class FrmPrincipal
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Session("cve_emp") Is Nothing Then
            gen_principal()
        Else
            Response.Redirect("Login.aspx")
        End If
    End Sub

    Protected Sub gen_principal()
        Dim ws_fil_act As String
        Dim ws_emp_act As String
        Dim cXml As String
        Dim wx_obj_srv As New WSPTALNOM.WSPTALNOM()
        Dim wx_Doc As XmlDocument = New XmlDocument()
        Dim wx_xmlCampo As XmlNodeList
        Dim wx_xmlElement As XmlNodeList
        Dim wx_literal As Literal
        Dim x As Integer = 0
        Dim j As Integer = 0

        ws_fil_act = Session("fil_Act")
        ws_emp_act = Session("emp_act")

        Try
            cXml = wx_obj_srv.GENERAMENU(ws_fil_act, ws_emp_act)
            wx_Doc.LoadXml(cXml)
            wx_xmlCampo = wx_doc.GetElementsByTagName("Home")
            wx_xmlElement = DirectCast(wx_xmlCampo(0), XmlElement).GetElementsByTagName("Menu")

            wx_literal = New Literal()
            j = 0
            For Each wx_nodo As XmlElement In wx_xmlElement

                wx_literal.Text += "<div class='descripcion'  id='desc1'>"
                wx_literal.Text += "<div class='img_desc' id='img1'>"
                wx_literal.Text += "<img alt='img' src='images/icono_romp_" & (j + 1).ToString() & ".png' class='esquina_inf_izq'/>"
                wx_literal.Text += "</div>"
                wx_literal.Text += "<div class='desc' id='subdesc1'>"
                wx_literal.Text += "<span class='subTitle'>" & wx_nodo.Attributes("text").Value & "</span>"
                wx_literal.Text += "    <p class='parrafo'>"

                If wx_nodo.Attributes("desc").Value.Trim.Length > 0 Then
                    wx_literal.Text += wx_nodo.Attributes("desc").Value
                Else
                    For Each wx_subnodo As XmlElement In wx_nodo
                        wx_literal.Text += wx_subnodo.Attributes("desc").Value & "<br/>"
                    Next

                End If

                wx_literal.Text += "</p>"
                wx_literal.Text += " </div>"
                wx_literal.Text += "</div>"

                j += 1             
               
            Next

        Catch ex As Exception
            wx_literal = New Literal()
            wx_literal.Text += "<p>" & ex.Message & "</p>"
        End Try
        wx_literal.Text += "<br /><br/>"
        phContenido.Controls.Add(wx_literal)

    End Sub
End Class
