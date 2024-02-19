/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A978COMP  ºAutor³                       Microsiga                            ºData³  31/03/2006 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³PE para tratar as compensacoes da DCTF atraves de titulos manuais compensados                   º±±
±±º          ³                                                                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³PARAMIXB[1] -> Alias da tabela SE2 posicionado no momento                                       º±±
±±º          ³PARAMIXB[2] -> Array contendo dados da baixa do titulo                                          º±±
±±º          ³PARAMIXB[3] -> Dados do fornecedor posicionado no momento - Codigo + Loja                       º±±
±±º          ³PARAMIXB[4] -> Codigo de receita+variacao conforme solicitado pela DCTF                         º±±
±±º          ³PARAMIXB[5] -> Retorna X, de acordo com a periodicidade. Ex: cPeriod="Q" e dData 14/10/2004,    º±±
±±º          ³               retorno 1, 1. Quinzena.                                                          º±±
±±º          ³PARAMIXB[6] -> Data de apuracao do titulo                                                       º±±
±±º          ³PARAMIXB[7] -> Numero de acordo com a periodicidade - D=Diario, S=Semanal, X=Decendial,         º±±
±±º          ³               Q=Quinzenal, M=Mensal, B=Bimentral, T=Trimestral, U=Quadrimestral, E=Semestral e º±±
±±º          ³               A=Anual.                                                                         º±±
±±º          ³PARAMIXB[8] -> Periodocidade de uma data - D=Diario, S=Semanal, X=Decendial, Q=Quinzenal,       º±±
±±º          ³               M=Mensal, B=Bimentral, T=Trimestral, U=Quadrimestral, E=Semestral e A=Anual.     º±±
±±º          ³PARAMIXB[9] -> CNPJ do SIGAMAT ou do FORNECEDOR do titulo PAI, caso exista.                     º±±
±±º          ³PARAMIXB[10] -> SA2->A2_CODMUN do FORNECEDOR do titulo PAI, caso exista.                        º±±
±±º          ³PARAMIXB[11] -> Codigo de receita do titulo - deve ser utilizada, pois na DCTF trimestral ela   º±±
±±º          ³                tem um tratamento especial no MATA978                                           º±±
±±º          ³                                                                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³1-Indicador de COMPENSACAO, S para COMPENSACAO e N para NAO.                                    º±±
±±º          ³2-Tipo de FORMALIZACAO                                                                          º±±
±±º          ³3-Numero da FORMALIZACAO                                                                        º±±
±±º          ³4-Indicador se devo tratar no padrao do sistema (T) ou NAO(F). Quando tratar pelo               º±±
±±º          ³  padrao do sistema ele NAO irah identificar a compensacao.                                     º±±
±±º          ³                                                                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºSintaxe   ³ A978COMP                                                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 
User Function A978COMP
	Local	cAlsSe2		:=	PARAMIXB[1]		//Alias da tabela SE2 posicionado no momento
	Local	aBaixa		:=	PARAMIXB[2]		//Array contendo dados da baixa do titulo
	Local	cComp		:=	Iif ("COMPENSACAO"$Upper (aBaixa[9]), "S", "N")	//Verificacao se eh um TX que foi compensado
	Local	aFornece	:=	PARAMIXB[3]		//Dados do fornecedor posicionado no momento - Codigo + Loja
	Local	cCodRetVar	:=	StrZero (Val (PARAMIXB[4]), 5)		//Codigo de receita+variacao conforme solicitado pela DCTF
	Local	cDSQD		:=	StrZero (PARAMIXB[5], 2)			//Retorna X, de acordo com a periodicidade. Ex: cPeriod="Q" e dData 14/10/2004, retorno 1, 1. Quinzena.
	Local	dDtApur		:=	PARAMIXB[6]							//Data de apuracao do titulo
	Local	cMBTQS		:=	StrZero (PARAMIXB[7], 2)			//Numero de acordo com a periodicidade - D=Diario, S=Semanal, X=Decendial, Q=Quinzenal, M=Mensal, B=Bimentral, T=Trimestral, U=Quadrimestral, E=Semestral e A=Anual.
	Local	cPeriod		:=	PARAMIXB[8]							//Periodocidade de uma data - D=Diario, S=Semanal, X=Decendial, Q=Quinzenal, M=Mensal, B=Bimentral, T=Trimestral, U=Quadrimestral, E=Semestral e A=Anual.
	Local	nCnpjDarf	:=	PARAMIXB[9]							//CNPJ do SIGAMAT ou do FORNECEDOR do titulo PAI, caso exista.
	Local	cCodMun		:=	PARAMIXB[10]						//SA2->A2_CODMUN do FORNECEDOR do titulo PAI, caso exista.
	Local	cCodRet		:=	PARAMIXB[11]						//Codigo de receita do titulo - deve ser utilizada, pois na DCTF trimestral ela tem um tratamento especial no MATA978
	Local	cAnoApur	:=	StrZero (Year (dDtApur), 4)
	Local	aInfComp	:=	{"N","","",.T.}					//Informacoes da Nota de Debito Fornecedor, ou seja, da compensacao
																//1-Indicador de COMPENSACAO, S para COMPENSACAO e N para NAO.
																//2-Tipo de FORMALIZACAO
																//3-Numero da FORMALIZACAO
																//4-Indicador se devo tratar no padrao do sistema (T) ou NAO(F). Quando tratar pelo padrao do sistema ele NAO irah identificar a compensacao.
	//
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³SOMENTE PARA COMPENSACAO³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ("S"$cComp)
		RetComp ((cAlsSe2)->E2_PREFIXO, (cAlsSe2)->E2_NUM, (cAlsSe2)->E2_PARCELA, (cAlsSe2)->E2_TIPO, (cAlsSe2)->E2_FORNECE, (cAlsSe2)->E2_LOJA, @aInfComp)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³TRB utilizado na geracao dos registros.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !TRB->(DbSeek (aFornece[1]+aFornece[2]+cCodRetVar+cDSQD+cAnoApur+cMBTQS+aInfComp[1]+aInfComp[2]+aInfComp[3]))
			TRB->(RecLock ("TRB", .T.))
				TRB->TRB_FORN	:=	aFornece[1]
				TRB->TRB_LOJA	:=	aFornece[2]
				TRB->TRB_CODREC	:=	Val (cCodRetVar)
				TRB->TRB_ANOAPU	:=	Val (cAnoApur)
				TRB->TRB_MESAPU	:=	Val (cMBTQS)
				TRB->TRB_DSQD	:=	Val (cDSQD)
				TRB->TRB_PERIOD	:=	cPeriod
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Regra na validacao - Somente deverah ser preenchido quando nao for compensacao ou quando³
				//³      for e a formalizacao for 3.                                                       ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If ("S"$aInfComp[1] .And. "3"$aInfComp[2]) .Or. ("N"$aInfComp[1])
					TRB->TRB_PERAPU	:=	dDtApur
					TRB->TRB_CNPJDA	:=	nCnpjDarf
					TRB->TRB_CODRE2	:=	Val ((cAlsSe2)->E2_CODRET)
					TRB->TRB_DTVENC	:=	(cAlsSe2)->E2_VENCREA
				EndIf
				TRB->TRB_DATA	:=	dDtApur
				TRB->TRB_COMP	:=	aInfComp[1]
				TRB->TRB_FORMAL	:=	aInfComp[2]
				TRB->TRB_NUMERO	:=	aInfComp[3]
				//
				If ("4028"$cCodRet)
					TRB->TRB_NUMRER	:=	cCodMun
				Else
					TRB->TRB_NUMRER	:=	""
				EndIf
				TRB->TRB_NATUR	:=	(cAlsSe2)->E2_NATUREZ
		Else
			TRB->(RecLock ("TRB", .F.))
		EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Regra na validacao - Somente deverah ser preenchido quando nao for compensacao ou quando³
				//³      for e a formalizacao for 3.                                                       ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If ("S"$cComp .And. "3"$aInfComp[2]) .Or. ("N"$cComp)
					TRB->TRB_VLRPRI	+=	(cAlsSe2)->E2_VALOR
				EndIf
				TRB->TRB_VLRMUL	+=	aBaixa[4]
				TRB->TRB_VLRJUR	+=	aBaixa[3]
				TRB->TRB_VLRPAG	+=	aBaixa[6]			//Somo o desconto pois a DCTF nao considera se estiver embutido na baixa
			TRB->(MsUnLock ())
	EndIf
