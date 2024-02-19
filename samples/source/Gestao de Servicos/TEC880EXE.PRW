#INCLUDE "Protheus.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "MSOle.Ch" 

//--------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} Tec880EXE

Alimenta as DocVariable do Modelo Dot
@sample 	Tec880EXE() 
@since		11/09/2013 
@version P11 R9
     
@return lRet, Retorna .T. se houve sucesso
/*/
//--------------------------------------------------------------------------------------------------------------------
User Function Tec880EXE(cWord,cNome,cDesc,aCarac,cQtd,cLocal,aResp,cTpArma)
Local nX		:= 0
Local nI		:= 0

Do Case
	Case cTpArma == "1"
		If cQtd == 0
			cQtd := "1"
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ -Funcao que atualiza as variaveis do Word.                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		OLE_SetDocumentVar(cWord, "c_Data"     	, DtoC(dDatabase))
		OLE_SetDocumentVar(cWord, "cNome"  		, cNome         	)
		OLE_SetDocumentVar(cWord, "cLocal"  		, cLocal         	)
		OLE_SetDocumentVar(cWord, "cDesc"  		, cDesc       	)
		
		OLE_SetDocumentVar(cWord, "cAtivo"      	, aCarac[1]          )
		OLE_SetDocumentVar(cWord, "cEspec"      	, aCarac[2]          )
		OLE_SetDocumentVar(cWord, "cMarca"      	, aCarac[3]          )
		OLE_SetDocumentVar(cWord, "cCalibre"      , aCarac[4]          )
		OLE_SetDocumentVar(cWord, "cModelo"      	, aCarac[5]          )
		OLE_SetDocumentVar(cWord, "cReg"      		, aCarac[6]          )
		OLE_SetDocumentVar(cWord, "cSinarm"      	, aCarac[7]          )
		
		OLE_SetDocumentVar(cWord, "cQTD"   		, cQtd      		)
		
		For nX := 1 to Len(aResp)
			nI ++
			OLE_SetDocumentVar(cWord,"cResp"+Alltrim(str(nX)), aResp[nX] )
		Next nX
				
		If nI > 0
			OLE_SetDocumentVar(cWord,'nItens_Resp',alltrim(Str(nI)))
			OLE_ExecuteMacro(cWord,"Resp") 
		Endif
	
	Case cTpArma == "2"
		If cQtd == 0
			cQtd := "1"
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ -Funcao que atualiza as variaveis do Word.                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		OLE_SetDocumentVar(cWord, "c_Data"     	, DtoC(dDatabase))
		OLE_SetDocumentVar(cWord, "cNome"  		, cNome         	)
		OLE_SetDocumentVar(cWord, "cLocal"  		, cLocal         	)
		OLE_SetDocumentVar(cWord, "cDesc"  		, cDesc       	)
		
		OLE_SetDocumentVar(cWord, "cFabric"      	, aCarac[1]          )
		OLE_SetDocumentVar(cWord, "cDataValid"  	, aCarac[2]          )
		OLE_SetDocumentVar(cWord, "cNumCol"      	, aCarac[3]          )
		OLE_SetDocumentVar(cWord, "cNumSerie"    	, aCarac[4]          )
		OLE_SetDocumentVar(cWord, "cNumSinarm"  	, aCarac[5]          )
		OLE_SetDocumentVar(cWord, "cPlacaD"      	, aCarac[6]          )
		OLE_SetDocumentVar(cWord, "cPlacaT"      	, aCarac[7]          )
		
		OLE_SetDocumentVar(cWord, "cQTD"   		, cQtd      		)
		
		For nX := 1 to Len(aResp)
			nI ++
			OLE_SetDocumentVar(cWord,"cResp"+Alltrim(str(nX)), aResp[nX] )
		Next nX
		
		
		If nI > 0
			OLE_SetDocumentVar(cWord,'nItens_Resp',alltrim(Str(nI)))
			OLE_ExecuteMacro(cWord,"Resp") 
		Endif	
		
	Case cTpArma == "3"
		If cQtd == 0
			cQtd := "1"
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ -Funcao que atualiza as variaveis do Word.                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		OLE_SetDocumentVar(cWord, "c_Data"     	, DtoC(dDatabase))
		OLE_SetDocumentVar(cWord, "cNome"  		, cNome         	)
		OLE_SetDocumentVar(cWord, "cLocal"  		, cLocal         	)
		OLE_SetDocumentVar(cWord, "cDesc"  		, cDesc       	)
		
		OLE_SetDocumentVar(cWord, "cLote"      	, aCarac[1]          )
		OLE_SetDocumentVar(cWord, "cDataValid"  	, aCarac[2]          )
		OLE_SetDocumentVar(cWord, "cEspec"      	, aCarac[3]         	)
		OLE_SetDocumentVar(cWord, "cMarca"    		, aCarac[4]          )
		OLE_SetDocumentVar(cWord, "cCalibre"  		, aCarac[5]          )
		OLE_SetDocumentVar(cWord, "cModelo"      	, aCarac[6]          )
		OLE_SetDocumentVar(cWord, "cSinarm"      	, aCarac[7]          )
		
		OLE_SetDocumentVar(cWord, "cQTD"   		, cQtd      		)
		
		For nX := 1 to Len(aResp)
			nI ++
			OLE_SetDocumentVar(cWord,"cResp"+Alltrim(str(nX)), aResp[nX] )
		Next nX
		
		
		If nI > 0
			OLE_SetDocumentVar(cWord,'nItens_Resp',alltrim(Str(nI)))
			OLE_ExecuteMacro(cWord,"Resp") 
		Endif		
EndCase
	
Return .T.

//--------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} Tec880ImpProt

Realiza a Impressão do Protocolo
@sample 	tec880ImpProt() 
@since		11/09/2013 
@version P11 R9
     
@return lRet, Retorna .T. se houve sucesso
/*/
//--------------------------------------------------------------------------------------------------------------------
User Function Tec880ImpProt(cCodigo,cTpArma,cArma,cResp,nQtdMun,cDesti)

