#Include 'Protheus.ch'
#Include 'poncalen.ch'

static _cEscala 	:= ""
static _cCalend 	:= ""
static _lSum444 	:= TDV->(FieldPos("TDV_FERSAI")) > 0 .AND. TDV->(FieldPos("TDV_FSTPEX")) > 0 .AND. TDV->(FieldPos("TDV_FSEXTN")) > 0 // Verificação de campos para sumula 444
static _lIntra 		:= TDW->(FieldPos("TDW_INTRA")) > 0 // Verificação de campos para intrajornada
Static aDiasNProc	:= {}
Static cHasCompen   := "0"
Static _TrbPrxFer   := TGY->(FieldPos("TGY_PROXFE")) > 0

//ESTRUTURA DO ARRAY DE EXCEÇÕES
#DEFINE EXCECAO_DIAS 01
#DEFINE EXCECAO_FERIADOS 02
#DEFINE EXCECAO_ELEMENTOS 02

//ESTRUTURA DO ARRAY DOS ITENS DE EXCEÇÕES
#DEFINE EXCECAO_ITEM_TURNO			01
#DEFINE EXCECAO_ITEM_SEQUENCIA		02
#DEFINE EXCECAO_ITEM_DIASEM			03
#DEFINE EXCECAO_ITEM_ENTRA1			04
#DEFINE EXCECAO_ITEM_SAIDA1			05
#DEFINE EXCECAO_ITEM_ENTRA2			06
#DEFINE EXCECAO_ITEM_SAIDA2			07
#DEFINE EXCECAO_ITEM_ENTRA3			08
#DEFINE EXCECAO_ITEM_SAIDA3			09
#DEFINE EXCECAO_ITEM_ENTRA4			10
#DEFINE EXCECAO_ITEM_SAIDA4			11
#DEFINE EXCECAO_ITEM_TIPO			12
#DEFINE EXCECAO_ITEM_TROCASEQ		13
#DEFINE EXCECAO_ITEM_LIM_SUPERIOR	14
#DEFINE EXCECAO_ITEM_LIM_INFERIOR	15
#DEFINE EXCECAO_ITEM_TRABSDF    	16
#DEFINE EXCECAO_ITEM_ELEMENTOS		16

//ESTRUTURA DO ARRAY DO CALENDARIO DE FERIADOS
#DEFINE FERIADO_ITEM_DATA			01
#DEFINE FERIADO_ITEM_TP_HE			02
#DEFINE FERIADO_ITEM_TP_HE_NT		03
#DEFINE FERIADO_ITEM_DESC			04
#DEFINE FERIADO_ITEM_FIXO			05
#DEFINE FERIADO_MES_DIA				06
#DEFINE FERIADO_ITEM_ELEMENTOS		06

#DEFINE AGENDA_DATAINI			01
#DEFINE AGENDA_HORAINI			02
#DEFINE AGENDA_DATAFIM			03
#DEFINE AGENDA_HORAFIM			04
#DEFINE AGENDA_DATA_APONT 		05
#DEFINE AGENDA_TIPODIA 			06
#DEFINE AGENDA_TURNO			07
#DEFINE AGENDA_SEQUENCIA 		08
#DEFINE AGENDA_CC				09
#DEFINE AGENDA_FERIADO			10
#DEFINE AGENDA_FERIADO_TPEXT	11
#DEFINE AGENDA_FERIADO_TPEXTN	12
#DEFINE AGENDA_FERIADO_DESC		13
#DEFINE AGENDA_LIM_INFERIOR		14
#DEFINE AGENDA_LIM_SUPERIOR		15
#DEFINE AGENDA_TIPO_HE_NOR		16
#DEFINE AGENDA_TIPO_HE_NOT		17
#DEFINE AGENDA_PG_NONA_HORA		18
#DEFINE AGENDA_COD_REFEICAO		19
#DEFINE AGENDA_INTSREP			20
#DEFINE AGENDA_INI_H_NOT		21
#DEFINE AGENDA_FIM_H_NOT		22
#DEFINE AGENDA_MIN_H_NOT		23
#DEFINE AGENDA_APON_FERIAS		24
#DEFINE AGENDA_TP_HE_NR_FER		25
#DEFINE AGENDA_TP_HE_NT_FER		26
#DEFINE AGENDA_HE_AUTO_FER		27
#DEFINE AGENDA_HRS_INTER		28
#DEFINE AGENDA_INTERVALO1		29
#DEFINE AGENDA_INTERVALO2		30
#DEFINE AGENDA_INTERVALO3		31
#DEFINE AGENDA_INTRAJORNADA		32
#DEFINE AGENDA_INTRA_INTVL1		33
#DEFINE AGENDA_INTRA_INTVL2		34
#DEFINE AGENDA_HRS_INTRA			35
#DEFINE AGENDA_FERIADO_SAIDA			36
#DEFINE AGENDA_FERIADO_TPEXT_SAIDA		37
#DEFINE AGENDA_FERIADO_TPEXTN_SAIDA	38
#DEFINE AGENDA_FERIADO_DESC_SAIDA		39
#DEFINE AGENDA_CODIGO_ABN       		40
#DEFINE AGENDA_TGY_DTINI       		    41
#DEFINE AGENDA_TGY_DTFIM       		    42
#DEFINE AGENDA_USA_TGY                  43
#DEFINE AGENDA_FILIAL_TDV               44
#DEFINE AGENDA_ELEMENTOS				44


/*/{Protheus.doc} PNMTABC01
Ponto de Entrada para processamento do calendário de acordo com configurações do Gestão de Serviços
@since 08/07/2014
@version 1.0
@return aCalend, Array com o calendário
@example
(examples)
@see (links_or_references)
/*/
User Function PNMTABC01()
	Local aCalend := ParamIxb[1]
	Local lCriaOk := ParamIxb[2]
	Local cFil := If(Len(ParamIxb)>=3, ParamIxb[3], Nil)//Filial Funcionário
	Local cMat := If(Len(ParamIxb)>=4,ParamIxb[4], Nil)//Matricula Funcionário
	Local cEscala := U_PNMGEsc()
	Local cCalend := U_PNMGCal()
	Local cCodAtend := ""

		
	If lCriaOk .AND. !IsInCallStack ("TECA330") .AND.  !IsInCallStack ("TECA331")
		
		If !Empty(cEscala)	
			aCalend := procEsc(cEscala, cCalend, aCalend)	
		EndIf
		
		If 	cFil != Nil .AND. cMat != Nil
			cCodAtend := GetAtend(cFil, cMat)
			If !Empty(cCodAtend)
				//Realiza carregamento da Agenda do Atendente.
				aCalend := ProcFunc(aCalend, cCodAtend)
				If !EMPTY(aDiasNProc)
					AjustaDias(@aCalend)
				EndIf
			EndIf
		EndIf

	EndIf
	aDiasNProc	:= {}
Return aCalend


/*/{Protheus.doc} ProcFunc
Realiza processamento do calendário de acordo com a agenda do atendente
@since 08/07/2014
@version 1.0
@param aCalend, array, Calendário do ponto eletronico
@param cCodAtend, character, Código do Atendente
@return aCalend, Array, Calendário após processamento
/*/
Static Function ProcFunc(aCalend, cCodAtend)
	Local dDataIni := If(Len(aCalend) > 0, aCalend[1][CALEND_POS_DATA_APO], STOD(""))
	Local dDataFim := If(Len(aCalend) > 0, aCalend[Len(aCalend)][CALEND_POS_DATA_APO], STOD(""))
	Local aAgenda := {}
	Local nI := 1
	Local nJ := 1 	
	Local aRows := {}
	Local aCalendAux := {}		
		
	
	//Realiza Leitura na ABB	
	aAgenda := GetAgenda(cCodAtend, dDataIni, dDataFim)	
	
	For nI:=1 To Len(aCalend)	
		If aCalend[nI][CALEND_POS_TIPO_MARC] == "1E"
			
			aRows := TrataAgenda(aClone(aCalend[nI]), aAgenda, aCalendAux )
			
			If Len(aRows) > 1
				For nJ:=1 To Len(aRows)
					aAdd(aCalendAux, aRows[nJ])
				Next nJ
			EndIf
			
		EndIf
	
	Next nI

Return aCalendAux


/*/{Protheus.doc} TrataAgenda
Realiza tratamento para geração do calendário baseado na agenda do Atendente 
@since 08/07/2014
@version 1.0
@param aRow, array, Linha do aTabCalend
@param aAgenda, array, Informações da agenda do atendente
@return aRows, array, Linhas geradas para o aTabCalend de acordo com a agenda do atendente 
/*/
Static Function TrataAgenda(aRow, aAgenda, aCalendAux)
	Local nPos := 0	
	Local aRows := {}
	Local nI := 1
	Local nMarc := 1
	Local lTrab := .F.//Verifica se possui dias trabalhados
	Local lFolga := .F.
	Local lDiaComp := .F.
	Local nIndEnt := 0
	Local nIndSai := 0
	
	nPos := aScan(aAgenda, {|x| x[1] == aRow[CALEND_POS_DATA_APO]})
	lFolga := nPos == 0
	
	If cHasCompen == "0"
	    If FindFunction("TecABRComp")
	        If TecABRComp()
	            cHasCompen := '1'
	        Else
	            cHasCompen := '2'
	        EndIf
	    Else
	        cHasCompen := '2'
	    EndIF
	EndIf
	If cHasCompen == '1' .AND. !lFolga
	    If !EMPTY(aAgenda[nPos][2][1][AGENDA_CODIGO_ABN])
	        If Posicione("ABN",1,xFilial("ABN")+aAgenda[nPos][2][1][AGENDA_CODIGO_ABN], "ABN_TIPO") == "09"
	            lFolga := .T.
	            lDiaComp := .T.
	        EndIf
	    EndIf
	EndIf
	
	If !lFolga	

		lTrab := hasDiaTrab(aAgenda[nPos][2])//VErifica se existe dias trabalhados
		
		//Verifica indice de entrada e saida para caso existir intervalos trabalhados e não trabalhados
		If lTrab
			For nI:=1 To Len(aAgenda[nPos][2])				
				If  aAgenda[nPos][2][nI][AGENDA_TIPODIA] == "S"
					If nIndEnt == 0//INdice de entrada
						nIndEnt := nI
					EndIf
					
					nIndSai := nI
				EndIf
			Next nI
		Else
			nIndEnt := 1
			nIndSai := Len(aAgenda[nPos][2])
		EndIf
		
		//Gera Linhas do aTabCalend com base na agenda
		For nI := 1 To Len(aAgenda[nPos][2])				
			
			//Quando existir intervalos trabalhados e não trabalhados deve retornar somente as agendas do dia trabalhado
			//Quando existir somente dias não trabalhados deve retornar todos intervalos.
			If !lTrab .OR. aAgenda[nPos][2][nI][AGENDA_TIPODIA] == "S"
			 
				//Gera Linha de acordo com a agenda, gerando limite de marcação na primeira entrada e ultima saida			
				aAdd(aRows, GetRowByAg( aRow, aAgenda[nPos][2][nI], nMarc, .T., If(nI==nIndEnt, .T., .F.)))//Entrada
				
				If (aAgenda[nPos][2][nI][AGENDA_INTRAJORNADA])//Inclui informações referente a configuração de intrajornada
					aAdd(aRows, GetRowByAg( aRow, aAgenda[nPos][2][nI], nMarc, .F., .F., .T.))
					aAdd(aRows, GetRowByAg( aRow, aAgenda[nPos][2][nI], ++nMarc, .T., .F., .T.))	
				EndIf
				
				aAdd(aRows, GetRowByAg( aRow, aAgenda[nPos][2][nI], nMarc, .F., If(nI==nIndSai, .T., .F.)))//Saida
				
				nMarc++
			EndIf
		Next nI
		
	Else
		aAdd(aRows, getRowFolg( aRow, .T., aCalendAux, aAgenda,.T.,!lDiaComp))
		aAdd(aRows, getRowFolg( aRow, .F., aCalendAux, aAgenda,.T.,!lDiaComp))		
	EndIf	
	
Return aRows



Static Function hasDiaTrab(aAgendas)
	Local nI := 1
	Local lRet := .F.
	
	For nI := 1 To LEn(aAgendas)
		If aAgendas[nI][AGENDA_TIPODIA] == "S"
			lRet := .T.
			Exit
		EndIf
	Next nI
	
Return lRet


/*/{Protheus.doc} getRowFolg
Ajusta linha do aTabCalend para indicar dia de folga do atendente
@since 08/07/2014
@version 1.0
@param aBase, array, Linha base do aTabCalend
@param lEntrada, Boolean, Indica se será realizdo processamento de Entrada ou Saída
@return aRow, array com linha de folga para o aTabCalend
/*/
Static Function getRowFolg(aBase, lEntrada, aCalendAux, aAgenda, lAltera, lDayType)
Local aRow := aClone(aBase)
Local nX := 0
Local nY := 0
Local nZ := 0
Local nBkpnY := 0
Local nBkpnZ := 0
Local nPosAux := 0
Local cPOS_SEQ := ""
Local lFoundTGY := .F.
Local lOtherTGY := .F.
Local cFilProc := cFilAnt

