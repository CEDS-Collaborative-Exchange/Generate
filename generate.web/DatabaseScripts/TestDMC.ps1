Param(
  [string] $sqlServer = "10.0.2.10",
  [string] $db = "generate",
  [string] $user,
  [string] $password,
  [string] $sqlCmdPath = "C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\170\Tools\Binn\SQLCMD.EXE")

Write-Output "Server = $sqlServer"
Write-Output "Database = $db"
Write-Output "User = $user"
Write-Output "Password = $password"

# Example Usage:
# PS TestDMC.ps1 '(LocalDb)\MSSQLLocalDB'
# PS TestDMC.ps1 "192.168.51.54" "generate" "xxxxxxx"
# PS TestDMC.ps1 "10.0.2.10" "generate-test" "generate"

$erroractionpreference = 'stop'

try
{
	$invocation = (Get-Variable MyInvocation).Value
	$currentPath = Split-Path $invocation.MyCommand.Path

	$testPath = "$currentPath\TestCases"
	
    Write-Output "Version Path = $testPath"	
	Write-Output "TestDMC.ps1 Starting"

	Get-childitem $testPath | ForEach-Object {

        Write-Output "Running: $testPath\$_" 
		If ($user) {
			& $sqlCmdPath -b -S $sqlServer -d $db -U $user -P $password -i "$testPath\$_" 
		}
		Else {
			& $sqlCmdPath -b -S $sqlServer -d $db -i "$testPath\$_" 
		}
	}

	$fileMsg = $fileToRun + " - Finished"
	Write-Output $fileMsg

	Write-Output "TestDMC.ps1 Complete"

	Exit

}
Catch [Exception]
{
	Write-Host "Generic Exception"
	Write-Host $_
	$_ | Select-Object *
}