Local cWord     	:= Nil 							// Versao do Office
Local lRet      	:= .F.
Local cEnvServ  	:= GetEnvServer()
Local cIniFile  	:= GetADV97()
Local cRootPath 	:= GetPvProfString(cEnvServ,"RootPath","",cIniFile)

Local cArquivo	:= ""
Local cPathOri	:= AllTrim(SuperGetMv("MV_PATWORD"))		//Diretorio que esta todos componentes ( c:\wordstd )
Local cPathServer	:= Alltrim(SuperGetMv("MV_TECPATH"))	//Diretorio que estao os DOTS originais
Local cNomeDot	:= Alltrim(SuperGetMv("MV_TECDOT"))			//Documento WORD contendo todas as macro usadas na impressao do modelo
Local cPathFinal	:= Alltrim(SuperGetMv("MV_TECWORD")) 	//Diretorio onde será salvo o Protocolo
Local cNomeWord		:= Alltrim(SuperGetMv("MV_TECNOME"))		//Nome do Arquivo do Protocolo

Local cArq			:=  "" //cNomeWord + cCodigo 	//Concatena o Nome do Arquivo do Protocolo + o Codigo da Movimentação			
Local aDot			:={}						//Array com os nomes dos .Dot
Local cDotMacros	:= ""						//Variavel com o Nome do .Dot que será usado
Local cDesc			:= ""
Local aCarac		:= {}
Local aResp			:= {}
Local aSArea    	:= GetArea()
Local lCopia		:= .F.
Local aDescArma := { " Arma ", " Colete ", " Munição "}

Default cArma		:= ""
Default cTpArma	:= ""
Default cResp		:= ""
Default nQtdMun	:= 0
Default cDesti	:= ""


If !Empty(cTpArma) .And. !Empty(cNomeDot)
	aDot := STRTOKARR(cNomeDot,",")

	If Val(cTpArma) <= 3
		cDotMacros	:= AllTrim(aDot[Val(cTpArma)])
		cDotMacros := cDotMacros + If(".DOT" $ Upper(cDotMacros), "", ".dot")
		cArq	:= cNomeWord + aDescArma[Val(cTpArma)] +cCodigo + "_"+ RTrim(cArma)
	EndIf
EndIf

If	! File(cPathServer+cDotMacros)
	MsgAlert("Modelo do WORD : "  + cDotMacros + " usado na integração não encontrado no servidor. Impressão cancelada !" ,"Atenção") 
	Return NIL
