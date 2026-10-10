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

Describe $FunctionName {

	InModuleScope $ModuleName {

		Context "Configuration" {

			BeforeEach {

				$Script:SavedPAR = $Script:PAR
				$Script:PAR = [pscustomobject]@{}

				Mock Start-Process -MockWith {}

			}

			AfterEach {

				$Script:PAR = $Script:SavedPAR

			}

			It "throws if PARClient path is not set" {

				{New-PARPassFile -Path "C:\SomeFolder\SomeFile.pass"} | Should Throw "PARClient.exe not found"

			}

			It "does not invoke PARClient if path is not set" {

				{New-PARPassFile -Path "C:\SomeFolder\SomeFile.pass"} | Should Throw
				Assert-MockCalled Start-Process -Times 0 -Exactly -Scope It

			}

		}

		Context "Create Password File" {

			BeforeEach {

				$Script:SavedPAR = $Script:PAR
				$Script:PAR = [pscustomobject]@{ClientPath = "C:\PARClient\PARClient.exe"}

				Mock Test-Path -MockWith {$true}

				Mock New-Item -MockWith {}

				Mock Get-Item -MockWith {
					[pscustomobject]@{FullName = "C:\Some Folder\SomeFile.pass"}
				}

				Mock Start-Process -MockWith {
					[pscustomobject]@{ExitCode = 0}
				}

			}

			AfterEach {

				$Script:PAR = $Script:SavedPAR

			}

			It "invokes PARClient" {

				New-PARPassFile -Path "C:\Some Folder\SomeFile.pass"
				Assert-MockCalled Start-Process -Times 1 -Exactly -Scope It

			}

			It "invokes configured PARClient path" {

				New-PARPassFile -Path "C:\Some Folder\SomeFile.pass"
				Assert-MockCalled Start-Process -Times 1 -Exactly -Scope It -ParameterFilter {

					$FilePath -eq "C:\PARClient\PARClient.exe"

				}

			}

			It "uses PARClient folder as working directory" {

				New-PARPassFile -Path "C:\Some Folder\SomeFile.pass"
				Assert-MockCalled Start-Process -Times 1 -Exactly -Scope It -ParameterFilter {

					$WorkingDirectory -eq "C:\PARClient"

				}

			}

			It "passes quoted path to CreatePassFile" {

				New-PARPassFile -Path "C:\Some Folder\SomeFile.pass"
				Assert-MockCalled Start-Process -Times 1 -Exactly -Scope It -ParameterFilter {

					$ArgumentList -eq '/CreatePassFile "C:\Some Folder\SomeFile.pass"'

				}

			}

			It "runs PARClient in current console and waits" {

				New-PARPassFile -Path "C:\Some Folder\SomeFile.pass"
				Assert-MockCalled Start-Process -Times 1 -Exactly -Scope It -ParameterFilter {

					$NoNewWindow -and $Wait -and $PassThru

				}

			}

			It "returns created file" {

				$Output = New-PARPassFile -Path "C:\Some Folder\SomeFile.pass"
				$Output.FullName | Should Be "C:\Some Folder\SomeFile.pass"

			}

			It "accepts path from pipeline" {

				[pscustomobject]@{Path = "C:\Some Folder\SomeFile.pass"} | New-PARPassFile
				Assert-MockCalled Start-Process -Times 1 -Exactly -Scope It

			}

			It "does not create existing folder" {

				New-PARPassFile -Path "C:\Some Folder\SomeFile.pass"
				Assert-MockCalled New-Item -Times 0 -Exactly -Scope It

			}

			It "creates missing folder" {

				Mock Test-Path -MockWith {$false} -ParameterFilter {$PathType -eq "Container"}

				New-PARPassFile -Path "C:\Some Folder\SomeFile.pass"
				Assert-MockCalled New-Item -Times 1 -Exactly -Scope It -ParameterFilter {

					$Path -eq "C:\Some Folder" -and $ItemType -eq "Directory"

				}

			}

			It "does not invoke PARClient with WhatIf" {

				New-PARPassFile -Path "C:\Some Folder\SomeFile.pass" -WhatIf
				Assert-MockCalled Start-Process -Times 0 -Exactly -Scope It

			}

			It "reports error if PARClient exit code is not 0" {

				Mock Start-Process -MockWith {
					[pscustomobject]@{ExitCode = 1}
				}

				{New-PARPassFile -Path "C:\Some Folder\SomeFile.pass" -ErrorAction Stop} | Should Throw "Failed to create password file"

			}

			It "reports error if password file is not created" {

				Mock Test-Path -MockWith {$false} -ParameterFilter {$PathType -eq "Leaf"}

				{New-PARPassFile -Path "C:\Some Folder\SomeFile.pass" -ErrorAction Stop} | Should Throw "Failed to create password file"

			}

		}

	}

}
