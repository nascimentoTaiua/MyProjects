#INCLUDE "EECPRL07.ch"


/*
Programa        : EECPRL07.PRW
Objetivo        : Comiss�es Pendentes
Autor           : Cristiane C. Figueiredo
Data/Hora       : 22/05/2000 17:18
Obs.            :

*/

#include "EECRDM.CH"

#define EV_COM_AR     "120" // Comiss�o do Tipo A Remeter. (Utilizada nos tratamentos de Frete Seguro e Comiss�o).
#define EV_COM_CG     "121" // Comiss�o do Tipo Conta Gr�fica. (Utilizada nos tratamentos de Frete Seguro e Comiss�o).
#define EV_COM_DF     "122" // Comiss�o do Deduzir da Fatura. (Utilizada nos tratamentos de Frete Seguro e Comiss�o).

/*
Funcao      : EECPRL07
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : Cristiane C. Figueiredo
Data/Hora   : 22/05/2000 17:18
Revisao     :
Obs.        :
*/

User Function EECPRL07

Local lRet := .T.
Local aOrd := SaveOrd({"EE8","EEM","EEC","EEB","EE7","EEQ"})

Local aArqs
Local cNomDbfC, aCamposC, cNomDbfD, aCamposD
Local aRetCrw, lZero := .t.
Local cPeriodo
Local aTPCOMB := {STR0001,STR0002,STR0003} //"Remeter"###"Conta Grafica"###"Deduzir Fatura"
Local lEmba, cAgeCom, lRecCom, lExport, lFornec, lTpCom, lRecebe, lValCom
Local nValFob, nPercom, nValCom, nDiasCP
Local nValLiq := 0
Local nTotCom := 0
Local cFilEEQ := xFilial("EEQ")
Local cPreemb := "", nAgentes := 0, nRecno := 0  // GFP - 23/10/2014
   
Private dDtIni  := AVCTOD("  /  /  ")
Private dDtFim  := AVCTOD("  /  /  ")
Private cExport := SPACE(AVSX3("A2_COD",3))
Private cExpLj  := SPACE(AVSX3("A2_FILIAL",3))
Private cFabric := SPACE(AVSX3("A2_COD",3))
Private cFablJ  := SPACE(AVSX3("A2_FILIAL",3))

Private cRepres := SPACE(AVSX3("EEB_CODAGE",3))
Private aTpCom  := {STR0004, STR0005,STR0006, STR0007} //"0-Todos"###"1-Remeter"###"2-Conta Gr�fica"###"3-Deduzir Fatura"
Private cTpCom := aTpCom[1]

Private cArqRpt, cTitRpt

//JVR - 11/12/09 - Relat�rio Personalizavel
Private oReport
Private lRelPersonal := FindFunction("TRepInUse") .And. TRepInUse()

