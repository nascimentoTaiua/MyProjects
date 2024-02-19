#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"

/*/{Protheus.doc} ENCDACTE
//GeraГЦo da DACTE
@author osmar.junior
@since 24/10/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function ENCDACTE()
Local nCount		:= 0
Local nSoma			:= 0
Local cTmsAntt		:= SuperGetMv( "MV_TMSANTT", .F., .F. )	//Numero do registro na ANTT com 14 dМgitos
Local aCab			:= {}
Local aDoc			:= {}
Local oFont07		:= TFont():New("Times New Roman",07,07,,.F.,,,,.T.,.F.)
Local oFont08		:= TFont():New("Times New Roman",08,08,,.F.,,,,.T.,.F.)
Local oFont08N		:= TFont():New("Times New Roman",08,08,,.T.,,,,.T.,.F.)
Local oFont10N		:= TFont():New("Times New Roman",10,10,,.T.,,,,.T.,.F.)
Local nCont			:= 0
Local lSeqDes		:= .F.
Local lSeqRec		:= .F.
Local cG99Obs		:= ''
Local cG99Obs2		:= ''
Local cG99Obs3		:= '' 
Local cAUXObs		:= ''
Local cAUXObs2		:= ''
Local cAUXObs3		:= ''
Local cObsProp		:= ''
Local cObsStat		:= ''
Local nCountObs		:= ''
Local nLinhaObs  	:= 0
Local aObsCont		:= ''
//-- Buscar dados XML
Local aNotas		:= {}
Local aXML			:= {}
Local cAviso		:= ""
Local cErro			:= ""
Local cAutoriza		:= ""
Local cHorAut		:= ""
Local cDatAut		:= ""
Local cModalidade	:= ""
Local cIdEnt		:= ""
Local nX			:= 0
//-- CFOP - Natureza da Prestacao
Local cCFOP			:= ''
Local cDescCfop		:= ''
//-- Origem Prestacao
Local cOriMunPre	:= ""
Local cOriUFPre		:= ""
//-- Destino Prestacao
Local cDesMunPre	:= ""
Local cDesUFPre		:= ""
//-- Remetente
Local cRemMun		:= ""
Local cRemUF		:= ""
Local cRemNome		:= ""
Local cRemEnd		:= ""
Local cRemNro		:= ""
Local cRemCompl		:= ""
Local cRemBair		:= ""
Local cRemCEP		:= ""
Local cRemCNPJ		:= ""
Local cRemIE		:= ""
Local cRemPais		:= ""
Local cRemFone		:= ""
//-- Destinatario
Local cDesMun		:= ""
Local cDesUF		:= ""
Local cDesNome		:= ""
Local cDesEnd		:= ""
Local cDesNro		:= ""
Local cDesCompl		:= ""
Local cDesBair		:= ""
Local cDesCEP		:= ""
Local cDesCNPJ		:= ""
Local cDesIE		:= ""
Local cDesPais		:= ""
Local cDesFone		:= ""
//-- Expedidor
Local cExpNome		:= ""
Local cExpEnd		:= ""
Local cExpNro		:= ""
Local cExpMun		:= ""
Local cExpBai		:= ""
Local cExpUF		:= ""
Local cExpPais		:= ""
//-- Recebedor
Local cRecNome		:= ""
Local cRecEnd		:= ""
Local cRecNro   	:= ""
Local cRecBai		:= ""
Local cRecMun		:= ""
Local cRecUF		:= ""
Local cRecCEP		:= ""
Local cRecFone  	:= ""
Local lRecPJ		:= .F.
Local cRecCGC		:= ""
Local cRecCPF		:= ""
Local cRecINSCR		:= ""
Local cRecPais		:= ""
Local cRecCompl 	:= ""
//-- Tomador do Servico
Local cDevMun		:= ""
Local cDevUF		:= ""
Local cDevNome		:= ""
Local cDevEnd		:= ""
Local cDevNro		:= ""
Local cDevCompl		:= ""
Local cDevBair		:= ""
Local cDevCEP		:= ""
Local cDevCNPJ		:= ""
Local cDevIE		:= ""
Local cDevPais		:= ""
Local cDevFone		:= ""
//-- Produto Predominante
Local cPPDesc		:= ""
Local cPPCarga	    := ""
Local cPPVlTot	    := ""
Local cPPPesoB	    := ""
Local cPPPeso3	    := ""
Local cPPMetro3	    := ""
Local cPPQtdVol	    := ""
//-- Emial
Local cNomeDacte    := If( TYPE('PARAMIXB') <> 'U' , PARAMIXB[1],'' )
Local lChvEmail     := Empty(cNomeDacte)

//-- Documentos Originarios
Local aDocOri		:= {}
Local lPerig		:= .F.	//-- Informa se ha produtos perigosos
Local cStartPath
Local cTagObs		:= ''
Local lXmlCont      := .F.
Local cError		:= ''
Local cAmbiente     := ''
Local cInsRemOpc	:= ''	// Remetente com sequencia de IE
Local PixelX		:= nil
Local PixelY		:= nil
Local nMM			:= 0
Local cVersaoCTE	:= ""

//-- Variaveis Private
Private oDacte
Private nLInic		:= 0	// Linha Inicial
Private nLFim		:= 0	// Linha Inicial
Private nFolhAtu	:= 1
Private lComp		:= .F.	//CTE Complementar

//-- Verifica se o arquivo sera gerado em Remote Linux
cStartPath := GetTempPath(.T.) 

If	!TMSSpedNFe(@cIdEnt,@cModalidade,@cVersaoCTE,NIL)
	Return()
EndIf

cAmbiente := substr(getCfgAmbiente(@cError, cIdEnt, '57'), 1, 1)

cAliasG99 := DataSource( 'G99' )

If lChvEmail
	oDacte:=FWMSPrinter():New("DACTE",IMP_PDF,.F.,/*cStartPath*/, /*.T.*/,,@oDacte,,,,,.T.)
else
	oDacte:=FWMSPrinter():New(cNomeDacte,IMP_PDF,.F.,/*cStartPath*/, .T.,,@oDacte,,.T.,,,.F.)
EndIf 

oDacte:SetResolution(72)
oDacte:SetPortrait()
oDacte:SetPaperSize(DMPAPER_A4)
oDacte:SetMargin(60,60,60,60)

//--Salvar arquivo na pasta temporaria deverА seleciona no TOTVSPrinter Servidor,
//--Caso contrАrio salvarА na pasta selecionada.
If oDacte:LSERVER == .T.
	oDacte:cPathPDF := cStartPath //--Pasta Temp.
EndIf

If lChvEmail
	If oDacte:nModalResult <> 1
		oDacte:Cancel()        
	EndIf
EndIf

If oDacte:Canceled()
	oDacte:DeActivate()
	Return(.T.)
EndIf

PixelX  := oDacte:nLogPixelX()
PixelY  := oDacte:nLogPixelY()
nMM     := 0

