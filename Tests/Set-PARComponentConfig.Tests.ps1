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

Describe 'Set-PARComponentConfig' {

	InModuleScope 'VaultControl' {

		Context "Mandatory Parameters" {

			It "specifies parameter <Parameter> as mandatory" -TestCases @(
				@{Parameter = 'Server'},
				@{Parameter = 'Component'},
				@{Parameter = 'Password'},
				@{Parameter = 'Credential'},
				@{Parameter = 'PassFile'}
			) {

				(Get-Command Set-PARComponentConfig).Parameters["$Parameter"].Attributes.Mandatory | Should -Be $true

			}

		}

		Context "Input" {

			BeforeEach {

				Mock Invoke-PARClient -MockWith {

				}

				$InputObj = [pscustomobject]@{
					Server    = "SomeServer"
					Component = "Vault"
					Password  = ConvertTo-SecureString "SomePassword" -AsPlainText -Force
					Parameter = "DefaultTimeout"
					Value     = "SomeValue"
					Mode      = "Temporary"
				}

			}

			It "executes command" {

				$InputObj | Set-PARComponentConfig -verbose

				Should -Invoke Invoke-PARClient -Times 1 -Exactly

			}

			It "executes command with expected parameters" {


				$InputObj | Set-PARComponentConfig -verbose

				Should -Invoke Invoke-PARClient -ParameterFilter {

					$CommandParameters -eq "SetParm Vault DefaultTimeout=SomeValue /Temporary"

				} -Times 1 -Exactly
			}

		}

		Context "Output" {

			BeforeEach {

				Mock Invoke-PARClient -MockWith {
					Write-Output @{"StdOut" = "Something Something Success Something"}
				}

				$InputObj = [pscustomobject]@{
					Server    = "SomeServer"
					Component = "Vault"
					Password  = ConvertTo-SecureString "SomePassword" -AsPlainText -Force
					Parameter = "DefaultTimeout"
					Value     = "SomeValue"
					Mode      = "Temporary"
				}

			}

			It "reports success" {
				$InputObj | Set-PARComponentConfig | Select-Object -ExpandProperty Status | Should -Be "Success"
			}

			It "reports failure" {
				Mock Invoke-PARClient -MockWith {
					Write-Output @{"StdOut" = "Something Something extremely bad error"}
				}

				$InputObj | Set-PARComponentConfig | Select-Object -ExpandProperty Status | Should -Be "Error"
			}

		}

	}

}