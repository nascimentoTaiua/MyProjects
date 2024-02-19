#INCLUDE "RWMAKE.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡ao   ³ SCRRPS      ³ Autor ³ Vendas CLientes    ³ Data ³05/04/2012³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡ao³ Monta o texto a ser impresso no comprovante de venda       ³±±
±±³          ³ (nao fiscal) no caso de venda com itens de servico (RPS -  ³±±
±±³          ³ Recibo Provisorio de Servico).                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Retorno  ³ Texto a ser impresso                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Sigaloja                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/  
User Function SCRRPS()
Local aDadosRPS 	:= PARAMIXB
Local cOrcam		:= ""
Local sTexto   		:= ""                      
Local nDinheir		:= 0
Local nCheques		:= 0
Local nCartaoC		:= 0
Local nCartaoD		:= 0
Local nConveni		:= 0
Local nVales		:= 0
Local nFinanc		:= 0
Local nCredito		:= 0
Local nOutros		:= 0
Local nAbtoPCC		:= 0
Local nAbtoISS		:= 0
Local cQuant 		:= ""
Local cVrUnit		:= ""
Local cDesconto		:= ""
Local cVlrItem		:= ""
Local nVlrIcmsRet	:= 0				// Valor do icms retido (Substituicao tributaria)
Local aFilCodMun 	:= {{"",""},{"",""}}
Local lRPSOK 		:= .F.
Local cNumRPS		:= ""
Local cSerRPS		:= ""
Local lL2ICMSRET 	:= SL2->(FieldPos("L2_ICMSRET")) > 0
Local nValTot		:= 0
Local nDescTot		:= 0
Local nTotDesc		:= 0
Local nVlrDescIt	:= 0
Local nFatorRPS		:= 1
Local nValPag		:= 0
Local lMvArrefat    := SuperGetMv("MV_ARREFAT") == "S"
Local nVlrTot       := 0                                // Valor Total
Local nVlrFSD       := 0                                // Valor do frete + seguro + despesas

If FindClass("FWSM0Util") //Proteção, para ambiente com RPO Ctree essa função não existe
	aFilCodMun	:= FWSM0Util():GetSM0Data( cEmpAnt, cFilAnt , { "M0_CODMUN","M0_CIDCOB" } )
EndIf

lRPSOK		:= aDadosRPS[01] 		//Indica se trouxe a série do RPS
If Len(aDadosRPS[02]) > 0
	cNumRPS	:= aDadosRPS[02][01]	//Número do RPS
	cSerRPS	:= aDadosRPS[02][02]	//Série do RPS
EndIf
nFatorRPS 	:= aDadosRPS[03]		//Fator de Cálculo (proporcional da venda) referente aos itens de serviço (RPS)

sTexto := sTexto + '==============================================='	+Chr(13)+Chr(10)
sTexto := sTexto + '      RECIBO PROVISORIO DE SERVICOS (RPS)      '	+Chr(13)+Chr(10)
sTexto := sTexto + '==============================================='	+Chr(13)+Chr(10)

// Tratativa municipio Aquiraz - CE
IF lRPSOK .AND. ( (!Empty(aFilCodMun[1][2]) .AND. AllTrim(aFilCodMun[1][2]) == "2301000") .OR.;
	!Empty(aFilCodMun[2][2]) .AND. Upper(AllTrim(aFilCodMun[2][2])) == "AQUIRAZ" )
	sTexto := sTexto + 'Numero RPS                    ' + AllTrim(cNumRPS)	+Chr(13)+Chr(10)
	sTexto := sTexto + '-----------------------------------------------'	+Chr(13)+Chr(10)
EndIf

