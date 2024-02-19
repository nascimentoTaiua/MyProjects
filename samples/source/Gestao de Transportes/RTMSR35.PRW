#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"

#DEFINE VBOX      080
#DEFINE VSPACE    008 
#DEFINE HSPACE    010
#DEFINE SAYVSPACE 008
#DEFINE SAYHSPACE 008
#DEFINE HMARGEM   030
#DEFINE VMARGEM   030
#DEFINE MAXITEM   Max((022-Max(0,Len(aMensagem)-02)),1)
#DEFINE MAXITEMP2 055
#DEFINE MAXMENLIN 070

#DEFINE doDTC_SERNFC	1
#DEFINE doDTC_NUMNFC	2
#DEFINE doDTC_EMINFC	3
#DEFINE doDTC_VALOR		4
#DEFINE doDTC_PESO		5
#DEFINE doDTC_CLIDEV	6
#DEFINE doDTC_LOJDEV	7
#DEFINE doDTC_NFEID		8
#DEFINE doDTC_CTEID		9

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³RTMSR35   ³ Autor ³Felipe Barbiere        ³ Data ³19/01/17  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Funcao responsavel por imprimir o DACTE.                    ³±±
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
User Function RTMSR35()
Local nCount		:= 0
Local nSoma			:= 0
Local nCInic		:= 0	// Coluna Inicial
Local cChaveA		:= ''
Local cChaveB		:= ''
Local cTmsAntt		:= SuperGetMv( "MV_TMSANTT", .F., .F. )	//Numero do registro na ANTT com 14 dígitos
Local cTmsCOTM		:= SuperGetMv( "MV_TMSCOTM", .F., .F. )	//Numero do registro da OTM
Local aCab			:= {}
Local aDoc			:= {}
Local oFont07		:= TFont():New("Times New Roman",07,07,,.F.,,,,.T.,.F.)
Local oFont08		:= TFont():New("Times New Roman",08,08,,.F.,,,,.T.,.F.)
Local oFont08N		:= TFont():New("Times New Roman",08,08,,.T.,,,,.T.,.F.)
Local oFont10N		:= TFont():New("Times New Roman",10,10,,.T.,,,,.T.,.F.)
Local lControl		:= .F.
Local cAliasInfNF	:= ''
Local cPerg			:= 'RTMSR25'
Local nCont			:= 0
Local lSeqDes		:= .F.
Local lSeqRec		:= .F.
Local cDT6Obs		:= ''
Local cDT6Obs2		:= ''
Local cDT6Obs3		:= '' 
Local cDTCObs		:= ''
Local aDTCObserv	:= {"","","","","","","",""} //--Linha da Observação proveniente da tabela DTC
Local nCountDTC		:= 0
Local cObsProp		:= ''
Local cObsStat		:= ''
Local nCountObs		:= 0
Local nLinhaObs  	:= 0
Local aObsCont		:= ''
Local cCtrDpc		:= ''
Local cSerDpc		:= ''
Local cCTEDocAnt	:= ''
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
Local cPPCarga	:= ""
Local cPPVlTot	:= ""
Local cPPPesoB	:= ""
Local cPPPeso3	:= ""
Local cPPMetro3	:= ""
Local cPPQtdVol	:= ""
Local cPesoBC   := ""

//-- Documentos Originarios
Local aDocOri		:= {}
//Lotação
Local cDesDocAnt	:= ""
Local cAliasPeri	:= ""
Local lPerig		:= .F.	//-- Informa se ha produtos perigosos
Local cStartPath
Local cTipoDoc		:= ''
Local cTagObs		:= ''
Local lTMSDACTE     := ExistBlock("TMSDACTE",,.T.)
Local lXmlCont      := .F.
Local nLinIEM		:= 0 //-- valor de ajuste de salto pra as linhas relacionadas a Informações do Modal Rodoviário
Local cEndCom		:= ""
Local cChaveCTe		:= ""

Local cDestPDF 	    := ''
Local cFilDoc		:= ''
Local cDoc		    := ''
Local cSerie		:= ''
Local cChave		:= ''
Local lExibePerg    := .T.

//-- Variaveis Private
Private cAliasCT	:= GetNextAlias()
Private oDacte
Private oNfe
Private nLInic		:= 0	// Linha Inicial
Private nLFim		:= 0	// Linha Inicial
Private nDifEsq		:= 0	// Variavel com Diferenca para alinhar os Print da Esquerda com os da Direita
Private cInsRemOpc	:= ''	// Remetente com sequencia de IE
Private nFolhas		:= 1
Private nFolhAtu	:= 1
Private PixelX		:= nil
Private PixelY		:= nil
Private nMM			:= 0
Private lComp		:= .F.	//CTE Complementar
Private cVersaoCTE	:= ""
Private lUsaColab	:= UsaColaboracao("2")

//-- Verifica se o arquivo sera gerado em Remote Linux
if Type('ParamIXB') <> 'U' .And. Len( ParamIXB ) > 0
	cDestPDF:= ParamIXB[1]
	cFilDoc	:= ParamIXB[2]
	cDoc	:= ParamIXB[3]
	cSerie	:= ParamIXB[4]
	cChave	:= ParamIXB[5]

ElseIf Empty(cDestPDF)

	cStartPath := GetTempPath(.T.)
endif

//-- MV_PAR01 - Informe lote inicial.
//-- MV_PAR02 - Informe lote final.
//-- MV_PAR03 - Informe documento inicial.
//-- MV_PAR04 - Informe documento final.
//-- MV_PAR05 - Informe serie do documento inicial.
//-- MV_PAR06 - Informe serie do documento final.
//-- MV_PAR07 - Informe tipo do documento.
//-- MV_PAR08 - Buscar XML do WebService.

If lTMSDACTE
	ExecBlock("TMSDACTE",.F.,.F.)	
	Return()
EndIf

lExibePerg := !( !Empty(cChave) .And. !Empty(cFilDoc) .And. !Empty(cDoc) )
If !Pergunte( cPerg, lExibePerg ) .And. lExibePerg
	Return()
EndIf

If	!lUsaColab .And. !TMSSpedNFe(@cIdEnt,@cModalidade,@cVersaoCTE,lUsaColab)
	Return()
EndIf

// Cria Arquivo de Trabalho - Documentos de Transporte
cAliasCT := DataSource( 'DT6', cFilDoc, cDoc, cSerie )
If !Empty(cFilDoc) .And. !Empty(cDoc) .And. !Empty(cSerie) .AND. Empty(cChave)
	cChaveCTe := IIf(!Empty((cAliasCT)->DT6_CHVCTE), (cAliasCT)->DT6_CHVCTE, (cAliasCT)->DT6_CHVCTG)
ElseIf !Empty(cChave) .AND. !Empty(cFilDoc) .And. !Empty(cDoc) .And. !Empty(cSerie)
	cChaveCTe := cChave
EndIf

oDacte := FWMSPrinter():New( If( !Empty(cChaveCTe), cChaveCTe, "DACTE"), IMP_PDF, .F., If(!Empty(cDestPDF), cDestPDF, cStartPath ), If( !Empty(cDoc), .T., .F.), , @oDacte, , , , , If( Empty(cDoc), .T., .F. ) )
oDacte:SetResolution( 72 )
oDacte:SetPortrait()
oDacte:SetPaperSize( DMPAPER_A4 )
oDacte:SetMargin( 60, 60, 60, 60 )
oDacte:SetParm( "-RFS" )

//--Salvar arquivo na pasta temporaria deverá seleciona no TOTVSPrinter Servidor,
//--Caso contrário salvará na pasta selecionada.
If !Empty(cDestPDF)
	oDacte:lServer	:= .T.
	oDacte:nDevice	:= IMP_PDF
	oDacte:cPathPDF	:= cDestPDF
Else
	oDacte:cPathPDF := cStartPath //--Pasta Temp.
EndIf

If Empty(cDoc) .And. oDacte:nModalResult <> 1
	oDacte:Cancel()
EndIf

If oDacte:Canceled()
	oDacte:DeActivate()
	Return(.T.)
EndIf

PixelX  := oDacte:nLogPixelX()
PixelY  := oDacte:nLogPixelY()
nMM     := 0