While !(cAliasG99)->(Eof())

	oDacte:StartPage()

	cExpMun		:= ""
	cExpUF		:= ""
	cExpNome	:= ""
	cExpEnd		:= ""
	cExpNro		:= ""
	cExpCompl	:= ""
	cExpBai		:= ""
	cExpCEP		:= ""
	cExpCNPJ	:= ""
	cExpIE		:= ""
	cExpPais	:= ""
	cExpFone	:= ""
	cHorAut		:= ""
	cDatAut		:= ""
	lExped		:= .F.

	//-- Buscar XML do WebService
	aNotas := {}
	aadd(aNotas, {})
	aAdd(Atail(aNotas), .F.)
	aadd(Atail(aNotas), "S") 
	aAdd(Atail(aNotas), "")
	aAdd(Atail(aNotas), (cAliasG99)->G99_SERIE) //SERIE
	aAdd(Atail(aNotas), (cAliasG99)->G99_NUMDOC) //Documento
	aadd(Atail(aNotas), "")
	aadd(Atail(aNotas), "")

	nX   := 1
	aXml := {}

	aXml := TMSGetXML(cIdEnt,aNotas,@cModalidade,"57")
	
	
	If SubStr(cModalidade,1,1) $ '5;7'
		lXmlCont := .T.
	EndIf
		
	If !Empty(aXML[nX][2])
		If !Empty(aXml[nX])
			cAutoriza   := aXML[nX][1]
			cCodAutDPEC := aXML[nX][5]
			cHorAut     := IIF(!Empty(aXML[nX][6]),aXML[nX][6],"")		//-- Data autorizacao
			cDatAut     := IIF(!Empty(aXML[nX][7]),DToC(aXML[nX][7]),"")	//-- Hora autorizacao
		Else
			cAutoriza   := ""
			cCodAutDPEC := ""
		EndIf
		cAviso := ""
		cErro  := ""
		oNfe := XmlParser(aXML[nX][2],"_",@cAviso,@cErro)
		//oNfeDPEC := XmlParser(aXML[nX][4],"_",@cAviso,@cErro)
		
		If Type( 'oNFE' ) == 'U'
			(cAliasG99)->(DbSkip())
			Loop
		EndIf
		
		If (!Empty(cAutoriza) .Or. !Empty(cCodAutDPEC) .Or. !cModalidade$"1,4,5,6")
			If aNotas[nX][02]=="S"
				dbSelectArea("SF2")
				dbSetOrder(1)
				If MsSeek(xFilial("SF2")+aNotas[nX][05]+aNotas[nX][04]) .And. cModalidade$"1,4,6"
					RecLock("SF2")
					If !SF2->F2_FIMP$"D"
						SF2->F2_FIMP := "S"
					EndIf
					If SF2->(FieldPos("F2_CHVNFE"))>0
						SF2->F2_CHVNFE := SubStr(NfeIdSPED(aXML[nX][2],"Id"),4)
					EndIf
					MsUnlock()
				EndIf
			EndIf
		EndIf
	EndIf
	
	If Type( 'oNFE' ) == 'U'
		(cAliasG99)->(DbSkip())
		Loop 
	EndIf

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Controla o documento a ser enviado para montagem do cabecalho.         Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	nCont += 1
		aAdd(aCab, {;
		AllTrim((cAliasG99)->G99_NUMDOC),;
		AllTrim(oNfe:_CTE:_INFCTE:_IDE:_SERIE:TEXT),;
		AllTrim(STRTRAN( SUBSTR( oNfe:_CTE:_INFCTE:_IDE:_dhEmi:TEXT, 1, AT('T', oNfe:_CTE:_INFCTE:_IDE:_dhEmi:TEXT) - 1) , '-', '')),;
		AllTrim(STRTRAN( SUBSTR( oNfe:_CTE:_INFCTE:_IDE:_dhEmi:TEXT, AT('T', oNfe:_CTE:_INFCTE:_IDE:_dhEmi:TEXT) + 1, 5) , ':', '')),;
		AllTrim(STRTRAN(UPPER(oNFE:_CTE:_INFCTE:_ID:TEXT),'CTE','')),;
		(cAliasG99)->G99_PROTOC,"" ,cDatAut, cHorAut})	//-- Nao possui ref. no XML
	
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Funcao responsavel por montar o cabecalho do relatorio                 Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	nFolhAtu := 1
	lSeqDes  :=.F.
	lSeqRec  :=.F.
	TMSR31Cab(aCab[nCont],.T., lXmlCont)

	//-- Estrutura da funcao que retorna o logradouro, numero e complemento.
	//-- Logradouro		FisGetEnd(XXXXXXXX)[1]
	//-- Numero			FisGetEnd(XXXXXXXX)[2]
	//-- Complemento	FisGetEnd(XXXXXXXX)[4]

		//-- CFOP
		cCFOP		:= AllTrim(oNfe:_CTE:_INFCTE:_IDE:_CFOP:TEXT)
		cDescCfop	:= AllTrim(oNfe:_CTE:_INFCTE:_IDE:_NATOP:TEXT)

		//-- Origem da Prestacao
		cOriMunPre	:= Iif(Type("oNfe:_CTE:_INFCTE:_IDE:_XMUNINI:TEXT")=="U"," ",oNfe:_CTE:_INFCTE:_IDE:_XMUNINI:TEXT)
		cOriUFPre	:= oNfe:_CTE:_INFCTE:_IDE:_UFINI:TEXT

		//-- Destino da Prestacao
		cDesMunPre	:= oNfe:_CTE:_INFCTE:_IDE:_XMUNFIM:TEXT
		cDesUFPre	:= oNfe:_CTE:_INFCTE:_IDE:_UFFIM:TEXT

		//-- Remetente
		If Type("oNfe:_CTE:_INFCTE:_REM") <> "U"
			cRemMun   := oNfe:_CTE:_INFCTE:_REM:_ENDERREME:_XMUN:TEXT
			cRemUF    := oNfe:_CTE:_INFCTE:_REM:_ENDERREME:_UF:TEXT
			cRemNome  := oNfe:_CTE:_INFCTE:_REM:_XNOME:TEXT
			cRemEnd   := oNfe:_CTE:_INFCTE:_REM:_ENDERREME:_XLGR:TEXT
			cRemNro   := oNfe:_CTE:_INFCTE:_REM:_ENDERREME:_NRO:TEXT
			cRemCompl := Iif(Type("oNfe:_CTE:_INFCTE:_REM:_ENDERREME:_XCPL:TEXT"  )=="U"," ",oNfe:_CTE:_INFCTE:_REM:_ENDERREME:_XCPL:TEXT)
			cRemBair  := oNfe:_CTE:_INFCTE:_REM:_ENDERREME:_XBAIRRO:TEXT
			cRemCEP   := oNfe:_CTE:_INFCTE:_REM:_ENDERREME:_CEP:TEXT
			cRemCNPJ  := Iif(Type("oNfe:_CTE:_INFCTE:_REM:_CNPJ:TEXT")=="U",oNfe:_CTE:_INFCTE:_REM:_CPF:TEXT,oNfe:_CTE:_INFCTE:_REM:_CNPJ:TEXT)
			cRemIE    := Iif(Type("oNfe:_CTE:_INFCTE:_REM:_IE:TEXT"  )=="U"," ",oNfe:_CTE:_INFCTE:_REM:_IE:TEXT)
			cRemPais  := Iif(Type("oNfe:_CTE:_INFCTE:_REM:_ENDERREME:_XPAIS:TEXT")=="U"," ",oNfe:_CTE:_INFCTE:_REM:_ENDERREME:_XPAIS:TEXT)
			cRemFone  := Iif(Type("oNfe:_CTE:_INFCTE:_REM:_FONE:TEXT")=="U"," ",oNfe:_CTE:_INFCTE:_REM:_FONE:TEXT)
		EndIf
		//-- Expedidor
		If (Type("oNfe:_CTE:_INFCTE:_EXPED")) <> "U"
			lExped		:= .T.
			cExpMun	:= oNfe:_CTE:_INFCTE:_EXPED:_ENDEREXPED:_XMUN:TEXT
			cExpUF		:= oNfe:_CTE:_INFCTE:_EXPED:_ENDEREXPED:_UF:TEXT
			cExpNome	:= oNfe:_CTE:_INFCTE:_EXPED:_XNOME:TEXT
			cExpEnd	:= oNfe:_CTE:_INFCTE:_EXPED:_ENDEREXPED:_XLGR:TEXT
			cExpNro	:= oNfe:_CTE:_INFCTE:_EXPED:_ENDEREXPED:_NRO:TEXT
			cExpCompl 	:= ""
			cExpBai	:= oNfe:_CTE:_INFCTE:_EXPED:_ENDEREXPED:_XBAIRRO:TEXT
			cExpCEP   := oNfe:_CTE:_INFCTE:_EXPED:_ENDEREXPED:_CEP:TEXT
			cExpCNPJ  := Iif(Type("oNfe:_CTE:_INFCTE:_EXPED:_CNPJ:TEXT")=="U", oNfe:_CTE:_INFCTE:_EXPED:_CPF:TEXT , oNfe:_CTE:_INFCTE:_EXPED:_CNPJ:TEXT)
			cExpIE    := Iif(Type("oNfe:_CTE:_INFCTE:_EXPED:_IE:TEXT"  )=="U"," ",oNfe:_CTE:_INFCTE:_EXPED:_IE:TEXT)
			cExpPais  := Iif(Type("oNfe:_CTE:_INFCTE:_EXPED:_ENDEREXPED:_XPAIS:TEXT")=="U"," ",oNfe:_CTE:_INFCTE:_EXPED:_ENDEREXPED:_XPAIS:TEXT)
			cExpFone  := Iif(Type("oNfe:_CTE:_INFCTE:_EXPED:_FONE:TEXT")=="U"," ",oNfe:_CTE:_INFCTE:_EXPED:_FONE:TEXT)
		EndIf

		//-- Destinatario
		If Type("oNfe:_CTE:_INFCTE:_DEST") <> "U"
			cDesMun   := oNfe:_CTE:_INFCTE:_DEST:_ENDERDEST:_XMUN:TEXT
			cDesUF    := oNfe:_CTE:_INFCTE:_DEST:_ENDERDEST:_UF:TEXT
			cDesNome  := oNfe:_CTE:_INFCTE:_DEST:_XNOME:TEXT
			cDesEnd   := oNfe:_CTE:_INFCTE:_DEST:_ENDERDEST:_XLGR:TEXT
			cDesNro   := oNfe:_CTE:_INFCTE:_DEST:_ENDERDEST:_NRO:TEXT
			cDesCompl := Iif(Type("oNfe:_CTE:_INFCTE:_DEST:_ENDERDEST:_XCPL:TEXT"  )=="U"," ", oNfe:_CTE:_INFCTE:_DEST:_ENDERDEST:_XCPL:TEXT)
			cDesBair  := oNfe:_CTE:_INFCTE:_DEST:_ENDERDEST:_XBAIRRO:TEXT
			cDesCEP   := oNfe:_CTE:_INFCTE:_DEST:_ENDERDEST:_CEP:TEXT
			cDesCNPJ  := Iif(Type("oNfe:_CTE:_INFCTE:_DEST:_CNPJ:TEXT")=="U",    oNfe:_CTE:_INFCTE:_DEST:_CPF:TEXT, oNfe:_CTE:_INFCTE:_DEST:_CNPJ:TEXT)
			cDesIE    := Iif(Type("oNfe:_CTE:_INFCTE:_DEST:_IE:TEXT"  )=="U"," ",oNfe:_CTE:_INFCTE:_DEST:_IE:TEXT)
			cDesPais  := Iif(Type("oNfe:_CTE:_INFCTE:_DEST:_ENDERDEST:_XPAIS:TEXT")=="U"," ",oNfe:_CTE:_INFCTE:_DEST:_ENDERDEST:_XPAIS:TEXT)
			cDesFone  := Iif(Type("oNfe:_CTE:_INFCTE:_DEST:_FONE:TEXT")=="U"," ",oNfe:_CTE:_INFCTE:_DEST:_FONE:TEXT)
		EndIf

		//-- Local de Entrega
		If (Type("oNfe:_CTE:_INFCTE:_RECEB:_ENDERRECEB")) <> "U"
			lSeqRec := .T.
			//Destino Recebedor
			cRecNome	:= oNfe:_CTE:_INFCTE:_RECEB:_XNOME:TEXT
			cRecEnd		:= oNfe:_CTE:_INFCTE:_RECEB:_ENDERRECEB:_XLGR:TEXT
			cRecNro  	:= oNfe:_CTE:_INFCTE:_RECEB:_ENDERRECEB:_NRO:TEXT
			cRecBai		:= oNfe:_CTE:_INFCTE:_RECEB:_ENDERRECEB:_XBAIRRO:TEXT
			cRecMun		:= oNfe:_CTE:_INFCTE:_RECEB:_ENDERRECEB:_XMUN:TEXT
			crecUF		:= oNfe:_CTE:_INFCTE:_RECEB:_ENDERRECEB:_UF:TEXT
			cRecPais  	:= Iif(Type("oNfe:_CTE:_INFCTE:_RECEB:_ENDERRECEB:_XPAIS:TEXT")=="U"," ",oNfe:_CTE:_INFCTE:_RECEB:_ENDERRECEB:_XPAIS:TEXT)
			cRecCompl 	:= Iif( Type("oNfe:_CTE:_INFCTE:_RECEB:_ENDERRECEB:_XCPL:TEXT") == "U"," ",oNfe:_CTE:_INFCTE:_RECEB:_ENDERRECEB:_XCPL:TEXT )
			cRecCEP   	:= Iif( Type("oNfe:_CTE:_INFCTE:_RECEB:_ENDERRECEB:_CEP:TEXT")  == "U"," ",oNfe:_CTE:_INFCTE:_RECEB:_ENDERRECEB:_CEP:TEXT  )
			
			cRecFone := Iif( Type("oNfe:_CTE:_INFCTE:_RECEB:_FONE:TEXT") == "U"," ",oNfe:_CTE:_INFCTE:_RECEB:_FONE:TEXT )
			If Empty(cRecFone)
				cRecFone := Iif( Type("oNfe:_CTE:_INFCTE:_RECEB:_ENDERRECEB:_FONE:TEXT") == "U"," ",oNfe:_CTE:_INFCTE:_RECEB:_ENDERRECEB:_FONE:TEXT )
			EndIf

			If Type("oNfe:_CTE:_INFCTE:_RECEB:_CNPJ:TEXT")=="U"
				cRecCPF	:= oNfe:_CTE:_INFCTE:_RECEB:_CPF:TEXT
			Else
				cRecCGC	:= oNfe:_CTE:_INFCTE:_RECEB:_CNPJ:TEXT				
				cRecINSCR := Iif(Type("oNfe:_CTE:_INFCTE:_RECEB:_IE:TEXT" )=="U"," ",oNfe:_CTE:_INFCTE:_RECEB:_IE:TEXT)
				lRecPJ	:= .T.
			EndIf		
		EndIf

		//-- Produto Predominante
		If (Type("oNFE:_CTE:_INFCTE:_INFCTENORM")) <> "U"
			If Type("oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_PROPRED") <>  "U"
				cPPDesc		:= oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_PROPRED:TEXT
			EndIf
			If Type("oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_XOUTCAT") <>  "U"
				cPPCarga	:= oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_XOUTCAT:TEXT
			EndIf
			If Type("oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_VMERC") <> "U"
				cPPVlTot	:= oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_VMERC:TEXT
			Else
				cPPVlTot	:= oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_VCARGA:TEXT
			EndIf
			If ValType( oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ ) == 'A'
				For nCount := 1 To Len( oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ )
					Do Case
						Case oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ[ nCount ]:_TPMED:TEXT == "PESO DECLARADO"
							cPPPesoB := oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ[ nCount ]:_QCARGA:TEXT
						Case oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ[ nCount ]:_TPMED:TEXT == "PESO CUBADO"
							cPPPeso3 := oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ[ nCount ]:_QCARGA:TEXT
						Case oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ[ nCount ]:_TPMED:TEXT == "LITRAGEM"
							cPPQtdVol := oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ[ nCount ]:_QCARGA:TEXT
						Case oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ[ nCount ]:_TPMED:TEXT == "VOLUME"
							cPPQtdVol := oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ[ nCount ]:_QCARGA:TEXT
						Case oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ[ nCount ]:_TPMED:TEXT == "METROS CUBICOS"
							cPPMetro3 := oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ[ nCount ]:_QCARGA:TEXT
					EndCase
				Next nCount
			EndIf
		EndIf

		//-- Tomador
		//здддддддддддддддддддддддддддд©
		//Ё Tomador do Servico         Ё
		//Ё 0 - Remetente;             Ё
		//Ё 1 - Expedidor;             Ё
		//Ё 2 - Recebedor;             Ё
		//Ё 3 - Destinatario.          Ё
		//юдддддддддддддддддддддддддддды
		//| Remetente И o tomador do frete
		If Type("oNfe:_CTE:_INFCTE:_IDE:_TOMA3:_TOMA:TEXT") <> "U"
			If oNfe:_CTE:_INFCTE:_IDE:_TOMA3:_TOMA:TEXT == "0"
				cDevMun   := cRemMun
				cDevUF    := cRemUF
				cDevNome  := cRemNome
				cDevEnd   := cRemEnd
				cDevNro   := cRemNro
				cDevCompl := cRemCompl
				cDevBair  := cRemBair
				cDevCEP   := cRemCEP
				cDevCNPJ  := cRemCNPJ
				cDevIE    := cRemIE
				cDevPais  := cRemPais
				cDevFone  := cRemFone
			//| Expediro И o Tomador do Frete
			ElseIf oNfe:_CTE:_INFCTE:_IDE:_TOMA3:_TOMA:TEXT == "1"
				cDevMun   := cExpMun
				cDevUF    := cExpUF
				cDevNome  := cExpNome
				cDevEnd   := cExpEnd
				cDevNro   := cExpNro
				cDevCompl := cExpCompl
				cDevBair  := cExpBai
				cDevCEP   := cExpCEP
				cDevCNPJ  := cExpCNPJ
				cDevIE    := cExpIE
				cDevPais  := cExpPais
				cDevFone  := cExpFone
			//| Recebedor И o tomador do frete
			ElseIf oNfe:_CTE:_INFCTE:_IDE:_TOMA3:_TOMA:TEXT == "2"
				cDevMun   := cRecMun
				cDevUF    := cRecUF
				cDevNome  := cRecNome
				cDevEnd   := cRecEnd
				cDevNro   := cRecNro
				cDevCompl := cRecCompl
				cDevBair  := cRecBai
				cDevCEP   := cRecCEP
				cDevCNPJ  := cRecCGC
				cDevIE    := cRecINSCR
				cDevPais  := cRecPais
				cDevFone  := cRecFone
			//| Expediro И o Tomador do Frete
			ElseIf oNfe:_CTE:_INFCTE:_IDE:_TOMA3:_TOMA:TEXT == "3"
				cDevMun   := cDesMun
				cDevUF    := cDesUF
				cDevNome  := cDesNome
				cDevEnd   := cDesEnd
				cDevNro   := cDesNro
				cDevCompl := cDesCompl
				cDevBair  := cDesBair
				cDevCEP   := cDesCEP
				cDevCNPJ  := cDesCNPJ
				cDevIE    := cDesIE
				cDevPais  := cDesPais
				cDevFone  := cDesFone
			EndIf
		ElseIf Type("oNfe:_CTE:_INFCTE:_IDE:_TOMA4:_TOMA:TEXT") <> "U"
			If oNfe:_CTE:_INFCTE:_IDE:_TOMA4:_TOMA:TEXT == "4"
				// Subcontratacao G99_DEVFRE == "4" - Despachante		
				cDevMun   := oNfe:_CTE:_INFCTE:_IDE:_TOMA4:_ENDERTOMA:_XMUN:TEXT
				cDevUF    := oNfe:_CTE:_INFCTE:_IDE:_TOMA4:_ENDERTOMA:_UF:TEXT
				cDevNome  := oNfe:_CTE:_INFCTE:_IDE:_TOMA4:_XNOME:TEXT
				cDevEnd   := oNfe:_CTE:_INFCTE:_IDE:_TOMA4:_ENDERTOMA:_XLGR:TEXT
				cDevNro   := oNfe:_CTE:_INFCTE:_IDE:_TOMA4:_ENDERTOMA:_NRO:TEXT
				cDevCompl := ""
				cDevBair  := oNfe:_CTE:_INFCTE:_IDE:_TOMA4:_ENDERTOMA:_XBAIRRO:TEXT
				cDevCEP   := oNfe:_CTE:_INFCTE:_IDE:_TOMA4:_ENDERTOMA:_CEP:TEXT
				cDevCNPJ  := Iif(Type("oNfe:_CTE:_INFCTE:_IDE:_TOMA4:_CNPJ:TEXT")=="U",oNfe:_CTE:_INFCTE:_IDE:_TOMA4:_CPF:TEXT,oNfe:_CTE:_INFCTE:_IDE:_TOMA4:_CNPJ:TEXT)
				cDevIE    := Iif(Type("oNfe:_CTE:_INFCTE:_IDE:_TOMA4:_IE:TEXT"  )=="U"," ",oNfe:_CTE:_INFCTE:_IDE:_TOMA4:_IE:TEXT)
				cDevPais  := ""
				cDevFone  := Iif(Type("oNfe:_CTE:_INFCTE:_IDE:_TOMA4:_FONE:TEXT")=="U"," ",oNfe:_CTE:_INFCTE:_IDE:_TOMA4:_FONE:TEXT)
			EndIf
		EndIf
		//-- Documentos Originarios
		aDocOri := {}
		If	( Type( "oNFE:_CTE:_INFCTE:_REM:_INFNFE" ) <> 'U' )
			If ValType( oNFE:_CTE:_INFCTE:_REM:_INFNFE ) == 'A'
				For nCount := 1 To Len( oNFE:_CTE:_INFCTE:_REM:_INFNFE )
					If aScan(aDocOri,{|x|x[8]==oNFE:_CTE:_INFCTE:_REM:_INFNFE[ nCount ]:_CHAVE:TEXT})==0
						AADD(aDocOri, {;
						'',;
						'',;
						'',;
						'',;
						'',;
						'',;
						'',;
						oNFE:_CTE:_INFCTE:_REM:_INFNFE[ nCount ]:_CHAVE:TEXT })
					EndIf
				Next nCount
			ElseIf ValType( oNFE:_CTE:_INFCTE:_REM:_INFNFE ) == 'O'
				If aScan(aDocOri,{|x|x[8]==oNFE:_CTE:_INFCTE:_REM:_INFNFE:_CHAVE:TEXT})==0
					AADD(aDocOri, {;
					'',;
					'',;
					'',;
					'',;
					'',;
					'',;
					'',;
					oNFE:_CTE:_INFCTE:_REM:_INFNFE:_CHAVE:TEXT }) 
				EndIf
			EndIf
		ElseIf	( Type( "oNFE:_CTE:_INFCTE:_REM:_INFNF" ) <> 'U' ) 
			If ValType( oNFE:_CTE:_INFCTE:_REM:_INFNF ) == 'A'
				For nCount := 1 To Len( oNFE:_CTE:_INFCTE:_REM:_INFNF )
					If aScan(aDocOri,{|x|x[1]+x[2]==oNFE:_CTE:_INFCTE:_REM:_INFNF[ nCount ]:_SERIE:TEXT+oNFE:_CTE:_INFCTE:_REM:_INFNF[ nCount ]:_NDOC:TEXT})==0
						AADD(aDocOri, {;
						oNFE:_CTE:_INFCTE:_REM:_INFNF[ nCount ]:_SERIE:TEXT,;
						oNFE:_CTE:_INFCTE:_REM:_INFNF[ nCount ]:_NDOC:TEXT,;
						STRTRAN(oNFE:_CTE:_INFCTE:_REM:_INFNF[ nCount ]:_DEMI:TEXT,'-'),;
						oNFE:_CTE:_INFCTE:_REM:_INFNF[ nCount ]:_VPROD:TEXT,;
						'',;
						'',;
						'',;
						'' })
					EndIf
				Next nCount
				//-- Local de Retirada
				If (Type("oNfe:_CTE:_INFCTE:_REM:_INFNF[1]:_LOCRET")) <> "U"
					cExpMun	:= oNfe:_CTE:_INFCTE:_REM:_INFNF[1]:_LOCRET:_XMUN:TEXT
					cExpUF		:= oNfe:_CTE:_INFCTE:_REM:_INFNF[1]:_LOCRET:_UF:TEXT
					cExpNome	:= oNfe:_CTE:_INFCTE:_REM:_INFNF[1]:_LOCRET:_XNOME:TEXT
					cExpEnd	:= oNfe:_CTE:_INFCTE:_REM:_INFNF[1]:_LOCRET:_XLGR:TEXT
					cExpNro	:= oNfe:_CTE:_INFCTE:_REM:_INFNF[1]:_LOCRET:_NRO:TEXT
					cExpCompl 	:= ""
					cExpBai	:= oNfe:_CTE:_INFCTE:_REM:_INFNF[1]:_LOCRET:_XBAIRRO:TEXT
					cExpCEP   	:= ""
					cExpCNPJ  	:= Iif(Type("oNfe:_CTE:_INFCTE:_REM:_INFNF[1]:_LOCRET:_CNPJ:TEXT")=="U", oNfe:_CTE:_INFCTE:_REM:_INFNF[1]:_LOCRET:_CPF:TEXT , oNfe:_CTE:_INFCTE:_REM:_INFNF[1]:_LOCRET:_CNPJ:TEXT)
					cExpIE    	:= ""
					cExpPais  	:= cRemPais
					cExpFone  	:= ""
				EndIf
			Else
				If aScan(aDocOri,{|x|x[1]+x[2]==oNFE:_CTE:_INFCTE:_REM:_INFNF:_SERIE:TEXT+oNFE:_CTE:_INFCTE:_REM:_INFNF:_NDOC:TEXT})==0
					AADD(aDocOri, {;
					oNFE:_CTE:_INFCTE:_REM:_INFNF:_SERIE:TEXT,;
					oNFE:_CTE:_INFCTE:_REM:_INFNF:_NDOC:TEXT,;
					STRTRAN(oNFE:_CTE:_INFCTE:_REM:_INFNF:_DEMI:TEXT,'-'),;
					oNFE:_CTE:_INFCTE:_REM:_INFNF:_VPROD:TEXT,;
					'',;
					'',;
					'',;
					'' })
				EndIf
				If (Type("oNfe:_CTE:_INFCTE:_REM:_INFNF:_LOCRET")) <> "U"
					cExpMun	:= oNfe:_CTE:_INFCTE:_REM:_INFNF:_LOCRET:_XMUN:TEXT
					cExpUF		:= oNfe:_CTE:_INFCTE:_REM:_INFNF:_LOCRET:_UF:TEXT
					cExpNome	:= oNfe:_CTE:_INFCTE:_REM:_INFNF:_LOCRET:_XNOME:TEXT
					cExpEnd	:= oNfe:_CTE:_INFCTE:_REM:_INFNF:_LOCRET:_XLGR:TEXT
					cExpNro	:= oNfe:_CTE:_INFCTE:_REM:_INFNF:_LOCRET:_NRO:TEXT
					cExpCompl 	:= ""
					cExpBai	:= oNfe:_CTE:_INFCTE:_REM:_INFNF:_LOCRET:_XBAIRRO:TEXT
					cExpCEP   	:= ""
					cExpCNPJ  	:= Iif(Type("oNfe:_CTE:_INFCTE:_REM:_INFNF:_LOCRET:_CNPJ:TEXT")=="U", oNfe:_CTE:_INFCTE:_REM:_INFNF:_LOCRET:_CPF:TEXT , oNfe:_CTE:_INFCTE:_REM:_INFNF:_LOCRET:_CNPJ:TEXT)
					cExpIE    	:= ""
					cExpPais  	:= cRemPais
					cExpFone  	:= ""
			EndIf
			EndIf
        //Aqui Inicio
		ElseIf  (Type( "oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNF")) <> 'U'  
				If ValType( oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNF ) == 'A'
					For nCount := 1 To Len( oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNF )
						If aScan(aDocOri,{|x|x[1]+x[2]==oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNF[ nCount ]:_SERIE:TEXT+oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNF[ nCount ]:_NDOC:TEXT})==0
							AADD(aDocOri, {;
							oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNF[ nCount ]:_SERIE:TEXT,;
							oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNF[ nCount ]:_NDOC:TEXT,;
							STRTRAN(oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNF[ nCount ]:_DEMI:TEXT,'-'),;
							oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNF[ nCount ]:_VPROD:TEXT,;
							'',;
							'',;
							'',;
							'' })
						EndIf
					Next nCount
				Else
					If aScan(aDocOri,{|x|x[1]+x[2]==oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNF:_SERIE:TEXT+oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNF:_NDOC:TEXT})==0
						AADD(aDocOri, {;
						oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNF:_SERIE:TEXT,;
						oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNF:_NDOC:TEXT,;
						STRTRAN(oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNF:_DEMI:TEXT,'-'),;
						oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNF:_VPROD:TEXT,;
						'',;
						'',;
						'',;
						'',;
						'' })
					EndIf
				EndIf
	        
	        // Fim
		ElseIf	( Type( "oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE" ) <> 'U' )
			If ValType( oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE ) == 'A'
				For nCount := 1 To Len( oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE )
					If aScan(aDocOri,{|x|x[8]==oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE[ nCount ]:_CHAVE:TEXT})==0
						AADD(aDocOri, {;
						'',;
						'',;
						'',;
						'',;
						'',;
						'',;
						'',;
						oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE[ nCount ]:_CHAVE:TEXT,;
						'' })
					EndIf
				Next nCount
			ElseIf ValType( oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE ) == 'O'
				If aScan(aDocOri,{|x|x[8]==oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE:_CHAVE:TEXT})==0
					AADD(aDocOri, {;
					'',;
					'',;
					'',;
					'',;
					'',;
					'',;
					'',;
					oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE:_CHAVE:TEXT,;
					'' }) 
				EndIf
			EndIf
		ElseIf	( Type( "oNFE:_CTE:_INFCTE:_REM:_INFOUTROS" ) <> 'U' ) 
			If ValType( oNFE:_CTE:_INFCTE:_REM:_INFOUTROS ) == 'A'
				For nCount := 1 To Len( oNFE:_CTE:_INFCTE:_REM:_INFOUTROS )
					If aScan(aDocOri,{|x|x[1]+x[2]==oNFE:_CTE:_INFCTE:_REM:_INFOUTROS[ nCount ]:_NDOC:TEXT})==0
						AADD(aDocOri, {;
						'',; //SERIE DO DOCUMENTO NAO INFORMADA NO XML QUANDO O DOCUMENTO NAO EH FISCAL
						oNFE:_CTE:_INFCTE:_REM:_INFOUTROS[ nCount ]:_NDOC:TEXT,;
						STRTRAN(oNFE:_CTE:_INFCTE:_REM:_INFOUTROS[ nCount ]:_DEMI:TEXT,'-'),;
						'',; //--VALOR DO PRODUTO NAO INFORMADO NO XML QUANDO O DOCUMENTO NAO EH FISCAL
						'',;
						'',;
						'',;
						'' })
					EndIf
				Next nCount
			Else
				If aScan(aDocOri,{|x|x[1]+x[2]==oNFE:_CTE:_INFCTE:_REM:_INFOUTROS:_SERIE:TEXT+oNFE:_CTE:_INFCTE:_REM:_INFOUTROS:_NDOC:TEXT})==0
					AADD(aDocOri, {;
					'',;//SERIE DO DOCUMENTO NAO INFORMADA NO XML QUANDO O DOCUMENTO NAO EH FISCAL
					oNFE:_CTE:_INFCTE:_REM:_INFOUTROS:_NDOC:TEXT,;
					STRTRAN(oNFE:_CTE:_INFCTE:_REM:_INFOUTROS:_DEMI:TEXT,'-'),;
					'',; //--VALOR DO PRODUTO NAO INFORMADO NO XML QUANDO O DOCUMENTO NAO EH FISCAL
					'',;
					'',;
					'',;
					'' })
				EndIf
			EndIf
		ElseIf	( Type( "oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFOUTROS" ) <> 'U' ) 
			If ValType( oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFOUTROS ) == 'A'
				For nCount := 1 To Len( oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFOUTROS )
					If aScan(aDocOri,{|x|x[1]+x[2]==oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFOUTROS[ nCount ]:_NDOC:TEXT})==0
						AADD(aDocOri, {;
						'',; //SERIE DO DOCUMENTO NAO INFORMADA NO XML QUANDO O DOCUMENTO NAO EH FISCAL
						oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFOUTROS[ nCount ]:_NDOC:TEXT,;
						STRTRAN(oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFOUTROS[ nCount ]:_DEMI:TEXT,'-'),;
						'',; //--VALOR DO PRODUTO NAO INFORMADO NO XML QUANDO O DOCUMENTO NAO EH FISCAL
						'',;
						'',;
						'',;
						'' })
					EndIf
				Next nCount
			Else
				If aScan(aDocOri,{|x|x[1]+x[2]==oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFOUTROS:_SERIE:TEXT+oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFOUTROS:_NDOC:TEXT})==0
					AADD(aDocOri, {;
					'',;//SERIE DO DOCUMENTO NAO INFORMADA NO XML QUANDO O DOCUMENTO NAO EH FISCAL
					'',;//oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFOUTROS:_NDOC:TEXT,;
					STRTRAN(oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFOUTROS:_DESCOUTROS:TEXT,'-'),;
					'',; //--VALOR DO PRODUTO NAO INFORMADO NO XML QUANDO O DOCUMENTO NAO EH FISCAL
					'',;
					'',;
					'',;
					'' })
				EndIf
			EndIf
		EndIf		
	
		//Tratamento para a tag docAnt
		If	( Type( "oNFE:_CTE:_INFCTE:_INFCTENORM:_DOCANT:_EMIDOCANT:_IDDOCANT:_IDDOCANTELE" ) <> 'U' )
			If ValType( oNFE:_CTE:_INFCTE:_INFCTENORM:_DOCANT:_EMIDOCANT:_IDDOCANT:_IDDOCANTELE ) == 'A'
				For nCount := 1 To Len( oNFE:_CTE:_INFCTE:_INFCTENORM:_DOCANT:_EMIDOCANT:_IDDOCANT:_IDDOCANTELE )
					If aScan(aDocOri,{|x|x[9]==oNFE:_CTE:_INFCTE:_INFCTENORM:_DOCANT:_EMIDOCANT:_IDDOCANT:_IDDOCANTELE[ nCount ]:_CHCTE:TEXT})==0
						AADD(aDocOri, {;
						'',;
						'',;
						'',;
						'',;
						'',;
						'',;
						'',;
						'',;
						oNFE:_CTE:_INFCTE:_INFCTENORM:_DOCANT:_EMIDOCANT:_IDDOCANT:_IDDOCANTELE[ nCount ]:_CHCTE:TEXT })
					EndIf
				Next nCount
			ElseIf ValType( oNFE:_CTE:_INFCTE:_INFCTENORM:_DOCANT:_EMIDOCANT:_IDDOCANT:_IDDOCANTELE ) == 'O'
				If aScan(aDocOri,{|x|x[9]==oNFE:_CTE:_INFCTE:_INFCTENORM:_DOCANT:_EMIDOCANT:_IDDOCANT:_IDDOCANTELE:_CHCTE:TEXT})==0
					AADD(aDocOri, {;
					'',;
					'',;
					'',;
					'',;
					'',;
					'',;
					'',;
					'',;
					oNFE:_CTE:_INFCTE:_INFCTENORM:_DOCANT:_EMIDOCANT:_IDDOCANT:_IDDOCANTELE:_CHCTE:TEXT }) 
				EndIf
			EndIf
		EndIf

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё BOX: CFOP - Natureza da Prestacao                                      Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	oDacte:Box(0195, 0000, 0215, 0260)
	oDacte:Say(0202, 0003, "CСdigo Fiscal de OperaГУes - Natureza da OperaГЦo",	oFont08N)
	oDacte:Say(0211, 0003, cCFOP + " - " + cDescCfop,		oFont08)

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё BOX: ORIGEM DA PRESTACAO                                               Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	oDacte:Box(0215, 0000, 0229, 0280)
	oDacte:Say(0221, 0003, "InМcio da PrestaГЦo" , oFont08N)
	oDacte:Say(0228, 0003, AllTrim(cOriMunPre) + ' - ' + AllTrim(cOriUFPre), oFont08)	

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё BOX: DESTINO DA PRESTACAO                                              Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	oDacte:Box(0215, 0280, 0229, 0559)
	oDacte:Say(0221, 0288, "TИrmino da PrestaГЦo", oFont08N)
	oDacte:Say(0228, 0288, AllTrim(cDesMunPre) + ' - ' + AllTrim(cDesUFPre), oFont08)

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё BOX: Remetente                                                         Ё
	//Ё BOX: Destinatario                                                      Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	oDacte:Box(0231, 0000, 0282, 0279)	//Remetente
	oDacte:Box(0231, 0281, 0282, 0559)	//Destinatario

	oDacte:Say(0237, 0003, "Remetente:", oFont08)
	oDacte:Say(0237, 0043, NoAcentoCte(Substr(cRemNome,1,45)), oFont08N)
	oDacte:Say(0237, 0286, "DestinatАrio:", oFont08)
	oDacte:Say(0237, 0328, NoAcentoCte(Substr(cDesNome,1,45)), oFont08N)

	cInsRemOpc := AllTrim(cRemIE)
	For nCount := 1 To 5
		Do Case
			Case ( nCount == 1 )
				oDacte:Say(0246, 0003, "EndereГo:", oFont08)
				oDacte:Say(0246, 0043, AllTrim(cRemEnd) + ", " + cRemNro, oFont08)
				oDacte:Say(0246, 0286, "EndereГo:", oFont08)
				oDacte:Say(0246, 0328, AllTrim(cDesEnd) + ", " + cDesNro, oFont08)
			Case ( nCount == 2 )
				oDacte:Say(0253, 0043, AllTrim(cRemCompl) + " - " + AllTrim(cRemBair), oFont08)
				oDacte:Say(0253, 0328, AllTrim(cDesCompl) + " - " + AllTrim(cDesBair), oFont08)
			Case ( nCount == 3 )
				oDacte:Say(0260, 0003, "MunicМpio:", oFont08)
				oDacte:Say(0260, 0043, AllTrim(cRemMun) + ' - ' + AllTrim(cRemUF)  + ' CEP.: ' + Transform(AllTrim(cRemCEP), "@r 99999-999"), oFont08)
				oDacte:Say(0260, 0286, "MunicМpio:", oFont08)
				oDacte:Say(0260, 0328, AllTrim(cDesMun) + ' - ' + AllTrim(cDesUF) + ' CEP.: ' + Transform(AllTrim(cDesCEP), "@r 99999-999"), oFont08)
			Case ( nCount == 4 )
				oDacte:Say(0267, 0003, "CNPJ/CPF:", oFont08)
				oDacte:Say(0267, 0043, Transform(AllTrim(cRemCNPJ), "@r 99.999.999/9999-99") + "   InscriГЦo Estadual: " +  AllTrim(cInsRemOpc), oFont08)
				oDacte:Say(0267, 0286, "CNPJ/CPF:", oFont08)
				oDacte:Say(0267, 0328, Transform(AllTrim(cDesCNPJ), "@r 99.999.999/9999-99") + "   InscriГЦo Estadual: " +  AllTrim(cDesIE),    oFont08)
			Case ( nCount == 5 )
				oDacte:Say(0274, 0003, "PaМs:", oFont08)
				oDacte:Say(0274, 0043, AllTrim(cRemPais) + ' - Telefone: ' + Transform(AllTrim(cRemFone),"@r (999) 999999999"),  oFont08)
				oDacte:Say(0274, 0286, "PaМs:", oFont08)
				oDacte:Say(0274, 0328, AllTrim(cDesPais) + '  - Telefone: ' + Transform(AllTrim(cDesFone),"@r (999) 999999999"), oFont08)
		EndCase
	Next nCount

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё BOX: Expedidor / BOX: Recebedor                                        Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	oDacte:Box(0284, 0000, 0335, 0279)	//Expedidor
	oDacte:Box(0284, 0281, 0335, 0559)	//Recebedor

	If lExped .Or. Empty(cExpNome) 		
		oDacte:Say(0291, 0003, "EXPEDIDOR:", oFont08)
	Else
		oDacte:Say(0291, 0003, "LOCAL DE COLETA:", oFont08)
	EndIf
	oDacte:Say(0291, 0043, NoAcentoCte(Substr(cExpNome,1,45))    , oFont08N)

	//-- Sequencia de endereco preenchida, fica como local de entrega.
	
	If lSeqDes
		oDacte:Say(0291, 0286, "LOCAL DE ENTREGA:", oFont08)
		oDacte:Say(0291, 0342,  NoAcentoCte(Substr(cRecNome,1,45)), oFont08N)
	EndIf
	
	If lSeqRec
		oDacte:Say(0291, 0286, "RECEBEDOR:", oFont08)
		oDacte:Say(0291, 0328,  NoAcentoCte(Substr(cRecNome,1,45)), oFont08N)
	EndIf

	If !lSeqDes .And. !lSeqRec
		oDacte:Say(0291, 0286, "RECEBEDOR:", oFont08)
	EndIf

	For nCount := 1 To 5
		Do Case
			Case ( nCount == 1 )
				oDacte:Say(0300, 0003, "EndereГo:", oFont08)
				oDacte:Say(0300, 0043, IIf(!Empty(cExpEnd), AllTrim(cExpEnd) + ", " + cExpNro, " "), oFont08) 
				oDacte:Say(0300, 0286, "EndereГo:", oFont08)
				//-- Sequencia de endereco preenchida, fica como local de entrega.
				oDacte:Say(0300, 0328, IIf(lSeqDes .or. lSeqRec, AllTrim(cRecEnd) + ", " + cRecNro, " "), oFont08)
			Case ( nCount == 2 )
				oDacte:Say(0307, 0043, IIf(!Empty(cExpCompl), AllTrim(cExpCompl) + " - " + AllTrim(cExpBai), cExpBai), oFont08)
				oDacte:Say(0307, 0328, If(lSeqDes .or. lSeqRec, AllTrim(cValtoChar(FisGetEnd(cRecEnd)[4])) + " - " + AllTrim(cRecBai),""), oFont08)
			Case ( nCount == 3 )
				oDacte:Say(0314, 0003, "MunicМpio:", oFont08)
				oDacte:Say(0314, 0043, IIf(!Empty(cExpMun),  AllTrim(cExpMun) + ' - ' + AllTrim(cExpUF), " ")  + ' CEP.: ' + IIf(!Empty(cExpCEP), Transform(AllTrim(cExpCEP), "@r 99999-999"), ""), oFont08)
				oDacte:Say(0314, 0286, "MunicМpio:", oFont08)
				oDacte:Say(0314, 0328, If(lSeqDes .or. lSeqRec, AllTrim(cRecMun) + ' - ' + AllTrim(cRecUF),"") + ' CEP.: ' + IIf(!Empty(cRecCEP), Transform(AllTrim(cRecCEP), "@r 99999-999"), ""), oFont08)
			Case ( nCount == 4 )
				oDacte:Say(0321, 0003, "CNPJ/CPF:", oFont08)
				oDacte:Say(0321, 0043, IIf(!Empty(cExpCNPJ), Transform(AllTrim(cExpCNPJ), "@r 99.999.999/9999-99"), " ") + "   InscriГЦo Estadual: " +  AllTrim(cExpIE), oFont08)
				oDacte:Say(0321, 0286, "CNPJ/CPF:", oFont08)
				If lSeqDes .or. lSeqRec
					If lRecPJ
						oDacte:Say(0321, 0328, IIf(!Empty(cRecCGC), Transform(cRecCGC,"@r 99.999.999/9999-99"), " ") + "   InscriГЦo Estadual: " +  cRecINSCR, oFont08)
					Else
						oDacte:Say(0321, 0328, Transform(cRecCPF,"@r 999.999.999-99"), oFont08)
					EndIf
				Else
					oDacte:Say(0321, 0328, "", oFont08)
				EndIf

			Case ( nCount == 5 )
				If lExped .Or. Empty(cExpNome)
					oDacte:Say(0328, 0003, "PaМs:" , oFont08)
					oDacte:Say(0328, 0043, AllTrim(cExpPais) + ' Telefone: ' + IIf(!Empty(cExpFone), Transform(AllTrim(cExpFone),"@r (999) 999999999"), " "),  oFont08)
				EndIf
				If !lSeqDes
					oDacte:Say(0328, 0286, "PaМs:" , oFont08)
					oDacte:Say(0328, 0328, AllTrim(cRecPais) + ' Telefone: ' + IIf(!Empty(cRecFone), Transform(AllTrim(cRecFone),"@r (999) 999999999"), " "),  oFont08)
				EndIf
		EndCase
	Next nCount

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё BOX: Tomador do Servico                                                Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	oDacte:Box(0337, 0000, 0364, 0559)
	oDacte:Say(0344, 0003, "Tomador do ServiГo:", oFont08)
	oDacte:Say(0344, 0072, NoAcentoCte(SubStr(cDevNome,1,45)), oFont08)
	oDacte:Say(0344, 0328, "MunicМpio:", oFont08)
	oDacte:Say(0344, 0368, AllTrim(cDevMun) + ' - ' + AllTrim(cDevUF) + ' CEP.: ' + Transform(AllTrim(cDevCEP),"@r 99999-999"), oFont08)

	For nCount := 1 To 2
		Do Case
			Case ( nCount == 1 )
				oDacte:Say(0352, 0003, "EndereГo:", oFont08)
				oDacte:Say(0352, 0043, SubStr(AllTrim(cDevEnd),1,40) + ", " + cDevNro + " - "	+;
				                              AllTrim(cDevCompl) + " - " + AllTrim(cDevBair), oFont08)
				oDacte:Say(0352, 0328, "PaМs: ", oFont08)
				oDacte:Say(0352, 0368, AllTrim(cDevPais), oFont08)
			Case ( nCount == 2 )
				oDacte:Say(0360, 0003, "CNPJ/CPF:", oFont08)
				oDacte:Say(0360, 0043, Transform(AllTrim(cDevCNPJ),"@r 99.999.999/9999-99") + "   InscriГЦo Estadual: " + AllTrim(cDevIE), oFont08)
				oDacte:Say(0360, 0328, "Telefone:", oFont08)
				oDacte:Say(0360, 0368, Transform(AllTrim(cDevFone),"@r (999) 999999999"), oFont08)
		EndCase
	Next nCount


	TMSR31Cmp()
	TMSR31Comp()

	
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё BOX: PREVISцO DO FLUXO CARGA                                           Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	oDacte:Box(0561 , 0000, 0590, 0559)
	oDacte:Say(0568,  0245, "PrevisЦo do Fluxo de Carga", oFont08N)
	oDacte:Line(0569, 0000, 0569, 0559)	// Linha: Abaixo    
	oDacte:Say(0575,  0003, "Sigla ou CСdigo da Filial/Porto/EstaГЦo/Aeroporto de Origem", oFont07)
	oDacte:Say(0583,  0003, cOriUFPre, oFont07)
	oDacte:Say(0575,  0188, "Sigla ou CСdigo da Filial/Porto/EstaГЦo/Aeroporto de Passagem", oFont07)
	oDacte:Say(0575,  0374, "Sigla ou CСdigo da Filial/Porto/EstaГЦo/Aeroporto de Destino", oFont07)
	oDacte:Say(0583,  0374, cDesUFPre, oFont07)
	oDacte:Line(0569, 0186, 0590, 0186)	// Linha: Separadoras
	oDacte:Line(0569, 0372, 0590, 0372)	// Linha: Separadoras

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё BOX: OBSERVACOES GERAIS                                                Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	oDacte:Box(0592,  0000, 0643, 0559)	
	oDacte:Say(0598,  0258, "ObservaГУes Gerais", oFont08N)
	oDacte:Line(0600, 0000, 0600, 0559) // Linha: OBSERVACOES
    nCountObs := 5
	If cAmbiente== '2'
		cObsStat := "DOCUMENTO GERADO EM AMBIENTE DE HOMOLOGAгцO"
		nCountObs -= 1
		cTagObs := 'OBSGER1;'
	ElseIf cAmbiente == '10' //"7-ContingЙncia FS-DA"
		cObsStat := "DACTE em ContingЙncia - impresso em decorrЙncia de problemas tИcnicos"
		nCountObs -= 1
		cTagObs := 'OBSGER1;' 
	EndIf

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё BOX: OBSERVACOES                                                       Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	
	cG99Obs := " "
	If Type("oNfe:_CTE:_INFCTE:_IMP:_INFADFISCO:TEXT") == "U"
		cG99Obs := " "
	Else
		cG99Obs := oNfe:_CTE:_INFCTE:_IMP:_INFADFISCO:TEXT
	EndIf
	cObsProp := " "
	If Type("oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_VEIC:_PROP:_XNOME:TEXT") != "U" .And.;
		Type("oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_VEIC:_TPPROP:TEXT") != "U"
		If oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_VEIC:_TPPROP:TEXT == 'T'
			cObsProp += " Proprietario : " + AllTrim(oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_VEIC:_PROP:_XNOME:TEXT)			
		EndIf	
	EndIf
	cAUXObs := " "
	If Type("oNfe:_CTE:_INFCTE:_COMPL:_XOBS:TEXT") != "U"
		cAUXObs += oNfe:_CTE:_INFCTE:_COMPL:_XOBS:TEXT
	EndIf
	If Type("oNfe:_CTE:_INFCTE:_COMPL:_OBSCONT") == "A"
		aObsCont := {}
		For nX := 1 to len(oNfe:_CTE:_INFCTE:_COMPL:_OBSCONT)
			aAdd(aObsCont, oNfe:_CTE:_INFCTE:_COMPL:_OBSCONT[nX]:_XTEXTO:TEXT )
		Next nX
	ElseIf Type("oNfe:_CTE:_INFCTE:_COMPL:_OBSCONT:_XTEXTO:TEXT") == "U"
		aObsCont := {""}
	Else
		aObsCont := {oNfe:_CTE:_INFCTE:_COMPL:_OBSCONT:_XTEXTO:TEXT}
	EndIf
	
		
	cG99Obs3:= SubStr(cG99Obs,281,140)
	cG99Obs2:= SubStr(cG99Obs,141,140)
	cG99Obs := SubStr(cG99Obs,1,140)  
	
	cObsProp:= SubStr(cObsProp,1,140)
	cAUXObs3:= SubStr(cAUXObs,281,140)
	cAUXObs2:= SubStr(cAUXObs,141,140)
	cAUXObs := SubStr(cAUXObs,1,140)	
	
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Tratamento para aproveitar todo o espaco do quadro observacao          Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	if !Empty(cG99Obs)
	  nCountObs -= 1
	  cTagObs += 'OBSG991;' 
	EndIf
	
	if !Empty(cG99Obs2)
	  nCountObs -= 1
	  cTagObs += 'OBSG992;' 
	EndIf
	
	if !Empty(cAUXObs)
	  nCountObs -= 1
	  cTagObs += 'OBSAUX1;' 
	EndIf
	
	if !Empty(cObsProp)
	  nCountObs -= 1
	  cTagObs  += 'OBSPRO1;' 
	EndIf
	
	If (nCountObs > 0) .AND. (!Empty(cAUXObs2))
	  nCountObs -= 1
	  cTagObs += 'OBSAUX2;' 
	EndIf
	
	If (nCountObs > 0) .AND. (!Empty(cG99Obs3))
	  nCountObs -= 1
	  cTagObs += 'OBSG993;' 
	EndIf
	
	If (nCountObs > 0) .AND. (!Empty(cAUXObs3))
	  nCountObs -= 1
	  cTagObs += 'OBSAUX3;' 
	EndIf
	
	nLinhaObs := 0608
	if AT('OBSGER1;',cTagObs) > 0
	  oDacte:Say (nLinhaObs, 0003, cObsStat, oFont10N)
	  nLinhaObs += 8  
	End IF
	
	if AT('OBSG991;',cTagObs) > 0
	  oDacte:Say (nLinhaObs, 0003, cG99Obs, oFont07)
	  nLinhaObs += 8  
	End IF
	
	if AT('OBSG992;',cTagObs) > 0
	  oDacte:Say (nLinhaObs, 0003, cG99Obs2, oFont07)
	  nLinhaObs += 8  
	End IF
	
	if AT('OBSG993;',cTagObs) > 0
	  oDacte:Say (nLinhaObs, 0003, cG99Obs3, oFont07)
	  nLinhaObs += 8  
	End IF
	
	if AT('OBSAUX1;',cTagObs) > 0
	  oDacte:Say (nLinhaObs, 0003, cAUXObs, oFont07)
	  nLinhaObs += 8  
	End IF
	
	if AT('OBSAUX2;',cTagObs) > 0
	  oDacte:Say (nLinhaObs, 0003, cAUXObs2, oFont07)
	  nLinhaObs += 8  
	End IF
	
	if AT('OBSAUX3;',cTagObs) > 0
	  oDacte:Say (nLinhaObs, 0003, cAUXObs3, oFont07)
	  nLinhaObs += 8  
	End IF
	
	if AT('OBSPRO1;',cTagObs) > 0
	  oDacte:Say (nLinhaObs, 0003, cObsProp, oFont07)
	  nLinhaObs += 8  
	End IF		

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё BOX: INFORMACOES ESPECIFICAS DO MODAL                                  Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	
	oDacte:Box(0645, 0000, 0672, 0559)
	oDacte:Say(0651, 0210, "InformaГУes do Modal RodoviАrio", oFont08N)
	oDacte:Line(0654, 0000, 0652, 0559)
	oDacte:Say(0661, 0003, "RNTRC da Empresa: " + cTmsAntt	, oFont08)
	

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё BOX: USO EXCLUSIVO DO EMISSOR + RESERVADO AO FISCO                     Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	oDacte:Box(0674 , 0000, 0720, 0559)  
	oDacte:Say(0681 , 0090, "USO EXCLUSIVO DO EMISSOR DO CT-E", oFont08N)
	nSoma := 0
	For nX := 1 to len(aObsCont)
		If nX > 3
			Exit
		EndIf
		oDacte:Say(0690 + nSoma, 0003, aObsCont[nX], oFont08)
		nSoma += 10
	Next
	oDacte:Say(0681 , 0420, "RESERVADO AO FISCO", oFont08N)
	oDacte:Line(0683, 0000, 0683, 0559)	//Linha Horizontal
	oDacte:Line(0674, 0355, 0720, 0355)	//Linha Vertical

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Atualizar o Status de Impressao no CTe                                 Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	G99->(dbSetOrder(2))
	If	G99->(MsSeek(xFilial('G99')+(cAliasG99)->G99_SERIE+(cAliasG99)->G99_NUMDOC+(cAliasG99)->G99_TIPCTE))						
		//RecLock('G99',.F.)
		//G99->G99_FIMP := '1' //Grava Flag de Impressao
		//MsUnLock()
	EndIf
	oDacte:EndPage()

	//-- aDoc > 0, existe mais de uma pagina com Doc a ser impressa.
	//-- lPerig .T. existem produtos perigosos a serem impressos.
	If Len(aDoc) > 0 .Or. lPerig
		//-- Caso de mais de uma pagina, chama a funcao para montar as paginas seguites.
		TMSR35Cont(aDoc, aCab[nCont])
	EndIf
	(cAliasG99)->(DbSkip())
