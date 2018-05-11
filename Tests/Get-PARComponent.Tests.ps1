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

				(Get-Command Get-PARComponent).Parameters["$Parameter"].Attributes.Mandatory | Should Be $true

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

				$InputObj | Get-PARComponent -verbose

				Assert-MockCalled Invoke-PARClient -Times 1 -Exactly -Scope It

			}

			It "executes command with expected parameters" {

				$InputObj | Get-PARComponent -verbose

				Assert-MockCalled Invoke-PARClient -ParameterFilter {

					$CommandParameters -eq "Status Vault"

				} -Times 1 -Exactly -Scope It

			}

			It "does not throw if no result on StdOut" {

				{$InputObj | Get-PARComponent -Verbose} | Should Not throw

			}

			It "reports running status" {

				$InputObj = [pscustomobject]@{
					Server    = "SomeServer"
					Component = "Vault"
					PassFile  = (Join-Path $pwd "README.md")
				}

				Mock Invoke-PARClient -MockWith {
					Write-Output @{"StdOut" = "The vault service is running"}
				}

				$InputObj | Get-PARComponent -Verbose | Select-Object -ExpandProperty Status | Should Be "Running"

			}

			It "reports starting status" {

				$InputObj = [pscustomobject]@{
					Server    = "SomeServer"
					Component = "Vault"
					PassFile  = (Join-Path $pwd "README.md")
				}

				Mock Invoke-PARClient -MockWith {
					Write-Output @{"StdOut" = "The vault service is starting"}
				}

				$InputObj | Get-PARComponent -Verbose | Select-Object -ExpandProperty Status | Should Be "Starting"

			}

			It "reports stopped status" {

				$InputObj = [pscustomobject]@{
					Server    = "SomeServer"
					Component = "Vault"
					PassFile  = (Join-Path $pwd "README.md")
				}

				Mock Invoke-PARClient -MockWith {
					Write-Output @{"StdOut" = "The vault service is stopped"}
				}

				$InputObj | Get-PARComponent -Verbose | Select-Object -ExpandProperty Status | Should Be "Stopped"

			}

			It "reports unknown status in full" {

				$InputObj = [pscustomobject]@{
					Server    = "SomeServer"
					Component = "Vault"
					PassFile  = (Join-Path $pwd "README.md")
				}

				Mock Invoke-PARClient -MockWith {
					@{"StdOut" = "The vault said something else"}
				}

				$InputObj | Get-PARComponent -Verbose | Select-Object -ExpandProperty Status | Should Be "The vault said something else"

			}


		}

		Context "Output" {



		}

	}

}