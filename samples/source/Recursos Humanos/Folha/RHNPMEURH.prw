#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "RESTFUL.CH"
#INCLUDE "FWPRINTSETUP.CH" 
#INCLUDE "RPTDEF.CH"

#INCLUDE "RHNPMEURH.CH"


/*/{Protheus.doc}RHNPMEURH
   - Funções que possibilitam customizações futuras pelos clientes MeuRH;
/*/

User Function NoticeVacationReport( aDados, cLocal, cFileName )
Local oPrint
Local lRet        := .T.
Local nLin        := 0
Local nSizePage   := 0
Local nTamMarg    := 25
Local cArqLocal   := ""
Local oFont12n    := TFont():New("Arial",12,12,,.T.,,,,.T.,.F.)	//Normal negrito
Local oFont10     := TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)	//Normal s/ negrito

Default aDados    := {} //informações para a geração do recibo
Default cLocal    := "" //local para a gravação do arquivo
Default cFileName := "" //nome do arquivo pdf esperado na saida


//Informações sobre a estrutura esperada do array de dados
// aDados[1]  = tipo do aviso            (P=programado) (F=Férias) 
// aDados[2]  = cCompanyState            (estado federativo da empresa)
// aDados[3]  = dNoticeDate              (data do aviso)
// aDados[4]  = cEmployeeName            (nome do funcionário)
// aDados[5]  = cLaborCardNumber         (carteira de trabalho)
// aDados[6]  = cLaborCardSeries         (série da carteira de trabalho) 
// aDados[7]  = cDepartmentDescription   (descrição do departamento)
// aDados[8]  = nPaydLeaveFollow         (dias de licença remunerada mês seguinte - férias calculadas)
// aDados[9]  = nPaydLeave               (dias de licença remunerada - férias calculadas)
// aDados[10] = dAcquisitiveStartDate   (data de inicio do período aquisitivo)
// aDados[11] = dAcquisitiveEndDate     (data de término do período aquisitivo)
// aDados[12] = dEnjoymentStart         (data de inicio do gozo de férias)
// aDados[13] = dEnjoymentEndDate       (data de término do gozo de férias)
// aDados[14] = cCompanyName            (nome descritivo da empresa)
// aDados[15] = cCompanyCNPJ            (CNPJ da empresa)
// aDados[16] = nPecuniaryAllowance     (dias de abono pecuniário - férias calculadas/programadas)
// aDados[17] = cAccept                 (informações do aceite - férias calculadas)
// aDados[18] = cBranch                 (filial do funcionário)
// aDados[19] = cMat                    (matricula do funconário)
// aDados[20] = cAdmissionDate          (admissão do funconário)
// aDados[21] = cReceiptDate            (data do recibo)


If valtype(aDados) != "A" .or. len(aDados) <> 21 .or. empty(cFileName)
   lRet := .F.
EndIf

//geração do html para o recibo de férias
If lRet

	oPrint := FWMSPrinter():New(cFileName+".rel", IMP_PDF, .F., cLocal, .T., , , , .T., , .F., )
	
	oPrint:SetPortrait()
    oPrint:SetPaperSize(DMPAPER_A4)
	oPrint:SetMargin(nTamMarg,nTamMarg,nTamMarg,nTamMarg)
	oPrint:StartPage()

	nSizePage := oPrint:nPageWidth / oPrint:nFactorHor

	nLin += 50
	oPrint:SayAlign(nLin, 0, OemToAnsi(STR0001), oFont12n, 550, , , 2, 0) //"Aviso de Férias"
	nLin += 20	
	oPrint:Line(nLin, 15, nLin, nSizePage-(nTamMarg*2))
	
	nLin += 50
	cMsgLine := AllTrim(aDados[2]) +', ' +SubStr(DtoC( aDados[3] ),1,2) +STR0002 +MesExtenso(Month(aDados[3])) +STR0002 +STR(Year(aDados[3]),4) 
	oPrint:Say(nLin, 15, cMsgLine, oFont10) 

	nLin += 40		
	cMsgLine := STR0003 //"A(o) Sr(a)" 
	oPrint:Say(nLin, 15, cMsgLine, oFont10) 
	nLin += 15		
	cMsgLine := Left(aDados[4],30) 
	oPrint:Say(nLin, 15, cMsgLine, oFont10) 
	nLin += 10		
	cMsgLine := STR0004 +aDados[5] +' - ' +aDados[6] +SPACE(8) +STR0005 +aDados[7]  //"CTPS: " / "Depto: "
	oPrint:Say(nLin, 15, cMsgLine, oFont10) 

	nLin += 40		
	oPrint:Say(nLin, 15, STR0006 +" " +STR0007, oFont10)  //"Nos termos da legislação vigente, suas férias serão" "concedidas conforme as informações abaixo:"

    If aDados[1] == "F" //Férias calculadas
       nLin += 15		
	   cMsgLine := STR0009 +Padr(DtoC(aDados[10]),10) +STR0013 +Padr(DtoC(aDados[11]),10) //"Período Aquisitivo: " " a "
	   oPrint:Say(nLin, 15, cMsgLine, oFont10)

       nLin += 10
       cMsgLine := STR0010 +Padr(DtoC(aDados[12]),10) +STR0013 +Padr(DtoC(aDados[13]),10) //"Período de Gozo: "  " a "
 	   oPrint:Say(nLin, 15, cMsgLine, oFont10)  

       If ( aDados[8] + aDados[9] ) > 0
          If aDados[9] == 30
              nLin += 10		
	          cMsgLine := STR0011 + CVALTOCHAR(aDados[8] + aDados[9]) //"Qtd Lic.remun.: " 
	          oPrint:Say(nLin, 15, cMsgLine, oFont10) 
          EndIf
       EndIf

    ElseIf aDados[1] == "P" //Férias programadas
        nLin += 15
	    cMsgLine := STR0010 +Padr(DtoC(aDados[12]),10) +STR0013 +Padr(DtoC(aDados[13]),10) //"Período de Gozo: "  " a "
	    oPrint:Say(nLin, 15, cMsgLine, oFont10)  
    EndIf

    nLin += 10
    cMsgLine := STR0015 + Padr(DtoC(aDados[13] + 1), 10) //"Retorno ao Trabalho: "
    oPrint:Say(nLin, 15, cMsgLine, oFont10)  

    //montagem para assinaturas
    nLin += 50
    cMsgLine := replicate("_",50)
    oPrint:SayAlign(nLin, 0, cMsgLine, oFont10, 550, , , 2, 0)  

    nLin += 15
    cMsgLine := aDados[14]
	oPrint:SayAlign(nLin, 0, cMsgLine, oFont10, 550, , , 2, 0)  

	nLin += 50
    cMsgLine := replicate("_",50) 
	oPrint:SayAlign(nLin, 0, cMsgLine, oFont10, 550, , , 2, 0) 

    nLin += 15
    cMsgLine := aDados[4]
	oPrint:SayAlign(nLin, 0, cMsgLine, oFont10, 550, , , 2, 0)  
		
	oPrint:EndPage()

	cArqLocal		:= cLocal+cFileName+".PDF"		
	oPrint:cPathPDF := cLocal 
	oPrint:lViewPDF := .F.
	oPrint:Print()

EndIf

Return(lRet)

/*/{Protheus.doc}RHNPMEURH
   - Funções que possibilitam customizações futuras pelos clientes MeuRH;
   - Geracao dos arquivos PDF no App MeuRH dos recibos de Ferias com ou Abono e 1a. Parcela do 13o. 
/*/
User Function VacationReport( aCabec, aVerbas, aInfo, cLocal, cFileName )

Local cValor1     := ""
Local cValor2     := ""
Local cPdPens     := ""
Local cRet1       := ""
Local cRet2       := ""
Local cEndEmp     := ""
Local cLocalEmp   := ""
Local cVerb13o    := "0022"

