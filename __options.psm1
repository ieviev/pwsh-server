Set-PSReadLineOption -CompletionQueryItems 100
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -HistorySavePath ~/.bash_history

function prompt {
    Write-Host  "$(Get-Location)" -ForegroundColor Green
    "❯ "
}


# --- keybinds
Import-Module $PSScriptRoot/__psapi.psm1

function SetupKeybinds() {
    Set-PSReadLineKeyHandler -Chord 'Alt+s' -Function AcceptNextSuggestionWord
    Set-PSReadLineKeyHandler -Chord 'Alt+x' -Function HistorySearchForward
    Set-PSReadLineKeyHandler -Chord 'Alt+z' -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Chord 'Ctrl+a' -Function SelectBackwardsLine
    Set-PSReadLineKeyHandler -Chord 'Ctrl+Home' -Function SelectBackwardsLine
    Set-PSReadLineKeyHandler -Chord 'Ctrl+l' -Function ClearScreen
    Set-PSReadLineKeyHandler -Chord 'Ctrl+LeftArrow' -Function ShellBackwardWord
    Set-PSReadLineKeyHandler -Chord 'Ctrl+RightArrow' -Function ShellForwardWord
    Set-PSReadLineKeyHandler -Chord 'Ctrl+Shift+LeftArrow' -Function SelectShellBackwardWord
    Set-PSReadLineKeyHandler -Chord 'Ctrl+Shift+RightArrow' -Function SelectShellForwardWord
    Set-PSReadLineKeyHandler -Chord 'F11' -Function SelectBackwardsLine
    Set-PSReadLineKeyHandler -Chord 'F12' -Function MenuComplete
    Set-PSReadLineKeyHandler -Chord 'Shift+End' -Function SelectShellForwardWord
    Set-PSReadLineKeyHandler -Chord 'Shift+Home' -Function SelectBackwardsLine
    Set-PSReadLineKeyHandler -Chord "Alt+Enter" -ScriptBlock { [Microsoft.PowerShell.PSConsoleReadLine]::AcceptSuggestion() }
    Set-PSReadLineKeyHandler -Chord 'Ctrl+F5' -ScriptBlock { psPaste 'git clone ' }
    Set-PSReadLineKeyHandler -Chord 'Ctrl+F8' -ScriptBlock { psPaste 'du -sh * | sort -h ' }

    #// some common pipes 
    # filter / alt + shift + l
    Set-PSReadLineKeyHandler -Chord 'alt+l' -ScriptBlock { 
        psCursorEnd;
        psPaste('| ?{ $_. }')
        psCursorLeft(2);
    }
    # map / alt + shift + m
    Set-PSReadLineKeyHandler -Chord 'alt+m' -ScriptBlock { 
        psCursorEnd;
        psPaste('| %{ $_. }')
        psCursorLeft(2);
    }
    Set-PSReadLineKeyHandler -Chord 'alt+L' -ScriptBlock { 
        psPaste '-match ""' 
        psCursorLeft(1);
    }

}

SetupKeybinds;

# --- environment
function SetEnvironment(){
    # $env:LD_LIBRARY_PATH += ":$pwd"
}

SetEnvironment;

# --- load formatting data

function setupFormatting () {
    Update-TypeData -AppendPath "$PSScriptRoot/formatting/FileInfo.ps1xml"
    Update-FormatData -PrependPath "$PSScriptRoot/formatting/ls.Format.ps1xml"
}

setupFormatting;

# --- some configs

function source([string]$envname){
    ./"$envname"/bin/Activate.ps1
}