sTexto:= sTexto+ 'Codigo         Descricao'+Chr(13)+Chr(10)
sTexto:= sTexto+ 'Qtd             VlrUnit                 VlrTot'+Chr(13)+Chr(10)
sTexto:= sTexto+'-----------------------------------------------'+Chr(13)+Chr(10)
cOrcam		:= SL1->L1_NUM
nDinheir	:= (nFatorRPS * SL1->L1_DINHEIR)
nCheques	:= (nFatorRPS * SL1->L1_CHEQUES)
nCartaoC 	:= (nFatorRPS * SL1->L1_CARTAO)
nCartaoD 	:= (nFatorRPS * SL1->L1_VLRDEBI)
nConveni	:= (nFatorRPS * SL1->L1_CONVENI)
nVales  	:= (nFatorRPS * SL1->L1_VALES)
nFinanc		:= (nFatorRPS * SL1->L1_FINANC)
nCredito	:= (nFatorRPS * SL1->L1_CREDITO)
nOutros		:= (nFatorRPS * SL1->L1_OUTROS)
nAbtoPCC	:= (nFatorRPS * SL1->L1_ABTOPCC)
nAbtoISS	:= RetAbatIss()	//Abatimento de ISS

/* Soma o valor de todas as formas de pagamento
Necessariio dar um round em cada forma para verificar se ha diferença de arredondamento no somatorio dos pagamentos*/
nValPag :=	Round(nDinheir,2)	+	Round(nCheques,2)	+	Round(nCartaoC,2)	+	Round(nCartaoD,2)	+;
			Round(nConveni,2)	+	Round(nVales,2)	+	Round(nCredito,2)	+	Round(nFinanc,2)	+;
			Round(nOutros,2)
           
dbSelectArea("SL2")
dbSetOrder(1)  
dbSeek(xFilial("SL2") + cOrcam)
	
While !SL2->(Eof()) .AND. SL2->L2_FILIAL + SL2->L2_NUM == cFilAnt + cOrcam
	
	//Verifica se é item de servico (ISS)
	If LjIsItISS()

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Faz o tratamento do valor do ICMS ret.                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lL2ICMSRET 
			nVlrIcmsRet	:= SL2->L2_ICMSRET
		Endif

		cQuant 		:= StrZero(SL2->L2_QUANT, 8, 3)
		cVrUnit		:= Str(((SL2->L2_QUANT * SL2->L2_PRCTAB) + SL2->L2_VALIPI + nVlrIcmsRet) / SL2->L2_QUANT, 15, 2)
		
		nVlrDescIt 	+= SL2->L2_VALDESC //Valor de desconto no item
		nTotDesc   	+= SL2->L2_DESCPRO //Valor de desconto Total (Proporcional)
		cVlrItem 	:= Str(Val(cVrUnit) * SL2->L2_QUANT, 15, 2)

		sTexto		:= sTexto + SL2->L2_PRODUTO + SL2->L2_DESCRI + Chr(13) + Chr(10)
		sTexto		:= sTexto + cQuant + '  ' + cVrUnit + '      ' + cVlrItem + Chr(13) + Chr(10)
		If SL2->L2_VALDESC > 0 
			sTexto	:= sTexto + 'Desconto no Item:              ' + Str(SL2->L2_VALDESC, 15, 2) + Chr(13) + Chr(10)
		EndIf

		nValTot  += Val(cVlrItem)

	EndIf
	SL2->(DbSkip())
Enddo

cDesconto	:= Str(nVlrDescIt, TamSx3("L2_VALDESC")[1], TamSx3("L2_VALDESC")[2])
nVlrFSD		:= SL1->L1_FRETE + SL1->L1_SEGURO + SL1->L1_DESPESA

If SL1->L1_DESCONTO > 0
	nDescTot	:= nTotDesc
	sTexto	:= sTexto + 'Desconto no Total:             ' + Str(nDescTot, 15, 2) + Chr(13) + Chr(10)
EndIf

//Armazena Valor Total
nVlrTot := nValTot - nDescTot - nVlrDescIt
nVlrTot := IIf(lMvArrefat, Round(nVlrTot,TamSX3("D2_TOTAL")[2]), NoRound(nVlrTot,TamSX3("D2_TOTAL")[2]))

sTexto	:= sTexto + '-----------------------------------------------' + Chr(13) + Chr(10)
sTexto	:= sTexto + 'TOTAL                          ' + Str(nVlrTot, 15, 2) + Chr(13) + Chr(10)

If nDinheir > 0 
	sTexto := sTexto + 'DINHEIRO' + '                       ' + Str(nDinheir, 15, 2) + Chr(13) + Chr(10)
EndIf
If nCheques > 0 
	sTexto := sTexto + 'CHEQUE' + '                         ' + Str(nCheques, 15, 2) + Chr(13) + Chr(10)
