# .ExternalHelp VaultControl-help.xml
Function Set-PARComponentConfig {
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
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
			Mandatory = $true,
			ValueFromPipelineByPropertyName = $true
		)]
		[ValidateSet("Vault", "PADR")]
		[string]$Component,

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
		[ValidateSet("DefaultTimeout", "MTU", "SecurityNotification", "DebugLevel", "DisableExceptionHandling",
			"EnableCheck", "EnableReplicate", "EnableFailover", "EnableDBSync", "FailoverMode")]
		[string]$Parameter,

		[Parameter(
			Mandatory = $true,
			ValueFromPipelineByPropertyName = $true
		)]
		[string]$Value,

		[Parameter(
			Mandatory = $true,
			ValueFromPipelineByPropertyName = $true
		)]
		[ValidateSet("Temporary", "Permanent", "Immediate")]
		[string]$Mode

	)

	Process {

		$PSBoundParameters.Add("CommandParameters", "SetParm $Component $Parameter=$Value /$Mode")

		$Result = Invoke-PARClient @PSBoundParameters

		If($Result.StdOut) {

			$Update = ($Result.StdOut | Select-String '(success|Error)' -AllMatches)

			[PSCustomObject]@{

				"Server"    = $Result.Server
				"Component" = $Component
				"Parameter" = $($PSBoundParameters["Parameter"])
				"Value"     = $Value
				"Mode"      = $($PSBoundParameters["Mode"])
				"Status"    = $($Update.Matches.Groups[1].Value).Substring(0, 1).ToUpper() + $($Update.Matches.Groups[1].Value).Substring(1)
				"Message"   = $Result.StdOut

			}

		}

	}

}