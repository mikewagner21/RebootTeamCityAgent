$username = "%buildAgentAccessUser%"
$password = "%buildAgentAccessPassword%"
$authInfo = $username + ":" + $password
$authInfo = [System.Convert]::ToBase64String([System.Text.Encoding]::Default.GetBytes($authInfo))

$uri = "%teamcity.serverUrl%/httpAuth/app/rest/agents/name:%teamcity.agent.name%/id"

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls -bor [Net.SecurityProtocolType]::Tls11 -bor [Net.SecurityProtocolType]::Tls12
$webRequest = [System.Net.WebRequest]::Create($uri)
$webRequest.Headers["Authorization"] = "Basic " + $authInfo
$webRequest.PreAuthenticate = $true 
[System.Net.WebResponse] $resp = $webRequest.GetResponse();
$rs = $resp.GetResponseStream();
[System.IO.StreamReader] $sr = New-Object System.IO.StreamReader -argumentList $rs;
[string] $id = $sr.ReadToEnd();
Write-Output "Rebooting Agent ID: $id"

$uri = "%teamcity.serverUrl%/httpAuth/remoteAccess/reboot.html?agent=$id&rebootAfterBuild=true"

$webRequest = [System.Net.WebRequest]::Create($uri)
$webRequest.Method="POST"
$webRequest.Headers["Authorization"] = "Basic " + $authInfo
$webRequest.ContentLength=0
$webRequest.PreAuthenticate = $true 
[System.Net.WebResponse] $resp = $webRequest.GetResponse();
$rs = $resp.GetResponseStream();
[System.IO.StreamReader] $sr = New-Object System.IO.StreamReader -argumentList $rs;
$sr.ReadToEnd();
Write-Output "Reboot request sent to %teamcity.agent.name%: $id"