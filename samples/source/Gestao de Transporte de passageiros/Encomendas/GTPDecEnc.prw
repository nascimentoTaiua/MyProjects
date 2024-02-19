#INCLUDE "TOTVS.ch"
#include "rwmake.ch"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"

//-----------------------------------------------------------------------------
/*/{Protheus.doc} GTPDecEnc
Imprime declaração de transporte de encomendas
@author  gustavo.silva2
@since   23/09/2019
@version 1.0
/*/
//-----------------------------------------------------------------------------
User Function GTPDecEnc()

Local oReport
		
oReport := ReportDef()
oReport:PrintDialog()

Return

//-----------------------------------------------------------------------------
/*/{Protheus.doc} ReportDef
Definição do relatório
@author  gustavo.silva2
@since   23/09/2019
@version 1.0
/*/
//-----------------------------------------------------------------------------
Static Function ReportDef()

Local cTitle   	:= "Declaração para Transporte de Mercadoria"  
Local cHelp    	:= "Declaração para Transporte de Mercadoria"  

oReport := TReport():New('GTPDecEnc',cTitle,,{|oReport|ReportPrint(oReport)},cHelp,/*lLandscape*/,/*uTotalText*/,.T.,/*cPageTText*/,.F./*lPageTInLine*/,/*lTPageBreak*/,/*nColSpace*/)
oReport:SetPortrait(.T.)
oReport:nFontBody := 12
oReport:SetTotalInLine(.F.)

Return oReport

/*/{Protheus.doc} ReportPrint
Processamento dos dados
@type function
@author gustavo.silva2
@since 18/02/2019
@version 1.0
@param oReport, objeto, (Descrição do parâmetro)
@param cAliasFix, character, (Descrição do parâmetro)
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static Function ReportPrint(oReport)

Local oFnt22  := TFont():New( "Arial" ,,22,,.T.,,,,,.F. )
Local oFnt16  := TFont():New( "Arial" ,,16,,.T.,,,,,.F. )
Local oNFnt16  := TFont():New( "Arial" ,,16,,.F.,,,,,.F. )
Local cEmpresa:= FWFilialName(,cFilAnt)//"Nome da empresa/Filial"

oReport:Say(0400,0600,"Declaração para transporte de mercadoria", oFnt22)

oReport:Say(600,100,"Declaro para os devidos fins, e sob as penas legais que entregamos à " + cEmpresa,oNFnt16)
oReport:Say(700,100,"os produtos relacionados abaixo para transporte até o destinatário informado nesta declaração. As mercadorias são particulares,", oNFnt16)
oReport:Say(800,100," sem valor comercial e não requer emissão de nota fiscal, dada sua natureza ou minha condição de não contribuinte. ",oNFnt16)
oReport:Say(900,100,"Declaro não havermercadorias ilegais, visto que o conteúdo da mercadoria é inteiramente de responsabilidade do contratante.",oNFnt16)

oReport:Say(1100,100, "REMETENTE: ",oFnt16)

oReport:Say(1200,0100, "Nome: ",oNFnt16)
oReport:Line(1250, 0400, 1250, 1600)

oReport:Say(1300,0100, "Endereço: ",oNFnt16)
oReport:Line(1350, 0400, 1350, 1600)

oReport:Say(1400,0100, "Cidade: ",oNFnt16)
oReport:Line(1450, 0400, 1450, 1600)

oReport:Say(1500,0100, "Cnpj/Cpf: ",oNFnt16)
oReport:Line(1550, 0400, 1550, 1600)

oReport:Say(1600,0100, "DESTINATÁRIO: ",oFnt16)

oReport:Say(1700,0100, "Nome: ",oNFnt16)
oReport:Line(1750, 0400, 1750, 1600)

oReport:Say(1800,0100, "Endereço: ",oNFnt16)
oReport:Line(1850,0400, 1850, 1600)

oReport:Say(1900,0100, "Cidade: ",oNFnt16)
oReport:Line(1950, 0400, 1950, 1600)

oReport:Say(2000,0100, "Cnpj/Cpf: ",oNFnt16)
oReport:Line(2050, 0400, 2050, 1600)

oReport:Say(2100,0100, "MERCADORIA: ",oFnt16)
// Tabela da mercadoria
oReport:Box(2200, 0100,2500, 2300) //Box completo
oReport:Box(2200, 0100,2300, 2300) //Box cabeçalho

oReport:Box(2200, 0100,2500, 0500)
oReport:Say(2200, 0110, "Volumes: ",oFnt16)

oReport:Box(2200, 0500,2500, 0900)
oReport:Say(2200,0510, "Peso: ",oFnt16)

oReport:Box(2200, 0900,2500, 1800)
oReport:Say(2200, 0910, "Observação: ",oFnt16)

oReport:Box(2200, 1800,2500, 2300)
oReport:Say(2200, 1810, "Frete: ",oFnt16)
// Combo box dentro do Frete
oReport:Box(2330, 1850,2380, 1900)
oReport:Say(2330, 1900, " Remetente",oNFnt16)
oReport:Box(2390, 1850,2440, 1900)
oReport:Say(2390, 1900, " Destinatário",oNFnt16)

//Campo de data
oReport:Line(2700, 0900, 2700, 1600)
oReport:Say(2650, 1610, "de ",oFnt16)
oReport:Line(2700, 1660, 2700, 2040)
oReport:Say(2650, 2040, "de ",oFnt16)
oReport:Line(2700, 2100, 2700, 2300)

//Assisnatura
oReport:Line(2900, 1400, 2900, 2300)
oReport:Say(2900, 1700, "Nome e Assinatura",oFnt16)

Return