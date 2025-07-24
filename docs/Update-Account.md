---
external help file: psbanky-help.xml
Module Name: psbanky
online version:
schema: 2.0.0
---

# Update-Account

## SYNOPSIS
Updates an account

## SYNTAX

```
Update-Account [-id] <String> [[-Name] <String>] [[-Ammount] <Decimal>] [[-PaymentType] <String>]
 [[-Threshold] <Decimal>] [<CommonParameters>]
```

## DESCRIPTION
This function Updates an account entry at Banky

## EXAMPLES

### EXEMPLO 1
```
Update-Account
```

Updates an account

## PARAMETERS

### -id
Account uuid

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Name
Account Name

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Ammount
Account ammount.
e.g.
10, 10.5, 1, 0.58

```yaml
Type: Decimal
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 0
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -PaymentType
Account payment type name.
e.g.
Debit, Credit, Investiment

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Threshold
Account threshold.
This threshold is used to set alarms for account limits

```yaml
Type: Decimal
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: 0
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Version: 1.0

## RELATED LINKS
