#INCLUDE "PROTHEUS.CH"                                                                                        
#INCLUDE "COLORS.CH"                                                                                                                    
#INCLUDE "TBICONN.CH"                                                                                                              
                                                                                                                             
/*                                                                                                   
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ   
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±     
±±³Programa  ³FISA057XML³ Autor ³ Camila Januário       ³ Data ³25/01/2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±± 
±±³Descri‡…o ³Exemplo de geracao da Nota Fiscal Eletronica Uruguai        ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Xml para envio                                              ³±± 
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Tipo da NF                                           ³±±
±±³          ³       [0] Entrada                                          ³±±
±±³          ³       [1] Saida                                            ³±±
±±³          ³ExpC2: Serie da NF                                          ³±±         
±±³          ³ExpC3: Numero da nota fiscal                                ³±±
±±³          ³ExpC4: Codigo do cliente ou fornecedor                      ³±±
±±³          ³ExpC5: Loja do cliente ou fornecedor                        ³±± 
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±                          
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±± 
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß  
/*/                                                                                 

User Function FISA057XML(cTipo,cSerie,cNota,cClieFor,cLoja) 


Local cAliasSD1    := "cAliSD1"
Local cAliasSD2    := "cAliSD2"
Local cMensCli     := ""
Local cMensFis     := ""


Local cCodUM	   := ""


Local lPedido 	   := ""
Local lQuery       := .F.
Local aDest        := {}
Local aProd        := {}
Local acabNF 	   := {}
Local aPed 		   := {}             
Local aNfVinc	   := {}       
                                                                    
Local nX           := 0
Local nIV		   := 0
Local nTasaBas 	   := 0
Local nTasaMin 	   := 0
Local nMntTasBas   := 0
Local nBasiva 	   := 0
local nTkBruto	   := 0
local cTpFret	   := ""
Local nPos:=0
Local lMuestra     := .F.
Local nValdescU:= 0
Local nValddesc:=0
Local nPrec:=0
Local nTotal:=0
Private aColIB	   :={}
Private aColIVA	   :={}
Private aColIVAZer :={}
Private aColIVAIse :={}
Private aColIVASus :={}
Private aIB		   :={}
Private aIVA	   :={}
Private _cSerie    := ""

DEFAULT cTipo      := PARAMIXB[1]
DEFAULT cSerie     := PARAMIXB[2]
DEFAULT cNota      := PARAMIXB[3]                         
DEFAULT cClieFor   := PARAMIXB[4]
DEFAULT cLoja      := PARAMIXB[5]

If cTipo == "1"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posiciona NF                                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SF2")
	dbSetOrder(1)
	DbGoTop()
	If DbSeek(xFilial("SF2")+cNota+cSerie+cClieFor+cLoja)		
		aadd(aCabNF,SF2->F2_SERIE)
		aadd(aCabNF,SF2->F2_DOC)                  
		aadd(aCabNF,SF2->F2_EMISSAO)  
		aadd(aCabNF,SF2->F2_COND) 
		
		Fis57Imp()

		nVlIv:=0
		For nIV := 1 To Len(aColIVA)
			If aColIVA[nIV][2] == "1" //tasa basica
				nTasaBas := aColIVA[nIV][3]   
				nMntTasBas  := &("SF2->F2_VALIMP"+aColIVA[nIV][1])  
				nBasIva  	:= &("SF2->F2_BASIMP"+aColIVA[nIV][1])   
			Elseif aColIVA[nIV][2] == "2" //tasa min
				nTasaMin := aColIVA[nIV][3]
			Endif				
			If  &("SF2->F2_VALIMP"+aColIVA[nIV][1]) > 0
				aadd(aIVA,{&("SF2->F2_VALIMP"+aColIVA[nIV][1]),;
							&("SF2->F2_BASIMP"+aColIVA[nIV][1]),;
								aColIVA[nIV][2],;
								aColIVA[nIV][3],;
								})
			EndIf					
		Next
		
		aadd(aCabNF,0/*nTasaBas*/)  			  						// aliq basica
		aadd(aCabNF,0/*nTasaMin*/)    			  						//aliq min
		aadd(aCabNF,nMntTasBas)  				  						//valor do imposto     7 MntIVATasaBasica
		aadd(aCabNF,nBasIva)	 				  						//base do iva		   8 MntNetoIVATasaBasica	    
		aadd(aCabNF,SF2->F2_FRETE+SF2->F2_DESPESA+SF2->F2_SEGURO)  
		aadd(aCabNF,SF2->F2_ESPECIE) 			 						//tipo da nota
		aadd(aCabNF,SF2->F2_VALMERC) 			 						//valor da mercadoria s impostos
		aadd(aCabNF,SF2->F2_VALFAT)	 			 						//valor total da nota 
		aadd(aCabNF,SF2->F2_TXMOEDA) //13
		aadd(aCabNF,SF2->F2_BASIMP3) //14 
		aadd(aCabNF,"") //15 
		aadd(aCabNF,"") //16
		aadd(aCabNF,"") //17
		aadd(aCabNF,"") //18
		aadd(aCabNF,"") //19
		aadd(aCabNF,"") //20                        	    
		

		_cSerie := SF2->F2_SERIE  
						
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Posiciona cliente ou fornecedor                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
		If Alltrim(SF2->F2_ESPECIE)=="NDI" .Or. Alltrim(SF2->F2_ESPECIE)=="NCP" .OR. Alltrim(SF2->F2_ESPECIE)=="NDP"
			dbSelectArea("SA2")
			dbSetOrder(1)
			DbSeek(xFilial("SA2")+SF2->F2_CLIENTE+SF2->F2_LOJA)
			aadd(aDest,SA2->A2_PAIS)   
			aadd(aDest,AllTrim(SA2->A2_CGC))
			aadd(aDest,Alltrim(SA2->A2_NOME)) 
			aadd(aDest,MyGetEnd(SA2->A2_END,"SA2")[1])
			aadd(aDest,AllTrim(SA2->A2_MUN))
			aadd(aDest,RetProvin(AllTrim(SA2->A2_EST)))					
			aadd(aDest,AllTrim(SA2->A2_TIPO))		
			aadd(aDest,"")
			aadd(aDest,"")
			aadd(aDest,"") 
			aadd(aDest,"") //Contacto
		Else
			dbSelectArea("SA1")
			dbSetOrder(1)
			DbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA)		
			aadd(aDest,SA1->A1_PAIS)  
			aadd(aDest,AllTrim(SA1->A1_CGC))
			aadd(aDest,Alltrim(SA1->A1_NOME)) 
			//aadd(aDest,MyGetEnd(SA1->A1_END,"SA1")[1])
			aadd(aDest,ALLTRIM(SA1->A1_END))
			aadd(aDest,AllTrim(SA1->A1_MUN))
			aadd(aDest,RetProvin(AllTrim(SA1->A1_EST)))
			aadd(aDest,AllTrim(SA1->A1_TIPO))
			aadd(aDest,AllTrim(SA1->A1_PESSOA))
			aadd(aDest,Iif(SA1->(FieldPos("A1_VEXP")) >0,AllTrim(SA1->A1_VEXP),"")) 
			aadd(aDest,Iif(SA1->(FieldPos("A1_TP")) >0,AllTrim(SA1->A1_TP),""))		 
			aadd(aDest,"") //Contacto
		EndIf	
		
		dbSelectArea("SF2")
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Pesquisa itens de nota                                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
		dbSelectArea("SD2")
		dbSetOrder(3)	
		#IFDEF TOP
			lQuery  := .T.
			BeginSql Alias cAliasSD2
				SELECT *
				FROM %Table:SD2% SD2
				WHERE
				SD2.D2_FILIAL = %xFilial:SD2% AND
				SD2.D2_SERIE = %Exp:SF2->F2_SERIE% AND 
				SD2.D2_DOC = %Exp:SF2->F2_DOC% AND 
				SD2.D2_CLIENTE = %Exp:SF2->F2_CLIENTE% AND 
				SD2.D2_LOJA = %Exp:SF2->F2_LOJA% AND 
				SD2.%NotDel%
				ORDER BY %Order:SD2%
			EndSql
				
		#ELSE
			DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)
		#ENDIF 
		dbSelectArea(cAliasSD2)
		While !Eof() .And. xFilial("SD2") == (cAliasSD2)->D2_FILIAL .And.;
			SF2->F2_SERIE == (cAliasSD2)->D2_SERIE .And.;
			SF2->F2_DOC == (cAliasSD2)->D2_DOC
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica as notas vinculadas                                            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !Empty((cAliasSD2)->D2_NFORI) 
				If (cAliasSD2)->D2_TIPO $ "DBN"
					dbSelectArea("SD1")
					dbSetOrder(1)
					If DbSeek(xFilial("SD1")+(cAliasSD2)->D2_NFORI+(cAliasSD2)->D2_SERIORI+(cAliasSD2)->D2_CLIENTE+(cAliasSD2)->D2_LOJA+(cAliasSD2)->D2_COD+(cAliasSD2)->D2_ITEMORI)
						dbSelectArea("SF1")
						dbSetOrder(1)
						DbSeek(xFilial("SF1")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_TIPO)
						If SD1->D1_TIPO $ "DB"
							dbSelectArea("SA1")
							dbSetOrder(1)
							DbSeek(xFilial("SA1")+SD1->D1_FORNECE+SD1->D1_LOJA)
						Else
							dbSelectArea("SA2")
							dbSetOrder(1)
							DbSeek(xFilial("SA2")+SD1->D1_FORNECE+SD1->D1_LOJA)
						EndIf
						
				aadd(aNfVinc,{SD1->D1_EMISSAO,SD1->D1_SERIE,SD1->D1_DOC,IIF(SD1->D1_TIPO $ "DB",IIF(SD1->D1_FORMUL=="S",SM0->M0_CGC,SA1->A1_CGC),IIF(SD1->D1_FORMUL=="S",SM0->M0_CGC,SA2->A2_CGC)),SM0->M0_ESTCOB,SF1->F1_ESPECIE})
					EndIf
				Else
					aOldReg  := SD2->(GetArea())
					aOldReg2 := SF2->(GetArea())
					dbSelectArea("SD2")
					dbSetOrder(3)
					If DbSeek(xFilial("SD2")+(cAliasSD2)->D2_NFORI+(cAliasSD2)->D2_SERIORI+(cAliasSD2)->D2_CLIENTE+(cAliasSD2)->D2_LOJA+(cAliasSD2)->D2_COD+(cAliasSD2)->D2_ITEMORI)
						dbSelectArea("SF2")
						dbSetOrder(1)
						DbSeek(xFilial("SF2")+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA)
						If !SD2->D2_TIPO $ "DB"
							dbSelectArea("SA1")
							dbSetOrder(1)
							DbSeek(xFilial("SA1")+SD2->D2_CLIENTE+SD2->D2_LOJA)
						Else
							dbSelectArea("SA2")
							dbSetOrder(1)
							DbSeek(xFilial("SA2")+SD2->D2_CLIENTE+SD2->D2_LOJA)
						EndIf
						
						aadd(aNfVinc,{SF2->F2_EMISSAO,SD2->D2_SERIE,SD2->D2_DOC,SM0->M0_CGC,SM0->M0_ESTCOB,SF2->F2_ESPECIE})
					EndIf
					RestArea(aOldReg)
					RestArea(aOldReg2)
				EndIf
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Obtem os dados do produto                                               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
			dbSelectArea("SB1")
			dbSetOrder(1)
			DbSeek(xFilial("SB1")+(cAliasSD2)->D2_COD)
						
			cMensFis:=""
			lPedido:=.F.
			cTpFret := ""
			If !Empty((cAliasSD2)->D2_PEDIDO)
				dbSelectArea("SC5")
				dbSetOrder(1)
				if DbSeek(xFilial("SC5")+(cAliasSD2)->D2_PEDIDO)
				
					cTpFret := SC5->C5_TPFRETE
					if SC5->C5_TPFRETE == "C"
						cTpFret := "CIF"
					elseif SC5->C5_TPFRETE == "F"
						cTpFret := "FOB"         
					else
						cTpFret := "   "         
					endif
					
					dbSelectArea("SC6")
					dbSetOrder(1)
					DbSeek(xFilial("SC6")+(cAliasSD2)->D2_PEDIDO+(cAliasSD2)->D2_ITEMPV+(cAliasSD2)->D2_COD)
				
					If !AllTrim(SC5->C5_MENNOTA) $ cMensCli
						cMensCli += AllTrim(SC5->C5_MENNOTA)
					EndIf
					If !Empty(SC5->C5_MENPAD) .And. !AllTrim(FORMULA(SC5->C5_MENPAD)) $ cMensFis
						cMensFis += AllTrim(FORMULA(SC5->C5_MENPAD))
					EndIf			
					lPedido:=.T.
				endif	                
			EndIf     
			 
			aadd(aPed,AllTrim(SA1->A1_CGC))                        //1
			aadd(aPed,AllTrim(SA1->A1_PAIS))                       //2
			aadd(aPed,MyGetEnd(SA1->A1_ENDENT,"SA2")[1])           //3
			aadd(aPed,cMensFis)			                           //4
		
			cMoeda:='GetMV("MV_SIMB'+Alltrim(str(SF2->F2_MOEDA))+'")'
			If(SYF->(Dbseek(xFilial("SYF")+&cMoeda)))              //5
				aadd(aPed,SYF->YF_MOEDA)
			Else
				aadd(aPed,"UYU")                                   //5
		   	EndIf                                           
		   	aadd(aPed,Iif(FieldPos("F2_IDIOMA") > 0,(SF2->F2_IDIOMA),""))                           //6
			aadd(aPed,Iif(SE4->(Dbseek(xFilial("SE4")+SF2->F2_COND)),SE4->E4_FMPAGEX,""))           //7     
			aadd(aPed,SF2->F2_VALMERC)																//8
			aadd(aPed,SC6->C6_NFORI)                                                                //9
			aadd(aPed,SC6->C6_SERIORI)                                                              //10
			aadd(aPed,cTpFret)                                                                      //11
			 

			dbSelectArea(cAliasSD2)	
			While !Eof() .And. xFilial("SD2") == (cAliasSD2)->D2_FILIAL .And.;
				SF2->F2_SERIE == (cAliasSD2)->D2_SERIE .And.;
				SF2->F2_DOC == (cAliasSD2)->D2_DOC                                                     
					
				dbSelectArea("SB1")
				dbSetOrder(1)
				DbSeek(xFilial("SB1")+(cAliasSD2)->D2_COD) 				
    			nX ++
				nValdescU:= 0
				nValddesc:=0
				nPrec:=0
				nTotal:=0
		 		lMuestra := .F.

		 		If GETMV("MV_DESCSAI")=="2" 
		 			nValdescU:= Round((cAliasSD2)->D2_DESCON/(cAliasSD2)->D2_QUANT ,TamSX3("D2_PRCVEN")[2])
		 			nValddesc:=(cAliasSD2)->D2_DESCON       
		 		EndIf  

		 		nPrec   := (cAliasSD2)->D2_PRCVEN+nValdescU 
		 		nTotal  := (cAliasSD2)->D2_TOTAL+nValddesc  
		 		 		
		 		If !IsSF4GFin((cAliasSD2)->D2_TES)
		 			lMuestra := .T.
					aCabNF[14] -= nTotal
				EndIf

		 		aadd(aProd,	{Len(aProd)+1,;	  					   
							SB1->B1_DESC,;    		//2
							(cAliasSD2)->D2_QUANT,; //3
							SB1->B1_UM,; 			//4
							nPrec,; 
							nTotal}) 
				    
					// Basico
				nBAliq:= 0
				nBBas := 0
				nBVal := 0         
				cBClasq:=""
					 //Minimo
				nMAliq:=0
				nMBas :=0
				nMVal :=0   
				cMClasq:=""
					//Exportação
				nEAliq:=0
				nEBas :=0
				nEVal :=0
				cEClasq:=""
					//Outros
				nOAliq:=0
				nOBas :=0
				nOVal :=0
				cOClasq:=""
						
				nPos:=0                  
				    
				    
				For nPos:=1 To Len(aColIVA)  
				
					dbSelectArea("SFC")
					dbSetOrder(2)						
			    		If DbSeek(xFilial("SFC")+(cAliasSD2)->D2_TES+aColIVA[nPos][4])
				
						If aColIVA[nPos][2] == "1"  //Basica
					   		If nBBas =0
				   		   		nBAliq:= &(cAliasSD2+"->D2_ALQIMP"+aColIVA[nPos][1])
					   	   			cBClasq:= aColIVA[nPos][2]
					   		EndIf
					   		nBBas :=nBBas+&(cAliasSD2+"->D2_BASIMP"+aColIVA[nPos][1])
							nBVal :=nBVal+&(cAliasSD2+"->D2_VALIMP"+aColIVA[nPos][1])
						 ElseIf aColIVA[nPos][2] == "2" //Minima
				   			If nMBas=0
				   				nMAliq:=&(cAliasSD2+"->D2_ALQIMP"+aColIVA[nPos][1])
				   				cMClasq:= aColIVA[nPos][2]
							EndIf
				
							nMBas :=nMBas+&(cAliasSD2+"->D2_BASIMP"+aColIVA[nPos][1])
							nMVal :=nMVal+&(cAliasSD2+"->D2_VALIMP"+aColIVA[nPos][1])
						ElseIf aColIVA[nPos][2] $ "345"   //Exportação
							If nEBas=0
								nEAliq:=&(cAliasSD2+"->D2_ALQIMP"+aColIVA[nPos][1])
								cEClasq:= aColIVA[nPos][2]
							EndIf
							nEBas :=nEBas+&(cAliasSD2+"->D2_BASIMP"+aColIVA[nPos][1])
							nEVal :=nEVal+&(cAliasSD2+"->D2_VALIMP"+aColIVA[nPos][1])
						Else
							IF 	nOBas=0
								nOAliq:=&(cAliasSD2+"->D2_ALQIMP"+aColIVA[nPos][1])
								cOClasq:= aColIVA[nPos][2]
						  	EndIf
							nOBas :=nOBas+&(cAliasSD2+"->D2_BASIMP"+aColIVA[nPos][1])
							nOVal :=nOVal+&(cAliasSD2+"->D2_VALIMP"+aColIVA[nPos][1])
						EndIf                   
					EndIf
				Next
						
					
				nAliq:=0
				nBas:=0
				nVal:=0        
				cClas:= "3"
				If 	nBVal>0     
					nAliq:=nBAliq
					nBas :=nBBas
					nVal :=nBVal+nMVal +nEVal 						
					cClas:=cBClasq
				ElseIf nMVal>0
					nAliq:=nMAliq
					nBas :=nMBas
					nVal :=nMVal 
					cClas:=cMClasq
						
				ElseIF nEVal>0
					nAliq:=nEAliq
					nBas :=nEBas
					nVal :=nEVal
					cClas:=cEClasq	
				ElseIF nOVal >0      
					nAliq:=nOAliq
					nBas :=nOBas
					nVal :=nOVal
					cClas:="3"
				EndIf
		  
	           	aadd(aProd[Len(aProd)],cClas) //TPCLASS           //7
		        aadd(aProd[Len(aProd)],nBas)   //8            
		        aadd(aProd[Len(aProd)],nAliq)   //9             
		        aadd(aProd[Len(aProd)],nVal)   //10
		     	aadd(aProd[Len(aProd)],(cAliasSD2)->D2_NFORI)  	//11
				aadd(aProd[Len(aProd)],(cAliasSD2)->D2_SERIORI) //12  
				aadd(aProd[Len(aProd)],(cAliasSD2)->D2_ESPECIE) //13
				aadd(aProd[Len(aProd)],(cAliasSD2)->D2_EMISSAO) //14
				aadd(aProd[Len(aProd)],DescItem(SB1->B1_COD))	//15 
				aadd(aProd[Len(aProd)],(cAliasSD2)->D2_COD) 	//16
	            aadd(aProd[Len(aProd)],(cAliasSD2)->D2_ITEM) 	//17 
	         	aadd(aProd[Len(aProd)],Iif(GETMV("MV_DESCSAI")=="2",0,(cAliasSD2)->D2_DESCON)) //18                
	      		aadd(aProd[Len(aProd)],(cAliasSD2)->D2_TOTAL) 	//19                	      		                   
				aadd(aProd[Len(aProd)],lMuestra)  //20               	      			      							
				aadd(aProd[Len(aProd)],)  //21 
				aadd(aProd[Len(aProd)],)  //22 
				aadd(aProd[Len(aProd)],)  //23 
				aadd(aProd[Len(aProd)],SB1->B1_POSIPI)  //24 

				dbSelectArea(cAliasSD2)
				dbSkip()
			
			EndDo	
	    EndDo
	    
	    If lQuery
	    	dbSelectArea(cAliasSD2)
	    	dbCloseArea()
	    	dbSelectArea("SD2")
	    EndIf
	
	EndIf
