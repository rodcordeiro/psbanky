function Get-Account {
    [CmdletBinding()]
    param ()

    process {
        $url = "/api/v1/accounts"

        $response = Invoke-Api $url -Method 'GET'
        return $response
    }
}
