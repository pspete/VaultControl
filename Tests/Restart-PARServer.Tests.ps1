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
			@{Parameter = 'PassFile'}

			It "specifies parameter <Parameter> as mandatory" -TestCases $Parameters {

				param($Parameter)

				(Get-Command Restart-PARServer).Parameters["$Parameter"].Attributes.Mandatory | Should Be $true

			}

		}

		Context "Input" {

			BeforeEach {

				Mock Invoke-PARClient -MockWith {
					Write-Output @{
						"Server" = "Some Server"
						"StdOut" = "Some Message"
					}
				}

				$InputObj = [pscustomobject]@{
					Server    = "SomeServer"
					Component = "Vault"
					PassFile  = (Join-Path $pwd "README.md")
				}

			}

			It "executes command" {

				$InputObj | Restart-PARServer -verbose

				Assert-MockCalled Invoke-PARClient -Times 1 -Exactly -Scope It

			}

			It "executes command with expected parameters" {

				$InputObj | Restart-PARServer -verbose

				Assert-MockCalled Invoke-PARClient -ParameterFilter {

					$CommandParameters -eq "REBOOT"

				} -Times 1 -Exactly -Scope It
			}

		}

		Context "Output" {



		}

	}

}