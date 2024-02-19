 #INCLUDE "WSPTALNOM.CH" 
#INCLUDE "APWEBSRV.CH" 
#INCLUDE "PROTHEUS.CH"              

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Función    ³WSPTALNOM ³Autor  ³ M.Camargo            ³ Data ³ 03/03/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ M.Camargo  ³08/06/10³      ³WSGETCONSOLPRE: Los conceptos serán 	  ³±±  
±±³  		   ³        ³      ³tomados del parámetro PT_LISPRE	     	  ³±±  
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ M.Camargo  ³08/06/10³      ³WSGETDIASFES: Ordenar las fechas		  ³±±  
±±³  		   ³        ³      ³									  	  ³±±  
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³G. Santacruz³23/03/11³      ³Se agrego la instruccion GetJobProfString ³±±  
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³M. Camargo  ³24/01/13³      ³GETCAMPOS: Se agrega condicion RBC_STATUS ³±±
±±³            ³        ³      ³='A' al query que contiene opcines de menu³±±  
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³M. Camargo  ³15/02/13³      ³Se cambia el uso de GETMV por SUPERGETMV  ³±±
±±³            ³        ³      ³a excepcion de las tablas para solicitudes³±± 
±±³            ³        ³      ³de vacaciones, préstamos y documentos.    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/ 


// Estructura de Retorno del método VERIFICARACCESO     
WSSTRUCT strTransaccion
	WSDATA ESTATUS  as Boolean   // Falso o verdadero, indica si la contraseña de entrada es correcta para la matrícula dada
	WSDATA NOMBRE   as String    // Si Estatus= .T., se retorna nombre del empleado, de lo contrario se retorna vacío
ENDWSSTRUCT

//Registro para sacar los datos de envio y remitente del mail
WSSTRUCT strDatosMail
	WSDATA cEmail 		as String 
	WSDATA cPassMail    as String
	WSDATA cSmpt		as String	
	WSDATA cMailEnvio as string
ENDWSSTRUCT	  

//Registro de tipos de documento
WSSTRUCT STRTIPDOC
	WSDATA cCodSX5 as String
	WSDATA cDescsx5   as String	  
ENDWSSTRUCT  

//Registro para la inserción de Solicitudes de Documentos

WSSTRUCT stSolDoc
	WSDATA Insertado as Boolean
	WSDATA Mensaje   as String	  
ENDWSSTRUCT  

//Registro para la inserción de Solicitudes de Prestamo

WSSTRUCT stSolPre
	WSDATA Insertado as Boolean
	WSDATA Mensaje   as String	  
ENDWSSTRUCT  

//Registro de la Solicitud de Documentos

WSSTRUCT STRUSOLDOC

	WSDATA sFecSol as string
	WSDATA cDocto as string	
	WSDATA cIntere as string
	WSDATA nRecno   as integer

ENDWSSTRUCT    

//Registro de la Solicitud de prestamos

WSSTRUCT STRUSOLPRES

	WSDATA sFecSol as string
	WSDATA cDesPd as string	
	WSDATA nImporte as String
	WSDATA cStatus as string
	WSDATA cDesStat as string	
	WSDATA sFecRes  as string
	WSDATA nRecno   as integer
	WSDATA cMotrec   as string
ENDWSSTRUCT    

//Registro del Estado de Cuenta de Prestamos

WSSTRUCT STRUEDOPRES
	WSDATA nValorTot as float
	WSDATA nsaldod as float
	WSDATA nValorpa as float
	WSDATA cDtvenc as string
	WSDATA nParcela as integer
	WSDATA nParPag as integer
	WSDATA cSituac as string
	WSDATA cnumid  as string	
	WSDATA cinicio as string		
ENDWSSTRUCT              
                         

//Registro de Amortizaciones                   

WSSTRUCT STRUAMORTIZ
	WSDATA cPd as string
	WSDATA cdesc as string
	WSDATA cDtPago as string
	WSDATA nCargo as float
	WSDATA nAbono as float	
	WSDATA nvlsaldo  as float

ENDWSSTRUCT         

//Registro de Extraccion de Vacaciones

WSSTRUCT strExtVac
	WSDATA DESCRIPCION 	as String
	WSDATA FECINI 		as String
	WSDATA FECFIN 		as String
	WSDATA DIASDER		as Integer
	WSDATA DIASDIS		as Integer
	WSDATA DIASPRO		as Integer
	WSDATA DIASPAG		as Integer     
	WSDATA DIASSAL		as Integer
ENDWSSTRUCT

//Registro de Mail para solicitud de vacaciones

WSSTRUCT strSolVac
	WSDATA Insertado as Boolean
	WSDATA Mensaje   as String	  
ENDWSSTRUCT  

WSSTRUCT strRecnum
	WSDATA ARRNUMS as ARRAY OF String
ENDWSSTRUCT

//Registro de Solicitud de vacaciones

WSSTRUCT strVacaciones
	WSDATA RECNUM as Integer
	WSDATA FECSOL as String
	WSDATA CONCEPTO as String
	WSDATA FECINI as String
	WSDATA FECFIN as String
	WSDATA ESTATUS as String
	WSDATA FECRES as String	 
	WSDATA MOTREC as String
ENDWSSTRUCT 

//Registro de ausentismos

WSSTRUCT strExtAus
	WSDATA DESCRIPCION 	as String
	WSDATA FECINI 		as String
	WSDATA FECFIN 		as String  
	WSDATA DIAS 		as String   
	WSDATA TIPO 		as String
ENDWSSTRUCT 

//Registro de Historia Laboral

WSSTRUCT strHisLab
	WSDATA FecMov 		as String
	WSDATA Descripcion  as String 
	WSDATA SalDiario	as String
	WSDATA SalDiaInt	as String
	WSDATA SalMensual	as String  
	WSDATA LocPago 		as String   
	WSDATA CenCos 		as String
	WSDATA Depto		as String
	WSDATA Funcion 		as String	
	WSDATA Cargo 		as String
ENDWSSTRUCT 
                             
WSSTRUCT strFecRecNom
	WSDATA FECVALUE  	as String
	WSDATA FECRECNOM 	as String	
ENDWSSTRUCT          

//Registro de Extraccion de conceptos

WSSTRUCT strExtCon
	WSDATA CODIGO  		as String
	WSDATA DESCRIPCION 	as String	
ENDWSSTRUCT       

// Registro de Estados de cuenta de Movimientos

WSSTRUCT strCtaNom
	WSDATA FECHA 		as String
	WSDATA CONCEPTO		as String
	WSDATA IMPORTE 		as string
	WSDATA SUMA 		as string
ENDWSSTRUCT

// Registro de dias festivos

WSSTRUCT strDiasFes
	WSDATA FECHA 		as String
	WSDATA DESCRIPCION	as String
ENDWSSTRUCT
//FOLDERS

WSSTRUCT strCarpeta
	WSDATA ID 			as string
	WSDATA NOMBRE 		as string
ENDWSSTRUCT
   
WSSERVICE WSPTALNOM  DESCRIPTION "Funcionalidad para procesos del portal de Nomina para el  Empleado "

//............ Parámetros de Entrada.....................................................................................

	//--Filial a la que accesa
	WSDATA cFilAct 	   		as String    
	WSDATA cFilRes 	   		as String           
	//--miniespec_1
	WSDATA MATRICULA   		as String      	// Matrícula del Empleado 
	WSDATA SUCURSAL	   		as String
	WSDATA PASSWORD   		as String      	// Password
	WSDATA EMPRESA			as String
	WSDATA NEWPASS	   		as String			// Password Nuevo para cuando se realize cambio de password       
	WSDATA AREA		   		as String
	//--miniespec_2
	WSDATA 	 CAMPO     		as String
	WSDATA 	 NOMTABLA  	 	as String             
	WSDATA	 IDCARPETA		as String
	//miniespec_3
	WSDATA PERIODO	   		as String
	WSDATA NUMPAGO	   		as String        
	//--miniespec_4   Prestamos	                               
	WSDATA 	 IMPORTE   		as String  
	WSDATA   cNumID    		as string 
	//--miniespec_5
	WSDATA 	 CONCEPTO  		as String
	WSDATA	 FECHAINICIO	as String
	WSDATA 	 FECHAFIN		as String           
	WSDATA   cMV_PAR   		as String
	WSDATA   RECNUMS		as String //USADO EN MINIESPEC 4 Y 5
	WSDATA   FILTRO 		as String   
	//--miniespec_7
	WSDATA 	 DOCTO	   		as String
	WSDATA	 INTERESA  		as String
	
	//--
	WSDATA PROCESO			as String

