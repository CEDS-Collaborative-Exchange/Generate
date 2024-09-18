param (
   [string]$buildNumber,
   [string]$environment,
   [string]$database,
   [string]$consolePath
)

(Get-Content "..\..\generate.web\ClientApp\src\assets\config\config.prod.json") | 
Foreach-Object {$_ -replace "Production", $environment} | 
Set-Content "..\..\generate.web\ClientApp\src\assets\config\config.prod.json";

(Get-Content "..\..\generate.web\ClientApp\src\assets\config\config.prod.json") | 
Foreach-Object {$_ -replace "0.0.0", $buildNumber} | 
Set-Content "..\..\generate.web\ClientApp\src\assets\config\config.prod.json";

(Get-Content "..\..\generate.web\web.config") | 
Foreach-Object {$_ -replace "development", $environment} | 
Set-Content "..\..\generate.web\web.config";

(Get-Content "..\..\generate.background\web.config") | 
Foreach-Object {$_ -replace "development", $environment} | 
Set-Content "..\..\generate.background\web.config";
