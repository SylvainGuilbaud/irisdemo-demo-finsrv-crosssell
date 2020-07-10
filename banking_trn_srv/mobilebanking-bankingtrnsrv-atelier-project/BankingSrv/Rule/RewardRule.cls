/// Determine if Customer should receive
Class BankingSrv.Rule.RewardRule Extends Ens.Rule.Definition
{

Parameter RuleAssistClass = "Ens.Rule.GeneralBusinessRuleAssist";

XData RuleDefinition [ XMLNamespace = "http://www.intersystems.com/rule" ]
{
<ruleDefinition alias="" context="BankingSrv.BP.Transaction.CreditCardReward.Context" production="">
<ruleSet name="Credit Card Usage Reward" effectiveBegin="" effectiveEnd="">
<rule name="" disabled="false">
<when condition="Request.TransType=&quot;PAYMENT&quot;">
<trace value="&quot;PAYMENT - OK&quot;"></trace>
</when>
<otherwise>
<trace value="&quot;Non-Payment Transaction - returning&quot;"></trace>
<return>0</return>
</otherwise>
</rule>
<rule name="Number of Transactions" disabled="false">
<when condition="CCRewardResp.TransactionsLastPeriod&gt;=150">
<trace value="&quot;Transactions Greater than 150&quot;"></trace>
</when>
<otherwise>
<trace value="&quot;Too Few Transactions&quot;"></trace>
<return>0</return>
</otherwise>
</rule>
<rule name="Amount of Transactions" disabled="false">
<when condition="CCRewardResp.TransactionAmtLastPeriod&gt;=5000">
<trace value="&quot;Transaction Amount Greater than Min&quot;"></trace>
</when>
<otherwise>
<trace value="&quot;Transaction Amount too small&quot;"></trace>
<return>0</return>
</otherwise>
</rule>
<trace value="&quot;All passed - so give reward&quot;"></trace>
<return>1</return>
</ruleSet>
<ruleSet name="Covid Rewards" effectiveBegin="2020-03-01" effectiveEnd="2020-07-31">
<rule name="" disabled="false">
<when condition="CCRewardReq.TransType=&quot;PAYMENT&quot;">
<trace value="&quot;PAYMENT - OK&quot;"></trace>
</when>
<otherwise>
<trace value="&quot;Non-Payment Transaction - returning&quot;"></trace>
<return>0</return>
</otherwise>
</rule>
<rule name="Number of Transactions" disabled="false">
<when condition="CCRewardReq.TransactionsLastPeriod&gt;=120">
<trace value="&quot;Transactions Greater than 120&quot;"></trace>
</when>
<otherwise>
<trace value="&quot;Too Few Transactions&quot;"></trace>
<return>0</return>
</otherwise>
</rule>
<rule name="Amount of Transactions" disabled="false">
<when condition="CCRewardReq.TransactionAmtLastPeriod&gt;=3500">
<trace value="&quot;Transaction Amount Greater than Min&quot;"></trace>
</when>
<otherwise>
<trace value="&quot;Transaction Amount too small&quot;"></trace>
<return>0</return>
</otherwise>
</rule>
<trace value="&quot;All passed - so give reward&quot;"></trace>
<return>1</return>
</ruleSet>
</ruleDefinition>
}

}
