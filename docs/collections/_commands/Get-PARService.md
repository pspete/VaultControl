---
external help file: VaultControl-help.xml
Module Name: VaultControl
online version:
schema: 2.0.0
title: Get-PARService
---

# Get-PARService

## SYNOPSIS
Gets status of Operating System Services on Vault Server.

## SYNTAX

### Password
```
Get-PARService -Server <String> -Password <SecureString> [-ServiceName <String>] [<CommonParameters>]
```

### Credential
```
Get-PARService -Server <String> -Credential <PSCredential> [-ServiceName <String>] [<CommonParameters>]
```

### PassFile
```
Get-PARService -Server <String> -PassFile <String> [-ServiceName <String>] [<CommonParameters>]
```

## DESCRIPTION
For services listed as allowed to be monitored with PARClient, returns the running status of the service.
By default returns the status of all monitored services.

## EXAMPLES

### EXAMPLE 1
```
Get-PARService -Server EPV1 -Password $SecureString
```

Returns details of all monitored services

### EXAMPLE 2
```
Get-PARService -Server EPV1 -Password $SecureString -ServiceName "PrivateArk Database"
```

Returns details of PrivateArk Database service

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

### -ServiceName
The service to return the status of

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: *
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
