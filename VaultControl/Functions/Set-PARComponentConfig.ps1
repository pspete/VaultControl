Function Set-PARComponentConfig {
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
		[ValidateScript( {Test-Path $_})]
		[string]$PassFile,

		[Parameter(
			Mandatory = $true,
			ValueFromPipelineByPropertyName = $true
		)]
		[string]$Value

	)

	DynamicParam {

		#Create a RuntimeDefinedParameterDictionary
		$Dictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

		if($Component -eq "VAULT") {

			New-DynamicParam -Name Parameter -Type String -Mandatory -ValueFromPipelineByPropertyName `
				-ValidateSet "DefaultTimeout", "MTU", "SecurityNotification", "DebugLevel", "DisableExceptionHandling" `
				-DPDictionary $Dictionary

			New-DynamicParam -Name Mode -Type String -Mandatory -ValueFromPipelineByPropertyName `
				-ValidateSet "Temporary", "Permanent", "Immediate" -DPDictionary $Dictionary

		}

		if($Component -eq "PADR") {

			New-DynamicParam -Name Parameter -Type String  -ValueFromPipelineByPropertyName `
				-ValidateSet "EnableCheck", "EnableReplicate", "EnableFailover", "EnableDBSync", "FailoverMode" `
				-DPDictionary $Dictionary

			New-DynamicParam -Name Mode -Type String -ValueFromPipelineByPropertyName `
				-ValidateSet "Permanent" -DPDictionary $Dictionary

		}

		$Dictionary

	}

	Process {

		$PSBoundParameters.Add("CommandParameters", "SetParm $Component $($PSBoundParameters["Parameter"])=$Value /$($PSBoundParameters["Mode"])")

		$status = Invoke-PARClient @PSBoundParameters
		#Write-Output $status.StdOut
		$Update = ($Status.StdOut | Select-String '(success|Error)' -AllMatches)
		[PSCustomObject]@{

			"Server"    = $Status.Server
			"Component" = "Component"
			"Parameter" = $($PSBoundParameters["Parameter"])
			"Value"     = $Value
			"Mode"      = $($PSBoundParameters["Mode"])
			"Status"    = $($Update.Matches.Groups[1].Value).Substring(0, 1).ToUpper() + $($Update.Matches.Groups[1].Value).Substring(1)
			"Message"   = $status.StdOut

		}

	}

}