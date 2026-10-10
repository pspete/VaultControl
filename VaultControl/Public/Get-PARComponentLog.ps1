# .ExternalHelp VaultControl-help.xml
Function Get-PARComponentLog {
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
		[ValidateSet("Vault", "PADR", "ENE", "CVM")]
		[string]$Component,

		[Parameter(
			Mandatory = $false,
			ValueFromPipelineByPropertyName = $true
		)]
		[ValidateSet("Console", "Trace")]
		[string]$LogFile = "Console",

		[Parameter(
			Mandatory = $false,
			ValueFromPipelineByPropertyName = $true
		)]
		[datetime]$TimeFrom,

		[Parameter(
			Mandatory = $false,
			ValueFromPipelineByPropertyName = $true
		)]
		[int]$Lines
	)

	Begin {

		$PADR = '^\[(\d+\/\d+\/\d+\s+\d+\:\d+\:\d+\.\d+)\]\W+([A-Z]+\d+[A-Z](?:\s))?(.+)$'
		$Vault = '^(\d+\/\d+\/\d+ \d+:\d+:\d+) ([A-Z]+[0-9]+[A-Z]) (.+)$'
		$ENEConsole = '^\[(\d+\/\d+\/\d+\s\W\s\d+\:\d+\:\d+)\]\W+([A-Z]+\d+[A-Z])\s(.+)$'
		$ENETrace = '^\[(\d+\/\d+\/\d+(?:\s\W)\s\d+\:\d+\:\d+)\.\d+\].+\|\s([A-Z]+(?:[A-Z]|\d)[A-Z]\d+[A-Z](?:\s))?(.+)$'

	}

	Process {

		$Command = "GetLog $Component"

		if(($Component -eq "VAULT") -or ($Component -eq "PADR")) {

			if($PSBoundParameters.ContainsKey("TimeFrom")) {

				$DateStamp = (Get-Date $($PSBoundParameters["TimeFrom"]) -Format ddMMyyyy:HHmm)
				$Command = "$Command /TimeFrom $DateStamp"

			}

		}

		if($Component -eq "VAULT") {

			if($PSBoundParameters.ContainsKey("Lines")) {

				$Command = "$Command /Lines $($PSBoundParameters["Lines"])"

			}

		}

		if(($Component -eq "ENE") -or ($Component -eq "CVM")) {

			$Command = "$Command /LogFile $($PSBoundParameters["LogFile"])"

		}

		$PSBoundParameters.Add("CommandParameters", "$Command")

		switch ($Component) {

			"PADR" {$Pattern = $PADR; break}

			"Vault" {$Pattern = $Vault; break}

			"ENE" {

				if ($($PSBoundParameters["LogFile"]) -eq "Console") {

					$Pattern = $ENEConsole; break

				} elseif ($($PSBoundParameters["LogFile"]) -eq "Trace") {

					$Pattern = $ENETrace; break

				}

			}

			default {$Pattern = '(.+)'; break}

		}

		$Result = Invoke-PARClient @PSBoundParameters

		If($Result.StdOut) {

			($Result.StdOut).Split("`n") | ForEach-Object {

				$LogEntry = ($_ | Select-String $Pattern -AllMatches)

				if($LogEntry -match '\S') {

					[PSCustomObject]@{

						"Time"    = $LogEntry.Matches.Groups[1].Value -replace '(\s\W\s)', ' '
						"Code"    = $LogEntry.Matches.Groups[2].Value
						"Message" = $LogEntry.Matches.Groups[3].Value

					} | Add-ObjectDetail -typename VaultControl.Log.Component

				}

			}

		}

	}

}