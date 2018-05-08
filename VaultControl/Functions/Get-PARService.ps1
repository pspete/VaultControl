Function Get-PARService {
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
			Mandatory = $false,
			ValueFromPipelineByPropertyName = $true
		)]
		[string]$ServiceName = "*"
	)

	Process {

		$ServiceName = $ServiceName -replace '(.+)', '\"$&\"'

		$PSBoundParameters.Add("CommandParameters", "ServiceStatus /ServiceName $ServiceName")

		$Status = Invoke-PARClient @PSBoundParameters

		($Status.StdOut).Split("`n") | ForEach-Object {

			Write-Debug "ServiceStatus: $_"
			$Service = ($_ | Select-String '^(.+)is\s([a-z]+)' -AllMatches)

			If($Service -ne $null) {

				[PSCustomObject]@{

					"Server"  = $Status.Server
					"Service" = $Service.Matches.Groups[1].Value
					"Status"  = $($Service.Matches.Groups[2].Value).Substring(0, 1).ToUpper() + $($Service.Matches.Groups[2].Value).Substring(1)

				}

			}

		}

	}

}