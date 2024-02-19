#INCLUDE "protheus.ch"
#INCLUDE "report.ch" 
#INCLUDE "fwprintsetup.ch"

#DEFINE __RELIMP PLSMUDSIS(getWebDir() + getSkinPls() + "\relatorios\")
#DEFINE	 IMP_PDF 6 
#DEFINE	 TAM_A4 9	//A4     	210mm x 297mm  620 x 876		

//-------------------------------------------------------------------
/*/{Protheus.doc} PL99BSol

Monta estrutura do relatorio de atendimento Protocolos RN 395

@author  Equipe PLS
@version P11
@since   11/08/16
/*/
//------------------------------------------------------------------- 
User Function PL99BSol()
Local aDados     := paramixb[1]  
Local lImpEmail  := paramixb[2]   
Local lPortalWeb := paramixb[3]   
Local lSrvUnix   := IsSrvUnix()

Local oFontCab   := TFont():New("Arial", 20, 20, , .T., , , , .T., .F.)  
Local oFontNorm	 := TFont():New("Arial", 14, 14, , .F., , , , .T., .F.)   
Local oFontUnder := TFont():New("Arial", 14, 14, , .T., , , , .T., .F.,.T.)        
Local oFontBenNe := TFont():New("Arial", 14, 14, , .T., , , , .T., .F.)  

