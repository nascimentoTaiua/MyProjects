#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"

Static lMarkAll := .T. //Indicador de marca/desmarca todos
Static nContTMP := 0   //Contador de Registros Marcados (ProcRegua)
/*/{Protheus.doc} ETQEND
Impressão de etiquetas de Endereço
@author ricardo.rotta
@VERSION PROTHEUS 12
@SINCE 06/01/23
@Impressão Etiquetas de Endereço
/*/
User Function ETQEND()

Local aColsBrw    := {}
Local aColsSX3    := {}
Local aSeeks      := {}
Private cPerg     := "ETIQEND"
Private oBrowse   := Nil
Private cAliasBrw := GetNextAlias()
Private cMarca    := "X"
Private cFilaE    := ""
Private cTamLet   := ""
Gera_SX1(cPerg)
	If !Pergunte(cPerg,.T.)
		Return
	EndIf
	cFilaE := mv_par01
	cTamLet := mv_par09
	If !BrwQuery()
		Return
	EndIf
	AAdd(aColsBrw,{BuscarSX3('BE_LOCAL'		,,aColsSX3), "TP_LOCAL"		,'C',aColsSX3[3],aColsSX3[4],aColsSX3[2],1,,.F.,,,,,,,,1}) // Local
	AAdd(aColsBrw,{BuscarSX3('BE_LOCALIZ'	,,aColsSX3), "TP_LOCALIZ"	,'C',aColsSX3[3],aColsSX3[4],aColsSX3[2],1,,.F.,,,,,,,,1}) // Codigo
	AAdd(aColsBrw,{BuscarSX3('BE_DESCRICC'	,,aColsSX3), "TP_DESC"   	,'C',aColsSX3[3],aColsSX3[4],aColsSX3[2],1,,.T.,,,,,,,,1}) // Descrição
	AAdd(aColsBrw,{BuscarSX3('BE_CODZON'	,,aColsSX3), "TP_CODZON"   	,'C',aColsSX3[3],aColsSX3[4],aColsSX3[2],1,,.T.,,,,,,,,1}) // Zona
	AAdd(aColsBrw,{BuscarSX3('DC4_DESZON'	,,aColsSX3), "TP_DESCZON"  	,'C',aColsSX3[3],aColsSX3[4],aColsSX3[2],1,,.T.,,,,,,,,1}) // Descrição

	AAdd(aSeeks, {; // Endereço
		AllTrim(aColsBrw[1][1]),;
		{;
			{'SBE',aColsBrw[2][3],aColsBrw[2][4],aColsBrw[2][5],aColsBrw[2][1],Nil} ;
		}})

	AAdd(aSeeks, {; // Descricao
		AllTrim(aColsBrw[2][1]),;
		{;
			{'SBE',aColsBrw[4][3],aColsBrw[4][4],aColsBrw[4][5],aColsBrw[4][1],Nil} ;
		}})

	oBrowse:= FWMarkBrowse():New()
	oBrowse:SetDescription("Etiqueta Endereço")
	oBrowse:SetMenuDef("ETQEND")
	oBrowse:SetFields(aColsBrw)
	oBrowse:SetSeek(.T.,aSeeks)
	oBrowse:SetTemporary(.T.)
	oBrowse:SetAlias(cAliasBrw)
	oBrowse:SetFieldMark("TP_MARK")
	oBrowse:SetMark(cMarca,cAliasBrw,"TP_MARK")
	oBrowse:SetAllMark({||BrwAllMark()})
	oBrowse:SetWalkThru(.F.)
	oBrowse:SetAmbiente(.F.)
	oBrowse:SetUseFilter(.T.)
	oBrowse:SetParam({|| RecarSel()})
	oBrowse:Activate()
	delTabTmp(cAliasBrw)
Return

