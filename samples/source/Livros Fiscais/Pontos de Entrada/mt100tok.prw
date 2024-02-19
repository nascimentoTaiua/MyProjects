User Function MT100TOK() 

Local nLoop			:= 1
Local lRet			:= PARAMIXB[1]       
Local lOk			:= .F.
LOCAL cCampos4:= &( GetNewPar( "MV_CAT95", NIL ) )

xUserData			:=If(ValType(xUserData)=="U",{},xUserData)

For nLoop := 1 to Len( aCols )		
    If SB5->(dbSeek(xFilial()+aCols[nLoop,1])) .And. !Empty( SB5->(FieldGet( FieldPos( cCampos4 ) ) ))
	   lOk := .T.
	   Exit
    EndIf		
Next nLoop

If lOk                   
   lRet		:= .F.
   For nLoop := 1 to Len( xUserData )
       If !Empty(xUserData[nLoop,2])
          lRet	:=.T.
	      Exit
       EndIf		
   Next nLoop
   
   If !lRet
      MSGINFO("As informacoes adicionais referentes a Portaria CAT 95/03 devem ser digitadas","Aviso")   
   Endif
Endif   

Return( lRet ) 

