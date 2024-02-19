//Bibliotecas
#INCLUDE 'protheus.ch'
#INCLUDE 'totvs.ch'

/*/{Protheus.doc} nomeFunction
    (long_description)
    @type  Function
    @author user
    @since 04/01/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/

User Function M410STTS()

    Local nOper := PARAMIXB[1]
    Local aArea       := GetArea()

    Local cPedido := M->C5_NUM

    DbSelectArea('SC5')
    SC5->(DbGoTo(cPedido))

    Local nT          := 0
    Local nPosPrcVen  := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRCVEN"})
    Local nPosPrUnit  := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRUNIT"})
    Local nDesconto   := 0
    Local nPDesconto  := 0
    Local nPrecoVenda := 0
    Local nPrecoUnit  := 0

//Verifica se a operação é de copiar o registro
If nOper == 6
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
EndIf
    
Return Nil
