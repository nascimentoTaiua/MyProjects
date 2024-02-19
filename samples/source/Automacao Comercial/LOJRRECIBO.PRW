#include 'protheus.ch'
#include 'parmtype.ch'

Static nColMax	:= 2400	// Numero maximo de Colunas
//Posições de colunas dos campos
// *IMPORTANTE* : Ao mudar o valor da coluna, favor TESTAR a IMPRESSÃO do relatório
//pois o PREVIEW é diferente da IMPRESSÃO. */
Static nColDoc	:= 0050
Static nColTipo	:= 0260
Static nColEmis	:= 0340
Static nColVenc	:= 0520
Static nColVlrOrg	:= 0720
Static nColSaldo	:= 1070
Static nColAcres	:= 1400
Static nColMulta	:= 1650
Static nColDesc	:= 1900
Static nColVlrFin	:= 2100

//----------------------------------------------------------
/*/{Protheus.doc} LOJRRecibo
Relatorio para impressao do recebimento de titulos.

@type		User function
@author	Varejo
@version	P11.8
@since		20/06/2016

@param		cCodCli - Codigo do cliente que possui os titulos.
			cNomeCli - Nome do cliente.
			aTitBx - Informações dos titulos baixados.
			aFormPg - Informações das formas de pagamento utilizadas.
			aTitNeg - Títulos que foram renegociados e baixados para serem impressos no recibo
			cE5HISTOR - Historico da baixa (SE5)
			cE5SEQ - Sequencia da baixa (SE5)
			cE5DATA - data da baixa (SE5)
			cE5TIPODOC - Tipo do documento da baixa (SE5)
			cE5MOTBX - Motivo de baixa (SE5)
			cE5NUMERO - Numero do baixa (SE5)
			cE5PARCELA - Parcela da baixa (SE5)
			cE5CLIFOR - Cliente da baixa (SE5)
			cE5LOJA - loja do cliente da baixa (SE5) 
@return lRet
/*/
//----------------------------------------------------------
User Function LOJRRecibo(	cCodCli	,cNomeCli	,aTitBx	,aFormPg		,;
								aTitNeg	,cE5HISTOR	,cE5SEQ	,cE5DATA		,;
								cE5TIPODOC	,cE5MOTBX	,cE5NUMERO	,cE5PARCELA	,;
								cE5CLIFOR	,cE5LOJA	)

Local cPerg			:= "LOJRREC"	//Grupo de perguntas do relatorio
Local cTitulo			:= "RECIBO"	//Titulo do Recibo
Local oPrint							//Objeto  de impressao
Local aSA1Area		:= {}
Local aSE1Area		:= {}
Local aSEFArea		:= {}
Local aArea			:= {}  
Local lRet          := .T.

DEFAULT cCodCli		:= ""	//Codigo do Cliente que será impresso no Recibo 
DEFAULT cNomeCli		:= ""	//Nome do cliente que será impresso no Recibo 
DEFAULT aTitBx		:= {}	//Array contendo os títulos que foram baixados para serem impressos no recibo
DEFAULT aFormPg		:= {}	//Array contendo as formas de pgamentos e valores que foram utilizadas para baixar os titulos e que serão impressas no recibo. 
DEFAULT aTitNeg		:= {}	//Array contendo os títulos que foram renegociados e baixados para serem impressos no recibo
DEFAULT cE5HISTOR		:= ""
DEFAULT cE5SEQ		:= ""
DEFAULT cE5DATA		:= ""
DEFAULT cE5TIPODOC	:= ""
DEFAULT cE5MOTBX		:= ""
DEFAULT cE5NUMERO		:= ""
DEFAULT cE5PARCELA	:= ""
DEFAULT cE5CLIFOR		:= ""
DEFAULT cE5LOJA		:= ""

