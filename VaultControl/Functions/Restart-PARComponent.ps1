Function Restart-PARComponent {
	<#
	.SYNOPSIS
	Restarts a Vault or PADR Component

	.DESCRIPTION
	Issues a restart command to a remote Vault or DR Vault component

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
	The name of the component to restart. Vault or PADR are the accepted values

	.EXAMPLE
	Restart-PARComponent -Server EPV1 -Credential $cred -Component Vault

	Restarts the Vault service on Server EPV1

	.EXAMPLE
	Restart-PARComponent -Server EPV2 -PassFile C:\PassFile.pass -Component PADR

	Restarts the PADR service on Server EPV2, using encrypted password contained in C:\PassFile.pass
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
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
		[ValidateScript( {Test-Path $_ -PathType Leaf})]
		[string]$PassFile,

		[Parameter(
			Mandatory = $true,
			ValueFromPipelineByPropertyName = $true
		)]
		[ValidateSet("Vault", "PADR")]
		[string]$Component
	)

	Process {

		$PSBoundParameters.Add("CommandParameters", "Restart $Component")

		$Result = Invoke-PARClient @PSBoundParameters

		If($Result.StdOut) {

			Write-Debug "Status: $($Result.StdOut)"

			$Service = ($Result.StdOut | Select-String '(restarted|Error)' -AllMatches)

			[PSCustomObject]@{

				"Server"    = $Result.Server
				"Component" = $Component
				"Status"    = $($Service.Matches.Groups[1].Value).Substring(0, 1).ToUpper() + $($Service.Matches.Groups[1].Value).Substring(1)

			}

		}

	}

}