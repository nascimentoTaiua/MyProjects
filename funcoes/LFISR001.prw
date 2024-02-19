#Include "PROTHEUS.ch"
#Include "FWMVCDef.ch"
#Include "TopConn.CH"
#Include "fileio.ch"
#Include "TbiConn.ch"
#Include "Rwmake.ch"
Static __cFileLog
// --------------------------------------------------
/*/ Rotina LFISR001
  
   Importar XML (CTE).

  @author Anderson Almeida - TOTVS Ne
  Retorno
  @historia
   18/05/2023 - Desenvolvimento da Rotina.
/*/
// --------------------------------------------------
User Function LFISR001()
  Local aCampos := {}

  Private cMemoXML := ""
  Private aButtons := {{.F.,Nil},;
                       {.F.,Nil},;
                       {.F.,Nil},;
                       {.F.,Nil},;
                       {.F.,Nil},;
                       {.F.,Nil},;
                       {.F.,"Confirmar"},;
                       {.T.,"Fechar"},;
                       {.F.,Nil},;
                       {.F.,Nil},;
                       {.F.,Nil},;
                       {.F.,Nil},;
                       {.F.,Nil},;
                       {.F.,Nil}}

 // -- Criar tabela temporária
 // -- Cabeçalho
 // --------------------------
  aAdd(aCampos,{"T1_CHAVE","C",1,0})

  oTempTRB1 := FWTemporaryTable():New("TRB1")
  oTempTRB1:SetFields(aCampos)
  oTempTRB1:AddIndex("01",{"T1_CHAVE"})
  oTempTRB1:Create()

  aCampos := {}

  aAdd(aCampos,{"T2_CHAVE" ,"C",1,0})
  aAdd(aCampos,{"T2_ITEM"  ,"C",4,0})
  aAdd(aCampos,{"T2_NOMARQ","C",80,0})
  aAdd(aCampos,{"T2_DATA"  ,"D",8,0})
  aAdd(aCampos,{"T2_HORA"  ,"C",8,0})
  aAdd(aCampos,{"T2_STATUS","L",1,0})

  oTempTRB2 := FWTemporaryTable():New("TRB2")
  oTempTRB2:SetFields(aCampos)
  oTempTRB2:AddIndex("01",{"T2_CHAVE","T2_ITEM"})
  oTempTRB2:Create()

  aCampos := {}

  aAdd(aCampos,{"T3_CHAVE" ,"C",1,0})
  aAdd(aCampos,{"T3_ITEM"  ,"C",4,0})
  aAdd(aCampos,{"T3_NOMARQ","C",80,0})
  aAdd(aCampos,{"T3_DATA"  ,"D",8,0})
  aAdd(aCampos,{"T3_HORA"  ,"C",8,0})

  oTempTRB3 := FWTemporaryTable():New("TRB3")
  oTempTRB3:SetFields(aCampos)
  oTempTRB3:AddIndex("01",{"T3_CHAVE","T3_ITEM"})
  oTempTRB3:Create()

  aCampos := {}

  aAdd(aCampos,{"T4_CHAVE" ,"C",1,0})
  aAdd(aCampos,{"T4_SEQ"   ,"C",2,0})
  aAdd(aCampos,{"T4_STATUS","C",15,0})
  aAdd(aCampos,{"T4_NOMARQ","C",80,0})
  aAdd(aCampos,{"T4_DATA"  ,"D",8,0})
  aAdd(aCampos,{"T4_HORA"  ,"C",8,0})
  aAdd(aCampos,{"T4_MENSAG","C",250,0})

  oTempTRB4 := FWTemporaryTable():New("TRB4")
  oTempTRB4:SetFields(aCampos)
  oTempTRB4:AddIndex("01",{"T4_CHAVE","T4_SEQ"})
  oTempTRB4:Create()

  FWExecView("Importar","LFISR001",MODEL_OPERATION_INSERT,,{|| .T.},,,aButtons)

  oTempTRB1:Delete() 
  oTempTRB2:Delete() 
  oTempTRB3:Delete() 
  oTempTRB4:Delete() 
Return

// -----------------------------------------
/*/ FunÃ§Ã£o ModelDef

   Define as regras de negocio.

  @author Totvs Nordeste
  Return
  @Since  28/04/2023
/*/
// -----------------------------------------
Static Function ModelDef() 
  Local oModel
  Local oStrCab as Object
  Local oStrTRB2 := fnM01TB2()
  Local oStrTRB3 := fnM01TB3()
  Local oStrTRB4 := fnM01TB4()

  oStrCab := FWFormModelStruct():New()

  oStrCab:AddTable("",{"XXTABKEY"},"XML (CTE)",{|| ""})
  oStrCab:AddField("Chave","Campo de texto","T1_CHAVE","C",1)
  
