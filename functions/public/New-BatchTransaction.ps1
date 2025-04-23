

function New-BatchTransaction {
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline)]
        # [ValidateSet('Create', 'Update', 'Transfer', 'Delete')]
        [string]$action
    )
    begin {

    }
    process {
        if ($PSItem -eq $null ) {
            throw 'Do not use this for unique processes as it adds more complexity than needed';
        }

        # Action to be executed
        $action = $PSItem.action
        
        #region  Common parameters
        $params = @{
            description       = $PSItem.description
            value             = $PSItem.value
            AccountMatchExact = $PSItem.AccountMatchExact
        }
        if ($PSItem.account) {
            $params.account = $PSItem.account
        }
        if ($PSItem.category) {
            $params.category = $PSItem.category
        }
        if ($PSItem.date) {
            $params.date = $PSItem.date
        }
        #endregion

        #region Update Command
        if ($PSItem.id) {
            $params.id = $PSItem.id
        }
        #endregion

        #region Transfer Parameters
        if ($PSItem.Origin) {
            $params.Origin = $PSItem.Origin
        }
        if ($PSItem.Destiny) {
            $params.Destiny = $PSItem.Destiny
        }
        #endregion
        

        switch ($action) {
            Create {
                New-Transaction @params
            }
            Update {
                Update-Transaction @params
            }
            Transfer {
                New-TransferTransaction  @params
            }
            Default {
                throw "$action not implemented"
            }
        }
        $params = {}
    }
}