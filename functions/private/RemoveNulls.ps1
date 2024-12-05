function Remove-Null {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", Justification = "Not applicable")]
    param(
        [Parameter(ValueFromPipeline)]
        [PSCustomObject]$entityIn
    )
    process {
        $entity = @{}

        $entityIn.PSObject.Properties.Where({ $null -ne $_.Value -and $_.Value -ne "" }) | ForEach-Object {
            $entity[$_.Name] = $_.Value
        }

        return $entity
    }
}