/*
Padrao DATAMAX
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMG04     ºAutor  ³Sandro Valex        º Data ³  19/06/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada referente a imagem de operador             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Img04 // imagem de etiqueta de dispositivo de movimentacao
Local cCodigo
Local nID := paramixb[1]
IF nID # NIL
	cCodigo := nID
ElseIf Empty(CB1->CB1_IDETIQ)
	IF UsaCB0("04")
		cCodigo := CBGrvEti('04',{CB1->CB1_CODOPE})
		RecLock("CB1",.F.)
		CB1->CB1_IDETIQ := cCodigo
		MsUnlock()
	Else
		cCodigo := CB1->CB1_CODOPE
	EndIf
Else
	IF UsaCB0("04")
		cCodigo := CB1->CB1_IDETIQ
	Else
		cCodigo := CB1->CB1_CODOPE
	EndIf
Endif
cCodigo := Alltrim(cCodigo)
MSCBLOADGRF("SIGA.BMP")
MSCBBEGIN(1,6)
MSCBBOX(02,01,76,34,1)
MSCBLineH(30,30,76,1)
MSCBLineH(02,23,76,1)
MSCBLineH(02,15,76,1)
MSCBLineV(30,23,34,1)
MSCBGRAFIC(2,26,"SIGA")
MSCBSAY(33,31,'OPERADOR',"N","2","01,01")
MSCBSAY(33,27,"CODIGO","N","2","01,01")
MSCBSAY(33,24, CB1->CB1_CODOPE, "N", "2", "01,01")
MSCBSAY(05,20,"NOME","N","2","01,01")
MSCBSAY(05,16,CB1->CB1_NOME,"N", "2", "01,01")
MSCBSAYBAR(22,03,cCodigo,"N","MP07",8.36,.F.,.T.,.F.,,3,2,.F.,.F.,"1",.T.)
MSCBInfoEti("Operador","30X100")
MSCBEND()
Return .F.