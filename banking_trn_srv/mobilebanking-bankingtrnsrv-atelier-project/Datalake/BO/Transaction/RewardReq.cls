Class Datalake.BO.Transaction.RewardReq Extends Ens.Request [ Language = objectscript ]
{

/// Customer/Merchant who started the transaction
Property FromAccountNumber As %String;

Storage Default
{
<Data name="RewardReqDefaultData">
<Subscript>"RewardReq"</Subscript>
<Value name="1">
<Value>FromAccountNumber</Value>
</Value>
</Data>
<DefaultData>RewardReqDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}