
#INCLUDE "protheus.ch"
#INCLUDE "PNOM009.ch"
                                                                   
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ PNOM009  ³ Autor ³ Gpe Santacruz         ³ Data ³26/02/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Control del supervisor                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAGPE  - Portales de Nomina -                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³GSANTACRUZ  ³17/06/10³CORR  ³Que actuAlice con Ddatabse el campo FECRES³±±
±±³            ³        ³      ³                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³GSANTACRUZ  ³24/03/11³Mejo  ³Evite desplegar los empleado dados de baja³±±
±±³            ³        ³      ³                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³GSANTACRUZ  ³09/04/13³TGZZCO³Modificacion de extraccion de matricula   ³±±
±±³            ³        ³      ³en el arreglo del usuario                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/         

user Function PNOM009()

Local aArea     := GetArea()
Local aSvKeys	:= GetKeys()
Local cCadastro := OemToAnsi(STR0001) //"Control del Supervisor"

//PARA EL DIALOG
Local aButtons:={}

Local bOk:={||odlg:end()}
Local bCan:={||odlg:end()}
  
Local aPosObj   := {}
Local aObjects  := {}
Local aSize     := {}
Local aInfo     := {}


Local ni:=0
//BOTONES
Local bAutPre:={||AutoPrestamo()}
Local bAutVac:={||}
Local bConDat:={||}
Local bHisLab:={||}
Local bConPre:={||}
Local bConVac:={||}
Local bconaus:={||}
Local bSalir:={||oDlg:End()}

Local nOpca:=0
Local cTitSup:=''
Local cTitNom:=''
Local cTitDep:=''

Local cDepsup:=''
Local cDesDep:=''	
Local nUsado:=0     
Local cQryCond:=''
Local oTBar
Local oDlg   
Local nPosMat:=0
Local nPosNom:=0
Local aUser:={}

Private oGet
Private CMATSUP:=' ' //Clave del supervisor
Private cNomSup:='' 

Private cAliasZZB:=UPPER(alltrim(GETMV("PT_SOLVAC")))
Private cAliasZZA:=UPPER(alltrim(GETMV("PT_SOLPRE")))
CURSORWAIT()

/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Busca amtricula del usuario registrado³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
PswOrder(1)
If PswSeek(__cUserId)
	aUser := PswRet(1)
	If Len(aUser) > 0
	
    
	    cMatsup:=substr(aUser[1,22],len(alltrim(aUser[1,22]))-	TAMSX3("RA_MAT")[1]+1,TAMSX3("RA_MAT")[1])
	   
		//cMatsup := substr(aUser[1,22],5,len(aUser[1,22]))
		
	EndIf
Endif

/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Abre las tablas que se utilizaran³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
	dbselectarea("SRA")	
	dbselectarea("SQB")	
	dbselectarea("SRJ")	
	dbselectarea("SQ3")	
	dbselectarea("RGC")	
	dbselectarea("RCP")	
	DBSELECTAREA("SRE") 
	DBSELECTAREA("CTT")   
	DBSELECTAREA("SRC") 
	DBSELECTAREA("SRD")   
	DBSELECTAREA("SR8")   
	DBSELECTAREA(cAliasZZA)   
	DBSELECTAREA(cAliasZZB)   	

/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Agrega botones especiales³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
       aAdd(aButtons, {'TPOPAGTO1' ,{||AutoPrestamo()},OemToAnsi(STR0003),OemToAnsi(STR0003)})//"Prestamos por Autorizar"
       aAdd(aButtons, {'FERIAS' ,{||AutoVacacion()},OemToAnsi(STR0004),OemToAnsi(STR0004)})//"Vacaciones por Autorizar"    
       aAdd(aButtons, {'BMPUSER' ,{||ConsDatosPer(oGet:acols[oGet:NAT,nPosMat])},OemToAnsi(STR0005),OemToAnsi(STR0005)})//"Datos Personales"
       aAdd(aButtons, {'SDUSTRUCT' ,{|| HistoLaboral(oGet:acols[oGet:NAT,nPosMat],oGet:acols[oGet:NAT,nPosNom])},OemToAnsi(STR0006),OemToAnsi(STR0006)}) //"Historia Laboral"
       aAdd(aButtons, {'BAIXATIT' ,{||ConsPres()},OemToAnsi(STR0007),OemToAnsi(STR0007)}) //"Historial de Prestamos "     
       aAdd(aButtons, {'AFASTAMENTO' ,{||ConsVac(oGet:acols[oGet:NAT,nPosMat],oGet:acols[oGet:NAT,nPosNom])},OemToAnsi(STR0008),OemToAnsi(STR0008)})//"Historial de Vacaciones "
       aAdd(aButtons, {'BMPCALEN' ,{||ConsAuse(oGet:acols[oGet:NAT,nPosMat],oGet:acols[oGet:NAT,nPosNom])},OemToAnsi(STR0009),OemToAnsi(STR0009)})// "Historial de Ausencias "

	/*/
	  ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  ³Prepara información para los GetDados³
	  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ /*/
	       
	aMuestra:= {"RA_MAT","RA_NOME","RA_DEPTO","QB_DESCRIC","RA_CODFUNC","RJ_DESC","RA_CARGO","Q3_DESCSUM"} //Solo datos que mostrara
	dbSelectArea("SX3")
	dbSetorder(2)
	aHeader:={}
	nUsado:=0
	for ni:= 1 to len(aMuestra)
		if sx3->(dbSeek(aMuestra[ni]))
			If X3USO(x3_usado).And.cNivel>=x3_nivel
				nUsado++
				AADD(aHeader,{ TRIM(x3titulo()), x3_campo, x3_picture,x3_tamanho,;
					 x3_decimal,"AllwaysTrue()",x3_usado, x3_tipo, x3_arquivo, x3_context } )
			Endif      
		endif	

	next

	//Prepara aCols
	
    cQryCond:= "SELECT RA_MAT, RA_NOME,RA_DEPTO,RA_CODFUNC,RA_CARGO, QB_DESCRIC, RJ_DESC, Q3_DESCSUM FROM "
    cQryCond+= RetSqlName("SRA") + " SRA "                             
    cQryCond	+= " LEFT OUTER JOIN " + RetSqlName("SQB") + " SQB"
    If ( TcSrvType()=="AS/400" )
	   cQryCond	+= " ON SQB.@DELETED@"
    ELSE
	   cQryCond	+= " ON SQB.D_E_L_E_T_ = ' ' "
	ENDIF   
    cQryCond	+= " AND QB_FILIAL='"+XFILIAL("SQB")+"' "
    cQryCond	+= " AND QB_DEPTO=RA_DEPTO"
    cQryCond	+= " LEFT OUTER JOIN " + RetSqlName("SRJ") + " SRJ"
    If ( TcSrvType()=="AS/400" )
	   cQryCond	+= " ON SRJ.@DELETED@"
    ELSE
	   cQryCond	+= " ON SRJ.D_E_L_E_T_ = ' ' "
	ENDIF   
    cQryCond	+= " AND RJ_FILIAL='"+XFILIAL("SRJ")+"' "
    cQryCond	+= " AND RJ_FUNCAO = RA_CODFUNC"
    cQryCond	+= " LEFT OUTER JOIN " + RetSqlName("SQ3") + " SQ3"
    If ( TcSrvType()=="AS/400" )
	   cQryCond	+= " ON SQ3.@DELETED@"
    ELSE
	   cQryCond	+= " ON SQ3.D_E_L_E_T_ = ' ' "
	ENDIF   
    cQryCond	+= " AND Q3_FILIAL ='"+XFILIAL("SQ3")+"' "
    cQryCond	+= " AND Q3_CARGO = RA_CARGO"
    If ( TcSrvType()=="AS/400" )
		cQryCond+=" AND SQ3.@DELETED@  = ' ' "
    ELSE
		cQryCond+= " AND SQ3.D_E_L_E_T_  = ' ' "
	ENDIF	                
    cQryCond+=" WHERE  RA_FILIAL  ='"+XFILIAL("SRA")+"' "
    cQryCond+=" AND RA_SUPERVI = '"+CMATSUP+"' "
    cQryCond+=" AND RA_SITFOLH <>'D' " 
    If ( TcSrvType()=="AS/400" )
		cQryCond+="     AND SRA.@DELETED@  = ' ' " 
	ELSE 
		cQryCond+="     AND SRA.D_E_L_E_T_  = ' ' " 
	ENDIF                                       
    cQryCond+= " ORDER BY RA_NOME "
    cQryCond := ChangeQuery(cQryCond)
    DbUseArea( .T., 'TOPCONN', TCGENQRY(,, cQryCond), "TRB", .T., .T. )
	dbSelectArea("TRB")                      
	aCols:={}
	While !TRB->(EOF())
			AADD(aCols,Array(nUsado+1))
			For ni:=1 to nUsado
				aCols[Len(aCols),ni]:=FieldGet(FieldPos(aHeader[ni,2]))
			Next 
			aCols[Len(aCols),nUsado+1]:=.F.
		TRB->(dbSkip())
	EnddO
	trb->(DbCloseArea())		                                       
	
	if len(aCols)==0
	   msgInfo(OemToAnsi(STR0002)+cMatsup)   //"No hay empleados asignados al supervisor con matricula :"                       
	   RestArea(aArea)
	   RestKeys( aSvKeys , .T. ) // Restaura as Teclas de Atalho                				   
	   cursorarrow()
	   Return
	endif
	
	nPosMat:=GdFieldPos( "RA_MAT" , aHeader)
	nPosNom:=GdFieldPos( "RA_NOME" , aHeader)	

	/*
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Datos para el Encabezado³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	*/

	SX3->(DBSETORDER(2))
	SX3->(DBSEEK("RA_SUPERVI"))
	cTitSup:=x3Titulo()
	SX3->(DBSEEK("RA_NOME"))
	cTitNom:=x3Titulo()
	SX3->(DBSEEK("RA_DEPTO"))
	cTitDep:=alltrim(x3Titulo())          
    cNomSup:='' ;    cDepsup:='';	cDesDep:=''	
	SRA->(DBSETORDER(1))
	IF SRA->(DBSEEK(XFILIAL("SRA")+CMATSUP))
	   cNomSup:=SRA->RA_NOME
	   cDepsup:=SRA->RA_DEPTO
	   SQB->(DBSETORDER(1))
	   IF SQB->(DBSEEK(XFILIAL("SQB")+cDepsup))
		  cDesDep:=SQB->QB_DESCRIC
	   ENDIF	
	ENDIF   
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Hace  calculo automatico de dimenciones de objetos     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
		aSize := MsAdvSize()
		AAdd( aObjects, { 30, 30, .T., .T. } )  //VENTANA DEL ENCABEZADO     
		AAdd( aObjects, { 245, 245, .T., .T. } )//VENTANA DEL GETDADOS 

		aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
		aPosObj := MsObjSize( aInfo, aObjects,.T.)                       

