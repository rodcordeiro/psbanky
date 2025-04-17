function Get-Category {
    [CmdletBinding()]
    param ()
    process {
        $url = [URI]::EscapeUriString("$BANKY_API_URL/api/v1/categories")
        $response = Invoke-Api $url -Method 'GET'
        return $response
    }
}
