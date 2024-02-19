User Function MT953TIT
Local	lTitulo		:=	PARAMIXB[01]
Local	cImposto	:=	PARAMIXB[02]
Local	cImp		:=	PARAMIXB[03]
Local	cLcPadTit	:=	PARAMIXB[04]
Local	dDtIni		:=	PARAMIXB[05]
Local	dDtFim		:=	PARAMIXB[06]
Local	dDtVenc		:=	PARAMIXB[07]
Local	nMoedTit	:=	PARAMIXB[08]
Local	lGuiaRec	:=	PARAMIXB[09]
Local	nMes		:=	PARAMIXB[10]
Local	nAno		:=	PARAMIXB[11]
Local	lContab		:=	PARAMIXB[12]
Local	aGNRESt		:=	PARAMIXB[13]
Local	cMVSIGNRE	:=	PARAMIXB[14]
Local	cProdec		:=	PARAMIXB[15]
Local	cOrgArrec	:=	PARAMIXB[16]
Local	nValGuiaSf6	:=	PARAMIXB[17]
Local	nPosFECP	:=	Ascan (aCols5, {|x| x[1]=="012"}) 	//FECP a recolher
Local	nPosRecST	:=	Ascan (aCols6, {|x| x[1]=="015"}) 	//imposto a recolher Substituicao Tributaria
Local	nPosFECPST	:=	Ascan (aCols6, {|x| x[1]=="014"}) 	//FECP a recolher Substituicao Tributaria
Local	nNum		:=	0
Local	cNumero		:=	""
Local	cNumero2		:=	""
Local	aGNRE		:=	{}
Local	aTitulo		:=	{}
Local	lInfComp	:=	.F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Grava o titulo do ICMS Normal³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nVlrTitulo>0
	GravaTit (lTitulo, nVlrTitulo, cImposto, cImp, cLcPadTit, dDtIni, dDtFim, dDtVenc,;
				nMoedTit, lGuiaRec, nMes, nAno,	 nValGuiaSf6, 0, "MATA953", lContab, @cNumero, @aGNRE)
	If lTitulo .And. nVlrTitulo>0
		AADD (aTitulo, {"TIT",cNumero+" "+Dtoc (dDtVenc)+" "+cOrgArrec, nVlrTitulo})
	Endif
	PcoDetLan('000250','01','MATA953')	//Gera os lancamentos do SIGAPCO
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Grava o titulo de Adicional relativo ao FECP³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If GetMV("MV_ESTADO")=="RJ" .And. aCols5[nPosFECP,4]>0
	GravaTit (lTitulo, aCols5[nPosFECP,4], cImposto, cImp, cLcPadTit, dDtIni, dDtFim, dDtVenc,	 nMoedTit, lGuiaRec,;
				nMes, nAno, aCols5[nPosFECP,4],	 0, "MATA953", lContab, @cNumero, @aGNRE,,,,,.T.)

	If lTitulo .And. aCols5[nPosFECP,4]>0
		AADD (aTitulo, {"TIT",cNumero+" "+Dtoc (dDtVenc)+" "+cOrgArrec, aCols5[nPosFECP,4]})
	Endif
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Grava o titulo de Diferencial de Aliquotas (RJ/MG)          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SuperGetMV ("MV_ESTADO")$"RJ/MG" .And. aCols7[2,3]>0
	GravaTit (lTitulo, aCols7[2,3], cImposto, cImp, cLcPadTit, dDtIni, dDtFim, dDtVenc, nMoedTit, lGuiaRec, nMes, nAno,;
				aCols7[2,3], 0, "MATA953", lContab, @cNumero, @aGNRE,,,,,,.T.)
	If lTitulo .And. aCols7[2,3]>0
		lInfComp := .T.
		AADD (aTitulo, {"TIT", cNumero+" "+Dtoc (dDtVenc)+" "+cOrgArrec, aCols7[2,3]})
	Endif
Endif
			
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Grava o titulo de Substituicao Tributaria do proprio estado.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (aCols6[nPosRecST,4]>0)
	GravaTit (lTitulo, aCols6[nPosRecST,4], cImposto, cImp, cLcPadTit, dDtIni, dDtFim, dDtVenc, nMoedTit, lGuiaRec, nMes,;
				nAno, 0, aCols6[nPosRecST,4], "MATA953", lContab, @cNumero, @aGNRE)
	If lTitulo .And. aCols6[nPosRecST,4]>0
		AADD (aTitulo, {"TIT", cNumero+" "+Dtoc (dDtVenc)+" "+cOrgArrec, aCols6[nPosRecST,4]})
	Endif 
	PcoDetLan('000250','02','MATA953')	//Gera os lancamentos do SIGAPCO
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Grava o titulo de FECP Substituicao Tributaria              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (SuperGetMV("MV_ESTADO")=="RJ" .And. aCols6[nPosFECPST,4]>0)
	GravaTit (lTitulo, aCols6[nPosFECPST,4], cImposto, cImp, cLcPadTit, dDtIni, dDtFim, dDtVenc, nMoedTit, lGuiaRec, nMes,;
				nAno, 0, aCols6[nPosFECPST,4], "MATA953", lContab, @cNumero, @aGNRE)
	If lTitulo .And.aCols6[nPosFECPST,4]>0
		AADD (aTitulo, {"TIT", cNumero+" "+Dtoc (dDtVenc)+" "+cOrgArrec, aCols6[nPosFECPST,4]})
	Endif 
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Grava os titulos de Substituicao Tributaria de outros estados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nNum := 1 to Len(aGNREST)
	GravaTit (lTitulo, aGNREST[nNum][02], cImposto, cImp, cLcPadTit, dDtIni, dDtFim, dDtVenc, nMoedTit, lGuiaRec, nMes,;
				nAno, 0, aGNREST[nNum][02], "MATA953", lContab, @cNumero, @aGNRE,, @aGNREST, aGNREST[nNum][01])
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Grava a informacao do titulo na apuracao se o mesmo foi gerado³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If aGNREST[nNum][03]
		AADD (aTitulo, {"TIT", cNumero+" "+Dtoc (dDtVenc)+" "+cOrgArrec, aGNREST[nNum][02]})
	Endif
	PcoDetLan('000250','03','MATA953')	//Gera os lancamentos do SIGAPCO
Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tratamento do Incentivos Fiscais - SC  ( PRODEC )³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nNum :=1 to Len(aCOLS5)
	If !Empty(aCOLS5[nNum,6])
		If !(AllTrim (aCOLS5[nNum, 2])$cMVSIGNRE)
			dDtVenc2 :=STOD(StrZero(Year(ddtvenc)+Val(cProdec),4)+StrZero(Month(ddtvenc),2)+StrZero(Day(ddtvenc),2))
		Else
			dDtVenc2 := dDtVenc
		EndIf
		GravaTit (lTitulo, aCols5[nNum,4], cImposto, cImp, cLcPadTit, dDtIni, dDtFim, dDtVenc2, nMoedTit, lGuiaRec, nMes,;
					nAno, aCols5[nNum,4], 0, "MATA953", lContab, @cNumero2, @aGNRE, aCOLS5[nNum,6],,,,,, aCOLS5[nNum,5])
		If (Len (aGNRE)>0)
		   aCOLS5[nNum,5] := aGNRE[Len (aGNRE)][1]
		EndIf
		PcoDetLan('000250','04','MATA953')	//Gera os lancamentos do SIGAPCO
	Endif
Next
Return ({cNumero, aGNRE, aGNREST, aTitulo, lInfComp, cNumero2})