Else
	dbSelectArea("SF1")
	dbSetOrder(1)
	If DbSeek(xFilial("SF1")+cNota+cSerie+cClieFor+cLoja)
		aadd(aCabNF,SF1->F1_SERIE)
		aadd(aCabNF,SF1->F1_DOC)                  
		aadd(aCabNF,SF1->F1_EMISSAO)  
		aadd(aCabNF,SF1->F1_COND) 
		Fis57Imp()
                                                   
		nVlIv:=0            
		For nIV := 1 To Len(aColIVA)

			If aColIVA[nIV][2] == "1" //tasa basica
				nTasaBas := aColIVA[nIV][3]   
				nMntTasBas  := &("SF1->F1_VALIMP"+aColIVA[nIV][1])  
				nBasIva  	:= &("SF1->F1_BASIMP"+aColIVA[nIV][1])   
			Elseif aColIVA[nIV][2] == "2" //tasa min
				nTasaMin := aColIVA[nIV][3]
			Endif  	 						
			If  &("SF1->F1_VALIMP"+aColIVA[nIV][1]) > 0
				aadd(aIVA,{&("SF1->F1_VALIMP"+aColIVA[nIV][1]),;
							&("SF1->F1_BASIMP"+aColIVA[nIV][1]),;
								aColIVA[nIV][2],;
								aColIVA[nIV][3],;
								})
			EndIf					
		Next 	       
		aadd(aCabNF,0/*nTasaBas*/)    								// aliq basica
		aadd(aCabNF,0/*nTasaMin*/)    								//aliq min
		aadd(aCabNF,nMntTasBas)  	  								//valor do imposto    7 MntIVATasaBasica
		aadd(aCabNF,nBasIva)	 	  								//base do iva		  8	MntNetoIVATasaBasica	    
		aadd(aCabNF,SF1->F1_FRETE+SF1->F1_DESPESA+SF1->F1_SEGURO)  
		aadd(aCabNF,SF1->F1_ESPECIE) 								//tipo da nota
		aadd(aCabNF,SF1->F1_VALMERC) 								//valor da mercadoria s impostos
		aadd(aCabNF,SF1->F1_VALBRUT-Iif(GETMV("MV_DESCSAI")=="2",0,SF1->F1_DESCONT)	) 							//valor total da nota 
		aadd(aCabNF,SF1->F1_TXMOEDA)	  
		aadd(aCabNF,SF1->F1_BASIMP3)   //14
		aadd(aCabNF,SF1->F1_MENNOTA) //15 
		
		_cSerie := SF1->F1_SERIE          

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Posiciona cliente ou fornecedor                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
			If SF1->F1_TIPO $ "DB|N|C"  .Or. Alltrim(SF1->F1_ESPECIE)=="NCI" .Or. Alltrim(SF1->F1_ESPECIE)=="NCC"  
			    If Alltrim(SF1->F1_ESPECIE)=="NCI"  .And. Alltrim(SF1->F1_TIPO)<>"N" .And.Alltrim(SF1->F1_TIPO)<>"C"
				    dbSelectArea("SA2")
					dbSetOrder(1)
					DbSeek(xFilial("SA2")+SF2->F2_CLIENTE+SF2->F2_LOJA)
					aadd(aDest,AllTrim(SA2->A2_PAIS))
					aadd(aDest,AllTrim(SA2->A2_CGC))
					aadd(aDest,SA2->A2_NOME)					
					aadd(aDest,MyGetEnd(SA2->A2_END,"SA1")[1])
					aadd(aDest,AllTrim(SA2->A2_MUN))
					aadd(aDest,AllTrim(SA2->A2_ESTADO))
			    	aadd(aDest,AllTrim(SA2->A2_TIPO))
					aadd(aDest,"")
					aadd(aDest,"")
					aadd(aDest,"")
					aadd(aDest,"") //Contacto
					
					
					
			    ElseIf (SF1->F1_TIPO $ "N" .AND. Alltrim(SF1->F1_ESPECIE)=="NF") .OR. (SF1->F1_TIPO $ "C" .AND. Alltrim(SF1->F1_ESPECIE)=="NCI")
			    	dbSelectArea("SA2")
					dbSetOrder(1)
					DbSeek(xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA)
					aadd(aDest,AllTrim(SA2->A2_PAIS))
					aadd(aDest,AllTrim(SA2->A2_CGC))
					aadd(aDest,SA2->A2_NOME)					
					aadd(aDest,MyGetEnd(SA2->A2_END,"SA1")[1])
					aadd(aDest,AllTrim(SA2->A2_MUN))
					aadd(aDest,AllTrim(SA2->A2_ESTADO))
			    	aadd(aDest,AllTrim(SA2->A2_TIPO))
					aadd(aDest,"")
					aadd(aDest,"")
					aadd(aDest,"")
					aadd(aDest,"") //Contacto
			    Else		
					dbSelectArea("SA1")
					dbSetOrder(1)
					DbSeek(xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA)
					aadd(aDest,AllTrim(SA1->A1_PAIS))
					aadd(aDest,AllTrim(SA1->A1_CGC))
					aadd(aDest,SA1->A1_NOME)
					aadd(aDest,Alltrim(SA1->A1_END))
					aadd(aDest,AllTrim(SA1->A1_MUN))
					aadd(aDest,AllTrim(SA1->A1_ESTADO))	
					aadd(aDest,AllTrim(SA1->A1_TIPO))
					aadd(aDest,AllTrim(SA1->A1_PESSOA))
					aadd(aDest,Iif(SA1->(FieldPos("A1_VEXP")) >0,AllTrim(SA1->A1_VEXP),"")) 
					aadd(aDest,Iif(SA1->(FieldPos("A1_TP")) >0,AllTrim(SA1->A1_TP),""))		 
					aadd(aDest,"") //Contacto
					
					
				EndIf	
			    	
				dbSelectArea("SD1")
				dbSetOrder(1)	
				#IFDEF TOP
					lQuery  := .T.
					BeginSql Alias cAliasSD1
					SELECT *
					FROM %Table:SD1% SD1
					WHERE
					SD1.D1_FILIAL = %xFilial:SD1% AND
					SD1.D1_SERIE = %Exp:SF1->F1_SERIE% AND 
					SD1.D1_DOC = %Exp:SF1->F1_DOC% AND 
					SD1.D1_FORNECE = %Exp:SF1->F1_FORNECE% AND 
					SD1.D1_LOJA = %Exp:SF1->F1_LOJA% AND 
					SD1.%NotDel%
					ORDER BY %Order:SD1%
				EndSql
					
			#ELSE
				DbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
			#ENDIF
			While !Eof() .And. xFilial("SD1") == (cAliasSD1)->D1_FILIAL .And.;
				SF1->F1_SERIE == (cAliasSD1)->D1_SERIE .And.;
				SF1->F1_DOC == (cAliasSD1)->D1_DOC .And.;
				SF1->F1_FORNECE == (cAliasSD1)->D1_FORNECE .And.;
				SF1->F1_LOJA ==  (cAliasSD1)->D1_LOJA				
	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Verifica as notas vinculadas                                            ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
				If !Empty((cAliasSD1)->D1_NFORI) 
					If !(cAliasSD1)->D1_TIPO $ "DBN"
						aOldReg  := SD1->(GetArea())
						aOldReg2 := SF1->(GetArea())
						dbSelectArea("SD1")
						dbSetOrder(1)
						If DbSeek(xFilial("SD1")+(cAliasSD1)->D1_NFORI+(cAliasSD1)->D1_SERIORI+(cAliasSD1)->D1_FORNECE+(cAliasSD1)->D1_LOJA+(cAliasSD1)->D1_COD+(cAliasSD1)->D1_ITEMORI)
							dbSelectArea("SF1")
							dbSetOrder(1)
							DbSeek(xFilial("SF1")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_TIPO)
							If SD1->D1_TIPO $ "DB"
								dbSelectArea("SA1")
								dbSetOrder(1)
								DbSeek(xFilial("SA1")+SD1->D1_FORNECE+SD1->D1_LOJA)
							Else
								dbSelectArea("SA2")
								dbSetOrder(1)
								DbSeek(xFilial("SA2")+SD1->D1_FORNECE+SD1->D1_LOJA)
							EndIf
							
							aadd(aNfVinc,{SD1->D1_EMISSAO,SD1->D1_SERIE,SD1->D1_DOC,IIF(SD1->D1_TIPO $ "DB",IIF(SD1->D1_FORMUL=="S",SM0->M0_CGC,SA1->A1_CGC),IIF(SD1->D1_FORMUL=="S",SM0->M0_CGC,SA2->A2_CGC)),SM0->M0_ESTCOB,SF1->F1_ESPECIE})
						EndIf
						RestArea(aOldReg)
						RestArea(aOldReg2)
					Else					
						dbSelectArea("SD2")
						dbSetOrder(3)
						If DbSeek(xFilial("SD2")+(cAliasSD1)->D1_NFORI+(cAliasSD1)->D1_SERIORI+(cAliasSD1)->D1_FORNECE+(cAliasSD1)->D1_LOJA+(cAliasSD1)->D1_COD+(cAliasSD1)->D1_ITEMORI)
							dbSelectArea("SF2")
							dbSetOrder(1)
							DbSeek(xFilial("SF2")+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA)
							If !SD2->D2_TIPO $ "DB"
								dbSelectArea("SA1")
								dbSetOrder(1)
								DbSeek(xFilial("SA1")+SD2->D2_CLIENTE+SD2->D2_LOJA)    
							Else
								dbSelectArea("SA2")
								dbSetOrder(1)
								DbSeek(xFilial("SA2")+SD2->D2_CLIENTE+SD2->D2_LOJA)
							EndIf							
							aadd(aNfVinc,{SD2->D2_EMISSAO,SD2->D2_SERIE,SD2->D2_DOC,SM0->M0_CGC,SM0->M0_ESTCOB,SF2->F2_ESPECIE})							
						EndIf
					EndIf				
				EndIf			 				
									 			
				aadd(aPed,AllTrim(SA1->A1_CGC))                
				aadd(aPed,AllTrim(SA1->A1_PAIS))               
				aadd(aPed,MyGetEnd(SA1->A1_ENDENT,"SA2")[1])   
				aadd(aPed,cMensFis)                            
				cMoeda:='GetMV("MV_SIMB'+Alltrim(str(SF1->F1_MOEDA))+'")'
				If(SYF->(Dbseek(xFilial("SYF")+&cMoeda)) )
					aadd(aPed,SYF->YF_MOEDA)       
				Else
					aadd(aPed,"UYU")                 
				EndIf
				aadd(aPed,SF1->F1_IDIOMA)
				aadd(aPed,Iif(SE4->(Dbseek(xFilial("SE4")+SF1->F1_COND)),SE4->E4_FMPAGEX,"")    )  
				aadd(aPed,SF1->F1_VALMERC)   
				aadd(aPed,SC6->C6_NFORI)   
				aadd(aPed,SC6->C6_SERIORI)				
				aadd(aPed,"")
									
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Obtem os dados do produto                                               ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
				aAliasAnt:=GetArea()
				dbSelectArea("SAH")
				dbSetOrder(1)
		        If SAH->(DbSeek(xFilial("SAH")+(cAliasSD1)->D1_UM) )
		        	 cCodUM := AH_CODUMFE
				Else  				
					cCodUM	:=	"98"    
				EndI
			   RestArea(aAliasAnt)
			   
				While (cAliasSD1)->(!Eof()) .And. xFilial("SD1") == (cAliasSD1)->D1_FILIAL .And.;
					SF1->F1_SERIE == (cAliasSD1)->D1_SERIE .And.;
					SF1->F1_DOC == (cAliasSD1)->D1_DOC 
							
					dbSelectArea("SB1")
					dbSetOrder(1)
					DbSeek(xFilial("SB1")+(cAliasSD1)->D1_COD) 				
					nX ++
					nValdescU:= 0
			 		nValddesc:=0
			 		nPrec:=0
			 		nTotal:=0
		 			lMuestra := .F.   
		 			
	 				nValddesc:=(cAliasSD1)->D1_VALDESC
			 		
			 		If GETMV("MV_DESCSAI")=="1" 
			 			nValdescU:= Round(  (cAliasSD1)->D1_VALDESC/(cAliasSD1)->D1_QUANT ,TamSX3("D1_VUNIT")[2])
	 					nValddesc:=(cAliasSD1)->D1_VALDESC
		 			EndIf
			 		
			 		nPrec   :=	(cAliasSD1)->D1_VUNIT-nValdescU 
			 		nTotal  :=	(cAliasSD1)->D1_TOTAL-nValddesc
			
			 		aadd(aProd,	{Len(aProd)+1,;		   				   
								SB1->B1_DESC,;          //2
								(cAliasSD1)->D1_QUANT,; //3
								SB1->B1_UM,;            //4
								nPrec,;
								nTotal})
					
						// Basico
					nBAliq:= 0
					nBBas := 0
					nBVal := 0
					 //Minimo
					nMAliq:=0
					nMBas :=0
					nMVal :=0
					//Exportação
					nEAliq:=0
					nEBas :=0
					nEVal :=0
					//Outros
					nOAliq:=0
					nOBas :=0
					nOVal :=0
						
					nPos:=0                  
				    
				    
					For nPos:=1 To Len(aColIVA)  
				
						dbSelectArea("SFC")
						dbSetOrder(2)						
				    		If DbSeek(xFilial("SFC")+(cAliasSD1)->D1_TES+aColIVA[nPos][4])
				
							If aColIVA[nPos][2] == "1"  //Basica
						   		If nBBas =0
				   			   		nBAliq:= &(cAliasSD1+"->D1_ALQIMP"+aColIVA[nPos][1])
					   		   			cBClasq:= aColIVA[nPos][2]
						   		EndIf
						   		nBBas :=nBBas+&(cAliasSD1+"->D1_BASIMP"+aColIVA[nPos][1])
								nBVal :=nBVal+&(cAliasSD1+"->D1_VALIMP"+aColIVA[nPos][1])
							 ElseIf aColIVA[nPos][2] == "2" //Minima
					   			If nMBas=0
					   				nMAliq:=&(cAliasSD1+"->D1_ALQIMP"+aColIVA[nPos][1])
				   					cMClasq:= aColIVA[nPos][2]
								EndIf
				
								nMBas :=nMBas+&(cAliasSD1+"->D1_BASIMP"+aColIVA[nPos][1])
								nMVal :=nMVal+&(cAliasSD1+"->D1_VALIMP"+aColIVA[nPos][1])
							ElseIf aColIVA[nPos][2] $ "345"   //Exportação
								If nEBas=0
									nEAliq:=&(cAliasSD1+"->D1_ALQIMP"+aColIVA[nPos][1])
									cEClasq:= aColIVA[nPos][2]
								EndIf
								nEBas :=nEBas+&(cAliasSD1+"->D1_BASIMP"+aColIVA[nPos][1])
								nEVal :=nEVal+&(cAliasSD1+"->D1_VALIMP"+aColIVA[nPos][1])
							Else
								IF 	nOBas=0
									nOAliq:=&(cAliasSD1+"->D1_ALQIMP"+aColIVA[nPos][1])
									cOClasq:= aColIVA[nPos][2]
							  	EndIf
								nOBas :=nOBas+&(cAliasSD1+"->D1_BASIMP"+aColIVA[nPos][1])
								nOVal :=nOVal+&(cAliasSD1+"->D1_VALIMP"+aColIVA[nPos][1])
							EndIf                   
						EndIf
					Next

										
				nAliq:=0
				nBas:=0
				nVal:=0    
				cClas:="3"
				
