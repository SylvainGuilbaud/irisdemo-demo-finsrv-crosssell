Class IRISDemo.REST.Dispatcher Extends %CSP.REST
{

Parameter HandleCorsRequest = 1;

Parameter UseSession = 1;

Parameter CONVERTINPUTSTREAM = 1;

Parameter CHARSET = "utf-8";

XData UrlMap
{
<Routes>
<Route Url="/init" Method="GET" Call="init"/>
  </Routes>
}

ClassMethod init() As %Status
{
  set %response.ContentType="application/json"
  set json={}
  set sc = $system.OBJ.LoadDir("/shared/bi","ck-d",.err,1)
  set:sc json.import = "BI classes successfully imported"
  set:'sc json.import = "ERROR WHILE IMPORTING BI classes :"_($system.Status.GetErrorText(sc))
  set json.cubes = []
  
  for cube = "transactions","account" {
	set cube = {}
	set sc = ##class(%DeepSee.Utils).%BuildCube(cube)
	set:sc cube.build = "Cube "_cube_" successfully built"
	set:'sc cube.build = "ERROR WHILE BUILDING cube :"_cube_" "_($system.Status.GetErrorText(sc))
	do json.cubes.%Push(cube)
  }

  do json.%ToJSON()
  return $$$OK
}

}
