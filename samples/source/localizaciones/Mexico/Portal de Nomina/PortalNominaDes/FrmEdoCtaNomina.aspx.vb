Imports System.Data
Imports System.Xml
Imports System.IO
Imports System.Net
Imports System.Net.Mail

Partial Class _Default
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

        btnImprimir.Attributes.Add("onclick", "window.print();")
        'Me.rvFechaInicio.MaximumValue = DateTime.Today.ToString("dd/MM/yyyy")

        If Me.User.Identity.IsAuthenticated And Not Session("cve_emp") Is Nothing Then
            If Not Me.IsPostBack Then
                obtener_conceptos()
            End If
        Else
            Response.Redirect("Login.aspx")
        End If

        If gvEdoCta.Rows.Count > 0 Then
            btnImprimir.Visible = True
        End If

    End Sub

    Private Sub obtener_conceptos()
        Dim wx_obj_Srv As New WSPTALNOM.WSPTALNOM()
        Dim wa_arr_Con() As WSPTALNOM.STREXTCON
        Dim dsConceptos As New DataSet()
        Dim dtConceptos As DataRow
        Dim wn_num_i As Integer = 0

        dsConceptos.Tables.Add("Conceptos")
        dsConceptos.Tables(0).Columns.Add("Codigo", GetType(String))
        dsConceptos.Tables(0).Columns.Add("Descripcion", GetType(String))

        Try
            wa_arr_Con = wx_obj_Srv.GETEXTCON(vs_fil_act, vs_cve_emp, vs_emp_act)

            For wn_num_i = 0 To wa_arr_Con.Length - 1
                dtConceptos = dsConceptos.Tables(0).NewRow()
                dtConceptos("Codigo") = wa_arr_Con(wn_num_i).CODIGO
                dtConceptos("Descripcion") = wa_arr_Con(wn_num_i).DESCRIPCION
                dsConceptos.Tables(0).Rows.Add(dtConceptos)
            Next

            ddlConceptos.DataSource = dsConceptos.Tables(0)
            ddlConceptos.DataValueField = "Codigo"
            ddlConceptos.DataTextField = "Descripcion"
            ddlConceptos.DataBind()

        Catch ex As Exception
            ' Response.Write("ERROR : obtener_conceptos " & ex.Message)
            lbExcepcion.Text = "ERROR : obtener_conceptos " & ex.Message
        End Try
    End Sub

    Protected Sub btnConsultar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnConsultar.Click

            Try


                Dim ws_Fec_Ini As String = String.Empty
                Dim ws_Fec_Fin As String = String.Empty
                Dim wd_Fec_Ini As DateTime = Convert.ToDateTime(txtFechaInicio.Text)
                Dim wd_Fec_Fin As DateTime = Convert.ToDateTime(txtFechaFin.Text)
                Dim wa_edo_cta() As WSPTALNOM.STRCTANOM
                Dim wx_obj_Srv As New WSPTALNOM.WSPTALNOM()
                Dim wn_num_i As Integer = 0
                Dim ws_importe As String = " "
                Dim dsCuentas As New DataSet()
                Dim dtCuentas As DataRow

                If Me.User.Identity.IsAuthenticated And Not Session("cve_emp") Is Nothing Then

                    dsCuentas.Tables.Add("Historial")
                    dsCuentas.Tables(0).Columns.Add("Fecha", GetType(String))
                    dsCuentas.Tables(0).Columns.Add("Concepto", GetType(String))
                    dsCuentas.Tables(0).Columns.Add("Importe", GetType(String))
                    dsCuentas.Tables(0).Columns.Add("Suma", GetType(String))

                    lbExcepcion.Text = ""

                    If Not txtimporte.Text.Equals("") Then
                        ws_importe = txtimporte.Text
                    End If

                    Try

                        wa_edo_cta = wx_obj_Srv.GETEDOCTANOM(vs_fil_act, vs_cve_emp, ddlConceptos.SelectedValue, wd_Fec_Ini.ToString("yyyyMMdd"), wd_Fec_Fin.ToString("yyyyMMdd"), ws_importe, vs_emp_act)

                        For wn_num_i = 0 To wa_edo_cta.Length - 1
                            dtCuentas = dsCuentas.Tables(0).NewRow()

                            dtCuentas("Fecha") = wa_edo_cta(wn_num_i).FECHA
                            dtCuentas("Concepto") = wa_edo_cta(wn_num_i).CONCEPTO
                            dtCuentas("Importe") = wa_edo_cta(wn_num_i).IMPORTE
                            dtCuentas("Suma") = wa_edo_cta(wn_num_i).SUMA
                            dsCuentas.Tables(0).Rows.Add(dtCuentas)

                        Next

                        gvEdoCta.DataSource = dsCuentas.Tables(0)
                        gvEdoCta.DataBind()

                        If gvEdoCta.Rows.Count = 0 Then
                            lbMensaje.Text = "No se Encontraron registros con esos parámetros de búsqueda"
                            btnImprimir.Visible = False
                        Else
                            btnImprimir.Visible = True
                            lbMensaje.Text = ""
                        End If

                    Catch ex As Exception
                        lbExcepcion.Text = "ERROR: Funcion btnConsultar_Click() " & ex.Message
                    End Try
                Else
                    Response.Redirect("Login.aspx")
                End If
            Catch ex As Exception
                lbExcepcion.Text = "ERROR: Funcion btnConsultar_Click() " & ex.Message
            End Try


    End Sub


    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLimpiar.Click

        txtFechaInicio.Text = ""
        txtFechaFin.Text = ""
        txtimporte.Text = ""
        ddlConceptos.SelectedValue = " "
        gvEdoCta.DataBind()
    End Sub
End Class