If 	nBVal>0     
						nAliq:=nBAliq
						nBas :=nBBas
						nVal :=nBVal						
						cClas:=cBClasq
					ElseIf nMVal>0
						nAliq:=nMAliq
						nBas :=nMBas
						nVal :=nMVal 
						cClas:=cMClasq
							
					ElseIF nEVal>0
						nAliq:=nEAliq
						nBas :=nEBas
						nVal :=nEVal
						cClas:=cEClasq	
					ElseIF nOVal >0      
						nAliq:=nOAliq
						nBas :=nOBas
						nVal :=nOVal
						cClas:="3"
					EndIf
					
					If !IsSF4GFin((cAliasSD1)->D1_TES)
						lMuestra := .T.
						//Si es muestra resto el valor total de este item (nTotal) del total facturado (aCabNF[12])
						//Eso solo es necesario para SF1/SD1, ya que en SF2 dicha relacion ya se gaurda en F2_VALFAT
						aCabNF[12] -= nTotal
						aCabNF[14] -= nTotal
					EndIf		
						
				
					dbSelectArea("SFC")
					dbSetOrder(2)						
					DbSeek(xFilial("SFC")+(cAliasSD1)->D1_TES)
					If SFC->FC_INCNOTA == '3'
					   nTkBruto ++
					EndIf 
				
		    	    aadd(aProd[Len(aProd)],cClas) //TPCLASS           //7	                    
			        aadd(aProd[Len(aProd)],nBas)  //8
			        aadd(aProd[Len(aProd)],nAliq)  //9
			        aadd(aProd[Len(aProd)],nVal)  //10
		            aadd(aProd[Len(aProd)],(cAliasSD1)->D1_NFORI)	//11
					aadd(aProd[Len(aProd)],(cAliasSD1)->D1_SERIORI) //12
					aadd(aProd[Len(aProd)],(cAliasSD1)->D1_ESPECIE) //13
					aadd(aProd[Len(aProd)],(cAliasSD1)->D1_EMISSAO) //14
					aadd(aProd[Len(aProd)],DescItem(SB1->B1_COD))	//15 
					aadd(aProd[Len(aProd)],(cAliasSD1)->D1_COD) 	//16
		            aadd(aProd[Len(aProd)],(cAliasSD1)->D1_ITEM) 	//17
		            aadd(aProd[Len(aProd)],Iif(GETMV("MV_DESCSAI")=="2",0,(cAliasSD1)->D1_VALDESC)) 	//18                  		
		      		aadd(aProd[Len(aProd)],(cAliasSD1)->D1_TOTAL) 	//19 
					aadd(aProd[Len(aProd)],lMuestra)  //20  
					aadd(aProd[Len(aProd)],)  //21 
					aadd(aProd[Len(aProd)],)  //22 
					aadd(aProd[Len(aProd)],)  //23 
					aadd(aProd[Len(aProd)],SB1->B1_POSIPI)  //24 	      		               
		      		
					dbSelectArea(cAliasSD1)
					dbSkip()
				
				EndDo
		    EndDo
		    If lQuery
		    	dbSelectArea(cAliasSD1)
		    	dbCloseArea()
		    	dbSelectArea("SD1")
		    EndIf     
		EndIf
	EndIf
EndIf   
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função que gera a string com conteúdo do XML.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(aCabNF)
	aXML := GeraXML(aCabNF,aDest,aPed,aProd,Paramixb[1],cMensCli,nTkBruto)
EndIf

Return(aXML)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GeraXML ºAutor  ³Camila Januário      º Data ³  28/01/2013  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera string com conteúdo XML                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Nota Fiscal Elet. Uruguai				         		  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GeraXML(aCabNf,aDest,aPed,aProd,cTipo,cMensCli,nTkBruto) 

