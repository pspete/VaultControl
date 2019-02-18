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
			@{Parameter = 'Component'},
			@{Parameter = 'Password'},
			@{Parameter = 'Credential'},
			@{Parameter = 'PassFile'}

			It "specifies parameter <Parameter> as mandatory" -TestCases $Parameters {

				param($Parameter)

				(Get-Command Get-PARComponentConfig).Parameters["$Parameter"].Attributes.Mandatory | Should Be $true

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
					Parameter = "DebugLevel"
				}

			}

			It "executes command" {

				$InputObj | Get-PARComponentConfig -verbose

				Assert-MockCalled Invoke-PARClient -Times 1 -Exactly -Scope It

			}

			It "executes command with expected parameters" {

				$InputObj | Get-PARComponentConfig

				Assert-MockCalled Invoke-PARClient -ParameterFilter {

					$CommandParameters -eq "GetParm Vault DebugLevel"

				} -Times 1 -Exactly -Scope It

			}

			It "reports returned value status" {

				Mock Invoke-PARClient -MockWith {
					Write-Output @{"StdOut" = "DebugLevel=PE(1),PERF(1)"}
				}

				$InputObj | Get-PARComponentConfig | Select-Object -ExpandProperty Value | Should Be "PE(1),PERF(1)"

			}

			It "reports returned value status" {

				Mock Invoke-PARClient -MockWith {
					Write-Output @{"StdOut" = "DebugLevel"}
				}

				$InputObj | Get-PARComponentConfig | Select-Object -ExpandProperty Value | Should Be "DebugLevel"

			}

			It "throws if invalid vault parameter specified" {
				$InputObj = [pscustomobject]@{
					Server    = "SomeServer"
					Component = "Vault"
					Password  = ConvertTo-SecureString "SomePassword" -AsPlainText -Force
					Parameter = "FailoverMode"
				}

				{$InputObj | Get-PARComponentConfig} | Should throw

			}

			It "throws if invalid PADR parameter specified" {
				$InputObj = [pscustomobject]@{
					Server    = "SomeServer"
					Component = "PADR"
					Password  = ConvertTo-SecureString "SomePassword" -AsPlainText -Force
					Parameter = "DebugLevel"
				}

				{$InputObj | Get-PARComponentConfig} | Should throw

			}


		}

		Context "Output" {



		}

	}

}