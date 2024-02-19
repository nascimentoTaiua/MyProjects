Imports System.Data
Imports System.Xml
Imports System.IO
Imports System.Net
Imports System.Net.Mail

Partial Class FrmVacaciones
    Inherits System.Web.UI.Page
    Public vs_cve_emp As String
    Public vs_nom_emp As String
    Public vs_fil_act As String
    Public vs_emp_act As String
    Public vn_gv_ind As Integer = 0
    Private Const CHECKED_ITEMS As String = "CheckedItems"

    Private Sub Obtener_Conceptos()
        Try

            Dim wx_obj_Srv As New WSPTALNOM.WSPTALNOM()
            Dim ws_Xml As String = String.Empty
            Dim wx_dsConceptos As New DataSet()

            ws_Xml = wx_obj_Srv.GETCONCEPTOSVAC(vs_fil_act, vs_emp_act)
            wx_obj_Srv.Dispose()
            wx_dsConceptos.ReadXml(New XmlTextReader(New StringReader(ws_Xml)))

            ddlConceptos.DataSource = wx_dsConceptos.Tables(0)
            ddlConceptos.DataTextField = "descripcion"
            ddlConceptos.DataValueField = "codigo"
            ddlConceptos.DataBind()
            lbExcepcion.Text = ""

        Catch ex As Exception
            lbExcepcion.Text = "ERROR: obtener_conceptos() " & ex.Message
        End Try

    End Sub

    Public Sub Obtener_SolVac()
        Dim wx_obj_Srv As New WSPTALNOM.WSPTALNOM()
        Dim wx_est_Vac As New WSPTALNOM.STRVACACIONES()
        Dim wa_arr_Vac() As WSPTALNOM.STRVACACIONES
        Dim ws_fil_act As String = String.Empty
        Dim ws_cve_emp As String = String.Empty
        Dim wn_num_i As Integer = 0

        Dim dsSolicitudes As New DataSet()
        Dim dtSolicitud As DataRow

        dsSolicitudes.Tables.Add("Solicitudes")
        dsSolicitudes.Tables(0).Columns.Add("RECNO", GetType(String))
        dsSolicitudes.Tables(0).Columns.Add("Solicitud", GetType(String))
        dsSolicitudes.Tables(0).Columns.Add("Concepto", GetType(String))
        dsSolicitudes.Tables(0).Columns.Add("Fecha Inicio", GetType(String))
        dsSolicitudes.Tables(0).Columns.Add("Fecha Fin", GetType(String))
        dsSolicitudes.Tables(0).Columns.Add("Estatus", GetType(String))
        dsSolicitudes.Tables(0).Columns.Add("Respondido", GetType(String))
        dsSolicitudes.Tables(0).Columns.Add("Motivo", GetType(String))

        Try

            vs_fil_act = Session("fil_act")
            vs_cve_emp = Session("cve_emp")
            wa_arr_Vac = wx_obj_Srv.GETSOLVAC(vs_fil_act, vs_cve_emp, vs_emp_act)

            For wn_num_i = 0 To wa_arr_Vac.Length - 1
                dtSolicitud = dsSolicitudes.Tables(0).NewRow()

                dtSolicitud("RECNO") = wa_arr_Vac(wn_num_i).RECNUM
                dtSolicitud("Solicitud") = wa_arr_Vac(wn_num_i).FECSOL
                dtSolicitud("Concepto") = wa_arr_Vac(wn_num_i).CONCEPTO
                dtSolicitud("Fecha Inicio") = wa_arr_Vac(wn_num_i).FECINI
                dtSolicitud("Fecha Fin") = wa_arr_Vac(wn_num_i).FECFIN
                dtSolicitud("Estatus") = wa_arr_Vac(wn_num_i).ESTATUS
                dtSolicitud("Respondido") = wa_arr_Vac(wn_num_i).FECRES
                dtSolicitud("Motivo") = wa_arr_Vac(wn_num_i).MOTREC
                dsSolicitudes.Tables(0).Rows.Add(dtSolicitud)

            Next

            gvSolicitudes.DataSource = dsSolicitudes.Tables(0)
            gvSolicitudes.DataBind()
            lbExcepcion.Text = ""
        Catch ex As Exception
            lbExcepcion.Text = "ERROR: obtener_solvac " & ex.Message
        End Try

    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        vs_cve_emp = Session("cve_emp")
        vs_fil_act = Session("fil_act")
        vs_nom_emp = Session("nom_emp")
        vs_emp_act = Session("emp_act")

        If Me.User.Identity.IsAuthenticated And Not Session("cve_emp") Is Nothing Then
            If Not Me.IsPostBack Then
                Obtener_Conceptos()
                Obtener_SolVac()
            End If

            If gvSolicitudes.Rows.Count <= 0 Then
                btnEliminar.Enabled = False
            Else
                btnEliminar.Visible = True
                btnEliminar.Enabled = True
            End If
        Else
            Response.Redirect("Login.aspx")
        End If

    End Sub

    Protected Sub gvSolicitudes_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvSolicitudes.RowDataBound

        If e.Row.RowIndex <> vn_gv_ind Then
            vn_gv_ind = e.Row.RowIndex
            e.Row.Cells(1).Visible = False
            e.Row.Cells(8).Visible = False
            If e.Row.RowType = DataControlRowType.DataRow Then
                If e.Row.Cells(6).Text.ToUpper() = "RECHAZADA" Then
                    e.Row.Cells(6).Text = "<a href='#'>Rechazada</a>"
                    e.Row.Cells(6).Attributes.Add("onClick", "toggleDiv(1,'" & e.Row.Cells(8).Text & "');")
                End If
            End If
        End If

    End Sub


    Protected Sub gvSolicitudes_SelectedIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewSelectEventArgs)
        gvSolicitudes.PageIndex = e.NewSelectedIndex
        Obtener_SolVac()
    End Sub

    Protected Sub gvSolicitudes_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles gvSolicitudes.PageIndexChanging
        RememberOldValues()
        gvSolicitudes.PageIndex = e.NewPageIndex
        Obtener_SolVac()
        RePopulateValues()
    End Sub

    'FUNCIONES PARA MANTENER EL ESTADO DEL CHECKBOX EN EL GRID VIEW
    Private Sub RePopulateValues()
        Dim categoryIDList As ArrayList = DirectCast(Session(CHECKED_ITEMS), ArrayList)

        If categoryIDList IsNot Nothing AndAlso categoryIDList.Count > 0 Then
            For Each row As GridViewRow In gvSolicitudes.Rows
                Dim index As Integer = CInt(gvSolicitudes.DataKeys(row.RowIndex).Value)

                If categoryIDList.Contains(index) Then
                    Dim myCheckBox As CheckBox = DirectCast(row.FindControl("chkActive"), CheckBox)
                    myCheckBox.Checked = True
                End If
            Next

        End If
    End Sub

    Private Sub RememberOldValues()
        Dim categoryIDList As New ArrayList()
        Dim index As Integer = -1
        For Each row As GridViewRow In gvSolicitudes.Rows
            index = Integer.Parse(gvSolicitudes.DataKeys(row.RowIndex).Value.ToString())

            Dim result As Boolean = DirectCast(row.FindControl("chkActive"), CheckBox).Checked

            ' Check in the Session
            If Session(CHECKED_ITEMS) IsNot Nothing Then
                categoryIDList = DirectCast(Session(CHECKED_ITEMS), ArrayList)
            End If

            If result Then
                If Not categoryIDList.Contains(index) Then
                    categoryIDList.Add(index)
                End If
            Else

                categoryIDList.Remove(index)
            End If
        Next

        If categoryIDList IsNot Nothing AndAlso categoryIDList.Count > 0 Then
            Session(CHECKED_ITEMS) = categoryIDList
        End If
    End Sub

          
    Protected Sub LinkButton2_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnEnviar.Click
        Try


            Dim ws_Body As String = String.Empty
            Dim ws_e_Mail As String = String.Empty
            Dim ws_Msg As String = String.Empty
            Dim ws_Subject As String = String.Empty
            Dim ws_Fec_Ini As String = String.Empty
            Dim ws_Fec_Fin As String = String.Empty
            Dim wd_Fec_Ini As DateTime = Convert.ToDateTime(txtFechaInicio.Text)
            Dim wd_Fec_Fin As DateTime = Convert.ToDateTime(txtFechaFin.Text)

            'Objetos para manipulacion de datos obtenidos de web services
            Dim wx_obj_Srv As New WSPTALNOM.WSPTALNOM()
            Dim wx_est_envio As New WSPTALNOM.STRDATOSMAIL 'estructura con los datos de envío
            Dim wx_est_Sol As New WSPTALNOM.STRSOLVAC 'envío de solicitud

            'objetos para envio de email
            Dim wx_correo As New MailMessage()
            Dim wx_smtp As New SmtpClient()

            ws_Fec_Ini = wd_Fec_Ini.ToString("yyyyMMdd")
            ws_Fec_Fin = wd_Fec_Fin.ToString("yyyyMMdd")

            vs_cve_emp = Session("cve_emp")
            vs_fil_act = Session("fil_act")
            vs_nom_emp = Session("nom_emp")
            vs_emp_act = Session("emp_act")

            If Me.User.Identity.IsAuthenticated And Not Session("cve_emp") Is Nothing Then
                Try
                    ws_Subject = "Solicitud de Vacaciones"
                    ' Obtenemos datos de envío de los webservices de protheus

                    wx_est_Sol = wx_obj_Srv.SETSOLVAC(vs_fil_act, vs_cve_emp, ddlConceptos.SelectedValue, ws_Fec_Ini, ws_Fec_Fin, vs_emp_act)

                    If wx_est_Sol.INSERTADO Then
                        ws_e_Mail = wx_obj_Srv.GETMAILSUPERVISOR(vs_fil_act, vs_cve_emp, vs_emp_act)
                        wx_est_envio = wx_obj_Srv.GETDATOSENVIO(vs_fil_act, vs_cve_emp, vs_emp_act)

                        ws_Body = "<div style='font-family: arial; font-size: 12px;'>"
                        ws_Body += "<p>Empleado " & Me.User.Identity.Name
                        ws_Body += "-"
                        ws_Body += vs_nom_emp & "</p>"
                        ws_Body += "<span style='padding-left: 35px;'>Concepto: " & ddlConceptos.SelectedItem.Text & "</span>"
                        ws_Body += "<br/>"
                        ws_Body += "<span style='padding-left: 35px;'>Fecha de inicio: " & wd_Fec_Ini.ToString("dd/MM/yy") & "</span>"
                        ws_Body += "<br/>"
                        ws_Body += "<span style='padding-left: 35px;'>Fecha de Fin: " & wd_Fec_Fin.ToString("dd/MM/yy") & "</span>"
                        ws_Body += "</div>"

                        If Not wx_est_envio.CMAILENVIO.Length.Equals(0) Then
                            wx_correo.From = New MailAddress(wx_est_envio.CMAILENVIO)

                            wx_correo.To.Add(ws_e_Mail)
                            wx_correo.Subject = "Solicitud de Vacaciones"
                            wx_correo.Body = ws_Body
                            wx_correo.IsBodyHtml = True
                            wx_correo.Priority = MailPriority.Normal

                            ' smtp del servidor de envío
                            wx_smtp.Host = wx_est_envio.CSMPT
                            wx_smtp.Credentials = New NetworkCredential(wx_est_envio.CEMAIL, wx_est_envio.CPASSMAIL)
                            'wx_smtp.UseDefaultCredentials = True
                            wx_smtp.EnableSsl = wx_obj_Srv.GETSSL(vs_fil_act, vs_emp_act)

                            Try
                                wx_smtp.Send(wx_correo)
                                Response.Write("<script languaje='javascript'>alert('Mensaje enviado satisfactoriamente'); window.location=window.location;</script>")
                            Catch ex As SmtpException
                                lbExcepcion.Text = "ERROR: Funcion btnEnviar_Click - " & ex.Message
                            Catch ex As Exception
                                lbExcepcion.Text = "ERROR: Funcion btnEnviar_Click - " & ex.Message
                            End Try

                        Else
                            lbExcepcion.Text = "Su dirección de correo no está registrada, contacte a su administrador para verificar su información."
                            lbExcepcion.ForeColor = Drawing.Color.Red
                        End If

                    Else
                        lbExcepcion.Text = wx_est_Sol.MENSAJE
                    End If

                Catch ex As Exception
                    lbExcepcion.Text = "ERROR: Funcion btnEnviar_Click - " & ex.Message
                End Try
            End If
        Catch ex As Exception
            lbExcepcion.Text = "ERROR: Funcion btnEnviar_Click - " & ex.Message
        End Try
    End Sub

    Protected Sub LinkButton1_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnEliminar.Click
        Dim wn_num_i As Integer = 0                                             ' Auxiliar numérico
        Dim Ls_del_rec As New ArrayList()                                       ' Array con los números de registro para eliminación            
        Dim ws_Body As String = String.Empty                                    ' Cuerpo del email 
        Dim ws_enc_mail As String = String.Empty                                ' Encabezado del email
        Dim ws_det_mail As String = String.Empty                                ' Detalle del email
        Dim ws_subject As String = String.Empty                                 ' Asunto del mail
        Dim ws_Nom_Emp As String = String.Empty                                 ' Nombre del empleado
        Dim ws_fil_act As String = String.Empty                                 ' Filial del Empleado
        Dim ws_cve_emp As String = String.Empty                                 ' Clave del empleado 
        Dim ws_e_Mail As String = String.Empty                                  ' Mail del supervisor directo del empleado
        Dim wb_sol_pen As Boolean = False                                       ' True si se van a eliminar solicitudes pendientes
        Dim ws_mail_sup As String = String.Empty                                ' Mail del Supervisor
        Dim chkSelected As CheckBox                                             ' Obtiene el valor de cada checkbox del GridView Solcicitudes
        Dim ws_rec_num As String = String.Empty
        Dim wn_num_ind As Integer = 0
        Dim ws_emp_act As String

        'objetos para envio de email
        Dim wx_correo As New MailMessage()
        Dim wx_smtp As New SmtpClient()

        'Objetos para manipulacion de datos obtenidos de web services
        Dim wx_obj_Srv As New WSPTALNOM.WSPTALNOM()
        Dim wx_est_envio As New WSPTALNOM.STRDATOSMAIL                          'estructura con los datos de envío
        Dim wx_est_Sol As New WSPTALNOM.STRSOLVAC                               'envío de solicitud

        ws_cve_emp = Session("cve_emp")
        ws_fil_act = Session("fil_act")
        ws_Nom_Emp = Session("nom_emp")
        ws_emp_act = Session("emp_act")

        If Me.User.Identity.IsAuthenticated Then

            ws_enc_mail = "Empleado " & ws_cve_emp & "-" & ws_Nom_Emp & "<br />"
            ws_det_mail = "Aviso de Cancelación de las Siguientes Solicitudes </br>"
            ws_det_mail += "<table>"
            ws_det_mail += "<tr><th>Solicitud</th><th>Concepto</th><th>Fecha Inicio</th><th>Fecha Fin</th></tr>"

            For Each dgi As GridViewRow In gvSolicitudes.Rows

                chkSelected = DirectCast(dgi.FindControl("chkActive"), CheckBox)
                If chkSelected.Checked = True Then
                    If dgi.Cells(6).Text.Trim.Length = 0 Then
                        wb_sol_pen = True
                        ws_det_mail += "<tr>"
                        ws_det_mail += "<td>" & dgi.Cells(2).Text & "</td>"
                        ws_det_mail += "<td>" & dgi.Cells(3).Text & "</td>"
                        ws_det_mail += "<td>" & dgi.Cells(4).Text & "</td>"
                        ws_det_mail += "<td>" & dgi.Cells(5).Text & "</td>"
                        ws_det_mail += "</tr>"
                    End If

                    ws_rec_num += dgi.Cells(1).Text & ","
                End If

            Next

            ws_det_mail += "</table>"
            ws_rec_num = ws_rec_num.Substring(0, ws_rec_num.Length - 1)

            Try
                If wx_obj_Srv.DELSOLVAC(ws_fil_act, ws_cve_emp, ws_rec_num, ws_emp_act) Then

                    Response.Write("<script languaje='javascript'>alert('Solicitudes Eliminadas');</script>")

                End If

                If wb_sol_pen Then
                    ws_Body = ws_enc_mail & ws_det_mail
                    Try
                        wx_est_envio = wx_obj_Srv.GETDATOSENVIO(ws_fil_act, ws_cve_emp, ws_emp_act)
                        ws_mail_sup = wx_obj_Srv.GETMAILSUPERVISOR(ws_fil_act, ws_cve_emp, ws_emp_act)

                        wx_correo.From = New MailAddress(wx_est_envio.CEMAIL)

                        wx_correo.To.Add(ws_mail_sup) '"MAYRA.CAMARGO@TOTVS.COM.BR"
                        'wx_correo.To.Add("mayra.camargo@totvs.com.br")
                        wx_correo.Subject = "Cancelación de Solicitud de Vacaciones"
                        wx_correo.Body = ws_Body
                        wx_correo.IsBodyHtml = True
                        wx_correo.Priority = MailPriority.Normal

                        ' smtp del servidor de envío
                        wx_smtp.Host = wx_est_envio.CSMPT
                        wx_smtp.Credentials = New NetworkCredential(wx_est_envio.CEMAIL, wx_est_envio.CPASSMAIL)

                        Try
                            wx_smtp.Send(wx_correo)
                            Response.Write("<script languaje='javascript'>alert('Mensaje enviado satisfactoriamente'); window.location.href=window.location;</script>")
                            lbExcepcion.Text = ""
                        Catch ex As SmtpException
                            Response.Write(ex.Message)
                        Catch ex As Exception
                            lbExcepcion.Text = "ERROR:" & ex.Message
                        End Try

                    Catch ex As Exception
                        lbExcepcion.Text = "ERROR:" & ex.Message
                    End Try

                End If

            Catch ex As Exception
                lbExcepcion.Text = "ERROR:" & ex.Message
            End Try
        Else
            Response.Redirect("Login.aspx")
        End If
    End Sub
End Class
