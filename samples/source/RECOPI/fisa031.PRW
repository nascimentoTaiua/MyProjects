#INCLUDE "Fisa031.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWIZARD.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "APWEBSRV.CH"        

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Fisa031   ³ Autor ³ Vitor Felipe          ³ Data ³14/07/2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Programa do RECOPI - Sistema de Reconhecimento e Controle   ³±±
±±³          ³das Operacoes com papel imune.  							  ³±± 
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³      ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Fisa031()

Local oWs
Local aArea       := GetArea()
Local cCodMun     := SM0->M0_CODMUN
Local lRetorno    := .T.
Local lOk         := .F.
Local lTabelas	  := AliasIndic("CE3") .And. AliasIndic("CE4") 	

Private lBtnFiltro:= .F.
Private cURL      := Padr(GetNewPar("MV_SPEDURL","http://localhost:8081/RECOPI.apw"),250)
Private cInscMun  := Alltrim(SM0->M0_INSCM)
Private cIdEnt    := GetIdEnt()
Private lDirCert  := .T.  
Private cVerTss   := ""
Private lF2IDRECOP:= SF2->(FieldPos("F2_IDRECOP")) > 0
Private lF1IDRECOP:= SF1->(FieldPos("F1_IDRECOP")) > 0

If !lTabelas
    Alert("Tabelas CE3 e CE4 não localizadas, rodar UPDFIS")
	Return Nil
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Montagem das perguntas                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oWs:= WsSpedCfgNFe():New()
oWs:cUSERTOKEN      := "TOTVS"
oWs:cID_ENT         := cIdEnt
oWS:_URL            := AllTrim(cURL)+"/SPEDCFGNFe.apw"
lOk                 := oWs:CfgTSSVersao()
If lOk
	cVerTss := oWs:cCfgTSSVersaoResult
Else
	Aviso("Recopi",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{STR0114},3)
	If EMPTY(cIdEnt)
		cVerTss := "2.20"
	EndIf
EndIf

While lRetorno
	lBtnFiltro:= .F.
    lRetorno := Fisa031Brw(cCodMun)
    If !lBtnFiltro
    	Exit
    EndIf
EndDo
RestArea(aArea)       			
Return Nil


Static Function Fisa031Brw(cCodMun)
Local aPerg     := {}
Local aCores    := {}
Local lRetorno  := .T.
Local aIndArq   := {}
Local cParBrw   := SM0->M0_CODIGO+SM0->M0_CODFIL+"Fisa031"

PRIVATE cCondicao := ""
PRIVATE aRotina   := Fisa031Men(cCodMun)
PRIVATE cCadastro := "" 
PRIVATE bFiltraBrw
  

If Fisa031Ok(cCodMun)

	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem das perguntas                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	aadd(aPerg,{2,STR0075,PadR("",Len("2-Entrada")),{STR0076,STR0077},120,".T.",.T.,".T."}) //"Tipo de NF"###"1-Saída"###"2-Entrada"
	aadd(aPerg,{2,STR0082,PadR("",Len("1-Sem Filtro")),{STR0083,STR0111,STR0112},120,".T.",.T.,".T."}) //"Filtra"###"1-Sem filtro"###"2-Transmitidas"###"3-Não Transmitidas"
	aadd(aPerg,{1,STR0010,PadR("",Len(SF2->F2_SERIE)),"",".T.","",".T.",30,.F.})	//"Serie da Nota Fiscal"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se o serviço foi configurado - Somente o Adm pode configurar   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If ParamBox(aPerg,"RECOPI",,,,,,,,cParBrw,.T.,.T.)   
		If SubStr(MV_PAR01,1,1) == "1"
			aCores    := {{"F2_RECOPI==' '",'DISABLE' },;	//NF não transmitida
							{"F2_RECOPI=='T'",'ENABLE'}}		//NF Transmitida
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Realiza a Filtragem                                                     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
				cCondicao := "F2_FILIAL=='"+xFilial("SF2")+"'"
				If !Empty(MV_PAR03)
					cCondicao += ".AND.F2_SERIE=='"+MV_PAR03+"'"
				EndIf
				If SubStr(MV_PAR02,1,1) == "2" 		//"2-Transmitidas"
					cCondicao +=  ".AND. F2_RECOPI$'T' "
				ElseIf SubStr(MV_PAR02,1,1) == "3" 		//"3-Não Transmitidas"
					cCondicao += ".AND. F2_RECOPI$' ' " 			
				EndIf
		
				bFiltraBrw := {|| FilBrowse("SF2",@aIndArq,@cCondicao) }
				Eval(bFiltraBrw)
				mBrowse( 6, 1,22,75,"SF2",,,,,,aCores,/*cTopFun*/,/*cBotFun*/,/*nFreeze*/,/*bParBloco*/,/*lNoTopFilter*/,.F.,.F.,)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Restaura a integridade da rotina                                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
				dbSelectArea("SF2")
				RetIndex("SF2")
				dbClearFilter()
				aEval(aIndArq,{|x| Ferase(x[1]+OrdBagExt())})			
			Else
				aCores    := {{"F1_RECOPI==' '",'DISABLE' },;	//NF não transmitida
							{"F1_RECOPI=='T'",'ENABLE'}}			//NF Transmitida

		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Realiza a Filtragem                                                     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
				cCondicao := "F1_FILIAL=='"+xFilial("SF1")+"'"
				If !Empty(MV_PAR03)
					cCondicao += ".AND.F1_SERIE=='"+MV_PAR03+"'"
				EndIf
				If SubStr(MV_PAR02,1,1) == "2" 			//"2-Transmitidas"
					cCondicao +=  ".AND. F1_RECOPI$'T' "
				ElseIf SubStr(MV_PAR02,1,1) == "2" 		//"3-Não Transmitidas"
					cCondicao += ".AND. F1_RECOPI$' ' " 			
				EndIf
		
				bFiltraBrw := {|| FilBrowse("SF1",@aIndArq,@cCondicao) }
				Eval(bFiltraBrw)
				mBrowse( 6, 1,22,75,"SF1",,,,,,aCores,/*cTopFun*/,/*cBotFun*/,/*nFreeze*/,/*bParBloco*/,/*lNoTopFilter*/,.F.,.F.,)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Restaura a integridade da rotina                                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
				dbSelectArea("SF1")
				RetIndex("SF1")
				dbClearFilter()
				aEval(aIndArq,{|x| Ferase(x[1]+OrdBagExt())})			
			EndIf
	EndIf
	Return(lRetorno)
Else
	MsgAlert("Algumas tabelas utilizadas nesta rotina não foram encontradas. Execute os compatibilizadores UPDFIS.")
	Return()
EndIf
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Fisa031Leg³ Autor ³ Vitor Felipe          ³ Data ³14/07/2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Legenda para o Browse do RECOPI							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Fisa031                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³      ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Fisa031Leg(cCodMun)
Local aLegenda := {}
				aCores    := {{"F1_RECOPI==' ','DISABLE'"  },;			//NF não transmitida
							  {"F1_RECOPI=='T','ENABLE'"    }}			//NF transmitida
							  

Aadd(aLegenda, {"ENABLE"    ,STR0078}) //"NF transmitida"
Aadd(aLegenda, {"DISABLE"   ,STR0079}) //"NF não transmitida"

BrwLegenda(cCadastro,STR0117,aLegenda) //"Legenda"

Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Fisa031Men³ Autor ³Vitor Felipe           ³ Data ³14/07/2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Menu principal                                             ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Array com opcoes da rotina.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Parametros do array a Rotina:                               ³±±
±±³          ³1. Nome a aparecer no cabecalho                             ³±±
±±³          ³2. Nome da Rotina associada                                 ³±±
±±³          ³3. Reservado                                                ³±±
±±³          ³4. Tipo de Transa‡„o a ser efetuada:                        ³±±
±±³          ³	  1 - Pesquisa e Posiciona em um Banco de Dados           ³±±
±±³          ³    2 - Simplesmente Mostra os Campos                       ³±±
±±³          ³    3 - Inclui registros no Bancos de Dados                 ³±±
±±³          ³    4 - Altera o registro corrente                          ³±±
±±³          ³    5 - Remove o registro corrente do Banco de Dados        ³±±
±±³          ³5. Nivel de acesso                                          ³±±
±±³          ³6. Habilita Menu Funcional                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Fisa031Men(cCodMun)    

Private aRotina := {}
If cVerTss >= "2.20" .Or. cVerTss >= "12.1.007"
	aRotina := {{"Pesquisar","AxPesqui"		,0,1,0,.F.},; //"Pesquisar"
				{"Wiz. Config.","Fisa031CFG"	,0,2,0 ,NIL},; //"Wiz.Config."
				{"Estoque","Fisa031CEs"	,0,2,0 ,NIL},; //"Controle Estoque"
				{"Solicitações","Fisa031Sol"	,0,2,0 ,NIL},; //"Solicitacoes"
				{"Inclusão NF","Fisa031INf"	,0,2,0 ,NIL},; //"Inclusoes NF"
				{"Confirmações","Fisa031Con"	,0,2,0 ,NIL},; //"Confirmacoes"
				{"Monitor","RecopiMnt1"	,0,2,0 ,NIL},; //"Monitor."
	 			{"Legenda","Fisa031Leg"	,0,2,0 ,NIL}}  //"Legenda"
		
EndIf
	
If ExistBlock("FIRSTNFSE")
	ExecBlock("FIRSTNFSE",.F.,.F.)
EndIf

Return(aRotina)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Fisa031Vis³ Autor ³Vitor Felipe           ³ Data ³14/07/2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Botao para visualizar documentos de saida                   ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Fisa031Vis(cAlias)

If cAlias == "SF2"  
	Mc090Visual("SF2",SF2->(RecNo()),1)
ElseIf cAlias == "SF1"
	A103NFiscal("SF1",SF1->(RecNo()),2)  
EndIf

Return             

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Fisa031Sol³ Autor ³ Vitor Felipe          ³ Data ³14/07/2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina de Solicitacao de Operacoes em Lote.				  ³±±
±±³          ³Service SPED - utilizada em personalizacoes                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³					                                          ³±±
±±³          ³                  					                      ³±±
±±³          ³                                      					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Fisa031Sol()

Local aArea	:= GetArea()
Local oWs
Local lOk		:= .F.
Local cIdSolc	:= ""
Local cCodCtr	:= ""
Local cString	:= ""
Local cRetorno  := ""

Private oRetorno

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Controle de Numeracao ID.                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cIdSolc := AllTrim(RecopiID())
cString := TelaSol("CE3",0,3,cIdSolc)

If !Empty(cString)
	oWS := WSRECOPI():New()
	oWS:cUSERTOKEN := "TOTVS"
	oWS:cID_ENT := cIdEnt
	oWS:_URL := AllTrim(cURL)+"/RECOPI.apw"
   	oWS:OWSRECOPISOLICITACAO:OWSLISTASOLICITACOES := RECOPI_ARRAYOFSOLICITACAO():New()
		
	aadd(oWS:OWSRECOPISOLICITACAO:OWSLISTASOLICITACOES:OWSSOLICITACAO, RECOPI_SOLICITACAO():New())
	     oWS:OWSRECOPISOLICITACAO:OWSLISTASOLICITACOES:OWSSOLICITACAO[1]:CXML:= cString//Encode64(cString)
	     
 	lOk := oWS:RECOPILISTASOLICITACOES()
 	
	If	lOk 
	
		If	oWS:OWSRECOPILISTASOLICITACOESRESULT:CERROGERSTATUS <> "0" 	// Realiza validação para processamento de envio integral
			cRetorno 	:= "Solicitação não enviada." + chr(13)+chr(10)+chr(13)+chr(10) + "Para maiores informações, consulte o Status no Monitor."
		Else
		 	// Realiza validação para processamento de solicitação especifica
			If 	oWS:OWSRECOPILISTASOLICITACOESRESULT:OWSRETLISTASOLICITACOES:OWSRETSOLICITACAO[1]:CERROSTATUS == "0"
				cCodCtr	 := oWS:OWSRECOPILISTASOLICITACOESRESULT:OWSRETLISTASOLICITACOES:OWSRETSOLICITACAO[1]:CCODCONTROLE
				cRetorno := "Solicitação enviada com sucesso!"
			Else
				cRetorno := "Solicitação não enviada." + chr(13)+chr(10)+chr(13)+chr(10) + "Para maiores informações, consulte o Status no Monitor."
	        EndIf

			//Preenche o código de Controle na CE3
			If !Empty(cCodCtr)
				dbSelectArea("CE3")
				dbSetOrder(1)
				If CE3->(MsSeek(xFilial("CE3")+AllTrim(cIdSolc)))
					If CE3->(FieldPos("CE3_RECOPI")) > 0
				  		RecLock("CE3")
						CE3->CE3_RECOPI:= AllTrim(cCodCtr)
						MsUnLock()	
					EndIf
				EndIf	
			EndIf				
		EndIf
		Aviso("RECOPI",cRetorno,{STR0114},3)
	Else
		Aviso("RECOPI","Problema de Comunicação",{STR0114},3)
	EndIf
