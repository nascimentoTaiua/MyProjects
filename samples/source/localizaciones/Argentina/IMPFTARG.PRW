#INCLUDE "PROTHEUS.CH"
#INCLUDE "FONT.CH"
#INCLUDE "IMPFTARG.CH"

#DEFINE nTop		40
#DEFINE nLeft		65
#DEFINE DOC		1
#DEFINE SERIE		2
#DEFINE CLIENTE	3
#DEFINE LOJA		4
#DEFINE EMISSAO	5
#DEFINE ESPECIE	6
#DEFINE CONDPAG	7
#DEFINE DESCPAG	8 
#DEFINE VENCTO	9
#DEFINE PEDCLI	9
#DEFINE CODCLI	10
#DEFINE FECPED	11
#DEFINE VENDPED	12
#DEFINE TXMOEDA	13
#DEFINE CAE		14
#DEFINE VCTOCAE	15
#DEFINE MOEDA	16
#DEFINE VALMERC	28
#DEFINE VALBRUT	29
#DEFINE DESCONT	30
#DEFINE LCAI		32


/* ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
   ฑฑณPrograma  ณ IMPFTARG ณ Autor ณ Galvao Carlos         ณ Data ณ30/04/2015ณฑฑ
   ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
   ฑฑณDescricao ณLayout NF,NC,ND(FACTURA-NOTA-CREDITO-NOTA DEBITO) Salida PDFณฑฑ
   ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
   ฑฑณParametrosณ                                                            ณฑฑ
   ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ*/

