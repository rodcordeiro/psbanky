class BankyAuthenticationResponse {
    [string]$accessToken
    [Nullable[TimeSpan]]$expires
    [string]$refreshToken
    [bool]$authenticated
    [string]$expirationDate

    [void]GetExpirationDate() {
        if ($this.expires) {
            $this.expirationDate = [DateTimeOffset]::FromUnixTimeMilliseconds($this.expires.Ticks).LocalDateTime.toString()
            $this.expires = $null
        }
    }
}