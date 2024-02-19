#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "REPORT.CH"

//--------------------------------------------------------------------
/*/{Protheus.doc} RTMSR37()
Executa a impressão do relatorio Financeiro da PagBem
@author  	Rodrigo Pirolo
@version 	P12
@build		
@since		30/03/2022
@return 	lRet
/*/
//--------------------------------------------------------------------

User Function RTMSR37()

    Local oReport   := Nil
    Local aArea     := GetArea()
    Local lTabAtu   := FindFunction("TMSIntgPB") .AND. DEG->(FieldPos("DEG_CONPDG")) > 0
    
    Private aLinhas := {}
    Private nLin    := 0

    If lTabAtu
        // Interface de impressao
        oReport := ReportDef()
        // Impressao
        oReport:PrintDialog()
    Else
        Help( "", 1, "Integração TMS Protheus X PagBem", , "O ambiente não está atualizado.", 1, 0, , , , , , { "Atualize o ambiente com o pacote de atualização referente a Integração TMS Protheus x PagBem." } ) // "O ambiente não está atualizado. Verificamos a falta dos campos DEG_TOKEN, DEG_HRTOKE, DEG_DTTOKE e DEG_EXPIRE." "Atualize o ambiente para que os novos campos da tabela Operadoras de Frota (DEG) sejam criados."
    EndIf

    RestArea( aArea )

Return

//--------------------------------------------------------------------
/*/{Protheus.doc} ReportDef()
Definições do Relatorio

@author  	Rodrigo Pirolo
@version 	P12
@build		
@since		30/03/2022
@return 	lRet
/*/
//--------------------------------------------------------------------

Static Function ReportDef()

    Local oReport   := NIL
    Local oDados    := NIL
    Local oValores  := NIL
    Local oBreak    := NIL
    Local nX        := 0
    Local aCell1    := {    { "FILVIAG",    "FILIAL/VIAGEM"     , TAMSX3("DTQ_FILORI")[1] + 10 + TAMSX3("DTQ_VIAGEM")[1] },;
                            { "CONTRPGB",   "CONTRATO PAGBEM"   , 10 },;
                            { "CIOT",       "CIOT"              , TAMSX3("DTR_CIOT")[1] },;
                            { "DATAMOVI",   "DATA MOVIMENTO"    , 10 },;
                            { "VLRMOVI",    "VLR MOVIMENTO"     , 16 },;
                            { "LOCALMOVI",  "LOCAL MOVIME"      , 15 },;
                            { "TIPOMOVI",   "TIPO MOVIMENTO"    , 15 },;
                            { "DATAEMI",    "DATA EMISSÃO"      , 10 },;
                            { "CGCMOTO",    "CPF/CNPJ MOTORISTA", 20 },;
                            { "CGCCONTRA",  "CPF/CNPJ CONTRAT." , 20 },;
                            { "IDFILIAL",   "IDENT FILIAL"      , TAMSX3("DTQ_FILORI")[1] },;
                            { "NOMEMOTO",   "NOME MOTORISTA"    , TAMSX3("A2_NOME")[1] },;
                            { "NOMECONTR",  "NOME CONTRATADO"   , TAMSX3("A2_NOME")[1] },;
                            { "NOMEFIL",    "NOME FILIAL"       , 20 },;
                            { "CNPJFIL",    "CNPJ FILIAL"       , 20 } }

    Local aCell2    :=  {   { "VLFREBRU",   "VLR FRETE BRUTO"   , 16 },;
                            { "VLRPESOS",   "VLR PESO SAÍDA"    , 16 },;
                            { "VLRPESOC",   "VLR PESO CHEGADA"  , 16 },;
                            { "VLRQUEBRA",  "VLR QUEBRA"        , 16 },;
                            { "VLRQUEBRA",  "VLR AVARIA"        , 16 },;
                            { "VLRDFRETE",  "VLR DIF FRETE"     , 16 },;
                            { "VLRINSS",    "VLR INSS"          , 16 },;
                            { "VLRPIS",     "VLR PIS"           , 16 },;
                            { "VLRCOFINS",  "VLR COFINS"        , 16 },;
                            { "VLRCSLL",    "VLR CSLL"          , 16 },;
                            { "VLRIR",      "VLR IR"            , 16 },;
                            { "VLRSESNAT",  "VLR SEST/SENAT"    , 16 },;
                            { "VLRSEGURO",  "VLR SEGURO"        , 16 },;
                            { "VLRADIAN",   "VLR ADIANTAMENTO"  , 16 },;
                            { "VLROUDEB",   "VLR OUTROS DEBITOS", 16 },;
                            { "VLRAJUSTE",  "VLR AJUSTES"       , 16 },;
                            { "TRANSACA",   "TRANSAÇÃO"         , 15 },;
                            { "TARICARD",   "TARIFA CARTÃO"     , 16 },;
                            { "TARIANTT",   "INC.TARIFA ANTT"   , 5 },;
                            { "TARIBANK",   "TARIFAS BANCARIAS" , 16 } }
    
    oReport := TReport():New( "RTMSR37", "Relatorio Financeiro PagBem", "RTMSR37", { | oReport | ReportPrint( oReport, oBreak ) }, "Realiza a busca de dados no Sistema PagBem para realizar a impressão pelo TMS Protheus." )
    oDados  := TRSection():New( oReport, "DADOS PAGBEM", /*uTable*/, /*aOrder*/, /*lLoadCells*/, /*lLoadOrder*/, /*uTotalText*/, /*lTotalInLine*/, .T./*lHeaderPage*/, .T./*lHeaderBreak*/, /*lPageBreak*/, /*lLineBreak*/, /*nLeftMargin*/, /*lLineStyle*/, /*nColSpace*/, /*lAutoSize*/, /*cCharSeparator*/, 3/*nLinesBefore*/, /*nCols*/, /*nClrBack*/, /*nClrFore*/, /*nPercentage*/)

    For nX := 1 To Len( aCell1 )
        TRCell():New( oDados, aCell1[nX, 1], /*cAlias*/, aCell1[nX, 2], /*Picture*/, aCell1[nX, 3]/*Tamanho*/, /*lPixel*/, /*{|| code-block de impressao }*/, /*cAlign*/, .T./*lLineBreak*/, /*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, /*lBold*/ )
    Next nX

    oValores:=  TRSection():New( oDados, "Valores PAGBEM", /*uTable*/, /*aOrder*/, /*lLoadCells*/, /*lLoadOrder*/, /*uTotalText*/, /*lTotalInLine*/, .T./*lHeaderPage*/, .T./*lHeaderBreak*/, /*lPageBreak*/, /*lLineBreak*/, /*nLeftMargin*/, /*lLineStyle*/, /*nColSpace*/, /*lAutoSize*/, /*cCharSeparator*/, 1/*nLinesBefore*/, /*nCols*/, /*nClrBack*/, /*nClrFore*/, /*nPercentage*/)

    For nX := 1 To Len( aCell2 )
        TRCell():New( oValores, aCell2[nX, 1], /*cAlias*/, aCell2[nX, 2], /*Picture*/, aCell2[nX, 3]/*Tamanho*/, /*lPixel*/, /*{|| code-block de impressao }*/, /*cAlign*/, .T./*lLineBreak*/, /*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, /*lBold*/ )
    Next nX

    oBreak := TRBreak():New( oDados, { || oDados:Cell("FILVIAG") }, "Por Viagem", .T. )

    oReport:SetLandScape(.T.) //-- Impressão em formato Paisagem

