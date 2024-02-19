#include 'totvs.ch'
#include 'protheus.ch'
#include 'parmtype.ch'

//-----------------------------------------------------------
/*/{Protheus.doc} XmlCTeOSV4()


@param cSerie    	Serie da nota
@param cNota    	Numero da nota
@param cCliente    	Cliente da nota
@param cLoja	    Loja da nota
@param cModal		Modal de transporte, preencher com:
					01-Rodoviário
					02-Aéreo
					03-Aquaviário
					04-Ferroviário
					05-Dutoviário
					06-Multimodal

@return	XmlCTeOSV4      XML do CTeOS

@author	Fernando Amorim(Cafu)
@since		20/09/2017
@version 	12.1.17
/*/
//----------------------------------------------------------
user function CTeOS_V4(cTipo, cSerie, cNota,cCliFor, cLoja, cAmbiente, cVersao, cModalidade, cTimeZone, cModal, cEvento)
	
	Local cChave     := ''
	Local CTeOSXML   := ''
	Local cDoc_Chv	 := ''
	Local cChvAnu	 := ''
	Local cChvAux	 := ''
	Local cVerAmb	 := ''
	Local cTpServ	 := '6' // 6 - Transporte de Pessoas;7 - Transporte de Valores;8 - Excesso de Bagagem  ...vem de parametro da nova tabela GTP
	Local cdtEmisA	 := ''
	Local cNotaA	 := ''
	Local cSerieA	 := ''
	Local cChvOri	 := ''	

	Default cEvento	 := ''

	If GZH->(FieldPos('GZH_CODGQ2')) > 0
		If fwisincallstack("VLDGQ2") .OR. !Empty(GZH->GZH_CODGQ2)
			cTpServ := '8'
		Endif
	Endif

	iF cTipo <>'3'
		cTipo       := PARAMIXB[1]
		cSerie      := alltrim(PARAMIXB[2])
		cNota       := alltrim(PARAMIXB[3])
		cCliFor     := PARAMIXB[4]
		cLoja       := PARAMIXB[5]
		cAmbiente   := PARAMIXB[6]
		cVersao     := PARAMIXB[7]
		cModalidade := PARAMIXB[8]
		cTipoEmissao:= cModalidade
		cTimeZone	:= PARAMIXB[9]
		cVerAmb		:= cVersao
		cModal		:= iif( type("PARAMIXB[10]") <> "U", PARAMIXB[10], "01" )
		cEvento 	:= PARAMIXB[11]
	Endif
	If Empty(cTimeZone)
		cTimeZone :='-02:00'
	Endif

	If cEvento=='A'
		BuscaNFs(@cNota, @cSerie, @cChvAux, @cChvAnu, @cdtEmisA,cTimeZone, @cNotaA, @cSerieA) //BUSCA A ORIGINAL DE SAIDA
	EndIf

	SF2->(DbSetOrder(1))
	SF2->(DbSeek(xFilial('SF2')+PadR(cNota,TamSx3('F2_DOC')[1])+PadR(cSerie,TamSx3('F2_SERIE')[1])+cCliFor+PadR(cLoja,TamSx3('F2_LOJA')[1])))
	GZH->(DbSetOrder(1))
	GZH->(DbSeek(xFilial('GZH')+PadR(cNota,TamSx3('F2_DOC')[1])+PadR(cSerie,TamSx3('F2_SERIE')[1])+cCliFor+cLoja))


	cChave += getUFCode(SM0->M0_ESTENT)
	cChave += substr(DTOS(SF2->F2_EMISSAO),3,2)
	cChave += substr(DTOS(SF2->F2_EMISSAO),5,2)
	cChave += SM0->M0_CGC
	cChave += '67'
	cChave += strZero(val(cSerie),3)
	cChave += strZero(val(cNota),9)
	cChave += '1'
	cChave += strZero(val(cNota),8)

	cDoc_Chv	:= cChave + Modulo11(cChave)

	If cEvento=='A'
		cDoc_Chv := cChvAux
	EndIf

	CTeOSXML := ''
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Header do Arquivo XML                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	CTeOSXML += '<infNFe versao="T02.00" modelo="67">'
	CTeOSXML += '<CTeOS xmlns="http://www.portalfiscal.inf.br/cte" versao="4.00">'
	CTeOSXML += '<infCte Id="CTe' + AllTrim(cDoc_Chv) + '" versao="' + cVerAmb + '">'

	If cEvento=='A'
		CTeOSXML += XmlCTeIde(cSerieA,cNotaA,SF2->F2_CLIENTE,SF2->F2_LOJA,cDoc_Chv,cAmbiente, cModalidade, cTimeZone,cModal, cTpServ, cEvento, cdtEmisA)
	Else
		CTeOSXML += XmlCTeIde(SF2->F2_SERIE,SF2->F2_DOC,SF2->F2_CLIENTE,SF2->F2_LOJA,cDoc_Chv,cAmbiente, cModalidade, cTimeZone,cModal, cTpServ, cEvento)
	EndIf
	CTeOSXML += XmlCTeComp(SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA)

	CTeOSXML += XmlCTeEmit()

	If cTpServ != "8"
		CTeOSXML += XmlCTeToma(SF2->F2_CLIENTE,SF2->F2_LOJA,cAmbiente)
	Endif

	CTeOSXML += XmlCTeVPrest(SF2->F2_SERIE,SF2->F2_DOC,SF2->F2_CLIENTE,SF2->F2_LOJA)
	CTeOSXML += XmlCTeIMP(SF2->F2_SERIE,SF2->F2_DOC,SF2->F2_CLIENTE,SF2->F2_LOJA,cEvento)

	If !(cEvento $ 'A|C')
		CTeOSXML += XmlCTeINF(SF2->F2_SERIE,SF2->F2_DOC,SF2->F2_CLIENTE,SF2->F2_LOJA,cModal, cTpServ, GZH->GZH_TPFRET, dtos(GZH->GZH_DSAIDA), GZH->GZH_HSAIDA, cEvento)
		//CTeOSXML += XmlINfRespTec(SF2->F2_SERIE,SF2->F2_DOC,SF2->F2_CLIENTE,SF2->F2_LOJA,cModal)
	EndIf

	If cEvento == 'A'
		CTeOSXML += XmlCTeAnu(cChvAnu)
	EndIf

	If cEvento == 'C'
		cChvOri := RetChvOri(cCliFor, cLoja, cNota, cSerie)
		CTeOSXML += XmlCTeCPL(cChvOri)
	EndIf

	CTeOSXML += '</infCte>'

	CTeOSXML += XmlCTeQrC(cModalidade,cDoc_Chv,cAmbiente)

	CTeOSXML += '</CTeOS>'
	CTeOSXML += '</infNFe>'

	CTeOSXML := STRTRAN(CTeOSXML,chr(13) + chr(10),'')

return {encodeUTF8(CTeOSXML),cDoc_Chv}