EndIf

RestArea(aArea)
Return  

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Fisa031INf³ Autor ³Vitor Felipe           ³ Data ³14/07/2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina para associar a informacao da Nota Fiscal.			  ³±±
±±³          ³Service SPED - utilizada em personalizacoes                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³					                                          ³±±
±±³          ³                  					                      ³±±
±±³          ³                                      					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Fisa031INf()

Local aArea		:= GetArea()
Local aPerg		:= {}
Local cAliasSF3 := "SF3"
Local cAlias    := "SF2"
Local cAliasSF1 := "SF1"
Local aParam	:= {Space(Len(SF2->F2_SERIE)),Space(Len(SF2->F2_DOC)),Space(Len(SF2->F2_DOC)),Space(6),Space(6)}
Local cParTrans	:= SM0->M0_CODIGO+SM0->M0_CODFIL+"Fisa031INf"
Local cCodMun	:= SM0->M0_CODMUN
Local cSerie	:= ""
Local cNotaIni	:= ""
Local cNotaFin	:= ""
Local cIdSoli	:= ""
Local cParINF	:= SM0->M0_CODIGO+SM0->M0_CODFIL+"Fisa031INF"
Local aNotas    := {}
Local cCodCtr	:= ""
Local nX		:= 0
Local lQuery    := .F.
Local cWhere    := ""
Local cDtEmi	:= ""
Local cDtSai	:= ""
Local cIdInNF	:= ""
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da Interface                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

MV_PAR01	:=	cSerie	:= aParam[01] := PadR(ParamLoad(cParINF,aPerg,1,aParam[01]),3)
MV_PAR02	:=	cNotaIni:= aParam[02] := PadR(ParamLoad(cParINF,aPerg,2,aParam[02]),9)
MV_PAR03	:=	cNotaFin:= aParam[03] := PadR(ParamLoad(cParINF,aPerg,3,aParam[03]),9)
MV_PAR04	:=	cIdSoli	:= aParam[04] := PadR(ParamLoad(cParINF,aPerg,4,aParam[04]),6)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Montagem das perguntas                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aadd(aPerg,{1,"Serie"			,aParam[01],"",".T.","",".T.",10,.T.}) 						//"Serie"
aadd(aPerg,{1,"Nota Fiscal de"	,aParam[02],"",".T.","",".T.",50,.T.}) 						//"Nota Fiscal de"
aadd(aPerg,{1,"Nota Fiscal ate"	,aParam[03],"",".T.","",".T.",50,.T.}) 						//"Nota Fiscal ate"
aadd(aPerg,{1,"Id Solicitação"	,aParam[04],"",".T.","",".T.",20,.T.}) 						//"Id Solicitação"

If ParamBox(aPerg,"Inclusão de NF - RECOPI",,,,,,,,cParINF,.T.,.T.)
 	cSerie	:= MV_PAR01
	cNotaIni:= MV_PAR02
	cNotaFin:= MV_PAR03
	cIdSoli	:= MV_PAR04
  	
	ProcRegua(0)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Restaura a integridade da rotina caso exista filtro             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea(cAlias)
	dbClearFilter()
	RetIndex(cAlias)
	
	ProcRegua(Val(cNotaFin)-Val(cNotaIni)+1)
	dbSelectArea("SF3")
	dbSetOrder(5)
	#IFDEF TOP
		cWhere := "%((SubString(SF3.F3_CFO,1,1) < '5' AND SF3.F3_FORMUL='S') OR (SubString(SF3.F3_CFO,1,1) >= '5'))%"
		cAliasSF3 := GetNextAlias()
		lQuery    := .T.
		BeginSql Alias cAliasSF3
			
		COLUMN F3_ENTRADA AS DATE
		COLUMN F3_DTCANC AS DATE
		COLUMN F3_EMISSAO AS DATE
					
		SELECT	F3_FILIAL,F3_ENTRADA,F3_NFeLETR,F3_CFO,F3_FORMUL,F3_NFISCAL,F3_SERIE,F3_CLIEFOR,F3_LOJA,F3_ESPECIE,F3_DTCANC,F3_EMISSAO,F3_VALCONT
				FROM %Table:SF3% SF3
				WHERE
				SF3.F3_FILIAL = %xFilial:SF3% AND
				SF3.F3_SERIE = %Exp:cSerie% AND 
				SF3.F3_NFISCAL >= %Exp:cNotaIni% AND 
				SF3.F3_NFISCAL <= %Exp:cNotaFin% AND 
				%Exp:cWhere% AND 
				SF3.F3_DTCANC = %Exp:Space(8)% AND 
				SF3.%notdel%
		EndSql
		cWhere := ".T."	
	#ELSE
		MsSeek(xFilial("SF3")+cSerie+cNotaIni,.T.)
	#ENDIF
	cWhere := "((SubStr(F3_CFO,1,1) < '5' .AND. F3_FORMUL='S') .OR. (SubStr(F3_CFO,1,1) >= '5'))"
	While !Eof() .And. xFilial("SF3") == (cAliasSF3)->F3_FILIAL .And.;
		(cAliasSF3)->F3_SERIE == cSerie .And.;
		(cAliasSF3)->F3_NFISCAL >= cNotaIni .And.;
		(cAliasSF3)->F3_NFISCAL <= cNotaFin
	
		dbSelectArea(cAliasSF3)
		If (SubStr((cAliasSF3)->F3_CFO,1,1)>="5" .Or. (cAliasSF3)->F3_FORMUL=="S") .And. aScan(aNotas,{|x| x[3]+x[4]==(cAliasSF3)->F3_SERIE+(cAliasSF3)->F3_NFISCAL})==0
			
			IncProc("(1/2) "+STR0022+(cAliasSF3)->F3_NFISCAL) //"Preparando nota: "
			
			If Empty((cAliasSF3)->F3_DTCANC) .And. &cWhere
				aadd(aNotas,{})	
				nX := Len(aNotas)
				aadd(aNotas[nX],IIF((cAliasSF3)->F3_CFO<"5","0","1"))    
				aadd(aNotas[nX],(cAliasSF3)->F3_ENTRADA)                  
				aadd(aNotas[nX],(cAliasSF3)->F3_SERIE)
				aadd(aNotas[nX],(cAliasSF3)->F3_NFISCAL)
				aadd(aNotas[nX],(cAliasSF3)->F3_CLIEFOR)
				aadd(aNotas[nX],(cAliasSF3)->F3_LOJA)
				aadd(aNotas[nX],(cAliasSF3)->F3_EMISSAO)
				aadd(aNotas[nX],(cAliasSF3)->F3_VALCONT)
			EndIf
		EndIf		
		dbSelectArea(cAliasSF3)
		dbSkip()	
	EndDo
	If lQuery
		dbSelectArea(cAliasSF3)
		dbCloseArea()
		dbSelectArea("SF3")
	EndIf
	ProcRegua(Len(aNotas))
	                                               
	If Len(aNotas)>0
	
		oWS := WSRECOPI():New()
		oWS:cUSERTOKEN	:= "TOTVS"
		oWS:cID_ENT		:= cIdEnt
		oWS:_URL 		:= AllTrim(cURL)+"/RECOPI.apw"
		oWS:OWSMONITORRECOPI:OWSMONITOR := RECOPI_MONITOR():New()
			oWS:OWSMONITORRECOPI:OWSMONITOR:CID:= MV_PAR04 
			oWS:OWSMONITORRECOPI:OWSMONITOR:CID_ENT := cIdEnt
			oWS:OWSMONITORRECOPI:OWSMONITOR:CUSERTOKEN := "TOTVS"
			oWS:OWSMONITORRECOPI:OWSMONITOR:NID_METODO := 01
		
		lOk := oWS:MONITORRECOPI()
		
		If lOk 
			cCodCtr := oWS:OWSMONITORRECOPIRESULT:OWSRETMONITOR:CCODIGOCONTROLE
		Else
			Aviso("RECOPI","ID de Controle não encontrado",{STR0114},3)
		EndIf
	
	    If !Empty(cCodCtr)
			cDtEmi:=DTOS(aNotas[nX][7])
			cDtSai:=DTOS(aNotas[nX][2])			
			
			cString:= '<InclusaoNF>'
			cString+= '<CodigoControle>'+AllTrim(cCodCtr)+'</CodigoControle>'
			For nX:= 1 to Len(aNotas)
				cString+= '<NF>'
				cString+= '<Numero>'+AllTrim(aNotas[nX][4])+'</Numero>'
				cString+= '<Serie>'+AllTrim(aNotas[nX][3])+'</Serie>'
				cString+= '<DataEmissao>'+SubStr(cDtEmi,7,2)+"/"+SubStr(cDtEmi,5,2)+"/"+SubStr(cDtEmi,1,4)+'</DataEmissao>'
				cString+= '<DataSaida>'+SubStr(cDtSai,7,2)+"/"+SubStr(cDtSai,5,2)+"/"+SubStr(cDtSai,1,4)+'</DataSaida>'
				cString+= '<Valor>'+Alltrim(Transform( aNotas[nX][8], "@R 999999.99" ))+'</Valor>'
				cString+= '</NF>'
				cIdInNF := aNotas[nX][3]+aNotas[nX][4]
			Next(nX)
			cString+= '</InclusaoNF>'
	
			oWS := WSRECOPI():New()
			oWS:cUSERTOKEN	:= "TOTVS"
			oWS:cID_ENT		:= cIdEnt
			oWS:_URL 		:= AllTrim(cURL)+"/RECOPI.apw"
		   	oWS:OWSRECOPIINCLUSOESNF:OWSLISTAINCLUSOESNF := RECOPI_ARRAYOFINCLUSAONF():New()
				
			aadd(oWS:OWSRECOPIINCLUSOESNF:OWSLISTAINCLUSOESNF:OWSINCLUSAONF, RECOPI_INCLUSAONF():New())
			     oWS:OWSRECOPIINCLUSOESNF:OWSLISTAINCLUSOESNF:OWSINCLUSAONF[1]:CID:= cIdInNF
			     oWS:OWSRECOPIINCLUSOESNF:OWSLISTAINCLUSOESNF:OWSINCLUSAONF[1]:CXML:= cString
			     
		 	lOk := oWS:RECOPILISTAINCLUSOESNF()
		 	
		    If lOk 
				cRetorno:= "Notas Fiscais:"+CHR(13)+CHR(10)
				cRetorno+= "De: "+MV_PAR02+CHR(13)+CHR(10)
				cRetorno+= "Ate: "+MV_PAR03+CHR(13)+CHR(10)
				cRetorno+= "Foram Enviadas com sucesso."+CHR(13)+CHR(10)
				cRetorno+= "Código de controle: "+AllTrim(cCodCtr)
				Aviso("RECOPI",cRetorno,{STR0114},3)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Atualiza o Status das Notas. ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("SF2")
				dbSetOrder(1)
				dbSelectArea("SF1")
				dbSetOrder(1)
				
				For nX:= 1 to Len(aNotas)
				If aNotas[nX][1] == '1'
					If SF2->(MsSeek(xFilial("SF2")+aNotas[nX][4]+aNotas[nX][3]))
						RecLock("SF2")
							SF2->F2_RECOPI := "T"
							If lF2IDRECOP
								SF2->F2_IDRECOP:= cIdSoli
							EndIf
						MsUnlock()						
                	EndIf
              Else
              	If SF1->(MsSeek(xFilial("SF1")+aNotas[nX][4]+aNotas[nX][3]))
						RecLock("SF1")
						SF1->F1_RECOPI := "T"
						If lF1IDRECOP
							SF1->F1_IDRECOP:= cIdSoli
						EndIf
						MsUnlock()						
					EndIf
				Endif	  	
      			Next(nX)
			Else
				cRetorno := "Erro de Comunicação"
				Aviso("RECOPI",cRetorno,{STR0114},3)
			EndIf
	    Else
			cRetorno := "Solicitação sem codigo de confirmação"
			Aviso("RECOPI",cRetorno,{STR0114},3)	    
	    EndIf
	EndIf
EndIF
RestArea(aArea)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Fisa031Con³ Autor ³Vitor Felipe           ³ Data ³14/07/2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina para informar o Status de envio da Mercadoria.		  ³±±
±±³          ³Service SPED - utilizada em personalizacoes                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³					                                          ³±±
±±³          ³                  					                      ³±±
±±³          ³                                      					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Fisa031Con()

Local aArea		:= GetArea()
Local aPerg		:= {}
Local aParam	:= {Space(20),Space(6),Space(10),Space(9),Space(10),Space(9),Space(3),Space(9),Space(6),Space(10),Space(10)}
Local cAliasSD1	:= "SD1"
Local cAliasSD2	:= "SD2"
Local cSerie	:= ""
Local cParCon	:= SM0->M0_CODIGO+SM0->M0_CODFIL+"Fisa031Con"
Local cDt		:= ""
Local cDtEmi	:= ""
Local lQuery	:= .F.
Local cString	:= ""
Local lSD1		:= .F.
Local lSD2		:= .F.

