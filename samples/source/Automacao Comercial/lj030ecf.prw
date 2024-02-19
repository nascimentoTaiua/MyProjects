#INCLUDE "LJ030ECF.CH"
#INCLUDE "AUTODEF.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Lj030ECF  ºAutor  ³Andre Alves Veiga   º Data ³  26/09/00   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Impressao do resumo de caixa na impressora fiscal           º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Lj030ECF()

Local aCaixa 		:= {}                                           // Array com os valores do Caixa
Local cString 		:= ''											// String que sera impressa
Local nTroco        := 0                                            // Variavel que armazena o Troco
Local nTotCredito   := 0                                            // Total de Credito
Local nTotDebito    := 0                                            // Total de Debito
Local nRet 			:= 0                                            // Retorno da impressora 
Local lAberto                                                       // Se o Caixa esta aberto
Local cCaixa 		:= MV_PAR03                                     // Caixa do Resumo
Local dDataMovto 	:= MV_PAR01                                     // Data da Movimentacao
Local nI 			:= 0										    // Contador 
Local nSaldFinal	:= 0       										// Valor com o Saldo Final
Local aContFina 	:= {0,0,0,0,0,0,0,0,0,0,0,0}					// Contadores utilizados nos tipos de finalizações
Local aSinal  		:= {"+", "+", "+", "+", "+", "", "+", "+", "+", "+", "+" , "+"}	// Array com as sinais realizados
Local nVlrCred	    := 0											// Valor do Credito 
Local aDDown		:= {}											// Array com o segundo nivel das opcoes 
Local nEstac		:= 0                                           	// Valor referente ao estacionamento (restaurante) 
Local nGorjeta		:= 0											// Valor referente a gorjeta (restaurante)
Local aDadosVen		:= {}                                          	// Array com os dados das vendas
Local aDadosSan		:= {}											// Array com os dados da sangria 
Local nOpcao		:= 0											// Define qual elemento do ListBox recebeu o DbClick 
Local nTrocoSaida   := 0											// Somatoria dos trocos de saida						
Local lUsaNMov      := .F.											// Verifica se foi criado MV_PAR09
Local lMV_LJTROCO   := SuperGetMV("MV_LJTROCO", ,.F.)				// Determina se utiliza troco para diferentes formas de Pagamento
Local aArea 		:= GetArea()
Local aAreaSA6 		:= SA6->(GetArea())
Local aPrinter		:= {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pergunta que define o numero do movimento - (Somente se houver a tabela SLW)																  |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If AliasIndic("SLW")
	lUsaNMov := .T.
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Carrega array com valores totais do caixa em uma data          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCaixa := MovimCaixa( cCaixa	 , dDataMovto	, lMV_LJTROCO, NIL 		,;
					  NIL		 , NIL    		, NIL   	, lUsaNmov  ,  NIL )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Alimenta Totalizadores / Arrays aDados...  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Lj030Dados(	aCaixa	,	nOpcao		, 	NIL			,	@nTrocoSaida,;	
			@nTroco	,	@nTotCredito, @nTotDebito	,	@nSaldFinal	,;
			nEstac	,	nGorjeta	, @aDadosVen	,	aSinal		,;
			@aDDown	, 	aContFina	, @aDadosSan	,	nVlrCred	,)

DbSelectArea("SA6")
SA6->(DbSetOrder(1))
SA6->(DbSeek( xFilial("SA6")+xNumCaixa()) )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta o relatório gerencial                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cString := chr(10) + chr(10) + Repl('-',40) + chr(10)
cString += Space((40-Len(STR0001))/2) + STR0001 + chr(10) //"RESUMO DE CAIXA"###"RESUMO DE CAIXA"
cString += Repl('-',40) + chr(10)
cString += STR0002 + SA6->A6_COD+"-"+SA6->A6_NOME + chr(10)  //"Codigo do Caixa: "
cString += STR0003 + Dtoc(dDataMovto)	+ chr(10) //"Data Movimento: "
cString += Repl('-',40) + chr(10)
cString += Subst(STR0004 + Space(26),1,26) + Trans(nTroco,'@E 999,999,999.99') + chr(10) //"Saldo Inicial: "
If lMV_LJTROCO
	cString += Subst(STR0005 + Space(26),1,26) + Trans(nTrocoSaida,'@E 999,999,999.99') + chr(10) //"Troco Saida: "
Endif
cString += Repl('-',40) + chr(10)

cString += Subst(STR0006 + Space(26),1,26) + Trans(nTotCredito,'@E 999,999,999.99')	+ chr(10) //"Credito/Vendas"
For nI :=1 to len(aDadosVen)
	lAberto := (Left(aDadosVen[nI][1],1)=="-" .and. aDadosVen[nI][2] # 0)
	cString += padr(aDadosVen[nI][1]+" ",26,IIf(lAberto,"",".")) +;
	IIf(lAberto,"",Trans(aDadosVen[nI][2],'@E 999,999,999.99')) + Chr(10)
Next
cString += Repl('-',40) + chr(10) + chr(10)

cString += Subst(STR0007 + Space(26),1,26) + Trans(nTotDebito,'@E 999,999,999.99') + chr(10) //"Debitos/Sangrias"
For nI :=1 to len(aDadosSan)
	cString += padr(aDadosSan[nI][1]+" ",26,".") + Trans(aDadosSan[nI][2],'@E 999,999,999.99') + chr(10)
Next
cString += Repl('-',40) + chr(10) + chr(10)
cString += Subst(STR0008 + Space(26),1,26) + Trans(nSaldFinal,'@E 999,999,999.99') + chr(10) //"SALDO FINAL"
cString += Repl('-',40) + chr(10)

cString += Replicate(Chr(13)+Chr(10),6) + TAG_GUIL_INI+TAG_GUIL_FIM  //Corta Papel (Guilhotina)

/*Envia o relatório para a impressora*/
If ExistFunc("STFIsPOS") .And. STFIsPOS()	//indica se eh TOTVS PDV
	aPrinter :=	STFFireEvent(	ProcName(0) 		,;	// Nome do processo
							"STManagReportPrint",;	// Nome do evento
							{cString, 1} )
	nRet := aPrinter[1]
Else
	nRet := IFRelGer(nHdlECF,cString,1)
Endif

If nRet <> 0
	MsgStop(STR0009) //"Problemas com a Impressora Fiscal"
Endif

RestArea(aAreaSA6)
RestArea(aArea)

Return