//----------------------------------------------------------------------------------------------------//
//------------------------------Permite selecionar novamente o intervalo------------------------------//
//----------------------------------e recarregar os dados no Browse-----------------------------------//
//----------------------------------------------------------------------------------------------------//
Static Function RecarSel(lPergunte)
	If !Pergunte(cPerg,.T.)
		Return
	EndIf
	DbSelectArea(cAliasBrw)
	ZAP // Apaga os dados da tabela temporária cAliasBrw
	cFilaE  := mv_par01
	cTamLet := mv_par09
	BrwQuery(.F.)
	oBrowse:GoBottom()
	oBrowse:Refresh(.T.)
Return

//-------------------------------------------------------------------//
//-------------------------Função MenuDef----------------------------//
//-------------------------------------------------------------------//
Static Function MenuDef()
Local aRotina := {}
	ADD OPTION aRotina TITLE "Selecionar"	ACTION 'StaticCall(ETQEND,RecarSel)' 	OPERATION 3 ACCESS 0 // Processar
	ADD OPTION aRotina TITLE "Imprimir" 	ACTION 'StaticCall(ETQEND,IMP001)' 		OPERATION 4 ACCESS 0 // Processar
Return aRotina
//-------------------------------------------------------------------------

Static Function IMP001

Local nJ        := 1
Local cCodCB5 	:= CriaVar("CB5_MODELO",.F.)
Local aImp		:= {}
Local cLocaliz	:= CriaVar("BE_LOCALIZ",.F.)
Local cDesc	    := CriaVar("BE_DESCRIC",.F.)
dbSelectArea(cAliasBrw)
dbGotop()
While !Eof()
	If !Empty((cAliasBrw)->TP_MARK)
		cLocaliz	:= Alltrim((cAliasBrw)->TP_LOCALIZ)
		cDesc		:= Alltrim((cAliasBrw)->TP_DESC)
		aadd(aImp, {cLocaliz, cDesc})
	ENDIF
	dbSelectArea(cAliasBrw)
	dbSkip()
End
If Len(aImp) > 0
	If CB5SetImp(cFilaE,.T.)
		cCodCB5 := Alltrim(CB5->CB5_MODELO)
		For nJ:=1 to Len(aImp)
			Processa( {|lEnd| u_EtVEND(cCodCB5, aImp[nJ,1],aImp[nJ,2])}, "Aguarde...","Imprimindo Etiquetas", .T. )
		Next
	Endif
Endif
Return

/*/{Protheus.doc} ETQVIN
EtCaixa Impressão de etiquetas de VIN
@author ricardo.rotta
@VERSION PROTHEUS 12
@SINCE 12/04/25
@Impressão Etiquetas de VIN
/*/
User Function EtVEND(cCodCB5, cLocaliz, cDesc)

Local aArea := GetArea()
Local nColEnd := 32.5
Local nColBar := 32.5
Local cTamImp := IIF(cTamLet == 1, "8,7", "7,7")
If Len(Alltrim(cLocaliz)) >= 6
	If cTamLet == 1
		nColEnd := 10
		nColBar := 15
	Else
		nColEnd := 15
		nColBar := 15
	Endif
Endif
MSCBBEGIN(1,6)
If cCodCB5 == "ZEBRA"
	MSCBSAYMEMO(00,02,100,1,ALLTRIM(cDesc),"N","0","025,020",.F.,"C")
	MSCBSAYBAR(28,05,Alltrim(cLocaliz),"N","MB07",8,.F.,.F.,.F.,,2,1,.F.,.F.)
	MSCBSAYMEMO(00,14,100,1,ALLTRIM(cLocaliz),"N","0","025,020",.F.,"C")
Else
//	MSCBSAY(05,20,"DESCRICAO","N","2","01,01")
//	MSCBSAY(05,15,ALLTRIM(cDesc),"N","9", "2,2")
	MSCBSAY(nColEnd		,29.5,ALLTRIM(cLocaliz),"N","2", cTamImp)
	MSCBSAYBAR(nColBar	,12.5,Alltrim(cLocaliz),"N","MB07",15,.F.,.F.,.F.,,8,5,.F.)
