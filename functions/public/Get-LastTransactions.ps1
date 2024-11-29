function Get-LastTransactions {
    <#
.SYNOPSIS
    Retrieves the last N transactions
.EXAMPLE
    Get-LastTransactions
.OUTPUTS
    [System.Object[]]
        Returns an array of transactions data.
.NOTES
    Version: 1.0
#>
    [CmdletBinding()]
    param ()
    begin {
        if (!(Test-Path "$($(Resolve-Path -Path $env:USERPROFILE).Path)\.banky" -ErrorAction Stop)) {
            throw "Banky not found. Please configure it."
        }
        [BankyAuthenticationResponse]$bankyAuth = $(Get-Content "$($(Resolve-Path -Path $env:USERPROFILE).Path)\.banky" -ErrorAction Stop | ConvertFrom-Json )

        $isExpired = [datetime]::Parse($bankyAuth.expirationDate) -lt [DateTime]::Now

        if ($isExpired) {
            Throw "Login expirado, autentique novamente"
        }

        $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
        $headers.Add("Content-Type", "application/json")
        $headers.Add("Authorization", "Bearer $($bankyAuth.accessToken)")
        
        
    }
    process {

        
        $response = Invoke-RestMethod 'http://82.180.136.148:3338/api/v1/transactions' -Method 'GET' -Headers $headers
        [BankyTransaction[]]$items = $response.items
        foreach ($transaction in $items) {
            $transaction
        }
    }
}