//.......... Parámetros de Salida.......................................................................................
	
	WSDATA retSolDoc   		as StSolDoc                                                  
	WSDATA aretTipDoc  		as  Array of STRTIPDOC   //Retorno de Tipos de documentos
	WSDATA aretSolDoc  		as  Array of STRUSOLDOC   //Retorno de Solicitud de Documentos
	WSDATA aretSolPres 		as  Array of STRUSOLPRES   //Retorno de Solicitud de Prestamos
	WSDATA aRetEdoPres 		as  Array of  STRUEDOPRES	//retorno de estado de cuenta de prestamos
	WSDATA aRetAmortiz 		as  Array of  STRUAMORTIZ	//retorno de amortizaciones                 
	WSDATA retSolPre   		as StSolPre
	WSDATA retRespuesta 	as strDatosMail	 
	WSDATA retSolVac  		as strSolVac
	WSDATA retTransaccion   as strTransaccion   
	WSDATA retExtCon		as Array of strExtCon
	WSDATA retVacaciones 	as Array of strVacaciones             
	WSDATA retExtAus 		as Array of strExtAus   
	WSDATA retExtVac		as Array of strExtVac	
	WSDATA retHisLab		as Array of strHisLab    
	WSDATA retFecRecNom		as Array of strFecRecNom // Conceptos de recibos de nómina
	WSDATA retExtCtaNom		as Array of strCtaNom                        
	WSDATA retDiasFes		as Array of strDiasFes  
	WSDATA retCarpeta		as Array of strCarpeta
	WSDATA retCambio  		as Boolean               // V si se realizó el cambio de password, F si ocurrió algún error
	WSDATA retXML 			as String				 // Almacena un xml para retorno
	WSDATA retMail	 		as String                // email del administrador
	WSDATA retQuery     	as String                // Query
	WSDATA retValor	    	as String                // Valor del parámetro cParametro
	WSDATA retArea 			as String                // Nombre físico de una tabla      	
	WSDATA retFecAdmis		as Date					 // Fecha de Admisión del empleado    
	WSDATA retHTML			as String              // Nombre físico de una tabla
	WSDATA retSSL			as Boolean              // Nombre físico de una tabla
	WSDATA retRcNom		as String					//Confirmacón del la generación del recibo de nómina.
	
//.......Metodos.........................................................................................................
	
	WSMETHOD VERIFICARACCESO 	DESCRIPTION 	'Verifica si los datos de acceso al portal del empleado son correctos'  //Miniespec_1
    WSMETHOD CAMBIOPASS  		DESCRIPTION  	'Realiza el cambio de password para acceso al portal del empleado'      //Miniespec_1 
    WSMETHOD GENERAMENU	 		DESCRIPTION	 	'Obtiene la configuración para el menú del portal del empleado'	     	//Miniespec_1 
    WSMETHOD GETCAMPOS	 		DESCRIPTION    	'Obtiene la configuración de los campos para portal del empleado'		//Miniespec_2   
    WSMETHOD getConceptosVac 	DESCRIPTION 	'Obtiene conceptos de vacaciones'                                       //Miniespec_5
	WSMETHOD getMailSupervisor 	DESCRIPTION 	'Obtiene mail del supervisor'                                           //Miniespec_2 y 5
	WSMETHOD getDatosEnvio  	DESCRIPTION     'Obtiene datos de envío de email'                                       //Miniespec_5

	WSMETHOD setSolVac      	DESCRIPTION     'Inserta solicitud de vacaciones'                                       //Miniespec_5
	WSMETHOD getSolVac      	DESCRIPTION     'Obtienes las solicitudes de Vacaciones de un empleado'                 //Miniespec_5
	WSMETHOD getParametro   	DESCRIPTION     'Obtiene el Valor de un parámetro dado'                                 //Miniespec_5
//	WSMETHOD getArea  			DESCRIPTION     'Obtiene el nombre físico de una tabla dada'
	WSMETHOD getMail  			DESCRIPTION     'Obtiene el mail del supervisor de un empleado dado'
	WSMETHOD getSSL  			DESCRIPTION     'Obtiene el valor del parametro SSL'
	WSMETHOD getFilial 			DESCRIPTION		'Obtiene las filiales del sigamat y las retorna en un xml'
	WSMETHOD delSolVac			DESCRIPTION		'Elimina las solicitudes de vacaciones de un empleado'
//   	WSMETHOD getxFilial   		description 	'Obtiene la filial'
   	WSMETHOD getSolPres  		description 	'Obtiene las solicitudes de prestamos'   	
	WSMETHOD setSolPres   		DESCRIPTION     'Inserta solicitud de prestamos '                                      //Miniespec_4
	WSMETHOD delSolPre			DESCRIPTION		'Elimina las solicitudes de prestamo de un empleado'
   	WSMETHOD getEdoPres  		description 	'Obtiene el Estado de Cuenta de Prestamos'   	
   	WSMETHOD getAmortiz  		description 	'Obtiene las amortizaciones por ID del prestamo'
   	WSMETHOD getSolDoc  		description 	'Obtiene las solicitudes de documentos'   	
	WSMETHOD setSolDoc   		DESCRIPTION     'Inserta solicitud de documentos '                     
	WSMETHOD delSolDoc	    	DESCRIPTION		'Elimina las solicitudes de documentos de un empleado'                 //Miniespec_4
	WSMETHOD GetTipDoc		    DESCRIPTION		'Obtiene los tipo de documentos de la tabla W1'
   	WSMETHOD getExtVac			DESCRIPTION 	'Obtiene el estado de cuenta de vacaciones del empleado'
	WSMETHOD getExtAus			DESCRIPTION 	'Obtiene los permisos otorgados a un empleado'         
	WSMETHOD getFecAdmis		DESCRIPTION		'Obtiene la fecha de admisión de un empleado'  
	WSMETHOD getHisLab			DESCRIPTION		'Obtiene el historial labolar de un empleado dado'   
	WSMETHOD getFecNom			DESCRIPTION 	'Obtiene las fechas de los recibos de nómina de un empleado'    
	WSMETHOD getRecNom			DESCRIPTION		'Obtiene el recibo de nímina en formato HTML'
	WSMETHOD getExtCon			DESCRIPTION		'Obtiene conceptos para estado de cuenta de nómina del empleado '		// miniespec_3  parte 1
	WSMETHOD getEdoCtaNom	 	DESCRIPTION		'Obtiene el estado de cuenta de nómina de un empleado'					// miniespec_3  parte 2
	WSMETHOD getDiasFest		DESCRIPTION		'Obtiene el calendario con los días festivos del año en curso '
	WSMETHOD getConPeryAus		DESCRIPTION		'Obtiene la lista de conceptos para permisos y ausencias  '
	WSMETHOD getConSolPre		DESCRIPTION		'Obtiene la lista de conceptos para solicitudes de préstamos'
	WSMETHOD getTelCont			DESCRIPTION		'Obtiene el número telefónico de contacto con el depto de recursos humanos o administración de nóminas'	
	WSMETHOD getCarpetas		DESCRIPTION		'Obtiene el nombre de las carpetas a la que pertenecen los campos'
	WSMETHOD getRcNom		DESCRIPTION		'Imprime el recibo de nómina del empleado'


	
ENDWSSERVICE
 
 //'Obtiene el nombre físico de una tabla dada' 
 
/*WSMETHOD getArea WSRECEIVE NOMTABLA,SUCURSAL,EMPRESA WSSEND retArea WSSERVICE  WSPTALNOM    

	U_PREPENV(SUCURSAL,EMPRESA)
	::retArea := InitSqlName(NOMTABLA)
RETURN .T.     
*/
//'Obtiene la filial'

/*WSMETHOD getxFilial WSRECEIVE NOMTABLA, cFilAct,EMPRESA WSSEND cFilRes WSSERVICE WSPTALNOM     

	U_PREPENV(cFilAct,EMPRESA)
	::cFilRes := if (cFilAct=='99',xfilial(NOMTABLA) ,xfilial(NOMTABLA,cFilAct) )
	
RETURN .T.    
  */


//'Obtiene el Valor de un parámetro dado'
	
WSMETHOD getParametro WSRECEIVE cMV_PAR,SUCURSAL,EMPRESA WSSEND retValor WSSERVICE WSPTALNOM     
	U_PREPENV(sucursal,EMPRESA)
	::retValor := alltrim((SupergetMV(cMV_PAR,,,)))
RETURN .T.  
  
//'Obtiene las filiales del sigamat y las retorna en un xml'
	
WSMETHOD getFilial WSRECEIVE NULLPARAMS WSSEND retXML WSSERVICE WSPTALNOM
Local cEmpSelect	:= substr(AllTrim( GetJobProfString( "PREPAREIN" , ""  ) ),1,2)
Local cFilSelect	:= substr(AllTrim( GetJobProfString( "PREPAREIN" , ""  ) ),4,2)

//conout("Empresa Selec :"+cEmpselect)
//conout("Filial Selec :"+cFilSelect)
IF EMPTY(cEmpSelect)
	cEmpSelect:='01'
ENDIF
IF EMPTY(cFilSelect)
	cFilSelect:='01'
ENDIF


 u_PREPENV(cFilSelect,cEmpSelect)  

	
	
    ::retXML := u_getFilial()
Return .T.      

//'Obtiene el mail del Administrador de Nominas'

WSMETHOD getMail WSRECEIVE SUCURSAL,EMPRESA WSSEND retMail WSSERVICE  WSPTALNOM
	// PREPARA EL AMBIENTE 	                       
	U_PREPENV(SUCURSAL,EMPRESA)
	//::retMail := getMV("PT_MAILAN",,"")  
	::retMail := SuperGetMV("PT_MAILAN",.F.,,SUCURSAL)
