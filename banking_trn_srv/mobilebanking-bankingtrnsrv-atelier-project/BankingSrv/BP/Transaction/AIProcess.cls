/// 
Class BankingSrv.BP.Transaction.AIProcess Extends Ens.BusinessProcessBPL [ ClassType = persistent, ProcedureBlock ]
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='BankingSrv.BS.Transaction.NewTransactionReq' response='BankingSrv.BS.Transaction.NewTransactionResp' height='2550' width='2000' >
<context>
<property name='Request' type='BankingSrv.BS.Transaction.NewTransactionReq' instantiate='0' />
<property name='QueryWhiteListResp' type='WhiteList.BO.QueryWhiteListResp' instantiate='0' />
<property name='TransactionAllowed' type='%Boolean' initialexpression='1' instantiate='0' />
<property name='DatalakeReq' type='Datalake.BO.Transaction.NewTransactionReq' instantiate='0' />
<property name='TransactionResp' type='BankingCore.Transaction.WSProxy.s0.CreateTransactionResp' instantiate='0' />
<property name='ExecuteModelReq' type='IRISDemo.BO.PMML.ExecuteModelReq' instantiate='0' />
<property name='LooksLikeFraud' type='%Library.Boolean' instantiate='0' />
<property name='LooksLikeFraudReason' type='%Library.String' instantiate='0' />
<property name='ExecuteMLModelRequest' type='ML.Model.BO.Executor.ExecuteModelReq' instantiate='0' />
<property name='FraudPrediction' type='%Integer' instantiate='0' />
</context>
<sequence xend='200' yend='2550' >
<if name='PAYMENT' condition='request.TransType="PAYMENT"' xpos='200' ypos='250' xend='200' yend='1800' >
<true>
<transform name='Prepare ML Model Features' class='BankingSrv.DTL.BuildMLFeatures' source='request' target='context.ExecuteMLModelRequest' xpos='470' ypos='400' />
<call name='Execute ML Model' target='Fraud Prediction ML Model Executor' async='0' xpos='470' ypos='500' >
<annotation><![CDATA[Call the new ML Model using the ML package to determine if this is a fraudulent transaction]]></annotation>
<request type='ML.Model.BO.Executor.ExecuteModelReq' >
<assign property="callrequest" value="context.ExecuteMLModelRequest" action="set" />
</request>
<response type='ML.Model.BO.Executor.ExecuteModelResp' >
<assign property="context.FraudPrediction" value="callresponse.ModelOutput.GetAt(&quot;fraud&quot;)" action="set" />
</response>
</call>
<trace name='Trace If Flagged As Fraud' value='"Is Fraud: "_(context.FraudPrediction)' xpos='470' ypos='600' />
<assign name="Save Request into Context" property="context.Request" value="request" action="set" xpos='470' ypos='700' />
<rule name='Hard rules' rule='BankingSrv.Rule.AIRule'  resultLocation='context.LooksLikeFraud' reasonLocation='context.LooksLikeFraudReason' ruleContext='context' xpos='470' ypos='800' >
<annotation><![CDATA[Evaluate response of ML model together with transactional data. Combining business rules and ML insight]]></annotation>
</rule>
<if name='Fraud?' condition='context.LooksLikeFraud' xpos='470' ypos='900' xend='470' yend='1700' >
<annotation><![CDATA[Is it a fraudulent transaction?]]></annotation>
<true>
<call name='Query White List' target='White List Operation' async='0' xpos='605' ypos='1050' >
<annotation><![CDATA[Let's see if the customer notified us if he/she would be doing something different today...]]></annotation>
<request type='WhiteList.BO.QueryWhiteListReq' >
<assign property="callrequest.FromAccountNumber" value="request.FromAccountNumber" action="set" />
</request>
<response type='WhiteList.BO.QueryWhiteListResp' >
<assign property="context.QueryWhiteListResp" value="callresponse" action="set" />
</response>
</call>
<if name='White listed?' condition='context.QueryWhiteListResp.WhiteListRequestFound' xpos='605' ypos='1150' xend='605' yend='1600' >
<annotation><![CDATA[He/she did?]]></annotation>
<true>
<trace name='Trace suspicious allowed' value='"Suspicious transaction allowed:"_context.QueryWhiteListResp.RequestDate' xpos='605' ypos='1300' />
</true>
<false>
<trace name='Trace suspicious blocked' value='"Suspicious transaction BLOCKED. No white list found."' xpos='875' ypos='1300' />
<assign name="Above Limit not allowed!" property="context.TransactionAllowed" value="0" action="set" xpos='875' ypos='1400' >
<annotation><![CDATA[No! So, let's decline this transaction!]]></annotation>
</assign>
<call name='Send Email - Alert' target='Send Email' async='1' xpos='875' ypos='1500' >
<request type='BankingSrv.BO.Email.EmailRequest' >
<assign property="callrequest.Recipient" value="$Get(^EmailRecipient)" action="set" />
<assign property="callrequest.Subject" value="&quot;Demo Bank - Suspicious Activity&quot;" action="set" />
<assign property="callrequest.EmailBody" value="&quot;Dear Customer,&quot;_$CHAR(10)_$CHAR(10)_&quot;We have identified some suspicious activity on your Credit Card.&quot;_$CHAR(10)_$CHAR(10)_&quot;Whilst we have declined the transaction, your card is still operational. You should check your transactions...&quot;" action="set" />
</request>
</call>
</false>
</if>
</true>
</if>
</true>
<false>
<assign name="DEBIT " property="context.TransactionAllowed" value="1" action="set" xpos='200' ypos='400' />
</false>
</if>
<if name='Allowed?' condition='context.TransactionAllowed' xpos='200' ypos='1900' xend='200' yend='2450' >
<true>
<assign name="Transaction Approved!" property="response.TransactionApproved" value="1" action="set" xpos='470' ypos='2050' />
<call name='Call Core Banking' target='Banking Core Transaction Operation' async='0' xpos='470' ypos='2150' >
<request type='BankingCore.Transaction.CreateTransactionRequest' >
<assign property="callrequest.pTransDateTime" value="request.TransDateTime" action="set" />
<assign property="callrequest.pTransType" value="request.TransType" action="set" />
<assign property="callrequest.pAmount" value="request.Amount" action="set" />
<assign property="callrequest.pFromAccountNumber" value="request.FromAccountNumber" action="set" />
<assign property="callrequest.pToAccountNumber" value="request.ToAccountNumber" action="set" />
</request>
<response type='BankingCore.Transaction.CreateTransactionResponse' >
<assign property="response.TransactionId" value="callresponse.CreateTransactionResult.TransactionId" action="set" />
<assign property="context.TransactionResp" value="callresponse.CreateTransactionResult" action="set" />
</response>
</call>
<call name='Call Rewards Process' target='Credit Card Reward' async='1' xpos='470' ypos='2250' >
<request type='BankingSrv.BS.Transaction.NewTransactionReq' >
<assign property="callrequest" value="request" action="set" />
</request>
</call>
<call name='Populate the data lake' target='Datalake Transaction Operations' async='1' xpos='470' ypos='2350' >
<annotation><![CDATA[Asynchronous]]></annotation>
<request type='Datalake.BO.Transaction.NewTransactionReq' >
<assign property="callrequest.TransDateTime" value="request.TransDateTime" action="set" />
<assign property="callrequest.TransactionNumber" value="context.TransactionResp.TransactionId" action="set" />
<assign property="callrequest.FromAccountOldBalance" value="context.TransactionResp.FromAccountOldBalance" action="set" />
<assign property="callrequest.FromAccountNewBalance" value="context.TransactionResp.FromAccountNewBalance" action="set" />
<assign property="callrequest.ToAccountOldBalance" value="context.TransactionResp.ToAccountOldBalance" action="set" />
<assign property="callrequest.ToAccountNewBalance" value="context.TransactionResp.ToAccountNewBalance" action="set" />
<assign property="callrequest.TransType" value="request.TransType" action="set" />
<assign property="callrequest.Amount" value="request.Amount" action="set" />
<assign property="callrequest.WhiteListRequestId" value="context.QueryWhiteListResp.WhiteListRequestId" action="set" />
<assign property="callrequest.FromAccountNumber" value="request.FromAccountNumber" action="set" />
<assign property="callrequest.ToAccountNumber" value="request.ToAccountNumber" action="set" />
<assign property="callrequest.TransactionAllowed" value="context.TransactionAllowed" action="set" />
</request>
</call>
</true>
<false>
<assign name="Transaction declined!" property="response.TransactionApproved" value="0" action="set" xpos='200' ypos='2050' />
<call name='Populate the data lake' target='Datalake Transaction Operations' async='1' xpos='200' ypos='2150' >
<annotation><![CDATA[Asynchronous]]></annotation>
<request type='Datalake.BO.Transaction.NewTransactionReq' >
<assign property="callrequest.TransDateTime" value="request.TransDateTime" action="set" />
<assign property="callrequest.TransactionNumber" value="0" action="set" />
<assign property="callrequest.FromAccountOldBalance" value="0" action="set" />
<assign property="callrequest.FromAccountNewBalance" value="0" action="set" />
<assign property="callrequest.ToAccountOldBalance" value="0" action="set" />
<assign property="callrequest.ToAccountNewBalance" value="0" action="set" />
<assign property="callrequest.TransType" value="request.TransType" action="set" />
<assign property="callrequest.Amount" value="request.Amount" action="set" />
<assign property="callrequest.WhiteListRequestId" value="context.QueryWhiteListResp.WhiteListRequestId" action="set" />
<assign property="callrequest.FromAccountNumber" value="request.FromAccountNumber" action="set" />
<assign property="callrequest.ToAccountNumber" value="request.ToAccountNumber" action="set" />
<assign property="callrequest.TransactionAllowed" value="context.TransactionAllowed" action="set" />
</request>
</call>
</false>
</if>
</sequence>
</process>
}

}