/*	
aadd(aTitBx	,{"000001","C01","000003","01","20160625","20160725",2000,500,10,5,3,1500})
aadd(aTitBx	,{"000002","C01","000003","01","20160625","20160725",1000,100,10,5,3, 900})
aadd(aTitBx	,{"000003","C01","000003","01","20160625","20160725",1000,500,10,5,3,1000})
aadd(aTitBx	,{"000004","C01","000003","01","20160625","20160725",1000,500,10,5,3,1000})

aadd(aFormPg	,{"R$",2000,"20160625","","","","",""} )
aadd(aFormPg	,{"CC",1000,"20160625","","","","",""} )
aadd(aFormPg	,{"CH",1000,"20160625","000001","341","4158","2020044-5","MARCOS"} )
aadd(aFormPg	,{"CH",1000,"20160626","000002","341","4158","2020044-5","MARCOS"} )
*/

If Len(aTitBx) > 0
	aArea		:= GetArea()
	aSA1Area	:= SA1->(GetArea())
	aSE1Area	:= SE1->(GetArea())
	aSEFArea	:= SEF->(GetArea())

		oPrint 	:= FWMSPrinter():New(cTitulo,6,.T., ,.T., , , , ,.T.,  , .T.  )
		oPrint:SetPortrait()
		oPrint:Setup()
        
        If ValType(oPrint:NMODALRESULT) <> NIL .AND. oPrint:NMODALRESULT == 1		
            MsgRun("Aguarde... Gerando recibo...",,{|| CursorWait(), RECPROC(oPrint,cTitulo,cCodCli, cNomeCli, aTitBx, aFormPg, aTitNeg , cE5HISTOR , cE5SEQ , cE5DATA, cE5TIPODOC, cE5MOTBX, cE5NUMERO, cE5PARCELA, cE5CLIFOR , cE5LOJA ) ,CursorArrow()}) 
            oPrint:Preview()
        Else
            oPrint:Cancel() //Cancela impressao 
        EndIf
	
	RestArea(aSA1Area)
	RestArea(aSE1Area)
	RestArea(aSEFArea)
	RestArea(aArea)
Endif

Return

//----------------------------------------------------------
/*/{Protheus.doc} RECPROC
Processa a configuração e montagem do relatorio para impressão.

@type		Static Function
@author	Varejo
@version	P11.8
@since		20/06/2016
@param		oPrint - Objeto de impresão
			cTitulo - Titulo da impressão
			cCodCli - Codigo do cliente que possui os titulos.
			cNomeCli - Nome do cliente.
			aTitBx - Informações dos titulos baixados.
			aFormPg - Informações das formas de pagamento utilizadas.
			aTitNeg - Títulos que foram renegociados e baixados para serem impressos no recibo
			cE5HISTOR - Historico da baixa (SE5)
			cE5SEQ - Sequencia da baixa (SE5)
			cE5DATA - data da baixa (SE5)
			cE5TIPODOC - Tipo do documento da baixa (SE5)
			cE5MOTBX - Motivo de baixa (SE5)
			cE5NUMERO - Numero do baixa (SE5)
			cE5PARCELA - Parcela da baixa (SE5)
			cE5CLIFOR - Cliente da baixa (SE5)
			cE5LOJA - loja do cliente da baixa (SE5) 
@return	Nil
/*/
//----------------------------------------------------------
Static function RECPROC(	oPrint		, cTitulo		, cCodCli		, cNomeCli		,;
							aTitBx		, aFormPg		, aTitNeg		, cE5HISTOR	,;
							cE5SEQ		, cE5DATA		, cE5TIPODOC	, cE5MOTBX		,;
							cE5NUMERO	, cE5PARCELA	, cE5CLIFOR	, cE5LOJA		)
