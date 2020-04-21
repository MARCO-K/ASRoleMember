Function Add-ASRoleMember
{
  param(
    [string]$SqlInstance,
    [string]$role = 'Administrators',
    [string]$user 
  )
  begin {
    Write-PSFMessage -Level Output -Message 'Adding user to AS role...'
    $null = [Reflection.Assembly]::LoadWithPartialName('Microsoft.AnalysisServices')
    $server = New-Object -TypeName Microsoft.AnalysisServices.Server
    $server.Connect($SqlInstance)
    $asrole = $server.Roles[$role]
  }
  process { 
    if ($asrole.Members.Name -ne $null -and $asrole.Members.Name -notcontains $user) 
    {
      Write-PSFMessage -Level Output -Message "Adding user '$user' to role '$($asrole.Name)'"
      try 
      {
        $null = $asrole.Members.Add($user)
        $asrole.Update()
        Write-PSFMessage -Level Output -Message "Successfully added user '$user' to role '$($asrole.Name)'"
      }
      catch 
      {
        Write-PSFMessage -Level Critical -Message "Failed to add user '$user' to role '$($asrole.Name)'" -ErrorRecord $_ -Exception $_.Exception
      } 
    }
    else 
    {
      Write-PSFMessage -Level Output -Message "User '$user' is already member of role '$($asrole.Name)'"
    }
  }
  end { 
    $null = $server.Disconnect
    Write-PSFMessage -Level Output -Message "Completed adding user '$user' to role '$($asrole.Name)'"
  }
}