#INCLUDE "imprecper.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "topconn.ch"
#INCLUDE "TBICONN.CH"

#define DMPAPER_A4 9
// A4 210 x 297 mm

#IFNDEF CRLF
	#DEFINE CRLF ( chr(13)+chr(10) )
#ENDIF

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ IMPRECPER  ³ Autor ³ Cesar Perea          ³ Data ³ 2018	                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissao de Recibos de Pagamento                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ IMPRECPER  (void)                                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS/FNC  ³  Motivo da Alteracao                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  Copia del fuente GPER030PER, convertido en user funtion   IMPRECPER                 ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 
User Function ImpRecPer (lTerminal,cFilTerminal,cMatTerminal,cProcTerminal, nRecTipo, cPerTerminal, cSemanaTerminal)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Locais (Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cString :="SRA"        // alias do arquivo principal (Base)
Local aOrd   := {STR0001,STR0002,STR0003,STR0004,STR0005,STR0177,STR0178} //"Matricula"###"C.Custo"###"Nome"###"Chapa"###"C.Custo + Nome"###"Depto."###"Depto. + Nome"
Local cDesc1 := STR0006		//"Emiss„o de Recibos de Pagamento."
Local cDesc2 := STR0007		//"Ser  impresso de acordo com os parametros solicitados pelo"
Local cDesc3 := STR0008		//"usu rio."


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Locais (Programa)                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cIndCond
Local cRotBlank := Space(GetSx3Cache( "RCH_ROTEIR", "X3_TAMANHO" ))
Local cHtml 	:= ""

Private cBaseAux:= ""
Private cMes	:= ""
Private cAno    := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o numero da linha de impressão como 0                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetPrc(0,0)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Private(Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aReturn  := {STR0009, 1,STR0010, 2, 2, 1, "",1 }	//"Zebrado"###"Administra‡„o"


Private nLastKey := 0
Private cPerg    :="GPER030PER"
Private nAteLim , nBaseFgts , nFgts , nBaseIr , nBaseIrFe




//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Private(Programa)                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aLanca 		:= {}
Private aProve 		:= {}
Private aDesco 		:= {}
Private aBases 		:= {}
Private aInfo  		:= {}
Private aCodFol		:= {}
Private li     		:= _PROW()
Private Titulo 		:= STR0011		//"EMISSO DE RECIBOS DE PAGAMENTOS"
Private lEnvioOk 	:= .F.
Private lRetCanc	:= .t.
Private cIRefSem    := GetMv("MV_IREFSEM",,"S")
Private aPerAberto	:= {}
Private aPerFechado	:= {}
Private cProcesso	:= "" // Armazena o processo selecionado na Pergunte GPR040 (mv_par01).
Private cRoteiro	:= "" // Armazena o Roteiro selecionado na Pergunte GPR040 (mv_par02).
Private cPeriodo	:= "" // Armazena o Periodo selecionado na Pergunte GPR040 (mv_par03).


Private cRot		:= ""

Private Semana:= "" 
Private cSemana:= "" 
Private cArquivo    	:= "firmarec.bmp"	//Nome do arquivo Bitmap que sera impresso na primeira pagina
Private cArquivoC 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="GPER030PER"            //Nome Default do relatorio em Disco


If !File(cArquivo)
MsgAlert(OemToAnsi(STR0013)+cArquivo)	//-"Arquivo não encontrado -> "
Return
EndIf      
cArquivoC	:= fLoadLogo(cArquivo)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o programa foi chamado do terminal - TCF         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lTerminal := If( lTerminal == Nil, .F., lTerminal )

IF !( lTerminal )
	wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd)
EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define a Ordem do Relatorio                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nOrdem := IF( !( lTerminal ), aReturn[8] , 1 )



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙadmin
Pergunte(cPerg, .F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carregando variaveis mv_par?? para Variaveis do Sistema.     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cSemanaTerminal := IF( Empty( cSemanaTerminal ) , Space( Len( SRC->RC_SEMANA ) ) , cSemanaTerminal )
cProcesso  := IF( !( lTerminal ), mv_par01 , cProcTerminal		)   //Processo
cRoteiro   := IF( !( lTerminal ), mv_par02 , nRecTipo			)	//Emitir Recibos(Roteiro)
cPeriodo   := IF( !( lTerminal ), mv_par03 , cPerTerminal		)   //Periodo
Semana     := IF( !( lTerminal ), mv_par04 , cSemanaTerminal	)	//Numero da Semana
cSemana    := Semana

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verificar se o sistema esta trabalhando com ou sem roteiro   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea( "RCH" )
DbSetOrder( 4 )
IF DbSeek(  xFilial( "RCH" ) + cProcesso + cRoteiro + cPeriodo + Semana, .F. )
	If Eof()
		DbSeek(  xFilial( "RCH" ) + cProcesso + cRotBlank + cPeriodo + Semana, .F. )
	Else
		cRotBlank := cRoteiro
	EndIf
EndIf

//Carregar os periodos abertos (aPerAberto) e/ou
// os periodos fechados (aPerFechado), dependendo
// do periodo (ou intervalo de periodos) selecionado
RetPerAbertFech(cProcesso	,; // Processo selecionado na Pergunte.
cRotBlank	,; // Roteiro selecionado na Pergunte.
cPeriodo	,; // Periodo selecionado na Pergunte.
Semana		,; // Numero de Pagamento selecionado na Pergunte.
NIL			,; // Periodo Ate - Passar "NIL", pois neste relatorio eh escolhido apenas um periodo.
NIL			,; // Numero de Pagamento Ate - Passar "NIL", pois neste relatorio eh escolhido apenas um numero de pagamento.
@aPerAberto	,; // Retorna array com os Periodos e NrPagtos Abertos
@aPerFechado ) // Retorna array com os Periodos e NrPagtos Fechados

// Retorna o mes e o ano do periodo selecionado na pergunte.
AnoMesPer(	cProcesso	,; // Processo selecionado na Pergunte.
cRotBlank	,; // Roteiro selecionado na Pergunte.
cPeriodo	,; // Periodo selecionado na Pergunte.
@cMes		,; // Retorna o Mes do Processo + Roteiro + Periodo selecionado
@cAno		,; // Retorna o Ano do Processo + Roteiro + Periodo selecionado
Semana		 ) // Retorna a Semana do Processo + Roteiro + Periodo selecionado
dDataRef := CTOD("01/" + cMes + "/" + cAno)

nTipRel    := IF( !( lTerminal ), mv_par05 , 2					)	//Tipo de Recibo (Pre/EMail)
cFilDe     := IF( !( lTerminal ), mv_par06,cFilTerminal		)	//Filial De
cFilAte    := IF( !( lTerminal ), mv_par07,cFilTerminal		)	//Filial Ate
cCcDe      := IF( !( lTerminal ), mv_par08,SRA->RA_CC			)	//Centro de Custo De
cCcAte     := IF( !( lTerminal ), mv_par09,SRA->RA_CC			)	//Centro de Custo Ate
cMatDe     := IF( !( lTerminal ), mv_par10,cMatTerminal		)	//Matricula Des
cMatAte    := IF( !( lTerminal ), mv_par11,cMatTerminal		)	//Matricula Ate
cNomDe     := IF( !( lTerminal ), mv_par12,SRA->RA_NOME		)	//Nome De
cNomAte    := IF( !( lTerminal ), mv_par13,SRA->RA_NOME		)	//Nome Ate
ChapaDe    := IF( !( lTerminal ), mv_par14,SRA->RA_CHAPA 		)	//Chapa De
ChapaAte   := IF( !( lTerminal ), mv_par15,SRA->RA_CHAPA 		)	//Chapa Ate
Mensag1    := mv_par16										 	//Mensagem 1
Mensag2    := mv_par17											//Mensagem 2
Mensag3    := mv_par18											//Mensagem 3
cSituacao  := IF( !( lTerminal ),mv_par19, fSituacao( NIL , .F. ) )	//Situacoes a Imprimir
cCategoria := IF( !( lTerminal ),mv_par20, fCategoria( NIL , .F. ))	//Categorias a Imprimir
cBaseAux   := If(mv_par21 == 1,"S","N")							//Imprimir Bases
cDeptoDe   := IF( !( lTerminal ),mv_par22,SRA->RA_DEPTO 		)	//Depto. De
cDeptoAte  := IF( !( lTerminal ),mv_par23,SRA->RA_DEPTO 		)	//Depto. Ate

if nTipRel == 2 
	nTipRel := 3
Endif

If aReturn[5] == 1 .and. nTipRel == 1
	li	:=  0
EndIf

cMesAnoRef := StrZero(Month(dDataRef),2) + StrZero(Year(dDataRef),4)
IF !( lTerminal )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa Impressao                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ! fInicia(cString,nTipRel)
		Return
	Endif
Else
	
EndIF

DbSelectArea( "SRA" )
IF nTipRel==3
	IF lTerminal
		cHtml := R030Imp(.F.,wnRel,cString,cMesAnoRef,lTerminal)
	Else
		ProcGPE({|lEnd| R030IMP(@lEnd,wnRel,cString,cMesAnoRef,.f.)},,,.T.)  // Chamada do Processamento
	EndIF
Else
	RptStatus({|lEnd| R030Imp(@lEnd,wnRel,cString,cMesAnoRef,.f.)},Titulo)  // Chamada do Relatorio
EndIF

Return( IF( lTerminal , cHtml , NIL ) )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ R030IMP  ³ Autor ³                       ³ Data ³   2018   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Processamento Para emissao do Recibo                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ R030Imp(lEnd,WnRel,cString,cMesAnoRef,lTerminal)			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function R030Imp(lEnd,WnRel,cString,cMesAnoRef,lTerminal)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Locais (Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cAcessaSR1  := &("{ || " + ChkRH("GPER030","SR1","2") + "}")
Local cAcessaSRA  := &("{ || " + ChkRH("GPER030","SRA","2") + "}")
Local cAcessaSRC  := &("{ || " + ChkRH("GPER030","SRC","2") + "}")
Local cAcessaSRD  := &("{ || " + ChkRH("GPER030","SRD","2") + "}")
Local cNroHoras   := &("{ || If(aVerbasFunc[nReg,5] > 0 .And. cIRefSem == 'S', aVerbasFunc[nReg,5], aVerbasFunc[nReg,6]) }")
Local cHtml		  := ""
Local nHoras      := 0

//Local nX
Local nReg		  := 0

Local cKey		  := ""
Local cInicio	  := ""

Local dDataLibRH
Local cPerCorrente	:= ""
Local cSemCorrente	:= ""
Local cMesCorrente 	:= ""
Local cAnoCorrente 	:= ""

Local nTcfDadt		:= if(lTerminal,getmv("MV_TCFDADT",,0),0)		// indica o dia a partir do qual esta liberada a consulta ao TCF
Local nTcfDfol		:= if(lTerminal,getmv("MV_TCFDFOL",,0),0)		// indica a quantidade de dias a somar ou diminuir no ultimo dia do mes corrente para liberar a consulta do TCF
Local nTcfD131		:= if(lTerminal,getmv("MV_TCFD131",,0),0)		// indica o dia a partir do qual esta liberada a consulta ao TCF
Local nTcfD132		:= if(lTerminal,getmv("MV_TCFD132",,0),0)		// indica o dia a partir do qual esta liberada a consulta ao TCF
Local nTcfDext		:= if(lTerminal,getmv("MV_TCFDEXT",,0),0)		// indica o dia a partir do qual esta liberada a consulta ao TCF
Local nDec

//Private tamanho     := "M"
//Private limite		:= 132
Private cDtPago     := ""
Private cTipoRot 	:= PosAlias("SRY", cRoteiro, SRA->RA_FILIAL, "RY_TIPO")
Private aVerbasFunc := {}
Private cRotBlank
Private nHraExtra 	:= 0
Private nPagoDom	:= 0

Private cPict1		:= "@E 999,999,999.99"
Private cPict2 		:= "@E 99,999,999.99"
Private cPict3 		:= "999,999.99"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis da Impressao Grafica                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private oPrint
Private oArial06	:= TFont():New("Arial",06,06,,.F.,,,,.T.,.F.)//Normal
Private oArial07	:= TFont():New("Arial",07,07,,.F.,,,,.T.,.F.)//Normal
Private oFont08		:= TFont():New("Courier New",08,08,,.F.,,,,.T.,.F.)//Normal
Private oArial08	:= TFont():New("Arial",08,08,,.F.,,,,.T.,.F.)//Normal
Private oArial08N	:= TFont():New("Arial",08,08,,.T.,,,,.T.,.F.)//Negrito
Private oArial10N	:= TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)//Negriot
Private lRit  :=  .F.

//-Ordem 1 -> RCA_FILIAL+RCA_MNEMON
If FPOSREG("RCA", 1, XFILIAL("RCA")+"RHDECIMAIS")
	nDec := Val(Alltrim(RCA->RCA_CONTEU))
Else
	nDec := MsDecimais(1)
EndIf

If nDec = 0
	cPict1	:=	"@E 99,999,999,999"
	cPict2 	:=	"@E 9,999,999,999"
	cPict3 	:=	"@E 99,999,999"
Endif

// Ajuste do tipo da variavel
nTcfDadt	:= if(valtype(nTcfDadt)=="C",val(nTcfDadt),nTcfDadt)
nTcfD131	:= if(valtype(nTcfD131)=="C",val(nTcfD131),nTcfD131)
nTcfD132	:= if(valtype(nTcfD132)=="C",val(nTcfD132),nTcfD132)
nTcfDfol	:= if(valtype(nTcfDfol)=="C",val(nTcfDfol),nTcfDfol)
nTcfDext	:= if(valtype(nTcfDext)=="C",val(nTcfDext),nTcfDext)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Verifica se o Mes solicitado esta liberado para consulta no  |
//| terminal de consulta do funcionario.                         |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lTerminal
	
	dbSelectArea("RCH")
	dbSetOrder(6)
	
		cKey    := "xFilial('RCH') + cProcesso" + IIf(cRoteiro == "EXT", "", " + cRoteiro")
		cInicio := "RCH_FILIAL + RCH_PROCES" + IIf(cRoteiro == "EXT", "", " + RCH_ROTEIR")
	
	
	DbSeek( &(cKey))
	If Eof()
		cRotBlank 	:= Space(GetSx3Cache( "RCH_ROTEIR", "X3_TAMANHO" ))
		cKey := "xFilial('RCH') + cProcesso " + IIf(cRoteiro == "EXT", "", " + cRotBlank")
		cInicio := "RCH_FILIAL + RCH_PROCES " + IIf(cRoteiro == "EXT", "", " + RCH_ROTEIR")
		DbSeek( &(cKey))
	EndIf
	If !Eof()
		While RCH->( !Eof() .and. &(cInicio) == &(cKey))
			If Empty(RCH->RCH_DTFECH)
				cPerCorrente := RCH->RCH_PER
				cSemCorrente := RCH->RCH_NUMPAG
				cMesCorrente := RCH->RCH_MES
				cAnoCorrente := RCH->RCH_ANO
				Exit
			EndIf
			RCH->( dbSkip() )
		EndDo
	EndIf
	
	If	(cPerCorrente == cPeriodo .AND. cSemCorrente == Semana)  .OR. ;
		( MesAno(dDataRef) >= (cAnoCorrente + cMesCorrente) )
		
		If  cTipoRot == "2" //Adiantamento
			If ( MesAno(dDataRef) > (cAnoCorrente + cMesCorrente) ) .Or.;
				( If(MesAno(Date()) == (cAnoCorrente + cMesCorrente), Day(Date()) < nTcfDadt,.F.) )
				Return( IF( lTerminal <> NIL .And. lTerminal , cHtml , NIL ) )
			EndIf
		ElseIf cTipoRot == "1" .and. !empty(nTCFDFOL) //Folha
			dDataLibRH := fMontaDtTcf(cMesCorrente + cAnoCorrente,nTCFDFOL)
			If Date() < dDataLibRH
				Return( IF( lTerminal <> NIL .And. lTerminal , cHtml , NIL ) )
			Endif
		ElseIf cTipoRot == "5" //1a parcela 13o Salario
			If ( MesAno(dDataRef) > (cAnoCorrente + cMesCorrente) ) .Or.;
				( If(MesAno(Date()) == (cAnoCorrente + cMesCorrente), Day(Date()) < nTcfD131,.F.) )
				Return( IF( lTerminal <> NIL .And. lTerminal , cHtml , NIL ) )
			Endif
		ElseIf cTipoRot == "6" //2a parcela 13o Salario
			If ( MesAno(dDataRef) > (cAnoCorrente + cMesCorrente) ) .Or.;
				( If(MesAno(Date()) == (cAnoCorrente + cMesCorrente), Day(Date()) < nTcfD132,.F.) )
				Return( IF( lTerminal <> NIL .And. lTerminal , cHtml , NIL ) )
			Endif
		ElseIf cRoteiro == "EXT"  // Valores Extras
			If ( MesAno(dDataRef) > (cAnoCorrente + cMesCorrente) ) .Or.;
				( If(MesAno(Date()) == (cAnoCorrente + cMesCorrente), Day(Date()) < nTcfDext,.F.) )
				Return( IF( lTerminal <> NIL .And. lTerminal , cHtml , NIL ) )
			Endif
		EndIf
	Endif
Endif



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Selecionando a Ordem de impressao escolhida no parametro.    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea( "SRA")
IF !( lTerminal )
	If nOrdem == 1			//"Matricula"
		dbSetOrder(1)
	ElseIf nOrdem == 2		//"C.Custo"
		dbSetOrder(2)
	ElseIf nOrdem == 3		//"Nome"
		dbSetOrder(3)
	Elseif nOrdem == 4		//"Chapa"
		cArqNtx  := CriaTrab(NIL,.f.)
		cIndCond :="RA_Filial + RA_Chapa + RA_Mat"
		IndRegua("SRA",cArqNtx,cIndCond,,,STR0012)		//"Selecionando Registros..."
		
	ElseIf nOrdem == 5		//"C.Custo + Nome"
		dbSetOrder(8)
	ElseIf nOrdem == 6		//"Depto"
		dbSetOrder(19)
	ElseIf nOrdem == 7		//"Depto. + Nome"
		dbSetOrder(20)
	Endif
	
	dbGoTop()
	
//	If nTipRel == 2
	//	@ LI,00 PSAY AvalImp(Limite)
	//Endif
EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Selecionando o Primeiro Registro e montando Filtro.          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nOrdem == 1 .or. lTerminal
	cInicio := "SRA->RA_FILIAL + SRA->RA_MAT"
	IF !( lTerminal )
		dbSeek(cFilDe + cMatDe,.T.)
		cFim    := cFilAte + cMatAte
	Else
		cFim    := &(cInicio)
	EndIF
ElseIf nOrdem == 2
	dbSeek(cFilDe + cCcDe + cMatDe,.T.)
	cInicio  := "SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT"
	cFim     := cFilAte + cCcAte + cMatAte
ElseIf nOrdem == 3
	dbSeek(cFilDe + cNomDe + cMatDe,.T.)
	cInicio := "SRA->RA_FILIAL + SRA->RA_NOME + SRA->RA_MAT"
	cFim    := cFilAte + cNomAte + cMatAte
ElseIf nOrdem == 4
	dbSeek(cFilDe + ChapaDe + cMatDe,.T.)
	cInicio := "SRA->RA_FILIAL + SRA->RA_CHAPA + SRA->RA_MAT"
	cFim    := cFilAte + ChapaAte + cMatAte
ElseIf nOrdem == 5
	dbSeek(cFilDe + cCcDe + cNomDe,.T.)
	cInicio  := "SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_NOME"
	cFim     := cFilAte + cCcAte + cNomAte
ElseIf nOrdem == 6
	dbSeek(cFilDe + cDeptoDe + cMatDe,.T.)
	cInicio  := "SRA->RA_FILIAL + SRA->RA_DEPTO + SRA->RA_MAT"
	cFim     := cFilAte + cDeptoAte + cMatAte
ElseIf nOrdem == 7
	dbSeek(cFilDe + cDeptoDe + cNomDe,.T.)
	cInicio  := "SRA->RA_FILIAL + SRA->RA_DEPTO + SRA->RA_NOME"
	cFim     := cFilAte + cDeptoAte + cNomAte
Endif

dbSelectArea("SRA")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega Regua Processamento                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF nTipRel # 3
	SetRegua(RecCount())	// Total de elementos da regua
Else
	IF !( lTerminal )
		GPProcRegua(RecCount())// Total de elementos da regua
	EndIF
EndIF

TOTVENC:= TOTDESC:= TOTBAS:=  0

SPRES:= DTRAB:= HSTRAB:= HSEXT:= AUS := DMEDIC := TARDS:=PERPAG:= 0

Desc_Fil := Desc_End :=  ""
Desc_Comp:= Desc_Est := Desc_Cid:= DESC_Bair := ""
DESC_MSG1:= DESC_MSG2:= DESC_MSG3:= " "
cFilialAnt := Space(FwGetTamFilial)
//Vez        := 0
ORDEMZ     := 0

If nTipRel == 1 .and. !( lTerminal )
	
		oPrint:= TMSPrinter():New(Titulo)//Emissao de Recibos de Pagamentos
		oPrint:SetPortrait()            //Define que a impressao deve ser RETRATO//
		oPrint:setPaperSize(DMPAPER_A4) //Defino Tamaño de Papel A4
	
Endif

While SRA->( !Eof() .And. &cInicio <= cFim )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Movimenta Regua Processamento                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF !( lTerminal )
		
		IF nTipRel # 3
			IncRegua()  // Anda a regua
		ElseIF !( lTerminal )
			GPIncProc(SRA->RA_FILIAL+" - "+SRA->RA_MAT+" - "+SRA->RA_NOME)
		EndIF
		
		If lEnd
			//@Prow()+1,0 PSAY cCancel
			Exit
		Endif
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Consiste Parametrizacao do Intervalo de Impressao            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (SRA->RA_CHAPA < ChapaDe)  .Or.  (SRA->RA_CHAPa > ChapaAte) .Or. ;
			(SRA->RA_NOME < cNomDe)    .Or. (SRA->RA_NOME > cNomAte)   .Or. ;
			(SRA->RA_MAT < cMatDe)     .Or. (SRA->RA_MAT > cMatAte)    .Or. ;
			(SRA->RA_CC < cCcDe)       .Or. (SRA->RA_CC > cCcAte)      .Or. ;
			(SRA->RA_DEPTO < cDeptoDe) .Or. (SRA->RA_DEPTO > cDeptoAte)
			
			
			
			SRA->(dbSkip(1))
			Loop
		Else
			
		EndIf
		
	EndIF
	
	
	
	aLanca:={}         // Zera Lancamentos
	aProve:={}         // Zera Lancamentos
	aDesco:={}         // Zera Lancamentos
	aBases:={}         // Zera Lancamentos
	nAteLim := nBaseFgts := nFgts := nBaseIr := nBaseIrFe := 0.00
	
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica Data Demissao         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cSitFunc := SRA->RA_SITFOLH
	dDtPesqAf:= CTOD("01/" + Left(cMesAnoRef,2) + "/" + Right(cMesAnoRef,4),"DDMMYY")
	If cSitFunc == "D" .And. (!Empty(SRA->RA_DEMISSA) .And. MesAno(SRA->RA_DEMISSA) > MesAno(dDtPesqAf))
		cSitFunc := " "
	Endif
	
	IF !( lTerminal )
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Consiste situacao e categoria dos funcionarios			     |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !( cSitFunc $ cSituacao ) .OR.  ! ( SRA->RA_CATFUNC $ cCategoria )
			dbSkip()
			Loop
		Endif
		If cSitFunc $ "D" .And. Mesano(SRA->RA_DEMISSA) # Mesano(dDataRef)
			dbSkip()
			Loop
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Consiste controle de acessos e filiais validas				 |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !(SRA->RA_FILIAL $ fValidFil()) .Or. !Eval(cAcessaSRA)
			dbSkip()
			Loop
		EndIf
		
	EndIF
		 
	If SRA->RA_Filial # cFilialAnt
		If ! Fp_CodFol(@aCodFol,Sra->Ra_Filial) .Or. ! fInfo(@aInfo,Sra->Ra_Filial)
			Exit
		Endif
		
		Desc_Fil  := aInfo[3]
		Desc_End  := aInfo[4]                // Dados da Filial
		DESC_Bair := SM0->M0_BAIRENT
		Desc_CGC  := aInfo[8]
		
		DESC_MSG1:= DESC_MSG2:= DESC_MSG3:= Space(01)
		Desc_Est := Substr(fDesc("SX5","12"+aInfo[6],"X5DESCRI()"),1,12)
		Desc_Comp:= aInfo[14]        			// Complemento Cobranca
		Desc_Cid := aInfo[05]
		// MENSAGENS
		If !Empty(MENSAG1)
			If FPHIST82(SRA->RA_FILIAL, "06", MENSAG1)
				DESC_MSG1 := Left(SRX->RX_TXT,30)
			Endif
		Endif
		
		If !Empty(MENSAG2)
			If FPHIST82(SRA->RA_FILIAL, "06", MENSAG2)
				DESC_MSG2 := Left(SRX->RX_TXT,30)
			Endif
		Endif
		
		If !Empty(MENSAG3)
			If FPHIST82(SRA->RA_FILIAL, "06", MENSAG3)
				DESC_MSG3 := Left(SRX->RX_TXT,30)
			Endif
		Endif
		
		dbSelectArea("SRA")
		cFilialAnt := SRA->RA_FILIAL
	Endif
	
	Totvenc := Totbas:= Totdesc := 0
	
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
			If (Len(aPerAberto) > 0 .AND. !Eval(cAcessaSRC)) .OR. (Len(aPerFechado) > 0 .AND. !Eval(cAcessaSRD)) .Or.;
				( aVerbasFunc[nReg,7] <= 0 )
				dbSkip()
				Loop
			EndIf
			
			If  cBaseAux = "N"
				if PosSrv( aVerbasFunc[nReg,3] , SRA->RA_FILIAL , "RV_TIPOCOD" ) $ "34" .and. !(ALLTRIM(SRV->RV_CODFOL) $ "1411/0054")
					dbSkip()
					Loop
				Endif
			Endif
			
			If PosSrv( aVerbasFunc[nReg,3] , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1"
				
				nHoras := Eval(cNroHoras)
				
				fSomaPdRec("P",aVerbasFunc[nReg,3],nHoras,aVerbasFunc[nReg,7])
				TOTVENC += aVerbasFunc[nReg,7]
				
				
				
				
			Elseif SRV->RV_TIPOCOD == "2"
				fSomaPdRec("D",aVerbasFunc[nReg,3],Eval(cNroHoras),aVerbasFunc[nReg,7])
				TOTDESC += aVerbasFunc[nReg,7]
			Elseif SRV->RV_TIPOCOD $ "3/4" .and. ALLTRIM(SRV->RV_IMPRIPD) == "1"
					  
					If (aVerbasFunc[nReg,3] <> aCodFol[047,1])
						fSomaPdRec("B",aVerbasFunc[nReg,3],Eval(cNroHoras),aVerbasFunc[nReg,7])
						TOTBAS += aVerbasFunc[nReg,7]
					Endif

				
			ElseIf SRV->RV_TIPOCOD $ "3/4" .and. ALLTRIM(SRV->RV_CODFOL) $ "0054"
			
				AUS += aVerbasFunc[nReg,6]
			ElseIf SRV->RV_TIPOCOD $ "3/4" .and. ALLTRIM(SRV->RV_CODFOL) $ "1411"
				HSEXT += aVerbasFunc[nReg,6]
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
					TOTBAS = TOTBAS + SR1->R1_VALOR
				Endif
				dbskip()
			Enddo
		Endif
	Endif
	
	
	dbSelectArea("SRA")
	
	If TOTVENC = 0 .And. TOTDESC = 0
		dbSkip()
		Loop
	Endif
	
	If nTipRel == 1 .and. !( lTerminal )
		
		//  Alert("Impresion se recibo grafico")
		fImpreGraf()
		/*IF !( lTerminal )
			If Vez = 0  .and. nTipRel # 3  .and. aReturn[5] # 1
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Descarrega teste de impressao                                ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				fImpTeste(cString)
				If !lRetCanc
					Exit
				Endif
				TotDesc := TotVenc := 0
		//		If nTipRel == 2
			//		Loop
				//Endif
				
			ENDIF
		EndIF*/
	/*ElseIf nTipRel == 2 .and. !( lTerminal )
		For nX := 1 to 1
		
				fImpreZebr()
		
		Next nX
		ASize(aProve,0)
		ASize(aDesco,0)
		ASize(aBases,0)*/
	ElseIf nTipRel == 3 .or. lTerminal
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Ponto de entrada para alterar layout do recibo.				 |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ExistBlock("GP030HTM")
			cHtml := ExecBlock("GP030HTM",.F.,.F.)
		Else
			cHtml := fSendDPgto(lTerminal)   //Monta o corpo do e-mail e envia-o
		Endif
	Endif
	
	dbSelectArea("SRA")
	SRA->( dbSkip() )
	TOTDESC := TOTVENC := 0
	
EndDo



If nTipRel == 1 .and. !( lTerminal )
	
		oPrint:Preview()
	
Endif

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
	
	Set Device To Screen
	
	If lEnvioOk
		APMSGINFO(STR0042)
	ElseIf nTipRel== 3
		APMSGINFO(STR0043)
	EndIf
	SeTPgEject(.F.)
	
	
	
	
	MS_FLUSH()
	
EndIF

Return( cHtml )



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fImpreZebr³ Autor ³ R.H. - Ze Maria       ³ Data ³ 14.03.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMRESSAO DO RECIBO FORMULARIO ZEBRADO                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fImpreZebr()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
/*Static Function fImpreZebr()

Local nConta    := nContr := nContrT:=0

If li >= 60
	li := 0
Endif
	fCabecZPer()
	fLancaZ(nConta)

Return Nil
*/
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fImpreGraf³ Autor ³ SSERVICE				³ Data ³ 05.05.08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMRESSAO DO RECIBO FORMULARIO GRAFICO                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fImpreGraf()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fImpreGraf()


Local nConta    := 0
Private nRe2    := 1800

fcabecg()
fLancaG(nConta)

Return Nil



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fCabecG   ³ Autor ³ SSERVICE              ³ Data ³ 04.05.08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMRESSAO Cabe‡alho Grafico                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fCabecG()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fCabecG()   // Cabecalho do Recibo Zebrado
Local cCodFunc		:= ""		//-- codigo da Funcao do funcionario
Local cDescFunc		:= ""		//-- Descricao da Funcao do Funcionario
Local cStartPath	:= GetSrvProfString("Startpath","")
Local cNome         := ""
Local cDoc          := ''
Local cFECVAC       := fSRF(SRA->RA_MAT,IIF(ALLTRIM(DTOS(SRA->RA_DTREC))<>"",DTOS(SRA->RA_DTREC),DTOS(SRA->RA_ADMISSA)))
Local cPenEmp       := ''
Local cDataBase		:=''
Local cCargo		:= ""
Local cDesSit		:=''
Local cDesSex		:=''

Local cMonDes		:=''
Local nPosTab		:=0

Local cDescr        := ""
local cDesTrb       := ""

oPrint:StartPage()
oPrint:Box(20,15,200,2400 )
oPrint:SayBitmap(030,060,cStartPath+"lgrl"+FwCodEmp("SM0")+".bmp",200,100) // Tem que estar abaixo do RootPath
oPrint:Say(030,0800,ALLTRIM(DESC_Fil),oArial10N)
oPrint:Say(080,1050,ALLTRIM(DESC_CGC),oArial10N)
oPrint:Say(0120,0800,ALLTRIM(DESC_END)+", "+ALLTRIM(DESC_CID)+", "+ALLTRIM(DESC_EST) +", "+ALLTRIM("Perú") ,oArial10N)		//Empresa : #Local :
oPrint:Say(160,1050,ALLTRIM("D.S.N°001-98-TR"),oArial10N)
cDataBase:=Substr(Dtos(Date()),7,2)+"/"+Substr(Dtos(Date()),5,2)+"/"+Substr(Dtos(Date()),1,4)
//Box do Cabecalho recibo de vencimento
oPrint:Box(0210,0015,0290,2400)  //******
oPrint:Say(0220,0030,Space(20)+STR0017,oArial08N) //"RECIBO DE PAGAMENTO
ORDEMZ ++
cNome := Alltrim(SRA->RA_PRISOBR) + " " +Alltrim(SRA->RA_SECSOBR) + " " +Alltrim(SRA->RA_PRINOME)+ " " +Alltrim(SRA->RA_SECNOME)
oPrint:Say(0220,2100,"BOLETA NO."+StrZero(ORDEMZ,4),oArial08N) // Orden
oPrint:Line(0250,0015,0250,2400)
oPrint:Say(0260,030,UPPER(STR0147)+SRA->RA_MAT,oArial07)

oPrint:Say(0260,400,UPPER(STR0024)+" " + UPPER(cNome),oArial07)
oPrint:Say(0260,1200,UPPER("Fecha Ingreso:")+DTOC(SRA->RA_ADMISSA),oArial07)
oPrint:Say(0260,2000,UPPER("Fecha CESE:")+DTOC(SRA->RA_DEMISSA),oArial07)
oPrint:Box(0290,0015,0370,2400)
oPrint:Say(0300,030,UPPER("PERIODOS VACACIONALES:")+cFECVAC,oArial07)
oPrint:Say(0300,1100,UPPER("PERIODO DE PAGO:")+DTOC(RCH->RCH_DTINI)+ "-" +DTOC(RCH->RCH_DTFIM),oArial07)
oPrint:Say(0300,2000,UPPER("FECHA DE PAGO:")+DTOC(RCH->RCH_DTPAGO),oArial07)
oPrint:Line(0330,0015,0330,2400)
oPrint:Say(0340,030,UPPER("DEPARTAMENTO:")+UPPER(POSICIONE("SQB",1,XFILIAL("SQB")+SRA->RA_DEPTO,"QB_DESCRIC")),oArial07)

//fBuscaFunc(dDataRef, @cCodFunc, @cDescFunc   )

cCargo:=fDesc("SQ3",fGetCargo(SRA->RA_MAT),"SQ3->Q3_DESCSUM")
oPrint:Say(0340,1100,UPPER("CARGO:")+cCargo,oArial07)

cDesSex := IIF(SRA->RA_SEXO=="F","FEMENINO","MASCULINO")
oPrint:Say(0340,2000,UPPER("SEXO:")+cDesSex,oArial07)

oPrint:Box(0370,0015,0450,2400)


nPosTab:= fPosTab("ST35",SRA->RA_SITTRAB, "==", 4)
IF  nPosTab>0
	cDesSit := fTabela("ST35",nPosTab,5)
ENDIF	
	
oPrint:Say(0380,030,UPPER("SITUACIÓN ESPECIAL:")+cDesSit,oArial07)

cDesTrb := AllTrim(FDESCRCC("ST35",SRA->RA_SITTRAB,1,1,2,51)) 

oPrint:Say(0380,0700,UPPER("TIPO DE TRABAJADOR: ")+ALLTRIM(cDesTrb),oArial07)//oPrint:Say(0380,0700,UPPER("TIPO DE TRABAJADOR:")+IIF(ALLTRIM(SRA->RA_SITTRAB) == "1","EMPLEADO DE DIRECCION","EMPLEADO DE CONFIANZA"),oArial07)
oPrint:Say(0380,2000,UPPER("FISCALIZADO:")+SRA->RA_FISCALI,oArial07)
oPrint:Box(0410,0015,0410,2400)
oPrint:Say(0420,0030,UPPER("FECHA DE NACIMIENTO:")+DTOC(SRA->RA_NASC),oArial07)

nPosTab:= fPosTab("ST04",SRA->RA_NACIONA, "==", 4) 
IF  nPosTab>0
	cDesNac :=  fTabela("ST04",nPosTab,5)
endif	
oPrint:Say(0420,0550,UPPER("NACIONALIDAD:")+cDesNac,oArial07)

nPosTab:= fPosTab("ST03",SRA->RA_TPCIC, "==", 4) 
IF  nPosTab>0
	cDoc := fTabela("ST03",nPosTab,5)
endif	
oPrint:Say(0420,1100,UPPER("DOCUMENTO:")+cDoc,oArial07)

oPrint:Say(0420,2000,UPPER("NO:")+SRA->RA_CIC,oArial07)
oPrint:Box(0450,0015,0530,2400)

nPosTab:= fPosTab("ST11",SRA->RA_CODAFP, "==", 4)
IF  nPosTab>0 
	cPenEmp := ALLTRIM(fTabela("ST11",nPosTab,5))
	cPenEmp+= ALLTRIM(fTabela("ST11",nPosTab,12))+ALLTRIM(fTabela("ST11",nPosTab,13))
	If SRA->RA_TIPAFP == '1'
		cPenEmp+= ALLTRIM(fTabela("ST11",nPosTab,14))
	Else
		cPenEmp+= ALLTRIM(fTabela("ST11",nPosTab,15))
	EndIf
endif
oPrint:Say(0460,0030,UPPER("PENSION:")+cPenEmp,oArial07)
oPrint:Say(0460,0480,UPPER("CUSPP:")+SRA->RA_CUSPP,oArial07)
oPrint:Say(0460,0900,UPPER("ESSALUD:")+SRA->RA_NUMINSC,oArial07)
oPrint:Say(0460,1300,UPPER("SUELDO:")+TRANSFORM(SRA->RA_SALARIO,"@e 9,999,999.99"),oArial07)

cMonDes:=fDesc("CTO",SRA->RA_TPMOEDA,"CTO_DESC")

oPrint:Say(0460,2000,UPPER("MONEDA:")+cMonDes,oArial07)
oPrint:Box(0490,0015,0490,2400)

	cDescr := AllTrim(FDESCRCC("ST28",SRA->RA_CEP,1,6,7,51)) 
	
//oPrint:Say(0500,0030,UPPER("DIRECCION:")+ UPPER(RTRIM(SRA->RA_ENDEREC) + " "+ RTRIM(cDescr)+ " " + RTRIM(SRA->RA_BAIRRO)) +" " +SRA->RA_TELEFON,oArial07)
oPrint:Say(0500,0030,UPPER("DIRECCION:")+ UPPER(RTRIM(SRA->RA_ENDEREC) + " "+ RTRIM(cDescr)),oArial07)

//fBuscaFunc(dDataRef, @cCodFunc, @cDescFunc   )


// Recibo 2

oPrint:Box(20 + nRe2,15,200 +  nRe2,2400 )
oPrint:SayBitmap(030 + nRe2,060,cStartPath+"lgrl"+FwCodEmp("SM0")+".bmp",200,100) // Tem que estar abaixo do RootPath
oPrint:Say(30 +  nRe2,0800,ALLTRIM(DESC_Fil),oArial10N)
oPrint:Say(80 + nRe2,1050,ALLTRIM(DESC_CGC),oArial10N)
oPrint:Say(120 + nRe2,0800,ALLTRIM(DESC_END)+", "+ALLTRIM(DESC_CID)+", "+ALLTRIM(DESC_EST) +", "+ALLTRIM("Perú") ,oArial10N)		//Empresa : #Local :
oPrint:Say(160 +  nRe2,1050,ALLTRIM("D.S.N°001-98-TR"),oArial10N)
oPrint:Box(0210+ nRe2,0015,0290+ nRe2,2400)  //******
oPrint:Say(0220+ nRe2,0030,Space(20)+STR0017,oArial08N) //"RECIBO DE PAGAMENTO
oPrint:Say(0220+ nRe2,2100,"BOLETA NO."+StrZero(ORDEMZ,4),oArial08N) // Orden
oPrint:Line(0250+ nRe2,0015,0250+ nRe2,2400)
oPrint:Say(0260+ nRe2,030,UPPER(STR0147)+SRA->RA_MAT,oArial07)
oPrint:Say(0260+ nRe2,400,UPPER(STR0024)+" "+UPPER(cNome),oArial07)
oPrint:Say(0260+ nRe2,1200,UPPER("Fecha Ingreso:")+DTOC(SRA->RA_ADMISSA),oArial07)
oPrint:Say(0260+ nRe2,2000,UPPER("Fecha CESE:")+DTOC(SRA->RA_DEMISSA),oArial07)
oPrint:Box(0290+ nRe2,0015,0370+ nRe2,2400)
oPrint:Say(0300+ nRe2,030,UPPER("PERIODOS VACACIONALES:")+cFECVAC,oArial07)
oPrint:Say(0300+ nRe2,1100,UPPER("PERIODO DE PAGO:")+DTOC(RCH->RCH_DTINI)+ "-" +DTOC(RCH->RCH_DTFIM),oArial07)
oPrint:Say(0300+ nRe2,2000,UPPER("FECHA DE PAGO:")+DTOC(RCH->RCH_DTPAGO),oArial07)
oPrint:Line(0330+ nRe2,0015,0330+ nRe2,2400)
oPrint:Say(0340+ nRe2,030,UPPER("DEPARTAMENTO:")+POSICIONE("SQB",1,XFILIAL("SQB")+SRA->RA_DEPTO,"QB_DESCRIC"),oArial07)
oPrint:Say(0340+ nRe2,1100,UPPER("CARGO:") + cCargo,oArial07)
oPrint:Say(0340+ nRe2,2000,UPPER("SEXO:")+cDesSex,oArial07)
oPrint:Box(0370+ nRe2,0015,0450+ nRe2,2400)
oPrint:Say(0380+ nRe2,030,UPPER("SITUACIÓN ESPECIAL:")+cDesSit,oArial07)

cDesTrb := AllTrim(FDESCRCC("ST35",SRA->RA_SITTRAB,1,1,2,51)) 

oPrint:Say(0380+ nRe2,0700,UPPER("TIPO DE TRABAJADOR: ")+ALLTRIM(cDesTrb),oArial07)
oPrint:Say(0380+ nRe2,2000,UPPER("FISCALIZADO:")+SRA->RA_FISCALI,oArial07)
oPrint:Box(0410+ nRe2,0015,0410+ nRe2,2400)
oPrint:Say(0420+ nRe2,0030,UPPER("FECHA DE NACIMIENTO:")+DTOC(SRA->RA_NASC),oArial07)
oPrint:Say(0420+ nRe2,0550,UPPER("NACIONALIDAD:")+cDesNac,oArial07)
oPrint:Say(0420+ nRe2,1100,UPPER("DOCUMENTO:")+cDoc,oArial07)
oPrint:Say(0420+ nRe2,2000,UPPER("NO:")+SRA->RA_RG,oArial07)
oPrint:Box(0450+ nRe2,0015,0530+ nRe2,2400)
oPrint:Say(0460+ nRe2,0030,UPPER("PENSION:")+cPenEmp,oArial07)
oPrint:Say(0460+ nRe2,0480,UPPER("CUSPP:")+SRA->RA_CUSPP,oArial07)
oPrint:Say(0460+ nRe2,0900,UPPER("ESSALUD:")+SRA->RA_NUMINSC,oArial07)
oPrint:Say(0460+ nRe2,1300,UPPER("SUELDO:")+TRANSFORM(SRA->RA_SALARIO,"@e 9,999,999.99"),oArial07)
oPrint:Say(0460+ nRe2,2000,UPPER("MONEDA:")+cMonDes,oArial07)
oPrint:Box(0490+ nRe2,0015,0490+ nRe2,2400)


	cDescr := AllTrim(FDESCRCC("ST28",SRA->RA_CEP,1,6,7,51)) 

//oPrint:Say(0500,0030,UPPER("DIRECCION:")+ UPPER(RTRIM(SRA->RA_ENDEREC) + " "+ RTRIM(cDescr)+ " " + RTRIM(SRA->RA_BAIRRO)) +" " +SRA->RA_TELEFON,oArial07)
oPrint:Say(0500,0030,UPPER("DIRECCION:")+ UPPER(RTRIM(SRA->RA_ENDEREC) + " "+ RTRIM(cDescr)),oArial07)
//oPrint:Say(0500+ nRe2,0030,UPPER("DIRECCION:")+ UPPER(RTRIM(SRA->RA_ENDEREC) + " "+ RTRIM(SRA->RA_COMPLEM)+ " " + RTRIM(SRA->RA_BAIRRO)) +" " +SRA->RA_TELEFON,oArial07)

cDescFunc := ""
Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fLancaG() ³ Autor ³ SSERVICE              ³ Data ³ 04.05.08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMRESSAO Detalhe do Grafico                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ flancaG()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fLancaG()
Local nCont     := 0
Local nValidos  := 0
Local cRepreLe      :=  ALLTRIM(fTabela("S002", 1, 7)) +" "+ ALLTRIM(fTabela("S002", 1,8))+ " "+ ALLTRIM (fTabela("S002", 1, 9))
Local cDocRep       :=  ALLTRIM(fTabela("S002", 1, 6))
Local CodFOL       :=  ""
Local nPREST       := 0
Local nLoop        := 1
Local cObs         := ""

Local i            := 0

Local cCodban1   := ""
Local cAgencBco1 := "" 		         
Local cNomBco1 := ""



nPREST  := fSRK(SRA->RA_MAT)


nTermina := Max(Max(LEN(aProve),LEN(aDesco)),LEN(aBases))

//Box do Detalhe do Recibo de vencimento


oPrint:Box(0540,0015,1300,2400)
oPrint:Say(0550,0200,UPPER("REMUNERACIONES"),oArial08N)//P R O V E N T O S
oPrint:Say(0550,0910,UPPER("DESCUENTOS"),oArial08N)//D E S C O N T O S
oPrint:Say(0550,1810,UPPER("APORTACIONES DEL EMPLEADOR"),oArial08N)//B A S E S
oPrint:Line(0590,0015,0590,2400)
oPrint:Say(0600,0040,"CONCEPTO",oArial08)//REMUNERACIONES
oPrint:Say(0600,0490,"Hrs./Día",oArial08)//REMUNERACIONES
oPrint:Say(0600,0630,"IMPORTES",oArial08)//REMUNERACIONES
oPrint:Say(0600,0810,"CONCEPTO",oArial08)//APORTACIONES Y DESCUENTO
oPrint:Say(0600,1420,"IMPORTES",oArial08)//APORTACIONES Y DESCUENTO
oPrint:Say(0600,1610,"CONCEPTO",oArial08)//APORTACIONES DEL EMPLEADOR
oPrint:Say(0600,2070,"BASE",oArial08)//APORTACIONES DEL EMPLEADOR
oPrint:Say(0600,2220,"IMPORTES",oArial08)//APORTACIONES DEL EMPLEADOR
oPrint:Line(0640,0015,0640,2400)


oPrint:Line(0640,0470,1300,0470)
oPrint:Line(0640,0600,1340,0600)
oPrint:Line(0640,0800,1380,0800)
oPrint:Line(0640,1400,1380,1400)
oPrint:Line(0640,1600,1380,1600)
oPrint:Line(0640,2030,1300,2030)
oPrint:Line(0640,2190,1340,2190)

// Recibo 2


oPrint:Box(0540+nRe2,0015,1300+nRe2,2400)
oPrint:Say(0550+nRe2,0200,UPPER("REMUNERACIONES"),oArial08N)//P R O V E N T O S
oPrint:Say(0550+nRe2,0910,UPPER("DESCUENTOS"),oArial08N)//D E S C O N T O S
oPrint:Say(0550+nRe2,1810,UPPER("APORTACIONES DEL EMPLEADOR"),oArial08N)//B A S E S
oPrint:Line(0590+nRe2,0015,0590+nRe2,2400)
oPrint:Say(0600+nRe2,0040,"CONCEPTO",oArial08)//REMUNERACIONES
oPrint:Say(0600+nRe2,0490,"Hrs./Día",oArial08)//REMUNERACIONES
oPrint:Say(0600+nRe2,0630,"IMPORTES",oArial08)//REMUNERACIONES
oPrint:Say(0600+nRe2,0810,"CONCEPTO",oArial08)//APORTACIONES Y DESCUENTO
oPrint:Say(0600+nRe2,1420,"IMPORTES",oArial08)//APORTACIONES Y DESCUENTO
oPrint:Say(0600+nRe2,1610,"CONCEPTO",oArial08)//APORTACIONES DEL EMPLEADOR
oPrint:Say(0600+nRe2,2070,"BASE",oArial08)//APORTACIONES DEL EMPLEADOR
oPrint:Say(0600+nRe2,2220,"IMPORTES",oArial08)//APORTACIONES DEL EMPLEADOR
oPrint:Line(0640+nRe2,0015,0640+nRe2,2400)


oPrint:Line(0640+nRe2,0470,1300+nRe2,0470)
oPrint:Line(0640+nRe2,0600,1340+nRe2,0600)
oPrint:Line(0640+nRe2,0800,1380+nRe2,0800)
oPrint:Line(0640+nRe2,1400,1380+nRe2,1400)
oPrint:Line(0640+nRe2,1600,1380+nRe2,1600)
oPrint:Line(0640+nRe2,2030,1300+nRe2,2030)
oPrint:Line(0640+nRe2,2190,1340+nRe2,2190)




nLinDet:=645
For nCont := 1 To nTermina
	IF nCont <= Len(aProve)
		oPrint:Say(nLinDet,040,aProve[nCont,1],oArial08)
		oPrint:Say(nLinDet,480,TRANSFORM(aProve[nCont,2],'999.99'),oFont08)
		oPrint:Say(nLinDet,610,TRANSFORM(aProve[nCont,3],cPict3),oFont08)
		
		//Recibo 2
		
		oPrint:Say(nLinDet + nRe2,0040,aProve[nCont,1],oArial08)
		oPrint:Say(nLinDet + nRe2,480,TRANSFORM(aProve[nCont,2],'999.99'),oFont08)
		oPrint:Say(nLinDet + nRe2,0610,TRANSFORM(aProve[nCont,3],cPict3),oFont08)
		
		cCodFOL := Posicione("SRV",1,xfilial("SRV") + substr(aProve[nCont,1],1,3),"RV_CODFOL")
		
		IF ALLTRIM(cCodFOL) == "0031"//"0360"
			DTRAB += aProve[nCont,2]
		//ELSEIF ALLTRIM(cCodFOL) == "0638"
			HSTRAB += (DTRAB*6) //HSTRAB += (DTRAB*SRA->RA_HRSDIA) //aProve[nCont,2]
		ELSEIF ALLTRIM(cCodFOL) == "1411"
			HSEXT += aProve[nCont,2]
		ELSEIF ALLTRIM(cCodFOL) == "0054"
			AUS += aProve[nCont,2]
		ELSEIF ALLTRIM(cCodFOL) == "1117"
			DMEDIC += aProve[nCont,2]
		ELSEIF ALLTRIM(cCodFOL) == "0055"
			TARDS += aProve[nCont,2]
		ELSEIF ALLTRIM(cCodFOL) == "0442"
			PERPAG += aProve[nCont,2]
		ENDIF
		cCodFOL := ""
		
		
	ENDIF
	IF nCont <= Len(aDesco)
		oPrint:Say(nLinDet,0810,aDesco[nCont,1],oArial08)
		oPrint:Say(nLinDet,1400,TRANSFORM(aDesco[nCont,3],cPict3),oFont08)
		
		//Recibo 2
		
		oPrint:Say(nLinDet + nRe2,0810,aDesco[nCont,1],oArial08)
		oPrint:Say(nLinDet + nRe2,1400,TRANSFORM(aDesco[nCont,3],cPict3),oFont08)
		
		CodFOL := Posicione("SRV",1,xfilial("SRV") + substr(aDesco[nCont,1],1,3),"RV_CODFOL")
		IF ALLTRIM(CodFOL) == "0031"
			DTRAB += aDesco[nCont,2]
		//ELSEIF ALLTRIM(CodFOL) == "0638"
			HSTRAB += (DTRAB*6) //HSTRAB += (DTRAB*SRA->RA_HRSDIA)//aDesco[nCont,2]
		ELSEIF ALLTRIM(CodFOL) == "1411"
			HSEXT += aDesco[nCont,2]
		ELSEIF ALLTRIM(CodFOL) == "0054"
			AUS += aDesco[nCont,2]
		ELSEIF ALLTRIM(CodFOL) == "1117"
			DMEDIC += aDesco[nCont,2]
		ELSEIF ALLTRIM(CodFOL) == "0055"
			TARDS += aDesco[nCont,2]
		ELSEIF ALLTRIM(CodFOL) == "0442"
			PERPAG += aDesco[nCont,2]
		ENDIF
		CodFOL := ""
		
	ENDIF
	IF nCont <= Len(aBases)
		oPrint:Say(nLinDet,1610,aBases[nCont,1],oArial08)
		oPrint:Say(nLinDet,2050,TRANSFORM(aBases[nCont,2],'999.99'),oFont08)
		oPrint:Say(nLinDet,2210,TRANSFORM(aBases[nCont,3],cPict3),oFont08)
		
		//Recibo 2
		
		oPrint:Say(nLinDet + nRe2,1610,aBases[nCont,1],oArial08)
		oPrint:Say(nLinDet + nRe2,2050,TRANSFORM(aBases[nCont,2],'999.99'),oFont08)
		oPrint:Say(nLinDet + nRe2,2210,TRANSFORM(aBases[nCont,3],cPict3),oFont08)
		
		CodFOL := Posicione("SRV",1,xfilial("SRV") + substr(aBases[nCont,1],1,3),"RV_CODFOL")
		
		IF ALLTRIM(CodFOL) == "0031"
			DTRAB += aBases[nCont,2]
		//ELSEIF ALLTRIM(CodFOL) == "0638"
			HSTRAB += (DTRAB*6)//HSTRAB += (DTRAB*SRA->RA_HRSDIA) //aBases[nCont,2]
		ELSEIF ALLTRIM(CodFOL) == "1411"
			//HSEXT += aBases[nCont,2]
		ELSEIF ALLTRIM(CodFOL) == "0054"
			//AUS += aBases[nCont,2]
		ELSEIF ALLTRIM(CodFOL) == "1117"
			DMEDIC += aBases[nCont,2]
		ELSEIF ALLTRIM(CodFOL) == "0055"
			TARDS += aBases[nCont,2]
		ELSEIF ALLTRIM(CodFOL) == "0442"
			PERPAG += aBases[nCont,2]
		ENDIF
		CodFOL := ""
	Endif
	//====================================================
	//---- Soma 1 nos nValidos e Linha
	//====================================================
	nValidos ++
	nLinDet+=40
	
	
	
	If nLinDet>=1285
		nLinDet+=40
		oPrint:Box(1300,0015,1380,2400)
		oPrint:Box(1300+nRe2,0015,1380+nRe2,2400)
		oPrint:Box(1340,0015,1340,2400)
		oPrint:Box(1340+nRe2,0015,1340+nRe2,2400)
		oPrint:Say(1460,0910,"C O N T I N U A    R E C I B O No." + StrZero(ORDEMZ,4) ,oArial10N)//TOTAL DESCUENTOS
		oPrint:Say(1460+nRe2,0910,"C O N T I N U A    R E C I B O No." + StrZero(ORDEMZ,4) ,oArial10N)//TOTAL DESCUENTOS

		ORDEMZ --
		oPrint:EndPage()
		fCabecG()
		oPrint:Box(0540,0015,1300,2400)
		oPrint:Say(0550,0200,UPPER("REMUNERACIONES"),oArial08N)//P R O V E N T O S
		oPrint:Say(0550,0910,UPPER("DESCUENTOS"),oArial08N)//D E S C O N T O S
		oPrint:Say(0550,1810,UPPER("APORTACIONES DEL EMPLEADOR"),oArial08N)//B A S E S
		oPrint:Line(0590,0015,0590,2400)
		oPrint:Say(0600,0040,"CONCEPTO",oArial08)//REMUNERACIONES
		oPrint:Say(0600,0490,"Hrs./Día",oArial08)//REMUNERACIONES
		oPrint:Say(0600,0630,"IMPORTES",oArial08)//REMUNERACIONES
		oPrint:Say(0600,0810,"CONCEPTO",oArial08)//APORTACIONES Y DESCUENTO
		oPrint:Say(0600,1420,"IMPORTES",oArial08)//APORTACIONES Y DESCUENTO
		oPrint:Say(0600,1610,"CONCEPTO",oArial08)//APORTACIONES DEL EMPLEADOR
		oPrint:Say(0600,2070,"BASE",oArial08)//APORTACIONES DEL EMPLEADOR
		oPrint:Say(0600,2220,"IMPORTES",oArial08)//APORTACIONES DEL EMPLEADOR
		oPrint:Line(0640,0015,0640,2400)
		
		oPrint:Line(0640,0470,1300,0470)
		oPrint:Line(0640,0600,1340,0600)
		oPrint:Line(0640,0800,1380,0800)
		oPrint:Line(0640,1400,1380,1400)
		oPrint:Line(0640,1600,1380,1600)
		oPrint:Line(0640,2030,1300,2030)
		oPrint:Line(0640,2190,1340,2190)
		
		// Recibo 2
		
		
		oPrint:Box(0540+nRe2,0015,1300+nRe2,2400)
		oPrint:Say(0550+nRe2,0200,UPPER("REMUNERACIONES"),oArial08N)//P R O V E N T O S
		oPrint:Say(0550+nRe2,0910,UPPER("DESCUENTOS"),oArial08N)//D E S C O N T O S
		oPrint:Say(0550+nRe2,1810,UPPER("APORTACIONES DEL EMPLEADOR"),oArial08N)//B A S E S
		oPrint:Line(0590+nRe2,0015,0590+nRe2,2400)
		oPrint:Say(0600+nRe2,0040,"CONCEPTO",oArial08)//REMUNERACIONES
		oPrint:Say(0600+nRe2,0490,"Hrs./Día",oArial08)//REMUNERACIONES
		oPrint:Say(0600+nRe2,0630,"IMPORTES",oArial08)//REMUNERACIONES
		oPrint:Say(0600+nRe2,0810,"CONCEPTO",oArial08)//APORTACIONES Y DESCUENTO
		oPrint:Say(0600+nRe2,1420,"IMPORTES",oArial08)//APORTACIONES Y DESCUENTO
		oPrint:Say(0600+nRe2,1610,"CONCEPTO",oArial08)//APORTACIONES DEL EMPLEADOR
		oPrint:Say(0600+nRe2,2070,"BASE",oArial08)//APORTACIONES DEL EMPLEADOR
		oPrint:Say(0600+nRe2,2220,"IMPORTES",oArial08)//APORTACIONES DEL EMPLEADOR
		oPrint:Line(0640+nRe2,0015,0640+nRe2,2400)
		
		oPrint:Line(0640+nRe2,0470,1300+nRe2,0470)
		oPrint:Line(0640+nRe2,0600,1340+nRe2,0600)
		oPrint:Line(0640+nRe2,0800,1380+nRe2,0800)
		oPrint:Line(0640+nRe2,1400,1380+nRe2,1400)
		oPrint:Line(0640+nRe2,1600,1380+nRe2,1600)
		oPrint:Line(0640+nRe2,2030,1300+nRe2,2030)
		oPrint:Line(0640+nRe2,2190,1340+nRe2,2190)
		nLinDet:=645
		
		nValidos := 0
	Endif
	
Next nCont

oPrint:Box(1300,0015,1380,2400)
oPrint:Say(1310,0040,"TOTAL REMUNERACIONES:",oArial08)//TOTAL REMUNERACIONES
oPrint:Say(1310,0610,TRANS(TOTVENC,cPict3),oFont08)
oPrint:Say(1310,0810,"TOTAL DESCUENTOS:",oArial08)//TOTAL DESCUENTOS
oPrint:Say(1310,1400,TRANS(TOTDESC,cPict3),oFont08)
oPrint:Say(1310,1610,"TOTAL APORTACIONES:",oArial08)//TOTAL APORTACIONES
oPrint:Say(1310,2210,TRANS(TOTBAS,cPict3),oFont08)
oPrint:Box(1340,0015,1340,2400)
oPrint:Say(1350,0810,"NETO RECIBIDO (S/.):",oArial08)//NETO RECIBIDO
oPrint:Say(1350,1400,TRANS(TOTVENC - TOTDESC,cPict3),oFont08)

cCodban1   := Substr(SRA->RA_BCOHAB,1,3)
cAgencBco1 := Substr(SRA->RA_BCOHAB,4,5) 		         

cNomBco1 := POSICIONE("SA6",1,xfilial("SA6")+ cCodban1+ cAgencBco1,"A6_NREDUZ")

oPrint:Say(1350,1610,"BANCO: " + SRA->RA_BCOHAB+"-"+SUBSTR(cNomBco1,1,44),oArial08)//oPrint:Say(1350,1610,"BANCO: " + SRA->RA_BCDEPSA+"-"+SUBSTR(DescBco(SRA->RA_BCDEPSA,SRA->RA_FILIAL),1,44),oArial08)//TOTAL APORTACIONES
cObs :=  Alltrim(DESC_MSG1) +" " + Alltrim(DESC_MSG2) + " " + Alltrim(DESC_MSG3)
oPrint:Say(1350,0040,"OBSERVACIONES:",oArial07)
nLoop := 1
For i := 1 To Len(cObs) Step 40
	oPrint:Say(1350 + (nLoop*30),0040,SubStr(cObs,i,040),oArial07)
	nLoop++
	If nLoop == 5
		Exit
	EndIf
Next i

oPrint:Box(1380,0700,1460,2400)
oPrint:Line(1380,0900,1460,0900)
oPrint:Line(1380,1100,1460,1100)
oPrint:Line(1380,1300,1460,1300)
oPrint:Line(1380,1500,1460,1500)
oPrint:Line(1380,1700,1460,1700)
oPrint:Line(1380,2000,1460,2000)
//oPrint:Line(1380,2200,1460,2200)
oPrint:Box(1380,0700,1420,2400)

oPrint:Say(1390,700,TRANSFORM(nPREST,cPict3),oFont08)
oPrint:Say(1390,920,TRANSFORM(DTRAB,'999.99'),oFont08)
oPrint:Say(1390,1120,TRANSFORM(HSTRAB,'999.99'),oFont08)
oPrint:Say(1390,1320,TRANSFORM(HSEXT,'999.99'),oFont08)
oPrint:Say(1390,1520,TRANSFORM(AUS,'999.99'),oFont08)
oPrint:Say(1390,1720,TRANSFORM(DMEDIC,'999.99'),oFont08)
oPrint:Say(1390,2020,ALLTRIM(SRA->RA_CTDEPSA),oFont08) //oPrint:Say(1390,2020,TRANSFORM(TARDS,'999.99'),oFont08)
//oPrint:Say(1390,2210,TRANSFORM(PERPAG,'999.99'),oFont08)
oPrint:Say(1430,720,"SALDO PREST:",oArial06)
oPrint:Say(1430,920,"D. TRAB:",oArial06)
oPrint:Say(1430,1120,"HS. TRAB:",oArial06)
oPrint:Say(1430,1320,"HX. EXT:",oArial06)
oPrint:Say(1430,1520,"AUS.:",oArial06)
oPrint:Say(1430,1720,"D.MEDIC.:",oArial06)
oPrint:Say(1430,2020,"CTA. HABERES",oArial06) //oPrint:Say(1430,2020,"TARDS.:",oArial06)
oPrint:Say(1430,2210,"",oArial06) //oPrint:Say(1430,2210,"PERM.S/PAGO:",oArial06)





oPrint:SayBitmap(1400,0090, cArquivoC, 450, 150,,.F.) //Tem que estar abaixo do RootPath
oPrint:Box(1540,0090,1540,0700)
oPrint:Say(1550,0090,UPPER("REPRESENTANTE LEGAL"),oArial08)//REPRESENTANTE LEGAL
oPrint:Say(1590,0090,UPPER(cRepreLe),oArial08)//NOMBRE DE REPRESENTANTE LEGAL
oPrint:Say(1630,0090,UPPER("D.N.L.") + UPPER(cDocRep),oArial08)//DNL REPRESENTANTE


oPrint:Box(1540,1500,1540,2200)
oPrint:Say(1550,1600,UPPER("EMPLEADO"),oArial08)//EMPLEADO
oPrint:Say(1590,1600,UPPER(SRA->RA_NOME),oArial08)//NOMBRE DEL EMPLEADO
oPrint:Say(1630,1600,UPPER("D.N.L.") + ALLTRIM(SRA->RA_CIC),oArial08)//DNL EMPLEADO


//Recibo 2


oPrint:Box(1300 + nRe2,0015,1380+ nRe2,2400)
oPrint:Say(1310+ nRe2,0040,"TOTAL REMUNERACIONES:",oArial08)//TOTAL REMUNERACIONES
oPrint:Say(1310 + nRe2,0610,TRANS(TOTVENC,cPict3),oFont08)
oPrint:Say(1310+ nRe2,0810,"TOTAL DESCUENTOS:",oArial08)//TOTAL DESCUENTOS
oPrint:Say(1310+ nRe2,1400,TRANS(TOTDESC,cPict3),oFont08)

oPrint:Say(1310+ nRe2,1610,"TOTAL APORTACIONES:",oArial08)//TOTAL APORTACIONES
oPrint:Say(1310+ nRe2,2210,TRANS(TOTBAS,cPict3),oFont08)
oPrint:Box(1340+ nRe2,0015,1340+ nRe2,2400)
oPrint:Say(1350+ nRe2,0810,"NETO RECIBIDO (S/.):",oArial08)//NETO RECIBIDO
oPrint:Say(1350+ nRe2,1400,TRANS(TOTVENC - TOTDESC,cPict3),oFont08)

oPrint:Say(1350+ nRe2,1610,"BANCO: " + SRA->RA_BCOHAB+"-"+SUBSTR(cNomBco1,1,44),oArial08)//oPrint:Say(1350+ nRe2,1610,"BANCO: " + SRA->RA_BCDEPSA+"-"+SUBSTR(DescBco(SRA->RA_BCDEPSA,SRA->RA_FILIAL),1,44),oArial08)//TOTAL APORTACIONES

oPrint:Say(1350+ nRe2,0040,"OBSERVACIONES:",oArial07)//OBSERVACIONES
nLoop := 1
For i := 1 To Len(cObs) Step 40
	oPrint:Say(1350 + nRe2 + (nLoop*30),0040,SubStr(cObs,i,040),oArial07)
	nLoop++
	If nLoop == 5
		Exit
	EndIf
Next i

oPrint:Box(1380+ nRe2,0700,1460+ nRe2,2400)
oPrint:Line(1380+ nRe2,0900,1460+ nRe2,0900)
oPrint:Line(1380+ nRe2,1100,1460+ nRe2,1100)
oPrint:Line(1380+ nRe2,1300,1460+ nRe2,1300)
oPrint:Line(1380+ nRe2,1500,1460+ nRe2,1500)
oPrint:Line(1380+ nRe2,1700,1460+ nRe2,1700)
oPrint:Line(1380+ nRe2,2000,1460+ nRe2,2000)
//oPrint:Line(1380+ nRe2,2200,1460+ nRe2,2200)
oPrint:Box(1380+ nRe2,0700,1420+ nRe2,2400)

oPrint:Say(1390+ nRe2,700,TRANSFORM(nPREST,cPict3),oFont08)
oPrint:Say(1390+ nRe2,920,TRANSFORM(DTRAB,'999.99'),oFont08)
oPrint:Say(1390+ nRe2,1120,TRANSFORM(HSTRAB,'999.99'),oFont08)
oPrint:Say(1390+ nRe2,1320,TRANSFORM(HSEXT,'999.99'),oFont08)
oPrint:Say(1390+ nRe2,1520,TRANSFORM(AUS,'999.99'),oFont08)
oPrint:Say(1390+ nRe2,1720,TRANSFORM(DMEDIC,'999.99'),oFont08)
oPrint:Say(1390+ nRe2,2020,ALLTRIM(SRA->RA_CTDEPSA),oFont08) //oPrint:Say(1390+ nRe2,2020,TRANSFORM(TARDS,'999.99'),oFont08)
//oPrint:Say(1390+ nRe2,2210,TRANSFORM(PERPAG,'999.99'),oFont08)
SRA->RA_CTDEPSA
oPrint:Say(1430+ nRe2,720,"SALDO PREST:",oArial06)
oPrint:Say(1430+ nRe2,920,"D. TRAB:",oArial06)
oPrint:Say(1430+ nRe2,1120,"HS. TRAB:",oArial06)
oPrint:Say(1430+ nRe2,1320,"HX. EXT:",oArial06)
oPrint:Say(1430+ nRe2,1520,"AUS.:",oArial06)
oPrint:Say(1430+ nRe2,1720,"D.MEDIC.:",oArial06)

oPrint:Say(1430+ nRe2,2020,"CTA. DE HABERES",oArial06) //oPrint:Say(1430+ nRe2,2020,"TARDS.:",oArial06)
oPrint:Say(1430+ nRe2,2210,"",oArial06) //oPrint:Say(1430+ nRe2,2210,"PERM.S/PAGO:",oArial06)



SPRES := 0
DTRAB := 0
HSTRAB:= 0
HSEXT := 0
AUS   := 0
DMEDIC:= 0
TARDS := 0
PERPAG:= 0


//oPrint:Box(1540+ nRe2,0090,1540+ nRe2,0700)
oPrint:SayBitmap(1400+ nRe2,0090, cArquivoC, 450, 150,,.F.) //Tem que estar abaixo do RootPath
oPrint:Box(1540+ nRe2,0090,1540+ nRe2,0700)
oPrint:Say(1550+ nRe2,0090,UPPER("REPRESENTANTE LEGAL"),oArial08)//REPRESENTANTE LEGAL
oPrint:Say(1590+ nRe2,0090,UPPER(cRepreLe),oArial08)//NOMBRE DE REPRESENTANTE LEGAL
oPrint:Say(1630+ nRe2,0090,UPPER("D.N.L.") + cDocRep,oArial08)//DNL REPRESENTANTE


oPrint:Box(1540+ nRe2,1500,1540+ nRe2,2200)
oPrint:Say(1550+ nRe2,1600,UPPER("EMPLEADO"),oArial08)//EMPLEADO
oPrint:Say(1590+ nRe2,1600,UPPER(SRA->RA_NOME),oArial08)//NOMBRE DEL EMPLEADO
oPrint:Say(1630+ nRe2,1600,UPPER("D.N.L.") + ALLTRIM(SRA->RA_RG),oArial08)//DNL EMPLEADO


oPrint:EndPage()
Return Nil




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fLancaZ   ³ Autor ³ R.H. - Ze Maria       ³ Data ³ 14.03.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao das Verbas (Lancamentos) Zebrado                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fLancaZ()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
/*Static Function fLancaZ(nConta)   // Impressao dos Lancamentos

Local nTermina  := 0
Local nCont     := 0
Local nCont1    := 0
Local nValidos  := 0
Local nTam		:= 0

nTermina := Max(Max(LEN(aProve),LEN(aDesco)),LEN(aBases))

For nCont := 1 To nTermina
	@ LI,00 PSAY "|"
	IF nCont <= LEN(aProve)
		@ LI,02 PSAY SubStr(aProve[nCont,1],1,21)+" "+TRANSFORM(aProve[nCont,2],'999.99')+TRANSFORM(aProve[nCont,3],cPict2)
	ENDIF
	@ LI,44 PSAY "|"
	IF nCont <= LEN(aDesco)
		@ LI,46 PSAY SubStr(aDesco[nCont,1],1,21)+" "+TRANSFORM(aDesco[nCont,2],'999.99')+TRANSFORM(aDesco[nCont,3],cPict2)
	ENDIF
	@ LI,88 PSAY "|"
	IF nCont <= LEN(aBases)
		@ LI,90 PSAY SubStr(aBases[nCont,1],1,21)+""+TRANSFORM(aBases[nCont,2],'999.99')+TRANSFORM(aBases[nCont,3],cPict2)
	ENDIF
	@ LI,131 PSAY "|"
	
	//---- Soma 1 nos nValidos e Linha
	nValidos ++
	Li ++
	
	If nValidos == 12
		@ LI,00 PSAY "|"+REPLICATE("-",130)+"|"
		LI ++
		@ LI,00 PSAY "|"
		@ LI,05 PSAY STR0030			// "CONTINUA !!!"

		LI ++
		@ LI,00 PSAY "*"+REPLICATE("=",130)+"*"
		LI += 8
		If li >= 60
			li := 0
		Endif
		
		fCabecZPer()
		
		nValidos := 0
	ENDIF
Next nCont

For nCont1 := nValidos+1 To 12
	@ Li,00  PSAY "|"
	@ Li,44  PSAY "|"
	@ Li,88  PSAY "|"
	@ Li,131 PSAY "|"
	Li++
Next nCont1

	@ LI,00 PSAY "|"+REPLICATE("-",130)+"|"
	LI ++
	@ LI,000 PSAY "|"
	@ LI,005 PSAY DESC_MSG1
	@ LI,044 PSAY STR0031+SPACE(10)+TRANS(TOTVENC,cPict1)	//"| TOTAL BRUTO     "
	@ LI,088 PSAY "|"+STR0032+SPACE(06)+TRANS(TOTDESC,cPict1)	//" TOTAL DESCONTOS     "
	@ LI,131 PSAY "|"
	
	LI ++
	@ LI,000 PSAY "|"
	@ LI,005 PSAY DESC_MSG2
	@ LI,044 PSAY "|"+REPLICATE("-",86)+"|"
	
	LI ++
	@ LI,000 PSAY "|"
	@ LI,005 PSAY DESC_MSG3
	nTam := 44 - (Len(STR0033) + Len(SRA->RA_BCDEPSA) + 1)
	@ LI,044 PSAY STR0033+SRA->RA_BCDEPSA+"-"+Substr(DescBco(SRA->RA_BCDEPSA,SRA->RA_FILIAL), 1, nTam)	//"| CREDITO:"
	nTam := 43 - (Len(STR0034) + Len(TRANS((TOTVENC-TOTDESC),cPict1)))
	@ LI,088 PSAY STR0034+SPACE(nTam-1)+TRANS((TOTVENC-TOTDESC),cPict1)			//"| LIQUIDO A RECEBER     "
	@ LI,131 PSAY "|"
	
	LI ++
	@ LI,000 PSAY "|"+REPLICATE("-",130)+"|"
	
	LI ++
	@ LI,000 PSAY "|"
	
	@ LI,044 PSAY STR0035 + SRA->RA_CTDEPSAL		//"| CONTA:"
	
	@ LI,088 PSAY "|"
	@ LI,131 PSAY "|"
	
	LI ++
	@ LI,000 PSAY "|"+REPLICATE("-",130)+"|"
	
	LI ++
	@ LI,00  PSAY STR0036 + Replicate("_",40)		//"| Recebi o valor acima em ___/___/___ "
	@ li,131 PSAY "|"
	
	LI ++
	@ LI,00 PSAY "*"+REPLICATE("=",130)+"*"

Li += 1

//Quebrar pagina
If LI > 63
	LI := 0
EndIf
Return Nil
*/







/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fSendDPgto| Autor ³ R.H.-Natie            ³ Data ³ 15.08.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Envio de E-mail -Demonstrativo de Pagamento                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico :Envio Demonstrativo de Pagto atraves de eMail  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fSendDPgto(lTerminal)
Local aSvArea		:= GetArea()
Local aGetArea		:= {}
Local cEmail		:= If(SRA->RA_RECMAIL=="S",SRA->RA_EMAIL,"    ")
Local cHtml			:= ""
Local cSubject		:= STR0044	//" DEMONSTRATIVO DE PAGAMENTO "
Local cMesComp		:= IF( Month(dDataRef) + 1 > 12 , 01 , Month(dDataRef) )
Local cTipo			:= ""
Local cTitTotal		:= STR0065
Local cTitTDesc		:= STR0066
Local cTitTLiq  	:= STR0067
Local cReferencia	:= ""
Local cVerbaLiq		:= ""
Local dDataPagto	:= Ctod("//")
Local nBase    		:= 0
Local nDesco
Local nZebrado		:= 0.00
Local nResto		:= 0.00
Local nProv
Local cCodFunc		:= ""		//-- codigo da Funcao do funcionario
Local cDescFunc		:= ""		//-- Descricao da Funcao do Funcionario
Local cDescUbigeo   := ""

Private cMailConta	:= NIL
Private cMailServer	:= NIL
Private cMailSenha	:= NIL

lTerminal := IF( lTerminal == NIL .or. ValType( lTerminal ) != "L" , .F. , lTerminal )

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
	cTipo		:= STR0064 //"Valores Extras"
	cVerbaLiq	:= ""
EndIF

IF  cRoteiro <> "EXT"
	DbSelectArea( "RCH" )
	DbSetOrder( 1 )
	DbSeek( xFilial( "RCH" ) + cProcesso + cPeriodo + Semana + cRoteiro, .F. )
	If Eof()
		DbSeek( xFilial( "RCH" ) + cProcesso + cPeriodo + Semana + Space(GetSx3Cache( "RCH_ROTEIR", "X3_TAMANHO" )), .F. )
	EndIf
	If !Eof()
		dDataPagto := RCH->RCH_DTPAGO
	Else
		Help( " ", 1, "REGNOIS" )
	EndIf
EndIf

IF !( lTerminal )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Busca parametros                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cMailConta	:=If(cMailConta == NIL,GETMV("MV_EMCONTA"),cMailConta)             //Conta utilizada p/envio do email
	cMailServer	:=If(cMailServer == NIL,GETMV("MV_RELSERV"),cMailServer)           //Server
	cMailSenha	:=If(cMailSenha == NIL,GETMV("MV_EMSENHA"),cMailSenha)
	
	If Empty(cEmail)
		Return
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se existe o SMTP Server                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If 	Empty(cMailServer)
		Help(" ",1,"SEMSMTP")//"O Servidor de SMTP nao foi configurado !!!" ,"Atencao"
		Return(.F.)
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se existe a CONTA                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If 	Empty(cMailConta)
		Help(" ",1,"SEMCONTA")//"A Conta do email nao foi configurado !!!" ,"Atencao"
		Return(.F.)
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se existe a Senha                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If 	Empty(cMailServer)
		Help(" ",1,"SEMSENHA")	//"A Senha do email nao foi configurado !!!" ,"Atencao"
		Return(.F.)
	EndIf
	
EndIF

If !( lTerminal )
	cDescUbigeo := fRDescUbig()
Endif


	cReferencia	:= AllTrim( MesExtenso(Month(dDataRef))+"/"+STR(YEAR(dDataRef),4) ) + " - ( " + cTipo + "-" + cPeriodo + "/" + Semana + " )"

cHtml +=	'<html>'
cHtml +=		'<head>'
IF !( lTerminal )
	
	cHtml += 		'<title>DEMONSTRATIVO DE PAGAMENTO</title>'
	cHtml +=			'<style>'
	cHtml +=				'th { text-align:left; background-color:#4B87C2; line-height:01; line-width:400; border-left:0px solid  #FF9B06; border-right:0px solid #FF9B06; border-bottom:0px solid #FF9B06 ; border-top:0px solid #FF9B06 }'
	cHtml +=				'.tdPrinc { text-align:left; line-height:1; line-width:340 ; border-left:0px solid #FF9B06; border-right:0px solid #FF9B06; border-bottom:0px solid #FF9B06 ; border-top:0px solid #FF9B06 > }'
	cHtml +=				'.td18_94_AlignR { text-align:right ; line-height:1; line-width:94 }'
	cHtml +=				'.td18_95_AlignR { text-align:right ; line-height:1; line-width:95 }'
	cHtml +=				'.td26_94_AlignR { text-align:right ; line-height:1; line-width:94 }'
	cHtml +=				'.td26_95_AlignR { text-align:right ; line-height:1; line-width:95 }'
	cHtml += 				'.td26_18_AlignL { lext-align:left ; line-height:1; line:width:18 ; border-left:0px solid #FF9B06; border-right:0px solid #FF9B06; border-bottom:0px solid #FF9B06 ; border-top:0px solid #FF9B06 bgcolor=#6F9ECE" }'
	cHtml +=    			'.pStyle1 { line-height:100% ; margin-top:15 ; margin-bottom:0 }'
	cHtml +=			'</style>'
	cHtml +=	'</head>'
	cHtml +=		'<body bgcolor="#FFFFFF"  topmargin="0" leftmargin="0">'
	cHtml +=			'<center>'
	cHtml +=				'<table  border="1" cellpadding="0" cellspacing="0" bordercolor="#FF9B06" bgcolor="#000082" width=598 height="637">'
	cHtml +=    				'<td width="598" height="181" bgcolor="FFFFFF">'
	cHtml += 					'<center>'
	cHtml += 					'<font color="#000000">'
	cHtml +=					'<b>'
	cHtml += 					'<h4 size="03">'
	cHtml +=					'<br>'
	cHtml += 						STR0044 // " DEMONSTRATIVO DE PAGAMENTO "
	cHtml += 					'<br>'
	
Else
	
	cHtml += 		'<title>RH Online</title>' + CRLF
	cHtml += 		'<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">' + CRLF
	cHtml += 		'<link rel="stylesheet" href="css/rhonline.css" type="text/css">' + CRLF
	cHtml += 	'</head>' + CRLF
	cHtml += 	'<body bgcolor="#FFFFFF" text="#000000">' + CRLF
	cHtml += 		'<Table width="515" border="0" cellspacing="0" cellpadding="0">' + CRLF
	
	//Cabecalho completo - TERMINAL
	
			cHtml += 			CabecHtml( cReferencia , dDataPagto , dDataRef )

	
	//Separador
	cHtml +=			"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
	cHtml +=				"<TBODY>" + CRLF
	cHtml +=					"<TR>" + CRLF
	cHtml +=						"<TD vAlign=top width='100%' height=10>" + CRLF
	cHtml +=						"</TD>" + CRLF
	cHtml +=	 				"</TR>" + CRLF
	cHtml +=				"</TBODY>" + CRLF
	cHtml +=			"</TABLE>" + CRLF
	
	cHtml +=			"<TABLE border='1' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
	cHtml +=				"<TBODY>" + CRLF
EndIF

If !Empty(Semana) .And. Semana # "99" .And.  Upper(SRA->RA_TIPOPGT) == "S"
	IF !( lTerminal )
		cHtml += cReferencia
	EndIF
Else
	IF !( lTerminal )
		cHtml += cReferencia
	EndIF
EndIf

/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Carrega Funcao do Funcion. de acordo com a Dt Referencia     ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
fBuscaFunc(dDataRef, @cCodFunc, @cDescFunc   )

IF !( lTerminal )
	
	//Cabecalho utilizado pela localizacao Peru
		cHtml += '</b></h4></font></center>'
		cHtml += '<hr whidth = 100% align=right color="#FF812D">'
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Dados do funcionario                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cHtml += '<!Dados do Funcionario>'
		cHtml += '<p align=left  style="margin-top: 0">'
		cHtml +=   '<font color="#000082" face="Courier New"><i><b>'
		cHtml +=  	'&nbsp;&nbsp' + STR0001 + ":" + '&nbsp;' + SRA->RA_MAT + '&nbsp;' + "-" + '&nbsp;' + SRA->RA_NOME +'</i><br>' //Funcionario
		cHtml += 	'&nbsp;&nbsp' + "DNI" + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + ":"   +  '&nbsp;' + "SRA->RA_RG"      + '&nbsp;&nbsp;' + STR0174 + '&nbsp;' +":"+ '&nbsp;' + AllTrim(STR(SRA->RA_HRSMES))+'<br>' //"DNI + Horas Mensais
		cHtml += 	'&nbsp;&nbsp' + "AFP" + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + ":"   +  Space(1) + SRA->RA_CODAFP  + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + "Ubigeo :" + '&nbsp;' + cDescUbigeo +'<br>' //"DNI + Horas Mensais
		cHtml += 	'&nbsp;&nbsp' + STR0103 + '&nbsp;&nbsp;' + ":" + '&nbsp;' + cCodFunc   + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + STR0069 + '&nbsp;' + ":" + '&nbsp;' + cDescFunc	+'<br>' //"Funcao    - Descricao "
		cHtml +=  	'&nbsp;&nbsp' + STR0002 + '&nbsp;&nbsp'  + ":" + '&nbsp;' + SRA->RA_CC + '&nbsp;'+ "-" + '&nbsp;' + DescCc(SRA->RA_CC,SRA->RA_FILIAL) +'<br>' //"C.Custo   - "
		cHtml +=    '&nbsp;&nbsp' + STR0049 + SRA->RA_BCDEPSAL+"-"+DescBco(SRA->RA_BCDEPSAL,SRA->RA_FILIAL)+ '&nbsp;'+  SRA->RA_CTDEPSAL //"Bco/Conta - "
		cHtml += '</b></p></font>'
		cHtml += '<!Proventos e Desconto>'
		cHtml += '<div align="center">'
		cHtml += '<Center>'
		cHtml += '<Table bgcolor="#6F9ECE" border="0" cellpadding ="1" cellspacing="0" width="553" height="296">'
		cHtml += '<TBody><Tr>'
		cHtml +=	'<font face="Arial" size="02" color="#000082"><b>'
		cHtml += 	'<th>' + STR0050 + '</th>' //"Cod  Descricao "
		cHtml += 	'<th>' + STR0051 + '</th>' //"Referencia"
		cHtml += 	'<th>' + STR0052 + '</th>' //"Valores"
		cHtml += 	'</b></font></tr>'
		cHtml += '<font color=#000082 face="Courier new"  size=2">'

	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Espacos Entre os Cabecalho e os Proventos/Descontos          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cHtml += 	'<tr>'
	cHtml += 		'<td class="tdPrinc"></td>'
	cHtml += 		'<td class="td18_94_AlignR">&nbsp;&nbsp</td>'
	cHtml += 		'<td class="td18_95_AlignR">&nbsp;&nbsp</td>'
	cHtml += 		'<td class="td18_18_AlignL"></td>'
	cHtml += 	'</tr>'
	
Else
	
	//Cabecalho dos valores
	cHtml +=					"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
	cHtml +=						"<TBODY>" + CRLF
	cHtml += 							'<tr align="center">' + CRLF
	cHtml += 								'<td width="45" height="1">' + CRLF
	cHtml += 									'<span class="etiquetas"><div align="Left">'+ STR0068 + '</span></div>' + CRLF //C&oacute;digo
	cHtml += 								'</td>' + CRLF
	cHtml += 								'<td width="219" valign="top">' + CRLF
	cHtml += 									'<span class="etiquetas"><div align="left">' + STR0069 + '</span></div>' + CRLF //Descri&ccedil;&atilde;o
	cHtml += 								'</td>' + CRLF
	cHtml += 								'<td width="127" valign="top">' + CRLF
	cHtml += 									'<span class="etiquetas"><div align="right">' + STR0070  + '</span></div>' + CRLF //Refer&ecirc;ncia
	cHtml += 								'</td>' + CRLF
	cHtml += 								'<td width="127" valign="top">' + CRLF
	cHtml += 									'<span class="etiquetas"><div align="right">' + STR0052 + '</span></div>' + CRLF //Valores
	cHtml += 								'<td width="107" valign="top">' + CRLF
	cHtml += 									'<span class="etiquetas"><div align="right"> (+/-) </span></div>' + CRLF
	cHtml += 								'</td>' + CRLF
	cHtml += 							'</tr>' + CRLF
	cHtml +=						"</TBODY>" + CRLF
	cHtml += 					'</TABLE>' + CRLF
	
	//Separador
	cHtml +=					"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
	cHtml +=						"<TBODY>" + CRLF
	cHtml +=							"<TR>" + CRLF
	cHtml +=								"<TD vAlign=top width='100%' height=05>" + CRLF
	cHtml +=								"</TD>" + CRLF
	cHtml +=	 						"</TR>" + CRLF
	cHtml +=						"</TBODY>" + CRLF
	cHtml +=					"</TABLE>" + CRLF
	
	cHtml +=					"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
	cHtml +=						"<TBODY>" + CRLF
	cHtml +=							"<TR>" + CRLF
	
EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Proventos                                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nProv:=1 To Len( aProve )
	
	nResto := ( ++nZebrado % 2 )
	
	IF !( lTerminal )
		
		cHtml += '<tr>'
		cHtml += 	'<td class="tdPrinc">' + aProve[nProv,1] + '</td>'
		cHtml += 	'<td class="td18_94_AlignR">' + Transform(aProve[nProv,2],'999.99')+'</td>'
		cHtml += 	'<td class="td18_95_AlignR">' + Transform(aProve[nProv,3],cPict1) + '</td>'
		cHtml +=    '<td class="td18_18_AlignL"></td>'
		cHtml += '</tr>'
		
	Else
		
		cHtml += 							'<tr>' + CRLF
		IF nResto > 0.00
			cHtml += 							'<td width="45" vAlign=top height="1" bgcolor="#FAFBFC">'
		Else
			cHtml += 							'<td width="45" vAlign=top height="1">' + CRLF
		EndIF
		cHtml += 									'<div align="left"><span class="dados">'  + Substr( aProve[nProv,1] , 1 , 3 ) + '</span></div>' + CRLF
		cHtml += 								'</td>' + CRLF
		IF nResto > 0.00
			cHtml += 							'<td width="219" valign="top" bgcolor="#FAFBFC">' + CRLF
		Else
			cHtml += 							'<td width="219" vAlign=top="top">' + CRLF
		EndIF
		cHtml += 									'<div align="Left"><span class="dados">'  + Capital( AllTrim( Substr( aProve[nProv,1] , 4 ) ) ) + '</span></div>' + CRLF
		cHtml += 								'</td>' + CRLF
		IF nResto > 0.00
			cHtml += 							'<td width="127" valign="top" bgcolor="#FAFBFC">' + CRLF
		Else
			cHtml += 							'<td width="127" valign="top">' + CRLF
		EndIF
		cHtml += 									'<div align="right"><span class="dados">' + Transform(aProve[nProv,2],'999.99') + '</span></div>' + CRLF
		cHtml += 								'</td>' + CRLF
		IF nResto > 0.00
			cHtml += 							'<td width="127" valign="top" bgcolor="#FAFBFC">' + CRLF
		Else
			cHtml += 							'<td width="127" valign="top">' + CRLF
		EndIF
		cHtml += 									'<div align="right"><span class="dados">' + Transform(aProve[nProv,3],cPict1) + '</span></div>' + CRLF
		cHtml += 								'</td>' + CRLF
		IF nResto > 0.00
			cHtml += 							'<td width="107" valign="top" bgcolor="#FAFBFC">' + CRLF
		Else
			cHtml += 							'<td width="107" valign="top">' + CRLF
		EndIF
		cHtml += 									'<div align="right"><span class="dados"> (+) </span></div>' + CRLF
		cHtml += 								'</td>' + CRLF
		cHtml += 							'</tr>' + CRLF
	EndIF
Next nProv

IF ( lTerminal )
	cHtml +=							"</TR>" + CRLF
	cHtml +=							"<TR>" + CRLF
EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Descontos                                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nDesco := 1 to Len(aDesco)
	
	nResto := ( ++nZebrado % 2 )
	
	IF !( lTerminal )
		
		cHtml += '<tr>'
		cHtml += 	'<td class="tdPrinc">' + aDesco[nDesco,1] + '</td>'
		cHtml += 	'<td class="td18_94_AlignR">' + Transform(aDesco[nDesco,2],'999.99') + '</td>'
		cHtml += 	'<td class="td18_95_AlignR">' + Transform(aDesco[nDesco,3],cPict1) + '</td>'
		cHtml += 	'<td class="td18_18_AlignL">-</td>'
		cHtml += '</tr>'
		
	Else
		
		cHtml += 							'<tr>' + CRLF
		IF nResto > 0.00
			cHtml += 							'<td width="45" align="center" height="19" bgcolor="#FAFBFC">'
		Else
			cHtml += 							'<td width="45" align="center" height="19">' + CRLF
		EndIF
		cHtml += 									'<div align="left"><span class="dados">'  + Substr( aDesco[nDesco,1] , 1 , 3 ) + '</span></div>' + CRLF
		cHtml += 								'</td>' + CRLF
		IF nResto > 0.00
			cHtml += 							'<td width="219" valign="top" bgcolor="#FAFBFC">' + CRLF
		Else
			cHtml += 							'<td width="219" valign="top">' + CRLF
		EndIF
		cHtml += 									'<div align="Left"><span class="dados">'  + Capital( AllTrim( Substr( aDesco[nDesco,1] , 4 ) ) ) + '</span></div>' + CRLF
		cHtml += 								'</td>' + CRLF
		IF nResto > 0.00
			cHtml += 							'<td width="127" valign="top" bgcolor="#FAFBFC">' + CRLF
		Else
			cHtml += 							'<td width="127" valign="top">' + CRLF
		EndIF
		cHtml += 									'<div align="right"><span class="dados">' + Transform(aDesco[nDesco,2],'999.99') + '</span></div>' + CRLF
		cHtml += 								'</td>' + CRLF
		IF nResto > 0.00
			cHtml += 							'<td width="127" valign="top" bgcolor="#FAFBFC">' + CRLF
		Else
			cHtml += 							'<td width="127" valign="top">' + CRLF
		EndIF
		cHtml += 									'<div align="right"><span class="dados">' + Transform(aDesco[nDesco,3],cPict1) + '</span></div>' + CRLF
		cHtml += 								'</td>' + CRLF
		IF nResto > 0.00
			cHtml += 							'<td width="107" valign="top" bgcolor="#FAFBFC">' + CRLF
		Else
			cHtml += 							'<td width="107" valign="top">' + CRLF
		EndIF
		cHtml += 									'<div align="right"><span class="dados"> (-) </span></div>' + CRLF
		cHtml += 								'</td>' + CRLF
		cHtml += 							'</tr>' + CRLF
	EndIF
Next nDesco

IF ( lTerminal )
	
	cHtml +=							"</TR>" + CRLF
	cHtml +=						"</TBODY>" + CRLF
	cHtml +=					"</TABLE>" + CRLF
	
	//Separador
	cHtml +=					"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
	cHtml +=						"<TBODY>" + CRLF
	cHtml +=							"<TR>" + CRLF
	cHtml +=								"<TD vAlign=top width='100%' height=05>" + CRLF
	cHtml +=								"</TD>" + CRLF
	cHtml +=	 						"</TR>" + CRLF
	cHtml +=						"</TBODY>" + CRLF
	cHtml +=					"</TABLE>" + CRLF
	
	cHtml +=					"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
	cHtml +=						"<TBODY>" + CRLF
	cHtml +=							"<TR>" + CRLF
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Terminal - Impressao de Bases                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF cBaseAux = "S"
		
		For nBase:=1 To Len( aBases )
			
			cHtml += 								"<tr>"
			cHtml += 									"<td width=219' bgcolor='#FAFBFC' class='etiquetas'>"
			cHtml +=										aBases[nBase,1] + CRLF
			cHtml +=									"</td>" + CRLF
			cHtml += 									"<td width='45' bgcolor='#FAFBFC' class='dados'>" + CRLF
			cHtml += 										'<div align="left" class="etiquetas"> </div>' + CRLF
			cHtml +=									"</td>" + CRLF
			cHtml += 									"<td width='127' bgcolor='#FAFBFC' class='dados'>" + CRLF
			cHtml +=										"<div align='right'>" + Transform(aBases[nBase,2],'999.99') + "</div>" + CRLF
			cHtml +=									"</td>" + CRLF
			cHtml += 									"<td width='127'  bgcolor='#FAFBFC' class='dados'>" + CRLF
			cHtml +=										"<div align='right'>" + Transform(aBases[nBase,3],cPict1) + "</div>" + CRLF
			cHtml +=									'</td>' + CRLF
			cHtml += 									"<td width='107' valign='top' bgcolor='#FAFBFC'>" + CRLF
			cHtml += 										"<div align='right'><span class='dados'></span></div>" + CRLF
			cHtml += 									"</td>" + CRLF
			cHtml += 								"</tr>" + CRLF
			
		Next
		
		If Len( aBases ) > 0   // Espaco apos impressao bases
			
			cHtml += 	'<tr>'
			cHtml += 		'<td class="tdPrinc"></td>'
			cHtml += 		'<td class="td18_94_AlignR">&nbsp;&nbsp</td>'
			cHtml += 		'<td class="td18_95_AlignR">&nbsp;&nbsp</td>'
			cHtml += 		'<td class="td18_18_AlignL"></td>'
			cHtml += 	'</tr>'
			
		EndIf
		
	EndIf
EndIF

IF !( lTerminal )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Espacos Entre os Proventos e Descontos e os Totais           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cHtml += 	'<tr>'
	cHtml += 		'<td class="tdPrinc"></td>'
	cHtml += 		'<td class="td18_94_AlignR">&nbsp;&nbsp</td>'
	cHtml += 		'<td class="td18_95_AlignR">&nbsp;&nbsp</td>'
	cHtml += 		'<td class="td18_18_AlignL"></td>'
	cHtml += 	'</tr>'
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Totais                                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cHtml += '<!Totais >'
	cHtml +=	'<b><i>'
	cHtml += 	'<tr>'
	cHtml += 		'<td class="tdPrinc">' + STR0053 + '</td>' //"Total Bruto "
	cHtml += 		'<td class="td18_94_AlignR"></td>'
	cHtml += 		'<td class="td18_95_AlignR">' + Transform(TOTVENC,cPict1) + '</td>'
	cHtml += 		'<td class="td18_18_AlignL"></td>'
	cHtml +=	'</tr>'
	cHtml += 	'<tr>'
	cHtml += 		'<td class="tdPrinc">' + STR0054 + '</td>' //"Total Descontos "
	cHtml += 		'<td class="td18_94_AlignR"></Td>'
	cHtml += 		'<td class="td18_95_AlignR">' + Transform(TOTDESC,cPict1) + '</td>'
	cHtml += 		'<td class="td18_18_AlignL">-</td>'
	cHtml += 	'</tr>'
	cHtml += 	'<tr>'
	cHtml += 		'<td class="tdPrinc">' + STR0055 + '</td>' //"Liquido a Receber "
	cHtml += 		'<td class="td18_94_AlignR"></td>'
	cHtml += 		'<td align=right height="18" width="95" Style="border-left:0px solid #FF812D; border-right:0px solid #FF9B06; border-bottom:0px solid #FF9B06 ; border-top:1px solid #FF9B06 bgcolor=#4B87C2">'
	cHtml +=        Transform((TOTVENC-TOTDESC),cPict1) +'</td>'
	cHtml += 	'</tr>'
	cHtml += '<!Bases>'
	cHtml += 	'<tr>'
	
Else
	
	
	
	//Total de Proventos
	cHtml += 							'<tr>' + CRLF
	cHtml += 								'<td width="219" valign="top" bgcolor="#FAFBFC">' + CRLF
	cHtml += 									'<div align="left" class="etiquetas"> ' + cTitTotal + '</div>' + CRLF //"Total Bruto: "
	cHtml += 								'</td>' + CRLF
	cHtml += 								'<td width="45" valign="top" bgcolor="#FAFBFC">' + CRLF
	cHtml += 									'<div align="left" class="etiquetas"> </div>' + CRLF
	cHtml += 								'</td>' + CRLF
	cHtml += 								'<td width="127" valign="top" bgcolor="#FAFBFC">' + CRLF
	cHtml += 									'<div align="left" class="etiquetas"> </div>' + CRLF
	cHtml += 								'</td>' + CRLF
	cHtml += 								'<td width="127" valign="top" bgcolor="#FAFBFC">' + CRLF
	cHtml += 									'<div align="right"><span class="dados">' + Transform(TOTVENC,cPict1) + '</span></div>' + CRLF
	cHtml += 								'</td>' + CRLF
	cHtml += 								'<td width="107" valign="top" bgcolor="#FAFBFC">' + CRLF
	cHtml += 									'<div align="right"><span class="dados"> (+) </span></div>' + CRLF
	cHtml += 								'</td>' + CRLF
	cHtml += 							'</tr>' + CRLF
	
	//Total de Descontos
	cHtml += 							'<tr>' + CRLF
	cHtml += 								'<td width="219" valign="top">' + CRLF
	cHtml += 									'<div align="left" class="etiquetas"> ' + cTitTDesc + '</div>' + CRLF //"Total de Descontos: "
	cHtml += 								'</td>' + CRLF
	cHtml += 								'<td width="45" valign="top">' + CRLF
	cHtml += 									'<div align="left" class="etiquetas"> </div>' + CRLF
	cHtml += 								'</td>' + CRLF
	cHtml += 								'<td width="127" valign="top">' + CRLF
	cHtml += 									'<div align="left" class="etiquetas"> </div>' + CRLF
	cHtml += 								'</td>' + CRLF
	cHtml += 								'<td width="127" valign="top">' + CRLF
	cHtml += 									'<div align="right"><span class="dados">' + Transform(TOTDESC,cPict1) + '</span></div>' + CRLF
	cHtml += 								'</td>' + CRLF
	cHtml += 								'<td width="107" valign="top">' + CRLF
	cHtml += 									'<div align="right"><span class="dados"> (-) </span></div>' + CRLF
	cHtml += 								'</td>' + CRLF
	cHtml += 							'</tr>' + CRLF
	
	
	//Liquido
	cHtml += 							'<tr>' + CRLF
	cHtml += 								'<td width="219" valign="top" bgcolor="#FAFBFC">' + CRLF
	cHtml += 									'<div align="left" class="etiquetas">' + cTitTLiq  + '</div>' + CRLF //"L&iacute;quido a Receber: "
	cHtml += 								'</td>' + CRLF
	cHtml += 								'<td width="45" valign="top" bgcolor="#FAFBFC">' + CRLF
	cHtml += 									'<div align="left" class="etiquetas"> </div>' + CRLF
	cHtml += 								'</td>' + CRLF
	cHtml += 								'<td width="127" valign="top" bgcolor="#FAFBFC">' + CRLF
	cHtml += 									'<div align="left" class="etiquetas"> </div>' + CRLF
	cHtml += 								'</td>' + CRLF
	cHtml += 								'<td width="127" valign="top" bgcolor="#FAFBFC">' + CRLF
	cHtml += 									'<div align="right"><span class="dados">' + Transform((TOTVENC-TOTDESC),cPict1) + '</span></div>' + CRLF
	cHtml += 								'</td>' + CRLF
	cHtml += 								'<td width="107" valign="top" bgcolor="#FAFBFC">' + CRLF
	cHtml += 									'<div align="right"><span class="dados"> (=) </span></div>' + CRLF
	cHtml += 								'</td>' + CRLF
	cHtml += 							'</tr>' + CRLF
	
	cHtml +=							"</TR>" + CRLF
	cHtml +=						"</TBODY>" + CRLF
	cHtml +=					"</TABLE>" + CRLF
	
	//Separador
	cHtml +=					"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
	cHtml +=						"<TBODY>" + CRLF
	cHtml +=							"<TR>" + CRLF
	cHtml +=								"<TD vAlign=top width='100%' height=10>" + CRLF
	cHtml +=								"</TD>" + CRLF
	cHtml +=	 						"</TR>" + CRLF
	cHtml +=						"</TBODY>" + CRLF
	cHtml +=					"</TABLE>" + CRLF
	
	cHtml +=					"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
	cHtml +=						"<TBODY>" + CRLF
	cHtml +=							"<TR>" + CRLF
	
EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Espacos Entre os Totais e as Bases                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF !( lTerminal )
	cHtml += 	'<tr>'
	cHtml += 		'<td class="tdPrinc"></td>'
	cHtml += 		'<td class="td18_94_AlignR">&nbsp;&nbsp</td>'
	cHtml += 		'<td class="td18_95_AlignR">&nbsp;&nbsp</td>'
	cHtml += 		'<td class="td18_18_AlignL"></td>'
	cHtml += 	'</tr>'
Else
	cHtml += '<table width="498" border="0" cellspacing="0" cellpadding="0">' + CRLF
EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Base de Adiantamento                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cTipoRot = "2"
	If cBaseAux = "S" .And. nBaseIr # 0
		IF !( lTerminal )
			cHtml +=	'<tr>'
			cHtml +=		'<td class="tdPrinc"><p class="pStyle1"><font color=#000082 face="Courier new" size=2><i>'+STR0058+'</i></p></td></font>' //"Base IR Adiantamento"
			cHtml +=		'<td class="td26_94_AlignR"><p></td>'
			cHtml +=		'<td class="td26_95_AlignR"><p>'+ Transform(nBaseIr,cPict1)+'</td>'
			cHtml +=		'<td class="td26_18_AlignL"><p></td>'
			cHtml += 	'</tr>'
		Else
			cHtml += '<tr>'
			cHtml += '<td width="304" class="etiquetas">' + STR0058 + ' + </td>' + CRLF
			cHtml += '<td width="103" class="dados"><div align="center">' + Transform(nBaseIr,cPict1) + '</div></td>' + CRLF
			cHtml += '<td width="91"  class="dados"><div align="center">' + Transform(0.00   ,cPict1) + '</div></td>' + CRLF
			cHtml += '</tr>'
		EndIF
	Endif
EndIF

IF !( lTerminal )
	
	cHtml += '</font></i></b>'
	cHtml += '</TBody>'
	cHtml += '</table>'
	cHtml += '</center>'
	cHtml += '</div>'
	cHtml += '<hr whidth = 100% align=right color="#FF812D">'
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Espaco para Observacoes/mensagens                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cHtml += '<!Mensagem>'
	cHtml += '<Table bgColor=#6F9ECE border=0 cellPadding=0 cellSpacing=0 height=100 width=598>'
	cHtml += 	'<TBody>'
	cHtml +=	'<tr>'
	cHtml +=	'<td align=left height=18 width=574 style="border-left:1px solid #FF9B06; border-right:1px solid #FF9B06; border-bottom: 0px solid #FF9B06 ; border-top:1px solid #FF9B06 bgcolor=#6F9ECE"><i><font face="Arial" size="2" color="#000082">'+DESC_MSG1+ '</font></td></tr>'
	cHtml +=	'<tr>'
	cHtml +=	'<td align=left height=18 width=574 style="border-left:1px solid #FF9B06; border-right:1px solid #FF9B06; border-bottom: 0px solid #FF9B06 ; border-top: 0px solid #FF9B06 bgcolor=#6F9ECE"><i><font face="Arial" size="2" color="#000082">'+DESC_MSG2+ '</font></td></tr>'
	cHtml +=	'<tr>'
	cHtml += 	'<td align=left height=18 width=574 style="border-left:1px solid #FF9B06; border-right:1px solid #FF9B06; border-bottom:1px solid #FF9B06 ; border-top: 0px solid #FF9B06 bgcolor=#6F9ECE"><i><font face="Arial" size="2" color="#000082">'+DESC_MSG3+ '</font></td></tr>'
	IF cMesComp == Month(SRA->RA_NASC)
		cHtml += '<TD align=left height=18 width=574 bgcolor="#FFFFFF"><EM><B><CODE>      <font face="Arial" size="4" color="#000082">'
		cHtml += '<MARQUEE align="middle" bgcolor="#FFFFFF">' + STR0059	+ '</marquee><code></b></font></td></tr>' //"F E L I Z &nbsp;&nbsp  A N I V E R S A R I O !!!! "
	EndIF
	cHtml += '</TBody>'
	cHtml += '</Table>'
	cHtml += '</table>'
	cHtml += '</body>'
	cHtml += '</html>'
	
Else
	
	cHtml +=							"</TR>" + CRLF
	cHtml +=						"</TBODY>" + CRLF
	cHtml +=					"</TABLE>" + CRLF
	
	cHtml +=				"</TBODY>" + CRLF
	cHtml +=			"</TABLE>" + CRLF
	
	//Separador
	cHtml +=			"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
	cHtml +=				"<TBODY>" + CRLF
	cHtml +=					"<TR>" + CRLF
	cHtml +=						"<TD vAlign=top width='100%' height=10>" + CRLF
	cHtml +=						"</TD>" + CRLF
	cHtml +=			 		"</TR>" + CRLF
	cHtml +=				"</TBODY>" + CRLF
	cHtml +=			"</TABLE>" + CRLF
	
	//Rodape
	cHtml +=	RodaHtml()
	
	cHtml += 		'</TABLE>' + CRLF
	cHtml += 		'<p align="right"><a href="javascript:self.print()"><img src="imagens/imprimir.gif" width="90" height="28" hspace="20" border="0"></a></p>' + CRLF
	cHtml += 	'</body>' + CRLF
	cHtml += '</html>' + CRLF
	
EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia e-mail p/funcionario                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF !( lTerminal )
	lEnvioOk := GPEMail(cSubject,cHtml,cEmail)
EndIF

RestArea( aSvArea )

Return( IF( lTerminal , cHtml , NIL ) )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fImpTeste ºAutor  ³R.H. - Natie        º Data ³  11/29/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Testa impressao de Formulario Teste                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
/*Static function fImpTeste(cString,nTipoRel)

//--Comando para nao saltar folha apos o MsFlush.
SetPgEject(.F.)

@ PROW(),PCOL() PSAY ""
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Descarrega teste de impressao                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MS_Flush()
fInicia(cString,nTipoRel)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o Li com a a linha de impressão correten para não saltar linhas no teste  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
li := _Prow()

//If nTipoRel == 2
//	@ LI,00 PSAY AvalImp(Limite)
//Endif

lRetCanc	:= Pergunte("GPR30A",.T.)

Vez := If(nTipRel = 1,1,0)

Return Vez
*/
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fInicia   ºAutor  ³Natie               º Data ³  04/12/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Inicializa parametros para impressao                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function  fInicia(cString,nTipoRel)


If LastKey() = 27 .Or. nLastKey = 27
	Return  .F.
Endif

If nTipoRel# 3
	SetDefault(aReturn,cString)
Endif

If LastKey() = 27 .OR. nLastKey = 27
	Return .F.
Endif

Return .T.

/*
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡…o	   ³CabecHtml  		³Autor³Marinaldo de Jesus ³ Data ³18/09/2003³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡…o ³Retorna Cabecalho HTML para o RHOnLine                      ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³<Vide Parametros Formais>									³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³<Vide Parametros Formais>									³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Retorno   ³cHtml  														³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Uso	   ³GPER030PER       										    	³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Static Function CabecHtml( cReferencia , dDataPagto , dDataRef )

Local cCodFunc		:= ""		//-- codigo da Funcao do funcionario
Local cDescFunc		:= ""		//-- Descricao da Funcao do Funcionario
Local cHtml 		:= ""
Local cLogoEmp		:= RetLogoEmp()
 

Local nSalario		:= 0
Local cTitPagto		:= STR0044  // Titulo p/ o Comprovante de Pagto.
// PER
Local cDescUbigeo   := ""
Local dDataPerAd	:= cTod("")
Local dDataPerAt	:= cTod("")
Local dDataIniF     := cTod("")
Local dDAtaFimF		:= cTod("")
Local nDiastb		:= 0    //Dias Trabalhados
//Local nDiasP		:= 0    //Dias Trabalhados
Local nDiasAfas		:= 0    //Dias de Afastamento
Local nDiasAfs		:= 0	//Dias de Afastanentos subsidiados
Local cUltDia	    := StrZero( f_UltDia(CTOD( "01/" + cMes + "/"+ cAno , "DDMMYY" ) ) , 2 ) //Ultimo dia do mes deste periodo
Local dData   	    := Ctod( cUltDia + "/" + cMes + "/" + cAno , "DDMMYY" ) //data formatada com o ultimo dia do mes.
Local nHorOrd       := 0 //Quantidade de horas trabalhadas pelo funcionario
Local nHorExt       := 0 //Quantidade de horas extras trabalhadas pelo funcionario

DEFAULT cReferencia	:= ""

Private nTotDias := 0	 //-- Total de Dias da Semana
Private cDiasMes := Getmv("MV_DIASMES")
Private DiasDsr  := 0


	
	If SRA->RA_TIPOPGT = "S"
		nTotDias := 7						//-- Total de Dias da Semana
	EndIf
	
	cDescUbigeo := fRDescUbig()
	cTpEmprega  := fRTipoEmp()
	fRetFerFunc(@dDataPerAd, @dDataPerAt ,@dDataIniF , @dDAtaFimF)
	cDescAfp    := fRDescAFP()
	
	// -- Apura Dias Trabalhados
	FDiasTrab(@nDiastb,cDiasMes,.F.,dData,.F.)
	
	
	//Busca dias de afastamento subsidiados
	fAfasSub(@nDiasAfs)
	
	//Busca horas ordinarias
	fHorasFunc( .F. , @nHorOrd , Semana)
	
	//Busca horas extras
	fHorasFunc( .T. , @nHorExt, Semana)
	
	nSalario := SRA->RA_SALARIO


/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Carrega Funcao do Funcion. de acordo com a Dt Referencia     ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
fBuscaFunc(dDataRef, @cCodFunc, @cDescFunc   )



//Logo e Titulo
cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY class='fundo'>"
cHtml +=			"<img src='" + cLogoEmp +"' width='206' height='030' align=left hspace=30>" + CRLF
cHtml +=					"<b>" + CRLF
cHtml += 						"<span class='titulo_opcao'>" + Capital( cTitPagto ) + "</span>" + CRLF //DEMONSTRATIVO DE PAGAMENTO
cHtml +=					"</b>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Empresa
cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>" + STR0097 + CRLF //"Empresa: "
cHtml += 						"</span>" + CRLF
cHtml +=	        			 "<span class='dados'>" + CRLF
cHtml +=								Capital( AllTrim( Desc_Fil ) ) + CRLF
cHtml += 						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=	 		"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Separador
cHtml +=	"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100%' height=1>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=	 		"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Endereco e CNPJ
cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='65%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>" + STR0098 + CRLF //"Endereço:"
cHtml +=						"</span>" + CRLF
cHtml +=						"<span class='dados'>"
cHtml +=								Capital( AllTrim( Desc_End ) ) + "</span>" + CRLF
cHtml +=						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF

cHtml +=				"<TD vAlign=top width='35%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>" + STR0099 + CRLF	//"CNPJ:"
cHtml +=						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=								Transform( Desc_CGC , "@R 99.999.999/9999-99") + CRLF
cHtml +=						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF

cHtml +=			"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Separador
cHtml +=	"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100%' height=1>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=	 		"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Data do Credito e Conta Corrente
cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=				"<TD vAlign=top width='40%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>" + STR0101 + CRLF //"Crédito em:"
cHtml +=						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=								Dtoc(dDataPagto) + CRLF
cHtml +=						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=				"<TD vAlign=top width='60%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>" + STR0102 + CRLF //"Banco/Agência/Conta:"
cHtml +=						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=								AllTrim( Transform( SRA->RA_BCDEPSA , "@R 999/999999" ) ) + "/" + SRA->RA_CTDEPSA + CRLF
cHtml +=						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=			"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Separador
cHtml +=	"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100%' height=1>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=	 		"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Referencia
cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>" + STR0100 + CRLF //"Referencia:"
cHtml += 						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=								cReferencia + CRLF
cHtml += 						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=	 		"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Separador
cHtml +=	"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100%' height=5>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=	 		"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Nome e Matricula
cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='75%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>" + STR0105 + CRLF //"Nome:
cHtml += 						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=								Capital( AllTrim( SRA->RA_NOME ) ) + CRLF
cHtml += 						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=				"<TD vAlign=top width='25%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>" + STR0106 + CRLF //"Matricula:"
cHtml += 						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=								SRA->RA_MAT + CRLF
cHtml += 						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=			"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Separador
cHtml +=	"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100%' height=1>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=	 		"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF


	
	cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
	cHtml +=		"</TBODY>" + CRLF
	cHtml +=			"<TR>" + CRLF
	
	cHtml +=				"<TD vAlign=top width='30%' height=1>" + CRLF
	cHtml +=					"<P align=left>" + CRLF
	cHtml +=						"<span class='etiquetas'>" + STR0111 + CRLF //"Admissão:"
	cHtml += 						"</span>" + CRLF
	cHtml +=						"<span class='dados'>" + CRLF
	cHtml +=								Dtoc( SRA->RA_ADMISSA ) + CRLF
	cHtml +=						"</span>" + CRLF
	cHtml +=					"</P>" + CRLF
	cHtml +=				"</TD>" + CRLF
	
	cHtml +=				"<TD vAlign=top width='40%' height=1>" + CRLF
	cHtml +=					"<P align=left>" + CRLF
	cHtml +=					"<span class='etiquetas'>" + "DNI: "+ CRLF
	cHtml += 						"</span>" + CRLF
	cHtml +=						"<span class='dados'>" + CRLF
	
	cHtml += 						"</span>" + CRLF
	cHtml +=					"</P>" + CRLF
	cHtml +=				"</TD>" + CRLF
	
	cHtml +=				"<TD vAlign=top width='30%' height=1>" + CRLF
	cHtml +=					"<P align=left>" + CRLF
	cHtml +=					"<span class='etiquetas'>" + STR0174 + CRLF  // Horas Mensais
	cHtml += 						"</span>" + CRLF
	cHtml +=						"<span class='dados'>" + CRLF
	cHtml +=							AllTrim(STR(SRA->RA_HRSMES)) + CRLF
	cHtml += 						"</span>" + CRLF
	cHtml +=					"</P>" + CRLF
	cHtml +=				"</TD>" + CRLF
	
	cHtml +=	 		"</TR>" + CRLF
	cHtml +=		"</TBODY>" + CRLF
	cHtml +=	"</TABLE>" + CRLF
	
	//Separador
	cHtml +=	"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
	cHtml +=		"<TBODY>" + CRLF
	cHtml +=			"<TR>" + CRLF
	cHtml +=				"<TD vAlign=top width='100%' height=1>" + CRLF
	cHtml +=				"</TD>" + CRLF
	cHtml +=	 		"</TR>" + CRLF
	cHtml +=		"</TBODY>" + CRLF
	cHtml +=	"</TABLE>" + CRLF
	
	cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
	cHtml +=		"</TBODY>" + CRLF
	cHtml +=			"<TR>" + CRLF
	
	cHtml +=				"<TD vAlign=top width='30%' height=1>" + CRLF
	cHtml +=					"<P align=left>" + CRLF
	cHtml +=					"<span class='etiquetas'>" + "AFP: "+ CRLF
	cHtml += 						"</span>" + CRLF
	cHtml +=						"<span class='dados'>" + CRLF
	cHtml +=							SRA->RA_CODAFP + CRLF
	cHtml += 						"</span>" + CRLF
	cHtml +=					"</P>" + CRLF
	cHtml +=				"</TD>" + CRLF
	
	cHtml +=				"<TD vAlign=top width='70%' height=1>" + CRLF
	cHtml +=					"<P align=left>" + CRLF
	cHtml +=					"<span class='etiquetas'>" + "Ubigeo : " + CRLF
	cHtml += 						"</span>" + CRLF
	cHtml +=						"<span class='dados'>" + CRLF
	cHtml +=							cDescUbigeo + CRLF
	cHtml += 						"</span>" + CRLF
	cHtml +=					"</P>" + CRLF
	cHtml +=				"</TD>" + CRLF
	
	cHtml +=	 		"</TR>" + CRLF
	cHtml +=		"</TBODY>" + CRLF
	cHtml +=	"</TABLE>" + CRLF
	
	//Separador
	cHtml +=	"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
	cHtml +=		"<TBODY>" + CRLF
	cHtml +=			"<TR>" + CRLF
	cHtml +=				"<TD vAlign=top width='100%' height=1>" + CRLF
	cHtml +=				"</TD>" + CRLF
	cHtml +=	 		"</TR>" + CRLF
	cHtml +=		"</TBODY>" + CRLF
	cHtml +=	"</TABLE>" + CRLF
	
	cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
	cHtml +=		"</TBODY>" + CRLF
	cHtml +=			"<TR>" + CRLF
	
	cHtml +=				"<TD vAlign=top width='30%' height=1>" + CRLF
	cHtml +=					"<P align=left>" + CRLF
	cHtml +=					"<span class='etiquetas'>" + "Dias Lab: "+ CRLF
	cHtml += 						"</span>" + CRLF
	cHtml +=						"<span class='dados'>" + CRLF
	cHtml +=							AllTrim(Str(nDiastb)) + CRLF
	cHtml += 						"</span>" + CRLF
	cHtml +=					"</P>" + CRLF
	cHtml +=				"</TD>" + CRLF
	
	cHtml +=				"<TD vAlign=top width='35%' height=1>" + CRLF
	cHtml +=					"<P align=left>" + CRLF
	cHtml +=					"<span class='etiquetas'>" + "Dias Subs: "+ CRLF
	cHtml += 						"</span>" + CRLF
	cHtml +=						"<span class='dados'>" + CRLF
	cHtml +=							AllTrim(Str(nDiasAfs)) + CRLF
	cHtml += 						"</span>" + CRLF
	cHtml +=					"</P>" + CRLF
	cHtml +=				"</TD>" + CRLF
	
	cHtml +=				"<TD vAlign=top width='35%' height=1>" + CRLF
	cHtml +=					"<P align=left>" + CRLF
	cHtml +=					"<span class='etiquetas'>" + "Dias No Lab: "+ CRLF
	cHtml += 						"</span>" + CRLF
	cHtml +=						"<span class='dados'>" + CRLF
	cHtml +=							AllTrim(Str(nDiasAfas)) + CRLF
	cHtml += 						"</span>" + CRLF
	cHtml +=					"</P>" + CRLF
	cHtml +=				"</TD>" + CRLF
	
	cHtml +=	 		"</TR>" + CRLF
	cHtml +=		"</TBODY>" + CRLF
	cHtml +=	"</TABLE>" + CRLF
	
	
	//Separador
	cHtml +=	"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
	cHtml +=		"<TBODY>" + CRLF
	cHtml +=			"<TR>" + CRLF
	cHtml +=				"<TD vAlign=top width='100%' height=1>" + CRLF
	cHtml +=				"</TD>" + CRLF
	cHtml +=	 		"</TR>" + CRLF
	cHtml +=		"</TBODY>" + CRLF
	cHtml +=	"</TABLE>" + CRLF
	
	cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
	cHtml +=		"</TBODY>" + CRLF
	cHtml +=			"<TR>" + CRLF
	
	cHtml +=				"<TD vAlign=top width='30%' height=1>" + CRLF
	cHtml +=					"<P align=left>" + CRLF
	cHtml +=					"<span class='etiquetas'>" + "N. Hrs Ord: " + CRLF
	cHtml += 						"</span>" + CRLF
	cHtml +=						"<span class='dados'>" + CRLF
	cHtml +=							AllTrim(Str(nHorOrd)) + CRLF
	cHtml += 						"</span>" + CRLF
	cHtml +=					"</P>" + CRLF
	cHtml +=				"</TD>" + CRLF
	
	cHtml +=				"<TD vAlign=top width='70%' height=1>" + CRLF
	cHtml +=					"<P align=left>" + CRLF
	cHtml +=					"<span class='etiquetas'>" + "N. Hrs Ext: " + CRLF
	cHtml += 						"</span>" + CRLF
	cHtml +=						"<span class='dados'>" + CRLF
	cHtml +=							AllTrim(Str(nHorExt)) + CRLF
	cHtml += 						"</span>" + CRLF
	cHtml +=					"</P>" + CRLF
	cHtml +=				"</TD>" + CRLF
	
	cHtml +=	 		"</TR>" + CRLF
	cHtml +=		"</TBODY>" + CRLF
	cHtml +=	"</TABLE>" + CRLF
	


//Separador
cHtml +=	"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100%' height=1>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=	 		"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='60%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>" + STR0103  + CRLF //Funcao
cHtml += 						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=								Capital( AllTrim( cDescFunc ) ) + CRLF
cHtml += 						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=				"<TD vAlign=top width='40%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>" + STR0175 + CRLF //Rem.Basica##Salario Nominal:
cHtml += 						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=								Transform( nSalario , cPict1 ) + CRLF
cHtml += 						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=			"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Separador
cHtml +=	"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100%' height=1>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=	 		"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Centro de Custo
cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>" + STR0110 + CRLF //Centro de Custo:
cHtml += 						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=								AllTrim( SRA->RA_CC ) + " - " + Capital( AllTrim(fDesc("SI3",SRA->RA_CC,"I3_DESC",TamSx3("I3_DESC")[1]) ) ) + CRLF
cHtml += 						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=			"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Separador
cHtml +=	"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100%' height=1>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=	 		"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF


Return( cHtml )



/*
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡…o	   ³RodaHtml  		³Autor³Marinaldo de Jesus ³ Data ³18/09/2003³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡…o ³Retorna Rodape HTML para o RHOnLine                         ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³<Vide Parametros Formais>									³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³<Vide Parametros Formais>									³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Retorno   ³cHtml  														³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Uso	   ³GPER030PER       										    	³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Static Function RodaHtml()

Local cHtml	:= ""

cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top height=1>" + CRLF
cHtml +=					"<P align=center>" + CRLF
cHtml += 							STR0114 + CRLF //"Valido como Comprobante Mensual de Remuneracion"
cHtml +=						"<br>" + CRLF

cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=			"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

Return( cHtml )

/*
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡…o	   ³fMontaDtTcf 	³Autor³Ricardo Duarte     ³ Data ³13/08/2004³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡…o ³Retorna a data valida para a consulta do Terminal Consulta  ³
³          ³do Funcionario                                         		³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³<Vide Parametros Formais>									³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³<Vide Parametros Formais>									³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Retorno   ³cHtml  														³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Uso	   ³GPER030PER       										    	³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Static Function fMontaDtTcf(cMesAno,nDia)

Local dDataValida
Default nDia := 0

dDataValida := stod(right(cMesAno,4)+left(cMesAno,2)+"01")
dDataValida := stod(right(cMesAno,4)+left(cMesAno,2)+strzero(f_UltDia(dDataValida),2))+nDia

return(dDataValida)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fCabeczPer³ Autor ³ R.H. - Alceu Pereira  ³ Data ³ 08.02.10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMRESSAO do cabe‡alho formulario zebrado (Peru)            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fCabeczPer()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Localizacao Peru                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
/*Static Function fCabecZPer()    // Cabecalho do Recibo Zebrado
Local cCodFunc		:= ""		//-- codigo da Funcao do funcionario
Local cDescFunc		:= ""		//-- Descricao da Funcao do Funcionario
Local cDescUbigeo   := ""
Local cDescRot		:= PosAlias("SRY", cRoteiro, SRA->RA_FILIAL, "RY_DESC")
Local cDescAfp      := ""
Local dDataPerAd	:= cTod("")
Local dDataPerAt	:= cTod("")
Local dDataIniF     := cTod("")
Local dDAtaFimF		:= cTod("")
Local nDiastb		:= 0    //Dias Trabalhados
Local nDiasAfas		:= 0    //Dias de Afastamento
Local nDiasAfs		:= 0	//Dias de Afastanentos subsidiados
Local cUltDia	    := StrZero( f_UltDia(CTOD( "01/" + cMes + "/"+ cAno , "DDMMYY" ) ) , 2 ) //Ultimo dia do mes deste periodo
Local dData   	    := Ctod( cUltDia + "/" + cMes + "/" + cAno , "DDMMYY" ) //data formatada com o ultimo dia do mes.
Local nHorOrd       := 0 //Quantidade de horas trabalhadas pelo funcionario
Local nHorExt       := 0 //Quantidade de horas extras trabalhadas pelo funcionario

Private nTotDias := 0	 //-- Total de Dias da Semana
Private cDiasMes := Getmv("MV_DIASMES")
Private DiasDsr  := 0
Private nDiasP := 0

If SRA->RA_TIPOPGT = "S"
	nTotDias := 7						//-- Total de Dias da Semana
EndIf
cDescUbigeo := fRDescUbig()
cTpEmprega  := fRTipoEmp()
fRetFerFunc(@dDataPerAd, @dDataPerAt ,@dDataIniF , @dDAtaFimF)
cDescAfp    := fRDescAFP()

// -- Apura Dias Trabalhados
FDiasTrab(@nDiastb,cDiasMes,.F.,dData,.F.)

// -- Apura Dias de Afastamento


//Carrega Funcao do Funcion. de acordo com a Dt Referencia     ³
fBuscaFunc(dDataRef, @cCodFunc, @cDescFunc   )

//Busca dias de afastamento subsidiados
fAfasSub(@nDiasAfs)

//Busca horas ordinarias
fHorasFunc( .F. , @nHorOrd , Semana)

//Busca horas extras
fHorasFunc( .T. , @nHorExt, Semana)

@ Li,00 PSAY Avalimp(Limite)
LI ++
@ LI,00 PSAY "*"+REPLICATE("=",130)+"*"

LI ++
@ LI,00  PSAY  "|"
@ LI,46  PSAY STR0017		//"RECIBO DE PAGAMENTO  "
@ LI,131 PSAY "|"

LI ++
@ LI,00  PSAY  "|"
@ LI,30  PSAY "(" + Space(1) + MesExtenso(MONTH(dDataRef))+"/"+STR(YEAR(dDataRef),4) + Space(1) + "-" + Space(1) + AllTrim(cDescRot) +  SPACE(1) + "-" + Space(1) + STR0119 + cPeriodo + SPACE(1) + "/" + Space(1) + Semana + ")"
@ LI,131 PSAY "|"

LI ++
@ LI,00 PSAY "|"+REPLICATE("-",130)+"|"

LI ++
@ LI,00  PSAY STR0018 +  AllTrim(DESC_CGC) + Space(5) + "-"    //"| Empresa   : "
@ LI,39  PSAY AllTrim(DESC_Fil)
@ LI,87  PSAY "-"
@ LI,90  PSAY "Filial :" + AllTrim(SRA->RA_FILIAL) 	 //" Local : "
@ LI,131 PSAY "|"

LI ++
@ LI,00  PSAY  "|"
@ LI,02 PSAY STR0168 + Space(1) + AllTrim(DESC_END) + " - " + AllTrim(Desc_Comp) + " - " + AllTrim(DESC_EST) + " - " + AllTrim(DESC_CID)
@ LI,131 PSAY "|"

LI ++
@ LI,00  PSAY  "|"
@ LI,02  PSAY STR0001 + Space(1) + ":"  + Space(1) + SRA->RA_MAT //"| Matricula : "
@ LI,33  PSAY "-"
@ LI,39  PSAY STR0003 + Space(7) + ":" + Space(1) + If( !Empty(SRA->RA_NOMECMP),SRA->RA_NOMECMP,SRA->RA_NOME )	//"Nome  : "
@ LI,87  PSAY "-"
@ LI,90  PSAY STR0170 +  ' ' + cProcesso
@ LI,131 PSAY "|"

LI ++
@ LI,00  PSAY "|"
@ LI,02  PSAY "Fecha Nacimiento : " +  Substr(Dtos(SRA->RA_NASC),7,2) + "/" + Substr(Dtos(SRA->RA_NASC),5,2) + "/" + Substr(Dtos(SRA->RA_NASC),1,4) //+  DtoS(SRA->RA_NASC)
@ LI,33  PSAY "-"
@ LI,39  PSAY "Fecha Ingresso   : "  + Substr(Dtos(SRA->RA_ADMISSA),7,2)+"/"+Substr(Dtos(SRA->RA_ADMISSA),5,2)+"/"+Substr(Dtos(SRA->RA_ADMISSA),1,4)//+  Dtos(SRA->RA_ADMISSA)
@ LI,87  PSAY "-"
@ LI,90  PSAY "Fecha Cese: "  + Substr(Dtos(SRA->RA_DEMISSA),7,2)+"/"+Substr(Dtos(SRA->RA_DEMISSA),5,2)+"/"+Substr(Dtos(SRA->RA_DEMISSA),1,4)//+  Dtos(SRA->RA_DEMISSA)
@ LI,131  PSAY "|"

LI ++
@ LI,00  PSAY "|"
@ LI,02  PSAY "C.U.S.P.P. : "   +  SRA->RA_CUSPP
@ LI,33  PSAY "-"
@ LI,39  PSAY "Tipo/Cat trab   : "  + Substr(cTpEmprega,1,15)
@ LI,87  PSAY "-"

@ LI,131  PSAY "|"

LI ++
@ LI,00  PSAY "|"
@ LI,02  PSAY  "Per. Vac.:"  + Substr(Dtos(dDataPerAd),7,2) + "/" + Substr(Dtos(dDataPerAd),5,2) + "/" + Substr(Dtos(dDataPerAd),1,4) + "-" + Substr(Dtos(dDataPerAt),7,2) + "/" + Substr(Dtos(dDataPerAt),5,2) + "/" + Substr(Dtos(dDataPerAt),1,4)
@ LI,33  PSAY "-"
@ LI,39  PSAY "Inicio Vac.: " + Substr(Dtos(dDataIniF),7,2) + "/" + Substr(Dtos(dDataIniF),5,2) + "/" + Substr(Dtos(dDataIniF),1,4)
@ LI,87  PSAY "-"
@ LI,90  PSAY "Fim Vac.   : " + Substr(Dtos(dDAtaFimF),7,2) + "/" + Substr(Dtos(dDAtaFimF),5,2) + "/" + Substr(Dtos(dDAtaFimF),1,4)
@ LI,131  PSAY "|"

LI ++
@ LI,00  PSAY "|"
@ LI,02  PSAY "Cod.  AFP: "   + AllTrim(SRA->RA_CODAFP)
@ LI,33  PSAY "-"
@ LI,39  PSAY "Desc. AFP: " +  cDescAfp
@ LI,87  PSAY "-"
@ LI,90  PSAY STR0169 +  AllTrim(STR(SRA->RA_HRSMES))		//"| Horas Mensais : "
@ LI,131  PSAY "|"

LI ++
@ LI,00  PSAY "|"
@ LI,02  PSAY "Dias Lab: "   + AllTrim(Str(nDiastb))
@ LI,33  PSAY "-"
@ LI,39  PSAY "Dias Subs: " + AllTrim(Str(nDiasAfs))
@ LI,87  PSAY "-"
@ LI,90  PSAY "Dias No Lab: "  + AllTrim(Str(nDiasAfas))
@ LI,131  PSAY "|"

LI ++
@ LI,00  PSAY "|"
@ LI,02  PSAY "N. Hrs Ord: "   + AllTrim(Str(nHorOrd))
@ LI,33  PSAY "-"
@ LI,39  PSAY "N. Hrs Ext: " + AllTrim(Str(nHorExt))
@ LI,87  PSAY "-"
@ LI,90  PSAY "Rem. Basica:  "  + AllTrim(Transform((SRA->RA_SALARIO), cPict1))
@ LI,131  PSAY "|"


LI ++
@ LI,00  PSAY "|"
@ LI,02  PSAY "Cod.Ubigeo:" + Space(1) + AllTrim(SRA->RA_CEP)
@ LI,33  PSAY "-"
@ LI,39  PSAY STR0069 + "  :" + Space(1) + cDescUbigeo
@ LI,131 PSAY "|"

LI ++
@ LI,00 PSAY STR0020 + SRA->RA_CC + Space(9) + " - "+ Space(4) + STR0069 + "  :" + Space(1) + DescCc(SRA->RA_CC,SRA->RA_FILIAL)	//"| C Custo   : " "Desc. CC.:
@ LI,131 PSAY "|"

LI++
@ LI,00  PSAY STR0026+cCodFunc + Space(12) + " - "+ Space(4) + STR0069 + "  :" + Space(1) + cDescFunc											//"| Funcao    : "
@ LI,131 PSAY "|"

LI ++
@ LI,00 PSAY "|"+REPLICATE("-",130)+"|"

LI ++
@ LI,000 PSAY STR0027		//"| P R O V E N T O S "
@ LI,044 PSAY STR0028		//"  D E S C O N T O S"
@ LI,088 PSAY STR0029		//"  B A S E S"
@ LI,131 PSAY "|"

LI ++
@ LI,00 PSAY "|"+REPLICATE("-",130)+"|"
LI++

Return Nil
*/
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fRDescUbig ºAutor  ³Alceu Pereira       º Data ³  09/02/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Exibir descricao do Ubigeo contido na tabela auxiliar para   º±±
±±º          ³localizacao Peru.                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico Localizacao Peru                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fRDescUbig()

Local nAux:= 1
Local cDescUbigeo := STR0020
Local aTabUbiGeo := {}

fCarrTab( @aTabUbiGeo, "S022", Nil)

IF ( len(aTabUbiGeo) >= 1 )
	nAux := 1
	While ( nAux <= len(aTabUbiGeo) )
		If ( aTabUbiGeo[nAux,1] == "S022" .And. aTabUbiGeo[nAux,5] == SubStr(SRA->RA_CEP,1,2) .And. aTabUbiGeo[nAux,6] == SubStr(SRA->RA_CEP,3,2) .And. aTabUbiGeo[nAux,7] == SubStr(SRA->RA_CEP,5,2) )
			cDescUbigeo := aTabUbiGeo[nAux,8]
			nAux := LEN(aTabUbiGeo)
		Endif
		nAux++
	End
Endif

Return cDescUbigeo
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fRTipoEmpreºAutor  ³Alceu Pereira       º Data ³  15/07/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Exibir descricao do tipo de empregado da tabela S029 para    º±±
±±º          ³localizacao Peru.                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico Localizacao Peru                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fRTipoEmp()

Local nAux:= 1
Local cTpEmprega := ""
Local aTabTipoEmp := {}

fCarrTab( @aTabTipoEmp, "S029", Nil)

IF ( len(aTabTipoEmp) >= 1 )
	nAux := 1
	While ( nAux <= len(aTabTipoEmp) )
		If ( aTabTipoEmp[nAux,1] == "S029" .And. aTabTipoEmp[nAux,5] == SRA->RA_TPFUNC )
			cTpEmprega := Trim(aTabTipoEmp[nAux,6])
			nAux := LEN(aTabTipoEmp)
		Endif
		nAux++
	End
Endif

Return cTpEmprega

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fRetFerFuncºAutor  ³Alceu Pereira       º Data ³  19/07/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retornar as datas de periodo aquisitivo, data inicio e data  º±±
±±º          ³fim das ferias de um funcionario.                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico Localizacao Peru                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fRetFerFunc(dDataPerAd, dDataPerAt ,dDataIniF , dDAtaFimF)

Local cFil   := SRA->RA_FILIAL
Local cMat   := SRA->RA_MAT
Local aArea	 := GetArea()

dbSelectArea("SRH")
DbSetOrder( 1 )
If dbSeek( cFil + cMat )
	While !Eof() .AND. SRH->RH_FILIAL == cFil .AND. SRH->RH_MAT == cMat
		If AllTrim(Str(Ano(SRH->RH_DATAINI))) == cAno .AND. SRH->RH_FILIAL == cFil .AND. SRH->RH_MAT == cMat
			dDataPerAd := SRH->RH_DATABAS
			dDataPerAt := SRH->RH_DBASEAT
			dDataIniF := SRH->RH_DATAINI
			dDAtaFimF := SRH->RH_DATAFIM
			Exit
		Endif
		dbSkip()
	EndDo
Endif
RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fRTipoEmpreºAutor  ³Alceu Pereira       º Data ³  19/07/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Exibir descricao do tipo de AFP da tabela S004 para          º±±
±±º          ³localizacao Peru.                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico Localizacao Peru                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fRDescAFP()

Local nAux:= 1
Local cDescAfp := ""
Local aTabDescAFP := {}

fCarrTab( @aTabDescAFP, "S004", Nil)

IF ( len(aTabDescAFP) >= 1 )
	nAux := 1
	While ( nAux <= len(aTabDescAFP) )
		If ( aTabDescAFP[nAux,1] == "S004" .And. aTabDescAFP[nAux,5] == SRA->RA_CODAFP )
			cDescAfp := Trim(aTabDescAFP[nAux,6])
			nAux := LEN(aTabDescAFP)
		Endif
		nAux++
	End
Endif

Return cDescAfp

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fAfasSub   ºAutor  ³Alceu Pereira       º Data ³  25/07/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna quantidade de dias de afastamentos subsidiados pela  º±±
±±º          ³empresa.                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico Localizacao Peru.                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fAfasSub(nDiasAfs)

Local cFil   := SRA->RA_FILIAL
Local cMat   := SRA->RA_MAT
Local aArea	 := GetArea()

dbSelectArea("SR8")
DbSetOrder( 1 )
If dbSeek( cFil + cMat )
	While !Eof() .AND. SR8->R8_FILIAL == cFil .AND. SR8->R8_MAT == cMat
		If cMes >= StrZero(Month(SR8->R8_DATAINI),2) .AND. cMes <= StrZero(Month(SR8->R8_DATAFIM),2) .AND. cAno = StrZero(Year(SR8->R8_DATAFIM),4)
			If SR8->R8_DPAGAR > 0
				nDiasAfs := nDiasAfs + SR8->R8_DPAGAR
			Endif
		Endif
		dbSkip()
	EndDo
Endif
RestArea(aArea)

Return nDiasAfs

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fHorasFunc ºAutor  ³Alceu Pereira       º Data ³  25/07/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna quantidade de horas trabalhadas ou quantidade de     º±±
±±º          ³horas extras feitas pelo funcionario.                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico Localizacao Peru.                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fHorasFunc(lHorasExtras, nQuantHoras, Semana)

Local aArea	        := GetArea()
Local cChaveSem     := ""
Local aVerbasLIQ    := {}
Local nAux			:= 0
Local aPerAberto    := {}
Local aPerFechado   := {}
Local aPerTodos     := {}

If lHorasExtras == .T.
	
	fRetPerComp( 	cMes		  ,;	// Obrigatorio - Mes para localizar as informacoes
	cAno		  ,;	// Obrigatorio - Ano para localizar as informacoes
	xFilial("RCH"),;	// Opcional - Filial a Pesquisar
	,;		// Opcional - Filtro por Processo
	,;		// Opcional - Filtro por Roteiro
	@aPerAberto	  ,;	// Por Referencia - Array com os periodos Abertos
	@aPerFechado, ;		// Por Referencia - Array com os periodos Fechados
	@aPerTodos    ;		// Por Referencia - Array com os periodos Abertos e Fechados em Ordem Crescente
	)
Endif

nQuantHoras := 0

cChaveSem := StrZero(Year(dDataRef),4)+StrZero(Month(dDataRef),2)

dbSelectArea( "RCF" )
DbSetOrder( 1 )

If RCF->( dbSeek( xFilial("RCF") + cChaveSem,.T.)) .AND. lHorasExtras == .F.
	nQuantHoras := RCF->RCF_HRSTRA + RCF->RCF_HRSDSR
Else
	aVerbasLIQ := RetornaVerbasFunc(SRA->RA_FILIAL, SRA->RA_MAT, ,fGetCalcRot("1"), , aPerAberto, aPerFechado )
	For nAux:= 1 to len(aVerbasLIQ)
		If (PosSrv(aVerbasLIQ[nAux,3], SRA->RA_FILIAL, "RV_HE")) == "S"
			If PosSrv( aVerbasLIQ[nAux,3], SRA->RA_FILIAL, "RV_TIPOCOD" ) $ "1*3"
				nQuantHoras += aVerbasLIQ[nAux,6]
			Elseif PosSrv( aVerbasLIQ[nAux,3], SRA->RA_FILIAL, "RV_TIPOCOD" ) $ "2*4"
				nQuantHoras -= aVerbasLIQ[nAux,6]
			Endif
		Endif
	Next
Endif

RestArea (aArea)

Return nQuantHoras




/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Calculo de descripcion de documento para registro de empleado³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ENDDOC*/


                               



/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ@¿
//³Funcion calculo de fechas de Vacaciones del Empleado³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ@Ù
ENDDOC*/


Static Function fSRF(cMAT,CADMISSA)

Local cDatas := ""
Local TRB6		 := GetNextAlias()
Local cQuery6    := ""
Local cDta       := substr(cPeriodo,1,4) + substr(CADMISSA,5,4)

//-->Query para sacar la informacion de fechas de vacaciones
cQuery6 := "SELECT RF_FILIAL, RF_MAT, RF_DATABAS, RF_DATAFIM "
cQuery6 += " FROM " + "SRF" +Alltrim(SM0->M0_CODIGO)+"0" +" SRF "
cQuery6 += "WHERE RF_MAT = '" + cMAT + "' "
cQuery6 += "AND RF_DATAFIM <= '" + cDta + "' "
cQuery6 += "AND SRF.D_E_L_E_T_ = ' ' "
cQuery6 += "Order By RF_MAT,RF_DATABAS "
cQuery6 := ChangeQuery(cQuery6)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery6),TRB6,.F.,.T.)

DbSelectArea(TRB6)

While !(TRB6)->(Eof())
	
	cDatas := dtoc(stod((TRB6)->RF_DATABAS)) + "-" + dtoc(stod((TRB6)->RF_DATAFIM))
	
	(TRB6)->(dbSkip())
EndDo

(TRB6)->(DBCLOSEAREA())

Return cDatas  



/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Funcion para calcular el saldo de conceptos de prestamo estatus 2 en la SRK³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ENDDOC*/

Static Function fSRK(cMAT)

Local cDatas := ""
Local TRB6		 := GetNextAlias()
Local TRB7		 := GetNextAlias()
Local cQuery6    := ""
Local cQuery7    := ""
Local cPros      := cProcesso
Local cPer       := cPeriodo
Local cRot       := cRoteiro
Local cSem       := mv_par04
Local aPres      := {}
Local nToPre     := 0
Local nQ 		 := 0

//-->Query para sacar la informacion de prestamos
cQuery6 := "SELECT RK_FILIAL, RK_MAT, RK_PD, RK_PROCES, RK_STATUS, RK_VLSALDO,RK_NUMID"
cQuery6 += " FROM " + "SRK" +Alltrim(SM0->M0_CODIGO)+"0" +" SRK "
cQuery6 += "WHERE RK_MAT = '" + cMAT + "' "
cQuery6 += "AND RK_PROCES = '" + cPros + "' "
cQuery6 += "AND RK_STATUS = '2' "
cQuery6 += "AND SRK.D_E_L_E_T_ = ' ' "
cQuery6 += "Order By RK_MAT,RK_PD "
cQuery6 := ChangeQuery(cQuery6)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery6),TRB6,.F.,.T.)