Local aArea				:= GetArea()
Local Li          		:= 0
Local nPag        		:= 0
Local cMensChq			:= ""
Local oFtGrande			:= TFont():New("Arial",09,12,,.T.,,,,.T.,.F.)
Local oFtMedia 			:= TFont():New("Arial",09,10,,.F.,,,,.T.,.F.)
Local oFtMediaNeg			:= TFont():New("Arial",09,10,,.T.,,,,.T.,.F.)
Local oFtMsg				:= TFont():New("Arial",09,9.5,,.T.,,,,.T.,.F.)
Local oFtItem2 			:= TFont():New("Tahoma",09,09,,.T.,,,,.T.,.F.)
Local nX					:= 0
Local nTotal	 			:= 0
Local nRtot 				:= 0
Local nSalDev 			:= 0
Local nTReg 				:= 0                     
Local lImpCab				:= .T.
Local nTotVlCruz			:= 0
Local cAliasSE1			:= GetNextAlias()
Local cAliasSE5			:= GetNextAlias()
Local lLiquida			:= .T.
Local lAcrescimo			:= Len(aTitBx[1]) > 14
Local cData				:= ""
Local nAcrescimo			:= 0
Local cMasc				:= "@E 999,999,999,999.99"
Local cMaskDesc			:= PesqPict("SE1","E1_DESCONT")
Local cMaskMulta			:= PesqPict("SE1","E1_MULTA")
Local cMaskValor			:= PesqPict("SE1","E1_VALOR")
Local cMaskAcres			:= PesqPict("SE1","E1_ACRESC")
Local aAreaSEF			:= GetArea()
Local nLinhasPag			:= 2932  			// Quantidade de linhas de folha Retrato 
Local nLinTotais			:= 1128				// Quantidade de linhas utilzadas para impressão dos Totais

If Len(aFormPg) > 0
	lLiquida := .F.
Endif

//Busca o Total Recebido
aEval(aTitBx,{|x| nTotal += x[14]})

For nX := 1 to len(aTitBx)

	cTitulo	:= Padr(Alltrim(aTitBx[nX][01]),TamSX3("E1_NUM")[1]) 
	cPrefixo	:= Padr(Alltrim(aTitBx[nX][02]),TamSX3("E1_PREFIXO")[1])
	cParcela	:= Padr(Alltrim(aTitBx[nX][03]),TamSX3("E1_PARCELA")[1])
	cTipo		:= Padr(Alltrim(aTitBx[nX][04]),TamSX3("E1_TIPO")[1])
	cCliente	:= Padr(Alltrim(aTitBx[nX][05]),TamSX3("E1_CLIENTE")[1])  
	cLoja		:= Padr(Alltrim(aTitBx[nX][06]),TamSX3("E1_LOJA")[1]) 

	If lImpCab	
		oPrint:StartPage()
		RECabec(	oPrint		,@Li			,@nPag			,cTitulo		,;
					cCliente	,cLoja			,nTotal		,lAcrescimo	,;
					cPrefixo	,cParcela		,cTipo			,cE5HISTOR		,;
					cE5SEQ		,cE5DATA		,cE5TIPODOC	,cE5MOTBX		,;
					cE5NUMERO	,cE5PARCELA	,cE5CLIFOR		,cE5LOJA		)
		Li += 48
		oPrint:Box(Li,020,Li,nColMax)
		lImpCab := .F.
	Endif

	nTReg := nTReg + 1 
	nCount := Li

	Li += 48

	DbSelectArea("SE1")
	SE1->(DbSetOrder(1))
	If SE1->(DbSeek(xFilial("SE1") + cPrefixo + cTitulo + cParcela + cTipo))
		aTitBx[nX][09] := SE1->E1_VLCRUZ
	Endif

	//Documento
	oPrint:Say(Li+15 ,nColDoc		,aTitBx[nX][01]														, oFtItem2 )

	//Tipo
	oPrint:Say(Li+15 ,nColTipo		,aTitBx[nX][02]														, oFtItem2 )
	If ValType(aTitBx[nX][07]) == 'D'
    	cData := DtoS(aTitBx[nX][07])
    Else
    	cData := aTitBx[nX][07]
    Endif
    	
	//Emissao
	oPrint:Say(Li+15 ,nColEmis		,SUBSTR(cData,7,2)+"/"+SUBSTR(cData,5,2)+"/"+SUBSTR(cData,3,2)	, oFtItem2 )
	
	//Vencimento
	If ValType(aTitBx[nX][08])=='D'
    	cData := DtoS(aTitBx[nX][08])
    Else
    	cData := aTitBx[nX][08]
    Endif	
	oPrint:Say(Li+15 ,nColVenc		,SUBSTR(cData,7,2)+"/"+SUBSTR(cData,5,2)+"/"+SUBSTR(cData,3,2)	, oFtItem2 )
	
	//Valor Original
	oPrint:Say(Li+15 ,nColVlrOrg	,AllTrim(Transform(aTitBx[nX][09],cMaskValor))					, oFtItem2 )
	
	//Saldo
	oPrint:Say(Li+15 ,nColSaldo		,AllTrim(Transform(aTitBx[nX][10],cMaskValor))					, oFtItem2 )

	//Valor Acrescimo (E1_ACRESC)
	nAcrescimo := iIf(lAcrescimo, aTitBx[nX][15], 0)
	oPrint:Say(Li+15 ,nColAcres		, AllTrim(Transform(nAcrescimo,cMaskAcres))						, oFtItem2 )

	//Juros/Multa
	oPrint:Say(Li+15 ,nColMulta		,AllTrim(Transform(aTitBx[nX][11]+aTitBx[nX][12],cMaskMulta))	, oFtItem2 )	

	//Desconto
	oPrint:Say(Li+15 ,nColDesc		,AllTrim(Transform(aTitBx[nX][13],cMaskDesc))						, oFtItem2 )

	//Valor Final
	oPrint:Say(Li+15 ,nColVlrFin	,AllTrim(Transform(aTitBx[nX][14],cMaskValor))					, oFtItem2 )	

	//Total do Saldo Devido
	nTotVlCruz += aTitBx[nX][10] + nAcrescimo - aTitBx[nX][13]
	
	//Saldo Devedor = Saldo do Titulo
	If ( (aTitBx[nX][10] + nAcrescimo - aTitBx[nX][13]) - aTitBx[nX][14] ) > 0
		nSalDev += aTitBx[nX][10]
	Else
		nSalDev += 0
	Endif

	//Total Recebido
	nRtot += aTitBx[nX][14]
	If Li >= nLinhasPag 
		lImpCab := .T.
		oPrint:EndPage()
	EndIf
	
