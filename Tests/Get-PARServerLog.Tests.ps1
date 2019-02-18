#Get Current Directory
$Here = Split-Path -Parent $MyInvocation.MyCommand.Path

#Get Function Name
$FunctionName = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -Replace ".Tests.ps1"

#Assume ModuleName from Repository Root folder
$ModuleName = Split-Path (Split-Path $Here -Parent) -Leaf

#Resolve Path to Module Directory
$ModulePath = Resolve-Path "$Here\..\$ModuleName"

#Define Path to Module Manifest
$ManifestPath = Join-Path "$ModulePath" "$ModuleName.psd1"

if( -not (Get-Module -Name $ModuleName -All)) {

	Import-Module -Name "$ManifestPath"  -ArgumentList $true -Force -ErrorAction Stop

}

BeforeAll {

	#$Script:RequestBody = $null

}

AfterAll {

	#$Script:RequestBody = $null

}

Describe $FunctionName {

	InModuleScope $ModuleName {

		Context "Mandatory Parameters" {

			$Parameters = @{Parameter = 'Server'},
			@{Parameter = 'Password'},
			@{Parameter = 'Credential'},
			@{Parameter = 'PassFile'},
			@{Parameter = "LogName"}

			It "specifies parameter <Parameter> as mandatory" -TestCases $Parameters {

				param($Parameter)

				(Get-Command Get-PARServerLog).Parameters["$Parameter"].Attributes.Mandatory | Should Be $true

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

				Assert-MockCalled Invoke-PARClient -Times 1 -Exactly -Scope It

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

				Assert-MockCalled Invoke-PARClient -ParameterFilter {

					$CommandParameters -eq "GetOSLog /Name Application /TimeFrom 01011970:1234"

				} -Times 1 -Exactly -Scope It
			}

		}

		Context "Output" {



		}

	}

}