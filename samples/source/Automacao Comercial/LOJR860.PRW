#INCLUDE "LOJR860.ch"
#INCLUDE "Protheus.ch"

#DEFINE CTRL Chr(10)           	//Pula linha

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³ Fun‡…o   ³ LOJR860     ³ Autor ³ Vendas Clientes    ³ Data ³ 29/04/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Relatorio de Nota de Credito                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ ExR1 - Nil                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³ Uso      ³ Sigaloja                                                   ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/              
User Function LOJR860()

Local aArea    	:= GetArea()		// Backup da Area
Local aDocDev	:= Paramixb[1]   	// Documento de Devolução
Local aRecSD2	:= Paramixb[2]    	// Recnos de D2
Local aDadosNCC := Paramixb[3]		// Dados de NCC
Local aRecSD1   := Iif( Len(Paramixb) >= 4 ,Paramixb[4], {} )      // Recnos de D1
Local lContinua	:= .T.

If Len(aDocDev) == 0 
	lContinua := .F.
EndIf

If lContinua
	SetPrvt('oPrint')
	oPrint:= TMSPrinter():New(STR0004)   //"Nota de Crédito"
	oPrint:SetPortrait()
	
	oFontCN08  := TFont():New("Courier New", 08, 08, .F., .F., , , , .F., .F.)
	oFontCN08N := TFont():New("Courier New", 08, 08, .F., .T., , , , .F., .F.)
	oFontCN11N := TFont():New("Courier New", 11, 11, .F., .T., , , , .F., .F.)
	oFontCN12  := TFont():New("Courier New", 12, 12, .F., .F., , , , .F., .F.)
	oFontCN12N := TFont():New("Courier New", 12, 12, .F., .T., , , , .F., .F.)
	
	oFont26N := TFont():New("Tahoma", 26, 26, .F., .T., , , , .F., .F.)
	
	MsgRun(STR0005,"",{|| CursorWait(), Lj850Print(oPrint,aDocDev,aRecSD2,aDadosNCC,aRecSD1),CursorArrow()}) //"Gerando Visualização, Aguarde..."
	
	oPrint:Preview()  // Visualiza antes de imprimir
	
	RestArea(aArea)
EndIf

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Funcao    ³Lj850Print³ Autor ³TOTVS                   ³ Data ³ 08/03/2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Imprime e gera a visualizacao do relatorio                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³SIGALOJA                                                       ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Lj850Print(oPrint,aDocDev,aRecSD2,aDadosNCC,aRecSD1)

Local nX	  := 0 		// Contador
Local nLin	  := 0		// Numero da Linha
Local cPrefixo:= ""		//Prefixo do titulo

Default oPrint   := Nil
Default aDocDev  := {}
Default aRecSD2  := {}
Default aDadosNCC:= {}
Default aRecSD1  := {} //Registros da Nota de devolução, quando selecionado sem documento de origem

If Len(aDadosNCC) > 0
	cPrefixo := aDadosNCC[1]
Else
	cPrefixo := aDocDev[1]
EndIf

