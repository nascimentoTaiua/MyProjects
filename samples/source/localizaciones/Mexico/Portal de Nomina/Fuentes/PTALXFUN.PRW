 #INCLUDE "protheus.ch"                                                                                          
#Include "AP5Mail.ch"                                                               
#Include "PTALXFUN.ch"    
#include "TbiConn.ch" 
                                                                    
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun??o    ³ PTALXFUN ³ Autor ³ Gpe Santacruz         ³ Data ³08/03/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri??o ³ Funciones generales para control del supervisor y Portal   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Todas las fun grales del portal de Nomina y del Control    ³±±
±±³          ³ del supervisor.                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU?AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±                                      
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³MCamargo    ³08/06/10³      ³PN9HISLAB: Se agrega un nuevo elemento al ³±±
±±³            ³        ³      ³arreglo de los datos del historial lab    ³±±
±±³            ³        ³      ³agregando un código para diferenciar cada ³±±
±±³            ³        ³      ³operación y ordenar por fecha y código los³±±
±±³            ³        ³      ³movimientos.					 		  ³±±      
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³MCamargo    ³09/06/10³      ³PN9HISLAB: Se modifican las funciones de- ³±±
±±³            ³        ³      ³pendiendo del tipo de movimiento para obt-³±±
±±³            ³        ³      ³ener CC,Loc Pago,Depto,Funcion y cargo.	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³flor.monroy ³27/01/12³ Mejr ³PN9EXTVAC: Ordenar por Fecha Fin y no     ³±±
±±³            ³        ³      ³ Imprimir filas en cero                   ³±±
±±³flor.monroy ³27/01/12³ Mejr ³PN9SOLVAC: Ordenar descendente            ³±± 
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³MCamargo	   ³23/01/13³ Mejr ³PN9SOLVAC: Agregar fecha inicio a aPosicio³±± 
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³MCamargo	   ³28/01/13³ Mejr ³PN9DATPER:Obtener archivo por parametro   ³±±   
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³MCamargo	   ³28/01/13³ Mejr ³PN3EXTCON:Obtener lista de conceptos      ³±± 
±±³            ³        ³      ³del parámetro PT_CONVIS.		 		  ³±±    
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³MCamargo	   ³15/02/13³ Mejr ³Se cambia el uso de GETMV por SUPERGETMV ³±± 
±±³            ³        ³      ³para obtener param x suc.		 		 ³±± 
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Raul Ortiz  ³31/07/14³TPZAAL³Se modifica PN9EnvMail por error en la    ³±± 
±±³            ³        ³      ³autenticacion con el servidor.            ³±±   
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³M.Camargo   ³11/07/17³MMI-54³ Réplica MMI-5421. PN9EnvMail()           ³±±   
±±³            ³        ³57    ³Error en la autenticacion con el servidor ³±±
±±³            ³        ³      ³de correo electrónico.                    ³±±
±±³M.Camargo   ³11/07/17³MMI-45³ Réplica MMI-4579. PN9EXTFEC Se modifica  ³±±   
±±³            ³        ³93    ³query ya que causaba error de sintaxis por³±±
±±³            ³        ³      ³por comillas faltantes.                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/    

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun??o    ³PN9SOLPRES³       ³ Gpe Santacruz         ³ Data ³03/03/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri??o ³ Consulta de Solicitud de Prestamos                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³PN9SOLPRES (lPar01,cPar01)                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³lPar01: .t. Solo muestra las pendientes. F. Todas.          ³±±
±±³          ³cPar01: Matricula del empleado. Si vacia saca todos los em- ³±±
±±³          ³pleados del supervisor.                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³PNOM009                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±/*/     

USER FUNCTION 	PN9SOLPRES(lTodas,cMat,lDe)
Local aLista:={}
Local cQrySolPre:='' 
Local cAliasZZA:=UPPER(alltrim(GETMV("PT_SOLPRE")))

Default ltodas:= .f.                     
Default cMat:=''
Default lDe:= .t. //cuando la funcion es llamada desde el Control del supervisor
aPosicio:={}
DBSELECTAREA(cAliasZZA)

    cQrySolPre:= "SELECT "+cAliasZZA+".*, RA_NOME, RV_DESC FROM "
    cQrySolPre+= RetSqlName(cAliasZZA) + " "+cAliasZZA+", " + RetSqlName("SRA") + " SRA , " + RetSqlName("SRV") + " SRV "
   
    cQrySolPre+=" WHERE  "+cAliasZZA+"_FILIAL  ='"+XFILIAL(cAliasZZA)+"' AND "+cAliasZZA+"_MAT= RA_MAT"
    if empty(cmat)
	    cQrySolPre+=" AND RA_SUPERVI = '"+CMATSUP+"' "
	else                                              
		cQrySolPre+=" AND RA_mat = '"+CMAT+"' "
	endif    
     cQrySolPre+="AND RA_FILIAL='"+XFILIAL("SRA")+"' "
    if !ltodas
	    cQrySolPre+=" AND "+cAliasZZA+"_STATUS=' ' "
	endif    
    cQrySolPre+=" AND RV_COD="+cAliasZZA+"_PD "+   " AND RV_FILIAL='"+XFILIAL("SRV")+"' "
    If ( TcSrvType()=="AS/400" )
		cQrySolPre+="     AND SRA.@DELETED@  = ' ' " 
		cQrySolPre+="     AND SRV.@DELETED@  = ' ' " 
		cQrySolPre+="     AND "+cAliasZZA+".@DELETED@  = ' ' " 
	ELSE                                           
		cQrySolPre+="     AND SRA.D_E_L_E_T_  = ' ' " 
		cQrySolPre+="     AND SRV.D_E_L_E_T_  = ' ' " 		
		cQrySolPre+="     AND "+cAliasZZA+".D_E_L_E_T_  = ' ' " 
	ENDIF
    cQrySolPre := ChangeQuery(cQrySolPre)
    DbUseArea( .T., 'TOPCONN', TCGENQRY(,, cQrySolPre), "TRBPRES", .T., .T. )
	dbSelectArea("TRBPRES")                      
	aLista:={}
	While !TRBPRES->(EOF())
	       if lDe //si llamada desde control del Supervisor
			   			   AADD(aLista,{.F.,;
	                       SUBSTR(TRBPRES->&(cAliasZZA+"_MAT"),1,8),;   //Matricula
	                       substr(TRBPRES->RA_NOME,1,25),;               //Nombre
	                       STOD(TRBPRES->&(cAliasZZA+"_FECSOL")),;       //Fecha de solicitud          
	                       SUBSTR(TRBPRES->&(cAliasZZA+"_PD"),1,5),;     //Concepto
	                       substr(TRBPRES->RV_DESC,1,15),;                //Descripcion del concepto
	                       transform(TRBPRES->&(cAliasZZA+"_IMPORT"),"999,999.99"),;   //Importe solicitado
							})                                                                               
							
			else    //llamado desde el portal                                                                                         
			               
						   AADD(aLista,{.F.,;
	                       STOD(TRBPRES->&(cAliasZZA+"_FECSOL")),;       //Fecha de solicitud          
	                       SUBSTR(TRBPRES->&(cAliasZZA+"_PD"),1,5),;     //Concepto
	                       substr(TRBPRES->RV_DESC,1,15),;                //Descripcion del concepto
	                       TRBPRES->&(cAliasZZA+"_IMPORT"),;   //Importe solicitado
  	                       TRBPRES->&(cAliasZZA+"_STATUS"),;   //Status
	                       STOD(TRBPRES->&(cAliasZZA+"_FECRES")),;   //Fecha de respuesta
	                       TRBPRES->R_E_C_N_O_,;   //       
	                       TRBPRES->&(cAliasZZA+"_MOTREC"),;
							})                                                                               
							
            endif
            aadd(aPosicio,TRBPRES->R_E_C_N_O_)            
            TRBPRES->(DBSKIP())
       ENDDO                    
       TRBPRES->(DBCLOSEAREA())
RETURN aLista

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun??o    ³PN9SOLVAC ³       ³ Gpe Santacruz         ³ Data ³03/03/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri??o ³ Consulta de Solicitud de Vacaciones                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³PN9SOLVAC  (lPar01,cPar01                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³lPar01: .f. Solo muestra las pendientes. t. Todas.          ³±±
±±³          ³cPar01: Matricula de un empleado, si vacio saca todos       ³±±
±±³          ³ los empleado del supervisor.                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³PNOM009                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±/*/     

USER FUNCTION 	PN9SOLVAC(lTodas,cMat)
Local aLista:={}
Local cQrySolVac:='' 
Local cAliasZZB:=UPPER(alltrim(GETMV("PT_SOLVAC")))

Default ltodas:= .f.                
Default cMat:=''   
aPosicio:={}


DBSELECTAREA(cAliasZZB)

    cQrySolVac:= "SELECT "+cAliasZZB+".*, RA_NOME, RV_DESC FROM "
    cQrySolVac+= RetSqlName(cAliasZZB) + " "+cAliasZZB+", " + RetSqlName("SRA") + " SRA , " + RetSqlName("SRV") + " SRV "
   
    cQrySolVac+=" WHERE  "+cAliasZZB+"_FILIAL  ='"+XFILIAL(cAliasZZB)+"' AND "+cAliasZZB+"_MAT= RA_MAT"
    if empty(cMat)
	    cQrySolVac+=" AND RA_SUPERVI = '"+CMATSUP+"' "
	else
	    cQrySolVac+=" AND RA_MAT = '"+CMAT+"' "
	endif                                                                                 
    cQrySolVac+=" AND RA_FILIAL='"+XFILIAL("SRA")+"' "	
    if !ltodas
	    cQrySolVac+=" AND "+cAliasZZB+"_STATUS=' ' "
	endif    
    cQrySolVac+=" AND RV_COD="+cAliasZZB+"_PD "+   " AND RV_FILIAL='"+XFILIAL("SRV")+"' "
    If ( TcSrvType()=="AS/400" )
		cQrySolVac+="     AND SRA.@DELETED@  = ' ' " 
		cQrySolVac+="     AND SRV.@DELETED@  = ' ' " 
		cQrySolVac+="     AND "+cAliasZZB+".@DELETED@  = ' ' " 
	ELSE                                           
		cQrySolVac+="     AND SRA.D_E_L_E_T_  = ' ' " 
		cQrySolVac+="     AND SRV.D_E_L_E_T_  = ' ' " 		
		cQrySolVac+="     AND "+cAliasZZB+".D_E_L_E_T_  = ' ' " 
	ENDIF
    cQrySolVac := ChangeQuery(cQrySolVac)
    DbUseArea( .T., 'TOPCONN', TCGENQRY(,, cQrySolVac), "TRBVAC", .T., .T. )
	dbSelectArea("TRBVAC")                      
	aLista:={}
	While !TRBVAC->(EOF())
	 if !ltodas
			AADD(aLista,{.F.,;
                       SUBSTR(TRBVAC->&(cAliasZZB+"_MAT"),1,8),;  //matricula
                       substr(TRBVAC->RA_NOME,1,25),;   			//Nombre
                       STOD(TRBVAC->&(cAliasZZB+"_FECSOL")),;      //Fecha de solicitud
                       SUBSTR(TRBVAC->&(cAliasZZB+"_PD"),1,5),;    //Concepto 
                       substr(TRBVAC->RV_DESC,1,15),;     			//Descripcion del concepto
                       STOD(TRBVAC->&(cAliasZZB+"_FECINI")),;      //Fecha de inicio
                       STOD(TRBVAC->&(cAliasZZB+"_FECFIN")),;      //Fecha de fin
						})
          aadd(aPosicio,{TRBVAC->R_E_C_N_O_,STOD(TRBVAC->&(cAliasZZB+"_FECINI"))})
     else                              
     			AADD(aLista,{.F.,;
                       SUBSTR(TRBVAC->&(cAliasZZB+"_MAT"),1,8),;  //matricula
                       substr(TRBVAC->RA_NOME,1,25),;   		  //Nombre
                       STOD(TRBVAC->&(cAliasZZB+"_FECSOL")),;     //Fecha de solicitud
                       SUBSTR(TRBVAC->&(cAliasZZB+"_PD"),1,5),;   //Concepto 
                       substr(TRBVAC->RV_DESC,1,15),;     		  //Descripcion del concepto
                       STOD(TRBVAC->&(cAliasZZB+"_FECINI")),;     //Fecha de inicio
                       STOD(TRBVAC->&(cAliasZZB+"_FECFIN")),;     //Fecha de fin  
                       TRBVAC->R_E_C_N_O_,;     				
                       TRBVAC->&(cAliasZZB+"_STATUS"),;     
                       STOD(TRBVAC->&(cAliasZZB+"_FECRES")),;     
			           TRBVAC->&(cAliasZZB+"_MOTREC"),;
						})

     endif       
            TRBVAC->(DBSKIP())
       ENDDO                    
       TRBVAC->(DBCLOSEAREA())
	   aLista:= aSort(aLista,,, { |x,y| x[7] >= y[7] })
	   aPosicio := aSort(aPosicio,,, { |x,y| x[2] >= y[2]})
RETURN aLista


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun??o    ³PN9SOLDOC ³       ³ Gpe Santacruz         ³ Data ³26/03/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri??o ³ Consulta de Solicitud de Documentos                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³PN9SOLDOC  (lPar01,cPar01)                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³lPar01: .t. Solo muestra las pendientes. F. Todas.          ³±±
±±³          ³cPar01: Matricula del empleado. Si vacia saca todos los em- ³±±
±±³          ³pleados del supervisor.                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³PNOM009                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±/*/     

USER FUNCTION 	PN9SOLDOC(lTodas,cMat,lDe)
Local aLista:={}
Local cQrySolPre:='' 
Local cAliasZZA:=UPPER(alltrim(GETMV("PT_SOLDOC")))

Default ltodas:= .f.                     
Default cMat:=''
Default lDe:= .t. //cuando la funcion es llamada desde el Control del supervisor
aPosicio:={}
DBSELECTAREA(cAliasZZA)

    cQrySolPre:= "SELECT "+cAliasZZA+".* FROM "
    cQrySolPre+= RetSqlName(cAliasZZA) + " "+cAliasZZA+"  "
   
    cQrySolPre+=" WHERE  "+cAliasZZA+"_FILIAL  ='"+XFILIAL(cAliasZZA)+"' "
	cQrySolPre+=" AND "+cAliasZZA+"_mat = '"+CMAT+"' "




    If ( TcSrvType()=="AS/400" )
		cQrySolPre+="     AND "+cAliasZZA+".@DELETED@  = ' ' " 
	ELSE                                           
		cQrySolPre+="     AND "+cAliasZZA+".D_E_L_E_T_  = ' ' " 
	ENDIF
    cQrySolPre := ChangeQuery(cQrySolPre)
    DbUseArea( .T., 'TOPCONN', TCGENQRY(,, cQrySolPre), "TRBDOC", .T., .T. )
	dbSelectArea("TRBDOC")                      
	aLista:={}
	While !TRBDOC->(EOF())
							

			               
						   AADD(aLista,{ STOD(TRBDOC->&(cAliasZZA+"_FECSOL")),;       //Fecha de solicitud          
						   TRBDOC->&(cAliasZZA+"_DOCTO"),;     //Concepto
	                       TRBDOC->&(cAliasZZA+"_INTERE"),;                //Descripcion del concepto
	                       TRBDOC->R_E_C_N_O_,;   //       
	  							})                                                                               
							

            aadd(aPosicio,TRBDOC->R_E_C_N_O_)            
            TRBDOC->(DBSKIP())
       ENDDO                    
       TRBDOC->(DBCLOSEAREA())
RETURN aLista

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun??o    ³PN9DATPER ³       ³ Gpe Santacruz         ³ Data ³03/03/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri??o ³ Consulta de Datos personales de acuero a TCF               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³PN9DATPER                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³PNOM009                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±/*/     

