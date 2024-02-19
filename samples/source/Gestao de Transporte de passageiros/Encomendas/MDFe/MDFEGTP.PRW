#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TBICONN.CH"
#include "fileio.ch


/*/{Protheus.doc} MdfeGTP3
//TODO Descrição auto-gerada.
@author osmar.junior
@since 07/11/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function MdfeGTP3()               

Local cString     := ""
Local nSerieMDF   := 0
Local aXMLMDFe    := {}
Local nMDF        := ''
Local cMDF        := ''
Local cChvAcesso  := ''
Local nCount      := 0 
Local nCount2     := 0
Local cCodUF      := ''
Local cTpEmis     := ''
Local cUFIni      := ''
Local cUFFim      := ''
Local cCdMunIni	  := ''
Local aCdMunIni	  := {}
Local nCdMunIni	  := 1 
Local cCidIni     := ''
Local cNFe        := ""

Local cCodVei     := ''
Local cAliasDTR   := ''
Local nX          := 0
Local nCapcM3     := 0 
Local cAliasDA4   := ''
Local cAliasDVB   := ''
Local cAliasDUD   := ''
Local cAliasDT6   := ''
Local cAliasCLI   := ''
Local cFilDCAOld  := ''
Local cMunDCAOld  := ''
Local cCodObs	  := ''
Local cQuery      := ''    
     
Local cFilMan     := PARAMIXB[1]
Local cSerMan     := PARAMIXB[2]
Local cNumMan     := PARAMIXB[3]
Local cAmbiente   := PARAMIXB[4]
Local cVerAmb     := PARAMIXB[5]
Local cModalidade := PARAMIXB[6]
Local cEvento     := PARAMIXB[7]
Local cTimeZone   := PARAMIXB[8]
Local cCodGI9     := PARAMIXB[9]

Local cUFPer      := ""
Local cNumRom     := ""
Local cSeek       := ""                   
Local nQtdCte     := 0
Local lRet        := .T.
Local cSertms     := ''
Local lPercMDFe   := .F.
Local aPercurso   := {}   
Local nPos        := 0
Local nEst        := 0
Local cRota       := ""
Local cCNPJAntt   := SuperGetMv( "MV_CNPJANTT", .F., .F. )
Local aAreaSM0    := SM0->(GetArea())
Local aInfSeguro  :={}
Local cAliasDY3   := ''
Local lRoteiro    := .F.
Local lPerc       := .F. 
Local nRecDL1     := 0
Local cAliasDUD2  := ''
Local a190UFRD    := {}
Local cNumRed     := ''
Local cCdMnRed    := ''
Local cNmMnRed    := ''
Local lImpRed     := .F.
Local aAreaSM01   := {}
Local cFilOri	  := ""
Local cViagem	  := ""
Local cCNPJOPer	  := ""
Local cChvCte	  := ""
Local cIsenSub	  := GetMV("MV_ISENSUB",,"")
Local lInfMunDes  := .F.
Local cChave := ''
Local aChaveCte := {}

Private aUF       := {}
Private cCNPJEmiMN:= ''
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Preenchimento do Array de UF                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd(aUF,{"RO","11"})
aAdd(aUF,{"AC","12"})
aAdd(aUF,{"AM","13"})
aAdd(aUF,{"RR","14"})
aAdd(aUF,{"PA","15"})
aAdd(aUF,{"AP","16"})
aAdd(aUF,{"TO","17"})
aAdd(aUF,{"MA","21"})
aAdd(aUF,{"PI","22"})
aAdd(aUF,{"CE","23"})
aAdd(aUF,{"RN","24"})
aAdd(aUF,{"PB","25"})
aAdd(aUF,{"PE","26"})
aAdd(aUF,{"AL","27"})
aAdd(aUF,{"MG","31"})
aAdd(aUF,{"ES","32"})
aAdd(aUF,{"RJ","33"})
aAdd(aUF,{"SP","35"})
aAdd(aUF,{"PR","41"})
aAdd(aUF,{"SC","42"})
aAdd(aUF,{"RS","43"})
aAdd(aUF,{"MS","50"})
aAdd(aUF,{"MT","51"})
aAdd(aUF,{"GO","52"})
aAdd(aUF,{"DF","53"})
aAdd(aUF,{"SE","28"})
aAdd(aUF,{"BA","29"})
aAdd(aUF,{"EX","99"})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posiciona SM0                                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SM0->(MsSeek(cEmpAnt+cFilMan))

If cEvento == "E" //-- Envio Manifesto	
	                                                                                                                     
	cSeek :=  cFilMan+cCodGI9+cSerman+cNumMan
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posiciona MDF                                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("GI9")
	dbSetOrder(1)	//GI9_FILIAL+GI9_CODIGO+GI9_SERIE+GI9_NUMERO 
	If dbSeek(cSeek)		
		
		cString := MDFeIde(cFilMan,cSerman,cNumMan,cModalidade,cVerAmb,cAmbiente,cTimeZone,@cChave)
		cString += MDFeEmit(cFilMan)	
		cString += MDFeModal(cVerAmb)		
		cString += MDFeInfDoc(@nQtdCte,aChaveCte)
		cString += infSeg()
		cString += infProPred(cFilMan,aChaveCte)  
		cString += MDFeTotais(nQtdCte)	
		cString += InfoAdic()
		cString += '</infMDFe>'
			cString += MDFeInfMDFeSupl(cChave,cAmbiente)
		cString += '</MDFe>'		
		

	EndIf
EndIf

MEMOWRIT('mdfe-'+cSerMan+'-'+cNumMan+'.XML',cString)

RestArea(aAreaSM0)
Return({cChave,EncodeUTF8(cString),cNumMan,cSerMan})


/*/{Protheus.doc} ConvType
//TODO Descrição auto-gerada.
@author osmar.junior
@since 07/11/2019
@version 1.0
@return ${return}, ${return_description}
@param xValor, , descricao
@param nTam, numeric, descricao
@param nDec, numeric, descricao
@param lInt, logical, descricao
@type function
/*/
Static Function ConvType(xValor,nTam,nDec,lInt)

Local   cNovo := ""
Default nDec  := 0
Default lInt  := .F.

Do Case
	Case ValType(xValor)=="N"
		If lInt .And. nDec=0
			xValor := Int(xValor)
		EndIf
		cNovo := AllTrim(Str(xValor,nTam,nDec))
		If "*"$cNovo .and. nDec=0
			cNovo:= Replicate("9",nTam)
		EndIf
	Case ValType(xValor)=="D"
		cNovo := FsDateConv(xValor,"YYYYMMDD")
		cNovo := SubStr(cNovo,1,4)+"-"+SubStr(cNovo,5,2)+"-"+SubStr(cNovo,7)
	Case ValType(xValor)=="C"
		If nTam==Nil
			xValor := AllTrim(xValor)
		EndIf
		Default nTam := 60
		cNovo := NoAcentoCte(SubStr(xValor,1,nTam))
EndCase
Return(cNovo)


/*/{Protheus.doc} Inverte
//TODO Descrição auto-gerada.
@author osmar.junior
@since 07/11/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function Inverte()