USER FUNCTION IMPFTARG(lD,cL)

	Local oDlg    		:= NIL
	Local cTM      		:= ""
	Local nTipFac		:= 0
	Local nFormPro		:= 0
	Local nEmiAPrv  	:= 0
	Private lDibuja 	:= lD
	Private cTitulo  	:= STR0001 + DtoS(dDataBase) + SubStr(TIME(),1,2) + SubStr(TIME(),4,2) + SubStr(TIME(),7,2) 
	Private oPrn     	:= NIL
	Private cPerg    	:= "IMPFTARG"
	Private cQryCab  	:= GetNextAlias()
	Private cQryDet  	:= GetNextAlias()
	Private aCabec   	:= {}
	Private aObserv 	:= {}
	Private aSocios 	:= {}
	Private aItem   	:= {}
	Private aCli    	:= {}
	Private aItos    	:= {}
	Private aAda     	:= {}
	Private aLeyen   	:= {}
	Private aDesNCND	:= {}
	Private aDetItem 	:= {}
	Private aDet	 	:= {}
	Private lPrinted  	:= .F.,;
		lAuto     		:= .F.,;
		nReg      		:= 0
	Private cCae		:= ""
	Private cVtoCae		:= ""
	Private cEspecie	:= ""
	Private lCai		:= .T.
	Private cLogo   	:= cL
	Private cTipoNF   	:= ""
	Private cDir		:= GETNEWPAR("MV_FATPDF", AllTrim(STR0002)) 
	Private lBuF3  		:= GETNEWPAR("TO_BUIMPUF3", .F.)

	Private oFontA06  	:= TFont():New( "Arial      ",,6,,.T.,,,,,.F. )
	Private oFontCB06  	:= TFont():New( "Arial      ",,6,,.F.,,,,,.F. )
	Private oFontA07 	:= TFont():New( "Arial      ",,7,,.T.,,,,,.F. )
	Private oFontCB07  	:= TFont():New( "Arial      ",,7,,.F.,,,,,.F. )
	Private oFontA08  	:= TFont():New( "Arial      ",,8,,.T.,,,,,.F. )
	Private oFontCB08  	:= TFont():New( "Arial      ",,8,,.F.,,,,,.F. )
	Private oFCouri08B  := TFont():New( "Courier New",,8,,.T.,,,,,.F. )
	Private oFCouri08  	:= TFont():New( "Courier New",,8,,.F.,,,,,.F. )
	Private oFontA09  	:= TFont():New( "Arial      ",,9,,.T.,,,,,.F. )
	Private oFontCB09  	:= TFont():New( "Arial      ",,9,,.F.,,,,,.F. )
	Private oFontA10  	:= TFont():New( "Arial      ",,10,,.T.,,,,,.F. )
	Private oFontCB10  	:= TFont():New( "Arial      ",,10,,.F.,,,,,.F. )
	Private oFCouri10B  := TFont():New( "Courier New",,10,,.T.,,,,,.F. )
	Private oFCouri10  	:= TFont():New( "Courier New",,10,,.F.,,,,,.F. )
	Private oFontA11  	:= TFont():New( "Arial      ",,11,,.T.,,,,,.F. )
	Private oFontCB11  	:= TFont():New( "Arial      ",,11,,.F.,,,,,.F. )
	Private oFontA12  	:= TFont():New( "Arial      ",,12,,.T.,,,,,.F. )
	Private oFontCB12  	:= TFont():New( "Arial      ",,12,,.F.,,,,,.F. )
	Private oFontA14  	:= TFont():New( "Arial      ",,14,,.T.,,,,,.F. )
	Private oFontCB14  	:= TFont():New( "Arial      ",,14,,.F.,,,,,.F. )
	Private oFontA16  	:= TFont():New( "Arial      ",,18,,.T.,,,,,.F. )
	Private oFontCB20  	:= TFont():New( "Arial      ",,20,,.T.,,,,,.F. )
	Private oFontCBXX  	:= TFont():New( "I2OF5TXT",,20,,.F.,,,,,.F. )
	Private oFont2		:= TFont():New( "Courier New",,8,,.F.,,,,,.F. )
    Private lQRAFIP     := GetNewPar("MV_FATQRCO",.F.)//Habilita QR en layout de ventas, en caso contrario aparece codigo de barras

	if (lDibuja  == NIL)
		lDibuja := .T.
	Endif

	If (cLogo == NIL)
		cLogo := AllTrim(STR0004) //* "lgrl99.bmp" //*"lgrl"+SM0->M0_CODIGO+alltrim(SM0->M0_CODFIL)+".bmp" 
	Endif

	Makedir(AllTrim(STR0003)) 
	Makedir(AllTrim(STR0002)) 

	IF FUNNAME() == "MATA465N"

		oPrn := FWMSPrinter():New( cTitulo + AllTrim(STR0006),6,.T., , .T.) 
		
		oPrn:SetPage(9)  //Hoja A4
		oPrn:SetPortrait()
		cDir := iif(right(cDir,1) != "\",cDir+"\",cDir)
		oPrn:cPathPDF := cDir
		oPrn:CPrinter := AllTrim(STR0007) 
		oPrn:Setup()
		
		// Me traigo de nuevo las preguntas MTA465N para levantar el tipo de factura
		Pergunte("MT465N", .F.)
		nFormPro:= MV_PAR01
		nTipFac := MV_PAR02
		//luego repongo las preguntas que deberian estar
		If Pergunte(cPerg, .F.)
			lAuto := .T.
			IF nFormPro == 1	// Si es formulario propio
				IF nTipFac == 1	// Debito
					nReg := SF2->(recno())
					IF SF2->F2_ESPECIE == 'NF   '
						MV_PAR01 := 1
					EndIF
					IF SF2->F2_ESPECIE == 'NDC  ' .OR. SF2->F2_ESPECIE == 'NDI  '
						MV_PAR01 := 2
					EndIF
					IF SF2->F2_ESPECIE == 'NCC  ' .OR. SF2->F2_ESPECIE == 'NCI  '
						MV_PAR01 := 3
					EndIF

					MV_PAR02 = SF2->F2_DOC		// Desde Documento
					MV_PAR03 = SF2->F2_DOC		// Hasta Documento
					MV_PAR04 = SF2->F2_SERIE		// Desde Serie
					MV_PAR05 = SF2->F2_SERIE		// Hasta Serie
					MV_PAR06 = SF2->F2_EMISSAO	// Desde Fecha
					MV_PAR07 = SF2->F2_EMISSAO	// Hasta Fecha
					MV_PAR08 = SF2->F2_CLIENTE		// Desde Cliente
					MV_PAR09 = SF2->F2_LOJA		// Desde Tienda
					MV_PAR10 = SF2->F2_CLIENTE		// Hasta Cliente
					MV_PAR11 = SF2->F2_LOJA		// Hasta Tienda
					MV_PAR12 = 1					// Copias
				Else	// Credito
					nReg := SF1->(recno())
					IF SF1->F1_ESPECIE == 'NF   '
						MV_PAR01 := 1
					EndIF
					IF SF1->F1_ESPECIE == 'NDC  ' .OR. SF1->F1_ESPECIE == 'NDI  '
						MV_PAR01 := 2
					EndIF
					IF SF1->F1_ESPECIE == 'NCC  ' .OR. SF1->F1_ESPECIE == 'NCI  '
						MV_PAR01 := 3
					EndIF

					MV_PAR02 = SF1->F1_DOC		// Desde Documento
					MV_PAR03 = SF1->F1_DOC		// Hasta Documento
					MV_PAR04 = SF1->F1_SERIE		// Desde Serie
					MV_PAR05 = SF1->F1_SERIE		// Hasta Serie
					MV_PAR06 = SF1->F1_EMISSAO	// Desde Fecha
					MV_PAR07 = SF1->F1_EMISSAO	// Hasta Fecha
					MV_PAR08 = SF1->F1_FORNECE	// Desde Cliente
					MV_PAR09 = SF1->F1_LOJA		// Desde Tienda
					MV_PAR10 = SF1->F1_FORNECE	// Hasta Cliente
					MV_PAR11 = SF1->F1_LOJA		// Hasta Tienda
					MV_PAR12 = 1					// Copias
				EndIf
				Imprimir()
				
				oPrn:EndPage()
				
			Else
				Alert(AllTrim(STR0005)) 
			EndIf

			
		EndIf
	EndIf

	IF FUNNAME() == "MATA466N"
		oPrn := FWMSPrinter():New( cTitulo + AllTrim(STR0006),6,.T., , .T.) 
		
		oPrn:SetPage(9)  //Hoja A4
		oPrn:SetPortrait()
		cDir := iif(right(cDir,1) != "\",cDir+"\",cDir)
		oPrn:cPathPDF := cDir
		oPrn:CPrinter := AllTrim(STR0007)
		oPrn:Setup()
		// Me traigo de nuevo las preguntas MTA466N para levantar el tipo de factura
		Pergunte("MT466N", .F.)
		nFormPro	:= MV_PAR01
		nTipFac 	:= MV_PAR02
		nEmiAPrv	:= MV_PAR04
		//luego repongo las preguntas que deberian estar
		If Pergunte(cPerg, .F.)
			lAuto := .T.
			IF nFormPro == 1	// Si es formulario propio
				IF nTipFac == 2	// Credito
					nReg := SF1->(recno())
					IF SF1->F1_ESPECIE == 'NF   '
						MV_PAR01 := 1
					EndIF
					IF SF1->F1_ESPECIE == 'NDC  ' .OR. SF1->F1_ESPECIE == 'NDI  ' .OR. SF1->F1_ESPECIE == 'NDP  '
						MV_PAR01 := 2
					EndIF
					IF SF1->F1_ESPECIE == 'NCC  ' .OR. SF1->F1_ESPECIE == 'NCI  ' .OR. SF1->F1_ESPECIE == 'NCP  '
						MV_PAR01 := 3
					EndIF
					MV_PAR01 := 3					// Para NCI
					MV_PAR02 := SF1->F1_DOC		// Desde Documento
					MV_PAR03 := SF1->F1_DOC		// Hasta Documento
					MV_PAR04 := SF1->F1_SERIE		// Desde Serie
					MV_PAR05 := SF1->F1_SERIE		// Hasta Serie
					MV_PAR06 := SF1->F1_EMISSAO	// Desde Fecha
					MV_PAR07 := SF1->F1_EMISSAO	// Hasta Fecha
					MV_PAR08 := SF1->F1_FORNECE	// Desde Cliente
					MV_PAR09 := SF1->F1_LOJA		// Desde Tienda
					MV_PAR10 := SF1->F1_FORNECE	// Hasta Cliente
					MV_PAR11 := SF1->F1_LOJA		// Hasta Tienda
					MV_PAR12 := 1					// Copias
					Imprimir()
					
					oPrn:EndPage()
				EndIF
				IF nTipFac == 1	// Debito
					IF SF2->F2_ESPECIE == 'NF   '
						MV_PAR01 := 1
					EndIF
					IF SF2->F2_ESPECIE == 'NDC  ' .OR. SF2->F2_ESPECIE == 'NDI  ' .OR. SF2->F2_ESPECIE == 'NDP  '
						MV_PAR01 := 2
					EndIF
					IF SF2->F2_ESPECIE == 'NCC  ' .OR. SF2->F2_ESPECIE == 'NCI  ' .OR. SF2->F2_ESPECIE == 'NCP  '
						MV_PAR01 := 3
					EndIF
					nReg := SF2->(recno())
					MV_PAR01 := 2					// Para NCI
					MV_PAR02 = SF2->F2_DOC		// Desde Documento
					MV_PAR03 = SF2->F2_DOC		// Hasta Documento
					MV_PAR04 = SF2->F2_SERIE		// Desde Serie
					MV_PAR05 = SF2->F2_SERIE		// Hasta Serie
					MV_PAR06 = SF2->F2_EMISSAO	// Desde Fecha
					MV_PAR07 = SF2->F2_EMISSAO	// Hasta Fecha
					MV_PAR08 = SF2->F2_CLIENTE		// Desde Cliente
					MV_PAR09 = SF2->F2_LOJA		// Desde Tienda
					MV_PAR10 = SF2->F2_CLIENTE		// Hasta Cliente
					MV_PAR11 = SF2->F2_LOJA		// Hasta Tienda
					MV_PAR12 = 1					// Copias
					Imprimir()
					
					oPrn:EndPage()
					
				EndIF
			EndIF

			
		Endif
	EndIF

	IF FUNNAME() == "MATA467N"
		oPrn := FWMSPrinter():New( cTitulo + AllTrim(STR0006),6,.T., , .T.)
		
		oPrn:SetPage(9)  //Hoja A4
		oPrn:SetPortrait()
		cDir := iif(right(cDir,1) != "\",cDir+"\",cDir)
		oPrn:cPathPDF := cDir
		oPrn:CPrinter := AllTrim(STR0007)

		oPrn:Setup()
		
		If Pergunte( cPerg,.F.)
			lAuto := .T.
			nReg := SF2->(recno())
			IF SF2->F2_ESPECIE == 'NF   '
				MV_PAR01 := 1
			EndIF
			IF SF2->F2_ESPECIE == 'NDC  ' .OR. SF2->F2_ESPECIE == 'NDI  '  .OR. SF2->F2_ESPECIE == 'NDP  '
				MV_PAR01 := 2
			EndIF
			IF SF2->F2_ESPECIE == 'NCC  ' .OR. SF2->F2_ESPECIE == 'NCI  ' .OR. SF2->F2_ESPECIE == 'NCP  '
				MV_PAR01 := 3
			EndIF

			MV_PAR02 = SF2->F2_DOC		// Desde Documento
			MV_PAR03 = SF2->F2_DOC		// Hasta Documento
			MV_PAR04 = SF2->F2_SERIE		// Desde Serie
			MV_PAR05 = SF2->F2_SERIE		// Hasta Serie
			MV_PAR06 = SF2->F2_EMISSAO	// Desde Fecha
			MV_PAR07 = SF2->F2_EMISSAO	// Hasta Fecha
			MV_PAR08 = SF2->F2_CLIENTE		// Desde Cliente
			MV_PAR09 = SF2->F2_LOJA		// Desde Tienda
			MV_PAR10 = SF2->F2_CLIENTE		// Hasta Cliente
			MV_PAR11 = SF2->F2_LOJA		// Hasta Tienda
			MV_PAR12 = 1					// Copias
			Imprimir()

			oPrn:EndPage()
		Endif
	EndIF

	IF !lAuto
		IF Pergunte( cPerg,.T.)

			oPrn := FWMSPrinter():New( cTitulo + AllTrim(STR0006),6,.T., , .T.) 
			
			oPrn:SetPage(9)  //Hoja A4
			oPrn:SetPortrait()
			cDir := iif(right(cDir,1) != "\",cDir+"\",cDir)
			oPrn:cPathPDF := cDir
			oPrn:CPrinter := AllTrim(STR0007) 

			oPrn:Setup()
			
			Imprimir()

			oPrn:EndPage()

		EndIF
	EndIF
If  ValType(oPrn) == "O" .and. !Empty(oPrn)
	oPrn:Preview()
Endif

Return

/* ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
   ฑฑบPrograma  ณImprimir  บAutor  ณ Carlos Galvao      บFecha ณ  30/04/15   บฑฑ
   ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
   ฑฑบDesc.     ณ Arma la estructura del Layout dividido en 3 partes         บฑฑ
   ฑฑบ          ณ Cabecera, Cuerpo y Pie                                     บฑฑ
   ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
   ฑฑบUso       ณ AP                                                         บฑฑ
   ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ*/
STATIC FUNCTION Imprimir()

	Local aArea     := GetArea()
	Local lRet		:= .F.
    Local nIdx:=0
    Local nCopies:=0
	Private nTope  	:= oPrn:nHorzRes() - 200
	Private nIniX   := nLeft
	Private nIniY   := nTop
	Private nAlto   := oPrn:nVertRes() - 130
	Private nMedio 	:= ((nTope-nIniX)/2) + nIniX
	Private nHojas 	:= 0
	Private _nTotal	:= 0
	Private _nMonNG := 0
	Private _nMonGr := 0
	Private aRayas 	:= {}
	Private aTitCab	:= {}

	If CargaDatos() // funcion que cargos los arrays necesarios para imprimirlos luego
		For nIdx := 1 TO Len(aCabec)
			If Len(aItem[nIdx]) > 0
				For nCopies := 1 TO MV_PAR12
					nHojas   := 0
					_nTotal  := 0
					_nValImp := 0
					_nMonNG  := 0
					_nMonGr  := 0
					oPrn:StartPage()
					ImpEstruc(nIdx) 	// Imprime el esqueleto del cuerpo del layout
					ImpHeader(nIdx) 	// Imprime datos de encabezado
					ImpBody(nIdx, nCopies)   	// Imprime items
					ImpTrailer(nIdx,nCopies)
					oPrn:EndPage()
				Next nCopies
			EndIf
		Next nIdx
	Endif
	Ms_Flush()

	RestArea(aArea)
Return

/*ฑษออออออออออัอออออออออออหออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
 ฑฑบPrograma  ณCargaDatos บAutor ณ Carlos Galvao      บFecha ณ  30/04/15   บฑฑ
 ฑฑฬออออออออออุอออออออออออสออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
 ฑฑบDesc.     ณ Defide si carga los datos de FACTURA/DEBITO o CREDITO      บฑฑ
 ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
 ฑฑบUso       ณ AP                                                         บฑฑ
 ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ*/

STATIC FUNCTION CargaDatos()
	Local lRet:=.F.
	If MV_PAR01 == 1
		cEspecie := AllTrim(STR0008) 
		cDataFac()  //Factura y Debito comparten la misma tabla-
		lRet:=.T.
	Elseif  MV_PAR01 == 2
		cEspecie := AllTrim(STR0009) 
		cDataFac()  //Factura y Debito comparten la misma tabla-
		lRet:=.T.
	elseif MV_PAR01 == 3
		cEspecie := AllTrim(STR0010) 
		cDataCre() //credito
		lRet:=.T.
	Endif
Return lRet

/* ฑฑษออออออออออัอออออออออออหออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
   ฑฑบPrograma  ณ cDataFac  บAutor ณ Carlos Galvao      บFecha ณ  30/04/15   บฑฑ
   ฑฑฬออออออออออุอออออออออออสออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
   ฑฑบDesc.     ณ Carga los datos para la factura                            บฑฑ
   ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
   ฑฑบUso       ณ AP                                                         บฑฑ
   ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ*/
Static Function cDataFac()
	Local aArea    	:= GetArea()
	Local aAreaSF2 	:= SF2->(GetArea()) 
	Local aAreaSD2 := SD2->(GetArea())
	Local aAreaSE4 	:= SE4->(GetArea())
	Local aAreaSB1 	:= SB1->(GetArea())
	Local cQry1    	:= ""
	Local cClave   	:= ""
	Local cDescPrd 	:= ""
	Local cCodP    	:= ""
	Local cPedCli  	:= ""
	Local cCodCli  	:= ""
	Local xDesCPag 	:= ""
	Local lRet     	:= .F.
	Local xItem    	:= {}
	Local xImpu    	:= {}
	Local aIVA     	:= {}
	Local cRemito	:= ""
	Local nImps    	:= 0
	Local cProvincia:= ""
	Local cSitIVA 	:= ""
	Local cEAM		:= ""
	Local nZ:=0

	DbSelectArea("SX5")

	cQry1 := 	"SELECT F2_DOC,F2_SERIE,R_E_C_N_O_ SF2RECNO" + CRLF
	cQry1 +=  " FROM " + RetSqlName("SF2") + CRLF
	cQry1 += 	" WHERE F2_FILIAL = '" + xFilial("SF2") + "'" + CRLF
	cQry1 +=  " AND F2_ESPECIE IN " + cEspecie + CRLF
	cQry1 +=  " AND F2_DOC BETWEEN '" + MV_PAR02 + "' AND '" + MV_PAR03 + "'" + CRLF
	cQry1 +=  " AND F2_SERIE BETWEEN '" + MV_PAR04 + "' AND '" + MV_PAR05 + "'" + CRLF
	cQry1 +=  " AND F2_EMISSAO BETWEEN '" + Dtos(MV_PAR06) + "' AND '" + Dtos(MV_PAR07) + "'" + CRLF
	cQry1 +=  " AND F2_CLIENTE BETWEEN '" + MV_PAR08 + "' AND '" + MV_PAR10 + "'" + CRLF
	cQry1 +=  " AND F2_LOJA BETWEEN '" + MV_PAR09 + "' AND '" + MV_PAR11 + "'" + CRLF
	cQry1 +=  " AND D_E_L_E_T_ = ' '" + CRLF
	cQry1 += 	" ORDER BY F2_DOC,F2_SERIE"
	cQry1 := ChangeQuery(cQry1)
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry1), cQryCab, .F., .T.)

	DbSelectArea(cQryCab)
	DbGoTop()
	Count To nTotReg
	DbGoTop()

	While (cQryCab)->(! EOF())
		xItem    :={}
		DbSelectArea("SF2")
		DbGoTo((cQryCab)->SF2RECNO)

		xDesCPag := Posicione("SE4",1,xFilial("SE4")+SF2->F2_COND,"E4_DESCRI") // Descricao Condicao de Pagamento
		aFechasV	:=	TraeVtos(	SF2->F2_DOC	,	SF2->F2_SERIE	,	SF2->F2_CLIENTE	,	SF2->F2_LOJA	, "SF2")
			
		If !Empty(SF2->F2_CAEE)
			cCae    := SF2->F2_CAEE
			cVtoCae := SF2->F2_EMCAEE
			lCai	:= .F.
		Endif
		DbSelectArea("SA1")
		SA1->(dbSetOrder(1))
		SA1->(MsSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA))

		DbSelectArea("SF2")
		If !Empty(SA1->A1_EST)
			cProvincia := Tabela("12",SA1->A1_EST)
		EndIf
		If !Empty(SA1->A1_TIPO)
			cSitIVA := Tabela("SF",SA1->A1_TIPO )
		EndIf

		cDesPai := buDesPais(SA1->A1_PAIS)
		cCodigo := SA1->A1_COD
		cNombre := Alltrim(SA1->A1_NOME)
		cEndere	:= SA1->A1_END
		cBarrio	:= SA1->A1_BAIRRO
		cCEP	:= SA1->A1_CEP
		cMunic	:= SA1->A1_MUN
		cEstado	:= SA1->A1_EST
		cCGC	:= SA1->A1_CGC
		cPessoa	:= ""

		aAdd(aCli,{ cCodigo,;			//1
					cNombre,;			//2
					cEndere,;			//3
					cBarrio,;			//4
					cCEP,;				//5
					cMunic,;			//6
					cEstado,;			//7
					cCGC,;				//8
					cProvincia,;		//9
					cSitIVA,;			//10
					cDesPai,;			//11
					cPessoa;			//12
					};
			)

		If !lBuF3
			xImpu := armaImpu("SF2",SF2->F2_SERIE)
        else
		    xImpu := armaF3Impu("SF3",SF2->F2_SERIE,SF2->F2_DOC,SF2->F2_CLIENTE,SF2->F2_LOJA)
		endif	
			
		Aadd(aItos,xImpu)

		cClave := SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA

		SD2->(DbSetOrder(3)) // D2_FILIAL, D2_DOC, D2_SERIE, D2_CLIENTE, D2_LOJA, D2_COD, D2_ITEM
		SD2->(MsSeek(xFilial("SD2") + cClave))
		cRemito := BuRemitos(SD2->D2_DOC, SD2->D2_SERIE, SD2->D2_CLIENTE, SD2->D2_LOJA,SD2->D2_COD, SD2->D2_ITEM,.T.)

		Aadd(aCabec,{	SF2->F2_DOC,;				// 1
						SF2->F2_SERIE,;				// 2
						SF2->F2_CLIENTE,;			// 3
						SF2->F2_LOJA,;				// 4
						SF2->F2_EMISSAO,;			// 5
						SF2->F2_ESPECIE,;			// 6
						SF2->F2_COND,;				// 7
						xDesCPag,;					// 8  
						aFechasV,;					// 9
						"",;						//10
						"",;						//11
						SF2->F2_VEND1,;				//12
						SF2->F2_TXMOEDA,;			//13
						cCae,;						//14
						cVtoCae,;					//15
						SF2->F2_MOEDA,;				//16
						SF2->F2_BASIMP1,;			//17
						SF2->F2_BASIMP2,;			//18
						SF2->F2_BASIMP3,;			//19
						SF2->F2_BASIMP7,;			//20
						SF2->F2_BASIMP8,;			//21
						SF2->F2_VALIMP1,;			//22
						SF2->F2_VALIMP2,;			//23
						SF2->F2_VALIMP3,;			//24
						SF2->F2_VALIMP7,;			//25
						SF2->F2_VALIMP8,;			//26
						SF2->F2_VALIMP6,;			//27
						SF2->F2_VALMERC,;			//28
						SF2->F2_VALBRUT,;			//29
						SF2->F2_DESCONT,;			//30
						SF2->F2_FILIAL,;			//31
						lCai,;						//32
						cRemito,;					//33	
						SF2->F2_VALIMP9,;			//34
						SF2->F2_BASIMP9;      		//35
			})
			
		nTotQtd  := 0

		While SD2->(! EOF()) .And. SD2->(D2_FILIAL + D2_DOC + D2_SERIE + D2_CLIENTE + D2_LOJA) == xFilial("SD2") + cClave
			cDescPrd 	:= AllTrim(Posicione("SB1",1,xfilial("SB1") + SD2->D2_COD,"B1_DESC"))
			IF Empty(cDescPrd)
			   cDescPrd := AllTrim(STR0011) 
			ENDIF
			cEAM 		:= AllTrim(Posicione("SB1",1,xfilial("SB1")+ SD2->D2_COD,"B1_CODBAR"))
			cUm     	:= SD2->D2_UM
			nQuant  	:= SD2->D2_QUANT
			nPrcven 	:= SD2->D2_PRCVEN
			nTotal  	:= SD2->D2_TOTAL
			lRet		:= .T.
			nImps 	:= 0

			If substr(allTrim(SF2->F2_SERIE),1,1) == "B"	//Suma impuestos al item
				aIVA := buDatIVA(SD2->D2_TES) // busca las columnas que corresponden al IVA
				For nZ := 1 TO Len(aIVA)
					nImps += &("SD2->D2_VALIMP"+allTrim( CValToChar( aIVA[nZ,4] ) ) )
				Next nZ
				nTotal += nImps
				nPrcven := Round(nTotal/nQuant,TamSx3("D2_PRCVEN")[2] )
			EndIf

			aAdd(xItem,{SD2->D2_COD,;			// 1
						cDescPrd,;    			// 2
						nQuant,; 				// 3
						nPrcven,; 				// 4
						cUm,;  					// 5
						SD2->D2_ITEM,; 			// 6
						nTotal,;  				// 7
						SD2->D2_TES,;  			// 8
						SD2->D2_DOC,;			// 9
						SD2->D2_SERIE,;			// 10
						SD2->D2_CLIENTE,;		// 11
						SD2->D2_LOJA,;			// 12
						SD2->D2_ITEM,;			// 13
						SD2->D2_NUMSERI,;		// 14  
						cEAM;               	 //15
				})
				
			nTotQtd += nQuant
			SD2->(dbskip())
		Enddo

		xItem:=aSort(xItem,,,{ |x,y| x[6] < y[6] })

		Aadd(aItem,xItem)
		DbSelectArea(cQryCab)
		(cQryCab)->(DbSkip())
	EndDo

	RestArea(aAreaSF2)
	RestArea(aAreaSD2)
	RestArea(aAreaSE4)
	RestArea(aAreaSB1)
	RestArea(aArea)

Return lRet

/* ฑฑษออออออออออัอออออออออออหออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
   ฑฑบPrograma  ณ cDataCre  บAutor ณ Carlos Galvao      บFecha ณ  30/04/15   บฑฑ
   ฑฑฬออออออออออุอออออออออออสออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
   ฑฑบDesc.     ณ Carga los datos para nota de credito                       บฑฑ
   ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
   ฑฑบUso       ณ AP                                                         บฑฑ
   ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ*/

Static Function  cDataCre() //carga la info de la nota de Credito
	Local aArea    	:= GetArea()
	Local aAreaSF1 	:= SF1->(GetArea())
	Local aAreaSD1 := SD1->(GetArea())
	Local aAreaSA1 := SA1->(GetArea())
	Local aAreaSE4 	:= SE4->(GetArea())
	Local aAreaSB1 	:= SB1->(GetArea())
	Local cQry1    	:= ""
	Local cClave   	:= ""
	Local cDescPrd 	:= ""
	Local cEAM		:= ""
	Local cCodP    	:= ""
	Local cPedCli  	:= ""
	Local cCodCli  	:= ""
	Local xDesCPag 	:= ""
	Local lRet     	:= .F.
	Local xItem    	:= {}
	Local xImpu    	:= {}
	Local aIVA     	:= {}
	Local nImps    	:= 0
	Local cRemito	:= ""
	Local cDesPai   := buDesPais(SA1->A1_PAIS)
	Local nZ:=0

	cQry1 := 	"SELECT F1_DOC,F1_SERIE,R_E_C_N_O_ SF1RECNO"+CRLF
	cQry1 +=  " FROM " + RetSqlName("SF1") +CRLF
	cQry1 += 	" WHERE F1_FILIAL = '" + xFilial("SF1") + "'" +CRLF
	cQry1 +=  " AND F1_ESPECIE IN "+cEspecie+CRLF
	cQry1 +=  " AND F1_DOC BETWEEN '" + MV_PAR02 + "' AND '" + MV_PAR03 + "'" +CRLF
	cQry1 +=  " AND F1_SERIE BETWEEN '" + MV_PAR04 + "' AND '" + MV_PAR05 + "'" +CRLF
	cQry1 +=  " AND F1_EMISSAO BETWEEN '" + Dtos(MV_PAR06) + "' AND '" + Dtos(MV_PAR07) + "'" +CRLF
	cQry1 +=  " AND F1_FORNECE BETWEEN '" + MV_PAR08 + "' AND '" + MV_PAR10 + "'" +CRLF
	cQry1 +=  " AND F1_LOJA BETWEEN '" + MV_PAR09 + "' AND '" + MV_PAR11 + "'" +CRLF
	cQry1 +=  " AND D_E_L_E_T_ = ' '" +CRLF
	cQry1 += 	" ORDER BY F1_DOC,F1_SERIE"

	cQry1 := ChangeQuery(cQry1)
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry1), cQryCab, .F., .T.)

	DbSelectArea(cQryCab)
	DbGoTop()
	Count To nTotReg
	DbGoTop()

	While (cQryCab)->(! EOF())
		xItem := {}
		DbSelectArea("SF1")
		DbGoTo((cQryCab)->SF1RECNO)

		xDesCPag := Posicione("SE4",1,xFilial("SE4") + SF1->F1_COND,"E4_DESCRI") // Descricao Condicao de Pagamento
		aFechasV	:=	TraeVtos(	SF1->F1_DOC	,	SF1->F1_SERIE	,	SF1->F1_FORNECE	,	SF1->F1_LOJA	, "SF1")        

		If ! Empty(SF1->F1_CAEE)
			cCae    	:= SF1->F1_CAEE
			cVtoCae 	:= SF1->F1_EMCAEE		
			lCai		:= .F.
		Endif
		
		If Alltrim(SF1->F1_ESPECIE) <> 'NCI'

			DbSelectArea("SA1")
			SA1->(dbSetOrder(1))
			SA1->(MsSeek(xFilial("SA1") + SF1->F1_FORNECE + SF1->F1_LOJA))

			if !Empty(SA1->A1_EST)
				cProvincia := Tabela("12",SA1->A1_EST) 
			endif
			If !empty(SA1->A1_TIPO)
				cSitIVA := Tabela("SF",SA1->A1_TIPO ) 
			endif 
			if !Empty(SA1->A1_PAIS)
				cDesPai := buDesPais(SA1->A1_PAIS)
			endif
			
			cCodigo 	:= SA1->A1_COD
			cNombre 	:= Alltrim(SA1->A1_NOME)
			cEndere	:= SA1->A1_END
			cBarrio	:= SA1->A1_BAIRRO
			cCEP		:= SA1->A1_CEP
			cMunic	:= SA1->A1_MUN
			cEstado	:= SA1->A1_EST
			cCGC	:= SA1->A1_CGC
			cPessoa	:= SA1->A1_PESSOA
		Else
			DbSelectArea("SF1")
			SA2->(dbSetOrder(1))
			SA2->(MsSeek(xFilial("SA2") + SF1->F1_FORNECE + SF1->F1_LOJA))

			if !Empty(SA2->A2_EST)
				cProvincia := Tabela("12",SA2->A2_EST) 
			endif
			If !empty(SA2->A2_TIPO)
				cSitIVA := Tabela("SF",SA2->A2_TIPO ) 
			endif 
			if !Empty(SA2->A2_PAIS)
				cDesPai := buDesPais(SA2->A2_PAIS)
			endif

			cCodigo 	:= SA2->A2_COD
			cNombre 	:= Alltrim(SA2->A2_NOME)
			cEndere	:= SA2->A2_END
			cBarrio	:= SA2->A2_BAIRRO
			cCEP		:= SA2->A2_CEP
			cMunic	:= SA2->A2_MUN
			cEstado	:= SA2->A2_EST
			cCGC	:= SA2->A2_CGC
			cPessoa	:= ""
		Endif

		aAdd(aCli,{ cCodigo,;		//01
					cNombre,;		//02
					cEndere,;		//03
					cBarrio,;		//04
					cCEP,;			//05
					cMunic,;		//06
					cEstado,;		//07
					cCGC,;			//08
					cProvincia,;	//09
					cSitIVA,;		//10
					cDesPai,;		//11
					cPESSOA;		//12
				};
			)
			
		If (lBuF3)
			xImpu := armaImpu("SF1",SF1->F1_SERIE)
		else
			xImpu := armaF3Impu("SF3",SF1->F1_SERIE,SF1->F1_DOC,SF1->F1_FORNECE,SF1->F1_LOJA)
		endif   

		Aadd(aItos,xImpu)

		cClave := SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA

		SD1->(DbSetOrder(1)) // D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
		SD1->(MsSeek(xFilial("SD1") + cClave))

			//Busca info de remitos relacionados a la Nota de credito
		cRemito := BuRemitos(SD1->D1_DOC, SD1->D1_SERIE, SD1->D1_FORNECE, SD1->D1_LOJA,SD1->D1_COD, SD1->D1_ITEM,.F.)

		Aadd(aCabec,{	SF1->F1_DOC,;	// 1
						SF1->F1_SERIE,;				// 2
						SF1->F1_FORNECE,;			// 3
						SF1->F1_LOJA,;				// 4
						SF1->F1_EMISSAO,;			// 5
						SF1->F1_ESPECIE,;			// 6
						SF1->F1_COND,;			// 7
						xDesCPag,;				// 8
						aFechasV,;						// 9					
						"",;						//10
						"",;						//11
						SF1->F1_VEND1,;			//12
						SF1->F1_TXMOEDA,;			//13
						cCae,;					//14
						cVtoCae,;					//15
						SF1->F1_MOEDA,;			//16
						SF1->F1_BASIMP1,;			//17
						SF1->F1_BASIMP2,;			//18
						SF1->F1_BASIMP3,;			//19
						SF1->F1_BASIMP7,;			//20
						SF1->F1_BASIMP8,;			//21
						SF1->F1_VALIMP1,;			//22
						SF1->F1_VALIMP2,;			//23
						SF1->F1_VALIMP3,;			//24
						SF1->F1_VALIMP7,;			//25
						SF1->F1_VALIMP8,;			//26
						SF1->F1_VALIMP6,;			//27
						SF1->F1_VALMERC,;			//28
						SF1->F1_VALBRUT,;			//29
						SF1->F1_DESCONT,;			//30
						SF1->F1_FILIAL,;			//31
						lCai,;						//32
						cRemito,;	 				//33
						SF1->F1_VALIMP9,;			//34
						SF1->F1_BASIMP9;			//35
		})

		nTotQtd  := 0

		While SD1->(! EOF()) .And. SD1->(D1_FILIAL + D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA) == xFilial("SD1") + cClave
			lRet		:= .T.
			cDescPrd 	:= allTrim(Posicione('SB1',1,xfilial('SB1')+ SD1->D1_COD,'B1_DESC'))
			cEAM 		:= allTrim(Posicione('SB1',1,xfilial('SB1')+ SD1->D1_COD,'B1_CODBAR'))
			cUm     	:= SD1->D1_UM
			nQuant  	:= SD1->D1_QUANT
			nPrcven 	:= SD1->D1_VUNIT
			nTotal  	:= SD1->D1_TOTAL

			nImps := 0

			If substr(allTrim(SF1->F1_SERIE),1,1) == "B"	//Suma impuestos al item
				aIVA := buDatIVA(SD1->D1_TES) // busca las columnas que corresponden al IVA
				For nZ := 1 TO Len(aIVA)
					nImps += &("SD1->D1_VALIMP"+allTrim( CValToChar( aIVA[nZ,4] ) ) )
				Next nZ
				nTotal += nImps
				nPrcven := Round(nTotal/nQuant,TamSx3("D1_VUNIT")[2] )
			EndIf

			aAdd(xItem,{SD1->D1_COD,;			// 1
						cDescPrd,;    			// 2
						nQuant,; 				// 3
						nPrcven,; 				// 4
						cUm,;  					// 5
						SD1->D1_ITEM,; 			// 6
						nTotal,;  				// 7
						SD1->D1_TES,;  			// 8
						SD1->D1_DOC,;			// 9
						SD1->D1_SERIE,;			// 10
						SD1->D1_FORNECE,;		// 11
						SD1->D1_LOJA,;			// 12
						SD1->D1_ITEM,;			// 13
						SD1->D1_NUMSERI,;		// 14
						cEAM;               	//15
			})
			nTotQtd += nQuant
			SD1->(dbskip())
		EndDo
		xItem:=aSort(xItem,,,{|x,y| x[6]<y[6]})

		Aadd(aItem,xItem)

		DbSelectArea(cQryCab)
		(cQryCab)->(DbSkip())
	EndDo
	RestArea(aAreaSF1)
	RestArea(aAreaSD1)
	RestArea(aAreaSE4)
	RestArea(aAreaSB1)
	RestArea(aAreaSA1)
	RestArea(aArea)