CURSORARROW()	                      

	DEFINE FONT oFont NAME "Arial" SIZE 0,-12 BOLD
	DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 To aSize[6],aSize[5] of oMainWnd PIXEL
//		DEFINE BUTTONBAR oBar SIZE 25,25 3D TOP OF oDlg
   
   //		DEFINE BUTTON RESOURCE "TPOPAGTO1" 	OF oBar ACTION AutoPrestamo() TOOLTIP STR0003 //"Prestamos por Autorizar"
	//	DEFINE BUTTON RESOURCE "FERIAS" 	OF oBar ACTION AutoVacacion() TOOLTIP STR0004 //"Vacaciones por Autorizar"
	 //	DEFINE BUTTON RESOURCE "BMPUSER" 	OF oBar ACTION ConsDatosPer(oGet:acols[oGet:NAT,nPosMat]) TOOLTIP STR0005 //"Datos Personales"
	  //	DEFINE BUTTON RESOURCE "SDUSTRUCT" 	OF oBar ACTION HistoLaboral(oGet:acols[oGet:NAT,nPosMat],oGet:acols[oGet:NAT,nPosNom]) TOOLTIP STR0006 //"Historia Laboral"
//		DEFINE BUTTON RESOURCE "BAIXATIT" 	OF oBar ACTION ConsPres() TOOLTIP STR0007 //"Historial de Prestamos "
  //		DEFINE BUTTON RESOURCE "AFASTAMENTO" 	OF oBar ACTION ConsVac(oGet:acols[oGet:NAT,nPosMat],oGet:acols[oGet:NAT,nPosNom]) TOOLTIP STR0008 //"Historial de Vacaciones "
	//	DEFINE BUTTON RESOURCE "BMPCALEN" 	OF oBar ACTION ConsAuse(oGet:acols[oGet:NAT,nPosMat],oGet:acols[oGet:NAT,nPosNom]) TOOLTIP STR0009 // "Historial de Ausencias "
	  //	DEFINE BUTTON RESOURCE "FINAL" 	OF oBar ACTION oDlg:End() TOOLTIP STR0010 //"Salir"
/*		oTBar := TBar():New( oDlg,25,32,.T.,,,,.F. )
		oTBtnBmp2_1	:= TBtnBmp2():New( 00, 00, 25, 25, 'TPOPAGTO1' ,,,,;
						bAutPre, oTBar,'Autorización de Prestamos',,.F.,.F. )
		oTBtnBmp2_2	:= TBtnBmp2():New( 00, 00, 25, 25, 'FERIAS'  ,,,,;
						bAutVac,oTBar,'Autorización de Vacaciones',,.F.,.F. )
		oTBtnBmp2_3	:= TBtnBmp2():New( 00, 00, 25, 25, 'BMPUSER'   ,,,,;
						bConDat,oTBar,'Datos Personales',,.F.,.F. )
		oTBtnBmp2_4	:= TBtnBmp2():New( 00, 00, 25, 25, 'SDUSTRUCT'    ,,,,;
						bHisLab,oTBar,'Historia Laboral'  ,,.F.,.F. )					
		oTBtnBmp2_5	:= TBtnBmp2():New( 00, 00, 25, 25, 'BAIXATIT'    ,,,,;
						bConPre,oTBar,'Consulta de Prestamos'  ,,.F.,.F. )					
		oTBtnBmp2_6	:= TBtnBmp2():New( 00, 00, 25, 25, 'AFASTAMENTO'   ,,,,;
						bConVac,oTBar,'Consulta de Vacaciones',,.F.,.F. )
		oTBtnBmp2_7	:= TBtnBmp2():New( 00, 00, 25, 25, 'BMPCALEN'    ,,,,;
						bConAus,oTBar,'Consulta de ausencias'  ,,.F.,.F. )					
		oTBtnBmp2_8	:= TBtnBmp2():New( 00, 00, 25, 25, 'FINAL'    ,,,,;
						bSalir,oTBar,'Salir'  ,,.F.,.F. )					
  */						
		@aPosObj[1,1]+1,aPosObj[1,2]     SAY cTitSup  SIZE 40,7 OF oDlg PIXEL   FONT oFont 	
 	    @aPosObj[1,1]+1,aPosObj[1,2]+90  SAY cTitNom  SIZE 40,7 OF oDlg PIXEL   FONT oFont 	
   		@aPosObj[1,1]+15,aPosObj[1,2]+90 SAY cTitDep  SIZE 40,7 OF oDlg PIXEL	  FONT oFont 	                      
   		
		@ aPosObj[1,1]+1,aPosObj[1,2]+40   MSGET cMatsup PICTURE "@!" WHEN .F. SIZE 30,7 OF oDLG PIXEL   
		@ aPosObj[1,1]+1,aPosObj[1,2]+130  MSGET cNomsup PICTURE "@!" WHEN .F. SIZE 150,7 OF oDLG PIXEL   
		@ aPosObj[1,1]+15,aPosObj[1,2]+130 MSGET cDepsup PICTURE "@!" WHEN .F. SIZE 30,7 OF oDLG PIXEL   		
		@ aPosObj[1,1]+15,aPosObj[1,2]+170 MSGET cDesDep PICTURE "@!" WHEN .F. SIZE 100,7 OF oDLG PIXEL   		
		
      	 oGet:= MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],4,"AllwaysTrue" ,"AllwaysTrue" ,nil,, 0, 999,"AllwaysTrue" ,; 
        		                             "",nil ,  oDlg, aHeader, aCols)

	ACTIVATE MSDIALOG oDlg CENTER  ON INIT EnchoiceBar(oDlg,bOk,bCan,,aButtons)
	