Next		

// Se na impressão dos Totais ultrapssar o final da folha, realiza a impressão na próxima folha
If (nLinhasPag-Li) <= nLinTotais
	oPrint:EndPage()
	oPrint:StartPage()
	RECabec(	oPrint		,@Li			,@nPag			,cTitulo		,;
				cCliente	,cLoja			,nTotal		,lAcrescimo	,;
				cPrefixo	,cParcela		,cTipo			,cE5HISTOR		,;
				cE5SEQ		,cE5DATA		,cE5TIPODOC	,cE5MOTBX		,;
				cE5NUMERO	,cE5PARCELA	,cE5CLIFOR		,cE5LOJA		)
	Li += 48
	oPrint:Box(Li,020,Li,nColMax)
EndIf

Li += 50
oPrint:Box(Li,020,Li,nColMax)

Li += 50
oPrint:Say(Li , nColMulta, "Total R$ ", oFtGrande )
oPrint:Say(Li , nColVlrFin,AllTrim(Transform(nRtot,cMasc)), oFtItem2 )

Li += 50
oPrint:Say(Li , nColMulta, "Valor Recebido R$ ", oFtGrande )
oPrint:Say(Li , nColVlrFin,AllTrim(Transform(nRtot,cMasc)), oFtItem2 )

Li += 50
oPrint:Say(Li , nColMulta, "Saldo Devedor R$ ", oFtGrande )
oPrint:Say(Li , nColVlrFin,AllTrim(Transform(nSalDev,cMasc)), oFtItem2 )

lImpCab := .T.