Return lRet

/*ฑษออออออออออัอออออออออออหออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
 ฑฑบPrograma  ณ BuRemitos บAutor ณ Carlos Galvao      บFecha ณ  30/04/15   บฑฑ
 ฑฑฬออออออออออุอออออออออออสออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
 ฑฑบDesc.     ณ Busca los datos de los remitos asociados                   บฑฑ
 ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
 ฑฑบUso       ณ AP                                                         บฑฑ
 ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ*/

Static Function BuRemitos(cDocAux, cSerieAux, cClieAux, cLojaAux,cCod, cItem, lesSD2)
	Local aArea 	:= GetArea()
	Local aAreaSD2 := SD2->(GetArea())
	Local aAreaSD1 := SD1->(GetArea())
	Local cRemito 	:= ""
	Local cRemAux := ""
	Local lPrimero	:= .T.

	IF lesSD2
		SD2->(DbSetOrder(3))	//D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
		SD2->(MsSeek(xFilial("SD2") + cDocAux + cSerieAux + cClieAux + cLojaAux))

		while SD2->(!EOF()) .AND. SD2->D2_DOC == cDocAux .AND. cSerieAux == SD2->D2_SERIE
			IF !Empty(SD2->D2_REMITO)
				IF lPrimero
					lPrimero := .F.
					cRemito := SD2->D2_REMITO
					cRemAux := SD2->D2_REMITO
				Else
					IF cRemAux != SD2->D2_REMITO
						cRemito += " / "+SD2->D2_REMITO
						cRemAux := SD2->D2_REMITO
					EndIF
				EndIF
			EndIF
			SD2->(DbSkip())
		EndDo
	Else
		SD1->(DbSetOrder(3))	//D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
		SD1->(MsSeek(xFilial("SD1") + cDocAux + cSerieAux + cClieAux + cLojaAux))

		while SD1->(!EOF()) .AND. SD1->D1_DOC == cDocAux .AND. cSerieAux == SD1->D1_SERIE
			IF !Empty(SD1->D1_REMITO)
				IF lPrimero
					lPrimero := .F.
					cRemito := SD1->D1_REMITO
					cRemAux := SD1->D1_REMITO
				Else
					IF cRemAux != SD1->D1_REMITO
						cRemito += " / "+SD1->D1_REMITO
						cRemAux := SD1->D1_REMITO
					EndIF
				EndIF
			EndIF
			SD1->(DbSkip())
		EndDo
	EndIF

	RestArea(aAreaSD1)
	RestArea(aAreaSD2)
	RestArea(aArea)

