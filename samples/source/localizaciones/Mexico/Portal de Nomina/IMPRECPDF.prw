
#Include "PROTHEUS.CH"
#Include "RPTDEF.CH" 
#INCLUDE "TBICONN.CH"
#INCLUDE "XMLXFUN.CH"
#INCLUDE "imprecxml.CH"
#INCLUDE "FONT.CH"

User Function ImpRcNPdf(cProc,cPer,cNumP,cFil,cMat)

	Local cCaminhoXML 	:= &(SuperGetmv( "MV_CFDRECN" , .F. , "'cfd\recibos\'" ))//GetSrvProfString('startpath','\')+'cfd\recibos\'
	Local cPath 		:= GetSrvProfString('RootPath','\') //+ 'System\spool\'       
	Local oXML			:= Nil
	Local cAviso			:= ""
	Local cErro			:= ""
	Local oPrinter 
	LOCAL aArqDir := Directory(cCaminhoXML + "*.*", "D")
	Local nX := 0
	Local lRet := .F.
	Local cFile := ""
	//Local cProc := ""
	Local cRot := AllTrim(getRoteir())
	local aItens := {}
	Local cArq := ""
	Local cFileAux := ""
	Local cPathHTTP := ""
	
	PRIVATE oFont  := NIL
	PRIVATE oFont1  := NIL
	PRIVATE oFont2  := NIL
	PRIVATE oFont3  := NIL
	PRIVATE oFont4  := NIL
	PRIVATE oFont5  := NIL
	PRIVATE oFont6  := NIL
	PRIVATE oFont7  := NIL
	
	cFil:= PadR(cFil, POSICIONE("SX3",2,"RA_FILIAL","X3_TAMANHO"))
	//cProc := AllTrim(POSICIONE("SRA",1,cFil+cMat,"RA_PROCES"))
	cFile := AllTrim(cProc) + cRot + cPer + cNumP + "_" + cFil + cMat
	cCaminhoXML := Replace( cCaminhoXML, "\\", "\" )
	cPathHTTP :=  cPath + "\HTTP\"
	
	IF ISSRVUNIX()
		cCaminhoXML := Replace( cCaminhoXML, "\", "/" )
		cPath := Replace( cPath, "\", "/" )
		cPathHTTP := 	Replace( cPathHTTP, "\", "/" )
	End If
	
	ClearFolder(cPathHTTP)
	
	oPrinter      := FWMSPrinter():New(cFile,6,.F.,cPath,.T.,,,,,.F.)
	
	oFont1 := TFont():New('Courier new',,40,.T., .T.)
	oFont := TFont():New( "ARIAL", , 07, .T., .F.)
	oFont2 := TFont():New( "ARIAL", , 05, .T., .F.)
	oFont3 := TFont():New( "ARIAL", , 10, .T., .T.)
	oFont4 := TFont():New( "ARIAL", , 07, .T., .T.)
	oFont5 := TFont():New( "ARIAL", , 05, .T., .T.)
	oFont6 := TFont():New( "ARIAL", , 07, .T., .F.)	
	oFont7 := TFont():New( "ARIAL", , 05, .T., .F.)
	
	If FILE(cCaminhoXML + cFile + ".XML")
		oXML := XmlParserFile( cCaminhoXML + cFile + '.xml', "_", @cAviso,@cErro )	
	Else
		For nX := 1 to Len(aArqDir)
			If aArqDir[nX][5] == "D"
				If FILE(cCaminhoXML + aArqDir[nX][1] + "\" + cFile + ".XML")
					cCaminhoXML := cCaminhoXML + aArqDir[nX][1] + "\"
					oXML := XmlParserFile( cCaminhoXML + cFile + '.xml', "_", @cAviso,@cErro )
					nX := Len(aArqDir)
				EndIf
			End If
		Next
	EndIf
	
	If oXML == NIL
		Return ""
	EndIf 
	
	oPrinter:setDevice(IMP_PDF)
	IF FUNNAME() != "IMPRECXML"
	oPrinter:cPathPDF := cCaminhoXML 
	Else
	oPrinter:cPathPDF := cPath + cCaminhoXML 
	EndIf
	
	oPrinter:StartPage()
	ImprRecNom(oPrinter,oXml)      
	oPrinter:EndPage()

	oPrinter:Print()
	FreeObj(oPrinter)
	oPrinter := Nil
	
	aAdd( aItens, cCaminhoXML + cFile + ".pdf" )
	aAdd( aItens, cCaminhoXML + cFile + ".xml" )
	IF FUNNAME() != "IMPRECXML"
		cFileAux := Replace( cFile, " ", "_" )
		cArq := tarCompress( aItens, cPathHTTP + cFileAux + ".Zip" )
		
		FERASE(cCaminhoXML + cFile + ".pdf")
		
		cFile := SuperGetmv( "MV_HTTPPTL" , .F. , "Undefined" ) 	
		If	cFile == "Undefined"
			cFileAux := cFile
		Else
			cFileAux := cFile + cFileAux
		EndIf
	Else
		cFileAux := cCaminhoXML + cFile
	EndIf
	
Return cFileAux 

static Function ImprRecNom(oPrinter,oXml)  

	Private msg	:= ""
	Private li	:= 0
	Private cPict1		:=	"@E 999,999,999.99"
	Private cPict2 		:=	"@E 99,999,999.99"
	Private cPict3 		:=	"@E 999,999.99"
	Private nEsp1 := 10
	Private nEsp2 := 10
	Private nEsp3 := 15
	Private nEsp4 := 25
	Private nEspLi1 := 5
	Private nEspLi2 := 10
	
	Pergunte("IMPRECXML",.F.)	
	 
	msg := AllTrim( fPosTab( "S018", MV_PAR23, "=", 4,,,,5) )
	ImpEnc(oPrinter,oXml)
	fLanca(oPrinter,oXML)
	fRodape(oPrinter,oXML)
Return 

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥Imprime   ∫Autor  ≥mayra.camargo       ∫ Data ≥ 24/12/2013  ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Genera el reporte a base del xml con los datos fiscales    ∫±±
±±∫          ≥ y ya timbrado.                                             ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥                                                            ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
static Function ImpEnc(oPrinter,oXml)

	Local cDet			:= ""
	Local cDir			:= oXml:_CFDI_COMPROBANTE:_CFDI_EMISOR:_CFDI_DOMICILIOFISCAL:_CALLE:TEXT + " "
	Local cFileLogo		:= ""   
	Local cFchRelLab    := oXml:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_FechaInicioRelLaboral:TEXT
	Local cFchPerIni    := oXml:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_FechaInicialPago:TEXT
	Local cFchPerFin    := oXml:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_FechaFinalPago:TEXT   
	Local cFchPago      := oXml:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_FECHAPAGO:TEXT 
	 
	//Fecha Admision
	If !Empty(cFchRelLab)
		cFchRelLab := substr(cFchRelLab,9,2)+"/"+substr(cFchRelLab,6,2)+"/"+substr(cFchRelLab,1,4)
	Else
		cFchRelLab := "//"
	Endif  
	
	//Fecha Pago
	If !Empty(cFchPago)
		cFchPago := substr(cFchPago,9,2)+"/"+substr(cFchPago,6,2)+"/"+substr(cFchPago,1,4)
	Else
		cFchPago := "//"
	Endif   
	 
	//Fecha Inicio Periodo-Pago
	If !Empty(cFchPerIni)
		cFchPerIni := substr(cFchPerIni,9,2)+"/"+substr(cFchPerIni,6,2)+"/"+substr(cFchPerIni,1,4)
	Else
		cFchPerIni := "//"
	Endif
  
	//Fecha Final Periodo-Pago
	If !Empty(cFchPerFin)
		cFchPerFin := substr(cFchPerFin,9,2)+"/"+substr(cFchPerFin,6,2)+"/"+substr(cFchPerFin,1,4)
	Else
		cFchPerFin := "//"
	Endif
	
	fCarLogo(@cFileLogo)
	oPrinter:Line(5,5,820,5,,"-4") //Linea lateral izquierda
	oPrinter:Line(5,585,820,585,,"-4") //Linea lateral derecha
	oPrinter:Line(5,5,5,585,,"-4")//Linea horizontal de marco
	
	

	cDir += oXml:_CFDI_COMPROBANTE:_CFDI_EMISOR:_CFDI_DOMICILIOFISCAL:_COLONIA:TEXT 			+ " "
	cDir += oXml:_CFDI_COMPROBANTE:_CFDI_EMISOR:_CFDI_DOMICILIOFISCAL:_MUNICIPIO:TEXT 		+ " "
	cDir += oXml:_CFDI_COMPROBANTE:_CFDI_EMISOR:_CFDI_DOMICILIOFISCAL:_CODIGOPOSTAL:TEXT 	+ " "	
	cDir += oXml:_CFDI_COMPROBANTE:_CFDI_EMISOR:_CFDI_DOMICILIOFISCAL:_ESTADO:TEXT 			+ ","
	cDir += oXml:_CFDI_COMPROBANTE:_CFDI_EMISOR:_CFDI_DOMICILIOFISCAL:_PAIS:TEXT
	
	LI := 10
	If File(cFilelogo)
		oPrinter:SayBitmap(LI,10, cFileLogo,40,30) // Tem que estar abaixo do RootPath
	Endif
	
	LI += 30
	oPrinter:Say(LI,250,STR0017,oFont3)
	
	LI += nEspLi1
	oPrinter:Line(LI,5,LI,585,,"-4")
	LI += nEspLi2
	oPrinter:Say(LI,10,STR0097,oFont4)
	oPrinter:Say(LI,85,oXml:_CFDI_COMPROBANTE:_CFDI_EMISOR:_NOMBRE:TEXT,oFont)
	LI += nEsp2
	If ObtUidXML(OXml:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA, "RegistroPatronal")
		oPrinter:SAY(LI,10 ,STR0121,OFONT4)
		oPrinter:SAY(LI,85 ,OXml:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_REGISTROPATRONAL:TEXT,oFont)
	EndIf
	LI += nEsp2
	oPrinter:SAY(LI,10 ,STR0099,OFONT4)
	oPrinter:SAY(LI,85 ,oXml:_CFDI_COMPROBANTE:_CFDI_EMISOR:_RFC:TEXT,oFont)
	LI += nEsp2
	oPrinter:SAY(LI,10 ,STR0098, oFont4)
	oPrinter:SAY(LI,85 , cDir ,oFont)
	LI += nEspLi1
	oPrinter:Line(LI,5,LI,585,,"-4")
	
	
	LI += nEspLi2
	oPrinter:SAY(LI,10 , STR0001 + ": " , oFONT4)
	oPrinter:SAY(LI,85 , oXml:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_NUMEMPLEADO:TEXT,oFont)
	If ObtUidXML(oXml:_CFDI_COMPROBANTE:_CFDI_RECEPTOR, "nombre")
		oPrinter:SAY(LI,165 , STR0003,Ofont4)
		oPrinter:SAY(LI,220 , oXml:_CFDI_COMPROBANTE:_CFDI_RECEPTOR:_NOMBRE:TEXT,oFont)
	EndIf
	Li+= nEsp2
	
	oPrinter:SAY(LI,10 , STR0099, Ofont4)
	oPrinter:SAY(LI,85 , oXml:_CFDI_COMPROBANTE:_CFDI_RECEPTOR:_RFC:TEXT,oFont)
	If ObtUidXML(oXml:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA, "NumSeguridadSocial")
		oPrinter:SAY(LI,165 , STR0122, oFONT4)
		oPrinter:SAY(LI,220 , oXml:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_NUMSEGURIDADSOCIAL:TEXT,oFont)
	EndIf
	oPrinter:SAY(LI,285 , STR0123 + ": " , oFONT4)
	oPrinter:SAY(LI,350 , oXml:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_CURP:TEXT,oFont) 
	oPrinter:SAY(LI,465 , STR0175, oFONT4)															//PERIODICIDAD DE PAGO
	oPrinter:SAY(LI,540 , oXml:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_PERIODICIDADPAGO:TEXT,oFont)
	
	/*Correcto*/
	Li+= nEsp2
	
	If ObtUidXML(oXml:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA, "Departamento")
		oPrinter:SAY(LI,10 , STR0128, oFONT4)
		oPrinter:SAY(LI,85 , oXml:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_DEPARTAMENTO:TEXT,oFont)
	EndIf
	If ObtUidXML(oXml:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA, "Puesto")
		oPrinter:SAY(LI,285 , STR0133, Ofont4)
		oPrinter:SAY(LI,350 , oXml:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_PUESTO:TEXT,oFont)
	EndIf 
	If ObtUidXML(oXml:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA, "TipoContrato") 
		oPrinter:SAY(LI,465 , STR0176, oFONT4)															//TIPO DE CONTRATO
		oPrinter:SAY(LI,540 , oXml:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_TIPOCONTRATO:TEXT,oFont)
	EndIf
	
	Li+= nEsp2
	If ObtUidXML(oXml:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA, "SalarioBaseCotApor")
		oPrinter:SAY(LI,10 ,STR0134, oFONT4)
		oPrinter:SAY(LI,85 , oXml:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_SalarioBaseCotApor:TEXT,oFont)
	EndIf
	If ObtUidXML(oXml:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA, "SalarioDiarioIntegrado")
		oPrinter:SAY(LI,165 ,STR0135, oFONT4)
		oPrinter:SAY(LI,220 , oXml:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_SalarioDiarioIntegrado:TEXT,oFont) 
	EndIf
	oPrinter:SAY(LI,285 ,STR0126,oFONT4)
	oPrinter:SAY(LI,350 , oXml:_CFDI_COMPROBANTE:_LugarExpedicion:TEXT,oFont)
	If ObtUidXML(oXml:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA, "FechaInicioRelLaboral")
		oPrinter:SAY(LI,465 ,STR0111, oFONT4)
		oPrinter:SAY(LI,540 ,cFchRelLab,oFont) // oXml:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_FechaInicioRelLaboral:TEXT
	EndIf
	
	Li+= nEsp2
	If ObtUidXML(oXml:_CFDI_COMPROBANTE:_CFDI_RECEPTOR:_CFDI_DOMICILIO, "calle")
		cDet := oXml:_CFDI_COMPROBANTE:_CFDI_RECEPTOR:_CFDI_DOMICILIO:_CALLE:TEXT + " "
	EndIf
	If ObtUidXML(oXml:_CFDI_COMPROBANTE:_CFDI_RECEPTOR, "colonia")
		cDet += oXml:_CFDI_COMPROBANTE:_CFDI_RECEPTOR:_CFDI_DOMICILIO:_COLONIA:TEXT + " "
	EndIf
	If ObtUidXML(oXml:_CFDI_COMPROBANTE:_CFDI_RECEPTOR, "municipio")
		cDet += oXml:_CFDI_COMPROBANTE:_CFDI_RECEPTOR:_CFDI_DOMICILIO:_MUNICIPIO:TEXT + " "
	EndIf
	If ObtUidXML(oXml:_CFDI_COMPROBANTE:_CFDI_RECEPTOR, "codigoPostal")
		cDet += oXml:_CFDI_COMPROBANTE:_CFDI_RECEPTOR:_CFDI_DOMICILIO:_CODIGOPOSTAL:TEXT + " "
	EndIf
	If ObtUidXML(oXml:_CFDI_COMPROBANTE:_CFDI_RECEPTOR, "estado")
		cDet += oXml:_CFDI_COMPROBANTE:_CFDI_RECEPTOR:_CFDI_DOMICILIO:_ESTADO:TEXT + " ,"
	EndIf
	cDet += oXml:_CFDI_COMPROBANTE:_CFDI_RECEPTOR:_CFDI_DOMICILIO:_PAIS:TEXT 
	oPrinter:SAY(Li,10 ,STR0098 , oFONT4)
	oPrinter:SAY(Li,85 , cDet,oFont)
	Li+= nEsp2 //2
	oPrinter:SAY(Li,10 ,STR0178, OFONT4) //STR0120 - "No Pago: "     Periodo Pago                  
	oPrinter:SAY(Li,85 ,cFchPerIni+"  a  " + cFchPerFin,oFont) //oXml:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_FechaInicialPago:TEXT +" / " +oXml:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_FechaFinalPago:TEXT
	oPrinter:SAY(LI,285 ,STR0136, ofont4)
	oPrinter:SAY(LI,350 ,cFchPago,oFont) //oXml:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_FECHAPAGO:TEXT		
	
	LI+=nEspLi1
	oPrinter:Line(LI,5,LI,585,,"-4")
	LI += nEspLi2
	
Return Nil

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥fLanca    ∫Autor  ≥Raul Ortiz          ∫ Data ≥ 29/10/2014  ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥Genera cuerpo del reporte en base al xml                    ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥                                                            ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

Static Function fLanca(oPrinter,oXML)   // Impressao dos Lancamentos
	
	Local cString	:= "" //Transform(aLanca[nConta,5],cPict2)

	Local nI		:= 0
	Local cImpGrv	:= ""
	Local cImpExc	:= ""
	
	oPrinter:SAY(Li,10 ,STR0137	,oFont4)
	oPrinter:SAY(Li,75 ,STR0138	,oFont4)
	oPrinter:SAY(Li,145 ,STR0069	,oFont4)
	oPrinter:SAY(Li,280 ,STR0177	,oFont4)
	oPrinter:SAY(Li,390 ,STR0139	,oFont4)
	oPrinter:SAY(Li,490 ,STR0140	,oFont4)	
	
	LI += 5
	oPrinter:Line(LI,10,LI,575,,"-4")
	LI += nEspLi2
	newPage(oPrinter)

	oPrinter:SAY(Li,10 ,oXml:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO:_CANTIDAD:TEXT	,oFont)
	oPrinter:SAY(Li,75 ,oXml:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO:_UNIDAD:TEXT		,oFont)
	oPrinter:SAY(Li,145 ,oXml:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO:_DESCRIPCION:TEXT,oFont)
	oPrinter:SAY(Li,280 ,oXml:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_NUMDIASPAGADOS:TEXT,oFont) // DIAS PAGADOS SAT
	oPrinter:SAY(Li,390 ,Transform(val(oXml:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO:_VALORUNITARIO:TEXT),cPict2),oFont6)
	oPrinter:SAY(Li,490 ,Transform(val(oXml:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO:_IMPORTE:TEXT),cPict2),oFont6)
		
	LI += nEspLi1
	oPrinter:Line(LI,5,LI,585,,"-4")
	LI += nEspLi2
	
	oPrinter:SAY(Li,10 ,STR0141	,oFont4)
	oPrinter:SAY(Li,75 ,STR0142	,oFont4)
	oPrinter:SAY(Li,145 ,STR0069	,oFont4)
	oPrinter:SAY(Li,450 ,STR0143	,oFont4)
	
	LI += 5
	oPrinter:Line(LI,10,LI,575,,"-4")
	LI += nEspLi2
	newPage(oPrinter)
	oPrinter:SAY(Li,10 ,STR0144,oFont4)
	Li += nEsp3
	If ObtUidXML(oXML,"nomina:Percepciones")
		IF ValType(oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_NOMINA_PERCEPCIONES:_NOMINA_PERCEPCION) <> "O"
			For nI := 1 to Len(oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_NOMINA_PERCEPCIONES:_NOMINA_PERCEPCION)
				
				cImpGrv := val(oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_NOMINA_PERCEPCIONES:_NOMINA_PERCEPCION[nI]:_IMPORTEGRAVADO:TEXT)
				cImpExc := val(oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_NOMINA_PERCEPCIONES:_NOMINA_PERCEPCION[nI]:_IMPORTEEXENTO:TEXT)
				
				IF !Empty(cImpGrv)
					cString := Transform(cImpGrv,cPict2)
					oPrinter:SAY(LI,10,oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_NOMINA_PERCEPCIONES:_NOMINA_PERCEPCION[nI]:_TIPOPERCEPCION:TEXT,oFont)
					oPrinter:SAY(LI,75,oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_NOMINA_PERCEPCIONES:_NOMINA_PERCEPCION[nI]:_CLAVE:TEXT,oFont)
					oPrinter:SAY(LI,145,oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_NOMINA_PERCEPCIONES:_NOMINA_PERCEPCION[nI]:_CONCEPTO:TEXT,oFont)		
					oPrinter:SAY(LI,450,cString,oFont6)
					Li += nEsp1
					newPage(oPrinter)
				End If
				
				If !Empty(cImpExc)			
					cString := Transform(cImpExc,cPict2)
					oPrinter:SAY(LI,10,oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_NOMINA_PERCEPCIONES:_NOMINA_PERCEPCION[nI]:_TIPOPERCEPCION:TEXT,oFont)				
					oPrinter:SAY(LI,75,oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_NOMINA_PERCEPCIONES:_NOMINA_PERCEPCION[nI]:_CLAVE:TEXT,oFont)
					oPrinter:SAY(LI,145,oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_NOMINA_PERCEPCIONES:_NOMINA_PERCEPCION[nI]:_CONCEPTO:TEXT,oFont)		
					oPrinter:SAY(LI,450, cString,oFont6)	
					Li += nEsp1
					newPage(oPrinter)	
				End IF				
			Next nI
		Else
			cImpGrv := val(oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_NOMINA_PERCEPCIONES:_NOMINA_PERCEPCION:_IMPORTEGRAVADO:TEXT)
			cImpExc := val(oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_NOMINA_PERCEPCIONES:_NOMINA_PERCEPCION:_IMPORTEEXENTO:TEXT)
				
			IF !Empty(cImpGrv)
				cString := Transform(cImpGrv,cPict2)
				oPrinter:SAY(LI,10,oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_NOMINA_PERCEPCIONES:_NOMINA_PERCEPCION:_TIPOPERCEPCION:TEXT,oFont)			
				oPrinter:SAY(LI,75,oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_NOMINA_PERCEPCIONES:_NOMINA_PERCEPCION:_CLAVE:TEXT,oFont)
				oPrinter:SAY(LI,145,oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_NOMINA_PERCEPCIONES:_NOMINA_PERCEPCION:_CONCEPTO:TEXT,oFont)		
				oPrinter:SAY(LI,450,cString,oFont6)
				Li += nEsp1
				newPage(oPrinter)
			End If
				
			If !Empty(cImpExc)			
				cString := Transform(cImpExc,cPict2)
				oPrinter:SAY(LI,10,oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_NOMINA_PERCEPCIONES:_NOMINA_PERCEPCION:_TIPOPERCEPCION:TEXT,oFont)			
				oPrinter:SAY(LI,75,oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_NOMINA_PERCEPCIONES:_NOMINA_PERCEPCION:_CLAVE:TEXT,oFont)
				oPrinter:SAY(LI,145,oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_NOMINA_PERCEPCIONES:_NOMINA_PERCEPCION:_CONCEPTO:TEXT,oFont)		
				oPrinter:SAY(LI,450, cString,oFont6)	
				Li += nEsp1
				newPage(oPrinter)	
			End IF			
		EndIF
	EndIF
	

	
	oPrinter:SAY(Li,10 ,STR0145,oFont4)
	Li += nEsp3
	newPage(oPrinter)
	
	If ObtUidXML(oXML,"nomina:Deducciones")
		If valtype(oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_NOMINA_DEDUCCIONES:_NOMINA_DEDUCCION) <> "O"
			For nI := 1 to Len(oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_NOMINA_DEDUCCIONES:_NOMINA_DEDUCCION)
			
				cImpGrv := val(oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_NOMINA_DEDUCCIONES:_NOMINA_DEDUCCION[nI]:_IMPORTEGRAVADO:TEXT)
				cImpExc := val(oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_NOMINA_DEDUCCIONES:_NOMINA_DEDUCCION[nI]:_IMPORTEEXENTO:TEXT)
				
				IF !Empty(cImpGrv)
					cString := Transform(cImpGrv,cPict2)
					oPrinter:SAY(LI,10,oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_NOMINA_deducciones:_NOMINA_DEDUCCION[nI]:_TIPODEDUCCION:TEXT,oFont)				
					oPrinter:SAY(LI,75,oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_NOMINA_DEDUCCIONES:_NOMINA_DEDUCCION[nI]:_CLAVE:TEXT,oFont)
					oPrinter:SAY(LI,145,oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_NOMINA_DEDUCCIONES:_NOMINA_DEDUCCION[nI]:_CONCEPTO:TEXT,oFont)	
					oPrinter:SAY(LI,520 , cString,oFont6)
					Li += nEsp1
					newPage(oPrinter)
				End If
				
				If !Empty(cImpExc)			
					cString := Transform(cImpExc,cPict2)
					oPrinter:SAY(LI,10,oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_NOMINA_DEDUCCIONES:_NOMINA_DEDUCCION[nI]:_TIPODEDUCCION:TEXT,oFont)
					oPrinter:SAY(LI,75,oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_NOMINA_DEDUCCIONES:_NOMINA_DEDUCCION[nI]:_CLAVE:TEXT,oFont)
					oPrinter:SAY(LI,145,oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_NOMINA_DEDUCCIONES:_NOMINA_DEDUCCION[nI]:_CONCEPTO:TEXT,oFont)	
					oPrinter:SAY(LI,520 , cString,oFont6)	
					Li += nEsp1
					newPage(oPrinter)	
				End IF				
			Next nI
		Else
			cImpGrv := val(oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_NOMINA_DEDUCCIONES:_NOMINA_DEDUCCION:_IMPORTEGRAVADO:TEXT)
			cImpExc := val(oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_NOMINA_DEDUCCIONES:_NOMINA_DEDUCCION:_IMPORTEEXENTO:TEXT)
			
			IF !Empty(cImpGrv)
				cString := Transform(cImpGrv,cPict2)
				oPrinter:SAY(LI,10,oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_NOMINA_DEDUCCIONES:_NOMINA_DEDUCCION:_TIPODEDUCCION:TEXT,oFont)
				oPrinter:SAY(LI,75,oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_NOMINA_DEDUCCIONES:_NOMINA_DEDUCCION:_CLAVE:TEXT,oFont)
				oPrinter:SAY(LI,145,oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_NOMINA_DEDUCCIONES:_NOMINA_DEDUCCION:_CONCEPTO:TEXT,oFont)	
				oPrinter:SAY(LI,520, cString,oFont6)
				Li += nEsp1
				newPage(oPrinter)
			End If
			
			If !Empty(cImpExc)			
				cString := Transform(cImpExc,cPict2)
				oPrinter:SAY(LI,10,oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_NOMINA_DEDUCCIONES:_NOMINA_DEDUCCION:_TIPODEDUCCION:TEXT,oFont)
				oPrinter:SAY(LI,75,oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_NOMINA_DEDUCCIONES:_NOMINA_DEDUCCION:_CLAVE:TEXT,oFont)
				oPrinter:SAY(LI,145,oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_NOMINA_DEDUCCIONES:_NOMINA_DEDUCCION:_CONCEPTO:TEXT,oFont)	
				oPrinter:SAY(LI,520 , cString,ofont6)	
				Li += nEsp1	
				newPage(oPrinter)
			End IF				
		EndIF
	EndIf
	
	LI -= 5
	oPrinter:Line(LI,5,LI,585,,"-4")
	LI += nEspLi2
	newPage(oPrinter)
	
	If ObtUidXML(oXML,"nomina:Incapacidades")
		oPrinter:SAY(Li,10 ,STR0147,oFont4)
		Li += nEsp3
		newPage(oPrinter)
		oPrinter:SAY(Li,10 ,STR0148			,oFont4)
		oPrinter:SAY(Li,75 ,STR0141			,oFont4)
		oPrinter:SAY(Li,520 ,STR0149		,oFont4)
		
		Li += 5
		oPrinter:Line(LI,10,LI,575,,"-4")
		LI += nEspLi2
		newPage(oPrinter)
		
		IF valtype(oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_NOMINA_INCAPACIDADES:_NOMINA_INCAPACIDAD)<> "O"
			For nI := 1 to len(oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_NOMINA_INCAPACIDADES:_NOMINA_INCAPACIDAD)
				
				oPrinter:SAY(Li,10 ,oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_NOMINA_INCAPACIDADES:_NOMINA_INCAPACIDAD[NI]:_DIASINCAPACIDAD:TEXT,oFont)
				oPrinter:SAY(Li,75 ,oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_NOMINA_INCAPACIDADES:_NOMINA_INCAPACIDAD[NI]:_TIPOINCAPACIDAD:TEXT,oFont)
				oPrinter:SAY(Li,520 ,Transform(val(oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_NOMINA_INCAPACIDADES:_NOMINA_INCAPACIDAD[NI]:_DESCUENTO:TEXT),cPict2),oFont6)
				Li += nEsp1
				newPage(oPrinter)			
			Next nI
		Else
			
			oPrinter:SAY(Li,10 ,oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_NOMINA_INCAPACIDADES:_NOMINA_INCAPACIDAD:_DIASINCAPACIDAD:TEXT,oFont)
			oPrinter:SAY(Li,75 ,oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_NOMINA_INCAPACIDADES:_NOMINA_INCAPACIDAD:_TIPOINCAPACIDAD:TEXT,oFont)
			oPrinter:SAY(Li,520 ,Transform(val(oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_NOMINA_INCAPACIDADES:_NOMINA_INCAPACIDAD:_DESCUENTO:TEXT),cPict2),oFont6)			
			Li += nEsp1
			newPage(oPrinter)
		EndIF
	End If
	
	If ObtUidXML(oXML,"nomina:HorasExtra")
		oPrinter:SAY(Li,10 ,STR0151,oFont4)
		Li += nEsp4
		newPage(oPrinter)
		oPrinter:SAY(Li,10 ,STR0148	,oFont4)
		oPrinter:SAY(Li,75 ,STR0141	,oFont4)
		oPrinter:SAY(Li,145 ,STR0152	,oFont4)
		oPrinter:SAY(Li,520 ,STR0140	,oFont4)
		
		Li += 5
		oPrinter:Line(LI,10,LI,575,,"-4")
		LI += nEspLi2
		newPage(oPrinter)
		
		IF valtype(oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_NOMINA_HORASEXTRAS:_NOMINA_HORASEXTRA) <> "O"
			For nI := 1 to len(oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_NOMINA_HORASEXTRAS:_NOMINA_HORASEXTRA)
				
				oPrinter:SAY(Li,10 ,oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_NOMINA_HORASEXTRAS:_NOMINA_HORASEXTRA[nI]:_DIAS:TEXT,oFont)
				oPrinter:SAY(Li,75 ,oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_NOMINA_HORASEXTRAS:_NOMINA_HORASEXTRA[nI]:_TIPOHORAS:TEXT,oFont)
				oPrinter:SAY(Li,145 ,oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_NOMINA_HORASEXTRAS:_NOMINA_HORASEXTRA[nI]:_HORASEXTRA:TEXT,oFont)
				oPrinter:SAY(Li,520 ,Transform(val(oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_NOMINA_HORASEXTRAS:_NOMINA_HORASEXTRA[nI]:_IMPORTEPAGADO:TEXT),cPict2),oFont6)
				Li += nEsp1
				newPage(oPrinter)
			Next nI
		Else
			
			oPrinter:SAY(Li,10 ,oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_NOMINA_HORASEXTRAs:_NOMINA_HORASEXTRA:_DIAS:TEXT,oFont)
			oPrinter:SAY(Li,75 ,oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_NOMINA_HORASEXTRAs:_NOMINA_HORASEXTRA:_TIPOHORAS:TEXT,oFont)
			oPrinter:SAY(Li,145 ,oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_NOMINA_HORASEXTRAs:_NOMINA_HORASEXTRA:_HORASEXTRA:TEXT,oFont)
			oPrinter:SAY(Li,520 ,Transform(val(oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_NOMINA_HORASEXTRAs:_NOMINA_HORASEXTRA:_IMPORTEPAGADO:TEXT),cPict2),oFont6)
			Li += nEsp1
			newPage(oPrinter)
		EndIf
	End If
	
	
	If ObtUidXML(oXML,"cfdi:Impuestos")
		Li+=nEsp1
		oPrinter:SAY(Li,10 ,STR0154	,oFont4)
		Li+=nEsp3
		newPage(oPrinter)
		oPrinter:SAY(Li,10 ,STR0155	,oFont4)
		oPrinter:SAY(Li,520 ,STR0140	,oFont4)
		
		LI += 5
		oPrinter:Line(LI,10,LI,575,,"-4")
		LI += nEspLi2
		newPage(oPrinter)
		
		IF valtype(oXML:_CFDI_COMPROBANTE:_CFDI_IMPUESTOS:_CFDI_RETENCIONES:_CFDI_RETENCION)<> "O"
			For nI := 1 to len(oXML:_CFDI_COMPROBANTE:_CFDI_IMPUESTOS:_CFDI_RETENCIONES:_CFDI_RETENCION)
				
				oPrinter:SAY(Li,10 ,oXML:_CFDI_COMPROBANTE:_CFDI_IMPUESTOS:_CFDI_RETENCIONES:_CFDI_RETENCION[nI]:_IMPUESTO:TEXT,oFont)
				oPrinter:SAY(Li,520 ,Transform(val(oXML:_CFDI_COMPROBANTE:_CFDI_IMPUESTOS:_CFDI_RETENCIONES:_CFDI_RETENCION[nI]:_IMPORTE:TEXT),cPict2),oFont6)
				Li += nEsp1
				newPage(oPrinter)
			Next nI
		Else
			
			oPrinter:SAY(Li,10 ,oXML:_CFDI_COMPROBANTE:_CFDI_IMPUESTOS:_CFDI_RETENCIONES:_CFDI_RETENCION:_IMPUESTO:TEXT,oFont)
			oPrinter:SAY(Li,520 ,Transform(val(oXML:_CFDI_COMPROBANTE:_CFDI_IMPUESTOS:_CFDI_RETENCIONES:_CFDI_RETENCION:_IMPORTE:TEXT),cPict2),oFont6)
			Li += nEsp1
			newPage(oPrinter)
		EndIF
	End If
	LI -= 5
	oPrinter:Line(LI,5,LI,585,,"-4")
	Li += nEspLi2
	newPage(oPrinter)
Return Nil

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥fRodape   ∫Autor  ≥Raul Ortiz          ∫ Data ≥ 29/10/2014  ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥Genera pie de reporte incluyendo mensajes, totales ,        ∫±±
±±∫          ≥ cadenas de sello e imagen de codigo de barras.             ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥                                                            ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function fRodape(oPrinter,oXML)    // Rodape do Recibo

	Local cTotalPerGrv 	:= 0
	Local cTotalPerExc 	:= 0
	Local cTotalDedGrv 	:= 0
	Local cTotalDedExc 	:= 0
	Local cTotal		  	:= 0
	Local cSubTotal	  	:= 0
	Local cCadena 	  	:= ""
	Local nI			 	:= 0
	Local nx				:= 0
	Local cCadAux		  	:= ""
	Local nLiaux			:= ""
	Local cCertSAT		:= ""
	Local cTotalImp		:= 0
	Local cDescuentos	:= 0
	Local nTtlAux := 0
	
	If ObtUidXML(oXML,"nomina:Percepciones")
		cTotalPerGrv 	:= val(oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_NOMINA_PERCEPCIONES:_TOTALGRAVADO:TEXT)
		cTotalPerExc 	:= val(oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_NOMINA_PERCEPCIONES:_TOTALEXENTO:TEXT)
	EndIf
	
	If ObtUidXML(oXML,"nomina:Deducciones")
		cTotalDedGrv 	:= val(oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_NOMINA_DEDUCCIONES:_TOTALGRAVADO:TEXT)
		cTotalDedExc 	:= val(oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_NOMINA_DEDUCCIONES:_TOTALEXENTO:TEXT)
	EndIf
	
	cSubTotal		:= val(oXML:_CFDI_COMPROBANTE:_SUBTOTAL:TEXT)
	cTotal			:= val(oXML:_CFDI_COMPROBANTE:_TOTAL:TEXT) 
	cTotalImp		:= val(oXML:_CFDI_COMPROBANTE:_CFDI_IMPUESTOS:_totalImpuestosRetenidos:TEXT)    
	cDescuentos	:= val(oXML:_CFDI_COMPROBANTE:_DESCUENTO:TEXT)
	If !Empty(cTotalPerGrv)
		oPrinter:SAY(LI,10, STR0156,oFont4)
		oPrinter:SAY(LI,450, Transform(cTotalPerGrv,cPict2),oFont6)
		Li += nEsp1
		newPage(oPrinter)
	End IF

	If !Empty(cTotalPerExc)
		oPrinter:SAY(LI,10, "Total Percepciones Exentas",oFont4)
		oPrinter:SAY(LI,450, Transform(cTotalPerExc,cPict2),oFont6)
		Li += nEsp1
		newPage(oPrinter)
	End IF
	oPrinter:SAY(LI,10, STR0158,oFont4)
	oPrinter:SAY(LI,450, Transform(cSubtotal,cPict2),oFont6)
	Li += nEsp1
	newPage(oPrinter)
	If !Empty(cTotalDedGrv)
		oPrinter:SAY(LI,10, STR0159,oFont4)
		oPrinter:SAY(LI,520, Transform(cTotalDedGrv,cPict2),oFont6)
		Li += nEsp1
		newPage(oPrinter)
	End IF
	If !Empty(cTotalDedExc)
		oPrinter:SAY(LI,10, STR0160,oFont4)
		oPrinter:SAY(LI,520, Transform(cTotalDedExc,cPict2),oFont6)
		Li += nEsp1
		newPage(oPrinter)
	End IF
	oPrinter:SAY(LI,10, STR0161,oFont4)
	oPrinter:SAY(LI,520, Transform(cDescuentos,cPict2),oFont6)
	Li += nEsp1
	newPage(oPrinter)
	oPrinter:SAY(LI,10, STR0162,oFont4)
	oPrinter:SAY(LI,520, Transform(cTotalImp,cPict2),oFont6)

	Li += nEsp3
	newPage(oPrinter)
	oPrinter:SAY(LI,10, STR0163,ofont4)
	oPrinter:SAY(LI,520 , Transform(cTotal,cPict2),oFont6)
	LI += nEspLi1
	newPage(oPrinter)
	oPrinter:Line(LI,5,LI,585,,"-4")
	LI += nEspLi2
	newPage(oPrinter)
	
	If ObtUidXML(oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA, "Banco")
		oPrinter:SAY(LI,10 , STR0164, oFont4	)//"CRED:"
		oPrinter:SAY(LI,85 , oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_BANCO:TEXT,oFont)
	EndIf
	If ObtUidXML(oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA, "CLABE")
		oPrinter:SAY(LI,165 , STR0165, ofont4)
		oPrinter:SAY(LI,220 , oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_NOMINA_NOMINA:_CLABE:TEXT,oFont)//"CONTA:"
	EndIf
	LI += nEspLi1
	newPage(oPrinter)
	oPrinter:Line(LI,5,LI,585,,"-4")
	LI += nEspLi2
	newPage(oPrinter)
	oPrinter:SAY(LI,10 , STR0166, oFont4	)
	LI += nEsp1
	newPage(oPrinter)

	oPrinter:Line(LI,5,LI,585,,"-4")
	LI += nEspLi2
	newPage(oPrinter)
		
	aBlock := LoadBlock(oXML)
	If aBlock[4][2] > 815 - LI 
		newPage(oPrinter, .T.)		
	End If
	//nLiaux	:= LI
	
	oPrinter:SAY(LI,10 , STR0179, oFont5)
	LI += nEsp2
	
	If ObtUidXML(oXML,"tfd:TimbreFiscalDigital") 
		nX := 1
		For nI := 1 to aBlock[1][2] 		
			cCadAux:= Substr(aBlock[1][1],nX,225)
			nX += 225	
			oPrinter:SAY(LI,10 ,cCadAux,oFont7)
			Li+=nEsp2
		End IF 
	Else
		Li += nEsp2
	End IF
	
	oPrinter:SAY(LI,130 ,STR0168,oFont5)
	nLiaux	:= LI
	LI += nEsp2
	If ObtUidXML(oXML,"SELLOCFD")
		nX := 1
		For nI := 1 to aBlock[2][2] 		
			cCadAux:= Substr(aBlock[2][1],nX,170)
			nX+=170	
			oPrinter:SAY(LI,130 ,cCadAux,oFont7)
			Li+=nEsp1
		End IF
	Else
		Li+=nEsp2
	EndIf
	oPrinter:SAY(LI,130 , STR0169, oFont5)
	LI +=nEsp2
	If	ObtUidXML(oXML,"SELLOSAT")		
		nX := 1
		For nI := 1 to aBlock[3][2]			
			cCadAux:= Substr(aBlock[3][1],nX,170)
			nX+=170	
			oPrinter:SAY(LI,130 ,cCadAux,oFont7)
			Li+=nEsp1
		End IF
		oPrinter:QRCode(10,nLiaux + 110 ,aBlock[4][1], 50)
	Else
		Li+=nEsp1
	EndIF
	lI+=nEsp3
	oPrinter:SAY(LI,130 , UPPER(STR0170),oFont7)
	
	oPrinter:Line(820,5,820,585,,"-4")
	//oPrinter:SAY(825,10 , "RECIBI DE LA EMPRESA ANTES MENCIONADA LA CANTIDAD NETA A QUE ESTE DOCUMENTO SE REFIERE, ESTANDO CONFORME CON LAS PERCEPCIONES Y DEDUCCIONES QUE EN EL APARECEN ESPECIFICADAS.",oFont7)		
	oPrinter:SAY(825,10,msg,oFont7)
	
Return Nil

/*Calcula el tamaÒo del bloque y regresa las cadenas de los nodos contenidos en el bloque, junto con el numero de lineas que va a 
ocupar */ 
Static Function LoadBlock(oXML)
	Local aBlock := {{{},{}},{{},{}},{{},{}},{{},{}}}
	Local nLineas := 0
	Local cCadena := ""
	Local nX := 0
	Local nI := 0
	Local nTmp := 0
	Local nLiAux := 0
	
	nLineas += oFont5:NHEIGHT
	nLineas += nEsp2
	If ObtUidXML(oXML,"tfd:TimbreFiscalDigital") 
		cCadena := "||" + oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_TFD_TIMBREFISCALDIGITAL:_VERSION:TEXT
		cCadena += "|" + oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_TFD_TIMBREFISCALDIGITAL:_UUID:TEXT 
		cCadena += "|" + oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_TFD_TIMBREFISCALDIGITAL:_FECHATIMBRADO:TEXT
		cCadena += "|" + oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_TFD_TIMBREFISCALDIGITAL:_SELLOCFD:TEXT 
		cCadena += "|" + oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_TFD_TIMBREFISCALDIGITAL:_NOCERTIFICADOSAT:TEXT
		cCadena += "||"
		
		nX := 1
		nTmp := (len(cCadena)/225)	+ 1  
		For nI := 1 to nTmp		
			cCadAux:= Substr(cCadena,nX,225)
			nX += 225	
			nLineas += oFont7:NHEIGHT
			nLineas += nEsp2
		End IF
		aBlock[1][1] := cCadena
		aBlock[1][2] := nTmp
	Else
		nLineas += nEsp2
	End IF
	
	nLiAux += oFont5:NHEIGHT
	nLiAux += nEsp2
	If ObtUidXML(oXML,"SELLOCFD")
		cCadena :=  oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_TFD_TIMBREFISCALDIGITAL:_SELLOCFD:TEXT
		nX := 1
		nTmp := (len(cCadena)/170)	+ 1 
		For nI := 1 to nTmp		
			cCadAux:= Substr(cCadena,nX,170)
			nX+=170
			nLiAux	+= oFont7:NHEIGHT
			nLiAux += nEsp1
		End IF
		aBlock[2][1] := cCadena
		aBlock[2][2] := nTmp
	Else
		nLiAux += nEsp2
	EndIf
	
	nLiAux += oFont5:NHEIGHT
	nLiAux += nEsp2
	If	ObtUidXML(oXML,"SELLOSAT")			
		If Val(oXML:_CFDI_COMPROBANTE:_TOTAL:TEXT) < 0 
			nTtlAux := Val(oXML:_CFDI_COMPROBANTE:_TOTAL:TEXT) * (- 1)
			nTtlAux := "-" + Replace(Transform(nTtlAux,"999999999.999999") , " ", "0")
		Else
			nTtlAux := Val(oXML:_CFDI_COMPROBANTE:_TOTAL:TEXT)
			nTtlAux := Replace(Transform(nTtlAux,"9999999999.999999") , " ", "0")	 
		EndIf
		cCertSAT := "?re=" + oXml:_CFDI_COMPROBANTE:_CFDI_EMISOR:_RFC:TEXT 
		cCertSAT += "&rr=" + oXml:_CFDI_COMPROBANTE:_CFDI_RECEPTOR:_RFC:TEXT
		cCertSAT += "&tt=" + nTtlAux
		cCertSAT += "&id=" + oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_TFD_TIMBREFISCALDIGITAL:_UUID:TEXT
		
		aBlock[4][1] := cCertSAT		
		cCadena :=  oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_TFD_TIMBREFISCALDIGITAL:_SELLOSAT:TEXT
		nX := 1
		nTmp := (len(cCadena)/170)	+ 1
		For nI := 1 to  nTmp
			
			cCadAux:= Substr(cCadena,nX,170)
			nX+=170
			nLiAux += 	oFont7:NHEIGHT
			nLiAux += nEsp1
		End IF
		aBlock[3][1] := cCadena
		aBlock[3][2] := nTmp
	Else
		nLiAux += nEsp1
	EndIF
	
	nLiAux += nEsp3
	nLiAux += oFont7:NHEIGHT
	
	If nLiAux <= 115
		nLineas += 120
	Else
		nLineas += nLiAux
	EndIf
	aBlock[4][2] := nLineas
	

Return aBlock 

// Busca nodo o elemento en el XML
Static Function ObtUidXML(oXML,cNodo)

	Local cXML     := ""     
	Local cError   := ""
	Local cDetalle := ""   
	Local lRet     := .F.
	
	If valType(oXml) == "O"				//Es un objeto
		SAVE oXML XMLSTRING cXML
	
		If AT( "ERROR" , Upper(cXML) ) > 0	// El archivo tiene errores
			If 	ValType(oXml:_ERROR) == "O"
				cError   := oXml:_ERROR:_CODIGO:TEXT
				cDetalle := oXml:_ERROR:_DESCRIPCIONERROR:TEXT   
		    Endif
		Else		//Obtener identificador del certificado 				
			If At( UPPER(cNodo) , Upper(cXml) ) > 0
				lRet := .T. 
			Endif
		Endif
	Endif
	
Return lRet

//Carga Logo de la empresa
Static Function fCarLogo(cLogo)
	Local  cStartPath:= GetSrvProfString("Startpath","")
	
	cLogo	:= cStartPath + "LGRL"+SM0->M0_CODIGO+SM0->M0_CODFIL+".BMP" // Empresa+Filial
	//-- Logotipo da Empresa
	If !File( cLogo )
		cLogo := cStartPath + "LGRL"+SM0->M0_CODIGO+".BMP" // Empresa
	Endif

Return cLogo

//Comprueba el espacio restante en la pagina y crea el fin de p·gina y el inicio de la siguiente.
static Function newPage(oPrinter,lCheck)
	Local lNewPage := .F.
	Default lCheck := .F.
	
	If lCheck
		lNewPage := .T.	
	Else 	
		If li >= 815
			lNewPage := .T.	
		EndIf
	End If
	
	If lNewPage
		oPrinter:Line(820,5,820,585,,"-4")
		oPrinter:SAY(825,10 , msg,oFont7)
		oPrinter:EndPage()
		LI := 50
		oPrinter:StartPage()
		oPrinter:Line(5,5,820,5,,"-4") //Linea lateral izquierda
		oPrinter:Line(5,585,820,585,,"-4") //Linea lateral derecha
		oPrinter:Line(5,5,5,585,,"-4")//Linea horizontal de marco
	End If
	
Return

//Obtiene el reotiero correspondiente.
Static function getRoteir()     
    
    Local cRoteir:=''
    
	dbselectarea("SRY")
    dbsetorder(1)
	cTmpSRY			:= criatrab(nil,.F.) 	// Tabla temporal
	cSRYRetSqlName  := InitSqlName("SRY") 	//Se obtiene el nombre  fisico de la tabla
	cFilSRY 		:= xfilial("SRY")  		// se obtiene la filial de la tabla  SRY
	
	cQuery := "SELECT RY_CALCULO "
	cQuery += "FROM " + cSRYRetSqlName +	" "
   	cQuery += "WHERE RY_ORDINAR='1' AND RY_TIPO='1' AND RY_FILIAL='"+cFilSRY+"' AND D_E_L_E_T_<>'*' "
	
	cQuery := ChangeQuery(cQuery)                         	
	// coloca el resultado en cTmpSRY(Tabla temporal)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cTmpSRY,.T.,.T.) 
	(cTmpSRY)->(dbGoTop())

	While (cTmpSRY)->(!eof()) 
		cRoteir:=(cTmpSRY)->RY_CALCULO
	    (cTmpSRY)->(dbskip()) 
	End Do   
	
	(cTmpSRY)->(dbCloseArea())                        

Return cRoteir

//Obtiene el proceso correspondiente al empleado.
Static function getProc(cMatricula)     
    
    Local cProc:=''
    
	dbselectarea("SRE")
    dbsetorder(1)
	cTmpSRE			:= criatrab(nil,.F.) 	// Tabla temporal
	cSRERetSqlName  := InitSqlName("SRE") 	//Se obtiene el nombre  fisico de la tabla
	//cFilSRE 		:= xfilial("SRE")  		// se obtiene la filial de la tabla  SRE
	
	cQuery := "SELECT RE_PROCESD, RE_PROCESP "
	cQuery += "FROM " + cSRERetSqlName +	" "
   	cQuery += "WHERE RE_EMPD = RE_EMPP AND RE_FILIALD = RE_FILIALP AND" 
	cQuery += " RE_MATD = RE_MATP AND RE_PROCESD != RE_PROCESP AND RE_MATD = " + cMatricula + " "
	cQuery += "AND D_E_L_E_T_<>'*' "
	
	cQuery := ChangeQuery(cQuery)                         	
	// coloca el resultado en cTmpSRE(Tabla temporal)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cTmpSRE,.T.,.T.) 
	(cTmpSRE)->(dbGoTop())

	While (cTmpSRE)->(!eof()) 
		cProc:=(cTmpSRE)->RE_PROCESP
	    (cTmpSRE)->(dbskip()) 
	End Do   
	
	(cTmpSRE)->(dbCloseArea())                        

Return cProc 

Static Function LeeArch(cFile)

	Local cBuffer	:= ""
	Local nFor		:= 0
	Local nHandle
	Local nX		:= 0
	Local lRet      := .F.
	Local cLinea	:= ""

	Local cSalto	:= Chr(13) + Chr(10)
	
	nHandle := FT_FUse(cFile)
	
	If  nHandle = -1
		return .F.
	Endif

	FT_FGoTop()
	
	nFor := FT_FLastRec()
	
	
	While !FT_FEOF()
	
		//cLinea := FT_FReadLn()
		cLinea := FT_FReadLn()
		cBuffer += IIF(nX<>0,cSalto,"")+ Alltrim(cLinea)
		//cBuffer +=  Alltrim(cLinea)
	 	
		FT_FSKIP()
		nX += 1 
	End
	
	FT_FUSE()
		
Return cBuffer

static Function FTPTranfer(cRuta,cArch)	
Local aRetDir := {}		//Tenta se conectar ao servidor ftp em localhost na porta 21	//com usu·rio e senha anÙnimos	
if !FTPCONNECT( "10.195.4.49" , 21 ,"ftp.test.com|ftp", "ftp" )		
	conout( "Nao foi possivel se conectar!!" )		
	Return NIL	
Else
		//Tenta realizar o upload de um item qualquer no array   	
		//Armazena no local indicado pela constante PATH	
		if !FTPUPLOAD( cRuta + cArch , "\" + cArch )		
			conout( "Nao foi possivel realizar o upload!!" )   		
			Return NIL   	
		EndIf		
		//Tenta desconectar do servidor ftp		
	FTPDISCONNECT()
EndIf
Return

//Limpia la carpeta HTTP de los archivos .Zip creados al menos un dÌa antes
static Function ClearFolder(cPath)
	Local aArqDir := Directory(cPath + "*.Zip")
	Local nX := 0
	
	For nX := 1 to Len(aArqDir)
		If DtoS(aArqDir[nX][3]) < DtoS(Date())
			FERASE(cPath + aArqDir[nX][1])
		EndIf		
	Next
		
Return
