Class Datalake.BO.Transaction.TransCountReq Extends Ens.Request [ Language = objectscript ]
{
Property FromAccountNumber As %String;

Property TranCount As %Integer;


Storage Default
{
<Data name="TransCountReqDefaultData">
<Subscript>"TransCountReq"</Subscript>
<Value name="1">
<Value>FromAccountNumber</Value>
</Value>
<Value name="2">
<Value>TranCount</Value>
</Value>
</Data>
<DefaultData>TransCountReqDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}