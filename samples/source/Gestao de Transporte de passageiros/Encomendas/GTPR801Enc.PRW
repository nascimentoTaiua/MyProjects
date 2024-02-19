#INCLUDE "TOTVS.ch"
#include "rwmake.ch"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"

Static nOpc := 0

/*/
 * {Protheus.doc} GTPR801Enc()
 * Recibo de Encomendas
 * type    Function
 * author  Eduardo Ferreira
 * since   02/10/2019
 * version 12.25
 * param   Não há
 * return  Não há
/*/
User Function GTPR801Enc()
Local oReport   := Nil
Local aParamBox := {}
Local aRet      := {} 
Local lRet      := .F.

If fwisincallstack('GTPA801')
    lRet := .T.
Else
    nOpc := Aviso( "CTE", "Recibo Entrada de Encomendas CTE", {"Posicionado", "Faixa", "Cancelar"},1) 

    If nOpc == 1  
        lRet := .T.
    ElseIf nOpc == 2
        aadd( aParamBox, { 1, "Nota de?" , PadR("", 9), "@!", ".T.", "", ".T.", 55, .F. } )
        aadd( aParamBox, { 1, "Nota até?", PadR("", 9), "@!", ".T.", "", ".T.", 55, .F. } )

        ParamBox( aParamBox, "Parametros para exibicao...", @aRet )

        MV_PAR01 := Iif(Len(aRet) > 0, Alltrim(aRet[1]), ' ')
        MV_PAR02 := Iif(Len(aRet) > 0, Alltrim(aRet[2]), ' ')
        
        lRet := .T.
    EndIf
EndIf 

If lRet
    oReport := ReportDef()
    oReport:PrintDialog()
EndIf

Return

/*/
 * {Protheus.doc} ReportDef()
 * Montagem do Relatorio 
 * type    Function
 * author  Eduardo Ferreira
 * since   02/10/2019
 * version 12.25
 * param   Não há
 * return  Não há
/*/
Static Function ReportDef()
Local cTitle := 'Recibo Entrada de Encomendas'
Local cHelp  := 'Recibo Entrada de Encomendas'

oReport := TReport():New('GTPR801Enc',cTitle,,{|oReport|ReportPrint(oReport)},cHelp,,,.T.,,.F.,,)
oReport:SetPortrait(.T.)
oReport:nFontBody := 12
oReport:SetTotalInLine(.F.)

Return oReport

Return 

/*/
 * {Protheus.doc} PrintDialog()
 * Montagem do Recibo
 * type    Function
 * author  Eduardo Ferreira
 * since   02/10/2019
 * version 12.25
 * param   oReport
 * return  Não há
/*/
Static Function ReportPrint(oReport)
Local oFnt22   := TFont():New( "Arial" ,,22,,.T.,,,,,.F. )
Local oFnt16   := TFont():New( "Arial" ,,16,,.T.,,,,,.F. )
Local oNFnt16  := TFont():New( "Arial" ,,16,,.F.,,,,,.F. )
Local oNFnt12  := TFont():New( "Arial" ,,12,,.F.,,,,,.F. )
Local aGI6     := GI6->(GetArea())
Local aAlias   := {}
Local aNumdoc  := {}
Local aSM0Emi  := {}
Local aSM0Rec  := {}
Local cEmpresa := FWFilialName(,cFilAnt)
Local cDescEmi := ''
Local cDescRec := ''
Local cData    := ''
Local nCont    := NIL 
Local nQuant   := Nil
Local nTop     := 1800
Local nTop2    := 1900
Local nLeft    := 0100 
Local nBottom  := 1900
Local nRight   := 2300
Local nVert    := 1850
Local nHori1   := 0110
Local nHori2   := 0290
Local nFimLin  := 1900

