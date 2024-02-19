
#INCLUDE "PROTHEUS.CH"            
#INCLUDE "IMPRECIB.CH"        
#IFNDEF CRLF
	#DEFINE CRLF ( chr(13)+chr(10) )
#ENDIF

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPRECHTMLºAutor  ³Ml.Camargo          ºFecha ³  23/03/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Genera el recibó de nómina  en html para envió al portal   º±±
±±º          ³ del empleado. 					                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PORTAL GPE                                                 º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ M.Camargo  	 ³13/03/13³TGVDF1³GENRECHTML: Se toma el valor de los 	  ³±±  
±±³  		     ³        ³      ³parámetros de IMPREC2 para mostrar   	  ³±±       
±±³  		     ³        ³      ³el mensaje de pie de recibo		  	  ³±± 
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß          
/*/


user function GenrecHTML(lTerminal,cFilTerminal,cMatTerminal,cMesAnoRef,nRecTipo,cSemanaTerminal)

	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Define Variaveis Locais (Programa)                           ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
//	Local cIndCond
//	Local Baseaux 	:= "S"

	Local cMes		:= ""
	Local cAno		:= ""
	Local cString	:="SRA"        // alias do arquivo principal (Base)
	Private aLanca 		:= {}
	Private aProve 		:= {}
	Private aDesco 		:= {}
	Private aBases 		:= {}
	Private aInfo  		:= {}
	Private aCodFol		:= {}
	Private li     		:= _PROW()
	Private Titulo 		:= OemToAnsi(STR0011)		//"EMISSO DE RECIBOS DE PAGAMENTOS"
	Private lEnvioOk 	:= .F.
	Private lRetCanc	:= .t.
	Private aPerAberto	:= {}
	Private aPerFechado	:= {}
	Private cProcesso	:= "" // Armazena o processo selecionado na Pergunte GPR040 (mv_par01).
	Private cRoteiro	:= "" // Armazena o Roteiro selecionado na Pergunte GPR040 (mv_par02).
	Private cPeriodo	:= "" // Armazena o Periodo selecionado na Pergunte GPR040 (mv_par03).
	Private cCcto		:= ""
	Private cCond		:= ""
	Private cRot		:= ""
	Private cMensRec 	:= ""
	Private cDescProc
    Private nTipRel 	:= 3
	Private nOrdem		:= 1      
	Private Semana		:= ""
	Private cHtml		:= ""    
    cSemanaTerminal := IF( Empty( cSemanaTerminal ) , Space( Len( SRC->RC_SEMANA ) ) , cSemanaTerminal )
   	Semana     := cSemanaTerminal	//Numero da Semana
	cProcesso  := POSICIONE("SRA",1,cFilTerminal+cMatTerminal,"RA_PROCES")	//Processo
	cPeriodo   := cMesAnoRef//cPerTerminal  	//Periodo
	cRoteiro   := getRoteir()   		//Emitir Recibos(Roteiro)
	Pergunte("IMPREC2",.F.)
	cMensRec   := AllTrim( fPosTab( "S018", mv_par21, "=", 4,,,,5) )

	 
    // Carregar os periodos abertos (aPerAberto) e/ou
	// os periodos fechados (aPerFechado), dependendo
	// do periodo (ou intervalo de periodos) selecionado
  	RetPerAbertFech(cProcesso	,; // Processo selecionado na Pergunte.
	cRoteiro	,; // Roteiro selecionado na Pergunte.
	cPeriodo	,; // Periodo selecionado na Pergunte.
	Semana		,; // Numero de Pagamento selecionado na Pergunte.
	NIL			,; // Periodo Ate - Passar "NIL", pois neste relatorio eh escolhido apenas um periodo.
	NIL			,; // Numero de Pagamento Ate - Passar "NIL", pois neste relatorio eh escolhido apenas um numero de pagamento.
	@aPerAberto	,; // Retorna array com os Periodos e NrPagtos Abertos
	@aPerFechado ) // Retorna array com os Periodos e NrPagtos Fechados
	
	// Retorna o mes e o ano do periodo selecionado na pergunte.
	AnoMesPer(	cProcesso	,; // Processo selecionado na Pergunte.
	cRoteiro	,; // Roteiro selecionado na Pergunte.
	cPeriodo	,; // Periodo selecionado na Pergunte.
	@cMes		,; // Retorna o Mes do Processo + Roteiro + Periodo selecionado
	@cAno		 ) // Retorna o Ano do Processo + Roteiro + Periodo selecionado
	
	dDataRef := CTOD("01/" + cMes + "/" + cAno)
	
	nTipRel    := IF( !( lTerminal ), mv_par05 , 3				)	//Tipo de Recibo (Pre/Zebrado/EMail)
	cFilDe     := IF( !( lTerminal ), mv_par06,cFilTerminal		)	//Filial De
	cFilAte    := IF( !( lTerminal ), mv_par07,cFilTerminal		)	//Filial Ate
	cCcDe      := IF( !( lTerminal ), mv_par08,SRA->RA_CC		)	//Centro de Custo De
	cCcAte     := IF( !( lTerminal ), mv_par09,SRA->RA_CC		)	//Centro de Custo Ate
	cMatDe     := IF( !( lTerminal ), mv_par10,cMatTerminal		)	//Matricula Des
	cMatAte    := IF( !( lTerminal ), mv_par11,cMatTerminal		)	//Matricula Ate
	cNomDe     := IF( !( lTerminal ), mv_par12,SRA->RA_NOME		)	//Nome De
	cNomAte    := IF( !( lTerminal ), mv_par13,SRA->RA_NOME		)	//Nome Ate
	ChapaDe    := IF( !( lTerminal ), mv_par14,SRA->RA_CHAPA 	)	//Chapa De
	ChapaAte   := IF( !( lTerminal ), mv_par15,SRA->RA_CHAPA 	)	//Chapa Ate
	Mensag1    := mv_par16										 	//Mensagem 1
	Mensag2    := mv_par17											//Mensagem 2
	Mensag3    := mv_par18											//Mensagem 3
	cSituacao  := IF( !( lTerminal ),mv_par19, fSituacao( NIL , .F. ) )	//Situacoes a Imprimir
	cCategoria := IF( !( lTerminal ),mv_par20, fCategoria( NIL , .F. ))	//Categorias a Imprimir
	cBaseAux   := "N"									   				//Imprimir BaseS

	
	cMesAnoRef := StrZero(Month(dDataRef),2) + StrZero(Year(dDataRef),4)
    DbSelectArea( "SRA" )
	cHtml := R030Imp(.F.,cString,cMesAnoRef,.T.)
	
Return   cHtml   

Static Function R030Imp(lEnd,cString,cMesAnoRef,lTerminal)

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Define Variaveis Locais (Basicas)                            ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Local aCodBenef   := {}
Local cAcessaSR1  := &("{ || " + ChkRH("IMPRECIB","SR1","2") + "}")
Local cAcessaSRA  := &("{ || " + ChkRH("IMPRECIB","SRA","2") + "}")
Local cAcessaSRC  := &("{ || " + ChkRH("IMPRECIB","SRC","2") + "}")
Local cAcessaSRD  := &("{ || " + ChkRH("IMPRECIB","SRD","2") + "}")
Local cNroHoras   := &("{ || If(aVerbasFunc[nReg,05] > 0 .And. cIRefSem == 'S', aVerbasFunc[nReg,05], aVerbasFunc[nReg,6]) }")
Local cHtml		  := ""
Local nHoras      := 0
Local nMes, nAno
Local nX
Local nReg		  := 0
Local cPerAnt	  := ""
Local aVerbasFunc := {}

Local dDataLibRh
Local cMesCorrente	:= getmv("MV_FOLMES")
Local nTcfDadt		:= If(lTerminal,getmv("MV_TCFDADT",,0),0)		// indica o dia a partir do qual esta liberada a consulta ao TCF
Local nTcfDfol		:= If(lTerminal,getmv("MV_TCFDFOL",,0),0)		// indica a quantidade de dias a somar ou diminuir no ultimo dia do mes corrente para liberar a consulta do TCF
Local nTcfD131		:= If(lTerminal,getmv("MV_TCFD131",,0),0)		// indica o dia a partir do qual esta liberada a consulta ao TCF
Local nTcfD132		:= If(lTerminal,getmv("MV_TCFD132",,0),0)		// indica o dia a partir do qual esta liberada a consulta ao TCF
Local nTcfDext		:= If(lTerminal,getmv("MV_TCFDEXT",,0),0)		// indica o dia a partir do qual esta liberada a consulta ao TCF

Private tamanho     := "M"
Private limite		:= 132
Private cDtPago     := ""
Private cPict1		:= "@E 999,999,999.99"
Private cPict2 		:= "@E 99,999,999.99"
Private cPict3 		:= "@E 999,999.99"
Private cTipoRot 	:= PosAlias("SRY", cRoteiro, SRA->RA_FILIAL, "RY_TIPO")

If MsDecimais(1) == 0
	cPict1	:=	"@E 99,999,999,999"
	cPict2 	:=	"@E 9,999,999,999"
	cPict3 	:=	"@E 99,999,999"
Endif

// Ajuste do tipo da variavel
nTcfDadt	:= if(valtype(ntcfdadt)=="C",val(ntcfdadt),ntcfdadt)
nTcfD131	:= if(valtype(nTcfD131)=="C",val(nTcfD131),nTcfD131)
nTcfD132	:= if(valtype(nTcfD132)=="C",val(nTcfD132),nTcfD132)
nTcfDfol	:= if(valtype(ntcfdfol)=="C",val(ntcfdfol),ntcfdfol)
nTcfDext	:= if(valtype(ntcfdext)=="C",val(ntcfdext),ntcfdext)


/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Selecionando a Ordem de impressao escolhida no parametro.    ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
dbSelectArea( "SRA")
IF !( lTerminal )
	If nOrdem == 1
		dbSetOrder(1)
	Endif
Endif

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Selecionando o Primeiro Registro e montando Filtro.          ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
If nOrdem == 1 .or. lTerminal
	cInicio := "SRA->RA_FILIAL + SRA->RA_MAT"
	cFim    := &(cInicio)	
Endif

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Carrega Regua Processamento                                  ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
dbSelectArea("SRA")

TOTVENC:= TOTDESC:= FLAG:= CHAVE := 0

Desc_Fil := Desc_End := DESC_CC:= DESC_FUNC:=Desc_Bair:= ""
Desc_Comp:= Desc_Est := Desc_Cid := Desc_CEP := ""
DESC_MSG1:= DESC_MSG2:= DESC_MSG3:= Space(01)
dRCHDtIni := PosAlias( "RCH" , (cProcesso+cPeriodo+Semana+cRoteiro), SRA->RA_FILIAL , "RCH_DTINI")
dRCHDtFim := PosAlias( "RCH" , (cProcesso+cPeriodo+Semana+cRoteiro), SRA->RA_FILIAL , "RCH_DTFIM")
cFilialAnt := "  "
Vez        := 0
OrdemZ     := 0

While SRA->( !Eof() .And. &cInicio <= cFim )
	

	aLanca	:= {}         // Zera Lancamentos
	aProve	:= {}         // Zera Lancamentos
	aDesco	:= {}         // Zera Lancamentos
	aBases	:= {}         // Zera Lancamentos
	nAteLim := nBaseFgts := nFgts := nBaseIr := nBaseIrFe := 0.00
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Consiste Parametrizacao do Intervalo de Impressao            ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		If (SRA->RA_CHAPA < ChapaDe) .Or. (SRA->Ra_CHAPa > ChapaAte) 	 .Or. ;
			(SRA->RA_NOME < cNomDe)    .Or. (SRA->Ra_NOME > cNomAte)    .Or. ;
			(SRA->RA_MAT < cMatDe)     .Or. (SRA->Ra_MAT > cMatAte)     .Or. ;
			(SRA->RA_CC < cCcDe)       .Or. (SRA->Ra_CC > cCcAte)
			SRA->(dbSkip(1))
			Loop
		EndIf	
	
	Ordem_rel := 1     // Ordem dos Recibos

    /*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Verifica Data Demissao         ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	
	cSitFunc := SRA->RA_SITFOLH
	dDtPesqAf:= CTOD("01/" + Right(cMesAnoRef,2) + "/" + Left(cMesAnoRef,4),"DDMMYY")
	If cSitFunc == "D" .And. (!Empty(SRA->RA_DEMISSA) .And. MesAno(SRA->RA_DEMISSA) > MesAno(dDtPesqAf))
		cSitFunc := " "
	Endif
	
	IF !( lTerminal )
		
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Consiste situacao e categoria dos funcionarios			   |
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/

/*gsa150411		If !( cSitFunc $ cSituacao ) .OR.  ! ( SRA->RA_CATFUNC $ cCategoria )		
			dbSkip()
			Loop
		Endif*/
		If cSitFunc $ "D" .And. Mesano(SRA->RA_DEMISSA) # Mesano(dDataRef)
			dbSkip()
			Loop
		Endif
		
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Consiste controle de acessos e filiais validas			   |
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
/*gsa150411		If !(SRA->RA_FILIAL $ fValidFil()) .Or. !Eval(cAcessaSRA)
			dbSkip()
			Loop
		EndIf
*/		
	EndIF
	
	If SRA->RA_Filial # cFilialAnt
		If ! Fp_CodFol(@aCodFol,Sra->Ra_Filial) .Or. ! fInfo(@aInfo,Sra->Ra_Filial)
			Exit
		Endif
		Desc_Fil := aInfo[3]
		Desc_End := aInfo[4]                // Dados da Filial
		Desc_CGC := aInfo[8]
		DESC_MSG1:= DESC_MSG2:= DESC_MSG3:= Space(01)
		Desc_Est := Substr(fDesc("SX5","12"+aInfo[6],"X5DESCRI()"),1,12)
		Desc_Comp:= aInfo[14]        			// Complemento Cobranca
		Desc_Cid := aInfo[05]
		Desc_Bair:= aInfo[13]
		Desc_CEP := aInfo[07]
		
		// MENSAGENS
		If MENSAG1 # SPACE(3)
			If FPHIST82(SRA->RA_FILIAL,"06",MENSAG1)
				DESC_MSG1 := Left(SRX->RX_TXT,30)
			Endif
		Endif
		
		If MENSAG2 # SPACE(3)
			If FPHIST82(SRA->RA_FILIAL,"06",MENSAG2)
				DESC_MSG2 := Left(SRX->RX_TXT,30)
			Endif
		Endif
		
		If MENSAG3 # SPACE(3)
			If FPHIST82(SRA->RA_FILIAL,"06",MENSAG3)
				DESC_MSG3 := Left(SRX->RX_TXT,30)
			Endif
		Endif
		dbSelectArea("SRA")
		cFilialAnt := SRA->RA_FILIAL
	Endif
	
	Totvenc := Totdesc := 0
	
	//Retorna as verbas do funcionario, de acordo com os periodos selecionados
	aVerbasFunc	:= RetornaVerbasFunc(	SRA->RA_FILIAL					,; // Filial do funcionario corrente
	SRA->RA_MAT	  					,; // Matricula do funcionario corrente
	NIL								,; //
	cRoteiro	  					,; // Roteiro selecionado na pergunte
	NIL			  					,; // Array com as verbas que deverão ser listadas. Se NIL retorna todas as verbas.
	aPerAberto	  					,; // Array com os Periodos e Numero de pagamento abertos
	aPerFechado	 	 				 ) // Array com os Periodos e Numero de pagamento fechados
	
	If cRoteiro <> "EXT"
		For nReg := 1 to Len(aVerbasFunc)
			If (Len(aPerAberto) > 0 .AND. !Eval(cAcessaSRC)) .OR. (Len(aPerFechado) > 0 .AND. !Eval(cAcessaSRD))
				dbSkip()
				Loop
			EndIf			
			If PosSrv( aVerbasFunc[nReg,3] , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1"
				If cPaisLoc == "PAR" .and. Eval(cNroHoras) == 30
					LocGHabRea(Ctod("01/"+SubStr(DTOC(dDataRef),4)), Ctod(StrZero(F_ULTDIA(dDataRef),2)+"/"+Strzero(Month(dDataRef),2)+"/"+right(str(Year(dDataRef)),2),"ddmmyy"),@nHoras)
				Else
					nHoras := Eval(cNroHoras)
				Endif
				fSomaPdRec("P",aVerbasFunc[nReg,3],nHoras,aVerbasFunc[nReg,7])
				TOTVENC += aVerbasFunc[nReg,7]
			Elseif SRV->RV_TIPOCOD == "2"
				fSomaPdRec("D",aVerbasFunc[nReg,3],Eval(cNroHoras),aVerbasFunc[nReg,7])
				TOTDESC += aVerbasFunc[nReg,7]
			Elseif SRV->RV_TIPOCOD $ "3/4"
				//No Paraguai imprimir somente o valor liquido
				If cPaisLoc <> "PAR" .Or. (aVerbasFunc[nReg,3] == aCodFol[047,1])
					fSomaPdRec("B",aVerbasFunc[nReg,3],Eval(cNroHoras),aVerbasFunc[nReg,7])
				Endif
			Endif
			
			If (aVerbasFunc[nReg,3] $ aCodFol[10,1]+'*'+aCodFol[15,1]+'*'+aCodFol[27,1])
				nBaseIr += aVerbasFunc[nReg,7]
			ElseIf (aVerbasFunc[nReg,3] $ aCodFol[13,1]+'*'+aCodFol[19,1])
				nAteLim += aVerbasFunc[nReg,7]
			Elseif (aVerbasFunc[nReg,3] $ aCodFol[108,1]+'*'+aCodFol[17,1])
				nBaseFgts += aVerbasFunc[nReg,7]
			Elseif (aVerbasFunc[nReg,3] $ aCodFol[109,1]+'*'+aCodFol[18,1])
				nFgts += aVerbasFunc[nReg,7]
			Elseif (aVerbasFunc[nReg,3] == aCodFol[16,1])
				nBaseIrFe += aVerbasFunc[nReg,7]
			Endif
		Next nReg
	Elseif cRoteiro == "EXT"
		dbSelectArea("SR1")
		dbSetOrder(1)
		If dbSeek( SRA->RA_FILIAL + SRA->RA_MAT )
			While !Eof() .And. SRA->RA_FILIAL + SRA->RA_MAT ==	SR1->R1_FILIAL + SR1->R1_MAT
				If Semana # "99"
					If SR1->R1_SEMANA # Semana
						dbSkip()
						Loop
					Endif
				Endif
				If !Eval(cAcessaSR1)
					dbSkip()
					Loop
				EndIf
				If PosSrv( SR1->R1_PD , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1"
					fSomaPdRec("P",SR1->R1_PD,SR1->R1_HORAS,SR1->R1_VALOR)
					TOTVENC = TOTVENC + SR1->R1_VALOR
				Elseif SRV->RV_TIPOCOD == "2"
					fSomaPdRec("D",SR1->R1_PD,SR1->R1_HORAS,SR1->R1_VALOR)
					TOTDESC = TOTDESC + SR1->R1_VALOR
				Elseif SRV->RV_TIPOCOD $ "3/4"
					fSomaPdRec("B",SR1->R1_PD,SR1->R1_HORAS,SR1->R1_VALOR)
				Endif
				dbskip()
			Enddo
		Endif
	Endif
	
	dbSelectArea("SRA")
	//	If TOTVENC = 0 .And. TOTDESC = 0
	If Empty( aVerbasFunc )
		dbSkip()
		Loop
	Endif
	
	If nTipRel == 3 .AND. lTerminal
		cHtml := genHTMl(lTerminal)   //Monta o corpo do e-mail e envia-o
	Endif
	
	dbSelectArea("SRA")
	SRA->( dbSkip() )
	TOTDESC := TOTVENC := 0
	
EndDo

IF !( lTerminal )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Termino do relatorio                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SRC")
	dbSetOrder(1)          // Retorno a ordem 1
	dbSelectArea("SRD")
	dbSetOrder(1)          // Retorno a ordem 1
	dbSelectArea("SRA")
	SET FILTER TO
	RetIndex("SRA")
	
	If !(Type("cArqNtx") == "U")
		fErase(cArqNtx + OrdBagExt())
	Endif		
EndIF

Return( cHtml )

Static Function fSomaPdRec(cTipo,cPd,nHoras,nValor)

Local Desc_paga

Desc_paga := DescPd(cPd,Sra->Ra_Filial)  // mostra como pagto

If PosSrv(cPD, SRA->RA_FILIAL, "RV_IMPRIPD") == "2"
	Return
EndIf

If cTipo # 'B'
	
	//--Array para Recibo Pre-Impresso
	nPos := Ascan(aLanca,{ |X| X[2] = cPd })
	If nPos == 0
		Aadd(aLanca,{cTipo,cPd,Desc_Paga,nHoras,nValor})
	Else
		aLanca[nPos,4] += nHoras
		aLanca[nPos,5] += nValor
	Endif
Endif

//--Array para o Recibo Pre-Impresso
If cTipo = 'P'
	cArray := "aProve"
Elseif cTipo = 'D'
	cArray := "aDesco"
Elseif cTipo = 'B'
	cArray := "aBases"
Endif

nPos := Ascan(&cArray,{ |X| X[1] = cPd })
If nPos == 0
	Aadd(&cArray,{cPd+" "+Desc_Paga,nHoras,nValor })
Else
	&cArray[nPos,2] += nHoras
	&cArray[nPos,3] += nValor
Endif

Return        


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPRECIB  ºAutor  ³Joao Tavares Junior ºFecha ³  08/11/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa Envio de Email Recibo Nomina                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP8                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function genHTMl(lTerminal)
	Local aSvArea		:= GetArea()
	Local aGetArea		:= {}
	Local cMesComp		:= IF( Month(dDataRef) + 1 > 12 , 01 , Month(dDataRef) )
	Local cTipo			:= ""
	Local cReferencia	:= ""
	Local cVerbaLiq		:= ""
	Local dDataPagto	:= Ctod("//")
	Local nZebrado		:= 0.00
	Local nResto		:= 0.00
	Local nProv
	Local nDesco
	Local cCodFunc		:= ""		//-- codigo da Funcao do funcionario
	Local cDescFunc		:= ""		//-- Descricao da Funcao do Funcionario
	//Local cLogoEmp		:= RetLogoEmp()
	//Local cArquivo		:= getmv("ES_DIRLOG") //+SubStr(cLogoEmp,RAT("/",cLogoEmp) + 1,Len(cLogoEmp))
	//Variables de cambios
	Local dPerFinal     := dRCHDtFim   //16 - 16/08/08-31/08/08(Este es periodo Final)
	Local nSalDiar      := 0 //Salario Diario
	Local nSalInt       := 0 //Salario Diario Integrado
	Local cRegPatr      := ""  //Space(TAMSX3("RCP_CODRP")[1])  //Regostro Patronal
	Local cProceso      := ""  //Space(TAMSX3("RE_PROCESP")[1]) //Proceso
	Local cDesProc      := ""  //Space(TAMSX3("RCJ_DESCRI")[1]) //Descripción del Proceso (RCJ)
	Local cCentroC      := ""  //Space(TAMSX3("RE_CCP")[1])     //Centro de Costo 
	Local cDescCC       := ""  //Space(TAMSX3("CTT_DESC01")[1])//Descripción del Centro de Costo (CTT)
	Local cFuncion      := ""  //Space(TAMSX3("R7_FUNCAO")[1])  //Función
	Local cDesFunc      := ""  //Space(TAMSX3("R7_DESCFUN")[1]) //Descripcion de la Función
	Local cEstado       := SRA->RA_ESTADO
	
	Private cMailConta	:= NIL
	Private cMailServer	:= NIL
	Private cMailSenha	:= NIL
	
	lTerminal := .F.
	
	aGetArea	:= SRC->( GetArea() )
	cTipo		:= PosAlias("SRY", cRoteiro, SRA->RA_FILIAL, "RY_DESC")
	
	IF cTipoRot == "2"
		cVerbaLiq	:= PosSrv( "007ADT" , xFilial("SRA") , "RV_COD" , RetOrdem("SRV","RV_FILIAL+RV_CODFOL") , .F. )
	ElseIF cTipoRot == "1"
		cVerbaLiq	:= PosSrv( "047CAL" , xFilial("SRA") , "RV_COD" , RetOrdem("SRV","RV_FILIAL+RV_CODFOL") , .F. )
	ElseIF cTipoRot == "5"
		cVerbaLiq	:= PosSrv( "022C13" , xFilial("SRA") , "RV_COD" , RetOrdem("SRV","RV_FILIAL+RV_CODFOL") , .F. )
	ElseIF cTipoRot == "6"
		cVerbaLiq	:= PosSrv( "021C13" , xFilial("SRA") , "RV_COD" , RetOrdem("SRV","RV_FILIAL+RV_CODFOL") , .F. )
	ElseIF  cRoteiro == "EXT"
		cTipo		:= OemToAnsi(STR0064) //"Valores Extras"
		cVerbaLiq	:= ""
	EndIF
	
	IF  cRoteiro <> "EXT"
		dDataPagto := PosAlias( "RCH" , (cProcesso+cPeriodo+Semana+cRoteiro) , SRA->RA_FILIAL , "RCH_DTPAGO")
	EndIf
	
	cReferencia	:= AllTrim( MesExtenso(Month(dDataRef))+"/"+STR(YEAR(dDataRef),4) ) + " - ( " + cTipo + "-" + cPeriodo + "/" + Semana + " )"
	
	//Obtener Datos Validos
	ObtDatos(dPerFinal,@nSalDiar,@nSalInt,@cProceso,@cDesProc,@cCentroC,@cDescCC,@cFuncion,@cDesFunc,@cRegPatr,SRA->RA_MAT)
	
	
	//-----Cabecalho
	
	cHtml += '<table id="enc">'+chr(13)+chr(10)
	cHtml += 	'<tr><td>Recibo de Pago</td></tr>'
	cHtml += '</table>'+chr(13)+chr(10)
	//----Inicio dados empresa

	cHtml += '<!--webbot bot="PurpleText" preview="Dados da empresa" -->'+chr(13)+chr(10)
	cHtml += ''+chr(13)+chr(10)   
	
	cHtml += '<table id="datos_empresa">'+chr(13)+chr(10)
	cHtml += 	'<tr>'+chr(13)+chr(10)
	cHtml += 		'<td>'+chr(13)+chr(10)
	cHtml +=	'<table >'+chr(13)+chr(10)
	cHtml +=   		'<tr>'+chr(13)+chr(10)
	cHtml += 			'<td >Empresa:</td>'+chr(13)+chr(10)
	cHtml += 			'<td >'+DESC_Fil+'</td>'+chr(13)+chr(10)
	cHtml += 		'</tr>'+chr(13)+chr(10)
	cHtml += 		'<tr>'+chr(13)+chr(10)
	cHtml += 			'<td>&nbsp;Cod.&nbsp;Reg.&nbsp;Patr:</td>'+chr(13)+chr(10)
	cHtml += 			'<td>'+cRegPatr+'</td>'+chr(13)+chr(10)
	cHtml += 		'</tr>'+chr(13)+chr(10)
	cHtml += 		'<tr>'+chr(13)+chr(10)
	cHtml += 			'<td>&nbsp;RFC:</td>'+chr(13)+chr(10)
	cHtml += 			'<td>'+Desc_CGC+'</td>'+chr(13)+chr(10)
	cHtml += 		'</tr>'+chr(13)+chr(10)
	cHtml += 		'<tr>'+chr(13)+chr(10)
	cHtml += 			'<td>&nbsp;Dirección:</td>'+chr(13)+chr(10)
	cHtml += 			'<td>'+Desc_End+ Alltrim( Desc_Bair ) +" - "+ If( Empty( Desc_Bair ), "", ", " ) + AllTrim( Desc_Cid ) + If( Empty(Desc_Cid), "",  ", " ) + cEstado +  If( Empty(cEstado), "",  ", " ) + Desc_CEP + '</td>'+chr(13)+chr(10)
	cHtml += 			'</tr>'+chr(13)+chr(10)
	cHtml += 		'</table>'+chr(13)+chr(10)
	cHtml += 		'<table>'+chr(13)+chr(10)
	cHtml += 			'<tr>'+chr(13)+chr(10)
	cHtml += 				'<td ">'+chr(13)+chr(10)
	cHtml += 				'</td>'+chr(13)+chr(10)
	cHtml += 			'</tr>'+chr(13)+chr(10)
	cHtml += 		'</table>'+chr(13)+chr(10)
	cHtml += 	'</td>'+chr(13)+chr(10)
	cHtml += '</tr>'+chr(13)+chr(10)
	cHtml += '</table>'+chr(13)+chr(10)   
	cHtml += '<br/><br/>'
	//---Fim dados Empresa
	//-----Inicio dados funcionario
	
	
	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  ³ Carrega Funcao do Funcion. de acordo com a Dt Referencia     ³
	  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	fBuscaFunc(dDataRef, @cCodFunc, @cDescFunc   )

	cHtml += '<!--webbot bot="PurpleText" preview="DADOS CADASTRAIS Funcionario" -->'+chr(13)+chr(10)
	cHtml += '<table id="datos_empleado">'+chr(13)+chr(10)
	cHtml += 	'<tr>'+chr(13)+chr(10)    
	cHtml += 		'<td >Matricula:</td>'+chr(13)+chr(10)
	cHtml += 		'<td >'+SRA->RA_MAT+'</td>'+chr(13)+chr(10)
	cHtml += 		'<td ><b>Nombre:</b></td>'+chr(13)+chr(10)
	cHtml += 		'<td >'+SRA->RA_NOME+'</td>'+chr(13)+chr(10)
	cHtml += 	'</tr>'+chr(13)+chr(10)
	cHtml += '</table>'+chr(13)+chr(10)
	cHtml += '<table >'+chr(13)+chr(10)
	cHtml += 	'<tr>'+chr(13)+chr(10)
	cHtml += 		'<td><b>Orden: </b></td>'+chr(13)+chr(10)
	cHtml += 		'<td > '+StrZero(ORDEMZ,4)+' </td>'+chr(13)+chr(10)
	cHtml += 		'<td >Centro&nbsp;Costo:</td>'+chr(13)+chr(10)
	cHtml += 		'<td > '+Alltrim( cCentroC ) + " - " + cDescCC +' </td>'+chr(13)+chr(10)
	cHtml += 		'<td ><b>Función:</b></td>'+chr(13)+chr(10)
	cHtml += 		'<td >'+ cFuncion + " - " + AllTrim( cDesFunc )+' </td>'+chr(13)+chr(10)
	cHtml += 	'</tr>'+chr(13)+chr(10)
	cHtml += 	'<tr>'+chr(13)+chr(10)
	cHtml += 		'<td > RFC: </td>'+chr(13)+chr(10)
	cHtml += 		'<td > '+SRA->RA_CIC+' </td>'+chr(13)+chr(10)
	cHtml += 		'<td ><b> IMSS: </b></td>'+chr(13)+chr(10)
	If SRA->RA_CATFUNC <> "A"	// Autonomos nao possui Registro no IMSS
		cHtml += 	'<td > '+SRA->RA_RG+' </td>'+chr(13)+chr(10)
	Else
		cHtml += 	'<td > &nbsp </td>'+chr(13)+chr(10)
	EndIf
	cHtml += 		'<td ><b> CURP: </b></td>'+chr(13)+chr(10)
	cHtml += 		'<td > '+SRA->RA_CURP+' </td>'+chr(13)+chr(10)
	cHtml += 	'</tr>'+chr(13)+chr(10)
	cHtml += 	'<tr>'+chr(13)+chr(10)
	cHtml += 		'<td > Sueldo&nbsp;Diario: </td>'+chr(13)+chr(10)
	cHtml += 		'<td > '+ TRANSFORM(nSalDiar,"@E 999,999.999999")+' </td>'+chr(13)+chr(10)
	cHtml += 		'<td ><b> Suel.&nbsp;Dia.&nbsp;Int: </b></td>'+chr(13)+chr(10)
	If SRA->RA_CATFUNC <> "A"// Autonomos nao possui Salario Integrado
		cHtml += 	'<td > '+TRANSFORM(nSalInt,"@E 999,999.999999")+' </td>'+chr(13)+chr(10)
	Else
		cHtml += 	'<td > &nbsp </td>'+chr(13)+chr(10)
	EndIf
	
	cHtml += 		'<td ><b> Lugar&nbsp;de&nbsp;Pago: </b></td>'+chr(13)+chr(10)
	cHtml += 		'<td > '+AllTrim( SRA->RA_KEYLOC ) + " - " + Substr( AllTrim( fPosTab( "S015", SRA->RA_KEYLOC, "=", 4,,,,5) ), 1, 30 )+' </td>'+chr(13)+chr(10)
	cHtml += 	'</tr>'+chr(13)+chr(10)
	cHtml += 	'<tr>'+chr(13)+chr(10)
	cHtml += 		'<td > Proceso: </td>'+chr(13)+chr(10)
	cHtml += 		'<td > '+cProceso + "-" + cDesProc+' </td>'+chr(13)+chr(10)
	cHtml += 		'<td ><b> Procedimiento: </b></td>'+chr(13)+chr(10)
	cHtml += 		'<td > '+cRoteiro+" - "+cTipo+' </td>'+chr(13)+chr(10)
	cHtml += 		'<td ><b> Periodo: </b></td>'+chr(13)+chr(10)
	cHtml += 		'<td > '+cPeriodo+' </td>'+chr(13)+chr(10)
	cHtml += 	'</tr>'+chr(13)+chr(10)
	cHtml += '</table>'+chr(13)+chr(10)
	cHtml += '<table>'+chr(13)+chr(10)
	cHtml += 	'<tr>'+chr(13)+chr(10)
	cHtml += 		'<td> Nº&nbsp;Pago:&nbsp; </td>'+chr(13)+chr(10)
	cHtml += 		'<td> '+Semana + " - " + DtoC( GravaData( dRCHDtIni, .T. ) ) + " a " + DtoC( GravaData( dRCHDtFim, .T. ) )+' </td>'+chr(13)+chr(10)
	cHtml += 	'</tr>'+chr(13)+chr(10)
	cHtml += '</table>'+chr(13)+chr(10)
	
	cHtml += '<br/><br/>'
	//----Fim dados Funcionarios
	cHtml += '<!--webbot bot="PurpleText" preview="DADOS PERCEPICIONES" -->'+chr(13)+chr(10)
	cHtml += '<table id="percepcion">'+chr(13)+chr(10)
	cHtml += 	'<tr>'+chr(13)+chr(10)
	cHtml += 		'<td>'+chr(13)+chr(10)
	cHtml += 			'<b> C&oacute;digo </b></td>'+chr(13)+chr(10)
	cHtml += 		'<td>'+chr(13)+chr(10)
	cHtml += 			'<b> Descripci&oacute;n </b></td>'+chr(13)+chr(10)
	cHtml += 		'<td>'+chr(13)+chr(10)
	cHtml += 			'<b> Referencia </b></td>'+chr(13)+chr(10)
	cHtml += 		'<td>'+chr(13)+chr(10)
	cHtml += 		'<b>Valor</b></td>'+chr(13)+chr(10)
	cHtml += 	'</tr>'+chr(13)+chr(10)
	cHtml += 	'<tr>'+chr(13)+chr(10)
	cHtml += 		'<td>'+chr(13)+chr(10)
	cHtml += 			'<b>Percepciones</b></td>'+chr(13)+chr(10)
	cHtml += 		'</tr>'+chr(13)+chr(10)
	cHtml += '</table>'+chr(13)+chr(10)
	cHtml += '<table>'+chr(13)+chr(10)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Proventos                                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nProv:=1 To Len( aProve )
		
		nResto := ( ++nZebrado % 2 )
		
		cHtml += 	'<tr>'+chr(13)+chr(10)
		cHtml += 		'<td>'+chr(13)+chr(10)
		cHtml += 			substr(aProve[nProv,1],1,4)+' </td>'+chr(13)+chr(10)
		cHtml += 		'<td>'+chr(13)+chr(10)
		cHtml += 	 		substr(aProve[nProv,1],5) + ' </td>'+chr(13)+chr(10)
		cHtml += 		'<td>'+chr(13)+chr(10	)
		cHtml += 			Transform(aProve[nProv,2],'999.99')+' </td>'+chr(13)+chr(10)
		cHtml += 		'<td>'+chr(13)+chr(10)
		cHtml += 			Transform(aProve[nProv,3],cPict3) + ' </td>'+chr(13)+chr(10)
		cHtml += 	'</tr>'+chr(13)+chr(10)
		
	Next nProv
	
	
	cHtml += '</table>'+chr(13)+chr(10)
	cHtml += '<!--webbot bot="PurpleText" preview="Separador Deduciones" -->'+chr(13)+chr(10)
	cHtml += '<br/>'
	cHtml += '<table id="deduccion">'+chr(13)+chr(10)
	cHtml += '<!--webbot bot="PurpleText" preview="DADOS Deduciones" -->'+chr(13)+chr(10)
	cHtml += 	'<tr>'+chr(13)+chr(10)
	cHtml += 		'<td>'+chr(13)+chr(10)
	cHtml += 		'<b>Deducciones</b></td>'+chr(13)+chr(10)
	cHtml += 	'</tr>'+chr(13)+chr(10)
	cHtml += '</table>'+chr(13)+chr(10)
	
	cHtml += '<table >'+chr(13)+chr(10)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Descontos                                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nDesco := 1 to Len(aDesco)
		
		nResto := ( ++nZebrado % 2 )
		
		cHtml += '<tr>'+chr(13)+chr(10)
		cHtml += 	'<td>'+chr(13)+chr(10)
		cHtml += 		substr(aDesco[nDesco,1],1,4) + ' </td>'+chr(13)+chr(10)
		cHtml += 	'<td>'+chr(13)+chr(10)
		cHtml +=  		substr(aDesco[nDesco,1],5) + ' </td>'+chr(13)+chr(10)
		cHtml += 	'<td>'+chr(13)+chr(10)
		cHtml +=  		Transform(aDesco[nDesco,2],'999.99') + ' </td>'+chr(13)+chr(10)
		cHtml += 	'<td>'+chr(13)+chr(10)
		cHtml += 		Transform(aDesco[nDesco,3],cPict3) + ' </td>'+chr(13)+chr(10)
		cHtml += '</tr>'+chr(13)+chr(10)
		
		
	Next nDesco
	
	///--fim de detalhes 
	cHtml += '</table>'+chr(13)+chr(10)
	cHtml += '<br/><img height="1" src="../pic_invis.gif" width="1"><br/>'+chr(13)+chr(10)

	cHtml += '<!--webbot bot="PurpleText" preview="DADOS TOTALES" -->'+chr(13)+chr(10)
	cHtml += '<table id="total1">'+chr(13)+chr(10)
	cHtml += 	'<tr>'+chr(13)+chr(10)
	cHtml += 		'<td>'+chr(13)+chr(10)
	cHtml += 		'<b>Totales</b> </td>'+chr(13)+chr(10)
	cHtml += 	'</tr>'+chr(13)+chr(10)

	cHtml += '</table>'+chr(13)+chr(10)     
	cHtml += '<br/>'     
	///---cabecalho totais
	cHtml += '<table id="totales">'+chr(13)+chr(10)
	cHtml += 	'<tr>'+chr(13)+chr(10)
	cHtml += 		'<td >'+chr(13)+chr(10)
	cHtml += 			'<b> Total  Percepciones</b> </td>'+chr(13)+chr(10)
	cHtml += 		'<td >'+chr(13)+chr(10)
	cHtml += 			'<b> Total&nbsp;Deduciones </b></td>'+chr(13)+chr(10)
	cHtml += 		'<td >'+chr(13)+chr(10)
	cHtml += 			'<b>Cuenta de Banco</b> </td>'+chr(13)+chr(10)
	cHtml += 		'<td>'+chr(13)+chr(10)
	cHtml += 			'<b> Neto Por Cobrar </b></td>'+chr(13)+chr(10)
	cHtml += 	'</tr>'+chr(13)+chr(10)
	//-----Totais
	
	cHtml += 	'<tr>'+chr(13)+chr(10)
	cHtml += 		'<td>'+chr(13)+chr(10)
	cHtml += 		 	Transform(TOTVENC,cPict3) + ' </td>'+chr(13)+chr(10)
	cHtml += 		'<td>'+chr(13)+chr(10)
	cHtml +=			 Transform(TOTDESC,cPict3) + ' </td>'+chr(13)+chr(10)
	cHtml += 		'<td>'+chr(13)+chr(10)
	cHtml += 			SRA->RA_BCDEPSA+"-"+DescBco(SRA->RA_BCDEPSA,SRA->RA_FILIAL)+' </td>'+chr(13)+chr(10)
	cHtml += 		'<td>'+chr(13)+chr(10)
	cHtml += 			Transform((TOTVENC-TOTDESC),cPict3) +' </td>'+chr(13)+chr(10)
	cHtml += 	'</tr>'+chr(13)+chr(10)
	//-----fim Totais
   
	cHtml += '<br/>'
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Espaco para Observacoes/mensagens                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	//-----dados mensagem
	cHtml += '<!--webbot bot="PurpleText" preview="DADOS Mensagens" -->'+chr(13)+chr(10)

	cHtml += 	'<tr>'+chr(13)+chr(10)
	cHtml += 		'<td>'+chr(13)+chr(10)
	cHtml += 			'<b>Mensajes</b> </td>'+chr(13)+chr(10)
	cHtml += 	'</tr>'+chr(13)+chr(10)
	cHtml += 	'<tr>'+chr(13)+chr(10)
	cHtml += 		'<td>'+chr(13)+chr(10)
	cHtml += 			DESC_MSG1+ ' </td>'+chr(13)+chr(10)
	cHtml += 	'</tr>'+chr(13)+chr(10)
	cHtml += 	'<tr>'+chr(13)+chr(10)
	cHtml += 	'<td>'+chr(13)+chr(10)
	cHtml += 		DESC_MSG2+ ' </td>'+chr(13)+chr(10)
	cHtml += 	'</tr>'+chr(13)+chr(10)
	cHtml += 	'<tr>'+chr(13)+chr(10)
	cHtml += 		'<td>'+chr(13)+chr(10)
	cHtml += 		DESC_MSG3+ ' </td>'+chr(13)+chr(10)
	cHtml += 	'</tr>'+chr(13)+chr(10)
	////----Inclui mensagem de mes aniversario
	IF cMesComp == Month(SRA->RA_NASC)
		cHtml += '<tr>'+chr(13)+chr(10)
		cHtml += 	'<td>'+chr(13)+chr(10)
		cHtml +=		OemToAnsi(STR0059)	+ ' </td>'+chr(13)+chr(10)
		cHtml += '</tr>'+chr(13)+chr(10)
	EndIF
	cHtml += '</table>'+chr(13)+chr(10)
	//---fim dados mensagem
	
	cHtml += '<br/>
	cHtml += '<!--webbot bot="PurpleText" preview="Separador rodape 1 acima 1 abaixo" -->'+chr(13)+chr(10)
	cHtml += '<br/>'+chr(13)+chr(10)

	cHtml += '<!--webbot bot="PurpleText" preview="rodape" -->'+chr(13)+chr(10)
	///----Rodape
	cHtml += '<div id="rodapie">'+chr(13)+chr(10)
	cHtml += 	cMensRec+chr(13)+chr(10)
	cHtml += '</div>'+chr(13)+chr(10)
	////-----Fim Rodape
	cHtml += 		'<div id="msiga">Workflow by Microsiga/Protheus 10</div>'+chr(13)+chr(10)

	RestArea( aSvArea )
	
Return  cHtml 
	
	
	
	
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ObtDatos  ºAutor  ³Laura Medina Prado  ºFecha ³ 05/09/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa para obtener datos actuales de: Salario diario,   º±±
±±º          ³ Salario Diario Integrado, Proceso, Función, Registro Patro-º±±
±±º          ³ y Centro de Costo de las tablas RCP, SRE y SR7.            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ObtDatos(dPerFinal,nSalDiar,nSalInt,cProceso,cDesProc,cCentroC,cDescCC,cFuncion,cDesFunc,cRegPatr,cMatEmp)
	Local aArea  	:= (GetArea())
//	Local nTemRecn  := 0
	Local cQueryRCP := "" //Trayectorial laboral  
	Local cAliasRCP := CriaTrab(Nil,.F.)
	Local cQuerySRE := "" //Transferencias
	Local cAliasSRE := CriaTrab(Nil,.F.)
	Local cQuerySR7 := "" //Historial Modificaciones Salario 
	Local cAliasSR7 := CriaTrab(Nil,.F.)
	
	cQueryRCP := " SELECT RCP_MAT,RCP_DTMOV,RCP_SALDIA,RCP_SALDII,RCP_CODRPA"
	cQueryRCP += " FROM " + RetSqlName("RCP") + " RCP "
	cQueryRCP += " WHERE  RCP.RCP_MAT ='"+cMatEmp+"' AND 
	cQueryRCP += " RCP.RCP_DTMOV<='"+DTOS(dPerFinal)+"' AND 
	cQueryRCP += " RCP.D_E_L_E_T_<>'*'  
	cQueryRCP += " ORDER BY RCP_MAT,RCP_DTMOV DESC"  
	cQueryRCP := ChangeQuery(cQueryRCP)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQueryRCP),cAliasRCP,.T.,.T.)   
	
	(cAliasRCP)->( dbGoTop() ) 
	IF  !(cAliasRCP)->(Eof())  
		nSalDiar := (cAliasRCP)->RCP_SALDIA 
		nSalInt  := (cAliasRCP)->RCP_SALDII  
		cRegPatr := POSICIONE("RCO",RetOrdem("RCO","RCO_FILIAL+RCO_CODIGO"),XFILIAL("RCO")+(cAliasRCP)->RCP_CODRPA,"RCO_NREPAT") 
	Endif
	(cAliasRCP)->( DBCloseArea() ) 
	
	cQuerySR7 := " SELECT R7_MAT,R7_DATA,R7_FUNCAO,R7_DESCFUN "
	cQuerySR7 += " FROM " + RetSqlName("SR7") + " SR7 "
	cQuerySR7 += " WHERE  SR7.R7_MAT ='"+cMatEmp+"' AND 
	cQuerySR7 += " SR7.R7_DATA<='"+DTOS(dPerFinal)+"' AND 
	cQuerySR7 += " SR7.D_E_L_E_T_<>'*'  
	cQuerySR7 += " ORDER BY R7_MAT,R7_DATA DESC"  
	cQuerySR7 := ChangeQuery(cQuerySR7)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuerySR7),cAliasSR7,.T.,.T.)   
	
	(cAliasSR7)->( dbGoTop() ) 
	IF  !(cAliasSR7)->(Eof())  
		cFuncion := (cAliasSR7)->R7_FUNCAO 
	 	cDesFunc := (cAliasSR7)->R7_DESCFUN
	Endif
	(cAliasSR7)->( DBCloseArea() ) 
	
	
	cQuerySRE := " SELECT RE_MATD,RE_DATA,RE_PROCESP,RE_CCP "
	cQuerySRE += " FROM " + RetSqlName("SRE") + " SRE "
	cQuerySRE += " WHERE  SRE.RE_MATD ='"+cMatEmp+"' AND 
	cQuerySRE += " SRE.RE_DATA<='"+DTOS(dPerFinal)+"' AND 
	cQuerySRE += " SRE.D_E_L_E_T_<>'*'  
	cQuerySRE += " ORDER BY RE_MATD,RE_DATA DESC"  
	cQuerySRE := ChangeQuery(cQuerySRE)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuerySRE),cAliasSRE,.T.,.T.)   
	
	(cAliasSRE)->( dbGoTop() ) 
	IF  !(cAliasSRE)->(Eof())  
		cProceso := (cAliasSRE)->RE_PROCESP 
		cDesProc := POSICIONE("RCJ",RetOrdem("RCJ","RCJ_FILIAL+RCJ_CODIGO"),XFILIAL("RCJ")+cProceso,"RCJ_DESCRI")
	 	cCentroC := (cAliasSRE)->RE_CCP
	 	cDescCC  := POSICIONE("CTT",RetOrdem("CTT","CTT_FILIAL+CTT_CUSTO"),XFILIAL("CTT")+cCentroC,"CTT_DESC01")
	Endif                              
	(cAliasSRE)->( DBCloseArea() )
	
	RestArea(aArea)
