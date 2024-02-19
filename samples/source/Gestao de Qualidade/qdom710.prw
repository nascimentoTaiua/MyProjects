#INCLUDE "TOTVS.CH"

/*/{Protheus.doc} qdom710
Transfere os valores das var. de memoria para var. do word 
@type  User Function
@author Programacao Quality 
@since 31/05/2019
@version 12
@see http://tdn.totvs.com/pages/viewpage.action?pageId=6801951
/*/
 
User Function qdom710()
	//objeto oWord é private no programa origem

	//Variaveis do .DOT Padrao
	OLE_SetDocumentVar( oWord, "variavel_doc1"        , "conteudo variavel 1" )
	OLE_SetDocumentVar( oWord, "variavel_doc2"        , "conteudo variavel 2" )
	OLE_SetDocumentVar( oWord, "variavel_doc3"        , "conteudo variavel 3" )

Return

