Function Get-PARService {
	<#
	.SYNOPSIS
	Gets status of Operating System Services on Vault Server.

	.DESCRIPTION
	For services listed as allowed to be monitored with PARClient, returns the running status of the service.
	By default returns the status of all monitored services.

	.PARAMETER Server
	The name or address of the remote Vault server to target with PARClient

	.PARAMETER Password
	The password for remote operations via PARClient as a secure string

	.PARAMETER Credential
	The password for remote operations via PARClient held in a credential object

	.PARAMETER PassFile
	The path to a "password" file created by PARClient.exe, containing the encrypted password value used for remote
	operations via PARClient

	.PARAMETER ServiceName
	The service to return the status of

	.EXAMPLE
	Get-PARService -Server EPV1 -Password $SecureString

	Returns details of all monitored services

	.EXAMPLE
	Get-PARService -Server EPV1 -Password $SecureString -ServiceName "PrivateArk Database"

	Returns details of PrivateArk Database service
	#>
	[CmdletBinding()]
	Param(
		[Parameter(
			Mandatory = $true,
			ValueFromPipelineByPropertyName = $true
		)]
		[string]$Server,

		[Parameter(
			Mandatory = $true,
			ValueFromPipelineByPropertyName = $true,
			ParameterSetName = "Password"
		)]
		[securestring]$Password,

		[Parameter(
			Mandatory = $true,
			ValueFromPipelineByPropertyName = $true,
			ParameterSetName = "Credential"
		)]
		[pscredential]$Credential,

		[Parameter(
			Mandatory = $True,
			ValueFromPipelineByPropertyName = $True,
			ParameterSetName = "PassFile"
		)]
		[ValidateScript( {Test-Path $_ -PathType Leaf})]
		[string]$PassFile,

		[Parameter(
			Mandatory = $false,
			ValueFromPipelineByPropertyName = $true
		)]
		[string]$ServiceName = "*"
	)

	Process {

		$ServiceName = $ServiceName -replace '(.+)', '\"$&\"'

		$PSBoundParameters.Add("CommandParameters", "ServiceStatus /ServiceName $ServiceName")

		$Result = Invoke-PARClient @PSBoundParameters

		If($Result.StdOut) {

			($Result.StdOut).Split("`n") | ForEach-Object {

				Write-Debug "ServiceStatus: $_"
				$Service = ($_ | Select-String '^(.+)is\s([a-z]+)' -AllMatches)

				If($Service -match '\S') {

					[PSCustomObject]@{

						"Server"  = $Result.Server
						"Service" = $Service.Matches.Groups[1].Value
						"Status"  = $($Service.Matches.Groups[2].Value).Substring(0, 1).ToUpper() + $($Service.Matches.Groups[2].Value).Substring(1)

					}

				}

			}

		}

	}

}