local lPage2      := .F.
Local nLin        := 0
Local nReg        := 0
Local nBenef      := 0
Local nPen13o     := 0
Local nVal13a     := 0
Local nVal13o     := 0
Local nValAb      := 0
Local nValAb13    := 0
Local nMaximo     := 0
Local nTotDesc    := 0
Local nTotProv    := 0
Local nLinAbI     := 0  //Linha inicial do Abono
Local nLinPcI     := 0  //Linha inicial do Parcela do 13o.
Local nLinPDI     := 0  //Linha inicial das verbas do recibo de ferias
Local nLinPDF     := 0  //Linha final impressao das verbas do recibo de ferias
Local nAligE      := 40 //Alinhamento do texto a esquerda
Local nSoma10     := 10 //Adiciona 10 espacos na linha
Local nSoma20     := 20 //Adiciona 20 espacos na linha
Local nSoma25     := 25 //Adiciona 25 espacos na linha

Local oFont14     := TFont():New("Courier new",14,14,,.F.,,,,.T.,.F.)

Local aProv       := {}
Local aDesc       := {}
Local aCodBenef   := {}
Local aVerbsAbo   := { "0074", "0617", "0622", "0623", "0632", "0633", "0634", "0635", ;
                       "1312", "1313", "1314", "1315", "1316", "1317", "1318", "1319", ;
                       "1320", "1321", "1322", "1323", "1324", "1325", "1326", "1327", ;
                       "1330", "1331", "1407", "1408", "1409", "1410", "0205", "0079", ;
                       "0206" }

Default aInfo     := {} //Matriz com os dados da Empresa/Filial
Default aCabec    := {} //informações para a geração do recibo
Default aVerbas   := {} //informações para a geração do recibo
Default cLocal    := "" //local para a gravação do arquivo
Default cFileName := "" //nome do arquivo pdf esperado na saida

