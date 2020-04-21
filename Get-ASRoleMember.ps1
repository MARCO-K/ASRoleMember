Function Get-ASRoleMember
{
  param(
    [string]$SqlInstance,
    [string]$role = 'Administrators' 
  )
  begin {
    Write-PSFMessage -Level Output -Message 'Getting user from AS role...'
    $null = [Reflection.Assembly]::LoadWithPartialName('Microsoft.AnalysisServices')
    $server = New-Object -TypeName Microsoft.AnalysisServices.Server
    $server.Connect($SqlInstance)
    $asrole = $server.Roles[$role]
  }
  process {   
    if ($asrole.Name -ne $null) 
    {
      Write-PSFMessage -Level Output -Message "Get members of role '$($asrole.Name)'"
      try 
      { 
        $members = $asrole.Members | Select-Object -Property @{ Name = 'SqlInstance';Expression = { $server.Name }}, @{ Nam = 'Role';Expression = { $asrole.Name }}, Name, SID
        Write-PSFMessage -Level Output -Message "Successfully retrieved members of role '$($asrole.Name)'"
      }
      catch 
      {
        Write-PSFMessage -Level Critical -Message "Failed to get members of role '$($asrole.Name)'"      
      }
    }
    else 
    {
      Write-PSFMessage -Level Output -Message "Role '$($asrole.Name)' does not exist"
    }
  }
  end { 
    $server.Disconnect()
    $members
    Write-PSFMessage -Level Output -Message "Completed getting members of role '$($asrole.Name)'"
  }
}