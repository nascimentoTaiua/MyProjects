/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTATIP56  ºAutor  ³Vicente Lacerenza   º Data ³  17/12/2003 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de Entrada para Tratar o Reg. 56 do Sintegra          º±±
±±º          ³Convenio ICMS 142/02 							              º±±
±±º          ³                                                            º±±
±±º          ³ P.ENTRADA NF.SAIDA  - SD2 ==> MTA56S ()                    º±±
±±º          ³ P.ENTRADA NF.ENTRADA- SD1 ==> MTA56E ()                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºNota 1    ³ Criado conf. BOPS NR. 68710 DE 12/12/2003                  º±±
±±ºNota 2    ³ Somente deve tratar Motocicletas ou Microtratores  -       º±±
±±º          ³ Operacoes com Veiculos Automotores Novos                   º±±
±±º          ³ SB1->B1_TPMOTO $ "M/T" ou B1_GRUPO $ "MOTO/TRAT"           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºEspecifico³ J.TOLEDO DA AMAZONIA-IND. E COMERCIO DE VEICS. LTDA.       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

OBSERVACOES -----------------------------------------------------------------
1º) Se ambiente TOP, para SD2 ou SD1 utilizar como alias (PARAMIXB[1])

2º) Tipos de Operacoes, campo 10 do layout:
1 = Venda para concessionaria
2 = Faturamento direto (NAO HAVERA CNF. MARIA DO CARMO-FISCAL)
3 = Venda Direta (clientes)

3º) DETALHES DOS CAMPOS DO LAYOUT, CNF. ENTENDIMENTO COM A USUARIA MARIA DO
CARMO - DEPTO. FISCAL EM 17.12.2003

4º) Conforme DoCarmo, primeiro sera usado para filial Jundiai, depois sera analisado
para demais empresas e filiais.
ciente, Felipe
por Vicente 19.12.2003

5*) Novas adaptacoes no ponto efetuadas pelo Analista Gustavo Rueda (desenvolvimento siga)
em 12.02.2004. foi tambem adaptado o sintegra.ini

6*) VALIDADO PELA USUARIA MARIA DO CARMO EM 12/02/2004 - 12:00HS CNF. E-MAIL 
RECEBIDO NESTA DATA.
*/


//-----------------------------------------------------------------------
//====>> PONTO DE ENTRADA PARA TRATAR AS NOTAS FISCAIS DE SAIDA!!!
//-----------------------------------------------------------------------
User Function MTA56S ()
Local	aGetArea	:=	GetArea ()
Local	aGetAreaB1	:=	SB1->(GetArea ())
Local _cCodPro := (PARAMIXB[1])->D2_COD
Local _cCodCLI := (PARAMIXB[1])->D2_CLIENTE
Local _cTipOper:= 1
Local _cTpMoto := Posicione("SB1",1,xFilial()+(PARAMIXB[1])->D2_COD,"B1_TPMOTO")

