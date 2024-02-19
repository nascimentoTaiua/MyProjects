#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³RTMSR32   ³ Autor ³Katia                  ³ Data ³07/05/13  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao responsavel por imprimir o DAMDFE                    ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RTMSR32()
Local aCab				:= {}
Local oFont08			:= TFont():New("Times New Roman",08,08,,.F.,,,,.T.,.F.)
Local oFont08N			:= TFont():New("Times New Roman",08,08,,.T.,,,,.T.,.F.)
Local oFont10			:= TFont():New("Times New Roman",10,10,,.F.,,,,.T.,.F.)
Local oFont10N			:= TFont():New("Times New Roman",10,10,,.T.,,,,.T.,.F.)
Local cPerg				:= Iif(__lPyme,'RTMSR32P', 'RTMSR32')
Local nCont				:= 0
Local lSeqDes			:= .F.
//-- Buscar dados XML
Local aNotas			:= {}
Local aXML				:= {}
Local cAviso			:= ""
Local cErro				:= ""
Local cAutoriza			:= ""
Local cModalidade		:= ""
Local cIdEnt			:= ""
Local nX				:= 0
Local cStartPath
Local cSerie			:= Padr(0,Len(DT6->DT6_SERIE))
Local cModelo			:= "58"
Local nLinha			:= 0
Local nCount			:= 0
Local cFilePrint		:= ""
Local nQCTE				:= 0
Local cHoraBase     	:= ""
Local cRNTRC			:= ""
Local cAliasDA3			:= ""
Local cObs				:= ""
Local lDTX_SERMAN		:= DTX->(FieldPos("DTX_SERMAN")) > 0
Local nContChv			:= 0
Local nLinCTe			:= 0
Local nColTipo			:= 0
Local nColChave   		:= 0
Local cChaveCTe			:= ""
Local lXmlCont			:= .T.
Local nLinReb			:= 0
Local nCntFor			:= 0
Local lImp				:= .F.
Local lMDFEAUT    		:= SuperGetMv('MV_MDFEAUT',,.F.) .And. ExistFunc("TmsMDFeAut") //--MDFe Automático
Local lTercRbq    		:= DTR->(ColumnPos("DTR_CODRB3")) > 0

//-- Variaveis Private
Private cAliasMDF		:= GetNextAlias()
Private oDamdfe
Private nLInic			:= 0	// Linha Inicial
Private nLFim			:= 0	// Linha Inicial
Private nDifEsq			:= 0	// Variavel com Diferenca para alinhar os Print da Esquerda com os da Direita
Private cInsRemOpc		:= ''	// Remetente com sequencia de IE
Private nFolhas			:= 0
Private nFolhAtu		:= 1
Private PixelX			:= nil
Private PixelY			:= nil
Private nMM		   		:= 0
Private lXml			:= .T.
Private lComp			:= .F.	//CTE Complementar
Private lUsaColab		:= UsaColaboracao("5")
Private oNfe


//Verifica se o arquivo sera gerado em Remote Linux
cStartPath := GetTempPath(.T.)

If lMDFEAUT .And. IsInCallStack("TmsMDFeAut")
	Pergunte(cPerg,.F.)	
	For nCntFor := 1 To Len(PARAMIXB)	
		mv_par04 := PARAMIXB[nCntFor][1]  
		mv_par05 := PARAMIXB[nCntFor][1]  		
		mv_par06 := PARAMIXB[nCntFor][2] 
		mv_par07 := PARAMIXB[nCntFor][3]  
		mv_par08 := PARAMIXB[nCntFor][4]  	
		mv_par09 := PARAMIXB[nCntFor][4]  
		mv_par02 := PARAMIXB[nCntFor][5] 
		mv_par03 := PARAMIXB[nCntFor][5] 
		lImp     := PARAMIXB[nCntFor][7]	
		
	Next nCntFor
	
ElseIf !Pergunte(cPerg,.T.) 
 	Return()
EndIf

If	!lUsaColab .And. !TMSSpedNFe(@cIdEnt,@cModalidade,,lUsaColab,cModelo)
	Return()
EndIf

//Se for contingencia nao busca do XML
If SubStr(cModalidade,1,1) == '2'
	lXmlCont = .F.
EndIf

// Cria Arquivo de Trabalho - Documentos de Transporte
cAliasMDF := DataSource( 'DTX' )

cFilePrint:= "DAMDFE_"+cIdEnt+Dtos(MSDate())+StrTran(Time(),":","")

oDamdfe:=FWMSPrinter():New(cFilePrint,IMP_PDF,.F./*lAdjustToLegacy*/,/*cStartPath*/, lImp /*lDisabeSetup*/,/*lTReport*/,@oDamdfe,/*cPrinter*/,.F./*lServer*/,/*lPDFAsPNG*/,/*lRaw*/,.T./*lViewPDF*/,/*nQtdCopy*/)
oDamdfe:SetResolution(72)
oDamdfe:SetLandscape()
oDamdfe:SetPaperSize(DMPAPER_A4)
oDamdfe:SetMargin(60,60,60,60)
    
//--Salvar arquivo na pasta temporaria deverá seleciona no TOTVSPrinter Servidor,
//--Caso contrário salvará na pasta selecionada.
If oDamdfe:LSERVER == .T. 
	oDamdfe:cPathPDF := cStartPath //--Pasta Temp.
EndIf

PixelX  := oDamdfe:nLogPixelX()
PixelY  := oDamdfe:nLogPixelY()
nMM     := 0

