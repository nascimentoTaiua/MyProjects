
#include "SIGAWIN.CH"       
#include "RWMAKE.CH"   

//---------------------------------------------------------------------------------------
//  Ponto de Entrada na confirmação da NF Entrada para :
//  1. Inclusão de Descréscimo no título principal (no caso de SEST/SENAT);
//  2. Geração de título a pagar no valor do SEST/SENAT;
//  3. Possibilitar a digitação de mensagem no corpo da NF : será impressa p/USA_O1 e USA_02
//  4. Possibilitar a digitação de Transportadora p/ NF Entrada.    
//  5. Possibilitar a digitação dos campos IE e UF para a DIEF - ES
//---------------------------------------------------------------------------------------

User Function SF1100I()

 SetPrvt("CMSGPDR,OBS,aVet,nPerc,cMsgPdr,cTeste,cTranPdr,cIE,cUF")
 
 //----------------------------------------------------------------------- 
 // Tratamento do cálculo do SEST/SENAT para Prest. Serviços de Transporte
 
 nPerc   	:= getmv("MV_PERCSEN")      // % UTILIZADO PARA CÁLCULO DO SEST/SENAT 
 cMsgPdr 	:= space(200)                                    
 cTranPdr	:= space(6)
 cIE  		:= space(18)
 cUF		:= space(2)
 
 if SA2->A2_STSENAT == "S"     
       
      // Grava o campo E2_DECRESC com o valor do SEST/SENAT para que seja abatido do 
      // valor total a pagar.
      
      dbselectarea("SE2")
      reclock("SE2",.f.)
      SE2->E2_DECRESC := SE2->E2_SDDECRE := (SF1->F1_VALMERC*nPerc)/100      
      SE2->E2_HIST    := "Desc.SEST/SENAT:"+alltrim(str(round((SF1->F1_VALMERC*nPerc)/100,2)))
      msUnlock()      
         
      // Gera um título a pagar no valor do SEST/SENAT para NF´S que possuem esse cálculo.
      
      aVet := {}
 
      AADD(aVet,{"E2_FILIAL " ,xfilial("SE2"), Nil} )  
      AADD(aVet,{"E2_FILTUSA" ,space(2)     , Nil} )
      AADD(aVet,{"E2_NUM    " ,SF1->F1_DOC  , Nil} )
      AADD(aVet,{"E2_PREFIXO" ,SF1->F1_SERIE, Nil} )
      AADD(aVet,{"E2_PARCELA" ,""           , Nil} )
      AADD(aVet,{"E2_TIPO"    ,"TX "        , Nil} )  
      AADD(aVet,{"E2_NATUREZ" ,"71602"      , Nil} )         
      AADD(aVet,{"E2_FORNECE" ,"SENAT"      , Nil} )           
      AADD(aVet,{"E2_LOJA   " ,"00"         , Nil} )               	     		
      AADD(aVet,{"E2_NOMFOR " ,"SENAT"      , Nil} )         
      AADD(aVet,{"E2_EMISSAO" ,ddatabase    , Nil} )     
      AADD(aVet,{"E2_VENCTO"  ,ddatabase    , Nil} )  
      AADD(aVet,{"E2_VENCORI" ,ddatabase    , Nil} ) 
      AADD(aVet,{"E2_VENCREA" ,ddatabase    , Nil} )
      AADD(aVet,{"E2_VALOR"   ,(SF1->F1_VALMERC*nPerc)/100, Nil} )            
      AADD(aVet,{"E2_EMIS1  " ,ddatabase      , Nil} )         
      AADD(aVet,{"E2_LA     " ,"S"            , Nil} )
      AADD(aVet,{"E2_OK     " ,"3q"           , Nil} )                    
      AADD(aVet,{"E2_SALDO"   ,(SF1->F1_VALMERC*nPerc)/100, Nil} )       
      AADD(aVet,{"E2_MOEDA  " ,1              , Nil} )       
      AADD(aVet,{"E2_VLCRUZ " ,(SF1->F1_VALMERC*nPerc)/100, Nil} )       
      AADD(aVet,{"E2_ORIGEM " ,"MATA100"  , Nil} )        
      AADD(aVet,{"E2_USUALIB" ,substr(cUsuario,7,15), Nil} )             
      	         
      FINA050(aVet,3)                     
                
      // Se a fç automática FINA050 é usada aqui p/ gerar o título TX do SEST/SENAT, 
      // o campo E2_ORIGEM sempre será gravado com "FINA050". Se faz necessário regravar
      // esse campo c/"MATA100" para que, ao excluir a NF Entrada, esse título tbém seja 
      // excluído automaticamente.

      dbselectarea("SE2")
      reclock("SE2",.f.)
      SE2->E2_ORIGEM := "MATA100"   
      msUnlock()
            
 endif

 //----------------------------------------------------------------------- 
 // Tratamento da Inclusão de Mensagem Livre na Nota Fiscal de Entrada
 
 if SF1->F1_FORMUL=='S'
 
	 @ 0,0 TO 150,450 DIALOG oDlg1 TITLE "Inclusao de Mensagem"
	 @ 75,10 Say "ComboBox:"
	 @ 5 ,15 Say "Mensagem ?"
	 @ 20,15 GET cMsgPdr PICTURE "@S" SIZE 200,500 
	 
	 @ 40,15 Say "Transportadora "
	 @ 38,55 Get cTranPdr F3 "SA4"

	 @ 45,185 BUTTON "_Ok" SIZE 35,15 ACTION Close(oDlg1)
	 ACTIVATE DIALOG oDlg1 CENTER
	 
 endif	 

 dbselectarea("SF1")
 reclock("SF1",.f.)
 SF1->F1_MENSG  :=cMsgPdr
 SF1->F1_USERNR :=SUBS(cUsuario,7,15)
 if !empty(cTranPdr)
    SF1->F1_TRANSPT:=cTranPdr
 endif   
 msUnlock()      