RETURN .T.   

//'Obtiene el mail del Administrador de Nominas'

WSMETHOD getSSL WSRECEIVE SUCURSAL,EMPRESA WSSEND retSSL WSSERVICE  WSPTALNOM
	// PREPARA EL AMBIENTE 	                       
	U_PREPENV(SUCURSAL,EMPRESA)
	//::retMail := getMV("PT_MAILAN",,"")  
	::retSSL := SuperGetMV("MV_RELSSL",.F.,,SUCURSAL)
RETURN .T.

//Llamada a la rutina de impresion de recibo de nomina
WSMETHOD getRcNom WSRECEIVE SUCURSAL,MATRICULA,PERIODO,NUMPAGO,EMPRESA,PROCESO WSSEND retRcNom WSSERVICE  WSPTALNOM
	// PREPARA EL AMBIENTE 	                       
	U_PREPENV(SUCURSAL,EMPRESA)
	//::retMail := getMV("PT_MAILAN",,"")  
	::retRcNom := u_ImpRcNPdf(PROCESO,PERIODO,NUMPAGO,SUCURSAL,MATRICULA)
RETURN .T.   

//'Verifica si los datos de acceso al portal del empleado son correctos'  //Miniespec_1

WSMETHOD VERIFICARACCESO WSRECEIVE MATRICULA,PASSWORD,SUCURSAL,EMPRESA WSSEND retTransaccion WSSERVICE WSPTALNOM
	
	Local cMat     := MATRICULA     
	Local cPass    := PASSWORD        
   //	Local cFilEmp  := SUCURSAL
	Local cAuxPass := ""  
	Local cQuery   := ""
	Local cSRA	   := ""
	Local cTmp	   := ""   
	Local nReg	   := 0

// PREPARA EL AMBIENTE 	                       
	U_PREPENV(SUCURSAL,EMPRESA)
// conout("Sel Suc:"+sucursal)
// conout("Sel Emp:"+empresa)
// conout("xfilial "+xfiliaL("SRA"))	   
// conout("nOM TABLA "+InitSqlName("SRA"))	
 
 
	cSRA := InitSqlName("SRA")   
	cTmp := criatrab(nil,.F.)  
	cAuxPass := Embaralha(cPass,0)

	cQuery := "SELECT "
	cQuery +=		"RA_NOME,  "
	cQuery +=		"RA_FILIAL "
	cQuery += "FROM "
	cQuery +=		cSRA +" SRA "
	cQuery += "WHERE "          
	cQuery +=		"RA_FILIAL='"+ xfilial("SRA")  + "' AND "
	cQuery +=		"RA_SENHA='" + cAuxPass + "' AND "
	cQuery +=		"RA_MAT  ='" + cMat     + "' AND " 
	cQuery +=		"RA_SITFOLH<>'D' AND "
	cQuery +=		"D_E_L_E_T_=' ' "
	//conout(cQuery)
  	cQuery := ChangeQuery(cQuery)                    
	//CONOUT("QUERY2: " + cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cTmp,.T.,.T.) 
    //conout(TCGETDB() )
    Count to nReg 
    
    (cTmp)->(dbGoTop())
    If nReg > 0    
		IF (cTmp)->(!eof())   
			::retTransaccion:ESTATUS:= .T.	
	   		::retTransaccion:NOMBRE := (cTmp)->RA_NOME
			//::RETORNO:FILIAL := (cTmp)->RA_FILIAL 
		    (cTmp)->(dbskip())     
		End If  	
	Else
		::retTransaccion:ESTATUS:= .F.	
		::retTransaccion:NOMBRE := ""
		//::RETORNO:FILIAL := ""
	End If
	(cTmp)->(dbCloseArea())       
RETURN .T.  

//	'Realiza el cambio de password para acceso al portal del empleado'      //Miniespec_1  

WSMETHOD CAMBIOPASS WSRECEIVE MATRICULA,PASSWORD,SUCURSAL,NEWPASS,EMPRESA WSSEND retCambio  WSSERVICE WSPTALNOM


	Local cAuxPass 	:= ""
	Local lRet		:= .F.     
//	Local nRegPos:=0
	U_PREPENV(SUCURSAL,EMPRESA)
	


	
	DBSELECTAREA("SRA")
	SRA->(DBSETORDER(1))   
//    nRegPos:=u_BuscaTabFil(" RA_MAT='"+MATRICULA+"'","R_E_C_N_O_"," SRA ","RA",1)

	If  SRA->(DBSEEK(XFILIAL("SRA")+MATRICULA)) //nregpos>0
//	    SRA->(DBGOTO(NREGPOS))
		cAuxPass := Embaralha(PASSWORD,0)
		If cAuxPass == SRA->RA_SENHA
	   		cAuxPass := Embaralha(NEWPASS,0)
			Reclock("SRA",.F.)
	   			SRA->RA_SENHA := cAuxPass
	   		SRA->(Msunlock())        
	   		lRet := .T.
		EndIf			
	EndIf
	::retCambio := lRet
		
RETURN .T.                                       

//'Obtiene la configuración para el menú del portal del empleado'	     	//Miniespec_1 

WSMETHOD GENERAMENU WSRECEIVE SUCURSAL,EMPRESA WSSEND retXML WSSERVICE WSPTALNOM

	Local cQuery:= ""	
	Local cRBC	:= ""
	Local cTmp	:= ""
	Local aTmp  := {}                               
	Local nI	:= 0     
	Local cCodTmp := ""  
	Local _retXML := ""
	
	U_PREPENV(SUCURSAL,EMPRESA)

	cRBC 	:= InitSqlName("RBC")
	cTmp 	:= criatrab(nil,.F.)    
	cQuery 	:= "SELECT  "
	cQuery +=	"RBC_CODMNU,RBC_SEQ,RBC_DESCRI,RBC_ROTINA,RBC_DESCME "
	cQuery += "FROM "
	cQuery +=	cRBC + " RCB " 
	cQuery += 	"WHERE "
	cQuery +=	"RBC_FILIAL='"+XFILIAL("RBC")+"' AND "
	cQuery +=  "RBC_STATUS='A'" + " AND "
	cQuery +=	"D_E_L_E_T_=' ' "
	cQuery	+=	"ORDER BY    "
	cQuery	+=	"RBC_CODMNU, "
	cQuery +=	"RBC_SEQ     "
	cQuery := ChangeQuery(cQuery)                    


	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cTmp,.T.,.T.) 
 
    //Count to nReg
    (cTmp)->(dbGoTop())    
    
    While (cTmp)->(!eof())   
   		AADD(aTmp,{(cTmp)->RBC_CODMNU,(cTmp)-> RBC_SEQ,(cTmp)->RBC_DESCRI,(cTmp)->RBC_ROTINA,ALLTRIM((cTmp)->RBC_DESCME)})		    
   		(cTmp)->(dbskip())
    Enddo             
    (cTmp)->(dbCloseArea())        
    
   	_retXML :="<?xml version='1.0'?>"
	_retXML +='<Home>'
    For nI := 1 to Len(aTmp)    
		If cCodTmp == aTmp[nI,1]
			If !Empty(aTmp[nI,2])
				_retXML += '<SubMenu text="'+alltrim(aTmp[nI,3])+'" url="' + IIF(LEN(alltrim(aTmp[nI,4]))==0,"FrmPrincipal.aspx",alltrim(aTmp[nI,4]))+'" desc="'+strtran(aTmp[nI,5],'"',"'")+'" />'	
			End If									
		Else   
			If nI != 1
				_retXML += '</Menu>'			
			End If
			If Empty(aTmp[nI,2]) 
				_retXML += '<Menu text="'+alltrim(aTmp[nI,3])+'" url="' +IIF(LEN(alltrim(aTmp[nI,4]))==0,"FrmPrincipal.aspx",alltrim(aTmp[nI,4]))+ '" desc="'+strtran(aTmp[nI,5],'"',"'")+'">'
			End If	
			cCodTmp := aTmp[nI,1]
		End If
    Next nI   
    _retXML += '</Menu>'
    _retXML  +='</Home>'
    ::retXML := _retXML

RETURN .T.  
//'Obtiene la configuración de los campos para portal del empleado'		//Miniespec_2   

WSMETHOD getCampos WSRECEIVE SUCURSAL,EMPRESA,MATRICULA,IDCARPETA   WSSEND retXML WSSERVICE  WSPTALNOM
	Local _retXML	:= ""
	Local aDicioW 	:= {} 
	Local cTexto 	:= "" 
	Local aAux		:= {}	// arreglo auxiliar