Local cRet := ""

cRet := Alltrim(Str(Randomize( 10000000, 99999999 ))) 

Return(cRet)


/*/{Protheus.doc} MDFCHVAC
//TODO Descrição auto-gerada.
@author osmar.junior
@since 07/11/2019
@version 1.0
@return ${return}, ${return_description}
@param cUF, characters, descricao
@param cAAMM, characters, descricao
@param cCNPJ, characters, descricao
@param cMod, characters, descricao
@param cSerie, characters, descricao
@param nMDF, numeric, descricao
@param cMDF, characters, descricao
@type function
/*/
Static Function MDFCHVAC(cUF, cAAMM, cCNPJ, cMod, cSerie, nMDF, cMDF)
Local nCount      := 0
Local nSequenc    := 2
Local nPonderacao := 0
Local cResult     := ''
Local cChvAcesso  := cUF +  cAAMM + cCNPJ + cMod + cSerie + nMDF + cMDF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³SEQUENCIA DE MULTIPLICADORES (nSequenc), SEGUE A SEGUINTE        ³
//³ORDENACAO NA SEQUENCIA: 2,3,4,5,6,7,8,9,2,3,4... E PRECISA SER   ³
//³GERADO DA DIREITA PARA ESQUERDA, SEGUINDO OS CARACTERES          ³
//³EXISTENTES NA CHAVE DE ACESSO INFORMADA (cChvAcesso)             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nCount := Len( AllTrim(cChvAcesso) ) To 1 Step -1
	nPonderacao += ( Val( SubStr( AllTrim(cChvAcesso), nCount, 1) ) * nSequenc )
	nSequenc += 1
	If (nSequenc == 10)
		nSequenc := 2
	EndIf
Next nCount

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Quando o resto da divisão for 0 (zero) ou 1 (um), o DV devera   ³
//³ ser igual a 0 (zero).                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( mod(nPonderacao,11) > 1)
	cResult := (cChvAcesso + cValToChar( (11 - mod(nPonderacao,11) ) ) )
Else
	cResult := (cChvAcesso + '0')
EndIf

Return(cResult)

/*/{Protheus.doc} NoPontos
//TODO Descrição auto-gerada.
@author osmar.junior
@since 07/11/2019
@version 1.0
@return ${return}, ${return_description}
@param cString, characters, descricao
@type function
/*/
Static Function NoPontos(cString)
Local cChar     := ""
Local nX        := 0
Local cPonto    := "."
Local cBarra    := "/"
Local cTraco    := "-"
Local cVirgula  := ","
Local cBarraInv := "\"
Local cPVirgula := ";"
Local cUnderline:= "_"
Local cParent   := "()"

