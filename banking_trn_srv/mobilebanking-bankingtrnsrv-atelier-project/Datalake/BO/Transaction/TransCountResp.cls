Class Datalake.BO.Transaction.TransCountResp Extends Ens.Response [ Language = objectscript ]
{
Property FromAccountNumber As %String;

Property TranCount As %Integer;
Storage Default
{
<Data name="TransCountRespDefaultData">
<Subscript>"TransCountResp"</Subscript>
<Value name="1">
<Value>FromAccountNumber</Value>
</Value>
<Value name="2">
<Value>TranCount</Value>
</Value>
</Data>
<DefaultData>TransCountRespDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}