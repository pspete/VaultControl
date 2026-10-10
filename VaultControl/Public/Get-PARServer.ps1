# .ExternalHelp VaultControl-help.xml
Function Get-PARServer {
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
		[string]$PassFile

	)

	Process {

		Try {

			$ErrorActionPreference = "Stop"

			$PSBoundParameters["CommandParameters"] = "GetCPU"

			$CPU = Invoke-PARClient @PSBoundParameters

			$PSBoundParameters["CommandParameters"] = "GetDiskUsage"

			$Disk = Invoke-PARClient @PSBoundParameters

			$PSBoundParameters["CommandParameters"] = "GetMemoryUsage"

			$Memory = Invoke-PARClient @PSBoundParameters

			$PSBoundParameters["CommandParameters"] = "List"

			$Components = Invoke-PARClient @PSBoundParameters

			#Remove PARAgent version header line
			$CPU, $Disk, $Memory, $Components = $CPU, $Disk, $Memory, $Components | ForEach-Object {

				$_.StdOut -replace '(?m)^PARAgent version:.*(\r?\n)?', ''

			}

			If($CPU) {

				$CPU = ($CPU  | Select-String '(\d+\.\d+)' -AllMatches).Matches.Value

			}

			Else {$CPU = $null}

			If($Disk) {

				$Disk = $Disk | Select-String '(.+)' -AllMatches | ForEach-Object {

					$DiskInfo = $_.Line.Split(" ")

					For ($i = 0 ; $i -lt $DiskInfo.count ; $i += 3) {

						$Drive = $DiskInfo[$i..($i + 3)]

						[PSCustomObject]@{

							"Drive"         = $Drive[0]
							"FreeSpace(MB)" = ($Drive[1] | Select-String '(\d+)' -AllMatches).Matches.Value
							"FreeSpace(%)"  = ($Drive[2] | Select-String '(\d+\.\d+)' -AllMatches).Matches.Value

						}

					}

				}

			} Else {$Disk = $null}

			If($Memory) {

				$Memory = ($Memory | Select-String '(.+)' -AllMatches).Matches.Value | ForEach-Object {

					$MemoryInfo = $_.Split(":")

					$MemoryData = ($MemoryInfo[1] | Select-String '(\S+)' -AllMatches).Matches.Value

					[PSCustomObject]@{

						"MemoryType" = ($MemoryInfo[0].Split(" "))[0]
						"Total(K)"   = (($MemoryData[0]).Split("=")[1] |  Select-String '(\d+)' -AllMatches).Matches.Value
						"Free(K)"    = (($MemoryData[1]).Split("=")[1] |  Select-String '(\d+)' -AllMatches).Matches.Value
						"Used(%)"    = (($MemoryData[2]).Split("=")[1] | Select-String '(\d+\.\d+)' -AllMatches).Matches.Value

					}

				}

			}

			Else {$Memory = $null}

			If($Components) {

				$Components = ($Components | Select-String '(.+)' -AllMatches).Matches.Value | ForEach-Object {

					$Component = $_.Split(" ")

					$Version = ($_ | Select-String "(\d+\D\d+\D\d+\D\d+)" -AllMatches).Matches.Value

					[PSCustomObject]@{

						Component = $Component[0]
						Version   = $Version

					}

				}

			}

			Else {$Components = $null}

			[PSCustomObject]@{

				"Server"     = $Server.ToUpper()
				"CPU(%)"     = $CPU
				"Disk"       = $Disk
				"Memory"     = $Memory
				"Components" = $Components

			}

		} Catch {throw $_}

	}

}