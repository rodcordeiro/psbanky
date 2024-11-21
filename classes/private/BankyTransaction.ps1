class BankyTransaction {
    [string]$id
    [datetime]$createdAt
    [datetime]$updatedAt
    [string]$description
    [datetime]$date
    [decimal]$value
    [BankyAccount]$account
    [BankyCategory]$category
}

class CreateBankyTransaction {
    [string]$description
    [string]$date 
    [decimal]$value
    [string]$account
    [string]$category
}