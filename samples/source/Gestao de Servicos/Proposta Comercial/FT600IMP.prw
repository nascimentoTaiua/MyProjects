#INCLUDE "PROTHEUS.CH"

//-------------------------------------------------------------------------------------
/*/{Protheus.doc} FT600IMP
RDMAKE para Impressao Customizada da Proposta Comercial 

@author  TOTVS SP - Equipe de Projetos Piloto do Segmento de Servicos e Juridico
@version P12
@since 	 13/11/2015
@return  Nil
/*/
//-------------------------------------------------------------------------------------
User Function FT600IMP()
	Private cNomeFile	:= 'Modelo-proposta-TOTVS.dot'
	Private cPath		:= GetTempPath(.T.)
	Private cFullPath	:= cPath + cNomeFile
	Private cSrvPath	:= alltrim(GetNewPar("MV_DOCAR","\system\modelos\"))
	Private cSrvFull	:= cSrvPath + cNomeFile
	
	Processa( {|| U_AdlProp() })	
Return

//-------------------------------------------------------------------------------------
/*/{Protheus.doc} AdlProp
RDMAKE para Impressao Customizada da Proposta Comercial 

@author  TOTVS SP - Equipe de Projetos Piloto do Segmento de Servicos e Juridico
@version P12
@since 	 13/11/2015
@return  Nil
/*/
//-------------------------------------------------------------------------------------
User Function AdlProp()
	If U_AdlCpDot()
		If IsInCallStack("TECA745")
			U_SPSetDoc()
		Else
			U_AdlSetDoc()
		EndIf
	Else
		MsgStop('Erro na execução da copia do arquivo Modelo do Microsoft Word para a estação de trabalho')
	EndIf
Return

//-------------------------------------------------------------------------------------
/*/{Protheus.doc} AdlCpDot
Funcao responsavel por promover a copia do arquivo DOT da impressao de orcamentos 
do servidor Protheus para a Estacao de Trabalho do Usuario. Arquivo fica armazenado no diretorio
TEMP da estacao local. Sempre apaga o arquivo caso ele exista na estacao 

@author  TOTVS SP - Equipe de Projetos Piloto do Segmento de Servicos e Juridico
@version P12
@since 	 13/11/2015
@return  Nil
/*/
//-------------------------------------------------------------------------------------
User Function AdlCpDot()
	Local nTry	:= 5
	Local nI 	:= 1
	Local lOk	:= .T.
	
	//Verifica se o arquivo existe. Se existe, apaga ele.
	If File(cNomeFile) 
		For nI := 1 to nTry 
			If FErase(cFile) <> -1
				lOk := .T.
				exit
			Else
				lOk := .F.
				Sleep(1000)
			EndIf
		Next nT
	EndIf
	
	//Copia o Arquivo para a estacao
	If lOk
		lOk := CpyS2T(cSrvFull,cPath,.T.) 
	EndIf
	
Return lOk

//-------------------------------------------------------------------------------------
/*/{Protheus.doc} AdlSetDoc
RDMAKE para Impressao Customizada da Proposta Comercial 

@author  TOTVS SP - Equipe de Projetos Piloto do Segmento de Servicos e Juridico
@version P12
@since 	 13/11/2015
@return  Nil
/*/
//-------------------------------------------------------------------------------------
User Function AdlSetDoc(cPath,cNomeFile)
Local aArea			:= GetArea()						//Armazena area atual
Local hWord 		:= Nil								//Objeto usado para preenchimento
Local cProposta		:= Space(TamSX3("ADY_PROPOS")[1])	//Numero da proposta comercial
Local cDtEmissao	:= Space(TamSX3("CJ_EMISSAO")[1])	//Data de emissao
Local cCodigo		:= Space(TamSX3("A1_COD")[1])		//Codigo da entidade (cliente ou prospect)
Local cLoja			:= Space(TamSX3("A1_LOJA")[1])		//Loja
Local cNome 		:= Space(TamSX3("A1_NOME")[1])		//Nome
Local cEndereco		:= Space(TamSX3("A1_END")[1])   	//Endereco
Local cBairro		:= Space(TamSX3("A1_BAIRRO")[1])    //Bairro
Local cCidade		:= Space(TamSX3("A1_MUN")[1])  		//Cidade
Local cUF			:= Space(TamSX3("A1_ESTADO")[1])  	//Estado (UF)
Local cPRevisa		:= ' '                              //Revisao dos itens da proposta comercial gravado na tabela ADZ
Local aTipo09		:= {}								//Array que armazena o tipo de pagamento 9
Local aCronoFin		:= {}								//Array que armazena o cronograma financeiro
Local cRevisao		:= ' '                              //Controla a revisao do documento
Local nTotProsp		:= 0								//Total da proposta comercial
Local nI			:= 0                               	//Usado no laco do While
Local nX            := 0                                //Usado no laco do For
Local nY			:= 0								//Usado no laco do While
Local nCount		:= 0								//Incremento para utilizar no itens de cond. pagto.
Local cQuery 		:= ""
Local cUserName		:= ""
Local cUserCarg		:= ""
Local cUserMail		:= ""
Local aUserInfo		:= PswRet()
Local cEndAtend		:= ""
Local nTotOrc		:= 0
Local nTotPst		:= 0
Local nPst			:= 0
Local nTotNoImp		:= 0

//Monta a conexao com o arquivo WORD
hWord	:= OLE_CreateLink()
OLE_NewFile(hWord, cFullPath)

cProposta	:= ADY->ADY_PROPOS
cPRevisa	:= ADY->ADY_PREVIS
cDescEnt	:= Space(30)
cDtEmissao	:= Dtoc(ADY->ADY_DATA)
aTipo09		:= Ft600Tip09(cProposta,cPRevisa)
aCronoFin	:= Ft600CroFin(cProposta,cPRevisa,aTipo09)

//Busca dados do cliente
If ADY->ADY_ENTIDA == "1"
	dbSelectArea("SA1")
	dbSetOrder(1)
	If	dbSeek(xFilial("SA1")+ADY->ADY_CODIGO+ADY->ADY_LOJA)
		cCodigo		:= ADY->ADY_CODIGO
		cLoja		:= ADY->ADY_LOJA
		cNome 		:= Replace(alltrim(SA1->A1_NOME),"  "," ")
		cEndereco	:= alltrim(SA1->A1_END)
		cBairro		:= alltrim(SA1->A1_BAIRRO)
		cCidade		:= alltrim(SA1->A1_MUN)
		cUF			:= alltrim(SA1->A1_EST)
		cDescEnt	:= alltrim(SA1->A1_NREDUZ)
	Endif
Else
	dbSelectArea("SUS")
	dbSetOrder(1)
	If	dbSeek(xFilial("SUS")+ADY->ADY_CODIGO+ADY->ADY_LOJA)
		cCodigo		:= ADY->ADY_CODIGO
		cLoja		:= ADY->ADY_LOJA
		cNome 		:= alltrim(SUS->US_NOME)
		cEndereco	:= alltrim(SUS->US_END)
		cBairro		:= alltrim(SUS->US_BAIRRO)
		cCidade		:= alltrim(SUS->US_MUN)
		cUF			:= alltrim(SUS->US_EST)
		cDescEnt	:= alltrim(SUS->US_NREDUZ)
	Endif
Endif

cNomeWord	:=	''
cNomeWord	:= 'P'+cProposta

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Descricao da Oportunidade de Venda         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
OLE_SetDocumentVar(hWord,'cRevisao'	,cPRevisa)
OLE_SetDocumentVar(hWord,'cDesOport',Capital(POSICIONE("AD1",1,xFilial("AD1")+ADY->ADY_OPORTU,"AD1_DESCRI")))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza variaveis do cabecalho - Variaveis³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
OLE_SetDocumentVar(hWord,'cProposta'	,cProposta)
OLE_SetDocumentVar(hWord,'cDtEmissao'	,cDtEmissao)
OLE_SetDocumentVar(hWord,'cCodigo'		,cCodigo)
OLE_SetDocumentVar(hWord,'cNome'		,cNome)
OLE_SetDocumentVar(hWord,'cEndereco'	,cEndereco)
OLE_SetDocumentVar(hWord,'cBairro'		,cBairro)
OLE_SetDocumentVar(hWord,'cCidade'		,cCidade)
OLE_SetDocumentVar(hWord,'cUF'			,cUF)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza tabela de itens da proposta³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("ADZ")
ADZ->(dbSetOrder(3))
If ADZ->(dbSeek(xFilial("ADZ")+cProposta+cPRevisa)) 
	
	//Busco os itens do orcamento desta proposta
	cQuery := "SELECT SRJ.RJ_DESC AS FUNCAO, SR6.R6_DESC AS TURNO, TFF.TFF_QTDVEN AS QTD,
	cQuery += "		(TFF.TFF_TOTMES /  TFF.TFF_QTDVEN) AS VLRPOSTO, TFF.TFF_TOTMES AS VLRMES,
	cQuery += "		ABS.ABS_DESCRI AS LOCAL, ABS.ABS_END AS RUA, ABS.ABS_BAIRRO AS BAIRRO, "
	cQuery += "		ABS.ABS_MUNIC AS CIDADE, ABS.ABS_ESTADO AS UF, "
	cQuery += "		(TFL.TFL_MESRH + TFL.TFL_MESMI + TFL.TFL_MESMC) AS TOTMESLOC "  
	cQuery += " FROM "
	cQuery += RetSqlName("TFJ") + " TFJ, " 
	cQuery += RetSqlName("TFL") + " TFL, "
	cQuery += RetSqlName("TFF") + " TFF, " 
	cQuery += RetSqlName("SRJ") + " SRJ, "
	cQuery += RetSqlName("SR6") + " SR6, "
	cQuery += RetSqlName("ABS") + " ABS "
	cQuery += " WHERE TFJ.TFJ_FILIAL = '" + xFilial("TFJ") + "'"
	cQuery += " 	AND TFJ.TFJ_FILIAL = TFL.TFL_FILIAL "
	cQuery += " 	AND TFL.TFL_FILIAL = TFF.TFF_FILIAL "
	cQuery += " 	AND SRJ.RJ_FILIAL = '" + xFilial('SRJ') + "' "
	cQuery += " 	AND SR6.R6_FILIAL = '" + xFilial('SR6') + "'
	cQuery += " 	AND ABS.ABS_FILIAL = '" + xFilial('ABS') + "'		
	cQuery += " 	AND TFJ.TFJ_PROPOS = '" + ADY->ADY_PROPOS + "'" 
	cQuery += " 	AND TFJ.TFJ_PREVIS = '" + ADY->ADY_PREVIS + "'" 
	cQuery += " 	AND TFJ.TFJ_CODIGO = TFL.TFL_CODPAI " 
	cQuery += " 	AND TFL.TFL_CODIGO = TFF.TFF_CODPAI "
	cQuery += " 	AND SRJ.RJ_FUNCAO = TFF.TFF_FUNCAO "
	cQuery += " 	AND SR6.R6_TURNO = TFF.TFF_TURNO "
	cQuery += " 	AND TFF.TFF_LOCAL = ABS.ABS_LOCAL "
	cQuery += " 	AND TFJ.D_E_L_E_T_ = ' ' "
	cQuery += " 	AND TFL.D_E_L_E_T_ = ' ' "
	cQuery += " 	AND TFF.D_E_L_E_T_ = ' ' "
	cQuery += " 	AND SRJ.D_E_L_E_T_ = ' ' "
	cQuery += " 	AND SR6.D_E_L_E_T_ = ' ' "
	cQuery += " 	AND ABS.D_E_L_E_T_ = ' ' "
	iif(Select('TCQ')>0,TCQ->(dbCloseArea()),Nil)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery), "TCQ", .F., .T.)	
	
	//Printo cada item no arquivo DOT
	While TCQ->(!Eof())
		nI++
		OLE_SetDocumentVar(hWord,"cFunc"+Alltrim(str(nI)),Alltrim(TCQ->FUNCAO) )
		OLE_SetDocumentVar(hWord,"cPostoJorn"+Alltrim(str(nI)) ,Alltrim(TCQ->TURNO))
		OLE_SetDocumentVar(hWord,"nQtdItem"+Alltrim(str(nI)),Transform(TCQ->QTD,"@E 999,999,999"))

		TCQ->(dbSkip())
	Enddo
	
	//Total do Contrato por Mes
	nTotProsp := aCronoFin[1][3]
	OLE_SetDocumentVar(hWord,'nTotProsp',"R$ "+ Transform(nTotProsp,"@E 999,999,999.99"))
	OLE_SetDocumentVar(hWord,'cExtenso',alltrim(Extenso(nTotProsp))) 