//	MSCBSAYBAR(28,05,Alltrim(cLocaliz),"N","MB07",8,.F.,.F.,.F.,,2,1,.F.,.F.)
Endif
MSCBEND()
MSCBCLOSEPRINTER()
RestArea(aArea)
Return
//---------------------------------------------------------------------------------------------------------//
//-------------------------Realiza busca dos dados que serão exibidos no Browse----------------------------//
//---------------------------------------------------------------------------------------------------------//
/*/{Protheus.doc} BrwQuery
Filtro dos registros para seleção
@type function
@version 1.12.27
@author ricardo rotta
@since 20/08/2020
@param lCriaTemp, logical, True para gerar temporário
@return return_type, registros para seleção
@description Filtro dos registros dos apontamentos para impressão das etiquetas 
conforme os parametros informados pelo usuário
/*/
Static Function BrwQuery(lCriaTemp)
Local cQuery    := ""
Local cAliasQry := ""
Default lCriaTemp := .T.
	If lCriaTemp
		If !CriaTemp()
			Return .F.
		EndIf
	EndIf
	nContTMP = 0
	cQuery := "SELECT BE_LOCAL, BE_LOCALIZ, BE_DESCRIC, BE_CODZON"
	cQuery += " FROM "+RETSQLNAME("SBE")+" WHERE D_E_L_E_T_ = ' ' "
	cQuery += " AND BE_FILIAL='"+XFILIAL("SBE")+"'"
	cQuery += " AND BE_LOCAL = '" + mv_par02 + "'"
	cQuery += " AND BE_LOCALIZ >= '" + mv_par03 + "'"
	cQuery += " AND BE_LOCALIZ <= '" + mv_par04 + "'"
	cQuery += " AND BE_CODZON >= '" + mv_par05 + "'"
	cQuery += " AND BE_CODZON <= '" + mv_par06 + "'"
	cQuery += " AND BE_ESTFIS >= '" + mv_par07 + "'"
	cQuery += " AND BE_ESTFIS <= '" + mv_par08 + "'"
	cQuery += " ORDER BY BE_LOCALIZ"
	cAliasQry := GetNextAlias()
	DbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasQry,.F.,.T.)
	While !(cAliasQry)->(Eof())
		RecLock(cAliasBrw,.T.)
		(cAliasBrw)->TP_LOCAL   := (cAliasQry)->BE_LOCAL
		(cAliasBrw)->TP_LOCALIZ := (cAliasQry)->BE_LOCALIZ
		(cAliasBrw)->TP_DESC  	:= (cAliasQry)->BE_DESCRIC
		(cAliasBrw)->TP_CODZON 	:= (cAliasQry)->BE_CODZON
		(cAliasBrw)->TP_DESCZON	:= Posicione("DC4", 1, xFilial("DC4")+(cAliasQry)->BE_CODZON, "DC4_DESZON")
		MsUnlock(cAliasBrw)
		(cAliasQry)->(DbSkip())
	EndDo
	(cAliasQry)->(DbCloseArea())
	(cAliasBrw)->(DbGoTop())
Return .T.
//-----------------------------------------------------------------------------//
//-------------------------Cria a tabela temporária----------------------------//
//-----------------------------------------------------------------------------//
Static Function CriaTemp()
Local aColsSX3 := {}
Local aColsBrw  := {}
	/*Coluna de marcação*/             	 AAdd(aColsBrw,{"TP_MARK"  		,"C",          1,          0})
	BuscarSX3("BE_LOCAL"	,,aColsSX3); AAdd(aColsBrw,{"TP_LOCAL"		,"C" ,aColsSX3[3],aColsSX3[4]})
	BuscarSX3("BE_LOCALIZ"  ,,aColsSX3); AAdd(aColsBrw,{"TP_LOCALIZ"	,"C" ,aColsSX3[3],aColsSX3[4]})
	BuscarSX3("BE_DESCRIC"	,,aColsSX3); AAdd(aColsBrw,{"TP_DESC"		,"C" ,aColsSX3[3],aColsSX3[4]})
	BuscarSX3("BE_CODZON"	,,aColsSX3); AAdd(aColsBrw,{"TP_CODZON"		,"C" ,aColsSX3[3],aColsSX3[4]})
	BuscarSX3("DC4_DESZON"	,,aColsSX3); AAdd(aColsBrw,{"TP_DESCZON"	,"C" ,aColsSX3[3],aColsSX3[4]})
	// Cria tabelas temporárias
	criaTabTmp(aColsBrw,{'TP_LOCALIZ', 'TP_CODZON'} ,cAliasBrw)
