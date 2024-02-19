#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TBICONN.CH"
#include "fileio.ch

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MdfeSf30³ Autor ³ Totvs                 ³ Data ³14.02.2017³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rdmake de exemplo para geracao do Manifesto Eletronico da   ³±±
±±³          ³SEFAZ - Versao 3.00                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³String do MDFe                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Tipo do MDFe                                         ³±±
±±³          ³       [1] Envio                                            ³±±
±±³          ³       [2] Encerramento                                     ³±±
±±³          ³       [3] Cancelamento                                     ³±±
±±³          ³ExpC2: Filial de Origem                                     ³±±
±±³          ³ExpC3: Numero da Viagem                                     ³±±
±±³          ³ExpC4: Filial do Manifesto                                  ³±±
±±³          ³ExpC5: Numero do Manifesto                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MdfeSf30()               

Local cString     := ""
Local nSerieMDF   := 0
Local aXMLMDFe    := {}
Local cMDF        := ''
Local cChvAcesso  := ''
Local nCount      := 0 
Local nCount2     := 0
Local cCodUF      := ''
Local cTpEmis     := ''
Local cUFIni      := ''
Local cUFFim      := ''
Local cCdMunIni	  := ''
Local aCdMunIni	  := {}
Local nCdMunIni	  := 1 
Local cCidIni     := ''
Local cNFe        := ""
Local cTmsAntt    := SuperGetMv( "MV_TMSANTT", .F., .F. )
Local cCodVei     := ''
Local cAliasDTR   := ''
Local nX          := 0
Local nCapcM3     := 0 
Local cAliasDA4   := ''
Local cAliasDVB   := ''
Local cAliasDUD   := ''
Local cAliasDT6   := ''
Local cAliasCLI   := ''
Local cFilDCAOld  := ''
Local cMunDCAOld  := ''
Local cCodObs	  := ''
Local cObs		  := ''
Local cQuery      := ''         
Local cFilMan     := PARAMIXB[1]
Local cNumMan     := PARAMIXB[2]
Local cAmbiente   := PARAMIXB[3]
Local cVerAmb     := PARAMIXB[4]
Local cModalidade := PARAMIXB[5]
Local cEvento     := PARAMIXB[6]
Local cSerMan     := PARAMIXB[7]
Local cTimeZone   := PARAMIXB[8]
Local cUFPer      := ""
Local cNumRom     := ""
Local cAliasDUN   := ""
Local cAliasDIQ   := ""   
Local nQtdCte     := 0
Local cMdfeDoc    := SuperGetMV('MV_MDFEDOC',,'')
Local aTipoDoc    := Iif(!Empty(cMdfeDoc),Str2Arr(Upper(cMdfeDoc), ","),'')  //quebra em array por delimitador ","
Local lRet        := .T.
Local cSertms     := ''
Local cTipTra     := "1" ///1.Rodoviario;2.Aéreo;3.Fluvial;4.Rodoviario Internacional;6.multimodal
Local lPercMDFe   := .F.
Local aPercurso   := {}   
Local nPos        := 0
Local nEst        := 0
Local cRota       := ""
Local cCNPJAntt   := SuperGetMv( "MV_CNPJANTT", .F., .F. )
Local lTercRbq    := DTR->(ColumnPos("DTR_CODRB3")) > 0
Local aAreaSM0    := SM0->(GetArea())
Local aInfSeguro  :={}
Local lRoteiro    := .F.
Local lPerc       := .F. 
Local nRecDL1     := 0
Local cAliasDUD2  := ''
Local a190UFRD    := {}
Local cNumRed     := ''
Local cCdMnRed    := ''
Local cNmMnRed    := ''
Local lImpRed     := .F.
Local lDTX_PRMACO := DTX->(ColumnPos("DTX_PRMACO")) > 0
Local aAreaSM01   := {}
Local cFilOri	  := ""
Local cViagem	  := ""
Local cCNPJOPer	  := "" // CNPJ da Empresa Operadora de Vale Pedágio 
Local lCnpjOP 	  := DTR->(ColumnPos('DTR_CNPJOP')) > 0
Local lCnpjPg	  := DTR->(ColumnPos('DTR_CNPJPG')) > 0 
Local lForOpe	  := DTR->(ColumnPos('DTR_FOROPE')) > 0 
Local cChvCte	  := ""
Local cIsenSub	  := GetMV("MV_ISENSUB",,"")
Local lUsaColab   := UsaColaboracao("5")
Local lInfMunDes  := .F.
Local aAreaAnt    := {}
Local aRetDA4     := {}  // Dados Array Motorista - Codigo / Nome/ CGC /Tipo 
Local cA2_Nome    := ""
Local cA2_EST     := ""
Local cA2_PFisica := ""
Local cA2_Tipo    := ""
Local cA2_CGC     := ""
Local cBanco      := ""
Local cAgencia    := ""
Local nC          := 0
Local nC1         := 0
Local nValComp    := 0
Local nValFre     := 0
Local cCondPag    := ""
Local aVenctos    := {}
Local nTipoPag    := 0
Local lCIOT       := .F.
Local cA2_CGCPdg  := ""  
Local lVgCNPJOpe  :=.F.
Local aFretPag    := {}
Local nValImp     := 0
Local nValPdg     := 0 
Local lTagComp    := .F.
Local lDEGOP	  := .F.
Local cCodForn    := ""
Local cLojForn	  := ""
Local lMDFeInt    := IIf((cAmbiente == '1' .And. dDataBase >= CToD('02/05/2021')) .Or. (cAmbiente == '2' .And. dDataBase >= CToD('05/04/2021')), .T., .F.)
Local lNT2021002  := IIf((cAmbiente == '1' .And. dDataBase >= CToD('07/06/2021')) .Or. (cAmbiente == '2' .And. dDataBase >= CToD('02/05/2021')), .T., .F.) //NT 2021.002 do MDFe
Local nQtdEixo    := 0
Local cCatCobVei  := ""
Local lTMSMDFESE  := ExistBlock("TMSMDFESE",,.T.)
Local nValAdto	  := 0
Local cTpValePed  := ""
Local cPix		  := ""
Local cAliasTrp   := GetNextAlias()
Local lTpTransp	  := .F.
Local lFrtZero	  := .F.
Local nValTotFre  := 0
Local cXComp	  := ""
Local cCNPJOPpdg  := "" // CNPJ do Responsável pelo Pagamento do Vale Pedágio. Somente utilizado quando o pagador do pedágio não for o Emitente do MDF-e.
Local cCodMun     := ""
Local lForCTO	  := DTR->(ColumnPos('DTR_FORCTO')) > 0 
Local cCNPJCIOT   := ""

Private aUF       := {}
Private cCNPJEmiMN:= ''
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Preenchimento do Array de UF                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd(aUF,{"RO","11"})
aAdd(aUF,{"AC","12"})
aAdd(aUF,{"AM","13"})
aAdd(aUF,{"RR","14"})
aAdd(aUF,{"PA","15"})
aAdd(aUF,{"AP","16"})
aAdd(aUF,{"TO","17"})
aAdd(aUF,{"MA","21"})
aAdd(aUF,{"PI","22"})
aAdd(aUF,{"CE","23"})
aAdd(aUF,{"RN","24"})
aAdd(aUF,{"PB","25"})
aAdd(aUF,{"PE","26"})
aAdd(aUF,{"AL","27"})
aAdd(aUF,{"MG","31"})
aAdd(aUF,{"ES","32"})
aAdd(aUF,{"RJ","33"})
aAdd(aUF,{"SP","35"})
aAdd(aUF,{"PR","41"})
aAdd(aUF,{"SC","42"})
aAdd(aUF,{"RS","43"})
aAdd(aUF,{"MS","50"})
aAdd(aUF,{"MT","51"})
aAdd(aUF,{"GO","52"})
aAdd(aUF,{"DF","53"})
aAdd(aUF,{"SE","28"})
aAdd(aUF,{"BA","29"})
aAdd(aUF,{"EX","99"})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posiciona SM0                                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SM0->(MsSeek(cEmpAnt+cFilMan))

