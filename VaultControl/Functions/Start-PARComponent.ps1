Function Start-PARComponent {
	<#
	.SYNOPSIS
	Starts a component service

	.DESCRIPTION
	Starts a stopped Vault, CVM, PADR or ENE component on a remote server

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
	Start-PARComponent -Server EPV1 -Component Vault

	Starts the Vault service on Vault Server EPV1

	.EXAMPLE
	Start-PARComponent -Server EPV1 -Component PADR

	Starts the PADR service on Vault Server EPV2

	.EXAMPLE
	Start-PARComponent -Server EPV1 -Component ENE

	Starts the ENE service on Vault Server EPV1
	#>
	[CmdletBinding(SupportsShouldProcess)]
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
		[string]$PassFile,

		[Parameter(
			Mandatory = $true,
			ValueFromPipelineByPropertyName = $true
		)]
		[ValidateSet("Vault", "PADR", "ENE", "CVM")]
		[string]$Component
	)

	DynamicParam {

		#Create a RuntimeDefinedParameterDictionary
		$Dictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

		if($Component -eq "VAULT") {

			New-DynamicParam -Name Last -Type switch -ValueFromPipelineByPropertyName -DPDictionary $Dictionary

		}

		$Dictionary

	}

	Process {

		$Command = "Start $Component"

		if($PSBoundParameters.ContainsKey("Last")) {

			$Command = "$Command /Last"

		}

		$PSBoundParameters.Add("CommandParameters", "$Command")

		$Result = Invoke-PARClient @PSBoundParameters

		If($Result.StdOut) {

			Write-Debug "Status: $Result"

			$Service = ($Result.StdOut | Select-String '(started|Error)' -AllMatches)

			[PSCustomObject]@{

				"Server"    = $Result.Server
				"Component" = $Component
				"Status"    = $($Service.Matches.Groups[1].Value).Substring(0, 1).ToUpper() + $($Service.Matches.Groups[1].Value).Substring(1)

			}

		}

	}

}