Default lAltera := .F.
Default aAgenda := {}
Default lDayType := .T.
If lEntrada
    aRow[CALEND_POS_TIPO_MARC	] := "1E"
Else
    aRow[CALEND_POS_TIPO_MARC	] := "1S"
EndIf

aRow[CALEND_POS_HORA] := 0
If !lAltera
    aRow[CALEND_POS_TIPO_DIA] := 'N'
Else
    For nX := LEN(aCalendAux) to 1 STEP -1
        If !EMPTY(aCalendAux[nX][CALEND_POS_HORA]) .AND. aCalendAux[nX][CALEND_POS_TIPO_DIA] == 'S'
            nPosAux := nX
            Exit
        EndIf
    Next nX
    
    If nPosAux > 0
        aRow[CALEND_POS_TURNO] := aCalendAux[nPosAux][CALEND_POS_TURNO]
        cPOS_SEQ := aCalendAux[nPosAux][CALEND_POS_SEQ_TURNO]
        If lDayType .AND. !EMPTY(aAgenda) .AND. (aRow[CALEND_POS_DATA_APO] >= aAgenda[1][1] .AND. aRow[CALEND_POS_DATA_APO] <= aAgenda[Len(aAgenda)][1])
            If LEN(aAgenda[1]) >= 2 .AND. VALTYPE(aAgenda[1][2]) == 'A' .AND.;
                    VALTYPE(aAgenda[1][2][1]) == "A" .AND. GetFilProc(@cFilProc, aRow, aAgenda) .AND. aAgenda[1][2][1][AGENDA_USA_TGY]
                For nY := 1 To LEN(aAgenda)
                    For nZ := 1 To LEN(aAgenda[nY][2])
                        If aAgenda[nY][2][nZ][AGENDA_TURNO] == aRow[CALEND_POS_TURNO] .AND. aRow[CALEND_POS_DATA_APO] >= aAgenda[nY][2][nZ][AGENDA_TGY_DTINI] .AND.;
                                aRow[CALEND_POS_DATA_APO] <= aAgenda[nY][2][nZ][AGENDA_TGY_DTFIM]
                            lFoundTGY := .T.
                            Exit
                        EndIf
                    Next nZ
                    If lFoundTGY
                        Exit
                    EndIf
                Next nY
                If !lFoundTGY
                    //Um outro FOR para garantir que não existe a TGY
                    For nY := 1 To LEN(aAgenda)
                        For nZ := 1 To LEN(aAgenda[nY][2])
                            If !EMPTY(aAgenda[nY][2][nZ][AGENDA_TGY_DTINI]) .AND. aAgenda[nY][2][nZ][AGENDA_TURNO] != aRow[CALEND_POS_TURNO] .AND.;
                                    aRow[CALEND_POS_DATA_APO] >= aAgenda[nY][2][nZ][AGENDA_TGY_DTINI] .AND.;
                                    aRow[CALEND_POS_DATA_APO] <= aAgenda[nY][2][nZ][AGENDA_TGY_DTFIM]
                                lOtherTGY := .T.
                                nBkpnY := nY
                                nBkpnZ := nZ
                                Exit
                            EndIf
                        Next nZ
                        If lOtherTGY
                            Exit
                        EndIf
                    Next nY
                EndIf
                If lFoundTGY .OR. !lOtherTGY
                    aRow[CALEND_POS_TIPO_DIA] := NextDayType(aCalendAux[nPosAux][CALEND_POS_DATA_APO],;
                                                            aCalendAux[nPosAux][CALEND_POS_TURNO],;
                                                            @cPOS_SEQ,;
                                                            aRow[CALEND_POS_DATA_APO] - aCalendAux[nPosAux][CALEND_POS_DATA_APO],;
                                                            cFilProc)
                Else
                    aRow[CALEND_POS_TURNO] := aAgenda[nBkpnY][2][nBkpnZ][AGENDA_TURNO]
                    cPOS_SEQ := aAgenda[nBkpnY][2][nBkpnZ][AGENDA_SEQUENCIA]
                    If aRow[CALEND_POS_DATA_APO] > aAgenda[nBkpnY][2][nBkpnZ][AGENDA_DATA_APONT]
                        aRow[CALEND_POS_TIPO_DIA] := NextDayType(aAgenda[nBkpnY][2][nBkpnZ][AGENDA_DATA_APONT],;
                                                                aAgenda[nBkpnY][2][nBkpnZ][AGENDA_TURNO],;
                                                                @cPOS_SEQ,;
                                                                aRow[CALEND_POS_DATA_APO]-aAgenda[nBkpnY][2][nBkpnZ][AGENDA_DATA_APONT],;
                                                                cFilProc)
                    Else
                        aRow[CALEND_POS_TIPO_DIA] := PreviousDay(aAgenda[nBkpnY][2][nBkpnZ][AGENDA_DATA_APONT],;
                                                                aAgenda[nBkpnY][2][nBkpnZ][AGENDA_TURNO],;
                                                                @cPOS_SEQ,;
                                                                aRow[CALEND_POS_DATA_APO]-aAgenda[nBkpnY][2][nBkpnZ][AGENDA_DATA_APONT],;
                                                                cFilProc)
                    EndIf
                EndIf
            Else
                aRow[CALEND_POS_TIPO_DIA] := NextDayType(aCalendAux[nPosAux][CALEND_POS_DATA_APO],;
                                                        aCalendAux[nPosAux][CALEND_POS_TURNO],;
                                                        @cPOS_SEQ,;
                                                        aRow[CALEND_POS_DATA_APO] - aCalendAux[nPosAux][CALEND_POS_DATA_APO],;
                                                        cFilProc)
            EndIf
        Else
            If aRow[CALEND_POS_DATA_APO] > aAgenda[Len(aAgenda)][1]
                aRow[CALEND_POS_TIPO_DIA] := NextDayType(aCalendAux[nPosAux][CALEND_POS_DATA_APO],;
                                                        aCalendAux[nPosAux][CALEND_POS_TURNO],;
                                                        @cPOS_SEQ,;
                                                        aRow[CALEND_POS_DATA_APO] - aCalendAux[nPosAux][CALEND_POS_DATA_APO],;
                                                        cFilProc)
            Else
                aRow[CALEND_POS_TIPO_DIA] := 'N'
            EndIf
        EndIf
        aRow[CALEND_POS_SEQ_TURNO] := cPOS_SEQ
    Else
        aRow[CALEND_POS_TIPO_DIA] := 'N'
        If lDayType .AND. !EMPTY(aAgenda)
            AADD(aDiasNProc, aRow)
        EndIf
    EndIf
EndIf
Return aRow
//------------------------------------------------------------------------------
/*/{Protheus.doc} NextDayType

@description Retorna o PJ_DIA de um determinado dia calculado apartir dos parâmetros

@param dDtBase, date, dia que será usado como base para o calculo
@param cTurno, string, código da tabela de horário utilizado como base
@param cSeqBase, string, código da semana da tabela de horário utilizado como base
@param nDays, int, valor positivo de quantos dias a função deve rodar para frente

Exemplo de uso:
    -> Igual PreviousDay, porém "rodando para frente"

@return cRet, string, Tipo do dia.

@author	boiani
@since	23/07/2020
/*/
//------------------------------------------------------------------------------
Static Function NextDayType(dDtBase, cTurno, cSeqBase, nDays, cFilProc)
Local cRet := 'N'
Local nAuxDia
Local aSeqTno := {}
Local cQry := GetNextAlias()
Local cFilBkp := cFilAnt
Default cFilProc := cFilAnt

If !EMPTY(dDtBase) .AND. !EMPTY(cTurno) .AND. !EMPTY(cSeqBase) .AND. nDays > 0
    If LEN(AllTrim(cFilProc)) == LEN(Alltrim(cFilAnt))
        cFilAnt := cFilProc
    EndIf
    nAuxDia := DOW(dDtBase)

    BeginSQL Alias cQry
        SELECT DISTINCT PJ_SEMANA 
            FROM %Table:SPJ% SPJ
            WHERE SPJ.PJ_FILIAL = %xFilial:SPJ%
            AND SPJ.%NotDel%
            AND SPJ.PJ_TURNO = %Exp:cTurno%
    EndSQL

    While (cQry)->(!Eof())
        AADD(aSeqTno, (cQry)->(PJ_SEMANA))
        (cQry)->(DbSkip())
    End
    (cQry)->(DbCloseArea())
    If !EMPTY(aSeqTno)
        While nDays > 0
            If nAuxDia + 1 == 2
                If LEN(aSeqTno) == ASCAN(aSeqTno, cSeqBase)
                    cSeqBase := aSeqTno[1]
                Else
                    cSeqBase := aSeqTno[(ASCAN(aSeqTno, cSeqBase) + 1)]
                EndIF
                nAuxDia++
            ElseIf nAuxDia + 1 == 8
                nAuxDia := 1
            Else
                nAuxDia++
            EndIf
            nDays--
        End
        cRet := POSICIONE("SPJ",1,xFilial("SPJ") + cTurno + cSeqBase + cValToChar(nAuxDia), "PJ_TPDIA")
    EndIf
EndIf
cFilAnt := cFilBkp
Return cRet