RestArea(aArea)
RestKeys( aSvKeys , .T. ) // Restaura as Teclas de Atalho                				   
RETURN

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    AutoPrestamo       ³ Gpe Santacruz         ³ Data ³04/03/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Autorizacion de Prestamos                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ AutoPrestamo()   		                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³  													      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³PNOM009                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±/*/

Static function AutoPrestamo

                              
Local aButtons:={}
//Local cAliasZZA:=UPPER(alltrim(GETMV("PT_SOLPRE")))
Local cTitMat:=''
Local cTitNom:=''
Local cTitFec:=''         
Local cTitPd:=''
Local cTitDesPd:=''
Local cTitImp:=''
Local bMarcTod:={||(MarcProd( oListBox , @aListBox , @oDlg , "M" ),oListBox:nColPos := 1,oListBox:Refresh())}
Local bDesmTod:={||(MarcProd( oListBox , @aListBox , @oDlg , "D" ),oListBox:nColPos := 1,oListBox:Refresh())}
Local bInverte:={||(MarcProd( oListBox , @aListBox , @oDlg , "I" ),oListBox:nColPos := 1,oListBox:Refresh())}
Local bCanPres:={|| if (CanAutoPres(cAliasZZA),oDlg:End(),)}
Local bAutoriza:={|| if (GrbAutoPres(cAliasZZA), oDlg:End(),)}
Local bCancela:={||oDlg:End()}

Private aPosicio:={}
Private aListBox :={}
Private oListBox 
Private oOk		 := LoadBitmap( GetResources(), "LBOK" )
Private oNo		 := LoadBitmap( GetResources(), "LBNO" )


/*
  ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³Prepara botones de la barra de herramientas
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ /*/
CURSORWAIT()
	

       aAdd(aButtons, {'BMPDEL' , bCanPres,OemToAnsi(STR0011),OemToAnsi(STR0012)})//"Rechazar Prestamo","Rechazar"

       aListBox:=U_PN9SOLPRES() //Consulta de prestamos
       
       IF LEN(aListBox)== 0          
	      CURSORARROW()	                      
          MSGinfo (OemToAnsi(STR0013)) //"No hay Solicitudes de Prestamos pendientes..."
          Return
       endif    
       
	/*
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Datos para el Encabezado³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	*/

	SX3->(DBSETORDER(2))
	SX3->(DBSEEK(cAliasZZA+"_MAT"))
	cTitMat:=x3Titulo()
	SX3->(DBSEEK("RA_NOME"))
	cTitNom:=x3Titulo()
	SX3->(DBSEEK(cAliasZZA+"_FECSOL"))
	cTitFec:=alltrim(x3Titulo())          
	SX3->(DBSEEK(cAliasZZA+"_PD"))
	cTitPd:=alltrim(x3Titulo())
	SX3->(DBSEEK("RV_DESC"))
	cTitDesPd:=alltrim(x3Titulo())
	SX3->(DBSEEK(cAliasZZA+"_IMPORTE"))
	cTitImp:=alltrim(x3Titulo())

CURSORARROW()	                      

	DEFINE MSDIALOG oDlg TITLE OemToAnsi(STR0014) From 50,100 To 400,800 of oMainWnd PIXEL //"Autorización de Préstamos" 

	     @ 30,0 LISTBOX oListBox FIELDS HEADER "",cTitMat,cTitNom,cTitFec,cTitPd,cTitDesPd,cTitImp    SIZE 351, 160 PIXEL ON DBLCLICK (MarcProd(oListBox,@aListBox,@oDlg),oListBox:nColPos := 1,oListBox:Refresh())  //NOSCROLL 
	     oListBox:SetArray( aListBox )
		 oListBox:bLine := { || { IF(aListBox[oListBox:nAt,1],oOk,oNo),aListBox[oListBox:nAt,2],aListBox[oListBox:nAt,3],aListBox[oListBox:nAt,4],aListBox[oListBox:nAt,5],aListBox[oListBox:nAt,6],aListBox[oListBox:nAt,7]} }
      	 oGroup:= tGroup():New(178,2,197,350,,oDlg,,CLR_WHITE,.T.)	
	  	 oBtnMarcTod:=tButton():New( 181,168,OemToAnsi(STR0015) ,oGroup,bMarcTod,54.50,13.50  ,,,.F.,.T.,.F.,,.F.,,,.F. )	 //"Marca Todos"
	   	 oBtnDesmTod:=tButton():New( 181,224,OemToAnsi(STR0016) ,oGroup,bDesmTod,54.50,13.50  ,,,.F.,.T.,.F.,,.F.,,,.F. )	 //"Desmarca Todos"
	   	 oBtnInverte:=tButton():New( 181,280 ,OemToAnsi(STR0017) ,oGroup,bInverte,54.50,13.50  ,,,.F.,.T.,.F.,,.F.,,,.F. ) //"Marca Todos"
       	
	ACTIVATE MSDIALOG  oDlg CENTER  ON INIT EnchoiceBar(oDlg,bAutoriza,bCancela,,aButtons)


Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    AutoVacacion       ³ Gpe Santacruz         ³ Data ³04/03/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Autorizacion de Vacaciones                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ AutoVacacion()   		                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³  													      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³PNOM009                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±/*/


Static function AutoVacacion

                              
Local aButtons:={}
//Local cAliasZZB:=UPPER(alltrim(GETMV("PT_SOLVAC")))
Local cTitMat:=''
Local cTitNom:=''
Local cTitFec:=''         
Local cTitPd:=''
Local cTitDesPd:=''
Local cTitImp:=''
Local bMarcTod:={||(MarcProd( oListBox , @aListBox , @oDlg , "M" ),oListBox:nColPos := 1,oListBox:Refresh())}
Local bDesmTod:={||(MarcProd( oListBox , @aListBox , @oDlg , "D" ),oListBox:nColPos := 1,oListBox:Refresh())}
Local bInverte:={||(MarcProd( oListBox , @aListBox , @oDlg , "I" ),oListBox:nColPos := 1,oListBox:Refresh())}
Local bCanVac:={|| if (CanAutoVac(cAliasZZB),oDlg:End(),)}
Local bAutoriza:={|| if (GrbAutoVac(cAliasZZB), oDlg:End(),)}
Local bCancela:={||oDlg:End()}

Private aPosicio:={}
Private aListBox :={}
Private oListBox 
Private oOk		 := LoadBitmap( GetResources(), "LBOK" )
Private oNo		 := LoadBitmap( GetResources(), "LBNO" )

/*
  ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³Prepara botones de la barra de herramientas
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ /*/
CURSORWAIT()
	

       aAdd(aButtons, {'BMPDEL' , bCanVac,OemToAnsi(STR0018),OemToAnsi(STR0019)})//"Rechazar Vacaciones","Rechazar"

       aListBox:=U_PN9SOLVAC() //Consulta de vacaciones
       
       IF LEN(aListBox)== 0          
	      CURSORARROW()	                      
          MSGinfo (OemToAnsi(STR0020)) //"No hay Solicitudes de Vacaciones pendientes..."
          Return
       endif    
       
	/*
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Datos para el Encabezado³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	*/

	SX3->(DBSETORDER(2))
	SX3->(DBSEEK(cAliasZZB+"_MAT"))
	cTitMat:=x3Titulo()
	SX3->(DBSEEK("RA_NOME"))
	cTitNom:=x3Titulo()
	SX3->(DBSEEK(cAliasZZB+"_FECSOL"))
	cTitFec:=alltrim(x3Titulo())          
	SX3->(DBSEEK(cAliasZZB+"_PD"))
	cTitPd:=alltrim(x3Titulo())
	SX3->(DBSEEK("RV_DESC"))
	cTitDesPd:=alltrim(x3Titulo())
	SX3->(DBSEEK(cAliasZZB+"_FECINI"))
	cTitFeI:=alltrim(x3Titulo())
	SX3->(DBSEEK(cAliasZZB+"_FECFIN"))
	cTitFeF:=alltrim(x3Titulo())