//	Local cFile		:= "GRHPER.FCH"
	Local cBloque	:= ""     
	Local cSeq		:= ""  
	Local cCampo	:= ""
	Local nX		:= 0             
	Local nY		:= 0
	Local nRegPos:=0
	// PREPARA EL AMBIENTE 	                       
	U_PREPENV(SUCURSAL,EMPRESA)
	
	cSeq := SuperGetMV("PT_SEQSRA",.F.,,)
	
	aDicioW := U_PN9DATPER(IDCARPETA)
	_retXML +="<?xml version='1.0'?>"
	_retXML +=Chr(13)+Chr(10) 
	_retXML +="<controles>"   
	_retXML +=Chr(13)+Chr(10)      
	
	dbselectarea("SRA")	
	dbsetorder(1)
	// conout("GENERA CAMPOS")
	// conout("xfilial "+xfiliaL("SRA"))	   
	// conout("nOM TABLA "+InitSqlName("SRA"))		
	//nRegPos:=u_BuscaTabFil(" RA_MAT='"+MATRICULA+"'","R_E_C_N_O_"," SRA ","RA",1)
    IF SRA->(dbseek(XFILIAL("SRA")+MATRICULA))
	//	IF nRegPos>0
  	//	    SRA->(DBGOTO(NREGPOS))
		For nX := 1 To len(aDicioW)
			IF aDicioW[nX,1] .or. aDicioW[nX,2]
			 
				if valtype(SRA->&(Substr(aDicioW[nX,5],1,10))) == 'C'
					cTexto := alltrim(STRTRAN(SRA->&(Substr(aDicioW[nX,5],1,10)),'"',"'"))  
					
					cBloque := POSICIONE("SX7",1,Substr(aDicioW[nX,5],1,10)+cSeq,"X7_REGRA")
										
					IF !Empty(aDicioW[nX,6])
						aAux := aDicioW[nX,6]
						For nY := 1 to len(aAux)
							If cTexto == Substr(aAux[nY],1,LEN(cTexto))
								cTexto := IIF(Empty(cTexto),cTexto,Substr(aAux[nY],len(cTexto)+2))
								nY := len(aAux)
							ENd If
						NExt nY
					
					End IF
					
					IF !Empty(cBloque) .and. !Empty(SRA->&(Substr(aDicioW[nX,5],1,10)))
						cCampo :=Substr(aDicioW[nX,5],1,10)
						cBloque:= strtran(cBloque,"M->","SRA->")   
						cBloque:= &(cBloque)
						cTexto := cTexto + "-" + cBloque					
					Else
						cCampo := POSICIONE("SX3",2,Substr(aDicioW[nX,5],1,10),"X3_F3") 					
						IF !Empty(cCampo) .and. val(cCampo)<>0
							cCampo :=POSICIONE("SX5",1,xfilial("SX5")+alltrim(cCampo)+SRA->&(Substr(aDicioW[nX,5],1,10)),"X5_DESCSPA")							
							cTexto := cTexto + "-" + cCampo
						End If	   
											
					End IF 
					IF ALLTRIM(Substr(aDicioW[nX,5],1,10)) == "RA_SUPERVI"
						cTexto := POSICIONE("SRA",1,XFILIAL("SRA")+SRA->&(Substr(aDicioW[nX,5],1,10)),"RA_NOME")					
						//cTexto := u_BuscaTabFil(" RA_MAT='"+SRA->&(Substr(aDicioW[nX,5],1,10))+"'","RA_NOME"," SRA ","RA")					
					END IF
					
					cTexto := strtran(cTexto,"&","&amp;")
					
				elseif valtype(SRA->&(Substr(aDicioW[nX,5],1,10))) == 'N'
					cTexto := alltrim(STR(SRA->&(Substr(aDicioW[nX,5],1,10)))) 
				elseif valtype(SRA->&(Substr(aDicioW[nX,5],1,10))) == 'D' 
					cTexto := DTOC(SRA->&(Substr(aDicioW[nX,5],1,10)))
				endif
																
				_retXML += '<control type="Label" ID="lb'+ alltrim(lower(Substr(aDicioW[nX,5],1,10)))+'1" Text="'+alltrim(aDicioW[nX,4])+'"   name="'+alltrim(Substr(aDicioW[nX,5],1,10))+'" />'
				_retXML += Chr(13)+Chr(10)
				_retXML += '<control type="Text" ID="lb'+ Substr(aDicioW[nX,5],1,10)+ '"  Text="' + cTexto			   
				_retXML += '"  name="'+alltrim(Substr(aDicioW[nX,5],1,10))+'"/>'
				_retXML += Chr(13)+Chr(10)		
					
			EndIF			
		Next nX 
		
		_retXML +="</controles>"   
		_retXML +=Chr(13)+Chr(10) 
	else
	   conout("No encontre campos "+SUCURSAL+MATRICULA+ " sucur/emp"+sucursal+empresa)	
	ENDIF 
	
	::retXML := _retXML                                                             
Return .T.

//'Obtiene conceptos de vacaciones'                                       //Miniespec_5                            

WSMETHOD getConceptosVac WSRECEIVE SUCURSAL,EMPRESA WSSEND retXML WSSERVICE WSPTALNOM
	
	Local cConcep:= ""//alltrim(getMV("PT_LISVAC",,""))
	Local _retXML  := ""  
	Local ni	 := 0     
	Local aConcep:= {} 
	Local cDesc	 := ""
	Local iSRV 	 := "" //retordem("SRV","RV_FILIAL+RV_COD")
	Local nloop:=0      
	
	U_PREPENV(SUCURSAL,EMPRESA)
	        
	iSRV 	:= retordem("SRV","RV_FILIAL+RV_COD")
	cConcep	:= alltrim(SuperGetMV("PT_LISVAC",.f.,,))
	
	_retXML +="<?xml version='1.0'?>"
	_retXML +=Chr(13)+Chr(10) 
	_retXML +="<conceptos>"     
	_retXML +=Chr(13)+Chr(10) 
	if Empty(cConcep)
		_retXML +='<concepto codigo="000" descripcion="Configure el parámetro PT_LISVAC" />' 
		_retXML +=Chr(13)+Chr(10) 
	Else
		ni:=1
		
		While (nPos:= At(",",cConcep))<>0
			cCaracter := SUBSTR(cConcep,1,nPos-1)
			cConcep   :=RIGHT(cConcep,(len(cConcep)-(nPos)))
			AADD(aConcep,cCaracter)
		Enddo 
		AADD(aConcep,cConcep)
		For nloop:=1 to (len(aConcep)) 
			cDesc :=alltrim(POSICIONE("SRV",iSRV,XFILIAL("SRV")+aConcep[nloop],"RV_DESC"))
			//AADD(aTmp,{aConcep[nloop], cDesc})
			_retXML += '<concepto codigo="'+aConcep[nloop]+'" descripcion="'+aConcep[nloop]+"-"+cDesc+'" />'     
			_retXML += Chr(13)+Chr(10) 
		Next nloop 		
		
	EndIf
	
	_retXML +=Chr(13)+Chr(10) 
	_retXML +="</conceptos>"   	


	::retXML := _retXML
	
RETURN .T.                   

//'Obtiene mail del supervisor'                       

WSMETHOD GETMAILSUPERVISOR WSRECEIVE SUCURSAL,MATRICULA,EMPRESA WSSEND retMail WSSERVICE WSPTALNOM
	
	Local cSMat  := ""

	Local cLLave := ""
	Local cEmailS:= ""
	
	U_PREPENV(SUCURSAL,EMPRESA)            
	
	cLLave := XFILIAL("SRA")+MATRICULA
	cSMAT  := POSICIONE("SRA",1,cLlave,"RA_SUPERVI") // u_BuscaTabFil(" RA_MAT='"+MATRICULA+"'","RA_SUPERVI"," SRA ","RA")	

	cLlave := XFILIAL("SRA")+cSMat
	cEmailS:=POSICIONE("SRA",1,cLlave,"RA_EMAIL") 	//u_BuscaTabFil(" RA_MAT='"+cSMat+"'","RA_EMAIL"," SRA ","RA")
	
	::retMail:= ALLTRIM(cEmailS)
	
		
RETURN .T.           

//'Obtiene datos de envío de email'                    

WSMETHOD GETDATOSENVIO WSRECEIVE SUCURSAL,MATRICULA,EMPRESA WSSEND retRespuesta WSSERVICE WSPTALNOM
 	
	Local cAccount := ""  
	Local cPassword:= ""
	Local cServer  := ""
	Local cEmailS  := ""
	Local nRegPos:=0
	
 	// PREPARA EL AMBIENTE 	                       
	U_PREPENV(SUCURSAL,EMPRESA)
	
	cAccount := alltrim(getMV("MV_RELACNT")) // Cuenta de usuario del cliente de correo
	cPassword:= alltrim(getMV("MV_RELAPSW")) // Password del usuario de la cuenta de correo
	cServer  := alltrim(getMV("MV_RELSERV")) // Servidor de correo smtp
	cEmailS	 := ALLTRIM(POSICIONE("SRA",1,XFILIAL("SRA")+MATRICULA,"RA_EMAIL"))    //u_BuscaTabFil(" RA_MAT='"+MATRICULA+"'","RA_EMAIL"," SRA ","RA")
	::retRespuesta:cEmail 	 := cAccount
	::retRespuesta:cPassMail := cPassword
	::retRespuesta:cSMPT	 := cServer 
	::retRespuesta:cMailEnvio:= cEmailS       
	DBSELECTAREA("SRA")  
	sra->(dbsetorder(1))
	//nRegPos:=u_BuscaTabFil(" RA_MAT='"+MATRICULA+"'","SRA.R_E_C_N_O_"," SRA ","RA",1)
	
    IF  SRA->(DBSEEK(XFILIAL("SRA")+MATRICULA))//nregpos>0
   	    SRA->(DBGOTO(NREGPOS))
       cemails:=sra->RA_EMAIL  
       
    else
                            
          conout("no entre")      
    endif   
	
