#include 'protheus.ch'
#INCLUDE 'totvs.ch'
#INCLUDE 'FWMVCDEF.CH'
 
 
User Function TmpMarkBrowse()
 
    Local aArea         := GetArea()
    Local oTempTable := Nil
    Local cTempTable := ""   
    Local nIndice     := 0    
    Local aColumns := {}    
    Local oMarkBrowse
     
    //Constrói estrutura da temporária
    cTempTable := fBuildTmp(@oTempTable) 
     
    DbSelectArea(cTempTable)
    (cTempTable)->( DbSetOrder(1) )
    (cTempTable)->( DbGoTop() )
    lAcao := .T.
    //Alimenta a tabela temporária para teste.        
    For nIndice := 1 To 10                                
        If( RecLock(cTempTable, lAcao) )            
            (cTempTable)->ANO       := "2020"
            (cTempTable)->PRODUTO := "PRODUTO - "+cValToChar(nIndice)
            MsUnLock()
        EndIf
    Next
     
    //Constrói estrutura das colunas do FWMarkBrowse
    aColumns := fBuildColumns()
     
    //Criando o FWMarkBrowse
    oMarkBrowse := FWMarkBrowse():New()
    oMarkBrowse:SetAlias(cTempTable)                
    oMarkBrowse:SetDescription('Seleção Tabela Temporária')
    oMarkBrowse:DisableReport()
    oMarkBrowse:SetFieldMark( 'OK' )    //Campo que será marcado/descmarcado
    oMarkBrowse:SetTemporary(.T.)
    oMarkBrowse:SetColumns(aColumns)
         
    //Inicializa com todos registros marcados
    oMarkBrowse:AllMark() 
        
    //Ativando a janela
    oMarkBrowse:Activate()
         
    oTempTable:Delete()
    oMarkBrowse:DeActivate()
    FreeObj(oTempTable)
    FreeObj(oMarkBrowse)
    RestArea( aArea )
Return 
 
/*
    Descrição: Constrói tabela temporária.
    Data     : 26/05/2020
    Param    : Object, Endereço do content da temporária
    Return   : Character, nome da tabela criada.    
*/
Static Function fBuildTmp(oTempTable)
 
    Local cAliasTemp := "ZMARC_"+FWTimeStamp(1)
    Local aFields    := {}
         
    //Monta estrutura de campos da temporária
    aAdd(aFields, { "OK"       , "C", 2, 0 })
    aAdd(aFields, { "ANO"      , "C", 4, 0 })
    aAdd(aFields, { "PRODUTO"  , GetSx3Cache("B1_COD","X3_TIPO"), GetSx3Cache("B1_COD","X3_TAMANHO"), GetSx3Cache("B1_COD","X3_DECIMAL")  })
         
    oTempTable:= FWTemporaryTable():New(cAliasTemp)
    oTemptable:SetFields( aFields )
    oTempTable:AddIndex("01", {"PRODUTO"} )    
    oTempTable:Create()    
 
Return oTempTable:GetAlias()
 
/*
    Descrição: Constrói estrutura das colunas que serão apresentadas na tela.
    Data     : 26/05/2020
    Return   : Nil        
*/
Static Function fBuildColumns()
     
    Local nX       := 0 
    Local aColumns := {}
    Local aStruct  := {}
     
    AAdd(aStruct, {"OK"           , "C", 2 , 0})
    AAdd(aStruct, {"ANO"        , "C", 4 , 0})
    AAdd(aStruct, {"PRODUTO"   , "C",20 , 0})
             
    For nX := 2 To Len(aStruct)    
        AAdd(aColumns,FWBrwColumn():New())
        aColumns[Len(aColumns)]:SetData( &("{||"+aStruct[nX][1]+"}") )
        aColumns[Len(aColumns)]:SetTitle(aStruct[nX][1])
        aColumns[Len(aColumns)]:SetSize(aStruct[nX][3])
        aColumns[Len(aColumns)]:SetDecimal(aStruct[nX][4])              
    Next nX
Return aColumns
