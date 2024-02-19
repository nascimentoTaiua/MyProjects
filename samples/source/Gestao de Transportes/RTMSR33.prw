#INCLUDE "RTMSR33.ch"
#INCLUDE "Protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE 'TOPCONN.CH'
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³RTMSR33  ³ Autor ³Aluizio F. Habizenreuter³ Data ³23/11/17  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Emiss„o de Relatorio de Tabela de frete                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RTMSR33()

Local oReport
Local aArea := GetArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Interface de impressao.                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport := ReportDef()
oReport:PrintDialog()

RestArea(aArea)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef³ Autor ³Aluizio F. Habizenreuter³ Data ³23/11/17  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpO1: Objeto do relatório                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()

Local oReport   := Nil
Local oSec1DTL  := Nil //Tabela de frete e suas Regiões
Local oSec2DVE  := Nil //Componentes da tabela de frete, faixas e sub-faixas
Local oSec2DTK  := Nil //Complemento dos componentes de frete
Local oSec2DY1  := Nil //Excedente dos componentes de frete
Local oSec2DVY  := Nil //Componentes afetados pelo TDA
Local oSec2DJS  := Nil //Componentes afetados pelo TRT

oReport := TReport():New("RTMSR33",STR0001,"RTMSR33", {|oReport| RTMSR33Imp(oReport)}) //Relatório de tabela de frete
oReport:SetLandscape()
oReport:SetTotalInLine(.F.)
oReport:HideParamPage()   // Desabilita a impressao da pagina de parametros.
Pergunte("RTMSR33",.F.)

