Function Get-PARServerLog {
	<#
	.SYNOPSIS
	Returns events from Server Event Logs

	.DESCRIPTION
	Queries remote vault server and returns events from specified OS Logs.

	.PARAMETER Server
	The name or address of the remote Vault server to target with PARClient

	.PARAMETER Password
	The password for remote operations via PARClient as a secure string

	.PARAMETER Credential
	The password for remote operations via PARClient held in a credential object

	.PARAMETER PassFile
	The path to a "password" file created by PARClient.exe, containing the encrypted password value used for remote
	operations via PARClient

	.PARAMETER LogName
	The name of the event log to return events from.
	Application, Security & System are the accepted values.

	.PARAMETER TimeFrom
	A date time to return events from.

	.EXAMPLE
	Get-PARServerLog -Server EPV1 -Credential $Cred -LogName Application

	Get events from Application log on vault EPV1

	.EXAMPLE
	Get-PARServerLog -Server zEPV1 -Credential $Cred -LogName System -TimeFrom (Get-Date 5/5/2018)

	Get all events from the System log since Cinco de Mayo 2018 on vault EPV1
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
		[datetime]$TimeFrom #= (Get-Date (Get-Date).AddMinutes(-10) -Format ddMMyyyy:HHmm)
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

		$Result = Invoke-PARClient @PSBoundParameters

		If($Result.StdOut) {

			$Logs = $Result.StdOut | Select-String $Pattern -AllMatches

			$Logs.Matches | ForEach-Object {

				[PSCustomObject]@{

					"EventLogRecordTime" = ($_.Groups[1].Value).Trim()
					"Source"             = ($_.Groups[2].Value).Trim()
					"Computer"           = ($_.Groups[3].Value).Trim()
					"EventID"            = ($_.Groups[4].Value).Trim()
					"EventType"          = ($_.Groups[5].Value).Trim()
					"Description"        = ($_.Groups[6].Value).Trim()

				} | Add-ObjectDetail -typename VaultControl.Log.Server

			}

		}

	}

}