If !Empty(aCabec) .And. !Empty(aVerbas) .And. !Empty(aInfo) 

	//Busca os codigos de pensao sob 13o. Salario definidos no cadastro beneficiario
	fBusCadBenef( @aCodBenef, "131", { fGetCodFol("0172") } )	
	For nBenef := 1 To Len(aCodBenef)
		cPdPens += aCodBenef[nBenef,1] + "|"
	Next nBenef	
	
	//Licenca remunerada
	If aCabec[1,10] + aCabec[1,11] > 0 
		nDiaFeQueb := aCabec[1,3] - Int(aCabec[1,3])
		DaAuxF := aCabec[1,5] + If(nDiaFeQueb>0 , 1, 0 )
	Else
		DaAuxF := aCabec[1,5]
    EndIf	
	
	//Periodos: Aquisitivo e gozo de Ferias
	PER_AQ_I := STRZERO( DAY( aCabec[1,08]),2) + STR0002 + MesExtenso(MONTH( aCabec[1,08])) + STR0002 + STR(YEAR( aCabec[1,08]),4)	//" De "###" De "
	PER_AQ_F := STRZERO( DAY( aCabec[1,09]),2) + STR0002 + MesExtenso(MONTH( aCabec[1,09])) + STR0002 + STR(YEAR( aCabec[1,09]),4)	//" De "###" De "
	PER_GO_I := STRZERO( DAY( aCabec[1,04]),2) + STR0002 + MesExtenso(MONTH( aCabec[1,04])) + STR0002 + STR(YEAR( aCabec[1,04]),4)	//" De "###" De "
	PER_GO_F := STRZERO( DAY( aCabec[1,05]),2) + STR0002 + MesExtenso(MONTH( aCabec[1,05])) + STR0002 + STR(YEAR( aCabec[1,05]),4)	//" De "###" De "

	cNameFun	:= If( !Empty(SRA->RA_NOMECMP), AllTrim( SRA->RA_NOMECMP ), AllTrim( SRA->RA_NOME ) )
	cCtps		:= If( Empty(SRA->RA_NUMCP),Space(7),AllTrim(SRA->RA_NUMCP))+" - "+SRA->RA_SERCP + SPACE(01) + STR0055 + Space(1) + SRA->RA_FILIAL+" "+SRA->RA_MAT //"Registro: "
	cDiasFMes 	:= If( (nPd := aScan( aVerbas, { |x| x[2] == "0072" }) ) > 0, Transform( aVerbas[nPd,5], "@E 999,999.99"), Transform( 0, "@E 999,999.99") )
	cDiasFMSeg 	:= If( (nPd := aScan( aVerbas, { |x| x[2] == "0073" }) ) > 0, Transform( aVerbas[nPd,5], "@E 999,999.99"), Transform( 0, "@E 999,999.99") )
	cDiasAbMes 	:= If( (nPd := aScan( aVerbas, { |x| x[2] == "0074" }) ) > 0, Transform( aVerbas[nPd,5], "@E 999,999.99"), Transform( 0, "@E 999,999.99") )
	cDiasAbMSeg	:= If( (nPd := aScan( aVerbas, { |x| x[2] == "0205" }) ) > 0, Transform( aVerbas[nPd,5], "@E 999,999.99"), Transform( 0, "@E 999,999.99") )	
	cLicRemun	:= cValToChar( aCabec[1,10] + aCabec[1,11] )

	//Dados da empresa e local de pagamento
	cRecEmp		:= STR0016 + Space(1) + SubStr(aInfo[3], 1, 50) //"Recebi da:"
	cEndEmp  	:= STR0017 + Space(1) + SubStr(AllTrim(aInfo[4]),1,30) + " - " + STR0018 + Space(1) + AllTrim(aInfo[7]) //"Estabelecida a"#"Cep:"
	cLocalEmp	:= STR0019 + Space(1) + SubStr(AllTrim(aInfo[5]),1,25) + " - " + STR0020 + Space(1) + AllTrim(aInfo[6]) //"Cidade:"#"UF:" 
	
	//Data de pagamento
	cDtPagExt	:= StrZero(Day(aCabec[1,7]),2) + STR0002 //" de " 
	cDtPagExt	+= MesExtenso(Month(aCabec[1,7])) + STR0002 //" de " 
	cDtPagExt	+= STR(YEAR(aCabec[1,7]),4) 
	
	cDtPag		:= ALLTRIM(aInfo[5]) + ", " + cDtPagExt
	cDtReceb	:= STR0021 + Space(1) + SubStr( AllTrim(aInfo[5]),1,25) + ", " + cDtPagExt + Space(1) + STR0022 //"em"#"a importancia Liquida de"

	cDescCC   := AllTrim(EncodeUTF8(fDesc('CTT',SRA->RA_CC,'CTT->CTT_DESC01',,SRA->RA_FILIAL)))
	cDescDpto := AllTrim(EncodeUTF8(fDesc('SQB',SRA->RA_DEPTO,'SQB->QB_DESCRIC',,SRA->RA_FILIAL)))

	//-----------------------------------------------------------------------
	//Avalia as verbas que serao impressas nos recibos 
	//-----------------------------------------------------------------------
	For nReg := 1 TO Len(aVerbas)
		
		//Proventos de ferias
		If aVerbas[nReg,1] == "1" .And. aScan( aVerbsAbo, aVerbas[nReg,2] ) == 0
			If !aVerbas[nReg,2] $ cVerb13o
				nTotProv +=	aVerbas[nReg,4]
				aAdd( aProv, { aVerbas[nReg,3], aVerbas[nReg,6], aVerbas[nReg,5], aVerbas[nReg,4] })
			EndIf
		EndIf

		//Descontos	(Nao considera pensao)
		If aVerbas[nReg,1] == "2" .And. aScan( aVerbsAbo, aVerbas[nReg,2] ) == 0 .And. !(aVerbas[nReg,3] $ cPdPens)
		  	If !aVerbas[nReg,2] $ "0102"
				nTotDesc += aVerbas[nReg,4]
				aAdd( aDesc, { aVerbas[nReg,3], aVerbas[nReg,6], aVerbas[nReg,5], aVerbas[nReg,4] })
			EndIf 		
		EndIf

		//Obtem os valores dde Abono
		If aScan( aVerbsAbo, aVerbas[nReg,2] ) > 0
			If aVerbas[nReg,2] $ "0079||0206"
				nValAb13 += aVerbas[nReg,4]
			Else 
				nValAb += aVerbas[nReg,4]
			EndIf
		EndIf
		
		//Obtem o valor da 1o. Parcela 13o. Salario
		If aVerbas[nReg,2] == cVerb13o 
			nVal13o += aVerbas[nReg,4]
		EndIf	

	Next nReg	
	
	//-----------------------------------------------------------------------
	//IMPRESSAO DO RECIBO DE FERIAS
	//-----------------------------------------------------------------------

	//Inicio da atribuicao dos objetos graficos do relatorio
	oPrint := FWMSPrinter():New(cFileName+".rel", IMP_PDF, .F., cLocal, .T., , , , .T., , .F., )
	
	oPrint:SetPortrait()
	oPrint:StartPage()

	nSizePage := oPrint:nPageWidth / oPrint:nFactorHor

	//Box superior
	nLin  	+= 60
	oPrint:Box( nLin-10,030,260,575)

	nLin  += 5	 
	oPrint:Say( nLin, 235, STR0023, 			oFont14) //"RECIBO DE FERIAS"
	nLin  += nSoma10
	oPrint:Say( nLin, 235, REPLICATE("=",16),	oFont14)

	nLin  += 30
	oPrint:Say( nLin, nAligE,	STR0024,		oFont14) //"Nome do Empregado.......:"
	oPrint:Say( nLin, 220,		cNameFun, 		oFont14)
	
	nLin  += nSoma10
	oPrint:Say( nLin, nAligE,	STR0025, 		oFont14) //"Carteira Trabalho.......:"
	oPrint:Say( nLin, 220,		cCtps, 			oFont14)

	nLin  += nSoma10
	oPrint:Say( nLin, nAligE,	STR0026, 		oFont14) //"Periodo Aquisitivo......:"
	oPrint:Say( nLin, 220,		PER_AQ_I + STR0027 + PER_AQ_F, 	oFont14) //" A "	
	
	nLin  += nSoma10
	oPrint:Say( nLin, nAligE,	STR0028, 		oFont14) //"Periodo Gozo das Ferias.:"
	oPrint:Say( nLin, 220,		PER_GO_I + STR0027 + PER_GO_F, 	oFont14) //" A "
	
	nLin  += nSoma10
	oPrint:Say( nLin, nAligE,	STR0029, 		oFont14) //"Qtde. Dias Lic. Remun...:"
	oPrint:Say( nLin, 220,		cLicRemun, 		oFont14)

	nLin  += nSoma10
	oPrint:Line(nLin,030,nLin,575)	//Linha horizontal
	nLin  += 15
	oPrint:Say( nLin, 160, 		STR0030, 		oFont14) //"DADOS PARA CALCULO DE PAGAMENTO DE FERIAS"
	nLin  += nSoma10
	oPrint:Line(nLin,030,nLin,575)	//Linha horizontal

	nLin  += 15
	oPrint:Say( nLin, nAligE, 	STR0031, 	 	oFont14) //"Salario Mes.............:"
	oPrint:Say( nLin, 220,		Transform(aCabec[1,14],"@E 999,999.99"), 	oFont14)
	oPrint:Say( nLin, 315, 		STR0032, 		oFont14) //"Salario Hora.........:"
	oPrint:Say( nLin, 500,		Transform(aCabec[1,15],"@E 999,999.99"), 	oFont14)		

	nLin  += nSoma10
	oPrint:Say( nLin, nAligE,	STR0033,		oFont14) //"Valor Dia Mes...........:"
	oPrint:Say( nLin, 220,		Transform(aCabec[1,16],"@E 999,999.99"), 	oFont14)	
	oPrint:Say( nLin, 315, 		STR0034, 		oFont14) //"Valor Dia Mes Seg....:"
	oPrint:Say( nLin, 500,		Transform(aCabec[1,17],"@E 999,999.99"), oFont14)

	nLin  += nSoma10
	oPrint:Say( nLin, nAligE, 	STR0035, 		oFont14) //"Dias Ferias Mes.........:"
	oPrint:Say( nLin, 220,		cDiasFMes, 		oFont14)	
	oPrint:Say( nLin, 315, 		STR0036, 		oFont14) //"Dias Ferias Mes Seg..:"
	oPrint:Say( nLin, 500,		cDiasFMSeg, 	oFont14)

	nLin  += nSoma10
	oPrint:Say( nLin, nAligE, 	STR0037, 		oFont14) //"Dias Abono Mes..........:"
	oPrint:Say( nLin, 220, 		cDiasAbMes, 	oFont14)
	oPrint:Say( nLin, 315, 		STR0038, 		oFont14) //"Dias Abono Mes Seg...:"
	oPrint:Say( nLin, 500, 		cDiasAbMSeg, 	oFont14)
	
	nLin  	+= nSoma10
	nLinPDI	:= nLin 

	oPrint:Line(nLin,030,nLin,575)	//Linha horizontal
	nLin  	+= 15
	nLinPDF	+= 15
	oPrint:Say( nLin, 105, 		STR0039, 		oFont14) //"P R O V E N T O S"
	oPrint:Say( nLin, 380, 		STR0040, 		oFont14) //"D E S C O N T O S"	
	nLin  	+= nSoma10
	nLinPDF	+= nSoma10
	oPrint:Line(nLin,030,nLin,575)	//Linha horizontal
	
	nLin  	+= 15
	nLinPDF	+= 15
	
	oPrint:Say( nLin, nAligE, 		STR0041,  	oFont14) //"Cód"
	oPrint:Say( nLin, nAligE+30,	STR0042,  	oFont14) //"Verba"
	oPrint:Say( nLin, nAligE+160,	STR0043,  	oFont14) //"Q/H"
	oPrint:Say( nLin, nAligE+220,	STR0044,  	oFont14) //"Valor"

	oPrint:Say( nLin, 310, 			STR0041,  	oFont14) //"Cód"
	oPrint:Say( nLin, 340,			STR0042,  	oFont14) //"Verba"
	oPrint:Say( nLin, 470,			STR0043,  	oFont14) //"Q/H"
	oPrint:Say( nLin, 530,			STR0044,  	oFont14) //"Valor"

	//-----------------------------------------------------------------------
	//Impressao das verbas do recibo de ferias 
	//-----------------------------------------------------------------------
	nMaximo := MAX(Len(aProv),Len(aDesc))
	For nReg := 1 TO nMaximo

		nLin  	+= nSoma10
		nLinPDF	+= nSoma10
		
		//Proventos de ferias
		If nReg <= Len(aProv)
			oPrint:Say( nLin, nAligE, 		aProv[nReg,1],								oFont14)
			oPrint:Say( nLin, nAligE+30,	SubStr(aProv[nReg,2],1,15),				oFont14)
			oPrint:Say( nLin, nAligE+150,	Transform(aProv[nReg,3], '@E 99.99'),		oFont14)
			oPrint:Say( nLin, nAligE+190,	Transform(aProv[nReg,4], '@E 999,999.99'),	oFont14)
		EndIf

		//Descontos	(Nao considera pensao)
		If nReg <= Len(aDesc)
			oPrint:Say( nLin, 310, 			aDesc[nReg,1],								oFont14)
			oPrint:Say( nLin, 340,			SubStr(aDesc[nReg,2],1,15),				oFont14)
			oPrint:Say( nLin, 460,			Transform(aDesc[nReg,3], '@E 99.99'),		oFont14)
			oPrint:Say( nLin, 500,			Transform(aDesc[nReg,4], '@E 999,999.99'),	oFont14)
		EndIf

	Next nReg
	
	//Tratamento do valor extenso
	//-----------------------------------------------------------------------
	cValor1	:= STR0045 + TRANSFORM(nTotProv-nTotDesc,"@E 999,999.99") + " (" //"R$"
	cValExt	:= Extenso(nTotProv-nTotDesc,.F.,1)
	nTamMax	:= 80 - Len(cValor1)
	SepExt(cValExt, nTamMax, 80, @cRet1, @cRet2)
	
	cValor1 += AllTrim(cRet1)
	If !Empty(cRet2)
		cValor2 += AllTrim(cRet2) + ".****)"
	Else
		cValor1 += ")"
	EndIf	
	//-----------------------------------------------------------------------
	
	//Total proventos e descontos
	nLin  	+= 30
	nLinPDF	+= 30
	oPrint:Say( nLin, nAligE, 		STR0046,		oFont14) //"Total Proventos......:"
	oPrint:Say( nLin, 310, 			STR0047,		oFont14) //"Total Descontos......:"

	oPrint:Say( nLin, nAligE+190,	Transform(nTotProv,'@E 999,999.99'),	oFont14)
	oPrint:Say( nLin, 500,			Transform(nTotDesc,'@E 999,999.99'),	oFont14)

	nLin  	+= nSoma10
	nLinPDF	+= nSoma10
	oPrint:Line(nLin,030,nLin,575)						//Linha horizontal
	oPrint:Line(nLinPDI, 030, nLinPDI+nLinPDF, 030)		//Linha vertical direita
	oPrint:Line(nLinPDI, 300, nLinPDI+nLinPDF, 300)		//Linha vertical centro
	oPrint:Line(nLinPDI, 575, nLinPDI+nLinPDF, 575)		//Linha vertical esquerda

	nLin  += 15
	oPrint:Say( nLin, nAligE, 		STR0048,		oFont14) //"Liquido a receber....:"
	oPrint:Say( nLin, nAligE+190,	Transform(nTotProv-nTotDesc,'@E 999,999.99'),	oFont14)
	
	nLin  += nSoma10
	oPrint:Line(nLin,030,nLin,575)	//Linha horizontal

	nLin  += 15
	oPrint:Say( nLin, nAligE+10, 	cRecEmp, 		oFont14)
	nLin  += nSoma10
	oPrint:Say( nLin, nAligE+10, 	cEndEmp, 		oFont14)
	nLin  += nSoma10	
	oPrint:Say( nLin, nAligE+10, 	cLocalEmp,			oFont14)
	nLin  += nSoma10	
	oPrint:Say( nLin, nAligE+10, 	cDtReceb, 		oFont14)
	nLin  += nSoma10	
	oPrint:Say( nLin, nAligE+10, 	cValor1,		oFont14)
	
	//Valor por extenso impresso em duas linhas
	If !Empty(cValor2)
		nLin  += nSoma10
		oPrint:Say( nLin, nAligE+10, 	cValor2,	oFont14)
	EndIf
	
	nLin  += nSoma10	
	oPrint:Say( nLin, nAligE+10, STR0049, 	oFont14) //"que me paga adiantadamente por motivo das minhas ferias regulamentares,"
	nLin  += nSoma10	
	oPrint:Say( nLin, nAligE+10, STR0050, 	oFont14) //"ora concedidas que vou gozar de acordo com a descricao acima, tudo"
	nLin  += nSoma10	
	oPrint:Say( nLin, nAligE+10, STR0051, 	oFont14) //"conforme o aviso que recebi em tempo, ao qual dei meu ciente."
	nLin  += nSoma10	
	oPrint:Say( nLin, nAligE+10, STR0052, 	oFont14) //"Para clareza e documento, firmo o presente recibo, dando a firma plena e"
	nLin  += nSoma10	
	oPrint:Say( nLin, nAligE+10, STR0053, 	oFont14) //"geral quitacao."
	nLin  += nSoma25	
	oPrint:Say( nLin, nAligE+10, cDtPag, 	oFont14)
	nLin  += nSoma25	
	oPrint:Say( nLin, nAligE+200, STR0054 + Space(1) + REPLICATE("_",25), 	oFont14) //"Assinatura do Empregado:"
	nLin  += nSoma20

	oPrint:Line(nLin, 030, nLin, 575)				//Linha horizontal
	oPrint:Line(nLinPDI+nLinPDF, 030, nLin, 030)	//Linha vertical direita
	oPrint:Line(nLinPDI+nLinPDF, 575, nLin, 575)	//Linha vertical esquerda

	oPrint:EndPage()
	
	
	//-----------------------------------------------------------------------
	//IMPRESSAO DO RECIBO DO ABONO
	//-----------------------------------------------------------------------	
	If nValAb > 0 .Or. nValAb13 > 0
	
		cRet1  := ""
		cRet2  := ""		
		lPage2 := .T.

		//Define se o periodo do abono pecuniario será considerado antes ou depois do gozo de ferias
		If !Empty(aCabec[1,13])
			cAbono 	:= aCabec[1,13]
		Else
			cAbono	:= GetMv("MV_ABOPEC")                   
			cAbono 	:= If(cAbono=="S","1","2")
		EndIF
		
		If cAbono == "1"
			cDtAbon  := PADR(DtoC(aCabec[1,4]-aCabec[1,12]),10) +" a "+ Dtoc(aCabec[1,4]-1) 
			cDtGzFer := PADR(Dtoc(aCabec[1,4]),10) +" a "+ PADR(DtoC(DaAuxF),10)
		Else
			cDtAbon  := PADR(DtoC( DaAuxF + 1),10) +" a "+ PADR(Dtoc(DaAuxF+aCabec[1,12]),10)
			cDtGzFer := PADR(Dtoc(aCabec[1,4]),10) +" a "+ PADR(DtoC(DaAuxF),10)
		EndIf
	
		PER_AQ_I := STRZERO( DAY( aCabec[1,08]),2) + STR0002 + MesExtenso(MONTH( aCabec[1,08])) + STR0002 + STR(YEAR( aCabec[1,08]),4)	//" De "###" De "
		PER_AQ_F := STRZERO( DAY( aCabec[1,09]),2) + STR0002 + MesExtenso(MONTH( aCabec[1,09])) + STR0002 + STR(YEAR( aCabec[1,09]),4)	//" De "###" De "
		PER_GO_I := STRZERO( DAY( aCabec[1,04]),2) + STR0002 + MesExtenso(MONTH( aCabec[1,04])) + STR0002 + STR(YEAR( aCabec[1,04]),4)	//" De "###" De "
		PER_GO_F := STRZERO( DAY( aCabec[1,05]),2) + STR0002 + MesExtenso(MONTH( aCabec[1,05])) + STR0002 + STR(YEAR( aCabec[1,05]),4)	//" De "###" De "
	
		oPrint:StartPage()
		
		//Inicio da atribuicao dos objetos graficos do relatorio
		nLin  	:= 60
		nLinAbI := nLin-10
	
		nLin  += 5	 
		oPrint:Say( nLin, 200, STR0056, 							oFont14) //"RECIBO DE ABONO DE FERIAS"
		nLin  += nSoma10
		oPrint:Say( nLin, 200, REPLICATE("=",25),					oFont14)
	
		nLin  += 30
		oPrint:Say( nLin, nAligE+50,	cNameFun,					oFont14) //Nome do Empregado
		
		nLin  += nSoma10
		oPrint:Say( nLin, nAligE+50,	cCtps, 						oFont14) //Carteira Trabalho
		oPrint:Say( nLin, 360,			STR0057 +" "+ cDescCC,		oFont14) //"C.CUSTO:"
	
		nLin  += nSoma10
		oPrint:Say( nLin, 360,			cDescDpto, 					oFont14) //Departamento
		
		nLin  += nSoma25
		oPrint:Say( nLin, 220,			STR0058, 					oFont14) //"D E M O N S T R A T I V O"
		
		nLin  += nSoma25
		oPrint:Say( nLin, nAligE,		STR0059,					oFont14) //"Periodo de ferias em abono pecuniario"	
		oPrint:Say( nLin, 350,			STR0060,	 				oFont14) //"Periodo de gozo de ferias"
	
		nLin  += nSoma10
		oPrint:Say( nLin, nAligE+50,	cDtAbon,					oFont14) //Periodo de abono
		oPrint:Say( nLin, 370,			cDtGzFer,					oFont14) //Periodo do gozo de ferias

		nLin  += 30
		oPrint:Say( nLin, nAligE+50,	STR0061 + " (" + STR(aCabec[1,12],3) + ") " + STR0062,	oFont14) //"Abono"#"Dias: "
		oPrint:Say( nLin, 310,			Transform(nValab, '@E 999,999.99'),						oFont14)
		nLin  += nSoma10
		oPrint:Say( nLin, nAligE+50,	STR0063,												oFont14) //"Acrescimo 1/3:"
		oPrint:Say( nLin, 310,			Transform(nValAb13,'@E 999,999.99'),					oFont14)
		nLin  += nSoma10
		oPrint:Say( nLin, nAligE+50,	STR0064,												oFont14) //"Liquido:"
		oPrint:Say( nLin, 310,			Transform(nValab+nValAb13,'@E 999,999.99'),				oFont14)

		nLin  += 30
		oPrint:Say( nLin, nAligE+100, 	cRecEmp, 					oFont14)
		nLin  += nSoma10		
		oPrint:Say( nLin, nAligE+50, 	STR0065, 					oFont14) //"a importancia Liquida de"		

		//Tratamento do valor extenso
		//-----------------------------------------------------------------------
		cValor1	:= STR0045 + TRANSFORM(nValab+nValAb13,"@E 999,999.99") + " (" //"R$"
		cValExt	:= Extenso(nValab+nValAb13,.F.,1)
		nTamMax	:= 40 - Len(cValor1)
		SepExt(cValExt, nTamMax, 80, @cRet1, @cRet2)
		
		cValor1 += AllTrim(cRet1)
		cValor2 := ""
		If !Empty(cRet2)
			cValor2 += AllTrim(cRet2) + ".****)"
		Else
			cValor1 += ")"
		EndIf	
		//-----------------------------------------------------------------------

		oPrint:Say( nLin, nAligE+230, 		cValor1,		oFont14)	
		//Valor por extenso impresso em duas linhas
		If !Empty(cValor2)
			nLin  += nSoma10
			oPrint:Say( nLin, nAligE+50, 	cValor2,		oFont14)
		EndIf		
		nLin  += nSoma10
		oPrint:Say( nLin, nAligE+50, 		STR0066, 		oFont14) //"conforme demonstrativo acima, referente ao abono pecuniario."
		
		nLin  += 30	
		oPrint:Say( nLin, nAligE, cDtPag, 					oFont14)
		nLin  += nSoma10	
		oPrint:Say( nLin, nAligE+300, REPLICATE("_",35), 	oFont14)
		nLin  += 15	
		oPrint:Say( nLin, nAligE+300, cNameFun, 			oFont14)
		nLin  += nSoma20

		oPrint:Line(nLinAbI, 030, nLinAbI, 575)	//Linha horizontal superior
		oPrint:Line(nLinAbI, 030, nLin, 030)	//Linha vertical direita
		oPrint:Line(nLinAbI, 575, nLin, 575)	//Linha vertical esquerda
		oPrint:Line(nLin,    030, nLin, 575)	//Linha horizontal inferior

	EndIf
	
	
	//-----------------------------------------------------------------------
	//IMPRESSAO DO RECIBO DA 1a. PARCELA DO 13o. SALARIO
	//-----------------------------------------------------------------------
	If nVal13o > 0
	
		cRet1 := ""
		cRet2 := ""		

		If !lPage2
			oPrint:StartPage()
			nLin  	:= 60
			nLinPcI := nLin-nSoma10
		Else
			nLin  	+= 30
			nLinPcI := nLin-nSoma10		
		EndIf

		//Obtem os valores de pensao do 13o. Salario
		For nReg := 1 To Len(aVerbas)
			If aVerbas[nReg,3] $ cPdPens
				nPen13o += aVerbas[nReg,4]
			EndIf
		Next nReg
		
		//Inicio da atribuicao dos objetos graficos do relatorio
	
		nLin  += 5	 
		oPrint:Say( nLin, 170, STR0067, 						oFont14) //"RECIBO DA 1a. PARCELA DO 13o SALARIO"
		nLin  += nSoma10
		oPrint:Say( nLin, 170, REPLICATE("=",36),				oFont14)
	
		nLin  += 30
		oPrint:Say( nLin, nAligE+50,	cNameFun,				oFont14) //Nome do Empregado
		
		nLin  += nSoma10
		oPrint:Say( nLin, nAligE+50,	cCtps, 					oFont14) //Carteira Trabalho
		oPrint:Say( nLin, 360,			STR0057 +" "+ cDescCC,	oFont14) //"C.CUSTO:"
	
		nLin  += nSoma10
		oPrint:Say( nLin, 360,			cDescDpto, 				oFont14) //Departamento
		
		nLin  += nSoma25
		oPrint:Say( nLin, 220,			STR0058, 				oFont14) //"D E M O N S T R A T I V O"
		
		nLin  += nSoma25
		oPrint:Say( nLin, nAligE+50,	STR0068,				oFont14) //"1a Parcela do 13o Salario:"
		oPrint:Say( nLin, 310,			Transform(nVal13o, '@E 999,999.99'),		oFont14)
		nLin  += nSoma10
		oPrint:Say( nLin, nAligE+50,	STR0069,									oFont14) //"Adiantamento:"
		oPrint:Say( nLin, 310,			Transform(nVal13a,'@E 999,999.99'),			oFont14)
		
		If nPen13o > 0
			nLin  += nSoma10
			oPrint:Say( nLin, nAligE+50,	STR0070,								oFont14) //"Pensao:"
			oPrint:Say( nLin, 310,			Transform(nPen13o,'@E 999,999.99'),		oFont14)		
		EndIf
		
		nLin  += nSoma10
		oPrint:Say( nLin, nAligE+50,	STR0064,									oFont14) //"Liquido:"
		oPrint:Say( nLin, 310,			Transform(nVal13o-nVal13a-nPen13o,'@E 999,999.99'),	oFont14)
		
		nLin  += 30
		oPrint:Say( nLin, nAligE+100, 	cRecEmp, 									oFont14)
		nLin  += nSoma10		
		oPrint:Say( nLin, nAligE+50, 	STR0065, 									oFont14) //"a importancia Liquida de"		

		//Tratamento do valor extenso
		//-----------------------------------------------------------------------
		cValor1	:= STR0045 + TRANSFORM(nVal13o-nVal13a-nPen13o,"@E 999,999.99") + " (" //"R$"
		cValExt	:= Extenso(nVal13o-nVal13a-nPen13o,.F.,1)
		nTamMax	:= 40 - Len(cValor1)
		SepExt(cValExt, nTamMax, 80, @cRet1, @cRet2)
		
		cValor1 += AllTrim(cRet1)
		cValor2 := ""
		If !Empty(cRet2)
			cValor2 += AllTrim(cRet2) + ".****)"
		Else
			cValor1 += ")"
		EndIf	
		//-----------------------------------------------------------------------

		oPrint:Say( nLin, nAligE+230, 	cValor1,			oFont14)			
		//Valor por extenso impresso em duas linhas
		If !Empty(cValor2)
			nLin  += nSoma10
			oPrint:Say( nLin, nAligE+50, 	cValor2,		oFont14)
		EndIf
				
		nLin  += nSoma10
		oPrint:Say( nLin, nAligE+50, 		STR0071, 		oFont14) //"conforme demonstrativo acima, referente a 1a parcela do 13o salario."
		
		nLin  += 30	
		oPrint:Say( nLin, nAligE, cDtPag, 					oFont14)
		nLin  += nSoma10	
		oPrint:Say( nLin, nAligE+300, REPLICATE("_",35), 	oFont14)
		nLin  += 15	
		oPrint:Say( nLin, nAligE+300, cNameFun, 			oFont14)
		nLin  += nSoma20

		oPrint:Line(nLinPcI, 030, nLinPcI, 575)	//Linha horizontal superior
		oPrint:Line(nLinPcI, 030, nLin, 030)	//Linha vertical direita
		oPrint:Line(nLinPcI, 575, nLin, 575)	//Linha vertical esquerda
		oPrint:Line(nLin,    030, nLin, 575)	//Linha horizontal inferior
	
	EndIf	

	oPrint:EndPage()	
	cArqLocal		:= cLocal+cFileName+".PDF"		
	oPrint:cPathPDF := cLocal 
	oPrint:lViewPDF := .F.
	oPrint:Print()

