# This file contains a set of functions used to format text,
# and make printing text a little easier. Feel free to put
# any additional functions you need for formatting your shell
# output text.

# Colors
$BOLD_RED_COLOR="`e[1m`e[31m"

# Indents the text 2 spaces
# example:
#   Write-Host "Hello" | Indent
function Indent {
  process {
    foreach($Line in $_) {
      Write-Host "  $Line"
    }
  }
}

# Prints out an arrow to your custom notice
# example:
#   Notice "Installing new magic"
function Notice($Message) {
  Write-Host "`n▸ $Message`n"
}

# Prints out a check mark and Done.
# example:
#   PrintDone
function PrintDone {
  Write-Host "✔ Done`n" | Indent
}