For nX:= 1 To Len(cString)
	cChar := SubStr(cString, nX, 1)
	If cChar$cPonto+cVirgula+cBarra+cTraco+cBarraInv+cPVirgula+cUnderline+cParent
		cString := StrTran(cString,cChar,"")
		nX := nX - 1
	EndIf
Next
cString := AllTrim(_NoTags(cString))

Return cString


/*/{Protheus.doc} RetInfCTe
//TODO Descrição auto-gerada.
@author osmar.junior
@since 07/11/2019
@version 1.0
@return ${return}, ${return_description}
@param cChvCte, characters, descricao
@param cChvCtg, characters, descricao
@type function
/*/
Static Function RetInfCTe(cChvCte,cChvCtg)
	Local cRet := ''
	Default cChvCtg := ''
	
	cRet += '<infCTe>'                             
	cRet += '<chCTe>' +cChvCte+ '</chCTe>'	                                                                                   
	If !Empty(cChvCtg)
		cRet += '<SegCodBarra>'+ Alltrim(cChvCtg) + '</SegCodBarra>'
	EndIf	
					
	cRet += '</infCTe>'  

Return cRet 


/*/{Protheus.doc} MDFeIde
//TODO Descrição auto-gerada.
@author osmar.junior
@since 07/11/2019
@version 1.0
@return ${return}, ${return_description}
@param cFilMan, characters, descricao
@param cSerieMDF, characters, descricao
@param cNumdoc, characters, descricao
@param cModalidade, characters, descricao
@param cVerAmb, characters, descricao
@param cAmbiente, characters, descricao
@param cTimeZone, characters, descricao
@type function
/*/
Static Function MDFeIde(cFilMan,cSerieMDF,cNumdoc,cModalidade,cVerAmb,cAmbiente,cTimeZone,cChave)
	Local cString := ''
	Local aAreaSM0 := SM0->(GetArea())
	Local nCount := 0
	Local aCdMunIni :={}
	Local nCdMunIni := 0
	Local cCdMunIni	:= ''
	Local cEst := ''
	Local cMun := ''
	Local cCidIni :=''	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Header do Arquivo XML                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cString += '<MDFe xmlns="http://www.portalfiscal.inf.br/mdfe">'	
	dbSelectArea("SM0")	
	OpenSM0() //Abrir Tabela SM0 (Empresa/Filial)	
	SM0->(dbSetOrder(1))
	SM0->(dbSeek(cEmpAnt + cFilMan,.T.)) //Posiciona Empresa	
	If aScan(aUF,{|x| x[1] ==  AllTrim(SM0->M0_ESTENT) }) != 0 // Confere se Uf do Emitente esta OK
		cCodUF := aUF[ aScan(aUF,{|x| x[1] == AllTrim(SM0->M0_ESTENT) }), 2]
	Else
		cCodUF := ''
	EndIf                                                
			
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Formato de Impressao do MDF-e                                   ³
	//³ 1 - Normal                                                      ³
	//³ 2 - Contingência                   								³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cModalidade == '1'
		cTpEmis := '1'
	ElseIf cModalidade == '2'
		cTpEmis := '2'
	EndIf

	
	cMDF := Inverte()
	cChvAcesso := MDFCHVAC( cCodUF,;
					   ( SubStr(DToS(GI9->GI9_EMISSA),3, 2) +  SubStr(DToS(GI9->GI9_EMISSA),5, 2) ),;
						AllTrim(SM0->M0_CGC),;
						 '58',;
						 StrZero( val(PadR(cSerieMDF,3)), 3),;
						 StrZero( val(PadR(cNumdoc,9)), 9),;
						 cTpEmis + cMDF)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicio dos Dados do MDFe                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cNFe    := 'MDFe' + AllTrim(cChvAcesso)
	cChave  := AllTrim(cChvAcesso)			
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Versao do MDF-e, de acordo com o parametro                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cString += '<infMDFe Id="MDFe' + AllTrim(cChvAcesso) + '" versao="' + cVerAmb + '">'
				
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ TAG: IDE -- Identificacao do MDF-e                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Identificacao do Ambiente.                                      ³
	//³ 1 - Producao                                                    ³
	//³ 2 - Homologacao                                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                         
	
	cString += '<ide>'
	cString += '<cUF>'  + NoAcentoCte( cCodUF )	 + '</cUF>'
	cString += '<tpAmb>' + cAmbiente + '</tpAmb>'          		
	cString += '<tpEmit>1</tpEmit>'   
	cString += '<mod>58</mod>'               

	cString += '<serie>' +  Alltrim(cSerieMDF) + '</serie>'
			
	cString += '<nMDF>'+ NoAcentoCte( cValtoChar( Val( AllTrim(cNumdoc) ) ) ) + '</nMDF>'

	cString += '<cMDF>'+ NoAcentoCte(Substr(cMDF,1,8)) + '</cMDF>'
	
	cString += '<cDV>' + SubStr( AllTrim(cChvAcesso), Len( AllTrim(cChvAcesso) ), 1) + '</cDV>'

	cString += '<modal>1</modal>'  //Rodoviario
	
	cString += '<dhEmi>'+ SubStr(DToS(GI9->GI9_EMISSA), 1, 4) + "-";
						+ SubStr(DToS(GI9->GI9_EMISSA), 5, 2) + "-";
						+ SubStr(DToS(GI9->GI9_EMISSA), 7, 2) + "T";
						+ SubStr(AllTrim(GI9->GI9_HORAEM), 1, 2) + ":";
						+ SubStr(AllTrim(GI9->GI9_HORAEM), 4, 2) + ":00";
						+ cTimeZone + '</dhEmi>'

	cString += '<tpEmis>' + cTpEmis + '</tpEmis>'

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processo de Emissao do CT-e                                     ³
	//³ 0 - emissao com aplicativo do contribuinte                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cString += '<procEmi>0</procEmi>'
	
	cString += '<verProc>' + cVerAmb + '</verProc>'
		
	cString += '<UFIni>' + NoAcentoCte(GI9->GI9_UFINI) + '</UFIni>' 					
	
	cString += '<UFFim>' + NoAcentoCte(GI9->GI9_UFFIM) + '</UFFim>'   
	
	aCdMunIni := Municipos(GI9->GI9_CODIGO)
	//For nCdMunIni := 1 To Len(aCdMunIni)
		
	//	cCdMunIni	:= aCdMunIni[nCdMunIni,1]
	//	cCidIni		:= aCdMunIni[nCdMunIni,2]
		cCdMunIni	:= SM0->M0_CODMUN
		cEst := CodEstado(SUBSTR(cCdMunIni,1,2))
		cMun := SUBSTR(cCdMunIni,3)	
		cCidIni		:= NoAcentoCte(Posicione("CC2",1, xFilial('CC2')+cEst+cMun,"CC2_MUN"))							

		cString += '<infMunCarrega>'  
		cString += '<cMunCarrega>' + NoAcentoCte(cCdMunIni) + '</cMunCarrega>'  
		cString += '<xMunCarrega>' + NoAcentoCte(cCidIni) 	+ '</xMunCarrega>'
		cString += '</infMunCarrega>' 

	//Next nCdMunIni	                                                         
	
	aPercurso := Percurso(GI9->GI9_CODIGO)
	If Len(aPercurso) > 0	            
		For nCount:= 1 to Len(aPercurso)
			cString += '<infPercurso>' 
			cString += '<UFPer>' + NoAcentoCte( aPercurso[nCount] ) + '</UFPer>'
			cString += '</infPercurso>'									
		Next nCount
	EndIf				

	/*
	If !Empty((cAliasDTR)->DTR_DATINI) 
		cString += '<dhIniViagem>'+ SubStr((cAliasDTR)->DTR_DATINI, 1, 4) + "-";
							+ SubStr((cAliasDTR)->DTR_DATINI, 5, 2) + "-";
							+ SubStr((cAliasDTR)->DTR_DATINI, 7, 2) + "T";
							+ SubStr(AllTrim((cAliasDTR)->DTR_HORINI), 1, 2) + ":";
							+ SubStr(AllTrim((cAliasDTR)->DTR_HORINI), 3, 2) + ":00";
							+ cTimeZone + '</dhIniViagem>'
	EndIf
	
	*/
	
	cString += '</ide>'
	SM0->(RestArea(aAreaSM0)) //Restaura Tabela
	