DbSelectArea(TRB6)
While !(TRB6)->(Eof())
	aAdd(aPres,{(TRB6)->RK_MAT,(TRB6)->RK_PD,(TRB6)->RK_NUMID,(TRB6)->RK_PROCES,(TRB6)->RK_STATUS,(TRB6)->RK_VLSALDO,0,0})
	(TRB6)->(dbSkip())
EndDo

(TRB6)->(DBCLOSEAREA())

If Len(aPres) > 0
	
	nToPre := 0
	
	For nQ:=1 to Len(aPres)
		
		nToPre +=  (aPres[nQ,6])
		
		//-->Query para sacar la informacion de fechas de vacaciones
		cQuery7 := "SELECT RC_FILIAL, RC_MAT, RC_PD, RC_VALOR, RC_NUMID"
		cQuery7 += " FROM " + "SRC" +Alltrim(SM0->M0_CODIGO)+"0" +" SRC "
		cQuery7 += "WHERE RC_MAT = '" + cMAT + "' "
		cQuery7 += "AND RC_PROCES = '" + cPros + "' "
		cQuery7 += "AND RC_ROTEIR = '" + cRot + "' "
		cQuery7 += "AND RC_PERIODO = '" + cPer + "' "
		cQuery7 += "AND RC_SEMANA = '" + cSem + "' "
		cQuery7 += "AND RC_NUMID = '" + aPres[nQ,3] + "'  "
		cQuery7 += "AND SRC.D_E_L_E_T_ = ' ' "
		cQuery7 += "Order By RC_MAT,RC_PD "
		cQuery7 := ChangeQuery(cQuery7)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery7),TRB7,.F.,.T.)
		
		DbSelectArea(TRB7)
		While !(TRB7)->(Eof())
			nToPre -= (TRB7)->RC_VALOR
			(TRB7)->(dbSkip())
		EndDo
		
		(TRB7)->(DBCLOSEAREA())
		
	Next nQ
Endif
Return nToPre

Static Function fLoadLogo(cNomeArq)

	Local cStartPath := GetSrvProfString("Startpath","") 

	If Substr(cStartPath, Len(cStartPath), 1) == "\"
		cImagem := cStartPath + cNomeArq        
	Else
		cImagem := cStartPath + "\" + cNomeArq    
	Endif

Return cImagem

