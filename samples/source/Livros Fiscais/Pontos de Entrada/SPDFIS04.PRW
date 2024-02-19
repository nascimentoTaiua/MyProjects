#include 'protheus.ch'

Static aNFXML := {}
/*/
Ponto-de-Entrada: SPDFIS04 - Altera a descrição do produto
Descrição: Este ponto de entrada altera a descrição do produto no registro C170 da geração do arquivo magnético para o Sped Fiscal.
Eventos: A chamada é efetuada no momento da montagem do registro C170.
Programa Fonte : SpedFiscal.prw
Sintaxe SPDFIS04 - Altera a descrição do produto ( [ aNota ] ) --> cDescrição
ParamIXB da Chamada: Arrauy com campos Chave do item da nota fiscal que está sendo processado
ExecBlock("SPDFIS04", .F., .F., {(cAliasSFT)->FT_FILIAL,;  //[01] = Filial
							(cAliasSFT)->FT_TIPOMOV,;       //[02] = Tipo Movimento (entrada ou saída)
							(cAliasSFT)->FT_SERIE,;         //[03] = Série
							(cAliasSFT)->FT_NFISCAL,;       //[04] = Nota Fiscal
							(cAliasSFT)->FT_CLIEFOR,;       //[05] = Cliente/Fornecedor
							(cAliasSFT)->FT_LOJA,;          //[06] = Loja
							(cAliasSFT)->FT_ITEM,;          //[07] = Item
							(cAliasSFT)->FT_PRODUTO})       //[08] = Código do Produto

Retorno: Descrição a ser utilizada.
/*/
User Function SPDFIS04()
Local aRet as Array
Local cEstado   := SuperGetMV('MV_ESTADO',.F.,'')
Local cDescricao:= ''

If cEstado == 'AM' 
    aRet := u_HasXMLImp(ParamIXB,'SPDFIS04')
    cDescricao := Iif(Valtype(aRet)=='A',aRet[2],'')
else
    //Customizações do cliente
EndIf
Return(cDescricao)

/*/
    Função HasXMLImp - Procura a nota em SDT/CKO
/*/
User Function HasXMLImp(aDados,cPE)
Local aRet as Array
Local cArquivo := ''
Local cAliasSFT := GetGlbValue('cAliasSFT')
Local lSFT := !Empty(cAliasSFT)

SDS->(dbSetOrder(2))
CKO->(dbSetOrder(1))
SDT->(dbSetOrder(3)) //DT_FILIAL+DT_FORNEC+DT_LOJA+DT_DOC+DT_SERIE+DT_COD

If lSFT .And. !Empty((cAliasSFT)->FT_CHVNFE)
    cChaveNF := xFilial('SDS')+(cAliasSFT)->FT_CHVNFE
    IF SDS->(dbSeek(cChaveNF))
        cArquivo := Alltrim(SDS->DS_ARQUIVO) //xFilial('CKO')+
        If CKO->(dbSeek(cArquivo))
            aRet := SpdRetXML(aDados,cPE,cAliasSFT)
        EndIf
    EndIf
EndIf
Return(aRet)

/*/
    Função: SpdRetXML
/*/
Static Function SpdRetXML(aDados,cPE,cAliasSFT)
Local oXML      as Object
Local nPosi     := 0
Local nPosNf    := 0
Local cError    := ''
Local cWarning  := ''
Local nQtd      := 0
Local aXML      as Array
Local aItens    as Array
Local cChaveNFE as String
Local nRegs     := 0
Local nProdForn := 0
Local cFTReg    as String
Local nTamB1UM := TAMSX3("B1_UM")[1]

cChaveDT := xFilial('SDT')+aDados[5]+aDados[6]+aDados[4]+aDados[3]+aDados[8]//cProdForn