If cEvento == "I" //-- Envio Manifesto
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posiciona MDF                                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("DTX")
	DTX->(dbSetOrder(2))
	If DTX->(DbSeek(xFilial('DTX')+cFilMan+cNumMan+cSerman))

    	If DTX->(ColumnPos("DTX_NUMROM")) > 0
			cNumRom	:= DTX->DTX_NUMROM
		EndIf 
		
		cSertms  := Posicione("DTQ",2,xFilial("DTQ")+DTX->DTX_FILORI+DTX->DTX_VIAGEM,"DTQ_SERTMS")
		cTipTra  := Posicione("DTQ",2,xFilial("DTQ")+DTX->DTX_FILORI+DTX->DTX_VIAGEM,"DTQ_TIPTRA")

		cString := ''
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Header do Arquivo XML                                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cString += '<MDFe xmlns="http://www.portalfiscal.inf.br/mdfe">'

		aAdd(aXMLMDFe,AllTrim(cString))
				
		If aScan(aUF,{|x| x[1] ==  AllTrim(SM0->M0_ESTENT) }) != 0 // Confere se Uf do Emitente esta OK
			cCodUF := aUF[ aScan(aUF,{|x| x[1] == AllTrim(SM0->M0_ESTENT) }), 2]
		Else
			cCodUF := ''
		EndIf                                                
				
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Formato de Impressao do MDF-e                                   ³
		//³ 1 - Normal                                                      ³
		//³ 2 - Contingência                   								³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If cModalidade == '1'
			cTpEmis := '1'
		ElseIf cModalidade == '2'
			cTpEmis := '2'
		EndIf

		If !Empty(DTX->DTX_SERMAN)
	   		nSerieMDF := Val( AllTrim(DTX->DTX_SERMAN))
		EndIf 
		    
		If Empty(DTX->DTX_CHVMDF)
			cMDF := Inverte()
			cChvAcesso := MDFCHVAC( cCodUF,;
							   ( SubStr(DToS(DTX->DTX_DATMAN),3, 2) +  SubStr(DToS(DTX->DTX_DATMAN),5, 2) ),;
							    AllTrim(SM0->M0_CGC),;
								 '58',;
								 StrZero( nSerieMDF, 3),;
								 StrZero( val(PadR(DTX->DTX_MANIFE,9)), 9),;
								 cTpEmis + cMDF)
		Else
			cChvAcesso := DTX->DTX_CHVMDF
			cMDF := Substr(DTX->DTX_CHVMDF, 36, 8) 
		EndIf								 

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Inicio dos Dados do MDFe                                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cNFe    := 'MDFe' + AllTrim(cChvAcesso)
		cString := ''
					
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Versao do MDF-e, de acordo com o parametro                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cString += '<infMDFe Id="MDFe' + AllTrim(cChvAcesso) + '" versao="' + cVerAmb + '">'
								
		aAdd(aXMLMDFe,AllTrim(cString))
					
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ TAG: IDE -- Identificacao do MDF-e                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Identificacao do Ambiente.                                      ³
		//³ 1 - Producao                                                    ³
		//³ 2 - Homologacao                                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                         
		cString:= ""
		cString += '<ide>'
		cString += '<cUF>'  + NoAcentoCte( cCodUF )	 + '</cUF>'
		cString += '<tpAmb>' + cAmbiente + '</tpAmb>'          		
		cString += '<tpEmit>1</tpEmit>'   
		// tpTransp
		cAliasTrp := GetNextAlias()
		cQuery := ""
		cQuery += " SELECT A2_CGC, A2_NOME, DA3_FROVEI  " + CRLF		
		cQuery += " FROM " + RetSqlName("DA3") + " DA3 " + CRLF

		cQuery += " INNER JOIN " + RetSqlName("DUT") + " DUT " + CRLF
		cQuery += "   ON DUT.DUT_TIPVEI = DA3.DA3_TIPVEI " + CRLF
		cQuery += "   AND DUT.D_E_L_E_T_ = ' ' " + CRLF

		cQuery += " INNER JOIN " + RetSqlName("SA2") + " SA2 ON " + CRLF
		cQuery += "           SA2.A2_COD    = DA3.DA3_CODFOR AND " + CRLF
		cQuery += "           SA2.A2_LOJA   = DA3.DA3_LOJFOR AND " + CRLF
		cQuery += "           SA2.D_E_L_E_T_= '' " + CRLF

		cQuery += " WHERE DA3.DA3_FILIAL = '"+xFilial("DA3")+"'"  + CRLF
		cQuery += "   AND DA3.DA3_COD    = '"+DTX->DTX_CODVEI+"'" + CRLF
		cQuery += "   AND DA3.D_E_L_E_T_ = ' '"                  + CRLF
		cQuery += "   AND DUT.DUT_FILIAL = '"+xFilial('DUT')+"'" + CRLF
		cQuery += "   AND SA2.A2_FILIAL  = '"+xFilial('SA2')+"'" + CRLF
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTrp,.F.,.T.)

		If !(cAliasTrp)->(Eof()) .And. (cAliasTrp)->DA3_FROVEI <> '1'
			lTpTransp := .T.
			If Len(Alltrim((cAliasTrp)->A2_CGC)) > 11
				cString += '<tpTransp>1</tpTransp>'
			Else
				cString += '<tpTransp>2</tpTransp>'
			EndIf
		EndIf
		(cAliasTrp)->(dbCloseArea())

		cString += '<mod>58</mod>'               
		If !Empty(DTX->DTX_SERMAN)   
			cString += '<serie>' + Alltrim(Str(nSerieMDF)) + '</serie>'
		Else
			cString += '<serie>' + StrZero( nSerieMDF, 1) + '</serie>'
		EndIf		
		cString += '<nMDF>'+ NoAcentoCte( cValtoChar( Val( AllTrim(DTX->DTX_MANIFE) ) ) ) + '</nMDF>'

		cString += '<cMDF>'+ NoAcentoCte(Substr(cMDF,1,8)) + '</cMDF>'
		
		cString += '<cDV>' + SubStr( AllTrim(cChvAcesso), Len( AllTrim(cChvAcesso) ), 1) + '</cDV>'

		cString += '<modal>1</modal>'  //Rodoviario
		
		cString += '<dhEmi>'+ SubStr(DToS(DTX->DTX_DATMAN), 1, 4) + "-";
							+ SubStr(DToS(DTX->DTX_DATMAN), 5, 2) + "-";
							+ SubStr(DToS(DTX->DTX_DATMAN), 7, 2) + "T";
							+ SubStr(AllTrim(DTX->DTX_HORMAN), 1, 2) + ":";
							+ SubStr(AllTrim(DTX->DTX_HORMAN), 3, 2) + ":00";
							+ cTimeZone + '</dhEmi>'

		cString += '<tpEmis>' + cTpEmis + '</tpEmis>'

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Processo de Emissao do CT-e                                     ³
		//³ 0 - emissao com aplicativo do contribuinte                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cString += '<procEmi>0</procEmi>'
		
		cString += '<verProc>' + cVerAmb + '</verProc>'
		
		aAreaSM0 := SM0->(GetArea())
		If AliasInDic("DL0") 
			dbSelectArea("DL0")
			DL0->(dbSetOrder(2))
			If DL0->(MsSeek( FWxFilial("DL0")+ DTX->DTX_FILORI + DTX->DTX_VIAGEM ))
				cFilOri:= DTX->DTX_FILORI
				cViagem:= DTX->DTX_VIAGEM
			Else
				// Verifica se a viagem é coligada
				dbSelectArea("DTR")
				DTR->( DbSetOrder( 1 ) )
				If MsSeek(xFilial("DTR")  + DTX->DTX_FILORI + DTX->DTX_VIAGEM) .And. !Empty(DTR->DTR_NUMVGE)
					DL0->( DbSetOrder( 2 ) )
					If DL0->(MsSeek( FWxFilial("DL0")+DTR->DTR_FILVGE+DTR->DTR_NUMVGE ))   //Posiciona na viagem Principal
						cFilOri:= DTR->DTR_FILVGE
						cViagem:= DTR->DTR_NUMVGE
					EndIf
				EndIf
			EndIf
			
			DL0->(MsSeek( FWxFilial("DL0") + cFilOri + cViagem + Replicate("Z",Len(DL0->DL0_PERCUR)),.T.))
			DL0->(DbSkip(-1))

			dbSelectArea("DL1")
			DL1->(dbSetOrder(2))
			If DL1->(dbSeek( FWxFilial("DL1") + DL0->DL0_PERCUR + DTX->DTX_FILMAN + Iif(lDTX_PRMACO,Iif(!Empty(DTX->DTX_PRMACO),DTX->DTX_PRMACO,DTX->DTX_MANIFE),DTX->DTX_MANIFE) + DTX->DTX_SERMAN))		
				cUFIni 	  	:= DL1->DL1_UFORIG
				cCodUF		:= aUF[ aScan(aUF,{|x| x[1] == AllTrim(DL1->DL1_UFORIG) }), 2]
				cCdMunIni 	:= cCodUF + DL1->DL1_MUNMAN
				cCidIni   	:= Posicione("CC2",1,FWxFilial("CC2")+cUFIni+DL1->DL1_MUNMAN,"CC2_MUN" )
				cUFFIm    	:= DL1->DL1_UF
				lPerc 		:= .T.
				
				Aadd( aCdMunIni , { cCdMunIni , cCidIni } )
			EndIf
		EndIf
		
		If !lPerc
			cRota := Posicione("DTQ",2,xFilial("DTQ")+DTX->DTX_FILORI+DTX->DTX_VIAGEM,"DTQ_ROTA")		
			DA8->(DbSetOrder(1))
			If 	DA8->(MsSeek(xFilial("DA8")+cRota)) 
				DUY->(DbSetOrder(1))			
				If 	!Empty(DA8->DA8_CDOMDF) .And. DUY->(MsSeek(xFilial("DUY")+DA8->DA8_CDOMDF)) 
					cCodUF 	:= aUF[ aScan(aUF,{|x| x[1] == AllTrim(DUY->DUY_EST) }), 2] 			
					cUFIni 	:= DUY->DUY_EST
					cCdMunIni	:= AllTrim(cCodUF) + AllTrim(DUY->DUY_CODMUN)
					cCidIni   	:= DUY->DUY_DESCRI

					Aadd( aCdMunIni , { cCdMunIni , cCidIni } )

				EndIf
			EndIf                                     

			cFilOri		:= DTX->DTX_FILORI
			cViagem		:= DTX->DTX_VIAGEM
			cUFFIm   	:= Posicione("SM0",1,cEmpAnt+DTX->DTX_FILDCA,"M0_ESTENT")

		EndIf
		
		If Empty(cUFIni) .Or. Empty(cCdMunIni) .Or. Empty(cCidIni)
			cUFIni 		:= Posicione("SM0",1,cEmpAnt+DTX->DTX_FILMAN,"M0_ESTENT")
			cCdMunIni	:= Posicione("SM0",1,cEmpAnt+DTX->DTX_FILMAN,"M0_CODMUN")
			cCidIni  	:= Posicione("SM0",1,cEmpAnt+DTX->DTX_FILMAN,"M0_CIDENT")

			Aadd( aCdMunIni , { cCdMunIni , cCidIni } )

		EndIf
		
		If DTQ->DTQ_STATUS != StrZero(2,Len(DTQ->DTQ_STATUS))
			//--Verifica os municipios de carregamento de acordo com o DTA
			MunCarMan( cFilOri, cViagem , Iif(lDTX_PRMACO,Iif(!Empty(DTX->DTX_PRMACO),DTX->DTX_PRMACO,DTX->DTX_MANIFE),DTX->DTX_MANIFE) , DTX->DTX_SERMAN , cSerTms , aUF, @aCdMunIni )
		EndIf 
		RestArea(aAreaSM0)
		
		cString += '<UFIni>' + NoAcentoCte(cUFIni) + '</UFIni>' 
		
		// Verifica se é viagem de Entrega
		If cSertms = '3' .Or. (cSertms = '2' .And. DTX->DTX_FILDCA = cFilAnt) .Or. __lPyme
			If !lPerc
				// Busca ultimo doc sequenciado do manifesto posicionado
				// Para este tratamento é necessario que o manifesto tenha sido gerado por ESTADO.
				cAliasDUD := GetNextAlias()
				cQuery := "SELECT Max(DUD_SEQUEN) MAX_SEQUEN, DUD_CDRCAL, DUD_SERTMS, DUD_FILDCA "			
				cQuery += "  FROM " + RetSQLName("DUD") + " DUD "
				cQuery += " WHERE DUD.DUD_FILIAL  = '"+xFilial("DUD")+"'"
				cQuery += "	  AND DUD.DUD_FILORI  = '"+DTX->DTX_FILORI+"'"			
	    		If __lPyme 
					cQuery += "	  AND DUD.DUD_NUMROM  = '" + cNumRom + "'"	
				EndIf
				cQuery += "	  AND DUD.DUD_FILMAN  = '" + DTX->DTX_FILMAN + "'"
				If lDTX_PRMACO
					cQuery += "	  AND DUD.DUD_MANIFE  = '" + Iif(!Empty(DTX->DTX_PRMACO),DTX->DTX_PRMACO,DTX->DTX_MANIFE) + "'"
				Else
					cQuery += "	  AND DUD.DUD_MANIFE  = '" + DTX->DTX_MANIFE + "'"
				EndIf
				cQuery += "	  AND DUD.D_E_L_E_T_  = ' '"
				cQuery += " GROUP BY DUD_CDRCAL, DUD_SERTMS, DUD_FILDCA"
	
				cQuery := ChangeQuery(cQuery)
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDUD)		
				
				If !(cAliasDUD)->(Eof())
					//Em caso de Viagem de Transferencia coligada a Viagem de Entrega, e o documento da viagem de TRansferencia estar em ultimo,
					//buscar o Servico e a Filial de Descarga, e usa-los para determinar a UFFIM.
					If (cAliasDUD)->DUD_SERTMS == StrZero(2,Len(DUD->DUD_SERTMS))
						cUFFIm   := Posicione("SM0",1,cEmpAnt+(cAliasDUD)->DUD_FILDCA,"M0_ESTENT")
					Else // Em viagem de Entrega a UF Fim vem da regiao de Calculo
						cUFFIm   := Posicione("DUY",1, xFilial('DUY')+(cAliasDUD)->DUD_CDRCAL ,"DUY_EST")
					EndIf				
				EndIf
				(cAliasDUD)->(dbCloseArea())	
			EndIf		
		Else		
			// Em Viagem de Transferencia o descarregamento ocorre na mesma filial (SM0).
			aAreaSM01 := SM0->(GetArea())
			cUFFIm   := Posicione("SM0",1,cEmpAnt+DTX->DTX_FILDCA,"M0_ESTENT")
			RestArea(aAreaSM01)
		EndIf
		
		//MLOG-3026 - Busca da UF do Parceiro. Esta UF sera considerada como UF Fim do Manifesto
		If FindFunction("TMS190UFRD")
			cAliasDUD2 := GetNextAlias()
			cQuery := "SELECT DUD_NUMRED "
			cQuery += "  FROM " + RetSQLName("DUD") + " DUD "
			cQuery += " WHERE DUD.DUD_FILIAL  = '"+xFilial("DUD")+"'"
			cQuery += "	  AND DUD.DUD_FILORI  = '"+DTX->DTX_FILORI+"'"
			If __lPyme 
				cQuery += "	  AND DUD.DUD_NUMROM  = '" + cNumRom + "'"	
			EndIf
			cQuery += "	  AND DUD.DUD_FILMAN  = '" + cFilMan + "'"
			cQuery += "	  AND DUD.DUD_MANIFE  = '" + cNumMan + "'"
			cQuery += "	  AND DUD.D_E_L_E_T_  = ' '"

			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDUD2)		
			If (cAliasDUD2)->(!Eof())
				cNumRed := (cAliasDUD2)->DUD_NUMRED
			EndIf
			(cAliasDUD2)->(dbCloseArea())

			//MLOG-3026 - Busca da UF do Parceiro. Esta UF sera considerada como UF Fim do Manifesto
			a190UFRD := TMS190UFRD("2", cSertms, cNumRed)
			If Len(a190UFRD) > 0
				cUFFim   := a190UFRD[1]
				cCdMnRed := a190UFRD[2]
				cNmMnRed := a190UFRD[3]
			EndIf			
		EndIf						
		
		cString += '<UFFim>' + NoAcentoCte(cUFFIm) + '</UFFim>'   
		
		For nCdMunIni := 1 To Len(aCdMunIni)
			
			cCdMunIni	:= aCdMunIni[nCdMunIni,1]
			cCidIni		:= aCdMunIni[nCdMunIni,2]

			cString += '<infMunCarrega>'  
			cString += '<cMunCarrega>' + NoAcentoCte(cCdMunIni) + '</cMunCarrega>'  
			cString += '<xMunCarrega>' + NoAcentoCte(cCidIni) 	+ '</xMunCarrega>'
			cString += '</infMunCarrega>' 

		Next nCdMunIni
	                                                         
		cUFPer:= "'" + AllTrim(DTX->DTX_FILMAN) + "','" + AllTrim(DTX->DTX_FILDCA) + "'"  //Uf Inicial e Final do Manifesto 
	
		If !__lPyme 	                               
			DTQ->(DbSetOrder(2))
			If DTQ->(MsSeek(xFilial("DTQ")+DTX->DTX_FILORI+DTX->DTX_VIAGEM))   	
				If lPerc
					dbSelectArea("DL1")
						If DTQ->DTQ_STATUS =='2' //Em Transito, posiciona na tabela DL1 o RECNO que coincidir com UF Origem/Destino do MDF-e 
							DL1->(dbSetOrder(4))
							DL1->(dbSeek(FWxFilial("DL1") + DL0->DL0_PERCUR + cUFFim + cUFIni))
							nRecDL1 := DL1->(Recno())
						Else
							DL1->(dbSetOrder(3))
						    DL1->(dbSeek(FWxFilial("DL1") + DL0->DL0_PERCUR + cUFIni  ))
							nRecDL1 := DL1->(Recno())
						EndIf
						
						DL1->(dbSetOrder(5))
						DL1->(dbGoto(nRecDL1))
						DL1->(DbSkip())
						While (DL1->DL1_PERCUR == DL0->DL0_PERCUR .AND. !(DL1->DL1_UF == cUFFim .AND. DL1->DL1_FILMAN + DL1->DL1_MANIFE  == DTX->DTX_FILMAN + Iif(lDTX_PRMACO,Iif(!Empty(DTX->DTX_PRMACO),DTX->DTX_PRMACO,DTX->DTX_MANIFE),DTX->DTX_MANIFE)) )
							Aadd( aPercurso, DL1->DL1_UF )	
							DL1->(DbSkip())
						EndDo			
				Else
					If cUFIni<>cUFFIm 	
						// Verifica se utiliza Percursos do MDF-e, caso contrario verifica Regioes da Rota
						// Verifica se a rota é de Roteiro
						If FindFunction("F11RotRote")
							lRoteiro := F11RotRote(DTQ->DTQ_ROTA)
						EndIf
						
						cAliasDIQ := GetNextAlias()
						cQuery := " SELECT DIQ_EST "
						cQuery += "   FROM " + RetSqlName("DIQ")
						cQuery += "  WHERE DIQ_FILIAL = '" + xFilial('DIQ') + "' "
						cQuery += "    AND DIQ_ROTA = '" + DTQ->DTQ_ROTA + "' "  
						
						// Adiciona a busca por roteiro
						If lRoteiro .AND. DTQ->(ColumnPos("DTQ_ROTEIR")) > 0
							If !Empty(DTQ->DTQ_ROTEIR)
								cQuery += "    AND DIQ_ROTEIR = '" + DTQ->DTQ_ROTEIR + "' " 
							EndIf
						EndIf
						
						cQuery += "    AND D_E_L_E_T_ = ' ' "
						cQuery += "  ORDER BY DIQ_SEQUEN "
						cQuery := ChangeQuery(cQuery)
						dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDIQ)
						
						While !(cAliasDIQ)->(Eof())
							lPercMDFe:= .T.
								
							If (cAliasDIQ)->DIQ_EST <> cUFIni
								Aadd( aPercurso, (cAliasDIQ)->DIQ_EST )							
							EndIf
								
							// /inclui ultimo estado do percursos referente ao manifesto atual
							If (cAliasDIQ)->DIQ_EST == cUFFim 
								Exit
							EndIf
								
							(cAliasDIQ)->(DbSkip())
						EndDo						
						(cAliasDIQ)->(DbCloseArea())			
					EndIf
				EndIf
				If cUFIni<>cUFFIm 
					If DTQ->DTQ_SERTMS == StrZero(2,Len(DTQ->DTQ_SERTMS));
							.And. Len(aPercurso) == 0 .And. !lPerc .And. !lPercMDFe  //--- Somente se não for Percurso (DL1) e não existir nenhum registro na tabela DIQ 
						
						cAliasDUN := GetNextAlias()
						cQuery := " SELECT DUN_CDRDCA "
						cQuery += "   FROM " + RetSqlName("DUN") 
						cQuery += " WHERE DUN_FILIAL = '" + xFilial('DUN') + "' "
						cQuery += "   AND DUN_ROTEIR = '" + DTQ->DTQ_ROTA + "' "  
						cQuery += "   AND D_E_L_E_T_ = ' ' "
						cQuery += " ORDER BY DUN_ROTEIR, DUN_SEQUEN "
						cQuery := ChangeQuery(cQuery)
						dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDUN)		
						While (cAliasDUN)->(!Eof())                    
							DUY->(DbSetOrder(1))
							If DUY->(MsSeek(xFilial("DUY")+(cAliasDUN)->DUN_CDRDCA))
								If DUY->DUY_EST <> cUFIni .And. DUY->DUY_EST <> cUFFim
									Aadd( aPercurso, DUY->DUY_EST )
								EndIf
							EndIf
							(cAliasDUN)->(DbSkip())
						EndDo						
						(cAliasDUN)->(DbCloseArea())
						
					EndIf
					
					If Len(aPercurso) > 0	            
						For nCount:= 1 to Len(aPercurso)
							If cUFFim != aPercurso[nCount] .OR. Len(aPercurso) != nCount
								If nCount <= 25
									cString += '<infPercurso>' 
									cString += '<UFPer>' + NoAcentoCte( aPercurso[nCount] ) + '</UFPer>'
									cString += '</infPercurso>'
								EndIf
							Else 
								nCount := Len(aPercurso)
							EndIf						
						Next nCount
					EndIf
				EndIf
			EndIf                      
			
		Else  // Caso seja serie 3      
			If AliasInDic("DJ1")
			   	If cUFIni<>cUFFIm                              
			
					cAliasDJ1 := GetNextAlias()
					cQuery := " SELECT DJ1_EST "
					cQuery += "   FROM " + RetSqlName("DJ1")
					cQuery += "  WHERE DJ1_FILIAL = '" + xFilial('DJ1') + "' "
					cQuery += "    AND DJ1_NUMROM = '" + cNumRom + "' "  
					cQuery += "    AND D_E_L_E_T_ = ' ' "
					cQuery += "  ORDER BY DJ1_SEQUEN "
					cQuery := ChangeQuery(cQuery)
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDJ1)
					
					While !(cAliasDJ1)->(Eof())
					
						If (cAliasDJ1)->DJ1_EST <> cUFIni
							If ( nPos:= Ascan(aPercurso, { | x | x == (cAliasDJ1)->DJ1_EST } ) ) == 0   //Nao repetir a mesma UF 
								Aadd( aPercurso, (cAliasDJ1)->DJ1_EST )
							EndIf
							
						EndIf
						
						// /inclui ultimo estado do percursos referente ao manifesto atual
						If (cAliasDJ1)->DJ1_EST == cUFFim
							Exit
						EndIf
						
						(cAliasDJ1)->(DbSkip())
					EndDo						
					(cAliasDJ1)->(DbCloseArea())
			
					If Len(aPercurso) > 0	            
						For nCount:= 1 to Len(aPercurso)
							If cUFFim <>aPercurso[nCount]
								If nCount <= 25
									cString += '<infPercurso>' 
									cString += '<UFPer>' + NoAcentoCte( aPercurso[nCount] ) + '</UFPer>'
									cString += '</infPercurso>'
								EndIf
							Else 
								nCount := Len(aPercurso)
							EndIf						
						Next nCount
					EndIf
				EndIf                   
			Else
				MsgAlert("Favor rodar o compatibilizador TMS11R159")
			EndIf
		EndIf
		cAliasDTR := GetNextAlias()                           
		                                              
		cQuery    := "SELECT DTR_DATINI, DTR_HORINI  "
		cQuery    += " FROM " + RetSqlName("DTR")+" DTR "
		cQuery    += " WHERE DTR_FILIAL = '"+xFilial('DTR')+"'"
		cQuery    += "   AND DTR_FILORI = '"+DTX->DTX_FILORI+"'"
		cQuery    += "   AND DTR_VIAGEM = '"+DTX->DTX_VIAGEM+"'"
		cQuery    += "   AND DTR.D_E_L_E_T_ = ' '"
		cQuery    := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDTR,.F.,.T.)

		If !Empty((cAliasDTR)->DTR_DATINI) 
			cString += '<dhIniViagem>'+ SubStr((cAliasDTR)->DTR_DATINI, 1, 4) + "-";
								+ SubStr((cAliasDTR)->DTR_DATINI, 5, 2) + "-";
								+ SubStr((cAliasDTR)->DTR_DATINI, 7, 2) + "T";
								+ SubStr(AllTrim((cAliasDTR)->DTR_HORINI), 1, 2) + ":";
								+ SubStr(AllTrim((cAliasDTR)->DTR_HORINI), 3, 2) + ":00";
								+ cTimeZone + '</dhIniViagem>'
		EndIf
		
		(cAliasDTR)->(dbCloseArea())
        cString += '</ide>'
		aAdd(aXMLMDFe,AllTrim(cString))
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ TAG: Emit -- Identificacao do Emitente do Manifesto              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cString := ''
		cString += '<emit>'

		If SM0->M0_TPINSC == 3 //CPF
			cString += '<CPF>' + NoPontos(SM0->M0_CGC) + '</CPF>'
		Else
			cString += '<CNPJ>' + NoPontos(SM0->M0_CGC) + '</CNPJ>'
		EndIf
		cCNPJEmiMN := NoPontos(SM0->M0_CGC)
		
		If (AllTrim(SM0->M0_INSC) == 'ISENTO')
			cString += '<IE>ISENTO</IE>'
		Else
			cString += '<IE>' + NoPontos(SM0->M0_INSC) + '</IE>'
		EndIf
		
		cString += '<xNome>' + NoAcentoCte(SubStr(SM0->M0_NOMECOM,1,60)) + '</xNome>'
		cString += '<xFant>' + NoAcentoCte(SM0->M0_NOME) + '</xFant>'
		cString += '<enderEmit>'
		cString += '<xLgr>' + NoAcentoCte(FisGetEnd(SM0->M0_ENDENT)[1]) + '</xLgr>'
		cString += '<nro>'  + Iif(FisGetEnd(SM0->M0_ENDENT)[2]<>0, AllTrim(cValtoChar( FisGetEnd(SM0->M0_ENDENT)[2])),"S/N") + '</nro>'
		If !Empty(NoAcentoCte(FisGetEnd(SM0->M0_ENDENT)[4]))
			cString += '<xCpl>' + NoAcentoCte(FisGetEnd(SM0->M0_ENDENT)[4]) + '</xCpl>'
		EndIf
		If Empty(AllTrim(SM0->M0_BAIRENT))
			cString += '<xBairro>BAIRRO NAO CADASTRADO</xBairro>'
		Else
			cString += '<xBairro>' + NoAcentoCte( SM0->M0_BAIRENT ) + '</xBairro>'
		EndIf
					
		cString += '<cMun>' + NoAcentoCte( SM0->M0_CODMUN ) + '</cMun>'
		cString += '<xMun>' + NoAcentoCte( SM0->M0_CIDENT ) + '</xMun>'
		cString += '<CEP>'  + NoAcentoCte( SM0->M0_CEPENT ) + '</CEP>'
		cString += '<UF>'   + NoAcentoCte( SM0->M0_ESTENT ) + '</UF>'
		If !Empty (NoPontos(SM0->M0_TEL))
			cString += '<fone>' + cValtoChar(NoPontos(SM0->M0_TEL))      + '</fone>'
		EndIf
		cString += '</enderEmit>'
		cString += '</emit>'

		aAdd(aXMLMDFe,AllTrim(cString))

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ TAG: InfModal -- Informacoes do modal Rodoviario                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cString:= ""
		cString += '<infModal versaoModal="'+cVerAmb+'">'
		cString += '<rodo>'
		cString += '<infANTT>'	
		If !Empty(cTmsAntt)	
			cString += '<RNTRC>' + SubStr(AllTrim(cTmsAntt),1,8) + '</RNTRC>'
		EndIf
		If !__lPyme
			If DTR->(ColumnPos('DTR_CIOT')) > 0
				cAliasDTR := GetNextAlias()		                                              
				
				If lMDFeInt
					cQuery    := "SELECT DTQ_FILORI, DTR_VIAGEM, DTQ_IDOPE, DTR_CIOT, DTR_PRCTRA, DTR_CODOPE, DTR_VALPDG, DTR_ITEM, DTR_CODFOR, DTR_LOJFOR, DTR_TPSPDG, DTR_ADIFRE"
				Else
					cQuery    := "SELECT DTQ_FILORI, DTR_VIAGEM, DTQ_IDOPE, DTR_CIOT, DTR_PRCTRA, DTR_CODOPE, DTR_VALPDG, DTR_ITEM, DTR_ADIFRE "
				EndIf

				If lCnpjOP
					cQuery+= ", DTR_CNPJOP	"
				EndIf
				
				If lCnpjPg
					cQuery += ", DTR_CNPJPG "
				EndIf 

				If lForOpe
					cQuery += ", DTR_FOROPE, DTR_LOJOPE, DTR_FORPDG, DTR_LOJPDG "
				EndIf 
				
				If lForCTO
					cQuery += ", DTR_FORCTO, DTR_LOJCTO "
				EndIf
				cQuery    += " FROM " + RetSqlName("DTR")+" DTR "
				
				cQuery	  += " INNER JOIN " + RetSQLName("DTQ") + " DTQ "
				cQuery 	  += " 	 ON	 DTQ.DTQ_FILORI = DTR.DTR_FILORI "
				cQuery	  += "	 AND DTQ.DTQ_VIAGEM = DTR.DTR_VIAGEM "
				cQuery 	  += "   AND DTQ_FILIAL = '" +xFilial('DTQ')+"'"
				cQuery 	  += "	 AND DTQ.D_E_L_E_T_ = ' ' "
				
				cQuery    += " WHERE DTR_FILIAL = '"+xFilial('DTR')+"'"
				cQuery    += "   AND DTR_FILORI = '"+DTX->DTX_FILORI+"'"
				cQuery    += "   AND DTR_VIAGEM = '"+DTX->DTX_VIAGEM+"'"
				cQuery    += "   AND DTR.D_E_L_E_T_ = ' '"
				cQuery    := ChangeQuery(cQuery)
				
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDTR,.F.,.T.)

				DEG->(DbSetOrder(1))
				If DEG->(MsSeek(xFilial('DEG')+(cAliasDTR)->DTR_CODOPE))
					cCNPJOPer := NoPontos(DEG->DEG_CNPJOP)
					SA2->( dbSetOrder(1) )
					If SA2->( dbSeek( xFilial("SA2")+DEG->DEG_CODFOR+DEG->DEG_LOJFOR))
						cA2_Nome:= SA2->A2_NOME
					EndIf
					cBanco  := DEG->DEG_BANCO
					cAgencia:= DEG->DEG_AGENCI
					lDEGOP	:= .T.
				ElseIf lForOpe
					SA2->( dbSetOrder(1) )
					If SA2->( dbSeek( xFilial("SA2")+(cAliasDTR)->DTR_FOROPE+(cAliasDTR)->DTR_LOJOPE))
						cA2_Nome  := SA2->A2_NOME
						cBanco    := SA2->A2_BANCO
						cAgencia  := SA2->A2_AGENCIA
						cA2_Tipo  := SA2->A2_TIPO
						cCNPJOPer := NoPontos(SA2->A2_CGC)
						cCondPag  := SA2->A2_COND
						lVgCNPJOpe:= .T.
					EndIf
					cA2_CGCPdg := NoPontos(Posicione("SA2",1,xFilial("SA2")+(cAliasDTR)->DTR_FORPDG+(cAliasDTR)->DTR_LOJPDG,"A2_CGC"))
				EndIf
				
				If lForCTO .And. !lDEGOP
					SA2->( dbSetOrder(1) )
					If SA2->( dbSeek( xFilial("SA2")+(cAliasDTR)->DTR_FORCTO+(cAliasDTR)->DTR_LOJCTO))
						cCNPJCIOT := NoPontos(SA2->A2_CGC) //Número do CNPJ da empresa responsável pela geração do CIOT, quando não houver operadora de frota 
					EndIf
				EndIf

				If Empty(cCNPJOPer) .And. lCnpjOP .And. !lForOpe
					cCNPJOPer := NoPontos((cAliasDTR)->DTR_CNPJOP)
				EndIf

				If lMDFeInt
					cCodForn	:= (cAliasDTR)->DTR_CODFOR
					cLojForn	:= (cAliasDTR)->DTR_LOJFOR
				EndIf

				If (cAliasDTR)->DTR_ADIFRE > 0
					nValAdto := (cAliasDTR)->DTR_ADIFRE
				EndIf

				If !Empty((cAliasDTR)->DTR_CIOT)
					cString += '<infCIOT>'
					cString += '<CIOT>' + SubStr(AllTrim((cAliasDTR)->DTR_CIOT),1,12) + '</CIOT>'
					If lForCTO .And. !lDEGOP
						cString += '<CNPJ>' +  cCNPJCIOT + '</CNPJ>'
					Else
						cString += '<CNPJ>' +  cCNPJOPer + '</CNPJ>'
					EndIf
					cString += '</infCIOT>'
					lCIOT:= .T.
				EndIf
				
				If !lForOpe .And. lCnpjPg
					cCNPJOPpdg:= (cAliasDTR)->DTR_CNPJPG
				ElseIf lForOpe .And. lCnpjPg .AND. lDEGOP
					cCNPJOPpdg:=  cCNPJOPer
					lDEGOP	:= .F.
				Else
					cCNPJOPpdg:= cA2_CGCPdg
				EndIf

				If !Empty(cCNPJOPer) // CNPJ da empresa de Vale Pedágio informada manualmente no campo DTR_FOROPE 
					cString += '<valePed>'
					cString += '<disp>'						
					cString += '<CNPJForn>' + cCNPJOPer + '</CNPJForn>'		    //-- Preenchimento do CNPJ da empresa Fornecedora do Vale Pedagio - Repom, Pamcard, Etc - IPEF's
					If Empty((cAliasDTR)->DTR_CODOPE) .And. !Empty(cCNPJOPpdg) //-  Responsável pelo Pagamento do Pedágio - Somente utilizado quando o pagador do pedagio não é o Emitente do MDF-e
						cString += '<CNPJPg>' + NoPontos(cCNPJOPpdg) + '</CNPJPg>'
					EndIf 
					
					If (cAliasDTR)->DTR_CODOPE == '01' .Or. Empty((cAliasDTR)->DTR_CODOPE)
						cString += '<nCompra>' 	+ Substr(AllTrim((cAliasDTR)->DTR_PRCTRA),1,20) + '</nCompra>' //--Numero da Compra (DTR_PRCTRA)
					ElseIf (cAliasDTR)->DTR_CODOPE == '02'
						cString += '<nCompra>' 	+ AllTrim((cAliasDTR)->DTQ_IDOPE) + '</nCompra>' //--Numero da Compra (DTQ_IDOPE)								
					EndIf
						
					cString += '<vValePed>' + ConvType((cAliasDTR)->DTR_VALPDG, 13, 2) + '</vValePed>'//--Valor do vale-pedágio (DTR_VALPDG)							
					
					If lMDFeInt

						Do Case
							Case (cAliasDTR)->DTR_TPSPDG == '4'
								cTpValePed := "01" //-- TAG
							Case(cAliasDTR)->DTR_TPSPDG == '1'
								cTpValePed := "02" //-- Cupom
							Case (cAliasDTR)->DTR_TPSPDG ==	'3' 						
								cTpValePed := "03" //-- Cartão
							Case (cAliasDTR)->DTR_TPSPDG ==	'5'   //Pamcard
								cTpValePed := "03" //-- Cartão
							Case (cAliasDTR)->DTR_TPSPDG ==	'6'   //Tag								
								cTpValePed := "01" //-- TAG

						EndCase

						If !Empty(cTpValePed)
							cString += '<tpValePed>' + cTpValePed + '</tpValePed>'//--Tipo do vale-pedágio (DTR_TPSPDG)							
						EndIf
						
						nQtdEixo :=  QtdEixVei(DTX->DTX_FILORI, DTX->DTX_VIAGEM)
					
					EndIf

					cString += '</disp>'
					
					If lMDFeInt
						Do Case
							Case nQtdEixo = 2
								cCatCobVei := '02'  //-- Veículo Comercial 2 eixos;
							Case nQtdEixo = 3
								cCatCobVei := '04' //--Veículo Comercial 3 eixos;
							Case nQtdEixo = 4
								cCatCobVei := '06' //--Veículo Comercial 4 eixos;
							Case nQtdEixo = 5
								cCatCobVei := '07' //--Veículo Comercial 5 eixos;
							Case nQtdEixo = 6
								cCatCobVei := '08' //--Veículo Comercial 6 eixos;
							Case nQtdEixo = 7
								cCatCobVei := '10' //--Veículo Comercial 7 eixos;
							Case nQtdEixo = 8
								cCatCobVei := '11' //--Veículo Comercial 8 eixos;
							Case nQtdEixo = 9
								cCatCobVei := '12' //--Veículo Comercial 9 eixos;
							Case nQtdEixo = 10
								cCatCobVei := '13' //--Veículo Comercial 10 eixos;
							Case nQtdEixo > 10
								cCatCobVei := '14' //--Veículo Comercial Acima de 10 eixos;
						EndCase
						If !Empty(cCatCobVei)
							cString += '<categCombVeic>' + cCatCobVei + '</categCombVeic>'//--Qtd Eixo no Veiculo (DA3_QTDEIX)							
						EndIf
					EndIf

					cString += '</valePed>'
				EndIf		 

				aRetDA4:= RetInfMot(DTX->DTX_FILORI,DTX->DTX_VIAGEM,(cAliasDTR)->DTR_ITEM)

				(cAliasDTR)->(dbCloseArea())		
			EndIf
		EndIF		
		
		cAliasCLI := GetNextAlias()
		cQuery := " SELECT DISTINCT SA1.A1_NOME, SA1.A1_CGC, SA1.A1_PESSOA, SA1.A1_PFISICA, SA1.A1_EST"
		cQuery += " FROM "
		cQuery += RetSqlName('DUD')+" DUD, "
		cQuery += RetSqlName('DT6')+" DT6, "
		cQuery += RetSqlName('SA1')+" SA1  "
		cQuery += " WHERE DUD.DUD_FILIAL  = '"+xFilial("DUD")+"'"
		cQuery += "		AND DUD.DUD_FILORI  = '"+DTX->DTX_FILORI+"'"
	    If __lPyme 
			cQuery += "	  AND DUD.DUD_NUMROM  = '"+cNumRom+"'"	
        EndIf
		cQuery += "		AND DUD.DUD_FILMAN  = '"+DTX->DTX_FILMAN+"'"
		If lDTX_PRMACO
			cQuery += "		AND DUD.DUD_MANIFE  = '"+Iif(!Empty(DTX->DTX_PRMACO),DTX->DTX_PRMACO,DTX->DTX_MANIFE)+"'"
		Else
			cQuery += "		AND DUD.DUD_MANIFE  = '"+DTX->DTX_MANIFE+"'"
		EndIf
		cQuery += "		AND DUD.DUD_SERMAN  = '"+DTX->DTX_SERMAN+"'"
		cQuery += "     AND DUD.DUD_STATUS <> '" + StrZero(9,Len(DUD->DUD_STATUS)) + "'" //Cancelado
		cQuery += "		AND DUD.D_E_L_E_T_  = ' '"
		cQuery += "		AND DT6.DT6_FILIAL  = '"+xFilial("DT6")+"'"
		cQuery += "		AND DT6.DT6_FILDOC  = DUD.DUD_FILDOC "
		cQuery += "		AND DT6.DT6_DOC     = DUD.DUD_DOC"
		cQuery += "		AND DT6.DT6_SERIE   = DUD.DUD_SERIE"
		cQuery += "		AND DT6.D_E_L_E_T_  = ' '"
		
		cQuery += "		AND SA1.A1_FILIAL  = '"+xFilial("SA1")+"'"		
		cQuery += "		AND SA1.A1_COD = DT6.DT6_CLIDEV"		
		cQuery += "		AND SA1.A1_LOJA = DT6.DT6_LOJDEV"
		cQuery += "		AND SA1.D_E_L_E_T_  = ' '"		
		
		cQuery := ChangeQuery(cQuery)
		DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAliasCLI,.T.,.T.)
		
		If lTpTransp //verificar o tpprop
			cString += '<infContratante>'
			cString += '<xNome>' + NoAcentoCte(SubStr(SM0->M0_NOMECOM, 1, 60)) + '</xNome>'
			cString += '<CNPJ>'+ NoPontos(SM0->M0_CGC)+'</CNPJ>'
			cString += '</infContratante>'
		Else		
			While (cAliasCLI)->(!Eof())	
				cString += '<infContratante>'
				cString += '<xNome>' + NoAcentoCte((cAliasCLI)->A1_NOME) + '</xNome>'
				If 	(cAliasCLI)->A1_EST == 'EX'
					cString += '<idEstrangeiro>'+NoPontos((cAliasCLI)->A1_PFISICA)+'</idEstrangeiro>'
				ElseIf 	(cAliasCLI)->A1_PESSOA == 'F'
					cString += '<CPF>'+NoPontos((cAliasCLI)->A1_CGC)+'</CPF>'
				Else
					cString += '<CNPJ>'+ NoPontos((cAliasCLI)->A1_CGC)+'</CNPJ>'
				EndIF	
				cString += '</infContratante>'

				(cAliasCLI)->(dbSkip())
			EndDo
			(cAliasCLI)->(dbCloseArea())	
		EndIf
		////////////////////////////////////////////////////////////////////////////////////////////
		//  TAG: InfPag -- Grupo Informacoes do Pagamento de Frete         
		//  **** Informações InfPag será gerada para viagem com CIOT ou com informações
		//  do Fornecedor da Operacao da Viagem (DTR_FOROPE/DTR_LOJOPE) e Frota Terceiro/Agregado
		////////////////////////////////////////////////////////////////////////////////////////////
				
		If ExistFunc("TMSMonPrev") .And. (lCIOT .Or. lVgCNPJOpe) .And. Len(aRetDA4) > 0 .And. Len(aRetDA4[1]) > 0 .And. aRetDA4[1][4] $ "2,3"  //2-Terceiro,3-Agregado		
			aAreaAnt:= GetArea()
			aFretPag:= aClone(TMSMonPrev(DTX->DTX_FILORI,DTX->DTX_VIAGEM))  
			RestArea(aAreaAnt)
			nC:= Len(aFretPag)
			
			If nC  > 0 .And. aFretPag[1]  //Preview do Frete  a Pagar efetuado com sucesso
				cString += '<infPag>'

				cString += '<xNome>' + NoAcentoCte(SubStr(cA2_Nome,1,60))  + '</xNome>'
				If cA2_EST == 'EX' 
					cString += '<idEstrangeiro>' + NoPontos(cA2_PFisica) + '</idEstrangeiro>'							
				ElseIf cA2_Tipo == 'F'	
					cString += '<CPF>' + NoPontos(cA2_CGC) + '</CPF>'		
				ElseIf !Empty(cCNPJOPer) 						
					cString += '<CNPJ>' + NoPontos(cCNPJOPer) + '</CNPJ>'	//Tratar quando for para todos, independente Operadora
				Else
					cString += '<CNPJ>' + NoPontos(cA2_CGC) + '</CNPJ>'	
				EndIf	

				nValImp := 0
				nValPdg := 0
				nValFre := 0
				If nC > 0
					For nC1:= 1 To Len(aFretPag[4][1])
						If AllTrim(aFretPag[4][1][nC1][1]) $ 'IRRF|INSS|SEST|ISS|PIS|COF|SENA'  //- Valor Impostos, Taxas e Contribuicoes
							nValImp+= 	aFretPag[4][1][nC1][2]	
						ElseIf AllTrim(aFretPag[4][1][nC1][1]) $ 'VALPDG'   //- Valor do Pedagio
							nValPdg:= 	aFretPag[4][1][nC1][2]	
						ElseIf AllTrim(aFretPag[4][1][nC1][1]) $ 'VALFRETE' //- Valor do Frete
							nValFre:= aFretPag[4][1][nC1][2]	
						EndIf	
					Next nC1

					nValTotFre := 0		
					For nC:= 1 to 4   //01-Vale Pedagio, 02-Impostos, Taxas e Contribuicoes, 03-Despesas, 99-Outros		
						nValComp:= 0			
						If nC == 1    //01- Vale Pedagio
							nValComp:= nValPdg
						ElseIf nC == 2  //-- 02-Impostos, Taxas e Contribuicoes
							nValComp:= nValImp
						ElseIf nC == 3  //-- 03-Despesas
							nValComp:= 0
						ElseIf nC == 4  // 99-Outros
							If Len(aFretPag[3]) > 0
								For nC1:= 1 To Len(aFretPag[3][1][2])
									If aFretPag[3][1][2][nc1][3]  <> 'TF'  //Total do Frete
										nValComp+= aFretPag[3][1][2][nc1][2]
										cXComp := NoAcentoCte(SubStr(aFretPag[3][1][2][nc1][1] ,1,60))
										
										cString += '<Comp>'
										cString += '<tpComp>99</tpComp>' 
										cString += '<vComp>' + ConvType(aFretPag[3][1][2][nc1][2], 13, 2)  + '</vComp>'
										cString += '<xComp>' + NoAcentoCte(SubStr(cXComp ,1,60)) + '</xComp>'  
										cString += '</Comp>'
									
									EndIf
								Next nC1
							Else
								lFrtZero := .T.
								nValComp := nValFre
							EndIf

							If (nValComp > 0) .And. (Len(aFretPag[3]) = 0)
								cString += '<Comp>'
								cString += '<tpComp>99</tpComp>' 
								cString += '<vComp>' + ConvType(nValComp, 13, 2)  + '</vComp>'
								cString += '</Comp>'

								lTagComp:= .T.
							EndIf

						EndIf

						If nC <> 4 .And. nValComp > 0 // 99-Outros
							cString += '<Comp>'
							cString += '<tpComp>' + StrZero(nC,2) + '</tpComp>' 
							cString += '<vComp>' + ConvType(nValComp, 13, 2)  + '</vComp>'
							cString += '</Comp>'
							lTagComp:= .T.
						EndIf

						nValTotFre += nValComp
						
					Next nC
					
					aSize(aFretPag, 0)
					aFretPag := Nil
				EndIf	

				cString += '<vContrato>' + ConvType(nValTotFre, 13, 2) + '</vContrato>'
				// SEFAZ valida o valor considerando na conta o valor do adiantamento
				// por isso subtraimos o valor do adiantamento do total do frete para
				// que os valores das parcelas fiquem de acordo com a regra da SEFAZ
				If !Empty(cCondPag)
					aVenctos := Condicao( nValTotFre - nValAdto, cCondPag, , dDataBase ) 
					nTipoPag := If (Len(aVenctos) > 1, 1, 0) //0-Pagamento a Vista, 1-Pagamento a Prazo 
				EndIf
				
				cString += '<indPag>'+ StrZero( nTipoPag, 1) + '</indPag>'   

				If nTipoPag == 1 //Pagamento a Prazo
					
					If lNT2021002 .And. nValAdto > 0			
						cString += '<vAdiant>'+ ConvType(nValAdto, 13, 2) + '</vAdiant>' //Valor do Adiantamento (DTR_ADIFRE)
					EndIf
					
					For nC:=1 To Len(aVenctos)
						cString += '<infPrazo>'
						cString += '<nParcela>' + StrZero( nC,3 ) + '</nParcela>'
						cString += '<dVenc>' + 	SubStr(DToS(aVenctos[nC][1]), 1, 4) + "-";
											+ SubStr(DToS(aVenctos[nC][1] ), 5, 2) + "-";
											+ SubStr(DToS(aVenctos[nC][1] ), 7, 2) + '</dVenc>'
						cString += '<vParcela>' + ConvType(aVenctos[nC][2], 13, 2) + '</vParcela>'  
						cString += '</infPrazo>'
					Next nC
					
				EndIf	
				
				cPix := AllTrim(RetNumPIX(cCodForn, cLojForn))
				cString += '<infBanc>'
				If !Empty(cCNPJOPer)
					cString += '<CNPJIPEF>' + cCNPJOPer + '</CNPJIPEF>'	
				ElseIf !Empty(cBanco)
					cString += '<codBanco>' + cBanco + '</codBanco>'
					cString += '<codAgencia>' + AllTrim(cAgencia) + '</codAgencia>'
				ElseIf lMDFeInt .And. !Empty(cPix)
					cString += '<PIX>' + cPix + '</PIX>'
				EndIf	
				cString += '</infBanc>'
				cString += '</infPag>'
			EndIf	
		EndIf	
		aRetDA4:= {}

		cString += '</infANTT>'		

		If __lPyme // Utilizado no Serie 3
			//INICIO            
			cAliasDYB := GetNextAlias()                           
			                                              
			cQuery    := "SELECT DYB_CODVEI, DYB_CODRB1, DYB_CODRB2, DYB_CODMOT  " 
			If lTercRbq
				cQuery	+= " ,DYB_CODRB3 "
			EndIf
			cQuery    += " FROM " + RetSqlName("DYB")+" DYB "
			cQuery    += " WHERE DYB_FILIAL = '"+xFilial('DYB')+"'"
			cQuery    += "   AND DYB_NUMROM = '"+cNumRom+"'"
			cQuery    += "   AND DYB.D_E_L_E_T_ = ' '"
			cQuery    := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDYB,.F.,.T.)
			If (cAliasDYB)->(!Eof())
			
				cCodVei:= ''
				For nX := 1 To 4                                              
					If nX == 1                                                
						cCodVei := (cAliasDYB)->DYB_CODVEI
					ElseIf nX == 2
						If !Empty((cAliasDYB)->DYB_CODRB1)
							cCodVei := (cAliasDYB)->DYB_CODRB1
						Else
							Exit
						EndIf
					ElseIf nX == 3 
						If !Empty((cAliasDYB)->DYB_CODRB2)
							cCodVei := (cAliasDYB)->DYB_CODRB2
						Else
							Exit
						EndIf
					ElseIf nX == 4 .And. lTercRbq 
						If !Empty((cAliasDYB)->DYB_CODRB3)
							cCodVei := (cAliasDYB)->DYB_CODRB3
						Else
							Exit
						EndIf
					Else
						Exit
					EndIf
					
					cAliasDA3 := GetNextAlias()
					cQuery := ""
					cQuery += " SELECT DA3_COD   , DA3_PLACA , DA3_RENAVA, DA3_TARA  ,DA3_CAPACM, DA3_FROVEI, " + CRLF
					cQuery += "        DA3_ESTPLA, DA3_CODFOR, DA3_LOJFOR, DUT_TIPROD, DUT_TIPCAR, "            + CRLF
					cQuery += "        DA3_ALTINT, DA3_LARINT, DA3_COMINT, DA3_RENAVA, "                         + CRLF
					cQuery += "        A2_CGC    , A2_NOME   , A2_INSCR  , A2_EST    , A2_TIPO  , A2_RNTRC,    " + CRLF
					cQuery += "        A2_TPRNTRC, A2_EQPTAC     " + CRLF
					cQuery += " FROM " + RetSqlName("DA3") + " DA3 " + CRLF
	
					cQuery += " INNER JOIN " + RetSqlName("DUT") + " DUT " + CRLF
					cQuery += "   ON DUT.DUT_TIPVEI = DA3.DA3_TIPVEI " + CRLF
					cQuery += "   AND DUT.D_E_L_E_T_ = ' ' " + CRLF
	
					cQuery += " INNER JOIN " + RetSqlName("SA2") + " SA2 ON " + CRLF
					cQuery += "           SA2.A2_COD    = DA3.DA3_CODFOR AND " + CRLF
					cQuery += "           SA2.A2_LOJA   = DA3.DA3_LOJFOR AND " + CRLF
					cQuery += "           SA2.D_E_L_E_T_= '' " + CRLF
	
					cQuery += " WHERE DA3.DA3_FILIAL = '"+xFilial("DA3")+"'" + CRLF
					cQuery += "   AND DA3.DA3_COD    = '"+cCodVei+"'"        + CRLF
					cQuery += "   AND DA3.D_E_L_E_T_ = ' '"                  + CRLF
					cQuery += "   AND DUT.DUT_FILIAL = '"+xFilial('DUT')+"'" + CRLF
					cQuery += "   AND SA2.A2_FILIAL  = '"+xFilial('SA2')+"'" + CRLF
					cQuery := ChangeQuery(cQuery)
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDA3,.F.,.T.)
	
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ TAG: Veic -- Tag com informacoes do veiculo                     ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If nX == 1
						cString += '<veicTracao>'
					Else
						cString += '<veicReboque>'
					EndIf
						
					cString += '<cInt>'    + NoAcentoCte((cAliasDA3)->DA3_COD)    + '</cInt>'
					cString += '<placa>'   + NoAcentoCte((cAliasDA3)->DA3_PLACA)  + '</placa>'
					If !Empty((cAliasDA3)->DA3_RENAVA)
						cString += '<RENAVAM>' + NoAcentoCte((cAliasDA3)->DA3_RENAVA) + '</RENAVAM>'				
					EndIf
					cString += '<tara>'    + ConvType(((cAliasDA3)->DA3_TARA) 	, 6,0, .T.)    + '</tara>'
					cString += '<capKG>'   + ConvType(((cAliasDA3)->DA3_CAPACM) , 6, 0, .T.) + '</capKG>'
					//Converte Valor da capacidade em KG para M3
					nCapcM3 := Round((cAliasDA3)->DA3_ALTINT * (cAliasDA3)->DA3_LARINT * (cAliasDA3)->DA3_COMINT,0)
					cString += '<capM3>'   + ConvType((nCapcM3) , 3, 0, .T.) + '</capM3>'
	
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ TAG: Prop -- Se o veiculo for de terceiros, preencher tags com  ³
					//³ informacoes do proprietário                                     ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If (cAliasDA3)->DA3_FROVEI <> '1'
						cString += '<prop>'
						If Len(Alltrim((cAliasDA3)->A2_CGC)) > 11
							cString += '<CNPJ>'	+ NoAcentoCte( (cAliasDA3)->A2_CGC )	+ '</CNPJ>'
						Else
							cString += '<CPF>'	+ NoAcentoCte( (cAliasDA3)->A2_CGC )	+ '</CPF>'
						EndIf
						
						If !Empty((cAliasDA3)->A2_RNTRC)
							cString += '<RNTRC>' + StrZero(Val(AllTrim((cAliasDA3)->A2_RNTRC)),8) + '</RNTRC>'
						EndIf
						
						cString += '<xNome>'+ NoAcentoCte((cAliasDA3)->A2_NOME) + '</xNome>'
						
						If Empty((cAliasDA3)->A2_INSCR) .Or. 'ISENT' $ Upper(AllTrim((cAliasDA3)->A2_INSCR))
							cString += '<IE></IE>'
						Else
							cString += '<IE>' + NoPontos((cAliasDA3)->A2_INSCR) + '</IE>'
						EndIf	
						
						cString += '<UF>'		+ NoAcentoCte( (cAliasDA3)->A2_EST )		+ '</UF>'
						
						If (cAliasDA3)->DA3_FROVEI = '3'  //TAC Agregado 
							cString += '<tpProp>0</tpProp>'
						ElseIf (cAliasDA3)->DA3_FROVEI = '2'  //TAC Independente
							cString += '<tpProp>1</tpProp>'
						Else //Outros
							cString += '<tpProp>2</tpProp>'
						EndIf
						
						cString += '</prop>'
						
					EndIf
	                     
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ TAG: Condutor -- Condutor do Veiculo                            ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If nX == 1
						cAliasDA4 := GetNextAlias()
						cQuery := " SELECT DA4_COD,DA4_NOME,DA4_CGC "
						cQuery += CRLF+" FROM " + RetSqlName("DA4") + " DA4 "

						cQuery += CRLF+ " WHERE DA4_FILIAL     = '" + xFilial("DA4") + "' AND "
						cQuery += CRLF+ "       DA4.DA4_COD    = '" + (cAliasDYB)->DYB_CODMOT + "' AND "
						cQuery += CRLF+ "       DA4.D_E_L_E_T_ = '' "
						cQuery := ChangeQuery(cQuery)
						dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDA4,.F.,.T.)
	
						While (cAliasDA4)->(!Eof())
							cString += '<condutor>'
							cString +=   '<xNome>' + NoAcentoCte((cAliasDA4)->DA4_NOME) +'</xNome>
							cString +=   '<CPF>'   + AllTrim((cAliasDA4)->DA4_CGC) +'</CPF>'
							cString += '</condutor>'
							(cAliasDA4)->(dbSkip())
						EndDo
						(cAliasDA4)->(dbCloseArea())
						cString +=   '<tpRod>'   + AllTrim((cAliasDA3)->DUT_TIPROD) +'</tpRod>'
						
					EndIf		
					
					cString +=   '<tpCar>'   + AllTrim((cAliasDA3)->DUT_TIPCAR) +'</tpCar>'
					If !Empty((cAliasDA3)->DA3_ESTPLA)
						cString +=   '<UF>'   + AllTrim((cAliasDA3)->DA3_ESTPLA) +'</UF>'
					EndIf	
							
					If nX == 1
						cString += '</veicTracao>'
					Else
						cString += '</veicReboque>'
					EndIf
					
		        	(cAliasDA3)->(DbCloseArea())                     
				Next nX			
			EndIf
			
			(cAliasDYB)->(dbCloseArea())			

			//FIM
		Else // Utilizado no Serie T		
			cAliasDTR := GetNextAlias()                           
			                                              
			cQuery    := "SELECT DTR_CODVEI, DTR_CODRB1, DTR_CODRB2, DTR_ITEM "
			If lTercRbq
				cQuery += " ,DTR_CODRB3 "
			EndIf 
			cQuery    += " FROM " + RetSqlName("DTR")+" DTR "
			cQuery    += " WHERE DTR_FILIAL = '"+xFilial('DTR')+"'"
			cQuery    += "   AND DTR_FILORI = '"+DTX->DTX_FILORI+"'"
			cQuery    += "   AND DTR_VIAGEM = '"+DTX->DTX_VIAGEM+"'"
			If lDTX_PRMACO
				If !Empty(DTX->DTX_PRMACO)
					cQuery    += "   AND DTR_CODVEI = '"+DTX->DTX_CODVEI+"'"
				EndIf						
			EndIf
			cQuery    += "   AND DTR.D_E_L_E_T_ = ' '"
			cQuery    := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDTR,.F.,.T.)
			If (cAliasDTR)->(!Eof())
			
				cCodVei:= ''
				For nX := 1 To 4                                              
					If nX == 1                                                
						cCodVei := (cAliasDTR)->DTR_CODVEI
					ElseIf nX == 2
						If !Empty((cAliasDTR)->DTR_CODRB1)
							cCodVei := (cAliasDTR)->DTR_CODRB1
						Else
							Exit
						EndIf
					ElseIf nX == 3
						If !Empty((cAliasDTR)->DTR_CODRB2)
							cCodVei := (cAliasDTR)->DTR_CODRB2
						Else
							Exit
						EndIf
					ElseIf nX == 4 .And. lTercRbq
						If !Empty((cAliasDTR)->DTR_CODRB3)
							cCodVei := (cAliasDTR)->DTR_CODRB3
						Else
							Exit
						EndIf 
					Else
						Exit
					EndIf
					
					cAliasDA3 := GetNextAlias()
					cQuery := ""
					cQuery += " SELECT DA3_COD   , DA3_PLACA , DA3_RENAVA, DA3_TARA  ,DA3_CAPACM, DA3_FROVEI, " + CRLF
					cQuery += "        DA3_ESTPLA, DA3_CODFOR, DA3_LOJFOR, DUT_TIPROD, DUT_TIPCAR, "            + CRLF
					cQuery += "        DA3_ALTINT, DA3_LARINT, DA3_COMINT, DA3_RENAVA, "                         + CRLF
					cQuery += "        A2_CGC    , A2_NOME   , A2_INSCR  , A2_EST    , A2_TIPO  , A2_RNTRC,    " + CRLF
					cQuery += "        A2_TPRNTRC, A2_EQPTAC     " + CRLF
					cQuery += " FROM " + RetSqlName("DA3") + " DA3 " + CRLF
	
					cQuery += " INNER JOIN " + RetSqlName("DUT") + " DUT " + CRLF
					cQuery += "   ON DUT.DUT_TIPVEI = DA3.DA3_TIPVEI " + CRLF
					cQuery += "   AND DUT.D_E_L_E_T_ = ' ' " + CRLF
	
					cQuery += " INNER JOIN " + RetSqlName("SA2") + " SA2 ON " + CRLF
					cQuery += "           SA2.A2_COD    = DA3.DA3_CODFOR AND " + CRLF
					cQuery += "           SA2.A2_LOJA   = DA3.DA3_LOJFOR AND " + CRLF
					cQuery += "           SA2.D_E_L_E_T_= '' " + CRLF
	
					cQuery += " WHERE DA3.DA3_FILIAL = '"+xFilial("DA3")+"'" + CRLF
					cQuery += "   AND DA3.DA3_COD    = '"+cCodVei+"'"        + CRLF
					cQuery += "   AND DA3.D_E_L_E_T_ = ' '"                  + CRLF
					cQuery += "   AND DUT.DUT_FILIAL = '"+xFilial('DUT')+"'" + CRLF
					cQuery += "   AND SA2.A2_FILIAL  = '"+xFilial('SA2')+"'" + CRLF
					cQuery := ChangeQuery(cQuery)
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDA3,.F.,.T.)
	
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ TAG: Veic -- Tag com informacoes do veiculo                     ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If nX == 1
						cString += '<veicTracao>'
					Else
						cString += '<veicReboque>'
					EndIf
						
					cString += '<cInt>'    + NoAcentoCte((cAliasDA3)->DA3_COD)    + '</cInt>'
					cString += '<placa>'   + NoAcentoCte((cAliasDA3)->DA3_PLACA)  + '</placa>'
					If !Empty((cAliasDA3)->DA3_RENAVA)
						cString += '<RENAVAM>' + NoAcentoCte((cAliasDA3)->DA3_RENAVA) + '</RENAVAM>'				
					EndIf
					cString += '<tara>'    + ConvType(((cAliasDA3)->DA3_TARA) 	, 6,0, .T.)    + '</tara>'
					cString += '<capKG>'   + ConvType(((cAliasDA3)->DA3_CAPACM) , 6, 0, .T.) + '</capKG>'
					//Converte Valor da capacidade em KG para M3
					nCapcM3 := Round((cAliasDA3)->DA3_ALTINT * (cAliasDA3)->DA3_LARINT * (cAliasDA3)->DA3_COMINT,0)
					cString += '<capM3>'   + ConvType((nCapcM3) , 3, 0, .T.) + '</capM3>'
	
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ TAG: Prop -- Se o veiculo for de terceiros, preencher tags com  ³
					//³ informacoes do proprietário                                     ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If (cAliasDA3)->DA3_FROVEI <> '1'
						cString += '<prop>'
						If Len(Alltrim((cAliasDA3)->A2_CGC)) > 11
							cString += '<CNPJ>'	+ NoAcentoCte( (cAliasDA3)->A2_CGC )	+ '</CNPJ>'
						Else
							cString += '<CPF>'	+ NoAcentoCte( (cAliasDA3)->A2_CGC )	+ '</CPF>'
						EndIf
						
						If !Empty((cAliasDA3)->A2_RNTRC)
							cString += '<RNTRC>' + StrZero(Val(AllTrim((cAliasDA3)->A2_RNTRC)),8) + '</RNTRC>'
						EndIf
						
						cString += '<xNome>'+ NoAcentoCte((cAliasDA3)->A2_NOME) + '</xNome>'
						
						If Empty((cAliasDA3)->A2_INSCR) .Or. 'ISENT' $ Upper(AllTrim((cAliasDA3)->A2_INSCR))
							cString += '<IE></IE>'
						Else
							cString += '<IE>' + NoPontos((cAliasDA3)->A2_INSCR) + '</IE>'
						EndIf	
						
						cString += '<UF>'		+ NoAcentoCte( (cAliasDA3)->A2_EST )		+ '</UF>'
						
						If (cAliasDA3)->DA3_FROVEI = '3'  //TAC Agregado 
							cString += '<tpProp>0</tpProp>'
						ElseIf (cAliasDA3)->DA3_FROVEI = '2'  //TAC Independente
							cString += '<tpProp>1</tpProp>'
						Else //Outros
							cString += '<tpProp>2</tpProp>'
						EndIf
						
						cString += '</prop>'
					EndIf
	                     
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ TAG: Condutor -- Condutor do Veiculo                            ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If nX == 1
						aRetDA4:= RetInfMot(DTX->DTX_FILORI,DTX->DTX_VIAGEM,(cAliasDTR)->DTR_ITEM)

						For nCount:= 1 To Len(aRetDA4)
							cString += '<condutor>'
							cString +=   '<xNome>' + aRetDA4[nCount][2] +'</xNome>
							cString +=   '<CPF>'   + aRetDA4[nCount][3] +'</CPF>'
							cString += '</condutor>'
						Next nCount

						cString +=   '<tpRod>'   + AllTrim((cAliasDA3)->DUT_TIPROD) +'</tpRod>'					
					EndIf		
					
					cString +=   '<tpCar>'   + AllTrim((cAliasDA3)->DUT_TIPCAR) +'</tpCar>'
					If !Empty((cAliasDA3)->DA3_ESTPLA)
						cString +=   '<UF>'   + AllTrim((cAliasDA3)->DA3_ESTPLA) +'</UF>'
					EndIf
					
					If nX == 1
						cString += '</veicTracao>'
					Else
						cString += '</veicReboque>'
					EndIf
		        	(cAliasDA3)->(dbCloseArea())                          
				Next nX			
			EndIf
			(cAliasDTR)->(dbCloseArea())
		EndIf
		cString += '</rodo>'
		cString += '</infModal>'                           
		
		aAdd(aXMLMDFe,AllTrim(cString)) 
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ TAG: InfDoc -- Informacoes dos Doctos Fiscais vinculados ao Manifesto ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		cString  := ""
		cString += '<infDoc>'                                      
                       
		nQtdCte:= 0
				
		aAreaSM0  := SM0->(GetArea())
		cAliasDT6 := GetNextAlias()
		cQuery := " SELECT DUD_FILDOC, DUD_DOC, DUD_SERIE, DUD_FILATU, DUD_CDRDES, DUD_CDRCAL, DUD_FILDCA, DT6_DATEMI, DT6_CHVCTE, DT6_CHVCTG, DT6_VALMER, DT6_DOCTMS, DT6_CDRCAL, DUY_CODMUN, DUY_EST, "
		cQuery += " DT6_CLIDEV, DT6_LOJDEV, DT6_CLIREM, DT6_LOJREM, DT6_CLIDES, DT6_LOJDES, DUD_SERTMS, SA1.A1_CGC as CNPJ_CLIDV "
		cQuery += " FROM "
		cQuery += RetSqlName('DUD')+" DUD, "
		cQuery += RetSqlName('DT6')+" DT6 "
		cQuery += " LEFT JOIN "+RetSqlName('SA1')+" SA1 ON "
		cQuery += "  SA1.A1_FILIAL  = '" + xFilial("SA1") + "'"
		cQuery += " AND SA1.A1_COD = DT6.DT6_CLIDEV AND SA1.A1_LOJA = DT6.DT6_LOJDEV AND SA1.D_E_L_E_T_  = ' ', "
		cQuery += RetSqlName('DUY')+" DUY  "
		
		If lPerc .AND. cSertms = '3' //Entrega
			cQuery += ","
			cQuery += RetSqlName('DL1')+" DL1,  "
			cQuery += RetSqlName('DL2')+" DL2  "
		EndIf
		
		cQuery += " WHERE DUD.DUD_FILIAL  = '"+xFilial("DUD")+"'"
		cQuery += "		AND DUD.DUD_FILORI  = '"+DTX->DTX_FILORI+"'"
	    If __lPyme 
			cQuery += "	  AND DUD.DUD_NUMROM  = '"+cNumRom+"'"	
        EndIf
		cQuery += "		AND DUD.DUD_FILMAN  = '"+DTX->DTX_FILMAN+"'"
		If lDTX_PRMACO
			cQuery += "		AND DUD.DUD_MANIFE  = '"+Iif(!Empty(DTX->DTX_PRMACO),DTX->DTX_PRMACO,DTX->DTX_MANIFE)+"'"
		Else
			cQuery += "		AND DUD.DUD_MANIFE  = '"+DTX->DTX_MANIFE+"'"
		EndIf		
		cQuery += "		AND DUD.DUD_SERMAN  = '"+DTX->DTX_SERMAN+"'"
		cQuery += "     AND DUD.DUD_STATUS <> '" + StrZero(9,Len(DUD->DUD_STATUS)) + "'" //Cancelado
		cQuery += "		AND DUD.D_E_L_E_T_  = ' '"
		cQuery += "		AND DT6.DT6_FILIAL  = '"+xFilial("DT6")+"'"
		cQuery += "		AND DT6.DT6_FILDOC  = DUD.DUD_FILDOC "
		cQuery += "		AND DT6.DT6_DOC     = DUD.DUD_DOC"
		cQuery += "		AND DT6.DT6_SERIE   = DUD.DUD_SERIE"
		cQuery += "		AND DT6.D_E_L_E_T_  = ' '"
		
		cQuery += "		AND DUY.DUY_FILIAL  = '"+xFilial("DUY")+"'"		
		If lPerc .AND. cSertms = '3' //Entrega

			cQuery += "	AND DL2.DL2_FILIAL  = '"+xFilial("DL2")+"'"
			cQuery += "	AND DL2.DL2_FILORI  = DUD.DUD_FILORI "
			cQuery += "	AND DL2.DL2_VIAGEM  = DUD.DUD_VIAGEM "
			cQuery += " AND DL2.DL2_FILDOC  = DUD.DUD_FILDOC "
			cQuery += " AND DL2.DL2_DOC     = DUD.DUD_DOC"
			cQuery += " AND DL2.DL2_SERIE   = DUD.DUD_SERIE"
			cQuery += " AND DL2.DL2_PERCUR  = '"+DL0->DL0_PERCUR+"'"
			cQuery += "	AND DL2.D_E_L_E_T_  = ' ' " 

			cQuery += "	AND DL1.DL1_FILIAL  = '"+xFilial("DL1")+"'"
			cQuery += " AND DL1.DL1_PERCUR  = DL2.DL2_PERCUR "
			cQuery += " AND DL1.DL1_IDLIN   = DL2.DL2_IDLIN "
			cQuery += "	AND DL1.D_E_L_E_T_  = ' ' " 
		EndIf

		cQuery += "		AND DUY.DUY_GRPVEN  = DUD.DUD_CDRCAL"
		cQuery += "		AND DUY.DUY_CATGRP = '3'
		cQuery += "		AND DUY.D_E_L_E_T_  = ' '"		
		If cSertms = '3' .Or. (cSertms = '2' .And. DTX->DTX_FILDCA = cFilAnt) //Entrega
			cQuery += " ORDER BY DUY.DUY_CODMUN ,DT6.DT6_AMBIEN DESC"
		Else
			cQuery += " ORDER BY DUD.DUD_FILDCA, DUY.DUY_CODMUN, DT6.DT6_AMBIEN DESC"
		EndIf
		cQuery := ChangeQuery(cQuery)
		DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAliasDT6,.T.,.T.)
		While (cAliasDT6)->(!Eof())	
			lRet:= .T.
			If Len(aTipoDoc) > 0 .And. Ascan(aTipoDoc,{|x| x == (cAliasDT6)->DT6_DOCTMS})  > 0
				lRet:= .F.
			EndIf         
						
			If lRet
				lInfMunDes:= .T.
				If !__lPyme 
					If !Empty(cCdMnRed)
						If !lImpRed
							cString += '<infMunDescarga>'
							cString += '<cMunDescarga>' + NoAcentoCte(aUF[ aScan(aUF,{|x| x[1] == AllTrim(cUFFim) }), 2] + cCdMnRed) + '</cMunDescarga>'		
							cString += '<xMunDescarga>' + NoAcentoCte(cNmMnRed) + '</xMunDescarga>'
							lImpRed := .T.
						EndIf											
			       Else			       
				       If (cAliasDT6)->DUD_SERTMS = '3' .Or. ((cAliasDT6)->DUD_SERTMS = '2' .And. DTX->DTX_FILDCA = cFilAnt) 
						   If (cAliasDT6)->DUY_CODMUN <> cMunDCAOld 		
						    	If !Empty(cMunDCAOld) .Or. !Empty(cFilDCAOld) //Para o caso de um Manifesto que possua em primeiro lugar um CTRC de Transferencia e na sequencia um CTRC de Entrega.					    	
									cString += '</infMunDescarga>'
								EndIf	                          
								
								// Em viagem de Entrega o municipio de descarga vem da DT6, regiao de Calculo							
								// Busca estado da Região de Calculo
								nEst := AScan( aUF, {|x| x[1] == (cAliasDT6)->DUY_EST })
	
								cString += '<infMunDescarga>'
								cString += '<cMunDescarga>' + NoAcentoCte(aUF[nEst,2] + (cAliasDT6)->DUY_CODMUN) + '</cMunDescarga>'		
								cString += '<xMunDescarga>' + NoAcentoCte(Posicione("CC2",1, xFilial('CC2')+(cAliasDT6)->DUY_EST+(cAliasDT6)->DUY_CODMUN,"CC2_MUN")) + '</xMunDescarga>'									
				           EndIf
					        cMunDCAOld:= (cAliasDT6)->DUY_CODMUN 
				       Else   //Transferencia    
					       If ((cAliasDT6)->DUD_FILDCA <> cFilDCAOld) .And. (cCodMun <> NoAcentoCte(Posicione("SM0",1,cEmpAnt+(cAliasDT6)->DUD_FILDCA,"M0_CODMUN")))		
						    	If !Empty(cFilDCAOld) .Or. !Empty(cMunDCAOld) //Para o caso de um Manifesto que possua em primeiro lugar um CTRC de Entrega e na sequencia um CTRC de Transferencia.					    	
									cString += '</infMunDescarga>'
								EndIf	                          
								cString += '<infMunDescarga>'
								cString += '<cMunDescarga>' + NoAcentoCte(Posicione("SM0",1,cEmpAnt+(cAliasDT6)->DUD_FILDCA,"M0_CODMUN")) + '</cMunDescarga>'		
								cString += '<xMunDescarga>' + NoAcentoCte(Posicione("SM0",1,cEmpAnt+(cAliasDT6)->DUD_FILDCA,"M0_CIDENT")) + '</xMunDescarga>'		
						   EndIf
					        cFilDCAOld := (cAliasDT6)->DUD_FILDCA     
							cCodMun    := NoAcentoCte(Posicione("SM0",1,cEmpAnt+(cAliasDT6)->DUD_FILDCA,"M0_CODMUN"))
				       EndIf
				    EndIf
		        Else // Para uso do Serie 3
				   If (cAliasDT6)->DUY_CODMUN <> cMunDCAOld		
				    	If !Empty(cMunDCAOld)
							cString += '</infMunDescarga>'
						EndIf	                          
						
						// Em viagem de Entrega o municipio de descarga vem da DT6, regiao de Calculo						
						// Busca estado da Região de Calculo
						nEst := AScan( aUF, {|x| x[1] == (cAliasDT6)->DUY_EST })

						cString += '<infMunDescarga>'
						cString += '<cMunDescarga>' + NoAcentoCte(aUF[nEst,2] + (cAliasDT6)->DUY_CODMUN) + '</cMunDescarga>'		
						cString += '<xMunDescarga>' + NoAcentoCte(Posicione("CC2",1, xFilial('CC2')+(cAliasDT6)->DUY_EST+ (cAliasDT6)->DUY_CODMUN,"CC2_MUN")) + '</xMunDescarga>'								
		           EndIf
			        cMunDCAOld:= (cAliasDT6)->DUY_CODMUN 
		        EndIf            
		        
				If !Empty((cAliasDT6)->DT6_CHVCTE) .Or. !Empty((cAliasDT6)->DT6_CHVCTG)
					cChvCte := Iif(!Empty((cAliasDT6)->DT6_CHVCTE),(cAliasDT6)->DT6_CHVCTE,(cAliasDT6)->DT6_CHVCTG) 
					If TableInDic("DLR") .And. !Empty(cIsenSub)
						DLR->(dbSetOrder(1))
						If DLR->(MsSeek(xFilial('DLR')+(cAliasDT6)->DUD_FILDOC+(cAliasDT6)->DUD_DOC+(cAliasDT6)->DUD_SERIE)) //-- FilDoc + Doc + Serie 
							While DLR->(!Eof()) .And. DLR->DLR_FILIAL + DLR->DLR_FILDOC + DLR->DLR_DOC + DLR->DLR_SERIE == xFilial("DLR") + (cAliasDT6)->DUD_FILDOC+(cAliasDT6)->DUD_DOC+(cAliasDT6)->DUD_SERIE   
								cChvCte := DLR->DLR_CHVCTE
								cString += RetInfCTe( (cAliasDT6)->DUD_FILDOC, (cAliasDT6)->DUD_DOC, (cAliasDT6)->DUD_SERIE, cChvCte, (cAliasDT6)->DT6_CHVCTG  )
								nQtdCte += 1	
								DLR->(dbSkip())
							Enddo
						Else 
							cString += RetInfCTe( (cAliasDT6)->DUD_FILDOC, (cAliasDT6)->DUD_DOC, (cAliasDT6)->DUD_SERIE, cChvCte, (cAliasDT6)->DT6_CHVCTG  )
							nQtdCte += 1	
						EndIf   
				    Else 
						cString += RetInfCTe( (cAliasDT6)->DUD_FILDOC, (cAliasDT6)->DUD_DOC, (cAliasDT6)->DUD_SERIE, cChvCte, (cAliasDT6)->DT6_CHVCTG  )
						nQtdCte += 1 
					EndIf    				
				EndIf	  
			EndIf
			PesqSeg(@aInfSeguro,cAliasDT6)	
			(cAliasDT6)->(dbSkip())
		Enddo
		(cAliasDT6)->(dbCloseArea())		
		RestArea(aAreaSM0)
		
		If lInfMunDes
			cString += '</infMunDescarga>'                                              		
		EndIf	
		cString += '</infDoc>'
				
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ TAG: seg -- Informacoes de Seguro da Carga                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nCount := 1 to Len(aInfSeguro)
			cString += '<seg>'
			cString += '<infResp>'
			cString += '<respSeg>'+ aInfSeguro[nCount][1]  + '</respSeg>'
			if !Empty(aInfSeguro[nCount][2])
				cString += '<CNPJ>'+ NoPontos(aInfSeguro[nCount][2])  + '</CNPJ>'						
			EndIF
			if !Empty(aInfSeguro[nCount][3])
				cString += '<CPF>'+ NoPontos(aInfSeguro[nCount][3])  + '</CPF>'						
			EndIF
			cString += '</infResp>'
			
			if !Empty(aInfSeguro[nCount][4])
				cString += '<infSeg>'
				cString += '<xSeg>'   + NoAcentoCte(AllTrim(aInfSeguro[nCount][4]))   + '</xSeg>'
				cString += '<CNPJ>'   + NoPontos(aInfSeguro[nCount][5])  + '</CNPJ>'
				cString += '</infSeg>'
			EndIF
			
			if !Empty(aInfSeguro[nCount][6])
				cString += '<nApol>'  + aInfSeguro[nCount][6]  + '</nApol>'
			EndIF
			
			For nCount2 := 1 to Len(aInfSeguro[nCount][7])
				if !Empty(aInfSeguro[nCount][7][nCount2][1]) 			
					cString += '<nAver>'  + aInfSeguro[nCount][7][nCount2][1]  + '</nAver>'
				EndIf
			Next nCount

			cString += '</seg>'
		Next nCount
			
		// Informações sobre o produto predominante.
		If FindFunction("ProdPred") .And. ( cTipTra == StrZero(1,Len(DTQ->DTQ_TIPTRA)) .OR. cTipTra == StrZero(2,Len(DTQ->DTQ_TIPTRA)) .OR. __lPyme )
			cString += RetProdPred(DTX->DTX_FILMAN,Iif(!Empty(DTX->DTX_PRMACO),DTX->DTX_PRMACO,DTX->DTX_MANIFE),DTX->DTX_SERMAN) 
		EndIf

		// TAG: Tot -- Totalizadores da carga transportada e seus doctos fiscais
		cString += '<tot>'
		If nQtdCte > 0
			cString += '<qCTe>' + cValtoChar(nQtdCte) + '</qCTe>'				
		EndIf
		
		cString += '<vCarga>'   + ConvType(DTX->DTX_VALMER, 13, 2) + '</vCarga>'
		cString += '<cUnid>01</cUnid>'			        	//01- KG, 02- TON
		cString += '<qCarga>'   + ConvType(DTX->DTX_PESO, 11, 4) + '</qCarga>'
		cString += '</tot>'

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ TAG: Lacres -- Lacres do MDF-e                                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cAliasDVB := GetNextAlias()
		cQuery := " SELECT DVB_LACRE "
		cQuery += CRLF+" FROM " + RetSqlName("DVB")	+ " DVB "
		cQuery += CRLF+" WHERE DVB_FILIAL = '" + xFilial("DVB") + "' AND "
		cQuery += CRLF+"       DVB_FILORI = '" + DTX->DTX_FILORI + "' AND "
		cQuery += CRLF+"       DVB_VIAGEM = '" + DTX->DTX_VIAGEM + "' AND "
		cQuery += CRLF+"       DVB.D_E_L_E_T_ = '' "
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDVB,.F.,.T.)

		While (cAliasDVB)->(!Eof())
			cString+=	'<lacres>'
			cString+= 		'<nLacre>' + AllTrim((cAliasDVB)->DVB_LACRE) + '</nLacre>'
			cString+=	'</lacres>'
			dbskip()
		Enddo
		(cAliasDVB)->(dbCloseArea())

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ TAG: autXML -- Autorizados para download do XML do DF-e               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		// Conforme Resolução 799/2015 da ANTT em seu artigo 22  (Chamado TTGSCD)
		If  !Empty(cCNPJAntt)
			cString += '<autXML>'
			cString +=  '<CNPJ>' + NoPontos(cCNPJAntt) + '</CNPJ>' 
			cString += '</autXML>'
		EndIf
		
		// TAG: infAdic -- Informacoes adicionais                                ³
		cCodObs  := Posicione("DTQ",2,xFilial("DTQ")+DTX->DTX_FILORI+DTX->DTX_VIAGEM,"DTQ_CODOBS")
		If !Empty(cCodObs)
			cObs    := NoAcentoCte( StrTran(MsMM(cCodObs),Chr(13),"") )
		EndIf	
		
		If !Empty(cObs)                   
			cString += '<infAdic>'              
			cString +=  '<infAdFisco>' + NoAcentoCte(SubStr(cObs,1,320)) + '</infAdFisco>'
			cString += '</infAdic>'              
		EndIf

		// TAG: infRespTec -- Identificação do Responsavel Tecnico               
		If !lUsaColab  
			If ExistFunc('TMSIdResp')
				cString += TMSIdResp()
			EndIf			
		EndIf	

		cString += '</infMDFe>'

		//-- TAG: infMDFeSupl -- Informações suplementares do MDF-e QRCod
		If !lUsaColab 
			cString += '<infMDFeSupl>'
			cString +=  '<qrCodMDFe>'
			cString += 'https://dfe-portal.svrs.rs.gov.br/mdfe/QRCode?chMDFe='+ cChvAcesso + '&amp;tpAmb=' + cAmbiente 
			cString +=  '</qrCodMDFe>'
			cString += '</infMDFeSupl>'	
		EndIf

		aAdd(aXMLMDFe,AllTrim(cString))
				
		cString := ''
		cString += '</MDFe>'

			
		aAdd(aXMLMDFe,AllTrim(cString))				

		cString := ''			
		For nCount := 1 To Len(aXMLMDFe)
			cString += AllTrim(aXMLMDFe[nCount])
		Next nCount

		RecLock('DTX',.F.) 
		If Empty(DTX->DTX_CHVMDF) .And. cTpEmis == '1'
			DTX->DTX_CHVMDF:= cChvAcesso
		EndIf
		If cTpEmis == '2' .And.  Empty(DTX->DTX_CTGMDF)  //Contingencia
			DTX->DTX_CTGMDF:= cChvAcesso
		EndIf
		MsUnlock()				                       

	EndIf