USER FUNCTION 	PN9DATPER(idFolder)

	Local cTabla := "SRA"
	Local _cXML	  	:= ""
	Local _cPref	:= ""
	Local i 	  	:= 0  
	Local aDicioT 	:= {}
	Local aDicFch	:= {}  
	Local aCBox		:= {}
	Local cFile		:= UPPER(alltrim(superGETMV("PT_ARCSRA",.f.,,)))//"GRHPER.FCH" Se obtiene el nombre del archivo del parámetro
	Local cBuffer	:= ""
	Local nX		:= 0
	Local nTamArq	:= 0
	Local nFor		:= 0
	Local nHdl		:= 0
	Local nElem		:= 0
	Local nPos		:= 0   
	Local nCont     := 0
	Default idFolder := ''
/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Genera en un arreglo los campos con Uso en la SX3 para la SRA³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
	Dbselectarea("SX3")
	SX3->( dbSetOrder(1) )
	IF SX3->( dbSeek(upper(cTabla)) ) 		

		While SX3->( !Eof() .And. SX3->X3_ARQUIVO == UPPER(cTabla) )
	       	IF 	SX3->X3_CONTEXT # 'V'
	    		nCont := nCont + 1          	
		        SX3->( aAdd(aDicioT,OemToAnsi(X3Titulo())+;
		        					Space(14)+CHR(179)+"["+IF(X3USO(X3_USADO),"X"," ")+"]"+;
		        					SPACE(01)+CHR(179)+"["+If (X3USO(x3_usado),"X"," ")+"]"+;
		        					Space(5)+SX3->X3_CAMPO+;
		        					Space(3)+StrZero(X3_TAMANHO,3)+;
		        					StrZero(X3_DECIMAL,2)+;
		        					StrZero(nCont,3)))
	 		EndIF
		    SX3->( dbSkip() )
		End While
	EndIF	
	
/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica cuales campos de la SRA puede visulizar el usuario de acuero a la configuracion del a Terminal de Empleado³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
	nElem := nCont
	IF File(cFile) .And. !Empty(cFile)        // Si encuentra el archivo y además no está vacío
		nHdl := Fopen(cFile,64)
		fSeek(nHdl,0,0)
		nTamArq := fSeek(nHdl,0,2)
		fSeek(nHdl,0,0)
		nFor := nTamArq / 63
		For nX := 1 To nFor
			cBuffer := Space(63)
			fRead(nHdl,@cBuffer,63)
			aAdd(aDicFch,cBuffer)
		Next nX                              	
		nElem := Len(aDicioT)	
		For nX:= 1 To nElem
			IF ( nPos := aScan(aDicFch,{ |x| Subs(x,44,10)=Subs(aDicioT[nX],41,10)}) ) > 0.00
				aDicioT[nX] :=	Subs(ADicioT[nX],1,28)		+;
								Subs(aDicFch[nPos],32,1)	+;
								Subs(aDicioT[nX],30,4)		+;
								Subs(aDicFch[nPos],37,1)	+;
								Subs(aDicioT[nX],35,24)		+;
								Subs(aDicFch[nPos],1,3)	
			EndIF
		Next nX
		fClose(nHdl)
	EndIF
	                                                    
	aDicioT:= aSort(aDicioT,,,{|x,y| Substr(x,59,3) < Substr(y,59,3)})
	aDicioW := {}

	For nX := 1 To nElem
	 	aAdd(	aDicioW	,{	IF(Subs(aDicioT[nX],29,1) == "X",.T.,.F.),;
	                    	IF(Subs(aDicioT[nX],34,1) == "X",.T.,.F.),;
	                    	Subs(aDicioT[nX],59,3),;
					  		Subs(aDicioT[nX],1,12),;
	                    	Subs(aDicioT[nX],41,18);
	                     };
		         )
		
	Next nX             
	
	If !Empty(idFolder)
			idfolder:= IIF(idFolder=='0',idFolder:=' ',idFolder:=idFolder)  
			aDicFch:= {}  
			
			For nX:=1 to len(aDicioW)
			    _cXML 	:= POSICIONE("SX3",2,Substr(aDicioW[nX,5],1,10),"X3_FOLDER")
			    _cPref 	:= POSICIONE("SX3",2,Substr(aDicioW[nX,5],1,10),"X3_CBOXSPA")
			    
			    AADD(aDicioW[nX]," ")
			    If !Empty(_cPref)
			   		aCBOX := separa(_cPref,";")	   
			   		aDicioW[nX,len(adiciow[nX])] := aCbox
			    End If
			    If _cXML == idFolder
					AADD(aDicFch,aDicioW[nX]) 			    
			    End IF
				
			Next nX	     
			   
			aDicioW := aClone(aDicFch)
	End If
	
RETURN aDicioW
/*............................FUNCIONES PARA LA HISTORIA LABORAL ................................................*/
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun??o    ³PN9HISLAB ³       ³ Gpe Santacruz         ³ Data ³03/03/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri??o ³ Consulta de la historia laboral de cada empleado           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³PN9HISLAB(cPar01,dPar01,dPar02,cPar02)                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cPar01: Cadena con los Tipos de movimientos a consultar     ³±±
±±³          ³dPar01 y dPar02 :Fecha de inicio y fin                      ³±±
±±³          ³cPar02: Matricula del empleadoo                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³PNOM009                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±/*/     

user function PN9HISLAB(cString,dFecini,dFecFin,cMat)
/*Retorna una arreglo con la historia Laboral*/
Local nx:=0
Local nTam:=0
Local cStr:=alltrim(cString)

Private aDatosHisLab  :={}
nTam:=len(cStr)
For nx:=1 to nTam
    cTipo:=substr(cStr,nx,1)
    Do case
    	Case cTipo=='A'//altas
    	     HISALTAS(dFecini,dFecFin,cMat,"A")
    	Case cTipo=='B' //Bajas
	   	     HISBAJAS(dFecini,dFecFin,cMat)    	     
    	Case cTipo=='M' //Modificaciones de salario
	   	      HISALTAS(dFecini,dFecFin,cMat,"M")
    	Case cTipo=='D' //Cambios de Departamento   	     
	   	      HISDEPYCC(dFecini,dFecFin,cMat,"D")
    	Case cTipo=='C'// Cambios de Centro de costos
	   	      HISDEPYCC(dFecini,dFecFin,cMat,"C")
    	Case cTipo=='L'// Cambios de Localidad de Pago
	   	      HISLOCP(dFecini,dFecFin,cMat)
    	Case cTipo=='F' //Cambios de Funcion   	     
	   	      HISFUNCAR(dFecini,dFecFin,cMat,"F")
    	Case cTipo=='P' //Cambios de Funcion   	     
	   	      HISFUNCAR(dFecini,dFecFin,cMat,"P")
	   	     
    endcase	
Next
/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Contenido de aDatosHisLab:                    ³
//³1. Fecha del movimiento (tipo fecha)          ³
//³2. Descripcion del movimiento (string)        ³
//³3. Salario diario (numerico)                  ³
//³4.Salario diario integrado (numerico)         ³
//³5.Salario mensual (Numerico)                  ³
//³6.Codigo y descripcion de la localidad de pago³
//³7.Codigo y descripcion del centro de costo.   ³
//³8.Codigo y descripcion del departamento       ³
//³9.Codigo y descripcion de la Funcion          ³
//³10. Codigo y descripcion del Cargo            ³         IMPORTANTE !!!!
//³11. Codigo de operacióm interna	             ³    <=== Si se requiere agregar un nuevo movimiento, deberá agregar un nuevo código indicador
//³		1.Alta						             ³         además de que deberá agregar las funciones correspondientes para ese nuevo código.
//³		2.Bajas						             ³
//³		3.Modificaciones			             ³
//³		4.Depto						             ³
//³		5.Centro de costo			             ³
//³		6.Loc. Pago					             ³
//³		7.Función					             ³
//³		8.Cargo						             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

aDatosHisLab:=aSort(aDatosHisLab,,,{|x,y| dtos(x[1])+x[11] <= dtos(y[1])+Y[11]})   //ORDENA POR FECHA DE MOVIMIENTO
return aDatosHisLab                 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun??o    ³HISALTAS  ³       ³ Gpe Santacruz         ³ Data ³03/03/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri??o ³ Consulta las Altas de los movimiento de :                  ³±±
±±³          ³ 01-Ingreso 03- Altas de Reg Pat, 06-Reingreso              ³±±
±±³          ³ 05-Modificacion de salario                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³HISALTAS(dPar01,dPar02,cPar01,cPar01)                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±³          ³dPar01 y dPar02 :Fecha de inicio y fin                      ³±±
±±³          ³cPar01: Matricula del empleadoo                             ³±±
±±³          ³cPar02: A-Altas, M-Modificacion de Salarios                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³PN9HISLAB                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±/*/     

STATIC FUNCTION HISALTAS(dFecini,dFecFin,cMat,cTM)
Local cQryAlta:=''
Local cAliasAltas := CriaTrab(Nil,.F.)	
Local cDesLoc:=''
Local cDesCC:=''
Local cDesDEPTO:=''
Local cDesFuncao:=''
Local cDescCargo:=''
Local cDesTM:=''             

Local cInd:= '0'
Local cCC := '' 
Local cDp := ''
Local cLP := ''
Local cFN := ''
Local cCar:= ''


cQryAlta:="Select RCP_DTMOV,RCP_TPMOV,RCP_SALDIA,RCP_SALDII, RCP_SALMES,RA_KEYLOC,RA_CC,RA_CODFUNC,RA_DEPTO,RA_CARGO FROM "+RETSQLNAME("RCP")+" RCP, "
cQryAlta+=RETSQLNAME("SRA")+" SRA WHERE RCP_FILIAL='"+XFILIAL("RCP")+"' AND RA_FILIAL='"+XFILIAL("SRA")+"' "
cQryAlta+=" AND RCP_MAT=RA_MAT AND RCP_MAT='"+CMAT+"' "

IF 	cTM=='A'
	cQryAlta+=" AND RCP_TPMOV IN ('01','03','06') " 
	cInd := '1'
else                                               
	cQryAlta+=" AND RCP_TPMOV ='05' "
	cInd := '3'
endif	

cQryAlta+=" AND RCP_DTMOV BETWEEN '"+DTOS(DFECINI)+ "' AND '"+DTOS(DFECFIN)+ "' "
If ( TcSrvType()=="AS/400" )
	cQryAlta+="     AND SRA.@DELETED@  = ' ' "                                                                     
	cQryAlta+="     AND RCP.@DELETED@  = ' ' "                                                                     	
ELSE 
	cQryAlta+="     AND SRA.D_E_L_E_T_  = ' ' " 
	cQryAlta+="     AND RCP.D_E_L_E_T_  = ' ' "                                                                     		
ENDIF
cQryAlta := ChangeQuery(cQryAlta)

DbUseArea( .T., 'TOPCONN', TCGENQRY(,, cQryAlta),cAliasAltas, .T., .T. )
TCSetField(cAliasAltas,"RCP_DTMOV","D")  

Do while !(cAliasAltas)->(eof())
    
    IF cTM == 'A'
	    cCC := getInfHL(0,"RE_DATA" ,"RE_CCD" 	 	,"SRE"," RE_FILIAL='"+XFILIAL("SRE")+"' AND RE_MATP='"+cMAT+"' ")                     	// cc       
		cDp := getInfHL(0,"RE_DATA" ,"RE_DEPTOP"	,"SRE"," RE_FILIAL='"+XFILIAL("SRE")+"' AND RE_MATP='"+cMAT+"' ")                     	// DEPTO
		cLP := getInfHL(0,"R9_CAMPO","R9_DESC"		,"SR9"," R9_MAT='"+cMAT+"' AND R9_CAMPO='RA_KEYLOC' ")  								// lp
		cFN := getInfHL(0,"R7_DATA" ,"R7_FUNCAO"	,"SR7"," R7_FILIAL='"+XFILIAL("SR7")+"' AND R7_MAT='"+cMAT+"' ")                      // FN
		cCar:= getInfHL(0,"R7_DATA" ,"R7_CARGO"		,"SR7"," R7_FILIAL='"+XFILIAL("SR7")+"' AND R7_MAT='"+cMAT+"' ")                       // CARGO
	ELSE
	    cCC := getInfHL(1,"RE_DATA" ,"RE_CCD" 	 	,"SRE"," RE_FILIAL='"+XFILIAL("SRE")+"' AND RE_MATP='"+cMAT+"' AND RE_DATA>='"+ DTOS((cAliasAltas)->RCP_DTMOV) + "'  "	,DTOS((cAliasAltas)->RCP_DTMOV))                     	// cc       
		cDp := getInfHL(1,"RE_DATA" ,"RE_DEPTOP"	,"SRE"," RE_FILIAL='"+XFILIAL("SRE")+"' AND RE_MATP='"+cMAT+"' AND RE_DATA>='"+ DTOS((cAliasAltas)->RCP_DTMOV) + "'  "	,DTOS((cAliasAltas)->RCP_DTMOV))                     	// DEPTO
		cLP := getInfHL(1,"R9_DATA" ,"R9_DESC"		,"SR9"," R9_MAT='"+cMAT+"' AND R9_CAMPO='RA_KEYLOC' AND R9_DATA>='"+ DTOS((cAliasAltas)->RCP_DTMOV) + "'  "				,DTOS((cAliasAltas)->RCP_DTMOV))  								// lp
		cFN := getInfHL(1,"R7_DATA" ,"R7_FUNCAO"	,"SR7"," R7_FILIAL='"+XFILIAL("SR7")+"' AND R7_MAT='"+cMAT+"' AND R7_DATA>='"+ DTOS((cAliasAltas)->RCP_DTMOV) + "'  "		,DTOS((cAliasAltas)->RCP_DTMOV))                      // FN
		cCar:= getInfHL(1,"R7_DATA" ,"R7_CARGO"		,"SR7"," R7_FILIAL='"+XFILIAL("SR7")+"' AND R7_MAT='"+cMAT+"' AND R7_DATA>='"+ DTOS((cAliasAltas)->RCP_DTMOV) + "'  "		,DTOS((cAliasAltas)->RCP_DTMOV))                       // CARGO	
	END IF	
    
    cDesLoc		:=_LocPag(cmat,IIF(Empty(cLP),(cAliasAltas)->Ra_KEYLOC,cLP))
    cDesCC 		:=_CenCosDepto(CMAT,IIF(Empty(cCC),(cAliasAltas)->Ra_CC,cCC),(cAliasAltas)->RCP_DTMOV,"C",(cAliasAltas)->RCP_TPMOV)
    cDesDepto	:=_CenCosDepto(CMAT,IIF(Empty(cDP),(cAliasAltas)->Ra_depto,cDP),(cAliasAltas)->RCP_DTMOV,"D",(cAliasAltas)->RCP_TPMOV)
    cDesFuncao	:=_FunCar(CMAT,IIF(Empty(cFN),(cAliasAltas)->Ra_CODFUNC,cFN),(cAliasAltas)->RCP_DTMOV,"F")
    cDescCargo	:=_FunCar(CMAT,IIF(Empty(cCar),(cAliasAltas)->Ra_CARGO,cCar),(cAliasAltas)->RCP_DTMOV,"C")
    cDesTM:=''

    do case 
	    case (cAliasAltas)->RCP_TPMOV='01'
		        cDesTM:= OemToAnsi(STR0001) //"01-Ingreso"
	    case (cAliasAltas)->RCP_TPMOV='03'
		        cDesTM:= OemToAnsi(STR0002) //"03-Alta Reg.Patr."
	    case (cAliasAltas)->RCP_TPMOV='05'
		        cDesTM:= OemToAnsi(STR0003) //"05-Modif.Sal."
	    case (cAliasAltas)->RCP_TPMOV='06'
		        cDesTM:= OemToAnsi(STR0004) //"06-Reingreso"	        
    endcase

    aadd(aDatosHisLab,{(cAliasAltas)->RCP_DTMOV,;
    			 substr(cDesTM,rat("-",cDesTM)+1,30),;
    			 (cAliasAltas)->RCP_SALDIA,;
    			 (cAliasAltas)->RCP_SALDII,;
    			 (cAliasAltas)->RCP_SALMES,;
    			 cDesLoc,;
    			 cDesCC,;     
    			 cDesDepto,;
    			 cDesFuncao,;
    			 cDescCargo,;
    			 cInd})
    			 
	(cAliasAltas)->(dbskip())
enddo	
(cAliasAltas)->(DbCloseArea())

RETURN 
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun??o    ³HISBAJAS  ³       ³ Gpe Santacruz         ³ Data ³03/03/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri??o ³ Consulta las Bajas                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³HISBAJAS(dPar01,dPar02,cPar01)                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±³          ³dPar01 y dPar02 :Fecha de inicio y fin                      ³±±
±±³          ³cPar01: Matricula del empleadoo                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³PN9HISLAB                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±/*/     
                                

