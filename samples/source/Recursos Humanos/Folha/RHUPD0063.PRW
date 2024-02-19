#INCLUDE "PROTHEUS.CH"

User Function RHUPD0063()

    Local aButtons  := {}
    Local aSays     := {}
    Local cMsg      := ""
    Local nOpcA     := 0
    Local aErros	:= {}
    Local cMsgHelp	:= ""
    Local cLink		:= 'https://tdn.totvs.com/x/If-zLQ'

    Private aLog    := {}
    Private aTitle  := {}
    Private cPerg   := "RHUPD0063"

    // VERIFICA SE ENCONTROU O GRUPO DE PERGUNTAS
    If !SX1->(DbSeek(cPerg))
        cMsg :=  + CRLF + OemToAnsi("Não foi encontrado o grupo de perguntas") + Alltrim(cPerg) //Não foi encontrado o grupo de perguntas

        cMsgHelp := ""
        cMsgHelp += + CRLF + OemToAnsi("Antes de prosseguir será necessário criar o grupo de perguntas. Para isso, siga as instruções contidos no link abaixo:")
        cMsgHelp += + CRLF + cLink + CRLF

        aAdd(aErros, cMsgHelp)

        Help(,, 'NOPERGUNT',, cMsg, 1, 0,,,,,, {aErros})

        Return()
    EndIf

    aAdd(aSays,OemToAnsi( "Este programa tem por objetivo gerar uma verba no cálculo de folha com valor" ))
    aAdd(aSays,OemToAnsi( "correspondente ao Id 0063. A correta configuração desta verba assim como maiores" ))
    aAdd(aSays,OemToAnsi( "informações deste ajuste podem ser consultadas em nossa documentação." ))
    aAdd(aSays,OemToAnsi( "Clique em abrir para consultar." ))


    aAdd(aButtons, { 14,.T.,{|| ShellExecute("open",cLink,"","",1) } } )
    aAdd(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) } } )
    aAdd(aButtons, { 1,.T.,{|o| nOpcA := 1,IF(gpconfOK(), FechaBatch(), nOpcA := 0 ) }} )
    aAdd(aButtons, { 2,.T.,{|o| FechaBatch() }} )

    //Abre a tela de processamento
    FormBatch( OemToAnsi( "Cópia do valor da verba de Id 0063 do adiantamento para a folha" ), aSays, aButtons )

    //Efetua o processamento de geração
    If nOpcA == 1
        Aadd( aTitle, OemToAnsi( "Funcionários ajustados:" ) )
        Aadd( aLog, {} )
        ProcGpe( {|lEnd| fProcessa()},,,.T. )
        fMakeLog(aLog,aTitle,,,cPerg,OemToAnsi( "Log de Ocorrências" ),"M","P",,.F.)
    EndIf

Return