Local cCodCo	:= ""
Local cStCon	:= ""
Local cNfEnt	:= ""
Local cNFEDt	:= ""
Local cNFCon	:= ""
Local cNFisc 	:= ""
Local cForne 	:= ""
Local cLoja 	:= ""
Local cPerda 	:= 0
Local cIdRem	:= ""
Local cIdRecopi:= ""
Local cXMLIni	:= ""
Local cXMLFim	:= ""
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da Interface                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

MV_PAR01 := cCodCo	:= aParam[01] := PadR(ParamLoad(cParCon,aPerg,1, aParam[01]),20)
MV_PAR02 := cStCon	:= aParam[02] := PadR(ParamLoad(cParCon,aPerg,2, aParam[02]),30)
MV_PAR03 := cNfEnt	:= aParam[03] := PadR(ParamLoad(cParCon,aPerg,3, aParam[03]),9)
MV_PAR04 := cNFEDt	:= aParam[04] := PadR(ParamLoad(cParCon,aPerg,4, aParam[04]),10)
MV_PAR05 := cNFCon	:= aParam[05] := PadR(ParamLoad(cParCon,aPerg,5, aParam[05]),9)
MV_PAR06 := cSerie 	:= aParam[06] := PadR(ParamLoad(cParCon,aPerg,6,aParam[06]),3)
MV_PAR07 := cNFisc 	:= aParam[07] := PadR(ParamLoad(cParCon,aPerg,7,aParam[07]),9)
MV_PAR08 := cForne 	:= aParam[08] := PadR(ParamLoad(cParCon,aPerg,8,aParam[08]),6)
MV_PAR09 := cLoja 	:= aParam[09] := PadR(ParamLoad(cParCon,aPerg,9,aParam[09]),2)
MV_PAR10 := cPerda 	:= aParam[10] := PadR(ParamLoad(cParCon,aPerg,10,aParam[10]),10)
MV_PAR11 := cIdRem 	:= aParam[11] := PadR(ParamLoad(cParCon,aPerg,11,aParam[11]),6)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Montagem das perguntas                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aadd(aPerg,{1,"Codigo de Controle"	,aParam[01],"",".T.","",".T.",70,.T.}) 						//"Codigo de Controle"
aadd(aPerg,{2,"Status Confirma.","1-Aceite", {"1-Aceite", "2-Cancelamento","3-Devolucao Parcial","4-Devolucao Total",;
												"5-Importacao Fracionada","6-Imposto","7- Retorno","8-Retorno Armazem",;
												"9-Retorno Industrialização","10-Sem Confirmação","11-Sinistro"},70,'.T.',.T.})	//Tipo de Operacao

aadd(aPerg,{2,"Nota de Entrada"	,"1-Sim", {"1-Sim", "2-Não"}, 50,'.T.',.T.})					//"Nota de Entrada"
aadd(aPerg,{1,"Data NF"			,aParam[04],"@R 99/99/9999",".T.","",".T.",30,.F.}) 			//"Data Nota de Entrada"

aadd(aPerg,{2,"Nota de Comple."	,"1-Sim", {"1-Sim", "2-Não"}, 50,'.T.',.T.})					//"Nota Complementar"
aadd(aPerg,{1,"Serie"			,aParam[06],"",".T.","",".T.",3,.F.}) 							//"Serie"
aadd(aPerg,{1,"Nota Fiscal"		,aParam[07],"",".T.","",".T.",9,.F.}) 							//"Nota Fiscal"
aadd(aPerg,{1,"Forn./Cli."		,aParam[08],"",".T.","",".T.",6,.F.}) 							//"Fornecedor ou Cliente"
aadd(aPerg,{1,"Loja"			,aParam[09],"",".T.","",".T.",2,.F.}) 							//"Loja"
aadd(aPerg,{1,"Perda"			,aParam[10],"",".T.","",".T.",50,.F.}) 						//"Perda"
aadd(aPerg,{1,"Id Remessa"		,aParam[11],"",".T.","",".T.",6,.F.}) 					   		//"Id Remessa"



If ParamBox(aPerg,"Confirmacoes - RECOPI",,,,,,,,cParCon,.T.,.T.)
	cCodCo	:= MV_PAR01
	cStCon	:= Iif((MV_PAR02 == "10-Sem Confirmação") .or. (MV_PAR02 == "11-Sinistro"),AllTrim(SubStr(MV_PAR02,1,2)),AllTrim(SubStr(MV_PAR02,1,1)))
	cNfEnt	:= SubStr(MV_PAR03,1,1)
	cNFEDt	:= Alltrim(MV_PAR04)
	cNFCon	:= SubStr(MV_PAR05,1,1)
	cSerie := MV_PAR06
	cNFisc := MV_PAR07
	cForne := MV_PAR08
	cLoja 	:= MV_PAR09
	cPerda := Alltrim(MV_PAR10)
	cIdRem	:= MV_PAR11                       

//Inicializa Metodo para verificar Solicitacao                                         
	
    If !Empty(cCodCo)
    	cXMLIni:='<Confirmacao>'
		cXMLIni+= '<CodigoControle>'+AllTrim(cCodCo)+'</CodigoControle>'
		cXMLIni+= '<StatusSolicitacao>'+cStCon+'</StatusSolicitacao>'
    	cXMLFim:= '</Confirmacao>'
           
    	If cStCon=="2" //Cancelamento de Solicitação
			cString:=  cXMLIni+ cXMLFim	
		Else	
	    	If cNFEnt == "1" //Entrada
	    		dbSelectArea("SD1")
				dbSetOrder(1)
				#IFDEF TOP
			    	If (TcSrvType ()<>"AS/400")
				    	lQuery := .T.
				    	cAliasSD1	:=	GetNextAlias()
				    	BeginSql Alias cAliasSD1
							COLUMN D1_EMISSAO AS DATE
							SELECT
								SD1.D1_EMISSAO,SD1.D1_FILIAL,SD1.D1_DOC,SD1.D1_SERIE,SD1.D1_FORNECE,SD1.D1_LOJA,SD1.D1_QUANT,SD1.D1_VUNIT,SD1.D1_TOTAL,SD1.D1_COD,SD1.D1_NFORI,SD1.D1_SERIORI
							FROM 
								%Table:SD1% SD1 
							WHERE 									
								SD1.D1_FILIAL = %xFilial:SD1% AND
								SD1.D1_DOC = %Exp:cNFisc% AND
								SD1.D1_SERIE = %Exp:cSerie% AND
								SD1.D1_FORNECE = %Exp:cForne% AND
								SD1.D1_LOJA = %Exp:cLoja% AND
								SD1.%notdel%
						EndSql
					EndIf
				#ENDIF
	
		       If !lQuery
				  	MsSeek(xFilial("SD1")+cNFisc+cSerie+cForne+cLoja)
				EndIF
			
				//Tratamento para buscar ID_RECOPI - NFE na tabela SF2 - Retorno de mercadoria
				If cStCon$"7-8-9" .And. !Empty((cAliasSD1)->D1_NFORI) 
					dbSelectArea("SF2")
					dbSetOrder(1)
					If SF2->(DbSeek(xFilial("SF2")+(cAliasSD1)->(D1_NFORI)+(cAliasSD1)->(D1_SERIORI))) 
						If lF2IDRECOP
							cIdRecopi := Alltrim(SF2->F2_IDRECOP)
						EndIf
					EndIf			
				EndIf	
				
				//Data de Emissao:
		   		dbSelectArea("SF1")
				dbSetOrder(1)
				If MsSeek(xFilial("SF1")+cNFisc+cSerie+cForne+cLoja)		
					cDt    := Dtos(SF1->F1_EMISSAO)
					cDtEmi := SubStr(cDt,7,2)+"/"+SubStr(cDt,5,2)+"/"+SubStr(cDt,1,4)
								
					If Empty(cNFEDt)
						cNFEDt := SubStr(cDt,1,4)+"-"+SubStr(cDt,5,2)+"-"+SubStr(cDt,7,2)
					Else
						cNFEDt := StrTran(cNFEDt,"/","")
						cNFEDt := SubStr(cNFEDt,5,4)+"-"+SubStr(cNFEDt,3,2)+"-"+SubStr(cNFEDt,1,2)
					EndIf
					cString:= cXMLIni
					If cStCon $ "7-8-9" .And. cNFCon == "1"
						cString+= '<NFComplementar>'
						cString+= '<Numero>'+cNFisc+'</Numero>'
						cString+= '<Serie>'+cSerie+'</Serie>'
						cString+= '<DataEmissao>'+cDtEmi+'</DataEmissao>'
						If cStCon == "7"
							cString+= '<DataEntrada>'+cDtEmi+'</DataEntrada>'
						Else
							cString+= '<DataSaida>'+cNFEDt+'</DataSaida>'
						EndIf
						cString+= '<Valor>'+Alltrim(Transform( SF1->F1_VALBRUT, "@R 999999.99" ))+'</Valor>'
						cString+= '</NFComplementar>'
						
						//Itens da nota de Devolução de Venda (7- Retorno,8-Retorno Armazem,9-Retorno Industrialização)
						If cStCon $ "8-9"
							While (cAliasSD1)->(!Eof())
								cString+= '<ListaItens>'
								cString+= '<ItemPapel>'
								dbSelectArea("SB1")
								dbSetOrder(1)
								MsSeek(xFilial("SB1")+(cAliasSD1)->D1_COD)
								cString+= '<CodigoPapel>'+AllTrim(SB1->B1_POSIPI)+'</CodigoPapel>'
								cString+= '<Quantidade>'+AllTrim(Str((cAliasSD1)->D1_QUANT))+'</Quantidade>'
								cString+= NfeTag('<Perda>',AllTrim(cPerda))
								cString+= '</ItemPapel>'
								cString+= '</ListaItens>' 
								cString+= '<IdRemessa>'+AllTrim(cIdRem)+'</IdRemessa>'
							(cAliasSD1)->(DbSkip())
							EndDo
						EndIf
					Else
						cString+= '<NFEntrada>'
						cString+= '<DataEntrada>'+cNFEDt+'</DataEntrada>'
						cString+= '</NFEntrada>'
					EndIf
					cString+= cXMLFim
					
					lSD1:= .T.
	    		EndIf
    		Else
    			dbSelectArea("SD2")
				dbSetOrder(1)
				#IFDEF TOP
		    	If (TcSrvType ()<>"AS/400")
			    	lQuery := .T.
			    	cAliasSD2	:=	GetNextAlias()
			    	BeginSql Alias cAliasSD2
						COLUMN D1_EMISSAO AS DATE
						SELECT
							SD2.D2_EMISSAO,SD2.D2_FILIAL,SD2.D2_DOC,SD2.D2_SERIE,SD2.D2_CLIENTE,SD2.D2_LOJA,SD2.D2_QUANT,SD2.D2_TOTAL,SD2.D2_COD,SD2.D2_NFORI,SD2.D2_SERIORI
						FROM 
							%Table:SD2% SD2 
						WHERE 									
							SD2.D2_FILIAL = %xFilial:SD2% AND
							SD2.D2_DOC = %Exp:cNFisc% AND
							SD2.D2_SERIE = %Exp:cSerie% AND
							SD2.D2_CLIENTE = %Exp:cForne% AND
							SD2.D2_LOJA = %Exp:cLoja% AND
							SD2.%notdel%
					EndSql
				EndIf
				#ENDIF
	
		       If !lQuery
				  	MsSeek(xFilial("SD2")+cNFisc+cSerie+cForne+cLoja)
				EndIF	
    		
    			SF2->(dbSetOrder(1))
    			If SF2->(MsSeek(xFilial("SF2")+cNFisc+cSerie+cForne+cLoja))		
					cDt    := Dtos(SF2->F2_EMISSAO)
					cDtEmi := SubStr(cDt,7,2)+"/"+SubStr(cDt,5,2)+"/"+SubStr(cDt,1,4)
								
					If Empty(cNFEDt)
						cNFEDt := SubStr(cDt,1,4)+"-"+SubStr(cDt,5,2)+"-"+SubStr(cDt,7,2)
					Else
						cNFEDt := StrTran(cNFEDt,"/","")
						cNFEDt := SubStr(cNFEDt,5,4)+"-"+SubStr(cNFEDt,3,2)+"-"+SubStr(cNFEDt,1,2)
					EndIf
					cString:= cXMLIni
					If cStCon $ "3-4" .And. cNFCon == "1"
						cString+= '<NFComplementar>'
						cString+= '<Numero>'+cNFisc+'</Numero>'
						cString+= '<Serie>'+cSerie+'</Serie>'
						cString+= '<DataEmissao>'+cDtEmi+'</DataEmissao>'
						cString+= '<DataSaida>'+cNFEDt+'</DataSaida>'
						cString+= '<Valor>'+Alltrim(Transform( SF2->F2_VALBRUT, "@R 999999.99" ))+'</Valor>'
						cString+= '</NFComplementar>'
						
						//Itens da nota de Devolução de Venda (7- Retorno,8-Retorno Armazem,9-Retorno Industrialização)
						If cStCon == "3"
							While (cAliasSD2)->(!Eof())
								cString+= '<ListaItens>'
								cString+= '<ItemPapel>'
								dbSelectArea("SB1")
								dbSetOrder(1)
								MsSeek(xFilial("SB1")+(cAliasSD2)->D2_COD)
								cString+= '<CodigoPapel>'+AllTrim(SB1->B1_POSIPI)+'</CodigoPapel>'
								cString+= '<Quantidade>'+AllTrim(Str((cAliasSD2)->D2_QUANT))+'</Quantidade>'
								cString+= NfeTag('<Perda>',AllTrim(cPerda))
								cString+= '</ItemPapel>'
								cString+= '</ListaItens>' 
								(cAliasSD2)->(DbSkip())
							EndDo
						EndIf
					EndIf
					cString+= cXMLFim
					
					lSD2:= .T.	
				EndIf
   			EndIf
   		EndIf
   	EndIf
