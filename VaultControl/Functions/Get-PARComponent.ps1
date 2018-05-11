Function Get-PARComponent {
	<#
	.SYNOPSIS
	Queries the status of a component running on a remote vault server

	.DESCRIPTION
	Gets status of remote Vault, PADR, CVM or ENE component

	.PARAMETER Server
	The name or address of the remote Vault server to target with PARClient

	.PARAMETER Password
	The password for remote operations via PARClient as a secure string

	.PARAMETER Credential
	The password for remote operations via PARClient held in a credential object

	.PARAMETER PassFile
	The path to a "password" file created by PARClient.exe, containing the encrypted password value used for remote
	operations via PARClient

	.PARAMETER Component
	The name of the component to query. Vault, PADR, CVM or ENE are the accepted values

	.EXAMPLE
	Get-PARComponent -Server 10.10.10.10 -Password $SecureString -Component Vault

	Returns status of Vault service on remote vault with address 10.10.10.10

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
		[ValidateScript( {Test-Path $_})]
		[string]$PassFile,

		[Parameter(
			Mandatory = $true,
			ValueFromPipelineByPropertyName = $true
		)]
		[ValidateSet("Vault", "PADR", "ENE", "CVM")]
		[string]$Component
	)

	Process {

		$PSBoundParameters.Add("CommandParameters", "Status $Component")

		$Result = Invoke-PARClient @PSBoundParameters

		If($Result.StdOut) {

			switch -regex ($Result.StdOut) {

				'running' {$Status = "Running"; break}
				'starting' {$Status = "Starting"; break}
				'stopped' {$Status = "Stopped"; break}
				"default" {$Status = $Result.StdOut; break}

			}

			[PSCustomObject]@{

				"Server"    = $Result.Server
				"Component" = $Component
				"Status"    = $Status

			}

		}

	}

}