//  oModel:AddGrid("DETLOT","DETPED",oStruLot,bPreVld,bLinPost,bLinPost)  
  oModel := MPFormModel():New("Importar XML (CTE)")  

  oModel:SetDescription("Importar XML")

  oModel:AddFields("MSTCAB",,oStrCab)
 
  oModel:AddGrid("DETREC","MSTCAB",oStrTRB2)
  oModel:AddGrid("DETPRO","MSTCAB",oStrTRB3)
  oModel:AddGrid("DETHIS","MSTCAB",oStrTRB4)

  oModel:SetPrimaryKey({"T1_CHAVE"})

  oModel:SetRelation("DETREC",{{"T2_CHAVE","T1_CHAVE"}}, TRB2->(IndexKey(1)))
  oModel:SetRelation("DETPRO",{{"T3_CHAVE","T1_CHAVE"}}, TRB3->(IndexKey(1)))
  oModel:SetRelation("DETHIS",{{"T4_CHAVE","T1_CHAVE"}}, TRB4->(IndexKey(1)))
Return oModel

// -----------------------------------------
/*/ Função fnGerBor

   Gerar Bordero.

  @author Totvs Nordeste
  Return
  @Since  28/04/2023
/*/
// -----------------------------------------
Static Function fnGerBor(oModel)
  Local lRet    := .T.
//  Local oGrdBco := oModel:GetModel("DETREC")
 
  MsExecAuto({|a,b| (a,b)},3,{aRegBor, aRegTit})

  If lMsErroAuto
     MostraErro()
  EndIf
Return lRet

//-------------------------------------------
/*/ Função fnM01TB2()

  Estrutura do detalhe da pasta Recebidas.							  

  @author Anderson Almeida (TOTVS NE)
  @since	28/04/2023	
/*/
//--------------------------------------------
Static Function fnM01TB2()
  Local oStruct := FWFormModelStruct():New()

  oStruct:AddTable("TRB2",{"T2_CHAVE","T2_ITEM"},"Recebidas")
  oStruct:AddField("Chave" ,"Chave","T2_CHAVE"  ,"C",1,0,Nil,Nil,{},.F.,,.F.,.F.,.F.)
  oStruct:AddField("Item"  ,"Item" ,"T2_ITEM"   ,"C",4,0,Nil,Nil,{},.F.,,.F.,.F.,.F.)
  oStruct:AddField("XML"   ,"XML"  ,"T2_NOMARQ" ,"C",80,0,Nil,Nil,{},.F.,,.F.,.F.,.F.)
  oStruct:AddField("Data"  ,"Data" ,"T2_DATA"   ,"D",8,0,Nil,Nil,{},.F.,,.F.,.F.,.F.)
  oStruct:AddField("Hora"  ,"Hora" ,"T2_HORA"   ,"C",8,0,Nil,Nil,{},.F.,,.F.,.F.,.F.)
  oStruct:AddField("Status","Status","T2_STATUS","L",1,0,Nil,Nil,{},.F.,,.F.,.F.,.F.)
Return oStruct

//-------------------------------------------
/*/ Função fnM01TB3()

  Estrutura do detalhe da pasta Processados.							  

  @author Anderson Almeida (TOTVS NE)
  @since	28/04/2023	
/*/
//--------------------------------------------
Static Function fnM01TB3()
  Local oStruct := FWFormModelStruct():New()

  oStruct:AddTable("TRB3",{"T3_CHAVE","T3_ITEM"},"Processadas")
  oStruct:AddField("Chave","Chave","T3_CHAVE" ,"C",01,0,Nil,Nil,{},.F.,,.F.,.F.,.F.)
  oStruct:AddField("Item" ,"Item" ,"T3_ITEM"  ,"C",4,0,Nil,Nil,{},.F.,,.F.,.F.,.F.)
  oStruct:AddField("XML"  ,"XML"  ,"T3_NOMARQ","C",80,0,Nil,Nil,{},.F.,,.F.,.F.,.F.)
  oStruct:AddField("Data" ,"Data" ,"T3_DATA"  ,"D",08,0,Nil,Nil,{},.F.,,.F.,.F.,.F.)
  oStruct:AddField("Hora" ,"Hora" ,"T3_HORA"  ,"C",08,0,Nil,Nil,{},.F.,,.F.,.F.,.F.)
Return oStruct

//-------------------------------------------
/*/ Função fnM01TB4()

  Estrutura do detalhe dos Histórico.							  

  @author Anderson Almeida (TOTVS NE)
  @since	28/04/2023	
/*/
//--------------------------------------------
Static Function fnM01TB4()
  Local oStruct := FWFormModelStruct():New()

  oStruct:AddTable("TRB4",{"T4_CHAVE","T4_SEQ"},"Historico")
  oStruct:AddField("Chave"    ,"Chave"    ,"T4_CHAVE" ,"C",01,0,Nil,Nil,{},.F.,,.F.,.F.,.F.)
  oStruct:AddField("Sequencia","Sequencia","T4_SEQ"   ,"C",02,0,Nil,Nil,{},.F.,,.F.,.F.,.F.)
  oStruct:AddField(""         ,""         ,"T4_STATUS","C",15,0,Nil,Nil,{},.F.,,.F.,.F.,.T.)
  oStruct:AddField("XML"      ,"XML"      ,"T4_NOMARQ","C",80,0,Nil,Nil,{},.F.,,.F.,.F.,.F.)
  oStruct:AddField("Data"     ,"Data"     ,"T4_DATA"  ,"D",08,0,Nil,Nil,{},.F.,,.F.,.F.,.F.)
  oStruct:AddField("Hora"     ,"Hora"     ,"T4_HORA"  ,"C",08,0,Nil,Nil,{},.F.,,.F.,.F.,.F.)
  oStruct:AddField("Mensagem" ,"Mensagem" ,"T4_MENSAG","C",250,0,Nil,Nil,{},.F.,,.F.,.F.,.F.)
