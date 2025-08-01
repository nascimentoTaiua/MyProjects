#INCLUDE "Protheus.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "PLSMGER.CH"
#INCLUDE "TCBROWSE.CH"
#Include "RwMake.ch"
#Include "MsOle.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "FWPrintSetup.ch"

Static objCENFUNLGP := CENFUNLGP():New() 


//Refer�ncias
//http://tdn.totvs.com.br/display/public/mp/FWMsPrinter
//http://tdn.totvs.com.br/display/tec/TFont
 
//-------------------------------------------------------------------
/*/{Protheus.doc} PLSQTDEB
Funcao de usu�rio para imprimir o Relat�rio de Quiota��o de D�bitos em PDF
@author Oscar Zanin
@since 16/11/2015
@version P12
/*/
//-------------------------------------------------------------------
User Function PLSQTDEB()

/*
nI	= contador da fun��o que chama esta
 
lPortal = Indi

Formato do aDados
aDados[1] = Cidade
aDados[2] = Estado
aDados[3] = Data
aDados[4] = Nome Benefici�rio
aDados[5] = Nome do benefici�rio + Tratamento (Sr/Sra)
aDados[6] = CPF/CNPJ
aDados[7] = Ano refer�ncia
aDados[8] = Telefone de contato - central de atendimento
aDados[9] = N�o utilizado -> mantido para compatibilidade com a rotina .DOT
aDados[10] = Operadora

Formato do aFinan
aFinan[nI][12] = Data do vencimento
aFinan[nI][13] = Valor do t�tulo
aFinan[nI][14] = Saldo restante
aFinan[nI][15] = Situa��o do t�tulo
*/
Local oReport  := NIL
Local nJ := 1
Local nAltura := 0
Local cWebOut := paramixb[5]
Local lPortal := paramixb[2]
Local aDados := paramixb[3]
Local aFinan := paramixb[4]
Local cOper	:= paramixb[3,10]
Local nTop	:= 30
Local nLeft	:= 20
Local nTamanho := 45
Local aBMP	:= {"lgesqrl.bmp"}
Local cLogo := "lgesqrl"


//Local onde o arquivo ser� gerado
Local cDirArq	 := '/web/PP/imagens-pls/relatorios'
 
//Os objetos abaixo definem a fonte a ser utilizada, os par�metros s�o:
//cName = nome da fonte a ser utilizada				- Caractere
//os parametros uParX n�o s�o utilizados				- Nil, ou n�o utilizar
//lBold = define se o texto ser� em Negrito			- L�gico
//lUnderline = define se o texto ser� Sublinhado		- L�gico
//lItalic = define se o texto ser� em It�lico			- L�gico

//TFont(): New ( [ cName], [ uPar2], [ nHeight], [ uPar4], [ lBold], [ uPar6], [ uPar7], [ uPar8], [ uPar9], [ lUnderline], [ lItalic] ) --> oObjeto
Local oFnt10N 	:= TFont():New("Arial",,10,.T.,.f., , , , .F., .f.)
Local oFnt14N		:= TFont():New("Arial",,18,.T.,.t., , , , .t., .f.)
Local oFnt10C 	:= TFont():New("Arial",,10,.F.,.f., , , , .F., .f.)

//Nome do arquivo que ser� gerado
Local cNomArq  := "quitacao_"+AllTrim(Str(Day(Date()))) + "_" + Alltrim(Str(month(date()))) + "_" + ( Alltrim(Str(Year(date()))) ) + "_" +;
                     Left(Time(),2) + "_" + Substr(Time(),4,2) + "_" + Right(Time(),2) 


//cArqName � uma vari�vel Private da fun��o que chama o relat�rio na web, � necess�rio atualizar ela para que
//o relat�rio seja exibido no portal.
FWLogMsg('WARN',, 'SIGAPLS', funName(), '', '01', lPortal , 0, 0, {})
If lPortal
	cArqName := cNomArq + ".pdf"
	cDirArq  := cWebOut
EndIf



//o Objeto oReport � o objeto do pr�prio relat�rio
//Principais par�metros:
//cFilePrintert = nome do arquivo que ser� gerado (sem a extens�o)						- Caractere
//nDevice = dispositivo padr�o da impress�o, IMP_PDF gera o arquivo em .pdf			- Num�rico
//cPathInServer = Local (no servidor) onde ser�o armazenados os arquivos gerados		- Caractere

//FWMsPrinter(): New ( < cFilePrintert >, [ nDevice], [ lAdjustToLegacy], [ cPathInServer], [ lDisabeSetup ], [ lTReport], [ @oPrintSetup], [ cPrinter], [ lServer], [ lPDFAsPNG], [ lRaw], [ lViewPDF], [ nQtdCopy] ) 
oReport := FWMSPrinter():new(cNomArq /*cFilePrintert*/, IMP_PDF /*nDevice*/, .F. /*lAdjustToLegacy*/ ,cDirArq /*cPathInServer*/ , lPortal /*lDisabeSetup*/, /*lTReport*/, /*oPrintSetup*/, /*cPrinter*/, .T. /*lServer*/, /*lPDFAsPNG*/, /*lRaw*/, /*!lPortal*/ .T. /*lViewPDF*/, /*nQtdCopy*/) 
oReport:setDevice(IMP_PDF)
oReport:StartPage() //Inicia p�gina

