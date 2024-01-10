#INCLUDE 'PROTHEUS.CH'

/*/{Protheus.doc} FIRSTNFSE
    Este ponto de entrada tem a finalidade de executar a manipulação do 
    array aRotina utilizado pelo menu da Nota Fiscal de Serviço Eletrônica.
    @type  Function
    @author Taiuã Nascimento | TOTVS Nordeste
    @since 09/01/2024
    @version 1.01
    @see (links_or_references)
/*/

User Function FIRSTNFSE()

    aadd(aRotina ,{'Impressao NFS-e', 'U_ZNFSE', 0, 3, 0, NIL})

Return Nil