Return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³RetPerAbertFechºAutor  ³Tatiane Matias º Data ³  01/12/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna os Periodos e Numeros de Pagamento Abertos e       º±±
±±º          ³ Fechados, dependendo do processo, roteiro e o intervalo de º±±
±±º          ³ de periodos/numero de pagamento passado.                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ cProcSel    - Processo                                     º±±
±±º          ³ cRotSel     - Roteiro                                      º±±
±±º          ³ cPeriodoDe  - Periodo Inicial                              º±±
±±º          ³ cNumPagDe   - Numero de Pagamento Inicial. Se "99" retorna º±±
±±º          ³               todos os numeros de pagamento.               º±±
±±º          ³ cPeriodoAte - Periodo Final                                º±±
±±º          ³ cNumPagAte  - Numero de Pagamento Final. Se "99" retorna   º±±
±±º          ³               todos os numeros de pagamento.               º±±
±±º          ³ aPerAberto  - Array que sera carregado com os per. abertos º±±
±±º          ³         Retorna apenas o periodo caso o numero de pagamentoº±±
±±º          ³         nao for passado.  - (aPerAberto[n][1]) 	    	  º±±
±±º          ³         Retorna o periodo e o numero de pagamento caso o   º±±
±±º          ³		   cNumPagDe/Ate for passado.  -                      º±±
±±º          ³		      (aPerAberto[n][1] e aPerAberto[n][2])           º±±
±±º          ³ aPerFechado - Array que sera carregado com os per. fechadosº±±
±±º          ³         Retorna apenas o periodo caso o numero de pagamentoº±±
±±º          ³         nao for passado.  - (aPerFechado[n][1]) 	    	  º±±
±±º          ³         Retorna o periodo e o numero de pagamento caso o   º±±
±±º          ³		   cNumPagDe/Ate for passado.  -                      º±±
±±º          ³		      (aPerFechado[n][1] e aPerFechado[n][2])         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GPER040                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function RetPer(	cProcSel	,;
							cRotSel		,;
							cPeriodoDe	,;
							cNumPagDe	,;
							cPeriodoAte	,;
							cNumPagAte	,;	
							aPerAberto	,;
							aPerFechado	 )

