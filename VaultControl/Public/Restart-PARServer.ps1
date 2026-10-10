# .ExternalHelp VaultControl-help.xml
Function Restart-PARServer {
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
		[ValidateScript( {Test-Path $_ -PathType Leaf})]
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