While !(cAliasCT)->(Eof())

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
	aadd(aNotas,{})
	aAdd(Atail(aNotas),.F.)

	aadd(Atail(aNotas),"S") //IIF(MV_PAR04==1,"E","S"))
	aAdd(Atail(aNotas),"")
	aAdd(Atail(aNotas),(cAliasCT)->DT6_SERIE) //SERIE
	aAdd(Atail(aNotas),(cAliasCT)->DT6_DOC) //Documento
	aadd(Atail(aNotas),"")
	aadd(Atail(aNotas),"")

	nX   := 1
	aXml := {}
	If lUsaColab
		//-- TOTVS Colaboracao 2.0
		aXml := TMSColXML(aNotas,@cModalidade,lUsaColab)
	Else
		aXml := TMSGetXML(cIdEnt,aNotas,@cModalidade)
	EndIf
	
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
		oNfeDPEC := XmlParser(aXML[nX][4],"_",@cAviso,@cErro)
		
		If ValType( oNfe ) == 'U'
			(cAliasCT)->(DbSkip())
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
	
	If ValType( oNfe ) == 'U'
		(cAliasCT)->(DbSkip())
		Loop 
	EndIf

	// Seleciona a qtde de registros, p/ calcular a qtde de folhas
	cAliasInfNF := DataSource( 'DTC' )
	If (cAliasInfNF)->nTotal > 0
		If (cAliasInfNF)->nTotal <= 10
			nFolhas := 1
		Else
			nFolhas := (cAliasInfNF)->nTotal - 10	//-- Qtde da primeira paginas.
			nFolhas := Int(( nFolhas / 74 ) + 2)	//-- Qtde da outras paginas.
		EndIf
	EndIf
	(cAliasInfNF)->(DbCloseArea())	

	// Controla o documento a ser enviado para montagem do cabecalho.
	nCont += 1
		aAdd(aCab, {;
		AllTrim((cAliasCT)->DT6_DOC),;
		AllTrim(oNfe:_CTE:_INFCTE:_IDE:_SERIE:TEXT),;
		AllTrim(STRTRAN( SUBSTR( oNfe:_CTE:_INFCTE:_IDE:_dhEmi:TEXT, 1, AT('T', oNfe:_CTE:_INFCTE:_IDE:_dhEmi:TEXT) - 1) , '-', '')),;
		AllTrim(STRTRAN( SUBSTR( oNfe:_CTE:_INFCTE:_IDE:_dhEmi:TEXT, AT('T', oNfe:_CTE:_INFCTE:_IDE:_dhEmi:TEXT) + 1, 5) , ':', '')),;
		AllTrim(STRTRAN(UPPER(oNFE:_CTE:_INFCTE:_ID:TEXT),'CTE','')),;
		(cAliasCT)->DT6_PROCTE,"" ,cDatAut, cHorAut})	//-- Nao possui ref. no XML
	
	// Funcao responsavel por montar o cabecalho do relatorio
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
	cOriMunPre	:= Iif(XmlChildEx( oNfe:_CTE:_INFCTE:_IDE, '_XMUNINI') == NIL," ",oNfe:_CTE:_INFCTE:_IDE:_XMUNINI:TEXT )
	cOriUFPre	:= oNfe:_CTE:_INFCTE:_IDE:_UFINI:TEXT

	//-- Destino da Prestacao
	cDesMunPre	:= oNfe:_CTE:_INFCTE:_IDE:_XMUNFIM:TEXT
	cDesUFPre	:= oNfe:_CTE:_INFCTE:_IDE:_UFFIM:TEXT

	//-- Remetente
	If XmlChildEx(oNfe:_CTE:_INFCTE,'_REM') <> NIL
		cRemMun   := oNfe:_CTE:_INFCTE:_REM:_ENDERREME:_XMUN:TEXT
		cRemUF    := oNfe:_CTE:_INFCTE:_REM:_ENDERREME:_UF:TEXT
		cRemNome  := oNfe:_CTE:_INFCTE:_REM:_XNOME:TEXT
		cRemEnd   := oNfe:_CTE:_INFCTE:_REM:_ENDERREME:_XLGR:TEXT
		cRemNro   := oNfe:_CTE:_INFCTE:_REM:_ENDERREME:_NRO:TEXT
		cRemCompl := Iif(XmlChildEx(oNfe:_CTE:_INFCTE:_REM:_ENDERREME,'_XCPL' )== NIL," ",oNfe:_CTE:_INFCTE:_REM:_ENDERREME:_XCPL:TEXT)
		cRemBair  := oNfe:_CTE:_INFCTE:_REM:_ENDERREME:_XBAIRRO:TEXT
		cRemCEP   := oNfe:_CTE:_INFCTE:_REM:_ENDERREME:_CEP:TEXT
		cRemCNPJ  := Iif(XmlChildEx(oNfe:_CTE:_INFCTE:_REM,'_CNPJ') == Nil,oNfe:_CTE:_INFCTE:_REM:_CPF:TEXT,oNfe:_CTE:_INFCTE:_REM:_CNPJ:TEXT)
		cRemIE    := Iif(XmlChildEx(oNfe:_CTE:_INFCTE:_REM,'_IE' ) == Nil," ",oNfe:_CTE:_INFCTE:_REM:_IE:TEXT)
		cRemPais  := Iif(XmlChildEx(oNfe:_CTE:_INFCTE:_REM:_ENDERREME,'_XPAIS') == Nil," ",oNfe:_CTE:_INFCTE:_REM:_ENDERREME:_XPAIS:TEXT)
		cRemFone  := Iif(XmlChildEx(oNfe:_CTE:_INFCTE:_REM,'_FONE') == Nil," ",oNfe:_CTE:_INFCTE:_REM:_FONE:TEXT)
	EndIf
	//-- Expedidor
	If (XmlChildEx(oNfe:_CTE:_INFCTE,'_EXPED')) <> Nil
		lExped		:= .T.
		cExpMun		:= oNfe:_CTE:_INFCTE:_EXPED:_ENDEREXPED:_XMUN:TEXT
		cExpUF		:= oNfe:_CTE:_INFCTE:_EXPED:_ENDEREXPED:_UF:TEXT
		cExpNome	:= oNfe:_CTE:_INFCTE:_EXPED:_XNOME:TEXT
		cExpEnd		:= oNfe:_CTE:_INFCTE:_EXPED:_ENDEREXPED:_XLGR:TEXT
		cExpNro		:= oNfe:_CTE:_INFCTE:_EXPED:_ENDEREXPED:_NRO:TEXT
		cExpCompl 	:= ""
		cExpBai		:= oNfe:_CTE:_INFCTE:_EXPED:_ENDEREXPED:_XBAIRRO:TEXT
		cExpCEP		:= oNfe:_CTE:_INFCTE:_EXPED:_ENDEREXPED:_CEP:TEXT
		cExpCNPJ	:= Iif(XmlChildEx(oNfe:_CTE:_INFCTE:_EXPED,'_CNPJ')==Nil, oNfe:_CTE:_INFCTE:_EXPED:_CPF:TEXT , oNfe:_CTE:_INFCTE:_EXPED:_CNPJ:TEXT)
		cExpIE		:= Iif(XmlChildEx(oNfe:_CTE:_INFCTE:_EXPED,'_IE' )==Nil," ",oNfe:_CTE:_INFCTE:_EXPED:_IE:TEXT)
		cExpPais	:= Iif(XmlChildEx(oNfe:_CTE:_INFCTE:_EXPED:_ENDEREXPED,'_XPAIS')==Nil," ",oNfe:_CTE:_INFCTE:_EXPED:_ENDEREXPED:_XPAIS:TEXT)
		cExpFone	:= Iif(XmlChildEx(oNfe:_CTE:_INFCTE:_EXPED,'_FONE')==Nil," ",oNfe:_CTE:_INFCTE:_EXPED:_FONE:TEXT)
	EndIf

	//-- Destinatario
	If XmlChildEx(oNfe:_CTE:_INFCTE,'_DEST') <> Nil
		cDesMun   := oNfe:_CTE:_INFCTE:_DEST:_ENDERDEST:_XMUN:TEXT
		cDesUF    := oNfe:_CTE:_INFCTE:_DEST:_ENDERDEST:_UF:TEXT
		cDesNome  := oNfe:_CTE:_INFCTE:_DEST:_XNOME:TEXT
		cDesEnd   := oNfe:_CTE:_INFCTE:_DEST:_ENDERDEST:_XLGR:TEXT
		cDesNro   := oNfe:_CTE:_INFCTE:_DEST:_ENDERDEST:_NRO:TEXT
		cDesCompl := Iif(XmlChildEx(oNfe:_CTE:_INFCTE:_DEST:_ENDERDEST,'_XCPL' ) == Nil," ", oNfe:_CTE:_INFCTE:_DEST:_ENDERDEST:_XCPL:TEXT)
		cDesBair  := oNfe:_CTE:_INFCTE:_DEST:_ENDERDEST:_XBAIRRO:TEXT
		cDesCEP   := oNfe:_CTE:_INFCTE:_DEST:_ENDERDEST:_CEP:TEXT
		cDesCNPJ  := Iif(XmlChildEx(oNfe:_CTE:_INFCTE:_DEST,'_CNPJ') == Nil,    oNfe:_CTE:_INFCTE:_DEST:_CPF:TEXT, oNfe:_CTE:_INFCTE:_DEST:_CNPJ:TEXT)
		cDesIE    := Iif(XmlChildEx(oNfe:_CTE:_INFCTE:_DEST,'_IE'  ) == Nil," ",oNfe:_CTE:_INFCTE:_DEST:_IE:TEXT)
		cDesPais  := Iif(XmlChildEx(oNfe:_CTE:_INFCTE:_DEST:_ENDERDEST,'_XPAIS') == Nil," ",oNfe:_CTE:_INFCTE:_DEST:_ENDERDEST:_XPAIS:TEXT)
		cDesFone  := Iif(XmlChildEx(oNfe:_CTE:_INFCTE:_DEST,'_FONE') == Nil," ",oNfe:_CTE:_INFCTE:_DEST:_FONE:TEXT)
	EndIf

	//-- Local de Entrega
	If XmlChildEx(oNfe:_CTE:_INFCTE,'_RECEB') <> Nil .AND. XmlChildEx(oNfe:_CTE:_INFCTE:_RECEB,'_ENDERRECEB') <> Nil
		lSeqRec := .T.
		//Destino Recebedor
		cRecNome	:= oNfe:_CTE:_INFCTE:_RECEB:_XNOME:TEXT
		cRecEnd		:= oNfe:_CTE:_INFCTE:_RECEB:_ENDERRECEB:_XLGR:TEXT
		cRecNro  	:= oNfe:_CTE:_INFCTE:_RECEB:_ENDERRECEB:_NRO:TEXT
		cRecBai		:= oNfe:_CTE:_INFCTE:_RECEB:_ENDERRECEB:_XBAIRRO:TEXT
		cRecMun		:= oNfe:_CTE:_INFCTE:_RECEB:_ENDERRECEB:_XMUN:TEXT
		crecUF		:= oNfe:_CTE:_INFCTE:_RECEB:_ENDERRECEB:_UF:TEXT
		cRecPais  	:= Iif( XmlChildEx(oNfe:_CTE:_INFCTE:_RECEB:_ENDERRECEB,'_XPAIS')== Nil," ",oNfe:_CTE:_INFCTE:_RECEB:_ENDERRECEB:_XPAIS:TEXT)
		cRecCompl 	:= Iif( XmlChildEx(oNfe:_CTE:_INFCTE:_RECEB:_ENDERRECEB,'_XCPL') == Nil," ",oNfe:_CTE:_INFCTE:_RECEB:_ENDERRECEB:_XCPL:TEXT )
		cRecCEP   	:= Iif( XmlChildEx(oNfe:_CTE:_INFCTE:_RECEB:_ENDERRECEB,'_CEP')  == Nil," ",oNfe:_CTE:_INFCTE:_RECEB:_ENDERRECEB:_CEP:TEXT  )
		
		cRecFone := Iif( XmlChildEx(oNfe:_CTE:_INFCTE:_RECEB,'_FONE') == Nil," ",oNfe:_CTE:_INFCTE:_RECEB:_FONE:TEXT )
		If Empty(cRecFone)
			cRecFone := Iif( XmlChildEx(oNfe:_CTE:_INFCTE:_RECEB:_ENDERRECEB,'_FONE') == Nil," ",oNfe:_CTE:_INFCTE:_RECEB:_ENDERRECEB:_FONE:TEXT )
		EndIf

		If XmlChildEx(oNfe:_CTE:_INFCTE:_RECEB,'_CNPJ')==Nil
			cRecCPF	:= oNfe:_CTE:_INFCTE:_RECEB:_CPF:TEXT
		Else
			cRecCGC	:= oNfe:_CTE:_INFCTE:_RECEB:_CNPJ:TEXT				
			cRecINSCR := Iif(XmlChildEx(oNfe:_CTE:_INFCTE:_RECEB,'_IE' )==Nil," ",oNfe:_CTE:_INFCTE:_RECEB:_IE:TEXT)
			lRecPJ	:= .T.
		EndIf		
	EndIf

	//-- Produto Predominante
	If (XmlChildEx(oNFE:_CTE:_INFCTE,'_INFCTENORM')) <> Nil .And. (XmlChildEx(oNFE:_CTE:_INFCTE,'_INFCTENORM')) <> Nil
		If XmlChildEx(oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA,'_PROPRED') <> Nil
			cPPDesc		:= oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_PROPRED:TEXT
		EndIf
		If XmlChildEx(oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA,'_XOUTCAT') <> Nil
			cPPCarga	:= oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_XOUTCAT:TEXT
		EndIf
		If XmlChildEx(oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA,'_VMERC') <> Nil
			cPPVlTot	:= oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_VMERC:TEXT
		Else
			cPPVlTot	:= oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_VCARGA:TEXT
		EndIf
		If XmlChildEx( oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA,'_INFQ' ) <> Nil
			For nCount := 1 To Len( oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ )
				Do Case
					Case oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ[ nCount ]:_TPMED:TEXT == "PESO DECLARADO"
						cPPPesoB := oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ[ nCount ]:_QCARGA:TEXT
					Case oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ[ nCount ]:_TPMED:TEXT == "PESO BASE DE CALCULO"
						cPesoBC := oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ[ nCount ]:_QCARGA:TEXT	
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

	// Tomador
	//
	// Tomador do Servico
	// 0 - Remetente;
	// 1 - Expedidor;
	// 2 - Recebedor;
	// 3 - Destinatario. 
		//| Remetente é o tomador do frete
	If XmlChildEx(oNfe:_CTE:_INFCTE:_IDE, '_TOMA3') <> Nil .AND. (oNfe:_CTE:_INFCTE:_IDE:_TOMA3,'_TOMA') <> Nil
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
		//| Expedidor é o Tomador do Frete
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
		//| Recebedor é o tomador do frete
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
		//| Destinatário  é o Tomador do Frete
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
	ElseIf XmlChildEx(oNfe:_CTE:_INFCTE:_IDE, '_TOMA4') <> Nil .AND. (oNfe:_CTE:_INFCTE:_IDE:_TOMA4,'_TOMA') <> Nil
		If oNfe:_CTE:_INFCTE:_IDE:_TOMA4:_TOMA:TEXT == "4"
			// Subcontratacao DT6_DEVFRE == "4" - Despachante		
			cDevMun   := oNfe:_CTE:_INFCTE:_IDE:_TOMA4:_ENDERTOMA:_XMUN:TEXT
			cDevUF    := oNfe:_CTE:_INFCTE:_IDE:_TOMA4:_ENDERTOMA:_UF:TEXT
			cDevNome  := oNfe:_CTE:_INFCTE:_IDE:_TOMA4:_XNOME:TEXT
			cDevEnd   := oNfe:_CTE:_INFCTE:_IDE:_TOMA4:_ENDERTOMA:_XLGR:TEXT
			cDevNro   := oNfe:_CTE:_INFCTE:_IDE:_TOMA4:_ENDERTOMA:_NRO:TEXT
			cDevCompl := ""
			cDevBair  := oNfe:_CTE:_INFCTE:_IDE:_TOMA4:_ENDERTOMA:_XBAIRRO:TEXT
			cDevCEP   := oNfe:_CTE:_INFCTE:_IDE:_TOMA4:_ENDERTOMA:_CEP:TEXT
			cDevCNPJ  := Iif(XmlChildEx(oNfe:_CTE:_INFCTE:_IDE:_TOMA4,'_CNPJ')==Nil,oNfe:_CTE:_INFCTE:_IDE:_TOMA4:_CPF:TEXT,oNfe:_CTE:_INFCTE:_IDE:_TOMA4:_CNPJ:TEXT)
			cDevIE    := Iif(XmlChildEx(oNfe:_CTE:_INFCTE:_IDE:_TOMA4,'_IE' )==Nil," ",oNfe:_CTE:_INFCTE:_IDE:_TOMA4:_IE:TEXT)
			cDevPais  := Iif(XmlChildEx(oNfe:_CTE:_INFCTE:_IDE:_TOMA4:_ENDERTOMA,'_XPAIS' )==Nil," ",oNfe:_CTE:_INFCTE:_IDE:_TOMA4:_ENDERTOMA:_XPAIS:TEXT)
			cDevFone  := Iif(XmlChildEx(oNfe:_CTE:_INFCTE:_IDE:_TOMA4,'_FONE')==Nil," ",oNfe:_CTE:_INFCTE:_IDE:_TOMA4:_FONE:TEXT)
		EndIf
	EndIf
	//-- Documentos Originarios
	aDocOri := {}
	If (XmlChildEx(oNFE:_CTE:_INFCTE,'_REM') <> Nil) .And. ( XmlChildEx( oNFE:_CTE:_INFCTE:_REM,'_INFNFE' ) <> Nil )
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
	ElseIf	(XmlChildEx(oNFE:_CTE:_INFCTE,'_REM') <> Nil) .And. ( XmlChildEx( oNFE:_CTE:_INFCTE:_REM,'_INFNF' ) <> Nil ) 
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
			If (XmlChildEx(oNfe:_CTE:_INFCTE:_REM:_INFNF[1],'_LOCRET')) <> Nil
				cExpMun	:= oNfe:_CTE:_INFCTE:_REM:_INFNF[1]:_LOCRET:_XMUN:TEXT
				cExpUF		:= oNfe:_CTE:_INFCTE:_REM:_INFNF[1]:_LOCRET:_UF:TEXT
				cExpNome	:= oNfe:_CTE:_INFCTE:_REM:_INFNF[1]:_LOCRET:_XNOME:TEXT
				cExpEnd	:= oNfe:_CTE:_INFCTE:_REM:_INFNF[1]:_LOCRET:_XLGR:TEXT
				cExpNro	:= oNfe:_CTE:_INFCTE:_REM:_INFNF[1]:_LOCRET:_NRO:TEXT
				cExpCompl 	:= ""
				cExpBai	:= oNfe:_CTE:_INFCTE:_REM:_INFNF[1]:_LOCRET:_XBAIRRO:TEXT
				cExpCEP   	:= ""
				cExpCNPJ  	:= Iif(XmlChildEx(oNfe:_CTE:_INFCTE:_REM:_INFNF[1]:_LOCRET,'_CNPJ')==Nil, oNfe:_CTE:_INFCTE:_REM:_INFNF[1]:_LOCRET:_CPF:TEXT , oNfe:_CTE:_INFCTE:_REM:_INFNF[1]:_LOCRET:_CNPJ:TEXT)
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
			If (XmlChildEx(oNfe:_CTE:_INFCTE:_REM:_INFNF,'_LOCRET')) <> Nil
				cExpMun	:= oNfe:_CTE:_INFCTE:_REM:_INFNF:_LOCRET:_XMUN:TEXT
				cExpUF		:= oNfe:_CTE:_INFCTE:_REM:_INFNF:_LOCRET:_UF:TEXT
				cExpNome	:= oNfe:_CTE:_INFCTE:_REM:_INFNF:_LOCRET:_XNOME:TEXT
				cExpEnd	:= oNfe:_CTE:_INFCTE:_REM:_INFNF:_LOCRET:_XLGR:TEXT
				cExpNro	:= oNfe:_CTE:_INFCTE:_REM:_INFNF:_LOCRET:_NRO:TEXT
				cExpCompl 	:= ""
				cExpBai	:= oNfe:_CTE:_INFCTE:_REM:_INFNF:_LOCRET:_XBAIRRO:TEXT
				cExpCEP   	:= ""
				cExpCNPJ  	:= Iif(XmlChildEx(oNfe:_CTE:_INFCTE:_REM:_INFNF:_LOCRET,'_CNPJ')==Nil, oNfe:_CTE:_INFCTE:_REM:_INFNF:_LOCRET:_CPF:TEXT , oNfe:_CTE:_INFCTE:_REM:_INFNF:_LOCRET:_CNPJ:TEXT)
				cExpIE    	:= ""
				cExpPais  	:= cRemPais
				cExpFone  	:= ""
			EndIf
		EndIf
	//Aqui Inicio
	ElseIf XmlChildEx(oNFE:_CTE:_INFCTE,'_INFCTENORM') <> Nil .And. XmlChildEx(oNFE:_CTE:_INFCTE:_INFCTENORM,'_INFDOC') <> Nil .And. XmlChildEx( oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC,'_INFNF') <> Nil
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
		
    //CTE MULTIMODAL
	ElseIf XmlChildEx(oNFE:_CTE:_INFCTE,'_INFCTENORM') <> Nil .And. XmlChildEx(oNFE:_CTE:_INFCTE:_INFCTENORM,'_INFSERVVINC') <> Nil .And. XmlChildEx( oNFE:_CTE:_INFCTE:_INFCTENORM:_INFSERVVINC,'_INFCTEMULTIMODAL' ) <> Nil 
		If ValType( oNFE:_CTE:_INFCTE:_INFCTENORM:_INFSERVVINC:_INFCTEMULTIMODAL ) == 'A'
			For nCount := 1 To Len( oNFE:_CTE:_INFCTE:_INFCTENORM:_INFSERVVINC:_INFCTEMULTIMODAL )
				If aScan(aDocOri,{|x|x[8]==oNFE:_CTE:_INFCTE:_INFCTENORM:_INFSERVVINC:_INFCTEMULTIMODAL[ nCount ]:_CHCTEMULTIMODAL:TEXT})==0
					AADD(aDocOri, {;
					'',;
					'',;
					'',;
					'',;
					'',;
					'',;
					'',;
					'',;
					oNFE:_CTE:_INFCTE:_INFCTENORM:_INFSERVVINC:_INFCTEMULTIMODAL[ nCount ]:_CHCTEMULTIMODAL:TEXT })
				EndIf
			Next nCount
		ElseIf ValType( oNFE:_CTE:_INFCTE:_INFCTENORM:_INFSERVVINC:_INFCTEMULTIMODAL) == 'O'
			If aScan(aDocOri,{|x|x[8]==oNFE:_CTE:_INFCTE:_INFCTENORM:_INFSERVVINC:_INFCTEMULTIMODAL:_CHCTEMULTIMODAL:TEXT})==0
				AADD(aDocOri, {;
				'',;
				'',;
				'',;
				'',;
				'',;
				'',;
				'',;
				'',;
				oNFE:_CTE:_INFCTE:_INFCTENORM:_INFSERVVINC:_INFCTEMULTIMODAL:_CHCTEMULTIMODAL:TEXT }) 
			EndIf
		EndIf

	ElseIf XmlChildEx(oNFE:_CTE:_INFCTE,'_INFCTENORM') <> Nil .And. XmlChildEx(oNFE:_CTE:_INFCTE:_INFCTENORM,'_INFDOC') <> Nil .And. XmlChildEx( oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC,'_INFNFE' ) <> Nil 
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
	ElseIf	(XmlChildEx(oNFE:_CTE:_INFCTE,'_REM') <> Nil) .And. ( XmlChildEx( oNFE:_CTE:_INFCTE:_REM,'_INFOUTROS' ) <> Nil )
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
	ElseIf XmlChildEx(oNFE:_CTE:_INFCTE,'_INFCTENORM') <> Nil .And. XmlChildEx(oNFE:_CTE:_INFCTE:_INFCTENORM,'_INFDOC') <> Nil .And. ( XmlChildEx( oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC,'_INFOUTROS' ) <> Nil ) 
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
				oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFOUTROS:_NDOC:TEXT,;
				STRTRAN(oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFOUTROS:_DEMI:TEXT,'-'),;
				'',; //--VALOR DO PRODUTO NAO INFORMADO NO XML QUANDO O DOCUMENTO NAO EH FISCAL
				'',;
				'',;
				'',;
				'' })
			EndIf
		EndIf
	EndIf

	//Tratamento para a tag docAnt
	If (XmlChildEx(oNFE:_CTE:_INFCTE,'_INFCTENORM')) <> Nil .And. XmlChildEx( oNFE:_CTE:_INFCTE:_INFCTENORM,'_DOCANT' ) <> Nil .AND. ;
		XmlChildEx( oNFE:_CTE:_INFCTE:_INFCTENORM:_DOCANT,'_EMIDOCANT' ) <> NIL .AND.;
		XmlChildEx( oNFE:_CTE:_INFCTE:_INFCTENORM:_DOCANT:_EMIDOCANT:_IDDOCANT,'_IDDOCANTELE' ) <> Nil
		aDocOri := {}
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

	// BOX: CFOP - Natureza da Prestacao
	oDacte:Box(0195, 0000, 0215, 0280)
	oDacte:Say(0202, 0003, "Código Fiscal de Operações - Natureza da Operação",	oFont08N)
	oDacte:Say(0211, 0003, cCFOP + " - " + cDescCfop,		oFont08)

	// BOX: ORIGEM DA PRESTACAO
	oDacte:Box(0215, 0000, 0229, 0280)
	oDacte:Say(0221, 0003, "Início da Prestação" , oFont08N)
	oDacte:Say(0228, 0003, AllTrim(cOriMunPre) + ' - ' + AllTrim(cOriUFPre), oFont08)	

	// BOX: DESTINO DA PRESTACAO
	oDacte:Box(0215, 0280, 0229, 0559)
	oDacte:Say(0221, 0288, "Término da Prestação", oFont08N)
	oDacte:Say(0228, 0288, AllTrim(cDesMunPre) + ' - ' + AllTrim(cDesUFPre), oFont08)

	// BOX: Remetente
	// BOX: Destinatario
	oDacte:Box(0231, 0000, 0282, 0279)	//Remetente
	oDacte:Box(0231, 0281, 0282, 0559)	//Destinatario

	oDacte:Say(0237, 0003, "Remetente:", oFont08)
	oDacte:Say(0237, 0043, NoAcentoCte(Substr(cRemNome,1,45)), oFont08N)
	oDacte:Say(0237, 0286, "Destinatário:", oFont08)
	oDacte:Say(0237, 0328, NoAcentoCte(Substr(cDesNome,1,45)), oFont08N)

	cInsRemOpc := AllTrim(cRemIE)
	For nCount := 1 To 5
		Do Case
			Case ( nCount == 1 )
				oDacte:Say(0246, 0003, "Endereço:", oFont08)
				If Len(AllTrim(cRemEnd)) > 40
					oDacte:Say(0246, 0039, SubStr( AllTrim(cRemEnd), 1, 40 ) , oFont08)
					oDacte:Say(0253, 0039, SubStr( AllTrim(cRemEnd), 40,Len(AllTrim(cRemEnd) ) ) + ", " + cRemNro, oFont08)
				Else
					oDacte:Say(0246, 0039, AllTrim(cRemEnd) + ", " + cRemNro, oFont08)
				EndIf
				
				oDacte:Say(0246, 0286, "Endereço:", oFont08)
				If Len(AllTrim(cDesEnd)) > 40
					oDacte:Say(0246, 0324, SubStr( AllTrim(cDesEnd), 1, 40) , oFont08)
					oDacte:Say(0253, 0324, SubStr( AllTrim(cDesEnd), 40, 35 ) + ", " + cDesNro, oFont08)
				Else
					oDacte:Say(0246, 0324, AllTrim(cDesEnd) + ", " + cDesNro, oFont08)
				EndIf
			Case ( nCount == 2 )
				oDacte:Say(0260, 0039, SubStr( AllTrim(cRemCompl), 1, 20 ) + " - " + SubStr( AllTrim(cRemBair), 1, 20 ), oFont08)
				oDacte:Say(0260, 0324, SubStr( AllTrim(cDesCompl), 1, 20 ) + " - " + SubStr( AllTrim(cDesBair), 1, 20 ), oFont08)
			Case ( nCount == 3 )
				oDacte:Say(0267, 0003, "Município:", oFont08)
				oDacte:Say(0267, 0043, AllTrim(cRemMun) + ' - ' + AllTrim(cRemUF)  + ' CEP.: ' + Transform(AllTrim(cRemCEP), "@r 99999-999"), oFont08)
				oDacte:Say(0267, 0286, "Município:", oFont08)
				oDacte:Say(0267, 0328, AllTrim(cDesMun) + ' - ' + AllTrim(cDesUF) + ' CEP.: ' + Transform(AllTrim(cDesCEP), "@r 99999-999"), oFont08)
			Case ( nCount == 4 )
				oDacte:Say(0274, 0003, "CNPJ/CPF:", oFont08)
				oDacte:Say(0274, 0043, Transform(AllTrim(cRemCNPJ), "@r 99.999.999/9999-99") + "   Inscrição Estadual: " +  AllTrim(cInsRemOpc), oFont08)
				oDacte:Say(0274, 0286, "CNPJ/CPF:", oFont08)
				oDacte:Say(0274, 0328, Transform(AllTrim(cDesCNPJ), "@r 99.999.999/9999-99") + "   Inscrição Estadual: " +  AllTrim(cDesIE),    oFont08)
			Case ( nCount == 5 )
				oDacte:Say(0281, 0003, "País:", oFont08)
				oDacte:Say(0281, 0043, AllTrim(cRemPais) + ' - Telefone: ' + Transform(AllTrim(cRemFone),"@r (999) 999999999"),  oFont08)
				oDacte:Say(0281, 0286, "País:", oFont08)
				oDacte:Say(0281, 0328, AllTrim(cDesPais) + '  - Telefone: ' + Transform(AllTrim(cDesFone),"@r (999) 999999999"), oFont08)
		EndCase
	Next nCount

	// BOX: Expedidor / BOX: Recebedor
	oDacte:Box(0284, 0000, 0335, 0279)	//Expedidor
	oDacte:Box(0284, 0281, 0335, 0559)	//Recebedor

	If lExped .Or. Empty(cExpNome) 		
		oDacte:Say(0291, 0003, "Expedidor:", oFont08) 
	Else
		oDacte:Say(0291, 0003, "Local de Coleta:", oFont08)
	EndIf
	oDacte:Say(0291, 0043, NoAcentoCte(Substr(cExpNome,1,45))    , oFont08N)

	//-- Sequencia de endereco preenchida, fica como local de entrega.
	If lSeqDes
		oDacte:Say(0291, 0286, "Local de Entrega:", oFont08)
		oDacte:Say(0291, 0342,  NoAcentoCte(Substr(cRecNome,1,45)), oFont08N)
	EndIf
	
	If lSeqRec
		oDacte:Say(0291, 0286, "Recebedor:", oFont08)
		oDacte:Say(0291, 0328,  NoAcentoCte(Substr(cRecNome,1,45)), oFont08N)
	EndIf

	If !lSeqDes .And. !lSeqRec
		oDacte:Say(0291, 0286, "Recebedor:", oFont08)
	EndIf

	For nCount := 1 To 5
		Do Case
			Case ( nCount == 1 )
				oDacte:Say(0300, 0003, "Endereço:", oFont08)
				If Len(AllTrim(cDesEnd)) > 40
					oDacte:Say(0300, 0039, If( !Empty(cExpEnd), SubStr(AllTrim(cExpEnd), 1, 40 ), " "), oFont08)
					oDacte:Say(0307, 0039, If( !Empty(cExpEnd), SubStr(AllTrim(cExpEnd), 40, Len(AllTrim(cExpEnd) ) ) + ", " + cExpNro, " "), oFont08)
				Else
					oDacte:Say(0300, 0039, IIf(!Empty(cExpEnd), AllTrim(cExpEnd) + ", " + cExpNro, " "), oFont08)
				EndIf
				oDacte:Say(0300, 0286, "Endereço:", oFont08)
				//-- Sequencia de endereco preenchida, fica como local de entrega.
				If Len(AllTrim(cRecEnd)) > 40
					oDacte:Say(0300, 0324, If(lSeqDes .or. lSeqRec, SubStr(AllTrim(cRecEnd), 1, 40 ), " "), oFont08)
					oDacte:Say(0307, 0324, If(lSeqDes .or. lSeqRec, SubStr(AllTrim(cRecEnd), 40, Len(AllTrim(cRecEnd) ) ) + ", " + cRecNro, " "), oFont08)
				Else
					oDacte:Say(0300, 0324, If(lSeqDes .or. lSeqRec, AllTrim(cRecEnd) + ", " + cRecNro, " "), oFont08)
				EndIf
			Case ( nCount == 2 )
				oDacte:Say(0314, 0039, If(!Empty(cExpCompl), If(!Empty(cExpCompl), SubStr(AllTrim(cExpCompl), 1, 20 ), "" ) + " - " + SubStr(AllTrim(cExpBai), 1, 20 ), cExpBai), oFont08)
				oDacte:Say(0314, 0324, If(lSeqDes .or. lSeqRec, AllTrim(cValtoChar(FisGetEnd(cRecEnd)[4] ) ) + " - " + AllTrim(cRecBai),""), oFont08)
			Case ( nCount == 3 )
				oDacte:Say(0321, 0003, "Município:", oFont08)
				oDacte:Say(0321, 0043, IIf(!Empty(cExpMun),  AllTrim(cExpMun) + ' - ' + AllTrim(cExpUF), " ")  + ' CEP.: ' + IIf(!Empty(cExpCEP), Transform(AllTrim(cExpCEP), "@r 99999-999"), ""), oFont08)
				oDacte:Say(0321, 0286, "Município:", oFont08)
				oDacte:Say(0321, 0328, If(lSeqDes .or. lSeqRec, AllTrim(cRecMun) + ' - ' + AllTrim(cRecUF),"") + ' CEP.: ' + IIf(!Empty(cRecCEP), Transform(AllTrim(cRecCEP), "@r 99999-999"), ""), oFont08)
			Case ( nCount == 4 )
				oDacte:Say(0328, 0003, "CNPJ/CPF:", oFont08)
				oDacte:Say(0328, 0043, IIf(!Empty(cExpCNPJ), Transform(AllTrim(cExpCNPJ), "@r 99.999.999/9999-99"), " ") + "   Inscrição Estadual: " +  AllTrim(cExpIE), oFont08)
				oDacte:Say(0328, 0286, "CNPJ/CPF:", oFont08)
				If lSeqDes .or. lSeqRec
					If lRecPJ
						oDacte:Say(0328, 0328, IIf(!Empty(cRecCGC), Transform(cRecCGC,"@r 99.999.999/9999-99"), " ") + "   Inscrição Estadual: " +  cRecINSCR, oFont08)
					Else
						oDacte:Say(0328, 0328, Transform(cRecCPF,"@r 999.999.999-99"), oFont08)
					EndIf
				Else
					oDacte:Say(0328, 0328, "", oFont08)
				EndIf

			Case ( nCount == 5 )
				If lExped .Or. Empty(cExpNome)
					oDacte:Say(0335, 0003, "País:" , oFont08)
					oDacte:Say(0335, 0043, AllTrim(cExpPais) + ' Telefone: ' + IIf(!Empty(cExpFone), Transform(AllTrim(cExpFone),"@r (999) 999999999"), " "),  oFont08)
				EndIf
				If !lSeqDes
					oDacte:Say(0335, 0286, "País:" , oFont08)
					oDacte:Say(0335, 0328, AllTrim(cRecPais) + ' Telefone: ' + IIf(!Empty(cRecFone), Transform(AllTrim(cRecFone),"@r (999) 999999999"), " "),  oFont08)
				EndIf
		EndCase
	Next nCount

	// BOX: Tomador do Servico
	oDacte:Box(0337, 0000, 0364, 0559)
	oDacte:Say(0344, 0003, "Tomador do Serviço:", oFont08)
	oDacte:Say(0344, 0072, NoAcentoCte(SubStr(cDevNome,1,45)), oFont08)
	oDacte:Say(0344, 0328, "Município:", oFont08)
	oDacte:Say(0344, 0368, AllTrim(cDevMun) + ' - ' + AllTrim(cDevUF) + ' CEP.: ' + Transform(AllTrim(cDevCEP),"@r 99999-999"), oFont08)

	For nCount := 1 To 2
		Do Case
			Case ( nCount == 1 )
				cEndCom := SubStr(AllTrim(cDevEnd),1,40) + ", " + cDevNro + " - " + AllTrim(cDevCompl) + " - " + AllTrim(cDevBair)
				oDacte:Say(0352, 0003, "Endereço:", oFont08	)

				If Len(cEndCom) > 64 .AND. !Empty(cDevCompl)
					cEndCom := SubStr(AllTrim(cDevEnd),1,40) + ", " + cDevNro + " - " + SubStr(AllTrim(cDevCompl), 1, 10 ) + " - " + SubStr(AllTrim(cDevBair), 1, 29 )
					oDacte:Say(0352, 0038, cEndCom, oFont08		)
					oDacte:Say(0352, 0485, "País: ", oFont08	)
					oDacte:Say(0352, 0505, AllTrim(cDevPais), oFont08	)
				ElseIf Len(cEndCom) > 64
					oDacte:Say(0352, 0038, cEndCom, oFont08		)
					oDacte:Say(0352, 0485, "País: ", oFont08	)
					oDacte:Say(0352, 0505, AllTrim(cDevPais), oFont08	)
				Else
					oDacte:Say(0352, 0038, cEndCom, oFont08		)
					oDacte:Say(0352, 0328, "País: ", oFont08	)
					oDacte:Say(0352, 0368, AllTrim(cDevPais), oFont08	)
				EndIf
				
			Case ( nCount == 2 )
				oDacte:Say(0360, 0003, "CNPJ/CPF:", oFont08)
				oDacte:Say(0360, 0043, Transform(AllTrim(cDevCNPJ),"@r 99.999.999/9999-99") + "   Inscrição Estadual: " + AllTrim(cDevIE), oFont08)
				oDacte:Say(0360, 0328, "Telefone:", oFont08)
				oDacte:Say(0360, 0368, Transform(AllTrim(cDevFone),"@r (999) 999999999"), oFont08)
		EndCase
	Next nCount

	If	AllTrim((cAliasCT)->DT6_DOCTMS) == StrZero( 2, Len(DT6->DT6_DOCTMS)) .Or.;
		AllTrim((cAliasCT)->DT6_DOCTMS) == StrZero( 6, Len(DT6->DT6_DOCTMS)) .Or.;
		AllTrim((cAliasCT)->DT6_DOCTMS) == StrZero( 7, Len(DT6->DT6_DOCTMS)) .Or.;
		AllTrim((cAliasCT)->DT6_DOCTMS) == StrZero( 9, Len(DT6->DT6_DOCTMS)) .Or.;
		AllTrim((cAliasCT)->DT6_DOCTMS) == 'A' .Or. AllTrim((cAliasCT)->DT6_DOCTMS) == 'E' .Or. ;
		AllTrim((cAliasCT)->DT6_DOCTMS) == 'M' .Or. ;
		(AllTrim((cAliasCT)->DT6_DOCTMS) == 'B' .Or. AllTrim((cAliasCT)->DT6_DOCTMS) == 'C' .And. ;
		 Empty(Posicione('DUI',1,xFilial('DUI')+(cAliasCT)->DT6_DOCTMS,'DUI_DOCFAT')) )

		// BOX: Prod Predom || Outras Caract || Valor Total da Mercadoria
		oDacte:Box(0366 , 0000, 0383, 0559)
		oDacte:Line(0366, 0189, 0383, 0189) // Linha: Prod.Predominante e Out.Caracteristicas
		oDacte:Line(0366, 0378, 0383, 0378) // Linha: Out.Caracteristicas e Vlr.Total
		oDacte:Say(0372, 0003, "Produto Predominante"           , oFont08N)
		oDacte:Say(0372, 0192, "Outras Características da Carga", oFont08N)
		oDacte:Say(0372, 0381, "Valor Total da Mercadoria"      , oFont08N)
		oDacte:Say(0380, 0003, SubStr(cPPDesc,1,40), oFont08)	//Produto Predominante
		oDacte:Say(0380, 0192, AllTrim(cPPCarga)	, oFont08)	//Outras Caracteristicas da Carga
		oDacte:Say(0380, 0381, PadL( Transform( val(cPPVlTot), PesqPict("DT6","DT6_VALMER") ), 20 ), oFont08)	//Valor Total da Mercadoria

		// BOX: QNT. / UNIDADE MEDIDA /
		oDacte:Box(0385, 0000, 0443,  0559)	
		oDacte:Box(0385, 0000, 0443,  0040) // Box Qtd / Carga
		oDacte:Say(0392 , 0003, "Qtd."	, oFont08N)
		oDacte:Say(0402 , 0003, "Carga"	, oFont08N)	
		oDacte:Say(0392 , 0043, "Peso Bruto (KG)"			, oFont08N)
		oDacte:Say(0392 , 0143, "Peso Base de Cálculo (KG)"	, oFont08N)
		oDacte:Say(0392 , 0247, "Peso Aferido (KG)  "	, oFont08N)
		oDacte:Say(0392 , 0352, "Cubagem (M³)        "		, oFont08N)
		oDacte:Say(0392 , 0457, "Qtd. Volume (UN)"	, oFont08N)
		oDacte:Say(0392 , nCInic, "                ", oFont08N)
		oDacte:Line(0385, 0140, 0443, 0140) // Linha: Separador Peso Bruto (KG) / Peso Cubado		
		oDacte:Line(0385, 0245, 0443, 0245) // Linha: Separador Peso Cubado / M³				
		oDacte:Line(0385, 0350, 0443, 0350) // Linha: Separador M³ / Qtd. Volume (Un)			
		oDacte:Line(0385, 0455, 0443, 0455) // Linha: SeparadorQtd. Volume (Un) / 				

		oDacte:Say(0405, 0043, Transform(val(cPPPesoB) ,	PesqPict("DT6","DT6_PESO")   ),	oFont08) 
		oDacte:Say(0405, 0143, Transform(val(cPesoBC) ,  	PesqPict("DT6","DT6_PESO")   ),	oFont08) 						
		oDacte:Say(0405, 0247, Transform(val(cPPPeso3) ,	PesqPict("DT6","DT6_PESOM3") ),	oFont08)  			
		oDacte:Say(0405, 0352, Transform(val(cPPMetro3),	PesqPict("DT6","DT6_METRO3") ),	oFont08)   				
		oDacte:Say(0405, 0457, Transform(val(cPPQtdVol),	PesqPict("DT6","DT6_QTDVOL") ),	oFont08)    
		
		//-- Zera as variaveis(Peso, Peso Cubado, Metro Cubico e Qtd Volume) depois de impresso no DACTE.
		cPPPesoB  := ""
		cPPPeso3  := ""
		cPPMetro3 := ""
		cPPQtdVol := ""
		cPesoBC	  := ""	

		// Conteudo do Box: Componentes do Valor da Prestacao de Servico
		// Conteudo do Box: Informacoes Relativas ao Imposto
		TMSR31Comp()

		cAliasPeri := DataSource("PRODUTOS_PERIGOSOS")
		If (cAliasPeri)->(!Eof())
			lPerig := .T.
		Else
			lPerig := .F.
		EndIf
		(cAliasPeri)->(DbCloseArea())

		// BOX: DOCUMENTOS ORIGINARIOS
		oDacte:Box(0502, 0000, 0559, 0559)
		If Empty(cCtrDpc)
			oDacte:Say(0508 , 0243, "Documentos Originários", oFont08N)
		Else
			oDacte:Say(0508 , 0143, "Documentos Originários",oFont08N)
			oDacte:Say(0508 , 0443, "Documentos Anteriores ",oFont08N)
		EndIf

		oDacte:Line(0510, 0000, 0510, 0559)	// Linha: Abaixo    DOCUMENTOS ORIGINARIOS
		oDacte:Line(0510, 0283, 0590, 0283)	// Linha: Separador DOCUMENTOS ORIGINARIOS
		
		oDacte:Say(0517 , 0003, "Tp. Doc."           , oFont08N)
		If !Empty(aDocOri) .And. Empty(AllTrim(aDocOri[1][doDTC_NFEID]))
			oDacte:Say(0517 , 0033, "CNPJ/CPF Emitente"  , oFont08N)
		EndIf
		oDacte:Say(0517 , 0163, "Série/Nr. Documento", oFont08N)
		oDacte:Say(0517 , 0286, "Tp. Doc."           , oFont08N)
		If !Empty(aDocOri) .And. Empty(AllTrim(aDocOri[1][doDTC_NFEID]))
			oDacte:Say(0517 , 0316, "CNPJ/CPF Emitente"  , oFont08N)
		EndIf
		oDacte:Say(0517 , 0448, "Série/Nr. Documento", oFont08N)
				
		// Documentos Originarios
		lControl := .F.
		nLInic   := 0525

		nCount := 0
		aDoc   := {}

		For nCount := 1 to Len( aDocOri )
			lControl := !lControl
			If nCount < 11
				If Empty(cCtrDpc)
					If lControl
						If Empty(AllTrim(aDocOri[nCount][doDTC_NFEID])) .And. !Empty(AllTrim(aDocOri[nCount][doDTC_SERNFC]))
							//-- Imprime a Chave da NF-e, lado esquerdo
							oDacte:Say(nLInic, 0003, "NF", oFont08)
							oDacte:Say(nLInic, 0033, Transform(AllTrim(cRemCNPJ),"@r 99.999.999/9999-99"), oFont08)
							oDacte:Say(nLInic, 0163, AllTrim(aDocOri[nCount][doDTC_SERNFC] + " / " + AllTrim(aDocOri[nCount][doDTC_NUMNFC])), oFont08)
						ElseIf Len(aDocOri[nCount]) >= doDTC_CTEID .And. !Empty(AllTrim(aDocOri[nCount][doDTC_CTEID])) 
							//-- Imprime a Chave da CT-e docAnt, lado esquerdo
							cChaveA := (AllTrim(aDocOri[nCount][doDTC_CTEID]))
							oDacte:Say(nLInic, 0003, "CT-E CHAVE:", oFont08)
							oDacte:Say(nLInic, 0073, cChaveA, oFont08)
							cChaveA := ''
						ElseIf Empty(AllTrim(aDocOri[nCount][doDTC_NFEID]))
							//-- Imprime os dados do documento não fiscal do lado esquerdo.
							oDacte:Say(nLInic, 0003, "OUTROS", oFont08)
							oDacte:Say(nLInic, 0033, Transform(AllTrim(cRemCNPJ),"@r 99.999.999/9999-99"), oFont08)
							oDacte:Say(nLInic, 0163, AllTrim(aDocOri[nCount][doDTC_NUMNFC]), oFont08)						
						Else
							//-- Imprime a Chave da NF-e, lado esquerdo
							cChaveA := AllTrim(aDocOri[nCount][doDTC_NFEID])
							oDacte:Say(nLInic, 0003, "NF-E CHAVE:", oFont08)
							oDacte:Say(nLInic, 0073, SUBSTR(cChaveA,1,22), oFont08)
							oDacte:Say(nLInic, 0168, SUBSTR(cChaveA,23,3) + " " + SUBSTR(cChaveA,26,9), oFont08N)
							oDacte:Say(nLInic, 0223, SUBSTR(cChaveA,35,10), oFont08)
							cChaveA := ''
						EndIf

					Else
						If Empty(AllTrim(aDocOri[nCount][doDTC_NFEID])) .And. !Empty(AllTrim(aDocOri[nCount][doDTC_SERNFC]))
							//-- Imprime a Chave da NF-e, lado direito
							oDacte:Say(nLInic, 0286, "NF", oFont08)
							oDacte:Say(nLInic, 0316, Transform(AllTrim(cRemCNPJ),"@r 99.999.999/9999-99"), oFont08)
							oDacte:Say(nLInic, 0448, AllTrim(aDocOri[nCount][doDTC_SERNFC]) + " / " + AllTrim(aDocOri[nCount][doDTC_NUMNFC]), oFont08)
						ElseIf Len(aDocOri[nCount]) >= doDTC_CTEID .And. !Empty(AllTrim(aDocOri[nCount][doDTC_CTEID])) 
							//-- Imprime a Chave da CT-e docAnt, lado direito
							cChaveB := (AllTrim(aDocOri[nCount][doDTC_CTEID]))
							oDacte:Say(nLInic, 0286, "CT-E CHAVE:", oFont08)
							oDacte:Say(nLInic, 0356, cChaveB, oFont08)
							cChaveB := ''
						ElseIf Empty(AllTrim(aDocOri[nCount][doDTC_NFEID]))
							//-- Imprime os dados do documento não fiscal do lado direito.
							oDacte:Say(nLInic, 0286, "OUTROS", oFont08)
							oDacte:Say(nLInic, 0316, Transform(AllTrim(cRemCNPJ),"@r 99.999.999/9999-99"), oFont08)
							oDacte:Say(nLInic, 0448, AllTrim(aDocOri[nCount][doDTC_NUMNFC]), oFont08)
						Else
							//-- Imprime a Chave da NF-e, lado direito
							cChaveB := AllTrim(aDocOri[nCount][doDTC_NFEID])
							oDacte:Say(nLInic, 0286, "NF-E CHAVE:", oFont08)
							oDacte:Say(nLInic, 0356, SUBSTR(cChaveB,1,22), oFont08)
							oDacte:Say(nLInic, 0451, SUBSTR(cChaveB,23,3) + " " + SUBSTR(cChaveB,26,9), oFont08N)
							oDacte:Say(nLInic, 0506, SUBSTR(cChaveB,35,10), oFont08)
							cChaveB := ''
						EndIf
					EndIf
				ElseIf lControl
					If Empty(AllTrim(aDocOri[nCount][doDTC_NFEID])) .And. !Empty(AllTrim(aDocOri[nCount][doDTC_SERNFC]))
						oDacte:Say(nLInic, 0003, "NF", oFont08)
						oDacte:Say(nLInic, 0033, Transform(AllTrim(cRemCNPJ),"@r 99.999.999/9999-99"), oFont08)
						oDacte:Say(nLInic, 0163, AllTrim(aDocOri[nCount][doDTC_SERNFC]) + " / " + AllTrim(aDocOri[nCount][doDTC_NUMNFC]), oFont08)
					ElseIf Empty(AllTrim(aDocOri[nCount][doDTC_NFEID]))
						oDacte:Say(nLInic, 0003, "OUTROS", oFont08)
						oDacte:Say(nLInic, 0033, Transform(AllTrim(cRemCNPJ),"@r 99.999.999/9999-99"), oFont08)
						oDacte:Say(nLInic, 0163, AllTrim(aDocOri[nCount][doDTC_NUMNFC]), oFont08)					
					Else
						//-- Imprime a Chave da NF-e, lado direito
						cChaveA := AllTrim(aDocOri[nCount][doDTC_NFEID])
						oDacte:Say(nLInic, 0003, "NF-E CHAVE:", oFont08)
						oDacte:Say(nLInic, 0073, cChaveA, oFont08)
						cChaveA := ''
					EndIf
					If !Empty(cCtrDpc)
						If Empty(cCTEDocAnt)
							oDacte:Say(nLInic, 0286, cDesDocAnt, oFont08)
							oDacte:Say(nLInic, 0316, Transform(AllTrim((cAliasCT)->DPC_CNPJ),"@r 99.999.999/9999-99"), oFont08)
							oDacte:Say(nLInic, 0448, AllTrim(cSerDpc) + " / " + AllTrim(cCtrDpc), oFont08)
						Else
							//-- Imprime a Chave da NF-e, lado esquerdo
							cChaveB := AllTrim(cCTEDocAnt)
							oDacte:Say(nLInic, 0286, "NF-E CHAVE:", oFont08)
							oDacte:Say(nLInic, 0356, cChaveB, oFont08)
							cChaveB := ''
						EndIf
					EndIf
				EndIf
			Else
				cTipoDoc := IIf(Empty(AllTrim(aDocOri[nCount][doDTC_NFEID])) .And. Empty(AllTrim(aDocOri[nCount][doDTC_SERNFC])),'Outros',IIf(Empty(AllTrim(aDocOri[nCount][doDTC_NFEID])),'NF','NF-e'))
				If cTipoDoc == 'Outros' .And. !Empty(AllTrim(aDocOri[nCount][doDTC_CTEID]))
					cTipoDoc := 'CT-e'
					aadd(aDoc,{ AllTrim(cRemCNPJ), AllTrim(aDocOri[nCount][doDTC_SERNFC]) + " / " + AllTrim(aDocOri[nCount][doDTC_NUMNFC]),	AllTrim(aDocOri[nCount][doDTC_CTEID]), cTipoDoc})					
				Else
					aadd(aDoc,{ AllTrim(cRemCNPJ),;
						AllTrim(aDocOri[nCount][doDTC_SERNFC]) + " / " + AllTrim(aDocOri[nCount][doDTC_NUMNFC]),;
						AllTrim(aDocOri[nCount][doDTC_NFEID]),cTipoDoc})
				 		//--Acrescenta o Tipo do Documento no aDoc
				EndIf
			EndIf

			// FORCAR A "QUEBRA" DA LINHA
			If ( (mod(nCount,2)) == 0 )
				If nCount < 11
					If !Empty(cChaveA)
						nLInic += 0008
						oDacte:Say(nLInic, 0003, "NF-E CHAVE:", oFont08)
						oDacte:Say(nLInic, 0073, cChaveA, oFont08)
						cChaveA := ''
					
						If !Empty(cChaveB)
							oDacte:Say(nLInic, 0286, "NF-E CHAVE:", oFont08)
							oDacte:Say(nLInic, 0356, cChaveB, oFont08)
							cChaveB := ''
						EndIf
					EndIf
					
					nLInic += 0008
				EndIf
			EndIf
		Next nCount
		nLInic := 2050
	Else
		TMSR31Cmp()
		TMSR31Comp()
	EndIf
	
	// BOX: PREVISÃO DO FLUXO CARGA
	oDacte:Box(0561 , 0000, 0590, 0559)
	oDacte:Say(0568,  0245, "Previsão do Fluxo de Carga", oFont08N)
	oDacte:Line(0569, 0000, 0569, 0559)	// Linha: Abaixo    
	oDacte:Say(0575,  0003, "Sigla ou Código da Filial/Porto/Estação/Aeroporto de Origem", oFont07)
	oDacte:Say(0583,  0003, cOriUFPre, oFont07)
	oDacte:Say(0575,  0188, "Sigla ou Código da Filial/Porto/Estação/Aeroporto de Passagem", oFont07)
	oDacte:Say(0575,  0374, "Sigla ou Código da Filial/Porto/Estação/Aeroporto de Destino", oFont07)
	oDacte:Say(0583,  0374, cDesUFPre, oFont07)
	oDacte:Line(0569, 0186, 0590, 0186)	// Linha: Separadoras
	oDacte:Line(0569, 0372, 0590, 0372)	// Linha: Separadoras

	// BOX: OBSERVACOES GERAIS
	oDacte:Box(0592,  0000, 0683, 0559)	
	oDacte:Say(0598,  0258, "Observações Gerais", oFont08N)
	oDacte:Line(0600, 0000, 0600, 0559) // Linha: OBSERVACOES
    nCountObs := 9
	If (cAliasCT)->DT6_AMBIEN == 2 .And. Empty((cAliasCT)->DT6_CHVCTG)
		cObsStat := "DOCUMENTO GERADO EM AMBIENTE DE HOMOLOGAÇÃO"
		nCountObs -= 1
		cTagObs := 'OBSGER1;'
	ElseIf !Empty((cAliasCT)->DT6_CHVCTG) .And. Substr((cAliasCT)->DT6_CHVCTG,3,1) == "5"  //"7-Contingência FS-DA"
		cObsStat := "DACTE em Contingência - impresso em decorrência de problemas técnicos"
		nCountObs -= 1
		cTagObs := 'OBSGER1;' 
	EndIf

	// BOX: OBSERVACOES
	dbSelectArea("DT6") //-- Nao retirar
	cDT6Obs := " "
	If XmlChildEx(oNfe:_CTE:_INFCTE:_IMP,'_INFADFISCO') == Nil
		cDT6Obs := " "
	Else
		cDT6Obs := oNfe:_CTE:_INFCTE:_IMP:_INFADFISCO:TEXT
	EndIf
	cObsProp := " "
	If (XmlChildEx(oNFE:_CTE:_INFCTE,'_INFCTENORM')) <> Nil .And. ;
		XmlChildEx(oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL,'_RODO') != Nil .AND. ;
		XmlChildEx(oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO,'_VEIC') != Nil .And. ;
		XmlChildEx(oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_VEIC,'_PROP') != Nil .And. ;
		XmlChildEx(oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_VEIC:_PROP,'_XNOME') != Nil .And.;
		XmlChildEx(oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_VEIC,'_TPPROP') != Nil
		If oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_VEIC:_TPPROP:TEXT == 'T'
			cObsProp += " Proprietario : " + AllTrim(oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_VEIC:_PROP:_XNOME:TEXT)			
		EndIf
	EndIf
	cDTCObs := " "

	If XmlChildEx(oNfe:_CTE:_INFCTE,'_COMPL') != Nil 
		If XmlChildEx(oNfe:_CTE:_INFCTE:_COMPL,'_XOBS') != Nil
			cDTCObs += oNfe:_CTE:_INFCTE:_COMPL:_XOBS:TEXT
		EndIf
		If XmlChildEx(oNfe:_CTE:_INFCTE:_COMPL, '_OBSCONT') <> Nil
			If ValType(oNfe:_CTE:_INFCTE:_COMPL:_OBSCONT) == "A"
				aObsCont := {}
				For nX := 1 to len(oNfe:_CTE:_INFCTE:_COMPL:_OBSCONT)
					aAdd(aObsCont, oNfe:_CTE:_INFCTE:_COMPL:_OBSCONT[nX]:_XTEXTO:TEXT )
				Next nX
			ElseIf XmlChildEx(oNfe:_CTE:_INFCTE:_COMPL:_OBSCONT,'_XTEXTO') == Nil
				aObsCont := {""}
			Else
				aObsCont := {oNfe:_CTE:_INFCTE:_COMPL:_OBSCONT:_XTEXTO:TEXT}
			EndIf
		EndIf
	EndIf
	// Agendamento de Entrega
	If AliasIndic("DYD")
		If DYD->(FieldPos("DYD_DIAATR"))>0
			cDT6Obs += (" "+Posicione("DYD",2,xFilial("DYD")+(cAliasCT)->DT6_FILDOC+(cAliasCT)->DT6_DOC+(cAliasCT)->DT6_SERIE,"DYD_MOTAGD"))
		EndIf
	EndIf

	cDT6Obs3:= SubStr(cDT6Obs,281,140)
	cDT6Obs2:= SubStr(cDT6Obs,141,140)
	cDT6Obs := SubStr(cDT6Obs,  1,140)
	//-- Popula o vetor de observações
	cObsProp:= SubStr(cObsProp,  1,140)
	nObsStart := 1
	For nCountDTC := 1 To Len(aDTCObserv)		
		aDTCObserv[nCountDTC] := SubStr(cDTCObs ,  nObsStart,140)
		//--Atualiza Tags
		cTagObs += "OBSDTC"+AllTrim(Str(nCountDTC))+";"
		nCountObs -= 1
		nObsStart += 140
	Next nCountDTC
	
	// Tratamento para aproveitar todo o espaco do quadro observacao
	if !Empty(cDT6Obs)
	  nCountObs -= 1
	  cTagObs += 'OBSDT61;' 
	EndIf
	
	if !Empty(cDT6Obs2)
	  nCountObs -= 1
	  cTagObs += 'OBSDT62;' 
	EndIf

	if !Empty(cObsProp)
	  nCountObs -= 1
	  cTagObs  += 'OBSPRO1;' 
	EndIf
	
	// If (nCountObs > 0) .AND. (!Empty(cDTCObs2))
	//   nCountObs -= 1
	//   cTagObs += 'OBSDTC2;' 
	// EndIf
	
	If (nCountObs > 0) .AND. (!Empty(cDT6Obs3))
	  nCountObs -= 1
	  cTagObs += 'OBSDT63;' 
	EndIf

	nLinhaObs := 0608
	if AT('OBSGER1;',cTagObs) > 0
	  oDacte:Say (nLinhaObs, 0003, cObsStat, oFont10N)
	  nLinhaObs += 8  
	EndIF
	
	if AT('OBSDT61;',cTagObs) > 0
	  oDacte:Say (nLinhaObs, 0003, cDT6Obs, oFont07)
	  nLinhaObs += 8  
	EndIF
	
	if AT('OBSDT62;',cTagObs) > 0
	  oDacte:Say (nLinhaObs, 0003, cDT6Obs2, oFont07)
	  nLinhaObs += 8  
	EndIF
	
	if AT('OBSDT63;',cTagObs) > 0
	  oDacte:Say (nLinhaObs, 0003, cDT6Obs3, oFont07)
	  nLinhaObs += 8  
	EndIF
	
	//-- Realiza a impressão da observações gerais
	For nCountDTC := 1 To Len(aDTCObserv)
		If AT("OBSDTC" + AllTrim(Str(nCountDTC)) + ";",cTagObs) > 0
			oDacte:Say (nLinhaObs, 0003, aDTCObserv[nCountDTC], oFont07)
			nLinhaObs += 8
		EndIF
	Next nCountDTC
	
	if AT('OBSPRO1;',cTagObs) > 0
	  oDacte:Say (nLinhaObs, 0003, cObsProp, oFont07)
	  nLinhaObs += 8  
	End IF		

	// BOX: INFORMACOES ESPECIFICAS DO MODAL
	nLinIEM := 40
	If  oNfe:_CTE:_INFCTE:_IDE:_modal:TEXT == "06" // do tipo MultiModal 
		oDacte:Box(0688+nLinIEM, 0000, 0717+nLinIEM, 0559)
		oDacte:Say(0651+nLinIEM, 0210, "Informações Específicas do Transporte Multimodal de Cargas", oFont08N)
		oDacte:Line(0654+nLinIEM, 0000, 0654+nLinIEM, 0559)
		oDacte:Say(0664+nLinIEM, 0003, "COTM da Empresa: " + cTmsCOTM	, oFont08)

		If (XmlChildEx(oNFE:_CTE:_INFCTE,'_INFCTENORM')) <> Nil .And. (XmlChildEx(oNFE:_CTE:_INFCTE:_INFCTENORM:_INFMODAL,'_MULTIMODAL')) <> NIL //Existe Stru da MultiModal.
			cIndNegoci := oNFE:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_MULTIMODAL:_indNegociavel:TEXT

			oDacte:Box(0658+nLinIEM, 0295, 0666+nLinIEM, 0285)
			oDacte:Say(0664+nLinIEM, 0300, "Negociável" , oFont08)	 
			
			oDacte:Box(0658+nLinIEM, 0350, 0666+nLinIEM, 0360)
			oDacte:Say(0664+nLinIEM, 0368, "Não Negociável" , oFont08)
			
			If (cIndNegoci == "1") 			
				oDacte:Say(0664+nLinIEM, 0287, "X" /* DTC_INDNEG */	, oFont08) 
			Else
				oDacte:Say(0664+nLinIEM, 0352, "X" /* DTC_INDNEG */	, oFont08)
			EndIf
		EndIf
	Else
		oDacte:Box(0645+nLinIEM, 0000, 0672+nLinIEM, 0559)
		oDacte:Say(0651+nLinIEM, 0210, "Informações do Modal Rodoviário", oFont08N)
		oDacte:Line(0654+nLinIEM, 0000, 0654+nLinIEM, 0559)
		oDacte:Say(0661+nLinIEM, 0003, "RNTRC da Empresa: " + cTmsAntt	, oFont08)
	EndIf

	// BOX: USO EXCLUSIVO DO EMISSOR + RESERVADO AO FISCO
	oDacte:Box(0674+nLinIEM , 0000, 0720+nLinIEM, 0559)  
	oDacte:Say(0681+nLinIEM , 0090, "USO EXCLUSIVO DO EMISSOR DO CT-E", oFont08N)
	nSoma := 0
	For nX := 1 to len(aObsCont)
		If nX > 3
			Exit
		EndIf
		oDacte:Say(0690 + nSoma+nLinIEM, 0003, aObsCont[nX], oFont08)
		nSoma += 10
	Next
	oDacte:Say(0681+nLinIEM , 0420, "RESERVADO AO FISCO", oFont08N)
	oDacte:Line(0683+nLinIEM, 0000, 0683+nLinIEM, 0559)	//Linha Horizontal
	oDacte:Line(0674+nLinIEM, 0355, 0720+nLinIEM, 0355)	//Linha Vertical

	// Atualizar o Status de Impressao no CTe
	DT6->(dbSetOrder(1))
	If	DT6->(MsSeek(xFilial('DT6')+(cAliasCT)->DT6_FILDOC+(cAliasCT)->DT6_DOC+(cAliasCT)->DT6_SERIE))
		RecLock('DT6',.F.)
		DT6->DT6_FIMP := StrZero(1, Len(DT6->DT6_FIMP)) //Grava Flag de Impressao
		MsUnLock()
	EndIf
	oDacte:EndPage()

	//-- aDoc > 0, existe mais de uma pagina com Doc a ser impressa.
	//-- lPerig .T. existem produtos perigosos a serem impressos.
	If Len(aDoc) > 0 .OR. lPerig
		//-- Caso de mais de uma pagina, chama a funcao para montar as paginas seguites.
		TMSR35Cont( aDoc, aCab[nCont] )
	EndIf
	(cAliasCT)->(DbSkip())