EndIf

Return()

//*////////////////////////////////////////////////////////////*
//* Bloco de funções para geração do PDF do extrato de horas //*
//*////////////////////////////////////////////////////////////*

/*/
fExtBHoras
Recebe dados do funcionário, e gera um arquivo .pdf
com o extrato de horas no período informado.
@author alberto.ortiz
@since 27/04/2023
/*/
User Function fExtBHoras(cBranchVld, cMatSRA, cCodEmp, dInicio, dFim , lJob, cUID)

	Local aArea      := GetArea()
	Local aOcorrBH   := {}
	Local aReturn    := {}
	Local cPadrao999 := "9999999.99"
	Local lImpBaixad := .F.
	Local dDtFim	 := cTod("//")
	Local dDtIni	 := dInicio
	Local oFile      := JsonObject():New()
	Local oDetReg    := Nil
	Local oSaldo     := JsonObject():New()
	
	DEFAULT cBranchVld := ""
	DEFAULT cMatSRA    := ""
	DEFAULT cCodEmp    := ""
	DEFAULT dInicio    := ""
	DEFAULT dFim       := ""
	DEFAULT lJob       := .F.
	DEFAULT cUID       := .F.

	//Caso a data fim não tenha sido preenchida, preenche com a data de hoje.
	dDtFim := If(!Empty(dFim), dFim, DATE())

	If lJob
		//Instancia o ambiente para a empresa onde a funcao sera executada
		RPCSetType(3)
		RPCSetEnv(cCodEmp, cBranchVld)
	EndIf

	oSaldo["MV_TCFBHVL"] := If(SuperGetMv("MV_TCFBHVL",.F.,.F.) == .F., 1, 0)
	lImpBaixad	         := SuperGetMv("MV_IMPBHBX",,.T.) // Lista horas baixadas?

	dbSelectArea('SRA')
	dbSetOrder(1)

	If SRA->(dbSeek(cBranchVld + cMatSRA))

		//-- Carrega os Totais de Horas e Abonos.
		oSaldo["Horas_positivas"]           := 0
		oSaldo["Horas_negativas"]           := 0
		oSaldo["Saldo"]                     := 0
		oSaldo["Saldo_anterior"]            := 0 
		oSaldo["Saldo_anterior_valorizado"] := 0

		// Verifica lancamentos no Banco de Horas
		dbSelectArea("SPI")
		dbSetOrder(2)
		dbSeek(SRA->RA_FILIAL + SRA->RA_MAT)

		//Caso a data inicial venha em branco, é utilizada a data de admissão.
		dDtIni := If(!Empty(dDtIni), dDtIni, SRA->RA_ADMISSA)

		//Varre a tabela SPI
		While !Eof() .And. SPI->PI_FILIAL+SPI->PI_MAT == SRA->RA_FILIAL + SRA->RA_MAT

			// Totaliza Saldo Anterior.
			// Busca na SP9 - utilizando SPI.
			If SPI->PI_STATUS == " " .And. SPI->PI_DATA < dDtIni
				If PosSP9(SPI->PI_PD, SRA->RA_FILIAL, "P9_TIPOCOD") $ "1*3" 
					If oSaldo["MV_TCFBHVL"] == 1	// Horas Normais
						oSaldo["Saldo_anterior"]             := SomaHoras(oSaldo["Saldo_anterior"], SPI->PI_QUANT)
						oSaldo["Saldo_anterior_valorizado"]  := SomaHoras(oSaldo["Saldo_anterior_valorizado"], SPI->PI_QUANTV)
					Else
						oSaldo["Saldo_anterior"] := SomaHoras(oSaldo["Saldo_anterior"], SPI->PI_QUANTV)
					Endif
				Else
					If oSaldo["MV_TCFBHVL"] == 1
						oSaldo["Saldo_anterior"]            := SubHoras(  oSaldo["Saldo_anterior"], SPI->PI_QUANT)
						oSaldo["Saldo_anterior_valorizado"] := SubHoras(oSaldo["Saldo_anterior_valorizado"], SPI->PI_QUANTV)
					Else
						oSaldo["Saldo_anterior"]   := SubHoras(oSaldo["Saldo_anterior"], SPI->PI_QUANTV)
					Endif
				Endif
				oSaldo["Saldo"] := oSaldo["Saldo_anterior"]
			EndIf
			//Valida as datas.
			If	SPI->PI_DATA < dDtIni .Or. SPI->PI_DATA > dDtFim .Or. (SPI->PI_STATUS == "B" .And. !lImpBaixad) 
				dbSkip()
				Loop
			Endif

			PosSP9(SPI->PI_PD, SRA->RA_FILIAL)

			// Acumula os lancamentos de Proventos/Desconto no array aOcorrBH 
			If SP9->P9_TIPOCOD $ "1*3"
				oSaldo["Saldo"] := SomaHoras(oSaldo["Saldo"], If(SPI->PI_STATUS=="B", 0, If(oSaldo["MV_TCFBHVL"]==1, SPI->PI_QUANT, SPI->PI_QUANTV)))
			Else
				oSaldo["Saldo"] := SubHoras(oSaldo["Saldo"], If(SPI->PI_STATUS=="B", 0, If(oSaldo["MV_TCFBHVL"]==1, SPI->PI_QUANT, SPI->PI_QUANTV)))
			Endif

			oDetReg                                := JsonObject():New()
			oDetReg["Data"]                        := padr(DTOC(SPI->PI_DATA),10)
			oDetReg["Descricao_do_Evento"]         := Left(DescPdPon(SPI->PI_PD, SPI->PI_FILIAL), 20)
			oDetReg["Quantidade_de_Horas_Debito"]  := Transform(If(SP9->P9_TIPOCOD $ "1*3", 0, If(oSaldo["MV_TCFBHVL"]==1, SPI->PI_QUANT, SPI->PI_QUANTV)), cPadrao999)
			oDetReg["Quantidade_de_Horas_Credito"] := Transform(If(SP9->P9_TIPOCOD $ "1*3", If(oSaldo["MV_TCFBHVL"]==1, SPI->PI_QUANT, SPI->PI_QUANTV), 0), cPadrao999)
			oDetReg["Saldo"] 					   := Transform(oSaldo["Saldo"], cPadrao999)

			aAdd(aOcorrBH, oDetReg)

			// Acumula os lancamentos de Proventos/Desconto no array aOcorrBH 
			If SP9->P9_TIPOCOD $ "1*3"
				oSaldo["Horas_positivas"] := SomaHoras(oSaldo["Horas_positivas"], If(oSaldo["MV_TCFBHVL"]==1, If(SPI->PI_STATUS=="B", 0, SPI->PI_QUANT), If(SPI->PI_STATUS=="B", 0, SPI->PI_QUANTV)))
			Else
				oSaldo["Horas_negativas"] := SomaHoras(oSaldo["Horas_negativas"], If(oSaldo["MV_TCFBHVL"]==1, If(SPI->PI_STATUS=="B", 0, SPI->PI_QUANT), If(SPI->PI_STATUS=="B", 0, SPI->PI_QUANTV)))
			EndIf

			dbSelectArea( "SPI" )
			SPI->(dbSkip())
		Enddo
	EndIf

	If (Len(aOcorrBH) > 0 )
		oFile                 := fImpGraf(dDtIni, dDtFim, oSaldo, aOcorrBH)
		oFile["error"]        := .F.
		oFile["errorMessage"] := ""
	Else
		oFile["error"]        := .T.
		oFile["errorMessage"] := STR0072 + dToC(dDtIni) + " - " + dToC(dDtFim) //"Não foram encontrados saldo de horas para o período "
	Endif

	RestArea(aArea)

	If lJob
		//Atualiza a variavel de controle que indica a finalizacao do JOB
		PutGlbValue(cUID, "1")
	EndIf

	AADD(aReturn, oFile['content'])
	AADD(aReturn, oFile['fileName'])
	AADD(aReturn, oFile['error'])
	AADD(aReturn, oFile['errorMessage'])

	FreeObj(oDetReg)
	FreeObj(oSaldo)
	FreeObj(oFile)