Begin Sequence
   IF Select("WorkId") > 0
      cArqRpt := WorkId->EEA_ARQUIV
      cTitRpt := AllTrim(WorkId->EEA_TITULO)
   Else 
      cArqRpt := Posicione("EEA",1,xFilial("EEA")+AvKey("57","EEA_COD"),"EEA_ARQUIV")
      cTitRpt := AllTrim(Posicione("EEA",1,xFilial("EEA")+AvKey("57","EEA_COD"),"EEA_TITULO"))
   Endif

   cNomDbfC:= "WORK07C"
   aCamposC:= {}
   AADD(aCamposC,{"SEQREL","C", 8,0})
   AADD(aCamposC,{"PERIODO","C",30,0})
   AADD(aCamposC,{"EMPRESA","C",60,0})
   AADD(aCamposC,{"FABRIC","C",60,0})
   AADD(aCamposC,{"EXPORT","C",60,0})


   cNomDbfD:= "WORK07D"
   aCamposD:= {}
   AADD(aCamposD,{"SEQREL","C", 8,0})
   AADD(aCamposD,{"DTEMBA","C",10,0})
   AADD(aCamposD,{"DTVENC","C",10,0})
   AADD(aCamposD,{"AGECOM","C",40,0})
   AADD(aCamposD,{"IMPORT","C",20,0})
   AADD(aCamposD,{"PREEMB","C",20,0})
   AADD(aCamposD,{"CONDPA","C",60,0})
   AADD(aCamposD,{"NRINVO","C",20,0})
   AADD(aCamposD,{"TPCOM","C",20,0})
   AADD(aCamposD,{"CODIMP","C",60,0})
   AADD(aCamposD,{"CODAGE","C",60,0})
   AADD(aCamposD,{"VALFOB","N",15,3})
   AADD(aCamposD,{"PERCOM","N",6,2})
   AADD(aCamposD,{"VALCOM","N",15,3})
   //** PLB 01/06/07
   AADD(aCamposD,{"TOTCOM","N",15,3})
   AADD(aCamposD,{"VALLIQ","N",15,3})
   //**

   aArqs := {}
   AADD( aArqs, {cNomDbfc,aCamposc,"CAB","SEQREL"})
   AADD( aArqs, {cNomDbfd,aCamposd,"DET","SEQREL"})

   aRetCrw := crwnewfile(aArqs)

   IF ! TelaGets()
      lRet := .F.
      Break
   Endif

   EEQ->( DBSetOrder(1) )

   EEC->(dbsetorder(12))
   EEC->(DBSEEK(XFILIAL("EEC")+DTOS(dDtIni),.T.))
   
   IF ( Empty(dDtIni) .and. Empty(dDtFim) )
      cPeriodo := STR0008 //"TODOS"
   Else   
      cPeriodo := DtoC(dDtIni) + STR0009 + DtoC(dDtFim) //" ATE "
   Endif
   
   IF empty(cExport)
      cExport := STR0008  //"TODOS"
   ENDIF
   
   IF empty(cFabric)
      cFabric := STR0008  //"TODOS"
   ENDIF
   //rotina principal
   cSEQREL :=GetSXENum("SY0","Y0_SEQREL")
   CONFIRMSX8()

   SysRefresh()
   
   CAB->(DBAPPEND())
   CAB->SEQREL  := cSeqRel 
   CAB->EMPRESA := SM0->M0_NOME
   CAB->PERIODO := cPeriodo
   CAB->FABRIC  := If(cFabric <> STR0008, Posicione("SA2",1,XFILIAL("SA2")+cFabric+cFabLj,"A2_NREDUZ"),cFabric) //"TODOS"
   CAB->EXPORT  := If(cExport <> STR0008, Posicione("SA2",1,XFILIAL("SA2")+cExport+cExpLj,"A2_NREDUZ"),cExport) //"TODOS"
   
   CAB->(MSUNLOCK())
   lZero := .t.
   
    While EEC->(!Eof() .And. EEC->EEC_FILIAL==xFilial("EEC")) .and. EEC->EEC_DTEMBA >= dDtIni .And.  If(Empty(dDtFim),.t.,EEC->EEC_DTEMBA <= dDtFim)
     
     EE9->(DBSETORDER(3))
     EE9->(DBSEEK(XFILIAL("EE9")+EEC->EEC_PREEMB))
     if cFabric == STR0008 //"TODOS"
        lFornec := .f.
     Else
        lFornec := .t.
        Do while EE9->(!eof()) .and. xFilial("EE9") ==  EE9->EE9_FILIAL .AND. EE9->EE9_PREEMB == EEC->EEC_PREEMB
           if cFabric + cFabLj == EE9->EE9_FABR + EE9->EE9_FALOJA
              lFornec := .f.
           Endif
           EE9->(DBSKIP())
        Enddo   
     endif      
     EEB->(DBSETORDER(1))
     lEmba   := EMPTY(EEC->EEC_DTEMBA)
     cAgeCom := BUSCAEMPRESA(EEC->EEC_PREEMB,"Q","3")
     lRecCom := empty(cAgecom)
     lValCom := empty(EEC->EEC_VALCOM)
     lExport := cExport<>STR0008 .and. cExport + cExpLj  <> if(empty(EEC->EEC_EXPORT),EEC->EEC_FORN + EEC->EEC_FOLOJA, EEC->EEC_EXPORT + EEC->EEC_EXLOJA) //"TODOS"
     //MFR 13/01/2022 OSSME-6476
     //lTpCom  := substr(cTpCom,1,1) <> "0" .and. substr(cTpCom,1,1) <> EEC->EEC_TIPCOM
     //lRecebe := !EMPTY(cRepres) .and. !(EEB->(DBSEEK(XFILIAL("EEB")+EEC->EEC_PREEMB+"Q"+cRepres+"3")))
     
     IF ( lExport .or. lFornec .or. /*lTpCom .or.*/ lRecCom .or. /*lRecebe .or.*/ lEmba .or. lValCom)
        EEC->(DBSKIP())
        Loop
     ENDIF
     
     lZero := .f.
     If !EasyGParam("MV_AVG0086",,.F.)  //LBL - 07/06/2013
        nValFOB := (EEC->EEC_TOTPED+EEC->EEC_DESCON)-(EEC->EEC_FRPREV+EEC->EEC_FRPCOM+EEC->EEC_SEGPRE+EEC->EEC_DESPIN+AvGetCpo("EEC->EEC_DESP1")+AvGetCpo("EEC->EEC_DESP2"))
     Else
        nValFOB := EEC->EEC_TOTPED - (EEC->EEC_FRPREV+EEC->EEC_FRPCOM+EEC->EEC_SEGPRE+EEC->EEC_DESPIN+AvGetCpo("EEC->EEC_DESP1")+AvGetCpo("EEC->EEC_DESP2"))
     EndIf        
     cPreemb := EEC->EEC_PREEMB  // GFP - 23/10/2014
     // nRecno := EEB->(Recno()) // RMD - 02/12/14 - Retirado
     nAgentes := 0  // GFP - 24/10/2014
     //EEB->(DBSEEK(XFILIAL("EEB")+EEC->EEC_PREEMB))  // GFP - 24/10/2014
     EEB->(DBSEEK(XFILIAL("EEB")+EEC->EEC_PREEMB+OC_EM))  //RMD - 02/12/14 - Considerar a chave correta (com o campo da fase) 
     //Do While EEB->(!Eof()) .AND. EEB->EEB_FILIAL == xFilial("EEB") .AND. EEB->EEB_PEDIDO == cPreemb .And. EEB->EEB_OCORRE == OC_EM  // GFP - 23/10/2014
     Do While EEB->(!Eof()) .AND. EEB->EEB_FILIAL == xFilial("EEB") .AND. EEB->EEB_PEDIDO == cPreemb .And. EEB->EEB_OCORRE == OC_EM 
	    If Left(EEB->EEB_TIPOAG, 1) == CD_AGC //RMD - 02/12/14 - Considerar a chave correta (com o campo da fase e tipo do agente)
           nAgentes++
           nLastAgente := EEB->(Recno())//RMD - 18/12/14 - Guarda o �ltimo agente v�lido
		EndIf
        EEB->(DbSkip())
     EndDo
     
     EEB->(DBSEEK(XFILIAL("EEB")+EEC->EEC_PREEMB+OC_EM))
     Do While EEB->(!Eof()) .AND. EEB->EEB_FILIAL == xFilial("EEB") .AND. EEB->EEB_PEDIDO == cPreemb .And. EEB->EEB_OCORRE == OC_EM 
        //EEB->(DbGoTo(nRecno)) RMD - 02/12/14 - Retirado pois sen�o o tratamento n�o ir� carregar o agente
        If nAgentes == 1  // GFP - 23/10/2014
           //EEB->(DbGoTo(nLastAgente)) //RMD - 02/12/14 - Para carregar o agente correto
           nPerCom := If(EEC->EEC_TIPCVL=="1",EEC->EEC_VALCOM, (EEB->(EEB_TOTCOM/EEB_FOBAGE)*100) )//EEB->EEB_VALCOM
        Else
           //nPerCom := if(EEC->EEC_TIPCVL=="1",EEC->EEC_VALCOM,(EEC->EEC_VALCOM/nValFOB)*100)
           nPerCom := if(EEC->EEC_TIPCVL=="1",EEC->EEC_VALCOM,(EEC->EEC_VALCOM/nValFOB)*100)
           //nPerCom := If(EEC->EEC_TIPCVL=="1",EEC->EEC_VALCOM,(EEB->(EEB_TOTCOM/EEB_FOBAGE)*100) ) //EEB->EEB_VALCOM
        EndIf
        //nValCom := if(EEC->EEC_TIPCVL=="1",(EEC->EEC_VALCOM*nValFOB)/100,EEC->EEC_VALCOM)
        
        //EEB->(DbGoTo(nRecno))
        //** PLB 01/06/07 - Tratamento para exibi��o de Comiss�es Liquidadas
        nTotCom := if(EEC->EEC_TIPCVL=="1", (EEC->EEC_VALCOM*nValFOB)/100, EEC->EEC_VALCOM)
        nValLiq := 0
        
        EEQ->( DBSeek(cFilEEQ+EEC->EEC_PREEMB) )
        Do While EEQ->( !EoF()  .And.  cFilEEQ+EEC->EEC_PREEMB == EEQ_FILIAL+EEQ_PREEMB )
           If EEQ->EEQ_EVENT $ (EV_COM_AR + "___" + EV_COM_CG + "___" + EV_COM_DF)
              If !Empty(EEQ->EEQ_PGT)
                 nValLiq += EEQ->EEQ_VL
              EndIf
           EndIf
           EEQ->( DBSkip() )
        EndDo

        nValCom := nTotCom - nValLiq
        //**
        //TRP-25/06/07 - Exibi��o apenas das comiss�es pendentes
        If nValCom > 0
           //MFR 13/01/2022 OSSME-6476
           //IF Alltrim(EEB->EEB_NOME) == Alltrim(cAgeCom) //LRS - 27/11/2015
           If (If (Empty(cRepres), .T., Alltrim(EEB->EEB_CODAGE) == Alltrim(cRepres) ) .And. If( Left(cTpCom,1)=="0" ,.T., Left(cTpCom,1) == EEB->EEB_TIPCOM) )
	           DET->(DBAPPEND())
	           DET->SEQREL := cSeqRel 
	           DET->DTEMBA := dtoc(EEC->EEC_DTEMBA)
	           nDIASCP     := POSICIONE("SY6",1,XFILIAL("SY6")+EEC->EEC_CONDPA,"Y6_DIAS_PA")
	           DET->DTVENC := DTOC(EEC->EEC_DTEMBA + nDIASCP)
	           DET->AGECOM := IF (nAgentes == 1, cAgeCom, EEB->EEB_NOME)
	           DET->IMPORT := Posicione("SA1",1,XFILIAL("SA1")+EEC->EEC_IMPORT,"A1_NREDUZ")
	           DET->PREEMB := EEC->EEC_PREEMB
	           DET->CONDPA := MSMM(Posicione("SY6",1,xFILIAL("SY6")+EEC->EEC_CONDPA,"Y6_DESC_P"),AVSX3("Y6_VM_DESP",3))
	           DET->VALFOB := IF (nAgentes == 1, nValFOB, EEB->EEB_FOBAGE)
	           
	           //**Faz o rateio do valor da comissao do agente com o valor da comissao que ja foi abatido o valor se tiver parcela de cambio liquidado para comissao.
	           DET->VALCOM := IF (nAgentes == 1, Round(nValCom, 3), Round(((EEB->EEB_TOTCOM/nTotCom)*nValCom),3) )
	           DET->PERCOM := IF (nAgentes == 1, Round(nPerCom, 2), Round(((DET->VALCOM/EEB->EEB_FOBAGE)*100),3) )
	           
	           //** PLB 01/06/07
	           DET->TOTCOM := IF (nAgentes == 1, Round(nTotCom, 3), Round(EEB->EEB_TOTCOM, 3) )
	           DET->VALLIQ := Round(nValLiq, 3)
	
	           DET->NRINVO := EEC->EEC_NRINVO
	           DET->TPCOM  := IF(!EMPTY(EEC->EEC_TIPCOM),aTPCOMB[VAL(EEC->EEC_TIPCOM)],"")
	           DET->CODIMP := EEC->EEC_IMPORT
	           DET->CODAGE := EEB->EEB_CODAGE
	           DET->(MSUNLOCK())
           EndIF
        Endif
        EEB->(DbSkip())
     Enddo
     EEC->(DBSKIP())
   Enddo   
  
   IF ( lZero )
     MSGINFO(STR0010, STR0011) //"N�o existe comiss�o para o intervalo escolhido"###"Aviso"
     lRet := .f.
   ELSE
      //JVR - 04/12/09 - Relat�rio Personalizavel
      If lRelPersonal
         oReport := ReportDef()
      EndIf
   ENDIF
     
