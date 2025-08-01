#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} ATURU2
Programa para popular registros da tabela RU2 - Informa��es Complementares Menor Aprendiz
@author  raquel.andrade
@since   17/07/2023
@version 1.0
/*/
User Function ATURU2()

	Local nOpcA         := 0
	Local aButtons      := {}
	Local aSays         := {}
    Local lTabAprend  := chkfile("RU2")

	Private aPerg   := {}
	Private aTitle  := {}
	Private aLog    := {}
    Private aParam  := {}

    If !lTabAprend
		Help( " ", 1, OemToAnsi("Aviso"),, OemToAnsi("RDMAKE dispon�vel apenas quando a tabela RU2 - Informa��es Complementares Menor Aprendiz estiver dispon�vel na base de dados."), 1, 0 )
        Return
    EndIf

	aAdd(aSays,OemToAnsi( "Este programa tem como objetivo incluir registros na tabela  RU2 - Informa��es "))
	aAdd(aSays,OemToAnsi( "Complementares Menor Aprendiz dos funcion�rios de Categoria eSocial igual a 103"))
	aAdd(aSays,OemToAnsi( "que possuem dados de Num. Insc. (RA_PLAPRE), Tp. Inscr. (RA_TIPCTA) preenchidos."))
   	aAdd(aSays,OemToAnsi( "Clique em ABRIR para consultar a documenta��o desta rotina." ))

	aAdd(aButtons, { 14, .T., {|| ShellExecute("open","https://tdn.totvs.com/pages/releaseview.action?pageId=777915746","","",1) } } )
	aAdd(aButtons, { 1, .T., {|o| nOpcA := 1,FechaBatch() } } )
	aAdd(aButtons, { 2, .T., {|o| FechaBatch() } } )

	//Abre a tela de processamento
	FormBatch( "Incluindo registros na tabela RU2 - Informa��es Complementares Menor Aprendiz", aSays, aButtons )

	//Efetua o processamento de gera��o
	If nOpcA == 1
		Aadd( aLog, {OemToAnsi( "Funcion�rios processados:" )} )
        Aadd( aLog, {} )
		Aadd( aLog, {} )
		ProcGpe( {|lEnd| fNewRU2()},,,.T. )
		fMakeLog(aLog,,,,"ATURU2",OemToAnsi("Log de Ocorr�ncias"),"M","P",,.F.)
	EndIf

Return

/*/{Protheus.doc} fNewRU2
Fun��o respons�vel pelo processamento da Inclus�o
@author  raquel.andrade
@since   17/07/2023
@version 1.0
/*/
Static Function fNewRU2()

    Local cAliasQry	:= GetNextAlias()
    Local cCatEFD   := "103"
    Local cTitLog   := ""
    Local cMsgYesNo := ""
    Local nX        := 0
    Local aReg      := {}    
    Local lProcessado  := .F.

    cMsgYesNo	:= OemToAnsi("Log de Ocorr�ncias exibir� apenas os registros inclu�dos (NOVO)." + CRLF	+ CRLF +  "Deseja visualizar os registros j� Processados?")
	cTitLog		:= OemToAnsi( "Aten��o" )	// Atencao!"
	 
	lProcessado	:= MsgYesNo( OemToAnsi( cMsgYesNo ) ,  OemToAnsi( cTitLog ) ) 

    //Pesquisa pelo registro na C9V
    BeginSqL alias cAliasQry
        SELECT SRA.RA_FILIAL, SRA.RA_MAT, SRA.RA_CATEFD,SRA.RA_PLAPRE, SRA.RA_TIPCTA
        FROM %Table:SRA% SRA
        WHERE SRA.RA_CATEFD IN (%Exp:cCatEFD%)
            AND SRA.RA_PLAPRE <> ""
            AND SRA.RA_TIPCTA <> ""
            AND SRA.%NotDel%
        GROUP BY SRA.RA_FILIAL, SRA.RA_MAT, SRA.RA_CATEFD, SRA.RA_PLAPRE,SRA.RA_TIPCTA
    EndSql

    //Valida se � preciso ajustar o CODUNIC e confirma com o usu�rio a altera��o
    If (cAliasQry)->(Eof())
        aAdd( aLog[2], "N�o existem registros a serem inclu�dos." )
    Else       
        //Adiciona os registros encontrados num array
        While (cAliasQry)->(!Eof())
            cChave := (cAliasQry)->RA_FILIAL + (cAliasQry)->RA_MAT
            If aScan( aReg, { |x| x[1]+x[2] == cChave } ) == 0 
                aAdd( aReg, { (cAliasQry)->RA_FILIAL,(cAliasQry)->RA_MAT,  (cAliasQry)->RA_PLAPRE, (cAliasQry)->RA_TIPCTA } )
            EndIf
            (cAliasQry)->(dbSkip())
        EndDo

        Begin Transaction

            If Len(aReg) > 0
                For nX := 1 to Len(aReg)
                    // Grava na RU2
                    dbSelectArea("RU2")
                    RU2->(dbSetOrder(1))
                    RU2->(dbGoTop())	
                    // Verifica se j� n�o est� gravado	- relacionamento com SRA � de 1x1
                    If !(RU2->(dbSeek(aReg[nX][1] + aReg[nX][2])))				
                        Reclock("RU2", .T.)
                        RU2->RU2_FILIAL := aReg[nX][1]
                        RU2->RU2_MAT    := aReg[nX][2]                        
                        RU2->RU2_NUMINS	:= aReg[nX][3] // RA_PLAPRE
                        RU2->RU2_TPINSC	:= aReg[nX][4] // RA_TIPCTA 
                        RU2->RU2_INDMOD	:= "2"
                        RU2->(MsUnlock())
                        aAdd( aLog[2], "Registro NOVO - " + "Filial: " + aReg[nX][1] + " Matr�cula: - " + aReg[nX][2] )
                    Else  
                        If lProcessado             
                            aAdd( aLog[2], "Registro j� Processado - " + "Filial: " + aReg[nX][1] + " Matr�cula: - " + aReg[nX][2] )
                        EndIf
                    EndIf
                Next nX
            EndIf 

        End Transaction       
    EndIf

    (cAliasQry)->( dbCloseArea() )    

Return
