Imports System.Data
Imports System.Xml
Imports System.IO

Partial Class _Login
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        obt_filial()
    End Sub

    Protected Sub obt_filial()
        Try
            Dim wx_srv_dato As New WSPTALNOM.WSPTALNOM()

            Dim ws_Xml As String
            Dim wx_dsSucursales As DataSet

            ws_Xml = wx_srv_dato.GETFILIAL()

            wx_dsSucursales = New DataSet()
            wx_dsSucursales.ReadXml(New XmlTextReader(New StringReader(ws_Xml)))
            wx_dsSucursales.WriteXml(Server.MapPath("xml/sucursales.xml"))

            XmlDataSource1.DataFile = Server.MapPath("xml/sucursales.xml")

        Catch ws_str_ex As Exception
            XmlDataSource1.Data = "<FILIALES><FILIAL id ='00' nombre='NO HAY DATOS' /></FILIALES>"

            'Response.Write(ws_str_ex.Message)
            lbExcepcion.Text = ws_str_ex.Message
        End Try
    End Sub

    Protected Sub LinkButton1_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Response.Redirect("FrmCambioPass.aspx")
    End Sub

    Protected Sub Login1_Autenticate(ByVal sender As Object, ByVal e As AuthenticateEventArgs)
        Dim authenticated As Boolean = False
        Dim sucursal As DropDownList = Login1.FindControl("UserFilial")
        Dim aEmpFil() As String

        Login1.DestinationPageUrl = "Home.aspx"
        Try
            Dim wx_obj_srv As New WSPTALNOM.WSPTALNOM()
            Dim wx_est_datos As New WSPTALNOM.STRTRANSACCION()

            aEmpFil = sucursal.SelectedValue.Split("/")
            wx_est_datos = wx_obj_srv.VERIFICARACCESO(Login1.UserName, Login1.Password, aEmpFil(1), aEmpFil(0))

            If wx_est_datos.ESTATUS = True Then
                authenticated = Login(Login1.UserName)

                If authenticated Then
                    Session.Timeout = 60
                    Session("cve_emp") = Login1.UserName
                    Session("fil_act") = aEmpFil(1)
                    Session("nom_emp") = wx_est_datos.NOMBRE
                    Session("emp_act") = aEmpFil(0)
                    Session("nom_empresa") = sucursal.SelectedItem.Text
                Else
                    Login1.FailureText = "Usuario con sesión iniciada."
                End If
                
            End If
            e.Authenticated = authenticated

        Catch ws_str_ex As Exception
            'Response.Write("ERROR:" & ws_str_ex.Message)
            lbExcepcion.Text = "ERROR:" & ws_str_ex.Message
        End Try

    End Sub

    Protected Sub Password_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs)

    End Sub

    Protected Sub UserFilial_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)

    End Sub

    Protected Sub LoginButton_Click(ByVal sender As Object, ByVal e As System.EventArgs)

    End Sub

    Protected Function Login(ByVal userName As String) As Boolean
        Dim d As System.Collections.Generic.List(Of String) = Application("UsersLoggedIn")
        If d IsNot Nothing Then
            SyncLock (d)
                If d.Contains(userName) Then
                    ' User is already logged inNot Not Not 
                    Return False

                End If
                d.Add(userName)
            End SyncLock
            

        End If
        Session("UserLoggedIn") = userName
        Return True

    End Function


End Class