STATIC FUNCTION HISBAJAS(dFecini,dFecFin,cMat)


Local cQry:=''
Local cAliasQRY := CriaTrab(Nil,.F.)	
Local cDesLoc:=''
Local cDesCC:=''
Local cDesDEPTO:=''
Local cDesFuncao:=''
Local cDesCargo:=''
Local cDesTM:=''    
Local cInd:= '2' // Código interno para el tipo de operación

cQry:="Select RCP_DTMOV,RCP_TPMOV,RCP_SALDIA,RCP_SALDII, RCP_SALMES,RA_KEYLOC,ra_depto,RA_CC,RA_CODFUNC,RA_CARGO,QB_DESCRIC, RJ_DESC, Q3_DESCSUM, CTT_DESC01,RGC_DESLOC FROM "+RETSQLNAME("RCP")+" RCP, "
cQry+=RETSQLNAME("SRA")+" SRA "       

    cQry	+= " LEFT OUTER JOIN " + RetSqlName("RGC") + " RGC "
    If ( TcSrvType()=="AS/400" )
	   cQry	+= " ON RGC.@DELETED@"
    ELSE
	   cQry	+= " ON RGC.D_E_L_E_T_ = ' ' "
	ENDIF   
    cQry	+= " AND RGC_FILIAL='"+XFILIAL("RGC")+"' "
    cQry	+= " AND RGC_KEYLOC=RA_KEYLOC "

    cQry	+= " LEFT OUTER JOIN " + RetSqlName("CTT") + " CTT"
    If ( TcSrvType()=="AS/400" )
	   cQry	+= " ON CTT.@DELETED@"
    ELSE
	   cQry	+= " ON CTT.D_E_L_E_T_ = ' ' "
	ENDIF   
    cQry	+= " AND CTT_FILIAL='"+XFILIAL("CTT")+"' "
    cQry	+= " AND CTT_CUSTO=RA_CC"
    
    cQry	+= " LEFT OUTER JOIN " + RetSqlName("SQB") + " SQB"
    If ( TcSrvType()=="AS/400" )
	   cQry	+= " ON SQB.@DELETED@"
    ELSE
	   cQry	+= " ON SQB.D_E_L_E_T_ = ' ' "
	ENDIF   
    cQry	+= " AND QB_FILIAL='"+XFILIAL("SQB")+"' "
    cQry	+= " AND QB_DEPTO=RA_DEPTO"
    cQry	+= " LEFT OUTER JOIN " + RetSqlName("SRJ") + " SRJ"
    If ( TcSrvType()=="AS/400" )
	   cQry	+= " ON SRJ.@DELETED@"
    ELSE
	   cQry	+= " ON SRJ.D_E_L_E_T_ = ' ' "
	ENDIF   
    cQry	+= " AND RJ_FILIAL='"+XFILIAL("SRJ")+"' "
    cQry	+= " AND RJ_FUNCAO = RA_CODFUNC"
    cQry	+= " LEFT OUTER JOIN " + RetSqlName("SQ3") + " SQ3"
    If ( TcSrvType()=="AS/400" )
	   cQry	+= " ON SQ3.@DELETED@"
    ELSE
	   cQry	+= " ON SQ3.D_E_L_E_T_ = ' ' "
	ENDIF   
    cQry	+= " AND Q3_FILIAL ='"+XFILIAL("SQ3")+"' "
    cQry	+= " AND Q3_CARGO = RA_CARGO"
    If ( TcSrvType()=="AS/400" )
		cQry+=" AND SQ3.@DELETED@  = ' ' "
    ELSE
		cQry+= " AND SQ3.D_E_L_E_T_  = ' ' "
	ENDIF	                

	cQry+=" WHERE RCP_FILIAL='"+XFILIAL("RCP")+"' AND RA_FILIAL='"+XFILIAL("SRA")+"' "
	cQry+=" AND RCP_MAT=RA_MAT AND RCP_MAT='"+CMAT+"' "
	cQry+=" AND RCP_TPMOV IN ('04','20') AND RCP_DTMOV BETWEEN '"+DTOS(DFECINI)+ "' AND '"+DTOS(DFECFIN)+ "' "
	If ( TcSrvType()=="AS/400" )
		cQry+="     AND SRA.@DELETED@  = ' ' "                                                                     
		cQry+="     AND RCP.@DELETED@  = ' ' "                                                                     	
	ELSE 
		cQry+="     AND SRA.D_E_L_E_T_  = ' ' " 
		cQry+="     AND RCP.D_E_L_E_T_  = ' ' "                                                                     		
	ENDIF
	cQry := ChangeQuery(cQry)

DbUseArea( .T., 'TOPCONN', TCGENQRY(,, cQry),cAliasQRY, .T., .T. )
TCSetField(cAliasQRY,"RCP_DTMOV","D")  


Do while !(cAliasQRY)->(eof())

    cDesLoc:=(cAliasQRY)->RA_KEYLOC+"-"+(cAliasQRY)->RGC_DESLOC
    cDesCC:=(cAliasQRY)->RA_CC+"-"+(cAliasQRY)->CTT_DESC01
    cDesDepto:=(cAliasQRY)->RA_DEPTO+"-"+(cAliasQRY)->QB_DESCRIC
    cDesFuncao:=(cAliasQRY)->RA_CODFUNC+"-"+(cAliasQRY)->RJ_DESC
    cDescCargo:=(cAliasQRY)->RA_CARGO+"-"+(cAliasQRY)->Q3_DESCSUM
    cDesTM:=''
    do case 
	    case (cAliasQRY)->RCP_TPMOV='04'
		        cDesTM:= OemToAnsi(STR0005) //"04-Baja Reg.Patr"
	    case (cAliasQRY)->RCP_TPMOV='20'
		        cDesTM:= OemToAnsi(STR0006) //"20-Baja Planilla"
	        
    endcase

    aadd(aDatosHisLab,{(cAliasQRY)->RCP_DTMOV,;
    			 substr(cDesTM,rat("-",cDesTM)+1,30),;
    			 (cAliasQRY)->RCP_SALDIA,;
    			 (cAliasQRY)->RCP_SALDII,;
    			 (cAliasQRY)->RCP_SALMES,;
    			 cDesLoc,;
    			 cDesCC,;     
    			 cDesDepto,;
    			 cDesFuncao,;
    			 cDesCargo,;
    			 cInd})
    			 
	(cAliasQRY)->(dbskip())
enddo	
(cAliasQRY)->(DbCloseArea())

RETURN 
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun??o    ³HISDEPYCC ³       ³ Gpe Santacruz         ³ Data ³03/03/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri??o ³ Consulta losas Cambios de Depto o Centro de Costos         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³HISDEPYCC(dPar01,dPar02,cPar01,cPar02)                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±³          ³dPar01 y dPar02 :Fecha de inicio y fin                      ³±±
±±³          ³cPar01: Matricula del empleadoo                             ³±±
±±³          ³cPar02: D-Verifica cambios de departamento                  ³±±
±±³          ³        C-Verifica cambios de centros de costos             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³PN9HISLAB                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±/*/     


STATIC FUNCTION HISDEPYCC(dFecini,dFecFin,cMat,cMov)


Local cQryTmp:=''
Local cAliasTmp := CriaTrab(Nil,.F.)	
Local cDesLoc:=''
Local cDesCC:=''
Local cDesDEPTO:=''
Local cDesFuncao:=''
Local cDescCargo:=''
Local cDesTM:=''
Local aSalario:={}


Local cCC := '' 
Local cDp := ''
Local cLP := ''
Local cFN := ''
Local cCar:= ''
Local cInd:= '0'

cQryTmp:="Select RE_DATA,RA_KEYLOC,RA_CC,RA_CODFUNC,RA_DEPTO,RA_CARGO FROM "+RETSQLNAME("SRE")+" SRE, "
cQryTmp+=RETSQLNAME("SRA")+" SRA WHERE RE_FILIAL='"+XFILIAL("SRE")+"' AND RA_FILIAL='"+XFILIAL("SRA")+"' "
cQryTmp+=" AND RE_MATP=RA_MAT AND RE_MATP='"+CMAT+"' "
if cMov=='D'
	cQryTmp+=" AND RE_DEPTOD<>RE_DEPTOP "
    cDesTM:= OemToAnsi(STR0007) //"Cambio Departamento"     
    cInd := '4'
else                                     
	cQryTmp+=" AND RE_CCD<>RE_CCP " 
    cDesTM:= OemToAnsi(STR0008) //"Cambio Centro de Costo"      
    cInd := '5'
endif


cQryTmp+=" AND RE_DATA BETWEEN '"+DTOS(DFECINI)+ "' AND '"+DTOS(DFECFIN)+ "' "
If ( TcSrvType()=="AS/400" )
	cQryTmp+="     AND SRA.@DELETED@  = ' ' "                                                                     
	cQryTmp+="     AND SRE.@DELETED@  = ' ' "                                                                     	
ELSE 
	cQryTmp+="     AND SRA.D_E_L_E_T_  = ' ' " 
	cQryTmp+="     AND SRE.D_E_L_E_T_  = ' ' "                                                                     		
ENDIF
cQryTmp := ChangeQuery(cQryTmp)

DbUseArea( .T., 'TOPCONN', TCGENQRY(,, cQryTmp),cAliasTmp, .T., .T. )
TCSetField(cAliasTmp,"RE_DATA","D")  


Do while !(cAliasTmp)->(eof())          
    aSalario:=HISSALARIO(cMat,(cAliasTmp)->RE_DATA)
    
    cCC := getInfHL(1,"RE_DATA" ,"RE_CCD" 	 	,"SRE"," RE_FILIAL='"+XFILIAL("SRE")+"' AND RE_MATP='"+cMAT+"' AND RE_DATA>='"+ dtos((cAliasTmp)->RE_DATA) + "'  "	,dtos((cAliasTmp)->RE_DATA))                     	// cc       
	cDp := getInfHL(1,"RE_DATA" ,"RE_DEPTOP"	,"SRE"," RE_FILIAL='"+XFILIAL("SRE")+"' AND RE_MATP='"+cMAT+"' AND RE_DATA>='"+ dtos((cAliasTmp)->RE_DATA) + "'  "	,dtos((cAliasTmp)->RE_DATA))                     	// DEPTO
	cLP := getInfHL(1,"R9_DATA" ,"R9_DESC"		,"SR9"," R9_MAT='"+cMAT+"' AND R9_CAMPO='RA_KEYLOC' AND R9_DATA>='"+ dtos((cAliasTmp)->RE_DATA) + "'  "	,dtos((cAliasTmp)->RE_DATA))  								// lp
	cFN := getInfHL(1,"R7_DATA" ,"R7_FUNCAO"	,"SR7"," R7_FILIAL='"+XFILIAL("SR7")+"' AND R7_MAT='"+cMAT+"' AND R7_DATA>='"+ dtos((cAliasTmp)->RE_DATA) + "'  "	,dtos((cAliasTmp)->RE_DATA))                      // FN
	cCar:= getInfHL(1,"R7_DATA" ,"R7_CARGO"		,"SR7"," R7_FILIAL='"+XFILIAL("SR7")+"' AND R7_MAT='"+cMAT+"' AND R7_DATA>='"+ dtos((cAliasTmp)->RE_DATA) + "'  "	,dtos((cAliasTmp)->RE_DATA))                       // CARGO
    
    cDesLoc	 :=_LocPag(cmat,IIF(Empty(cLP),(cAliasTmp)->Ra_KEYLOC,cLP))
    cDesCC	 :=_CenCosDepto(CMAT,IIF(empty(cCC),(cAliasTmp)->Ra_CC,cCC),(cAliasTmp)->RE_DATA,"C")
    cDesDepto:=_CenCosDepto(CMAT,IIF(empty(cDP),(cAliasTmp)->Ra_depto,cDP),(cAliasTmp)->RE_DATA,"D")

    cDesFuncao:=_FunCar(CMAT,IIF(Empty(cFN),(cAliasTmp)->Ra_CODFUNC,cFN),(cAliasTmp)->RE_DATA,"F")
    cDescCargo:=_FunCar(CMAT,IIF(Empty(cCar),(cAliasTmp)->Ra_CARGO,cCar),(cAliasTmp)->RE_DATA,"C")

    aadd(aDatosHisLab,{(cAliasTmp)->RE_DATA,;
    			 substr(cDesTM,rat("-",cDesTM)+1,30),;
    			 aSalario[1],;
    			 aSalario[2],;
    			 aSalario[3],;
    			 cDesLoc,;
    			 cDesCC,;     
    			 cDesDepto,;
    			 cDesFuncao,;
    			 cDescCargo,;
    			 cInd})
    			 
	(cAliasTmp)->(dbskip())
enddo	
(cAliasTmp)->(DbCloseArea())

RETURN 
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun??o    ³HISLOCP   ³       ³ Gpe Santacruz         ³ Data ³03/03/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri??o ³ Consulta de cambios de Localidades de Pago                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³HISLOCP(dPar01,dPar02,cPar01 )	                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±³          ³dPar01 y dPar02 :Fecha de inicio y fin                      ³±±
±±³          ³cPar01: Matricula del empleadoo                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³PN9HISLAB                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±/*/     

