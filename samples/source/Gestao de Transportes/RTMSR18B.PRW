#INCLUDE "protheus.ch"
#INCLUDE "RTMSR18.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RTMSR18B ³ Autor ³ Jose L. Pinheiro Jr.  ³ Data ³20.10.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao MIC/DTA Grafico (Pré-Impresso)                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ RTMSR18B                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGATMS                                                    ³±±
±±³          ³ Para uso em impressora a LASER                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RTMSR18B()

Local   nZ       := 0
Local   cPerg    := "RTMR18G"
Private aParamRl := Array(8)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01            	// Fil.Origem De		                 ³
//³ mv_par02            	// Viagem De          	         	  ³
//³ mv_par03            	// Fil.Origem Ate  	      		     ³
//³ mv_par04            	// Viagem Ate         		           ³
//³ mv_par05            	// Veiculo De   	   		           ³
//³ mv_par06            	// Veiculo Ate          	           ³
//³ mv_par07            	// Impressao / Reimpressao            ³
//³ mv_par08            	// Originais / Copias		           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


If Pergunte( cPerg, .T. )
	For nZ := 1 To Len(aParamRl)
		aParamRl[nZ]:=&("mv_par"+StrZero(nZ,2))
	Next nZ
	Processa( { | lEnd | MontaRel( @lEnd ) }, "Gerando MIC Pre-Imp. (Laser), Aguarde...",, .T. )
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RTMSR18Imp³ Autor ³ Richard Anderson      ³ Data ³22.11.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Chamada do Relat¢rio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RTMSR18			                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MontaRel( lEnd )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local  nLin         := 0, nI := 0
Local  cQuery       := ''
Local  aAreaAtu     := GetArea()
Local  aAreaSM0     := SM0->(GetArea())
Local  aRegDCA      := {}
Local  nTotVol      := 0
Local  nTotPes      := 0
Local  nVolAnt      := 0
Local  nPesAnt      := 0
Local  nVolAcu      := 0
Local  nPesAcu      := 0
Local  _nSubpeso	  := 0
Local  _nSubVol     := 0
Local  cCdrDes      := ''
Local  cCdrOri      := ''
Local  cPaiDes      := ''
Local  cPaiOri      := ''
Local  cPlacaRb     := ''
Local  cReboque     := ''

//-- Vias do MIC/DTA
Local  aVias        	 := {}
Local  nQtdVia        := 0
Local  lFim           := .F.     
Local  nx             :=0, nVia:= 0

Private  aDadMIC      := {}
//Private  nVia         := 0
Private  nQtdDoc      := 0
Private  cAliasQry  	 := GetNextAlias()
Private  oPrint,oFont1,oFont2,oFont3,oFontD,oFontD1,oFontE
Private  aPg          := {}
Private  aLin         := {}
Private  cFilMIC      := ''
Private  cNumMIC      := ''
Private  cCodVei      := ''
Private  cIteMIC      := ''
Private  cDatMic      := ''
Private  lDI0PAIS := DI0->(FieldPos("DI0_PAIS")) > 0 //TMS11R177 - Permisso

Aadd(aVias, 'Primeira via - Alfandega de partida.')
Aadd(aVias, 'Duplicado - Aduana de salida en Pais de partida.')
Aadd(aVias, 'Triplicado - Aduana de entrada en Pais de destino.')
Aadd(aVias, 'Quadruplicado - Aduana de destino.')
Aadd(aVias, 'Quintuplicado - Transportista.')

If aParamRl[08] == 2
	aVias := {}
	Aadd(aVias, 'Copia.')
ElseIf aParamRl[08] == 3
	Aadd(aVias, 'Copia.')
EndIf

nQtdVia        := Len(aVias)

oFont1  := TFont():New("Arial"        ,00,13,,.T.,,,,.T.,.F.)
oFont2  := TFont():New("Arial"        ,00,08,,.T.,,,,.T.,.F.)
oFont3  := TFont():New("Arial Narrow" ,00,09,,.T.,,,,.T.,.F.)
oFontD  := TFont():New("Courier New"  ,06,10)
oFontD1 := TFont():New("Courier New"  ,06,08)
oFontE  := TFont():New("Arial"        ,00,15,,.T.,,,,.T.,.F.)

oPrint := TMSPrinter():New( "MIC/DTA - Pré-Impresso (Laser)" )