EndDo

// TERMINO ROTINA DE IMPRESSAO
oDacte:Preview()

(cAliasCT)->(dbCloseArea())

Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |TMSR35Cont³ Autor ³Felipe Barbiere           ³ Data ³01/10/12  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ³±±
±±³Descri‡…o ³Caso de mais de uma pagina, chama a funcao para montar      ³±±
±±³          ³as paginas seguites.                                        ³±±
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
Static Function TMSR35Cont(aDoc, aCab, aPerigo, nCnt)
Local oFont08	:= TFont():New( "Times New Roman", 08, 08, , .F., , , , .T., .F. )
Local oFont08N	:= TFont():New( "Times New Roman", 08, 08, , .T., , , , .T., .F. )
Local lControl	:= .F.
Local nCount	:= 0
Local aDoc1		:= {}
Local cChaveA	:= ''
Local cChaveB	:= ''

//Variaveis Produtos Perigosos
Local nCompr	:= 42	//Comprimento Padrao da Primeira Linha
Local nSegLinha	:= 1	//Trecho a ser Impresso para cada linha
Local lVerif	:= .F.	//Evita Repeticao de Impressao
Local lVerifCls := .F.
Local lFimPerig	:= .F.

Default nCnt	:= 1
Default aPerigo	:= {}
Default aDoc	:= {}
Default aCab	:= {}

