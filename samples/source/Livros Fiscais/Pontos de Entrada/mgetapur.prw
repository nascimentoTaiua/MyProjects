#include "rwmake.ch"    

User Function MGETAPUR() 

Local cCodImp  := PARAMIXB[1]

If cCodImp == "004"
	AADD(PARAMIXB[2],{"004",PADR("Teste 4",46),100,"DD"})
ElseIf cCodImp == "005"
	AADD(PARAMIXB[2],{"005",PADR("Teste 5",46),200,"DD"})
ElseIf cCodImp == "010"
	AADD(PARAMIXB[2],{"010",PADR("Teste 10",46),300,"DD"})	
ElseIf cCodImp == "012"
	AADD(PARAMIXB[2],{"012",PADR("Teste 12",46),400,"DD"})
Endif		

Return(PARAMIXB[2])    