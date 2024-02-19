#Include "PROTHEUS.ch"
#Include "parmtype.ch"

/*/{protheusDoc.marcadores_ocultos} MATA410
  Função MT410INC
  @author Totvs Nordeste - Anderson Almeida

  @sample
// MT410INC - Ponto de entrada no fim da gravação do Pedido de venda.
               - Grava o fator da comissão de venda.
  Return
  @história
  25/03/2021 - Desenvolvimento da Rotina.
/*/
User Function MT410CPY()
    Local aArea       := GetArea()
    Local lRet := .T.
  
    Local nT          := 0
    Local nPosPrcVen  := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRCVEN"})
    Local nPosPrUnit  := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRUNIT"})
    Local nDesconto   := 0
    Local nPDesconto  := 0
    Local nPrecoVenda := 0
    Local nPrecoUnit  := 0

    For nT:=1 to Len(aCols)
		If !aCols[nT,Len(aHeader)+1]
            nPrecoVenda := aCols[nT,nPosPrcVen]
            nPrecoUnit  := aCols[nT,nPosPrUnit]
            nDesconto   := nPrecoUnit - nPrecoVenda
            nPDesconto  := ROUND((nDesconto * 100) / nPrecoUnit,2)
            
            If nPDesconto > 5
                Reclock("SC5",.T.)
                Replace SC5->C5_BLQ with "1"
                SC5->(MsUnlock())
            ENDIF
            
		ENDIF
	Next
  
    RestArea(aArea)
Return lRet