/*/{Protheus.doc} GetRowByAg
Recupera 
@since 08/07/2014
@version 1.0
@param aBase, array, Array base para geração da linha de acordo com agenda
@param aAgenda, array, INformação da agenda do atendente
@param nInterv, numérico, Indica intervalo da marcação
@param lEntrada, Boolean,  Indica se será realizdo processamento de Entrada ou Saída
@param lCalcLim,  Boolean,  Indica se será realizado o calculo do limite de entrada ou saida
@param lIntra,  Boolean,  Indica se será realizado processamento considerando horário para configuração de intrajornada
@return aRow, Linha do aTabCalend de acordo com a agenda do atendente 
/*/
Static Function GetRowByAg(aBase, aAgenda, nInterv, lEntrada, lCalcLim, lIntra)

	Local nHrsTrab := 0
	Local aRow := aClone(aBase)
	Local nSerial := 0
	Local nHrIni := 0
	Local nHrFim := 0
	Local lFerEnt := .T.
	
	Default lIntra := .F.

	//Data e hora 
	If !lIntra
		If lEntrada
			aRow[CALEND_POS_DATA] := aAgenda[AGENDA_DATAINI]
			aRow[CALEND_POS_HORA] := aAgenda[AGENDA_HORAINI]
		Else
			aRow[CALEND_POS_DATA] := aAgenda[AGENDA_DATAFIM]
			aRow[CALEND_POS_HORA] := aAgenda[AGENDA_HORAFIM]	
		EndIf
	Else//Intrajornada
		If lEntrada
			aRow[CALEND_POS_DATA] := If(aAgenda[AGENDA_INTRA_INTVL2] >= aAgenda[AGENDA_HORAINI], aAgenda[AGENDA_DATAINI],aAgenda[AGENDA_DATAFIM] ) 
			aRow[CALEND_POS_HORA] := aAgenda[AGENDA_INTRA_INTVL2]//If (aAgenda[AGENDA_HORAINI]>12,15,10) //aAgenda[AGENDA_INTRA_INTVL2]
		Else
			aRow[CALEND_POS_DATA] := If(aAgenda[AGENDA_INTRA_INTVL1] >= aAgenda[AGENDA_HORAINI], aAgenda[AGENDA_DATAINI],aAgenda[AGENDA_DATAFIM] )
			aRow[CALEND_POS_HORA] := aAgenda[AGENDA_INTRA_INTVL1]//If (aAgenda[AGENDA_HORAFIM]>12,14,9)//aAgenda[AGENDA_INTRA_INTVL1]	
		EndIf
	EndIf
		
	//Horas Trabalhadas			
	If lEntrada
		
		If !lIntra
			nHrIni := aAgenda[AGENDA_HORAINI]
			nHrFim	:= If(aAgenda[AGENDA_INTRAJORNADA], aAgenda[AGENDA_INTRA_INTVL1],aAgenda[AGENDA_HORAFIM] )
		Else//Intrajornada
			nHrIni := aAgenda[AGENDA_INTRA_INTVL2]
			nHrFim	:= aAgenda[AGENDA_HORAFIM]
		EndIf
		
		nHrsTrab := PNMCTothr(nHrIni, nHrFim)
	EndIf
	
	aRow[CALEND_POS_HRS_INTER	] := 0
	If !lEntrada//Saida
		If !lIntra
			If 	(nInterv == 1 .AND. aAgenda[AGENDA_INTERVALO1]== "S") .OR.;
			 	(nInterv == 2 .AND. aAgenda[AGENDA_INTERVALO2]== "S") .OR.;
			 	(nInterv == 3 .AND. aAgenda[AGENDA_INTERVALO3]== "S")
			  
			  aRow[CALEND_POS_HRS_INTER	] 	:= aAgenda[AGENDA_HRS_INTER]//Intervalo das agendas
			EndIf	
		Else//Intrajornada
			aRow[CALEND_POS_HRS_INTER	] 	:= aAgenda[AGENDA_HRS_INTRA]
		EndIf
	EndIf	

	
	//Realiza tratamento do limite inferior e superior
	If lCalcLim .AND. !lIntra
		If lEntrada
			nSerial := __fDhToNS( aRow[CALEND_POS_DATA] , aRow[CALEND_POS_HORA] ) - __fDhToNS(NIL, aAgenda[AGENDA_LIM_INFERIOR])							
			aRow[CALEND_POS_LIM_MARCACAO] := {__fNsToDh( nSerial , "D" ), __fNsToDh( nSerial , "H" )}
		Else
			nSerial := __fDhToNS( aRow[CALEND_POS_DATA] , aRow[CALEND_POS_HORA] ) + __fDhToNS( NIL, aAgenda[AGENDA_LIM_SUPERIOR])							
			aRow[CALEND_POS_LIM_MARCACAO] := {__fNsToDh( nSerial , "D" ), __fNsToDh( nSerial , "H" )}	
		EndIf	
	Else
		aRow[CALEND_POS_LIM_MARCACAO] := {Ctod("//"),  0}	// 17 - Limite de Marcacao Inicial
	EndIf
			
	aRow[CALEND_POS_TIPO_MARC	] 	:= cValToChar(nInterv) + If(lEntrada, "E", "S")// 04 - Tipo Marc
	aRow[CALEND_POS_TIPO_DIA	] 	:= aAgenda[AGENDA_TIPODIA]// 06 - Tipo Dia
	aRow[CALEND_POS_HRS_TRABA	] 	:= nHrsTrab// 07 - Horas Trabalhada no Periodo
	aRow[CALEND_POS_SEQ_TURNO	] 	:= aAgenda[AGENDA_SEQUENCIA]// 08 - Sequˆncia de Turno
		
	aRow[CALEND_POS_EXCECAO		] 	:= "N"// 10 - Excecao ( E-Excecao, # E - nao e excecao )
	aRow[CALEND_POS_MOT_EXECAO	] 	:= ""// 11 - Motivo da Excecao
	aRow[CALEND_POS_TIPO_HE_NOR	] 	:= aAgenda[AGENDA_TIPO_HE_NOR]						// 12 - Tipo de hora extra normal
	aRow[CALEND_POS_TIPO_HE_NOT	] 	:= aAgenda[AGENDA_TIPO_HE_NOT	]				// 13 - Tipo de hora extra noturna
	aRow[CALEND_POS_TURNO		] 	:= aAgenda[AGENDA_TURNO]// 14 - Turno de Trabalho
	aRow[CALEND_POS_CC			] 	:= aAgenda[AGENDA_CC]// 15 - Centro de Custo do Periodo 
	aRow[CALEND_POS_PG_NONA_HORA] 	:= aAgenda[AGENDA_PG_NONA_HORA]					// 16 - Pagamento de Nona Hora																		
	aRow[CALEND_POS_COD_REFEICAO] 	:= aAgenda[AGENDA_COD_REFEICAO]// 18 - Codigo da Refeicao
	aRow[CALEND_POS_INI_H_NOT	] 	:= aAgenda[AGENDA_INI_H_NOT	]// 28 - Inicio da Hora Noturna
	aRow[CALEND_POS_FIM_H_NOT	] 	:= aAgenda[AGENDA_FIM_H_NOT	]// 29 - Final da Hora Noturna
	aRow[CALEND_POS_MIN_H_NOT	] 	:= aAgenda[AGENDA_MIN_H_NOT	]// 30 - Minutos da Hora Noturna
	aRow[CALEND_POS_APON_FERIAS	] 	:= If (aRow[CALEND_POS_TIP_AFAST	] == "F" .AND. aAgenda[AGENDA_APON_FERIAS] == "S", .T., .F.)// 32 - Se Aponta Quando Afastamento em Ferias
	aRow[CALEND_POS_TP_HE_NR_FER] 	:= If(aRow[CALEND_POS_APON_FERIAS], aAgenda[AGENDA_TP_HE_NR_FER], "")// 33 - Tipo de hora extra normal (Ferias)
	aRow[CALEND_POS_TP_HE_NT_FER] 	:= If(aRow[CALEND_POS_APON_FERIAS], aAgenda[AGENDA_TP_HE_NT_FER], "")// 34 - Tipo de hora extra noturna (Ferias)			
	aRow[CALEND_POS_HE_AUTO_FER ] 	:= aAgenda[AGENDA_HE_AUTO_FER ]// 37 - Se H.Extras são autorizadas para funcionario em ferias				
	aRow[CALEND_POS_INTSREP 	] 	:= aAgenda[AGENDA_INTSREP]
	
	//Verificação de tratamento de feriado da entrada ou saida considerando a intrajornada
	If lIntra
		lFerEnt := If(aRow[CALEND_POS_DATA] == aAgenda[AGENDA_DATAINI], .T., .F.)		
	Else
		lFerEnt := lEntrada
	EndIf
	
	If lFerEnt		
		aRow[CALEND_POS_FERIADO		] 	:= aAgenda[AGENDA_FERIADO] 		// 19 - Dia e Feriado
		aRow[CALEND_POS_TP_HE_FER_NR]	:= aAgenda[AGENDA_FERIADO_TPEXT]// 20 - Tipo de Hora Extra Feriado Normal
		aRow[CALEND_POS_TP_HE_FER_NT] 	:= aAgenda[AGENDA_FERIADO_TPEXTN]// 21 - Tipo de Hora Extra Feriado Noturna
		aRow[CALEND_POS_DESC_FERIADO] 	:= aAgenda[AGENDA_FERIADO_DESC]// 22 - Descricao do Feriado	
	Else
		aRow[CALEND_POS_FERIADO		] 	:= aAgenda[AGENDA_FERIADO_SAIDA] 		// 19 - Dia e Feriado
		aRow[CALEND_POS_TP_HE_FER_NR]	:= aAgenda[AGENDA_FERIADO_TPEXT_SAIDA]// 20 - Tipo de Hora Extra Feriado Normal
		aRow[CALEND_POS_TP_HE_FER_NT] 	:= aAgenda[AGENDA_FERIADO_TPEXTN_SAIDA]// 21 - Tipo de Hora Extra Feriado Noturna
		aRow[CALEND_POS_DESC_FERIADO] 	:= aAgenda[AGENDA_FERIADO_DESC_SAIDA]// 22 - Descricao do Feriado	
	EndIf
	
	
	
Return aRow


/*/{Protheus.doc} ProcEsc
Realiza processamento do aTabCalend de acordo com a configuração da escala definida no Gestão de Serviços
@since 08/07/2014
@version 1.0
@param cEscala, character, Código da Escala
@param cCalend, character, Código do calendário a ser considerado
@param aCalend, array, aTabCalend gerado pelo Ponto
@return aCalendRet, aTabCalend gerado de acordo com as configurações da escala
/*/
Static Function ProcEsc(cEscala, cCalend, aCalend)
	Local aExcecoes 	:= LoadExcec(cEscala)	
	Local aFeriados	:= {} 
	Local nI := 0
	Local nY := 0
	Local aAux := {}
	Local aRow := {}
	Local aCalendRet := {}
	Local nDif := 0
	Local nPos := 0	
	Local aExcecao := {}
	Local aSeqs := {}
	Local lTrocaSeq := .F.//Controle para troca da sequência
	Local nSeqNew := 0
	Local cSeq := "0"
	Local dDataIni := If(Len(aCalend) > 0, aCalend[1][CALEND_POS_DATA], STOD(""))
	Local dDataFim := If(Len(aCalend) > 0, aCalend[Len(aCalend)][CALEND_POS_DATA], STOD(""))
	Local cSeqIni := If(Len(aCalend) > 0, aCalend[1][CALEND_POS_SEQ_TURNO], "01")
	Local aInfoSeq := {}
	Local aRows := {}
	Local lRplFer := TDW->( ColumnPos('TDW_RPLFER')) > 0 .And. (Posicione("TDW",1,xFilial("TDW") + cEscala , "TDW_RPLFER") == "1")
	Local lTrbFol := TDY->( ColumnPos('TDY_TRBFOL')) > 0

	//Carrega Feriados de acordo com calendário
	If !Empty(cCalend)	
		aFeriados := LoadFeriad(cCalend, dDataIni, dDataFim)	
	EndIf	
	
	
	If Len(aCalend) > 0
					
		aSeqs := At580GtSeq(aCalend[1][CALEND_POS_TURNO])//recupera sequencias do turno
		
		//realiza primeiro tratamento
		aExcecao := GetRowExec(aCalend[1], aExcecoes, ,lRplFer)//Recupera exceção considerando item padrão do aCalend					
		
		For nI:=1	To Len(aCalend)
			
			aRow := {}

			If aCalend[nI][CALEND_POS_TIPO_MARC] == "1E"
				
				//Atualiza informações para indicar feriado
				If Len(aFeriados) > 0
					aCalend[nI] := TrataFer(aFeriados, aCalend[nI], aCalend[nI][CALEND_POS_DATA_APO])
				EndIf
				
				//sequencia que será considerada
				If nSeqNew > 0
					cSeq := GetNextSeq(aSeqs, aCalend[nI][CALEND_POS_SEQ_TURNO], nSeqNew)//Troca da sequência
				Else
					cSeq := aCalend[nI][CALEND_POS_SEQ_TURNO]
				EndIf
				
				//Recupera linha considerando a troca da sequencia
				If cSeq != aCalend[nI][CALEND_POS_SEQ_TURNO]									
					aRow := getNewRow(	GetNextSeq(aSeqs, cSeqIni, nSeqNew),;															
								aCalend[nI][CALEND_POS_TURNO],;
								@aInfoSeq,;
								aCalend[nI],;
								dDataIni,;
								dDataFim)											
				Else
					aRow := aCalend[nI]				
				EndIf
				
				aExcecao := GetRowExec(aRow, aExcecoes, , lRplFer)//Recupera exceção considerando item padrão do aCalend
				
				If Len(aExcecao) > 0				
					If aExcecao[EXCECAO_ITEM_TROCASEQ] == "1"
					
						nSeqNew++
						
						//ao trocar sequencia refaz a verificação de substituilçao da linha do aTrabCalend
						cSeq := GetNextSeq(aSeqs, aCalend[nI][CALEND_POS_SEQ_TURNO], nSeqNew)//Troca da sequência
						
						If cSeq != aCalend[nI][CALEND_POS_SEQ_TURNO]									
							aRow := getNewRow(	GetNextSeq(aSeqs, cSeqIni, nSeqNew),;															
										aCalend[nI][CALEND_POS_TURNO],;
										@aInfoSeq,;
										aCalend[nI],;
										dDataIni,;
										dDataFim)											
						Else
							aRow := aCalend[nI]
						EndIf
												
						aExcecao := GetRowExec(aRow, aExcecoes, , lRplFer)//Recupera exceção considerando item padrão do aCalend	
														
					EndIf			
				EndIf
				
				If (Len(aExcecao) > 0 .And. aCalend[nI][CALEND_POS_TIPO_DIA] == "S") .Or. ( lTrbFol .And. Len(aExcecao) > 0 .And. aExcecao[EXCECAO_ITEM_TRABSDF] == "1" ) 
 
								
					aAux := TrataExce(aExcecao,aRow)
					
					//Verifica e recupera marcações necessárias para a exceção					
					aDif := GetDifMarc(aCalend, aRow[CALEND_POS_ORDEM], aExcecao )
					
					For nY:=1 To Len(aDif)
						aDif[nY] := TrataFer(aFeriados, aDif[nY], aDif[ny][CALEND_POS_DATA]) //Realiza tratamento de acordo com data efetiva de trabalho
						aAdd(aCalendRet, aDif[nY])
					Next nY
					
					aDif := {}				
										
				Else
										
					aRows := GetNewRows(aRow, aInfoSeq, GetNextSeq(aSeqs, cSeqIni, nSeqNew), dDataIni, dDataFim)
					For nY:=1 To Len(aRows)
						aRows[nY] := TrataFer(aFeriados, aRows[nY], aRows[nY][CALEND_POS_DATA]) //Realiza tratamento de acordo com data efetiva de trabalho
						aAdd(aCalendRet, aRows[nY])
					Next nY
			
				EndIf		
				
			EndIf
					
		Next nI
		
		//Ordena aCalendario pela ordem e tipo de marcação
		aSort( aCalendRet , NIL , NIL , { |x,y|  (x[CALEND_POS_ORDEM] + x[CALEND_POS_TIPO_MARC]) <  (y[CALEND_POS_ORDEM ] + y[ CALEND_POS_TIPO_MARC	])} )
		
	EndIf

Return aCalendRet


