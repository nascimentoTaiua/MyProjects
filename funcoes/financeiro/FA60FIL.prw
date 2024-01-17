#Include "Protheus.ch"

/*
Teste para o meu amigo Anderson Almeida
*/

 
/*------------------------------------------------------------------------------------------------------*
 | P.E.:  FA60FIL                                                                                       |
 | Desc:  Filtro de registros processados do Borderô                                                    |
 | Links: http://tdn.totvs.com/pages/releaseview.action?pageId=6071248                                  |
 *------------------------------------------------------------------------------------------------------*/
 
User Function FA60FIL()
    
    Local cRet := ""

    //Irá filtrar os títulos com o portador igual ao informado na geração do bordero
    cRet := "E1_PORTADO == cport060"
Return cRet