For nX:=1 to Len(aTitNeg)

	If Alltrim(aTitNeg[nX][05]) == "CH"

		aAdd(aFormPg, { 	aTitNeg[nX][05]		,;	//01-Forma de Pagamento
							aTitNeg[nX][21]		,;	//02-Valor
							aTitNeg[nX][09]		,;	//03-Vencimento
							aTitNeg[nX][16]		,;	//04-Numero do Cheque
							aTitNeg[nX][17]		,;	//05-Banco	
							aTitNeg[nX][18]		,;	//06-Agencia
							aTitNeg[nX][19]		,;	//07-Conta Corrente
							""						})	//08-Titular
	Else
		If lImpCab
			Li += 50
			oPrint:Say(Li , 050, "Novo Título" , oFtMediaNeg )
			Li += 50
			oPrint:Box(Li,020,Li,nColMax)
			Li += 50
			oPrint:Say(Li , 050, "Filial" 		, oFtMediaNeg )
			oPrint:Say(Li , 300, "Tp.Doc." 		, oFtMediaNeg )
			oPrint:Say(Li , 470, "Num.Doc."		, oFtMediaNeg )
			oPrint:Say(Li , 770, "Parcela" 		, oFtMediaNeg )
			oPrint:Say(Li , 990, "Cliente" 		, oFtMediaNeg )
			oPrint:Say(Li , 1560,"Emissão"		, oFtMediaNeg )
			oPrint:Say(Li , 1880,"Vencimento"	, oFtMediaNeg )
			oPrint:Say(Li , 2150,"Valor" 		, oFtMediaNeg )       
			Li += 50
			oPrint:Box(Li,020,Li,nColMax)
			lImpCab := .F.
		Endif
		
		Li += 48
		oPrint:Say(Li+15 , 0050,aTitNeg[nX][01], oFtItem2 )								//1-FILIAL
		oPrint:Say(Li+15 , 0300,aTitNeg[nX][05], oFtItem2 )								//2-Tp. Doc
		oPrint:Say(Li+15 , 0470,aTitNeg[nX][02], oFtItem2 )								//4-Numero documento
		oPrint:Say(Li+15 , 0770,aTitNeg[nX][04], oFtItem2 )								//5-Parcela
		oPrint:Say(Li+15 , 0990,aTitNeg[nX][06], oFtItem2 )								//6-Cliente
		oPrint:Say(Li+15 , 1560,SUBSTR(aTitNeg[nX][08],7,2)+"/"+SUBSTR(aTitNeg[nX][08],5,2)+"/"+SUBSTR(aTitNeg[nX][08],1,4), oFtItem2 ) //7- Emissao
		oPrint:Say(Li+15 , 1880,SUBSTR(aTitNeg[nX][09],7,2)+"/"+SUBSTR(aTitNeg[nX][09],5,2)+"/"+SUBSTR(aTitNeg[nX][09],1,4), oFtItem2 )								//7-Vencimento
		oPrint:Say(Li+15 , 2050,Transform(aTitNeg[nX][15],cMasc), oFtItem2 )		//8-Valor
	Endif
Next

lImpCab := .T.