CURSORARROW()	                      

	DEFINE MSDIALOG oDlg TITLE OemToAnsi(STR0021) From 100,100 To 500,800 of oMainWnd PIXEL //"Autorización de Vacaciones"

	     @ 30,0 LISTBOX oListBox FIELDS HEADER "",cTitMat,cTitNom,cTitFec,cTitPd,cTitDesPd,cTitFeI,cTitFeF    SIZE 351, 145 PIXEL ON DBLCLICK (MarcProd(oListBox,@aListBox,@oDlg),oListBox:nColPos := 1,oListBox:Refresh())  //NOSCROLL 
	     oListBox:SetArray( aListBox )
		 oListBox:bLine := { || { IF(aListBox[oListBox:nAt,1],oOk,oNo),aListBox[oListBox:nAt,2],aListBox[oListBox:nAt,3],aListBox[oListBox:nAt,4],aListBox[oListBox:nAt,5],aListBox[oListBox:nAt,6],aListBox[oListBox:nAt,7],aListBox[oListBox:nAt,8]} }
      	 oGroup:= tGroup():New(178,2,197,350,,oDlg,,CLR_WHITE,.T.)	
	  	 oBtnMarcTod:=tButton():New( 181,168,OemToAnsi(STR0015) ,oGroup,bMarcTod,54.50,13.50  ,,,.F.,.T.,.F.,,.F.,,,.F. )	 //"Marca Todos"
	   	 oBtnDesmTod:=tButton():New( 181,224,OemToAnsi(STR0016) ,oGroup,bDesmTod,54.50,13.50  ,,,.F.,.T.,.F.,,.F.,,,.F. )	 //"Desmarca Todos"
	   	 oBtnInverte:=tButton():New( 181,280,OemToAnsi(STR0017) ,oGroup,bInverte,54.50,13.50  ,,,.F.,.T.,.F.,,.F.,,,.F. ) //"Marca Todos"
       	
	ACTIVATE MSDIALOG oDlg center ON INIT EnchoiceBar(oDlg,bAutoriza,bCancela,,aButtons)


Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ConsDatosPer       ³ Gpe Santacruz         ³ Data ³03/03/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Consulta de datos personales de cada empleado              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ConsDatosPer (cPar01) 		                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cPar01: Caracter, Matricula del empleado.				      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³PNOM009                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±/*/

static function ConsDatosPer (cMat)
Local aButtons:={}
Local bOk:={||odlg:end()}
Local bCan:={||odlg:end()}

Local aAlterEnch:={}  
Local aDatos:={}   
Local aCpoEnch:={}    
Local aPos		:= {25,000,400,600}
Local nModelo	:= 3         
Local lF3 		:= .F.
Local lMemoria	:= .T.
Local lColumn	:= .F.   
Local caTela 	:= ""
Local lNoFolder	:= .F.            
Local lProperty	:= .F. 
Local oDlg
Local oEnch
Local nOpc:=4 //solo visualizar
Local nPos:=0
Local nReg:=0

Private aTELA[0][0]
Private aGETS[0]

Inclui:= .f.
CursorWait()
	SRA->(DBSETORDER(1))
	IF !SRA->(DBSEEK(XFILIAL("SRA")+cMat))
	   MSGalert(OemToAnsi(STR0022)+cmat) //"No encontre datos para la matricula : "
	   Return
	ENDIF    
	nReg:=SRA->(RECNO())
	aDatos:=u_PN9DATPER() //verifica si en SIGATCF se han configurado los campos a visualizar de la SRA
	if len(aDatos)==0
	    msgAlert(OemToAnsi(STR0023))//"No hay datos configurados para visualizar desde la Terminal del Empleado, verifique!"
	    Return
	endif    
	DbSelectArea("SX3")
	DbSetOrder(1)
	DbSeek("SRA")
	
	While !Eof() .And. SX3->X3_ARQUIVO == "SRA"                                               
		nPos:= aScan(aDatos,{|x| alltrim(substr(x[5],1,11)) == alltrim(SX3->X3_CAMPO) } )
		IF nPos>0
		    if  aDatos[npos,1]==.t.
				AADD(aCpoEnch,SX3->X3_CAMPO)
			endif	
		EndIf		 
		DbSkip()
	End

CURSORARROW()	                      

	DEFINE MSDIALOG oDlg TITLE STR0102 From 80,80 To 800,1250 of oMainWnd PIXEL //"Datos Personales"
		RegToMemory("SRA", If(nOpc==3,.T.,.F.))
		oEnch:=	Enchoice("SRA", nReg, 4, /*aCRA*/, /*cLetra*/, /*cTexto*/, ;
		   aCpoEnch, aPos, aAlterEnch, nModelo, /*nColMens*/,;
 	        /*cMensagem*/,/*cTudoOk*/, oDlg, lF3, lMemoria, lColumn,;
	        caTela, lNoFolder, lProperty)

	   	
	ACTIVATE MSDIALOG oDlg center ON  INIT EnchoiceBar(oDlg,bOk,bCan,,aButtons)

Return               

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    HistoLaboral       ³ Gpe Santacruz         ³ Data ³03/03/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Consulta de Historial Laboral del cada empleado            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ConsDatosPer (cPar01) 		                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cPar01: Caracter, Matricula del empleado.				      ³±±
±±³          ³cPar02: Caracter, Nombre del empleado                       ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³PNOM009                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±/*/


static function HistoLaboral (cMat,cNom)
Local aButtons:={}
Local bOk:={||odlg:end()}
Local bCan:={||odlg:end()}
Local aMuestra:= {"RCP_DTMOV","RCP_TPMOV","RCP_SALDIA","RCP_SALDII","RCP_SALMES","RA_KEYLOC","RA_CC","RA_DEPTO","RA_CODFUNC","RA_CARGO"} //Solo datos que mostrara
Local aTitEnc:=  {OemToAnsi(STR0024),OemToAnsi(STR0025),OemToAnsi(STR0026),OemToAnsi(STR0027),OemToAnsi(STR0028),OemToAnsi(STR0029),OemToAnsi(STR0030),OemToAnsi(STR0031),OemToAnsi(STR0032),OemToAnsi(STR0033)}//"Fch Motivo","Tipo","Sal Diario","Sal Dia Int","Sal Mensual","Loc Pago","C.C.","Depto","Función","Cargo" 
Local aTamDat:= {8,10,0,0,0,10,10,20,20,20} 


Local aRcp:={}
Local ni:=0
Local nj:=0
Local aReaHead:=aclone(aheader)
Local aResaCol:=aclone(acols)
Local oGetH            
Local nUsado:=0  
Local oDlg
Private dIni:=ctod("  /  /  ")
Private dFin:=ctod("  /  /  ")
Private cStr:=""

PergHisLab("PNOM100009")   

if Pergunte("PNOM100009", .t.)
        dIni:=MV_PAR01
        dFin:=MV_PAR02
        cStr:=MV_PAR03
else
   return
endif    

cursorwait() 
	/*/
	  ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  ³Prepara información para los GetDados³
	  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ /*/
	       
	dbSelectArea("SX3")
	dbSetorder(2)
	aHeader:={}
	nUsado:=0
	for ni:= 1 to len(aMuestra)
		if sx3->(dbSeek(aMuestra[ni]))
			If X3USO(x3_usado).And.cNivel>=x3_nivel
				nUsado++
				AADD(aHeader,{ TRIM(aTitEnc[ni]), x3_campo, x3_picture,(if (aTamDat[ni]<>0,aTamDat[ni],x3_tamanho)),;
					 x3_decimal,"AllwaysTrue()",x3_usado, x3_tipo, x3_arquivo, x3_context } )
			Endif      
		endif	

	next
	//Prepara aCols                  
	aRcp:=u_PN9HISLAB(cStr,dIni,dFin,cmat) //extrae la informción de la historia laboral
	aCols:={}
	for ni:= 1 to len(aRcp)
			AADD(aCols,Array(nUsado+1))
			For nj:=1 to nUsado
				aCols[Len(aCols),nj]:=aRcp[ni,nj]
			Next 
			aCols[Len(aCols),nUsado+1]:=.F.

	next

	
	if len(aCols)==0
	   msgInfo(OemToAnsi(STR0034))//"No hay historia laboral para esta empleado"                          
	   aheader:=aclone(aReaHead )
	   acols:=aclone(aResaCol )
	   cursorarrow()
	   Return
	endif
	


cursorarrow()

	DEFINE MSDIALOG oDlg TITLE OemToAnsi(STR0035)+cMat+"-"+cNom From 100,100 To 500,1000 of oMainWnd PIXEL //"Historia Laboral de  "
      	 oGetH:= MsNewGetDados():New(30,0,200,451,4,"AllwaysTrue" ,"AllwaysTrue" ,nil,, 0, 999,"AllwaysTrue" ,; 
        		                             "",nil ,  oDlg, aHeader, aCols)

	ACTIVATE MSDIALOG oDlg center ON INIT EnchoiceBar(oDlg,bOk,bCan,,aButtons)

aheader:=aclone(aReaHead )
acols:=aclone(aResaCol )

Return



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ConsPres  ³       ³ Gpe Santacruz         ³ Data ³08/03/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Consulta de Prestamos activos de los empleados de la plani-³±±
±±³          ³ lla del supervisor.                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ConsPres()            		                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 				     										  ³±±
±±³          ³                 										      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³PNOM009                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±/*/