RETURN .T.                         



//'Saca los tipo de documentos de la tabla W1"
            
WSMETHOD GETTIPDOC WSRECEIVE SUCURSAL,EMPRESA WSSEND aRetTipDoc WSSERVICE WSPTALNOM   


Local cTabla:='W1'                                     

// PREPARA EL AMBIENTE 
U_PREPENV(SUCURSAL,EMPRESA)

DBSELECTAREA("SX5")
DBSETORDER(1)
IF DBSEEK(XFILIAL("SX5")+cTabla)
   DO WHILE !SX5->(EOF()) .AND. SX5->X5_TABELA==cTabla

	   	aAdd(::aRetTipDoc,WsClassNew("STRTIPDOC")) 
		::aRetTipDoc[LEN(aRetTipDoc)]:cCodSX5 := SX5->X5_CHAVE
		::aRetTipDoc[LEN(aRetTipDoc)]:cDescsx5 := x5Descri()
	    SX5->(DBSKIP())
   ENDDO
ENDIF

RETURN .T.

//'Obtiene las solicitudes de documentos' 

WSMETHOD GETSOLDOC WSRECEIVE SUCURSAL,MATRICULA,EMPRESA WSSEND aretSolDoc WSSERVICE WSPTALNOM   

Local ni:=0

Local aRet:={}
// PREPARA EL AMBIENTE 

U_PREPENV(SUCURSAL,EMPRESA)

aRet := u_PN9SOLDOC(.T.,MATRICULA,.f.)   //extrae las todas las solicitudes


for ni:=1 to len(aRET)              
    
	aAdd(::aretSolDoc,WsClassNew("STRUSOLDOC")) 
	::aretSolDoc[nI]:sFecSol:= dtoc(aRet[ni,1])
	::aretSolDoc[nI]:cDocto:= aRet[ni,2]	
	::aretSolDoc[nI]:cIntere:= aRet[nI,3]
	::aretSolDoc[nI]:nRecno:=aRet[ni,4]

			
Next
RETURN .T.

//'Inserta solicitud de documentos ' 

WSMETHOD SETSOLDOC WSRECEIVE SUCURSAL,MATRICULA,DOCTO,INTERESA,EMPRESA WSSEND retSolDoc WSSERVICE WSPTALNOM   

	Local cArea  := ""
	Local cClave := ""
	Local cSuperv:= ""

    Local cMailSu:= ""   
    Local cFilEmp:= SUCURSAL
    Local cMat   := MATRICULA
    
    // PREPARA EL AMBIENTE 

	U_PREPENV(SUCURSAL,EMPRESA)
    
	cArea  := alltrim(UPPER(getMV("PT_SOLDOC",,"")))

    
	cSuperv := POSICIONE("SRA",1,XFILIAL("SRA")+cMat,"RA_SUPERVI")  //u_BuscaTabFil(" RA_MAT='"+cMAT+"'","RA_SUPERVI"," SRA ","RA")
	cMailSu := POSICIONE("SRA",1,XFILIAL("SRA")+cSuperv,"RA_EMAIL") //u_BuscaTabFil(" RA_MAT='"+cSuperv+"'","RA_EMAIL"," SRA ","RA")
	if !Empty(cArea)

		dbSelectArea(cArea)
		dbsetorder(1)
		Reclock(cArea,.T.) 
			(cArea)->(&(cArea+"_FILIAL")) := XFILIAL(CAREA)
			(cArea)->(&(cArea+"_MAT"   )) := cMat
			(cArea)->(&(cArea+"_DOCTO"    )) := DOCTO
			(cArea)->(&(cArea+"_INTERE"    )) := INTERESA
			(cArea)->(&(cArea+"_FECSOL")) := DATE()		
		MSUNLOCK()

		::retSolDoc:Insertado:= .T.
		::retSolDoc:Mensaje:= "Registro Guardado"	
		
	Else
		::retSolPre:Insertado:= .F.
		::retSolPre:Mensage:= "Debe Configurar el parámetro PT_SOLDOC "		
	EndIf

RETURN .T. 

//	'Elimina las solicitudes de documentos de un empleado'                 //Miniespec_4

WSMETHOD DELSOLDOC WSRECEIVE RECNUMS,SUCURSAL,EMPRESA WSSEND RetCambio WSSERVICE WSPTALNOM
	Local aTmp 		:= {}
	Local nI		:= 0
	Local cAliasZZB := ""   
	Local nError	:= 0      
	Local cCaracter :=""
	Local nPos		:= 0      
	Local cRecno	:= RECNUMS
	::retCambio 	:= .T.
	// pREPARA EL AMBIENTE
	U_PREPENV(SUCURSAL,EMPRESA)
	cAliasZZB := getMV("PT_SOLDOC",,"")  
	 
	While (nPos:= At(",",cRecno))<>0
		cCaracter := SUBSTR(cRecno,1,nPos-1)
		cRecno  :=RIGHT(cRecno,(len(cRecno)-(nPos)))
		AADD(aTmp,cCaracter)
	Enddo      
	   
	AADD(aTmp,cRecno)  
		
	DBSELECTAREA(cAliasZZB)	      

	For nI = 1 to Len(aTmp)  
		(cAliasZZB)->(dbgoto(Val(aTmp[nI])))
		If !EOF()
			RECLOCK(cAliasZZB,.F.)
				(cAliasZZB)->(DBDelete())
		    (cAliasZZB)->(MSUNLOCK())
	    Else
	   		nError++
	    End IF
	Next nI         
	
	If nError == len(aTmp) 	
		::retCambio := .F.	
	End If
		
RETURN .T.	

//	'Obtiene las solicitudes de prestamos' 

WSMETHOD GETSOLPRES WSRECEIVE SUCURSAL,MATRICULA,EMPRESA WSSEND aretSolPres WSSERVICE WSPTALNOM   

Local ni:=0
Local cDesSta:=''
Local aRet:={}

// pREPARA EL AMBIENTE
U_PREPENV(SUCURSAL,EMPRESA) 

aRet := u_PN9SOLPRES(.T.,MATRICULA,.f.)   //extrae las todas las solicitudes


for ni:=1 to len(aRET)              
	cDesSta:=''
    If aRet[nI,6] == "1"
		 cDesSta :=  OemToAnsi(STR0001) //"Aceptada"           
	endif
		                
	 If aRet[nI,6] == "2"
		 cDesSta :=  OemToAnsi(STR0002) //"Rechazada"           
	endif
    
	aAdd(::aretSolPres,WsClassNew("STRUSOLPRES")) 
	::aretSolPres[nI]:sFecSol:= dtoc(aRet[ni,2])
	::aretSolPres[nI]:cDesPd:= aRet[ni,3]	+"-"+aRet[ni,4]			
	::aretSolPres[nI]:nImporte:= alltrim(str(aRet[ni,5]))
	::aretSolPres[nI]:cStatus:= aRet[nI,6]
	::aretSolPres[nI]:cDesStat:= cDesSta	
	::aretSolPres[nI]:sFecRes:=dtoc(aRet[ni,7])
	::aretSolPres[nI]:nRecno:=aRet[ni,8]
	::aretSolPres[nI]:cMotrec:=aRet[ni,9]	
			
Next
RETURN .T.

//'Inserta solicitud de prestamos '

WSMETHOD SETSOLPRES WSRECEIVE SUCURSAL,MATRICULA,CONCEPTO,IMPORTE,EMPRESA WSSEND retSolPre WSSERVICE WSPTALNOM   
                 

	Local cArea  := ""
	Local cClave := ""
	Local cSuperv:= ""

    Local cMailSu:= ""   

    Local cMat   := MATRICULA 
    Local cImp   := transform(val(IMPORTE),"99999999999.99")
    Local nImporte:=  val(cImp)
    Local cPD	 := CONCEPTO
    
  	// pREPARA EL AMBIENTE
	
	U_PREPENV(SUCURSAL,EMPRESA)
    nImporte:= val(cImp)
    cArea  := alltrim(UPPER(getMV("PT_SOLPRE",,"")))

    
	cSuperv := POSICIONE("SRA",1,XFILIAL("SRA")+cMat,"RA_SUPERVI")
 	cMailSu := POSICIONE("SRA",1,XFILIAL("SRA")+cSuperv,"RA_EMAIL")
  //	cSuperv := u_BuscaTabFil(" RA_MAT='"+cMAT+"'","RA_SUPERVI"," SRA ","RA") 
	//cMailSu := u_BuscaTabFil(" RA_MAT='"+cSuperv+"'","RA_EMAIL"," SRA ","RA") 
	if !Empty(cArea)
  //		cClave := GETSX8NUM( cArea , cArea+"_ID" )	
		dbSelectArea(cArea)
		dbsetorder(1)
		Reclock(cArea,.T.) 
			(cArea)->(&(cArea+"_FILIAL")) := XFILIAL(CAREA)
			(cArea)->(&(cArea+"_MAT"   )) := cMat
			(cArea)->(&(cArea+"_PD"    )) := cPD
