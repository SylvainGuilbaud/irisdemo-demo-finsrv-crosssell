Class BankingSrv.BO.Email.EmailRequest Extends Ens.Request [ Language = objectscript ]
{
Property Recipient As %String;

Property Subject As %String;

Property EmailBody As %String(MAXLEN = 1024);

Property HoldMsg As %String;

Property Source As %String;
Storage Default
{
<Data name="EmailRequestDefaultData">
<Subscript>"EmailRequest"</Subscript>
<Value name="1">
<Value>Recipient</Value>
</Value>
<Value name="2">
<Value>Subject</Value>
</Value>
<Value name="3">
<Value>EmailBody</Value>
</Value>
<Value name="4">
<Value>HoldMsg</Value>
</Value>
<Value name="5">
<Value>Source</Value>
</Value>
</Data>
<DefaultData>EmailRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}