Local cString    	:= ""
Local cData      	:= ""
Local cEspeci    	:= IIf(!Empty(Alltrim(aCabNF[10])),Alltrim(aCabNF[10]),"")
Local cTipoCli   	:= IIf(!Empty(Alltrim(aDest[7])),Alltrim(aDest[7]),"")	
Local cTipoEx		:= IIf(!Empty(Alltrim(aDest[9])),Alltrim(aDest[9]),"1") 	// Dentro ou Fora do Pais  
Local cTipoCliEx	:= IIf(!Empty(Alltrim(aDest[10])),Alltrim(aDest[10]),"")	// Tipo cliente: 2=RUC, 3=C.I., 5=Pasaporte, 6=DNI
Local cNfOri 	   	:=	""
Local cSerOri    	:= ""
Local cNfOriPe	:=	""
Local cNfSerPe   	:= ""
Local cNotUsa	 	:= ""
Local cTxMoeda	:= ""
Local cTipoFac	:=	""
Local cRef			:= ""  
Local cRef1			:= ""
Local cRefglob   	:= ""
Local cValMoeda	:= GETMV("MV_VALMOIU") // Parametro com a informação de onde esta cadastrado a Moeda UI 
Local cSucursal  	:= GETMV("MV_URUSUCU") // Código registrado na DGI, associado ao RUC emissor 
Local cPDV	  	 	:= GETMV("MV_RONDAIN") //Parametro referente a instalação do RondaNet 
Local lCont  	 	:= GETMV("MV_URUCONT") //Parametro referente a Contingencia da nota do Uruguai  
	
	
Local nExento	:= 0
Local nContiten	:= 0	
Local nX 		 	:= 0
Local nY		 	:= 0
Local nValCon   	:= 0
Local nTxMoeda	:= 0 
Local nTxMoeUI	:= 0	
Local aXML       	:= {}
Local aRetMntIV  	:= {}
Local aNfOri	 	:= {}
Local aConX		:= StrTokArr (GETMV("MV_URUCONX"),",",.T.) 
Local aTempArea	:= {}
Local aDadosCae	:= {}
Local cAliasSE1     := "cAliSE1"
Local cAliasSE2     := "cAliSE2"
Local cRefNoElec    := "Facturas Asociadas: "  
Local bFacNoElec    := .F.
 
