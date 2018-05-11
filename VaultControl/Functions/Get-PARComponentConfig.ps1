Function Get-PARComponentConfig {
	<#
	.SYNOPSIS
	Gets values set in component configuration files

	.DESCRIPTION
	Queries remote vault server for values contained in component configuration files DBPARM.ini or PADR.ini.

	DYNAMICPARAMETER Parameter
	The name of the Parameter to get the value of.
	For Vault Components, the parameter names accepted are:
	"DefaultTimeout", "MTU", "SecurityNotification", "DebugLevel", "DisableExceptionHandling"
	For Disaster Recovery Components, the parameter names accepted are:
	"EnableCheck", "EnableReplicate", "EnableFailover", "EnableDBSync", "FailoverMode"

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
	The name of the component to query. Vault or PADR are the accepted values

	.EXAMPLE
	Get-PARComponentConfig -Server EPV1 -Credential $credential -Component Vault -Parameter DebugLevel

	Returns the DebugLevel parameter value configured in the dbparm.ini file on vault server EPV1
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
		[ValidateSet("Vault", "PADR")]
		[string]$Component

	)

	DynamicParam {

		#Create a RuntimeDefinedParameterDictionary
		$Dictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

		if($Component -eq "VAULT") {

			New-DynamicParam -Name Parameter -Type String -Mandatory -ValueFromPipelineByPropertyName `
				-ValidateSet "DefaultTimeout", "MTU", "SecurityNotification", "DebugLevel", "DisableExceptionHandling" `
				-DPDictionary $Dictionary

		}

		if($Component -eq "PADR") {

			New-DynamicParam -Name Parameter -Type String -Mandatory -ValueFromPipelineByPropertyName `
				-ValidateSet "EnableCheck", "EnableReplicate", "EnableFailover", "EnableDBSync", "FailoverMode" `
				-DPDictionary $Dictionary

		}

		$Dictionary

	}

	Process {

		$PSBoundParameters.Add("CommandParameters", "GetParm $Component $($PSBoundParameters["Parameter"])")

		$Result = Invoke-PARClient @PSBoundParameters

		If($Result.StdOut) {

			If($Result.StdOut -match "=") {

				Try {

					$Value = ($Result.StdOut).Split("=")[1]

				} Catch {$Value = $Result.StdOut}

			} Else {$Value = $Result.StdOut}

			[PSCustomObject]@{

				"Server"    = $Result.Server
				"Component" = $Component
				"Parameter" = $($PSBoundParameters["Parameter"])
				"Value"     = $Value.Trim()

			}

		}

	}

}