While !(cAliasMDF)->(Eof())
	nCount:= 1
	oDamdfe:StartPage()

	If lDTX_SERMAN .And. !Empty((cAliasMDF)->DTX_SERMAN)
		cSerie := (cAliasMDF)->DTX_SERMAN
	EndIf

	//-- Buscar XML do WebService
	If lXml
		aNotas := {}
		aadd(aNotas,{})
		aAdd(Atail(aNotas),.F.)

		aadd(Atail(aNotas),"")
		aAdd(Atail(aNotas),"")
		If lUsaColab
			aAdd(Atail(aNotas),cSerie)
		Else
			aAdd(Atail(aNotas),'58'+cSerie)
		EndIf
		aAdd(Atail(aNotas),(cAliasMDF)->DTX_MANIFE) //Documento
		aadd(Atail(aNotas),"")
		aadd(Atail(aNotas),"")

		nX   := 1
		aXml := {}
		If lUsaColab
			//-- TOTVS Colaboracao 2.0
			aXml := TMSColXML(aNotas,@cModalidade,lUsaColab,"58")
		Else
			aXml := TMSGetXML(cIdEnt,aNotas,@cModalidade,cModelo)
		EndIf
		If !Empty(aXML[nX][2])
			If !Empty(aXml[nX])
				cAutoriza   := aXML[nX][1]
				cCodAutDPEC := aXML[nX][5]
			Else
				cAutoriza   := ""
				cCodAutDPEC := ""
			EndIf
			cAviso := ""
			cErro  := ""
			oNfe := XmlParser(aXML[nX][2],"_",@cAviso,@cErro)
			oNfeDPEC := XmlParser(aXML[nX][4],"_",@cAviso,@cErro)
		EndIf
	EndIf

	nFolhas := 1

	If Type( 'oNfe:_MDFE:_INFMDFE:_IDE:_SERIE:TEXT' ) == 'U'
		lXml := .F. //Restricao de errorlog devido ao xml retornado
	EndIf

	cHoraBase:= StrTran(Left(Time(),5),':','')
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Controla o documento a ser enviado para montagem do cabecalho.         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nCont += 1
	If lXml
		aAdd(aCab, {;
		AllTrim((cAliasMDF)->DTX_MANIFE),;
		AllTrim(oNfe:_MDFE:_INFMDFE:_IDE:_SERIE:TEXT),;
		AllTrim(STRTRAN( SUBSTR( oNfe:_MDFE:_INFMDFE:_IDE:_dhEmi:TEXT, 1, AT('T', oNfe:_MDFE:_INFMDFE:_IDE:_dhEmi:TEXT) - 1) , '-', '')),;
		AllTrim(STRTRAN( SUBSTR( oNfe:_MDFE:_INFMDFE:_IDE:_dhEmi:TEXT, AT('T', oNfe:_MDFE:_INFMDFE:_IDE:_dhEmi:TEXT) + 1, 5) , ':', '')),;
		AllTrim(STRTRAN(UPPER(oNFE:_MDFE:_INFMDFE:_ID:TEXT),'MDFE','')),;
		AllTrim(aXML[nX][1]),;
		AllTrim((cAliasMDF)->DTX_CTGMDF),;
		aXML[nX][7],;
		aXML[nX][6] })
	Else
		aAdd(aCab, {;
		AllTrim((cAliasMDF)->DTX_MANIFE),;
		cSerie,;
		AllTrim((cAliasMDF)->DTX_DATMAN),;
		AllTrim((cAliasMDF)->DTX_HORMAN),;
		AllTrim((cAliasMDF)->DTX_CHVMDF),;
				(cAliasMDF)->DTX_PRIMDF,;
		AllTrim((cAliasMDF)->DTX_CTGMDF),;
		Iif((cAliasMDF)->DTX_FIMP == StrZero(1, Len(DTX->DTX_FIMP)), (cAliasMDF)->DTX_DATIMP, DtoS(dDataBase)),;
		Iif((cAliasMDF)->DTX_FIMP == StrZero(1, Len(DTX->DTX_FIMP)), (cAliasMDF)->DTX_HORIMP, cHoraBase) })
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Funcao responsavel por montar o cabecalho do relatorio                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nFolhAtu := 1
	lSeqDes  :=.F.
	TMSR32Cab(aCab[nCont],lXml)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ BOX: MODAL RODOVIARIO DE CARGA                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oDamdfe:Box(0165, 0000, 180, 0800)
	oDamdfe:Say(0175, 0350, "Modal Rodoviário de Carga", oFont08N)

	oDamdfe:Box(0180, 0000, 230, 0800)

	oDamdfe:Say(0188, 0005, "Qtd. CT-e", oFont08)
	If lXml
		If Type("oNfe:_MDFE:_INFMDFE:_TOT:_QCTE") <> "U"
			nQCTE:= oNfe:_MDFE:_INFMDFE:_TOT:_QCTE:TEXT
		EndIf
	Else
		nQCTE:= (cAliasMDF)->DTX_QTDCTE
	EndIf
	oDamdfe:Say(0208, 0010, cValtoChar( nQCTE ), oFont10)

	oDamdfe:Box(0180, 0150, 230, 0800)
	oDamdfe:Say(0188, 0155, "Qtd. NF-e", oFont08)

	If lXML
		nQCarga:= oNfe:_MDFE:_INFMDFE:_TOT:_QCARGA:TEXT
	Else
		nQCarga:= (cAliasMDF)->DTX_PESO
	EndIf
	oDamdfe:Box(0180, 0300, 230, 0800)
	oDamdfe:Say(0188, 0315, "Peso Total (Kg)", oFont08)
	oDamdfe:Say(0208, 0315, cValtoChar(nQCarga), oFont10)
	oDamdfe:Box(0180, 0450, 230, 0800)

	oDamdfe:Box(0230, 0000, 245, 0300)
	oDamdfe:Say(0237, 0005, "Veículo", oFont08)

	oDamdfe:Box(0230, 0300, 245, 0800)
	oDamdfe:Say(0237, 0305, "Condutor", oFont08)

	oDamdfe:Box(0245, 0000, 260, 0150)
	oDamdfe:Say(0252, 0005, "Placa", oFont08)

	oDamdfe:Box(0245, 0150, 260, 0300)
	oDamdfe:Say(0252, 0155, "RNTRC", oFont08)

	oDamdfe:Box(0245, 0300, 260, 0400)
	oDamdfe:Say(0252, 0305, "CPF", oFont08)

	oDamdfe:Box(0245, 0400, 260, 0800)
	oDamdfe:Say(0252, 0405, "Nome", oFont08)

	//-- Dados da Placa
	oDamdfe:Box(0260, 0000, 310, 0150)
	If lXml
		oDamdfe:Say(0270, 0005, AllTrim(oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICTRACAO:_PLACA:TEXT), oFont08)
		If Type("oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICREBOQUE") <> "U"
			If Type( "oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICREBOQUE" ) <> "A"
				oDamdfe:Say(0278, 0005, AllTrim(oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICREBOQUE:_PLACA:TEXT), oFont08)
			Else
				nLinReb	:= 278
				For nCount := 1 To Len (oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICREBOQUE)
					oDamdfe:Say(nLinReb, 0005, AllTrim(oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICREBOQUE[nCount]:_PLACA:TEXT), oFont08)
					nLinReb += 10
				Next nCount
			EndIf
		EndIF
	Else
		//--- Veiculo
		If __lPyme
			cCodVei := (cAliasMDF)->DYB_CODVEI
			cAliasDA3 := DataSource( 'DA3' )
			cRNTRC  := (cAliasDA3)->A2_RNTRC
			oDamdfe:Say(0270, 0005, AllTrim((cAliasDA3)->DA3_PLACA), oFont08)
			(cAliasDA3)->(dbCloseArea())
			//--- Reboque 1
			cCodVei := (cAliasMDF)->DYB_CODRB1
			cAliasDA3 := DataSource( 'DA3' )
			oDamdfe:Say(0278, 0005, AllTrim((cAliasDA3)->DA3_PLACA), oFont08)
			(cAliasDA3)->(dbCloseArea())
			//--- Reboque 2
			cCodVei := (cAliasMDF)->DYB_CODRB2
			cAliasDA3 := DataSource( 'DA3' )
			oDamdfe:Say(0286, 0005, AllTrim((cAliasDA3)->DA3_PLACA), oFont08)
			(cAliasDA3)->(dbCloseArea())
			//--- Reboque 3 
			If lTercRbq
				cCodVei := (cAliasMDF)->DYB_CODRB3
				cAliasDA3 := DataSource( 'DA3' )
				oDamdfe:Say(0294, 0005, AllTrim((cAliasDA3)->DA3_PLACA), oFont08)
				(cAliasDA3)->(dbCloseArea())
			EndIf 
		Else
			cCodVei := (cAliasMDF)->DTR_CODVEI
			cAliasDA3 := DataSource( 'DA3' )
			cRNTRC  := (cAliasDA3)->A2_RNTRC
			oDamdfe:Say(0270, 0005, AllTrim((cAliasDA3)->DA3_PLACA), oFont08)
			(cAliasDA3)->(dbCloseArea())
			//--- Reboque 1
			cCodVei := (cAliasMDF)->DTR_CODRB1
			cAliasDA3 := DataSource( 'DA3' )
			oDamdfe:Say(0278, 0005, AllTrim((cAliasDA3)->DA3_PLACA), oFont08)
			(cAliasDA3)->(dbCloseArea())
			//--- Reboque 2
			cCodVei := (cAliasMDF)->DTR_CODRB2
			cAliasDA3 := DataSource( 'DA3' )
			oDamdfe:Say(0286, 0005, AllTrim((cAliasDA3)->DA3_PLACA), oFont08)
			(cAliasDA3)->(dbCloseArea())
			//--- Reboque 3 
			If lTercRbq
				cCodVei := (cAliasMDF)->DTR_CODRB3
				cAliasDA3 := DataSource( 'DA3' )
				oDamdfe:Say(0294, 0005, AllTrim((cAliasDA3)->DA3_PLACA), oFont08)
				(cAliasDA3)->(dbCloseArea())
			EndIf 
		EndIf
	EndIf

	//--- Dados do RNTRC
	oDamdfe:Box(0260, 0150, 310, 0300)
	If lXml
		If Type('oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICTRACAO:_PROP:_RNTRC') <> 'U'
			oDamdfe:Say(0270, 0155, AllTrim(oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICTRACAO:_PROP:_RNTRC:TEXT), oFont08)
		EndIf
		If Type("oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICREBOQUE:_PROP:_RNTRC") <> "U"
			If Type( "oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICREBOQUE" ) <> "A"
				oDamdfe:Say(0278, 0155, AllTrim(oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICREBOQUE:_PROP:_RNTRC:TEXT), oFont08)
			Else
				nLinReb	:= 278
				For nCount := 1 To Len (oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICREBOQUE)
					oDamdfe:Say(nLinReb, 0155, AllTrim(oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICREBOQUE[nCount]:_PROP:_RNTRC:TEXT), oFont08)
					nLinReb += 10
				Next nCount
			EndIf
		EndIf

		If Type('oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICTRACAO:_PROP:_RNTRC') = 'U'
			If Type('oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_infANTT:_RNTRC') <> 'U'
				oDamdfe:Say(0270, 0155, AllTrim(oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_infANTT:_RNTRC:TEXT), oFont08)
			EndIf
		EndIf

	Else
		oDamdfe:Say(0270, 0155, AllTrim(cRNTRC), oFont08)
	EndIf

	//--- Vale Pedagio
	oDamdfe:Box(0310, 0000, 325, 0300)
	oDamdfe:Say(0320, 0005, "Vale Pedágio", oFont08)

	oDamdfe:Box(0325, 0000, 390, 0300)
	oDamdfe:Say(0335, 0005, "Responsável CNPJ", oFont08)
	If Type('oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_INFANTT:_VALEPED:_DISP:_CNPJPG') <> 'U'
		oDamdfe:Say(0355, 0010, oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_INFANTT:_VALEPED:_DISP:_CNPJPG:TEXT, oFont10)
	EndIf

	oDamdfe:Box(0325, 0100, 390, 0300)
	oDamdfe:Say(0335, 0105, "Fornecedora CNPJ", oFont08)
	If Type('oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_INFANTT:_VALEPED:_DISP:_CNPJFORN') <> 'U'
		oDamdfe:Say(0355, 0110, oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_INFANTT:_VALEPED:_DISP:_CNPJFORN:TEXT, oFont10)
	EndIf	

	oDamdfe:Box(0325, 0200, 390, 0300)
	oDamdfe:Say(0335, 0205, "Nro Comprovante", oFont08)
	If Type('oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_INFANTT:_VALEPED:_DISP:_NCOMPRA') <> 'U'
		oDamdfe:Say(0355, 0210, oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_INFANTT:_VALEPED:_DISP:_NCOMPRA:TEXT, oFont10)
	EndIf	
	//--- Dados Condutor CPF  e Nome
	oDamdfe:Box(0260, 0300, 390, 0400)
	oDamdfe:Box(0260, 0400, 390, 0800)

	If lXML
		If Type( "oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICTRACAO:_CONDUTOR" ) <> "A"
			oDamdfe:Say(0270, 0305, Transform(AllTrim(oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICTRACAO:_CONDUTOR:_CPF:TEXT),"@r 999.999.999-99"), oFont08)
			oDamdfe:Say(0270, 0405, AllTrim(oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICTRACAO:_CONDUTOR:_XNOME:TEXT), oFont08)
		Else
			nLinha:= 270
			For nCount := 1 To Len( oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICTRACAO:_CONDUTOR )
				oDamdfe:Say(nLinha, 0305, Transform(AllTrim(oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICTRACAO:_CONDUTOR[nCount]:_CPF:TEXT),"@r 999.999.999-99"), oFont08)
				oDamdfe:Say(nLinha, 0405, AllTrim(oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICTRACAO:_CONDUTOR[nCount]:_XNOME:TEXT), oFont08)
				nLinha+= 10
			Next nCount
		EndIf
	Else
		nLinha:= 270
		DUP->(DbSetOrder(1))
		If DUP->(MsSeek(xFilial('DUP')+(cAliasMDF)->DTX_FILORI+(cAliasMDF)->DTX_VIAGEM))
			While DUP->(!Eof()) .And. (DUP->DUP_FILORI == (cAliasMDF)->DTX_FILORI .AND. DUP->DUP_VIAGEM == (cAliasMDF)->DTX_VIAGEM)
				cCodMoto := DUP->DUP_CODMOT
				oDamdfe:Say(nLinha, 0305, Transform(AllTrim(Posicione("DA4",1,xFilial('DA4')+cCodMoto,'DA4_CGC')),"@r 999.999.999-99"), oFont08)
				oDamdfe:Say(nLinha, 0405, AllTrim(Posicione("DA4",1,xFilial('DA4')+cCodMoto,'DA4_NOME')), oFont08)
				nLinha+= 10
				DUP->(DbSkip())
			EndDo
		EndIf
	EndIf

	If !lXmlCont
		//--- Somente apresenta esse box quando for contingencia
	  	oDamdfe:Box(0390, 0000, 600, 0800)
		oDamdfe:Say(0400, 0380, "Informações da Composição da Carga", oFont08)
	  	oDamdfe:Box(0405, 0000, 600, 0800)
		oDamdfe:Say(0415, 0005, "Informações dos Documentos Fiscais vinculados ao Manifesto", oFont08)
	  	oDamdfe:Box(0405, 0500, 600, 0800)
		oDamdfe:Say(0415, 0505, "Identificação de Unidade de Transporte", oFont08)
	  	oDamdfe:Box(0405, 0650, 600, 0800)
		oDamdfe:Say(0415, 0655, "Identificação de Unidade de Carga", oFont08)
	  	oDamdfe:Box(0420, 0000, 600, 0800)
	  	oDamdfe:Box(0420, 0500, 600, 0800)
	  	oDamdfe:Box(0420, 0650, 600, 0800)

		oDamdfe:Say(0430, 0005, "Tipo", oFont08)
		oDamdfe:Say(0430, 0030, "Chave", oFont08)
		oDamdfe:Say(0430, 0250, "Tipo", oFont08)
		oDamdfe:Say(0430, 0280, "Chave", oFont08)

	    //Tag INFCTE
		If (Type( "oNFe:_MDFE:_INFMDFE:_INFDOC:_INFMUNDESCARGA:_INFCTE") <> 'U')
			If (ValType(oNFe:_MDFE:_INFMDFE:_INFDOC:_INFMUNDESCARGA:_INFCTE)  =='A')
			   nLinCTe			:= 0440
			   nColTipo		:= 0005
			   nColChave    	:= 0030
	           For nContChv 	:= 1 to len(oNFe:_MDFE:_INFMDFE:_INFDOC:_INFMUNDESCARGA:_INFCTE)
					cChaveCTe 	:= oNFe:_MDFE:_INFMDFE:_INFDOC:_INFMUNDESCARGA:_INFCTE[nContChv]:_CHCTE:TEXT
					oDamdfe:Say(nLinCTE, nColTipo , "CTe"    , oFont08)
					oDamdfe:Say(nLinCTE, nColChave, cChaveCTe, oFont08)
					nLinCTe += 10
					If nLinCTe		= 0530
						nColTipo	:= 0250
						nColChave	:= 0280
					EndIf
			   Next
			Else
	            cChaveCTe := oNFe:_MDFE:_INFMDFE:_INFDOC:_INFMUNDESCARGA:_INFCTE:_CHCTE:TEXT
	            oDamdfe:Say(0440, 0005, "CTe"    , oFont08)
	  	        oDamdfe:Say(0440, 0030, cChaveCTe, oFont08)
			EndIf
		ElseIf (Type( "oNFe:_MDFE:_INFMDFE:_INFDOC:_INFMUNDESCARGA") <> 'U')
			If (ValType(oNFe:_MDFE:_INFMDFE:_INFDOC:_INFMUNDESCARGA)  =='A')
			   nLinCTe			:= 0440
			   nColTipo		:= 0005
			   nColChave    	:= 0030
	           For nContChv 	:= 1 to len(oNFe:_MDFE:_INFMDFE:_INFDOC:_INFMUNDESCARGA)
					cChaveCTe 	:= oNFe:_MDFE:_INFMDFE:_INFDOC:_INFMUNDESCARGA[nContChv]:_INFCTE:_CHCTE:TEXT
					oDamdfe:Say(nLinCTE, nColTipo , "CTe"    , oFont08)
					oDamdfe:Say(nLinCTE, nColChave, cChaveCTe, oFont08)
					nLinCTe += 10
					If nLinCTe		= 0530
						nColTipo	:= 0250
						nColChave	:= 0280
					EndIf
			   Next
			Else
	            cChaveCTe := oNFe:_MDFE:_INFMDFE:_INFDOC:_INFMUNDESCARGA:_INFCTE:_CHCTE:TEXT
	            oDamdfe:Say(0440, 0005, "CTe"    , oFont08)
	  	        oDamdfe:Say(0440, 0030, cChaveCTe, oFont08)
			EndIf
		EndIf
		//--- Observacoes
	  	oDamdfe:Box(0545, 0000, 600, 0800)
	 	oDamdfe:Say(0555, 0005, "Observação", oFont08)
	 	If (lXML .And. oNfe:_MDFE:_INFMDFE:_IDE:_TPAMB:TEXT == '2') .Or. ((cAliasMDF)->DTX_AMBIEN == 2)
	  		oDamdfe:Say(0565, 0005, "MANIFESTO GERADO EM AMBIENTE DE HOMOLOGAÇÃO", oFont10N)
		EndIf
		If Type("oNfe:_MDFE:_INFMDFE:_infAdic:_infAdFisco:TEXT") != "U"
		 	cObs := oNfe:_MDFE:_INFMDFE:_infAdic:_infAdFisco:TEXT
			oDamdfe:Say(0585, 0005,Substr(cObs,1,110), oFont10N)
			oDamdfe:Say(0605, 0005,Substr(cObs,111,110), oFont10N)
			oDamdfe:Say(0625, 0005,Substr(cObs,221,100), oFont10N)
		EndIf
	Else
		//--- Observacoes
	  	oDamdfe:Box(0390, 0000, 500, 0800)
	 	oDamdfe:Say(0400, 0005, "Observação", oFont08)
	 	If (lXML .And. oNfe:_MDFE:_INFMDFE:_IDE:_TPAMB:TEXT == '2') .Or. ((cAliasMDF)->DTX_AMBIEN == 2)
	  		oDamdfe:Say(0420, 0005, "MANIFESTO GERADO EM AMBIENTE DE HOMOLOGAÇÃO", oFont10N)
		EndIf
		If Type("oNfe:_MDFE:_INFMDFE:_infAdic:_infAdFisco:TEXT") != "U"
			cObs := oNfe:_MDFE:_INFMDFE:_infAdic:_infAdFisco:TEXT
			oDamdfe:Say(0440, 0005,Substr(cObs,1,110), oFont10N)
			oDamdfe:Say(0460, 0005,Substr(cObs,111,110), oFont10N)
			oDamdfe:Say(0480, 0005,Substr(cObs,221,100), oFont10N)
		EndIf
	EndIf

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualizar o Status de Impressao no DAMDFE                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DTX->(dbSetOrder(1))
	If	DTX->(MsSeek(xFilial('DTX')+(cAliasMDF)->DTX_MANIFE+(cAliasMDF)->DTX_SERMAN)) .And. DTX->DTX_FIMP <> StrZero(1, Len(DTX->DTX_FIMP))
		RecLock('DTX',.F.)
		DTX->DTX_FIMP  := StrZero(1, Len(DTX->DTX_FIMP))
		DTX->DTX_DATIMP:= dDataBase
		DTX->DTX_HORIMP:= cHoraBase
		MsUnLock()
	EndIf

	oDamdfe:EndPage()

	(cAliasMDF)->(DbSkip())