STATIC FUNCTION HISLOCP(dFecini,dFecFin,cMat)


Local cQryTmp:=''
Local cAliasTmp := CriaTrab(Nil,.F.)	
Local cDesLoc:=''
Local cDesCC:=''
Local cDesDEPTO:=''
Local cDesFuncao:=''
Local cDescCargo:=''
Local cDesTM:='Cambio Localidad de Pago'
Local aSalario:={}  
Local cInd	:= '6'
Local cCC := '' 
Local cDp := ''
Local cLP := ''
Local cFN := ''
Local cCar:= ''

cQryTmp:="Select R9_DATA,RA_KEYLOC,RA_CC,RA_CODFUNC,RA_DEPTO,RA_CARGO  FROM "+RETSQLNAME("SR9")+" SR9, "
cQryTmp+=RETSQLNAME("SRA")+" SRA WHERE R9_FILIAL='"+XFILIAL("SR9")+"' AND RA_FILIAL='"+XFILIAL("SRA")+"' "
cQryTmp+=" AND R9_MAT=RA_MAT AND RA_MAT='"+CMAT+"' "
cQryTmp+=" AND R9_CAMPO='RA_KEYLOC ' "
cQryTmp+=" AND R9_DATA BETWEEN '"+DTOS(DFECINI)+ "' AND '"+DTOS(DFECFIN)+ "' "

If ( TcSrvType()=="AS/400" )
	cQryTmp+="     AND SRA.@DELETED@  = ' ' "                                                                     
	cQryTmp+="     AND SR9.@DELETED@  = ' ' "                                                                     	
ELSE 
	cQryTmp+="     AND SR9.D_E_L_E_T_  = ' ' " 
	cQryTmp+="     AND SR9.D_E_L_E_T_  = ' ' "                                                                     		
ENDIF
cQryTmp := ChangeQuery(cQryTmp)

DbUseArea( .T., 'TOPCONN', TCGENQRY(,, cQryTmp),cAliasTmp, .T., .T. )
TCSetField(cAliasTmp,"R9_DATA","D")  


Do while !(cAliasTmp)->(eof())          
    aSalario:=HISSALARIO(cMat,(cAliasTmp)->R9_DATA)
	
	cCC := getInfHL(1,"RE_DATA" ,"RE_CCD" 	 	,"SRE"," RE_FILIAL='"+XFILIAL("SRE")+"' AND RE_MATP='"+cMAT+"' AND RE_DATA>='"+ dtos((cAliasTmp)->R9_DATA) + "'  "	,dtos((cAliasTmp)->R9_DATA))                     	// cc       
	cDp := getInfHL(1,"RE_DATA" ,"RE_DEPTOP"	,"SRE"," RE_FILIAL='"+XFILIAL("SRE")+"' AND RE_MATP='"+cMAT+"' AND RE_DATA>='"+ dtos((cAliasTmp)->R9_DATA) + "'  "	,dtos((cAliasTmp)->R9_DATA))                     	// DEPTO
	cLP := getInfHL(1,"R9_DATA" ,"R9_DESC"		,"SR9"," R9_MAT='"+cMAT+"' AND R9_CAMPO='RA_KEYLOC' AND R9_DATA>='"+ dtos((cAliasTmp)->R9_DATA) + "'  "	,dtos((cAliasTmp)->R9_DATA))  								// lp
	cFN := getInfHL(1,"R7_DATA" ,"R7_FUNCAO"	,"SR7"," R7_FILIAL='"+XFILIAL("SR7")+"' AND R7_MAT='"+cMAT+"' AND R7_DATA>='"+ dtos((cAliasTmp)->R9_DATA) + "'  "	,dtos((cAliasTmp)->R9_DATA))                      // FN
	cCar:= getInfHL(1,"R7_DATA" ,"R7_CARGO"		,"SR7"," R7_FILIAL='"+XFILIAL("SR7")+"' AND R7_MAT='"+cMAT+"' AND R7_DATA>='"+ dtos((cAliasTmp)->R9_DATA) + "'  "	,dtos((cAliasTmp)->R9_DATA))                       // CARGO
    


    cDesLoc		:=_LocPag(cmat,IIF(EMPTY(cLP),(cAliasTmp)->Ra_KEYLOC,cLP))
    cDesCC		:=_CenCosDepto(CMAT,IIF(EMPTY(cCC),(cAliasTmp)->Ra_CC,cCC),(cAliasTmp)->R9_DATA,"C")
    cDesDepto	:=_CenCosDepto(CMAT,IIF(EMPTY(cdp),(cAliasTmp)->Ra_depto,cDP),(cAliasTmp)->R9_DATA,"D")

    cDesFuncao	:=_FunCar(CMAT,IIF(EMPTY(cFN) ,(cAliasTmp)->Ra_CODFUNC,cFN) ,(cAliasTmp)->R9_DATA,"F")
    cDescCargo	:=_FunCar(CMAT,IIF(EMPTY(cCar),(cAliasTmp)->Ra_CARGO  ,cCar),(cAliasTmp)->R9_DATA,"C")

    aadd(aDatosHisLab,{(cAliasTmp)->R9_DATA,;
    			 substr(cDesTM,rat("-",cDesTM)+1,30),;
    			 aSalario[1],;
    			 aSalario[2],;
    			 aSalario[3],;
    			 cDesLoc,;
    			 cDesCC,;     
    			 cDesDepto,;
    			 cDesFuncao,;
    			 cDescCargo,;
    			 cInd})
    			 
	(cAliasTmp)->(dbskip())
enddo	
(cAliasTmp)->(DbCloseArea())

RETURN 
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun??o    ³HISFUNCAR ³       ³ Gpe Santacruz         ³ Data ³03/03/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri??o ³ Consulta losas Cambios de Funcion o Cargo                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³HISBAJAS(dPar01,dPar02,cPar01,cPar02)                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±³          ³dPar01 y dPar02 :Fecha de inicio y fin                      ³±±
±±³          ³cPar01: Matricula del empleadoo                             ³±±
±±³          ³cPar02: F-Verifica cambios de funciones                     ³±±
±±³          ³        P-Verifica cambios de puestos                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³PN9HISLAB                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±/*/     

STATIC FUNCTION HISFUNCAR(dFecini,dFecFin,cMat,cMov)

Local cQryTmp:=''
Local cAliasTmp := CriaTrab(Nil,.F.)	
Local cDesLoc:=''
Local cDesCC:=''
Local cDesDEPTO:=''
Local cDesFuncao:=''
Local cDescCargo:=''
Local cDesTM:=''
Local aSalario:={}
Local cDes:=''       
Local cInd := '0'              
Local cCC := '' 
Local cDp := ''
Local cLP := ''
Local cFN := ''
Local cCar:= ''

cQryTmp:="Select R7_DATA,RA_KEYLOC,RA_CC,RA_CODFUNC,RA_DEPTO,RA_CARGO FROM "+RETSQLNAME("SR7")+" SR7, "
cQryTmp+=RETSQLNAME("SRA")+" SRA WHERE R7_FILIAL='"+XFILIAL("SR7")+"' AND RA_FILIAL='"+XFILIAL("SRA")+"' "
cQryTmp+=" AND R7_MAT=RA_MAT AND R7_MAT='"+CMAT+"' "
if cMov=='F'
	cQryTmp+=" AND R7_FUNCAO<>Ra_CODFUNC "
    cDesTM:= OemToAnsi(STR0009) //"Cambio Funcion"  
    cInd := '7'
else                                     
	cQryTmp+=" AND R7_CARGO<>RA_CARGO " 
    cDesTM:= OemToAnsi(STR0010) //"Cambio Cargos"  
    cInd := '8'
endif

cQryTmp+=" AND R7_DATA BETWEEN '"+DTOS(DFECINI)+ "' AND '"+DTOS(DFECFIN)+ "' "
If ( TcSrvType()=="AS/400" )
	cQryTmp+="     AND SRA.@DELETED@  = ' ' "                                                                     
	cQryTmp+="     AND SR7.@DELETED@  = ' ' "                                                                     	
ELSE 
	cQryTmp+="     AND SRA.D_E_L_E_T_  = ' ' " 
	cQryTmp+="     AND SR7.D_E_L_E_T_  = ' ' "                                                                     		
ENDIF
cQryTmp := ChangeQuery(cQryTmp)

DbUseArea( .T., 'TOPCONN', TCGENQRY(,, cQryTmp),cAliasTmp, .T., .T. )
TCSetField(cAliasTmp,"R7_DATA","D")  

srj->(DBSETORDER(1))
sq3->(DBSETORDER(1))
Do while !(cAliasTmp)->(eof())          
    aSalario:=HISSALARIO(cMat,(cAliasTmp)->R7_DATA)     

 	cCC := getInfHL(1,"RE_DATA" ,"RE_CCD" 	 	,"SRE"," RE_FILIAL='"+XFILIAL("SRE")+"' AND RE_MATP='"+cMAT+"' AND RE_DATA>='"+ dtos((cAliasTmp)->R7_DATA) + "'  "	,dtos((cAliasTmp)->R7_DATA))                     	// cc       
	cDp := getInfHL(1,"RE_DATA" ,"RE_DEPTOP"	,"SRE"," RE_FILIAL='"+XFILIAL("SRE")+"' AND RE_MATP='"+cMAT+"' AND RE_DATA>='"+ dtos((cAliasTmp)->R7_DATA) + "'  "	,dtos((cAliasTmp)->R7_DATA))                     	// DEPTO
	cLP := getInfHL(1,"R9_DATA" ,"R9_DESC"		,"SR9"," R9_MAT='"+cMAT+"' AND R9_CAMPO='RA_KEYLOC' AND R9_DATA>='"+ dtos((cAliasTmp)->R7_DATA) + "'  "	,dtos((cAliasTmp)->R7_DATA))  								// lp
	cFN := getInfHL(1,"R7_DATA" ,"R7_FUNCAO"	,"SR7"," R7_FILIAL='"+XFILIAL("SR7")+"' AND R7_MAT='"+cMAT+"' AND R7_DATA>='"+ dtos((cAliasTmp)->R7_DATA) + "'  "	,dtos((cAliasTmp)->R7_DATA))                      // FN
	cCar:= getInfHL(1,"R7_DATA" ,"R7_CARGO"		,"SR7"," R7_FILIAL='"+XFILIAL("SR7")+"' AND R7_MAT='"+cMAT+"' AND R7_DATA>='"+ dtos((cAliasTmp)->R7_DATA) + "'  "	,dtos((cAliasTmp)->R7_DATA))                       // CARGO
 
    
    cDesLoc		:=_LocPag(cmat,IIF(EMPTY(cLP),(cAliasTmp)->Ra_KEYLOC,cLP))
    cDesCC		:=_CenCosDepto(CMAT,IIF(EMPTY(cCC),(cAliasTmp)->Ra_CC,cCC),(cAliasTmp)->R7_DATA,"C")
    cDesDepto	:=_CenCosDepto(CMAT,IIF(EMPTY(cdp),(cAliasTmp)->Ra_depto,cDP),(cAliasTmp)->R7_DATA,"D")


	if cMov=='F'
		If srj->(DBSEEK(XFILIAL("SRJ")+IIF(EMPTY(cFN) ,(cAliasTmp)->Ra_CODFUNC,cFN)))
			   cDes:=SRJ->RJ_DESC
		else                       
			   cDes:= OemToAnsi(STR0011)  //"No encontre Función "
		ENDIF               
	    cDesFuncao:=/*(cAliasTmp)->RA_CODFUNC +"-"+*/substr(cDes,1,30)
        cDescCargo:=_FunCar(CMAT,IIF(EMPTY(cCar),(cAliasTmp)->Ra_CARGO  ,cCar),(cAliasTmp)->R7_DATA,"C")//_FunCar(CMAT,(cAliasTmp)->Ra_CARGO,(cAliasTmp)->R7_DATA,"C")
        cDesFuncao:=substr(cDesFuncao,rat("-",cDesFuncao)+1,30)       
	else        

		If SQ3->(DBSEEK(XFILIAL("SQ3")+IIF(EMPTY(cCar),(cAliasTmp)->Ra_CARGO  ,cCar)))
			   cDes:= substr(SQ3->Q3_DESCSUM,1,30)
		else                       
			   cDes:= OemToAnsi(STR0012) + " " + cCar //"No encontre Cargo "
		ENDIF               

	    cDescCargo:=/*(cAliasTmp)->RA_CARGO +"-"+*/substr(cDes,1,30)
        cDesFuncao:=_FunCar(CMAT,IIF(EMPTY(cFN) ,(cAliasTmp)->Ra_CODFUNC,cFN),(cAliasTmp)->R7_DATA,"F")
        cDesFuncao:=substr(cDesFuncao,rat("-",cDesFuncao)+1,30)          
	endif	
    aadd(aDatosHisLab,{(cAliasTmp)->R7_DATA,;
    			 substr(cDesTM,rat("-",cDesTM)+1,30),;
    			 aSalario[1],;
    			 aSalario[2],;
    			 aSalario[3],;
    			 cDesLoc,;
    			 cDesCC,;     
    			 cDesDepto,;
    			 cDesFuncao,;
    			 cDescCargo,;
    			 cInd})
    			 
	(cAliasTmp)->(dbskip())
