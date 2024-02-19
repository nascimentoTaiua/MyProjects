#include 'protheus.ch'
#include "report.ch"
#include 'rtmsr36.ch'

/*/-----------------------------------------------------------
{Protheus.doc} RTMSR36()
Relatório Viagem X Veículos X Documentos

Uso: RTMSR36

@author Caio Bruno Murakami
@since 13/09/2019
@history 

@version 1.0
-----------------------------------------------------------/*/
User Function RTMSR36()
Local oReport
Local oSession1
Local oSession2
Local oSession3
 
Pergunte("RTMSR36",.F.)
 
DEFINE REPORT oReport NAME "RTMSR36" TITLE STR0001 PARAMETER "RTMSR36" ACTION {|oReport| PrintReport(oReport)} //-- Documento X Viagem
 
    DEFINE SECTION oSession1 OF oReport TITLE STR0002 TABLES "DTR" //-- Viagens
    
    DEFINE CELL NAME "DTQ_FILORI"       OF oSession1 ALIAS "DTQ"
    DEFINE CELL NAME "DTQ_VIAGEM"       OF oSession1 ALIAS "DTQ"
    DEFINE CELL NAME "DTQ_DATINI"       OF oSession1 ALIAS "DTQ"
    DEFINE CELL NAME "DTQ_DATFIM"       OF oSession1 ALIAS "DTQ"
    
    DEFINE SECTION oSession2 OF oSession1 TITLE STR0003 TABLES "DT6" //-- Veículos 

    DEFINE CELL NAME "DA3VEIC_PLACA"    OF oSession2 ALIAS "DA3" TITLE RetTitle("DA3_PLACA") SIZE TamSx3("DA3_COD")[1]+05
    DEFINE CELL NAME "DA3RB1_PLACA"     OF oSession2 ALIAS "DA3" TITLE RetTitle("DTT_FRORB1")
    DEFINE CELL NAME "DA3RB2_PLACA"     OF oSession2 ALIAS "DA3" TITLE RetTitle("DTT_FRORB2")
    DEFINE CELL NAME "DA3RB3_PLACA"     OF oSession2 ALIAS "DA3" TITLE RetTitle("DTT_FRORB3")
    DEFINE CELL NAME "DA4_CGC"          OF oSession2 ALIAS "DA4" 
    DEFINE CELL NAME "DA4_NREDUZ"       OF oSession2 ALIAS "DA4" TITLE RetTitle("DA4_NOME")

    DEFINE SECTION oSession3 OF oSession1 TITLE STR0004 TABLE "DT6" //-- Documentos
    
    DEFINE CELL NAME "DT6_FILDOC"       OF oSession3 ALIAS "DT6"
    DEFINE CELL NAME "DT6_DOC"          OF oSession3 ALIAS "DT6"
    DEFINE CELL NAME "DT6_SERIE"        OF oSession3 ALIAS "DT6"
    DEFINE CELL NAME "ORIDUY_EST"       OF oSession3 ALIAS "DUY" TITLE RetTitle("DFV_UFORI")
    DEFINE CELL NAME "ORIDUY_DESCRI"    OF oSession3 ALIAS "DUY" TITLE RetTitle("DFV_MUNORI") SIZE 20
    DEFINE CELL NAME "CALDUY_EST"       OF oSession3 ALIAS "DUY" TITLE RetTitle("DFV_UFDES")
    DEFINE CELL NAME "CALDUY_DESCRI"    OF oSession3 ALIAS "DUY" TITLE RetTitle("DFV_MUNDES") SIZE 20
    DEFINE CELL NAME "DTC_KM"           OF oSession3 ALIAS "DTC"
    DEFINE CELL NAME "DT6_VALFRE"       OF oSession3 ALIAS "DT6"
    DEFINE CELL NAME "DT6_VALIMP"       OF oSession3 ALIAS "DT6"
    DEFINE CELL NAME "DT6_VALTOT"       OF oSession3 ALIAS "DT6"
    DEFINE CELL NAME "DT6_DOCTMS"       OF oSession3 ALIAS "DT6"

oReport:PrintDialog()
Return  

/*/-----------------------------------------------------------
{Protheus.doc} PrintReport()
Relatório Viagem X Veículos X Documentos

Uso: RTMSR36

@author Caio Bruno Murakami
@since 13/09/2019
@history 

@version 1.0
-----------------------------------------------------------/*/
Static Function PrintReport(oReport)
Local cAlias    := GetNextAlias()
Local cAliasMot := GetNextAlias()
Local cAliasDoc := GetNextAlias()
Local cExp      := ""

MakeSqlExp("RTMSR36")

cExp    := " DTQ_DATGER >= " + "'" + DToS( mv_par01 )  + "' "+ " AND DTQ_DATENC <=  " + "'" + DToS( mv_par02 ) + "' "
If AllTrim(Str(mv_par03)) == '1'
    cExp    += " AND DTQ_SERTMS  IN ('2','3') " 
Else
    cExp    += " AND DTQ_SERTMS  = '" + AllTrim(STR(mv_par03)) + "' "
EndIf

If mv_par04 == 1 //-- Propria
    cExp    += " AND DA3_FROVEI = '1' "
ElseIf mv_par04 == 2 //-- Terceiros
    cExp    += " AND DA3_FROVEI =  '2' "
ElseIf mv_par04 == 3 //-- Ambos
    cExp    += " AND DA3_FROVEI = '3' "
EndIf

cExp    := "%"+cExp+"%"

//-- Sessão 1
BEGIN REPORT QUERY oReport:Section(1)

