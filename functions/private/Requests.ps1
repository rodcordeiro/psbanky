function Invoke-Api {
    param(
        [uri]$Uri,
        [string]$Method,
        [AllowNull()][Object]$Body
    )
    begin {
        if (!(Test-Path "$($(Resolve-Path -Path $env:USERPROFILE).Path)\.banky" -ErrorAction Stop)) {
            throw "Banky not found. Please configure it."
        }
        [BankyAuthenticationResponse]$bankyAuth = $(Get-Content "$($(Resolve-Path -Path $env:USERPROFILE).Path)\.banky" -ErrorAction Stop | ConvertFrom-Json )

        $isExpired = [datetime]::Parse($bankyAuth.expirationDate) -lt [DateTime]::Now

        if ($isExpired) {
            try {
                $cred = $bankyAuth.GetCredentials()
                New-BankyAuthentication @cred
            }
            catch {
                Throw "Login expirado, autentique novamente"
            }
        }

        $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
        $headers.Add("Content-Type", "application/json")
        $headers.Add("Authorization", "Bearer $($bankyAuth.accessToken)")

    }
    process {
        $response = Invoke-RestMethod $Uri -Method $Method -Headers $headers -Body $Body
        return $response
    }
}