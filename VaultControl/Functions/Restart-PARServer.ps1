Function Restart-PARServer {
	<#
	.SYNOPSIS
	Reboots a remote Vault Server

	.DESCRIPTION
	Initiates a reboot of a remote vault server

	.PARAMETER Server
	The name or address of the remote Vault server to target with PARClient

	.PARAMETER Password
	The password for remote operations via PARClient as a secure string

	.PARAMETER Credential
	The password for remote operations via PARClient held in a credential object

	.PARAMETER PassFile
	The path to a "password" file created by PARClient.exe, containing the encrypted password value used for remote
	operations via PARClient

	.EXAMPLE
	Restart-PARServer -Server EPV1 -Password $SecureString

	Initiates Reboot of EPV1
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification = "ShouldProcess handling is in Invoke-PARClient")]
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
		[string]$PassFile

	)

	Process {

		$PSBoundParameters.Add("CommandParameters", "REBOOT")

		$Result = Invoke-PARClient @PSBoundParameters

		If($Result.StdOut) {

			[PSCustomObject]@{

				"Server" = $Result.Server
				"Status" = $Result.StdOut

			}

		}

	}

}