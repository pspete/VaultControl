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

	Import-Module -Name "$ManifestPath" -Force -ErrorAction Stop

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
			@{Parameter = 'PassFile'}

			It "specifies parameter <Parameter> as mandatory" -TestCases $Parameters {

				param($Parameter)

				(Get-Command Get-PARServer).Parameters["$Parameter"].Attributes.Mandatory | Should Be $true

			}

		}

		Context "Command Execution" {


			BeforeEach {

				Mock Invoke-PARClient -MockWith {
				}

				$InputObj = [pscustomobject]@{
					Server   = "SomeServer"
					Password = ConvertTo-SecureString "SomePassword" -AsPlainText -Force
				}

			}

			It "executes expected commands" {

				$InputObj | Get-PARServer -Verbose

				Assert-MockCalled Invoke-PARClient -Times 4 -Exactly -Scope It

			}

			It "executes GetCPU command" {

				$InputObj | Get-PARServer -verbose

				Assert-MockCalled Invoke-PARClient -ParameterFilter {

					$CommandParameters -eq "GetCPU"

				} -Times 1 -Scope It

			}

			It "executes GetDiskUsage command" {

				$InputObj | Get-PARServer -verbose

				Assert-MockCalled Invoke-PARClient -ParameterFilter {

					$CommandParameters -eq "GetDiskUsage"

				} -Times 1 -Scope It

			}

			It "executes GetMemoryUsage command" {

				$InputObj | Get-PARServer -verbose

				Assert-MockCalled Invoke-PARClient -ParameterFilter {

					$CommandParameters -eq "GetMemoryUsage"

				} -Times 1 -Scope It

			}

			It "executes List command" {


				$InputObj | Get-PARServer -verbose

				Assert-MockCalled Invoke-PARClient -ParameterFilter {

					$CommandParameters -eq "List"

				} -Times 1 -Scope It

			}

		}

		Context "Return Value Parsing" {

			BeforeEach {

				$Script:counter = 0
				Mock Invoke-PARClient -MockWith {

					$Script:counter++

					if ($Script:counter -eq 1) {
						# GetCPU
						[PSCustomObject]@{
							"StdOut" = "%12.34"
						}
					}

					if($Script:counter -eq 2) {
						# GetDisk
						[PSCustomObject]@{"StdOut" = "C:\ 35336MB (69.92%)"}
					}

					if($Script:counter -eq 3) {
						# GetMemory
						[PSCustomObject]@{"StdOut" = @"
Physical memory: Total=1047580K, Free=434336K, Utilized=58.54%
Swap memory: Total=1834012K, Free=479088K, Utilized=73.88%
"@
						}
					}

					if($Script:counter -eq 4) {
						# List
						[PSCustomObject]@{"StdOut" = @"
Vault module dbmain.exe                        10.2.3.4
ENE module ENE.exe                             10.2.3.4
PADR module PADR.exe                           10.2.3.4
"@
						}
					}

				}


				$InputObj = [pscustomobject]@{
					Server   = "SomeServer"
					Password = ConvertTo-SecureString "SomePassword" -AsPlainText -Force
				}

			}

			It "reports expected cpu info" {

				$InputObj | Get-PARServer | Select-Object -ExpandProperty "CPU(%)" | Should Be "12.34"

			}

			It "reports expected disk info" {
				$Output = $InputObj | Get-PARServer
				$Output.Disk.Drive | Should Be "C:\"
				$Output.Disk."Space(MB)" | Should Be "35336"
				$Output.Disk."Used(%)" | Should Be "69.92"

			}

			It "reports expected memory info" {
				$Output = $InputObj | Get-PARServer
				$Output.Memory[0].MemoryType | Should Be "Physical"
				$Output.Memory[0]."Total(K)" | Should Be "1047580"
				$Output.Memory[0]."Free(K)"  | Should Be "434336"
				$Output.Memory[0]."Used(%)"  | Should Be "58.54"
				$Output.Memory[1].MemoryType | Should Be "Swap"
				$Output.Memory[1]."Total(K)" | Should Be "1834012"
				$Output.Memory[1]."Free(K)"  | Should Be "479088"
				$Output.Memory[1]."Used(%)"  | Should Be "73.88"

			}

			It "reports expected component info" {
				$Output = $InputObj | Get-PARServer
				$Output.Components[0].Component | Should Be "Vault"
				$Output.Components[0].Version | Should Be "10.2.3.4"
				$Output.Components[1].Component | Should Be "ENE"
				$Output.Components[1].Version | Should Be "10.2.3.4"
				$Output.Components[2].Component | Should Be "PADR"
				$Output.Components[2].Version | Should Be "10.2.3.4"

			}

		}

	}

}