End Sequence


//retorna a situacao anterior ao processamento
RestOrd(aOrd)

IF ( lRet )
   //JVR - 01/12/09 - Relat�rio Personalizavel
   If lRelPersonal
      oReport:PrintDialog()
      CrwCloseFile(aRetCrw,.T.)
   Else
      lRetC := CrwPreview(aRetCrw,cArqRpt,cTitRpt,cSeqRel)
   EndIf
ELSE
   // Fecha e apaga os arquivos temporarios
   CrwCloseFile(aRetCrw,.T.)
ENDIF


Return .f.
         
//----------------------------------------------------------------------
Static Function TelaGets

   Local lRet  := .f.

   Local oDlg

   Local nOpc := 0
   Local bOk  := {|| nOpc:=1, oDlg:End() }
   Local bCancel := {|| oDlg:End() }
   
   Begin Sequence
      
      DEFINE MSDIALOG oDlg TITLE cTitRpt FROM 9,0 TO 30,50 OF oMainWnd
   
      @ 35,05 SAY STR0012 PIXEL //"Data Inicial"
      @ 35,45 MSGET dDtIni SIZE 40,8 PIXEL
      
      @ 48,05 SAY STR0013 PIXEL //"Data Final"
      @ 48,45 MSGET dDtFim SIZE 40,8 Valid fConfData(dDtFim, dDtIni) PIXEL
      
      @ 61,05 SAY STR0014 PIXEL //"Representante"
      @ 61,45 MSGET cRepres SIZE 20,8 PICT AVSX3("Y5_COD",6) valid (Empty(cRepres).or.ExistCpo("SY5")) F3 "SY5" PIXEL
   
      @ 74,05 SAY STR0015 PIXEL //"Exportador"
      @ 74,45 MSGET cExport SIZE 40,8 PICT AVSX3("A2_COD",6) valid (Empty(cExport) .or.ExistCpo("SA2") ) F3 "SA2" PIXEL 

      @ 87,05 SAY STR0019 PIXEL //"Loja Exportador"
      @ 87,45 MSGET cExpLj  SIZE 40,8 PICT AVSX3("A2_COD",6) valid ( (Empty(cExport) .AND. Empty(cExpLj)) .or. TemReg("EXP") ) PIXEL 

      
      @ 100,05 SAY STR0016 PIXEL //"Fabricante"
      @ 100,45 MSGET cFabric SIZE 40,8 PICT AVSX3("A2_COD",6) valid (Empty(cFabric) .or.ExistCpo("SA2") ) F3 "SA2" PIXEL 

      @ 113,05 SAY STR0020 PIXEL //"Loja Fabricante"
      @ 113,45 MSGET cFabLj SIZE 40,8 PICT AVSX3("A2_COD",6) valid ( (Empty(cFabric) .AND. Empty(cFabLj) )  .or.TemReg("FAB") )  PIXEL 

   
      @ 126,05 SAY STR0017 PIXEL //"Tipo Comiss�o"
      TComboBox():New(126,45,bSETGET(cTpCom),aTpCom,80,5,oDlg,,,,,,.T.)
        
      ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,bOk,bCancel) CENTERED

      IF nOpc == 1
         lret := .t.
      ENDIF
      
   End Sequence

   Return lRet
   
   