static function ConsPres 
Local aButtons:={}
Local bOk:={||odlg:end()}
Local bCan:={||odlg:end()}
Local aMuestra:= {"RK_MAT","RA_NOME","RK_VALORTO","RK_VLSALDO","RK_VALORPA","RK_DTVENC","RK_PARCELA","RK_PARCPAG","RK_STATUS"} //Solo datos que mostrara
Local aTamDat:= {0,0,0,0,0,0,0,0,10} 
Local aReaHead:=aclone(aheader)
Local aResaCol:=aclone(acols)
Local ni:=0
Local nUsado:=0  
Local oDlg                  
Local cfiltro:=''  
Local bFiltro:={||cFiltro:=u_PNM9MonExp("SRK",aMuestra), ogetpres:acols:=FilPrestamo(cFiltro,nusado),oGetPres:refresh()}
Private  oGetPres            
cursorwait() 
    aAdd(aButtons, {'FILTRO' , bFiltro,OemToAnsi(STR0036),OemToAnsi(STR0037)})//"Filtro","Filtro"
    
	/*/
	  ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  ³Prepara información para los GetDados³
	  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ /*/


	dbSelectArea("SX3")
	dbSetorder(2)
	aHeader:={}
	nUsado:=0
	for ni:= 1 to len(aMuestra)
		if sx3->(dbSeek(aMuestra[ni]))
			If X3USO(x3_usado).And.cNivel>=x3_nivel
				nUsado++
				AADD(aHeader,{ TRIM(x3titulo()), x3_campo, x3_picture,(if (aTamDat[ni]<>0,aTamDat[ni],x3_tamanho)),;
					 x3_decimal,"AllwaysTrue()",x3_usado, x3_tipo, x3_arquivo, x3_context } )
			Endif      
		endif	

	next
	//Prepara aCols                 
	aCols:=FilPrestamo(cFiltro,nusado)               

	
	if len(aCols)==0
	   msgInfo(OemToAnsi(STR0038))//"No hay prestamos activos de ningun empleado"                          
	   aheader:=aclone(aReaHead )
	   acols:=aclone(aResaCol )
	   cursorarrow()
	   Return
	endif

cursorarrow()

	DEFINE MSDIALOG oDlg TITLE OemToAnsi(STR0039) From 100,100 To 500,1000 of oMainWnd PIXEL //"Consulta de Prestamos "
      	 oGetPres:= MsNewGetDados():New(30,0,200,453,4,"AllwaysTrue" ,"AllwaysTrue" ,nil,, 0, 999,"AllwaysTrue" ,; 
        		                             "",nil ,  oDlg, aHeader, aCols)

	ACTIVATE MSDIALOG oDlg center ON INIT EnchoiceBar(oDlg,bOk,bCan,,aButtons)

aheader:=aclone(aReaHead )
acols:=aclone(aResaCol )

Return

static function FilPrestamo(cFiltro,nusado)

Local aSRK:={}
Local ni:=0
Local nj:=0

Local cMatFin:=REPLICATE("Z",TAMSX3("RK_MAT")[1])
Local Acols:={}
Default cfiltro:=''
aSRK:=u_PN9EXTPRES(space(TAMSX3("RK_MAT")[1]),cMatFin,CMATSUP,.T.,cFiltro) //extrae los prestamos activos   y filtrados

for ni:= 1 to len(aSRK)
			AADD(acols,Array(nUsado+1))
			For nj:=1 to nUsado
				acols[Len(acols),nj]:=aSRK[ni,nj]
			Next 
			acols[Len(acols),nUsado+1]:=.F.

next

Return aCols

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ConsVac   ³       ³ Gpe Santacruz         ³ Data ³10/03/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Consulta de Vacaciones  por empleado                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ConsVac ()            		                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 				     										  ³±±
±±³          ³                 										      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³PNOM009                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±/*/


static function ConsVac(cMat,cNome) 
Local aButtons:={}
Local bOk:={||odlg:end()}
Local bCan:={||odlg:end()}         



Local aMuestra:= {"RV_DESC","RF_DATABAS","RF_DATAFIM","RF_DFERVAT","R8_DURACAO","R8_SDPAGAR","RC_HORAS","R8_SDPAGAR"} //Solo datos que mostrara
Local aTitCam := {OemToAnsi(STR0040),OemToAnsi(STR0041),OemToAnsi(STR0042),OemToAnsi(STR0043),OemToAnsi(STR0044),OemToAnsi(STR0045),OemToAnsi(STR0046),OemToAnsi(STR0047)} //"Concepto"," "," ","Días Derecho ","Días Disfrutados","Días Programados","Días Pagados","Saldo" 
Local aTamDat:= {10,0,0,0,0,0,0,0} 
Local aReaHead:=aclone(aheader)
Local aResaCol:=aclone(acols)
Local ni:=0
Local nUsado:=0  
Local oDlg                  
Local cfiltro:=''  
//Local bFiltro:={||cFiltro:=u_PNM9MonExp("SR8",aMuestra), ogetVac:acols:=FilAusencia(CMAT,cFiltro,nusado),oGetVac:refresh()}
Private  oGetVac            
cursorwait() 
//  aAdd(aButtons, {'FILTRO' , bFiltro,"Filtro","Filtro"})
    
	/*/
	  ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  ³Prepara información para los GetDados³
	  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ /*/
	       

	dbSelectArea("SX3")
	dbSetorder(2)
	aHeader:={}
	nUsado:=0
	for ni:= 1 to len(aMuestra)
		if sx3->(dbSeek(aMuestra[ni]))
		//	If X3USO(x3_usado).And.cNivel>=x3_nivel
				nUsado++
				AADD(aHeader,{(if (!empty(aTitcam[ni]),aTitcam[ni], TRIM(x3titulo()))), x3_campo, x3_picture,(if (aTamDat[ni]<>0,aTamDat[ni],x3_tamanho)),;
					 x3_decimal,"AllwaysTrue()",x3_usado, x3_tipo, x3_arquivo, x3_context } )
		  //	Endif      
		endif	

	next
	//Prepara aCols                 
	aCols:=FilVac(CMAT,nusado)               

	
	if len(aCols)==0
	   msgInfo("No hay vacaciones para el empleado :"+cmat+"-"+cnome)                          
	   aheader:=aclone(aReaHead )
	   acols:=aclone(aResaCol )
	   cursorarrow()
	   Return
	endif
	


cursorarrow()

	DEFINE MSDIALOG oDlg TITLE OemToAnsi(STR0048)+cmat+"-"+cnome From 100,100 To 500,1000 of oMainWnd PIXEL //"Consulta de Vacaciones de "
      	 oGetVac := MsNewGetDados():New(30,0,200,451,4,"AllwaysTrue" ,"AllwaysTrue" ,nil,, 0, 999,"AllwaysTrue" ,; 
        		                             "",nil ,  oDlg, aHeader, aCols)

	ACTIVATE MSDIALOG oDlg center ON INIT EnchoiceBar(oDlg,bOk,bCan,,aButtons)

aheader:=aclone(aReaHead )
acols:=aclone(aResaCol )

Return

static function FilVac(cMat,nusado)
Local aSR8:={}
Local ni:=0
Local nj:=0


Local Acols:={}

aSR8:=u_PN9EXTVAC(cmat) //extrae las vacaciones

for ni:= 1 to len(aSR8)
			AADD(acols,Array(nUsado+1))
			For nj:=1 to nUsado
				acols[Len(acols),nj]:=aSR8[ni,nj]
			Next 
			acols[Len(acols),nUsado+1]:=.F.

next

Return aCols

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ConsAuse  ³       ³ Gpe Santacruz         ³ Data ³09/03/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Consulta de Ausencias                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ConsAuse()            		                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 				     										  ³±±
±±³          ³                 										      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³PNOM009                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±/*/