oDacte:StartPage()
oDacte:SetPaperSize( Val( GetProfString( GetPrinterSession(), "PAPERSIZE", "1", .T. ) ) )

// Funcao responsavel pela montagem do cabecalho do DACTE
TMSR31Cab( aCab, .F. )

// BOX: DOCUMENTOS ORIGINARIOS
oDacte:Box(	0224, 0000, 0593, 0559)
oDacte:Say(	0230, 0210, "Documentos Originários",	oFont08N )
oDacte:Line(0232, 0000, 0232, 0559)							// Linha: DOCUMENTOS ORIGINARIOS
oDacte:Line(0232, 0280, 0593, 0280)							// Linha: Separador DOCUMENTOS ORIGINARIOS
oDacte:Say(	0238, 0003, "Tp.Doc",					oFont08N )

If Len(aDoc) > 0 .AND. Empty(AllTrim(aDoc[1][3]))
	oDacte:Say( 0238, 0033, "CNPJ/CPF Emitente",	oFont08N )
EndIf

oDacte:Say(	0238, 0163, "Série/Nr.Documento",		oFont08N )
oDacte:Say(	0238, 0286, "Tp.Doc",					oFont08N )

If Len(aDoc) > 0 .AND. Empty(AllTrim(aDoc[1][3]))
	oDacte:Say( 0238, 0316, "CNPJ/CPF Emitente",	oFont08N )