EndIf
    				
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Inicializa Metodo de envio da Confirmacao ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
				
		oWS := WSRECOPI():New()
		oWS:cUSERTOKEN	:= "TOTVS"
		oWS:cID_ENT		:= cIdEnt
		oWS:_URL := AllTrim(cURL)+"/RECOPI.apw"
	   	oWS:OWSRECOPILISTACONFIRMACOES:OWSLISTACONFIRMACOES := RECOPI_ARRAYOFCONFIRMACAO():New()
			
		aadd(oWS:OWSRECOPILISTACONFIRMACOES:OWSLISTACONFIRMACOES:OWSCONFIRMACAO, RECOPI_CONFIRMACAO():New())
		     oWS:OWSRECOPILISTACONFIRMACOES:OWSLISTACONFIRMACOES:OWSCONFIRMACAO[1]:CID:= cIdRem
		     oWS:OWSRECOPILISTACONFIRMACOES:OWSLISTACONFIRMACOES:OWSCONFIRMACAO[1]:CXML:= cString
		     
	 	lOk := oWS:RECOPILISTACONFIRMACOES()
	 	
	   	If lOk .And. (Type("oWS:OWSRECOPILISTACONFIRMACOESRESULT:OWSRETLISTACONFIRMACOES:OWSRETCONFIRMACAO")<>"U"	)
	    	 If Len(oWS:OWSRECOPILISTACONFIRMACOESRESULT:OWSRETLISTACONFIRMACOES:OWSRETCONFIRMACAO) > 0
				
				oRetorno:=oWS:OWSRECOPILISTACONFIRMACOESRESULT:OWSRETLISTACONFIRMACOES:OWSRETCONFIRMACAO[1]
				cRetorno:= Iif(oRetorno:CERROSTATUS==Nil,"",oRetorno:CERROSTATUS+" - ")+oWS:OWSRECOPILISTACONFIRMACOESRESULT:OWSRETLISTACONFIRMACOES:OWSRETCONFIRMACAO[1]:CSTATUS
				Aviso("RECOPI",cRetorno,{STR0114},3)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Atualiza o Status da NF de Entrada    |
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
				If lSD1 
					If cNFEnt == "1" .And. SF1->F1_DOC == cNFisc .And. SF1->F1_SERIE == cSerie .And. SF1->F1_FORNECE == cForne .And. SF1->F1_LOJA == cLoja
						RecLock("SF1")						
							SF1->F1_RECOPI := "T"
							
							If SF1->(FieldPos("F1_IDRECOP")) > 0
								SF1->F1_IDRECOP:= cIdRecopi
							EndIf
							
						MsUnlock()		
					EndIf				
	           ElseIf lSD2
	           	If cNFEnt == "2" .And. SF2->F2_DOC == cNFisc .And. SF2->F2_SERIE == cSerie .And. SF2->F2_CLIENTE == cForne .And. SF2->F2_LOJA == cLoja
						RecLock("SF2")						
							SF2->F2_RECOPI := "T"
							
							If SF2->(FieldPos("F2_IDRECOP")) > 0
								SF2->F2_IDRECOP:= cIdRecopi
							EndIf
							
						MsUnlock()	
	           	EndIf  
	           EndIf
    	 	Else
	    	 	cRetorno := "Erro de Comunicação"
				Aviso("RECOPI",cRetorno,{STR0114},3)
    	 	EndIf
		Else
			cRetorno := "Erro de Comunicação"
			Aviso("RECOPI",cRetorno,{STR0114},3)
		EndIf


RestArea(aArea)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Fisa031CEs³ Autor ³Vitor Felipe           ³ Data ³14/07/2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina para informar a quantidade de papel de um            ³±±
±±³          ³determinado periodo.										  ³±±
±±³          ³Service SPED - utilizada em personalizacoes                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³					                                          ³±±
±±³          ³                  					                      ³±±
±±³          ³                                      					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Fisa031CEs()

Local aArea		:= GetArea()
Local aPerg		:= {}
Local aParam	:= {Space(14),Space(2),Space(10),Space(7),Space(10),Space(10),Space(10),Space(10),Space(10),Space(10),Space(10),Space(10),Space(6)}
Local cParEst	:= SM0->M0_CODIGO+SM0->M0_CODFIL+"Fisa031Est"
Local cCNPJor	:= ""
Local cCJorUF	:= ""
Local cTpInfo	:= ""
Local cDtRefe	:= ""
Local cTpDecl	:= ""
Local cJustif	:= ""
Local cCodPap	:= ""
Local nQTDPap	:= ""
Local cCdPapf	:= ""
Local cTpPubl	:= ""
Local cISBNIS	:= ""
Local cTirage	:= ""
Local cString	:= ""
Local cID		:= ""
Local cRetorno:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da Interface                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

MV_PAR01	:=	cCNPJor	:= aParam[01] := PadR(ParamLoad(cParEst,aPerg,1,aParam[01]),14)
MV_PAR02	:=	cCJorUF	:= aParam[02] := PadR(ParamLoad(cParEst,aPerg,2,aParam[02]),2)
MV_PAR03	:=	cTpInfo	:= aParam[03] := PadR(ParamLoad(cParEst,aPerg,3,aParam[03]),10)
MV_PAR04	:=	cDtRefe	:= aParam[04] := PadR(ParamLoad(cParEst,aPerg,4,aParam[04]),12)
MV_PAR05	:=	cTpDecl	:= aParam[05] := PadR(ParamLoad(cParEst,aPerg,5,aParam[05]),10)
MV_PAR06	:=	cJustif	:= aParam[06] := PadR(ParamLoad(cParEst,aPerg,6,aParam[06]),254)
MV_PAR07	:=	cCodPap	:= aParam[07] := PadR(ParamLoad(cParEst,aPerg,7,aParam[07]),10)
MV_PAR08	:=	nQTDPap	:= aParam[08] := PadR(ParamLoad(cParEst,aPerg,8,aParam[08]),10)
MV_PAR09	:=	cCdPapf	:= aParam[09] := PadR(ParamLoad(cParEst,aPerg,9,aParam[09]),10)
MV_PAR10	:=	cTpPubl	:= aParam[10] := PadR(ParamLoad(cParEst,aPerg,10,aParam[10]),10)
MV_PAR11	:=	cISBNIS	:= aParam[11] := PadR(ParamLoad(cParEst,aPerg,11,aParam[11]),10)
MV_PAR12	:=	cTirage	:= aParam[12] := PadR(ParamLoad(cParEst,aPerg,12,aParam[12]),10)
MV_PAR13	:=	cID		:= aParam[13] := PadR(ParamLoad(cParEst,aPerg,12,aParam[12]),6)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Montagem das perguntas  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aadd(aPerg,{1,"CNPJ Origem"		,aParam[01],"@R 99.999.999/9999-99",".T.","",".T.",80,.T.}) 				//"CNPJ Origem"
aadd(aPerg,{1,"UF"				,aParam[02],"@!",".T.","",".T.",10,.T.}) 									//"UF"
aAdd(aPerg,{2,"Tipo Informe"	,"1-Estoque",{"1-Estoque","2-Papel Tributado","3-Papel Imune",;
												"4-Publicação","5-Resíduo","6-Transformação",;
												"7-Envio Indust.","8-Recebimento Indust."},080,"",.T.})	//"Tipo Informe"
aadd(aPerg,{1,"Data Refer."		,aParam[04],"@R 99/9999",".T.","",".T.",30,.T.}) 							//"Data Referência"
aAdd(aPerg,{2,"Tipo Declara."	,"1-Nova",{"1-Nova","2-Corretiva"}, 060,"",.T.})							//"Tipo Declara." '.T.'
aadd(aPerg,{1,"Justificativa"	,aParam[06],"",".T.","",".T.",080,.F.}) 									//"Justificativa"
aadd(aPerg,{1,"Cod. do Papel"	,aParam[07],"",".T.","",".T.",050,.T.}) 									//"Cod. do Papel"
aadd(aPerg,{1,"Quantidade"		,aParam[08],"",".T.","",".T.",080,.T.})		 							//"Quantidade"
aadd(aPerg,{1,"Cod. Pap. Fin"	,aParam[09],"",".T.","",".T.",050,.F.}) 						   			//"Cod. Pap. Final"
aadd(aPerg,{2,"Tp. Publica."	,"Livro",{"Livro","Jornal"}, 060,"",.T.})									//"Tp. Publicação"
aadd(aPerg,{1,"ISBNISSN Tit."	,aParam[11],"",".T.","",".T.",050,.F.}) 						   			//"ISBNISSN Tit."
aadd(aPerg,{1,"Tiragem"			,aParam[12],"",".T.","",".T.",050,.F.}) 						   			//"Tiragem"
aadd(aPerg,{1,"Id de Envio"		,aParam[13],"",".T.","",".T.",050,.T.}) 						   			//"ID"