Local aArea			:= GetArea()
Local cMesDe		:= ""
Local cAnoDe		:= ""
Local cMesAte		:= ""
Local cAnoAte		:= ""
Local cAliasRCH 	:= ""
Local cKey			:= ""
Local cPer			:= ""
Local cTipoRot		:= fGetTipoRot( cRotSel )
Local dIni			:= CTOD("//")
Local dFim			:= CTOD("//")
Local bSkip			:= {}
Local aQueryCond    := {}
Local aRCHCols		:= {}
Local aRCHHeader	:= {}
Local aRCHVirtual	:= {}
Local aRCHVisual	:= {}
Local aRCHRecnos	:= {}
Local nRCHUsado		:= 0
Local nPosDtFech	:= 0
Local nPosPeriodo	:= 0
Local nPosNumPag	:= 0
Local nPosMes		:= 0
Local nPosAno		:= 0
Local nPosDtIni		:= 0
Local nPosDtFim		:= 0
Local nReg			:= 0
Local nPerTot		:= 0
Local nNumPagto		:= 0
Local lRotBlank

cAliasRCH := "RCH"
dbSelectArea(cAliasRCH)
dbSetOrder(4)

If ValType(cPeriodoAte) == "U"  
	If cNumPagDe <> "99"
		fPosPeriodo( xFilial("RCH"), cProcSel, cPeriodoDe, cNumPagDe, cRotSel,, @lRotBlank, 4 )
	Else
		fPosPeriodo( xFilial("RCH"), cProcSel, cPeriodoDe,, cRotSel,, @lRotBlank, nOrdem )
	EndIf
	
	If lRotBlank
		cRotSel	:= Space( GetSx3Cache( "RCH_ROTEIR", "X3_TAMANHO" ) )
	EndIf
	cPeriodoAte	:= cPeriodoDe
	cKey 	:= xFilial("RCH") + cProcSel + cRotSel + cPeriodoDe
	If cNumPagDe <> "99"
		cKey += cNumPagDe
	EndIf
	bSkip	:= { ||	.F. }

	#IfDef TOP     
		If cNumPagDe <> "99"
			aQueryCond		:= Array( 11 )
		Else
			aQueryCond		:= Array( 09 )
		EndIf
		aQueryCond[01]	:= " RCH_FILIAL = '" + xFilial("RCH") + "'"
		aQueryCond[02]	:= "  AND "
		aQueryCond[03]	:= " RCH_PROCES = '" + cProcSel + "'"
		aQueryCond[04]	:= "  AND "
		aQueryCond[05]	:= " RCH_ROTEIR = '" + cRotSel + "'"
		aQueryCond[06]	:= "  AND "
		aQueryCond[07]	:= " RCH_PER = '" + cPeriodoDe + "'"
		aQueryCond[08]	:= "  AND "
		If cNumPagDe <> "99"
			aQueryCond[09]	:= " RCH_NUMPAG = '" + cNumPagDe + "'"
			aQueryCond[10]	:= "  AND "
			aQueryCond[11]	:= " D_E_L_E_T_ = ' ' "
		Else
			aQueryCond[09]	:= " D_E_L_E_T_ = ' ' "
		EndIf

	#ENDIF