EndDo

(cAliasMDF)->(dbCloseArea())
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TERMINO ROTINA DE IMPRESSAO                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//If File(cStartPath+cFilePrint+".REL")
	//-- Caso necessario, converte para .PDF para arquivo gerado com extensao .REL (impressao via Server)
	//-- File2Printer(cStartPath+cFilePrint+".REL", "PDF")
//EndIf
oDamdfe:Preview()

Return(.T.)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ TMSR32Cab³ Autor ³Katia                  ³ Data ³07/05/13  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao responsavel por montar o cabecalho do relatorio      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   |                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function TMSR32Cab(aCab,lXML)
Local oFont07    	:= TFont():New("Times New Roman",07,07,,.F.,,,,.T.,.F.)	//Fonte Times New Roman 07
Local oFont08    	:= TFont():New("Times New Roman",08,08,,.F.,,,,.T.,.F.)	//Fonte Times New Roman 08
Local oFont08N   	:= TFont():New("Times New Roman",08,08,,.T.,,,,.T.,.F.)	//Fonte Times New Roman 08 Negrito
Local oFont12N   	:= TFont():New("Times New Roman",12,12,,.T.,,,,.T.,.F.)	//Fonte Times New Roman 12 Negrito
Local cStartPath	:= GetSrvProfString("Startpath","")
Local cTmsAntt		:= SuperGetMv( "MV_TMSANTT", .F., .F. )	//Numero do registro na ANTT com 14 dígitos
Local cLogoTp	   := cStartPath + "logoDAMDFE" + cEmpAnt + ".BMP" //Insira o caminho do Logo da empresa logada, na variavel cLogoTp.
Local cUF        := ""
Local cUFDesc    := ""
Local cCodEst    := ""
Local aUF        := {}
Local aAreaSM0   := {}
Local cRota      := ""
Local cEndereco  := ""