cQuery := "SELECT * FROM ("
cQuery += "SELECT DT6_FILDOC, DT6_DOC  , DT6_SERIE , DID_FILORI, DID_VIAGEM, DID_CODVEI, DII_ITEMIC, DII_CDAORI, DII_CDADES, DID_QTDDOC , "
cQuery += "       DT6_QTDVOL, DT6_PESO , DT6_PESLIQ, DT6_VALMER, DID_FILMIC, DID_NUMMIC, DID_DATMIC, DTQ_ROTA  , DII.R_E_C_N_O_ RECNODII, "
cQuery += "       DT6_SIGTRA, DT6_MOEDA, DT6_VALTOT, DID_QTDFOL, DII_NUMFOL"
If lDI0PAIS 
	cQuery += "  , DT6_NUMPER "
EndIf
cQuery += " FROM "
cQuery += RetSqlName("DID")+" DID, "
cQuery += RetSqlName("DII")+" DII, "
cQuery += RetSqlName("DT6")+" DT6, "
cQuery += RetSqlName("DTQ")+" DTQ  "
cQuery += " WHERE DID.DID_FILIAL = '"+xFilial("DID")+"'"
cQuery += "   AND DID.DID_FILORI BETWEEN '"+aParamRl[01]+"' AND '"+aParamRl[03]+"'"
cQuery += "   AND DID.DID_VIAGEM BETWEEN '"+aParamRl[02]+"' AND '"+aParamRl[04]+"'"
cQuery += "   AND DID.DID_CODVEI BETWEEN '"+aParamRl[05]+"' AND '"+aParamRl[06]+"'"
cQuery += "   AND DID.D_E_L_E_T_  = ' '"
cQuery += "   AND DII.DII_FILIAL  = '"+xFilial("DII")+"'"
cQuery += "   AND DII.DII_FILMIC  = DID_FILMIC"
cQuery += "   AND DII.DII_NUMMIC  = DID_NUMMIC"
cQuery += "   AND DII.DII_CODVEI  = DID_CODVEI"
cQuery += "   AND DII.DII_IMPMIC IN "+Iif(aParamRl[07] == 1,"( ' ', '0')","( '1' )")
cQuery += "   AND DII.D_E_L_E_T_  = ' '"
cQuery += "   AND DT6.DT6_FILIAL  = '"+xFilial("DT6")+"'"
cQuery += "   AND DT6.DT6_FILDOC  = DII_FILDOC"
cQuery += "   AND DT6.DT6_DOC     = DII_DOC"
cQuery += "   AND DT6.DT6_SERIE   = DII_SERIE"
cQuery += "   AND DT6.DT6_DOCTMS <> 'K'"
cQuery += "   AND DT6.D_E_L_E_T_  = ' '"
cQuery += "   AND DTQ.DTQ_FILIAL  = '"+xFilial("DTQ")+"'"
cQuery += "   AND DTQ.DTQ_FILORI  = DID_FILORI"
cQuery += "   AND DTQ.DTQ_VIAGEM  = DID_VIAGEM"
cQuery += "   AND DTQ.DTQ_TIPVIA IN ( '1', '3' )"
cQuery += "   AND DTQ.D_E_L_E_T_  = ' '"
cQuery += " UNION ALL "
cQuery += "SELECT DT6_FILDCO DT6_FILDOC, DT6_DOCDCO DT6_DOC  , DT6_SERDCO DT6_SERIE , DID_FILORI, DID_VIAGEM, DID_CODVEI, DII_ITEMIC, DII_CDAORI, DII_CDADES, DID_QTDDOC , "
cQuery += "       DT6_QTDVOL           , DT6_PESO            , DT6_PESLIQ           , DT6_VALMER, DID_FILMIC, DID_NUMMIC, DID_DATMIC, DTQ_ROTA  , DII.R_E_C_N_O_ RECNODII, "
cQuery += "       DT6_SIGTRA           , DT6_MOEDA           , DT6_VALTOT           , DID_QTDFOL, DII_NUMFOL"
If lDI0PAIS 
	cQuery += "  , DT6_NUMPER "