Return .T.
/*/{Protheus.doc} BrwAllMark
Função para marcar ou desmarcar a seleção no bowse
@type function
@version 1.12.27
@author ricardo rotta
@since 13/06/2020
@return return_type, return_description
/*/
Static Function BrwAllMark()
Local aAreaAnt  := GetArea()
	lMarkAll := !lMarkAll
	nContTMP := 0
	(cAliasBrw)->(DbGoTop())
	While (cAliasBrw)->(!Eof())
		If !Empty((cAliasBrw)->TP_LOCALIZ)
			RecLock(cAliasBrw,.F.)
			(cAliasBrw)->TP_MARK := Iif(lMarkAll,cMarca," ")
			MsUnlock()
			If !Empty((cAliasBrw)->TP_MARK)
				nContTMP++
			EndIf
		EndIf
		(cAliasBrw)->(DbSkip())
	EndDo
	(cAliasBrw)->(DbGoTop())
RestArea(aAreaAnt)
oBrowse:Refresh()
Return Nil

/*/{Protheus.doc} Gera_SX1
Geração dos registros das perguntas no SX1
@type function
@version 1.12.27
@author ricardo rotta
@since 12/06/2020
@param cPerg, character, Nome do grupo das perguntas
@return return_type, return_description
/*/
Static Function Gera_SX1(cPerg)

Local i := 0
Local j := 0
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
aRegs:={}
AADD(aRegs,{cPerg,"01","Local Impressao	  ?"  ,"","","mv_ch1","C",TAMSX3("CB5_CODIGO")[1],0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","CB5"})
AADD(aRegs,{cPerg,"02","Do Armazem        ?"  ,"","","mv_ch2","C",TAMSX3("NNR_CODIGO")[1],0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","NNR"})
AADD(aRegs,{cPerg,"03","Do Endereco       ?"  ,"","","mv_ch3","C",TAMSX3("BE_LOCALIZ")[1],0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SBE"})
AADD(aRegs,{cPerg,"04","Ate Endereco      ?"  ,"","","mv_ch4","C",TAMSX3("BE_LOCALIZ")[1],0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SBE"})
AADD(aRegs,{cPerg,"05","Da Zona           ?"  ,"","","mv_ch5","C",TAMSX3("BE_CODZON")[1] ,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","DC4"})
AADD(aRegs,{cPerg,"06","Ate Zona          ?"  ,"","","mv_ch6","C",TAMSX3("BE_CODZON")[1] ,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","DC4"})
AADD(aRegs,{cPerg,"07","Da Estrut.Fisica  ?"  ,"","","mv_ch7","C",TAMSX3("BE_ESTFIS")[1] ,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","DC8"})
AADD(aRegs,{cPerg,"08","Ate Estrut.Fisica ?"  ,"","","mv_ch8","C",TAMSX3("BE_ESTFIS")[1] ,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","DC8"})
AADD(aRegs,{cPerg,"09","Tamanho da Letra  ?"  ,"","","mv_ch9","N",01                     ,0,0,"C","","mv_par09","8 cm","8 cm","8 cm","","","7 cm","7 cm","7 cm","","","","","","","","",""})
For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next
Return
