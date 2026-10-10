---
external help file: VaultControl-help.xml
Module Name: VaultControl
online version:
schema: 2.0.0
title: Get-PARComponent
---

# Get-PARComponent

## SYNOPSIS
Queries the status of a component running on a remote vault server

## SYNTAX

### Password
```
Get-PARComponent -Server <String> -Password <SecureString> -Component <String> [<CommonParameters>]
```

### Credential
```
Get-PARComponent -Server <String> -Credential <PSCredential> -Component <String> [<CommonParameters>]
```

### PassFile
```
Get-PARComponent -Server <String> -PassFile <String> -Component <String> [<CommonParameters>]
```

## DESCRIPTION
Gets status of remote Vault, PADR, CVM or ENE component

## EXAMPLES

### EXAMPLE 1
```
Get-PARComponent -Server 10.10.10.10 -Password $SecureString -Component Vault
```

Returns status of Vault service on remote vault with address 10.10.10.10

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

### -Component
The name of the component to query.
Vault, PADR, CVM or ENE are the accepted values

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