EndIf

If lTMSMDFESE
	aRetXML := ExecBlock("TMSMDFESE",.F.,.F., {cNumMan,cSerMan,aXMLMDFe})
	If ValType(aRetXML) == 'A' .And. Len(aRetXML) > 0
		aXMLMDFe := aClone(aRetXML)
	EndIf
	
	cString := ''
	For nCount := 1 To Len(aXMLMDFe)
		cString += AllTrim(aXMLMDFe[nCount])
	Next nCount	
EndIf

RestArea(aAreaSM0)
Return({cNfe,EncodeUTF8(cString),cNumMan,cSerMan})

/* 
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ConvType  ºAutor  ³Totvs               º Data ³  14/02/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ConvType(xValor,nTam,nDec,lInt)

Local   cNovo := ""
Default nDec  := 0
Default lInt  := .F.

Do Case
	Case ValType(xValor)=="N"
		If lInt .And. nDec=0
			xValor := Int(xValor)
		EndIf
		cNovo := AllTrim(Str(xValor,nTam,nDec))
		If "*"$cNovo .and. nDec=0
			cNovo:= Replicate("9",nTam)
		EndIf
	Case ValType(xValor)=="D"
		cNovo := FsDateConv(xValor,"YYYYMMDD")
		cNovo := SubStr(cNovo,1,4)+"-"+SubStr(cNovo,5,2)+"-"+SubStr(cNovo,7)
	Case ValType(xValor)=="C"
		If nTam==Nil
			xValor := AllTrim(xValor)
		EndIf
		Default nTam := 60
		cNovo := NoAcentoCte(SubStr(xValor,1,nTam))
EndCase
Return(cNovo)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Inverte   ºAutor  ³Totvs               º Data ³  08/03/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Inverte()

Local cRet := ""
Local cFunc := "Random"

If FindFunction(cFunc)
	cRet := AllTrim(Str(&cFunc.( 10000000, 99999999 )))
Else
	cRet := AllTrim(Str(Randomize( 10000000, 99999999 )))
EndIf

Return(cRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ MDFCHVAC ³       ³Totvs                  ³ Data ³14.02.2017³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao responsavel em montar a Chave de Acesso             ³±±
±±³          ³ a SEFAZ e calcular o seu digito verIficador.               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MDFCHVAC(cUF, cAAMM, cCNPJ, cMod, cSerie, nMDF, cMDF)       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³ cUF...: Codigo da UF                                       ³±±
±±³          ³ cAAMM.: Ano (2 Digitos) + Mes da Emissao do CTe            ³±±
±±³          ³ cCNPJ.: CNPJ do Emitente do CTe                            ³±±
±±³          ³ cMod..: Modelo (58 = MDFe)                                 ³±±
±±³          ³ cSerie: Serie do MDFe                                      ³±±
±±³          ³ nCT...: Numero do MDF                                      ³±±
±±³          ³ cMDF..: Numero do Lote de Envio a SEFAZ                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Explicacao do Calculo se encontra no manual do MDF-e       ³±±
±±³          ³ disponibilizado pela SEFAZ na versao atual 3.00            ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function MDFCHVAC(cUF, cAAMM, cCNPJ, cMod, cSerie, nMDF, cMDF)
Local nCount      := 0
Local nSequenc    := 2
Local nPonderacao := 0
Local cResult     := ''
Local cChvAcesso  := cUF +  cAAMM + cCNPJ + cMod + cSerie + nMDF + cMDF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³SEQUENCIA DE MULTIPLICADORES (nSequenc), SEGUE A SEGUINTE        ³
//³ORDENACAO NA SEQUENCIA: 2,3,4,5,6,7,8,9,2,3,4... E PRECISA SER   ³
//³GERADO DA DIREITA PARA ESQUERDA, SEGUINDO OS CARACTERES          ³
//³EXISTENTES NA CHAVE DE ACESSO INFORMADA (cChvAcesso)             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nCount := Len( AllTrim(cChvAcesso) ) To 1 Step -1
	nPonderacao += ( Val( SubStr( AllTrim(cChvAcesso), nCount, 1) ) * nSequenc )
	nSequenc += 1
	If (nSequenc == 10)
		nSequenc := 2
	EndIf
Next nCount

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Quando o resto da divisão for 0 (zero) ou 1 (um), o DV devera   ³
//³ ser igual a 0 (zero).                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( mod(nPonderacao,11) > 1)
	cResult := (cChvAcesso + cValToChar( (11 - mod(nPonderacao,11) ) ) )
Else
	cResult := (cChvAcesso + '0')
EndIf

Return(cResult)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NoPontos  ºAutor  ³Totvs               º Data ³  15/02/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retira caracteres dIferentes de numero, como, ponto,       º±±
±±º          ³virgula, barra, traco                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function NoPontos(cString)
Local cChar     := ""
Local nX        := 0
Local cPonto    := "."
Local cBarra    := "/"
Local cTraco    := "-"
Local cVirgula  := ","
Local cBarraInv := "\"
Local cPVirgula := ";"
Local cUnderline:= "_"
Local cParent   := "()"

For nX:= 1 To Len(cString)
	cChar := SubStr(cString, nX, 1)
	If cChar$cPonto+cVirgula+cBarra+cTraco+cBarraInv+cPVirgula+cUnderline+cParent
		cString := StrTran(cString,cChar,"")
		nX := nX - 1
	EndIf
Next
cString := AllTrim(_NoTags(cString))

Return cString

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PesqSeg   ºAutor  ³Totvs               º Data ³  14/03/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Pesquisa as apolices utilizidas para cada CT-e e armazena   º±±
±±º          ³em um array, que sera utilizado na montagem da tag <seg>    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PesqSeg(aInfSeguro,cAliasDT6)
Local aResp := {}
Local cAliasSeg
Local cQuery	
Local cRespSeg := ''
Local cApolice := ''
Local cNomSeg := ''
Local cCNPJSeg := ''
Local cRespCNPJ := ''
Local cRespCPF := ''
Local cForSeg := SuperGetMv( "MV_FORSEG",,'' )
Local lForApol := SA2->(ColumnPos('A2_APOLICE')) > 0
Local lApolice := .F.
Local nTamCod := Len(SA2->A2_COD)
Local nTamLoj := Len(SA2->A2_LOJA)
Local cAliasAp := ''
Local cChave
Local aNumAvb := {}
Local cNumAvb := ''
Local nScanAr := 0
Local cAliasDL5
Local lAchouDL5 := .F.
		
	If AliasInDic("DL5")
		cAliasDL5 := GetNextAlias()
		cQuery := " SELECT DISTINCT DL5_NOMESE, DL5_CNPJSE, DL5_NUMAPO, DL5_NUMAVB, DL5_TPMOV, DL5_STATUS "
		cQuery += " FROM " + RetSqlName("DL5") 
		cQuery += " WHERE DL5_FILIAL = '" + xFilial("DL5")  + "' "		
		cQuery += " AND DL5_FILDOC = '"+(cAliasDT6)->DUD_FILDOC+"'" 
		cQuery += " AND DL5_DOC = '"+(cAliasDT6)->DUD_DOC+"'" 
		cQuery += " AND DL5_SERIE = '"+(cAliasDT6)->DUD_SERIE+"'"
		cQuery += " AND D_E_L_E_T_ = ' ' "
		
		cQuery := ChangeQuery(cQuery)
		dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAliasDL5, .F., .T.)
				
		Do While !(cAliasDL5)->(Eof())
			lAchouDL5 := .T.

			IF (cAliasDL5)->DL5_TPMOV == '4'//Resp. terceiros
				cRespSeg  := '2'
				cRespCNPJ := (cAliasDT6)->CNPJ_CLIDV
				cRespCPF := ''
			Else
				cRespSeg  := '1'
				cRespCNPJ := cCNPJEmiMN
				cRespCPF := ''
			EndIF
			cNomSeg   := AllTrim(SubStr((cAliasDL5)->DL5_NOMESE, 1, 30))
			cCNPJSeg  := (cAliasDL5)->DL5_CNPJSE
			cApolice  :=  NoAcentoCte(AllTrim((cAliasDL5)->DL5_NUMAPO))				
						
			cChave := cRespSeg+cRespCNPJ+cRespCPF+cCNPJSeg+cApolice
			nScanAr := AScan( aInfSeguro,{|x| x[8] == cChave})
				
			If !Empty((cAliasDL5)->DL5_NUMAVB)				
				cNumAvb := AllTrim((cAliasDL5)->DL5_NUMAVB)
			else
			    cNumAvb := '99999'
			End
							 									 	
			If nScanAr == 0
				aNumAvb := {}				 					
				aAdd(aNumAvb,{cNumAvb})				
				AAdd(aInfSeguro,{cRespSeg,cRespCNPJ,cRespCPF,cNomSeg,cCNPJSeg,cApolice,aNumAvb,cChave})
			Else
				aNumAvb := aInfSeguro[nScanAr][7]
				if AScan( aNumAvb,{|x| x[1] == cNumAvb}) == 0
					aAdd(aNumAvb,{cNumAvb})
					aInfSeguro[nScanAr][7] := aNumAvb 
				EndIf
			EndIF
			(cAliasDL5)->(DbSkip())
		EndDo							
		(cAliasDL5)->( DbCloseArea() )	
	End
	
	IF !lAchouDL5 	
		aResp := TMSAvbCli(	(cAliasDT6)->DT6_CLIDEV, (cAliasDT6)->DT6_LOJDEV, '', ;
								(cAliasDT6)->DT6_CLIREM, (cAliasDT6)->DT6_LOJREM,     ;
								(cAliasDT6)->DT6_CLIDES, (cAliasDT6)->DT6_LOJDES, .F. )
											
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Cliente Responsavel pelo Seguro   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(aResp) .And. lForApol 
			cAliasSeg := GetNextAlias()
			cQuery := "SELECT SA2.A2_NOME, DV6.DV6_APOL, SA2.A2_CGC, "
			cQuery += " SA1.A1_PESSOA, SA1.A1_CGC, DV6.DV6_NUMAVB"
			cQuery += " FROM  " + RetSqlName("DV6") + " DV6 "
			cQuery += " JOIN " + RetSqlName("SA2") + " SA2 "
			cQuery += " ON SA2.A2_FILIAL  = '" + xFilial("SA2") + "'"
			cQuery += " AND SA2.A2_COD     = DV6.DV6_CODSEG"
			cQuery += " AND SA2.A2_LOJA    = DV6.DV6_LOJSEG"
			cQuery += " AND SA2.D_E_L_E_T_ = ' '"		
			cQuery += " LEFT JOIN " + RetSqlName("SA1") + " SA1 "
			cQuery += " ON SA1.A1_FILIAL  = '" + xFilial("SA1") + "'"
			cQuery += " AND SA1.A1_COD     = DV6.DV6_CLIDEV"
			cQuery += " AND SA1.A1_LOJA    = DV6.DV6_LOJDEV"
			cQuery += " AND SA1.D_E_L_E_T_ = ' '"			
			cQuery += " Where DV6.DV6_CLIDEV  = '" + aResp[1]       + "'"
			cQuery += " AND DV6.DV6_LOJDEV = '" + aResp[2]       + "'"
			cQuery += " AND DV6.DV6_FILIAL = '" + xFilial("DV6") + "'"
			cQuery += " AND DV6.DV6_INIVIG <= '" + DToS(dDataBase) + "' "
			cQuery += " AND (DV6.DV6_FIMVIG  = ' ' OR DV6.DV6_FIMVIG >= '" + DToS(dDataBase) + "' )"
			cQuery += " AND DV6.D_E_L_E_T_ = ' '"
				
			cQuery := ChangeQuery(cQuery)
			DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasSeg, .F., .T.)
			While (cAliasSeg)->(!EoF())
				cRespSeg  := '2'
				cRespCNPJ := ''
				cRespCPF := ''
				If (cAliasSeg)->A1_PESSOA == 'F'
					cRespCPF := (cAliasSeg)->A1_CGC
				Else
					cRespCNPJ := (cAliasSeg)->A1_CGC 
				EndIF
				
				cNomSeg   := AllTrim(SubStr((cAliasSeg)->A2_NOME, 1, 30))
				cCNPJSeg  := (cAliasSeg)->A2_CGC
				cApolice  :=  NoAcentoCte(AllTrim((cAliasSeg)->DV6_APOL))
				lApolice  := .F.				
						
				cChave := cRespSeg+cRespCNPJ+cRespCPF+cCNPJSeg+cApolice
				nScanAr := AScan( aInfSeguro,{|x| x[8] == cChave})
				
				If !Empty((cAliasSeg)->DV6_NUMAVB)				
					cNumAvb := AllTrim((cAliasSeg)->DV6_NUMAVB)
				else
				    cNumAvb := '99999'
				End
							 									 	
				If nScanAr == 0
					aNumAvb := {}				 					
					aAdd(aNumAvb,{cNumAvb})				
					AAdd(aInfSeguro,{cRespSeg,cRespCNPJ,cRespCPF,cNomSeg,cCNPJSeg,cApolice,aNumAvb,cChave})
				Else
					aNumAvb := aInfSeguro[nScanAr][7]
					if AScan( aNumAvb,{|x| x[1] == cNumAvb}) == 0
						aAdd(aNumAvb,{cNumAvb})
						aInfSeguro[nScanAr][7] := aNumAvb 
					EndIf
				EndIF									
				
				(cAliasSeg)->(DbSkip())
			EndDo
			(cAliasSeg)->(DbCloseArea())
		EndIf					
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Transportadora Responsavel pelo Seguro  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ						
		If !Empty(cForSeg) .And. lForApol
			cAliasSeg := GetNextAlias()
			cQuery := "SELECT  SA2.A2_NOME, SA2.A2_APOLICE, SA2.A2_CGC"
			cQuery += " FROM  " + RetSqlName("SA2") + " SA2 "
			cQuery += " WHERE A2_COD = '" + Substr(cForSeg,1,nTamCod) + "'"
			cQuery += " AND A2_LOJA  = '" + Substr(cForSeg,nTamCod+1,nTamLoj) + "'"
			cQuery += " AND SA2.A2_FILIAL  = '" + xFilial("SA2") + "'"
			cQuery += " AND SA2.D_E_L_E_T_ = ' '"
			cQuery := ChangeQuery(cQuery)
			DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasSeg, .F., .T.)
			If (cAliasSeg)->(!EoF())
				cRespSeg  := '1' //-- Emitente do MDF-e;
				cRespCNPJ := cCNPJEmiMN
				cNomSeg   := AllTrim(SubStr((cAliasSeg)->A2_NOME, 1, 30))
				cCNPJSeg  := (cAliasSeg)->A2_CGC
				cApolice  :=  NoAcentoCte(AllTrim((cAliasSeg)->A2_APOLICE))
			EndIf
			(cAliasSeg)->(DbCloseArea())
		EndIf
		//Verifica caso haja mais de uma Apolice de Seguro
		If DU3->(ColumnPos('DU3_NUMAPO')) > 0			
			lApolice := .F.							
			cAliasAp := GetNextAlias()
			cQuery := "SELECT DISTINCT DU3.DU3_NUMAPO, DT6.DT6_DOCSEG "
			cQuery += " FROM  " + RetSqlName("DT6") + " DT6 "
			cQuery += " INNER JOIN " + RetSqlName("DC5") + " DC5 ON "
			cQuery += " DT6.DT6_SERVIC = DC5.DC5_SERVIC "
			cQuery += " INNER JOIN " + RetSqlName("DU4") + " DU4 ON "
			cQuery += " DU4.DU4_TABSEG = DC5.DC5_TABSEG "
			cQuery += " INNER JOIN " + RetSqlName("DU5") + " DU5 ON "
			cQuery += " DU4.DU4_TABSEG = DU5.DU5_TABSEG AND DU4.DU4_TPTSEG = DU5.DU5_TPTSEG "
			cQuery += " INNER JOIN " + RetSqlName("DU3") + " DU3 ON "
			cQuery += " DU3.DU3_COMSEG = DU5.DU5_COMSEG "  
			cQuery += " WHERE DT6.DT6_FILIAL = '" + xFilial('DT6') + "'"
			cQuery += " AND DU3.DU3_FILIAL = '" + xFilial('DU3') + "'"
			cQuery += " AND DU4.DU4_FILIAL = '" + xFilial('DU4') + "'"
			cQuery += " AND DU5.DU5_FILIAL = '" + xFilial('DU5') + "'"
			cQuery += " AND DC5.DC5_FILIAL = '" + xFilial('DC5') + "'"
			cQuery += " AND DT6.DT6_FILDOC    = '" + (cAliasDT6)->DUD_FILDOC + "'"
			cQuery += " AND DT6.DT6_DOC       = '" + (cAliasDT6)->DUD_DOC + "'"
			cQuery += " AND DT6.DT6_SERIE     = '" + (cAliasDT6)->DUD_SERIE + "'"						
			cQuery += " AND DT6.D_E_L_E_T_ = ' '"
			cQuery += " AND DU3.D_E_L_E_T_ = ' '"
			cQuery += " AND DU3.DU3_NUMAPO <> ''" 
			cQuery += " AND DU4.D_E_L_E_T_ = ' '"
			cQuery += " AND DU5.D_E_L_E_T_ = ' '"
			cQuery += " AND DC5.D_E_L_E_T_ = ' '"
	
			cQuery := ChangeQuery(cQuery)
			DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasAp, .F., .T.)
			
			While (cAliasAp)->(!Eof())
				If !Empty(cRespSeg) .And. !Empty(cNomSeg) 
					lApolice := .T.								
					cApolice := NoAcentoCte(AllTrim((cAliasAp)->DU3_NUMAPO))
					cChave := cRespSeg+cRespCNPJ+''+cCNPJSeg+cApolice
					nScanAr := AScan( aInfSeguro,{|x| x[8] == cChave})
					If !Empty((cAliasAp)->DT6_DOCSEG)				
						cNumAvb := AllTrim((cAliasAp)->DT6_DOCSEG)
					else
						cNumAvb := '99999'
					End				 									 
					If nScanAr == 0
						aNumAvb := {}					
						aAdd(aNumAvb,{cNumAvb}) 
						AAdd(aInfSeguro,{cRespSeg,cRespCNPJ,'',cNomSeg,cCNPJSeg,cApolice,aNumAvb,cChave})
					Else
						aNumAvb := aInfSeguro[nScanAr][7]
						if AScan( aNumAvb,{|x| x[1] == cNumAvb}) == 0
							aAdd(aNumAvb,{cNumAvb})
							aInfSeguro[nScanAr][7] := aNumAvb 
						EndIf
					EndIF					
				EndIf
				(cAliasAp)->(DbSkip())
			EndDo
						
			(cAliasAp)->(dbCloseArea())
		EndIf
						
		If !Empty(cForSeg) .And. !Empty(cRespSeg) .And. !Empty(cNomSeg) .And. !Empty(cApolice) .And. !lApolice
			cAliasAp := GetNextAlias()
			cQuery := "SELECT DISTINCT DT6.DT6_DOCSEG "
			cQuery += " FROM  " + RetSqlName("DT6") + " DT6 "		  
			cQuery += " WHERE DT6.DT6_FILIAL = '" + xFilial('DT6') + "'"
			cQuery += " AND DT6.DT6_FILDOC    = '" + (cAliasDT6)->DUD_FILDOC + "'"
			cQuery += " AND DT6.DT6_DOC       = '" + (cAliasDT6)->DUD_DOC + "'"
			cQuery += " AND DT6.DT6_SERIE     = '" + (cAliasDT6)->DUD_SERIE + "'"						
			cQuery += " AND DT6.D_E_L_E_T_ = ' '"
			
			cQuery := ChangeQuery(cQuery)
			DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasAp, .F., .T.)
		
			cChave := cRespSeg+cRespCNPJ+''+cCNPJSeg+cApolice
			nScanAr := AScan( aInfSeguro,{|x| x[8] == cChave})
			If !Empty((cAliasAp)->DT6_DOCSEG)				
				cNumAvb := AllTrim((cAliasAp)->DT6_DOCSEG)
			else
				cNumAvb := '99999'
			End						 									 
			If nScanAr == 0
				aNumAvb := {}		
				aAdd(aNumAvb,{cNumAvb})				
				AAdd(aInfSeguro,{cRespSeg,cRespCNPJ,'',cNomSeg,cCNPJSeg,cApolice,aNumAvb,cChave})
			Else
				aNumAvb := aInfSeguro[nScanAr][7]
				if AScan( aNumAvb,{|x| x[1] == cNumAvb}) == 0
					aAdd(aNumAvb,{cNumAvb})
					aInfSeguro[nScanAr][7] := aNumAvb 
				EndIf
			EndIF
			(cAliasAp)->(DbCloseArea())	
		EndIf
	EndIF	
Return .T.

//-----------------------------------------------------------------
/*/{Protheus.doc} MunCarMan()
A função retorna o código das regiões de carregamento quando:
1 - Rota / Transportadora
2 - Cliente Remetente
3 - Local de Coleta 