Endif

oDacte:Say( 0238, 0448, "Série/Nr.Documento",		oFont08N )

// Imprime as NF
lControl := .F.
nLInic := 0244
For nCount := 1 To Len(aDoc)
	lControl := !lControl

	If nCount < 75         
		If (lControl == .T.)			
			If Empty(aDoc[nCount,3])
				oDacte:Say(nLInic, 0003, aDoc[nCount,4],										oFont08)
				oDacte:Say(nLInic, 0033, Transform(aDoc[nCount,1],"@r 99.999.999/9999-99"),		oFont08)
				oDacte:Say(nLInic, 0163, aDoc[nCount,2],										oFont08)
			ElseIf Upper(aDoc[nCount,4]) == "CT-E"
				cChaveA     := aDoc[nCount,3]
				oDacte:Say(nLInic, 0003, "CT-E CHAVE:",											oFont08)
				oDacte:Say(nLInic, 0073, cChaveA,												oFont08)
				cChaveA := ''
			Else
				cChaveA     := aDoc[nCount,3]
				oDacte:Say(nLInic, 0003, "NF-E CHAVE:",											oFont08)
				oDacte:Say(nLInic, 0073, SUBSTR(cChaveA,1,22),									oFont08)
				oDacte:Say(nLInic, 0168, SUBSTR(cChaveA,23,3) + " " + SUBSTR(cChaveA,26,9),		oFont08N)
				oDacte:Say(nLInic, 0223, SUBSTR(cChaveA,35,10),									oFont08)
				cChaveA     := ''
			EndIf
			
		Else
			If Empty(aDoc[nCount,3])
				oDacte:Say(nLInic, 0286, aDoc[nCount,4],									    oFont08)
				oDacte:Say(nLInic, 0316, Transform(aDoc[nCount,1],"@r 99.999.999/9999-99"),		oFont08)
				oDacte:Say(nLInic, 0448, aDoc[nCount,2],										oFont08)
			ElseIf Upper(aDoc[nCount,4]) == "CT-E"
				cChaveB     := aDoc[nCount,3]
				oDacte:Say(nLInic, 0286, "CT-E CHAVE:",											oFont08)
				oDacte:Say(nLInic, 0356, cChaveB,												oFont08)
				cChaveB := ''
			Else
				cChaveB     := aDoc[nCount,3]
				oDacte:Say(nLInic, 0286, "NF-E CHAVE:",											oFont08)
				oDacte:Say(nLInic, 0356, SUBSTR(cChaveB,1,22),									oFont08)
				oDacte:Say(nLInic, 0451, SUBSTR(cChaveB,23,3) + " " + SUBSTR(cChaveB,26,9),		oFont08N)
				oDacte:Say(nLInic, 0506, SUBSTR(cChaveB,35,10),									oFont08)
				cChaveB     := ''
			EndIf
			nLInic += 0008
		EndIf		
	Else
		AAdd( aDoc1, { aDoc[nCount,1], aDoc[nCount,2], aDoc[nCount,3], aDoc[nCount,4] } )
	EndIf
	
