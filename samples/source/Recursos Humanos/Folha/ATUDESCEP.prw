#INCLUDE "TOTVS.CH"

/*/{Protheus.doc} AtuDescep
	Programa para atualização do campo RA_DESCEP
	@type  user Function
	@author isabel.noguti
	@since 04/01/2022
	@version 1.0
	/*/
User Function AtuDescep()
	Local aButtons	:= {}
	Local aSays		:= {}
	Local nOpcA		:= 0
	Local cMsgHelp	:= ""
	Local cMsg      := ""
	Local cLink		:= 'https://tdn.totvs.com/x/IsBDJw'
	Local aErros	:= {}
	Private cPerg   := "UPDDESCEP"

	aAdd(aSays,OemToAnsi( "Este programa tem como objetivo ajustar o campo Controle de Matrícula TSV (RA_DESCEP)" ))
	aAdd(aSays,OemToAnsi( "dos registros de Trabalhadores Sem Vinculo(SRA) já integrados ao TAF/Middleware, com" ))
	aAdd(aSays,OemToAnsi( "evento S-2300 gerado contendo informação de matrícula de acordo com o Leiaute S-1.0 sem" ))
	aAdd(aSays,OemToAnsi( "alimentação do campo de controle ou com o evento S-2300 enviado ao governo sem as " ))
	aAdd(aSays,OemToAnsi( "informações de matricula no TAF, porém com o campo Controle de Matricula TSV " ))
	aAdd(aSays,OemToAnsi( "(RA_DESCEP) preenchido " ))
	aAdd(aSays,OemToAnsi( "" ))

	If !SX1->(DbSeek('UPDDESCEP'))
		cMsg :=  + CRLF + OemToAnsi("Não foi encontrado o grupo de perguntas: ") + Alltrim(cPerg)
		cMsgHelp := ""
		cMsgHelp += + CRLF + OemToAnsi("Antes de prosseguir será necessário criar o grupo de perguntas. Para isso, siga as instruções contidos no link abaixo:")
		cMsgHelp += + CRLF + cLink + CRLF

		aAdd(aErros, cMsgHelp)
		Help(,, 'NOPERGUNT',, cMsg, 1, 0,,,,,, {aErros})
		Return()
	Endif

	aAdd(aButtons, { 14,.T.,{|| ShellExecute("open","https://tdn.totvs.com/x/IsBDJw","","",1) } } )
	aAdd(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) } } )
	aAdd(aButtons, { 1, .T., {|o| nOpcA := 1,FechaBatch() } } )
	aAdd(aButtons, { 2, .T., {|o| FechaBatch() } } )

	FormBatch( "Atualização RA_DESCEP", aSays, aButtons )

	If nOpcA == 1
		If SRA->(ColumnPos("RA_DESCEP")) > 0 .And. X3USO( GetSX3Cache("RA_DESCEP", "X3_USADO"))
			ProcGpe( {|lEnd| fProc()},,,.T.)
		else
			MsgInfo("Efetue a atualização do dicionário de dados no ambiente conforme a issue especificada para execução desta rotina.")
			Return()
		EndIf
	Endif
Return

