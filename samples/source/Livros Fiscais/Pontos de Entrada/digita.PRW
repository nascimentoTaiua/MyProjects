#INCLUDE "RWMAKE.CH"
USER Function DIGITA()      

PRIVATE aRotina := { { "Pesquisar"  ,"AxPesqui", 0 , 1},;          
					  { "Alterar" ,"U_AAltera", 0 , 4, 2}}         

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o cabecalho da tela de atualizacoes                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE cCadastro := "Complemento de Informacoes do Processo de Importacao"

PRIVATE INCLUI    := .F.
PRIVATE ALTERA    := .F.

dbSelectArea("SD1")
mBrowse( 6, 1,22,75,"SD1")


USER Function AALTERA(cAlias,nReg,nOpc)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a entrada de dados do arquivo                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aButtons := {}
Local aUsrBut  := {}
Local aAltera	:= {'D1_WDINUM','D1_WADI','D1_WADIPOS','D1_WPERII','D1_DESCR','D1_VDOLAR'}
Local aExibe	:= {'D1_DOC','D1_SERIE','D1_COD','D1_WDINUM','D1_WADI','D1_WADIPOS','D1_WPERII','D1_DESCR','D1_VDOLAR'}

Private aTELA[0][0],aGETS[0]

bCampo := {|nCPO| Field(nCPO) }
l010Auto := If(Type("l010Auto") == "U", .f.,l010Auto)

INCLUI := .F.
ALTERA := .T.

While .T.
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Envia para processamento dos Gets          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nOpcA:=0
	
	Begin Transaction
		nOpcA := AxAltera( cAlias, nReg, 2,aExibe,aAltera)
	End Transaction
	Exit
End
dbSelectArea(cAlias)
Return