SE1->( DbSetOrder( 2 ) )
If SE1->( DbSeek( xFilial("SE1") + aDocDev[3] + aDocDev[4] + cPrefixo + aDocDev[2]  ) )

	While SE1->(!Eof()) .AND. xFilial("SE1")		== SE1->E1_FILIAL 	.AND. ;
								SE1->E1_CLIENTE		== aDocDev[3] 		.AND. ;
								SE1->E1_LOJA		== aDocDev[4]		.AND. ;
								SE1->E1_PREFIXO		== cPrefixo		.AND. ;
								SE1->E1_NUM			== aDocDev[2] 
									
	   	If !( SE1->E1_SITUACA $ "27" .OR. SE1->E1_SALDO == 0 )
		
     		If ( SE1->E1_TIPO $ MV_CRNEG )

				oPrint:StartPage() // Inicia uma nova página

				oPrint:Box( 0100, 0100, 3000, 2300 )
				oPrint:Say( 0180, 0875, STR0004, oFont26N ) //"Nota de Crédito"
				oPrint:Box( 0300, 0100, 3000, 2300 )
				
				/*
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³   ESCALA PARA POSICIONAMENTO DA IMPRESSAO    ³
				//³                                              ³
				//³A impressao das linhas abaixo pode ser ativada³
				//³se for necessario efetuar uma manutencao neste³
				//³relatorio                                     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
				//Marcacoes de Linhas
				oPrint:Say(0300, 0110, "0300", oFontCN08)
				oPrint:Say(0400, 0110, "0400", oFontCN08)
				oPrint:Say(0500, 0110, "0500", oFontCN08)
				oPrint:Say(0600, 0110, "0600", oFontCN08)
				oPrint:Say(0700, 0110, "0700", oFontCN08)
				oPrint:Say(0800, 0110, "0800", oFontCN08)
				oPrint:Say(0900, 0110, "0900", oFontCN08)
				oPrint:Say(1000, 0110, "1000", oFontCN08)
				oPrint:Say(1100, 0110, "1100", oFontCN08)
				oPrint:Say(1200, 0110, "1200", oFontCN08)
				oPrint:Say(1300, 0110, "1300", oFontCN08)
				oPrint:Say(1400, 0110, "1400", oFontCN08)
				oPrint:Say(1500, 0110, "1500", oFontCN08)
				oPrint:Say(1600, 0110, "1600", oFontCN08)
				oPrint:Say(1700, 0110, "1700", oFontCN08)
				oPrint:Say(1800, 0110, "1800", oFontCN08)
				oPrint:Say(1900, 0110, "1900", oFontCN08)
				oPrint:Say(2000, 0110, "2000", oFontCN08)
				oPrint:Say(2100, 0110, "2100", oFontCN08)
				oPrint:Say(2200, 0110, "2200", oFontCN08)
				oPrint:Say(2300, 0110, "2300", oFontCN08)
				oPrint:Say(2400, 0110, "2400", oFontCN08)
				oPrint:Say(2500, 0110, "2500", oFontCN08)
				oPrint:Say(2600, 0110, "2600", oFontCN08)
				oPrint:Say(2700, 0110, "2700", oFontCN08)
				oPrint:Say(2800, 0110, "2800", oFontCN08)
				oPrint:Say(2900, 0110, "2900", oFontCN08)
				oPrint:Say(3000, 0110, "3000", oFontCN08)
				oPrint:Say(3100, 0110, "3100", oFontCN08)
				
				oPrint:Line	(0300, 0080, 0300, 0100)
				oPrint:Line	(0350, 0090, 0350, 0100)
				oPrint:Line	(0400, 0080, 0400, 0100)
				oPrint:Line	(0450, 0090, 0450, 0100)
				oPrint:Line	(0500, 0080, 0500, 0100)
				oPrint:Line	(0550, 0090, 0550, 0100)
				oPrint:Line	(0600, 0080, 0600, 0100)
				oPrint:Line	(0650, 0090, 0650, 0100)
				oPrint:Line	(0700, 0080, 0700, 0100)
				oPrint:Line	(0750, 0090, 0750, 0100)
				oPrint:Line	(0800, 0080, 0800, 0100)
				oPrint:Line	(0850, 0090, 0850, 0100)
				
				oPrint:Line	(0900, 0080, 0900, 0100)
				oPrint:Line	(0950, 0090, 0950, 0100)
				oPrint:Line	(1000, 0080, 1000, 0100)
				oPrint:Line	(1050, 0090, 1050, 0100)
				oPrint:Line	(1100, 0080, 1100, 0100)
				oPrint:Line	(1150, 0090, 1150, 0100)
				oPrint:Line	(1200, 0080, 1200, 0100)
				oPrint:Line	(1250, 0090, 1250, 0100)
				oPrint:Line	(1300, 0080, 1300, 0100)
				oPrint:Line	(1350, 0090, 1350, 0100)
				oPrint:Line	(1400, 0080, 1400, 0100)
				oPrint:Line	(1450, 0090, 1450, 0100)
				oPrint:Line	(1500, 0080, 1500, 0100)
				oPrint:Line	(1550, 0090, 1550, 0100)
				oPrint:Line	(1600, 0080, 1600, 0100)
				oPrint:Line	(1650, 0090, 1650, 0100)
				oPrint:Line	(1700, 0080, 1700, 0100)
				oPrint:Line	(1750, 0090, 1750, 0100)
				oPrint:Line	(1800, 0080, 1800, 0100)
				oPrint:Line	(1850, 0090, 1850, 0100)
				oPrint:Line	(1900, 0080, 1900, 0100)
				oPrint:Line	(1950, 0090, 1950, 0100)
				oPrint:Line	(2000, 0080, 2000, 0100)
				oPrint:Line	(2050, 0090, 2050, 0100)
				oPrint:Line	(2100, 0080, 2100, 0100)
				oPrint:Line	(2150, 0090, 2150, 0100)
				oPrint:Line	(2200, 0080, 2200, 0100)
				oPrint:Line	(2250, 0090, 2250, 0100)
				oPrint:Line	(2300, 0080, 2300, 0100)
				oPrint:Line	(2350, 0090, 2350, 0100)
				oPrint:Line	(2400, 0080, 2400, 0100)
				oPrint:Line	(2450, 0090, 2450, 0100)
				oPrint:Line	(2500, 0080, 2500, 0100)
				oPrint:Line	(2550, 0090, 2550, 0100)
				oPrint:Line	(2600, 0080, 2600, 0100)
				oPrint:Line	(2650, 0090, 2650, 0100)
				oPrint:Line	(2700, 0080, 2700, 0100)
				oPrint:Line	(2750, 0090, 2750, 0100)
				oPrint:Line	(2800, 0080, 2800, 0100)
				oPrint:Line	(2850, 0090, 2850, 0100)
				oPrint:Line	(2900, 0080, 2900, 0100)
				oPrint:Line	(2950, 0090, 2950, 0100)
				oPrint:Line	(3000, 0080, 3000, 0100)
				oPrint:Line	(3050, 0090, 3050, 0100)
				oPrint:Line	(3100, 0080, 3100, 0100)
				oPrint:Line	(3150, 0090, 3150, 0100)
				oPrint:Line	(3200, 0080, 3200, 0100)
				
				oPrint:Line	(0280, 0100, 3200, 0100)
				
				//Marcacoes de Colunas
				oPrint:Say(0230, 0070, "0100", oFontCN08)
				oPrint:Say(0230, 0170, "0200", oFontCN08)
				oPrint:Say(0230, 0270, "0300", oFontCN08)
				oPrint:Say(0230, 0370, "0400", oFontCN08)
				oPrint:Say(0230, 0470, "0500", oFontCN08)
				oPrint:Say(0230, 0570, "0600", oFontCN08)
				oPrint:Say(0230, 0670, "0700", oFontCN08)
				oPrint:Say(0230, 0770, "0800", oFontCN08)
				oPrint:Say(0230, 0870, "0900", oFontCN08)
				oPrint:Say(0230, 0970, "1000", oFontCN08)
				oPrint:Say(0230, 1070, "1100", oFontCN08)
				oPrint:Say(0230, 1170, "1200", oFontCN08)
				oPrint:Say(0230, 1270, "1300", oFontCN08)
				oPrint:Say(0230, 1370, "1400", oFontCN08)
				oPrint:Say(0230, 1470, "1500", oFontCN08)
				oPrint:Say(0230, 1570, "1600", oFontCN08)
				oPrint:Say(0230, 1670, "1700", oFontCN08)
				oPrint:Say(0230, 1770, "1800", oFontCN08)
				oPrint:Say(0230, 1870, "1900", oFontCN08)
				oPrint:Say(0230, 1970, "2000", oFontCN08)
				oPrint:Say(0230, 2070, "2100", oFontCN08)
				oPrint:Say(0230, 2170, "2200", oFontCN08)
				oPrint:Say(0230, 2270, "2300", oFontCN08)
				
				oPrint:Line	(0280, 0100, 0300, 0100)
				oPrint:Line	(0290, 0150, 0300, 0150)
				oPrint:Line	(0280, 0200, 0300, 0200)
				oPrint:Line	(0290, 0250, 0300, 0250)
				oPrint:Line	(0280, 0300, 0300, 0300)
				oPrint:Line	(0290, 0350, 0300, 0350)
				oPrint:Line	(0280, 0400, 0300, 0400)
				oPrint:Line	(0290, 0450, 0300, 0450)
				oPrint:Line	(0280, 0500, 0300, 0500)
				oPrint:Line	(0290, 0550, 0300, 0550)
				oPrint:Line	(0280, 0600, 0300, 0600)
				oPrint:Line	(0290, 0650, 0300, 0650)
				oPrint:Line	(0280, 0700, 0300, 0700)
				oPrint:Line	(0290, 0750, 0300, 0750)
				oPrint:Line	(0280, 0800, 0300, 0800)
				oPrint:Line	(0290, 0850, 0300, 0850)
				oPrint:Line	(0280, 0900, 0300, 0900)
				oPrint:Line	(0290, 0950, 0300, 0950)
				oPrint:Line	(0280, 1000, 0300, 1000)
				oPrint:Line	(0290, 1050, 0300, 1050)
				oPrint:Line	(0280, 1100, 0300, 1100)
				oPrint:Line	(0290, 1150, 0300, 1150)
				oPrint:Line	(0280, 1200, 0300, 1200)
				oPrint:Line	(0290, 1250, 0300, 1250)
				oPrint:Line	(0280, 1300, 0300, 1300)
				oPrint:Line	(0290, 1350, 0300, 1350)
				oPrint:Line	(0280, 1400, 0300, 1400)
				oPrint:Line	(0290, 1450, 0300, 1450)
				oPrint:Line	(0280, 1500, 0300, 1500)
				oPrint:Line	(0290, 1550, 0300, 1550)
				oPrint:Line	(0280, 1600, 0300, 1600)
				oPrint:Line	(0290, 1650, 0300, 1650)
				oPrint:Line	(0280, 1700, 0300, 1700)
				oPrint:Line	(0290, 1750, 0300, 1750)
				oPrint:Line	(0280, 1800, 0300, 1800)
				oPrint:Line	(0290, 1850, 0300, 1850)
				oPrint:Line	(0280, 1900, 0300, 1900)
				oPrint:Line	(0290, 1950, 0300, 1950)
				oPrint:Line	(0280, 2000, 0300, 2000)
				oPrint:Line	(0290, 2050, 0300, 2050)
				oPrint:Line	(0280, 2100, 0300, 2100)
				oPrint:Line	(0290, 2150, 0300, 2150)
				oPrint:Line	(0280, 2200, 0300, 2200)
				oPrint:Line	(0290, 2250, 0300, 2250)
				oPrint:Line	(0280, 2300, 3200, 2300)
				
				oPrint:Line	(0300, 0100, 0300, 2300)
				*/
				
				SA1->(DbSetOrder(1))
				If SA1->(DbSeek(xFilial("SA1")+aDocDev[3]+aDocDev[4] ))
					oPrint:Say( 400, 0200, STR0006, oFontCN12N ) //"Código:"
					oPrint:Say( 400, 0500, aDocDev[3], oFontCN12 )
					oPrint:Say( 400, 0750, STR0007, oFontCN12N ) //"Loja:"
					oPrint:Say( 400, 0950, aDocDev[4], oFontCN12 )
					oPrint:Say( 400, 1350, STR0008, oFontCN12N ) //"Nome:"
					oPrint:Say( 400, 1500, Alltrim(SA1->A1_NOME), oFontCN12 )                                            
				Endif	
				
				oPrint:Say( 480, 0200, STR0009, oFontCN12N ) //"Data de Devolução:"
				oPrint:Say( 480, 0700, DTOC(SE1->E1_EMISSAO), oFontCN12 )
				oPrint:Say( 480, 1100, STR0010, oFontCN12N ) //"Data de Validade da NCC:"
				oPrint:Say( 480, 1800, DTOC(SE1->E1_VENCREA), oFontCN12 )                                            
					
					
				oPrint:Say( 560, 0200, STR0011, oFontCN12N ) //"Prefixo:"
				oPrint:Say( 560, 0500, cPrefixo, oFontCN12 )
				oPrint:Say( 560, 0750, STR0012, oFontCN12N ) //"Número:"
				oPrint:Say( 560, 0950, aDocDev[2], oFontCN12 )                                            
					                                            
				oPrint:Say( 560, 1400, STR0013, oFontCN12N ) //"Saldo NCC:"
				oPrint:Say( 560, 1800, Transform(SE1->E1_SALDO,PesqPict("SE1","E1_SALDO")), oFontCN12 )
				
				oPrint:Box( 0700, 0100, 3000, 2300 )
				
				oPrint:Say( 800, 0200, STR0014, oFontCN12N ) //"Código"
				oPrint:Say( 800, 0750, STR0015, oFontCN12N ) //"Descrição"
				
				nLin := 800
				
				SB1->(DbSetOrder(1))
				If Len(aRecSD2) > 0
    				For nX := 1 To Len(aRecSD2)
    				
    					nLin += 80
    					SD2->(DbGoTo(aRecSD2[nX][2]))
    					If SB1->(DbSeek(xFilial("SB1")+SD2->D2_COD))
    						oPrint:Say( nLin, 0200, SD2->D2_COD, oFontCN12 )                                            
    						oPrint:Say( nLin, 0750, Alltrim(SB1->B1_DESC), oFontCN12 )                                                              
    					Endif 		
    					                         
    					If nLin > 3000
    						oPrint:EndPage()   	  // Finaliza a página	
    						oPrint:StartPage()   // Inicializa a página			
    						oPrint:Box( 0100, 0100, 3000, 2300 )
    						oPrint:Say( 0180, 0875, STR0004, oFont26N ) //"Nota de Crédito"
    						nLin := 400
    					EndIf	
    				
    				Next nX
    			Else
    			    For nX := 1 To Len(aRecSD1)
                    
                        nLin += 80
                        SD1->(DbGoTo(aRecSD1[nX][2]))
                        If SB1->(DbSeek(xFilial("SB1")+SD1->D1_COD))
                            oPrint:Say( nLin, 0200, SD1->D1_COD, oFontCN12 )                                            
                            oPrint:Say( nLin, 0750, Alltrim(SB1->B1_DESC), oFontCN12 )                                                              
                        Endif       
                                                 
                        If nLin > 3000
                            oPrint:EndPage()      // Finaliza a página  
                            oPrint:StartPage()   // Inicializa a página         
                            oPrint:Box( 0100, 0100, 3000, 2300 )
                            oPrint:Say( 0180, 0875, STR0004, oFont26N ) //"Nota de Crédito"
                            nLin := 400
                        EndIf   
                    
                    Next nX
    			
    			EndIF
				oPrint:EndPage()   // Finaliza a página	
     		Endif	
		Endif
		SE1->(DbSkip())
	End