Return aReturn

/*/
fImpGraf
Faz a impressão do extrato de horas.
@author alberto.ortiz
@since 27/04/2023
/*/

Static Function fImpGraf(dDtIni, dDtFim, oSaldo, aOcorrBH)

	Local cLocal 	   := GetSrvProfString("STARTPATH", "")
	Local cFile	 	   := AllTrim(SRA->RA_FILIAL) + "_" + AllTrim(SRA->RA_MAT)
	Local cFileContent := ""
	Local nLin	 	   := 0
	Local oFile        := Nil
	Local oPrint       := Nil
	Local oFileRet     := JsonObject():New()

	DEFAULT aOcorrBH := {}
	DEFAULT dDtIni   := cToD("//")
	DEFAULT dDtFim   := cToD("//")
	DEFAULT oSaldo   := Nil

	//Remove espaços em branco do nome do arquivo.
	cFile  := StrTran( cFile, " ", "_")
	oPrint := FWMSPrinter():New(cFile +".pdf", IMP_PDF, .F., cLocal, .T., Nil, Nil, Nil, .T., Nil, .F., Nil)
	oPrint:SetPortrait()

	//Cabeçalho
	fCabecGrf(@nLin, oPrint)

	//Dados do Periodo
	fPerGrf(@nLin, dDtIni, dDtFim, oPrint)

	//Cabeçalho dos Valores do BH
	fCabBH(@nLin, oPrint)

	//Valores do BH
	fValBH(@nLin, aOcorrBH, oPrint)

	//Saldos Finais
	fSaldosBH(@nLin, oSaldo, oPrint)

	oPrint:EndPage() // Finaliza a pagina
	oPrint:cPathPDF := cLocal 
	oPrint:lViewPDF := .F.
	oPrint:Print()

	//Avalia o arquivo gerado no servidor
	If File( cFile + ".pdf" )
		oFile := FwFileReader():New( cFile + ".pdf" )
		If (oFile:Open())
			cFileContent         := oFile:FullRead()
			oFileRet['content']  := cFileContent
			oFileRet['fileName'] := cFile +".pdf"
			oFile:Close()
		EndIf
	EndIf

	FreeObj(oFile)
	FreeObj(oPrint)

