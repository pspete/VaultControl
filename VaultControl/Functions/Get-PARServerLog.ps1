Function Get-PARServerLog {
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
		[ValidateSet("Application", "Security", "System")]
		[string]$LogName,

		[Parameter(
			Mandatory = $false,
			ValueFromPipelineByPropertyName = $true
		)]
		[datetime]$TimeFrom = (Get-Date (Get-Date).AddMinutes(-10) -Format ddMMyyyy:HHmm)
	)

	Begin {

		$Pattern = 'EventLogRecordTime:(.+\s)Source:(.+\s)Computer:(.+\s)Event ID:(.+\s)Event Type:(.+\s)Description:(.+(?:[\S\s]+?))(?=\Z|EventLogRecordTime)'

	}
	Process {

		$Command = "GetOSLog /Name $LogName"

		if($PSBoundParameters.ContainsKey("TimeFrom")) {

			$DateStamp = (Get-Date $($PSBoundParameters["TimeFrom"]) -Format ddMMyyyy:HHmm)
			$Command = "$Command /TimeFrom $DateStamp"

		}

		$PSBoundParameters.Add("CommandParameters", "$Command")

		$OSLogs = Invoke-PARClient @PSBoundParameters


		$Logs = $OSLogs.StdOut | Select-String $Pattern -AllMatches

		$Logs.Matches | ForEach-Object {

			Write-Debug "Event: $($_.Groups[0].Value)"

			[PSCustomObject]@{
				"EventLogRecordTime" = ($_.Groups[1].Value).Trim()
				"Source"             = ($_.Groups[2].Value).Trim()
				"Computer"           = ($_.Groups[3].Value).Trim()
				"EventID"            = ($_.Groups[4].Value).Trim()
				"EventType"          = ($_.Groups[5].Value).Trim()
				"Description"        = ($_.Groups[6].Value).Trim()
			}

		}

	}

}