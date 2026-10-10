# .ExternalHelp VaultControl-help.xml
Function Get-PARServerLog {
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
		[ValidateScript( {Test-Path $_ -PathType Leaf})]
		[string]$PassFile,

		[Parameter(
			Mandatory = $true,
			ValueFromPipelineByPropertyName = $true
		)]
		[ValidateSet("Application", "Security", "System")]
		[string]$LogName,

		[Parameter(
			Mandatory = $false,
			ValueFromPipelineByPropertyName = $true
		)]
		[datetime]$TimeFrom = (Get-Date).AddDays(-1)
	)

	Begin {

		$Pattern = 'EventLogRecordTime:(.+\s)Source:(.+\s)Computer:(.+\s)Event ID:(.+\s)Event Type:(.+\s)Description:(.+(?:[\S\s]+?))(?=\Z|EventLogRecordTime)'

	}
	Process {

		$Command = "GetOSLog /Name $LogName /TimeFrom $(Get-Date $TimeFrom -Format ddMMyyyy:HHmm)"

		$PSBoundParameters.Add("CommandParameters", "$Command")

		$Result = Invoke-PARClient @PSBoundParameters

		If($Result.StdOut) {

			$Logs = $Result.StdOut -replace '(?m)^PARAgent version:.*(\r?\n)?', '' | Select-String $Pattern -AllMatches

			$Logs | Select-Object -ExpandProperty Matches | ForEach-Object {

				[PSCustomObject]@{

					"EventLogRecordTime" = ($_.Groups[1].Value).Trim()
					"Source"             = ($_.Groups[2].Value).Trim()
					"Computer"           = ($_.Groups[3].Value).Trim()
					"EventID"            = [int]([int64](($_.Groups[4].Value).Trim()) -band 0xFFFF)
					"EventType"          = ($_.Groups[5].Value).Trim()
					"Description"        = ($_.Groups[6].Value).Trim()

				} | Add-ObjectDetail -typename VaultControl.Log.Server

			}

		}

	}

}