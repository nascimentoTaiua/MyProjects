#INCLUDE "finr650.CH"
#Include "PROTHEUS.CH"   

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//?Variaveis para tratamento dos Sub-Totais por Ocorrencia  ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
#DEFINE DESPESAS           3
#DEFINE DESCONTOS          4
#DEFINE ABATIMENTOS        5
#DEFINE VALORRECEBIDO      6
#DEFINE JUROS              7
#DEFINE VALORIOF		   8
#DEFINE VALORCC			   9
#DEFINE VALORORIG		   10
#DEFINE SIGAFIN			   6

Static lExecJob		:= ExecSchedule()
Static __lFuncVldEx	As Logical

// 17/08/2009 - Compilacao para o campo filial de 4 posicoes
// 18/08/2009 - Compilacao para o campo filial de 4 posicoes

/*/{Protheus.doc} FINR650
Impress? do Retorno da Comunica豫o Banc?ia  
@type function
@version 12
@author totvs
@since 03/02/2023
@param aParam, array, par?etros
/*/
User Function FINR650(aParam As Array)
	Local oReport    As Object
	Local lLicencUso As Logical

	DEFAULT aParam := {}

	//Valida a licen? do m?ulo
	lLicencUso := VldLicenca()

	If lLicencUso
		oReport := ReportDef(aParam)

		If !lExecJob
			oReport:PrintDialog()
		Else
			oReport:lPreview	:= .F.
			oReport:Print()
		EndIf
	EndIf

Return