EndIf
cQuery += " FROM "
cQuery += RetSqlName("DID")+" DID, "
cQuery += RetSqlName("DII")+" DII, "
cQuery += RetSqlName("DT6")+" DT6, "
cQuery += RetSqlName("DTQ")+" DTQ  "
cQuery += " WHERE DID.DID_FILIAL = '"+xFilial("DID")+"'"
cQuery += "   AND DID.DID_FILORI BETWEEN '"+aParamRl[01]+"' AND '"+aParamRl[03]+"'"
cQuery += "   AND DID.DID_VIAGEM BETWEEN '"+aParamRl[02]+"' AND '"+aParamRl[04]+"'"
cQuery += "   AND DID.DID_CODVEI BETWEEN '"+aParamRl[05]+"' AND '"+aParamRl[06]+"'"
cQuery += "   AND DID.D_E_L_E_T_  = ' '"
cQuery += "   AND DII.DII_FILIAL  = '"+xFilial("DII")+"'"
cQuery += "   AND DII.DII_FILMIC  = DID_FILMIC"
cQuery += "   AND DII.DII_NUMMIC  = DID_NUMMIC"
cQuery += "   AND DII.DII_CODVEI  = DID_CODVEI"
cQuery += "   AND DII.DII_IMPMIC IN "+Iif(aParamRl[07] == 1,"( ' ', '0')","( '1' )")
cQuery += "   AND DII.D_E_L_E_T_  = ' '"
cQuery += "   AND DT6.DT6_FILIAL  = '"+xFilial("DT6")+"'"
cQuery += "   AND DT6.DT6_FILDOC  = DII_FILDOC"
cQuery += "   AND DT6.DT6_DOC     = DII_DOC"
cQuery += "   AND DT6.DT6_SERIE   = DII_SERIE"
cQuery += "   AND DT6.DT6_DOCTMS  = 'K'"
cQuery += "   AND DT6.D_E_L_E_T_  = ' '"
cQuery += "   AND DTQ.DTQ_FILIAL  = '"+xFilial("DTQ")+"'"
cQuery += "   AND DTQ.DTQ_FILORI  = DID_FILORI"
cQuery += "   AND DTQ.DTQ_VIAGEM  = DID_VIAGEM"
cQuery += "   AND DTQ.DTQ_TIPVIA IN ( '1', '3' )"
cQuery += "   AND DTQ.D_E_L_E_T_  = ' ' ) MIC_QRY"
cQuery += " ORDER BY DID_FILORI,DID_VIAGEM,DID_CODVEI,DII_ITEMIC"
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry)
TcSetField(cAliasQry,"DT6_QTDVOL","N",TamSX3("DT6_QTDVOL")[1],TamSX3("DT6_QTDVOL")[2])
TcSetField(cAliasQry,"DT6_PESO"  ,"N",TamSX3("DT6_PESO"  )[1],TamSX3("DT6_PESO"  )[2])
TcSetField(cAliasQry,"DT6_PESLIQ","N",TamSX3("DT6_PESLIQ")[1],TamSX3("DT6_PESLIQ")[2])
TcSetField(cAliasQry,"DT6_VALMER","N",TamSX3("DT6_VALMER")[1],TamSX3("DT6_VALMER")[2])
TcSetField(cAliasQry,"DID_DATMIC","D",TamSX3("DID_DATMIC")[1],TamSX3("DID_DATMIC")[2])
TcSetField(cAliasQry,"DT6_MOEDA" ,"N",TamSX3("DT6_MOEDA" )[1],TamSX3("DT6_MOEDA" )[2])
TcSetField(cAliasQry,"DT6_VALTOT","N",TamSX3("DT6_VALTOT")[1],TamSX3("DT6_VALTOT")[2])

aPg          := {}
aLin         := {}