Endif
If nI > 0
	//Executa a macro para atualizar os itens
	OLE_SetDocumentVar(hWord,'nItens_Proposta',alltrim(Str(nI)))
	OLE_ExecuteMacro(hWord,"Itens_Proposta") 
Endif

//Obtem o total dos locais (sem impostos)
nTotNoImp := 0
TCQ->(dbGoTop())
While !(TCQ->(Eof()))
	nTotNoImp += TCQ->TOTMESLOC
	TCQ->(dbSkip())
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza os dados de resumo  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
TCQ->(dbGoTop())
While !(TCQ->(Eof()))
	nX++
	
	//Define o Endereco do Local
	cEndAtend := alltrim(TCQ->RUA) + " - " 
	cEndAtend += alltrim(TCQ->BAIRRO) + " - "
	cEndAtend += alltrim(TCQ->CIDADE) + "/"
	cEndAtend += alltrim(TCQ->UF)
	
	//Total do Contrato por Mes
	nTotOrc := aCronoFin[1][3]
	
	//Valor Total do Posto
	nTotPst := Round((((TCQ->TOTMESLOC * 100) / nTotNoImp) * nTotOrc) / 100,2)
	
	//Valor do Posto
	nPst := nTotPst / TCQ->QTD
	
	OLE_SetDocumentVar(hWord,"cLocal"+Alltrim(str(nX)),alltrim(TCQ->LOCAL))
	OLE_SetDocumentVar(hWord,"cEndLoc"+Alltrim(str(nX)),alltrim(cEndAtend))
	OLE_SetDocumentVar(hWord,"cResFunc"+Alltrim(str(nX)),alltrim(TCQ->FUNCAO))
	OLE_SetDocumentVar(hWord,"cResTurn"+Alltrim(str(nX)),alltrim(TCQ->TURNO))
	OLE_SetDocumentVar(hWord,"nResQtd"+Alltrim(str(nX)),Transform(TCQ->QTD,"@E 999,999,999"))
	OLE_SetDocumentVar(hWord,"nVlrPst"+Alltrim(str(nX)),"R$ " + Transform(nPst,"@E 999,999,999.99"))
	OLE_SetDocumentVar(hWord,"nVlrPstTot"+Alltrim(str(nX)),"R$ " + Transform(nTotPst,"@E 999,999,999.99"))
	//OLE_SetDocumentVar(hWord,"nVltTotContr"+Alltrim(str(nX)),"R$ " + Transform(nTotOrc,"@E 999,999,999.99"))

	TCQ->(dbSkip())
