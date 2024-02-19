Imports System.Xml
Imports System.IO
Imports System.Net
Imports System.Net.Mail
Imports System.Data
Imports System.Data.SqlClient

Partial Class EdoCtaPrestamos
    Inherits System.Web.UI.Page

    Public vn_gv_ind As Integer = 0

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Me.User.Identity.IsAuthenticated And Not Session("cve_emp") Is Nothing Then
            Obtener_ExtPres()
            btnImpPres.Attributes.Add("OnClick", "window.print();")
        Else
            Response.Redirect("Login.aspx")
        End If

    End Sub

    Private Sub Obtener_ExtPres()
        Dim wx_obj_Srv As New WSPTALNOM.WSPTALNOM()
        Dim wx_est_Pres As New WSPTALNOM.STRUEDOPRES()
        Dim wa_arr_Pre() As WSPTALNOM.STRUEDOPRES

        Dim ws_fil_act As String = String.Empty
        Dim ws_cve_emp As String = String.Empty
        Dim ws_emp_act As String = String.Empty
        Dim wn_num_i As Integer = 0

        Dim dsEdoPres As New DataSet()
        Dim dtEdoPres As DataRow

        dsEdoPres.Tables.Add("Prestamos")
        dsEdoPres.Tables(0).Columns.Add("Vlr. Principal", GetType(String))
        dsEdoPres.Tables(0).Columns.Add("Saldo", GetType(String))
        dsEdoPres.Tables(0).Columns.Add("Val. Cuota", GetType(String))
        dsEdoPres.Tables(0).Columns.Add("Inicio", GetType(String))
        dsEdoPres.Tables(0).Columns.Add("Fch. Prox. Venc.", GetType(String))
        dsEdoPres.Tables(0).Columns.Add("No. Cuotas", GetType(String))
        dsEdoPres.Tables(0).Columns.Add("No. Cuotas Pgdas.", GetType(String))
        dsEdoPres.Tables(0).Columns.Add("Situacion", GetType(String))
        dsEdoPres.Tables(0).Columns.Add("ID", GetType(String))

        Try

            ws_fil_act = Session("fil_act")
            ws_cve_emp = Session("cve_emp")
            ws_emp_act = Session("emp_act")

            wa_arr_Pre = wx_obj_Srv.GETEDOPRES(ws_fil_act, ws_cve_emp, ws_emp_act)

            For wn_num_i = 0 To wa_arr_Pre.Length - 1
                dtEdoPres = dsEdoPres.Tables(0).NewRow()
                dtEdoPres("Vlr. Principal") = wa_arr_Pre(wn_num_i).NVALORTOT
                dtEdoPres("Saldo") = wa_arr_Pre(wn_num_i).NSALDOD

                dtEdoPres("Val. Cuota") = wa_arr_Pre(wn_num_i).NVALORPA
                dtEdoPres("Inicio") = wa_arr_Pre(wn_num_i).CINICIO
                dtEdoPres("Fch. Prox. Venc.") = wa_arr_Pre(wn_num_i).CDTVENC
                dtEdoPres("No. Cuotas") = wa_arr_Pre(wn_num_i).NPARCELA
                dtEdoPres("No. Cuotas Pgdas.") = wa_arr_Pre(wn_num_i).NPARPAG
                dtEdoPres("Situacion") = wa_arr_Pre(wn_num_i).CSITUAC
                dtEdoPres("ID") = wa_arr_Pre(wn_num_i).CNUMID

                dsEdoPres.Tables(0).Rows.Add(dtEdoPres)

            Next
          

            gv_cta_pres.DataSource = dsEdoPres.Tables(0)
            gv_cta_pres.DataBind()
            If gv_cta_pres.Rows.Count = 0 Then
                lbMensaje.Text = "No se Encontraron registros..."
            End If
        Catch ex As Exception
            lbExcepcion.Text = "ERROR: Funcion Obtener_ExtPres() - " & ex.Message
        End Try
    End Sub

    Protected Sub gv_cta_pres_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gv_cta_pres.RowDataBound

        Dim ws_txt_acc As String

        If e.Row.RowIndex <> vn_gv_ind Then

            vn_gv_ind = e.Row.RowIndex
            Try
                e.Row.Cells(8).Visible = False


                ws_txt_acc = "<iframe src=\'Amortiza.aspx?idpre=" & e.Row.Cells(8).Text & "\' width=\'460px\'  height=\'190px\' frameborder=\'0\' ></iframe> "

                If e.Row.DataItemIndex <> -1 Then
                    e.Row.Cells(0).Text = String.Format("{0:C} ", Double.Parse(e.Row.Cells(0).Text))
                    e.Row.Cells(1).Text = String.Format("{0:C} ", Double.Parse(e.Row.Cells(1).Text))
                    e.Row.Cells(2).Text = String.Format("{0:C} ", Double.Parse(e.Row.Cells(2).Text))
                    e.Row.Cells(3).Text = "<a href='#'>" + e.Row.Cells(3).Text + "</a>"
                    e.Row.Cells(3).Attributes.Add("onClick", "toggleDiv(1,'" & ws_txt_acc & "');")

                End If

            Catch ex As Exception
                Response.Write("ERROR gv_cta_pres_RowDataBound: " + ex.Message)
            End Try
        End If

    End Sub
   
    Protected Sub gv_cta_pres_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles gv_cta_pres.SelectedIndexChanged

    End Sub
End Class


