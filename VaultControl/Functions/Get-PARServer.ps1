Function Get-PARServer {
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
		[string]$PassFile

	)

	Process {

		$PSBoundParameters["CommandParameters"] = "GetCPU"

		$CPU = Invoke-PARClient @PSBoundParameters

		$PSBoundParameters["CommandParameters"] = "GetDiskUsage"

		$Disk = Invoke-PARClient @PSBoundParameters

		$PSBoundParameters["CommandParameters"] = "GetMemoryUsage"

		$Memory = Invoke-PARClient @PSBoundParameters

		$PSBoundParameters["CommandParameters"] = "List"

		$Components = Invoke-PARClient @PSBoundParameters

		$CPU = ($CPU.StdOut  | Select-String '(\d+\.\d+)' -AllMatches).Matches.Value

		$Disk = $Disk.StdOut | Select-String '(.+)' -AllMatches | ForEach-Object {
			$DiskInfo = $_.Line.Split(" ")
			[PSCustomObject]@{
				"Drive"     = $DiskInfo[0]
				"Space(MB)" = ($DiskInfo[1] |  Select-String '(\d+)' -AllMatches).Matches.Value
				"Used(%)"   = ($DiskInfo[2] | Select-String '(\d+\.\d+)' -AllMatches).Matches.Value
			}
		}

		$Memory = ($Memory.StdOut | Select-String '(.+)' -AllMatches).Matches.Value | ForEach-Object {
			$MemoryInfo = $_.Split(":")
			$MemoryData = ($MemoryInfo[1] | Select-String '(\S+)' -AllMatches).Matches.Value
			[PSCustomObject]@{
				"MemoryType" = ($MemoryInfo[0].Split(" "))[0]
				"Total(K)"   = (($MemoryData[0]).Split("=")[1] |  Select-String '(\d+)' -AllMatches).Matches.Value
				"Free(K)"    = (($MemoryData[1]).Split("=")[1] |  Select-String '(\d+)' -AllMatches).Matches.Value
				"Used(%)"    = (($MemoryData[2]).Split("=")[1] | Select-String '(\d+\.\d+)' -AllMatches).Matches.Value
			}

		}

		#([A-Z][a-z]+)\smodule\s\w+\.exe\W+(\d+\D\d+\D\d+\D\d+)
		$Components = ($Components.StdOut | Select-String '(.+)' -AllMatches).Matches.Value | ForEach-Object {
			$Component = $_.Split(" ")
			$Version = ($_ | Select-String "(\d+\D\d+\D\d+\D\d+)" -AllMatches).Matches.Value
			[PSCustomObject]@{
				Component = $Component[0]
				Version   = $Version
			}
		}

		[PSCustomObject]@{

			"Server"     = $Server.ToUpper()
			"CPU(%)"     = $CPU
			"Disk"       = $Disk
			"Memory"     = $Memory
			"Components" = $Components

		}

	}

}