Return cRemito

/*ฑษออออออออออัอออออออออออหออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
 ฑฑบPrograma  ณ ImpEstruc บAutor ณ Carlos Galvao      บFecha ณ  30/04/15   บฑฑ
 ฑฑฬออออออออออุอออออออออออสออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
 ฑฑบDesc.     ณ Imprime la estructura del Layout                           บฑฑ
 ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
 ฑฑบUso       ณ AP                                                         บฑฑ
 ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ*/

STATIC FUNCTION ImpEstruc(nIdx)

	Local nAuxX    	:= 0
	Local nAuxY    	:= 0
	Local idx      	:= 0
	Local cCodNF   	:= ""
	Local cTit     	:= ""
	Local cNomeCom := ""
	Local cTelFax  	:= ""
	Local cEndEnt  	:= ""
	Local cCidEnt  	:= ""
	Local cCuit    	:= ""
	Local cEstEnt  	:= ""
	Local cCodPos  	:= ""
	Local cIIBB    	:= ""
	Local cSM0DTRE 	:= ""
	Local cInicAct 	:= ""
	Local nDesplaz 	:= 0
	Local aSimbMon 	:= { GetMV( "MV_SIMB1" ), GetMV( "MV_SIMB2" ), GetMV( "MV_SIMB3" ), GetMV( "MV_SIMB4" ), GetMV( "MV_SIMB5" ) }
	Local xRayas   	:= {}
	Local xTitCab  	:= {}
	Local aDatCom 	:= {}
	Local cEmpresa 	:= SM0->M0_CODIGO
	Local cFilEmp  	:= SM0->M0_CODFIL 
	Local cTel		:= "" 
	Local cDomici	:= ""
	Local cMail		:= AllTrim(STR0012)
	Local ind:=0
	
	
	if (lDibuja)
		oPrn:SayBitmap(nIniY-80,nIniX+32,cLogo,600,300)
	endif

	nAuxX := nIniX
	nAuxY := nIniY + 210