Return cString


/*/{Protheus.doc} MDFeEmit
//TODO Descrição auto-gerada.
@author osmar.junior
@since 07/11/2019
@version 1.0
@return ${return}, ${return_description}
@param cFilMan, characters, descricao
@type function
/*/
Static Function MDFeEmit(cFilMan)

Local cString := ''
Local aAreaSM0 := SM0->(GetArea())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ TAG: Emit -- Identificacao do Emitente do Manifesto              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SM0")	
	OpenSM0() //Abrir Tabela SM0 (Empresa/Filial)	
	SM0->(dbSetOrder(1))
	SM0->(dbSeek(cEmpAnt + cFilMan,.T.)) //Posiciona Empresa	
	
	cString += '<emit>'

	If SM0->M0_TPINSC == 3 //CPF
		cString += '<CPF>' + NoPontos(SM0->M0_CGC) + '</CPF>'
	Else
		cString += '<CNPJ>' + NoPontos(SM0->M0_CGC) + '</CNPJ>'
	EndIf
	cCNPJEmiMN := NoPontos(SM0->M0_CGC)
	
	If (AllTrim(SM0->M0_INSC) == 'ISENTO')
		cString += '<IE>ISENTO</IE>'
	Else
		cString += '<IE>' + NoPontos(SM0->M0_INSC) + '</IE>'
	EndIf
	
	cString += '<xNome>' + NoAcentoCte(SubStr(SM0->M0_NOMECOM,1,60)) + '</xNome>'
	cString += '<xFant>' + NoAcentoCte(SM0->M0_NOME) + '</xFant>'
	cString += '<enderEmit>'
	cString += '<xLgr>' + NoAcentoCte(FisGetEnd(SM0->M0_ENDENT)[1]) + '</xLgr>'
	cString += '<nro>'  + Iif(FisGetEnd(SM0->M0_ENDENT)[2]<>0, AllTrim(cValtoChar( FisGetEnd(SM0->M0_ENDENT)[2])),"S/N") + '</nro>'
	If !Empty(NoAcentoCte(FisGetEnd(SM0->M0_ENDENT)[4]))
		cString += '<xCpl>' + NoAcentoCte(FisGetEnd(SM0->M0_ENDENT)[4]) + '</xCpl>'
	EndIf
	If Empty(AllTrim(SM0->M0_BAIRENT))
		cString += '<xBairro>BAIRRO NAO CADASTRADO</xBairro>'
	Else
		cString += '<xBairro>' + NoAcentoCte( SM0->M0_BAIRENT ) + '</xBairro>'
	EndIf
				
	cString += '<cMun>' + Alltrim(str(Val(SM0->M0_CODMUN))) + '</cMun>' 
	cString += '<xMun>' + NoAcentoCte( SM0->M0_CIDENT ) 	+ '</xMun>'
	cString += '<CEP>'  + Alltrim(SM0->M0_CEPENT)		    + '</CEP>'
	cString += '<UF>'   + NoAcentoCte( SM0->M0_ESTENT ) 	+ '</UF>'
	If !Empty (NoPontos(SM0->M0_TEL))
		cString += '<fone>' + cValtoChar(NoPontos(SM0->M0_TEL))      + '</fone>'
	EndIf
	cString += '</enderEmit>'
	cString += '</emit>'

	SM0->(RestArea(aAreaSM0)) //Restaura Tabela
	
