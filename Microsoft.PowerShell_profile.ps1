Import-Module pscomplete
# --- load options
Import-Module "$PSScriptRoot/__options.psm1"
# --- parse some completions with regex
Import-Module "$PSScriptRoot/__complete-basic.psm1"
# --- enable tab completions from bash 
Import-Module "$PSScriptRoot/__complete-bash.psm1"
# --- enable functions
Import-Module "$PSScriptRoot/__functions.psm1"