Endif	

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} Ljr860CB
Gera Texto para impressao do Comprovante da NCC com Código de Barras

@type 		Function
@author 	Alberto Deviciente
@since 		12/12/2018
@version 	P12.1.17

@param		aDocDev, Array, Documento de Devolução
@param		aRecSD2, Array, Recnos de SD2

@return  	Array, Retorna um array com a relacao de texto e o respectivo codigo de barras da NCC a ser impresso
/*/
//-------------------------------------------------------------------
User Function Ljr860CB()
Local aDocDev		:= Paramixb[1] 				// Documento de Devolução
Local aRecSD2		:= Paramixb[2] 				// Recnos de SD2
Local lImpFiscal	:= Paramixb[3] 				// Indica se esta usando impressora Fiscal ou Nao Fiscal
Local aArea    		:= GetArea()				// Guarda a area anterior
Local aAreaSE1    	:= SE1->(GetArea())			// Guarda a area da tabela SE1
Local cPrefixo 		:= ""
Local cNumTit 		:= ""
Local cCliente 		:= ""
Local cLoja			:= ""
Local nX	 		:= 0 						// Contador
Local aRetorno		:= {}						// Array de Retorno da funcao
Local cTxtCab 		:= ""						// Texto Inicial do comprovante
Local cCodBar		:= ""						// Codigo de barras a ser impresso
Local cTxtRodape 	:= ""						// Texto Final do comprovante
Local nLarCup	 	:= 47						// Largura do Cupom (qtde de colunas)
Local cLinhaSimp	:= Replicate("-",nLarCup) 	// Linha pontilhada Simples
Local cLinhaDupl	:= Replicate("=",nLarCup) 	// Linha pontilhada Dupla
Local nTamCodPrd 	:= TamSX3("D2_COD")[1]
Local lEndFis   	:= SuperGetMV("MV_SPEDEND",.F.) //Se estiver como F refere-se ao endereço de Cobrança se estiver T  ao  endereço de Entrega.
Local aEndEnt 		:= {}
Local aEndCob 		:= {}
Local cNome			:= ""
Local cLogradouro 	:= ""
Local cNumero 		:= ""
Local cBairro		:= ""
Local cMunicipio	:= ""
Local cUF 			:= ""
Local cCEP			:= ""
Local cCNPJ			:= ""
Local cIE			:= ""
Local cCabec 		:= ""

If !lImpFiscal
	If ExistFunc("LjFiGetEnd")
		aEndEnt := LjFiGetEnd( SM0->M0_ENDENT, SM0->M0_ESTENT, .T. )
		aEndCob := LjFiGetEnd( SM0->M0_ENDCOB, SM0->M0_ESTCOB, .T. )
	Else
		aEndEnt := FisGetEnd( SM0->M0_ENDENT, SM0->M0_ESTENT )
		aEndCob := FisGetEnd( SM0->M0_ENDCOB, SM0->M0_ESTCOB )
	EndIf

	cNome		:= AllTrim(SM0->M0_NOMECOM)
	cLogradouro	:= Left( AllTrim( IIF(!lEndFis,aEndCob[1],aEndEnt[1]) ), 60 )

	//tratamento para o Numero
	If lEndFis .AND. aEndEnt[2] <> 0
		cNumero := AllTrim( aEndEnt[3] )
	ElseIf aEndCob[2] <> 0
		cNumero := AllTrim( aEndCob[3] )
	EndIf 
	cBairro		:= AllTrim( IIF(!lEndFis,SM0->M0_BAIRCOB,SM0->M0_BAIRENT) )
	cMunicipio	:= AllTrim( IIF(!lEndFis,SM0->M0_CIDCOB,SM0->M0_CIDENT) )
	cUF 		:= SM0->M0_ESTCOB
	cCEP		:= AllTrim( IIF(!lEndFis,SM0->M0_CEPCOB,SM0->M0_CEPENT) )
	cCNPJ		:= AllTrim( SM0->M0_CGC )
	cIE			:= AllTrim( SM0->M0_INSC )


	//---------------------------------------------------
	// Monta o Cabecalho com os dados do estabelecimento
	//---------------------------------------------------
	cCabec := PADC(cNome, nLarCup) + CTRL  													//Nome do estabelecimento
	cCabec += PADC(cLogradouro + ", " + cNumero + " - "	+ cBairro, nLarCup) + CTRL 			//Endereço Número Bairro 
	cCabec += PADC(cMunicipio + " - "	+ cUF + " - "	+ "CEP:" + cCEP, nLarCup) + CTRL 	//Municipio UF CEP
	cCabec += PADC("CNPJ:" + cCNPJ + Space(3)	+ "IE:" + cIE + Space(1), nLarCup) + CTRL 	//CNPJ IE do Estabelecimento
EndIf

If Len(aDocDev) > 0

	cPrefixo 	:= aDocDev[1]
	cNumTit 	:= aDocDev[2]
	cCliente 	:= aDocDev[3]
	cLoja		:= aDocDev[4]

	SE1->( DbSetOrder( 2 ) ) //E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
	If SE1->( DbSeek( xFilial("SE1") + cCliente + cLoja + cPrefixo + cNumTit  ) )

		While SE1->(!Eof()) .AND. SE1->E1_FILIAL+SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_PREFIXO+SE1->E1_NUM == xFilial("SE1")+cCliente+cLoja+cPrefixo+cNumTit
			
			If !( SE1->E1_SITUACA $ "27" .OR. SE1->E1_SALDO == 0 )
			
				If ( SE1->E1_TIPO $ MV_CRNEG )
					
					aAdd( aRetorno, {} )
					cTxtCab := ""
					
					If !lImpFiscal
						//---------------------------------------------------
						// Monta o Cabecalho com os dados do estabelecimento
						//---------------------------------------------------
						cTxtCab += cCabec
					EndIf

					//-----------------------
					// Monta o Texto Inicial
					//-----------------------
					cTxtCab += cLinhaDupl + CTRL
					cTxtCab += PadC(Upper("  " + STR0004 + "  "),nLarCup,"*") + CTRL //"Nota de Crédito"
					cTxtCab += cLinhaDupl + CTRL + CTRL

					SA1->(DbSetOrder(1))
					If SA1->(DbSeek(xFilial("SA1")+cCliente+cLoja ))

						cTxtCab += Upper(STR0018) + CTRL							//"Dados do Cliente:"
						cTxtCab += cLinhaSimp + CTRL

						cTxtCab += STR0006 + cCliente + Space(10)					//"Código:"
						cTxtCab += STR0007 + cLoja + CTRL 							//"Loja:"
						cTxtCab += STR0008 + Alltrim(SA1->A1_NOME) + CTRL + CTRL	//"Nome:"
					Endif
					
					cTxtCab += Upper(STR0019) + CTRL								//"Dados da Troca/Devolução:"
					cTxtCab += cLinhaSimp + CTRL

					cTxtCab += STR0009 + DTOC(SE1->E1_EMISSAO) + CTRL				//"Data de Devolução:"
					cTxtCab += STR0010 + DTOC(SE1->E1_VENCREA) + CTRL				//"Data de Validade da NCC:"
					
					cTxtCab += STR0011 + cPrefixo + Space(10)						//"Prefixo:"
					cTxtCab += STR0012 + cNumTit + CTRL								//"Número:"

					cTxtCab += STR0013 + Transform(SE1->E1_SALDO,PesqPict("SE1","E1_SALDO"))//"Saldo NCC:"
					cTxtCab += CTRL + CTRL
		
					If Len(aRecSD2) > 0
						cTxtCab += Upper(STR0020) + CTRL							//"Dados da Troca/Devolução:"
						cTxtCab += cLinhaSimp + CTRL

						cTxtCab += PadR(STR0014,nTamCodPrd)							//"Código"
						cTxtCab += STR0015 + CTRL									//"Descrição"
						
						SB1->(DbSetOrder(1))
						For nX := 1 To Len(aRecSD2)
							SD2->(DbGoTo(aRecSD2[nX][2]))
							If SB1->(DbSeek(xFilial("SB1")+SD2->D2_COD))
								cTxtCab += SD2->D2_COD + Alltrim(SB1->B1_DESC) + CTRL
							Endif
						Next nX
					EndIf

					//-------------------------
					// Gera o codigo de barras
					//-------------------------
					If ExistFunc("LJ720CBNCC") //Verifica se a funcao existe no RPO
						
						//DEVE SER UTILIZADA ESSA FUNCAO, pois ela gera o Codigo de Barras de acordo com a regra que sera utilizada na Leitura tambem
						cCodBar := LJ720CBNCC( SE1->(Recno()) )
					EndIf

					//-------------------------
					// Monta o Texto Final
					//-------------------------
					cTxtRodape := cLinhaDupl + CTRL
					cTxtRodape += PadC(Upper("  " + STR0004 + "  "),nLarCup,"*") + CTRL //"Nota de Crédito"
					cTxtRodape += cLinhaDupl + CTRL + CTRL

					aRetorno[Len(aRetorno)] := { cTxtCab, cCodBar, cTxtRodape } //Adiciona os textos e o codigo de barras da NCC a ser impressa
					
				EndIf

			EndIf
			SE1->(DbSkip())
		End

	EndIf

EndIf

//Restaura as areas que estavam posicionadas anteriormente
RestArea(aAreaSE1)
RestArea(aArea)

Return aRetorno