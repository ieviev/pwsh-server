Set-PSReadLineOption -CompletionQueryItems 1000
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -HistorySavePath ~/.bash_history
Set-PSReadLineOption -MaximumHistoryCount 999999

function prompt {
    Write-Host  "$(Get-Location)" -ForegroundColor Green
    "❯ "
}


# --- keybinds
Import-Module $PSScriptRoot/__psapi.psm1

# register keys that pwsh linux wont register to f13-f24
function SetupFnKeybinds() {
    Set-PSReadLineKeyHandler -Chord 'F13' -Function SelectBackwardsLine  # Shift+Home
    Set-PSReadLineKeyHandler -Chord 'F14' -Function SelectLine           # Shift+End
    # F15 wont be registered
    # Set-PSReadLineKeyHandler -Chord 'F15' -ScriptBlock { psPaste '%{ $_. } '; psCursorLeft(3) } # Ctrl+m
    Set-PSReadLineKeyHandler -Chord 'F16' -ScriptBlock { psPaste '%{ $_. } '; psCursorLeft(3) } # Ctrl+m
    Set-PSReadLineKeyHandler -Chord 'F17' -ScriptBlock { psPaste '%{ $_. } '; psCursorLeft(3) } # Ctrl+m
    Set-PSReadLineKeyHandler -Chord 'F18' -ScriptBlock { psPaste '%{ $_. } '; psCursorLeft(3) } # Ctrl+m
}

SetupFnKeybinds;

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
    Set-PSReadLineKeyHandler -Chord 'F12' -Function MenuComplete
    Set-PSReadLineKeyHandler -Chord 'F9' -Function SelectLine
    Set-PSReadLineKeyHandler -Chord "Alt+Enter" -ScriptBlock { [Microsoft.PowerShell.PSConsoleReadLine]::AcceptSuggestion() }
    Set-PSReadLineKeyHandler -Chord 'Ctrl+F5' -ScriptBlock { psPaste 'git clone ' }
    Set-PSReadLineKeyHandler -Chord 'Ctrl+F8' -ScriptBlock { psPaste 'du -sh * | sort -h ' }
    
    Set-PSReadLineKeyHandler -Chord 'Ctrl+UpArrow' -ScriptBlock { psCursorPrevPipeStart; }
    Set-PSReadLineKeyHandler -Chord 'Ctrl+DownArrow' -ScriptBlock { psCursorNextPipeStart; }

    #// some common pipes 
    # filter / alt + shift + l
    Set-PSReadLineKeyHandler -Chord 'alt+L' -ScriptBlock { 
        psCursorEnd;
        psPaste('| ?{ $_. }')
        psCursorLeft(2);
    }
    # map / alt + shift + m
    Set-PSReadLineKeyHandler -Chord 'alt+M' -ScriptBlock { 
        psCursorEnd;
        psPaste('| %{ $_. }')
        psCursorLeft(2);
    }
    # match input with regex 
    Set-PSReadLineKeyHandler -Chord 'alt+N' -ScriptBlock { 
        psPaste '-match ""' 
        psCursorLeft(1);
    }
    # ctrl + \ to pipe
    Set-PSReadLineKeyHandler -Chord 'ctrl+Oem5' -ScriptBlock { 
        psCursorEnd;
        psPaste "```n| "
    }
    # disk usage in current dir sorted / alt + shift + D
    Set-PSReadLineKeyHandler -Chord 'alt+D' -ScriptBlock { 
        psPaste 'du -sh * | sort -h '
    }
    # ls dir
    Set-PSReadLineKeyHandler -Chord 'alt+l' -ScriptBlock { 
        psPaste "ls "
        [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
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


