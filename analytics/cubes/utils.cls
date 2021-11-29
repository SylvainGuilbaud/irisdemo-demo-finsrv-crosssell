Class cubes.utils [ Abstract ]
{

Parameter cubeName = "data";

Method %OnAfterSave(insert As %Boolean) As %Status [ Private, ServerOnly = 1 ]
{

	do ##class(%DeepSee.Utils).%ProcessFact(..#cubeName,..%Id())

	return $$$OK
}

ClassMethod %OnAfterDelete(oid As %ObjectIdentity) As %Status [ Private, ServerOnly = 1 ]
{

	do ##class(%DeepSee.Utils).%DeleteFact(..#cubeName,oid)

	return $$$OK
}

Trigger AfterDeleteTrigger [ Event = DELETE, Time = AFTER ]
{

	do ##class(%DeepSee.Utils).%DeleteFact(..#cubeName,{ID})
}

Trigger AfterInsertTrigger [ Event = INSERT, Time = AFTER ]
{

	do ##class(%DeepSee.Utils).%ProcessFact(..#cubeName,{ID})
}

Trigger AfterUpdateTrigger [ Event = UPDATE, Time = AFTER ]
{

	do ##class(%DeepSee.Utils).%ProcessFact(..#cubeName,{ID})
}

/*
Parameter ROWLEVELSECURITY = 1;

ClassMethod %SecurityPolicy(ZoneClesSociete As %String) As %String [ SqlProc ]
{
	set roles=""
	if $roles [ "%All" {
		set roles="%All"
	} 
	set roles=roles_","_ZoneClesSociete
	
    QUIT roles
}
*/
}
