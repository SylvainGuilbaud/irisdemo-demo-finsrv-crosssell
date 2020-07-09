/// takes the data from geonames 
/// Source http://download.geonames.org/export/zip/
/// 
///     country code      : iso country code, 2 characters
///     postal code       : varchar(20)
///     place name        : varchar(180)
///     admin name1       : 1. order subdivision (state) varchar(100)
///     admin code1       : 1. order subdivision (state) varchar(20)
///     admin name2       : 2. order subdivision (county/province) varchar(100)
///     admin code2       : 2. order subdivision (county/province) varchar(20)
///     admin name3       : 3. order subdivision (community) varchar(100)
///     admin code3       : 3. order subdivision (community) varchar(20)
///     latitude          : estimated latitude (wgs84)
///     longitude         : estimated longitude (wgs84)
///     accuracy          : accuracy of lat/lng from 1=estimated, 4=geonameid, 6=centroid of addresses or shape
Class IRISConfig.Region Extends %Persistent
{

Property CountryCode As %String;

Property PostalCode As %String;

Property PlaceName As %String;

Property AdminName1 As %String;

Property AdminCode1 As %String;

Property AdminName2 As %String;

Property AdminCode2 As %String;

Property AdminName3 As %String;

Property AdminCode3 As %String;

Property Latitude As %Double;

Property Longitude As %Double;

ClassMethod LoadDataFromCSV(csvPath As %String = "/shared/region.txt", appendHeader As %Boolean = 1) As %Status
{
		W !,"Loading "_csvPath_"..."
		set loadFrom = csvPath
		Set tSC = $$$OK
		Try
		{
			if appendHeader {
				W !,"appending header ..."
				// Verify the file does not have a header - from repeated runs
				set inFile= ##class(%FileCharacterStream).%New()
				set inFile.Filename = csvPath
				set firstLine = inFile.ReadLine()
				set inFile = ""
				if ($piece(firstLine,"	") = "CountryCode")
				{
					w !,"'"_csvPath_"' has header line"
				}
				else
				{ 	
					w !,"appending header line to '"_csvPath_"'"
					// the data from geonames does not include a header line.
					set headerline = "CountryCode	PostalCode	PlaceName	AdminName1	AdminCode1	AdminName2	AdminCode2	AdminName3	AdminCode3	Latitude	Longitude	Accuracy"
					set inFile= ##class(%FileCharacterStream).%New()
					set inFile.Filename = csvPath
					set outFile= ##class(%FileCharacterStream).%New()
					set outFile.Filename = loadFrom //csvPath
					do outFile.WriteLine(headerline)
					do outFile.CopyFrom(inFile)
					do outFile.SaveStream()
					set inFile =""
					set outFile =""
				}
			} else {
				set loadFrom = csvPath

			}			
			// looking for the region.txt file...
			// load it into the Region table 
			
			//Disable journaling to speed data bulk load
			DO DISABLE^%NOJRN
			
			Set iLine=0 //Header is consumed

			w !,"Starting load from '"_loadFrom_"'"

			Set oRSRegions=##class(%ResultSet).%New("IRISDemo.Util.FileReader:TSV")
			w !,"..."
			Set tSC = oRSRegions.Execute(loadFrom)
			W:(tSC) !,"tSC="_tSC_" - "_$system.Status.DisplayError(tSC)
			//Quit:$System.Status.IsError(tSC)

			W !,"Processing..."			
			While oRSRegions.Next()
			{
				Set iLine=iLine+1
				//W !,"Processing...iline="_iLine			
				
				set oRegion = ##class(IRISConfig.Region).%New()
				set oRegion.CountryCode = oRSRegions.Get("CountryCode")
				set oRegion.PostalCode = oRSRegions.Get("PostalCode")
				set oRegion.PlaceName = oRSRegions.Get("PlaceName")
				set oRegion.AdminName1 = oRSRegions.Get("AdminName1")
				set oRegion.AdminCode1 = oRSRegions.Get("AdminCode1")
				set oRegion.AdminName2 = oRSRegions.Get("AdminName2")
				set oRegion.AdminCode2 = oRSRegions.Get("AdminCode2")
				set oRegion.AdminName3 = oRSRegions.Get("AdminName3")
				set oRegion.AdminCode3 = oRSRegions.Get("AdminCode3")

				set oRegion.Latitude = +oRSRegions.Get("Latitude")
				set oRegion.Longitude = +oRSRegions.Get("Longitude")
				
				Set tSC = oRegion.%Save()
				//Quit:$System.Status.IsError(tSC)

				w:((iLine#100)=0) "."
				w:((iLine#5000)=0) iLine,!

			}
			Quit:$System.Status.IsError(tSC)
			
			// enable Journaling
			DO ENABLE^%NOJRN

			w !,"finished loading "_iLine_" regions."

		}
		Catch (oException)
		{
			Set tSC = oException.AsStatus()
		}
		
		Quit tSC
}

ClassMethod getLocations(CountryCode As %String = "", State As %String = "") As %Library.ListOfDataTypes [ Private ]
{
		
		// Determine if Country and/or State is provided 
		set qryOption = 1
		set:(State="") qryOption = 2
		set:(CountryCode="") qryOption = 3
		// calc number of matches
		// get random element

		
		if (qryOption=1) { 
			W !,"Loc crtiteria 1."
			&SQL(Select %DLIST(ID) INTO :idList FROM IRISConfig.Region WHERE CountryCode=:CountryCode AND AdminCode1=:State)
		}
		elseif (qryOption=2) { 
			W !,"Loc crtiteria 2."
			&SQL(Select %DLIST(ID) INTO :idList FROM IRISConfig.Region WHERE CountryCode=:CountryCode)
		}
		else { 
			W !,"Loc crtiteria 3."
			&SQL(Select %DLIST(ID) INTO :idList FROM IRISConfig.Region )
		}
		
		set retList = ##class(%Library.ListOfDataTypes).%New()
		set tSC = retList.InsertList(idList)
		
		
		quit retList
}

ClassMethod PopulateTransLocation(CountryCode As %String = "", State As %String = "") As %Status
{

	W !,"Starting to load Transaction Locations..."

	Set tSC = $$$OK
	Try
	{

		//Disable journaling to speed data bulk load
		DO DISABLE^%NOJRN

		// Build List of Locations to match Country/State
		
		W !,"Getting locations for Country Code='"_CountryCode_"' and state='"_State_"'..."
		
		set regionList = ..getLocations(CountryCode, State)

		w "regionList count = "_regionList.Count(),!
		//Loop through transactions and add Random Region Data
		
		Set oRS = ##class(%ResultSet).%New()
		Set tSC = oRS.Prepare("SELECT T.ID As ID from IRISDemo.BC_TRANSACTIONS T LEFT JOIN IRISDemo.BC_TRANS_LOC L ON T.ID = L.BC_TRANS_ID WHERE L.ID is null")
								
		Quit:$System.Status.IsError(tSC)
		
		Set tSC = oRS.Execute()
		Quit:$System.Status.IsError(tSC)
		
		set iCtr = 0
		WHILE $$$OK 
		{
			Quit:'oRS.Next()
			
			Set oLoc = ##class(IRISDemo.TransLocation).%New()
			set randID = regionList.GetAt($random(regionList.Count())+1)
			set oReg = ##class(IRISConfig.Region).%OpenId(randID)
			
			//set oReg = ##class(IRISConfig.Region).getRandomLocation(CountryCode, State)
			set oLoc.TransactionNumber = oRS.GetData(1)
			set oLoc.Country = oReg.CountryCode
			set oLoc.State = oReg.AdminCode1
			set oLoc.StateDesc = oReg.AdminName1
			set oLoc.Suburb = oReg.AdminName2
			set oLoc.Longitude = oReg.Longitude
			set oLoc.Latitude = oReg.Latitude
			
			set tSC = oLoc.%Save()
			do $I(iCtr)
			
			w:((iCtr#500)=0) "."
			w:((iCtr#10000)=0) iCtr,!
			
			Quit:$System.Status.IsError(tSC)
		} 
		Quit:$System.Status.IsError(tSC)
		
		// enable Journaling
		DO ENABLE^%NOJRN
	}
	Catch (oException)
	{
		Set tSC = oException.AsStatus()
	}
	
	Quit tSC
}

Storage Default
{
<Data name="RegionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CountryCode</Value>
</Value>
<Value name="3">
<Value>PostalCode</Value>
</Value>
<Value name="4">
<Value>PlaceName</Value>
</Value>
<Value name="5">
<Value>AdminName1</Value>
</Value>
<Value name="6">
<Value>AdminCode1</Value>
</Value>
<Value name="7">
<Value>AdminName2</Value>
</Value>
<Value name="8">
<Value>AdminCode2</Value>
</Value>
<Value name="9">
<Value>AdminName3</Value>
</Value>
<Value name="10">
<Value>AdminCode3</Value>
</Value>
<Value name="11">
<Value>Latitude</Value>
</Value>
<Value name="12">
<Value>Longitude</Value>
</Value>
</Data>
<DataLocation>^IRISConfig.RegionD</DataLocation>
<DefaultData>RegionDefaultData</DefaultData>
<IdLocation>^IRISConfig.RegionD</IdLocation>
<IndexLocation>^IRISConfig.RegionI</IndexLocation>
<StreamLocation>^IRISConfig.RegionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
