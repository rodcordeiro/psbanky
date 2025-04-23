

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

        #  Common parameters
        $account = $PSItem.account
        $category = $PSItem.category
        $description = $PSItem.description
        $value = $PSItem.value
        $AccountMatchExact = $PSItem.AccountMatchExact
        $id = $PSItem.id


        # Transfer Parameters
        $Origin = $PSItem.Origin
        $Destiny = $PSItem.Destiny

        if ($PSItem.date) {
            $date = $PSItem.date
        }

        switch ($action) {
            Create {
                New-Transaction -account $account -category $category -description $description -value $value -date $date -AccountMatchExact:$accountMatchExact
            }
            Update {
                Update-Transaction -id $id  -account $Account -category $category -description $description -value $value -date $date -AccountMatchExact:$accountMatchExact
            }
            Transfer {
                New-TransferTransaction -Origin $origin -Destiny $Destiny -description $description -value $value -date $date -AccountMatchExact:$accountMatchExact
            }
            Default {
                throw "$action not implemented"
            }
        }
    }
}