Return cString


/*/{Protheus.doc} MDFeModal
//TODO Descrição auto-gerada.
@author osmar.junior
@since 07/11/2019
@version 1.0
@return ${return}, ${return_description}
@param cVerAmb, characters, descricao
@type function
/*/
Static Function MDFeModal(cVerAmb)
	Local cTmsAntt    := SuperGetMv( "MV_TMSANTT", .F., .F. )
	Local cString:= ""
	Local nTara := 0
	Local cCodBem:= ''
	Local nCount :=  0
	Local aCondutores :={}
	Local aContrat := Contratantes(GI9->GI9_CODIGO)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ TAG: InfModal -- Informacoes do modal Rodoviario                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	cString += '<infModal versaoModal="'+cVerAmb+'">'
	cString += '<rodo>'	
	If !Empty(cTmsAntt)	
		cString += '<infANTT>'
			cString += '<RNTRC>' + SubStr(AllTrim(cTmsAntt),1,8)+ '</RNTRC>'
			If Len(aContrat) > 0	
				For nCount:= 1 to Len(aContrat)
					cString +='<infContratante>'
					//cString +='<CPF>26970513840</CPF>'
					If aContrat[nCount][1]=='F'
						cString +='<CPF>'+aContrat[nCount][2]+'</CPF>'
					Else
						cString +='<CNPJ>'+aContrat[nCount][2]+'</CNPJ>'
					EndIf
					cString +='</infContratante>'
				Next nCount
			EndIf			 
		cString += '</infANTT>'	
	EndIf

	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ TAG: Veic -- Tag com informacoes do veiculo                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	cString += '<veicTracao>'
						
	cString += '<cInt>'    + NoAcentoCte(GI9->GI9_VEICUL)    + '</cInt>'
	cString += '<placa>'   + NoAcentoCte(GI9->GI9_PLACA)  + '</placa>'
	//If !Empty(RENAVA)
	//	cString += '<RENAVAM>' + NoAcentoCte((cAliasDA3)->DA3_RENAVA) + '</RENAVAM>'				
	//EndIf
	
	cString += '<tara>'    + ConvType(GI9->GI9_TARAVE 	, 6,0, .T.)    + '</tara>'	
 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ TAG: Condutor -- Condutor do Veiculo                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ					
	aCondutores := Condutores(GI9->GI9_CODIGO)
	If Len(aCondutores) > 0	            
		For nCount:= 1 to Len(aCondutores)
			cString += '<condutor>'
			cString +=   '<xNome>' + NoAcentoCte(aCondutores[nCount][1]) +'</xNome>
			cString +=   '<CPF>'   + AllTrim(aCondutores[nCount][2]) +'</CPF>'
			cString += '</condutor>'
		Next nCount
	EndIf	
	cString +=   '<tpRod>01</tpRod>' //01-truck	
	cString +=   '<tpCar>00</tpCar>' //NAO APLICAVEL
	//If !Empty(cCodBem)
	//	cString +=   '<UF>'   + Posicione("ST9",1,xFilial("ST9")+ cCodBem,"T9_UFEMPLA"  ) +'</UF>'	
	//Else
		cString +=   '<UF>SP</UF>'	
	//EndIf					
				
	cString += '</veicTracao>'
	
	cString += '</rodo>'
	cString += '</infModal>'                       
	