@author Caio Murakami
@since 08/11/2018
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function MunCarMan( cFilOri, cViagem , cManife , cSerMan , cSerTms , aUF, aCdMunIni)
Local aArea			:= GetArea()
Local cQuery		:= ""
Local cAliasQry		:= ""
Local cUF			:= ""
Local aCdMunAux 	:= {}
Local lOrigem		:= .F.
Local nI			:= 0

Default cFilOri		:= ""
Default cViagem		:= ""
Default cSerTms		:= ""
Default aUF			:= {}
Default aCdMunIni	:= {}

If cSerTms = '3' //-- Entrega
	If DTA->(ColumnPos("DTA_ORIGEM")) > 0

		cQuery := "SELECT DTA.DTA_ORIGEM,DTC.DTC_NUMSOL, SA1.A1_CDRDES, DUD_MANIFE, DUD_SERMAN "
		cQuery += "FROM " + RetSqlName("DUD") + " DUD "
		cQuery += "INNER JOIN " + RetSqlName("DTC") + " DTC "
		cQuery += "	ON DTC_FILIAL = '" + xFilial("DTC") + "' "
		cQuery += "	AND DTC_FILDOC = DUD_FILDOC "
		cQuery += "	AND DTC_DOC = DUD_DOC "
		cQuery += "	AND DTC_SERIE = DUD_SERIE "
		cQuery += "	AND DTC.D_E_L_E_T_ = ' ' "
		cQuery += "INNER JOIN " + RetSqlName("DT6") + " DT6 "
		cQuery += "	ON DT6_FILIAL = '" + xFilial("DT6") + "' "
		cQuery += "	AND DT6_FILDOC = DUD_FILDOC "
		cQuery += "	AND DT6_DOC = DUD_DOC "
		cQuery += "	AND DT6_SERIE = DUD_SERIE "
		cQuery += "	AND DT6.D_E_L_E_T_ = ' ' "
		cQuery += "INNER JOIN " + RetSqlName("SA1") + " SA1 "
		cQuery += "	ON A1_FILIAL = '" + xFilial("SA1") + "' "
		cQuery += "	AND A1_COD = DT6_CLIREM "
		cQuery += "	AND A1_LOJA = DT6_LOJREM "
		cQuery += "	AND SA1.D_E_L_E_T_ = ' ' "
		cQuery += "INNER JOIN " + RetSqlName("DTA") + " DTA "
		cQuery += "	ON DTA_FILIAL = '" + xFilial("DTA") + "' "
		cQuery += " AND DTA_FILORI = DUD_FILORI "
		cQuery += "	AND DTA_VIAGEM = DUD_VIAGEM "
		cQuery += " AND DTA_FILDOC = DUD_FILDOC"
		cQuery += "	AND DTA_DOC = DUD_DOC "
		cQuery += "	AND DTA_SERIE = DUD_SERIE "
		cQuery += "	AND DTA.D_E_L_E_T_ = ' ' "	
		cQuery += "WHERE DUD_FILIAL = '" + xFilial("DUD") + "' "
		cQuery += " AND DUD_FILORI = '" + cFilOri + "' "
		cQuery += " AND DUD_VIAGEM = '" + cViagem + "' "
		cQuery += " AND DUD_MANIFE = '" + cManife + "' "
		cQuery += " AND DUD_SERMAN = '" + cSerMan + "' "
		cQuery += " AND DUD.D_E_L_E_T_ = ' '"
		
		cQuery += " UNION "

		cQuery += "SELECT DTA.DTA_ORIGEM,DTC.DTC_NUMSOL, SA1.A1_CDRDES, DUD_MANIFE, DUD_SERMAN "
		cQuery += "FROM " + RetSqlName("DUD") + " DUD "
		cQuery += "INNER JOIN " + RetSqlName("DY4") + " DY4 "
		cQuery += "	ON DY4.DY4_FILIAL = '" + xFilial("DY4") + "' "
		cQuery += "	AND DY4.DY4_FILDOC = DUD_FILDOC "
		cQuery += "	AND DY4.DY4_DOC = DUD_DOC "
		cQuery += "	AND DY4.DY4_SERIE = DUD_SERIE "
		cQuery += "	AND DY4.D_E_L_E_T_ = ' ' "	
		cQuery += "INNER JOIN " + RetSqlName("DTC") + " DTC "
		cQuery += "	ON DTC_FILIAL = '" + xFilial("DTC") + "' "
		cQuery += "	AND DTC_FILORI = DY4.DY4_FILORI "
		cQuery += "	AND DTC_LOTNFC = DY4.DY4_LOTNFC "
		cQuery += "	AND DTC_NUMNFC = DY4.DY4_NUMNFC "
		cQuery += "	AND DTC_SERNFC = DY4.DY4_SERNFC "
		cQuery += "	AND DTC_CLIREM = DY4.DY4_CLIREM "
		cQuery += "	AND DTC_LOJREM = DY4.DY4_LOJREM "
		cQuery += "	AND DTC_CODPRO = DY4.DY4_CODPRO "
		cQuery += "	AND DTC.D_E_L_E_T_ = ' ' "
		cQuery += "INNER JOIN " + RetSqlName("SA1") + " SA1 "
		cQuery += "	ON A1_FILIAL = '" + xFilial("SA1") + "' "
		cQuery += "	AND A1_COD = DY4.DY4_CLIREM "
		cQuery += "	AND A1_LOJA = DY4.DY4_LOJREM "
		cQuery += "	AND SA1.D_E_L_E_T_ = ' ' "
		cQuery += "INNER JOIN " + RetSqlName("DTA") + " DTA "
		cQuery += "	ON DTA_FILIAL = '" + xFilial("DTA") + "' "
		cQuery += " AND DTA_FILORI = DUD_FILORI "
		cQuery += "	AND DTA_VIAGEM = DUD_VIAGEM "
		cQuery += " AND DTA_FILDOC = DUD_FILDOC"
		cQuery += "	AND DTA_DOC = DUD_DOC "
		cQuery += "	AND DTA_SERIE = DUD_SERIE "
		cQuery += "	AND DTA.D_E_L_E_T_ = ' ' "	
		cQuery += "WHERE DUD_FILIAL = '" + xFilial("DUD") + "' "
		cQuery += " AND DUD_FILORI = '" + cFilOri + "' "
		cQuery += " AND DUD_VIAGEM = '" + cViagem + "' "
		cQuery += " AND DUD_MANIFE = '" + cManife + "' "
		cQuery += " AND DUD_SERMAN = '" + cSerMan + "' "
		cQuery += " AND DUD.D_E_L_E_T_ = ' '"
		cQuery := ChangeQuery(cQuery)
		cAliasQry := GetNextAlias()
		dbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), cAliasQry)		

		DUY->(dbSetOrder(1)) //DUY_FILIAL+DUY_GRPVEN
		CC2->(dbSetOrder(1)) //CC2_FILIAL+CC2_MUN
		DT5->(dbSetOrder(3)) //DT5_FILIAL+DT5_NUMSOL

		While (cAliasQry)->(!Eof())
			If Empty((cAliasQry)->DTA_ORIGEM) .OR. (cAliasQry)->DTA_ORIGEM == "1" // 1=Rota / Transportadora
				lOrigem := .T.			
			ElseIf (cAliasQry)->DTA_ORIGEM == "2" //2=Cliente/Remetente
				If !DUY->(MsSeek(xFilial("DUY")+(cAliasQry)->A1_CDRDES))
					(cAliasQry)->(dbSkip())
					Loop
				EndIf
			ElseIf (cAliasQry)->DTA_ORIGEM == "3" //3=Local Coleta
				If DT5->(MsSeek(xFilial("DT5")+(cAliasQry)->DTC_NUMSOL))
					If !DUY->(MsSeek(xFilial("DUY")+DT5->DT5_CDRORI))
						(cAliasQry)->(dbSkip())
						Loop
					EndIf
				Else
					(cAliasQry)->(dbSkip())
					Loop
				EndIf
			EndIf
			If (cAliasQry)->DTA_ORIGEM $ "2,3"
				CC2->(MsSeek(xFilial("CC2")+DUY->DUY_EST+DUY->DUY_CODMUN))
				If CC2->(!Eof()) .AND. CC2->(CC2_FILIAL+CC2_EST+CC2_CODMUN) == xFilial("CC2")+DUY->DUY_EST+DUY->DUY_CODMUN
					cUF := CC2->CC2_EST
					cUF	:= aUF[aScan(aUF, {|x| x[1] == AllTrim(cUF) }), 2]
					If aScan(aCdMunAux, {|x| x[1] == cUF + CC2->CC2_CODMUN}) == 0
						aAdd(aCdMunAux, {cUF + CC2->CC2_CODMUN, CC2->CC2_MUN})
					EndIf
				EndIf
			EndIf
			(cAliasQry)->(dbSkip())
		EndDo
		(cAliasQry)->(dbCloseArea())

		If !lOrigem
			If !Empty(aCdMunAux)
				aCdMunIni := aClone(aCdMunAux)
			EndIf
		Else
			For nI := 1 To Len(aCdMunAux)
				If aScan(aCdMunIni, {|x| x[1] == aCdMunAux[nI][1]}) == 0
					aAdd(aCdMunIni, {aCdMunAux[nI][1], aCdMunAux[nI][2]})
				EndIf
			Next
		EndIf
	Else
		cQuery	:= " SELECT CC2_EST , CC2_CODMUN , CC2_MUN "
		cQuery	+= " FROM " + RetSQLName("DUD") + " DUD "
		cQuery	+= " INNER JOIN " + RetSQLName("DTC") + " DTC "
		cQuery	+= "	ON DTC_FILIAL 	= '" + xFilial("DTC") + "' "
		cQuery	+= "	AND DTC_FILDOC 	= DUD_FILDOC "
		cQuery	+= "	AND DTC_DOC		= DUD_DOC "
		cQuery	+= "	AND DTC_SERIE	= DUD_SERIE "
		cQuery	+= "	AND DTC_SELORI	= '2' " //-- Origem = Cliente/Remetente
		cQuery	+= " 	AND DTC_NUMSOL IN ( "
		cQuery	+= " 		SELECT DT5_NUMSOL "
		cQuery	+= " 		FROM " + RetSQLName("DUD") + " DUD "
		cQuery	+= " 		INNER JOIN " + RetSQLName("DT5") + " DT5 "
		cQuery	+= "			ON DT5_FILIAL 	= '" + xFilial("DT5") + "' "
		cQuery	+= "			AND DT5_FILDOC 	= DUD_FILDOC "
		cQuery	+= "			AND DT5_DOC 	= DUD_DOC "
		cQuery	+= "			AND DT5_SERIE 	= DUD_SERIE "
		cQuery	+= " 			AND DT5.D_E_L_E_T_ = '' "
		cQuery	+= " 		WHERE DUD_FILIAL 	= '" + xFilial("DUD") + "' "
		cQuery	+= "			AND DUD_FILORI 	= '" + cFilOri + "' "
		cQuery	+= "			AND DUD_VIAGEM 	= '" + cViagem + "' "
		cQuery	+= " 			AND DUD.D_E_L_E_T_ = '' "
		cQuery	+= "	) "
		cQuery	+= "	AND DTC.D_E_L_E_T_ = '' "	
		cQuery	+= " INNER JOIN " + RetSQLName("DUY") + " DUY "
		cQuery	+= " 	ON DUY_FILIAL 	= '" + xFilial("DUY") + "' "
		cQuery	+= "	AND DUY_GRPVEN 	= DTC_CDRORI "
		cQuery	+= "	AND DUY.D_E_L_E_T_ = '' "
		cQuery	+= " INNER JOIN " + RetSQLName("CC2") + " CC2 "
		cQuery	+= "	ON CC2_FILIAL 	= '" + xFilial("CC2") + "' "
		cQuery	+= "	AND CC2_EST		= DUY_EST "
		cQuery	+= "	AND CC2_CODMUN	= DUY_CODMUN "
		cQuery	+= "	AND CC2.D_E_L_E_T_ = '' "
		cQuery	+= " WHERE DUD_FILIAL 	= '" + xFilial("DUD") + "' "
		cQuery	+= "	AND DUD_FILORI 	= '" + cFilOri + "' "
		cQuery	+= "	AND DUD_VIAGEM 	= '" + cViagem + "' "
		cQuery	+= "	AND DUD_MANIFE 	= '" + cManife + "' "
		cQuery	+= "	AND DUD_SERMAN 	= '" + cSerMan + "' "
		cQuery	+= " 	AND DUD.D_E_L_E_T_ = '' "

		cQuery	+= " UNION "

		cQuery	+= " SELECT CC2_EST , CC2_CODMUN , CC2_MUN "
		cQuery	+= " FROM " + RetSQLName("DUD") + " DUD "
		cQuery  += " INNER JOIN " + RetSqlName("DY4") + " DY4 "
		cQuery  += "	ON DY4.DY4_FILIAL = '" + xFilial("DY4") + "' "
		cQuery  += "	AND DY4.DY4_FILDOC = DUD_FILDOC "
		cQuery  += "	AND DY4.DY4_DOC = DUD_DOC "
		cQuery  += "	AND DY4.DY4_SERIE = DUD_SERIE "
		cQuery  += "	AND DY4.D_E_L_E_T_ = ' ' "	
		cQuery  += "INNER JOIN " + RetSqlName("DTC") + " DTC "
		cQuery  += "	ON DTC_FILIAL = '" + xFilial("DTC") + "' "
		cQuery  += "	AND DTC_FILORI = DY4.DY4_FILORI "
		cQuery  += "	AND DTC_LOTNFC = DY4.DY4_LOTNFC "
		cQuery  += "	AND DTC_NUMNFC = DY4.DY4_NUMNFC "
		cQuery  += "	AND DTC_SERNFC = DY4.DY4_SERNFC "
		cQuery  += "	AND DTC_CLIREM = DY4.DY4_CLIREM "
		cQuery  += "	AND DTC_LOJREM = DY4.DY4_LOJREM "
		cQuery  += "	AND DTC_CODPRO = DY4.DY4_CODPRO "
		cQuery	+= "	AND DTC_SELORI	= '2' " //-- Origem = Cliente/Remetente
		cQuery	+= " 	AND DTC_NUMSOL IN ( "
		cQuery	+= " 		SELECT DT5_NUMSOL "
		cQuery	+= " 		FROM " + RetSQLName("DUD") + " DUD "
		cQuery	+= " 		INNER JOIN " + RetSQLName("DT5") + " DT5 "
		cQuery	+= "			ON DT5_FILIAL 	= '" + xFilial("DT5") + "' "
		cQuery	+= "			AND DT5_FILDOC 	= DUD_FILDOC "
		cQuery	+= "			AND DT5_DOC 	= DUD_DOC "
		cQuery	+= "			AND DT5_SERIE 	= DUD_SERIE "
		cQuery	+= " 			AND DT5.D_E_L_E_T_ = '' "
		cQuery	+= " 		WHERE DUD_FILIAL 	= '" + xFilial("DUD") + "' "
		cQuery	+= "			AND DUD_FILORI 	= '" + cFilOri + "' "
		cQuery	+= "			AND DUD_VIAGEM 	= '" + cViagem + "' "
		cQuery	+= " 			AND DUD.D_E_L_E_T_ = '' "
		cQuery	+= "	) "
		cQuery	+= "	AND DTC.D_E_L_E_T_ = '' "	
		cQuery	+= " INNER JOIN " + RetSQLName("DUY") + " DUY "
		cQuery	+= " 	ON DUY_FILIAL 	= '" + xFilial("DUY") + "' "
		cQuery	+= "	AND DUY_GRPVEN 	= DTC_CDRORI "
		cQuery	+= "	AND DUY.D_E_L_E_T_ = '' "
		cQuery	+= " INNER JOIN " + RetSQLName("CC2") + " CC2 "
		cQuery	+= "	ON CC2_FILIAL 	= '" + xFilial("CC2") + "' "
		cQuery	+= "	AND CC2_EST		= DUY_EST "
		cQuery	+= "	AND CC2_CODMUN	= DUY_CODMUN "
		cQuery	+= "	AND CC2.D_E_L_E_T_ = '' "
		cQuery	+= " WHERE DUD_FILIAL 	= '" + xFilial("DUD") + "' "
		cQuery	+= "	AND DUD_FILORI 	= '" + cFilOri + "' "
		cQuery	+= "	AND DUD_VIAGEM 	= '" + cViagem + "' "
		cQuery	+= "	AND DUD_MANIFE 	= '" + cManife + "' "
		cQuery	+= "	AND DUD_SERMAN 	= '" + cSerMan + "' "
		cQuery	+= " 	AND DUD.D_E_L_E_T_ = '' "
		cQuery := ChangeQuery(cQuery)
		cAliasQry := GetNextAlias()
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry)		

		While (cAliasQry)->( !Eof() )
			cUF		:= (cAliasQry)->CC2_EST
			cUF		:= aUF[ aScan(aUF,{|x| x[1] == AllTrim(cUF) }), 2]
			If aScan(aCdMunIni, {|x| x[1] == cUF + (cAliasQry)->CC2_CODMUN}) == 0
				Aadd( aCdMunIni , { cUF + (cAliasQry)->CC2_CODMUN , (cAliasQry)->CC2_MUN } )
			EndIf
			(cAliasQry)->(dbSkip())
		EndDo
		(cAliasQry)->(dbCloseArea())
	EndIf
