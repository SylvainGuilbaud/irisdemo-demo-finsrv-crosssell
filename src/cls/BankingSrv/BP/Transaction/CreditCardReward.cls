/// 
Class BankingSrv.BP.Transaction.CreditCardReward Extends Ens.BusinessProcessBPL
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='BankingSrv.BS.Transaction.NewTransactionReq' response='Ens.Response' height='2000' width='2000' >
<context>
<property name='TranCount' type='%Integer' initialexpression='0' instantiate='0' />
<property name='TranAmount' type='%Library.Double' initialexpression='0' instantiate='0' />
<property name='SendAward' type='%Boolean' initialexpression='0' instantiate='0' />
<property name='CCRewardResp' type='Datalake.BO.Transaction.RewardResp' instantiate='0' />
<property name='Request' type='BankingSrv.BS.Transaction.NewTransactionReq' instantiate='0' />
</context>
<sequence xend='200' yend='1550' >
<assign name="Add Request to Context" property="context.Request" value="request" action="set" xpos='200' ypos='250' />
<trace name='Started CC Reward BP' value='"Started CC Reward BP"' xpos='200' ypos='350' />
<call name='Get Tran History' target='Get Transaction History' async='0' xpos='200' ypos='450' >
<request type='Datalake.BO.Transaction.RewardReq' >
<assign property="callrequest.FromAccountNumber" value="request.FromAccountNumber" action="set" />
</request>
<response type='Datalake.BO.Transaction.RewardResp' >
<assign property="context.CCRewardResp" value="callresponse" action="set" />
</response>
</call>
<trace name='DEBUG - Step before Rule' value='"STEP BEFORE RULE"' xpos='200' ypos='550' />
<rule name='Reward Bus Rule' rule='BankingSrv.Rule.RewardRule'  resultLocation='context.SendAward' ruleContext='context' xpos='200' ypos='650' >
</rule>
<trace name='Step After Rule' value='"STEP AFTER RULE"' xpos='200' ypos='750' />
<if name='Send Reward' condition='context.SendAward' xpos='200' ypos='850' xend='200' yend='1450' >
<true>
<flow xpos='335' ypos='1000' xend='335' yend='1350' >
<sequence >
<call name='Send Email' target='Send Email' async='1' xpos='875' ypos='1150' >
<request type='BankingSrv.BO.Email.EmailRequest' >
<assign property="callrequest.Recipient" value="$Get(^EmailRecipient)" action="set" />
<assign property="callrequest.Subject" value="&quot;Demo Bank Reward Notification&quot;" action="set" />
<assign property="callrequest.EmailBody" value="&quot;Thank you for using our Credit Card facilities. As you have been a frequent user of the service we would like to extend our gratitude with this gift...&quot;" action="set" />
</request>
</call>
<call name='Send SMS' target='AWS SNS Operation' async='1' xpos='875' ypos='1250' >
<request type='AWS.BO.SNS.SendSNSReq' >
<assign property="callrequest.PhoneNumber" value="$Get(^SMSPhoneNumber)" action="set" />
<assign property="callrequest.Message" value="&quot;En tant que bon client, vous avez obtenu un cadeau&quot;" action="set" />
</request>
</call>
</sequence>
<sequence >
<call name='Send Email' target='Send Email' async='1' xpos='335' ypos='1150' >
<request type='BankingSrv.BO.Email.EmailRequest' >
<assign property="callrequest.Recipient" value="$Get(^EmailRecipient(&quot;Guillaume&quot;))" action="set" />
<assign property="callrequest.Subject" value="&quot;Demo Bank Reward Notification&quot;" action="set" />
<assign property="callrequest.EmailBody" value="&quot;Thank you for using our Credit Card facilities. As you have been a frequent user of the service we would like to extend our gratitude with this gift...&quot;" action="set" />
</request>
</call>
<call name='Send SMS' target='AWS SNS Operation' async='1' xpos='335' ypos='1250' >
<request type='AWS.BO.SNS.SendSNSReq' >
<assign property="callrequest.PhoneNumber" value="$Get(^SMSPhoneNumber(&quot;Guillaume&quot;))" action="set" />
<assign property="callrequest.Message" value="&quot;En tant que bon client, vous avez obtenu un cadeau&quot;" action="set" />
</request>
</call>
</sequence>
<sequence >
<call name='Send Email' target='Send Email' async='1' xpos='605' ypos='1150' >
<request type='BankingSrv.BO.Email.EmailRequest' >
<assign property="callrequest.Recipient" value="$Get(^EmailRecipient(&quot;Laurent&quot;))" action="set" />
<assign property="callrequest.Subject" value="&quot;Demo Bank Reward Notification&quot;" action="set" />
<assign property="callrequest.EmailBody" value="&quot;Thank you for using our Credit Card facilities. As you have been a frequent user of the service we would like to extend our gratitude with this gift...&quot;" action="set" />
</request>
</call>
<call name='Send SMS' target='AWS SNS Operation' async='1' xpos='605' ypos='1250' >
<request type='AWS.BO.SNS.SendSNSReq' >
<assign property="callrequest.PhoneNumber" value="$Get(^SMSPhoneNumber(&quot;Laurent&quot;))" action="set" />
<assign property="callrequest.Message" value="&quot;En tant que bon client, vous avez obtenu un cadeau&quot;" action="set" />
</request>
</call>
</sequence>
</flow>
</true>
</if>
</sequence>
</process>
}

}