While (cAliasQry)->(!Eof())
	
	cFilOri := (cAliasQry)->DID_FILORI
	cViagem := (cAliasQry)->DID_VIAGEM
	cCodVei := (cAliasQry)->DID_CODVEI
	nTotVol := 0
	nTotPes := 0
	nVolAnt := 0
	nPesAnt := 0
	nVolAcu := 0
	nPesAcu := 0
	nQtdDoc := 0
	
	While (cAliasQry)->(!Eof()) .And. (cAliasQry)->(DID_FILORI+DID_VIAGEM+DID_CODVEI) == cFilOri+cViagem+cCodVei
		
		aLin := {}
		
		IncProc()
		
		If Interrupcao(@lEnd)
			Exit
		EndIf
		
		SM0->(dbSetOrder(1))
		SM0->(dbSeek(cEmpAnt+(cAliasQry)->DID_FILMIC))
		
		cFilMIC := (cAliasQry)->DID_FILMIC
		cNumMIC := (cAliasQry)->DID_NUMMIC
		cIteMIC := (cAliasQry)->DII_ITEMIC
		
		// Data MIC
		aDadMIC := TmsDadMIC('06',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
		If ValType(aDadMIC[1]) == 'D'
			cDatMic := DtoC(aDadMIC[1])
		Else
			cDatMic := aDadMIC[1]
		EndIf
		
		//-- Obtem as regioes de origem/destino a partir da rota da viagem
		aRegDCA := TmsRegDCA((cAliasQry)->DTQ_ROTA)
		cCdrOri := ''
		cPaiOri := ''
		cCdrDes := ''
		cPaiDes := ''
		If Len(aRegDCA) > 0
			cCdrOri := aRegDCA[1,1]
			cPaiOri := Posicione('DUY',1,xFilial('DUY')+cCdrOri,'DUY_PAIS')
			cCdrDes := aRegDCA[Len(aRegDCA),1]
			cPaiDes := Posicione('DUY',1,xFilial('DUY')+cCdrDes,'DUY_PAIS')
		EndIf
		
		
		If (cAliasQry)->DII_ITEMIC == StrZero(1,Len(DII->DII_ITEMIC)) //--  Caratola
			
			//-- Campo 03: Transporte Aduaneiro
			If DID->DID_TRANAD =='1' // SIM
				Aadd(aLin, {0330, 1330, "X", oFontD })
			Else
				Aadd(aLin, {0330, 1500, "X", oFontD })
			EndIf
			
			//-- Campo 04: Numero MIC/DTA
			Aadd(aLin, {0330, 1800, Transform((cAliasQry)->DID_NUMMIC,PesqPict("DID","DID_NUMMIC")), oFontE })
			
			//-- Campo 05: Folha
			Aadd(aLin, {0450, 1350, (cAliasQry)->DII_NUMFOL+"/"+(cAliasQry)->DID_QTDFOL, oFontD })
			
			//-- Campo 06: Data de emissão
			Aadd(aLin, {0450, 1850, cDatMic, oFontD })
			
			//-- Campo 07: Alfândega
			aDadMIC := TmsDadMIC('07',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			If Empty(aDadMIC[2])
				Aadd(aLin, {0600, 1300, Left(AllTrim(aDadMIC[1]),Len(AllTrim(aDadMIC[1]))-TamSx3("DI1_CODADU")[1]), oFontD })
				Aadd(aLin, {0600, 2092, Transform(Right(AllTrim(aDadMIC[1]),TamSx3("DI1_CODADU")[1]),"@R X X X X X X X"), oFontD1 })
			Else
				Aadd(aLin, {0600, 1300, aDadMIC[1], oFontD })
				Aadd(aLin, {0600, 2092, Transform(aDadMIC[2],"@R X X X X X X X"), oFontD1 })
			EndIf
			
			
			//-- Campo 08: Cidade e pais de destino final
			aDadMIC := TmsDadMIC('08',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			Aadd(aLin, {0760, 1300, Left(AllTrim(aDadMIC[1]),Len(AllTrim(aDadMIC[1]))-Len(DUY->DUY_PAIS)), oFontD })
			Aadd(aLin, {0760, 2268, Transform(Right(AllTrim(aDadMIC[1]),Len(DUY->DUY_PAIS)),"@R X X X"), oFontD })
			Aadd(aLin, {0790, 1300, aDadMIC[2], oFontD })
			
			//-- Campo 09: Caminhão Original
			aDadMIC   := TmsDadMIC('09',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			Aadd(aLin, {0920, 0100, aDadMIC[1], oFontD })
			Aadd(aLin, {0960, 0100, aDadMIC[2], oFontD })
			Aadd(aLin, {1000, 0100, aDadMIC[3], oFontD })
			Aadd(aLin, {1040, 0100, aDadMIC[4], oFontD })
			
			//-- Campo 10: Cadastro geral do contribuinte
			aDadMIC := TmsDadMIC('10',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			
			aDadMIC[1] := AllTrim(StrTran(Transform(aDadMIC[1], "@R 99999999999999999999"),'-',''))
			Aadd(aLin, {1170, 0100, TRANSFORM(aDadMIC[1],If(Len(aDadMIC[1])>11,"@R 99.999.999/9999-99","@R 999.999.999-99")), oFontD })
			
			//-- Campo 11: Placa do caminhão
			aDadMIC := TmsDadMIC('11',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			Aadd(aLin, {1150, 0820, aDadMIC[1], oFontD })
			
			//-- Campo 12: Marca e numero
			aDadMIC := TmsDadMIC('12',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			Aadd(aLin, {1240, 0100, aDadMIC[1], oFontD })
			Aadd(aLin, {1275, 0100, aDadMIC[2], oFontD })
			
			
			//-- Campo 13: Capacidade de tração
			aDadMIC := TmsDadMIC('13',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			Aadd(aLin, {1250, 0830, Transform(aDadMIC[1],PesqPict("DA3","DA3_CAPACM")), oFontD })
			
			//-- Campo 14: Ano
			aDadMIC := TmsDadMIC('14',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			Aadd(aLin, {1380, 0100, aDadMIC[1], oFontD })
			
			//-- Campo 15: Reboque
			aDadMIC := TmsDadMIC('15',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			If !Empty(aDadMIC[1])
				cReboque := 'X'
				cPlacaRb := Padr(aDadMIC[1],Len(DA3->DA3_PLACA))
			Else
				cReboque := ''
				cPlacaRb := ''
			EndIf
			
			Aadd(aLin, {1330, 0695, cReboque, oFontD })
			Aadd(aLin, {1400, 0700, cPlacaRb, oFontD })
			
			
			//-- Campo 16: Caminhão Substitutito
			aDadMIC   := TmsDadMIC('16',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			Aadd(aLin, {0900, 1300, aDadMIC[1], oFontD })
			Aadd(aLin, {0940, 1300, aDadMIC[2], oFontD })
			Aadd(aLin, {0980, 1300, aDadMIC[3], oFontD })
			Aadd(aLin, {1020, 1300, aDadMIC[4], oFontD })
			
			//-- Campo 17: Cadastro Geral de Contribuintes
			aDadMIC := TmsDadMIC('17',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			Aadd(aLin, {1150, 1300, aDadMIC[1], oFontD })
			
			//-- Campo 18: Placa do caminhão
			aDadMIC := TmsDadMIC('18',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			Aadd(aLin, {1150, 1900, aDadMIC[1], oFontD })
			
			//-- Campo 19: Marca e numero
			aDadMIC := TmsDadMIC('19',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			Aadd(aLin, {1240, 1300, aDadMIC[1], oFontD })
			Aadd(aLin, {1270, 1300, aDadMIC[2], oFontD })
			
			//-- Campo 20: Capacidade de tração
			aDadMIC := TmsDadMIC('20',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			If aDadMIC[1] > 0
				Aadd(aLin, {1260, 1900, Transform(aDadMIC[1],PesqPict("DA3","DA3_CAPACM")), oFontD })
			End If
			
			//-- Campo 21: Ano
			aDadMIC := TmsDadMIC('21',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			Aadd(aLin, {1380, 1300, aDadMIC[1], oFontD })
			
			//-- Campo 22: Reboque
			aDadMIC := TmsDadMIC('22',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			If !Empty(aDadMIC[1])
				cReboque := 'X'
				cPlacaRb := Padr(aDadMIC[1],Len(DA3->DA3_PLACA))
			Else 
				cReboque := ''
				cPlacaRb := ''
			EndIf
				
				Aadd(aLin, {1320, 1400, cReboque, oFontD })
				Aadd(aLin, {1400, 1400, cPlacaRb, oFontD })
				
			If DTR->(ColumnPos('DTR_CODRB3')) > 0
				//-- Campo 42: Reboque 3 
				aDadMIC := TmsDadMIC('42',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
				If !Empty(aDadMIC[1])
					cReboque := 'X'
					cPlacaRb := Padr(aDadMIC[1],Len(DA3->DA3_PLACA))
				Else
					cReboque := ''
					cPlacaRb := ''
				EndIf
					
					Aadd(aLin, {1320, 1980, cReboque, oFontD })
					Aadd(aLin, {1400, 1980, cPlacaRb, oFontD })
			EndIf 	
			
		ElseIf nQtdDoc == 2
			nQtdDoc := 1
		Else
			nQtdDoc += 1
		EndIf
		
		
		If nQtdDoc == 0
			ImpCorpo(10,.F.)
			
		ElseIf nQtdDoc == 1
			//-- Campo 32 - Peso Bruto
			aDadMIC := TmsDadMIC('32',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			_nSubPeso     := aDadMIC[1]
			_nSubVol      := (cAliasQry)->DT6_QTDVOL
			
			ImpCorpo(-900,.T.)  // impressao do corpo do MIC com deslocamento a menor em pixel
			
			If (cAliasQry)->DID_QTDDOC > 2
				If (cAliasQry)->RECNODII > 0
					DII->(dbGoTo((cAliasQry)->RECNODII))
					RecLock('DII',.F.)
					DII->DII_IMPMIC := '1' //-- Impresso
					MsUnLock()
				EndIf
				(cAliasQry)->(dbSkip())
				If !Empty((cAliasQry)->DT6_DOC)

					cFilMIC := (cAliasQry)->DID_FILMIC
					cNumMIC := (cAliasQry)->DID_NUMMIC
					cIteMIC := (cAliasQry)->DII_ITEMIC
					
					//-- Campo 32 - Peso Bruto
					aDadMIC := TmsDadMIC('32',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
					_nSubPeso     += aDadMIC[1]
					_nSubVol      += (cAliasQry)->DT6_QTDVOL
					
					ImpCorpo(180,.F.) // impressao do corpo do MIC com deslocamento a maior em pixel
				Else
					lFim := .T.
				EndIf
			EndIf
			
			nQtdDoc += 1
		EndIf
		
		
		If (cAliasQry)->DII_ITEMIC == StrZero(1,Len(DII->DII_ITEMIC)) //-- Caratola
			//-- Campo 40: Rota e prazo de transporte
			nLin := 2640
			aPercRt:= TmsDadMIC('40',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			For nI := 1 To Len(aPercRt)
				Aadd(aLin, {nLin, 1220, aPercRt[nI], oFontD })
				nLin += 40
			Next nI
			
			//-- Campo 39: Assinatura e carimbo do transportador
			Aadd(aLin, {3260, 0300, cDatMic, oFontD })
		ElseIf nQtdDoc == 2 .or. lFim
			
			aPercRt:= TmsDadMIC('40',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			
			//-- Campo 42: Subtotal de volume
			Aadd(aLin, {2810, 0620, IIf((_nSubVol > 9), Transform(_nSubVol,"@E 999,999"), StrZero(_nSubVol,2)), oFontD })
			
			//-- Campo 43: Subtotal Peso Bruto
			Aadd(aLin, {2810, 0850, Transform(_nSubPeso,"@E 9,999,999.999"), oFontD })
			
			//-- Campo 40: Rota e prazo de transporte
			nLin := 2810
			
			For nI := 1 To Len(aPercRt)
				Aadd(aLin, {nLin, 1220, aPercRt[nI], oFontD })
				nLin += 40
			Next nI
			
			
			//-- Campo 44: Total folha anterior (Volume)
			Aadd(aLin, {2920, 0620, IIf((nVolAnt > 9), Transform(nVolAnt,"@E 999,999"), StrZero(nVolAnt,2)), oFontD })
			
			//-- Campo 45: Total folha anterior (Peso Bruto)
			Aadd(aLin, {2920, 0850, Transform(nPesAnt,"@E 9,999,999.999"), oFontD })
			
			nVolAcu := _nSubVol  + nVolAnt
			nPesAcu := _nSubPeso + nPesAnt
			nVolAnt := nVolAcu
			nPesAnt := nPesAcu
			
			//-- Campo 46: Total folha anterior (Volume)
			Aadd(aLin, {3030, 0620, IIf((nVolAcu > 9), Transform(nVolAcu,"@E 999,999"), StrZero(nVolAcu,2)), oFontD })
			
			//-- Campo 47: Total folha anterior (Peso Bruto)
			Aadd(aLin, {3030, 0850, Transform(nPesAcu,"@E 9,999,999.999"), oFontD })
			
			//-- Campo 39: Assinatura e carimbo do transportador
			Aadd(aLin, {3280, 0300, cDatMic, oFontD })
			
			nVolAcu 		:= 0
			nPesAcu		:= 0
			nTotVol 		:= 0
			nTotPes 		:= 0
			_nSubPeso   := 0
			_nSubVol    := 0
			lFim        := .F.
		EndIf
		
		Aadd(aPg, aLin)
		
		//-- Campo 32 - Peso Bruto
		aDadMIC := TmsDadMIC('32',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
		If (cAliasQry)->DII_ITEMIC == StrZero(1,Len(DII->DII_ITEMIC)) //-- Caratola
			//-- Soma Volume e Peso
			nVolAnt += (cAliasQry)->DT6_QTDVOL
			nPesAnt += aDadMIC[1]
		ElseIf nQtdDoc < 2
			//-- Soma Volume e Peso
			nTotVol += (cAliasQry)->DT6_QTDVOL
			nTotPes += aDadMIC[1]
		EndIf
		
		
		//-- Atualiza flag de impresso do MIC/DTA
		If (cAliasQry)->RECNODII > 0
			DII->(dbGoTo((cAliasQry)->RECNODII))
			RecLock('DII',.F.)
			DII->DII_IMPMIC := '1' //-- Impresso
			MsUnLock()
		EndIf
		
		(cAliasQry)->(dbSkip())
		
	EndDo
	
EndDo


For nI := 1 To Len(aPg)
	
	For nVia := 1 To nQtdVia
		
		oPrint:StartPage() // Inicia uma nova página
		
		For nX := 1 to Len(aPg[nI])
			
			oPrint:Say( aPg[nI][nX,1], aPg[nI][nX,2], aPg[nI][nX,3], aPg[nI][nX,4] )
			
			//-- Via
			If nX == Len(aPg[nI])
				oPrint:Say( 3345, 0100, aVias[nVia], oFontD )
			EndIf
			
			
		Next nX
		
		oPrint:EndPage()  // Finaliza Pagina
		
	Next nVia
	
Next nI


(cAliasQry)->(dbCloseArea())

If !lEnd
	oPrint:Preview()
EndIf

RestArea(aAreaSM0)
RestArea(aAreaAtu)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ImpCorpo   ³ Autor ³Jose Luiz P. Jr.    ³ Data ³ 22/11/2006 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Imprimi o Corpo do MIC/DTA   - Todoas as vias               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³RTMSR18                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ImpCorpo(nL,lImp)
Local  aDadCli      := {}
Local  aDocAne      := {}
Local  aObsDoc      := {}
Local  aDadEmb      := {}     
Local  nI           := 0

Default nL   := 0
Default lImp := .T.


If nQtdDoc == 1 .and. lImp
	//-- Campo 04: Numero MIC/DTA
	Aadd(aLin, {0350, 1850, Transform((cAliasQry)->DID_NUMMIC,PesqPict("DID","DID_NUMMIC")), oFontE })
	
	//-- Campo 05: Folha
	Aadd(aLin, {0480, 1350, (cAliasQry)->DII_NUMFOL+"/"+(cAliasQry)->DID_QTDFOL, oFontD })
	
	//-- Campo 06: Data de emissão
	Aadd(aLin, {0480, 1850, cDatMic, oFontD })
EndIf

//-- Campo 23: Numero do Conhecimento
//-- Campo 24: Alfandega de destino
//-- Campo 33: Dados do Cliente Remetente

aDadMIC := TmsDadMIC('24',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)    
If lDI0PAIS
	Aadd(aLin, {1540 + nL, 0100, Transform((cAliasQry)->(DT6_SIGTRA+DT6_NUMPER)+Right(Alltrim((cAliasQry)->DT6_DOC),6),"@R AA.9999.999999"), oFontD })
Else
	Aadd(aLin, {1540 + nL, 0100, Transform((cAliasQry)->(DT6_SIGTRA+DT6_SERIE+DT6_DOC),"@R AA.999.999999"), oFontD })
EndIf

If Empty(aDadMIC[2])
	Aadd(aLin, {1540 + nL, 0430, Left(AllTrim(aDadMIC[1]),Len(AllTrim(aDadMIC[1]))-TamSx3("DI1_CODADU")[1]*2), oFontD })
	Aadd(aLin, {1540 + nL, 0975, Right(AllTrim(aDadMIC[1]),TamSx3("DI1_CODADU")[1]*2), oFontD1 })
Else
	Aadd(aLin, {1540 + nL, 0430, Substr(aDadMIC[1],1,23), oFontD })
	Aadd(aLin, {1540 + nL, 0975, Transform(Padl(AllTrim(StrTran(aDadMIC[2],' ','')),TamSx3("DI1_CODADU")[1]),"@R X X X X X X X"), oFontD1 })
EndIf


aDadCli := TmsDadMIC('33',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
Aadd(aLin, {1477 + nL, 1300, aDadCli[1], oFontD })
Aadd(aLin, {1517 + nL, 1300, aDadCli[2], oFontD })
Aadd(aLin, {1557 + nL, 1300, aDadCli[3], oFontD })


//-- Campo 25: Moeda
//-- Campo 26: Origem das Mercadorias
//-- Campo 34: Dados do Cliente Destinatario

aDadMIC := TmsDadMIC('25',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
Aadd(aLin, {1690 + nL, 0100, aDadMIC[1], oFontD })

aDadMIC := TmsDadMIC('26',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
If SYA->(MsSeek(xFilial('SYA')+Right(aDadMIC[1],Len(DUY->DUY_PAIS)) ))
	Aadd(aLin, {1690 + nL, 0540, Left(aDadMIC[1],Len(aDadMIC[1])-Len(DUY->DUY_PAIS)), oFontD })
	Aadd(aLin, {1690 + nL, 1078, Transform(Right(aDadMIC[1],Len(DUY->DUY_PAIS)),"@R X X X"), oFontD })
Else
	Aadd(aLin, {1690 + nL, 0540, aDadMIC[1], oFontD })
EndIf


aDadCli := TmsDadMIC('34',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
Aadd(aLin, {1635 + nL, 1300, aDadCli[1], oFontD })
Aadd(aLin, {1675 + nL, 1300, aDadCli[2], oFontD })
Aadd(aLin, {1715 + nL, 1300, aDadCli[3], oFontD })


//-- Campo 27: Valor FOT
//-- Campo 28: Frete
//-- Campo 29: Seguro
//-- Campo 35: Dados do Cliente Consignatário
aDadMIC := TmsDadMIC('27',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
Aadd(aLin, {1830 + nL, 0100, Transform(aDadMIC[1],PesqPict("DT6","DT6_VALMER")), oFontD })

aDadMIC := TmsDadMIC('28',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
Aadd(aLin, {1830 + nL, 0540, Transform(aDadMIC[1],"@E 9,999,999.99"), oFontD })

aDadMIC := TmsDadMIC('29',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
Aadd(aLin, {1830 + nL, 0850, Transform(aDadMIC[1],PesqPict("DTC","DTC_VALSEG")), oFontD })

aDadCli := TmsDadMIC('35',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
Aadd(aLin, {1790 + nL, 1300, aDadCli[1], oFontD })
Aadd(aLin, {1830 + nL, 1300, aDadCli[2], oFontD })
Aadd(aLin, {1867 + nL, 1300, aDadCli[3], oFontD })


//-- Campo 30: Tipo de Volumes
//-- Campo 31: Qtde.de Volumes
//-- Campo 32: Peso Bruto
//-- Campo 36: Documentos Anexos

aDocAne := TmsDadMIC('36',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
Aadd(aLin, {2000 + nL, 1300, aDocAne[1], oFontD })
Aadd(aLin, {2040 + nL, 1300, aDocAne[2], oFontD })
Aadd(aLin, {2080 + nL, 1300, aDocAne[3], oFontD })
Aadd(aLin, {2120 + nL, 1300, aDocAne[4], oFontD })
Aadd(aLin, {2160 + nL, 1300, aDocAne[5], oFontD })


aDadEmb := _DadEmb((cAliasQry)->DT6_FILDOC,(cAliasQry)->DT6_DOC,(cAliasQry)->DT6_SERIE)
aDadMIC := TmsDadMIC('31',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)

If valtype(aDadMIC[1]) == 'C'
	aDadMIC[1] := Val(StrTran(aDadMIC[1],',',''))
EndIf

Aadd(aLin, {2010 + nL, 0070, aDadEmb[1], oFontD })
Aadd(aLin, {2010 + nL, 0350, Transform( aDadEmb[2],"@R X X"), oFontD })
Aadd(aLin, {2010 + nL, 0500, IIf((aDadMic[1] > 9), Transform(aDadMic[1],"@E 999,999"), StrZero(aDadMic[1],2)), oFontD })

//Lacres
aDadMIC := TmsDadMIC('37',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
Aadd(aLin, {2140 + nL, 0060, aDadMIC[1], oFontD })


//Peso Bruto
aDadMIC := TmsDadMIC('32',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
Aadd(aLin, {1980 + nL, 0800, 'Bruto: ' + Transform(aDadMIC[1],"@E 999,999.999"), oFontD })

// Peso Liquido
aDadMIC := TmsDadMIC('41',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
Aadd(aLin, {2020 + nL, 0800, 'Liqu.: ' + Transform(aDadMIC[1],"@E 999,999.999"), oFontD })


//-- Campo 38: Marcas e numeros dos volumes
nLin := 2290
aObsDoc:= TmsDadMIC('38',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
For nI := 1 To Len(aObsDoc)
	Aadd(aLin, {nLin + nL, 0100, aObsDoc[nI], oFontD })
	nLin += 38
	If nI > 6
		Exit
	EndIf
Next nI

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³   _DadEmb ³ Autor ³ Jose Luiz Pinheiro Jr³ Data ³22.11.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna Descricao da Embalagem do Documento e              ³±±
±±³          ³ o codigo da embalagem conforme tabela do siscomex.         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ TMSDadEmb([ExpC1],[ExpC2],[ExpC3])                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 - Filial Documento                                   ³±±
±±³          ³ ExpC2 - Numero Documento                                   ³±±
±±³          ³ ExpC3 - Serie  Documento                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Expresso Aracatuba                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function _DadEmb(cFilDoc,cDoc,cSerie)
Local   aAreaDTC := DTC->(GetArea())
Local   aEmb     := Array(2)
Default cFilDoc  := ''
Default cDoc     := ''
Default cSerie   := ''

Afill(aEmb,Space(2))

If !Empty(cDoc)
	DTC->(dbSetOrder(3))
	DTC->(MsSeek(xFilial('DTC')+cFilDoc+cDoc+cSerie))
	
	aEmb[1] := Tabela('MG',DTC->DTC_CODEMB,.F.)

	aEmb[2] := AllTrim(FWGetSX5('MG',DTC->DTC_CODEMB, TamSX3("X5_CHAVE")))		// Codigo da embalagem

	
EndIf
RestArea(aAreaDTC)
Return aEmb