/*/{Protheus.doc} fProcessa
Função que efetua o processamento para a geração dos Id`s
/*/
Static Function fProcessa()

    Local cAliasQry := GetNextAlias()
    Local cFilOld   := cFilAnt
    Local cWhere    := ""
    Local cPd0063   := ""
    Local cPd0066   := ""
    Local cDtIni    := ""
    Local cDtFim    := ""
    Local cChvProc  := ""
    Local dDatPgt   := CTOD("//")
    Local nVlrIR    := 0
    Local lRotFOL   := .F.
    Local lProc     := .F.
    Local aCodFol   := {}

    If MsgNoYes("Foi efetuado backup da tabela SRD?", "Atenção!") .And. MsgYesNo("Tem certeza que quer continuar?", "Atenção!")

        dbSelectArea("RCH")
        dbSelectArea("SRD")

        //Carrega o array aCodFol para verificar o cadastro de verbas x Ids de cálculo
        Fp_CodFol(@aCodFol, xFilial("SRV", cFilAnt), .F., .F.)

        //Obtém o código da verba de Id 0063 e 0066
        If Len(aCodFol) >= 66 .And. !Empty(aCodFol[66,1])
            cPd0063 := aCodFol[63,1]
            cPd0066 := aCodFol[66,1]
        EndIf

        Pergunte( cPerg, .F. )
        MakeSqlExpr( cPerg )

        //Filial
        If !Empty(mv_par01)
            cWhere += mv_par01
        EndIf

        //Matricula
        If !Empty(mv_par02)
            cWhere += Iif(!Empty(cWhere)," AND ","")
            cWhere += mv_par02
        EndIf

        If Empty(mv_par03) .Or. Empty(mv_par04)
            aAdd( aLog[1],  OemToAnsi( "Verifique o preenchimento dos parâmetros. Período ou verba não foi informada." ))
            Return
        EndIf

        //Periodo
        cDtIni := mv_par03+"01"
        cDtFim := dtos(lastday(stod(mv_par03+"01")))
        cWhere += Iif(!Empty(cWhere)," AND ","")
        cWhere += "SRD.RD_DATPGT BETWEEN '" + cDtIni +"' AND  '" + cDtFim +"' " 
        cWhere += Iif(!Empty(cWhere)," AND ","")  
        cWhere += "SRD.RD_PD = '" + cPd0063 +"'" 
        cWhere := "%" + cWhere + "%"


        //Processa a query e cria a tabela temporária com os resultados
        BeginSql alias cAliasQry
            SELECT SRD.RD_FILIAL, SRD.RD_MAT, SRD.RD_PD, SRD.RD_VALOR, SRD.RD_DATARQ, SRD.RD_DATPGT, SRD.RD_CC, SRD.RD_PROCES, SRD.RD_ROTEIR, SRD.RD_SEMANA
            FROM %table:SRD% SRD
            WHERE %exp:cWhere% AND
                SRD.RD_ROTEIR = 'ADI' AND
                SRD.%notDel%
            GROUP BY SRD.RD_FILIAL, SRD.RD_MAT, SRD.RD_PD, SRD.RD_VALOR, SRD.RD_DATARQ, SRD.RD_DATPGT, SRD.RD_CC, SRD.RD_PROCES, SRD.RD_ROTEIR, SRD.RD_SEMANA
            ORDER BY SRD.RD_FILIAL, SRD.RD_MAT, SRD.RD_PD, SRD.RD_VALOR, SRD.RD_DATARQ, SRD.RD_DATPGT, SRD.RD_CC, SRD.RD_PROCES, SRD.RD_ROTEIR, SRD.RD_SEMANA
        EndSql

        While (cAliasQry)->( !EoF() )

            //Carrega o array aCodFol para verificar o cadastro de verbas x Ids de cálculo
            If xFilial("SRV",(cAliasQry)->RD_FILIAL) != xFilial("SRV",cFilOld)
                cFilOld := (cAliasQry)->RD_FILIAL
                cPd0063 := ""
                cPd0066 := ""
                aCodFol := {}
                Fp_CodFol(@aCodFol, xFilial("SRV", (cAliasQry)->RD_FILIAL))
                //Obtém o código da verba de Id 0063 e 0066
                If Len(aCodFol) >= 66 .And. !Empty(aCodFol[66,1])
                    cPd0063 := aCodFol[63,1]
                    cPd0066 := aCodFol[66,1]
                EndIf
            EndIf

            //Obtém o valor e data de pagamento do IR Devolvido na verba de Id 0063
            nVlrIR  := (cAliasQry)->RD_VALOR
            dDatPgt := stod((cAliasQry)->RD_DATPGT)
            cProce  := (cAliasQry)->RD_PROCES

            //Procura se há o roteiro FOL ou AUT
            If cChvProc <> xFilial("RCH",(cAliasQry)->RD_FILIAL) + (cAliasQry)->RD_PROCES
                lRotFOL := .F. 
                RCH->( dbSetOrder(1) ) //Ordena a tabela RCH pela ordem 1 - RCH_FILIAL+RCH_PROCES+RCH_PER+RCH_NUMPAG+RCH_ROTEIR                                                                                              
                If RCH->( dbSeek( xFilial("RCH",(cAliasQry)->RD_FILIAL) + (cAliasQry)->RD_PROCES + (cAliasQry)->RD_DATARQ + (cAliasQry)->RD_SEMANA + "FOL"))
                    lRotFOL := .T.
                EndIf
            EndIf   

            cChvProc := xFilial("RCH",(cAliasQry)->RD_FILIAL) + (cAliasQry)->RD_PROCES 

            //Procura a verba de IR no pagamento FOL/AUT do período anterior
            SRD->( dbSetOrder(5) ) //Ordena a tabela SRD pela ordem 5 - RD_FILIAL+RD_MAT+RD_PROCES+RD_ROTEIR+RD_PERIODO+RD_SEMANA+RD_PD                                                                                                 
            If SRD->( dbSeek( (cAliasQry)->RD_FILIAL + (cAliasQry)->RD_MAT + (cAliasQry)->RD_PROCES + If(lRotFOL, "FOL", "AUT") + SubMesAno((cAliasQry)->RD_DATARQ) + (cAliasQry)->RD_SEMANA + cPd0066))
                lProc := .T.
                //Grava a verba de ContraPartida na SRD
                If nVlrIR <= SRD->RD_VALOR
                    fGravaSRD(SRD->RD_FILIAL, SRD->RD_MAT, MV_PAR04, SRD->RD_DATARQ, SRD->RD_SEMANA, SRD->RD_DATPGT, " ", SRD->RD_PROCES, SRD->RD_DTREF, SRD->RD_CC, nVlrIR, If(lRotFOL, "FOL", "AUT"))
                EndIf
            EndIf            

            //Pula para o próximo registro
            (cAliasQry)->( dbSkip() )
        EndDo

        //Fecha a tabela temporária da query
        (cAliasQry)->( dbCloseArea() )

        If !lProc
            aAdd( aLog[1],  OemToAnsi( "Não foram encontrados registros para processamento." ))
        EndIf

    EndIf