EndIf

RestArea(aArea)
Return

//-----------------------------------------------------------------
/*/{Protheus.doc} RetInfCTe()
Função para retornar as informações que compõe os dados do CTE para o
MDFE
@author Rafael Souza
@since 07/02/2019
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function RetInfCTe(cFilDoc,cDoc,cSerie,cChvCte,cChvCtg)

Local cQuery 	:= ""
Local cAliasDY3 := ""
Local cRet		:= "" 

Default cFilDoc := ""
Default cDoc	:= ""
Default cSerie  := ""
Default cChvCte := ""
Default cChvCtg	:= ""

cRet += '<infCTe>'                              
	cRet += '<chCTe>' +cChvCte+ '</chCTe>'	                                                                                   
If !Empty(cChvCtg)
	cRet += '<SegCodBarra>'+ Alltrim(cChvCtg) + '</SegCodBarra>'
EndIf	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TAG: N - Dados EspecIficos do Transporte de Produtos Perigosos  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If AliasInDic("DY3")
	cAliasDY3 := GetNextAlias()
	cQuery := " SELECT DY3.DY3_ONU, DY3.DY3_DESCRI, DY3.DY3_CLASSE, DY3.DY3_GRPEMB, DY3.DY3_LIMVEI " + CRLF
	cQuery += "  ,SUM(DTC.DTC_PESO) DTC_PESO " + CRLF
	cQuery += "       FROM " + RetSqlName("DTC") + " DTC " + CRLF
	cQuery += "           INNER JOIN " + RetSqlName("SB5") + " SB5 ON " + CRLF
	cQuery += "                 SB5.B5_FILIAL = '"  + xFilial('SB5')	+ "' AND " + CRLF
	cQuery += "                 SB5.B5_COD = DTC.DTC_CODPRO AND " + CRLF
	cQuery += "                 SB5.B5_CARPER = '1' AND " + CRLF
	cQuery += "                 SB5.D_E_L_E_T_ = '' " + CRLF
	cQuery += "           INNER JOIN " + RetSqlName("DY3") + " DY3 ON " + CRLF
	cQuery += "                 DY3.DY3_FILIAL = '"  + xFilial('DY3')	+ "' AND " + CRLF
	cQuery += "                 DY3.DY3_ONU    = SB5.B5_ONU AND " + CRLF
	cQuery += "                 DY3.DY3_ITEM   = SB5.B5_ITEM AND " + CRLF
	cQuery += "                 DY3.D_E_L_E_T_ = '' " + CRLF						
	cQuery += CRLF+" WHERE DTC.DTC_FILIAL = '" + xFilial('DTC')				+ "'" + CRLF
	cQuery += CRLF+"   AND DTC.DTC_FILDOC = '" + cFilDoc	+ "'" + CRLF
	cQuery += CRLF+"   AND (DTC.DTC_DOC   = '" + cDoc		+ "' OR DTC.DTC_DOCPER = '" + cDoc + "')" + CRLF
	cQuery += CRLF+"   AND DTC.DTC_SERIE  = '" + cSerie		+ "'" + CRLF
	cQuery += "   AND DTC.D_E_L_E_T_ = '' " + CRLF
	cQuery += "GROUP BY DY3.DY3_ONU, DY3.DY3_DESCRI, DY3.DY3_CLASSE, DY3.DY3_GRPEMB, DY3.DY3_LIMVEI " + CRLF
	cQuery += "ORDER BY DY3.DY3_ONU " + CRLF
	cQuery := ChangeQuery(cQuery)
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasDY3, .F., .T.)
	
	If !(cAliasDY3)->(Eof())
		While !(cAliasDY3)->(Eof())
			cRet += '<peri>'
			cRet += '<nONU>'+ Alltrim((cAliasDY3)->DY3_ONU) +'</nONU>'
			cRet += '<xNomeAE>'+ Upper(NoAcentoCte(SubStr((cAliasDY3)->DY3_DESCRI,1,150))) +'</xNomeAE>'
			cRet += '<xClaRisco>'+ NoPontos((cAliasDY3)->DY3_CLASSE) +'</xClaRisco>'
			If !Empty((cAliasDY3)->DY3_GRPEMB)
				cRet += '<grEmb>'+AllTrim((cAliasDY3)->DY3_GRPEMB)+'</grEmb>'
			EndIf
			cRet += '<qTotProd>'+AllTrim(STR((cAliasDY3)->DTC_PESO))+'</qTotProd>'
			cRet += '</peri>'
			(cAliasDY3)->(DbSkip())
		EndDo
	EndIf							
	(cAliasDY3)->(DbCloseArea())
EndIf
					
cRet += '</infCTe>'  

Return cRet 

/*/{Protheus.doc} TagProdPred
	(Informações sobre produto predominante / NOTA TECNICA 2020.001 - disponibilizado em produção na data de 06-04-2020 )
	@type  Function
	@author Tiago dos Santos
	@since 2020-02-18
	@version 1.0 
	@param param, param_type, param_descr
	@return return, String, Retorna estrutura do xml referente ao tag 
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function RetProdPred(cFilMan,cManife,cSerman) 
 Local cTagResult	:= ""
 Local cTipoCarga	:= "05"
 Local cProdDescr	:= ""
 Local cEAN			:= ""
 Local cNCM			:= ""
 Local cCEPOrigem	:= ""
 Local cOrigLatit	:= ""
 Local cOrigLongi	:= ""
 Local cCEPDestin	:= ""
 Local cDestLatit	:= ""
 Local cDestLongi	:= ""
 Local oJResult		:= Nil
 Local lCargaLot	:= TMSQtDocVg(,, cFilMan, cManife, cSerman) == 1 

			/*
			//-- a função ProdPred retorna um JsonObject com os seguintes atributos:
			JResult['PRODUTO'    ] //-- Codigo do Produto (SB1)
			JResult['UNIDMEDIDA' ] //-- Unidade de MEdida
			jResult['DOCTOAPOIO' ] //-- documento de apoio? .T. ou .F.
			jResult['OBSERVACAO' ] //-- observações provenientes da Entrada de NF Cliente
			jResult['DOCTODPC'   ] //-- Numero Documento CT-e Despachante
			jResult['SERIEDPC'   ] //-- Serie CT-e Despachante
			jResult['TPDOCTOANT' ] //-- Tipo do Documento do Despachante 0=CTRC;2=ACT;3=Nota Fiscal;4=AWB;5=Outros
			jResult['EMISSAODPC' ] //-- Data Emissão do Documento do Despachante
			jResult['NRDOCTOANT' ] //-- Numero do Documento Anterior
			jResult['TIPONF'     ] //-- Tipo da NF -0=Normal;1=Devolucao;2=SubContratacao;3=Nao Fiscal;4=Exportacao;5=Redesp;6=Nao Fiscal 1;7=Nao Fiscal 2;8=Serv Vincul.Multimodal
			JResult['DEVEDOR'    ] //-- Devedor do Frete - 1=Remetente;2=Destinatario;3=Consignatario;4=Despachante;6=Expedidor;7=Recebedor
			JResult['SELORIGEM'  ] //-- Selecao de Origem
			JResult['SEQENDDES'  ] //-- Sequencia de Endereco de Entrega
			JResult['FILORIGEM'  ] //-- Filial de Origem do Documento
			JResult['SOLICITACAO'] //-- Numero da Solicitacao de Coleta
			JResult['INSREMOPC'  ] //-- Inscricao Estadual do Remetente proveniente da tabela DV3
			JResult['INSDESOPC'  ] //-- Inscricao Estadual do Destinatario proveniente da tabela DV3
			JResult['INSAUXOPC'  ] 
			JResult['INSDESOPC'  ] 
			JResult['INSREMOPC'  ]
			JResult['DSCPRODUTO' ] //-- Descrição do Produto
 			JResult['NCM'        ] //-- Nomenclatura Comum do Mercosul (NCM)
 			JResult['cEAN'       ] //-- Codigo de Barras do Produto
 			JResult['TIPOCARGA'  ] //-- Tipo da Carga Conforme Resolução ANTT nº.  5.849/2019. 
			*/

		oJResult :=	ProdPred(,,,0,cFilMan,cManife,cSerman) 

		cProdDescr	:= oJResult['DSCPRODUTO' ]
		cNCM		:= oJResult['NCM'        ] //-- Nomenclatura Comum do Mercosul (NCM)
		cEAN		:= oJResult['cEAN'       ] //-- Codigo de Barras do Produto
		cTipoCarga	:= IIf(Empty(oJResult['TIPOCARGA']), "05", oJResult['TIPOCARGA']) //-- Tipo da Carga Conforme Resolução ANTT nº.  5.849/2019. 
		cCEPOrigem	:= oJResult['cCEPOrigem' ]
		cOrigLatit	:= oJResult['cOrigLatit' ]
		cOrigLongi	:= oJResult['cOrigLongi' ]
		cCEPDestin	:= oJResult['cCEPDestin' ]
		cDestLatit	:= oJResult['cDestLatit' ]
		cDestLongi	:= oJResult['cDestLongi' ]

		cTagResult := '<prodPred>'
		cTagResult += '<tpCarga>' + AllTrim(cTipoCarga) + '</tpCarga>'
		cTagResult += '<xProd>' + AllTrim(cProdDescr) + '</xProd>'
		If !Empty(cEAN)
			cTagResult += '<cEAN>' + AllTrim(cEAN) + '</cEAN>'
		EndIf
		If !Empty(cNCM)
			cTagResult += '<NCM>' + AllTrim(cNCM) + '</NCM>'
		EndIf
		If lCargaLot
			cTagResult += '<infLotacao>'
			cTagResult += '<infLocalCarrega>'			
			If !Empty(cOrigLatit)  .And. !Empty(cOrigLongi)
				cTagResult += '<latitude>'+cOrigLatit+'</latitude>'
				cTagResult += '<longitude>'+cOrigLongi+'</longitude>'
			Else
				cTagResult += '<CEP>'+cCEPOrigem+'</CEP>'
			EndIf
			cTagResult += '</infLocalCarrega>'
			cTagResult += '<infLocalDescarrega>'			
			If !Empty(cDestLatit)  .And. !Empty(cDestLongi)
				cTagResult += '<latitude>'+cDestLatit+'</latitude>'
				cTagResult += '<longitude>'+cDestLongi+'</longitude>'
			Else
				cTagResult += '<CEP>'+cCEPDestin+'</CEP>'
			EndIf			
			cTagResult += '</infLocalDescarrega>'
			cTagResult += '</infLotacao>'
		EndIf
		cTagResult += '</prodPred>'

