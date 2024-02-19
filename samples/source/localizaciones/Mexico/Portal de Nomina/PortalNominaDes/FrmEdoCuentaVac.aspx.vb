Imports System.Data
Partial Class FrmEdoCuentaVac
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Me.User.Identity.IsAuthenticated And Not Session("cve_emp") Is Nothing Then
            Obtener_ExtVac()
            btnImprimir.Attributes.Add("OnClick", "window.print();")
        Else
            Response.Redirect("Login.aspx")
        End If
    End Sub

    Private Sub Obtener_ExtVac()
        Dim wx_obj_Srv As New WSPTALNOM.WSPTALNOM()
        Dim wx_est_Vac As New WSPTALNOM.STRVACACIONES()
        Dim wa_arr_Vac() As WSPTALNOM.STREXTVAC
        Dim ws_fil_act As String = String.Empty
        Dim ws_cve_emp As String = String.Empty
        Dim wn_num_i As Integer = 0
        Dim ws_emp_act As String

        Dim dsSolicitudes As New DataSet()
        Dim dtSolicitud As DataRow

        dsSolicitudes.Tables.Add("Vacaciones")
        dsSolicitudes.Tables(0).Columns.Add("Concepto", GetType(String))
        dsSolicitudes.Tables(0).Columns.Add("Fecha Inicio", GetType(String))
        dsSolicitudes.Tables(0).Columns.Add("Fecha Fin", GetType(String))
        dsSolicitudes.Tables(0).Columns.Add("Dias Derecho", GetType(String))
        dsSolicitudes.Tables(0).Columns.Add("Dias Disfrutados", GetType(String))
        dsSolicitudes.Tables(0).Columns.Add("Dias Programados", GetType(String))
        dsSolicitudes.Tables(0).Columns.Add("Dias Pagados", GetType(String))
        dsSolicitudes.Tables(0).Columns.Add("Dias Saldo", GetType(String))

        Try

            ws_fil_act = Session("fil_act")
            ws_cve_emp = Session("cve_emp")
            ws_emp_act = Session("emp_act")
            wa_arr_Vac = wx_obj_Srv.GETEXTVAC(ws_fil_act, ws_cve_emp, ws_emp_act)

            For wn_num_i = wa_arr_Vac.Length - 1 To 0 Step -1
                dtSolicitud = dsSolicitudes.Tables(0).NewRow()

                dtSolicitud("Concepto") = wa_arr_Vac(wn_num_i).DESCRIPCION
                dtSolicitud("Fecha Inicio") = wa_arr_Vac(wn_num_i).FECINI
                dtSolicitud("Fecha Fin") = wa_arr_Vac(wn_num_i).FECFIN
                dtSolicitud("Dias Derecho") = wa_arr_Vac(wn_num_i).DIASDER
                dtSolicitud("Dias Disfrutados") = wa_arr_Vac(wn_num_i).DIASDIS
                dtSolicitud("Dias Programados") = wa_arr_Vac(wn_num_i).DIASPRO
                dtSolicitud("Dias Pagados") = wa_arr_Vac(wn_num_i).DIASPAG
                dtSolicitud("Dias Saldo") = wa_arr_Vac(wn_num_i).DIASSAL
                dsSolicitudes.Tables(0).Rows.Add(dtSolicitud)

            Next

            gvVacaciones.DataSource = dsSolicitudes.Tables(0)
            gvVacaciones.DataBind()

            For wn_num_i = 1 To dsSolicitudes.Tables(0).Rows.Count / 10

                DdlElementos.Items.Add(wn_num_i * 10)

            Next

        Catch ex As Exception
            'Response.Write("ERROR: Obtener_ExtVac " + ex.Message)
            lbExcepcion.Text = "ERROR: Obtener_ExtVac " + ex.Message
        End Try
    End Sub
    Protected Sub gvVacaciones_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles gvVacaciones.PageIndexChanging
        gvVacaciones.PageIndex = e.NewPageIndex
        DdlElementos.Items.Clear()
        Obtener_ExtVac()


    End Sub

    Protected Sub DropDownList1_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles DdlElementos.SelectedIndexChanged
        gvVacaciones.PageSize = DdlElementos.SelectedValue
        DdlElementos.Items.Clear()
        Obtener_ExtVac()

    End Sub
End Class
