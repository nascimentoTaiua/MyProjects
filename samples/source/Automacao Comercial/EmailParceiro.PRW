#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "AP5MAIL.CH"   // (Para utilizar o comando CONNECT SMTP SERVER.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EmailParceiro  ºAutor  ³Varejo			    º Data ³  09/12/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Envio o e-mail para os parceiros							  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cNumOrc - Número do orçamento								   	³±±
±±³          ³aParcEnviar - Array contendo:
±±³				[1] - Codigo do parceiro					 						³±±
±±³				[2] - Numero do Item						 						³±±
±±³				[3] - Codigo do Produto					 						³±±
±±³				[4] - Descrição do Produto				 						³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ºUso       ³SIGALOJA                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function EmailParceiro()

Local cNumOrc			:= ""			//Numero do orçamento
Local aParcEnviar		:= {}			//Itens com parceiros a enviar
Local lRet				:= .T.			//Verifica se todos email foram enviados			
Local nX 				:=  0			//Contador   
Local cMsg				:= ""			//Mensagem do email
Local cServer  		:= AllTrim(SuperGetMv("MV_RELSERV")) 	//Servidor RPC
Local cEmail   		:= AllTrim(SuperGetMv("MV_RELACNT")) 	//Conta de Email
Local cPass    		:= AllTrim(SuperGetMv("MV_RELPSW"))	//Senha
Local cPassAut  		:= AllTrim(SuperGetMv("MV_RELAPSW"))	//Senha autenticação
Local lRelauth 		:= SuperGetMv("MV_RELAUTH")		//Autenicação
Local lResulConn		:= .T.			//Resultado conexão
Local lResulSend		:= .F.			//Resultado envio		
Local lResult			:= .T.			//Resultado Autenticação 			
Local cError 			:= ""			//Armazena error da conexão
Local cAssunto 		:= "Comissão"	//Assunto
Local cDestino		:= ""			//Destinatario do email

If SuperGetMv("MV_LJPARCE", Nil, .F.) // Define se envio de email para parceiros está ativo
	
	/*Amazena os parâmetros*/
	If Len(ParamIXB) == 2
		cNumOrc := ParamIXB[1]
		aParcEnviar := ParamIXB[2]
	Else 
		Return
	EndIf
	
	If !Empty( cNumorc ) .AND. Len(aParcEnviar) > 0	
			
		For nX := 1 To Len(aParcEnviar)
			
			// Pesquisar destinatário: Email do parceiro
			DbSelectArea("SA3")
			DbSetOrder(1) //A3_FILIAL+A3_COD
			If DbSeek( xFilial("SA3") + aParcEnviar[nX][1] )
				cDestino := AllTrim(SA3->A3_EMAIL)
				If Empty(cDestino)
					lRet := .F.
					Exit
				EndIf
			Else
				lRet := .F.
				Exit
			EndIf			
			
			// Mensagem
			cMsg := 	"Comissão para parceiro gerada:" 	+ CHR(10) +			;
						"Produto: " + aParcEnviar[nX][3]		+ CHR(10) +		;		 
						"Descrição: " + aParcEnviar[nX][4]		+ CHR(10) 
	
			
			CONNECT SMTP SERVER cServer ACCOUNT cEmail PASSWORD cPass RESULT lResulConn			             
			              
			If !lResulConn
			   GET MAIL ERROR cError				  
			   MsgAlert("Falha na conexao : "+cError)//"Falha na conexao : "				   
			   Return(.F.)
			Endif	
			
			// AUTENTICACAO (OPICIONAL)
			If lRelauth
		       lResult := MailAuth(Alltrim(cEmail), Alltrim(cPassAut))
		   		//Se nao conseguiu fazer a Autenticacao usando o E-mail completo, 
		   		//tenta fazer a autenticacao usando apenas o nome de usuario do E-mail
				If !lResult
					nA := At("@",cEmail)
					cUser	:= If(nA>0,Subs(cEmail,1,nA-1),cEmail)
					lResult := MailAuth(Alltrim(cUser), Alltrim(cPassAut))
				EndIf
			EndIf
			
			// ENVIA O EMAIL
			If lResult 
				SEND MAIL FROM cEmail TO cDestino SUBJECT cAssunto BODY cMsg RESULT lResulSend				
				
				If !lResulSend
		   			GET MAIL ERROR cError	  
		  		    MsgAlert("Falha no Envio do e-mail " + CHR(13)+CHR(10)		+; //"Falha no Envio do e-mail "
		  		        		"Erro :" + cError + CHR(13)+CHR(10)				+; //"Erro :"
		  		        		"Destinatário :" + cDestino 						)  //"Destinatário :"
			  	Endif				
			EndIf 
						
			DISCONNECT SMTP SERVER
			   	
			lRet := lRet .AND. lResulSend
		
		Next nY
		   	
		If lRet
			MsgInfo("E-mail enviado com sucesso !"	)//"E-mail enviado com sucesso !"	
		Else
			MsgAlert("Um ou mais e-mails não foram enviados.")//"Um ou mais e-mails não foram enviados. Verifique !"
		EndIf
				
	EndIf
	
EndIf

Return

