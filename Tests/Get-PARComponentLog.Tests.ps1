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
			@{Parameter = 'Component'},
			@{Parameter = 'Password'},
			@{Parameter = 'Credential'},
			@{Parameter = 'PassFile'}

			It "specifies parameter <Parameter> as mandatory" -TestCases $Parameters {

				param($Parameter)

				(Get-Command Get-PARComponentLog).Parameters["$Parameter"].Attributes.Mandatory | Should Be $true

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

				Assert-MockCalled Invoke-PARClient -Times 1 -Exactly -Scope It

			}

			It "executes command with expected parameters" {

				$InputObj | Get-PARComponentLog -verbose

				Assert-MockCalled Invoke-PARClient -ParameterFilter {

					$CommandParameters -eq "GetLog Vault"

				} -Times 1 -Exactly -Scope It

			}

			It "reports returned event time" {

				$InputObj = [pscustomobject]@{
					Server    = "SomeServer"
					Component = "Vault"
					PassFile  = (Join-Path $pwd "README.md")
				}

				$InputObj | Get-PARComponentLog -Verbose | Select-Object -ExpandProperty Time | Should Be "04/05/2018 16:01:40"

			}

			It "reports returned event code" {

				$InputObj | Get-PARComponentLog -Verbose | Select-Object -ExpandProperty Code | Should Be "ITAIGM03I"

			}

			It "reports returned event message" {

				$InputObj | Get-PARComponentLog -Verbose | Select-Object -ExpandProperty Message | Should Be "DebugLevel 1 ACTIVATED for Class PE"

			}

			It "reports returned event time" -Pending {

				$InputObj = [pscustomobject]@{
					Server    = "SomeServer"
					Component = "Vault"
					TimeFrom  = (Get-Date 01/01/1970)
				}

				$InputObj | Get-PARComponentLog -TimeFrom $(Get-Date 01/01/1970) -Verbose | Select-Object -ExpandProperty Time | Should Be "04/05/2018 16:01:40"

				Assert-MockCalled Invoke-PARClient -ParameterFilter {

					$CommandParameters -eq "GetLog Vault /TimeFrom 01011970:0000"

				} -Times 1 -Exactly -Scope It

			}

		}

		Context "Output" {



		}

	}

}