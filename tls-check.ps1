<#	Tls-Check.ps1 - Adam Lewis - May 2023
	
	.SYNOPSIS
	Returns the registry values of a Windows server TLS cipher settings
	Uses Windows credentials
	
	.DESCRIPTION
	Returns the registry values of a Windows server TLS cipher settings
	Uses Windows credentials

    Reads these keys
    
	HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers
	HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols
#>

Write-Host "Cipher and SCHANNEL Protocol checker"
Write-Host .
$server = Read-host "Enter server name"
Write-Host .
$Reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey([Microsoft.Win32.RegistryHive]::LocalMachine,$server)

$Regpath = "SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers"  
$RegSubKey = $Reg.OpenSubKey($Regpath) 
$Values = $RegSubKey.GetSubKeyNames()
foreach ($Subkey in $Values)
{    
    $rpath = $null
    $key = $null
    $Enabled = $null 
    
    $rpath = "$Regpath\$Subkey"
    Try
    {
        $key = $Reg.OpenSubKey($rpath)  
        $t = ""

        $v = "Enabled"        
        $Enabled = $key.GetValue("$v")
        if(($Enabled -eq 0) -or ($Enabled -eq 1)){Write-Host("[$Subkey][$t][$v][$Enabled]")}
    }
    Catch{}
}

$Regpath = "SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols"  
$RegSubKey = $Reg.OpenSubKey($Regpath)   
$Values = $RegSubKey.GetSubKeyNames()
foreach ($Subkey in $Values)
{  
    $rpath = $null
    $key = $null
    $Enabled = $null     
         
    $rpath = "$Regpath\$Subkey\Client"
    Try
    {
        $key = $Reg.OpenSubKey($rpath)  
        $t = "Client"

        $v = "Enabled"        
        $Enabled = $key.GetValue("$v")
        if(($Enabled -eq 0) -or ($Enabled -eq 1)){Write-Host("[$Subkey][$t][$v][$Enabled]")}

        $v = "DisabledByDefault"
        $Enabled = $key.GetValue("$v")
        if(($Enabled -eq 0) -or ($Enabled -eq 1)){Write-Host("[$Subkey][$t][$v][$Enabled]")}
    }
    Catch{}

    $rpath = $null
    $key = $null
    $Enabled = $null  
    
    $rpath = "$Regpath\$Subkey\Server"
    $Exists = (Test-Path $rpath) 
    Try
    {
        $key = $Reg.OpenSubKey($rpath)  
        $t = "Server"

        $v = "Enabled"        
        $Enabled = $null 
        $Enabled = $key.GetValue("$v")
        if(($Enabled -eq 0) -or ($Enabled -eq 1)){Write-Host("[$Subkey][$t][$v][$Enabled]")}

        $v = "DisabledByDefault"
        $Enabled = $null 
        $Enabled = $key.GetValue("$v")
        if(($Enabled -eq 0) -or ($Enabled -eq 1)){Write-Host("[$Subkey][$t][$v][$Enabled]")}
    }
    Catch{}

}