Function Remove-ASRoleMember
{
  <#
    .SYNOPSIS
    This cmdlet will remove a  member of a AS server role.

    .DESCRIPTION
    This cmdlet will remove a  member of a AS server role.

    .PARAMETER SqlInstance
    The name of the SQL server instance.

    .PARAMETER role
    Name of the AS server role.

    .PARAMETER user
    Name of the user you want to remove.
    User and and group names without domain are accepted.

    .EXAMPLE
    Remove-ASRoleMember -SqlInstance Server\instance -role 'Administrators' -user Value 'user'
    It will remove the 'user' to the role Administrators'.
  #>


  param(
    [string]$SqlInstance,
    [string]$role = 'Administrators',
    [string]$user 
  )
  begin {
    Write-PSFMessage -Level Output -Message 'Removing user from AS role...'
    $null = [Reflection.Assembly]::LoadWithPartialName('Microsoft.AnalysisServices')
    $server = New-Object -TypeName Microsoft.AnalysisServices.Server
    $server.Connect($SqlInstance)
    $asrole = $server.Roles[$role]
  }
  process { 
    if($asrole.Members.Name -contains $user)
    {
      Write-PSFMessage -Level Output -Message "Removing user '$user' from role '$($asrole.Name)'"
      try { 
        $mem = $asrole.Members | Where-Object { $_.Name -eq $user}
        $asrole.Members.Remove($mem)
        $asrole.Update()
        Write-PSFMessage -Level Output -Message "Successfully removed user '$user' from role '$($asrole.Name)'"
      }
      catch {
        Write-PSFMessage -Level Critical -Message "Failed to remove user '$user' from role '$($asrole.Name)'" -ErrorRecord $_ -Exception $_.Exception
      }
    }
    else {
      Write-PSFMessage -Level Output -Message "User '$user' is not member of role '$($asrole.Name)'"
    }
  }
  end {
    $server.Disconnect()
    Write-PSFMessage -Level Output -Message "Completed removing user '$user' from role '$($asrole.Name)'"
  }
}