enddo	
(cAliasTmp)->(DbCloseArea())

RETURN 
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun??o    ³HISSALARIO³       ³ Gpe Santacruz         ³ Data ³03/03/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri??o ³ Extrae Salario Diario, diario integrado y Mensual          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³HISSALARIO(cPar01,dPar01)			                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cPar01 : Matricula del empleado                             ³±±
±±³          ³dPar01 : Fecha del movimiento                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³HISFUNCAR, HISDEPYCC, HISLOCP                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±/*/     
static function HISSALARIO(cMat,DfecMov)

Local aSal:={0,0,0,CTOD("//")}
Local cQryTmp:=''
Local cAliasTmp := CriaTrab(Nil,.F.)	

cQryTmp:="Select RCP_SALDIA,RCP_SALDII,RCP_SALMES, RCP_DTMOV FROM "
cQryTmp+=RETSQLNAME("RCP")+" RCP WHERE RCP_FILIAL='"+XFILIAL("RCP")+"' "
cQryTmp+=" AND RCP_MAT='"+CMAT+"' "
cQryTmp+=" AND RCP_DTMOV <= '"+DTOS(DFECMOV)+ "' "
If ( TcSrvType()=="AS/400" )

	cQryTmp+="     AND RCP.@DELETED@  = ' ' "                                                                     	
ELSE 

	cQryTmp+="     AND RCP.D_E_L_E_T_  = ' ' "                                                                     		
ENDIF                                                                                                                   
cQryTmp+=" ORDER BY RCP_DTMOV desc"
cQryTmp := ChangeQuery(cQryTmp)

DbUseArea( .T., 'TOPCONN', TCGENQRY(,, cQryTmp),cAliasTmp, .T., .T. )
TCSetField(cAliasTmp,"RCP_DTMOV","D")  


IF  !(cAliasTmp)->(eof())       
    aSal[1]:=(cAliasTmp)->RCP_SALDIA
    aSal[2]:=(cAliasTmp)->RCP_SALDII    
    aSal[3]:=(cAliasTmp)->RCP_SALMES
    aSal[4]:=(cAliasTmp)->RCP_DTMOV
ENDIF
(cAliasTmp)->(DBCLOSEAREA())
Return aSal                                
/*                                                                               
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao     ³_LocPag   ³ Autor ³ GSANTACRUZ           ³ Data ³ 04/03/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descripción³ Saca la descripción de la Localidad de Pago p/la Historia ³±± 
±±³           ³ Laboral 		                                          ³±± 
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU?AO INICIAL.             ³±±                
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³  /  /  ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

static function _LocPag(cmat,cKeyLoc)

Local cDesLoc:=''                                    
Local nTamCam:=TAMSX3("RA_KEYLOC")[1]
Local cFilSR9:=XFILIAL("SR9")  

DBSELECTAREA("RGC") 
RGC->(DBSETORDER(1))
DBSELECTAREA("SR9")
SR9->(DBSETORDER(1))// R9_FILIAL+R9_MAT+R9_CAMPO+DTOS(R9_DATA)     

IF SR9->(DBSEEK(XFILIAL("SR9")+CMAT+"RA_KEYLOC"))   
   DO WHILE SR9->(EOF()) .AND. (cFilSR9+CMAT+"RA_KEYLOC") ==SR9->R9_FILIA+SR9->R9_MAT+ SR9->R9_CAMPO
		cKeyLoc :=PADR(ALLTRIM(SR9->R9_DESC),NTAMCAM)
        SR9->(DBSKIP())
   ENDDO     		
ENDIF	                                

If RGC->(DBSEEK(XFILIAL("RGC")+cKeyLoc))
	   cDesLoc:=/*cKeyLoc+"-"+*/substr(RGC->RGC_DESLOC,1,30)
else                       
	   cDesLoc:= OemToAnsi(STR0013)+cKeyLoc //"No encontre Loc "
ENDIF
Return cDesLoc
/*                                                                               
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao     ³_CenCosDepto Autor³ GSANTACRUZ           ³ Data ³ 04/03/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descripción³ Saca la descripción del CC o Departamen para la Historia  ³±± 
±±³           ³ Laboral 		                                          ³±± 
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU?AO INICIAL.             ³±±                
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³  /  /  ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

static function _CenCosDepto(cmat,ccc,dFecMov,cTp,cTipo)

Local cDesCC:=''                                    

Local cFilSRE:=XFILIAL("SRE")
Local caliasTmp:= CriaTrab(Nil,.F.)	  
Local CQryCat:=''
Default cTipo:='  '
/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica si hay movimientos en el archivo de Transferencias (sre), ³
//³de ser asi, selecciona el 1ero de acuerdo a la fecha               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
cQryCat:="Select RE_CCP,RE_DEPTOP,RE_DEPTOD,RE_CCD, RE_DATA FROM "+RETSQLNAME("SRE")+" SRE WHERE RE_MATP='"+cmat+"' "
cQryCat+= " AND RE_DATA ='"+DTOS(dFecMov)+"' AND RE_FILIAL='"+cFilSRE+"' "
If ( TcSrvType()=="AS/400" )
   cQryCat	+= " AND SRE.@DELETED@"
ELSE
   cQryCat	+= " AND SRE.D_E_L_E_T_ = ' ' "
ENDIF         
CQryCat	+= " ORDER BY RE_DATA"
CQryCat := ChangeQuery(CQryCat)
DbUseArea( .T., 'TOPCONN', TCGENQRY(,, CQryCat),cAliasTMP, .T., .T. )
TCSetField(cAliasTMP,"RE_DATA","D")  

IF !(cAliasTMP)->(eof())
   if cTipo=='01' .OR. cTipo=='06'  //Ingreso o reingreso
	   if cTp=="C"
		   cCC:=(cAliasTMP)->RE_CCD 
	    ELSE                        
	   	   cCC:=(cAliasTMP)->RE_DEPTOD
	    ENDIF	               
    else
   	   if cTp=="C"
		   cCC:=(cAliasTMP)->RE_CCP 
	    ELSE                        
	   	   cCC:=(cAliasTMP)->RE_DEPTOP 
	    ENDIF	               
    endif
endIF
(cAliasTMP)->(dbclosearea())
IF cTp=="C"
	CTT->(DBSETORDER(1))
	If CTT->(DBSEEK(XFILIAL("CTT")+cCC))
		   cDesCC:=/*cCC+"-"+*/ substr(CTT->CTT_DESC01,1,30)
	else                       
		   cDesCC:= OemToAnsi(STR0014)+cCC //"No encontre CC "
	ENDIF               
ELSE 
	SQB->(DBSETORDER(1))
	If SQB->(DBSEEK(XFILIAL("SQB")+cCC))
		   cDesCC:=/*cCC+"-"+*/substr(SQB->QB_DESCRIC,1,30)
	else                       
		   cDesCC:="No encontre Depto "+cCC
	ENDIF               
ENDIF	
Return cDesCC


/*                                                                               
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao     ³_FunCar   ³ Autor ³ GSANTACRUZ           ³ Data ³ 04/03/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descripción³ Saca la descripción del Puesto o Cargo  para la Historia  ³±± 
±±³           ³ Laboral 		                                          ³±± 
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU?AO INICIAL.             ³±±                
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³  /  /  ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
static function _FunCar(cmat,cFun,dFecMov,cTp)

Local cDesFun:=''                                    
Local lHubo:= .f.
Local cFilSR7:=XFILIAL("SR7")
Local caliasTmp:= CriaTrab(Nil,.F.)	  
Local CQryCat:=''

cQryCat:="Select R7_FUNCAO, R7_DATA,R7_CARGO,R7_DESCFUN, R7_DESCCAR FROM "+RETSQLNAME("SR7")+" SR7 WHERE R7_MAT='"+cmat+"' "
cQryCat+= " AND R7_DATA ='"+DTOS(dFecMov)+"' AND R7_FILIAL='"+cFilSR7+"' "
If ( TcSrvType()=="AS/400" )
   cQryCat	+= " AND SR7.@DELETED@"
ELSE
   cQryCat	+= " AND SR7.D_E_L_E_T_ = ' ' "
ENDIF         
CQryCat	+= " ORDER BY R7_DATA"
CQryCat := ChangeQuery(CQryCat)
DbUseArea( .T., 'TOPCONN', TCGENQRY(,, CQryCat),cAliasTMP, .T., .T. )
TCSetField(cAliasTMP,"R7_DATA","D")  

IF !(cAliasTMP)->(eof())
	lHubo:= .t.
	IF cTp=="F"
	   cFun:=(cAliasTMP)->R7_funcao
	   cDesFun:=/*cFun+"-"+*/substr((cAliasTMP)->R7_DESCFUN,1,30)
	else                          
	   cFun:=(cAliasTMP)->R7_cargo              
   	   cDesFun:=/*cFun+"-"+*/substr((cAliasTMP)->R7_DESCCAR,1,30)
	endif   

endIF
(cAliasTMP)->(dbclosearea())
if !lHubo
	IF cTp=="F"
		srj->(DBSETORDER(1))
		If srj->(DBSEEK(XFILIAL("SRJ")+cFun))
			   cDesFun:=/*cFun+"-"+*/ substr(srj->RJ_DESC,1,30)
		else                       
			   cDesFun:= OemToAnsi(STR0015)+cfUN //"No encontre Función "
		ENDIF               
	else                    
		sq3->(DBSETORDER(1))
		If SQ3->(DBSEEK(XFILIAL("SQ3")+cFun))
			   cDesFun:=/*cFun+"-"+*/ substr(SQ3->Q3_DESCSUM,1,30)
		else                       
			   cDesFun:= OemToAnsi(STR0016)+alltrim(cfUN) //"No encontre Cargo "
		ENDIF               
	endif	 
endif
Return cDesFun
/*............................TERMINA FUNCIONES PARA LA HISTORIA LABORAL .......................................*/

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun??o    ³PN9EXTPRES³       ³ Gpe Santacruz         ³ Data ³03/03/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri??o ³ Extrae los prestamos de los empleados                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³PN9EXTPRES(cPar01,cPar02,cPar03,lPar01,cPar04)              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cPar01: Matricula inicial.                                  ³±±
±±³          ³cPar02: Matricula final.                                    ³±±
±±³          ³cPar03: Matricula del supervisor.                           ³±±
±±³          ³cPar04: Filtro sobre el query principal                     ³±±
±±³          ³lPar01: .t. Solo activos , .f. Todos                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³PNOM009                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±/*/     

user function PN9EXTPRES(cMat1,cMat2,CMATSUP,lTodos,cFiltro)
/*Retorna una arreglo con los prestamos*/


Local CQryCat:=''
Local aPrestamos  :={}
Local cFilSRK:=XFILIAL("SRK") 
Local cFilSRA:=XFILIAL("SRA") 
Local cAliasTmp := CriaTrab(Nil,.F.)	
Local aDesTipo:={OemToAnsi(STR0017),OemToAnsi(STR0018),OemToAnsi(STR0019),OemToAnsi(STR0020)," "}//"Solicitado","Activo","Pagado","Suspendido"
Default cFiltro:=''
Default lTodos:= .f.  

/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Contenido de aPrestamos:                      													 ³
//³1.Matricula           													                         ³
//³2.Nombre (ra_nome) .- Nombre del empleado.         												 ³
//³3.Vlr. Princip (rk_valorto) .- Valor inicial del préstamo.               						 ³
//³4.Val cuota (rk_valorpa) .- Valor de  cada pago.    												 ³
//³5.Fc. Prox. Venc (rk_dtvenc) .- Fecha del próximo vencimiento.        					         ³
//³6.No. Cuotas (rk_parcela) .- Numero de pagos que deberá realizar.								 ³
//³7.Situación (rk_status) .- Status del préstamo,  1-Solicitado, 2-Activo, 3-Pagado, 4-Suspendido   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

cQryCat:="Select RK_NUMID,RK_MAT, RA_NOME,RK_VALORTO,RK_VLSALDO,RK_VALORPA, RK_DTVENC, RK_PARCELA, RK_PARCPAG, RK_STATUS, RK_DTMOVI FROM "+RETSQLNAME("SRK")+" SRK, "+RETSQLNAME("SRA")+" SRA "
cQryCat+= " WHERE RK_MAT>='"+cmat1+"'  AND RK_MAT<='"+CMAT2+"' "
IF lTodos  // si se hace desde el Control del supervisor
	cQryCat+= " AND RK_STATUS IN ('1','2') AND RA_SUPERVI='"+CMATSUP+"' and RK_VLSALDO<>0 "
endif	
cQryCat+= " AND RK_FILIAL='"+cFilSRK+"' AND RK_MAT=RA_MAT "
cQryCat+= " AND RA_FILIAL='"+CFILSRA+"' "
If ( TcSrvType()=="AS/400" )
   cQryCat	+= " AND SRK.@DELETED@"
   cQryCat	+= " AND SRA.@DELETED@"   
ELSE
   cQryCat	+= " AND SRK.D_E_L_E_T_ = ' ' "
   cQryCat	+= " AND SRA.D_E_L_E_T_ = ' ' "   
ENDIF              
if !empty(cFiltro)  
	cQryCat	+= " AND " + cFiltro 
endif
CQryCat	+= " ORDER BY RK_MAT"
CQryCat := ChangeQuery(CQryCat)
DbUseArea( .T., 'TOPCONN', TCGENQRY(,, CQryCat),cAliasTMP, .T., .T. )
TCSetField(cAliasTMP,"RK_DTVENC","D")  
TCSetField(cAliasTMP,"RK_DTMOVI","D")  

do while !(cAliasTMP)->(eof())
if !empty(cmatsup)
	AADD(aPrestamos,{   (cAliasTMP)->RK_MAT,;
						(cAliasTMP)->RA_NOME,;
						(cAliasTMP)->RK_VALORTO,;
						(cAliasTMP)->RK_VLSALDO,;
						(cAliasTMP)->RK_VALORPA,;
						(cAliasTMP)->RK_DTVENC,;
						(cAliasTMP)->RK_PARCELA,;
						(cAliasTMP)->RK_PARCPAG,;					
						aDesTipo[   IF (EMPTY((cAliasTMP)->RK_STATUS),5,VAL((cAliasTMP)->RK_STATUS))      ] }    )
