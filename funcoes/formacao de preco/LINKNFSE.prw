#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} nomeFunction
    (long_description)
    @type  Function
    @author user
    @since 08/01/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/

User Function LINKNFSE()

    Local aArea := GetArea()

    DBSELECTAREA("SF2")

    Local aPergs       := {}
    Local paramRps     := Space(TamSX3( 'F2_DOC' )[01])
    Local paramSerie   := Space(TamSX3( 'F2_DOC' )[01])
    Local paramCliente := Space(TamSX3( 'A1_COD' )[01])
    Local paramLoja    := Space(TamSX3( 'A1_LOJA' )[01])
    Local cTipoNota    := "N"
    Local cInscricao   := "3420086"
    Local cRps         := ""
    Local cSerie       := ""
    Local cCliente     := ""
    Local cLoja        := ""
    Local cNfse        := ""
    Local cProtocolo   := ""
    Local cLink        := ""

    aadd(aPergs, {1, "RPS"        , paramRps    , "", ".T.", "SF2", ".T.", 80, .F.})
    aadd(aPergs, {1, "Serie Docto", paramSerie  , "", ".T.", ""   , ".T.", 80, .T.})
    aadd(aPergs, {1, "Cliente"    , paramCliente, "", ".T.", ""   , ".T.", 80, .T.})
    aadd(aPergs, {1, "Cliente"    , paramLoja   , "", ".T.", ""   , ".T.", 80, .T.})

    If Parambox(aPergs, "Informe os Parâmetros")
        Alert(MV_PAR01)
        Alert(MV_PAR02)
        Alert(MV_PAR03)
        Alert(MV_PAR04)
    ENDIF

    cRps     := ALLTRIM(MV_PAR01)
    cSerie   := ALLTRIM(MV_PAR02)
    cCliente := ALLTRIM(MV_PAR03)
    cLoja    := ALLTRIM(MV_PAR04)

    cNfse      := Posicione("SF2",18,XFILIAL("SF2")+cRps+cSerie+cCliente+cLoja+cTipoNota,"F2_NFELETR")
    cProtocolo := Posicione("SF2",18,XFILIAL("SF2")+cRps+cSerie+cCliente+cLoja+cTipoNota,"F2_CODNFE")

    alert(cNfse+cProtocolo)
    alert(cRps+cSerie+cCliente+cLoja)

    SF2->(DbCloseArea())

    RestArea(aArea)

    //cLink      := "https://nfse.recife.pe.gov.br/contribuinte/notaprint.aspx?ccm="+cInscricao+"&nf="+cNfse+"&cod="+SubStr(cProtocolo, 1, 4)
    
    //ShellExecute("Open", cLink, "", "", 1)
    
Return
