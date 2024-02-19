#include "TopConn.ch"
/////////////////////
/// Ita - 13/12/2023
///       Pontos de Entradas usados para personalizar a base de cálculo do ICMS ST de acordo
///       com as necessidades da PanCrystal.
///       M410SOLI
///       M460SOLI
///////////////////////////////
/*
    Ponto-de-Entrada: M410SOLI - Retorno do valor de ICMS
    Descrição:
    Este ponto de entrada retorna o valor do ICMS Solidario para ser demonstrado na planilha financeira do pedido de vendas.

    Para realizar todo o processo corretamente deve utilizar em conjunto com o ponto de entrada M460SOLI com o mesmo tratamento do ponto M410SOLI.

    Para que as informações do pedido de vendas e da nota fiscal de saída fiquem iguais.

    Programa Fonte
    .PRW
    Sintaxe
    M410SOLI - Retorno do valor de ICMS ( < UPAR> ) --> aSolid

    Parâmetros:

    Retorno
    aSolid
    (vetor)
    Deve retornar um array com a seguinte estrutura:

    1 - Base de retenção de ICMS
    2 - Valor do ICMS solidário
    3 - Margem de Valor Agregado
    4 - Alíquota Solidário
    5 - Base do FECP-ST
    6 - Aliquota do FECP-ST
    7 - Valor do FECP-ST

    Obs.: Caso não seja retornado o array corretamente com a estrutura descrita acima, 
    o programa ira fazer os devidos calculos não considerando o P.E. em questão.

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Ponto de Entrada M410SOLI para alterar os valores do ICM Solidario referente a palnilha financeira³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lM410Soli
			ICMSITEM    := MaFisRet(nItem,"IT_VALICM")		// variavel para ponto de entrada
			QUANTITEM   := MaFisRet(nItem,"IT_QUANT")		// variavel para ponto de entrada
			BASEICMRET  := MaFisRet(nItem,"IT_BASESOL")	    // criado apenas para o ponto de entrada
			MARGEMLUCR  := MaFisRet(nItem,"IT_MARGEM")		// criado apenas para o ponto de entrada
			aSolid := ExecBlock("M410SOLI",.f.,.f.,{nItem}) 
			aSolid := IIF(ValType(aSolid) == "A" .And. Len(aSolid) == 2, aSolid,{})
			If !Empty(aSolid)
				MaFisLoad("IT_BASESOL",NoRound(aSolid[1],2),nItem)
				MaFisLoad("IT_VALSOL" ,NoRound(aSolid[2],2),nItem)
				MaFisEndLoad(nItem,1)
                aAdd(aTotSolid, { nItem , NoRound(aSolid[1],2) , NoRound(aSolid[2],2)} )
			Endif
		EndIf    
*/
User Function M410SOLI
    
    Local xArea := GetArea()
    Local _cUFDest := C5_UFDEST
    Local nItem := ParamIxb[1]
    aSolid :=   {}
    Private _Enter  := chr(13) + Chr(10)
    //Ita - 19/01/2024 - _aRetPauta := fGetCFC(SM0->M0_ESTENT,_cUFDest,SB1->B1_COD)
    _nBasICMRt := 0
    _nVlICMRt  := 0
    _cPrdC6 := aCols[nItem, aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRODUTO"}) ]
    _nQtdC6 := aCols[nItem, aScan(aHeader,{|x| AllTrim(x[2]) == "C6_QTDVEN"}) ]
    _cTESC6 := aCols[nItem, aScan(aHeader,{|x| AllTrim(x[2]) == "C6_TES"}) ]
    _cSitTrb := Posicione("SF4",1,FWxFilial("SF4")+_cTESC6,"F4_SITTRIB")
    _nPsoC6 := Posicione("SB1",1,FWxFilial("SB1")+_cPrdC6,"B1_PESO")
    
    _aRetPauta := fGetCFC(SM0->M0_ESTENT,_cUFDest,_cPrdC6)
    _nPautPrd := _aRetPauta[1]
    _nMargPrg := _aRetPauta[2]
    _nAlqFCP  := _aRetPauta[3]

    If (_nPautPrd + _nMargPrg + _nAlqFCP) > 0 

        _nPrcPaut := (_nPsoC6 * _nPautPrd * _nQtdC6)
        _nBASEICM    := MaFisRet(nItem,"IT_BASEICM")
        _nBasICMRt := BASEICMRET
        _nVlICMRt  := ICMSITEM
        _nMrgLucr  := MARGEMLUCR
        _nValICM   := MaFisRet(nItem,"IT_VALICM")
        _nAlqST := MaAliqSoli(nItem)    
        If _nPrcPaut > GdFieldGet("C6_VALOR",nItem)
            _nBasICMRt := _nPrcPaut
            //_nVlICMRt  := _nBasICMRt * (_nAlqST / 100)
            _nMVACalc  := ( _nBasICMRt * (_nMargPrg / 100) )
            _nBasICMRt := _nBasICMRt + _nMVACalc
            _nVlICMRt  := ( _nBasICMRt * (_nAlqST / 100) ) - _nValICM
            //_nVlrFCP   := (_nBasICMRt * (_nAlqFCP / 100)) 
            //MsgInfo("nItem: ["+CVALTOCHAR( nItem )+"] Alltrim(_cSitTrb): ["+Alltrim(_cSitTrb)+"] _cPrdC6: ["+_cPrdC6+"] _nBasICMRt: ["+CVALTOCHAR( _nBasICMRt )+"] _nBASEICM: ["+CVALTOCHAR( _nBASEICM )+"]","Atenção!")
            If Alltrim(_cSitTrb) $ '10|30|70'
                _nBsFECP := _nBasICMRt
            Else
                _nBsFECP := _nBASEICM
            EndIf
            _nVlrFCP   := (_nBsFECP * (_nAlqFCP / 100)) 
        //EndIf
            
            aSolid :=   {   ;
                            _nBasICMRt  ,;    //1 - Base de retenção de ICMS
                            _nVlICMRt   ,;    //2 - Valor do ICMS solidário
                            _nMrgLucr   ,;    //3 - Margem de Valor Agregado
                            _nAlqST     ,;    //4 - Alíquota Solidário
                            _nBsFECP    ,;    //5 - Base do FECP-ST
                            _nAlqFCP    ,;    //6 - Aliquota do FECP-ST
                            _nVlrFCP     ;    //7 - Valor do FECP-ST
                        }
                    /*
            aSolid :=   {   ;
                            _nBasICMRt  ,;    //1 - Base de retenção de ICMS
                            _nVlICMRt    ;    //2 - Valor do ICMS solidário
                        }
                        cpare:=""
                        */
        EndIf

    EndIf
    //MsgInfo("PE M410SOLI nItem: ["+CVALTOCHAR( nItem )+"] PRODUTO: ["+_cPrdC6+"] Len(aSolid): ["+CVALTOCHAR( Len(aSolid) )+"] _nPautPrd: ["+CVALTOCHAR( _nPautPrd )+"] _nMargPrg: ["+CVALTOCHAR( _nMargPrg )+"] _nAlqFCP: ["+CVALTOCHAR( _nAlqFCP )+"] _nBasICMRt: ["+CVALTOCHAR( _nBasICMRt )+"] _nVlICMRt: ["+CVALTOCHAR( _nVlICMRt )+"]","Atenção!")
    RestArea(xArea)
Return(aSolid)

/*
    Ponto-de-Entrada: M460SOLI - Calcula base de retenção ICMS e valor de ICMS Solidário

    Descrição:
    Este ponto de entrada tem a finalidade de calcular a base de retenção de ICMS e o valor do ICMS solidário.
    Programa Fonte
    MATA461.PRX
    Sintaxe
    M460SOLI - Calcula base de retenção ICMS e valor de ICMS Solidário ( [ _nItem ], [ _cItemSC6 ] ) --> aRet

    Parâmetros:  

    Retorno
    aRet
    (array_of_record)
    Este PE deverá retornar um Array contendo:

    1 - Base de retenção de ICMS
    2 - Valor do ICMS solidário
    3 - Margem de Valor Agregado
    4 - Alíquota Solidário
    5 - Base do FECP-ST
    6 - Aliquota do FECP-ST
    7 - Valor do FECP-ST


    Se este PE não retornar o array com a estrutura descrita acima, o programa ignorará o PE e o sistema 
    fará os devidos cálculos.
*/

User Function M460SOLI()

    Local xArea := GetArea()
    Local _nItem := ParamIxb[1]                         //Item do aCols
    Local _cItemSC6 := ParamIxb[2]                      //Item do Pedido de Venda (C6_ITEM)
    Local _nBaseSol := MaFisRet(_nItem,"IT_BASESOL")    //Base de retencao ICMS Solidario
    Local _nValSol := MaFisRet(_nItem,"IT_VALICM")      //Valor do ICMS Solidario
    Local _nMargem := MaFisRet(_nItem,"IT_MARGEM")      //Margem de Valor Agregado
    Local _nQtdIt  := MaFisRet(_nItem,"IT_QUANT")       //Quantidade do Item
    Local _nValICM   := MaFisRet(_nItem,"IT_VALICM")     //Valor do ICMS Normal
    Local _nPsoPrd := Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_PESO")
    Local _cUFDest := Posicione("SA1",1,xFilial("SA1")+SC6->C6_CLI+SC6->C6_LOJA,"A1_EST")
    Local _nAliqSol := MaAliqSoli(_nItem)               //Alíquota Solidário
    Local _nBaseFCP := 0                                //Base do FCP-ST
    Local _nAliqFCP := 0                                //Aliquota do FCP-ST
    Local _nValFCP := 0                                 //Valor do FCP-ST
    Private _Enter  := chr(13) + Chr(10)    
    //Atencao: O FCP-ST compõe o valor do ICMS-ST. 
    //Portanto seu valor deve ser somado ao valor "final" de ICMS-ST.
    //Alert("Passou pelo PE: M460SOLI -> nItem: " + AllTrim(Str(_nItem)) + " - nItemSC6: " + AllTrim(_cItemSC6))
    _aRetPauta := fGetCFC(SM0->M0_ESTENT,_cUFDest,SC6->C6_PRODUTO)
    _nPautPrd  := _aRetPauta[1]
    _nMargPrg  := _aRetPauta[2]
    _nAlqFCP  := _aRetPauta[3]
    _nPrcPaut  := (_nPsoPrd * _nPautPrd * _nQtdIt)    

    _nBaseSol  := _nPrcPaut
    _nMVACalc  := ( _nBaseSol * (_nMargPrg / 100) )
    _nBaseSol  := _nBaseSol + _nMVACalc
    _nValSol   := ( _nBaseSol * (_nAliqSol / 100) ) - _nValICM
    _nBaseFCP  := _nBaseSol
    _nAliqFCP  := _nAlqFCP
    _nValFCP   := (_nBaseSol * (_nAlqFCP / 100))

    If !(_nPrcPaut > SC6->C6_VALOR)
        //_nBaseSol := _nPrcPaut
        //_nValSol  := _nBaseSol * (_nAliqSol / 100)
    //else
        RestArea(xArea)
        Return {}
    EndIf

    RestArea(xArea)
Return {_nBaseSol,_nValSol,_nMargem,_nAliqSol,_nBaseFCP,_nAliqFCP,_nValFCP}

Static Function fGetCFC(pUFOrig,pUFDest,pCodPrd)
    
    cQryCFC := " SELECT CFC.CFC_VL_ICM, CFC.CFC_MARGEM, CFC.CFC_ALQFCP " + _Enter
    cQryCFC += "   FROM "+RetSQLName("CFC")+" CFC " + _Enter
    cQryCFC += "  WHERE CFC.CFC_FILIAL = '"+FWxFilial("CFC")+"'" + _Enter
    cQryCFC += "    AND CFC.CFC_UFORIG = '"+pUFOrig+"'" + _Enter
    cQryCFC += "    AND CFC.CFC_UFDEST = '"+pUFDest+"'" + _Enter
    cQryCFC += "    AND CFC.CFC_CODPRD = '"+pCodPrd+"'" + _Enter
    cQryCFC += "    AND CFC.D_E_L_E_T_ <> '*'" + _Enter

    MemoWrite("C:\TEMP\fGetCFC.SQL",cQryCFC)
    MemoWrite("fGetCFC.SQL",cQryCFC)

    TCQuery cQryCFC NEW ALIAS "XCFC" 

    TCSetField("XCFC","CFC_VL_ICM","N",TamSX3("CFC_VL_ICM")[1],TamSX3("CFC_VL_ICM")[2])
    TCSetField("XCFC","CFC_MARGEM","N",TamSX3("CFC_MARGEM")[1],TamSX3("CFC_MARGEM")[2])
    TCSetField("XCFC","CFC_ALQFCP","N",TamSX3("CFC_ALQFCP")[1],TamSX3("CFC_ALQFCP")[2])

    DbSelectArea("XCFC")
        nPtICMPr := XCFC->CFC_VL_ICM
        nPtMrgPr := XCFC->CFC_MARGEM
        nAlqFCP  := XCFC->CFC_ALQFCP
    DbCloseArea()

Return({nPtICMPr,nPtMrgPr,nAlqFCP})