else
	AADD(aPrestamos,{   (cAliasTMP)->RK_MAT,;
						(cAliasTMP)->RA_NOME,;
						(cAliasTMP)->RK_VALORTO,;
						(cAliasTMP)->RK_VLSALDO,;
						(cAliasTMP)->RK_VALORPA,;
						(cAliasTMP)->RK_DTVENC,;
						(cAliasTMP)->RK_PARCELA,;
						(cAliasTMP)->RK_PARCPAG,;					
						aDesTipo[   IF (EMPTY((cAliasTMP)->RK_STATUS),5,VAL((cAliasTMP)->RK_STATUS))      ],;
						 (cAliasTMP)->RK_NUMID,;
						 (cAliasTMP)->RK_DTMOVI} )

endif

	(cAliasTMP)->(dbskip())
enddo
(cAliasTMP)->(dbclosearea())

return aPrestamos                 
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun??o    ³PN9EXTVAC ³       ³ Gpe Santacruz         ³ Data ³10/03/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri??o ³ Extrae las vacaciones del empleado                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³PN9EXTVAC (cPar01)                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cPar01: Matricula del empleado.                             ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³PNOM009                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±/*/     

user function PN9EXTVAC(cMat1)
/*Retorna una arreglo con las VACACIONES*/

Local cLisVac:=Supergetmv("PT_CONVAC",.f.,,) //concepto de vacaciones 	en SR8 y SRF
Local cVacPag:=SupergetMV("PT_VACPAG",.f.,,)  //para buscar en SRC y SRD
Local aVacaciones  :={}
Local aVacac       :={}
Local nSaldo:=0
Local nsalAnt:=0
Local ni:=0

/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Contenido de aVacac      ³
//³                         ³
//³1.Tipo de registro:      ³
//³       1.dias derecho    ³
//³       2.dias programado ³
//³       3.dias disfrutado ³
//³       4.dias pagado     ³
//³2.Fecha de inicio        ³
//³3.Fecha de fin           ³
//³4.Dias derecho           ³
//³5.Dias dusfrutados       ³
//³6.Dias programados       ³
//³7.Días Pagados           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

aVacac:= ObtVaciones(1,cMat1,cLisVac,cVacPag)    //Obtener los registros de vacaciones(SRF,SR8,SRC y SRD) 
/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Contenido de aVacaciones ³
//³                         ³
//³1.Desc del Concepto      ³
//³2.Fecha de inicio        ³
//³3.Fecha de fin           ³
//³4.Dias derecho           ³
//³5.Dias disfrutados       ³
//³6.Dias programados       ³
//³7.Días Pagados           ³
//³8.Días Saldo             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

aVacac:= aSort(aVacac ,,, { |x,y| CTOD(x[3]) <= CTOD(y[3]) })
                            

nSaldo:=0

for ni:=1 to len(aVacac)
   	If !(aVacac[ni,4]==0 .And. aVacac[ni,5]==0 .And.aVacac[ni,6]==0  .And. aVacac[ni,7]==0 )
		do case
		   case aVacac[ni,1]==1
				cDesc:= OemToAnsi(STR0021) //"Días derecho"  
				nSaldo+=aVacac[ni,4]
				aadd(aVacaciones,{cDesc,;
						   aVacac[ni,2],; //Fecha inicio
						   aVacac[ni,3],;//Fecha fin
						   aVacac[ni,4],;//Días Derecho
						   aVacac[ni,5],;//Días Programados
						   aVacac[ni,6],;//Días Disfrutados
						   aVacac[ni,6],;//Días Pagados
						   nsaldo})    
		   case aVacac[ni,1]==2 
			   if aVacac[ni,4]==0         
					cDesc:= OemToAnsi(STR0022) //"Días programados"
					nSaldo:=nsaldo-aVacac[ni,4]-aVacac[ni,5]
					aadd(aVacaciones,{cDesc,;
						  aVacac[ni,2],; //Fecha inicio
						  aVacac[ni,3],;//Fecha fin
						  aVacac[ni,6],;//Días Derecho
						  aVacac[ni,4],;//Días Programados
						  aVacac[ni,5],;//Días Disfrutados
						  aVacac[ni,6],;//Días Pagados
						  nsaldo})    
			   else
					cDesc:= OemToAnsi(STR0023) //"Días disfrutados"
					nSaldo:=nsaldo-aVacac[ni,4]-aVacac[ni,5]
					aadd(aVacaciones,{cDesc,;
						  aVacac[ni,2],; //Fecha inicio
						  aVacac[ni,3],;//Fecha fin
						  aVacac[ni,6],;//Días Derecho
						  aVacac[ni,4],;//Días Programados
						  aVacac[ni,5],;//Días Disfrutados
						  aVacac[ni,6] ,;//Días Pagados
						  nsaldo})    
			   endif  
		   case aVacac[ni,1]>=3
			 cDesc:= OemToAnsi(STR0024) //"Días pagado"     
					nSaldo:=nsaldo-aVacac[ni,6]
					aadd(aVacaciones,{cDesc,;
						  aVacac[ni,2],; //Fecha inicio
						  aVacac[ni,3],;//Fecha fin
						  aVacac[ni,4],;//Días Derecho
						  aVacac[ni,4],;//Días Programados
						  aVacac[ni,4],;//Días Disfrutados
						  aVacac[ni,6] ,;//Días Pagados
						  nsaldo})    
		endcase
 	EndIf

next
return aVacaciones                 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao     ³ ObtVaciones³ Autor ³ Laura Medina       ³ Data ³ 19/12/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descripción³ Función para obtener los registros correspondientes a las ³±± 
±±³           ³ vacaciones.                                               ³±± 
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxis   ³ ObtVaciones()                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ObtVaciones(nOrden,cMat1,cConVac,cVacPag)
           
Local aSRF_8Vacac:= {}
Local aSRD_CVacac:= {}
Local nloop      := 0    

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Variables de control de acceso a usuarios.                   ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Local cFilSRA:= xfilial("SRA")  
Local cFilSRF:= xfilial("SRF")
Local cFilSR8:= xfilial("SR8")
Local cFilSRC:= xfilial("SRC")
Local cFilSRD:= xfilial("SRD")
Local nRegPos:=0
cSucini  := XFILIAL("SRA")
cSucFin  := XFILIAL("SRA")
cMatIni  := cMat1
cMatFin  := cMat1


cConcep  := cConVac

dFecha   := ctod("01/01/80")
     

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicia con el DE Filial + De Matricula                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea( "SRF" )
SRF->(dbSetOrder(RetOrdem("SRF","RF_FILIAL+RF_MAT+RF_PD+DTOS(RF_DATABAS)")))
dbSelectArea( "SR8" )
SR8->(dbSetOrder(RetOrdem("SR8","R8_FILIAL+R8_MAT+R8_PD")))  //NUEVO INDICE
dbSelectArea( "SRC" )
SRC->(dbSetOrder(RetOrdem("SRC","RC_FILIAL+RC_MAT+RC_PD+RC_CC+RC_SEMANA+RC_SEQ")))
dbSelectArea( "SRD" )
SRD->(dbSetOrder(RetOrdem("SRD","RD_FILIAL+RD_MAT+RD_PD+RD_ROTEIR+DTOS(RD_DATPGT)"))) 
dbSelectArea( "SRA" )
SRA->(dbSetOrder(RetOrdem("SRA","RA_FILIAL+RA_MAT")))
SRA->(dbSeek(cFILSRA+cMatIni,.T.))


dbSelectArea( "SRA" )
Begin Sequence     
	While SRA->(!EOF())   
                                     
		If  SRA->(Eof()) .Or. (cFILSRA+SRA->RA_MAT > cFILSRA+cMatFin)
			Exit
		Endif
		
		//OBTENER DIAS DERECHO(SRF)  *****          

		dbSelectArea( "SRF" )
		SRF->(dbSeek(cFILSRF+SRA->RA_MAT+cConcep))
		While SRF->(!EOF()) .And. SRF->RF_FILIAL+SRF->RF_MAT+SRF->RF_PD==cFILSRF+SRA->RA_MAT+cConcep

			
	      	If  YEAR(SRF->RF_DATABAS) <= YEAR(DDATABASE)
		      	aAdd(aSRF_8Vacac,{1,;
		                       DTOC(SRF->RF_DATABAS),; 
		                       DTOC(SRF->RF_DATAFIM),;
		                       SRF->RF_DFERVAT,;  
		                       0,;
		                       0,;
		                       0})
  	        Endif 
	        dbSelectArea("SRF")                         
			SRF->(dbSkip())
        Enddo    
        
        //OBTENER DIAS PROGRAMADOS Y DISFRUTADOS(SR8) *****

		dbSelectArea( "SR8" )   //("SR8","R8_FILIAL+R8_MAT+R8_PD")
		SR8->(dbSeek(cFILSR8+SRA->RA_MAT+cConcep))
		While SR8->(!EOF()) .And. SR8->R8_FILIAL+SR8->R8_MAT+SR8->R8_PD==cFILSR8+SRA->RA_MAT+cConcep


	      	aAdd(aSRF_8Vacac,{2,;
		                    DTOC(SR8->R8_DATAINI),; 
		                    DTOC(SR8->R8_DATAFIM),;
		                    SR8->R8_DURACAO-SR8->R8_SDPAGAR,;  
		                    SR8->R8_SDPAGAR,;
		                    0,;
		                    0})  

	        dbSelectArea("SR8")                         
			SR8->(dbSkip())
        Enddo    
        
        //OBTENER DIAS PAGADOS (SRC) *****

		dbSelectArea( "SRC" )   //("SRC","RC_FILIAL+RC_MAT+RC_PD")

		SRC->(dbSeek(cFILSRC+SRA->RA_MAT+cVacPag))

		If nregpos>0 
			    SRC->(DBGOTO(NREGPOS))
		endif
		dbSelectArea( "SRC" )
				
		While SRC->(!EOF()) .And. SRC->RC_FILIAL+SRC->RC_MAT+SRC->RC_PD==cFILSRc+SRA->RA_MAT+cVacPag//cConcep

			If  Empty(SRC->RC_NUMID)
		      	aAdd(aSRD_CVacac,{3,;
			                    DTOC(SRC->RC_DTREF),; 
			                    DTOC(SRC->RC_DTREF),; //"  /  /  ",;
			                    0,;  
			                    0,;
			                    SRC->RC_HORAS,;
			                    0})   
			Endif

	        dbSelectArea("SRC")                         
			SRC->(dbSkip())
        Enddo       
		
		//OBTENER DIAS PAGADOS (SRD) *****              
		dbSelectArea( "SRD" )   //("SRD","RD_FILIAL+RD_MAT+RD_PD")

		SRD->(dbSeek(cFILSRd+SRA->RA_MAT+cVacPag))
		If nregpos>0 
			    SRD->(DBGOTO(NREGPOS))
		endif
		dbSelectArea( "SRD" )

		While SRD->(!EOF()) .And. SRD->RD_FILIAL+SRD->RD_MAT+SRD->RD_PD==cfilsrd+SRA->RA_MAT+cVacPag//cConcep		
			If  Empty(SRD->RD_NUMID)
		      	aAdd(aSRD_CVacac,{4,;
			                    DTOC(SRD->RD_DTREF),; 
			                    DTOC(SRD->RD_DTREF),;//"  /  /  ",;
			                    0,;  
			                    0,;
			                    SRD->RD_HORAS,;
			                    0})   
			Endif

	        dbSelectArea("SRD")                         
			SRD->(dbSkip())
        Enddo  
		       
		dbSelectArea("SRA")                         
		SRA->(dbSkip())
	Enddo  
End Sequence

For  nloop:=1 to len(aSRD_CVacac)  
	 aAdd(aSRF_8Vacac,aSRD_CVacac[nloop])
Next nloop 


Return aSRF_8Vacac

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun??o    ³PN9EXTAUS ³       ³ Gpe Santacruz         ³ Data ³09/03/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri??o ³ Extrae las ausencias del empleado                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³PN9EXTPRES(cPar01,lPar01,cPar02)                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cPar01: Matricula inicial.                                  ³±±
±±³          ³lPar01: .t. Solo activos , .f. Todos                        ³±±
±±³          ³cPar02: string del filtro                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³PNOM009                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±/*/     

user function PN9EXTAUS(cMat1,lTodos,cFiltro)
/*Retorna una arreglo con las usencias*/


Local CQryCat:=''
Local aAusencias  :={}
Local cFilSR8:=XFILIAL("SR8") 
Local cFilSRV:=XFILIAL("SRV") 
Local cFilRCM:=XFILIAL("RCM") 
Local cAliasTmp := CriaTrab(Nil,.F.)	
Local aDesTipo:={OemToAnsi(STR0025),OemToAnsi(STR0026),OemToAnsi(STR0027)," "}  //"Accidente de Trabajo","Accidente en Trayecto","Enfermedad de Trabajo"

Default cFiltro:=''
Default lTodos:= .f.  

/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Contenido de aAusencias:                      													 ³
//³1.Concepto (r8_pd_rv_desc) .- Código               del concepto de ausencia.         													                         ³
//³2.Desc Con (rv_desc) .- descripción del concepto de ausencia.    												 ³
//³3.Fch Inicio (r8_dataini).- Fecha de inicio de la ausencia.              						 ³
//³4.Fch Fin (r8_dtfim) .- Fecha final de la ausencia.   												 ³
//³5.Días (r8_duracao) .- Numero de días de ausencia.       					         ³
//³6.Tipo (r8_tiporsc).- Descripción del tipo de ausencia (x3_relacao).								 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
DBSELECTAREA("SR8")
cQryCat:="Select R8_PD, RV_DESC,R8_DATAINI,R8_DATAFIM,R8_DURACAO, R8_TIPORSC FROM "+RETSQLNAME("SR8")+" SR8, "+RETSQLNAME("SRV")+" SRV, "+RETSQLNAME("RCM")+" RCM "
cQryCat+= " WHERE R8_MAT='"+cmat1+"'  "
cQryCat+= " AND R8_TIPOAFA=RCM_TIPO AND   RCM_TPIMSS IN('1','2') "
cQryCat+= " AND R8_FILIAL='"+cFilSR8+"' AND R8_PD=RV_COD "
cQryCat+= " AND RV_FILIAL='"+CFILSRV+"' "
cQryCat+= " AND RCM_FILIAL='"+CFILRCM+"' "
If ( TcSrvType()=="AS/400" )
   cQryCat	+= " AND SR8.@DELETED@"
   cQryCat	+= " AND SRV.@DELETED@"   
   cQryCat	+= " AND RCM.@DELETED@"      
