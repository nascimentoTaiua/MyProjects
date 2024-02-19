/*
Padrao DATAMAX
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMG08     ºAutor  ³Anderson Rodrigues  º Data ³  07/11/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Ponto de entrada referente a imagem de identificacao do     º±±
±±º          ³Recurso                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³AP6                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Img08  // imagem da etiqueta do recurso
Local nCopias := Val(paramixb[1])
Local cCodigo := Alltrim(SH1->H1_CODIGO)

MSCBLOADGRF("SIGA.BMP")
MSCBBEGIN(nCopias,6)
MSCBBOX(02,01,76,34,1)
MSCBLineH(30,30,76,1)
MSCBLineH(02,23,76,1)
MSCBLineH(02,15,76,1)
MSCBLineV(30,23,34,1)
MSCBGRAFIC(2,26,"SIGA")
MSCBSAY(33,31,'RECURSO',"N","2","01,01")
MSCBSAY(33,27,"CODIGO","N","2","01,01")
MSCBSAY(33,24,cCodigo , "N", "2", "01,01")
MSCBSAY(05,20,"DESCRICAO","N","2","01,01")
MSCBSAY(05,16,SH1->H1_DESCRI,"N", "2", "01,01")
MSCBSAYBAR(22,03,cCodigo,"N","MB07",8.36,.F.,.T.,.F.,,3,2,.F.,.F.,"1",.T.)
MSCBInfoEti("Recurso","30X100")
MSCBEND()
Return .F.