Next nCount

// Imprime a ultima Chave.
// FORCAR A "QUEBRA" DA LINHA
If !Empty(cChaveA)
	nLInic += 0008
	oDacte:Say(nLInic, 0003, "NF-E CHAVE:",		oFont08)
	oDacte:Say(nLInic, 0073,cChaveA ,			oFont08)
	cChaveA := ''

	If !Empty(cChaveB)
		oDacte:Say(nLInic, 0286, "NF-E CHAVE:",	oFont08)
		oDacte:Say(nLInic, 0356, cChaveB,		oFont08)
		cChaveB := ''
	EndIf
EndIf

// BOX: Produtos Perigosos
cAliasPeri := DataSource("PRODUTOS_PERIGOSOS")
nSoma   := 1380
nQtdTotal := 0

If (cAliasPeri)->(!Eof())
	nDifEsq:= 110
	nLInic := 2214
	oDacte:Box(0645 , 0000, 0820, 0559)
	oDacte:Say(0651 , 0200, "Informações sobre Produtos Perigosos", oFont08N)
	nSoma  := 12
	oDacte:Line(0653, 0000, 0653, 0559)		// Linha Horizontal
	oDacte:Line(0653, 0032, 0820, 0032 )	// Linha Divisoria Nro. Onu X Nome Apropriado
	oDacte:Line(0653, 0262, 0820, 0262 )	// Linha Divisoria Nome Apropriado X Classe/Subclasse e Risco Subsidiário
	oDacte:Line(0653, 0470, 0820, 0470 )	// Linha Divisoria Classe Subclasse e Risco Subsidiário X Grupo de Embalagem	
	oDacte:Line(0653, 0511, 0820, 0511 )	// Linha Divisoria Grupo de Embalagem X Qto. Tot. Produto	
	
	oDacte:Say(0659 , 0002, "Nº Onu"			, oFont08N)
	oDacte:Say(0659 , 0035, "Nome Apropriado" 	, oFont08N)
	oDacte:Say(0659 , 0265, "Classe/Subclasse e Risco Subsidiário", oFont08N)
	oDacte:Say(0659 , 0474, "Grp.Emb.", oFont08N)
	oDacte:Say(0659 , 0513, "Qtde.Produto" , oFont08N)
	nLInic :=  0670
	
	If Len(aPerigo) <= 0
		Do While (cAliasPeri)->(!EoF())
			If DTC_PESO == 0
				nQtdTotal := Str(DTC_QTDVOL)
			Else
				nQtdTotal := Str(DTC_PESO)
			EndIf
			AAdd(aPerigo,{	(cAliasPeri)->DY3_ONU,;
							(cAliasPeri)->DY3_DESCRI,;
							AllTrim((cAliasPeri)->DY3_CLASSE) + ' ' + (cAliasPeri)->DY3_NRISCO, ;
							(cAliasPeri)->DY3_GRPEMB,;
							(cAliasPeri)->(nQtdTotal)})
			(cAliasPeri)->(dbSkip())
		EndDo
	Else
		If DTC_PESO == 0
			nQtdTotal := Str(DTC_QTDVOL)
		Else
			nQtdTotal := Str(DTC_PESO)
		EndIf	
	EndIf

	For nCnt := nCnt to Len(aPerigo)														//Verifica tamanho do array
		oDacte:Say(nLInic , 0002,     aPerigo[nCnt][1]   , oFont08)							//Nro. Onu
		For nSegLinha:= nSegLinha To Len(aPerigo[nCnt][2])									
			oDacte:Say(nLInic , 0035,Substr(aPerigo[nCnt][2],nSegLinha,nCompr), oFont08)	//Nome Apropriado 																										
			If !lVerif
				oDacte:Say(nLInic , 0265, aPerigo[nCnt][3]  , oFont08)		//Classe/Subclasse e Risco Subsidiário - Maximo 33 Caracteres
				oDacte:Say(nLInic , 0477,aPerigo[nCnt][4] 	, oFont08)						//Grupo de Embalagem
				oDacte:Say(nLInic , 0510,aPerigo[nCnt][5]	, oFont08)						//Qto. Tot. Produto
				lVerif := .T.
			EndIf
			nSegLinha += nCompr -1
			If Len(aPerigo[nCnt][2]) > nSegLinha
				nLInic += 0008
			EndIf
			If nLInic >= 0770		//Verifica se chegou ao fim da pagina
				lFimPerig := .T.
				Exit
			EndIf
		Next
		If lFimPerig
			Exit
		EndIf
		nSegLinha := 1
		lVerif	:= .F. // Reinicia valor para o proximo elemento
		lVerifCls := .F.
	Next
	nCnt++
EndIf

(cAliasPeri)->(DbCloseArea())

// Linha de finalizacao.
oDacte:EndPage()

// Se existir mais doc para outra pagina, chama a mesma funcao.
If Len(aDoc1) > 1
	TMSR35Cont(aDoc1,aCab)
EndIf

// Se existir mais prod perigoso para outra pagina, chama a mesma funcao.
If nLInic >= 0820
	TMSR35Cont(,aCab,aPerigo,nCnt)
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ TMSR31Cab³ Autor ³Felipe Barbiere           ³ Data ³01/10/12  ³±±
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

Default lXmlCont := .F.
Default lImpCan  := .F.

