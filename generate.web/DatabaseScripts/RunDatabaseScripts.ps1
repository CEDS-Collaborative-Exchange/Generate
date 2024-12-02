Param(
  [string] $version = "12.3_prerelease",
  [string] $sqlServer = "(localdb)\MSSQLLocalDB",
  [string] $db = "generate",
  [string] $user,
  [string] $password)

Echo "Version = $version"
Echo "Server = $sqlServer"
Echo "Database = $db"
Echo "User = $user"
Echo "Password = $password"


# Example Usage:
# PS RunDatabaseScripts.ps1 '3.1' '(LocalDb)\MSSQLLocalDB'
# PS RunDatabaseScripts.ps1 "3.1" "192.168.51.54" "generate" "xxxxxxx"
# PS RunDatabaseScripts.ps1 "3.1" "192.168.51.53" "generate-test" "generate"

$erroractionpreference = 'stop'

try
{
	$sqlCmdPath = "C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\170\Tools\Binn\SQLCMD.EXE"
	$invocation = (Get-Variable MyInvocation).Value
	$currentPath = Split-Path $invocation.MyCommand.Path

	$versionPath = "$currentPath\VersionUpdates\$version\VersionScripts.csv"

	Echo "Version Path = $versionPath"
	Echo "RunDatabaseScripts.ps1 Starting"

    $rows = Get-Content $versionPath

	ForEach ($row in $rows) 
	{
        $release,$file,$c = $row.Split(',')	
        
		# skip the null/empty line
		if ([string]::IsNullOrEmpty($file))
		{
			continue
		}

		$fileMsg = $row + " - Started"
		Echo $fileMsg

        $fileToRun = $release + "\" + $file

		If ($user) {
		 & $sqlCmdPath -b -S $sqlServer -d $db -U $user -P $password -i $fileToRun
		}
		Else {
		 & $sqlCmdPath -b -S $sqlServer -d $db -i $fileToRun
		}
		

		$fileMsg = $fileToRun + " - Finished"
		Echo $fileMsg
			
	}

	Echo "RunDatabaseScripts.ps1 Complete"

}
Catch [Exception]
{
	Write-Host "Generic Exception"
	Write-Host $_
	$_ | Select *
}
