#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TBICONN.CH" 
#include 'parmtype.ch'

Static cFilEnc	:= ""

/*/{Protheus.doc} GTPCTEXML
@author osmar.junior
@since 03/10/2019
@version 1.0
@return ${return}, ${return_description}
@param cSerie, characters, descricao
@param cNota, characters, descricao
@param cClieFor, characters, descricao
@param cLoja, characters, descricao
@type function
/*/
User Function GTPCTEXML(cSerie,cNota,cClieFor,cLoja, cAmbiente, cVerAmb, cModalidade, cTimeZone, cEvento)

	Local nX          := 0
	Local cRet     := ""
	Local cNFe        := ""
	Local cCFOP       := ""


	//-- Inicio das variaveis para CTe //
	Local cQuery      := ''	
	Local cCT         := ''
	Local cChvAcesso  := ''
	Local nCount      := 0
	Local cCodUF      := ''
	Local cSeqEntr    := ''
	Local cObs        := ''
	Local cTpEmis     := ''
	Local cDtCont     := ''
	Local cChvCTG     := ''
	Local lContrib    := .F.
	Local lRedesp     := .F.
	Local nVcred      := 0
	Local nBASEICM    := 0
	Local nBASICMRET  := 0
	Local nCREDPRES   := 0
	Local nALIQICM    := 0
	Local nVALICM     := 0
	Local nALIQSOL    := 0
	Local nICMSRET    := 0
	Local lFecp		:= SF4->(ColumnPos('F4_DIFAL')) > 0
	Local aAreaSM0		:= SM0->(GetArea())
	Local cChvAux := ''
	Local lFind		:= .F.
	Local cEspecie	:= ""
	Local cUFIni 	:=''
	Local cUFFim 	:=''
	
	Local cQualAgen	:= ""
	Private aUF       	:= {}

	If EMPTY(cSerie)
		cSerie := PARAMIXB[1]
	EndIf
	If EMPTY(cNota)
		cNota := PARAMIXB[2]
	EndIf
	If EMPTY(cClieFor)
		cClieFor := PARAMIXB[3]
	EndIf
	If EMPTY(cLoja)
		cLoja := PARAMIXB[4]
	EndIf
	If EMPTY(cAmbiente)
		cAmbiente := PARAMIXB[5]
	EndIf
	If EMPTY(cVerAmb)
		cVerAmb := PARAMIXB[6]
	EndIf
	If EMPTY(cModalidade)
		cModalidade := PARAMIXB[7]
	EndIf
	If EMPTY(cTimeZone)
		cTimeZone := PARAMIXB[8]
	EndIf
	If EMPTY(cEvento)
		cEvento := PARAMIXB[9]
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

	If aScan(aUF,{|x| x[1] ==  AllTrim(SM0->M0_ESTENT) }) != 0 // Confere se Uf do Emitente esta OK
		cCodUF := aUF[ aScan(aUF,{|x| x[1] == AllTrim(SM0->M0_ESTENT) }), 2]
	EndIf
    cSerie  := PadR(cSerie,TamSx3('G99_SERIE')[1])

	dbSelectArea("G99")
	dbSetOrder(2)		//G99_FILIAL+G99_SERIE+G99_NUMDOC
	
	If MsSeek(xFilial("G99")+cSerie+cNota+cEvento)

		cQualAgen := Iif( G99->G99_TOMADO == '0',G99->G99_CODEMI, G99->G99_CODREC)

		cFilEnc := GI6->(GetAdvFVal("GI6",'GI6_FILRES',xFilial("GI6")+cQualAgen,1,IIf(cEvento=="1",XFilial("SF2"),XFilial("SF1"))))

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Posiciona NF                                                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If cEvento == '2' 
			dbSelectArea("SF1")
			dbSetOrder(1)
			//TODO: Efetuar a passagem do segundo param de XFilial com cFilEnc, futuramente
			If  MsSeek(cFilEnc+cNota+cSerie+cClieFor+cLoja)
				lFind := .T.
				cEspecie := SF1->F1_ESPECIE
			Endif
			
		Else
			dbSelectArea("SF2")
			dbSetOrder(1)
			
			If  MsSeek(XFilial("SF2",cFilEnc)+cNota+cSerie+cClieFor+cLoja)
				lFind := .T.
				cEspecie := SF2->F2_ESPECIE
			Endif
			
		Endif
		
		If lFind 
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Tratamento temporario do CTe                                            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

			If (AModNot(cEspecie)=="57")

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Header do Arquivo XML                                           ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

				cRet := InfCteIni(cCodUF, cModalidade, cVerAmb, @cCT , @cChvAux, cEvento )

				cRet += CteIde(cCodUF,cCT,cModalidade, cChvAux,cTimeZone,cAmbiente,cVerAmb, cEvento,@cUFIni,@cUFFim)

				cRet += CTeCompl()

				cRet += CTeEmit()

				cRet += CTeRemet(cAmbiente)

				cRet += CTeReceb(cAmbiente)

				cRet += CTeDest(cAmbiente)

				cRet += TagVPrest(cEvento)

				cRet += TagImp(cEvento,cUFIni,cUFFim)

				cRet += TagCteNorm()

				cRet += CTeCmpl()

				cRet += CTeAnula()

				
				//final
				cRet += InfCteFim(cModalidade,cChvAux,cAmbiente)

			EndIf

		EndIf
	EndIf

	RestArea(aAreaSM0)
	MEMOWRIT('CTE-'+cSerie+cNota+'.XML',cRet)
	
Return( {cChvAux,EncodeUTF8(cRet),cNota,cSerie} )

/*/{Protheus.doc} CTeCmpl
(long_description)
@type  Static Function
@author user
@since 17/10/2019
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/
Static Function CTeCmpl()
	
Local cTagComp := ''

If G99->G99_TIPCTE == '1'
	cTagComp +=	'<infCteComp>'
	cTagComp +=	'<chCTe>' + G99->G99_CHVANT + '</chCTe>'
	cTagComp +=	'</infCteComp>'
EndIf

Return cTagComp

/*/{Protheus.doc} CTeAnula
(long_description)
@type  Static Function
@author user
@since 21/10/2019
@version version
@param param_name, param_type, param_descr
@return cTagComp, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/
Static Function CTeAnula()
	
Local cTagComp := ''
Local cDtEmissao := DTOS(G99->G99_DTEMIS)

If G99->G99_TIPCTE == '2'
	cTagComp +=	'<infCteAnu>'
	cTagComp +=	'<chCte>' + G99->G99_CHVCTE + '</chCte>'
	cTagComp +=	'<dEmi>'  + SubStr(cDtEmissao, 1, 4) + "-";
				+ SubStr(cDtEmissao, 5, 2) + "-";
				+ SubStr(cDtEmissao, 7, 2) + '</dEmi>'
	cTagComp +=	'</infCteAnu>'
EndIf

Return cTagComp

/*/{Protheus.doc} CTeSubst
(long_description)
@type  Static Function
@author user
@since 21/10/2019
@version version
@param param_name, param_type, param_descr
@return cTagComp, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/
Static Function CTeSubst()
	
Local cTagComp := ''

If G99->G99_TIPCTE == '3'
	cTagComp +=	'<infCteSub>'
	cTagComp +=	'<chCte>' + G99->G99_CHVANT + '</chCte>'
	cTagComp +=	'<refCteAnu>' + G99->G99_CHVANU + '</refCteAnu>'
	cTagComp +=	'</infCteSub>'
EndIf

Return cTagComp

/*/{Protheus.doc} ConvType
@author osmar.junior
@since 03/10/2019
@version 1.0
@return ${return}, ${return_description}
@param xValor, , descricao
@param nTam, numeric, descricao
@param nDec, numeric, descricao
@param lInt, logical, descricao
@type function
/*/
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

/*/{Protheus.doc} Inverte
@author osmar.junior
@since 03/10/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function Inverte()

	Local cRet := ""

	cRet := Alltrim(Str(Randomize( 10000000, 99999999 )))