Return (aInfComp)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |RetComp   ºAutor³                       Microsiga                            ºData³  31/03/2006 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Retorna valores necessario para a geracao do Registro 12 (Compensacao)                          º±±
±±º          ³                                                                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObservacao³Ao passar as informacoes do titulo TX em processamento, verifico se possui baixa por compensacao,º±±
±±º          ³ se houver, atraves dos campos E5_DOCUMEN, E5_FORNADT e E5_LOJAADT posiciono no titulo que o    º±±
±±º          ³ compensou e retorno as informacoes de FORMALIZACAO e NUMERO DE PROCESSO do titulo de compensacaoº±±
±±º          ³                                                                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³cPrefixo -> Prefixo do titulo TX                                                                º±±
±±º          ³cNumero -> Numero do titulo TX                                                                  º±±
±±º          ³cParcela -> Parcela do titulo TX                                                                º±±
±±º          ³cTipo -> Tipo do titulo TX                                                                      º±±
±±º          ³cClifor -> Codigo do fornecedor do titulo TX                                                    º±±
±±º          ³cLoja -> Loja do fornecedor do titulo TX                                                        º±±
±±º          ³                                                                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³aRet -> Array contendo as informacoes de Formalizacao e Numero Processo para o registro 12.     º±±
±±º          ³                                                                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºSintaxe   ³RetComp (cPrefixo, cNumero, cParcela, cTipo, cCliFor, cLoja)                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function	RetComp (cPrefixo, cNumero, cParcela, cTipo, cCliFor, cLoja, aInfComp)
	Local   nTamTit		:=	TamSx3 ("E5_PREFIXO")[1]+TamSx3 ("E5_NUMERO")[1]+TamSx3 ("E5_PARCELA")[1]+TamSx3 ("E5_TIPO")[1]
	Local	aMVCMPSE2	:=	&(GetNewPar ("MV_CMPSE2", "{}"))
	//
	If Len (aMVCMPSE2)==0
		aInfComp		:=	{"N","", "", .T.}
		Return (aInfComp)
	EndIf
	//
	DbSelectArea ("SE5")
		SE5->(DbSetOrder (7))
	If (SE5->(DbSeek (xFilial ("SE5")+cPrefixo+cNumero+cParcela+cTipo+cCliFor+cLoja)))
		Do While !SE5->(Eof ()) .And.;
			cPrefixo+cNumero+cParcela+cTipo+cCliFor+cLoja==SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA
			//
			If (SE5->E5_MOTBX=="CMP")
				DbSelectArea ("__SE2")
					__SE2->(DbSetOrder (1))
				If (__SE2->(DbSeek (xFilial ("SE2")+SubStr (SE5->E5_DOCUMEN, 1, nTamTit)+SE5->E5_FORNADT+SE5->E5_LOJAADT)))
					aInfComp[2]	:=	&("__SE2->"+aMVCMPSE2[1])		//Formalizacao do Pedido
					aInfComp[3]	:=	&("__SE2->"+aMVCMPSE2[2])		//Numero do PERDCOMP ou PROCESSO
					aInfComp[1]	:=	"S"
					aInfComp[4]	:=	.F.
					//
					Exit
				EndIf
			EndIf
			//
			SE5->(DbSkip ())
		EndDo
	EndIf
Return (.T.)