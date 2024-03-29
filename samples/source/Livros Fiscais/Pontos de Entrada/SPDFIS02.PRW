#include 'protheus.ch'
/*/
Ponto de Entrada
SPDFIS02 - Unidade de medida e quantidade do item do documento
Descri��o - Ponto de Entrada que define a unidade de medida e quantidade do item do documento. 
            Por padr�o � assumida sempre a primeira unidade de medida e a primeira quantidade 
            (para gerar o registro 0190 e campo 06 do registro C170). Para utilizar a segunda 
            unidade de medida e a segunda quantidade, � preciso realizar o tratamento utilizando 
            este ponto de entrada. 

Localiza��es
Apura��o da EFD Contribui��es e SPED Fiscal
Programas Fonte: SPEDFISCAL.PRW e FISA008.PRW
Sintaxe	
SPDFIS02 - Unidade de medida e quantidade do item do documento ( [ AlsSD ] , [ cTpMov ] , [cRegSped] ) --> aRet

Par�metros da chamada:

AlsSD: Caracter - Alias posicionado, podendo ser o alias da query principal (TOP), ou SD1/SD2 (DBF).
                  No caso do SpedPisCofins sempre � passado o DBF(SD1/SD2).
cTpMov: Caracter - Tipo Movimento, podendo ser "E" de Entrada ou "S" de sa�da (FT_TIPOMOV)
cRegSped: Caracter - Nome do Registro(1105, G140, H010, K200). A partir da� � poss�vel fazer um tratamento espec�fico ao posicionar o produto, 
                    ou simplesmente retornar a segunda unidade de medida e a segunda quantidade deste documento (D1_SEGUM ou D2_SEGUM). 

Retorno:
aRet - (array_of_record)
aRet[1] => Unidade de Medida do item do documento 
aRet[2] => Quantidade do item do documento 
aRet[3] => Fator de Convers�o. essa posi��o do array � opcional. 
aRet[4] => Tipo de Convers�o M=Multiplica��o/D=Divis�o. essa posi��o do array � opcional.

Importante
- Na chamada do SPDFIS02 para alguns registros K200, H010(SPED Fiscal) n�o ocorrer� tratamento para o cTpMov (FT_TIPOMOV), 
pois estes registros n�o s�o gerados com base na movimenta��o das notas do per�odo e sim com base na 
produ��o(K200) e no invent�rio(H010) do per�odo respectivamente. 

- Par�metro MV_GER0220: Indica se gera registro de convers�es de unidades de mediadas
/*/
User Function SPDFIS02()
Local aAreaAnt  := GetArea()
Local cAliasSFT := ParamIXB[1] // Alias principal
Local cTipoMov  := ParamIXB[2] // Tipo movimento-E=ENTRADA|S=SAIDA, registros originados de notas fiscais./Registros n�o originados de notas fiscais conte�do Nil.
Local aReg      := {}
Local cEstado   := SuperGetMV('MV_ESTADO',.F.,'')

If cEstado == 'AM' .And. cTipoMov=='E'
    aReg := u_HasXMLImp({(cAliasSFT)->FT_FILIAL,;  //[01] = Filial
                        (cAliasSFT)->FT_TIPOMOV,;       //[02] = Tipo Movimento (entrada ou sa�da)
                        (cAliasSFT)->FT_SERIE,;         //[03] = S�rie
                        (cAliasSFT)->FT_NFISCAL,;       //[04] = Nota Fiscal
                        (cAliasSFT)->FT_CLIEFOR,;       //[05] = Cliente/Fornecedor
                        (cAliasSFT)->FT_LOJA,;          //[06] = Loja
                        (cAliasSFT)->FT_ITEM,;          //[07] = Item
                        (cAliasSFT)->FT_PRODUTO},;      //[08] = C�digo do Produto
                        'SPDFIS02')
else
    //Customiza��es do cliente
    aReG := Nil
EndIf

RestArea(aAreaAnt)

Return aReg
