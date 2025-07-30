#INCLUDE 'topconn.ch'
#INCLUDE 'protheus.ch'
#INCLUDE 'totvs.ch'

/*/{Protheus.doc} zNfse
    Função para chamar o link da NFS-e, de acordo com a RPS informada. 
    @type  Function
    @author Taiuã Nascimento | TOTVS Nordeste
    @since 09/01/2024
    @version 1.02
    Obs1: Necessário criar consulta padrão da SF2 que retorne F2_DOC, F2_SERIE, F2_CLIENTE e F2_LOJA.
    Obs2: Criar campo na tabela CC2->CC2_XLINK, nesse campo será informado a estrutura da URL para
    Vizualização da NFS-e emitida pela respectiva prefeitura.
/*/

User Function zNfse()

    Local aPergs       := {}
    Local paramRps     := Space(TamSX3( 'F2_DOC' )[01])
    Local paramSerie   := Space(TamSX3( 'F2_SERIE' )[01])
    Local paramCliente := Space(TamSX3( 'A1_COD' )[01])
    Local paramLoja    := Space(TamSX3( 'A1_LOJA' )[01])
    Local cInscricao   := SM0->M0_INSCM //Campo utilizado na chamada do link na linha 46
    Local cMunicipio   := SubStr(SM0->M0_CODMUN, 3, 5)
    Local cEstado      := SM0->M0_ESTENT
    Local cNfs         := ""
    Local cProtocolo   := ""
    Local cLink        := ""

    aadd(aPergs, {1, "RPS"        , paramRps    , "", ".T.", "SF2NFS"   , ".T.", 80, .F.})
    aadd(aPergs, {1, "Serie Docto", paramSerie  , "", ".T.", "", ".T.", 80, .F.})
    aadd(aPergs, {1, "Cliente"    , paramCliente, "", ".T.", ""   , ".T.", 80, .F.})
    aadd(aPergs, {1, "Loja"       , paramLoja   , "", ".T.", ""      , ".T.", 80, .F.})

    IF Parambox(aPergs, "Informe os Parâmetros")
        
        cNfs       := AllTrim(Posicione( 'SF2' ,1,FWxFilial( 'SF2' )+MV_PAR01+AllTrim(MV_PAR02)+MV_PAR03+MV_PAR04+ ' ' + 'N' , 'F2_NFELETR' ))

        cNfs       := Strzero(Val(cNfs),TamSX3("F2_DOC")[1])
        cProtocolo := AllTrim(Posicione( 'SF2' ,1,FWxFilial( 'SF2' )+MV_PAR01+AllTrim(MV_PAR02)+MV_PAR03+MV_PAR04+ ' ' + 'N' , 'F2_CODNFE' ))
        cProtocolo := LEFT(cProtocolo, 4)+RIGHT(cProtocolo, 4)

        IF (cNfs == "" .AND. cProtocolo == "")
            cMsg := "Nota ainda nao autorizada. Selecione uma nota com codigo de verificacao. "
            cMsg += "Verifique o conteúdo dos campos F2_NFELETR e F2_CODNFE"
            MSGALERT(cMsg)
        ELSE
            cLink := GetMV("MV_XNFSLNK")
            ShellExecute("Open", &(cLink), "", "", 1)
        ENDIF
    ENDIF

Return
