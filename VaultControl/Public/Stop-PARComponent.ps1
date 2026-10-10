# .ExternalHelp VaultControl-help.xml
Function Stop-PARComponent {
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

			$Service = ($Result.StdOut | Select-String '(stopped|Error)' -AllMatches)

			[PSCustomObject]@{

				"Server"    = $Result.Server
				"Component" = $Component
				"Status"    = $($Service.Matches.Groups[1].Value).Substring(0, 1).ToUpper() + $($Service.Matches.Groups[1].Value).Substring(1)

			}

		}

	}

}