Else

	If cNumPagDe <> "99"
		fPosPeriodo( xFilial("RCH"), cProcSel, cPeriodoDe, cNumPagDe, cRotSel,, @lRotBlank, 4 )
	Else
		fPosPeriodo( xFilial("RCH"), cProcSel, cPeriodoDe,, cRotSel,, @lRotBlank, nOrdem )
	EndIf
	
	If lRotBlank
		cRotSel	:= Space( GetSx3Cache( "RCH_ROTEIR", "X3_TAMANHO" ) )
	EndIf

	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Seleciona o Mes/Ano Inicial do Periodo De                    ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	AnoMesPer(cProcSel, cRotSel, cPeriodoDe	, @cMesDe	, @cAnoDe)

	If cNumPagDe <> "99"
		fPosPeriodo( xFilial("RCH"), cProcSel, cPeriodoAte, cNumPagAte, cRotSel,, @lRotBlank, 4 )
	Else
		fPosPeriodo( xFilial("RCH"), cProcSel, cPeriodoAte,, cRotSel,, @lRotBlank, nOrdem )
	EndIf
	
	If lRotBlank
		cRotSel	:= Space( GetSx3Cache( "RCH_ROTEIR", "X3_TAMANHO" ) )
	EndIf

	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Seleciona o Mes/Ano Fim do Periodo De                        ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	AnoMesPer(cProcSel, cRotSel, cPeriodoAte, @cMesAte	, @cAnoAte)

   	dIni		:= CTOD("01/" + cMesDe + "/" + cAnoDe, "DDMMYYYY")
	dFim		:= CTOD("01/" + cMesAte + "/" + cAnoAte, "DDMMYYYY")

	cAliasRCH := "RCH"
	dbSelectArea(cAliasRCH)
	dbSetOrder(4)
	cKey 	:= xFilial("RCH") + cProcSel + cRotSel
	bSkip	:= { ||	( ;
						CTOD("01/" + RCH_MES + "/" + RCH_ANO, "DDMMYYYY") < dIni ;
						.OR. ;
	   		   		  	CTOD("01/" + RCH_MES + "/" + RCH_ANO, "DDMMYYYY") > dFim ;
	   				);
		   		}
	#IFDEF TOP     
		aQueryCond		:= Array( 07 )
		aQueryCond[01]	:= " RCH_FILIAL = '" + xFilial("RCH") + "'"
		aQueryCond[02]	:= "  AND "
		aQueryCond[03]	:= " RCH_PROCES = '" + cProcSel + "'"
		aQueryCond[04]	:= "  AND "
		aQueryCond[05]	:= " RCH_ROTEIR = '" + cRotSel + "'"
		aQueryCond[06]	:= "  AND "
		aQueryCond[07]	:= " D_E_L_E_T_ = ' ' "
	#ENDIF