EndDo

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё TERMINO ROTINA DE IMPRESSAO                                            Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If lChvEmail
	oDacte:Preview()
Else
	If FILE(oDacte:cPathPDF+cNomeDacte+'.pdf')
		FERASE(oDacte:cPathPDF+cNomeDacte+'.pdf')
	EndIf 
	oDacte:Print()
EndIf

(cAliasG99)->(dbCloseArea())

Return(.T.)


/*/{Protheus.doc} ENCDACTE
//chama a funcao para montar as paginas seguites. 
@author osmar.junior
@since 24/10/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function TMSR35Cont(aDoc, aCab, aPerigo, nCnt)
Local oFont08     := TFont():New("Times New Roman",08,08,,.F.,,,,.T.,.F.)
Local oFont08N    := TFont():New("Times New Roman",08,08,,.T.,,,,.T.,.F.)
Local lControl    := .F.
Local nCount      := 0
Local aDoc1       := {}
Local cChaveA     := ''
Local cChaveB     := ''

Default nCnt		:= 1
Default aPerigo		:= {}
Default aDoc		:= {}
Default aCab		:= {}

oDacte:StartPage()
oDacte:SetPaperSize(Val(GetProfString(GetPrinterSession(),"PAPERSIZE","1",.T.)))

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Funcao responsavel pela montagem do cabecalho do DACTE                 Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
TMSR31Cab(aCab,.F.)

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё BOX: DOCUMENTOS ORIGINARIOS                                            Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
oDacte:Box(0224, 0000, 0593, 0559)							
oDacte:Say(0230, 0210, "Documentos OriginАrios", oFont08N)

oDacte:Line(0232, 0000, 0232, 0559) 	// Linha: DOCUMENTOS ORIGINARIOS
oDacte:Line(0232, 0280, 0593, 0280) // Linha: Separador DOCUMENTOS ORIGINARIOS
oDacte:Say( 0238, 0003, "Tp.Doc"            , oFont08N)
oDacte:Say( 0238, 0033, "CNPJ/CPF Emitente" , oFont08N)
oDacte:Say( 0238, 0163, "SИrie/Nr.Documento", oFont08N)
oDacte:Say( 0238, 0286, "Tp.Doc"            , oFont08N)
oDacte:Say( 0238, 0316, "CNPJ/CPF Emitente" , oFont08N)
oDacte:Say( 0238, 0448, "SИrie/Nr.Documento", oFont08N)
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Imprime as NF                                                          Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
lControl := .F.
nLInic := 0244
For nCount := 1 To Len(aDoc)
	lControl := !lControl
	
	If nCount < 75         
		If (lControl == .T.)			
			If Empty(aDoc[nCount,3])
				oDacte:Say(nLInic, 0003, aDoc[nCount,4],										oFont08)
				oDacte:Say(nLInic, 0033, Transform(aDoc[nCount,1],"@r 99.999.999/9999-99"),	oFont08)
				oDacte:Say(nLInic, 0163, aDoc[nCount,2],										oFont08)
			Else
				cChaveA     := aDoc[nCount,3]
				oDacte:Say(nLInic, 0003, "NF-E CHAVE:"	,oFont08)
				oDacte:Say(nLInic, 0073,aDoc[nCount,3],oFont08)
				cChaveA     := ''
			EndIf
			
		Else
			If Empty(aDoc[nCount,3])
				oDacte:Say(nLInic, 0286, aDoc[nCount,4],									    oFont08)
				oDacte:Say(nLInic, 0316, Transform(aDoc[nCount,1],"@r 99.999.999/9999-99"),	oFont08)
				oDacte:Say(nLInic, 0448, aDoc[nCount,2],										oFont08)
			Else
				cChaveB     := aDoc[nCount,3]
				oDacte:Say(nLInic, 0286, "NF-E CHAVE:"	,oFont08)
				oDacte:Say(nLInic, 0356, aDoc[nCount,3],oFont08)
				cChaveB     := ''
			EndIf
			nLInic += 0008
		EndIf		
	Else
		aAdd(aDoc1,{aDoc[nCount,1],;
		aDoc[nCount,2],;
		aDoc[nCount,3],;
		aDoc[nCount,4]})
	EndIf
	
Next nCount

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁImprime a ultima Chave.                                                 Ё
//ЁFORCAR A "QUEBRA" DA LINHA                                              Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If !Empty(cChaveA)
	nLInic += 0008
	oDacte:Say(nLInic, 0003, "NF-E CHAVE:",	oFont08)
	oDacte:Say(nLInic, 0073,cChaveA ,		oFont08)
	cChaveA := ''

	If !Empty(cChaveB)
		oDacte:Say(nLInic, 0286, "NF-E CHAVE:",	oFont08)
		oDacte:Say(nLInic, 0356, cChaveB,		oFont08)
		cChaveB := ''
	EndIf
EndIf

nSoma   := 1380


//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Linha de finalizacao.                                                  Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
oDacte:EndPage()

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Se existir mais doc para outra pagina, chama a mesma funcao.           Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If Len(aDoc1) > 1
	TMSR35Cont(aDoc1,aCab)
EndIf


Return


/*/{Protheus.doc} ENCDACTE
//Funcao responsavel por montar o cabecalho do relatorio  
@author osmar.junior
@since 24/10/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function TMSR31Cab(aCab, lImpCan, lXmlCont)
Local oFont07    := TFont():New("Times New Roman",07,07,,.F.,,,,.T.,.F.)	//Fonte Times New Roman 07
Local oFont07N   := TFont():New("Times New Roman",07,07,,.T.,,,,.T.,.F.)	//Fonte Times New Roman 08 Negrito
Local oFont08    := TFont():New("Times New Roman",08,08,,.F.,,,,.T.,.F.)	//Fonte Times New Roman 08
Local oFont08N   := TFont():New("Times New Roman",08,08,,.T.,,,,.T.,.F.)	//Fonte Times New Roman 08 Negrito
Local oFont10N   := TFont():New("Times New Roman",10,10,,.T.,,,,.T.,.F.)
Local cTpServ    := ''
Local cProtocolo := ''
Local cStartPath := GetSrvProfString("Startpath","")
Local cLogoTp	 := cStartPath + "logoCte" + cEmpAnt + ".BMP" //Insira o caminho do Logo da empresa logada, na variavel cLogoTp.
Local cQrCode    := ''
Local nPosSign   := 0
Local aAreaSA1  := SA1->(GetArea())
Local nFolhas		:= 1

