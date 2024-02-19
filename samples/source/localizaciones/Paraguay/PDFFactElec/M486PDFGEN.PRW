#include 'protheus.ch'
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "XMLXFUN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FONT.CH"
#INCLUDE "M486PDFPAR.CH"

/*/{Protheus.doc} M486PDFPAR
Rutina para creación y/o envio de reporte en formato PDF generado
a partir de XML timbrado por el SIFEN (PAR).
@author TOTVS
@version 1.0
@param cEspecie, caracter, Especie del Documento
/*/
User Function M486PDFGEN(cEspecie)
 	Local cPerg := "M486PDF"
	Private cSerie := ""
	Private cDocIni := ""
	Private cDocFin := ""
	Private nFormato := 0
	Private cPath := &(SuperGetmv( "MV_CFDDOCS" , .F. , "'cfd\facturas\'" )) + "\autorizados\"
	Private oXML   := Nil
	Private nTotPag := 0
	Private oFont1 := TFont():New( "ARIAL", , 7, .F., .F.)
	Private oFont2 := TFont():New( "ARIAL", , 8, .F., .F.)
	Private oFont3 := TFont():New( "ARIAL", , 10, .T., .T.)
	Private oFont4 := TFont():New( "ARIAL", , 8, .F., .T.) //Negrita - 8
	Private oFont5 := TFont():New( "ARIAL", , 11, .F., .T.) //Negrita - 12
	Private oFont6 := TFont():New( "ARIAL", , 14, .F., .T.) //Negrita - 16
	Private oFont7 := TFont():New( "ARIAL", , 11, .T., .T.) //Negrita - 16
	Private oFont8 := TFont():New( "ARIAL", , 10, .F., .F.)
	Private oFont9 := TFont():New( "ARIAL", ,  9, .F., .F.)
	Private nLinea	:= 0
	Private cPicture := "@E 99,999,999,999.99"
	Private cPicture2 := "@E 99999999999.99"
	Private cXmlMoe:=''
	Private cDirAux:=""
	Private nFinBox:=0
	oFont1:nWidth:=oFont2:nWidth:=oFont3:nWidth:=oFont4:nWidth:=oFont5:nWidth:=oFont6:nWidth:=oFont7:nWidth:=oFont8:nWidth:=oFont9:nWidth:= 3
	cPath := Replace( cPath, "\\", "\" )
	IF Empty(cEspecie)
	cEspecie:=U_TComboBox()
	ENDIF
	
	If Pergunte(cPerg,.T.)
		cSerie := MV_PAR01
		cDocIni := MV_PAR02
		cDocFin := MV_PAR03
		nFormato := MV_PAR04
		cDirAux:= ALLTRIM(MV_PAR05)
		Processa({|| U_XMLPDF(cEspecie)},STR0052, STR0053)// "Espere.." "Generando impresión de documento autorizado"
	EndIf
Return Nil

/*/{Protheus.doc} U_XMLPDF
Llamado de funciones para impresión de reporte PDF
@version 1.0
@param cEspecie, character,  Especie del documento.
/*/
User Function XMLPDF(cEspecie)
Local cCampos 	:= ""
Local cTablas 	:= ""
Local cCond   	:= ""
Local cOrder  	:= ""
Local cAliasPDF := getNextAlias()
Local cAviso	:= ""
Local cErro		:= ""
Local oPrinter
Local cFile 	:= ""
Local cFileGen 	:= ""
Local cFileAux 	:= ""
Local nRegProc 	:= 0
Local cPDFPro  	:= "1"
Local bOk:= .T.

Private nML			:= 20
Private cTipFact	:= ""
Private cLetFac		:= ""
Private cLetPie 	:= ""
Private nTamCant:=0
Private nPag:=0
	If alltrim(cEspecie) $ "NF|NDC|RFN|RTS"
		
		cCampos  := "% SF2.F2_FILIAL, SF2.F2_SERIE SERIE, SF2.F2_DOC DOCUMENTO, SF2.F2_ESPECIE ESPECIE, SF2.F2_CLIENTE CLIENTE, SF2.F2_LOJA LOJA, SF2.F2_MOEDA AS MONEDA, F2_SERIE2 SERIE2 %"
		cTablas  := "% " + RetSqlName("SF2") + " SF2 %"
		cCond    := "% SF2.F2_SERIE = '"  + cSerie + "'"
		cCond    += " AND SF2.F2_DOC >= '"  + cDocIni + "'"
		cCond    += " AND SF2.F2_DOC <= '"  + cDocFin + "'"
		cCond    += " AND SF2.F2_ESPECIE IN ('"  + cEspecie + "')"
		cCond	 += " AND SF2.F2_FILIAL = '" + xFilial("SF2") + "'"
		cCond	 += " AND SF2.D_E_L_E_T_  = ' ' %"
		cOrder := "% SF2.F2_FILIAL, SF2.F2_SERIE, SF2.F2_DOC %"
		cLetFac := STR0001 + IIf(Alltrim(cEspecie) == "NF", STR0002, STR0004) //"FACTURA ELECTRÓNICA" //"NOTA DE DÉBITO ELECTRÓNICA"
		cLetPie := IIf(Alltrim(cEspecie) == "NF", STR0029, STR0030) //"Representación impresa de FACTURA ELECTRÓNICA" //"Representación impresa de NOTA DE DÉBITO ELECTRÓNICA"
		nTamCant :=TamSX3("D2_QUANT")[2]
	ElseIf alltrim(cEspecie) $ "NCC"
		// NOTA DE CRÉDITO
		cCampos  := "% SF1.F1_FILIAL, SF1.F1_SERIE SERIE, SF1.F1_DOC DOCUMENTO, SF1.F1_ESPECIE ESPECIE, SF1.F1_FORNECE CLIENTE, SF1.F1_LOJA LOJA, SF1.F1_MOEDA AS MONEDA, F1_SERIE2 SERIE2  %"
		cTablas  := "% " + RetSqlName("SF1") + " SF1 %"
		cCond    := "% SF1.F1_SERIE = '"  + cSerie + "'"
		cCond    += " AND SF1.F1_DOC >= '"  + cDocIni + "'"
		cCond    += " AND SF1.F1_DOC <= '"  + cDocFin + "'"
		cCond    += " AND SF1.F1_ESPECIE = '"  + cEspecie + "'"
		cCond	 += " AND SF1.F1_FILIAL = '" + xFilial("SF1") + "'"
		cCond	 += " AND SF1.D_E_L_E_T_  = ' ' %"
		cOrder := "% SF1.F1_FILIAL, SF1.F1_SERIE, SF1.F1_DOC %"
		cLetFac := STR0001 + STR0003 //"NOTA DE CRÉDITO ELECTRÓNICA"
		cLetPie	:= STR0031  //"Representación impresa de NOTA DE CRÉDITO ELECTRÓNICA"
		nTamCant :=TamSX3("D1_QUANT")[2]
	EndIf

	BeginSql alias cAliasPDF
		SELECT %exp:cCampos%
		FROM  %exp:cTablas%
		WHERE %exp:cCond%
		ORDER BY %exp:cOrder%
	EndSql

	Count to nRegProc

	dbSelectArea(cAliasPDF)

	(cAliasPDF)->(DbGoTop())

	While (cAliasPDF)->(!Eof())
		If cPDFPro == "1"
			cFileGen := AllTrim((cAliasPDF)->SERIE) + AllTrim((cAliasPDF)->DOCUMENTO) + AllTrim((cAliasPDF)->ESPECIE)
			cFile := cFileGen + ".xml"
			oXML := XmlParserFile(cPath + cFile, "_", @cAviso,@cErro)

			If oXML <> Nil
				If File(GetClientDir() + cFileGen + ".pdf")
					// En caso de que exista el PDF en la carpeta del Smartclient, lo borra para que no pregunte si se sobre-escribe
					Delete File &(GetClientDir() + cFileGen + ".pdf")
				Endif

				oPrinter := FWMSPrinter():New(cFileGen,6,.F.,GetClientDir(),.T.,,,,,.F.,,.F. )

				If AllTrim((cAliasPDF)->ESPECIE) $ "NF|NDC|RFN|RTS"
					If alltrim((cAliasPDF)->ESPECIE) == "NF"
						cTipFact:= STR0002
						cLetFac := STR0001 + STR0002 // "KuDE de " "Factura Electrónica"
						cLetPie := STR0043 + STR0002 + STR0044 //"Consulte la validez de esta " "Factura Electrónica" " con el número de CDC impreso abajo en:"
					ElseIf AllTrim((cAliasPDF)->ESPECIE) == "NDC"
						cTipFact:= STR0004
						cLetFac := STR0001 + STR0004 // "KuDE de " "Nota de Débito Electrónica"
						cLetPie := STR0043 + STR0004 + STR0044 //"Consulte la validez de esta " "Nota de Débito Electrónica" " con el número de CDC impreso abajo en:"
					ElseIf AllTrim((cAliasPDF)->ESPECIE) $ "RFN|RTS"
						cTipFact:= STR0005
						cLetFac := STR0001 + STR0005 // "KuDE de " "Nota de Débito Electrónica"
						cLetPie := STR0043 + STR0005 + STR0044 //"Consulte la validez de esta " "Nota de Débito Electrónica" " con el número de CDC impreso abajo en:"
					EndIf
				ElseIf AllTrim((cAliasPDF)->ESPECIE) $ "NCC"
					cTipFact:= STR0003
					cLetFac	:= STR0001 + STR0003 //"KuDE de " "Nota de Crédito Electrónica"
					cLetPie	:= STR0043 + STR0003 + STR004  //"Consulte la validez de esta " "Nota de Crédito Electrónica" " con el número de CDC impreso abajo en:"
				EndIf

				oPrinter:setDevice(IMP_PDF)
				oPrinter:cPathPDF := GetClientDir()
				oPrinter:StartPage()

				cXmlMoe:=(cAliasPDF)->MONEDA
				//Encabezado
				U_uImpEnc(oPrinter,oXml, ( !AllTrim((cAliasPDF)->ESPECIE) $ "RFN|RTS"))
				
				If !AllTrim((cAliasPDF)->ESPECIE) $ "RFN|RTS"
					//Detalle
					U_uDetFact(oPrinter,oXML,0,1)
				Else
					U_uDetRem(oPrinter,oXML)
				EndIf
					
				//Pie de página
				oPrinter:EndPage()
				oPrinter:Print()

			

				cFileAux := GetClientDir() + cFileGen +".pdf"
				CpyT2S(cFileAux, cPath)
				If !Empty(cDirAux)
					bOk:=CpyS2T(cPath+ cFileGen +".pdf",cDirAux,.T. )
					IF !bOk
						Help(" ",1,STR0089,,STR0090,4,5)
					ENDIF
				ENDIF

				FreeObj(oPrinter)
				oPrinter := Nil

				FErase(cFileAux)
			EndIf
		EndIf
		(cAliasPDF)->(dbskip())
	EndDo

Return Nil

/*/{Protheus.doc} uImpEnc
Imprime encabezado de factura a partir de XML Paraguay
@version 1.0
@param oPrinter, objeto, Objeto creado por FWMSPrinter.
@param oXml, objeto, Objeto con estructura de archivo XML.
/*/
User Function uImpEnc(oPrinter,oXml,lNoRem)

Local cFileLogo	:= ""
//Emisor
Local cNomEm	:= ""
Local cRUC 		:= ""
Local cTimbrado := ""
Local cFecTim	:= ""
Local cDir		:= ""
Local cCiudad	:= ""
Local cTel		:= ""
Local cCorreo	:= ""
Local cActEc	:= ""
Local cNumDoc	:= ""
//Receptor
Local cFecEmis	:= ""
Local cCondVnt	:= ""
Local cCoutas	:= ""
Local cMoneda	:= ""
Local cTipoCam	:= ""
Local cRUCRec	:= ""
Local cNomRec	:= ""
Local cDirRec	:= ""
Local cTelRec	:= ""
Local cCorreoR	:= ""
Local cTipoTr	:= ""
Local cMotTr	:= ""
Local nMRText	:= 340
Local nMLText	:= 25
Local nIniBox:= 0
Local cResto:=0
Default lNoRem	:= .T.

	
	If XmlChildEx(oXml:_RDE, '_DE') <> Nil
		If XmlChildEx(oXml:_RDE:_DE, '_GDATGRALOPE') <> Nil
			If XmlChildEx(oXml:_RDE:_DE:_GDATGRALOPE, '_GEMIS') <> Nil
				If XmlChildEx(oXml:_RDE:_DE:_GDATGRALOPE:_GEMIS, '_DNOMEMI') <> Nil
					cNomEm		:= oXml:_RDE:_DE:_GDATGRALOPE:_GEMIS:_DNOMEMI:TEXT
				EndIf
				If XmlChildEx(oXml:_RDE:_DE:_GDATGRALOPE:_GEMIS, '_DDESCIUEMI') <> Nil
					cCiudad		:= oXml:_RDE:_DE:_GDATGRALOPE:_GEMIS:_DDESCIUEMI:TEXT
				EndIf
				If XmlChildEx(oXml:_RDE:_DE:_GDATGRALOPE:_GEMIS, '_DTELEMI') <> Nil
					cTel		:= oXml:_RDE:_DE:_GDATGRALOPE:_GEMIS:_DTELEMI:TEXT
				EndIf
				If XmlChildEx(oXml:_RDE:_DE:_GDATGRALOPE:_GEMIS, '_DEMAILE') <> Nil
					cCorreo		:= oXml:_RDE:_DE:_GDATGRALOPE:_GEMIS:_DEMAILE:TEXT
				EndIf
				If XmlChildEx(oXml:_RDE:_DE:_GDATGRALOPE:_GEMIS, '_DRUCEM') <> Nil
					cRUC		:= oXml:_RDE:_DE:_GDATGRALOPE:_GEMIS:_DRUCEM:TEXT
				EndIf
				If XmlChildEx(oXml:_RDE:_DE:_GDATGRALOPE:_GEMIS, '_DDVEMI') <> Nil 
					cRUC		+= "-" + oXml:_RDE:_DE:_GDATGRALOPE:_GEMIS:_DDVEMI:TEXT
				EndIf
				If XmlChildEx(oXml:_RDE:_DE:_GDATGRALOPE:_GEMIS, '_DDIREMI') <> Nil
					cDir		:= oXml:_RDE:_DE:_GDATGRALOPE:_GEMIS:_DDIREMI:TEXT
				EndIf
				If XmlChildEx(oXml:_RDE:_DE:_GDATGRALOPE:_GEMIS, '_DNUMCAS') <> Nil 
					cDir		+= " " + STR0054 + " " + oXml:_RDE:_DE:_GDATGRALOPE:_GEMIS:_DNUMCAS:TEXT
				EndIf
				If XmlChildEx(oXml:_RDE:_DE:_GDATGRALOPE:_GEMIS, '_GACTECO') <> Nil
					If XmlChildEx(oXml:_RDE:_DE:_GDATGRALOPE:_GEMIS:_GACTECO, '_DDESACTECO') <> Nil
						cActEc		:= oXml:_RDE:_DE:_GDATGRALOPE:_GEMIS:_GACTECO:_DDESACTECO:TEXT
					EndIf
				EndIf
				 
			EndIf
			If XmlChildEx(oXml:_RDE:_DE:_GDATGRALOPE, '_DFEEMIDE') <> Nil
				//Emisión
				cFecEmis	:= SUBSTR(oXml:_RDE:_DE:_GDATGRALOPE:_DFEEMIDE:TEXT,9,2) + "-"
				cFecEmis	+= SUBSTR(oXml:_RDE:_DE:_GDATGRALOPE:_DFEEMIDE:TEXT,6,2) + "-"
				cFecEmis	+= SUBSTR(oXml:_RDE:_DE:_GDATGRALOPE:_DFEEMIDE:TEXT,1,4) + " "
				cFecEmis	+= SUBSTR(oXml:_RDE:_DE:_GDATGRALOPE:_DFEEMIDE:TEXT,12)
			EndIf
			
			If XmlChildEx(oXml:_RDE:_DE:_GDATGRALOPE, '_GOPECOM') <> Nil
				If XmlChildEx(oXml:_RDE:_DE:_GDATGRALOPE:_GOPECOM, '_DDESTIPTRA') <> Nil
					cTipoTr		:= oXml:_RDE:_DE:_GDATGRALOPE:_GOPECOM:_DDESTIPTRA:TEXT
				EndIf
				If XmlChildEx(oXml:_RDE:_DE:_GDATGRALOPE:_GOPECOM, '_CMONEOPE') <> Nil
					cMoneda		:= oXml:_RDE:_DE:_GDATGRALOPE:_GOPECOM:_CMONEOPE:TEXT
				EndIf
				If cMoneda <> "PYG"
					If XmlChildEx(oXml:_RDE:_DE:_GDATGRALOPE:_GOPECOM, '_DTICAM') <> Nil
						cTipoCam	:= oXml:_RDE:_DE:_GDATGRALOPE:_GOPECOM:_DTICAM:TEXT
					EndIf
				EndIf
			EndIf
			
			If XmlChildEx(oXml:_RDE:_DE:_GDATGRALOPE, '_GDATREC') <> Nil
				If XmlChildEx( oXml:_RDE:_DE:_GDATGRALOPE:_GDATREC, '_DRUCREC') <> Nil
					cRUCRec		:= oXml:_RDE:_DE:_GDATGRALOPE:_GDATREC:_DRUCREC:TEXT 
				EndIf
				IF Empty(cRUCRec)
					If XmlChildEx( oXml:_RDE:_DE:_GDATGRALOPE:_GDATREC, '_DNUMIDREC') <> Nil
					cRUCRec		:= oXml:_RDE:_DE:_GDATGRALOPE:_GDATREC:_DNUMIDREC:TEXT 
					EndIf
				ENDIF
				If XmlChildEx( oXml:_RDE:_DE:_GDATGRALOPE:_GDATREC, '_DDVREC') <> Nil
					cRUCRec		+= "-" + oXml:_RDE:_DE:_GDATGRALOPE:_GDATREC:_DDVREC:TEXT
				EndIf
				If XmlChildEx( oXml:_RDE:_DE:_GDATGRALOPE:_GDATREC, '_DNOMREC') <> Nil
					cNomRec		:= oXml:_RDE:_DE:_GDATGRALOPE:_GDATREC:_DNOMREC:TEXT
				EndIf
				If XmlChildEx( oXml:_RDE:_DE:_GDATGRALOPE:_GDATREC, '_DDIRREC') <> Nil
					cDirRec		:= oXml:_RDE:_DE:_GDATGRALOPE:_GDATREC:_DDIRREC:TEXT 
				EndIf
				If XmlChildEx( oXml:_RDE:_DE:_GDATGRALOPE:_GDATREC, '_DNUMCASREC') <> Nil
					cDirRec		+= " " + STR0054 + " " + oXml:_RDE:_DE:_GDATGRALOPE:_GDATREC:_DNUMCASREC:TEXT
				EndIf
				If XmlChildEx( oXml:_RDE:_DE:_GDATGRALOPE:_GDATREC, '_DTELREC') <> Nil
					cTelRec		:= oXml:_RDE:_DE:_GDATGRALOPE:_GDATREC:_DTELREC:TEXT//dTelRec
				EndIf
				If XmlChildEx( oXml:_RDE:_DE:_GDATGRALOPE:_GDATREC, '_DEMAILREC') <> Nil
					cCorreoR	:= oXml:_RDE:_DE:_GDATGRALOPE:_GDATREC:_DEMAILREC:TEXT //dEmailRec
				EndIf
			EndIf
		EndIf
		If XmlChildEx( oXml:_RDE:_DE, '_GTIMB') <> Nil
			If XmlChildEx( oXml:_RDE:_DE:_GTIMB, '_DNUMTIM') <> Nil
				cTimbrado	:= oXml:_RDE:_DE:_GTIMB:_DNUMTIM:TEXT
			EndIf
			If XmlChildEx( oXml:_RDE:_DE:_GTIMB, '_DFEINIT') <> Nil
				cFecTim		:= oXml:_RDE:_DE:_GTIMB:_DFEINIT:TEXT
			EndIf
			If XmlChildEx( oXml:_RDE:_DE:_GTIMB, '_DEST') <> Nil
				cNumDoc		:= oXml:_RDE:_DE:_GTIMB:_DEST:TEXT
			EndIf
			If XmlChildEx( oXml:_RDE:_DE:_GTIMB, '_DPUNEXP') <> Nil  
				cNumDoc		+= "-" + oXml:_RDE:_DE:_GTIMB:_DPUNEXP:TEXT
			EndIf  
			If XmlChildEx( oXml:_RDE:_DE:_GTIMB, '_DNUMDOC') <> Nil
				cNumDoc		+= "-" + oXml:_RDE:_DE:_GTIMB:_DNUMDOC:TEXT
			EndIf
		EndIf
		If XmlChildEx( oXml:_RDE:_DE, '_GDTIPDE') <> Nil
			If XmlChildEx( oXml:_RDE:_DE:_GDTIPDE, '_GCAMCOND') <> Nil
				If XmlChildEx( oXml:_RDE:_DE:_GDTIPDE:_GCAMCOND, '_DDCONDOPE') <> Nil
					cCondVnt	:= oXml:_RDE:_DE:_GDTIPDE:_GCAMCOND:_DDCONDOPE:TEXT
				EndIf
				If XmlChildEx( oXml:_RDE:_DE:_GDTIPDE:_GCAMCOND, '_GPAGCRED') <> Nil
					If XmlChildEx( oXml:_RDE:_DE:_GDTIPDE:_GCAMCOND:_GPAGCRED, '_DCUOTAS') <> Nil
						cCoutas		:= oXml:_RDE:_DE:_GDTIPDE:_GCAMCOND:_GPAGCRED:_DCUOTAS:TEXT
					EndIf
				EndIf
			EndIf
			
			If XmlChildEx( oXml:_RDE:_DE:_GDTIPDE, '_GCAMNCDE') <> Nil
				If XmlChildEx( oXml:_RDE:_DE:_GDTIPDE:_GCAMNCDE, '_DDESMOTEMI') <> Nil
					cMotTr := oXml:_RDE:_DE:_GDTIPDE:_GCAMNCDE:_DDESMOTEMI:TEXT
				EndIf
			EndIf
		EndIf
	EndIf


	cFileLogo := U_uCargaLog()

	nLinea := 15
	
	oPrinter:Box( nLinea, nML, nLinea+15, 575, "-4")
	
	oPrinter:SayAlign(nLinea + 1,190,cLetFac,oFont5,160,5,CLR_BLACK, 2, 2 )
	
	
	nLinea += 15
	nIniBox:= U_ucalLi(cDir,51)
	nIniBox+= U_ucalLi(cCorreo,40)
	nInibox+=U_ucalLi(cActEc,66)
	IF nIniBox >3 //no se cuentan esas 3 lineas por que no dal un salto
		nIniBox:=nIniBox-3
	ENDIF
	oPrinter:Box( nLinea, nML, nLinea+130+(nIniBox*10), 575, "-4")
	
	nLinea += 10
	If File(cFilelogo)
		oPrinter:SayBitmap(nLinea,nMLText,cFileLogo,100,50) // Impresion de logotipo
	EndIf
	
	nLinea += 10
	oPrinter:Say(nLinea,nMRText,STR0006  + cRUC,oFont3) //"RUC: "
	
	nLinea += 10
	oPrinter:Say(nLinea,nMRText,STR0007 +  cTimbrado,oFont3) //"Timbrado No: "
	
	nLinea += 10
	oPrinter:Say(nLinea,nMRText,STR0008 + cFecTim,oFont3) //"Fecha de Inicio de Vigencia: "
	
	nLinea += 30
	oPrinter:Say(nLinea,nMLText,cNomEm,oFont5) //Nombre  generado en ambiente de prueba - sin valor comercial ni fiscal
	
	nLinea += 3
	U_uLeyendas(cDir,51,@nLinea,nMLText,oPrinter,10,oFont8) 

	//nLinea += 1
	U_uLeyendas(STR0010+cCiudad,51,@nLinea,nMLText,oPrinter,10,oFont8) 
	
	nLinea += 10
	oPrinter:Say(nLinea,nMLText,STR0011 + cTel,oFont8) //"Teléfono: "
	
	oPrinter:Say(nLinea,nMRText,cTipFact,oFont6) //Tipo de documento
	
	nLinea += 10
	
	cResto:=SubStr(cCorreo,1,40)
	oPrinter:Say(nLinea,nMLText,cResto,oFont8)
	cResto:=SubStr(cCorreo,41,len(cCorreo))
	U_uLeyendas(cResto,40,@nLinea,nMLText,oPrinter,12,oFont8) 
	
	oPrinter:Say(nLinea,nMRText,cNumDoc,oFont7) //Número de documento
	
	nLinea += 10
	
	cResto:=SubStr(STR0012 + cActEc,1,50)
	oPrinter:Say(nLinea,nMLText,cResto,oFont8)
	cResto:=SubStr(STR0012 + cActEc,51,len(STR0012 + cActEc))
	U_uLeyendas(cResto,50,@nLinea,nMLText,oPrinter,10,oFont8) 
	
	If lNoRem
		nLinea += 10
		nFinBox:=nIniBox+1 // para que no se encime el cuadro previo
		nIniBox:= U_ucalLi(cNomRec,50)// verificando lineas que van a consumir razon social
		nIniBox+=U_ucalLi(cDirRec,50)
		nIniBox+=U_ucalLi(cTipoTr,40)
		nIniBox+=U_ucalLi(cCorreoR,40)
		nIniBox+=U_ucalLi(cTelRec,50)
		
		
		oPrinter:Box( nLinea+nFinBox, nML, nLinea+80+(nIniBox*10), 575, "-4")
		
		
		nLinea += 10+nFinBox
		oPrinter:Say(nLinea,nMLText,STR0013 + cFecEmis,oFont8) //"Fecha y hora de emisión: "
		
		oPrinter:Say(nLinea,nMRText,STR0024,oFont8) //"RUC/Documento de Identidad No: "
		cResto:=SubStr(cRUCRec,1,25)
		oPrinter:Say(nLinea,nMRText+131,cResto,oFont3)
		cResto:=SubStr(cRUCRec,26,len(cRUCRec))
		U_uLeyendas(cResto,50,@nLinea,nMRText,oPrinter,12,oFont3) 
		
		nLinea += 10
		oPrinter:Say(nLinea,nMLText,STR0014 + cCondVnt,oFont8) //"Condición de venta: "
		
			
		oPrinter:Say(nLinea,nMRText,STR0025,oFont8) //"Nombre o Razón Social: "
		cResto:=SubStr(cNomRec,1,30)
		oPrinter:Say(nLinea,nMRText+86,cResto,oFont3)
		cResto:=SubStr(cNomRec,31,len(cNomRec))
		U_uLeyendas(cResto,50,@nLinea,nMRText,oPrinter,12,oFont3) 
		
		nLinea += 10
		oPrinter:Say(nLinea,nMLText,STR0017 + cCoutas,oFont8) //"Coutas: "
		
		oPrinter:Say(nLinea,nMRText,STR0026,oFont8) //"Dirección: "
		cResto:=SubStr(cDirRec,1,40)
		oPrinter:Say(nLinea,nMRText +40,cResto,oFont3)
		cResto:=SubStr(cDirRec,41,len(cDirRec))
		U_uLeyendas(cResto,50,@nLinea,nMRText,oPrinter,10,oFont3) 
		
		nLinea += 10
		oPrinter:Say(nLinea,nMLText,STR0018 + cMoneda,oFont8) //"Moneda: "
		oPrinter:Say(nLinea,nMLText+75,STR0019 + cTipoCam,oFont8) //"Tipo de Cambio: "
		
		oPrinter:Say(nLinea,nMRText,STR0011,oFont8) //"Teléfono: "
	
		cResto:=SubStr(cTelRec,1,45)
		oPrinter:Say(nLinea,nMRText +40,cResto,oFont3)
		cResto:=SubStr(cTelRec,46,len(cTelRec))
		U_uLeyendas(cResto,50,@nLinea,nMRText,oPrinter,10,oFont3)
		
		nLinea += 10
		oPrinter:Say(nLinea,nMLText,STR0020,oFont8) //"Tipo de cambio global o por item"
		
		oPrinter:Say(nLinea,nMRText,STR0027,oFont8) //"Correo Eléctronico: "
		cResto:=SubStr(cCorreoR,1,34)
		oPrinter:Say(nLinea,nMRText +69,cResto,oFont3)
		cResto:=SubStr(cCorreoR,35,len(cCorreoR))
		U_uLeyendas(cResto,40,@nLinea,nMRText,oPrinter,10,oFont3)

		nLinea += 10
		oPrinter:Say(nLinea,nMLText,STR0021,oFont8) //"Documento asociado CDC o preimpreso"
		
		oPrinter:Say(nLinea,nMRText,STR0028,oFont8) //"Tipo de transacción: "
		cResto:=SubStr(cTipoTr,1,35)
		oPrinter:Say(nLinea,nMRText +72,cResto,oFont3)
		cResto:=SubStr(cTipoTr,36,len(cTipoTr))
		U_uLeyendas(cResto,40,@nLinea,nMRText,oPrinter,10,oFont3)

		nLinea += 10
		oPrinter:Say(nLinea,nMLText,STR0022 + STR0023,oFont8) //"Tipo de documento asociado: " "FE o preimpreso"
		
		If !Empty(cMotTr)
			oPrinter:Say(nLinea,nMRText,STR0057,oFont8) //"Motivo de la emisión: "
			oPrinter:Say(nLinea,nMRText+75,cMotTr,oFont3) //
		EndIf
	Else
		nLinea += 15
		
		nIniBox:= U_ucalLi(cNomRec,60)
		nIniBox+= U_ucalLi(cRUCRec,50)


		oPrinter:Box( nLinea, nML, nLinea+50+nIniBox, 575, "-4")
		
		nLinea += 10
		oPrinter:Say(nLinea,nMLText,STR0013 + cFecEmis,oFont8) //"Fecha y hora de emisión: "
		
		nLinea += 10
		oPrinter:Say(nLinea,200,STR0058,oFont6) //"DESTINATARIO DE LA MERCADERÍA"
		
		nLinea += 10
		oPrinter:Say(nLinea,nMLText,STR0025,oFont8) //"Nombre o Razón Social: "
	
		cResto:=SubStr(cNomRec,1,20)
		oPrinter:Say(nLinea,nMLText +86,cResto,oFont3)
		cResto:=SubStr(cNomRec,21,len(cNomRec))
		U_uLeyendas(cResto,60,@nLinea,nMLText,oPrinter,10,oFont3)
		
		oPrinter:Say(nLinea,nMRText,STR0024,oFont8) //"RUC/Documento de Identidad No: "
		
		cResto:=SubStr(cRUCRec,1,25)
		oPrinter:Say(nLinea,nMRText+131,cResto,oFont3)
		cResto:=SubStr(cRUCRec,26,len(cRUCRec))
		U_uLeyendas(cResto,50,@nLinea,nMRText,oPrinter,12,oFont3) 
		
	
	EndIf
	
Return Nil

/*/{Protheus.doc} uDetFact
Imprimir detalle de reporte de factura a partir de XML
@author TOTVS
@version 1.0
@param oPrinter, objeto, objeto creado por FWMSPrinter.
@param oXml, Objeto con estructura de archivo XML.
@return N/A
/*/
User Function uDetFact(oPrinter,oXML,nIndice,nHoj)
Local nMLText	:= 25
Local nLinea1 	:= 73
Local nLinea2	:= 198
Local nLinea3	:= 243
Local nLinea4	:= 283
Local nLinea5	:= 343
Local nLinea6	:= 393
Local nLinea7	:= 454 
Local nLinea8	:= 515
Local nInicio	:= 0
Local nInicio2	:= 0

Local oXmlItem	:= Nil
Local nI		:= 0
Local nIniFact:=0
Local nLimite:= 0

Local nUltima:=0
Local nAux:=0
Local nHojas:=nHoj
cPicture := IIF(MsDecimais(cXmlMoe)==0,"@E 99,999,999,999","@E 99,999,999,999.99")
	If XmlChildEx(oXml:_RDE, '_DE') <> Nil
		
		If XmlChildEx(oXml:_RDE:_DE, '_GDTIPDE') <> Nil
			oXmlItem := oXml:_RDE:_DE:_GDTIPDE:_GCAMITEM
		EndIf
	EndIf
	
	nLinea += 30
	nInicio	:= nLinea
	
	oPrinter:Line( nLinea, nML, nLinea, 575, CLR_BLACK, "-4") //Linea superior
	
	//Encabezados
	nLinea += 20
	oPrinter:Say( nLinea,nMLText	  ,STR0029,oFont3) //"Cod"
	oPrinter:Say( nLinea,nMLText + 50 ,STR0030,oFont3) //"Descripción"
	oPrinter:Say( nLinea,nMLText + 166,STR0031,oFont3) //"Unidad de"
	oPrinter:Say( nLinea,nMLText + 211,STR0032,oFont3) //"Cantidad"
	oPrinter:Say( nLinea,nMLText + 260,STR0033,oFont3) //"Precio Unitario"
	oPrinter:Say( nLinea,nMLText + 320,STR0034,oFont3) //"Descuento"
	oPrinter:Say( nLinea,nMLText + 425,STR0035,oFont3) //"Valor de Venta"
	nLinea += 10
	oPrinter:Say( nLinea,nMLText + 169,STR0055,oFont3) //"medida"
	oPrinter:Say( nLinea,nMLText + 383,STR0036,oFont3) //"Exentas"
	oPrinter:Say( nLinea,nMLText + 454,STR0037,oFont3) //"5%"
	oPrinter:Say( nLinea,nMLText + 512,STR0038,oFont3) //"10%"

	nLinea += 5
	nInicio2 := nLinea
	oPrinter:Line( nLinea, nML, nLinea, 575, CLR_BLACK, "-4") //Linea inferior
	
	nLinea += 5
	If ValType(oXmlItem) == "O"
		U_uImpItem(oPrinter, oXmlItem)
		nUltima:=1
		nLimite:=618
	ElseIf ValType(oXmlItem) == "A"
		IF nIndice==0
			nHojas:=U_utotHojas(oXmlItem,nLinea,79,682,618,25,10,6)
		ENDIF
		For nI := IIF(nIndice<>0,nIndice,1) To Len(oXmlItem)
			
			IF nI== Len(oXmlItem)
				nUltima:=1
				nLimite:=618
			ELSE
				nLimite:=682
			ENDIF

			nAux:=3+nLinea  // el 7 es la separación de linea ente peoductos
			nAux+=U_ucalLi(oXmlItem[nI]:_DDESPROSER:TEXT,25)*10// +(IIF(nI==1,))
	
			IF (nAux)< nLimite// verifico primero si el item no pasa el limite le sumo 200 porel pie de pagina
				U_uImpItem(oPrinter, oXmlItem[nI])
			ELSE
				nLinea:=nLimite
				nIniFact:=nI
				EXIT
			
			ENDIF
			
		Next nI
	EndIf
	
	//Lineas de división
	
	oPrinter:Line( nInicio, nML, nLinea, nML, CLR_BLACK, "-4")
	oPrinter:Line( nInicio, 575, nLinea, 575, CLR_BLACK, "-4")
	oPrinter:Line( nInicio, nLinea1-10, nLinea, nLinea1-10, CLR_BLACK, "-4")
	oPrinter:Line( nInicio, nLinea2-10, nLinea, nLinea2-10, CLR_BLACK, "-4")
	oPrinter:Line( nInicio, nLinea3-10, nLinea, nLinea3-10, CLR_BLACK, "-4")
	oPrinter:Line( nInicio, nLinea4, nLinea, nLinea4, CLR_BLACK, "-4")
	oPrinter:Line( nInicio, nLinea5, nLinea, nLinea5, CLR_BLACK, "-4")
	oPrinter:Line( nInicio, nLinea6, nLinea, nLinea6, CLR_BLACK, "-4")
	
	oPrinter:Line( nInicio2, nLinea7, nLinea, nLinea7, CLR_BLACK, "-4")
	oPrinter:Line( nInicio2, nLinea8, nLinea, nLinea8, CLR_BLACK, "-4") 
	
	IF (nUltima ==  1)
		IF (nAux)< nLimite
			nLinea+=2
			oPrinter:Line( nLinea+1, nML, nLinea, 575, CLR_BLACK, "-4") 
			U_utotales(oPrinter,oXml)
		ENDIF
	ENDIF
	U_uImpPie(oPrinter,oXML)
	oPrinter:Say( 820,275,CVALTOCHAR((nPag+=1))+"/"+CVALTOCHAR(nHojas),oFont3) //
	IF nIniFact<>0

		U_usigPag(oPrinter,oXML)
		U_uDetFact(oPrinter,oXML,nIniFact,nHojas)

	ENDIF

Return Nil

/*/{Protheus.doc} uImpItem
Impresión de datos de items
@author TOTVS
@version 1.0
@param oPrinter, objeto, objeto creado por FWMSPrinter.
@param oItem, objeto, objeto con información del item
/*/
User Function uImpItem(oPrinter, oItem)
	Local cCodPro	:= ""
	Local cDescr	:= ""
	Local cUniMed	:= ""
	Local cCant		:= ""
	Local cPreUni	:= ""
	Local cDesc		:= ""
	Local cValVent	:= ""
	Local cTasaIVA	:= ""

	Local nCod 		:= 25
	Local nDescr 	:= 65
	Local nUniMed	:= 203
	Local nLinPro:=0
	Local aNum:={}
	Local nLinAux1:=0

	Local nLinCod:=0
	Local nLinCant:=0
	Local nLinFinCod:=0
	Local nLinFinPre:=0
	Local nLinFinDes:=0
	Local nLinFinIVA:=0
	


	cCodPro 	:= oItem:_DCODINT:TEXT
	cDescr		:= oItem:_DDESPROSER:TEXT
	cUniMed		:= oItem:_DDESUNIMED:TEXT
	cCant		:= U_uMoneda(  oItem:_DCANTPROSER:TEXT,cXmlMoe,.F.,nTamCant)

	cCant		:=	ALLTRIM(Transform(VAL(cCant),"@E 99,999,999,999.99"))//es el unico elemento que se deja en decimales cuando es guaranies

	cPreUni		:= U_uMoneda( oItem:_GVALORITEM:_DPUNIPROSER:TEXT,cXmlMoe,.T.)

	cPreUni		:=	ALLTRIM(Transform(VAL(cPreUni),cPicture))
	cDesc		:= U_uMoneda( oItem:_GVALORITEM:_GVALORRESTAITEM:_DDESCITEM:TEXT,cXmlMoe,.T.)
	
	cDesc		:=	ALLTRIM(Transform(VAL(cDesc),cPicture))

	cValVent	:= U_uMoneda(oItem:_GVALORITEM:_GVALORRESTAITEM:_DTOTOPEITEM:TEXT,cXmlMoe,.T.)
	
	cValVent	:=	ALLTRIM(Transform(VAL(cValVent),cPicture))
	cTasaIVA	:= oItem:_GCAMIVA:_DTASAIVA:TEXT

	nLinAux1:=nLinea+10
	nLinFinCod:=nLinAux1

	nLinCod:=U_uLeyendas(cCodPro,10,@nLinFinCod-10,nCod,oPrinter,10,oFont9,.T.)
	nLinFinCod+=(nLinCod*10)// la división del código es la más pequeña necesita sumarle 10 a cada línea en caso de tener más líneas
	U_uLeyendas(cDescr,29,@nLinea,nDescr,oPrinter,10,oFont9)

	oPrinter:Say( nLinAux1,nUniMed,cUniMed,oFont9) //Unidad de medida
	nLinCant:= nLinAux1+2
	nLinPro:=U_uLeyendas( cCant,16,@nLinCant-10,(252-(U_ulonVisu(cCant))),oPrinter,8,oFont9,.T.,.T.)
	nLinCant+=(nLinPro*5)
	
	nLinFinPre:= nLinAux1+2
	nLinPro:=U_uLeyendas( cPreUni,25,@nLinFinPre-10,(310-(U_ulonVisu(cPreUni))),oPrinter,8,oFont9,.T.,.T.)
	nLinFinPre+=(nLinPro*5)


	nLinFinDes:= nLinAux1+2
	nLinPro:=U_uLeyendas( cDesc,12,@nLinFinDes-10,(368-(U_ulonVisu(cDesc))),oPrinter,8,oFont9,.T.,.T.)
	nLinFinDes+=(nLinPro*5)


	If Val(cTasaIVA) == 0
		nLinFinIVA:= nLinAux1+2
		nLinPro:=U_uLeyendas( cValVent,25,@nLinFinIVA-10,(418-(U_ulonVisu(cValVent))),oPrinter,8,oFont9,.T.,.T.)
		nLinFinIVA+=(nLinPro*5)
	ElseIf Val(cTasaIVA) == 5
		nLinFinIVA:= nLinAux1+2
		nLinPro:=U_uLeyendas( cValVent,25,@nLinFinIVA-10,(478-(U_ulonVisu(cValVent))),oPrinter,8,oFont9,.T.,.T.)
		nLinFinIVA+=(nLinPro*5)

	ElseIf Val(cTasaIVA) == 10
		
		nLinFinIVA:= nLinAux1+2
		nLinPro:=U_uLeyendas( cValVent,25,@nLinFinIVA-10,(538-(U_ulonVisu(cValVent))),oPrinter,8,oFont9,.T.,.T.)
		nLinFinIVA+=(nLinPro*5)

	EndIf
	
	
	aNum:={nLinFinCod,nLinea,nLinCant,nLinFinPre,nLinFinIVA}
	aNum:=ASORT(aNum,,, { |x, y| x > y } )  //saltos(aNum) // se verifica la cantidad mayor en base a esto se hace el salto para el inicio del sig, item
	nLinea:=aNum[1]+4 

Return Nil

/*/{Protheus.doc} uDetRem
Imprimir detalle de reporte de remitos
@author TOTVS
@version 1.0
@param oPrinter, objeto, objeto creado por FWMSPrinter.
@param oXml, Objeto con estructura de archivo XML.
@return N/A
/*/
User Function uDetRem(oPrinter,oXML)
Local nMLText	:= 25
Local nMRText	:= 340

Local oXmlItem	:= Nil
//Datos del traslado
Local cRespEm	:= ""
Local cFecInT	:= ""
Local cFecFnT	:= ""
Local cDirPtoP	:= ""
Local cCiuPtoP	:= ""
Local cDepPtoP	:= ""
Local cKmEst	:= ""
Local cNoCasS	:= ""
Local cNoCasE	:= ""
//Datos del vehiculo del transporte
Local cTipTrans	:= ""
Local cModTrans	:= ""
Local cRespCosF	:= ""
Local cCondNeg	:= ""
Local cMarcaV	:= ""
Local cNoIdVe	:= ""
Local cNoMatVe	:= ""
Local cTipoVe	:= ""
//Datos del conductor del vehiculo
Local cNatTran	:= ""
Local cNomTran	:= ""
Local cNumDocCh	:= ""
Local cNomCh	:= ""
Local cNomAgen	:= ""
Local cDocId	:= ""
Local cDir		:= ""
Local cKM		:= ""
	If XmlChildEx(oXml:_RDE, '_DE') <> Nil
		If XmlChildEx(oXml:_RDE:_DE, '_GDTIPDE') <> Nil
		
			If XmlChildEx(oXml:_RDE:_DE:_GDTIPDE, '_GTRANSP') <> Nil
				If XmlChildEx(oXml:_RDE:_DE:_GDTIPDE:_GTRANSP, '_DINITRAS') <> Nil
					cFecInT := oXml:_RDE:_DE:_GDTIPDE:_GTRANSP:_DINITRAS:TEXT
				EndIf
				
				If XmlChildEx(oXml:_RDE:_DE:_GDTIPDE:_GTRANSP, '_DFINTRAS') <> Nil
					cFecFnT := oXml:_RDE:_DE:_GDTIPDE:_GTRANSP:_DFINTRAS:TEXT
				EndIf
				
				If XmlChildEx(oXml:_RDE:_DE:_GDTIPDE:_GTRANSP, '_DKMR') <> Nil
					cKmEst := oXml:_RDE:_DE:_GDTIPDE:_GTRANSP:_DKMR:TEXT
				EndIf
				
				If XmlChildEx(oXml:_RDE:_DE:_GDTIPDE:_GTRANSP, '_GCAMSAL') <> Nil
					If XmlChildEx(oXml:_RDE:_DE:_GDTIPDE:_GTRANSP:_GCAMSAL, '_DDIRLOCSAL') <> Nil
						cDirPtoP := oXml:_RDE:_DE:_GDTIPDE:_GTRANSP:_GCAMSAL:_DDIRLOCSAL:TEXT
					EndIf
					
					If XmlChildEx(oXml:_RDE:_DE:_GDTIPDE:_GTRANSP:_GCAMSAL, '_DDESCIUSAL') <> Nil
						cCiuPtoP := oXml:_RDE:_DE:_GDTIPDE:_GTRANSP:_GCAMSAL:_DDESCIUSAL:TEXT
					EndIf
					
					If XmlChildEx(oXml:_RDE:_DE:_GDTIPDE:_GTRANSP:_GCAMSAL, '_DDESDEPSAL') <> Nil
						cDepPtoP := oXml:_RDE:_DE:_GDTIPDE:_GTRANSP:_GCAMSAL:_DDESDEPSAL:TEXT
					EndIf
					
					If XmlChildEx(oXml:_RDE:_DE:_GDTIPDE:_GTRANSP:_GCAMSAL, '_DNUMCASSAL') <> Nil
						cNoCasS := oXml:_RDE:_DE:_GDTIPDE:_GTRANSP:_GCAMSAL:_DNUMCASSAL:TEXT
					EndIf
				EndIf
				
				If XmlChildEx(oXml:_RDE:_DE:_GDTIPDE:_GTRANSP, '_GCAMENT') <> Nil
					If XmlChildEx(oXml:_RDE:_DE:_GDTIPDE:_GTRANSP:_GCAMENT, '_DNUMCASENT') <> Nil
						cNoCasE := oXml:_RDE:_DE:_GDTIPDE:_GTRANSP:_GCAMENT:_DNUMCASENT:TEXT
					EndIf
				EndIf
				
				If XmlChildEx(oXml:_RDE:_DE:_GDTIPDE:_GTRANSP, '_ITIPTRANS') <> Nil
					cTipTrans := oXml:_RDE:_DE:_GDTIPDE:_GTRANSP:_ITIPTRANS:TEXT
				EndIf
				
				If XmlChildEx(oXml:_RDE:_DE:_GDTIPDE:_GTRANSP, '_DDESMODTRANS') <> Nil
					cModTrans := oXml:_RDE:_DE:_GDTIPDE:_GTRANSP:_DDESMODTRANS:TEXT
				EndIf
				
				If XmlChildEx(oXml:_RDE:_DE:_GDTIPDE:_GTRANSP, '_IRESPFLETE') <> Nil
					cRespCosF := oXml:_RDE:_DE:_GDTIPDE:_GTRANSP:_IRESPFLETE:TEXT
					cRespCosF := AllTrim(ObtColSAT("S027", cRespCosF, 1, 1, 2, 55))
				EndIf
				
				If XmlChildEx(oXml:_RDE:_DE:_GDTIPDE:_GTRANSP, '_CCONDNEG') <> Nil
					cCondNeg := oXml:_RDE:_DE:_GDTIPDE:_GTRANSP:_CCONDNEG:TEXT
					cCondNeg := AllTrim(ObtColSAT("S010", cCondNeg, 1, 3, 4, 33))
				EndIf
				
				If XmlChildEx(oXml:_RDE:_DE:_GDTIPDE:_GTRANSP, '_GVEHTRAS') <> Nil
					If XmlChildEx(oXml:_RDE:_DE:_GDTIPDE:_GTRANSP:_GVEHTRAS, '_DMARVEH') <> Nil
						cMarcaV := oXml:_RDE:_DE:_GDTIPDE:_GTRANSP:_GVEHTRAS:_DMARVEH:TEXT
					EndIf
					
					If XmlChildEx(oXml:_RDE:_DE:_GDTIPDE:_GTRANSP:_GVEHTRAS, '_DNROIDVEH') <> Nil
						cNoIdVe := oXml:_RDE:_DE:_GDTIPDE:_GTRANSP:_GVEHTRAS:_DNROIDVEH:TEXT
					EndIf
					
					If XmlChildEx(oXml:_RDE:_DE:_GDTIPDE:_GTRANSP:_GVEHTRAS, '_DNROMATVEH') <> Nil
						cNoMatVe := oXml:_RDE:_DE:_GDTIPDE:_GTRANSP:_GVEHTRAS:_DNROMATVEH:TEXT
					EndIf
					
					If XmlChildEx(oXml:_RDE:_DE:_GDTIPDE:_GTRANSP:_GVEHTRAS, '_DTIVEHTRAS') <> Nil
						cTipoVe := oXml:_RDE:_DE:_GDTIPDE:_GTRANSP:_GVEHTRAS:_DTIVEHTRAS:TEXT
					EndIf
				EndIf
				
				If XmlChildEx(oXml:_RDE:_DE:_GDTIPDE:_GTRANSP, '_GCAMTRANS') <> Nil
					If XmlChildEx(oXml:_RDE:_DE:_GDTIPDE:_GTRANSP:_GCAMTRANS, '_INATTRANS') <> Nil
						cNatTran := oXml:_RDE:_DE:_GDTIPDE:_GTRANSP:_GCAMTRANS:_INATTRANS:TEXT
						
						If cNatTran == "1"
							cNatTran := STR0087
						ElseIf cNatTran == "2"
							cNatTran := STR0088
						Else
							cNatTran := ""
						EndIf                                                                                             
					EndIf
					
					If XmlChildEx(oXml:_RDE:_DE:_GDTIPDE:_GTRANSP:_GCAMTRANS, '_DNOMTRANS') <> Nil
						cNomTran := oXml:_RDE:_DE:_GDTIPDE:_GTRANSP:_GCAMTRANS:_DNOMTRANS:TEXT
					EndIf
					
					If XmlChildEx(oXml:_RDE:_DE:_GDTIPDE:_GTRANSP:_GCAMTRANS, '_DNUMIDCHOF') <> Nil
						cNumDocCh := oXml:_RDE:_DE:_GDTIPDE:_GTRANSP:_GCAMTRANS:_DNUMIDCHOF:TEXT
					EndIf
					
					If XmlChildEx(oXml:_RDE:_DE:_GDTIPDE:_GTRANSP:_GCAMTRANS, '_DNOMCHOF') <> Nil
						cNomCh := oXml:_RDE:_DE:_GDTIPDE:_GTRANSP:_GCAMTRANS:_DNOMCHOF:TEXT
					EndIf
					
					If XmlChildEx(oXml:_RDE:_DE:_GDTIPDE:_GTRANSP:_GCAMTRANS, '_DNOMBAG') <> Nil
						cNomAgen := oXml:_RDE:_DE:_GDTIPDE:_GTRANSP:_GCAMTRANS:_DNOMBAG:TEXT
					EndIf
					
					If XmlChildEx(oXml:_RDE:_DE:_GDTIPDE:_GTRANSP:_GCAMTRANS, '_DRUCAG') <> Nil
						cDocId := oXml:_RDE:_DE:_GDTIPDE:_GTRANSP:_GCAMTRANS:_DRUCAG:TEXT
					EndIf
					
					If XmlChildEx(oXml:_RDE:_DE:_GDTIPDE:_GTRANSP:_GCAMTRANS, '_DDOMFISC') <> Nil
						cDir := oXml:_RDE:_DE:_GDTIPDE:_GTRANSP:_GCAMTRANS:_DDOMFISC:TEXT
					EndIf
					
				EndIf
				
			EndIf
			
			If XmlChildEx(oXml:_RDE:_DE:_GDTIPDE, '_GCAMNRE') <> Nil
				If XmlChildEx(oXml:_RDE:_DE:_GDTIPDE:_GCAMNRE, '_DDESRESPEMINR') <> Nil
					cRespEm := oXml:_RDE:_DE:_GDTIPDE:_GCAMNRE:_DDESRESPEMINR:TEXT
					cKM := oXml:_RDE:_DE:_GDTIPDE:_GCAMNRE:_DKMR:TEXT
				EndIf
			EndIf
			
			If XmlChildEx(oXml:_RDE:_DE:_GDTIPDE, '_GCAMITEM') <> Nil
				oXmlItem := oXml:_RDE:_DE:_GDTIPDE:_GCAMITEM
			EndIf
		EndIf
	EndIf

	nLinea += 10
	oPrinter:Box( nLinea, nML, nLinea+105, 575, "-4")
	
	nLinea += 15
	oPrinter:Say(nLinea,230,STR0059,oFont6) //"DATOS DEL TRASLADO"
	
	nLinea += 10
	oPrinter:Say(nLinea,nMLText,STR0060 + cRespEm,oFont8) //"Responsable de la emisión: "
	
	nLinea += 10
	oPrinter:Say(nLinea,nMLText,STR0061 + cFecInT,oFont8) //"Fecha estimada de inicio del traslado: "
	oPrinter:Say(nLinea,nMRText,STR0062 + cFecFnT,oFont8) //"Fecha estimada de fin de traslado: "
	
	nLinea += 10
	//oPrinter:Say(nLinea,nMLText,STR0063 + cDirPtoP,oFont8) //"Dirección del Punto de Partida: "
	cResto:=SubStr(STR0063 + cDirPtoP,1,100)
	oPrinter:Say(nLinea,nMLText,cResto,oFont8)
	cResto:=SubStr(cDirPtoP,101,len(cDirPtoP))
	U_uLeyendas(cResto,100,@nLinea,nMLText,oPrinter,10,oFont8)
	
	nLinea += 10
	oPrinter:Say(nLinea,nMLText,STR0064 + cCiuPtoP,oFont8) //"Ciudad del punto de partida: "
	oPrinter:Say(nLinea,nMRText,STR0065 + cDepPtoP,oFont8) //"Departamento del punto de partida: "
	
	nLinea += 10
	oPrinter:Say(nLinea,nMLText,STR0066 + cKmEst,oFont8) //"Kilómetros estimados de recorrido: "
	
	nLinea += 10
	oPrinter:Say(nLinea,nMLText,STR0067 + cNoCasS,oFont8) //"N° de casa de salida: "
	
	nLinea += 10
	oPrinter:Say(nLinea,nMLText,STR0068 + cNoCasE,oFont8) //"N° de casa de la entrega: "
	
	nLinea += 13
	oPrinter:Box( nLinea, nML, nLinea+138, 575, "-4")
	
	nLinea += 13
	oPrinter:Say(nLinea,200,STR0069,oFont6) //"DATOS DEL VEHICULO DEL TRANSPORTE"
	
	nLinea += 10
	oPrinter:Say(nLinea,nMLText,STR0070 + cTipTrans,oFont8) //"Tipo de transporte: "
	
	nLinea += 10
	oPrinter:Say(nLinea,nMLText,STR0071 + cModTrans,oFont8) //"Modalidad del transporte: "
	
	nLinea += 10
	oPrinter:Say(nLinea,nMLText,STR0072 + cRespCosF,oFont8) //"Responsable del costo del flete: "
	
	nLinea += 10
	oPrinter:Say(nLinea,nMLText,STR0073 + cCondNeg,oFont8) //"Condición de la negociación: "
	
	nLinea += 10
	oPrinter:Say(nLinea,nMLText,STR0061 + cFecInT,oFont8) //"Fecha estimada de inicio del traslado: "
	
	nLinea += 10
	oPrinter:Say(nLinea,nMLText,STR0062 + cFecFnT,oFont8) //"Fecha estimada de fin de traslado: "
	
	nLinea += 10
	oPrinter:Say(nLinea,nMLText,STR0074 + cMarcaV,oFont8) //"Marca del vehículo: "
	
	nLinea += 10
	oPrinter:Say(nLinea,nMLText,STR0075 + cNoIdVe,oFont8) //"N° de identificación del vehículo: "
	
	nLinea += 10
	oPrinter:Say(nLinea,nMLText,STR0076 + cNoMatVe,oFont8) //"N° de matrícula (chapa) del vehículo: "
	
	nLinea += 10
	oPrinter:Say(nLinea,nMLText,STR0077 + cTipoVe,oFont8) //"Tipo de vehículo: "
	
	nLinea += 10
	oPrinter:Say(nLinea,nMLText,"Distancia Recorrida" + cKM,oFont8) //"Dist.
	
	nLinea += 10
	oPrinter:Box( nLinea, nML, nLinea+103, 575, "-4")
	nLinea += 15
	oPrinter:Say(nLinea,200,STR0078,oFont6) //"DATOS DEL VEHICULO DEL TRANSPORTE"
	
	nLinea += 10
	oPrinter:Say(nLinea,nMLText,STR0079 + cNatTran,oFont8) //"Naturaleza del transportista: "
	
	nLinea += 10
	oPrinter:Say(nLinea,nMLText,STR0080 + cNomTran,oFont8) //"Nombre o razón social del transportista: "
	
	nLinea += 10
	oPrinter:Say(nLinea,nMLText,STR0081 + cNumDocCh,oFont8) //"Número de documento de indentidad del chofer: "
	
	nLinea += 10
	oPrinter:Say(nLinea,nMLText,STR0082 + cNomCh,oFont8) //"Nombre y apellido del chofer: "
	
	nLinea += 10
	oPrinter:Say(nLinea,nMLText,STR0083 + cNomAgen,oFont8) //"Nombre o razón social del agente: "
	
	nLinea += 10
	oPrinter:Say(nLinea,nMLText,STR0024 + cDocId,oFont8) //"RUC/Documento de Identidad No: "
	
	nLinea += 10
	oPrinter:Say(nLinea,nMLText,STR0026 + cDir,oFont8) //"Dirección: "
	
	nLinea += 5
	U_uProdRem(oPrinter,oXmlItem,0,oXml,cDir,1)

	
Return Nil

/*/{Protheus.doc} U_uImItemR
Impresión de datos de items
@author TOTVS
@version 1.0
@param oPrinter, objeto, objeto creado por FWMSPrinter.
@param oItem, objeto, objeto con información del item
/*/

User Function uImItemR(oPrinter, oItem)
Local cDescr	:= ""
Local cUniMed	:= ""
Local cCant		:= ""

Local nCant		:= 35
Local nUniMed	:= 95
Local nDescr 	:= 215
Local nLinPro	:=0
Local nLinAux	:=0

	cCant		:= oItem:_DCANTPROSER:TEXT
	cUniMed		:= oItem:_DDESUNIMED:TEXT
	cDescr		:= oItem:_DDESPROSER:TEXT
	
	nLinea += 5
	
	

	nLinPro:=U_uLeyendas(cDescr,80,@nLinea,nDescr,oPrinter,9,oFont9)
	nLinAux:=nLinea //respaldando valor del eje "y" afectado por la leyenda de producto

	IF nLinPro >1 // se modifica el valor del eje "y" para que lo tomen los items de forma centrada
		nLinea:= nLinea-(10*(nLinPro/2))
	ENDIF

	oPrinter:Say( nLinea,nCant	,PADL(cCant,4)	,oFont9) //Cantidad
	oPrinter:Say( nLinea,nUniMed,cUniMed,oFont9) //Unidad de medida
	
	nLinea:= nLinAux;


Return Nil

/*/{Protheus.doc} uImpPie
Imprimir pie de reporte de factura a partir de XML
@author TOTVS
@version 1.0
@param oPrinter, objeto, objeto creado por FWMSPrinter.
@param oXml, Objeto con estructura de archivo XML.
@return N/A
/*/
User Function uImpPie(oPrinter,oXml)
	Local nMLText	:= 25
	Local nMRText	:= 85
	Local cTextQR	:= ""

	If XmlChildEx( oXml:_RDE, '_GCAMFUFD') <> Nil
		cTextQR	:= oXml:_RDE:_GCAMFUFD:_DCARQR:TEXT //dEmailRec
	EndIf
	
	//nLinea += 5
	oPrinter:Box( nLinea, nML, nLinea+130, 575, "-4")
	
	nLinea += 15
	oPrinter:QRCode(nLinea+115,nMLText-4,cTextQR, 130)
	
	nLinea += 5
	oPrinter:Say(nLinea,nMRText+65,cLetPie,oFont7) //
	
	nLinea += 15
	oPrinter:Say(nLinea,nMRText+65,STR0045,oFont7) //"https://ekuatia.set.gov.py/consultas/"

	If XmlChildEx(oXml:_RDE, '_DE') <> Nil
		oPrinter:Say(nLinea+30,nMRText+65,"CDC:"+Upper(oXml:_RDE:_DE:_ID:TEXT),oFont7)
	ENDIF
	
	nLinea += 50
	oPrinter:Say(nLinea,nMLText+125,STR0047,oFont7) //"ESTE DOCUMENTO ES UNA REPRESENTACIÓN GRAFICA DE UN DOCUMENTO ELECTRÓNICO (XML)"
	
	nLinea += 10
	oPrinter:Say(nLinea,nMLText+125,STR0048,oFont3) //"Información de interés del facurador electrónico emisor."
	
	nLinea += 10
	oPrinter:Say(nLinea,nMLText+125,STR0049,oFont3) //"Si su documento electrónico presenta algún error, podrá solicitar la modificación dentro de las "
	
	nLinea += 10
	oPrinter:Say(nLinea,nMLText+125,STR0050,oFont3) //"72 horas siguientes de la emisión de este comprobante."
	
Return Nil

/*/{Protheus.doc} U_uSaltoPag
Genera salto de página en reporte
@author TOTVS
@version 1.0
@param oPrinter, objeto, objeto creado por FWMSPrinter.
/*/
User Function uSaltoPag(oPrinter)

	oPrinter:Line(nLinea,nML,nLinea,575,,"-4")

	oPrinter:EndPage()
	oPrinter:StartPage()

Return Nil

/*/{Protheus.doc} U_uCargaLog
Carga logo de la empresa
@author TOTVS
@version 1.0
@return cLogo .- Retorna url de ubicación de logo de empresa.
/*/
User Function uCargaLog()
	Local  cStartPath:= GetSrvProfString("Startpath","")
	//-- Logotipo da Empresa
	cLogo := cStartPath + "lgrl"+ALLTRIM(SM0->M0_CODIGO)+ALLTRIM(SM0->M0_CODFIL)+".BMP" // Empresa+Filial

	If !File( cLogo )
		cLogo := cStartPath + "lgrl"+ALLTRIM(SM0->M0_CODIGO)+".BMP" 
	ENDIF
	If !File( cLogo )
		cLogo := cStartPath + "lgrl"+".BMP" 
	EndIf
Return cLogo

/*/{Protheus.doc uMoneda
    con esta funcion se formatea los decimales en la visualizacion 
    @author TOTVS
    @version 1.01
    @param cValor, carácter, valor al cual se le modifican los decimales
    @param cMoneda, carácter, indica el numero de moneda
    @param lMVCENT, booleano, si es “.T.” se agregan los decimales al valor informado dependiendo de la moneda 
							  y el valor regresado por MsDecimais
							 si es “.F.” solo se quitan los decimales o se agregan
							 los informados en nDecDef
	@param nDecDef, numerico, se pueden definir los decimales siempre y cuando este en .F. lMVCENT
    @return cValor, carácter, valor al cual se le formateo los decimales	
/*/
User Function uMoneda(cValor,cMoneda,lMVCENT,nDecDef)

Local nCentavos:=MsDecimais(cMoneda)
	
	If lMVCENT
		cValor:= CVALTOCHAR(NOROUND( VAL(cValor), nCentavos ))
	ELSE
		IF nDecDef<> nil .or. nDecDef>0
			cValor:= CVALTOCHAR(NOROUND( VAL(cValor), nDecDef ))
		ENDIF
	ENDIF
		
Return cValor

 /*/{Protheus.doc} U_uLeyendas
	Esta función se utiliza para dividir una texto en varias líneas de acuerdo a los parámetros
	y posteriormente imprimir el  texto dentro del pdf
	@author TOTVS
    @param cDescr,caracter, leyenda a tratar
    @param nMaxLin,numerico, tamaño máximo de la línea(tomando en cuenta que es horizontal eje x cuadrante I)
    @param nLinea, numerico, en donde empieza la línea (tomando en cuenta al eje y en el cuadrante IV)
	@param nDescr, numerico, punto de inicio en "x")
	@param oPrinter, objeto, objeto para acceder a las propiedades del pdf
	@param nNumSalto, numerico, tamaño del interlineado
	@param oFont, objeto, fuente
	@param lPrint, booleano, indica si imprime el texto
	@param lAltXSal, booleano, indica si se altera el eje Y en caso de que la cadena necesite quebrarse, se usa principalmente en cantidades numericas
	@return total de lines ocupadas por la leyenda
	/*/
User Function uLeyendas(cDescr,nMaxLin,nLinea,nDescr,oPrinter,nNumSalto,oFont,lPrint,lAltXSal)
	Local nTotLiDes:=0
	Local nResiduo:=0
	Local nLin:=0

	Local nTotCad:=0
	Local nTotAux:=0
	Local nMaxAux:=0
	Local nInicio:=1
	Local cAux:=""
	Local cDescAux:=""
	
	Default cDescr=""
	Default nMaxlin=0
	DEFAULT nLinea:=0
	DEFAULT nDescr:=0
	DEFAULT oPrinter:= NIL
	DEFAULT nNumsalto:=0
	DEFAULT oFont:= NIL
	DEFAULT lPrint:=.T.
	DEFAULT lAltXSal:=.F.


	IF !Empty(cDescr)
		nMaxLin-=1 //evito tocar margen cuando so puras mayusculas
		nTotCad:= U_ulonVisu(cDescr)
		//Descripción del producto: tratamiento para evitar que se salgan del tamñaño del campo descripcion
		nTotLiDes:= ROUND(( nTotCad/nMaxLin),0)//numero de lineas(linea completa tamaño nMaxLin) que caben en la descripcion
		nResiduo:=( nTotCad/nMaxLin)-nTotLiDes // por redondeos se necesita saber si hay una linea incompleta(linea completa de tamaño nMaxLin)

		For nLin := 1 To nTotLiDes
			cDescAux		:= SubStr(cDescr, nInicio, nMaxlin)

			nTotAux:= ROUND(U_ulonVisu(cDescAux),0)

			if nTotAux> 	nMaxLin
				nMaxAux:=nMaxLin-(nTotAux-nMaxlin)
				cDescAux		:= SubStr(cDescr,nInicio,nMaxAux)
				cAux+=cDescAux
				nInicio:=nInicio+nMaxAux

			else
				cDescAux		:= SubStr(cDescr,nInicio, nMaxLin)
				cAux+=cDescAux
				nInicio:=nInicio+nMaxLin
			ENDIF
				
			nLinea += nNumSalto
			
			IF lPrint
			oPrinter:Say( nLinea,nDescr +(iif(lAltXSal .and. nLin>1,nMaxLin-U_ulonVisu(cDescAux),0) )	,cDescAux,oFont)
			ENDIF

		NEXT nLin 

		If nResiduo>0 // linea que no cubre el tamaño de 25

			cDescAux		:= SubStr(cDescr, len(cAux)+1, len(cDescr))				
			nLinea += nNumSalto
			
			IF lPrint
				oPrinter:Say( nLinea,nDescr +(iif(lAltXSal .and. nLin>1,nMaxLin-U_ulonVisu(cDescAux),0) )	,cDescAux,oFont)
			ENDIF
			
		ENDIF
	ENDIF
Return (nTotLiDes+nResiduo)


/*/{Protheus.doc} 
	U_ucalLi función para indicar el numero de líneas  en las que se puede dividir
	@author TOTTVS
	@param cDescr, descripcion, leyenda a dividir en lineas
	@param nMaxLin,numerico, tamaño máximo de la línea(tomando en cuenta que es horizontal eje x cuadrante I)
	@return nTotLiDes, numerico, lineas que se crean al dividir las U_uLeyendas
	/*/
User Function ucalLi(cDescr,nMaxLin)
Local nTotLiDes:=0
Default cDescr=""
Default nMaxlin=""

	nTotLiDes:= Len(cDescr)/nMaxLin//numero de lineas(linea completa tamaño 25) que caben en la descripcion 
	
Return nTotLiDes

/*/{Protheus.doc} U_usigPag
	@crea una pagina siguiente
	@author TOTVS
	@parama oPrinter, objeto, objeto para acceder a las propiedades del pdf
	@parama oXML, objeto, objeto para acceder a las propiedades del xml
	@return nil
/*/
User Function usigPag(oPrinter,oXML)
nLinea:=9
oPrinter:EndPage()
oPrinter:StartPage()

Return nil

/*/{Protheus.doc} U_utotales
    @pinta la información referente a los totales y pie de pagina(QR)
	@author TOTVS
	@version version
	@parama oPrinter, objeto, objeto para acceder a las propiedades del pdf
	@parama oXML, objeto, objeto para acceder a las propiedades del xml
	@return nil
/*/
User Function utotales(oPrinter,oXml)
Local nMLText	:= 25
Local nFin		:= 0
Local cSubTotal	:= ""
Local cTotal	:= ""
Local cTotGua	:= ""
Local cIVA5		:= ""
Local cIVA10	:= ""
Local cTotIVA	:= ""
Local cAuxSubTot:=""
Local cAuxTot:=""
Local cAuToIva:=""
Local cAuxTGua	:= ""

cPicture := IIF(MsDecimais(cXmlMoe)==0,"@E 99,999,999,999","@E 99,999,999,999.99")
	If XmlChildEx(oXml:_RDE, '_DE') <> Nil
		If XmlChildEx(oXml:_RDE:_DE, '_GTOTSUB') <> Nil
			If XmlChildEx(oXml:_RDE:_DE:_GTOTSUB, '_DTOTGRALOPE') <> Nil
				cSubTotal	:= U_uMoneda(oXml:_RDE:_DE:_GTOTSUB:_DTOTGRALOPE:TEXT,cXmlMoe,.T.)
				cAuxSubTot:=cSubTotal
				cSubTotal:=ALLTRIM(Transform(VAL(cSubTotal),cPicture))
			EndIf
			If XmlChildEx(oXml:_RDE:_DE:_GTOTSUB, '_DTOTGRALOPE') <> Nil
				cTotal		:=U_uMoneda(oXml:_RDE:_DE:_GTOTSUB:_DTOTGRALOPE:TEXT,cXmlMoe,.T.) 
				cAuxTot:=cTotal
				cTotal:=ALLTRIM(Transform(VAL(cTotal),cPicture))
			EndIf
			If XmlChildEx(oXml:_RDE:_DE:_GTOTSUB, '_DTOTGRALOPE') <> Nil
				cTotGua		:= U_uMoneda(oXml:_RDE:_DE:_GTOTSUB:_DTOTGRALOPE:TEXT,cXmlMoe,.T.) 
				cAuxTGua:=cTotGua
				cTotGua:=ALLTRIM(Transform(VAL(cTotGua),cPicture))
			EndIf
			If XmlChildEx(oXml:_RDE:_DE:_GTOTSUB, '_DIVA5') <> Nil
				cIVA5		:= U_uMoneda(oXml:_RDE:_DE:_GTOTSUB:_DIVA5:TEXT,cXmlMoe,.T.) 
				cIVA5:=ALLTRIM(Transform(VAL(cIVA5),cPicture))
			EndIf
			If XmlChildEx(oXml:_RDE:_DE:_GTOTSUB, '_DIVA10') <> Nil
				cIVA10		:= U_uMoneda(oXml:_RDE:_DE:_GTOTSUB:_DIVA10:TEXT,cXmlMoe,.T.) 
				cIVA10:=ALLTRIM(Transform(VAL(cIVA10),cPicture))
			EndIf
			If XmlChildEx(oXml:_RDE:_DE:_GTOTSUB, '_DTOTIVA') <> Nil
				cTotIVA		:= U_uMoneda(oXml:_RDE:_DE:_GTOTSUB:_DTOTIVA:TEXT,cXmlMoe,.T.) 
				cAuToIva:=	cTotIVA
				cTotIVA:=ALLTRIM(Transform(VAL(cTotIVA),cPicture))
			EndIf
		EndIf
		/*If XmlChildEx(oXml:_RDE:_DE, '_GDTIPDE') <> Nil
			oXmlItem := oXml:_RDE:_DE:_GDTIPDE:_GCAMITEM
		EndIf */
	EndIf
		//Lineas de división

	
	//SUBTOTAL
	oPrinter:Box( nLinea	, nML, nLinea+20, 575, "-4")
	oPrinter:Say( nLinea +10,nMLText,STR0039,oFont3)
	U_uinvetCad(cSubTotal,nLinea +10,570	,.T.,oFont3,oPrinter)
	//TOTAL DE LA OPERACION
	nLinea += 15
	oPrinter:Box( nLinea	, nML, nLinea+20, 575, "-4")
	oPrinter:Say( nLinea +10,nMLText,STR0040,oFont3) 
	
	U_uinvetCad(cTotal,nLinea +10,570	,.T.,oFont3,oPrinter)
	//TOTAL EN GUARANIES
	nLinea += 15
	oPrinter:Box( nLinea	, nML, nLinea+20, 575, "-4")
	oPrinter:Say( nLinea +10,nMLText,STR0041,oFont3)
	If cXmlMoe==1
		U_uinvetCad(cTotGua,nLinea +10,570	,.T.,oFont3,oPrinter)
	ELSE
		U_uinvetCad(ALLTRIM(Transform(ROUND((VAL(cAuxTGua)*VAL(oXml:_RDE:_DE:_GDATGRALOPE:_GOPECOM:_DTICAM:TEXT)),MsDecimais(1) ),cPicture)),nLinea +10,570	,.T.,oFont3,oPrinter)
	ENDIF
	
	//LIQUIDACION IVA
	nLinea += 15
	oPrinter:Box( nLinea	, nML, nLinea+20, 575, "-4")
	oPrinter:Say( nLinea +10,nMLText,STR0042,oFont3)
	
	oPrinter:Say( nLinea +10,165,"(" + STR0037 + ")",oFont3) //(5%)
	oPrinter:Say( nLinea +10,200,PADL(cIVA5,16),oFont3)
	
	oPrinter:Say( nLinea +10,260,"(" + STR0038 + ")",oFont3) //(10%)
	oPrinter:Say( nLinea +10,305,PADL(cIVA10,16),oFont3)
	
	oPrinter:Say( nLinea +10,455,STR0056,oFont3)
	
	U_uinvetCad(cTotIVA,nLinea +10,570	,.T.,oFont3,oPrinter)
	//	cTotIVA
	nLinea += 15
	nFin	:= nLinea
	
	
Return nil

/*/{Protheus.doc} U_uProdRem
	Funcion usada para la paginación
	@author TOTVS
	@parama oPrinter, objeto, objeto para acceder a las propiedades del pdf
	@parama oXmlItem, objeto, objeto para acceder a los items 
	@parama nIndice, numerico, numero de item donde se quedo el ciclo cuando existe mas de un item 
	@parama oXML, objeto, objeto para acceder a las propiedades del xml
	@parama cDir, carácter, dirección transportista
	@return nil
/*/
User Function uProdRem(oPrinter,oXmlItem,nIndice,oXml,cDir,nHoj)
Local nMLText:=25
Local nI:=0
Local nInicio	:= 0
Local nLinea1 	:= 80
Local nLinea2	:= 200
Local nIniRem	:=0
Local nHojas	:=nHoj
Local nLimite	:= 672
Local nAux		:=0
nInicio	:= nLinea

nLinea += 10
	nInicio	:= nLinea
	oPrinter:Line( nLinea, nML, nLinea, 575, CLR_BLACK, "-4") //Linea superior
	
	nLinea += 12
	oPrinter:Say(nLinea,nMLText + 10,STR0032,oFont8) //"Cantidad"
	
	oPrinter:Say(nLinea,nMLText + 70,STR0031 +  " " + STR0055,oFont8) //"Unidad de" "medida"
	
	oPrinter:Say(nLinea,nMLText + 190,STR0085 ,oFont8) //"Descripción detallada (incluir cantidad o porcentaje de la tolerancia de quiebra)"
	
	nLinea += 12
	oPrinter:Say(nLinea,nMLText + 190,STR0086,oFont8) //"o merma/datos de relevancia de la mercadería)"
	
	nLinea += 5
	oPrinter:Line( nLinea, nML, nLinea, 575, CLR_BLACK, "-4") //Linea media

	
	If ValType(oXmlItem) == "O"
		U_uImItemR(oPrinter, oXmlItem)
	ElseIf ValType(oXmlItem) == "A"
		IF nIndice==0
			nHojas:=U_utotHojas(oXmlItem,nLinea,48,nLimite,nLimite,80,10,0)
		ENDIF
		For nI := IIF(nIndice<>0,nIndice,1) To Len(oXmlItem)

			nAux:=nLinea  
			nAux+=U_ucalLi(oXmlItem[nI]:_DDESPROSER:TEXT,80)*10
			
			IF nAux < nLimite
				U_uImItemR(oPrinter, oXmlItem[nI])
			ELSE
				nIniRem:=nI
				EXIT
			ENDIF
			
		Next nI
	EndIf
	
	nLinea += 5
	oPrinter:Line( nLinea, nML, nLinea, 575, CLR_BLACK, "-4") //Linea media
	
	//Lineas de división
	oPrinter:Line( nInicio, nML, nLinea, nML, CLR_BLACK, "-4")
	oPrinter:Line( nInicio, 575, nLinea, 575, CLR_BLACK, "-4")
	oPrinter:Line( nInicio, nLinea1, nLinea, nLinea1, CLR_BLACK, "-4")
	oPrinter:Line( nInicio, nLinea2, nLinea, nLinea2, CLR_BLACK, "-4")
	U_uImpPie(oPrinter,oXml)
	oPrinter:Say( 820,275,CVALTOCHAR((nPag+=1))+"/"+CVALTOCHAR(nHojas),oFont3) //

	nLinea += 10
	IF nIniRem<>0
		U_usigPag(oPrinter,oXML)
		U_uProdRem(oPrinter,oXmlItem,nIniRem,oXml,cDir,nHojas)
	ENDIF
	
Return nil

/*/{Protheus.doc} U_utotHojas
	@author TOTVS
	@param oXmlItem, objeto xml, items del xml
	@param nPos1, numerico, posicion de inicio de pintado de items de la primer hoja(lleva más datos)
	@param nPos2, numerico, posicion de inicio de pintado de items de segunda hoja en adelante
	@param nLimIni, numerico, limite de pintado para items en las hojas salvo la ultima
	@param nLimFin, numerico, limite de pintado para items en la ultima hoja
	@param nLinLim, numerico, limite de ancho para las descripción del item
	@param nSalto, numerico, salto entre lineas de las descripcon de los items
	@param nSep, numerico, separación entre items(interlineado)
	@return 
/*/
User Function utotHojas(oXmlItem,nPos1,nPos2,nLimIni,nLimFin,nLinLim,nSalto,nSep)
Local nLinCon:=0
Local nTotal:=0
Local nI:=0
Local nLimite
Local nLinea:=nPos1
Local nHojas:=1

For nI := 1 To Len(oXmlItem)
	IF nI== Len(oXmlItem)

		nLimite:=nLimFin//618
	ELSE
		nLimite:=nLimIni//682
	ENDIF
	nLinCon:=nSep+nLinea 
	nTotal:=((U_ucalLi(oXmlItem[nI]:_DDESPROSER:TEXT,nLinLim)))*nSalto
	nLinCon+=nTotal

	IF (nLinCon)< nLimite// verifico primero si el item no pasa el limite le sumo 200 porel pie de pagina
		nLinea+=nTotal+nSep
	ELSE
		nHojas+=1
		nLinea:=nPos2+nTotal+nSep
	ENDIF
	
Next nI


Return nHojas

			
/*/{Protheus.doc} U_ulonVisu
	cuenta la longitud de una cadena pero al reconocer a algunas letras asigna un valor diferente de 1
	por ejemplo si es "," o "." o "," asignando un valor de 4 ya que al imprimir es el espacio que usa y al usar la función
	LEN solo lo toma como un valor de 1
	@author TOTVS
	@cCadena, caracter, cadena a extraer
	@return nTot, númerico, aproximación de la longitud visual de una cadena
	/*/
User Function ulonVisu(cCadena)

	Local cAux:=""
	Local nLin:=0
	Local nTot:=0
	DEFAULT cCadena:=""

	If	!Empty(cCadena)

		For nLin := 1 To Len(cCadena)
			
			cAux:=	SubStr(cCadena,nLin,1)
			If ASC(cAux  )==87 .or. ASC(cAux  )==81 .or. ASC(cAux  )==85	.or. ASC(cAux )==119 .or. ASC(cAux )==90 .or. ASC(cAux )==112 .or. ASC(cAux )==77
				nTot+=1.4
			Elseif IsUpper(cAux )
				nTot+=1.1
			Elseif  ASC(cAux )==44 .or. ASC(cAux )==46 .or. ASC(cAux)==59
				nTot+=2
			Else
				nTot+=1
			EndIF

		NEXT nLin
	ENDIF	
Return nTot



/*/{Protheus.doc} U_uinvetCad
    PADR y PADL no toman el punto x asignado solo formatea la cadena,
    Por eso a partir del x eje asignado comienza a imprimir la cadena hacia la izquierda, 
    tomando el ultimo carácter para comenzar a imprimir para ello se invierte la cadena
    @author TOTVS
    @param cTextInv, carácter, cadena original a ser invertida
	@param nY, numerico, posición en el eje Y
	@param nX, numerico, posición en el eje X
	@param lImp, booleano, indica si imprime el texto
	@parama oPrinter, objeto, objeto para acceder a las propiedades del pdf
	@parama oFont, objeto, fuente
    @return cTextoInvertido, carácter, la cadena original es invertida
    /*/

User Function uinvetCad(cTextInv, nY,nX,lImp,oFont,oPrinter)

	Local nI:=0
	Local cAux:=0

	DEFAULT cTextInv:=""
	DEFAULT nY=0
	DEFAULT nX:=0
	DEFAULT lImp:=.F.
	DEFAULT oFont:= NIL
	DEFAULT oPrinter:=NIl

	For nI := 1 to LEN(cTextInv) 
		cAux:=	SubStr(cTextInv,(LEN(cTextInv)-nI)+1,1)
		IF lImp
			oPrinter:Say( nY,nX-=4	,cAux,oFont)
		ENDIF
	Next

Return cTextInv
	

User Function TComboBox()
Local cEspecie:=""
Local cCombo	:= ""
Local aCombo	:= {}
Local oDlg		:= Nil
Local oFld		:= Nil
 
aAdd( aCombo, "1.-Factura" ) //"1- Factura"
aAdd( aCombo, "2.-Nota de Débito" ) //"2- debito"
aAdd( aCombo, "3.-Nota de Crédito" ) //"3- credito  "
aAdd( aCombo, "4.-Remisión" ) //"4- Remision  "
aAdd( aCombo, "5.-RTS" ) //"5- RTS  "

 	DEFINE DIALOG oDlg TITLE "Seleccione documento" FROM 180,180 TO 350,450 PIXEL


	@ 020,010 COMBOBOX oCombo VAR cCombo ITEMS aCombo SIZE 65,8 PIXEL OF oFld 
	@ 040,040 BUTTON "Siguiente" SIZE 046,10 PIXEL ACTION oDlg:End() //"&Sair"
 	ACTIVATE MSDIALOG oDlg CENTER
	
	cCombo:= Subs(cCombo,1,1)   

	if cCombo=="1"
		cEspecie:="NF"
	elseif cCombo=="2"
		cEspecie:="NDC"
	elseif cCombo=="3"
		cEspecie:="NCC"
	elseif cCombo=="4"
		cEspecie:="RFN"
	else 
		cEspecie:="RTS"
	endif



 Return cEspecie