/*
Funcao      : fConfData
Parametros  : Data Final, Data Inicial
Retorno     : 
Objetivos   : 
Autor       : Cristiane C. Figueiredo
Data/Hora   : 28/08/2000 11:00       
Revisao     :
Obs.        :
*/
Static Function fConfData(dFim,dIni)

Local lRet  := .f.

Begin Sequence
      
      if !empty(dFim) .and. dFim < dIni
         MsgInfo(STR0018,STR0011) //"Data Final n�o pode ser menor que Data Inicial"###"Aviso"
      Else
         lRet := .t.
      Endif   

End Sequence
      
Return lRet

/*
Funcao      : ReportDef
Parametros  : 
Retorno     : 
Objetivos   : Relat�rio Personalizavel TReport
Autor       : Jean Victor Rocha
Data/Hora   : 11/12/2009
Revisao     :
Obs.        :
*/
*-------------------------*
Static Function ReportDef()
*-------------------------*                                                                

//Variaveis
Local cDescr := cTitulo := cTitRpt

//Alias que podem ser utilizadas para adicionar campos personalizados no relat�rio
aTabelas := {"DET", "EEC", "EEQ"}

//Array com o titulo e com a chave das ordens disponiveis para escolha do usu�rio
aOrdem   := {} 
//
//Par�metros:            Relat�rio , Titulo  ,  Pergunte , C�digo de Bloco do Bot�o OK da tela de impress�o , Descri��o
oReport := TReport():New("EECPRL07", cTitulo ,""         , {|oReport| ReportPrint(oReport)}                 , cDescr    )

