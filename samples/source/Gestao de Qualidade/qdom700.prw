#INCLUDE "TOTVS.CH" 

/*/{Protheus.doc} qdom700
Ponto de entrada para ajustar o formato de integração com office
@type  User Function
@author Programacao Quality 
@since 31/05/2019
@version 12
@see http://tdn.totvs.com/pages/viewpage.action?pageId=6801951
/*/

User Function Qdom700()

/*/ COMENTARIOS
	Declaracao de variaveis utilizadas no programa atraves da funcao
	SetPrvt, que criara somente as variaveis definidas pelo usuario,
	identificando as variaveis publicas do sistema utilizadas no codigo
	Incluido pelo assistente de conversao do AP5 IDE
/*/
SetPrvt("CEDIT,CEDITOR,") // variávels cEdit e cEditor são private no progama origem

/*/ COMENTARIOS
	A váriável cEditor tem o valor default = "TMsOleWord97"
	Exemplo de utilização e alteração das variáveis
	O valor do cEdit e montado pelo parametro MV_QDTIPED e devera
	conter um dos parametros abaixo:
/*/

/*
	//   Aqui deve-se colocar os elseif necessarios para determinar
	//   qual o editor de texto deve-se usar.  Em 14 Set 1999 estao
	//   disponiveis apenas no Word7(Office95) e Word8(Office97).
	If AllTrim(cEdit) == "WORD95"
		cEditor := "TMsOleWord95"
	ElseIf Alltrim(cEdit) == "WORD97"
		cEditor := "TMsOleWord97"
	EndIf
*/

Return
