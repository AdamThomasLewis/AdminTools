<#	Check-Port.ps1 - Adam Lewis - May 2023
	
	.SYNOPSIS
	Tests if a server is listening on a port
		
	.DESCRIPTION
	Uses the Net.Sockets.TcpClient object
    Quicker than Test-NetConnection
    
    .EXAMPLE  Test-Ports -serverName SERVERNAME -ports 3389

#>

#Get server FQDN
function Get-DNSName
{
    param ( [string]$Hostname)
	$DNSname = Resolve-DnsName $HostName -ErrorAction SilentlyContinue
    if ($DNSname.name -eq $null) {$DNSname = Resolve-DnsName "$HostName.amnat.pub" -ErrorAction SilentlyContinue}
    return $DNSname
}

#check ports function
function Test-Ports
{
    param($serverName, $ports)
    $computer = (Get-DNSName -hostname $serverName).Name
    $Milliseconds = 300

    IF($computer)
    {
        foreach($port in $ports)
        {
            #  Initialize object
            $Test = New-Object -TypeName Net.Sockets.TcpClient
            #  Attempt connection, timeout, returns boolean
            $portTest = ( $Test.BeginConnect( $computer, $port, $Null, $Null ) ).AsyncWaitHandle.WaitOne( $Milliseconds )
            # Cleanup
            $Test.Close()

            $portObject += [PSCustomObject]@{
                Server = $computer
                Port = $Port
                Open = $portTest
            }
        }
        return $portObject
    }
    Else
    {
        return "Could not connect to $serverName"
    }
}