Imports System.Net
Imports System.Net.Mail

Partial Class Empleadosmod
    Inherits System.Web.UI.Page



    Protected Sub Enviar_mail()

        Dim ws_Body As String = String.Empty
        Dim ws_Nom_Emp As String = String.Empty
        Dim ws_e_Mail As String = String.Empty
        Dim ws_Msg As String = String.Empty

        Dim ws_Fil_act As String = String.Empty
        Dim ws_cve_emp As String = String.Empty
        Dim ws_emp_act As String = String.Empty
        Dim ws_prueba As String = String.Empty

        'SSL
        Dim ws_ssl As Boolean = False

        'Manejo de correo
        Dim wx_correo As New MailMessage()
        Dim wx_smtp As New SmtpClient()

        'Objetos para manipulación de datos por Web Service
        Dim wx_obj_Srv As New WSPTALNOM.WSPTALNOM()
        Dim wx_est_envio As New WSPTALNOM.STRDATOSMAIL()


        If Me.User.Identity.IsAuthenticated And Not Session("cve_emp") Is Nothing Then
            Try
                ws_cve_emp = Session("cve_emp")
                ws_Fil_act = Session("fil_act")
                ws_Nom_Emp = Session("nom_emp")
                ws_emp_act = Session("emp_act")

                ws_e_Mail = wx_obj_Srv.GETMAIL(ws_Fil_act, ws_emp_act)
                wx_est_envio = wx_obj_Srv.GETDATOSENVIO(ws_Fil_act, ws_cve_emp, ws_emp_act)

                ws_Body = "Empleado " & ws_cve_emp & "-" & ws_Nom_Emp & "<br/>"
                ws_Body += txtBody.Text

                wx_correo.From = New MailAddress(wx_est_envio.CMAILENVIO)
                wx_correo.To.Add(ws_e_Mail)

                wx_correo.Subject = "Solicitud de Modificaciones de Datos Personales"
                wx_correo.Body = ws_Body
                wx_correo.IsBodyHtml = True
                wx_correo.Priority = MailPriority.Normal

                ' smtp del servidor de envío

                wx_smtp.Host = wx_est_envio.CSMPT
                wx_smtp.Credentials = New NetworkCredential(wx_est_envio.CEMAIL, wx_est_envio.CPASSMAIL)
                'wx_smtp.UseDefaultCredentials = True
                wx_smtp.EnableSsl = wx_obj_Srv.GETSSL(ws_Fil_act, ws_emp_act)


                Try

                    wx_smtp.Send(wx_correo)
                    Response.Write("<script languaje='javascript'>alert('Mensaje enviado satisfactoriamente'); window.location.href=window.location;</script>")

                Catch ex As SmtpException
                    'Response.Write("ERROR:" & ex.Message)
                    lbExcepcion.Text = "Error: Funcion btEnviar_Click() - " & ex.Message
                Catch ex As Exception
                    lbExcepcion.Text = "Error: Funcion btEnviar_Click() - " & ex.Message
                End Try
            Catch ex As Exception
                lbExcepcion.Text = "Error: Funcion btEnviar_Click() - " & ex.Message
            End Try
        Else
            Response.Redirect("Login.aspx")
        End If
    End Sub

    Protected Sub btnEnviar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnEnviar.Click
        Enviar_mail()

    End Sub
End Class
