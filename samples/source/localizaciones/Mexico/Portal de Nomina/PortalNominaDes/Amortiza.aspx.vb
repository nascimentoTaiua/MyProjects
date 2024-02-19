Imports System.Data
Partial Class Amortiza
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Obtener_ExtAmor()
        btnImpAmor.Attributes.Add("OnClick", "window.print();")
        BtnCerrar.Attributes.Add("OnClick", "window.close();")

    End Sub
    Private Sub Obtener_ExtAmor()

        Dim wx_obj_Srv As New WSPTALNOM.WSPTALNOM()
        Dim wx_est_Amo As New WSPTALNOM.STRUAMORTIZ()
        Dim wa_arr_Amo() As WSPTALNOM.STRUAMORTIZ

        Dim ws_id_num As String

        Dim ws_fil_act As String = String.Empty
        Dim ws_cve_emp As String = String.Empty
        Dim ws_emp_act As String = String.Empty
        Dim wn_num_i As Integer = 0

        Dim dsEdoAmo As New DataSet()
        Dim dtEdoAmo As DataRow

        dsEdoAmo.Tables.Add("Amortizaciones")

        dsEdoAmo.Tables(0).Columns.Add("Concepto", GetType(String))
        dsEdoAmo.Tables(0).Columns.Add("Fecha", GetType(String))
        dsEdoAmo.Tables(0).Columns.Add("Cargo", GetType(String))
        dsEdoAmo.Tables(0).Columns.Add("Abono", GetType(String))
        dsEdoAmo.Tables(0).Columns.Add("Saldo", GetType(String))


        Try

            ws_fil_act = Session("fil_act")
            ws_cve_emp = Session("cve_emp")
            ws_emp_act = Session("emp_act")
            ws_id_num = Request.QueryString("idpre")


            wa_arr_Amo = wx_obj_Srv.GETAMORTIZ(ws_fil_act, ws_cve_emp, ws_id_num, ws_emp_act)

            Lb_amor_tiz.Text = "Movimiento del Préstamo de " & Trim(wa_arr_Amo(0).CDTPAGO)

            For wn_num_i = 0 To wa_arr_Amo.Length - 1
                dtEdoAmo = dsEdoAmo.Tables(0).NewRow()

                dtEdoAmo("Concepto") = wa_arr_Amo(wn_num_i).CPD & "- " & wa_arr_Amo(wn_num_i).CDESC
                dtEdoAmo("Fecha") = wa_arr_Amo(wn_num_i).CDTPAGO
                dtEdoAmo("Cargo") = wa_arr_Amo(wn_num_i).NCARGO
                dtEdoAmo("Abono") = wa_arr_Amo(wn_num_i).NABONO
                dtEdoAmo("Saldo") = wa_arr_Amo(wn_num_i).NVLSALDO
                dsEdoAmo.Tables(0).Rows.Add(dtEdoAmo)


            Next
            If wa_arr_Amo.Length = 0 Then
                Response.Write("No hay movimientos ")
            End If
            gv_amor_tiz.DataSource = dsEdoAmo.Tables(0)
            gv_amor_tiz.DataBind()


        Catch ex As Exception
            'Response.Write("ERROR: Obtener_ExtAmor " + ex.Message)
            lbExcepcion.Text = "ERROR: Funcion Obtener_ExtAmor() - " & ex.Message
        End Try
    End Sub
   

   
    Protected Sub gv_amor_tiz_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gv_amor_tiz.RowDataBound
        Try


            If e.Row.DataItemIndex <> -1 Then
                e.Row.Cells(2).Text = String.Format("{0:C} ", Double.Parse(e.Row.Cells(2).Text))
                e.Row.Cells(3).Text = String.Format("{0:C} ", Double.Parse(e.Row.Cells(3).Text))
                e.Row.Cells(4).Text = String.Format("{0:C} ", Double.Parse(e.Row.Cells(4).Text))
            End If

        Catch ex As Exception
            lbExcepcion.Text = "ERROR: Funcion gv_amor_tiz_RowDataBound() - " & ex.Message
        End Try

    End Sub

    
    
End Class
