---
external help file: VaultControl-help.xml
Module Name: VaultControl
online version:
schema: 2.0.0
title: Restart-PARComponent
---

# Restart-PARComponent

## SYNOPSIS
Restarts a Vault or PADR Component

## SYNTAX

### Password
```
Restart-PARComponent -Server <String> -Password <SecureString> -Component <String> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Credential
```
Restart-PARComponent -Server <String> -Credential <PSCredential> -Component <String> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### PassFile
```
Restart-PARComponent -Server <String> -PassFile <String> -Component <String> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Issues a restart command to a remote Vault or DR Vault component

## EXAMPLES

### EXAMPLE 1
```
Restart-PARComponent -Server EPV1 -Credential $cred -Component Vault
```

Restarts the Vault service on Server EPV1

### EXAMPLE 2
```
Restart-PARComponent -Server EPV2 -PassFile C:\PassFile.pass -Component PADR
```

Restarts the PADR service on Server EPV2, using encrypted password contained in C:\PassFile.pass

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
The name of the component to restart.
Vault or PADR are the accepted values

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