//-----------------------------------------------------------------------------------------------------
/*/{Protheus.doc} XmlCTeIde()

Monta Grupo da Identificação do CTeOS


@param cSerie    	Serie da nota
@param cNota    	Numero da nota
@param cCliente    	Cliente da nota
@param cLoja	    Loja da nota
@Param cDoc_chv		chave da nota XML

@return cString   XML com a Identificaçao da CTeOS

@author 	Fernando Amorim(Cafu) 
@since		20/09/2017
@version 12.1.17

/*/
//------------------------------------------------------------------------------------------------------
static function XmlCTeIde(cSerie,cNota,cCliente,cLoja,cDoc_Chv,cAmbiente, cModalidade, cTimeZone,cModal, cTpServ, cEvento, cdtEmisA)

	Local cString    := ""
	Local cDhEmis	 := ""
	Local cCFOP		 := ''
	Local cNatOper	 := ''
	Local cMod		 := '67'
	Local cTpImp	 := '1'  // Preencher com: 1 - Retrato; 2 - Paisagem.  depois será parametro do TSS
	Local cTpEmis	 := cModalidade   // 1 - Normal; 5 - Contingência FSDA; 7 - Autorização pela SVC-RS; 8 - Autorização pela SVC-SP  depois será parametro do TSS
	Local cDV		 := SubStr( AllTrim(cDoc_Chv), len( AllTrim(cDoc_Chv) ), 1)
	Local cTpAmb	 := cAmbiente // 1 - Produção; 2 - Homologação  depois será parametro do TSS
	Local cTpCte	 := '0' // 0 - CT-e Normal; 1 - CT-e Complementar; 2 - Anulação; 3 - Substituição  depois será parametro do TSS
	Local cToma      := ' ' // 1 – Contribuinte ICMS; toma3 ou toma4 2 – Contribuinte isento de inscrição; 9 – Não Contribuinte
	Local aUFPer	 := {}
	Local nX		 := 0
	Local lRet		 := .T.
	Local cUFtexto	 := alltrim(GZH->GZH_UFPER)

	Default cModal	 := '01' // 01-Rodoviário
	Default cEvento  := ''
	Default cdtEmisA :=''

	If cEvento == 'A'
		cTpCte := '2'
	ElseIf cEvento == 'S'
		cTpCte := '3'
	ElseIf cEvento == 'C'
		cTpCte := '1'
	EndIf

	SA1->(DbSetOrder(1))
	SA1->(DbSeek(xFilial('SA1')+cCliente+cLoja))
	If SA1->A1_CONTRIB == '1'  .And. (Empty(SA1->A1_INSCR) .Or. "ISENT" $ Upper(AllTrim(SA1->A1_INSCR)))
		cToma	:= '2'
	ElseIf SA1->A1_CONTRIB == '1'
		cToma	:= '1'
	Else
		cToma	:= '9'
	Endif
	// pega as UF do percurso
	While lRet

		If at(';',cUFtexto) > 0
			aAdd(aUFPer,substr(ALLTRIM(cUFtexto),at(';',cUFtexto)-2,at(';',cUFtexto)-1))

			cUFtexto := substr(cUFtexto,at(';',cUFtexto)+1)
		else
			If !Empty(cUFtexto)
				aAdd(aUFPer,cUFtexto)
			Endif
			lRet := .F.
		Endif

	End

	SF3->(DbSetOrder(4))
	If SF3->(DbSeek(xFilial("SF3")+cCliente+cLoja+PadR(cNota,TamSx3('F2_DOC')[1])+PadR(cSerie,TamSx3('F2_SERIE')[1]) ))
		cCFOP := SF3->F3_CFO
	EndIf

	If cEvento == 'A'
		cCFOP := '2206'
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ CFOP - Natureza da Prestacao                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(cCFOP) .AND. !Empty(FWGetSX5('13',PadR(cCFOP, TamSX3("X5_CHAVE")[1])))
		cNatOper := NoAcentoCte( SubStr(AllTrim(FWGetSX5('13',PadR(cCFOP, TamSX3("X5_CHAVE")[1]))[1][4]),1,55) )
	Else
		cNatOper := 'Prestação de serviços de transporte'
	EndIf

	If cEvento == 'A'
		cDhEmis := cdtEmisA
	Else
		cDhEmis := SubStr(DToS(SF2->F2_EMISSAO), 1, 4) + "-";
			+ SubStr(DToS(SF2->F2_EMISSAO), 5, 2) + "-";
			+ SubStr(DToS(SF2->F2_EMISSAO), 7, 2) + "T";
			+ SubStr(AllTrim(Time()), 1, 2) + ":";
			+ SubStr(AllTrim(Time()), 4, 2) + ':00';
			+ cTimeZone
	EndIf
	cString := '<ide>'
	cString += '<cUF>' + getUFCode(SM0->M0_ESTENT) + '</cUF>'					//6
	cString += '<cCT>' + convType(strZero(Val(cNota),8,0),8,0) + '</cCT>'		//7
	cString += '<CFOP>' + Alltrim(str(Val(cCFOP))) + '</CFOP>'										//8
	cString += '<natOp>' + cNatOper + '</natOp>'								//9
	cString += '<mod>' + cMod + '</mod>'										//10
	cString += '<serie>' + Alltrim(str(Val(cSerie))) + '</serie>'									//11
	cString += '<nCT>' + Alltrim(str(Val(cNota))) + '</nCT>'							//12
	cString += '<dhEmi>' + cDhEmis + '</dhEmi>'									//13
	cString += '<tpImp>' + cTpImp + '</tpImp>'									//14
	cString += '<tpEmis>' + cTpEmis + '</tpEmis>'								//15
	cString += '<cDV>' + cDv + '</cDV>'										    //16
	cString += '<tpAmb>' + cTpAmb + '</tpAmb>'									//17
	cString += '<tpCTe>' + cTpCTe + '</tpCTe>'									//18
	cString += '<procEmi>0</procEmi>'									//19 emissão com aplicação do contribuinte
	cString += '<verProc>2.00</verProc>'								//20
	cString += '<cMunEnv>' + Alltrim(str(Val(SM0->M0_CODMUN))) + '</cMunEnv>'						//21
	cString += '<xMunEnv>' + RemoveAcento(Alltrim(SM0->M0_CIDENT)) + '</xMunEnv>'						//22
	cString += '<UFEnv>' + SM0->M0_ESTENT + '</UFEnv>'							//23
	cString += '<modal>' + cModal + '</modal>'									//24
	cString += '<tpServ>' + cTpServ + '</tpServ>'								//25
	cString += '<indIEToma>' + cToma + '</indIEToma>'							//26
	cString += '<cMunIni>' + Alltrim(str(Val(getUFCode(GZH->GZH_UMUINI) + GZH->GZH_CMUINI))) + '</cMunIni>'						//27
	cString += '<xMunIni>' + RemoveAcento(Alltrim(GZH->GZH_DMUINI)) + '</xMunIni>'						//28
	cString += '<UFIni>' + GZH->GZH_UMUINI + '</UFIni>'							//29
	cString += '<cMunFim>' + Alltrim(str(Val(getUFCode(GZH->GZH_UMUFIM) + GZH->GZH_CMUFIM))) + '</cMunFim>'						//30
	cString += '<xMunFim>' + RemoveAcento(Alltrim(GZH->GZH_DMUFIM)) + '</xMunFim>'						//31
	cString += '<UFFim>' + GZH->GZH_UMUFIM + '</UFFim>'							//32
	For nX:= 1 to len(aUFPer)
		cString += '<infPercurso>'
		cString += '<UFPer>' + aUFPer[nX]  + '</UFPer>'
		cString += '</infPercurso>'
	Next nX
	cString += '</ide>'

return(cString)



//-----------------------------------------------------------------------------------------------------
/*/{Protheus.doc} XmlCTeComp()

Monta Grupo complementar do CTeOS


@return cString   XML com a Identificaçao da CTeOS

@author 	Fernando Amorim(Cafu) 
@since		20/09/2017
@version 12.1.17

/*/
//------------------------------------------------------------------------------------------------------
static function XmlCTeComp(cNota,cSerie,cCliente,cloja )

	Local cString    := ""
	Local cRetLTr	 := GerLeiTr(cNota,cSerie,cCliente,cloja) // Lei da transparencia
	Local cTxtObs := ''

	cString := '<compl>'
	cString += '<xObs>' + RemoveAcento(alltrim(cRetLTr)) + RemoveAcento(alltrim(GZH->GZH_OBSNF)) +  '</xObs>'   // 41

	If SF2->F2_TOTIMP > 0
		//cTxtObs := "Retenção de 11.00% s/ 30% do valor bruto da NF : R$ " + PADL(Transform((SF2->F2_TOTIMP * 1.3),'@E 999,999.99'),20) + " conforme IN RFB971/09 art 122 II" + CRLF
		cTxtObs += 'O valor aproximado de tributos incidentes sobre o preco deste servico e de R$ ' + PADL(Transform(SF2->F2_TOTIMP,'@E 999,999.99'),20)
		cString +=  '<ObsCont xCampo="LeidaTransparencia">'
		cString +=    '<xTexto>'+cTxtObs+'</xTexto>'
		cString +=  '</ObsCont>'
	EndIf

	cString += '</compl>'

return(cString)

//-----------------------------------------------------------------------------------------------------
/*/{Protheus.doc} XmlCTeEmit()

Monta Grupo da Emitente do CTeOS


@return cString     XML com o Emitente da NFe

@author 	Fernando Amorim (Cafu)
@since		20/09/2017
@version 12.1.17

/*/
//-----------------------------------------------------------------------------------------------------
static function XmlCTeEmit()

	Local cString  	:= ""
	Local cInscEst	:= ""
	Local cMVCODREG	:= AllTrim(SuperGetMV("MV_CODREG", ," "))

	If (AllTrim(SM0->M0_INSC) == 'ISENTO' .Or. Empty(SM0->M0_INSC) )
		cInscEst	:= '00000000000'
	Else
		cInscEst 	:= NoPontos(SM0->M0_INSC)
	EndIf

	cString := '<emit>'

	cString += '<CNPJ>' + NoPontos(SM0->M0_CGC) + '</CNPJ>'      			// 49
	cString += '<IE>' + cInscEst + '</IE>'									// 50
	cString += '<xNome>' + RemoveAcento(Alltrim(SM0->M0_NOME)) + '</xNome>'			// 52
	cString += '<xFant>' + RemoveAcento(Alltrim(SM0->M0_NOMECOM)) + '</xFant>'     	// 53

	cString += '<enderEmit>'

	cString += '<xLgr>' +  RemoveAcento(alltrim(FisGetEnd(SM0->M0_ENDENT)[1]))+ '</xLgr>'			// 55
	cString += '<nro>' + Iif(FisGetEnd(SM0->M0_ENDENT)[2]<>0, AllTrim(cValtoChar( FisGetEnd(SM0->M0_ENDENT)[2])),"S/N") + '</nro>'		// 56
	If !Empty(RemoveAcento(FisGetEnd(SM0->M0_ENDENT)[4]))
		cString += '<xCpl>' + RemoveAcento(Alltrim(FisGetEnd(SM0->M0_ENDENT)[4])) + '</xCpl>'			// 57
	EndIf
	cString += '<xBairro>' + RemoveAcento(Alltrim( SM0->M0_BAIRENT )) + '</xBairro>'						// 58
	cString += '<cMun>' + Alltrim(str(Val(SM0->M0_CODMUN))) + '</cMun>'											// 59
	cString += '<xMun>' +  RemoveAcento(Alltrim(SM0->M0_CIDENT )) + '</xMun>'							// 60
	cString += '<CEP>' + SM0->M0_CEPENT + '</CEP>'												// 61
	cString += '<UF>' + SM0->M0_ESTENT + '</UF>'												// 62
	If !Empty (NoPontos(SM0->M0_TEL))
		cString += '<fone>' + cValtoChar(NoPontos(SM0->M0_TEL)) + '</fone>'						// 63
	EndIf

	cString += '</enderEmit>'

	cString += '<CRT>'+ cMVCODREG + '</CRT>'	//65

	cString += '</emit>'

return cString

