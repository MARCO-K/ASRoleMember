# ASRoleMember
This module will modify members of Analysis Server roles.
It uses Windows PowerShell and AMO to get the various Server properties of SQL Server Analysis Service and modifies the role membership of the server roles.
## Add-ASRoleMember
This cmdlet will add a new member to a AS server role.

`Add-ASRoleMember -SqlInstance 'Server\instance' -role 'Administrators' -user Value 'user'`

It will add 'user' to the role 'Administrators'.

## Get-ASRoleMember
This cmdlet will get all members of a AS server role.

`Get-ASRoleMember -SqlInstance 'Server\instance' -role 'Administrators'`

It will retrieve all users of the role 'Administrators'.

## Remove-ASRoleMember
This cmdlet will remove a  member of a AS server role.

`Remove-ASRoleMember -SqlInstance 'Server\instance' -role 'Administrators' -user Value 'user'`

It will remove the 'user' to the role 'Administrators'.
