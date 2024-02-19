#INCLUDE "PROTHEUS.CH"   
#INCLUDE "RWMAKE.CH" 
#INCLUDE "WMSR430A.CH" 
#INCLUDE "APVT100.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"


//-----------------------------------------------------------
/*/{Protheus.doc} WMSR430A
Impressao de Etiquetas de Volume

@author  Leandro Paulino
@since   05/17/11
/*/
//-----------------------------------------------------------
User Function WMSR430A()          
Local cVolume := ''  
Local nQtdEti := 000
Local nX		  := 0
Local cLocImp := Space(TamSX3("CB5_CODIGO")[01])
Local aTela	  := VtSave()

	VTCLear()
	@ 00,00 VTSay STR0001 // Qtde. de Etiquetas:
	@ 01,00 VTGet nQtdEti pict '@999!'
	VTRead    
	   
	If VtLastKey() == 27
		VtRestore(,,,,aTela)
		Return ( NIL )  
	EndIf  
	
	If VtYesNo(STR0001+" " + cValToChar(nQtdEti),STR0002) // CONFIRMA IMPRESSÃO?
	
	   If Empty(SuperGetMV("MV_WMSLOCI",.F.,""))        
			VtClear()		
			@ 0,00 VTSAY STR0003 // Informe o Local
			@ 1,00 VTSAY STR0004 // de Impressão
			@ 2,00 VTGET cLocImp PICTURE '@!' F3 "CB5"
			VtRead
			If VtLastkey() == 27
				Return ( .F. )
			EndIf
			If !CB5SetImp(cLocImp,IsTelNet())
				VtAlert(STR0005,STR0006,.t.,3000,2) // Local de impressao invalido! // Aviso
				Return .F.
			EndIf						   		   			
		ElseIf !CB5SetImp(CBRLocImp("MV_WMSLOCI"),IsTelNet())	
			VtAlert(STR0005,STR0006,.T.,3000,2) // Local de impressao invalido!
		Return .F.
		EndIf	
		For nX:= 1 To nQtdEti
		
			If VtLastKey() == 27
				VtRestore(,,,,aTela)
				Return ( NIL )  
			EndIf  
			
			cVolume := Padl(CBProxCod('MV_WMSNVOL'),TamSx3("DCU_CODVOL")[1],"0")                 
				
			MSCBINFOETI(STR0007,"30X100") // Etiqueta de Volume.
		
			MSCBBEGIN(1,6)
				MSCBBOX(006,00,06,76)
				MSCBSAY(017,10,STR0007,"N","F","1,2", , , ,.T.) // Etiqueta de Volume.
				MSCBSAYBAR(015,020,AllTrim(cVolume),"N","MB07",11.36,.F.,.F.,.F., ,2.3,2,.F.,.F.,"1",.T.)	 
			MSCBEND()
			
		Next nX 	                                                
	Else	      
		Return (.F.)
	EndIf	

	MSCBCLOSEPRINTER()		  
	
Return ( Nil )