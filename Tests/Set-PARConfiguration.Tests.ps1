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

		Context "General" {

			BeforeEach {

				Mock Test-Path -MockWith {
					$true
				}

				$InputObj = [pscustomobject]@{
					ClientPath = "SomePath"
					Port       = 666
				}

			}

			it "sets value of script scope variable" {

				$InputObj | Set-PARConfiguration
				$Script:PAR | Should Not BeNullOrEmpty
			}

			it "sets client path property value" {
				$InputObj | Set-PARConfiguration
				$($Script:PAR.ClientPath) | Should Be "SomePath"
			}

			it "sets client path property value" {
				$InputObj | Set-PARConfiguration
				$($Script:PAR.Port) | Should Be 666
			}

		}

	}

}