
#INCLUDE "RWMAKE.CH"

User function CAT95DAT()

Local oDlg
Local aUserData := {}
LOCAL cPlaca1 := Space(7)
LOCAL cPlaca2 := Space(7)
LOCAL cPlaca3 := Space(7)

LOCAL cEst1   := Space(2)
LOCAL cEst2   := Space(2)
LOCAL cEst3   := Space(2)

LOCAL cFornec 	:= Space(6)
LOCAL cLoja		:= Space(2)
LOCAL cFilEnt  	:= Space(2)
LOCAL cTransp  	:= Space(6)

LOCAL aCampos := &( GetNewPar( "MV_CAT95P1", NIL ) )
LOCAL aCampos2:= &( GetNewPar( "MV_ENTSF1", NIL ) )
LOCAL cCampos3:= &( GetNewPar( "MV_CAT95TR", NIL ) )
LOCAL cCampos4:= &( GetNewPar( "MV_CAT95", NIL ) )

If ValType( aCampos ) == "A"
	
	lOk := .T.
	aEval( aCampos, { |x| x := AllTrim( x ) } )
	
	For nLoop := 1 to Len( aCampos )
		
		If Empty( SF1->( FieldPos( aCampos[ nLoop ] ) ) )
			lOk := .F.
			Exit
		EndIf
		
	Next nLoop
	
	lOk := .T.
	aEval( aCampos2, { |x| x := AllTrim( x ) } )
	
	For nLoop := 1 to Len( aCampos2 )
		
		If Empty( SF1->( FieldPos( aCampos2[ nLoop ] ) ) )
			lOk := .F.
			Exit
		EndIf
		
	Next nLoop
	
	lOk := .T.
	If SF1->( FieldPos( cCampos3 ) ) > 0
	   If Empty( SF1->( FieldPos( cCampos3 ) ) )
	      lOk := .F.
	   EndIf
	Endif
	
	lOk := .T.
	If SB5->( FieldPos( cCampos4 ) ) > 0
	   If Empty( SB5->( FieldPos( cCampos4 ) ) )
		  lOk := .F.
	   EndIf
	Endif   
	
	If lOk
	   lOk		:=.F.
	   For nLoop := 1 to Len( aCols )		
		   If SB5->(dbSeek(xFilial()+aCols[nLoop,1])) .And. !Empty( SB5->(FieldGet( FieldPos( cCampos4 ) ) ))
			  lOk := .T.
			  Exit
		   EndIf		
	   Next nLoop
	Endif   
	
	If lOK
		
		lOk := .F.
		
		@ 110,147 TO 380,475 DIALOG oDlg TITLE "Campos - CAT95"
		@ 022 ,9   SAY 'Placa do 1o Veiculo'
		@ 033 ,9   SAY 'UF do 1o Veiculo'
		@ 044 ,9   SAY 'Placa do 2o Veiculo'
		@ 055 ,9   SAY 'UF do 2o Veiculo'
		@ 066 ,9   SAY 'Placa do 3o Veiculo'
		@ 077 ,9   SAY 'UF do 3o Veiculo'
		@ 088 ,9   SAY 'Local de Armazenagem'
		@ 099 ,9   SAY 'Loja de Armazenagem'
		@ 110 ,9   SAY 'Filial de Armazenagem'
		@ 121 ,9   SAY 'Codigo da Transportadora'
		
		@ 022 ,94  GET cPlaca1
		@ 033 ,94  GET cEst1 VALID ExistCpo( "SX5","12"  + cEst1 ) F3 "12"
		@ 044 ,94  GET cPlaca2
		@ 055 ,94  GET cEst2  VALID ExistCpo( "SX5","12" + cEst2 ) F3 "12"
		@ 066 ,94  GET cPlaca3
		@ 077 ,94  GET cEst3 VALID ExistCpo( "SX5","12"  +  cEst3 ) F3 "12"
		@ 088 ,94  GET cFornec VALID ExistCpo( "SA2",cFornec ) F3 "SA2"
		@ 099 ,94  GET cLoja
		@ 110 ,94  GET cFilEnt
		@ 121 ,94  GET cTransp  VALID ExistCpo( "SA4",cTransp ) F3 "SA4"
		
		ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||lOk:=.T.,oDlg:End()},{||oDlg:End()}) CENTERED
		
		If !Empty(cTransp)
		   If lOk		
			  aUserData := { { aCampos[1], cPlaca1 }, { aCampos[2], cEst1 }, { aCampos[3],cPlaca2 } , { aCampos[4],cEst2 }, { aCampos[5],cPlaca3 }, { aCampos[6],cEst3 },{ aCampos2[1],cFornec },{ aCampos2[2],cLoja },{ aCampos2[3],cFilEnt },{ cCampos3,cTransp } }
		   Else
			  aUserData := NIL
		   EndIf
		Else   
		   aUserData := NIL
		Endif   		
	EndIf
EndIf

Return( aUserData )
