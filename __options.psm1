Set-PSReadLineOption -CompletionQueryItems 100
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -HistorySavePath ~/.bash_history

function prompt {
    Write-Host  "$(Get-Location)" -ForegroundColor Green
    "❯ "
}

# --- aliases

Set-Alias -Name 'clip'  -Value Set-Clipboard
Set-Alias -Name "ps"    -Value Get-Process
Set-Alias -Name "kill"  -Value Stop-Process
function ls() {
    Get-ChildItem $args
    | Format-Table -Property Name, Size, UnixMode, FullName, Extension -HideTableHeaders
}
function lsr {
    Get-ChildItem -Recurse $args | ForEach-Object{$_.FullName}
}
Set-Alias -Name 'lsa'  -Value Get-ChildItem
Set-Alias -Name 'map'  -Value %

function update-pwshserver {
    Set-Location ~/.config/powershell
    git reset --hard
    git pull
}

# --- keybinds

function SetupKeybinds() {
    Set-PSReadLineKeyHandler -Chord 'Alt+a' -Function SelectBackwardsLine
    Set-PSReadLineKeyHandler -Chord 'Alt+s' -Function AcceptNextSuggestionWord
    Set-PSReadLineKeyHandler -Chord 'Alt+x' -Function HistorySearchForward
    Set-PSReadLineKeyHandler -Chord 'Alt+z' -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Chord 'Ctrl+a' -Function SelectLine
    Set-PSReadLineKeyHandler -Chord 'Ctrl+Home' -Function SelectBackwardsLine
    Set-PSReadLineKeyHandler -Chord 'Ctrl+l' -Function ClearScreen
    Set-PSReadLineKeyHandler -Chord 'Ctrl+LeftArrow' -Function ShellBackwardWord
    Set-PSReadLineKeyHandler -Chord 'Ctrl+RightArrow' -Function ShellForwardWord
    Set-PSReadLineKeyHandler -Chord 'Ctrl+Shift+LeftArrow' -Function SelectShellBackwardWord
    Set-PSReadLineKeyHandler -Chord 'Ctrl+Shift+RightArrow' -Function SelectShellForwardWord
    Set-PSReadLineKeyHandler -Chord 'Ctrl+UpArrow' -ScriptBlock { [Microsoft.PowerShell.PSConsoleReadLine]::Insert('dotnet fsi ') }
    Set-PSReadLineKeyHandler -Chord 'F11' -Function SelectBackwardsLine
    Set-PSReadLineKeyHandler -Chord 'F12' -Function MenuComplete
    Set-PSReadLineKeyHandler -Chord 'Shift+End' -Function SelectShellForwardWord
    Set-PSReadLineKeyHandler -Chord 'Shift+Home' -Function SelectBackwardsLine
    Set-PSReadLineKeyHandler -Chord "Alt+Enter" -ScriptBlock { [Microsoft.PowerShell.PSConsoleReadLine]::AcceptSuggestion() }
}

SetupKeybinds;

# --- environment
function SetEnvironment(){
    # $env:LD_LIBRARY_PATH += ":$pwd"
}

SetEnvironment;



function source([string]$envname){
    ./"$envname"/bin/Activate.ps1
}
$PsCompleteSettings.ForceClearBeforeUse = $true;