Return  cString


/*/{Protheus.doc} MDFeInfDoc
//TODO Descrição auto-gerada.
@author osmar.junior
@since 07/11/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function MDFeInfDoc(nQtdCte,aChaveCte)
	Local cString  := ""
	Local cAliasTmp := GetNextAlias()
	Local cMunic	:= ''
	Local cCodigo	:= GI9->GI9_CODIGO
	Local cEst := ''
	Local cMun := ''
	Local lAddCTE := .F.	

	BeginSql alias cAliasTmp
		SELECT GIF_CODMUN,GIF_CHCTE
		FROM %table:GIB% GIB INNER JOIN %table:GIF% GIF	ON GIB_FILIAL = GIF_FILIAL AND GIB_CODIGO = GIF_CODIGO AND GIB_CODMUN = GIF_CODMUN
		WHERE 	GIB_FILIAL = %xFilial:GIB% AND 				
				GIB_CODIGO = %exp:alltrim(cCodigo)% AND 			
				GIB.%notDel% AND
				GIF.%notDel%				
	EndSql	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ TAG: InfDoc -- Informacoes dos Doctos vinculados ao Manifesto ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
	cString += '<infDoc>'                                      
				   
	nQtdCte:= 0
	If (cAliasTmp)->(!EoF())
		While (cAliasTmp)->(!Eof())			
			If cMunic <> (cAliasTmp)->GIF_CODMUN
				If lAddCTE
					cString += '</infMunDescarga>' 
					lAddCTE := .F.
				EndIf
				cEst := CodEstado(SUBSTR((cAliasTmp)->GIF_CODMUN,1,2))
				cMun := SUBSTR((cAliasTmp)->GIF_CODMUN,3)			
				cString += '<infMunDescarga>'
				cString += '<cMunDescarga>' + NoAcentoCte((cAliasTmp)->GIF_CODMUN) + '</cMunDescarga>'		
				cString += '<xMunDescarga>' + NoAcentoCte(Posicione("CC2",1, xFilial('CC2')+cEst+cMun,"CC2_MUN")) + '</xMunDescarga>'		
				cMunic := (cAliasTmp)->GIF_CODMUN	
				cChvCte :=(cAliasTmp)->GIF_CHCTE 			
				cString += RetInfCTe(  cChvCte  )
				nQtdCte += 1 							
				aADD(aChaveCte,	cChvCte)
			Else
				cChvCte :=(cAliasTmp)->GIF_CHCTE 			
				cString += RetInfCTe(  cChvCte  )
				nQtdCte += 1 		    				
				aADD(aChaveCte,	cChvCte)
			EndIf
			lAddCTE := .T.			
			(cAliasTmp)->(DbSkip())                                     				
		End
		cString += '</infMunDescarga>' 
	EndIf
	
	cString += '</infDoc>'

Return cString


/*/{Protheus.doc} MDFeTotais
//TODO Descrição auto-gerada.
@author osmar.junior
@since 07/11/2019
@version 1.0
@return ${return}, ${return_description}
@param nQtdCte, numeric, descricao
@type function
/*/
Static Function MDFeTotais(nQtdCte)
	Local cString := ''
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ TAG: Tot -- Totalizadores da carga transportada e seus doctos fiscais ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cString += '<tot>'
	If nQtdCte > 0
		cString += '<qCTe>' + cValtoChar(nQtdCte) + '</qCTe>'				
	EndIf
	
	cString += '<vCarga>'   + ConvType(GI9->GI9_VCARGA, 13, 2) + '</vCarga>'
	cString += '<cUnid>01</cUnid>'			        	//01- KG, 02- TON
	cString += '<qCarga>'   + ConvType(GI9->GI9_PCARGA, 11, 4) + '</qCarga>'
	cString += '</tot>'

Return cString


/*/{Protheus.doc} MDFeInfMDFeSupl
//TODO Descrição auto-gerada.
@author osmar.junior
@since 07/11/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function MDFeInfMDFeSuplc(cChvAcesso,cAmbiente)
Local cString := ''

	//-- TAG: infMDFeSupl -- Informações suplementares do MDF-e QRCod
	
	cString += '<infMDFeSupl>'
	cString +=  '<qrCodMDFe>'
	cString += 'https://dfe-portal.svrs.rs.gov.br/mdfe/QRCode?chMDFe='+ cChvAcesso + '&amp;tpAmb=' + cAmbiente 
	cString +=  '</qrCodMDFe>'
	cString += '</infMDFeSupl>'	
		

Return cString