EndIf

aRCHCols := GdMontaCols(@aRCHHeader		,;	//01 -> Array com os Campos do Cabecalho da GetDados
						@nRCHUsado		,;	//02 -> Numero de Campos em Uso
						@aRCHVirtual	,;	//03 -> [@]Array com os Campos Virtuais
						@aRCHVisual		,;	//04 -> [@]Array com os Campos Visuais
						"RCH"			,;	//05 -> Opcional, Alias do Arquivo Carga dos Itens do aCols
						NIL				,;	//06 -> Opcional, Campos que nao Deverao constar no aHeader
						@aRCHRecnos		,;	//07 -> [@]Array unidimensional contendo os Recnos
						"RCH"		   	,;	//08 -> Alias do Arquivo Pai
						cKey			,;	//09 -> Chave para o Posicionamento no Alias Filho
						NIL				,;	//10 -> Bloco para condicao de Loop While
						bSkip			,;	//11 -> Bloco para Skip no Loop While
						NIL				,;	//12 -> Se Havera o Elemento de Delecao no aCols 
						NIL				,;	//13 -> Se cria variaveis Publicas
						NIL				,;	//14 -> Se Sera considerado o Inicializador Padrao
						NIL				,;	//15 -> Lado para o inicializador padrao
						NIL				,;	//16 -> Opcional, Carregar Todos os Campos
						NIL			 	,;	//17 -> Opcional, Nao Carregar os Campos Virtuais
						aQueryCond		,;	//18 -> Opcional, Utilizacao de Query para Selecao de Dados
						.F.				,;	//19 -> Opcional, Se deve Executar bKey  ( Apenas Quando TOP )
						.T.				,;	//20 -> Opcional, Se deve Executar bSkip ( Apenas Quando TOP )
						NIL				,;	//21 -> Carregar Coluna Fantasma e/ou BitMap ( Logico ou Array )
						NIL			 	,;	//22 -> Inverte a Condicao de aNotFields carregando apenas os campos ai definidos
						NIL				,;	//23 -> Verifica se Deve Checar se o campo eh usado
						NIL			 	,;	//24 -> Verifica se Deve Checar o nivel do usuario
						.F.				 )	//25 -> Verifica se Deve Carregar o Elemento Vazio no aCols

