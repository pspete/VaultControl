# VaultControl

Invoke CyberArk PARClient.exe Utility with PowerShell

**Note**: This is a work in progress - it works, but may change as it is developed prior to a Version 1.0 release.
~~Comment based help~~, examples & error checking are all currently missing, but initial core functionality is present.

Feedback, Issues and Pull Requests are more than welcome.

## Getting Started

  - `import-module VaultControl`
  - Run `Set-PARConfiguration` to set the path to the `PARClient.exe` utility and any non-default port used for PARClient operations.

## Functions

  - `Get-PARServer` - Gets resource and component infomration from a vault
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
- CyberArk Vault/PADR/ENE

### Install Options

This repository contains a folder named ```VaultControl```.

The folder needs to be copied to one of your PowerShell Module Directories.

#### Manual Install

Find your PowerShell Module Paths with the following command:

```powershell

$env:PSModulePath.split(';')

```

[Download the ```develop branch```](https://github.com/pspete/VaultControl/archive/develop.zip)

Extract the archive

Copy the ```VaultControl``` folder to your "Powershell Modules" directory of choice.

