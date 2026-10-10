---
external help file: VaultControl-help.xml
Module Name: VaultControl
online version:
schema: 2.0.0
title: Get-PARServer
---

# Get-PARServer

## SYNOPSIS
Gets OS resource information from remote vault

## SYNTAX

### Password
```
Get-PARServer -Server <String> -Password <SecureString> [<CommonParameters>]
```

### Credential
```
Get-PARServer -Server <String> -Credential <PSCredential> [<CommonParameters>]
```

### PassFile
```
Get-PARServer -Server <String> -PassFile <String> [<CommonParameters>]
```

## DESCRIPTION
Returns details of CPU, Memory & Free Disk space from remote vault, as well as details of installed components.

## EXAMPLES

### EXAMPLE 1
```
Get-PARServer -Server EPV1
```

Returns object containing current resource consumption & installed component names & versions.

## PARAMETERS

### -Server
The name or address of the remote Vault server to target with PARClient

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Password
The password for remote operations via PARClient as a secure string

```yaml
Type: SecureString
Parameter Sets: Password
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Credential
The password for remote operations via PARClient held in a credential object

```yaml
Type: PSCredential
Parameter Sets: Credential
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -PassFile
The path to a "password" file created by PARClient.exe, containing the encrypted password value used for remote
operations via PARClient

```yaml
Type: String
Parameter Sets: PassFile
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