aPerAberto 	:= {}
aPerFechado	:= {}                     
nPosDtFech	:= GdFieldPos("RCH_DTFECH"	, aRCHHeader)
nPosPeriodo	:= GdFieldPos("RCH_PER"		, aRCHHeader)
nPosNumPag	:= GdFieldPos("RCH_NUMPAG"	, aRCHHeader)
nPosMes		:= GdFieldPos("RCH_MES"	, aRCHHeader)
nPosAno		:= GdFieldPos("RCH_ANO"	, aRCHHeader)
nPosDtIni	:= GdFieldPos("RCH_DTINI"	, aRCHHeader)
nPosDtFim	:= GdFieldPos("RCH_DTFIM"	, aRCHHeader)

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Se o Numero de Pagamento nao foi Passado                     ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
If ValType(cNumPagDe) == "U"
	cNumPagDe 	:= 0
	cNumPagAte 	:= 0
	lNrPagto := .F.
Else
	cNumPagDe 	:= If(Empty(Alltrim(cNumPagDe))	, 0, Val(cNumPagDe))
	cNumPagAte := If(ValType(cNumPagAte) == "U", cNumPagDe , If(Empty(Alltrim(cNumPagAte)), 0, Val(cNumPagAte)))
	lNrPagto := .T.
EndIf
             
