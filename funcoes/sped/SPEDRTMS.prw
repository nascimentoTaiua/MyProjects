#INCLUDE 'protheus.ch'
#INCLUDE 'totvs.ch'

/*/{Protheus.doc} SPEDRTMS
    O ponto de entrada SPEDRTMS tem como finalidade permitir a manipulação com as informações
    envolvendo Conhecimentos de Transporte para os clientes que possuem movimentos gerados sem
    integração com o ambiente SIGATMS - Gestão de Transportes sendo utilizado na geração do Bloco
    documentos fiscais II serviço (ICMS)" para os Registros: D100, D110, D120, D130, D140, D150,
    D160, D161, D162 e D190.
    @type  Function
    @author TOTVS S.A
    @since 11/01/2024
    @version 1.01
    @see (https://tdn.totvs.com.br/pages/releaseview.action?pageId=696687353)
/*/

User Function SPEDRTMS()

    Local vLinha     := {}
    Local nPos       := ParamIXB[1]
    Local cReg       := ParamIXB[2]
    Local cAlias     := ParamIXB[3]
    Local aCmpAntSFT := ParamIXB[4]
    Local aRet       := {}
    Local vValServ   := 0
    Local vValDoc    := 0
    Local vValICMS   := 0
    Local vValBSICM  := 0
    Local cCod_Part  := ""
    Local cCodMunOri := ""
    Local cCodMunDes := ""
    Local cInd_Oper  := ""
    Local cInd_Emit  := ""
    Local cModelo := AModNot(aCmpAntSFT[42])
    //Campos contidos no array aCmpAntSFT:
    //01 - Doc. Fiscal
    //02 - Serie NF
    //03 - Cliente/Fornecedor
    //04 - Código Loja
    //05 - Data Docto
    //06 - Data Emissão
    //07 - Data Cancelamento
    //08 - Formulário Próprio
    //09 - CFOP
    //10 -
    //11 - Alíq. ICMS
    //12 - Nro. PDV
    //13 - Base  ICMS
    //14 - Alíq. ICMS
    //15 - Valor ICMS
    //16 - Valor Isento ICMS
    //17 - Outros ICMS
    //18 - ICMS Retido ST
    //19 - Conta Contábil
    //20 - Tipo Lançamento
    //21 - Tipo Frete
    //22 - Filial
    //23 - Estado
    //24 - Observação
    //25 - Chave NFE
    //26 - Tipo Emissão
    //27 - Prefixo
    //28 - Duplicata
    //29 - Cupom Fiscal
    //30 - Transportadora
    //31 - Peso Bruto
    //32 - Peso Liquido
    //33 - Veiculo1
    //34 - Veiculo2
    //35 - Veiculo3
    //36 - Optante Simples Nacional
    //37 - Regime Paraíba
    //38 - Nota Fiscal Original
    //39 - Serie da Nota fiscal original
    //40 - Flag de tipo de CTE na entrada
    //41 - Data de Recebimento para Lançamento extemporâneo de documento fiscal.
    //42 - Espécie do Documento
    //43 - Tipo Mov.
    //44 - Mensagem da Nota Fiscal
    //45 - Produto
    //46 - Item
    //47 - Formula
    //48 - Código da TES
    //49 - UF de Origem do Transporte
    //50 - Município de Origem do Transporte
    //51 - UF de Destino do Transporte
    //52 - Município de Destino do Transporte
    //53 - Sub Série da nota fiscal de entrada
    //54 - UF de Origem do Transporte
    //55 - Município de Origem do Transporte
    //56 - UF de Destino do Transporte
    //57 - Município de Destino do Transporte
    //58 - Município de Destino Complemento
    //59 - Chave de Acesso SEFAZ/CTe
    //60 - Documento de Transporte
    //61 - Tipo Frete
    //62 - Quantidade de registros encontrados na GZH
    //63 - Código do Produto na SB1
    //64 - Conta Contábil do Produto na SB1
   
    If aCmpAntSFT[43] == "S"
           
        DbSelectArea("SA1")
        SA1->(DBSetOrder(1))
        SA1->(DBSeek(XFilial("SA1") + aCmpAntSFT[3] + aCmpAntSFT[4]))
   
        cCod_Part   := "SA1"
        cCodMunOri  := SM0->M0_CODMUN
   
        DbSelectArea("SF2")
        SF2->(DBSetOrder(1))
        SF2->(DBSeek(XFilial("SF2") + aCmpAntSFT[1] + aCmpAntSFT[2] + aCmpAntSFT[3] + aCmpAntSFT[4]))

        cCodMunDes  := SF2->F2_XMUNDES

        cCod_Part += SF2->(F2_FILIAL+F2_CLIENTE+F2_LOJA)
    Else
        DbSelectArea("SA2")
        SA2->(DBSetOrder(1))
        SA2->(DBSeek(XFilial("SA2") + aCmpAntSFT[3] + aCmpAntSFT[4]))
   
        cCod_Part   := "SA2"      
  
        DbSelectArea("SF1")
        SF1->(DBSetOrder(1))
        SF1->(DBSeek(XFilial("SF1") + aCmpAntSFT[1] + aCmpAntSFT[2] + aCmpAntSFT[3] + aCmpAntSFT[4]))

        cCodMunOri  := UfCodIBGE(SF1->F1_UFORITR) + AllTrim(SF1->F1_MUORITR)
        cCodMunDes  := UfCodIBGE(SF1->F1_UFDESTR) + AllTrim(SF1->F1_MUDESTR)
   
        cCod_Part += SF1->(F1_FILIAL+F1_FORNECE+F1_LOJA)
    EndIf
   
    If cReg == "D140"
           
        AAdd(vLinha,    "D140")         // 01 - REG
        AAdd(vLinha,    cCod_Part )     // 02 - COD_PART_CONSG
        AAdd(vLinha,    cCodMunOri)     // 03 - COD_MUN_ORIG
        AAdd(vLinha,    cCodMunDes)     // 04 - COD_MUN_DEST
        AAdd(vLinha,    "1")            // 05 - IND_VEIC
        AAdd(vLinha,    "")             // 06 - VEIC_ID
        AAdd(vLinha,    "0")            // 07 - IND_NAV
        AAdd(vLinha,    "")             // 08 - VIAGEM
        AAdd(vLinha,    LTrim(Transform(SF2->F2_VALMERC, "@E 99999999.99"))) // 09 - VL_FRT_LIQ
        AAdd(vLinha,    "")             // 10 - VL_DESP_PORT
        AAdd(vLinha,    "")             // 11 - VL_DESP_CAR_DESC
        AAdd(vLinha,    "")             // 12 - VL_OUT
        AAdd(vLinha,    LTrim(Transform(SF2->F2_VALBRUT, "@E 99999999.99"))) // 13 - VL_FRT_BRT
        AAdd(vLinha,    LTrim(Transform(0.00, "@E 99999999.99"))) // 14 - VL_FRT_MM
        AAdd(aRet, vLinha)
   
   ElseIf cReg == "D120"
           
        AAdd(vLinha,    "D120")         // 01 - REG
        AAdd(vLinha,    cCodMunOri)     // 02 - COD_MUN_ORIG
        AAdd(vLinha,    cCodMunDes)     // 03 - COD_MUN_DEST
        AAdd(vLinha,    "")             // 04 - VEIC_ID
        AAdd(vLinha,    "")             // 05 - UF_ID
        AAdd(aRet, vLinha)
   
    ElseIf cReg == "D100"
   
        If  aCmpAntSFT[43] == "S"
  
            cInd_Oper := "1"
            cInd_Emit := "0"
  
            vValServ  := LTrim(Transform(F2_VALMERC + F2_FRETE + F2_VALICM, "@E 99999999.99"))
            vValDoc   := LTrim(Transform(F2_VALBRUT, "@E 99999999.99"))
            vValICMS  := LTrim(Transform(F2_VALICM , "@E 99999999.99"))
   
        Else
               
            cInd_Oper := "0"
            cInd_Emit := "1"
  
            vValServ := LTrim(Transform(F1_VALMERC + F1_FRETE + F1_VALICM, "@E 99999999.99"))
            vValDoc  := LTrim(Transform(F1_VALBRUT, "@E 99999999.99"))
            vValICMS := LTrim(Transform(F1_VALICM , "@E 99999999.99"))
   
        EndIf
   
        DbSelectArea("SF3")
        SF3->(DBSetOrder(1))
   
        vValBSICM := LTrim(Transform(F3_VALCONT, "@E 99999999.99"))
   
        AAdd(vLinha,    "D100")         //01 REG
        AAdd(vLinha,    cInd_Oper)      //02 IND_OPER
        AAdd(vLinha,    cInd_Emit)      //03 IND_EMIT
        //AAdd(vLinha,    IIf(cModelo$"63", "", cModelo))      //04 COD_PART
        If aCmpAntSFT[43] == "S"
            AAdd(vLinha,    "SA1"+cFilAnt+SA1->A1_COD+SA1->A1_LOJA)//04 COD_PART
        Else
            AAdd(vLinha,    "SA2"+cFilAnt+SA2->A2_COD+SA2->A2_LOJA)//04 COD_PART
        EndIf
        AAdd(vLinha,    AModNot(aCmpAntSFT[42])) //05 COD_MOD
        AAdd(vLinha,    "00")           //06 COD_SIT
        AAdd(vLinha,    aCmpAntSFT[2])  //07 SER
        AAdd(vLinha,    "")             //08 SUB
        AAdd(vLinha,    aCmpAntSFT[1])  //09 NUM_DOC
        AAdd(vLinha,    aCmpAntSFT[25]) //10 CHV_CTE
        AAdd(vLinha,    aCmpAntSFT[5])  //11 DT_DOC
        AAdd(vLinha,    aCmpAntSFT[5])  //12 DT_A_P
        AAdd(vLinha,    0)              //13 TP_CTe
        AAdd(vLinha,    "")             //14 CHV_CTe_REF
        AAdd(vLinha,    vValDoc)        //15 VL_DOC
        AAdd(vLinha,    0)              //16 VL_DESC
        AAdd(vLinha,    IIf(cModelo$"63", "", aCmpAntSFT[21])) //17 IND_FRT
        AAdd(vLinha,    vValServ)       //18 VL_SERV
        AAdd(vLinha,    vValBSICM)      //19 VL_BC_ICMS
        AAdd(vLinha,    vValICMS)       //20 VL_ICMS
        AAdd(vLinha,    0)              //21 VL_NT
        AAdd(vLinha,    "")             //22 COD_INF
        AAdd(vLinha,    "")             //23 COD_CTA
        AAdd(vLinha,    cCodMunOri)     //24 COD_MUN_ORIG
        AAdd(vLinha,    cCodMunDes)     //25 COD_MUN_DEST
        AAdd(aRet, vLinha)
       
    EndIf
    
Return(aRet)