static function ConsAuse(cMat,cNome) 
Local aButtons:={}
Local bOk:={||odlg:end()}
Local bCan:={||odlg:end()}         

Local aMuestra:= {"R8_PD","RV_DESC","R8_DATAINI","R8_DATAFIM","R8_DURACAO","R8_TIPORSC"} //Solo datos que mostrara
Local aTamDat:= {0,0,0,0,0,20} 
Local aReaHead:=aclone(aheader)
Local aResaCol:=aclone(acols)
Local ni:=0
Local nUsado:=0  
Local oDlg                  
Local cfiltro:=''  
Local bFiltro:={||cFiltro:=u_PNM9MonExp("SR8",aMuestra), ogetaus:acols:=FilAusencia(CMAT,cFiltro,nusado),oGetAus:refresh()}
Private  oGetAus            
cursorwait() 
    aAdd(aButtons, {'FILTRO' , bFiltro,OemToAnsi(STR0049),OemToAnsi(STR0050)}) //"Filtro","Filtro"
    
	/*/
	  ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  ³Prepara información para los GetDados³
	  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ /*/
       
	dbSelectArea("SX3")
	dbSetorder(2)
	aHeader:={}
	nUsado:=0
	for ni:= 1 to len(aMuestra)
		if sx3->(dbSeek(aMuestra[ni]))
			If X3USO(x3_usado).And.cNivel>=x3_nivel
				nUsado++
				AADD(aHeader,{ TRIM(x3titulo()), x3_campo, x3_picture,(if (aTamDat[ni]<>0,aTamDat[ni],x3_tamanho)),;
					 x3_decimal,"AllwaysTrue()",x3_usado, x3_tipo, x3_arquivo, x3_context } )
			Endif      
		endif	

	next
	//Prepara aCols                 
	aCols:=FilAusencia(CMAT,CFILTRO,nusado)               

	
	if len(aCols)==0
	   msgInfo(OemToAnsi(STR0051)+cmat+"-"+cnome)   //"No hay ausencias para el empleado :"                       
	   aheader:=aclone(aReaHead )
	   acols:=aclone(aResaCol )
	   cursorarrow()
	   Return
	endif
	


cursorarrow()

	DEFINE MSDIALOG oDlg TITLE OemToAnsi(STR0052)+cmat+"-"+cnome From 100,100 To 500,1000 of oMainWnd PIXEL //"Consulta de Ausencias de "
      	 oGetaus := MsNewGetDados():New(30,0,200,451,4,"AllwaysTrue" ,"AllwaysTrue" ,nil,, 0, 999,"AllwaysTrue" ,; 
        		                             "",nil ,  oDlg, aHeader, aCols)

	ACTIVATE MSDIALOG oDlg center ON INIT EnchoiceBar(oDlg,bOk,bCan,,aButtons)

aheader:=aclone(aReaHead )
acols:=aclone(aResaCol )

Return

static function FilAusencia(cMat,cFiltro,nusado)
Local aSR8:={}
Local ni:=0
Local nj:=0


Local Acols:={}
Default cfiltro:=''
aSR8:=u_PN9EXTAUS(cmat,.T.,cFiltro) //extrae las ausencias

for ni:= 1 to len(aSR8)
			AADD(acols,Array(nUsado+1))
			For nj:=1 to nUsado
				acols[Len(acols),nj]:=aSR8[ni,nj]
			Next 
			acols[Len(acols),nUsado+1]:=.F.

next

Return aCols

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    GrbAutoPres        ³ Gpe Santacruz         ³ Data ³03/03/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Graba el Prestamo Autorizado y lo envia por Mail           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³GrbAutoPres(cPar01)	 		                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cPar01: Caracter, Alias de la tabla.              	      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³AutoPrestamo                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±/*/

static function GrbAutoPres(cTabla)
Local ni:=0
Local lRet:= .f.

Local cEnvioMail:=supergetmv("PT_ENVAUT",.T.,"Configure parámetro PT_ENVAUT",) //SI S enviara mail para autorización
Local cMailNom:=''
Local cMailSup:=''  
Local cAssunto:=''  
Local ccMensagem:=''
Local cAttach:="" 
Local lPasa:= .t.  

IF aScan(oListBox:aarray,{|x| x[1] == .T.} )>0
    if cEnvioMail=='S' //si enviara correo de autorizacion al administrador de nomina
	    cMailNom:=Supergetmv("PT_MAILAN",.T.,"Configure parámetro PT_MAILAN",)
	    SRA->(DBSETORDER(1))
		IF SRA->(DBSEEK(XFILIAL("SRA")+CMATSUP) )
			cMailSup:=SRA->RA_EMAIL
		ENDIF
	    IF EMPTY(cMailSup)
	       MSGINFO(OemToAnsi(STR0053))//"Es necesario el correo electronico del supervisor para poder autorizar!"
	       lPasa:= .f.
	    endif   
	    IF EMPTY(cMailNom)
	       MSGINFO(OemToAnsi(STR0054))//"Es necesario el correo electronico del Administrador de Nominas para poder autorizar!"
	       lPasa:= .f.
	    endif   
	    if !lPasa
	       return .f.
	    endif        
    endif
	if MsgYesNo(OemToAnsi(STR0055)) //"¿Estas Seguro de Autorizar?"
	    CURSORWAIT()
		if cEnvioMail=='S'
		  
	       cAssunto:= OemToAnsi(STR0056)  //"Autorizacion de Prestamos"
	       ccMensagem:= OemToAnsi(STR0057)+CRLF //"Se autorizan los prestamos al siguiente personal:" 
  	       ccMensagem+=CRLF
	       
                                 
 	       For ni:=1 to len(oListBox:aarray)
			    if oListBox:aarray[ni,1]
		   	       ccMensagem+= OemToAnsi(STR0058)+oListBox:aarray[ni,2]+"-"+PADR(oListBox:aarray[ni,3],40)+ OemToAnsi(STR0059)+oListBox:aarray[ni,5]+"-"+PADR(oListBox:aarray[ni,6],25)+OemToAnsi(STR0060)+TRANSFORM(oListBox:aarray[ni,7],"999,999.99") +CRLF //"Empleado : " ## "/   Concepto: " ## "/   Importe $ "
			    endif
		   next		    

	       ccMensagem+=CRLF
   	       ccMensagem+=OemToAnsi(STR0061)+alltrim(cnomsup) //"			Autorizado por : "
		   cAttach:=""                                         

		   if !u_PN9EnvMail(cAssunto,ccMensagem,cMailNom,cMailSup)

  		       msgalert (OemToAnsi(STR0062))	//"Verifique si hay algun problema de conexión, no se logro enviar el correo al administrador de Nomina y no se logro autorizar!"
		      lPasa:= .f.
		      
 	  	   endif   
		endif	       
	    
	    if lPasa
				For ni:=1 to len(oListBox:aarray)
				    if oListBox:aarray[ni,1]
						(cTabla)->(dbgoto(aPosicio[nI]))
						if !(cTabla)->(eof())
							Reclock(cTabla,.f.)
							&(cAliasZZA+"->"+cAliasZZA+"_STATUS"):='1'
							&(cAliasZZA+"->"+cAliasZZA+"_FECRES"):=DDATABASE
							(cTabla)->(msunlock())
							lRet:= .t.
						endif	
					endif
				NEXT		
						if cEnvioMail=='S'
						   msgInfo(OemToAnsi(STR0063))//"EnvÍo de Autorización  con éxito"
						else
						   msgInfo(OemToAnsi(STR0064))   //"Autorización Realizada con Exito!"
						endif   

	     endif			
	     CURSORARROW()                               
	endif	   
ELSE
   MSGINFO(OemToAnsi(STR0065))//"Debe seleccionar al menos una solicitud para poder autorizar!"
   lRet:= .f.
ENDIF
Return lRet
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    CanAutoPres        ³ Gpe Santacruz         ³ Data ³03/03/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Cancelación o Autorizacion de Prestamos                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CanAutoPres(cPar01)	 		                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cPar01: Caracter, Alias de la tabla.              	      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³AutoPrestamo                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±/*/

Static Function CanAutoPres(cTabla)
Local ni:=0
Local lRet:= .f.                                          
Local oDlg           
Local obien
Local oCance
Local cMot:=space(40)