Default lXmlCont := .F.
Default lImpCan  := .F.

If	IsSrvUnix() .And. GetRemoteType() == 1
	cLogoTp := StrTran(cLogoTp,"/","\")
Endif

If  !File(cLogoTp)
	cLogoTp    := cStartPath + "logoCte.bmp"
EndIf

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё BOX: CANHOTO - 0746                                                    Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If	lImpCan

	If (cAliasG99)->G99_TOMADO == '0' //REMETENTE
		SA1->(dbSeek(xFilial('SA1') + G99->G99_CLIREM + G99->G99_LOJREM))
	ElseIf (cAliasG99)->G99_TOMADO == '3' //DESTINATARIO
		SA1->(dbSeek(xFilial('SA1') + G99->G99_CLIDES + G99->G99_LOJDES))
	EndIf
	_cCgcDev := SA1->A1_CGC
	_cNomDev := SA1->A1_NOME
	_cMunDev := SA1->A1_MUN
	_cEstDev := SA1->A1_EST
	
	oDacte:Box(0020, 0000, 0082, 0559)
	oDacte:Say(026 , 0005, "TOMADOR: " + SPACE(05) +Transform(_cCgcDev, PesqPict("SA1","A1_CGC"))+ '  -  ' + SPACE(05) +;
	_cNomDev + '  -  ' + SPACE(05) + _cMunDev + '  -  '  + _cEstDev, oFont07N )
	
	oDacte:Line(0029, 0000, 0029, 0559) // Linha horizontal
	oDacte:Say(0036 , 0001, "DECLARO QUE RECEBI OS VOLUMES DESTE CONHECIMENTO EM PERFEITO ESTADO PELO QUE DOU POR CUMPRIDO O PRESENTE CONTRATO DE TRANSPORTE", oFont07)
	oDacte:Line(0039, 0000, 0039, 0559) // Linha horizontal
	
	oDacte:Line(0062, 0000, 0062, 0166) // Linha Horizontal: Separador NOME e RG
	oDacte:Line(0062, 0416, 0062, 0513) // Linha Horizontal: Separador CHEGADA e SAIDA
	
	oDacte:Line(0039, 0166, 0082, 0166) // Linha vertical
	oDacte:Line(0039, 0416, 0082, 0416) // Linha vertical
	oDacte:Line(0039, 0513, 0082, 0513) // Linha vertical
	
	oDacte:Say(0047 , 0005, "NOME"               	, oFont07N)
	oDacte:Say(0047 , 0421, "TИrmino Prest.Data/Hora"	, oFont07N)
	oDacte:Say(0047 , 0530, "CT-E"					, oFont07N)
	oDacte:Say(0057 , 0518, "No DOC. " , oFont07N)
	oDacte:Say(0067 , 0518, cValtoChar( Val(aCab[1]))	, oFont07N)
	oDacte:Say(0079 , 0518, "SиRIE: "+cValtoChar( Val(aCab[2]))	, oFont07N)
	oDacte:Say(0070 , 0005, "RG"                	, oFont07N)
	oDacte:Say(0079 , 0241, "ASSINATURA / CARIMBO"  , oFont07N)
	oDacte:Say(0070 , 0421, "InМcio Prest.Data/Hora"  	, oFont07N)
EndIf

oDacte:Box(0086, 0000, 0148, 0240)

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё BOX: Empresa + 0050                                                    Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
oDacte:SayBitmap(0088, 0005,cLogoTp,0088,0057 )		//Logo
oDacte:Say(0100, 0090, AllTrim(SM0->M0_NOMECOM),oFont08) 	//Nome Comercial
oDacte:Say(0110, 0090, 'CNPJ ' + Transform(AllTrim(SM0->M0_CGC),"@r 99.999.999/9999-99") + ' - IE ' + AllTrim(SM0->M0_INSC), oFont08)
oDacte:Say(0120, 0090, AllTrim(SM0->M0_ENDCOB) + ' ' + AllTrim(SM0->M0_BAIRCOB), oFont07)	//EndereГo + Bairro      
oDacte:Say(0130, 0090, AllTrim(SM0->M0_CIDCOB) + '  -  ' + AllTrim(SM0->M0_ESTCOB) + '  CEP.:  ' + AllTrim(SM0->M0_CEPCOB) ,oFont07)	//Cidade, UF, CEP
oDacte:Say(0140, 0090, AllTrim(SM0->M0_TEL)	,oFont07)	//Telefone

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё BOX: DACTE                                                             Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
oDacte:Box(0086, 0230, 0133, 0371)					
oDacte:Say(0093, 282, "DACTE", oFont10N)
oDacte:Say(0105, 231, "Documento Auxiliar do Conhecimento", oFont08N)
oDacte:Say(0116, 257, "de Transporte EletrТnico", oFont08N)

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё BOX: MODAL                                                             Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
oDacte:Box(0086, 0361, 0133, 0420)
oDacte:Say(0093, 375,"MODAL"     ,oFont08N)
If oNfe:_CTE:_INFCTE:_IDE:_modal:TEXT == "06" // do tipo MultiModal
	oDacte:Say(0116, 364,Upper("MULTIMODAL"),oFont08 ) 
Else
	oDacte:Say(0116, 364,Upper("RodoviАrio"),oFont08 ) 
EndIf

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё BOX: FOLHA
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
oDacte:Box(0086, 0420, 0133, 0444)
oDacte:Say(0093, 0423, "Folha"  , oFont08N)	//Folha
oDacte:Say(0116, 0425, AllTrim(Str(nFolhAtu)) + " / " + AllTrim(Str(nFolhas)), oFont08)
nFolhAtu ++

//зддддддддддддддддддддддддд
//ЁQRCODE Ё
//юддддддддддддддддддддддддд	
If Type( 'oNfe:_CTE:_INFCTESUPL:_QRCODCTE:TEXT' ) != 'U' .And. !Empty(oNFE:_CTE:_INFCTESUPL:_QRCODCTE:TEXT  )
	cQrCode := oNfe:_CTE:_INFCTESUPL:_QRCODCTE:TEXT
	If lXmlCont //Contingencia
		nPosSign := At("&sign", cQrCode)
		cQrCode := Substr(cQrCode, 1, nPosSign - 1)
	EndIf 
Else
	cQrCode := 'https://dfe-portal.svrs.rs.gov.br/cte/QRCode?chCTe=' + aCab[5] + '&tpAmb=2' 
EndIf

If oDacte:nDevice == 2
	oDacte:QRCODE(200, 446, cQrCode, 115)	// Spool
Else
	oDacte:QRCODE(200, 446, cQrCode, 50)	// PDF
EndIf


//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁBOX: Modelo / Serie / Numero / Emis                                     Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
oDacte:Box(0125, 0230, 0148, 0257)
oDacte:Say(0133, 0232, "Modelo", oFont07N)	//Modelo
oDacte:Say(0144, 0232, "57", oFont08)

oDacte:Box(0125, 0257, 0148 , 0276)
oDacte:Say(0133, 0259, "SИrie"  , oFont07N)	//Serie
oDacte:Say(0144, 0259, cValtoChar( Val(aCab[2]) ), oFont08)

oDacte:Box(0125, 0276, 0148, 0313)
oDacte:Say(0133, 0278, "NЗmero" , oFont07N)	//Numero
oDacte:Say(0144, 0278, cValtoChar( Val(aCab[1]) ), oFont08)

oDacte:Box(0125, 0313, 0148, 0383)
oDacte:Say(0133, 0315, "EmissЦo", oFont07N) //Emissao
oDacte:Say(0144, 0315, 	SubStr(AllTrim(aCab[3]), 7, 2) + '/'   +;
						SubStr(AllTrim(aCab[3]), 5, 2) + "/"   +; 
						SubStr(AllTrim(aCab[3]), 1, 4) + "-" +;
						SubStr(AllTrim(aCab[4]), 1, 2) + ":"   +;	
						SubStr(AllTrim(aCab[4]), 3, 2) + ":00")
oDacte:Box(0125, 0383, 0148, 0444)
If oDacte:nDevice == 2
	oDacte:Say(0133, 0385, "Ins.SUFRAMA Des"  , oFont07)	//Insc. SUFRAMA DestinatАrio
Else
	oDacte:Say(0133, 0385, "Ins.SUFRAMA Des"  , oFont07N)	//Insc. SUFRAMA DestinatАrio
EndIf

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё BOX: Controle do Fisco                                                 Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
oDacte:Box(0173, 0444, 0185, 0444)
oDacte:Code128C(171.4,265,(cAliasG99)->G99_CHVCTE, 24)	
oDacte:Say(0205, 0264, "Consulta em: http://www.cte-fazenda.gov.br/portal", oFont07)
	
oDacte:Line(0173, 0260, 0173, 0444)	//Linha Separadora
oDacte:Say( 0178, 0262,"Chave de acesso",oFont07)
If oDacte:nDevice == 2
	oDacte:Say( 0185, 0262, Transform(AllTrim(aCab[5]),"@r 9999999999999999 9999999999999999 999999999999"), oFont07)
Else 
	oDacte:Say( 0185, 0262, Transform(AllTrim(aCab[5]),"@r 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999"), oFont07)
EndIf

oDacte:Line(0186, 0260, 0186, 0444 )	//Linha Separadora 
oDacte:Line(0209, 0260, 0209, 0559 )	//Linha Separadora
oDacte:Say(0214,  0262, "Protocolo de AutorizaГЦo de uso", oFont07)
oDacte:Line(0217, 0260, 0217, 0559 )	//Linha Separadora

oDacte:Line(0148, 0444, 0209, 0444 )	//Linha Vertical
oDacte:Line(0209, 0559, 0217, 0559 )	//Linha Vertical

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё  BOX: Tipo do CTe                                                      Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
oDacte:Box(0148, 0000, 0170, 0260) 
oDacte:Say(0157, 0003, "Tipo do CT-e"   , oFont08N)
oDacte:Say(0157, 0143, "Tipo de ServiГo", oFont08N)

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё  BOX: Tipo do CTe  Globalizado                                         Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
oDacte:Box(0170, 0000, 0195, 0260)
oDacte:Say(0180, 0003, "Indicador CT-e Globalizado"  , oFont08N)

If Type("oNfe:_CTE:_INFCTE:_IDE:_INDGLOBALIZADO:Text") == "C" .And. AllTrim(oNfe:_CTE:_INFCTE:_IDE:_INDGLOBALIZADO:Text) == "1"
	oDacte:Say(0190, 0003, "Sim"  , oFont08N)
Else
	oDacte:Say(0190, 0003, "NЦo"  , oFont08N)
EndIf

oDacte:Say(0180, 0143, "InformaГУes CT-e Globalizado", oFont08N)
oDacte:Line(0148,0140, 0195, 0140)  //Linha Vertical Tipo CT-e / Inf. CT-e Globalizado

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Tipo de Conhecimento                                            Ё
//Ё 0 - Normal                                                      Ё
//Ё 1 - Complemento de Valores                                      Ё
//Ё 2 - Emitido em Hipotese de anulacao de Debito                   Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If ( AllTrim((cAliasG99)->G99_TIPCTE) == "1" )
	oDacte:Say(0167,  0003, "COMPLEMENTO"	, oFont08)
ElseIf ( AllTrim((cAliasG99)->G99_TIPCTE) == "3" )
	oDacte:Say(0167,  0003, "SUBSTITUTO"		, oFont08)	
ElseIf ( AllTrim((cAliasG99)->G99_TIPCTE) == "2" )
	oDacte:Say(0167,  0003, "ANULACAO"		, oFont08)
Else
	oDacte:Say(0167,  0003, "NORMAL"		, oFont08)
EndIf

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Tipo de Servico                                                 Ё
//Ё 0 - Normal                                                      Ё
//Ё 1 - SubContratacao                                              Ё
//Ё 2 - Redespacho                                                  Ё
//Ё 3 - Redespacho Intermediario                                    Ё
//Ё 4 - ServiГo Vinculado a Multimodal                              Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё  - Notas Fiscais:           Ё
//Ё   0 - Normal                                                    Ё
//Ё   1 - Devolucao                                                 Ё
//Ё   2 - SubContratacao                                            Ё
//Ё   3 - Dcto Nao Fiscal                                           Ё
//Ё   4 - Exportacao                                                Ё
//Ё   5 - Redespacho                                                Ё
//Ё   6 - Dcto Nao Fiscal 1                                         Ё
//Ё   7 - Dcto Nao Fiscal 2                                         Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
cTpServ := oNfe:_CTE:_INFCTE:_IDE:_tpserv:TEXT

If (cTpServ $ '0')
	oDacte:Say(0167, 0145, "NORMAL"				, oFont08)
ElseIf (cTpServ == '1')
	oDacte:Say(0167, 0145, "SUBCONTRATAгцO"		, oFont08)
ElseIf (cTpServ == '2')
	oDacte:Say(0167, 0145, "REDESPACHO"			, oFont08)
ElseIf (cTpServ == '3')
	oDacte:Say(0167, 0145, "REDESPACHO INTERM"			, oFont08)	//--Redespacho IntermediАrio
ElseIf (cTpServ == '4')
	oDacte:Say(0167, 0145, "SERV.VINC.MULTIMODAL"			, oFont08)	//--ServiГo vinculado Multimodal
Else
	oDacte:Say(0167, 0145, "NORMAL"				, oFont08)
EndIf

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Numero Protocolo + Data e Hora Autorizacao                      Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддadminы
cProtocolo := aCab[6] + " " + aCab[8] + " " + aCab[9]
oDacte:Say(0214,  0380, cProtocolo, oFont08)

RestArea(aAreaSA1)

Return

/*/{Protheus.doc} ENCDACTE
//ЁFuncao responsavel por montar o BOX com as informacoes do componentes do frete e impostos 
@author osmar.junior
@since 24/10/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/

Static Function TMSR31Comp()
Local cLabel      	:= ''
Local nCInic      	:= 0			// Coluna Inicial
Local oFont08     	:= TFont():New("Times New Roman",08,08,,.F.,,,,.T.,.F.)
Local oFont08N    	:= TFont():New("Times New Roman",08,08,,.T.,,,,.T.,.F.)
Local oFont10N    	:= TFont():New("Times New Roman",10,10,,.T.,,,,.T.,.F.)
Local lControl    	:= .F.
Local nCount      	:= 0
Local nCount_2    	:= 0
Local cSitTriba		:= "Sit Trib"
Local cBaseIcms		:= ''			//-- Base de Calculo
Local cAliqIcms		:= ''			//-- Aliquota ICMS
Local cValIcms		:= ''			//-- Valor ICMS
Local cRedBcCalc	:= ''			//-- "Red.Bc.Calc."
Local nCount_3		:= 0
Local aComp			:= {}

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё BOX: COMPONENTES DA PRESTACAO                                          Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If lComp
	nLInic	:= 0474
	nLFim	:= 0532	
Else
	nLInic	:= 0414
	nLFim	:= 0472	
EndIf

oDacte:Box(nLInic, 0000, nLFim, 0559)

nLInic	+= 0008
oDacte:Say(nLInic, 0210, "Componentes do Valor da PrestaГЦo de ServiГo", oFont08N)
	
nLInic	+= 0004
	
oDacte:Line(nLInic, 0000, nLInic, 0559) // Linha: Componentes da Prestacao
oDacte:Line(nLInic, 0140, nLFim, 0140) // Linha: Separador Vertical
oDacte:Line(nLInic, 0280, nLFim, 0280) // Linha: Separador Vertical
oDacte:Line(nLInic, 0420, nLFim, 0420) // Linha: Separador Vertical
	
nLInic	+= 0006
oDacte:Say(nLInic, 0003, "Nome",	oFont08N)
oDacte:Say(nLInic, 0073, "Valor",	oFont08N)
oDacte:Say(nLInic, 0143, "Nome",	oFont08N)
oDacte:Say(nLInic, 0213, "Valor",	oFont08N)
oDacte:Say(nLInic, 0283, "Nome",	oFont08N)
oDacte:Say(nLInic, 0353, "Valor",	oFont08N)
oDacte:Say(nLInic, 0423, "Valor Total da PrestaГЦo do ServiГo", oFont08N)
	
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Componentes do Valor da Prestacao de Servico                           Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁDT8 - Componentes do Frete                                              Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
nLInic		+= 0008
nCInic		:= 0003
lControl	:= .F.

	aComp := TMSGetComp( oNfe )
		
	For nCount_3 := 1 To Len( aComp )
		nCount += 2
		oDacte:Say(nLInic, nCInic, Substr(AllTrim(aComp[nCount_3][1]),1,14), oFont08)	//Descricao do Componente
		nCInic += 0070	//Proxima Coluna

		oDacte:Say(nLInic, nCInic, Transform(Val(AllTrim(aComp[nCount_3][2])),'@E 999,999,999.99'), oFont08)	//Valor do Componente
		nCInic += 0070	//Proxima Coluna


		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё FORCAR A "QUEBRA" DA LINHA, SENDO 6 CAMPOS POR LINHA.                  Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		If ( (mod(nCount,6)) == 0 )
			nCount_2 += 1
			Do Case
				Case ( nCount_2 == 1 )
				cLabel := PadL(Transform(Val(oNFE:_CTE:_INFCTE:_VPREST:_VTPREST:TEXT),'@E 999,999,999.99'),20)
				Case ( nCount_2 == 2 )
				cLabel := ""
				Case ( nCount_2 == 3 )
					oDacte :Line(nLInic - 8, 0420, nLInic - 8, 0559) // Linha: VALOR A RECEBER
					cLabel := "Valor a Receber"
				Case ( nCount_2 == 4 )
					cLabel := PadL(Transform(Val(oNFE:_CTE:_INFCTE:_VPREST:_VREC:TEXT),'@E 999,999,999.99'),20)
			EndCase
				
			oDacte:Say(nLInic + 4 , 0423, cLabel, oFont10N)
			nLInic   += 0008
			nCInic   := 0003
		EndIf
	Next nCount_3
	For nCount := (1 + nCount) To 24
		lControl := !lControl
		nCInic   += 0070
		cLabel   := ""
		
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё FORCAR A "QUEBRA" DA LINHA, SENDO 6 CAMPOS POR LINHA.                  Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		If ( (mod(nCount,6)) == 0 )
			nCount_2 += 1
			Do Case
				Case ( nCount_2 == 1 )
					cLabel := PadL(Transform(Val(oNFE:_CTE:_INFCTE:_VPREST:_VTPREST:TEXT),'@E 999,999,999.99'),20)
				Case ( nCount_2 == 2 )
					cLabel := ""
				Case ( nCount_2 == 3 )
					oDacte :Line(nLInic - 8, 0420, nLInic - 8, 0559) // Linha: VALOR A RECEBER
					cLabel := "Valor a Receber"
				Case ( nCount_2 == 4 )
					cLabel := PadL(Transform(Val(oNFE:_CTE:_INFCTE:_VPREST:_VREC:TEXT),'@E 999,999,999.99'),20)
			EndCase
			
			oDacte:Say(nLInic, 0423, cLabel, oFont10N)
			nLInic   += 0008
			nCInic   := 0003
		EndIf
	Next nCount

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё BOX: INFORMACOES RELATIVAS AO IMPOSTO                                  Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

If !lComp
	nLInic	:= 0474
	nLFim	:= 0500	
Else
	nLInic	:= 0534
	nLFim	:= 0560
EndIf

oDacte:Box(nLInic , 0000, nLFim, 0559)

nLInic += 0006
oDacte:Say(nLInic , 0212, "InformaГУes Relativas ao Imposto", oFont08N)

nLInic += 0002
oDacte:Line(nLInic, 0000, nLInic, 0559)	// Linha:
oDacte:Line(nLInic, 0240, nLFim, 0240)	// Linha: Separador Situacao Trib	/ Base de Calculo
oDacte:Line(nLInic, 0350, nLFim, 0350) 	// Linha: Separador Base de Calculo	/ Aliq.ICMS
oDacte:Line(nLInic, 0400, nLFim, 0400) 	// Linha: Separador Aliq.ICMS    	/ Valor ICMS
oDacte:Line(nLInic, 0470, nLFim, 0470) 	// Linha: Separador Valor ICMS    	/ %Red Bc.Calc

nLInic += 0008
oDacte:Say(nLInic , 0003, "ClassificaГЦo TributАria", oFont08N)   // Label: ClassificaГЦo TributАria
oDacte:Say(nLInic , 0243, "Base de CАlculo"    , oFont08N)   // Label: Base de CАlculo
oDacte:Say(nLInic , 0353, "Aliq. ICMS"         , oFont08N)   // Label: Aliq.ICMS
oDacte:Say(nLInic , 0403, "Valor ICMS"         , oFont08N)   // Label: Valor ICMS
oDacte:Say(nLInic , 0473, "%Red. Bc. Calc."    , oFont08N)   // Label: %Red.Bc.Calc.

	/*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	  Ё Tag <ICMS00>                                                    Ё
	  юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
	If !Type("oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_CST:TEXT")=="U"

		cAliasD2  := DataSource( 'DESCRSUBSTTRIBUTARIA' )
		
		cSitTriba	:= Iif( Type("oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_CST:TEXT")=="U"," ",;
		oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_CST:TEXT + " - " + SubStr(AllTrim((cAliasD2)->X5_DESCRI),1,40) )

		cBaseIcms	:= Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_VBC:TEXT)
		cAliqIcms	:= Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_PICMS:TEXT)
		cValIcms	:= Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_VICMS:TEXT)
		
		(cAliasD2)->(DbCloseArea())
	/*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	  Ё Tag <ICMS45>                                                    Ё
	  юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
	ElseIf !Type("oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS45:_CST:TEXT") == "U"

		cAliasD2  := DataSource( 'DESCRSUBSTTRIBUTARIA' )

		cSitTriba	:= Iif( Type("oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS45:_CST:TEXT")=="U"," ",;
		oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS45:_CST:TEXT + " - " + SubStr(AllTrim((cAliasD2)->X5_DESCRI),1,40) )
		
		(cAliasD2)->(DbCloseArea()) 
	/*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	  Ё Tag <ICMS90>                                                    Ё
	  юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
	ElseIf !Type("oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS90:_CST:TEXT") == "U"

		cAliasD2  := DataSource( 'DESCRSUBSTTRIBUTARIA' )

		cSitTriba	:= Iif( Type("oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS90:_CST:TEXT")=="U"," ",;
		oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS90:_CST:TEXT + " - " + SubStr(AllTrim((cAliasD2)->X5_DESCRI),1,40) )

		cBaseIcms	:= Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS90:_VBC:TEXT)
	   	cAliqIcms	:= Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS90:_PICMS:TEXT)
		cValIcms	:= Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS90:_VICMS:TEXT)
		cRedBcCalc := Val(Iif( Type("oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS90:_pRedBC:TEXT")=="U"," ",(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS90:_pRedBC:TEXT) ))
		
		(cAliasD2)->(DbCloseArea())
	/*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	  Ё Tag <ICMS20>                                                    Ё
	  юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
	ElseIf !Type("oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS20:_CST:TEXT") == "U"

		cAliasD2  := DataSource( 'DESCRSUBSTTRIBUTARIA' )

		cSitTriba	:= Iif( Type("oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS20:_CST:TEXT")=="U"," ",;
		oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS20:_CST:TEXT + " - " + SubStr(AllTrim((cAliasD2)->X5_DESCRI),1,40) )

		cBaseIcms	:= Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS20:_VBC:TEXT)
		cAliqIcms	:= Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS20:_PICMS:TEXT)
		cValIcms	:= Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS20:_VICMS:TEXT)
		cRedBcCalc := Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS20:_pRedBC:TEXT)
		
		(cAliasD2)->(DbCloseArea())
	/*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	  Ё Tag <ICMS60>                                                    Ё
	  юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
	ElseIf !Type("oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS60:_CST:TEXT") == "U"

		cAliasD2  := DataSource( 'DESCRSUBSTTRIBUTARIA' )

		cSitTriba	:= Iif( Type("oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS60:_CST:TEXT")=="U"," ",;
		oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS60:_CST:TEXT + " - " + SubStr(AllTrim((cAliasD2)->X5_DESCRI),1,40) )

		cBaseIcms	:= Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS60:_VBCSTRET:TEXT)
		
		cValIcms	:= Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS60:_VICMSSTRET:TEXT)
		cAliqIcms	:= Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS60:_PICMSSTRET:TEXT)
		
		(cAliasD2)->(DbCloseArea())
	ElseIf !Type("oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMSOutraUF:_CST:TEXT") == "U"

		cAliasD2  := DataSource( 'DESCRSUBSTTRIBUTARIA' )

		cSitTriba	:= Iif( Type("oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMSOutraUF:_CST:TEXT")=="U"," ",;
		oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMSOutraUF:_CST:TEXT + " - " + SubStr(AllTrim((cAliasD2)->X5_DESCRI),1,40) )

	   	cAliqIcms	:= Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMSOutraUF:_PICMSOUTRAUF:TEXT)
		cBaseIcms	:= Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMSOutraUF:_VBCOUTRAUF:TEXT)
		cValIcms   := Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMSOutraUF:_VICMSOUTRAUF:TEXT)
		
		
		(cAliasD2)->(DbCloseArea())
	/*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	  Ё Tag <ICMSSN> Simples Nacional                                   Ё
	  юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/	
	ElseIf !Type("oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMSSN:_indSN:TEXT")=="U"		
		cSitTriba	:= Iif( Type("oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMSSN:_indSN:TEXT")=="U"," "," Simples Nacional ")		
	EndIf	

nLInic += 0008
oDacte:Say(nLInic , 0003, cSitTriba,								oFont08)
oDacte:Say(nLInic , 0243, Transform(cBaseIcms , '@E 999,999,999.99'),	oFont08)
oDacte:Say(nLInic , 0353, Transform(cAliqIcms , '@E 999,999,999.99'),	oFont08)
oDacte:Say(nLInic , 0403, Transform(cValIcms  , '@E 999,999,999.99'),	oFont08)
oDacte:Say(nLInic , 0473, Transform(cRedBcCalc, '@E 999,999,999.99'),	oFont08)

lComp := .F. //CTE Complementar

Return

/*/{Protheus.doc} ENCDACTE
//Funcao responsavel por montar o BOX relativo as informacoes dos componentes e valores complementados
@author osmar.junior
@since 24/10/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function TMSR31Cmp()

Local nCount    := 0
Local nCount_2  := 0
Local oFont08   := TFont():New("Times New Roman",08,08,,.F.,,,,.T.,.F.)
Local oFont08N  := TFont():New("Times New Roman",08,08,,.T.,,,,.T.,.F.)
Local lControl  := .F.
Local cAliasChv := ''

lComp := .T.	//CTE Complementar

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё BOX: COMPONENTES DO VALOR DA PRESTACAO DO SERVICO                      Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
nLInic  := 0400
nLFim   := 0506
oDacte:Box(nLInic , 0000, nLFim, 0559)

nLInic += 0006
oDacte:Say(nLInic , 0210, "Componentes do Valor da PrestaГЦo do ServiГo", oFont08N)

nLInic += 0002
oDacte:Line(nLInic, 0000, nLInic, 0559)		// Linha: DOCUMENTOS ORIGINARIOS       
oDacte:Line(nLInic, 0279, nLFim , 0279)	// Linha: Separador DOCUMENTOS ORIGINARIOS

nLInic += 0007
oDacte:Say(nLInic , 0003, "Chave do CT-e Complementado", oFont08N)
oDacte:Say(nLInic , 0205, "Valor Complementado", oFont08N)
oDacte:Say(nLInic , 0281, "Chave do CT-e Complementado", oFont08N)
oDacte:Say(nLInic , 0483, "Valor Complementado", oFont08N)

nLInic   += 0008
nCount   := 0
nCount_2 := 0
lControl := .F.

//-- Query para pesquisar a chave do CTE original
cAliasChv :=  GetNextAlias()
cQuery := ''
cQuery += " SELECT G99_CHVCTE,G99_COMPVL " +CRLF
cQuery += "   FROM " + RetSqlName('G99') + " G99 " +CRLF
cQuery += "  WHERE G99_FILIAL = '" + xFilial('G99') + "'" +CRLF
cQuery += "    AND G99_CHVANT    = '" + (cAliasG99)->G99_CHVCTE + "'" +CRLF
cQuery += "    AND G99_COMPLM  = 'C'" +CRLF
cQuery += "    AND D_E_L_E_T_ = ' '"
cQuery := ChangeQuery(cQuery)
DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasChv, .F., .T.)

