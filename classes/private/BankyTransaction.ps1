
class BankyCategory {
    [string]$id
    [datetime]$createdAt
    [datetime]$updatedAt
    [string]$name
    [bool]$positive
    [bool]$internal
    [BankyCategory[]]$subcategories
}
class BankyPaymentType {
    [string]$id
    [datetime]$createdAt
    [datetime]$updatedAt
    [string]$name
}

class BankyAccount {
    [string]$id
    [datetime]$createdAt
    [datetime]$updatedAt
    [string]$name
    [float]$ammount
    [float]$threshold
    [BankyPaymentType]$paymentType
}


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
    [AllowNull()][string]$id
    [string]$description
    [string]$date
    [decimal]$value
    [string]$account
    [string]$category
}
class UpdateBankyTransaction {
    [string]$id
    [AllowNull()][string]$description = $null
    [AllowNull()][string]$date = $null
    [AllowNull()][decimal]$value = $null
    [AllowNull()][string]$account = $null
    [AllowNull()][string]$category = $null

    UpdateBankyTransaction([string]$id) {
        $this.id = $id;
    }
}