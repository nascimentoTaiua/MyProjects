#INCLUDE "protheus.ch"
#INCLUDE "RTMSR18.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RTMSR18A ³ Autor ³ Jose L. Pinheiro Jr.  ³ Data ³29.10.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao MIC/DTA En Lastre Grafico (Pré-Impresso)         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ RTMSR18A                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGATMS                                                    ³±±
±±³          ³ Para uso em impressora LASER  (En Lastre)                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RTMSR18A()

Local   nZ       := 0
Local   cPerg    := "RTMR18G"
Private aParamRl := Array(9)

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
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


If Pergunte( cPerg, .T. )
	For nZ := 1 To Len(aParamRl)
		aParamRl[nZ]:=&("mv_par"+StrZero(nZ,2))
	Next nZ
	Processa( { | lEnd | MontaRel( @lEnd ) }, "Gerando MIC/DTA En Lastre, Aguarde...",, .T. )
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
//Static Function RTMSR18Imp(lEnd,wnRel,titulo,tamanho)
Static Function MontaRel( lEnd )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local  oPrint,oFont1,oFont2,oFont3,oFontD,oFontE
Local  cAliasQry    := GetNextAlias()
Local  cQuery       := ''
Local  aAreaAtu     := GetArea()
Local  aAreaSM0     := SM0->(GetArea())
Local  aRegDCA      := {}
Local  cCdrOri      := ''
Local  cPaiOri      := ''
Local  cCdrDes      := ''
Local  cPaiDes      := ''
Local  cReboque     := ''
Local  cPlacaRb     := ''
Local  nQtdDoc      := 0
Local  nTotVol      := 0
Local  nTotPes      := 0
Local  nVolAnt      := 0
Local  nPesAnt      := 0
Local  nVolAcu      := 0
Local  nPesAcu      := 0
Local  _nTaraSR     := 0
//-- Vias do MIC/DTA
Local  nVia         := 0
Local  aVias        := {}
Local  nQtdVia      := 0
Local  cFilMIC      := ''
Local  cNumMIC      := ''
Local  cCodVei      := ''
Local  cIteMIC      := ''   
Local  cDatMic      := ''

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
oFontE  := TFont():New("Arial"        ,00,15,,.T.,,,,.T.,.F.)
oFontD  := TFont():New("Courier New"  ,06,10)
oFontD1 := TFont():New("Courier New"  ,06,08)

oPrint := TMSPrinter():New( "MIC/DTA - En Lastre (Laser)" )
oPrint:Setup()

