Function Stop-PARComponent {
	<#
	.SYNOPSIS
	Stops a component service

	.DESCRIPTION
	Stops a running Vault, CVM, PADR or ENE component on a remote server

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
	The name of the component to query. Vault, PADR, CVM or ENE are the accepted values.

	.PARAMETER ShutdownMode
	Specify "Normal", "Immediate" or "Terminate" shutdown mode for stop operation against Vault service.

	.EXAMPLE
	Stop-PARComponent -Server EPV1 -Component Vault

	Stops the Vault service on Vault Server EPV1

	.EXAMPLE
	Stop-PARComponent -Server EPV1 -Component PADR

	Stops the PADR service on Vault Server EPV2

	.EXAMPLE
	Stop-PARComponent -Server EPV1 -Component ENE

	Stops the ENE service on Vault Server EPV1
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
		[string]$PassFile,

		[Parameter(
			Mandatory = $true,
			ValueFromPipelineByPropertyName = $true
		)]
		[ValidateSet("Vault", "PADR", "ENE", "CVM")]
		[string]$Component,

		[Parameter(
			Mandatory = $false,
			ValueFromPipelineByPropertyName = $true
		)]
		[ValidateSet("Normal", "Immediate", "Terminate")]
		[string]$ShutdownMode
	)

	Process {

		$Command = "Stop $Component"

		If($Component -eq "Vault") {

			if($PSBoundParameters.ContainsKey("ShutdownMode")) {

				$Command = "$Command /$($PSBoundParameters["ShutdownMode"])"

			}

		}

		$PSBoundParameters.Add("CommandParameters", "$Command")

		$Result = Invoke-PARClient @PSBoundParameters

		If($Result.StdOut) {

			Write-Debug "Status: $Result"
			$Service = ($Result.StdOut | Select-String '(stopped|Error)' -AllMatches)

			[PSCustomObject]@{

				"Server"    = $Result.Server
				"Component" = $Component
				"Status"    = $($Service.Matches.Groups[1].Value).Substring(0, 1).ToUpper() + $($Service.Matches.Groups[1].Value).Substring(1)

			}

		}

	}

}