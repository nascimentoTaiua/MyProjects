#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "COLORS.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PRODSEQ  ºAutor  ³ TOTVS NORDESTE     º Data ³ 04/11/2011  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Gera codigo do Produto automatico, concatenando o codigo   º±±
±±º          ³ do Grupo de Produto + Seguencial automatico.   º±±
±±º          ³ -> [ B1_GRUPO + Sequencial ], sendo seu formato:   º±±
±±º          ³  GRUPO + SEGUENCIAL                                º±±
±±º          ³   9999  +   .   + 999999                                   º±±
±±º          ³                                                            º±±
±±º          ³ PARAMETROS                                                 º±±
±±º          ³	Recebe:                                                   º±±
±±º          ³		NIHIL                                                 º±±
±±º          ³                                                            º±±
±±º          ³  Devolve:                                                  º±±
±±º          ³		_cUP --> Numero seguencial do Produto do tipo         º±±
±±º          ³               caracter de 10 possicoes                     º±±
±±º          ³                                                            º±± 
±±º          ³ PROCEDIMENTOS PARA INSTALACAO                              º±±
±±º          ³    1. Criar gatilhos para alimentar o campo do codigo do   º±±
±±º          ³       produto;                                             º±±
±±º          ³       Campo........: B1_GRUPO                              º±±
±±º          ³       Cnt. Dominio.: B1_COD                                º±±
±±º          ³       Regra........: U_ProdSEQ() ou                        º±±
±±º          ³                      EXECBLOCK("ProdSEQ",.F.,.F.)          º±±
±±º          ³                                                            º±±
±±º          ³    2. Alterar a propriedade e a ordem dos campos abaixo;   º±±
±±º          ³       Campo........: B1_COD                                º±±
±±º          ³       Propriedade..: Visualizar                            º±±           
±±º          ³       Ordem;                                               º±±
±±º          ³          1. B1_FILIAL                                      º±±
±±º          ³          2. B1_GRUPO                                       º±±         
±±º          ³          3. B1_COD                                         º±±
±±º          ³                                                            º±±
±±º          ³    3. Aplicar no Inic. Padrao do campo [SB1->B1_COD] a     º±±
±±º          ³       Expressao: [ IIF(LCOPIA,U_PRODSEQ(),SPACE(15)) ]     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Geracao automatica dos codigos dos produtos                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlterado  ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ProdSEQ()
Local cUltimo	:= ""
Local nTAM_GRU	:= 4
Local nTAM_COD 	:= 6

//-- Declaracao de Variaveis
SetPrvt("_xGrp,_xRETORNO,_nUP,_cALIAS,_nRECNO,_nORDEM,_n")

//-- Retorna sem efetuar modificações caso não esteja em modo de INCLUSAO
If !INCLUI 
	Return()
Endif

//-- Salva a area corrente
_cALIAS := SELECT()
_nORDEM := INDEXORD()
_nRECNO := RECNO()

//-- Para atender a necessidade de gerar um codigo novo quando
//-- da acao de COPIA
cGrupo	:= Iif(lCopia,SB1->B1_GRUPO,M->B1_GRUPO)

//-- Tratamento de excessao para MOD - Mao de Obra Direta
If Alltrim(cGrupo) != "MOD"
	//-- Verifica tamnaho do Campo Grupo para garantir a integridade do sistema
	If Len(AllTrim(cGrupo)) > nTAM_GRU
		MsgInfo('Esse grupo não pode montar um codigo de produto, verifique o tamanho do codigo.')
		cGrupo   := " "
		Return(cGrupo)	
	Endif
	//-- Implemento + 1 no Codigo do Produto
	cUltimo		:= xGetCodGrp(cGrupo)			//-- Funcao que devolve o ultimo Codigo utilizado no Grupo 
	_xRETORNO	:= SUBSTR(alltrim(cUltimo),nTAM_GRU+1,6)		
	_xRETORNO	:= Iif(Empty(_xRETORNO),Strzero(0,nTAM_COD),_xRETORNO)			
	_nUP		:= INT(VAL(_xRETORNO)+1)
	_cUP		:= AllTrim(cGrupo)+Strzero(_nUP,nTAM_COD)
Endif
dbSelectArea(_cALIAS)
dbSetOrder(_nORDEM)
RECNO(_nRECNO)
Return(_cUP)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³XGETCODGRPº Autor ³ TOTVS NORDESTE     º Data ³ 11/11/2011  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Descr.   ³ Funcao que verifica qual ultimo comdigo utilizado para um  º±±
±±º          ³ determinado Grupo de produtos.                             º±±
±±º          ³ PARAMETROS                                                 º±±
±±º          ³   Recebe:  pGrupo - Codigo do Grupo                        º±±
±±º          ³  Devolve: cCodpro - Ultimo Codigo de Produto Utilizado no  º±±
±±º          ³                     no Grupo                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Metro do Recife - CBTU/Metrorec                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function xGetCodGrp(pGrupo)
Local aAreaAnt  	:= GetArea()		//-- Salva Ambiente Anterior
Local cQuery   		:= ""				//-- String utilizada para montagem da query
Local cCodPro		:= ""

cQuery += "Select *"
cQuery += "from " + RetSQLName("SB1")
cQuery += " where B1_FILIAL  = '"+xFilial("SB1")+"'"
cQuery += " and D_E_L_E_T_ != '*' "
cQuery += " and B1_GRUPO = '"+pGrupo+"'"
cQuery += " Order by B1_COD DESC"		//-- Ordena GRUPO na ordem DECENDENTE
cQuery := ChangeQuery(cQuery)
TCQuery cQuery ALIAS TEMP_SB1 NEW      

dbSelectArea("TEMP_SB1")
TEMP_SB1->(DBGotop())				//-- Joga o ponteiro para primeiro registro do arquivo.
cCodPro := TEMP_SB1->B1_COD
dbCloseArea()						//-- Fecha o Arquivo temporario
RestArea(aAreaAnt) 					//-- Restaura Ambiente Anterior

Return cCodPro