Return(cRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ CTeCHVAC ³       ³                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao responsavel em montar a Chave de Acesso             ³±±
±±³          ³ a SEFAZ e calcular o seu digito verIficador.               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CTeCHVAC(cUF, cAAMM, cCNPJ, cMod, cSerie, nCT, cCT)        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cUF...: Codigo da UF                                       ³±±
±±³          ³ cAAMM.: Ano (2 Digitos) + Mes da Emissao do CTe            ³±±
±±³          ³ cCNPJ.: CNPJ do Emitente do CTe                            ³±±
±±³          ³ cMod..: Modelo (57 = CTe)                                  ³±±
±±³          ³ cSerie: Serie do CTe                                       ³±±
±±³          ³ nCT...: Numero do CTe                                      ³±±
±±³          ³ cCT...: Numero do Lote de Envio a SEFAZ                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Explicacao do Calculo se encontra no manual do CT-e        ³±±
±±³          ³ disponibilizado pela SEFAZ na versao atual 1.02,           ³±±
±±³          ³ pag: 77 e 78                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CTeCHVAC(cUF, cAAMM, cCNPJ, cMod, cSerie, nCT, cCT)
Local nCount      := 0
Local nSequenc    := 2
Local nPonderacao := 0
Local cResult     := ''
Local cChvAcesso  := cUF +  cAAMM + cCNPJ + cMod + cSerie + nCT + cCT

// A partir da versão 1.04 do leiaute do CT-e, o campo tpEmis (forma de emissão da CT-e) passou
// a compor a chave de acesso da seguinte forma:
// O tamanho do campo cCT – código numérico do CT-e –foi reduzido para oito posiçõespara não
// alterar o tamanho da chave de acesso do CT-e de 44 posições que passa sercomposta pelos
// seguintes campos que se encontram dispersos no CT-e :
// cUF    - Codigo da UF do emitente do Documento Fiscal
// AAMM   - Ano (2 Digitos) e Mes de emissão do CT-e
// CNPJ   - CNPJ do emitente
// mod    - Modelo do Documento Fiscal (57 = CTe)
// serie  - Serie do Documento Fiscal
// nCT    - Numero do Documento Fiscal
// tpEmis - Forma de emissão do CT-e
// cCT    - Codigo Numurico que compoe a Chave de Acesso
// cDV    - Digito Verificador da Chave de Acesso

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

/*/{Protheus.doc} NoPontos
@author osmar.junior
@since 03/10/2019
@version 1.0
@return ${return}, ${return_description}
@param cString, characters, descricao
@type function
/*/
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
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ CTeCHCTG ³Autor  ³             ³ Data ³³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao responsavel em montar a Chave de Acesso auxiliar    ³±±
±±³          ³ a SEFAZ e calcular o seu digito verIficador.               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CTeCHCTG(cUF, tpEmis,CNPJ,VCT,ICMSp,ICMSs,DD)              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³- cUF    - 02 = Código da UF                                ³±±
±±³          ³- tpEmis - 01 = Forma de Emissão                            ³±±
±±³          ³- CNPJ   - 14 = CNPJ do destinatário                        ³±±
±±³          ³- vCT    - 14 = Valor Total do Serviço                      ³±±
±±³          ³- ICMSp  - 01 = Destaque de ICMS próprio                    ³±±
±±³          ³- ICMSs  - 01 = Destaque de ICMS por substituição tributária³±±
±±³          ³- DD     - 02 = Dia da emissão                              ³±±
±±³          ³- DV     - 01 = Dígito Verificador                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Explicacao do Calculo se encontra no manual do CT-e        ³±±
±±³          ³ disponibilizado pela SEFAZ na versao atual 1.02,           ³±±
±±³          ³ pag: 77 e 78                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CTeCHCTG(cUF,tpEmis,cCNPJ, cvCT, cICMSp, cICMSs, cDD)
Local nCount      := 0
Local nSequenc    := 2
Local nPonderacao := 0
Local cResult     := ''
Local cChvCTG  := cUF +  tpEmis + cCNPJ + cvCT + cICMSp + cICMSs + cDD

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³SEQUENCIA DE MULTIPLICADORES (nSequenc), SEGUE A SEGUINTE        ³
//³ORDENACAO NA SEQUENCIA: 2,3,4,5,6,7,8,9,2,3,4... E PRECISA SER   ³
//³GERADO DA DIREITA PARA ESQUERDA, SEGUINDO OS CARACTERES          ³
//³EXISTENTES NA CHAVE DE ACESSO INFORMADA (cChvAcesso)             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nCount := Len( AllTrim(cChvCTG) ) To 1 Step -1
	nPonderacao += ( Val( SubStr( AllTrim(cChvCTG), nCount, 1) ) * nSequenc )
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
	cResult := (cChvCTG + cValToChar( (11 - mod(nPonderacao,11) ) ) )
	Else
	cResult := (cChvCTG + '0')
	EndIf

Return(cResult)



/*/{Protheus.doc} CTeToma
@author osmar.junior
@since 03/10/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function CTeToma(cAmbiente)

	Local cRet 		:= ""
	Local cIEToma		:= ""

	//| Tomador
	//| 1=Remetente;2=Destinatario;3=Consignatario;4=Despachante;6=Expedidor;7=Recebedor
	//+---------------------------------------------------------------------------

	SA1->(DbSetOrder(1))


	If G99->G99_TOMADO == '0' //REMETENTE
		SA1->(dbSeek(xFilial('SA1') + G99->(G99_CLIREM + G99_LOJREM)))
	ElseIf G99->G99_TOMADO == '3' //DESTINATARIO
		SA1->(dbSeek(xFilial('SA1') + G99->(G99_CLIDES + G99_LOJDES)))
	EndIf

	If SA1->A1_CONTRIB <> "2" .and. !Empty(SA1->A1_INSCR)
		If "ISENT" $ Upper(Alltrim(SA1->A1_INSCR))
				cIEToma := "2" //2-Contribuinte isento de inscrição;
			Else
				cIEToma := "1" //1-Contribuinte ICMS;
			EndIf
	Else
		cIEToma := "9" //9-Não Contribuinte
	EndIf

	cRet += '<indIEToma>' + cIEToma + '</indIEToma>'

	cRet += '<toma3>'
	cRet += '<toma>' + G99->G99_TOMADO + '</toma>'   //0=Remetente;3=Destinatario
	cRet += '</toma3>'
	

	If cIEToma == 'x'	
		cRet += '<toma4>'			
		
		cRet += '<toma>4</toma4>'
		
		If (AllTrim(SA1->A1_PESSOA) == "J")
			cRet += '<CNPJ>' + NoAcentoCte( SA1->A1_CGC ) + '</CNPJ>'
		Else
			cRet += '<CPF>'  + NoAcentoCte( SA1->A1_CGC ) + '</CPF>'
		EndIf
	
		//-- Conf. MOC 3.00a, tag IE: Caso o tomador não seja contribuinte do ICMS não informar o conteúdo. 
		If SA1->A1_CONTRIB =='1'
			If Empty(SA1->A1_INSCR) .Or. 'ISENT' $ Upper(AllTrim(SA1->A1_INSCR)) .Or. ( SA1->A1_CONTRIB =='1' .And. 'ISENT' $ Upper(AllTrim(SA1->A1_INSCR)))
				cRet += '<IE>ISENTO</IE>'
			Else
				cRet += '<IE>' + NoPontos(SA1->A1_INSCR) + '</IE>'
			EndIf
		EndIf
	
		If cAmbiente == '2'  //--Homologacao / Nota T?nica 2012/005
			cRet += '<xNome>' + (SubStr('CT-E EMITIDO EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL',1,60)) + '</xNome>'
		Else
			cRet += '<xNome>' + NoAcentoCte(SubStr(SA1->A1_NOME,1,60)) + '</xNome>'
		EndIf
		cRet += '<enderToma>'
		cRet += '<xLgr>' + NoAcentoCte(Alltrim(FisGetEnd(SA1->A1_END)[1])) + '</xLgr>'
		cRet += '<nro>' + Iif(FisGetEnd(SA1->A1_END)[2]<>0, AllTrim(cValtoChar( FisGetEnd(SA1->A1_END)[2])),"S/N") + '</nro>'
		If !Empty(NoAcentoCte(FisGetEnd(SA1->A1_END)[4]))
			cRet += '<xCpl>' + NoAcentoCte(Alltrim(FisGetEnd(SA1->A1_END)[4])) + '</xCpl>'
		EndIf
		If Empty(AllTrim(SA1->A1_BAIRRO))
			cRet += '<xBairro>BAIRRO NAO CADASTRADO</xBairro>'
		Else
			cRet += '<xBairro>' + NoAcentoCte(Alltrim(SA1->A1_BAIRRO))+ '</xBairro>'
		EndIf
		cRet += '<cMun>' + Alltrim(str(Val(GetDadosUf(SA1->A1_EST,1,2)+ SA1->A1_COD_MUN))) + '</cMun>'
		cRet += '<xMun>' + NoAcentoCte(Alltrim(SA1->A1_MUN)) + '</xMun>'
		cRet += '<CEP>'  + NoPontos(SA1->A1_CEP)    + '</CEP>'
		cRet += '<UF>'   + SA1->A1_EST + '</UF>'
		cRet += '</enderToma>'
		If !Empty(SA1->A1_EMAIL)
	    	cRet += '<email>' + NoAcentoCte(Alltrim(SA1->A1_EMAIL)) + '</email>'
		Endif
		
		
		cRet += '</toma4>'
	EndIf
	
	
Return(cRet)


/*/{Protheus.doc} CTeCompl
//TODO Descrição auto-gerada.
@author osmar.junior
@since 03/10/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function CTeCompl()
	Local cRet := ''
	Local cTxtObs:=''
	
	//TAG: Dados complementares do CT-e
	
	If !Empty(G99->G99_OBSERV) 
		cRet := '<compl>'
		//-- Observacoes Gerais
		If !Empty(G99->G99_OBSERV)
			cRet += '<xObs>' + NoAcentoCte(SubStr(G99->G99_OBSERV,1,601)) + '</xObs>'
		EndIf
		//-- Observacoes Contribuintes - Uso exclusivo do emissor CT-E
		If SF2->F2_TOTIMP > 0
			cTxtObs := 'O valor aproximado de tributos incidentes sobre o preco deste servico e de R$ ' + PADL(Transform(SF2->F2_TOTIMP,'@E 999,999.99'),20)
			cRet +=  '<ObsCont xCampo="LeidaTransparencia">'
			cRet +=    '<xTexto>'+cTxtObs+'</xTexto>'
			cRet +=  '</ObsCont>'
			cRet += '</compl>'			
		Else
			cRet += '</compl>'	
		EndIf
	EndIf

return cRet


/*/{Protheus.doc} CTeEmit
//TODO Descrição auto-gerada.
@author osmar.junior
@since 03/10/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function CTeEmit()
Local cRet := ''
	
	//l TAG: Emitente do CT-e
	
	cRet := '<emit>'
	cRet += '<CNPJ>' + NoPontos(SM0->M0_CGC) + '</CNPJ>' 
	
	If (AllTrim(SM0->M0_INSC) == 'ISENTO')
		cRet += '<IE>ISENTO</IE>'
	Else
		cRet += '<IE>' + NoPontos(SM0->M0_INSC) + '</IE>'
	EndIf
	
	//Inscrição Estadual do Substituto Tributário
	//cRet += '<IEST>' + NoPontos(cSubTrib) + '</IEST>'		
	  
	
	cRet += '<xNome>' + NoAcentoCte(SubStr(SM0->M0_NOMECOM,1,60)) + '</xNome>'
	cRet += '<xFant>' + NoAcentoCte(SM0->M0_NOME) + '</xFant>'
	cRet += '<enderEmit>'
	cRet += '<xLgr>' + NoAcentoCte(FisGetEnd(SM0->M0_ENDENT)[1]) + '</xLgr>'
	cRet += '<nro>'  + Iif(FisGetEnd(SM0->M0_ENDENT)[2]<>0, AllTrim(cValtoChar( FisGetEnd(SM0->M0_ENDENT)[2])),"S/N") + '</nro>'
	If !Empty(NoAcentoCte(FisGetEnd(SM0->M0_ENDENT)[4]))
		cRet += '<xCpl>' + NoAcentoCte(FisGetEnd(SM0->M0_ENDENT)[4]) + '</xCpl>'
	EndIf
	If Empty(AllTrim(SM0->M0_BAIRENT))
		cRet += '<xBairro>BAIRRO NAO CADASTRADO</xBairro>'
	Else
		cRet += '<xBairro>' + NoAcentoCte( SM0->M0_BAIRENT ) + '</xBairro>'
	EndIf
	
	cRet += '<cMun>' + NoAcentoCte( SM0->M0_CODMUN ) + '</cMun>'
	cRet += '<xMun>' + NoAcentoCte( SM0->M0_CIDENT ) + '</xMun>'
	cRet += '<CEP>'  + NoAcentoCte( SM0->M0_CEPENT ) + '</CEP>'
	cRet += '<UF>'   + NoAcentoCte( SM0->M0_ESTENT ) + '</UF>'
	If !Empty (NoPontos(SM0->M0_TEL))
		cRet += '<fone>' + cValtoChar(NoPontos(SM0->M0_TEL)) + '</fone>'
	EndIf
	cRet += '</enderEmit>'
	cRet += '</emit>'
					
Return cRet


/*/{Protheus.doc} CTeRemet
//TODO Descrição auto-gerada.
@author osmar.junior
@since 03/10/2019
@version 1.0
@return ${return}, ${return_description}
@param cAmbiente, characters, descricao
@type function
/*/
Static Function CTeRemet(cAmbiente)
	Local cRet := ''
		
	SA1->(dbSeek(xFilial('SA1') + G99->(G99_CLIREM + G99_LOJREM)))
	
	cRet += '<rem>'
								
	If (AllTrim(SA1->A1_PESSOA) == "J")
		cRet += '<CNPJ>' + IIf(SA1->A1_EST <> 'EX',NoAcentoCte( SA1->A1_CGC  ),StrZero(0,14) ) + '</CNPJ>'
		If SA1->A1_CONTRIB =='1'
			If Empty(SA1->A1_INSCR) .Or. 'ISENT' $ Upper(AllTrim(SA1->A1_INSCR)) .Or. ( SA1->A1_CONTRIB =='1' .And. 'ISENT' $ Upper(AllTrim(SA1->A1_INSCR)))
				cRet += '<IE>ISENTO</IE>'
			Else
				cRet += '<IE>' + NoPontos(SA1->A1_INSCR) + '</IE>'
			EndIf
		Else						
			If 'ISENT' $ Upper(NoAcentoCte( SA1->A1_INSCR ))
				//cRet += '<IE>ISENTO</IE>'
			ElseIf !Empty(SA1->A1_INSCR)
				cRet += '<IE>' + NoPontos(SA1->A1_INSCR) + '</IE>'
			EndIf
		EndIf
	Else
		cRet += '<CPF>' + IIf(SA1->A1_EST <> 'EX',NoAcentoCte( SA1->A1_CGC  ),StrZero(0,14) ) + '</CPF>'				
	EndIf
		
	If cAmbiente == '2'  //--Homologacao / Nota T?nica 2012/005
		cRet += '<xNome>' + (SubStr('CT-E EMITIDO EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL',1,60)) + '</xNome>'
	Else
		cRet += '<xNome>' + NoAcentoCte(SubStr(SA1->A1_NOME,1,60)) + '</xNome>'
	EndIf
	//cRet += '<xFant>' + NoAcentoCte(SA1->A1_NREDUZ) + '</xFant>'
	If !Empty(SA1->A1_TEL)
		cRet += '<fone>' + cValtoChar(NoPontos(SA1->A1_DDD)) + cValtoChar(NoPontos(SA1->A1_TEL)) + '</fone>'
	EndIf
		
	cRet += '<enderReme>'
	cRet += '<xLgr>' +NoAcentoCte(Alltrim(FisGetEnd(SA1->A1_END)[1]))  + '</xLgr>'
	cRet += '<nro>' + Iif(FisGetEnd(SA1->A1_END)[2]<>0, AllTrim(cValtoChar( FisGetEnd(SA1->A1_END)[2])),"S/N")  + '</nro>'
	
	If !Empty(NoAcentoCte(FisGetEnd(SA1->A1_END)[4]))
		cRet += '<xCpl>' +  NoAcentoCte(Alltrim(FisGetEnd(SA1->A1_END)[4]))+ '</xCpl>'
	EndIf
	If Empty(AllTrim(SA1->A1_BAIRRO))
		cRet += '<xBairro>BAIRRO NAO CADASTRADO</xBairro>'
	Else
		cRet += '<xBairro>' + NoAcentoCte(Alltrim(SA1->A1_BAIRRO))+ '</xBairro>'
	EndIf
	
	cRet += '<cMun>' + Alltrim(str(Val(GetDadosUf(SA1->A1_EST,1,2)+ SA1->A1_COD_MUN))) + '</cMun>'
	cRet += '<xMun>' + NoAcentoCte(Alltrim(SA1->A1_MUN)) + '</xMun>'
	cRet += '<CEP>'  + NoPontos(SA1->A1_CEP)    + '</CEP>'
	cRet += '<UF>'   + SA1->A1_EST + '</UF>'
	
	If !Empty(AllTrim(SA1->A1_PAIS))
		cRet += '<cPais>'+ NoAcentoCte( SA1->A1_PAIS ) + '</cPais>'
		cRet += '<xPais>'+ NoAcentoCte( Posicione("SYA",1,xFilial("SYA")+SA1->A1_PAIS,"YA_DESCR") ) + '</xPais>'
	EndIf
	
	cRet += '</enderReme>'
	If !Empty(SA1->A1_EMAIL)
    	cRet += '<email>' + NoAcentoCte(Alltrim(SA1->A1_EMAIL)) + '</email>'
	Endif
    
	cRet += '</rem>'							

Return cRet 

/*/{Protheus.doc} CTeDest
//TODO Descrição auto-gerada.
@author osmar.junior
@since 03/10/2019
@version 1.0
@return ${return}, ${return_description}
@param cAmbiente, characters, descricao
@type function
/*/
Static Function CTeDest(cAmbiente)
	Local cRet:=''

	SA1->(dbSeek(xFilial('SA1') + G99->(G99_CLIDES + G99_LOJDES)))
					
	cRet := '<dest>'
	If (AllTrim(SA1->A1_PESSOA) == "J")
		cRet += '<CNPJ>' + Iif(SA1->A1_EST <> 'EX', NoPontos(SA1->A1_CGC), '00000000000000') + '</CNPJ>'
		If SA1->A1_CONTRIB == '1'
			If 'ISENT' $ Upper(SA1->A1_INSCR)
				cRet += '<IE>ISENTO</IE>'
			Else
				cRet += '<IE>' + NoPontos(SA1->A1_INSCR) + '</IE>'
			EndIf
		Else
			If 'ISENT' $ Upper(NoAcentoCte( SA1->A1_INSCR ))
				//cRet += '<IE>ISENTO</IE>'
			ElseIf !Empty(SA1->A1_INSCR)
				cRet += '<IE>' + NoPontos(SA1->A1_INSCR) + '</IE>'
			EndIf
		EndIf
	Else
		cRet += '<CPF>' + Iif(SA1->A1_EST <> 'EX', NoAcentoCte( SA1->A1_CGC ), '00000000000') + '</CPF>'		
	EndIf
	
	

	If cAmbiente == '2'  //--Homologacao / Nota T?nica 2012/005
		cRet += '<xNome>' + (SubStr('CT-E EMITIDO EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL',1,60)) + '</xNome>'
	Else
		cRet += '<xNome>' + NoAcentoCte(SubStr(SA1->A1_NOME,1,60)) + '</xNome>'	
	EndIf
	
	If !Empty(SA1->A1_TEL)
		cRet += '<fone>' + cValtoChar(NoPontos(SA1->A1_DDD)) + 	cValtoChar(NoPontos(SA1->A1_TEL)) + '</fone>'
	EndIf
	
	cRet += '<enderDest>'
	cRet += '<xLgr>' + NoAcentoCte(Alltrim(FisGetEnd(SA1->A1_END)[1]))+ '</xLgr>'
	cRet += '<nro>' + Iif(FisGetEnd(SA1->A1_END)[2]<>0, AllTrim(cValtoChar( FisGetEnd(SA1->A1_END)[2])),"S/N")  + '</nro>'
	
	If !Empty(NoAcentoCte(FisGetEnd(SA1->A1_END)[4]))
		cRet += '<xCpl>' +  NoAcentoCte(Alltrim(FisGetEnd(SA1->A1_END)[4]))+ '</xCpl>'
	EndIf
	If Empty(AllTrim(SA1->A1_BAIRRO))
		cRet += '<xBairro>BAIRRO NAO CADASTRADO</xBairro>'
	Else
		cRet += '<xBairro>' + NoAcentoCte(Alltrim(SA1->A1_BAIRRO))+ '</xBairro>'
	EndIf
	
	cRet += '<cMun>' + Alltrim(str(Val(GetDadosUf(SA1->A1_EST,1,2)+ SA1->A1_COD_MUN))) + '</cMun>'
	cRet += '<xMun>' + NoAcentoCte(Alltrim(SA1->A1_MUN)) + '</xMun>'
	cRet += '<CEP>'  + NoPontos(SA1->A1_CEP)    + '</CEP>'
	cRet += '<UF>'   + SA1->A1_EST + '</UF>'
	
	If !Empty(AllTrim(SA1->A1_PAIS))
		cRet += '<cPais>'+ NoAcentoCte( SA1->A1_PAIS ) + '</cPais>'
		cRet += '<xPais>'+ NoAcentoCte( Posicione("SYA",1,xFilial("SYA")+SA1->A1_PAIS,"YA_DESCR") ) + '</xPais>'
	EndIf
	
	cRet += '</enderDest>'
	
	If !Empty(SA1->A1_EMAIL)
    	cRet += '<email>' + NoAcentoCte(Alltrim(SA1->A1_EMAIL)) + '</email>'
	Endif
					
	//-- Strings incluidas para envio de email para tomador.
	//-- Necessario incluir SPED_DELMAIL=1 no SERVER.INI do TSS/SPED
	//-- para excluir este conteudo do arquivo XML final.
	If !Empty(SA1->A1_EMAIL)
		cRet += '[EMAIL=' + SA1->A1_EMAIL + ']'
	EndIf
	
	cRet += '</dest>'
					

Return cRet


/*/{Protheus.doc} CTeReceb
//TODO Descrição auto-gerada.
@author osmar.junior
@since 03/10/2019
@version 1.0
@return ${return}, ${return_description}
@param cAmbiente, characters, descricao
@type function
/*/
Static Function CTeReceb(cAmbiente)
	Local cRet := ''
	Local aAreaSM0 
	Local cEmpBkp 
	Local cFilBkp
	Local cFilAgRec := Posicione( "GI6", 1, xFilial('GI6') + G99->G99_CODREC , 'GI6_FILRES')

	dbSelectArea("SM0")
	aAreaSM0 := SM0->(GetArea())
	cEmpBkp := SM0->M0_CODIGO //Guardo a empresa atual
	cFilBkp := SM0->M0_CODFIL //Guardo a filial atual

	OpenSM0() //Abrir Tabela SM0 (Empresa/Filial)	
	SM0->(dbSetOrder(1))
	SM0->(dbSeek(cEmpBkp + cFilAgRec,.T.)) //Posiciona Empresa

	cRet := '<receb>'
	cRet += '<CNPJ>' + NoPontos(SM0->M0_CGC) + '</CNPJ>' 
	
	If (AllTrim(SM0->M0_INSC) == 'ISENTO')
		cRet += '<IE>ISENTO</IE>'
	Else
		cRet += '<IE>' + NoPontos(SM0->M0_INSC) + '</IE>'
	EndIf
	
	//Inscriçao Estadual do Substituto Tributário
	//cRet += '<IEST>' + NoPontos(cSubTrib) + '</IEST>'		
	If cAmbiente == '2'  //--Homologacao / Nota T?nica 2012/005
		cRet += '<xNome>' + (SubStr('CT-E EMITIDO EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL',1,60)) + '</xNome>'
	Else  	
		cRet += '<xNome>' + NoAcentoCte(SubStr(SM0->M0_NOMECOM,1,60)) + '</xNome>'
	EndIf
	
	cRet += '<enderReceb>'
	cRet += '<xLgr>' + NoAcentoCte(FisGetEnd(SM0->M0_ENDENT)[1]) + '</xLgr>'
	cRet += '<nro>'  + Iif(FisGetEnd(SM0->M0_ENDENT)[2]<>0, AllTrim(cValtoChar( FisGetEnd(SM0->M0_ENDENT)[2])),"S/N") + '</nro>'
	If !Empty(NoAcentoCte(FisGetEnd(SM0->M0_ENDENT)[4]))
		cRet += '<xCpl>' + NoAcentoCte(FisGetEnd(SM0->M0_ENDENT)[4]) + '</xCpl>'
	EndIf
	If Empty(AllTrim(SM0->M0_BAIRENT))
		cRet += '<xBairro>BAIRRO NAO CADASTRADO</xBairro>'
	Else
		cRet += '<xBairro>' + NoAcentoCte( SM0->M0_BAIRENT ) + '</xBairro>'
	EndIf
	
	cRet += '<cMun>' + NoAcentoCte( SM0->M0_CODMUN ) + '</cMun>'
	cRet += '<xMun>' + NoAcentoCte( SM0->M0_CIDENT ) + '</xMun>'
	cRet += '<CEP>'  + NoAcentoCte( SM0->M0_CEPENT ) + '</CEP>'
	cRet += '<UF>'   + NoAcentoCte( SM0->M0_ESTENT ) + '</UF>'
	cRet += '</enderReceb>'
	cRet += '</receb>'

	SM0->(RestArea(aAreaSM0)) //Restaura Tabela
	SM0->(dbSeek(cEmpBkp + cFilBkp,.T.)) //Posiciona Empresa
	cEmpAnt := cEmpBkp  //Restaura variaveis de ambiente
	cFilAnt := cFilBkp //Restaura variaveis de ambiente

Return cRet

/*/{Protheus.doc} TagVPrest
//TODO Descrição auto-gerada.
@author osmar.junior
@since 03/10/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function TagVPrest(cEvento)
	Local cRet := ''
	
	cRet := '<vPrest>'
	If cEvento <> '2'
		cRet += '<vTPrest>' + ConvType(SF2->F2_VALMERC, 15, 2) + '</vTPrest>'
	Else
		cRet += '<vTPrest>' + ConvType(SF1->F1_VALMERC, 15, 2) + '</vTPrest>'
	Endif
	
	If G99->G99_TIPCTE == '1'
		cRet += '<vRec>'    + ConvType(G99->G99_COMPVL, 15, 2) + '</vRec>'
	Else
	cRet += '<vRec>'    + ConvType(G99->G99_VALOR, 15, 2) + '</vRec>'
	EndIf
	If !Empty(G99->G99_PESO)
		cRet +='<Comp>'
		cRet += '<xNome>FRETE PESO</xNome>'
		cRet += '<vComp>' + ConvType(G99->G99_PESO, 15, 2) + '</vComp>'	
		cRet +='</Comp>'
	EndIf
	If !Empty(G99->G99_PESCUB)
		cRet +='<Comp>'
		cRet += '<xNome>PESO CUBADO</xNome>'
		cRet += '<vComp>' + ConvType(G99->G99_PESCUB, 15, 2) + '</vComp>'	
		cRet +='</Comp>'
	EndIf
	If !Empty(G99->G99_QTDVO)
		cRet +='<Comp>'
		cRet += '<xNome>QTDE VOLUME</xNome>'
		cRet += '<vComp>' + ConvType(G99->G99_QTDVO, 15, 2) + '</vComp>'	
		cRet +='</Comp>'
	EndIf
	
	cRet += '</vPrest>'
			

Return cRet

/*/{Protheus.doc} TagImp
//TODO Descrição auto-gerada.
@author osmar.junior
@since 03/10/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function TagImp(cEvento,cUFIni,cUFFim)
	Local cRet := ''
	Local cAliasTagJ := ''	
	Local cQuery := ''
	Local nBASEICM := 0
	Local nALIQICM := 0
	Local nVALICM  := 0
	Local nALIQSOL := 0
	Local nICMSRET := 0
	Local nCREDPRES := 0	
	Local nCount := 0
	Local cMVSINAC 	:= SuperGetMv("MV_CODREG")
	Local cObs := ''
	Local cInterCons    := ''

	//Para tipo (Normal,Complemento e substituição)	//
	//Destinatário não contribuinte e Tomador diferente de remetente e não contribuinte (indIEToma=9) 
	//Geração das TAGS (ICMSUFFim) quando: 
			//A1_CONTRIB == '2' 		//NAO CONTRIBUINTE
			//F4_DIFAL == "1"			//Calcula Difal ICMS 
			//F4_COMPL == "S"			//Calcula Dif. Icm ? 
	If cUFIni<>cUFFim .AND. G99->G99_TOMADO=='3' .AND. cEvento <> '2'
		cInterCons  := InterCons(SF2->F2_CLIENTE,SF2->F2_LOJA,SF2->F2_DOC,SF2->F2_SERIE)
	EndIf	

	cAliasTagJ := GetNextAlias()
	
	If cEvento <> '2'
		cQuery := "SELECT SFT.FT_NFISCAL, SFT.FT_SERIE, SFT.FT_CLASFIS, " + CRLF
		cQuery += "  MAX(SFT.FT_ALIQICM) FT_ALIQICM, " + CRLF
		cQuery += "	 MAX(SFT.FT_ALIQSOL) FT_ALIQSOL, " + CRLF
		cQuery += "  SUM(SFT.FT_BASEICM) FT_BASEICM, " + CRLF
		cQuery += "  SUM(SFT.FT_BASERET) FT_BASERET, " + CRLF
		cQuery += "  SUM(SFT.FT_VALICM)  FT_VALICM,  " + CRLF
		cQuery += "  SUM(SFT.FT_CRPRST)  FT_CRPRST,  " + CRLF
		cQuery += "  SUM(SFT.FT_ICMSRET) FT_ICMSRET, " + CRLF
		cQuery += "  MAX(SD2.D2_ALIQSOL) ALIQSOL, " + CRLF
		cQuery += "  SUM(SD2.D2_BASEICM) BASEICM, " + CRLF 
		cQuery += "  SUM(SD2.D2_VALICM)  VALICM,  " + CRLF
		cQuery += "  MAX(SD2.D2_PICM)    PICM,  " + CRLF
		cQuery += "  SUM(SD2.D2_ICMSRET) ICMSRET  " + CRLF
		cQuery += "  FROM " + RetSqlName('SFT') + " SFT, "+ RetSqlName('SD2') +" SD2   " + CRLF
		cQuery += "  WHERE SFT.FT_FILIAL  = '" + xFilial('SFT',cFilEnc) + "'" + CRLF
		cQuery += " AND SFT.FT_NFISCAL = '" + SF2->F2_DOC   + "'" + CRLF
		cQuery += " AND SFT.FT_SERIE   = '" + SF2->F2_SERIE + "'" + CRLF					
		cQuery += " AND SFT.FT_CLIEFOR = '" + SF2->F2_CLIENTE + "'" + CRLF
		cQuery += " AND SFT.FT_LOJA    = '" + SF2->F2_LOJA + "'" + CRLF
		cQuery += " AND SFT.D_E_L_E_T_ = ' '" + CRLF
		cQuery += " AND SD2.D2_FILIAL  = '" + xFilial('SD2',cFilEnc) + "'" + CRLF
		cQuery += " AND SD2.D2_DOC   = SFT.FT_NFISCAL " + CRLF
		cQuery += " AND SD2.D2_SERIE = SFT.FT_SERIE   " + CRLF				
		cQuery += " AND SD2.D2_CLIENTE = SFT.FT_CLIEFOR " + CRLF
		cQuery += " AND SD2.D2_LOJA    = SFT.FT_LOJA    " + CRLF
		cQuery += " AND SD2.D2_ITEM    = SFT.FT_ITEM    " + CRLF
		cQuery += " AND SD2.D_E_L_E_T_ = ' '" + CRLF
		cQuery += " GROUP BY SFT.FT_NFISCAL, SFT.FT_SERIE, SFT.FT_CLASFIS "
		cQuery += " ORDER BY SFT.FT_NFISCAL, SFT.FT_SERIE, SFT.FT_CLASFIS "
	Else //TODO: Ajustar, futuramente a chamada de xFilial com a passagem do segundo parâmetro cFilEnc
		cQuery := "SELECT SFT.FT_NFISCAL, SFT.FT_SERIE, SFT.FT_CLASFIS, " + CRLF
		cQuery += "  MAX(SFT.FT_ALIQICM) FT_ALIQICM, " + CRLF
		cQuery += "	 MAX(SFT.FT_ALIQSOL) FT_ALIQSOL, " + CRLF
		cQuery += "  SUM(SFT.FT_BASEICM) FT_BASEICM, " + CRLF
		cQuery += "  SUM(SFT.FT_BASERET) FT_BASERET, " + CRLF
		cQuery += "  SUM(SFT.FT_VALICM)  FT_VALICM,  " + CRLF
		cQuery += "  SUM(SFT.FT_CRPRST)  FT_CRPRST,  " + CRLF
		cQuery += "  SUM(SFT.FT_ICMSRET) FT_ICMSRET, " + CRLF
		cQuery += "  MAX(SD1.D1_ALIQSOL) ALIQSOL, " + CRLF
		cQuery += "  SUM(SD1.D1_BASEICM) BASEICM, " + CRLF 
		cQuery += "  SUM(SD1.D1_VALICM)  VALICM,  " + CRLF
		cQuery += "  MAX(SD1.D1_PICM)    PICM,  " + CRLF
		cQuery += "  SUM(SD1.D1_ICMSRET) ICMSRET  " + CRLF
		cQuery += "  FROM " + RetSqlName('SFT') + " SFT, "+ RetSqlName('SD1') +" SD1   " + CRLF
		cQuery += "  WHERE SFT.FT_FILIAL  = '" + xFilial('SFT') + "'" + CRLF
		cQuery += " AND SFT.FT_NFISCAL = '" + SF1->F1_DOC   + "'" + CRLF
		cQuery += " AND SFT.FT_SERIE   = '" + SF1->F1_SERIE + "'" + CRLF					
		cQuery += " AND SFT.FT_CLIEFOR = '" + SF1->F1_FORNECE + "'" + CRLF
		cQuery += " AND SFT.FT_LOJA    = '" + SF1->F1_LOJA + "'" + CRLF
		cQuery += " AND SFT.D_E_L_E_T_ = ' '" + CRLF
		cQuery += " AND SD1.D1_FILIAL  = '" + xFilial('SD1') + "'" + CRLF
		cQuery += " AND SD1.D1_DOC   = SFT.FT_NFISCAL " + CRLF
		cQuery += " AND SD1.D1_SERIE = SFT.FT_SERIE   " + CRLF				
		cQuery += " AND SD1.D1_FORNECE = SFT.FT_CLIEFOR " + CRLF
		cQuery += " AND SD1.D1_LOJA    = SFT.FT_LOJA    " + CRLF
		cQuery += " AND SD1.D1_ITEM    = SFT.FT_ITEM    " + CRLF
		cQuery += " AND SD1.D_E_L_E_T_ = ' '" + CRLF
		cQuery += " GROUP BY SFT.FT_NFISCAL, SFT.FT_SERIE, SFT.FT_CLASFIS "
		cQuery += " ORDER BY SFT.FT_NFISCAL, SFT.FT_SERIE, SFT.FT_CLASFIS "
	
	
	Endif

	cQuery := ChangeQuery(cQuery)
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasTagJ, .F., .T.)
	
	cRet := '<imp>'
	cRet += '<ICMS>'
	nCount := 0
	While !(cAliasTagJ)->(Eof())
		nCount++
		If (cAliasTagJ)->FT_VALICM > 0
			nBASEICM := (cAliasTagJ)->FT_BASEICM
			nALIQICM := (cAliasTagJ)->FT_ALIQICM
			nVALICM  := (cAliasTagJ)->FT_VALICM
			nALIQSOL := (cAliasTagJ)->FT_ALIQSOL
			nICMSRET := (cAliasTagJ)->FT_ICMSRET
		Else
			nBASEICM := (cAliasTagJ)->BASEICM
			nALIQICM := (cAliasTagJ)->PICM
			nVALICM  := (cAliasTagJ)->VALICM
			nALIQSOL := (cAliasTagJ)->ALIQSOL
			nICMSRET := (cAliasTagJ)->ICMSRET
		EndIf
		
		If (cAliasTagJ)->FT_BASERET > 0
			nBASICMRET 	:= (cAliasTagJ)->FT_BASERET
			nALIQSOL 	:= (cAliasTagJ)->FT_ALIQSOL
			nICMSRET	:= (cAliasTagJ)->FT_ICMSRET  
			nCREDPRES	:= (cAliasTagJ)->FT_CRPRST  
		EndIf
				
		//l Informacoes relativas ao ICMS   l		
		If nCount == 1
			If cMVSINAC == '1'
			//--Simples Nacional(MV_CODREG == 1)
				cRet += '<ICMSSN>'
				cRet += '<CST>90</CST>'
				cRet += '<indSN>1</indSN>'							 
				cRet += '</ICMSSN>'						
			ElseIf SubStr((cAliasTagJ)->FT_CLASFIS, 2, 2) == '00'
				If SF2->F2_TIPO ='I'
					ComplICMS(@nBASEICM,@nALIQICM,@nVALICM)
					cRet += '<ICMS00>'
					cRet += '<CST>00</CST>'
					cRet += '<vBC>'  + ConvType(nBASEICM, 15, 2) + '</vBC>'
					cRet += '<pICMS>'+ ConvType(nALIQICM,  6, 2) + '</pICMS>'
					cRet += '<vICMS>'+ ConvType(nVALICM , 15, 2) + '</vICMS>'
					cRet += '</ICMS00>'						
				Else
					cRet += '<ICMS00>'
					cRet += '<CST>00</CST>'
					cRet += '<vBC>'  + ConvType(nBASEICM, 15, 2) + '</vBC>'
					cRet += '<pICMS>'+ ConvType(nALIQICM,  6, 2) + '</pICMS>'
					cRet += '<vICMS>'+ ConvType(nVALICM , 15, 2) + '</vICMS>'
					cRet += '</ICMS00>'						
				EndIf						
			ElseIf SubStr((cAliasTagJ)->FT_CLASFIS, 2, 2) $ "40,41,51"
				//l ICMS Isento, nao Tributado ou dIferido  l
				//l - 40: ICMS Isencao                      l
				//l - 41: ICMS Nao Tributada                l
				//l - 51: ICMS DIferido                     l				
				cRet += '<ICMS45>'
				If SubStr((cAliasTagJ)->FT_CLASFIS, 2, 2)  == '40'
					cRet += '<CST>40</CST>'
				ElseIf SubStr((cAliasTagJ)->FT_CLASFIS, 2, 2) == '41'
					cRet += '<CST>41</CST>'
				ElseIf SubStr((cAliasTagJ)->FT_CLASFIS, 2, 2) == '51'
					cRet += '<CST>51</CST>'
				EndIf
				cRet += '</ICMS45>'
			ElseIf SubStr((cAliasTagJ)->FT_CLASFIS, 2, 2) == "60"
				//l - 60: ICMS cobrado por substitui?o tribut?ia.                 l
				//l Responsabilidade do recolhimento do ICMS atribu?o              l
				//l ao tomadorou 3o por ST.                                         l
				//l CST60 - ICMS cobrado anteriormente por substituicao tributaria  l				
				cRet += '<ICMS60>'
				//-- ICMS cobrado anteriormente por substituicao tributaria
				cRet += '<CST>60</CST>'
				cRet += '<vBCSTRet>'  + ConvType(nBASICMRET, 15, 2) + '</vBCSTRet>'
				cRet += '<vICMSSTRet>'+ ConvType(nICMSRET + nCREDPRES , 15, 2) + '</vICMSSTRet>'
				cRet += '<pICMSSTRet>'+ ConvType(nALIQSOL,  6, 2) + '</pICMSSTRet>'
				cRet += '<vCred>'     + ConvType(nCREDPRES, 15, 2) + '</vCred>'
				cRet += '</ICMS60>'
			ElseIf SubStr((cAliasTagJ)->FT_CLASFIS, 2, 2) $ "10,30,70"
				//l - 80: ICMS pagto atribuido ao tomador ou ao 3o previsto para    l
				//l substituicao tributaria                                       l
				cRet += '<ICMS90>'
				cRet += '<CST>90</CST>'		
				cRet += '<vBC>'    + ConvType(nBASEICM, 15, 2) + '</vBC>'
				cRet += '<pICMS>'  + ConvType(nALIQICM,  6, 2) + '</pICMS>'
				cRet += '<vICMS>'  + ConvType(nVALICM , 15, 2) + '</vICMS>'
				cRet += '<vCred>'  + ConvType(nVcred  , 15, 2) + '</vCred>'
				cRet += '</ICMS90>'
			ElseIf SubStr((cAliasTagJ)->FT_CLASFIS, 2, 2) $ '20,90' .And. !(AllTrim(cCFOP) $ "5932,6932")
				//l - 81: ICMS DEVIDOS A OUTRAS UF'S                                l
				//l - 90: ICMS Outros                                               l				
				If SubStr((cAliasTagJ)->FT_CLASFIS, 2, 2) == '20'
					cRet += '<ICMS20>'
					cRet += '<CST>20</CST>'		
					cRet += '<vBC>'  + ConvType(nBASEICM, 15, 2) + '</vBC>'
					cRet += '<pICMS>'+ ConvType(nALIQICM,  6, 2) + '</pICMS>'
					cRet += '<vICMS>'+ ConvType(nVALICM , 15, 2) + '</vICMS>'
					cRet += '</ICMS20>'
				Else
					If SubStr((cAliasTagJ)->FT_CLASFIS, 2, 2) == '90'
						cRet += '<ICMS90>'
					Else
						cRet += '<CST81>'
					EndIf
					cRet += '<CST>90</CST>'		
					cRet += '<vBC>'    + ConvType(nBASEICM, 13, 2) + '</vBC>'
					cRet += '<pICMS>'  + ConvType(nALIQICM,  6, 2) + '</pICMS>'
					cRet += '<vICMS>'  + ConvType(nVALICM , 13, 2) + '</vICMS>'
					cRet += '<vCred>'  + ConvType(nICMSRET, 15, 2) + '</vCred>'
					If SubStr((cAliasTagJ)->FT_CLASFIS, 2, 2) == '90'
						cRet += '</ICMS90>'
					Else
						cRet += '</CST81>'
					EndIf
				EndIf
			ElseIf SubStr((cAliasTagJ)->FT_CLASFIS, 2, 2) $ '20,90' .And. AllTrim(SF3->F3_CFO) $ "5932,6932"
				//l - 81: ICMS DEVIDOS A OUTRAS UF'S                                l
				//l - 90: ICMS Outros                                               l				
				cRet += '<ICMSOutraUF>'
				cRet += '<CST>90</CST>'	
				cRet += '<vBCOutraUF>'    + ConvType(nBASEICM	, 13, 2) + '</vBCOutraUF>'
				cRet += '<pICMSOutraUF>'  + ConvType(nALIQICM	,  6, 2) + '</pICMSOutraUF>'
				cRet += '<vICMSOutraUF>'  + ConvType(nVALICM  , 13, 2) + '</vICMSOutraUF>'
				cRet += '</ICMSOutraUF>'
			EndIf
		EndIf //-- If nCount == 1
		
		(cAliasTagJ)->(dbSkip())
		
	EndDo
	
	(cAliasTagJ)->(DbCloseArea())

	cRet += '</ICMS>'
	//-- Valor Total dos impostos - Lei da Transparencia
	If !Empty(SF2->F2_TOTIMP)
		cRet += '<vTotTrib>' + ConvType(SF2->F2_TOTIMP, 13, 2) + '</vTotTrib>'	
	EndIf
	//-- Observa?es das regras de Tributa?o (campo Memo)	
	cObs := G99->G99_OBSERV
	If !Empty(cObs)
		cRet +=  '<infAdFisco>' + NoAcentoCte(SubStr(cObs,1,320)) + '</infAdFisco>'
	EndIf
	
	//l TAG:  Informacoes relativas ICMS para a UF de t?mino da `     //
	// presta?o do servi? de transporte nas opera?es interestaduais //
	// para consumidor final  Emenda Constitucional 87 de 2015.        //
	// Nota T?nica 2015/003 e 2015/004                                //	
	If !Empty(cInterCons)  //-- Nao Contribuinte e Campo Difal
		cRet += cInterCons								
	EndIf
	
	cRet += '</imp>'

Return cRet

Static Function ComplICMS(nBASEICM,nALIQICM,nVALICM)

Local cNota 	:= SD2->D2_NFORI
Local cSerie	:= SD2->D2_SERIORI
Local cCliente	:= SD2->D2_CLIENTE
Local cLoja 	:= SD2->D2_LOJA
Local aAreaSD2 	:= SD2->(GetArea())

SF2->(DbSetOrder(1))
If SF2->(DBSEEK(ALLTRIM(G99->G99_CHVFIS)))
	cNota    := SF2->F2_DOC
	cSerie   := SF2->F2_SERIE
	cCliente := SF2->F2_CLIENTE
	cLoja    := SF2->F2_LOJA
EndIf

SD2->(DbSetOrder(3))
SD2->(DbSeek(xFilial("SD2",cFilEnc)+PadR(cNota,TamSx3('F2_DOC')[1])+PadR(cSerie,TamSx3('F2_SERIE')[1])+cCliente+cLoja ))
While !SD2->(Eof ()) .And. SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA == cNota+cSerie+cCliente+cLoja
	nBASEICM	+= SD2->D2_PRCVEN
	nVALICM     := SD2->D2_VALICM
	nALIQICM	:= SD2->D2_PICM	
	SD2->(DbSkip()) 
End

RestArea(aAreaSD2)

Return

/*/{Protheus.doc} TagCteNorm
//TODO Descrição auto-gerada.
@author osmar.junior
@since 03/10/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function TagCteNorm()
	Local cRet:= ''
	Local cGTPAntt    := SuperGetMv( "MV_TMSANTT", .F., '' )
	
	If G99->G99_TIPCTE $ '0|3'
		cRet += '<infCTeNorm>'
			cRet += '<infCarga>'
				cRet += '<vCarga>' + ConvType( G99->G99_VALOR, 15, 2 ) + '</vCarga>'
				cRet += '<proPred>ENCOMENDAS</proPred>'
				
		If !Empty(G99->G99_PESO)
					cRet += '<infQ>'
						cRet += '<cUnid>01</cUnid>'
						cRet += '<tpMed>PESO DECLARADO</tpMed>'
						cRet += '<qCarga>'+ ConvType( G99->G99_PESO, 15, 4 ) +'</qCarga>'
					cRet += '</infQ>'
		EndIf
		If !Empty(G99->G99_PESCUB)
					cRet += '<infQ>'
						cRet += '<cUnid>01</cUnid>'
						cRet += '<tpMed>PESO CUBADO</tpMed>'
						cRet += '<qCarga>'+ ConvType( G99->G99_PESCUB, 15, 4 ) +'</qCarga>'
					cRet += '</infQ>'	
		EndIf
		If !Empty(G99->G99_QTDVO)
					cRet += '<infQ>'
						cRet += '<cUnid>01</cUnid>'
						cRet += '<tpMed>VOLUME</tpMed>'
						cRet += '<qCarga>'+ ConvType( G99->G99_QTDVO, 15, 4 ) +'</qCarga>'
					cRet += '</infQ>'
		EndIf
		If !Empty(G99->G99_METRO3)
					cRet += '<infQ>'
						cRet += '<cUnid>01</cUnid>'
						cRet += '<tpMed>METRO CUBICO</tpMed>'
						cRet += '<qCarga>'+ConvType( G99->G99_METRO3, 15, 4 ) +'</qCarga>'
					cRet += '</infQ>'
		EndIf
			cRet += '</infCarga>'
			
			cRet += '<infDoc>'
				cRet += '<infOutros>'		
				    cRet += '<tpDoc>00</tpDoc>'		//00 - Declaração;
				    cRet += '<descOutros>Outros</descOutros>'		   
			    cRet += '</infOutros>'
			cRet += '</infDoc>'
		
			cRet +='<infModal versaoModal="3.00">'
				cRet +='<rodo>'
		If !Empty(cGTPAntt)
						cRet += '<RNTRC>' + SubStr(AllTrim(cGTPAntt),1,8) + '</RNTRC>'
		Else
						cRet += '<RNTRC>ISENTO</RNTRC>'
		EndIf
				cRet +='</rodo>'
			cRet +='</infModal>'
			cRet += CTeSubst()
		cRet += '</infCTeNorm>'
	EndiF
Return cRet



/*/{Protheus.doc} InfCteIni
//TODO Descrição auto-gerada.
@author osmar.junior
@since 03/10/2019
@version 1.0
@return ${return}, ${return_description}
@param cCodUF, characters, descricao
@param cModalidade, characters, descricao
@param cVerAmb, characters, descricao
@param cCT, characters, descricao
@param cChvAux, characters, descricao
@type function
/*/
Static Function InfCteIni(cCodUF, cModalidade, cVerAmb, cCT, cChvAux, cEvento )
	Local cRet := ''
	Local cTpEmis := ''	
	Local cNFe := ''
	cCT := Inverte()
	
	cRet += '<infNFe versao="T02.00" modelo="57">'				
	cRet += '<CTe xmlns="http://www.portalfiscal.inf.br/cte">'


	aAreaSM0 := SM0->(GetArea())
					


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gerar Chave de Acesso do CT-e                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Formato de Impressao do CT-e                                    ³
	//³ 1 - Normal    
	//³ 4 - EPEC  	                                                    ³
	//³ 5 - Contingencia versao 1.04 - 7-Contingência FS-DA             ³
	//³ 7 - Contingencia versao 1.04 - SVC-RS                           ³
	//³ 8 - Contingencia versao 1.04 - SVC-SP                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If (cModalidade == '1')
		cTpEmis := '1'
	ElseIf cModalidade == '5'
		cTpEmis := '4'
	ElseIf cModalidade == '7'
		cTpEmis := '5'
	ElseIf cModalidade == '8'
		cTpEmis := '8'
	ElseIf cModalidade == '9'
		cTpEmis := '7'
	EndIf
		
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Voltar rotina abaixo                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	
	If cEVento <> '2'
		cChvAcesso := CTeCHVAC( cCodUF,;
								( SubStr(AllTrim(DTOS(SF2->F2_EMISSAO)), 3, 2) + SubStr(AllTrim(DTOS(SF2->F2_EMISSAO)), 5, 2) ),;
								AllTrim(SM0->M0_CGC),;
								'57',;
								StrZero(Val(SF2->F2_SERIE),TamSx3('F2_SERIE')[1]),;
								StrZero(Val(SF2->F2_DOC), 9),; 
								cTpEmis + cCT)
	Else
		cChvAcesso := CTeCHVAC( cCodUF,;
								( SubStr(AllTrim(DTOS(SF1->F1_EMISSAO)), 3, 2) + SubStr(AllTrim(DTOS(SF1->F1_EMISSAO)), 5, 2) ),;
								AllTrim(SM0->M0_CGC),;
								'57',;
								StrZero(Val(SF1->F1_SERIE),TamSx3('F1_SERIE')[1]),;
								StrZero(Val(SF1->F1_DOC), 9),; 
								cTpEmis + cCT)
	Endif
						
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicio dos Dados do CTe                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cNFe    := 'CTe' + AllTrim(cChvAcesso)
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Versao do Ct-e, de acordo com o parametro                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cRet += '<infCte Id="CTe' + AllTrim(cChvAcesso) + '" versao="' + cVerAmb + '">'
	cChvAux:= AllTrim(cChvAcesso)

					

Return cRet


/*/{Protheus.doc} CteIde
//TODO Descrição auto-gerada.
@author osmar.junior
@since 03/10/2019
@version 1.0
@return ${return}, ${return_description}
@param cCodUF, characters, descricao
@param cCT, characters, descricao
@param cModalidade, characters, descricao
@param cChvAux, characters, descricao
@param cTimeZone, characters, descricao
@param cAmbiente, characters, descricao
@param cVerAmb, characters, descricao
@type function
/*/
Static Function CteIde(cCodUF,cCT,cModalidade, cChvAux,cTimeZone,cAmbiente,cVerAmb, cEvento,cUFIni,cUFFim)
	Local cRet := ''
	Local cCodUFRem := ''
	Local cCodUFDes := ''
	Local cCodUFRec := ''
	Local cCFOP     := ''
	Local cMail := ''
	Local lFecp		:= SF4->(ColumnPos('F4_DIFAL')) > 0
	Local aAgConf := {}
	Local cDtEmissao := DTOS(G99->G99_DTEMIS)
	Default cTimeZone := '-03:00'
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ TAG: B - IdentIficação do Conhecimento de Transporte Eletronico ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ CFOP - Natureza da Prestacao                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	

	dbSelectArea("SA1")
	dbSetOrder(1)
	MsSeek( xFilial("SA1")+G99->(G99_CLIREM+G99_LOJREM) )	
	If aScan(aUF,{|x| x[1] == SA1->A1_EST }) != 0   //Confere se Uf do Remetente esta OK
		cCodUFRem  := aUF[ aScan(aUF,{|x| x[1] == SA1->A1_EST }), 2]						
	Else
		cCodUFRem  := ''
	EndIf
		
	MsSeek(xFilial("SA1")+G99->(G99_CLIDES+G99_LOJDES)) 	
	If aScan(aUF,{|x| x[1] == SA1->A1_EST }) != 0   //Confere se Uf do Destinatario esta OK
		cCodUFDes  := aUF[ aScan(aUF,{|x| x[1] == SA1->A1_EST }), 2]
	Else
		cCodUFDes := ''
	EndIf
	
	cMail := SubStr(Posicione('SA1',1,xFilial('SA1')+SF2->(F2_CLIENTE+F2_LOJA),'A1_EMAIL'),1, 60 )
	
	If lFecp
		cUFST := Posicione('SA1',1,xFilial('SA1')+SF2->(F2_CLIENTE+F2_LOJA),'A1_EST')
	EndIf
	
	dbSelectArea("SF3")
	SF3->(DbSetOrder(4))
	If SF3->(DbSeek(xFilial("SF3",cFilEnc)+SF2->(F2_CLIENTE+F2_LOJA+F2_DOC+F2_SERIE)))
		cCFOP := SF3->F3_CFO
	else
		cCFOP := G99->G99_CFOP
	EndIf


	cRet += '<ide>'
	cRet += '<cUF>'  + NoAcentoCte( cCodUF )		+ '</cUF>'
	cRet += '<cCT>'  + NoAcentoCte( cCT )		+ '</cCT>'
	cRet += '<CFOP>' + NoAcentoCte( G99->G99_CFOP )		+ '</CFOP>'
	cRet += '<natOp>'+ NoAcentoCte( SubStr(AllTrim(FWGetSX5('13',PadR(cCFOP, TamSX3("X5_CHAVE")[1]))[1][4]),1,55) )	+ '</natOp>'

	If SA1->A1_CONTRIB == '1'
		lContrib := .T.		
	EndIf

	
	cRet += '<mod>' 	+ "57" + '</mod>'
	
	If cEvento <> '2'
		cRet += '<serie>'+ NoAcentoCte( cValtoChar( SF2->F2_SERIE ) ) + '</serie>'
		cRet += '<nCT>'	+ NoAcentoCte( cValtoChar( Val( AllTrim(SF2->F2_DOC ) ) ) ) + '</nCT>'
	Else
		cRet += '<serie>'+ NoAcentoCte( cValtoChar( SF1->F1_SERIE ) ) + '</serie>'
		cRet += '<nCT>'	+ NoAcentoCte( cValtoChar( Val( AllTrim(SF1->F1_DOC ) ) ) ) + '</nCT>'
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Data e hora de emissão                                           ³
	//³Formato = AAAA-MM-DDTHH:MM:SS                                    ³
	//³Preenchido com data e hora de emissão.                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cRet += '<dhEmi>' + SubStr(cDtEmissao, 1, 4) + "-";
	+ SubStr(cDtEmissao, 5, 2) + "-";
	+ SubStr(cDtEmissao, 7, 2) + "T";
	+ SubStr(G99->G99_HREMIS, 1, 2) + ":";
	+ SubStr(G99->G99_HREMIS, 4, 2) + ':00';
	+ cTimeZone + '</dhEmi>' 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Formato de Impressao do DACTE                                   ³
	//³ 1 - Retrato                                                     ³
	//³ 2 - Paisagem                                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cRet += '<tpImp>1</tpImp>'

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Formato de Impressao do CT-e                                    ³
	//³ 1 - Normal                                                      ³
	//³ 4 - EPEC                                                        ³
	//³ 5 - Contingencia versao 1.04                                    ³
	//³ 7 - Contingencia versao 1.04  - SVC-RS                          ³
	//³ 8 - Contingencia versao 1.04  - SVC-SP                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If (cModalidade == '1')
		cRet += '<tpEmis>1</tpEmis>'
	ElseIf cModalidade == '5'
		cRet += '<tpEmis>4</tpEmis>'
	ElseIf cModalidade == '7'
		cRet += '<tpEmis>5</tpEmis>'
	ElseIf cModalidade == '8'
		cRet += '<tpEmis>8</tpEmis>'
	ElseIf cModalidade == '9'
		cRet += '<tpEmis>7</tpEmis>'
	EndIf

	cRet += '<cDV>' + SubStr( AllTrim(cChvAux), len( AllTrim(cChvAux) ), 1) + '</cDV>'

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Identificacao do Ambiente.                                      ³
	//³ 1 - Producao                                                    ³
	//³ 2 - Homologacao                                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cRet += '<tpAmb>' + cAmbiente + '</tpAmb>'

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Tipo de Conhecimento                                            ³
	//³ 0 - Normal                                                      ³
	//³ 1 - Complemento de Valores                                      ³
	//³ 2 - Emitido em Hipotese de anulacao de Debito                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cRet += '<tpCTe>'+G99->G99_TIPCTE+'</tpCTe>'

	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processo de Emissao do CT-e                                     ³
	//³ 0 - emissao com aplicativo do contribuinte                      ³
	//³ 1 - avulsa pelo fisco                                           ³
	//³ 2 - avulsa pelo contrinbuinte com seu certificado digital,      ³
	//³     atraves do site do Fisco                                    ³
	//³ 3 - pelo contribuinte com aplicativo fornecido pelo Fisco       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cRet += '<procEmi>0</procEmi>'			
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³                                                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cRet += '<verProc>' + cVerAmb + '</verProc>'
	
	//cRet += '<indGlobalizado>1</indGlobalizado>'
		
	cRet += '<cMunEnv>' + NoAcentoCte( SM0->M0_CODMUN ) + '</cMunEnv>'
	cRet += '<xMunEnv>' + NoAcentoCte( SM0->M0_CIDENT ) + '</xMunEnv>'
	cRet += '<UFEnv>'   + NoAcentoCte( SM0->M0_ESTENT ) + '</UFEnv>'

	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Modal                                                           ³
	//³ 01 - Rodoviario;                                                ³
	//³ 02 - Aereo;                                                     ³
	//³ 03 - Aquaviario;                                                ³
	//³ 04 - Ferroviario;                                               ³
	//³ 05 - Dutoviario.                                                ³
	//³ 06 - Multimodal                                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


	cRet += '<modal>01</modal>'
	
	cRet   += '<tpServ>'+G99->G99_TIPSER+'</tpServ>' 

	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Municipio inicio e termino da prestacao                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	aAgConf := GxGetMunAg(G99->G99_CODEMI,2)
	cRet += '<cMunIni>' + aAgConf[4]+aAgConf[2] + '</cMunIni>'
	cRet += '<xMunIni>' + AllTrim(aAgConf[3]) + '</xMunIni>'			
	cRet += '<UFIni>'   + AllTrim(aAgConf[1]) + '</UFIni>'
	cUFIni := AllTrim(aAgConf[1])
	aAgConf := GxGetMunAg(G99->G99_CODREC,2)
	cRet += '<cMunFim>'	+ aAgConf[4]+aAgConf[2] + '</cMunFim>'
	cRet += '<xMunFim>'	+ AllTrim(aAgConf[3]) + '</xMunFim>'
	cRet += '<UFFim>'	+ AllTrim(aAgConf[1]) + '</UFFim>'
	cUFFim := AllTrim(aAgConf[1])
	//Percurso (Estados por onde vai passar, excluindo Inicio e Fim)
    //Apenas para CTe-Os
    //cInfPerc := infPercurso( SF2->F2_SERIE, SF2->F2_DOC)
    

	//If !Empty(cInfPerc)
	//	cRet += cInfPerc
	//EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Recebedor retira no aeroporto,filial, porto ou Estacao Destino? ³
	//³ 0 - SIM / 1 - NAO                                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	 
	cRet += '<retira>0</retira>'
	cRet += '<xDetRetira>NAO SE APLICA</xDetRetira>'


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ TAG Tomador do Serviço ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ				
	cRet += CTeToma(cAmbiente)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Contigencia 1.04                                                 ³
	//³Data e hora de entrada em contigencia                            ³
	//³Formato = AAAA-MM-DDTHH:MM:SS                                    ³
	//³Justificativa da Contigencia -                                   ³
	//³Preenchida no momento de escolha da opcao de Contigencia FSDA    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If	cModalidade == '5'//
		cRet += '<dhCont>' + SubStr(cDtEmissao, 1, 4) + "-";
			 + SubStr(cDtEmissao, 5, 2) + "-";
			 + SubStr(cDtEmissao, 7, 2) + "T";
			 + SubStr(G99->G99_HREMIS, 1, 2) + ":";
			 + SubStr(G99->G99_HREMIS, 4, 2) + ':00';
			 + cTimeZone +  '</dhCont>'
			cRet += '<xJust>Sefaz indisponivel</xJust>'			
	EndIf
	
	cRet += '</ide>' 

Return cRet


/*/{Protheus.doc} InfCteFim
//TODO Descrição auto-gerada.
@author osmar.junior
@since 03/10/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function InfCteFim(cModalidade,cDoc_Chv,cAmbiente)
	Local cRet := ''

			cRet += '</infCte>'
				cRet += XmlCTeQrC(cModalidade,cDoc_Chv,cAmbiente)
		cRet += '</CTe>'
	cRet += '</infNFe>'

Return 	cRet	



/*/{Protheus.doc} infPercurso
//TODO Descrição auto-gerada.
@author osmar.junior
@since 03/10/2019
@version 1.0
@return ${return}, ${return_description}
@param cSerie, characters, descricao
@param cNota, characters, descricao
@type function
/*/
Static Function infPercurso(cSerie,cNota)
	Local cRet := ''
	Local cAliasTmp := GetNextAlias()

	//informar a sigla das Unidades da Federação do percurso do veículo.
	//Não é necessário repetir as UF de Início e Fim
	BeginSql alias cAliasTmp
		SELECT G9P.G9P_ESTADO
		FROM %table:G9P% G9P
		JOIN %table:G99% G99 ON G9P_FILIAL = G99_FILIAL AND G9P_CODIGO = G99_CODIGO AND G99.%notDel%
		
		WHERE 	G9P_FILIAL = %xFilial:G9P% AND 
				G99_SERIE = %exp:alltrim(cSerie)% AND 
				G99_NUMDOC = %exp:alltrim(cNota)% AND 
				G9P.%notDel%			
		ORDER BY G9P_ITEM
	EndSql
	
	If (cAliasTmp)->(!EoF())
		cRet += '<infPercurso>'
		While (cAliasTmp)->(!EoF())
			cRet += '<UFPer>'+(cAliasTmp)->G9P_ESTADO+'</UFPer>'			
			(cAliasTmp)->(DbSkip())
		End
		cRet += '</infPercurso>'
	EndIf

Return cRet	


/*/{Protheus.doc} XmlCTeQrC
//TODO Descrição auto-gerada.
@author osmar.junior
@since 08/10/2019
@version 1.0
@return ${return}, ${return_description}
@param cModalidade, characters, descricao
@param cDoc_Chv, characters, descricao
@param cAmbiente, characters, descricao
@type function
/*/
Static Function XmlCTeQrC(cModalidade,cDoc_Chv,cAmbiente)
	Local cTagQRC :=''	
	Local cEstado	:= AllTrim(SM0->M0_ESTENT)
	Local cURLQrc	:= ''	
	
	If  cEstado $ 'AC|AL|AM|BA|CE|DF|ES|GO|MA|PA|PB|PI|RJ|RN|RO|RS|SC|TO'
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
			cURLQrc := 'https://hcte.fazenda.mg.gov.br/portalcte/sistema/qrcode.xhtml'
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


/*/{Protheus.doc} InterCons
//Função para retornar as tags de partilha de icms
@author osmar.junior
@since 08/10/2019
@version 1.0
@type function
/*/
Static Function InterCons(cCliente,cLoja,cNota,cSerie) 
	Local cRet:= ''	
	Local nBCICMS := 0
	Local nPERFCP := 0
	Local nALQTER := 0
	Local nALQINT := 0
	Local nPEDDES := 0
	Local nVALFCP := 0
	Local nVALDES := 0
	Local nVLTRIB := 0
	Local cAliasCD2 := ''
	Local cQuery := ''
	Local aAreaSA1		:= SA1->(GetArea()) 
	Local aAreaSF4		:= SF4->(GetArea()) 
	
	SA1->(DbSetOrder(1))
	SA1->(DbSeek(xFilial('SA1')+cCliente+cLoja)) 

	If SA1->A1_CONTRIB <> '1' //NAO CONTRIBUINTE
		SF4->(DbSetOrder(1))
		If SF4->(DbSeek(xFilial("SF4")+G99->G99_TS )) //TODO: Deve-se passar o segundo parâmetro para xFilial- cFilEnc?
			If SF4->F4_DIFAL == "1" .And. SF4->F4_COMPL == "S"
		
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
				cQuery += "    WHERE D2.D2_FILIAL  = '" + xFilial('SD2',cFilEnc) + "'" + CRLF
				cQuery += "    AND D2.D2_DOC     = '" + cNota    + "'" + CRLF      
				cQuery += "    AND D2.D2_SERIE   = '" + cSerie   + "'" + CRLF      
				cQuery += "    AND D2.D2_CLIENTE = '" + cCliente + "'" + CRLF      
				cQuery += "    AND D2.D2_LOJA    = '" + cLoja    + "'" + CRLF      
				cQuery += "    AND D2.D_E_L_E_T_ = ''" + CRLF       
											
				cQuery += "    AND CD2.CD2_FILIAL = '"  + xFilial('CD2',cFilEnc) + "'" + CRLF							
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

				cRet += '<ICMSUFFim>'						
				cRet += '<vBCUFFim>'   		+ ConvType(nBCICMS,  15, 2) + '</vBCUFFim>'
				cRet += '<pFCPUFFim>'  		+ ConvType(nPERFCP,   5, 2) + '</pFCPUFFim>'
				cRet += '<pICMSUFFim>' 		+ ConvType(nALQTER,   5, 2) + '</pICMSUFFim>'
				cRet += '<pICMSInter>' 		+ ConvType(nALQINT,   5, 2) + '</pICMSInter>'
				If SM0->M0_ESTENT == 'PR'	//Paraná ainda necessita da tag
					cRet += '<pICMSInterPart>'	+ ConvType(nPEDDES,   5, 2) + '</pICMSInterPart>'
				EndIf
				cRet += '<vFCPUFFim>' 		+ ConvType(nVALFCP,  15, 2) + '</vFCPUFFim>'
				cRet += '<vICMSUFFim>'  	+ ConvType(nVALDES,  15, 2) + '</vICMSUFFim>'
				cRet += '<vICMSUFIni>' 		+ ConvType(nVLTRIB,  15, 2) + '</vICMSUFIni>'							
				cRet += '</ICMSUFFim>'	

			EndIf	
		Endif
	Endif
	
	RestArea(aAreaSA1)
	RestArea(aAreaSF4)
	
Return cRet


/*/{Protheus.doc} TesteCte
//teste de execução
@author osmar.junior
@since 03/10/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User function TesteCte()
	PARAMIXB := Array(5)
	PARAMIXB[2]:='2'
	PARAMIXB[3]:='3.00'
	PARAMIXB[4]:='1'
	PARAMIXB[5]:='-03:00'
	PARAMIXB[1] :={,,,,,,}//-- Obtem as informacoes de contigencia

  //U_GTPCTEXML('CTE','000013   ','ZZZSP ','01  ') 
	U_GTPCTEXML('375','000001   ','VSI000','0001','2', '3.00', '1','-03:00',) 

	//GTPCTEXML(cSerie,cNota,cClieFor,cLoja, cAmbiente, cVerAmb, cModalidade, cTimeZone, cEvento))
	//cAmbiente 1-pord/2-homol

Return	 
