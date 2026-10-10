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

Describe 'Get-PARComponentLog' {

	InModuleScope 'VaultControl' {

		Context "Mandatory Parameters" {

			It "specifies parameter <Parameter> as mandatory" -TestCases @(
				@{Parameter = 'Server'},
				@{Parameter = 'Component'},
				@{Parameter = 'Password'},
				@{Parameter = 'Credential'},
				@{Parameter = 'PassFile'}
			) {

				(Get-Command Get-PARComponentLog).Parameters["$Parameter"].Attributes.Mandatory | Should -Be $true

			}

		}

		Context "Input" {

			BeforeEach {

				Mock Invoke-PARClient -MockWith {
					Write-Output @{"StdOut" = "04/05/2018 16:01:40 ITAIGM03I DebugLevel 1 ACTIVATED for Class PE"}
				}

				$InputObj = [pscustomobject]@{
					Server    = "SomeServer"
					Component = "Vault"
					Password  = ConvertTo-SecureString "SomePassword" -AsPlainText -Force
				}

			}

			It "executes command" {

				$InputObj | Get-PARComponentLog -verbose

				Should -Invoke Invoke-PARClient -Times 1 -Exactly

			}

			It "executes command with expected parameters" {

				$InputObj | Get-PARComponentLog -verbose

				Should -Invoke Invoke-PARClient -ParameterFilter {

					$CommandParameters -eq "GetLog Vault"

				} -Times 1 -Exactly

			}

			It "reports returned event time" {

				$InputObj = [pscustomobject]@{
					Server    = "SomeServer"
					Component = "Vault"
					PassFile  = (Join-Path $pwd "README.md")
				}

				$InputObj | Get-PARComponentLog -Verbose | Select-Object -ExpandProperty Time | Should -Be "04/05/2018 16:01:40"

			}

			It "reports returned event code" {

				$InputObj | Get-PARComponentLog -Verbose | Select-Object -ExpandProperty Code | Should -Be "ITAIGM03I"

			}

			It "reports returned event message" {

				$InputObj | Get-PARComponentLog -Verbose | Select-Object -ExpandProperty Message | Should -Be "DebugLevel 1 ACTIVATED for Class PE"

			}

			It "sends correct format of timefrom" {

				$InputObj = [pscustomobject]@{
					Server    = "SomeServer"
					Component = "PADR"
					PassFile  = (Join-Path $pwd "README.md")
					TimeFrom  = (Get-Date 01/01/1970)
				}

				$InputObj | Get-PARComponentLog

				Should -Invoke Invoke-PARClient -ParameterFilter {

					$CommandParameters -eq "GetLog PADR /TimeFrom 01011970:0000"

				} -Times 1 -Exactly

			}

			It "sends correct format of lines" {

				$InputObj = [pscustomobject]@{
					Server    = "SomeServer"
					Component = "Vault"
					PassFile  = (Join-Path $pwd "README.md")
					Lines     = 66
				}

				$InputObj | Get-PARComponentLog

				Should -Invoke Invoke-PARClient -ParameterFilter {

					$CommandParameters -eq "GetLog Vault /Lines 66"

				} -Times 1 -Exactly

			}

			It "sends correct command format for console logfile" {

				$InputObj = [pscustomobject]@{
					Server    = "SomeServer"
					Component = "ENE"
					PassFile  = (Join-Path $pwd "README.md")
					LogFile   = "Console"
				}

				$InputObj | Get-PARComponentLog

				Should -Invoke Invoke-PARClient -ParameterFilter {

					$CommandParameters -eq "GetLog ENE /LogFile Console"

				} -Times 1 -Exactly

			}

			It "sends correct command format for trace logfile" {

				$InputObj = [pscustomobject]@{
					Server    = "SomeServer"
					Component = "ENE"
					PassFile  = (Join-Path $pwd "README.md")
					LogFile   = "Trace"
				}

				$InputObj | Get-PARComponentLog

				Should -Invoke Invoke-PARClient -ParameterFilter {

					$CommandParameters -eq "GetLog ENE /LogFile Trace"

				} -Times 1 -Exactly

			}

			It "has placeholder logic for cvm" {

				$InputObj = [pscustomobject]@{
					Server    = "SomeServer"
					Component = "CVM"
					PassFile  = (Join-Path $pwd "README.md")
					LogFile   = "Trace"
				}

				$InputObj | Get-PARComponentLog

				Should -Invoke Invoke-PARClient -ParameterFilter {

					$CommandParameters -eq "GetLog CVM /LogFile Trace"

				} -Times 1 -Exactly

			}

		}

		Context "Output" {



		}

	}

}