Return oStruct

//--------------------------------------
/*/ Função ViewDef()
  
    Definição da View

  @author Anderson Almeida (TOTVS NE)
  @since	28/04/2023	
/*/
//---------------------------------------
Static Function ViewDef() 
  Local oModel   := ModelDef() 
  Local oStrTRB1 := fnV01TB1()
  Local oStrTRB2 := fnV01TB2()
  Local oStrTRB3 := fnV01TB3()
//  Local oStrTRB4 := fnV01TB4()
  Local oView

  oView := FWFormView():New() 
   
  oView:SetModel(oModel)
  oView:AddOtherObject("FXML", {|oPanel| fnCriaMem(oPanel)})
  oView:AddOtherObject("FBOT", {|oPanel| fnCriaBut(oPanel)})

  oView:AddField("FCAB",oStrTRB1,"MSTCAB") 
  oView:AddGrid("FREC" ,oStrTRB2,"DETREC") 
  oView:AddGrid("FPRO" ,oStrTRB3,"DETPRO") 
//  oView:AddGrid("FHIS" ,oStrTRB4,"DETHIS") 

  oView:SetViewProperty("FREC","GRIDDOUBLECLICK",{{|oGrid,cField,nLGrid,nLModel| fnDbClick(oGrid,cField,nLGrid,nLModel)}})

  oView:EnableTitleView("FREC","Recebidos") 
  oView:EnableTitleView("FPRO","Processados") 
//  oView:EnableTitleView("FHIS","Historicos") 
  oView:EnableTitleView("FXML","XML") 

 // --- Definição da Tela
 // ---------------------
  oView:CreateHorizontalBox("BXSUP",0)
  
  oView:CreateHorizontalBox("BXARQ",45) 
  oView:CreateVerticalBox("VREC",50,"BXARQ")  
  oView:CreateVerticalBox("VPRO",50,"BXARQ")  
  
  oView:CreateHorizontalBox("BXINF",45)  
//  oView:CreateVerticalBox("VHIS",50,"BXINF")
//  oView:CreateVerticalBox("VXML",50,"BXINF")

  oView:CreateHorizontalBox("BXROD",10)  

 // --- Definição dos campos
 // ------------------------    
  oView:SetOwnerView("FCAB","BXSUP")
  oView:SetOwnerView("FREC","VREC")
  oView:SetOwnerView("FPRO","VPRO")
 // oView:SetOwnerView("FHIS","VHIS")
  oView:SetOwnerView("FXML","BXINF")
  oView:SetOwnerView("FBOT","BXROD")

  oView:SetViewAction("ASKONCANCELSHOW",{|| .F.})           // Tirar a mensagem do final "Há Alterações não..."
  oView:SetAfterViewActivate({|oView| fnLerRec(oView)})     // Carregar dados antes de montar a tela
  oView:ShowInsertMsg(.F.)
Return oView

//---------------------------------------
/*/ Função fnCriaMem

    Cria campo Memo.

  @param oPanel = campo será mostrado
  @author Anderson Almeida (TOTVS NE)
  @since	23/11/2020	
/*/
//---------------------------------------
Static Function fnCriaMem(oPanel)
  oTMultiGet := TMultiget():New(01,01, {|u| If(pCount() > 0, cMemoXML := u, cMemoXML)},oPanel,640,105,,,,,,.F.,,,,,,.T.)
Return

//---------------------------------------
/*/ Função fnCriaBut

    Cria botão.

  @param oPanel = campo será mostrado
  @author Anderson Almeida (TOTVS NE)
  @since	23/11/2020	
/*/
//---------------------------------------
Static Function fnCriaBut(oPanel)
  TButton():New(003,610,"Importar",oPanel,{|| MsAguarde({|| fnImportar()},"Gerando...")},40,13,,,.F.,.T.,.F.,,.F.,,,.F.)
Return

//-------------------------------------------------
/*/ Função fnDbClick

   Dublo click no grid. Ler XML

  @Parâmetro: oGrid = Objecto Grid
              cField = nome do campo
              nLGrid = Linha do grid
              nLModel = Linha do grid
  @author Anderson Almeida (TOTVS NE)
  @since  25/05/2023	
/*/
//--------------------------------------------------
Static Function fnDbClick(oGrid,cField,nLGrid,nLModel)
  Local cXMLOri := "C:\XML\" + AllTrim(oGrid:GetModel("FREC"):GetValue("T2_NOMARQ"))
  Local nHandle := 0
  Local nLength := 0
  
  If cField == "T2_NOMARQ"
   	 nHandle := FOpen(cXMLOri)
	   nLength := FSeek(nHandle,0,FS_END)

	   FSeek(nHandle,0)

	   If nHandle > 0
		    FRead(nHandle, cXMLOri, nLength)
		    FClose(nHandle)
			
		    If ! Empty(cXMLOri)
				   cMemoXML := DecodeUTF8(cXMLOri)
				   cMemoXML := A140IRemASC(cMemoXML)	//remove caracteres especiais não aceitos pelo encode
		    EndIf
	   EndIf
  EndIf 