If ParamBox(aPerg,"Transmissão de Estoque - RECOPI",,,,,,,,cParEst,.T.,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Geracao do XML     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cString:='<ControleEstoque>'
cString+='<CNPJ>'+MV_PAR01+'</CNPJ>'
cString+='<CNPJUF>'+MV_PAR02+'</CNPJUF>'
cString+='<TipoInforme>'+SubStr(MV_PAR03,1,1)+'</TipoInforme>'
cString+='<DataReferencia>'+AllTrim(MV_PAR04)+'</DataReferencia>'
cString+='<TipoDeclaracao>'+SubStr(MV_PAR05,1,1)+'</TipoDeclaracao>'
cString+='<ListaItens>'
cString+='<ItemPapel>'
cString+='<CodigoPapel>'+AllTrim(MV_PAR07)+'</CodigoPapel>'
cString+='<Quantidade>'+Alltrim(MV_PAR08)+'</Quantidade>'
If MV_PAR03 == "6-Transformação"
	cString+='<CodigoPapelFinal>'+AllTrim(MV_PAR09)+'</CodigoPapelFinal>'
EndIf
If MV_PAR03 == "4-Publicação"
	cString+='<TipoPublicacao>'+AllTrim(MV_PAR10)+'</TipoPublicacao>'
	cString+='<ISBNISSNTitulo>'+AllTrim(MV_PAR11)+'</ISBNISSNTitulo>'
	cString+='<Tiragem>'+AllTrim(MV_PAR12)+'</Tiragem>'
EndIf
cString+='</ItemPapel>'
cString+='</ListaItens>'
cString+='</ControleEstoque>'

	oWS := WSRECOPI():New()
	oWS:cUSERTOKEN := "TOTVS"
	oWS:cID_ENT := cIdEnt
	oWS:_URL := AllTrim(cURL)+"/RECOPI.apw"
 	oWS:OWSRECOPICONTROLEESTOQUE:OWSLISTACONTROLEESTOQUE := RECOPI_ARRAYOFCONTROLEESTOQUE():New()
		
	aadd(oWS:OWSRECOPICONTROLEESTOQUE:OWSLISTACONTROLEESTOQUE:OWSCONTROLEESTOQUE, RECOPI_CONTROLEESTOQUE():New())
 		 oWS:OWSRECOPICONTROLEESTOQUE:OWSLISTACONTROLEESTOQUE:OWSCONTROLEESTOQUE[1]:CID:= AllTrim(MV_PAR13)
	     oWS:OWSRECOPICONTROLEESTOQUE:OWSLISTACONTROLEESTOQUE:OWSCONTROLEESTOQUE[1]:CXML:=cString
	     
 	lOk := oWS:RECOPILISTACONTROLEESTOQUE()
 	
    If lOk 
    	If Type("oWS:OWSRECOPILISTACONTROLEESTOQUERESULT:OWSRETLISTACONTROLEESTOQUE:OWSRETCONTROLEESTOQUE[1]")<>"U"
			If Empty(oWS:OWSRECOPILISTACONTROLEESTOQUERESULT:OWSRETLISTACONTROLEESTOQUE:OWSRETCONTROLEESTOQUE[1]:CERRODESC)
				cRetorno := "Cadastro Efeuado com Sucesso. Consulte o Status no Monitor."
			Else
				cRetorno := oWS:OWSRECOPILISTACONTROLEESTOQUERESULT:OWSRETLISTACONTROLEESTOQUE:OWSRETCONTROLEESTOQUE[1]:CERRODESC
			EndIf
			Aviso("RECOPI",cRetorno,{STR0114},3)
		Else
			Aviso("RECOPI","Problema de Comunicação",{STR0114},3)
		EndIf
	Else
		Aviso("RECOPI","Problema de Comunicação",{STR0114},3)
	EndIf

EndIf

RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ        
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Fisa031CFG³ Autor ³Vitor Felipe           ³ Data ³14/07/2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Configura o Ambiente para TOTV SPED SERVICE (TSS).          ³±±
±±³          ³(RECOPI)							                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Fisa031CFG() ////

Local oWizard
Local oCombo , oComboAmbs
Local cCodMun   := SM0->M0_CODMUN
Local cCert     := Space(250)
Local cKey      := Space(250)
Local cModulo   := Space(250)
Local cPassWord := Space(20)
Local cCombo    := STR0097
Local cSlot     := Space(4)
Local cLabel    := Space(250)
Local aTexto    := {}
Local aPerg     := {}
Local aPerg2    := {}
Local aParam    := {}
Local aParam2   := {}
Local aDadosEmp := {}

Local cAmbienteNFSe:= STR0057
Local cModNFSE     := "0"
Local cVersaoNFSe  := "1"
Local cCodSIAFI    := Space(4)
Local cUso         :="NFSE" 
Local cCnpJAut     := "  .   .   /    -  "
                                         

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem da Interface                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aadd(aTexto,{})
	aTexto[1] := STR0038+CRLF //"Esta rotina tem como objetivo ajuda-lo na configuração da integração com o Protheus com o serviço Totvs Services SPED. "
	aTexto[1] += STR0039 //"O primeiro passo é configurar a conexão do Protheus com o serviço."
	
	aadd(aTexto,{})
	aTexto[2] := STR0040
	
	DEFINE WIZARD oWizard ;
		TITLE STR0041; //"Assistente de configuração da Nota Fiscal Eletrônica"
		HEADER STR0019; //"Atenção"
		MESSAGE STR0020; //"Siga atentamente os passos para a configuração da nota fiscal eletrônica."
		TEXT aTexto[1] ;
		NEXT {|| .T.} ;
		FINISH {||.T.}
	
	CREATE PANEL oWizard  ;
		HEADER STR0041 ; //"Assistente de configuração da Nota Fiscal Eletrônica"
		MESSAGE ""	;
		BACK {|| .F.} ;
		NEXT {|| IsReady(cURL,3,.T.)} ;
		PANEL
		
	@ 010,010 SAY STR0042 SIZE 270,010 PIXEL OF oWizard:oMPanel[2] //"Informe a URL do servidor Totvs Services"
	@ 025,010 GET cURL SIZE 270,010 PIXEL OF oWizard:oMPanel[2]
	

	CREATE PANEL oWizard  ;
		HEADER STR0041 ; //"Assistente de configuração da Nota Fiscal Eletrônica"
		MESSAGE ""	;
		BACK {|| .T.} ;
		NEXT {|| IsCDReady(@oCombo:nAt,@cCert,@cKey,@cPassWord,@cSlot,@cLabel,@cModulo)} ;
		PANEL

	@ 005,010 SAY STR0095 SIZE 270,010 PIXEL OF oWizard:oMPanel[3] //"Informe o tipo de certificado digital"
	@ 005,105 COMBOBOX oCombo VAR cCombo ITEMS {STR0097,""} SIZE 120,010 OF oWizard:oMPanel[3] PIXEL //"Formato Apache(.pem)"###"Formato PFX(.pfx ou .p12)"###"HSM"
	@ 020,010 SAY STR0043 SIZE 270,010 PIXEL OF oWizard:oMPanel[3] //"Informe o nome do arquivo do certificado digital"
	@ 030,010 GET cCert SIZE 240,010 PIXEL OF oWizard:oMPanel[3] WHEN oCombo:nAt <> 3
	TButton():New( 030,250,STR0044,oWizard:oMPanel[3],{||cCert := cGetFile(IIF(oCombo:nAt == 2,STR0045,STR0098),STR0072,0,"",.T.,GETF_LOCALHARD),.T.},29,12,,oWizard:oMPanel[3]:oFont,,.T.,.F.,,.T., ,, .F.) //"Drive:"###"Arquivos .PEM |*.PEM","Selecione o certificado"
	@ 050,010 SAY STR0047 SIZE 270,010 PIXEL OF oWizard:oMPanel[3] //"Informe senha do arquivo digital"
	@ 060,010 GET cPassWord SIZE 060,010 PIXEL OF oWizard:oMPanel[3] PASSWORD
                    

	CREATE PANEL oWizard  ;
		HEADER STR0041 ; //"Assistente de configuração da Nota Fiscal Eletrônica"
		MESSAGE ""	;
		BACK {|| .T.} ;
		NEXT {|| SetParams(cIdEnt,cUrl,cCodMun,AllTrim(cAmbienteNFSe),AllTrim(cModNFSE),AllTrim(cVersaoNFSe),AllTrim(cCodSIAFI),cCnpJAut)} ;
		PANEL
                                                                  
	@ 010,010 SAY "Ambiente" SIZE 270,010 PIXEL OF oWizard:oMPanel[4] 
	@ 020,010 COMBOBOX oComboAmb VAR cAmbienteNFSe ITEMS {STR0056,STR0057} SIZE 060,010 PIXEL OF oWizard:oMPanel[4] 

	@ 040,010 SAY "CNPJ do Certificado Digital" SIZE 270,010 PIXEL OF oWizard:oMPanel[4]
	@ 050,010 GET cCnpJAut SIZE 080,010 PICTURE "99.999.999/9999-99" PIXEL OF oWizard:oMPanel[4]

	CREATE PANEL oWizard  ;
		HEADER STR0041; //"Assistente de configuração da Nota Fiscal Eletrônica"
		MESSAGE "";
		BACK {|| oWizard:SetPanel(2),.T.} ;
		FINISH {|| lOk := .T.} ;
		PANEL
	@ 010,010 GET aTexto[2] MEMO SIZE 270, 115 READONLY PIXEL OF oWizard:oMPanel[5]
	
	ACTIVATE WIZARD oWizard CENTERED

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ        
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³RecopiMnt1³ Autor ³Vitor Felipe           ³ Data ³14/07/2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Monitor dos metodos. (TSS).						          ³±±
±±³          ³(RECOPI)							                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Function RecopiMnt1(cAlias) 
//Solicitacoes:
Local aPerg		:= {}
Local aParam 	:= {Space(15),Space(6),Space(6),Iif(cAlias == "SF2",Space(Len(SF2->F2_SERIE)),Space(Len(SF1->F1_SERIE))),IIf(cAlias == "SF2",Space(Len(SF2->F2_DOC)),Space(Len(SF1->F1_DOC))),IIf(cAlias == "SF2",Space(Len(SF2->F2_DOC)),Space(Len(SF1->F1_DOC)))}
Local lOk		:= .F.
Local cParMnt	:= ""
Local cCodCtrl 	:= ""
Local cMsgRet	:= ""
Local oRetorno
Local lAtu		:= .F.
Local aListBox	:= {}
Local nX		:= 0
Local cAliasTemp:= ""
Local cQuery    := ""
Local oQueryTemp
Local nMonitDe	:= 0  
Local nMonitAte	:= 0
Default cAlias  := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da Interface                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MV_PAR01	:=	cTPSer		:= aParam[01] := PadR(ParamLoad(cParMnt,aPerg,1,aParam[01]),15)
MV_PAR02	:=	cIdSerd		:= aParam[02] := PadR(ParamLoad(cParMnt,aPerg,2,aParam[02]),6)
MV_PAR03	:=	cIdSera		:= aParam[03] := PadR(ParamLoad(cParMnt,aPerg,3,aParam[03]),6)
MV_PAR04	:=	cSerie		:= aParam[04] := PadR(ParamLoad(cParMnt,aPerg,4,aParam[04]),3)
MV_PAR05	:=	cNotaIni	:= aParam[05] := PadR(ParamLoad(cParMnt,aPerg,5,aParam[05]),9)
MV_PAR06	:=	cNotaFin	:= aParam[06] := PadR(ParamLoad(cParMnt,aPerg,6,aParam[06]),9)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Montagem das perguntas                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd(aPerg,{2,"Tipo Informe"	,"01-Solicitaçoes",{"01-Solicitações","02-Inclusão NF","03-Confirmaçoes","04-Estoque"}, 060,"",.T.})		//"Tipo de Servico Monitor
aadd(aPerg,{1,"ID Serviço de:" 	,aParam[2],"",".T.","",".T.",030,.F.})	//"Id Solicitação"
aadd(aPerg,{1,"ID Serviço até:"	,aParam[3],"",".T.","",".T.",030,.F.})	//"Id Solicitação"
aadd(aPerg,{1,"Serie"			,aParam[4],"",".T.","",".T.",003,.F.})	//"Serie"
aadd(aPerg,{1,"Nota Fiscal de"	,aParam[5],"",".T.","",".T.",50,.F.})	//"Nota Fiscal de?"
aadd(aPerg,{1,"Nota Fiscal ate"	,aParam[6],"",".T.","",".T.",50,.F.})	//"Nota Fiscal ate?"


If ParamBox(aPerg,"Monitor - RECOPI",,,,,,,,cParMnt,.T.,.T.)

	If cAlias == "SF2"

		cQuery := "SELECT SF2.F2_DOC, SF2.F2_SERIE, SF2.F2_IDRECOP, SF2.F2_RECOPI"
		cQuery += "  FROM ? SF2"
		cQuery += " WHERE SF2.F2_FILIAL = ? AND SF2.F2_SERIE = ? AND SF2.F2_DOC >= ? AND SF2.F2_DOC <= ? "
		cQuery += "   AND (SF2.F2_RECOPI <> '' OR SF2.F2_IDRECOP <> '')"
		cQuery += "   AND SF2.D_E_L_E_T_ = ? "
		cQuery += " ORDER BY SF2.F2_DOC "

		oQueryTemp := FwExecStatement():New(cQuery)

		oQueryTemp:SetUnsafe(1, RetSqlName("SF2") )
		oQueryTemp:SetString(2, xFilial("SF2") )

	ElseIf cAlias == "SF1"

		cQuery := "SELECT SF1.F1_DOC, SF1.F1_SERIE, SF1.F1_IDRECOP, SF1.F1_RECOPI"
		cQuery += "  FROM ? SF1"
		cQuery += " WHERE SF1.F1_FILIAL = ? AND SF1.F1_SERIE = ? AND SF1.F1_DOC >= ? AND SF1.F1_DOC <= ? "
		cQuery += "   AND (SF1.F1_RECOPI <> '' OR SF1.F1_IDRECOP <> '')"
		cQuery += "   AND SF1.D_E_L_E_T_ = ? "
		cQuery += " ORDER BY SF1.F1_DOC "

		oQueryTemp := FwExecStatement():New(cQuery)

		oQueryTemp:SetUnsafe(1, RetSqlName("SF1") )
		oQueryTemp:SetString(2, xFilial("SF1") )

	EndIf

	oQueryTemp:SetString(3, Alltrim( MV_PAR04 ) )
	oQueryTemp:SetString(4, AllTrim( MV_PAR05 ) )
	oQueryTemp:SetString(5, AllTrim( MV_PAR06 ) )
	oQueryTemp:SetString(6, ' ')

	cAliasTemp:= oQueryTemp:OpenAlias()

	If Val(SubStr(MV_PAR01,1,2)) <> 2 //Inclusão Nf tem um Id diferente 
		nMonitDe	:= MV_PAR02
		nMonitAte	:= MV_PAR03
	EndIf

	If Val(SubStr(MV_PAR01,1,2)) == 2
		DbSelectArea (cAliasTemp)
		(cAliasTemp)->(DbGoTop ())
		While (cAliasTemp)->(!Eof())
		If cAlias == "SF2"
			If Val(SubStr(MV_PAR01,1,2)) == 2 
				cNumNf	:= (cAliasTemp)->F2_DOC
				cIdMonitor := MV_PAR04 + cNumNf
			Else
				cIdMonitor := StrZero(nX,6,0)
			Endif
		Else
			If Val(SubStr(MV_PAR01,1,2)) == 2 
				cNumNf	:= (cAliasTemp)->F1_DOC
				cIdMonitor := MV_PAR04 + cNumNf
			Else
				cIdMonitor := StrZero(nX,6,0)
			Endif
		Endif	
		oWS := WSRECOPI():New()
		oWS:cUSERTOKEN	:= "TOTVS"
		oWS:cID_ENT		:= cIdEnt
		oWS:_URL := AllTrim(cURL)+"/RECOPI.apw"
		oWS:OWSMONITORRECOPI:OWSMONITOR := RECOPI_MONITOR():New()
			oWS:OWSMONITORRECOPI:OWSMONITOR:CID		:= cIdMonitor 
			oWS:OWSMONITORRECOPI:OWSMONITOR:CID_ENT := cIdEnt
			oWS:OWSMONITORRECOPI:OWSMONITOR:CUSERTOKEN := "TOTVS"
			oWS:OWSMONITORRECOPI:OWSMONITOR:NID_METODO := Val(SubStr(MV_PAR01,1,2))
		
		lOk := oWS:MONITORRECOPI()
		
		If lOk 
			oRetorno := oWS:OWSMONITORRECOPIRESULT:OWSRETMONITOR
			
			aadd(aListBox,{ Iif(! empty (AllTrim(oRetorno:CCODIGOCONTROLE)),AllTrim(oRetorno:CCODIGOCONTROLE),cCodCtrl),;		
							AllTrim(oRetorno:CID),;
							AllTrim(oRetorno:CID_ENT),;
						   	oRetorno:NERROGERALSTATUS,;
						   	oRetorno:NERROSTATUS,;
							AllTrim(oRetorno:CERRODESCRICAO)})			   			   
		Else
			Aviso("RECOPI","Problema de Comunicação",{STR0114},3)
		EndIf
		(cAliasTemp)->(DbSkip())	
		Enddo
	Else
	For nX := Val(MV_PAR02) To Val(MV_PAR03) 
	
		oWS := WSRECOPI():New()
		oWS:cUSERTOKEN	:= "TOTVS"
		oWS:cID_ENT		:= cIdEnt
		oWS:_URL := AllTrim(cURL)+"/RECOPI.apw"
		oWS:OWSMONITORRECOPI:OWSMONITOR := RECOPI_MONITOR():New()
			oWS:OWSMONITORRECOPI:OWSMONITOR:CID:= StrZero(nX,6,0) 
			oWS:OWSMONITORRECOPI:OWSMONITOR:CID_ENT := cIdEnt
			oWS:OWSMONITORRECOPI:OWSMONITOR:CUSERTOKEN := "TOTVS"
			oWS:OWSMONITORRECOPI:OWSMONITOR:NID_METODO := Val(SubStr(MV_PAR01,1,2))
		
		lOk := oWS:MONITORRECOPI()
		
		If lOk 
			oRetorno := oWS:OWSMONITORRECOPIRESULT:OWSRETMONITOR
			cMsgRet  := alltrim(oRetorno:CERROGERALDESC)
			If empty( cMsgRet )			// Realiza tratamento para retornar mensagem especifica caso não encontre mensagem geral
				cMsgRet  := alltrim(oRetorno:CERRODESCRICAO)
			EndIf
			aadd(aListBox,{ AllTrim(oRetorno:CCODIGOCONTROLE),;		
		   					AllTrim(oRetorno:CID),;
							AllTrim(oRetorno:CID_ENT),;
						   	oRetorno:NERROGERALSTATUS,;
						   	oRetorno:NERROSTATUS,;
							iif('<br />' $ cMsgRet, strtran( cMsgRet,'<br />',''), cMsgRet) })
				   
		Else
			Aviso("RECOPI","Problema de Comunicação",{STR0114},3)
		EndIf
	Next
	Endif				   	

	(cAliasTemp)->(DbCloseArea())
	oQueryTemp:Destroy()
	oQueryTemp:= nil

	If IsReady() 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Obtem o codigo da entidade                                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
			If !Empty(cIdEnt) .And. !lAtu
			
				If !Empty(aListBox)
						lAtu:= .T.
						aSize := MsAdvSize()
						aObjects := {}
						AAdd( aObjects, { 100, 100, .t., .t. } )
						AAdd( aObjects, { 100, 015, .t., .f. } )
					
						aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
						aPosObj := MsObjSize( aInfo, aObjects )
												
						DEFINE MSDIALOG oDlg TITLE "RECOPI" From aSize[7],0 to aSize[6],aSize[5] OF oMainWnd PIXEL
						
						@ aPosObj[1,1],aPosObj[1,2] LISTBOX oListBox Fields HEADER "Cod. Controle","ID","ID Ent.","Status Geral","Status","Descriçao"; //"Cod. Controle","ID","ID Ent.","XML","Descriçao","Status Geral","Status"
						SIZE aPosObj[1,4]-aPosObj[1,2],aPosObj[1,3]-aPosObj[1,1] PIXEL
						oListBox:SetArray( aListBox )
						oListBox:bLine := { || { aListBox[ oListBox:nAT,1 ],aListBox[ oListBox:nAT,2 ],aListBox[ oListBox:nAT,3 ],aListBox[ oListBox:nAT,4 ],aListBox[ oListBox:nAT,5 ],aListBox[ oListBox:nAT,6 ]}} //,aListBox[ oListBox:nAT,7 ]} }
						
						@ aPosObj[2,1],aPosObj[2,4]-080 BUTTON oBtn5 PROMPT STR0115 		ACTION (DetSchema(aListBox[oListBox:nAT][02],Val(SubStr(MV_PAR01,1,2)))) OF oDlg PIXEL SIZE 035,011
						@ aPosObj[2,1],aPosObj[2,4]-040 BUTTON oBtn1 PROMPT STR0114   		ACTION (oDlg:End(),aListBox:={}) OF oDlg PIXEL SIZE 035,011 //"OK"
						ACTIVATE MSDIALOG oDlg
						
				Else
					Aviso("RECOPI",STR0021,{STR0114},3)	//"Execute o módulo de configuração do serviço, antes de utilizar esta opção!!!"
				EndIf
				
			EndIf
				
	EndIf
EndIf

Return


Function DetSchema(Id,IdMetodo)

oWS := WSRECOPI():New()
oWS:cUSERTOKEN	:= "TOTVS"
oWS:cID_ENT		:= cIdEnt
oWS:_URL := AllTrim(cURL)+"/RECOPI.apw"
oWS:OWSMONITORRECOPI:OWSMONITOR := RECOPI_MONITOR():New()
	oWS:OWSMONITORRECOPI:OWSMONITOR:CID:= Id 
	oWS:OWSMONITORRECOPI:OWSMONITOR:CID_ENT := cIdEnt
	oWS:OWSMONITORRECOPI:OWSMONITOR:CUSERTOKEN := "TOTVS"
	oWS:OWSMONITORRECOPI:OWSMONITOR:NID_METODO := IdMetodo

lOk := oWS:MONITORRECOPI()

If lOk 
	oRetorno := oWS:OWSMONITORRECOPIRESULT:OWSRETMONITOR
	Aviso("RECOPI - XML",Alltrim(oWS:OWSMONITORRECOPIRESULT:OWSRETMONITOR:CXML),{STR0114},3)
Else
	Aviso("RECOPI - XML","Erro na geração do XML",{STR0114},3)	
EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³IsReady   ³ Autor ³Vitor Felipe           ³ Data ³14/07/2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Verifica se a conexao com a Totvs Sped Services pode ser    ³±±
±±³          ³estabelecida                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: URL do Totvs Services SPED                        OPC³±±
±±³          ³ExpN2: nTipo - 1 = Conexao ; 2 = Certificado             OPC³±±
±±³          ³ExpL3: Exibe help                                        OPC³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function IsReady(cURL,nTipo,lHelp)

Local lRetorno := .T.
DEFAULT nTipo := 1
DEFAULT lHelp := .F.

If !Empty(cURL) .And. !PutMV("MV_SPEDURL",cURL)
	RecLock("SX6",.T.)
	SX6->X6_FIL     := xFilial( "SX6" )
	SX6->X6_VAR     := "MV_SPEDURL"
	SX6->X6_TIPO    := "C"
	SX6->X6_DESCRIC := "URL do WebService Nota Fiscal de Serviços Eletrônica."
	MsUnLock()
	PutMV("MV_SPEDURL",cURL)
EndIf
SuperGetMv() //Limpa o cache de parametros - nao retirar

Return(lRetorno)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³IsCDReady ³ Autor ³Vitor Felipe           ³ Data ³14/07/2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Verifica se o certificado digital foi transferido com suces-³±±
±±³          ³so                                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpN1: [1] PEM; [2] PFX                                     ³±±
±±³          ³ExpC2: Certificado digital                                  ³±±
±±³          ³ExpC3: Private Key                                          ³±±
±±³          ³ExpC4: Password                                             ³±±
±±³          ³ExpC5: Slot                                                 ³±±
±±³          ³ExpC6: Label                                                ³±±
±±³          ³ExpC7: Modulo                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function IsCDReady(nTipo,cCert,cKey,cPassWord,cSlot,cLabel,cModulo)

Local lRetorno := .T.
Local cMsg     := ""
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Obtem o codigo da entidade                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( !Empty(cCert) .And. !Empty(cPassWord) .And. nTipo == 1 ) .Or. !IsReady(,2)

	If nTipo <> 3 .And. !File(cCert)
		Aviso("NFS-e",STR0048,{STR0114},3) //"Arquivo não encontrado"
		lRetorno := .F.
	EndIf

	If !Empty(cIdEnt) .And. lRetorno .And. nTipo <> 3
		
		If Fisa031Pfx(cIdEnt,cCert,AllTrim(cPassWord),@cMsg,"NFSE")
			lRetorno := .T.
		Else
			lRetorno := .F.
		EndIf	
	EndIf

EndIf
Return(lRetorno)           
                   

Function Fisa031Pfx(cIdEnt,cCert,cPassWord,cMsg,cUsoCert)
Local oWS
Local lRetorno := .T.    
Local cURL     := AllTrim(GetNewPar("MV_SPEDURL","http://localhost:8080/nfse"))


oWS:= WsNFSE001():New()
oWs:cUSERTOKEN   := "TOTVS"
oWs:cID_ENT      := cIdEnt 
oWs:cCertificate := GENLoadTXT(cCert)
oWs:cPASSWORD    := AllTrim(cPassWord)
oWS:_URL         := AllTrim(cURL)+"/NFSE001.apw"
oWS:CUso         := "NFSE"

	lOk := oWS:CFGNFSeCertPfx()
	
	If lOk 
		oRetorno := oWS:CCFGNFSeCertPfxRESULT
		Aviso("NFS-e",oRetorno,{STR0114},3)
    Else
    	cMsg :=(IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)))
		Aviso("NFS-e",cMsg,{STR0114},3)		
    EndIf

