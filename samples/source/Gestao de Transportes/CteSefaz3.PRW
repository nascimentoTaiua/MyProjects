#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TBICONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³XmlCte3 ³ Autor ³ Felipe Barbieri         ³ Data ³19.01.2017³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rdmake de exemplo para geracao da Conhecimento de Transporte³±±
±±³          ³CTE SEFAZ - Versao T03.00                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³String da Nota Fiscal Eletronica                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Tipo da NF                                           ³±±
±±³          ³       [0] Entrada                                          ³±±
±±³          ³       [1] Saida                                            ³±±
±±³          ³ExpC2: Serie da NF                                          ³±±
±±³          ³ExpC3: Numero da nota fiscal                                ³±±
±±³          ³ExpC4: Codigo do cliente ou fornecedor                      ³±±
±±³          ³ExpC5: Loja do cliente ou fornecedor                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function XmlCte3(cTipo,cSerie,cNota,cClieFor,cLoja)

Local cString     := ""
Local cString20   := ""
Local cStringCh   := ""
Local cStringTmp  := ""  
Local cStringExp  := ""
Local cStringOut  := ""
Local cNFe        := ""
Local cCFOP       := ""

Local aCarga      := {0,0,0,0,""}
Local cGerDup     := 'S'
Local cViagem     := ''
Local cFilVia     := '' 

//-- Inicio das variaveis para CTe //
Local cAliasDT6   := ''
Local cAliasRBC   := ''
Local cAliasCD2   := ''
Local cAliasAll   := ''
Local cAliasDTC   := ''
Local cAliasTagE  := ''
Local cAliasTagJ  := ''
Local cAliasChv   := ''
Local cAliasVPrest:= ''
Local cAliasCTG   := ''
Local cAliasTES   := ''
Local cQuery      := ''
Local nSerieCTe   := 0
Local cAmbiente   := PARAMIXB[2]
Local cVerAmb     := PARAMIXB[3]
Local cModalidade := PARAMIXB[4]
Local cTimeZone   := PARAMIXB[5]
Local aMotivoCont := PARAMIXB[1,7] //-- Obtem as informacoes de contigencia
Local aXMLCTe     := {}
Local cCT         := ''
Local cChvAcesso  := ''
Local nCount      := 0
Local cProdPred   := ''
Local cCodPred    := ''
Local cCodUF      := ''
Local cCodUFRem   := ''
Local cCodUFDes   := ''
Local cCodUFRec   := '' //--Codigo IBGE da UF do Recebedor
Local cCodUFExp   := '' //--Codigo IBGE da UF do Expedidor
Local cCodUFCon   := ''
Local cCodUFDpc   := ''
Local cCodUFDUL   := ''
Local lTMSCTe     := SuperGetMv( "MV_TMSCTE" , .F., .F. )
Local cTmsAntt    := SuperGetMv( "MV_TMSANTT", .F., .F. )
Local cpRedBC     := ''
Local cInsRemOpc  := ''
Local cInsDesOpc  := ''
Local lSelOcor    := .F.
Local cSeqEntr    := ''
Local cObs        := ''
Local cDTCObs     := ''
Local cCtrDpc     := ''
Local cSerDpc     := ''
Local cTpDocAnt   := ''
Local cDtEmi      := ''
Local cCTEDocAnt  := ''
Local cTipoNF     := '2'
Local cDevFre	  := ''
Local lCTEVFRE    := SuperGetMv("MV_CTEVFRE",.F.,.F.)
Local lCTEVPRE    := SuperGetMv("MV_CTEVPRE",.F.,.F.)
Local cSelOri     := '2'
Local cCodUFOri   := ''
Local lDocApoio   := .F.
Local cAliasDT5   := ''
Local cFilOri     := ''
Local cNumSol     := ''
Local cTpEmis     := ''
Local cDtCont     := ''
Local cChvCTG     := ''
Local cFilDco 	:= ''
Local cDocDco 	:= ''
Local cSerDco 	:= ''
Local lContrib    := .F.
Local lRedesp     := .F. 
Local nVcred      := 0
Local nBASEICM    := 0
Local nBASICMRET  := 0
Local nCREDPRES   := 0
Local nALIQICM    := 0
Local nVALICM     := 0
Local nALIQSOL    := 0
Local nICMSRET    := 0
Local cCliExp     := ""
Local cLojExp 	  := ""
Local cCliRec	  := ""
Local cLojRec	  := ""
Local cInsAuxOpc  := ""
Local lEPEC		  := .F.

Local nBCICMS 	:= 0
Local nPERFCP 	:= 0
Local nALQTER 	:= 0
Local nALQINT 	:= 0
Local nPEDDES 	:= 0
Local nVALFCP 	:= 0
Local nVALDES 	:= 0
Local nVLTRIB 	:= 0	

Local cCTeUnico	:= ''
Local cUniRem		:= ''	
Local cUniDes		:= ''     

Local aArea

Local lUsaColab		:= UsaColaboracao("2")
Local aNFEID		:= {}

Local cMVSINAC 		:= SuperGetMv("MV_CODREG")
Local cCNPJAntt		:= SuperGetMv( "MV_CNPJANT", .F., .F. )
Local aAreaSM0		:= SM0->(GetArea())
Local lAlteraToma	:= .F. 
Local cTmsCOTM    	:= SuperGetMv( "MV_TMSCOTM", .F., .F. )
Local cSubTrib		:= ""
Local cUFST			:= ""
Local lMOC300A      := .T.
Local aRetXML   	:= {}
Local lTMSCTESEF    := ExistBlock("TMSCTESEF",,.T.)
Local cMVURLQCOD	:= SUPERGETMV("MV_URLQCOD", .T., "")
Local aCFOP 		:= {}
Local aAreaSA1		:= {}
Local cCGCRdp		:= ''
Local lAnuSubs      := .T.
Local nEmiDocAnt	:= 0
Local nIdDocAnt		:= 0
Local nFDocAnt		:= 0
Local nFEmDcAnt		:= 0
Local cUFDESGLOB	:= ''
Local lDifal        := .T.

Private aUF       	:= {}

Default cTipo     := PARAMIXB[1,1]
Default cSerie    := PARAMIXB[1,3]
Default cNota     := PARAMIXB[1,4]
Default cClieFor  := PARAMIXB[1,5]
Default cLoja     := PARAMIXB[1,6]

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