Return oFileRet

/*/
fCabecGrf
Faz a impressão do cabeçalho do extrato de horas..
@author alberto.ortiz
@since 27/04/2023
/*/

Static Function fCabecGrf(nLin, oPrint)

	Local aInfo			:= {}
	Local aDtHr         := {}
	Local cFile			:= ""
	Local cFilDesc      := ""
	Local cDepDesc      := ""
	Local cFuncDesc     := ""
	Local cNome         := ""
	Local cMat          := ""
	Local cStartPath	:= GetSrvProfString("Startpath","")
	Local cPagText      := "Página: "
	Local lNomeSoc      := SuperGetMv("MV_NOMESOC", NIL, .F.) 
	Local oFont15n      := TFont():New("Arial", 15, 15, Nil, .T., Nil, Nil, Nil, .T., .F.) //Normal negrito
	Local oFont12n      := TFont():New("Arial", 12, 12, Nil, .T., Nil, Nil, Nil, .T., .F.) //Normal negrito
	Local oFont10       := TFont():New("Arial", 10, 10, Nil, .F., Nil, Nil, Nil, .T., .F.) //Normal s/ negrito

	DEFAULT nLin   := 0
	DEFAULT oPrint := Nil

	fInfo(@aInfo, SRA->RA_FILIAL)

	cMat      := SRA->RA_MAT
	cFilDesc  := aInfo[1]
	cDepDesc  := AllTrim(fDesc('SQB', SRA->RA_DEPTO, 'QB_DESCRIC', Nil, SRA->RA_FILIAL))
	cNome     := If(lNomeSoc .And. !Empty(SRA->RA_NSOCIAL), AllTrim(SRA->RA_NSOCIAL), AllTrim(SRA->RA_NOME))
	cFuncDesc := AllTrim(fDesc('SRJ', SRA->RA_CODFUNC, 'RJ_DESC', Nil, SRA->RA_FILIAL))

	//Inicia uma nova pagina.
	oPrint:StartPage() 

	//Horário da geração do extrato de horas.
	aDtHr := FwTimeUF("SP", Nil, .T.)  
	nLin := 20
	oPrint:Say(nLin, 400, dToC(date()) + Space(1) + Time() + " - " + cPagText + "1", oFont10)
	nLin +=10 
	oPrint:Line(nLin, 10, nLin, 575, 12)

	//Logo
	cFile := cStartPath + "lgrl" + cEmpAnt + ".bmp"
	If File(cFile)
		oPrint:SayBitmap(nLin + 4, 25, cFile, 60, 50) // Tem que estar abaixo do RootPath
		nLin += 40
	Endif
	nLin +=20
	oPrint:Say(nLin,  40, STR0073, oFont15n) //EXTRATO DO BANCO DE HORAS
	nLin +=20
	oPrint:Say(nLin,  40, STR0074, oFont12n) //Empresa
	oPrint:Say(nLin, 200, STR0075, oFont12n) //Filial
	oPrint:Say(nLin, 400, STR0076, oFont12n) //Departamento
	nLin +=10
	oPrint:Say(nLin,  40,  cEmpAnt, oFont10) //Empresa
	oPrint:Say(nLin, 200, cFilDesc, oFont10) //Filial
	oPrint:Say(nLin, 400, cDepDesc, oFont10) //Departamento
	nLin +=30
	oPrint:Say(nLin,  40, STR0077, oFont12n) //Nome
	oPrint:Say(nLin, 200, STR0078, oFont12n) //Matrícula
	oPrint:Say(nLin, 400, STR0079, oFont12n) //Função
	nLin +=10
	oPrint:Say(nLin,  40,     cNome, oFont10) //Nome
	oPrint:Say(nLin, 200,      cMat, oFont10) //Matrícula
	oPrint:Say(nLin, 400, cFuncDesc, oFont10) //Função
	nLin +=10
	oPrint:Line(nLin, 10, nLin, 575, 12)
	nLin +=25

	FreeObj(oFont15n)
	FreeObj(oFont12n)
	FreeObj(oFont10)

