Include DEMOMACROS

/// As per the documentation on https://docs.intersystems.com/latest/csp/docbook/DocBook.UI.Page.cls?KEY=EREST_service, one
/// should not use EnsLib.REST.Service to create REST business services with IRIS Interoperability. We should use %CSP.REST instead.
/// So, this dispatcher class will serve as an example of how to create a rest service that is calling a business service while
/// a better way of doing it is not available.
Class IRISDemo.REST.Dispatcher Extends %CSP.REST
{

Parameter UseSession = 1;

Parameter CONVERTINPUTSTREAM = 1;

Parameter CHARSET = "utf-8";

Parameter HandleCorsRequest = 1;

XData UrlMap
{
<Routes>
    <Map Prefix="/transaction" Forward="BankingSrv.BS.Transaction.Service"/>
    <Map Prefix="/whitelist" Forward="WhiteList.BS.Service"/>
    <Route Url="/sns/:enable" Method="GET" Call="SNS"/>
  </Routes>
}

ClassMethod SNS(enable As %Boolean) As %Status
{
  set %response.ContentType="application/json"
  set json={}
  set json.items=[]
  for items = "AWS SNS Operation","Send Email" {
    do ##class(Ens.Director).EnableConfigItem(items,enable)
    set sc = ##class(Ens.Queue).AbortQueue(items)
    set item={}
    set item.name=(items)
    set item.active=(enable)
    set:sc item.queue="successfully aborted"
    set:'sc item.queue="error while aborting queue :"_($system.Status.GetErrorText(sc))
    do json.items.%Push(item)
  }
  if enable {
    set ^EmailRecipient("Guillaume") = "gjeunot@puydufou.com"
    set ^EmailRecipient("Laurent") = "laurent.viquesnel@intersystems.com"
    set ^SMSPhoneNumber("Guillaume") = "+33620370065"
    set ^SMSPhoneNumber("Laurent") = "+33778417983"
  } else {
    set ^EmailRecipient("Guillaume") = "sylvain.guilbaud@intersystems.com"
    set ^EmailRecipient("Laurent") = "sylvain.guilbaud@intersystems.com"
    set ^SMSPhoneNumber("Guillaume") = "+33623074641"
    set ^SMSPhoneNumber("Laurent") = "+33623074641"
  } 
  do json.%ToJSON()
  return $$$OK
}

}
