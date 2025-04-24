---
external help file: psbanky-help.xml
Module Name: psbanky
online version:
schema: 2.0.0
---

# Invoke-Authentication

## SYNOPSIS
Authenticate to Banky services

## SYNTAX

```
Invoke-Authentication [-username] <String> [-password] <SecureString> [<CommonParameters>]
```

## DESCRIPTION
This function authenticates to Banky services and save the token to environment

## EXAMPLES

### EXEMPLO 1
```
Invoke-Authentication -username Teste -password Teste
```

Authenticate to banky with test user

## PARAMETERS

### -username
The username to authenticate

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -password
The password secure string to be used

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### [System.string] username
###     The username to authenticate
### [System.SecureString] password
###     The password secure string to be used
## OUTPUTS

## NOTES
Version: 1.0

## RELATED LINKS
