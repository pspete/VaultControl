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

Describe 'Restart-PARComponent' {

	InModuleScope 'VaultControl' {

		Context "Mandatory Parameters" {

			It "specifies parameter <Parameter> as mandatory" -TestCases @(
				@{Parameter = 'Server'},
				@{Parameter = 'Component'},
				@{Parameter = 'Password'},
				@{Parameter = 'Credential'},
				@{Parameter = 'PassFile'}
			) {

				(Get-Command Restart-PARComponent).Parameters["$Parameter"].Attributes.Mandatory | Should -Be $true

			}

		}

		Context "Input" {

			BeforeEach {

				Mock Invoke-PARClient -MockWith {
					Write-Output @{"StdOut" = "restarted"}
				}

				$InputObj = [pscustomobject]@{
					Server    = "SomeServer"
					Component = "Vault"
					Password  = ConvertTo-SecureString "SomePassword" -AsPlainText -Force
				}

			}

			It "executes command" {

				$InputObj | Restart-PARComponent -verbose

				Should -Invoke Invoke-PARClient -Times 1 -Exactly

			}

			It "executes command with expected parameters" {

				$InputObj = [pscustomobject]@{
					Server    = "SomeServer"
					Component = "Vault"
					PassFile  = (Join-Path $pwd README.md)
				}
				#$DebugPreference = "Continue"
				$InputObj | Restart-PARComponent -verbose

				Should -Invoke Invoke-PARClient -ParameterFilter {

					$CommandParameters -eq "Restart Vault"

				} -Times 1 -Exactly
			}

		}

		Context "Output" {



		}

	}

}