EndIf
If nCartaoC > 0 
	sTexto := sTexto + 'CARTAO CRED' + '                    ' + Str(nCartaoC, 15, 2) + Chr(13) + Chr(10)
EndIf
If nCartaoD > 0 
	sTexto := sTexto + 'CARTAO DEB' + '                      ' + Str(nCartaoD, 15, 2) + ' (+)' + Chr(13) + Chr(10)
EndIf
If nConveni > 0 
	sTexto := sTexto + 'CONVENIO' + '                        ' + Str(nConveni, 15, 2) + Chr(13) + Chr(10)
EndIf
If nVales > 0 
	sTexto := sTexto + 'VALES' + '                           ' + Str(nVales, 15, 2) + Chr(13) + Chr(10)
EndIf
If nFinanc > 0 
	sTexto := sTexto + 'FINANCIADO' + '                      ' + Str(nFinanc, 15, 2) + Chr(13) + Chr(10)
EndIf  
If nCredito > 0
	sTexto := sTexto + 'CREDITO ' + '                       ' + Str(nCredito, 15, 2) + Chr(13) + Chr(10)
EndIf			
If nAbtoPCC > 0
	sTexto := sTexto + 'RETENCAO PCC'	+ '                   ' + Str(nAbtoPCC, 15, 2) + Chr(13) + Chr(10)
EndIf
If nAbtoISS > 0
	sTexto := sTexto + 'RETENCAO ISS'	+ '                   ' + Str(nAbtoISS, 15, 2) + Chr(13) + Chr(10)
EndIf

sTexto := sTexto + '-----------------------------------------------' + Chr(13) + Chr(10)

Return sTexto

//-------------------------------------------------------------------
/*/{Protheus.doc} RetAbatIss
Retorna o valor de ISS que deve ser abatido do valor total da venda.

@type    Static Function
@author	 Varejo
@since	 03/02/2022
@version P12

@return Numérico, Valor de ISS que deve ser abatido do valor total da venda.
/*/
//-------------------------------------------------------------------
Static Function RetAbatIss()
Local nRet 			:= 0
Local lMvDescISS 	:= SuperGetMV("MV_DESCISS",,.F.)	//Indica se há desconto do ISS no financeiro
Local nMinRetISS  	:= SuperGetMv("MV_VRETISS",.F.,0) 	//Valor minimo para dispensa de retencao de ISS

//Faz a verificação se o valor do ISS deve ser abatido no valor total da venda
If lMvDescISS .And. SL1->L1_VALISS > 0 .And. SL1->L1_RECISS == "1" .And. SA1->A1_RECISS == "1"
	If SA1->A1_FRETISS == "1" //Forma de retencao de ISS (1=Cons Vlr Minimo; 2=Sempre Retem) 
		//Verifica se o valor total do ISS eh maior que o valor minimo para dispensa de retencao de ISS
		If nMinRetISS > 0
			If SL1->L1_VALISS > nMinRetISS
				nRet := SL1->L1_VALISS // Valor do abatimento do ISS
			EndIf
		Else
			nRet := SL1->L1_VALISS // Valor do abatimento do ISS
		EndIf
	Else
		nRet := SL1->L1_VALISS // Valor do abatimento do ISS
	EndIf
EndIf

Return nRet

//-------------------------------------------------------------------
/*/{Protheus.doc} LjIsItISS
Verifica é um item de Servico (ISS)

@type    Static Function
@author	 Varejo
@since	 02/08/2022
@version P12

@return Lógico, Retorna se é um item de Servico (ISS)
/*/
//-------------------------------------------------------------------
Static Function LjIsItISS()
Local lRet 		:= .F.

If SL2->L2_VALISS > 0
	//Se for Totvs PDV e Usa ECF ou se é PAF-ECF, só considera item de servico via importação de orçamento
	If (nModulo == 23 .And. STFGetCfg("lUseECF")) .Or. ;
		STBIsPAF()		//Verifica se é ambiente PAF-ECF								
		lRet := !Empty(SL2->L2_NUMORIG)
	Else
		lRet := .T.
	EndIf
EndIf

Return lRet
