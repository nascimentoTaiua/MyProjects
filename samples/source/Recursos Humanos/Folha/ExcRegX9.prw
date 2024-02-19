#INCLUDE "PROTHEUS.CH"
#iNCLUDE 'TBICONN.CH'

/*/{Protheus.doc} ExcRegX9
Rotina que apaga registro indevido na tabela SX9
@type  User Function
@since 20/02/2020
@see 
/*/
User Function ExcRegX9()

	Local aArea := getArea()

	// Se a chamada não ocorrer via Menu, necessário preparar o ambiente
	//PREPARE ENVIRONMENT EMPRESA "T1" FILIAL "D MG 01 " MODULO "GPE"

	DbSelectArea("SX9")
	DbSetOrder(1)

	If DbSeek("RA2")
		While !(Eof()) .And. X9_DOM == "RA2"   
			If X9_CDOM == "RAK" .And. AllTrim(X9_EXPDOM) == "RA2_CALEND" 
				If MsgNoYes("Foi encontrado um relacionamento incorreto entre as tabelas RA2 e RAK, deseja removê-lo?")
					If RecLock("SX9",.F.)
						dbDelete()
						MsUnlock()
						ApMsgInfo("Ajuste realizado com sucesso!") 
					EndIf
				EndIf
			EndIf
			DbSkip()	
		EndDo
	EndIf

	If DbSeek("SRA")
		While !(Eof()) .And. X9_DOM == "SRA"
			If AllTrim(X9_EXPCDOM) == "QB_MATRESP"
				If MsgNoYes("Registro encontrado, deseja prosseguir com o ajuste?")
					If RecLock("SX9",.F.)
						dbDelete()
						MsUnlock()
						ApMsgInfo("Registro excluído com sucesso!") 
					EndIf
				EndIf
			EndIf
			DbSkip()	
		EndDo
	EndIf

RestArea(aArea)

Return