//			(cArea)->(&(cArea+"_ID"    )) := cClave
			(cArea)->(&(cArea+"_IMPORT")) := nImporte
			(cArea)->(&(cArea+"_STATUS")) := " "
			(cArea)->(&(cArea+"_SUPERVI")):= cSuperv
			(cArea)->(&(cArea+"_DIRSUP")) := cMailSu
			(cArea)->(&(cArea+"_FECSOL")) := DATE()		
		MSUNLOCK()
	//	CONFIRMsx8()   
		::retSolPre:Insertado:= .T.
		::retSolPre:Mensaje:=  OemToAnsi(STR0003) //"Registro Guardado"	
		
	Else
		::retSolPre:Insertado:= .F.
		::retSolPre:Mensage:=  OemToAnsi(STR0004) //"Debe Configurar el parámetro PT_SOLPRE "		
	EndIf

RETURN .T. 

//'Elimina las solicitudes de prestamo de un empleado'

WSMETHOD DELSOLPRE WSRECEIVE RECNUMS,SUCURSAL,EMPRESA WSSEND RetCambio WSSERVICE WSPTALNOM
	Local aTmp 		:= {}
	Local nI		:= 0
	Local cAliasZZB := ""   
	Local nError	:= 0      
	Local cCaracter :=""
	Local nPos		:= 0      
	Local cRecno	:= RECNUMS
	::retCambio 	:= .T.
	// PREPARA EL AMBIENTE
	 
	cAliasZZB := getMV("PT_SOLPRE",,"") 
	 
	While (nPos:= At(",",cRecno))<>0
		cCaracter := SUBSTR(cRecno,1,nPos-1)
		cRecno  :=RIGHT(cRecno,(len(cRecno)-(nPos)))
		AADD(aTmp,cCaracter)
	Enddo      
	   
	AADD(aTmp,cRecno)  
		
	DBSELECTAREA(cAliasZZB)	      

	For nI = 1 to Len(aTmp)  
		(cAliasZZB)->(dbgoto(Val(aTmp[nI])))
		If !EOF()
			RECLOCK(cAliasZZB,.F.)
				(cAliasZZB)->(DBDelete())
		    (cAliasZZB)->(MSUNLOCK())
	    Else
	   		nError++
	    EndIF
	Next nI         
	
	If nError == len(aTmp) 	
		::retCambio := .F.	
	End If
		
RETURN .T.	

//'Obtiene el Estado de Cuenta de Prestamos'

WSMETHOD GETEDOPRES WSRECEIVE SUCURSAL,MATRICULA,EMPRESA WSSEND aRetEdoPres WSSERVICE WSPTALNOM   

Local ni:=0

Local aRet:={}

// PREPARA EL AMBIENTE
U_PREPENV(SUCURSAL,EMPRESA)

aRet :=u_PN9EXTPRES(matricula,matricula,"") //extrae el estado de cuanta de prestamos del empleado

for ni:=1 to len(aRET)              
	aAdd(::aRetEdoPres,WsClassNew("STRUEDOPRES")) 
	::aRetEdoPres[nI]:nValorTot:= aRet[ni,3]
	::aRetEdoPres[nI]:nsaldod:= aRet[ni,4]			
	::aRetEdoPres[nI]:nValorpa:= aRet[ni,5]
	::aRetEdoPres[nI]:cDtvenc:= dtoc(aRet[ni,6])
	::aRetEdoPres[nI]:nParcela:= aRet[nI,7]
	::aRetEdoPres[nI]:nParPag:= aRet[nI,8]
	::aRetEdoPres[nI]:cSituac:=aRet[ni,9]
	::aRetEdoPres[nI]:cNumId:=aRet[ni,10]	
	::aRetEdoPres[nI]:cinicio:=dtoc(aRet[ni,11])	
Next
RETURN .T.

//	'Obtiene las amortizaciones por ID del prestamo

WSMETHOD GETAMORTIZ WSRECEIVE SUCURSAL,MATRICULA,cNUMID,EMPRESA WSSEND aRetAmortiz WSSERVICE WSPTALNOM   

Local ni:=0
Local nSaldo:=0
Local aRet:={}

// PREPARA EL AMBIENTE
U_PREPENV(SUCURSAL,EMPRESA)

aRet := u_PN9AMORT(SUCURSAL,MATRICULA,cNUMID) //extrae las amortizaciones del prestamo

for ni:=1 to len(aRET)              
    if ni==1
       nSaldo+=aRet[nI,5]  //en el elemento 1 viene el importe del prestamo (cargo)
    else                 
	    nSaldo-=aRet[nI,4]
    endif   
	aAdd(::aRetAmortiz,WsClassNew("STRUAMORTIZ")) 

	::aRetAmortiz[nI]:cPd:= aRet[ni,1]
	::aRetAmortiz[nI]:cdesc:= aRet[ni,2]			
	::aRetAmortiz[nI]:cDtPago:= dtoc(aRet[ni,3]	)   
	::aRetAmortiz[nI]:nCargo:=aRet[nI,5]      //cargo
	::aRetAmortiz[nI]:nabono:= aRet[ni,4]     //abono
	::aRetAmortiz[nI]:nvlsaldo:= nSaldo
	
Next
RETURN .T.


//'Inserta solicitud de vacaciones'         

WSMETHOD SETSOLVAC WSRECEIVE SUCURSAL,MATRICULA,CONCEPTO,FECHAINICIO,FECHAFIN,EMPRESA WSSEND retSolVac WSSERVICE WSPTALNOM   

	Local cArea  := ""
	Local cClave := ""//GETSX8NUM( "ZZA" , "ZZA_CLAVE" )
	Local cSuperv:= ""

    Local cMailSu:= ""   

    Local cMat   := MATRICULA
    Local cFecIni:= FECHAINICIO
    Local cFecFin:= FECHAFIN     
    Local cPD	 := CONCEPTO
    
    // PREPARA EL AMBIENTE
	U_PREPENV(SUCURSAL,EMPRESA)

	cSuperv := POSICIONE("SRA",1,XFILIAL("SRA")+cMat,"RA_SUPERVI")
	cMailSu := POSICIONE("SRA",1,XFILIAL("SRA")+cSuperv,"RA_EMAIL")

//	cSuperv := u_BuscaTabFil(" RA_MAT='"+cMAT+"'","RA_SUPERVI"," SRA ","RA") 
//	cMailSu := u_BuscaSra(" RA_MAT='"+cSuperv+"'","RA_EMAIL"," SRA ","RA") 
	
	cArea  := alltrim(UPPER(getMV("PT_SOLVAC",,"")))
	
	if !Empty(cArea)
//		cClave := GETSX8NUM( cArea , cArea+"_ID" )	
		dbSelectArea(cArea)
		dbsetorder(1)
		Reclock(cArea,.T.) 
			(cArea)->(&(cArea+"_FILIAL")) := XFILIAL(cArea)
			(cArea)->(&(cArea+"_MAT"   )) := cMat
			(cArea)->(&(cArea+"_PD"    )) := cPD
  //			(cArea)->(&(cArea+"_ID"    )) := cClave
			(cArea)->(&(cArea+"_FECINI")) := STOD(cFecIni)
			(cArea)->(&(cArea+"_FECFIN")) := STOD(cFecFin)
			(cArea)->(&(cArea+"_STATUS")) := " "
			(cArea)->(&(cArea+"_SUPERVI")):= cSuperv
			(cArea)->(&(cArea+"_DIRSUP")) := cMailSu
			(cArea)->(&(cArea+"_FECSOL")) := DATE()		
		MSUNLOCK()
	//	CONFIRMsx8()   
		::retSolVac:Insertado:= .T.
		::retSolVac:Mensaje:=  OemToAnsi(STR0003) //"Registro Guardado"	
		
	Else
		::retSolVac:Insertado:= .F.
		::retSolVac:Mensage:=  OemToAnsi(STR0005) //"Debe Configurar el parámetro PT_SOLVAC "		
	EndIf

RETURN .T. 

// 'Obtienes las solicitudes de Vacaciones de un empleado' 
 
WSMETHOD GETSOLVAC WSRECEIVE SUCURSAL,MATRICULA,EMPRESA WSSEND RETVACACIONES WSSERVICE WSPTALNOM
	
	Local nI	  := 0   
    Local cStatus := ""
    Local aTmp 	  := {}    
    Local cPD	  := ""   
    Private aPosicio := {}
    // PREPARA EL AMBIENTE
	U_PREPENV(SUCURSAL,EMPRESA)
    
    aTmp := U_PN9SOLVAC(.T.,MATRICULA) 	

    For nI := 1 to Len(aTmp) 
           cPD := aTmp[nI][5] +"-" + aTmp[nI][6]  
           cStatus := aTmp[nI][10] 

           If cStatus == "1"
			 cStatus :=  OemToAnsi(STR0001) //"Aceptada"           
           Elseif cStatus=="2"
			 cStatus :=  OemToAnsi(STR0002) //"Rechazada"          
           EndIF
              
            //Se crea el array de tipo estructura
           aAdd(::retVacaciones,WsClassNew("strVacaciones")) 
           ::retVacaciones[nI]:RECNUM:= aTmp[nI][9]
           ::retVacaciones[nI]:FecSol:= DTOC(aTmp[nI][4])
           ::retVacaciones[nI]:Concepto:= cPD    
           ::retVacaciones[nI]:FecIni:= DTOC(aTmp[nI][7])          
           ::retVacaciones[nI]:FecFin:= DTOC(aTmp[nI][8])  
           ::retVacaciones[nI]:Estatus:= cStatus//aTmp[nI][10]  
           ::retVacaciones[nI]:FecRes:= DTOC(aTmp[nI][11])                                 
           ::retVacaciones[nI]:MotRec:= aTmp[nI][12]
    Next nI                                                                    
                                                                         
             	