Return .T.

/*/
fPerGrf
Faz a impressão do período do extrato de horas.
@author alberto.ortiz
@since 27/04/2023
/*/

Static Function fPerGrf(nLin, dDtIni, dDtFim, oPrint)

	Local oFont12n := TFont():New("Arial", 12, 12, Nil, .T., Nil, Nil, Nil, .T., .F.) //Normal negrito
	Local oFont10  := TFont():New("Arial", 10, 10, Nil, .F., Nil, Nil, Nil, .T., .F.) //Normal s/ negrito

	DEFAULT nLin   := 0
	DEFAULT dDtIni := cToD("//")
	DEFAULT dDtFim := cToD("//")
	DEFAULT oPrint := Nil

	nLin  += 10
	oPrint:Line(nLin, 10, nLin, 575, 12)
	nLin  += 10
	oPrint:Say(nLin, 270, STR0080, oFont12n) //Período.
	nLin  += 15
	oPrint:Say(nLin, 245, DtoC(dDtIni) + " - " + dToC(dDtFim), oFont10) //Valores do período informado.
	nLin  += 5
	oPrint:Line(nLin, 10, nLin, 575, 12)
	nLin  += 40
	
	FreeObj(oFont12n)
	FreeObj(oFont10)

Return .T.

/*/
fCabBH
Faz a impressão do cabeçalho da seção dos eventos do extrato de horas.
@author alberto.ortiz
@since 27/04/2023
@param nLin, oPrint
/*/