Else
	//Realizo a copia para a maquina local
	If __CopyFile( cPathServer+cDotMacros , cPathOri+cDotMacros  )
		cArquivo := cPathOri+cDotMacros	
		lCopia := .T.
	Else
		Conout("Falha ao copiar arquivo para maquina local!")
		
		//Verifica se o arquivo dot está na pasta local
		If File(cPathOri+cDotMacros)
			cArquivo := cPathOri+cDotMacros	
		Else
			MsgAlert("Modelo do WORD : "  + cDotMacros + " usado na integração não encontrado na maquina local. Impressão cancelada !" ,"Atenção") 
			MsgAlert("Verifique a pasta local " + cPathOri)
			Return NIL
		EndIf
		 
	EndIf		
Endif
	
//Função para retornar os dados da arma
At880RetDados(cTpArma,cArma,@cDesc,@aCarac)
	
//Array com os responsaveis
aResp := At880RetResp()
	
//Abre o link com o word³
cWord := OLE_CreateLink('TMsOleWord97',,.T.)
	
If ValType(cWord) == "C" .AND. (cWord >= "0")
	OLE_NewFile( cWord,cArquivo)	
	//Funcao que faz o Word aparecer na Area de Transferencia do Windows,     
	//sendo que para habilitar/desabilitar e so colocar .T. ou .F.            
	OLE_SetProperty(cWord,oleWdWindowState,"MAX" )
	OLE_SetProperty(cWord, oleWdVisible  ,.T. )
	OLE_SetProperty(cWord, oleWdPrintBack,.T. )
		    
	//atualiza as variaveis do documento
	U_Tec880EXE(cWord,cResp,cDesc,aCarac,nQtdMun,cDesti,aResp,cTpArma)	
	//Funcao que atualiza os campos da memoria para o Documento, utilizada logo apos a  ³
	//funcao OLE_SetDocumentVar().														  
	OLE_UpdateFields(cWord)
				
	//Funcao que imprime o Documento corrente podendo ser especificado o numero de copias, 
	//podedo tambem imprimir com um intervalo especificado nos parametros "nPagInicial" ate  
	//"nPagFinal" retirando o parametro "ALL".												  		
	OLE_SetProperty( cWord, '208', .F. )
		
	MsgRun("Imprimindo protocolo...." ,"Aguarde"  ,{ || Tec800Prot(cWord) })
		
	MsgRun("Salvando Arquivo....","Aguarde",{ || Tec800Save(cWord,cPathFinal,cArq) })
				
	//Funcao que fecha o Link com o Word.
	OLE_CloseLink(cWord)
	
	//Função para apagar o .dot que foi criado na maquina local
	If lCopia .And. fErase(cPathOri+cDotMacros) <> -1
		Conout("Arquivo Apagado")
	EndIf
		
	lRet := .T.
		
Else
	Help( ,, "Tec880ImpProt",, "Problemas na comunicacao com o editor do Protocolo de Recebimento", 1, 0 ) 
Endif


RestArea(aSArea)

Return(lRet)
//--------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} Tec800Save

Salva o protocolo no diretorio especificado
@sample 	tec880ImpProt() 
@since		11/09/2013 
@version P11 R9
     
@return lRet, Retorna .T. se houve sucesso
/*/
//--------------------------------------------------------------------------------------------------------------------
Static Function Tec800Save(cWord,cPathFinal,cArq)
Local lRet	:= .T.

Default cPathFinal	:= ""
Default cArq			:= ""
	
If	File(cPathFinal)
	OLE_SaveAsFile(cWord,cPathFinal+cArq,,,.F.,oleWdFormatDocument)
	ApMsgInfo( cArq + " Salvo no Diretorio "  + cPathFinal, "Atenção" )
Else
	MakeDir(cPathFinal)
	If MakeDir(cPathFinal) == 0
		Help(2,"NODIR","Erro" ,"Falha na criação da pasta " +cPathFinal) //### //"Erro"###"Falha na criação da pasta "
		Return
	Else
		OLE_SaveAsFile(cWord,cPathFinal+cArq,,,.F.,oleWdFormatDocument)
		ApMsgInfo( cArq + " Salvo no Diretorio " + cPathFinal, "Atenção" )
	EndIf
EndIf

Return(lRet)
//--------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} Tec800Prot

Realiza a Impressão do Protocolo
@sample 	Tec800Prot() 
@since		11/09/2013 
@version P11 R9
     
@return lRet, Retorna .T. se houve sucesso
/*/
//--------------------------------------------------------------------------------------------------------------------
Static Function Tec800Prot(cWord)

OLE_PrintFile(cWord,,,,)

Return(.T.)