If	IsSrvUnix() .And. GetRemoteType() == 1
	cLogoTp := StrTran(cLogoTp,"/","\")
Endif

If  !File(cLogoTp)
	cLogoTp    := cStartPath + "logoCte.bmp"
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BOX: CANHOTO - 0746                                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If	lImpCan

	_cCgcDev :=Posicione("SA1",1,xFilial("SA1")+(cAliasCT)->DT6_CLIDEV+(cAliasCT)->DT6_LOJDEV,"A1_CGC")
	_cNomDev :=Posicione("SA1",1,xFilial("SA1")+(cAliasCT)->DT6_CLIDEV+(cAliasCT)->DT6_LOJDEV,"A1_NOME")
	_cMunDev :=Posicione("SA1",1,xFilial("SA1")+(cAliasCT)->DT6_CLIDEV+(cAliasCT)->DT6_LOJDEV,"A1_MUN")
	_cEstDev :=Posicione("SA1",1,xFilial("SA1")+(cAliasCT)->DT6_CLIDEV+(cAliasCT)->DT6_LOJDEV,"A1_EST")
	
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
	oDacte:Say(0047 , 0421, "Término Prest.Data/Hora"	, oFont07N)
	oDacte:Say(0047 , 0530, "CT-E"					, oFont07N)
	oDacte:Say(0057 , 0518, "No DOC. " , oFont07N)
	oDacte:Say(0067 , 0518, cValtoChar( Val(aCab[1]))	, oFont07N)
	oDacte:Say(0079 , 0518, "SÉRIE: "+cValtoChar( Val(aCab[2]))	, oFont07N)
	oDacte:Say(0070 , 0005, "RG"                	, oFont07N)
	oDacte:Say(0079 , 0241, "ASSINATURA / CARIMBO"  , oFont07N)
	oDacte:Say(0070 , 0421, "Início Prest.Data/Hora"  	, oFont07N)
EndIf

oDacte:Box(0086, 0000, 0148, 0240)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BOX: Empresa + 0050                                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oDacte:SayBitmap(0088, 0005,cLogoTp,0088,0057 )		//Logo

If XmlChildEx(oNfe:_CTE:_INFCTE,'_EMIT') <> Nil
	oDacte:Say(0100, 0090, AllTrim(oNfe:_CTE:_INFCTE:_EMIT:_XNOME:Text),oFont07) 	//Nome Comercial
	oDacte:Say(0110, 0090, 'CNPJ ' + Transform(AllTrim(oNfe:_CTE:_INFCTE:_EMIT:_CNPJ:TEXT),"@r 99.999.999/9999-99") +;
						   ' - IE ' + Iif(XmlChildEx(oNfe:_CTE:_INFCTE:_EMIT,'_IE'  )==NIL," ",AllTrim(oNfe:_CTE:_INFCTE:_EMIT:_IE:TEXT)), oFont07)
	oDacte:Say(0120, 0090, AllTrim(oNfe:_CTE:_INFCTE:_EMIT:_ENDEREMIT:_XLGR:TEXT) + ;
						   ", "+ AllTrim(oNfe:_CTE:_INFCTE:_EMIT:_ENDEREMIT:_NRO:TEXT) +;
						   Iif(XmlChildEx(oNfe:_CTE:_INFCTE:_EMIT:_ENDEREMIT,'_XCPL')==Nil, " ", " " + AllTrim(oNfe:_CTE:_INFCTE:_EMIT:_ENDEREMIT:_XCPL:TEXT) + " ") +;
						   AllTrim(oNfe:_CTE:_INFCTE:_EMIT:_ENDEREMIT:_XBAIRRO:TEXT), oFont07)	//Endereço + Bairro      
	oDacte:Say(0130, 0090, AllTrim(oNfe:_CTE:_INFCTE:_EMIT:_ENDEREMIT:_XMUN:TEXT) + '  -  ' +;
					       AllTrim(oNfe:_CTE:_INFCTE:_EMIT:_ENDEREMIT:_UF:TEXT) + ;
						   '  CEP:  ' + Transform(AllTrim(AllTrim(oNfe:_CTE:_INFCTE:_EMIT:_ENDEREMIT:_CEP:TEXT)), "@r 99999-999") ,oFont07)	//Cidade, UF, CEP
	oDacte:Say(0140, 0090, AllTrim(Iif(XmlChildEx(oNfe:_CTE:_INFCTE:_EMIT:_ENDEREMIT,'_FONE')==Nil," ",oNfe:_CTE:_INFCTE:_EMIT:_ENDEREMIT:_FONE:TEXT))	,oFont07)	//Telefone
Else
	oDacte:Say(0100, 0090, AllTrim(SM0->M0_NOMECOM),oFont07) 	//Nome Comercial
	oDacte:Say(0110, 0090, 'CNPJ ' + Transform(AllTrim(SM0->M0_CGC),"@r 99.999.999/9999-99") + ' - IE ' + AllTrim(SM0->M0_INSC), oFont07)
	oDacte:Say(0120, 0090, AllTrim(SM0->M0_ENDCOB) + ' ' + AllTrim(SM0->M0_BAIRCOB), oFont07)	//Endereço + Bairro      
	oDacte:Say(0130, 0090, AllTrim(SM0->M0_CIDCOB) + '  -  ' + AllTrim(SM0->M0_ESTCOB) + '  CEP:  ' + AllTrim(SM0->M0_CEPCOB) ,oFont07)	//Cidade, UF, CEP
	oDacte:Say(0140, 0090, AllTrim(SM0->M0_TEL)	,oFont07)	//Telefone
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BOX: DACTE                                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oDacte:Box(0086, 0240, 0133, 0377)					
oDacte:Say(0095, 292, "DACTE", oFont10N)
oDacte:Say(0105, 243, "Documento Auxiliar do Conhecimento", oFont08N)
oDacte:Say(0116, 265, "de Transporte Eletrônico", oFont08N)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BOX: MODAL                                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oDacte:Box(0086, 0377, 0133, 0433)
oDacte:Say(0093, 390,"MODAL"     ,oFont08N)
If oNfe:_CTE:_INFCTE:_IDE:_modal:TEXT == "06" // do tipo MultiModal
	oDacte:Say(0116, 380,Upper("MULTIMODAL"),oFont08 ) 
Else
	oDacte:Say(0116, 380,Upper("Rodoviário"),oFont08 ) 
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BOX: FOLHA
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oDacte:Box(0086, 0433, 0133, 0460)
oDacte:Say(0093, 0435, "Folha"  , oFont08N)	//Folha
oDacte:Say(0116, 0437, AllTrim(Str(nFolhAtu)) + " / " + AllTrim(Str(nFolhas)), oFont08)
nFolhAtu ++

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³QRCODE ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
If XmlChildEx( oNfe:_CTE,'_INFCTESUPL') != Nil
	If XmlChildEx( oNfe:_CTE:_INFCTESUPL,'_QRCODCTE' ) != NIL .And. !Empty(oNFE:_CTE:_INFCTESUPL:_QRCODCTE:TEXT  )
		cQrCode := oNfe:_CTE:_INFCTESUPL:_QRCODCTE:TEXT
		If lXmlCont //Contingencia
			nPosSign := At("&sign", cQrCode)
			cQrCode := Substr(cQrCode, 1, nPosSign - 1)
		EndIf 
	EndIf
EndIf
oDacte:QRCODE(190, 466, cQrCode, 90)	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³BOX: Modelo / Serie / Numero / Emis                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oDacte:Box(0125, 0240, 0148, 0270)
oDacte:Say(0133, 0242, "Modelo", oFont08N)	//Modelo
oDacte:Say(0144, 0242, "57", oFont08)

oDacte:Box(0125, 0270, 0148 , 0294)
oDacte:Say(0133, 0272, "Série"  , oFont08N)	//Serie
oDacte:Say(0144, 0272, cValtoChar( Val(aCab[2]) ), oFont08)

oDacte:Box(0125, 0294, 0148, 0333)
oDacte:Say(0133, 0295, "Número" , oFont07N)	//Numero
oDacte:Say(0144, 0295, cValtoChar( Val(aCab[1]) ), oFont08)

oDacte:Box(0125, 0333, 0148, 0396)
oDacte:Say(0133, 0334, "Emissão", oFont07N) //Emissao
oDacte:Say(0144, 0334, 	SubStr(AllTrim(aCab[3]), 7, 2) + '/'   +;
						SubStr(AllTrim(aCab[3]), 5, 2) + "/"   +; 
						SubStr(AllTrim(aCab[3]), 1, 4) + "-" +; 
						SubStr(AllTrim(aCab[4]), 1, 2) + ":"   +;	
						SubStr(AllTrim(aCab[4]), 3, 2) + ":00", oFont07)
oDacte:Box(0125, 0396, 0148, 0460)
oDacte:Say(0133, 0397, "Ins SUFRAMA Des"  , oFont07N)	//Insc. SUFRAMA Destinatário
oDacte:Say(0144, 0397, Iif(XmlChildEx(oNfe:_CTE:_INFCTE,'_DEST') <> Nil .And. XmlChildEx(oNfe:_CTE:_INFCTE:_DEST,'_ISUF') <> Nil, oNfe:_CTE:_INFCTE:_DEST:_ISUF:TEXT, " "), oFont07)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BOX: Controle do Fisco                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oDacte:Box(0173, 0460, 0185, 0460)
If	AllTrim((cAliasCT)->DT6_CHVCTG)<>''
	oDacte:Code128C(172.4,286,(cAliasCT)->DT6_CHVCTE, 24)	
	oDacte:Code128C(208.2,286,(cAliasCT)->DT6_CHVCTG, 23)
Else
	oDacte:Code128C(171.4,286,(cAliasCT)->DT6_CHVCTE, 24)	
	oDacte:Say(0205, 0282, "Consulta em: http://www.cte-fazenda.gov.br/portal", oFont07)
EndIf	
oDacte:Line(0173, 0280, 0173, 0460 )	//Linha Separadora
oDacte:Say( 0178, 0282,"Chave de acesso",oFont07)
If oDacte:nDevice == 2
	oDacte:Say( 0185, 0281, Transform(AllTrim(aCab[5]),"@r 9999999999999999 9999999999999999 999999999999"), oFont07)
Else 
	oDacte:Say( 0185, 0282, Transform(AllTrim(aCab[5]),"@r 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999"), oFont07N)
EndIf

oDacte:Line(0186, 0280, 0186, 0460 )	//Linha Separadora 
oDacte:Line(0209, 0280, 0209, 0559 )	//Linha Separadora
oDacte:Say(0214,  0282, "Protocolo de Autorização de uso", oFont07)
oDacte:Line(0217, 0280, 0217, 0559 )	//Linha Separadora

oDacte:Line(0173, 0460, 0209, 0460 )	//Linha Vertical
oDacte:Line(0209, 0559, 0217, 0559 )	//Linha Vertical

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³  BOX: Tipo do CTe                                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oDacte:Box(0148, 0000, 0170, 0280) 
oDacte:Say(0157, 0003, "Tipo do CT-e"   , oFont08N)
oDacte:Say(0157, 0143, "Tipo de Serviço", oFont08N)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³  BOX: Tipo do CTe  Globalizado                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oDacte:Box(0170, 0000, 0195, 0280)
oDacte:Say(0180, 0003, "Indicador CT-e Globalizado"  , oFont08N)

If XmlChildEx(oNfe:_CTE:_INFCTE:_IDE,'_INDGLOBALIZADO') <> NIL .And. AllTrim(oNfe:_CTE:_INFCTE:_IDE:_INDGLOBALIZADO:Text) == "1"
	oDacte:Say(0190, 0003, "Sim"  , oFont08N)
Else
	oDacte:Say(0190, 0003, "Não"  , oFont08N)
EndIf

oDacte:Say(0180, 0143, "Informações CT-e Globalizado", oFont08N)
oDacte:Line(0148,0140, 0195, 0140)  //Linha Vertical Tipo CT-e / Inf. CT-e Globalizado

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tipo de Conhecimento                                            ³
//³ 0 - Normal                                                      ³
//³ 1 - Complemento de Valores                                      ³
//³ 2 - Emitido em Hipotese de anulacao de Debito                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( AllTrim((cAliasCT)->DT6_DOCTMS) == "8" )
	oDacte:Say(0167,  0003, "COMPLEMENTO"	, oFont08)
ElseIf ( AllTrim((cAliasCT)->DT6_DOCTMS) == "P" )
	oDacte:Say(0167,  0003, "SUBSTITUTO"		, oFont08)	
ElseIf ( AllTrim((cAliasCT)->DT6_DOCTMS) == "M" )
	oDacte:Say(0167,  0003, "ANULACAO"		, oFont08)
Else
	oDacte:Say(0167,  0003, "NORMAL"		, oFont08)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tipo de Servico                                                 ³
//³ 0 - Normal                                                      ³
//³ 1 - SubContratacao                                              ³
//³ 2 - Redespacho                                                  ³
//³ 3 - Redespacho Intermediario                                    ³
//³ 4 - Serviço Vinculado a Multimodal                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ DTC - Notas Fiscais: (Informacao do campo DTC_TIPNFC)           ³
//³   0 - Normal                                                    ³
//³   1 - Devolucao                                                 ³
//³   2 - SubContratacao                                            ³
//³   3 - Dcto Nao Fiscal                                           ³
//³   4 - Exportacao                                                ³
//³   5 - Redespacho                                                ³
//³   6 - Dcto Nao Fiscal 1                                         ³
//³   7 - Dcto Nao Fiscal 2                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cTpServ := oNfe:_CTE:_INFCTE:_IDE:_tpserv:TEXT

If (cTpServ $ '0')
	oDacte:Say(0167, 0145, "NORMAL"				, oFont08)
ElseIf (cTpServ == '1')
	oDacte:Say(0167, 0145, "SUBCONTRATAÇÃO"		, oFont08)
ElseIf (cTpServ == '2')
	oDacte:Say(0167, 0145, "REDESPACHO"			, oFont08)
ElseIf (cTpServ == '3')
	oDacte:Say(0167, 0145, "REDESPACHO INTERM"			, oFont08)	//--Redespacho Intermediário
ElseIf (cTpServ == '4')
	oDacte:Say(0167, 0145, "SERV.VINC.MULTIMODAL"			, oFont08)	//--Serviço vinculado Multimodal
Else
	oDacte:Say(0167, 0145, "NORMAL"				, oFont08)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Numero Protocolo + Data e Hora Autorizacao                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄadminÙ
cProtocolo := aCab[6] + " " + aCab[8] + " " + aCab[9]
oDacte:Say(0214,  0378, cProtocolo, oFont08)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³TMSR27Comp³ Autor ³Felipe Barbiere           ³ Data ³01/10/12  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao responsavel por montar o BOX com as informacoes do   ³±±
±±³          ³componentes do frete e impostos                             ³±±
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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BOX: COMPONENTES DA PRESTACAO                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lComp
	nLInic	:= 0474
	nLFim	:= 0532	
Else
	nLInic	:= 0414
	nLFim	:= 0472	
EndIf

oDacte:Box(nLInic, 0000, nLFim, 0559)

nLInic	+= 0008
oDacte:Say(nLInic, 0210, "Componentes do Valor da Prestação de Serviço", oFont08N)
	
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
oDacte:Say(nLInic, 0423, "Valor Total da Prestação do Serviço", oFont08N)
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Componentes do Valor da Prestacao de Servico                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³DT8 - Componentes do Frete                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ FORCAR A "QUEBRA" DA LINHA, SENDO 6 CAMPOS POR LINHA.                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ FORCAR A "QUEBRA" DA LINHA, SENDO 6 CAMPOS POR LINHA.                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BOX: INFORMACOES RELATIVAS AO IMPOSTO                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If !lComp
	nLInic	:= 0474
	nLFim	:= 0500	
Else
	nLInic	:= 0534
	nLFim	:= 0560
EndIf

oDacte:Box(nLInic , 0000, nLFim, 0559)

nLInic += 0006
oDacte:Say(nLInic , 0212, "Informações Relativas ao Imposto", oFont08N)

nLInic += 0002
oDacte:Line(nLInic, 0000, nLInic, 0559)	// Linha:
oDacte:Line(nLInic, 0240, nLFim, 0240)	// Linha: Separador Situacao Trib	/ Base de Calculo
oDacte:Line(nLInic, 0350, nLFim, 0350) 	// Linha: Separador Base de Calculo	/ Aliq.ICMS
oDacte:Line(nLInic, 0400, nLFim, 0400) 	// Linha: Separador Aliq.ICMS    	/ Valor ICMS
oDacte:Line(nLInic, 0470, nLFim, 0470) 	// Linha: Separador Valor ICMS    	/ %Red Bc.Calc

nLInic += 0008
oDacte:Say(nLInic , 0003, "Classificação Tributária", oFont08N)   // Label: Classificação Tributária
oDacte:Say(nLInic , 0243, "Base de Cálculo"    , oFont08N)   // Label: Base de Cálculo
oDacte:Say(nLInic , 0353, "Aliq. ICMS"         , oFont08N)   // Label: Aliq.ICMS
oDacte:Say(nLInic , 0403, "Valor ICMS"         , oFont08N)   // Label: Valor ICMS
oDacte:Say(nLInic , 0473, "%Red. Bc. Calc."    , oFont08N)   // Label: %Red.Bc.Calc.

	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  ³ Tag <ICMS00>                                                    ³
	  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	If !XmlChildEx(oNfe:_CTE:_INFCTE:_IMP:_ICMS,'_ICMS00') == NIL .AND. !XmlChildEx(oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00,'_CST') == NIL

		cAliasD2  := DataSource( 'DESCRSUBSTTRIBUTARIA' )
		
		cSitTriba	:= Iif( XmlChildEx(oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00,'_CST') == Nil," ",;
		oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_CST:TEXT + " - " + SubStr(AllTrim((cAliasD2)->X5DESCRI),1,40) )

		cBaseIcms	:= Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_VBC:TEXT)
		cAliqIcms	:= Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_PICMS:TEXT)
		cValIcms	:= Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_VICMS:TEXT)
		
		(cAliasD2)->(DbCloseArea())
	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  ³ Tag <ICMS45>                                                    ³
	  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	ElseIf !XmlChildEx(oNfe:_CTE:_INFCTE:_IMP:_ICMS,'_ICMS45') == Nil .AND. !XmlChildEx(oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS45,'_CST') == Nil

		cAliasD2  := DataSource( 'DESCRSUBSTTRIBUTARIA' )

		cSitTriba	:= Iif( XmlChildEx(oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS45,'_CST')==Nil," ",;
		oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS45:_CST:TEXT + " - " + SubStr(AllTrim((cAliasD2)->X5DESCRI),1,40) )
		
		(cAliasD2)->(DbCloseArea()) 
	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  ³ Tag <ICMS90>                                                    ³
	  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	ElseIf !XmlChildEx(oNfe:_CTE:_INFCTE:_IMP:_ICMS,'_ICMS90') == Nil

		cAliasD2  := DataSource( 'DESCRSUBSTTRIBUTARIA' )

		cSitTriba	:= Iif( XmlChildEx(oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS90,'_CST') == Nil," ",;
		oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS90:_CST:TEXT + " - " + SubStr(AllTrim((cAliasD2)->X5DESCRI),1,40) )

		cBaseIcms	:= Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS90:_VBC:TEXT)
	   	cAliqIcms	:= Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS90:_PICMS:TEXT)
		cValIcms	:= Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS90:_VICMS:TEXT)
		cRedBcCalc := Val(Iif( XmlChildEx(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS90,'_pRedBC')==Nil," ",(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS90:_pRedBC:TEXT) ))
		
		(cAliasD2)->(DbCloseArea())
	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  ³ Tag <ICMS20>                                                    ³
	  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	ElseIf !XmlChildEx(oNfe:_CTE:_INFCTE:_IMP:_ICMS,'_ICMS20') == Nil

		cAliasD2  := DataSource( 'DESCRSUBSTTRIBUTARIA' )

		cSitTriba	:= Iif( XmlChildEx(oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS20,'_CST')==Nil," ",;
		oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS20:_CST:TEXT + " - " + SubStr(AllTrim((cAliasD2)->X5DESCRI),1,40) )

		cBaseIcms	:= Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS20:_VBC:TEXT)
		cAliqIcms	:= Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS20:_PICMS:TEXT)
		cValIcms	:= Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS20:_VICMS:TEXT)
		cRedBcCalc := Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS20:_pRedBC:TEXT)
		
		(cAliasD2)->(DbCloseArea())
	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  ³ Tag <ICMS60>                                                    ³
	  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	ElseIf !XmlChildEx(oNfe:_CTE:_INFCTE:_IMP:_ICMS,'_ICMS60') == Nil

		cAliasD2  := DataSource( 'DESCRSUBSTTRIBUTARIA' )

		cSitTriba	:= Iif( XmlChildEx(oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS60,'_CST') == "U"," ",;
		oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS60:_CST:TEXT + " - " + SubStr(AllTrim((cAliasD2)->X5DESCRI),1,40) )

		//DECRETO Nº 13.780 DE 16 DE MARÇO DE 2012   TDN https://tdn.totvs.com/pages/releaseview.action?pageId=498708893
		If XmlChildEx(oNfe:_CTE:_INFCTE:_IDE, '_UFINI') <> Nil .And. oNfe:_CTE:_INFCTE:_IDE:_UFINI:TEXT = "BA"  
			cBaseIcms	:= 0 // Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS60:_VBCSTRET:TEXT)
			cCredPres	:= 0 // Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS60:_vCred:TEXT)
			cValIcms	:= 0 // Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS60:_VICMSSTRET:TEXT)
			cAliqIcms	:= 0 // Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS60:_PICMSSTRET:TEXT)
		Else
			cBaseIcms	:= Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS60:_VBCSTRET:TEXT)
			cCredPres	:= Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS60:_vCred:TEXT)
			cValIcms	:= Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS60:_VICMSSTRET:TEXT)
			cAliqIcms	:= Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS60:_PICMSSTRET:TEXT)
		EndIf

		(cAliasD2)->(DbCloseArea())
	ElseIf !XmlChildEx(oNfe:_CTE:_INFCTE:_IMP:_ICMS,'_ICMSOUTRAUF') == NIL

		cAliasD2  := DataSource( 'DESCRSUBSTTRIBUTARIA' )

		cSitTriba	:= Iif( XmlChildEx(oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMSOUTRAUF,'_CST') == Nil," ",;
		oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMSOUTRAUF:_CST:TEXT + " - " + SubStr(AllTrim((cAliasD2)->X5DESCRI),1,40) )

	   	cAliqIcms	:= Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMSOUTRAUF:_PICMSOUTRAUF:TEXT)
		cBaseIcms	:= Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMSOUTRAUF:_VBCOUTRAUF:TEXT)
		cValIcms   := Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMSOUTRAUF:_VICMSOUTRAUF:TEXT)
		
		(cAliasD2)->(DbCloseArea())
	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  ³ Tag <ICMSSN> Simples Nacional                                   ³
	  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/	
	ElseIf !XmlChildEx(oNfe:_CTE:_INFCTE:_IMP:_ICMS,'_ICMSSN') == Nil
		cSitTriba	:= Iif( XmlChildEx(oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMSSN,'_INDSN')==Nil," "," Simples Nacional ")		
	EndIf

nLInic += 0008
oDacte:Say(nLInic , 0003, cSitTriba,								oFont08)
oDacte:Say(nLInic , 0243, Transform(cBaseIcms , '@E 999,999,999.99'),	oFont08)
oDacte:Say(nLInic , 0353, Transform(cAliqIcms , '@E 999,999,999.99'),	oFont08)
oDacte:Say(nLInic , 0403, Transform(cValIcms  , '@E 999,999,999.99'),	oFont08)
oDacte:Say(nLInic , 0473, Transform(cRedBcCalc, '@E 999,999,999.99'),	oFont08)

lComp := .F. //CTE Complementar

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ TMSR27Cmp³ Autor ³Felipe Barbiere           ³ Data ³01/10/12  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao responsavel por montar o BOX relativo as informacoes ³±±
±±³          ³dos componentes e valores complementados                    ³±±
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
Static Function TMSR31Cmp()

Local nCount    := 0
Local nCount_2  := 0
Local oFont08   := TFont():New("Times New Roman",08,08,,.F.,,,,.T.,.F.)
Local oFont08N  := TFont():New("Times New Roman",08,08,,.T.,,,,.T.,.F.)
Local lControl  := .F.
Local cAliasChv := ''

