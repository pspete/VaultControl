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

Describe 'Start-PARComponent' {

	InModuleScope 'VaultControl' {

		Context "Mandatory Parameters" {

			It "specifies parameter <Parameter> as mandatory" -TestCases @(
				@{Parameter = 'Server'},
				@{Parameter = 'Component'},
				@{Parameter = 'Password'},
				@{Parameter = 'Credential'},
				@{Parameter = 'PassFile'}
			) {

				(Get-Command Start-PARComponent).Parameters["$Parameter"].Attributes.Mandatory | Should -Be $true

			}

		}

		Context "Input" {

			BeforeEach {

				Mock Invoke-PARClient -MockWith {
					Write-Output @{}
				}

				$InputObj = [pscustomobject]@{
					Server    = "SomeServer"
					Component = "Vault"
					Password  = ConvertTo-SecureString "SomePassword" -AsPlainText -Force
				}

			}

			It "executes command" {

				$InputObj | Start-PARComponent

				Should -Invoke Invoke-PARClient -Times 1 -Exactly

			}

			It "executes command with expected parameters" {

				$InputObj | Start-PARComponent -Last

				Should -Invoke Invoke-PARClient -ParameterFilter {

					$CommandParameters -eq "Start Vault /Last"

				} -Times 1 -Exactly
			}

		}

		Context "Output" {

			BeforeEach {

				Mock Invoke-PARClient -MockWith {
					Write-Output @{"StdOut" = "Huge Massive Big Ugly error"}
				}

				$InputObj = [pscustomobject]@{
					Server    = "SomeServer"
					Component = "Vault"
					Password  = ConvertTo-SecureString "SomePassword" -AsPlainText -Force
				}

			}

			It "reports failure" {
				$DebugPreference = "Continue"
				$Output = $InputObj | Start-PARComponent

				$Output.Status | Should -Be "Error"

			}

			It "reports success" {
				Mock Invoke-PARClient -MockWith {
					Write-Output @{"StdOut" = "well that started something"}
				}
				$Output = $InputObj | Start-PARComponent

				$Output.Status | Should -Be "Started"

			}

		}

	}

}