//----------------------------------------------
// SEÇÃO TABELA DE FRETE E SUAS REGIÕES
//----------------------------------------------
oSec1DTL := TRSection():New(oReport,STR0002,{"DTL"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)//Tabela de frete 
oSec1DTL:SetPageBreak(.T.)		//Define se salta a página na quebra de seção
oSec1DTL:SetAutoSize(.T.)		//Ajusta alinhamento da célula por toda a extensao da linha
oSec1DTL:SetTotalInLine(.F.)
TRCell():New(oSec1DTL,"DTL_FILIAL","DTL",STR0027,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{||DTL_FILIAL}*/) //"Filial Tabela de frete"
TRCell():New(oSec1DTL,"DTL_TABFRE","DTL",STR0002,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{||DTL_TABFRE}*/) //"Tabela de frete"
TRCell():New(oSec1DTL,"DTL_DESCRI","DTL",STR0007,/*Picture*/,20,/*lPixel*/,/*{||DTL_DESCRI}*/) //"Descrição da tabela de frete"
TRCell():New(oSec1DTL,"DTL_TIPTAB","DTL",STR0008,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{||DTL_TIPTAB}*/) //"Tipo da tabela de frete"
TRCell():New(oSec1DTL,"DES_TIPTAB","DTL",STR0009,/*Picture*/,20,/*lPixel*/,/*{||DES_TIPTAB}*/) //"Descrição do Tipo da tabela de frete"
TRCell():New(oSec1DTL,"DTL_DATDE" ,"DTL",STR0028,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{||DTL_DATDE}*/)  //"Inicio da vigencia da tabela de frete"
TRCell():New(oSec1DTL,"DTL_DATATE","DTL",STR0039,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{||DTL_DATATE}*/)  //"Fim da vigencia da tabela de frete"
TRCell():New(oSec1DTL,"DT0_CDRORI","DT0",STR0010,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{||DT0_CDRORI}*/) //"Código da origem"
TRCell():New(oSec1DTL,"DESCORIG"  ,"DUY",STR0011,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{||DUY_DESCRI}*/) //"Descrição da origem"
TRCell():New(oSec1DTL,"DT0_CDRDES","DT0",STR0012,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{||DT0_CDRDES}*/) //"Código do Destino"
TRCell():New(oSec1DTL,"DESCDEST"  ,"DUY",STR0013,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{||DUY_DESCRI}*/) //"Descrição do destino"
TRCell():New(oSec1DTL,"DT0_CODPRO","DT0",STR0026,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{||DT0_CODPRO}*/) //"Código do Produto"
TRCell():New(oSec1DTL,"B1_DESC"   ,"SB1",STR0029,/*Picture*/,20,/*lPixel*/,/*{||B1_DESC}   */) //"Descrição do Produto"
TRCell():New(oSec1DTL,"DT0_TABTAR","DT0",STR0030,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{||DT0_TABTAR}*/) //"Tabela de Tarifa"

//----------------------------------------------
// SEÇÃO COMPONENTES DA TABELA DE FRETE, FAIXAS E SUB-FAIXAS DOS COMPONENTES
//----------------------------------------------
oSec2DVE := TRSection():New(oSec1DTL,STR0003,{"DVE"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)//Componentes de frete
oSec2DVE:SetAutoSize(.T.)			//Ajusta alinhamento da célula por toda a extensao da linha
oSec2DVE:SetHeaderSection(.T.)
oSec2DVE:SetTotalInLine(.F.)
TRCell():New(oSec2DVE,"DVE_CODPAS","DVE",STR0014,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{||DVE_CODPAS}*/) //"Componente"
TRCell():New(oSec2DVE,"DT3_DESCRI","DT3",STR0007,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{||DT3_DESCRI}*/) //"Descrição Componente"
TRCell():New(oSec2DVE,"DT1_ITEM"  ,"DT1",STR0015,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{||DT1_ITEM  }*/) //"Item"
TRCell():New(oSec2DVE,"VALATE_DT1","DT1",STR0016,/*Picture*/,TamSX3("DT1_VALATE")[1],/*lPixel*/,/*{||DT1_VALATE}*/) //"Faixas - Até"
TRCell():New(oSec2DVE,"FATPES_DT1","DT1",STR0017,/*Picture*/,TamSX3("DT1_FATPES")[1],/*lPixel*/,/*{||DT1_FATPES}*/) //"Fator peso"
TRCell():New(oSec2DVE,"VALOR_DT1" ,"DT1",STR0018,/*Picture*/,TamSX3("DT1_VALOR")[1],/*lPixel*/,/*{||DT1_VALOR }*/) //"Valor"
TRCell():New(oSec2DVE,"INTERV_DT1","DT1",STR0019,/*Picture*/,TamSX3("DT1_INTERV")[1],/*lPixel*/,/*{||DT1_INTERV}*/) //"Fração"
TRCell():New(oSec2DVE,"DT1_TARIFA","DT1",STR0020,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{||DT1_TARIFA}*/) //"Comp tarifa"
TRCell():New(oSec2DVE,"DW1_ITEM","DW1",STR0015,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{||DW1_ITEM}*/) //"Item"
TRCell():New(oSec2DVE,"VALATE_DW1","DW1",STR0033,/*Picture*/,TamSX3("DW1_VALATE")[1],/*lPixel*/,/*{||DW1_VALATE}*/) //"Subfaixas - Até"
TRCell():New(oSec2DVE,"FATPES_DW1","DW1",STR0017,/*Picture*/,TamSX3("DW1_FATPES")[1],/*lPixel*/,/*{||DW1_FATPES}*/) //"Fator peso"
TRCell():New(oSec2DVE,"VALOR_DW1" ,"DW1",STR0018,/*Picture*/,TamSX3("DW1_VALOR")[1],/*lPixel*/,/*{||DW1_VALOR }*/) //"Valor"
TRCell():New(oSec2DVE,"INTERV_DW1","DW1",STR0019,/*Picture*/,TamSX3("DW1_INTERV")[1],/*lPixel*/,/*{||DW1_INTERV}*/) //"Fração"

//----------------------------------------------
// SEÇÃO COMPLEMENTO DOS COMPONENTES DA TABELA DE FRETE
//----------------------------------------------
oSec2DTK := TRSection():New(oSec1DTL,STR0006,{"DTK"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)
oSec2DTK:SetAutoSize(.T.)			//Ajusta alinhamento da célula por toda a extensao da linha
TRCell():New(oSec2DTK,"DTK_CODPAS","DTK",STR0014,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{||DTK_CODPAS}*/) //"Componente de frete"
TRCell():New(oSec2DTK,"DTK_EXCMIN","DTK",STR0021,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{||DTK_EXCMIN}*/) //"Min Exces"
TRCell():New(oSec2DTK,"DTK_VALMIN","DTK",STR0022,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{||DTK_VALMIN}*/) //"Valor Minimo"
TRCell():New(oSec2DTK,"DTK_VALMAX","DTK",STR0023,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{||DTK_VALOR }*/) //"Valor Maximo"
TRCell():New(oSec2DTK,"DTK_VALOR" ,"DTK",STR0024,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{||DTK_VALOR }*/) //"Valor Excedente"
TRCell():New(oSec2DTK,"DTK_INTERV","DTK",STR0025,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{||DTK_INTERV}*/) //"Fração Excedente"

//----------------------------------------------
// SEÇÃO EXCEDENTE DAS FAIXAS DOS COMPONENTES DE FRETE
//----------------------------------------------
oSec2DY1 := TRSection():New(oSec1DTL,STR0005,{"DY1"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)
oSec2DY1:SetAutoSize(.T.)			//Ajusta alinhamento da célula por toda a extensao da linha
TRCell():New(oSec2DY1,"DY1_CODPAS","DY1",STR0014,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{||DY1_CODPAS}*/) //"Componente de frete"
TRCell():New(oSec2DY1,"DT1_VALATE","DW1",STR0016,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{||DT1_VALATE}*/) //"Faixas - até"
TRCell():New(oSec2DY1,"DY1_EXCMIN","DY1",STR0021,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{||DY1_EXCMIN}*/) //"Min. Exces"
TRCell():New(oSec2DY1,"DY1_VALMIN","DY1",STR0022,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{||DY1_VALMIN}*/) //"Val Min"
TRCell():New(oSec2DY1,"DY1_VALMAX","DY1",STR0023,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{||DY1_VALMAX}*/) //"Val Max"
TRCell():New(oSec2DY1,"DY1_VALOR" ,"DY1",STR0024,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{||DY1_VALOR }*/) //"Vlr. Excedent"
TRCell():New(oSec2DY1,"DY1_INTERV","DY1",STR0019,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{||DY1_INTERV}*/) //"Fração"

//----------------------------------------------
// SEÇÃO COMPONENTES RELACIONADOS A TDA
//----------------------------------------------
oSec2DVY := TRSection():New(oSec1DTL,STR0034,{"DVY"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)
oSec2DVY:SetAutoSize(.T.)			//Ajusta alinhamento da célula por toda a extensao da linha
TRCell():New(oSec2DVY,"DVY_CODPAS","DVY",STR0014,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{||DVY_CODPAS}*/) //"Componente de frete"
TRCell():New(oSec2DVY,"DVY_DESPAS","DVY",STR0007,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{||DVY_DESPAS}*/) //"Descrição Componente"
TRCell():New(oSec2DVY,"DVY_VLBASE","DVY",STR0035,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{||DVY_VLBASE}*/) //"Percentual Base Calculo"

//----------------------------------------------
// SEÇÃO COMPONENTES RELACIONADOS A TRT
//----------------------------------------------
oSec2DJS := TRSection():New(oSec1DTL,STR0036,{"DJS"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)
oSec2DJS:SetAutoSize(.T.)			//Ajusta alinhamento da célula por toda a extensao da linha
TRCell():New(oSec2DJS,"DJS_CODPAS","DJS",STR0014,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{||DJS_CODPAS}*/) //"Componente de frete"
TRCell():New(oSec2DJS,"DJS_CODTRT","DJS",STR0037,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{||DJS_CODTRT}*/) //"Componente de frete TRT"
TRCell():New(oSec2DJS,"DJS_PERCEN","DJS",STR0038,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{||DJS_PERCEN}*/) //"Percentual"

Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa ³ReportPrin³ Autor ³Aluizio F. Habizenreuter³ Data ³23/11/17  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatório                           ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RTMSR33Imp(oReport)

Local oSec1DTL  := oReport:Section(1) //Tabela de frete e suas Regiões
Local oSec2DVE  := oReport:Section(1):Section(1) //Componentes da tabela de frete, faixas e sub-faixas
Local oSec2DTK  := oReport:Section(1):Section(2) //Complemento do componente de frete
Local oSec2DY1  := oReport:Section(1):Section(3) //Excedente das faixas do componente de frete
Local oSec2DVY  := oReport:Section(1):Section(4) //COMPONENTES RELACIONADOS A TDA
Local oSec2DJS  := oReport:Section(1):Section(5) //COMPONENTES RELACIONADOS A TRT
Local cQryMain  := ""	
Local cQryNReg  := ""
Local cWhrMain  := ""
Local cWhrNReg  := ""
Local cFields   := ""	
Local cGroupBy  := ""
Local cDTL_FIL  := ""   
Local cDTL_TAB  := ""
Local cDTL_TIP  := ""
Local cDT0_ORI  := ""
Local cDT0_DES  := ""
Local cDT0_PRD  := ""
Local cDVE_COD  := ""		
Local cDT1_ITE  := ""
Local cDW1_ITE  := ""
Local aAreaRep  := ""
Local aAreaSec  := ""
Local cAliasDTL := "" 
Local cAliasReg := ""
Local cAliasDTK := ""
Local cAliasDY1 := ""
Local cAliasDVY := ""
Local cAliasDJS := ""
Local nTotRegs  := 0 
Local nCntRegs  := 0
Local lSecDTK   := .F.
Local lSecDY1   := .F.
Local lSecDVY   := .F.
Local lSecDJS   := .F.

Local aContrt   := {}
Local cContrt   := ""
Local nCntFor   := 1

//Lógica para busca de todos os Contratos Vigentes, Ativos e que atendam as demais condições para o Cliente e Loja informados no filtro.
If !Empty(mv_par12) .And. !Empty(mv_par13)
	If !Empty(mv_par11)
	   cContrt += "'"+mv_par11 +"',"
	EndIf
	aContrt   := TMSContrat(mv_par12, mv_par13,,,.F.,,.F.,,,,,,,,,,,,,,,)
	If Len(aContrt)>0
		For nCntFor := 1 To Len(aContrt)
			cContrt += "'"+aContrt[nCntFor,1] +"',"			
		Next nCntFor
	EndIf	
	cContrt := Substr(cContrt,1,Len(cContrt)-1)	
EndIf

//Se o Pergunte do Contrato tiver sido informado, e a variavel 'cContrt' estiver nula, indica que não foi informado Cliente e Loja. Então, alimentá-la só com o Pergunte do Contrato.
If !Empty(mv_par11) .And. Empty(cContrt) 
   cContrt := "'"+mv_par11 +"'"
EndIf
	
aAreaRep  := GetArea()
cAliasDTL := GetNextAlias()
//Consulta envolvendo as tabelas DTL, DVE, DT3, DT0, DUY, DTK, DT1, DY1 e DW1
cFields := " SELECT DTL_FILIAL, DTL_TABFRE, DTL_DESCRI, DTL_TIPTAB, DTL_DATDE, DTL_DATATE "
cFields +=          ", DT0_CDRORI, DUY1.DUY_DESCRI DESCORIG, DT0_CDRDES, DUY2.DUY_DESCRI DESCDEST, DT0_CODPRO, DT0_TABTAR"
cFields +=          ", DVE_CODPAS, DT3_DESCRI"
cFields +=          ", DT1_ITEM, DT1_VALATE, DT1_FATPES, DT1_VALOR, DT1_INTERV, DT1_TARIFA"
cFields +=          ", DW1_ITEM, DW1_VALATE, DW1_FATPES, DW1_VALOR, DW1_INTERV" 

//Configuração da tabela de frete
cQryMain :=   " FROM "+RETSQLNAME("DTL")+" DTL " 
//Componentes da tabela de frete
cQryMain +=   " JOIN "+RETSQLNAME("DVE")+" DVE "
cQryMain +=     " ON DVE_FILIAL = DTL_FILIAL AND DVE_TABFRE = DTL_TABFRE AND DVE_TIPTAB = DTL_TIPTAB AND DVE.D_E_L_E_T_  = ' '"
//Componentes de frete
cQryMain +=   " JOIN "+RETSQLNAME("DT3")+" DT3 "
cQryMain +=     " ON DT3_FILIAL = DVE_FILIAL AND DT3_CODPAS = DVE_CODPAS AND DT3.D_E_L_E_T_  = ' '"
//Regiões da tabela de frete
cQryMain +=   " JOIN "+RETSQLNAME("DT0")+" DT0 "
cQryMain +=     " ON DT0_FILIAL = DTL_FILIAL AND DT0_TABFRE = DTL_TABFRE AND DT0_TIPTAB = DTL_TIPTAB AND DT0.D_E_L_E_T_  = ' '"
//Região de Origem
cQryMain +=   " JOIN "+RETSQLNAME("DUY")+" DUY1 "
cQryMain +=     " ON DUY1.DUY_FILIAL = DT0_FILIAL AND DUY1.DUY_GRPVEN = DT0_CDRORI AND DUY1.D_E_L_E_T_  = ' '"
//Região de Destino
cQryMain +=   " JOIN "+RETSQLNAME("DUY")+" DUY2 "
cQryMain +=     " ON DUY2.DUY_FILIAL = DT0_FILIAL AND DUY2.DUY_GRPVEN = DT0_CDRDES AND DUY2.D_E_L_E_T_  = ' '"
//Faixas dos Componentes da tabela de frete
cQryMain +=   " JOIN "+RETSQLNAME("DT1")+" DT1 " 
cQryMain +=     " ON DT1_FILIAL = DT0_FILIAL AND DT1_TABFRE = DT0_TABFRE AND DT1_TIPTAB = DT0_TIPTAB AND DT1_CDRORI = DT0_CDRORI AND DT1_CDRDES = DT0_CDRDES AND DT1_CODPAS = DVE_CODPAS AND DT1_CODPRO = DT0_CODPRO AND DT1.D_E_L_E_T_  = ' '"
//Sub-faixas dos Componentes da tabela de frete
cQryMain +=   " LEFT JOIN "+RETSQLNAME("DW1")+" DW1 "
cQryMain +=     " ON DW1_FILIAL = DT1_FILIAL AND DW1_TABFRE = DT1_TABFRE AND DW1_TIPTAB = DT1_TIPTAB AND DW1_CDRORI = DT1_CDRORI AND DW1_CDRDES = DT1_CDRDES AND DW1_CODPAS = DT1_CODPAS AND DW1_CODPRO = DT1_CODPRO AND DW1_ITEDT1 = DT1_ITEM AND DW1.D_E_L_E_T_  = ' '"

//Salvar a Query para uso na quantidade de Registros.
cQryNReg := cQryMain 

//Issue DLOGTMS01-680. Considerar como Cliente ou Fornecedor, de acordo com o parametro da categoria da tabela de frete.
If     mv_par10 == 1 .And. !Empty(cContrt) .And. (!Empty(mv_par11) .Or. (!Empty(mv_par12) .And. !Empty(mv_par13))) //Cliente
   cQryMain +=   " JOIN "+RETSQLNAME("DDA")+" DDA ON DDA_FILIAL = DTL_FILIAL AND DDA_TABFRE = DTL_TABFRE AND DDA_TIPTAB = DTL_TIPTAB AND DDA.D_E_L_E_T_  = ' '"
   cQryMain +=   " JOIN "+RETSQLNAME("DDC")+" DDC ON DDC_FILIAL = DDA_FILIAL AND DDC_NCONTR = DDA_NCONTR AND DDC_CODNEG = DDA_CODNEG AND DDC.D_E_L_E_T_  = ' '"
   cQryMain +=   " JOIN "+RETSQLNAME("AAM")+" AAM ON AAM_FILIAL = DDC_FILIAL AND AAM_CONTRT = DDC_NCONTR AND AAM_CONTRT IN (" +cContrt+ ") AND AAM.D_E_L_E_T_  = ' '"
ElseIf mv_par10 == 2 .And. (!Empty(mv_par11) .Or. (!Empty(mv_par14) .And. !Empty(mv_par15))) //Fornecedor
   cQryMain +=   " JOIN "+RETSQLNAME("DVG")+" DVG ON DVG_FILIAL = DTL_FILIAL AND DVG_TABFRE = DTL_TABFRE AND DVG_TIPTAB = DTL_TIPTAB AND DVG.D_E_L_E_T_  = ' '"
   cQryMain +=   " JOIN "+RETSQLNAME("DUJ")+" DUJ ON DUJ_FILIAL = DVG_FILIAL AND DUJ_NCONTR = DVG_NCONTR AND (DUJ.DUJ_FIMVIG = ' ' OR (DUJ.DUJ_FIMVIG <> ' ' AND DUJ.DUJ_FIMVIG < '" + DtoS(Date())+ "')) AND DUJ.D_E_L_E_T_  = ' '"  
EndIf

cWhrMain :=  " WHERE DTL.D_E_L_E_T_  = ' ' "
cWhrMain +=    " AND DTL_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
cWhrMain +=    " AND DTL_TABFRE BETWEEN '"+mv_par04+"' AND '"+mv_par05+"' "
cWhrMain +=    " AND DTL_DATDE >= '"+DTOS(mv_par06)+"' AND DTL_DATATE <= '"+DTOS(mv_par07)+"' "
cWhrMain +=    " AND DTL_CATTAB = '"+cValToChar(mv_par10)+"' "

If !Empty(mv_par03)
	cWhrMain +=    " AND DTL_TIPTAB = '"+mv_par03+"' "
EndIf
If !Empty(mv_par08)
	cWhrMain +=    " AND DT0_CDRORI = '"+mv_par08+"' "
EndIf
If !Empty(mv_par09)
	cWhrMain +=    " AND DT0_CDRDES = '"+mv_par09+"' "
EndIf

//Salvar o Where para uso na quantidade de Registros.
cWhrNReg := cWhrMain 

//Issue DLOGTMS01-680. Considerar como Cliente ou Fornecedor, de acordo com o parametro da categoria da tabela de frete.
If     mv_par10 == 1 .And. !Empty(mv_par12) .And. !Empty(mv_par13) //Cliente
   cWhrMain +=    " AND AAM.AAM_CODCLI = '"+mv_par12+"' AND AAM.AAM_LOJA = '"+mv_par13+"' "
ElseIf mv_par10 == 2 .And. !Empty(mv_par14) .And. !Empty(mv_par15) //Fornecedor
   cWhrMain +=    " AND DUJ.DUJ_CODFOR = '"+mv_par14+"' AND DUJ.DUJ_LOJFOR = '"+mv_par15+"' "	
EndIf

If !Empty(mv_par11) //Contrato de Cliente ou Fornecedor
	If     mv_par10 == 1
		cWhrMain +=    " AND DDA_NCONTR = '"+mv_par11+"' "
	EndIf
EndIf	

cGroupBy := " GROUP BY DTL_FILIAL, DTL_TABFRE, DTL_DESCRI, DTL_TIPTAB, DTL_DATDE, DTL_DATATE "
cGroupBy +=         ", DT0_CDRORI, DUY1.DUY_DESCRI, DT0_CDRDES, DUY2.DUY_DESCRI, DT0_CODPRO, DT0_TABTAR"
cGroupBy +=         ", DT3_TIPVEI, DVE_CODPAS, DT3_DESCRI"
cGroupBy +=         ", DT1_ITEM, DT1_VALATE, DT1_FATPES, DT1_VALOR, DT1_INTERV, DT1_TARIFA"
cGroupBy +=         ", DW1_ITEM, DW1_VALATE, DW1_FATPES, DW1_VALOR, DW1_INTERV"
cQuery := cFields + cQryMain + cWhrMain + cGroupBy
cQuery +=  " ORDER BY DTL_FILIAL,DTL_TABFRE,DT0_CDRORI,DT0_CDRDES,DT0_CODPRO,DT3_TIPVEI,DVE_CODPAS,DT1_ITEM,DW1_ITEM "
cQuery := ChangeQuery(cQuery)
		
DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAliasDTL,.T.,.T.)

While !(cAliasDTL)->(Eof())
		
	If oReport:Cancel()
		Exit
	EndIf
	
	oReport:IncMeter()
					
	If (cAliasDTL)->(DTL_FILIAL+DTL_TABFRE+DTL_TIPTAB+DT0_CDRORI+DT0_CDRDES+DT0_CODPRO) <> cDTL_FIL+cDTL_TAB+cDTL_TIP+cDT0_ORI+cDT0_DES+cDT0_PRD
		//##########################################################
		// Inicialização da seção da tabela DTL - Tabela de frete. #
		//##########################################################
		oReport:SkipLine(1)
		oSec1DTL:Init()	
		oSec1DTL:Cell("DTL_FILIAL"):SetValue((cAliasDTL)->DTL_FILIAL)
		oSec1DTL:Cell("DTL_TABFRE"):SetValue((cAliasDTL)->DTL_TABFRE)				
		oSec1DTL:Cell("DTL_DESCRI"):SetValue((cAliasDTL)->DTL_DESCRI)
		oSec1DTL:Cell("DTL_TIPTAB"):SetValue((cAliasDTL)->DTL_TIPTAB)
		oSec1DTL:Cell("DES_TIPTAB"):SetValue(Tabela("M5", (cAliasDTL)->DTL_TIPTAB,.F.))
		oSec1DTL:Cell("DTL_DATDE"):SetValue(StoD((cAliasDTL)->DTL_DATDE))
		oSec1DTL:Cell("DTL_DATATE"):SetValue(StoD((cAliasDTL)->DTL_DATATE))
		oSec1DTL:Cell("DT0_CDRORI"):SetValue((cAliasDTL)->DT0_CDRORI)
		oSec1DTL:Cell("DESCORIG"):SetValue((cAliasDTL)->DESCORIG)
		oSec1DTL:Cell("DT0_CDRDES"):SetValue((cAliasDTL)->DT0_CDRDES)
		oSec1DTL:Cell("DESCDEST"):SetValue((cAliasDTL)->DESCDEST)		
		oSec1DTL:Cell("DT0_CODPRO"):SetValue((cAliasDTL)->DT0_CODPRO)
		oSec1DTL:Cell("DT0_TABTAR"):SetValue((cAliasDTL)->DT0_TABTAR)
		If !Empty((cAliasDTL)->DT0_CODPRO)
			aAreaSec := GetArea()
			dbSelectArea("SB1")
			SB1->(dbSetOrder(1))
			IF SB1->(dbSeek(xFilial("SB1")+(cAliasDTL)->DT0_CODPRO))
				oSec1DTL:Cell("B1_DESC"):SetValue(SB1->B1_DESC)
			EndIf
			RestArea(aAreaSec)
		Else
			oSec1DTL:Cell("B1_DESC"):SetValue("")
		EndIf			
		oSec1DTL:Printline()
	
		//######################################################################
		//Busca do total de registros relacionados ao cabeçalho, para utilizar #      
		// no controle do "Finish" das regiões e da tabela de frete em si.     #
		//######################################################################			
		aAreaSec := GetArea()
		cAliasReg := GetNextAlias()
		cQuery := "SELECT COUNT(*) nTotRegs "
		cQuery += cQryNReg
		cQuery += cWhrNReg
		cQuery += " AND DT0_FILIAL = '" + (cAliasDTL)->DTL_FILIAL + "'"
		cQuery += " AND DT0_TABFRE = '" + (cAliasDTL)->DTL_TABFRE + "'"
		cQuery += " AND DT0_TIPTAB = '" + (cAliasDTL)->DTL_TIPTAB + "'"
		cQuery += " AND DT0_CDRORI = '" + (cAliasDTL)->DT0_CDRORI + "'"
		cQuery += " AND DT0_CDRDES = '" + (cAliasDTL)->DT0_CDRDES + "'"
		cQuery += " AND DT0_CODPRO = '" + (cAliasDTL)->DT0_CODPRO + "'"
		cQuery += " AND DT0.D_E_L_E_T_ = ' '"		
		cQuery := ChangeQuery(cQuery)
		DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAliasReg,.T.,.T.)
	
		nTotRegs := (cAliasReg)->nTotRegs
		nCntRegs := 1
		(cAliasReg)->(DbCloseArea())
		RestArea(aAreaSec)
	EndIf	
	
	//##########################################################################################
	//Inicialização e emissão da seção das tabelas DVE e DT1 - Componentes da tabela de frete. #
	//##########################################################################################
	If (cAliasDTL)->(DTL_FILIAL+DTL_TABFRE+DTL_TIPTAB+DT0_CDRORI+DT0_CDRDES+DT0_CODPRO+DVE_CODPAS) <> cDTL_FIL+cDTL_TAB+cDTL_TIP+cDT0_ORI+cDT0_DES+cDT0_PRD+cDVE_COD        
		oSec2DVE:Init()
		oSec2DVE:Cell("DVE_CODPAS"):SetValue((cAliasDTL)->DVE_CODPAS)
    	oSec2DVE:Cell("DT3_DESCRI"):SetValue((cAliasDTL)->DT3_DESCRI)
	Else
		oSec2DVE:Cell("DVE_CODPAS"):SetValue("")
    	oSec2DVE:Cell("DT3_DESCRI"):SetValue("")		
	EndIf

	If (cAliasDTL)->(DTL_FILIAL+DTL_TABFRE+DTL_TIPTAB+DT0_CDRORI+DT0_CDRDES+DT0_CODPRO+DVE_CODPAS+DT1_ITEM) <> cDTL_FIL+cDTL_TAB+cDTL_TIP+cDT0_ORI+cDT0_DES+cDT0_PRD+cDVE_COD+cDT1_ITE
		oSec2DVE:Cell("DT1_ITEM"):SetValue((cAliasDTL)->DT1_ITEM)
		oSec2DVE:Cell("VALATE_DT1"):SetValue((cAliasDTL)->DT1_VALATE)
		oSec2DVE:Cell("FATPES_DT1"):SetValue((cAliasDTL)->DT1_FATPES)		
		oSec2DVE:Cell("VALOR_DT1"):SetValue((cAliasDTL)->DT1_VALOR)
		oSec2DVE:Cell("INTERV_DT1"):SetValue((cAliasDTL)->DT1_INTERV)
		oSec2DVE:Cell("DT1_TARIFA"):SetValue((cAliasDTL)->DT1_TARIFA)
	Else
		oSec2DVE:Cell("DT1_ITEM"):SetValue("")
		oSec2DVE:Cell("VALATE_DT1"):SetValue(Transform("","@!")) 
		oSec2DVE:Cell("FATPES_DT1"):SetValue(Transform("","@!"))		
		oSec2DVE:Cell("VALOR_DT1"):SetValue(Transform("","@!"))
		oSec2DVE:Cell("INTERV_DT1"):SetValue(Transform("","@!"))
		oSec2DVE:Cell("DT1_TARIFA"):SetValue("")
	EndIf
	
	If !Empty((cAliasDTL)->DW1_ITEM)
		oSec2DVE:Cell("DW1_ITEM"):SetValue((cAliasDTL)->DW1_ITEM)
		oSec2DVE:Cell("VALATE_DW1"):SetValue((cAliasDTL)->DW1_VALATE)
		oSec2DVE:Cell("FATPES_DW1"):SetValue((cAliasDTL)->DW1_FATPES)		
		oSec2DVE:Cell("VALOR_DW1"):SetValue((cAliasDTL)->DW1_VALOR)
		oSec2DVE:Cell("INTERV_DW1"):SetValue((cAliasDTL)->DW1_INTERV)	
		oSec2DVE:Printline()
	Else
		oSec2DVE:Cell("DW1_ITEM"):SetValue("")
		oSec2DVE:Cell("VALATE_DW1"):SetValue(Transform("","@!"))
		oSec2DVE:Cell("FATPES_DW1"):SetValue(Transform("","@!"))		
		oSec2DVE:Cell("VALOR_DW1"):SetValue(Transform("","@!"))
		oSec2DVE:Cell("INTERV_DW1"):SetValue(Transform("","@!"))
		oSec2DVE:Printline()
	EndIf
	
	If nTotRegs = nCntRegs
		//#############################################
		//Busca e emissão dos registros da tabela DTK #      
		//#############################################			
		aAreaSec := GetArea()
		cAliasDTK := GetNextAlias()
		cQuery := "SELECT DTK_CODPAS, DTK_EXCMIN, DTK_VALMIN, DTK_VALMAX, DTK_VALOR, DTK_INTERV "
		cQuery += "  FROM " + RetSqlName("DTK")+" DTK "
		cQuery += " WHERE DTK_FILIAL = '" + (cAliasDTL)->DTL_FILIAL + "'"
		cQuery += "   AND DTK_TABFRE = '" + (cAliasDTL)->DTL_TABFRE + "'"
		cQuery += "   AND DTK_TIPTAB = '" + (cAliasDTL)->DTL_TIPTAB + "'"
		cQuery += "   AND DTK_CDRORI = '" + (cAliasDTL)->DT0_CDRORI + "'"
		cQuery += "   AND DTK_CDRDES = '" + (cAliasDTL)->DT0_CDRDES + "'"
		cQuery += "   AND DTK_CODPRO = '" + (cAliasDTL)->DT0_CODPRO + "'"
		cQuery += "   AND DTK.D_E_L_E_T_ = ' '"
		cQuery += " ORDER BY DTK_CODPAS"
		cQuery := ChangeQuery(cQuery)
		DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAliasDTK,.T.,.T.)
	
		While !(cAliasDTK)->(Eof())
			If lSecDTK = .F.
				oReport:Skipline()
				oReport:PrintText(STR0031)
				oSec2DTK:Init()
				lSecDTK = .T.
			EndIf
			oSec2DTK:Cell("DTK_CODPAS"):SetValue((cAliasDTK)->DTK_CODPAS)
			oSec2DTK:Cell("DTK_EXCMIN"):SetValue((cAliasDTK)->DTK_EXCMIN)
			oSec2DTK:Cell("DTK_VALMIN"):SetValue((cAliasDTK)->DTK_VALMIN)		
			oSec2DTK:Cell("DTK_VALMAX"):SetValue((cAliasDTK)->DTK_VALMAX)
			oSec2DTK:Cell("DTK_VALOR"):SetValue((cAliasDTK)->DTK_VALOR)		    	
			oSec2DTK:Cell("DTK_INTERV"):SetValue((cAliasDTK)->DTK_INTERV)
			oSec2DTK:Printline()		
			
			(cAliasDTK)->(DbSkip())	
		EndDo
		(cAliasDTK)->(DbCloseArea())
		RestArea(aAreaSec)	
	
		If lSecDTK = .T.
			oSec2DTK:Finish()
			lSecDTK = .F.
		EndIf

		//#############################################
		//Busca e emissão dos registros da tabela DY1 #      
		//#############################################			
		aAreaSec := GetArea()
		cAliasDY1 := GetNextAlias()
		cQuery := "SELECT DY1_CODPAS, DT1_VALATE, DY1_EXCMIN, DY1_VALMIN, DY1_VALMAX, DY1_VALOR, DY1_INTERV "
		cQuery += "  FROM " + RetSqlName("DY1")+" DY1 "
		cQuery +=   " JOIN "+RETSQLNAME("DT1")+" DT1 "
		cQuery +=     " ON DT1_FILIAL = DY1_FILIAL AND DT1_TABFRE = DY1_TABFRE AND DT1_TIPTAB = DY1_TIPTAB AND DT1_CDRORI = DY1_CDRORI AND DT1_CDRDES = DY1_CDRDES AND DT1_CODPRO = DY1_CODPRO AND DT1_CODPAS = DY1_CODPAS AND DT1_ITEM = DY1_ITEDT1 AND DT1.D_E_L_E_T_  = ' '"
		cQuery += " WHERE DY1_FILIAL = '" + (cAliasDTL)->DTL_FILIAL + "'"
		cQuery += "   AND DY1_TABFRE = '" + (cAliasDTL)->DTL_TABFRE + "'"
		cQuery += "   AND DY1_TIPTAB = '" + (cAliasDTL)->DTL_TIPTAB + "'"
		cQuery += "   AND DY1_CDRORI = '" + (cAliasDTL)->DT0_CDRORI + "'"
		cQuery += "   AND DY1_CDRDES = '" + (cAliasDTL)->DT0_CDRDES + "'"
		cQuery += "   AND DY1_CODPRO = '" + (cAliasDTL)->DT0_CODPRO + "'"
		cQuery += "   AND DY1.D_E_L_E_T_ = ' '"
		cQuery += " ORDER BY DY1_ITEM"
		cQuery := ChangeQuery(cQuery)
		DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAliasDY1,.T.,.T.)
	
		While !(cAliasDY1)->(Eof())
			If lSecDY1 = .F.
				oReport:Skipline()
				oReport:PrintText(STR0032)
				oSec2DY1:Init()
				lSecDY1 = .T.
			EndIf
			oSec2DY1:Cell("DY1_CODPAS"):SetValue((cAliasDY1)->DY1_CODPAS)
			oSec2DY1:Cell("DT1_VALATE"):SetValue((cAliasDY1)->DT1_VALATE)
			oSec2DY1:Cell("DY1_EXCMIN"):SetValue((cAliasDY1)->DY1_EXCMIN)
			oSec2DY1:Cell("DY1_VALMIN"):SetValue((cAliasDY1)->DY1_VALMIN)		
			oSec2DY1:Cell("DY1_VALMAX"):SetValue((cAliasDY1)->DY1_VALMAX)
			oSec2DY1:Cell("DY1_VALOR"):SetValue((cAliasDY1)->DY1_VALOR)		    	
			oSec2DY1:Cell("DY1_INTERV"):SetValue((cAliasDY1)->DY1_INTERV)
			oSec2DY1:Printline()
			
			(cAliasDY1)->(DbSkip())			
		EndDo
		(cAliasDY1)->(DbCloseArea())
		RestArea(aAreaSec)	
	
		If lSecDY1 = .T.
			oSec2DY1:Finish()
			lSecDY1 = .F.
		EndIf
		
		//#############################################
		//Busca e emissão dos registros da tabela DVY #      
		//#############################################			
		aAreaSec := GetArea()
		cAliasDVY := GetNextAlias()
		cQuery := "SELECT DVY_CODPAS, DVY_DESPAS, DVY_VLBASE "
		cQuery += "  FROM " + RetSqlName("DVY")+" DVY "
		cQuery += " WHERE DVY_FILIAL = '" + (cAliasDTL)->DTL_FILIAL + "'"
		cQuery += "   AND DVY_TABFRE = '" + (cAliasDTL)->DTL_TABFRE + "'"
		cQuery += "   AND DVY_TIPTAB = '" + (cAliasDTL)->DTL_TIPTAB + "'"
		cQuery += "   AND DVY_CDRORI = '" + (cAliasDTL)->DT0_CDRORI + "'"
		cQuery += "   AND DVY_CDRDES = '" + (cAliasDTL)->DT0_CDRDES + "'"
		cQuery += "   AND DVY_CODPRO = '" + (cAliasDTL)->DT0_CODPRO + "'"
		cQuery += "   AND DVY.D_E_L_E_T_ = ' '"
		cQuery += " ORDER BY DVY_CODPAS"
		cQuery := ChangeQuery(cQuery)
		DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAliasDVY,.T.,.T.)
	
		While !(cAliasDVY)->(Eof())
			If lSecDVY = .F.
				oReport:Skipline()
				oReport:PrintText(STR0034)
				oSec2DVY:Init()
				lSecDVY = .T.
			EndIf
			oSec2DVY:Cell("DVY_CODPAS"):SetValue((cAliasDVY)->DVY_CODPAS)
			oSec2DVY:Cell("DVY_DESPAS"):SetValue((cAliasDVY)->DVY_DESPAS)
			oSec2DVY:Cell("DVY_VLBASE"):SetValue((cAliasDVY)->DVY_VLBASE)		
			oSec2DVY:Printline()
			
			(cAliasDVY)->(DbSkip())			
		EndDo
		(cAliasDVY)->(DbCloseArea())
		RestArea(aAreaSec)	
	
		If lSecDVY = .T.
			oSec2DVY:Finish()
			lSecDVY = .F.
		EndIf		

		//#############################################
		//Busca e emissão dos registros da tabela DJS #      
		//#############################################			
		aAreaSec := GetArea()
		cAliasDJS := GetNextAlias()
		cQuery := "SELECT DJS_CODPAS, DJS_CODTRT, DJS_PERCEN "
		cQuery += "  FROM " + RetSqlName("DJS")+" DJS "
		cQuery += " WHERE DJS_FILIAL = '" + (cAliasDTL)->DTL_FILIAL + "'"
		cQuery += "   AND DJS_TABFRE = '" + (cAliasDTL)->DTL_TABFRE + "'"
		cQuery += "   AND DJS_TIPTAB = '" + (cAliasDTL)->DTL_TIPTAB + "'"
		cQuery += "   AND DJS_CDRORI = '" + (cAliasDTL)->DT0_CDRORI + "'"
		cQuery += "   AND DJS_CDRDES = '" + (cAliasDTL)->DT0_CDRDES + "'"
		cQuery += "   AND DJS_CODPRO = '" + (cAliasDTL)->DT0_CODPRO + "'"
		cQuery += "   AND DJS.D_E_L_E_T_ = ' '"
		cQuery += " ORDER BY DJS_CODPAS"
		cQuery := ChangeQuery(cQuery)
		DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAliasDJS,.T.,.T.)
	
		While !(cAliasDJS)->(Eof())
			If lSecDJS = .F.
				oReport:Skipline()
				oReport:PrintText(STR0036)
				oSec2DJS:Init()
				lSecDJS = .T.
			EndIf
			oSec2DJS:Cell("DJS_CODPAS"):SetValue((cAliasDJS)->DJS_CODPAS)
			oSec2DJS:Cell("DJS_CODTRT"):SetValue((cAliasDJS)->DJS_CODTRT)
			oSec2DJS:Cell("DJS_PERCEN"):SetValue((cAliasDJS)->DJS_PERCEN)		
			oSec2DJS:Printline()
			
			(cAliasDJS)->(DbSkip())			
		EndDo
		(cAliasDJS)->(DbCloseArea())
		RestArea(aAreaSec)	
	
		If lSecDJS = .T.
			oSec2DJS:Finish()
			lSecDJS = .F.
		EndIf		

		//################################
		//Fechamento das seções iniciais #      
		//################################
		oSec2DVE:Finish()
		oSec1DTL:Finish()
		nCntRegs := 0
	Else
		nCntRegs += 1
	EndIf		
	
	cDTL_FIL  := (cAliasDTL)->DTL_FILIAL   
	cDTL_TAB  := (cAliasDTL)->DTL_TABFRE
	cDTL_TIP  := (cAliasDTL)->DTL_TIPTAB
	cDT0_ORI  := (cAliasDTL)->DT0_CDRORI
	cDT0_DES  := (cAliasDTL)->DT0_CDRDES
	cDVE_COD  := (cAliasDTL)->DVE_CODPAS		
	cDT0_PRD  := (cAliasDTL)->DT0_CODPRO
	cDT1_ITE  := (cAliasDTL)->DT1_ITEM
	cDW1_ITE  := (cAliasDTL)->DW1_ITEM	
	
	(cAliasDTL)->(DbSkip())
Enddo

(cAliasDTL)->(DbCloseArea())
RestArea(aAreaRep)

Return
