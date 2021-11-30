/// 
Class cubes.transactions Extends %DeepSee.CubeDefinition [ DependsOn = IRISDemo.CheckingTrans, ProcedureBlock ]
{

/// Cube definition from Architect.
XData Cube [ XMLNamespace = "http://www.intersystems.com/deepsee" ]
{
<cube xmlns="http://www.intersystems.com/deepsee" name="transactions" displayName="transactions" disabled="false" abstract="false" sourceClass="IRISDemo.CheckingTrans" countMeasureName="%COUNT" bucketSize="8" bitmapChunkInMemory="false" precompute="0" disableListingGroups="false" enableSqlRestrict="false">
  <dimension name="TransType" disabled="false" hasAll="false" allCaption="All TransType" allDisplayName="TransType" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="TransType" disabled="false" sourceProperty="TransType" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="TransDateTime" disabled="false" hasAll="false" allCaption="All TransDateTime" allDisplayName="TransDateTime" sourceProperty="TransDateTime" type="time" calendar="gregorian" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="TransDateTime" disabled="false" timeFunction="DayMonthYear" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="TransactionNumber" disabled="false" hasAll="false" allCaption="All TransactionNumber" allDisplayName="TransactionNumber" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="TransactionNumber" disabled="false" sourceProperty="TransactionNumber" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="WasBlocked" disabled="false" hasAll="false" allCaption="All WasBlocked" allDisplayName="WasBlocked" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="WasBlocked" disabled="false" sourceProperty="WasBlocked" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="WhiteListAccountNumber" disabled="false" hasAll="false" allCaption="All AccountNumber" allDisplayName="AccountNumber" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="AccountNumber" disabled="false" sourceProperty="WhiteListedBy.FromAccountNumber.AccountNumber" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="FromAccountNumber" disabled="false" hasAll="false" allCaption="All AccountNumber" allDisplayName="AccountNumber" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="FromAccountNumber" disabled="false" sourceProperty="FromAccount.AccountNumber" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="ToAccountNumber" disabled="false" hasAll="false" allCaption="All AccountNumber" allDisplayName="AccountNumber" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="ToAccountNumber" disabled="false" sourceProperty="ToAccount.AccountNumber" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <measure name="Amount" disabled="false" sourceProperty="Amount" aggregate="SUM" type="number" hidden="false" searchable="false">
  </measure>
  <measure name="FromAccountOldBalance" displayName="ancien solde du compte" disabled="false" sourceProperty="FromAccountOldBalance" aggregate="SUM" type="number" hidden="false" searchable="false">
  </measure>
  <measure name="FromAccountNewBalance" displayName="nouveau solde du compte" disabled="false" sourceProperty="FromAccountNewBalance" aggregate="SUM" type="number" hidden="false" searchable="false">
  </measure>
  <measure name="ToAccountOldBalance" disabled="false" sourceProperty="ToAccountOldBalance" aggregate="SUM" type="number" hidden="false" searchable="false">
  </measure>
  <measure name="ToAccountNewBalance" disabled="false" sourceProperty="ToAccountNewBalance" aggregate="SUM" type="number" hidden="false" searchable="false">
  </measure>
  <listing name="detail" disabled="false" listingType="table" fieldList="%ID,BC_TRANS_AMOUNT AS &quot;amount&quot;,BC_TRANS_IS_FRAUD AS &quot;fraud&quot;,BC_TRANS_DATE AS &quot;date&quot;,BC_TRANS_TYPE AS &quot;type&quot;,BC_TRANS_NUM AS &quot;num&quot;,BC_TRANS_WAS_BLOCKED AS &quot;blocked&quot;,BC_TRANS_SRC_ACC-&gt;BC_ACC_NUMBER AS &quot;source account&quot;,BC_TRANS_DEST_ACC-&gt;BC_ACC_NUMBER AS &quot;dest account&quot;,BC_TRANS_WHITELISTED_BY-&gt;BS_WL_ACCOUNT-&gt;BC_ACC_NUMBER AS &quot;white list accNumber &quot;,BC_TRANS_SRC_ACC_OLD_BAL AS &quot;source old balance&quot;,BC_TRANS_SRC_ACC_NEW_BAL AS &quot;source new balance&quot;,BC_TRANS_DEST_ACC_OLD_BAL AS &quot;dest old balance&quot;,BC_TRANS_DEST_ACC_NEW_BAL AS &quot;dest new balance&quot;">
  </listing>
</cube>
}

Parameter DOMAIN;

}
