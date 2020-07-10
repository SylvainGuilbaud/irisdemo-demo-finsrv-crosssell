/// 
Class BankingSrv.BP.Transaction.CreditCardReward Extends Ens.BusinessProcessBPL
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='BankingSrv.BS.Transaction.NewTransactionReq' response='Ens.Response' height='2000' width='2000' >
<context>
<property name='TranCount' type='%Integer' initialexpression='0' instantiate='0' />
<property name='TranAmount' type='%Library.Double' initialexpression='0' instantiate='0' />
<property name='SendAward' type='%Boolean' initialexpression='0' instantiate='0' />
<property name='CCRewardReq' type='BankingSrv.Msg.RewardReq' instantiate='0' />
</context>
<sequence xend='200' yend='1200' >
<trace name='Started CC Reward BP' value='"Started CC Reward BP"' xpos='200' ypos='250' />
<call name='Get Tran History' target='Get Transaction History' async='0' xpos='200' ypos='350' >
<request type='BankingSrv.Msg.RewardReq' >
<assign property="callrequest.TransDateTime" value="request.TransDateTime" action="set" />
<assign property="callrequest.TransType" value="request.TransType" action="set" />
<assign property="callrequest.Amount" value="request.Amount" action="set" />
<assign property="callrequest.FromAccountNumber" value="request.FromAccountNumber" action="set" />
<assign property="callrequest.ToAccountNumber" value="request.ToAccountNumber" action="set" />
</request>
<response type='BankingSrv.Msg.RewardResp' >
<assign property="context.CCRewardReq.TransDateTime" value="callresponse.TransDateTime" action="set" />
<assign property="context.CCRewardReq.TransType" value="callresponse.TransType" action="set" />
<assign property="context.CCRewardReq.Amount" value="callresponse.Amount" action="set" />
<assign property="context.CCRewardReq.FromAccountNumber" value="callresponse.FromAccountNumber" action="set" />
<assign property="context.CCRewardReq.ToAccountNumber" value="callresponse.ToAccountNumber" action="set" />
<assign property="context.CCRewardReq.TransactionsLastPeriod" value="callresponse.TransactionsLastPeriod" action="set" />
<assign property="context.CCRewardReq.TransactionAmtLastPeriod" value="callresponse.TransactionAmtLastPeriod" action="set" />
</response>
</call>
<trace name='DEBUG - Step before Rule' value='"STEP BEFORE RULE"' xpos='200' ypos='450' />
<rule name='Reward Bus Rule' rule='BankingSrv.Rule.RewardRule'  resultLocation='context.SendAward' ruleContext='context' xpos='200' ypos='550' >
</rule>
<trace name='Step After Rule' value='"STEP AFTER RULE"' xpos='200' ypos='650' />
<if name='Send Reward' condition='context.SendAward' xpos='200' ypos='750' xend='200' yend='1100' >
<true>
<call name='Send Email' target='Send Email' async='1' xpos='335' ypos='900' >
<request type='BankingSrv.Msg.EmailRequest' >
<assign property="callrequest.Recipient" value="&quot;isc.peteoh@gmail.com&quot;" action="set" />
<assign property="callrequest.Subject" value="&quot;Demo Bank Reward Notification&quot;" action="set" />
<assign property="callrequest.EmailBody" value="&quot;Thank you for using our Credit Card facilities. As you have been a frequent user of the service we would like to extend our gratitude with this gift...&quot;" action="set" />
</request>
<response type='Ens.Response' />
</call>
<call name='Send SMS' target='AWS SNS Operation' async='1' xpos='335' ypos='1000' >
<request type='AWS.BO.SNS.SendSNSReq' >
<assign property="callrequest.PhoneNumber" value="$Get(^SMSPhoneNumber)" action="set" />
<assign property="callrequest.Message" value="&quot;You have been sent a reward&quot;" action="set" />
</request>
<response type='Ens.Response' />
</call>
</true>
</if>
</sequence>
</process>
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