IF aScan(oListBox:aarray,{|x| x[1] == .T.} )>0
	if MsgYesNo(OemToAnsi(STR0066)) //"¿Estas Seguro de cancelar las solicitudes?"
		DEFINE MSDIALOG oDlg TITLE OemToAnsi(STR0067) From 100,100 To 180,377 of oMainWnd PIXEL	    //"Describa el Motivo de Rechazo"

		   @ 12,10 MSGET cMot PICTURE "@!" SIZE 120,7 OF oDLG PIXEL   
		   oBien := SButton():New( 28,73,1,{||if (empty(cMot),MsgInfo(OemToAnsi(STR0068)),(lRet:= .t.,oDlg:end()))},oDlg,.T.,,) //"La descripcón del motivo es obligatoria!"
		   oCance := SButton():New( 28,103,2,{||lRet:= .f.,oDlg:end()},oDlg,.T.,,)		   
		ACTIVATE MSDIALOG oDlg  centered
		if lRet
			For ni:=1 to len(oListBox:aarray)
			    if oListBox:aarray[ni,1]
					(cTabla)->(dbgoto(aPosicio[nI]))
					if !(cTabla)->(eof())
						Reclock(cTabla,.f.)
						&(cAliasZZA+"->"+cAliasZZA+"_MOTREC"):=cMot
						&(cAliasZZA+"->"+cAliasZZA+"_STATUS"):='2'
						&(cAliasZZA+"->"+cAliasZZA+"_FECRES"):=DDATABASE						
						(cTabla)->(msunlock())
						lRet:= .t.			
					endif	
				endif
			NEXT   
		endif			
	endif
ELSE
   MSGINFO(OemToAnsi(STR0069))//"Debe seleccionar al menos una solicitud para poder Cancelar!"
ENDIF

Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    GrbAutoVac         ³ Gpe Santacruz         ³ Data ³03/03/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Graba las vacaciones autorizadas y envia por Mail          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³GrbAutoVAC(cPar01)	 		                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cPar01: Caracter, Alias de la tabla.              	      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³AutoVacacion                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±/*/


static function GrbAutoVAC(cTabla)
Local ni:=0
Local lRet:= .f.

Local cEnvioMail:=SUPERgetmv("PT_ENVAUT",.f.,,) //SI S enviara mail para autorización
Local cMailNom:=''
Local cMailSup:=''  
Local cAssunto:=''  
Local ccMensagem:=''
Local cAttach:="" 
Local lPasa:= .t.  

IF aScan(oListBox:aarray,{|x| x[1] == .T.} )>0
    if cEnvioMail=='S' //si enviara correo de autorizacion al administrador de nomina
	    cMailNom:=supergetmv("PT_MAILAN",.f.,,)
	    SRA->(DBSETORDER(1))
		IF SRA->(DBSEEK(XFILIAL("SRA")+CMATSUP) )
			cMailSup:=SRA->RA_EMAIL
		ENDIF
	    IF EMPTY(cMailSup)
	       MSGINFO(OemToAnsi(STR0070))//"Es necesario el correo electronico del supervisor para poder autorizar!"
	       lPasa:= .f.
	    endif   
	    IF EMPTY(cMailNom)
	       MSGINFO(OemToAnsi(STR0071))//"Es necesario el correo electronico del Administrador de Nominas para poder autorizar!"
	       lPasa:= .f.
	    endif   
	    if !lPasa
	       return .f.
	    endif        
    endif
	if MsgYesNo(STR0072)//"¿Estas Seguro de Autorizar?"
	    CURSORWAIT()
		if cEnvioMail=='S'
		  
	       cAssunto:= OemToAnsi(STR0073) //"Autorizacion de Vacaciones"
	       ccMensagem:= OemToAnsi(STR0074) +CRLF //"Se autorizan las vacaciones al siguiente personal:"
  	       ccMensagem+=CRLF
	       
                                 
 	       For ni:=1 to len(oListBox:aarray)
			    if oListBox:aarray[ni,1]
		   	       ccMensagem+= OemToAnsi(STR0075)+oListBox:aarray[ni,2]+"-"+PADR(oListBox:aarray[ni,3],40)+ OemToAnsi(STR0076)+oListBox:aarray[ni,5]+"-"+PADR(oListBox:aarray[ni,6],25)+"/   Fecha Inicio : "+dtoc(oListBox:aarray[ni,7]) + OemToAnsi(STR0077)+dtoc(oListBox:aarray[ni,8])+CRLF //"Empleado : " ## "/   Concepto: " ## "/   Fecha Fin : "
			    endif
		   next		    

	       ccMensagem+=CRLF
   	       ccMensagem+= OemToAnsi(STR0078)+alltrim(cnomsup) //"			Autorizado por : "
		   cAttach:=""                                         

		   if !u_PN9EnvMail(cAssunto,ccMensagem,cMailNom,cMailSup)

  		       msgalert (OemToAnsi(STR0079)) //"Verifique si hay algun problema de conexión, no se logro enviar el correo al administrador de Nomina y no se logro autorizar!"	
		      lPasa:= .f.
		      
 	  	   endif   
		endif	       
	    
	    if lPasa
				For ni:=1 to len(oListBox:aarray)
				    if oListBox:aarray[ni,1]
						(cTabla)->(dbgoto(aPosicio[nI,1]))
						if !(cTabla)->(eof())
							Reclock(cTabla,.f.)
							&(cAliasZZB+"->"+cAliasZZB+"_STATUS"):='1'
							&(cAliasZZB+"->"+cAliasZZB+"_FECRES"):=DDATABASE							

							(cTabla)->(msunlock())
							lRet:= .t.
						endif	
					endif
				NEXT		
						if cEnvioMail=='S'
						   msgInfo(OemToAnsi(STR0080))//"EnvÍo de Autorización  con éxito"
						else
						   msgInfo(OemToAnsi(STR0081)) //"Autorización Realizada con Exito!"   
						endif   

	     endif			
	     CURSORARROW()                               
	endif	   
ELSE
   MSGINFO(OemToAnsi(STR0082))
   lRet:= .f.
ENDIF
Return lRet


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    CanAutoVAC         ³ Gpe Santacruz         ³ Data ³03/03/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Cancelación o Autorizacion de Vacaciones                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CanAutoVac (cPar01)	 		                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cPar01: Caracter, Alias de la tabla.              	      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³AutoVacacion                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±/*/

Static Function CanAutoVAC(cTabla)
Local ni:=0
Local lRet:= .f.                                          
Local oDlg           
Local obien
Local oCance
Local cMot:=space(40)

IF aScan(oListBox:aarray,{|x| x[1] == .T.} )>0
	if MsgYesNo(OemToAnsi(STR0083))//"¿Estas Seguro de cancelar las solicitudes?"
		DEFINE MSDIALOG oDlg TITLE OemToAnsi(STR0084) From 100,100 To 180,377 of oMainWnd PIXEL	    //"Describa el Motivo de Rechazo"

		   @ 12,10 MSGET cMot PICTURE "@!" SIZE 120,7 OF oDLG PIXEL   
		   oBien := SButton():New( 28,73,1,{||if (empty(cMot),MsgInfo(OemToAnsi(STR0085)),(lRet:= .t.,oDlg:end()))},oDlg,.T.,,) //"La descripcón del motivo es obligatoria!"
		   oCance := SButton():New( 28,103,2,{||lRet:= .f.,oDlg:end()},oDlg,.T.,,)		   
		ACTIVATE MSDIALOG oDlg  centered
		if lRet
			For ni:=1 to len(oListBox:aarray)
			    if oListBox:aarray[ni,1]
					(cTabla)->(dbgoto(aPosicio[nI,1]))
					if !(cTabla)->(eof())
						Reclock(cTabla,.f.)
						&(cAliasZZB+"->"+cAliasZZB+"_MOTREC"):=cMot
						&(cAliasZZB+"->"+cAliasZZB+"_STATUS"):='2'
						&(cAliasZZB+"->"+cAliasZZB+"_FECRES"):=DDATABASE						
						(cTabla)->(msunlock())
						lRet:= .t.			
					endif	
				endif
			NEXT   
		endif			
	endif
ELSE
   MSGINFO(OemToAnsi(STR0086)) //"Debe seleccionar al menos una solicitud para poder Cancelar!"
ENDIF