Return .T. 

//-------------------------------------------
/*/ Função fnV01TB1

   Estrutura do detalhe do Cabeçalho (View)
  						  
  @author Anderson Almeida (TOTVS NE)
  @since  18/05/2023
/*/
//-------------------------------------------
Static Function fnV01TB1()
  Local oViewTB := FWFormViewStruct():New() 

 // -- Montagem Estrutura
 //      01 = Nome do Campo
 //      02 = Ordem
 //      03 = Tí­tulo do campo
 //      04 = Descrição do campo
 //      05 = Array com Help
 //      06 = Tipo do campo
 //      07 = Picture
 //      08 = Bloco de PictTre Var
 //      09 = Consulta F3
 //      10 = Indica se o campo é alterável
 //      11 = Pasta do Campo
 //      12 = Agrupamnento do campo
 //      13 = Lista de valores permitido do campo (Combo)
 //      14 = Tamanho máximo da opção do combo
 //      15 = Inicializador de Browse
 //      16 = Indica se o campo é virtual (.T. ou .F.)
 //      17 = Picture Variavel
 //      18 = Indica pulo de linha após o campo (.T. ou .F.)
 // --------------------------------------------------------
  oViewTB:AddField("T1_CHAVE","01","Chave","XML (CTE)",Nil,"C","@!",Nil,"",.F.,Nil,Nil,Nil,Nil,Nil,.F.,Nil,Nil)
Return oViewTB

//-------------------------------------------
/*/ FunÃ§Ã£o fnV01TB2

   Estrutura do detalhe do Grid (View)
   Recebidas						  
  @author Anderson Almeida (TOTVS NE)
  @since  18/05/2023
/*/
//-------------------------------------------
Static Function fnV01TB2()
  Local oViewTB := FWFormViewStruct():New() 

  oViewTB:AddField("T2_STATUS","01",""    ,""    ,Nil,"L",""  ,Nil,"",.T.,Nil,Nil,Nil,Nil,Nil,.F.,Nil,Nil)
  oViewTB:AddField("T2_NOMARQ","02","XML" ,"XML" ,Nil,"C","@!",Nil,"",.F.,Nil,Nil,Nil,Nil,Nil,.F.,Nil,Nil,450)
  oViewTB:AddField("T2_DATA"  ,"03","Data","Data",Nil,"D","@!",Nil,"",.F.,Nil,Nil,Nil,Nil,Nil,.F.,Nil,Nil)
  oViewTB:AddField("T2_HORA"  ,"04","Hora","Hora",Nil,"C","@!",Nil,"",.F.,Nil,Nil,Nil,Nil,Nil,.F.,Nil,Nil)
Return oViewTB

//-------------------------------------------
/*/ FunÃ§Ã£o fnV01TB3

   Estrutura do detalhe do Grid (View)
   Processadas					  
  @author Anderson Almeida (TOTVS NE)
  @since  28/04/2023
/*/
//-------------------------------------------
Static Function fnV01TB3()
  Local oViewTB := FWFormViewStruct():New() 

  oViewTB:AddField("T3_NOMARQ","01","XML" ,"XML" ,Nil,"C","@!",Nil,"",.F.,Nil,Nil,Nil,Nil,Nil,.F.,Nil,Nil,450)
  oViewTB:AddField("T3_DATA"  ,"02","Data","Data",Nil,"D","@!",Nil,"",.F.,Nil,Nil,Nil,Nil,Nil,.F.,Nil,Nil)
  oViewTB:AddField("T3_HORA"  ,"03","Hora","Hora",Nil,"C","@!",Nil,"",.F.,Nil,Nil,Nil,Nil,Nil,.F.,Nil,Nil)
Return oViewTB

//-------------------------------------------
/*/ FunÃ§Ã£o fnV01TB4

   Estrutura do detalhe do Grid (View)
   Historico						  
  @author Anderson Almeida (TOTVS NE)
  @since  18/05/2023
/*/
//-------------------------------------------
Static Function fnV01TB4()
  Local oViewTB := FWFormViewStruct():New() 

  oViewTB:AddField("T4_STATUS","00",""        ,""        ,{"Legenda"},"C","@BMP",Nil,Nil,.F.,Nil,Nil,Nil,Nil,Nil,.F.,Nil,Nil)
  oViewTB:AddField("T4_NOMARQ","01","XML"     ,"XML"     ,Nil,"C","@!",Nil,"",.F.,Nil,Nil,Nil,Nil,Nil,.F.,Nil,Nil)
  oViewTB:AddField("T4_DATA"  ,"02","Data"    ,"Data"    ,Nil,"D","@!",Nil,"",.F.,Nil,Nil,Nil,Nil,Nil,.F.,Nil,Nil)
  oViewTB:AddField("T4_HORA"  ,"03","Hora"    ,"Hora"    ,Nil,"C","@!",Nil,"",.F.,Nil,Nil,Nil,Nil,Nil,.F.,Nil,Nil)
  oViewTB:AddField("T4_MENSAG","04","Mensagem","Mensagem",Nil,"C","@!",Nil,"",.F.,Nil,Nil,Nil,Nil,Nil,.F.,Nil,Nil)