Return(lRetorno)     


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³GetIdEnt  ³ Autor ³Vitor Felipe           ³ Data ³14/07/2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Obtem o codigo da entidade apos enviar o post para o Totvs  ³±±
±±³          ³Service                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpC1: Codigo da entidade no Totvs Services                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GetIdEnt()

Local aArea  := GetArea()
Local cIdEnt := ""
Local cURL   := PadR(GetNewPar("MV_SPEDURL","http://"),250)
Local oWs
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Obtem o codigo da entidade                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oWS := WsSPEDAdm():New()
oWS:cUSERTOKEN := "TOTVS"
	
oWS:oWSEMPRESA:cCNPJ       := IIF(SM0->M0_TPINSC==2 .Or. Empty(SM0->M0_TPINSC),SM0->M0_CGC,"")	
oWS:oWSEMPRESA:cCPF        := IIF(SM0->M0_TPINSC==3,SM0->M0_CGC,"")
oWS:oWSEMPRESA:cIE         := SM0->M0_INSC
oWS:oWSEMPRESA:cIM         := SM0->M0_INSCM		
oWS:oWSEMPRESA:cNOME       := SM0->M0_NOMECOM
oWS:oWSEMPRESA:cFANTASIA   := SM0->M0_NOME
oWS:oWSEMPRESA:cENDERECO   := FisGetEnd(SM0->M0_ENDENT)[1]
oWS:oWSEMPRESA:cNUM        := FisGetEnd(SM0->M0_ENDENT)[3]
oWS:oWSEMPRESA:cCOMPL      := FisGetEnd(SM0->M0_ENDENT)[4]
oWS:oWSEMPRESA:cUF         := SM0->M0_ESTENT
oWS:oWSEMPRESA:cCEP        := SM0->M0_CEPENT
oWS:oWSEMPRESA:cCOD_MUN    := SM0->M0_CODMUN
oWS:oWSEMPRESA:cCOD_PAIS   := "1058"
oWS:oWSEMPRESA:cBAIRRO     := SM0->M0_BAIRENT
oWS:oWSEMPRESA:cMUN        := SM0->M0_CIDENT
oWS:oWSEMPRESA:cCEP_CP     := Nil
oWS:oWSEMPRESA:cCP         := Nil
oWS:oWSEMPRESA:cDDD        := Str(FisGetTel(SM0->M0_TEL)[2],3)
oWS:oWSEMPRESA:cFONE       := AllTrim(Str(FisGetTel(SM0->M0_TEL)[3],15))
oWS:oWSEMPRESA:cFAX        := AllTrim(Str(FisGetTel(SM0->M0_FAX)[3],15))
oWS:oWSEMPRESA:cEMAIL      := UsrRetMail(RetCodUsr())
oWS:oWSEMPRESA:cNIRE       := SM0->M0_NIRE
oWS:oWSEMPRESA:dDTRE       := SM0->M0_DTRE
oWS:oWSEMPRESA:cNIT        := IIF(SM0->M0_TPINSC==1,SM0->M0_CGC,"")
oWS:oWSEMPRESA:cINDSITESP  := ""
oWS:oWSEMPRESA:cID_MATRIZ  := ""
oWS:oWSOUTRASINSCRICOES:oWSInscricao := SPEDADM_ARRAYOFSPED_GENERICSTRUCT():New()
oWS:_URL := AllTrim(cURL)+"/SPEDADM.apw"
If oWs:ADMEMPRESAS()
	cIdEnt  := oWs:cADMEMPRESASRESULT