LOCAL cFileName := ""
Local cFolder   := GetNewPar("MV_P412PDF","")    
LOCAL cTexto    := ""
Local cPathSrv  := GetNewPar("MV_PLDIDOT", "\dot\" ) 
Local nHeiPag   := 2200                              	
Local nLin      := nHeiPag
Local nX      	:= 0
Local nY        := 0
LOCAL lDisSetup := .T.
LOCAL lOk       := .T.
Private oPrn       
/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Dados do Array aDados                                                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aDados[01] -> Municipio Operadora
aDados[02] -> UF Municipio Operadora      
aDados[03] -> Data Impressao
aDados[04] -> Nome Beneficiario  
aDados[05] -> Data Atendimento/Protocolo
aDados[06] -> CPF
aDados[07] -> Matricula Beneficiario
aDados[08] -> Telefone Central
aDados[09] -> Nome Operadora
aDados[10] -> Numero Protocolo
aDados[11] -> Observacao (somente Guias de Atendimento)
aDados[12] -> Ocorrencia Call Center
aDados[13] -> Solucao Call Center
*/       

If Empty(cFolder) .And. !lPortalWeb
	cFolder := PLSMUDSIS(GetTempPath()+"totvsprinter\") 
EndIf

If lImpEmail .And. Empty(B5J->B5J_EMAIL)                        
	lDisSetup := .F.
EndIf

cFileName := lower("solcan_"+aDados[10]+".pdf")     

If lPortalWeb
	cPathSrv := __RELIMP
ElseIf !Substr(cPathSrv,len(cPathSrv),1) $ "\/"     
	cPathSrv := PLSMUDSIS(cPathSrv + "\")
EndIf
                              
nH   := PLSAbreSem("PL99BRSMF.SMF")
oPrn := FWMSPrinter():New(cFileName,IMP_PDF,.T.,cPathSrv,lDisSetup,.F.,@oPrn,,.T.,.F.,.F.,.T.)
PLSFechaSem(nH,"PL99BRSMF.SMF")

nCol1 	   :=  040 // Margem da coluna
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Resolucao do relatorio                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oPrn:setResolution(72)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Modo retrato                                                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oPrn:setPortrait()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Papel A4                                                                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oPrn:setPaperSize(TAM_A4)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Margem                                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oPrn:setMargin(100,100,100,100) 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime cabecalho                                                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nLin := FS_CabecImp(@oPrn, aDados)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Mensagem principal do corpo                                                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ     
nLin += 110
oPrn:Say(nLin, nCol1, "Ao Beneficiário,", oFontNorm)
nLin += 070
oPrn:Say(nLin, nCol1, aDados[04], oFontNorm)
nLin += 200                                                   
oPrn:Say(nLin, nCol1+470, "Solicitação de Cancelamento de Plano", oFontCab)       
nLin += 200  
oPrn:Say(nLin, nCol1, "Prezado,", oFontNorm)  
nLin += 070
oPrn:Say(nLin, nCol1, "No dia "+aDados[05]+" o beneficiário ", oFontNorm)  
oPrn:Say(nLin, nCol1+0700 , aDados[04], oFontUnder)
oPrn:Say(nLin, nCol1+1500 , "inscrito(a) no CPF "+aDados[06]+",", oFontNorm)  

nLin += 050   
cTexto := ", entrou em contato com a nossa Operadora solicitando cancelamento do plano dos "

oPrn:Say(nLin, nCol1, "portador(a) da matrícula "+aDados[07]+cTexto, oFontNorm)  

nLin += 050   
oPrn:Say(nLin, nCol1, "beneficiário(s):", oFontNorm)    

If len(aDados) > 0   
	
	nLin += 070 
	For nX := 1 to len(aDados[12]) 
		For nY:= 1 to len(aDados[12][nX])
	    	nLin += 050   
	    	nLin := FS_EndPage(nLin,oPrn,aDados)
	    	oPrn:Say(nLin, nCol1    , aDados[12][nX][nY][1], oFontBenNe)
			oPrn:Say(nLin, nCol1+330, aDados[12][nX][nY][2], oFontNorm )  
		Next
   		nLin += 070
	Next
	
EndIf  

nLin += 140
oPrn:Say(nLin, nCol1+50 , "Consequências do cancelamento ou exclusão do contrato de Plano de Saúde" , oFontCab)    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Artigo 15                                    	                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nLin += 035
nLin := impMemo(oPrn,nLin,Artigo15(),aDados,"0")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Observacoes do Beneficiario                 	                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//nLin += 035
//nLin := impMemo(oPrn,nLin,Alltrim(aDados[11]),aDados)
 	
//nLin += 140
//oPrn:Say(nLin, nCol1, "Segue o nosso parecer para ocorrência(s) apresentada(s):", oFontNorm)    
//nLin += 035
//nLin := impMemo(oPrn,nLin,Alltrim(aDados[13]),aDados)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza relatorio                       	                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nLin += 200  
If nLin >= 2850
	nLin := FS_EndPage(nLin,oPrn,aDados)
EndIf	
oPrn:Say(nLin, nCol1 , "Solicitamos, por gentileza, caso restem dúvidas, permanecemos à disposição através da nossa Central de Relacionamento com Cliente, ", oFontNorm)       
nLin += 070
oPrn:Say(nLin, nCol1 , "no número "+aDados[08]+".",oFontNorm)       
nLin += 140
oPrn:Say(nLin, nCol1 , "Atenciosamente,",oFontNorm) 
nLin += 070
oPrn:Say(nLin, nCol1 , aDados[09] , oFontUnder)    

nLin := 2850
oPrn:Say(nLin+070, 2000, "Página "+cValtoChar(oPrn:nPageCount) , oFontUnder) 
	
oPrn:SetViewPDF(.F.)
oPrn:lServer    := .T.    
oPrn:cPathPDF   := cPathSrv   
oPrn:cPathPrint := cPathSrv  
oPrn:setDevice(IMP_PDF)      
If lSrvUnix	
	ajusPath(@oPrn) 
EndIf	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Deleta arquivo se ja existente  									        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FERASE(PLSMUDSIS(cPathSrv)+cFileName) 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera o relatorio   													        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
oPrn:Preview()    
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abre arquivo PDF e deleta no server  								        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  
If !lPortalWeb
	FERASE( PLSMUDSIS(cFolder)+cFileName) //deleta o arquivo se ja existir
	Sleep(2000)
	CpyS2T( PLSMUDSIS(cPathSrv)+cFileName, cFolder, .F. )  
	If !lImpEmail
		Sleep(2000)
		shellExecute("Open", PLSMUDSIS(cFolder)+cFileName, " /k dir", PLSMUDSIS("c:\"), 1 )    
	EndIf

	FERASE( PLSMUDSIS(cPathSrv)+cFileName) //deleta arquivo no servidor
EndIf

Return {lOk,cFolder,cFileName}
                              


//-------------------------------------------------------------------
/*/{Protheus.doc} FS_CabecImp

Imprime cabecalho do relatório da RN 395

@author  Equipe PLS
@version P11
@since   28/06/16
/*/
//-------------------------------------------------------------------   
Static Function FS_CabecImp(oPrn, aDados)
Local nMarSup	   :=  317   	             // Margem superior        
Local nCol1 	   :=  015		             // Margem da coluna1
Local oFontNeg	:= TFont():New("Arial", 16, 16, , .T., , , , .T., .F.)

nLin   := nMarSup     
oPrn:StartPage()     

oPrn:Say(nLin, nCol1, "Protocolo Nº "+ aDados[10], oFontNeg) 
nLin += 070
oPrn:Say(nLin, nCol1+1200, aDados[01]+"-"+aDados[02]+", "+aDados[3], oFontNeg)       
nLin += 140

Return(nLin)  
                       


//-------------------------------------------------------------------
/*/{Protheus.doc} FS_EndPage

Verifica quebra de pagina

@author  Equipe PLS
@version P11
@since   28/06/16
/*/
//-------------------------------------------------------------------   
Static Function FS_EndPage(nLin,oPrn,aDados)             
Local oFontUnder:= TFont():New("Arial", 14, 14, , .T., , , , .T., .F.,.T.)   

If nLin >= 2850
	oPrn:Say(nLin+070, 2000, "Página "+cValtoChar(oPrn:nPageCount) , oFontUnder)
	oPrn:EndPage()  
	nLin := FS_CabecImp(oPrn, aDados)
EndIf

Return nLin  



//-------------------------------------------------------------------
/*/{Protheus.doc} impMemo

Imprime um campo memo

@author  Equipe PLS
@version P11
@since   28/06/16
/*/
//-------------------------------------------------------------------   
Static Function impMemo(oPrn,nLin,cMemo,aDados,cFonte)
Local oFontObs	 := ""
Local aDadObs    := {}     
Local lLoop      := .T.
Local nTamLin    := 110//120     
Local nFor       := 0
Local nContBlank := 0	
Default cFonte   := "1"   

Do Case 
	Case cFonte == "0"//Normal            
    	oFontObs := TFont():New("Arial", 14, 14, , .F., , , , .T., .F.)     
    
    Case cFonte == "1"//Negrito
    	oFontObs := TFont():New("Arial", 14, 14, , .T., , , , .T., .F.)   
EndCase
   
While lLoop
	If len(cMemo) < nTamLin  
		If (nPosChr13 := At(Chr(13),Substr(cMemo,1,nTamLin))) < nTamLin .And. nPosChr13 <> 0  
			Aadd(aDadObs,Substr(cMemo,1,nPosChr13))  
			cMemo := Substr(cMemo,nPosChr13+1,len(cMemo)) 	
		Else	
			Aadd(aDadObs,cMemo)
			lLoop := .F.
		EndIf	
	Else
		If (nPosChr13 := At(Chr(13),Substr(cMemo,1,nTamLin))) < nTamLin .And. nPosChr13 <> 0 
			Aadd(aDadObs,Substr(cMemo,1,nPosChr13))  
			cMemo := Substr(cMemo,nPosChr13+1,len(cMemo)) 		
		Else            
			lBlank     := .F.  
			nContBlank := 0
			While !lBlank 
				If Substr(cMemo,nTamLin-nContBlank,1) == " "
		        	lBlank := .T.
		        Else
		        	nContBlank ++
		        EndIf
		    EndDo   
		    Aadd(aDadObs,Substr(cMemo,1,nTamLin-nContBlank))
			cMemo := Substr(cMemo,(nTamLin-nContBlank)+1,len(cMemo))   
		EndIf	
	EndIf
EndDo   
	
For nFor := 1 to len(aDadObs)     
   	nLin += 050        
   	nLin := FS_EndPage(nLin,oPrn,aDados)
   	aDadObs[nFor] := StrTran(aDadObs[nFor],Chr(10),"")
   	aDadObs[nFor] := StrTran(aDadObs[nFor],Chr(13),"")
   	oPrn:Say(nLin, nCol1+90, aDadObs[nFor] , oFontObs) 
Next

Return nLin    


//-------------------------------------------------------------------
/*/{Protheus.doc} AjusPath

Ajusta paths

@author  Equipe PLS
@version P11
@since   28/06/16
/*/
//-------------------------------------------------------------------  
Static Function AjusPath(oPrn)
oPrn:cFilePrint := StrTran(oPrn:cFilePrint,"\","/",1)
oPrn:cPathPrint := StrTran(oPrn:cPathPrint,"\","/",1)
oPrn:cFilePrint := StrTran(oPrn:cFilePrint,"//","/",1)
oPrn:cPathPrint := StrTran(oPrn:cPathPrint,"//","/",1)
Return



//-------------------------------------------------------------------
/*/{Protheus.doc} Artigo15

Traz o artigo 15: consequencias do cancelamento do plano

@author  Equipe PLS
@version P11
@since   28/06/16
/*/
//-------------------------------------------------------------------  
Static Function Artigo15()
Local cRet := ""

cRet += "I - Eventual ingresso em novo plano de saúde poderá importar:" + Chr(13)
cRet += "a) no cumprimento de novos períodos de carência, observado o disposto no inciso V do artigo 12, daLei nº 9.656, de 3 de junho de 1998;" + Chr(13)
cRet += "b) na perda do direito à portabilidade de carências, caso não tenha sido este o motivo do pedido, nos termos previstos na RN nº 186, de 14 de janeiro de 2009, que dispõe, em especial, sobre a regulamentação da portabilidade das carências previstas no inciso V do art. 12 da Lei nº 9.656, de 3 de junho de 1998;" + Chr(13)
cRet += "c) no preenchimento de nova declaração de saúde, e, caso haja doença ou lesão preexistente – DLP, no cumprimento de Cobertura Parcial Temporária – CPT, que determina, por um período ininterrupto de até 24 meses, a partir da data da contratação ou adesão ao novo plano, a suspensão da cobertura de Procedimentos de Alta Complexidade (PAC), leitos de alta tecnologia e"
cRet += "procedimentos cirúrgicos;" + Chr(13)
cRet += "d) na perda imediata do direito de remissão, quando houver, devendo o beneficiário arcar com o pagamento de um novo contrato de plano de saúde que venha a contratar;" + Chr(13)
cRet += "II - Efeito imediato e caráter irrevogável da solicitação de cancelamento do contrato ou exclusão de"
cRet += "beneficiário, a partir da ciência da operadora ou administradora de benefícios;" + Chr(13)
cRet += "III - As contraprestações pecuniárias vencidas e/ou eventuais coparticipações devidas, nos planos em pré-pagamento ou em pós-pagamento, pela utilização de serviços realizados antes da solicitação de cancelamento ou exclusão do plano de saúde são de responsabilidade do beneficiário;" + Chr(13)
cRet += "IV - As despesas decorrentes de eventuais utilizações dos serviços pelos beneficiários após a data de solicitação de cancelamento ou exclusão do plano de saúde, inclusive nos casos de urgência ou emergência, correrão por sua conta;" + Chr(13)
cRet += "V - A exclusão do beneficiário titular do contrato individual ou familiar não extingue o contrato, sendo assegurado aos dependentes já inscritos o direito à manutenção das mesmas condições contratuais, com a assunção das obrigações decorrentes; e" + Chr(13)
cRet += "VI - A exclusão do beneficiário titular do contrato coletivo empresarial ou por adesão observará as disposições contratuais quanto à exclusão ou não dos dependentes, conforme o disposto no inciso II do parágrafo único do artigo 18, da RN nº 195, de 14 de julho de 2009, que dispõe sobre a classificação e características dos planos privados de assistência à saúde, regulamenta a sua"
cRet += "contratação, institui a orientação para contratação de planos privados de assistência à saúde e dá outras providências." + Chr(13)

Return cRet