If nOpc == 1  .OR. fwisincallstack('GTPA801')
    aAlias   := RetItem(G99->G99_NUMDOC)

    cDescEmi := Posicione('GI6',1,xFilial('GI6')+Iif(Len(aAlias) > 0, aAlias[1, 12], ' '),'GI6_DESCRI')
    cDescRec := Posicione('GI6',1,xFilial('GI6')+Iif(Len(aAlias) > 0, aAlias[1, 13], ' '),'GI6_DESCRI')
    cData    := (Right(Iif(Len(aAlias) > 0, aAlias[1, 7], ' '), 2) + '/' + Left(Right(Iif(Len(aAlias) > 0, aAlias[1, 7], ' '), 4), 2) + '/' + Left(Iif(Len(aAlias) > 0, aAlias[1, 7], ' '), 4))
    aSM0Emi  := RetSM0(Iif(Len(aAlias) > 0, aAlias[1, 12], ' '))
    aSM0Rec  := RetSM0(Iif(Len(aAlias) > 0, aAlias[1, 13], ' '))

    If  !Empty(aAlias)
        oReport:Say(0300,0600,"RECIBO ENTRADA DE ENCOMENDAS", oFnt22)
        oReport:Say(600, 1900, "FILIAL: " + cEmpresa, oNFnt16)
        oReport:Say(600, 0100, "DADOS DO CLIENTE"   , oNFnt16)

        // Cabeçalho
        oReport:Say(0750 , 0110, "Remetente:", oFnt16)
        oReport:Say(0750 , 0400,  aAlias[1, 1] + ' - ' + aAlias[1, 2], oNFnt12)
        oReport:Line(0800, 0360, 0800, 2300)

        oReport:Say(0850 , 0110, "Destinatario:", oFnt16)
        oReport:Say(0850 , 0400, aAlias[1, 3] + ' - ' +  aAlias[1, 4], oNFnt12)
        oReport:Line(0900, 0380, 0900, 2300)

        oReport:Say(0950 , 0110, "Tomador:", oFnt16)
        oReport:Say(0950 , 0350, Iif(aAlias[1, 5] = '0', 'Remetente', 'Destinatario'), oNFnt12)
        oReport:Line(1000, 0310, 1000, 2300)
        
        oReport:Say(1050 , 0110, "Emissor:", oFnt16)
        oReport:Say(1050 , 0330, cDescEmi, oNFnt12)
        oReport:Line(1100, 0300, 1100, 0930)

        oReport:Say(1050 , 0950, "End:", oFnt16)
        oReport:Say(1050 , 1070, Iif(!Empty(aSM0Emi), aSM0Emi[1, 1], ' '), oNFnt12)
        oReport:Line(1100, 1050, 1100, 1680)

        oReport:Say(1050 , 1690, "CEP:", oFnt16)
        oReport:Say(1050 , 1810, Iif(!Empty(aSM0Emi), aSM0Emi[1, 2], ' '), oNFnt12)
        oReport:Line(1100, 1800, 1100, 2130)

        oReport:Say(1050 , 2140, "UF:", oFnt16)
        oReport:Say(1050 , 2230, Iif(!Empty(aSM0Emi), aSM0Emi[1, 3], ' '), oNFnt12)
        oReport:Line(1100, 2220, 1100, 2300)

        oReport:Say(1150 , 0110, "Recebedor:", oFnt16)
        oReport:Say(1150 , 0390, cDescRec, oNFnt12)
        oReport:Line(1200, 0360, 1200, 0930)

        oReport:Say(1150 , 0950, "End:", oFnt16)
        oReport:Say(1150 , 1070, Iif(!Empty(aSM0Rec), aSM0Rec[1, 1], ' '), oNFnt12)
        oReport:Line(1200, 1050, 1200, 1680)

        oReport:Say(1150 , 1690, "CEP:", oFnt16)
        oReport:Say(1150 , 1810, Iif(!Empty(aSM0Rec), aSM0Rec[1, 2], ' '), oNFnt12)
        oReport:Line(1200, 1800, 1200, 2130)

        oReport:Say(1150 , 2140, "UF:", oFnt16)
        oReport:Say(1150 , 2230, Iif(!Empty(aSM0Rec), aSM0Rec[1, 3], ' '), oNFnt12)
        oReport:Line(1200, 2220, 1200, 2300)
        
        oReport:Say(1250 , 0110, "Nota:", oFnt16)
        oReport:Say(1250 , 0270, aAlias[1, 6], oNFnt12)
        oReport:Line(1300, 0230, 1300, 2300)

        oReport:Say(1350 , 0110, "Data de Emissão:", oFnt16)
        oReport:Say(1350 , 0510, cData, oNFnt12)
        oReport:Line(1400, 0470, 1400, 1280)

        oReport:Say(1350 , 1300, "Hora de Emissão:", oFnt16)
        oReport:Say(1350 , 1690, aAlias[1, 8], oNFnt12)
        oReport:Line(1400, 1660, 1400, 2300)
    
        oReport:Say(1450 , 0110, "Valor:", oFnt16)
        oReport:Say(1450 , 0280, STRTRAN(aAlias[1, 9],'.',','), oNFnt12)
        oReport:Line(1500, 0240, 1500, 2300)

        // Corpo
        for nCont := 1 to Len(aAlias)
            oReport:Say(1750, 0110, "Item", oFnt16)
            oReport:Say(1750, 1200, "Descrição", oFnt16)

            oReport:Line(1700, 0100, 1700, 2300)
            oReport:Line(1800, 0100, 1800, 2300)
            oReport:Line(1800, 0100, 1700, 0100)
            oReport:Line(1800, 0240, 1700, 0240)
            oReport:Line(1800, 2300, 1700, 2300)

            oReport:Say(nVert , nHori1, aAlias[nCont, 10], oNFnt12)
            oReport:Say(nVert , nHori2, aAlias[nCont, 11], oNFnt12)
            oReport:Line(nTop2 , nLeft , nBottom, nRight)

            oReport:Line(nTop, nLeft , nFimLin, nLeft )
            oReport:Line(nTop, 0240  , nFimLin, 0240  )
            oReport:Line(nTop, nRight, nFimLin, nRight)

            nTop    += 100
            nTop2   += 100
            nBottom += 100
            nVert   += 100
            nFimLin += 100
        next
    EndIf
