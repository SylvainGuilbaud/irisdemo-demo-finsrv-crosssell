Class Datalake.BO.Transaction.RewardResp Extends Ens.Response [ Language = objectscript ]
{
Property TransactionsLastPeriod As %Integer;

Property TransactionAmtLastPeriod As %Library.Double;
Storage Default
{
<Data name="RewardRespDefaultData">
<Subscript>"RewardResp"</Subscript>
<Value name="1">
<Value>TransactionsLastPeriod</Value>
</Value>
<Value name="2">
<Value>TransactionAmtLastPeriod</Value>
</Value>
</Data>
<DefaultData>RewardRespDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}