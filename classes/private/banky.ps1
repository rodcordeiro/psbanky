class BankyAuthenticationResponse {
    [string]$accessToken
    [Nullable[TimeSpan]]$expires
    [string]$refreshToken
    [bool]$authenticated
    [string]$expirationDate
    [string]$username
    [string]$key

    [void]GetExpirationDate() {
        if ($this.expires) {
            $this.expirationDate = [DateTimeOffset]::FromUnixTimeMilliseconds($this.expires.Ticks).LocalDateTime.toString()
            $this.expires = $null
        }
    }
    [pscustomobject] GetCredentials() {
        return @{
            Username = $this.username
            Password = $(Protect-String $this.key)
        }
    }
}