Else
	Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{STR0114},3)
EndIf

RestArea(aArea)
Return(cIdEnt)


Function Fisa031Cod(cCodServ, cVerTss)
Local oWs
Local cRet := ""               

oWS:= WsNFSE001():New()
oWs:cUSERTOKEN   := "TOTVS"
oWs:cID_ENT      := cIdEnt 
oWs:cCSERVICO    := cCodServ 
oWS:_URL         := AllTrim(cURL)+"/NFSE001.apw"
If oWs:RETMUNSERV()
	cRet := oWs:CRETMUNSERVRESULT
EndIf
oWs := Nil	
Return(cRet)

                 
Function Fisa031Ok(cCodMun)
Local lRet := .T.
Return(lRet)
             
Static Function SetParams(cIdEnt,cUrl,cCodMun,cAmbienteNFSe,cModNFSE,cVersaoNFSe,cCodSIAFI,cCnpJAut)
Local lRet := .T.
Local oWs    
Local lOk := .F.

Private oWsTMP  

	oWS := WSRECOPI():New()
   	oWS:_URL				  := AllTrim(cUrl)+"/RECOPI.apw"
	oWS:cUSERTOKEN            := "TOTVS"
	oWS:cID_ENT               := cIdEnt
	oWS:NAMBIENTE			  := Val(Substr(cAmbienteNFSe,1,1))
	
	lOk := oWS:RECOPICONFIG()
	
	If lOk 
		oRetorno := oWS:CRECOPICONFIGRESULT
		Aviso("NFS-e",Capital(oRetorno),{STR0114},3)
    Else
    	cMsg :=(IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)))
		Aviso("NFS-e",cMsg,{STR0114},3)		
    EndIf
           
       
Return(lRet)        

Static Function GENLoadTXT(cFileImp)
Local cTexto     := ""
Local cNewFile   := ""
Local cExt       := "" 
//Local cRootPath  := GetSrvProfString("RootPath","")
Local cStartPath := GetSrvProfString("StartPath","")
Local nHandle    := 0
Local nTamanho   := 0
Local cDrive     := ""
Local cPath		 :=	""
Local lCopied	 :=	.F.                     


cStartPath := StrTran(cStartPath,"/","\")
cStartPath +=If(Right(cStartPath,1)=="\","","\")

cFileOrig:= Alltrim(cFileImp)
If Substr(cFileImp,1,1) == "\"
//	cFileImp := AllTrim(cRootPath)+Alltrim(cFileImp)
EndIf    

SplitPath(cFileOrig,@cDrive,@cPath, @cNewFile,@cExt)

cNewFile	:=	cNewFile+cExt
If Empty(cDrive)
	lCopied := __CopyFile(cFileImp, cStartPath+cNewFile) 
Else
	lCopied := CpyT2S(cFileImp,cStartPath)
EndIf		

If lCopied
	nHandle 	:= 	FOpen(cNewFile)
	If nHandle > 0
		nTamanho := Fseek(nHandle,0,FS_END)
		FSeek(nHandle,0,FS_SET)
		FRead(nHandle,@cTexto,nTamanho)
		FClose(nHandle)
		FErase(cNewFile)
	Else
	   	cAviso := "Falha ao tentar obter acesso ao arquivo "+cNewFile
	   	Aviso("NFS-e",cAviso,{"OK"},3)
	EndIf

Else                                         
   	cAviso := "Falha ao tentar copiar o arquivo "+cNewFile +CRLF
   	cAviso += "para o diretorio raiz do Protheus."
  	Aviso("NFS-e",cAviso,{"OK"},3)	
EndIf	

If lCopied
	FErase(cNewFile)
EndIf

Return(cTexto)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³RecopiID  ³ Autor ³Vitor Felipe           ³ Data ³14/07/2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Id da Solicitacao.							              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: ID Escolhida.                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³			                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RecopiID()

Local cFilSx5	:= xFilial("SX5")
Local cTab		:= "ZM"
Local cChave	:= "01"
Local nVezes    := 0
Local nTamNota  := Len(SF2->F2_DOC)
Local lContinua := .T.
Local cSerNF	:= ""
Local nTimeOut  := GetNewPar("MV_NOTAOUT",20)*1000
Local nOpcA     := 0
Local aSerNF    := {}
Local aSerNFAnt := {}
Local cNumNF    := ""
Local oDlg
Local oQual
Local oTimer
Local oBmp
Local oBold 
Local nSizeFil  := 2
Local cTpNrNfs := "1"
Local cFilTela := cFilAnt    
Local lCanChange := .T.
Local lMudouNum	:= .T.
//-- Atualiza o conteúdo da filial
If FindFunction("FWSizeFilial")
	nSizeFil := FWSizeFilial()
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica as series de notas fiscais validas                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( lContinua )
	DbSelectArea("SX5")
	dbSetOrder(1)
	MsSeek(cFilSX5+cTab+cChave,.F.)
	While (SX5->X5_FILIAL == cFilSX5 .And. SX5->X5_TABELA == cTab)
		AADD( aSerNF,{PadR(SX5->X5_CHAVE,3), X5Descri()})
		dbSelectArea("SX5")
		dbSkip()
	EndDo
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Montagem da janela de exibicao                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( Len(aSerNF) != 0 )
	
	aSerNFAnt := aClone(aSerNF)
	DEFINE MSDIALOG oDlg TITLE "Controle ID Solicitação:" FROM 0,0 TO 264,378 OF oMainWnd	PIXEL 

	DEFINE FONT oBold NAME "Arial" SIZE 0, -13 BOLD
	
	@  0, -25 BITMAP oBmp RESNAME "PROJETOAP" oF oDlg SIZE 55, 1000 NOBORDER WHEN .F. PIXEL
	@ 14, 30 TO 16 ,400 LABEL '' OF oDlg PIXEL
	@ 03, 40 SAY "ID Solicitação" FONT oBold PIXEL
	
	oTimer:= TTimer():New(nTimeOut,{|| oDlg:End() },oDlg)
	oTimer:Activate()

	@ 025,040 LISTBOX oQual VAR cVarQ ;
		FIELDS HEADER OemToAnsi("Tabela"),"ID" ; //"Serie"
		SIZE 140,080 ;
		ON DBLCLICK (If(SX5Troca(@aSerNF,oQual:nAt,@oTimer,nTimeOut,oQual,cTpNrNfs),(oQual:Refresh(),If(lCanChange,lMudouNum := .T.,)),oDlg:End())) NOSCROLL PIXEL
		//oQual:Refresh() NOSCROLL PIXEL
		
	oQual:SetArray(aSerNF)
	oQual:bLine := { || {aSerNf[oQual:nAT,1],aSerNf[oQual:nAT,2]} }
	DEFINE SBUTTON FROM 113,119 TYPE 1 ACTION If(cTpNrNfs $ "2",;
						IIf(VldSX5Num(aSerNF[oQual:nAt][2],aSerNF[oQual:nAt][1],.T.),(nOpcA:=oQual:nAt,oDlg:End()),nil),;
						(nOpcA:=oQual:nAt,oDlg:End())) ENABLE OF oDlg PIXEL
	ACTIVATE MSDIALOG oDlg VALID (oTimer:End(),.T.) CENTERED
	
	If ( lContinua .And. nOpcA != 0 )
		cSerNF := aSerNF[nOpcA][1]
		cNumNF:= aSerNF[nOpcA][2]
	Else
		lContinua := .F.
	EndIf
Else
	Help(" ",1,"A460FLOCK")
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Trava o registro escolhido                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( lContinua )
	dbSelectArea("SX5")
	dbSetOrder(1)
	If ( MsSeek(cFilSX5+cTab+cSerNF) )
		nVezes := 0
		While ( !SX5->(MsRLock()) )
			nVezes ++
			If ( nVezes > 10 )
				Help(" ",1,"A460FLOCK")
				lContinua := .F.
				Exit
			EndIf
			Sleep(100)
		EndDo
		If ( lContinua )
			SX5->X5_DESCRI  := StrZero((Val(cNumNF)+1),6,0)
			SX5->X5_DESCSPA := StrZero((Val(cNumNF)+1),6,0)
			SX5->X5_DESCENG := StrZero((Val(cNumNF)+1),6,0)
		EndIf
	EndIf
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Destrava os registro do SX5                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SX5->(MsRUnLock())

Return(cNumNF)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³  Sx5Troca³ Autor ³Vitor Felipe           ³ Data ³14/07/2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Verifica qual numeracao da Solicitacao.		              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Logico de continuacao.                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³				                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Sx5Troca(aSerNf,nItem,oTimer,nTimeOut,oQual,cTpNrNfs)
      
Local aDim      := {} 
Local bValidNum := { || .T. } 
Local cCadastro := OemToAnsi(STR0017) //"Numero"
Local cNumero   := aSerNf[nItem][2]
Local cSerie    := aSerNf[nItem][1]
Local lContinua := .T.
Local lValid    := .F. 
Local nCol      := 2 
Local nRow      := oQual:nAt
Local oOwner    := oQual:oWnd 
Local oDlg      
Local oTimer2
Local oGet1                      
Local oRect           
Local oBtn 
Local lCanChange  := SuperGetMv("MV_MUDANUM",,.F.)

Default cTpNrNfs:=  "1" 

// Verifica se arquivo criado no meio da versao 710 existe
If cTpNrNfs == "3" 
	SX3->(dbSetOrder(1))
	If !(SX3->(dbSeek("SD9")))
		cTpNrNfs := "1"
	EndIf
EndIf

If cTpNrNfs # "3" .Or. lCanChange
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ponto de entrada para validacao da digitacao do numero                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ExistBlock( "NFSVLNUM" ) 
		bValidNum := { |x,y| ExecBlock( "NFSVLNUM", .F., .F., { x,y } ) }	
	EndIf  
	
	oTimer:Deactivate()    
	
	oRect := tRect():New(0,0,0,0)    // obtem as coordenadas da celula (lugar onde
	oQual:GetCellRect(nCol,,oRect)    // a janela de edicao deve ficar)
	aDim  := {oRect:nTop,oRect:nLeft,oRect:nBottom,oRect:nRight}
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria uma janela invisivel para permitir a edicao do campo sobre o browse ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DEFINE MSDIALOG oDlg OF oOwner  FROM 0, 0 TO 0, 0 STYLE nOR( WS_VISIBLE, WS_POPUP ) PIXEL
	
	oTimer2 := TTimer():New(nTimeOut,{|| lContinua := .F.,oDlg:End() },oDlg)
	oTimer2:Activate()       
				
	@ 0,0 MSGET oGet1 VAR cNumero SIZE 0,0 OF oDlg FONT oOwner:oFont PICTURE "@!" PIXEL ;
				HASBUTTON WHEN Substr(cAcesso,50,1) == "S" 
				
	oGet1:Move(-2,-2, (aDim[ 4 ] - aDim[ 2 ]) + 4, aDim[ 3 ] - aDim[ 1 ] + 4 )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Botao criado para receber o foco - nao retirar                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@ 0,0 BUTTON oBtn PROMPT "X" SIZE 0,0 OF oDlg
	oBtn:bGotFocus := {|| oDlg:nLastKey := VK_RETURN, If( lValid := ( !Empty(cNumero) .And. Eval( bValidNum, cNumero, cSerie ) ), oDlg:End(0), oGet1:SetFocus() ) }
	
	ACTIVATE MSDIALOG oDlg ON INIT oDlg:Move(aDim[1],aDim[2],aDim[4]-aDim[2], aDim[3]-aDim[1])
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Restaura a listbox                                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oQual:nAt := nRow
	SetFocus(oQual:hWnd)
	oQual:Refresh()
	
	oTimer:Activate()
	        
	If lValid 
		aSerNf[nItem][2] := cNumero
	EndIf 	
EndIf

Return(lContinua) 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³  TelaSol ³ Autor ³Vitor Felipe           ³ Data ³14/07/2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Tela de Solicitacoes.					                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ XML Gerado para a solicitacao.                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³														           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function TelaSol(cAlias,nReg,nOpc,cIDSOl)

Local aButtons 	:= {}
Local aCpoEnch 	:= {}
Local aAlterEnch:= {}
Local aCpoGDa 	:= {}
Local aHeader 	:= {}
Local aCols 	:= {}
Local aAlterGDa := {}
Local aPos 		:= {030,000,100,300}

Local cTpOper	:= ""  
Local caTela 	:= "" 
Local cSuperDel := ""  
Local cDescOper	:= ""
Local cString	:= ""
Local cAliasE 	:= cAlias   
Local cAliasGD 	:= "CE4"  
Local cLinOk 	:= "AllwaysTrue"
Local cTudoOk 	:= "AllwaysTrue"
Local cIniCpos 	:= "+CE4_ITEM" 
Local cFieldOk 	:= "AllwaysTrue"
Local cDelOk 	:= "AllwaysFalse"   
Local cNDI		:= ""

Local lF3 		:= .F.
Local lMemoria 	:= .T.
Local lColumn 	:= .F. 
Local lNoFolder := .T.
Local lProperty := .T. 
Local lOk		:= .F. 
Local lImport	:= .F. 
Local lAcJudic	:= .F.

Local nX 		:= 0
Local nUsado 	:= 0
Local nModelo 	:= 3
Local nSuperior := 100
Local nEsquerda := 000
Local nInferior := 250
Local nDireita 	:= 300
Local nFreeze 	:= 000
Local nMax 		:= 999
Local nQTD		:= 0
Local nTamItem 	:= TamSX3("CE4_ITEM")[1]
Local nPosITEM 	:= 0
Local nPosCODPAP:= 0
Local nPosQTDPAP:= 0


Private oDlg
Private oGetD
Private oEnch
Private aTELA[0][0]
Private aGETS[0]

DbSelectArea("SX3")
DbSetOrder(1)
DbSeek(cAliasE)
While !Eof() .And. SX3->X3_ARQUIVO == cAliasE
	If !(SX3->X3_CAMPO $ "CE3_FILIAL") .And. cNivel >= SX3->X3_NIVEL .And. X3Uso(SX3->X3_USADO)
		AADD(aCpoEnch,SX3->X3_CAMPO)
	EndIf
	DbSkip()
End

aAlterEnch := aClone(aCpoEnch)

DbSelectArea("SX3")
DbSetOrder(1)
MsSeek(cAliasGD)
While !Eof() .And. SX3->X3_ARQUIVO == cAliasGD
	If !(AllTrim(SX3->X3_CAMPO) $ "CE4_FILIAL") .And. cNivel >= SX3->X3_NIVEL .And. X3Uso(SX3->X3_USADO)
		AADD(aCpoGDa,SX3->X3_CAMPO)
	EndIf
	DbSkip()
End

aAlterGDa := aClone(aCpoGDa)

nUsado:=0
dbSelectArea("SX3")
DbSetOrder(1)
dbSeek("CE4")
aHeader:={}
While !Eof().And.(x3_arquivo=="CE4")
	If X3USO(x3_usado).And.cNivel>=x3_nivel
		nUsado:=nUsado+1
		AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
			x3_tamanho, x3_decimal,"AllwaysTrue()",;
			x3_usado, x3_tipo, x3_f3, x3_context } )
		
	Endif
	dbSkip()