If SDT->(dbSeek(cChaveDT))

    //Verifica quantos itens iguais na SFT
    nRegSFT := f04ItFT()

    nQtd:=-1
    cProdForn := Alltrim(SDT->DT_PRODFOR)
    nRegs := 0
    //verifica item repetido na SDT
    While SDT->(DT_FILIAL+DT_FORNEC+DT_LOJA+DT_DOC+DT_SERIE+DT_COD) == cChaveDT .And. ;
        SDT->(!Eof())
        nRegs++
        If SDT->DT_QUANT == (cAliasSFT)->FT_QUANT
            nQtd := SDT->DT_QUANT
            Exit
        EndIf
        SDT->(dbSkip())    
    Enddo
    
    cXML := CKO->CKO_XMLRET

    If ("</NFE>" $ Upper(cXML))       
        cChaveNFE := SDS->DS_CHAVENFE
        If (nPosNF := ascan(aNFXML,{|a| a[1] == cChaveNFE})) == 0
            If Len(aNFXML)>=10
                For nPosi:=1 to 5
                    Adel(aNFXML,1)
                    aSize(aNFXML,Len(aNFXML)-1)
                Next
            EndIf
            aAdd(aNFXML,{cChaveNFE,{}})
            nPosNF := Len(aNFXML)
            oXML := XmlParser(cXML,"_",@cError,@cWarning)
            If !Empty(oXML) .and. Empty(cError)
                lFound := .F.
                While !lFound
                    oAuxXML := XmlChildEx(oAuxXML,"_NFE")
                    If !(lFound := oAuxXML # NIL)
                        For nPosi := 1 To XmlChildCount(oXML)
                            oAuxXML  := XmlChildEx(XmlGetchild(oXML,nPosi),"_NFE")
                            lFound := oAuxXML:_InfNfe# Nil
                            If lFound
                                oXML := oAuxXML
                                Exit
                            EndIf
                        Next nX
                    EndIf				
                    If lFound
                        Exit
                    EndIf
                EndDo			

                aItens := IIF(ValType(oXML:_InfNfe:_Det) == "O",{oXML:_InfNfe:_Det},oXML:_InfNfe:_Det)

                For nPosi:=1 to Len(aItens)
                    aAdd(aNFXML[nPosNF,2],{aItens[nPosi]:_prod:_cprod:text,;
                                        aItens[nPosi]:_prod:_xprod:text,;
                                        Val(aItens[nPosi]:_prod:_qcom:text),;
                                        aItens[nPosi]:_prod:_uCom:text,;
                                        0,; //lido spdfis02
                                        0}) //qtd lida spdfis04
                Next
            EndIf    
        EndIf
        nProdForn:=1     
        If nQtd = -1 //se não achou, reposiciona
    //       SDT->(dbSeek(cChaveDT))
    //     nQtd := Iif(nRegs==1,SDT->DT_QUANT,(cAliasSFT)->FT_QUANT)
           nQtd := (cAliasSFT)->FT_QUANT
           nProdForn := 0
           Aeval(aNFXML[´nPosNF,2],{|a|Iif(a[1]==cProdForn,nProdForn++,.T.)})
        EndIf
        //encontrou o produto do fornecedor
        If (nPosi := Ascan(aNFXML[nPosNF,2],{|i| i[1] == cProdForn})) > 0
            aXML := {,}
            If cPE = 'SPDFIS04' //spdfis04
                aXML[1] := nPosi //Item
                aXML[2] := aNFXML[nPosNF,2,nPosi,2]//descrição
            Else//spdfis02
                aXML[1] := PADR(aNFXML[nPosNF,2,nPosi,4],nTamB1UM) //Unidade de Medida
                aXML[2] := Iif(nProdForn>1,nQtd,Iif(nRegSFT<=1,aNFXML[nPosNF,2,nPosi,3],nQtd))//Quantidade
                If aXML[2] > 0 //.And. //!(aXML[2]==SFT->FT_QUANT)
                    If !(aXML[1] ==(cAliasSFT)->B1_UM)
                        aAdd(aXML,(cAliasSFT)->B1_CONV)//SFT->FT_QUANT/aXML[2])
                        aAdd(aXML,(cAliasSFT)->B1_TIPCONV)//'M')
                    EndIf
                EndIf
            EndIf
            //ajusta a posição se qtde for igual e tiver mais de um registro na tabela SDT
            If nRegs > 1 .And. (nPosi := Ascan(aNFXML[nPosNF,2],{|i| i[1] == cProdForn .And. i[3] = nQtd})) > 0
                If cPE = 'SPDFIS04' //spdfis04
                    aXML[1] := nPosi //Item
                Else//spdfis02
                    aXML[1] := PADR(aNFXML[nPosNF,2,nPosi,4],nTamB1UM) //Unidade de Medida
                    aXML[2] := aNFXML[nPosNF,2,nPosi,3]//Quantidade
                    If aXML[2] > 0 //.And. //!(aXML[2]==SFT->FT_QUANT)
                        If !(aXML[1] ==(cAliasSFT)->B1_UM)
                            aAdd(aXML,(cAliasSFT)->B1_CONV)//SFT->FT_QUANT/aXML[2])
                            aAdd(aXML,(cAliasSFT)->B1_TIPCONV)//'M')
                        EndIf
                    EndIf
                EndIf
            EndIf
        EndIf
    EndIf 
EndIf

Return(aXML)

/*/
    Função f04ItFT - Retorna a quantidade de registros na tabela SFT referente ao item da tabela SDT
/*/
Static Function f04ItFT()
Local cAreaFT := GetNextAlias()
Local nRet := 0
Local aArea := GetArea()

BEGINSQL Alias cAreaFT
		SELECT COUNT(*) QTREGFT
		FROM %Table:SFT% FT
		WHERE FT.FT_FILIAL 	= %xfilial:SFT% AND 
    	FT.FT_TIPOMOV = 'E'  AND
        FT.FT_SERIE=%Exp:SDT->DT_SERIE% AND
        FT_NFISCAL=%Exp:SDT->DT_DOC% AND
        FT_CLIEFOR=%Exp:SDT->DT_FORNEC% AND
        FT_LOJA=%Exp:SDT->DT_LOJA% AND
        FT_PRODUTO=%Exp:SDT->DT_COD% AND
        FT.%NotDel%
EndSQL

If (cAreaFT)->(!EOF())
	nRet := (cAreaFT)->QTREGFT
EndIf

(cAreaFT)->(dbCloseArea())

RestArea(aArea)

Return(nRet)
