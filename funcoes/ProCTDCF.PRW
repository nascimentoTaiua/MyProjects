//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
//±±ºPrograma  ³ ProCTDCF º Autor ³ Elvis Siqueira     º Data ³  25/10/23   º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºDesc      ³ Processa conta contabil para cliente e forncedores que nao º±±
//±±º          ³ possuem.                                                   º±±
//±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

User Function ProCTDCF()

Processa({|| FSProcessa()}, "Filtrando registros...")

Return 

Static Function FSProcessa()
Local aAreaSA1	:= SA1->(GetArea())
Local aAreaSA2	:= SA2->(GetArea())
Local aAreaCTD	:= CTD->(GetArea())
Local lMsgCampo := .T.
Local nAtual := 0
Local nTotal := 0 
	
	// Inclusao no Item Contabil. "Cliente"
	DBSelectArea("SA1")
	SA1->(DbSetOrder(1))
	Count To nTotal
    ProcRegua(nTotal)
	SA1->(DBGoTop())

	While SA1->(!Eof())
		
		nAtual++
        IncProc("Processando cliente " + cValToChar(nAtual) + " de " + cValToChar(nTotal) + "...")          
		
		DBSelectArea("CTD")
		CTD->(Dbsetorder(1))
		If ! CTD->(dbSeek(xFilial("CTD")+"C"+Alltrim(SA1->A1_COD)+Alltrim(SA1->A1_LOJA)))
			If RecLock("CTD", .T.)
				CTD->CTD_FILIAL := xFilial("CTD")
				CTD->CTD_ITEM   := "C"+Alltrim(SA1->A1_COD)+Alltrim(SA1->A1_LOJA)
				CTD->CTD_DESC01 := SA1->A1_NOME
				CTD->CTD_CLASSE := "2"
				CTD->CTD_NORMAL := "2"
				CTD->CTD_BLOQ   := "2"
				CTD->CTD_DTEXIS := CtoD("01/01/2000")
				CTD->CTD_ITLP   := CTD->CTD_ITEM
				CTD->CTD_CLOBRG := "2"
				CTD->CTD_ACCLVL := "1"  
				CTD->CTD_BOOK   := "AUTO"
				MsUnlock("CTD")
			EndIf
			If SA1->(FieldPos('A1_XITEMCC')) > 0
				RecLock("SA1",.F.)
					SA1->A1_XITEMCC := CTD->CTD_ITEM
				SA1->(MSUnlock())
			Else
				If lMsgCampo
					FWAlertWarning("Campo A1_XITEMCC não encontrado no dicionário de dados.","Campo A1_XITEMCC")
					lMsgCampo := .F.
				EndIf 
			EndIf
		Else
			If SA1->(FieldPos('A1_XITEMCC')) > 0
				RecLock("SA1",.F.)
					SA1->A1_XITEMCC := CTD->CTD_ITEM
				SA1->(MSUnlock())
			Else
				If lMsgCampo
					FWAlertWarning("Campo A1_XITEMCC não encontrado no dicionário de dados.","Campo A1_XITEMCC")
					lMsgCampo := .F.
				EndIf 
			EndIf 
		EndIF
		
		SA1->(dbSkip())
	EndDo
	
	// Inclusao no Item Contabil. "Fornecedor"
	DBSelectArea("SA2")
	SA2->(DbSetOrder(1))
	Count To nTotal
    ProcRegua(nTotal)
	SA2->(DBGoTop())
	nAtual := 0
	lMsgCampo := .T.

	While SA2->(!Eof())

		nAtual++
        IncProc("Processando fornecedor " + cValToChar(nAtual) + " de " + cValToChar(nTotal) + "...")  
		
		DBSelectArea("CTD")
		CTD->(dbSetOrder(1))
		If ! CTD->(dbSeek(xFilial("CTD")+"F"+Alltrim(SA2->A2_COD)+Alltrim(SA2->A2_LOJA)))
			If RecLock("CTD", .T.)
				CTD->CTD_FILIAL := xFilial("CTD")
				CTD->CTD_ITEM   := "F"+Alltrim(SA2->A2_COD)+Alltrim(SA2->A2_LOJA)
				CTD->CTD_DESC01 := SA2->A2_NOME
				CTD->CTD_CLASSE := "2"
				CTD->CTD_NORMAL := "1"
				CTD->CTD_BLOQ   := "2"
				CTD->CTD_DTEXIS := CtoD("01/01/2000")
				CTD->CTD_ITLP   := CTD->CTD_ITEM
				CTD->CTD_CLOBRG := "2"
				CTD->CTD_ACCLVL := "1"  
				CTD->CTD_BOOK   := "AUTO"
				MsUnlock("CTD")
			If SA2->(FieldPos('A2_XITEMCC')) > 0
				RecLock("SA2",.F.)
					SA2->A2_XITEMCC := CTD->CTD_ITEM
				SA2->(MSUnlock())
			Else
				If lMsgCampo
					FWAlertWarning("Campo A2_XITEMCC não encontrado no dicionário de dados.","Campo A2_XITEMCC")
					lMsgCampo := .F.
				EndIf 
			EndIf
			EndIf
			If SA2->(FieldPos('A2_XITEMCC')) > 0
				RecLock("SA2",.F.)
					SA2->A2_XITEMCC := CTD->CTD_ITEM
				SA2->(MSUnlock())
			Else
				If lMsgCampo
					FWAlertWarning("Campo A2_XITEMCC não encontrado no dicionário de dados.","Campo A2_XITEMCC")
					lMsgCampo := .F.
				EndIf 
			EndIf
		EndIf
	           
		SA2->(dbSkip())
	EndDo

RestArea(aAreaSA1)
RestArea(aAreaSA2)
RestArea(aAreaCTD)

FWAlertSuccess('PROCTDCF - Processo concluido.')

Return
