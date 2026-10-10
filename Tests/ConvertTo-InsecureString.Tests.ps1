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

Describe 'ConvertTo-InsecureString' {

	InModuleScope 'VaultControl' {

		Context "Mandatory Parameters" {

			It "specifies parameter <Parameter> as mandatory" -TestCases @(
				@{Parameter = 'SecureString'}
			) {

				(Get-Command ConvertTo-InsecureString).Parameters["$Parameter"].Attributes.Mandatory | Should -Be $true

			}

		}

		Context "General" {

			BeforeEach {

				$InputObj = [pscustomobject]@{
					SecureString = ConvertTo-SecureString SomeSecureString -AsPlainText -Force
				}

			}

			It "converts securestring to plaintext" {

				ConvertTo-InsecureString -SecureString $InputObj.SecureString| Should -Be "SomeSecureString"

			}

		}

	}

}