/*/{Protheus.doc} Municipos
//TODO Descrição auto-gerada.
@author osmar.junior
@since 07/11/2019
@version 1.0
@return ${return}, ${return_description}
@param cCodigo, characters, descricao
@type function
/*/
Static Function Municipos(cCodigo)
	Local aMunic := {}
	Local cAliasTmp := GetNextAlias()
	Local cNomeMunic := ''
	Local cEst := ''
	Local cMun := ''

	BeginSql alias cAliasTmp
		SELECT GIB.GIB_CODMUN
		FROM %table:GIB% GIB		
		WHERE 	GIB_FILIAL = %xFilial:GIB% AND 
				GIB_CODIGO = %exp:alltrim(cCodigo)% AND 			
				GIB.%notDel%		
	EndSql
	
	If (cAliasTmp)->(!EoF())
		While (cAliasTmp)->(!EoF())
			cEst := CodEstado(SUBSTR((cAliasTmp)->GIB_CODMUN,1,2))
			cMun := SUBSTR((cAliasTmp)->GIB_CODMUN,3)
			cNomeMunic := Posicione("CC2",1,FWxFilial("CC2")+cEst+cMun,"CC2_MUN" )
			AADD( aMunic, { (cAliasTmp)->GIB_CODMUN, ALLTRIM(cNomeMunic) } )
			(cAliasTmp)->(DbSkip())
		End	
	EndIf
	
Return aMunic


/*/{Protheus.doc} Percurso
//TODO Descrição auto-gerada.
@author osmar.junior
@since 07/11/2019
@version 1.0
@return ${return}, ${return_description}
@param cCodigo, characters, descricao
@type function
/*/
Static Function Percurso(cCodigo) 
	Local aPercurso := {}
	Local cAliasTmp := GetNextAlias()

	BeginSql alias cAliasTmp
		SELECT GIA.GIA_UF
		FROM %table:GIA% GIA		
		WHERE 	GIA_FILIAL = %xFilial:GIA% AND 
				GIA_CODIGO = %exp:alltrim(cCodigo)% AND 			
				GIA.%notDel%		
	EndSql
	
	If (cAliasTmp)->(!EoF())
		While (cAliasTmp)->(!EoF())	
			AADD( aPercurso,  (cAliasTmp)->GIA_UF )
			(cAliasTmp)->(DbSkip())
		End	
	EndIf
	
Return aPercurso


/*/{Protheus.doc} InfoAdic
//TODO Descrição auto-gerada.
@author osmar.junior
@since 07/11/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static function InfoAdic()
	Local cString := ''
	Local cCodObs := GI9->GI9_OBSERV
	
	If !Empty(cCodObs)                   
		cString += '<infAdic>'              
		cString +=  '<infAdFisco>' + NoAcentoCte(SubStr(cCodObs,1,320)) + '</infAdFisco>'
		cString += '</infAdic>'              
	EndIf

Return cString


/*/{Protheus.doc} CodEstado
//TODO Descrição auto-gerada.
@author osmar.junior
@since 07/11/2019
@version 1.0
@return ${return}, ${return_description}
@param cCodigo, characters, descricao
@type function
/*/
Static function CodEstado(cCodigo)
	Local cCodUF :=''

	If aScan(aUF,{|x| x[2] ==  AllTrim(cCodigo) }) != 0 // Confere se Uf do Emitente esta OK
		cCodUF := aUF[aScan(aUF,{|x| x[2] ==  AllTrim(cCodigo) }), 1]
	EndIf 
	
Return cCodUF


/*/{Protheus.doc} Condutores
//TODO Descrição auto-gerada.
@author osmar.junior
@since 07/11/2019
@version 1.0
@return ${return}, ${return_description}
@param cCodigo, characters, descricao
@type function
/*/
Static Function Condutores(cCodigo)
	Local aCondutores:= {}
	Local cAliasTmp := GetNextAlias()
	Local cNomeMunic := ''
	Local cNome := ''
	Local cCPF := ''

	BeginSql alias cAliasTmp
		SELECT GIG.GIG_CODCON
		FROM %table:GIG% GIG	
		WHERE 	GIG_FILIAL = %xFilial:GIG% AND 
				GIG_CODIGO = %exp:alltrim(cCodigo)% AND 			
				GIG.%notDel%		
	EndSql
	
	If (cAliasTmp)->(!EoF())
		While (cAliasTmp)->(!EoF())
			cNome := AllTrim( Posicione("GYG",1,FWxFilial("GYG")+(cAliasTmp)->GIG_CODCON,"GYG_NOME" ) )
			cCPF :=  AllTrim( Posicione("GYG",1,FWxFilial("GYG")+(cAliasTmp)->GIG_CODCON,"GYG_CPF" ) )		 
			AADD( aCondutores, { cNome, cCPF } )
			(cAliasTmp)->(DbSkip())
		End	
	EndIf
	
Return aCondutores


/*/{Protheus.doc} infSeg
//TODO Descrição auto-gerada.
@author osmar.junior
@since 07/11/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function infSeg()
	Local cString := ''
	Local cAliasTmp := GetNextAlias()
	Local cCNPJ := ''
	Local cCodigo := GI9->GI9_CODIGO
	
	BeginSql alias cAliasTmp
		SELECT GIF_CNPJ,GIF_NOMESE,GIF_NAPOLI,GIF_NAVERB
		FROM %table:GIF% GIF	
		WHERE 	GIF_FILIAL = %xFilial:GIF% AND 
				GIF_CODIGO = %exp:alltrim(cCodigo)% AND 			
				GIF.%notDel%		
	EndSql
	
	If (cAliasTmp)->(!EoF())
		While (cAliasTmp)->(!EoF())		
		
			cString += '<seg>'
			cString += '<infResp>'
			cString += '<respSeg>1</respSeg>'	
			cString += '</infResp>'	
			cString += '<infSeg>'	
			cString += '<xSeg>'    + NoAcentoCte( (cAliasTmp)->GIF_NOMESE )   + '</xSeg>'
			cString += '<CNPJ>'   	+ NoPontos( (cAliasTmp)->GIF_CNPJ )  + '</CNPJ>'	
			cString += '</infSeg>'
			cString += '<nApol>'  	+ AllTrim( (cAliasTmp)->GIF_NAPOLI )  + '</nApol>'				
			cString += '<nAver>'  	+ AllTrim( (cAliasTmp)->GIF_NAVERB )  + '</nAver>'		
			cString += '</seg>'	
				
			(cAliasTmp)->(DbSkip())
		End	
	EndIf

