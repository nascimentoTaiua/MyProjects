
Imports System.Xml
Imports System.IO
Imports System.Net
Imports System.Net.Mail
Imports System.Data
Imports System.Data.SqlClient


Partial Class SolicitudPrestamos

    Inherits System.Web.UI.Page

    Public wn_index As Integer = 0
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Me.User.Identity.IsAuthenticated And Not Session("cve_emp") Is Nothing Then
            If Not Me.IsPostBack Then
                Obtener_ConcPres()
                Obtener_SolPre()
            End If

            If lis_sol_pres.Rows.Count <= 0 Then
                btnDel.Enabled = False
            End If
        Else
            Response.Redirect("Login.aspx")
        End If


    End Sub


    Private Sub Obtener_ConcPres()
        'Obtiene los conceptos de Prestamo
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

            wa_arr_con = wx_obj_Srv.GETCONSOLPRE(ws_fil_act, ws_emp_act)

            dsConceptos.Tables.Add("Conceptos")
            dsConceptos.Tables(0).Columns.Add("Codigo", GetType(String))
            dsConceptos.Tables(0).Columns.Add("Descripcion", GetType(String))

            For wn_num_i = 0 To wa_arr_con.Length - 1

                drConceptos = dsConceptos.Tables(0).NewRow()

                drConceptos("Codigo") = wa_arr_con(wn_num_i).CODIGO
                drConceptos("Descripcion") = wa_arr_con(wn_num_i).DESCRIPCION

                dsConceptos.Tables(0).Rows.Add(drConceptos)

            Next

            LisConPres.DataSource = dsConceptos
            LisConPres.DataTextField = "Descripcion"
            LisConPres.DataValueField = "Codigo"
            LisConPres.DataBind()
            lbExcepcion.Text = ""
        Catch ex As Exception
            lbExcepcion.Text = "ERROR Obtener_ConcPres: " + ex.Message
        End Try

    End Sub

    Private Sub Obtener_SolPre()
        'Obtiene las Solicitudes de Prestamos
        Dim wx_obj_Srv As New WSPTALNOM.WSPTALNOM()

        Dim wa_arr_pres() As WSPTALNOM.STRUSOLPRES
        Dim wn_num_i As Integer = 0
        Dim dsSolicitudes As New DataSet()
        Dim dtSolicitud As DataRow
        Dim ws_cve_mat As String
        Dim ws_fil_act As String
        Dim ws_emp_act As String

        ws_fil_act = Session("fil_act")
        ws_cve_mat = Session("cve_Emp")
        ws_emp_act = Session("emp_act")

        'Genera la lista de solicitudes de prestamo

        dsSolicitudes.Tables.Add("Solicitudes")

        dsSolicitudes.Tables(0).Columns.Add("RECNO", GetType(String))
        dsSolicitudes.Tables(0).Columns.Add("Solicitud", GetType(String))
        dsSolicitudes.Tables(0).Columns.Add("Concepto", GetType(String))
        dsSolicitudes.Tables(0).Columns.Add("Importe", GetType(String))
        dsSolicitudes.Tables(0).Columns.Add("cStatus", GetType(String))
        dsSolicitudes.Tables(0).Columns.Add("Status", GetType(String))
        dsSolicitudes.Tables(0).Columns.Add("Respondido", GetType(String))
        dsSolicitudes.Tables(0).Columns.Add("Motivo", GetType(String))

        Try

            wa_arr_pres = wx_obj_Srv.GETSOLPRES(ws_fil_act, ws_cve_mat, ws_emp_act)

            For wn_num_i = 0 To wa_arr_pres.Length - 1
                dtSolicitud = dsSolicitudes.Tables(0).NewRow()

                dtSolicitud("RECNO") = wa_arr_pres(wn_num_i).NRECNO
                dtSolicitud("Solicitud") = wa_arr_pres(wn_num_i).SFECSOL
                dtSolicitud("Concepto") = wa_arr_pres(wn_num_i).CDESPD
                dtSolicitud("Importe") = wa_arr_pres(wn_num_i).NIMPORTE
                dtSolicitud("cStatus") = wa_arr_pres(wn_num_i).CSTATUS
                dtSolicitud("Status") = wa_arr_pres(wn_num_i).CDESSTAT
                dtSolicitud("Respondido") = wa_arr_pres(wn_num_i).SFECRES
                dtSolicitud("Motivo") = wa_arr_pres(wn_num_i).CMOTREC
                dsSolicitudes.Tables(0).Rows.Add(dtSolicitud)
            Next

            lis_sol_pres.DataSource = dsSolicitudes.Tables(0)
            lis_sol_pres.DataBind()
            lbExcepcion.Text = ""

            If lis_sol_pres.Rows.Count > 0 Then
                btnDel.Visible = True
            Else
                btnDel.Visible = False
            End If
        Catch ex As Exception
            'Response.Write("ERROR Obtener_SolPre: " + ex.Message)
            lbExcepcion.Text = "ERROR Obtener_SolPre: " + ex.Message
        End Try

    End Sub
   
    Protected Sub lis_sol_pres_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles lis_sol_pres.RowDataBound
        'Da los formatos y acciones necesarias a cada columna de cada renglon
        'Dim ws_txt_acc As String
        If wn_index <> e.Row.RowIndex Then
            wn_index = e.Row.RowIndex
            Try

                e.Row.Cells(1).Visible = False 'recno
                e.Row.Cells(8).Visible = False 'Motivo
                e.Row.Cells(5).Visible = False 'status
                If e.Row.DataItemIndex <> -1 Then
                    e.Row.Cells(4).Text = String.Format("{0:C} ", Double.Parse(e.Row.Cells(4).Text))
                End If
                If e.Row.RowType = DataControlRowType.DataRow Then
                    If e.Row.Cells(5).Text.ToUpper() = "2" Then
                        e.Row.Cells(6).Text = "<a href='#'>RECHAZADA</a>"

                        e.Row.Cells(6).Attributes.Add("onClick", "toggleDiv(1,'" & e.Row.Cells(8).Text & "');")

                    End If
                End If
            Catch ex As Exception
                Response.Write("ERROR lis_sol_pres_RowDataBound: " + ex.Message)
            End Try
        End If
    End Sub

    Protected Sub enviar_mail()
        'Envia la Solicitud de prestamo por correo y la guarda
        Dim ws_Body As String = String.Empty
        Dim ws_Nom_Emp As String = String.Empty
        Dim ws_e_Mail As String = String.Empty
        Dim ws_Msg As String = String.Empty
        Dim ws_Subject As String = String.Empty
        Dim ws_fil_act As String = String.Empty
        Dim ws_cve_emp As String = String.Empty
        Dim ws_emp_act As String = String.Empty



        'Objetos para manipulacion de datos obtenidos de web services
        Dim wx_obj_Srv As New WSPTALNOM.WSPTALNOM()
        Dim wx_est_envio As New WSPTALNOM.STRDATOSMAIL 'estructura con los datos de envío
        Dim wx_est_Sol As New WSPTALNOM.STSOLPRE      'envío de solicitud

        'objetos para envio de email
        Dim wx_correo As New MailMessage()
        Dim wx_smtp As New SmtpClient()


        If Me.User.Identity.IsAuthenticated Then  'CAMBIAR AL PROBAR SELECCIONANDO UN USUARIO
            Try
                ws_Subject = "Solicitud de Prestamo"
                ws_fil_act = Session("fil_act")
                ws_cve_emp = Session("cve_emp")
                ws_Nom_Emp = Session("nom_emp")
                ws_emp_act = Session("emp_act")

                ' Obtenemos datos de envío de los webservices de protheus

                wx_est_Sol = wx_obj_Srv.SETSOLPRES(ws_fil_act, ws_cve_emp, LisConPres.SelectedValue, tx_imp_pres.Text, ws_emp_act)

                If wx_est_Sol.INSERTADO Then
                    ws_e_Mail = wx_obj_Srv.GETMAILSUPERVISOR(ws_fil_act, ws_cve_emp, ws_emp_act)
                    wx_est_envio = wx_obj_Srv.GETDATOSENVIO(ws_fil_act, ws_cve_emp, ws_emp_act)

                    If Trim(wx_est_envio.CMAILENVIO) <> "" And Trim(ws_e_Mail) <> "" Then

                        ws_Nom_Emp = ws_Nom_Emp
                        ws_Body = "<div style='font-family: arial; font-size: 12px;'>"
                        ws_Body += "<p>Empleado " & ws_cve_emp
                        ws_Body += "-"
                        ws_Body += ws_Nom_Emp & "</p>"

                        ws_Body += "<p>Solicita el prestamo :" & "</p>"

                        ws_Body += "<span style='padding-left: 35px;'>Concepto : " & LisConPres.SelectedItem.Value & "- " & LisConPres.SelectedItem.Text & "</span>"
                        ws_Body += "<br/>"
                        ws_Body += "<span style='padding-left: 35px;'>  Importe : " & String.Format("{0:C} ", Double.Parse(tx_imp_pres.Text)) & "</span>"
                        ws_Body += "<br/>"
                        ws_Body += "</div>"

                        wx_correo.From = New MailAddress(wx_est_envio.CMAILENVIO)

                        wx_correo.To.Add(ws_e_Mail)
                        wx_correo.Subject = "Solicitud de Prestamo"
                        wx_correo.Body = ws_Body
                        wx_correo.IsBodyHtml = True
                        wx_correo.Priority = MailPriority.Normal

                        ' smtp del servidor de envío
                        wx_smtp.Host = wx_est_envio.CSMPT
                        wx_smtp.Credentials = New NetworkCredential(wx_est_envio.CEMAIL, wx_est_envio.CPASSMAIL)

                        Try
                            wx_smtp.Send(wx_correo)
                            Response.Write("<script languaje='javascript'>alert('Mensaje enviado satisfactoriamente'); window.location.href=window.location;</script>")
                        Catch ex As SmtpException
                            lbExcepcion.Text = "ERROR: Funcion btnEnvSolPre_Click() - " & ex.Message
                        Catch ex As Exception
                            lbExcepcion.Text = "ERROR: Funcion btnEnvSolPre_Click() - " & ex.Message
                        End Try
                    Else
                        Response.Write("<script languaje='javascript'>alert('No se envio Mensaje. Falta correo electronico'); window.location.href=window.location;</script>")
                    End If
                    tx_imp_pres.Text = " "
                    lbExcepcion.Text = " "
                Else
                    lbExcepcion.Text = wx_est_Sol.MENSAJE
                End If

            Catch ex As Exception
                lbExcepcion.Text = "ERROR: Funcion enviar_mail() - " & ex.Message
            End Try
        Else
            Response.Redirect("Login.aspx")
        End If
    End Sub

  
    Protected Sub lis_sol_pres_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles lis_sol_pres.SelectedIndexChanged

    End Sub

   
    Protected Sub lis_sol_pres_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles lis_sol_pres.PageIndexChanging
        lis_sol_pres.PageIndex = e.NewPageIndex
        Obtener_SolPre()
    End Sub

    Protected Sub btnEnvSolPres2_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnEnvSolPres2.Click
        'Envia la Solicitud de prestamo por correo y la guarda
        Dim ws_Body As String = String.Empty
        Dim ws_Nom_Emp As String = String.Empty
        Dim ws_e_Mail As String = String.Empty
        Dim ws_Msg As String = String.Empty
        Dim ws_Subject As String = String.Empty
        Dim ws_fil_act As String = String.Empty
        Dim ws_cve_emp As String = String.Empty
        Dim ws_emp_act As String = String.Empty



        'Objetos para manipulacion de datos obtenidos de web services
        Dim wx_obj_Srv As New WSPTALNOM.WSPTALNOM()
        Dim wx_est_envio As New WSPTALNOM.STRDATOSMAIL 'estructura con los datos de envío
        Dim wx_est_Sol As New WSPTALNOM.STSOLPRE      'envío de solicitud

        'objetos para envio de email
        Dim wx_correo As New MailMessage()
        Dim wx_smtp As New SmtpClient()


        If Me.User.Identity.IsAuthenticated Then  'CAMBIAR AL PROBAR SELECCIONANDO UN USUARIO
            Try
                ws_Subject = "Solicitud de Prestamo"
                ws_fil_act = Session("fil_act")
                ws_cve_emp = Session("cve_emp")
                ws_Nom_Emp = Session("nom_emp")
                ws_emp_act = Session("emp_act")

                ' Obtenemos datos de envío de los webservices de protheus

                wx_est_Sol = wx_obj_Srv.SETSOLPRES(ws_fil_act, ws_cve_emp, LisConPres.SelectedValue, tx_imp_pres.Text, ws_emp_act)

                If wx_est_Sol.INSERTADO Then
                    ws_e_Mail = wx_obj_Srv.GETMAILSUPERVISOR(ws_fil_act, ws_cve_emp, ws_emp_act)
                    wx_est_envio = wx_obj_Srv.GETDATOSENVIO(ws_fil_act, ws_cve_emp, ws_emp_act)

                    If Trim(wx_est_envio.CMAILENVIO) <> "" And Trim(ws_e_Mail) <> "" Then

                        ws_Nom_Emp = ws_Nom_Emp
                        ws_Body = "<div style='font-family: arial; font-size: 12px;'>"
                        ws_Body += "<p>Empleado " & ws_cve_emp
                        ws_Body += "-"
                        ws_Body += ws_Nom_Emp & "</p>"

                        ws_Body += "<p>Solicita el prestamo :" & "</p>"

                        ws_Body += "<span style='padding-left: 35px;'>Concepto : " & LisConPres.SelectedItem.Value & "- " & LisConPres.SelectedItem.Text & "</span>"
                        ws_Body += "<br/>"
                        ws_Body += "<span style='padding-left: 35px;'>  Importe : " & String.Format("{0:C} ", Decimal.Parse(tx_imp_pres.Text)) & "</span>"
                        ws_Body += "<br/>"
                        ws_Body += "</div>"

                        wx_correo.From = New MailAddress(wx_est_envio.CMAILENVIO)

                        wx_correo.To.Add(ws_e_Mail)
                        wx_correo.Subject = "Solicitud de Prestamo"
                        wx_correo.Body = ws_Body
                        wx_correo.IsBodyHtml = True
                        wx_correo.Priority = MailPriority.Normal

                        ' smtp del servidor de envío
                        wx_smtp.Host = wx_est_envio.CSMPT
                        wx_smtp.Credentials = New NetworkCredential(wx_est_envio.CEMAIL, wx_est_envio.CPASSMAIL)
                        wx_smtp.EnableSsl = wx_obj_Srv.GETSSL(ws_fil_act, ws_emp_act)

                        Try
                            wx_smtp.Send(wx_correo)
                            Response.Write("<script languaje='javascript'>alert('Mensaje enviado satisfactoriamente'); window.location=window.location;</script>")
                        Catch ex As SmtpException
                            lbExcepcion.Text = "ERROR: Funcion btnEnvSolPre_Click() - " & ex.Message
                        Catch ex As Exception
                            lbExcepcion.Text = "ERROR: Funcion btnEnvSolPre_Click() - " & ex.Message
                            lbExcepcion.Visible = True
                        End Try
                    Else
                        Response.Write("<script languaje='javascript'>alert('No se envio Mensaje. Falta correo electronico'); window.location=window.location;</script>")
                    End If
                    tx_imp_pres.Text = " "
                    lbExcepcion.Text = " "
                Else
                    lbExcepcion.Text = wx_est_Sol.MENSAJE
                End If

            Catch ex As Exception
                lbExcepcion.Text = "ERROR: Funcion enviar_mail() - " & ex.Message
            End Try
        Else
            Response.Redirect("Login.aspx")
        End If
    End Sub

    Protected Sub btnDel_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDel.Click
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
        Dim ws_emp_act As String

        'objetos para envio de email
        Dim wx_correo As New MailMessage()
        Dim wx_smtp As New SmtpClient()

        'Objetos para manipulacion de datos obtenidos de web services
        Dim wx_obj_Srv As New WSPTALNOM.WSPTALNOM()
        Dim wx_est_envio As New WSPTALNOM.STRDATOSMAIL                          'estructura con los datos de envío
        Dim wx_est_Sol As New WSPTALNOM.STSOLPRE        'envío de solicitud

        If Me.User.Identity.IsAuthenticated And Not Session("cve_emp") Is Nothing Then
            ws_fil_act = Session("fil_act")
            ws_cve_emp = Session("cve_emp")
            ws_Nom_Emp = Session("nom_emp")
            ws_emp_act = Session("emp_act")

            ws_enc_mail = "Empleado " & ws_cve_emp & "-" & ws_Nom_Emp & "<br />"
            ws_det_mail += " </br>"
            ws_det_mail = "Canceló las Siguientes Solicitudes de Prestamo : </br>"
            ws_det_mail += " </br>"
            ws_det_mail += "<table>"
            ws_det_mail += "<tr><th>Solicitud   </th><th>Concepto   </th><th>Importe   </th></tr>"

            For Each dgi As GridViewRow In lis_sol_pres.Rows
                chkSelected = DirectCast(dgi.FindControl("chkActive"), CheckBox)
                If chkSelected.Checked = True Then
                    If dgi.Cells(5).Text.Trim.Length = 0 Then
                        wb_sol_pen = True
                        ws_det_mail += "<tr>"
                        ws_det_mail += "<td>" & dgi.Cells(2).Text & "</td>"
                        ws_det_mail += "<td>" & "   " & dgi.Cells(3).Text & "</td>"
                        ws_det_mail += "<td>" & "   " & dgi.Cells(4).Text & "</td>"
                        ws_det_mail += "</tr>"
                    End If

                    ws_rec_num += dgi.Cells(1).Text & ","
                End If

            Next

            ws_det_mail += "</table>"
            ws_rec_num = ws_rec_num.Substring(0, ws_rec_num.Length - 1)

            Try
                If wx_obj_Srv.DELSOLPRE(ws_rec_num, ws_fil_act, ws_emp_act) Then

                    Response.Write("<script languaje='javascript'>alert('Solicitudes Eliminadas');window.location=window.location;</script>")

                End If

                If wb_sol_pen Then
                    ws_Body = ws_enc_mail & ws_det_mail
                    Try
                        wx_est_envio = wx_obj_Srv.GETDATOSENVIO(ws_fil_act, ws_cve_emp, ws_emp_act)
                        ws_mail_sup = wx_obj_Srv.GETMAILSUPERVISOR(ws_fil_act, ws_cve_emp, ws_emp_act)

                        If ws_mail_sup <> "" And wx_est_envio.CMAILENVIO <> "" Then

                            wx_correo.From = New MailAddress(wx_est_envio.CMAILENVIO)

                            wx_correo.To.Add(ws_mail_sup)
                            wx_correo.Subject = "Cancelación de Solicitud de Prestamos"
                            wx_correo.Body = ws_Body
                            wx_correo.IsBodyHtml = True
                            wx_correo.Priority = MailPriority.Normal

                            ' smtp del servidor de envío
                            wx_smtp.Host = wx_est_envio.CSMPT
                            wx_smtp.Credentials = New NetworkCredential(wx_est_envio.CEMAIL, wx_est_envio.CPASSMAIL)

                            Try
                                wx_smtp.Send(wx_correo)
                                Response.Write("<script languaje='javascript'>alert('Mensaje enviado satisfactoriamente'); window.location.href=window.location;</script>")

                            Catch ex As SmtpException
                                lbExcepcion.Text = ex.Message
                            Catch ex As Exception
                                lbExcepcion.Text = ex.Message
                            End Try
                        End If

                    Catch ex As Exception
                        lbExcepcion.Text = ex.Message
                    End Try

                End If
            Catch ex As Exception
                lbExcepcion.Text = ex.Message
            End Try

        Else
            Response.Redirect("Login.aspx")
        End If
    End Sub
End Class
