Imports System.Data
Partial Class FrmHistLaboral
    Inherits System.Web.UI.Page
    Public vs_cve_emp As String = String.Empty
    Public vs_fil_Act As String = String.Empty
    Public vs_nom_emp As String = String.Empty
    Public vs_emp_act As String = String.Empty

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        vs_cve_emp = Session("cve_emp")
        vs_fil_Act = Session("fil_act")
        vs_nom_emp = Session("nom_emp")
        vs_emp_act = Session("emp_act")

        btnImprimir.Attributes.Add("OnClick", "window.print();")

        If Not IsPostBack Then
            If Me.User.Identity.IsAuthenticated And Not Session("cve_emp") Is Nothing Then
                obtener_fechas()
            Else
                Response.Redirect("Login.aspx")
            End If
        End If
    End Sub

    Protected Sub cbxTodos_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles cbxTodos.CheckedChanged
        If cbxTodos.Checked Then
            cbxAltas.Checked = True
            cbxBajas.Checked = True
            cbxMod.Checked = True
            cbxDepartamentos.Checked = True
            cbxLocalPago.Checked = True
            cbxCenCos.Checked = True
            cbxFunciones.Checked = True
            cbxCargos.Checked = True
        Else
            cbxAltas.Checked = False
            cbxBajas.Checked = False
            cbxMod.Checked = False
            cbxDepartamentos.Checked = False
            cbxLocalPago.Checked = False
            cbxCenCos.Checked = False
            cbxFunciones.Checked = False
            cbxCargos.Checked = False
        End If
    End Sub

    Private Sub obtener_fechas()
        Dim wx_obj_Srv As New WSPTALNOM.WSPTALNOM()
        Dim ws_Fec_adm As String = String.Empty
        Dim wd_fec_adm As DateTime

        Try
            ws_Fec_adm = wx_obj_Srv.GETFECADMIS(vs_fil_Act, vs_cve_emp, vs_emp_act)
            wd_fec_adm = DateTime.Parse(ws_Fec_adm)

            txtFechaInicio.Text = wd_fec_adm.ToString("dd/MM/yyyy")
            txtFechaFin.Text = wd_fec_adm.ToString("dd/MM/yyyy")

        Catch ex As Exception
            'Response.Write("ERROR: Función obtener_fechas() " & ex.Message)
            lbMsg.Text = "ERROR: Función obtener_fechas() " & ex.Message
        End Try

    End Sub

    Protected Sub Button1_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles Button1.Click

        If Me.User.Identity.IsAuthenticated And Not Session("cve_emp") Is Nothing Then
            obtener_fechas()
            cbxTodos.Checked = False
            cbxAltas.Checked = False
            cbxBajas.Checked = False
            cbxMod.Checked = False
            cbxDepartamentos.Checked = False
            cbxLocalPago.Checked = False
            cbxCenCos.Checked = False
            cbxFunciones.Checked = False
            cbxCargos.Checked = False
            lbMsg.Text = ""
            gvHisLab.DataBind()
        Else
            Response.Redirect("Login.aspx")
        End If
    End Sub

    Protected Sub btnConsultar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnConsultar.Click
        Try


            Dim ws_Fec_Ini As String = String.Empty
            Dim ws_Fec_Fin As String = String.Empty
            Dim wd_Fec_Ini As DateTime = Convert.ToDateTime(txtFechaInicio.Text)
            Dim wd_Fec_Fin As DateTime = Convert.ToDateTime(txtFechaFin.Text)
            Dim wa_his_lab() As WSPTALNOM.STRHISLAB
            Dim wx_obj_Srv As New WSPTALNOM.WSPTALNOM()
            Dim ws_filtro As String = String.Empty
            Dim wn_num_i As Integer = 0

            Dim dsHistorial As New DataSet()
            Dim dtHistorial As DataRow
            lbMsg.Text = ""
            If Me.User.Identity.IsAuthenticated And Not Session("cve_emp") Is Nothing Then
                If cbxTodos.Checked Then
                    ws_filtro = "ABMDCLFP"
                Else
                    If cbxAltas.Checked Then
                        ws_filtro += "A"
                    End If
                    If cbxBajas.Checked Then
                        ws_filtro += "B"
                    End If
                    If cbxMod.Checked Then
                        ws_filtro += "M"
                    End If
                    If cbxDepartamentos.Checked Then
                        ws_filtro += "D"
                    End If
                    If cbxCenCos.Checked Then
                        ws_filtro += "C"
                    End If
                    If cbxLocalPago.Checked Then
                        ws_filtro += "L"
                    End If
                    If cbxFunciones.Checked Then
                        ws_filtro += "F"
                    End If
                    If cbxCargos.Checked Then
                        ws_filtro += "P"
                    End If
                End If

                dsHistorial.Tables.Add("Historial")
                dsHistorial.Tables(0).Columns.Add("Fecha", GetType(String))
                dsHistorial.Tables(0).Columns.Add("Movimiento", GetType(String))
                dsHistorial.Tables(0).Columns.Add("Salario Diario", GetType(String))
                dsHistorial.Tables(0).Columns.Add("Salario Dia Int.", GetType(String))
                dsHistorial.Tables(0).Columns.Add("Salario Mensual", GetType(String))
                dsHistorial.Tables(0).Columns.Add("Loc.", GetType(String))
                dsHistorial.Tables(0).Columns.Add("C.C.", GetType(String))
                dsHistorial.Tables(0).Columns.Add("Depto", GetType(String))
                'dsHistorial.Tables(0).Columns.Add("Funcion", GetType(String))
                'dsHistorial.Tables(0).Columns.Add("Cargo", GetType(String))


                Try
                    wa_his_lab = wx_obj_Srv.GETHISLAB(vs_fil_Act, vs_cve_emp, ws_filtro, wd_Fec_Ini.ToString("yyyyMMdd"), wd_Fec_Fin.ToString("yyyyMMdd"), vs_emp_act)
                    For wn_num_i = 0 To wa_his_lab.Length - 1
                        dtHistorial = dsHistorial.Tables(0).NewRow()

                        dtHistorial("Fecha") = wa_his_lab(wn_num_i).FECMOV
                        dtHistorial("Movimiento") = wa_his_lab(wn_num_i).DESCRIPCION
                        dtHistorial("Salario Diario") = wa_his_lab(wn_num_i).SALDIARIO
                        dtHistorial("Salario Dia Int.") = wa_his_lab(wn_num_i).SALDIAINT
                        dtHistorial("Salario Mensual") = wa_his_lab(wn_num_i).SALMENSUAL
                        dtHistorial("Loc.") = wa_his_lab(wn_num_i).LOCPAGO
                        dtHistorial("C.C.") = wa_his_lab(wn_num_i).CENCOS
                        dtHistorial("Depto") = wa_his_lab(wn_num_i).DEPTO
                        'dtHistorial("Funcion") = wa_his_lab(wn_num_i).FUNCION
                        'dtHistorial("Cargo") = wa_his_lab(wn_num_i).CARGO
                        dsHistorial.Tables(0).Rows.Add(dtHistorial)

                        dtHistorial = dsHistorial.Tables(0).NewRow()
                        dtHistorial("Fecha") = " "
                        dtHistorial("Movimiento") = " "
                        dtHistorial("Salario Diario") = " "
                        dtHistorial("Salario Dia Int.") = " "
                        dtHistorial("Salario Mensual") = " "
                        dtHistorial("Loc.") = "Cargo: " & wa_his_lab(wn_num_i).CARGO
                        dtHistorial("C.C.") = "Funcion: " & wa_his_lab(wn_num_i).FUNCION
                        dtHistorial("Depto") = " "
                        dsHistorial.Tables(0).Rows.Add(dtHistorial)

                    Next

                    gvHisLab.DataSource = dsHistorial.Tables(0)
                    gvHisLab.DataBind()

                    If gvHisLab.Rows.Count = 0 Then
                        lbMsg.Text = "No se Encontraron registros con esos parámetros de búsqueda"
                        btnImprimir.Visible = False
                    Else
                        btnImprimir.Visible = True
                        lbMsg.Text = ""
                    End If

                Catch ex As Exception

                    lbMsg.Text = "ERROR: Funcion btnConsultar_Click() " & ex.Message
                End Try
            Else
                Response.Redirect("Login.aspx")
            End If
        Catch ex As Exception
            lbMsg.Text = "ERROR: Funcion btnConsultar_Click() " & ex.Message
        End Try
    End Sub
End Class