else
    aNumdoc := QuantDoc()

    for nQuant := 1 to Len(aNumdoc)
        
        aAlias   := RetItem(aNumdoc[nQuant, 1])
        
        If Len(aAlias) > 0
            cDescEmi := Posicione('GI6',1,xFilial('GI6')+Iif(Len(aAlias) > 0, aAlias[1, 12], ' '),'GI6_DESCRI')
            cDescRec := Posicione('GI6',1,xFilial('GI6')+Iif(Len(aAlias) > 0, aAlias[1, 13], ' '),'GI6_DESCRI')
            cData    := (Right(Iif(Len(aAlias) > 0, aAlias[1, 7], ' '), 2) + '/' + Left(Right(Iif(Len(aAlias) > 0, aAlias[1, 7], ' '), 4), 2) + '/' + Left(Iif(Len(aAlias) > 0, aAlias[1, 7], ' '), 4))
            aSM0Emi  := RetSM0(Iif(Len(aAlias) > 0, aAlias[1, 12], ' '))
            aSM0Rec  := RetSM0(Iif(Len(aAlias) > 0, aAlias[1, 13], ' '))

            oReport:StartPage()

            If  !Empty(aAlias)
                oReport:Say(0300,0600,"RECIBO ENTRADA DE ENCOMENDAS", oFnt22)
                oReport:Say(600, 1900, "FILIAL: " + cEmpresa, oNFnt16)
                oReport:Say(600, 0100, "DADOS DO CLIENTE"   , oNFnt16)

                // Cabeçalho
                oReport:Say(0750 , 0110, "Remetente:", oFnt16)
                oReport:Say(0750 , 0400,  aAlias[1, 1] + ' - ' + aAlias[1, 2], oNFnt12)
                oReport:Line(0800, 0360, 0800, 2300)

                oReport:Say(0850 , 0110, "Destinatario:", oFnt16)
                oReport:Say(0850 , 0400, aAlias[1, 3] + ' - ' +  aAlias[1, 4], oNFnt12)
                oReport:Line(0900, 0380, 0900, 2300)

                oReport:Say(0950 , 0110, "Tomador:", oFnt16)
                oReport:Say(0950 , 0350, Iif(aAlias[1, 5] = '0', 'Remetente', 'Destinatario'), oNFnt12)
                oReport:Line(1000, 0310, 1000, 2300)
                
                oReport:Say(1050 , 0110, "Emissor:", oFnt16)
                oReport:Say(1050 , 0330, cDescEmi, oNFnt12)
                oReport:Line(1100, 0300, 1100, 0930)

                oReport:Say(1050 , 0950, "End:", oFnt16)
                oReport:Say(1050 , 1070, Iif(!Empty(aSM0Emi), aSM0Emi[1, 1], ' '), oNFnt12)
                oReport:Line(1100, 1050, 1100, 1680)

                oReport:Say(1050 , 1690, "CEP:", oFnt16)
                oReport:Say(1050 , 1810, Iif(!Empty(aSM0Emi), aSM0Emi[1, 2], ' '), oNFnt12)
                oReport:Line(1100, 1800, 1100, 2130)

                oReport:Say(1050 , 2140, "UF:", oFnt16)
                oReport:Say(1050 , 2230, Iif(!Empty(aSM0Emi), aSM0Emi[1, 3], ' '), oNFnt12)
                oReport:Line(1100, 2220, 1100, 2300)

                oReport:Say(1150 , 0110, "Recebedor:", oFnt16)
                oReport:Say(1150 , 0390, cDescRec, oNFnt12)
                oReport:Line(1200, 0360, 1200, 0930)

                oReport:Say(1150 , 0950, "End:", oFnt16)
                oReport:Say(1150 , 1070, Iif(!Empty(aSM0Rec), aSM0Rec[1, 1], ' '), oNFnt12)
                oReport:Line(1200, 1050, 1200, 1680)

                oReport:Say(1150 , 1690, "CEP:", oFnt16)
                oReport:Say(1150 , 1810, Iif(!Empty(aSM0Rec), aSM0Rec[1, 2], ' '), oNFnt12)
                oReport:Line(1200, 1800, 1200, 2130)

                oReport:Say(1150 , 2140, "UF:", oFnt16)
                oReport:Say(1150 , 2230, Iif(!Empty(aSM0Rec), aSM0Rec[1, 3], ' '), oNFnt12)
                oReport:Line(1200, 2220, 1200, 2300)
                
                oReport:Say(1250 , 0110, "Nota:", oFnt16)
                oReport:Say(1250 , 0270, aAlias[1, 6], oNFnt12)
                oReport:Line(1300, 0230, 1300, 2300)

                oReport:Say(1350 , 0110, "Data de Emissão:", oFnt16)
                oReport:Say(1350 , 0510, cData, oNFnt12)
                oReport:Line(1400, 0470, 1400, 1280)

                oReport:Say(1350 , 1300, "Hora de Emissão:", oFnt16)
                oReport:Say(1350 , 1690, aAlias[1, 8], oNFnt12)
                oReport:Line(1400, 1660, 1400, 2300)
            
                oReport:Say(1450 , 0110, "Valor:", oFnt16)
                oReport:Say(1450 , 0280, STRTRAN(aAlias[1, 9],'.',','), oNFnt12)
                oReport:Line(1500, 0240, 1500, 2300)

                // Corpo
                for nCont := 1 to Len(aAlias)
                    oReport:Say(1750, 0110, "Item", oFnt16)
                    oReport:Say(1750, 1200, "Descrição", oFnt16)

                    oReport:Line(1700, 0100, 1700, 2300)
                    oReport:Line(1800, 0100, 1800, 2300)
                    oReport:Line(1800, 0100, 1700, 0100)
                    oReport:Line(1800, 0240, 1700, 0240)
                    oReport:Line(1800, 2300, 1700, 2300)

                    oReport:Say(nVert , nHori1, aAlias[nCont, 10], oNFnt12)
                    oReport:Say(nVert , nHori2, aAlias[nCont, 11], oNFnt12)
                    oReport:Line(nTop2 , nLeft , nBottom, nRight)

                    oReport:Line(nTop, nLeft , nFimLin, nLeft )
                    oReport:Line(nTop, 0240  , nFimLin, 0240  )
                    oReport:Line(nTop, nRight, nFimLin, nRight)

                    nTop    += 100
                    nTop2   += 100
                    nBottom += 100
                    nVert   += 100
                    nFimLin += 100
                next
            EndIf  

            oReport:EndPage()  

            nTop    := 1800
            nTop2   := 1900
            nBottom := 1900
            nVert   := 1850
            nFimLin := 1900
        EndIf
    next 
