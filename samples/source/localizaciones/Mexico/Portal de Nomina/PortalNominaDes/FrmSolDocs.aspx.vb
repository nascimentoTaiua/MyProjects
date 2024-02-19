
Imports System.Xml
Imports System.IO
Imports System.Net
Imports System.Net.Mail
Imports System.Data
Imports System.Data.SqlClient


Partial Class FrmSolDocumentos

    Inherits System.Web.UI.Page

    Public vn_gv_ind As Integer = 0
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Me.User.Identity.IsAuthenticated And Not Session("cve_emp") Is Nothing Then
            If Not Me.IsPostBack Then
                Obtener_TiposSolicitud()
                Obtener_SolDoc()
            End If

            If lis_sol_doc.Rows.Count > 0 Then
                btnEliSolDoc.Visible = True
            Else
                btnEliSolDoc.Visible = False
            End If
        Else
            Response.Redirect("Login.aspx")
        End If

    End Sub


    Private Sub Obtener_TiposSolicitud()
        'Obtiene los tipos de documentos

        Dim ws_rst_emp As New DataSet()
        Dim ws_str_qry As String = String.Empty
        Dim wx_rdo_rst As String = String.Empty
        Dim ws_nom_tab As String = String.Empty

        Dim wx_obj_Srv As New WSPTALNOM.WSPTALNOM()
        Dim ws_fil_ial As New WSPTALNOM.WSPTALNOM()
        Dim wa_arr_tdoc() As WSPTALNOM.STRTIPDOC
        Dim wn_num_i As Integer

        Dim ws_fil_act As String
        Dim ws_cve_mat As String
        Dim ws_emp_act As String
        Dim dsTipdoc As New DataSet()
        Dim dtTipdoc As DataRow

        Try

            ws_fil_act = Session("fil_act")
            ws_cve_mat = Session("cve_emp")
            ws_emp_act = Session("emp_act")

            dsTipdoc.Tables.Add("Tipos de documentos")

            dsTipdoc.Tables(0).Columns.Add("Cod", GetType(String))
            dsTipdoc.Tables(0).Columns.Add("Desc", GetType(String))

            wa_arr_tdoc = wx_obj_Srv.GETTIPDOC(ws_fil_act, ws_emp_act)

            For wn_num_i = 0 To wa_arr_tdoc.Length - 1
                dtTipdoc = dsTipdoc.Tables(0).NewRow()

                dtTipdoc("Cod") = wa_arr_tdoc(wn_num_i).CCODSX5
                dtTipdoc("Desc") = wa_arr_tdoc(wn_num_i).CDESCSX5


                dsTipdoc.Tables(0).Rows.Add(dtTipdoc)
            Next
            LisDocums.DataSource = dsTipdoc.Tables(0)
            LisDocums.DataTextField = "Desc"
            LisDocums.DataValueField = "Cod"
            LisDocums.DataBind()

        Catch ex As Exception
            Response.Write("ERROR Obtener_TiposSolicitud: " + ex.Message)
        End Try

    End Sub
    Private Sub Obtener_SolDoc()
        'Obtiene las Solicitudes de documentos
        Dim wx_obj_Srv As New WSPTALNOM.WSPTALNOM()

        Dim wa_arr_doc() As WSPTALNOM.STRUSOLDOC

        Dim wn_num_i As Integer = 0
        Dim dsSolicitudes As New DataSet()
        Dim dtSolicitud As DataRow
        Dim ws_cve_mat As String
        Dim ws_fil_act As String
        Dim ws_emp_act As String

        ws_fil_act = Session("fil_act")
        ws_cve_mat = Session("cve_emp")
        ws_emp_act = Session("emp_act")

        'Genera la lista de solicitudes de documentos

        dsSolicitudes.Tables.Add("Solicitudes")

        dsSolicitudes.Tables(0).Columns.Add("RECNO", GetType(String))
        dsSolicitudes.Tables(0).Columns.Add("Solicitud", GetType(String))
        dsSolicitudes.Tables(0).Columns.Add("Documento", GetType(String))
        dsSolicitudes.Tables(0).Columns.Add("Interesado", GetType(String))
        Try

            wa_arr_doc = wx_obj_Srv.GETSOLDOC(ws_fil_act, ws_cve_mat, ws_emp_act)


            For wn_num_i = 0 To wa_arr_doc.Length - 1
                dtSolicitud = dsSolicitudes.Tables(0).NewRow()

                dtSolicitud("RECNO") = wa_arr_doc(wn_num_i).NRECNO
                dtSolicitud("Solicitud") = wa_arr_doc(wn_num_i).SFECSOL
                dtSolicitud("Documento") = wa_arr_doc(wn_num_i).CDOCTO
                dtSolicitud("Interesado") = wa_arr_doc(wn_num_i).CINTERE
                dsSolicitudes.Tables(0).Rows.Add(dtSolicitud)
            Next
            lis_sol_doc.DataSource = dsSolicitudes.Tables(0)
            lis_sol_doc.DataBind()
        Catch ex As Exception
            Response.Write("ERROR Obtener_SolDoc: " + ex.Message)
        End Try

    End Sub


    Protected Sub lis_sol_doc_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles lis_sol_doc.RowDataBound
        'Da los formatos y acciones necesarias a cada columna de cada renglon
        If e.Row.RowIndex <> vn_gv_ind Then
            vn_gv_ind = e.Row.RowIndex
            Try
                e.Row.Cells(1).Visible = False 'recno

            Catch ex As Exception
                Response.Write("ERROR lis_sol_doc_RowDataBound: " + ex.Message)
            End Try
        End If

    End Sub

    Protected Sub SOL_DOC()
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
        Dim wx_est_Sol As New WSPTALNOM.STSOLDOC        'envío de solicitud

        If Me.User.Identity.IsAuthenticated And Not Session("cve_emp") Is Nothing Then
            ws_fil_act = Session("fil_act")
            ws_cve_emp = Session("cve_emp")
            ws_Nom_Emp = Session("nom_emp")
            ws_emp_act = Session("emp_act")

            ws_enc_mail = "Empleado " & ws_cve_emp & "-" & ws_Nom_Emp & "<br />"
            ws_det_mail += " </br>"
            ws_det_mail = "Canceló las Siguientes Solicitudes de Documentos : </br>"
            ws_det_mail += " </br>"
            ws_det_mail += "<table>"
            ws_det_mail += "<tr><th>Documento   </th><th>Interesado </th></tr>"

            For Each dgi As GridViewRow In lis_sol_doc.Rows
                chkSelected = DirectCast(dgi.FindControl("chkActive"), CheckBox)
                If chkSelected.Checked = True Then

                    wb_sol_pen = True
                    ws_det_mail += "<tr>"
                    ws_det_mail += "<td>" & dgi.Cells(3).Text & "</td>"
                    ws_det_mail += "<td>" & "   " & dgi.Cells(4).Text & "</td>"
                    ws_det_mail += "</tr>"

                    ws_rec_num += dgi.Cells(1).Text & ","

                End If

            Next

            ws_det_mail += "</table>"


            Try
                ws_rec_num = ws_rec_num.Substring(0, ws_rec_num.Length - 1)
                If wx_obj_Srv.DELSOLDOC(ws_rec_num, ws_fil_act, ws_emp_act) Then

                    Response.Write("<script languaje='javascript'>alert('Solicitudes Eliminadas');window.location=window.location;</script>")

                End If

                If wb_sol_pen Then
                    ws_Body = ws_enc_mail & ws_det_mail
                    Try
                        wx_est_envio = wx_obj_Srv.GETDATOSENVIO(ws_fil_act, ws_cve_emp, ws_emp_act)
                        'ws_mail_sup = wx_obj_Srv.GETMAILSUPERVISOR(ws_fil_act, ws_cve_emp, ws_emp_act)
                        ws_mail_sup = ws_e_Mail = wx_obj_Srv.GETMAIL(ws_fil_act, ws_emp_act)

                        If ws_mail_sup <> "" And wx_est_envio.CMAILENVIO <> "" Then

                            wx_correo.From = New MailAddress(wx_est_envio.CMAILENVIO)

                            wx_correo.To.Add(ws_mail_sup)
                            wx_correo.Subject = "Cancelación de Solicitud de Documento"
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
                                Response.Write(ex.Message)
                            Catch ex As Exception
                                Response.Write(ex.Message)
                            End Try
                        End If

                    Catch ex As Exception
                        Response.Write(ex.Message)
                    End Try

                End If
            Catch ex As Exception
                Response.Write(ex.Message)
            End Try

        Else
            Response.Redirect("Login.aspx")
        End If
    End Sub


    
    Protected Sub LisDocums_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)

    End Sub

    
    Protected Sub lis_sol_doc_SelectedIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewSelectEventArgs) Handles lis_sol_doc.SelectedIndexChanging
        lis_sol_doc.PageIndex = e.NewSelectedIndex
        Obtener_SolDoc()
    End Sub

    Protected Sub lis_sol_doc_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles lis_sol_doc.PageIndexChanging
        lis_sol_doc.PageIndex = e.NewPageIndex
        Obtener_SolDoc()
    End Sub

    Protected Sub LinkButton1_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles LinkButton1.Click
        ' SOL_DOC()
        enviar_sol()
    End Sub

    Protected Sub btnEliSolDoc_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnEliSolDoc.Click
        SOL_DOC()
    End Sub

    Protected Sub enviar_sol()
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
        Dim wx_est_Sol As New WSPTALNOM.STSOLDOC      'envío de solicitud

        'objetos para envio de email
        Dim wx_correo As New MailMessage()
        Dim wx_smtp As New SmtpClient()

        If Me.User.Identity.IsAuthenticated And Not Session("cve_emp") Is Nothing Then ' CAMBIAR AL PROBAR SELECCIONANDO UN USUARIO
            Try
                ws_Subject = "Solicitud de Documento"
                ws_fil_act = Session("fil_act")
                ws_cve_emp = Session("cve_emp")
                ws_Nom_Emp = Session("nom_emp")
                ws_emp_act = Session("emp_act")

                ' Obtenemos datos de envío de los webservices de protheus

                wx_est_Sol = wx_obj_Srv.SETSOLDOC(ws_fil_act, ws_cve_emp, LisDocums.SelectedItem.Text, tx_int_ere.Text, ws_emp_act)

                If wx_est_Sol.INSERTADO Then
                    ws_e_Mail = wx_obj_Srv.GETMAIL(ws_fil_act, ws_emp_act)
                    wx_est_envio = wx_obj_Srv.GETDATOSENVIO(ws_fil_act, ws_cve_emp, ws_emp_act)

                    If Trim(wx_est_envio.CMAILENVIO) <> "" And Trim(ws_e_Mail) <> "" Then

                        ws_Nom_Emp = ws_Nom_Emp
                        ws_Body = "<div style='font-family: arial; font-size: 12px;'>"
                        ws_Body += "<p>Empleado " & ws_cve_emp ' Me.User.Identity.Name  CAMBIAR
                        ws_Body += "-"
                        ws_Body += ws_Nom_Emp & "</p>"
                        ws_Body += "<p>Solicita el documento :" & "</p>"
                        ws_Body += "<span style='padding-left: 35px;'>Documento : " & LisDocums.SelectedItem.Text & "</span>"
                        ws_Body += "<br/>"
                        ws_Body += "<span style='padding-left: 35px;'>  Interesado : " & tx_int_ere.Text & "</span>"
                        ws_Body += "<br/>"
                        ws_Body += "</div>"

                        wx_correo.From = New MailAddress(wx_est_envio.CMAILENVIO)

                        wx_correo.To.Add(ws_e_Mail)
                        wx_correo.Subject = "Solicitud de Documento"
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
                            Response.Write(ex.Message)
                        Catch ex As Exception
                            Response.Write(ex.Message)
                        End Try
                    Else
                        Response.Write("<script languaje='javascript'>alert('No se envio Mensaje. Falta correo electronico'); window.location=window.location;</script>")
                    End If
                    tx_int_ere.Text = " "
                Else
                    Response.Write(wx_est_Sol.MENSAJE)
                End If

            Catch ex As Exception
                Response.Write("ERROR  btnEnvSolDoc_Click: " + ex.Message)
            End Try
        Else
            Response.Redirect("Login.aspx")
        End If
    End Sub
End Class
