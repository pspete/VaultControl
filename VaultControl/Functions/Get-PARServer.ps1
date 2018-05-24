Function Get-PARServer {
	<#
	.SYNOPSIS
	Gets OS resource information from remote vault

	.DESCRIPTION
	Returns details of CPU, Memory & Disk usage from remote vault, as well as details of installed components.

	.PARAMETER Server
	The name or address of the remote Vault server to target with PARClient

	.PARAMETER Password
	The password for remote operations via PARClient as a secure string

	.PARAMETER Credential
	The password for remote operations via PARClient held in a credential object

	.PARAMETER PassFile
	The path to a "password" file created by PARClient.exe, containing the encrypted password value used for remote
	operations via PARClient

	.EXAMPLE
	Get-PARServer -Server EPV1

	Returns object containing current resource consumption & installed component names & versions.
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



			If($CPU.StdOut) {

				$CPU = ($CPU.StdOut  | Select-String '(\d+\.\d+)' -AllMatches).Matches.Value

			}

			Else {$CPU = $null}

			If($Disk.StdOut) {

				$Disk = $Disk.StdOut | Select-String '(.+)' -AllMatches | ForEach-Object {

					$DiskInfo = $_.Line.Split(" ")

					[PSCustomObject]@{

						"Drive"     = $DiskInfo[0]
						"Space(MB)" = ($DiskInfo[1] |  Select-String '(\d+)' -AllMatches).Matches.Value
						"Used(%)"   = ($DiskInfo[2] | Select-String '(\d+\.\d+)' -AllMatches).Matches.Value

					}

				}

			} Else {$Disk = $null}

			If($Memory.StdOut) {

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

			}

			Else {$Memory = $null}

			If($Components.StdOut) {

				$Components = ($Components.StdOut | Select-String '(.+)' -AllMatches).Matches.Value | ForEach-Object {

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