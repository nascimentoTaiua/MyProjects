#INCLUDE "protheus.ch"
#INCLUDE "RTMSR21.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RTMSR21  ³ Autor ³ Richard Anderson      ³ Data ³21.12.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao Nota de Debito/Credito                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ RTMSR21                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGATMS                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RTMSR21()

Local titulo  := STR0001 //"Nota de Débito/Crédito
Local cString := "DIH"
Local wnrel   := "RTMSR21"
Local cDesc1  := STR0002 //"Este programa ira imprimir a Nota de Débito/Crédito
Local cDesc2  := ""
Local cDesc3  := ""
Local tamanho := "P"
Local Limite  := 80
Local cPerg   := "RTMR21"
Local aOrd    := {}

Private aReturn  := {STR0003,1,STR0004,2, 2, 1, "",1 } //"Zebrado"###"Administracao"
Private nLastKey := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01            	// No.Nota de                         ³
//³ mv_par02            	// No.Nota Ate        	         	  ³
//³ mv_par03            	// Data Emissao de 	      		     ³
//³ mv_par04            	// Data Emissao Ate   		           ³
//³ mv_par05            	// Impressao / Reimpressao            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte(cPerg,.F.)

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

If nLastKey = 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey = 27
	Set Filter To
	Return
Endif

RptStatus({|lEnd| RTMSR21Imp(@lEnd,wnRel,titulo,tamanho,Limite)},titulo)

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RTMSR21Imp³ Autor ³ Richard Anderson      ³ Data ³22.11.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Chamada do Relat¢rio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RTMSR21			                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RTMSR21Imp(lEnd,wnRel,titulo,tamanho,Limite)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local  nObs      := 0
Local  cObs      := ''
Local  cDados    := ''
Local  nLin      := 0, nI := 0, nX := 0
Local  cAliasQry := GetNextAlias()
Local  cQuery    := ''
Local  aAreaAtu  := GetArea()
Local  aStruDIH  := DIH->(dbStruct())
Local  cExtenso  := '' 
Local lDI0PAIS := DI0->(FieldPos("DI0_PAIS")) > 0 //TMS11R177 - Permisso

SetRegua(DIH->(LastRec()))
If lDI0PAIS 
	cQuery := "SELECT DIH.*, DIH.R_E_C_N_O_ RECNODIH, DT6_SIGTRA, DT6_NUMPER, DT6_TIPTRA, DT6_CLIDEV, DT6_LOJDEV FROM "	
Else
	cQuery := "SELECT DIH.*, DIH.R_E_C_N_O_ RECNODIH, DT6_SIGTRA, DT6_TIPTRA, DT6_CLIDEV, DT6_LOJDEV FROM "
EndIf
cQuery += RetSqlName("DIH")+" DIH, "
cQuery += RetSqlName("DT6")+" DT6  "
cQuery += " WHERE DIH.DIH_FILIAL = '"+xFilial("DIH")+"'"
cQuery += "   AND DIH.DIH_NUMNDC BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
cQuery += "   AND DIH.DIH_DATEMI BETWEEN '"+Dtos(mv_par03)+"' AND '"+Dtos(mv_par04)+"'"
cQuery += "   AND DIH.DIH_STATUS IN ( '1', '2' )"
cQuery += "   AND DIH.DIH_FIMP   IN "+Iif(mv_par05 == 1,"( ' ', '0')","( '1' )")
cQuery += "   AND DIH.D_E_L_E_T_ = ' '" 
cQuery += "   AND DT6.DT6_FILIAL = '"+xFilial('DT6')+"'"
cQuery += "   AND DT6.DT6_FILDOC = DIH_FILDOC"
cQuery += "   AND DT6.DT6_DOC    = DIH_DOC"
cQuery += "   AND DT6.DT6_SERIE  = DIH_SERIE"
cQuery += "   AND DT6.D_E_L_E_T_ = ' '"
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry)
For nX := 1 To Len(aStruDIH)
	If aStruDIH[nX][2]<>"C"
		TcSetField(cAliasQry,aStruDIH[nX][1],aStruDIH[nX][2],aStruDIH[nX][3],aStruDIH[nX][4])
	EndIf
