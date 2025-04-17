function Get-Account {
    [CmdletBinding()]
    param ()

    process {
        $url = [URI]::EscapeUriString("$BANKY_API_URL/api/v1/accounts")

        $response = Invoke-Api $url -Method 'GET'
        return $response
    }
}