ELSE
   cQryCat	+= " AND SR8.D_E_L_E_T_ = ' ' "
   cQryCat	+= " AND SRV.D_E_L_E_T_ = ' ' "   
   cQryCat	+= " AND RCM.D_E_L_E_T_ = ' ' "      
ENDIF              
if !empty(cFiltro)  
	cQryCat	+= " AND " + cFiltro 
endif
CQryCat	+= " ORDER BY R8_DATAINI"
CQryCat := ChangeQuery(CQryCat)
DbUseArea( .T., 'TOPCONN', TCGENQRY(,, CQryCat),cAliasTMP, .T., .T. )
TCSetField(cAliasTMP,"R8_DATAINI","D")  
TCSetField(cAliasTMP,"R8_DATAFIM","D")  

do while !(cAliasTMP)->(eof())
   AADD(aAusencias,{(cAliasTMP)->R8_PD,;
					(cAliasTMP)->RV_DESC,;
					(cAliasTMP)->R8_DATAINI,;
					(cAliasTMP)->R8_DATAFIM,;
					(cAliasTMP)->R8_DURACAO,;
					aDesTipo[   IF (EMPTY((cAliasTMP)->R8_TIPORSC),4,VAL((cAliasTMP)->R8_TIPORSC))      ] }    )

   (cAliasTMP)->(dbskip())
enddo
(cAliasTMP)->(dbclosearea())

return aAusencias                 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun??o    ³PN9AMORT  ³       ³ Gpe Santacruz         ³ Data ³22/03/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri??o ³ Extrae las amortizaciones por prestamo                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³PN9AMORT(cPar01,cPar02)                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cPar01: ID del prestamosones                                ³±±
±±³          ³cPar02: Matricula del empleado.                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³PNOM009                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±/*/     

user function PN9AMORT(cFilSel,cMat,cIDpres)
/*Retorna una arreglo con los prestamos*/


Local CQryCat:=''
Local aAmortiza :={}
Local cFilRCK:=XFILIAL("RCK") 
Local cFilSRV:=XFILIAL("SRV")
Local cAliasTmp := CriaTrab(Nil,.F.)	      
Local cDesPd:=''
dbselectarea("SRK")
dbselectarea("RCK")



cQryCat:="Select RCK_pd, RV_DESC,rck_dtpago,rck_vlpago FROM "+RETSQLNAME("RCK")+" RCK, "+RETSQLNAME("SRV")+" SRV "
cQryCat+= " WHERE RCK_NUMID='"+cidpres+"'  AND RCK_PD = RV_COD AND RCK_MAT='"+CMAT+"' "
cQryCat+= " AND RCK_FILIAL='"+cFilRCK+"' "
cQryCat+= " AND RV_FILIAL='"+CFILSRV+"' "
If ( TcSrvType()=="AS/400" )
   cQryCat	+= " AND RCK.@DELETED@"
   cQryCat	+= " AND SRV.@DELETED@"   
ELSE
   cQryCat	+= " AND RCK.D_E_L_E_T_ = ' ' "
   cQryCat	+= " AND SRV.D_E_L_E_T_ = ' ' "   
ENDIF              
CQryCat	+= " ORDER BY RCK_DTpago"
CQryCat := ChangeQuery(CQryCat)
DbUseArea( .T., 'TOPCONN', TCGENQRY(,, CQryCat),cAliasTMP, .T., .T. )

TCSetField(cAliasTMP,"RCK_DTPAGO","D")  
SRV->(DBSETORDER(1)) 
SRK->(DBSETORDER(2)) //RK_FILIAL+RK_MAT+RK_NUMID
IF SRK->(DBSEEK(XFILIAL("SRK")+CMAT+cidpres))
   IF SRV->(DBSEEK(CFILSRV+SRK->RK_PD))
	   cdespd:=SRV->RV_DESC
   ENDIF     
   AADD(aAmortiza,{SRK->RK_PD,;
					cdespd,;
					SRK->RK_DTMOVI,;					
					0,;
						SRK->rk_valorto	})
ENDIF
do while !(cAliasTMP)->(eof())
	IF (cAliasTMP)->rck_vlpago<>0
		AADD(aAmortiza,{   (cAliasTMP)->RCK_PD,;
						(cAliasTMP)->RV_DESC,;
						(cAliasTMP)->RCK_DTPAGO,;					
						(cAliasTMP)->rck_vlpago,;
						0}    )
	ENDIF					
	(cAliasTMP)->(dbskip())
enddo
(cAliasTMP)->(dbclosearea())

return aAmortiza                

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun??o    ³PN9EnvMail³       ³ Gpe Santacruz         ³ Data ³03/03/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri??o ³ Envio de correo                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³PN9EnvMail(cPar01,cPar02,cPar03,lPar01)                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±³          ³cPar01: Descripción del asunto                              ³±±
±±³          ³cPar02: Descripción del contenido                           ³±±
±±³          ³cPar03: Direccion de mail de quien envia                    ³±±
±±³          ³lPar01: .t. Si es ejecutado por JOB, .F. No ejecutado por Jb³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³PNOM009                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±/*/     



user  function PN9EnvMail(cAssunto,cMensaje,ceMail,cMailSup,lworkflow) 
Local oMailServer := Nil
Local oMessage
Local cEmailTo := ""
Local cEmailBcc:= ""
//Local lResult  := .F.
Local cError   := ""  
Local cEMailAst:= cAssunto

// Verifica se serao utilizados os valores padrao.
Local cAccount	:= GetMV( "MV_RELACNT",,"" )
Local cPassword	:= GetMV( "MV_RELPSW",,""  )
Local cServer	:= GetMV( "MV_RELSERV",,"" ) //smtp.microsiga.com.br
Local cAttach 	:= ""
Local cFrom		:= cAccount
Local nPosMas	:= At(Chr(59),cEmail)
Local lUseSSL  	:= GetMv("MV_RELSSL")	//Define se o envio e recebimento de E-Mail na rotina SPED utilizara conexao segura (SSL);              
Local lUseTLS	:= GetMv("MV_RELTLS")	//Define se o envio e recebimento de E-Mail na rotina SPED utilizara conexao segura (SSL);
Local lAuth    	:= GetMv("MV_RELAUTH")	//Servidor de E-Mail necessita de Autenticacao? Determina se o Servidor necessita de Autenticacao;
Local nPort		:= GetMv("MV_SRVPORT")
Local cAcAut	:= GetMV("MV_RELAUSR",,"" )
Local nI			:= 0 
Local nAuxPos := At(":", cServer)
DEFAULT lworkflow:= .F.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Envia o e-mail para a lista selecionada. Envia como BCC para que a pessoa pense³
//³que somente ela recebeu aquele email, tornando o email mais personalizado.     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nAuxPos <> 0
	cServer := Substr(cServer, 1 , nAuxPos - 1)
EndIf
If nPosMas == 0
	cEmailTo := cEmail
Else
	cEmailTo := SubStr(cEmail,1,nPosMas-1)
	cEmailBcc:= SubStr(cEmail,nPosMas+1,Len(cEmail))
Endif

	If !lAuth 

		CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lResult
		
		If lResult
			SEND MAIL FROM cFrom ;
			TO      	cEmailTo;
			BCC     	cEmailBcc;
			SUBJECT 	Txt2Htm( cEMailAst, cEmail );
			BODY    	Txt2Htm( cMensaje, cEmail );
			ATTACHMENT  cAttach  ;
			RESULT lResult
			
			If !lResult
				//Erro no envio do email
				GET MAIL ERROR cError
				IF !lworkflow
					Help(" ",1,"ATENCION",,cError,4,5)
				ELSE 
		//		    CONOUT ("Error: "+cError)
				ENDIF	
			EndIf
			
			DISCONNECT SMTP SERVER
			
		Else
			//Erro na conexao com o SMTP Server
			GET MAIL ERROR cError
			IF !lworkflow
				Help(" ",1,"ATENCION",,cError,4,5)
			else       
		//		CONOUT ("Error: "+cError)
			endif	
		EndIf
		DISCONNECT SMTP SERVER
	Else
	//Instancia o objeto do MailServer
			oMailServer:= TMailManager():New()
			oMailServer:SetUseSSL(lUseSSL)				//Obs: Apenas se servidor de e-mail utiliza autenticacao SSL para envio
			oMailServer:SetUseTLS(lUseTLS) 				//Obs: Apenas se servidor de e-mail utiliza autenticacao TLS para recebimento
			oMailServer:Init("",cServer,cAccount,cPassword,60,nPort)
			
				//Definição do timeout do servidor
		   	If oMailServer:SetSmtpTimeOut(60) != 0
		   		//Help(" ",1,STR0171,,STR0172 ,4,5)
		        Return .F.
		    EndIf
	
		    //Conexão com servidor
		    nErr := oMailServer:smtpConnect()
			If nErr <> 0
				//Help(" ",1,STR0171,,oMailServer:getErrorString(nErr),4,5)
				oMailServer:smtpDisconnect()
				Return .F.
			EndIf
			
			//Autenticação com servidor smtp
			nErr := oMailServer:smtpAuth(cAcAut, cPassword)
			If nErr <> 0
				//Help(" ",1,STR0171,,STR0173 + oMailServer:getErrorString(nErr),4,5)
				oMailServer:smtpDisconnect()
				return .F.
			EndIf
			
			//Cria objeto da mensagem+
			oMessage := tMailMessage():new()
			oMessage:clear()
			oMessage:cFrom := cFrom 
			oMessage:cTo := cMailSup 
			oMessage:cCc := cEmail
			oMessage:cSubject :=  cEMailAst
		
			oMessage:cBody := cMensaje
	
			
			//Dispara o email	
			nErr := oMessage:send(oMailServer)
			If nErr <> 0
				//Help(" ",1,STR0171,,STR0174 + oMailServer:getErrorString(nErr),4,5)
				oMailServer:smtpDisconnect()
				Return .F.
			Else
				
				lResult := .T.
			EndIf
			
			//Desconecta do servidor
			oMailServer:smtpDisconnect()   
		
	End IF
Return(lResult)    

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun??o    ³Txt2Htm   ³       ³ Gpe Santacruz         ³ Data ³03/03/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri??o ³ Convierte a HTML el contenido del correo                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³PN9EnvMail(cPar01)                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±³          ³cPar01: Descripción del contenido del mail                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³PN9EnvMail                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±/*/     
STATIC Function Txt2Htm( cText )

// ::: CRASE
// aA (acento crase)
cText := STRTRAN(cText,CHR(224), "&agrave;")
cText := STRTRAN(cText,CHR(192), "&Agrave;")

// ::: ACENTO CIRCUNFLEXO
// aA (acento circunflexo)
cText := STRTRAN(cText,CHR(226), "&acirc;")
cText := STRTRAN(cText,CHR(194), "&Acirc;")
// eE (acento circunflexo)
cText := STRTRAN(cText,CHR(234), "&ecirc;")
cText := STRTRAN(cText,CHR(202), "&Ecirc;")
// oO (acento circunflexo)
cText := STRTRAN(cText,CHR(244), "&ocirc;")
cText := STRTRAN(cText,CHR(212), "&Ocirc;")

// ::: TIL
// aA (til)
cText := STRTRAN(cText,CHR(227), "&atilde;")
cText := STRTRAN(cText,CHR(195), "&Atilde;")
// oO (til)
cText := STRTRAN(cText,CHR(245), "&otilde;")
cText := STRTRAN(cText,CHR(213), "&Otilde;")

// ::: CEDILHA
cText := STRTRAN(cText,CHR(231), "&ccedil;")
cText := STRTRAN(cText,CHR(199), "&Ccedil;")

// ::: ACENTO AGUDO
// aA (acento agudo)
cText := STRTRAN(cText,CHR(225), "&aacute;")
cText := STRTRAN(cText,CHR(193), "&Aacute;")

// eE (acento agudo)
cText := STRTRAN(cText,CHR(233), "&eacute;")
cText := STRTRAN(cText,CHR(201), "&Eacute;")

// iI (acento agudo)
cText := STRTRAN(cText,CHR(237), "&iacute;")
cText := STRTRAN(cText,CHR(205), "&Iacute;")

// oO (acento agudo)
cText := STRTRAN(cText,CHR(243), "&oacute;")
cText := STRTRAN(cText,CHR(211), "&Oacute;")

// uU (acento agudo)
cText := STRTRAN(cText,CHR(250), "&uacute;")
cText := STRTRAN(cText,CHR(218), "&Uacute;")

// ::: ENTER
cText := STRTRAN(cText,CHR(13)+CHR(10), "<br>")
cText := STRTRAN(cText,CHR(13), "<br>")
cText := STRTRAN(cText,CHR(10), "<br>")

Return cText  




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GETFILIAL ºAutor  ³M.Camargo           ºFecha ³  03/19/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Obtiene del sigamat el número de filial y nombre retrnando  º±±
±±º          ³una cadena XML                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WSPTALNOM 						                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GetFilial()
	Local _cXML := ""
	
	DBSELECTAREA("SM0")  
	DBSETORDER(1)
	_cXML :="<?xml version='1.0'?>"
	_cXML +='<Filiales>'  
	SM0->(DBGOTOP())
	WHILE SM0->(!eof())   
			_cXML += '<filial id="'+ alltrim(SM0->M0_CODIGO) + "/" + alltrim(SM0->M0_CODFIL) +'" nombre="' + alltrim(SM0->M0_NOME)+"/" + alltrim(SM0->M0_FILIAL)+'"/>'
	
		SM0->(dbskip())
	END DO      
    _cXML+="</Filiales>"    
Return  _cXML   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PN9EXTFEC ºAutor  ³M.Camargo           ºFecha ³  03/19/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Obtiene las fechas de entrega de los recibos de nómina      º±±
±±º          ³					                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WSPTALNOM 						                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                           

