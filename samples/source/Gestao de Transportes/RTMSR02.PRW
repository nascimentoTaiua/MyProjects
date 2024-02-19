#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH" 
#INCLUDE "RTMSR02.CH"
#INCLUDE "FWPrintSetup.ch"

//---------------------------------------------------------------------------------------
/*/{Protheus.doc} RTMSR02()
Impressao do Relatório de conferencia de Coleta
@protected
@author 		TOTVS      
@since         30/12/2014
@version       P12.1.7
/*/
//---------------------------------------------------------------------------------------
#DEFINE DMPAPER_A4 9
#DEFINE IMP_PDF    6 

Static lTMAF76Imp := (Type("__VPRINTSC") != "U" .And. (IsInCallStack("TMSAF76") .Or. IsInCallStack("TMSF76EXE")))

User Function RTMSR02()

Local cPerg			:= 'RTMR02' 
Local lAdjustToLegacy 	:= .F.

Private nLin      := 0
//-- Fontes utilizadas no relatório
Private nLargLin	:= "-1"
Private oFont06	:= TFont():New("Arial",06,06,,.F.,,,,.T.,.F.)
Private oFont10	:= TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)
Private oFont10N	:= TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)
Private OPRINT 

If IsInCallStack('TMSA460')
	If !Pergunte(cPerg,.T.,,,,.F.)
		Return()
	EndIf 
Else
     If lTMAF76IMP          //-- Impressao via Painel apenas pergunta se deseja imprimir, sem abrir dialog do pergunte() 
          
          If Len(__VPRINTSC) > 0
               
               Pergunte(cPerg,.F.)
               
               If Len(__VPRINTSC) > 1
                    ASort(__VPRINTSC,,,{|x,y| x[2] < y[2] })
               EndIf

               MV_PAR01 := __VPRINTSC[1][2]
               MV_PAR02 := __VPRINTSC[Len(__VPRINTSC)][2]
               If Aviso("Atenção","Deseja Imprimir as solicitações de: " + MV_PAR01 + " à " + MV_PAR02 + " ?",{"SIM","NAO"}) == 2
                    Return
               EndIf
          ELSE
               lTMAF76IMP := .F.
          EndIf
     EndIf
     If !lTMAF76IMP
	     If !Pergunte(cPerg,.T.)
		    Return()
	     EndIf
	EndIf 
EndIF

RptStatus({|| MontaRel(@oPrint)})

If ValType(oPrint) == 'O'
	oPrint:Print()
Else
	MsgAlert(STR0038) //--"Não há dados disponíveis para impressão."  
EndIf 

TRBDT5->(DbCloseArea())
Return

//---------------------------------------------------------------------------------------
/*/{Protheus.doc} MontaRel(oPrint)
Impressao do Relatório de conferencia de Coleta
@protected
@author       TOTVS
@since        30/12/2014 
@version      P12.1.7 
/*/
//---------------------------------------------------------------------------------------
Static Function MontaRel(oPrint)
Local x				:= 0
Local cFilePrint 		:= ""
//--Solicitante
Local cNomeSol		:= ""
Local cCNPJSol       := ""
Local cEndSol        := ""
Local cBairSol       := ""
Local cCidSol	       := ""
Local cCepSol			:= ""
Local cDDDSol			:= ""
Local cFoneSol       := ""
// -- Observacao
Local cOBS				:= ""
//--Destinatário
Local cNomeDes		:= "" 
Local cCNPJDes       := ""
Local cEndDes        := ""
Local cBairDes       := ""
Local cCidDes        := ""
Local cCepDes			:= ""
Local cDDDDes			:= ""
Local cFoneDes       := ""
//--Devedor
Local cNomeDev		:= ""
Local cCNPJDev		:= ""
Local cEndDev			:= ""
Local cBairDev		:= ""
Local cCidDev			:= ""
Local cCepDev			:= ""
Local cDDDDev			:= ""
Local cFoneDev		:= ""

