function Invoke-Api {
    param(
        [uri]$Uri,
        [string]$Method,
        [AllowNull()][Object]$Body
    )
    begin {
        try {
            $cred = Get-StoredCredential -Target "BANKY"
            if (-not $cred) {
                throw "Credenciais não encontradas. Reautentique."
            }
            Invoke-Authentication -username $Cred.username -Password (Protect-String $Cred.GetNetworkCredential().password)
        }
        catch {
            Throw "Login expirado. Reautentique."
        }


        $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
        $headers.Add("Content-Type", "application/json")
        $headers.Add("Authorization", "Bearer $($script:BANKY_AUTH_TOKEN)")

    }
    process {
        $response = Invoke-RestMethod $Uri -Method $Method -Headers $headers -Body $Body
        return $response
    }
}