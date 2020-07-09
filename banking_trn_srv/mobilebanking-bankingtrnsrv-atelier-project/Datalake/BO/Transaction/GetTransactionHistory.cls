Class Datalake.BO.Transaction.GetTransactionHistory Extends Ens.BusinessOperation [ Language = objectscript ]
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method GetTransactionHistory(pRequest As BankingSrv.Msg.RewardReq, Output pResponse As BankingSrv.Msg.RewardResp) As %Status
{

	set iTranCount = 0
	set dTranAmt = 0

	$$$TRACE("retreving data using account ID...")
	Set tSQL = "SELECT count(T.ID) As TransCount, Sum(BC_TRANS_AMOUNT) AS TransAmount"_
		" FROM IRISDemo.BC_TRANSACTIONS T, IRISDemo.BC_CUST_ACCOUNT A"_
		" WHERE T.BC_TRANS_SRC_ACC = A.ID"_
		" AND ISNULL(BC_TRANS_WAS_BLOCKED,0) <> 1"_
		" AND BC_ACC_NUMBER = '"_pRequest.FromAccountNumber_"'"
	
	//Set pParams=1
	
	//Set pParams(1)=pRequest.FromAccountNumber

	#dim pRS As EnsLib.SQL.GatewayResultSet
	
	$$$TRACE("Executing Query...")
	$$$TRACE("tSQL="_tSQL)
	//$$$TRACE("pParams(1)="_pParams(1))
	
	//Set tSC =  ..Adapter.ExecuteQuery(.pRS, tSQL, pParams)
	Set tSC =  ..Adapter.ExecuteQuery(.pRS, tSQL)

	if pRS.Next() {
		$$$TRACE("tSC OK")
		$$$TRACE("TransAmount = "_pRS.Get("TransAmount"))
		$$$TRACE("TransCount = "_pRS.Get("TransCount"))
	}	
	
	set pResponse = ##class(BankingSrv.Msg.RewardResp).%New()
	set pResponse.Amount = pRequest.Amount
	set pResponse.FromAccountNumber = pRequest.FromAccountNumber
	set pResponse.ToAccountNumber = pRequest.ToAccountNumber
	set pResponse.TransDateTime = pRequest.TransDateTime
	set pResponse.TransType = pRequest.TransType
	set pResponse.TransactionAmtLastPeriod = pRS.Get("TransAmount")
	set:(pResponse.TransactionAmtLastPeriod="") pResponse.TransactionAmtLastPeriod = 0 
	set pResponse.TransactionsLastPeriod = pRS.Get("TransCount")
	set:(pResponse.TransactionsLastPeriod="") pResponse.TransactionsLastPeriod = 0
	
	return $$$OK
}

Method GetTranCount(pRequest As BankingSrv.Msg.TranCountReq, Output pResponse As Ens.Response)
{

	set iTranCount = 0
	set dTranAmt = 0

	$$$TRACE("retreving tran count using account ID...")
	Set tSQL = "SELECT Count(T.ID) as TransCount"_
		" FROM IRISDemo.BC_TRANSACTIONS T, IRISDemo.BC_CUST_ACCOUNT A"_
		" WHERE T.BC_TRANS_SRC_ACC = A.ID"_
		" AND BC_ACC_NUMBER = '"_pRequest.FromAccountNumber_"'"_
		" AND BC_TRANS_DATE > DATEADD('ss',-60,Now())"
	
	//Set pParams=1
	
	//Set pParams(1)=pRequest.FromAccountNumber

	#dim pRS As EnsLib.SQL.GatewayResultSet
	
	$$$TRACE("Executing Query...")
	$$$TRACE("tSQL="_tSQL)
	//$$$TRACE("pParams(1)="_pParams(1))
	
	//Set tSC =  ..Adapter.ExecuteQuery(.pRS, tSQL, pParams)
	Set tSC =  ..Adapter.ExecuteQuery(.pRS, tSQL)

	if pRS.Next() {
		$$$TRACE("tSC OK")
		$$$TRACE("TransCount = "_pRS.Get("TransCount"))
	}	
	
	set pResponse = ##class(BankingSrv.Msg.TranCountResp).%New()
	set pResponse.FromAccountNumber = pRequest.FromAccountNumber
	set pResponse.TranCount = pRS.Get("TransCount")
	set:(pResponse.TranCount="") pResponse.TranCount = 0
	
	return $$$OK
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="BankingSrv.Msg.RewardReq"> 
		<Method>GetTransactionHistory</Method>
	</MapItem>
	<MapItem MessageType="BankingSrv.Msg.TranCountReq"> 
		<Method>GetTranCount</Method>
	</MapItem>
</MapItems>
}

}