Return cString


/*/{Protheus.doc} Contratantes
//TODO Descrição auto-gerada.
@author osmar.junior
@since 12/11/2019
@version 1.0
@return ${return}, ${return_description}
@param cCodigo, characters, descricao
@type function
/*/
Static Function Contratantes(cCodigo)
	Local aContrat:= {}
	Local cAliasTmp := GetNextAlias()

	BeginSql alias cAliasTmp
		SELECT GIF_TPCLIE,GIF_DOCCLI
		FROM %table:GIF% GIF	
		WHERE 	GIF_FILIAL = %xFilial:GIF% AND 
				GIF_CODIGO = %exp:alltrim(cCodigo)% AND 			
				GIF.%notDel%		
	EndSql
	
	If (cAliasTmp)->(!EoF())
		While (cAliasTmp)->(!EoF())			
					 
			AADD( aContrat, { (cAliasTmp)->GIF_TPCLIE, ALLTRIM( (cAliasTmp)->GIF_DOCCLI) } )
			(cAliasTmp)->(DbSkip())
		End	
	EndIf
	
Return aContrat


/*/{Protheus.doc} infProPred
//TODO Descrição auto-gerada.
@author osmar.junior
@since 10/09/2020
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function infProPred(cFilMan,aChaveCte)
	Local cString := ''
	Local aAreaSM0 := SM0->(GetArea())
	Local nX := 0

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//?TAG: Emit -- Identificacao do Emitente do Manifesto              ?
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SM0")	
	OpenSM0() //Abrir Tabela SM0 (Empresa/Filial)	
	SM0->(dbSetOrder(1))
	SM0->(dbSeek(cEmpAnt + cFilMan,.T.)) //Posiciona Empresa	


	cString +='<prodPred>'
	cString +='<tpCarga>05</tpCarga>'
	cString +='<xProd>Encomendas</xProd>'
	cString +='<infLotacao>'
		cString +='<infLocalCarrega>'
			cString +='<CEP>'+ NoAcentoCte( SM0->M0_CEPENT ) +'</CEP>'
		cString +='</infLocalCarrega>'
		For nX:= 1 To Len(aChaveCte)
			cString +='<infLocalDescarrega>'
				cString +='<CEP>'+ CEPDesCte( aChaveCte[nX] ) +'</CEP>'
			cString +='</infLocalDescarrega>'
		Next nX
		cString +='</infLotacao>'
	cString +='</prodPred>'

	SM0->(RestArea(aAreaSM0)) //Restaura Tabela

Return cString


/*/{Protheus.doc} CEPDesCte
//TODO Descrição auto-gerada.
@author osmar.junior
@since 10/09/2020
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function CEPDesCte(cChave)
	Local cCEP :=''
	Local cAliasTmp := GetNextAlias()

	BeginSql alias cAliasTmp
		SELECT GI6_CEPENC
		FROM %table:GI6% GI6 INNER JOIN %table:G99% G99	
		ON GI6_FILIAL = G99_FILIAL AND 
		GI6_CODIGO = G99_CODREC
		WHERE 	GI6_FILIAL = %xFilial:GI6% AND 				
				G99_CHVCTE = %exp:alltrim(cChave)% AND 			
				GI6.%notDel% AND
				G99.%notDel%				
	EndSql	

	If (cAliasTmp)->(!EoF())		
		cCEP := (cAliasTmp)->(GI6_CEPENC)  		
	End

Return cCEP
