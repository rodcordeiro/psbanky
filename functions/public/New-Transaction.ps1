function New-Transaction {
    <#
.SYNOPSIS
    Create a transaction
.DESCRIPTION
    This function creates a new transaction entry at banky
.EXAMPLE
    New-BankyTransaction
    Create a new transaction entry at banky

.NOTES
    Version: 1.0
#>
    [CmdletBinding(ConfirmImpact = 'None')]
    param (
        # Account to be used, if not specified the user will be prompted to select it in a listbox.
        [Parameter(Mandatory = $true, ValueFromPipeline)]
        [string]$account,
        # Category to be used, if not specified the user will be prompted to select it in a listbox.
        [Parameter(Mandatory = $true, ValueFromPipeline)]
        [string]$category,
        # Transaction description
        [Parameter(Mandatory = $true, ValueFromPipeline)]
        [string]$description,
        # Transaction value
        [Parameter(Mandatory = $true, ValueFromPipeline)]
        [decimal]$value,
        # Transaction date at ISO format
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [datetime]$date,
        # If account parameter is specified, the script will search for the account with a similar name, breaking if it returns more than one account. This switch disables the like filter.
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [switch]$AccountMatchExact
    )

    begin {

        if (-not $PSBoundParameters.ContainsKey('Verbose')) {
            $VerbosePreference = $PSCmdlet.SessionState.PSVariable.GetValue('VerbosePreference')
        }
        if (-not $PSBoundParameters.ContainsKey('Confirm')) {
            $ConfirmPreference = $PSCmdlet.SessionState.PSVariable.GetValue('ConfirmPreference')
        }
        if (-not $PSBoundParameters.ContainsKey('WhatIf')) {
            $WhatIfPreference = $PSCmdlet.SessionState.PSVariable.GetValue('WhatIfPreference')
        }


        if (!(Test-Path "$($(Resolve-Path -Path $env:USERPROFILE).Path)\.banky" -ErrorAction Stop)) {
            throw "Banky not found. Please configure it."
        }

        $url = "/api/v1/transactions"
        $accounts = $(Get-Account)
        $categories = $(Get-Category)
    }
    process {
        if ($null -ne $PSItem ) {
            $account = $PSItem.account
            $category = $PSItem.category
            $description = $PSItem.description
            $value = $PSItem.value
            $AccountMatchExact = $PSItem.AccountMatchExact
            if ($PSItem.date) {
                $date = $PSItem.date
            }
        }

        if (-not $account) {
            throw "Account must be informed."
        }

        $selectedAccount = $null
        if ($AccountMatchExact) {
            $selectedAccount = ($accounts | Where-Object { $_.name -eq $account })
        }
        else {
            $selectedAccount = ( $accounts | Where-Object { $_.name -like "*$account*" } )
        }

        if (-not $selectedAccount) { throw "Account $account not found" }
        if (($selectedAccount | Measure-Object).Count -gt 1) { throw "Account filter returned more than one value. Please be more specific." }

        if (!$category) {
            Throw "Category must be passed"
        }

        foreach ($cat in $categories) {
            if ($cat.name -like "*$category*") { $selectedCategory = $cat; break }
            if ($cat.subcategories) {
                foreach ($subcategory in $cat.subcategories) {
                    if ($subcategory.name -like "*$category*") { $selectedCategory = $subcategory }
                }
            }
        }


        if (!$selectedCategory) { throw "Category not found" }
        if (($selectedCategory | Measure-Object).Count -gt 1) { throw "Category filter returned more than one value. Please be more specific." }

        $transaction = [CreateBankyTransaction]::new()
        $transaction.category = $selectedCategory.id
        $transaction.account = $selectedAccount.id
        $transaction.description = if ($description) { $description } else { Read-Host "Informe a descricao da transacao" }
        $transaction.value = if ($value) { $value } else { Read-Host "Informe o valor da transacao" }
        $transaction.date = if ($date) { get-date -Format 'yyyy-MM-ddTHH:mm:ss' -Date $date } else { $(get-date -Format 'yyyy-MM-ddTHH:mm:ss') }

        if ($transaction.value -eq 0) {
            throw "O valor da transacao nao pode ser zero"
        }

        $body = $($transaction | ConvertTo-Json)

        $response = Invoke-Api $url -Method 'POST'  -Body $body
        $response
    }
}