For nReg := 1 to Len(aRCHCols)     
	cPer		:= aRCHCols[nReg, nPosPeriodo]
	nNumPagto	:= If(Empty(Alltrim(aRCHCols[nReg, nPosNumPag])), 0, Val(aRCHCols[nReg, nPosNumPag]))
	
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Se numero de pagamento for "99", selecionar todos os numeros ³
	³ de pagamento do intervalo de periodo selecionado.            ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
    If !lNrPagto .OR. (lNrPagto .AND. cNumPagDe = 99 .AND. cNumPagAte = 99)
		If Empty(aRCHCols[nReg, nPosDtFech]) 
			If aScan(aPerAberto, {|x|	x[1] == cPer}) == 0
				aAdd(aPerAberto	, {cPer, ,aRCHCols[nReg, nPosMes],aRCHCols[nReg, nPosAno],aRCHCols[nReg, nPosDtini],aRCHCols[nReg, nPosDtFim]})
			Else
				aPerAberto[nReg,6] := aRCHCols[nReg,nPosDtFim]
			Endif	
		Else
			If aScan(aPerFechado, {|x|	x[1] == cPer}) == 0
				aAdd(aPerFechado, {cPer , ,aRCHCols[nReg, nPosMes],aRCHCols[nReg, nPosAno], aRCHCols[nReg, nPosDtini],aRCHCols[nReg, nPosDtFim]})
			Else
				APerFechado[nReg,6] := aRCHCols[nReg, nPosDtFim]
			Endif
		EndIf                      

		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Se numero de pagamento for diferente de "99", selecionar     ³
		³ apenas o intervalo de numero de pagamento do intervalo de    ³
		³ periodo selecionado.                                         ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
    ElseIf lNrPagto .AND.;
	    !((cPer < cPeriodoDe) .or. ( cPer > cPeriodoAte) .or. ;
		((cPer = cPeriodoDe) .and. (nNumPagto < cNumPagDe)) .or. ;
		((cPer = cPeriodoAte) .and. (nNumPagto > cNumPagAte)))
		If Empty(aRCHCols[nReg, nPosDtFech]) .AND. aScan(aPerAberto, {|x|	x[1] == cPer .AND. x[2] == aRCHCols[nReg, nPosNumPag]}) == 0
			aAdd(aPerAberto	, {cPer, aRCHCols[nReg, nPosNumPag],aRCHCols[nReg, nPosMes],aRCHCols[nReg, nPosAno], aRCHCols[nReg, nPosDtini],aRCHCols[nReg, nPosDtFim]})
		ElseIf aScan(aPerFechado, {|x|	x[1] == cPer .AND. x[2] == aRCHCols[nReg, nPosNumPag]}) == 0
			aAdd(aPerFechado, {cPer, aRCHCols[nReg, nPosNumPag],aRCHCols[nReg, nPosMes],aRCHCols[nReg, nPosAno], aRCHCols[nReg, nPosDtini],aRCHCols[nReg, nPosDtFim]})
		EndIf
	EndIf