EndDo
If nX > 0
	OLE_SetDocumentVar(hWord,'nItens_Proposta_Resumo',alltrim(Str(nX))) 
	OLE_ExecuteMacro(hWord,"Itens_Resumo") 
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Assinatua do Usuario do Protheus  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cUserName	:= aUserInfo[1][4] 
cUserCarg	:= aUserInfo[1][13]  
cUserMail	:= aUserInfo[1][14]
OLE_SetDocumentVar(hWord,'cUserName'	,cUserName)
OLE_SetDocumentVar(hWord,'cUserCarg'	,cUserCarg)
OLE_SetDocumentVar(hWord,'cUserMail'	,cUserMail)

//Atualiza todos os campos do documento DOT (Refresh)
OLE_UpDateFields(hWord)

RestArea(aARea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Ft600Rev  ºAutor  ³Vendas CRM			 º Data ³  29/12/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cria revisao do documento.                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ft600Exe                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Ft600Rev(cProposta)

Local cLocRev		:= '' 	   				//Localiza a se existe docs de revisao no servidor
Local cRevisao 		:= '' 					//Revisao do documento
Local cNomeWord		:= "P"+cProposta   		//P+Numero da Proposta
Local nCount 		:= 1  					//Incremento


DbSelectArea("ACB")
DbSetOrder(2)

If !DbSeek(xFilial("ACB")+Upper(cNomeWord+'.doc'))
	cRevisao := cNomeWord
	Return(cRevisao)
Else
	While ACB->(!Eof())
		cLocRev := ' - R'+cValToChar(nCount)
		If !DbSeek(xFilial("ACB")+Upper(cNomeWord+cLocRev+'.doc'))
			cRevisao := cNomeWord+cLocRev
			Exit
		EndIf
		nCount++
		ACB->(DbSkip())
	End
EndIf

Return(cRevisao)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Ft600Tip09 ºAutor  ³Vendas CRM          º Data ³  12/01/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Inicializa o vetor aTipo09 com as parcelas previamente       º±±
±±º          ³salvas.                                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Ft600Exe                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Ft600Tip09(cProposta,cPRevisa)

Local aArea		:= GetArea()
Local aAreaSCJ	:= SCJ->(GetArea())
Local aAreaSCK	:= SCK->(GetArea())
Local aProdutos := {}
Local aTipo09	:= {}
Local nIt		:= 0
Local nNumParc	:= SuperGetMv("MV_NUMPARC")
Local cProxParc	:= ""
Local dDtVenc	:= Nil
Local nVlParc	:= 0
Local nPc		:= 0


dbSelectArea("SE4")	
dbSetOrder(1)

DbSelectarea("SCJ")	
DbSetOrder(1)

DbSelectArea("SCK")
DbSetOrder(1)  		


DbSelectArea("ADZ")
DbSetOrder(3)   

If dbSeek(xFilial("ADZ")+cProposta+cPRevisa) 
	
	While ADZ->(!EOF()) .AND. ADZ_FILIAL == xFilial("ADZ")  .AND. ADZ_PROPOS == cProposta
		aAdd(aProdutos,{ADZ_PRODUT,ADZ_ORCAME,ADZ_ITEMOR,ADZ_ITEM})
		ADZ->(DbSkip())
	End
	
EndIf

For nIt := 1 to Len(aProdutos)
	
	If  SCK->(DbSeek(xFilial("SCK") + aProdutos[nIt][02] + aProdutos[nIt][03] + aProdutos[nIt][01]))
		
		SCJ->(DbSeek(xFilial("SCJ") + SCK->CK_NUM + SCK->CK_CLIENTE + SCK->CK_LOJA ))
		
		SE4->(DbSeek(xFilial("SE4") + SCJ->CJ_CONDPAG))
		
		If	SE4->E4_TIPO == "9"
			
			cProxParc := "0"
			
			For nPc:=1 To nNumParc
				
				cProxParc := Soma1(cProxParc)
				
				dDtVenc := &("SCJ->CJ_DATA"+cProxParc)
				nVlParc	:= &("SCJ->CJ_PARC"+cProxParc)
				
				If	nVlParc > 0
					aadd( aTipo09,{SCK->CK_PRODUTO, dDtVenc , nVlParc ,SCJ->CJ_CONDPAG, aProdutos[nIt][04] } )
				Endif
				
			Next
			
		Endif
		
	EndIf
	
Next nIt

RestArea(aAreaSCJ)
RestArea(aAreaSCK)
RestArea(aArea)

Return(aTipo09)




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Ft600CroFin ºAutor  ³Vendas CRM          º Data ³  12/01/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Monta o Cronograma Financeiro.								º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Ft600Exe                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function  Ft600CroFin(cProposta,cPRevisa,aTipo09)

Local aArea			:= GetArea()
Local aVencto 		:= {}
Local aCronoAtu		:= {}
Local nC			:= 0
Local nA			:= 0
Local nI			:= 0
Local nPosData		:= 0
Local cTipoPar		:= SuperGetMv("MV_1DUP")
Local cSequencia    := " "
Local aProdutos		:= {}
Local aCronoFin		:= {}


DbSelectArea("ADZ")
DbSetOrder(3) 

If dbSeek(xFilial("ADZ")+cProposta+cPRevisa) 
	
	While ADZ->(!EOF()) .AND. ADZ_FILIAL == xFilial("ADZ")  .AND. ADZ_PROPOS == cProposta
		aAdd(aProdutos,{ADZ_PRODUT,ADZ_TOTAL,ADZ_CONDPG,ADZ_DT1VEN})
		ADZ->(DbSkip())
	End
	
EndIf


For nI:=1 To Len(aProdutos)
	
	dbSelectArea("SE4")
	dbSetOrder(1)
	IF	dbSeek(xFilial("SE4")+aProdutos[nI][03]) 
		
		If	E4_TIPO <> "9"
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Atualiza cronograma financeiro para condicao diferente do tipo 9³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aVencto := Condicao(aProdutos[nI][02],aProdutos[nI][03],0,dDatabase,0)
			
			For nA:=1 To Len(aVencto)
				
				If	!Empty(aProdutos[nI][04]) .AND. aProdutos[nI][04] <> dDataBase .AND. nA == 1
					aVencto[nA,1] := aProdutos[nI][04]
				Endif
				
				nPosData := aScan( aCronoAtu, { |x| x[1] == aVencto[nA,1] } )
				
				If	nPosData == 0
					aadd(aCronoAtu,{aVencto[nA,1],aVencto[nA,2]})
				Else
					aCronoAtu[nPosData,2] += aVencto[nA,2]
				Endif
				
			Next nA
			
		Endif
		
	Endif
	
Next nI

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza cronograma financeiro para condicao de pagamento tipo 9³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If	Len(aTipo09)>0
	
	For nA:=1 To Len(aTipo09)
		
		If	Len(aCronoAtu)>0
			nPosData := aScan( aCronoAtu, { |x| x[1] == aTipo09[nA,2] } )
		Else
			nPosData := 0
		Endif
		
		If	nPosData == 0
			aadd(aCronoAtu,{aTipo09[nA,2],aTipo09[nA,3]})
		Else
			aCronoAtu[nPosData,2] += aTipo09[nA,3]
		Endif
		
	Next nA
	
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Trata o iniciador da parcela inicial ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If	cTipoPar == "A"
	cSequencia	:= "9"
Else
	cSequencia	:= "0"
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ordena as parcelas pela data de vencimento ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCronoAtu := ASort(aCronoAtu,,,{|parc1,parc2|parc1[1]<parc2[1]})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza cronograma financeiro ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nC:=1 To Len(aCronoAtu)
	
	cSequencia := Soma1(cSequencia)
	
	If	nC == 1
		aadd(aCronoFin,{"",CtoD(Space(8)),0})
		aCronoFin[nC,1] := cSequencia
		aCronoFin[nC,2] := aCronoAtu[nC,1]
		aCronoFin[nC,3] := aCronoAtu[nC,2]
	Else
		AAdd(aCronoFin,{cSequencia,aCronoAtu[nC,1],aCronoAtu[nC,2] })
	Endif
	
Next nC

RestArea(aArea)

Return(aCronoFin)

//-------------------------------------------------------------------------------------
/*/{Protheus.doc} SPSetDoc
RDMAKE para Impressao Customizada do Orçamento de Serviço

@author  Augusto.Albuquerque
@version P12
@since 	 22/10/2021
@return  Nil
/*/
//-------------------------------------------------------------------------------------
User Function SPSetDoc()
Local aArea			:= GetArea()						//Armazena area atual
Local hWord 		:= Nil								//Objeto usado para preenchimento
Local cCodTFJ		:= Space(TamSX3("ADY_PROPOS")[1])	//Numero da proposta comercial
Local cDtEmissao	:= Space(TamSX3("CJ_EMISSAO")[1])	//Data de emissao
Local cCodigo		:= Space(TamSX3("A1_COD")[1])		//Codigo da entidade (cliente ou prospect)
Local cLoja			:= Space(TamSX3("A1_LOJA")[1])		//Loja
Local cNome 		:= Space(TamSX3("A1_NOME")[1])		//Nome
Local cEndereco		:= Space(TamSX3("A1_END")[1])   	//Endereco
Local cBairro		:= Space(TamSX3("A1_BAIRRO")[1])    //Bairro
Local cCidade		:= Space(TamSX3("A1_MUN")[1])  		//Cidade
Local cUF			:= Space(TamSX3("A1_ESTADO")[1])  	//Estado (UF)
Local cAliasTFF		:= GetNextAlias()
Local cPRevisa		:= ' '                              //Revisao dos itens da proposta comercial gravado na tabela ADZ
Local nI			:= 0                               	//Usado no laco do While
Local nX            := 0                                //Usado no laco do For
Local cQuery 		:= ""
Local cUserName		:= ""
Local cUserCarg		:= ""
Local cUserMail		:= ""
Local aUserInfo		:= PswRet()
Local cEndAtend		:= ""
Local nTotal		:= 0

//Monta a conexao com o arquivo WORD
hWord	:= OLE_CreateLink()
OLE_NewFile(hWord, cFullPath)

cCodTFJ := TFJ->TFJ_CODIGO
cPRevisa := TFJ->TFJ_CONREV
cDescEnt	:= Space(30)
cDtEmissao	:= Dtoc(TFJ->TFJ_DATA)

dbSelectArea("SA1")
dbSetOrder(1)
If dbSeek(xFilial("SA1")+TFJ->TFJ_CODENT+TFJ->TFJ_LOJA)
	cCodigo		:= TFJ->TFJ_CODENT
	cLoja		:= TFJ->TFJ_LOJA
	cNome 		:= Replace(alltrim(SA1->A1_NOME),"  "," ")
	cEndereco	:= alltrim(SA1->A1_END)
	cBairro		:= alltrim(SA1->A1_BAIRRO)
	cCidade		:= alltrim(SA1->A1_MUN)
	cUF			:= alltrim(SA1->A1_EST)
	cDescEnt	:= alltrim(SA1->A1_NREDUZ)
Endif

cNomeWord	:=	''
cNomeWord	:= 'P'+ cCodTFJ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Descricao da Oportunidade de Venda         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
OLE_SetDocumentVar(hWord,'cRevisao'	,cPRevisa)
OLE_SetDocumentVar(hWord,'cDesOport', "")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza variaveis do cabecalho - Variaveis³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
OLE_SetDocumentVar(hWord,'cProposta'	,"")
OLE_SetDocumentVar(hWord,'cDtEmissao'	,cDtEmissao)
OLE_SetDocumentVar(hWord,'cCodigo'		,cCodigo)
OLE_SetDocumentVar(hWord,'cNome'		,cNome)
OLE_SetDocumentVar(hWord,'cEndereco'	,cEndereco)
OLE_SetDocumentVar(hWord,'cBairro'		,cBairro)
OLE_SetDocumentVar(hWord,'cCidade'		,cCidade)
OLE_SetDocumentVar(hWord,'cUF'			,cUF)

cQuery := ""
cQuery += " SELECT SRJ.RJ_DESC AS FUNCAO, SR6.R6_DESC AS TURNO,TDW.TDW_DESC AS ESCALA, TFF.TFF_QTDVEN, TFF.TFF_PRCVEN, TFF.TFF_VALDES,  "
cQuery += " TFF.TFF_TXLUCR, TFF.TFF_TXADM, ABS.ABS_DESCRI AS LOCAL, ABS.ABS_END AS RUA, ABS.ABS_BAIRRO AS BAIRRO, "
cQuery += "	ABS.ABS_MUNIC AS CIDADE, ABS.ABS_ESTADO AS UF "
cQuery += " FROM " + RetSQLName("TFF") + " TFF "
cQuery += " INNER JOIN " + RetSQLName("SRJ") + " SRJ "
cQuery += " ON SRJ.RJ_FUNCAO = TFF.TFF_FUNCAO "
cQuery += " AND SRJ.RJ_FILIAL = '" + xFilial("SRJ") + "' "
cQuery += " AND SRJ.D_E_L_E_T_ = ' ' "
cQuery += " LEFT JOIN " + RetSQLName("SR6") + " SR6 "
cQuery += " ON SR6.R6_TURNO = TFF.TFF_TURNO "
cQuery += " AND SR6.R6_FILIAL = '" + xFilial("SR6") + "' "
cQuery += " AND SR6.D_E_L_E_T_ = ' ' "
cQuery += " LEFT JOIN " + RetSqlName( "TDW" ) + " TDW "
cQuery += " ON TDW.TDW_FILIAL = '" + xFilial("TDW") + "' "
cQuery += " AND TDW.D_E_L_E_T_ = ' ' "
cQuery += " AND TDW.TDW_COD = TFF.TFF_ESCALA "  
cQuery += " INNER JOIN " + RetSQLName("TFL") + " TFL "
cQuery += " ON TFL.TFL_CODIGO = TFF.TFF_CODPAI "
cQuery += " AND TFL.TFL_FILIAL = '" + xFilial("TFL") + "' "
cQuery += " AND TFL.D_E_L_E_T_ = ' ' "
cQuery += " INNER JOIN " + RetSQLName("ABS") + " ABS "
cQuery += " ON ABS.ABS_LOCAL = TFL.TFL_LOCAL "
cQuery += " AND ABS.ABS_FILIAL = '" + xFilial("ABS") + "' "
cQuery += " AND ABS.D_E_L_E_T_ = ' ' "
cQuery += " INNER JOIN " + RetSQLName("TFJ") + " TFJ "
cQuery += " ON TFJ.TFJ_CODIGO = TFL.TFL_CODPAI "
cQuery += " AND TFJ.TFJ_FILIAL = '" + xFilial("TFJ") + "' "
cQuery += " AND TFJ.D_E_L_E_T_ = ' ' "
cQuery += " WHERE "
cQuery += " TFJ.TFJ_CODIGO = '" + TFJ->TFJ_CODIGO + "' "
cQuery += " AND TFF.TFF_FILIAL = '" + xFilial("TFF") + "' "
cQuery += " AND TFF.D_E_L_E_T_ = ' ' "
cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTFF,.T.,.T.)

