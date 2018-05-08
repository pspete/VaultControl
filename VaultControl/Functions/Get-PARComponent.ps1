Function Get-PARComponent {
	<#

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