If cTipo == "1" //-- Saida
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posiciona NF                                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SF2")
	dbSetOrder(1)
	If MsSeek(xFilial("SF2")+cNota+cSerie+cClieFor+cLoja)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Tratamento temporario do CTe                                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (lTMSCTe) .Or. (AModNot(SF2->F2_ESPECIE)=="57") .Or. (FunName()$"TMSA200" .Or. FunName()$"TMSA500")
			cAliasDT6 := "DT6_TMP"

			If (Select(cAliasDT6) > 0)
				(cAliasDT6)->(DbCloseArea())
			EndIf

			cQuery := " SELECT CTRC.DT6_FILDOC, " + CRLF
			cQuery += "        CTRC.DT6_FILORI, " + CRLF
			cQuery += "        CTRC.DT6_SERIE,  " + CRLF
			cQuery += "        CTRC.DT6_DOC,    " + CRLF
			cQuery += "        CTRC.DT6_DATEMI, " + CRLF
			cQuery += "        CTRC.DT6_HOREMI, " + CRLF
			cQuery += "        CTRC.DT6_DOCTMS, " + CRLF
			cQuery += "        CTRC.DT6_TIPTRA, " + CRLF
			cQuery += "        CTRC.DT6_FILIAL, " + CRLF
			cQuery += "        CTRC.DT6_FILDOC, " + CRLF
			cQuery += "        CTRC.DT6_CLIDEV, " + CRLF
			cQuery += "        CTRC.DT6_LOJDEV, " + CRLF
			cQuery += "        CTRC.DT6_CLIREM, " + CRLF
			cQuery += "        CTRC.DT6_LOJREM, " + CRLF
			cQuery += "        CTRC.DT6_CLIDES, " + CRLF
			cQuery += "        CTRC.DT6_LOJDES, " + CRLF
			cQuery += "        CTRC.DT6_CLICON, " + CRLF
			cQuery += "        CTRC.DT6_LOJCON, " + CRLF
			cQuery += "        CTRC.DT6_CLIDPC, " + CRLF
			cQuery += "        CTRC.DT6_LOJDPC, " + CRLF
			cQuery += "        CTRC.DT6_VALFRE, " + CRLF
			cQuery += "        CTRC.DT6_VALTOT, " + CRLF
			cQuery += "        CTRC.DT6_VALIMP, " + CRLF
			cQuery += "        CTRC.DT6_PRZENT, " + CRLF
			cQuery += "        CTRC.DT6_VOLORI, " + CRLF
			cQuery += "        CTRC.DT6_SERVIC, " + CRLF
			cQuery += "        CTRC.DT6_LOTNFC, " + CRLF
			cQuery += "        CTRC.DT6_VALMER, " + CRLF
			cQuery += "        CTRC.DT6_FILDCO, " + CRLF
			cQuery += "        CTRC.DT6_DOCDCO, " + CRLF
			cQuery += "        CTRC.DT6_SERDCO, " + CRLF
			cQuery += "        CTRC.DT6_CODMSG, " + CRLF
			cQuery += "        CTRC.DT6_CDRORI, " + CRLF
			cQuery += "        CTRC.DT6_CDRDES, " + CRLF
			cQuery += "        CTRC.DT6_PREFIX, " + CRLF
			cQuery += "        CTRC.DT6_NUM,    " + CRLF
			cQuery += "        CTRC.DT6_TIPO,   " + CRLF
			cQuery += "        CTRC.DT6_CODOBS, " + CRLF
			cQuery += "        CTRC.DT6_CHVCTE, " + CRLF
			cQuery += "        CTRC.DT6_SITCTE, " + CRLF
			cQuery += "        CTRC.DT6_DEVFRE, " + CRLF
			cQuery += "        CTRC.DT6_PESCOB, " + CRLF
			cQuery += "        CTRC.DT6_CLIEXP, " + CRLF
			cQuery += "        CTRC.DT6_LOJEXP, " + CRLF
			cQuery += "		   CTRC.DT6_CLIREC, " + CRLF
			cQuery += "		   CTRC.DT6_LOJREC, " + CRLF
			cQuery += "        CTRC.DT6_SQEDES, " + CRLF
			cQuery += "        CTRC.DT6_RETIRA, " + CRLF
			
			//-- Remetente
			cQuery += "        CLIREM.A1_CGC REM_CNPJ,			" + CRLF
			cQuery += "        CLIREM.A1_INSCR REM_INSC,		" + CRLF
			cQuery += "        CLIREM.A1_CONTRIB REM_CONTRIB,	" + CRLF
			cQuery += "        CLIREM.A1_NOME REM_NOME,			" + CRLF
			cQuery += "        CLIREM.A1_NREDUZ REM_NMEFANT,	" + CRLF
			cQuery += "        CLIREM.A1_DDD REM_DDDTEL,		" + CRLF
			cQuery += "        CLIREM.A1_TEL REM_TEL,			" + CRLF
			cQuery += "        CLIREM.A1_END REM_END,			" + CRLF
			cQuery += "        CLIREM.A1_COMPLEM REM_CPL,		" + CRLF
			cQuery += "        CLIREM.A1_BAIRRO REM_BAIRRO,		" + CRLF
			cQuery += "        CLIREM.A1_MUN REM_MUNICI,		" + CRLF
			cQuery += "        CLIREM.A1_CEP REM_CEP,			" + CRLF
			cQuery += "        CLIREM.A1_EST REM_UF,			" + CRLF
			cQuery += "        CLIREM.A1_PAIS REM_PAIS,			" + CRLF
			cQuery += "        CLIREM.A1_CODPAIS REM_CBACEN,	" + CRLF
			cQuery += "        CLIREM.A1_PESSOA REM_TPPESSOA,	" + CRLF
			cQuery += "        CLIREM.A1_SUFRAMA REM_SUFRAMA,	" + CRLF
			cQuery += "        CLIREM.A1_COD_MUN REM_COD_MUN,	" + CRLF
			cQuery += "        CLIREM.A1_EMAIL   REM_EMAIL,		" + CRLF

			//-- Expedidor
			cQuery += "        CLIEXP.A1_CGC EXP_CNPJ,			" + CRLF
			cQuery += "        CLIEXP.A1_INSCR EXP_INSC,		" + CRLF
			cQuery += "        CLIEXP.A1_CONTRIB EXP_CONTRIB,	" + CRLF
			cQuery += "        CLIEXP.A1_NOME EXP_NOME,			" + CRLF
			cQuery += "        CLIEXP.A1_NREDUZ EXP_NMEFANT,	" + CRLF
			cQuery += "        CLIEXP.A1_DDD EXP_DDDTEL,		" + CRLF
			cQuery += "        CLIEXP.A1_TEL EXP_TEL,			" + CRLF
			cQuery += "        CLIEXP.A1_END EXP_END,			" + CRLF
			cQuery += "        CLIEXP.A1_COMPLEM EXP_CPL,		" + CRLF
			cQuery += "        CLIEXP.A1_BAIRRO EXP_BAIRRO,		" + CRLF
			cQuery += "        CLIEXP.A1_MUN EXP_MUNICI,		" + CRLF
			cQuery += "        CLIEXP.A1_CEP EXP_CEP,			" + CRLF
			cQuery += "        CLIEXP.A1_EST EXP_UF,			" + CRLF
			cQuery += "        CLIEXP.A1_PAIS EXP_PAIS,			" + CRLF
			cQuery += "        CLIEXP.A1_CODPAIS EXP_CBACEN,	" + CRLF
			cQuery += "        CLIEXP.A1_PESSOA EXP_TPPESSOA,	" + CRLF
			cQuery += "        CLIEXP.A1_SUFRAMA EXP_SUFRAMA,	" + CRLF
			cQuery += "        CLIEXP.A1_COD_MUN EXP_COD_MUN,	" + CRLF
			cQuery += "        CLIEXP.A1_EMAIL   EXP_EMAIL,		" + CRLF

			//-- Destinatario
			cQuery += "        CLIDES.A1_CGC DES_CNPJ,			" + CRLF
			cQuery += "        CLIDES.A1_INSCR DES_INSC,		" + CRLF
			cQuery += "        CLIDES.A1_CONTRIB DES_CONTRIB,	" + CRLF
			cQuery += "        CLIDES.A1_NOME DES_NOME,			" + CRLF
			cQuery += "        CLIDES.A1_DDD DES_DDDTEL,		" + CRLF
			cQuery += "        CLIDES.A1_TEL DES_TEL,			" + CRLF
			cQuery += "        CLIDES.A1_PESSOA DES_TPPESSOA, 	" + CRLF
			cQuery += "        CLIDES.A1_SUFRAMA	DES_SUFRAMA," + CRLF
			cQuery += "        CLIDES.A1_END DES_END,			" + CRLF
			cQuery += "        CLIDES.A1_COMPLEM DES_CPL,		" + CRLF
			cQuery += "        CLIDES.A1_BAIRRO DES_BAIRRO,		" + CRLF
			cQuery += "        CLIDES.A1_MUN DES_MUNICI,		" + CRLF
			cQuery += "        CLIDES.A1_CEP DES_CEP,			" + CRLF
			cQuery += "        CLIDES.A1_EST DES_UF,			" + CRLF
			cQuery += "        CLIDES.A1_PAIS DES_PAIS,			" + CRLF
			cQuery += "        CLIDES.A1_CODPAIS DES_CBACEN,	" + CRLF			
			cQuery += "        CLIDES.A1_COD_MUN DES_COD_MUN,	" + CRLF
			cQuery += "        CLIDES.A1_EMAIL   DES_EMAIL,		" + CRLF

			//-- Recebedor
			cQuery += "        CLIREC.A1_CGC REC_CNPJ,			" + CRLF
			cQuery += "        CLIREC.A1_INSCR REC_INSC,		" + CRLF
			cQuery += "        CLIREC.A1_CONTRIB REC_CONTRIB,	" + CRLF
			cQuery += "        CLIREC.A1_NOME REC_NOME,			" + CRLF
			cQuery += "        CLIREC.A1_NREDUZ REC_NMEFANT,	" + CRLF
			cQuery += "        CLIREC.A1_DDD REC_DDDTEL,		" + CRLF
			cQuery += "        CLIREC.A1_TEL REC_TEL,			" + CRLF
			cQuery += "        CLIREC.A1_END REC_END,			" + CRLF
			cQuery += "        CLIREC.A1_COMPLEM REC_CPL,		" + CRLF
			cQuery += "        CLIREC.A1_BAIRRO REC_BAIRRO,		" + CRLF
			cQuery += "        CLIREC.A1_MUN REC_MUNICI,		" + CRLF
			cQuery += "        CLIREC.A1_CEP REC_CEP,			" + CRLF
			cQuery += "        CLIREC.A1_EST REC_UF,			" + CRLF
			cQuery += "        CLIREC.A1_PAIS REC_PAIS,			" + CRLF
			cQuery += "        CLIREC.A1_CODPAIS REC_CBACEN,	" + CRLF
			cQuery += "        CLIREC.A1_PESSOA REC_TPPESSOA,	" + CRLF
			cQuery += "        CLIREC.A1_SUFRAMA REC_SUFRAMA,	" + CRLF
			cQuery += "        CLIREC.A1_COD_MUN REC_COD_MUN,	" + CRLF
			cQuery += "        CLIREC.A1_EMAIL   REC_EMAIL,		" + CRLF

			//-- Consignatario			
			cQuery += "        CLICON.A1_CGC CON_CNPJ,			" + CRLF
			cQuery += "        CLICON.A1_INSCR CON_INSC,		" + CRLF
			cQuery += "        CLICON.A1_CONTRIB CON_CONTRIB,	" + CRLF
			cQuery += "        CLICON.A1_NOME CON_NOME,			" + CRLF
			cQuery += "        CLICON.A1_DDD CON_DDDTEL,		" + CRLF
			cQuery += "        CLICON.A1_TEL CON_TEL,			" + CRLF
			cQuery += "        CLICON.A1_PESSOA CON_TPPESSOA,	" + CRLF
			cQuery += "        CLICON.A1_SUFRAMA	CON_SUFRAMA," + CRLF
			cQuery += "        CLICON.A1_END CON_END,			" + CRLF
			cQuery += "        CLICON.A1_COMPLEM CON_CPL,		" + CRLF
			cQuery += "        CLICON.A1_BAIRRO CON_BAIRRO,		" + CRLF
			cQuery += "        CLICON.A1_MUN CON_MUNICI,		" + CRLF
			cQuery += "        CLICON.A1_CEP CON_CEP,			" + CRLF
			cQuery += "        CLICON.A1_EST CON_UF,			" + CRLF
			cQuery += "        CLICON.A1_PAIS CON_PAIS, 		" + CRLF
			cQuery += "        CLICON.A1_COD_MUN CON_COD_MUN,	" + CRLF
			cQuery += "        CLICON.A1_EMAIL   CON_EMAIL,		" + CRLF
			//-- Despachante
			cQuery += "        CLIDPC.A1_CGC DPC_CNPJ,			" + CRLF
			cQuery += "        CLIDPC.A1_INSCR DPC_INSC,		" + CRLF
			cQuery += "        CLIDPC.A1_CONTRIB DPC_CONTRIB,	" + CRLF
			cQuery += "        CLIDPC.A1_NOME DPC_NOME,			" + CRLF
			cQuery += "        CLIDPC.A1_DDD DPC_DDDTEL,		" + CRLF
			cQuery += "        CLIDPC.A1_TEL DPC_TEL,			" + CRLF
			cQuery += "        CLIDPC.A1_PESSOA DPC_TPPESSOA,	" + CRLF
			cQuery += "        CLIDPC.A1_SUFRAMA DPC_SUFRAMA,	" + CRLF
			cQuery += "        CLIDPC.A1_END DPC_END,			" + CRLF
			cQuery += "        CLIDPC.A1_COMPLEM DPC_CPL,		" + CRLF
			cQuery += "        CLIDPC.A1_BAIRRO DPC_BAIRRO,		" + CRLF
			cQuery += "        CLIDPC.A1_MUN DPC_MUNICI,		" + CRLF
			cQuery += "        CLIDPC.A1_CEP DPC_CEP,			" + CRLF
			cQuery += "        CLIDPC.A1_EST DPC_UF,			" + CRLF
			cQuery += "        CLIDPC.A1_PAIS DPC_PAIS,			" + CRLF
			cQuery += "        CLIDPC.A1_COD_MUN DPC_COD_MUN,	" + CRLF
			cQuery += "        CLIDPC.A1_EMAIL   DPC_EMAIL		" + CRLF

			cQuery += "   FROM " + RetSqlName('DT6') + " CTRC " + CRLF
			cQuery += "   INNER JOIN " + RetSqlName('SA1') + " CLIREM  ON (CLIREM.A1_COD = CTRC.DT6_CLIREM AND CLIREM.A1_LOJA = CTRC.DT6_LOJREM ) " + CRLF
			cQuery += " LEFT JOIN " + RetSqlName('SA1') + " CLIEXP  ON (CLIEXP.A1_FILIAL = '" + xFilial('SA1') + "' AND CLIEXP.A1_COD = CTRC.DT6_CLIEXP AND CLIEXP.A1_LOJA = CTRC.DT6_LOJEXP AND CLIEXP.D_E_L_E_T_ = ' '  ) " + CRLF
			cQuery += "  INNER JOIN " + RetSqlName('SA1') + " CLIDES  ON (CLIDES.A1_COD = CTRC.DT6_CLIDES AND CLIDES.A1_LOJA = CTRC.DT6_LOJDES   ) " + CRLF
			cQuery += "  LEFT  JOIN " + RetSqlName('SA1') + " CLIREC  ON (CLIREC.A1_FILIAL = '" + xFilial('SA1') + "' AND CLIREC.A1_COD = CTRC.DT6_CLIREC AND CLIREC.A1_LOJA = CTRC.DT6_LOJREC AND CLIREC.D_E_L_E_T_ = ' '  ) " + CRLF

			cQuery += "  LEFT  JOIN " + RetSqlName('SA1') + " CLICON  ON (CLICON.A1_FILIAL = '" + xFilial('SA1') + "' AND CLICON.A1_COD = CTRC.DT6_CLICON AND CLICON.A1_LOJA = CTRC.DT6_LOJCON AND CLICON.D_E_L_E_T_ = ' ' ) " + CRLF
			cQuery += "  LEFT  JOIN " + RetSqlName('SA1') + " CLIDPC  ON (CLIDPC.A1_FILIAL = '" + xFilial('SA1') + "' AND CLIDPC.A1_COD = CTRC.DT6_CLIDPC AND CLIDPC.A1_LOJA = CTRC.DT6_LOJDPC AND CLIDPC.D_E_L_E_T_ = ' ' ) " + CRLF

			cQuery += "  WHERE CTRC.DT6_FILIAL   = '" + xFilial('DT6') + "'" + CRLF
			cQuery += "    AND CTRC.DT6_FILDOC   = '" + cFilAnt + "'" + CRLF
			cQuery += "    AND CTRC.DT6_DOC      = '" + cNota + "'" + CRLF
			cQuery += "    AND CTRC.DT6_SERIE    = '" + cSerie + "'" + CRLF
			cQuery += "    AND CTRC.D_E_L_E_T_   = ' '" + CRLF
			
			cQuery += "    AND CLIREM.A1_FILIAL  = '" + xFilial('SA1') + "'" + CRLF
			cQuery += "    AND CLIREM.D_E_L_E_T_ = ' '" + CRLF
			
			cQuery += "    AND CLIDES.A1_FILIAL  = '" + xFilial('SA1') + "'" + CRLF
			cQuery += "    AND CLIDES.D_E_L_E_T_ = ' '"
			
			cQuery += "  ORDER BY CTRC.DT6_FILDOC, " + CRLF
			cQuery += "           CTRC.DT6_DOC,    " + CRLF
			cQuery += "           CTRC.DT6_SERIE   "
			
			cQuery := ChangeQuery(cQuery)
			DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasDT6, .F., .T.)
			(cAliasDT6)->(DbGoTop())
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se o lote foi criado para CT-e Único                    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cCTeUnico  := Posicione('DTP',2,xFilial('DTP')+(cAliasDT6)->DT6_FILORI+(cAliasDT6)->DT6_LOTNFC,'DTP_TIPLOT')

			If cCTeUnico == '4'
				If ((cAliasDT6)->DT6_CLIDEV == (cAliasDT6)->DT6_CLIREM) .And. ((cAliasDT6)->DT6_LOJDEV == (cAliasDT6)->DT6_LOJREM)								
                	cUniDes := "DIVERSOS"
				EndIf
				
				If ((cAliasDT6)->DT6_CLIDEV == (cAliasDT6)->DT6_CLIDES) .And. ((cAliasDT6)->DT6_LOJDEV == (cAliasDT6)->DT6_LOJDES)								
                	cUniRem := "DIVERSOS"
				EndIf

			EndIf
			
			If (!(cAliasDT6)->(Eof())) // (01)
				cString := ''
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Header do Arquivo XML                                           ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cString += '<infNFe versao="T02.00" modelo="57">'
				cString += '<CTe xmlns="http://www.portalfiscal.inf.br/cte">'
				aAdd(aXMLCTe,AllTrim(cString))
				
				aAreaSM0 := SM0->(GetArea())
				
				While !(cAliasDT6)->(Eof()) // (02)
					
					If aScan(aUF,{|x| x[1] ==  AllTrim(SM0->M0_ESTENT) }) != 0 // Confere se Uf do Emitente esta OK
						cCodUF := aUF[ aScan(aUF,{|x| x[1] == AllTrim(SM0->M0_ESTENT) }), 2]						
					Else
						cCodUF := ''
					EndIf
					lMOC300A := !(cCodUF == '41' .And. dDataBase < CToD('05/09/2019'))
					
					If aScan(aUF,{|x| x[1] == (cAliasDT6)->REM_UF }) != 0   //Confere se Uf do Remetente esta OK
						cCodUFRem  := aUF[ aScan(aUF,{|x| x[1] == (cAliasDT6)->REM_UF }), 2]						
					Else
						cCodUFRem  := ''
					EndIf
					
					If aScan(aUF,{|x| x[1] == (cAliasDT6)->DES_UF }) != 0   //Confere se Uf do Destinatario esta OK
						cCodUFDes  := aUF[ aScan(aUF,{|x| x[1] == (cAliasDT6)->DES_UF }), 2]
					Else
						cCodUFDes := ''
					EndIf

					If aScan(aUF, {|x| x[1] == (cAliasDT6)->REC_UF }) != 0 //Confere se UF do Recebedor esta Ok
						cCodUFRec  := aUF[ aScan(aUF, {|x| x[1] == (cAliasDT6)->REC_UF }), 2]
					Else
						cCodUFRec  := ''
					EndIf
					
					If aScan(aUF, {|x| x[1] == (cAliasDT6)->EXP_UF }) != 0 //Confere se UF do Expedidor esta Ok
						cCodUFExp  := aUF[ aScan(aUF, {|x| x[1] == (cAliasDT6)->EXP_UF }), 2]
					Else
						cCodUFExp  := ''
					EndIf
					
					cMail := SubStr(Posicione('SA1',1,xFilial('SA1')+(cAliasDT6)->(DT6_CLIDEV+DT6_LOJDEV),'A1_EMAIL'),1, 60 )
					
					cUFST := Posicione('SA1',1,xFilial('SA1')+(cAliasDT6)->(DT6_CLIDEV+DT6_LOJDEV),'A1_EST')
					
					dbSelectArea("SFT")
					SFT->(DbSetOrder(1))
					If SFT->(Dbseek(xFilial("SFT")+"S"+(cAliasDT6)->(DT6_SERIE+DT6_DOC+DT6_CLIDEV+DT6_LOJDEV)))
						cCFOP := SFT->FT_CFOP
					EndIf
					
					If !Empty((cAliasDT6)->CON_UF) // Confere se Uf do Consignatario esta OK
						If (aScan(aUF,{|x| x[1] == (cAliasDT6)->CON_UF }) != 0)
							cCodUFCon  := aUF[ aScan(aUF,{|x| x[1] == (cAliasDT6)->CON_UF }), 2]
						Else
							cCodUFCon := ''
						EndIF
					EndIf
					
					If !Empty((cAliasDT6)->DPC_UF)
						If (aScan(aUF,{|x| x[1] == (cAliasDT6)->DPC_UF }) != 0) //Confere se Uf do Despachante esta OK
							cCodUFDpc  := aUF[ aScan(aUF,{|x| x[1] == (cAliasDT6)->DPC_UF }), 2]
						Else
							cCodUFDpc  := ''
						EndIf
					EndIf
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Gerar Chave de Acesso do CT-e                                   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					nSerieCTe := Val( AllTrim((cAliasDT6)->DT6_SERIE))
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Formato de Impressao do CT-e                                    ³
					//³ 1 - Normal    
					//³ 4 - EPEC  	                                                    ³
					//³ 5 - Contingencia versao 1.04 - 7-Contingência FS-DA             ³
					//³ 7 - Contingencia versao 1.04 - SVC-RS                           ³
					//³ 8 - Contingencia versao 1.04 - SVC-SP                           ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If lUsaColab
						cTpEmis := cModalidade
					Else
						If (cModalidade == '1')
							cTpEmis := '1'
						ElseIf cModalidade == '5'
							cTpEmis := '4'
						ElseIf cModalidade == '7'
							cTpEmis := '5'
						ElseIf cModalidade == '8'
							cTpEmis := '8'
						ElseIf cModalidade == '9'
							cTpEmis := '7'
						EndIf
					EndIf
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Voltar rotina abaixo                                            ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If Empty((cAliasDT6)->DT6_CHVCTE)  
						cCT := Inverte()
						cChvAcesso := CTeCHVAC( cCodUF,;
												( SubStr(AllTrim((cAliasDT6)->DT6_DATEMI), 3, 2) + SubStr(AllTrim((cAliasDT6)->DT6_DATEMI), 5, 2) ),;
												AllTrim(SM0->M0_CGC),;
												'57',;
												StrZero(nSerieCTe, 3),;
												StrZero(Val(PadR((cAliasDT6)->DT6_DOC,9)), 9),;
												cTpEmis + cCT)
					Else
						If Substr(AllTrim((cAliasDT6)->DT6_CHVCTE), 35, 1) $ '4' .And. cTpEmis == '1'
							cCT := Substr(AllTrim((cAliasDT6)->DT6_CHVCTE), 36, 8)
							cChvAcesso := CTeCHVAC( cCodUF,;
												( SubStr(AllTrim((cAliasDT6)->DT6_DATEMI), 3, 2) + SubStr(AllTrim((cAliasDT6)->DT6_DATEMI), 5, 2) ),;
												AllTrim(SM0->M0_CGC),;
												'57',;
												StrZero(nSerieCTe, 3),;
												StrZero(Val(PadR((cAliasDT6)->DT6_DOC,9)), 9),;
												cTpEmis + cCT)
							lEPEC := .T.
						Else
							cChvAcesso := AllTrim((cAliasDT6)->DT6_CHVCTE)		
							cCT := Substr(AllTrim((cAliasDT6)->DT6_CHVCTE), 36, 8)
						EndIf
					EndIf
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ TAG Responsavel em Fechar os Dados do CTe                       ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ					
					If !lUsaColab .And. (Empty((cAliasDT6)->DT6_CHVCTE) .Or. (cModalidade $ '5;7;8;9' .And. (cAliasDT6)->DT6_SITCTE <> '1')) .Or. lEPEC
						cQuery := " UPDATE " + RetSqlName("DT6") + CRLF
						cQuery += "    SET DT6_CHVCTE = '" + cChvAcesso + "' " + CRLF
						cQuery += "  WHERE DT6_FILIAL = '" + xFilial('DT6') + "'" + CRLF
						cQuery += "    AND DT6_FILDOC = '" + (cAliasDT6)->DT6_FILDOC + "' " + CRLF
						cQuery += "    AND DT6_DOC    = '" + (cAliasDT6)->DT6_DOC    + "' " + CRLF
						cQuery += "    AND DT6_SERIE  = '" + (cAliasDT6)->DT6_SERIE  + "' " + CRLF
						cQuery += "    AND D_E_L_E_T_ = ' ' "
						TCSqlExec( cQuery )
					EndIf

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Inicio dos Dados do CTe                                         ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					cNFe    := 'CTe' + AllTrim(cChvAcesso)
					cString := ''
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Versao do Ct-e, de acordo com o parametro                       ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					cString += '<infCte Id="CTe' + AllTrim(cChvAcesso) + '" versao="' + cVerAmb + '">'

					aAdd(aXMLCTe,AllTrim(cString))

					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ TAG: B - IdentIficação do Conhecimento de Transporte Eletronico ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ CFOP - Natureza da Prestacao                                    ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					
					cString := ''
					cString += '<ide>'
					cString += '<cUF>'  + NoAcentoCte( cCodUF )		+ '</cUF>'
					cString += '<cCT>'  + NoAcentoCte( cCT )		+ '</cCT>'
					cString += '<CFOP>' + NoAcentoCte( cCFOP )		+ '</CFOP>'
					aCFOP := FWGetSX5('13',PadR(cCFOP, TamSX3("X5_CHAVE")[1]))
					cString += '<natOp>'+ NoAcentoCte( SubStr(AllTrim(IIf(!Empty(aCFOP), aCFOP[1][4], "")),1,55) )	+ '</natOp>'

					If (cAliasDT6)->DT6_DEVFRE == '1' .And. (cAliasDT6)->REM_CONTRIB == '1'
						lContrib := .T.				
					ElseIf (cAliasDT6)->DT6_DEVFRE == '2' .And. (cAliasDT6)->DES_CONTRIB == '1'
						lContrib := .T.
					ElseIf (cAliasDT6)->DT6_DEVFRE == '3' .And. (cAliasDT6)->CON_CONTRIB == '1'
						lContrib := .T.
					ElseIf (cAliasDT6)->DT6_DEVFRE == '4' .And. (cAliasDT6)->DPC_CONTRIB == '1'
						lContrib := .T.
					ElseIf (cAliasDT6)->DT6_DEVFRE == '6' .And. (cAliasDT6)->EXP_CONTRIB == '1'
						lContrib := .T.
					ElseIf (cAliasDT6)->DT6_DEVFRE == '7' .And. (cAliasDT6)->REC_CONTRIB == '1'
						lContrib := .T.
					EndIf
					
					cCliExp := (cAliasDT6)->( DT6_CLIEXP )
					cLojExp := (cAliasDT6)->( DT6_LOJEXP )
					cCLiRec := (cAliasDT6)->( DT6_CLIREC )
					cLojRec := (cAliasDT6)->( DT6_LOJREC )
					
					cString += '<mod>' 	+ "57" + '</mod>'
					cString += '<serie>'+ NoAcentoCte( cValtoChar( nSerieCTe ) ) + '</serie>'
					cString += '<nCT>'	+ NoAcentoCte( cValtoChar( Val( AllTrim((cAliasDT6)->DT6_DOC) ) ) ) + '</nCT>'

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Data e hora de emissão                                           ³
					//³Formato = AAAA-MM-DDTHH:MM:SS                                    ³
					//³Preenchido com data e hora de emissão.                           ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					cString += '<dhEmi>' + SubStr(AllTrim((cAliasDT6)->DT6_DATEMI), 1, 4) + "-";
					+ SubStr(AllTrim((cAliasDT6)->DT6_DATEMI), 5, 2) + "-";
					+ SubStr(AllTrim((cAliasDT6)->DT6_DATEMI), 7, 2) + "T";
					+ SubStr(AllTrim((cAliasDT6)->DT6_HOREMI), 1, 2) + ":";
					+ SubStr(AllTrim((cAliasDT6)->DT6_HOREMI), 3, 2) + ':00';
					+ cTimeZone + '</dhEmi>'

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Formato de Impressao do DACTE                                   ³
					//³ 1 - Retrato                                                     ³
					//³ 2 - Paisagem                                                    ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					cString += '<tpImp>1</tpImp>'

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Formato de Impressao do CT-e                                    ³
					//³ 1 - Normal                                                      ³
					//³ 4 - EPEC                                                        ³
					//³ 5 - Contingencia versao 1.04                                    ³
					//³ 7 - Contingencia versao 1.04  - SVC-RS                          ³
					//³ 8 - Contingencia versao 1.04  - SVC-SP                          ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If lUsaColab
						cString += '<tpEmis>'+cModalidade+'</tpEmis>'
					Else
						If (cModalidade == '1')
							cString += '<tpEmis>1</tpEmis>'
						ElseIf cModalidade == '5'
							cString += '<tpEmis>4</tpEmis>'
						ElseIf cModalidade == '7'
							cString += '<tpEmis>5</tpEmis>'
						ElseIf cModalidade == '8'
							cString += '<tpEmis>8</tpEmis>'
						ElseIf cModalidade == '9'
							cString += '<tpEmis>7</tpEmis>'
						EndIf
					EndIf
					cString += '<cDV>' + SubStr( AllTrim(cChvAcesso), len( AllTrim(cChvAcesso) ), 1) + '</cDV>'

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Identificacao do Ambiente.                                      ³
					//³ 1 - Producao                                                    ³
					//³ 2 - Homologacao                                                 ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					cString += '<tpAmb>' + cAmbiente + '</tpAmb>'

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Tipo de Conhecimento                                            ³
					//³ 0 - Normal                                                      ³
					//³ 1 - Complemento de Valores                                      ³
					//³ 2 - Emitido em Hipotese de anulacao de Debito                   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If ( AllTrim((cAliasDT6)->DT6_DOCTMS) $ "A/E/2/6/7/9" )
						cString += '<tpCTe>0</tpCTe>'
					ElseIf ( AllTrim((cAliasDT6)->DT6_DOCTMS) $ "8" )
						cString += '<tpCTe>1</tpCTe>'
					ElseIf ( AllTrim((cAliasDT6)->DT6_DOCTMS) = "P" ) 
						cString += '<tpCTe>3</tpCTe>'
					Else
						cString += '<tpCTe>0</tpCTe>'
					EndIf
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Processo de Emissao do CT-e                                     ³
					//³ 0 - emissao com aplicativo do contribuinte                      ³
					//³ 1 - avulsa pelo fisco                                           ³
					//³ 2 - avulsa pelo contrinbuinte com seu certificado digital,      ³
					//³     atraves do site do Fisco                                    ³
					//³ 3 - pelo contribuinte com aplicativo fornecido pelo Fisco       ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					cString += '<procEmi>0</procEmi>'					
											
					If !Empty((cAliasDT6)->DT6_DOCDCO)
						aArea      := GetArea()
						DbSelectArea("DT6")
						DbSetOrder(1)
						If Dbseek(xFilial("DT6")+(cAliasDT6)->DT6_FILDCO+(cAliasDT6)->DT6_DOCDCO+(cAliasDT6)->DT6_SERDCO)
							If !Empty(DT6->DT6_DOCDCO)
								cFilDco := DT6->DT6_FILDCO
								cDocDco := DT6->DT6_DOCDCO
								cSerDco := DT6->DT6_SERDCO
							Else
								cFilDco := (cAliasDT6)->DT6_FILDCO
								cDocDco := (cAliasDT6)->DT6_DOCDCO
								cSerDco := (cAliasDT6)->DT6_SERDCO
							EndIf
						Else
							cFilDco := (cAliasDT6)->DT6_FILDCO
							cDocDco := (cAliasDT6)->DT6_DOCDCO
							cSerDco := (cAliasDT6)->DT6_SERDCO	
						EndIf
						RestArea(aArea)
					Else
						cFilDco := ""
						cDocDco := ""
						cSerDco := ""	
					EndIf
					
					If (DT6->DT6_DOCTMS = "P") .And. !Empty(cDocDco) .And. !Empty(cSerDco) //Para resolver os casos quando há mais de um anulação/substitução.
						aArea := GetArea()

						While lAnuSubs
							DbSelectArea("DT6")
							DbSetOrder(1)
							If Dbseek(xFilial("DT6")+cFilDco+cDocDco+cSerDco)
								If !Empty(DT6->DT6_DOCDCO) .And. !Empty(DT6->DT6_SERDCO) 
									cFilDco := DT6->DT6_FILDCO
									cDocDco := DT6->DT6_DOCDCO
									cSerDco := DT6->DT6_SERDCO	
									lAnuSubs := .T.
								Else
									lAnuSubs := .F.	
								EndIf
							Else
								lAnuSubs := .F.
							EndIf
						EndDo
						RestArea(aArea)
					EndIf
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Tipo de Servico                                                 ³
					//³ 0 - Normal                                                      ³
					//³ 1 - SubContratacao                                              ³
					//³ 2 - Redespacho                                                  ³
					//³ 3 - Redespacho Intermediario                                    ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ DTC - Notas Fiscais: (Informacao do campo DTC_TIPNFC)           ³
					//³ 0 - Normal                                                      ³
					//³ 1 - Devolucao                                                   ³
					//³ 2 - SubContratacao                                              ³
					//³ 3 - Dcto Nao Fiscal                                             ³
					//³ 4 - Exportacao                                                  ³
					//³ 5 - Redespacho                                                  ³
					//³ 6 - Dcto Nao Fiscal 1                                           ³
					//³ 7 - Dcto Nao Fiscal 2                                           ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Seleciona as informacoes do produto, baseado na DTC             ³
					//³ Pega o produto com maior valor de mercadoria, definido como     ³
					//³ o produto predominante                                          ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					cAliasAll := GetNextAlias()
					cQuery := " SELECT MAX(DTC.DTC_VALOR),	" + CRLF
					cQuery += " 		 DTC.DTC_TIPNFC,	" + CRLF
					cQuery += " 		 DTC.DTC_DEVFRE,	" + CRLF
					cQuery += " 		 DTC.DTC_CODOBS,	" + CRLF
					cQuery += " 		 DTC.DTC_CTRDPC,	" + CRLF
					cQuery += " 		 DTC.DTC_SERDPC,	" + CRLF
					cQuery += " 		 DTC.DTC_TIPANT,	" + CRLF
					cQuery += " 		 DTC.DTC_DPCEMI,	" + CRLF
					cQuery += " 		 DTC.DTC_CTEANT,	" + CRLF
					cQuery += " 		 DTC.DTC_SELORI,	" + CRLF
					cQuery += " 		 DTC.DTC_CLIDES,	" + CRLF
					cQuery += " 		 DTC.DTC_LOJDES,	" + CRLF				
					cQuery += " 		 DTC.DTC_SQEDES,	" + CRLF
					cQuery += " 		 DTC.DTC_FILORI,	" + CRLF
					cQuery += " 		 DTC.DTC_NUMSOL,	" + CRLF
					cQuery += " 		 DTC.DTC_CLIEXP,	" + CRLF
					cQuery += " 		 DTC.DTC_LOJEXP,	" + CRLF
					
					cQuery += " 		 DV3REM.DV3_INSCR REMDV3_INSCR ,	" + CRLF
					cQuery += " 		 DV3DES.DV3_INSCR DESDV3_INSCR,		" + CRLF
					cQuery += " 		 SB1.B1_DESC,						" + CRLF
					cQuery += " 		 SB1.B1_COD,						" + CRLF
					cQuery += " 		 SB1.B1_UM							" + CRLF
					cQuery += "   FROM " + RetSqlName("DTC") + " DTC 		" + CRLF

					cQuery += " 		INNER JOIN " + RetSqlName('SB1') + " SB1 "	+ CRLF
					cQuery += "					ON ( SB1.B1_COD = DTC.DTC_CODPRO ) "+ CRLF

					cQuery += " 		 LEFT JOIN " + RetSqlName('DV3') + " DV3REM " + CRLF
					cQuery += "					ON (DV3REM.DV3_FILIAL = '" + xFilial("DV3") + "'"  + CRLF
					cQuery += "					AND DV3REM.DV3_CODCLI = DTC.DTC_CLIREM " + CRLF
					cQuery += "					AND DV3REM.DV3_LOJCLI = DTC.DTC_LOJREM " + CRLF
					cQuery += "					AND DV3REM.DV3_SEQUEN = DTC.DTC_SQIREM " + CRLF
					cQuery += "					AND DV3REM.D_E_L_E_T_ = ' ') "

					cQuery += " 		 LEFT JOIN " + RetSqlName('DV3') + " DV3DES " + CRLF
					cQuery += "					ON (DV3DES.DV3_FILIAL = '" + xFilial("DV3") + "'"  + CRLF
					cQuery += "					AND DV3DES.DV3_CODCLI = DTC.DTC_CLIDES " + CRLF
					cQuery += "					AND DV3DES.DV3_LOJCLI = DTC.DTC_LOJDES " + CRLF
					cQuery += "					AND DV3DES.DV3_SEQUEN = DTC.DTC_SQIdES " + CRLF
					cQuery += "					AND DV3DES.D_E_L_E_T_ = ' ') "

					cQuery += "  WHERE DTC.DTC_FILIAL = '" + xFilial('DTC') + "'" + CRLF

					cQuery += "	 	AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "'" + CRLF
					cQuery += "		AND SB1.D_E_L_E_T_ = ' ' "

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Se o tipo de Conhecimento for de Complemento, seleciona as      ³
					//³ informacoes do CTR principal, pois o complemento nao tem DTC    ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If !Empty(cDocDco)
						cQuery += " AND DTC.DTC_FILDOC   = '" + cFilDco + "'" + CRLF
						cQuery += " AND (DTC.DTC_DOC     = '" + cDocDco + "' OR DTC.DTC_DOCPER = '" + cDocDco + "')" + CRLF
						cQuery += " AND DTC.DTC_SERIE    = '" + cSerDco + "'" + CRLF
					Else
						cQuery += " AND DTC.DTC_FILDOC   = '" + (cAliasDT6)->DT6_FILDOC + "'" + CRLF
						cQuery += " AND (DTC.DTC_DOC     = '" + (cAliasDT6)->DT6_DOC    + "' OR DTC.DTC_DOCPER = '" + (cAliasDT6)->DT6_DOC + "')" + CRLF
						cQuery += " AND DTC.DTC_SERIE    = '" + (cAliasDT6)->DT6_SERIE  + "'" + CRLF
					EndIf
					cQuery += " AND DTC.D_E_L_E_T_   = ' '" + CRLF
					cQuery += " GROUP BY DV3REM.DV3_INSCR, DV3DES.DV3_INSCR, DTC.DTC_TIPNFC, DTC.DTC_DEVFRE, DTC.DTC_CODOBS, DTC.DTC_CTRDPC, DTC.DTC_SERDPC, DTC.DTC_TIPANT, "+ CRLF
					cQuery += "          DTC.DTC_DPCEMI, DTC.DTC_CTEANT, DTC.DTC_SELORI, DTC.DTC_CLIDES, DTC.DTC_LOJDES, DTC.DTC_SQEDES, DTC.DTC_FILORI, DTC.DTC_NUMSOL, "+ CRLF
					cQuery += " 		 DTC.DTC_CLIEXP,	DTC.DTC_LOJEXP, " + CRLF
					cQuery += "          SB1.B1_DESC, SB1.B1_COD , SB1.B1_UM " + CRLF
				
					cQuery += " ORDER BY MAX(DTC.DTC_VALOR) DESC" + CRLF
					cQuery := ChangeQuery(cQuery)
					DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasAll, .F., .T.)
					If ((cAliasAll)->(Eof()))
						//-- Nao localizou documentos... Procura documentos de apoio...
						(cAliasAll)->(DbCloseArea())
						cQuery := " SELECT MAX(DTC.DTC_VALOR),		" + CRLF
						cQuery += " 		 DTC.DTC_TIPNFC,		" + CRLF
						cQuery += " 		 DTC.DTC_DEVFRE,		" + CRLF
						cQuery += " 		 DTC.DTC_CODOBS,		" + CRLF
						cQuery += " 		 DTC.DTC_CTRDPC,		" + CRLF
						cQuery += " 		 DTC.DTC_SERDPC,		" + CRLF
						cQuery += " 		 DTC.DTC_TIPANT,		" + CRLF
						cQuery += " 		 DTC.DTC_DPCEMI,		" + CRLF
						cQuery += " 		 DTC.DTC_CTEANT,		" + CRLF
						cQuery += " 		 DTC.DTC_SELORI,		" + CRLF
						cQuery += " 		 DTC.DTC_CLIDES,		" + CRLF
						cQuery += " 		 DTC.DTC_LOJDES,		" + CRLF
						cQuery += " 		 DTC.DTC_SQEDES,		" + CRLF
						cQuery += " 		 DTC.DTC_FILORI,		" + CRLF
						cQuery += " 		 DTC.DTC_NUMSOL,		" + CRLF
						cQuery += " 		 DTC.DTC_CLIEXP,	" + CRLF
						cQuery += " 		 DTC.DTC_LOJEXP,	" + CRLF
						cQuery += "			 DTC.DTC_CLIREC,	" + CRLF
						cQuery += "			 DTC.DTC_LOJREC,	" + CRLF
						cQuery += "		''	 DTC_CLIREC,	" + CRLF
						cQuery += "		''	 DTC_LOJREC,	" + CRLF
						
						cQuery += " 		 DV3REM.DV3_INSCR REMDV3_INSCR,		" + CRLF
						cQuery += " 		 DV3DES.DV3_INSCR DESDV3_INSCR,		" + CRLF
						cQuery += " 		 SB1.B1_DESC,			" + CRLF
						cQuery += " 		 SB1.B1_COD,			" + CRLF
						cQuery += " 		 SB1.B1_UM				" + CRLF
						cQuery += "   FROM " + RetSqlName("DTC") + " DTC "

						cQuery += " 		INNER JOIN " + RetSqlName('SB1') + " SB1 " 		+ CRLF
						cQuery += "					ON ( SB1.B1_COD = DTC.DTC_CODPRO ) "   + CRLF
						cQuery += "					AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "'" + CRLF
						cQuery += "					AND SB1.D_E_L_E_T_ = ' '"

						cQuery += " 		 LEFT JOIN " + RetSqlName('DV3') + " DV3REM " + CRLF
						cQuery += "					ON (DV3REM.DV3_FILIAL = '" + xFilial("DV3") + "'"  + CRLF
						cQuery += "					AND DV3REM.DV3_CODCLI = DTC.DTC_CLIREM " + CRLF
						cQuery += "					AND DV3REM.DV3_LOJCLI = DTC.DTC_LOJREM " + CRLF
						cQuery += "					AND DV3REM.DV3_SEQUEN = DTC.DTC_SQIREM " + CRLF
						cQuery += "					AND DV3REM.D_E_L_E_T_ = ' ') "

						cQuery += " 		 LEFT JOIN " + RetSqlName('DV3') + " DV3DES " + CRLF
						cQuery += "					ON (DV3DES.DV3_FILIAL = '" + xFilial("DV3") + "'"  + CRLF
						cQuery += "					AND DV3DES.DV3_CODCLI = DTC.DTC_CLIDES " + CRLF
						cQuery += "					AND DV3DES.DV3_LOJCLI = DTC.DTC_LOJDES " + CRLF
						cQuery += "					AND DV3DES.DV3_SEQUEN = DTC.DTC_SQIDES " + CRLF
						cQuery += "					AND DV3DES.D_E_L_E_T_ = ' ') "

						cQuery += " INNER JOIN " + RetSqlName("DT6") + " DT6 " + CRLF
						cQuery += "	  ON DT6.DT6_FILIAL   = '" + xFilial("DT6") + "'"  + CRLF
						cQuery += "  AND DT6.DT6_CLIDEV   = '" + (cAliasDT6)->DT6_CLIDEV + "'" + CRLF
						cQuery += "  AND DT6.DT6_LOJDEV   = '" + (cAliasDT6)->DT6_LOJDEV + "'" + CRLF
						cQuery += "  AND DT6.DT6_PREFIX   = '" + (cAliasDT6)->DT6_PREFIX + "'" + CRLF
						cQuery += "  AND DT6.DT6_NUM      = '" + (cAliasDT6)->DT6_NUM    + "'" + CRLF
						cQuery += "  AND DT6.DT6_TIPO     = '" + (cAliasDT6)->DT6_TIPO   + "'" + CRLF
						cQuery += "  AND DT6.DT6_DOCTMS IN('B','C','H','I','N','O') "
						cQuery += "  AND DT6.D_E_L_E_T_   = ' '" + CRLF

						cQuery += " WHERE DTC.DTC_FILIAL = '" + xFilial('DTC') + "'" + CRLF
						cQuery += "  AND DTC.DTC_FILDOC   = DT6.DT6_FILDOC " + CRLF
						If !Empty(cDocDco)
							cQuery += "  AND (DTC.DTC_DOC     = DT6.DT6_DOC OR DTC.DTC_DOCPER = '" + cDocDco + "')" + CRLF
						Else
							cQuery += "  AND (DTC.DTC_DOC     = DT6.DT6_DOC ) " + CRLF
						EndIf
						cQuery += "  AND DTC.DTC_SERIE    = DT6.DT6_SERIE  " + CRLF
						cQuery += "  AND DTC.D_E_L_E_T_   = ' '" + CRLF

						cQuery += " GROUP BY DV3REM.DV3_INSCR, DV3DES.DV3_INSCR, DTC.DTC_TIPNFC, DTC.DTC_DEVFRE, DTC.DTC_CODOBS, DTC.DTC_CTRDPC, DTC.DTC_SERDPC, DTC.DTC_TIPANT, "+ CRLF
						cQuery += "          DTC.DTC_DPCEMI, DTC.DTC_CTEANT, DTC.DTC_SELORI, DTC.DTC_CLIDES, DTC.DTC_LOJDES, DTC.DTC_SQEDES, DTC.DTC_FILORI, DTC.DTC_NUMSOL, " + CRLF
						cQuery += " 		 DTC.DTC_CLIEXP,	DTC.DTC_LOJEXP, " + CRLF
						cQuery += "			 DTC.DTC_CLIREC, DTC.DTC_LOJREC,	" + CRLF
						cQuery += "          SB1.B1_DESC, SB1.B1_COD , SB1.B1_UM " + CRLF
						
						cQuery += " ORDER BY MAX(DTC.DTC_VALOR) DESC" + CRLF
						cQuery := ChangeQuery(cQuery)
						DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasAll, .F., .T.)
						lDocApoio := !(cAliasAll)->(Eof())
					EndIf

					If !(cAliasAll)->(Eof())
						cCtrDpc    := NoAcentoCte( (cAliasALL)->DTC_CTRDPC )
						cSerDpc    := NoAcentoCte( (cAliasALL)->DTC_SERDPC )
						cTpDocAnt  := NoAcentoCte( (cAliasALL)->DTC_TIPANT )
						cDtEmi     := SubStr(AllTrim((cAliasALL)->DTC_DPCEMI), 1, 4) + "-";
									+ SubStr(AllTrim((cAliasALL)->DTC_DPCEMI), 5, 2) + "-";
									+ SubStr(AllTrim((cAliasALL)->DTC_DPCEMI), 7, 2)
						cCTEDocAnt := NoAcentoCte( (cAliasALL)->DTC_CTEANT)

						cTipoNF    := NoAcentoCte( (cAliasAll)->DTC_TIPNFC ) 
						cDevFre	 := (cAliasAll)->( DTC_DEVFRE )
						cSelOri    := (cAliasAll)->( DTC_SELORI )
						if (AllTrim((cAliasAll)->DTC_CLIDES) + AllTrim((cAliasAll)->DTC_LOJDES)) ==;
						   (AllTrim((cAliasDT6)->DT6_CLIDES) + AllTrim((cAliasDT6)->DT6_LOJDES))
							cSeqEntr   := (cAliasAll)->( DTC_SQEDES )						
						EndIF						
						
						cFilOri    := (cAliasAll)->( DTC_FILORI )
						cNumSol    := (cAliasAll)->( DTC_NUMSOL )

						If !Empty((cAliasAll)->REMDV3_INSCR)
							cInsRemOpc := NoPontos((cAliasALL)->REMDV3_INSCR)
						EndIf
						If !Empty((cAliasAll)->DESDV3_INSCR)
							cInsDesOpc := NoPontos((cAliasALL)->DESDV3_INSCR)
						EndIf
						
						If AllTrim((cAliasDT6)->DT6_DOCTMS) == "6"							
							cInsAuxOpc := cInsDesOpc
							cInsDesOpc := cInsRemOpc
							cInsRemOpc := cInsAuxOpc
						EndIf

						cProdPred := NoAcentoCte( (cAliasAll)->B1_DESC )
						cCodPred  := NoAcentoCte( (cAliasAll)->B1_COD )
						aCarga[5] := NoAcentoCte( (cAliasAll)->B1_UM )

						While (CAliasAll)->(!Eof())
							If ( AllTrim((cAliasDT6)->DT6_DOCTMS) $ "6/7/8/P" .Or. cCTeUnico == '4' )
								If Empty(cDTCObs)
									cDTCObs    := NoAcentoCte( StrTran(MsMM((cAliasDT6)->DT6_CODOBS),Chr(13),"") )
									If cCteUnico =='4'	
										cDTCObs += " / Observacoes: "+ NoAcentoCte( StrTran(MsMM((cAliasALL)->DTC_CODOBS),Chr(13),"") )+ "/"
									EndIf
								Else
									If cCteUnico =='4' //Para Ct-e Unico adiciona conteudo das Dtc's digitadas além da Obs na DT6 					
										cDTCObs += " "+ NoAcentoCte( StrTran(MsMM((cAliasALL)->DTC_CODOBS),Chr(13),"") )+ "/"
									EndIf
								EndIf
							Else
								cDTCObs    := NoAcentoCte( StrTran(MsMM((cAliasALL)->DTC_CODOBS),Chr(13),"") )
							EndIf
						(CAliasAll)->(dbSkip())
						EndDo
					EndIf
					(cAliasAll)->(DbCloseArea())


					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³                                                                 ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					cString += '<verProc>' + cVerAmb + '</verProc>'
					
					If cCTeUnico == '4'
						cString += '<indGlobalizado>1</indGlobalizado>'
					EndIf
					
					cString += '<cMunEnv>' + NoAcentoCte( SM0->M0_CODMUN ) + '</cMunEnv>'
					cString += '<xMunEnv>' + NoAcentoCte( SM0->M0_CIDENT ) + '</xMunEnv>'
					cString += '<UFEnv>'   + NoAcentoCte( SM0->M0_ESTENT ) + '</UFEnv>'
				
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Modal                                                           ³
					//³ 01 - Rodoviario;                                                ³
					//³ 02 - Aereo;                                                     ³
					//³ 03 - Aquaviario;                                                ³
					//³ 04 - Ferroviario;                                               ³
					//³ 05 - Dutoviario.                                                ³
					//³ 06 - Multimodal                                                 ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

					If (cAliasDT6)->DT6_TIPTRA == '6'
						cString += '<modal>06</modal>'
					Else
						cString += '<modal>01</modal>'
					EndIf

					If cTipoNF $ '0,1,3,4,6,7'
						cString   += '<tpServ>0</tpServ>'
					ElseIf cTipoNF == '2'
						cString   += '<tpServ>1</tpServ>'
					ElseIf cTipoNF == '5'
						cString   += '<tpServ>2</tpServ>'
					ElseIf	cTipoNF $ '8/A'
						cString   += '<tpServ>4</tpServ>'					
					ElseIf	cTipoNF == '9'
						cString   += '<tpServ>3</tpServ>'
					EndIf
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Municipio inicio e termino da prestacao                         ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If cSelOri == StrZero(1,Len(DTC->DTC_SELORI)) .Or.  AllTrim((cAliasDT6)->DT6_DOCTMS) $ "6/7"  //Transportadora ou CT-e de Devolução e Reentrega
						DUY->(DbSetOrder(1))
						If DUY->(MsSeek(xFilial("DUY")+(cAliasDT6)->DT6_CDRORI))
							If (aScan(aUF,{|x| x[1] == DUY->DUY_EST }) != 0)
								cCodUFOri := aUF[ aScan(aUF,{|x| x[1] == DUY->DUY_EST }), 2]
							Else
								cCodUFOri := ''
							EndIf
							cString += '<cMunIni>' + NoAcentoCte( AllTrim(cCodUFOri ) +  Alltrim( DUY->DUY_CODMUN ) )  + '</cMunIni>'
							cString += '<xMunIni>' + NoAcentoCte( Posicione('CC2',1,xFilial("CC2")+ DUY->DUY_EST + DUY->DUY_CODMUN,"CC2_MUN") ) + '</xMunIni>'
							cString += '<UFIni>'   + NoAcentoCte( DUY->DUY_EST ) + '</UFIni>'
						EndIf
					ElseIf cSelOri == StrZero(2,Len(DTC->DTC_SELORI))   //Remetente
						
						If cCTeUnico == '4' .AND. !Empty(cUniRem)
							DTC->(DbSetOrder(3))	
							SA1->(DbSetOrder(1))	
							If DTC->(DbSeek(xFilial("DTC")+(cAliasDT6)->(DT6_FILDOC+DT6_DOC+DT6_SERIE)))
								If SA1->(dbSeek(xFilial('SA1') + DTC->DTC_CLIREM + DTC->DTC_LOJREM))
									If (aScan(aUF,{|x| x[1] == SA1->A1_EST }) != 0)
										cUFDESGLOB := aUF[ aScan(aUF,{|x| x[1] == SA1->A1_EST }), 2]
												
										cString += '<cMunIni>'	+ NoAcentoCte( AllTrim(cUFDESGLOB ) + AllTrim(SA1->A1_COD_MUN ) ) + '</cMunIni>'
										cString += '<xMunIni>'	+ NoAcentoCte( Alltrim(SA1->A1_MUN)) + '</xMunIni>'
										cString += '<UFIni>'	+ NoAcentoCte( AllTrim(SA1->A1_EST)) + '</UFIni>'
									EndIF
								EndIf
							EndIf
						Else
							If AllTrim((cAliasDT6)->DT6_DOCTMS) $ "6/7/8"  //Transportadora ou CT-e de Devolução e Reentrega ou complemento de imposto
								DUY->(DbSetOrder(1))
								If DUY->(MsSeek(xFilial("DUY")+(cAliasDT6)->DT6_CDRORI))
									If (aScan(aUF,{|x| x[1] == DUY->DUY_EST }) != 0)
										cCodUFOri := aUF[ aScan(aUF,{|x| x[1] == DUY->DUY_EST }), 2]
									Else
										cCodUFOri := ''
									EndIf
									cString += '<cMunIni>' + NoAcentoCte( AllTrim(cCodUFOri ) +  Alltrim( DUY->DUY_CODMUN ) )  + '</cMunIni>'
									cString += '<xMunIni>' + NoAcentoCte( Posicione('CC2',1,xFilial("CC2")+ DUY->DUY_EST + DUY->DUY_CODMUN,"CC2_MUN") ) + '</xMunIni>'
									cString += '<UFIni>'   + NoAcentoCte( DUY->DUY_EST ) + '</UFIni>'
								EndIf
							Else
								cString += '<cMunIni>' + NoAcentoCte( AllTrim(cCodUFRem ) +  Alltrim((cAliasDT6)->(REM_COD_MUN)) )  + '</cMunIni>'
								cString += '<xMunIni>' + NoAcentoCte( (cAliasDT6)->(REM_MUNICI) ) + '</xMunIni>'
								cString += '<UFIni>'   + NoAcentoCte( (cAliasDT6)->(REM_UF) ) + '</UFIni>'
							EndIf
						EndIf

					ElseIf cSelOri == StrZero(3,Len(DTC->DTC_SELORI))   //Coleta ou expedidor.

						If !Empty((cAliasDT6)->DT6_CLIEXP) //--Origem Expedidor?
							cString += '<cMunIni>' + NoAcentoCte( AllTrim(cCodUFExp ) +  Alltrim((cAliasDT6)->(EXP_COD_MUN)) )  + '</cMunIni>'
							cString += '<xMunIni>' + NoAcentoCte( (cAliasDT6)->(EXP_MUNICI) ) + '</xMunIni>'
							cString += '<UFIni>'   + NoAcentoCte( (cAliasDT6)->(EXP_UF) ) + '</UFIni>'
						Else //-- ou Coleta
							cAliasDT5:= GetNextAlias()
							cQuery := " SELECT DUE_MUN, DUE_CODMUN, DUE_EST, DUL_MUN, DUL_CODMUN, DUL_EST "
							cQuery += "  FROM " + RetSQLName("DT5") + " DT5 "
							cQuery += "  JOIN " + RetSQLName("DUE") + " DUE "
							cQuery += "    ON DUE_FILIAL = '" + xFilial("DUE") + "' "
							cQuery += "    AND DUE_CODSOL = DT5_CODSOL "
							cQuery += "    AND DUE.D_E_L_E_T_ = ' ' "
							cQuery += "  LEFT JOIN " + RetSQLName("DUL") + " DUL "
							cQuery += "    ON DUL_FILIAL = '" + xFilial("DUL") + "' "
							cQuery += "    AND DUL_CODSOL = DT5_CODSOL "
							cQuery += "    AND DUL_SEQEND = DT5_SEQEND "
							cQuery += "    AND DUL.D_E_L_E_T_ = ' ' "
							cQuery += "  WHERE DT5_FILIAL = '" + xFilial("DT5") + "' "
							cQuery += "    AND DT5_FILORI = '" + cFilOri + "' "
							cQuery += "    AND DT5_NUMSOL = '" + cNumSol + "' "
							cQuery += "    AND DT5.D_E_L_E_T_ = ' ' "
							cQuery := ChangeQuery(cQuery)

							DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAliasDT5,.T.,.T.)
							If !(cAliasDT5)->(Eof())
								//-- Endereco do Solicitante
								If !Empty((cAliasDT5)->DUL_CODMUN)
									If aScan(aUF,{|x| x[1] == (cAliasDT5)->DUL_EST }) != 0   //Confere se Uf do End.Solicitante esta OK
										cCodUFOri  := aUF[ aScan(aUF,{|x| x[1] == (cAliasDT5)->DUL_EST }), 2]
									Else
										cCodUFOri  := ''
									EndIf
									cString += '<cMunIni>' + NoAcentoCte( AllTrim(cCodUFOri) + Alltrim((cAliasDT5)->(DUL_CODMUN)) )  + '</cMunIni>'
									cString += '<xMunIni>' + NoAcentoCte( (cAliasDT5)->(DUL_MUN) ) + '</xMunIni>'
									cString += '<UFIni>'   + NoAcentoCte( (cAliasDT5)->(DUL_EST) ) + '</UFIni>'
								Else
									//-- Solicitante
									If aScan(aUF,{|x| x[1] == (cAliasDT5)->DUE_EST }) != 0   //Confere se Uf do Solicitante esta OK
										cCodUFOri  := aUF[ aScan(aUF,{|x| x[1] == (cAliasDT5)->DUE_EST }), 2]
									Else
										cCodUFOri  := ''
									EndIf
									cString += '<cMunIni>' + NoAcentoCte( AllTrim(cCodUFOri) +  Alltrim((cAliasDT5)->(DUE_CODMUN)) )  + '</cMunIni>'
									cString += '<xMunIni>' + NoAcentoCte( (cAliasDT5)->(DUE_MUN) ) + '</xMunIni>'
									cString += '<UFIni>'   + NoAcentoCte( (cAliasDT5)->(DUE_EST) ) + '</UFIni>'
								EndIf
							EndIf
							(cAliasDT5)->(DbCloseArea())
						EndIf
					EndIf
					
					If (cAliasDT6)->DT6_DOCTMS $ '67' //Devolução ou Reentrega
						cSeqEntr := (cAliasDT6)->DT6_SQEDES
					EndIf
					
					If !Empty(cSeqEntr)//-- Seq.Entrega preenchida

						If !Empty((cAliasDT6)->DT6_CLIREC)//-- Recebedor preenchido
							cString += '<cMunFim>'	+ NoAcentoCte( AllTrim(cCodUFRec) + AllTrim((cAliasDT6)->REC_COD_MUN)) + '</cMunFim>'
							cString += '<xMunFim>'	+ NoAcentoCte( (cAliasDT6)->REC_MUNICI  )  + '</xMunFim>'
							cString += '<UFFim>'	+ NoAcentoCte( (cAliasDT6)->REC_UF   )  + '</UFFim>'
						Else
							DUL->(DbSetOrder(1))
								If DUL->(MsSeek(xFilial("DUL") + (cAliasDT6)->DT6_SQEDES)) .AND. (cAliasDT6)->DT6_CDRDES != DUL->DUL_CDRDES .And. !(cAliasDT6)->DT6_DOCTMS $ '67' //Devolução ou Reentrega
									If aScan(aUF,{|x| x[1] == DUL->DUL_EST }) != 0   //Confere se Uf da DUL esta OK
										cCodUFDUL  := aUF[ aScan(aUF,{|x| x[1] == DUL->DUL_EST }), 2]
										cString += '<cMunFim>'	+ NoAcentoCte( AllTrim(cCodUFDUL) + AllTrim(DUL->DUL_CODMUN ) ) + '</cMunFim>' 
										cString += '<xMunFim>'	+ NoAcentoCte( DUL->DUL_MUN ) + '</xMunFim>'
										cString += '<UFFim>'	+ NoAcentoCte( DUL->DUL_EST ) + '</UFFim>'
									EndIf
							
								Else
									cString += '<cMunFim>'	+ NoAcentoCte( AllTrim(cCodUFDes ) + AllTrim((cAliasDT6)->DES_COD_MUN ) ) + '</cMunFim>'
									cString += '<xMunFim>'	+ NoAcentoCte( (cAliasDT6)->DES_MUNICI ) + '</xMunFim>'
									cString += '<UFFim>'	+ NoAcentoCte( (cAliasDT6)->DES_UF ) + '</UFFim>'
								EndIf
						EndIf

					ElseIf Empty(cSeqEntr) .And. !Empty((cAliasDT6)->DT6_CLIREC)
							cString += '<cMunFim>'	+ NoAcentoCte( AllTrim(cCodUFRec) + AllTrim((cAliasDT6)->REC_COD_MUN)) + '</cMunFim>'
							cString += '<xMunFim>'	+ NoAcentoCte( (cAliasDT6)->REC_MUNICI  )  + '</xMunFim>'
							cString += '<UFFim>'	+ NoAcentoCte( (cAliasDT6)->REC_UF   )  + '</UFFim>'
					Else
						If cCTeUnico == '4' .AND. !Empty(cUniDes)
							DTC->(DbSetOrder(3))	
							SA1->(DbSetOrder(1))	
							If DTC->(DbSeek(xFilial("DTC")+(cAliasDT6)->(DT6_FILDOC+DT6_DOC+DT6_SERIE)))
								If SA1->(dbSeek(xFilial('SA1') + DTC->DTC_CLIDES + DTC->DTC_LOJDES))
									If (aScan(aUF,{|x| x[1] == SA1->A1_EST }) != 0)
										cUFDESGLOB := aUF[ aScan(aUF,{|x| x[1] == SA1->A1_EST }), 2]
												
										cString += '<cMunFim>'	+ NoAcentoCte( AllTrim(cUFDESGLOB ) + AllTrim(SA1->A1_COD_MUN ) ) + '</cMunFim>'
										cString += '<xMunFim>'	+ NoAcentoCte( Alltrim(SA1->A1_MUN)) + '</xMunFim>'
										cString += '<UFFim>'	+ NoAcentoCte( AllTrim(SA1->A1_EST)) + '</UFFim>'
									EndIF
								EndIf
							EndIf
						Else
							cString += '<cMunFim>'	+ NoAcentoCte( AllTrim(cCodUFDes ) + AllTrim((cAliasDT6)->DES_COD_MUN ) ) + '</cMunFim>'
							cString += '<xMunFim>'	+ NoAcentoCte( (cAliasDT6)->DES_MUNICI ) + '</xMunFim>'
							cString += '<UFFim>'	+ NoAcentoCte( (cAliasDT6)->DES_UF ) + '</UFFim>'
						EndIf
					EndIf

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Recebedor retira no aeroporto,filial, porto ou Estacao Destino? ³
					//³ 0 - SIM / 1 - NAO                                               ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If  (cAliasDT6)->DT6_RETIRA == '1'
						cString += '<retira>0</retira>'
						cString += '<xDetRetira>NAO SE APLICA</xDetRetira>'
					Else
						cString += '<retira>1</retira>'							
					EndIf

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ TAG Tomador do Serviço ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ				
					cString += CTeToma(cAliasDT6, 1, cCodUFDpc)
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Contigencia 1.04                                                 ³
					//³Data e hora de entrada em contigencia                            ³
					//³Formato = AAAA-MM-DDTHH:MM:SS                                    ³
					//³Justificativa da Contigencia -                                   ³
					//³Preenchida no momento de escolha da opcao de Contigencia FSDA    ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If lUsaColab
						If	cModalidade == '5'
							cString += '<dhCont>' + ColGetPar("MV_CTINCON","") + '</dhCont>'
							cString += '<xJust>'  + ColGetPar("MV_CTXJUST","") + '</xJust>'
						EndIf
					Else
						If	cModalidade == '7'
							If	Len(aMotivoCont) >= 3
								cDtCont := DTOS(aMotivoCont[2])
								cString += '<dhCont>' + SubStr(AllTrim(cDtCont), 1, 4) + "-";
								+ SubStr(AllTrim(cDtCont), 5, 2) + "-";
								+ SubStr(AllTrim(cDtCont), 7, 2) + "T";
								+ SubStr(AllTrim(aMotivoCont[3]), 1, 2) + ":";
								+ SubStr(AllTrim(aMotivoCont[3]), 4, 2) + ':00';
								+ cTimeZone + '</dhCont>'
								cString += '<xJust>' + aMotivoCont[1] + '</xJust>'
							EndIf
						EndIf
					EndIf
					
					cString += '</ide>'
					aAdd(aXMLCTe,AllTrim(cString))
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Valores referente a base icms e valor do credito presumido      ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					cAliasRBC := GetNextAlias()					
					cQuery := " SELECT F4_BASEICM, F4_CRDPRES, D2_VALICM, F4_COMPL, F4_CONSUMO" + CRLF
					cQuery += ", F4_DIFAL" + CRLF
					cQuery += "   FROM " + RetSqlName("SD2") + " D2," + RetSqlName("SF4") + " F4" + CRLF
					cQuery += "  WHERE D2.D2_FILIAL  = '" + xFilial('SD2') + "'" + CRLF
					If AllTrim((cAliasDT6)->DT6_DOCTMS) == "M"
						cQuery += "    AND D2.D2_DOC   = '" + (cAliasDT6)->DT6_DOCDCO + "'" + CRLF
						cQuery += "    AND D2.D2_SERIE = '" + (cAliasDT6)->DT6_SERDCO + "'" + CRLF
					Else
						cQuery += "    AND D2.D2_DOC   = '" + cNota   + "'" + CRLF
						cQuery += "    AND D2.D2_SERIE = '" + cSerie  + "'" + CRLF
					EndIf	
					cQuery += "    AND D2.D2_CLIENTE   = '" + cClieFor + "'" + CRLF
					cQuery += "    AND D2.D2_LOJA      = '" + cLoja    + "'" + CRLF
					cQuery += "    AND D2.D_E_L_E_T_ = ' '" + CRLF
					
					//-- Cadastro de TES
					cQuery += "    AND F4.F4_FILIAL	= '"  + xFilial('SF4') + "'" + CRLF
					cQuery += "    AND F4.F4_CODIGO	= D2.D2_TES" + CRLF
					cQuery += "    AND F4.D_E_L_E_T_ = ' '"
										
					cQuery := ChangeQuery(cQuery)
					DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasRBC, .F., .T.)
					If !(cAliasRBC)->(Eof())
						If (cAliasRBC)->F4_BASEICM > 0
							cpRedBC := AllTrim(Str(100-(cAliasRBC)->F4_BASEICM))
						EndIf
						nVcred  := ((cAliasRBC)->F4_CRDPRES*(cAliasRBC)->D2_VALICM)
					EndIf					
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ TAG:  Informacoes relativas ICMS para a UF de término da `     //
					// prestação do serviço de transporte nas operações interestaduais //
					// para consumidor final  Emenda Constitucional 87 de 2015.        //
					// Nota Técnica 2015/003 e 2015/004                                //
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
					If (cAliasRBC)->F4_DIFAL == "1" .And. (cAliasRBC)->F4_COMPL == "S" .And. (cAliasRBC)->F4_CONSUMO == "S"
						//--Zerar Variaveis
						nBCICMS := 0
						nPERFCP := 0
						nALQTER := 0
						nALQINT := 0
						nPEDDES := 0
						nVALFCP := 0
						nVALDES := 0
						nVLTRIB := 0
							
						cAliasCD2 := GetNextAlias()					
						cQuery := " SELECT SUM(CD2.CD2_BC) CD2_BC,"+ CRLF
						cQuery += " CD2.CD2_PFCP," + CRLF
						cQuery += " CD2.CD2_ALIQ," + CRLF
						cQuery += " CD2.CD2_ADIF," + CRLF
						cQuery += " CD2.CD2_PDDES," + CRLF
						cQuery += " SUM(CD2.CD2_VFCP) CD2_VFCP," + CRLF
						cQuery += " SUM(CD2.CD2_VDDES) CD2_VDDES,"+ CRLF
						cQuery += " SUM(CD2.CD2_VLTRIB) CD2_VLTRIB " + CRLF														
						cQuery += "   FROM "+ RetSqlName("SD2") + " D2," + RetSqlName("CD2") + " CD2 "  + CRLF	
						cQuery += "    WHERE D2.D2_FILIAL  = '" + xFilial('SD2') + "'" + CRLF
						cQuery += "    AND D2.D2_DOC     = '" + cNota    + "'" + CRLF      
						cQuery += "    AND D2.D2_SERIE   = '" + cSerie   + "'" + CRLF      
						cQuery += "    AND D2.D2_CLIENTE = '" + cClieFor + "'" + CRLF      
						cQuery += "    AND D2.D2_LOJA    = '" + cLoja    + "'" + CRLF      
						cQuery += "    AND D2.D_E_L_E_T_ = ''" + CRLF       
													
						cQuery += "    AND CD2.CD2_FILIAL = '"  + xFilial('CD2') + "'" + CRLF							
						cQuery += "    AND CD2.CD2_CODCLI = D2.D2_CLIENTE " + CRLF
						cQuery += "    AND CD2.CD2_LOJCLI = D2.D2_LOJA " + CRLF
						cQuery += "    AND CD2.CD2_DOC    = D2.D2_DOC " + CRLF
						cQuery += "    AND CD2.CD2_SERIE  = D2.D2_SERIE " + CRLF
						cQuery += "    AND CD2.CD2_ITEM   = D2.D2_ITEM " + CRLF
						cQuery += "    AND CD2.CD2_IMP    = '" + PadR("CMP",TamSX3("CD2_IMP")[1]) + "'" + CRLF
						cQuery += "    AND CD2.D_E_L_E_T_=' '" + CRLF	
						
						cQuery += " GROUP BY CD2.CD2_PFCP,CD2.CD2_ALIQ,CD2.CD2_ADIF,CD2.CD2_PDDES "	+ CRLF						  
											
						cQuery := ChangeQuery(cQuery)
						DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasCD2, .F., .T.)
						If !(cAliasCD2)->(Eof())
							nBCICMS := (cAliasCD2)->CD2_BC
							nPERFCP := (cAliasCD2)->CD2_PFCP
							nALQTER := (cAliasCD2)->CD2_ALIQ
							nALQINT := (cAliasCD2)->CD2_ADIF
							nPEDDES := (cAliasCD2)->CD2_PDDES
							nVALFCP := (cAliasCD2)->CD2_VFCP
							nVALDES := (cAliasCD2)->CD2_VDDES
							nVLTRIB := (cAliasCD2)->CD2_VLTRIB
						EndIf			

						(cAliasCD2)->(DbCloseArea())
					Else
						//Tratamento para que nao sejam geradas as TAGs no XML caso nao atenda as condiçoes
						lDifal := .F.
					EndIf
					//--Valor do ICMS de partilha para a UF de término da prestação do serviço de transporte
					If nVALDES > 0
						cDTCObs += "Valor do ICMS de partilha para a UF de termino da prestacao do servico de transporte.R$ " + cValtochar(nVALDES)						
					EndIf

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ TAG: Dados complementares do CT-e para fins operacionais ou      ³
					//³ comerciaisEmitente do CT-e                                       ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If !Empty(cDTCObs) .Or. (cAliasDT6)->DT6_VALIMP > 0 .Or. SF2->F2_TOTIMP > 0
						cString := '<compl>'
						//-- Observacoes Gerais
						If !Empty(cDTCObs)
							cString += '<xObs>' + NoAcentoCte(SubStr(cDTCObs,1,1000)) + '</xObs>'
						EndIf						
						//-- Observacoes Contribuintes - Uso exclusivo do emissor CT-E
						If SF2->F2_TOTIMP > 0
							cTxtObs := 'O valor aproximado de tributos incidentes sobre o preco deste servico e de R$ ' + PADL(Transform(SF2->F2_TOTIMP,'@E 999,999.99'),20)
							cString +=  '<ObsCont xCampo="LeidaTransparencia">'
							cString +=    '<xTexto>'+cTxtObs+'</xTexto>'
							cString +=  '</ObsCont>'
							cString += '</compl>'						
						//-- Observacoes Contribuintes - Uso exclusivo do emissor CT-E
						ElseIf (cAliasDT6)->DT6_VALIMP > 0
							cTxtObs := 'O valor aproximado de tributos incidentes sobre o preco deste servico e de R$ ' + PADL(Transform((cAliasDT6)->DT6_VALIMP,'@E 999,999.99'),20)
							cString +=  '<ObsCont xCampo="LeidaTransparencia">'
							cString +=    '<xTexto>'+cTxtObs+'</xTexto>'
							cString +=  '</ObsCont>'
							cString += '</compl>'
						Else
							cString += '</compl>'	
						EndIf
						aAdd(aXMLCTe,AllTrim(cString))
					EndIf

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ TAG: D - Emitente do CT-e                                        ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					cString := '<emit>'
					cString += '<CNPJ>' + NoPontos(SM0->M0_CGC) + '</CNPJ>' 
					
					If !(AllTrim(SM0->M0_INSC) == 'ISENTO')
						cString += '<IE>' + NoPontos(SM0->M0_INSC) + '</IE>'
					EndIf
					
					If lDifal .And. !Empty(cUFST)						
					    cSubTrib := GetSubTrib(cUFST,lDifal) 
						If !Empty(cSubTrib)
							cString += '<IEST>' + NoPontos(cSubTrib) + '</IEST>'		
						EndIf				
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

					cString += '<cMun>' + NoAcentoCte( SM0->M0_CODMUN ) + '</cMun>'
					cString += '<xMun>' + NoAcentoCte( SM0->M0_CIDENT ) + '</xMun>'
					cString += '<CEP>'  + NoAcentoCte( SM0->M0_CEPENT ) + '</CEP>'
					cString += '<UF>'   + NoAcentoCte( SM0->M0_ESTENT ) + '</UF>'
					If !Empty (NoPontos(SM0->M0_TEL))
						cString += '<fone>' + cValtoChar(NoPontos(SM0->M0_TEL)) + '</fone>'
					EndIf
					cString += '</enderEmit>'
					If AllTrim(cVerAmb) == '4.00'
						cString += '<CRT>' + cMVSINAC + '</CRT>'
					EndIf
					cString += '</emit>'

					aAdd(aXMLCTe,AllTrim(cString))

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ TAG: E - Remetente das mercadorias transportadas pelo CT-e       ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					//| Se o tipo da nf estiver configurado com '9' Redespacho Intermediário
					//| a tag <rem> deixa de fazer parte do XML
					cString := ""
					If !(cTipoNF $ "9/A")
							
							cString += '<rem>'
							If (AllTrim((cAliasDT6)->REM_TPPESSOA) == "J")
								cString += '<CNPJ>' + IIf((cAliasDT6)->REM_UF <> 'EX',NoAcentoCte( (cAliasDT6)->REM_CNPJ ),StrZero(0,14)) + '</CNPJ>'
								If (cAliasDT6)->REM_CONTRIB == '1' 
									//-- Qdo sequencia do IE estiver preenchida.
									If Empty(cInsRemOpc)
										If Empty((cAliasDT6)->REM_INSC) .Or. "ISENT" $ Upper(AllTrim((cAliasDT6)->REM_INSC))
											cString += '<IE>ISENTO</IE>'
										Else
											cString += '<IE>' + NoPontos((cAliasDT6)->REM_INSC) + '</IE>'
										EndIf
									ElseIf 'ISENT' $ Upper(cInsRemOpc)
										cString += '<IE>ISENTO</IE>'
									Else
										cString += '<IE>' + NoPontos(cInsRemOpc) + '</IE>'
									EndIf
								Else							
									If !("ISENT" $ Upper(AllTrim((cAliasDT6)->REM_INSC)))
										cString += '<IE>' + NoPontos((cAliasDT6)->REM_INSC) + '</IE>'
									EndIf							
								EndIf						
							Else
								cString += '<CPF>' + IIf((cAliasDT6)->REM_UF <> 'EX',NoAcentoCte( (cAliasDT6)->REM_CNPJ ),StrZero(0,14) ) + '</CPF>'

								//IE somente deve ser gerado quando Contribuinte = Sim
								//-- Qdo sequencia do IE estiver preenchida.
								If (cAliasDT6)->REM_CONTRIB == '1'
									If Empty(cInsRemOpc)
										If !Empty((cAliasDT6)->REM_INSC) .And. !('ISENT' $ Upper(AllTrim((cAliasDT6)->REM_INSC)))
											cString += '<IE>' + NoPontos((cAliasDT6)->REM_INSC) + '</IE>'
										EndIf
									Else
										If !('ISENT' $ Upper(AllTrim(cInsRemOpc)))
											cString += '<IE>' + NoPontos(cInsRemOpc) + '</IE>'
										EndIf
									EndIf
								Else							
									If !Empty((cAliasDT6)->REM_INSC) .And. !('ISENT' $ Upper(AllTrim((cAliasDT6)->REM_INSC)))
										cString += '<IE>' + NoPontos((cAliasDT6)->REM_INSC) + '</IE>'
									EndIf							
								EndIf						
							EndIf

							If cAmbiente == '2'  //--Homologacao / Nota Técnica 2012/005 
								cString += '<xNome>' + (SubStr('CTE EMITIDO EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL',1,60)) + '</xNome>'
							Else
								If cCTeUnico == '4'	.And. !Empty(cUniRem) // Para os casos de CTe Unico					
									cString += '<xNome>' + cUniRem + '</xNome>'
								Else
									cString += '<xNome>' + NoAcentoCte(SubStr((cAliasDT6)->REM_NOME,1,60)) + '</xNome>'
								EndIf
							EndIf
							cString += '<xFant>' + NoAcentoCte((cAliasDT6)->REM_NMEFANT) + '</xFant>'
							If !Empty((cAliasDT6)->REM_TEL)
								cString += '<fone>' + cValtoChar(NoPontos((cAliasDT6)->REM_DDDTEL)) +;
								cValtoChar(NoPontos((cAliasDT6)->REM_TEL)) + '</fone>'
							EndIf
							
							cString += '<enderReme>'
							cString += '<xLgr>' + NoAcentoCte(FisGetEnd((cAliasDT6)->REM_END)[1]) + '</xLgr>'
							cString += '<nro>' + Iif(FisGetEnd((cAliasDT6)->REM_END)[2] <> 0, AllTrim(cValtoChar( FisGetEnd((cAliasDT6)->REM_END)[2])),"S/N") + '</nro>'
							If !Empty(NoAcentoCte((cAliasDT6)->REM_CPL))
								cString += '<xCpl>' + NoAcentoCte((cAliasDT6)->REM_CPL) + '</xCpl>'
							EndIf
							If Empty(AllTrim((cAliasDT6)->REM_BAIRRO))
								cString += '<xBairro>BAIRRO NAO CADASTRADO</xBairro>'
							Else	
								cString += '<xBairro>' + NoAcentoCte( (cAliasDT6)->REM_BAIRRO ) + '</xBairro>'
							EndIf
							cString += '<cMun>' + NoAcentoCte( AllTrim(cCodUFRem) + AllTrim((cAliasDT6)->REM_COD_MUN) ) + '</cMun>'
							cString += '<xMun>' + NoAcentoCte( (cAliasDT6)->REM_MUNICI ) + '</xMun>'
							cString += '<CEP>'  + NoAcentoCte( (cAliasDT6)->REM_CEP ) + '</CEP>'
							cString += '<UF>'   + NoAcentoCte( (cAliasDT6)->REM_UF ) + '</UF>'
							If !Empty(AllTrim((cAliasDT6)->REM_CBACEN))
								cString += '<cPais>'+ NoAcentoCte( RIGHT((cAliasDT6)->REM_CBACEN ,4 )) + '</cPais>'
								cString += '<xPais>'+ NoAcentoCte( Posicione("CCH",1,xFilial("CCH")+(cAliasDT6)->REM_CBACEN,"CCH_PAIS") ) + '</xPais>'					
							Else
								If !Empty(AllTrim((cAliasDT6)->REM_PAIS))
									cString += '<cPais>'+ NoAcentoCte( (cAliasDT6)->REM_PAIS ) + '</cPais>'
									cString += '<xPais>'+ NoAcentoCte( Posicione("SYA",1,xFilial("SYA")+(cAliasDT6)->REM_PAIS,"YA_DESCR") ) + '</xPais>'
								EndIf
							EndIf
							cString += '</enderReme>'
							If !Empty((cAliasDT6)->REM_EMAIL)
								cString += '<email>' + NoAcentoCte(Substr(AllTrim((cAliasDT6)->REM_EMAIL), 1, 60)) + '</email>'
							EndIf
							cString += '</rem>'
							aAdd(aXMLCTe,AllTrim(cString))
							cString	  := ""	
					EndIf

					//+----------------------------------------------------------------
					//-- Informacoes do Expedidor da Carga
					//+----------------------------------------------------------------
					cString := grpExpedid((cAliasDT6)->DT6_CLIREM,(cAliasDT6)->DT6_LOJREM,cCliExp,cLojExp,cFilOri,cNumSol,aUF,cAmbiente)
					aAdd(aXMLCTe,AllTrim(cString))
					cString := ""

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ TAG: E - Grupos de informacoes das NF                            ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ					
					If FindFunction("TmsPsqDY4") .And. TmsPsqDY4( (cAliasDT6)->DT6_FILDOC, (cAliasDT6)->DT6_DOC, (cAliasDT6)->DT6_SERIE )							
						cAliasTagE := GetNextAlias()
						cQuery := " SELECT DTC.DTC_NUMNFC, DTC.DTC_SERNFC, DTC.DTC_EMINFC, " + CRLF
						cQuery += "        DTC.DTC_NFEID, DTC.DTC_CLIDES, DTC.DTC_LOJDES,  " + CRLF
						cQuery += "        DTC.DTC_SQEDES, DTC.DTC_TIPNFC, DTC.DTC_TIPNFC, " + CRLF
						cQuery += "        DTC.DTC_FILORI, DTC.DTC_NUMSOL,DTC.DTC_SELORI,  " + CRLF
						cQuery += "        DTC_CF, DTC_DTENTR, DTC_FILCFS, DTC.DTC_DEVFRE, " + CRLF
						cQuery += "        SUM(DTC.DTC_BASICM) DTC_BASICM, SUM(DTC.DTC_VALICM) DTC_VALICM, " + CRLF
						cQuery += "        SUM(DTC.DTC_BASESU) DTC_BASESU, SUM(DTC.DTC_VALIST) DTC_VALIST, " + CRLF
						cQuery += "        SUM(DTC.DTC_VALOR)  DTC_VALOR,  SUM(DTC.DTC_PESO)   DTC_PESO,   " + CRLF
						cQuery += "        SUM(DTC.DTC_PESOM3) DTC_PESOM3, SUM(DTC.DTC_METRO3) DTC_METRO3, " + CRLF
						cQuery += "        SUM(DTC.DTC_QTDVOL) DTC_QTDVOL " + CRLF
						cQuery += "   FROM " + RetSqlName('DTC') + " DTC " + CRLF
							
						cQuery += "    INNER JOIN " + RetSqlName('DY4') + " DY4 ON " + CRLF
						cQuery += "    DTC.DTC_FILORI = DY4.DY4_FILORI " + CRLF		
						cQuery += "    AND DTC.DTC_NUMNFC = DY4.DY4_NUMNFC " + CRLF							
						cQuery += "    AND DTC.DTC_SERNFC = DY4.DY4_SERNFC " + CRLF
						cQuery += "    AND DTC.DTC_CLIREM = DY4.DY4_CLIREM " + CRLF
						cQuery += "    AND DTC.DTC_LOJREM = DY4.DY4_LOJREM " + CRLF
						cQuery += "    AND DTC.DTC_CODPRO = DY4.DY4_CODPRO " + CRLF
						cQuery += "    AND DTC.D_E_L_E_T_  = ' '" + CRLF						
							
						//-- DTC - Documento Cliente para Transporte
						cQuery += "  WHERE DY4.DY4_FILIAL	= '" + xFilial('DY4') + "'" + CRLF
							
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Se o tipo de Conhecimento for de Complemento, seleciona as       ³
						//³ informacoes do CTR principal, pois o complemento nao tem DTC     ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ							
						
						cQuery += "    AND DY4.DY4_FILDOC   = '" + (cAliasDT6)->DT6_FILDOC + "'" + CRLF
						cQuery += "    AND DY4.DY4_DOC      = '" + (cAliasDT6)->DT6_DOC    + "'" + CRLF
						cQuery += "    AND DY4.DY4_SERIE    = '" + (cAliasDT6)->DT6_SERIE  + "'" + CRLF
						
						cQuery += "  AND DY4.D_E_L_E_T_ = ' '" + CRLF
						cQuery += "  GROUP BY DTC.DTC_NUMNFC, DTC.DTC_SERNFC, DTC.DTC_EMINFC, DTC_FILCFS,  "    + CRLF
						cQuery += "           DTC.DTC_NFEID,  DTC.DTC_CLIDES, DTC.DTC_LOJDES, DTC.DTC_SQEDES, " + CRLF
						cQuery += "           DTC.DTC_TIPNFC, DTC_DTENTR,     DTC.DTC_FILORI, DTC.DTC_NUMSOL, " + CRLF
						cQuery += "			 DTC.DTC_SELORI, DTC_CF, 	     DTC_DEVFRE "                      + CRLF
					Else						
						cAliasTagE := GetNextAlias()
						cQuery := " SELECT DTC.DTC_NUMNFC, DTC.DTC_SERNFC, DTC.DTC_EMINFC, " + CRLF
						cQuery += "        DTC.DTC_NFEID,  DTC.DTC_CLIDES, DTC.DTC_LOJDES, " + CRLF
						cQuery += "        DTC.DTC_SQEDES, DTC.DTC_TIPNFC, DTC.DTC_TIPNFC, " + CRLF
						cQuery += "        DTC.DTC_FILORI, DTC.DTC_NUMSOL,DTC.DTC_SELORI, DTC_CF, DTC_DTENTR, " + CRLF
						cQuery += "        DTC_FILCFS, DTC.DTC_DEVFRE, " + CRLF
						cQuery += "        SUM(DTC.DTC_BASICM) DTC_BASICM, SUM(DTC.DTC_VALICM) DTC_VALICM, " + CRLF
						cQuery += "        SUM(DTC.DTC_BASESU) DTC_BASESU, SUM(DTC.DTC_VALIST) DTC_VALIST, " + CRLF
						If AllTrim((cAliasDT6)->DT6_DOCTMS) <> "P"
							cQuery += "        SUM(DTC.DTC_VALOR)  DTC_VALOR,  SUM(DTC.DTC_PESO)   DTC_PESO,   " + CRLF
							cQuery += "        SUM(DTC.DTC_PESOM3) DTC_PESOM3, SUM(DTC.DTC_METRO3) DTC_METRO3, " + CRLF
							cQuery += "        SUM(DTC.DTC_QTDVOL) DTC_QTDVOL " + CRLF
						Else
							cQuery += "        SUM(DT6.DT6_VALMER)  DTC_VALOR,  SUM(DT6.DT6_PESO)   DTC_PESO,   " + CRLF
							cQuery += "        SUM(DT6.DT6_PESOM3) DTC_PESOM3, SUM(DT6.DT6_METRO3) DTC_METRO3, " + CRLF
							cQuery += "        SUM(DT6.DT6_QTDVOL) DTC_QTDVOL " + CRLF
						EndIf
						cQuery += "   FROM " + RetSqlName('DTC') + " DTC " + CRLF
						If	lDocApoio
							cQuery += " INNER JOIN " + RetSqlName("DT6") + " DT6 " + CRLF
							cQuery += "   ON DT6.DT6_CLIDEV   = '" + (cAliasDT6)->DT6_CLIDEV + "'" + CRLF
							cQuery += "  AND DT6.DT6_LOJDEV   = '" + (cAliasDT6)->DT6_LOJDEV + "'" + CRLF
							cQuery += "  AND DT6.DT6_PREFIX   = '" + (cAliasDT6)->DT6_PREFIX + "'" + CRLF
							cQuery += "  AND DT6.DT6_NUM      = '" + (cAliasDT6)->DT6_NUM    + "'" + CRLF
							cQuery += "  AND DT6.DT6_TIPO     = '" + (cAliasDT6)->DT6_TIPO   + "'" + CRLF
							cQuery += "  AND DT6_DOCTMS IN('B','C','H','I','N','O') "
							cQuery += "  AND DT6.D_E_L_E_T_   = ' '" + CRLF
						EndIf
						If !lDocApoio .And. !Empty((cAliasDT6)->DT6_DOCDCO) .And. AllTrim((cAliasDT6)->DT6_DOCTMS) <> "P"
							cQuery += "    INNER JOIN " + RetSqlName('DT6') + " DT6 ON " + CRLF
							cQuery += "    DT6.DT6_DOC = '" + (cAliasDT6)->DT6_DOCDCO  + "'" + CRLF
							cQuery += "    AND DT6.DT6_SERIE   = '" + (cAliasDT6)->DT6_SERDCO  + "'" + CRLF
							cQuery += "    AND DT6.DT6_FILDOC  = '" + (cAliasDT6)->DT6_FILDCO  + "'" + CRLF
							cQuery += "    AND DT6.D_E_L_E_T_  = ' '" + CRLF
						ElseIf !lDocApoio .And. AllTrim((cAliasDT6)->DT6_DOCTMS) == "P" 
							cQuery += "    INNER JOIN " + RetSqlName('DT6') + " DT6 ON " + CRLF
							cQuery += "    DT6.DT6_DOC = '" + (cAliasDT6)->DT6_DOC  + "'" + CRLF
							cQuery += "    AND DT6.DT6_SERIE   = '" + (cAliasDT6)->DT6_SERIE  + "'" + CRLF
							cQuery += "    AND DT6.DT6_FILDOC  = '" + (cAliasDT6)->DT6_FILDOC  + "'" + CRLF
							cQuery += "    AND DT6.D_E_L_E_T_  = ' '" + CRLF
						EndIf
						//-- DTC - Documento Cliente para Transporte
						cQuery += "  WHERE DTC.DTC_FILIAL	= '" + xFilial('DTC') + "'" + CRLF
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Se o tipo de Conhecimento for de Complemento, seleciona as       ³
						//³ informacoes do CTR principal, pois o complemento nao tem DTC     ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If lDocApoio
							cQuery += "  AND DTC.DTC_FILDOC   = DT6.DT6_FILDOC " + CRLF
							cQuery += "  AND (DTC.DTC_DOC     = DT6.DT6_DOC OR DTC.DTC_DOCPER = DT6.DT6_DOC )" + CRLF
							cQuery += "  AND DTC.DTC_SERIE    = DT6.DT6_SERIE  " + CRLF
						Else
							If !Empty(cDocDco) 
								cQuery += "    AND DTC.DTC_FILDOC   = '" + cFilDco + "'" + CRLF
								cQuery += "    AND (DTC.DTC_DOC     = '" + cDocDco + "' OR DTC.DTC_DOCPER = '" + cDocDco + "')" + CRLF
								cQuery += "    AND DTC.DTC_SERIE    = '" + cSerDco + "'" + CRLF
							Else
								cQuery += "    AND DTC.DTC_FILDOC   = '" + (cAliasDT6)->DT6_FILDOC + "'" + CRLF
								cQuery += "    AND (DTC.DTC_DOC     = '" + (cAliasDT6)->DT6_DOC    + "' OR DTC.DTC_DOCPER = '" + (cAliasDT6)->DT6_DOC + "')" + CRLF
								cQuery += "    AND DTC.DTC_SERIE    = '" + (cAliasDT6)->DT6_SERIE  + "'" + CRLF
							EndIf
						EndIf
						cQuery += "  AND DTC.D_E_L_E_T_ = ' '" + CRLF
						cQuery += "  GROUP BY DTC.DTC_NUMNFC, DTC.DTC_SERNFC, DTC.DTC_EMINFC, DTC_FILCFS,       " + CRLF
						cQuery += "           DTC.DTC_NFEID,  DTC.DTC_CLIDES, DTC.DTC_LOJDES, DTC.DTC_SQEDES,   " + CRLF
						cQuery += "           DTC.DTC_TIPNFC, DTC_DTENTR,     DTC.DTC_FILORI, DTC.DTC_NUMSOL,   " + CRLF
						cQuery += "           DTC.DTC_SELORI, DTC_CF, DTC_DEVFRE                                " + CRLF                
					Endif
					
					cQuery := ChangeQuery(cQuery)
					DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasTagE, .F., .T.)

					lSelOcor := (cAliasTagE)->DTC_SELORI == '3'
					if (AllTrim((cAliasTagE)->DTC_CLIDES) + AllTrim((cAliasTagE)->DTC_LOJDES)) ==;
					   (AllTrim((cAliasDT6)->DT6_CLIDES) + AllTrim((cAliasDT6)->DT6_LOJDES))
						cSeqEntr := (cAliasTagE)->DTC_SQEDES
					Else
						cSeqEntr := ''
					EndIF					

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica se possui viagem                                        ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					cViagem  := Posicione('DTP',2,xFilial('DTP')+(cAliasDT6)->DT6_FILORI+(cAliasDT6)->DT6_LOTNFC,'DTP_VIAGEM')
					cFilVia  := ''
					
					//Busca a viagem quando for coleta com entrega direta
					If Empty(cViagem) .And. !Empty((cAliasTagE)->DTC_DTENTR)
						cAliasViag := GetNextAlias()
						cQuery := " SELECT Max(DUD.R_E_C_N_O_) DUDRECNO"
						cQuery += "  FROM " + RetSqlName('DUD') + " DUD "
						cQuery += "  WHERE DUD.DUD_FILIAL	 = '" + xFilial("DUD")  + "'" + CRLF
						cQuery += "    AND DUD.DUD_FILDOC	 = '" + (cAliasTagE)->DTC_FILCFS + "'" + CRLF
						cQuery += "    AND DUD.DUD_DOC   	 = '" + (cAliasTagE)->DTC_NUMSOL + "'" + CRLF
						cQuery += "    AND DUD.DUD_SERIE   	 = 'COL'" + CRLF
						cQuery += "    AND DUD.D_E_L_E_T_ 	 = '' "
						cQuery := ChangeQuery(cQuery)
						DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasViag, .F., .T.)
						If (cAliasViag)->(!Eof())
							DUD->( DbGoto( (cAliasViag)->DUDRECNO ) )
							cFilVia := DUD->DUD_FILORI
							cViagem := DUD->DUD_VIAGEM							
						EndIf
						(cAliasViag)->(dbCloseArea())
					EndIf
					
					If ((cAliasTagE)->DTC_TIPNFC) $ '3,6,7'	// -- Documento Nao Fiscal
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ TAG de grupo de informacoes dos demais documentos  ³
						//³ Ex: Delaracao, Outros                              ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						While !(cAliasTagE)->(Eof())					 //Preenche aCarga totalizando todos os produtos do Ct-e
						
							cString += '<infOutros>'
							cString += '<tpDoc>99</tpDoc>'
							cString += '<nDoc>'+NoAcentoCte(AllTrim((cAliasTagE)->DTC_NUMNFC))+'</nDoc>'
							cString += '<dEmi>'	+ SubStr(AllTrim((cAliasTagE)->DTC_EMINFC), 1, 4) + "-" ;
							+ SubStr(AllTrim((cAliasTagE)->DTC_EMINFC), 5, 2) + "-" ;
							+ SubStr(AllTrim((cAliasTagE)->DTC_EMINFC), 7, 2) + '</dEmi>'
							cString += '</infOutros>'

							aCarga[1] += (cAliasTagE)->DTC_PESO
							aCarga[2] += (cAliasTagE)->DTC_PESOM3
							aCarga[3] += (cAliasTagE)->DTC_METRO3
							aCarga[4] += (cAliasTagE)->DTC_QTDVOL
							(cAliasTagE)->(dbSkip())
						Enddo
						   
						cStringOut	+= cString  
						cString 		:= ''
					Else					
						While (cAliasTagE)->(!Eof())
							If !Empty((cAliasTagE)->DTC_NFEID)							
								// Efetuar a inclusão da CHAVE da NF-e na TAG, somente quando não inserida ainda //
								If aScan(aNFEID,{|x| x == (cAliasTagE)->DTC_NFEID }) == 0
									AAdd(aNFEID, (cAliasTagE)->DTC_NFEID)
									
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³ INFNFE: IdentIficador da NF-e   ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									lNfe := .T.
									cStringCh += '<infNFe>'
									cStringCh += '<chave>' + AllTrim((cAliasTagE)->DTC_NFEID) + '</chave>' //-- IdentIficador da NF-e									
									cStringCh += '</infNFe>'									           								
								EndIf
								
								aCarga[1] += (cAliasTagE)->DTC_PESO
								aCarga[2] += (cAliasTagE)->DTC_PESOM3
								aCarga[3] += (cAliasTagE)->DTC_METRO3
								aCarga[4] += (cAliasTagE)->DTC_QTDVOL								
							Else								
								If Empty(cStringTmp)
									cStringTmp := cString 
									cString    := ''  
								Else
									cStringTmp += cString 
									cString    := ''   
								EndIf
								
                        	    cString += '<infNF>'
								cString += '<mod>01</mod>'
								cString += '<serie>' + NoAcentoCte( (cAliasTagE)->DTC_SERNFC ) + '</serie>'			//-- Serie da NF
								cString += '<nDoc>'  + NoAcentoCte( (cAliasTagE)->DTC_NUMNFC ) + '</nDoc>'				//-- Num. da NF
								cString += '<dEmi>'  + SubStr(AllTrim((cAliasTagE)->DTC_EMINFC), 1, 4) + "-" + SubStr(AllTrim((cAliasTagE)->DTC_EMINFC), 5, 2) + "-" + SubStr(AllTrim((cAliasTagE)->DTC_EMINFC), 7, 2) + '</dEmi>' //-- Data Emissao
								cString += '<vBC>'   + ConvType((cAliasTagE)->DTC_BASICM, 15, 2) + '</vBC>'		//-- Base de Cálculo do ICMS
								cString += '<vICMS>' + ConvType((cAliasTagE)->DTC_VALICM, 15, 2) + '</vICMS>'		//-- Valor total do ICMS
								cString += '<vBCST>' + ConvType((cAliasTagE)->DTC_BASESU, 15, 2) + '</vBCST>'		//-- Base de cálculo do ICMS ST
								cString += '<vST>'   + ConvType((cAliasTagE)->DTC_VALIST, 15, 2) + '</vST>'		//-- Valor total do ICMS ST
								cString += '<vProd>' + ConvType((cAliasTagE)->DTC_VALOR,  15, 2) + '</vProd>'		//-- Valor total do Produto
								cString += '<vNF>'   + ConvType((cAliasTagE)->DTC_VALOR,  15, 2) + '</vNF>'		//-- Valor total da Nota Fiscal
								cString += '<nCFOP>' + ConvType((cAliasTagE)->DTC_CF, 4) + '</nCFOP>'				//-- CFOP predominante
								
								//-- Preenche aCarga totalizando todos os produtos do Ct-e
								If AllTrim((cAliasDT6)->DT6_DOCTMS) == "P"
									aCarga[1] := (cAliasTagE)->DTC_PESO
									aCarga[2] := (cAliasTagE)->DTC_PESOM3
									aCarga[3] := (cAliasTagE)->DTC_METRO3
									aCarga[4] := (cAliasTagE)->DTC_QTDVOL
								Else
									aCarga[1] += (cAliasTagE)->DTC_PESO
									aCarga[2] += (cAliasTagE)->DTC_PESOM3
									aCarga[3] += (cAliasTagE)->DTC_METRO3
									aCarga[4] += (cAliasTagE)->DTC_QTDVOL
								EndIf
			
								cString += '</infNF>'    
								cString20	+= cString  
								cString 	:= ''								
							EndIf  
							(cAliasTagE)->(dbSkip())
						EndDo						
					EndIf
					(cAliasTagE)->(DbCloseArea())
					
					cStringTmp += cString
					aAdd(aXMLCTe,AllTrim(cStringTmp))
					cStringTmp  := ""
					cString	  := ""	
					
					If !Empty(cStringExp)
						aAdd(aXMLCTe,AllTrim(cStringExp))
					EndIf
					cStringExp	:= ""				
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ TAG: Dados do Recebedor                               ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If (cAliasDT6)->DT6_DOCTMS $ '7' //Reentrega utilizando sequencia de endereço
						cSeqEntr := (cAliasDT6)->DT6_SQEDES
					ElseIf (cAliasDT6)->DT6_DOCTMS == '6' .And. !Empty((cAliasDT6)->DT6_CLIREC) //| Se devolução e existir Recebedor Preenchido não pode usar a sequencia de endereço do destinatário
						cSeqEntr := Space(TamSx3("DT6_SQEDES")[1])
					EndIf
					
					//-- adicionar informações sobre o recebedor da mercadoria
					//-- Quando o CT-e vem da Manutenção de DOCUMENTOS - com tipo DEVOLUCAO DOCTMS = 6
					//-- Deve-se assumor o campo DT6_CLIREC.
					//--       MOTIVO: quando existe apenas o Recebedor no documento original com sequencia de endereço informada para o destinatário
					//--               essa informação não é invertida no processo de devolução e por isso não deve ser considerada.
					//--               Como contorno deve-se alterar o campo Sel.Des.Cal para 2-Cliente assim o campo de sequência de endereço é limpo 
					//--               fazendo com que o campo DT6_CLIREC seja utilizado ao invés da sequencia de endereços do destinatario.
					//--               Outro motivo é que o campo Sel.Des.Cal pode estar bloqueado devido a configuração no contrato do cliente.
					If (Empty(cSeqEntr) .And. !Empty((cAliasDT6)->DT6_CLIREC) .And. !Empty((cAliasDT6)->DT6_LOJREC))
						cString := tagRecebe((cAliasDT6)->DT6_CLIREC,(cAliasDT6)->DT6_LOJREC,cSeqEntr,cAmbiente,@lRedesp)

					ElseIf !Empty(cSeqEntr) .And. !Empty((cAliasDT6)->DT6_CLIDES) .And. !Empty((cAliasDT6)->DT6_LOJDES) //-- Usando Sequencia de endereco
						cString := tagRecebe((cAliasDT6)->DT6_CLIDES,(cAliasDT6)->DT6_LOJDES,cSeqEntr,cAmbiente,@lRedesp)

					EndIf
					aAdd(aXMLCTe,AllTrim(cString))

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ TAG: H - Dados do Destinatario                                  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					//| Quando o tipo da NF for diferente de Redespacho Intermediário
					//| o destinatário é obrigatório.
					If !(cTipoNF $ "9/A")
						cString := '<dest>'
						If (AllTrim((cAliasDT6)->DES_TPPESSOA) == "J")
							cString += '<CNPJ>' + Iif((cAliasDT6)->DES_UF <> 'EX', NoPontos((cAliasDT6)->DES_CNPJ), '00000000000000') + '</CNPJ>'
							If (cAliasDT6)->DES_CONTRIB == '1'	
								If Empty(cInsDesOpc)
									If Empty((cAliasDT6)->DES_INSC) .Or. 'ISENT' $ Upper(NoAcentoCte( (cAliasDT6)->DES_INSC ))
										cString += '<IE>ISENTO</IE>'
									Else
										cString += '<IE>' + NoPontos((cAliasDT6)->DES_INSC) + '</IE>'
									EndIf
								ElseIf 'ISENT' $ Upper(cInsDesOpc)
									cString += '<IE>ISENTO</IE>'
								Else
									cString += '<IE>' + NoPontos(cInsDesOpc) + '</IE>'
								EndIf
							Else							
								If !Empty((cAliasDT6)->DES_INSC) .And. !('ISENT' $ Upper(NoAcentoCte( (cAliasDT6)->DES_INSC )))
									cString += '<IE>' + NoPontos((cAliasDT6)->DES_INSC) + '</IE>'
								EndIf						 
							EndIf
						Else
							cString += '<CPF>' + Iif((cAliasDT6)->DES_UF <> 'EX', NoAcentoCte( (cAliasDT6)->DES_CNPJ ), '00000000000') + '</CPF>'
							If (cAliasDT6)->DES_CONTRIB == '1' 
								If Empty(cInsDesOpc)
									If !('ISENT' $ Upper(AllTrim((cAliasDT6)->DES_INSC)))
										cString += '<IE>' + NoPontos((cAliasDT6)->DES_INSC) + '</IE>'
									EndIf
								ElseIf !('ISENT' $ Upper(cInsDesOpc))
									cString += '<IE>' + NoPontos(cInsDesOpc) + '</IE>'
								EndIf
							Else
								If !Empty((cAliasDT6)->DES_INSC) .And. !('ISENT' $ Upper(AllTrim((cAliasDT6)->DES_INSC)))
									cString += '<IE>' + NoPontos((cAliasDT6)->DES_INSC) + '</IE>'
								EndIf
							EndIf
						EndIf

						If cAmbiente == '2'  //--Homologacao / Nota Técnica 2012/005 
							cString += '<xNome>' + (SubStr('CTE EMITIDO EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL',1,60)) + '</xNome>'
						Else
							If cCTeUnico == '4'	.And. !Empty(cUniDes) // Para os casos de CTe Unico					
								cString += '<xNome>' + cUniDes + '</xNome>'
							Else
								cString += '<xNome>' + NoAcentoCte(SubStr((cAliasDT6)->DES_NOME,1,60)) + '</xNome>'
							EndIf
						EndIf
						If !Empty((cAliasDT6)->DES_TEL)
							cString += '<fone>' + cValtoChar(NoPontos((cAliasDT6)->DES_DDDTEL)) + ;
							cValtoChar(NoPontos((cAliasDT6)->DES_TEL)) + '</fone>'
						EndIf
						If !Empty((cAliasDT6)->DES_SUFRAMA)
							cString += '<ISUF>' + cValtoChar(NoPontos((cAliasDT6)->DES_SUFRAMA)) + '</ISUF>'
						EndIf
						cString += '<enderDest>'
						cString += '<xLgr>' + NoAcentoCte(FisGetEnd((cAliasDT6)->DES_END)[1]) + '</xLgr>'
						cString += '<nro>' + Iif(FisGetEnd((cAliasDT6)->DES_END)[2]<>0, AllTrim(cValtoChar( FisGetEnd((cAliasDT6)->DES_END)[2])),"S/N") + '</nro>'
						If !Empty(NoAcentoCte((cAliasDT6)->DES_CPL))
							cString += '<xCpl>' + NoAcentoCte((cAliasDT6)->DES_CPL) + '</xCpl>'
						EndIf
						If Empty(AllTrim((cAliasDT6)->DES_BAIRRO))
							cString += '<xBairro>BAIRRO NAO CADASTRADO</xBairro>'
						Else
							cString += '<xBairro>' + NoAcentoCte( (cAliasDT6)->DES_BAIRRO ) + '</xBairro>'
						EndIf
						cString += '<cMun>'+ NoAcentoCte( AllTrim(cCodUFDes) + AllTrim((cAliasDT6)->DES_COD_MUN) ) + '</cMun>'
						cString += '<xMun>'+ NoAcentoCte( (cAliasDT6)->DES_MUNICI ) + '</xMun>'
						cString += '<CEP>' + NoAcentoCte( (cAliasDT6)->DES_CEP    ) + '</CEP>'
						cString += '<UF>'  + NoAcentoCte( (cAliasDT6)->DES_UF     ) + '</UF>'
						If !Empty(AllTrim((cAliasDT6)->DES_CBACEN))
							cString += '<cPais>'+ NoAcentoCte( RIGHT((cAliasDT6)->DES_CBACEN ,4 )) + '</cPais>'
							cString += '<xPais>'+ NoAcentoCte( Posicione("CCH",1,xFilial("CCH")+(cAliasDT6)->DES_CBACEN,"CCH_PAIS") ) + '</xPais>'
						Else
							If !Empty(AllTrim((cAliasDT6)->DES_PAIS))
								cString += '<cPais>'+ NoAcentoCte( (cAliasDT6)->DES_PAIS ) + '</cPais>'
								cString += '<xPais>'+ NoAcentoCte( Posicione("SYA",1,xFilial("SYA")+(cAliasDT6)->DES_PAIS,"YA_DESCR") ) + '</xPais>'
							EndIf
						EndIf
						cString += '</enderDest>'
						If !Empty((cAliasDT6)->DES_EMAIL)
							cString += '<email>' + NoAcentoCte(SubStr(AllTrim((cAliasDT6)->DES_EMAIL),1,60)) + '</email>'
						EndIf					
										
						//-- Strings incluidas para envio de email para tomador.
						//-- Necessario incluir SPED_DELMAIL=1 no SERVER.INI do TSS/SPED
						//-- para excluir este conteudo do arquivo XML final.
						If !Empty(cMail)
							cString += '[EMAIL=' + cMail + ']'
						EndIf
						
						cString += '</dest>'
						aAdd(aXMLCTe,AllTrim(cString))
					EndIf //| Termino da Tag </dest>	

					If	AllTrim((cAliasDT6)->DT6_DOCTMS) == StrZero( 8, Len(DT6->DT6_DOCTMS))
						//-- Para TES configurada gerar duplicata = N somente para CTE complemento ICMS / destaque de ICMS.
						cGerDup := "S"
						cAliasTES := GetNextAlias()
						cQuery := " SELECT F4_DUPLIC " + CRLF
						cQuery += "   FROM " + RetSqlName("SD2") + " D2," + RetSqlName("SF4") + " F4 "  + CRLF
						cQuery += "  WHERE D2.D2_FILIAL  = '" + xFilial('SD2') + "'" + CRLF
						cQuery += "    AND D2.D2_DOC     = '" + cNota    + "'" + CRLF
						cQuery += "    AND D2.D2_SERIE   = '" + cSerie   + "'" + CRLF
						cQuery += "    AND D2.D2_CLIENTE = '" + cClieFor + "'" + CRLF
						cQuery += "    AND D2.D2_LOJA    = '" + cLoja    + "'" + CRLF
						cQuery += "    AND D2.D_E_L_E_T_ = ''" + CRLF
						//-- Cadastro de TES
						cQuery += "    AND F4.F4_FILIAL	 = '"  + xFilial('SF4') + "'" + CRLF
						cQuery += "    AND F4.F4_CODIGO	 = D2.D2_TES" + CRLF
						cQuery += "    AND F4.D_E_L_E_T_ =''"
						cQuery := ChangeQuery(cQuery)
						DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasTES, .F., .T.)
						If !(cAliasTES)->(Eof())
							cGerDup := (cAliasTES)->F4_DUPLIC
						EndIf
						(cAliasTES)->(DbCloseArea())
					EndIf

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ TAG: I - Valores da prestacao de servico                        ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If SF3->F3_TIPO != "I"
						cAliasTagI := GetNextAlias()
						cQuery := " SELECT SUM(DOCCOMP.DT8_VALPAS) DT8_VALPAS, " +CRLF
						cQuery += " 		 SUM(DOCCOMP.DT8_VALTOT) DT8_VALTOT, " +CRLF
						cQuery += " 		 COMP.DT3_CODPAS, COMP.DT3_DESCRI " +CRLF
						cQuery += "   FROM " + RetSqlName('DT8') + " DOCCOMP " +CRLF
						cQuery += " 		 INNER JOIN  " + RetSqlName('DT3') + " COMP " +CRLF
						cQuery += " 				   ON ( COMP.DT3_FILIAL='" + xFilial("DT3") + "'" +CRLF
						cQuery += "						AND COMP.DT3_CODPAS = DOCCOMP.DT8_CODPAS " +CRLF
						cQuery += "						AND COMP.D_E_L_E_T_=' ')" +CRLF
						cQuery += "  WHERE DOCCOMP.DT8_FILIAL  = '" + xFilial("DT8") + "'" +CRLF

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Se o tipo de Conhecimento for de Complemento, seleciona as      ³
						//³informacoes do CTR principal, pois o complemento nao tem DTC     ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If !Empty((cAliasDT6)->DT6_DOCDCO) .And. !((cAliasDT6)->DT6_DOCTMS $ "7/6/E/F/8/P") 
							cQuery += "    AND DOCCOMP.DT8_FILDOC  = '" + (cAliasDT6)->DT6_FILDCO  + "'" +CRLF
							cQuery += "    AND DOCCOMP.DT8_DOC     = '" + (cAliasDT6)->DT6_DOCDCO  + "'" +CRLF
							cQuery += "    AND DOCCOMP.DT8_SERIE   = '" + (cAliasDT6)->DT6_SERDCO + "'" +CRLF
						Else
							cQuery += "    AND DOCCOMP.DT8_FILDOC  = '" + AllTrim((cAliasDT6)->DT6_FILDOC)	+ "'" +CRLF
							cQuery += "    AND DOCCOMP.DT8_DOC     = '" + AllTrim((cAliasDT6)->DT6_DOC)	+ "'" +CRLF
							cQuery += "    AND DOCCOMP.DT8_SERIE   = '" + AllTrim((cAliasDT6)->DT6_SERIE)	+ "'" +CRLF
						EndIf

						cQuery += "    AND DOCCOMP.D_E_L_E_T_  = ' '"
						cQuery += "    GROUP BY COMP.DT3_CODPAS, COMP.DT3_DESCRI"
						cQuery := ChangeQuery(cQuery)
						DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasTagI, .F., .T.)

						cString := '<vPrest>'

						cAliasVPrest := GetNextAlias()
					
						cQuery := " SELECT DT6.DT6_VALFRE, DT6.DT6_VALTOT, " + CRLF
						cQuery += "        DT6.DT6_VALFAT  " + CRLF
						cQuery += "  FROM " + RetSqlName('DT6') + " DT6 " + CRLF
						cQuery += "  WHERE DT6.DT6_FILIAL  = '" + xFilial("DT6") + "'" + CRLF
						If AllTrim((cAliasDT6)->DT6_DOCTMS) == "M"
							cQuery += "    AND DT6.DT6_FILDOC  = '" + (cAliasDT6)->DT6_FILDCO + "'" + CRLF
							cQuery += "    AND DT6.DT6_DOC     = '" + (cAliasDT6)->DT6_DOCDCO    + "'" + CRLF
							cQuery += "    AND DT6.DT6_SERIE   = '" + (cAliasDT6)->DT6_SERDCO	  + "'" + CRLF
						Else
							cQuery += "    AND DT6.DT6_FILDOC  = '" + (cAliasDT6)->DT6_FILDOC + "'" + CRLF
							cQuery += "    AND DT6.DT6_DOC     = '" + (cAliasDT6)->DT6_DOC    + "'" + CRLF
							cQuery += "    AND DT6.DT6_SERIE   = '" + (cAliasDT6)->DT6_SERIE  + "'" + CRLF
						EndIf
						cQuery += "    AND DT6.D_E_L_E_T_  = ' '"
						cQuery := ChangeQuery(cQuery)
						DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasVPrest, .F., .T.)
						If SF3->F3_TIPO == "I" //--> Caso seja Complemento de imposto, o valor de prestação será Zerado.						
							
							If lCTEVPRE
								cString += '<vTPrest>' + ConvType((cAliasVPrest)->DT6_VALFRE, 15, 2) + '</vTPrest>'
							Else
								cString += '<vTPrest>' + ConvType((cAliasVPrest)->DT6_VALTOT, 15, 2) + '</vTPrest>'
							EndIf

							
							If !Empty((cAliasDT6)->DT6_DOCTMS)
								cString += '<vRec>'    + ConvType((cAliasVPrest)->DT6_VALFAT, 15, 2) + '</vRec>'
							Else
								cString += '<vRec>'    + ConvType((cAliasDT6)->DT6_VALFAT, 15, 2) + '</vRec>'
							EndIf
						Else
							If !Empty((cAliasDT6)->DT6_DOCTMS)
								If lCTEVPRE
									cString += '<vTPrest>' + ConvType((cAliasVPrest)->DT6_VALFRE, 15, 2) + '</vTPrest>'
								Else
									cString += '<vTPrest>' + ConvType((cAliasVPrest)->DT6_VALTOT, 15, 2) + '</vTPrest>'
								EndIf

								cString += '<vRec>'    + ConvType((cAliasVPrest)->DT6_VALFAT, 15, 2) + '</vRec>'
							Else
								If lCTEVPRE
									cString += '<vTPrest>' + ConvType((cAliasVPrest)->DT6_VALFRE, 15, 2) + '</vTPrest>'
								Else
									cString += '<vTPrest>' + ConvType((cAliasVPrest)->DT6_VALTOT, 15, 2) + '</vTPrest>'
								EndIf

								cString += '<vRec>'    + ConvType((cAliasDT6)->DT6_VALFAT, 15, 2) + '</vRec>'
							EndIf
						EndIf
											
						While !(cAliasTagI)->(Eof())
							cString +='<Comp>'
							cString += '<xNome>' + AllTrim(NoAcentoCte(SubStr((cAliasTagI)->DT3_DESCRI,1,15))) + '</xNome>'
							If lCTEVFRE
								cString += '<vComp>' + ConvType((cAliasTagI)->DT8_VALPAS, 15, 2) + '</vComp>'
							Else
								cString += '<vComp>' + ConvType((cAliasTagI)->DT8_VALTOT, 15, 2) + '</vComp>'
							EndIf
							cString +='</Comp>'
							(cAliasTagI)->(dbSkip())
						EndDo
						
						(cAliasVPrest)->(DbCloseArea())

						cString += '</vPrest>'
						aAdd(aXMLCTe,AllTrim(cString))
					
						(cAliasTagI)->(DbCloseArea())
					Else
						//-- Somente para CTE complemento ICMS / destaque de ICMS -> sem valor prestado.
						cString := '<vPrest>'
						cString += '<vTPrest>' + ConvType(0, 15, 2) + '</vTPrest>'
						cString += '<vRec>'    + ConvType(0, 15, 2) + '</vRec>'
						cString += '</vPrest>'
						aAdd(aXMLCTe,AllTrim(cString))
					EndIf				

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ TAG: J- Informacoes relativas aos Impostos                      ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Incluso as TAGS referentes as modalidades de tributacao do ICMS ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					cAliasTagJ := GetNextAlias()
					cQuery := "SELECT SFT.FT_NFISCAL, SFT.FT_SERIE, SFT.FT_CLASFIS, " + CRLF
					cQuery += "  MAX(SFT.FT_ALIQICM) FT_ALIQICM, " + CRLF
					cQuery += "	 MAX(SFT.FT_ALIQSOL) FT_ALIQSOL, " + CRLF
					cQuery += "  SUM(SFT.FT_BASEICM) FT_BASEICM, " + CRLF
					cQuery += "  SUM(SFT.FT_BASERET) FT_BASERET, " + CRLF
					cQuery += "  SUM(SFT.FT_VALICM)  FT_VALICM,  " + CRLF
					cQuery += "  SUM(SFT.FT_CRPRST)  FT_CRPRST,  " + CRLF
					cQuery += "  SUM(SFT.FT_ICMSRET) FT_ICMSRET, " + CRLF
					cQuery += "  MAX(SD2.D2_ALIQSOL) D2_ALIQSOL, " + CRLF
					cQuery += "  SUM(SD2.D2_BASEICM) D2_BASEICM, " + CRLF 
					cQuery += "  SUM(SD2.D2_VALICM)  D2_VALICM,  " + CRLF
					cQuery += "  MAX(SD2.D2_PICM)  D2_PICM,  " + CRLF
					cQuery += "  SUM(SD2.D2_ICMSRET) D2_ICMSRET  " + CRLF
					cQuery += "  FROM " + RetSqlName('SFT') + " SFT, "+ RetSqlName('SD2') +" SD2   " + CRLF
					cQuery += "  WHERE SFT.FT_FILIAL  = '" + xFilial('SFT') + "'" + CRLF
					If AllTrim((cAliasDT6)->DT6_DOCTMS) == "M"
						cQuery += " AND SFT.FT_NFISCAL = '" + (cAliasDT6)->DT6_DOCDCO + "'" + CRLF
						cQuery += " AND SFT.FT_SERIE   = '" + (cAliasDT6)->DT6_SERDCO + "'" + CRLF
					Else
						cQuery += " AND SFT.FT_NFISCAL = '" + (cAliasDT6)->DT6_DOC   + "'" + CRLF
						cQuery += " AND SFT.FT_SERIE   = '" + (cAliasDT6)->DT6_SERIE + "'" + CRLF
					EndIf
					cQuery += " AND SFT.FT_CLIEFOR = '" + (cAliasDT6)->DT6_CLIDEV + "'" + CRLF
					cQuery += " AND SFT.FT_LOJA    = '" + (cAliasDT6)->DT6_LOJDEV + "'" + CRLF
					cQuery += " AND SFT.D_E_L_E_T_ = ' '" + CRLF
					cQuery += " AND SD2.D2_FILIAL  = '" + xFilial('SD2') + "'" + CRLF
					If AllTrim((cAliasDT6)->DT6_DOCTMS) == "M"
						cQuery += " AND SD2.D2_DOC   = SFT.FT_NFISCAL " + CRLF
						cQuery += " AND SD2.D2_SERIE = SFT.FT_SERIE   " + CRLF
					Else
						cQuery += " AND SD2.D2_DOC   = SFT.FT_NFISCAL " + CRLF
						cQuery += " AND SD2.D2_SERIE = SFT.FT_SERIE   " + CRLF
					EndIf
					cQuery += " AND SD2.D2_CLIENTE = SFT.FT_CLIEFOR " + CRLF
					cQuery += " AND SD2.D2_LOJA    = SFT.FT_LOJA    " + CRLF
					cQuery += " AND SD2.D2_ITEM    = SFT.FT_ITEM    " + CRLF
					cQuery += " AND SD2.D_E_L_E_T_ = ' '" + CRLF
					cQuery += " GROUP BY SFT.FT_NFISCAL, SFT.FT_SERIE, SFT.FT_CLASFIS "
					cQuery += " ORDER BY SFT.FT_NFISCAL, SFT.FT_SERIE, SFT.FT_CLASFIS "
					cQuery := ChangeQuery(cQuery)
					DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasTagJ, .F., .T.)
					cString := '<imp>'
					cString += '<ICMS>'
					nCount := 0
					While !(cAliasTagJ)->(Eof())
						nCount++
						If (cAliasTagJ)->FT_VALICM > 0
							nBASEICM := (cAliasTagJ)->FT_BASEICM
							nALIQICM := (cAliasTagJ)->FT_ALIQICM
							nVALICM  := (cAliasTagJ)->FT_VALICM
							nALIQSOL := (cAliasTagJ)->FT_ALIQSOL
							nICMSRET := (cAliasTagJ)->FT_ICMSRET
                      Else
							nBASEICM := (cAliasTagJ)->D2_BASEICM
							nALIQICM := (cAliasTagJ)->D2_PICM
							nVALICM  := (cAliasTagJ)->D2_VALICM
							nALIQSOL := (cAliasTagJ)->D2_ALIQSOL
							nICMSRET := (cAliasTagJ)->D2_ICMSRET
						EndIf 
						
						If (cAliasTagJ)->FT_BASERET > 0
							nBASICMRET 	:= (cAliasTagJ)->FT_BASERET
							nALIQSOL 	:= (cAliasTagJ)->FT_ALIQSOL
							nICMSRET	:= (cAliasTagJ)->FT_ICMSRET  
							nCREDPRES	:= (cAliasTagJ)->FT_CRPRST  
						EndIf				
						
						//-- CT-e complemento ICMS campos preenchidos somente para permitir a validacao do CT-e
						If (cAliasDT6)->DT6_DOCTMS == "8" .And. nBASEICM == 0 .And. nALIQICM == 0 .And. nVALICM > 0
							nBASEICM := nVALICM
							nALIQICM := 100
						EndIf
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Informacoes relativas ao ICMS   ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If nCount == 1
							If cMVSINAC == '1'
							//--Simples Nacional(MV_CODREG == 1)
								cString += '<ICMSSN>'
								cString += '<CST>90</CST>'
								cString += '<indSN>1</indSN>'							 
								cString += '</ICMSSN>'						
							ElseIf SubStr((cAliasTagJ)->FT_CLASFIS, 2, 2) == '00' 
								cString += '<ICMS00>'
								cString += '<CST>00</CST>'
								cString += '<vBC>'  + ConvType(nBASEICM, 15, 2) + '</vBC>'
								cString += '<pICMS>'+ ConvType(nALIQICM,  6, 2) + '</pICMS>'
								cString += '<vICMS>'+ ConvType(nVALICM , 15, 2) + '</vICMS>'
								cString += '</ICMS00>'						
							ElseIf SubStr((cAliasTagJ)->FT_CLASFIS, 2, 2) $ "40,41,51"
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ ICMS Isento, nao Tributado ou dIferido  ³
								//³ - 40: ICMS Isencao                      ³
								//³ - 41: ICMS Nao Tributada                ³
								//³ - 51: ICMS DIferido                     ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								cString += '<ICMS45>'
								If SubStr((cAliasTagJ)->FT_CLASFIS, 2, 2)  == '40'
									cString += '<CST>40</CST>'
								ElseIf SubStr((cAliasTagJ)->FT_CLASFIS, 2, 2) == '41'
									cString += '<CST>41</CST>'
								ElseIf SubStr((cAliasTagJ)->FT_CLASFIS, 2, 2) == '51'
									cString += '<CST>51</CST>'
								EndIf
								cString += '</ICMS45>'
							ElseIf SubStr((cAliasTagJ)->FT_CLASFIS, 2, 2) == "60"
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ - 60: ICMS cobrado por substituição tributária.                 ³
								//³ Responsabilidade do recolhimento do ICMS atribuído              ³
								//³ ao tomadorou 3o por ST.                                         ³
								//³ CST60 - ICMS cobrado anteriormente por substituicao tributaria  ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								cString += '<ICMS60>'
								//-- ICMS cobrado anteriormente por substituicao tributaria
								cString += '<CST>60</CST>'
								cString += '<vBCSTRet>'  + ConvType(nBASICMRET, 15, 2) + '</vBCSTRet>'
								cString += '<vICMSSTRet>'+ ConvType(nICMSRET + nCREDPRES , 15, 2) + '</vICMSSTRet>'
								cString += '<pICMSSTRet>'+ ConvType(nALIQSOL,  6, 2) + '</pICMSSTRet>'
								cString += '<vCred>'     + ConvType(nCREDPRES, 15, 2) + '</vCred>'
								cString += '</ICMS60>'
							ElseIf SubStr((cAliasTagJ)->FT_CLASFIS, 2, 2) $ "10,30,70"
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ - 80: ICMS pagto atribuido ao tomador ou ao 3o previsto para    ³
								//³ substituicao tributaria                                         ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								cString += '<ICMS90>'
								cString += '<CST>90</CST>'
								If !Empty(cpRedBC)
									cString += '<pRedBC>' + ConvType(cpRedBC, 5, 2) + '</pRedBC>'
								EndIf
								cString += '<vBC>'    + ConvType(nBASEICM, 15, 2) + '</vBC>'
								cString += '<pICMS>'  + ConvType(nALIQICM,  6, 2) + '</pICMS>'
								cString += '<vICMS>'  + ConvType(nVALICM , 15, 2) + '</vICMS>'
								cString += '<vCred>'  + ConvType(nVcred  , 15, 2) + '</vCred>'
								cString += '</ICMS90>'
							ElseIf SubStr((cAliasTagJ)->FT_CLASFIS, 2, 2) $ '20,90' .And. !(AllTrim(cCFOP) $ "5932,6932")
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ - 81: ICMS DEVIDOS A OUTRAS UF'S                                ³
								//³ - 90: ICMS Outros                                               ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								If SubStr((cAliasTagJ)->FT_CLASFIS, 2, 2) == '20'
									cString += '<ICMS20>'
									cString += '<CST>20</CST>'
									If !Empty(cpRedBC)
										cString += '<pRedBC>' + ConvType(cpRedBC, 5, 2) + '</pRedBC>'
									EndIf
									cString += '<vBC>'  + ConvType(nBASEICM, 15, 2) + '</vBC>'
									cString += '<pICMS>'+ ConvType(nALIQICM,  6, 2) + '</pICMS>'
									cString += '<vICMS>'+ ConvType(nVALICM , 15, 2) + '</vICMS>'
									cString += '</ICMS20>'
								Else
									If SubStr((cAliasTagJ)->FT_CLASFIS, 2, 2) == '90'
										cString += '<ICMS90>'
									Else
										cString += '<CST81>'
									EndIf
									cString += '<CST>90</CST>'
									If !Empty(cpRedBC)
										cString += '<pRedBC>' + ConvType(cpRedBC, 5, 2) + '</pRedBC>'
									EndIf
									cString += '<vBC>'    + ConvType(nBASEICM, 13, 2) + '</vBC>'
									cString += '<pICMS>'  + ConvType(nALIQICM,  6, 2) + '</pICMS>'
									cString += '<vICMS>'  + ConvType(nVALICM , 13, 2) + '</vICMS>'
									cString += '<vCred>'  + ConvType(nICMSRET, 15, 2) + '</vCred>'
									If SubStr((cAliasTagJ)->FT_CLASFIS, 2, 2) == '90'
										cString += '</ICMS90>'
									Else
										cString += '</CST81>'
									EndIf
								EndIf
							ElseIf SubStr((cAliasTagJ)->FT_CLASFIS, 2, 2) $ '20,90' .And. AllTrim(cCFOP) $ "5932,6932"
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ - 81: ICMS DEVIDOS A OUTRAS UF'S                                ³
								//³ - 90: ICMS Outros                                               ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								cString += '<ICMSOutraUF>'
								cString += '<CST>90</CST>'
								If !Empty(cpRedBC)
									cString += '<pRedBCOutraUF>' + ConvType(cpRedBC, 5, 2) + '</pRedBCOutraUF>'
								EndIf
								cString += '<vBCOutraUF>'    + ConvType(nBASEICM	, 13, 2) + '</vBCOutraUF>'
								cString += '<pICMSOutraUF>'  + ConvType(nALIQICM	,  6, 2) + '</pICMSOutraUF>'
								cString += '<vICMSOutraUF>'  + ConvType(nVALICM  , 13, 2) + '</vICMSOutraUF>'
								cString += '</ICMSOutraUF>'
							EndIf
						EndIf //-- If nCount == 1

						(cAliasRBC)->(dbSkip())
						(cAliasTagJ)->(dbSkip())
						
					EndDo
					(cAliasRBC)->(DbCloseArea())
					(cAliasTagJ)->(DbCloseArea())

					cString += '</ICMS>'
					//-- Valor Total dos impostos - Lei da Transparencia
					If !Empty(SF2->F2_TOTIMP)
						cString += '<vTotTrib>' + ConvType(SF2->F2_TOTIMP, 13, 2) + '</vTotTrib>'
					Else
						cString += '<vTotTrib>' + ConvType((cAliasDT6)->DT6_VALIMP, 13, 2) + '</vTotTrib>'
					EndIf
					//-- Observações das regras de Tributação (campo Memo)
					DbSelectArea("DT6")
					cObs := StrTran(MsMM((cAliasDT6)->DT6_CODMSG),Chr(13),"")
					If !Empty(cObs)
						cString +=  '<infAdFisco>' + NoAcentoCte(SubStr(cObs,1,320)) + '</infAdFisco>'
					EndIf
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ TAG:  Informacoes relativas ICMS para a UF de término da `     //
					// prestação do serviço de transporte nas operações interestaduais //
					// para consumidor final  Emenda Constitucional 87 de 2015.        //
					// Nota Técnica 2015/003 e 2015/004                                //
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
					If !lContrib   //-- Não Contribuinte e Campo Difal
						cString += '<ICMSUFFim>'						
						cString += '<vBCUFFim>'   		+ ConvType(nBCICMS,  15, 2) + '</vBCUFFim>'
						cString += '<pFCPUFFim>'  		+ ConvType(nPERFCP,   5, 2) + '</pFCPUFFim>'
						cString += '<pICMSUFFim>' 		+ ConvType(nALQTER,   5, 2) + '</pICMSUFFim>'
						cString += '<pICMSInter>' 		+ ConvType(nALQINT,   5, 2) + '</pICMSInter>'
						If !lMOC300A
							cString += '<pICMSInterPart>'	+   cvaltochar(nPEDDES)     + '</pICMSInterPart>'
						EndIf
						cString += '<vFCPUFFim>' 		+ ConvType(nVALFCP,  15, 2) + '</vFCPUFFim>'
						cString += '<vICMSUFFim>'  		+ ConvType(nVALDES,  15, 2) + '</vICMSUFFim>'
						cString += '<vICMSUFIni>' 		+ ConvType(nVLTRIB,  15, 2) + '</vICMSUFIni>'							
						cString += '</ICMSUFFim>'									
					EndIf				
					
					cString += '</imp>'
					aAdd(aXMLCTe,AllTrim(cString))
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ TAG: K - Informacoes de CT-e Normal                             ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If	!AllTrim((cAliasDT6)->DT6_DOCTMS) == StrZero( 8, Len(DT6->DT6_DOCTMS)) .And.;
						!AllTrim((cAliasDT6)->DT6_DOCTMS) == "M"
						
						cString := '<infCTeNorm>'
						cAliasAll := GetNextAlias()
						cQuery    := " SELECT DB0.DB0_TIPCAR" + CRLF
						cQuery    += "   FROM " +	RetSqlName("SB1") + " SB1 " + CRLF
						cQuery    += "        INNER JOIN " + RetSqlName("DB0") + " DB0 " + CRLF
						cQuery    += "                ON DB0.DB0_FILIAL = '"  + xFilial("DB0")	+ "'" + CRLF
						cQuery    += "               AND DB0.DB0_CODMOD = SB1.B1_TIPCAR " + CRLF
						cQuery    += "               AND DB0.D_E_L_E_T_ = ' ' " + CRLF
						cQuery    += "  WHERE SB1.B1_FILIAL  = '" + xFilial("SB1")	+ "'" + CRLF
						cQuery    += "               AND SB1.B1_COD = '" + cCodPred + "'" + CRLF
						cQuery    += "               AND SB1.D_E_L_E_T_ = ' '" + CRLF
						cQuery    := ChangeQuery(cQuery)
						DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasAll, .F., .T.)
						
						cString += '<infCarga>'
						//-- Produto predominante.
						cString += '<vCarga>'   + ConvType((cAliasDT6)->DT6_VALMER, 15, 2) + '</vCarga>'
						cString += '<proPred>' + NoAcentoCte( cProdPred ) + '</proPred>'
						If !Empty((cAliasAll)->DB0_TIPCAR)
							cString += '<xOutCat>' + NoAcentoCte( FWGetSX5('DU',PadR((cAliasAll)->DB0_TIPCAR, TamSX3("X5_CHAVE")[1]))[1][4] ) + '</xOutCat>'
						EndIf
						(cAliasAll)->(DbCloseArea())
						
						//-- Caracteristica de todos os produtos.
						//-- DTC_PESO - KG
						cString += '<infQ>'
						cString += '<cUnid>' + '01' + '</cUnid>'
						cString += '<tpMed>' + 'PESO DECLARADO' + '</tpMed>'
						cString += '<qCarga>' + ConvType(aCarga[1], 15, 4) + '</qCarga>'
						cString += '</infQ>'
						
						cString += '<infQ>'
						cString += '<cUnid>' + '01' + '</cUnid>'
						cString += '<tpMed>' + 'PESO BASE DE CALCULO' + '</tpMed>'
						cString += '<qCarga>' +  ConvType((cAliasDT6)->DT6_PESCOB, 15, 4) + '</qCarga>'
						cString += '</infQ>'

						//-- PESO AFERIDO = PESOM3
						cString += '<infQ>'
						cString += '<cUnid>' + '01' + '</cUnid>'
						cString += '<tpMed>' + 'PESO AFERIDO' + '</tpMed>'
						cString += '<qCarga>' + ConvType(aCarga[2], 15, 4) + '</qCarga>'
						cString += '</infQ>'
						
						//-- DTC_PESOM3 - M3
						cString += '<infQ>'
						cString += '<cUnid>' + '01' + '</cUnid>'
						cString += '<tpMed>' + 'PESO CUBADO' + '</tpMed>'
						cString += '<qCarga>' + ConvType(aCarga[2], 15, 4) + '</qCarga>'
						cString += '</infQ>'
						
						//-- DT6_METRO3 - M3
						cString += '<infQ>'
						cString += '<cUnid>' + '00' + '</cUnid>'
						cString += '<tpMed>' + 'METROS CUBICOS' + '</tpMed>'
						cString += '<qCarga>' + ConvType(aCarga[3], 15, 4) + '</qCarga>'
						cString += '</infQ>'
						
						//-- DTC_QTDVOL - UNI
						cString += '<infQ>'
						If AllTrim(aCarga[5]) == 'L'
							cString += '<cUnid>' + '04' + '</cUnid>'
							cString += '<tpMed>' + 'LITRAGEM' + '</tpMed>'
						Else
							cString += '<cUnid>' + '03' + '</cUnid>'
							cString += '<tpMed>' + 'VOLUME' + '</tpMed>'
						EndIf
						cString += '<qCarga>' + ConvType(aCarga[4], 15, 4) + '</qCarga>'
						cString += '</infQ>'
						
						aCarga := {0,0,0,0,""}							
						
						If (cAliasDT6)->DT6_VALMER > 0
							cString += '<vCargaAverb>' + ConvType((cAliasDT6)->DT6_VALMER, 15, 2) + '</vCargaAverb>'	
						EndIf
						
						cString += '</infCarga>'
						aAdd(aXMLCTe,AllTrim(cString))
						cString :='' 
						
						If !(cTipoNF $ '8/9/A')  
							If !Empty(cString20)
								cString20 := '<infDoc>' + cString20 +'</infDoc>'
								aAdd(aXMLCTe,AllTrim(cString20))
								cString20 :=''					
							EndIf

							If !Empty(cStringCh)						
								cStringCh := '<infDoc>' + cStringCh +'</infDoc>'
								aAdd(aXMLCTe,AllTrim(cStringCh))
								cStringCh :=''	
							EndIf

							If !Empty(cStringOut)						
								cStringOut := '<infDoc>' + cStringOut +'</infDoc>'
								aAdd(aXMLCTe,AllTrim(cStringOut))
								cStringOut :=''	
							EndIf
						EndIf
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ TAG:  Informacao dos Documentos de Transporte Anterior          ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If (cTipoNF $ '5/2/9/A') .And. (!Empty(cCtrDpc) .Or. !Empty(cCTEDocAnt))
							cString += '<docAnt>'
							cAliasDTC   := GetNextAlias()
							cQuery := ""	                        
							cQuery += " SELECT DISTINCT DTC.DTC_CTEANT, SA1.A1_CGC, SA1.A1_INSCR, SA1.A1_EST, SA1.A1_CONTRIB, SA1.A1_NOME, SA1.A1_PESSOA "
							cQuery += " FROM " + RetSqlName ("DTC")      + " DTC, " + RetSqlName ("SA1")      + " SA1 "

							cQuery += " WHERE DTC.DTC_FILIAL = '" + xFilial ("DTC")+ "' "
							cQuery += " AND DTC.DTC_FILDOC   = '" + If( Empty( (cAliasDT6)->DT6_FILDCO), (cAliasDT6)->DT6_FILDOC,	(cAliasDT6)->DT6_FILDCO ) + "' "
							cQuery += " AND DTC.DTC_DOC      = '" + If( Empty( (cAliasDT6)->DT6_DOCDCO), (cAliasDT6)->DT6_DOC,		(cAliasDT6)->DT6_DOCDCO ) + "' "
							cQuery += " AND DTC.DTC_SERIE    = '" + If( Empty( (cAliasDT6)->DT6_SERDCO), (cAliasDT6)->DT6_SERIE,	(cAliasDT6)->DT6_SERDCO ) + "' "
							cQuery += " AND DTC.D_E_L_E_T_   = ' ' "

							cQuery += " AND SA1.A1_FILIAL    = '" + xFilial ("SA1") + "' "
							cQuery += " AND SA1.D_E_L_E_T_   = ' '  "
							If Empty(cCTEDocAnt)
								cQuery += " AND SA1.A1_COD   = '" + (cAliasDT6)->DT6_CLIDEV + "' "
								cQuery += " AND SA1.A1_LOJA  = '" + (cAliasDT6)->DT6_LOJDEV + "' "
							Else
								cQuery += " AND SA1.A1_CGC       = SUBSTRING(DTC_CTEANT, 7, 14) "
							EndIf
							cQuery += " AND SA1.A1_MSBLQL    <> '1' "
							cQuery += " ORDER BY SA1.A1_CGC "
							
							cQuery := ChangeQuery(cQuery)
							dbUseArea( .T., "TOPCONN", TCGENQRY(, ,cQuery), cAliasDTC, .F., .T.)

							aAreaSA1 := SA1->(GetArea())
							SA1->(DbSetOrder(3))

							While (cAliasDTC)->(!Eof())  
								If (cAliasDTC)->A1_CGC <> cCGCRdp
									cString += '<emiDocAnt>'
									nEmiDocAnt ++
									If (AllTrim((cAliasDTC)->A1_PESSOA) == "J")
										cString += '<CNPJ>'	+ IIf((cAliasDTC)->A1_EST <> 'EX',NoAcentoCte( (cAliasDTC)->A1_CGC ),StrZero(0,14)) + '</CNPJ>'
									Else
										cString += '<CPF>'	+ IIf((cAliasDTC)->A1_EST <> 'EX',NoAcentoCte( (cAliasDTC)->A1_CGC ),StrZero(0,14)) + '</CPF>'
									EndIf
									If Empty((cAliasDTC)->A1_INSCR) .Or. 'ISENT' $ Upper(AllTrim((cAliasDTC)->A1_INSCR)) .Or. ((cAliasDTC)->A1_CONTRIB) =='1' .And. 'ISENT' $ Upper(AllTrim((cAliasDTC)->A1_INSCR))
										cString += '<IE>ISENTO</IE>'
									Else
										cString += '<IE>' + NoPontos((cAliasDTC)->A1_INSCR) + '</IE>'
									EndIf
									cString += '<UF>' + NoAcentoCte( (cAliasDTC)->A1_EST ) + '</UF>'
									cString += '<xNome>' + NoAcentoCte(SubStr((cAliasDTC)->A1_NOME,1,60)) + '</xNome>'
									
									cString += '<idDocAnt>'
									nIdDocAnt ++
									cCGCRdp := (cAliasDTC)->A1_CGC
								EndIf

								/*Tipo do Documento de Transporte Anterior
								07 - ATRE;
								08 - DTA (Despacho de Transito Aduaneiro);
								09 - Conhecimento Aéreo Internacional;
								10 – Conhecimento - Carta de Porte Internacional;
								11 – Conhecimento Avulso;
								12 - TIF (Transporte Internacional Ferroviário); 
								13 - BL (Bill of Lading)*/
								
								If Empty(cCTEDocAnt)
									cString += '<idDocAntPap>'
									If cTpDocAnt == '1'
										cString += '<tpDoc>07</tpDoc>'
									ElseIf cTpDocAnt == '2'
										cString += '<tpDoc>08</tpDoc>'
									ElseIf cTpDocAnt == '3'
										cString += '<tpDoc>09</tpDoc>'
									ElseIf cTpDocAnt == '4'
										cString += '<tpDoc>10</tpDoc>'
									ElseIf cTpDocAnt == '5'
										cString += '<tpDoc>11</tpDoc>'
									ElseIf cTpDocAnt == '6'
										cString += '<tpDoc>12</tpDoc>'
									ElseIf cTpDocAnt == '7'
										cString += '<tpDoc>13</tpDoc>'
									EndIf
									
									cString += '<serie>' + cSerDpc   + '</serie>'
									cString += '<nDoc>'  + cCtrDpc   + '</nDoc>'
									cString += '<dEmi>'  + cDtEmi    + '</dEmi>'
									cString += '</idDocAntPap>'
								Else
									cString += '<idDocAntEle>'
									cString += '<chCTe>' + (cAliasDTC)->DTC_CTEANT + '</chCTe>'
									cString += '</idDocAntEle>'
								EndIf                       

								(cAliasDTC)->(DbSkip())									
								
								If  (cAliasDTC)->A1_CGC <> cCGCRdp
									cString += '</idDocAnt>'
									cString += '</emiDocAnt>'
									nFDocAnt ++
									nFEmDcAnt ++
								EndIf
							
							EndDo

							If nIdDocAnt > nFDocAnt
								cString += '</idDocAnt>'
								nIdDocAnt := 0
								nFDocAnt := 0
							EndIf

							If nEmiDocAnt > nFEmDcAnt
								cString += '</emiDocAnt>'
								nEmiDocAnt := 0
								nFEmDcAnt := 0
							EndIf

							cString += '</docAnt>'
							(cAliasDTC)->( DbCloseArea() )	
						
						EndIf
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ TAG: M - Dados Especificos do Modal Rodoviario                  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						//Verifica se possui viagem para verificar se a mesma se trata de lotação.
						cString += '<infModal versaoModal="'+cVerAmb+'">'
						If (cAliasDT6)->DT6_TIPTRA = '6'
							If DTC->(ColumnPos("DTC_INDNEG")) > 0
						    	cAliasDTC   := GetNextAlias()
								cQuery := ""	                        
								cQuery += " SELECT DTC.DTC_INDNEG " + CRLF
								cQuery += " FROM " + RetSqlName ("DTC")      + " DTC " + CRLF
								cQuery += " WHERE DTC.DTC_FILIAL = '" + xFilial ("DTC")+ "' " + CRLF
								cQuery += " AND DTC.DTC_FILDOC   = '" + (cAliasDT6)->DT6_FILDOC + "' " + CRLF 
								cQuery += " AND DTC.DTC_DOC      = '" + (cAliasDT6)->DT6_DOC + "' " + CRLF 
								cQuery += " AND DTC.DTC_SERIE    = '" + (cAliasDT6)->DT6_SERIE + "' " + CRLF 
								cQuery += " AND DTC.D_E_L_E_T_   = ' ' " + CRLF 	                       
								cQuery := ChangeQuery(cQuery)
								dbUseArea( .T., "TOPCONN", TCGENQRY(, ,cQuery), cAliasDTC, .F., .T.)
	
								cString += '<multimodal>'
								cString += '<COTM>' + SubStr(AllTrim(cTmsCOTM),1,9) + '</COTM>'
								cString += '<indNegociavel>' + (cAliasDTC)->DTC_INDNEG + '</indNegociavel>'
								cString += '</multimodal>'
								(cAliasDTC)->( DbCloseArea() )
							EndIf
						Else
							cString += '<rodo>'
							If !Empty(cTmsAntt)
								cString += '<RNTRC>' + SubStr(AllTrim(cTmsAntt),1,8) + '</RNTRC>'
							Else
								cString += '<RNTRC>ISENTO</RNTRC>'
							EndIf
							cString += '</rodo>'
						EndIf
						cString += '</infModal>'
						
						If AllTrim((cAliasDT6)->DT6_DOCTMS) == "P"
							
							lAlteraToma		:= TrocaToma( (cAliasDT6)->DT6_FILDCO, (cAliasDT6)->DT6_DOCDCO , (cAliasDT6)->DT6_SERDCO ,  (cAliasDT6)->DT6_CLIDEV , (cAliasDT6)->DT6_LOJDEV  )
							
							cString += '<infCteSub>'
							
							//-- Query para pesquisar a chave do CTE original
							cAliasChv :=  GetNextAlias()
							cQuery := " SELECT DT6.DT6_CHVCTE " +CRLF
							cQuery += "   FROM " + RetSqlName('DT6') + " DT6 " +CRLF
							cQuery += "  WHERE DT6.DT6_FILIAL = '" + xFilial('DT6') + "'" +CRLF
							cQuery += "    AND DT6.DT6_FILDOC = '" + (cAliasDT6)->DT6_FILDCO + "'" +CRLF
							cQuery += "    AND DT6.DT6_DOC    = '" + (cAliasDT6)->DT6_DOCDCO + "'" +CRLF
							cQuery += "    AND DT6.DT6_SERIE  = '" + (cAliasDT6)->DT6_SERDCO + "'" +CRLF
							cQuery += "    AND DT6.D_E_L_E_T_ = ' '"
							cQuery := ChangeQuery(cQuery)
							DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasChv, .F., .T.)
							//-- Chave do Cte Original
							If (!(cAliasChv)->(Eof()))
								cString += '<chCte>' + (cAliasChv)->DT6_CHVCTE + '</chCte>'
							EndIf
							(cAliasChv)->(DbCloseArea())												

							If lAlteraToma
								cString	+= '<indAlteraToma>' + '1' + '</indAlteraToma>'
							EndIf
																
							cString += '</infCteSub>'
							
						EndIf
						
						If (cTipoNF $ '8/A') .And. !Empty(cCTEDocAnt)
							cAliasDTC   := GetNextAlias()
							cQuery := ""	                        
							cQuery += " SELECT DISTINCT DTC.DTC_CTEANT, SA1.A1_CGC " + CRLF
							cQuery += " FROM " + RetSqlName ("DTC")      + " DTC, " + RetSqlName ("SA1")      + " SA1 " + CRLF

							cQuery += " WHERE DTC.DTC_FILIAL = '" + xFilial ("DTC")+ "' " + CRLF
							cQuery += " AND DTC.DTC_FILDOC   = '" + IIf(empty((cAliasDT6)->DT6_FILDCO),(cAliasDT6)->DT6_FILDOC,(cAliasDT6)->DT6_FILDCO) + "' " + CRLF 
							cQuery += " AND DTC.DTC_DOC      = '" + IIf(empty((cAliasDT6)->DT6_DOCDCO),(cAliasDT6)->DT6_DOC   ,(cAliasDT6)->DT6_DOCDCO) + "' " + CRLF 
							cQuery += " AND DTC.DTC_SERIE    = '" + IIf(empty((cAliasDT6)->DT6_SERDCO),(cAliasDT6)->DT6_SERIE ,(cAliasDT6)->DT6_SERDCO) + "' " + CRLF 
							cQuery += " AND DTC.D_E_L_E_T_   = ' ' " + CRLF 

							cQuery += " AND SA1.A1_FILIAL    = '" + xFilial ("SA1")+ "' " + CRLF
							cQuery += " AND SA1.D_E_L_E_T_   = ' '  " + CRLF
							cQuery += " AND SA1.A1_CGC       = SUBSTRING(DTC_CTEANT, 7, 14) " + CRLF
							cQuery += " AND SA1.A1_MSBLQL    <> '1' " + CRLF
							cQuery += " ORDER BY SA1.A1_CGC " + CRLF
							
							cQuery := ChangeQuery(cQuery)
							dbUseArea( .T., "TOPCONN", TCGENQRY(, ,cQuery), cAliasDTC, .F., .T.)

							cString += '<infServVinc>'
							While (cAliasDTC)->(!Eof())  
								cString += '<infCTeMultimodal>' 
								cString += '<chCTeMultimodal>' + (cAliasDTC)->DTC_CTEANT + '</chCTeMultimodal>'
								cString += '</infCTeMultimodal>'
								(cAliasDTC)->(DBSkip())								
							EndDo
							cString += '</infServVinc>'
							(cAliasDTC)->( DbCloseArea() )
						EndIf
						cString += '</infCTeNorm>'

						aAdd(aXMLCTe,AllTrim(cString))
					EndIf

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ TAG: O - CT-e Complementar                                      ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If AllTrim((cAliasDT6)->DT6_DOCTMS) == StrZero( 8, Len(DT6->DT6_DOCTMS))

						cString := '<infCteComp>'

						//-- Query para pesquisar a chave do CTE original
						cAliasChv :=  GetNextAlias()
						cQuery := " SELECT DT6.DT6_CHVCTE, DT6.DT6_VALFRE, DT6.DT6_VALTOT " + CRLF
						cQuery += "   FROM " + RetSqlName('DT6') + " DT6 " + CRLF
						cQuery += "  WHERE DT6.DT6_FILIAL = '" + xFilial('DT6') + "'" + CRLF
						cQuery += "    AND DT6.DT6_FILDOC = '" + (cAliasDT6)->DT6_FILDCO + "'" + CRLF
						cQuery += "    AND DT6.DT6_DOC    = '" + (cAliasDT6)->DT6_DOCDCO + "'" + CRLF
						cQuery += "    AND DT6.DT6_SERIE  = '" + (cAliasDT6)->DT6_SERDCO + "'" + CRLF
						cQuery += "    AND DT6.D_E_L_E_T_ = ' '"
						cQuery := ChangeQuery(cQuery)
						DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasChv, .F., .T.)
						//-- Chave do Cte Original
						If (!(cAliasChv)->(Eof()))
							cString += '<chCTe>' + (cAliasChv)->DT6_CHVCTE + '</chCTe>'							
						EndIf
						(cAliasChv)->(DbCloseArea())
						cString += '</infCteComp>'
						aAdd(aXMLCTe,AllTrim(cString))
					EndIf

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ TAG: P - CT-e do Tipo Anulacao de Valores                       ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If AllTrim((cAliasDT6)->DT6_DOCTMS) == "M"
						//-- Query para pesquisar a chave do CTE original
						cAliasChv :=  GetNextAlias()
						cQuery := ''
						cQuery += " SELECT DT6.DT6_CHVCTE " +CRLF
						cQuery += "   FROM " + RetSqlName('DT6') + " DT6 " +CRLF
						cQuery += "  WHERE DT6.DT6_FILIAL = '" + xFilial('DT6') + "'" +CRLF
						cQuery += "    AND DT6.DT6_FILDOC = '" + (cAliasDT6)->DT6_FILDCO + "'" +CRLF
						cQuery += "    AND DT6.DT6_DOC    = '" + (cAliasDT6)->DT6_DOCDCO + "'" +CRLF
						cQuery += "    AND DT6.DT6_SERIE  = '" + (cAliasDT6)->DT6_SERDCO + "'" +CRLF
						cQuery += "    AND DT6.D_E_L_E_T_ = ' '"
						cQuery := ChangeQuery(cQuery)
						DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasChv, .F., .T.)
						cString := '<infCteAnu>'
						//-- Chave do Cte Original
						If (!(cAliasChv)->(Eof()))
							cString += '<chCte>' + (cAliasChv)->DT6_CHVCTE + '</chCte>'
						EndIf
						(cAliasChv)->(DbCloseArea())
						cString += '<dEmi>'+ SubStr(AllTrim((cAliasDT6)->DT6_DATEMI), 1, 4) + "-";
						+ SubStr(AllTrim((cAliasDT6)->DT6_DATEMI), 5, 2) + "-";
						+ SubStr(AllTrim((cAliasDT6)->DT6_DATEMI), 7, 2) + '</dEmi>'						
						cString += '</infCteAnu>'
						aAdd(aXMLCTe,AllTrim(cString))
					EndIf					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Chave auxiliar para contigencia                                  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If	cModalidade == IIf(lUsaColab,'5','7')
						cAliasCTG := GetNextAlias()
						cQuery := " SELECT F4.F4_ICM,     " + CRLF
						cQuery += "        F4.F4_STDESC,  " + CRLF
						cQuery += "        DT6.DT6_VALTOT," + CRLF
						cQuery += "        DT6.DT6_DATEMI " + CRLF
						cQuery += "   FROM " + RetSqlName("SD2") + " D2," + RetSqlName("SF4") + " F4, "  + RetSqlName("DT6") + " DT6 "  + CRLF
						cQuery += "  WHERE D2.D2_FILIAL   = '" + xFilial('SD2') + "'" + CRLF
						cQuery += "    AND D2.D2_DOC      = '" + cNota    + "'" + CRLF
						cQuery += "    AND D2.D2_SERIE    = '" + cSerie   + "'" + CRLF
						cQuery += "    AND D2.D2_CLIENTE  = '" + cClieFor + "'" + CRLF
						cQuery += "    AND D2.D2_LOJA     = '" + cLoja    + "'" + CRLF
						cQuery += "    AND D2.D_E_L_E_T_  = ' '" + CRLF
						cQuery += "    AND F4.F4_FILIAL   = '" + xFilial('SF4') + "'" + CRLF
						cQuery += "    AND F4.F4_CODIGO   = D2.D2_TES" + CRLF
						cQuery += "    AND F4.D_E_L_E_T_  = ' '"
						cQuery += "    AND DT6.DT6_FILIAL = '" + xFilial('DT6') + "'" + CRLF
						cQuery += "    AND DT6.DT6_FILDOC = '" + cFilAnt   + "'" + CRLF
						cQuery += "    AND DT6.DT6_DOC    = '" + cNota   + "'" + CRLF
						cQuery += "    AND DT6.DT6_SERIE  = '" + cSerie  + "'" + CRLF
						cQuery += "    AND DT6.D_E_L_E_T_ = ' '"
						cQuery := ChangeQuery(cQuery)
						DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasCTG, .F., .T.)
						VALTOT:= padL(Alltrim(str(round(noround((cAliasCTG)->DT6_VALTOT,3),2)*100)),14,'0')
						cChvCTG := CTeCHCTG(	cCodUF,;
												cTpEmis,;
												AllTrim(SM0->M0_CGC),;
												VALTOT,;
												Iif((cAliasCTG)->F4_ICM <>'N', '1','2'),;
												Iif(!EMPTY((cAliasCTG)->F4_STDESC),'1','2'),;
												SubStr(AllTrim((cAliasCTG)->DT6_DATEMI), 7, 2))
						(cAliasCTG)->(dbCloseArea())
					Else
						cChvCTG := ""
					EndIf

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³  Variavel Private Responsavel Pela Gravação da Chave de contingencia na DT6 ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If !Empty(cChvCTG)
						aAdd(aPChvCtg,{(cAliasDT6)->DT6_FILDOC,(cAliasDT6)->DT6_DOC,(cAliasDT6)->DT6_SERIE ,cChvCTG})
					EndIf

					(cAliasDT6)->(DbSkip())
				EndDo // (02)

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ TAG: autXML -- Autorizados para download do XML do DF-e               ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				// Conforme Resolução 799/2015 da ANTT em seu artigo 22  (Chamado TTRZOW)
				If  !Empty(cCNPJAntt)						
					cString := '<autXML>'
					cString +=  '<CNPJ>' + NoPontos(cCNPJAntt) + '</CNPJ>' 
					cString += '</autXML>'
					aAdd(aXMLCTe,AllTrim(cString))						
				EndIf		

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ TAG: infRespTec -- Identificação do Responsavel Tecnico               ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
				If !lUsaColab  // para os casos de TOTVS Colab não e necessário enviar a Tag <infRespTec>
					If ExistFunc('TMSIdResp')
						cString:= TMSIdResp()
						aAdd(aXMLCTe,AllTrim(cString))	
					EndIf	
				EndIf

				cString := '</infCte>'
				aAdd(aXMLCTe,AllTrim(cString))
				
				If !Empty(cMVURLQCOD)
					//-- TAG: infCTeSupl -- Informações suplementares do CTe QRCode
					If !lUsaColab //Normal
						cString := '<infCTeSupl>'
						cString +=  '<qrCodCTe>'
						cString +=  AllTrim(cMVURLQCOD) + '?chCTe='+ cChvAcesso + '&amp;tpAmb=' + cAmbiente
						cString +=  '</qrCodCTe>'
						cString += '</infCTeSupl>'	
						aAdd(aXMLCTe,AllTrim(cString))
					EndIf
				EndIf
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Botton do Arquivo XML                                           ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cString := ''
				cString += '</CTe>'
				cString += '</infNFe>'
				
				aAdd(aXMLCTe,AllTrim(cString))
				RestArea(aAreaSM0)	
			EndIf // (01)
			
			cString := ''
			
			For nCount := 1 To Len(aXMLCTe)
				cString += AllTrim(aXMLCTe[nCount])
			Next nCount
		EndIf
	EndIf		