/*/{Protheus.doc} GetRowExec
Recupera Linha da exceção de acordo com as informações constantes em aRow
@since 08/07/2014
@version 1.0
@param aRow, array, Linha do aTabCalend
@param aExcecoes, array, Exceções da Escala 
@return aRowExcec, Linha da exceção a ser considerada
/*/
Static Function GetRowExec(aRow, aExcecoes, lOnlyFer, lRplFer)
	Local aRowExcec := {}
	Local nPos		:= 0
	Local lProxFer := _TrbPrxFer .AND. FindFunction("TecAtProc") .AND. !EMPTY(TecAtProc())

	Default lOnlyFer := .F.
	Default lRplFer := .F.
	//Verifica se é feriado e utiliza exceção de feriado	
	If Len(aRow) > 0	
	
		//Exceções por dia da semana
		If !lOnlyFer
			nPos := GetPosExec(aExcecoes[EXCECAO_DIAS], Dow(aRow[CALEND_POS_DATA_APO]), aRow[CALEND_POS_TURNO], aRow[CALEND_POS_SEQ_TURNO], .F. )	
			If nPos > 0
				aRowExcec := aExcecoes[EXCECAO_DIAS][nPos]
			EndIf
		EndIf
		
		If (aRow[CALEND_POS_FERIADO])
			nPos := GetPosExec(aExcecoes[EXCECAO_FERIADOS], Dow(aRow[CALEND_POS_DATA_APO]), aRow[CALEND_POS_TURNO], aRow[CALEND_POS_SEQ_TURNO], lRplFer )
			If nPos > 0
				If lProxFer
					If TecAtProc()[2] == "1" //Trabalha no próximo feriado
						aRowExcec := aExcecoes[EXCECAO_FERIADOS][nPos]
						TecAtProc({ TecAtProc()[1] , "2" })
					ElseIf TecAtProc()[2] == "2" //Não trabalha no prox. feriado
						aRowExcec := {}
						TecAtProc({ TecAtProc()[1] , "1" })
					Else
						aRowExcec := aExcecoes[EXCECAO_FERIADOS][nPos]
					EndIf
				Else
					aRowExcec := aExcecoes[EXCECAO_FERIADOS][nPos]
				EndIf
			EndIf
		EndIF			
	EndIf
	
Return aRowExcec

/*/{Protheus.doc} getNewRow
Recupera nova linha de acordo com a sequencia e turno informado
@since 08/07/2014
@version 1.0
@param cSeq, character, Sequencia
@param cTurno, character, turno
@param aInfoSeq, array, Array com cache das informações de sequencia já processadas
@param aRow, array, Linha do aTabCalend
@param dDataIni, data, Data Inicial 
@param dDataFim, data, Data Final
@return aRow, Linha do aTabCalend conforme informações enviadas por parametro
/*/ 
Static Function getNewRow(cSeq, cTurno, aInfoSeq, aRow, dDataIni, dDataFim)
	Local nPos := 0
	Local nPosTab := 0
	Local aAux := {}
	Local aTabPadrao := {}
	Local aTabCalend := {}
	Local aTurnos := {}
	Local aExcePer := {}
	Local lOK := .F.
	
	ChkInfoSeq(@ainfoSeq, cSeq, cTurno, dDataIni, dDataFim)//carrega info seq

	nPos := aScan(aInfoSeq, {|x| x[1]==cSeq})//busca posição do aInfoSeq
	
	If nPos > 0
		nPosTab := aScan(aInfoSeq[nPos][2], {|x| x[CALEND_POS_DATA_APO] == aRow[CALEND_POS_DATA_APO] .AND. x[CALEND_POS_TIPO_MARC] == aRow[CALEND_POS_TIPO_MARC]})
		If nPosTab > 0
			aAux := aClone(aInfoSeq[nPos][2][nPosTab])
			
			//Mantém indicação de Feriado
			aAux[CALEND_POS_FERIADO] := aRow[CALEND_POS_FERIADO]
			aAux[CALEND_POS_TP_HE_FER_NR] := aRow[CALEND_POS_TP_HE_FER_NR]//Atualiza indicação de Feriado
			aAux[CALEND_POS_TP_HE_FER_NT] := aRow[CALEND_POS_TP_HE_FER_NT]//Atualiza indicação de Feriado
			aAux[CALEND_POS_DESC_FERIADO] := aRow[CALEND_POS_DESC_FERIADO]//Atualiza indicação de Feriado
		Else
		
			If "E" $ aRow[CALEND_POS_TIPO_MARC]			
				nPosTab := aScan(aInfoSeq[nPos][2], {|x| x[CALEND_POS_DATA_APO] == aRow[CALEND_POS_DATA_APO] .AND. x[CALEND_POS_TIPO_MARC] == /*aRow[CALEND_POS_TIPO_MARC]*/"1E"})
			Else
				nPosTab := aScan(aInfoSeq[nPos][2], {|x| x[CALEND_POS_DATA_APO] == aRow[CALEND_POS_DATA_APO] .AND. x[CALEND_POS_TIPO_MARC] == /*aRow[CALEND_POS_TIPO_MARC]*/"1S"})
			EndIf
			aAux := aClone(aInfoSeq[nPos][2][nPosTab])  
			
			aAux[CALEND_POS_TIPO_MARC] := aRow[CALEND_POS_TIPO_MARC]
	
			//Mantém indicação de Feriado
			aAux[CALEND_POS_FERIADO] := aRow[CALEND_POS_FERIADO]
			aAux[CALEND_POS_TP_HE_FER_NR] := aRow[CALEND_POS_TP_HE_FER_NR]//Atualiza indicação de Feriado
			aAux[CALEND_POS_TP_HE_FER_NT] := aRow[CALEND_POS_TP_HE_FER_NT]//Atualiza indicação de Feriado
			aAux[CALEND_POS_DESC_FERIADO] := aRow[CALEND_POS_DESC_FERIADO]//Atualiza indicação de Feriado
		EndIf
	EndIf

	
Return aAux

Static Function ChkInfoSeq(aInfoSeq, cSeq, cTurno, dDataIni, dDataFim)
	Local nPos := 0	
	Local aTabPadrao := {}
	Local aTabCalend := {}
	Local aTurnos := {}
	Local aExcePer := {}
	Local lOk := .F.
	
	
	nPos := aScan(aInfoSeq, {|x| x[1]==cSeq})
	If nPos == 0		
		//Carrega CriaCalend da nova sequencia
		lOK := CalendCria(	dDataIni								,; //01 -> Data Inicial do Periodo
		 		  		dDataFim								,; //02 -> Data Final do Periodo
				  		cTurno									,; //03 -> Turno Para a Montagem do Calendario
				  		cSeq									,; //04 -> Sequencia Inicial para a Montagem Calendario
					  	@aTabPadrao								,; //05 -> Array Tabela de Horario Padrao
					  	@aTabCalend								,; //06 -> Array com o Calendario de Marcacoes
					  	xFilial("SR6")									,; //07 -> Filial para a Montagem da Tabela de Horario
					  	/*cMat*/NIL									,; //08 -> Matricula para a Montagem da Tabela de Horario
					  	/*cCc*/NIL										,; //09 -> Centro de Custo para a Montagem da Tabela
				  		@aTurnos								,; //10 -> Array com as Trocas de Turno
				  		@aExcePer								,; //11 -> Array com Todas as Excecoes do Periodo
				  		/*lExecQryTop*/NIL 							,; //12 -> Se executa Query para a Montagem da Tabela Padrao
				  		/*( ( lSncMaMe ) .and. !( lNewCalend ) )*/NIL	,; //13 -> Se executa a funcao se sincronismo do calendario
				  		/*lAcumulado*/ NIL								,; //14 -> Se o Calendario eh do periodo anterior
				  		/*aMarcacoes*/NIL								;  //15 -> Array de Marcacoes para tratamento de Turnos Opcionais
					  )
		If lOk
			aAdd(aInfoSeq, {cSeq, aTabCalend})					
		EndIf

	EndIf
return
	

/*/{Protheus.doc} TrataExce
Realiza tratamento considerando informações do aInfo
@since 08/07/2014
@version 1.0
@param aInfo, array, Informações a serem consideradas
@param aRow, array, Linha do aTabCalend
@return aRow,Linha do aTabCalend de acordo com novas configurações
/*/
Static Function TrataExce(aInfo, aRow)		
	Local lSaida := .F.	
	Local nSerial := Nil
	Local nUltMarc := 1//ultima marcação da exceção	
	Local nEntrada := 0
	Local nSaida := 0	
	
	//Não realiza tratamento quando for exceção do RH
	If aRow[CALEND_POS_EXCECAO] != "N"
		Return aRow
	EndIf
	
	If Len(aInfo) > 0	
		
		If !CheckExcec(aInfo, aRow )//Verifica se será considerada a linha para o registro da exceção
			Return Nil
		EndIf
	
		lSaida := aRow[CALEND_POS_TIPO_MARC] $ "1S|2S|3S|4S"//Indicador de horario de saída ou entrada
								
		aRow[CALEND_POS_DATA] := aRow[CALEND_POS_DATA_APO] + getQtdDias(aRow[CALEND_POS_TIPO_MARC], aInfo)//Ajusta data da marcação
		
		//Ajuste de Horario Entrada e Saída de acordo com a Exceção
		Do Case
			Case (aRow[CALEND_POS_TIPO_MARC] == "1E")
				aRow[CALEND_POS_HORA] := aInfo[EXCECAO_ITEM_ENTRA1]							
			Case (aRow[CALEND_POS_TIPO_MARC] == "1S")
				aRow[CALEND_POS_HORA] := aInfo[EXCECAO_ITEM_SAIDA1]		
			Case (aRow[CALEND_POS_TIPO_MARC] == "2E")
				aRow[CALEND_POS_HORA] := aInfo[EXCECAO_ITEM_ENTRA2]
			Case (aRow[CALEND_POS_TIPO_MARC] == "2S")
				aRow[CALEND_POS_HORA] := aInfo[EXCECAO_ITEM_SAIDA2]
			Case (aRow[CALEND_POS_TIPO_MARC] == "3E")
				aRow[CALEND_POS_HORA] := aInfo[EXCECAO_ITEM_ENTRA3]
			Case (aRow[CALEND_POS_TIPO_MARC] == "3S")
				aRow[CALEND_POS_HORA] := aInfo[EXCECAO_ITEM_SAIDA3]
			Case (aRow[CALEND_POS_TIPO_MARC] == "4E")
				aRow[CALEND_POS_HORA] := aInfo[EXCECAO_ITEM_ENTRA4]
			Case (aRow[CALEND_POS_TIPO_MARC] == "4S")
				aRow[CALEND_POS_HORA] := aInfo[EXCECAO_ITEM_SAIDA4]
		EndCase
		
		//Atualiza Horas Trabalhadas
		If !lSaida //É Entrada			
			If aRow[CALEND_POS_TIPO_MARC] == "1E"
				nEntrada := aInfo[EXCECAO_ITEM_ENTRA1]
				nSaida := aInfo[EXCECAO_ITEM_SAIDA1]
			ElseIf aRow[CALEND_POS_TIPO_MARC] == "2E"
				nEntrada := aInfo[EXCECAO_ITEM_ENTRA2]
				nSaida := aInfo[EXCECAO_ITEM_SAIDA2]
			ElseIf aRow[CALEND_POS_TIPO_MARC] == "3E"
				nEntrada := aInfo[EXCECAO_ITEM_ENTRA3]
				nSaida := aInfo[EXCECAO_ITEM_SAIDA3]
			ElseIf aRow[CALEND_POS_TIPO_MARC] == "4E"
				nEntrada := aInfo[EXCECAO_ITEM_ENTRA4]
				nSaida := aInfo[EXCECAO_ITEM_SAIDA4]
			EndIf
			
			If nEntrada > nSaida			
				aRow[CALEND_POS_HRS_TRABA] := (24 - nEntrada) + nSaida
			Else
				aRow[CALEND_POS_HRS_TRABA] := nSaida - nEntrada
			EndIf
			
			aRow[CALEND_POS_HRS_TRABA] := PNMCTothr ( nEntrada, nSaida )
			
		EndIf
		
		//Atualiza limite de marcação
		If Len(aRow[CALEND_POS_LIM_MARCACAO]) >= 2						
			
			//Verifica qual é a ultima Saìda da exceção		
			nUltMarc := If(aInfo[EXCECAO_ITEM_ENTRA2] + aInfo[EXCECAO_ITEM_SAIDA2] > 0, 2,nUltMarc)
			nUltMarc := If(aInfo[EXCECAO_ITEM_ENTRA3] + aInfo[EXCECAO_ITEM_SAIDA3] > 0, 3,nUltMarc)
			nUltMarc := If(aInfo[EXCECAO_ITEM_ENTRA4] + aInfo[EXCECAO_ITEM_SAIDA4] > 0, 4,nUltMarc)			

			//Só realiza a atualização do limite de marcação quando for primeira entrada ou ultima saida
			If 	aRow[CALEND_POS_TIPO_MARC] == "1E" .OR.;
			(nUltMarc == 1 .AND. aRow[CALEND_POS_TIPO_MARC] == "1S") .OR.;
			(nUltMarc == 2 .AND. aRow[CALEND_POS_TIPO_MARC] == "2S") .OR.;
			(nUltMarc == 3 .AND. aRow[CALEND_POS_TIPO_MARC] == "3S") .OR.;
			(nUltMarc == 4 .AND. aRow[CALEND_POS_TIPO_MARC] == "4S")
				
				If lSaida//Trata Saida				
					nSerial := __fDhToNS( aRow[CALEND_POS_DATA] , aRow[CALEND_POS_HORA] ) + __fDhToNS( NIL, aInfo[EXCECAO_ITEM_LIM_SUPERIOR])							
					aRow[CALEND_POS_LIM_MARCACAO][1] := __fNsToDh( nSerial , "D" )
					aRow[CALEND_POS_LIM_MARCACAO][2] := __fNsToDh( nSerial , "H" )							
				Else//Trata Entrada
					nSerial := __fDhToNS( aRow[CALEND_POS_DATA] , aRow[CALEND_POS_HORA] ) - __fDhToNS(NIL, aInfo[EXCECAO_ITEM_LIM_INFERIOR])							
					aRow[CALEND_POS_LIM_MARCACAO][1] := __fNsToDh( nSerial , "D" )
					aRow[CALEND_POS_LIM_MARCACAO][2] := __fNsToDh( nSerial , "H" )					
				EndIf	
			Else
				aRow[CALEND_POS_LIM_MARCACAO][1] := Ctod("//")
				aRow[CALEND_POS_LIM_MARCACAO][2] := 0							
			EndIf
			
		EndIf		
		
		//Tipo de Dia 1=Normal;2=Hora Extra
		If aInfo[EXCECAO_ITEM_TIPO] == "1"
			aRow[CALEND_POS_TIPO_DIA] := "S"
		ElseIf aInfo[EXCECAO_ITEM_TIPO] == "2"
			aRow[CALEND_POS_TIPO_DIA] := "E"
		EndIf
			
	EndIf
		
