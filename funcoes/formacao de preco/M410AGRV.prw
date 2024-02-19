#Include "PROTHEUS.ch"
#Include "parmtype.ch"

/*/{Protheus.doc} MT410INC
  Este ponto de entrada pertence � rotina de pedidos de venda, MATA410().
  Est� localizado na rotina de altera��o do pedido, A410INCLUI().
  � executado ap�s a grava��o das informa��es.

  @type  Function
  @author Taiu� Nascimento
  @since 04/01/2024
  @version 1.01
/*/

User Function MT410AGRV()
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
                Reclock("SC5",.F.)
                Replace SC5->C5_BLQ with "1"
                SC5->(MsUnlock())
            ENDIF
            
		ENDIF
	Next
  
    RestArea(aArea)
Return lRet
