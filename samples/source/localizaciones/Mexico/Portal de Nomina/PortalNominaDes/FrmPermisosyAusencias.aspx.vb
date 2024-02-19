Imports System.Data
Imports System.Xml
Imports System.IO
Imports System.Net
Imports System.Net.Mail

Partial Class FrmVacaciones
    Inherits System.Web.UI.Page

    Protected Sub btnEnviar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnConsultar.Click
        If Me.User.Identity.IsAuthenticated And Not Session("cve_emp") Is Nothing Then
            Consulta_Permisos()
            btnImprimir.Attributes.Add("onclick", "window.print();")
        Else
            Response.Redirect("Login.aspx")
        End If
    End Sub

    Private Sub Obtener_Conceptos()
        Dim wx_obj_Srv As New WSPTALNOM.WSPTALNOM()
        Dim wa_arr_con() As WSPTALNOM.STREXTCON
        Dim dsConceptos As New DataSet()
        Dim drConceptos As DataRow


        Dim ws_fil_act As String = String.Empty
        Dim ws_emp_act As String = String.Empty
        Dim wn_num_i As Integer = 0

        Try

            ws_fil_act = Session("fil_act")
            ws_emp_act = Session("emp_Act")

            wa_arr_con = wx_obj_Srv.GETCONPERYAUS(ws_fil_act, ws_emp_act)

            dsConceptos.Tables.Add("Conceptos")
            dsConceptos.Tables(0).Columns.Add("Codigo", GetType(String))
            dsConceptos.Tables(0).Columns.Add("Descripcion", GetType(String))

            For wn_num_i = 0 To wa_arr_con.Length - 1

                drConceptos = dsConceptos.Tables(0).NewRow()

                drConceptos("Codigo") = wa_arr_con(wn_num_i).CODIGO
                drConceptos("Descripcion") = wa_arr_con(wn_num_i).DESCRIPCION

                dsConceptos.Tables(0).Rows.Add(drConceptos)

            Next

            ddlConceptos.DataSource = dsConceptos
            ddlConceptos.DataTextField = "Descripcion"
            ddlConceptos.DataValueField = "Codigo"
            ddlConceptos.DataBind()

        Catch ex As Exception
            lbMensaje.Text = "ERROR: función obtener_conceptos()" & ex.Message
        End Try

    End Sub

    Public Sub Consulta_Permisos()
        Try

        
            Dim wx_obj_Srv As New WSPTALNOM.WSPTALNOM()
            Dim wx_est_Vac As New WSPTALNOM.STRVACACIONES()
            Dim wa_arr_Aus() As WSPTALNOM.STREXTAUS
            Dim ws_fil_act As String = String.Empty
            Dim ws_cve_emp As String = String.Empty
            Dim ws_emp_act As String = String.Empty
            Dim wn_num_i As Integer = 0
            Dim ws_filtro As String = String.Empty
            Dim wd_Fec_Ini As DateTime = Convert.ToDateTime(txtFechaInicio.Text)
            Dim wd_Fec_Fin As DateTime = Convert.ToDateTime(txtFechaFin.Text)

            Dim dsPermisos As New DataSet()
            Dim dtPermiso As DataRow

            dsPermisos.Tables.Add("Permisos")
            dsPermisos.Tables(0).Columns.Add("Concepto", GetType(String))
            dsPermisos.Tables(0).Columns.Add("Fecha Inicio", GetType(String))
            dsPermisos.Tables(0).Columns.Add("Fecha Fin", GetType(String))
            dsPermisos.Tables(0).Columns.Add("Dias", GetType(String))
            dsPermisos.Tables(0).Columns.Add("Tipo", GetType(String))

            Try
                ws_filtro = " R8_DATAINI>='" & wd_Fec_Ini.ToString("yyyyMMdd") & "' AND "
                ws_filtro += " R8_DATAFIM<='" & wd_Fec_Fin.ToString("yyyyMMdd") & "'  "

                If ddlConceptos.SelectedValue <> " " Then
                    ws_filtro += " AND  R8_PD='" & ddlConceptos.SelectedValue & "' "
                End If

                ws_fil_act = Session("fil_act")
                ws_cve_emp = Session("cve_emp")
                ws_emp_act = Session("emp_act")

                wa_arr_Aus = wx_obj_Srv.GETEXTAUS(ws_fil_act, ws_cve_emp, ws_filtro, ws_emp_act)

                For wn_num_i = 0 To wa_arr_Aus.Length - 1
                    dtPermiso = dsPermisos.Tables(0).NewRow()

                    dtPermiso("Concepto") = wa_arr_Aus(wn_num_i).DESCRIPCION
                    dtPermiso("Fecha Inicio") = wa_arr_Aus(wn_num_i).FECINI
                    dtPermiso("Fecha Fin") = wa_arr_Aus(wn_num_i).FECFIN
                    dtPermiso("Dias") = wa_arr_Aus(wn_num_i).DIAS
                    dtPermiso("Tipo") = wa_arr_Aus(wn_num_i).TIPO
                    dsPermisos.Tables(0).Rows.Add(dtPermiso)

                Next
                If dsPermisos.Tables(0).Rows.Count = 0 Then
                    lbMensaje.Text = "No se encontraron resultados con los datos de búsqueda introducidos"
                End If

                gvVacaciones.DataSource = dsPermisos.Tables(0)
                gvVacaciones.DataBind()

                If gvVacaciones.Rows.Count > 0 Then
                    btnImprimir.Visible = True
                Else
                    btnImprimir.Visible = False
                End If

            Catch ex As Exception
                lbMensaje.Text = "ERROR: Función Consulta_permisos() " + ex.Message
            End Try
        Catch ex As Exception
            lbMensaje.Text = "ERROR: Función Consulta_permisos() " + ex.Message
        End Try
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not Me.IsPostBack Then
            If Me.User.Identity.IsAuthenticated And Not Session("cve_emp") Is Nothing Then
                Obtener_Conceptos()
            End If
        End If

    End Sub

    Protected Sub Button1_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles Button1.Click
        ddlConceptos.SelectedValue = " "
        txtFechaInicio.Text = ""
        txtFechaFin.Text = ""
        lbMensaje.Text = ""
    End Sub

End Class
