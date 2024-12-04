function Update-BankyTransaction {
    <#
.SYNOPSIS
    Update a transaction
.DESCRIPTION
    This function update transaction entry at banky
.EXAMPLE
    Update-BankyTransaction
    Update a transaction entry at banky
.NOTES
    Version: 1.0
#>
    [CmdletBinding()]
    param (
        # Transaction to be updated
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName)]
        [ValidatePattern("^[0-9a-fA-F]{8}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{12}$")]
        [string]$id,

        # Account to be used, if not specified the user will be prompted to select it in a listbox.
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName)]
        [string]$account,

        # Category to be used, if not specified the user will be prompted to select it in a listbox.
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName)]
        [string]$category,

        # Transaction description
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName)]
        [string]$description,

        # Transaction value
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName)]
        [decimal]$value,

        # Transaction date at ISO format
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName)]
        [datetime]$date,

        # If account parameter is specified, the script will search for the account with a similar name, breaking if it returns more than one account. This switch disables the like filter.
        [switch]$AccountMatchExact
    )

    begin {

        if (!(Test-Path "$($(Resolve-Path -Path $env:USERPROFILE).Path)\.banky" -ErrorAction Stop)) {
            throw "Banky not found. Please configure it."
        }
        [BankyAuthenticationResponse]$bankyAuth = $(Get-Content "$($(Resolve-Path -Path $env:USERPROFILE).Path)\.banky" -ErrorAction Stop | ConvertFrom-Json )

        $isExpired = [datetime]::Parse($bankyAuth.expirationDate) -lt [DateTime]::Now

        if ($isExpired) {
            try {
                New-BankyAuthentication @banky
            }
            catch {
                Throw "Login expirado, autentique novamente"
            }
        }

        $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
        $headers.Add("Content-Type", "application/json")
        $headers.Add("Authorization", "Bearer $($bankyAuth.accessToken)")


        $accounts = $(Get-BankyAccounts)
        $categories = $(Get-BankyCategories)
    }
    process {


        $transaction = [UpdateBankyTransaction]::new($id)
        $transaction.description = if ($description) { $description }
        $transaction.value = if ($value) { $value }
        $transaction.date = if ($date) { get-date -Format 'yyyy-MM-ddTHH:mm:ss' -Date $date }

        if (($transaction.value) -and ($transaction.value -eq 0)) {
            throw "O valor da transacao nao pode ser zero"
        }

        if ($account) {
            $selectedAccount = if ($AccountMatchExact) { $accounts | Where-Object { $_.name -eq $account } } else { $accounts | Where-Object { $_.name -like "*$account*" } }
            $transaction.account = $selectedAccount.id
        }



        if ($category) {

            foreach ($cat in $categories) {
                if ($cat.name -like "*$category*") { $selectedCategory = $cat }
                if ($cat.subcategories) {
                    foreach ($subcategory in $cat.subcategories) {
                        if ($subcategory.name -like "*$category*") { $selectedCategory = $subcategory }
                    }
                }
            }
            $transaction.category = $selectedCategory.id
        }


        # Convert to JSON and remove null/empty values
        $jsonObject = $transaction | ConvertTo-Json -Depth 1 | ConvertFrom-Json

        # Filter out null or empty properties
        $filteredObject = @{}
        $jsonObject.PSObject.Properties.Where({ $null -ne $_.Value -and $_.Value -ne "" }) | ForEach-Object {
            $filteredObject[$_.Name] = $_.Value
        }

        # Convert back to JSON
        $body = $filteredObject | ConvertTo-Json -Depth 1


        $response = Invoke-RestMethod "http://82.180.136.148:3338/api/v1/transactions/$($transaction.id)" -Method 'PUT' -Headers $headers -Body $body
        $response
    }

}