Local aNfaProd 	    := {}	
Local ni:=1
Local cTpoTrans		:= ""
 	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Faz a busca do valor exento no livro fiscal ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	nExento := aCabNF[12]
	/*Soma totais de Impostos IVA*/
	aRetMntIV := SomaMntIV(aProd,cEspeci)


	cData := FsDateConv(Date(),"YYYYMMDD")
	cData := SubStr(cData,1,4)+"-"+SubStr(cData,5,2)+"-"+SubStr(cData,7)+"T"+Time()+"-03:00"                                                  
	cString := '<?xml version="1.0" encoding="UTF-8"?><ns0:CFE_Adenda xmlns:ns0="http://cfe.dgi.gub.uy" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://cfe.dgi.gub.uy CFEEmpresas_v1.15.xsd "><ns0:CFE version="1.0" xmlns:ns0="http://cfe.dgi.gub.uy">
	
	if cTipoCli $ "345"  .and.  cTipoEx == "1" 		//Extrangeiro e compra fora do pais 
		If alltrim(aCabNF[10]) == "RFN"
			cString +="<ns0:eRem_Exp>"
		Else
			cString +="<ns0:eFact_Exp>"
		Endif
	ElseIf cTipoCli $ "345"  .and.  cTipoEx == "2" 	//Extrangeiro e compra dentro do pais 
		If alltrim(aCabNF[10]) == "RFN"
			cString +="<ns0:eRem>"
		else
			cString +="<ns0:eTck>"
		Endif			
	ElseIf cTipoCli <> "2"
		If alltrim(aCabNF[10]) == "RFN"
			cString +="<ns0:eRem>"	       
		Else
			cString +="<ns0:eFact>"	
		Endif
	Else
		if alltrim(aCabNF[10]) == "RFN"
			cString +="<ns0:eRem>"       
		else
			cString +="<ns0:eTck>"                             
		endif
	Endif	
	cString +="<ns0:TmstFirma>"+cData+"</ns0:TmstFirma>"
	cString +="<ns0:Encabezado>"
	cString +="<ns0:IdDoc>"
	cString+="<ns0:TipoCFE>"+RetTpCbte(aCabNF[10],cTipoCli,cTipoEx)+"</ns0:TipoCFE>"   
	If alltrim(aCabNF[10]) == "RFN"                                            
		cString+="<ns0:Serie>"+Alltrim(SubStr(aCabNF[1],2,1))+"</ns0:Serie>"         
	else
		cString+="<ns0:Serie>"+Alltrim(SubStr(aCabNF[1],2))+"</ns0:Serie>"         
	Endif
	cString+="<ns0:Nro>"+aCabNF[2]+"</ns0:Nro>"             
   	cString+="<ns0:FchEmis>"+RetFormDat(aCabNF[3])+"</ns0:FchEmis>"
   	If alltrim(aCabNF[10]) == "RFN"                                            
   	   	cString+="<ns0:TipoTraslado>"+IIF(Empty(cTpoTrans),"1",cTpoTrans)+"</ns0:TipoTraslado>"
   	Endif
   	If cTipoCli == "2" .AND. nTkBruto > 0
   		cString+="<ns0:MntBruto>1</ns0:MntBruto>"
   	Endif 
    
	cCodDocT := RetTpCbte(aCabNF[10],cTipoCli,cTipoEx)
    
	If !Empty(aCabNF[4]) 
		cString+="<ns0:FmaPago>"+RetCondPg(aCabNF[4])+"</ns0:FmaPago>"
	Endif

	If cTipo == "1" .or. cTipo == "2"
			
			If ALLTRIM(cEspeci) == "NCC"
				cSerie   :=SF1->F1_SERIE
				cDoc     :=SF1->F1_DOC
				cCliente :=SF1->F1_FORNECE
				cLoja    :=SF1->F1_LOJA 
			Else


				cSerie   :=SF2->F2_SERIE
				cDoc     :=SF2->F2_DOC
				cCliente :=SF2->F2_CLIENTE
				cLoja    :=SF2->F2_LOJA 
			Endif
			
			BeginSql Alias cAliasSE1
				SELECT E1_VENCTO FROM %Table:SE1% SE1
				WHERE
				SE1.E1_FILIAL = %xFilial:SE1% AND
				SE1.E1_PREFIXO = %Exp:cSerie% AND 
				SE1.E1_NUM = %Exp:cDoc% AND 
				SE1.E1_CLIENTE = %Exp:cCliente% AND 
				SE1.E1_LOJA = %Exp:cLoja% AND 
				SE1.%NotDel%
				ORDER BY %Order:SE1%
			EndSql
		
			If !(cAliasSE1)->(EOF())
	    		cString+="<ns0:FchVenc>"+StrZero(Year(STOD((cAliasSE1)->E1_VENCTO)),4)+"-"+StrZero(Month(STOD((cAliasSE1)->E1_VENCTO)),2)+"-"+StrZero(Day(STOD((cAliasSE1)->E1_VENCTO)),2)+"</ns0:FchVenc>"
	    	Endif
	    	
	    	(cAliasSE1)->(DbCloseArea())
	 	

	Else 
		BeginSql Alias cAliasSE2
				SELECT E2_VENCTO FROM %Table:SE2% SE2
				WHERE
				SE2.E2_FILIAL = %xFilial:SE2% AND


				SE2.E2_PREFIXO = %Exp:SF1->F1_SERIE% AND 
				SE2.E2_NUM = %Exp:SF1->F1_DOC% AND 
				SE2.E2_FORNECE = %Exp:SF1->F1_FORNECE% AND 
				SE2.E2_LOJA = %Exp:SF1->F1_LOJA% AND 
				SE2.%NotDel%
				ORDER BY %Order:SE2%
			EndSql
		
			If !(cAliasSE2)->(EOF())
	    		cString+="<ns0:FchVenc>"+StrZero(Year(STOD(DTOS(SE2->E2_VENCTO))),4)+"-"+StrZero(Month(STOD(DTOS(SE2->E2_VENCTO))),2)+"-"+StrZero(Day(STOD(DTOS(SE2->E2_VENCTO))),2)+"</ns0:FchVenc>"
	 		Endif                       
	 		
	    	(cAliasSE2)->(DbCloseArea())

	Endif	
	//Dados somente para exportacao
	If cTipoCliEx $ "4|5|6"  .and.  cTipoEx <> "1" 
		cString+="<ns0:ModVenta>90</ns0:ModVenta>"
	Endif
	
	//Dados somente para exportacao
	If cTipoCli $ "345" .AND. cTipoEx == "1"

		If ALLTRIM(cEspeci) == "NF"		
			cString+="<ns0:ClauVenta>"+IIF(!EMPTY(aPed[13]),aPed[13],"N/A")+"</ns0:ClauVenta>"
		Else
			cString+="<ns0:ClauVenta>N/A</ns0:ClauVenta>"	
		Endif
			cString+="<ns0:ModVenta>1</ns0:ModVenta>"
		If ALLTRIM(cEspeci) == "NF"		
			cString+="<ns0:ViaTransp>"+aPed[14]+"</ns0:ViaTransp>"
		Else
			cString+="<ns0:ViaTransp>8</ns0:ViaTransp>"		
		Endif
	Endif
	

	cString+="</ns0:IdDoc>"                                                                  
	cString+="<ns0:Emisor>"
	cString+="<ns0:RUCEmisor>"+Alltrim(SM0->M0_CGC)+"</ns0:RUCEmisor>"
	cString+="<ns0:RznSoc>"+Convtype(Alltrim(SM0->M0_NOMECOM))+"</ns0:RznSoc>"
	cString+="<ns0:CdgDGISucur>"+IIF(!Empty(cSucursal),cSucursal,Convtype(Alltrim(Strtran(SM0->M0_CODFIL,"0"))))+"</ns0:CdgDGISucur>"
	cString+="<ns0:DomFiscal>"+Convtype(Alltrim(SM0->M0_ENDENT))+"</ns0:DomFiscal>"
	cString+="<ns0:Ciudad>"+Convtype(Alltrim(SM0->M0_CIDENT))+"</ns0:Ciudad>"
	cString+="<ns0:Departamento>"+Convtype(RetProvin(Alltrim(SM0->M0_ESTENT)))+"</ns0:Departamento>"
	cString+="</ns0:Emisor>"
	cString+="<ns0:Receptor>" 
    If aDest[7] == "3" .And. cTipoCliEx =="6" 		// DNI
   		cString+="<ns0:TipoDocRecep>6</ns0:TipoDocRecep>"
    Elseif aDest[7] == "3" .And. cTipoCliEx =="5" //Pasaporte
   		cString+="<ns0:TipoDocRecep>5</ns0:TipoDocRecep>"
    Elseif aDest[7] == "3" .And. cTipoCliEx =="4"	//Otros
   		cString+="<ns0:TipoDocRecep>4</ns0:TipoDocRecep>"                                      
    elseif aDest[7] == "2" .And. cTipoCliEx =="4"	//Otros
		cString+="<ns0:TipoDocRecep>4</ns0:TipoDocRecep>"    		   				
    elseif cTipo == "1" .And. !Empty(aDest[8]) 	
		cString+="<ns0:TipoDocRecep>"+IIF(Alltrim(aDest[8])=="J","2","3")+"</ns0:TipoDocRecep>"   
    ElseIF cTipo == "2" .And. (cEspeci $ "NCC")
		cString+="<ns0:TipoDocRecep>"+IIF(Alltrim(aDest[8])=="J","2","3")+"</ns0:TipoDocRecep>"
	Else
		cString+="<ns0:TipoDocRecep>2</ns0:TipoDocRecep>" 
	Endif
	cString+="<ns0:CodPaisRecep>"+RetCodPais(aDest[1])+"</ns0:CodPaisRecep>"   
	if aDest[7] == "3" .OR. (aDest[7] == "2" .And. cTipoCliEx =="4")
		cString+="<ns0:DocRecepExt>"+aDest[2]+"</ns0:DocRecepExt>"
	else	
		cString+="<ns0:DocRecep>"+aDest[2]+"</ns0:DocRecep>"
	endif	
	cString+="<ns0:RznSocRecep>"+Convtype(aDest[3])+"</ns0:RznSocRecep>" 
	If cTipoCli <> "2"
		cString+="<ns0:DirRecep>"+Convtype(aDest[4])+"</ns0:DirRecep>"
		cString+="<ns0:CiudadRecep>"+Convtype(aDest[5])+"</ns0:CiudadRecep>"			
		cString+="<ns0:DeptoRecep>"+Convtype(aDest[6])+"</ns0:DeptoRecep>"
		cString+="<ns0:PaisRecep>"+Convtype(RetCodPais(aDest[1],.T.))+"</ns0:PaisRecep>"
    Endif
	cString+="</ns0:Receptor>"
	cString+="<ns0:Totales>"
	
	If alltrim(aCabNF[10]) <> "RFN"  
		cString+="<ns0:TpoMoneda>"+Alltrim(aPed[5])+"</ns0:TpoMoneda>" 
		If Alltrim(aPed[5]) <> "UYU"
			cTxMoeda := IIF(cTipo=="1",SF2->F2_MOEDA,SF1->F1_MOEDA)
	
			DbSelectArea("SM2")
			DbSetOrder(1)
			If DbSeek(IIF(cTipo=="1",SF2->F2_EMISSAO,SF1->F1_EMISSAO))
				nTxMoeda := &("SM2->M2_MOEDA"+CVALTOCHAR(cTxMoeda))	
				cString+="<ns0:TpoCambio>"+Alltrim (Transform(nTxMoeda,"@! 9999.999"))+"</ns0:TpoCambio>" 
			Endif
			dbCloseArea()
		EndIf
		
		if cTipoEx <> "1"	
			If aRetMntIV[14] > 0 																				//Isento			
				If nExento = 0
					If aRetMntIV[1] > 0 .And. aRetMntIV[2] > 0.And. aRetMntIV[2] > 0 .And. aRetMntIV[4] > 0          // Iva 10 e 22 na mesma Nota 
						nTotRest := aRetMntIV[3]+aRetMntIV[1]
					ElseIf !aRetMntIV[1] > 0 .And. !aRetMntIV[2] > 0 .And. !aRetMntIV[2] > 0 .And. !aRetMntIV[4] > 0 // Iva 0 e Isento na mesma Nota 
						nTotRest := aRetMntIV[6]+aRetMntIV[7]
					ElseIf aRetMntIV[12] > 0  																	 	 // Iva Basica			
						nTotRest := aRetMntIV[1]+aRetMntIV[2]
					ElseIf aRetMntIV[2] > 0    																	 // Iva Minima		
						nTotRest := aRetMntIV[2]
					Else				                                                                             // Outros 
						nTotRest := aRetMntIV[3]+aRetMntIV[1]
					EndIf
				
					nExento := aCabNf[12] - nTotRest
				Endif	
				
				cString+="<ns0:MntNoGrv>"+Convtype(nExento,15,2)+"</ns0:MntNoGrv>"
			Else 
				cString+="<ns0:MntNoGrv>0</ns0:MntNoGrv>"
			EndIF
		endif
		
		If  cTipoEx == "1"  	
																		//Exportacion 
			cString+="<ns0:MntExpoyAsim>"+Convtype(aCabNf[12],15,2)+"</ns0:MntExpoyAsim>"

		endif
		
		if !cTipoCli $ "345"	
			cString+="<ns0:MntImpuestoPerc>0</ns0:MntImpuestoPerc>"
				
			If aRetMntIV[16] > 0 																				//Suspenso     
				cString+="<ns0:MntIVaenSusp>"+Convtype(nExento,15,2)+"</ns0:MntIVaenSusp>"
			Else
				cString+="<ns0:MntIVaenSusp>0</ns0:MntIVaenSusp>" 
			EndIF			
			If aRetMntIV[1] > 0 .And. aRetMntIV[2] > 0 .And. aRetMntIV[2] > 0 .And. aRetMntIV[4] > 0 			// Iva 10 e 22 na mesma Nota 
				cString+="<ns0:MntNetoIvaTasaMin>"+Convtype(aRetMntIV[4],15,2)+"</ns0:MntNetoIvaTasaMin>"
				cString+="<ns0:MntNetoIVATasaBasica>"+Convtype(aRetMntIV[2],15,2)+"</ns0:MntNetoIVATasaBasica>"				
			ElseIf !aRetMntIV[1] > 0 .And. !aRetMntIV[2] > 0 .And. !aRetMntIV[2] > 0 .And. !aRetMntIV[4] > 0 	// Iva 0 e Isento na mesma Nota 
				cString+="<ns0:MntNetoIvaTasaMin>"+Convtype(aRetMntIV[6],15,2)+"</ns0:MntNetoIvaTasaMin>"	
				cString+="<ns0:MntNetoIVATasaBasica>"+Convtype(aRetMntIV[7],15,2)+"</ns0:MntNetoIVATasaBasica>"   
			ElseIf aRetMntIV[12] > 0  																			// Iva Basica			
				cString+="<ns0:MntNetoIvaTasaMin>"+Convtype(aRetMntIV[4],15,2)+"</ns0:MntNetoIvaTasaMin>"	
				cString+="<ns0:MntNetoIVATasaBasica>"+Convtype(aRetMntIV[2],15,2)+"</ns0:MntNetoIVATasaBasica>"			
			ElseIf aRetMntIV[13] > 0  																			// Iva Minima
				cString+="<ns0:MntNetoIvaTasaMin>"+Convtype(aRetMntIV[4],15,2)+"</ns0:MntNetoIvaTasaMin>"	
				cString+="<ns0:MntNetoIVATasaBasica>"+Convtype(aRetMntIV[2],15,2)+"</ns0:MntNetoIVATasaBasica>"
			Else			                                                                                    //Outros
				cString+="<ns0:MntNetoIvaTasaMin>"+Convtype(aRetMntIV[4],15,2)+"</ns0:MntNetoIvaTasaMin>"	
				cString+="<ns0:MntNetoIVATasaBasica>"+Convtype(aRetMntIV[2],15,2)+"</ns0:MntNetoIVATasaBasic	
			Endif        			
			cString+="<ns0:MntNetoIVAOtra>0</ns0:MntNetoIVAOtra>"
			cString+="<ns0:IVATasaMin>"+Convtype(10,15,2)+"</ns0:IVATasaMin>"                       		
			cString+="<ns0:IVATasaBasica>"+Convtype(22,15,2)+"</ns0:IVATasaBasica>"    
			If aRetMntIV[1] > 0 .And. aRetMntIV[2] > 0.And. aRetMntIV[2] > 0 .And. aRetMntIV[4] > 0          // Iva 10 e 22 na mesma Nota 
				cString+="<ns0:MntIVATasaMin>"+Convtype(aRetMntIV[3],15,2)+"</ns0:MntIVATasaMin>"
				cString+="<ns0:MntIVATasaBasica>"+Convtype(aRetMntIV[1],15,2)+"</ns0:MntIVATasaBasica>"
			ElseIf !aRetMntIV[1] > 0 .And. !aRetMntIV[2] > 0 .And. !aRetMntIV[2] > 0 .And. !aRetMntIV[4] > 0 // Iva 0 e Isento na mesma Nota 
				cString+="<ns0:MntIVATasaMin>"+Convtype(aRetMntIV[6],15,2)+"</ns0:MntIVATasaMin>"  
				cString+="<ns0:MntIVATasaBasica>"+Convtype(aRetMntIV[7],15,2)+"</ns0:MntIVATasaBasica>"
			ElseIf aRetMntIV[12] > 0  																	 	 // Iva Basica			
				cString+="<ns0:MntIVATasaMin>"+Convtype(aRetMntIV[3],15,2)+"</ns0:MntIVATasaMin>"  
				cString+="<ns0:MntIVATasaBasica>"+Convtype(aRetMntIV[1],15,2)+"</ns0:MntIVATasaBasica>"			
			ElseIf aRetMntIV[13] > 0    																	 // Iva Minima		
				cString+="<ns0:MntIVATasaMin>"+Convtype(aRetMntIV[3],15,2)+"</ns0:MntIVATasaMin>"  
				cString+="<ns0:MntIVATasaBasica>"+Convtype(aRetMntIV[1],15,2)+"</ns0:MntIVATasaBasica>"
			Else				                                                                             // Outros 
				cString+="<ns0:MntIVATasaMin>"+Convtype(aRetMntIV[3],15,2)+"</ns0:MntIVATasaMin>"      
				cString+="<ns0:MntIVATasaBasica>"+Convtype(aRetMntIV[1],15,2)+"</ns0:MntIVATasaBasica>" 				  
			EndIf
		endif	
		
		/*******************************************************************************************/
		/*  Agrego el iva para los casos que sea un cliente del exterior pero se factura con iva   */
		/*******************************************************************************************/
		If cTipoCli $ "345"  .and.  cTipoEx == "2"	
			nITBasi:= 0
			nITMini:= 0
			nVTBasi:= 0
			nVTMini:= 0
			For ni:=1 to Len(aIVA)
				if ALLTRIM(aIVA[ni][3]) == "1"  //Tasa Basica
					nITBasi := aIVA[ni][1]                   
					nVTBasi := aIVA[ni][2]                   
				elseif ALLTRIM(aIVA[ni][3]) == "2"  //Tasa Minima
					nITMini := aIVA[ni][1]                       
					nVTMini := aIVA[ni][2]
				endif
			Next ni
			cString+="<ns0:MntNetoIvaTasaMin>"+cValToChar(nVTMini)+"</ns0:MntNetoIvaTasaMin>"	
			cString+="<ns0:MntNetoIVATasaBasica>"+cValToChar(nVTBasi)+"</ns0:MntNetoIVATasaBasica>"   
			cString+="<ns0:IVATasaMin>"+Convtype(10,15,2)+"</ns0:IVATasaMin>"                       		
			cString+="<ns0:IVATasaBasica>"+Convtype(22,15,2)+"</ns0:IVATasaBasica>"    		
			cString+="<ns0:MntIVATasaMin>"+cValToChar(nITMini)+"</ns0:MntIVATasaMin>"
			cString+="<ns0:MntIVATasaBasica>"+cValToChar(nITBasi)+"</ns0:MntIVATasaBasica>"
		Endif
		
		cString+="<ns0:MntTotal>"+Convtype(aCabNf[12],15,2)+"</ns0:MntTotal>"                                             	
	Endif	
	
	cString+="<ns0:CantLinDet>"+Alltrim(Str(Len(aProd)))+"</ns0:CantLinDet>"
	
	If alltrim(aCabNF[10]) <> "RFN"  
		If !cEspeci $ "NCC|NCI|NCE|NDC|NDI|NDE|NCP|NDP" .And. cTipoCli <> "2"
			If !aRetMntIV[2] > 0 .And. !aRetMntIV[4] > 0 .And. !aRetMntIV[1] > 0 .And. !aRetMntIV[3] > 0
			  cString+="<ns0:MontoNF>0</ns0:MontoNF>"
			ElseIf aRetMntIV[14] > 0
			  cString+="<ns0:MontoNF>0</ns0:MontoNF>"
			ElseIf aRetMntIV[15] > 0
			  cString+="<ns0:MontoNF>0</ns0:MontoNF>"
			ElseIf aRetMntIV[16] > 0
			  cString+="<ns0:MontoNF>0</ns0:MontoNF>"
			Else
			  cString+="<ns0:MontoNF>"+Convtype(nExento,15,2)+"</ns0:MontoNF>" 
			EndIF
		EndIf
			
		cString+="<ns0:MntPagar>"+Convtype(aCabNf[12],15,2)+"</ns0:MntPagar>" 
	Endif
	
	cString+="</ns0:Totales>"		
	cString+="</ns0:Encabezado>"
	cString+="<ns0:Detalle>" 	
	For Nx := 1 to Len(aProd)
		cString+="<ns0:Item>"                                                 
			nContiten := nX
			cString+="<ns0:NroLinDet>"+Alltrim(Str(nContiten))+"</ns0:NroLinDet>"   
		   
			cPrdCod := aProd[nX][16]
		    cCodTotvs := Posicione("SB1",1,xFilial("SB1")+cPrdCod,"B1_COD") 	
		    cCodEan := Posicione("SB1",1,xFilial("SB1")+cPrdCod,"B1_CODBAR")
            
			//Codigo INT1
			cString+="<ns0:CodItem>"
			cString+="<ns0:TpoCod>INT1</ns0:TpoCod>"
			cString+="<ns0:Cod>"+Convtype(Alltrim(cCodTotvs))+"</ns0:Cod>"	
			cString+="</ns0:CodItem>"		
			//Codigo EAN	
			If !Empty(cCodEan)
			cString+="<ns0:CodItem>"
			cString+="<ns0:TpoCod>EAN</ns0:TpoCod>"
			cString+="<ns0:Cod>"+Convtype(Alltrim(cCodEan))+"</ns0:Cod>"	
			cString+="</ns0:CodItem>"	
			EndIf
			
			cIndFact:=""
			
		    If aProd[nX][20]
				cIndFact:="5"	    
		  	ElseIf cTipoCli $ "345" .and.  cTipoEx == "1" 
		   	 	cIndFact:="10"
		    Else              
		   		cIndFact:=Str(RetIndFact(aProd[nX][7],aProd[nX][8],aProd[nX][9],aProd[nX][10]))
			EndIf
			cString+="<ns0:IndFact>"+Alltrim(cIndFact)+"</ns0:IndFact>"			
			cString+="<ns0:NomItem>"+Alltrim(aProd[nX][2])+"</ns0:NomItem>"
			If aProd[nX][20]// MAF Si es muestra
				cString+="<ns0:DscItem> Precio "+Convtype(aProd[nX][5],15,2)+"</ns0:DscItem>
			EndIf
			If cTipoCli == "3" .AND. cTipoEx == "1"
				cString+="<ns0:NCM>"+Convtype(Alltrim(aProd[nX][24]))+"</ns0:NCM>"
            Endif
			If ExistBlock("FIS57XML")
				cString+= ExecBlock("FIS57XML",.F.,.F.,{1,aProd,nX,aDest,aCabNF,aPed,aRetMntIV,cTipo,cString})  //A primeira posição é para ordenar em qual parte do XML o pronto de entrada vai atuar
			EndIf		
			cString+="<ns0:Cantidad>"+Alltrim(Str(aProd[nX][3]))+"</ns0:Cantidad>"
			cString+="<ns0:UniMed>"+aProd[nX][4]+"</ns0:UniMed>"
			If alltrim(aCabNF[10]) <> "RFN"
				If aProd[nX][20] // MAF Si es muestra
					cString+="<ns0:PrecioUnitario>0</ns0:PrecioUnitario>" 
				Else
					cString+="<ns0:PrecioUnitario>"+Convtype(aProd[nX][5],15,2)+"</ns0:PrecioUnitario>" 
				EndIf
				cString+="<ns0:DescuentoPct>0</ns0:DescuentoPct>"
				cString+="<ns0:DescuentoMonto>0</ns0:DescuentoMonto>"
				cString+="<ns0:RecargoPct>0</ns0:RecargoPct>"
				cString+="<ns0:RecargoMnt>0</ns0:RecargoMnt>"
				If aProd[nX][20] // MAF Si es muestra
					cString+="<ns0:MontoItem>0</ns0:MontoItem>"  
				Else
					cString+="<ns0:MontoItem>"+Convtype(aProd[nX][6],15,2)+"</ns0:MontoItem>"  
				EndIf
			Endif
		cString+="</ns0:Item>"			
	Next Nx			
	cString+="</ns0:Detalle>"   
	
	cRefNoElec := "Facturas Asociadas: "
	aNfaProd := {}
	   	
	If (cEspeci $ "NCC|NCI|NDE|NCP") .And. (cTipo <> "1")	//Comprobantes de entrada
		cString+="<ns0:Referencia>"	
		
	 	For nY :=1 to len (aProd)	 	                           
	 		cNfOri   :=(aprod[nY][11])                                      
	 		cSerOri  :=(aprod[nY][12])
	 		cNfOriPe :=(aPed[9])
	 		cNfSerPe :=(aPed[10])			 		
	 		
	 		If nY == 1
				If !Empty(cMensCli)
				  	cString+="<ns0:Referencia>"
					cString+="<ns0:NroLinRef>"+Alltrim(Str(nY))+"</ns0:NroLinRef>"
					cString+="<ns0:IndGlobal>1</ns0:IndGlobal>"
					cString+="<ns0:RazonRef></ns0:RazonRef>"				
				  	cString+="</ns0:Referencia>"   
				  	exit  //Me voy del for porque sólo puede haber una referencia global				 
				EndIf
				If ExistBlock("FIS57XML")
					cRefglob := ExecBlock("FIS57XML",.F.,.F.,{2,aProd,nY,aDest,aCabNF,aPed,aRetMntIV,cTipo,cString}) //A primeira posição é para ordenar em qual parte do XML o pronto de entrada vai atuar
					If	!Empty(cRefglob)	
						cString+="<ns0:Referencia>"
						cString+="<ns0:NroLinRef>"+Alltrim(Str(nY))+"</ns0:NroLinRef>"
						cString+="<ns0:IndGlobal>1</ns0:IndGlobal>" 
						cString += cRefglob						
						cString+="</ns0:Referencia>"   
						exit  //Me voy del for porque sólo puede haber una referencia global				
					Endif
				EndIf  
				If CompRef(aprod) == 0 .Or. CompRef(aprod) > 40
					cString+="<ns0:Referencia>"
					cString+="<ns0:NroLinRef>"+Alltrim(Str(nY))+"</ns0:NroLinRef>"
					cString+="<ns0:IndGlobal>1</ns0:IndGlobal>"
					cString+="<ns0:RazonRef>Aplica sobre facturas varias</ns0:RazonRef>"
				  	cString+="</ns0:Referencia>"
				  	exit  //Me voy del for porque sólo puede haber una referencia global
				Endif
			Endif
			
			If Empty(cRefGlob) .And. Empty(cMensCli)
			 	If (!empty(aProd[nY][12]) .And. !empty(aprod[nY][11])) .Or. (!empty (cNfSerPe) .And. !empty (cNfOriPe)) 					
				   	aadd(aNfOri,{cNfOri,cSerOri})
					aadd(aNfOri,{cNfOriPe,cNfSerPe})
					IF	!Empty(cNfOri)
						cNotUsa +=(Alltrim(aprod[nY][12])+(aprod[nY][11]))+"|"    
				 	Else 
				 	    cNotUsa +=(Alltrim(cNfSerPe)+(cNfOriPe))+"|"
				 	Endif			 	
					
					//Nota Referenciada
					If CompRef(aprod) <= 40 .And. (!Empty(cNfOri) .Or. !Empty(cNfOriPe))   			
						dbSelectArea("SF2")
						SF2->(dbSetOrder(1))
						if SF2->(dbSeek(xFilial("SF2")+cNfOri+cSerOri))  
							if ASCAN(aNfaProd, { |x| ALLTRIM(x[3]) == ALLTRIM(SF2->F2_CAEE) } ) == 0 //HRC
								
								//Genero el listado de facturas referenciadas para el caso de que haya que informar mediante referencia global
								//por haber entre las facturas referenciadas alguna factura no electrónica.
									if nY > 1
										cRefNoElec += "/"  
									endif
								
									cRefNoElec += cRef1
								
																								
								
								If !Empty(SF2->F2_CODDOC)							
									cRef+="<ns0:Referencia>"
									cRef+="<ns0:NroLinRef>"+Alltrim(Str(nY))+"</ns0:NroLinRef>"
									cRef+="<ns0:TpoDocRef>"+Alltrim(SF2->F2_CODDOC)+"</ns0:TpoDocRef>"
									cRef+="<ns0:Serie>"+Alltrim(SF2->F2_SERCAE)+"</ns0:Serie>"
									cRef+="<ns0:NroCFERef>"+Alltrim(SF2->F2_CAEE)+"</ns0:NroCFERef>"
									cRef+="</ns0:Referencia>"
								Else
									//Si encuentro una factura referenciada que no es electrónica, coloco referencia global.
									bFacNoElec := .T.
								Endif 
								
								//Agrego la Factura para Referencia
					 			AADD(aNfaProd,{aprod[nY][11],aprod[nY][12],SF2->F2_CAEE})	
					 			
							endif
						Endif						
						
					EndIf
				Endif				
			EndIf
		Next nY
		
		//Si hubieron facturas no electrónicas, coloco la referencia global para facturas no electrónicas
		//Si no, coloco la referencia no global.
		if bFacNoElec
			cString+="<ns0:Referencia>"
			cString+="<ns0:NroLinRef>1</ns0:NroLinRef>"
			cString+="<ns0:IndGlobal>1</ns0:IndGlobal>"
			cString+="<ns0:RazonRef>"+ cRefNoElec + "</ns0:RazonRef>"
			cString+="</ns0:Referencia>"
		else
			cString+= cRef
		endif
		
		cString+="</ns0:Referencia>"
	ElseIf (cEspeci $ "NDC|NDI|NCE|NDP")		//Comprobantes de salida
		cString+="<ns0:Referencia>"		
		For nY :=1 to len (aProd)	 	  
	 		cNfOri   :=(aProd[nY][11])       
	 		cSerOri  :=(aProd[nY][12])                        
	 		cNfOriPe :=(aPed[9])
	 		cNfSerPe :=(aPed[10])
	 		If nY == 1	 		    
				If !Empty(cMensCli)
					cString+="<ns0:Referencia>"
					cString+="<ns0:NroLinRef>"+Alltrim(Str(nY))+"</ns0:NroLinRef>"
					cString+="<ns0:IndGlobal>1</ns0:IndGlobal>"						
					cString+="<ns0:RazonRef></ns0:RazonRef>"
					cString+="</ns0:Referencia>"               
					exit  //Me voy del for porque sólo puede haber una referencia global
				Endif	 				
	 			If ExistBlock("FIS57XML")
					cRefglob := ExecBlock("FIS57XML",.F.,.F.,{2,aProd,nY,aDest,aCabNF,aPed,aRetMntIV,cTipo,cString}) //A primeira posição é para ordenar em qual parte do XML o pronto de entrada vai atuar
					If !Empty(cRefglob)		
						cString+="<ns0:Referencia>"
						cString+="<ns0:NroLinRef>"+Alltrim(Str(nY))+"</ns0:NroLinRef>"
						cString+="<ns0:IndGlobal>1</ns0:IndGlobal>" 
						cString += cRefglob						
						cString+="</ns0:Referencia>"			                        
						exit  //Me voy del for porque sólo puede haber una referencia global
					Endif
				EndIf   
				If (CompRef(aprod) == 0 .Or. CompRef(aprod) > 40) .And. AllTrim(cEspeci) <> "NF"
					cString+="<ns0:Referencia>"
					cString+="<ns0:NroLinRef>"+Alltrim(Str(nY))+"</ns0:NroLinRef>"
				  	cString+="</ns0:Referencia>"
				  	exit  //Me voy del for porque sólo puede haber una referencia global
				Endif
			Endif
			If	Empty(cRefglob) .And. Empty(cMensCli)
			 		If (!empty(aprod[nY][12]) .And. !empty(aprod[nY][11])) .Or. (!empty (cNfSerPe) .And. !empty (cNfOriPe))					 
						aadd(aNfOri,{cNfOri,cSerOri})
						aadd(aNfOri,{cNfOriPe,cNfSerPe})
					IF ! Empty(cNfOri) .OR. !Empty(cSerOri)  
						cNotUsa +=(Alltrim(aprod[nY][12])+(aprod[nY][11]))+"|"
				 	Else
				 		cNotUsa +=(Alltrim(cNfSerPe)+(cNfOriPe))+"|"
				 	EndIF
				 	
					If CompRef(aprod) < 40 .And. (!Empty(cNfOri) .or. !Empty(cNfOriPe))	
											
						//Nota Referenciada
						aTempArea := SF2->(getArea())	//Proteger area da SF2 e restaurar abaixo
						SF2->(dbSetOrder(1))  
						
						if SF2->(dbSeek(xFilial("SF2")+cNfOri+cSerOri))  
							if ASCAN(aNfaProd, { |x| AllTrim(x[3]) == ALLTRIM(SF2->F2_CAEE) } ) == 0  //HRC 
							
								//Genero el listado de facturas referenciadas para el caso de que haya que informar mediante referencia global
								//por haber entre las facturas referenciadas alguna factura no electrónica.
									if nY > 1
										cRefNoElec += "/"  
									endif
			
									cRefNoElec += cRef1
								If !Empty(SF2->F2_CODDOC)
									cRef+="<ns0:Referencia>"	
					   				cRef+="<ns0:NroLinRef>"+Alltrim(Str(nY))+"</ns0:NroLinRef>"
									cRef+="<ns0:TpoDocRef>"+Alltrim(SF2->F2_CODDOC)+"</ns0:TpoDocRef>"
									cRef+="<ns0:Serie>"+Alltrim(SF2->F2_SERCAE)+"</ns0:Serie>"		
									cRef+="<ns0:NroCFERef>"+Alltrim(SF2->F2_CAEE)+"</ns0:NroCFERef>"
									cRef+="</ns0:Referencia>"
								Else
									//Si encuentro una factura referenciada que no es electrónica, coloco referencia global.
									bFacNoElec := .T.
								Endif
								
								//Agrego la Factura para Referencia
					 				AADD(aNfaProd,{aprod[nY][11],aprod[nY][12],SF2->F2_CAEE})  //HRC Inclui o CAEE
					 			
							EndIf
						endif						
						
						RestArea(aTempArea)
						
					EndIf 	
				Endif
			Endif						
		Next nY                                      
		
		//Si hubieron facturas no electrónicas, coloco la referencia global para facturas no electrónicas
		//Si no, coloco la referencia no global.
		if bFacNoElec
			cString+="<ns0:Referencia>"
			cString+="<ns0:NroLinRef>1</ns0:NroLinRef>"
			cString+="<ns0:IndGlobal>1</ns0:IndGlobal>"
			cString+="<ns0:RazonRef>"+ cRefNoElec + "</ns0:RazonRef>"
			cString+="</ns0:Referencia>"
		else
			cString+= cRef
		endif
		
		cString+="</ns0:Referencia>"  
	Endif
	If lCont .And. !empty (aConX) .And. Len( aConX ) > 4
		
		cString+="<ns0:CAEData>"
		cString+="<ns0:CAE_ID>"+aConX[1]+"</ns0:CAE_ID>"  
		cString+="<ns0:DNro>"+aConX[2]+"</ns0:DNro>"
		cString+="<ns0:HNro>"+aConX[3]+"</ns0:HNro>"
		cString+="<ns0:FecVenc>"+aConX[4]+"</ns0:FecVenc>"
		cString+="</ns0:CAEData>"
	
	Else
		
		aDadosCae := RetDadosCae(aCabNf[01],aCabNf[02],cEspeci)
		
		cString+="<ns0:CAEData>"
		cString+="<ns0:CAE_ID>"+aDadosCae[01]+"</ns0:CAE_ID>"  
		cString+="<ns0:DNro>"+aDadosCae[02]+"</ns0:DNro>"
		cString+="<ns0:HNro>"+aDadosCae[03]+"</ns0:HNro>"
		cString+="<ns0:FecVenc>"+aDadosCae[04]+"</ns0:FecVenc>"
		cString+="</ns0:CAEData>"
	
	Endif
	If cTipoCli $ "345"  .and.  cTipoEx == "1" 		//Extrangeiro e compra fora do pais 
		If alltrim(aCabNF[10]) == "RFN"
			cString +="</ns0:eRem_Exp>"
		Else
			cString +="</ns0:eFact_Exp>"
		Endif
	ElseIf cTipoCli $ "345"  .and.  cTipoEx == "2" 	//Extrangeiro e compra dentro do pais 
		If alltrim(aCabNF[10]) == "RFN"
			cString+="</ns0:eRem>"
		Else	
			cString+="</ns0:eTck>"		 			
		Endif
	Elseif cTipocli <> "2"
		If alltrim(aCabNF[10]) == "RFN"
			cString+="</ns0:eRem>"
		Else
			cString+="</ns0:eFact>"
		Endif
	Else
		If alltrim(aCabNF[10]) == "RFN"  
			cString+="</ns0:eRem>"		 
		Else
			cString+="</ns0:eTck>"		 
		Endif
	Endif
	cString+="</ns0:CFE>"
	cString+="<ns0:Adenda>"
	cString+="<Rondanet>"
	cString+="<A01>"
	If cPDV =="1"
		cString+="<Numerar>0</Numerar>"
	Else
		cString+="<NumerarPDV>0</NumerarPDV>"
	Endif				   
	cString+="<Firmar>1</Firmar>"
	cString+="<NroDocInterno></NroDocInterno>"	
	cString+="<SerieDocInterna></SerieDocInterna>"					
	cString+="</A01>"
	
	If ExistBlock("FIS57XML")
		cString+= ExecBlock("FIS57XML",.F.,.F.,{3,aProd,1,aDest,aCabNF,aPed,aRetMntIV,cTipo,cString}) //A primeira posição é para ordenar em qual parte do XML o pronto de entrada vai atuar
	EndIf             

	/*********************************************************************************************/
	/*                                 CAMPOS EN LA ADENDA                                       */
	/*********************************************************************************************/
	cString+="<A03>"
	cString+="<TextoAImprimir>"		
	cString+="<ZonaImpresion zona='1'>"
			
	                               
	If ALLTRIM(cEspeci) == "NF"
		if Len(aPed)>= 12
			If !EMPTY(aPed[15])
				cString+="<LineaTexto>Observaciones: "+Alltrim(Convtype(aPed[15])) + "</LineaTexto>"//Observaciones
				cString+="<LineaTexto>"+Alltrim(Convtype("Transcurridos los 15 dias de la fecha de vencimiento de la factura,"))+"</LineaTexto>"
				cString+="<LineaTexto>"+Alltrim(Convtype("el no pago de la misma devengara un interes del 0,2% diario."))+"</LineaTexto>"
			Else
				cString+="<LineaTexto>Observaciones: "+Alltrim(Convtype("Transcurridos los 15 dias de la fecha de vencimiento de la factura,"))+"</LineaTexto>"
				cString+="<LineaTexto>"+Alltrim(Convtype("el no pago de la misma devengara un interes del 0,2% diario."))+"</LineaTexto>"
			Endif
			If !EMPTY(aPed[12])
				cString+="<LineaTexto>Pay Method: "+Alltrim(Convtype(aPed[12]))+"</LineaTexto>"//Metodo de pago
			Endif
		
			If !EMPTY(aPed[16])
				cString+="<LineaTexto>Courier: "+Alltrim(Convtype(aPed [16]))+"</LineaTexto>"// Transportista
			Endif                                             
			If !EMPTY(aPed[13])
				cString+="<LineaTexto>Incoterm: "+Alltrim(Convtype(aPed [13]))+"</LineaTexto>"// Incoterm
			Endif   
		ENDIF                                    
	Endif
	
	If aCabNF[12] == 0
		cString+="<LineaTexto>Total: "+Convtype(aCabNF[11],15,2)+"</LineaTexto>"//Total
	Endif

	cString+="</ZonaImpresion>"	
	cString+="</TextoAImprimir>"	 		
	cString+="</A03>" 
	/*********************************************************************************************/
		
	
	cString+="</Rondanet>"
	cString+="</ns0:Adenda>"
	cString+="</ns0:CFE_Adenda>" 
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Carpeta "aEnviar" - Controle TK menores                      ³
	//³TK menores é definido pelo valor total da factura aCabNF[12] ³
	//³Carpeta de envíos de alta prioridad – Se debe colocar en     ³
	//³esta carpeta las facturas, resguardos, y remitos, incluyendo ³
	//³los tickets mayores de 10.000 UY (todos los comprobantes     ³
	//³ excepto tickets menores). Estos serán enviados a DGI.       ³
	//³ A su vez serán publicados en el web y enviados a            ³
	//³enviados a otros receptores según corresponda.               ³
	//³                                                             ³
	//³Carpeta "AEnviarTKMenores"                                   ³
	//³Carpeta para los envíos baja prioridad – Son solo los        ³
	//³tickets menores de 10.000 UI. Serán todos publicados         ³
	//³en el web, no se envían a DGI.                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	//Verifica se a nota convertida fica com o valor maior ou menos que 100000	
	aadd(aXML,cString) 
	If aPed[5] == "USD" 
	   	cTipoFac := RetTpCbte(aCabNF[10],cTipoCli,cTipoEx)
		If cTipoFac $ "101|102|103|201|202|203" 
			DbSelectArea("SM2")
			DbSetOrder(1)
		    If DbSeek(IIF(cTipo=="1",SF2->F2_EMISSAO,SF1->F1_EMISSAO))
				nTxMoeUI := &("SM2->M2_MOEDA"+CVALTOCHAR(cValMoeda))	
				nValCon := aCabNf[12] * nTxMoeUI
			Endif
			aadd(aXML,IIF(nValCon < 10000,.T.,.F.)) 		
			dbCloseArea()
		Else 
			aadd(aXML,.F.)
		Endif	
	Else
		cTipoFac := RetTpCbte(aCabNF[10],cTipoCli,cTipoEx)
		If cTipoFac $ "101|102|103|201|202|203" 
			nValCon  := xMoeda(aCabNf[12],1,IIF(cTipo=="1",SF2->F2_MOEDA,SF1->F1_MOEDA),IIF(cTipo=="1",SF2->F2_EMISSAO,SF1->F1_EMISSAO),,,)
			dbSelectArea("SM2")
			SM2->(dbSetOrder(1))
		    If SM2->(dbSeek(IIF(cTipo=="1",SF2->F2_EMISSAO,SF1->F1_EMISSAO)))
				nTxMoeUI := &("SM2->M2_MOEDA"+CVALTOCHAR(cValMoeda))	
				nValCon := nValCon * nTxMoeUI
			Endif
			aadd(aXML,IIF(nValCon < 10000,.T.,.F.))
			dbCloseArea()
		Else 
			aadd(aXML,.F.)
		Endif
	Endif
	aadd(aXML,RetTpCbte(aCabNF[10],cTipoCli,cTipoEx)) 
	aadd(aXML,aCabNF[1])
	aadd(aXML,aCabNF[2])	
	aadd(aXML,aDadosCae[01])		//codigo CAE
	//Grava o Tipo do CFE
	If cTipo == "1"
		dbSelectArea("SF2")
		dbSetOrder(1)
		DbGoTop()
		If DbSeek(xFilial("SF2")+aCabNF[2]+aCabNF[1])
			RecLock("SF2",.F.)
			If FieldPos("F2_CODDOC") > 0
				SF2->F2_CODDOC := RetTpCbte(aCabNF[10],cTipoCli,cTipoEx)
			EndIf
			IF lCont
		    	If FieldPos("F2_CAEE") > 0
					SF2->F2_CAEE := aCabNF[2]
				EndIf
				If FieldPos("F2_SERCAE") > 0
					SF2->F2_SERCAE := aCabNF[1]
				EndIf		
			Endif
			MsUnLock()		
		Endif
	Else
		dbSelectArea("SF1")
		dbSetOrder(1)
		DbGoTop()
		If DbSeek(xFilial("SF1")+aCabNF[2]+aCabNF[1])
			RecLock("SF1",.F.)
			If FieldPos("F1_CODDOC") > 0
				SF1->F1_CODDOC := RetTpCbte(aCabNF[10],cTipoCli,cTipoEx)
			EndIf
			IF lCont
		    	If FieldPos("F1_CAEE") > 0
					SF1->F1_CAEE := aCabNF[2]
				EndIf
				If FieldPos("F1_SERCAE") > 0
					SF1->F1_SERCAE := aCabNF[1]
				EndIf	
			Endif
			MsUnLock()		
		Endif 
	Endif