While (cAliasTFF)->(!Eof())
	nI++
	OLE_SetDocumentVar(hWord,"cFunc"+Alltrim(str(nI)),Alltrim((cAliasTFF)->FUNCAO) )
	OLE_SetDocumentVar(hWord,"cPostoJorn"+Alltrim(str(nI)) ,Iif(!Empty(Alltrim((cAliasTFF)->TURNO)),Alltrim((cAliasTFF)->TURNO),Alltrim((cAliasTFF)->ESCALA)))
	OLE_SetDocumentVar(hWord,"nQtdItem"+Alltrim(str(nI)),Transform((cAliasTFF)->TFF_QTDVEN,"@E 999,999,999"))
	nTotal += (((cAliasTFF)->TFF_PRCVEN * (cAliasTFF)->TFF_QTDVEN) + (cAliasTFF)->TFF_TXLUCR + (cAliasTFF)->TFF_TXADM) - (cAliasTFF)->TFF_VALDES

	//OLE_SetDocumentVar(hWord,"nVltTotContr"+Alltrim(str(nX)),"R$ " + Transform(nTotOrc,"@E 999,999,999.99"))

	(cAliasTFF)->(DbSkip())
EndDo

// Total  Orçamento
OLE_SetDocumentVar(hWord,'nTotProsp',"R$ "+ Transform(nTotal,"@E 999,999,999.99"))
OLE_SetDocumentVar(hWord,'cExtenso',alltrim(Extenso(nTotal)))