Local nLin    		:= 0002
Local cStartPath 		:= GetSrvProfString("Startpath","")
Local cLogoTp   		:= cStartPath + "logoCte" + cEmpAnt + ".BMP" //Insira o caminho do Logo da empresa logada, na variavel cLogoTp. 


If	IsSrvUnix() .And. GetRemoteType() == 1
	cLogoTp := StrTran(cLogoTp,"/","\")
Endif

If  !File(cLogoTp)
	cLogoTp    := cStartPath + "logoCte.bmp"
EndIf


PesqCol() //Query com informações para impressão da Coleta

SM0->(dbSeek (cEmpAnt + cFilant))
If TRBDT5->(!EOF())
	//Cria o Objeto OPrint
	cFilePrint 	 	:= "COLETA_"+cEmpAnt+"_"+cFilAnt+"_"+Dtos(MSDate())+"_"+StrTran(Time(),":","")
	lAdjustToLegacy 	:= .F.
	oPrint	    		:= FWMSPrinter():New(cFilePrint, IMP_PDF, .F., /*cStartPath*/ , .F.,,@oPrint)
	oPrint:SetResolution(72) 
	oPrint:SetPortrait()
	oPrint:SetPaperSize(DMPAPER_A4)
	oPrint:SetMargin(03,04,03,03)
	oPrint:cPathPDF:= GetTempPath(.T.) // Gera o arquivo na pasta TEMP 
	
EndIf

While TRBDT5->(!EOF())  

     //--valida se SC está fora da "white list" de impressao
     If lTMAF76Imp
          If AScan(__VPrintSC,{|M| M[1] + M[2] + M[3] == TRBDT5->(DT5_FILDOC + DT5_NUMSOL + DT5_SERIE) }) == 0
               TRBDT5->(DbSkip())
               Loop
          EndIf
     EndIf
     
	oPrint:StartPage() 
	
	nLin:= 0002
	//--Pesquisa o Solicitante
	If Empty(TRBDT5->DT5_SEQEND)
		DUE->(DbSetOrder(1))
		DUE->(DbSeek(xFilial('DUE') + TRBDT5->DT5_CODSOL))
		cNomeSol	:= DUE->DUE_NOME
		cCNPJSol  	:= DUE->DUE_CGC
		cEndSol   	:= DUE->DUE_END
		cBairSol 	:= DUE->DUE_BAIRRO
		cCidSol	:= DUE->DUE_MUN
		cCepSol	:= DUE->DUE_CEP
		cDDDSol	:= DUE->DUE_DDD
		cFoneSol  	:= DUE->DUE_TEL
	Else		
		DUL->(DbSetOrder(3))
		DUL->(DbSeek(xFilial('DUL') + TRBDT5->DT5_CODSOL+TRBDT5->DT5_SEQEND))
		If !Empty(DUL->DUL_NOMRED)
			cNomeSol	:= DUL->DUL_NOMRED
			cCNPJSol  	:= DUL->DUL_CGC
			cEndSol   	:= DUL->DUL_END
			cBairSol 	:= DUL->DUL_BAIRRO
			cCidSol	:= DUL->DUL_MUN
			cCepSol	:= DUL->DUL_CEP
			cDDDSol	:= DUL->DUL_DDD
			cFoneSol  	:= DUL->DUL_TEL
		Else
			cEndSol   	:= DUL->DUL_END
			cBairSol  	:= DUL->DUL_BAIRRO
			cCidSol 	:= DUL->DUL_MUN
			cCepSol 	:= DUL->DUL_CEP
			cDDDSol	:= DUL->DUL_DDD
			cFoneSol  	:= DUL->DUL_TEL
			DUE->(DbSetOrder(1))
			DUE->(DbSeek(xFilial('DUE') + TRBDT5->DT5_CODSOL))
			cNomeSol 	:= DUE->DUE_NOME
			cCNPJSol  	:= DUE->DUE_CGC
		EndIf
	EndIf
	//--Pesquisa o Destinatario 
	If Empty(TRBDT5->DT5_SQEDES) 
		SA1->(DbSetOrder(1))
		SA1->(DbSeek(xFilial('SA1') + TRBDT5->DT5_CLIDES+TRBDT5->DT5_LOJDES))
		cNomeDes 	:= SA1->A1_NOME
		cCNPJDes  	:= SA1->A1_CGC
		cEndDes   	:= SA1->A1_END
		cBairDes 	:= SA1->A1_BAIRRO
		cCidDes   	:= SA1->A1_MUN
		cCepDes 	:= SA1->A1_CEP
		cDDDDes 	:= AllTrim(SA1->A1_DDD)
		cFoneDes  	:= AllTrim(SA1->A1_TEL)
	Else
		DUL->(DbSetOrder(2))
		DUL->(DbSeek(xFilial('DUL') + TRBDT5->DT5_CLIDES+TRBDT5->DT5_LOJDES+TRBDT5->DT5_SQEDES))
		If !Empty(DUL->DUL_NOMRED)
			cNomeDes 	:= DUL->DUL_NOMRED
			cCNPJDes  	:= DUL->DUL_CGC
			cEndDes   	:= DUL->DUL_END
			cBairDes  	:= DUL->DUL_BAIRRO
			cCidDes 	:= DUL->DUL_MUN
			cCepDes 	:= DUL->DUL_CEP
			cDDDDes 	:=  AllTrim(DUL->DUL_DDD)
			cFoneDes  	:=  AllTrim(DUL->DUL_TEL)
		Else 
			SA1->(DbSetOrder(1))
			SA1->(DbSeek(xFilial('SA1') + TRBDT5->DT5_CLIDES+TRBDT5->DT5_LOJDES))
			cNomeDes 	:= SA1->A1_NOME
			cCNPJDes  	:= SA1->A1_CGC
			cEndDes   	:= DUL->DUL_END
			cBairDes  	:= DUL->DUL_BAIRRO
			cCidDes 	:= DUL->DUL_MUN
			cCepDes 	:= DUL->DUL_CEP
		EndIf
	EndIf
	
	//--Pesquisa o Devedor
	If !Empty(TRBDT5->DT5_CLIDEV)  
		SA1->(DbSetOrder(1))
		SA1->(DbSeek(xFilial('SA1') + TRBDT5->DT5_CLIDEV+TRBDT5->DT5_LOJDES))
		cNomeDev	:= SA1->A1_NOME
		cCNPJDev	:= SA1->A1_CGC
		cEndDev	:= SA1->A1_END
		cBairDev	:= SA1->A1_BAIRRO
		cCidDev	:= SA1->A1_MUN
		cCepDev	:= SA1->A1_CEP
		cDDDDev	:= AllTrim(SA1->A1_DDD)
		cFoneDev	:= AllTrim(SA1->A1_TEL)
	EndIf
	
	cOBS := StrTran(MsMM( TRBDT5->DT5_CODOBS,80),Chr(13)," ") 
	cOBS := StrTran(cOBS, Chr(10)," ") 
	
	For x:=1 To 2 // PERMITE IMPRIMIR DUAS VEZES O RELATÓRIO NA MESMA PAGINA.
		oPrint:Box( nLin+0000, 0010, nLin+0064, 0128 ) 
		oPrint:Box( nLin+0000, 0128, nLin+0064, 0482 )    
		oPrint:SayBitmap( nLin+0015, 0030, cLogoTp,80,20 ) // LOGOTIPO 
		oPrint:Say( nLin+0048, 0035, Alltrim(STR(X))+ STR0002, oFont06) //-- ªVIA - COLETA
		
		//--DADOS DA TRANSPORTADORA - SM0
		oPrint:Say( nLin+0010, 0130, AllTrim(SM0->M0_NOMECOM)	,oFont10N) //0102
		oPrint:Say( nLin+0020, 0130, AllTrim(SM0->M0_ENDENT)		,oFont10)
		oPrint:Say( nLin+0030, 0130, AllTrim(SM0->M0_CIDENT)+"-"+AllTrim(SM0->M0_ESTENT),oFont10)
		oPrint:Say( nLin+0040, 0130, STR0003						,oFont10N) //--"Fone:"
		oPrint:Say( nLin+0040, 0170, Transform(AllTrim(SM0->M0_TEL),"@R (99) 999999999")	,oFont10) //0140
		oPrint:Say( nLin+0050, 0130, STR0004						,oFont10N) //--"CNPJ:"
		oPrint:Say( nLin+0050, 0170, Transform(AllTrim(SM0->M0_CGC),"@r 99.999.999/9999-99" ),oFont10)
		oPrint:Say( nLin+0020, 0331, STR0005						,oFont10N) //--"Bairro:"
		oPrint:Say( nLin+0020, 0371, AllTrim(SM0->M0_BAIRENT)	,oFont10)
		oPrint:Say( nLin+0030, 0331, STR0006						,oFont10N) //--"Cep:"
		oPrint:Say( nLin+0030, 0371, AllTrim(SM0->M0_CEPENT)		,oFont10)
		oPrint:Say( nLin+0040, 0331, STR0007						,oFont10N) //--"Fax:"
		oPrint:Say( nLin+0040, 0371, Transform(AllTrim(SM0->M0_FAX),"@R (99) 999999999")	,oFont10)
		oPrint:Say( nLin+0050, 0331, STR0008						,oFont10N) //--"Inscr.Est:"	
		oPrint:Say( nLin+0050, 0371, AllTrim(SM0->M0_INSC)		,oFont10)
		
		//--NUMERO DA SOL. COLETA | ROTA PREVISTA | EMISSAO | DATA PREV. COLETA | EFETUAR COLETA AS
		oPrint:Box( nLin+0000, 0460, nLin+0064, 0582 ) //      
		oPrint:Box( nLin+0012, 0460, nLin+0024, 0582 )
		oPrint:Say( nLin+0010, 0462, STR0009						,oFont10N) //--"Sol. Coleta:"
		oPrint:Say( nLin+0010, 0530, AllTrim(TRBDT5->DT5_NUMSOL),oFont10)
	   	oPrint:Say( nLin+0022, 0462, STR0010						,oFont10N) //--"Rota Prevista:"	
	   oPrint:Say( nLin+0022, 0530, AllTrim(TRBDT5->DT5_ROTPRE)	,oFont10)
		oPrint:Say( nLin+0032, 0462, STR0011						,oFont10) //--"Emissão:"
		oPrint:Say( nLin+0032, 0540, Transform(STOD(TRBDT5->DT5_DATSOL),"@D")	,oFont10)
		oPrint:Say( nLin+0042, 0462, STR0012						,oFont10) //--"Data Prev. Coleta:"
		oPrint:Say( nLin+0042, 0540, Transform(STOD(TRBDT5->DT5_DATPRV),"@D")	,oFont10)
		oPrint:Say( nLin+0052, 0462, STR0013						,oFont10) //--"Efetuar Coleta as:"
		oPrint:Say( nLin+0052, 0540, Transform(TRBDT5->DT5_HORPRV,"@R 99:99")	,oFont10)
		///
		//====================================================================
		nLin += 0054         //Inicio  //Linha  //FIm
		oPrint:Box( nLin+0000, 0010, nLin+0014, 0582 ,nLargLin)
		oPrint:Say( nLin+0010, 0220, STR0001	, oFont10N) //-- ORDEM DE COLETA DE CARGAS
		oPrint:Box( nLin+0014, 0010, nLin+0168, 0291 ,nLargLin)
		oPrint:Box( nLin+0014, 0291, nLin+0168, 0582 	,nLargLin)
		
		//--DADOS SOLICITANTE
		oPrint:Say( nLin+0022, 0012, STR0014 + Space(2) + (cNomeSol) ,oFont10N)//--"SOLICITANTE:"
		oPrint:Say( nLin+0036, 0012, STR0004						 ,oFont10N) //--"CNPJ"
		oPrint:Say( nLin+0036, 0062, Transform(AllTrim(cCNPJSol) ,"@r 99.999.999/9999-99") 	 ,oFont10)
		oPrint:Say( nLin+0048, 0012, STR0015						 ,oFont10N) //--"Endereço"
		oPrint:Say( nLin+0048, 0062, Alltrim(cEndSol)				 ,oFont10)
		oPrint:Say( nLin+0060, 0012, STR0005						 ,oFont10N) //--"Bairro" 
		oPrint:Say( nLin+0060, 0062, Alltrim(cBairSol)			 ,oFont10)
		oPrint:Say( nLin+0060, 0190, STR0006						 ,oFont10N) //--"Cep:"
		oPrint:Say( nLin+0060, 0230, Transform(AllTrim(cCepSol), "@r 99999-999")				 ,oFont10)
		oPrint:Say( nLin+0072, 0012, STR0016						 ,oFont10N) //--"Cidade:"
		oPrint:Say( nLin+0072, 0062, Alltrim(cCidSol)   			 ,oFont10)
		oPrint:Say( nLin+0072, 0190, STR0003						 ,oFont10N) //--"Fone:"
		oPrint:Say( nLin+0072, 0230, "("+Alltrim(cDDDSol)+") "+Alltrim(cFoneSol),oFont10)
		oPrint:Box( nLin+0026, 0010, nLin+0026, 0291 ,nLargLin)
		oPrint:Box( nLin+0026, 0291, nLin+0026, 0582 ,nLargLin)
		 
		//--DADOS CODIGO DE BARRAS
		oPrint:Say( nLin+0022, 0293, STR0017 ,oFont10N) //--"CHAVE:"
		oPrint:Say( nLin+0022, 0351, AllTrim(TRBDT5->DT6_CHVCTE) ,oFont10)
		oPrint:Code128C(nLin+0072, 0310,(TRBDT5->DT6_CHVCTE),35)
		
		//--DESTINATARIO	
		oPrint:Box( nLin+0090, 0010, nLin+0102, 0582 ,nLargLin)
		oPrint:Say( nLin+0100, 0012, STR0018 + Space(2) + (cNomeDes)	,oFont10N) //--"DESTINATÁRIO:"
		oPrint:Say( nLin+0114, 0012, STR0004 					,oFont10N) //--"CNPJ:"
		oPrint:Say( nLin+0114, 0062, Transform(AllTrim(cCNPJDes),"@r 99.999.999/9999-99")	, oFont10)
		oPrint:Say( nLin+0126, 0012, STR0015					,oFont10N) //--"Endereço:"
		oPrint:Say( nLin+0126, 0062, AllTRIM(cEndDes)			,oFont10)
		oPrint:Say( nLin+0138, 0012, STR0005					,oFont10N) //--"Bairro:"
		oPrint:Say( nLin+0138, 0062, AllTRIM(cBairDes)		,oFont10)
		oPrint:Say( nLin+0138, 0190, STR0006					,oFont10N) //--"Cep:"
		oPrint:Say( nLin+0138, 0230, Transform(AllTrim(cCepDes),"@r 99999-999" )				,oFont10)
		oPrint:Say( nLin+0150, 0012, STR0016					,oFont10N) //--"Cidade:"
		oPrint:Say( nLin+0150, 0062, Alltrim(cCidDes)			,oFont10) 
		oPrint:Say( nLin+0150, 0190, STR0003					,oFont10N) //--"Fone:"
		oPrint:Say( nLin+0150, 0230, "("+cDDDDes+") "+cFoneDes  ,oFont10)
		
		//--DEVEDOR  
		oPrint:Box( nLin+0090, 0291, nLin+0102, 0582 			,nLargLin)
		oPrint:Say( nLin+0100, 0293, STR0019 + Space(2) + (cNomeDev)	,oFont10N) //--"DEVEDOR:"
		oPrint:Say( nLin+0114, 0293, STR0004					,oFont10N)//--"CNPJ:"
		oPrint:Say( nLin+0114, 0343, Transform(AllTrim(cCNPJDev),"@r 99.999.999/9999-99" )	,oFont10)
		oPrint:Say( nLin+0126, 0293, STR0015					,oFont10N) //--"Endereço:"
		oPrint:Say( nLin+0126, 0343, AllTRIM(cEndDev)		  	,oFont10)
		oPrint:Say( nLin+0138, 0293, STR0005					,oFont10N) //--"Bairro:"	
		oPrint:Say( nLin+0138, 0343, AllTRIM(cBairDev)		,oFont10)
		oPrint:Say( nLin+0138, 0471, STR0006					,oFont10N) //--"Cep:"
		oPrint:Say( nLin+0138, 0511, Transform(AllTrim(cCepDev),"@r 99999-999") 				,oFont10)
		oPrint:Say( nLin+0150, 0293, STR0016					,oFont10N) //--"Cidade:"
		oPrint:Say( nLin+0150, 0343, AllTRIM(cCidDev)			,oFont10)
		oPrint:Say( nLin+0150, 0471, STR0003					,oFont10N) //--"Fone:"
		oPrint:Say( nLin+0150, 0511, "("+cDDDDev+")"+cFoneDev	,oFont10) 
		
		//--PREVISAO DE ENTREGA|HORA PREVISTA|VOLUME PREVISTO|PESO PREVISTO|M3 PREVISTO 
		oPrint:Box( nLin+0168, 0010, nLin+0180, 0582 ,nLargLin)
		
		//--PREVISÃO ENTREGA
		oPrint:Box( nLin+0168, 0010, nLin+0180, 0116 ,nLargLin)
		oPrint:Box( nLin+0180, 0010, nLin+0192, 0116 ,nLargLin)
		oPrint:Say( nLin+0178, 0012, STR0020, oFont10N) //--"PREVISÃO DE ENTREGA"
		oPrint:Say( nLin+0190, 0012, Transform(STOD(TRBDT5->DT5_DATENT),"@D") , oFont10)
		//--HORA PREVISTA DE ENTREGA
		oPrint:Box( nLin+0168, 0116, nLin+0180, 0232 ,nLargLin)
		oPrint:Box( nLin+0180, 0116, nLin+0192, 0232 ,nLargLin)
		oPrint:Say( nLin+0178, 0118, STR0021,oFont10N) //--"HORA PREVISTA ENTREGA"
		oPrint:Say( nLin+0190, 0118, Transform(TRBDT5->DT5_HORENT,"@R 99:99"),oFont10)
		//--VOLUME PREVISTO
		oPrint:Box( nLin+0168, 0232, nLin+0180, 0348 ,nLargLin)
		oPrint:Box( nLin+0180, 0232, nLin+0192, 0348 ,nLargLin)
		oPrint:Say( nLin+0178, 0234, STR0022, oFont10N) //--"VOLUME PREVISTO"
		oPrint:Say( nLin+0190, 0234, Transform(TRBDT5->DT6_QTDVOL,"@!"),oFont10)
		//--PESO
		oPrint:Box( nLin+0168, 0348, nLin+0180, 0464 ,nLargLin)
		oPrint:Box( nLin+0180, 0348, nLin+0192, 0464 ,nLargLin)
		oPrint:Say( nLin+0178, 0350, STR0023, oFont10N) //--"PESO PREVISTO"
		oPrint:Say( nLin+0190, 0350, Transform(TRBDT5->DT6_PESO,"@E 999,999.9999")		,oFont10)
		//--PESO CUBADO PREVISTO
		oPrint:Box( nLin+0168, 0464, nLin+0180, 0582 ,nLargLin)
		oPrint:Box( nLin+0180, 0464, nLin+0192, 0582 ,nLargLin)
		oPrint:Say( nLin+0178, 0466, STR0024	,oFont10N) //--"PESO CUBADO PREVISTO"
		oPrint:Say( nLin+0190, 0466, Transform(TRBDT5->DT6_PESOM3,"@E 999,999.9999"), oFont10)
		
		//--DADOS DA CARGA
		oPrint:Box( nLin+0192, 0010, nLin+0204, 0582 ,nLargLin)
		oPrint:Say( nLin+0202, 0264, STR0025	,oFont10N) //--"DADOS DA CARGA"
		
		//--PRODUTO
		oPrint:Box( nLin+0204, 0010, nLin+0216, 0144 ,nLargLin)
		oPrint:Box( nLin+0216, 0010, nLin+0228, 0144 ,nLargLin)
		oPrint:Say( nLin+0214, 0012, STR0026, oFont10N) //--"PRODUTO"
		oPrint:Say( nLin+0226, 0012, STR0027, oFont10) //--"CONFORME NF CLIENTE"  
		
		//--EMBALAGEM
		oPrint:Box( nLin+0204, 0144, nLin+0216, 0216 ,nLargLin)
		oPrint:Box( nLin+0216, 0144, nLin+0228, 0216 ,nLargLin)
		oPrint:Say( nLin+0214, 0146, STR0028, oFont10N) //--"EMBALAGEM"		
		DUM->(dbSetOrder(1))
		DUM->(MsSeek(xFilial("DUM")+TRBDT5->(DT5_FILORI+DT5_NUMSOL)))
		oPrint:Say( nLin+0226, 0146, Alltrim(DUM->DUM_CODEMB), oFont10)
		
		//--VOLUME REAL
		oPrint:Box( nLin+0204, 0216, nLin+0216, 0288 ,nLargLin)
		oPrint:Box( nLin+0216, 0216, nLin+0228, 0288 ,nLargLin)
		oPrint:Say( nLin+0214, 0218, STR0029, oFont10N) //--"VOLUME REAL"
		//oPrint:Say( nLin+0226, 0218, Transform(TRBDT5->DT6_QTDVOL,"@!") ,oFont10)
		
		//--PESO REAL
		oPrint:Box( nLin+0204, 0288, nLin+0216, 0360 ,nLargLin)
		oPrint:Box( nLin+0216, 0288, nLin+0228, 0360 ,nLargLin)
		oPrint:Say( nLin+0214, 0290, STR0030, oFont10N) //--"PESO REAL"
		//oPrint:Say( nLin+0226, 0290, Transform(TRBDT5->DT6_PESO,"@E 999,999.9999")	,oFont10)//
		
		//--VALOR REAL
		oPrint:Box( nLin+0204, 0360, nLin+0216, 0582 ,nLargLin)
		oPrint:Box( nLin+0216, 0360, nLin+0228, 0582 ,nLargLin)
		oPrint:Say( nLin+0214, 0362, STR0031, oFont10N) //--"VALOR REAL"	
		// oPrint:Say( nLin+0226, 0506, Transform(TRBDT5->DT6_VALMER,"@E 999,999.9999")	,oFont10)
		
		//--OBSERVAÇÃO:
		oPrint:Box( nLin+0228, 0010, nLin+0270, 0582 ,nLargLin)
		oPrint:Box( nLin+0270, 0010, nLin+0316, 0291 ,nLargLin)
		oPrint:Box( nLin+0270, 0291, nLin+0316, 0582 ,nLargLin)
		oPrint:Say( nLin+0240, 0012, STR0032, oFont10N) //--"OBS:"
		oPrint:Say( nLin+0240, 0062, AllTrim(cOBS), oFont10)
		
		//|DATA|HR.CHEGADA|DATA|H.SAIDA|RECEBIMENTOS
		
		//|DATA|
		oPrint:Box( nLin+0270, 0010, nLin+0282, 0072 ,nLargLin)
		oPrint:Say( nLin+0280, 0012, STR0033, oFont10N) //--"DATA"
		oPrint:Box( nLin+0282, 0010, nLin+0306, 0072 ,nLargLin)
		//|HR.CHEGADA|
		oPrint:Box( nLin+0270, 0072, nLin+0282, 0144 ,nLargLin)
		oPrint:Say( nLin+0280, 0074, STR0034, oFont10N) //--"HR.CHEGADA"
		oPrint:Box( nLin+0282, 0072, nLin+0306, 0144 ,nLargLin)
		//|DATA|
		oPrint:Box( nLin+0270, 0144, nLin+0282, 0216 ,nLargLin)
		oPrint:Say( nLin+0280, 0146, STR0033, oFont10N) //--"DATA"
		oPrint:Box( nLin+0282, 0144, nLin+0306, 0216 ,nLargLin)
		//|H.SAIDA|
		oPrint:Box( nLin+0270, 0216, nLin+0282, 0291 ,nLargLin)
		oPrint:Say( nLin+0280, 0218, STR0035, oFont10N) //--"HR.SAIDA"
		oPrint:Box( nLin+0282, 0216, nLin+0306, 0291 ,nLargLin)
		
		oPrint:Box( nLin+0270, 0291, nLin+0282, 0582 ,nLargLin)
		oPrint:Say( nLin+0280, 0300,STR0036 ) //--"RECEBI(EMOS) A(S) MERCADORIA(S) EM PERFEITA ORDEM"
		
		oPrint:Line( nLin+0306 ,0310 , nLin+0306, 0562 )   
		oPrint:Say( nLin+0314,  0410,STR0037) //--"ASSINATURA"
		nLin:= 0430
	Next	
	
	If FindFunction('TmsVLDSIX') .And. TmsVLDSIX("DT6","I")
		//-- Atualiza o Status de Impressão da Sol. de Coleta
		DT6->(dbSetOrder(18)) //DT6_FILIAL+DT6_CHVCTE
		If	DT6->(MsSeek(xFilial('DT6')+ TRBDT5->DT6_CHVCTE))
			RecLock('DT6',.F.)
			DT6->DT6_FIMP := StrZero(1, Len(DT6->DT6_FIMP)) //Grava Flag de Impressao
			MsUnLock()
		EndIf
	EndIf	
	
	TRBDT5->(DbSkip())
	oPrint:EndPage()
Enddo	

Return


//---------------------------------------------------------------------------------------
/*/{Protheus.doc} PesqCol()
Query com as informações da Solicitação de Coleta
@author    TOTVS   
@since     30/12/2014    
@version   P12.1.7
/*/
//---------------------------------------------------------------------------------------
Static Function PesqCol()

Local cQuery  := ""	
	
	cQuery := " SELECT * " 
	cQuery += " FROM "  
	cQuery += + RetSqlName("DT5") +  " DT5, " 
	cQuery += + RetSqlName("DT6") +  " DT6 "	   
	cQuery += " WHERE " 
	cQuery += " DT5.DT5_NUMSOL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND "
	cQuery += " DT5.DT5_FILIAL = '"+xFilial("DT5")+"' AND" 
	cQuery += " DT5.D_E_L_E_T_ = ' ' AND " 
	cQuery += " DT5.DT5_STATUS <> '9' AND "
	cQuery += " DT6.DT6_FILIAL = '"+xFilial("DT6")+"' AND" 
	cQuery += " DT6.D_E_L_E_T_ = ' ' AND " 
	cQuery += " DT6.DT6_DOC    = DT5.DT5_NUMSOL  AND " 
	cQuery += " DT6.DT6_FILDOC = DT5.DT5_FILORI  AND " 
	cQuery += " DT6.DT6_SERIE  = DT5.DT5_SERIE   "
		
	cQuery = ChangeQuery(cQuery)
	DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),'TRBDT5',.T.,.T.)
Return	
	 