Return cTagResult

//-----------------------------------------------------------------
/*/{Protheus.doc} RetInfMot()
Função para retornar as informações do Motorista (DA4)
@author Katia
@since 09/03/2020
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function RetInfMot(cFilOri, cViagem, cDTRItem)
Local cQuery    := ""
Local aRet      := {}
Local cAliasDA4 := GetNextAlias()
Local aArea     := GetArea()

Default cFilOri := ""
Default cViagem := ""
Default cDTRItem:= "" 

	cQuery := " SELECT DA4_COD,DA4_NOME,DA4_CGC,DA4_TIPMOT "
	cQuery += CRLF+" FROM " + RetSqlName("DA4") + " DA4 "	        	
	cQuery += CRLF+" INNER JOIN " + RetSqlName("DUP") + " DUP ON "
	cQuery += CRLF+ "       DUP.DUP_FILIAL = '" + xFilial("DUP") + "' AND "
	cQuery += CRLF+ "       DUP_FILORI     = '" + cFilOri + "' AND "
	cQuery += CRLF+ "       DUP_VIAGEM     = '" + cViagem + "' AND "
	cQuery += CRLF+ "       DUP_ITEDTR     = '" + cDTRItem + "' AND "
	cQuery += CRLF+"        DUP.D_E_L_E_T_ = '' "
	cQuery += CRLF+ " WHERE DA4_FILIAL     = '" + xFilial("DA4") + "' AND "
	cQuery += CRLF+"        DA4.DA4_COD = DUP.DUP_CODMOT  AND "
	cQuery += CRLF+ "       DA4.D_E_L_E_T_ = '' "
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDA4,.F.,.T.)
	While (cAliasDA4)->(!Eof())
		aAdd(aRet, {(cAliasDA4)->DA4_COD, NoAcentoCte((cAliasDA4)->DA4_NOME), AllTrim((cAliasDA4)->DA4_CGC), (cAliasDA4)->DA4_TIPMOT})
		(cAliasDA4)->(dbSkip())
	EndDo
	(cAliasDA4)->(dbCloseArea())

RestArea(aArea)
Return aRet

//-----------------------------------------------------------------
/*/{Protheus.doc} RetNumPIX()
Função para retornar numero do PIX do Motorista (DA4)
@author Fabio
@since 23/02/2021
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function RetNumPIX(cCodForn, cLojForn)

