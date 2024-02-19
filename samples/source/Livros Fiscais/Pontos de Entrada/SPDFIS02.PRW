#include 'protheus.ch'
/*/
Ponto de Entrada
SPDFIS02 - Unidade de medida e quantidade do item do documento
Descrição - Ponto de Entrada que define a unidade de medida e quantidade do item do documento. 
            Por padrão é assumida sempre a primeira unidade de medida e a primeira quantidade 
            (para gerar o registro 0190 e campo 06 do registro C170). Para utilizar a segunda 
            unidade de medida e a segunda quantidade, é preciso realizar o tratamento utilizando 
            este ponto de entrada. 

Localizações
Apuração da EFD Contribuições e SPED Fiscal
Programas Fonte: SPEDFISCAL.PRW e FISA008.PRW
Sintaxe	
SPDFIS02 - Unidade de medida e quantidade do item do documento ( [ AlsSD ] , [ cTpMov ] , [cRegSped] ) --> aRet

Parâmetros da chamada:

AlsSD: Caracter - Alias posicionado, podendo ser o alias da query principal (TOP), ou SD1/SD2 (DBF).
                  No caso do SpedPisCofins sempre é passado o DBF(SD1/SD2).
cTpMov: Caracter - Tipo Movimento, podendo ser "E" de Entrada ou "S" de saída (FT_TIPOMOV)
cRegSped: Caracter - Nome do Registro(1105, G140, H010, K200). A partir daí é possível fazer um tratamento específico ao posicionar o produto, 
                    ou simplesmente retornar a segunda unidade de medida e a segunda quantidade deste documento (D1_SEGUM ou D2_SEGUM). 

Retorno:
aRet - (array_of_record)
aRet[1] => Unidade de Medida do item do documento 
aRet[2] => Quantidade do item do documento 
aRet[3] => Fator de Conversão. essa posição do array é opcional. 
aRet[4] => Tipo de Conversão M=Multiplicação/D=Divisão. essa posição do array é opcional.

Importante
- Na chamada do SPDFIS02 para alguns registros K200, H010(SPED Fiscal) não ocorrerá tratamento para o cTpMov (FT_TIPOMOV), 
pois estes registros não são gerados com base na movimentação das notas do período e sim com base na 
produção(K200) e no inventário(H010) do período respectivamente. 

- Parâmetro MV_GER0220: Indica se gera registro de conversões de unidades de mediadas
/*/
User Function SPDFIS02()
Local aAreaAnt  := GetArea()
Local cAliasSFT := ParamIXB[1] // Alias principal
Local cTipoMov  := ParamIXB[2] // Tipo movimento-E=ENTRADA|S=SAIDA, registros originados de notas fiscais./Registros não originados de notas fiscais conteúdo Nil.
Local aReg      := {}
Local cEstado   := SuperGetMV('MV_ESTADO',.F.,'')

If cEstado == 'AM' .And. cTipoMov=='E'
    aReg := u_HasXMLImp({(cAliasSFT)->FT_FILIAL,;  //[01] = Filial
                        (cAliasSFT)->FT_TIPOMOV,;       //[02] = Tipo Movimento (entrada ou saída)
                        (cAliasSFT)->FT_SERIE,;         //[03] = Série
                        (cAliasSFT)->FT_NFISCAL,;       //[04] = Nota Fiscal
                        (cAliasSFT)->FT_CLIEFOR,;       //[05] = Cliente/Fornecedor
                        (cAliasSFT)->FT_LOJA,;          //[06] = Loja
                        (cAliasSFT)->FT_ITEM,;          //[07] = Item
                        (cAliasSFT)->FT_PRODUTO},;      //[08] = Código do Produto
                        'SPDFIS02')
else
    //Customizações do cliente
    aReG := Nil
EndIf

RestArea(aAreaAnt)

Return aReg
