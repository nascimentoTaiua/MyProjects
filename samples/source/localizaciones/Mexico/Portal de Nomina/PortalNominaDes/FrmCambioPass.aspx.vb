Imports System.Data
Imports System.IO
Imports System.Xml
Partial Class FrmCambioPass
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Me.IsPostBack Then
            Try
                Dim oSrv As New WSPTALNOM.WSPTALNOM()

                Dim cXML As String = ""
                cXML = oSrv.GETFILIAL()
                oSrv.Dispose()
                Dim dsSucursales As New DataSet()
                dsSucursales.ReadXml(New XmlTextReader(New StringReader(cXML)))

                ddlSucursal.DataSource = dsSucursales.Tables(0)
                ddlSucursal.DataTextField = "nombre"
                ddlSucursal.DataValueField = "id"
                ddlSucursal.DataBind()

            Catch ex As Exception
                'Dim lbError As New Label()
                lbError.Text = ex.Message
                'form1.Controls.Add(lbError)
            End Try
        End If
    End Sub


    Protected Sub lnkAceptar_Click(ByVal sender As Object, ByVal e As EventArgs)
        'Dim lbError As New Label()
        Dim lActualizo As Boolean = False

        Dim oSrv As New WSPTALNOM.WSPTALNOM()
        Dim oDatos As New WSPTALNOM.STRTRANSACCION
        Dim aEmpFil() As String
        If txtNewPassword.Text = txtConfirmPassword.Text Then
            aEmpFil = ddlSucursal.SelectedValue.Split("/")
            Try
                oDatos = oSrv.VERIFICARACCESO(txtMatricula.Text, txtPassword.Text, aEmpFil(1), aEmpFil(0))

                If oDatos.ESTATUS = True Then
                    lActualizo = oSrv.CAMBIOPASS(txtMatricula.Text, txtPassword.Text, aEmpFil(1), txtNewPassword.Text, aEmpFil(0))
                    If lActualizo Then
                        Response.Write("<script language='javascript'>alert('Datos actualizados correctamente'); window.location='login.aspx';</script>")
                    Else
                        'Response.Write("Ocurrio un error al tratar de actualizar los datos. Verifique su información y vuelva a intentar.")
                        lbError.Text = "Ocurrio un error al tratar de actualizar los datos. Verifique su información y vuelva a intentar."
                    End If
                Else
                    'Response.Write("Datos incorrectos, favor de verificar.")
                    lbError.Text = "Datos incorrectos, favor de verificar"
                End If
            Catch ex As Exception
                'Response.Write(ex.Message)
                lbError.Text = ex.Message
            End Try
        Else
            'Response.Write("La nueva contraseña no coincide con la confirmación. Verifique sus datos.")
            lbError.Text = "La nueva contraseña no coincide con su confirmación. Verifique sus datos."
        End If
    End Sub

    Protected Sub lnkCancelar_Click(ByVal sender As Object, ByVal e As EventArgs)
        Response.Redirect("Login.aspx")
    End Sub

End Class