Return oReport

//--------------------------------------------------------------------
/*/{Protheus.doc} ReportDef()
Impressão do Relatorio

@author  	Rodrigo Pirolo
@version 	P12
@build		
@since		30/03/2022
@return 	lRet
/*/
//--------------------------------------------------------------------

Static Function ReportPrint( oReport, oBreak, oTotal1 )

    Local oPagBem   := NIL
    Local oDados    := oReport:Section(1)
    Local oValores  := oReport:Section(1):Section(1)
    Local cFilViag  := ""
    Local cViagem   := ""
    Local aMsgErr   := {}
    Local nX        := 0
    Local nLenLin   := 0
    Local nTamFil   := TAMSX3("DTQ_FILORI")[1] + 1
    Local nTamVgm   := TAMSX3("DTQ_VIAGEM")[1]

    oPagBem := TMSBCAPagBem():New()
    oPagBem:Auth()

    If oPagBem:IsTokenActive()[1]
	
        Pergunte( "RTMSR37", .F. )

        aLinhas := oPagBem:GetRelFin( MV_PAR01, MV_PAR02 )
        nLenLin := Len(aLinhas)
        
        If nLenLin > 0
			oReport:SetMeter( Len(aLinhas) )
			
			oDados:Init()
			oValores:Init()

			For nX := 1 To Len( aLinhas ) //-- Itens
				
				nLin    := nX
				// Realizo o substr para obter somente o codigo da viagem, posição contem Filial + Viagem
				cViagem := SubStr( aLinhas[nLin][1][2], nTamFil, nTamVgm )
				
				If cViagem >= AllTrim( MV_PAR03 ) .AND. cViagem <= AllTrim( MV_PAR04 )
					If Empty( cFilViag )
						cFilViag  := aLinhas[nLin][1][2]
					ElseIf cFilViag <> aLinhas[nLin][1][2]
						
						cFilViag  := aLinhas[nLin][1][2]
						
						If nLin > 1
							oBreak:Execute(.T.)
							oReport:FatLine()
						EndIf
						
					EndIf
					
					oDados:Cell("FILVIAG"   ):SetBlock( { || aLinhas[nLin][1][2]    } )
					oDados:Cell("CONTRPGB"  ):SetBlock( { || aLinhas[nLin][2][2]    } )
					oDados:Cell("CIOT"      ):SetBlock( { || aLinhas[nLin][3][2]    } )
					oDados:Cell("DATAMOVI"  ):SetBlock( { || aLinhas[nLin][20][2]   } )
					oDados:Cell("VLRMOVI"   ):SetBlock( { || aLinhas[nLin][21][2]   } )
					oDados:Cell("LOCALMOVI" ):SetBlock( { || aLinhas[nLin][22][2]   } )
					oDados:Cell("TIPOMOVI"  ):SetBlock( { || aLinhas[nLin][23][2]   } )
					oDados:Cell("DATAEMI"   ):SetBlock( { || aLinhas[nLin][24][2]   } )
					oDados:Cell("CGCMOTO"   ):SetBlock( { || aLinhas[nLin][25][2]   } )
					oDados:Cell("CGCCONTRA" ):SetBlock( { || aLinhas[nLin][26][2]   } )
					oDados:Cell("IDFILIAL"  ):SetBlock( { || aLinhas[nLin][27][2]   } )
					oDados:Cell("NOMEMOTO"  ):SetBlock( { || aLinhas[nLin][28][2]   } )
					oDados:Cell("NOMECONTR" ):SetBlock( { || aLinhas[nLin][29][2]   } )
					oDados:Cell("NOMEFIL"   ):SetBlock( { || aLinhas[nLin][30][2]   } )
					oDados:Cell("CNPJFIL"   ):SetBlock( { || aLinhas[nLin][31][2]   } )
					
					oValores:Cell("VLFREBRU"  ):SetBlock( { || aLinhas[nLin][4][2]  } )
					oValores:Cell("VLRPESOS"  ):SetBlock( { || aLinhas[nLin][5][2]  } )
					oValores:Cell("VLRPESOC"  ):SetBlock( { || aLinhas[nLin][6][2]  } )
					oValores:Cell("VLRQUEBRA" ):SetBlock( { || aLinhas[nLin][7][2]  } )
					oValores:Cell("VLRQUEBRA" ):SetBlock( { || aLinhas[nLin][8][2]  } )
					oValores:Cell("VLRDFRETE" ):SetBlock( { || aLinhas[nLin][9][2]  } )
					oValores:Cell("VLRINSS"   ):SetBlock( { || aLinhas[nLin][10][2] } )
					oValores:Cell("VLRPIS"    ):SetBlock( { || aLinhas[nLin][11][2] } )
					oValores:Cell("VLRCOFINS" ):SetBlock( { || aLinhas[nLin][12][2] } )
					oValores:Cell("VLRCSLL"   ):SetBlock( { || aLinhas[nLin][13][2] } )
					oValores:Cell("VLRIR"     ):SetBlock( { || aLinhas[nLin][14][2] } )
					oValores:Cell("VLRSESNAT" ):SetBlock( { || aLinhas[nLin][15][2] } )
					oValores:Cell("VLRSEGURO" ):SetBlock( { || aLinhas[nLin][16][2] } )
					oValores:Cell("VLRADIAN"  ):SetBlock( { || aLinhas[nLin][17][2] } )
					oValores:Cell("VLROUDEB"  ):SetBlock( { || aLinhas[nLin][18][2] } )
					oValores:Cell("VLRAJUSTE" ):SetBlock( { || aLinhas[nLin][19][2] } )
					oValores:Cell("TRANSACA"  ):SetBlock( { || aLinhas[nLin][32][2] } )
					oValores:Cell("TARICARD"  ):SetBlock( { || aLinhas[nLin][33][2] } )
					oValores:Cell("TARIANTT"  ):SetBlock( { || aLinhas[nLin][34][2] } )
					oValores:Cell("TARIBANK"  ):SetBlock( { || aLinhas[nLin][35][2] } )
					
					oDados:PrintLine()
					oValores:PrintLine()
				EndIf
				
				oReport:IncMeter()
				
			Next nX
            
            oDados:Finish()
            oValores:Finish()
		Else
		
			AAdd( aMsgErr, { "Ocorreu um erro na requisição da Integração SIGATMS x PagBem:" , '06',  } )
			AAdd( aMsgErr, { oPagBem:last_error, '06',  } )
			
			TmsMsgErr( aMsgErr )
		EndIf
    EndIf
    
    oReport:Finish()
    
    oPagBem:Destroy()

    FwFreeObj(oPagBem)

Return
