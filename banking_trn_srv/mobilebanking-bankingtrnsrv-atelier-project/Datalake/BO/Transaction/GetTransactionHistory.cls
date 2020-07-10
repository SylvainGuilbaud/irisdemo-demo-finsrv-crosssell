Class Datalake.BO.Transaction.GetTransactionHistory Extends Ens.BusinessOperation [ Language = objectscript ]
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method GetTransactionHistory(pRequest As Datalake.BO.Transaction.RewardReq, Output pResponse As Datalake.BO.Transaction.RewardResp) As %Status
{
	set tSC = $$$OK
	
	Try{
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
		Quit:$$$ISERR(tSC)
	
		if pRS.Next() {
			$$$TRACE("tSC OK")
			$$$TRACE("TransAmount = "_pRS.Get("TransAmount"))
			$$$TRACE("TransCount = "_pRS.Get("TransCount"))
		}	
		
		set pResponse = ##class(Datalake.BO.Transaction.RewardResp).%New()
		
		set pResponse.TransactionAmtLastPeriod = +pRS.Get("TransAmount")
		set pResponse.TransactionsLastPeriod = +pRS.Get("TransCount")
	
	}
	Catch(oException){
		set tSC = oException.AsStatus()
	}

	return tSC
}

Method GetTranCount(pRequest As Datalake.BO.Transaction.TransCountReq, Output pResponse As Datalake.BO.Transaction.RewardResp)
{

	w 1/0
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
	
	set pResponse = ##class(Datalake.BO.Transaction.RewardResp).%New()
	set pResponse.FromAccountNumber = pRequest.FromAccountNumber
	set pResponse.TranCount = pRS.Get("TransCount")
	set:(pResponse.TranCount="") pResponse.TranCount = 0
	
	return $$$OK
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="Datalake.BO.Transaction.RewardReq"> 
		<Method>GetTransactionHistory</Method>
	</MapItem>
	<MapItem MessageType="Datalake.BO.Transaction.TransCountReq"> 
		<Method>GetTranCount</Method>
	</MapItem>
</MapItems>
}

}
