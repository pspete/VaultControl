Function Start-PARComponent {
	<#

	#>
	[CmdletBinding(SupportsShouldProcess)]
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

		$Status = Invoke-PARClient @PSBoundParameters

		Write-Debug "Status: $Status"
		$Service = ($Status.StdOut | Select-String '(started|Error)' -AllMatches)

		[PSCustomObject]@{

			"Server"    = $Status.Server
			"Component" = $Component
			"Status"    = $($Service.Matches.Groups[1].Value).Substring(0, 1).ToUpper() + $($Service.Matches.Groups[1].Value).Substring(1)

		}

	}

}