Return aXML 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ConvType ºAutor  ³Camila Januário     º Data ³ 28/01/2013   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Converte tipos                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ConvType(xValor,nTam,nDec)
Local cNovo := ""
DEFAULT nDec := 0
Do Case
	Case ValType(xValor)=="N"
		If xValor <> 0
			cNovo := AllTrim(Str(xValor,nTam,nDec))
			cNovo := StrTran(cNovo,",",".")
		Else
			cNovo := "0"
		EndIf
	Case ValType(xValor)=="D"
		cNovo := FsDateConv(xValor,"YYYYMMDD")
		cNovo := SubStr(cNovo,1,4)+"-"+SubStr(cNovo,5,2)+"-"+SubStr(cNovo,7)   
	Case ValType(xValor)=="C"
		If nTam==Nil
			xValor := AllTrim(xValor)
		EndIf
		DEFAULT nTam := 100
		cNovo := AllTrim(EnCodeUtf8(NoAcento(SubStr(xValor,1,nTam)))) 
EndCase
Return(cNovo)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NoAcento ºAutor  ³Camila Januário     º Data ³  28/01/2013  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Valida acentos                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static FUNCTION NoAcento(cString)


Local cChar  := ""
Local cVogal := "aeiouAEIOU"
Local cAgudo := ""                  //Local cAgudo := "áéíóú"+"ÁÉÍÓÚ"
Local cCircu := "âêîôû"+"ÂÊÎÔÛ"
Local cTrema := "äëïöü"+"ÄËÏÖÜ"
Local cCrase := "àèìòù"+"ÀÈÌÒÙ" 
Local cTio   := "ãõ"
Local cCecid := "çÇ"
Local cNTio  := ""                  //Local cNTio  := "ñÑ"
Local cEComer:= "&"  
Local nX     := 0 
Local nY     := 0

