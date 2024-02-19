#INCLUDE "PROTHEUS.CH"

User Function UPDDIFIRADI()

Local aButtons      := {}
Local aSays         := {}
Local bFilt			:= { || GpFltBldExp( "SRA" , NIL , @cExpFiltro , NIL ) }
Local cExpFiltro    := ""
Local nOpcA         := 0

Private aLogUPD     := {}
Private aTitle      := {}

aAdd(aSays,OemToAnsi( "Este programa tem como objetivo apurar eventual diferença de IR de adiantamento" ))
aAdd(aSays,OemToAnsi( "do período de 05/2023 para empresas com pagamento da folha em regime caixa." ))
aAdd(aSays,OemToAnsi( 'Clique no botão "Abrir" para abrir a documentação no TDN.'))
aAdd(aSays,OemToAnsi( "" ))

aAdd(aButtons, { 14 ,.T.,{||  ShellExecute("open","https://tdn.totvs.com/pages/viewpage.action?pageId=764331643","","",1) } } )
aAdd(aButtons, { 17,.T.,bFilt } )
aAdd(aButtons, { 1,.T.,{|o| nOpcA := 1,IF(gpconfOK(), FechaBatch(), nOpcA := 0 ) }} )
aAdd(aButtons, { 2,.T.,{|o| FechaBatch() }} )

//Abre a tela de processamento
FormBatch( "Apuração da diferença do IR de adiantamento", aSays, aButtons )

//Efetua o processamento de geração
If nOpcA == 1
	If Empty(cExpFiltro) .And. !MsgNoYes( "Nenhum filtro foi selecionado! Processar toda a tabela?", "Atenção" )
        Return
	EndIf
       
    If Aviso( "Atenção", "Confirma a leitura da documentação técnica, onde há explicação do uso do programa restrito para o período de 05/2023 e do procedimento manual que deve ser efetuado?", { "Sim", "Não" }, 3 ) == 2
        Return
    EndIf

    Aadd( aTitle, OemToAnsi( "Funcionários que tiveram diferenças geradas:" ) )
    Aadd( aLogUPD, {} )
    ProcGpe( {|lEnd| fProcessa( cExpFiltro )},,,.T. )
    If !Empty( aLogUPD[1] )
        fMakeLog(aLogUPD,aTitle,,,"UPDDIFIRADI",OemToAnsi("Log de Ocorrências"),"M","P",,.F.)
    EndIf
EndIf

Return

/*/{Protheus.doc} fProcessa
Função que efetua o processamento
/*/
Static Function fProcessa( cFiltroSRA )

Local aAreaSRA      := SRA->( GetArea() )
Local aPeriodo      := {}
Local cAliasQry     := GetNextAlias()
Local cFilOld       := ""
Local cProcOld      := ""
Local cWhere        := ""
Local nPosSem       := 0

If !Empty(cFiltroSRA)
    cFiltroSRA 	:= GPEParSQL(fPrepExpIn(cFiltroSRA))
    cWhere 		+= "( " + cFiltroSRA + " ) AND "
EndIf

cWhere := "%" + cWhere + "%"

BeginSql alias cAliasQry
    SELECT SRA.R_E_C_N_O_ AS RECNO
    FROM %table:SRA% SRA
    WHERE %exp:cWhere% 
            EXISTS ( SELECT * FROM %table:SRD% SRD WHERE SRD.RD_FILIAL = SRA.RA_FILIAL AND SRD.RD_MAT = SRA.RA_MAT AND SRD.RD_PERIODO = '202305' AND SRD.RD_ROTEIR = 'ADI' AND SRD.%notDel%) AND
            SRA.%notDel%            
    ORDER BY RA_FILIAL,RA_MAT
EndSql 

SetMnemonicos(NIL, NIL, .T.)

While (cAliasQry)->( !EoF() )
    SRA->( dbGoTo( (cAliasQry)->RECNO ) )

    If SRA->RA_FILIAL != cFilOld
        aCodFol     := {}
        aPeriodo    := {}
        aTabIr      := Array(7, 4)
        cFilOld     := SRA->RA_FILIAL
        dData_Pgto  := cToD("//")

        RstaCodFol()
        Fp_CodFol(@aCodFol, SRA->RA_FILIAL, .F., .F.)          
        RstGpexIni()
        CargaIr( @aTabIr, "202305" )
        If fCarPeriodo( "202305", "ADI", @aPeriodo, Nil, @nPosSem)
            dData_Pgto  := aPeriodo[nPosSem, 17]
        EndIf
    ElseIf SRA->RA_PROCES != cProcOld
        aPeriodo    := {}
        cProcOld    := SRA->RA_PROCES
        dData_Pgto  := cToD("//")

        If fCarPeriodo( "202305", "ADI", @aPeriodo, Nil, @nPosSem)
            dData_Pgto  := aPeriodo[nPosSem, 17]
        EndIf
    EndIf

    fRecalc()
       
    (cAliasQry)->( dbSkip() )
EndDo

(cAliasQry)->( dbCloseArea() )

RestArea( aAreaSRA )

Return

/*/{Protheus.doc} fRecalc
Função que irá recalcular o roteiro PLA
/*/
Static Function fRecalc()

Local nCont         := 0
Local nDifIRAdi     := 0
Local nValIRAnt     := 0

aPd         := {}
Calcule     := "S"    
cNumPag     := "02"
cProcesso   := SRA->RA_PROCES
cRot        := "ADI"
cSemana     := "02"
cPeriodo    := "202305"
dDataAte    := cToD("31/05/2023")
IR_Calc     := 0
Val_Adto    := 0

fCarMvto(SRA->RA_FILIAL, SRA->RA_MAT, "01", SRA->RA_PROCES, "202305", "ADI", "01", Nil, .F.)

For nCont := 1 To Len(aPd)
    If aPd[nCont, 1] $ (aCodFol[9, 1]+"/"+aCodFol[10, 1]+"/"+aCodFol[546, 1]+"/")
        aPd[nCont, 9] := "D"
    EndIf
    If aPd[nCont, 1] == aCodFol[6, 1]
        Val_Adto += aPd[nCont, 5]
    EndIf
    If aPd[nCont, 1] == aCodFol[9, 1]
        nValIRAnt += aPd[nCont, 5]
    EndIf
    aPd[nCont, 3] := "02"
Next

FBaseIni()
FM010IncIR()

nDifIRAdi := IR_CALC - nValIRAnt

If nDifIRAdi > 0
    aAdd( aLogUPD[1], "Filial: " + SRA->RA_FILIAL + "  -  Matrícula: " + SRA->RA_MAT )
    aAdd( aLogUPD[1], "----- Verba gerada: " + aCodfol[9, 1] + " | Diferença gerada: R$ " + Transform( nDifIRAdi, "@E 99,999.99" ) + " || Valor anterior: R$ " + Transform( nValIRAnt, "@E 99,999.99" ) + " | Valor correto: R$ " + Transform( IR_CALC, "@E 99,999.99" ) )
    
    aPd := {}
    FMatriz( aCodfol[9, 1], nDifIRAdi, Nil, Nil, Nil, Nil, "A" )
    fLiquido(aCodfol, aCodFol[546,1], 0, Nil, .T., aCodFol[45,1], Nil, .T.)
    GravaCalc()
EndIf

Return