Next nX
While (cAliasQry)->(!Eof())

	IncRegua()
	
	If Interrupcao(@lEnd)
		Exit
	EndIf
	
	nLin := 1
	@ nLin,00 PSay AvalImp(Limite)+__PrtLogo()
	nLin += 1
	
	@ nLin,00 PSay Padl(AllTrim(SM0->M0_CIDCOB)+', '+AllTrim(Str(Day((cAliasQry)->DIH_DATEMI),2))+" de "+AllTrim(MesExtenso(Month((cAliasQry)->DIH_DATEMI)))+" de "+Str(Year((cAliasQry)->DIH_DATEMI),4),Limite)
	nLin += 3
	@ nLin,02 PSay 'A'
	nLin += 1
	aDadCli := TMSDadCli((cAliasQry)->DT6_CLIDEV,(cAliasQry)->DT6_LOJDEV)
	For nI := 1 To Len(aDadCli)
		@ nLin,02 PSay aDadCli[nI]
		nLin+= 1
	Next nI
	nLin += 4
	@ nLin,00 PSay Padc('N O T A  D E  '+Iif((cAliasQry)->DIH_TIPNDC == '1','D E B I T O','C R E D I T O'),Limite)
	nLin += 1
	@ nLin,00 PSay Padc('--------------'+Iif((cAliasQry)->DIH_TIPNDC == '1','-----------','-------------'),Limite)
	nLin += 3       
	If  lDI0PAIS  
		@ nLin,02 PSay 'Referente Docto.: '+Iif((cAliasQry)->DT6_TIPTRA == '4',Transform((cAliasQry)->(DT6_SIGTRA+DT6_NUMPER)+Right(Alltrim((cAliasQry)->DIH_DOC),6),"@R AA.XXXX.XXXXXX"),Transform((cAliasQry)->(DIH_FILDOC+DIH_DOC+DIH_SERIE),"@R 99 999999-XXX"))		
	Else
		@ nLin,02 PSay 'Referente Docto.: '+Iif((cAliasQry)->DT6_TIPTRA == '4',Transform((cAliasQry)->(DT6_SIGTRA+DIH_SERIE+DIH_DOC),"@R AA.XXX.XXXXXX"),Transform((cAliasQry)->(DIH_FILDOC+DIH_DOC+DIH_SERIE),"@R 99 999999-XXX"))
	EndIf
	nLin += 3
	@ nLin,02 PSay 'Motivo..........: '
	cObs   := StrTran(MsMM((cAliasQry)->DIH_CODMOT,80),Chr(10),'')
	cDados := ''
	For nObs := 1 To Len(cObs)
		If Substr(cObs,nObs,1) == Chr(13)
			@ nLin,20 PSay cDados
			nObs   += 1
			nLin   += 1
			cDados := ''
			//-- Verifica linhas em branco
			While Substr(cObs,nObs,1) == Chr(13)
				nObs += 1
			EndDo
		EndIf
		cDados += Substr(cObs,nObs,1)
	Next nObs
	nLin += 3
	@ nLin,02 PSay 'Valor...........: '+Transform((cAliasQry)->DIH_VALOR,"@E 99,999,999.99")
	nLin += 1
	cExtenso := Extenso((cAliasQry)->DIH_VALOR)
	@ nLin,18 PSay '('+Padr(cExtenso,60,'*')+' )'
	nLin += 1
	@ nLin,18 PSay '('+Replicate('*',60)+' )'
	nLin += 3
	@ nLin,02 PSay 'Sem outro motivo para o momento, subscrevemo-nos.'
	nLin += 3
	@ nLin,00 PSay Padl('Atenciosamente',67)

	//-- Atualiza flag de impressao
	DIH->(dbGoTo((cAliasQry)->RECNODIH))
	RecLock('DIH',.F.)
	DIH->DIH_FIMP := '1' //-- Impresso
	MsUnLock()
		
	(cAliasQry)->(dbSkip())
	
EndDo	

(cAliasQry)->(dbCloseArea())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se em disco, desvia para Spool                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

RestArea(aAreaAtu)

Return