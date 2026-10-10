BeforeDiscovery {

	#Get Current Directory
	$Here = Split-Path -Parent $PSCommandPath

	#Module Name
	$ModuleName = 'VaultControl'

	#Resolve Path to Module Directory
	$ModulePath = Resolve-Path "$Here\..\$ModuleName"

	#Define Path to Module Manifest
	$ManifestPath = Join-Path "$ModulePath" "$ModuleName.psd1"

	if ( -not (Get-Module -Name $ModuleName -All)) {

		Import-Module -Name "$ManifestPath" -ArgumentList $true -Force -ErrorAction Stop

	}

}

Describe 'Get-PARServerLog' {

	InModuleScope 'VaultControl' {

		Context "Mandatory Parameters" {

			It "specifies parameter <Parameter> as mandatory" -TestCases @(
				@{Parameter = 'Server'},
				@{Parameter = 'Password'},
				@{Parameter = 'Credential'},
				@{Parameter = 'PassFile'},
				@{Parameter = "LogName"}
			) {

				(Get-Command Get-PARServerLog).Parameters["$Parameter"].Attributes.Mandatory | Should -Be $true

			}

		}

		Context "Input" {

			BeforeEach {

				Mock Invoke-PARClient -MockWith {
					Write-Output @{
						"StdOut" = @"
EventLogRecordTime: Wed May 09 20:03:13 2018
Source: Microsoft-Windows-Security-SPP
Computer: zEPV1
Event ID: 1073742727
Event Type: 0
Description: The Software Protection service has stopped.
"@

					}

				}

				$InputObj = [pscustomobject]@{
					Server    = "SomeServer"
					Component = "Vault"
					Password  = ConvertTo-SecureString "SomePassword" -AsPlainText -Force
					LogName   = "Application"
					TimeFrom  = (Get-Date 1/1/1970 -Hour 12 -Minute 34 -Second 56)
				}

			}

			It "executes command" {

				$InputObj | Get-PARServerLog -verbose

				Should -Invoke Invoke-PARClient -Times 1 -Exactly

			}

			It "executes command with expected parameters" {
				$InputObj = [pscustomobject]@{
					Server    = "SomeServer"
					Component = "Vault"
					PassFile  = (Join-Path $pwd README.md)
					LogName   = "Application"
					TimeFrom  = (Get-Date 1/1/1970 -Hour 12 -Minute 34 -Second 56)
				}

				$InputObj | Get-PARServerLog -verbose

				Should -Invoke Invoke-PARClient -ParameterFilter {

					$CommandParameters -eq "GetOSLog /Name Application /TimeFrom 01011970:1234"

				} -Times 1 -Exactly
			}

			It "defaults TimeFrom to 24 hours ago" {

				Mock Get-Date -ParameterFilter { $Format -eq "ddMMyyyy:HHmm" } -MockWith { "TimeStamp" }

				$InputObj = [pscustomobject]@{
					Server   = "SomeServer"
					Password = ConvertTo-SecureString "SomePassword" -AsPlainText -Force
					LogName  = "System"
				}

				$Before = (Get-Date).AddDays(-1)
				$InputObj | Get-PARServerLog
				$After = (Get-Date).AddDays(-1)

				Should -Invoke Get-Date -Times 1 -Exactly -ParameterFilter {
					$Format -eq "ddMMyyyy:HHmm" -and $Date -ge $Before -and $Date -le $After
				}

				Should -Invoke Invoke-PARClient -Times 1 -Exactly -ParameterFilter {
					$CommandParameters -eq "GetOSLog /Name System /TimeFrom TimeStamp"
				}

			}

		}

		Context "Output" {

			BeforeEach {

				$InputObj = [pscustomobject]@{
					Server   = "SomeServer"
					Password = ConvertTo-SecureString "SomePassword" -AsPlainText -Force
					LogName  = "System"
				}

			}

			It "returns no output and no error when no events are returned" {

				Mock Invoke-PARClient -MockWith {
					Write-Output @{
						"StdOut" = "PARAgent version: 15.2.0.44`r`n"
					}
				}

				$Result = $InputObj | Get-PARServerLog -ErrorVariable LogErrors
				$Result | Should -BeNullOrEmpty
				$LogErrors | Should -BeNullOrEmpty

			}

			It "returns EventID without qualifier bits" -TestCases @(
				@{Raw = '1073748860'; Expected = 7036},
				@{Raw = '3221232472'; Expected = 7000},
				@{Raw = '6005'; Expected = 6005}
			) {

				Mock Invoke-PARClient -MockWith {
					Write-Output @{
						"StdOut" = @"
PARAgent version: 15.2.0.44
EventLogRecordTime: Sat Oct 10 15:33:36 2026
Source: Service Control Manager
Computer: EPV1
Event ID: $Raw
Event Type: 4
Description: The Software Protection service entered the stopped state.
"@
					}
				}

				$Result = $InputObj | Get-PARServerLog
				$Result.EventID | Should -Be $Expected
				$Result.EventID | Should -BeOfType [int]

			}

		}

	}

}