RETURN .T.	
                  
//'Elimina las solicitudes de vacaciones de un empleado'

WSMETHOD DELSOLVAC WSRECEIVE SUCURSAL,MATRICULA,RECNUMS,EMPRESA WSSEND RetCambio WSSERVICE WSPTALNOM
	Local aTmp 		:= {}
	Local nI		:= 0  
	Local cAliasZZB := ""   
	Local nError	:= 0      
	Local cCaracter :=""
	Local nPos		:= 0      
	Local cRecno	:= RECNUMS
	::retCambio 	:= .T.
	// PREPARA EL AMBIENTE
	U_PREPENV(SUCURSAL,EMPRESA) 
	
	cAliasZZB := getMV("PT_SOLVAC",,"")     
	 
	While (nPos:= At(",",cRecno))<>0
		cCaracter := SUBSTR(cRecno,1,nPos-1)
		cRecno  :=RIGHT(cRecno,(len(cRecno)-(nPos)))
		AADD(aTmp,cCaracter)
	Enddo      
	
	AADD(aTmp,cRecno)  
		
	DBSELECTAREA(cAliasZZB)	      

	For nI = 1 to Len(aTmp)  
		(cAliasZZB)->(dbgoto(Val(aTmp[nI])))
		If !EOF()
			RECLOCK(cAliasZZB,.F.)
				(cAliasZZB)->(DBDelete())
		    (cAliasZZB)->(MSUNLOCK())
	    Else
	   		nError++
	    End IF
	Next nI         
	
	If nError == len(aTmp) 	
		::retCambio := .F.	
	EndIf
		
RETURN .T.                

//	'Obtiene el estado de cuenta de vacaciones del empleado'
  

WSMETHOD getExtVac WSRECEIVE SUCURSAL,MATRICULA,EMPRESA WSSEND retExtVac WSSERVICE WSPTALNOM

	Local ni:=0
	Local aTmp:={}
		// PREPARA EL AMBIENTE
	U_PREPENV(SUCURSAL,EMPRESA) 
	aTmp := u_PN9EXTVAC(MATRICULA)   //extrae las todas las solicitudes
	
	For ni:=1 to len(aTmp)              
		
		aAdd(::retExtVac,WsClassNew("strExtVac")) 
		::retExtVac[nI]:DESCRIPCION:= aTmp[nI,1]
		::retExtVac[nI]:FECINI	:= aTmp[nI,2]		
		::retExtVac[nI]:FECFIN	:= aTmp[nI,3]
		::retExtVac[nI]:DIASDER	:= aTmp[nI,4]
		::retExtVac[nI]:DIASDIS	:= aTmp[nI,5]
		::retExtVac[nI]:DIASPRO	:= aTmp[nI,6]
		::retExtVac[nI]:DIASPAG	:= aTmp[nI,7] 
		::retExtVac[nI]:DIASSAL	:= aTmp[nI,8]					   
							
	Next  

RETURN .T.              

//'Obtiene los permisos otorgados a un empleado'

WSMETHOD getExtAus WSRECEIVE SUCURSAL,MATRICULA,FILTRO,EMPRESA WSSEND retExtAus WSSERVICE WSPTALNOM

	Local ni:=0
	Local aTmp:={}

	// PREPARA EL AMBIENTE
	U_PREPENV(SUCURSAL,EMPRESA) 
		
	aTmp := u_PN9EXTAUS(MATRICULA,.T.,FILTRO)   //extrae las todas las solicitudes
	
	For ni:=1 to len(aTmp)              
		
		aAdd(::retExtAus,WsClassNew("strExtAus")) 
		::retExtAus[nI]:DESCRIPCION:= aTmp[nI,1] +"-"+aTmp[nI,2]
		::retExtAus[nI]:FECINI	:= DTOC(aTmp[nI,3]) 		
		::retExtAus[nI]:FECFIN	:= DTOC(aTmp[nI,4])
		::retExtAus[nI]:DIAS	:= ALLTRIM(str(aTmp[nI,5]))
		::retExtAus[nI]:TIPO	:= aTmp[nI,6]										
	Next  

RETURN .T.                  


//	'Obtiene la fecha de admisión de un empleado'

WSMETHOD GETFECADMIS WSRECEIVE SUCURSAL,MATRICULA,EMPRESA WSSEND RETFECADMIS	WSSERVICE WSPTALNOM


	Local dFecAdmis := ""
	
	// PREPARA EL AMBIENTE
	U_PREPENV(SUCURSAL,EMPRESA) 
	
	
	dFecAdmis := POSICIONE("SRA",1,XFILIAL("SRA")+MATRICULA,"RA_ADMISSA")  //   stod(u_BuscaTabFil(" RA_MAT='"+MATRICULA+"'","RA_ADMISSA"," SRA ","RA")) 
		
	::retFecAdmis := dFecAdmis
	
RETURN .T.

//'Obtiene el historial labolar de un empleado dado'  

WSMETHOD GETHISLAB WSRECEIVE SUCURSAL,MATRICULA,FILTRO,FECHAINICIO,FECHAFIN,EMPRESA WSSEND RETHISLAB WSSERVICE WSPTALNOM
	Local ni:=0
	Local aTmp:={}
	// PREPARA EL AMBIENTE
	U_PREPENV(SUCURSAL,EMPRESA) 
	
	aTmp := u_PN9HISLAB(FILTRO,STOD(FECHAINICIO),STOD(FECHAFIN),MATRICULA)   //extrae las todas las solicitudes
	
	For ni:=1 to len(aTmp)              
		
		aAdd(::retHisLab,WsClassNew("strHisLab")) 
		::retHisLab[nI]:FecMov		:= DTOC(aTmp[nI,1])
		::retHisLab[nI]:Descripcion	:= aTmp[nI,2]		
		::retHisLab[nI]:SalDiario	:= "$ " + TRANSFORM(aTmp[nI,3],'999,999,999.99')
		::retHisLab[nI]:SalDiaint	:= "$ " + TRANSFORM(aTmp[nI,4],'999,999,999.99')
		::retHisLab[nI]:SalMensual	:= "$ " + TRANSFORM(aTmp[nI,5],'999,999,999.99')
		::retHisLab[nI]:LocPago		:= aTmp[nI,6]
		::retHisLab[nI]:Cencos		:= aTmp[nI,7] 
		::retHisLab[nI]:Depto		:= aTmp[nI,8]	  
		::retHisLab[nI]:Funcion		:= aTmp[nI,9]	 														
		::retHisLab[nI]:Cargo		:= aTmp[nI,10]	 
		
	Next        
	
RETURN .T.             

//	'Obtiene las fechas de los recibos de nómina de un empleado' 
                                     
WSMETHOD GETFECNOM WSRECEIVE MATRICULA,SUCURSAL,EMPRESA WSSEND retFecRecNom	WSSERVICE WSPTALNOM
	Local aTmp 	:= {}
	Local nI 	:= 0   
	// PREPARA EL AMBIENTE
	U_PREPENV(SUCURSAL,EMPRESA) 
	
	aTmp :=  U_PN9EXTFEC(MATRICULA,SUCURSAL)
	For ni:=1 to len(aTmp)              		
		aAdd(::retFecRecNom,WsClassNew("strFecRecNom")) 
		::retFecRecNom[nI]:FecValue	:= aTmp[nI,1]
		::retFecRecNom[nI]:FecRecNom	:= aTmp[nI,2]					
	Next     		
	
RETURN .T.

//	'Obtiene el recibo de nímina en formato HTML'
	
WSMETHOD getRecNom WSRECEIVE SUCURSAL,MATRICULA,PERIODO,NUMPAGO,EMPRESA WSSEND retHTML WSSERVICE WSPTALNOM
	// PREPARA EL AMBIENTE
	U_PREPENV(SUCURSAL,EMPRESA) 
    ::retHTML :=  U_GenrecHTML(.T.,SUCURSAL,MATRICULA,PERIODO,3,NUMPAGO)
RETURN .T.       

//	'Obtiene conceptos para estado de cuenta de nómina del empleado '