For nX:=1 to Len(aFormPg)

	If lImpCab
	
		Li += 140
		oPrint:Box(Li,020,Li,nColMax)
		Li += 49
		oPrint:Say(Li , 0050, "Forma Pgto" , oFtMediaNeg )
		oPrint:Say(Li , 0250, "Valor"		, oFtMediaNeg )
		oPrint:Say(Li , 0650, "Data" 		, oFtMediaNeg )
		If AllTrim(aFormPg[nX][01]) == "CH"
			oPrint:Say(Li , 0700, "Nº Cheque"		, oFtMediaNeg )
			oPrint:Say(Li , 0920, "Banco"			, oFtMediaNeg )
			oPrint:Say(Li , 1090, "Agência"			, oFtMediaNeg )
			oPrint:Say(Li , 1320, "Conta Corrente"	, oFtMediaNeg )
			oPrint:Say(Li , 1620, "Titular"			, oFtMediaNeg )
		EndIf
		
		Li += 48
		oPrint:Box(Li,020,Li,nColMax)

		lImpCab := .F.
	Endif			

	Li += 48

	oPrint:Say(Li+15 , 0050,aFormPg[nX][01], oFtItem2 )							//1- Forma de Pagamento
	oPrint:Say(Li+15 , 0250,AllTrim(Transform(aFormPg[nX][02],cMasc))	, oFtItem2 )	//2- Valor
	oPrint:Say(Li+15 , 0650,SUBSTR(aFormPg[nX][03],7,2)+"/"+SUBSTR(aFormPg[nX][03],5,2)+"/"+SUBSTR(aFormPg[nX][03],1,4)	, oFtItem2 ) //3- Data

	Li += 48

	//Imprimir dados do cheque com RA
	aAreaSEF := GetArea()
	If AllTrim(aFormPg[nX][01]) == "RA"
		dbSelectArea("SEF")
		SEF->(dbSetOrder(3))
		SEF->(dbGotop())
		If SEF->(dbSeek(xfilial("SEF")+aTitBx[1][2]+aTitBx[1][1]+aTitBx[1][3]))

			oPrint:Say(Li , 0600, "Nº Cheque"		, oFtMediaNeg )
			oPrint:Say(Li , 0820, "Banco"			, oFtMediaNeg )
			oPrint:Say(Li , 0990, "Agência"			, oFtMediaNeg )
			oPrint:Say(Li , 1220, "Conta Corrente"	, oFtMediaNeg )
			oPrint:Say(Li , 1520, "Titular"			, oFtMediaNeg )
			oPrint:Say(Li , 2150, "Valor"			, oFtMediaNeg )

			Li += 48

			While SEF->( !EOF() ) .AND. SEF->EF_FILIAL+SEF->EF_PREFIXO+SEF->EF_TITULO+SEF->EF_PARCELA = xfilial("SEF")+aTitBx[1][2]+aTitBx[1][1]+aTitBx[1][3] 
				oPrint:Say(Li+15 , 0600,	SEF->EF_NUM						, oFtItem2 )	//4-Numero Cheque
				oPrint:Say(Li+15 , 0820,	SEF->EF_BANCO						, oFtItem2 )	//5-Banco
				oPrint:Say(Li+15 , 0990,	SEF->EF_AGENCIA					, oFtItem2 )	//6-Agencia
				oPrint:Say(Li+15 , 1220,	SEF->EF_CONTA						, oFtItem2 )	//7-Conta Corrente
				oPrint:Say(Li+15 , 1520,	SUBSTR(SEF->EF_EMITENT,1,30)	, oFtItem2 )	//8-Titular
				oPrint:Say(Li+15 , 2150,	AllTrim(Transform(SEF->EF_VALOR,cMasc))	, oFtItem2 )	//Valor do Cheque
				cMensChq := "OBS: A Quitação do presente recibo, somente terá validade após o pagamento do(s) cheque(s) especificado(s), pela Agência do Banco Sacado."
				Li += 48
				SEF->( dbSkip() )
			End
		Endif
	Endif
	RestArea(aAreaSEF)

	If AllTrim(aFormPg[nX][01]) == "CH"
		oPrint:Say(Li+15 , 0600,	aFormPg[nX][04], oFtItem2 )	//4-Numero Cheque
		oPrint:Say(Li+15 , 0820,	aFormPg[nX][05], oFtItem2 )	//5-Banco
		oPrint:Say(Li+15 , 0990,	aFormPg[nX][06], oFtItem2 )	//6-Agencia
		oPrint:Say(Li+15 , 1220,	aFormPg[nX][07], oFtItem2 )	//7-Conta Corrente
		oPrint:Say(Li+15 , 1520,	aFormPg[nX][08], oFtItem2 )	//8-Titular

		cMensChq := "OBS: A quitação do presente recibo, somente terá validade após o pagamento do(s) cheque(s) abaixo especificado(s), pela Agência do Banco Sacado."
	Endif
Next

If !Empty(cMensChq)
	Li += 100	
	oPrint:Say(Li , 050,cMensChq , oFtMsg )
Endif 

Li += 80

oPrint:Box(Li,020,Li,nColMax)
Li += 50
oPrint:Say(Li , 050, trim(SM0->M0_CIDCOB) + ", " +  STRZERO(Day(dDataBase), 2) + " de " + MesExtenso(dDataBase) + " de " + AllTrim(STR(Year(dDataBase))) , oFtMedia )
Li += 200
oPrint:Say(Li , 1590, "______________________________________" , oFtMedia )
Li += 50
oPrint:Say(Li , 1590,SM0->M0_NOMECOM, oFtMedia )