//Inicia o relat�rio como paisagem.
oReport:oPage:lLandScape := .T.
oReport:oPage:lPortRait := .F.
  
//Define os objetos com as se��es do relat�rio
oSecao1 := TRSection():New(oReport,"Se��o 1",{"CAB"},{})
oSecao2 := TRSection():New(oReport,"Se��o 2",aTabelas,aOrdem)

//Defini��o das colunas de impress�o da se��o 1
TRCell():New(oSecao1,"PERIODO" , "CAB", "Periodo"                 ,            ,     ,           ,       )
TRCell():New(oSecao1,"EXPORT"  , "CAB", "Exportador"              ,            ,     ,           ,       )
TRCell():New(oSecao1,"FABRIC"  , "CAB", "Fabricante"              ,            ,     ,           ,       )

//Defini��o das colunas de impress�o da se��o 2
//           objeto ,cName       ,cAlias,cTitle             ,cPicture             ,nSize,lPixel     ,bBlock ,cAlign ,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold
TRCell():New(oSecao2,"AGECOM"   , "DET", "Agente"           ,                     , 015 ,           ,       ,"LEFT" ,          ,            ,          ,         , .T.     ,        ,        ,     )
TRCell():New(oSecao2,"IMPORT"   , "DET", "Importador"       ,                     ,     ,           ,       ,"LEFT" ,          ,            ,          ,         , .T.     ,        ,        ,     )
TRCell():New(oSecao2,"PREEMB"   , "DET", "Embarque"         ,                     ,     ,           ,       ,"LEFT" ,          ,            ,          ,         , .T.     ,        ,        ,     )
TRCell():New(oSecao2,"DTEMBA"   , "DET", "Dt.Embarque"      ,                     ,     ,           ,       ,"LEFT" ,          ,            ,          ,         , .T.     ,        ,        ,     )
TRCell():New(oSecao2,"DTVENC"   , "DET", "Dt.Vencimento"    ,                     ,     ,           ,       ,"LEFT" ,          ,            ,          ,         , .T.     ,        ,        ,     )
TRCell():New(oSecao2,"CONDPA"   , "DET", "Cond.Pagamento"   ,                     ,     ,           ,       ,"LEFT" ,          ,            ,          ,         , .T.     ,        ,        ,     )
TRCell():New(oSecao2,"VALFOB"   , "DET", "Valor FOB"        ,"@E 9,999,999,999.99", 014 ,           ,       ,"RIGHT",          ,"RIGHT"     ,          ,         , .T.     ,        ,        ,     )
TRCell():New(oSecao2,"PERCOM"   , "DET", "% Comiss�o"       ,"@E 999,999,999.9999", 010 ,           ,       ,"RIGHT",          ,"RIGHT"     ,          ,         , .T.     ,        ,        ,     )
TRCell():New(oSecao2,"VALCOM"   , "DET", "Tot. Comiss�o"    ,"@E 9,999,999,999.99", 014 ,           ,       ,"RIGHT",          ,"RIGHT"     ,          ,         , .T.     ,        ,        ,     )
TRCell():New(oSecao2,"NRINVO"   , "DET", "Nro. Fatura"      ,                     ,     ,           ,       ,"LEFT" ,          ,            ,          ,         , .T.     ,        ,        ,     )
TRCell():New(oSecao2,"TPCOM"    , "DET", "Tp. Comiss�o"     ,                     ,     ,           ,       ,"LEFT" ,          ,            ,          ,         , .T.     ,        ,        ,     )

