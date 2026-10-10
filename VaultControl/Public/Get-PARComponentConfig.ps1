# .ExternalHelp VaultControl-help.xml
Function Get-PARComponentConfig {
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
		[string]$PassFile,

		[Parameter(
			Mandatory = $true,
			ValueFromPipelineByPropertyName = $true
		)]
		[ValidateSet("Vault", "PADR")]
		[string]$Component,

		[Parameter(
			Mandatory = $true,
			ValueFromPipelineByPropertyName = $true
		)]
		[ValidateSet("DefaultTimeout", "MTU", "SecurityNotification", "DebugLevel", "DisableExceptionHandling",
			"EnableCheck", "EnableReplicate", "EnableFailover", "EnableDBSync", "FailoverMode")]
		[string]$Parameter

	)

	Begin {
		$VaultSet = "DefaultTimeout", "MTU", "SecurityNotification", "DebugLevel", "DisableExceptionHandling"
		$PADRSet = "EnableCheck", "EnableReplicate", "EnableFailover", "EnableDBSync", "FailoverMode"
	}
	Process {

		Switch($Component) {
			"Vault" {
				If($VaultSet -notcontains $Parameter) {throw "Not a valid DBPARM.ini Parameter"}
			}
			"PADR" {
				If($PADRSet -notcontains $Parameter) {throw "Not a valid PADR.ini Parameter"}
			}
		}

		$PSBoundParameters.Add("CommandParameters", "GetParm $Component $($PSBoundParameters["Parameter"])")

		$Result = Invoke-PARClient @PSBoundParameters

		If($Result.StdOut) {

			If($Result.StdOut -match "=") {

				$Value = ($Result.StdOut).Split("=")[1]

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