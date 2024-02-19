/*
Padrao DATAMAX
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIMG10     บAutor  ณAnderson Rodrigues  บ Data ณ  25/02/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณPonto de entrada referente a imagem de identificacao do     บฑฑ
ฑฑบ          ณPallet                                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAP6                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function IMG10  // imagem do Pallet
Local cCodigo:= Paramixb[1] // Codigo da etiqueta do Pallet

MSCBLOADGRF("SIGA.BMP")
MSCBBEGIN(1,6)
MSCBBOX(02,01,76,34,1)
MSCBLineH(30,30,76,1)
MSCBLineH(02,23,76,1)
MSCBLineH(02,15,76,1)
MSCBLineV(30,23,34,1)
MSCBGRAFIC(2,26,"SIGA")
MSCBSAY(33,31,'PALLET',"N","2","01,01")
MSCBSAY(33,27,"CODIGO","N","2","01,01")
MSCBSAY(33,24,cCodigo , "N", "2", "01,01")
MSCBSAYBAR(22,03,cCodigo,"N","MB07",8.36,.F.,.T.,.F.,,3,2,.F.,.F.,"1",.T.)
MSCBInfoEti("Pallet","30X80")
MSCBEND()
Return .F.