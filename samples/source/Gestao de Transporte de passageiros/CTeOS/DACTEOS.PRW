#INCLUDE "PROTHEUS.CH"
#INCLUDE "PARMTYPE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH" 
#INCLUDE "FWPRINTSETUP.CH"

#DEFINE MAXMENLIN  93  //Máximo de caracteres por linha de dados adicionais
#DEFINE MAXMENFISC 60  //Maximo de caracteres da linha Reservado ao Fisco	

//-----------------------------------------------------------------------------
/*/{Protheus.doc} TSSDacteOS
Imprime o Documento Auxiliar do Conhecimento de Transporte Eletronico 
Outros Serviços (DACTE OS)

@param		aXml		Array com XML assinado e XML do Protocolo.
						aXml[nX][01] = XML_SIG
						aXml[nX][02] = XML_PROT
						aXml[nX][03] = XML_DPEC - Não utilizado
						aXml[nX][04] = NUMERO PROTOCOLO DPEC - Não utilizado
			
			cPathPDF	Diretório para impressão em PDF.		
			cPrinter
			lFrentVers	1 - Imprime Frente e verso, 2- Imprime Frente
			nVias	- número de vias impressas (1)
			lAuto	- Chamado por uma rotina automática.
			cFilePrint - Nome do arquivo pdf gerado			
@return	Array com a estrutura - Se imprimiu ou não
									- Caminho + nome do pdf gerado

@author  Natalia Sartori
@since   02/02/2017
@version 1.0
/*/
//-----------------------------------------------------------------------------
User Function DacteOS(aXml, cPathPDF, cPrinter, lFrentVers, nVias, lAuto, cFilePrint, nPrintType, lServer)

	Local nFile  := 0
	Local nCount := 0
	Local lImprimiu		  :=	.F.       
	Local cBarra 		  := 	IIf(issrvunix(), "/", "\")
	Local aFiles          := {} // O array receberá os nomes dos arquivos e do diretório
	Local aSizes          := {} // O array receberá os tamanhos dos arquivos e do diretorio
	Local oDaCte		  := Nil
	local lAdjustToLegacy := .T. // Inibe legado de resolução com a TMSPrinter

	Private __RELDIR	  := cBarra+"SPOOL"+cBarra
	Private PixelX 		  := Nil
	Private PixelY 		  := Nil
	Private nConsNeg 	  := 0.4 // Constante para concertar o cálculo retornado pelo GetTextWidth para fontes em negrito.
	Private nConsTex	  := 0.5 // Constante para concertar o cálculo retornado pelo GetTextWidth.

	DEFAULT aXml		:= PARAMIXB[1]		
	DEFAULT cPathPDF	:= PARAMIXB[2]	
	DEFAULT cPrinter	:= PARAMIXB[3]	
	DEFAULT lFrentVers	:= PARAMIXB[4]	
	DEFAULT nVias		:= PARAMIXB[5]	
	DEFAULT lAuto		:= PARAMIXB[6]	
	DEFAULT cFilePrint	:= PARAMIXB[7]	
	DEFAULT nPrintType	:= PARAMIXB[8]
	DEFAULT lServer		:= PARAMIXB[9]

	If !ExistDir(__RELDIR)
		Makedir(__RELDIR)
	EndIf 

	If nPrintType <> IMP_SPOOL .And. !empty(cPathPDF) .And. !ExistDir(cPathPDF)
		Makedir(cPathPDF)
	EndIf

	oDaCte := FWMSPrinter():New(cFilePrint, nPrintType, lAdjustToLegacy, , .T.) 

	oDaCte:lInJob	:= lAuto
	oDaCte:lServer 	:= lServer
	oDaCte:lPDFAsPNG:= .T.

	oDaCte:cPrinter	:= cPrinter
	oDaCte:nDevice  := nPrintType
	oDaCte:SetResolution(76)
	oDaCte:SetPortrait()
	oDaCte:SetPaperSize(DMPAPER_A4)
	oDaCte:SetMargin(20,80,60,00)

	PixelX := oDaCte:nLogPixelX()
	PixelY := oDaCte:nLogPixelY()

	lImprimiu := ProcDaCte(@oDacte,.F.,aXml,lAuto,lFrentVers,nVias)

	//Deve ser chamado o Preview,para converter o ".rel" -> ".pdf"
	If lImprimiu		                                                                                      	
		oDaCte:Preview()
	EndIf

	FreeObj(oDaCte)
	oDaCte := Nil

	// ------------------------------------------------------------------------------------------
	// Tratamento do *.PDF para receber o e-mail com o PDF nao corrompido
	// ------------------------------------------------------------------------------------------
	ADir(cPathPDF+"*.pdf", aFiles, aSizes)

	nFile := ASCAN(aFiles,UPPER(cFilePrint))

	If nFile > 0 
		nCount := aSizes[1]
		While nCount < 1024
			Sleep(6000)
			ADir(cPathPDF+"*.pdf", aFiles, aSizes)
			nCount := aSizes[1]
			Sleep(6000)
		EndDo 
		Sleep(6000)
	EndIf

Return({lImprimiu,cPathPDF+cFilePrint+".pdf"})

//-----------------------------------------------------------------------
/*/{Protheus.doc} ProcDaCte
Impressão do DACTE OS no formato Retrato utlizando somente o XML do Ct-e OS.

@param		oDacte		Objeto de impressão
			lEnd		Utilizada pelo RptStatus
			aXml		Array com os XMLs do CT-e.
						Onde:
						aXml[nX][01] = XML_SIG
						aXML[nX][02] = XML_PROT
						aXML[nX][03] = XML_DPEC - Não utilizado
						aXML[nX][03] = NUMERO PROTOCOLO DPEC - Não utilizado
			lAuto		Chamado por uma rotina automática.
			lFrentVers	Imprime frente Verso. .T. = SIM E .F.=NÃO
			nVias		Número de Vias que serão impressas.
								
@return	lImprimiu	Retorna .T. se imprimiu e .F. se não imprimiu

@author Natalia Sartori
@since 02.02.2017
@version 1.0 
/*/
//-----------------------------------------------------------------------
Static Function ProcDaCte(oDacte,lEnd,aXml,lAuto,lFrentVers,nVias)

Local cAviso	:= ""
Local cErro	:= ""
Local cNoImpr	:= "" 
Local lImpr	:= .F.

Local nX		:= 0

Private oCte
Private oCteProt

//-- Definicao de fontes  
Private oFont05	:= TFontEx():New(oDaCte,"Times New Roman",08,07,.F.,.T.,.F.)
Private oFont07	:= TFontEx():New(oDaCte,"Times New Roman",09,09,.F.,.T.,.F.)
Private oFont07N	:= TFontEx():New(oDaCte,"Times New Roman",09,09,.T.,.T.,.F.)
Private oFont08		:= TFontEx():New(oDaCte,"Times New Roman",10,10,.F.,.T.,.F.)
Private oFont08N	:= TFontEx():New(oDaCte,"Times New Roman",10,10,.T.,.T.,.F.)
Private oFont10	:= TFontEx():New(oDaCte,"Times New Roman",13,13,.F.,.T.,.F.)
Private oFont10N	:= TFontEx():New(oDaCte,"Times New Roman",13,13,.T.,.T.,.F.)

For nX := 1 To Len( aXml )

	//-- aXml[1] - XML ERP		
	If !Empty(aXml[nX,1])
		cAviso	:= ""
		cErro	:= ""
		aXml[nX][1] := EncodeUtf8(aXml[nX][1])
		oCte	:= XmlParser(aXml[nX][1],"_",@cAviso,@cErro)
				
		If Empty( cAviso ) .And. Empty( cErro )
	
			oCteProt:= XmlParser(aXml[nX][2],"_",@cAviso,@cErro)
	
			// Imprime DaCte
			ImpDetDaCte( @oDacte )
			lImpr := .T.
		Else
			cNoImpr += oCte:_CTEOS:_INFCTE:_IDE:_NCT:TEXT + " / "
		EndIf
	Else
		ConOut("[ThreadID:"+ AllTrim(Str(ThreadID(),15))+"] "+"DACTEOS - Date: "+DToS(Date())+" Time: "+Time()+" "+cErro)		
	Endif

Next

//Mensagem para informar os DACTE's que tiveram problema de impressao e nao foram impressas
If !Empty(cNoImpr)
	Conout("Os seguinte documentos não foram impressos: "+CRLF+cNoImpr)		//"Os seguinte documentos não foram impressos: "
EndIf

Return( lImpr )

//-----------------------------------------------------------------------
/*/{Protheus.doc} ImpDetDaCte
Impressão do DACTE OS no formato Retrato utlizando somente o XML do Ct-e.

@param		oDacte	- Obejto de impressão

@return		Nil

@author Sergio S. Fuzinaka
@since 07.11.2011
@version 11.6 
/*/
//-----------------------------------------------------------------------
Static Function ImpDetDaCte( oDacte )

	Local aCab			:= {}

	Local aObsCont	:= {}
	Local aObsFisco	:= {}
	Local aAuxUFPer	:= {}

	Local cCteProt	:= ""
	Local cObs			:= ""
	Local cRNMensagem	:= ""
	Local cCFOP		:= ""
	Local cDescCfop	:= ""
	Local cOriMunPre	:= ""
	Local cOriUFPre	:= ""
	Local cDesMunPre	:= ""
	Local cDesUFPre	:= ""
	Local cXNomeToma	:= ""
	Local cCPFCNPJ	:= ""
	Local cIEToma		:= ""
	Local cEndToma	:= ""
	Local cNroToma	:= ""
	Local cCplEnd		:= ""
	Local cCepToma	:= ""
	Local cUFToma		:= ""
	Local cBairToma	:= ""
	Local cMunToma	:= ""
	Local cPaisToma	:= ""
	Local cFoneToma	:= ""
	Local cXSeg		:= ""
	Local cSegResp	:= ""
	Local cSegNrApoli	:= ""
	Local cTAF			:= ""
	Local cNrRegEst	:= ""
	Local cPlacaVeic	:= ""
	Local cRenavam	:= ""
	Local cPCpfCnpj	:= ""
	Local cPropTaf	:= ""
	Local cPropNrRegEst	:= ""
	Local cInf	:= ""

	Local nCount	:= 0
	Local nCont		:= 0  
	Local nI		:= 0
	Local nX		:= 0
	Local nY		:= 0
	Local nConst	:= 0
	Local nTamBox	:= 0
	Local nHDiv		:= 0

	Local lCofins 	:= .F.
	Local lCSLL 	:= .F.
	Local lINSS 	:= .F.
	Local lIR		:= .F.
	Local lPIS 		:= .F.

	Private aUFPer	:= {}
	Private cTmsAntt	:= ""
	Private nSoma		:= 0
	Private nLInic	:= 0
	Private nLFim		:= 0
	Private nDifEsq	:= 0
	Private nFolhas	:= 1
	Private nFolhAtu	:= 1

	If oDacte == Nil
		lPreview := .T.
		oDacte := FWMSPrinter():New("DACTE", IMP_SPOOL)
		oDacte:SetPortrait()
		oDacte:Setup()
	EndIf

	//-- Controla o documento a ser enviado para montagem do cabecalho
	If Type("oCteProt:_PROTCTE:_INFPROT:_NPROT:TEXT") <> "U"
		cCteProt := oCteProt:_PROTCTE:_INFPROT:_NPROT:TEXT
	Endif
	
	nCont += 1
	aAdd(aCab, {;
	AllTrim(oCte:_CTEOS:_INFCTE:_IDE:_NCT:TEXT),;
	AllTrim(oCte:_CTEOS:_INFCTE:_IDE:_SERIE:TEXT),;
	AllTrim(STRTRAN( SUBSTR( oCte:_CTEOS:_INFCTE:_IDE:_dhEmi:TEXT, 1, AT('T', oCte:_CTEOS:_INFCTE:_IDE:_dhEmi:TEXT) - 1) , '-', '')),;
	AllTrim(STRTRAN( SUBSTR( oCte:_CTEOS:_INFCTE:_IDE:_dhEmi:TEXT, AT('T', oCte:_CTEOS:_INFCTE:_IDE:_dhEmi:TEXT) + 1, 5) , ':', '')),;
	AllTrim(STRTRAN(UPPER(oCte:_CTEOS:_INFCTE:_ID:TEXT),'CTE','')),;
	cCteProt,;
	Alltrim(Iif( Type( "oCte:_CTEOS:_INFCTE:_EMIT:_CNPJ:TEXT" ) == "U" ,oCte:_CTEOS:_INFCTE:_EMIT:_CPF:TEXT , oCte:_CTEOS:_INFCTE:_EMIT:_CNPJ:TEXT ))})
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Funcao responsavel por montar o cabecalho do relatorio                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	TMSR25Cab(@oDacte,aCab[nCont])

	cRNMensagem	:= "Esse Conhecimento de Transporte atende a Legislação de Transporte Rodoviário em Vigor"
	
	//--BOX: CFOP - Natureza da Prestacao
	cCFOP		:= AllTrim(oCte:_CTEOS:_INFCTE:_IDE:_CFOP:TEXT)
	cDescCfop	:= AllTrim(oCte:_CTEOS:_INFCTE:_IDE:_NATOP:TEXT)
	
	nSoma   := 40
	nLInic  += RetTamTex(oDacte,"X",oFont08:oFont) - 5
	nLFim   := (nLInic + RetTamTex(oDacte,"X",oFont08:oFont) + nSoma)
	oDacte:Box(nLInic, 0030, nLFim, 2370)

	nSoma   := 11
	nLInic  += RetTamTex(oDacte,"X",oFont07N:oFont) + nSoma
	oDacte:Say(nLInic, 0035, "CFOP - Natureza da Prestação", oFont07N:oFont)	//"CFOP - Natureza da Prestação"

	nSoma  := 10
	nLInic += RetTamTex(oDacte,"X",oFont08:oFont) + nSoma
	oDacte:Say(nLInic, 35, cCFOP + " - " + cDescCfop, oFont07:oFont)

	//-- BOX: Início da Prestação / Percurso do Veículo / Término da Prestação
	
	//- Início da Prestacao
	cOriMunPre	:= Iif(Type("oCte:_CTEOS:_INFCTE:_IDE:_XMUNINI:TEXT")=="U"," ",oCte:_CTEOS:_INFCTE:_IDE:_XMUNINI:TEXT)
	cOriUFPre	:= Iif(Type("oCte:_CTEOS:_INFCTE:_IDE:_UFINI:TEXT")=="U"," ",oCte:_CTEOS:_INFCTE:_IDE:_UFINI:TEXT)

	//- Término da Prestacao
	cDesMunPre	:= Iif(Type("oCte:_CTEOS:_INFCTE:_IDE:_XMUNFIM:TEXT")=="U"," ",oCte:_CTEOS:_INFCTE:_IDE:_XMUNFIM:TEXT)
	cDesUFPre	:= Iif(Type("oCte:_CTEOS:_INFCTE:_IDE:_UFFIM:TEXT")=="U"," ",oCte:_CTEOS:_INFCTE:_IDE:_UFFIM:TEXT)
	
	//- Percurso do Veículo
	If Type("oCte:_CTEOS:_INFCTE:_IDE:_INFPERCURSO") <> "U"
		If Type("oCte:_CTEOS:_INFCTE:_IDE:_INFPERCURSO") == "A"
			aUFPer :=  oCte:_CTEOS:_INFCTE:_IDE:_INFPERCURSO
		Else
			aUFPer := {oCte:_CTEOS:_INFCTE:_IDE:_INFPERCURSO}
		EndIf		
	EndIf
	
	nSoma   := 45
	nLInic  += RetTamTex(oDacte,"X",oFont08:oFont) - 5
	nLFim   := (nLInic + RetTamTex(oDacte,"X",oFont08:oFont) + nSoma)
	
	oDacte:Box(nLInic, 0030, nLFim, 1170)
	oDacte:Box(nLInic, 0690, nLFim, 2368)//1170/890
	oDacte:Box(nLInic, 1790, nLFim, 2368)
	
	nSoma  := 12
	nLInic += RetTamTex(oDacte,"X",oFont08N:oFont) + nSoma
	oDacte:Say(nLInic, 0035, "Início da Prestação" , oFont08N:oFont)	//"Origem da Prestação"
	oDacte:Say(nLInic, 0700, "Percurso do Veículo" , oFont08N:oFont)	//"Origem da Prestação"
	oDacte:Say(nLInic, 1800, "Término da Prestação", oFont08N:oFont)	//"Destino da Prestação 1185"

	nSoma  := 12
	nLInic += RetTamTex(oDacte,"X",oFont08:oFont) + nSoma
	oDacte:Say(nLInic, 0035, AllTrim(cOriMunPre) + ' - ' + AllTrim(cOriUFPre), oFont08:oFont)
	oDacte:Say(nLInic, 1800, AllTrim(cDesMunPre) + ' - ' + AllTrim(cDesUFPre), oFont08:oFont)
	
	If Len(aUFPer) > 0 // Impressão da UF de Percurso
		nSoma:=0				
		For nY := 1 to len(aUFPer)
			oDacte:Say(nLInic, 0700+nSoma, aUFPer[nY]:_UFPER:TEXT + " / " , oFont08:oFont)
			nSoma += 50
			aadd(aAuxUFPer,{aUFPer[nY]:_UFPER:TEXT})
			If Len	(aAuxUFPer) > 20 //Máximo de UF impressa na linha.
				Exit
			EndIf				
		Next nY
	EndIf
	
	//-- BOX: Tomador/Usuário do Serviço
	If Type("oCte:_CTEOS:_INFCTE:_TOMA") <> "U"
		
		cXNomeToma := Alltrim(oCte:_CTEOS:_INFCTE:_TOMA:_XNOME:TEXT)
				
		If Type("oCte:_CTEOS:_INFCTE:_TOMA:_CNPJ:TEXT") <> "U"
			cCPFCNPJ := Transform(AllTrim(oCte:_CTEOS:_INFCTE:_TOMA:_CNPJ:TEXT),"@r 99.999.999/9999-99")
		ElseIf Type("oCte:_CTEOS:_INFCTE:_TOMA:_CPF:TEXT") <> "U"
			cCPFCNPJ := Transform(AllTrim(oCte:_CTEOS:_INFCTE:_TOMA:_CPF:TEXT),"@r 999.999.999-99")		
		EndIf
		
		If Type("oCte:_CTEOS:_INFCTE:_TOMA:_IE:TEXT") <> "U"
			cIEToma := Alltrim(oCte:_CTEOS:_INFCTE:_TOMA:_IE:TEXT)
		EndIf
		
		cEndToma:= Alltrim(oCte:_CTEOS:_INFCTE:_TOMA:_ENDERTOMA:_XLGR:TEXT)
		cNroToma := Alltrim(oCte:_CTEOS:_INFCTE:_TOMA:_ENDERTOMA:_NRO:TEXT)
		
		If Type("oCte:_CTEOS:_INFCTE:_TOMA:_ENDERTOMA:_XCPL:TEXT") <> "U"
			cCplEnd:= Alltrim(oCte:_CTEOS:_INFCTE:_TOMA:_ENDERTOMA:_XCPL:TEXT)
		EndIf
		
		If Type("oCte:_CTEOS:_INFCTE:_TOMA:_ENDERTOMA:_CEP:TEXT") <> "U"
			cCepToma:= Transform(Alltrim(oCte:_CTEOS:_INFCTE:_TOMA:_ENDERTOMA:_CEP:TEXT),"@r 99999-999")
		EndIf
		
		cUFToma := Alltrim(oCte:_CTEOS:_INFCTE:_TOMA:_ENDERTOMA:_UF:TEXT)
		
		cBairToma := Alltrim(oCte:_CTEOS:_INFCTE:_TOMA:_ENDERTOMA:_XBAIRRO:TEXT)
		cMunToma := Alltrim(oCte:_CTEOS:_INFCTE:_TOMA:_ENDERTOMA:_XMUN:TEXT)
		
		If Type("oCte:_CTEOS:_INFCTE:_TOMA:_ENDERTOMA:_cPais:TEXT") <> "U"
			cPaisToma := POSICIONE("SYA",1,XFILIAL("SYA") + Alltrim(oCte:_CTEOS:_INFCTE:_TOMA:_ENDERTOMA:_cPais:TEXT),"YA_DESCR") 
		EndIf		
		
		If Type("oCte:_CTEOS:_INFCTE:_TOMA:_FONE:TEXT") <> "U"
			cFoneToma := Alltrim(oCte:_CTEOS:_INFCTE:_TOMA:_FONE:TEXT)
		EndIf
		
	EndIf
	
	nSoma   := 80
	nLInic  += RetTamTex(oDacte,"X",oFont08:oFont)
	nLFim   := (nLInic + RetTamTex(oDacte,"X",oFont08:oFont) + nSoma)
	oDacte:Box(nLInic, 0030, nLFim, 2370)
	
	nSoma   := 13
	nLInic  += RetTamTex(oDacte,"X",oFont08:oFont) + nSoma
	oDacte:Say(nLInic, 0035, "Tomador/ Usuário de Serviço: ", oFont08N:oFont)		//"Tomador do Serviço:"
	oDacte:Say(nLInic, 0400, NoAcentoCte(SubStr(cXNomeToma,1,45)), oFont08:oFont)//
	oDacte:Say(nLInic, 1380, "Municipio:", oFont08N:oFont)	//"Municipio:"
	oDacte:Say(nLInic, 1575, cMunToma + ' - ' + cUFToma + 'Município e CEP' + cCepToma, oFont08:oFont) // Município e CEP
	
	nSoma := 12
	For nCount := 1 To 2
		nLInic += RetTamTex(oDacte,"X",oFont08:oFont) + nSoma
		Do Case
			Case ( nCount == 1 )
				oDacte:Say(nLInic, 0035, "Endereço:", oFont08N:oFont)
				oDacte:Say(nLInic, 0210, SubStr(cEndToma,1,40)  + ", " + cNroToma + " - ", oFont08:oFont)
				oDacte:Say(nLInic, 980,  cCplEnd + " - " + cBairToma, oFont08:oFont)
				oDacte:Say(nLInic, 1875, "Pais:", oFont08N:oFont)//País
				oDacte:Say(nLInic, 1950, cPaisToma, oFont08:oFont)
			Case ( nCount == 2 )
				oDacte:Say(nLInic, 0035, "CNPJ/CPF:", oFont08N:oFont)
				oDacte:Say(nLInic, 0210, cCPFCNPJ + Space(3) + "Inscrição Estadual: " + cIEToma, oFont08:oFont)	//"CNPJ + Inscrição Estadual "
				oDacte:Say(nLInic, 1380, Alltrim(" Telefone: "), oFont08N:oFont)
				oDacte:Say(nLInic, 1575, Transform(cFoneToma,"@r (999) 999999999"), oFont08:oFont)
		EndCase
	Next nCount
			
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Conteudo do Box: Componentes do Valor da Prestacao de Servico          ³
	//³ Conteudo do Box: Informacoes Relativas ao Imposto                      ³
	//³ Conteudo do Box: Informações da Prestação do Serviço                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	TMSR25Comp(@oDacte)	
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ BOX OBSERVAÇÕES                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nSoma  := 100
	nConst	:= 300	//alterado por Radu em 06/09/2022
	
	nLInic += RetTamTex(oDacte,"X",oFont08:oFont) + nSoma
	nLFim  := (nLInic + RetTamTex(oDacte,"X",oFont08:oFont)) * 1.10
	
	nTamBox:= (nLFim + nConst)

	oDacte:Box(nLInic, 0030, nTamBox , 2375)	//alterado por Radu em 06/09/2022

	nSoma  := 13
	nLInic += RetTamTex(oDacte,"X",oFont08:oFont) + nSoma
	oDacte:Say(nLInic, 1050, "Observações", oFont08N:oFont)
	oDacte:Line((nLInic + 11), 0030, (nLInic + 11), 2375) // Linha: OBSERVACOES //alterado por Radu em 06/09/2022

	If Type("oCte:_CTEOS:_INFCTE:_IMP:_INFADFISCO:TEXT") <> "U"
		cObs := oCte:_CTEOS:_INFCTE:_IMP:_INFADFISCO:TEXT
	Endif  
	
	If Type("oCte:_CTEOS:_INFCTE:_COMPL:_XOBS:TEXT") <> "U"
		cObs += " " + oCte:_CTEOS:_INFCTE:_COMPL:_XOBS:TEXT
	Endif 
	
	If ( Type("oCte:_CTEOS:_INFCTE:_IMP:_INFTRIBFED") <> "U" )

		lCofins := Type("oCte:_CTEOS:_INFCTE:_IMP:_INFTRIBFED:_VCOFINS:TEXT") <> "U" .And. Val(oCte:_CTEOS:_INFCTE:_IMP:_INFTRIBFED:_VCOFINS:TEXT) > 0
		lCSLL 	:= Type("oCte:_CTEOS:_INFCTE:_IMP:_INFTRIBFED:_VCSLL:TEXT") <> "U" .And. Val(oCte:_CTEOS:_INFCTE:_IMP:_INFTRIBFED:_VCSLL:TEXT) > 0
		lINSS 	:= Type("oCte:_CTEOS:_INFCTE:_IMP:_INFTRIBFED:_VINSS:TEXT") <> "U" .And. Val(oCte:_CTEOS:_INFCTE:_IMP:_INFTRIBFED:_VINSS:TEXT) > 0
		lIR 	:= Type("oCte:_CTEOS:_INFCTE:_IMP:_INFTRIBFED:_VIR:TEXT") <> "U" .And. Val(oCte:_CTEOS:_INFCTE:_IMP:_INFTRIBFED:_VIR:TEXT) > 0		
		lPIS 	:= Type("oCte:_CTEOS:_INFCTE:_IMP:_INFTRIBFED:_VPIS:TEXT") <> "U" .And. Val(oCte:_CTEOS:_INFCTE:_IMP:_INFTRIBFED:_VPIS:TEXT) > 0
		
		If ( lCofins .Or. lCSLL .Or. lINSS .Or. lIR .Or. lPIS )
			cObs += chr(13) + chr(13) + "Impostos de Contribuição Social" 
		EndIf
		
		If ( lCofins )
		
			cObs += chr(13) 
			cObs += "COFINS:" + space(1) 
			cObs += Transform(Val(oCte:_CTEOS:_INFCTE:_IMP:_INFTRIBFED:_VCOFINS:TEXT),'@E 999,999,999.99')			

		EndIf
		
		If ( lCSLL )
		
			cObs += chr(13)
			cObs += "CSLL:" + space(1)
			cObs += Transform(Val(oCte:_CTEOS:_INFCTE:_IMP:_INFTRIBFED:_VCSLL:TEXT),'@E 999,999,999.99')
			cObs += " Retenção conforme IN/SRF Nº 459, DE 17 DE OUTUBRO DE 2004"

		EndIf
		
		If ( lINSS )
		
			cObs += chr(13)
			cObs += "INSS:" + space(1)
			cObs += Transform(Val(oCte:_CTEOS:_INFCTE:_IMP:_INFTRIBFED:_VINSS:TEXT),'@E 999,999,999.99')
			cObs += " Retenção conforme IN RFB971/09 art 122"

		EndIf
		
		If ( lIR )
		
			cObs += chr(13)
			cObs += "IR:" + space(1)
			cObs += Transform(Val(oCte:_CTEOS:_INFCTE:_IMP:_INFTRIBFED:_VIR:TEXT),'@E 999,999,999.99')
			cObs += " Retenção conforme Decreto Estadual nº 129, de 10 de maio de 2023"
			
		EndIf
		
		If ( lPIS )
		
			cObs += chr(13)
			cObs += "PIS:" + space(1)
			cObs += Transform(Val(oCte:_CTEOS:_INFCTE:_IMP:_INFTRIBFED:_VPIS:TEXT),'@E 999,999,999.99')
		
		EndIf
		
		cObs += chr(13)

	EndIf

	If Type("oCte:_CTEOS:_INFCTE:_COMPL:_OBSCONT") <> "U" 
		If	Type( "oCte:_CTEOS:_INFCTE:_COMPL:_OBSCONT" ) == "A"
			For nI := 1 to len(oCte:_CTEOS:_INFCTE:_COMPL:_OBSCONT)
					cInf:= oCte:_CTEOS:_INFCTE:_COMPL:_OBSCONT[nI]:_XTEXTO:TEXT
					While !Empty(cInf)
						aadd(aObsCont,SubStr(cInf,1,IIf(EspacoAt(cInf, MAXMENLIN) > 1, EspacoAt(cInf, MAXMENLIN) - 1, MAXMENLIN)))
						cInf := SubStr(cInf,IIf(EspacoAt(cInf, MAXMENLIN) > 1, EspacoAt(cInf, MAXMENLIN), MAXMENLIN) + 1)
					EndDo						
			Next nI
		Else
			cInf:= oCte:_CTEOS:_INFCTE:_COMPL:_OBSCONT:_XTEXTO:TEXT
			While !Empty(cInf)
				aadd(aObsCont,SubStr(cInf,1,IIf(EspacoAt(cInf, MAXMENLIN) > 1, EspacoAt(cInf, MAXMENLIN) - 1, MAXMENLIN)))
				cInf := SubStr(cInf,IIf(EspacoAt(cInf, MAXMENLIN) > 1, EspacoAt(cInf, MAXMENLIN), MAXMENLIN) + 1)
			EndDo					
		EndIf
	EndIf
	
	If Type("oCte:_CTEOS:_INFCTE:_COMPL:_OBSFISCO") <> "U" 
		If	Type( "oCte:_CTEOS:_INFCTE:_COMPL:_OBSFISCO" ) == "A"
			For nI := 1 to len(oCte:_CTEOS:_INFCTE:_COMPL:_OBSFISCO)
					cInf:= oCte:_CTEOS:_INFCTE:_COMPL:_OBSFISCO[nI]:_XTEXTO:TEXT
					While !Empty(cInf)
						aadd(aObsFisco,SubStr(cInf,1,IIf(EspacoAt(cInf, MAXMENFISC) > 1, EspacoAt(cInf, MAXMENFISC) - 1, MAXMENFISC)))
						cInf := SubStr(cInf,IIf(EspacoAt(cInf, MAXMENFISC) > 1, EspacoAt(cInf, MAXMENFISC), MAXMENFISC) + 1)
					EndDo						
			Next nI
		Else
			cInf:= oCte:_CTEOS:_INFCTE:_COMPL:_OBSFISCO:_XTEXTO:TEXT
			While !Empty(cInf)
				aadd(aObsFisco,SubStr(cInf,1,IIf(EspacoAt(cInf, MAXMENFISC) > 1, EspacoAt(cInf, MAXMENFISC) - 1, MAXMENFISC)))
				cInf := SubStr(cInf,IIf(EspacoAt(cInf, MAXMENFISC) > 1, EspacoAt(cInf, MAXMENFISC), MAXMENFISC) + 1)
			EndDo					
		EndIf
	EndIf 
	
	nLInic 	+= 42	
	//alterado por Radu em 06/09/2022 
	WordWrap(cObs,nLInic,oDacte,oFont05)

	nLInic  += RetTamTex(oDacte,"X",oFont08:oFont) + nSoma
	oDacte:Say (nLInic, 0045, ""/*cDTCObs*/, oFont08:oFont)

	nLInic  += RetTamTex(oDacte,"X",oFont08:oFont) + nSoma
	oDacte:Say (nLInic, 0045, ""/*cDTCObs2*/, oFont08:oFont)
	nLInic += 35
	nDifEsq:= 20	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ BOX SEGURO DA VIAGEM                        								³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nLInic += 200 + RetTamTex(oDacte,"X",oFont08:oFont)	//alterado por Radu em 06/09/2022 //100 +
	nLFim  := (nLInic + RetTamTex(oDacte,"X",oFont08:oFont))
	oDacte:Box(nLInic, 0030, (nLFim + 160), 2375)

	nSoma  := 13
	nLInic += RetTamTex(oDacte,"X",oFont08:oFont) + nSoma
	oDacte:Say(nLInic, 1050, "Seguro da Viagem", oFont08N:oFont)
	oDacte:Line((nLInic + 11), 0030, (nLInic + 11), 2375)
	
	nLInic  := CalcLinha(1, 1, nLInic, nSoma, oDacte, oFont08:oFont, 2)
	
	nSoma	:= 30
	nLInic	+= RetTamTex(oDacte,"X",oFont08:oFont) + nSoma
		
	oDacte:Say(nLInic, 0040, "Responsável", oFont07N:oFont)
	oDacte:Say(nLInic, 0800, "Número da Seguradora", oFont07N:oFont)//850
	oDacte:Say(nLInic, 1600, "Número da Apólice", oFont07N:oFont)//650
	
	oDacte:Line(nLInic-30, 790, nLFim + 159 , 790)		// Separador Responsavel / Numero Seguradora
	oDacte:Line(nLInic-30, 1590, nLFim + 159 , 1590)	// Separador Numero Seguradora / Número Apólice
	
	
	If Type("oCte:_CTEOS:_INFCTE:_INFCTENORM:_SEG:_XSEG") <> "U"
		cXSeg := Alltrim(oCte:_CTEOS:_INFCTE:_INFCTENORM:_SEG:_XSEG:TEXT)
	Endif
	
	If Type("oCte:_CTEOS:_INFCTE:_INFCTENORM:_SEG:_RESPSEG") <> "U"
		cSegResp := oCte:_CTEOS:_INFCTE:_INFCTENORM:_SEG:_RESPSEG:TEXT 
			
		If ( cSegResp == "4" )   
			cSegResp := "Emitente do CT-e"  
		elseif ( cSegResp == "5" )   
			cSegResp := "Tomador do Serviço"
		endif			
			
	Endif
	
	If Type("oCte:_CTEOS:_INFCTE:_INFCTENORM:_SEG:_NAPOL") <> "U"		
		cSegNrApoli := oCte:_CTEOS:_INFCTE:_INFCTENORM:_SEG:_NAPOL:TEXT 					
	Endif
		
	oDacte:Say(nLInic + 30 , 0040, cSegResp, oFont08:oFont)	  
		
	oDacte:Say(nLInic + 30 , 0800,cXSeg, oFont08:oFont)	
		
	oDacte:Say(nLInic + 30, 1600, cSegNrApoli, oFont08:oFont)
		
	nLInic += 110
	nDifEsq:= 20
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ BOX INFORMAÇÕES ESPECIFICAS DO MODAL RODOVIÁRIO                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nLInic += RetTamTex(oDacte,"X",oFont08:oFont)
	nLFim  := (nLInic + RetTamTex(oDacte,"X",oFont08:oFont))
	oDacte:Box(nLInic, 0030, (nLFim + 120), 2375)//160

	nSoma  := 13
	nLInic += RetTamTex(oDacte,"X",oFont08:oFont) + nSoma
	oDacte:Say(nLInic, 0850, "Informações específicas do Modal Rodoviário", oFont08N:oFont)
	oDacte:Line((nLInic + 11), 0030, (nLInic + 11), 2375)
	
	nLInic  := CalcLinha(1, 1, nLInic, nSoma, oDacte, oFont08:oFont, 2)
	
	nSoma	:= 30
	nLInic	+= RetTamTex(oDacte,"X",oFont08:oFont) + nSoma
		
	oDacte:Say(nLInic, 0040, "Tempo de Autorização de Fretamento", oFont07N:oFont)
	oDacte:Say(nLInic, 0500, "Número de Registro Estadual", oFont07N:oFont)
	oDacte:Say(nLInic, 1000, "Placa do Veículo", oFont07N:oFont)
	oDacte:Say(nLInic, 1500, "RENAVAM do Veículo", oFont07N:oFont)
	oDacte:Say(nLInic, 2000, "CNPJ/CPF", oFont07N:oFont)
	
	oDacte:Line(nLInic-30, 490, nLFim + 119 , 490)// Separador Tempo / Numero Registro
	oDacte:Line(nLInic-30, 0990, nLFim + 119 , 0990)// Separador Numero Registro / Placa
	oDacte:Line(nLInic-30, 1490, nLFim + 119 , 1490)// Separador Placa / Renavam
	oDacte:Line(nLInic-30, 1990, nLFim + 119 , 1990)// Separador Renavam / CNPJ
	
	
	If Type("oCte:_CTEOS:_INFCTE:_INFCTENORM:_INFMODAL:_RODOOS:_TAF") <> "U"	
		cTAF := Alltrim (oCte:_CTEOS:_INFCTE:_INFCTENORM:_INFMODAL:_RODOOS:_TAF:TEXT)
	EndIf
	
	If Type("oCte:_CTEOS:_INFCTE:_INFCTENORM:_INFMODAL:_RODOOS:_NROREGESTADUAL") <> "U"
		cNrRegEst := Alltrim (oCte:_CTEOS:_INFCTE:_INFCTENORM:_INFMODAL:_RODOOS:_NROREGESTADUAL:TEXT)		
	EndIf
	
	If Type("oCte:_CTEOS:_INFCTE:_INFCTENORM:_INFMODAL:_RODOOS:_VEIC") <> "U"
		cPlacaVeic := Alltrim (oCte:_CTEOS:_INFCTE:_INFCTENORM:_INFMODAL:_RODOOS:_VEIC:_PLACA:TEXT)
		
		If Type("oCte:_CTEOS:_INFCTE:_INFCTENORM:_INFMODAL:_RODOOS:_VEIC:_RENAVAM") <> "U"
			cRenavam := Alltrim (oCte:_CTEOS:_INFCTE:_INFCTENORM:_INFMODAL:_RODOOS:_VEIC:_RENAVAM:TEXT)
		EndIf
		
		If Type("oCte:_CTEOS:_INFCTE:_INFCTENORM:_INFMODAL:_RODOOS:_VEIC:_PROP") <> "U"
		
			If Type("oCte:_CTEOS:_INFCTE:_INFCTENORM:_INFMODAL:_RODOOS:_VEIC:_PROP:_CPF") <> "U"
				cPCpfCnpj := Transform(AllTrim(oCte:_CTEOS:_INFCTE:_INFCTENORM:_INFMODAL:_RODOOS:_VEIC:_PROP:_CPF:TEXT),"@r 999.999.999-99")
			ElseIf Type("oCte:_CTEOS:_INFCTE:_INFCTENORM:_INFMODAL:_RODOOS:_VEIC:_PROP:_CNPJ") <> "U"
				cPCpfCnpj := Transform(AllTrim(oCte:_CTEOS:_INFCTE:_INFCTENORM:_INFMODAL:_RODOOS:_VEIC:_PROP:_CPF:TEXT),"@r 99.999.999/9999-99")
			EndIf
			
			If Type("oCte:_CTEOS:_INFCTE:_INFCTENORM:_INFMODAL:_RODOOS:_VEIC:_PROP:_TAF") <> "U"
				cPropTaf := Alltrim(oCte:_CTEOS:_INFCTE:_INFCTENORM:_INFMODAL:_RODOOS:_VEIC:_PROP:_TAF:TEXT)
			EndIf
			
			If Type("oCte:_CTEOS:_INFCTE:_INFCTENORM:_INFMODAL:_RODOOS:_VEIC:_PROP:_NROREGESTADUAL") <> "U"
				cPropNrRegEst := Alltrim(oCte:_CTEOS:_INFCTE:_INFCTENORM:_INFMODAL:_RODOOS:_VEIC:_PROP:_NROREGESTADUAL:TEXT)
			EndIf
		EndIf
		
	EndIf
	
	oDacte:Say(nLInic+30, 0040, IIF(!Empty(cTAF),cTAF,IIF(!Empty(cPropTaf),cPropTaf,"")), oFont07:oFont)
	oDacte:Say(nLInic+60, 0040, IIF(!Empty(cPropTaf),cPropTaf,""), oFont07:oFont)	
	oDacte:Say(nLInic+30, 0500, IIF(!Empty(cNrRegEst),cNrRegEst,IIF(!Empty(cPropNrRegEst),cPropNrRegEst,"")), oFont07:oFont)
	oDacte:Say(nLInic+60, 0500, IIF(!Empty(cPropNrRegEst),cPropNrRegEst,""), oFont07:oFont)
	oDacte:Say(nLInic+30, 1000, cPlacaVeic, oFont07:oFont)
	oDacte:Say(nLInic+30, 1500, cRenavam, oFont07:oFont)
	oDacte:Say(nLInic+30, 2000, cPCpfCnpj, oFont07:oFont)
		
    
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ BOX: USO EXCLUSIVO DO EMISSOR + RESERVADO AO FISCO                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nLInic += 40
		
	nDifEsq := 180
	nLInic  += RetTamTex(oDacte,"X",oFont08:oFont) + nSoma
	nLFim   := (nLInic + RetTamTex(oDacte,"X",oFont08:oFont) + nSoma)
	oDacte:Box(nLInic , 0030, (nLFim + nDifEsq), 2375)
	
	nSoma   := 13
	nLInic  += RetTamTex(oDacte,"X",oFont08:oFont) + nSoma
	oDacte:Say(nLInic , 0550, "Uso Exclusivo do Emissor do CT-e", oFont08N:oFont)
	oDacte:Say(nLInic , 1770, "Reservado ao Fisco", oFont08N:oFont)
	
	nSoma:= 45
	For nX := 1 to len(aObsCont)
		If nX > 6
			Exit
		EndIf	
		
		oDacte:Say(nLInic + nSoma, 0035, aObsCont[nX], oFont08:oFont)		
		nSoma += 30
		
	Next
	
	If Len(aObsCont) > 0
		
		nSoma:= 45
		For nX := 1 to len(aObsFisco)
			If nX > 6
				Exit
			EndIf	
			
			oDacte:Say(nLInic + nSoma , 1505, aObsFisco[nX], oFont08:oFont)		
			nSoma += 30
			
		Next
	EndIf
	
	nLInic  += RetTamTex(oDacte,"X",oFont08:oFont)
	oDacte:Line(nLInic, 0030, nLInic , 2375) //Separador horizontal
	nHDiv	:= 100

	oDacte:Line(nLInic-37, 1490, 2078+nHDiv, 1490) //Separador vertical - alterado por Radu em 06/09/2022
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ BOX: CANHOTO                                      						  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nSoma   := 210
	nDifEsq := 180
	nLInic  += RetTamTex(oDacte,"X",oFont08:oFont) + nSoma
	nLFim   := (nLInic + RetTamTex(oDacte,"X",oFont08:oFont) + nSoma)
	oDacte:Box(nLInic-20 , 0030, 2400 + nHDiv , 2375)

	nSoma   := 15
	nLInic  += RetTamTex(oDacte,"X",oFont08:oFont) + nSoma + 30
	oDacte:Say(nLInic , 0035, "DECLARO QUE RECEBI OS VOLUMES DESTE CONHECIMENTO EM PERFEITO ESTADO PELO QUE DOU POR CUMPRIDO O PRESENTE CONTRATO DE TRANSPORTE", oFont08N:oFont)	//"DECLARO QUE RECEBI OS VOLUMES DESTE CONHECIMENTO EM PERFEITO ESTADO PELO QUE DOU POR CUMPRIDO O PRESENTE CONTRATO DE TRANSPORTE"
	
	nLInic  += RetTamTex(oDacte,"X",oFont08:oFont)
	oDacte:Line(nLInic, 0700, 2398 + nHDiv, 0700) 	// Linha: Separador NOME e RG - alterado por Radu em 06/09/2022
	oDacte:Line(nLInic, 1670, 2398 + nHDiv, 1670) 	// Linha Horizontal: Separador Término e Início 1690
	oDacte:Line(nLInic, 0030, nLInic, 2375) 		// Linha: DECLARO QUE RECEBI...
	oDacte:Line(nLInic, 2100, 2398 + nHDiv, 2100) 	// Linha: Separador CT-e/ Número /Série

	nSoma   := 10
	nLInic  += RetTamTex(oDacte,"X",oFont08:oFont) + nSoma
	For nCount := 1 To 6
		Do Case
			Case ( nCount == 1 )
				oDacte:Say(nLInic + 5 , 0035, "Nome", oFont08N:oFont)	//"Nome"
				oDacte:Say(nLInic + 5, 1680, "Término da Prestação - Data / Hora", oFont08N:oFont)
				oDacte:Say(nLInic + 40, 2190, "CT-E OS", oFont08N:oFont)
				oDacte:Say(nLInic + 90, 2110, "Nro:", oFont08N:oFont)
				oDacte:Say(nLInic + 90, 2200, cValtoChar( Val (aCab[1][1]) ), oFont08:oFont) //Impressão do Número do Documento
				oDacte:Say(nLInic + 140, 2110, "Série:", oFont08N:oFont)
				oDacte:Say(nLInic + 140, 2200, cValtoChar( Val(aCab[1][2]) ), oFont08:oFont) //Impressão da Série do Documento
			Case ( nCount == 6 )
				oDacte:Line(nLInic, 0030, nLInic, 0700) // Linha vertical: NOME 
				oDacte:Line(nLInic, 1670, nLInic, 2100) // Linha vertical: Término da Prestação 
				oDacte:Say((nLInic + 25), 0035, "R.G", oFont08N:oFont)	//"R.G"
				oDacte:Say((nLInic + 080), 1100, "Assinatura / Carimbo", oFont08N:oFont) 
				oDacte:Say((nLInic + 25), 1680, "Início da Prestação - Data / Hora", oFont08N:oFont)				
		EndCase
		
		nLInic += RetTamTex(oDacte,"X",oFont08:oFont) + nSoma
	Next nCount

	nLInic := CalcLinha(1, 5, nLInic, 12, oDacte, oFont08:oFont, 0) // Solicitacao para que sejam "calculadas" as linhas faltantes para completar o BOX

	oDacte:EndPage()	
	
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³CalcLinha ³ Autor ³Adalberto SM           ³ Data ³09/02/09  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao responsavel por Calcular o numero de linhas necessa- ³±±
±±³          ³rias para completar o layout, da sessao solicitante.        ³±±
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
Static Function CalcLinha(nInic, nTot, nLInic, nSoma, oDacte, oFont, nMod)

Local nCount := 0
Default nMod := 0

For nCount := nInic To nTot
	If ( nMod = 0 )
		nLInic   += RetTamTex(oDacte,"X",oFont) + nSoma
	Else
		// FORCAR UMA "QUEBRA" DE LINHA, SENDO O CAMPO nMod A QUANTIDADE DE "COLUNAS" POR LINHA.
		If ( (mod(nCount, nMod)) == 0 )
			nSoma    := nSoma
			nLInic   += RetTamTex(oDacte,"X",oFont) + nSoma
		EndIf
	EndIf

Next nCount

Return(nLInic)

//-----------------------------------------------------------------------
/*/{Protheus.doc} TMSR25Cab
Funcao responsavel por montar o cabecalho do relatorio.

@param		oDacte		Objeto 		
			aCab		Array do cabecalho.

@return	Nil

@author Natalia Sartori
@since 06.02.2017
@version 1.0 
/*/
//-----------------------------------------------------------------------
Static Function TMSR25Cab(oDacte,aCab)

Local cEndEmit	:= ""
Local cMunEmit	:= ""
Local cUfEmit		:= ""
Local cCepEmit	:= "" 
Local cCNPJEmit	:= ""
Local cIEEmit		:= ""
//--Insira o caminho do Logo da empresa, na variavel cLogoTp.
//Local cLogoTp   := TSSPFixLgo( 2, aCab[7] )
Local cLogoTp      	:= FisxLogo("1")
Local cLink		:= "https://dfe-portal.svrs.rs.gov.br"+"/cte/qrCode?"
Local cChaveCte	:= "chCTe="+STRTRAN(OCTE:_CTEOS:_INFCTE:_ID:TEXT,'CTe','')
Local cAmbiente := "&tpAmb="+OCTE:_CTEOS:_INFCTE:_IDE:_TPAMB:TEXT
Local lNomFan   := SuperGetMv('MV_NOMFAN', .F., .F.) //se imprime nome fantasia DACTEOS

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ INICIO ROTINA DE IMPRESSAO                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ MONTAGEM SETOR: INFORMACOES DACTE                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BOX: Empresa / DACTE / MODAL / LOGO                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oDacte:EndPage()
oDacte:StartPage()

nLInic := 30
nLFim  := (nLInic + 65)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³BOX: Logotipo									                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oDacte:Box(nLInic, 0030, 00480, 1400)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³BOX: Dacte OS									                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oDacte:Box(nLInic, 1400, nLFim, 2100)//Box Dacte OS

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³BOX: Modal									                           		³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oDacte:Box(nLInic, 2100, nLFim, 2368)//Box Modal
oDaCte:SayBitmap(nLInic + 10,050,cLogoTp,600,200)

nSoma  := 11
nLInic += RetTamTex(oDacte,"X",oFont08N:oFont) + nSoma
oDacte:Say(nLInic, 1670,"DACTE OS",oFont08N:oFont)
oDacte:Say(nLInic, 2175,"MODAL",oFont08N:oFont)		//"MODAL"

nSoma := 11
nLInic += RetTamTex(oDacte,"X",oFont08:oFont) + nSoma
oDacte:Say(nLInic, 2150, GetModal(oCte:_CTEOS:_INFCTE:_IDE:_MODAL:TEXT),oFont08:oFont)	

oDacte:Say(nLInic, 1414, "Documento Auxiliar do Conhecimento de Transporte Eletrônico para Outros Serviços",oFont05:oFont)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³BOX: Modelo / Serie / Numero / Folha / Emis                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nSoma  := 7
nLInic += RetTamTex(oDacte,"X",oFont08:oFont) + nSoma
nLFim  := (nLInic + 70)
oDacte:Box(nLInic, 1400, nLFim    , 2368)

nSoma  := 12
nLInic += RetTamTex(oDacte,"X",oFont08:oFont) + nSoma
oDacte:Say(nLInic, 1450, "Modelo", oFont08N:oFont)	//"Modelo"
oDacte:Say(nLInic, 1600, "Série", oFont08N:oFont)	//"Série"
oDacte:Say(nLInic, 1710, "Número", oFont08N:oFont)	//"Número"
oDacte:Say(nLInic, 1900, "Folha", oFont08N:oFont)	//"Folha"
oDacte:Say(nLInic, 2130, "Emissão", oFont08N:oFont)	//"Emissão"

nSoma  := 14
nLInic += RetTamTex(oDacte,"X",oFont08:oFont) + nSoma
oDacte:Say(nLInic, 1485,"67",oFont08:oFont)

oDacte:Say(nLInic, 1605,cValtoChar( Val(aCab[2]) ) , oFont08:oFont)

oDacte:Say(nLInic, 1710, cValtoChar( Val(aCab[1]) ), oFont08:oFont)

oDacte:Say(nLInic, 1900, AllTrim(Str(nFolhAtu)) + " / " + AllTrim(Str(nFolhas++)), oFont08:oFont)

oDacte:Say(nLInic, 2075, SubStr(AllTrim(aCab[3]), 7, 2) + '/' + SubStr(AllTrim(aCab[3]), 5, 2) + "/" +;
SubStr(AllTrim(aCab[3]), 1, 4) + " - " + SubStr(AllTrim(aCab[4]), 1, 2) + ":"+;
SubStr(AllTrim(aCab[4]), 3, 2) + ":00")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³BOX: Controle do Fisco						                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nSoma  := 04
nLInic += RetTamTex(oDacte,"X",oFont08:oFont) + nSoma
nLFim  := (nLInic + 307)
oDacte:Box(nLInic, 1400, nLFim, 2368)

nSoma  := 12
nLInic += RetTamTex(oDacte,"X",oFont08N:oFont) + nSoma
oDacte:Say(nLInic, 1750,(Upper("Controle do Fisco")),oFont08N:oFont) 	//"Controle do Fisco"

//-- Codigo de Barras
If Type("oCte:_CTEOS:_INFCTE:_ID:TEXT") <> "U" .And. !Empty(oCte:_CTEOS:_INFCTE:_ID:TEXT)
	oDacte:Code128C(0350,1440,SubStr(Alltrim(oCte:_CTEOS:_INFCTE:_ID:TEXT),4),30) 
Endif

			//nRow | nCol | cCodeBar | nSizeBar
oDacte:QrCode(0445,900,cLink+cChaveCte+cAmbiente, 110)  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BOX: EMPRESA - NOME                                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nSoma  := 60
nLInic += RetTamTex(oDacte,"X",oFont08:oFont) + nSoma
If Type("oCte:_CTEOS:_INFCTE:_EMIT:_XNOME:TEXT") <> "U" .And. !Empty(oCte:_CTEOS:_INFCTE:_EMIT:_XNOME:TEXT)
	if lNomFan 
		oDacte:Say(nLInic, 40, AllTrim(oCte:_CTEOS:_INFCTE:_EMIT:_XFANT:TEXT),oFont08:oFont)
	Else
		oDacte:Say(nLInic, 40, AllTrim(oCte:_CTEOS:_INFCTE:_EMIT:_XNOME:TEXT),oFont08:oFont)
	endif
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BOX: EMPRESA - ENDERECO                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nSoma  := 26
nLInic += RetTamTex(oDacte,"X",oFont08:oFont) + nSoma
If Type("oCte:_CTEOS:_INFCTE:_EMIT:_ENDEREMIT:_XLGR:TEXT") <> "U" .And. !Empty(oCte:_CTEOS:_INFCTE:_EMIT:_ENDEREMIT:_XLGR:TEXT)
	cEndEmit := Alltrim(oCte:_CTEOS:_INFCTE:_EMIT:_ENDEREMIT:_XLGR:TEXT)
	cEndEmit += ", "+Alltrim(oCte:_CTEOS:_INFCTE:_EMIT:_ENDEREMIT:_NRO:TEXT)
	oDacte:Say(nLInic,40,cEndEmit,oFont08:oFont)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BOX: EMPRESA - BAIRRO                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nSoma  := 26
nLInic += RetTamTex(oDacte,"X",oFont08:oFont) + nSoma
If Type("oCte:_CTEOS:_INFCTE:_EMIT:_ENDEREMIT:_XBAIRRO:TEXT") <> "U" .And. !Empty(oCte:_CTEOS:_INFCTE:_EMIT:_ENDEREMIT:_XBAIRRO:TEXT)
	oDacte:Say(nLInic,40,AllTrim(oCte:_CTEOS:_INFCTE:_EMIT:_ENDEREMIT:_XBAIRRO:TEXT),oFont08:oFont)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BOX: EMPRESA - UF / MUNICIPIO / CEP                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nSoma  := 26
nLInic += RetTamTex(oDacte,"X",oFont08:oFont) + nSoma
If Type("oCte:_CTEOS:_INFCTE:_EMIT:_ENDEREMIT:_XMUN:TEXT") <> "U" .And. !Empty(oCte:_CTEOS:_INFCTE:_EMIT:_ENDEREMIT:_XMUN:TEXT)
	cMunEmit	:= Alltrim(oCte:_CTEOS:_INFCTE:_EMIT:_ENDEREMIT:_XMUN:TEXT)
Endif
If Type("oCte:_CTEOS:_INFCTE:_EMIT:_ENDEREMIT:_UF:TEXT") <> "U" .And. !Empty(oCte:_CTEOS:_INFCTE:_EMIT:_ENDEREMIT:_UF:TEXT)
	cUfEmit		:= Alltrim(oCte:_CTEOS:_INFCTE:_EMIT:_ENDEREMIT:_UF:TEXT)
Endif
If Type("oCte:_CTEOS:_INFCTE:_EMIT:_ENDEREMIT:_CEP:TEXT") <> "U" .And. !Empty(oCte:_CTEOS:_INFCTE:_EMIT:_ENDEREMIT:_CEP:TEXT)
	cCepEmit	:= Alltrim(oCte:_CTEOS:_INFCTE:_EMIT:_ENDEREMIT:_CEP:TEXT)
Endif
oDacte:Say(nLInic, 40, AllTrim(cMunEmit) + '  -  ' + AllTrim(cUfEmit) + '  CEP.:  ' + AllTrim(cCepEmit) ,oFont08:oFont)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BOX: EMPRESA - CNPJ e INSCRICAO EST.                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nSoma   := 26
nDifEsq := 3
nLInic  += RetTamTex(oDacte,"X",oFont08:oFont) + nSoma
If Type("oCte:_CTEOS:_INFCTE:_EMIT:_CNPJ:TEXT") <> "U" .And. !Empty(oCte:_CTEOS:_INFCTE:_EMIT:_CNPJ:TEXT)
	cCNPJEmit 	:= Alltrim(oCte:_CTEOS:_INFCTE:_EMIT:_CNPJ:TEXT)
Endif
If Type("oCte:_CTEOS:_INFCTE:_EMIT:_IE:TEXT") <> "U" .And. !Empty(oCte:_CTEOS:_INFCTE:_EMIT:_IE:TEXT)
	cIEEmit		:= Alltrim(oCte:_CTEOS:_INFCTE:_EMIT:_IE:TEXT)
Endif
oDacte:Say(nLInic, 40, "CNPJ: " + Transform(AllTrim(cCNPJEmit),"@r 99.999.999/9999-99") + Space(7) + "Inscrição Estadual: " + AllTrim(cIEEmit), oFont08:oFont)	//"CNPJ: "###"Inscrição Estadual: "

oDacte:Line( (nLInic - 15), 1410, (nLInic - 15), 2360 )
oDacte:Say( (nLInic + nDifEsq), 1445,"Chave de acesso para consulta de autenticidade no site www.cte.fazenda.gov.br",oFont07:oFont)	//"Chave de acesso para consulta de autenticidade no site www.cte.fazenda.gov.br"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BOX: EMPRESA - TELEFONE                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nSoma   := 26
nDifEsq := 50
nLInic  += RetTamTex(oDacte,"X",oFont08:oFont) + nSoma

If Type("oCte:_CTEOS:_INFCTE:_EMIT:_ENDEREMIT:_FONE:TEXT") <> "U" .And. !Empty(oCte:_CTEOS:_INFCTE:_EMIT:_ENDEREMIT:_FONE:TEXT)
	oDacte:Say(nLInic, 40,'Telefone: ' + AllTrim(oCte:_CTEOS:_INFCTE:_EMIT:_ENDEREMIT:_FONE:TEXT),oFont08:oFont)
Endif

oDacte:Say(nLInic, 1455, Transform(AllTrim(aCab[5]),"@r 99.9999.99.999.999/9999-99-99-999-999.999.999.999.999.999.9"), oFont08N:oFont)

//-- BOX: Tipo do CTe
nLInic  += (RetTamTex(oDacte,"X",oFont08:oFont))
nLFim   := (nLInic + RetTamTex(oDacte,"X",oFont08:oFont) + nSoma)

//-- BOX: CFOP
oDacte:Box((nLInic - 5), 0030, (nLFim + 5) , 2370)
oDacte:Line((nLInic - 5), 0630, nLFim , 0630) // Separador Tp.Servico e Tomador
oDacte:Line((nLInic - 5), 1400, nLFim , 1400) // Separador Forma Pagto e Num. Protocolo

nSoma   := 4
nLInic  += RetTamTex(oDacte,"X",oFont07:oFont) + nSoma
oDacte:Say(nLInic, 0035, "Tipo do CTe", oFont07N:oFont)	//"Tipo do CTe"
oDacte:Say(nLInic, 0635, "Tipo de Serviço", oFont07N:oFont)	//"Tipo de Serviço"


oDacte:Say(nLInic, 1450, "Número do Protocolo", oFont07N:oFont)	//"Número do Protocolo"
oDacte:Say(nLInic+20,1450,aCab[6],oFont07:oFont) //Impressão número do Protocolo

nSoma  := 08
nLInic += RetTamTex(oDacte,"X",oFont08:oFont) + nSoma
nLFim  := (nLInic + RetTamTex(oDacte,"X",oFont08:oFont) + nSoma)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tipo de Conhecimento                                                   ³
//³ 0 - Normal                                                             ³
//³ 1 - Complemento de Valores                                             ³
//³ 2 - Anulação de Valores                                                ³
//³ 3 - Substituto                                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Type("oCte:_CTEOS:_INFCTE:_IDE:_TPCTE:TEXT") <> "U" 
	Do Case
		Case oCte:_CTEOS:_INFCTE:_IDE:_TPCTE:TEXT == "0"
			oDacte:Say(nLInic,0035,"NORMAL",oFont07:oFont)	//"NORMAL"
		Case oCte:_CTEOS:_INFCTE:_IDE:_TPCTE:TEXT == "1"
			oDacte:Say(nLInic,0035,"COMPLEMENTO",oFont07:oFont)	//"COMPLEMENTO"
		Case oCte:_CTEOS:_INFCTE:_IDE:_TPCTE:TEXT == "2"
			oDacte:Say(nLInic,0035,"ANULACAO",oFont07:oFont)	//"ANULACAO"
		Case oCte:_CTEOS:_INFCTE:_IDE:_TPCTE:TEXT == "3"
			oDacte:Say(nLInic,0035,"SUBSTITUTO",oFont07:oFont)	//"SUBSTITUTO"
	EndCase
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tipo de Servico                                                 ³
//³ 6 - Transporte de Pessoas                                       ³
//³ 7 - Transporte de Valores                                       ³
//³ 8 - Excesso de Bagagem                                      	  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Type("oCte:_CTEOS:_INFCTE:_IDE:_TPSERV:TEXT") <> "U" 
	Do Case
		Case oCte:_CTEOS:_INFCTE:_IDE:_TPSERV:TEXT == "6"
			oDacte:Say(nLInic, 0635, "TRANSPORTE DE PESSOAS", oFont07:oFont)
		Case oCte:_CTEOS:_INFCTE:_IDE:_TPSERV:TEXT == "7"
			oDacte:Say(nLInic, 0635, "TRANSPORTE DE VALORES", oFont07:oFont)
		Case oCte:_CTEOS:_INFCTE:_IDE:_TPSERV:TEXT == "8"
			oDacte:Say(nLInic, 0635, "EXCESSO DE BAGAGEM", oFont07:oFont)
	EndCase
Endif

Return

//-----------------------------------------------------------------------
/*/{Protheus.doc} TMSR25Comp
Funcao responsavel por montar os Boxes:
			- Informações da Prestação do Serviço
			- Componentes do Valor da Prestação do Serviço
			- Informações relativas ao imposto

@param		oDacte		Objeto 		
			aCab		Array do cabecalho.

@return	Nil

@author Natalia Sartori
@since 06.02.2017
@version 1.0 
/*/
//-----------------------------------------------------------------------
Static Function TMSR25Comp(oDacte)

Local aSitTrib	:= {}
Local aComp		:= {}
Local cLabel		:= ""
Local nCInic		:= 0			// Coluna Inicial
Local cSitTrib	:= "Sit Trib"		//"Sit Trib"
Local cBaseIcms	:= 0			//-- Base de Calculo
Local cAliqIcms	:= 0			//-- Aliquota ICMS
Local cValIcms	:= 0			//-- Valor ICMS
Local cRedBcCalc	:= 0			//-- "Red.Bc.Calc."
Local cDescServ	:= ""
Local cQtdCarga	:= ""
Local nCount		:= 0
Local nCount_2	:= 0
Local nCount_3	:= 0
Local nPos			:= 0
Local lControl	:= .F.
Local lZraCTEO	:= SuperGetMV('MV_ZRACTEO',.F.,.F.)


//-- Array da Situacao Tributaria
AADD(aSitTrib,{"00","Tributação normal ICMS"})	//"Tributada Integralmente"
AADD(aSitTrib,{"10","Tributada,c/cobr. ICMS por Substituição Trib."})	//"Tributada,c/cobr. ICMS por Substituição Trib."
AADD(aSitTrib,{"20","Com redução de Base de Cálculo"})	//"Com redução de Base de Cálculo"
AADD(aSitTrib,{"30","Isenta ou não trib.,c/cobr. ICMS por Subst. Trib."})	//"Isenta ou não trib.,c/cobr. ICMS por Subst. Trib."
AADD(aSitTrib,{"40","Isenta"})	//"Isenta"
AADD(aSitTrib,{"41","Não Tributada"})	//"Não Tributada"
AADD(aSitTrib,{"50","Com suspensão"})	//"Com suspensão"
AADD(aSitTrib,{"51","Diferimento"})	//"Diferimento"
AADD(aSitTrib,{"60","ICMS cobrado anteriormente por Subst. Trib."})	//"ICMS cobrado anteriormente por Subst. Trib."
AADD(aSitTrib,{"70","C/redução de Base de Cálc. e cobr./ICMS p/Subst. Trib."})	//"C/redução de Base de Cálc. e cobr./ICMS p/Subst. Trib."
AADD(aSitTrib,{"90","Outras"})	//"Outras"

//-- BOX: Informações da Prestação do Serviço
nSoma   := 18

nDifEsq := 178
nLInic  += RetTamTex(oDacte,"X",oFont08:oFont) + nSoma
nLFim   := (nLInic + RetTamTex(oDacte,"X",oFont08:oFont) + nSoma)
oDacte:Box(nLInic , 0030, (nLFim + nDifEsq), 2370)

nSoma   := 11
nDifEsq := 168
nLInic  += RetTamTex(oDacte,"X",oFont08:oFont) + nSoma
oDacte:Say(nLInic , 0850, "Informações da Prestação do Serviço", oFont08N:oFont)	

oDacte:Line((nLInic + 8), 0030, (nLInic + 8), 2368)//Separador Inf. Prest. Serv.

oDacte:Say(nLInic + 40, 0040, "Quantidade", oFont07N:oFont)
oDacte:Say(nLInic + 40, 0250, "Descrição do serviço prestado", oFont07N:oFont)//850

oDacte:Line(nLInic +10, 240, nLFim + 174 , 240)// Separador Quantidade / descrição

If Type("oCte:_CTEOS:_INFCTE:_INFCTENORM:_INFSERVICO") <> "U"
	cDescServ:= Alltrim(oCte:_CTEOS:_INFCTE:_INFCTENORM:_INFSERVICO:_XDESCSERV:TEXT)
	If Type("oCte:_CTEOS:_INFCTE:_INFCTENORM:_INFSERVICO:_INFQ") <> "U"
		cQtdCarga:= PadL(Transform(Val(oCte:_CTEOS:_INFCTE:_INFCTENORM:_INFSERVICO:_INFQ:_QCARGA:TEXT),"@E 99,999,999.9999"),20)
	EndIf
	oDacte:Say(nLInic + 80, 0040, cQtdCarga, oFont08:oFont)
	oDacte:Say(nLInic + 80, 0250, cDescServ, oFont08:oFont)	
EndIf

//-- BOX: Componentes da Prestacao
nSoma   := 180

nDifEsq := 178
nLInic  += RetTamTex(oDacte,"X",oFont08:oFont) + nSoma
nLFim   := (nLInic + RetTamTex(oDacte,"X",oFont08:oFont) + nSoma)
oDacte:Box(nLInic , 0030, (nLFim + nDifEsq), 2370)

nSoma   := 11
nDifEsq := 168
nLInic  += RetTamTex(oDacte,"X",oFont08:oFont) + nSoma
oDacte:Say(nLInic , 0850, "Componentes do Valor da Prestação de Serviço", oFont08N:oFont)	//"Componentes do Valor da Prestação de Serviço"

//-- Separador Linha
oDacte:Line((nLInic + 8), 0030, (nLInic + 8), 2368)

//-- BOX: Valor Total do Servico / Valor Receber
nSoma   := 6
nDifEsq := 150
nLInic  += RetTamTex(oDacte,"X",oFont08:oFont) + nSoma
nLFim   := (nLInic + RetTamTex(oDacte,"X",oFont08:oFont) + nSoma)

oDacte:Box((nLInic - 9), 1700, (nLFim + nDifEsq), 2368)

nSoma	:= 3
nLInic	+= RetTamTex(oDacte,"X",oFont08:oFont) + nSoma
nCInic	:= 35

For nCount := 1 To 6
	lControl := !lControl

	If (lControl == .T.)
		cLabel := "Nome"
	Else
		cLabel := "Valor"
	EndIf

	If (nCount > 1)
		oDacte:Line((nLInic - 23), (nCInic - 5), (nLFim + nDifEsq), (nCInic - 5)) // Separador Coluna
	EndIf

	oDacte:Say(nLInic , nCInic, cLabel, oFont08N:oFont)
	nCInic += 278
Next nCount
 
oDacte:Say(nLInic , 1710, "Valor Total do Serviço", oFont08N:oFont)	//"Valor Total do Serviço"

//-- Componentes do Valor da Prestacao de Servico
nSoma    := 15
nDifEsq  := 50
nLInic   += RetTamTex(oDacte,"X",oFont08:oFont) + nSoma
nCount   := 0
nCount_2 := 0
lControl := .F.

nCInic	:= 35
aComp	:= getDacteComp( oCte )
	
For nCount_3 := 1 To Len( aComp )
	nCount += 2
	oDacte:Say(nLInic, nCInic, AllTrim(aComp[nCount_3][1]), oFont08:oFont) //COMP:_XNOME
	
	nCInic += 278
 		oDacte:Say(nLInic, nCInic, AllTrim(aComp[nCount_3][2]), oFont08:oFont)//COMP:_VCOMP
	
	nCInic += 278
	
	//-- Forcar a "Quebra" da linha, sendo 6 campos por linha
	If ( (mod(nCount,6)) == 0 )
		nCount_2 += 1
		
		Do Case
			Case ( nCount_2 == 1 )
				cLabel := PadL(Transform(Val(oCte:_CTEOS:_INFCTE:_VPREST:_VTPREST:TEXT),'@E 999,999,999.99'),20)						   

			Case ( nCount_2 == 2 )
				cLabel := ""

			Case ( nCount_2 == 3 )
				//-- Separador Linha
				oDacte:Line((nLInic - 30), 1700, (nLInic - 30), 2368)
				cLabel := "Valor a Receber"	//"Valor a Receber"

			Case ( nCount_2 == 4 )
				cLabel := PadL(Transform(Val(oCte:_CTEOS:_INFCTE:_VPREST:_VTPREST:TEXT),'@E 999,999,999.99'),20)
		EndCase
		
		oDacte:Say((nLInic + 5) , 1710, cLabel, oFont10N:oFont)
		
		nSoma    := 18
		nLInic   += RetTamTex(oDacte,"X",oFont08:oFont) + nSoma
		nCInic   := 35
	EndIf
Next nCount_3	

For nCount := (1 + nCount) To 24
	lControl := !lControl
	nCInic   += 278
	cLabel   := ""
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ FORCAR A "QUEBRA" DA LINHA, SENDO 6 CAMPOS POR LINHA.                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ( (mod(nCount,6)) == 0 )
		nCount_2 += 1
		
		Do Case
			Case ( nCount_2 == 1 )
			    If oCte:_CTEOS:_INFCTE:_IDE:_TPCTE:TEXT == "1" .And. lZraCTEO
					cLabel := PadL(Transform(Val('0,00'),'@E 999,999,999.99'),20)
				Else
					cLabel := PadL(Transform(Val(oCte:_CTEOS:_INFCTE:_VPREST:_VTPREST:TEXT),'@E 999,999,999.99'),20)
				Endif						   

			Case ( nCount_2 == 2 )
				cLabel := ""

			Case ( nCount_2 == 3 )
				//-- Separador Linha
				oDacte:Line((nLInic - 30), 1700, (nLInic - 30), 2368)
				cLabel := "Valor a Receber"	//"Valor a Receber"

			Case ( nCount_2 == 4 )
			    If oCte:_CTEOS:_INFCTE:_IDE:_TPCTE:TEXT == "1" .And. lZraCTEO
					cLabel := PadL(Transform(Val('0,00'),'@E 999,999,999.99'),20)
				Else
					cLabel := PadL(Transform(Val(oCte:_CTEOS:_INFCTE:_VPREST:_VREC:TEXT),'@E 999,999,999.99'),20)
				Endif
		EndCase
		
		oDacte:Say(nLInic, 1710, cLabel, oFont10N:oFont)
		
		nSoma    := 18
		nLInic   += RetTamTex(oDacte,"X",oFont08:oFont) + nSoma
		nCInic   := 35
	EndIf
Next nCount

//-- BOX: Informacoes Relativas ao Imposto
nSoma   := 10
nDifEsq := 70
nLInic  += RetTamTex(oDacte,"X",oFont08:oFont) - 15
nLFim   := (nLInic + RetTamTex(oDacte,"X",oFont08:oFont) + nSoma)

oDacte:Box(nLInic , 0030, (nLFim + nDifEsq), 2368)

nSoma   := 10
nLInic  += RetTamTex(oDacte,"X",oFont08:oFont) + nSoma
oDacte:Say(nLInic , 0900, "Informações Relativas ao Imposto", oFont08N:oFont)	//"Informações Relativas ao Imposto"
oDacte:Line((nLInic + 10), 0030, (nLInic + 10), 2368)

nSoma   := 23
nLInic  += RetTamTex(oDacte,"X",oFont08:oFont) + nSoma
nLFim   := (nLInic + RetTamTex(oDacte,"X",oFont08:oFont) + nSoma)

oDacte:Line((nLInic - 22), 0990, (nLFim + 1), 0990) // Separador Base de Calculo
oDacte:Line((nLInic - 22), 1310, (nLFim + 1), 1310) // Separador Aliq.ICMS
oDacte:Line((nLInic - 22), 1490, (nLFim + 1), 1490) // Separador Valor ICMS
oDacte:Line((nLInic - 22), 1810, (nLFim + 1), 1810) // Separador %Red Bc.Calc

oDacte:Say(nLInic , 0035, "Situação Tributária", oFont08N:oFont)	//"Situação Tributária"
oDacte:Say(nLInic , 1000, "Base de Cálculo", oFont08N:oFont)	//"Base de Cálculo"
oDacte:Say(nLInic , 1320, "Aliq.ICMS", oFont08N:oFont)	//"Aliq.ICMS"
oDacte:Say(nLInic , 1500, "Valor ICMS", oFont08N:oFont)	//"Valor ICMS"
oDacte:Say(nLInic , 1820, "%Red.Bc.Calc.", oFont08N:oFont)	//"%Red.Bc.Calc."


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tag <ICMS00>    													³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If !Type("oCte:_CTEOS:_INFCTE:_IMP:_ICMS:_ICMS00:_CST:TEXT")=="U"
	
	cSitTrib	:= Iif( Type("oCte:_CTEOS:_INFCTE:_IMP:_ICMS:_ICMS00:_CST:TEXT")=="U"," ",oCte:_CTEOS:_INFCTE:_IMP:_ICMS:_ICMS00:_CST:TEXT )

	cBaseIcms	:= Val(oCte:_CTEOS:_INFCTE:_IMP:_ICMS:_ICMS00:_VBC:TEXT)
	cAliqIcms	:= Val(oCte:_CTEOS:_INFCTE:_IMP:_ICMS:_ICMS00:_PICMS:TEXT)
	cValIcms	:= Val(oCte:_CTEOS:_INFCTE:_IMP:_ICMS:_ICMS00:_VICMS:TEXT)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tag <ICMS45>    													³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ElseIf !Type("oCte:_CTEOS:_INFCTE:_IMP:_ICMS:_ICMS45:_CST:TEXT") == "U"

	cSitTrib	:= Iif( Type("oCte:_CTEOS:_INFCTE:_IMP:_ICMS:_ICMS45:_CST:TEXT")=="U"," ",oCte:_CTEOS:_INFCTE:_IMP:_ICMS:_ICMS45:_CST:TEXT )
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tag <ICMS90>    													³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ElseIf !Type("oCte:_CTEOS:_INFCTE:_IMP:_ICMS:_ICMS90:_CST:TEXT") == "U"

	cSitTrib	:= Iif( Type("oCte:_CTEOS:_INFCTE:_IMP:_ICMS:_ICMS90:_CST:TEXT")=="U"," ",oCte:_CTEOS:_INFCTE:_IMP:_ICMS:_ICMS90:_CST:TEXT )

	cBaseIcms	:= Val(oCte:_CTEOS:_INFCTE:_IMP:_ICMS:_ICMS90:_VBC:TEXT)
   	cAliqIcms	:= Val(oCte:_CTEOS:_INFCTE:_IMP:_ICMS:_ICMS90:_PICMS:TEXT)
	cValIcms	:= Val(oCte:_CTEOS:_INFCTE:_IMP:_ICMS:_ICMS90:_VICMS:TEXT)
	cRedBcCalc := Val(Iif( Type("oCte:_CTEOS:_INFCTE:_IMP:_ICMS:_ICMS90:_pRedBC:TEXT")=="U"," ",(oCte:_CTEOS:_INFCTE:_IMP:_ICMS:_ICMS90:_pRedBC:TEXT) ))
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tag <ICMSOutraUF>    													³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
ElseIf !Type("oCte:_CTEOS:_INFCTE:_IMP:_ICMS:_ICMSOutraUF:_CST:TEXT") == "U"

	cSitTrib	:= Iif( Type("oCte:_CTEOS:_INFCTE:_IMP:_ICMS:_ICMSOutraUF:_CST:TEXT")=="U"," ",oCte:_CTEOS:_INFCTE:_IMP:_ICMS:_ICMSOutraUF:_CST:TEXT )

	cBaseIcms	:= Val(oCte:_CTEOS:_INFCTE:_IMP:_ICMS:_ICMSOutraUF:_vBCOutraUF:TEXT)
	cAliqIcms	:= Val(oCte:_CTEOS:_INFCTE:_IMP:_ICMS:_ICMSOutraUF:_pICMSOutraUF:TEXT)
	cValIcms	:= Val(oCte:_CTEOS:_INFCTE:_IMP:_ICMS:_ICMSOutraUF:_vICMSOutraUF:TEXT)
	cRedBcCalc := Val(Iif( Type("oCte:_CTEOS:_INFCTE:_IMP:_ICMS:_ICMSOutraUF:_pRedBCOutraUF:TEXT")=="U"," ",(oCte:_CTEOS:_INFCTE:_IMP:_ICMS:_ICMSOutraUF:_pRedBCOutraUF:TEXT) ))

EndIf	

nSoma  := 12
nLInic += RetTamTex(oDacte,"X",oFont08:oFont) + nSoma

//-- Pesquisa Situacao Tributaria
nPos := aScan(aSitTrib,{|x| x[1] == Alltrim(cSitTrib)})
If nPos > 0
	cSitTrib += " - "+aSitTrib[nPos][2]
Endif

oDacte:Say(nLInic+2 , 0035, cSitTrib                           	, oFont08:oFont)
oDacte:Say(nLInic , 1000, Transform(cBaseIcms ,'@E 999,999,999.99')	, oFont08:oFont)
oDacte:Say(nLInic , 1320, Transform(cAliqIcms ,'@E 999,999,999.99')	, oFont08:oFont)
oDacte:Say(nLInic , 1500, Transform(cValIcms  ,'@E 999,999,999.99')	, oFont08:oFont)
oDacte:Say(nLInic , 1820, Transform(cRedBcCalc,'@E 999,999,999.99')	, oFont08:oFont)

Return

//-----------------------------------------------------------------------
/*/{Protheus.doc} getDacteComp
Retorna um Array com a estrutura do campo "Comp" relacionado
ao Objeto passado por parâmetro

@param		obj		Objeto	

@return	aResult Array com estrutura

@author Natalia Sartori
@since 06.02.2017
@version 1.0 
/*/
//-----------------------------------------------------------------------
Static Function getDacteComp( obj )

Local i			:= 0		// Auxiliar no Incremento da Estrutura de Laco
Local aAuxClone	:= { }		// Copia da propriedade Comp do Objeto passado por parametro
Local aAuxComp	:= { }		// Auxiliar no processamento de aAuxClone
Local aResult	:= { }		// Retorno da Funcao    

private oObject := obj

If	Type( "oObject:_CTEOS:_INFCTE:_VPREST:_COMP" ) == "A"
	aAuxClone := ACLONE( oObject:_CTEOS:_INFCTE:_VPREST:_COMP )
	For i := 1 To Len( aAuxClone )
		AADD( aResult, {AllTrim(aAuxClone[ i ]:_XNOME:TEXT), AllTrim(aAuxClone[ i ]:_VCOMP:TEXT)} )
	Next i
ElseIf	Type( "oObject:_CTEOS:_INFCTE:_VPREST:_COMP" ) == "O"
	AADD( aAuxComp, AllTrim(oObject:_CTEOS:_INFCTE:_VPREST:_COMP:_XNOME:TEXT) )
	AADD( aAuxComp, AllTrim(oObject:_CTEOS:_INFCTE:_VPREST:_COMP:_VCOMP:TEXT) )
	AADD( aResult, aAuxComp )
	aAuxComp := {}
EndIf

Return ( aResult )

//-----------------------------------------------------------------------
/*/{Protheus.doc} NoAcentoCte
Funcao responsavel por retirar caracteres especiais das strings

@param		obj		Objeto	

@return	aResult Array com estrutura

@author Natalia Sartori
@since 06.02.2017
@version 1.0 
/*/
//-----------------------------------------------------------------------
Static Function NoAcentoCte(cMens)

Local cByte,ni
Local s1:= "áéíóú" + "ÁÉÍÓÚ" + "âêîôû" + "ÂÊÎÔÛ" + "äëïöü" + "ÄËÏÖÜ" + "àèìòù" + "ÀÈÌÒÙ"  + "ãõÃÕ" + "çÇ"
Local s2:= "aeiou" + "AEIOU" + "aeiou" + "AEIOU" + "aeiou" + "AEIOU" + "aeiou" + "AEIOU"  + "aoAO" + "cC"
Local nPos:=0, nByte
Local cRet:=''

For ni := 1 To Len(cMens)
	cByte := Substr(cmens,ni,1)
	nByte := ASC(cByte)
	If nByte > 122 .Or. nByte < 48 .Or. ( nByte > 57 .And. nByte < 65 ) .Or. ( nByte > 90 .And. nByte < 97 )
		nPos := At(cByte,s1)
		If nPos > 0
			cByte := Substr(s2,nPos,1)
		Else
			cByte := " "
		EndIf
	EndIf
	cRet+=cByte
Next

Return(AllTrim(cRet))

//-----------------------------------------------------------------------
/*/{Protheus.doc} RetTamTex
Retorna o tamanho em pixels de uma string. (Workaround para o GetTextWidth)

@author Marcos Taranta
@since 24/05/2011
@version 1.0 

@param  cTexto   Texto a ser medido.
        oFont    Objeto instanciado da fonte a ser utilizada.
        oPrinter Objeto de impressão instanciado.

@return nTamanho Tamanho em pixels da string.
/*/
//-----------------------------------------------------------------------
Static Function RetTamTex(oPrinter,cTexto,oFont)
	
	Local nTamanho := 0
	
//	nTamanho := oPrinter:GetTextWidth(cTexto, oFont)
	
	nTamanho := 21
	
	If !oFont:Bold
		nTamanho *= nConsTex
	Else
		nTamanho *= nConsNeg
	EndIf
	
	nTamanho := Round(nTamanho, 0)
	
Return nTamanho

//-----------------------------------------------------------------------------
/*/{Protheus.doc} EspacoAt
Pega uma posição na string e retorna o caractere de espaço anterior.

@param		cString	String a ser verificada
			nTam			
			
@return	nRetorno

@author  Natalia Sartori
@since   30/06/2016
@version 11.6
/*/
//-----------------------------------------------------------------------------
Static Function EspacoAt(cString, nTam)

Local nRetorno := 0
Local nX       := 0

Default cString := ""
Default nTam	:= 0

/**
* Caso a posição (nTam) for maior que o tamanho da string, ou for um valor
* inválido, retorna 0.
*/
If nTam > Len(cString) .Or. nTam < 1
	nRetorno := 0
	Return nRetorno
EndIf

/**
* Procura pelo caractere de espaço anterior a posição e retorna a posição
* dele.
*/
nX := nTam
While nX > 1
	If Substr(cString, nX, 1) == " "
		nRetorno := nX
		Return nRetorno
	EndIf
	
	nX--
EndDo

/**
* Caso não encontre nenhum caractere de espaço, é retornado 0.
*/
nRetorno := 0

Return nRetorno

//-----------------------------------------------------------------------------
/*/{Protheus.doc} GetModal
Retorna o Texto do Modal
@param		cString	String a ser verificada				
@return	nRetorno
@author  GTP
@since   06/02/2020
/*/
//-----------------------------------------------------------------------------
Static Function GetModal(cModal)
Local cRet := ''

		Do Case
			Case ( cModal == '01' )
				cRet := 'Rodoviario'
			Case ( cModal == '02' )
				cRet := 'Aereo'
			Case ( cModal == '03' )
				cRet := 'Aquaviario'
			Case ( cModal == '04' )
				cRet := 'Ferroviario'
			Case ( cModal == '05' )
				cRet := 'Dutoviario'
			Case ( cModal == '06' )
				cRet := 'Multimodal'		
		EndCase
 
Return cRet

//-----------------------------------------------------------------------------
/*/{Protheus.doc} WordWrap
Efetua a impressão da quebra de texto do conteúdo de observações do DACTEOS
@param	cText, caractere, Texto que será quebrado em linhas, caso necessário
		nLInic, numérico, linha inicial do textado quebrado que será impresso
		oDacte, objeto, Instância da classe FWMSPrinter()
		oFont, objeto, Instância da classe TFontEx()
@return	nRetorno
@author  Fernando Radu Muscalu
@since   06/09/2022
/*/
//-----------------------------------------------------------------------------
Static Function WordWrap(cText,nLInic,oDacte,oFont)
	
	Local cSubText	:= ""

	Local nLinAux	:= 0
	Local nLineBreak:= 0
	Local nLoop		:= 0
	Local nLoop1	:= 0
	Local nSoma		:= 0
	Local nLimitBox	:= 0

	Local aWords	:= {}
	Local aLines	:= {}	
	Local aAux		:= {}

	aLines := Separa(cText,chr(13))	
	
	For nLoop := 1 to Len(aLines)
		
		aAux := Separa(aLines[nLoop],chr(32))	

		aEval(aAux,{|x| IIf(!Empty(x),aAdd(aWords,x),nil)})

		aLines[nLoop] := aClone(aWords)
		
		aWords := {}

	Next nLoop

	nLinAux 	:= nLInic 
	nLineBreak 	:= 260
	nSoma 		:= 13
	nLimitBox	:= 3350

	For nLoop1 := 1 to Len(aLines)

		aWords := aClone(aLines[nLoop1])

		For nLoop := 1 to Len(aWords)
			
			If ( Len(cSubText + aWords[nLoop]) <= nLineBreak .And. !Empty(aWords[nLoop]) )	
				
				cSubText += aWords[nLoop] + space(1)				

			Else
				
				If ( !Empty(cSubText) )
				
					oDacte:Say(nLinAux, 0045, cSubText, oFont:oFont, nLimitBox)

					cSubText	:= aWords[nLoop] + space(1)
					nLinAux  	+= RetTamTex(oDacte,"X",oFont:oFont) + nSoma
				
				EndIf

			EndIf

		Next nLoop

		If ( !Empty(cSubText) )

			oDacte:Say (nLinAux, 0045, cSubText, oFont:oFont, nLimitBox)
			
			cSubText	:= ""
			nLinAux  	+= RetTamTex(oDacte,"X",oFont:oFont) + nSoma

		EndIf

	Next nLoop1

Return()