//-----------------------------------------------------------------------------------------------------
/*/{Protheus.doc} XmlCTeToma()

Monta Grupo do tomador  do CTeOS

@return cString         XML com o tomador

@author 	Fernando Amorim (Cafu)
@since		20/09/2017
@version 12.1.17

/*/
//-----------------------------------------------------------------------------------------------------
static function XmlCTeToma(cCliente,cLoja,cAmbiente)

	local cString := ""
	Local cTelAux := ''


	SA1->(DbSetOrder(1))
	SA1->(DbSeek(xFilial('SA1')+cCliente+cLoja))

	cString += '<toma>'

	If SA1->A1_EST=='EX'
		cString += '<CNPJ>00000000000000</CNPJ>'
	ELse
		If SA1->A1_PESSOA == 'J'
			cString += '<CNPJ>' + NoPontos(Alltrim(SA1->A1_CGC)) + '</CNPJ>'													// 65
		Else
			cString += '<CPF>' + NoPontos(Alltrim(SA1->A1_CGC)) + '</CPF>'															// 66
		Endif
	Endif

	If Empty(SA1->A1_INSCR) .Or. "ISENT" $ Upper(AllTrim(SA1->A1_INSCR))
		cString += '<IE>ISENTO</IE>'																				// 67
	Else
		cString += '<IE>' + NoPontos(Upper(AllTrim(SA1->A1_INSCR))) + '</IE>'														// 67
	EndIf

	//If SA1->A1_PESSOA == 'J' .And. SA1->A1_CONTRIB == '2'
	//	cString += '<IE>' + NoPontos(Upper(AllTrim(SA1->A1_INSCR))) + '</IE>'
	//EndIf

	If cAmbiente == '1'
		cString += '<xNome>' + RemoveAcento(Alltrim(SA1->A1_NOME )) + '</xNome>'													// 68
		cString += '<xFant>' + RemoveAcento(Alltrim(SA1->A1_NREDUZ )) + '</xFant>'													// 69
	Else
		cString += '<xNome>CT-E EMITIDO EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL</xNome>'
		cString += '<xFant>CT-E EMITIDO EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL</xFant>'
	Endif

	If !Empty(SA1->A1_DDD)
		cTelAux += StrZero(Val(SA1->A1_DDD),3)
	EndIf

	If !Empty(NoPontos(SA1->A1_TEL))
		cTelAux += cValtoChar(NoPontos(SA1->A1_TEL))
		cString += '<fone>' + cTelAux + '</fone>'												// 70
	EndIf

	cString += '<enderToma>'

	cString += '<xLgr>' +  RemoveAcento(Alltrim(FisGetEnd(SA1->A1_END)[1])) + '</xLgr>'															// 72
	cString += '<nro>' + Iif(FisGetEnd(SA1->A1_END)[2]<>0, AllTrim(cValtoChar( FisGetEnd(SA1->A1_END)[2])),"S/N") + '</nro>'				// 73
	If !Empty(RemoveAcento(FisGetEnd(SA1->A1_END)[4]))
		cString += '<xCpl>' + RemoveAcento(Alltrim(FisGetEnd(SA1->A1_END)[4])) + '</xCpl>'														// 74
	EndIf
	cString += '<xBairro>' + RemoveAcento(Alltrim(SA1->A1_BAIRRO)) + '</xBairro>'																// 75
	cString += '<cMun>' + Alltrim(str(Val(getUFCode(SA1->A1_EST) + SA1->A1_COD_MUN))) + '</cMun>'																					// 76
	cString += '<xMun>' + RemoveAcento(Alltrim(SA1->A1_MUN)) + '</xMun>'																			// 77
	If !Empty(SA1->A1_CEP)
		cString += '<CEP>' + NoPontos(SA1->A1_CEP) + '</CEP>'																				// 78
	Endif
	cString += '<UF>' + SA1->A1_EST + '</UF>'																							// 79
	cString += '<cPais>' + SA1->A1_PAIS + '</cPais>'																					// 80
	cString += '</enderToma>'

	cMail   := RemoveAcento(Alltrim(SA1->A1_EMAIL))

	If !Empty(cMail)
		cString += '<email>' + cMail + '</email>'
		cString += '[EMAIL=' + cMail + ']'
	Endif															// 82

	cString += '</toma>'

return cString

//-----------------------------------------------------------------------------------------------------
/*/{Protheus.doc} XmlCTeVPrest()

Monta Grupo do valor do serviço prestado

@return cString         XML com CTeOS

@author 	Fernando Amorim(Cafu)
@since		20/09/2017
@version 12.1.17

/*/
//-----------------------------------------------------------------------------------------------------
static function XmlCTeVPrest(cSerie,cNota,cCliente,cLoja)

	Local cString 	:= ""
	Local cAliasRet := GetNextAlias()
	Local nIrRet	:= 0
	Local nCsllRet 	:= 0
	Local nPisRet 	:= 0
	Local nCofRet	:= 0
	Local nInssRet	:= 0
	Local nTotRet	:= 0
	Local nTotAbImp := 0
	
	CteQuery(@cAliasRet,cSerie,cNota,cCliente,cLoja)

	If !(cAliasRet)->(Eof())			 
		nVPIS		:= (cAliasRet)->FT_VRETPIS	
		nVCOF		:= (cAliasRet)->FT_VRETCOF			
		nVCSL		:= (cAliasRet)->FT_VRETCSL	
		nTotAbImp	:= nVPIS + nVCOF + nVCSL     
    EndIf

	dbSelectArea("SE1")
	SE1->(dbSetOrder(2))
	If SE1->(dbSeek(xFilial("SE1")+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_SERIE+SF2->F2_DOC))
		While !SE1->(Eof()) .And. xFilial("SE1") == SE1->E1_FILIAL .And.;
				SF2->F2_CLIENTE == SE1->E1_CLIENTE .And. SF2->F2_LOJA == SE1->E1_LOJA .And.;
				SF2->F2_SERIE == SE1->E1_PREFIXO .And. SF2->F2_DOC == SE1->E1_NUM
			If 'NF' $ SE1->E1_TIPO
				nTotRet+=SumAbatRec(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_MOEDA,"V",SE1->E1_BAIXA,@nTotAbImp,@nIrRet,@nCsllRet,@nPisRet,@nCofRet,@nInssRet,,,.T.)
			EndIf
			SE1->(DbSkip ())
		EndDo
	EndIf

	cString := '<vPrest>'

	cString += '<vTPrest>'+ ConvType(SF2->F2_VALBRUT,15,2) + '</vTPrest>' 				//84
	cString += '<vRec>'+ ConvType( SF2->F2_VALMERC - nTotAbImp ,15,2) + '</vRec>'  		//85
   /* If  GZH->GZH_COMPVL == '1'
     cString := '<Comp>'
   
     cString += '<xNome>'+ GZH->GZH_TPCOMP + '</xNome>'									//87
     cString += '<vComp>'+ ConvType(GZH->GZH_VLADIC,15,2) + '</vComp>' 					//88
     
     cString += '</Comp>'
    Endif */
    cString += '</vPrest>'


return(cString)