cQuery := "SELECT * FROM ("
cQuery += "SELECT ' ' DT6_FILDOC, ' ' DT6_DOC  , ' ' DT6_SERIE  ,   DID_FILORI  , DID_VIAGEM, DID_CODVEI, '"+StrZero(1,Len(DII->DII_ITEMIC))+"' DII_ITEMIC, ' ' DII_CDAORI, ' ' DII_CDADES, 0 DID_QTDDOC , "
cQuery += "       0   DT6_QTDVOL, 0   DT6_PESO , 0   DT6_PESOM3 , 0 DT6_VALMER  , DID_FILMIC, DID_NUMMIC, DID_DATMIC, DTQ_ROTA  , 0 RECNODII, "
cQuery += "       ' ' DT6_SIGTRA, 0   DT6_MOEDA, 0   DT6_VALTOT "
cQuery += " FROM "
cQuery += RetSqlName("DID")+" DID, "
cQuery += RetSqlName("DTQ")+" DTQ  "
cQuery += " WHERE DID.DID_FILIAL = '"+xFilial("DID")+"'"
cQuery += "   AND DID.DID_FILORI BETWEEN '"+aParamRl[01]+"' AND '"+aParamRl[03]+"'"
cQuery += "   AND DID.DID_VIAGEM BETWEEN '"+aParamRl[02]+"' AND '"+aParamRl[04]+"'"
cQuery += "   AND DID.DID_CODVEI BETWEEN '"+aParamRl[05]+"' AND '"+aParamRl[06]+"'"
cQuery += "   AND DID.D_E_L_E_T_  = ' '"
cQuery += "   AND DTQ.DTQ_FILIAL  = '"+xFilial("DTQ")+"'"
cQuery += "   AND DTQ.DTQ_FILORI  = DID_FILORI"
cQuery += "   AND DTQ.DTQ_VIAGEM  = DID_VIAGEM"
cQuery += "   AND DTQ.DTQ_TIPVIA IN ( '1','2', '4' )"
cQuery += "   AND DTQ.D_E_L_E_T_  = ' ') MIC_QRY"
cQuery += " ORDER BY DID_FILORI,DID_VIAGEM,DID_CODVEI,DII_ITEMIC"
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry)
TcSetField(cAliasQry,"DT6_QTDVOL","N",TamSX3("DT6_QTDVOL")[1],TamSX3("DT6_QTDVOL")[2])
TcSetField(cAliasQry,"DT6_PESO"  ,"N",TamSX3("DT6_PESO"  )[1],TamSX3("DT6_PESO"  )[2])
TcSetField(cAliasQry,"DT6_PESOM3","N",TamSX3("DT6_PESOM3")[1],TamSX3("DT6_PESOM3")[2])
TcSetField(cAliasQry,"DT6_VALMER","N",TamSX3("DT6_VALMER")[1],TamSX3("DT6_VALMER")[2])
TcSetField(cAliasQry,"DID_DATMIC","D",TamSX3("DID_DATMIC")[1],TamSX3("DID_DATMIC")[2])
TcSetField(cAliasQry,"DT6_MOEDA" ,"N",TamSX3("DT6_MOEDA" )[1],TamSX3("DT6_MOEDA" )[2])
TcSetField(cAliasQry,"DT6_VALTOT","N",TamSX3("DT6_VALTOT")[1],TamSX3("DT6_VALTOT")[2])

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
		
		For nVia := 1 To nQtdVia
			
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
			
			
			//-- Controle de Impressao			
			oPrint:StartPage() // Inicia uma nova página
			
			
			//-- Campo 03: Transporte Aduaneiro
			If DID->DID_TRANAD =='1' // SIM
				oPrint:Say( 0320, 1320, "X", oFontD )
			Else                                    
				oPrint:Say( 0320, 1500, "X", oFontD )
			EndIf

			
			//-- Campo 04: Numero MIC/DTA
			oPrint:Say( 0340, 1800, Transform((cAliasQry)->DID_NUMMIC,PesqPict("DID","DID_NUMMIC")), oFontE )
			
			//-- Campo 05: Folha
			oPrint:Say( 0450, 1350, "001/001", oFontD )
			
			//-- Campo 06: Data de emissão
			oPrint:Say( 0450, 1850, cDatMic, oFontD )
			
			If (cAliasQry)->DII_ITEMIC == StrZero(1,Len(DII->DII_ITEMIC)) //-- Caratola
				//-- Campo 07: Alfândega
				aDadMIC := TmsDadMIC('07',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
				If Empty(aDadMIC[2])
					oPrint:Say( 0600, 1300, Left(AllTrim(aDadMIC[1]),Len(AllTrim(aDadMIC[1]))-TamSx3("DI1_CODADU")[1]), oFontD )
					oPrint:Say( 0600, 2092, Transform(Right(AllTrim(aDadMIC[1]),TamSx3("DI1_CODADU")[1]),"@R X X X X X X X"), oFontD1 )
				Else
					oPrint:Say( 0600, 1300, aDadMIC[1], oFontD )
					oPrint:Say( 0600, 2092, Transform(aDadMIC[2],"@R X X X X X X X"), oFontD1 )
				EndIf
					
				//-- Campo 08: Cidade e pais de destino final
				aDadMIC := TmsDadMIC('08',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
				oPrint:Say( 0750, 1300, Left(AllTrim(aDadMIC[1]),Len(AllTrim(aDadMIC[1]))-Len(DUY->DUY_PAIS)), oFontD )
				oPrint:Say( 0750, 2268, Transform(Right(AllTrim(aDadMIC[1]),Len(DUY->DUY_PAIS)),"@R X X X"), oFontD )
				oPrint:Say( 0780, 1300, aDadMIC[2], oFontD )

				//-- Campo 09: Caminhão Original
				aDadMIC   := TmsDadMIC('09',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
				oPrint:Say( 0920, 0100, aDadMIC[1], oFontD )
				oPrint:Say( 0960, 0100, aDadMIC[2], oFontD )
				oPrint:Say( 1000, 0100, aDadMIC[3], oFontD )
				oPrint:Say( 1040, 0100, aDadMIC[4], oFontD )
				
				//-- Campo 10: Cadastro geral do contribuinte
				aDadMIC := TmsDadMIC('10',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
				aDadMIC[1] := AllTrim(StrTran(Transform(aDadMIC[1], "@R 99999999999999999999"),'-',''))			
				oPrint:Say(1150, 0100, TRANSFORM(aDadMIC[1],If(Len(aDadMIC[1])>11,"@R 99.999.999/9999-99","@R 999.999.999-99")), oFontD )
				
				//-- Campo 11: Placa do caminhão
				aDadMIC := TmsDadMIC('11',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
				oPrint:Say( 1150, 0820, aDadMIC[1], oFontD )
				
				//-- Campo 12: Marca e numero
				aDadMIC := TmsDadMIC('12',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
				oPrint:Say( 1220, 0100, aDadMIC[1], oFontD )
				oPrint:Say( 1260, 0100, aDadMIC[2], oFontD )
				
				//-- Campo 13: Capacidade de tração
				aDadMIC := TmsDadMIC('13',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
				oPrint:Say( 1220, 0820, Transform(aDadMIC[1],PesqPict("DA3","DA3_CAPACM")), oFontD )
				
				//-- Campo 14: Ano
				aDadMIC := TmsDadMIC('14',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
				oPrint:Say( 1420, 0100, aDadMIC[1], oFontD )

				//-- Campo 15: Reboque
				aDadMIC := TmsDadMIC('15',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
				If Len(aDadMIC) > 0
					cReboque := 'X'
					cPlacaRb := Padr(aDadMIC[1],Len(DA3->DA3_PLACA))
					_nTaraSR := Posicione('DA3',1,xFilial('DA3')+cPlacaRb,'DA3_TARA')
				Else
					cReboque := ' '
					cPlacaRb := ' '
					_nTaraSR := 0
				EndIf
					
				oPrint:Say( 1320, 0670, cReboque, oFontD )
				oPrint:Say( 1400, 0700, cPlacaRb, oFontD )

				If DTR->(ColumnPos('DTR_CODRB3')) > 0
					//-- Campo 22: Reboque 2 
					aDadMIC := TmsDadMIC('22',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
					If Len(aDadMIC) > 0
						cReboque := 'X'
						cPlacaRb := Padr(aDadMIC[1],Len(DA3->DA3_PLACA))
						_nTaraSR := Posicione('DA3',1,xFilial('DA3')+cPlacaRb,'DA3_TARA')
					Else
						cReboque := ' '
						cPlacaRb := ' '
						_nTaraSR := 0
					EndIf
						
					oPrint:Say( 1320, 0670, cReboque, oFontD )
					oPrint:Say( 1400, 0850, cPlacaRb, oFontD )
					
					//-- Campo 42: Reboque 3 
					aDadMIC := TmsDadMIC('42',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
					If Len(aDadMIC) > 0
						cReboque := 'X'
						cPlacaRb := Padr(aDadMIC[1],Len(DA3->DA3_PLACA))
						_nTaraSR := Posicione('DA3',1,xFilial('DA3')+cPlacaRb,'DA3_TARA')
					Else
						cReboque := ' '
						cPlacaRb := ' '
						_nTaraSR := 0
					EndIf
						
					oPrint:Say( 1320, 0670, cReboque, oFontD )
					oPrint:Say( 1400, 1000, cPlacaRb, oFontD )
				EndIf 
			Else
				nQtdDoc += 1
			EndIf
						
			oPrint:Say( 2360, 0100, "En Lastre   En Lastre   En Lastre   En Lastre   En Lastre   En Lastre   En Lastre   " , oFontD )
			oPrint:Say( 3280, 0300, DtoC((cAliasQry)->DID_DATMIC), oFontD )
			
			//-- Via
			oPrint:Say( 3345, 0100, aVias[nVia], oFontD )
			
			//-- Finaliza a página
			oPrint:EndPage()
			
		Next nVia
		
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

(cAliasQry)->(dbCloseArea())

If !lEnd
	oPrint:Preview()
EndIf

RestArea(aAreaSM0)
RestArea(aAreaAtu)

Return

