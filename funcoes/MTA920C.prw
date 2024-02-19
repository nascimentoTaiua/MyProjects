/*/{Protheus.doc} nomeFunction
    (long_description)
    @type  Function
    @author user
    @since 09/02/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function MTA920C()

    If !Empty(SF2->F2_CODNFE)
        SF2->F2_XMUNDES := SF2->F2_CODNFE
        SF2->F2_CODNFE := ""
    EndIf
    
Return
