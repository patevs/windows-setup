# setup.ps1
# ---------

# Test if running as administrator
# http://serverfault.com/questions/95431
function Test-Elevated {
  # Get the ID and security principal of the current user account
  $userID = [System.Security.Principal.WindowsIdentity]::GetCurrent()
  $userPrincipal = New-Object System.Security.Principal.WindowsPrincipal($userID)
  # Check to see if we are currently running "as Administrator"
  return $userPrincipal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
}

# TODO: Exit if not running as administrator

Push-Location ("scripts")

# From within the ./scripts directory...
.\deps.ps1

Pop-Location

# EOF #