Return aRow


//Tratamento de Feriado 
Static Function TrataFer(aFer, aRow, dData)
	Local nPos := 0

	nPos := aScan(aFer, {|x|  ;
				( x[FERIADO_ITEM_FIXO] == "S" .AND. x[FERIADO_MES_DIA] ==  MesDia(dData) ) .OR.;
				( x[FERIADO_ITEM_DATA] == dData) })
				
	If nPos > 0

		//Ajusta informações referente ao Feriado
		aRow[CALEND_POS_FERIADO]			:= .T.	
		aRow[CALEND_POS_TP_HE_FER_NR]	:= aFer[nPos][FERIADO_ITEM_TP_HE]
		aRow[CALEND_POS_TP_HE_FER_NT] 	:= aFer[nPos][FERIADO_ITEM_TP_HE_NT]
		aRow[CALEND_POS_DESC_FERIADO] 	:= aFer[nPos][FERIADO_ITEM_DESC]
	Else 
		aRow[CALEND_POS_FERIADO]			:= .F.	
		aRow[CALEND_POS_TP_HE_FER_NR]	:= ""
		aRow[CALEND_POS_TP_HE_FER_NT] 	:= ""
		aRow[CALEND_POS_DESC_FERIADO] 	:= ""
	EndIf

Return aRow

/*/{Protheus.doc} GetPosExec
Retorna posição do array de Exceções de acordo com parametros
@since 26/05/2014
@version 1.0
@param aExcec, Array, Array com exceções
@param nDia, Number, Tipo de dia a ser coinsiderado para exceção
@param cTurno, String, Turno a ser considerado para exceção
@param cSeq, String, Sequencia do turno a ser considerado para exceção

@return Integer, Posição da exceção encontrada

/*/
Static Function GetPosExec(aExcec, nDia, cTurno, cSeq, lRplFer )
Local nRet := 0
If lRplFer
	nRet := aScan(aExcec, {|x| Val(x[EXCECAO_ITEM_DIASEM]) == nDia })
Else
	nRet := aScan(aExcec, {|x| Val(x[EXCECAO_ITEM_DIASEM]) == nDia .AND. x[EXCECAO_ITEM_TURNO] == cTurno .AND. x[EXCECAO_ITEM_SEQUENCIA] == cSeq})		
Endif
Return nRet

//Verifica se o registro da exceção é um registro valido para a linha do aTabCalend
Static Function CheckExcec(aRowExec, aRowCalend) 
	Local lRet := .T.
	
	//Valida se deverá ser considerada a linha do aTabCalend com a exceção  
	Do Case
		Case aRowCalend[CALEND_POS_TIPO_MARC] == "2E" .OR. aRowCalend[CALEND_POS_TIPO_MARC] == "2S"
			lRet :=  aRowExec[EXCECAO_ITEM_ENTRA2] + aRowExec[EXCECAO_ITEM_SAIDA2] > 0
		Case aRowCalend[CALEND_POS_TIPO_MARC] == "3E" .OR. aRowCalend[CALEND_POS_TIPO_MARC] == "3S"
			lRet :=  aRowExec[EXCECAO_ITEM_ENTRA3] + aRowExec[EXCECAO_ITEM_SAIDA3] > 0
		Case aRowCalend[CALEND_POS_TIPO_MARC] == "4E" .OR. aRowCalend[CALEND_POS_TIPO_MARC] == "4S"
			lRet :=  aRowExec[EXCECAO_ITEM_ENTRA4] + aRowExec[EXCECAO_ITEM_SAIDA4] > 0
	End Case

Return lRet

//Retorna diferenças de linhas em relação a exceção
Static Function GetDifMarc(aCalend, cOrdem, aInfo)
	Local aNew := {}
	Local nI := 0
	Local nCount := 0//Contator aTabCalend
	Local nCountE := 0//Contador Exceção
	Local cLastMarc := ""
	Local nPos := 0
	Local nPosSai := 0	
	
	//Verifica quantidade de linhas que o aCalend possui para determinada ordem
	nPos := aScan(aCalend, {|x| x[CALEND_POS_ORDEM] == cOrdem .AND. x[CALEND_POS_TIPO_MARC] == "1E"})	
	If nPos > 0
		For nI:=nPos To Len(aCalend)	
			If aCalend[nI][CALEND_POS_ORDEM] != cOrdem
				Exit//mudança na ordem			
			EndIf
			
			nPosSai := nI//Armazena ultima linha da ordem do array 			

						
		Next nI
	EndIf
		
	//Verifica quantidade de linhas necessárias para exceção, para cada intervalo considera 2 linhas (Entrada e Saída)
	If(aInfo[EXCECAO_ITEM_ENTRA1] + aInfo[EXCECAO_ITEM_SAIDA1] > 0,nCountE++,0)
	If(aInfo[EXCECAO_ITEM_ENTRA2] + aInfo[EXCECAO_ITEM_SAIDA2] > 0,nCountE++,0)
	If(aInfo[EXCECAO_ITEM_ENTRA3] + aInfo[EXCECAO_ITEM_SAIDA3] > 0,nCountE++,0)
	If(aInfo[EXCECAO_ITEM_ENTRA4] + aInfo[EXCECAO_ITEM_SAIDA4] > 0,nCountE++,0)
	
	For nI := 1 To nCountE
		
		If nPosSai > 0				
			aAux := TrataExce(aInfo, CpyRowACal(aCalend[nPos], cValTochar(nI)+"E"))//Nova Entrada	
			aAdd(aNew, aAux)	

			aAux := TrataExce(aInfo, CpyRowACal(aCalend[nPos], cValTochar(nI)+"S"))//Nova Saida
			aAdd(aNew, aAux)	
		EndIf
					
	Next nI 

Return aNew


//Retorna diferenças de linhas em relação a sequencia
Static Function GetNewRows(aRow, aInfoSeq, cSeq, dDataIni, dDataFim)
	Local aNew := {}
	Local nI := 0	
	Local nPos := 0	
	Local cOrdem := ""	
	Local dDataRef := aRow[CALEND_POS_DATA_APO]
	Local aCalendSeq := {}
	
	
	If aRow[CALEND_POS_FERIADO]	//Recupera linhas considerando folga do feriado			
		aAdd(aNew, getRowFolg( aRow, .T.))
		aAdd(aNew, getRowFolg( aRow, .F.))
	Else //Tratamento para dia comum
		ChkInfoSeq(aInfoSeq, cSeq, aRow[CALEND_POS_TURNO], dDataIni, dDataFim)
		nPos := aScan(aInfoSeq, {|x| x[1]==cSeq})//busca posição do aInfoSeq
		aCalendSeq := aInfoSeq[nPos][2]
		nPos := aScan(aCalendSeq, {|x| x[CALEND_POS_DATA_APO] == dDataRef .AND. x[CALEND_POS_TIPO_MARC] == "1E"})
		
		If nPos > 0
			
			cOrdem := aCalendSeq[nPos][CALEND_POS_ORDEM]
		
			For nI:=nPos To Len(aCalendSeq)	
				If aCalendSeq[nI][CALEND_POS_ORDEM] != cOrdem
					Exit//mudança na ordem			
				EndIf			
				
				aAdd(aNew, aClone(aCalendSeq[nI]))
			Next nI
						
		EndIf
	EndIf

Return aNew


Static Function CpyRowACal(aOrig, cTipo)
	Local aNew := aClone(aOrig)
	
	aNew[CALEND_POS_TIPO_MARC] := cTipo
	
Return aNew

//Verifica a quantidade de dias dos intervalos de marcações até a marcação desejada
Static Function GetQtdDias(cTipo, aExcecao)
	Local aAux := {}
	Local nI := 0
	Local nDias := 0
	
	//Estrutura para verificação
	aAdd(aAux, {"1E", aExcecao[EXCECAO_ITEM_ENTRA1]})
	aAdd(aAux, {"1S", aExcecao[EXCECAO_ITEM_SAIDA1]})
	aAdd(aAux, {"2E", aExcecao[EXCECAO_ITEM_ENTRA2]})
	aAdd(aAux, {"2S", aExcecao[EXCECAO_ITEM_SAIDA2]})
	aAdd(aAux, {"3E", aExcecao[EXCECAO_ITEM_ENTRA3]})
	aAdd(aAux, {"3S", aExcecao[EXCECAO_ITEM_SAIDA3]})
	aAdd(aAux, {"4E", aExcecao[EXCECAO_ITEM_ENTRA4]})
	aAdd(aAux, {"4S", aExcecao[EXCECAO_ITEM_SAIDA4]})
		
	If cTipo != "1E" .AND. Len(aExcecao) > 1
	
		For nI := 2 To Len(aAux)
		
			If aAux[nI-1][2] > aAux[nI][2]
				nDias++
			EndIf  
						
			If aAux[nI][1] == cTipo
				Exit
			EndIf
		
		Next nI
	EndIf
	
Return nDias

Static Function GetAgenda(cCodAtend, dDataIni, dDataFim)
Local aAgenda := {}
Local cAlsTrb := GetNextAlias()
Local cAlsTGY := GetNextAlias()
Local aAux := {}
Local nPos := 0
Local nX
Local nY
Local cTurno := ""
Local nPosAnt := 0
Local lMudouTurno := .F.
Local cCcSpace   := Space( GetSx3Cache( "RA_CC" , "X3_TAMANHO" ) )
Local nLimIntra := SuperGetMV("MV_TECINTR", .F., 6)
Local nTotHrs := 0
Local cHora := ""
Local cCampos := ""
Local cFilAbbTGY := ""
Local cCodTFF := ""
Local cMotRelac := ""
Local cFilAbrAbb := "%ABR.ABR_FILIAL = '" + xFilial("ABR") + "'%"
Local cFilTdvAbb := "%TDV.TDV_FILIAL = '" + xFilial("TDV") + "'%"
Local cFilSr6Tdv := "%SR6.R6_FILIAL = '"  + xFilial("SR6") + "'%"
Local cFilAbqAbb := "%ABQ.ABQ_FILIAL = '" + xFilial("ABQ") + "'%"
Local cFilTdwTff := "%TDW.TDW_FILIAL = '" + xFilial("TDW") + "'%"
Local cFilAbb := "%ABB.ABB_FILIAL = '" + xFilial("ABB") + "'%"
Local cComAA1 		:= FwModeAccess("AA1",1) +  FwModeAccess("AA1",2) + FwModeAccess("AA1",3)
Local cComSRA 		:= FwModeAccess("SRA",1) +  FwModeAccess("SRA",2) + FwModeAccess("SRA",3)
Local lMultFil := SuperGetMV("MV_GSMSFIL",,.F.) .AND. (LEN(STRTRAN( cComAA1  , "E" )) > LEN(STRTRAN(  cComSRA  , "E" )))
Local nRecABR := 0

dbSelectArea("ABN")
ABN->(dbSetOrder(1))

dbSelectArea("ABR")
ABR->(dbSetOrder(1))

cCampos := "%"
cCampos += If(_lIntra ,", TDW.TDW_INTRA", "")
cCampos += If(_lSum444,", TDV.TDV_FERSAI, TDV.TDV_FSTPEX, TDV.TDV_FSEXTN", "")
cCampos += "%"

If lMultFil
    cFilAbrAbb := "%" + FWJoinFilial("ABR" , "ABB" , "ABR", "ABB", .T.) + "%"
    cFilTdvAbb := "%" + FWJoinFilial("TDV" , "ABB" , "TDV", "ABB", .T.) + "%"
    cFilSr6Tdv := "%" + FWJoinFilial("TDV" , "SR6" , "TDV", "SR6", .T.) + "%"
    cFilAbqAbb := "%" + FWJoinFilial("ABQ" , "ABB" , "ABQ", "ABB", .T.) + "%"
    cFilTdwTff := "%" + FWJoinFilial("TFF" , "TDW" , "TFF", "TDW", .T.) + "%"
    cFilAbb := "%1=1%"
EndIf

