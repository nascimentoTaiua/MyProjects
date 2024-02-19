#include "rwmake.ch"
#include "topconn.ch
                 
/*/{Protheus.doc} MATA030
Ponto de Entrada em MVC do cadastro de Cliente
@author Totvs S.A.
@since 16/10/2019
@version 1.0
@OBS Para utilizar os pontos de entrada da rotina MATA030 no padrão MVC, altere para .T. o parâmetro MV_MVCSA1.

O ID do modelo da dados da rotina MATA030 é CRMA980, assim sendo, a assinatura da função de usuário deve ser User Function CRMA980().

/*/
User Function CRMA980()
	Local aParam 	:= PARAMIXB
	Local xRet 		:= .T.
	Local oObj 		:= ""
	Local cIdPonto 	:= ""
	Local cIdModel 	:= ""

	If aParam <> NIL
		oObj 	:= aParam[1]
		cIdPonto := aParam[2]
		cIdModel := aParam[3]

		//Após a gravação total do modelo e dentro da transação.
		If cIdPonto =="MODELCOMMITTTS"
			xRet	:=	Nil
			//Inclusão da Item Contábil
			sfSetCTD(oObj)
		EndIf
	EndIf
Return(xRet)  

//==================================================================================================
Static Function sfSetCTD(mvModel)
	Local liRec		:=	.F.
	Local oModelSA1 := mvModel:GetModel( 'SA1MASTER' )
	Local aAreaSA1	:= SA1->(GetArea())
	Local aAreaCTD	:= CTD->(GetArea())

	If mvModel:GetOperation() == 3 .Or. mvModel:GetOperation() == 4

		DbSelectArea("CTD")
		CTD->(DbSetOrder(1))

		If !(CTD->(DbSeek(xFilial("CTD")+"C"+oModelSA1:GetValue('A1_COD')+oModelSA1:GetValue('A1_LOJA'))))

			liRec	:=	RecLock("CTD",.T.)
			CTD->CTD_FILIAL := xFilial("CTD") 
			CTD->CTD_ITEM	:= "C"+oModelSA1:GetValue('A1_COD')+oModelSA1:GetValue('A1_LOJA')
			CTD->CTD_CLASSE := "2"
			CTD->CTD_NORMAL := "2"          
			CTD->CTD_DESC01 := oModelSA1:GetValue('A1_NOME')
			CTD->CTD_BLOQ	:= "2"    
			CTD->CTD_DTEXIS := CTOD("01/01/1980")
			CTD->CTD_ITLP 	:= "C"+oModelSA1:GetValue('A1_COD')+oModelSA1:GetValue('A1_LOJA')
			CTD->(MsUnLock())  

			If liRec .And. SA1->(FieldPos('A1_XITEMCC')) > 0

				DbSelectArea("SA1")
				SA1->(DbSetOrder(1))
				If SA1->(DBSeek(xFilial("SA1")+oModelSA1:GetValue('A1_COD')+oModelSA1:GetValue('A1_LOJA')))		
					
					RecLock("SA1",.F.)
						SA1->A1_XITEMCC := "C"+oModelSA1:GetValue('A1_COD')+oModelSA1:GetValue('A1_LOJA')
					SA1->(MsUnLock())
			
				EndIf
			EndIf


		EndIF
	EndIf	

	RestArea(aAreaSA1)
	RestArea(aAreaCTD)

Return () 