Local cSertms    := ''
Local cQryCab    := ''
Local cAliasDUD  := ''

If IsSrvUnix() .And. GetRemoteType() == 1
	cLogoTp := StrTran(cLogoTp,"/","\")
Endif

If  !File(cLogoTp)
	cLogoTp    := cStartPath + "DAMDFE.bmp"
EndIf

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
//³ BOX: Empresa                                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oDamdfe:Box(0036, 0000, 0140, 0400)
oDamdfe:SayBitmap(0038, 0005,cLogoTp,0300,0040 )
oDamdfe:Say(0098, 0005, 'CNPJ: ' + Iif(lXML,(Transform(oNfe:_MDFE:_INFMDFE:_EMIT:_CNPJ:TEXT,"@r 99.999.999/9999-99")), Transform(AllTrim(SM0->M0_CGC),"@r 99.999.999/9999-99") ), oFont08)
oDamdfe:Say(0098, 0110, 'IE: ' + Iif(lXML,oNfe:_MDFE:_INFMDFE:_EMIT:_IE:TEXT,AllTrim(SM0->M0_INSC)), oFont08)	//CNPJ e IE
oDamdfe:Say(0098, 0190, 'RNTRC: '   + AllTrim( cTmsAntt)		,oFont08)	//RNTRC da Empresa

oDamdfe:Say(0108, 0005, Iif(lXML,oNfe:_MDFE:_INFMDFE:_EMIT:_XNOME:TEXT,AllTrim(SM0->M0_NOMECOM))              ,oFont08) 	//Nome Comercial

If lXML
    cEndereco := oNfe:_MDFE:_INFMDFE:_EMIT:_ENDEREMIT:_XLGR:TEXT
    cEndereco += ", " + oNfe:_MDFE:_INFMDFE:_EMIT:_ENDEREMIT:_NRO:TEXT

    If Type( "oNfe:_MDFE:_INFMDFE:_EMIT:_ENDEREMIT:_XCPL:TEXT" ) != "U"
        cEndereco += ", " + oNfe:_MDFE:_INFMDFE:_EMIT:_ENDEREMIT:_XCPL:TEXT
    EndIf

Else
    cEndereco := AllTrim(SM0->M0_ENDCOB)
EndIf

oDamdfe:Say(0118, 0005, cEndereco, oFont08)	//Endereco


oDamdfe:Say(0128, 0005, Iif(lXML,oNfe:_MDFE:_INFMDFE:_EMIT:_ENDEREMIT:_XBAIRRO:TEXT,AllTrim(SM0->M0_BAIRCOB)) ,oFont08)	//Bairro
oDamdfe:Say(0138, 0005, Iif(lXML,oNfe:_MDFE:_INFMDFE:_EMIT:_ENDEREMIT:_UF:TEXT + ' - ' + oNfe:_MDFE:_INFMDFE:_EMIT:_ENDEREMIT:_XMUN:TEXT + '  -  ' + oNfe:_MDFE:_INFMDFE:_EMIT:_ENDEREMIT:_CEP:TEXT,;
                             AllTrim(SM0->M0_ESTCOB) + ' - ' + AllTrim(SM0->M0_CIDCOB) + '  CEP.:  ' + AllTrim(SM0->M0_CEPCOB)) ,oFont08)	//Cidade, UF, CEP

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BOX: DACTE                                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oDamdfe:Box(0036, 402, 0053, 0800)
oDamdfe:Say(0046, 430, "DAMDFE", oFont12N)
oDamdfe:Say(0042, 490, "Documento Auxiliar de Manifesto Eletrônico de",oFont08)
oDamdfe:Say(0050, 490, "Documentos Fiscais",oFont08)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BOX: Controle do Fisco                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oDamdfe:Box(0055, 402, 0140, 0800)
If	AllTrim(aCab[7])<>''
	oDamdfe:Code128C(100.6,425,aCab[5], 29)
//	oDamdfe:Code128C(150.4,425,aCab[7], 29)
Else
	oDamdfe:Code128C(100.6,425,aCab[5], 29)
EndIf
oDamdfe:Line(0110, 0402, 0110, 0800 )	//Linha Separadora
oDamdfe:Say( 0118, 0425,"CHAVE DE ACESSO",oFont07)
oDamdfe:Say( 0128, 0425, Transform(AllTrim(aCab[5]),"@r 99.9999.99.999.999/9999-99-99-999-999.999.999.999.999.999.9"), oFont08N)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³BOX: Modelo / Serie / Numero / Folha / Emis / UF                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oDamdfe:Box(0142, 000, 162, 0400)

oDamdfe:Say(0150, 0005, "Modelo" , oFont08N)	//Modelo
oDamdfe:Say(0158, 0005, "58",oFont08)

oDamdfe:Say(0150, 0045, "Serie"  , oFont08N)	//Serie
oDamdfe:Say(0158, 0050, cValtoChar( Val(aCab[2]) ), oFont08)

oDamdfe:Say(0150, 0090, "Número" , oFont08N)	//Numero
oDamdfe:Say(0158, 0095, cValtoChar( Val(aCab[1]) ), oFont08)

oDamdfe:Say(0150, 0145, "Folha"  , oFont08N)	//Folha
oDamdfe:Say(0158, 0149, AllTrim(Str(nFolhAtu)) + " / " + AllTrim(Str(nFolhas)), oFont08)
nFolhAtu ++

oDamdfe:Say(0150, 0199, "Emissão", oFont08N)//Emissao
oDamdfe:Say(0158, 0192, SubStr(AllTrim(aCab[3]), 7, 2) + '/'   +;
						SubStr(AllTrim(aCab[3]), 5, 2) + "/"   +;
						SubStr(AllTrim(aCab[3]), 1, 4) + " - " +;
						SubStr(AllTrim(aCab[4]), 1, 2) + ":"   +;
						SubStr(AllTrim(aCab[4]), 3, 2) + ":00", oFont08)

oDamdfe:Say(0150, 0284, "UF Carreg."  , oFont08N)	//Folha
If lXml
	
	If (ValType(oNFe:_MDFE:_INFMDFE:_IDE:_INFMUNCARREGA)  =='A')
		cCodEst:= Substr(oNfe:_MDFE:_INFMDFE:_IDE:_INFMUNCARREGA[1]:_CMUNCARREGA:TEXT,1,2)
	Else
		cCodEst:= Substr(oNfe:_MDFE:_INFMDFE:_IDE:_INFMUNCARREGA:_CMUNCARREGA:TEXT,1,2)
	EndIf

	If aScan(aUF,{|x| x[2] ==  AllTrim(cCodEst) }) != 0
		cUF := aUF[ aScan(aUF,{|x| x[2] == AllTrim(cCodEst) }), 1]
	EndIf
Else
    If AliasInDic("DL0")
        dbSelectArea("DL0")
        DL0->(dbSetOrder(2))
    EndIf

    If AliasInDic("DL0") .AND.  DL0->(MsSeek( FWxFilial("DL0")+ DTX->DTX_FILORI + DTX->DTX_VIAGEM ))
        DL0->(MsSeek( FWxFilial("DL0") + DTX->DTX_FILORI + DTX->DTX_VIAGEM + Replicate("Z",Len(DL0->DL0_PERCUR)),.T.))
        DL0->(DbSkip(-1))

        dbSelectArea("DL1")
        DL1->(dbSetOrder(2))
        If DL1->(dbSeek( FWxFilial("DL1") + DL0->DL0_PERCUR + DTX->DTX_FILMAN + DTX->DTX_MANIFE + DTX->DTX_SERMAN))
            cUF  :=   DL1->DL1_UFORIG
        EndIf
    Else
        cRota := Posicione("DTQ",2,xFilial("DTQ")+(cAliasMDF)->DTX_FILMAN+(cAliasMDF)->DTX_VIAGEM,"DTQ_ROTA")
        DA8->(DbSetOrder(1))
        If DA8->(MsSeek(xFilial("DA8")+cRota))
            DUY->(DbSetOrder(1))
            If 	!Empty(DA8->DA8_CDOMDF) .And. DUY->(MsSeek(xFilial("DUY")+DA8->DA8_CDOMDF))
                cUF := DUY->DUY_EST
            EndIf
        EndIf
        If Empty(cUF)
            aAreaSM0:= SM0->(GetArea())
            cUF:= Posicione("SM0",1,cEmpAnt+(cAliasMDF)->DTX_FILMAN,"M0_ESTENT")
            RestArea(aAreaSM0)
        EndIf
    EndIf
EndIf

oDamdfe:Say(0158, 0292,cUF, oFont08)

oDamdfe:Say(0150, 0345, "UF Descarreg."  , oFont08N)	//Folha

If lXml
	If (ValType(oNFe:_MDFE:_INFMDFE:_INFDOC:_INFMUNDESCARGA)  =='A')
		cCodEst:= Substr(oNfe:_MDFE:_INFMDFE:_INFDOC:_INFMUNDESCARGA[1]:_CMUNDESCARGA:TEXT,1,2)
	Else
		cCodEst:= Substr(oNfe:_MDFE:_INFMDFE:_INFDOC:_INFMUNDESCARGA:_CMUNDESCARGA:TEXT,1,2)
	EndIf

	If aScan(aUF,{|x| x[2] ==  AllTrim(cCodEst) }) != 0
		cUFDesc := aUF[ aScan(aUF,{|x| x[2] == AllTrim(cCodEst) }), 1]
	EndIf
Else

    // Verifica na tabela de Percurso.
    If AliasInDic("DL0")
		dbSelectArea("DL0")
		DL0->(dbSetOrder(2))
	EndIf
    If AliasInDic("DL0") .AND.  DL0->(MsSeek( FWxFilial("DL0")+ (cAliasMDF)->DTX_FILORI + (cAliasMDF)->DTX_VIAGEM ))
        DL0->(MsSeek( FWxFilial("DL0") + (cAliasMDF)->DTX_FILORI + (cAliasMDF)->DTX_VIAGEM + Replicate("Z",Len(DL0->DL0_PERCUR)),.T.))
        DL0->(DbSkip(-1))

        dbSelectArea("DL1")
        DL1->(dbSetOrder(2))
        If DL1->(dbSeek( FWxFilial("DL1") + DL0->DL0_PERCUR + (cAliasMDF)->DTX_FILMAN + (cAliasMDF)->DTX_MANIFE + (cAliasMDF)->DTX_SERMAN))
            cUFDesc    := DL1->DL1_UF
            lPerc := .T.
        EndIf
    Else
        // Verifica se é viagem de Entrega
    	cSertms  := Posicione("DTQ",2,xFilial("DTQ")+(cAliasMDF)->DTX_FILORI+(cAliasMDF)->DTX_VIAGEM,"DTQ_SERTMS")
        If cSertms = '3' .Or. (cSertms = '2' .And. (cAliasMDF)->DTX_FILDCA = cFilAnt) .Or. __lPyme

            // Busca ultimo doc sequenciado do manifesto posicionado
            // Para este tratamento é necessario que o manifesto tenha sido gerado por ESTADO.
            cAliasDUD := GetNextAlias()
            cQryCab += " SELECT Max(DUD_SEQUEN) MAX_SEQUEN, DUD_CDRCAL "
            cQryCab += "   FROM " + RetSQLName("DUD") + " DUD "
            cQryCab += "  WHERE DUD.DUD_FILIAL  = '"+xFilial("DUD")+"'"
            cQryCab += "	 AND DUD.DUD_FILORI  = '"+(cAliasMDF)->DTX_FILORI+"'"
            If __lPyme
                cQryCab += " AND DUD.DUD_NUMROM  = '" + (cAliasMDF)->DTX_NUMROM + "'"
            EndIf
            cQryCab += "	 AND DUD.DUD_FILMAN  = '" + (cAliasMDF)->DTX_FILMAN + "'"
            cQryCab += "	 AND DUD.DUD_MANIFE  = '" + (cAliasMDF)->DTX_MANIFE + "'"
            cQryCab += "	 AND DUD.D_E_L_E_T_  = ' '"
            cQryCab += "  GROUP BY DUD_CDRCAL"

            cQryCab := ChangeQuery(cQryCab)
            dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryCab),cAliasDUD)

            If !(cAliasDUD)->(Eof())
                // Em viagem de Entrega a UF Fim vem da regiao de Calculo
                cUFDesc   := Posicione("DUY",1, xFilial('DUY')+(cAliasDUD)->DUD_CDRCAL ,"DUY_EST")
            EndIf
            (cAliasDUD)->(dbCloseArea())
        EndIf
    EndIf
	If Empty(cUFDesc)
		aAreaSM0:= SM0->(GetArea())
		cUFDesc:= Posicione("SM0",1,cEmpAnt+(cAliasMDF)->DTX_FILDCA,"M0_ESTENT")
		RestArea(aAreaSM0)
	EndIf