Return lRet



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PergHisLabºAutor  ³gsanatcruz          ºFecha ³  03/03/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Genera la pregunta                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Consulta de Historia Laboral                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function PergHisLab(cNomPerg)
//  Local _sAlias := Alias()           
  Local i := 0
  Local j:= 0

  dbSelectArea("SX1")
  dbSetOrder(1)
  cPerg := PADR(cNomPerg,10)
  aRegs := {}
  aAdd(aRegs,{cPerg,"01","","Del?","","MV_CH1","D",8,0,0,"G","","MV_PAR01","","","","  /  /  ","","","","","","","","","","","","","","","","","","","","","","","",""})
  aAdd(aRegs,{cPerg,"02","","Al?","","MV_CH2","D",8,0,0,"G","","MV_PAR02","","","","  /  /  ","","","","","","","","","","","","","","","","","","","","","","","",""})
  aAdd(aRegs,{cPerg,"03","","Tipo de Movimiento?","","MV_CH3","C",60,0,0,"G","u_PN9TMOV()","MV_PAR03","","","",SPACE(60),"","","","","","","","","","","","","","","","","","","","","","","",""})
 
  For i:=1 to Len(aRegs)
    If !dbSeek(cPerg+aRegs[i,2])
      RecLock("SX1",.T.)
      For j:=1 to FCount()
        If j <= Len(aRegs[i])
          FieldPut(j,aRegs[i,j])
        Endif
      Next
      MsUnlock()
    Endif
  Next

  //dbSelectArea(_sAlias)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³PN9TMOV     ³ Autor ³Gpe Santacruz A.     ³ Data ³ 03/03/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Genera el arreglo con los tipos de movimientos en la        ³±±
±±³          ³Historia laboral del empleado                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Ninguno                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±³Parametros³ExpL1: .t. si ejecutado desde lapregunta,.f. si ejecutado   ³±±
±±³          ³       sin pasar por la pregunta.                           ³±±
±±³Parametros³ExpC2: parametros con tipos de movimiento                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³x1_valid                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

user Function PN9TMOV(lTipo,cPar2)
Local lRet:= .t.
Local cTitulo:=""
Local mvRet
Local ni:=0
Local cString:=''
Local nSel:=0                
Local aConceptos:={OemToAnsi(STR0087),OemToAnsi(STR0088),OemToAnsi(STR0089),OemToAnsi(STR0090),OemToAnsi(STR0091),OemToAnsi(STR0092),OemToAnsi(STR0093),OemToAnsi(STR0094) }//"A-Altas","B-Bajas","M-Modificacion","L-Localidad de Pago","C-Centros de costo", "D-Departamento","F-Funciones","P-Cargos"
Local cConc:=''
Default lTipo:= .t.               
Default cPar2:=''

IF 	lTipo
	
	mvRet:=Alltrim(ReadVar())			 // Iguala Nombre de la Variable al Nombre de la variable del getdados de sx1
else
	mvRet:=cPar2
endif	

//Carga arreglo de acuerdo a las fecha del periodo

   if lTipo
		cTitulo := OEMTOANSI(STR0095)//"Seleccione los Tipos de Movimiento"
		&MvRet:=LBoxHL(cTitulo,aConceptos,12,49,&mvRet)  
	
	endif	           


if lTipo
	cstring:=&mvRet
else           
	cstring:=ALLTRIM(mvRet)
endif

if !empty(cstring)

	for ni:=1 to len(cstring)
	    nSel:=aScan(aConceptos,{|x|substr(x,1,1) ==substr(cstring,ni,1)} )                                     
	    if nSel==0
	       lRet:= .f.
	       msgAlert(OEMTOANSI(STR0096))//"Algun concepto seleccionado no existe!"
	       exit 
	     endif   
	next
else 
   msgAlert(OEMTOANSI(STR0097))//"Este campo no puede estar vacio"
   lRet:= .f.
endif

Return  lRet    



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³LBoxHL      ³ Autor ³Gpe Santacruz A.     ³ Data ³ 03/03/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Pantalla de listbox con los Tipo de Movimiento p/HisLab     ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Ninguno                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Titulo del listbox                                   ³±±
±±³          ³ExpA1: Arreglo con las fechas del programa de produccion    ³±±
±±³          ³ExpN1: Numero de linea donde inicia el listbox              ³±±
±±³          ³ExpN2: Numero de columna donde inicia el listbox            ³±±
±±³          ³ExpC2: Los dias que contiene el parametro actualmente       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³fDiasPP 					                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
static Function LBoxHL (cTit,aConc,nLin1,nCol1,cString)
Local cVar     := ""
Local lMark    := .F.
Local oOk      := LoadBitmap( GetResources(), "CHECKED" )   
Local oNo      := LoadBitmap( GetResources(), "UNCHECKED" ) 
Local oChk1
Local oChk2
Local ni:=0
Private oDlgDias
Private lChk1 := .F.
Private lChk2 := .F.
Private oLbx
Private aVetor := {}

for ni:=1 to len(aConc)
	lMark:= .f.
        if !empty(cstring)
            if 	substr(aConc[ni],1,1) $ cstring
                lMark:= .t.
            endif    
        endif
   	    aAdd( aVetor, { 	lMark,aConc[ni], })
next

If Len( aVetor ) == 0
   Aviso(oemtoansi(STR0098), OEMTOANSI(STR0099), {"Ok"} )//"No existen datos a consultar" ##"Aviso"
   Return
Endif

DEFINE MSDIALOG oDlgDias TITLE cTit FROM 0,0 TO 270,200 PIXEL

	@ 0,0 LISTBOX oLbx FIELDS HEADER    " ", OEMTOANSI(STR0100);    //"Concepto"
					   SIZE 100,105 OF oDlgDias PIXEL ON dblClick(aVetor[oLbx:nAt,1] := !aVetor[oLbx:nAt,1])
	
	oLbx:SetArray( aVetor )
	oLbx:bLine := {|| {Iif(aVetor[oLbx:nAt,1],oOk,oNo),;
	                       aVetor[oLbx:nAt,2],;
	                       }}
	
	@ 108,5 CHECKBOX oChk1 VAR lChk1 PROMPT OEMTOANSI(STR0101 ) SIZE 70,7 PIXEL OF oDlgDias ; //"Marca/Desmarca Todos"
	         ON CLICK( aEval( aVetor, {|x| x[1] := lChk1 } ),oLbx:Refresh() )
	
	
	DEFINE SBUTTON FROM 123,40 TYPE 1 ACTION AsigHL(oLbx,@cString) ENABLE OF oDlgDias
	DEFINE SBUTTON FROM 123,70 TYPE 2 ACTION oDlgDias:End() ENABLE OF oDlgDias
	
ACTIVATE MSDIALOG oDlgDias CENTER

Return cString
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³AsigHL      ³ Autor ³Gpe Santacruz A.     ³ Data ³ 03/03/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Genera el string con los dias seleccionados                 ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Ninguno                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Listbox                                              ³±±
±±³          ³ExpC1: Valor del parametro                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³MTR811LBoxMar 	 			                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

static function AsigHL(oLbx,cString)
Local nx:=0
cString:=''

for nx:=1 to len(olbx:aarray)  
    IF olbx:aarray[nx,1]
	    cstring+=substr(olbx:aarray[nx,2],1,1)

	ENDIF    
next                                    

oDlgDias:End()
return



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MarcProd  ³       ³ Gpe Santacruz         ³ Data ³03/03/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcion para marcar en el Listbox                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³MarcProd(oPar1,aPar1,oDlg,cPar01)                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³oPar01: Objeto del ListBox.                       	      ³±±
±±³          ³aPar1: Array original del ListBox.                          ³±±
±±³          ³oDlg : Objeto del Cuadro de Dialogo                         ³±±
±±³          ³cPar1: Marca del a casilla                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³AutoPrestamo  y AutoVacacion                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±/*/

Static Function MarcProd( oListBox , aListBox , oDlg , cMarckTip )

DEFAULT cMarckTip := ""

IF Empty( cMarckTip )
	aListBox[ oListBox:nAt , 1 ] := !aListBox[ oListBox:nAt , 1 ]
ElseIF cMarckTip	 == "M"
	aEval( aListBox , { |x,y| aListBox[y,1] := .T. } )
ElseIF cMarckTip == "D"
	aEval( aListBox , { |x,y| aListBox[y,1] := .F. } )
ElseIF cMarckTip == "I"
	aEval( aListBox , { |x,y| aListBox[y,1] := !aListBox[y,1] } )
EndIF


Return( NIL )