//Quebra de acordo com a Ordem selecionada
oBreak1 := TRBreak():New(oSecao2,{|| DET->AGECOM },,.F.)  
oBreak1:bOnBreak:={||oReport:SkipLine(1),oReport:PrintText("Total por Agente: ",,)}
oBreak:= TRBreak():New(oSecao2,{|| DET->IMPORT },,.F.)                       
oBreak:bOnBreak:={||oReport:SkipLine(1),oReport:PrintText("Total por Importador: ",,)}

oTotal:=TRFunction():New(oSecao2:Cell("VALFOB"),NIL,"SUM",oBreak, , ,{|| DET->VALFOB },.F.,.F.) 
oTotal:=TRFunction():New(oSecao2:Cell("VALCOM"),NIL,"SUM",oBreak, , ,{|| DET->VALCOM },.F.,.F.) 
oTotal1:=TRFunction():New(oSecao2:Cell("VALFOB"),NIL,"SUM",oBreak1, , ,{|| DET->VALFOB },.F.,.T.) 
oTotal1:=TRFunction():New(oSecao2:Cell("VALCOM"),NIL,"SUM",oBreak1, , ,{|| DET->VALCOM },.F.,.T.) 
oSecao2:SetTotalText("")

oReport:bOnPageBreak :={||oReport:Section("Se��o 1"):PrintLine()} 
oSecao1:SkipLine(2)

