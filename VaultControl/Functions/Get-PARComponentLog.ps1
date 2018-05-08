Function Get-PARComponentLog {
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

	DynamicParam {

		#Create a RuntimeDefinedParameterDictionary
		$Dictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

		if(($Component -eq "ENE") -or ($Component -eq "CVM")) {

			New-DynamicParam -Name LogFile -Type String -ValidateSet "Console", "Trace" -Mandatory -ValueFromPipelineByPropertyName -DPDictionary $Dictionary

		}

		if(($Component -eq "VAULT") -or ($Component -eq "PADR")) {

			New-DynamicParam -Name TimeFrom -Type datetime -ValueFromPipelineByPropertyName -DPDictionary $Dictionary

		}

		if($Component -eq "VAULT") {

			New-DynamicParam -Name Lines -Type Int -ValueFromPipelineByPropertyName -DPDictionary $Dictionary

		}

		$Dictionary

	}

	Begin {

		$PADR = '^\[(\d+\/\d+\/\d+\s+\d+\:\d+\:\d+\.\d+)\]\W+([A-Z]+\d+[A-Z](?:\s))?(.+)$'
		$Vault = '^(\d+\/\d+\/\d+ \d+:\d+:\d+) ([A-Z]+[0-9]+[A-Z]) (.+)$'
		$ENEConsole = '^\[(\d+\/\d+\/\d+\s\W\s\d+\:\d+\:\d+)\]\W+([A-Z]+\d+[A-Z])\s(.+)$'
		$ENETrace = '^\[(\d+\/\d+\/\d+(?:\s\W)\s\d+\:\d+\:\d+)\.\d+\].+\|\s([A-Z]+(?:[A-Z]|\d)[A-Z]\d+[A-Z](?:\s))?(.+)$'

	}

	Process {

		$Command = "GetLog $Component"

		if($PSBoundParameters.ContainsKey("TimeFrom")) {

			$DateStamp = (Get-Date $($PSBoundParameters["TimeFrom"]) -Format ddMMyyyy:HHmm)
			$Command = "$Command /TimeFrom $DateStamp"

		}

		if($PSBoundParameters.ContainsKey("Lines")) {

			$Command = "$Command /Lines $($PSBoundParameters["Lines"])"

		}

		if($PSBoundParameters.ContainsKey("LogFile")) {

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

			"default" {$Pattern = '(.+)'; break}

		}

		$logs = Invoke-PARClient @PSBoundParameters

		($logs.StdOut).Split("`n") | ForEach-Object {

			Write-Debug "LogLine: $_"

			$event = ($_ | Select-String $Pattern -AllMatches)

			if($event -ne $null) {

				[PSCustomObject]@{

					"Time"    = $event.Matches.Groups[1].Value -replace '(\s\W\s)', ' '
					"Code"    = $event.Matches.Groups[2].Value
					"Message" = $event.Matches.Groups[3].Value

				}

			}

		}

	}

}