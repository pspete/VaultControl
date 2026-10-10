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

Describe 'Start-PARClientProcess' {

	InModuleScope 'VaultControl' {

		Context "Mandatory Parameters" {

			It "specifies parameter <Parameter> as mandatory" -TestCases @(
				@{Parameter = 'Process'}
			) {

				(Get-Command Start-PARClientProcess).Parameters["$Parameter"].Attributes.Mandatory | Should -Be $true

			}



		}

		Context "Default" {

			BeforeEach {

				$Process = New-MockObject -Type "System.Diagnostics.Process"
				$StandardOutput = New-Object -TypeName PSObject
				$StandardError = New-Object -TypeName PSObject

				$StandardOutput | Add-Member -MemberType ScriptMethod -Name ReadToEnd -Value {"Standard Output String"} -Force
				$StandardError | Add-Member -MemberType ScriptMethod -Name ReadToEnd -Value {"Standard Error String"} -Force

				$Process | Add-Member -MemberType ScriptMethod -Name Start -Value {$true} -Force
				$Process | Add-Member -MemberType ScriptMethod -Name WaitForExit -Value {$true} -Force
				$Process | Add-Member -MemberType NoteProperty -Name ExitCode -Value 9876 -Force
				$Process | Add-Member -MemberType ScriptMethod -Name Dispose -Value {$true} -Force
				$Process | Add-Member -MemberType NoteProperty -Name StandardOutput -Value $StandardOutput -Force
				$Process | Add-Member -MemberType NoteProperty -Name StandardError -Value $StandardError -Force

				$InputObj = [pscustomobject]@{
					Process = $Process
				}


			}

			It "executes without exception" {

				{$InputObj | Start-PARClientProcess} | Should -Not -Throw


			}




		}

	}

}