//-----------------------------------------------------------------------------------------------------
/*/{Protheus.doc} XmlCTeIMP()

Monta Grupo do impostos

@param cSerie    	Serie da nota
@param cNota    	Numero da nota
@param cCliente    	Cliente da nota
@param cLoja	    Loja da nota

@return cString         XML com CTeOS

@author 	Fernando Amorim(Cafu)
@since		20/09/2017
@version 12.1.17

/*/
//-----------------------------------------------------------------------------------------------------
static function XmlCTeIMP(cSerie,cNota,cCliente,cLoja,cEvento)

    Local cString 	:= ""
    Local nBASEICM 	:= 0
	Local nALIQICM 	:= 0
	Local nVALICM  	:= 0
	Local nALIQSOL 	:= 0
	Local nICMSRET 	:= 0
	Local cObs 		:= AllTrim(FORMULA(SC5->C5_MENPAD))
	Local cMVSINAC 	:= SuperGetMv("MV_CODREG")
	Local cCFOP		:= ''
	Local cpRedBC	:= ''
	Local lFecp		:= SF4->(FieldPos('F4_DIFAL')) > 0
	Local nBCICMS 	:= 0
	Local nPERFCP 	:= 0
	Local nALQTER 	:= 0
	Local nALQINT 	:= 0
	Local nPEDDES 	:= 0
	Local nVALFCP 	:= 0
	Local nVALDES 	:= 0
	Local nVLTRIB 	:= 0
	Local cAliasCD2 := ''
	Local cQuery	:= ''
	Local cAliasICM	:= ''
	Local nVcred	:= 0
	Local nVPIS		:= 0
	Local nVCOF		:= 0
	Local nVIRR		:= 0
	Local nVINS		:= 0
	Local nVCSL		:= 0
	
	SF3->(DbSetOrder(4))
	If SF3->(DbSeek(xFilial("SF3")+cCliente+cLoja+PadR(cNota,TamSx3('F2_DOC')[1])+PadR(cSerie,TamSx3('F2_SERIE')[1])))
		cCFOP := SF3->F3_CFO
	EndIf
    SFT->(DbSetOrder(1))
	SFT->(DbSeek(xFilial("SF3")+'S'+PadR(cSerie,TamSx3('F2_SERIE')[1])+PadR(cNota,TamSx3('F2_DOC')[1])+cCliente+cLoja ))
	
	SD2->(DbSetOrder(3))
	SD2->(DbSeek(xFilial("SD2")+PadR(cNota,TamSx3('F2_DOC')[1])+PadR(cSerie,TamSx3('F2_SERIE')[1])+cCliente+cLoja ))
	
	SA1->(DbSetOrder(1))
	SA1->(DbSeek(xFilial('SA1')+cCliente+cLoja)) 
	
	SF4->(DbSetOrder(1))
	If SF4->(DbSeek(xFilial("SF4")+SD2->D2_TES ))
		cpRedBC := AllTrim(Str(100-SF4->F4_BASEICM))
	Endif
	
	cAliasICM := GetNextAlias()
	CteQuery(@cAliasICM,cSerie,cNota,cCliente,cLoja)	
	If !(cAliasICM)->(Eof())
	
		 If (cAliasICM)->FT_VALICM > 0
				nBASEICM := (cAliasICM)->FT_BASEICM
				nALIQICM := (cAliasICM)->FT_ALIQICM
				nVALICM  := (cAliasICM)->FT_BASEICM * ((cAliasICM)->FT_ALIQICM / 100) //(cAliasICM)->FT_VALICM
				nALIQSOL := (cAliasICM)->FT_ALIQSOL
				nICMSRET := (cAliasICM)->FT_ICMSRET
		 Else
				nBASEICM := (cAliasICM)->D2_BASEICM
				nALIQICM := (cAliasICM)->D2_PICM
				nVALICM  := (cAliasICM)->D2_BASEICM * ((cAliasICM)->D2_PICM / 100) //(cAliasICM)->D2_VALICM
				nALIQSOL := (cAliasICM)->D2_ALIQSOL
				nICMSRET := (cAliasICM)->D2_ICMSRET
				SF4->(DbSeek(xFilial("SF4")+(cAliasICM)->D2_TES ))
				nVcred  := (SF4->F4_CRDPRES*(cAliasICM)->D2_VALICM)
		 EndIf 	 
		 nVPIS		:= (cAliasICM)->FT_VRETPIS	//IIF((cAliasICM)->FT_VRETPIS == 0, (cAliasICM)->FT_VALPIS, (cAliasICM)->FT_VRETPIS)
		 nVCOF		:= (cAliasICM)->FT_VRETCOF	//IIF((cAliasICM)->FT_VRETCOF == 0, (cAliasICM)->FT_VALCOF,(cAliasICM)->FT_VRETCOF)
		 nVIRR		:= (cAliasICM)->FT_VALIRR
		 nVINS		:= (cAliasICM)->FT_VALINS
		 nVCSL		:= (cAliasICM)->FT_VRETCSL	//IIF((cAliasICM)->FT_VRETCSL == 0, (cAliasICM)->FT_VALCSL,(cAliasICM)->FT_VRETCSL)	 
		     
    EndIf
    (cAliasICM)->(DbCloseArea())
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ TAG:  Informacoes relativas ICMS para a UF de término da `     //
	// prestação do serviço de transporte nas operações interestaduais //
	// para consumidor final  Emenda Constitucional 87 de 2015.        //
	// Nota Técnica 2015/003 e 2015/004                                //
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
	If lFecp
		If SF4->F4_DIFAL == "1" .And. SF4->F4_COMPL == "S" 
			//--Zerar Variaveis
			nBCICMS := 0
			nPERFCP := 0
			nALQTER := 0
			nALQINT := 0
			nPEDDES := 0
			nVALFCP := 0
			nVALDES := 0
			nVLTRIB := 0
				
			cAliasCD2 := GetNextAlias()					
			cQuery := " SELECT SUM(CD2.CD2_BC) CD2_BC,"+ CRLF
			cQuery += " CD2.CD2_PFCP," + CRLF
			cQuery += " CD2.CD2_ALIQ," + CRLF
			cQuery += " CD2.CD2_ADIF," + CRLF
			cQuery += " CD2.CD2_PDDES," + CRLF
			cQuery += " SUM(CD2.CD2_VFCP) CD2_VFCP," + CRLF
			cQuery += " SUM(CD2.CD2_VDDES) CD2_VDDES,"+ CRLF
			cQuery += " SUM(CD2.CD2_VLTRIB) CD2_VLTRIB " + CRLF														
			cQuery += "   FROM "+ RetSqlName("SD2") + " D2," + RetSqlName("CD2") + " CD2 "  + CRLF	
			cQuery += "    WHERE D2.D2_FILIAL  = '" + xFilial('SD2') + "'" + CRLF
			cQuery += "    AND D2.D2_DOC     = '" + cNota    + "'" + CRLF      
			cQuery += "    AND D2.D2_SERIE   = '" + cSerie   + "'" + CRLF      
			cQuery += "    AND D2.D2_CLIENTE = '" + cCliente + "'" + CRLF      
			cQuery += "    AND D2.D2_LOJA    = '" + cLoja    + "'" + CRLF      
			cQuery += "    AND D2.D_E_L_E_T_ = ''" + CRLF       
										
			cQuery += "    AND CD2.CD2_FILIAL = '"  + xFilial('CD2') + "'" + CRLF							
			cQuery += "    AND CD2.CD2_CODCLI = D2.D2_CLIENTE " + CRLF
			cQuery += "    AND CD2.CD2_LOJCLI = D2.D2_LOJA " + CRLF
			cQuery += "    AND CD2.CD2_DOC    = D2.D2_DOC " + CRLF
			cQuery += "    AND CD2.CD2_SERIE  = D2.D2_SERIE " + CRLF
			cQuery += "    AND CD2.CD2_ITEM   = D2.D2_ITEM " + CRLF
			cQuery += "    AND CD2.CD2_IMP    = '" + PadR("CMP",TamSX3("CD2_IMP")[1]) + "'" + CRLF
			cQuery += "    AND CD2.D_E_L_E_T_<>'*'" + CRLF	
			
			cQuery += " GROUP BY CD2.CD2_PFCP,CD2.CD2_ALIQ,CD2.CD2_ADIF,CD2.CD2_PDDES "	+ CRLF						  
								
			cQuery := ChangeQuery(cQuery)
			DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasCD2, .F., .T.)
			If !(cAliasCD2)->(Eof())
				nBCICMS := (cAliasCD2)->CD2_BC
				nPERFCP := (cAliasCD2)->CD2_PFCP
				nALQTER := (cAliasCD2)->CD2_ALIQ
				nALQINT := (cAliasCD2)->CD2_ADIF
				nPEDDES := (cAliasCD2)->CD2_PDDES
				nVALFCP := (cAliasCD2)->CD2_VFCP
				nVALDES := (cAliasCD2)->CD2_VDDES
				nVLTRIB := (cAliasCD2)->CD2_VLTRIB
			EndIf			

			(cAliasCD2)->(DbCloseArea())
		Else
			//Tratamento para que nao sejam geradas as TAGs no XML caso nao atenda as condiçoes
			lFecp := .F.
		EndIf

    Endif
    
    
    cString := '<imp>'
    
    cString += '<ICMS>'
    
    If cMVSINAC == '1'
	//--Simples Nacional(MV_CODREG == 1)
		cString += '<ICMSSN>'
		cString += '<CST>90</CST>'
 		cString += '<indSN>1</indSN>'							 
		cString += '</ICMSSN>'									
	ElseIf SubStr(SFT->FT_CLASFIS, 2, 2) == '00'
		If SF2->F2_TIPO ='I'
			ComplICMS(@nBASEICM,@nALIQICM,@nVALICM)
		cString += '<ICMS00>'
		cString += '<CST>00</CST>'
		cString += '<vBC>'  + ConvType(nBASEICM, 15, 2) + '</vBC>'
		cString += '<pICMS>'+ ConvType(nALIQICM,  5, 2) + '</pICMS>'
		cString += '<vICMS>'+ ConvType(nVALICM , 15, 2) + '</vICMS>'
		cString += '</ICMS00>'						
		Else		
		cString += '<ICMS00>'
		cString += '<CST>00</CST>'
		cString += '<vBC>'  + ConvType(nBASEICM, 15, 2) + '</vBC>'
		cString += '<pICMS>'+ ConvType(nALIQICM,  5, 2) + '</pICMS>'
		cString += '<vICMS>'+ ConvType(nVALICM , 15, 2) + '</vICMS>'
		cString += '</ICMS00>'						
		EndIf					
	ElseIf SubStr(SFT->FT_CLASFIS, 2, 2) $ "40,41,51"
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ ICMS Isento, nao Tributado ou dIferido  ³
		//³ - 40: ICMS Isencao                      ³
		//³ - 41: ICMS Nao Tributada                ³
		//³ - 51: ICMS DIferido                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cString += '<ICMS45>'
		If SubStr(SFT->FT_CLASFIS, 2, 2)  == '40'
			cString += '<CST>40</CST>'
		ElseIf SubStr(SFT->FT_CLASFIS, 2, 2) == '41'
			cString += '<CST>41</CST>'
		ElseIf SubStr(SFT->FT_CLASFIS, 2, 2) == '51'
			cString += '<CST>51</CST>'
		EndIf
		cString += '</ICMS45>'
	
	ElseIf SubStr(SFT->FT_CLASFIS, 2, 2) $ "10,30,70"
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ - 80: ICMS pagto atribuido ao tomador ou ao 3o previsto para    ³
		//³ substituicao tributaria                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cString += '<ICMS90>'
		cString += '<CST>90</CST>'
		If !Empty(cpRedBC)
			cString += '<pRedBC>' + ConvType(cpRedBC, 5, 2) + '</pRedBC>'
		EndIf
		cString += '<vBC>'    + ConvType(nBASEICM, 15, 2) + '</vBC>'
		cString += '<pICMS>'  + ConvType(nALIQICM,  5, 2) + '</pICMS>'
		cString += '<vICMS>'  + ConvType(nVALICM , 15, 2) + '</vICMS>'
		cString += '<vCred>'  + ConvType(nVcred  , 15, 2) + '</vCred>'
		cString += '</ICMS90>'
	ElseIf SubStr(SFT->FT_CLASFIS, 2, 2) $ '90'
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ - 81: ICMS DEVIDOS A OUTRAS UF'S                                ³
		//³ - 90: ICMS Outros                                               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cString += '<ICMS90>'		
		cString += '<CST>90</CST>'
		If !Empty(cpRedBC)
			cString += '<pRedBC>' + ConvType(cpRedBC, 5, 2) + '</pRedBC>'
		EndIf
		cString += '<vBC>'    + ConvType(nBASEICM, 13, 2) + '</vBC>'
		cString += '<pICMS>'  + ConvType(nALIQICM,  5, 2) + '</pICMS>'
		cString += '<vICMS>'  + ConvType(nVALICM , 13, 2) + '</vICMS>'
		cString += '<vCred>'  + ConvType(nICMSRET, 15, 2) + '</vCred>'
		cString += '</ICMS90>'
		
		
	ElseIf SubStr(SFT->FT_CLASFIS, 2, 2) $ '20,90' .And. AllTrim(cCFOP) $ "5932,6932"
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ - 81: ICMS DEVIDOS A OUTRAS UF'S                                ³
		//³ - 90: ICMS Outros                                               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cString += '<ICMSOutraUF>'
		cString += '<CST>90</CST>'
		If !Empty(cpRedBC)
			cString += '<pRedBCOutraUF>' + ConvType(cpRedBC, 5, 2) + '</pRedBCOutraUF>'
		EndIf
		cString += '<vBCOutraUF>'    + ConvType(nBASEICM, 13, 2) + '</vBCOutraUF>'
		cString += '<pICMSOutraUF>'  + ConvType(nALIQICM, 05, 2) + '</pICMSOutraUF>'
		cString += '<vICMSOutraUF>'  + ConvType(nVALICM , 13, 2) + '</vICMSOutraUF>'
		cString += '</ICMSOutraUF>'
	EndIf
    
    cString += '</ICMS>'
    If SF2->F2_TOTIMP > 0 
    	cString += '<vTotTrib>'+ ConvType(SF2->F2_TOTIMP, 13, 2) + '</vTotTrib>
    Endif
    If !Empty(cObs)
    	cString += '<infAdFisco>'+  RemoveAcento(alltrim(cObs)) + '</infAdFisco>
    EndIf
    
    If SA1->A1_CONTRIB <> '1' .And. lFecp  //-- Não Contribuinte e Campo Difal
		cString += '<ICMSUFFim>'						
		cString += '<vBCUFFim>'   		+ ConvType(nBCICMS,  15, 2) + '</vBCUFFim>'
		cString += '<pFCPUFFim>'  		+ ConvType(nPERFCP,   5, 2) + '</pFCPUFFim>'
		cString += '<pICMSUFFim>' 		+ ConvType(nALQTER,   5, 2) + '</pICMSUFFim>'
		cString += '<pICMSInter>' 		+ ConvType(nALQINT,   5, 2) + '</pICMSInter>'
		If SM0->M0_ESTENT == 'PR'	//Paraná ainda necessita da tag
		cString += '<pICMSInterPart>'	+ ConvType(nPEDDES,   5, 2) + '</pICMSInterPart>'
		EndIf
		cString += '<vFCPUFFim>' 		+ ConvType(nVALFCP,  15, 2) + '</vFCPUFFim>'
		cString += '<vICMSUFFim>'  		+ ConvType(nVALDES,  15, 2) + '</vICMSUFFim>'
		cString += '<vICMSUFIni>' 		+ ConvType(nVLTRIB,  15, 2) + '</vICMSUFIni>'							
		cString += '</ICMSUFFim>'									
	EndIf	
    
    cString += '<infTribFed>'     
     
    cString += '<vPIS>'+ ConvType(nVPIS, 13, 2) + '</vPIS>'
    cString += '<vCOFINS>'+ ConvType(nVCOF, 13, 2) + '</vCOFINS>'
    cString += '<vIR>'+ ConvType(nVIRR, 13, 2) + '</vIR>'
    cString += '<vINSS>'+ ConvType(nVINS, 13, 2) + '</vINSS>'
    cString += '<vCSLL>'+ ConvType(nVCSL, 13, 2) + '</vCSLL>'
  
	cString += '</infTribFed>'
    
    cString += '</imp>'

	nValIcmAux := nVALICM

return(cString)


//-----------------------------------------------------------------------------------------------------
/*/{Protheus.doc} XmlCTeINF()

Monta Grupo das informações do serviço prestado

@param cSerie    	Serie da nota
@param cNota    	Numero da nota
@param cCliente    	Cliente da nota
@param cLoja	    Loja da nota

@return cString         XML com CTeOS

@author 	Fernando Amorim(Cafu)
@since		21/09/2017
@version 12.1.17

/*/
//-----------------------------------------------------------------------------------------------------
static function XmlCTeINF(cSerie,cNota,cCliente,cLoja,cmodal, cTpServ, cTpFretamento, cDataViagem, cHoraViagem, cEvento)

    Local cString 	:= ''
    Local cDescri	:= ''
	local cDhViagem := ""
	local cServerUF := IIf(!empty(SM0->M0_ESTENT), SM0->M0_ESTENT, SM0->M0_ESTCOB)
	local lHVerao := SuperGetMv("MV_HRVERAO",, "2") == "1"
	
    default cModal := '01'
    Default cEvento := ''
    
    SD2->(DbSetOrder(3))
	SD2->(DbSeek(xFilial("SD2")+PadR(cNota,TamSx3('F2_DOC')[1])+PadR(cSerie,TamSx3('F2_SERIE')[1])+cCliente+cLoja ))
    
    SB1->(DbSetOrder(1))
	If SB1->(DbSeek(xFilial("SB1")+SD2->D2_COD ))	
		cDescri	:= SB1->B1_DESC
	EndIf
	
    cString := '<infCTeNorm>'
   
    cString += '<infServico>'
    
    cString += '<xDescServ>'+ RemoveAcento(Alltrim(cDescri)) + '</xDescServ>'
    
    cString += '<infQ>'
    
    cString += '<qCarga>'+ ConvType(GZH->GZH_INFQ,11,0) + '</qCarga>'
    
    cString += '</infQ>'
          
    cString += '</infServico>'
    
    If cTpServ == "8"
		cString += XmlExcBag(cNota)
    Endif
    
//    Necessário verificar como preencher esses campos
//    cString += '<seg>'
//    cString += '<respSeg>'+ + '</respSeg>'
//    cString += '<xSeg>'   + + '</xSeg>'   
//    cString += '<nApol>'  + + '</nApol>'  
//    cString += '</seg>'
    
    if cModal == '01'
	    
	    cString += '<infModal versaoModal="4.00">'
	    
	    cString += '<rodoOS>'
	    If !Empty(GZH->GZH_AUTTAF) 
	    	cString += '<TAF>'+ Alltrim(GZH->GZH_AUTTAF) + '</TAF>'
	    Endif
	    If !Empty(GZH->GZH_REGEST) 
	    	cString += '<NroRegEstadual>'+ GZH->GZH_REGEST + '</NroRegEstadual>'
	    Endif    
	    
	
		if(!empty(GZH->GZH_VEIC) ) 
			cString += '<veic>'
			
			cString += '<placa>'+ NoPontos(GZH->GZH_PLACA) + '</placa>'
			if(!empty(GZH->GZH_RENAVA))
				cString += '<RENAVAM>'+ NoPontos(GZH->GZH_RENAVA) + '</RENAVAM>'
			endif	
			
			cString += '<UF>'+ GZH->GZH_UFVEI + '</UF>'        
					
			cString += '</veic>'
	     endif
	     
		if(cTpServ == "6")
			
						
			// Montagem da Data UTC			
			cDhViagem := Substr(cDataViagem ,1 ,4 )
			cDhViagem += "-"
			cDhViagem += Substr(cDataViagem, 5, 2 )
			cDhViagem += "-"
			cDhViagem += substr(cDataViagem, 7, 2 )			
			cDhViagem += "T"
			cDhViagem += cHoraViagem
			cDhViagem += Substr(Alltrim(FwGMTByUF(cServerUF, lHVerao)), 1, 6 )
			
			cstring += '<infFretamento>'
			cstring += '<tpFretamento>' + str(val(cTpFretamento),1) + '</tpFretamento>'
			cstring += '<dhViagem>' + cDhViagem + '</dhViagem>'			
			cstring +='</infFretamento>'
			
		endif
		
		

		 cString += '</rodoOS>'
	     
	     cString += '</infModal>'
	     
	     //cString += '<cobr>'
	
	endif
	
     
    If cEvento == 'S'        
    	cString += XmlCTeSub(GZH->GZH_CHVCTE,GZH->GZH_CHVANU)
    EndIf
    
    cString += '</infCTeNorm>'
    
  


return(cString)

//-----------------------------------------------------------------------
/*/{Protheus.doc}	XmlINfRespTec
Grupo de informações do responsável tecnico

@param cChave	Chave do documento

@return	cRetorno    cstring

@author Renato Nagib
@since 02/10/2018
@version 12.1.17
/*/
//-----------------------------------------------------------------------
static function XmlINfRespTec(cChave) 

	local cxml := ''
	local cCNPJ := '53113791000122'
	local cContato :='FULANO'
	local cEmail := 'fulano@gmail.com'
	local cFone := '9955943619'
	local cIdCSRT := '123'	
	local cHashCSRT := encode64(encode64(sha1(SuperGetMv("MV_TOKENRT",, "123") + cChave, 1 ) ))//aplicado duplo encode64 apenas para passar na validação de schema.sera necessario ajustar rotina na oficialização da valdação
	
	cXml +='<infRespTec>'
	cXml += '<CNPJ>'+cCNPJ+'</CNPJ>'
	cXml += '<xContato>'+cContato+'</xContato>'
	cXml += '<email>'+cEmail+'</email>'
	cXml += '<fone>'+cFone+'</fone>'
	cXml += '<idCSRT>'+cIdCSRT+'</idCSRT>'
	cXml += '<hashCSRT>'+cHashCSRT+'</hashCSRT>'
	cXml +='</infRespTec>'
return cXml

//-----------------------------------------------------------------------

/*/{Protheus.doc}	XmlExcBag
Grupo de informações de excesso de Bagagem - Documentos referenciados

@param cNota	Nota do documento

@return	cRetorno    cstring

@author Gustavo Silva
@since 05/04/2019
@version 12.1.17
/*/
//-----------------------------------------------------------------------
 
 static function XmlExcBag(cNota)

	Local cAliasTmp := GetNextAlias()
	Local cString	:= ""
	Local cNumDoc	:= ""
	Local cSerie	:= ""
	Local cSubser	:= ""
	Local cDataEmi	:= ""
	Local cData		:= ""
	Local nValorDoc	:= 0
	Local cFilGQ2   := xFilial("GQ2", xFilial("GZH")) 

	BeginSql alias cAliasTmp
		SELECT GQ1.GQ1_SERIE, GQ1.GQ1_SUBSER, GQ1.GQ1_NUMDOC, GQ1.GQ1_TIPDOC, GQ1.GQ1_VALOR, GQ2.GQ2_DTEMI, GZH.GZH_NOTA
		FROM %table:GZH% GZH
		JOIN %table:GQ2% GQ2 ON GQ2_FILIAL = %Exp:cFilGQ2% AND GQ2_CODIGO = GZH_CODGQ2 AND GQ2.%notDel%
		JOIN %table:GQ1% GQ1 ON GQ1_FILIAL = GQ2_FILIAL AND GQ1_CODGQ2 = GQ2_CODIGO AND GQ1.%notDel% 
		
		WHERE GZH_FILIAL = %xFilial:GZH% AND 
		      GZH_NOTA = %exp:alltrim(cNota)% AND 
		      GZH.%notDel%
			
		GROUP BY GQ1_SERIE, GQ1_SUBSER, GQ1_NUMDOC, GQ1_TIPDOC, GQ1_VALOR,GQ2_CODIGO,GQ2_DTEMI, GZH_CODGQ2, GZH_NOTA
	EndSql
	
	While (cAliasTmp)->(!EoF())
		cDataEmi	:= ""
	    cNumDoc		:= (cAliasTmp)->(GQ1_NUMDOC)
	    cSerie		:= (cAliasTmp)->(GQ1_SERIE)
	    cSubser	    := (cAliasTmp)->(GQ1_SUBSER)
	    cData		:= (cAliasTmp)->(GQ2_DTEMI)
	    nValorDoc	:= (cAliasTmp)->(GQ1_VALOR)
	    
	    cDataEmi += Substr(cData ,1 ,4 )
		cDataEmi += "-"
		cDataEmi += Substr(cData, 5, 2 )
		cDataEmi += "-"
		cDataEmi += substr(cData, 7, 2 )
		
		nValorDoc:= convType(nValorDoc,15,2,"N")
			
		cString +='<infDocRef>'
		cString +='<nDoc>' + cNumDoc+'</nDoc>'
		cString +='<serie>'+ cSerie+'</serie>'
		cString +='<subserie>'+cSubser+'</subserie>'
		cString +='<dEmi>'+cDataEmi+'</dEmi>'
		cString +='<vDoc>'+ nValorDoc+'</vDoc>'
		cString+= '</infDocRef>'
		
	(cAliasTmp)->(DbSkip())
	End
	
	(cAliasTmp)->(DbCloseArea())
		
return cString 

//-----------------------------------------------------------------------

/*/{Protheus.doc}	RemoveAcento
Verifica se há acento

@param cTexto   COnteudo a ser 

@return	cRetorno    cstring

@author Fernando Amorim(Cafu)
@since 20/09/2017
@version 12.1.17
/*/
//-----------------------------------------------------------------------

Static Function RemoveAcento(cString)
Local nX        := 0 
Local nY        := 0 
Local cSubStr   := ""
Local cRetorno  := ""

Local cStrEsp	:= "ÁÃÂÀáàâãÓÕÔóôõÇçÉÊéêºÚú"
Local cStrEqu   := "AAAAaaaaOOOoooCcEEeerUu" //char equivalente ao char especial

For nX:= 1 To Len(cString)
	cSubStr := SubStr(cString,nX,1)
	nY := At(cSubStr,cStrEsp)
	If nY > 0 
		cSubStr := SubStr(cStrEqu,nY,1)
	EndIf
    
	cRetorno += cSubStr
Next nX

Return cRetorno		


//-----------------------------------------------------------------------
/*/{Protheus.doc}	NoPontos
Verifica se há algo diferente de letras ou numeros

@param cTexto   Conteudo a ser 

@return	cRetorno    cstring

@author Fernando Amorim(Cafu)
@since 20/09/2017
@version 12.1.17
/*/
//-----------------------------------------------------------------------

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
cString := AllTrim(cString)

Return cString


//-----------------------------------------------------------------------
/*/{Protheus.doc}	convType
Formata conteudo

@param xValor   Valor do conteudo
@param nTam     tamanho da valor(Inteiro + decimais)
@param nDec     Numero de casas decimais
@param cTipo    Tipo do conteudo 

@return	cNovo	 Conteudo formatado

@author Renato Nagib
@since 21/08/2017
@version 12.1.17
/*/
//-----------------------------------------------------------------------
static function convType(xValor,nTam,nDec,cTipo)

    local cNovo 	:= ""  

    DEFAULT nDec 	:= 0   
    DEFAULT cTipo 	:= ""

    Do Case
        
        Case valType(xValor)=="N"          
            
            if xValor <> 0  		            
                cNovo := AllTrim(str(xValor,nTam+1,nDec))                    
                if Len(cNovo)>nTam
                    cNovo := AllTrim(str(xValor,nTam+1,nDec-(Len(cNovo)-nDec)))
                endif  
                                            
            else
                cNovo := "0"
            endif   
            
        Case valType(xValor)=="D"
            cNovo := FsDateConv(xValor,"YYYYMMDD")
            cNovo := substr(cNovo,1,4)+"-"+substr(cNovo,5,2)+"-"+substr(cNovo,7)
        
        Case valType(xValor)=="C" 
        
            if ( cTipo == "N" ) 			          
                cDecOk := substr(xValor,at(".",xValor)+1)                
                
                if ( len(cDecOk) > nDec )
                    xValor := substr(xValor,1,len(xValor)-(len(cDecOk)-nDec))
                endif
            
                if ( len(xValor) > nTam )
                    nDesconto := len(xValor) - nTam
                    xValor := substr(xValor,1,len(xValor)-nDesconto)
                endif   
                
                if ( substr(xValor,len(xValor)) == "." )
                    xValor := substr(xValor,1,len(xValor)-1)				
                endif  						  						
                
                cNovo := allTrim(xValor)
                
            else
            
                if nTam==Nil
                    xValor := AllTrim(xValor)
                endif
                
                DEFAULT nTam := 60
                cNovo := AllTrim(EnCodeUtf8(NoAcento(substr(xValor,1,nTam))))
            
            endif
    EndCase

return cNovo


//-----------------------------------------------------------------------
/*/{Protheus.doc}	getUFCode
tras o codigo do UF

@param cEst  	sigla do estado


@return	cCodUF	 Codigo da UF

@author Fernando Amorim(cafu)
@since 21/09/2017
@version 12.1.17
/*/
//-----------------------------------------------------------------------
static function getUFCode(cEst)

	Local aUF		:= {}
	Local cCodUF	:= ''
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
    
    aAreaSM0 := SM0->(GetArea())
    If aScan(aUF,{|x| x[1] ==  AllTrim(cEst) }) != 0 // Confere se Uf do Emitente esta OK
		cCodUF := aUF[ aScan(aUF,{|x| x[1] == AllTrim(cEst) }), 2]
	Else
		cCodUF := ''
	EndIf
	
return cCodUF


//-----------------------------------------------------------------------
/*/{Protheus.doc}	GerLeiTr
gera mensagem de lei da transparencia

@param cNota  		CTeOS
@param cSerie  		Serie da CTeOS
@param cCliente 	Cliente da CTeOS
@param cLoja	  	Loja

@return	cRet 		msg da lei da transparencia

@author Fernando Amorim(cafu)
@since 29/09/2017
@version 12.1.17
/*/
//-----------------------------------------------------------------------
Static Function GerLeiTr(cNota,cSerie,cCliente,cloja) 

	Local cRet		:=" Impostos Aproximados: - "  
	Local cImpFed	:= "Federais	:    "
	Local cImpEst	:= "Estaduais	: 0.00 - "
	Local cImpMun	:= "Municipais	:  "
	Local nImpFed	:= 0  
	Local nImpEst	:= 0   
	Local nImpMun	:= 0  
	Local aAreaSFT	:= SFT->(Getarea())  
	Local aArea		:= Getarea()  
	Local nValINS	:= 0
	Local nValISS	:= 0
	Local nValICM	:= 0
	Local nValPIS	:= 0
	Local nValCOF	:= 0
	Local nValIPI	:= 0
	Local nValIRR	:= 0
	Local nValCsll	:= 0
	Local nRetPIS	:= 0
	Local nRetCOFINS:= 0
	Local nRetencoes:= 0
	Local nSomaImp	:= 0 
	Local nTamFTITEM  := TamSx3('FT_ITEM')[1] 
	Local nTamCD2ITEM := TamSx3('CD2_ITEM')[1] 

	SD2->(DBSETORDER(3))
	If SD2->(DbSeek(xFilial("SD2")+cNota+cSerie+cCliente+cloja))
		While !SD2->(Eof ()) .And. SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA == cNota+cSerie+cCliente+cloja
			SFT->(DBSETORDER(1))
			If SFT->(DBSEEK(xFilial("SFT")+ "S" + cSerie+cNota + cCliente + cloja + PadR(SD2->D2_ITEM,nTamFTITEM) + SD2->D2_COD))  
				
				nValINS  	+= SFT->FT_VALINS
				nValIRR  	+= SFT->FT_VALIRR
				nValCsll 	+= SFT->FT_VRETCSL
				nRetPIS		+= SFT->FT_VRETPIS
				nRetCOFINS	+= SFT->FT_VRETCOF				
				
			Endif
			dbSelectArea("CD2")
			dbSetOrder(1)
			If CD2->(DbSeek(xFilial("CD2")+"S"+SD2->D2_SERIE+SD2->D2_DOC+SD2->D2_CLIENTE+SD2->D2_LOJA+PadR(SD2->D2_ITEM,nTamCD2ITEM) + SD2->D2_COD ))
				While !CD2->(Eof ()) .And. CD2->CD2_DOC == SD2->D2_DOC .And. CD2->CD2_ITEM == SFT->FT_ITEM
					If Alltrim(CD2->CD2_IMP) == "ISS" 
						nValISS	+= CD2->CD2_VLTRIB 
					ElseIf Alltrim(CD2->CD2_IMP) == "IPI" 
						nValIPI	+= CD2->CD2_VLTRIB 
					ElseIf Alltrim(CD2->CD2_IMP) == "ICM" 
						nValICM	+= CD2->CD2_VLTRIB 
					ElseIf Alltrim(CD2->CD2_IMP) == "CF2" 
						nValCOF	+= CD2->CD2_VLTRIB 
					ElseIf Alltrim(CD2->CD2_IMP) == "PS2" 
						nValPIS	+= CD2->CD2_VLTRIB 
					EndIf
					CD2->(DbSkip ())
				End 
			EndIf
			SD2->(DbSkip ()) 
		End
	Endif
	nImpFed	+= nValIRR + nValINS + nValPIS + nValCOF + nValCsll
	nImpMun += nValISS
	nImpEst	:= nValICM
	
	If nImpFed > 0
        cImpFed := "Federais: R$ " + alltrim(Transform(nImpFED,"@E 999,999,999,999.99"))+ " - "         
    Else
        cImpFed  := "Federais: R$ 0.00 - " 
    Endif 
	
	If nImpEst > 0
		cImpEst  := "Estaduais: R$ " + alltrim(Transform(nImpEST,"@E 999,999,999,999.99"))+ " - " 
	Else
		cImpEst  := "Estaduais: R$ 0.00 - " 
	Endif
	
	If nImpMun > 0
		cImpMun  :=" Municipais: R$ "+   alltrim(Transform(nImpMun,"@E 999,999,999,999.99"))+ " - "  
	Else
		cImpMun  := " Municipais: R$ 0.00 - " 
	Endif
		
	nSomaImp	:= nValPIS + nValCOF + nValICM + nValINS
	nRetencoes	:= nValINS + nValIRR + nValCsll + nRetPIS + nRetCOFINS	
	
	If nSomaImp > 0 		
   		cRet += "O valor aproximado de tributos incidentes sobre o preço deste serviço é de R$ " + alltrim(Transform(nSomaImp,"@E 999,999,999,999.99"))	   
	EndIF
	// cRet += chr(13) + chr(10) + cImpFed + cImpEst + cImpMun 

RestArea(aAreaSFT)
RestArea(aArea)
Return alltrim(cRet)    

/*/{Protheus.doc} BuscaNFs
//TODO Descrição auto-gerada.
@author osmar.junior
@since 25/03/2019
@version 1.0
@return ${return}, ${return_description}
@param cDocAux, characters, descricao
@param cSerieAux, characters, descricao
@type function
/*/
Static Function BuscaNFs(cDocAux,cSerieAux,cChave, cChvAnu, cdtEmisA,cTimeZone,cNotaA, cSerieA)
	Local lRet		:= .F.
	Local aAreaSD1 	:= SD1->(GetArea())
	Local cNota 	:= GZH->GZH_NOTA
	Local cSerie 	:= GZH->GZH_SERIE
	Local cCliFor 	:= GZH->GZH_CLIENT
	Local cLoja		:= GZH->GZH_LOJA
 
	SD1->(DbSetOrder(1))
	If SD1->(DbSeek(xFilial('SD1')+PadR(cNota,TamSx3('F2_DOC')[1])+PadR(cSerie,TamSx3('F2_SERIE')[1])+cCliFor+PadR(cLoja,TamSx3('F2_LOJA')[1])))
		lRet		:= .T.
		cDocAux		:= SD1->D1_NFORI
		cSerieAux	:= SD1->D1_SERIORI
		
		cChave += getUFCode(SM0->M0_ESTENT)
		cChave += substr(DTOS(SD1->D1_EMISSAO),3,2) 
    	cChave += substr(DTOS(SD1->D1_EMISSAO),5,2) 
    	cChave += SM0->M0_CGC 
    	cChave += '67' 
    	cChave += strZero(val(SD1->D1_SERIE),3) 
    	cChave += strZero(val(SD1->D1_DOC),9)
    	cChave += '1'
    	cChave += strZero(val(SD1->D1_DOC),8)
    
    	cChave	:= cChave + Modulo11(cChave)
    	
    	//4:F3_FILIAL+F3_CLIEFOR+F3_LOJA+F3_NFISCAL+F3_SERIE
    	SF3->(DbSetOrder(4))
    	If SF3->(DbSeek( xFilial('SF3')+ cCliFor+PadR(cLoja,TamSx3('F2_LOJA')[1])+ PadR(cDocAux,TamSx3('F2_DOC')[1])+ PadR(cSerieAux,TamSx3('F2_SERIE')[1]) ))
    	 	cChvAnu := SF3->F3_CHVNFE    		
    	EndIf
    	cNotaA 	:= SD1->D1_DOC
    	cSerieA	:= SD1->D1_SERIE
    	
    	cdtEmisA := SubStr(DToS(SD1->D1_EMISSAO), 1, 4) + "-";
			   + SubStr(DToS(SD1->D1_EMISSAO), 5, 2) + "-";
			   + SubStr(DToS(SD1->D1_EMISSAO), 7, 2) + "T";
		       + SubStr(AllTrim(Time()), 1, 2) + ":";
			   + SubStr(AllTrim(Time()), 4, 2) + ':00';
			   + cTimeZone
			   
	EndIf

RestArea(aAreaSD1)

Return lRet     


Static Function XmlCTeAnu(cChvAnu)
	Local cTagAnu := ''
	
	    cTagAnu +=	'<infCteAnu>'
		cTagAnu +=	'<chCte>' + cChvAnu + '</chCte>'
		cTagAnu +=	'<dEmi>' + ALLTRIM(STR(YEAR(SF2->F2_EMISSAO)))+'-'+ALLTRIM( STRZERO( MONTH(SF2->F2_EMISSAO),2 )) +'-'+ALLTRIM(STRZERO(DAY(SF2->F2_EMISSAO),2)) + '</dEmi>'
		cTagAnu +=	'</infCteAnu>'
	
Retur cTagAnu

Static Function XmlCTeSub(cChCteOri,cChCteAnu)
	Local cTagSub := ''
	
	    cTagSub +=	'<infCteSub>'
		cTagSub +=	'<chCte>' + cChCteOri + '</chCte>'
		cTagSub +=	'<refCteAnu>' + cChCteAnu + '</refCteAnu>'
		cTagSub +=	'</infCteSub>'
	
Retur cTagSub


Static Function XmlCTeCPL(cChCteOri)
	Local cTagComp := ''
	
		cTagComp +=	'<infCteComp>'
		cTagComp +=	'<chCTe>' + cChCteOri + '</chCTe>'
		cTagComp +=	'</infCteComp>'
	
Retur cTagComp

Static Function ComplICMS(nBASEICM,nALIQICM,nVALICM)
	Local cNota 	:= 	SD2->D2_NFORI
	Local cSerie	:=  SD2->D2_SERIORI
	Local cCliente	:=  SD2->D2_CLIENTE
	Local cLoja 	:=  SD2->D2_LOJA
	Local aAreaSD2 	:= SD2->(GetArea())
	
	nALIQICM	:= SD2->D2_PICM	

	SD2->(DbSetOrder(3))
	SD2->(DbSeek(xFilial("SD2")+PadR(cNota,TamSx3('F2_DOC')[1])+PadR(cSerie,TamSx3('F2_SERIE')[1])+cCliente+cLoja ))
	While !SD2->(Eof ()) .And. SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA == cNota+cSerie+cCliente+cLoja
		nBASEICM	+= SD2->D2_PRCVEN
			
	 	SD2->(DbSkip ()) 
	End

	nVALICM := Round(nBASEICM * (nALIQICM / 100),2)

RestArea(aAreaSD2)

Return

//VSI IMPOSTOS
static function ValImpost(cSerie,cNota,cCliente,cLoja)

    Local nBASEICM 	:= 0
	Local nALIQICM 	:= 0
	Local nVALICM  	:= 0
	Local nALIQSOL 	:= 0
	Local nICMSRET 	:= 0
	Local cCFOP		:= ''
	Local cpRedBC	:= ''	
	Local cQuery	:= ''
	Local cAliasICM	:= ''
	Local nVcred	:= 0
	Local nVPIS		:= 0
	Local nVCOF		:= 0
	Local nVIRR		:= 0
	Local nVINS		:= 0
	Local nVCSL		:= 0
	Local nValTot:= 0 
	Local nD2PIS:=	0 
	Local nD2COF:=	0
	Local nD2CSL:=	0
	
	SF3->(DbSetOrder(4))
	If SF3->(DbSeek(xFilial("SF3")+cCliente+cLoja+PadR(cNota,TamSx3('F2_DOC')[1])+PadR(cSerie,TamSx3('F2_SERIE')[1])))
		cCFOP := SF3->F3_CFO
	EndIf
    SFT->(DbSetOrder(1))
	SFT->(DbSeek(xFilial("SF3")+'S'+PadR(cSerie,TamSx3('F2_SERIE')[1])+PadR(cNota,TamSx3('F2_DOC')[1])+cCliente+cLoja ))
	
	SD2->(DbSetOrder(3))
	SD2->(DbSeek(xFilial("SD2")+PadR(cNota,TamSx3('F2_DOC')[1])+PadR(cSerie,TamSx3('F2_SERIE')[1])+cCliente+cLoja ))
	
	SA1->(DbSetOrder(1))
	SA1->(DbSeek(xFilial('SA1')+cCliente+cLoja)) 
	
	SF4->(DbSetOrder(1))
	If SF4->(DbSeek(xFilial("SF4")+SD2->D2_TES ))
		cpRedBC := AllTrim(Str(100-SF4->F4_BASEICM))
	Endif
	
	cAliasICM := GetNextAlias()
	cQuery := "SELECT SFT.FT_NFISCAL, SFT.FT_SERIE, SFT.FT_CLASFIS,SD2.D2_TES, " + CRLF
	cQuery += "  MAX(SFT.FT_ALIQICM) FT_ALIQICM, " + CRLF
	cQuery += "	 MAX(SFT.FT_ALIQSOL) FT_ALIQSOL, " + CRLF
	cQuery += "  SUM(SFT.FT_BASEICM) FT_BASEICM, " + CRLF
	cQuery += "  SUM(SFT.FT_BASERET) FT_BASERET, " + CRLF
	cQuery += "  SUM(SFT.FT_VALICM)  FT_VALICM,  " + CRLF
	cQuery += "  SUM(SFT.FT_CRPRST)  FT_CRPRST,  " + CRLF
	cQuery += "  SUM(SFT.FT_ICMSRET) FT_ICMSRET, " + CRLF
	cQuery += "  SUM(SFT.FT_VALPIS) FT_VALPIS, 	 " + CRLF
	cQuery += "  SUM(SFT.FT_VALCOF) FT_VALCOF, 	 " + CRLF
	cQuery += "  SUM(SFT.FT_VALIRR) FT_VALIRR, 	 " + CRLF
	cQuery += "  SUM(SFT.FT_VALINS) FT_VALINS, 	 " + CRLF
	cQuery += "  SUM(SFT.FT_VALCSL) FT_VALCSL, 	 " + CRLF
	cQuery += "  MAX(SD2.D2_ALIQSOL) D2_ALIQSOL, " + CRLF
	cQuery += "  SUM(SD2.D2_BASEICM) D2_BASEICM, " + CRLF 
	cQuery += "  SUM(SD2.D2_VALICM)  D2_VALICM,  " + CRLF
	cQuery += "  MAX(SD2.D2_PICM)  D2_PICM,  " + CRLF
	cQuery += "  SUM(SD2.D2_ICMSRET) D2_ICMSRET,  " + CRLF
	cQuery += "  SUM(SD2.D2_VALPIS) D2_VALPIS,  " + CRLF
	cQuery += "  SUM(SD2.D2_VALCOF) D2_VALCOF,  " + CRLF
	cQuery += "  SUM(SD2.D2_VALCSL) D2_VALCSL  " + CRLF
	cQuery += "  FROM " + RetSqlName('SFT') + " SFT, "+ RetSqlName('SD2') +" SD2   " + CRLF
	cQuery += "  WHERE SFT.FT_FILIAL  = '" + xFilial('SFT') + "'" + CRLF
	cQuery += " AND SFT.FT_NFISCAL = '" + cNota + "'" + CRLF
	cQuery += " AND SFT.FT_SERIE   = '" + cSerie + "'" + CRLF
	cQuery += " AND SFT.FT_CLIEFOR = '" + cCliente + "'" + CRLF
	cQuery += " AND SFT.FT_LOJA    = '" + cLoja + "'" + CRLF
	cQuery += " AND SFT.D_E_L_E_T_ = ' '" + CRLF
	cQuery += " AND SD2.D2_FILIAL  = '" + xFilial('SD2') + "'" + CRLF
	cQuery += " AND SD2.D2_DOC     = SFT.FT_NFISCAL " + CRLF
	cQuery += " AND SD2.D2_SERIE   = SFT.FT_SERIE   " + CRLF
	cQuery += " AND SD2.D2_CLIENTE = SFT.FT_CLIEFOR " + CRLF
	cQuery += " AND SD2.D2_LOJA    = SFT.FT_LOJA    " + CRLF
	cQuery += " AND SD2.D2_ITEM    = SFT.FT_ITEM    " + CRLF
	cQuery += " AND SD2.D_E_L_E_T_ = ' '" + CRLF
	cQuery += " GROUP BY SFT.FT_NFISCAL, SFT.FT_SERIE, SFT.FT_CLASFIS,SD2.D2_TES "
	cQuery := ChangeQuery(cQuery)
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasICM, .F., .T.)
	If !(cAliasICM)->(Eof())
		//Icms + IR + PIS + COFINS + CSLL

		 If (cAliasICM)->FT_VALICM > 0
				nBASEICM := (cAliasICM)->FT_BASEICM
				nALIQICM := (cAliasICM)->FT_ALIQICM
				nVALICM  := (cAliasICM)->FT_VALICM
				nALIQSOL := (cAliasICM)->FT_ALIQSOL
				nICMSRET := (cAliasICM)->FT_ICMSRET
				//nValIcmAux:=
		 Else
				nBASEICM := (cAliasICM)->D2_BASEICM
				nALIQICM := (cAliasICM)->D2_PICM
				nVALICM  := (cAliasICM)->D2_VALICM
				nALIQSOL := (cAliasICM)->D2_ALIQSOL
				nICMSRET := (cAliasICM)->D2_ICMSRET
				SF4->(DbSeek(xFilial("SF4")+(cAliasICM)->D2_TES ))
				nVcred  := (SF4->F4_CRDPRES*(cAliasICM)->D2_VALICM)
		 EndIf 	 
		 nVPIS		:= (cAliasICM)->FT_VALPIS
		 nVCOF		:= (cAliasICM)->FT_VALCOF
		 nVIRR		:= (cAliasICM)->FT_VALIRR
		 nVINS		:= (cAliasICM)->FT_VALINS
		 nVCSL		:= (cAliasICM)->FT_VALCSL  
		 nD2PIS		:= (cAliasICM)->D2_VALPIS 	 
		 nD2COF		:= (cAliasICM)->D2_VALCOF 
		 nD2CSL		:= (cAliasICM)->D2_VALCSL 
		  
		 
		// nValTot := nVALICM + nVIRR + nD2PIS + nD2COF + nD2CSL
		nValTot := nD2PIS + nD2COF + nVALICM + nVINS
		     
    EndIf
    (cAliasICM)->(DbCloseArea())
					

return nValTot

Static Function XmlCTeQrC(cModalidade,cDoc_Chv,cAmbiente)
	Local cTagQRC :=''	
	Local cEstado	:= AllTrim(SM0->M0_ESTENT)
	Local cURLQrc	:= ''	
	
	If  cEstado $ 'AC|AL|AM|BA|CE|DF|ES|GO|MA|PA|PB|PI|RJ|RN|RO|RS|SC|SE|TO'
		If cAmbiente == '2' //HOMOLOGAÇÃO
			cURLQrc := 'https://dfe-portal.svrs.rs.gov.br/cte/qrCode'
		Else
			cURLQrc := 'https://dfe-portal.svrs.rs.gov.br/cte/qrCode'
		EndIf	
	ElseIf cEstado $ 'AP||RR||PE|SP'
		If cAmbiente == '2' //HOMOLOGAÇÃO
			cURLQrc := 'https://homologacao.nfe.fazenda.sp.gov.br/CTeConsulta/qrCode'
		Else
			cURLQrc := 'https://nfe.fazenda.sp.gov.br/CTeConsulta/qrCode'
		EndIf
	ElseIf cEstado $ 'MG'
		If cAmbiente == '2' //HOMOLOGAÇÃO
			cURLQrc := 'https://cte.fazenda.mg.gov.br/portalcte/sistema/qrcode.xhtml'
		Else
			cURLQrc := 'https://cte.fazenda.mg.gov.br/portalcte/sistema/qrcode.xhtml'
		EndIf
	ElseIf cEstado $ 'MS'
		If cAmbiente == '2' //HOMOLOGAÇÃO
			cURLQrc := 'http://www.dfe.ms.gov.br/cte/qrcode'
		Else
			cURLQrc := 'http://www.dfe.ms.gov.br/cte/qrcode'
		EndIf
	ElseIf cEstado $ 'MT'
		If cAmbiente == '2' //HOMOLOGAÇÃO	
			cURLQrc := 'https://homologacao.sefaz.mt.gov.br/cte/qrcode'
		Else
			cURLQrc := 'https://www.sefaz.mt.gov.br/cte/qrcode'
		EndIf
	ElseIf cEstado $ 'PR'
		If cAmbiente == '2' //HOMOLOGAÇÃO		
			cURLQrc := 'http://www.fazenda.pr.gov.br/cte/qrcode'
		Else
			cURLQrc := 'http://www.fazenda.pr.gov.br/cte/qrcode'
		EndIf
	EndIf
	
	If !Empty(cURLQrc)
		If cModalidade=='1'
			cTagQRC +="<infCTeSupl>"
				cTagQRC +=  '<qrCodCTe>'
						//cTagQRC +=  'https://dfe-portal.svrs.rs.gov.br/cte/QRCode?chCTe='+ cDoc_Chv + '&amp;tpAmb=' + cAmbiente
						cTagQRC +=  AllTrim(cURLQrc) + '?chCTe='+ cDoc_Chv + '&amp;tpAmb=' + cAmbiente 
				cTagQRC +=  '</qrCodCTe>'
			cTagQRC +="</infCTeSupl>"
		EndIf
	EndIf	
	 
Return cTagQRC

Static Function RetChvOri(cCliente, cLoja, cNota, cSerie)
Local cAliasTmp := GetNextAlias()
Local cChave 	:= ''

BeginSql Alias cAliasTmp

	SELECT MAX(GZH_CHVCTE) AS GZH_CHVCTE
	FROM %Table:SD2% SD2
	INNER JOIN %Table:GZH% GZH ON GZH.GZH_FILIAL = %xFilial:GZH%
	AND GZH.GZH_NOTA = SD2.D2_NFORI
	AND GZH.GZH_SERIE = SD2.D2_SERIORI
	AND GZH.GZH_CLIENT = SD2.D2_CLIENTE
	AND GZH.GZH_LOJA = SD2.D2_LOJA
	AND GZH.%NotDel%
	WHERE SD2.D2_FILIAL = %xFilial:SD2%
	  AND SD2.D2_CLIENTE = %Exp:cCliente%
	  AND SD2.D2_LOJA = %Exp:cLoja%
	  AND SD2.D2_DOC = %Exp:cNota%
	  AND SD2.D2_SERIE = %Exp:cSerie%
	  AND SD2.%NotDel%

EndSql

If (cAliasTmp)->(!Eof())
	cChave := (cAliasTmp)->GZH_CHVCTE
Endif

(cAliasTmp)->(dbCloseArea())

Return cChave

//-------------------------------------------------------------------
/*/{Protheus.doc} CteQuery
Monta query com os dados da nota 

@param	cAlias,cSerie,cNota,cCliente,cLoja

@return	cQuery

@author  Karyna Morato
@since   19/07/2023
@version 12.1.2210

/*/
//-------------------------------------------------------------------
Static Function CteQuery(cAlias,cSerie,cNota,cCliente,cLoja)

	Local cQuery := 0

	Default cAlias := GetNextAlias()		

	cQuery := "SELECT SFT.FT_NFISCAL, SFT.FT_SERIE, SFT.FT_CLASFIS,SD2.D2_TES, " + CRLF
	cQuery += "  MAX(SFT.FT_ALIQICM) FT_ALIQICM, " + CRLF
	cQuery += "	 MAX(SFT.FT_ALIQSOL) FT_ALIQSOL, " + CRLF
	cQuery += "  SUM(SFT.FT_BASEICM) FT_BASEICM, " + CRLF
	cQuery += "  SUM(SFT.FT_BASERET) FT_BASERET, " + CRLF
	cQuery += "  SUM(SFT.FT_VALICM)  FT_VALICM,  " + CRLF
	cQuery += "  SUM(SFT.FT_CRPRST)  FT_CRPRST,  " + CRLF
	cQuery += "  SUM(SFT.FT_ICMSRET) FT_ICMSRET, " + CRLF
	cQuery += "  SUM(SFT.FT_VALPIS) FT_VALPIS, 	 " + CRLF
	cQuery += "  SUM(SFT.FT_VALCOF) FT_VALCOF, 	 " + CRLF
	cQuery += "  SUM(SFT.FT_VALIRR) FT_VALIRR, 	 " + CRLF
	cQuery += "  SUM(SFT.FT_VALINS) FT_VALINS, 	 " + CRLF
	cQuery += "  SUM(SFT.FT_VALCSL) FT_VALCSL, 	 " + CRLF
	cQuery += "  SUM(SFT.FT_VRETPIS) FT_VRETPIS, " + CRLF
	cQuery += "  SUM(SFT.FT_VRETCOF) FT_VRETCOF, " + CRLF
	cQuery += "  SUM(SFT.FT_VRETCSL) FT_VRETCSL, " + CRLF
	cQuery += "  MAX(SD2.D2_ALIQSOL) D2_ALIQSOL, " + CRLF
	cQuery += "  SUM(SD2.D2_BASEICM) D2_BASEICM, " + CRLF 
	cQuery += "  SUM(SD2.D2_VALICM)  D2_VALICM,  " + CRLF
	cQuery += "  MAX(SD2.D2_PICM)  D2_PICM,  " + CRLF
	cQuery += "  SUM(SD2.D2_ICMSRET) D2_ICMSRET  " + CRLF
	cQuery += "  FROM " + RetSqlName('SFT') + " SFT, "+ RetSqlName('SD2') +" SD2   " + CRLF
	cQuery += "  WHERE SFT.FT_FILIAL  = '" + xFilial('SFT') + "'" + CRLF
	cQuery += " AND SFT.FT_NFISCAL = '" + cNota + "'" + CRLF
	cQuery += " AND SFT.FT_SERIE   = '" + cSerie + "'" + CRLF
	cQuery += " AND SFT.FT_CLIEFOR = '" + cCliente + "'" + CRLF
	cQuery += " AND SFT.FT_LOJA    = '" + cLoja + "'" + CRLF
	cQuery += " AND SFT.D_E_L_E_T_ = ' '" + CRLF
	cQuery += " AND SD2.D2_FILIAL  = '" + xFilial('SD2') + "'" + CRLF
	cQuery += " AND SD2.D2_DOC     = SFT.FT_NFISCAL " + CRLF
	cQuery += " AND SD2.D2_SERIE   = SFT.FT_SERIE   " + CRLF
	cQuery += " AND SD2.D2_CLIENTE = SFT.FT_CLIEFOR " + CRLF
	cQuery += " AND SD2.D2_LOJA    = SFT.FT_LOJA    " + CRLF
	cQuery += " AND SD2.D2_ITEM    = SFT.FT_ITEM    " + CRLF
	cQuery += " AND SD2.D_E_L_E_T_ = ' '" + CRLF
	cQuery += " GROUP BY SFT.FT_NFISCAL, SFT.FT_SERIE, SFT.FT_CLASFIS,SD2.D2_TES "
	cQuery := ChangeQuery(cQuery)

	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAlias, .F., .T.)
	
Return cQuery
