
class BankyCategory {
    [string]$id
    [datetime]$createdAt
    [datetime]$updatedAt
    [string]$name
    [bool]$positive
    [bool]$internal
    [BankyCategory[]]$subcategories
}