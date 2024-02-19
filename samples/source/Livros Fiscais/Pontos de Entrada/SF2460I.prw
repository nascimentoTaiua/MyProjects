
#include "rwmake.ch"

//--------------------------------------------------------------------------------------
//   Ponto de Entrada na Geração da Nota Fiscal de Saída para :  
//   1. Acertar os valores no SF2 : F2_VALBRUT e F2_VALIPI (já que o valor do IPI
//   da NF é recalculado através do PE M460IPI (para arredondar os valores, ao invés
//   de "truncar");    
//   2. Atualiza F3_IPIOBS p/ NF´s com TES de Mandado de Segurança.
//   3. Tratamento INSS 2.85% s/ Faturamento.
//--------------------------------------------------------------------------------------

user Function SF2460I()  

	//cat95
	LOCAL aCampos := &( GetNewPar( "MV_CAT95P2", NIL ) ) 
	LOCAL lOk     := .T.                     
	LOCAL aCamposC5 := {} 
	/////////
   
   Local _nTTIPI  := 0                       
   Local aVet     := {}
   Local _cfoVend := space(3)
   Local _cParam  := ""     
   Local cMesVenc := ""     
   Local cAno     := ""     
   Local dVenc    := ""   
   Local _nTotINSS:= 0  
                                             
   // Parâmetro que contém os CFO´s de INSS AgroIndústria
      
   _cParam := alltrim(getmv("MV_CFOVEND"))   
   
   // Feito para calcular o IPI Mand.Segurança p/ imprimir esse valor no Livro Fiscal
   
   dbselectarea("SD2")
   dbsetorder(3)
   dbseek(xfilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE)    
   
   if !eof()     
           
      dbselectarea("SF4")
      dbsetorder(1)
      dbseek(xfilial("SF4")+SD2->D2_TES)
      
      if SF4->F4_MSEGURA=="S"
         dbselectarea("SF3")
         dbsetorder(6)
         dbseek(xfilial("SF3")+SF2->F2_DOC+SF2->F2_SERIE)
         reclock("SF3",.f.)
         SF3->F3_IPIOBS := round((((SF3->F3_VALCONT / 1.05) * 5 ) / 100),2)
         msUnlock()  
      endif  
      
   endif
      
   // Feito para arredondar o valor do IPI no SD2 (Itens da NF)
         
   dbselectarea("SD2")
   dbsetorder(3)
   dbseek(xfilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)
   
   do while SD2->D2_DOC==SF2->F2_DOC         .and. SD2->D2_SERIE==SF2->F2_SERIE .and. ;
            SD2->D2_CLIENTE==SF2->F2_CLIENTE .and. SD2->D2_LOJA==SF2->F2_LOJA
            
         _nTTIPI := _nTTIPI + SD2->D2_VALIPI
	     _cfoVend := alltrim(SD2->D2_CF)
	     
         // Totaliza Valor do INSS do item (verifica se é CFO p/ INSS AgroIndústria)

         if SD2->D2_VALINS<>0 .and. _cfoVend$_cParam 
            _nTotINSS := _nTotINSS + SD2->D2_VALINS   
	        
	        dbselectarea("SD2")
    	    reclock("SD2",.f.)
	        SD2->D2_VALINS := 0
	        SD2->D2_ALIQINS:= 0
    	    msUnlock()            
         endif
         
         dbselectarea("SD2")
         dbSkip()

   enddo    
            
   // Feito para arredondar o valor do IPI no SF2 (Cabec. da NF)              
               
   dbselectarea("SF2")
   reclock("SF2",.f.)
   SF2->F2_VALBRUT := SF2->F2_VALFAT
   SF2->F2_VALIPI  := _nTTIPI
   msUnlock()               

   if SF2->F2_VALINSS <> 0   // Alteração : estava mantendo o título IN- qdo não era 
                             // INSS AgroInd. Com essa alteração, o título IN- será 
                             // excluído sempre q houver cálculo de INSS (CFO de AgroInd.
                             // ou não)
    
      // Zera o campo F2_VALINSS no SF2
      
      dbselectarea("SF2")
      reclock("SF2",.f.)
      SF2->F2_VALINSS := 0
      msUnlock()
      
      // Exclui título IN- gerado no SE1, pois a Usina vai receber o valor total da
      // NF do Cliente, i.e., sem abater o valor do INSS desse esse título IN-
        
      dbselectarea("SE1")
      dbsetorder(1)
      dbseek(xfilial("SE1")+SF2->F2_SERIE+SF2->F2_DOC)    
      
      if !eof()
      
         do while SE1->E1_CLIENTE==SF2->F2_CLIENTE .and. SE1->E1_LOJA==SF2->F2_LOJA .and.;
                  SE1->E1_PREFIXO==SF2->F2_SERIE   .and. SE1->E1_NUM ==SF2->F2_DOC
            
            if SE1->E1_TIPO=="IN-"
               dbselectarea("SE1")
               reclock("SE1",.f.)
               dbDelete()
               msUnlock() 
            elseif SE1->E1_INSS<>0
                   dbselectarea("SE1")
                   reclock("SE1",.f.)
                   SE1->E1_INSS := 0.00
                   msUnlock() 
            endif
            
            dbselectarea("SE1")
            dbSkip()
         
         enddo
         
      endif
       
   endif
                  
   // Tratamento INSS 2.85% s/ Faturamento      

   if _nTotINSS <> 0 
     
      // Gera um título a pagar no valor do INSS gerado na NF 
      // PS. : Utiliza rotina automática para gerar o SE2.          
       
      AADD(aVet,{"E2_FILIAL " ,xfilial("SE2"), Nil} )  
      AADD(aVet,{"E2_FILTUSA" ,""           , Nil} )
      AADD(aVet,{"E2_NUM    " ,SF2->F2_DOC  , Nil} )
      AADD(aVet,{"E2_PREFIXO" ,SF2->F2_SERIE, Nil} )
      AADD(aVet,{"E2_PARCELA" ,""           , Nil} )
      AADD(aVet,{"E2_TIPO"    ,"INS"        , Nil} )  
      AADD(aVet,{"E2_NATUREZ" ,"INSS"       , Nil} )         
      AADD(aVet,{"E2_FORNECE" ,"INSS"       , Nil} )           
      AADD(aVet,{"E2_LOJA   " ,"01"         , Nil} )               	     		
      AADD(aVet,{"E2_NOMFOR " ,"INSS"       , Nil} )    
      
      // Alteração solicitada pro Gilson - Fiscal : 
      // o Vencto p/ o INSS sempre no dia 02 do mês seguinte.
      
      if month(ddatabase)<12          
	      cMesVenc := alltrim(str(month(ddatabase) + 1))	       
	      cAno     := alltrim(str(year(ddatabase)))
	  else
		  cMesVenc := "01"                         
          cAno     := alltrim(str(year(ddatabase)+1))
      endif                                                       
      
      dVenc    := ctod("02/"+cMesVenc+"/"+cAno)
      
      AADD(aVet,{"E2_EMISSAO" ,ddatabase        , Nil} )     
      AADD(aVet,{"E2_VENCTO"  ,dVenc            , Nil} )  
      AADD(aVet,{"E2_VENCORI" ,dVenc            , Nil} ) 
      AADD(aVet,{"E2_VENCREA" ,datavalida(dVenc), Nil} )
      AADD(aVet,{"E2_VALOR"   ,_nTotINSS        , Nil} )            
      AADD(aVet,{"E2_EMIS1  " ,ddatabase      , Nil} )         
      AADD(aVet,{"E2_LA     " ,"S"            , Nil} )
      AADD(aVet,{"E2_OK     " ,"3q"           , Nil} )                    
      AADD(aVet,{"E2_SALDO"   ,_nTotINSS      , Nil} )       
      AADD(aVet,{"E2_MOEDA  " ,1              , Nil} )       
      AADD(aVet,{"E2_VLCRUZ " ,_nTotINSS      , Nil} )   
      
      dbselectarea("SA1")
      dbsetorder(1)
      dbseek(xfilial("SA1")+SF2->F2_CLIENTE)
      AADD(aVet,{"E2_HIST   " ,"Cli. "+SA1->A1_NREDUZ , Nil} )                

      AADD(aVet,{"E2_ORIGEM " ,"MATA460"  , Nil} )        
      AADD(aVet,{"E2_USUALIB" ,substr(cUsuario,7,15), Nil} )             
      	         
      FINA050(aVet,3)      
   
   endif
   
   If ValType( aCampos ) == "A" 
           
	lOk := .T.
	aEval( aCampos, { |x| x := AllTrim( x ) } ) 	
	
	aCamposC5 := {} 
	
	aEval( aCampos, { |x| AAdd( aCamposC5, "C5_" + AllTrim( Substr( x, 4 ) ) ) } )

	For nLoop := 1 to Len( aCampos ) 
	
		If Empty( SF2->( FieldPos( aCampos[ nLoop ] ) ) ) 
			lOk := .F. 
			Exit
		EndIf 		                                                                
	
	Next nLoop 

	If lOK          
		For nLoop := 1 to Len( aCamposC5 ) 
		
			If Empty( SC5->( FieldPos( aCamposC5[ nLoop ] ) ) ) 
				lOk := .F. 
				Exit
			EndIf 		                                                                
		
		Next nLoop 
	EndIf	

	If lOk                      
	
		RecLock( "SF2", .f. ) 			
		
		For nLoop := 1 To Len( aCamposC5 ) 
			cConteudo := SC5->( FieldGet( SC5->( FieldPos( aCamposC5[ nLoop ] ) ) ) ) 
			SF2->( FieldPut( SF2->( FieldPos( aCampos[ nLoop ] ) ), cConteudo ) )
		Next nLoop
			
		SF2->( MsUnlock() ) 
	
	EndIf
	
EndIf

   
   
   
   
         
Return

//--------------------------------------------------------------------------------------
