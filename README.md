# VaultControl

[![appveyor][]][av-site]
[![tests][]][tests-site]
[![coveralls][]][cv-site]
[![psgallery][]][ps-site]
[![license][]][license-link]

[appveyor]:https://ci.appveyor.com/api/projects/status/svnyleaaupspfk1q/branch/master?svg=true
[av-site]:https://ci.appveyor.com/project/pspete/vaultcontrol/branch/master
[tests]:https://img.shields.io/appveyor/tests/pspete/vaultcontrol.svg
[tests-site]:https://ci.appveyor.com/project/pspete/vaultcontrol
[coveralls]:https://coveralls.io/repos/github/pspete/VaultControl/badge.svg
[cv-site]:https://coveralls.io/github/pspete/VaultControl
[psgallery]:https://img.shields.io/powershellgallery/v/VaultControl.svg
[ps-site]:https://www.powershellgallery.com/packages/VaultControl
[license]:https://img.shields.io/github/license/pspete/vaultcontrol.svg
[license-link]:https://github.com/pspete/VaultControl/blob/master/LICENSE.md

Invoke CyberArk PARClient.exe Utility Commands with PowerShell

## Getting Started

- `import-module VaultControl`
- Run `Set-PARConfiguration` to set the path to the `PARClient.exe` utility on your computer, and any non-default port used for PARClient operations.

### List of Commands

- `Get-PARServer` - Gets resource and component information from a vault
- `Get-PARComponent` - Gets vault component status
- `Get-PARComponentLog` - Gets component log content
- `Get-PARComponentConfig` - Gets DBParm/PADR parameter values
- `Get-PARServerLog` - Gets OS event logs from vault server
- `Get-PARService` - Gets status of monitored Operating System services
- `Restart-PARComponent` - Restarts CyberArk Vault/PADR/ENE/CVM component
- `Restart-PARServer` - Initiates reboot of Vault server
- `Set-PARComponentConfig` - Updates DBParm/PADR parameter values
- `Start-PARComponent` - Starts CyberArk Vault/PADR/ENE/CVM component
- `Stop-PARComponent` - Stops CyberArk Vault/PADR/ENE/CVM component
- `Set-PARConfiguration` - Sets default values for path to PARClient.exe & PARClient Port

## Installation

### Prerequisites

- Requires Powershell v3 (minimum)
- CyberArk PARClient.exe utility
- CyberArk Vault/PADR/ENE with which to interact

### Install Options

This repository contains a folder named ```VaultControl```.

The folder and it's contents needs to be present in one of your PowerShell Module Directories.

Use one of the following methods:

#### Option 1: Install from PowerShell Gallery

Download the module from the [PowerShell Gallery](https://www.powershellgallery.com/packages/VaultControl/).

- PowerShell 5.0 or above required.

From a PowerShell prompt, run:

````powershell
Install-Module -Name psPAS -Scope CurrentUser
````

#### Option 2: Manual Install

Find your PowerShell Module Paths with the following command:

```powershell

$env:PSModulePath.split(';')

```

[Download the ```master``` branch](https://github.com/pspete/VaultControl/archive/master.zip)

Extract the archive

Copy the ```VaultControl``` folder to your "Powershell Modules" directory of choice.

## Changelog

All notable changes to this project will be documented in the [Changelog](CHANGELOG.md)

## Author

- **Pete Maan** - [pspete](https://github.com/pspete)

## License

This project is [licensed under the MIT License](LICENSE.md).

## Contributing

Feedback, Issues and Pull Requests are encouraged.