Return oReport


*----------------------------------*
Static Function ReportPrint(oReport)
*----------------------------------*

//Faz o posicionamento de outros alias para utiliza��o pelo usu�rio na adi��o de novas colunas.
TRPosition():New(oReport:Section("Se��o 2"),"EEC", 1,{|| xFilial("EEC") + DET->PREEMB  })
TRPosition():New(oReport:Section("Se��o 2"),"EEQ", 1,{|| xFilial("EEQ") + EEC->EEC_PREEMB   })
 
//Inicio da impress�o da se��o 1.
oReport:Section("Se��o 1"):Init()

//Inicio da impress�o da se��o 2.
oReport:Section("Se��o 2"):Init()

oReport:SetMeter(DET->(EasyRecCount()))
DET->(dbGoTop())

FilePrint:=E_Create(,.F.)
IndRegua("DET",FilePrint+TEOrdBagExt(),"AGECOM+IMPORT")

//La�o principal
Do While DET->(!EoF()) .And. !oReport:Cancel()
   oReport:Section("Se��o 2"):PrintLine() //Impress�o da linha
   oReport:IncMeter()                     //Incrementa a barra de progresso
   DET->( dbSkip() )
EndDo

//Fim da impress�o da se��o 1
oReport:Section("Se��o 1"):Finish()
//Fim da impress�o da se��o 2
oReport:Section("Se��o 2"):Finish()                                

FERASE(FilePrint+TEOrdBagExt())

Return .T.

Static Function TemReg(cTab)
Local cExpFab := If(cTab==("EXP"),cExport,cFabric)
Local cLoja   := If(cTab==("EXP"),cExpLj,cFabLj)
Local cMsg    := If(cTab==("EXP"),"exportador","fabricante")
Local cCod := Posicione("SA2",1,xFilial("SA2") + cExpFab + cLoja,"A2_COD")
Local lRet := !Empty(cCod)
If empty(cCod)
   cMsg := Strtran(STR0021,"#####",cMsg)
   EasyHelp(cMsg,STR0011) //N�o encontrado o " + cMsg + " e loja com os valores selecionados
EndIf
return lRet


*------------------------------------------------------------------------------*
* FIM DO PROGRAMA EECPRL07.PRW                                                 *
*------------------------------------------------------------------------------*
