#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} RHTAFKEY
Programa para atualizar o TAFKEY de acordo com a TAFST2
@author  lidio.oliveira
@since   08/05/2023
@version 1.0
/*/
User Function ATUCODUNIC()

	Local nOpcA         := 0
	Local aButtons      := {}
	Local aSays         := {}
    Local lMiddleware  := SuperGetMv("MV_MID",, .F.)

	Private aPerg   := {}
	Private aTitle  := {}
	Private aLog    := {}
    Private aParam  := {}

    If lMiddleware
		Help( " ", 1, OemToAnsi("Aviso"),, "RDMAKE disponível apenas para integração com TAF", 1, 0 )
        Return
    EndIf

	aAdd(aSays,OemToAnsi( "Este programa tem como objetivo ajustar a matrícula eSocial (RA_CODUNIC) existente na "))
	aAdd(aSays,OemToAnsi( "tabela SRA - Funcionários com o valor do campo C9V_MATRIC existente no cadastro do "))
	aAdd(aSays,OemToAnsi( "trabalhador no TAF. "))
   	aAdd(aSays,OemToAnsi( "Clique em abrir para consultar a documentação desta rotina." ))

	aAdd(aButtons, { 14, .T., {|| ShellExecute("open","https://tdn.totvs.com/x/2uc1LQ","","",1) } } )
	aAdd(aButtons, { 5, .T., {|| fParam(@aPerg) } } )
	aAdd(aButtons, { 1, .T., {|o| nOpcA := 1,IF(gpconfOK(), FechaBatch(), nOpcA := 0 ) } } )
	aAdd(aButtons, { 2, .T., {|o| FechaBatch() } } )

	//Abre a tela de processamento
	FormBatch( "Atualização do campo RA_CODUNIC com base no campo C9V_MATRIC", aSays, aButtons )

	//Efetua o processamento de geração
	If nOpcA == 1
		Aadd( aTitle, OemToAnsi( "Funcionários que tiveram ajuste:" ) )
		Aadd( aTitle, OemToAnsi( "Funcionários que NÃO tiveram ajuste:" ) )
		Aadd( aLog, {} )
		Aadd( aLog, {} )
		ProcGpe( {|lEnd| fProc()},,,.T. )
		fMakeLog(aLog,aTitle,,,"ATUCODUNIC",OemToAnsi("Log de Ocorrências"),"M","P",,.F.)
	EndIf

Return


/*/{Protheus.doc} fParam
Cria tela com perguntes para possibilitar a execução de filtros
@author  lidio.oliveira
@since   08/05/2023
@version 1.0
/*/
Static Function fParam(aParam)

	Local aAdvSize      := {}
	Local aInfoAdvSize  := {}
	Local aObjCoords    := {}
	Local aObjSize      := {}
	Local cFilMat       := Space(TamSX3("RA_FILIAL")[1])
	Local cMatric       := Space(TamSX3("RA_MAT")[1])
	Local bSet15		:= { || nOpcA := 1, oDlg:End() }
	Local bSet24		:= { || nOpca := 2, oDlg:End() }
	Local lOk           := .T.
	Local nOpcA			:= 0
	Local oFil
	Local oMat

	Default aParam      := {}

    If len(aParam) > 0 
        cFilMat := aParam[1,1]
        cMatric := aParam[1,2]
    EndIf

	aAdvSize		:= MsAdvSize()
	aAdvSize[6]	:=	240	//Vertical
	aAdvSize[5]	:=  420	//horizontal
	aInfoAdvSize	:= { aAdvSize[1] , aAdvSize[2] , aAdvSize[3] , aAdvSize[4] , 5 , 5 }
	aAdd( aObjCoords , { 000 , 010 , .T. , .F. } )
	aAdd( aObjCoords , { 000 , 010 , .T. , .F. } )

	aObjSize	:= MsObjSize( aInfoAdvSize , aObjCoords )

	DEFINE FONT oFont  NAME "Arial" SIZE 0,-11 BOLD
	DEFINE MSDIALOG oDlg FROM aAdvSize[7], 0 TO aAdvSize[6], aAdvSize[5] TITLE OemToAnsi("Parâmetros") OF oMainWnd PIXEL

	@ aObjSize[1][1],aObjSize[1][2] 	SAY "Filial"    SIZE 050,10  FONT oFont OF oDlg PIXEL
	@ aObjSize[1][1],aObjSize[1][2]+80	MSGET oFil VAR cFilMat   SIZE 100,10 OF oDlg F3 "XM0" WHEN .T. PIXEL

	@ aObjSize[2][1],aObjSize[2][2] 	SAY "Matricula" SIZE 050,10  FONT oFont OF oDlg PIXEL
	@ aObjSize[2][1],aObjSize[2][2]+80	MSGET oMat VAR cMatric  SIZE 100,10 OF oDlg F3 "SRA" PIXEL

	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg, bSet15, bSet24) CENTERED

	If nOpcA == 2
		Return
	Else
		// Tratamento dos parâmetros preenchidos
		If Empty(cFilMat) .Or. Empty(cMatric)
			Aviso( OemtoAnsi("Parâmetros não preenchidos") , "O preenchimento dos perguntes filial e matrícula são obrigatórios",	{ "Ok" } )
			lOk := .F.
		EndIf

		If lOk
            aParam  := {}
			aAdd(aParam,{cFilMat, cMatric})
		EndIf
	EndIf

Return


/*/{Protheus.doc} GpConfOk
Confirma se há parâmetros preenchidos
@author  lidio.oliveira
@since   08/05/2023
@version 1.0
/*/
Static Function GpConfOk()

    Local cMensagem := "Confirma configuração dos parâmetros?"
    Local cTitulo   := "Atenção"

	If Len(aPerg) = 0
		Aviso( OemtoAnsi("Parâmetros em branco") , "Preencha os parâmetros para executar esta rotina",	{ "Ok" } )
		Return .F.
	EndIf

Return( MsgYesNo( OemToAnsi( cMensagem ) , OemToAnsi( cTitulo ) ) ) //"Atenção"


/*/{Protheus.doc} fProc
Função responsável pelo processamento da alteração
@author  lidio.oliveira
@since   08/05/2023
@version 1.0
/*/
Static Function fProc()

    Local cAliasQry	:= GetNextAlias()
	Local cJoinCateg:= ""
    Local cCodUnic  := ""
    Local cTCV      := fCatTrabEFD("TCV")
    Local cTSV      := fCatTrabEFD("TSV")
    Local cCatEFD   := ""
    Local nX        := 0
    Local nItem     := 0
    Local lTSV      := .F.
    Local aReg      := {}
    Local aItens    := {}
    
    DBSelectArea("SRA")
    SRA->( dbSetOrder(1) )

    //Se parâmetro preenchido garante que está posicionado no registro correto de processamento
    If Len(aPerg) > 0
        If SRA->( dbSeek(aPerg[1, 1] + aPerg[1, 2]) )         
            If SRA->RA_CATEFD $ cTCV
                cCatEFD := "%" + fSqlIn( StrTran(cTCV, "|" , ""), 3 ) + "%"
                cJoinCateg := "%C9V.C9V_MATRIC <> SRA.RA_CODUNIC%"
            ElseIf SRA->RA_CATEFD $ cTSV
               cCatEFD := "%" + fSqlIn( StrTran(cTSV, "|" , ""), 3 ) + "%" 
               lTSV    := .T.
               cJoinCateg := "%C9V.C9V_MATTSV <> SRA.RA_CODUNIC%"
            EndIf

            //Pesquisa pelo registro na C9V
            BeginSqL alias cAliasQry
                SELECT SRA.RA_FILIAL, SRA.RA_MAT, SRA.RA_CODUNIC, C9V.C9V_MATRIC, C9V.C9V_MATTSV, C9V.C9V_STATUS
                FROM %Table:SRA% SRA
                INNER JOIN %table:C9V% C9V
                ON 	%exp:cJoinCateg% AND
                C9V.C9V_CPF = SRA.RA_CIC AND
                C9V.C9V_ATIVO = '1' AND
                C9V.%notDel%
                WHERE SRA.RA_FILIAL = (%Exp:aPerg[1, 1]%)
                    AND SRA.RA_MAT = (%Exp:aPerg[1, 2]%)
                    AND SRA.RA_CATEFD IN (%Exp:cCatEFD%)
                    AND SRA.%NotDel%
                GROUP BY SRA.RA_FILIAL, SRA.RA_MAT, SRA.RA_CODUNIC, C9V.C9V_MATRIC, C9V.C9V_MATTSV, C9V.C9V_STATUS
            EndSql

            //Valida se é preciso ajustar o CODUNIC e confirma com o usuário a alteração
            If (cAliasQry)->(Eof())
                aAdd( aLog[2], "Registro não existente no TAF ou com matrícula eSocial idêntica. " )
            Else
                SRA->( dbSetOrder(1) )
                
                //Adiciona os registros encontrados num array
                While (cAliasQry)->(!Eof())
                    cCodUnic := If(lTSV, (cAliasQry)->C9V_MATTSV, (cAliasQry)->C9V_MATRIC)
                    If aScan( aReg, { |x| x[2] == cCodUnic } ) == 0 .And. !fVldCod(cCodUnic)
                        aAdd( aReg, { (cAliasQry)->RA_CODUNIC, cCodUnic, (cAliasQry)->RA_FILIAL,  (cAliasQry)->RA_MAT } )
                    EndIf
                    (cAliasQry)->(dbSkip())
                EndDo
                
                //Se houver registros no array atualiza a SRA
                nNumReg := Len(aReg)
                If nNumReg = 1 .And. (aReg[nNumReg,1] <> aReg[nNumReg,2])
                   If MsgYesNo( OemToAnsi( "Matrícula eSocial será alterada de " + alltrim(aReg[nNumReg,1]) + " para " + alltrim(aReg[nNumReg,2]) + ". Deseja prosseguir?" ) , OemToAnsi( "Atenção" ) )
                        RecLock("SRA",.F.) 
                            SRA->RA_CODUNIC := aReg[nNumReg,2]
                            aAdd( aLog[1], "Matrícula eSocial do fucionário na filial " + SRA->RA_FILIAL + " e matrícula " + SRA->RA_MAT  + " alterada de " + alltrim(aReg[nNumReg, 1]) + " para " + alltrim(aReg[nNumReg, 2]) )
                        SRA->(MsUnlock())
                   Else
                        aAdd( aLog[2], "Atualização do registro cancelada pelo usuário." )
                        Return
                   EndIf
                ElseIf nNumReg > 1
                    For nX := 1 to nNumReg
                        Aadd(aItens, aReg[nX, 2])
                    Next nX
                    //Executa função para seleção do C9V_MATRIC
                    nItem := fSelectC9V(aItens)
                    If nItem > 0
                        If MsgYesNo( OemToAnsi( "Matrícula eSocial será alterada de " + alltrim(aReg[nItem, 1]) + " para " + alltrim(aReg[nItem, 2]) + ". Deseja prosseguir?" ) , OemToAnsi( "Atenção" ) )
                            RecLock("SRA",.F.) 
                            SRA->RA_CODUNIC := aReg[nItem, 2]
                            aAdd( aLog[1], "Matrícula eSocial do fucionário " + SRA->RA_FILIAL + " " + SRA->RA_MAT  + " alterada de " + alltrim(aReg[nItem, 1]) + " para " + alltrim(aReg[nItem, 2]) )
                        SRA->(MsUnlock())
                        Else
                            aAdd( aLog[2], "Atualização do registro cancelada pelo usuário." )
                            Return
                        EndIf
                    Else
                        aAdd( aLog[2], "Atualização do registro cancelada pelo usuário." )
                        Return 
                    EndIf
                Else
                    aAdd( aLog[2], "Registro não existente no TAF ou com matrícula eSocial idêntica. " )
                EndIf
            EndIf
            (cAliasQry)->( dbCloseArea() )
        EndIf
        
    EndIf

Return

/*/{Protheus.doc} fSelectC9V
Função responsável pela tela de seleção da matrícula da C9V
@author  lidio.oliveira
@since   08/05/2023
@version 1.0
/*/
Static Function fSelectC9V(aItens)

    Local aAdvSize      := {}
	Local aInfoAdvSize  := {}
	Local aObjCoords    := {}
	Local aObjSize      := {}
    Local bProc			:= {||Iif( fTdOk1(nRadio), oDlg2:End(nRadio), 0)}
    Local bFecha		:= {||oDlg2:End(nRadio := 0)} 

	Default aItens      := {}

    Private nRadio      := 0
    Private oDlg2

    //------------------------------
    //| Criação das medidas da tela 
    //------------------------------
    aAdvSize		:= MsAdvSize( .F.,.F.,360)
    aInfoAdvSize	:= { aAdvSize[1] , aAdvSize[2] , aAdvSize[3] , aAdvSize[4] , 5 , 15 }
        
    aAdd( aObjCoords , { 000 , 000 , .T. , .T. } )
    aObjSize		:= MsObjSize( aInfoAdvSize , aObjCoords )

    //----------------------------------
    //| Criação da tela de Apresentação 
    //------------------------------------------------
    Define MsDialog oDlg2 FROM 0, 0 To 240, 380 Title "Matrículas eSocial existentes" Pixel

	//Cria o conteiner onde serão colocados os paineis
	oTela1	:= FWFormContainer():New( oDlg2 )
	cIdTel1	:= oTela1:CreateHorizontalBox( 30 )

    oTela1:Activate( oDlg2, .F. )

    //Cria os paineis onde serao colocados os browses
    oPanel1	:= oTela1:GeTPanel(cIdTel1)

    //-----------------
    //| Armazena os checkbox com todos as matrículas
    //-----------------------------------------------------
    @ 0, aObjSize[1,2] GROUP oGroup TO 90 ,aObjSize[1,4]*0.50 LABEL OemToAnsi("Selecione a matrícula eSocial correta:") OF oPanel1  PIXEL

    //Cria o RadioButton		
    oCheck1 := TRadMenu():New ( aObjSize[1,1]*0.750, aObjSize[1,2]+005, aItens, /*4*/,oPanel1,/*6*/,/*7*/,/*8*/,/*9*/,/*10*/,/*11*/,/*12*/,250,060,/*15*/,/*16*/,/*17*/,.T.)
    oCheck1:bSetGet := {|u|Iif (PCount()==0,nRadio,nRadio:=u)} 

	//-------------------
	//| Criação dos botões
	//| Realiza a criação das ações dos botões
	//-----------------------------------------------------
    oBtProc 	:= TButton():New( aObjSize[1,1]*6.000, aObjSize[1,2]+30, "&" + OemToAnsi("Processar"),NIL,bProc	, 060 , 012 , NIL , NIL , NIL , .T. )
	oBtFechar	:= TButton():New( aObjSize[1,1]*6.000, aObjSize[1,2]+110, "&" + OemToAnsi("Fechar"),NIL,bFecha , 040 , 012 , NIL , NIL , NIL , .T. )

    ACTIVATE MSDIALOG oDlg2 CENTERED

Return nRadio


/*/{Protheus.doc} fTdOk1
Valida se há eventos selecionados
@author  lidio.oliveira
@since   08/05/2023
@version 1.0
/*/
Static Function fTdOk1(nRadio)

    Local lRet  := .F.

    Default nRadio := 0

    If nRadio > 0
        lRet := .T.
    EndIf

Return lRet


/*/{Protheus.doc} fVldCod()
ValidA se o codUnic já existe na SRA
@type function
@author lidio.oliveira
@since 08/05/2023
@version 1.0
/*/
Static Function fVldCod(cCodUnic)

    Local aArea		:= GetArea()
    Local aAreaSRA  := SRA->(GetArea())
    Local lRet      := .F.

    DEFAULT cCodUnic	:= ""

    dbSelectArea( "SRA" )
    SRA->(dbSetOrder(24))
    If SRA->( Dbseek( cCodUnic ) )
        lRet      := .T.
    EndIf

    RestArea(aArea)
    RestArea(aAreaSRA)

Return lRet
