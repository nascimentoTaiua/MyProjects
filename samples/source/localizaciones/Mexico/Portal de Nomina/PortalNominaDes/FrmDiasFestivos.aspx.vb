Imports System.Data
Partial Class FrmDiasFestivos
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load


        obtener_dias()


    End Sub

    Protected Sub obtener_dias()
        Dim wx_obj_Srv As New WSPTALNOM.WSPTALNOM()
        Dim wa_arr_df() As WSPTALNOM.STRDIASFES
        Dim wn_num_i As Integer = 0
        Dim ws_fil_act As String = String.Empty
        Dim dsDiasFestivos As New DataSet()
        Dim drDiasFestivos As DataRow

        Dim ws_emp_act As String = String.Empty

        If Me.User.Identity.IsAuthenticated And Not Session("cve_emp") Is Nothing Then

            ws_fil_act = Session("fil_act")
            ws_emp_act = Session("emp_act")

            Try
                wa_arr_df = wx_obj_Srv.GETDIASFEST(ws_fil_act, ws_emp_act)

                dsDiasFestivos.Tables.Add("Dias_festivos")
                dsDiasFestivos.Tables(0).Columns.Add("Fecha", GetType(String))
                dsDiasFestivos.Tables(0).Columns.Add("Descripción", GetType(String))

                For wn_num_i = 0 To wa_arr_df.Length - 1
                    drDiasFestivos = dsDiasFestivos.Tables(0).NewRow()

                    drDiasFestivos("Fecha") = wa_arr_df(wn_num_i).FECHA
                    drDiasFestivos("Descripción") = wa_arr_df(wn_num_i).DESCRIPCION

                    dsDiasFestivos.Tables(0).Rows.Add(drDiasFestivos)

                Next

                gvDiasFestivos.DataSource = dsDiasFestivos
                gvDiasFestivos.DataBind()

            Catch ex As Exception
                lbExcepcion.Text = "ERROR: Funcion obtener_dias() - " & ex.Message
            End Try
        Else
            Response.Redirect("Login.aspx")
        End If
    End Sub

    Protected Sub gvDiasFestivos_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvDiasFestivos.RowDataBound
        'Dim ws_aux As String = String.Empty

        'If e.Row.Cells(0).Text <> "&nbsp;" And e.Row.Cells(0).Text.ToUpper() <> "FECHA" Then
        '    ws_aux = e.Row.Cells(0).Text.Substring(6, 2) & "/"
        '    ws_aux += e.Row.Cells(0).Text.Substring(4, 2) & "/"
        '    ws_aux += e.Row.Cells(0).Text.Substring(2, 2)
        '    e.Row.Cells(0).Text = ws_aux
        'End If
    End Sub
End Class
