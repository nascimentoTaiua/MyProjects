#INCLUDE "PROTHEUS.CH"


/*/{Protheus.doc} GtpEnvAtm
@author flavio.martins
@since 11/11/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function GtpEnvAtm()
Local cTipo 	:= PARAMIXB[1]
Local cFilDoc 	:= PARAMIXB[2]
Local cNumDoc	:= PARAMIXB[3]
Local cSerie	:= PARAMIXB[4]
Local cCodSeg	:= PARAMIXB[5]
Local cXml		:= ''
Local aRetAvb	:= {}

	 cXml := GTPRetXml(cTipo, cFilDoc, cNumDoc, cSerie)
	 
	 If Empty(cXml)
	 	aadd(aRetAvb,.F.)
	 	aadd(aRetAvb, {'999',"XML não encontrado"})
	 Else
	 	aRetAvb := EnviaAverb(cCodSeg, cXml)
	 Endif
	 
Return aRetAvb

/*/{Protheus.doc} GTPRetXml
@author flavio.martins
@since 11/11/2019
@version 1.0
@return ${return}, ${return_description}
@param cTipo, characters, descricao
@param cFilDoc, characters, descricao
@param cNumDoc, characters, descricao
@param cSerie, characters, descricao
@type function
/*/
Static Function GTPRetXml(cTipo, cFilDoc, cNumDoc, cSerie)
Local oWS
Local oXmlExp
Local oRetEvCanc
Local nPosChave
Local aAreaSM0	:= SM0->(GetArea())
Local cURL 		:= PadR(GetNewPar("MV_SPEDURL","http://"),250) 
Local cEntidade := getCfgEntidade()
Local cXml 		:= ''
Local aRetAverb	:= {}
Local cXmlCan
Local lOk		:= .F.
Local nPosChave
Local cChaveCan

	oWS:= WSNFeSBRA():New()
	oWS:cUSERTOKEN    := "TOTVS"
	oWS:cID_ENT       := cEntidade
	oWS:_URL          := AllTrim(cURL)+"/NFeSBRA.apw"
	oWS:cIdInicial    := cSerie + cNumDoc
	oWS:cIdFinal      := cSerie + cNumDoc
	oWS:nDIASPARAEXCLUSAO := 0

	If oWS:RETORNAFAIXA() .And. Len(oWs:oWSRETORNAFAIXARESULT:OWSNOTAS:oWSNFES3) > 0
	
		If cTipo == '1' // Normal
			
			cXML := AllTrim("<cteProc>")
			cXML += AllTrim(oWs:oWSRETORNAFAIXARESULT:OWSNOTAS:oWSNFES3[1]:oWSNFE:cXML)
			cXML += AllTrim(oWs:oWSRETORNAFAIXARESULT:OWSNOTAS:oWSNFES3[1]:oWSNFE:cXMLPROT)
			cXML += AllTrim("</cteProc>")
			
		ElseIf cTipo == '2' // Cancelamento
		
			cXml  := oWs:oWSRETORNAFAIXARESULT:OWSNOTAS:oWSNFES3[1]:oWSNFECANCELADA:cXML
			
			oWS:cID_EVENTO	:= "110111"  
			nPosChave := At("<chCTe>",cXml)+7
			cChaveCan := SubStr(cXml,nPosChave,44)
			     
			oWS:cChvInicial	:= cChaveCan
			oWS:cChvFinal	:= cChaveCan
			lOk				:= oWS:NFEEXPORTAEVENTO()
			oRetEvCanc 		:= oWS:oWSNFEEXPORTAEVENTORESULT
			
			If lOk					 
				oXmlExp := XmlParser(oRetEvCanc:CSTRING[1],"_","","")
				cXML := AllTrim("<procEventoCTe>")
				cXML += XmlSaveStr(oXmlExp:_PROCEVENTONFE:_EVENTO:_EVENTOCTE,.F.)
				cXML += XmlSaveStr(oXmlExp:_PROCEVENTONFE:_RETEVENTO:_RETEVENTOCTE,.F.)
				cXML += AllTrim("</procEventoCTe>")
			EndiF
		
		Endif
		
	Endif
	
	RestArea(aAreaSM0)	 
	
Return cXml

/*/{Protheus.doc} EnviaAverb
@author flavio.martins
@since 11/11/2019
@version 1.0
@return ${return}, ${return_description}
@param cCodSeg, characters, descricao
@param cXml, characters, descricao
@type function
/*/
Static Function EnviaAverb(cCodSeg, cXml)
Local aRetAvb	:= {}
Local aAvbOk 	:= {}
Local aAvbErro 	:= {}
Local oWsdl
Local nX
Local cDataAvb
Local cHrAvb
Local cProtocolo
Local cUsuario	:= ''
Local cSenha	:= ''
Local cCodAtm	:= ''
Local cLink		:= ''

	dbSelectArea("DL6")
	DL6->(dbSetOrder(1))
	
	If DL6->(dbSeek(xFilial('DL6')+cCodSeg))
	
		cUsuario := DL6->DL6_LOGIN
		cSenha	 := DL6->DL6_SENHA
		cCodAtm  := DL6->DL6_CODEMP
		cLink    := DL6->DL6_ENDSOA
	
	Endif
	
	oWsdl := WSATMWebSvr():New()
	oWsdl:cusuario	:= AllTrim(cUsuario)
	oWsdl:csenha	:= AllTrim(cSenha)
	oWsdl:ccodatm 	:= AllTrim(cCodAtm)
	oWsdl:cLinkSoap := AllTrim(cLink)
	oWsdl:cxmlCTe 	:= cXml	
	oWsdl:averbaCTe()	
	
	If !Empty(oWsdl:oWsAverbaCteResponse:oWsAverbado) .OR. !Empty(oWsdl:oWsAverbaCteResponse:oWsErros)			
	
		If !Empty(oWsdl:oWsAverbaCteResponse:oWsAverbado)	
			aadd(aRetAvb,.T.)
			aadd(aRetAvb,{})
			If !Empty(oWsdl:oWsAverbaCteResponse:oWsAverbado:cdhAverbacao)
				cDataAvb := SUBSTR(oWsdl:oWsAverbaCteResponse:oWsAverbado:cdhAverbacao,9,2)
				cDataAvb += '/'+SUBSTR(oWsdl:oWsAverbaCteResponse:oWsAverbado:cdhAverbacao,6,2)
				cDataAvb += '/'+SUBSTR(oWsdl:oWsAverbaCteResponse:oWsAverbado:cdhAverbacao,1,4)					
				cHrAvb 	:= SUBSTR(oWsdl:oWsAverbaCteResponse:oWsAverbado:cdhAverbacao,12,2)
				cHrAvb 	+= ':'+SUBSTR(oWsdl:oWsAverbaCteResponse:oWsAverbado:cdhAverbacao,15,2) 
			EndIf
			cProtocolo := oWsdl:oWsAverbaCteResponse:oWsAverbado:cProtocolo
			For nX := 1 to Len(oWsdl:oWsAverbaCteResponse:oWsAverbado:oWSDadosSeguro)
			
				aAdd(aRetAvb[2],{"GIJ_DATAVB",CtoD(cDataAvb)})
				aAdd(aRetAvb[2],{"GIJ_HORAVB",StrTran(cHrAvb,':','') })
				aadd(aRetAvb[2],{"GIJ_PROTOC",cProtocolo})
				aadd(aRetAvb[2],{"GIJ_NUMAVB",oWsdl:oWsAverbaCteResponse:oWsAverbado:oWSDadosSeguro[nX]:cNumeroAverbacao})
				aadd(aRetAvb[2],{"GIJ_CNPJSE",oWsdl:oWsAverbaCteResponse:oWsAverbado:oWSDadosSeguro[nX]:cCNPJSeguradora})
				aadd(aRetAvb[2],{"GIJ_NOMESE",oWsdl:oWsAverbaCteResponse:oWsAverbado:oWSDadosSeguro[nX]:cNomeSeguradora})
				aadd(aRetAvb[2],{"GIJ_NUMAPO",oWsdl:oWsAverbaCteResponse:oWsAverbado:oWSDadosSeguro[nX]:cNumApolice})
				aadd(aRetAvb[2],{"GIJ_TPMOV",oWsdl:oWsAverbaCteResponse:oWsAverbado:oWSDadosSeguro[nX]:cTpMov})
				aadd(aRetAvb[2],{"GIJ_TPDDR",oWsdl:oWsAverbaCteResponse:oWsAverbado:oWSDadosSeguro[nX]:cTpDDR})
				aadd(aRetAvb[2],{"GIJ_VALAVB",oWsdl:oWsAverbaCteResponse:oWsAverbado:oWSDadosSeguro[nX]:cValorAverbado})
				aadd(aRetAvb[2],{"GIJ_RAMO",oWsdl:oWsAverbaCteResponse:oWsAverbado:oWSDadosSeguro[nX]:cRamoAverbado})
			
			Next nX
		
		EndIf
			
		If !Empty(oWsdl:oWsAverbaCteResponse:oWsErros)
			aadd(aRetAvb,.F.)
			
			For nX := 1 to Len(oWsdl:oWsAverbaCteResponse:oWsErros:oWsErro)
				aadd(aRetAvb, {oWsdl:oWsAverbaCteResponse:oWsErros:oWsErro[nX]:CCODIGO, oWsdl:oWsAverbaCteResponse:oWsErros:oWsErro[nX]:CDESCRICAO})		
			Next nX
		EndIf
			
	Else
		aadd(aRetAvb,.F.)
		aadd(aRetAvb, {"999","Integracao AT&M - Erro ao acessar WebService"})
	EndIf
	
Return aRetAvb