lComp := .T.	//CTE Complementar

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BOX: COMPONENTES DO VALOR DA PRESTACAO DO SERVICO                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nLInic  := 0400
nLFim   := 0506
oDacte:Box(nLInic , 0000, nLFim, 0559)

nLInic += 0006
oDacte:Say(nLInic , 0210, "Componentes do Valor da Prestação do Serviço", oFont08N)

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
cQuery += " SELECT DT6.DT6_CHVCTE " +CRLF
cQuery += "   FROM " + RetSqlName('DT6') + " DT6 " +CRLF
cQuery += "  WHERE DT6.DT6_FILIAL = '" + xFilial('DT6') + "'" +CRLF
cQuery += "    AND DT6.DT6_FILDOC = '" + (cAliasCT)->DT6_FILDCO + "'" +CRLF
cQuery += "    AND DT6.DT6_DOC    = '" + (cAliasCT)->DT6_DOCDCO + "'" +CRLF
cQuery += "    AND DT6.DT6_SERIE  = '" + (cAliasCT)->DT6_SERDCO + "'" +CRLF
cQuery += "    AND DT6.D_E_L_E_T_ = ' '"
cQuery := ChangeQuery(cQuery)
DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasChv, .F., .T.)

nCount   := 0
While !(cAliasChv)->(Eof())

	nCount   += 1
	lControl := !lControl

	If nCount < 9

		If (lControl == .T.)
			oDacte:Say(nLInic, 0003, Transform(AllTrim((cAliasChv)->DT6_CHVCTE),"@!")	, oFont08)
			oDacte:Say(nLInic, 0205, PadL(Transform((cAliasCT)->DT6_VALFAT,'@E 9,999,999.9999'),20), oFont08)
		Else
			oDacte:Say(nLInic, 0281, Transform(AllTrim((cAliasChv)->DT6_CHVCTE),"@!")	, oFont08)
		EndIf

	EndIf

	(cAliasChv)->(DbSkip())

EndDo

(cAliasChv)->(dbCloseArea())

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RTMSR35   ³ Autor ³Felipe Barbiere        ³ Data ³01/10/12     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna um Array com a estrutura do campo complemento rel. º±±
±±º          ³ ao objeto passado por parametro                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TMS                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
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


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RTMSR35   ³ Autor ³Felipe Barbiere        ³ Data ³01/10/12  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function DataSource( cSource, cFilDoc, cDoc, cSerie )
Local cNewArea	:= GetNextAlias()
Local cQuery	:= ""

Default cFilDoc		:= ''
Default cDoc		:= ''
Default cSerie		:= ''

cQuery := GetSQL( cSource, cFilDoc, cDoc, cSerie )
DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cNewArea, .F., .T.)

Return ( cNewArea )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RTMSR35   ³ Autor ³Felipe Barbiere        ³ Data ³01/10/12  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³  Cria DACTE sem utilizar o XML, utilizando tabela.         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GetSQL( cSource, cFilDoc, cDoc, cSerie )
Local cQuery	:= ""
Local cSitTriba	:= ""
// Verifica se existe filtro por lote especifico
Local lFiltLote := Empty(MV_PAR01) .Or. MV_PAR02 = 'ZZZZZZ' 

Default cFilDoc		:= ''
Default cDoc		:= ''
Default cSerie		:= ''

If	cSource == 'DT6'
	cQuery += "    SELECT " + CRLF
	cQuery += "    CTRC.DT6_FILDOC,                " +CRLF
	cQuery += "    CTRC.DT6_SERIE,                 " +CRLF
	cQuery += "    CTRC.DT6_DOC,                   " +CRLF
	cQuery += "    CTRC.DT6_DOCTMS,                " +CRLF
	cQuery += "    CTRC.DT6_CHVCTE,                " +CRLF
	cQuery += "    CTRC.DT6_PROCTE,                " +CRLF
	cQuery += "    CTRC.DT6_VALFAT,                " +CRLF
	cQuery += "    CTRC.DT6_FILDCO,                " +CRLF
	cQuery += "    CTRC.DT6_DOCDCO,                " +CRLF
	cQuery += "    CTRC.DT6_SERDCO,                " +CRLF
	cQuery += "    CTRC.DT6_AMBIEN,                " +CRLF
	cQuery += "    CTRC.DT6_DEVFRE,                " +CRLF
	cQuery += "    CTRC.DT6_CHVCTG,                " +CRLF
	cQuery += "    CTRC.DT6_CLIDEV,                " +CRLF
	cQuery += "    CTRC.DT6_LOJDEV,                " +CRLF
	
	cQuery += "    CLIDES.A1_SUFRAMA DES_SUFRAMA,  " +CRLF
	
	cQuery += "    CLIDPC.A1_CGC DPC_CNPJ         " +CRLF
	
	cQuery += "   FROM " + RetSqlName('DT6') + " CTRC " + CRLF
	
	cQuery += "        INNER JOIN " + RetSqlName('SA1') + " CLIDES ON (CLIDES.A1_COD = CTRC.DT6_CLIDES AND CLIDES.A1_LOJA = CTRC.DT6_LOJDES AND CLIDES.D_E_L_E_T_ = ' ' ) " + CRLF
	
	cQuery += "        LEFT  JOIN " + RetSqlName('SA1') + " CLIDPC ON (CLIDPC.A1_FILIAL = '" + xFilial('SA1') + "' AND CLIDPC.A1_COD = CTRC.DT6_CLIDPC AND CLIDPC.A1_LOJA = CTRC.DT6_LOJDPC AND CLIDPC.D_E_L_E_T_ = ' ' ) " + CRLF
	
	cQuery += "  WHERE CTRC.DT6_FILIAL  = '" + xFilial('DT6') + "'" + CRLF

	If Empty(cFilDoc) .And. Empty(cDoc) .And. Empty(cSerie)
		cQuery += "    AND CTRC.DT6_FILORI  = '" + cFilAnt  + "'" + CRLF	
		cQuery += "    AND CTRC.DT6_LOTNFC >= '" + MV_PAR01 + "'" + CRLF
		cQuery += "    AND CTRC.DT6_LOTNFC <= '" + MV_PAR02 + "'" + CRLF
	EndIf

	cQuery += "    AND (CTRC.DT6_IDRCTE  = '100' OR CTRC.DT6_IDRCTE  = '136' OR (CTRC.DT6_CHVCTG  <> ' '))" + CRLF

	If Empty(cFilDoc) .And. Empty(cDoc) .And. Empty(cSerie)
		cQuery += "    AND CTRC.DT6_FILDOC  = '" + cFilAnt + "'" + CRLF
		cQuery += "    AND CTRC.DT6_DOC    >= '" + MV_PAR03 + "'" + CRLF
		cQuery += "    AND CTRC.DT6_DOC    <= '" + MV_PAR04 + "'" + CRLF
		cQuery += "    AND CTRC.DT6_SERIE  >= '" + MV_PAR05 + "'" + CRLF
		cQuery += "    AND CTRC.DT6_SERIE  <= '" + MV_PAR06 + "'" + CRLF
		If !Empty(MV_PAR07)
			cQuery += "    AND CTRC.DT6_DOCTMS  = '" + MV_PAR07 + "'" + CRLF
		EndIf
	Else
		cQuery += "    AND CTRC.DT6_FILDOC  = '"  + cFilDoc + "'" + CRLF
		cQuery += "    AND CTRC.DT6_DOC     = '"  + cDoc    + "'" + CRLF
		cQuery += "    AND CTRC.DT6_SERIE   = '"  + cSerie  + "'" + CRLF
	EndIf
	cQuery += "    AND CTRC.D_E_L_E_T_  = ' ' " + CRLF

	cQuery += "  AND CLIDES.A1_FILIAL  = '"  + xFilial('SA1') + "'" + CRLF
	cQuery += "  AND CLIDES.D_E_L_E_T_ = ' '" + CRLF
	
	If (lFiltLote .And. (Empty(MV_PAR07) .Or. MV_PAR07 == 'M')) .Or.;
		!Empty(cFilDoc) .And. !Empty(cDoc) .And. !Empty(cSerie)

		cQuery += " UNION " + CRLF
	
		cQuery += " SELECT SF1.F1_FILORIG DT6_FILDOC, " + CRLF
		cQuery += " 	   SF1.F1_SERIE DT6_SERIE, " + CRLF
		cQuery += " 	   SF1.F1_DOC DT6_DOC, " + CRLF
		cQuery += " 	   'M' DT6_DOCTMS, " + CRLF
		cQuery += " 	   SF1.F1_CHVNFE DT6_CHVCTE, " + CRLF
		cQuery += " 	   ' ' DT6_PROCTE, " + CRLF
		cQuery += " 	   SF1.F1_VALBRUT DT6_VALFAT, " + CRLF
		cQuery += "        SF1.F1_FILORIG DT6_FILDCO, " + CRLF
		cQuery += " 	   SF1.F1_NFORIG DT6_DOCDCO, " + CRLF
		cQuery += " 	   SF1.F1_SERORIG DT6_SERDCO, " + CRLF
		cQuery += " 	   0 DT6_AMBIEN, " + CRLF
		cQuery += " 	   '' DT6_DEVFRE, " + CRLF
		cQuery += " 	   '' DT6_CHVCTG," + CRLF
		cQuery += " 	   '' DES_SUFRAMA, " + CRLF
		cQuery += " 	   '' DPC_CNPJ, " + CRLF
		cQuery += " 	   '' DT6_CLIDEV, " + CRLF
		cQuery += " 	   '' DT6_LOJDEV " + CRLF
							
		cQuery += "   FROM " + RetSqlName('SF1') + " SF1 " + CRLF
	
		cQuery += "  WHERE SF1.F1_FILIAL  = '" + xFilial('SF1') + "'" + CRLF
		cQuery += "    AND SF1.F1_FORMUL = 'S' " + CRLF
		If Empty(cFilDoc) .And. Empty(cDoc) .And. Empty(cSerie)
			cQuery += "    AND SF1.F1_DOC    >= '" + MV_PAR03 + "'" + CRLF
			cQuery += "    AND SF1.F1_DOC    <= '" + MV_PAR04 + "'" + CRLF
			cQuery += "    AND SF1.F1_SERIE  >= '" + MV_PAR05 + "'" + CRLF
			cQuery += "    AND SF1.F1_SERIE  <= '" + MV_PAR06 + "'" + CRLF
		Else
			cQuery += "    AND SF1.F1_DOC    = '"  + cDoc   + "'" + CRLF
			cQuery += "    AND SF1.F1_SERIE  = '"  + cSerie + "'" + CRLF
		EndIf
		cQuery += "    AND SF1.F1_TPCTE  = 'A'" + CRLF
		cQuery += "    AND SF1.F1_TIPO   = 'D'" + CRLF
		cQuery += "    AND SF1.D_E_L_E_T_  = ' ' " + CRLF
	EndIf    

	cQuery += "  ORDER BY 1, 2, 3 "

ElseIf cSource == 'DTC'

	cQuery += " SELECT Count(Distinct NF.DTC_NUMNFC) nTotal "
	cQuery += "   FROM " + RetSqlName('DTC') + " NF "
	cQuery += "  WHERE NF.DTC_FILIAL = '" + xFilial("DTC") + "'"
	cQuery += "    AND NF.DTC_FILDOC = '" + AllTrim((cAliasCT)->DT6_FILDOC) + "'"
	cQuery += "    AND NF.DTC_DOC    = '" + AllTrim((cAliasCT)->DT6_DOC)    + "'"
	cQuery += "    AND NF.DTC_SERIE  = '" + AllTrim((cAliasCT)->DT6_SERIE)  + "'"
	cQuery += "    AND NF.D_E_L_E_T_ =' '"

ElseIf cSource == 'DESCRSUBSTTRIBUTARIA'

	cQuery := " SELECT SX5.X5_DESCRI X5DESCRI"
	cQuery += " FROM " + RetSqlName("SX5") + " SX5 "
	cQuery += " WHERE SX5.X5_FILIAL ='"  + xFilial("SX5") + "'"
	cQuery += "   AND SX5.X5_TABELA ='S2'"

	If !XmlChildEx(oNfe:_CTE:_INFCTE:_IMP:_ICMS,'_ICMS00')==Nil
		cSitTriba := Iif( XmlChildEx(oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00,'_CST')==Nil," ",;
		oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_CST:TEXT)
	ElseIf !XmlChildEx(oNfe:_CTE:_INFCTE:_IMP:_ICMS,'_ICMS45')==Nil
		cSitTriba := Iif( XmlChildEx(oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS45,'_CST')==Nil," ",;
		oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS45:_CST:TEXT)
	ElseIf !XmlChildEx(oNfe:_CTE:_INFCTE:_IMP:_ICMS,'_ICMS90')==Nil
		cSitTriba := Iif( XmlChildEx(oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS90,'_CST')==Nil," ",;
		oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS90:_CST:TEXT)
	ElseIf !XmlChildEx(oNfe:_CTE:_INFCTE:_IMP:_ICMS,'_ICMS20')==Nil
		cSitTriba := Iif( XmlChildEx(oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS20,'_CST')==Nil," ",;
		oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS20:_CST:TEXT)
	ElseIf !XmlChildEx(oNfe:_CTE:_INFCTE:_IMP:_ICMS,'_ICMS60')==Nil
		cSitTriba := Iif( XmlChildEx(oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS60,'_CST')==Nil," ",;
		oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS60:_CST:TEXT)
	ElseIf !XmlChildEx(oNfe:_CTE:_INFCTE:_IMP:_ICMS,'_ICMSOUTRAUF')==Nil
		cSitTriba := Iif( XmlChildEx(oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMSOUTRAUF,'_CST')==Nil," ",;
		oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMSOUTRAUF:_CST:TEXT)
	EndIf

	cQuery += " AND SX5.X5_CHAVE  ='" +cSitTriba+ "'"
	cQuery += " AND SX5.D_E_L_E_T_ = ' '"

ElseIf cSource == "PRODUTOS_PERIGOSOS"

	cQuery := " SELECT DTC.DTC_PESO, DTC.DTC_QTDVOL, DY3.DY3_ONU, DY3.DY3_DESCRI, DY3.DY3_GRPEMB, DY3.DY3_CLASSE, DY3.DY3_NRISCO "
	cQuery += " FROM " + RetSqlName("DTC") + " DTC , " + RetSqlName("SB5") + " SB5 , " + RetSqlName("DY3") + " DY3 "
	cQuery += " WHERE DTC.DTC_FILIAL   = '"  + xFilial("DT6") + "' "
	cQuery += " AND DTC.DTC_FILDOC = '" + (cAliasCT)->DT6_FILDOC + "'"
	cQuery += " AND DTC.DTC_DOC = '" + (cAliasCT)->DT6_DOC + "'"
	cQuery += " AND DTC.DTC_SERIE = '" + (cAliasCT)->DT6_SERIE + "'"
	cQuery += " AND SB5.B5_CARPER = '1' " //-- Carga Perigosa
	cQuery += " AND DTC.DTC_CODPRO = SB5.B5_COD"
	cQuery += " AND DY3.DY3_ONU = SB5.B5_ONU "
	cQuery += " AND DY3.DY3_ITEM = SB5.B5_ITEM "
	cQuery += " AND DTC.D_E_L_E_T_ = ' '"
	cQuery += " AND SB5.D_E_L_E_T_ = ' '"
	cQuery += " AND DY3.D_E_L_E_T_ = ' '"

EndIf

cQuery := ChangeQuery( cQuery )

Return ( cQuery )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RTMSR35   ³ Autor ³Felipe Barbiere        ³ Data ³01/10/12  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³  Retorna se usuário utliza TOTVS Colaboração               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static function UsaColaboracao(cModelo)

Local lUsa := .F.

If FindFunction("ColUsaColab")
	lUsa := ColUsaColab(cModelo)
endif

return (lUsa)