Li += 50
oPrint:Say(Li , 1590,Transform(SM0->M0_CGC,"@R 99.999.999/9999-99"), oFtMedia )
Li += 50
oPrint:Say(Li , 1590,SM0->M0_ENDCOB, oFtMedia )
Li += 50
oPrint:Say(Li , 1590,trim(SM0->M0_CIDCOB), oFtMedia )
Li += 50
oPrint:Say(Li , 1590,SM0->M0_TEL, oFtMedia )
Li += 50
oPrint:box(Li,020,Li,nColMax)

Li += 50
oPrint:Box(Li,020,Li,nColMax)

oPrint:EndPage()

RestArea(aArea)

If Select (cAliasSE1) > 0                               
	(cAliasSE1)->( dbCloseArea() )
Endif

If Select (cAliasSE5) > 0                               
	(cAliasSE5)->( dbCloseArea() )
Endif

Return

//----------------------------------------------------------
/*/{Protheus.doc} RECabec
Responsável por montar o trecho refente ao cabeçalho do relatorio.

@type		Static Function
@author	Varejo
@version	P11.8
@since		20/06/2016

@param		oPrint - Objeto de impresão
			Li - Posição da linha do relatorio
			nPag - Numero da pagina
			cTitulo - Titulo da impressão
			cCliente - Codigo do cliente que possui os titulos.
			cLoja - Nome do cliente.
			nTotal - Total do relatorio
			lAcrescimo - Imprime acrescimo
			cPrefixo - Prefixo do titulo
			cParcela - Parcela da baixa
			cTipo - Tipo da baixa
			cHistor - historico da baixa 
			cSeq - Sequencia da baixa
			cData - data da baixa
			cE5TipoDoc - Tipo do documento da baixa (SE5)
			cE5MotBx - Motivo de baixa (SE5)
			cE5Num - Numero do baixa (SE5)
			cE5Parcela - Parcela da baixa (SE5)
			cSE5Cliente - Cliente da baixa (SE5)
			cE5LOJA - loja do cliente da baixa (SE5) 
@return lRet
/*/
//----------------------------------------------------------
Static function RECabec(	oPrint		, Li			, nPag			, cTitulo		,;
							cCliente	, cLoja		, nTotal		, lAcrescimo	,;
							cPrefixo	, cParcela		, cTipo		, cHistor		,;
							cSeq		, cData		, cE5TipoDoc	, cE5MotBx		,;
							cE5Num		, cE5Parcela	, cSE5Cliente	, cE5LOJA		)

Local cPath			:= GetSrvProfString("Startpath","")			//Caminho do diretorio padrao para impressao do logo
Local oFtGrande		:= TFont():New("Arial",09,12,,.T.,,,,.T.,.F.)	//Fonte Grante
Local oFtMedia 		:= TFont():New("Arial",09,10,,.F.,,,,.T.,.F.)	//Fonte Media
Local cMasc			:= "@E 999,999,999,999.99"
local nPosExtens 	:= Rat(" ",PadR(AllTrim(EXTENSO(nTotal)),120))
Local cVlrExtens  	:= SubStr(AllTrim(EXTENSO(nTotal)),1,nPosExtens)


Default oPrint		:= Nil
Default Li				:= 0
Default nPag			:= 0
Default cTitulo		:= ""
Default cCliente		:= ""											//Codigo do Cliente
Default cLoja			:= "" 											//Loja do Cliente	
Default nTotal		:= 0											//Total do Recibo
Default lAcrescimo	:= .F.
Default cPrefixo		:= ""
Default cParcela		:= ""
Default cTipo			:= ""
Default cHistor		:= ""
Default cSeq			:= ""
Default cData			:= ""
Default cE5TipoDoc	:= ""
Default cE5MotBx		:= ""
Default cE5Num		:= ""
Default cE5Parcela	:= ""
Default cSE5Cliente	:= ""
Default cE5LOJA		:= ""