If nI > 0
	//Executa a macro para atualizar os itens
	OLE_SetDocumentVar(hWord,'nItens_Proposta',alltrim(Str(nI)))
	OLE_ExecuteMacro(hWord,"Itens_Proposta") 
EndIf

(cAliasTFF)->(DbGoTop())
//Define o Endereco do Local
While (cAliasTFF)->(!Eof())
	nX++
	cEndAtend := alltrim((cAliasTFF)->RUA) + " - " 
	cEndAtend += alltrim((cAliasTFF)->BAIRRO) + " - "
	cEndAtend += alltrim((cAliasTFF)->CIDADE) + "/"
	cEndAtend += alltrim((cAliasTFF)->UF)
	
	OLE_SetDocumentVar(hWord,"cLocal"+Alltrim(str(nX)),alltrim((cAliasTFF)->LOCAL))
	OLE_SetDocumentVar(hWord,"cEndLoc"+Alltrim(str(nX)),alltrim(cEndAtend))
	OLE_SetDocumentVar(hWord,"cResFunc"+Alltrim(str(nX)),alltrim((cAliasTFF)->FUNCAO))
	OLE_SetDocumentVar(hWord,"cResTurn"+Alltrim(str(nX)),Iif(!Empty(Alltrim((cAliasTFF)->TURNO)),Alltrim((cAliasTFF)->TURNO),Alltrim((cAliasTFF)->ESCALA)))
	OLE_SetDocumentVar(hWord,"nResQtd"+Alltrim(str(nX)),Transform((cAliasTFF)->TFF_QTDVEN,"@E 999,999,999"))
	OLE_SetDocumentVar(hWord,"nVlrPst"+Alltrim(str(nX)),"R$ " + Transform((cAliasTFF)->TFF_PRCVEN,"@E 999,999,999.99"))
	OLE_SetDocumentVar(hWord,"nVlrPstTot"+Alltrim(str(nX)),"R$ " + Transform((cAliasTFF)->TFF_PRCVEN * (cAliasTFF)->TFF_QTDVEN,"@E 999,999,999.99"))
	(cAliasTFF)->(DbSkip())
EndDo

If nX > 0
	OLE_SetDocumentVar(hWord,'nItens_Proposta_Resumo',alltrim(Str(nX))) 
	OLE_ExecuteMacro(hWord,"Itens_Resumo") 
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Assinatua do Usuario do Protheus  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cUserName	:= aUserInfo[1][4] 
cUserCarg	:= aUserInfo[1][13]  
cUserMail	:= aUserInfo[1][14]
OLE_SetDocumentVar(hWord,'cUserName'	,cUserName)
OLE_SetDocumentVar(hWord,'cUserCarg'	,cUserCarg)
OLE_SetDocumentVar(hWord,'cUserMail'	,cUserMail)

//Atualiza todos os campos do documento DOT (Refresh)
OLE_UpDateFields(hWord)

(cAliasTFF)->(DbCloseArea())

RestArea(aARea)
Return
