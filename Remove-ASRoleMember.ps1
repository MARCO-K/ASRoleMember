Function Remove-ASRoleMember
{
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