EndIf

RestArea(aGI6)

Return

/*/
 * {Protheus.doc} RetItem()
 * Montagem da query 
 * type    Function
 * author  Eduardo Ferreira
 * since   02/10/2019
 * version 12.25
 * param   Não há
 * return  aAlias
/*/
Static Function RetItem(cNota)
Local aAlias := {}
Local cAlias := GetNextAlias()

BeginSql Alias cAlias
    SELECT 
        G99.G99_DTEMIS,
        G99.G99_HREMIS,
        G99.G99_CLIREM,
        G99.G99_CLIDES,
        G99.G99_TOMADO,
        G99.G99_CODEMI,
        G99.G99_CODREC,
        G99.G99_NUMDOC,
        CAST(CAST(G99.G99_VALOR  AS DECIMAL(9,2)) AS VARCHAR(30)) AS VALOR,
        G9R.G9R_ITEM  ,
        G9R.G9R_DESCRI,
        SA1ORI.A1_NOME ORIGEM,
        SA1DES.A1_NOME DESTINO  
    FROM 
        %Table:G99% G99 
    JOIN %Table:G9R% G9R ON
        G99.G99_FILIAL = %xFilial:G99%  AND 
        G99.G99_CODIGO = G9R.G9R_CODIGO AND
        G9R.%NotDel% 
    JOIN %Table:SA1% SA1ORI ON 
        SA1ORI.A1_FILIAL = %xFilial:SA1% AND 
        SA1ORI.A1_COD = G99.G99_CLIREM   AND
        SA1ORI.%NotDel%
    JOIN %Table:SA1% SA1DES ON 
        SA1DES.A1_FILIAL = %xFilial:SA1% AND
        SA1DES.A1_COD = G99.G99_CLIDES   AND
        SA1DES.%NotDel%
    WHERE 
        G99.G99_FILIAL = %xFilial:G99%  AND
        G99.G99_NUMDOC = %Exp:cNota%    AND
        G99.G99_CODIGO = G9R.G9R_CODIGO AND
        G99.%NotDel%
