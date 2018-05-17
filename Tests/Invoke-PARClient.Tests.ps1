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

#Preference file must be removed and module must be re-imported for tests to complete
Remove-Item -Path "$env:HOMEDRIVE$env:HomePath\PARConfiguration.xml" -Force -ErrorAction SilentlyContinue
Remove-Module -Name $ModuleName -Force -ErrorAction SilentlyContinue
Import-Module -Name "$ManifestPath" -Force -ErrorAction Stop

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
			@{Parameter = 'CommandParameters'},
			@{Parameter = 'Password'},
			@{Parameter = 'Credential'},
			@{Parameter = 'PassFile'}

			It "specifies parameter <Parameter> as mandatory" -TestCases $Parameters {

				param($Parameter)

				(Get-Command Invoke-PARClient).Parameters["$Parameter"].Attributes.Mandatory | Should Be $true

			}



		}

		Context "Default" {

			BeforeEach {

				Mock Start-PARClientProcess -MockWith {
					Write-Output @{}
				}

				$InputObj = [pscustomobject]@{
					Server            = "SomeServer"
					CommandParameters = "Some Command Parameters"
					Password          = ConvertTo-SecureString "SomePassword" -AsPlainText -Force
					Port              = 1234
				}


			}

			It "tests path" {

				{$InputObj | Invoke-PARClient -ClientPath .\RandomFile.exe} | Should Throw

			}

			It "throws if `$PAR variable not set in script scope" {

				{$InputObj | Invoke-PARClient} | Should Throw

			}

			It "throws if `$PAR variable does not have ClientPath property" {

				$object = [PSCustomObject]@{
					prop1 = "Value1"
					prop2 = "Value2"
				}
				New-Variable -Name PAR -Value $object

				{$InputObj | Invoke-PARClient} | Should Throw

			}

			It "throws if `$PAR.ClientPath is not resolvable" {

				$object = [PSCustomObject]@{
					ClientPath = ".\RandomFile.Exe"
					prop2      = "Value2"
				}
				New-Variable -Name PAR -Value $object

				{$InputObj | Invoke-PARClient} | Should Throw

			}

			It "no throw if `$PAR.ClientPath is resolvable" {

				$object = [PSCustomObject]@{
					ClientPath = ".\README.md"
					prop2      = "Value2"
				}
				New-Variable -Name PAR -Value $object

				{$InputObj | Invoke-PARClient} | Should Throw

			}


		}

		Context "ParameterSets" {

			BeforeEach {

				Mock Test-Path -MockWith {
					$true
				}

				Mock Start-PARClientProcess -MockWith {
					Write-Output @{}
				}

				$InputObj = [pscustomobject]@{
					Server            = "SomeServer"
					CommandParameters = "Some Command Parameters"
					Password          = ConvertTo-SecureString "SomePassword" -AsPlainText -Force
					Port              = 1234
				}


			}

			it "does not throw after Set-PARConfiguration has set the `$PAR variable" {

				Set-PARConfiguration -ClientPath "C:\SomePath\PARClient.exe"
				{$InputObj | Invoke-PARClient} | Should Not throw

			}

			it "does not require Set-PARConfiguration to be run more than once" {

				{$InputObj | Invoke-PARClient} | Should Not throw

			}

			It "executes command with password" {

				$InputObj | Invoke-PARClient

				Assert-MockCalled Start-PARClientProcess -Times 1 -Exactly -Scope It

			}

			It "executes command with credential" {

				$InputObj = [pscustomobject]@{
					Server            = "SomeServer"
					CommandParameters = "Some Command Parameters"
					Credential        = New-Object System.Management.Automation.PSCredential ("username", $(ConvertTo-SecureString "SomePassword" -AsPlainText -Force))
				}

				$InputObj | Invoke-PARClient

				Assert-MockCalled Start-PARClientProcess -Times 1 -Exactly -Scope It

			}

			It "executes command with credential" {

				$InputObj = [pscustomobject]@{
					Server            = "SomeServer"
					CommandParameters = "Some Command Parameters"
					PassFile          = "SomeFile"
				}

				$InputObj | Invoke-PARClient

				Assert-MockCalled Start-PARClientProcess -Times 1 -Exactly -Scope It

			}

		}

		Context "Output" {



		}

	}

}