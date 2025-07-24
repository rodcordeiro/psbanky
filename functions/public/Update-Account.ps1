function Update-Account {
    <#
.SYNOPSIS
    Updates an account
.DESCRIPTION
    This function Updates an account entry at Banky
.EXAMPLE
    Update-Account
    Updates an account
.NOTES
    Version: 1.0
#>
    [CmdletBinding()]
    param (
        #Account uuid
        [Parameter(Mandatory = $true, ValueFromPipeline)]
        [string]$id,

        # Account Name
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [string]$Name,

        # Account ammount. e.g. 10, 10.5, 1, 0.58
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [decimal]$Ammount,

        # Account payment type name. e.g. Debit, Credit, Investiment
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [string]$PaymentType,

        # Account threshold. This threshold is used to set alarms for account limits
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [decimal]$Threshold
    )

    begin {
        $payments = $(Get-PaymentType)
    }

    process {
        $account = [UpdateAccount]::new()
        $account.name = $Name
        $account.ammount = $Ammount
        $account.threshold = $Threshold

        if ($null -ne $PSItem ) {
            $id = $PSItem.id
            $account.name = $PSItem.Name
            $account.ammount = $PSItem.Ammount
            $PaymentType = $PSItem.PaymentType
            $account.threshold = $PSItem.Threshold
        }

        if ($paymentType) {
            $selectedPaymentType = ($payments | Where-Object { $_.name -like "*$paymentType*" })
            if (!$selectedPaymentType) { throw "Payment not found" }
            if (($selectedPaymentType | Measure-Object).Count -gt 1) { throw "Payment filter returned more than one value. Please be more specific." }
            $account.paymentType = $selectedPaymentType.uuid
        }

        $body = ($account | Remove-Null | ConvertTo-Json -Depth 1)
        $url = [URI]::EscapeUriString("/api/v1/accounts/$id")

        $response = Invoke-Api -Method Put -Uri $url -Headers $headers -Body $body
        Write-Output $response
    }
    end {

    }
}


class UpdateAccount {
    [AllowNull()][string]$name
    [AllowNull()][float]$ammount
    [AllowNull()][float]$threshold
    [AllowNull()][string]$paymentType
}