EndSql

While !(cAlias)->(Eof())
    aAdd(aAlias,{(cAlias)->G99_CLIREM,;
                 (cAlias)->ORIGEM    ,;
                 (cAlias)->G99_CLIDES,;
                 (cAlias)->DESTINO   ,;
                 (cAlias)->G99_TOMADO,;
                 (cAlias)->G99_NUMDOC,;
                 (cAlias)->G99_DTEMIS,;
                 (cAlias)->G99_HREMIS,;
                 (cAlias)->VALOR     ,;
                 (cAlias)->G9R_ITEM  ,;
                 (cAlias)->G9R_DESCRI,;
                 (cAlias)->G99_CODEMI,;
                 (cAlias)->G99_CODREC})

    (cAlias)->(dbSkip())
End

(cAlias)->(DbCloseArea())   


Return aAlias

/*/
 * {Protheus.doc} RetSM0()
 * Busca o Endereço da Filial da Agencia
 * type    Function
 * author  Eduardo Ferreira
 * since   02/10/2019
 * version 12.25
 * param   Não há
 * return  aAlias
/*/
Static Function RetSM0(cCod)
Local aSM0    := SM0->(GetArea())
Local aGi6    := GI6->(GetArea())
Local cCodEmp := FWCodEmp()
Local cFilAge := Posicione('GI6',1,xFilial('GI6')+cCod,'GI6_FILRES')
Local cChave  := Iif(!Empty(cFilAge), cCodEmp+SUBSTR(cFilAge,1,3), ' ')    
Local aRet    := {}

dbselectarea("SM0")
SM0->(dbsetorder(1))

If SM0->(dbseek(cChave))
    aAdd(aRet,{SM0->M0_ENDCOB,;
               SM0->M0_CEPCOB,;
               SM0->M0_ESTENT})
         
endif
         
RestArea(aSM0)
RestArea(aGi6)

Return aRet



/*/
* {Protheus.doc} QuantDoc()
* Retorna a quantidade de documentos
* type    Function
* author  Eduardo Ferreira
* since   20/10/2019
* version 12.25
* param   Não há
* return  aAlias
/*/
Static Function QuantDoc()
Local aAlias := {}
Local cAlias := GetNextAlias() 
Local cNota1 := MV_PAR01
Local cNota2 := MV_PAR02   

BeginSql Alias cAlias
    SELECT
        G99_NUMDOC
    FROM
        %Table:G99% G99 
    WHERE
        G99_FILIAL = %xFilial:G99% AND
        G99_NUMDOC BETWEEN %Exp:cNota1% AND %Exp:cNota2% AND
        G99.%NotDel%
EndSql

While !(cAlias)->(Eof())
    aAdd(aAlias, {G99_NUMDOC})
    (cAlias)->(dbSkip())
End

(cAlias)->(DbCloseArea())   

Return aAlias
