<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2016 v5.2.128
	 Created on:   	11/13/2017 10:16 AM
	 Created by:   	Developer
	 Organization: 	
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>

param (
	[parameter(
		Mandatory = $true
	)]
	[int]$port,
	[parameter(
		Mandatory = $false
	)]
	[string]$delay = 1000,
	[parameter(
		Mandatory = $false
	)]
	[string]$buffer = 4096
)

$listener = [System.Net.Sockets.TcpListener]$port
$listener.start()

while ($true)
{
	[byte[]]$chunk = New-Object byte[] $buffer
	$client = $listener.AcceptTcpClient()
	if ($client -ne $Null)
	{
		$stream = $client.GetStream()
	}
	Do
	{
		#Write-Host 'Processing Data'
		Write-Verbose ("Bytes Left: {0}" -f $client.Available)
		$Return = $stream.Read($chunk, 0, $chunk.Length)
		#$String += [text.Encoding]::Ascii.GetString($byte[0..($Return - 1)])
		add-content -encoding byte -path outfile.txt -value $chunk
		
	}
	While ($stream.DataAvailable)
}


#overwrite
#set-content -value $x -encoding byte -path outfile.exe

#append