BeginSQL Alias cAlsTrb
    SELECT 
        ABR.ABR_DTINIA, ABR.ABR_HRINIA, ABR.ABR_DTFIMA, ABR.ABR_HRFIMA, ABR.ABR_MOTIVO,
        ABB.ABB_DTINI, ABB.ABB_HRINI, ABB.ABB_DTFIM, ABB.ABB_HRFIM, ABB.ABB_MANUT, ABB.ABB_FILIAL, ABB.ABB_CODIGO,
        TDV.TDV_DTREF, TDV.TDV_TPDIA, TDV.TDV_TURNO, TDV.TDV_SEQTRN, TDV.TDV_FERIAD, TDV.TDV_FTPEXT, 
        TDV.TDV_FEXTN, TDV.TDV_FERIAD, TDV.TDV_HRMEN, TDV.TDV_HRMAI, TDV.TDV_FILIAL, TDV.TDV_TPEXT, ABQ.ABQ_CODTFF,
        TDV.TDV_TPEXTN, TDV.TDV_NONHOR, TDV.TDV_CODREF, TDV.TDV_INSREP, TDV.TDV_INTVL1, TDV.TDV_INTVL2, TDV.TDV_INTVL3,
        SR6.R6_INIHNOT, SR6.R6_FIMHNOT, SR6.R6_MINHNOT, SR6.R6_APODFER, SR6.R6_TPEXFER, SR6.R6_TPEXFEN, SR6.R6_AUTOHEF 
        %Exp:cCampos%
    
    FROM %Table:ABB% ABB
    
    INNER JOIN  %Table:AA1% AA1 ON
        AA1.AA1_FILIAL = %xFilial:AA1% AND
        AA1.AA1_CODTEC = ABB.ABB_CODTEC AND
        AA1.%NotDel%

    LEFT JOIN %Table:ABR% ABR ON
        %Exp:cFilAbrAbb% AND
        ABR.ABR_AGENDA = ABB.ABB_CODIGO AND
        ABR.%NotDel%
    
    LEFT JOIN %Table:TDV% TDV ON
        %Exp:cFilTdvAbb% AND
        TDV.TDV_CODABB = ABB.ABB_CODIGO AND
        TDV.TDV_DTREF >= %Exp:dDataIni% AND
        TDV.TDV_DTREF <= %Exp:dDataFim% AND
        TDV.%NotDel%	
    
    INNER JOIN %Table:SR6% SR6 ON
        %Exp:cFilSr6Tdv% AND
        SR6.R6_TURNO = TDV.TDV_TURNO AND
        SR6.%NotDel%
        
    INNER JOIN %Table:ABQ% ABQ ON
        %Exp:cFilAbqAbb% AND
        ABQ.ABQ_CONTRT || ABQ.ABQ_ITEM || ABQ.ABQ_ORIGEM = ABB.ABB_IDCFAL AND
        ABQ.%NotDel%
    
    INNER JOIN %Table:TFF% TFF ON
        TFF.TFF_FILIAL = ABQ.ABQ_FILTFF AND
        TFF.TFF_COD = ABQ.ABQ_CODTFF AND
        TFF.%NotDel%	
        
    LEFT JOIN %Table:TDW% TDW ON
        %Exp:cFilTdwTff% AND
        TDW.TDW_COD = TFF.TFF_ESCALA AND
        TDW.%NotDel%
            
    WHERE 
        %Exp:cFilAbb% AND
        TDV.TDV_DTREF >= %Exp:dDataIni% AND
        TDV.TDV_DTREF <= %Exp:dDataFim% AND
        ABB.ABB_CODTEC = %Exp:cCodAtend% AND
        ABB.%NotDel%

    ORDER BY ABB.ABB_DTINI, ABB.ABB_HRINI
    
EndSQL	


While (cAlsTrb)->(!EOF())
	nRecABR := 0
    //Verifica se considera o registro de agenda cancelada
    If !Empty((cAlsTrb)->ABR_MOTIVO)
        cMotRelac := GetMotivos( (cAlsTrb)->ABB_FILIAL, (cAlsTrb)->ABB_CODIGO )
        If "05" $ cMotRelac .OR.;   //Cancelamento
                "08" $ cMotRelac    //Realocação
            (cAlsTrb)->(dbSkip())
            Loop
        EndIf
        		
		If "04" $ cMotRelac .AND. "01" $ cMotRelac //H.E. + Falta
			If ABN->(dbSeek(xFilial("ABN", (cAlsTrb)->ABB_FILIAL)+(cAlsTrb)->ABR_MOTIVO))
				If ABN->ABN_TIPO == "04"
					(cAlsTrb)->(dbSkip())
					Loop
				EndIf
			EndIf
		EndIf
    EndIf
        
    aAux := Array(AGENDA_ELEMENTOS)
    
    //Caso agenda possua manutenção recupera horario original
    If (cAlsTrb)-> ABB_MANUT == "1"
        aAux[AGENDA_DATAINI] 	:= STOD((cAlsTrb)->ABR_DTINIA)
        aAux[AGENDA_HORAINI] 	:= Val(StrTran((cAlsTrb)->ABR_HRINIA, ":", "."))
        aAux[AGENDA_DATAFIM]		:= STOD((cAlsTrb)->ABR_DTFIMA)
        aAux[AGENDA_HORAFIM] 	:= Val(StrTran((cAlsTrb)->ABR_HRFIMA, ":", "."))
    ElseIf FindFunction("AT910AbbHE") .AND.;
            AT910AbbHE({cCodAtend, STOD((cAlsTrb)->ABB_DTINI) ,(cAlsTrb)->ABB_HRINI , STOD((cAlsTrb)->ABB_DTFIM) , (cAlsTrb)->ABB_HRFIM,;
            /*6*/,/*7*/,/*8*/,/*9*/,/*10*/,/*11*/,/*12*/,/*13*/,/*14*/,/*15*/, (cAlsTrb)->ABB_FILIAL}, @nRecABR ) .AND. nRecABR > 0
        ABR->(dbGoTo(nRecABR))
        aAux[AGENDA_DATAINI] 	:= ABR->ABR_DTINIA
        aAux[AGENDA_HORAINI] 	:= Val(StrTran(ABR->ABR_HRINIA, ":", "."))
        aAux[AGENDA_DATAFIM]	:= ABR->ABR_DTFIMA
        aAux[AGENDA_HORAFIM] 	:= Val(StrTran(ABR->ABR_HRFIMA, ":", "."))
    Else
        aAux[AGENDA_DATAINI] 	:= STOD((cAlsTrb)->ABB_DTINI)
        aAux[AGENDA_HORAINI] 	:= Val(StrTran((cAlsTrb)->ABB_HRINI, ":", "."))
        aAux[AGENDA_DATAFIM]		:= STOD((cAlsTrb)->ABB_DTFIM)
        aAux[AGENDA_HORAFIM] 	:= Val(StrTran((cAlsTrb)->ABB_HRFIM, ":", "."))		
    EndIf
    aAux[AGENDA_DATA_APONT] 	:= STOD((cAlsTrb)->TDV_DTREF)
    aAux[AGENDA_TIPODIA]		:= (cAlsTrb)->TDV_TPDIA//pegar do campo
    aAux[AGENDA_TURNO]		:= (cAlsTrb)->TDV_TURNO
    aAux[AGENDA_SEQUENCIA]	:= (cAlsTrb)->TDV_SEQTRN
    aAux[AGENDA_FILIAL_TDV] := (cAlsTrb)->TDV_FILIAL
    aAux[AGENDA_CC]			:= cCcSpace	
    If EMPTY(cTurno)
        cTurno := (cAlsTrb)->TDV_TURNO
    ElseIf cTurno != (cAlsTrb)->TDV_TURNO
        lMudouTurno := .T.
    EndIf
    aAux[AGENDA_FERIADO]		:= !Empty((cAlsTrb)->TDV_FERIAD)
    aAux[AGENDA_FERIADO_TPEXT]		:= (cAlsTrb)->TDV_FTPEXT
    aAux[AGENDA_FERIADO_TPEXTN]		:= (cAlsTrb)->TDV_FEXTN
    If TDV->(FieldPos("TDV_FERIADO")) > 0
        aAux[AGENDA_FERIADO_DESC]		:= (cAlsTrb)->TDV_FERIADO
    EndIf
    aAux[AGENDA_FERIADO_SAIDA]			:= If(_lSum444, !Empty((cAlsTrb)->TDV_FERSAI), .F.)
    aAux[AGENDA_FERIADO_TPEXT_SAIDA]	:= If(_lSum444, (cAlsTrb)->TDV_FSTPEX, "")
    aAux[AGENDA_FERIADO_TPEXTN_SAIDA]	:= If(_lSum444, (cAlsTrb)->TDV_FSEXTN, "")
    aAux[AGENDA_FERIADO_DESC_SAIDA]		:= If(_lSum444, (cAlsTrb)->TDV_FERSAI, "")		
    
    aAux[AGENDA_LIM_INFERIOR]		:= (cAlsTrb)->TDV_HRMEN
    aAux[AGENDA_LIM_SUPERIOR]		:= (cAlsTrb)->TDV_HRMAI
            
    aAux[AGENDA_TIPO_HE_NOR	] := (cAlsTrb)->TDV_TPEXT//aTabTno[ nPos , 23 ]																	// 12 - Tipo de hora extra normal
    aAux[AGENDA_TIPO_HE_NOT	] := (cAlsTrb)->TDV_TPEXTN//aTabTno[ nPos , 24 ]																	// 13 - Tipo de hora extra noturna
    aAux[AGENDA_PG_NONA_HORA] := (cAlsTrb)->TDV_NONHOR//aTabTno[ nPos , 29 ]																	// 16 - Pagamento de Nona Hora																		
    aAux[AGENDA_COD_REFEICAO] := (cAlsTrb)->TDV_CODREF	// 18 - Codigo da Refeicao
    aAux[AGENDA_INTSREP 	] := (cAlsTrb)->TDV_INSREP
    aAux[AGENDA_INTERVALO1	] := (cAlsTrb)->TDV_INTVL1//Intervalo 1 Saida
    aAux[AGENDA_INTERVALO2	] := (cAlsTrb)->TDV_INTVL2//Intervalo 2 Saida
    aAux[AGENDA_INTERVALO3 	] := (cAlsTrb)->TDV_INTVL3//Intervalo 3 Saida
                        
    aAux[AGENDA_INI_H_NOT	] := (cAlsTrb)->R6_INIHNOT//SR6//nIniHnot																				// 28 - Inicio da Hora Noturna
    aAux[AGENDA_FIM_H_NOT	] := (cAlsTrb)->R6_FIMHNOT//SR6//nFimHnot																				// 29 - Final da Hora Noturna
    aAux[AGENDA_MIN_H_NOT	] := (cAlsTrb)->R6_MINHNOT//sr6//nMinHnot																				// 30 - Minutos da Hora Noturna		
    aAux[AGENDA_APON_FERIAS	] := (cAlsTrb)->R6_APODFER//SR6//lAponFer																				// 32 - Se Aponta Quando Afastamento em Ferias
    aAux[AGENDA_TP_HE_NR_FER] := (cAlsTrb)->R6_TPEXFER//SR6//cTpExNorFer																			// 33 - Tipo de hora extra normal (Ferias)
    aAux[AGENDA_TP_HE_NT_FER] := (cAlsTrb)->R6_TPEXFEN//SR6//cTpExNotFer																			// 34 - Tipo de hora extra noturna (Ferias)					
    aAux[AGENDA_HE_AUTO_FER ] := If ((cAlsTrb)->R6_AUTOHEF == "2", .F., .T.)	// 37 - Se H.Extras são autorizadas para funcionario em ferias
    aAux[AGENDA_INTRAJORNADA ]	:= _lIntra  .AND. (cAlsTrb)->TDW_INTRA=="1"
    aAux[AGENDA_INTRA_INTVL1 ] 	:= 0
    aAux[AGENDA_INTRA_INTVL2 ] 	:= 0
    aAux[AGENDA_HRS_INTRA ]		:= 0
    If !EMPTY((cAlsTrb)->ABR_MOTIVO)
        aAux[AGENDA_CODIGO_ABN] := (cAlsTrb)->ABR_MOTIVO
    Else
        aAux[AGENDA_CODIGO_ABN] := ""
    EndIf
    //Intrajornada
    If aAux[AGENDA_INTRAJORNADA ]
        
        nTotHrs := SubtHoras(aAux[AGENDA_DATAINI],IntToHora(aAux[AGENDA_HORAINI]),aAux[AGENDA_DATAFIM],InttoHora(aAux[AGENDA_HORAFIM]),.T.)
        
        //Verifica total de horas trabalhadas e parametro de configuração
        If nTotHrs >= nLimIntra
        
            //Calcula intervalo 1
            dData := aAux[AGENDA_DATAINI]
            cHora := PNMCVHora(aAux[AGENDA_HORAINI])
            SomaDiaHor(@dData,@cHora,(nTotHrs/2) - 0.5)				
            aAux[AGENDA_INTRA_INTVL1 ] := Val(StrTran(cHora, ":", "."))
            
            //Calcula intervalo 2 
            dData := aAux[AGENDA_DATAINI]
            cHora := PNMCVHora(aAux[AGENDA_HORAINI])
            SomaDiaHor(@dData,@cHora,(nTotHrs/2) + 0.5)				
            aAux[AGENDA_INTRA_INTVL2 ] := Val(StrTran(cHora, ":", "."))
            
            If aAux[AGENDA_INTRA_INTVL1 ] > aAux[AGENDA_INTRA_INTVL2 ] 
                aAux[AGENDA_HRS_INTRA ]	:= (24 - aAux[AGENDA_INTRA_INTVL1 ] + aAux[AGENDA_INTRA_INTVL2 ])
            Else
                aAux[AGENDA_HRS_INTRA ]	:= aAux[AGENDA_INTRA_INTVL2 ] - aAux[AGENDA_INTRA_INTVL1 ]
            EndIf
        Else
            aAux[AGENDA_INTRAJORNADA ] := .F.//Horas de trabalho inferior ao parametro desabilita intrajornada da agenda
        EndIf

    EndIf
                    
    aAux[AGENDA_HRS_INTER]	:= 0//Horas intervalo entre agendas

    cFilAbbTGY := (cAlsTrb)->ABB_FILIAL
    cCodTFF := (cAlsTrb)->ABQ_CODTFF

    BeginSQL Alias cAlsTGY
		SELECT TGY.TGY_DTINI, TGY.TGY_DTFIM
		  FROM %Table:TGY% TGY
		WHERE TGY.TGY_FILIAL = %Exp:cFilAbbTGY%
		   AND TGY.%NotDel%
		   AND TGY.TGY_CODTFF = %Exp:cCodTFF%
           AND TGY.TGY_ATEND = %Exp:cCodAtend%
           AND TGY.TGY_DTFIM <= %Exp:DTOS(dDataFim)%
           AND TGY.TGY_DTINI >= %Exp:DTOS(dDataIni)%
        ORDER BY R_E_C_N_O_ DESC
	EndSQL
    If !(cAlsTGY)->(EOF())
        aAux[AGENDA_TGY_DTINI] := STOD((cAlsTGY)->TGY_DTINI)
        aAux[AGENDA_TGY_DTFIM] := STOD((cAlsTGY)->TGY_DTFIM)
    Else
        aAux[AGENDA_TGY_DTINI] := CtoD("")
        aAux[AGENDA_TGY_DTFIM] := CtoD("")
    EndIf
    (cAlsTGY)->(DbCloseArea())

    nPos := aScan(aAgenda, {|x| x[1] == aAux[AGENDA_DATA_APONT]})
    If nPos > 0//adiciona na estrutura	
        
        //Calcula horas de intervalo entre agendas	
        nPosAnt := Len(aAgenda[nPos][2])	
        If nPosAnt > 0
            If aAgenda[nPos][2][nPosAnt][AGENDA_HORAFIM] > aAux[AGENDA_HORAINI]
                aAgenda[nPos][2][nPosAnt][AGENDA_HRS_INTER] := (24 - aAgenda[nPos][2][nPosAnt][AGENDA_HORAFIM]) + aAux[AGENDA_HORAINI]
            Else
                aAgenda[nPos][2][nPosAnt][AGENDA_HRS_INTER] := aAux[AGENDA_HORAINI] - aAgenda[nPos][2][nPosAnt][AGENDA_HORAFIM]
            EndIf
        EndIf
        
        aAdd(aAgenda[nPos][2], ACLONE(aAux))
    Else//Inclui na Estrutura
        aAdd(aAgenda, {aAux[AGENDA_DATA_APONT], {}})
        aAdd(aAgenda[Len(aAgenda)][2], ACLONE(aAux))
    EndIf

    (cAlsTrb)->(DbSkip())