objCENFUNLGP:setAlias("BA0")

BA0->(dbSetOrder(2)) 
BA0->(MsSeek(xFilial("BA0")+ cOper))

oReport:setResolution(72)
oReport:setPortrait() //Define orienta��o da p�gina
oReport:SetPaperSize(9) //define tipo de papel para impress�o
oReport:setMargin(35,15,05,05)

if !lPortal //Se veio do portal n�o pode exibir o Setup de impress�o do Protheus
	oReport:Setup()
EndIf

//O m�todo Say p�e a informa��o dentro da p�gina, cada Say gera uma linha
//Os par�metros s�o:
//1� - Posi��o vertical do texto, sendo Zero o Topo				- Num�rico
//2� - Posi��o horizontal do texto, sendo Zero a Esquerda		- Num�rico
//3� - O texto a ser apresentado									- Caractere
//4� - O objeto que define a fonte que o texto ser� gerado		- Objeto
//say( 1�, 2�, 3�, 4�)

//FWMsPrinter(): Say ( < nRow>, < nCol>, < cText>, [ oFont], [ nWidth], [ nClrText], [ nAngle] )

//Insere Logo
If FindFunction("PlLogoImp")
	PlLogoImp(oReport, nTop, nLeft, aBMP, cLogo, nTamanho, nAltura,Nil,Nil,Nil, oFnt10N, objCENFUNLGP)
	nAltura += 100
Else
	nAltura += 60
EndIf

oReport:say(nAltura, 20, aDados[1]+" - " + aDados[2] + ", " + aDados[3], oFnt10N) //, /*oFont*/, /*nWidth*/, /*nHeigth*/, /*nClrText*/, 2, 0/*nAlignVert*/)

nAltura += 30
oReport:say(nAltura, 20, "Ao Cliente", oFnt10C)

nAltura += 30
oReport:say(nAltura, 20, aDados[4], oFnt10N)

nAltura += 35
oReport:Say(nAltura, 20, "DECLARA��O ANUAL DE QUITA��O DE D�BITOS", oFnt14N)

nAltura += 30
oReport:say(nAltura, 20, "Prezado cliente", oFnt10C)

nAltura += 20
oReport:say(nAltura, 20, aDados[5] + ", inscrito (a) no " + aDados[6] + ", pelo ", oFnt10C)

nAltura += 20
oReport:say(nAltura, 20, "presente instrumento, em cumprimento � Lei Federal n� 12.007/2009, DECLARA A QUITA��O ", oFnt10C)

nAltura += 20
oReport:say(nAltura, 20, "das faturas, n�o existindo qualquer valor pendente, de vencimentos referentes ao ano de " + aDados[7] + ".", oFnt10C)

nAltura += 20
oReport:say(nAltura, 20, "A presente declara��o substitui, para a comprova��o do cumprimento das obriga��es do ", oFnt10C)

nAltura += 20
oReport:say(nAltura, 20, "consumidor, as quita��es dos faturamentos mensais dos d�bitos referentes ao ano de " + aDados[7] + ".", oFnt10C)

nAltura += 20
oReport:say(nAltura, 20, "Solicitamos, por gentileza, caso restem d�vidas a respeito do tema, permanecemos � ", oFnt10C)

nAltura += 20
oReport:say(nAltura, 20, "disposi��o atrav�s da nossa Central de Relacionamento com Cliente, no n�mero " + aDados[8] + ".", oFnt10C)

nAltura += 30
oReport:say(nAltura, 20, "VENCTO:                  VALOR:                        SALDO:                 SITUA��O:", oFnt10N)

For nJ := 1 To Len (aFinan)
	nAltura += 15
	oReport:say(nAltura, 20, AllTrim(DToC(aFinan[nJ,12])) + SPACE(31 - Len(AllTrim(Transform(aFinan[nJ,14], "@E 999,999,999.99")))) + AllTrim(Transform(aFinan[nJ,14], "@E 999,999,999.99")) + Space(34 - Len(AllTrim(Transform(aFinan[nJ,13], "@E 999,999,999.99"))) ) + AllTrim(Transform(aFinan[nJ,13], "@E 999,999,999.99")) + Space(15) + AllTrim(IIF(aFinan[nJ,15]=="B","T�TULO PAGO","EM ABERTO")), oFnt10N )
Next

nAltura += 30
oReport:say(nAltura, 20, "Atenciosamente, ", oFnt10C)

nAltura += 15
oReport:say(nAltura, 20, aDados[10], oFnt10N)

oReport:EndPage() //Finaliza p�gina

oReport:Print() //Cria impress�o

//Retorno altrado para array

Return({.T.,cDirArq,cArqName}) 