For nX:= 1 To Len(cString)
	cChar:=SubStr(cString, nX, 1)
	IF cChar$cAgudo+cCircu+cTrema+cCecid+cTio+cCrase+cEComer+cNTio
		nY:= At(cChar,cAgudo)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cCircu)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cTrema)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cCrase)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf		
		nY:= At(cChar,cTio)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr("ao",nY,1))
		EndIf		
		nY:= At(cChar,cCecid)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr("cC",nY,1))
		EndIf
	 	nY:= At(cChar,cEComer)
	 	If nY > 0
			cString := StrTran(cString,cChar,SubStr("y",nY,1))
		EndIf
		nY:= At(cChar,cNTio)
	 	If nY > 0
			cString := StrTran(cString,cChar,SubStr("nN",nY,1))
		EndIf		
	Endif
Next
For nX:=1 To Len(cString)
	cChar:=SubStr(cString, nX, 1)
	If (Asc(cChar) <> 241 .and. Asc(cChar) <> 209 .and. Asc(cChar) <> 225 .and. ;   // No considera ñÑ y áéíóúÁÉÍÓÚ
	   Asc(cChar) <> 233 .and. Asc(cChar) <> 237 .and. Asc(cChar) <> 243  .and.	;                                               
	   Asc(cChar) <> 250 .and. Asc(cChar) <> 193 .and. Asc(cChar) <> 201  .and.	;                                               
	   Asc(cChar) <> 205 .and. Asc(cChar) <> 211 .and. Asc(cChar) <> 218) 
 	   If Asc(cChar) < 32 .Or. Asc(cChar) > 123 
	      cString:=StrTran(cString,cChar,".")
	   Endif
	Endif   
Next nX
cString := _NoTags(cString)
Return cString

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MyGetEnd  ³ Autor ³ Camila Januário              ³ Data ³ 28/01/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica se o participante e do DF, ou se tem um tipo de endereco ³±±
±±³          ³ que nao se enquadra na regra padrao de preenchimento de endereco  ³±±
±±³          ³ por exemplo: Enderecos de Area Rural (essa verificção e feita     ³±±
±±³          ³ atraves do campo ENDNOT).                                         ³±±
±±³          ³ Caso seja do DF, ou ENDNOT = 'S', somente ira retornar o campo    ³±±
±±³          ³ Endereco (sem numero ou complemento). Caso contrario ira retornar ³±±
±±³          ³ o padrao do FisGetEnd                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Obs.     ³ Esta funcao so pode ser usada quando ha um posicionamento de      ³±±
±±³          ³ registro, pois será verificado o ENDNOT do registro corrente      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIS                                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function MyGetEnd(cEndereco,cAlias)

Local cCmpEndN	:= SubStr(cAlias,2,2)+"_ENDNOT"
Local cCmpEst	:= SubStr(cAlias,2,2)+"_EST"
Local aRet		:= {"",0,"",""}   

//Campo ENDNOT indica que endereco participante mao esta no formato <logradouro>, <numero> <complemento>
//Se tiver com 'S' somente o campo de logradouro sera atualizado (numero sera SN)
If (&(cAlias+"->"+cCmpEst) == "DF") .Or. ((cAlias)->(FieldPos(cCmpEndN)) > 0 .And. &(cAlias+"->"+cCmpEndN) == "1")
	aRet[1] := cEndereco
	aRet[3] := "SN"
Else
	aRet := FisGetEnd(cEndereco)
EndIf

Return aRet                                                       
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Fis57Imp ºAutor  ³Camila Januário     º Data ³ 25/01/2013   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Busca os impostos e as colunas  do IVA                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Nota Fiscal Eletronica Uruguai                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Fis57Imp()  

Local cColIVA	 :=""

DbSelectArea("SFB") 
//Iva Tasa Minima 10 
SFB->(DBGOTOP()) 
While !SFB->(EOF()) 		 
		cColIVA := SFB->FB_CPOLVRO 			
		IF(Len(SFB->FB_CPOLVRO)<>0 .And. !empty(SFB->FB_TPCLASS)) 
			AADD(aColIVA,{SFB->FB_CPOLVRO,SFB->FB_TPCLASS,SFB->FB_ALIQ,SFB->FB_CODIGO})   
		
		Endif
		
	SFB->(DBSkip())	 
EndDo

Return()        

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ 
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RetTpCbteºAutor  ³Camila Januário      º Data ³  25/01/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna o tipo de comprovante                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Nfe Uruguai                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function RetTpCbte(cTipo,cTipoCli,cTipoEx) 
Local cCbte  := ""
Local lCont  := GETMV("MV_URUCONT")   //Parametro referente a Contingencia da nota do Uruguai           