Next nReg

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Quando o Roteiro pertencer a Autonomos, deverar gerar os pe- ³
³ riodos repetidos, alterando somente o numero de pagamento.   ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
If cTipoRot == "9"
	fPosPeriodo( xFilial("RCH"), cProcSel, cPeriodoDe,, cRotSel,, @lRotBlank, nOrdem )
	If RCH->( !Eof() )
		nPerTot := (cNumPagAte - cNumPagDe)+1
		If nPerTot < 0
			nPerTot := -nPerTot
		EndIf
		For nReg := 1 To nPerTot
			If Empty(RCH->RCH_DTFECH)
				aAdd(aPerAberto	, RCH->({RCH_PER, If( cNumPagAte == cNumPagDe, StrZero(cNumPagDe, 2), StrZero(nReg, 2)),RCH_MES,RCH_ANO, RCH_DTINI, RCH_DTFIM}))
			Else
				aAdd(aPerFechado, RCH->({RCH_PER, If( cNumPagAte == cNumPagDe, StrZero(cNumPagDe, 2), StrZero(nReg, 2)),RCH_MES,RCH_ANO, RCH_DTINI, RCH_DTFIM}))
			EndIf
		Next nReg
	EndIf
EndIf

RestArea( aArea )

Return ( NIL )                         

Static function getRoteir()
	Local cRot:= ""
	Local cQuery:= ''  
	Local cTmpBus := ""
		
		cTmpBus	  := criatrab(nil,.F.) 	// Tabla temporal
		cRCH	  := InitSqlName("RCH") 	// Se obtiene el nombre  fisico de la tabla
		cSRA	  := InitSqlName("SRA")
		cSRY	  := InitSqlName("SRY")
			                                                                       
		cQuery := "SELECT RY_CALCULO AS NOM "
		cQuery += "FROM " 
		cQuery +=	cRCH +	" RCH," 
		cQuery +=	cSRA +  " SRA,"
		cQuery +=	cSRY +  " SRY "
		cQuery += "WHERE  "
		cQuery += 	"RA_FILIAL='"+XFILIAL("SRA")+"' AND RCH_FILIAL='"+XFILIAL("RCH")+"' AND RY_FILIAL='"+XFILIAL("SRY") +"' AND "
		cQuery += 	"RA_MAT='"+ SRA->RA_MAT +"' AND "  
		cQuery +=   "RCH_PER='"+ cPeriodo +"' AND RCH_NUMPAG='" +Semana+ "' AND "
		cquery +=	"RCH_PROCES=RA_PROCES AND RCH_ROTEIR=RY_CALCULO AND "
		cQuery +=	"RY_ORDINAR='1' AND RY_TIPO='1' AND "
		cQuery += 	"SRY.D_E_L_E_T_=' ' AND SRA.D_E_L_E_T_=' ' AND RCH.D_E_L_E_T_=' '" 
	
		cQuery := ChangeQuery(cQuery)                         	
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cTmpBus,.T.,.T.) 
		(cTmpBus)->(dbGoTop()) 
		nRegs := 0
		Count to nRegs	    
			(cTmpBus)->(dbgotop())
			While (cTmpBus)->(!eof()) 
				
					cRot:=(cTmpBus)->NOM  
				(cTmpBus)->(dbskip()) 
			End Do
			(cTmpBus)->(dbCloseArea())   
   
Return    cRot

                       