If Type( "xUserData" ) == "A" 
	Reclock( "SF1", .f. ) 

	For nLoop := 1 To Len( xUserData ) 
		SF1->( FieldPut( SF1->( FieldPos( xUserData[ nLoop,1 ] ) ), xUserData[nLoop, 2 ] ) ) 
	Next nLoop            
	SF1->( MsUnlock() ) 
EndIf 

 //----------------------------------------------------------------------- 
 // Tratamento da Inclusão dos campos de IE e UF na Nota Fiscal de Entrada
 // para a DIEF - ES
 
nIERegB 	:= SF1->(FieldPos(GetNewPar("MV_IEDFES","")))
nUFRegB 	:= SF1->(FieldPos(GetNewPar("MV_UFDFES","")))

If nIERegB > 0 .And. nUFRegB > 0

	@ 0,0 TO 150,450 DIALOG oDlg1 TITLE "Inclusão de UF e Inscrição Estadual para a DIEF-ES"
	
	@ 5,15 Say "UF"
	@ 18,15 Get cUF PICTURE "@!" SIZE 2,30 F3 "12" VALID Vazio() .Or. ExistCpo("SX5","12"+cUf)
	
	@ 33,15 Say "Inscrição Estadual"
	@ 46,15 Get cIE PICTURE "@!" SIZE 100,100 VALID Vazio() .Or. IE(cIE,cUF)
	
	@ 55,185 BUTTON "_Ok" SIZE 35,15 ACTION Close(oDlg1)
	ACTIVATE DIALOG oDlg1 CENTER

Endif	 

 DbSelectArea("SF1")
 RecLock("SF1",.F.)
 	SF1->&(GetNewPar("MV_UFDFES"))  := cUF
 	SF1->&(GetNewPar("MV_IEDFES"))  := cIE
 MsUnlock()     
 
Return                                                            