nCount   := 0
While !(cAliasChv)->(Eof())

	nCount   += 1
	lControl := !lControl

	If nCount < 9

		If (lControl == .T.)
			oDacte:Say(nLInic, 0003, Transform(AllTrim((cAliasChv)->G99_CHVCTE),"@!")	, oFont08)
			oDacte:Say(nLInic, 0205, PadL(Transform((cAliasChv)->G99_COMPVL,'@E 9,999,999.9999'),20), oFont08)
		Else
			oDacte:Say(nLInic, 0281, Transform(AllTrim((cAliasChv)->G99_CHVCTE),"@!")	, oFont08)
		EndIf

	EndIf

	(cAliasChv)->(DbSkip())

EndDo

(cAliasChv)->(dbCloseArea())

Return

/*/{Protheus.doc} ENCDACTE
//Retorna um Array com a estrutura do campo complemento rel.  ao objeto passado por parametro 
@author osmar.junior
@since 24/10/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function TMSGetComp( oObject )
Local i			:= 0		// Auxiliar no Incremento da Estrutura de Laco
Local aAuxClone	:= { }		// Copia da propriedade Comp do Objeto passado por parametro
Local aAuxComp	:= { }		// Auxiliar no processamento de aAuxClone
Local aResult	:= { }		// Retorno da Funcao
 If Valtype(XmlChildEx(oObject:_CTE:_INFCTE:_VPREST,"_COMP")) <> "U"
	If	ValType(oObject:_CTE:_INFCTE:_VPREST:_COMP) == "A"
		aAuxClone := ACLONE( oObject:_CTE:_INFCTE:_VPREST:_COMP )
		For i := 1 To Len( aAuxClone )
			AADD( aResult, {AllTrim(aAuxClone[ i ]:_XNOME:TEXT), AllTrim(aAuxClone[ i ]:_VCOMP:TEXT)} )
		Next i
	ElseIf	ValType(oObject:_CTE:_INFCTE:_VPREST:_COMP) == "O"
		AADD( aAuxComp, AllTrim(oObject:_CTE:_INFCTE:_VPREST:_COMP:_XNOME:TEXT) )
		AADD( aAuxComp, AllTrim(oObject:_CTE:_INFCTE:_VPREST:_COMP:_VCOMP:TEXT) )
		AADD( aResult, aAuxComp )
		aAuxComp := {}
	EndIf
 EndIf
Return ( aResult )


/*/{Protheus.doc} ENCDACTE
//chama a funcao para montar aa area de trabalho (tabela). 
@author osmar.junior
@since 24/10/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function DataSource( cSource )
Local cNewArea	:= GetNextAlias()
Local cQuery	:= ""