If lCont
	if  cTipoCli $ "345"
		IF (Alltrim(cTipo) == "NF")
			If cTipoEx=="1"   
				cCbte := "221"
			Else
				cCbte := "201"
			EndIf		
		Elseif (Alltrim(cTipo) $ "NCC|NCI|NCE|NCP") 
			cCbte := "222"
		Elseif (Alltrim(cTipo) $ "NDC|NDI|NDE|NDP") 
			cCbte := "223"
		Endif 
	ElseIf cTipoCli <> "2"
		IF (Alltrim(cTipo) == "NF")  
			cCbte := "211"		
		Elseif (Alltrim(cTipo) $ "NCC|NCI|NCE|NCP") 
			cCbte := "212"
		Elseif (Alltrim(cTipo) $ "NDC|NDI|NDE|NDP") 
			cCbte := "213"
		Endif	
	Else 
		IF (Alltrim(cTipo) == "NF")  
			cCbte := "201"
		Elseif (Alltrim(cTipo) $ "NCC|NCI|NCE|NCP") 
			cCbte := "202"
		Elseif (Alltrim(cTipo) $ "NDC|NDI|NDE|NDP") 
			cCbte := "203"
		Endif
	EndIF
Else
	if  cTipoCli $ "345"
		IF (Alltrim(cTipo) == "NF")     
		    If cTipoEx=="1" 
		    	cCbte := "121"
		    Else
				cCbte := "101"
			EndIf		
		Elseif (Alltrim(cTipo) $ "NCC|NCI|NCE|NCP") 
			If cTipoEx=="1" 
				cCbte := "122"
			Else
				cCbte := "102"
			EndIf
		Elseif (Alltrim(cTipo) $ "NDC|NDI|NDE|NDP") 
			If cTipoEx=="1" 
				cCbte := "123"
			Else
				cCbte := "103"
			EndIf	
		Endif	
 	ElseIf cTipoCli <> "2"
		IF (Alltrim(cTipo) == "NF")  
			cCbte := "111"		
		Elseif (Alltrim(cTipo) $ "NCC|NCI|NCE|NCP") 
		   
			cCbte := "112"
		Elseif (Alltrim(cTipo) $ "NDC|NDI|NDE|NDP") 
			cCbte := "113"
		Endif 	
	Else 
		IF (Alltrim(cTipo) == "NF")  
			cCbte := "101"
		Elseif (Alltrim(cTipo) $ "NCC|NCI|NCE|NCP") 
			cCbte := "102"
		Elseif (Alltrim(cTipo) $ "NDC|NDI|NDE|NDP") 
			cCbte := "103"
		Endif
	EndIF		
Endif 
Return cCbte   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RetCondPgºAutor  ³Camila Januário      º Data ³  25/01/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna o tipo de condição de pagamento                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Nfe Uruguai                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function RetCondPg(cCondpg)  

Local cCod		:= ""	 
Local aArea := GetArea() 
Default cCondpg := "1"

DbSelectArea("SE4")
DbSetOrder(1)
If DbSeek(xFilial("SE4")+cCondPg)
	If (Substr(SE4->E4_COND,1,1) <= "0" .AND. Substr(SE4->E4_COND,2,1) <= "0" .AND.SE4->E4_TIPO ="1");
	.OR.(Substr(SE4->E4_COND,1,2) == "00" .AND. SE4->E4_TIPO ="1")
	
		cCod := "1"
	Else
	    cCod := "2"
	Endif
Endif	

RestArea(aArea) 

Return cCod  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RetCodPaisºAutor  ³Camila Januário      º Data ³ 25/01/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna o código de País				                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Nfe Uruguai                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function RetCodPais(cPais,lNomePais)  

Local cCod 	  := ""
Local aArea := GetArea()
Default cPais := "845" //Uruguai
Default lNomePais := .F.

DbSelectArea("SYA")
DbSetOrder(1)                   
If DbSeek(xFilial("SYA")+cPais)
	if lNomePais
		cCod := SYA->YA_DESCR
	else
		cCod := Alltrim(SYA->YA_SIGLA)
	endif
Endif

RestArea(aArea) 

Return cCod


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RetFormDatºAutor  ³Camila Januário      º Data ³ 25/01/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna o formato de data			                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Nfe Uruguai                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RetFormDat(dData)             
Local cData := ""
cData := Alltrim(Str(Year(dData)))+"-"+Strzero(Month(dData),2)+"-"+Alltrim(StrZero(Day(dData),2))
Return cData

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RetIndFactºAutor  ³Camila Januário     º Data ³  25/01/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna o indicador de facturación                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Nfe Uruguai                                                º±±
,±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 
Static Function RetIndFact(cTpClass,nBasimp,nAlqimp,nValImp)                  
Local nRet := 0
Default cTpClass := ""                                                                             
Default nBasimp:=nAlqImp:=nValImp:=0 

Do Case
	Case Empty(cTpClass) 
		nRet := 4    //exento de IVA
			
	Case cTpClass == "2" 
		nRet := 2    //tasa minima	
			
	Case cTpClass == "1" 
		nRet := 3    //tasa basica

	Case cTpClass == "3"
		nRet := 1    //  Excento
				
	Case cTpClass == "4" 
		nRet := 10   //	Exportacion
	
	Case cTpClass == "5" 
		nRet := 12   //Suspenso	
			
	Case !cTpClass $ "0|1|2|3|4|5" .And. !(Str(nAlqImp) $ "10|22")
		nRet := 4    //otra tasa	
EndCase

Return nRet
              
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SomaMntIVºAutor  ³Camila Januário      º Data ³  25/01/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Soma os montantes dos itens que calculam IVA               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function SomaMntIV(aProd,cEspeci)

Local nMntTB 		:= 0   
Local nMntNetTB 	:= 0
Local nMntTM 		:= 0
Local nMntNetTM 	:= 0 
Local nMnTIsen		:= 0
Local nMntNetIsen	:= 0
Local nMnTExp       := 0  
Local nMntNetExp	:= 0
Local nMnTSus 		:= 0
Local nMntNetSus	:= 0
Local nTaxbas		:= 0 
local nTaxMin       := 0
Local nTaxIse       := 0
Local nTaxExp       := 0
Local nTaxSus       := 0
Local nMntTMSS      := 0 
Local nX 			:= 0
Local aRet 			:= {}                                            
Local cTx			:=""
Default cEspeci := "NF"
Default aProd 	:= {}

/*cTpClass    ,nBasimp     ,nAlqimp     ,nVal */
/*aProd[nX][7],aProd[nX][8],aProd[nX][9],aProd[nX][10]*/ 

For Nx := 1 to Len(aProd)
	If valType(aProd[nX][7]) =="N"
   		cTx:=Alltrim(str(aProd[nX][7]))
	Else
		cTx:=aProd[nX][7]
	EndIf

	If cTx=="1" //tasa basica 22
		nMntTB 		+= aProd[nX][10]
		nMntNetTB 	+= aProd[nX][8]
		nTaxbas ++
	Elseif cTx=="2" //tasa minima 10	   	
		nMntTM 		+= aProd[nX][10]
		nMntNetTM 	+= aProd[nX][8]
		nTaxMin ++
	Elseif cTx=="3" //Iva Excento      
		nMnTIsen    += 0
		nMntNetIsen += 0
	    nTaxIse ++
	Elseif cTx=="4" //Iva Iva Exportacion
		nMnTExp    += 0
		nMntNetExp += 0
	    nTaxExp ++
	Elseif cTx=="5" //Iva Suspenso	
		nMnTSus    += 0
		nMntNetSus += 0
	    nTaxSus ++    	
	Endif   
Next nX 

//Soma a Taxa minima com a Taxa Basica - Regra de Negocio
If AllTrim(cEspeci) $ "NF|NCC|NCI|NCE|NDC|NDI|NDE|NCP|NDP"   
	nMntTMSS := (nMntNetTB + nMntNetTM + nMntNetIsen + nMntNetExp + nMntNetSus) 		  		
EndIF
                        
aadd(aRet,nMntTB) 	     /*1   monto tasa basica valimp*/
aadd(aRet,nMntNetTB)     /*2   monto neto tasa basica basimp*/

aadd(aRet,nMntTM)        /*3   monto tasa minima valimp*/
aadd(aRet,nMntNetTM)     /*4   monto neto tasa minima basimp som soma total*/  

aadd(aRet,nMnTIsen)      /*5   monto tasa Isento valimp */
aadd(aRet,nMntNetIsen)	 /*6   monto neto tasa Isento basimp */ 

aadd(aRet,nMnTExp)       /*7  monto tasa Isento valimp */
aadd(aRet,nMntNetExp)	 /*8  monto neto tasa Isento basimp */

aadd(aRet,nMnTSus)       /*9  monto tasa Isento valimp */
aadd(aRet,nMntNetSus)	 /*10  monto neto tasa Isento basimp */

aadd(aRet,nMntTMSS)	     /*11   TOTAL  monto neto tasa minima basimp */

aadd(aRet,nTaxbas)       /*12   Valor total de Basicas*/	
aadd(aRet,nTaxMin)       /*13   Valor total de Minimas*/
aadd(aRet,nTaxIse)       /*14  Valor total de Isentas*/
aadd(aRet,nTaxExp)       /*15  Valor total de Exportacion*/
aadd(aRet,nTaxSus)       /*16  Valor total de Suspenso*/
Return aRet 
               
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DescItem ºAutor  ³Fernando Bastos     º Data ³  08/11/2013  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Busca da SB5 o complemento do Item                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Valida Uruguai                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  

Static Function DescItem (cCod)

Local cDesItem  :=""

DEFAULT cCod 	:=""
 

dbSelectArea("SB5")
dbSetOrder(1)
DbSeek(xFilial("SB5")+cCod) 

If DbSeek(xFilial("SB5")+cCod)
	cDesItem := SB5->B5_CEME
Else
	cDesItem := ""		
Endif  	

dbCloseArea()

return (cDesItem)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RetProvin ºAutor  ³Fernando Bastos    º Data ³  03/02/2014  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Busca da SX5 A Providencia                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Valida Uruguai                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  

Static Function RetProvin(cProvin)

Local cPro := ""

DEFAULT cProvin 	:="MO"

DBSelectArea("SX5")
If DbSeek(xFilial("SX5")+"12"+cProvin)
	cPro := (SX5->X5_DESCSPA) 
Else 
	cPro := cProvin
Endif
return (cPro)


//-----------------------------------------------------------------------
/*/{Protheus.doc} RetDadosCae
Função que devolve os dados do CAE da tabela da cadastro de fólios.

@author	Rafael Iaquinto
@since		24/11/2014
@version	10.5

@param		cSerie  , string, 	Série do documento 
@param		cEspecie, string, 	Espécie do documento 

@return	aListPar			Dados do CAE na tabela SFP 
								[1] - Numero do Cae
								[2] - Número Inicial
								[3] - Número Final
								[4] - Data de validade formato(YYYY-MM-DD) em String
/*/
//-----------------------------------------------------------------------

Static Function RetDadosCae(cSerie,cNumero,cEspecie) 

local cAproFol	:= ""
local cDataFech	:= ""
local cNumIni		:= ""
local cNumFim		:= ""
local cCombo		:= ""
local aDadosCai	:= {}

If SFP->(FieldPos("FP_CAI")) > 0
	SFP->(DbSetOrder(1))
	If (SFP->(DbSeek(xFilial("SFP") + cFilAnt + cSerie)))
		// Busca posicao da descricao da especie da nota no combo da tabela SFP (1=NF;2=NCI;3=NDI;4=NCC;5=NDC)
		SX3->(dbSetOrder(2))
		SX3->(dbSeek("FP_ESPECIE"))
		nPosIni := At(AllTrim(cEspecie),AllTrim(SX3->X3_CBOX))
		cCombo := Substr(AllTrim(SX3->X3_CBOX),nPosIni-2,1)
	
		// Verifica se a nota selecionada esta dentro de algum range cadastrado
		// Necessario em caso de existir mais de um range com a mesma serie
		While SFP->FP_FILIAL+SFP->FP_FILUSO+SFP->FP_SERIE == xFilial("SFP")+cFilAnt+cSerie
			If AllTrim(SFP->FP_ESPECIE) == AllTrim(cCombo)
				If Val(cNumero) >= Val(SFP->FP_NUMINI) .And. Val(cNumero) <= Val(SFP->FP_NUMFIM)
					Exit
				Endif
			EndIf
			SFP->(dbSkip())
		EndDo
	Endif
	cAproFol 		:= Alltrim(SFP->FP_CAI)
	cDataFech		:= SubStr(dTos(SFP->FP_DTAVAL),1,4)+"-"+SubStr(dTos(SFP->FP_DTAVAL),5,2)+"-"+SubStr(dTos(SFP->FP_DTAVAL),7,2)
	cNumIni		:= CVALTOCHAR(Val(SFP->FP_NUMINI))
	cNumFim		:= CVALTOCHAR(Val(SFP->FP_NUMFIM))
Endif

aDadosCai := { cAproFol, cNumIni, cNumFim, cDataFech }

return (aDadosCai)
       
//-----------------------------------------------------------------------
// Cuenta el numero de facturas referenciadas de acuerdo a las lineas
//-----------------------------------------------------------------------
Static Function CompRef(aprod)
Local nCompRef := 0
Local aNfaProd := {}
Local nx:=1
For Nx := 1 to Len(aProd)
	If !Empty(aProd[nx][11]) .AND.  !Empty(aProd[nx][12])
		if ASCAN(aNfaProd, { |x| x[1] == aProd[nx][11] } ) == 0
			AADD(aNfaProd,{aProd[nx][11],aProd[nx][12]}) 
			nCompRef++  
		Endif
	Endif
next Nx
Return nCompRef

Static Function IsSF4GFin(cCodTES)
Local lRet		:= .F.
Local aArea		:= GetArea()
Local aAreaSF4	:= SF4->(GetArea())

SF4->(dbSetOrder(1))
If SF4->(dbSeek( xFilial("SF4") + cCodTES )) 				
	If AllTrim(SF4->F4_DUPLIC) == "S" 
		lRet := .T.
	EndIf
EndIf

SF4->(RestArea(aAreaSF4))
RestArea(aArea)
Return lRet