BeginSql alias cAlias

SELECT DISTINCT DTQ_FILIAL, DTQ_FILORI, DTQ_VIAGEM , DTQ_DATINI , DTQ_DATFIM
FROM  %table:DTQ% DTQ ,  %table:DTR% DTR ,  %table:DA3% DA3
WHERE DTQ_FILIAL = %xfilial:DTQ% AND DTQ.%notDel% AND DTQ_STATUS = '3' AND DTQ_TIPVIA <> '2' AND 
DTR_FILIAL = %xfilial:DTR% AND DTR.%notDel% AND DTR_FILORI = DTQ_FILORI AND DTR_VIAGEM = DTQ_VIAGEM AND 
DA3_FILIAL = %xfilial:DA3%  AND DA3.%notDel% AND DA3_COD    = DTR_CODVEI  AND 
%exp:cExp%

EndSql

END REPORT QUERY oReport:Section(1) 

//-- Sessão 2
BEGIN REPORT QUERY oReport:Section(1):Section(1)

BeginSql alias cAliasMot

SELECT DISTINCT DA3VEIC.DA3_PLACA DA3VEIC_PLACA , DA4_CGC, DA4_NREDUZ ,    
DA3RB1.DA3_PLACA DA3RB1_PLACA , DA3RB2.DA3_PLACA DA3RB2_PLACA, DA3RB3.DA3_PLACA  DA3RB3_PLACA     
FROM  %table:DTR% DTR 
INNER JOIN  %table:DA3% DA3VEIC 
ON  DA3VEIC.DA3_FILIAL = %xfilial:DA3%  AND DA3VEIC.%notDel% AND DA3VEIC.DA3_COD    = DTR_CODVEI    
INNER JOIN %table:DUP% DUP 
ON DUP_FILIAL = %xfilial:DUP%  AND DUP.%notDel% AND DUP_FILORI = DTR_FILORI AND DUP_VIAGEM = DTR_VIAGEM AND DUP_ITEDTR = DTR_ITEM     
INNER JOIN %table:DA4% DA4  
ON DA4_FILIAL = %xfilial:DA4%  AND DA4.%notDel% AND DA4_COD    = DUP_CODMOT    
LEFT JOIN %table:DA3% DA3RB1 
ON DA3RB1.DA3_FILIAL = %xfilial:DA3%  AND DA3RB1.%notDel% AND DA3RB1.DA3_COD    = DTR_CODRB1
LEFT JOIN %table:DA3% DA3RB2 
ON DA3RB2.DA3_FILIAL = %xfilial:DA3%  AND DA3RB2.%notDel% AND DA3RB2.DA3_COD    = DTR_CODRB2
LEFT JOIN %table:DA3% DA3RB3  
ON DA3RB3.DA3_FILIAL = %xfilial:DA3%  AND DA3RB3.%notDel% AND DA3RB3.DA3_COD    = DTR_CODRB3
WHERE DTR_FILORI = %report_param: (cAlias)->DTQ_FILORI%  AND DTR_VIAGEM = %report_param: (cAlias)->DTQ_VIAGEM%  AND DTR_FILIAL = %xfilial:DTR% AND DTR.%notDel%  

EndSql

END REPORT QUERY oReport:Section(1):Section(1)


BEGIN REPORT QUERY oReport:Section(1):Section(2)

BeginSql alias cAliasDoc

SELECT DISTINCT DT6_FILDOC, DT6_DOC, DT6_SERIE , DT6_VALFRE , DT6_VALIMP , DT6_VALTOT ,  DT6_DOCTMS , DUYCAL.DUY_EST CALDUY_EST ,  DUYCAL.DUY_DESCRI CALDUY_DESCRI ,DUYORI.DUY_EST ORIDUY_EST , DUYORI.DUY_DESCRI ORIDUY_DESCRI , MAX(DTC_KM) DTC_KM
FROM  %table:DUD% DUD, %table:DT6% DT6, %table:DUY% DUY  , %table:DTC% DTC , %table:DUY% DUYCAL , %table:DUY% DUYORI
WHERE DUD_FILIAL = %xfilial:DUD% AND DUD.%notDel% AND DUD_FILORI = %report_param: (cAlias)->DTQ_FILORI % AND DUD_VIAGEM = %report_param: (cAlias)->DTQ_VIAGEM % AND
DT6_FILIAL = %xfilial:DT6%  AND DT6.%notDel% AND DT6_FILDOC = DUD_FILDOC AND DT6_DOC = DUD_DOC AND DT6_SERIE = DUD_SERIE  AND
DTC_FILIAL = %xfilial:DTC% AND DTC.%notDel% AND DTC_FILDOC = DT6_FILDOC AND DTC_DOC = DT6_DOC AND DTC_SERIE = DT6_SERIE AND
DUYCAL.DUY_FILIAL = %xfilial:DUY% AND DUYCAL.%notDel% AND DUYCAL.DUY_GRPVEN = DTC_CDRCAL  AND 
DUYORI.DUY_FILIAL = %xfilial:DUY% AND DUYORI.%notDel% AND DUYORI.DUY_GRPVEN = DTC_CDRORI

GROUP BY DT6_FILDOC, DT6_DOC, DT6_SERIE , DT6_VALFRE , DT6_VALIMP , DT6_VALTOT , DT6_DOCTMS , DUYCAL.DUY_EST  ,DUYCAL.DUY_DESCRI ,  DUYORI.DUY_EST , DUYORI.DUY_DESCRI

EndSql

END REPORT QUERY oReport:Section(1):Section(2)

oReport:Section(1):Print()

Return