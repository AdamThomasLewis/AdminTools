<# Get-ConsoleColors.ps1 June 2021 by Adam Lewis
	Displays foreground / background color combos on the console screen
		Employs:
			User input (Read-Host)
			Function with 2 paramaters
			[math]::floor function to round down to the nearest whole number
			use of system console settings ([enum]::GetValues([System.ConsoleColor])
			use of User Interface settings ($Host.UI.RawUI.BackgroundColor, $Host.UI.RawUI.WindowSize.Width)
			String padding and concatenation
#>
 Function Get-ConsoleColors {
		Clear-Host
		$Background = ""
		$Foreground = ""
		$ConsoleWidth = $Host.UI.RawUI.WindowSize.Width
		
	Function Write-Color {param ($Background,$Foreground)
		IF (!($Background -eq $Foreground)){
			$ColorString = "$($Foreground.ToUpper())   on   $($Background.ToUpper())"
			$ConsoleWidth = ($Host.UI.RawUI.WindowSize.Width)
			$Pad = [math]::floor([decimal]($ConsoleWidth/2)+($ColorString.Length/2))
			$ColorString = "***$($($Colorstring.PadLeft($Pad)))"
			$ColorString = "$($($Colorstring.PadRight($ConsoleWidth-3)))***"
			Write-Host "$ColorString" -BackgroundColor $Background -ForegroundColor $Foreground -NoNewLine
		}
	}
	
		Write-Host "`n
		**************************************************************************************`
		***                            Get-ConsoleColors.ps1                               ***`
		***         Displays foreground / background colors on the console screen          ***`
		***          Restrict to forground / background pairs or see all combos            ***`
		**************************************************************************************`
		`n" -ForegroundColor "White" -BackgroundColor "DarkCyan"
		
			foreach ($color in ([enum]::GetValues([System.ConsoleColor]))){
				$BackColor = $Host.UI.RawUI.BackgroundColor
				If ($Host.UI.RawUI.BackgroundColor -eq $color){$BackColor = ($Host.UI.RawUI.BackgroundColor.value + 1)}
				Write-Host "  $Color  " -ForegroundColor $Color -BackgroundColor $BackColor -NoNewLine
			}
			
			Write-Host "`n"
			$Background = Read-Host " Name of Background Color to restrict to [Enter For all]"
			$Foreground = Read-Host " Name of Foreground Color to restrict to [Enter For all]"
			$List = [enum]::GetValues([System.ConsoleColor]) 
			
			IF (($Background) -and ($Foreground)){Write-Color $Background $Foreground}
			IF (($Background) -and !($Foreground))	{ForEach ($Foreground in $List){Write-Color $Background $($Foreground.ToString())}}							
			IF (!($Background) -and ($Foreground))	{ForEach ($Background in $List){Write-Color $([string]$Background.ToString()) $Foreground}}
			IF (!($Background) -and !($Foreground))	{ForEach ($Background in $List)
														{ForEach ($Foreground in $List){Write-Color $Background.ToString() $Foreground.ToString()}}
													}
 }

	
