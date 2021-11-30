/// 
Class cubes.account Extends %DeepSee.CubeDefinition [ DependsOn = IRISDemo.Account, ProcedureBlock ]
{

/// Cube definition from Architect.
XData Cube [ XMLNamespace = "http://www.intersystems.com/deepsee" ]
{
<cube xmlns="http://www.intersystems.com/deepsee" name="account" displayName="account" disabled="false" abstract="false" sourceClass="IRISDemo.Account" countMeasureName="%COUNT" bucketSize="8" bitmapChunkInMemory="false" precompute="0" disableListingGroups="false" enableSqlRestrict="false">
</cube>
}

Parameter DOMAIN;

}
