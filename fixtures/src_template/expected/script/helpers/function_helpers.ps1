# This file contains a set of functions used as helpers
# for various tasks. Read the examples for each one for
# more information. Feel free to put any additional helper
# functions you may need for your app


# Returns true if the command $Command is not found
# example:
#   if (CommandNotFound "yarn") {
#     echo "no yarn"
#   }
function CommandNotFound($Command) {
  try {
    Get-Command -Name $Command -ErrorAction | Out-Null
    return $false
  } catch {
    return $true
  }
}

# Returns true if the command $Command is not running
# You must supply the full command to check as an argument
# example:
#   if (CommandNotRunning "redis-cli ping") {
#     PrintError "Redis is not running"
#   }
function CommandNotRunning($Command) {
  Invoke-Expression $Command
  if ($LASTEXITCODE -ne 0) {
    return $true
  } else {
    return $false
  }
}

# Prints error and exit.
# example:
#   PrintError "Redis is not running. Run it with some_command"
function PrintError($Message) {
  Write-Host -ForegroundColor Red "There is a problem with your system setup:`n`n"
  Write-Host -ForegroundColor Red  "$Message `n`n" | Indent
}
