<# Test-URL.ps1 February 2022 by Adam Lewis

.SYNOPSIS
	Tests URL availability either interactively or from a csv list.

.DESCRIPTION
	Tests URL availability either interactively or from a csv list.
	Prompts for user credentials for authenticated sessions.
		
#>
Write-Host "Test-URL loaded" -ForegroundColor "Green"

Function URLTest ($URL,$Creds){
	$ERROR.clear()
	try
	{
		$Request = Invoke-WebRequest -Uri $URL -Credential $Creds -Method HEAD
		# This will only execute if the Invoke-WebRequest is successful.
		$Result = $Request
	}
	catch
	{
		IF ($ERROR){$Result = $Error[0].ToString()}
	}
	Return $Result
}

Function Test-URL {
	$User = Read-host " Credentials to use or press enter for current user $env:UserDomain\$env:UserName"
	IF (!($User)){$User = "$env:UserDomain\$env:UserName"}
	$Creds = Get-Credential -User $User
	$Valid = $False
	
	Write-Host "[S]ingle URL or [B]atch from CSV?"  -Foregroundcolor "White"
	WHILE (!($Valid)){
		Write-Host "`tPress S or B >"  -Foregroundcolor "White" -NoNewLine
		$key = $Host.UI.RawUI.ReadKey()
		$Selection = ($key.Character.ToString())
		
		IF ($Selection -eq "S"){
				Write-Host " "
				$URL = Read-Host "`tEnter URL"
				Write-Host "`n $URL" -ForegroundColor "DARKMAGENTA"
				$results = URLTest $URL $Creds
				If ($Results.GetType().Name -eq "BasicHtmlWebResponseObject"){
					Write-Host "`tSuccess: Status Code = $($Results.StatusCode)" -foregroundcolor "Green"
				}
				Else{ Write-Host "`tFailure: $Results" -Foregroundcolor "Red"}
				$Valid = $True
		}
		ELSEIF ($Selection -eq "B"){
			
			Write-Host " "
			Write-Host " Full Path to CSV file" -Foregroundcolor "White"
			$InputFile = Read-Host
			$URLs = Import-CSV $InputFile
			Write-Host " Full Path to output file. Default is .\Test-URL.txt"  -Foregroundcolor "White"
			$OutputFile = Read-Host
			IF (!($Outputfile)){$Outputfile = ".\Test-URL.txt"}
			ForEach ($URL in $URLs){
			Write-Host "`n $($URL.URL)" -ForegroundColor "DARKMAGENTA"
				$results = URLTest $URL.URL $Creds
				If ($Results.GetType().Name -eq "BasicHtmlWebResponseObject"){
					Write-Host "`tSuccess: Status Code = $($Results.StatusCode)" -foregroundcolor "Green"
				}
				Else{ Write-Host "`tFailure: $Results" -Foregroundcolor "Red"
					Add-Content -Path $OutputFile -Value $URL.URL}
			}
			$Valid = $True
		}
		ELSE {Write-Host " Invalid input. Try again." -ForegroundColor "Yellow"}
	}
}