End

If nOpc==3 // Incluir
	aCols:={Array(nUsado+1)}
	aCols[1,nUsado+1]:=.F.
	For nX:=1 to nUsado
		IF Alltrim(aHeader[nX,2]) == "CE4_ITEM"
			aCols[1,nX]:= STRZERO(1,nTamItem)
		ELSE
			aCols[1,nX]:=CriaVar(aHeader[nX,2],.F.)
		ENDIF
	Next
Endif

oDlg := MSDIALOG():New(000,000,400,600, cCadastro,,,,,,,,,.T.)
 	RegToMemory("CE3", If(nOpc==3,.T.,.F.))
	oEnch := MsMGet():New(cAliasE,nReg,nOpc,/*aCRA*/,/*cLetra*/, /*cTexto*/,;
 						aCpoEnch,aPos, aAlterEnch, nModelo, /*nColMens*/, /*cMensagem*/,;
						cTudoOk,oDlg,lF3, lMemoria,lColumn,caTela,lNoFolder,lProperty)
 	oGetD:= MsNewGetDados():New(nSuperior,;
							nEsquerda,;
							nInferior,;
							nDireita,;
							GD_INSERT+GD_UPDATE,;
							cLinOk,;
							cTudoOk,;
							cIniCpos,;
							aAlterGDa,;
							/*nFreeze*/,;
							nMax,;
							cFieldOk,;
							/*SUPERDEL*/,;
							cDelOk,;
							oDLG,;
							aHeader,;
							aCols)								
	
	oGetD:oBrowse:lUseDefaultColors := .T.
	oDlg:bInit := {|| EnchoiceBar(oDlg, {||lOk:=.T.,oDlg:End()}, {||nOpcA:=0,oDlg:End()},,@aButtons)}
	oDlg:lCentered := .T.
	M->CE3_IDSOL := cIDSOl
oDlg:Activate() 

/*
Tipo de Operação

01 - INTERNA
02 - IMPORTACAO
03 - REMESSA INTERESTADUAL
04 - ENTRADA INTERESTADUAL
05 - INDUSTRIALIZACAO REMESSA INTERNA
06 - INDUSTRIALIZACAO REMESSA INTERESTADUAL
07 - INDUSTRIALIZACAO RECEBIMENTO INTERESTADUAL
08 - ARMAZEM REMESSA INTERNA
09 - ARMAZEM REMESSA INTERESTADUAL
10 - ARMAZEM RECEBIMENTO INTERESTADUAL
11 - JUDICIAL REMESSA
12 - JUDICIAL RECEBIMENTO
13 - JUDICIAL ARMAZEM REMESSA
14 - JUDICIAL ARMAZEM RECEBIMENTO
15 - JUDICIAL INDUSTRIALIZACAO REMESSA"
16 - JUDICIAL INDUSTRIALIZACAO RECEBIMENTO"

*/

//Tipo Operação
cTpOper := Alltrim(M->CE3_TPOPER)

Do Case
    Case cTpOper == "01"
    	cDescOper := "INTERNA"
    Case cTpOper == "02"
	    cDescOper := "IMPORTACAO" 
	    lImport := .T.
	Case cTpOper == "03"
		cDescOper := "REMESSA INTERESTADUAL"
    Case cTpOper == "04"
	    cDescOper := "ENTRADA INTERESTADUAL"
    Case cTpOper == "05"
	    cDescOper := "INDUSTRIALIZACAO REMESSA INTERNA"
    Case cTpOper == "06"
	    cDescOper := "INDUSTRIALIZACAO REMESSA INTERESTADUAL"
    Case cTpOper == "07"
	    cDescOper := "INDUSTRIALIZACAO RECEBIMENTO INTERESTADUAL"
	Case cTpOper == "08"
	    cDescOper := "ARMAZEM REMESSA INTERNA"
    Case cTpOper == "09"
	    cDescOper := "ARMAZEM REMESSA INTERESTADUAL"
    Case cTpOper == "10"
	    cDescOper := "ARMAZEM RECEBIMENTO INTERESTADUAL"     
	Case cTpOper == "11"
	    cDescOper := "JUDICIAL REMESSA"
	Case cTpOper == "12"
	    cDescOper := "JUDICIAL RECEBIMENTO"    
	Case cTpOper == "13"
	    cDescOper := "JUDICIAL ARMAZEM REMESSA"
	Case cTpOper == "14"
	    cDescOper := "JUDICIAL ARMAZEM RECEBIMENTO"
	Case cTpOper == "15"
	    cDescOper := "JUDICIAL INDUSTRIALIZACAO REMESSA" 
	Case cTpOper == "16"
	    cDescOper := "JUDICIAL INDUSTRIALIZACAO RECEBIMENTO"	    	    	    	    	    
EndCase	
 
//Ordem Judicial
lAcJudic := iif (Alltrim(cTpOper)$"11#12#13#14#15#16", .T., .F.)

If lOk
	dbSelectArea("CE3")
	dbSetOrder(1)
	If CE3->(MsSeek(xFilial("CE3")+AllTrim(cIDSOl)))		
		Alert("Solicitação já existente na Base de Dados!")	
		Return(cString)
	Else	
		RecLock("CE3",.T.)
			CE3->CE3_FILIAL	:= xFilial("CE3")
			CE3->CE3_IDSOL	:= AllTrim(cIDSOl)
			CE3->CE3_TPOPER	:= Alltrim(cTpOper) 
			CE3->CE3_CFOP	:= Alltrim(M->CE3_CFOP)
			CE3->CE3_CNPJOR	:= Alltrim(M->CE3_CNPJOR)
			CE3->CE3_UFORIG	:= Alltrim(M->CE3_UFORIG)
			CE3->CE3_CNPJDE	:= Alltrim(M->CE3_CNPJDE)
			CE3->CE3_UFDES	:= Alltrim(M->CE3_UFDES)
			If ColumnPos( "CE3_NDI" )
				CE3->CE3_NDI		:= Alltrim(M->CE3_NDI)
				cNDI := Alltrim(M->CE3_NDI)
			Endif
		MsUnLock()	
	
		cString :='<Solicitacao>'
		cString +='<IdInterno>'+  AllTrim(cIDSOl) +'</IdInterno>'
		cString +='<TipoOperacao>'+ Alltrim(cDescOper) +'</TipoOperacao>'
		cString +='<CNPJOrigem>'+ Alltrim(M->CE3_CNPJOR) +'</CNPJOrigem>'
		cString +='<CNPJOrigemUF>'+ Alltrim(M->CE3_UFORIG) +'</CNPJOrigemUF>'
		cString +='<CNPJDestino>'+ Alltrim(M->CE3_CNPJDE) +'</CNPJDestino>'
		cString +='<CNPJDestinoUF>'+ Alltrim(M->CE3_UFDES) +'</CNPJDestinoUF>'
		cString +='<CFOP>'+ Alltrim(M->CE3_CFOP) +'</CFOP>'  
		cString +='<Importacao>'+ iif(lImport, 'true', 'false' ) +'</Importacao>'
		cString +='<OrdemJudicial>'+ iif(lAcJudic, 'true', 'false' ) +'</OrdemJudicial>'
		cString +='<NumeroDI>'+ cNDI +'</NumeroDI>'
		cString +='<ListagemItens>'
		
		nPosITEM	:= GDFIELDPOS("CE4_ITEM",aHeader)
		nPosCODPAP	:= GDFIELDPOS("CE4_CODPAP",aHeader)
		nPosQTDPAP	:= GDFIELDPOS("CE4_QTDPAP",aHeader)
		
		dbSelectArea("CE4")
	  	dbSetOrder(1)	
		
		If CE4->(MsSeek(xFilial("CE4")+AllTrim(cIDSOl)))		
			Alert("Solicitação já existente na Base de Dados!")	
			Return("")
		Else	
		
			For nX := 1 to Len(oGetD:ACOLS)
				
				RecLock("CE4",.T.)
				CE4->CE4_FILIAL	:= xFilial("CE4")
				CE4->CE4_IDSOL	:= AllTrim(cIDSOl)
				CE4->CE4_CODPAP	:= Alltrim(oGetD:ACOLS[nX][nPosCODPAP])
				CE4->CE4_QTDPAP	:= oGetD:ACOLS[nX][nPosQTDPAP]
				CE4->CE4_ITEM	:= oGetD:ACOLS[nX][nPosITEM]
				MsUnLock()	
				
				nQTD := Transform(oGetD:ACOLS[nX][nPosQTDPAP],"@E 999999.99" )
				
				cString +='<ItemPapel>'
				cString +='<CodigoPapel>'+Alltrim(oGetD:ACOLS[nX][nPosCODPAP])+'</CodigoPapel>'
				cString +='<Quantidade>'+AllTrim(Replace(nQTD,",","."))+'</Quantidade>'
				cString +='</ItemPapel>'
			Next
			cString +='</ListagemItens>'
			cString +='</Solicitacao>'
		EndIf
	EndIf
	
EndIf

Return(cString)


//-------------------------------------------------------------------
/*/{Protheus.doc} NfeTag
Função que gera a tag apenas se tiver valor.

@param  cTag  - Tag a ser gerada
	     cConteudo  - Conteúdo da tag

@author Simone dos Santos de Oliveira
@since 12.05.2014
@version 11.80
/*/
//-------------------------------------------------------------------
Static Function NfeTag(cTag,cConteudo)

Local cRetorno := ""
If (!Empty(AllTrim(cConteudo)) .And. IsAlpha(AllTrim(cConteudo))) .Or. Val(AllTrim(cConteudo))<>0
	cRetorno := cTag+AllTrim(cConteudo)+SubStr(cTag,1,1)+"/"+SubStr(cTag,2)
EndIf
Return(cRetorno)

