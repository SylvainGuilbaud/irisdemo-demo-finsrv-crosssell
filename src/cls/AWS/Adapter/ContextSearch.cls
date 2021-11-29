Class AWS.Adapter.ContextSearch Extends %ZEN.Portal.ContextSearch
{

ClassMethod RegionList(Output pCaption As %String, Output pTopResults, Output pResults, ByRef pParms As %String, pSearchKey As %String = "") As %Status
{
		set key=0
		Set pResults($I(key))="us-east-1"
		Set pResults($I(key))="us-west-1"
		Set pResults($I(key))="us-gov-west-1"
		Set pResults($I(key))="ap-northeast-1"
		Set pResults($I(key))="ap-south-1"
		Set pResults($I(key))="ap-southeast-1"
		Set pResults($I(key))="ap-southeast-2"
		Set pResults($I(key))="eu-central-1"
		Set pResults($I(key))="eu-west-1"
		Set pResults($I(key))="eu-west-3"
		
		Quit $$$OK
}

ClassMethod HashList(Output pCaption As %String, Output pTopResults, Output pResults, ByRef pParms As %String, pSearchKey As %String = "") As %Status
{
		Set pResults(1)="AWS4-HMAC-SHA256"
		
		Quit $$$OK
}

}
