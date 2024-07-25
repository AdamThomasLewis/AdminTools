<#	BatchInvoke-Command.ps1 - Adam Lewis - May 2023
	
	.SYNOPSIS
	Establish Session and invoke commands on each server in a list
	Uses Windows credentials
	
	.DESCRIPTION
	Reads in a txt file list of server names. 
	Offers to run under different credentials.
	Establishes PsSession and invokes commands on each server in the list
#>

#Specify Target computer list. A text file with one computer name per line.
$TargetServerList = Get-Content .\DCList.txt

#Offer to get alternate credentials or run as current user
Write-Host " Press Y to specify credentials, or any other key to run as $env:UserDomain\$env:UserName."  -BackgroundColor "Black" -Foregroundcolor "Cyan" -NoNewLine
$key = $Host.UI.RawUI.ReadKey()
	Switch ($key.Character) {
		Y {$Confirm = $TRUE}
		default {$Confirm = $FALSE}
	}

if ($Confirm) {
	$Credential = Get-Credential
}

# Establish Session and invoke commands on each server in list.
Foreach ($Server in $TargetServerList){
	If (!($Confirm)){Try {$Session = New-PsSession $Server -ErrorAction SilentlyContinue} Catch {Write-Host "  Unable to connect to $Server as $env:UserDomain\$env:UserName." -ForegroundColor "Yellow"}}
	If ($Confirm){Try {$Session = New-PsSession $Server -Credential $Credential -ErrorAction SilentlyContinue} Catch {Write-Host "  Unable to connect to $Server as $($Credential.UserName)" -ForegroundColor "Yellow"}}
		If ($Session -ne $NUL){
			Write-Host "`n$server" -ForegroundColor Green
			Invoke-Command -Session $Session {
			# Commands to be run on target, one per line
				Set-Service -Name TetSensor -StartupType Disabled
				Set-Service -Name TetEnforcer -StartupType Disabled
				Stop-Service -Name TetSensor
				Stop-Service -Name TetEnforcer
			}
			Remove-PsSession $Session
		} ELSE {Write-Host "  Unable to connect to $Server" -ForegroundColor "Yellow"}
}