/*/{Protheus.doc} fProc
	Processamento da atualização do campo RA_DESCEP para integrações S-2300 conforme matrícula do leiaute S-1.0
/*/
Static Function fProc()
	Local aArea		:= GetArea()
	Local lRet		:= .T.
	Local cWhere	:= ""
	Local cTSV		:= "%" + fSqlIn( StrTran(fCatTrabEFD("TSV"), "|" , ""), 3 ) + "%"
	Local cAliasQry	:= GetNextAlias()
	Local cJoinC9VRA:= "% " + FWJoinFilial( "SRA", "C9V" ) + " %"
	Local cJoinRJERA:= "% " + FWJoinFilial( "SRA", "RJE" ) + " %"
	Local lMiddleware  := SuperGetMv("MV_MID",, .F.)
	Local cCatC9V	   := ""	
	Local lCont		   := .F.
	
	Pergunte( cPerg, .F. )
	MakeSqlExpr( cPerg )

	//Filial
	If !Empty(mv_par01)
		cWhere := mv_par01
	EndIf

	//Matricula
	If !Empty(mv_par02)
		cWhere += Iif(!Empty(cWhere)," AND ","")
		cWhere += mv_par02
	EndIf

	If !lMiddleware
		cWhere += Iif(!Empty(cWhere)," AND ","")
		cWhere += " C9V.C9V_NOMEVE ='S2300' "
	
		cWhere := "%" + cWhere+ "%"

		BeginSqL alias cAliasQry
			SELECT SRA.RA_FILIAL, SRA.RA_MAT, SRA.RA_DESCEP, C9V.C9V_CATCI,C9V.C9V_MATTSV, C9V.C9V_STATUS
			FROM %Table:SRA% SRA
    		INNER JOIN %table:C9V% C9V
			ON 	%exp:cJoinC9VRA% AND
			C9V.C9V_CPF = SRA.RA_CIC AND 
			C9V.C9V_DTINIV = SRA.RA_ADMISSA AND
			C9V.C9V_ATIVO = '1' AND
			C9V.%notDel%
			WHERE %exp:cWhere% 
				AND SRA.RA_CATEFD IN (%Exp:cTSV%)
				AND SRA.%NotDel%
			GROUP BY SRA.RA_FILIAL, SRA.RA_MAT, SRA.RA_DESCEP, C9V.C9V_CATCI,C9V.C9V_MATTSV, C9V.C9V_STATUS
		EndSql

		If (cAliasQry)->(Eof())
			MsgInfo("Não foram encontrados registros da SRA correspondentes ao cenário para atualização.")
		Else
			SRA->( dbSetOrder(1) )
			While (cAliasQry)->(!Eof())
				If SRA->( dbSeek((cAliasQry)->RA_FILIAL + (cAliasQry)->RA_MAT) )
				    cCatC9V	 := Posicione("C87",1, xFilial("C87", (cAliasQry)->RA_FILIAL)+(cAliasQry)->C9V_CATCI,"C87_CODIGO")
					RecLock("SRA",.F.)
					If cCatC9V = SRA->RA_CATEFD .And. Empty((cAliasQry)->RA_DESCEP) .And. !Empty((cAliasQry)->C9V_MATTSV) 
						SRA->RA_DESCEP := "1"
						lCont := .T.
					ElseIf cCatC9V = SRA->RA_CATEFD .And. (cAliasQry)->RA_DESCEP == '1' .And. Empty((cAliasQry)->C9V_MATTSV) .And. (cAliasQry)->C9V_STATUS == '4'
						SRA->RA_DESCEP := " "
						lCont := .T.
					Endif	
					SRA->(MsUnlock())
				EndIf
				(cAliasQry)->(dbSkip())
			EndDo
			If lCont
				MsgInfo("Processamento finalizado com sucesso.")
			else
				MsgInfo("Não foram encontrados registros da SRA correspondentes ao cenário para atualização.")
			Endif		
		EndIf
	else
		If ChkFile("RJE")
			cWhere += Iif(!Empty(cWhere)," AND ","")
			cWhere += " RJE.RJE_EVENTO = 'S2300' "
	
			cWhere := "%" + cWhere+ "%"

			BeginSqL alias cAliasQry
			
				SELECT SRA.RA_FILIAL, SRA.RA_MAT, SRA.RA_DESCEP
				FROM %Table:SRA% SRA
				INNER JOIN %table:RJE% RJE
				ON 	%exp:cJoinRJERA% 
				AND RJE.RJE_KEY = SRA.RA_CODUNIC 
				AND  RJE.%notDel%
				WHERE %exp:cWhere% 
					AND SRA.RA_DESCEP = ' '
					AND SRA.RA_CATEFD IN (%Exp:cTSV%)
					AND SRA.%NotDel%
				GROUP BY SRA.RA_FILIAL, SRA.RA_MAT, SRA.RA_DESCEP
			EndSql
			
			If (cAliasQry)->(Eof())
				MsgInfo("Não foram encontrados registros da SRA correspondentes ao cenário para atualização.")
			Else
				SRA->( dbSetOrder(1) )
				While (cAliasQry)->(!Eof())
					If SRA->( dbSeek((cAliasQry)->RA_FILIAL + (cAliasQry)->RA_MAT) )
						RecLock("SRA",.F.)
						If Empty((cAliasQry)->RA_DESCEP)
							SRA->RA_DESCEP := "1"
							lCont := .T.
						Endif	
						SRA->(MsUnlock())
					EndIf
					(cAliasQry)->(dbSkip())
				EndDo
				If lCont
					MsgInfo("Processamento finalizado com sucesso.")
				else
					MsgInfo("Não foram encontrados registros da SRA correspondentes ao cenário para atualização.")
				Endif		
			EndIf
		Endif
	EndIf

	(cAliasQry)->( dbCloseArea() )
	RestArea(aArea)

Return lRet
