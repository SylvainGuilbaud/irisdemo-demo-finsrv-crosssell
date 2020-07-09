Class IRISDemo.TransLocation Extends %Persistent [ SqlTableName = BC_TRANS_LOC ]
{

Property TransactionNumber As %Integer [ Required, SqlFieldName = BC_TRANS_ID ];

Property RegionId As %Integer;

Property Longitude As %Double;

Property Latitude As %Double;

Property Country As %String;

Property State As %String;

Property StateDesc As %String;

Property Suburb As %String;

Index isxTransId On TransactionNumber;

Storage Default
{
<Data name="TransLocationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TransactionNumber</Value>
</Value>
<Value name="3">
<Value>RegionId</Value>
</Value>
<Value name="4">
<Value>Longitude</Value>
</Value>
<Value name="5">
<Value>Latitude</Value>
</Value>
<Value name="6">
<Value>Country</Value>
</Value>
<Value name="7">
<Value>State</Value>
</Value>
<Value name="8">
<Value>StateDesc</Value>
</Value>
<Value name="9">
<Value>Suburb</Value>
</Value>
</Data>
<DataLocation>^IRISDemo.TransLocationD</DataLocation>
<DefaultData>TransLocationDefaultData</DefaultData>
<IdLocation>^IRISDemo.TransLocationD</IdLocation>
<IndexLocation>^IRISDemo.TransLocationI</IndexLocation>
<StreamLocation>^IRISDemo.TransLocationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
