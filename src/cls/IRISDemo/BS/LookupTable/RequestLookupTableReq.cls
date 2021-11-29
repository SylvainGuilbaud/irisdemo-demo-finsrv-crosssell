Class IRISDemo.BS.LookupTable.RequestLookupTableReq Extends (%Persistent, Ens.Request)
{

Property LookupTableName As %String [ Required ];

Property DatalakeTableName As %String [ Required ];

Property DataLakeKeyColumnName As %String [ Required ];

Property DataLakeValColumnName As %String [ Required ];

Storage Default
{
<Data name="RequestLookupTableReqDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LookupTableName</Value>
</Value>
<Value name="3">
<Value>DatalakeTableName</Value>
</Value>
<Value name="4">
<Value>DataLakeKeyColumnName</Value>
</Value>
<Value name="5">
<Value>DataLakeValColumnName</Value>
</Value>
</Data>
<DataLocation>^IRISDemo.B47F7.RequestLook5625D</DataLocation>
<DefaultData>RequestLookupTableReqDefaultData</DefaultData>
<IdLocation>^IRISDemo.B47F7.RequestLook5625D</IdLocation>
<IndexLocation>^IRISDemo.B47F7.RequestLook5625I</IndexLocation>
<StreamLocation>^IRISDemo.B47F7.RequestLook5625S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