Return

/*/{Protheus.doc} fGravaSRD
Função responsável pela gravação na SRD
/*/
Static Function fGravaSRD(cCodFil, cCodMat, cPD, cPer, cSem, dDtPag, cSeq, cProc, dDtRef, cCenCus, nValor, cRot )

    Local aArea	    := GetArea()
    Local aAreaSRD  := SRD->(GetArea())
    Local lNovo := .T.

    //Trava o registro na SRD para edição
    dbSelectArea("SRD")
    SRD->( dbSetOrder(1) ) //Ordena a tabela SRD pela ordem 1 - RD_FILIAL+RD_MAT+RD_DATARQ+RD_PD+RD_SEMANA+RD_SEQ+RD_CC
    lNovo := SRD->( !dbSeek( cCodFil + cCodMat + cPer + cPD + cSem + cSeq + cCenCus ))

    If SRD->( RecLock("SRD", lNovo) )
        //Se for inclusão, grava todos campos da SRD
        //Se for alteração, apenas altera o valor do registro
        If lNovo
            SRD->RD_FILIAL  := cCodFil
            SRD->RD_MAT     := cCodMat
            SRD->RD_CC      := cCenCus
            SRD->RD_PD      := cPD
            SRD->RD_TIPO1   := "V"
            SRD->RD_DATARQ  := cPer
            SRD->RD_DATPGT  := dDtPag
            SRD->RD_SEQ     := ""
            SRD->RD_TIPO2   := "I"
            SRD->RD_MES     := SubStr( cPer, 5, 2 )
            SRD->RD_STATUS  := "A"
            SRD->RD_INSS    := "N"
            SRD->RD_IR      := "N"
            SRD->RD_FGTS    := "N"
            SRD->RD_PROCES  := cProc
            SRD->RD_PERIODO := cPer
            SRD->RD_SEMANA  := cSem
            SRD->RD_ROTEIR  := cRot
            SRD->RD_DTREF   := dDtRef
        EndIf

        SRD->RD_VALOR   := nValor
        
        aAdd( aLog[1], OemToAnsi( "Filial " ) + cCodFil + OemToAnsi( "  -  Matrícula: " ) + cCodMat + OemToAnsi( "  -  Período: " ) + cPer + OemToAnsi( "  -  Verba: " ) + cPD + OemToAnsi( "  -  Valor: R$ " ) + Transform( nValor, "@E 99,999,999,999.99" ) )
 
        //Libera o registro da SRD
        SRD->( MsUnlock() )
    EndIf

    RestArea(aAreaSRD)
    RestArea(aArea)

Return