Static Function fCabBH(nLin, oPrint)

	Local oFont12n := TFont():New("Arial", 12, 12, Nil, .T., Nil, Nil, Nil, .T., .F.) //Normal negrito

	DEFAULT nLin   := 0
	DEFAULT oPrint := Nil

	oPrint:Line(nLin, 10, nLin, 575, 12)
	nLin += 15
	oPrint:Say(nLin,  40, STR0081, oFont12n) //Data
	oPrint:Say(nLin, 100, STR0082, oFont12n) //Evento
	oPrint:Say(nLin, 300, STR0083, oFont12n) //Positivas
	oPrint:Say(nLin, 400, STR0084, oFont12n) //Negativas
	oPrint:Say(nLin, 500, STR0085, oFont12n) //Saldo
	nLin  += 10
	oPrint:Line(nLin, 10, nLin, 575, 12)

	FreeObj(oFont12n)

Return .T.

/*/
fValBH
Faz a impressão dos eventos do extrato de horas.
@author alberto.ortiz
@since 27/04/2023
@param nLin, aOcorrBH, oPrint
/*/

Static Function fValBH(nLin, aOcorrBH, oPrint)

	Local nX	      := 0
	Local nPagina     := 1
	Local nTamPriPag  := 50
	Local nTamPagina  := 75
	Local nRegistros  := 0
	Local cPagText    := "Página: "
	Local oFont10     := TFont():New("Arial", 10, 10, Nil, .F., Nil, Nil, Nil, .T., .F.)	//Normal negrito

	DEFAULT aOcorrBH := {}
	DEFAULT nLin     := 0
	DEFAULT oPrint   := Nil

	nRegistros := Len(aOcorrBH)
	nLin +=10

	For nX := 1 To nRegistros

		//Controle da paginação - Situações em que ocorrem a quebra da página:
		//1 - Não coube na primeira página: - nRegistros > 50 e nPagina ==1
		//2 - Relatório tem mais de uma página e não coube na página atual (mais de 75 registros):
		//    nPagina > 1 .And. nX > (nTamPriPag + (nPagina - 1) * (nTamPagina))
		//3 - Está na última página do relatório e o rodapé não vai caber:
		//    Exemplos onde a o rodapé não cabe na página atual:
		//    40  < nRegistros <= 50  - primeira página
		//    115 < nRegistros <= 125 - segunda página
		//    190 < nRegistros <= 200 - terceira página
		//    3a - (nTamPriPag - 10 + (nPagina - 1) * (nTamPagina)) < nRegistros <= (nTamPriPag + (nPagina - 1) * (nTamPagina))
		//    3b - Faz a quebra quando for o primeiro registro da página seguinte: nX == nTamPriPag - 9 + (nPagina - 1) * (nTamPagina)  

		If (nPagina == 1 .And. nX > nTamPriPag) .Or. ; // - 1.
		   (nPagina > 1 .And. nX > (nTamPriPag + (nPagina - 1) * (nTamPagina))) .Or. ; // - 2.
		   ((nTamPriPag - 10 + (nPagina - 1) * (nTamPagina) < nRegistros) .And. ; // - 3a.
		    (nRegistros <= nTamPriPag + (nPagina - 1) * (nTamPagina)) .And. ;// - 3a.
			nX == nTamPriPag - 9 + (nPagina - 1) * (nTamPagina))// - 3b.
			
			//Encerra a página e começa outra
			oPrint:EndPage()
			oPrint:StartPage()
			nPagina++
			nLin := 20
			//Imprime horário e numeração da página.
			oPrint:Say(nLin, 400, dToC(date()) + Space(1) + Time() + Space(1) + " - " + cPagText + Alltrim(Str(nPagina)), oFont10)
			nLin := 40
			//Imprime o cabeçalho do Banco de horas novamente
			fCabBH(@nLin, @oPrint)
			nLin += 20
		EndIf

		// Impressão da linha
		oPrint:Say(nLin,  40,                        AllTrim(aOcorrBH[nX]["Data"]), oFont10) // Data
		oPrint:Say(nLin, 100,         AllTrim(aOcorrBH[nX]["Descricao_do_Evento"]), oFont10) // Evento
		oPrint:Say(nLin, 300, AllTrim(aOcorrBH[nX]["Quantidade_de_Horas_Credito"]), oFont10) // Positivas
		oPrint:Say(nLin, 400,  AllTrim(aOcorrBH[nX]["Quantidade_de_Horas_Debito"]), oFont10) // Negativas
		oPrint:Say(nLin, 500,                       AllTrim(aOcorrBH[nX]["Saldo"]), oFont10) // Saldo
		nLin += 10
	Next nX

	nLin +=20

	FreeObj(oFont10)
Return .T.

/*/
fSaldosBH
Faz a impressão dos saldos do extrato de horas.
@author alberto.ortiz
@since 27/04/2023
@param nLin, oSaldo, oPrint
/*/

Static Function fSaldosBH(nLin, oSaldo, oPrint)

	Local cSaldoAnterior  := ""
	Local cHorasPositivas := ""
	Local cHorasNegativas := ""
	Local cSaldo          := ""
	Local cPadrao999      := "9999999.99"
	Local oFont12n        := TFont():New("Arial", 12, 12, Nil, .T., Nil, Nil, Nil, .T., .F.) //Normal negrito
	Local oFont10         := TFont():New("Arial", 10, 10, Nil, .F., Nil, Nil, Nil, .T., .F.) //Normal s/ negrito

	DEFAULT nLin   := 0
	DEFAULT oSaldo := Nil
	DEFAULT oPrint := Nil

	cSaldoAnterior  := If(oSaldo["MV_TCFBHVL"] == 1, Transform(oSaldo["Saldo_anterior"], cPadrao999), Transform(oSaldo["Saldo_anterior_valorizado"],cPadrao999))
	cHorasPositivas := Transform(oSaldo["Horas_positivas"], cPadrao999)
	cHorasNegativas := Transform(oSaldo["Horas_negativas"], cPadrao999)
	cSaldo          := Transform(          oSaldo["Saldo"], cPadrao999)

	nLin  += 10
	oPrint:Line(nLin, 10, nLin, 575, 12)
	nLin  += 10

	oPrint:Say(nLin,  40, STR0086, oFont12n) // Saldo Anterior
	oPrint:Say(nLin, 250, STR0087, oFont12n) // Valores do Período
	oPrint:Say(nLin, 500, STR0088, oFont12n) // Saldo Final

	nLin += 10
    oPrint:Say(nLin,     40,            cSaldoAnterior, oFont10) // Saldo Anterior
	oPrint:Say(nLin,    250, STR0090 + cHorasPositivas, oFont10) // Horas positivas: 
	oPrint:Say(nLin+10, 250, STR0091 + cHorasNegativas, oFont10) // Horas Negativas: 
	oPrint:Say(nLin,    500,                    cSaldo, oFont10) // Saldo

	nLin  += 20
	oPrint:Line(nLin, 10, nLin, 575, 12)
	nLin  += 10

	FreeObj(oFont12n)
	FreeObj(oFont10)

Return .T.

//*///////////////////////////////////////////////////////////////////*
//* Fim do Bloco de funções para geração do PDF do extrato de horas //*
//*///////////////////////////////////////////////////////////////////*
