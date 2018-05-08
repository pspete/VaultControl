Function Get-PARComponentConfig {
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

		$Config = Invoke-PARClient @PSBoundParameters

		If($Config.StdOut -match "=") {

			Try {

				$Value = ($Config.StdOut).Split("=")[1]

			} Catch {$Value = $Config.StdOut}

		} Else {$Value = $Config.StdOut}

		[PSCustomObject]@{

			"Server"    = $Config.Server
			"Component" = $Component
			"Parameter" = $($PSBoundParameters["Parameter"])
			"Value"     = $Value.Trim()

		}

	}

}