---
external help file: VaultControl-help.xml
Module Name: VaultControl
online version:
schema: 2.0.0
title: Start-PARComponent
---

# Start-PARComponent

## SYNOPSIS
Starts a component service

## SYNTAX

### Password
```
Start-PARComponent -Server <String> -Password <SecureString> -Component <String> [-Last] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Credential
```
Start-PARComponent -Server <String> -Credential <PSCredential> -Component <String> [-Last] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### PassFile
```
Start-PARComponent -Server <String> -PassFile <String> -Component <String> [-Last] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Starts a stopped Vault, CVM, PADR or ENE component on a remote server

## EXAMPLES

### EXAMPLE 1
```
Start-PARComponent -Server EPV1 -Component Vault
```

Starts the Vault service on Vault Server EPV1

### EXAMPLE 2
```
Start-PARComponent -Server EPV1 -Component PADR
```

Starts the PADR service on Vault Server EPV2

### EXAMPLE 3
```
Start-PARComponent -Server EPV1 -Component ENE
```

Starts the ENE service on Vault Server EPV1

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

### -Last
For the Vault component, start with the last known good configuration.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
