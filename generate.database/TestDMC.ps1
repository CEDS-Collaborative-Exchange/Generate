Param(
  [string] $sqlServer = "192.168.51.53",
  [string] $db = "generate",
  [string] $user,
  [string] $password,
  [string] $sqlCmdPath = "C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\170\Tools\Binn\SQLCMD.EXE")

Echo "Server = $sqlServer"
Echo "Database = $db"
Echo "User = $user"
Echo "Password = $password"

# Example Usage:
# PS TestDMC.ps1 '(LocalDb)\MSSQLLocalDB'
# PS TestDMC.ps1 "192.168.51.54" "generate" "xxxxxxx"
# PS TestDMC.ps1 "192.168.51.53" "generate-test" "generate"

$erroractionpreference = 'stop'

try
{
	$invocation = (Get-Variable MyInvocation).Value
	$currentPath = Split-Path $invocation.MyCommand.Path

	$testPath = "$currentPath\TestCases"
	
    Echo "Version Path = $testPath"	
	Echo "TestDMC.ps1 Starting"

    $clearPath = "$testPath\pre_Test DMC.sql" 

	Get-childitem $testPath | ForEach-Object {

        Echo "Running: $testPath\$_" 
		If ($user) {
			& $sqlCmdPath -b -S $sqlServer -d $db -U $user -P $password -i "$testPath\$_" 
		}
		Else {
			& $sqlCmdPath -b -S $sqlServer -d $db -i "$testPath\$_" 
		}
	}

    $fileToRun = $testPath + "\Test DMC.sql"

	$fileMsg = $fileToRun + " - Finished"
	Echo $fileMsg

	Echo "TestDMC.ps1 Complete"

}
Catch [Exception]
{
	Write-Host "Generic Exception"
	Write-Host $_
	$_ | Select *
}
