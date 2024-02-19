#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"



/*/{Protheus.doc} GTPDANDE
//TODO Descrição auto-gerada.
@author osmar.junior
@since 27/11/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function GTPDANDE()

//--Variáveis do layout de impressão
Local aCab				:= {}
Local ofont12N			:= TFont():New("ARIAL",12,12,,.T.,,,,.T.,.F.)
Local oFont13			:= TFont():New("ARIAL",13,13,,.T.,,,,.T.,.F.)
Local oFont13N			:= TFont():New("ARIAL",13,13,,.T.,,,,.T.,.F.)
Local oFont10			:= TFont():New("ARIAL",10,10,,.F.,,,,.T.,.F.)
Local oFont10N			:= TFont():New("ARIAL",10,10,,.T.,,,,.T.,.F.)
Local oFont11			:= TFont():New("ARIAL",11,11,,.F.,,,,.T.,.F.)
Local oFont14N			:= TFont():New("ARIAL",14,14,,.T.,,,,.T.,.F.)
Local cPerg				:= 'GTPMDFE'
Local nCont				:= 0
Local lSeqDes			:= .F.
Local cAmbiente			:= ""
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
Local cModelo			:= "58"
Local nLinha			:= 0
Local nCount			:= 0
Local cFilePrint		:= ""
Local nQCTE				:= 0
Local cHoraBase     	:= ""
Local cRNTRC			:= ""
Local cAliasDA3			:= ""
Local nContChv			:= 0
Local nLinCTe			:= 0
Local nColTipo			:= 0
Local nColChave   		:= 0
Local cChaveCTe			:= ""
Local lXmlCont			:= .F. //--Impressao em contingência
Local nLinReb			:= 0
Local lImp				:= .F.
Local oBrush1			:= Nil
Local nPosSyCtge		:= 0 //Indica a coordenada vertical em pixels ou caracteres quando a impressão for por contingência, já que deixaremos a observação mais a baixo.
Local cError     		:= ""
Local oWS
Local cURL
Local nQtdCTEMun := 0

//--Variáveis de controle

Local cPlacaVeic 		:= '' 	//--Placa do Cavalo
Local cPlacaRb1			:= ''	//--Placa do Reboque1
Local cPlacaRb2			:= ''	//--Placa do Reboque2
Local cPlacaRb3			:= ''	//--Placa do Reboque3

//-- Variaveis Private
Private cAliasMDF		:= GetNextAlias()
Private oDamdfe
Private nFolhas			:= 0
Private nFolhAtu		:= 1
Private PixelX			:= nil
Private PixelY			:= nil
Private nMM		   		:= 0
Private lXml			:= .T.
Private oNfe

//Verifica se o arquivo sera gerado em Remote Linux
cStartPath := GetTempPath(.T.)

	cIdEnt := getCfgEntidade(@cError)
	If !Empty(cIdEnt)
		cURL := PadR(GetNewPar("MV_SPEDURL","http://"),250)
		oWS :=  WsSpedCfgNFe():New()
		oWS:cUSERTOKEN      := "TOTVS"
		oWS:cID_ENT         := cIdEnt
		oWS:nAmbienteMDFE   := 0 
		oWS:cVersaoMDFE     := "0.00"
		oWS:nModalidadeMDFE := 0
		oWS:cVERMDFELAYOUT  := "0.00"
		oWS:cVERMDFELAYEVEN := "0.00"
		oWS:nSEQLOTEMDFE    := 0
		oWS:cHORAVERAOMDFE  := '0'
		oWS:cHORARIOMDFE    := '0'
		oWS:_URL            := AllTrim(cURL)+"/SPEDCFGNFe.apw"
		oWS:cModelo         := '58'
		oWS:CFGMDFE()
				
		cVersMdfe := oWS:OWSCFGMDFERESULT:CVERSAOMDFE
		cAmbiente  := oWS:OWSCFGMDFERESULT:CAMBIENTEMDFE
	EndIf

If MSGYESNO('Gostaria de imprimir somente o posicionado ('+GI9->GI9_SERIE+' - '+GI9->GI9_NUMERO+') ?')

	Pergunte(cPerg,.F.)	

	mv_par01 := GI9->GI9_EMISSA
	mv_par02 := GI9->GI9_EMISSA 
	mv_par03 := GI9->GI9_SERIE 		
	mv_par04 := GI9->GI9_SERIE
	mv_par05 := GI9->GI9_NUMERO
	mv_par06 := GI9->GI9_NUMERO	
		
	
ElseIf !Pergunte(cPerg,.T.) 

 	Return()
 	
EndIf

If	!TMSSpedNFe(@cIdEnt,@cModalidade,,.F.,cModelo)
	Return()
EndIf


// Cria Arquivo de Trabalho - Documentos de Transporte
// Cria Arquivo de Trabalho - Documentos de Transporte
cAliasMDF := DataSource( 'GI9' )

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
	//Se for contingencia
	If (cAliasMDF)->GI9_TPEMIS == '2'
		lXmlCont := .T.
		nPosSyCtge := 075	
		nPosIniCtg := 045
	Else
		lXmlCont := .F.
		nPosSyCtge := 0	
		nPosIniCtg := 0

	EndIf
	//-- Buscar XML do WebService
	If lXml
		aNotas := {}
		aadd(aNotas,{})
		aAdd(Atail(aNotas),.F.)

		aadd(Atail(aNotas),"")
		aAdd(Atail(aNotas),"")
		aAdd(Atail(aNotas),(cAliasMDF)->GI9_SERIE)	//'58'+	
		aAdd(Atail(aNotas),(cAliasMDF)->GI9_NUMERO) //Documento
		aadd(Atail(aNotas),"")
		aadd(Atail(aNotas),"") 

		nX   := 1
		aXml := {}
	
		aXml := TMSGetXML(cIdEnt,aNotas,@cModalidade,cModelo)
	
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
		AllTrim((cAliasMDF)->GI9_NUMERO),;
		AllTrim(oNfe:_MDFE:_INFMDFE:_IDE:_SERIE:TEXT),;
		AllTrim(STRTRAN( SUBSTR( oNfe:_MDFE:_INFMDFE:_IDE:_dhEmi:TEXT, 1, AT('T', oNfe:_MDFE:_INFMDFE:_IDE:_dhEmi:TEXT) - 1) , '-', '')),;
		AllTrim(STRTRAN( SUBSTR( oNfe:_MDFE:_INFMDFE:_IDE:_dhEmi:TEXT, AT('T', oNfe:_MDFE:_INFMDFE:_IDE:_dhEmi:TEXT) + 1, 5) , ':', '')),;
		AllTrim(STRTRAN(UPPER(oNFE:_MDFE:_INFMDFE:_ID:TEXT),'MDFE','')),;
		AllTrim(aXML[nX][1]),;
		AllTrim((cAliasMDF)->GI9_CHVMDF),;
		aXML[nX][7],;
		aXML[nX][6] })
	Else
		aAdd(aCab, {;
		AllTrim((cAliasMDF)->GI9_NUMERO),;
		(cAliasMDF)->GI9_SERIE,;
		AllTrim((cAliasMDF)->GI9_EMISSA),;
		AllTrim((cAliasMDF)->GI9_HORAEM),;
		AllTrim((cAliasMDF)->GI9_CHVMDF),;
		AllTrim((cAliasMDF)->GI9_PROTOC),;
		AllTrim((cAliasMDF)->GI9_CHVMDF),;
		(cAliasMDF)->GI9_EMISSA,;
		(cAliasMDF)->GI9_HORAEM })
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Funcao responsavel por montar o cabecalho do relatorio                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nFolhAtu := 1
	lSeqDes  :=.F.
	TMSR34Cab(aCab[nCont],lXml, cAmbiente, nPosIniCtg,lXmlCont)

	oDamdfe:Say(0208-nPosIniCtg, 0005, "Modelo Rodoviário de Carga", ofont14N)
	
	If lXml
		If Type("oNfe:_MDFE:_INFMDFE:_TOT:_QCTE") <> "U"
			nQCTE:= oNfe:_MDFE:_INFMDFE:_TOT:_QCTE:TEXT
		EndIf
	Else
		nQCTE:= 1//BUSCAR QUANTIDADE //OSMAR
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³ BOX: QTDE CTE ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	oDamdfe:Box(0218-nPosIniCtg, 0005, 0258-nPosIniCtg, 0070)
	oDamdfe:Say(0233-nPosIniCtg, 0007, "Qtd. CT-e", ofont13)
	oDamdfe:Say(0243-nPosIniCtg, 0007, cValtoChar( nQCTE ), ofont13N)	

	oDamdfe:Box(0218-nPosIniCtg, 0078, 0258-nPosIniCtg, 0143)
	oDamdfe:Say(0233-nPosIniCtg, 0080, "Qtd. NF-e", ofont13)
	oDamdfe:Say(0243-nPosIniCtg, 0080, '0', ofont13N)	

	If lXML
		nQCarga:= oNfe:_MDFE:_INFMDFE:_TOT:_QCARGA:TEXT
	Else
		nQCarga:= (cAliasMDF)->GI9_PCARGA
	EndIf
	oDamdfe:Box(0218-nPosIniCtg, 0151, 0258-nPosIniCtg, 0300)
	oDamdfe:Say(0233-nPosIniCtg, 0153, "Peso Total (Kg)", ofont13)
	oDamdfe:Say(0243-nPosIniCtg, 0153, cValtoChar(nQCarga), oFont10)

	oDamdfe:Say(0330-nPosIniCtg, 0005, "Veículo"	, ofont14N)
	oDamdfe:Say(0345-nPosIniCtg, 0005, "Placa"		, ofont11)
	oDamdfe:Say(0345-nPosIniCtg, 0085, "RNTRC"		, ofont11)
	
	oBrush1 := TBrush():New( , CLR_GRAY)
	
	oDamdfe:FillRect({0350-nPosIniCtg,0005,0355-nPosIniCtg,0300},oBrush1)
		
	oDamdfe:Say(0330-nPosIniCtg, 0332, "Condutor"	, ofont14N)
	oDamdfe:Say(0345-nPosIniCtg, 0332, "CPF"		, ofont11)
	oDamdfe:Say(0345-nPosIniCtg, 0440, "Nome"		, ofont11)
	
	oDamdfe:FillRect({0350-nPosIniCtg,0332,0355-nPosIniCtg,800},oBrush1)

	//-- Dados da Placa
	If lXml
		oDamdfe:Say(0360-nPosIniCtg, 0005, AllTrim(oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICTRACAO:_PLACA:TEXT), oFont13N)
		If Type("oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICREBOQUE") <> "U"
			If Type( "oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICREBOQUE" ) <> "A"
				oDamdfe:Say(0370-nPosIniCtg, 0005, AllTrim(oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICREBOQUE:_PLACA:TEXT), ofont13N)
			Else
				nLinReb	:= 370-nPosIniCtg
				For nCount := 1 To Len (oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICREBOQUE)
					oDamdfe:Say(nLinReb, 0005, AllTrim(oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICREBOQUE[nCount]:_PLACA:TEXT), ofont13N)
					nLinReb += 10
				Next nCount
			EndIf
		EndIf
	Else
		//--- Veiculo
			
		cCodVei := (cAliasMDF)->GI9_VEICUL
		cAliasDA3 := DataSource( 'DA3' )
		cRNTRC  := AllTrim((cAliasDA3)->A2_RNTRC)
		cPlacaVeic := AllTrim((cAliasDA3)->DA3_PLACA)
		(cAliasDA3)->(dbCloseArea())
		
		oDamdfe:Say(0360-nPosIniCtg, 0005, cPlacaVeic, ofont13N)
		oDamdfe:Say(0370-nPosIniCtg, 0005, cPlacaRb1 , ofont13N)
		oDamdfe:Say(0380-nPosIniCtg, 0005, cPlacaRb2 , ofont13N)
		oDamdfe:Say(0390-nPosIniCtg, 0005, cPlacaRb3 , ofont13N)

	EndIf

	//--- Dados do RNTRC

	If lXml
		If Type('oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICTRACAO:_PROP:_RNTRC') <> 'U'
			oDamdfe:Say(0360-nPosIniCtg, 0085, AllTrim(oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICTRACAO:_PROP:_RNTRC:TEXT), oFont13N)
		EndIf
		If Type("oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICREBOQUE:_PROP:_RNTRC") <> "U"
			If Type( "oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICREBOQUE" ) <> "A"
				oDamdfe:Say(0370-nPosIniCtg, 0085, AllTrim(oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICREBOQUE:_PROP:_RNTRC:TEXT), oFont13N)
			Else
				nLinReb	:= 0370-nPosIniCtg
				For nCount := 1 To Len (oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICREBOQUE)
					oDamdfe:Say(nLinReb, 0085, AllTrim(oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICREBOQUE[nCount]:_PROP:_RNTRC:TEXT), ofont13N)
					nLinReb += 10
				Next nCount
			EndIf
		EndIf

		If Type('oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICTRACAO:_PROP:_RNTRC') = 'U'
			If Type('oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_infANTT:_RNTRC') <> 'U'
				oDamdfe:Say(0360-nPosIniCtg, 0085, AllTrim(oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_infANTT:_RNTRC:TEXT), oFont13N)
			EndIf
		EndIf

	Else
		oDamdfe:Say(0360-nPosIniCtg, 0085, AllTrim(cRNTRC), oFont13N)
	EndIf
	

	//--Dados do Condutor
	If lXML
		If Type( "oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICTRACAO:_CONDUTOR" ) <> "A"
			oDamdfe:Say(0360-nPosIniCtg, 0332, Transform(AllTrim(oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICTRACAO:_CONDUTOR:_CPF:TEXT),"@r 999.999.999-99"), oFont13N)
			oDamdfe:Say(0360-nPosIniCtg, 0440, AllTrim(oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICTRACAO:_CONDUTOR:_XNOME:TEXT), oFont13N)
		Else
			nLinha:= 360-nPosIniCtg
			For nCount := 1 To Len( oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICTRACAO:_CONDUTOR )
				oDamdfe:Say(nLinha, 0332, Transform(AllTrim(oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICTRACAO:_CONDUTOR[nCount]:_CPF:TEXT),"@r 999.999.999-99"), oFont13N)
				oDamdfe:Say(nLinha, 0440, AllTrim(oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICTRACAO:_CONDUTOR[nCount]:_XNOME:TEXT), oFont13N)
				nLinha+= 10
			Next nCount
		EndIf	
	
	EndIf

	//--- Vale Pedagio
	oDamdfe:Say(0410-nPosIniCtg, 0005, "Vale Pedágio", ofont14N)

	oDamdfe:Say(0430-nPosIniCtg, 0005, "Responsável CNPJ", ofont12N)
	oDamdfe:Say(0430-nPosIniCtg, 0105, "Fornecedora CNPJ", ofont13N)
	oDamdfe:Say(0430-nPosIniCtg, 0205, "Nro Comprovante", ofont13N)
	oDamdfe:FillRect({0435-nPosIniCtg,0005,0438-nPosIniCtg,300},oBrush1)
	If lXML
		If Type('oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_INFANTT:_VALEPED:_DISP:_CNPJPG') <> 'U'
			oDamdfe:Say(0445-nPosIniCtg, 0005, oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_INFANTT:_VALEPED:_DISP:_CNPJPG:TEXT, oFont10)
		EndIf
		
		
		If Type('oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_INFANTT:_VALEPED:_DISP:_CNPJFORN') <> 'U'
			oDamdfe:Say(0445-nPosIniCtg, 0130, oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_INFANTT:_VALEPED:_DISP:_CNPJFORN:TEXT, oFont10)
		EndIf	
		
		
		If Type('oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_INFANTT:_VALEPED:_DISP:_NCOMPRA') <> 'U'
			oDamdfe:Say(0445-nPosIniCtg, 0230, oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_INFANTT:_VALEPED:_DISP:_NCOMPRA:TEXT, oFont10)
		EndIf				

	EndIf		

	//--- Observacoes  	
 	oDamdfe:Say(0490+nPosSyCtge, 0005, "Observações", ofont12N)
 	oDamdfe:FillRect({0525+nposSyCtge,0005,0528+nposSyCtge,800},oBrush1)
 	If (lXML .And. oNfe:_MDFE:_INFMDFE:_IDE:_TPAMB:TEXT == '2') .Or. (cAmbiente == 2)
  		oDamdfe:Say(0535+nposSyCtge, 0005, "MANIFESTO GERADO EM AMBIENTE DE HOMOLOGAÇÃO", oFont10)
	EndIf
	
	If Type("oNfe:_MDFE:_INFMDFE:_infAdic:_infAdFisco:TEXT") != "U"
		cObs := oNfe:_MDFE:_INFMDFE:_infAdic:_infAdFisco:TEXT
		oDamdfe:Say(0545+nposSyCtge, 0005,Substr(cObs,1,110), oFont10N)
		oDamdfe:Say(0555+nposSyCtge, 0005,Substr(cObs,111,110), oFont10N)
		oDamdfe:Say(0565+nposSyCtge, 0005,Substr(cObs,221,100), oFont10N)
	EndIf
	
	If lXmlCont
		//--- Somente apresenta esse box quando for contingencia	  	
		oDamdfe:Say(0480-nPosIniCtg, 0005, "Informações da Composição da Carga", ofont13N)
	  	oDamdfe:FillRect({0485-nPosIniCtg,0005,0488-nPosIniCtg,800},oBrush1)
		
		oDamdfe:Say(0500-nPosIniCtg, 0005, "Informações dos Documentos Fiscais vinculados ao Manifesto", ofont13N)
		oDamdfe:FillRect({0505-nPosIniCtg,0005,0506-nPosIniCtg,0350},oBrush1)
		
	  	oDamdfe:Say(0500-nPosIniCtg, 0355, "Identificação de Unidade de Transporte", ofont13N)	  	
	  	oDamdfe:FillRect({0505-nPosIniCtg,0355,0506-nPosIniCtg,0600},oBrush1)
	  	
	  	oDamdfe:Say(0500-nPosIniCtg, 0605, "Identificação de Unidade de Carga", ofont13N)
	  	oDamdfe:FillRect({0505-nPosIniCtg,0605,0506-nPosIniCtg,0800},oBrush1)
	  
	    //Tag INFCTE
		If (Type( "oNFe:_MDFE:_INFMDFE:_INFDOC:_INFMUNDESCARGA:_INFCTE") <> 'U')
			If (ValType(oNFe:_MDFE:_INFMDFE:_INFDOC:_INFMUNDESCARGA:_INFCTE)  =='A')
			   nLinCTe			:= 0515-nPosIniCtg
			   nColTipo			:= 0005
			   nColChave    	:= 0030
	           For nContChv 	:= 1 to len(oNFe:_MDFE:_INFMDFE:_INFDOC:_INFMUNDESCARGA:_INFCTE)
					cChaveCTe 	:= oNFe:_MDFE:_INFMDFE:_INFDOC:_INFMUNDESCARGA:_INFCTE[nContChv]:_CHCTE:TEXT
					oDamdfe:Say(nLinCTE, nColTipo , "CTe"    , ofont13)
					oDamdfe:Say(nLinCTE, nColChave, cChaveCTe, ofont13)
					nLinCTe += 10
					If nLinCTe		== 0615-nPosIniCtg
						nColTipo	:= 0250
						nColChave	:= 0280
					EndIf
			   Next
			Else
	            cChaveCTe := oNFe:_MDFE:_INFMDFE:_INFDOC:_INFMUNDESCARGA:_INFCTE:_CHCTE:TEXT
	            oDamdfe:Say(0515-nPosIniCtg, 0005, "CTe"    , ofont13)
	  	        oDamdfe:Say(0515-nPosIniCtg, 0030, cChaveCTe, ofont13)
			EndIf
		ElseIf (Type( "oNFe:_MDFE:_INFMDFE:_INFDOC:_INFMUNDESCARGA") <> 'U')
			If (ValType(oNFe:_MDFE:_INFMDFE:_INFDOC:_INFMUNDESCARGA)  =='A')
			   nLinCTe		:= 0565-nPosIniCtg//0515-nPosIniCtg
			   nColTipo		:= 0005
			   nColChave    	:= 0030
	           For nContChv 	:= 1 to len(oNFe:_MDFE:_INFMDFE:_INFDOC:_INFMUNDESCARGA)
					If ValType( oNFe:_MDFE:_INFMDFE:_INFDOC:_INFMUNDESCARGA[nContChv]:_INFCTE ) == "A"
					 	
					 	For nQtdCTEMun := 1 To Len(oNFe:_MDFE:_INFMDFE:_INFDOC:_INFMUNDESCARGA[nContChv]:_INFCTE )
					 		cChaveCTe 	:= oNFe:_MDFE:_INFMDFE:_INFDOC:_INFMUNDESCARGA[nContChv]:_INFCTE[nQtdCTEMun]:_CHCTE:TEXT
					 		oDamdfe:Say(nLinCTE-nPosIniCtg, nColTipo , "CTe"    , ofont13)
							oDamdfe:Say(nLinCTE-nPosIniCtg, nColChave, cChaveCTe, ofont13)
							nLinCTe += 10
							If nLinCTe		== 0615-nPosIniCtg
								nColTipo	:= 0250
								nColChave	:= 0280
							EndIf
						Next nQtdCTEMun
					Else
						cChaveCTe 	:= oNFe:_MDFE:_INFMDFE:_INFDOC:_INFMUNDESCARGA[nContChv]:_INFCTE:_CHCTE:TEXT
					
						oDamdfe:Say(nLinCTE-nPosIniCtg, nColTipo , "CTe"    , ofont13)
						oDamdfe:Say(nLinCTE-nPosIniCtg, nColChave, cChaveCTe, ofont13)
						nLinCTe += 10
						If nLinCTe		== 0615-nPosIniCtg
							nColTipo	:= 0250
							nColChave	:= 0280
						EndIf
					EndIf
			   Next
			Else
	            cChaveCTe := oNFe:_MDFE:_INFMDFE:_INFDOC:_INFMUNDESCARGA:_INFCTE:_CHCTE:TEXT
	            oDamdfe:Say(0515-nPosIniCtg, 0005, "CTe"    , ofont13)
	  	        oDamdfe:Say(0515-nPosIniCtg, 0030, cChaveCTe, ofont13)
			EndIf
		EndIf
		
		If Type("oNfe:_MDFE:_INFMDFE:_infAdic:_infAdFisco:TEXT") != "U"
		 	cObs := oNfe:_MDFE:_INFMDFE:_infAdic:_infAdFisco:TEXT
			oDamdfe:Say(0490+nPosSyCtge+10, 0005,Substr(cObs,1,110), oFont10N)//0535
			oDamdfe:Say(0490+nPosSyCtge+20, 0005,Substr(cObs,111,110), oFont10N)//0565
			oDamdfe:Say(0490+nPosSyCtge+30, 0005,Substr(cObs,221,100), oFont10N)//0575
		EndIf
	Else  	
		If Type("oNfe:_MDFE:_INFMDFE:_infAdic:_infAdFisco:TEXT") != "U"
			cObs := oNfe:_MDFE:_INFMDFE:_infAdic:_infAdFisco:TEXT
			oDamdfe:Say(0490+10, 0005,Substr(cObs,1,110), oFont10N)
			oDamdfe:Say(0490+20, 0005,Substr(cObs,111,110), oFont10N)
			oDamdfe:Say(0490+30, 0005,Substr(cObs,221,100), oFont10N)
		EndIf
	EndIf  

	oDamdfe:EndPage()

	(cAliasMDF)->(DbSkip())
EndDo

(cAliasMDF)->(dbCloseArea())

oDamdfe:Preview()

Return(.T.)



/*/{Protheus.doc} TMSR34Cab
//TODO Descrição auto-gerada.
@author osmar.junior
@since 27/11/2019
@version 1.0
@return ${return}, ${return_description}
@param aCab, array, descricao
@param lXML, logical, descricao
@param cAmbiente, characters, descricao
@param nPosIniCtg, numeric, descricao
@param lXmlCont, logical, descricao
@type function
/*/
Static Function TMSR34Cab(aCab,lXML, cAmbiente, nPosIniCtg,lXmlCont)
Local oFont10		:= TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)	//Fonte Arial 10
Local oFont10N		:= TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)	//Fonte Arial 10 Negrito
Local oFont11		:= TFont():New("Arial",11,11,,.F.,,,,.T.,.F.)	//Fonte Arial 11
Local oFont11N		:= TFont():New("Arial",11,11,,.T.,,,,.T.,.F.)	//Fonte Arial 11 Negrito
Local ofont13		:= TFont():New("Arial",13,13,,.F.,,,,.T.,.F.)
Local ofont13N		:= TFont():New("Arial",13,13,,.T.,,,,.T.,.F.)
Local oFont14N		:= TFont():New("ARIAL",14,14,,.T.,,,,.T.,.F.)
//Local oFont07    	:= TFont():New("Times New Roman",07,07,,.F.,,,,.T.,.F.)	//Fonte Times New Roman 07
Local cStartPath	:= GetSrvProfString("Startpath","")
Local cTmsAntt		:= SuperGetMv( "MV_TMSANTT", .F., .F. )	//Numero do registro na ANTT com 14 dígitos
Local cLogoTp	   	:= cStartPath + "logoDAMDFE" + cEmpAnt + ".BMP" //Insira o caminho do Logo da empresa logada, na variavel cLogoTp.
Local cUF        	:= ""
Local cUFDesc    	:= ""
Local cCodEst    	:= ""
Local aUF        	:= {}
Local cEndereco  	:= ""
Local cQrCode		:= ""
Local oBrushBlck	:= Nil
Local nPosSign      := 0

Default aCab 		:= {}
Default lXml		:= .F.
Default cAmbiente	:= ''
Default nPosIniCtg	:= 0
Default lXmlCont    := .F.

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
//oDamdfe:Box(0036, 0000, 0140, 0400)
oDamdfe:SayBitmap(0090-nPosIniCtg, 0005,cLogoTp,0150-nPosIniCtg,0040 )
oDamdfe:Say(0090-nPosIniCtg, 0190, Iif(lXML,oNfe:_MDFE:_INFMDFE:_EMIT:_XNOME:TEXT,AllTrim(SM0->M0_NOMECOM))    , oFont10N)

If lXML
    cEndereco := oNfe:_MDFE:_INFMDFE:_EMIT:_ENDEREMIT:_XLGR:TEXT
    cEndereco += ", " + oNfe:_MDFE:_INFMDFE:_EMIT:_ENDEREMIT:_NRO:TEXT

    If Type( "oNfe:_MDFE:_INFMDFE:_EMIT:_ENDEREMIT:_XCPL:TEXT" ) != "U"
        cEndereco += ", " + oNfe:_MDFE:_INFMDFE:_EMIT:_ENDEREMIT:_XCPL:TEXT
    EndIf

Else
    cEndereco := AllTrim(SM0->M0_ENDCOB)
EndIf

oDamdfe:Say(0100-nPosIniCtg, 0190, cEndereco, ofont10)	//Endereco
oDamdfe:Say(0110-nPosIniCtg, 0190, Iif(lXML, + oNfe:_MDFE:_INFMDFE:_EMIT:_ENDEREMIT:_XMUN:TEXT + '  -  ' + oNfe:_MDFE:_INFMDFE:_EMIT:_ENDEREMIT:_UF:TEXT + ' - ' + oNfe:_MDFE:_INFMDFE:_EMIT:_ENDEREMIT:_CEP:TEXT,;
                            + AllTrim(SM0->M0_CIDCOB) + ' - ' + AllTrim(SM0->M0_ESTCOB) + ' - ' + '  CEP.:  ' + AllTrim(SM0->M0_CEPCOB)) ,ofont10)	//Cidade, UF, CEP

oDamdfe:Say(0120-nPosIniCtg, 0190, 'CNPJ: ', ofont10N)
oDamdfe:Say(0120-nPosIniCtg, 0220, Iif(lXML,(Transform(oNfe:_MDFE:_INFMDFE:_EMIT:_CNPJ:TEXT,"@r 99.999.999/9999-99")), Transform(AllTrim(SM0->M0_CGC),"@r 99.999.999/9999-99") ),oFont10) 
oDamdfe:Say(0120-nPosIniCtg, 0298, 'IE: ', ofont10N)
oDamdfe:Say(0120-nPosIniCtg, 0310, Iif(lXML,oNfe:_MDFE:_INFMDFE:_EMIT:_IE:TEXT,AllTrim(SM0->M0_INSC)), ofont10)
oDamdfe:Say(0120-nPosIniCtg, 0365, 'RNTRC: ' , ofont10N) 
oDamdfe:Say(0120-nPosIniCtg, 0400, AllTrim( cTmsAntt),ofont10)	//RNTRC da Empresa


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BOX: DACTE                                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oDamdfe:Say(0140-nPosIniCtg, 0005, "DAMDFE - ", oFont14N)
oDamdfe:Say(0140-nPosIniCtg, 0065, "Documento Auxiliar de Manifesto Eletrônico de Documentos Fiscais",oFont13)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³BOX: Modelo / Serie / Numero ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

oDamdfe:Box(0150-nPosIniCtg, 0005, 0185-nPosIniCtg, 0140)
oDamdfe:Say(0165-nPosIniCtg, 0007, "Modelo" , oFont13)	//Modelo
oDamdfe:Say(0175-nPosIniCtg, 0007, "58",ofont13)

oDamdfe:Say(0165-nPosIniCtg, 0047, "Serie"  , oFont13)	//Serie
oDamdfe:Say(0175-nPosIniCtg, 0047, cValtoChar( Val(aCab[2]) ), ofont13)

oDamdfe:Say(0165-nPosIniCtg, 0090, "Número" , ofont13)	//Numero
oDamdfe:Say(0175-nPosIniCtg, 0090, cValtoChar( Val(aCab[1]) ), ofont13)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³BOX: FL ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

oDamdfe:Box(0150-nPosIniCtg, 0148, 0185-nPosIniCtg, 0180)                        
oDamdfe:Say(0165-nPosIniCtg, 0150, "FL"  , ofont13N)	//Folha
oDamdfe:Say(0175-nPosIniCtg, 0150, AllTrim(Str(nFolhAtu)) + "/" + AllTrim(Str(nFolhas)), ofont13N)
nFolhAtu ++

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³BOX: DATA E HORA DE EMISSÃO 	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

oDamdfe:Box(0150-nPosIniCtg, 0188, 0185-nPosIniCtg, 0308)     
oDamdfe:Say(0165-nPosIniCtg, 0190, "Data e Hora de Emissão", ofont13)//Emissao
oDamdfe:Say(0175-nPosIniCtg, 0190, SubStr(AllTrim(aCab[3]), 7, 2) + '/'   +;
						SubStr(AllTrim(aCab[3]), 5, 2) + "/"   +;
						SubStr(AllTrim(aCab[3]), 1, 4) + " - " +;
						SubStr(AllTrim(aCab[4]), 1, 2) + ":"   +;
						SubStr(AllTrim(aCab[4]), 3, 2) + ":00", ofont13N)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³QRCODE ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ	

If lXml
	If Type( 'oNFE:_MDFE:_INFMDFESUPL:_QRCODMDFE:TEXT' ) != 'U' .And. !Empty(oNFE:_MDFE:_INFMDFESUPL:_QRCODMDFE:TEXT  )
		If lXmlCont //Contingencia
			nPosSign:= At("&sign",oNFE:_MDFE:_INFMDFESUPL:_QRCODMDFE:TEXT)
		EndIf

		If nPosSign > 0 
			cQrCode := Substr(oNFE:_MDFE:_INFMDFESUPL:_QRCODMDFE:TEXT, 1, nPosSign - 1)
		Else
			cQrCode := oNFE:_MDFE:_INFMDFESUPL:_QRCODMDFE:TEXT  
		EndIf	
	EndIf	
Else
	cQrCode := 'http://dfe-portal.svrs.rs.gov.br/mdfe/QRCode?chMDFe='+aCab[5]+'&tpAmb=' + Substr(cAmbiente,1,1) 
EndIf		
oDamdfe:QRCODE(200-nPosIniCtg,550,cQrCode, 120)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BOX: Controle do Fisco                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oDamdfe:Say(0208-nPosIniCtg, 0332, "CONTROLE DO FISCO", ofont11)

oDamdfe:Code128C(0265-nPosIniCtg,0332,aCab[5], 60)

If lXml

	If (ValType(oNFe:_MDFE:_INFMDFE:_IDE:_INFMUNCARREGA)  =='A')
		cCodEst:= Substr(oNfe:_MDFE:_INFMDFE:_IDE:_INFMUNCARREGA[1]:_CMUNCARREGA:TEXT,1,2)
	Else
		cCodEst:= Substr(oNfe:_MDFE:_INFMDFE:_IDE:_INFMUNCARREGA:_CMUNCARREGA:TEXT,1,2)
	EndIf

	If aScan(aUF,{|x| x[2] ==  AllTrim(cCodEst) }) != 0
		cUF := aUF[ aScan(aUF,{|x| x[2] == AllTrim(cCodEst) }), 1]
	EndIf
 
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³BOX: UF CARREGAMENTO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ						
oDamdfe:Box(0150-nPosIniCtg, 0316, 0185-nPosIniCtg, 0370		)						
oDamdfe:Say(0165-nPosIniCtg, 0318, "UF Carreg." , ofont13	)
oDamdfe:Say(0175-nPosIniCtg, 0318, cUF , ofont13N	)

If lXml
	If (ValType(oNFe:_MDFE:_INFMDFE:_INFDOC:_INFMUNDESCARGA)  =='A')
		cCodEst:= Substr(oNfe:_MDFE:_INFMDFE:_INFDOC:_INFMUNDESCARGA[1]:_CMUNDESCARGA:TEXT,1,2)
	Else
		cCodEst:= Substr(oNfe:_MDFE:_INFMDFE:_INFDOC:_INFMUNDESCARGA:_CMUNDESCARGA:TEXT,1,2)
	EndIf

	If aScan(aUF,{|x| x[2] ==  AllTrim(cCodEst) }) != 0
		cUFDesc := aUF[ aScan(aUF,{|x| x[2] == AllTrim(cCodEst) }), 1]
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³BOX: UF DESCARREGAMENTO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
oDamdfe:Box(0150-nPosIniCtg, 0380, 0185-nPosIniCtg			, 0450		)							
oDamdfe:Say(0165-nPosIniCtg, 0382, "UF Descarreg." , ofont13	)
oDamdfe:Say(0175-nPosIniCtg, 0382, cUFDesc 		, ofont13N	)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³BOX: PROTOCOLO                                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oDamdfe:Say(0290-nPosIniCtg, 0005, "Protocolo de autorização"  , ofont11N)
If !lXmlCont  //Chave Contingencia
	oDamdfe:Say(0300-nPosIniCtg, 0005,aCab[6], ofont13)
	If lXml
		oDamdfe:Say(0300-nPosIniCtg, 0105,cValToChar(aCab[8]) + '-', ofont13)
		oDamdfe:Say(0300-nPosIniCtg, 0165,cValToChar(aCab[9]), ofont13)
	Else
		oDamdfe:Say(0300-nPosIniCtg, 0105, SubStr(AllTrim(aCab[8]), 7, 2) + '/'   +;
                               SubStr(AllTrim(aCab[8]), 5, 2) + "/"   +;
                               SubStr(AllTrim(aCab[8]), 1, 4) + "   " +;
                               SubStr(AllTrim(aCab[9]), 1, 2) + ":"   +;
                               SubStr(AllTrim(aCab[9]), 3, 2), ofont13)
	EndIf
Else
	oBrushBlck := TBrush():New( , CLR_BLACK)
	oDamdfe:FillRect({0292-nPosIniCtg,0005,0315-nPosIniCtg,0300},oBrushBlck)
	oDamdfe:Say(0300-nPosIniCtg, 0008,'Impressão em contingência. Obrigatória a autorização ', oFont13,,CLR_WHITE)
	oDamdfe:Say(0311-nPosIniCtg, 0008,'em 168 horas após esta impressão.', ofont13,,CLR_WHITE)
   	If lXml
   		oDamdfe:Say(0312-nPosIniCtg, 0175, "(" + AllTrim(Dtoc(aCab[8])) + ' '   +;
										  SubStr(AllTrim(aCab[9]), 1, 5) + ")", ofont13)
   	Else
		oDamdfe:Say(0312-nPosIniCtg, 0175, "(" + SubStr(AllTrim(aCab[8]), 7, 2) + '/'   +;
										  SubStr(AllTrim(aCab[8]), 5, 2) + "/"   +;
										  SubStr(AllTrim(aCab[8]), 1, 4) + " - " +;
										  SubStr(AllTrim(aCab[9]), 1, 2) + ":"   +;
										  SubStr(AllTrim(aCab[9]), 3, 2) + ")", ofont13)
	EndIf
EndIf

oDamdfe:Say( 0290-nPosIniCtg, 0332,"Chave de Acesso",oFont11N)
oDamdfe:Say( 0300-nPosIniCtg, 0332, Transform(AllTrim(aCab[5]),"@r 99.9999.99.999.999/9999-99-99-999-999.999.999.999.999.999.9"), oFont11)
oDamdfe:Say( 0310-nPosIniCtg, 0332, "Consulte em ", oFont11)
oDamdfe:Say( 0310-nPosIniCtg, 0382, "https://dfe-portal.sefazvirtual.rs.gov.br/MDFe/consulta ", oFont11N)


Return


/*/{Protheus.doc} DataSource
//TODO Descrição auto-gerada.
@author osmar.junior
@since 27/11/2019
@version 1.0
@return ${return}, ${return_description}
@param cSource, characters, descricao
@type function
/*/
Static Function DataSource( cSource )
Local cNewArea	:= GetNextAlias()
Local cQuery	:= ""

cQuery := GetSQL( cSource )
DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cNewArea, .F., .T.)

Return ( cNewArea )


/*/{Protheus.doc} GetSQL
//TODO Descrição auto-gerada.
@author osmar.junior
@since 27/11/2019
@version 1.0
@return ${return}, ${return_description}
@param cSource, characters, descricao
@type function
/*/
Static Function GetSQL( cSource )
Local cQuery := ""

If	cSource == 'GI9'
	cQuery += "    SELECT GI9_FILIAL   ,GI9_CODIGO   ,GI9_TIPOEM   ,GI9_SERIE    ,GI9_NUMERO   ,GI9_EMISSA   ,GI9_HORAEM   ,GI9_DTCRIA   ,GI9_USUARI   , " +CRLF
	cQuery += "           GI9_UFINI    ,GI9_UFFIM    ,GI9_MUNCAR   ,GI9_OBSERV   ,GI9_VEICUL   ,GI9_PLACA    ,GI9_TARAVE   ,GI9_TPEMIS   ,GI9_VCARGA   , " +CRLF
	cQuery += "           GI9_PCARGA   ,GI9_CHVMDF   ,GI9_CODREF   ,GI9_PROTOC    " +CRLF
	cQuery += "   FROM " + RetSqlName('GI9') + " GI9 " + CRLF
	cQuery += "  WHERE GI9_FILIAL = '" + xFilial('GI9') + "'" + CRLF	

	cQuery += "    AND GI9_EMISSA >= '" + DTOS(MV_PAR01) + "'" + CRLF
	cQuery += "    AND GI9_EMISSA <= '" + DTOS(MV_PAR02) + "'" + CRLF
	cQuery += "    AND GI9_SERIE  >= '" + MV_PAR03 + "'" + CRLF
	cQuery += "    AND GI9_SERIE  <= '" + MV_PAR04 + "'" + CRLF
	cQuery += "    AND GI9_NUMERO >= '" + MV_PAR05 + "'" + CRLF
	cQuery += "    AND GI9_NUMERO <= '" + MV_PAR06 + "'" + CRLF	
	cQuery += "    AND (GI9_CODREF  = '100')" + CRLF
	cQuery += "    AND GI9.D_E_L_E_T_  = ' ' " + CRLF
	cQuery += "  ORDER BY GI9_FILIAL, GI9_EMISSA, GI9_SERIE, GI9_NUMERO " + CRLF	

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




