Imports System.Data
Imports System.Xml
Imports System.IO
Partial Class Empleados
    Inherits System.Web.UI.Page
    Private _CveUsuario As String
    Public Property vs_Cve_Usr() As String
        Get
            Return _CveUsuario
        End Get
        Set(ByVal value As String)
            _CveUsuario = value
        End Set
    End Property

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Me.User.Identity.IsAuthenticated And Not Session("cve_emp") Is Nothing Then
            vs_Cve_Usr = Me.User.Identity.Name
            gen_Carpetas()
            Crear_Controles()
        Else
            Response.Redirect("Login.aspx")
        End If

    End Sub
    
    Private Function construirControl(ByVal nodoControl As XmlElement) As Control
        Dim WebCtrl As New Control()
        WebCtrl = construirLabel(nodoControl)
        Return WebCtrl
    End Function

    Private Function construirLabel(ByVal nodo As XmlNode) As Label
        Dim l As New Label()
        l.ID = nodo.Attributes("ID").Value
        l.Text = nodo.Attributes("Text").Value
        'l.CssClass = nodo.Attributes("CssClass").Value
        Return l
    End Function

    Protected Sub Crear_Controles()
        Dim wn_num_i As Integer = 0
        Dim wx_doc As New XmlDocument()
        Dim wx_xmlCampo As XmlNodeList
        Dim wx_xmlElement As XmlNodeList
        Dim wx_obj_Srv As New WSPTALNOM.WSPTALNOM()
        Dim ws_XML As String = ""
        Dim ws_id_fol As String
        Dim ws_fil_act As String
        Dim ws_emp_act As String
        Dim wx_Literal As LiteralControl

        Try

            If Request.QueryString("car") Is Nothing Then
                ws_id_fol = "1"
            Else
                ws_id_fol = Request.QueryString("car")
            End If

            ws_fil_act = Session("fil_act")
            ws_emp_act = Session("emp_act")

            ws_XML = wx_obj_Srv.GETCAMPOS(ws_fil_act, ws_emp_act, vs_Cve_Usr, ws_id_fol)
            wx_doc.LoadXml(ws_XML)
            wx_xmlCampo = wx_doc.GetElementsByTagName("controles")
            wx_xmlElement = DirectCast(wx_xmlCampo(0), XmlElement).GetElementsByTagName("control")

            For Each wx_nodo As XmlElement In wx_xmlElement

                wn_num_i += 1
                wx_Literal = New LiteralControl()
                If wx_nodo.Attributes("type").Value = "Label" Then
                    wx_Literal.Text = "<label for='" & wx_nodo.Attributes("name").Value & "' class='label'>" & wx_nodo.Attributes("Text").Value & "</label>"
                Else
                    wx_Literal.Text = "<input class='input' type='Text' id='" & wx_nodo.Attributes("name").Value & "'Value='" & wx_nodo.Attributes("Text").Value & "' readonly='readonly'/>"
                End If
                phDatosPersonales.Controls.Add(wx_Literal)

                Dim cSalto As New LiteralControl("<br/>")

                If wn_num_i Mod 2 = 0 Then
                    phDatosPersonales.Controls.Add(cSalto)
                End If
            Next
        Catch ex As Exception
            Dim cSalto As New LiteralControl("<br/>")
            Dim lbExcepcion As New Label()
            lbExcepcion.ID = "lbEx"
            lbExcepcion.Text = "Error: Funcion crear_controles() " & ex.Message
            lbExcepcion.CssClass = "error"
            phDatosPersonales.Controls.Add(lbExcepcion)
            phDatosPersonales.Controls.Add(cSalto)
        End Try
    End Sub

    Protected Sub gen_Carpetas()
        Dim wx_obj_Srv As New WSPTALNOM.WSPTALNOM()
        Dim wx_str_fl() As WSPTALNOM.STRCARPETA
        Dim ws_fil_act As String
        Dim ws_emp_act As String
        Dim wx_Literal As New Literal()
        Dim wn_num_i As Integer
        Dim ws_texto As String
        Dim ws_class As String

        Try

            If Request.QueryString("car") Is Nothing Then
                ws_class = "seleccion"
            End If

            ws_fil_act = Session("fil_act")
            ws_emp_act = Session("emp_act")

            wx_str_fl = wx_obj_Srv.GETCARPETAS(ws_fil_act, ws_emp_act)

            wx_Literal.Text = "<ul>"
            For wn_num_i = 0 To wx_str_fl.Length - 1
                ws_texto = wx_str_fl(wn_num_i).NOMBRE

                If ws_texto.ToUpper() = "OTROS" Then
                    ws_texto = "Otros"
                End If
                wx_Literal.Text += "<li><a href='Empleados.aspx?car=" & wx_str_fl(wn_num_i).ID + "' "
                If wx_str_fl(wn_num_i).ID = Request.QueryString("car") And Not Request.QueryString("car") Is Nothing Then
                    wx_Literal.Text += "class='seleccion' "
                End If
                If Request.QueryString("car") Is Nothing And wx_str_fl(wn_num_i).ID = "1" Then
                    wx_Literal.Text += "class='seleccion' "
                End If
                wx_Literal.Text += "><span>" & ws_texto & "</span></a></li>"

            Next

            wx_Literal.Text += "</ul>"

            phCarpetas.Controls.Add(wx_Literal)

        Catch ex As Exception

        End Try

    End Sub

End Class
