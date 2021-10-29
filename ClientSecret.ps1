[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string]
    $IdentityServerClientId,
    [Parameter(Mandatory=$true)]
    [string]
    $IdentityServerClientSecret,
    [Parameter(Mandatory=$true)]
    [string]
    $IdentityServerUrl,
    [Parameter(Mandatory=$true)]
    [string]
    $ClientId,
    [Parameter(Mandatory=$true)]
    [string]
    $Secret
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$here = Split-Path -Parent $MyInvocation.MyCommand.Path

. $here\_IdentityServerCommon.ps1




if ($Secret.length -lt 50) {
    throw "A secret must be at least 50 characters"
}

$secretType = "SharedSecret"

$name = "$($OctopusEnvironmentName.ToUpper()) $ClientId";

Write-Host "Running ClientSecret.ps1:"
Write-Host "Name: $name"

$accessToken = GetAccesToken $IdentityServerUrl $IdentityServerClientId $IdentityServerClientSecret 

$clientSecret = @{ClientId = $clientId; Value = $Secret; Type = $secretType; }

$requestJson = $clientSecret | ConvertTo-Json -Compress

#Write-Host $requestJson
Write-Host "requestJson not displayed - contains sensitive data"


Write-Host "Creating ClientSecret:"   
CreateClientSecret $IdentityServerUrl $requestJson $accessToken

Write-Host "Done"