EndIf

oDamdfe:Say(0158, 0360, cUFDesc, oFont08)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³BOX: PROTOCOLO                                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oDamdfe:Box(0142, 0402, 162, 0800)
oDamdfe:Say(0150, 0425, "PROTOCOLO DE AUTORIZACAO DE USO"  , oFont08N)
If Empty(aCab[7])  //Chave Contingencia
	oDamdfe:Say(0158, 0425,aCab[6], oFont08)
	if lXml
		oDamdfe:Say(0158, 0495,cValToChar(aCab[8]), oFont08)
		oDamdfe:Say(0158, 0535,SubStr(cValToChar(aCab[9]),1,8), oFont08)
	Else
		oDamdfe:Say(0158, 0495, SubStr(AllTrim(aCab[8]), 7, 2) + '/'   +;
                               SubStr(AllTrim(aCab[8]), 5, 2) + "/"   +;
                               SubStr(AllTrim(aCab[8]), 1, 4) + "   " +;
                               SubStr(AllTrim(aCab[9]), 1, 2) + ":"   +;
                               SubStr(AllTrim(aCab[9]), 3, 2), oFont08)
	EndIF
Else
	oDamdfe:Say(0158, 0425,'Impressão em contingência. Obrigatória a autorização em 24 horas após esta impressão.', oFont08)
   if lXml
   		oDamdfe:Say(0158, 0700, "(" + AllTrim(Dtoc(aCab[8])) + ' '   +;
										  SubStr(AllTrim(aCab[9]), 1, 5) + ")", oFont08)
   else
		oDamdfe:Say(0158, 0700, "(" + SubStr(AllTrim(aCab[8]), 7, 2) + '/'   +;
										  SubStr(AllTrim(aCab[8]), 5, 2) + "/"   +;
										  SubStr(AllTrim(aCab[8]), 1, 4) + " - " +;
										  SubStr(AllTrim(aCab[9]), 1, 2) + ":"   +;
										  SubStr(AllTrim(aCab[9]), 3, 2) + ")", oFont08)
	EndIF

EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RTMSR32   ³ Autor ³Katia               ³ Data ³07/05/13     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function DataSource( cSource )
Local cNewArea	:= GetNextAlias()
Local cQuery	:= ""

cQuery := GetSQL( cSource )
DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cNewArea, .F., .T.)

Return ( cNewArea )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RTMSR32   ³ Autor ³Katia               ³ Data ³07/05/13     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³  Cria DACTE sem utilizar o XML, utilizando tabela.         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GetSQL( cSource )
Local cQuery := ""
Local lDTX_SERMAN := DTX->(FieldPos("DTX_SERMAN")) > 0
Local lTercRbq    := DTR->(ColumnPos("DTR_CODRB3")) > 0

If	cSource == 'DTX'
	cQuery += "    SELECT DTX_FILMAN, DTX_MANIFE, DTX_FILORI, DTX_VIAGEM, DTX_DATMAN, DTX_HORMAN, DTX_QTDDOC, DTX_PESO, " +CRLF
	cQuery += "           DTX_QTDCTE, DTX_PRIMDF, DTX_CHVMDF, DTX_CTGMDF, DTX_DATIMP, DTX_HORIMP, DTX_AMBIEN, DTX_FIMP, DTX_FILDCA, " +CRLF
	If __lPyme
		If lDTX_SERMAN
			cQuery += "  DYB_CODVEI, DYB_CODRB1 , DYB_CODRB2 ,  DTX_SERMAN " + CRLF
			If lTercRbq
				cQuery += ",DYB_CODRB3 " + CRLF 
			EndIf 
		EndIf
	Else
		If lDTX_SERMAN
			cQuery += "    DTX_SERMAN, " + CRLF
		EndIf

		cQuery += "    DTR_CODVEI, DTR_CODRB1, DTR_CODRB2 " + CRLF

		If lTercRbq
			cQuery += ",DTR_CODRB3 " + CRLF 
		EndIf 
	EndIf

	If __lPyme
		cQuery += "   FROM " + RetSqlName('DTX') + " DTX " + CRLF
		cQuery += "        INNER JOIN " + RetSqlName('DYB') + " DYB ON(DYB_FILIAL = '" + xFilial('DYB') + "' AND DYB_NUMROM = DTX_NUMROM AND DTX.D_E_L_E_T_ <>'*' AND DYB.D_E_L_E_T_ <>'*' ) " + CRLF
	Else
		cQuery += "   FROM " + RetSqlName('DTX') + " DTX " + CRLF
		cQuery += "        INNER JOIN " + RetSqlName('DTR') + " DTR ON(DTR_FILORI = DTX_FILORI AND DTR_VIAGEM = DTX_VIAGEM AND DTR_CODVEI = DTX_CODVEI AND DTX.D_E_L_E_T_='' ) " + CRLF
	EndIf

	cQuery += "  WHERE DTX_FILIAL = '" + xFilial('DTX') + "'" + CRLF
	If __lPyme
		cQuery += "    AND DTX_MANIFE  = '" + MV_PAR01 + "'" + CRLF
		If lDTX_SERMAN .And. Alltrim(MV_PAR02) <> '0'
			cQuery += "    AND DTX_SERMAN     = '" + MV_PAR02 + "'" + CRLF
		EndIF
		cQuery += "    AND DYB_NUMROM  = '" + MV_PAR03 + "'" + CRLF
	Else
		cQuery += "    AND DTX_FILORI = '" + MV_PAR01 + "'" + CRLF
		cQuery += "    AND DTX_VIAGEM >= '" + MV_PAR02 + "'" + CRLF
		cQuery += "    AND DTX_VIAGEM <= '" + MV_PAR03 + "'" + CRLF
		cQuery += "    AND DTX_FILMAN >= '" + MV_PAR04 + "'" + CRLF
		cQuery += "    AND DTX_FILMAN <= '" + MV_PAR05 + "'" + CRLF
		cQuery += "    AND DTX_MANIFE >= '" + MV_PAR06 + "'" + CRLF
		cQuery += "    AND DTX_MANIFE <= '" + MV_PAR07 + "'" + CRLF
		If lDTX_SERMAN .And. Alltrim(MV_PAR08) <> '0'
			cQuery += "    AND DTX_SERMAN    >= '" + MV_PAR08 + "'" + CRLF
			cQuery += "    AND DTX_SERMAN    <= '" + MV_PAR09 + "'" + CRLF
		EndIF
		cQuery += "  AND DTR_FILIAL = '" + xFilial('DTR') + "'" + CRLF
	EndIf
	cQuery += "    AND (DTX_IDIMDF  = '100' OR (DTX_CTGMDF  <> ' ' AND SUBSTRING(DTX_RTIMDF,1,3) = '004'))" + CRLF
	cQuery += "    AND DTX.D_E_L_E_T_  = ' ' " + CRLF
	If lDTX_SERMAN
		cQuery += "  ORDER BY DTX.DTX_FILIAL, DTX_FILORI, DTX_VIAGEM, DTX_FILMAN, DTX_MANIFE, DTX_SERMAN " + CRLF
	Else
		cQuery += "  ORDER BY DTX.DTX_FILIAL, DTX_FILORI, DTX_VIAGEM, DTX_FILMAN, DTX_MANIFE " + CRLF
	EndIf

