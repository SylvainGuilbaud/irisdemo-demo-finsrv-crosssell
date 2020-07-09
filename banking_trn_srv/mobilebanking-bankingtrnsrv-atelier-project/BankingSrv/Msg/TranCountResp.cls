Class BankingSrv.Msg.TranCountResp Extends Ens.Response [ Language = objectscript ]
{

Property FromAccountNumber As %String;

Property TranCount As %Integer;

Storage Default
{
<Data name="TranCountRespDefaultData">
<Subscript>"TranCountResp"</Subscript>
<Value name="1">
<Value>FromAccountNumber</Value>
</Value>
<Value name="2">
<Value>TranCount</Value>
</Value>
</Data>
<DefaultData>TranCountRespDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