USER FUNCTION PN9EXTFEC(cMat,cFilEmp)
	Local aExtFec 	:= {}
	Local cQuery  	:= ""
	Local cSRD	  	:= ""
	Local cRCH	  	:= ""
	Local cAliasTmp := CriaTrab(Nil,.F.)   
	Local cTipNom	:= getRoteir() 
	                 
	/*
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Contenido de aExtCon:                      													 	 ³
	//³1.RD_DTREF formato YYYYMMDD												                         ³
	//³2.RD_DTREF Formato DD/MM/YY																		 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	*/
	
	cSRD := RETSQLNAME("SRD")
	cRCH := RETSQLNAME("RCH")
	
	cQuery += "SELECT "
	cQuery += "DISTINCT(RD_DATPGT) as RD_DTREF,RD_PERIODO,RD_SEMANA,RD_PROCES "
	cQuery += "FROM "	
	cQuery += cSRD + " SRD,"
	cQuery += cRCH + " RCH "
	cQuery += "WHERE "	
	cQuery += "RD_FILIAL='"  + XFILIAL("SRD") + "' AND "
	cQuery += "RCH_FILIAL='" + XFILIAL("RCH") + "' AND "
	cQuery += "RD_PERIODO=RCH_PER   AND "
	cQuery += "RD_SEMANA=RCH_NUMPAG AND "  
	cQuery += "RD_MAT='" + cMat + "' AND "
	cQuery += "RCH_ROTEIR='"+cTipNom+"' AND "
	cQuery += "RD_ROTEIR='"+cTipNom+"' AND "
	cQuery += "RCH_DTFECH<>' ' AND "
	cQuery += "(RCH_DTFECH < '20140101' OR (RCH_DTFECH > '20140101' AND RCH_STATUS='6')) AND "
	cQuery += "RCH.D_E_L_E_T_=' ' AND "
	cQuery += "SRD.D_E_L_E_T_=' ' "
	cQuery += "ORDER BY RD_DATPGT"
		
	cQuery := ChangeQuery(cQuery)    
	
	DbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery),cAliasTMP, .T., .T. )
	TCSetField(cAliasTMP,"RD_DTREF","D")  
	
	Do While !(cAliasTmp)->(EOF())      
	
		AADD(aExtFec,{(cAliasTmp)->RD_PERIODO+(cAliasTmp)->RD_SEMANA+(cAliasTmp)->RD_PROCES,DTOC((cAliasTmp)->RD_DTREF)})
		(cAliasTmp)->(dbSkip())		                                        
		                             
	End do
	(cAliasTmp)->(dbclosearea())
		
Return aExtFec	



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun??o    ³PN3EXTCON ³       ³ Gpe Santacruz         ³ Data ³03/03/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri??o ³ Consulta de Conceptos para estado de cuenta del empleado   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³PN3EXTCON (cPar01,cPar02)                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cPar01: Sucursal del empleado						          ³±±
±±³          ³cPar02: Matricula del empleado.							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³WSPTALNOM                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±/*/    


USER FUNCTION PN3EXTCONC(cFilEmp, cMat)   

	Local aTmp 		:= {}
	Local cSRD  	:= ""
	Local cSRV		:= ""	 
	Local cQuery 	:= ""
    Local cTmpBus 	:= ""  
    Local cRoteir 	:= getRoteir()
	Local cConcep	:= alltrim(SuperGetMV("PT_CONVIS",.f.,,))	
	Local aConcep	:= {}	  
	Local nI 		:= 0	
	Local cDesc 	:= ""                
// Se obtienen los conceptos a visualizar 
	if Empty(cConcep)
		aadd(aTmp,{"00","CONFIGURE PARAM PT_CONVIS"})
	Else
		ni:=1
		
		While (nPos:= At(",",cConcep))<>0
			cCaracter := SUBSTR(cConcep,1,nPos-1)
			cConcep   :=RIGHT(cConcep,(len(cConcep)-(nPos)))
			AADD(aConcep,"'" + cCaracter +"',")
		Enddo 
		AADD(aConcep,"'" + cConcep +"' ")
		For ni:=1 to (len(aConcep)) 
			cDesc += aConcep[nI]		
		Next ni 		
		
		
		///////////////////////////////////////////////
		cTmpBus	:= CriaTrab(Nil,.F.) 
		cSRD 	:= RETSQLNAME("SRD")
		cSRV	:= RETSQLNAME("SRV")           
		
		cQuery 	+= "SELECT "
		cQuery 	+= 		"DISTINCT(RD_PD) as RD_PD,RV_DESC "
		cQuery  += "FROM  "
		cQuery 	+=		cSRD + " SRD," 
		cQuery 	+=		cSRV + " SRV "
		cQuery 	+=	"WHERE "
		cQuery 	+=		"    RD_FILIAL='" + XFILIAL("SRD") + "' "
		cQuery  +=		"AND RV_FILIAL='" + XFILIAL("SRV") + "' "
		cQuery  +=		"AND RV_COD	= RD_PD  "
		cQuery 	+=		"AND RD_MAT	='" + cMat + "' "
		cQuery  +=		"AND RD_ROTEIR = '" + cRoteir + "' "  
		cQuery  += 		"AND RV_COD IN(" +cDesc + ") "
		cQuery  +=		"AND SRD.D_E_L_E_T_=' ' "
		cQuery 	+=		"AND SRV.D_E_L_E_T_=' ' "
		cQuery 	+="ORDER BY RD_PD "
		
		cQuery := ChangeQuery(cQuery)    	
		DbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery),cTmpBus, .T., .T. )
		
		Do While !(cTmpBus)->(EOF())      
			
			AADD(aTmp,{(cTmpBus)->RD_PD , (cTmpBus)->RD_PD + "-" +(cTmpBus)->RV_DESC})
			(cTmpBus)->(dbSkip())		                                        		                             
			
		End do        		
		(cTmpBus)->(dbclosearea())	
	EndIf
		 	
		 	
		 	
	
	
RETURN  aTmp

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun??o    ³PN3EXTCTA ³       ³ Gpe Santacruz         ³ Data ³03/03/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri??o ³ Consulta de  estado de cuenta de nómina 	del empleado      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³PN3EXTCON (cPar01,cPar02)                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cPar01: Sucursal del empleado						          ³±±
±±³          ³cPar02: Matricula del empleado.							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³PNOM003                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±/*/    


USER FUNCTION PN3EXTCTA(cFilEmpL,cMat,cPD,cFecIni,cFecFin,cImporte)   

	Local aTmp 		:= {}  
	Local cSRC  		:= ""
	Local cSRD  		:= ""
	Local cSRV		:= ""	 
	Local cQuery 		:= ""
    Local cTmpBus 	:= ""          
    Local nSuma		:= 0
    Local cSigno		:= "" 
    Local cRoteir 	:= ""
    Local cDesc 		:= ""
    Local nI			:= 0
    Local cConcep		:= alltrim(SuperGetMV("PT_CONVIS",.f.,,))	
    Local aconcep		:= {}
    
    cRoteir := getRoteir()
		 	
	IF Empty(cPD)
		
		ni:=1
		
		While (nPos:= At(",",cConcep))<>0
			cCaracter := SUBSTR(cConcep,1,nPos-1)
			cConcep   :=RIGHT(cConcep,(len(cConcep)-(nPos)))
			AADD(aConcep,"'" + cCaracter +"',")
		Enddo 
		AADD(aConcep,"'" + cConcep +"' ")
		For ni:=1 to (len(aConcep)) 
			cDesc += aConcep[nI]		
		Next ni 	
		
	End IF	 	
			 	
	cTmpBus	:= CriaTrab(Nil,.F.) 
	cSRD 	:= RETSQLNAME("SRD")
	cSRV 	:= RETSQLNAME("SRV")
    cSRC	:= RETSQLNAME("SRC")
	cQuery 	+= "SELECT "
	cQuery 	+= 		"RD_DATPGT,RV_DESC,RD_VALOR,RV_TIPOCOD "
	cQuery  += "FROM  "
	cQuery 	+=		cSRD + " SRD," 
	cQuery 	+=		cSRV + " SRV "
	cQuery 	+=	"WHERE "
	cQuery 	+=		"    RD_FILIAL='" + XFILIAL("SRD") + "' "
	cQuery  +=		"AND RV_FILIAL='" + XFILIAL("SRV") + "' "
	cQuery  +=		"AND RV_COD	= RD_PD  "
	cQuery 	+=		"AND RD_MAT	='" + cMat + "' " 
	cQuery  +=		"AND RD_ROTEIR='" + cRoteir + "' "
	if !Empty(cPD)
		cQuery +=	"AND RD_PD = '" + cPD + "' "
	Else 
		cQuery	+= "AND RD_PD IN( " + cDesc + " )"
	End if                                  
	
	IF !Empty(cImporte)
		cQuery +=	"AND RD_VALOR = " + cImporte + " "
	End If                                                          
	
	cQuery  +=		"AND RD_DATPGT >='" + cFecIni + "' "
	cQuery  +=		"AND RD_DATPGT <='" + cFecFin + "' "
	cQuery  +=		"AND SRD.D_E_L_E_T_=' ' "
   	cQuery 	+=		"AND SRV.D_E_L_E_T_=' ' "
	cQuery  +=  "ORDER BY RD_DATPGT "
	cQuery := ChangeQuery(cQuery)    	
	DbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery),cTmpBus, .T., .T. )
	TCSetField(cTmpBus,"RD_DATPGT","D")  
	Do While !(cTmpBus)->(EOF())      
		
		cSigno := IIF((cTmpBus)->RV_TIPOCOD =='1' .or. (cTmpBus)->RV_TIPOCOD=='3'," (+)"," (-)" )    
		
		If (cTmpBus)->RV_TIPOCOD =='1' .or. (cTmpBus)->RV_TIPOCOD=='3'    
			nSuma  += (cTmpBus)->RD_VALOR
		Else
		    nSuma  -= (cTmpBus)->RD_VALOR
		End If          
		
		AADD(aTmp,{(cTmpBus)->RD_DATPGT , (cTmpBus)->RV_DESC + cSigno,(cTmpBus)->RD_VALOR, nSuma})
		(cTmpBus)->(dbSkip())		                                        		                             
		
	End do        		
	(cTmpBus)->(dbclosearea())		
	 
	
RETURN  aTmp
                   
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PREPENV   ºAutor  ³M.CAMARGO           ºFecha ³  04/06/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PREPARA  el ambiente del ERP para la empresa y filial dadasº±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function prepEnv(cFilEmp,cEmpAct)    
                                                                                 

	RPCSetType(3)                                                                
	RESET ENVIRONMENT
	Prepare Environment EMPRESA cEmpAct FILIAL cFilEmp  MODULO 'GPE'  


Return  

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

/*Obtiene CC,Lco Pag, Cargo, Depto, Función para el historial laboral*/
Static Function getInfHL(nTipo,cCampoF,cCampoB,cTabla,cCond,cVal,cTM)

	Local cResult := ""
	Local cQuery  := ""	
	Local cTmp	  := ""
	Local cNomTab := InitSqlName(cTabla)
	Local cFilSRE := XFILIAL(cTabla)    
	Local aTmp	  := {}
	
	cTmp   := CriaTrab(Nil,.F.)
	cQuery := " SELECT " 
	cQuery += 	cCampoF + "," + cCampoB
	cQuery += " FROM "
	cQuery +=	cNomTab + "  "	
	cQuery += " WHERE "
	cQuery += 	cCond 	
		
	If ( TcSrvType()=="AS/400" )
	   cQuery	+= " AND @DELETED@ " 
	ELSE
	   cQuery	+= " AND D_E_L_E_T_ = ' ' "   
	ENDIF
	
	cQuery += " ORDER BY " + cCampoF
	
	cQuery := ChangeQuery(cQuery)    	
	DbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery),cTmp, .T., .T. )
		
	Do While !(cTmp)->(EOF())      		      
		
		AADD(aTmp,{(cTmp)->&cCampoF , (cTmp)->&cCampoB })
		(cTmp)->(dbSkip())		                                        		                             
		
	End do        		
	(cTmp)->(dbclosearea())	
	IF len(aTmp) >0	  
	   	IF nTipo == 0
	   		cResult := aTmp[1,2]					
	    ELSE   			
			IF cVal == aTmp[1,1] .and. len(aTmp) != 1  
				If cTM == "P"          // Solo si es cargo toma el primer registro
					cresult := aTmp[1,2]   		
				Else     
					cresult := aTmp[2,2]   				
				EndIF
			ELSE 
		  		cresult := aTmp[1,2]   		  
			End IF
		END IF
	ELSE 
		cResult := ' '
	ENDIF
Return cResult             

USER FUNCTION PN2EXTFOL()
	Local aTmp 		:= {}
	Local aArray 	:= {}

	Local cTabla 	:= "SRA"
	Local cIdFol	:= ''
	Local nI 		:= 0  
	Local cDesc		:= ''
		
	Dbselectarea("SX3")
	
	SX3->( dbSetOrder(1) )
	IF SX3->(dbSeek(upper(cTabla)))
		While SX3->( !Eof() .And. SX3->X3_ARQUIVO == UPPER(cTabla) )
	    	IF 	SX3->X3_CONTEXT # 'V'	    				
				AADD(aTmp,SX3->X3_FOLDER)	        
	    	EndIF
		    SX3->( dbSkip() )
		End While
	EndIF	 
	aTmp :=  aSort(aTmp)  

	DBSELECTAREA("SXA") 
	SXA->(dbSetOrder(1))
		
	For nI := 1 to len(aTmp)
		If cIdFol <> aTmp[nI] .and. !Empty(cIDFol)   
			cDesc := POSICIONE("SXA",1,"SRA"+cIdFol,"XA_DESCSPA")
			AADD(aArray,{cIdFol,cDesc})		
	    End If		                	    
	    cIdFol := aTmp[nI]
	Next nI
	
    AADD(aArray,{"0","OTROS"}) 

RETURN aArray

//Funcion utitlizada para buscar en tabla que manejan superfiltros (SRA/SRV/SRD/SRC)
USER FUNCTION BuscaTabFil(cCondicion,cResulta,cTabla,cPrefijo,nnum)
Local cResQry:=''
Local cSRA := ''
Local cTmp := criatrab(nil,.F.) 
Local  cQuery :=""
           
Default nnum:=0       

cSRA := InitSqlName(cTabla)   
IF NNUM>0
   cResulta+= " nnumreg "
ENDIF
	cQuery := "SELECT "+cresulta
	cQuery += "  FROM "
	cQuery +=		cSRA +cTabla
	cQuery += "WHERE "+ALLTRIM(cprefijo)+"_FILIAL='"+ xfilial(ALLTRIM(cTabla))  + "' AND "+cCondicion
	cQuery +=		"  and D_E_L_E_T_=' ' "


	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cTmp,.T.,.T.) 

IF (cTmp)->(!eof())   
   if nnum>0                       
	   cResQry:=(cTmp)->nnumreg
   else           
       cResQry:=(cTmp)->&(cresulta)
   endif     
   
else           
   if nnum>0  
      cResQry:=0
    else  
	   cResQry:=''
	endif   
endif               
(cTmp)->(DBCLOSEAREA())
return cResQry