ElseIf cSource == 'DA3'

	cQuery += " SELECT DA3_COD, DA3_PLACA, DA3_RENAVA, DA3_TARA, DA3_CAPACM, DA3_FROVEI, " + CRLF
	cQuery += "   DA3_ESTPLA, DA3_CODFOR, DA3_LOJFOR, DUT_DESCRI,DUT_TIPROD, DUT_TIPCAR, " + CRLF
	cQuery += "   DA3_ALTINT, DA3_LARINT, DA3_COMINT, " + CRLF
	cQuery += "   A2_CGC, A2_NOME, A2_INSCR, A2_EST, A2_TIPO, A2_RNTRC " + CRLF
	cQuery += " FROM " + RetSqlName("DA3") + " DA3 " + CRLF
	cQuery += "   INNER JOIN " + RetSqlName("DUT") + " DUT " + CRLF
	cQuery += "   ON DUT.DUT_TIPVEI = DA3.DA3_TIPVEI " + CRLF
	cQuery += "   AND DUT.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "   INNER JOIN " + RetSqlName("SA2") + " SA2 ON " + CRLF
	cQuery += "   SA2.A2_COD = DA3.DA3_CODFOR AND " + CRLF
	cQuery += "   SA2.A2_LOJA   = DA3.DA3_LOJFOR AND " + CRLF
	cQuery += "   SA2.D_E_L_E_T_= '' " + CRLF
	cQuery += " WHERE DA3.DA3_FILIAL = '"+xFilial("DA3")+"'" + CRLF
	cQuery += "   AND DA3.DA3_COD    = '"+cCodVei+"'" + CRLF
	cQuery += "   AND DA3.D_E_L_E_T_ = ' '" + CRLF
	cQuery += "   AND DUT.DUT_FILIAL = '"+xFilial('DUT')+"'" + CRLF
	cQuery += "   AND SA2.A2_FILIAL  = '"+xFilial('SA2')+"'" + CRLF

EndIf

cQuery := ChangeQuery( cQuery )

Return ( cQuery )

static function UsaColaboracao(cModelo)
Local lUsa := .F.

If FindFunction("ColUsaColab")
	lUsa := ColUsaColab(cModelo)
endif
return (lUsa)