Return oViewTB

//-------------------------------------------------
/*/ FunÃ§Ã£o fnLerBco

   Carregar nome dos arquivos XML.

  @ParÃ¢metro: oView = Objecto View
  @author Anderson Almeida (TOTVS NE)
  @since  18/05/2023	
/*/
//--------------------------------------------------
Static Function fnLerRec(oView)
  Local oModel  := FwModelActive()
  Local oGrdRec := oModel:GetModel("DETREC")
  Local aFiles  := {}
  Local nX      := 0

  aFiles := Directory("C:\XML\" + "*.XML")

  For nX := 1 To Len(aFiles)
      oGrdRec:AddLine()

      oGrdRec:SetValue("T2_ITEM"  , StrZero(nX,4))
      oGrdRec:SetValue("T2_NOMARQ", AllTrim(aFiles[nX][01]))
      oGrdRec:SetValue("T2_DATA"  , aFiles[nX][03])
      oGrdRec:SetValue("T2_HORA"  , aFiles[nX][04])
  Next

  oGrdRec:GoLine(1)
  oView:Refresh()
Return

//---------------------------------------
/*/ Função fnImportar

    Importar os XMLs selecionados.

  @author Anderson Almeida (TOTVS NE)
  @since	26/05/2023	
/*/
//---------------------------------------
Static Function fnImportar()
  Local oModel     := FwModelActive()
  Local oView      := FwViewActive()
  Local oGrdRec    := oModel:GetModel("DETREC")
  Local oGrdProd   := oModel:GetModel("DETPRO")
  Local oXml       := Nil
  Local nX         := 0
  Local nY         := 0
  Local nItem      := 0
  Local cArqOrig   := ""
  Local cNfArq     := ""
  Local cError     := ""
  Local cWarning   := ""
  Local cEmissao   := ""
  Local cRetExec   := ""
  Local cNFiscal   := ""
  Local cToma      := ""
  Local cProduto   := SuperGetMv("LA_PRODCTE",.F.,"")
  Local cTES       := SuperGetMv("LA_TESCTE",.F.,"")
  Local cNatureza  := SuperGetMv("LA_NATCTE",.F.,"")
  Local cCCCte     := SuperGetMv("LA_CCCTE",.F.,"")
  Local aErro      := {}
  Local aRegSE1    := {}
  Local aRegSF2    := {}
  Local aRegSD2    := {}
  Local aItens     := {}
  Local aFiles     := {}
  Local aParcelas  := {}
  Local aSaveLines := FWSaveRows()
  Local cXmlToma   := "oXml:_CTEPROC:_CTE:_INFCTE:_"
  Local cCNPJCPF   := ""

  Private aResul         := {}
  Private lMsErroAuto    := .F.
  Private lMsHelpAuto    := .T. // Variavel de controle interno do ExecAuto
  Private lAutoErrNoFile := .T. // Variavel que gravar o erro log em arquivo

  oGrdProd:ClearData(.T.)

  dbSelectArea("SA1")
  SA1->(dbSetOrder(3))

  dbSelectArea("SF2")
  SF2->(dbSetOrder(1))            

  For nX := 1 To oGrdRec:Length()
      oGrdRec:GoLine(nX)

      If ! oGrdRec:GetValue("T2_STATUS")
         fnGuardaXml(@oGrdRec,@aFiles)
         Loop
      EndIf

      cArqOrig := AllTrim(oGrdRec:GetValue("T2_NOMARQ"))

      __CopyFile("C:\XML\" + cArqOrig,"xmlcte\recebidos\" + cArqOrig)
	    
      oXml := XmlParserFile("xmlcte\recebidos\" + cArqOrig, "_", @cError, @cWarning)

	    If XMLError() <> 0 .Or. ! Empty(cError)
		     If ! Empty(cError)
			      aAdd(aResul,{"**ERRO (XMLCTe): " + cArqOrig + ": " + cError})		
		      else
			      aAdd(aResul,{"**ERRO (XMLCTe): " + cArqOrig + ": Problemas no arquivo."})
		     EndIf
         
         aAdd(aResul, {Replicate("=",62)})
   	     
         fnGuardaXml(@oGrdRec,@aFiles)
         Loop
		  EndIf

      cNFiscal := StrZero(Val(oXml:_CTEPROC:_CTE:_INFCTE:_IDE:_NCT:Text),TamSX3("F2_DOC")[1]) 
      cNfArq   := oXml:_CTEPROC:_CTE:_INFCTE:_IDE:_SERIE:Text + "/" + cNFiscal
            
     // -- Execuato MATA920 - Nota Fiscal Saída
     // -- Módulo - Livros Fiscais
     // ---------------------------------------
      cEmissao := Substr(oXml:_CTEPROC:_CTE:_INFCTE:_IDE:_DHEMI:Text,1,4) +;
                  SubStr(oXml:_CTEPROC:_CTE:_INFCTE:_IDE:_DHEMI:Text,6,2) +;
                  Substr(oXml:_CTEPROC:_CTE:_INFCTE:_IDE:_DHEMI:Text,9,2)

      If AttIsMemberOf( oXml:_CTEPROC:_CTE:_INFCTE:_IDE,"_TOMA4")
        cCNPJCPF := Alltrim(&(cXmlToma + "IDE:_TOMA4:" + IIF(AttIsMemberOf(&(cXmlToma + "IDE:_TOMA4:"), "_CPF"),":_CPF:Text",":_CNPJ:Text")))
       Else 

        Do Case 
          Case oXml:_CTEPROC:_CTE:_INFCTE:_IDE:_TOMA3:_TOMA:Text == "0"
             cToma := "REM"
          Case oXml:_CTEPROC:_CTE:_INFCTE:_IDE:_TOMA3:_TOMA:Text == "1"
             cToma := "EMIT"
          Case oXml:_CTEPROC:_CTE:_INFCTE:_IDE:_TOMA3:_TOMA:Text == "2"
             cToma := "RECEB"
          Case oXml:_CTEPROC:_CTE:_INFCTE:_IDE:_TOMA3:_TOMA:Text == "3"
             cToma := "DEST"
        End Case

        cCNPJCPF := Alltrim(&(cXmlToma + cToma + IIF(AttIsMemberOf(&(cXmlToma + cToma), "_CPF"),":_CPF:Text",":_CNPJ:Text")))
      EndIf
      
      If ! SA1->(dbSeek(FWxFilial("SA1") + cCNPJCPF))
         aAdd(aResul, {"**ERRO (SA1): NF " + cNfArq + ": Cliente não cadastrado CNPJ - " +;
                       cCNPJCPF})
         aAdd(aResul, {Replicate("=",62)})

         fnGuardaXml(@oGrdRec,@aFiles)
         Loop

       elseIf Empty(SA1->A1_XCNDCTE)
              aAdd(aResul, {"**ERRO (SA1): NF " + cNfArq +;
                            ": Cliente não possue Condição de Pagamento cadastrada - " +;
                            cCNPJCPF})
              aAdd(aResul, {Replicate("=",62)})

              fnGuardaXml(@oGrdRec,@aFiles)
              Loop
      EndIf

      If SF2->(dbSeek(FWxFilial("SF2") + cNFiscal +;
                      Padr(AllTrim(oXml:_CTEPROC:_CTE:_INFCTE:_IDE:_SERIE:Text),TamSX3("F2_SERIE")[1]) +;
                      SA1->A1_COD + SA1->A1_LOJA))  
         aAdd(aResul, {"**ERRO (SF2): NF " + cNfArq + ": já cadastrada."})
         aAdd(aResul, {Replicate("=",62)})

         fnGuardaXml(@oGrdRec,@aFiles)
         Loop
      EndIf

     // -- Cabeçalho Nota
     // -----------------
      Begin Transaction
        aRegSF2 := {}
  
        aAdd(aRegSF2, {"F2_TIPO"   , "N"})
        aAdd(aRegSF2, {"F2_FORMUL" , "N"})
        aAdd(aRegSF2, {"F2_DOC"    , StrZero(Val(oXml:_CTEPROC:_CTE:_INFCTE:_IDE:_NCT:Text),TamSX3("F2_DOC")[1])})
        aAdd(aRegSF2, {"F2_SERIE"  , oXml:_CTEPROC:_CTE:_INFCTE:_IDE:_SERIE:Text})
        aAdd(aRegSF2, {"F2_EMISSAO", SToD(cEmissao)})
        aAdd(aRegSF2, {"F2_CLIENTE", SA1->A1_COD})
        aAdd(aRegSF2, {"F2_TIPOCLI", SA1->A1_TIPO})
        aAdd(aRegSF2, {"F2_LOJA"   , SA1->A1_LOJA})
        aAdd(aRegSF2, {"F2_ESPECIE", "CTE"})
        aAdd(aRegSF2, {"F2_COND"   , SA1->A1_XCNDCTE})
        aAdd(aRegSF2, {"F2_VALBRUT", Val(oXml:_CTEPROC:_CTE:_INFCTE:_VPREST:_VTPREST:Text)})
        aAdd(aRegSF2, {"F2_VALFAT" , Val(oXml:_CTEPROC:_CTE:_INFCTE:_VPREST:_VTPREST:Text)})      
        aAdd(aRegSF2, {"F2_PREFIXO", oXml:_CTEPROC:_CTE:_INFCTE:_IDE:_SERIE:Text})
        aAdd(aRegSF2, {"F2_CHVNFE" , AllTrim(oXml:_CTEPROC:_PROTCTE:_INFPROT:_CHCTE:Text)})
         
       // -- Item Nota
       // ------------
        aItens  := {}
        aRegSD2 := {}

        aAdd(aItens, {"D2_ITEM"  , StrZero(1,TamSX3("D2_ITEM")[1]) ,Nil})
        aAdd(aItens, {"D2_COD"   , cProduto                        ,Nil})
        aAdd(aItens, {"D2_QUANT" , 1                               ,Nil})
        aAdd(aItens, {"D2_PRCVEN", Val(oXml:_CTEPROC:_CTE:_INFCTE:_VPREST:_VTPREST:Text),Nil})
        aAdd(aItens, {"D2_TOTAL" , Val(oXml:_CTEPROC:_CTE:_INFCTE:_VPREST:_VTPREST:Text),Nil})
        aAdd(aItens, {"D2_TES"   , cTES                            ,Nil})
        aAdd(aItens, {"D2_CF"    , oXml:_CTEPROC:_CTE:_INFCTE:_IDE:_CFOP:Text,Nil})
          
        aAdd(aRegSD2, aItens)
          
        MsExecAuto({|x,y,z| MATA920(x,y,z)}, aRegSF2, aRegSD2,3) //Inclusao

        If lMsErroAuto
           cRetExec := ""   
           aErro    := GetAutoGRLog()
        
           For nY := 1 To Len(aErro)
               cRetExec += aErro[nY] +CRLF
           Next

           aAdd(aResul, {"**ERRO (MATA920): NF " + cNfArq + " - " + cRetExec})

           fnGuardaXml(@oGrdRec,@aFiles)
         else
			     If SF2->(dbSeek(FWxFilial("SF2") + SF3->F3_NFISCAL + SF3->F3_SERIE + SF3->F3_CLIEFOR + SF3->F3_LOJA))
              Reclock("SF2",.F.)
                Replace SF2->F2_XMUNDES with oXml:_CTEPROC:_CTE:_INFCTE:_IDE:_CMUNFIM:Text
              SF2->(MsUnLock())
           EndIf   
          
          // -- Gravação Financeiro
          // ----------------------
           aParcelas := Condicao(Val(oXml:_CTEPROC:_CTE:_INFCTE:_VPREST:_VTPREST:Text),;
                                 SA1->A1_XCNDCTE,,SToD(cEmissao))

           For nY := 1 To Len(aParcelas)
               aRegSE1 := {}

               aAdd(aRegSE1, {"E1_PREFIXO", oXml:_CTEPROC:_CTE:_INFCTE:_IDE:_SERIE:Text, Nil})
               aAdd(aRegSE1, {"E1_NUM"    , cNFiscal                                   , Nil})
               aAdd(aRegSE1, {"E1_PARCELA", Strzero(nY,TamSX3("E1_PARCELA")[1])        , Nil})
               aAdd(aRegSE1, {"E1_TIPO"   , "FT"                                       , Nil})
               aAdd(aRegSE1, {"E1_CLIENTE", SA1->A1_COD                                , Nil})
               aAdd(aRegSE1, {"E1_LOJA"   , SA1->A1_LOJA                               , Nil})
               aAdd(aRegSE1, {"E1_NATUREZ", cNatureza                                  , Nil}) 
               aAdd(aRegSE1, {"E1_VALOR"  , aParcelas[nY][02]                          , Nil}) 
               aAdd(aRegSE1, {"E1_VALLIQ" , aParcelas[nY][02]                          , Nil}) 
               aAdd(aRegSE1, {"E1_SALDO"  , aParcelas[nY][02]                          , Nil}) 
               aAdd(aRegSE1, {"E1_NOMCLI" , SA1->A1_NREDUZ                             , Nil})
               aAdd(aRegSE1, {"E1_EMISSAO", SToD(cEmissao)                             , Nil})
               aAdd(aRegSE1, {"E1_VENCTO" , aParcelas[nY][01]                          , Nil})
               aAdd(aRegSE1, {"E1_VENCREA", aParcelas[nY][01]                          , Nil})
               aAdd(aRegSE1, {"E1_VENCORI", aParcelas[nY][01]                          , Nil}) 
               aAdd(aRegSE1, {"E1_CCUSTO" , cCCCte                                     , Nil}) 
               aAdd(aRegSE1, {"E1_MOEDA"  , 1                                          , Nil}) 
               aAdd(aRegSE1, {"E1_SITUACA", "0"                                        , Nil})
               aAdd(aRegSE1, {"E1_ORIGEM" , "FINA040"                                  , Nil})
               aAdd(aRegSE1, {"E1_STATUS" , "A"                                        , Nil})
               aAdd(aRegSE1, {"E1_FLUXO"  , "S"                                        , Nil})
            
               lMsErroAuto := .F.

               MsExecAuto({|x,y| FINA040(x,y)},aRegSE1,3)           
     
               If lMsErroAuto
                  cRetExec := ""   
                  aErro    := GetAutoGRLog()
        
                  For nY := 1 To Len(aErro)
                      cRetExec += aErro[nY] +CRLF
                  Next

                  aAdd(aResul, {"**ERRO (FINA040): NF " + cNfArq + " - " + cRetExec})

                  fnGuardaXml(@oGrdRec,@aFiles)
                  exit
               EndIf                  
            Next

            If lMsErroAuto
               DisarmTransaction()
             else
               aAdd(aResul, {"SUCESSO: NF " + cNfArq})

              // -- Montar o grid Processados
              // ----------------------------
               nItem++

               oGrdProd:AddLine()
               oGrdProd:SetValue("T3_ITEM"  , StrZero(nItem,4))
               oGrdProd:SetValue("T3_NOMARQ", AllTrim(cArqOrig))
               oGrdProd:SetValue("T3_DATA"  , dDataBase)
               oGrdProd:SetValue("T3_HORA"  , Time())
            EndIf         
         EndIf
      End Transaction

      aAdd(aResul, {Replicate("=",60)})
  Next

  fnShowRes()

 // -- Atualizar grid
 // -----------------
  oGrdRec:ClearData(.T.)

  For nX := 1 To Len(aFiles)
      oGrdRec:AddLine()

      oGrdRec:SetValue("T2_ITEM"  , StrZero(nX,4))
      oGrdRec:SetValue("T2_NOMARQ", aFiles[nX][01])
      oGrdRec:SetValue("T2_DATA"  , aFiles[nX][02])
      oGrdRec:SetValue("T2_HORA"  , aFiles[nX][03])
  Next

  FWRestRows(aSaveLines)

  oGrdRec:GoLine(1)

  oView:Refresh()
Return

// ---------------------------------------------------
/*/ Função fnGuardaXml

   Mostra o resultado do processamento.

  @parametro: oGrdRec - Grid Recebidos
              aFiles - matriz com XML sem importação
  @author TOTVS Ne - Anderson
  @history
    25/07/2023 - Desenvolvimento da Rotina.
/*/
// ---------------------------------------------------
Static Function fnGuardaXml(oGrdRec,aFiles)
  aAdd(aFiles, {oGrdRec:GetValue("T2_NOMARQ"),;
                oGrdRec:GetValue("T2_DATA"),;
                oGrdRec:GetValue("T2_HORA")})
Return

// ------------------------------------------
/*/ Função fnShowRes

   Mostra o resultado do processamento.

  @author TOTVS Ne - Anderson
  @history
    25/07/2023 - Desenvolvimento da Rotina.
/*/
// ------------------------------------------
Static Function fnShowRes()
  Local nX     := 0
  Local cFile  := ""
  Local cMask  := "Arquivos Texto (*.TXT) |*.txt|"
  Local cResul := ""
  Local cCRLF	 := CHR(13)+CHR(10)
  Local cMemo
  Local oFont 
  Local oDlg

  For nX := 1 To Len(aResul)
      cResul += aResul[nX][01] + cCRLF
  Next

  Default __cFileLog := Criatrab(,.f.) + ".LOG"

  cMemo := cResul

	Define Font oFont Name "Courier New" Size 5,0

	Define MsDialog oDlg Title __cFileLog From 3,0 To 340,417 Pixel
  	@ 5,5 Get oMemo Var cMemo Memo Size 200,145 Of oDlg Pixel

	  oMemo:bRClicked := {|| AllwaysTrue()}
	  oMemo:oFont     := oFont

	  Define SButton From 153,175 Type 01 Action oDlg:End() Enable Of oDlg Pixel // Apaga
	  Define SButton From 153,145 Type 13 Action (cFile := cGetFile(cMask,OemToAnsi("Salvar Como...")),;
                     If(cFile = "",.t.,MemoWrite(cFile,cMemo)),oDlg:End()) Enable Of oDlg Pixel   // Salva e Apaga
	  Define SButton From 153,115 Type 06 Action (fnPrtAErr(__cFileLog,cMemo),oDlg:End()) Enable Of oDlg Pixel // Imprim/Apaga
	Activate MsDialog oDlg Center

  FErase(__cFileLog)
  
  __cFileLog := Nil
Return cMemo

// ------------------------------------------
/*/ Função fnPrtAErr

   Imprime o arquivo de log

  @author TOTVS Ne - Anderson
  @history
    25/07/2023 - Desenvolvimento da Rotina.
/*/
// ------------------------------------------
Static Function fnPrtAErr(cFileErro,cConteudo)
  Local nLin := 0
  Local nX   := 0	

  Private aReturn:= {"Zebrado",1,"Administracao",1,2,1,"",1}
  
  Default cConteudo := ""

	CursorWait()         
		
	SetPrint(,cFileErro,nil ,"Impressao de Log",cFileErro,'','',.F.,"",.F.,"M")

	If nLastKey <> 27		
  	 SetDefault(aReturn,"")
	   
     nLinha := MLCount(cConteudo,132)
	   
     For nX := 1 To nLinha
				 nLin++
				 
         If nLin > 80
				  	nLin := 1
				  	
            @ 00,00 PSAY AvalImp(132)
				 EndIf
				 
         @ nLin,000 PSAY Memoline(cConteudo,132,nX)        	
	   Next

		 Set device to Screen
		 MS_FLUSH()   
	EndIf
Return .T.
