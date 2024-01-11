#INCLUDE 'TOPCONN.CH'
#INCLUDE 'PROTHEUS.CH'

/*/{Protheus.doc} zNfse
    Função para abrir via navegador a NFS da Prefeitura do Recife
    @type  Function
    @author Taiuã Nascimento | TOTVS Nordeste
    @since 09/01/2024
    @version 1.01
    @see (https://nfse.recife.pe.gov.br/arquivos/WsNFSeNacional.pdf) "página 14"
    Obs2: Necessário criar consulta padrão da SF2 que retorne F2_DOC, F2_SERIE, F2_CLIENTE e F2_LOJA.
/*/

User Function zNfse()

    Local aPergs       := {}
    Local paramRps     := Space(TamSX3( 'F2_DOC' )[01])
    Local paramSerie   := Space(TamSX3( 'F2_SERIE' )[01])
    Local paramCliente := Space(TamSX3( 'A1_COD' )[01])
    Local paramLoja    := Space(TamSX3( 'A1_LOJA' )[01])
    Local cInscricao   := SM0->M0_INSCM
    Local cNfs         := ""
    Local cProtocolo   := ""
    Local cLink        := ""

    aadd(aPergs, {1, "RPS"        , paramRps    , "", ".T.", "SF2NFS"   , ".T.", 80, .F.})
    aadd(aPergs, {1, "Serie Docto", paramSerie  , "", ".T.", "", ".T.", 80, .F.})
    aadd(aPergs, {1, "Cliente"    , paramCliente, "", ".T.", ""   , ".T.", 80, .F.})
    aadd(aPergs, {1, "Loja"       , paramLoja   , "", ".T.", ""      , ".T.", 80, .F.})

    IF Parambox(aPergs, "Informe os Parâmetros")
        cNfs       := AllTrim(Posicione( 'SF2' ,1,FWxFilial( 'SF2' )+MV_PAR01+AllTrim(MV_PAR02)+MV_PAR03+MV_PAR04+ ' ' + 'N' , 'F2_NFELETR' ))
        cProtocolo := AllTrim(Posicione( 'SF2' ,1,FWxFilial( 'SF2' )+MV_PAR01+AllTrim(MV_PAR02)+MV_PAR03+MV_PAR04+ ' ' + 'N' , 'F2_CODNFE' ))
        cProtocolo := LEFT(cProtocolo, 4)+RIGHT(cProtocolo, 4)

        IF (cNfs == "" .AND. cProtocolo == "")
            cMsg := "Nota ainda nao autorizada. Selecione uma nota com codigo de verificacao. "
            cMsg += "Verifique o conteúdo dos campos F2_NFELETR e F2_CODNFE"
            MSGALERT(cMsg)
        ELSE
            cLink := "https://nfse.recife.pe.gov.br/contribuinte/notaprint.aspx?"
            cLink += "ccm="+cInscricao
            cLink += "&nf="+cNfs
            cLink += "&cod="+cProtocolo

            ShellExecute("Open", cLink, "", "", 1)
        ENDIF
    ENDIF

Return

//Função para buscar o municipio e retornar o link para a função zNfse

User Function zGetLinkMun()
    
Return 