IF !(PARAMIXB[2] $ "991/992/993/997/999")
	
	If SM0->M0_CODIGO == '01' .AND. SM0->M0_CODFIL == '02'
		If !SF2->F2_TIPO $ "B/D"			
			If Alltrim(_cTpMoto) $ "M/T"
				If Substr(_cCodCLI,1,1) == "0"
					_cTipOper := 1
				ElseIf Substr(_cCodCLI,1,1) == "1"
					_cTipOper := 3
				Endif
				
				_nCNPJ := VAL(A940CNPJ(SA1->A1_CGC,SA1->A1_TIPO))
				
				DbSelectARea ("R56")
				Reclock ("R56", .T.)
				
				A56_CNPJ	:= A940CNPJ(SA1->A1_CGC,SA1->A1_TIPO)
				A56_MODELO	:= Val (aModNot(SF2->F2_ESPECIE))
				A56_SERIE	:= SF2->F2_SERIE
				A56_NUMERO	:= StrZero(Val(SF2->F2_DOC),6)
				A56_CFOP	:= (PARAMIXB[1])->D2_CF
				A56_CST		:= Val ((PARAMIXB[1])->D2_CLASFIS)
				A56_NRIT	:= Val(PARAMIXB[2])
				A56_PROD	:= AFISFILL ((PARAMIXB[1])->D2_COD, 14)
				A56_OPER	:= _cTipOper
				A56_CNPJC	:= 00000000000000 //IIF(_cTipOper==1,_nCNPJ,00000000000000)
				A56_ALQIPI	:= Val( Transform(Posicione("SB1",1,xFilial()+(PARAMIXB[1])->D2_COD,"B1_IPI"),"@E 99,99"))
				A56_CHASSI	:= Substr(Posicione("SB1",1,xFilial()+(PARAMIXB[1])->D2_COD,"B1_CHASSI"),1,17)
				A56_SDOC	:= SerieNfId("SF2",2,"F2_SERIE")
				MsUnlock ()
			Endif
		Endif
	Endif
ENDIF

RestArea (aGetAreaB1)
RestArea (aGetArea)

Return .T.


//------------------------------------------------------------------------
//====>> PONTO DE ENTRADA PARA TRATAR AS NOTAS FISCAIS DE ENTRADA !!!
//------------------------------------------------------------------------
User Function MTA56E ()

Local	aGetArea	:=	GetArea ()

Local	aGetAreaB1	:=	SB1->(GetArea ())
Local _cCodPro := (PARAMIXB[1])->D1_COD
Local _cCodCLI := (PARAMIXB[1])->D1_FORNECE
Local _cTipOper:= 1
Local _cTpMoto := Posicione("SB1",1,xFilial()+(PARAMIXB[1])->D1_COD,"B1_TPMOTO")


IF !(PARAMIXB[2] $ "991/992/993/997/999")
	If SM0->M0_CODIGO == '01' .AND. SM0->M0_CODFIL == '02'		
		IF SF1->F1_TIPO $ "/D"
			If Alltrim(_cTpMoto) $ "M/T"
				If Substr(_cCodCLI,1,1) == "0"
					_cTipOper := 1
				ElseIf Substr(_cCodCLI,1,1) == "1"
					_cTipOper := 3
				Endif

				_nCNPJ := vAL (A940CNPJ(SA1->A1_CGC,SA1->A1_TIPO))
				
				DbSelectARea ("R56")
				Reclock ("R56", .T.)
				
				A56_CNPJ	:= A940CNPJ(SA1->A1_CGC,SA1->A1_TIPO)
				A56_MODELO	:= Val (aModNot(SF1->F1_ESPECIE))
				A56_SERIE	:= SF1->F1_SERIE
				A56_NUMERO	:= SF1->F1_DOC
				A56_CFOP	:= (PARAMIXB[1])->D1_CF
				A56_CST		:= Val ((PARAMIXB[1])->D1_CLASFIS)
				A56_NRIT	:= Val (PARAMIXB[2])
				A56_PROD	:= AFISFILL ((PARAMIXB[1])->D1_COD, 14)
				A56_OPER	:= _cTipOper
				A56_CNPJC	:= 00000000000000 //IIF(_cTipOper==1,_nCNPJ,00000000000000)
				A56_ALQIPI	:= Val( Transform(Posicione("SB1",1,xFilial()+(PARAMIXB[1])->D1_COD,"B1_IPI"),"@E 99,99"))
				A56_CHASSI	:= Substr(Posicione("SB1",1,xFilial()+(PARAMIXB[1])->D1_COD,"B1_CHASSI"),1,17)
				A56_SDOC	:= SerieNfId("SF1",2,"F1_SERIE")
				MsUnlock ()
				
			Endif
		Endif
	Endif
ENDIF

RestArea (aGetAreaB1)

RestArea (aGetArea)

Return .T.