//------------------------------------------------------------------------------------------------
//Se posiciona en la empresa/filial del comprobante e imprime eso como emisora del documento
//------------------------------------------------------------------------------------------------
	if (lDibuja)
		nRecSM0  	:= SM0->(REcno())
		cEmpAct  	:= SM0->M0_CODIGO
		cSucur   	:= aCabec[nIdx][31]// filial

		SM0->(MsSeek(cEmpAct + cSucur))

		If SM0->(FOUND())
			cNomeCom := allTrim(SM0->M0_NOMECOM)
			cIIBB    := allTrim(SM0->M0_INSC)
			cIIBB := StrTran(cIIBB,"-","")
			cIIBB    := SubStr(cIIBB, 1, 3 ) + "-" + SubStr(cIIBB, 4, 6 ) + "-" + SubStr(cIIBB, 10, 1 )
			cCuit := StrTran(SM0->M0_CGC,"-","")
			cCuit := SubStr(cCuit, 1, 2 ) + "-" + SubStr(cCuit, 3, 8 ) + "-" + SubStr(cCuit, 11, 1 )
			cSM0DTRE := DTOS(SM0->M0_DTRE)
			cInicAct := Substr(cSM0DTRE,7,2) + "/" + Substr(cSM0DTRE,5,2) + "/" + Substr(cSM0DTRE,1,4)
			cTel	 := Alltrim(SM0->M0_TEL)
			cDomici	 := Alltrim(SM0->M0_ENDENT)+" - "+Alltrim(SM0->M0_CIDENT)                                                 
		Endif
		SM0->(MsGoTo(nRecSM0))

//------------------------------------------------------------------------------------------------

		If substr(allTrim(aCabec[nIdx][SERIE]),1,1) == "E"
			cIIBB := AllTrim(STR0013) 
		Endif

		nPosY := nIniY + 200
		oPrn:Say(nPosY + 040,nMedio + 235,AllTrim(STR0014),oFontA09)//*oFontA08) 
		oPrn:Say(nPosY + 040,nMedio + 360,cCuit,oFontA09)//*oFontCB08)
		//IF Len(alltrim(cIIBB))>2//Solo imprime si tiene datos
		oPrn:Say(nPosY + 70,nMedio + 235,AllTrim(STR0015),oFontA08) 
		oPrn:Say(nPosY + 70,nMedio + 485,AllTrim(STR0016),oFontA09) 
		//ENDIF
		oPrn:Say(nPosY + 100,nMedio+235,AllTrim(STR0017),oFontA08) 
		oPrn:Say(nPosY + 130,nMedio + 235,AllTrim(STR0018),oFontA08) 
		oPrn:Say(nPosY + 130,nMedio + 500,cInicAct,oFontCB08)		// Fecha de Inicio de Actividades de SM0->M0_DTRE.

		If substr(allTrim(aCabec[nIdx][SERIE]),1,1) == "E"
			oPrn:Say(nPosY + 180,nMedio + 235,AllTrim(STR0019),oFontA08)
		Endif
	Endif //fin lDibuja

	Aadd(xRayas,nIniY + 0350)
	Aadd(xRayas,nIniY + 0850)
	Aadd(xRayas,nIniY + 2250)
	Aadd(xRayas,nIniY + 2550)
	Aadd(xRayas,nIniY + 2575)

	Aadd(aRayas,xRayas)

	// Box Tipo de Documento
	If (lDibuja)
		nAuxX := 1130 - 50
		nAuxY := nIniY
		oPrn:Box(40,nAuxX,125,nAuxX + 100)

		// Recuadro Cliente
		nAuxX := nIniX
		nAuxY := aRayas[nIdx][1]
		//oPrn:Say(nAuxY - 20,nAuxX + 020,"I.V.A. RESPONSABLE INSCRIPTO",oFontCB08)
		oPrn:Say(nAuxY-130,nAuxX + 020,cNomeCom,oFontA12)
		oPrn:Say(nAuxY-090,nAuxX+020,cDomici,oFontCB10)
		oPrn:Say(nAuxY-60,nAuxX+020,AllTrim(STR0020),oFontA08) 
	    if !EMPTY(cTel)
			oPrn:Say(nAuxY-60,nAuxX+180,SubStr(cTel,1,3)+" "+substr(cTel,4,2)+substr(cTel,6,4)+" - "+substr(cTel,10,4),oFontCB08)     
		endif
		oPrn:Say(nAuxY-30,nAuxX+020,cMail,oFontA09)//*oFontCB08)....Aca!
		//  ________________________
		// |Cliente    |Observ      |
		// |           |            |
		// |-----------|            |
		// |Cond. Pago |            |
		// |___________|____________|

		oPrn:Box(nAuxY,nAuxX,nAuxY + 500,nTope) 			// Box Cabecera
		oPrn:Line(nAuxY,nMedio,nAuxY + 500,nMedio)  		// Division Vertical Cabecera
		oPrn:Line(nAuxY + 225,nAuxX,nAuxY + 225,nMedio)		// Division Horizontal

		//Titulos Cabecera
		oPrn:Say(nAuxY + 040,nAuxX + 20,AllTrim(STR0021),oFontA12)

		oPrn:Say(nAuxY + 040,nMedio + 20,STR0022,oFontA12) 
		oPrn:Say(nAuxY + 080,nMedio + 20,STR0023,oFontA12) 
		oPrn:Say(nAuxY + 120,nMedio + 20,STR0023,oFontA12) 
		oPrn:Say(nAuxY + 160,nMedio + 20,STR0023,oFontA12) 
		
	
		
		oPrn:Say(nAuxY + 265,nAuxX + 20,AllTrim(STR0024),oFontA12) 

		If(cTipoNF == AllTrim(STR0025)) 
			oPrn:Say(nAuxY + 245,nMedio + 20,AllTrim(STR0026) + AllTRim(cValToChar(aCabec[nIdx][33],oFontA09)))//Imprime remito //STR0026
		EndIf

		// Recuadro Items
		nAuxX := nIniX
		nAuxY := aRayas[nIdx][2] + 50

		oPrn:Box(nAuxY,nAuxX,nAuxY + 1300,nTope)

		oPrn:Line(nAuxY + 50 ,nAuxX,nAuxY + 50 ,nTope) // Raya Horizontal

	EndIf //lDibuja

	cSimb := aSimbMon[aCabec[nIdx][MOEDA]]

	//Carga array con las posiciones y los titulos
			     // y   // x    	// titulo 			// offset
	Aadd(xTitCab,{nAuxY,nAuxX     		,AllTrim(STR0027)			,0020})			// 1 
	//Aadd(xTitCab,{nAuxY+5,nAuxX+0100,"CON.",0010})				// 2
	Aadd(xTitCab,{nAuxY,nAuxX + 0250	,AllTrim(STR0028)		,0250})			// 2 
	Aadd(xTitCab,{nAuxY,nAuxX + 1050	,AllTrim(STR0029)			,0015})			// 3 
	Aadd(xTitCab,{nAuxY,nAuxX + 1205	,AllTrim(STR0030)			,0040})			// 4 
	Aadd(xTitCab,{nAuxY,nAuxX + 1505	,AllTrim(STR0031) + cSimb	,0020})			// 5 
	Aadd(xTitCab,{nAuxY,nAuxX + 1785	,AllTrim(STR0032) + cSimb		,0090})			// 6 

	Aadd(aTitCab,xTitCab)

	//Impresion Titulos Cabecera y Grilla
	if (LDibuja)
		For ind:= 1 to Len(aTitCab[nIdx])

			//Obtiene Posiciones de grilla
			nAuxY    	:= aTitCab[nIdx][ind][1] + 10
			nAuxX    	:= aTitCab[nIdx][ind][2]
			cTit    	:= aTitCab[nIdx][ind][3]
			nDesplaz 	:= aTitCab[nIdx][ind][4]

			//Imprime Titulo grilla
			oPrn:Say(nAuxY + 30,nAuxX + nDesplaz,cTit,oFontA12)
			If ind<>1
				oPrn:Line(nAuxY - 10,nAuxX ,nAuxY + 1288,nAuxX) // Raya Vertical Titulos (Grilla)
			Endif
		Next ind

		nAuxX := nIniX
		nAuxY := aRayas[nIdx][3]

		//Box Neto e Impuestos
		nAuxX := nIniX + 1700
		oPrn:Box(nAuxY - 10,nAuxX,nAuxY + 270,nTope)

		//Box Original/Duplicado/Triplicado
		nAuxX := nIniX
		nAuxY := aRayas[nIdx][4]
		oPrn:Box(nAuxY,nAuxX,nAuxY + 50,nAuxX + 960)

		//Box Total
		nAuxX := nIniX+1700
		nAuxY := aRayas[nIdx][5] - 10
		oPrn:Box(nAuxY,nAuxX,nAuxY + 50,nTope)
	Endif
Return


/*ฑษออออออออออัอออออออออออหออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
 ฑฑบPrograma  ณ ImpHeader บAutor ณ Carlos Galvao      บFecha ณ  30/04/15   บฑฑ
 ฑฑฬออออออออออุอออออออออออสออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
 ฑฑบDesc.     ณ  Imprime el encabezado del Layout                          บฑฑ
 ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
 ฑฑบUso       ณ AP                                                         บฑฑ
 ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ*/

STATIC FUNCTION ImpHeader(nIdx)

	Local aArea	:= GetArea()
	Local nAuxX   	:= 0
	Local nAuxY   	:= 0
	Local cDoc      	:= ""
	Local cFecha    	:= ""
	Local cCodNF  	:= ""
	Local aAuxVen	:= {}
	Local cAuxVen	:= ""
	Local nX		:= 0
	Local nYVen		:= 160
	Local lDesc		:= .F.
	Local nMod		:= 11
	Local nVencs	:= 0

	nHojas++

	Do Case
	Case MV_PAR01 == 1
		cTipoNF := AllTrim(STR0025) 
		Do Case
		Case substr(allTrim(aCabec[nIdx][SERIE]),1,1) == "A"
			cCodNF := "01"
		Case substr(allTrim(aCabec[nIdx][SERIE]),1,1) == "B"
			cCodNF := "06"
		Case substr(allTrim(aCabec[nIdx][SERIE]),1,1) == "E"
			cCodNF  := "19"
			cTipoNF += STR0033 
		EndCase

	Case MV_PAR01 == 2 //NDC y NDI
		Do Case
		Case substr(allTrim(aCabec[nIdx][SERIE]),1,1) == "A"
			cCodNF := "02"
			cTipoNF:=AllTrim(STR0034) 
		Case substr(allTrim(aCabec[nIdx][SERIE]),1,1) == "B"
			cCodNF := "07"
			cTipoNF:=AllTrim(STR0034) 
		Case substr(allTrim(aCabec[nIdx][SERIE]),1,1) == "E"
			cCodNF := "20"
			cTipoNF += AllTrim(STR0033) 
		EndCase

	Case MV_PAR01 == 3  //NCC y NCI
		Do Case
		Case substr(allTrim(aCabec[nIdx][SERIE]),1,1) == "A"
			cCodNF := "03"
			cTipoNF := AllTrim(STR0035) 
		Case substr(allTrim(aCabec[nIdx][SERIE]),1,1) == "B"
			cCodNF := "08"
			cTipoNF := AllTrim(STR0035) 
		Case substr(allTrim(aCabec[nIdx][SERIE]),1,1) == "E"
			cCodNF := "21"
			cTipoNF += AllTrim(STR0033) 
		EndCase

	EndCase