End
(cAlsTrb)->(DbCloseArea())

For nX := 1 To LEN(aAgenda)
    For nY := 1 To LEN(aAgenda[nX][2])
        aAgenda[nX][2][nY][AGENDA_USA_TGY] := lMudouTurno
    Next nY
Next nX

Return aAgenda


Static Function GetAtend(cFil, cMat)
	Local cCod 		:= ""
	Local cAliasTrb := GetNextAlias()
	Local cQuery	:= "% %"
	Local lAA1MSBL	:= AA1->( ColumnPos('AA1_MSBLQL')) > 0
	
	If lAA1MSBL
		cQuery := "%"
		cQuery += " AND AA1.AA1_MSBLQL <> '1' "
		cQuery += "%"
	EndIf
	BeginSQL Alias cAliasTrb
		SELECT AA1_CODTEC
		
		FROM %Table:AA1% AA1
		
		WHERE 
			AA1.AA1_FILIAL = %xFilial:AA1%  AND
			AA1.AA1_CDFUNC = %Exp:cMat% AND
			AA1.AA1_FUNFIL = %Exp:cFil% AND
			AA1.%NotDel%
			%Exp:cQuery%
	EndSQL
	
	If (cAliasTrb)->(!EOF())
		cCod := (cAliasTrb)->AA1_CODTEC
	EndIf
	
	(cAliasTrb)->(DbCloseArea())
	
Return cCod

Static Function GetNextSeq(aSeqs, cSeqAtu, nNextSeq)
	Local cSeq := cSeqAtu
	Local nPos := 0
	Local nCount := 0
	
	If Len(aSeqs) > 0
		nPos := aScan(aSeqs, {|x| x[2]==cSeqAtu})
		If nPos > 0
			nCount := nNextSeq+nPos
			While (nCount>Len(aSeqs))
				nCount -= Len(aSeqs)			
			End
			
			cSeq := aSeqs[nCount][2]
			
		EndIf
	EndIf	
Return cSeq


/*/{Protheus.doc} LoadExcec
Recupera informações das exceções da escala
@since 08/07/2014
@version 1.0
@param cEscala, character, Escala
@return aExec, Estrutura com as exceções da escala
/*/
Static Function LoadExcec(cEscala)
	Local aExec := Array(EXCECAO_ELEMENTOS)
	Local cSql := ""
	Local cAliasQry := ""
	Local aArea := GetArea()
	Local aAux := {}
	Local lTrbFol := TDY->( ColumnPos('TDY_TRBFOL')) > 0

	cSql += " SELECT TDX.TDX_TURNO "
	cSql += " ,TDX.TDX_SEQTUR "
	cSql += " ,TDY.TDY_DIASEM "
	cSql += " ,TDY.TDY_ENTRA1 "
	cSql += " ,TDY.TDY_SAIDA1 "
	cSql += " ,TDY.TDY_ENTRA2 "
	cSql += " ,TDY.TDY_SAIDA2 "
	cSql += " ,TDY.TDY_ENTRA3 "
	cSql += " ,TDY.TDY_SAIDA3 "
	cSql += " ,TDY.TDY_ENTRA4 "
	cSql += " ,TDY.TDY_SAIDA4 "
	cSql += " ,TDY.TDY_HREXT "
	cSql += " ,TDY.TDY_TROSEQ "
	cSql += " ,TDY.TDY_HORMEN "
	cSql += " ,TDY.TDY_HORMAI "
	cSql += " ,TDY.TDY_FERIAD "
	If lTrbFol
		cSql += " ,TDY.TDY_TRBFOL "
	Endif
	cSql += " FROM " + RetSqlName("TDY") + " TDY "
	cSql += " INNER JOIN " + RetSqlName("TDX") + " TDX "
	cSql += " ON TDY.TDY_CODTDX = TDX.TDX_COD "
	cSql += " AND TDX.TDX_FILIAL = '" + xFilial('TDX') + "' "
	cSql += " AND TDX.D_E_L_E_T_ = ' ' "
	cSql += " AND TDX.TDX_CODTDW = '" + cEscala + "' "
	cSql += " WHERE "
	cSql += " TDY.TDY_FILIAL = '" + xFilial('TDY') + "' "
	cSql += " AND TDY.D_E_L_E_T_ = ' ' "
	cSql := ChangeQuery(cSql)
	cAliasQry := GetNextAlias()
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cSql),cAliasQry, .F., .T.)
	If !(cAliasQry)->(EOF())
		aExec[EXCECAO_DIAS] := {}
		aExec[EXCECAO_FERIADOS] := {}
	EndIf
	While !(cAliasQry)->(EOF())

		aAux := Array(EXCECAO_ITEM_ELEMENTOS)
		aAux[EXCECAO_ITEM_TURNO]		:= (cAliasQry)->TDX_TURNO
		aAux[EXCECAO_ITEM_SEQUENCIA]	:= (cAliasQry)->TDX_SEQTUR
		aAux[EXCECAO_ITEM_DIASEM]		:= (cAliasQry)->TDY_DIASEM
		aAux[EXCECAO_ITEM_ENTRA1]		:= (cAliasQry)->TDY_ENTRA1
		aAux[EXCECAO_ITEM_SAIDA1]		:= (cAliasQry)->TDY_SAIDA1
		aAux[EXCECAO_ITEM_ENTRA2]		:= (cAliasQry)->TDY_ENTRA2
		aAux[EXCECAO_ITEM_SAIDA2]		:= (cAliasQry)->TDY_SAIDA2
		aAux[EXCECAO_ITEM_ENTRA3]		:= (cAliasQry)->TDY_ENTRA3
		aAux[EXCECAO_ITEM_SAIDA3]		:= (cAliasQry)->TDY_SAIDA3
		aAux[EXCECAO_ITEM_ENTRA4]		:= (cAliasQry)->TDY_ENTRA4
		aAux[EXCECAO_ITEM_SAIDA4]		:= (cAliasQry)->TDY_SAIDA4
		aAux[EXCECAO_ITEM_TIPO]			:= (cAliasQry)->TDY_HREXT
		aAux[EXCECAO_ITEM_TROCASEQ]		:= (cAliasQry)->TDY_TROSEQ
		aAux[EXCECAO_ITEM_LIM_INFERIOR] := (cAliasQry)->TDY_HORMEN
		aAux[EXCECAO_ITEM_LIM_SUPERIOR]	:= (cAliasQry)->TDY_HORMAI
		If lTrbFol .And. !Empty((cAliasQry)->TDY_TRBFOL) 
			aAux[EXCECAO_ITEM_TRABSDF]	:= (cAliasQry)->TDY_TRBFOL
		Else
			aAux[EXCECAO_ITEM_TRABSDF]	:= "2"
		Endif
		If (cAliasQry)->TDY_FERIAD == '2'
			aAdd(aExec[EXCECAO_DIAS], aAux)
		Else			
			aAdd(aExec[EXCECAO_FERIADOS], aAux)
		EndIf
		(cAliasQry)->(dbSkip())
	End
	(cAliasQry)->(dbCloseArea())
	RestArea(aArea)
Return aExec


/*/{Protheus.doc} LoadFeriad
Recupera informações de FEriados de acordo com calendário informado
@since 08/07/2014
@version 1.0
@param cCalend, character, Código do calendário
@param dDataIni, data, Data inicial
@param dDataFim, data, Data Final
@return aFer, Estrutura dos feriados do calendário

/*/
Static Function LoadFeriad(cCalend, dDataIni, dDataFim)
	
	Local aFer := {}
	Local aArea := GetArea()
	Local cSql := ""
	Local aAux := {}
	Local cAliasQry := ""

	cSql += " SELECT RR0.RR0_DATA, RR0.RR0_TPEXT, RR0.RR0_TPEXTN, RR0.RR0_FIXO, RR0.RR0_DESC, RR0.RR0_MESDIA "
	cSql += " FROM " + RetSqlName("RR0") + " RR0 "
	cSql += " INNER JOIN " + RetSqlName("AC0") + " AC0 "
	cSql += " ON RR0.RR0_CODCAL = AC0.AC0_CODIGO "
	cSql += " AND AC0.AC0_FILIAL = '" + xFilial('AC0') + "' "
	cSql += " AND AC0.D_E_L_E_T_ = ' ' "
	cSql += " WHERE AC0.AC0_CODIGO = '" + cCalend +"' "
	cSql += " AND RR0.RR0_FILIAL = '" + xFilial('RR0') + "' "
	cSql += " AND RR0.D_E_L_E_T_ = ' ' "
	cSql := ChangeQuery(cSql)
	cAliasQry := GetNextAlias()
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cSql),cAliasQry, .F., .T.)
	While !(cAliasQry)->(EOF())

		aAux := Array(FERIADO_ITEM_ELEMENTOS)
		aAux[FERIADO_ITEM_DATA] := sToD((cAliasQry)->RR0_DATA)
		aAux[FERIADO_ITEM_TP_HE] := (cAliasQry)->RR0_TPEXT
		aAux[FERIADO_ITEM_TP_HE_NT] := (cAliasQry)->RR0_TPEXTN
		aAux[FERIADO_ITEM_FIXO] := (cAliasQry)->RR0_FIXO
		aAux[FERIADO_ITEM_DESC] := (cAliasQry)->RR0_DESC
		aAux[FERIADO_MES_DIA] := (cAliasQry)->RR0_MESDIA
		aAdd(aFer, aAux)								

		(cAliasQry)->(dbSkip())
	End
	(cAliasQry)->(dbCloseArea())
	RestArea(aArea)
Return aFer


User Function PNMSEsc(cEscala)
	_cEscala := cEscala
Return

User Function PNMGEsc()
Return _cEscala

User Function PNMSCal(cCalend)
	_cCalend := cCalend
Return

User Function PNMGCal()
Return _cCalend

Static Function PNMCVHora(nHoras)
	Local nHora := Int(nHoras)//recupera somente a hora
	Local nMinuto := (nHoras - nHora)*100//recupera somento os minutos	
Return(StrZero(nHora, 2) + ":" + StrZero(nMinuto, 2))