/*/{Protheus.doc} ReportDef
A funcao estatica ReportDef devera ser criada para todos os
relatorios que poderao ser agendados pelo usuario.
@type function
@version 12
@author totvs
@since 03/02/2023
@param aParam, array, parametros
@return object, objeto TReport
/*/
Static Function ReportDef(aParam As Array) As Object
	Local oReport As Object
	Local nI      As Numeric
	Local cFile   As Character
	Local cPath   As Character
	Local nParam  As Numeric
	Local cBarra  As Character

	oReport := Nil
	nI      := Nil
	cFile   := ""
	cPath   := ""
	nParam  := 0
	cBarra  := If(isSrvUnix(),"/","\")
	
	Default aParam := {}	//Modelo conteudo do array {{'MV_PAR01',Valor},{'MV_PAR02',Valor},{'MV_PARn',ValorN}}
	
	Pergunte("FIN650", .F., Nil, Nil, Nil, !lExecJob)
	
	If (nParam := Len(aParam)) > 0
		For nI := 1 To nParam
			If "MV_PAR" $ UPPER(aParam[nI,1])
				&(aParam[nI,1]) := aParam[nI,2]
			EndIf 
		Next nI
	EndIf
	
	oReport := TReport():New("FINR650",STR0004,"FIN650",{|oReport| ReportPrint(oReport)},STR0001+STR0002+STR0003)

	If lExecJob
		oReport:nDevice := 6
		
		cPath		:= ALLTRIM(GETMV('MV_RELT'))
		cFile	 	:= Substr(mv_par01,rat(cBarra,mv_par01)+1,len(mv_par01))          
		cFile		:= Substr(cFile,1, rat(".",cFile)-1)
		cFile       := StrTran( cFile, '.', '_' )
		
		If File(cPath+cFile+".PDF")
			FERASE(cPath+cFile+".PDF")
		Endif
		oReport:cFile := cFile
	EndIf
							
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커s
	//? Secao 1 - Titulos a Receber   ?
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

	oSection1 := TRSection():New(oReport,STR0047)
	TRCell():New(oSection1,"SEC1_TIT",,STR0031,,25,,)
	TRCell():New(oSection1,"SEC1_CLI",,STR0032,,10,,)
	TRCell():New(oSection1,"SEC1_OCOR",,STR0033,,31,,)
	TRCell():New(oSection1,"SEC1_DTOCOR",,STR0034,,10,,)
	TRCell():New(oSection1,"SEC1_VORIG",,StrTran(STR0035," ",CRLF),"@E 99999,999.99",12,,,"RIGHT",,"RIGHT")
	TRCell():New(oSection1,"SEC1_VRECE",,StrTran(STR0036," ",CRLF),"@E 99999,999.99",12,,,"RIGHT",,"RIGHT")
	TRCell():New(oSection1,"SEC1_VPAGO",,StrTran(STR0037," ",CRLF),"@E 99999,999.99",12,,,"RIGHT",,"RIGHT")
	TRCell():New(oSection1,"SEC1_DCOB" ,,StrTran(STR0038," ",CRLF),"@E 99999,999.99",12,,,"RIGHT",,"RIGHT")
	TRCell():New(oSection1,"SEC1_VDESC",,StrTran(STR0039," ",CRLF),"@E 99999,999.99",12,,,"RIGHT",,"RIGHT")
	TRCell():New(oSection1,"SEC1_VABAT",,StrTran(STR0040," ",CRLF),"@E 99999,999.99",12,,,"RIGHT",,"RIGHT")
	TRCell():New(oSection1,"SEC1_VJURO",,StrTran(STR0041," ",CRLF),"@E 99999,999.99",12,,,"RIGHT",,"RIGHT")
	TRCell():New(oSection1,"SEC1_VIOF" ,,StrTran(STR0042," ",CRLF),"@E 99999,999.99",12,,,"RIGHT",,"RIGHT")
	TRCell():New(oSection1,"SEC1_OCRED",,StrTran(STR0044," ",CRLF),"@E 99999,999.99",12,,,"RIGHT",,"RIGHT")
	TRCell():New(oSection1,"SEC1_DTCRED",,STR0045,,10,,)
	TRCell():New(oSection1,"SEC1_NTIT",,STR0043,,19,,)
	TRCell():New(oSection1,"SEC1_CONS",,STR0046,,26,,)
											
	//旼컴컴컴컴컴컴컴컴컴컴컴?
	//? Secao 3 - Subtotais  ?
	//읕컴컴컴컴컴컴컴컴컴컴컴?

	oSection2 := TRSection():New(oReport,STR0048)
	TRCell():New(oSection2,"STOT_TIT",,STR0027,,69,,)
	TRCell():New(oSection2,"STOT_VORIG",,StrTran(STR0035," ",CRLF),"@E 99999,999.99",12,,,"RIGHT",,"RIGHT")
	TRCell():New(oSection2,"STOT_VRECE",,StrTran(STR0036," ",CRLF),"@E 99999,999.99",12,,,"RIGHT",,"RIGHT")
	TRCell():New(oSection2,"STOT_VPAGO",,StrTran(STR0037," ",CRLF),"@E 99999,999.99",12,,,"RIGHT",,"RIGHT")
	TRCell():New(oSection2,"STOT_DCOB" ,,StrTran(STR0038," ",CRLF),"@E 99999,999.99",12,,,"RIGHT",,"RIGHT")
	TRCell():New(oSection2,"STOT_VDESC",,StrTran(STR0039," ",CRLF),"@E 99999,999.99",12,,,"RIGHT",,"RIGHT")
	TRCell():New(oSection2,"STOT_VABAT",,StrTran(STR0040," ",CRLF),"@E 99999,999.99",12,,,"RIGHT",,"RIGHT")
	TRCell():New(oSection2,"STOT_VJURO",,StrTran(STR0041," ",CRLF),"@E 99999,999.99",12,,,"RIGHT",,"RIGHT")
	TRCell():New(oSection2,"STOT_VIOF" ,,StrTran(STR0042," ",CRLF),"@E 99999,999.99",12,,,"RIGHT",,"RIGHT")
	TRCell():New(oSection2,"STOT_OCRED",,StrTran(STR0044," ",CRLF),"@E 99999,999.99",12,,,"RIGHT",,"RIGHT")


	oSection2:SetHeaderSection(.T.)
	oReport:SetLandScape()

Return(oReport)


//-------------------------------------------------------------------
/*/{Protheus.doc} Function ReportPrint
	A funcao estatica ReportPrint devera ser criada para todos os
	relatorios que poderao ser agendados pelo usuario.
	@params  oReport = Objeto Report do Relat?io
	@author  Marcel Borges Ferreira
	@since   23/06/06
/*/
//-------------------------------------------------------------------
Static Function ReportPrint(oReport as Object) as Logical

	Local oSection1  as Object
	Local oSection2  as Object
	Local cPosPrin   as Character
	Local cPosJuro   as Character
	Local cPosMult   as Character
	Local cPosCC     as Character
	Local cPosTipo   as Character
	Local cPosNum    as Character
	Local cPosData   as Character
	Local cPosDesp   as Character
	Local cPosDesc   as Character
	Local cPosAbat   as Character
	Local cPosDtCC   as Character
	Local cPosIof    as Character
	Local cPosOcor   as Character
	Local cPosNosso  as Character
	Local cPosForne  as Character
	Local cPosCgc    as Character
	Local lPosNum    as Logical
	Local lPosData   as Logical
	Local lPosAbat   as Logical
	Local lPosDesp   as Logical
	Local lPosDesc   as Logical
	Local lPosMult   as Logical
	Local lPosPrin   as Logical
	Local lPosJuro   as Logical
	Local lPosDtCC   as Logical
	Local lPosOcor   as Logical
	Local lPosTipo   as Logical
	Local lPosIof    as Logical
	Local lPosCC     as Logical
	Local lPosNosso  as Logical
	Local lPosRej    as Logical
	Local lPosForne  as Logical
	Local lPosCgc    as Logical
	Local nLidos     as Numeric
	Local nLenNum    as Numeric
	Local nLenData   as Numeric
	Local nLenDesp   as Numeric
	Local nLenDesc   as Numeric
	Local nLenAbat   as Numeric
	Local nLenDtCC   as Numeric
	Local nLenCGC    as Numeric
	Local nLenPrin   as Numeric
	Local nLenJuro   as Numeric
	Local nLenMult   as Numeric
	Local nLenOcor   as Numeric
	Local nLenTipo   as Numeric
	Local nLenIof    as Numeric
	Local nLenCC     as Numeric
	Local nLenRej    as Numeric
	Local cArqConf   as Character
	Local cArqEnt    as Character
	Local lOcorr     as Logical
	Local cDescr     as Character
	Local cDescr2    as Character
	Local cEspecie   as Character
	Local cData      as Character
	Local nTamArq    as Numeric
	Local cForne     as Character
	Local cCgc       as Character
	Local nValIof    as Numeric
	Local nHdlBco    as Numeric
	Local nHdlConf   as Numeric
	Local cTabela    as Character
	Local lRej       as Logical
	Local cCarteira  as Character
	Local nTamDet    as Numeric
	Local lHeader    as Logical
	Local lProcessa  as Logical
	Local aTabela    as Array
	Local cChave650  as Character
	Local nPos       as Numeric
	Local lAchouTit  as Logical
	Local nValPadrao as Numeric
	Local aValores   as Array
	LOCAL lF650Var   as Logical
	Local lF650Desc  as Logical
	LOCAL dDataFin   as Date
	Local lOk        as Logical
	Local x          as Variant
	Local nCntOco    as Numeric
	Local aCntOco    as Array
	Local cCliFor    as Character
	Local lFr650Fil  as Logical
	Local nValOrig   as Numeric
	Local nTamPre    as Numeric
	Local nTamNum    as Numeric
	Local nTamPar    as Numeric
	Local nTamTit    as Numeric
	Local nTamForn   as Numeric
	Local lPrint     as Logical
	Local nTit       as Numeric
	Local nVOrig     as Numeric
	Local nVReceb    as Numeric
	Local nDCOB      as Numeric
	Local nVDESC     as Numeric
	Local nVABAT     as Numeric
	Local nVJURO     as Numeric
	Local nVIOF      as Numeric
	Local nOCRED     as Numeric
	Local cChave     as Character
	Local cDestino   as Character
	Local cBarra     as Character
	Local cFileName  as Character
	Local aFile      as Array
	Local aArqConf   as Array // Atributos do arquivo de configuracao
	Local aSE1_SE2   as Array
	Local cLocRec    as Character
	Local lBarra     as Logical
	Local cCamArq    as Character
	Local lCadBco    as Logical
	Local lF430TXBX  as Logical
	Local nTxMoeda   as Numeric
	Local aTitulo    as Array
	Local aAreaSE2   as Array
	Local cTipoReg   as Character
	Local lGEMBaixa  as Logical
	Local nArray     as Numeric
	Local aPosicoes  as Array
	Local cIDTran    as Character
	Local cRej       as Character
	Local nTamMotB   as Numeric
	Local lAchouSEB  as Logical
	Local nVlrAces   as Numeric
	Local nSaldoTit  as Numeric
	Local nCasDec    as Numeric
	Local lFValAcess as Logical
	Local cExtensoes as Character
	Local cParamSX6  as Character
	Local cRotina    as Character
	Local lDDA       as Logical

	oSection1  := oReport:Section(1)
	oSection2  := oReport:Section(2)
	lPosNum    := .f.
	lPosData   := .f.
	lPosAbat   := .f.
	lPosDesp   := .f.
	lPosDesc   := .f.
	lPosMult   := .f.
	lPosPrin   := .f.
	lPosJuro   := .f.
	lPosDtCC   := .f.
	lPosOcor   := .f.
	lPosTipo   := .f.
	lPosIof    := .f.
	lPosCC     := .f.
	lPosNosso  := .f.
	lPosRej    := .f.
	lPosForne  := .f.
	lPosCgc    := .F.
	nLenRej    := 0
	lOcorr     := .F.
	nValIof    := 0
	nHdlBco    := 0
	nHdlConf   := 0
	cTabela    := "17"
	lRej       := .f.
	lHeader    := .f.
	lProcessa  := .T.
	aTabela    := {}
	nPos       := 0
	lAchouTit  := .F.
	nValPadrao := 0
	aValores   := {}
	lF650Var   := ExistBlock("F650VAR" )
	lF650Desc  := ExistBlock("F650DESCR")
	dDataFin   := Getmv("MV_DATAFIN")
	nCntOco    := 0
	aCntOco    := {}
	cCliFor    := " "
	lFr650Fil  := ExistBlock("FR650FIL")
	nValOrig   := 0
	nTamPre    := TamSX3("E1_PREFIXO")[1]
	nTamNum    := TamSX3("E1_NUM")[1]
	nTamPar    := TamSX3("E1_PARCELA")[1]
	nTamTit    := nTamPre+nTamNum+nTamPar
	nTamForn   := Tamsx3("E2_FORNECE")[1]
	lPrint     := .T.
	cChave     := ""
	cDestino   := ""
	cBarra     := If(isSrvUnix(),"/","\")
	cFileName  := ""
	aFile      := {}
	aArqConf   := {} // Atributos do arquivo de configuracao
	aSE1_SE2   := {}
	cLocRec    := SuperGetMV( "MV_LOCREC" , .F. , " " )
	lBarra     := isSrvUnix()
	cCamArq    := ""
	lCadBco    := .T.
	lF430TXBX  := ExistBlock("F430TXBX")
	nTxMoeda   := 0
	aTitulo    := {}
	aAreaSE2   := {}
	cTipoReg   := ""
	lGEMBaixa  := ExistTemplate("GEMBaixa")
	nArray     := 1
	aPosicoes  := {}
	cIDTran    := ""
	cRej       := ""
	nTamMotB   := TamSX3("EB_MOTBAN")[1]
	lAchouSEB  := .F.
	nVlrAces   := 0
	nSaldoTit  := 0
	nCasDec    := IIf(mv_par07 == 1, TamSx3("E1_TXMOEDA"), TamSx3("E2_TXMOEDA"))[2]
	lFValAcess := FindFunction("FValAcess")
	cExtensoes := ""
	cParamSX6  := ""
	cRotina    := "FINA200"
	nLenOcor   := 0
	cPosOcor   := ""
	lDDA       := .F.

	PRIVATE m_pag , cbtxt , cbcont , li 

	//Essas variaveis tem que ser private para serem manipuladas
	//nos pontos de entrada, assim como eh feito no FINA200
	Private cNumTit
	Private dBaixa
	Private cTipo
	Private cNossoNum
	Private nDespes  := 0
	Private nDescont := 0
	Private nAbatim  := 0
	Private nValrec  := 0
	Private nJuros   := 0
	Private nMulta   := 0
	Private nValCc   := 0
	Private dCred
	Private cOcorr
	Private xBuffer

	If mv_par08 == 3 .and. mv_par07 == 2
		HELP(' ',1,"Aviso" ,,STR0060,2,0,,,,,, {STR0061}) //"O uso da pergunta 'Configura豫o CNAB ?' = Modelo PIX ?permitida apenas para a carteira Receber."  "Para o uso da carteira Pagar, utilize a op?o Modelo 1 ou Modelo 2."
		Return .F.
	Endif

	If __lFuncVldEx == Nil
		__lFuncVldEx := FindFunction("VldExtCNAB")
	EndIf

	// Guarda area do contas a receber ou contas a pagar				
	If MV_PAR07 == 1
		aSE1_SE2  := SE1->(GetArea())
		cParamSX6 := "MV_FEXRETR"
	Else
		aSE1_SE2  := SE2->(GetArea())
		cParamSX6 := "MV_FEXRETP"
		cRotina   := "FINA430"
	EndIf

	oReport:SetTitle(STR0004+' - '+mv_par01)		//"Impressao do Retorno da Comunicacao Bancaria"

	dbSelectArea("SEE")
	If !lExecJob
		lCadBco := SEE->(DbSeek(xFilial("SEE")+mv_par03+mv_par04+mv_par05+mv_par06))
	EndIf

	If mv_par08 == 3 .And. SEE->EE_NRBYTES <> 750 .And. lCadBco
		HELP(' ',1,"NRBYTESPIX" ,,STR0067,2,0,,,,,, {STR0068}) //"A sub-conta definida nos par?etros possui o N?ero de Bytes (EE_NRBYTES) diferente de 750." "Para a utiliza豫o do relat?io com layout PIX ?necessario configurar no cadastro de Par?etros Bancos (FINA130) o campo N?ero Bytes (EE_NRBYTES) = 750"
		Return .F.
	Endif

	If !lCadBco
		Set Device To Screen
		Set Printer To
		Help(" ",1,"NOBCOCAD")
		Return .F.
	Endif

	//Busca tamanho do detalhe na configura豫odo banco
	If mv_par08 == 3
		nTamDet := Iif(Empty(SEE->EE_NRBYTES), 750, SEE->EE_NRBYTES)
	Else
		nTamDet := Iif(Empty(SEE->EE_NRBYTES), 400, SEE->EE_NRBYTES)
	EndIf

	nTamDet += 2
	cTabela := Iif( Empty(SEE->EE_TABELA), "17" , SEE->EE_TABELA )

	If SEE->(ColumnPos("EE_TAMMOTB")) .and. SEE->EE_TAMMOTB>0
		nTamMotB := SEE->EE_TAMMOTB
	EndIf

	If __lFuncVldEx
		cExtensoes := SuperGetMV(cParamSX6, .F., "")
	EndIf

	dbSelectArea( "SX5" )
	If !SX5->( dbSeek( cFilial + cTabela ) )
		Help(" ",1,"PAR150")
	Return .F.
	Endif

	While !SX5->(Eof()) .and. SX5->X5_TABELA == cTabela
		AADD(aTabela, {Alltrim(X5Descri()), Pad(SX5->X5_CHAVE, Len(IIF(mv_par07 == 1, SE1->E1_TIPO, SE2->E2_TIPO)))}) 
		SX5->(dbSkip( ))
	Enddo               

	If !FILE(mv_par02)
			Set Device To Screen
			Set Printer To
			Help(" ",1,"NOARQPAR")
			Return .F.
	ElseIf __lFuncVldEx .And. !Empty(cExtensoes) .And. !VldExtCNAB(SubStr(MV_PAR02, At(".", MV_PAR02) + 1), cRotina)
		Return .F.
	EndIf
		
	If (mv_par08 == 1 .Or. mv_par08 == 3)
		cArqConf := mv_par02
		//Abre arquivo de configura豫o	
		nHdlConf := FOPEN(cArqConf, 0+64)
		
		//Ler arquivo de configura豫o
		nLidos := 0
		FSEEK(nHdlConf, 0, 0)
		nTamArq := FSEEK(nHdlConf, 0, 2)
		FSEEK(nHdlConf, 0, 0)
		
		If mv_par08 == 3		
			aPosicoes := FinCnabPix(nHdlConf, nTamArq)
			
			If !(Len(aPosicoes) >= 2 .And. Len(aPosicoes[1]) >= 12 .And. Len(aPosicoes[2]) >= 11)
				Help(" ", 1, "ARQCONFPIX", Nil, STR0069, 2, 0, Nil, Nil, Nil, Nil, Nil, {})
				FwFreeArray(aPosicoes)
				Return .F.	
			EndIf
		Else
			While nLidos <= nTamArq
				//Verifica o tipo de qual registro foi lido
				xBuffer := Space(85)
				FREAD(nHdlConf, @xBuffer, 85)
				
				If mv_par07 == 1 .And. MV_PAR08 == 1 .And. Upper(SubStr(xBuffer, 2, 9)) $  "CHAVE PIX"
					Help(' ', 1, "AVISO", Nil, STR0066, 1, 0)
					Return .F.
				ElseIf MV_PAR08 == 1 .And. ((".2RR" $ cArqConf) .OR. (".2PR" $ cArqConf))
					HELP(' ', 1, "AVISO", Nil, STR0062, 2, 0, Nil, Nil, Nil, Nil, Nil, {STR0063})
					Return .F.	
				EndIf
				
				If SubStr(xBuffer, 1, 1) == CHR(1)
					nLidos += 85
					Loop
				EndIf
				
				IF !lPosNum
					cPosNum:=Substr(xBuffer,17,10)
					nLenNum:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
					lPosNum:=.t.
					nLidos+=85
					Loop
				EndIF
				
				IF !lPosData
					cPosData:=Substr(xBuffer,17,10)
					nLenData:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
					lPosData:=.t.
					nLidos+=85
					Loop
				EndIF
				
				IF !lPosDesp
					cPosDesp:=Substr(xBuffer,17,10)
					nLenDesp:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
					lPosDesp:=.t.
					nLidos+=85
					Loop
				EndIF
				
				IF !lPosDesc
					cPosDesc:=Substr(xBuffer,17,10)
					nLenDesc:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
					lPosDesc:=.t.
					nLidos+=85
					Loop
				EndIF
				
				IF !lPosAbat
					cPosAbat:=Substr(xBuffer,17,10)
					nLenAbat:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
					lPosAbat:=.t.
					nLidos+=85
					Loop
				EndIF
				
				IF !lPosPrin
					cPosPrin:=Substr(xBuffer,17,10)
					nLenPrin:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
					lPosPrin:=.t.
					nLidos+=85
					Loop
				EndIF
				
				IF !lPosJuro
					cPosJuro:=Substr(xBuffer,17,10)
					nLenJuro:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
					lPosJuro:=.t.
					nLidos+=85
					Loop
				EndIF
				
				IF !lPosMult
					cPosMult:=Substr(xBuffer,17,10)
					nLenMult:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
					lPosMult:=.t.
					nLidos+=85
					Loop
				EndIF
				
				IF !lPosOcor
					cPosOcor:=Substr(xBuffer,17,10)
					nLenOcor:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
					lPosOcor:=.t.
					nLidos+=85
					Loop
				EndIF
				
				IF !lPosTipo
					cPosTipo:=Substr(xBuffer,17,10)
					nLenTipo:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
					lPosTipo:=.t.
					nLidos+=85
					Loop
				EndIF
				
				If mv_par07 == 1 // Somente cart receber deve ler estes campos
					IF !lPosIof
						cPosIof:=Substr(xBuffer,17,10)
						nLenIof:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
						lPosIof:=.t.
						nLidos+=85
						Loop
					EndIF
					IF !lPosCC
						cPosCC:=Substr(xBuffer,17,10)
						nLenCC:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
						lPosCC:=.t.
						nLidos+=85
						Loop
					EndIF
					IF !lPosDtCc
						cPosDtCc:=Substr(xBuffer,17,10)
						nLenDtCc:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
						lPosDtCc:=.t.
						nLidos+=85
						Loop
					EndIF
				EndIf	
			
				IF !lPosNosso
					cPosNosso:=Substr(xBuffer,17,10)
					nLenNosso:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
					lPosNosso:=.t.
					nLidos+=85
					Loop
				EndIF
				
				IF !lPosRej
					cPosRej:=Substr(xBuffer,17,10)
					nLenRej:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
					lPosRej:=.t.
					nLidos+=85
					Loop
				EndIF
				
				If mv_par07 == 2
					IF !lPosForne
						cPosForne := Substr(xBuffer,17,10)
						nLenForne := 1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
						lPosForne := .t.
						nLidos += 85
						Loop
					EndIF
					IF !lPosCgc
						cPosCgc   := Substr(xBuffer,17,10)
						nLenCgc   := 1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
						lPosCgc   := .t.
						nLidos += 85
						Loop
					EndIF
				Endif
				Exit
			EndDo
		EndIf
		
		//Fecha arquivo de configuracao
		Fclose(nHdlConf)
	Endif

	MV_PAR01 := Alltrim(MV_PAR01)
	cLocRec  := Alltrim(cLocRec)

	//Verifica se o arquivo de entrada esta na maquina local, e se estiver copia para o servidor
	If Substr(mv_par01,2,2)== ":"+cBarra
		aFile := Directory(Alltrim(mv_par01))
		If Empty(aFile)
			Help(" ",1,"NOARQENT")
			Return .F.
		Else	
			cFileName := aFile[1][1]
			cDestino := GetSrvProfString("StartPath","")+If(Right(GetSrvProfString("StartPath",""),1) == cBarra,"",cBarra)+"CNABTmp"
			If !File(cDestino)
				MAKEDIR(cDestino)
			EndIf
			If CpyT2S(mv_par01,cDestino,.T.)
				cArqEnt := cDestino+cBarra+cFileName
			Else
				Help(" ",1,"F650COPY",,STR0049,1,0) //"N? foi poss?el copiar o arquivo de entrada para o servidor. O arquivo ser?processado a partir da m?uina local, para um melhor desempenho, copie o arquivo diretamente no servidor."
			EndIf
		EndIf
	Else
		If Empty(cLocRec)	
			If File(MV_PAR01)
				cArqEnt := MV_PAR01
			Else
				Help( Nil, Nil, STR0056, Nil , STR0057 + MV_PAR01 + ", " + STR0059 , 1, 0 )  //"Arquivo n? Encontrado" # "O arquivo " #  " "Informado no caminho " # "n? foi localizado. Favor verificar"
				Return .F.
			Endif
		Else
			If AT("/", MV_PAR01) > 0 .Or. AT("\", MV_PAR01) > 0 .Or. AT(":", MV_PAR01) > 0
				If File(MV_PAR01)
					cArqEnt := MV_PAR01
				Else
					cCamArq  := cLocRec + MV_PAR01
					If File(cCamArq)
						cArqEnt := cCamArq
					Else
						Help( Nil, Nil, STR0056, Nil , STR0057 + MV_PAR01 + "," + STR0058 + cCamArq + STR0059 , 1, 0 )  //"Arquivo n? Encontrado" # "O arquivo " #  " "Informado no caminho " # "n? foi localizado. Favor verificar"
						Return .F.
					Endif
				Endif
			Else
				If ! SubStr(cLocRec, Len(cLocRec), 1 ) $ "/|\|"
					If lBarra
						cLocRec := cLocRec + "/"
					Else
						cLocRec := cLocRec + "\"
					Endif
				Endif
				
				cCamArq  := cLocRec + MV_PAR01
				If File(cCamArq)
					cArqEnt := cCamArq
				Else
					If !lExecJob
						Help( Nil, Nil, STR0056, Nil , STR0057 + MV_PAR01 + "," + STR0058 + cCamArq + STR0059 , 1, 0 )  //"Arquivo n? Encontrado" # "O arquivo " #  " "Informado no caminho " # "n? foi localizado. Favor verificar"
						Return .F.
					Else
						Return .F.
					Endif
				Endif
			Endif
		Endif
	EndIf

	//Abre arquivo enviado pelo banco
	If !FILE(cArqEnt)
		Set Device To Screen
		Set Printer To
		Help(" ",1,"NOARQENT")
		Return .F.
	Else
		nHdlBco:=FOPEN(cArqEnt,0+64)
	EndIf

	//L?arquivo enviado pelo banco
	nLidos:=0
	FSEEK(nHdlBco,0,0)
	nTamArq:=FSEEK(nHdlBco,0,2)
	FSEEK(nHdlBco,0,0)

	//旼컴컴컴컴컴컴컴컴컴컴컴컴?
	//?Define Valores da Secao ?
	//읕컴컴컴컴컴컴컴컴컴컴컴컴?
	oSection1:Cell("SEC1_TIT"):SetBlock({||cNumTit+' '+cEspecie})
	oSection1:Cell("SEC1_CLI"):SetBlock({||cCliFor})
	oSection1:Cell("SEC1_OCOR"):SetBlock({||Subs(cDescr,1,26)})
	oSection1:Cell("SEC1_DTOCOR"):SetBlock({||dBaixa})
	oSection1:Cell("SEC1_VORIG"):SetBlock({||nValOrig})
	oSection1:Cell("SEC1_DCOB"):SetBlock({||nDespes})
	oSection1:Cell("SEC1_VDESC"):SetBlock({||nDescont})
	oSection1:Cell("SEC1_VABAT"):SetBlock({||nAbatim})
	oSection1:Cell("SEC1_VJURO"):SetBlock({||(nJuros+nMulta)})
	oSection1:Cell("SEC1_NTIT"):SetBlock({||Pad(cNossoNum,19)})
	oSection1:Cell("SEC1_CONS"):SetBlock({||cDescr2})
											
	oSection2:Cell("STOT_TIT"):SetBlock({||nTit})
	oSection2:Cell("STOT_VORIG"):SetBlock({||nVOrig})

	oSection2:Cell("STOT_DCOB"):SetBlock({||nDCOB})
	oSection2:Cell("STOT_VDESC"):SetBlock({||nVDESC})
	oSection2:Cell("STOT_VABAT"):SetBlock({||nVABAT})
	oSection2:Cell("STOT_VJURO"):SetBlock({||nVJURO})

	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//?Totalizador                ?
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴켸

	TRFunction():New (oSection2:Cell("STOT_VORIG"),,"SUM",,,"@E 99999,999.99",,.F.,.T.)
	TRFunction():New (oSection2:Cell("STOT_DCOB"),,"SUM",,,"@E 99999,999.99",,.F.,.T.)
	TRFunction():New (oSection2:Cell("STOT_VDESC"),,"SUM",,,"@E 99999,999.99",,.F.,.T.)
	TRFunction():New (oSection2:Cell("STOT_VABAT"),,"SUM",,,"@E 99999,999.99",,.F.,.T.)
	TRFunction():New (oSection2:Cell("STOT_VJURO"),,"SUM",,,"@E 99999,999.99",,.F.,.T.)

	If mv_par07 == 1
		oSection1:Cell("SEC1_VPAGO"):Disable()            
		oSection2:Cell("STOT_VPAGO"):Disable()
		
		oSection1:Cell("SEC1_VIOF"):SetBlock({||nValIof})
		oSection1:Cell("SEC1_OCRED"):SetBlock({||nValCc})
		oSection1:Cell("SEC1_DTCRED"):SetBlock({||If(Empty(dCred),dDataBase,dCred)})
	
		oSection1:Cell("SEC1_VRECE"):SetBlock({||nValRec})
		oSection2:Cell("STOT_VIOF"):SetBlock({||nVIOF})
		oSection2:Cell("STOT_OCRED"):SetBlock({||nOCRED})
		oSection2:Cell("STOT_VRECE"):SetBlock({||nVReceb})
		
		TRFunction():New (oSection2:Cell("STOT_VIOF"),,"SUM",,,"@E 99999,999.99",,.F.,.T.)
		TRFunction():New (oSection2:Cell("STOT_OCRED"),,"SUM",,,"@E 99999,999.99",,.F.,.T.)
		TRFunction():New (oSection2:Cell("STOT_VRECE"),,"SUM",,,"@E 99999,999.99",,.F.,.T.)
	Else                                      
		oSection1:Cell("SEC1_VRECE"):Disable()
		oSection1:Cell("SEC1_VIOF"):Disable()
		oSection1:Cell("SEC1_OCRED"):Disable()
		oSection1:Cell("SEC1_DTCRED"):Disable()
		oSection2:Cell("STOT_VIOF"):Disable()
		oSection2:Cell("STOT_OCRED"):Disable()
		oSection2:Cell("STOT_VRECE"):Disable()	

		oSection1:Cell("SEC1_VPAGO"):SetBlock({||nValRec})
		oSection2:Cell("STOT_VPAGO"):SetBlock({||nVReceb})
		
		TRFunction():New (oSection2:Cell("STOT_VPAGO"),,"SUM",,,"@E 99999,999.99",,.F.,.T.)
	EndIf

	//Carrega atributos do arquivo de configuracao
	aArqConf := Directory(mv_par02)
	oReport:SetTotalText(STR0023)
	oReport:SetTotalinLine(.F.)
	oReport:SetMeter(nTamArq/nTamDet)

	oSection1:Init()
	While (nTamArq-nLidos) >= nTamDet
		If oReport:Cancel() .And. oReport:Cancel()
			Exit
		EndIf
		
		lRej      := .F.
		lProcessa := .T.
		cRej      := ""
		nVlrAces  := 0
		nSaldoTit := 0	
		
		If mv_par08 == 1
			//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
			//?Tipo qual registro foi lido ?
			//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
			xBuffer:=Space(nTamDet)
			FREAD(nHdlBco,@xBuffer,nTamDet)

			oReport:IncMeter()

			IF !lHeader
				nLidos+=nTamDet
				lHeader := .t.
				Loop
			EndIF

			IF	SubStr(xBuffer,1,1) == "0" .or. SubStr(xBuffer,1,1) == "9" .or. ;
				SubStr(xBuffer,1,1) == "8" .or. SubStr(xBuffer,1,1) == "5"
				nLidos+=nTamDet
				Loop
			EndIF

			If SubStr(xBuffer,1,1) $ "1#F#J#7#2" .or. Substr(xBuffer,1,3) == "001"
				nDespes :=0
				nDescont:=0
				nAbatim :=0
				nValRec :=0
				nJuros  :=0
				nMulta  :=0
				If mv_par07 == 1						// somente carteira receber
					nValIof :=0
					nValCc  :=0
					dCred   :=ctod("  /  /  ")			
				Else
					cCgc := " "
				EndIf	
				cData   :=""
				dBaixa  :=ctod("  /  /  ")
				cEspecie:="  "
				cNossoNum:=Space(15)
				cForne:= Space(8)

				//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
				//?L� os valores do arquivo Retorno ?
				//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
				IF !Empty(cPosDesp)
					nDespes:=Val(Substr(xBuffer,Int(Val(Substr(cPosDesp,1,3))),nLenDesp))/100
				EndIF
				IF !Empty(cPosDesc)
					nDescont:=Val(Substr(xBuffer,Int(Val(Substr(cPosDesc,1,3))),nLenDesc))/100
				EndIF
				IF !Empty(cPosAbat)
					nAbatim:=Val(Substr(xBuffer,Int(Val(Substr(cPosAbat,1,3))),nLenAbat))/100
				EndIF
				IF !Empty(cPosPrin)
					nValRec :=Val(Substr(xBuffer,Int(Val(Substr(cPosPrin,1,3))),nLenPrin))/100
				EndIF
				IF !Empty(cPosJuro)
					nJuros  :=Val(Substr(xBuffer,Int(Val(Substr(cPosJuro,1,3))),nLenJuro))/100
				EndIF
				IF !Empty(cPosMult)
					nMulta  :=Val(Substr(xBuffer,Int(Val(Substr(cPosMult,1,3))),nLenMult))/100
				EndIF
				IF !Empty(cPosIof)
					nValIof :=Val(Substr(xBuffer,Int(Val(Substr(cPosIof,1,3))),nLenIof))/100
				EndIF
				IF !Empty(cPosCc)
					nValCc :=Val(Substr(xBuffer,Int(Val(Substr(cPosCc,1,3))),nLenCc))/100
				EndIF
				IF !Empty(cPosNosso)
					cNossoNum :=Substr(xBuffer,Int(Val(Substr(cPosNosso,1,3))),nLenNosso)
				EndIF			
				IF !Empty(cPosForne)
					cForne  :=Substr(xBuffer,Int(Val(Substr(cPosForne,1,3))),nLenForne)
				Endif
				If !Empty(cPosCgc)
					cCgc  :=Substr(xBuffer,Int(Val(Substr(cPosCgc,1,3))),nLenCgc)
				Endif

				cDescr  := ""
				cNumTit :=Substr(xBuffer,Int(Val(Substr(cPosNum, 1,3))),nLenNum )
				
				If Empty(cNumTit) .And. nValRec <= 0
					nLidos += nTamDet
					Loop
				Endif
				
				dBaixa  := dDataBase
				cData := Substr(xBuffer,Int(Val(Substr(cPosData,1,3))),nLenData)
				
				If !Empty(cData)
					cData   := ChangDate(cData, SEE->EE_TIPODAT)
					dBaixa  := Ctod(Substr(cData, 1, 2) + "/" + Substr(cData, 3, 2) + "/" + Substr(cData, 5), "ddmm" + Replicate("y", Len(Substr(cData,5))))
				EndIf
				
				cTipo   :=Substr(xBuffer,Int(Val(Substr(cPosTipo, 1,3))),nLenTipo )
				cTipo   := Iif(Empty(cTipo),"NF ",cTipo)		// Bradesco
				
				IF !Empty(cPosDtCc)
					cData :=Substr(xBuffer, Int(Val(Substr(cPosDtCc, 1, 3))), nLenDtCc)
					dCred := Ctod(Substr(cData, 1, 2) + "/" + Substr(cData, 3, 2) + "/" + Iif(nLenDtCc > 7, Substr(cData, 7, 2), Substr(cData, 5, 2)), "ddmmyy")
				EndIF
				
				If nLenOcor == 2
					cOcorr  :=Substr(xBuffer,Int(Val(Substr(cPosOcor,1,3))),nLenOcor) + " "
				Else
					cOcorr  :=Substr(xBuffer,Int(Val(Substr(cPosOcor,1,3))),nLenOcor)
				EndIf	
				
				If nLenRej > 0
					cRej	:= Substr(xBuffer,Int(Val(Substr(cPosRej,1,3))),nLenRej) 
				EndIf	

				lOk := .T.
				//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
				//?o array aValores ir� permitir ?
				//?que qualquer exce뇙o ou neces-?
				//?sidade seja tratado no ponto  ?
				//?de entrada em PARAMIXB        ?
				//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
				// Estrutura de aValores
				//	Numero do T?ulo	- 01
				//	data da Baixa		- 02
				// Tipo do T?ulo		- 03
				// Nosso Numero		- 04
				// Valor da Despesa	- 05
				// Valor do Desconto	- 06
				// Valor do Abatiment- 07
				// Valor Recebido    - 08
				// Juros					- 09
				// Multa					- 10
				// Valor do Credito	- 11
				// Data Credito		- 12
				// Ocorrencia			- 13
				// Linha Inteira		- 14

				aValores := ( { cNumTit, dBaixa, cTipo, cNossoNum, nDespes, nDescont, nAbatim, nValRec, nJuros, nMulta, nValCc, dCred, cOcorr, xBuffer })

				// Template GEM
				If lF650Var
					ExecBlock("F650VAR",.F.,.F.,{aValores})
				ElseIf ExistTemplate("GEMBaixa")
					ExecTemplate("GEMBaixa",.F.,.F.,)
				Endif
			
				If !Empty(cTipo)
					//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
					//?Verifica especie do titulo    ?
					//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
					nPos := Ascan(aTabela, {|aVal|aVal[1] == AllTrim(Substr(cTipo,1,Len(IIF(mv_par07==1,SE1->E1_TIPO,SE2->E2_TIPO))))})
					If nPos != 0
						cEspecie := aTabela[nPos][2]
					Else
						cEspecie	:= "  "
					EndIf								
					If cEspecie $ MVABATIM			// Nao l� titulo de abatimento
						nLidos+=nTamDet
						Loop
					Endif

					//Busca por IDCNAB sem filial no indice
					lAchouTit := .F.
					dbSelectArea(IIF(mv_par07==1,"SE1","SE2"))
					dbSetOrder(IIF(mv_par07==1,19,13))
					cChave := Substr(cNumTit,1,10)

					If !Empty(cNumTit) .And. MsSeek(cChave)
						If ( mv_par07 == 1 )
							cEspecie  := SE1->E1_TIPO
						Else
							cEspecie  := SE2->E2_TIPO
						Endif
						lAchouTit := .T.
						nPos   	  := 1
					Endif

					// Localiza o titulo
					If lFr650Fil
						lAchouTit := Execblock("FR650FIL",.F.,.F.,{aValores})
					Endif

					// Busca pela chave antiga
					If !lAchouTit
						dbSetOrder(1)
						//Chave retornada pelo banco
						cChave650 := IIf(!Empty(cForne),Pad(cNumTit,nTamTit)+cEspecie+SubStr(cForne,1,nTamForn),Pad(cNumTit,nTamTit)+cEspecie) 
						While !lAchouTit
							If !dbSeek(xFilial()+cChave650)
								nPos := Ascan(aTabela, {|aVal|aVal[1] == AllTrim(Substr(cTipo,1,Len(IIF(mv_par07==1,SE1->E1_TIPO,SE2->E2_TIPO))))},nPos+1)
								If nPos != 0
									cEspecie := aTabela[nPos][2]
									cChave650 := IIf(!Empty(cForne),Pad(cNumTit,nTamTit)+cEspecie+SubStr(cForne,1,nTamForn),Pad(cNumTit,nTamTit)+cEspecie) 
								Else
									Exit
								Endif
							Else
								lAchouTit := .T.
							Endif					
						Enddo					
						
						//Chave retornada pelo banco com a adicao de espacos para tratar chave enviada ao banco com
						//tamanho de nota de 6 posicoes e retornada quando o tamanho da nota e 9 (atual)
						If !lAchouTit
							cNumTit := SubStr(cNumTit,1,nTamPre)+Padr(Substr(cNumTit,nTampre+1,nTamNum),nTamNum)+SubStr(cNumTit,nTamPre+nTamNum+1,nTamPar)
							cChave650 := IIf(!Empty(cForne),Pad(cNumTit,nTamTit)+cEspecie+SubStr(cForne,1,nTamForn),Pad(cNumTit,nTamTit)+cEspecie)
							nPos := Ascan(aTabela, {|aVal|aVal[1] == AllTrim(Substr(cTipo,1,Len(IIF(mv_par07==1,SE1->E1_TIPO,SE2->E2_TIPO))))})
							While !lAchouTit
								If !dbSeek(xFilial()+cChave650)
									nPos := Ascan(aTabela, {|aVal|aVal[1] == AllTrim(Substr(cTipo,1,Len(IIF(mv_par07==1,SE1->E1_TIPO,SE2->E2_TIPO))))},nPos+1)
									If nPos != 0
										cEspecie := aTabela[nPos][2]
										cChave650 := IIf(!Empty(cForne),Pad(cNumTit,nTamTit)+cEspecie+SubStr(cForne,1,nTamForn),Pad(cNumTit,nTamTit)+cEspecie)
									Else
										Exit
									Endif
								Else
									lAchouTit := .T.
								Endif
							Enddo
						Endif

						If lAchouTit
							If mv_par07 == 2
								cNumSe2   := SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO
								cChaveSe2 := IIf(!Empty(cForne),cNumSe2+SE2->E2_FORNECE,cNumSe2)
								nPosEsp	  := nPos	// Gravo nPos para volta-lo ao valor inicial, caso
													// Encontre o titulo
								While !Eof() .and. SE2->E2_FILIAL+cChaveSe2 == xFilial("SE2")+cChave650
									nPos := nPosEsp
									If Empty(cCgc)
										Exit
									Endif
									dbSelectArea("SA2")
									If dbSeek(xFilial()+SE2->E2_FORNECE+SE2->E2_LOJA)
										If Substr(SA2->A2_CGC,1,14) == cCGC .or. StrZero(Val(SA2->A2_CGC),14,0) == StrZero(Val(cCGC),14,0)
											Exit
										Endif
									Endif
									dbSelectArea("SE2")
									dbSkip()
									cNumSe2   := SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO
									cChaveSe2 := IIf(!Empty(cForne),cNumSe2+SE2->E2_FORNECE,cNumSe2)
									nPos 	  := 0
								Enddo
							Endif
						Endif
					EndIf
					If nPos == 0
						cEspecie	:= "  "
						cCliFor	:= "  "
					Else
						cEspecie := IIF(mv_par07==1,SE1->E1_TIPO,SE2->E2_TIPO)				
						cNumTit := IIF(mv_par07==1,SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA),SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA))
						cCliFor	:= IIF(mv_par07==1,SE1->E1_CLIENTE+" "+SE1->E1_LOJA,SE2->E2_FORNECE+" "+SE2->E2_LOJA)
					EndIF
					If cEspecie $ MVABATIM			// Nao l� titulo de abatimento
						nLidos += nTamDet
						Loop
					EndIf
				EndIF
			Else
				lProcessa := .F.
			Endif
		ElseIf mv_par08 == 3
			//Tipo qual registro foi lido
			xBuffer := Space(nTamDet)
			FREAD(nHdlBco, @xBuffer, nTamDet)
			oReport:IncMeter()
			
			If !lHeader
				nLidos  += nTamDet
				lHeader := .T.
				Loop
			EndIf
			
			/*
			Tipo 9 = Trailer
			Vers? 001 => Tipo 2 = Detalhe Informa寤es adicionais, Tipo 3 = Pix Link
			Vers? 002 => Tipo 2 = Detalhe Informa寤es adicionais, Tipo 4 = Gera豫o QrCode
			*/
			If !(cTipoReg := (SubStr(xBuffer, 1, 1))) $ "1|5"
				nLidos += nTamDet
				Loop
			EndIf
			
			nArray := Iif(cTipoReg == "1", 2, 1)
			
			If (!aPosicoes[nArray,1,3] .Or. !aPosicoes[nArray,3,3])
				nLidos += nTamDet
				Loop				
			EndIf		
			
			nDespes   := 0
			nDescont  := 0
			nAbatim   := 0
			nValRec   := 0
			nJuros    := 0
			nMulta    := 0
			cData     := ""
			dBaixa    := CtoD("  /  /  ")
			cEspecie  := "  "
			cNossoNum := Space(15)
			cForne    := Space(8)
			cDtVc     := ""
			nPos      := 0
			
			cIDTran := Substr(xBuffer, aPosicoes[nArray,1,1], aPosicoes[nArray,1,2])				
			cOcorr  := AllTrim(Substr(xBuffer, aPosicoes[nArray,3,1], aPosicoes[nArray,3,2]))
			
			If cTipoReg == "1"
				If aPosicoes[nArray,6,3]
					nValRec := Round(Val(Substr(xBuffer, aPosicoes[nArray,6,1], aPosicoes[nArray,6,2])) / 100, 2)
				EndIf			
				
				If aPosicoes[nArray,4,3]
					cDtVc := Substr(xBuffer, aPosicoes[nArray,4,1], aPosicoes[nArray,4,2])						
					cDtVc   := Substr(cDtVc, 7, 2) + "/" + Substr(cDtVc, 5, 2) + "/" + Substr(cDtVc, 1, 4)
				EndIf
				
				dDtVenc := CtoD(cDtVc, "ddmmyy")
				
				If aPosicoes[nArray,7,3]
					cData  := Substr(xBuffer, aPosicoes[nArray,7,1], aPosicoes[nArray,7,2])
					cData  := Substr(cData, 7, 2) + "/" + Substr(cData, 5, 2) + "/" + Substr(cData, 1, 4)
				EndIf
				
				dBaixa := Ctod(cData, "ddmmyy")			
				
				If aPosicoes[nArray,8,3]				 
					cRej    := AllTrim(Substr(xBuffer, aPosicoes[nArray,8,1], aPosicoes[nArray,8,2])) 
					nLenRej := aPosicoes[nArray,8,2]
				EndIf
			Else
				If aPosicoes[nArray,4,3]
					cData  := Substr(xBuffer, aPosicoes[nArray,4,1], aPosicoes[nArray,4,2])
					cData  := Substr(cData, 7, 2) + "/" + Substr(cData, 5, 2) + "/" + Substr(cData, 1, 4)
				EndIf
				
				dBaixa := Ctod(cData, "ddmmyy")
				
				If aPosicoes[nArray,5,3]
					cDtVc := Substr(xBuffer, aPosicoes[nArray,5,1], aPosicoes[nArray,5,2])
					cDtVc := Substr(cDtVc, 7, 2) + "/" + Substr(cDtVc, 5, 2) + "/" + Substr(cDtVc, 1, 4)
				EndIf
				
				dDtVenc := CtoD(cDtVc, "ddmmyy")
				
				If aPosicoes[nArray,7,3]
					nJuros := Round(Val(Substr(xBuffer, aPosicoes[nArray,7,1], aPosicoes[nArray,7,2])) / 100, 2)
				EndIf
				
				If aPosicoes[nArray,8,3]
					nMulta := Round(Val(Substr(xBuffer, aPosicoes[nArray,8,1], aPosicoes[nArray,8,2])) / 100, 2)
				EndIf
				
				If aPosicoes[nArray,9,3]
					nDescont := Round(Val(Substr(xBuffer, aPosicoes[nArray,9,1], aPosicoes[nArray,9,2])) / 100, 2)
				EndIf
				
				If aPosicoes[nArray,10,3]
					nDescont += Round(Val(Substr(xBuffer, aPosicoes[nArray,10,1], aPosicoes[nArray,10,2])) / 100, 2)
				EndIf
				
				If aPosicoes[nArray,12,3]
					nValRec := Round(Val(Substr(xBuffer, aPosicoes[nArray,12,1], aPosicoes[nArray,12,2])) / 100, 2)
				EndIf		
			EndIf
			
			dbSelectArea("F71")
			F71->(dbSetOrder(3))
			
			If !F71->(DbSeek(cIDTran))
				nLidos += nTamDet
				Loop			
			EndIf
			
			cNumTit  := F71->F71_NUM
			cTipo    := F71->F71_TIPO
			cParcela := F71->F71_PARCEL
			cPrefixo := F71->F71_PREFIX
			cBANCO   := F71->F71_CODBAN
			cAGENCIA := F71->F71_AGENCI
			cCONTA   := F71->F71_NUMCON		
			lOk      := .T.
			aValores := ( { cNumTit, dBaixa, cTipo, cNossoNum, nDespes, nDescont, nAbatim, nValRec, nJuros, nMulta, nValCc, dCred, cOcorr, xBuffer })		
			
			//Template GEM
			If (lF650Var .Or. lGEMBaixa)
				If lF650Var
					ExecBlock("F650VAR", .F., .F., {aValores})
				Else
					ExecTemplate("GEMBaixa", .F., .F., Nil)
				EndIf
			EndIf
			
			If (lProcessa := !Empty(cTipo))
				If (nPosEsp := AScan(aTabela, {|x| x[2] == cTipo})) > 0
					cEspecie := aTabela[nPosEsp,2]
				EndIf
				
				If cEspecie $ MVABATIM // N? l?t?ulos de abatimentos
					nLidos += nTamDet
					Loop
				Endif
				
				lAchouTit := .F.
				DbSelectArea("SE1")	
				
				If lFr650Fil
					lAchouTit := Execblock("FR650FIL",.F.,.F.,{aValores})
				EndIf
				
				If !lAchouTit
					SE1->(DbSetOrder(1))
					lAchouTit := SE1->(DbSeek(F71->F71_FILIAL+cPrefixo+cNumTit+cParcela+cTipo))
				EndIf
				
				If lAchouTit
					nPos     := 1
					cEspecie := SE1->E1_TIPO
					cNumTit  := SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA)
					cCliFor	 := SE1->E1_CLIENTE+" "+SE1->E1_LOJA
				EndIf
				
				If cEspecie $ MVABATIM
					nLidos += nTamDet
					Loop
				EndIf
			EndIf
		Else
			If ".CPR" $ MV_PAR02 .OR. ".RET" $ MV_PAR02
				HELP(' ',1,"Aviso" ,,STR0064,2,0,,,,,, {STR0065}) //"A pergunta 'Configura豫o CNAB ?' foi definida como 'Modelo 2' e o arquivo de configura豫o ?'Modelo 1' ou 'Modelo PIX'." "Para o uso deste layout, ajuste a pergunta 'Configura豫o CNAB ?' de acordo com o tipo de layout 'Modelo 1' ou 'Modelo PIX'."
				Return .F.		
			Endif		
			
			aLeitura := ReadCnab2(nHdlBco,MV_PAR02,nTamDet,aArqConf)
			cNumTit  := SubStr(aLeitura[1],1,nTamTit)
			
			If Empty(cNumTit) .And. Empty(aLeitura[05])
				nLidos += nTamDet
				Loop			
			Endif	

			cData  := aLeitura[04]
			dBaixa := dDataBase
			
			If !Empty(cData)
				cData    :=	ChangDate(cData,SEE->EE_TIPODAT)
				dBaixa   :=	Ctod(Substr(cData,1,2)+"/"+Substr(cData,3,2)+"/"+Substr(cData,5),"ddmm"+Replicate("y", Len(Substr(cData,5))))		
			EndIf
			
			cTipo    	:= aLeitura[02]
			cTipo    	:= Iif(Empty(cTipo),"NF ",cTipo)		// Bradesco
			cNossoNum   := aLeitura[11]
			nDespes  	:= aLeitura[06]
			nDescont 	:= aLeitura[07]
			nAbatim  	:= aLeitura[08]
			nValRec  	:= aLeitura[05]
			nJuros   	:= aLeitura[09]
			nMulta   	:= aLeitura[10]
			cOcorr   	:= PadR(aLeitura[03],3)
			
			If Len(Alltrim(cOcorr)) > 2 .And. mv_par07 == 2
				cOcorr := PadR( Left(Alltrim(cOcorr),2) , 3)
			EndIf
			
			nValIof		:= aLeitura[12]
			nValCC   	:= aLeitura[13]
			cData    	:= aLeitura[14]
			dDataCred   := dDataBase

			If !Empty(cData)
				cData     := ChangDate(cData, SEE->EE_TIPODAT)
				dDataCred := Ctod(Substr(cData, 1, 2) + "/" + Substr(cData, 3, 2) + "/" + Substr(cData, 5, 2),"ddmmyy")
			EndIf
			
			dDataUser	:= dDataCred
			dCred		:= dDataCred
			cRej		:= aLeitura[15] 
			cForne		:= aLeitura[16]
			xBuffer		:= aLeitura[17]

			If !(SubStr(xBuffer,14,1) == "J" .and. Substr(xBuffer,18,2) == "52")
				//CGC
				If Len(aLeitura) > 19
					cCgc := aLeitura[20]
				Else
					cCgc := " "
				Endif
			
				lOk := .t.
				lAchouTit := .F.
				//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
				//?o array aValores ir� permitir ?
				//?que qualquer exce뇙o ou neces-?
				//?sidade seja tratado no ponto  ?
				//?de entrada em PARAMIXB        ?
				//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
				// Estrutura de aValores
				//	Numero do T?ulo	- 01
				//	data da Baixa		- 02
				// Tipo do T?ulo		- 03
				// Nosso Numero		- 04
				// Valor da Despesa	- 05
				// Valor do Desconto	- 06
				// Valor do Abatiment- 07
				// Valor Recebido    - 08
				// Juros					- 09
				// Multa					- 10
				// Valor do Credito	- 11
				// Data Credito		- 12
				// Ocorrencia			- 13
				// Linha Inteira		- 14

				aValores := ( { cNumTit, dBaixa, cTipo, cNossoNum, nDespes, nDescont, nAbatim, nValRec, nJuros, nMulta, nValCc, dCred, cOcorr, xBuffer })
				nLenRej := Len(AllTrim(cRej))

				// Template GEM
				If lF650Var
					ExecBlock("F650VAR",.F.,.F.,{aValores})
				ElseIf ExistTemplate("GEMBaixa")
					ExecTemplate("GEMBaixa",.F.,.F.,)
				Endif 	


				//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
				//?Verifica especie do titulo    ?
				//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
				nPos := Ascan(aTabela, {|aVal|aVal[1] == AllTrim(Substr(cTipo,1,Len(IIF(mv_par07==1,SE1->E1_TIPO,SE2->E2_TIPO))))})
				If nPos != 0
					cEspecie := aTabela[nPos][2]
				Else
					cEspecie	:= "  "
				EndIf								
				If cEspecie $ MVABATIM			// Nao l� titulo de abatimento
					nLidos += nTamDet
					Loop
				Endif

				//Busca por IDCNAB sem filial no indice
				lAchouTit := .F.
				dbSelectArea(IIF(mv_par07==1,"SE1","SE2"))
				dbSetOrder(IIF(mv_par07==1,19,13))
				cChave := Substr(cNumTit,1,10)

				If !Empty(cNumTit) .And. MsSeek(cChave)
					If ( mv_par07 == 1 )
						cEspecie  := SE1->E1_TIPO
					Else
						cEspecie  := SE2->E2_TIPO
					Endif
					lAchouTit := .T.
					nPos   	  := 1
				Endif      
				
				// Localiza o titulo
				If lFr650Fil
					lAchouTit := Execblock("FR650FIL",.F.,.F.,{aValores})
				Endif
				
				// Busca pela chave antiga
				If !lAchouTit
					dbSetOrder(1)
					//Chave retornada pelo banco
					cChave650 := IIf(!Empty(cForne),Pad(cNumTit,nTamTit)+cEspecie+SubStr(cForne,1,nTamForn),Pad(cNumTit,nTamTit)+cEspecie) 
					While !lAchouTit
						If !dbSeek(xFilial()+cChave650)
							nPos := Ascan(aTabela, {|aVal|aVal[1] == AllTrim(Substr(cTipo,1,Len(IIF(mv_par07==1,SE1->E1_TIPO,SE2->E2_TIPO))))},nPos+1)
							If nPos != 0
								cEspecie := aTabela[nPos][2]
								cChave650 := IIf(!Empty(cForne),Pad(cNumTit,nTamTit)+cEspecie+SubStr(cForne,1,nTamForn),Pad(cNumTit,nTamTit)+cEspecie) 
							Else
								Exit
							Endif
						Else
							lAchouTit := .T.
						Endif					
					Enddo					
					
					//Chave retornada pelo banco com a adicao de espacos para tratar chave enviada ao banco com
					//tamanho de nota de 6 posicoes e retornada quando o tamanho da nota e 9 (atual)
					If !lAchouTit
						cNumTit := SubStr(cNumTit,1,nTamPre)+Padr(Substr(cNumTit,nTampre+1,nTamNum),nTamNum)+SubStr(cNumTit,nTamPre+nTamNum+1,nTamPar)
						cChave650 := IIf(!Empty(cForne),Pad(cNumTit,nTamTit)+cEspecie+SubStr(cForne,1,nTamForn),Pad(cNumTit,nTamTit)+cEspecie)
						While !lAchouTit
							If !dbSeek(xFilial()+cChave650)
								nPos := Ascan(aTabela, {|aVal|aVal[1] == AllTrim(Substr(cTipo,1,Len(IIF(mv_par07==1,SE1->E1_TIPO,SE2->E2_TIPO))))},nPos+1)
								If nPos != 0
									cEspecie := aTabela[nPos][2]
									cChave650 := IIf(!Empty(cForne),Pad(cNumTit,nTamTit)+cEspecie+SubStr(cForne,1,nTamForn),Pad(cNumTit,nTamTit)+cEspecie)
								Else
									Exit
								Endif
							Else
								lAchouTit := .T.
							Endif
						Enddo
					Endif

					If lAchouTit
						If mv_par07 == 2
							cNumSe2   := SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO
							cChaveSe2 := IIf(!Empty(cForne),cNumSe2+SE2->E2_FORNECE,cNumSe2)
							nPosEsp	  := nPos	// Gravo nPos para volta-lo ao valor inicial, caso
												// Encontre o titulo
							While !Eof() .and. SE2->E2_FILIAL+cChaveSe2 == xFilial("SE2")+cChave650
								nPos := nPosEsp
								If Empty(cCgc)
									Exit
								Endif
								dbSelectArea("SA2")
								If dbSeek(xFilial()+SE2->E2_FORNECE+SE2->E2_LOJA)
									If Substr(SA2->A2_CGC,1,14) == cCGC .or. StrZero(Val(SA2->A2_CGC),14,0) == StrZero(Val(cCGC),14,0)
										Exit
									Endif
								Endif
								dbSelectArea("SE2")
								dbSkip()
								cNumSe2   := SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO
								cChaveSe2 := IIf(!Empty(cForne),cNumSe2+SE2->E2_FORNECE,cNumSe2)
								nPos 	  := 0
							Enddo
						Endif
					Endif
				Endif
				If nPos == 0
					cEspecie	:= "  "
					cCliFor	:= "  "
				Else
					cEspecie := IIF(mv_par07==1,SE1->E1_TIPO,SE2->E2_TIPO)				
					cNumTit := IIF(mv_par07==1,SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA),SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA))
					cCliFor	:= IIF(mv_par07==1,SE1->E1_CLIENTE+" "+SE1->E1_LOJA,SE2->E2_FORNECE+" "+SE2->E2_LOJA)
				EndIF
				If cEspecie $ MVABATIM			// Nao l� titulo de abatimento
					nLidos += nTamDet
					Loop
				EndIf
			Else
				Loop
			Endif
		EndIf   
		
		If !lProcessa
			nLidos += nTamDet
			loop
		EndIf
		
		nValOrig := 0
		
		If mv_par07 == 1
			cCarteira := "R"
			
			If lAchouTit
				nValOrig := SE1->E1_VLCRUZ
			Endif
			
			If lFValAcess
				nVlrAces := FValAcess(SE1->E1_PREFIXO, SE1->E1_NUM, SE1->E1_PARCELA, SE1->E1_TIPO, SE1->E1_CLIENTE, SE1->E1_LOJA, SE1->E1_NATUREZ,;
				.F., "", "R", dDataBase, Nil, SE1->E1_MOEDA, SE1->E1_MOEDA, SE1->E1_TXMOEDA, "", .F.)		
			EndIf
		Else
			cCarteira := "P"
			
			If lAchouTit
				nValOrig := SE2->E2_VLCRUZ
			Endif
			
			If lFValAcess
				nVlrAces := FValAcess(SE2->E2_PREFIXO, SE2->E2_NUM, SE2->E2_PARCELA, SE2->E2_TIPO, SE2->E2_FORNECE, SE2->E2_LOJA, SE2->E2_NATUREZ,;
				.F., "", "P", dDataBase, Nil, SE2->E2_MOEDA, SE2->E2_MOEDA, SE2->E2_TXMOEDA, "", .F.)
				
				If SE2->E2_MOEDA > 1 .And. nVlrAces != 0
					nVlrAces := Round(xMoeda(nVlrAces, SE2->E2_MOEDA, 1, dBaixa, nCasDec, nTxMoeda), 2)
				EndIf 
			EndIf
		EndIf
		
		DbSelectArea("SEB")
		
		//Verifica se a despesa est?descontada do valor principal
		If SEE->EE_DESPCRD == "S"
			nValRec := nValRec+nDespes+nValIOF - nValCC
		EndIf      
		
		cRej := Padr(cRej, nTamMotB, " ")
		
		If mv_par08 != 3
			lDDA := .F.
			If (mv_par08 == 2) .And. (len(aLeitura) >= 25)
				lDDA := !Empty(aLeitura[25])
			EndIf
			If lDDA
				lAchouSEB := SEB->(dbSeek(cFilial+mv_par03+cOcorr+"D"))
			EndIf
			If !lDDA .Or. !lAchouSEB
				lAchouSEB := SEB->(dbSeek(cFilial+mv_par03+cOcorr+cCarteira+cRej))
			EndIf
			If !lDDA .And. !lAchouSEB //A inclus? do 2?dbSeek ?necess?io porque o preenchimento do campo EB_MOTBAN n? ?obrigat?io
				lAchouSEB := SEB->(dbSeek(cFilial+mv_par03+cOcorr+cCarteira))
			EndIf
			
			If lAchouSEB
				lOcorr := .T.
				cDescr := RTrim(cOcorr) + "-" + Subs(SEB->EB_DESCRI,1,27)
				
				//Ponto de entrada para alterar a descricao do relatorio
				If lF650Desc
					cDescr := ExecBlock("F650DESCR",.F.,.F.,{cDescr})
				EndIf
				
				//Efetua contagem dos SubTotais por ocorrencia
				nCntOco := Ascan(aCntOco, { |X| X[1] == cOcorr})
				
				If nCntOco == 0
					Aadd(aCntOco,{cOcorr,Subs(SEB->EB_DESCRI,1,27),nDespes,nDescont,nAbatim,nValRec,nJuros+nMulta,nValIof,nValCc,nValOrig})
				Else
					aCntOco[nCntOco][DESPESAS]     +=nDespes
					aCntOco[nCntOco][DESCONTOS]    +=nDescont
					aCntOco[nCntOco][ABATIMENTOS]  +=nAbatim
					aCntOco[nCntOco][VALORRECEBIDO]+=nValRec
					aCntOco[nCntOco][JUROS]        +=nJuros+nMulta
					aCntOco[nCntOco][VALORIOF]     +=nValIOF
					aCntOco[nCntOco][VALORCC]      +=nValCC
					aCntOco[nCntOco][VALORORIG]    +=nValOrig
				Endif
				
				If SEB->EB_OCORR $ "03?5?6?7?0?1?2"		//Registro rejeitado
					//Verifica tabela de rejeicao
					If nLenRej > 0
						cDescr := RTrim(cOcorr) + "(" + cRej + ")" + "-" + Substr(SEB->EB_DESCMOT,1,22)
					EndIf
					
					lRej := .T.	
				EndIf
			Endif
		Else
			If !(lAchouSEB := SEB->(dbSeek(xFilial("SEB")+mv_par03+PadR(cOcorr,3)+cCarteira+cRej)))
				//A inclus? do 2?dbSeek ?necess?io porque o preenchimento do campo EB_MOTBAN n? ?obrigat?io
				lAchouSEB := SEB->(dbSeek(xFilial("SEB")+mv_par03+PadR(cOcorr,3)+cCarteira)) 
			EndIf
			
			If lAchouSEB
				lOcorr := .T.
				cDescr := RTrim(cOcorr) + "-" + Subs(SEB->EB_DESCRI,1,27)
				
				If cOcorr == "03" .And. (lRej := (nLenRej > 0))
					cDescr := RTrim(cOcorr) + "(" + cRej + ")" + "-" + Substr(SEB->EB_DESCMOT,1,22)
				EndIf
				
				//Ponto de entrada para alterar a descricao do relatorio
				If lF650Desc
					cDescr := ExecBlock("F650DESCR",.F.,.F.,{cDescr})
				EndIf
				
				//Efetua contagem dos SubTotais por ocorrencia			
				If (nCntOco := Ascan(aCntOco, { |X| X[1] == cOcorr})) == 0
					Aadd(aCntOco, {cOcorr, Subs(SEB->EB_DESCRI, 1, 27), nDespes, nDescont, nAbatim, nValRec, nJuros + nMulta, nValIof, nValCc, nValOrig})
				Else
					aCntOco[nCntOco][DESPESAS]     +=nDespes
					aCntOco[nCntOco][DESCONTOS]    +=nDescont
					aCntOco[nCntOco][ABATIMENTOS]  +=nAbatim
					aCntOco[nCntOco][VALORRECEBIDO]+=nValRec
					aCntOco[nCntOco][JUROS]        +=nJuros+nMulta
					aCntOco[nCntOco][VALORIOF]     +=nValIOF
					aCntOco[nCntOco][VALORCC]      +=nValCC
					aCntOco[nCntOco][VALORORIG]    +=nValOrig
				Endif
			EndIf
		EndIf
		
		If !lOcorr
			cDescr  := Space(29)
			
			If (nCntOco := (Ascan(aCntOco, {|X| X[2] == STR0016}))) == 0
				Aadd(aCntOco, {"00 ", STR0016, nDespes, nDescont, nAbatim, nValRec, (nJuros+nMulta), nValIof, nValCc, nValOrig})
			Else
				aCntOco[nCntOco][DESPESAS]     +=nDespes
				aCntOco[nCntOco][DESCONTOS]    +=nDescont
				aCntOco[nCntOco][ABATIMENTOS]  +=nAbatim
				aCntOco[nCntOco][VALORRECEBIDO]+=nValRec
				aCntOco[nCntOco][JUROS]        +=nJuros+nMulta
				aCntOco[nCntOco][VALORIOF]     +=nValIOF
				aCntOco[nCntOco][VALORCC]      +=nValCC
				aCntOco[nCntOco][VALORORIG]    +=nValOrig
			Endif
		EndIf

		If mv_par07 == 1
			dbSelectArea("SE1")
		Else
			dbSelectArea("SE2")
		EndIf
			
		If Empty(cOcorr)
			lPrint  := Empty(cDescr2)
			cDescr2 := OemToAnsi(STR0015)  	//"OCORRENCIA NAO ENVIADA"
			lOk     := PRINTLINE(oReport,lPrint)
		ElseIf !lOcorr
			lPrint  := Empty(cDescr2)
			cDescr2 := OemToAnsi(STR0016)  //"OCORRENCIA NAO ENCONTRADA"
			lOk     := PRINTLINE(oReport,lPrint)
		EndIf

		If dBaixa < dDataFin
			lPrint  := Empty(cDescr2)
			cDescr2 := OemToAnsi(STR0026)		//"DATA MENOR QUE DATA FECH.FINANCEIRO"
			lOk     := PRINTLINE(oReport,lPrint)
		Endif

		IF Empty(cNumTit) 
			lPrint  := Empty(cDescr2)
			cDescr2 := OemToAnsi(STR0017)  	//"NUMERO TITULO NAO ENVIADO"
			lOk     := PRINTLINE(oReport,lPrint)
		EndIf

		If !lAchouTit                     
			lPrint  := Empty(cDescr2)
			cDescr2 := OemToAnsi(STR0018)  	//"TITULO NAO ENCONTRADO"
			lOk     := PRINTLINE(oReport,lPrint)
		Endif

		IF Substr(dtoc(dBaixa),1,1)=' '   
			lPrint  := Empty(cDescr2)
			cDescr2 := OemToAnsi(STR0019) 		//"DATA DE BAIXA NAO ENVIADA"
			lOk     := PRINTLINE(oReport,lPrint)
		EndIF

		IF Empty(cTipo)                       
			lPrint  := Empty(cDescr2)
			cDescr2 := OemToAnsi(STR0020)  	//"ESPECIE NAO ENVIADA"
			lOk     := PRINTLINE(oReport,lPrint)
		Endif

		If Empty(cEspecie)
			lPrint  := Empty(cDescr2)
			cDescr2 := OemToAnsi(STR0021)  	//"ESPECIE NAO ENCONTRADA"
			lOk     := PRINTLINE(oReport, lPrint)           	
		Endif
		
		If mv_par07 == 1 .And. lAchouTit .and. nAbatim == 0 .And. SE1->E1_SALDO > 0
			nValPadrao := ((nValRec - (nJuros+nMulta+nValCC)) + nDescont) - nVlrAces
			nTotAbat   := SumAbatRec(Substr(cNumtit, 1, nTamPre), Substr(cNumtit, (nTamPre+1), nTamNum), Substr(cNumtit, (nTamPre+nTamNum+1), nTamPar), 1, "S")
			nSaldoTit  := Round(xMoeda(SE1->E1_SALDO, SE1->E1_MOEDA, 1, dBaixa, nCasDec, SE1->E1_TXMOEDA), 2)
			nSaldoTit  := ((nSaldoTit + SE1->E1_SDACRES) - (SE1->(E1_SDDECRE + E1_VLBOLSA) + nTotAbat))
			
			If nValPadrao > 0
				If nSaldoTit < nValPadrao
					lPrint  := Empty(cDescr2)
					cDescr2 := STR0050 //VLR REC MAIOR
					lOk     := PRINTLINE(oReport, lPrint)
				ElseIf nSaldoTit > nValPadrao
					lPrint  := Empty(cDescr2)
					cDescr2 := STR0051 //VLR REC MENOR
					lOk     := PRINTLINE(oReport, lPrint)
				Endif		
			EndIf
		EndIf
		
		If mv_par07 == 2 .and. lAchouTit .and. nAbatim == 0 .and. SE2->E2_SALDO > 0
			nValPadrao := ((nValRec - (nJuros+nMulta)) + nDescont) - nVlrAces 
			nTotAbat   := SumAbatPag(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_FORNECE,SE2->E2_MOEDA,"S",dDatabase,SE2->E2_LOJA)
			
			If SE2->E2_MOEDA > 1
				If lF430TXBX
					aTitulo  := {SE2->E2_FILIAL, SE2->E2_PREFIXO, SE2->E2_NUM, SE2->E2_PARCELA, SE2->E2_TIPO, SE2->E2_FORNECE, SE2->E2_LOJA, dBaixa}
					aAreaSE2 := SE2->(GetArea())
					nTxMoeda := ExecBlock("F430TXBX", .F., .F., aTitulo)
					
					If nTxMoeda == 0 .And. SE2->E2_TXMOEDA != 0 
						nTxMoeda := SE2->E2_TXMOEDA
					EndIf
					
					RestArea(aAreaSE2)
					FwFreeArray(aAreaSE2)
					FwFreeArray(aTitulo)
				Else
					If (((nTxMoeda := SE2->E2_TXMOEDA) <= 0) .Or. !Empty(SE2->E2_DTVARIA))
						nTxMoeda := RecMoeda(Iif(Empty(SE2->E2_DTVARIA), dBaixa, SE2->E2_DTVARIA), SE2->E2_MOEDA)
					EndIf				
				EndIf
			EndIf
			
			nSaldoTit := Round(xMoeda(SE2->E2_SALDO, SE2->E2_MOEDA, 1, dBaixa, nCasDec, nTxMoeda), 2)
			nSaldoTit := ((nSaldoTit + SE2->E2_SDACRES) - (SE2->E2_SDDECRE + nTotAbat))
			
			If nValPadrao > 0
				If nSaldoTit < nValPadrao
					lPrint 	:= Empty(cDescr2)
					cDescr2 := STR0052 //"VLR PAGO MAIOR"
					lOk 	:= PRINTLINE(oReport,lPrint)
				EndIf
				
				If nSaldoTit > nValPadrao
					lPrint := Empty(cDescr2)
					cDescr2 := STR0053 //"VLR PAGO MENOR"
					lOk := PRINTLINE(oReport,lPrint)
				Endif
			EndIf
		EndIf
		
		//Informa a condicao da baixa do titulo
		If lOk
			If mv_par07 == 1
				If SE1->E1_SALDO == 0
					lPrint  := Empty(cDescr2)
					cDescr2 := STR0028 //"BAIXADO ANTERIORMENTE - TOTAL"
					lOk     := PRINTLINE(oReport,lPrint)
				ElseIf SE1->E1_VALOR <> SE1->E1_SALDO
					lPrint  := Empty(cDescr2)
					cDescr2 := STR0029 //"BAIXADO ANTERIORMENTE - PARCIAL"
					lOk     := PRINTLINE(oReport,lPrint)
				EndIf
			Else
				If SE2->E2_SALDO == 0
					lPrint  := Empty(cDescr2)
					cDescr2 := STR0028 //"BAIXADO ANTERIORMENTE - TOTAL"
					lOk 	:= PRINTLINE(oReport,lPrint)
				ElseIf SE2->E2_VALOR <> SE2->E2_SALDO
					lPrint  := Empty(cDescr2)
					cDescr2 := STR0029 //"BAIXADO ANTERIORMENTE - PARCIAL"
					lOk 	:= PRINTLINE(oReport,lPrint)
				EndIf
			EndIf	
			
			If lOk
				lPrint := Empty(cDescr2)
				
				If lRej
					cDescr2 := OemToAnsi(STR0055)  	//"TITULO REJEITADO"
				Else
					If mv_par07 == 1
						cDescr2 := OemToAnsi(STR0022)  	//"TITULO RECEBIDO"
					Else
						cDescr2 := OemToAnsi(STR0030)  	//"TITULO PAGO"
					Endif
				EndIf	
				
				lOk := PRINTLINE(oReport, lPrint)
			EndIf
		EndIf
		
		nLidos += nTamDet
		cDescr2 := ""
		cDescr := ""
	EndDO

	If mv_par08 == 3 .And. aPosicoes != Nil
		FwFreeArray(aPosicoes)
	EndIf

	oSection1:Finish()

	//Imprime Subtotais por ocorrencia
	oSection2:Init()

	For x :=1 to Len(aCntOco)
		nTit    := aCntOco[x][1] + Substr(aCntOco[x][2],1,30)
		nVOrig  := aCntOco[x][10]
		nVReceb := aCntOco[x][6]
		nDCOB   := aCntOco[x][3]
		nVDESC  := aCntOco[x][4]
		nVABAT  := aCntOco[x][5]
		nVJURO  := aCntOco[x][7]
		nVIOF   := aCntOco[x][8]
		nOCRED  := aCntOco[x][9]
		
		oSection2:PrintLine()
	Next
	oSection2:Finish()

	//Restaura area do contas a receber ou contas a pagar
	RestArea(aSE1_SE2)

	//Fecha os Arquivos ASCII
	fClose(nHdlBco)
	fClose(nHdlConf)

	If FILE(cDestino+cBarra+cFileName)
		FErase(cDestino+cBarra+cFileName)
	EndIf

	Return NIL

	/*/
	複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複
	굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇
	굇旼컴컴컴컴컫컴컴컴컴컴컫컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컫컴컴컴쩡컴컴컴컴커굇
	굇?un뇚o    ?PRINTLINE ?Autor ?Marcel Borges Ferreira?Data ?04/09/06 낢?
	굇쳐컴컴컴컴컵컴컴컴컴컴컨컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컨컴컴컴좔컴컴컴컴캑굇
	굇?escri뇚o ?Impress꼘 da Linha                                          낢?
	굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑굇
	굇?intaxe   ?IMPLIN(texto)                                               낢?
	굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑굇
	굇?Uso      ?FINR650.PRG                                                 낢?
	굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸굇
	굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇
	賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽
	/*/
	Static Function PRINTLINE(oReport,lPrint) 

	Local oSection1 := oReport:Section(1)

	If lPrint
		oSection1:Cell("SEC1_TIT"):Show()
		oSection1:Cell("SEC1_CLI"):Show()
		oSection1:Cell("SEC1_OCOR"):Show()
		oSection1:Cell("SEC1_DTOCOR"):Show()
		oSection1:Cell("SEC1_VORIG"):Show()
		oSection1:Cell("SEC1_DCOB"):Show()
		oSection1:Cell("SEC1_VDESC"):Show()
		oSection1:Cell("SEC1_VABAT"):Show()
		oSection1:Cell("SEC1_VJURO"):Show()
		
		If mv_par07 == 1
			oSection1:Cell("SEC1_VRECE"):Show()
			oSection1:Cell("SEC1_VIOF"):Show()
			oSection1:Cell("SEC1_OCRED"):Show()
			oSection1:Cell("SEC1_DTCRED"):Show()
		Else
			oSection1:Cell("SEC1_VPAGO"):Show()
		EndIf
		
		oSection1:Cell("SEC1_NTIT"):Show()
		
		oSection1:PrintLine()
		
	Else

		oSection1:Cell("SEC1_TIT"):Hide()
		oSection1:Cell("SEC1_CLI"):Hide()
		oSection1:Cell("SEC1_OCOR"):Hide()
		oSection1:Cell("SEC1_DTOCOR"):Hide()
		oSection1:Cell("SEC1_VORIG"):Hide()
		oSection1:Cell("SEC1_DCOB"):Hide()
		oSection1:Cell("SEC1_VDESC"):Hide()
		oSection1:Cell("SEC1_VABAT"):Hide()
		oSection1:Cell("SEC1_VJURO"):Hide()
		If mv_par07 == 1
			oSection1:Cell("SEC1_VRECE"):Hide()
			oSection1:Cell("SEC1_VIOF"):Hide()
			oSection1:Cell("SEC1_OCRED"):Hide()
			oSection1:Cell("SEC1_DTCRED"):Hide()
		Else 
			oSection1:Cell("SEC1_VPAGO"):Hide()
		EndIf                                 
		
		oSection1:Cell("SEC1_NTIT"):Hide()
		
		oSection1:PrintLine()
		
	EndIf

Return .F.


/*複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇旼컴컴컴컴컫컴컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴컴컴컴컫컴컴컴컴엽?
굇?un뇙o    ?xecSchedule?Autor ?Aldo Barbosa dos Santos      ?1/12/10낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컨컴컴컴컴눙?
굇?escricao ?etorna se o programa esta sendo executado via schedule     낢?
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?/
Static Function ExecSchedule()
Local lRetorno := .T.

lRetorno := IsBlind()

Return( lRetorno )

/*{Protheus.doc} VldLicenca
Verifica se a rotina selecionada est?sendo chamada com licen? de uso para o m?ulo de origem 
@type function
@version 12 
@author gabriel.asantos
@since 03/02/2023
@return logical, Se retorno verdadeiro ent? possui licen?, caso contr?io n? possui licen?
/*/
Static Function VldLicenca()
	Local lRet       As Logical

	FwBlkUserFunction(.T.)
	lRet := AmIIn(SIGAFIN)
	FwBlkUserFunction(.F.)
	
Return lRet