//
// Impresion Datos
//
	nAuxX  := nMedio
	nAuxY  := nIniY
	oPrn:Say(nAuxY + 050,nAuxX - 20,substr(allTrim(aCabec[nIdx][SERIE]),1,1),oFontA16)  //variabilizar
	oPrn:Say(nAuxY + 050,nAuxX + 235,cTipoNF,oFontA14)  // Tipo de NF

	oPrn:Say(nAuxY + 120,nAuxX - 56,STR0036 + cCodNF,oFontA08)  //variabilizar 

	cDoc := substr(aCabec[nIdx][DOC],1,4) + "-" + substr(aCabec[nIdx][DOC],5)
	oPrn:Say(nAuxY + 100,nAuxX + 235,STR0037 + cDoc,oFontA14)  // Tipo de NF 

	cFecha := STRZERO(Day(aCabec[nIdx][EMISSAO]),2) + " de " + MesExtenso(aCabec[nIdx][EMISSAO]) + " de " + StrZero(Year(aCabec[nIdx][EMISSAO]),4)
	oPrn:Say(nAuxY + 180,nAuxX + 235,cFecha,oFontCB10)

	IF lQRAFIP
	    //Crea objeto QR
		oQRCode:= ArQrAFIP():New()
		//Obtiene codigo QR formato AFIP
		cCodQR:= oQRCode:LayCodeQR(aCabec[nIdx][CLIENTE],aCabec[nIdx][LOJA],/*NRODOC*/,aCabec[nIdx][ESPECIE],cCodNF, aCabec[nIdx][EMISSAO];
		         ,aCabec[nIdx][DOC], aCabec[nIdx][CAE],aCabec[nIdx][VCTOCAE],aCabec[nIdx][MOEDA],aCabec[nIdx][TXMOEDA],aCabec[nIdx][VALBRUT])
		oPrn:QRCode(270,1850,cCodQR, 60)
	ENDIF
//  Cliente
	nAuxX := nIniX
	nAuxY := aRayas[nIdx][1] + 20

	cCuitCli := SubStr(aCli[nIdx][8], 1, 2 ) + "-" + SubStr(aCli[nIdx][8], 3, 8 ) + "-" + SubStr(aCli[nIdx][8], 11, 1 )


	oPrn:Say(nAuxY + 020,nAuxX + 190, AllTrim(aCli[nIdx][2]), oFontCB08)
	oPrn:Say(nAuxY + 060,nAuxX + 190, AllTrim(aCli[nIdx][3]), oFontCB08)
	oPrn:Say(nAuxY + 100,nAuxX + 190, AllTrim(aCli[nIdx][6]) + " - " + AllTrim(aCli[nIdx][9]), oFontCB08)
	oPrn:Say(nAuxY + 140,nAuxX + 190, STR0038 + aCli[nIdx][10] , oFontCB08) 
	oPrn:Say(nAuxY + 180,nAuxX + 190, STR0039 + cCuitCli , oFontCB08) 

	nAuxX := nMedio
	nAuxY := aRayas[nIdx][1] + 20

	nAuxX := nIniX
	nAuxY := aRayas[nIdx][1] + 225

	//IMPRIME DESCRIPCION DE PAGO EN CABECERA
	oPrn:Say(nAuxY+080,nAuxX+190, aCabec[nIdx][DESCPAG], oFontCB08)
    
	If aCabec[nIdx][VENCTO] != ""
		aAuxVen := Separa(aCabec[nIdx][VENCTO], ";")
		nYVen := nAuxY+140
		For nX := 1 To Len(aAuxVen)
			If !Empty(aAuxVen[nX])
				cAuxVen += aAuxVen[nX] + ";"
			EndIf
			nVencs += 1
			If Mod(nVencs,nMod) == 0
				If !lDesc
					oPrn:Say(nYVen,nAuxX+020, STR0040 + cAuxVen, oFontCB08) //aca!
					nYVen += 20
					cAuxVen := ""
					lDesc := .T.
					nVencs := 0
					nMod := 12
				Else 
					oPrn:Say(nYVen,nAuxX+020, cAuxVen, oFontCB08) //aca!
					nYVen += 20
					cAuxVen := ""
				EndIf
			EndIf
		Next nX
		If !Empty(cAuxVen)
			oPrn:Say(nYVen,nAuxX+020, Iif(!lDesc,STR0040,"") + cAuxVen, oFontCB08) //aca! 
		EndIf
	EndIf

	nAuxX := nMedio
	nAuxY := aRayas[nIdx][1]+245

	RestArea(aArea)

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัอออออออออออหออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ImpBody   บAutor ณ Carlos Galvao      บFecha ณ  30/04/15   บฑฑ
ฑฑฬออออออออออุอออออออออออสออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime los datos del detalle del documento a imprimir     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

STATIC FUNCTION ImpBody(nIdx, nCopies)

	Local aArea    	:= GetArea()
	Local nAuxX    	:= 0
	Local nAuxY    	:= 0
	Local nLin     	:= 0
	Local nLenEsp	:= 0

	Local aLineas  	:= {}
	Local aEspec	:= {}

	Local cMoeda   	:= ""
	Local cDoc     	:= ""
	Local cClave   	:= ""
	Local cDesProd 	:= ""
	Local cDesNCND 	:= ""
	Local cLinEsp	:= ""

	Local lEtiqueta 	:= .T.

	Local I
	Local cPictQt  	:= PesqPict("SD2","D2_CUSTO1") //"@E 999,999,999.999"
	Local cPictPrc 	:= PesqPict("SD2","D2_PRCVEN")

	Local nIniBody 	:= aRayas[nIdx][2] + 100
	Local nLinMax  	:= 25 // cantidad de lines que se pueden imprimir en el cuerpo
	Local nIndice :=0

	for i := 1 TO 40
		Aadd(aLineas,5 + nIniBody + (i - 1) * 50)
	Next i

	nAuxX := nIniX
	nLin  := 2

	For I := 1 to Len(aItem[nIdx])
		nLargo := 47

		If nLin > nLinMax
			saltarPag(@nLin,@nHojas,nIdx, nCopies)
		Endif

		nAuxY := aLineas[nLin ++]
		nAuxX := aTitCab[nIdx][1][2]
		oPrn:Say(nAuxY,nAuxX + 0010, aItem[nIdx][I][1], oFCouri10) // codigo de articulo
		nAuxX := aTitCab[nIdx][3][2]
		oPrn:Say(nAuxY,nAuxX + 0020, aItem[nIdx][I][5], oFCouri10) // UM
		nAuxX := aTitCab[nIdx][4][2]
		oPrn:Say(nAuxY,nAuxX + 0000, Transform(aItem[nIdx][I][3],cPictQt), oFCouri10) // Cantidad
		nAuxX := aTitCab[nIdx][5][2]
		oPrn:Say(nAuxY,nAuxX, Transform(aItem[nIdx][I][4],cPictPrc), oFCouri10) // Pr.Unit.
		nAuxX := aTitCab[nIdx][6][2]
		oPrn:Say(nAuxY,nAuxX + 0060, Transform(aItem[nIdx][I][7],PesqPict("SD2","D2_TOTAL")), oFCouri10) // Total

		
		// Descripcion en varias lineas
		If !Empty(aItem[nIdx][I][6])
			cExtenso := alltrim(aItem[nIdx][I][2])  // agrega EAM .... + "- EAM: "+ Alltrim(aItem[nIdx][I][15] )
			nLargo := 40
			nLenMemo := MLCount(cExtenso,nLargo)
			For nIndice := 1 TO nLenMemo
				cLinea := MemoLine(cExtenso,nLargo, nIndice )
				nAuxX := aTitCab[nIdx][2][2]
				oPrn:Say(nAuxY,nAuxX+0020, cLinea, oFCouri10)
				nAuxY := aLineas[nLin ++]
			Next nIndice
			nLin --
		Endif		
		
		_nTotal += aItem[nIdx][I][7]

		If esExento(aItem[nIdx][I][8]) //D2_TES
			_nMonNG += aItem[nIdx][I][7]
		Else
			_nMonGr += aItem[nIdx][I][7]
		Endif

		nAuxX    := aTitCab[nIdx][2][2]

	Next I
	nLin++ // avanzo una linea
	nAuxX := aTitCab[nIdx][2][2]
	RestArea(aArea)

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัอออออออออออหออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ImpTrailerบAutor ณ Carlos Galvao      บFecha ณ  30/04/15   บฑฑ
ฑฑฬออออออออออุอออออออออออสออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImprime el pie de pagina                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

