#INCLUDE "protheus.ch"
#INCLUDE "totvs.ch"
    
    /*/{Protheus.doc} FORMAPRECO
    Função de Usuário para realizar a formação de preço na inclusão do pedido de venda.
    @type  Function
    @author Taiuã Nascimento
    @since 28/12/2023
    @version 1.01
    @param MV_ZIMPOST, MV_ZIMPOCE, MV_ZMARGEM
    @return nRob
    /*/

User Function FORMAPRECO()

    Local nRob           := 0
    Local cCliente       := M->C5_CLIENTE
    Local cLoja          := M->C5_LOJACLI
    Local cEstado        := Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_EST")
    Local nComis         := Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_COMIS")
    Local nTrade         := Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_XTRADE")
    Local nContrato      := Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_X_PDFIN")
    Local nImposto       := GETMV("MV_ZIMPOST")
    Local nImpostoCe     := GETMV("MV_ZIMPOCE")
    Local nMargem        := GETMV("MV_ZMARGEM")
    Local nPosProd       := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRODUTO"})
    Local nPreco         := Posicione("SB1",1,xFilial("SB1")+aCols[n,nPosProd],"B1_PRV1")
    Local nRoyalt        := Posicione("SB1",1,xFilial("SB1")+aCols[n,nPosProd],"B1_XROYLIC")
    Local nFrete         := 0
    Local nPosTotal      := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_VALOR"})
    Local nPosPrecoLista := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRUNIT"})
    Local nValorTotal    := 0
    
    Local nRol           := ROUND(nPreco/(1-((nRoyalt+nComis+nTrade)/100)),4)

    //Bloco de validação e busca de acordo com o tipo de frete e tipo de local (CD ou Fazenda)
    IF (M->C5_TPFRETE == "C" .AND. M->C5_XLOCAL == "C")
        nFrete := Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_XFRETE1")
        nRol   := ROUND(nRol + nFrete,4)
    ELSEIF (M->C5_TPFRETE == "C" .AND. M->C5_XLOCAL == "F")
        nFrete := Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_XFRETE2")
        nRol   := ROUND(nRol + nFrete,4)
    ELSEIF (M->C5_TPFRETE == "F" .AND. M->C5_XLOCAL == "C")
        nFrete := Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_XFRETE3")
        nRol   := ROUND(nRol + nFrete,4)
    ENDIF

    //Validação da UF do cliente para verificar se o mesmo pertence ao estado do Ceará
    IF (cEstado == "CE")
        nRol := ROUND(nRol/(1-((nContrato+nImposto)/100)) + nImpostoCe,4)
    ELSE
        nRol := ROUND(nRol/(1-((nContrato+nImposto)/100)),4)
    ENDIF

    //Validar se o preço de venda é maior que zero, caso contrário retorna alerta de aviso e não atualiza o preço
    IF (nPreco > 0)
        nRob                    := ROUND(nRol/(1-(nMargem/100)),2)
        aCols[n,nPosPrecoLista] := nRob
        nValorTotal             := ROUND(nRob * M->C6_QTDVEN,2)
        aCols[n,nPosTotal]      := nValorTotal
    ELSE
        MSGINFO("Produto sem preço de venda informado.","Formação de Preço")
    ENDIF

Return nRob