cQuery := GetSQL( cSource )
DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cNewArea, .F., .T.)

Return ( cNewArea )

/*/{Protheus.doc} ENCDACTE
//retorna query de acordo com o tipo (source). 
@author osmar.junior
@since 24/10/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function GetSQL( cSource )
Local cQuery	:= ""
Local cSitTriba	:= ""
// Verifica se existe filtro por lote especifico


If	cSource == 'G99'
	cQuery += "   SELECT " + CRLF
	cQuery += "   G99_FILIAL,      " +CRLF
	cQuery += "   G99_CODIGO,      " +CRLF
	cQuery += "   G99_CLIREM,      " +CRLF
	cQuery += "   G99_LOJREM,      " +CRLF
	cQuery += "   G99_CLIDES,      " +CRLF
	cQuery += "   G99_LOJDES,      " +CRLF
	cQuery += "   G99_TOMADO,      " +CRLF
	cQuery += "   G99_CODEMI,      " +CRLF
	cQuery += "   G99_CODREC,      " +CRLF
	cQuery += "   G99_CODPRO,      " +CRLF
	cQuery += "   G99_TABFRE,      " +CRLF
	cQuery += "   G99_TS,          " +CRLF
	cQuery += "   G99_CFOP,        " +CRLF
	cQuery += "   G99_PESO,        " +CRLF
	cQuery += "   G99_PESCUB,      " +CRLF	
	cQuery += "   G99_METRO3,      " +CRLF
	cQuery += "   G99_QTDVO,      " +CRLF
	cQuery += "   G99_KMFRET,      " +CRLF
	cQuery += "   G99_VALOR,       " +CRLF
	cQuery += "   G99_DTPREV,      " +CRLF
	cQuery += "   G99_HRPREV,      " +CRLF
	cQuery += "   G99_SERIE,       " +CRLF
	cQuery += "   G99_NUMDOC,      " +CRLF
	cQuery += "   G99_TIPCTE,      " +CRLF
	cQuery += "   G99_CHVCTE,      " +CRLF
	cQuery += "   G99_CHVSUB,      " +CRLF
	cQuery += "   G99_CHVANU,      " +CRLF
	cQuery += "   G99_DTEMIS,      " +CRLF
	cQuery += "   G99_HREMIS,      " +CRLF	
	cQuery += "   G99_STAENC,      " +CRLF
	cQuery += "   G99_STATRA,      " +CRLF
	cQuery += "   G99_TIPSER,      " +CRLF
	cQuery += "   G99_TPIMPR,      " +CRLF
	cQuery += "   G99_TPEMIS,      " +CRLF
	cQuery += "   G99_USUINC,      " +CRLF
	cQuery += "   G99_USUENC,      " +CRLF
	cQuery += "   G99_OBSERV,      " +CRLF
	cQuery += "   G99_PROTCA,      " +CRLF
	cQuery += "   G99_PROTOC,      " +CRLF
	cQuery += "   G99_CHVANT,      " +CRLF
	cQuery += "   G99_CHVFIS,      " +CRLF	
	cQuery += "   G99_COMPLM,      " +CRLF
	cQuery += "   G99_COMPVL,      " +CRLF
	cQuery += "   G99_NUMFCH      " +CRLF	
	cQuery += "   FROM " + RetSqlName('G99') +CRLF
	cQuery += "   WHERE G99_FILIAL  = '" + xFilial('G99') + "'" + CRLF	
	cQuery += "    AND G99_NUMDOC    = '" + G99->G99_NUMDOC + "'" + CRLF
	cQuery += "    AND G99_SERIE  = '" + G99->G99_SERIE + "'" + CRLF
	cQuery += "    AND D_E_L_E_T_  = ' ' " + CRLF	

ElseIf cSource == 'DESCRSUBSTTRIBUTARIA'

	cQuery := " SELECT SX5.X5_DESCRI"
	cQuery += " FROM " + RetSqlName("SX5") + " SX5 "
	cQuery += " WHERE SX5.X5_FILIAL ='"  + xFilial("SX5") + "'"
	cQuery += "   AND SX5.X5_TABELA ='S2'"

	If !Type("oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_CST:TEXT")=="U"
		cSitTriba := Iif( Type("oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_CST:TEXT")=="U"," ",;
		oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_CST:TEXT)
	ElseIf !Type("oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS45:_CST:TEXT")=="U"
		cSitTriba := Iif( Type("oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS45:_CST:TEXT")=="U"," ",;
		oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS45:_CST:TEXT)
	ElseIf !Type("oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS90:_CST:TEXT")=="U"
		cSitTriba := Iif( Type("oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS90:_CST:TEXT")=="U"," ",;
		oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS90:_CST:TEXT)
	ElseIf !Type("oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS20:_CST:TEXT")=="U"
		cSitTriba := Iif( Type("oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS20:_CST:TEXT")=="U"," ",;
		oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS20:_CST:TEXT)
	ElseIf !Type("oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS60:_CST:TEXT")=="U"
		cSitTriba := Iif( Type("oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS60:_CST:TEXT")=="U"," ",;
		oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS60:_CST:TEXT)
	ElseIf !Type("oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMSOutraUF:_CST:TEXT")=="U"
		cSitTriba := Iif( Type("oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMSOutraUF:_CST:TEXT")=="U"," ",;
		oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMSOutraUF:_CST:TEXT)
	EndIf

	cQuery += " AND SX5.X5_CHAVE  ='" +cSitTriba+ "'"
	cQuery += " AND SX5.D_E_L_E_T_<>'*'"

EndIf

cQuery := ChangeQuery( cQuery )

Return ( cQuery )
