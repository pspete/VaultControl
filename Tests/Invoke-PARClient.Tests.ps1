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

Describe 'Invoke-PARClient' {

	InModuleScope 'VaultControl' {

		BeforeAll {

			$Script:SavedPAR = $Script:PAR
			Remove-Variable -Name PAR -Scope Script -ErrorAction SilentlyContinue

		}

		AfterAll {

			$Script:PAR = $Script:SavedPAR

		}

		Context "Mandatory Parameters" {

			It "specifies parameter <Parameter> as mandatory" -TestCases @(
				@{Parameter = 'Server'},
				@{Parameter = 'CommandParameters'},
				@{Parameter = 'Password'},
				@{Parameter = 'Credential'},
				@{Parameter = 'PassFile'}
			) {

				(Get-Command Invoke-PARClient).Parameters["$Parameter"].Attributes.Mandatory | Should -Be $true

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

				{$InputObj | Invoke-PARClient -ClientPath .\RandomFile.exe} | Should -Throw

			}

			It "throws if `$PAR variable not set in script scope" {

				{$InputObj | Invoke-PARClient} | Should -Throw

			}

			It "throws if `$PAR variable does not have ClientPath property" {

				$object = [PSCustomObject]@{
					prop1 = "Value1"
					prop2 = "Value2"
				}
				New-Variable -Name PAR -Value $object

				{$InputObj | Invoke-PARClient} | Should -Throw

			}

			It "throws if `$PAR.ClientPath is not resolvable" {

				$object = [PSCustomObject]@{
					ClientPath = ".\RandomFile.Exe"
					prop2      = "Value2"
				}
				New-Variable -Name PAR -Value $object

				{$InputObj | Invoke-PARClient} | Should -Throw

			}

			It "no throw if `$PAR.ClientPath is resolvable" {

				$object = [PSCustomObject]@{
					ClientPath = ".\README.md"
					prop2      = "Value2"
				}
				New-Variable -Name PAR -Value $object

				{$InputObj | Invoke-PARClient} | Should -Throw

			}


		}

		Context "ParameterSets" {

			BeforeAll {

				Mock Test-Path -MockWith {
					$true
				}

				Mock Export-Clixml -MockWith {}

				Set-PARConfiguration -ClientPath "C:\SomePath\PARClient.exe"

			}

			BeforeEach {

				Mock Test-Path -MockWith {
					$true
				}

				Mock Export-Clixml -MockWith {}

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
				{$InputObj | Invoke-PARClient} | Should -Not -Throw

			}

			it "does not require Set-PARConfiguration to be run more than once" {

				{$InputObj | Invoke-PARClient} | Should -Not -Throw

			}

			It "executes command with password" {

				$InputObj | Invoke-PARClient

				Should -Invoke Start-PARClientProcess -Times 1 -Exactly

			}

			It "executes command with credential" {

				$InputObj = [pscustomobject]@{
					Server            = "SomeServer"
					CommandParameters = "Some Command Parameters"
					Credential        = New-Object System.Management.Automation.PSCredential ("username", $(ConvertTo-SecureString "SomePassword" -AsPlainText -Force))
				}

				$InputObj | Invoke-PARClient

				Should -Invoke Start-PARClientProcess -Times 1 -Exactly

			}

			It "executes command with credential" {

				$InputObj = [pscustomobject]@{
					Server            = "SomeServer"
					CommandParameters = "Some Command Parameters"
					PassFile          = "SomeFile"
				}

				$InputObj | Invoke-PARClient

				Should -Invoke Start-PARClientProcess -Times 1 -Exactly

			}

			It "quotes passfile path" {

				$InputObj = [pscustomobject]@{
					Server            = "SomeServer"
					CommandParameters = "Some Command Parameters"
					PassFile          = "C:\Some Folder\Some File"
				}

				$InputObj | Invoke-PARClient

				Should -Invoke Start-PARClientProcess -Times 1 -Exactly -ParameterFilter {

					$Process.StartInfo.Arguments -match '^SomeServer /UsePassFile "C:\\Some Folder\\Some File" '

				}

			}

		}

		Context "Reporting Errors" {

			BeforeEach {

				$InputObj = [pscustomobject]@{
					Server            = "SomeServer"
					CommandParameters = "Some Command Parameters"
					Password          = ConvertTo-SecureString "SomePassword" -AsPlainText -Force
					Port              = 1234
				}


			}

			it "reports 'ErrorCode Message' format errors on stdout" {

				Mock Start-PARClientProcess -MockWith {
					[pscustomobject]@{
						"ExitCode" = 0
						"StdOut"   = "PARCL002S Authentication failure."
						"StdErr"   = $null
					}

				}

				{$InputObj | Invoke-PARClient -ErrorAction Stop} | Should -Throw "*Authentication failure.*"

			}

			it "reports '(ErrorCode) Message' format errors on stdout" {

				Mock Start-PARClientProcess -MockWith {
					[pscustomobject]@{
						"ExitCode" = 0
						"StdOut"   = "ERROR (999) Something Awful."
						"StdErr"   = $null
					}

				}

				{$InputObj | Invoke-PARClient -ErrorAction Stop} | Should -Throw "*Something Awful.*"

			}

			it "reports 'Message (ErrorCode)' format errors on stdout" {

				Mock Start-PARClientProcess -MockWith {
					[pscustomobject]@{
						"ExitCode" = 0
						"StdOut"   = "Cannot get parameter DisableExceptionHandling. (Reason: 7)"
						"StdErr"   = $null
					}

				}

				{$InputObj | Invoke-PARClient -ErrorAction Stop} | Should -Throw "*Cannot get parameter DisableExceptionHandling.*"

			}

			it "reports 'CLP010S: Message' format errors on stdout" {

				Mock Start-PARClientProcess -MockWith {
					[pscustomobject]@{
						"ExitCode" = 1
						"StdOut"   = "CLP010S: Parameter `"Test\test.pass`" is redundant`r`nUsage: `r`nPARClient /?`r`n"
						"StdErr"   = $null
					}

				}

				{$InputObj | Invoke-PARClient -ErrorAction Stop} | Should -Throw "*is redundant*"

			}

			it "does not report stdout containing '(Text: 0)' as an error" {

				Mock Start-PARClientProcess -MockWith {
					[pscustomobject]@{
						"ExitCode" = 0
						"StdOut"   = "Description: Virtualization-based security (Enabled policies: 0)"
						"StdErr"   = $null
					}

				}

				{$InputObj | Invoke-PARClient -ErrorAction Stop} | Should -Not -Throw

			}

		}

		Context "Command Arguments" {

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

			It "executes command with expected arguments" {

				$InputObj | Invoke-PARClient

				Should -Invoke Start-PARClientProcess -Times 1 -Exactly -ParameterFilter {

					$Process.StartInfo.Arguments -match $('^SomeServer/SomePassword /Port 1234 /StateFileName "' + [regex]::Escape($env:temp) + '\\[0-9a-f-]{36}\.tmp" /Q /C "Some Command Parameters"$')

				}

			}

			It "uses a new state file for each command" {

				$Script:StateFiles = @()
				Mock Start-PARClientProcess -MockWith {
					$Script:StateFiles += [regex]::Match($Process.StartInfo.Arguments, '/StateFileName "([^"]+)"').Groups[1].Value
					Write-Output @{}
				}

				$InputObj | Invoke-PARClient
				$InputObj | Invoke-PARClient

				$Script:StateFiles.Count | Should -Be 2
				$Script:StateFiles[0] | Should -Not -Be $Script:StateFiles[1]

			}

			It "deletes the state file after the command completes" {

				Mock Remove-Item -MockWith {}

				$InputObj | Invoke-PARClient

				Should -Invoke Remove-Item -Times 1 -Exactly -ParameterFilter {
					$Path -match '[0-9a-f-]{36}\.tmp$'
				}

			}

			It "deletes the state file if the command throws" {

				Mock Remove-Item -MockWith {}
				Mock Start-PARClientProcess -MockWith { throw "Process Failed" }

				{$InputObj | Invoke-PARClient} | Should -Throw "*Process Failed*"

				Should -Invoke Remove-Item -Times 1 -Exactly

			}

			It "does not output the `$PAR variable" {

				Mock Start-PARClientProcess -MockWith {
					[pscustomobject]@{"ExitCode" = 0; "StdOut" = "Output"; "StdErr" = $null}
				}

				$Result = $InputObj | Invoke-PARClient

				@($Result).Count | Should -Be 1
				$Result.StdOut | Should -Be "Output"

			}

		}

	}

}