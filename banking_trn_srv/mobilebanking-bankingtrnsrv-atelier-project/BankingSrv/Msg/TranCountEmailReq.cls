Class BankingSrv.Msg.TranCountEmailReq Extends Ens.Request [ Language = objectscript ]
{

Property TranCount As %Integer;

Property Recipient As %String;

Property Subject As %String;

Property EmailBody As %String(MAXLEN = 1024);

Storage Default
{
<Data name="TranCountEmailReqDefaultData">
<Subscript>"TranCountEmailReq"</Subscript>
<Value name="1">
<Value>TranCount</Value>
</Value>
<Value name="2">
<Value>Recipient</Value>
</Value>
<Value name="3">
<Value>Subject</Value>
</Value>
<Value name="4">
<Value>EmailBody</Value>
</Value>
</Data>
<DefaultData>TranCountEmailReqDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