Local cRet       := ""
Local cQuery     := ""
Local cAliasPIX  := GetNextAlias()
Local aArea      := GetArea()
Local lF72       := AliasInDic("F72")

Default cCodForn := ""
Default cLojForn := ""

If lF72
	cQuery := " SELECT F72_CHVPIX "
	cQuery += CRLF+" FROM " + RetSqlName("F72") + " F72 "	        	
	cQuery += CRLF+ " WHERE F72.F72_FILIAL = '" + xFilial("F72") + "' AND "
	cQuery += CRLF+ "       F72_COD      = '" + cCodForn + "' AND "
	cQuery += CRLF+ "       F72_LOJA     = '" + cLojForn + "' AND "
	cQuery += CRLF+"        F72.D_E_L_E_T_ = '' "
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasPIX,.F.,.T.)
	If (cAliasPIX)->(!Eof())
		cRet := (cAliasPIX)->F72_CHVPIX
	EndIf

	(cAliasPIX)->(dbCloseArea())
	RestArea(aArea)
EndIf

Return cRet


//-----------------------------------------------------------------
/*/{Protheus.doc} RetNumPIX()
Função para retornar caracteristicas do veiculo (DA3)
@author Fabio
@since 23/02/2021
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function QtdEixVei(cFilOri, cViagem)

Local cQuery     := ""
Local cAliasDTR  := GetNextAlias()
Local aArea      := GetArea()
Local nQtdEixo   := 0

Default cFilOri := ""
Default cViagem := ""

	cAliasDTR := GetNextAlias()                           
													
	cQuery    := "SELECT DTR_CODVEI, DTR_CODRB1, DTR_CODRB2, DTR_CODRB3, DTR_ITEM "
	cQuery    += " FROM " + RetSqlName("DTR")+" DTR "
	cQuery    += " WHERE DTR_FILIAL = '"+xFilial('DTR')+"'"
	cQuery    += "   AND DTR_FILORI = '"+cFilOri+"'"
	cQuery    += "   AND DTR_VIAGEM = '"+cViagem+"'"
	cQuery    += "   AND DTR.D_E_L_E_T_ = ' '"
	cQuery    := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDTR,.F.,.T.)
	If (cAliasDTR)->(!Eof())

		DA3->( dbSetOrder( 1 ) )
		If DA3->( MsSeek( xFilial("DA3") + (cAliasDTR)->DTR_CODVEI ) )
			nQtdEixo:= DA3->DA3_QTDEIX
		Endif
		If !Empty((cAliasDTR)->DTR_CODRB1)
			If DA3->( MsSeek( xFilial("DA3") + (cAliasDTR)->DTR_CODRB1 ) )
				nQtdEixo += DA3->DA3_QTDEIX
			Endif
		EndIF
		If !Empty((cAliasDTR)->DTR_CODRB2)
			If DA3->( MsSeek( xFilial("DA3") + (cAliasDTR)->DTR_CODRB2 ) )
				nQtdEixo += DA3->DA3_QTDEIX
			Endif
		EndIf
		If !Empty((cAliasDTR)->DTR_CODRB3)
			If DA3->( MsSeek( xFilial("DA3") + (cAliasDTR)->DTR_CODRB3 ) )
				nQtdEixo += DA3->DA3_QTDEIX
			Endif
		EndIf

	EndIf

	(cAliasDTR)->(dbCloseArea())
RestArea(aArea)

Return nQtdEixo