STATIC FUNCTION ImpTrailer(nIdx,nCopies)

	Local aArea    		:= GetArea()
	Local aDescMon 	:= { GetMV( "MV_MOEDAP1" ), GetMV( "MV_MOEDAP2" ), GetMV( "MV_MOEDAP3" ), GetMV( "MV_MOEDAP4" ), GetMV( "MV_MOEDAP5" ) }
	Local aSimbMon 	:= { GetMV( "MV_SIMB1" ), GetMV( "MV_SIMB2" ), GetMV( "MV_SIMB3" ), GetMV( "MV_SIMB4" ), GetMV( "MV_SIMB5" ) }
	Local cSigno   		:= aSimbMon[ If( Empty( aCabec[nIdx][MOEDA] ), 1, aCabec[nIdx][MOEDA] ) ]
	Local cCopia   		:= ""
	Local cCAEleyenda   	:= ""
	Local cTxmoeda	:= ""
	Local Bar     		:= ""
	Local nLenMemo:=0
	Local nIndice:=0
	Local i:=0

	nAuxX := nIniX
	nAuxY := aRayas[nIdx][2] + 1400      
	
	/*datos bancarios.*/
	oPrn:Say(nAuxY + 40,nAuxX + 5, AllTrim(STR0041), oFCouri10B) 
 	oPrn:Say(nAuxY + 80,nAuxX + 5, AllTrim(STR0042), oFCouri10B)
  	oPrn:Say(nAuxY + 120,nAuxX + 5, AllTrim(STR0043), oFCouri10B)
   	oPrn:Say(nAuxY + 160,nAuxX + 5, AllTrim(STR0044), oFCouri10B) 
   	oPrn:Say(nAuxY + 200,nAuxX + 5, AllTrim(STR0045), oFCouri10B)
   	oPrn:Say(nAuxY + 240,nAuxX + 5, AllTrim(STR0012), oFCouri10B)
	
	
	oPrn:Say(nAuxY + 40,nAuxX + 970, PadL("SUBTOTAL",TamSX3("FB_DESCR")[1]), oFCouri10B)
	oPrn:Say(nAuxY + 40,nAuxX + 1620, cSigno, oFCouri10B)
	IF substr(allTrim(aCabec[nIdx][SERIE]),1,1) == "B" 
		oPrn:Say(nAuxY + 40,aTitCab[nIdx][6][2] + 060, Transform(aCabec[nIdx][VALBRUT],PesqPict("SD2","D2_TOTAL")), oFCouri10)
	Else
		oPrn:Say(nAuxY + 40,aTitCab[nIdx][6][2] + 060, Transform(_nTotal,PesqPict("SD2","D2_TOTAL")), oFCouri10)
	Endif

	//Impresion Monto Bruto en Palabras
	cExtenso := StrTran(Extenso (aCabec[nIdx][VALBRUT],.F.),AllTrim(STR0046),"") 
	If !Empty(cExtenso)
		cExtenso :=  "SON " + Upper(aDescMon[If( Empty( aCabec[nIdx][MOEDA] ), 1, aCabec[nIdx][MOEDA] )]) + " " + cExtenso
		nLargo := 55
		nLenMemo := MLCount(cExtenso,nLargo)
		nAuxX := nIniX
		nAuxY := aRayas[nIdx][5] + 20
		For nIndice := 1 To nLenMemo
			cLinea := MemoLine(cExtenso,nLargo, nIndice )
			cLinea := allTrim(cLinea) + Replicate( '*', nLargo - Len(AllTrim(cLinea)))
			oPrn:Say(nAuxY + 45,nAuxX + 20,cLinea, oFCouri10)
			nAuxY += 40
		Next nIndice
	Endif

	nAuxX := nIniX
	nAuxY := aRayas[nIdx][3] + 20

	//Impresion Monto Neto e Impuestos
	IF substr(allTrim(aCabec[nIdx][SERIE]),1,1) != "B"
		oPrn:Say(nAuxY,nAuxX + 0970, PadL("NETO",TamSX3("FB_DESCR")[1]), oFCouri10B)
		oPrn:Say(nAuxY,nAuxX + 1620, cSigno, oFCouri10B)
		oPrn:Say(nAuxY,aTitCab[nIdx][6][2] + 060, Transform(aCabec[nIdx][VALMERC],PesqPict("SD2","D2_TOTAL")), oFCouri10)
	Endif

	For i := 1 to Len(aItos[nIdx])
		If Len(aItos[nIdx][1]) > 0
			If substr(allTrim(aCabec[nIdx][SERIE]),1,1) != "B" 
				nAuxY += 40
				oPrn:Say(nAuxY,nAuxX + 970,PadL(allTrim(aItos[nIdx][i][2]),TamSX3("FB_DESCR")[1]), oFCouri10B)
				oPrn:Say(nAuxY,nAuxX + 1500, PadL(Transform(aItos[nIdx][i][3],PesqPict("SFB","FB_ALIQ")),TamSX3("FB_ALIQ")[1]) + "%", oFCouri10B)
				oPrn:Say(nAuxY,nAuxX + 1620, cSigno, oFCouri10B)
				oPrn:Say(nAuxY,aTitCab[nIdx][6][2] + 060, Transform(aItos[nIdx][i][6],PesqPict("SD2","D2_TOTAL")), oFCouri10)
			Endif
			if i > 5
				exit
			Endif
		Endif
	Next

	nAuxX := nIniX
	nAuxY := aRayas[nIdx][5] + 20

	//Impresion Monto Bruto en Numeros
	oPrn:Say(nAuxY,nAuxX + 0970, PadL("TOTAL",TamSX3("FB_DESCR")[1]), oFCouri10B)
	oPrn:Say(nAuxY,nAuxX + 1620, cSigno, oFCouri10B)
	oPrn:Say(nAuxY,aTitCab[nIdx][6][2] + 060, Transform(aCabec[nIdx][VALBRUT],PesqPict("SD2","D2_TOTAL")), oFCouri10)

	//Impresion Tipo de Copia
	IF nCopies == 1
		cCopia := AllTrim(STR0047) 
	elseif nCopies == 2
		cCopia := AllTrim(STR0048)
	elseif nCopies == 3
		cCopia := AllTrim(STR0049)
	Endif

	nAuxX := nIniX
	nAuxY := aRayas[nIdx][4]
	oPrn:Say(nAuxY + 35,nAuxX + 350,cCopia, oFontA14)

	nAuxY := aRayas[nIdx][5] + 100
	nAuxX := nIniX

	//Impresion CAE y Fecha de Vto. 
	//Si es prepimpreso no va
	if !Empty(aCabec[nIdx][CAE])
		oPrn:Say(nAuxY + 50,nAuxX + 1700,STR0050 + aCabec[nIdx][CAE], oFontA10) //100 
		oPrn:Say(nAuxY + 80,nAuxX + 1700,STR0051 + Dtoc(aCabec[nIdx][VCTOCAE]),oFontA10) 

		//Impresion Codigo de Barras
		if (lDibuja)
			Bar := Barc(aCabec[nIdx][ESPECIE],aCabec[nIdx][SERIE],aCabec[nIdx][DOC],aCabec[nIdx][CAE],aCabec[nIdx][VCTOCAE])
			oPrn:Code128C ( nAuxY + 150, nAuxX + 450, Bar, 45)
		EndIf
	Endif

	RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSaltarPag บAutor  ณ Carlos Galvao      บ Data ณ  30/04/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณHace un salto de pagina                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function SaltarPag(nLin,nHojas,nIdx,nCopies)

	//Imprime Trailer de la Pagina
	ImpTrailer(nIdx,nCopies)

	//Cierra la pagina y abre una nueva
	oPrn:EndPage()
	oPrn:StartPage()

	//Inicializa Ubicacion de detalle e imprime Estructura y Header en la nueva pagina
	nLin := 2
	if (lDibuja)
		ImpEstruc(nIdx)
	endif
	ImpHeader(nIdx)
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
 ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
 ฑฑบPrograma  ณ buDatSFB บAutor  ณ Carlos Galvao      บ Data ณ  30/04/15   บฑฑ
 ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
 ฑฑบDesc.     ณ Trae la cantidad de items que va a imprimir                บฑฑ
 ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
 ฑฑบUso       ณ AP                                                         บฑฑ
 ฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function buDatSFB(cColVal,nVal,nAliq,cSerie)

	Local aArea 	:= GetArea()
	Local cQuery1   := ""
	Local cAliasQry := GetNextAlias()
	Local aImpu     := {}


	cQuery1 := "SELECT FB_CODIGO,FB_DESCR,FB_ALIQ,FB_CPOLVRO,FB_ESTADO" + CRLF
	cQuery1 +=  " FROM " + RetSqlName("SFB") + CRLF
	cQuery1 += " WHERE FB_FILIAL = '" + xFilial("SFB") + "'" + CRLF
	cQuery1 +=   " AND FB_CPOLVRO ='" + cColVal + "'" + CRLF

	cQuery1 +=   " AND D_E_L_E_T_ <> '*'"

	cQuery1 := ChangeQuery(cQuery1)
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery1), cAliasQry, .F., .T.)

	dbSelectArea(cAliasQry)
	dbGoTop()

	If (cAliasQry)->(! EOF())
		Aadd(aImpu,FB_CODIGO) 	//1
		Aadd(aImpu,FB_DESCR)  	//2
		Aadd(aImpu,Iif(!Empty(nAliq),nAliq,FB_ALIQ))   	//3
		Aadd(aImpu,FB_CPOLVRO) 	//4
		Aadd(aImpu,FB_ESTADO) 	//5
		Aadd(aImpu,nVal)      	//6
	Endif

	(cAliasQry)->(DbCloseArea())

	RestArea( aArea )
	
Return aImpu


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
  ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฟฑฑ
  ฑฑณFuncion   ณ Barc     ณ Autor ณ Carlos Galvao         ณ Data ณ 30/04/15 	ณฑฑ
  ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤดฑฑ
  ฑฑณDescrip.  ณ Encripta el codigo de barra		   					  			ณฑฑ
  ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
  ฑฑณUso       ณ                                                            	ณฑฑ
  ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
  ฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function Barc(cEspecie,cSerie,cDoc,cCae,dVtoCae)

	Local aArea 	:= GetArea()
	Local cCode 	:= StrTran(Alltrim(SM0->M0_CGC),"-","")
    Local _N:=0

	If cEspecie $ "NF   -FT   -NDC  "

		If Left( AllTrim(cSerie), 1 ) == "A"
			cCode += IIf(Alltrim(cEspecie) == "NF", "01", "02")
		EndIf
		If Left( AllTrim(cSerie), 1 ) == "B"
			cCode += IIf(Alltrim(cEspecie) == "NF", "06", "07")
		EndIf
		If Left( AllTrim(cSerie), 1 ) == "E"
			cCode += IIf(Alltrim(cEspecie) == "NF", "19", "20")
		EndIf
		cCode += Left(cDoc, 4 ) + cCae + Substr(dtos(dVtoCae),1,4) + Substr(dtos(dVtoCae),5,2) + Substr(dtos(dVtoCae),7,2)
	Else
		If Left( AllTrim(cSerie), 1 ) == "A"   //Nota de credito
			cCode += "03"
		EndIf
		If Left( AllTrim(cSerie), 1 ) == "B"
			cCode += "08"
		EndIf
		If Left( AllTrim(cSerie), 1 ) == "E"
			cCode += "21"
		EndIf
		cCode += Left(cDoc, 4 )  + cCae + Substr(dtos(dVtoCae),1,4) + Substr(dtos(dVtoCae),5,2) + Substr(dtos(dVtoCae),7,2)
	EndIf

//CALCULO DE DIGITO VERIFICADOR
	_E1 := 0
	_E2 := 0
	_E3 := 0
	_E4 := 0
	_E5 := 0

//ETAPA1: Suma de las posiciones inpares
	For _N = 1 to len(cCode) step 2
		_E1 += Val(Substr(cCode,_N,1))
	next _N

//ETAPA2: Multiplicar la suma anterior por 3
	_E2 := _E1 * 3

//ETAPA3: Suma las posiciones pares
	For _N = 2 to len(cCode) step 2
		_E3 += Val(Substr(cCode,_N,1))
	next _N

//ETAPA4: Suma reasultados de etapas 2 y 3
	_E4 := _E2 + _E3

//ETAPA5: Buscar menor numero que que sumado al resultado de etapa 4 de un multiplo de 10.
	_E5 := 10 - Val(Right(str(_E4),1))
	If _E5 == 10
		_E5 := 0
	EndIf

	cCode := cCode + Alltrim(Str(_E5))

	RestArea( aArea )
Return (cCode)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
 ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
 ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
 ฑฑบPrograma  ณbuTotHojasบAutor  ณ Carlos Galvao      บ Data ณ  30/04/15   บฑฑ
 ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
 ฑฑบDesc.     ณ Trae la cantidad de items que va a imprimir                บฑฑ
 ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
 ฑฑบUso       ณ AP                                                         บฑฑ
 ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
 ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
 ฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function esExento(cTES)

	Local aArea    	:= GetArea()
	Local aAreaSFC := SFC->(GetArea())
	Local lRet     	:= .T.

	SFC->(dbSetOrder(1))
	If SFC->(MsSeek(xFilial("SF4") + cTES))
		lRet := .F.
	Endif

	RestArea(aAreaSFC)
	RestArea(aArea)

Return lRet

/* ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
   ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
   ฑฑบPrograma  ณ armaImpu บAutor  ณ Carlos Galvao      บ Data ณ  30/04/15   บฑฑ
   ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
   ฑฑบDesc.     ณ Arma un array con los impuestos de la factura              บฑฑ
   ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
   ฑฑบUso       ณ AP                                                         บฑฑ
   ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
   ฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function armaImpu(cTabla,cSerie)

	Local aArea    	:= GetArea()
	Local aAreaSX3 	:= SX3->(GetArea())
	Local cCampo   := Iif(cTabla == "SF2","F2_VALIMP","F1_VALIMP")
	Local cClave   	:= ""
	Local aCampos := {}
	Local aImpu    	:= {}
	Local xImpu    	:= {}
	Local cColVal  	:= ""
	Local i:=0

	SX3->( DbSetOrder(1) )

	IF SX3->( MsSeek(cTabla) )
		While SX3->( ! EOF() .And. X3_ARQUIVO == cTabla )
			IF cCampo $ Alltrim(SX3->X3_CAMPO)
				AADD(aCampos, AllTrim(SX3->X3_CAMPO))
			Endif
			SX3->( DbSkip() )
		End
	Endif

	For i := 1 to Len(aCampos)

		nVal := &(cTabla + "->" + aCampos[i])

		If nVal > 0

			If cTabla == "SF2"
				cClave := SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA
			Else
				cClave := SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA
			Endif

			cColVal := SubStr(aCampos[i],10,1)
			nAliq     := buAliq(cTabla,cClave,cColVal)
			xImpu   := buDatSFB(cColVal,nVal,nAliq,cSerie)
			If Len(xImpu) > 0
				AADD(aImpu,xImpu)
			EndIf
		Endif

	Next

	RestArea(aAreaSX3)
	RestArea(aArea)

Return aImpu

/* ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
   ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
   ฑฑบPrograma  ณ buAliq   บAutor  ณ Carlos Galvao      บ Data ณ  30/04/15   บฑฑ
   ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
   ฑฑบDesc.     ณ Busca la alcuota en SD1/SD2                                บฑฑ
   ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
   ฑฑบUso       ณ AP                                                         บฑฑ
   ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
   ฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function armaF3Impu(cTabla,cSerie,cDoc,cCliente,cLoja)

Local aArea    := GetArea()
Local aAreaSX3 := SX3->(GetArea())
Local aAreaSF3 := SF3->(GetArea())
Local cCampo   := "F3_VALIMP"
Local cClave   := ""
Local aCampos  := {}
Local aImpu    := {}
Local xImpu    := {}
Local cColVal  := ""
Local nAliq     :=""
Local i:=0

dbselectArea("SF3")

SX3->( DbSetOrder(1) )

IF SX3->( MsSeek(cTabla) )
	While SX3->( !Eof() .And. X3_ARQUIVO == cTabla )
		IF cCampo $ Alltrim(SX3->X3_CAMPO)
			aAdd(aCampos, AllTrim(SX3->X3_CAMPO))
		Endif
		SX3->( DbSkip() )
	End
Endif

If !Empty(aCampos)
	cClave := xFilial("SF3")+cCliente+cLoja+cDoc+cSerie
	
	SF3->(DbSetOrder(4))
	SF3->(MsSeek(cClave))

	While !EOF() .And. cClave == SF3->F3_FILIAL+SF3->F3_CLIEFOR+SF3->F3_LOJA+SF3->F3_NFISCAL+SF3->F3_SERIE
	
		For i := 1 to Len(aCampos)
            
			
			nVal := Iif(SF3->(FieldPos(aCampos[i]))>0,&(aCampos[i]),0)
			
			If nVal > 0	
				cColVal := SubStr(aCampos[i],10,1)
				xImpu   := buDatSFB(cColVal,nVal,nAliq,cSerie) 
				
				nPosImp := aScan(aImpu,{|x| x[1] == xImpu[1]})
				
				If nPosImp > 0
					aImpu[nPosImp][6] += xImpu[6]
				Else
					Aadd(aImpu,xImpu)
				EndIf
			Endif

		Next i

		SF3->(dbSkip())
	EndDo	 
	
Endif

RestArea(aAreaSF3)
RestArea(aAreaSX3)
RestArea(aArea)

Return aImpu


/* ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
   ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
   ฑฑบPrograma  ณ buAliq   บAutor  ณ Carlos Galvao      บ Data ณ  30/04/15   บฑฑ
   ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
   ฑฑบDesc.     ณ Busca la alcuota en SD1/SD2                                บฑฑ
   ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
   ฑฑบUso       ณ AP                                                         บฑฑ
   ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
   ฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function buAliq(cTabla,cClave,cColVal)

	Local aArea    	:= GetArea()
	Local aAreaSD1 := SD1->(GetArea())
	Local aAreaSD2 := SD2->(GetArea())
	Local nAliq    	:= 0
	Local cCampo   := Iif(cTabla == "SF2","SD2->D2_ALQIMP","SD1->D1_ALQIMP")

	If cTabla == 'SF2'
		SD2->(DbSetOrder(3)) // D2_FILIAL, D2_DOC, D2_SERIE, D2_CLIENTE, D2_LOJA, D2_COD, D2_ITEM
		SD2->(MsSeek(xFilial("SD2") + cClave))

		While SD2->(! EOF()) .And. SD2->(D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA) == xFilial("SD2") + cClave

			nAliq := &(cCampo + cColVal)

			If nAliq > 0
				Exit
			Endif

			SD2->(dbskip())
		Enddo
	Else
		SD1->(DbSetOrder(1)) // D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
		SD1->(MsSeek(xFilial("SD1") + cClave))

		While SD1->(! EOF()) .And. SD1->(D1_FILIAL + D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA) == xFilial("SD1") + cClave

			nAliq := &(cCampo + cColVal)

			If nAliq > 0
				Exit
			Endif

			SD1->(dbskip())
		Enddo
	Endif

	RestArea(aAreaSD1)
	RestArea(aAreaSD2)
	RestArea(aArea)

Return nAliq

/* ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
   ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
   ฑฑบPrograma  ณbuDesPais บAutor  ณ Carlos Galvao      บ Data ณ  30/04/15   บฑฑ
   ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
   ฑฑบDesc.     ณ Trae la descripcion del pais                               บฑฑ
   ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
   ฑฑบUso       ณ AP                                                         บฑฑ
   ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
   ฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function buDesPais(cCodPai)

	Local aArea    	:= GetArea()
	Local aAreaSYA	:= SYA->(GetArea())
	Local cDesPai  	:= ""

	SYA->(dbSetOrder(1))
	If SYA->(MsSeek( xFilial( "SYA" ) + cCodPai))
		cDesPai := SYA->YA_DESCR
	Endif

	RestArea(aAreaSYA)
	RestArea(aArea)

Return (cDesPai)


/* ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
   ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
   ฑฑบPrograma  ณ buDatIVA บAutor  ณ Carlos Galvao      บ Data ณ  30/04/15   บฑฑ
   ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
   ฑฑบDesc.     ณ Trae las columnas relacionadas con el IVA                  บฑฑ
   ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
   ฑฑบUso       ณ AP                                                         บฑฑ
   ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
   ฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function buDatIVA(cTES)

	Local cQuery1   := ""
	Local cAliasQry := GetNextAlias()
	Local aIVA      	:= {}

	cQuery1 := "SELECT FB_CODIGO,FB_DESCR,FB_ALIQ,FB_CPOLVRO"+CRLF
	cQuery1 +=  " FROM "+RetSqlName("SFB")+" SFB,"+RetSqlName("SFC")+" SFC"+CRLF
	cQuery1 += " WHERE FB_FILIAL = '"+xFilial("SFB")+"' AND FC_FILIAL = '"+xFilial("SFC")+"'"+CRLF
	cQuery1 +=   " AND SUBSTRING(FB_CODIGO,1,2) ='IV'"+CRLF
	cQuery1 +=   " AND FB_CLASSIF = '3'"+CRLF
	cQuery1 +=   " AND FB_CLASSE = 'I'"+CRLF
	cQuery1 +=   " AND SFB.D_E_L_E_T_ <> '*'"+CRLF
	cQuery1 +=   " AND SFC.D_E_L_E_T_ <> '*'"+CRLF
	cQuery1 +=   " AND FB_CODIGO=FC_IMPOSTO"+CRLF
	cQuery1 +=   " AND FC_TES='"+cTES+"'"+CRLF
	cQuery1 += " ORDER BY FB_CPOLVRO"

	cQuery1 := ChangeQuery(cQuery1)
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery1), cAliasQry, .F., .T.)

	dbSelectArea(cAliasQry)
	dbGoTop()

	While (cAliasQry)->(!Eof())

		Aadd(aIVA,	{	(cAliasQry)->FB_CODIGO,;   	//1
						(cAliasQry)->FB_DESCR,;   		//2
						(cAliasQry)->FB_ALIQ,;    		//3
						(cAliasQry)->FB_CPOLVRO;  		//4
					};
			)
		(cAliasQry)->(DbSkip())
	EndDO
	(cAliasQry)->(DbCloseArea())

Return aIVA         

Static Function TraeVtos(cDoc,cSerie,cClient,cLoja,cTabla)

	Local cQuerx   := ""
	Local cAliasQx := GetNextAlias()
	Local aFechasV 	:= ""
	Local nCntdMe	:= 0

			cQuerx := "SELECT E1_VENCTO"
			cQuerx += " FROM "+RetSqlName("SE1")+" SE1 "+CRLF
			cQuerx += "WHERE E1_NUM 		= '"+ cDoc +"' "
			cQuerx += "  AND E1_SERIE 		= '"+cSerie+"' "
			cQuerx += "  AND E1_CLIENTE	= '"+cClient+"' "
			cQuerx += "  AND E1_LOJA		= '"+cLoja+"' "
			cQuerx += "  AND D_E_L_E_T_ 	= '' "

	If cTabla 		== 'SF2'
			cQuerx += "  AND E1_TIPO  		IN ('NF' , 'NDC')	"
	ElseIf cTabla 	== 'SF1'
			cQuerx += "  AND  E1_TIPO  		IN ('NCC') 			"
	EndIf

	cQuerx := ChangeQuery(cQuerx)
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuerx), cAliasQx, .F., .T.)

	dbSelectArea(cAliasQx)
	dbGoTop()

	While (cAliasQx)->(!Eof())
		
		nCntdMe	:= (nCntdMe + 1)

		If cTabla == 'SF2'

			aFechasV += (SubStr((cAliasQx)->E1_VENCTO,7,2)/*dia*/+"-"+SubStr((cAliasQx)->E1_VENCTO,5,2)	/*mes*/+"-"+SubStr((cAliasQx)->E1_VENCTO,3,2)/*aรฑo*/)+" ; "
			
			SubStr(TIME(),1,2)
			
		ElseIf cTabla == 'SF1'.and. cEspecie = 'NCC'
			aFechasV += (SubStr((cAliasQx)->E2_VENCTO,7,2)/*dia*/+"-"+SubStr((cAliasQx)->E2_VENCTO,5,2)	/*mes*/+"-"+SubStr((cAliasQx)->E2_VENCTO,3,2)/*aรฑo*/)+" ; "
		EndIf
		
		(cAliasQx)->(DbSkip())
	EndDO
	(cAliasQx)->(DbCloseArea())

Return aFechasV