/*/{Protheus.doc} LoadFeriad
Calculo de total de horas, passando horas em formato numérico, utilizando separador decimal.
@since 20/09/2018
@author diego.bezerra
@version 1.0
@param nEntrada, decimal, horário de entrada
@param nSaida, decimal, horário de saída
@return nTotalH, Total de horas trabalhadas em formato de hora

/*/
Static Function PNMCTothr ( nEntrada, nSaida )

Local 	nAuxEnt		:= 0
Local	nAuxSai		:= 0
Local 	nTotalH		:= 0
Default nEntrada 	:= 0
Default nSaida 		:= 0

//Trata horario final no proximo dia
If nEntrada > nSaida
	nTotalH := (24 - nEntrada) + nSaida
Else
	nTotalH := nSaida - nEntrada
EndIf

If nTotalH > 0 
	If nSaida < 10
		If len( cValToChar( nSaida ) ) == 1
			nAuxSai 	:= 0
		ElseIf len( cValtoChar ( nSaida ) ) == 3
			nAuxSai 	:= VAL( right( cValtoChar( nSaida ),1) )
		Else	
			nAuxSai 	:= VAL( right( cValtoChar( nSaida ),2) )
		EndIf
	Else
		If len( cValToChar( nSaida ) ) == 2 
			nAuxSai 	:= 0
		ElseIf len( cValtoChar ( nSaida ) ) == 4
			nAuxSai 	:= VAL( right( cValtoChar( nSaida ),1) )
		Else	
			nAuxSai 	:= VAL( right( cValtoChar( nSaida ),2) )
		EndIf	
	EndIf
	
	If nEntrada < 10
		If len( cValToChar( nEntrada ) ) == 1 
			nAuxEnt		:= 0
		ElseIf len( cValtoChar ( nEntrada ) ) == 3
			nAuxEnt		:=	VAL( right( cValtoChar( nEntrada ),1) )
		Else	
			nAuxEnt		:=	VAL( right( cValtoChar( nEntrada ),2) )
		EndIf
	Else
		If len( cValToChar( nEntrada ) ) == 2
			nAuxEnt		:= 0
		ElseIf len( cValtoChar ( nEntrada ) ) == 4
			nAuxEnt 	:=	VAL( right( cValtoChar( nEntrada ),1) )
		Else	
			nAuxEnt 	:=	VAL( right( cValtoChar( nEntrada ),2) )
		EndIf	
	EndIf
	
	If nAuxSai < nAuxEnt
		nTotalH := nTotalH - 0.4
	EndIf
EndIf

Return nTotalH
//------------------------------------------------------------------------------
/*/{Protheus.doc} AjustaDias

@description Ajusta o Turno, o Tipo do Dia e a Sequência de dias não trabalhados
                que por algum motivo não foram processados na rotina getRowFolg
                (dias contidos no array static aDiasNProc)

@param aCalend, array, Todos os dias processados

@return nil, sem retorno

@author	boiani
@since	23/07/2020
/*/
//------------------------------------------------------------------------------
Static Function AjustaDias(aCalend)
Local nX
Local nPosCalend := 0
Local nY
Local nPosAux := 0
Local cPOS_SEQ

For nX := 1 To LEN(aDiasNProc)
	nPosCalend := ASCAN(aCalend, {|s| s[1] == aDiasNProc[nX][1] .AND.;
									s[2] == aDiasNProc[nX][2] .AND.;
									s[3] == aDiasNProc[nX][3] .AND.;
									s[4] == aDiasNProc[nX][4] })
	If nPosCalend > 0
		For nY := 1 TO LEN(aCalend)
			If !EMPTY(aCalend[nY][CALEND_POS_HORA]) .AND. aCalend[nY][CALEND_POS_TIPO_DIA] == 'S' .AND. aCalend[nY][CALEND_POS_DATA] > aCalend[nPosCalend][CALEND_POS_DATA]
				nPosAux := nY
				Exit
			EndIf
		Next nY
		
		If nPosAux > 0 .AND. nPosAux > 0
			aCalend[nPosCalend][CALEND_POS_TURNO] := aCalend[nPosAux][CALEND_POS_TURNO]
			cPOS_SEQ := aCalend[nPosAux][CALEND_POS_SEQ_TURNO]
			aCalend[nPosCalend][CALEND_POS_TIPO_DIA] := PreviousDay(aCalend[nPosAux][CALEND_POS_DATA], aCalend[nPosAux][CALEND_POS_TURNO],@cPOS_SEQ, aCalend[nPosCalend][CALEND_POS_DATA] - aCalend[nPosAux][CALEND_POS_DATA])
			aCalend[nPosCalend][CALEND_POS_SEQ_TURNO] := cPOS_SEQ
		EndIf
	EndIf
Next nX

Return
//------------------------------------------------------------------------------
/*/{Protheus.doc} PreviousDay

@description Retorna o PJ_DIA de um determinado dia calculado apartir dos parâmetros

@param dDtBase, date, dia que será usado como base para o calculo
@param cTurno, string, código da tabela de horário utilizado como base
@param cSeqBase, string, código da semana da tabela de horário utilizado como base
@param nDays, int, valor negativo de quantos dias a função deve rodar para trás

Exemplo de uso:
    -> Em uma escala 12x36 (código "001"), é preciso descobrir qual seria o tipo do dia 01/01/2099 
    sem saber qual a sequência deste dia. Caso algum outro dia nesta tabela de horário
    seja conhecido - por exemplo, o dia 31/01/2099 é da sequência "02" (PJ_SEMANA), basta
    executar esta rotina de seguinte maneira:

    PreviousDay(;
        31/01/2099,;               //(data referente aos demais params)
        "001",.                    //(Código da tabela de horário 12x36)
        "02",;                     //(a data do primeiro param está na semana "02")
        01/01/2099 - 31/01/2099    //(número [negativo] de dias que a rotina deve "girar para trás" 
                                        para chegar na sequência desejada (PJ_SEMANA), e assim,
                                        no tipo do dia dessa sequência para este dia da semana )
    )

@return cRet, string, Tipo do dia.

@author	boiani
@since	23/07/2020
/*/
//------------------------------------------------------------------------------
Static Function PreviousDay(dDtBase, cTurno, cSeqBase, nDays, cFilProc)
Local cRet := 'N'
Local nAuxDia
Local aSeqTno := {}
Local cQry := GetNextAlias()
Local cFilBkp := cFilAnt
Default cFilProc := cFilAnt
If !EMPTY(dDtBase) .AND. !EMPTY(cTurno) .AND. !EMPTY(cSeqBase) .AND. nDays < 0

    If LEN(AllTrim(cFilProc)) == LEN(Alltrim(cFilAnt))
        cFilAnt := cFilProc
    EndIf

	nAuxDia := DOW(dDtBase)
	
	BeginSQL Alias cQry
		SELECT DISTINCT PJ_SEMANA 
		  FROM %Table:SPJ% SPJ
		 WHERE SPJ.PJ_FILIAL = %xFilial:SPJ%
		   AND SPJ.%NotDel%
		   AND SPJ.PJ_TURNO = %Exp:cTurno%
	EndSQL
	
	While (cQry)->(!Eof())
		AADD(aSeqTno, (cQry)->(PJ_SEMANA))
		(cQry)->(DbSkip())
	End
	(cQry)->(DbCloseArea())
	
    If !EMPTY(aSeqTno)
        While nDays < 0
            If nAuxDia - 1 == 1
                If 1 == ASCAN(aSeqTno, cSeqBase)
                    cSeqBase := aSeqTno[LEN(aSeqTno)]
                Else
                    cSeqBase := aSeqTno[(ASCAN(aSeqTno, cSeqBase) - 1)]
                EndIF
                nAuxDia--
            ElseIf nAuxDia - 1 == 0
                nAuxDia := 7
            Else
                nAuxDia--
            EndIf
            nDays++
        End
        cRet := POSICIONE("SPJ",1,xFilial("SPJ") + cTurno + cSeqBase + cValToChar(nAuxDia), "PJ_TPDIA")
    EndIf
EndIf

cFilAnt := cFilBkp

Return cRet

/*/{Protheus.doc} PNMLdExc(cEscala)
Recupera informações das exceções da escala
@since 27/02/2020
@version 1.0
@param cEscala, character, Escala
@return aExec, Estrutura com as exceções da escala
/*/
User Function PNMLdExc(cEscala)

Default cEscala := ""

Return LoadExcec(cEscala) 

/*/{Protheus.doc} PNMRwExc
Recupera Linha da exceção de acordo com as informações constantes em aRow
@since 08/07/2014
@version 1.0
@param aRow, array, Linha do aTabCalend
@param aExcecoes, array, Exceções da Escala 
@param lOnyFer - Logico somente os feriados
@return aRowExcec, Linha da exceção a ser considerada
/*/
User Function PNMRwExc(aRow, aExcecoes, lOnlyFer, lRplFer)
Default aRow := {}
Default aExcecoes := {}
Default lOnlyFer := .F.
Default lRplFer := .F.

Return GetRowExec(aRow, aExcecoes, lOnlyFer, lRplFer)

//---------------------------------------------------------------------
/*/{Protheus.doc} GetMotivos
@description Retorna todos os ABN_TIPO relacionados a um código de ABB
@return cRet, string, tipo das manutenções concatenadas
@author Mateus Boiani
@since  07/10/2020
/*/
//---------------------------------------------------------------------
Static Function GetMotivos(cFilABB, cCodABB)
Local aArea := GetArea()
Local cQry := GetNextAlias()
Local cRet := ""

dbSelectArea("ABN")
ABN->(dbSetOrder(1))

BeginSQL Alias cQry
    SELECT ABR.ABR_MOTIVO
        FROM %Table:ABR% ABR
        WHERE ABR.ABR_FILIAL = %Exp:cFilABB%
        AND ABR.%NotDel%
        AND ABR.ABR_AGENDA = %Exp:cCodABB%
EndSQL

While !((cQry)->(EOF()))
    If ABN->(dbSeek(xFilial("ABN", cFilABB)+(cQry)->ABR_MOTIVO ))
        cRet += (ABN->ABN_TIPO + "|")
    EndIf
    (cQry)->(DbSkip())
End

(cQry)->(DbCloseArea())
RestArea(aArea)

Return cRet
//---------------------------------------------------------------------
/*/{Protheus.doc} GetFilProc
@description Esta função serve para buscar em qual filial está a Folga do
    atendente. Como ainda não geramos registros para os dias
    de folga, esta rotina verifica as outras agendas do atendente para
    tentar aferir a filial da folga (verificando a filial do ultimo dia trabalhado
    ou do próximo dia trabalhado).
@return .T. --sempre retornar .T.
@author Mateus Boiani
@since  25/01/2025
/*/
//---------------------------------------------------------------------
Static Function GetFilProc(cFilProc, aRow, aAgenda)
Local nX
Local nY
Local cAux := ""
Local lTrocou := .F.
Local dPrimMaior := aRow[1]
Local dUltMenor := aRow[1]
Local nAux1 := 0
Local nAux2 := 0
For nX := 1 To LEN(aAgenda)
    If aAgenda[nX][1] < aRow[1]
        If dUltMenor == aRow[1]
            dUltMenor := aAgenda[nX][1]
        EndIf
        If aAgenda[nX][1] > dUltMenor
            dUltMenor := aAgenda[nX][1]
        EndIf
    EndIf
    If aAgenda[nX][1] > aRow[1]
        If dPrimMaior == aRow[1]
            dPrimMaior := aAgenda[nX][1]
        EndIf
        If aAgenda[nX][1] < dPrimMaior
            dPrimMaior := aAgenda[nX][1]
        EndIf
    EndIf
    For nY := 1 To LEN(aAgenda[nX][2])
        If EMPTY(cAux) .AND. !lTrocou
            cAux := aAgenda[nX][2][nY][AGENDA_FILIAL_TDV]
        ElseIf !(EMPTY(cAux)) .AND. cAux != aAgenda[nX][2][nY][AGENDA_FILIAL_TDV]
            lTrocou := .T.
        EndIf
    Next nY
    If lTrocou
        Exit
    EndIf
Next nX

nAux1 := ASCAN(aAgenda, {|a| a[1] == dUltMenor})
nAux2 := ASCAN(aAgenda, {|a| a[1] == dPrimMaior})

If lTrocou //Atendente trocou de filial
    If dPrimMaior == aRow[1] .AND. dUltMenor != aRow[1] .AND. nAux1 > 0
        cFilProc := aAgenda[nAux1][2][1][AGENDA_FILIAL_TDV]
    ElseIf dPrimMaior != aRow[1] .AND. dUltMenor == aRow[1] .AND. nAux2 > 0
        cFilProc := aAgenda[nAux2][2][1][AGENDA_FILIAL_TDV]
    ElseIf (aRow[1] - dUltMenor) > (dPrimMaior - aRow[1]) .AND. nAux2 > 0
        cFilProc := aAgenda[nAux2][2][1][AGENDA_FILIAL_TDV]
    ElseIf nAux1 > 0
        cFilProc := aAgenda[nAux1][2][1][AGENDA_FILIAL_TDV]
    ElseIf nAux2 > 0
        cFilProc := aAgenda[nAux2][2][1][AGENDA_FILIAL_TDV]
    EndIf
ElseIf !(EMPTY(cAux))
    cFilProc := cAux
EndIf

Return .T.