Imports System.Data
Imports System.IO
Partial Class FrmReciboNomina
    Inherits System.Web.UI.Page
    Public vs_cve_emp As String
    Public vs_nom_emp As String
    Public vs_fil_act As String
    Public vs_emp_act As String

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        vs_cve_emp = Session("cve_emp")
        vs_fil_act = Session("fil_act")
        vs_nom_emp = Session("nom_emp")
        vs_emp_act = Session("emp_act")

        If Me.User.Identity.IsAuthenticated And Not Session("cve_emp") Is Nothing Then
            obtener_fechas()
        Else
            Response.Redirect("Login.aspx")
        End If

    End Sub

    Private Sub obtener_fechas()
        Dim wx_obj_Srv As New WSPTALNOM.WSPTALNOM()
        Dim wa_arr_Fec() As WSPTALNOM.STRFECRECNOM
        Dim dsFechasRecibo As New DataSet()
        Dim dtFechasRecibo As DataRow
        Dim wn_num_i As Integer = 0

        dsFechasRecibo.Tables.Add("Fechas")
        dsFechasRecibo.Tables(0).Columns.Add("Valor", GetType(String))
        dsFechasRecibo.Tables(0).Columns.Add("Descripcion", GetType(String))

        Try
            wa_arr_Fec = wx_obj_Srv.GETFECNOM(vs_cve_emp, vs_fil_act, vs_emp_act)

            For wn_num_i = 0 To wa_arr_Fec.Length - 1
                dtFechasRecibo = dsFechasRecibo.Tables(0).NewRow()
                dtFechasRecibo("Valor") = wa_arr_Fec(wn_num_i).FECVALUE
                dtFechasRecibo("Descripcion") = wa_arr_Fec(wn_num_i).FECRECNOM
                dsFechasRecibo.Tables(0).Rows.Add(dtFechasRecibo)
            Next

            ddlPeriodos.DataSource = dsFechasRecibo.Tables(0)
            ddlPeriodos.DataValueField = "Valor"
            ddlPeriodos.DataTextField = "Descripcion"
            ddlPeriodos.DataBind()

        Catch ex As Exception
            Response.Write(ex.Message)
        End Try

    End Sub

    Protected Sub btnBuscar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBuscar.Click
        'Response.Write(ddlPeriodos.SelectedValue)
        Dim ws_cve_per As String
        Dim ws_num_pag As String
        Dim ws_proc As String

        ws_cve_per = ddlPeriodos.SelectedValue.Substring(0, 6)
        ws_num_pag = ddlPeriodos.SelectedValue.Substring(6, 2)
        ws_proc = ddlPeriodos.SelectedValue.Substring(8)
        Response.Redirect("ReciboNom.aspx?per=" & ws_cve_per & "&np=" & ws_num_pag & "&pro=" & ws_proc)
        'gen_recibo(ws_cve_per, ws_num_pag)

    End Sub
    Public Sub gen_recibo(ByVal ws_per As String, ByVal ws_np As String)

        Dim ws_cve_per As String = ws_per
        Dim ws_num_pag As String = ws_np
        Dim wx_obj_srv As New WSPTALNOM.WSPTALNOM()
        Dim ws_html As Literal

        vs_cve_emp = Session("cve_emp")
        vs_fil_act = Session("fil_act")
        vs_emp_act = Session("emp_act")

        If Me.User.Identity.IsAuthenticated And Not Session("cve_emp") Is Nothing Then
            Try
                ws_html = New Literal()
                ws_html.Text = wx_obj_srv.GETRECNOM(vs_fil_act, vs_cve_emp, ws_cve_per, ws_num_pag, vs_emp_act)
                'Response.Write(ws_html)
                phRecibo.Controls.Add(ws_html)
            Catch ex As Exception
                'Response.Write("ERROR: PAGE_LOAD() - " & ex.Message)
                lbExcepcion.Text = "ERROR: gen_recibo() -" & ex.Message
            End Try
        Else
            Response.Redirect("Login.aspx")
        End If

    End Sub
End Class
