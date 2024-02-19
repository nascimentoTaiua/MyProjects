#INCLUDE 'PROTHEUS.CH'
#INCLUDE "FWMVCDEF.CH"

/*/
 * {Protheus.doc} G818EMAIL()
 * Configura E-mail DACTE
 * type    Function
 * author  Eduardo Ferreira
 * since   04/12/2019
 * version 12.25
 * param   lRet
 * return  Não há
/*/
User Function G818EMAIL()
Local aParam := PARAMIXB 
Local aEmail := {}    
Local cTitu  := 'DACTE - Encomendas'
Local cHtml  := ''

cHtml += '<!doctype html>'
cHtml += '<html lang="BR">'
cHtml += '<body>'
cHtml += "<strong>"

If aParam[3] == '0'
    cHtml += aParam[1]
    cHtml += "<br>"
Else 
    cHtml += aParam[2] 
    cHtml += "<br>"
EndIf

cHtml += "<p>"  
cHtml += 'Segue em anexo a DACTE referente a encomenda: ' + aParam[7] 
cHtml += "</p>"
cHtml += "<p>" 
cHtml += aParam[6] 
cHtml += "</p>"
cHtml += "</strong>"  
cHtml += "<br>"
cHtml += "<em>" 
cHtml += "<p>" 
cHtml += 'Este e-mail foi enviado de um endereço de notificação, que não esta habilitado a receber mensagens. Por Favor, não responda esta mensagem.' 
cHtml += "</p>"
cHtml += "</em>" 
cHtml += '</body>'
cHtml += '</html>'

aAdd(aEmail, {cTitu, cHtml}) 

Return aEmail

