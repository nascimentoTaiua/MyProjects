
Partial Class ReciboNom
    Inherits System.Web.UI.Page
    Public vs_cve_emp As String
    Public vs_nom_emp As String
    Public vs_fil_act As String
    Public vs_emp_act As String

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        gen_recibo()
    End Sub

    Public Sub gen_recibo()

        Dim ws_cve_per As String = Request.QueryString("per")
        Dim ws_num_pag As String = Request.QueryString("np")
        Dim ws_proc As String = Request.QueryString("pro")
        Dim wx_obj_srv As New WSPTALNOM.WSPTALNOM()
        Dim ws_html As New Literal()
        Dim ws_lRet As Boolean = False
        Dim ws_Ruta As String = ""


        vs_cve_emp = Session("cve_emp")
        vs_fil_act = Session("fil_act")
        vs_emp_act = Session("emp_act")

        If Me.User.Identity.IsAuthenticated And Not Session("cve_emp") Is Nothing Then
            Try
                If ws_cve_per > 201400 Then
                    ws_Ruta = wx_obj_srv.GETRCNOM(vs_fil_act, vs_cve_emp, ws_cve_per, ws_num_pag, vs_emp_act, ws_proc)
                    If ws_Ruta <> "" Then
                        If ws_Ruta <> "Undefined" Then
                            copyFile(ws_Ruta)
                        Else
                            Response.Write("ERROR: El parámetro MV_HTTPPTL no contiene información, contacta al administrador de nomina")
                        End If

                    Else
                        Response.Write("ERROR: No se encuentra información, contacta al administrador de nomina")
                    End If
                Else
                    ws_html.Text = wx_obj_srv.GETRECNOM(vs_fil_act, vs_cve_emp, ws_cve_per, ws_num_pag, vs_emp_act)
                    phRecibo.Controls.Add(ws_html)
                End If
            Catch ex As Exception
                Response.Write("ERROR: PAGE_LOAD() - " & ex.Message)
            End Try
        Else
            Response.Redirect("Login.aspx")
        End If

    End Sub

    Public Sub download(ws_Ruta As String)
        Dim fso = CreateObject("Scripting.FileSystemObject")
        Response.Clear()
        Response.ContentType = "application/Zip"
        Response.AddHeader("Content-disposition", "attachment; filename=" & ws_Ruta)
        Response.WriteFile(ws_Ruta)
        Response.Flush()
        Response.Close()
        'fso.DeleteFile(ws_Ruta)

    End Sub

    Public Sub copyFile(ws_file As String)
       
        Dim fileAddress As String = String.Empty
        Dim file As String = String.Empty

        Try
            Dim fileReader As New System.Net.WebClient()

            fileAddress = ws_file & ".Zip"

            file = fileAddress.Substring(fileAddress.LastIndexOf("/") + 1)

            If Not (System.IO.File.Exists(Server.MapPath("Files") & "\" & file)) Then
                fileReader.DownloadFile(fileAddress, Server.MapPath("Files") & "\" & file)
                download(Server.MapPath("Files") & "\" & file)
            End If

        Catch ex As Exception

        End Try

    End Sub

    Protected Sub lnkBack_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkBack.Click
        Response.Redirect("FrmReciboNomina.aspx")
    End Sub
End Class
