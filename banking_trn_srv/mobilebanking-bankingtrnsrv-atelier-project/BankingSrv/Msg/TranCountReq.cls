Class BankingSrv.Msg.TranCountReq Extends Ens.Request [ Language = objectscript ]
{

Property FromAccountNumber As %String;

Property TranCount As %Integer;

Storage Default
{
<Data name="TranCountReqDefaultData">
<Subscript>"TranCountReq"</Subscript>
<Value name="1">
<Value>FromAccountNumber</Value>
</Value>
<Value name="2">
<Value>TranCount</Value>
</Value>
</Data>
<DefaultData>TranCountReqDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