DbSelectArea("SA1")
SA1->(DbSetOrder(1))
If SA1->(DbSeek( xFilial("SA1")+ cCliente + cLoja ))

	nPag ++
	Li := 30

	oPrint:SayBitmap(005,075,cPath + "LOGO.BMP",295,296)
	Li += 250
	
	If !Empty(Trim(cE5Parcela) + cSeq + cE5Num + cSE5Cliente)
		oPrint:Say(Li , 1100 , "RECIBO " + cE5Num + Trim(cE5Parcela) + cSE5Cliente + cLoja + cSeq	, oFtGrande )
		Li += 48
	Else
		If AllTrim(cTipo) = "RA"
			// Inclui aqui impressão dos dados do RA para posterior reimpressao do recibo, verificar outros modulos. Ex. Liquidação/Baixa automatica com bordero
			// O numero do recibo é composto pelo numero do titulo principal (RA) + loja + cliente e tipo RA. 
			oPrint:Say(Li , 1000 ,"RECIBO R.A. " + AllTrim(cTitulo) + AllTrim(cLoja) + AllTrim(cCliente) ,oFtGrande )  
			Li += 48
        Else
        	oPrint:Say(Li , 1000 , "RECIBO ") // Ver outros modulos
			Li += 48
        EndIf
	EndIf
	
	oPrint:Say(Li , 1000 ,AllTrim(SM0->M0_NOME) 	 	,oFtGrande	)
	Li += 48
	
	oPrint:Say(Li , 1000 ,AllTrim(SM0->M0_NOMECOM)	, oFtGrande	)
	Li += 48

	oPrint:Box(Li,020,Li,nColMax)

	Li += 48
	oPrint:Say(Li , 050, "Recebi(emos) do Sr(a). " + TRIM(SA1->A1_NOME) + " / " + SA1->A1_COD + " / " + SA1->A1_LOJA  , oFtGrande )

	Li += 48

	If Len(TRIM(SA1->A1_CGC)) > 11
		oPrint:Say(Li , 050, "CNPJ : " + Transform(SA1->A1_CGC,"@R 99.999.999/9999-99")	, oFtMedia )
	Else
		oPrint:Say(Li , 050, "CPF : " + Transform(SA1->A1_CGC,"@R 999.999.999-99")		, oFtMedia )
	Endif
	
	Li += 48
	oPrint:Box(Li,020,Li,nColMax)
	
	Li += 48
	oPrint:Say(Li , 050, "A quantia de R$ " + AllTrim(Transform(nTotal,cMasc))  , oFtGrande )
	
	Li += 48
	oPrint:Say(Li , 050,cVlrExtens   , oFtMedia )
	
	cVlrExtens  := SubStr(AllTrim(EXTENSO(nTotal)),nPosExtens)
	
	If !Empty(cVlrExtens)
		Li += 48
		oPrint:Say(Li , 050,cVlrExtens   , oFtMedia )
	EndIf
	
	Li += 48
	oPrint:Box(Li,020,Li,nColMax)
	
	Li += 48
	oPrint:Say(Li , 050, "Referente ao(s) título(s) abaixo descrito(s):", oFtGrande )

	Li += 60
	oPrint:Say(Li , nColDoc		, "Docto"		, oFtGrande )
	oPrint:Say(Li , nColTipo		, "Tipo"			, oFtGrande )
	oPrint:Say(Li , nColEmis		, "Emissão"		, oFtGrande )
	oPrint:Say(Li , nColVenc		, "Vencto"	, oFtGrande )
	oPrint:Say(Li , nColVlrOrg	, "Vlr Origem"	, oFtGrande )
	oPrint:Say(Li , nColSaldo	, "Vlr Saldo"		, oFtGrande )
	oPrint:Say(Li , nColAcres	, "Acrescimo"		, oFtGrande )
	oPrint:Say(Li , nColMulta	, "Juros/Multa"	, oFtGrande )
	oPrint:Say(Li , nColDesc		, "Desconto"		, oFtGrande )
	oPrint:Say(Li , nColVlrFin	, "Vlr Final"		, oFtGrande )
Endif

Return
