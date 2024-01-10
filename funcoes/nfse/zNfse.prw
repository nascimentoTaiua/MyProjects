#INCLUDE 'PROTHEUS.CH'

/*/{Protheus.doc} zNfse
    Função para abrir via navegador a NFS da Prefeitura do Recife
    @type  Function
    @author Taiuã Nascimento | TOTVS Nordeste
    @since 09/01/2024
    @version 1.01
    @param MV_ZINSCRM, CHAR, Informar a inscrição municipal para utilização da função customizada zNsfe
    @see (https://nfse.recife.pe.gov.br/arquivos/WsNFSeNacional.pdf) "página 14"
    Obs1: Necessário criar o parâmetro MV_ZINSCRM e informar em seu conteúdo a inscrição municipal.
    Obs2: Necessário criar consulta padrão para SX5 com filtro para tabela 01 Series de N. Fiscais.
/*/

User Function zNfse()

    Local aArea        := GetArea()

    Local aPergs       := {}
    Local paramRps     := Space(TamSX3( 'F2_DOC' )[01])
    Local paramSerie   := Space(TamSX3( 'F2_SERIE' )[01])
    Local paramCliente := Space(TamSX3( 'A1_COD' )[01])
    Local paramLoja    := Space(TamSX3( 'A1_LOJA' )[01])
    Local cInscricao   := SM0->M0_INSCM
    Local cNfs         := ""
    Local cProtocolo   := ""
    Local cLink        := ""

    DbSelectArea("SF2")
    SF2->(DbSetOrder(13))
    SF2->(DbGoTop())

    aadd(aPergs, {1, "RPS"        , paramRps    , "", ".T.", "SF2NFS"   , ".T.", 80, .F.})
    aadd(aPergs, {1, "Serie Docto", paramSerie  , "", ".T.", "", ".T.", 80, .F.})
    aadd(aPergs, {1, "Cliente"    , paramCliente, "", ".T.", ""   , ".T.", 80, .F.})
    aadd(aPergs, {1, "Loja"       , paramLoja   , "", ".T.", ""      , ".T.", 80, .F.})

    IF Parambox(aPergs, "Informe os Parâmetros")
    ENDIF

    cNfs       := AllTrim(Posicione( 'SF2' ,1,FWxFilial( 'SF2' )+MV_PAR01+AllTrim(MV_PAR02)+MV_PAR03+MV_PAR04+ ' ' + 'N' , 'F2_NFELETR' ))
    cProtocolo := AllTrim(Posicione( 'SF2' ,1,FWxFilial( 'SF2' )+MV_PAR01+AllTrim(MV_PAR02)+MV_PAR03+MV_PAR04+ ' ' + 'N' , 'F2_CODNFE' ))

    IF (cNfs != "" .AND. cProtocolo != "")
        cLink := "https://nfse.recife.pe.gov.br/contribuinte/notaprint.aspx?ccm="+cInscricao+"&nf="+cNfs+"&cod="+SubStr(cProtocolo, 1, 4)+SubStr(cProtocolo, 6, 4)
        ShellExecute("Open", cLink, "", "", 1)
    ELSE
        MSGALERT("Verifique os campos F2_CODNFE e F2_NFELETR na tabela SF2","Documento sem informações da NFS-e")
    ENDIF

    RestArea(aArea)

Return
