Class BankingSrv.Msg.RewardReq Extends Ens.Request [ Language = objectscript ]
{

Property TransDateTime As %TimeStamp;

/// CASH_IN is the process of increasing the balance of account by paying in cash to a merchant.
/// CASH_OUT is the opposite process of CASH-IN, it means to withdraw cash from a merchant which decreases the balance of the account.
/// DEBIT is similar process than CASH-OUT and involves sending the money from the mobile money service to a bank account.
/// PAYMENT is the process of paying for goods or services to merchants which decreases the balance of the account and increases the balance of the receiver.
/// TRANSFER is the process of sending money to another user of the service through the mobile money platform.
Property TransType As %Library.String(VALUELIST = ",CASH_IN,CASH_OUT,DEBIT,PAYMENT,TRANSFER");

Property Amount As %Library.Double(MINVAL = 1);

/// Customer/Merchant who started the transaction
Property FromAccountNumber As %String;

/// customer who is the recipient of the transaction
Property ToAccountNumber As %String;

Property TransactionsLastPeriod As %Integer;

Property TransactionAmtLastPeriod As %Library.Double;

Storage Default
{
<Data name="RewardReqDefaultData">
<Subscript>"RewardReq"</Subscript>
<Value name="1">
<Value>TransDateTime</Value>
</Value>
<Value name="2">
<Value>TransType</Value>
</Value>
<Value name="3">
<Value>Amount</Value>
</Value>
<Value name="4">
<Value>FromAccountNumber</Value>
</Value>
<Value name="5">
<Value>ToAccountNumber</Value>
</Value>
<Value name="6">
<Value>TransactionsLastPeriod</Value>
</Value>
<Value name="7">
<Value>TransactionAmtLastPeriod</Value>
</Value>
</Data>
<DefaultData>RewardReqDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