EndIf
 
If lTMSCTESEF
	aRetXML := ExecBlock("TMSCTESEF",.F.,.F., {cNota,cSerie,aXMLCTe})
	If ValType(aRetXML) == 'A' .And. Len(aRetXML) > 0
		aXMLCTe := aClone(aRetXML)
	EndIf
	
	cString := ''
	For nCount := 1 To Len(aXMLCTe)
		cString += AllTrim(aXMLCTe[nCount])
	Next nCount	
EndIf

Return({cNfe,EncodeUTF8(cString),cNota,cSerie})
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NFESEFAZ  ºAutor  ³Microsiga           º Data ³  08/03/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
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
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NFESEFAZ  ºAutor  ³Microsiga           º Data ³  08/03/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Inverte()

Local cRet := ""
Local cFunc := "Random"

If FindFunction(cFunc)
	cRet := AllTrim(Str(&cFunc.( 10000000, 99999999 )))
Else
	cRet := AllTrim(Str(Randomize( 10000000, 99999999 )))
EndIf

Return(cRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ CTeCHVAC ³       ³ N3-DL                 ³ Data ³19.03.2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao responsavel em montar a Chave de Acesso             ³±±
±±³          ³ a SEFAZ e calcular o seu digito verIficador.               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CTeCHVAC(cUF, cAAMM, cCNPJ, cMod, cSerie, nCT, cCT)        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cUF...: Codigo da UF                                       ³±±
±±³          ³ cAAMM.: Ano (2 Digitos) + Mes da Emissao do CTe            ³±±
±±³          ³ cCNPJ.: CNPJ do Emitente do CTe                            ³±±
±±³          ³ cMod..: Modelo (57 = CTe)                                  ³±±
±±³          ³ cSerie: Serie do CTe                                       ³±±
±±³          ³ nCT...: Numero do CTe                                      ³±±
±±³          ³ cCT...: Numero do Lote de Envio a SEFAZ                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Explicacao do Calculo se encontra no manual do CT-e        ³±±
±±³          ³ disponibilizado pela SEFAZ na versao atual 1.02,           ³±±
±±³          ³ pag: 77 e 78                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CTeCHVAC(cUF, cAAMM, cCNPJ, cMod, cSerie, nCT, cCT)
Local nCount      := 0
Local nSequenc    := 2
Local nPonderacao := 0
Local cResult     := ''
Local cChvAcesso  := cUF +  cAAMM + cCNPJ + cMod + cSerie + nCT + cCT

// A partir da versão 1.04 do leiaute do CT-e, o campo tpEmis (forma de emissão da CT-e) passou
// a compor a chave de acesso da seguinte forma:
// O tamanho do campo cCT – código numérico do CT-e –foi reduzido para oito posiçõespara não
// alterar o tamanho da chave de acesso do CT-e de 44 posições que passa sercomposta pelos
// seguintes campos que se encontram dispersos no CT-e :
// cUF    - Codigo da UF do emitente do Documento Fiscal
// AAMM   - Ano (2 Digitos) e Mes de emissão do CT-e
// CNPJ   - CNPJ do emitente
// mod    - Modelo do Documento Fiscal (57 = CTe)
// serie  - Serie do Documento Fiscal
// nCT    - Numero do Documento Fiscal
// tpEmis - Forma de emissão do CT-e
// cCT    - Codigo Numurico que compoe a Chave de Acesso
// cDV    - Digito Verificador da Chave de Acesso

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

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NoPontos  ºAutor  ³Andre Godoi         º Data ³  20/11/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retira caracteres dIferentes de numero, como, ponto,       º±±
±±º          ³virgula, barra, traco                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
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
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ CTeCHCTG ³Autor  ³ JfsBarreto            ³ Data ³19.03.2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao responsavel em montar a Chave de Acesso auxiliar    ³±±
±±³          ³ a SEFAZ e calcular o seu digito verIficador.               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CTeCHCTG(cUF, tpEmis,CNPJ,VCT,ICMSp,ICMSs,DD)              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³- cUF    - 02 = Código da UF                                ³±±
±±³          ³- tpEmis - 01 = Forma de Emissão                            ³±±
±±³          ³- CNPJ   - 14 = CNPJ do destinatário                        ³±±
±±³          ³- vCT    - 14 = Valor Total do Serviço                      ³±±
±±³          ³- ICMSp  - 01 = Destaque de ICMS próprio                    ³±±
±±³          ³- ICMSs  - 01 = Destaque de ICMS por substituição tributária³±±
±±³          ³- DD     - 02 = Dia da emissão                              ³±±
±±³          ³- DV     - 01 = Dígito Verificador                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Explicacao do Calculo se encontra no manual do CT-e        ³±±
±±³          ³ disponibilizado pela SEFAZ na versao atual 1.02,           ³±±
±±³          ³ pag: 77 e 78                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CTeCHCTG(cUF,tpEmis,cCNPJ, cvCT, cICMSp, cICMSs, cDD)
Local nCount      := 0
Local nSequenc    := 2
Local nPonderacao := 0
Local cResult     := ''
Local cChvCTG  := cUF +  tpEmis + cCNPJ + cvCT + cICMSp + cICMSs + cDD

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³SEQUENCIA DE MULTIPLICADORES (nSequenc), SEGUE A SEGUINTE        ³
//³ORDENACAO NA SEQUENCIA: 2,3,4,5,6,7,8,9,2,3,4... E PRECISA SER   ³
//³GERADO DA DIREITA PARA ESQUERDA, SEGUINDO OS CARACTERES          ³
//³EXISTENTES NA CHAVE DE ACESSO INFORMADA (cChvAcesso)             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nCount := Len( AllTrim(cChvCTG) ) To 1 Step -1
	nPonderacao += ( Val( SubStr( AllTrim(cChvCTG), nCount, 1) ) * nSequenc )
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
	cResult := (cChvCTG + cValToChar( (11 - mod(nPonderacao,11) ) ) )
Else
	cResult := (cChvCTG + '0')
EndIf

Return(cResult)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³UsaColaboracao  ºAutor ³Felipe Barbiereº Data ³  07/01/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica se é TOTVS Colaboraçao                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function UsaColaboracao(cModelo)
Local lUsa := .F.

If FindFunction("ColUsaColab")
	lUsa := ColUsaColab(cModelo)
endif
Return (lUsa)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTESEFAZ3  ºAutor  ³Felipe Barbiere     º Data ³  20/12/16  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³    Retorna o Tomador do CT-e                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CTeToma(cAliasDT6, nRet, cCodUFDpc)

Local cRet 		:= ""
Local cPessoaToma	:= ""
Local cCNPJToma 	:= ""
Local cTomador   	:= ""
Local cIEToma		:= ""

Default nRet 		:= 1
Default cCodUFDpc := ""

If	( Empty((cAliasDT6)->DT6_CLICON) .And. Empty((cAliasDT6)->DT6_CLIDPC) ) .Or. ;
	((IIf(!Empty((cAliasDT6)->DT6_CLICON),((cAliasDT6)->DT6_CLICON+(cAliasDT6)->DT6_LOJCON <> (cAliasDT6)->DT6_CLIDEV+(cAliasDT6)->DT6_LOJDEV),.T.)) .And. ;
	 (IIf(!Empty((cAliasDT6)->DT6_CLIDPC) ,((cAliasDT6)->DT6_CLIDPC+(cAliasDT6)->DT6_LOJDPC <> (cAliasDT6)->DT6_CLIDEV+(cAliasDT6)->DT6_LOJDEV),.T.)))

	//+---------------------------------------------------------------------------
	//| Tomador = 0-Remetente
	//| DTC/DT6_DEVFRE : 1=Remetente;2=Destinatario;3=Consignatario;4=Despachante;6=Expedidor;7=Recebedor
	//+---------------------------------------------------------------------------
	If ((cAliasDT6)->DT6_CLIREM = (cAliasDT6)->DT6_CLIDES) .And.;
	   ((cAliasDT6)->DT6_LOJREM = (cAliasDT6)->DT6_LOJDES) .And. (cAliasDT6)->DT6_DEVFRE $ "1|2"
		If (cAliasDT6)->DT6_DEVFRE = '1' 
			cCNPJToma 		:= AllTrim((cAliasDT6)->REM_CNPJ)
			cPessoaToma 	:= AllTrim((cAliasDT6)->REM_TPPESSOA)
			cTomador   	:= '0'
			cIEToma 		:= IIf((cAliasDT6)->REM_CONTRIB = '1', '1', '9')	
		ElseIf (cAliasDT6)->DT6_DEVFRE = '2'
			cCNPJToma 		:= AllTrim((cAliasDT6)->DES_CNPJ)
			cPessoaToma 	:= AllTrim((cAliasDT6)->DES_TPPESSOA)
			cTomador   	:= '3'			
			If (cAliasDT6)->DES_CONTRIB <> "2" .and. !Empty((cAliasDT6)->DES_INSC)
				 If "ISENT" $ Upper(Alltrim((cAliasDT6)->DES_INSC))
				  cIEToma := "2" //2-Contribuinte isento de inscrição; 
				 Else
				  cIEToma := "1" //1-Contribuinte ICMS;  
				 EndIf
			Else				
			 	cIEToma := "9" //9-Não Contribuinte			 	
			EndIf	
		EndIf
	//+---------------------------------------------------------------------------
	//| Tomador = 0-Remetente
	//+---------------------------------------------------------------------------
	ElseIf ((cAliasDT6)->DT6_CLIREM = (cAliasDT6)->DT6_CLIDEV) .And.;
	       ((cAliasDT6)->DT6_LOJREM = (cAliasDT6)->DT6_LOJDEV) .And. (cAliasDT6)->DT6_DEVFRE $ "1"
		cCNPJToma 		:= AllTrim((cAliasDT6)->REM_CNPJ)
		cPessoaToma 	:= AllTrim((cAliasDT6)->REM_TPPESSOA)
		cTomador   	    := '0'

		If (cAliasDT6)->REM_CONTRIB <> "2" .And. !Empty((cAliasDT6)->REM_INSC)
			If "ISENT" $ Upper(AllTrim((cAliasDT6)->REM_INSC))
				cIEToma := "2" //-- Contribuinte isento de inscricao
			Else
				cIEToma := "1" //-- Contribuinte ICMS
			EndIf
		Else
			cIEToma  := "9"
		EndIf		
		
	//+---------------------------------------------------------------------------
	//| Tomador = 1-Expedidor
	//+---------------------------------------------------------------------------
	ElseIf ((cAliasDT6)->DT6_CLIEXP == (cAliasDT6)->DT6_CLIDEV) .And.;
		   ((cAliasDT6)->DT6_LOJEXP == (cAliasDT6)->DT6_LOJDEV) .And. (cAliasDT6)->DT6_DEVFRE $ "6"
			cCNPJToma     := AllTrim((cAliasDT6)->EXP_CNPJ)
			cPessoaToma   := AllTrim((cAliasDT6)->EXP_TPPESSOA)
			cTomador      := '1'
			If (cAliasDT6)->EXP_CONTRIB <> "2" .And. !Empty((cAliasDT6)->EXP_INSC)
				If "ISENT" $ Upper(AllTrim((cAliasDT6)->EXP_INSC))
					cIEToma := "2" //-- Contribuinte isento de inscricao
				Else
					cIEToma := "1" //-- Contribuinte ICMS
				EndIf
			Else
				cIEToma  := "9"
			EndIf

	//+---------------------------------------------------------------------------
	//| Tomador = 2-Recebedor
	//+---------------------------------------------------------------------------
	ElseIf ((cAliasDT6)->DT6_CLIREC == (cAliasDT6)->DT6_CLIDEV) .And.;
		   ((cAliasDT6)->DT6_LOJREC == (cAliasDT6)->DT6_LOJDEV)  .And. (cAliasDT6)->DT6_DEVFRE $ "7"
			cCNPJToma     := AllTrim((cAliasDT6)->REC_CNPJ)
			cPessoaToma   := AllTrim((cAliasDT6)->REC_TPPESSOA)
			cTomador      := '2'
			
			If (cAliasDT6)->REC_CONTRIB <> "2" .And. !Empty((cAliasDT6)->REC_INSC)
				If "ISENT" $ Upper(AllTrim((cAliasDT6)->REC_INSC))
					cIEToma := "2" //-- Contribuinte isento de inscricao
				Else
					cIEToma := "1" //-- Contribuinte ICMS
				EndIf
			Else
				cIEToma  := "9"
			EndIf
	
	//+---------------------------------------------------------------------------
	//| Tomador = 3-Destinatario
	//+---------------------------------------------------------------------------
	ElseIf ((cAliasDT6)->DT6_CLIDES = (cAliasDT6)->DT6_CLIDEV) .And.;
		   ((cAliasDT6)->DT6_LOJDES = (cAliasDT6)->DT6_LOJDEV) .And. (cAliasDT6)->DT6_DEVFRE $ "2"
		cCNPJToma 		:= AllTrim((cAliasDT6)->DES_CNPJ)
		cPessoaToma 	:= AllTrim((cAliasDT6)->DES_TPPESSOA)
		cTomador		:= '3'
		If (cAliasDT6)->DES_CONTRIB <> "2" .and. !Empty((cAliasDT6)->DES_INSC)
			 If "ISENT" $ Upper(Alltrim((cAliasDT6)->DES_INSC))
			  cIEToma := "2" //2-Contribuinte isento de inscrição;
			 Else
			  cIEToma := "1" //1-Contribuinte ICMS;
			 EndIf
		Else
		 	cIEToma := "9" //9-Não Contribuinte		 	
		EndIf
			
	Else
		cTomador   	:= '1'
		cIEToma 		:= IIf((cAliasDT6)->REM_CONTRIB = '1', '1', '9')	
	EndIf
	cRet += '<indIEToma>' + cIEToma + '</indIEToma>'
	cRet += '<toma3>'
	cRet += '<toma>' + cTomador + '</toma>'
	cRet += '</toma3>'

ElseIf (((cAliasDT6)->DT6_CLICON = (cAliasDT6)->DT6_CLIDEV) .And.;
		((cAliasDT6)->DT6_LOJCON = (cAliasDT6)->DT6_LOJDEV))
		
	cCNPJToma 		:= AllTrim((cAliasDT6)->CON_CNPJ)
	cPessoaToma 	:= AllTrim((cAliasDT6)->CON_TPPESSOA)	
	If (cAliasDT6)->CON_CONTRIB <> "2" .and. !Empty((cAliasDT6)->CON_INSC)
		 If "ISENT" $ Upper(Alltrim((cAliasDT6)->CON_INSC))
		  cIEToma := "2" //2-Contribuinte isento de inscrição; 
		 Else
		  cIEToma := "1" //1-Contribuinte ICMS;  
		 EndIf
	Else 		
	 	cIEToma := "9" //9-Não Contribuinte	 	
	EndIf		
	
	cRet += '<indIEToma>' + cIEToma + '</indIEToma>'
	cRet += '<toma4>'
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Tomador do Servico Consignatario     ³
	//³ 4 - Outros;                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cRet += '<toma>4</toma>'
	
	If (AllTrim((cAliasDT6)->CON_TPPESSOA) == "J")
		cRet += '<CNPJ>' + AllTrim((cAliasDT6)->CON_CNPJ) + '</CNPJ>'
	Else
		cRet += '<CPF>'  + AllTrim((cAliasDT6)->CON_CNPJ) + '</CPF>'
	EndIf
	
	//-- Conf. MOC 3.00a, tag IE: Caso o tomador não seja contribuinte do ICMS não informar o conteúdo. 
	If (cAliasDT6)->CON_CONTRIB =='1' 
		If Empty((cAliasDT6)->CON_INSC) .Or. "ISENT" $ Upper(AllTrim((cAliasDT6)->CON_INSC))
			cRet += '<IE>ISENTO</IE>'
		Else
			cRet += '<IE>' + NoPontos((cAliasDT6)->CON_INSC) + '</IE>'
		EndIf
	EndIf

	cRet += '<xNome>' + NoAcentoCte(SubStr((cAliasDT6)->CON_NOME,1,60)) + '</xNome>'
	If  !Empty(NoPontos((cAliasDT6)->CON_TEL))
		cRet += '<fone>'  +  cValtoChar(NoPontos((cAliasDT6)->CON_DDDTEL)) +;
		cValtoChar(NoPontos((cAliasDT6)->CON_TEL)) + '</fone>'
	EndIf
	cRet += '<enderToma>'
	cRet += '<xLgr>' + NoAcentoCte(FisGetEnd((cAliasDT6)->CON_END)[1]) + '</xLgr>'
	cRet += '<nro>'  + Iif(FisGetEnd((cAliasDT6)->CON_END)[2]<>0, AllTrim(cValtoChar( FisGetEnd((cAliasDT6)->CON_END)[2])),"S/N") + '</nro>'
	
	If !Empty(NoAcentoCte(FisGetEnd((cAliasDT6)->CON_CPL)[4]))
		cRet += '<xCpl>' + NoAcentoCte(FisGetEnd((cAliasDT6)->CON_CPL)[4]) + '</xCpl>'
	EndIf
	
	If Empty(AllTrim((cAliasDT6)->CON_BAIRRO))
		cRet += '<xBairro>BAIRRO NAO CADASTRADO</xBairro>'
	Else
		cRet += '<xBairro>' +NoAcentoCte( (cAliasDT6)->CON_BAIRRO ) + '</xBairro>'
	EndIf
	
	//-- Confere se Uf do Consignatario esta OK
	If !Empty((cAliasDT6)->CON_UF)
		If (aScan(aUF,{|x| x[1] == (cAliasDT6)->CON_UF }) != 0)
			cCodUFCon  := aUF[ aScan(aUF,{|x| x[1] == (cAliasDT6)->CON_UF }), 2]
		Else
			cCodUFCon := ''
		EndIf
	EndIf
					
	cRet += '<cMun>' + NoAcentoCte( AllTrim(cCodUFCon)         + AllTrim((cAliasDT6)->CON_COD_MUN) ) + '</cMun>'
	cRet += '<xMun>' + NoAcentoCte( (cAliasDT6)->CON_MUNICI ) + '</xMun>'
	cRet += '<CEP>'  + NoAcentoCte( (cAliasDT6)->CON_CEP )    + '</CEP>'
	cRet += '<UF>'   + NoAcentoCte( (cAliasDT6)->CON_UF )     + '</UF>'
	If !Empty(AllTrim((cAliasDT6)->CON_PAIS))
		cRet +=  '<cPais>'+ NoAcentoCte( (cAliasDT6)->CON_PAIS ) + '</cPais>'
		cRet +=  '<xPais>'+ NoAcentoCte( Posicione("SYA",1,xFilial("SYA")+(cAliasDT6)->CON_PAIS,"YA_DESCR") ) + '</xPais>'
	EndIf
	
	cRet += '</enderToma>'
	If !Empty((cAliasDT6)->CON_EMAIL)
		cRet += '<email>' + NoAcentoCte(SubStr(AllTrim((cAliasDT6)->CON_EMAIL),1,60)) + '</email>'
	EndIf
	cRet += '</toma4>'
		
ElseIf (((cAliasDT6)->DT6_CLIDPC = (cAliasDT6)->DT6_CLIDEV) .And.;
			((cAliasDT6)->DT6_LOJDPC = (cAliasDT6)->DT6_LOJDEV))
		
		cCNPJToma 	:= AllTrim((cAliasDT6)->DPC_CNPJ)
		cPessoaToma := AllTrim((cAliasDT6)->DPC_TPPESSOA)  		
		If (cAliasDT6)->DPC_CONTRIB <> "2" .and. !Empty((cAliasDT6)->DPC_INSC)
			 If "ISENT" $ Upper(Alltrim((cAliasDT6)->CON_INSC))
			  cIEToma := "2" //2-Contribuinte isento de inscrição; 
			 Else
			  cIEToma := "1" //1-Contribuinte ICMS;  
			 EndIf
		Else		 	
		 	cIEToma := "9" //9-Não Contribuinte		 	
		EndIf		
		cRet += '<indIEToma>' + cIEToma + '</indIEToma>'
		
		cRet += '<toma4>'
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Tomador do Servico Despachante       ³
		//³ 4 - Outros;                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cRet += '<toma>4</toma>'
		If (AllTrim((cAliasDT6)->DPC_TPPESSOA) == "J")
			cRet += '<CNPJ>' + NoAcentoCte( (cAliasDT6)->DPC_CNPJ ) + '</CNPJ>'
		Else
			cRet += '<CPF>'  + NoAcentoCte( (cAliasDT6)->DPC_CNPJ ) + '</CPF>'
		EndIf
	
		//-- Conf. MOC 3.00a, tag IE: Caso o tomador não seja contribuinte do ICMS não informar o conteúdo. 
		If (cAliasDT6)->DPC_CONTRIB =='1' 
			If Empty((cAliasDT6)->DPC_INSC) .Or. 'ISENT' $ Upper(AllTrim((cAliasDT6)->DPC_INSC)) .Or. ((cAliasDT6)->DPC_CONTRIB =='1' .And. 'ISENT' $ Upper(AllTrim((cAliasDT6)->DPC_INSC)))
				cRet += '<IE>ISENTO</IE>'
			Else
				cRet += '<IE>' + NoPontos((cAliasDT6)->DPC_INSC) + '</IE>'
			EndIf
		EndIf

		cRet += '<xNome>' + NoAcentoCte(SubStr((cAliasDT6)->DPC_NOME,1,60)) + '</xNome>'
		cRet += '<enderToma>'
		cRet += '<xLgr>' + NoAcentoCte(FisGetEnd((cAliasDT6)->DPC_END)[1]) + '</xLgr>'
		cRet += '<nro>' + Iif(FisGetEnd((cAliasDT6)->DPC_END)[2]<>0, AllTrim(cValtoChar( FisGetEnd((cAliasDT6)->DPC_END)[2])),"S/N") + '</nro>'
		If !Empty(NoAcentoCte(FisGetEnd((cAliasDT6)->DPC_CPL)[4]))
			cRet += '<xCpl>' + NoAcentoCte(FisGetEnd((cAliasDT6)->DPC_CPL)[4]) + '</xCpl>'
		EndIf
		If Empty(AllTrim((cAliasDT6)->DPC_BAIRRO))
			cRet += '<xBairro>BAIRRO NAO CADASTRADO</xBairro>'
		Else
			cRet += '<xBairro>' + NoAcentoCte( (cAliasDT6)->DPC_BAIRRO ) + '</xBairro>'
		EndIf
		cRet += '<cMun>' + NoAcentoCte( AllTrim(cCodUFDpc) + Alltrim((cAliasDT6)->DPC_COD_MUN) ) + '</cMun>'
		cRet += '<xMun>' + NoAcentoCte( (cAliasDT6)->DPC_MUNICI ) + '</xMun>'
		cRet += '<CEP>'  + NoAcentoCte( (cAliasDT6)->DPC_CEP )    + '</CEP>'
		cRet += '<UF>'   + NoAcentoCte( (cAliasDT6)->DPC_UF )     + '</UF>'
		cRet += '</enderToma>'
		If !Empty((cAliasDT6)->DPC_EMAIL)
			cRet += '<email>' + NoAcentoCte(SubStr(AllTrim((cAliasDT6)->DPC_EMAIL),1,60)) + '</email>'
		EndIf
		cRet += '</toma4>'
	EndIf
	
	If (nRet == 2)
		If (AllTrim(cPessoaToma) == "J")
			cRet = '<CNPJ>' + AllTrim(cCNPJToma) + '</CNPJ>'
		Else
			cRet = '<CPF>'  + AllTrim(cCNPJToma) + '</CPF>'
		EndIf
	EndIf 	
	
Return(cRet)


/*/{Protheus.doc} TrocaToma
// Verifica se o tomador de serviços foi alterado na substituição
@author caio.y
@since 16/11/2017
@version 1.0
@return ${return}, ${return_description}
@param cFilDoc, characters, Filial Doc
@param cDoc, characters, Documento
@param cSerie, characters, Serie
@param cCliDev, characters, Devedor
@param cLojDev, characters, Loja Devedor
@type function
/*/
Static Function TrocaToma(cFilDoc, cDoc , cSerie ,  cCliDev , cLojDev )
Local lRet		:= .F. 
Local aAreaDT6	:= DT6->(GetArea())

Default cFilDoc		:= ""
Default cDoc		:= ""
Default cSerie		:= ""
Default cCliDev		:= ""
Default cLojDev		:= ""

DT6->(dbSetOrder(1)) //-- FILIAL+FILDOC+DOC+SERIE
If DT6->(dbSeek(xFilial("DT6") + cFilDoc + cDoc + cSerie ))
	If cCliDev + cLojDev <> DT6->(DT6_CLIDEV+DT6_LOJDEV)
		lRet	:= .T. 
	EndIf
EndIf

RestArea(aAreaDT6)
Return lRet

/*/{Protheus.doc} tagRecebe()
	(long_description)
	@type  Static Function
	@author user
	@since date
	@version version
	@param param, param_type, param_descr
	@return returno,return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/
Static Function tagRecebe( cCodigo, cLoja, cSeqEntr, cAmbiente, lRedesp )

Local cResult   := ""
Local cSeekSa1  := ""
Local lJuridico := .T.
Local cCnpjCpf  := ""
Local cIE       := ""
Local cNomeRec  := ""
Local cTelefone := ""
Local cEmail    := ""
Local cEndereco := ""
Local cNumero   := ""
Local cComplem  := ""
Local cBairro   := ""
Local cMuniCod  := ""
Local cDscMunic := ""
Local cCep      := ""
Local cUF       := ""
Local cCodPais  := ""
Local cDscPais  := ""
Local lImpRec	:= .T.
Local lDULAchou	:= .F.
Local lDULAtu	:= DUL->( FieldPos("DUL_RECINS") ) > 0 .AND. DUL->( FieldPos("DUL_RECPES") ) > 0 .AND. DUL->( FieldPos("DUL_RECCGC") ) > 0 .AND. DUL->( FieldPos("DUL_IMPREC") )
 
	//+--------------------------------------------------
	//| monta a referencia de pesquisa para o recebedor
	//+--------------------------------------------------
	DUL->(DbSetOrder(2)) // DUL_FILIAL, DUL_CODCLI, DUL_LOJCLI, DUL_SEQEND
	SA1->(DbSetOrder(1))
	If !Empty(cSeqEntr) .And. DUL->(MsSeek(xFilial('DUL') + cCodigo + cLoja + cSeqEntr))
		lDULAchou := .T.
		If lDULAtu
			lImpRec := DUL->DUL_IMPREC == '1' .OR. DUL->DUL_IMPREC == ' ' // 1 = Sim 2 = Não
		EndIf

		If !Empty(DUL->DUL_CODRED+DUL->DUL_LOJRED)
			cSeekSA1 := xFilial('SA1') + DUL->DUL_CODRED + DUL->DUL_LOJRED
			lRedesp  := .T.
		Else
			If SA1->(dbSeek(xFilial('SA1') + cCodigo + cLoja))
				cCnpjCpf  := Iif( AllTrim(SA1->A1_PESSOA) == "J",NoPontos(SA1->A1_CGC),AllTrim(SA1->A1_CGC))
				lJuridico := (SA1->A1_PESSOA == "J")
				cIE       := Upper(AllTrim(SA1->A1_INSCR))
				cCONTRIB  := SA1->A1_CONTRIB
				cNomeRec  := Iif(cAmbiente == '2',SubStr('CTE EMITIDO EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL',1,60),AllTrim(SA1->A1_NOME))
				cTelefone := AllTrim(NoAcentoCte(SA1->A1_DDD)) + AllTrim(NoAcentoCte(SA1->A1_TEL)) 
				cEmail    := AllTrim(SA1->A1_EMAIL)
				cEndereco := NoAcentoCte(FisGetEnd(DUL->DUL_END)[1])
				cNumero   := Iif(FisGetEnd(DUL->DUL_END)[2]<>0, AllTrim(cValtoChar( FisGetEnd(DUL->DUL_END)[2])),"S/N")
				//cComplem  := AllTrim(NoAcentoCTE(SA1->A1_COMPLEM))
				cBairro   := Iif(!Empty(DUL->DUL_BAIRRO),NoAcentoCTE(DUL->DUL_BAIRRO),"Bairro Nao Cadastrado")
				If aScan(aUF,{|x| x[1] == DUL->DUL_EST }) != 0
					cMuniCod := aUF[ aScan(aUF,{|x| x[1] == DUL->DUL_EST }), 2]
				EndIf
				cMuniCod  := NoAcentoCte( AllTrim(cMuniCod) + AllTrim(DUL->DUL_CODMUN) )
				cDscMunic := NoAcentoCTE(DUL->DUL_MUN)
				cCep      := NoAcentoCTE(DUL->DUL_CEP)
				cUF       := AllTrim(DUL->DUL_EST)
				cCodPais  := NoAcentoCte( Posicione("DUY",1,xFilial("DUY")+DUL->DUL_CDRDES,"DUY_PAIS") )
				cDscPais  := NoAcentoCte( Posicione("SYA",1,xFilial("SYA")+DUY->DUY_PAIS  ,"YA_DESCR") )
				
				If AllTrim(DUL->DUL_EST) <> AllTrim(SA1->A1_EST) // Incluído para os casos onde o estado do destinatário é diferente do estado da sequência de entrega. Para não ocorrer rejeição 440
					If lDULAtu .AND. !Empty(DUL->DUL_RECPES) .AND. !Empty(DUL->DUL_RECCGC) .AND. !Empty(DUL->DUL_RECINS)
						cCnpjCpf	:= If( AllTrim(DUL->DUL_RECPES) == "2", NoPontos(DUL->DUL_RECCGC), AllTrim(DUL->DUL_RECCGC) )
						lJuridico	:= (DUL->DUL_RECPES == "2")
						cIE			:= If( 'ISENT' $ Upper(AllTrim(DUL->DUL_RECINS)), "ISENTO", DUL->DUL_RECINS )
					EndIf
				EndIf
			
			EndIf
		EndIf
	Else
		cSeekSA1 := xFilial('SA1') + cCodigo + cLoja
	EndIf
	//--
	//-- Popula as tags do recebedor para o XML CTE 3.0
	//--
	If !Empty(cSeekSA1)
		SA1->(dbSeek(cSeekSA1))
		
		If lDULAtu .AND. !Empty(DUL->DUL_RECPES) .AND. !Empty(DUL->DUL_RECCGC) .AND. !Empty(DUL->DUL_RECINS)
			cCnpjCpf	:= If( AllTrim(DUL->DUL_RECPES) == "2", NoPontos(DUL->DUL_RECCGC), AllTrim(DUL->DUL_RECCGC) )
			lJuridico	:= (DUL->DUL_RECPES == "2")
			cIE		:= If( 'ISENT' $ Upper(AllTrim(DUL->DUL_RECINS)), "ISENTO", DUL->DUL_RECINS )
		Else
			cCnpjCpf	:= If( AllTrim(SA1->A1_PESSOA) == "J",NoPontos(SA1->A1_CGC),AllTrim(SA1->A1_CGC))
			lJuridico	:= (SA1->A1_PESSOA == "J")
			
			If DUL->(DbSeek(xFilial('DUL') + cCodigo + cLoja + cSeqEntr))
				lDULAchou := .T.
			Else
				lDULAchou := .F.
			EndIf

			cIE		:= If( lDULAchou .And. 'ISENT' $ Upper(AllTrim(DUL->DUL_INSCR)), "ISENTO", SA1->A1_INSCR )
		EndIf

		cCONTRIB  := SA1->A1_CONTRIB
		cNomeRec  := If(cAmbiente == '2',SubStr('CTE EMITIDO EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL',1,60),AllTrim(SA1->A1_NOME))
		cTelefone := AllTrim(NoAcentoCte(SA1->A1_DDD)) + AllTrim(NoAcentoCte(SA1->A1_TEL))
		cEmail    := AllTrim(SA1->A1_EMAIL)
		cEndereco := NoAcentoCte(FisGetEnd(SA1->A1_END)[1])
		cNumero   := If(FisGetEnd(SA1->A1_END)[2]<>0, AllTrim(cValtoChar( FisGetEnd(SA1->A1_END)[2])),"S/N")
		cComplem  := AllTrim(NoAcentoCTE(SA1->A1_COMPLEM))
		cBairro   := If(!Empty(SA1->A1_BAIRRO),NoAcentoCTE(SA1->A1_BAIRRO),"Bairro Nao Cadastrado")

		If aScan(aUF,{|x| x[1] == SA1->A1_EST }) != 0
			cMuniCod := aUF[ aScan(aUF,{|x| x[1] == SA1->A1_EST  }), 2]
		EndIf

		cMuniCod  := NoAcentoCte( AllTrim(cMuniCod) + AllTrim(SA1->A1_COD_MUN) )
		cDscMunic := NoAcentoCTE(SA1->A1_MUN)
		cCep      := NoAcentoCTE(SA1->A1_CEP)
		cUF       := AllTrim(SA1->A1_EST)
		cCodPais  := NoAcentoCte( Posicione("DUY",1,xFilial("DUY")+SA1->A1_CDRDES,"DUY_PAIS") )
		cDscPais  := NoAcentoCte( Posicione("SYA",1,xFilial("SYA")+DUY->DUY_PAIS  ,"YA_DESCR") )
	EndIf

	If lImpRec
		cResult := '<receb>'
		
		If lJuridico
			cResult += '<CNPJ>' + cCnpjCpf + '</CNPJ>'
		Else
			cResult += '<CPF>'  + cCnpjCpf + '</CPF>'
		EndIf
		
		If cCONTRIB == '1' .Or. !Empty(cIE)
			cResult += '<IE>' + NoPontos(cIE) + '</IE>'
		EndIf
		
		cResult += '<xNome>' + NoAcentoCte(cNomeRec) + '</xNome>'
		
		cResult += Iif(!Empty(cTelefone),'<fone>'  + cValtoChar(NoPontos(cTelefone)) + '</fone>','')  +; //-- Telefone
					'<enderReceb>'   +;
						'<xLgr>'    + cEndereco + '</xLgr>' +; //-- Endereco
						'<nro>'     + cNumero   + '</nro>'     //-- Numero
		
		cResult += Iif(!Empty(cComplem),'<xCpl>' + cComplem  + '</xCpl>','') +; //-- Complemen..to
						'<xBairro>' + cBairro   + '</xBairro>' +; //-- Bairro
						'<cMun>'    + cMuniCod  + '</cMun>'    +; //-- Codigo IBGE do Municipio
						'<xMun>'    + cDscMunic + '</xMun>'    +; //-- Descricao do Municipio
						'<CEP>'     + cCep      + '</CEP>'     +; //-- CEP
						'<UF>'      + cUF       + '</UF>'      +;
						'<cPais>'   + cCodPais  + '</cPais>'   +; //-- Codigo do Pais
						'<xPais>'   + cDscPais  + '</xPais>'      //-- Descricao do Pais

		cResult += '</enderReceb>'

		If !Empty(cEmail)
			cResult += '<email>' + NoAcentoCte(SubStr(AllTrim(cEmail),1,60)) + '</email>'
		EndIf
		cResult += '</receb>'
	EndIf

Return cResult

/*/{Protheus.doc} grpExpedid(cCliExp,cLojExp,cNumSol)
	(funcao responsavel por montar a tag de expedidor da carga)
	@type  Static Function
	@author user
	@since date
	@version version
	@param cCliExp, Character, Codigo do Expedidor relacionado a tabela SA1 - Cadastro de Clientes
	@param cLojExp, Character, Codigo da Loja do Expedidor relacionado a tabela SA1 - Cadastro de Clientes
	@param cNumSol, Character, Numero da solicitação de coleta para casos em que existe o vincula pela nota fiscal da coleta.
	@return return, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function grpExpedid(cCliRem,cLojRem,cCliExp,cLojExp,cFilOri,cNumSol,aUF,cAmbiente)
 Local cResult    := ""
 Local lExpedOK   := .F.
 Local cStringExp := ""
 Local cQuery     := ""
 Local cAliasDT5  := GetNextAlias()
 Local cAliasCol  := ""
 Local cCodUFOri  := ""
 Default cCliRem  := Space(Len(SA1->A1_COD))
 Default cLojRem  := Space(Len(SA1->A1_LOJA))

		If !Empty(cNumSol)
				cAliasDT5:= GetNextAlias()
				cQuery := " SELECT A1_COD, A1_LOJA, A1_CGC, A1_PESSOA,A1_COMPLEM ,"
				cQuery += "   DUE_CODCLI, DUE_LOJCLI, DUE_NREDUZ, DUE_END, DUE_BAIRRO, DUE_CODMUN,DUE_MUN, DUE_EST, "
				cQuery += "   DUL_CODRED, DUL_LOJRED, DUL_CODCLI, DUL_LOJCLI, DUL_END, DUL_BAIRRO, DUL_CODMUN, DUL_MUN, DUL_EST "
				cQuery += "	FROM " + RetSQLName("DT5") + " DT5 "
				cQuery += "  JOIN " + RetSQLName("DUE") + " DUE "
				cQuery += "   ON DUE_FILIAL = '" + xFilial('DUE') + "'" 
				cQuery += "    AND DUE_CODSOL  = DT5_CODSOL "
				cQuery += "    AND DUE.D_E_L_E_T_ = ' ' "
				cQuery += "  JOIN " + RetSQLName("SA1") + " SA1 "
				cQuery += "    ON  A1_FILIAL = '" + xFilial('SA1') + "'" 
				cQuery += "    AND A1_COD = DUE_CODCLI "
				cQuery += "    AND A1_LOJA = DUE_LOJCLI "
				cQuery += "    AND SA1.D_E_L_E_T_ = ' ' "
				cQuery += "  LEFT JOIN " + RetSqlName("DUL") + " DUL "
				cQuery += "   ON DUL_FILIAL = '" + xFilial('DUL') + "'"
				cQuery += "	   AND DUL_CODSOL = DT5_CODSOL "
				cQuery += "	   AND DUL_SEQEND = DT5_SEQEND "
				cQuery += "	   AND DUL.D_E_L_E_T_ = ' ' "
				cQuery += "  WHERE DT5_FILIAL	= '" + xFilial("DT5") + "' "
				cQuery += "    AND DT5_FILORI  = '" + cFilOri + "' "
				cQuery += "    AND DT5_NUMSOL  = '" + cNumSol + "' "
				cQuery += "    AND DT5.D_E_L_E_T_ = ' ' "
				cQuery := ChangeQuery(cQuery)
				DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAliasDT5,.T.,.T.)
				If !(cAliasDT5)->(Eof())
					If (!Empty(Alltrim((cAliasDT5)->DUE_CODCLI)) .And. (!Empty(AllTrim((cAliasDT5)->DUE_LOJCLI))))
						If (cCliRem == (cAliasDT5)->DUE_CODCLI .And. cLojRem == (cAliasDT5)->DUE_LOJCLI)
							If !(Empty(Alltrim((cAliasDT5)->DUL_CODRED)) .And. !Empty(Alltrim((cAliasDT5)->DUL_LOJRED)))										
								//Faz um select na SA1 para pegar o Redespachante / Origem da Coleta	   
								cAliasCol:= GetNextAlias()									                  
								cQuery := " SELECT DUL_CODRED, DUL_LOJRED, "
								cQuery += "	A1_COD, A1_LOJA, A1_CGC, A1_PESSOA,A1_NOME, A1_END, A1_BAIRRO, A1_MUN, A1_EST," 
								cQuery += "   A1_COD_MUN, A1_INSCR, A1_PAIS, A1_DDD, A1_TEL, A1_CEP, A1_COMPLEM, A1_CODPAIS, A1_CONTRIB " 
								cQuery += "  FROM " + RetSqlName("DUL") + " DUL, " 
								cQuery += RetSqlName("SA1") + " SA1 "
								cQuery += "  WHERE SA1.A1_FILIAL = '" + xFilial('SA1') + "'"
								cQuery += "	 AND DUL.DUL_FILIAL = '" + xFilial('DUL') + "'"
								cQuery += "	 AND A1_COD = '" + (cAliasDT5)->DUL_CODRED + "'"
								cQuery += "     AND A1_LOJA = '" + (cAliasDT5)->DUL_LOJRED + "'"
								cQuery += "     AND SA1.D_E_L_E_T_ = ' ' "
								cQuery += "     AND DUL.D_E_L_E_T_ = ' ' "
								cQuery := ChangeQuery(cQuery)
								DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAliasCol,.T.,.T.)
								If !(cAliasCol)->(Eof())
									cStringExp := ""
									cStringExp += '<exped>'
									// Enderenco Solicitante DUL
									If aScan(aUF,{|x| x[1] == (cAliasCol)->(A1_EST) }) != 0   //Confere se Uf do End.Solicitante esta OK
										cCodUFOri  := aUF[ aScan(aUF,{|x| x[1] == (cAliasCol)->(A1_EST) }), 2]
									Else
										cCodUFOri  := ''
									EndIf
									If (AllTrim((cAliasCol)->(A1_PESSOA)) == "J")
										cStringExp += '<CNPJ>' + NoPontos((cAliasCol)->A1_CGC) + '</CNPJ>'
									Else
										cStringExp += '<CPF>' + AllTrim((cAliasCol)->A1_CGC) + '</CPF>'
									EndIf
									
									If (cAliasCol)->A1_CONTRIB == '1'
										If 'ISENT' $ Upper(AllTrim((cAliasCol)->A1_INSCR))
											cStringExp += '<IE>ISENTO</IE>'
										Else
											cStringExp += '<IE>' + NoPontos((cAliasCol)->A1_INSCR) + '</IE>'
										EndIf
									EndIf
									
									If cAmbiente == '2'  //--Homologacao / Nota Técnica 2012/005 
										cStringExp += '<xNome>' + (SubStr('CTE EMITIDO EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL',1,60)) + '</xNome>'
									Else
										cStringExp += '<xNome>' + NoAcentoCte(SubStr((cAliasCol)->A1_NOME,1,60)) + '</xNome>'
									EndIf
									
									If !Empty((cAliasCol)->A1_TEL)
										cStringExp += '<fone>' + cValtoChar(NoPontos((cAliasCol)->A1_DDD)) +;
										cValtoChar(NoPontos((cAliasCol)->A1_TEL)) + '</fone>'
									EndIf
									
									cStringExp += '<enderExped>'
									cStringExp += '<xLgr>' + NoAcentoCte(FisGetEnd((cAliasCol)->A1_END)[1]) + '</xLgr>'
									cStringExp += '<nro>' + Iif(FisGetEnd((cAliasCol)->A1_END)[2] <> 0, AllTrim(cValtoChar( FisGetEnd((cAliasCol)->A1_END)[2])),"S/N") + '</nro>'
									If !Empty(NoAcentoCte(FisGetEnd((cAliasCol)->A1_COMPLEM)[4]))
										cStringExp += '<xCpl>' + NoAcentoCte(FisGetEnd((cAliasCol)->A1_COMPLEM)[4]) + '</xCpl>'
									EndIf
									If Empty(AllTrim((cAliasCol)->A1_BAIRRO))
										cStringExp += '<xBairro>BAIRRO NAO CADASTRADO</xBairro>'
									Else
										cStringExp += '<xBairro>' + NoAcentoCte( (cAliasCol)->A1_BAIRRO ) + '</xBairro>'
									EndIf
									cStringExp += '<cMun>' + NoAcentoCte( AllTrim(cCodUFOri) + AllTrim((cAliasCol)->A1_COD_MUN) ) + '</cMun>'
									cStringExp += '<xMun>' + NoAcentoCte( (cAliasCol)->A1_MUN ) + '</xMun>'
									cStringExp += '<CEP>'  + NoAcentoCte( (cAliasCol)->A1_CEP ) + '</CEP>'
									cStringExp += '<UF>'   + NoAcentoCte( (cAliasCol)->A1_EST ) + '</UF>'
									If !Empty(AllTrim((cAliasCol)->A1_CODPAIS))
										cStringExp += '<cPais>'+ NoAcentoCte( RIGHT((cAliasCol)->A1_CODPAIS ,4 )) + '</cPais>'
										cStringExp += '<xPais>'+ NoAcentoCte( Posicione("CCH",1,xFilial("CCH")+(cAliasCol)->A1_CODPAIS,"CCH_PAIS") ) + '</xPais>'
									Else
										If !Empty(AllTrim((cAliasCol)->A1_PAIS))
											cStringExp += '<cPais>'+ NoAcentoCte( (cAliasCol)->A1_PAIS ) + '</cPais>'
											cStringExp += '<xPais>'+ NoAcentoCte( Posicione("SYA",1,xFilial("SYA")+(cAliasCol)->A1_PAIS,"YA_DESCR") ) + '</xPais>'
										EndIf
									EndIf
									cStringExp += '</enderExped>'
									cStringExp += '</exped>'
									
									(cAliasCol)->(DbCloseArea())
									lExpedOK := .T.
								EndIF
							EndIf								
						EndIf
					EndIf
				EndIf
				(cAliasDT5)->(DbCloseArea())			
		EndIf
					
		//-- Campo Expedidor Preenchido e tag <exped> nao preenchida.
		If !lExpedOK .And. !Empty(cCliExp+cLojExp)
			cAliasCol:= GetNextAlias()									                  
			cQuery := " SELECT A1_COD, A1_LOJA, A1_CGC, A1_PESSOA,A1_NOME, "
			cQuery += "	A1_END, A1_BAIRRO, A1_MUN, A1_EST, A1_CONTRIB, " 
			cQuery += "   A1_COD_MUN, A1_INSCR, A1_PAIS, A1_DDD, A1_TEL, A1_CEP,A1_COMPLEM, A1_CODPAIS "
			cQuery += "  FROM " + RetSqlName("SA1") + " SA1, "				
			cQuery += "  WHERE SA1.A1_FILIAL = '" + xFilial('SA1') + "'"						
			cQuery += "	 AND A1_COD = '" + cCliExp + "'"
			cQuery += "     AND A1_LOJA = '" + cLojExp + "'"
			cQuery += "     AND SA1.D_E_L_E_T_ = ' ' "						
			cQuery := ChangeQuery(cQuery)
			DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAliasCol,.T.,.T.)
			If !(cAliasCol)->(Eof())
				cStringExp := ""
				cStringExp += '<exped>'
				// Enderenco Solicitante DUL
				If aScan(aUF,{|x| x[1] == (cAliasCol)->(A1_EST) }) != 0   //Confere se Uf do End.Solicitante esta OK
					cCodUFOri  := aUF[ aScan(aUF,{|x| x[1] == (cAliasCol)->(A1_EST) }), 2]
				Else
					cCodUFOri  := ''
				EndIf
				If (AllTrim((cAliasCol)->(A1_PESSOA)) == "J")
					cStringExp += '<CNPJ>' + NoPontos((cAliasCol)->A1_CGC) + '</CNPJ>'
				Else
					cStringExp += '<CPF>' + AllTrim((cAliasCol)->A1_CGC) + '</CPF>'
				EndIf
							
				If (cAliasCol)->A1_CONTRIB == '1'
					If 'ISENT' $ Upper(AllTrim((cAliasCol)->A1_INSCR))
						cStringExp += '<IE>ISENTO</IE>'
					Else
						cStringExp += '<IE>' + NoPontos((cAliasCol)->A1_INSCR) + '</IE>'
					EndIf
				EndIf
				If cAmbiente == '2'  //--Homologacao / Nota Técnica 2012/005 
					cStringExp += '<xNome>' + (SubStr('CTE EMITIDO EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL',1,60)) + '</xNome>'
				Else
					cStringExp += '<xNome>' + NoAcentoCte(SubStr((cAliasCol)->A1_NOME,1,60)) + '</xNome>'
				EndIf
								
				If !Empty((cAliasCol)->A1_TEL)
					cStringExp += '<fone>' + cValtoChar(NoPontos((cAliasCol)->A1_DDD)) +;
					cValtoChar(NoPontos((cAliasCol)->A1_TEL)) + '</fone>'
				EndIf
								
				cStringExp += '<enderExped>'
				cStringExp += '<xLgr>' + NoAcentoCte(FisGetEnd((cAliasCol)->A1_END)[1]) + '</xLgr>'
				cStringExp += '<nro>' + Iif(FisGetEnd((cAliasCol)->A1_END)[2] <> 0, AllTrim(cValtoChar( FisGetEnd((cAliasCol)->A1_END)[2])),"S/N") + '</nro>'
				If !Empty(NoAcentoCte(FisGetEnd((cAliasCol)->A1_COMPLEM)[4]))
					cStringExp += '<xCpl>' + NoAcentoCte(FisGetEnd((cAliasCol)->A1_COMPLEM)[4]) + '</xCpl>'
				EndIf
				If Empty(AllTrim((cAliasCol)->A1_BAIRRO))
					cStringExp += '<xBairro>BAIRRO NAO CADASTRADO</xBairro>'
				Else
					cStringExp += '<xBairro>' + NoAcentoCte( (cAliasCol)->A1_BAIRRO ) + '</xBairro>'
				EndIf
				cStringExp += '<cMun>' + NoAcentoCte( AllTrim(cCodUFOri) + AllTrim((cAliasCol)->A1_COD_MUN) ) + '</cMun>'
				cStringExp += '<xMun>' + NoAcentoCte( (cAliasCol)->A1_MUN ) + '</xMun>'
				cStringExp += '<CEP>'  + NoAcentoCte( (cAliasCol)->A1_CEP ) + '</CEP>'
				cStringExp += '<UF>'   + NoAcentoCte( (cAliasCol)->A1_EST ) + '</UF>'
				If !Empty(AllTrim((cAliasCol)->A1_CODPAIS))
					cStringExp += '<cPais>'+ NoAcentoCte( RIGHT((cAliasCol)->A1_CODPAIS ,4 )) + '</cPais>'
					cStringExp += '<xPais>'+ NoAcentoCte( Posicione("CCH",1,xFilial("CCH")+(cAliasCol)->A1_CODPAIS,"CCH_PAIS") ) + '</xPais>'									
				Else		
					If !Empty(AllTrim((cAliasCol)->A1_PAIS))
						cStringExp += '<cPais>'+ NoAcentoCte( (cAliasCol)->A1_PAIS ) + '</cPais>'
						cStringExp += '<xPais>'+ NoAcentoCte( Posicione("SYA",1,xFilial("SYA")+(cAliasCol)->A1_PAIS,"YA_DESCR") ) + '</xPais>'
					EndIf
				EndIF
				cStringExp += '</enderExped>'
				cStringExp += '</exped>'
								
				(cAliasCol)->(DbCloseArea())
			EndIf
		EndIf
		cResult := cStringExp
Return cResult
