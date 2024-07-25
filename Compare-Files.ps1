<#	Compare-Files.ps1 - Adam Lewis - May 2023
	
	.SYNOPSIS
	Compares the contents of two directories
		
	.DESCRIPTION
	Promts for a reference path and a difference path, 
	returns if files are the same, different, or do not exist.
#>
Function Compare-Files {
	$Reference = Read-Host "Reference Path"
	$Difference = Read-Host "Difference Path"
	$ReferenceFiles = gci $Reference

	Write-Host "`n Comparing $Reference to $Difference" -ForegroundColor "Cyan"

	foreach ($File in $ReferenceFiles){
		$Result=$NUL
		Write-Host "`n $($File.Name)" -ForegroundColor "White"
		If (Test-Path ($Difference+"\"+ $File.Name) -Erroraction SilentlyContinue){
			$Result = compare-object -ReferenceObject (Get-content $File.FullName) -DifferenceObject (Get-content ($Difference+"\"+ $File.Name))
			If ($Result) {
				Write-Host "`tFiles are different" -Foregroundcolor "Red"
				$Result | Out-host
			}Else{
				Write-Host "`tFiles are the same" -ForegroundColor "Green"}
		} Else {
			Write-Host "`t$($File.Name) does not exist in $Difference" -ForegroundColor "Yellow"}
	}
}