WSMETHOD getExtCon WSRECEIVE SUCURSAL,MATRICULA,EMPRESA WSSEND retExtCon	WSSERVICE  WSPTALNOM
	Local aTmp := {}	
	Local ni   := 0
	// PREPARA EL AMBIENTE
	U_PREPENV(SUCURSAL,EMPRESA) 
	
	aTmp :=  U_PN3EXTCONC(SUCURSAL,MATRICULA)
	
	For ni:=1 to len(aTmp)              		
		aAdd(::retExtCon,WsClassNew("strExtCon")) 
		::retExtCon[nI]:codigo		:= aTmp[nI,1]
		::retExtCon[nI]:descripcion	:= aTmp[nI,2]					
	Next     

RETURN .T.          

//	'Obtiene el estado de cuenta de nómina de un empleado'					// miniespec_3  parte 2

WSMETHOD getEdoCtaNom WSRECEIVE SUCURSAL,MATRICULA,CONCEPTO,FECHAINICIO,FECHAFIN,IMPORTE,EMPRESA WSSEND retExtCtaNom WSSERVICE WSPTALNOM
	
	Local aTmp := {}	
	Local ni   := 0
	// PREPARA EL AMBIENTE
	U_PREPENV(SUCURSAL,EMPRESA)
	
	aTmp :=  U_PN3EXTCTA(SUCURSAL,MATRICULA,CONCEPTO,FECHAINICIO,FECHAFIN,IMPORTE )
	
	For ni:=1 to len(aTmp)              		
		aAdd(::retExtCtaNom,WsClassNew("strCtaNom")) 
		::retExtCtaNom[nI]:fecha	:= DTOC(aTmp[nI,1])
		::retExtCtaNom[nI]:concepto	:= aTmp[nI,2]					
		::retExtCtaNom[nI]:Importe	:= transform(aTmp[nI,3],"999,999,999.99")
		::retExtCtaNom[nI]:Suma		:= transform(aTmp[nI,4],"999,999,999.99")
	Next                                     		

RETURN .T.
             

WSMETHOD getDiasFest WSRECEIVE SUCURSAL,EMPRESA WSSEND retDiasFes WSSERVICE WSPTALNOM
	                           
	Local cQuery := ""
	Local cTmpBus:= ""
	Local aTmp	 := {}	
	Local nI	 := 0
	
	U_PREPENV(SUCURSAL,EMPRESA)
	
	cTmpBus:= CriaTrab(Nil,.F.) 
	cQuery := " SELECT P3_DATA,P3_DESC "
    cQuery += " FROM  " + retSQLName("SP3")
    cQuery += " WHERE "
    cQuery += " P3_FILIAL='" + XFILIAL("SP3") + " '  AND "
    cQuery += " P3_DATA LIKE '" + ALLTRIM(str(YEAR(date()))) + "%' AND "
    cQuery += " D_E_L_E_T_=' ' "
	cQuery += " ORDER BY P3_DATA "
    //conout(cQuery)
    cQuery := ChangeQuery(cQuery)    	
	DbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery),cTmpBus, .T., .T. )
	TCSetField(cTmpBus,"P3_DATA","D")  
 	
 	Do While !(cTmpBus)->(EOF())      
		
		AADD(aTmp,{(cTmpBus)->P3_DATA ,(cTmpBus)->P3_DESC})
		(cTmpBus)->(dbSkip())		                                        		                             		
	Enddo        		
	(cTmpBus)->(dbclosearea())		     
	
	For ni:=1 to len(aTmp)              		
		aAdd(::retDiasFes,WsClassNew("strDiasFes")) 
		::retDiasFes[nI]:Fecha		 	:= DTOC(aTmp[nI,1])
		::retDiasFes[nI]:Descripcion	:= aTmp[nI,2]					
	Next  

RETURN .T.     


WSMETHOD getConPeryAus WSRECEIVE  SUCURSAL,EMPRESA WSSEND retExtCon WSSERVICE WSPTALNOM        

	Local cQuery := ""
	Local cTmpBus:= ""
	Local aTmp	 := {}	
	Local nI	 := 0
	
	U_PREPENV(SUCURSAL,EMPRESA)     

	cTmpBus:= CriaTrab(Nil,.F.) 
	cQuery = "SELECT "
	cQuery += "RCM_PD,RV_DESC "
	cQuery += "FROM "
	cQuery += retSqlName("SRV") + " SRV ,"
	cQuery += retSqlName("RCM") + " RCM  "
	cQuery += "WHERE "
	cQuery += " RCM_FILIAL='" + XFILIAL("RCM") + "' AND "
	cQuery += " RV_FILIAL='"  + XFILIAL("SRV") + "'  AND "
	cQuery += " RV_COD=RCM_PD AND "
	//cQuery += " RCM_TPIMSS IN ('1','2')  AND "
	cQuery += " RCM_TIPOAF IN ('1','2','3')  AND "
	cQuery += " SRV.D_E_L_E_T_=' '  	 AND "
	cQuery += " RCM.D_E_L_E_T_=' '   "		   

	cQuery := ChangeQuery(cQuery)    	
	DbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery),cTmpBus, .T., .T. ) 
 	
 	Do While !(cTmpBus)->(EOF())      
		
		AADD(aTmp,{(cTmpBus)->RCM_PD,(cTmpBus)->RCM_PD+"-"+(cTmpBus)->RV_DESC})
		(cTmpBus)->(dbSkip())
				                                        		                             		
	Enddo     
	   		
	(cTmpBus)->(dbclosearea())		     
	
	For ni:=1 to len(aTmp)              		
	
		aAdd(::retExtCon,WsClassNew("strExtCon")) 
		::retExtCon[nI]:Codigo		:= aTmp[nI,1]
		::retExtCon[nI]:Descripcion	:= aTmp[nI,2]					
		
	Next                            
	
RETURN .T.            

WSMETHOD getConSolPre WSRECEIVE  SUCURSAL,EMPRESA WSSEND retExtCon WSSERVICE WSPTALNOM        

	//Local cQuery := ""
	//Local cTmpBus:= ""
	Local aTmp	 := {}	
	Local nI	 := 0 
	Local aConcep:= {}
	
	U_PREPENV(SUCURSAL,EMPRESA)     
    
	/*cTmpBus:= CriaTrab(Nil,.F.) 
 	cQuery = "SELECT RV_COD, RV_DESC  "
 	cQuery += " FROM " + RETSQLNAME("SRV") + " "
 	cQuery += "WHERE RV_LEEPRE='1' "
 	cQuery += "AND RV_FILIAL='" + XFILIAL("SRV") + "' "
 	cQuery += "AND D_E_L_E_T_=' ' "  
 	
	cQuery := ChangeQuery(cQuery)    	
	DbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery),cTmpBus, .T., .T. ) 
 	
 	Do While !(cTmpBus)->(EOF())      
		
		AADD(aTmp,{(cTmpBus)->RV_COD,(cTmpBus)->RV_COD+"-"+(cTmpBus)->RV_DESC})
		(cTmpBus)->(dbSkip())
				                                        		                             		
	End do     
	   		
	(cTmpBus)->(dbclosearea())	*/	

	iSRV 	:= retordem("SRV","RV_FILIAL+RV_COD")
	cConcep	:= alltrim(supergetMV("PT_LISPRE",.f.,,))

	if Empty(cConcep)
		aadd(aConcep,{"00","CONFIGURE PARAM PT_LISPRE"})
	Else
		ni:=1
		
		While (nPos:= At(",",cConcep))<>0
			cCaracter := SUBSTR(cConcep,1,nPos-1)
			cConcep   :=RIGHT(cConcep,(len(cConcep)-(nPos)))
			AADD(aConcep,cCaracter)
		Enddo 
		AADD(aConcep,cConcep)
		For ni:=1 to (len(aConcep)) 
			cDesc :=alltrim(POSICIONE("SRV",iSRV,XFILIAL("SRV")+aConcep[nI],"RV_DESC"))
			AADD(aTmp,{aConcep[nI], cDesc})		
		Next ni 		
		
	EndIf
		     
	
	For ni:=1 to len(aTmp)              			
		aAdd(::retExtCon,WsClassNew("strExtCon")) 		
		::retExtCon[nI]:Codigo		:= aTmp[nI,1]
		::retExtCon[nI]:Descripcion	:= aTmp[nI,2]							
	Next                            
	
RETURN .T.                  

WSMETHOD GETTELCONT WSRECEIVE SUCURSAL,EMPRESA	WSSEND cMV_PAR WSSERVICE WSPTALNOM   
	
	U_PREPENV(SUCURSAL,EMPRESA)  
	   
    ::cMV_PAR := SuperGetMV("PT_TELNOM",.f.,,)

RETURN .T.  

WSMETHOD GETCARPETAS WSRECEIVE SUCURSAL,EMPRESA WSSEND retCarpeta  WSSERVICE WSPTALNOM  
	Local nI 	:= 0
	Local aTmp 	:= {} 

   	U_PREPENV(SUCURSAL,EMPRESA)  
	aTmp := U_PN2EXTFOL()
	
	For ni:=1 to len(aTmp)              			
		aAdd(::retCarpeta,WsClassNew("strCarpeta")) 
		::retCarpeta[nI]:Id		:= aTmp[nI,1]
		::retCarpeta[nI]:Nombre	:= aTmp[nI,2]							
	Next  

RETURN .T.             


