## powershell internals for cursor position and buffer

function psCursorLeft([int] $by) {
    $buffer = ''
    $cursorPosition = 0
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$buffer, [ref]$cursorPosition)
    if ($buffer -eq '') { return }
    [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursorPosition - $by)
}

function psCursorRight([int] $by) {
    $buffer = ''
    $cursorPosition = 0
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$buffer, [ref]$cursorPosition)
    if ($buffer -eq '') { return }
    [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursorPosition + $by)
}
function psCursorEnd() {
    $buffer = ''
    $cursorPosition = 0
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$buffer, [ref]$cursorPosition)
    if ($buffer -eq '') { return }
    [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($buffer.Length)
}

function psCursorStart() {
    [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition(0)
}

function psPaste([string] $text) {
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert($text)
}

function psCopyBuffer([string] $text) {
    $buffer = ''
    $cursorPosition = 0
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$buffer, [ref]$cursorPosition)
    /usr/bin/echo -n "'$buffer'" | xclip -sel clip -i
}

function psCursorPrevPipeStart() {
    $buffer = ''
    $cursorPosition = 0
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$buffer, [ref]$cursorPosition)
    if (($buffer -eq '') -or ($cursorPosition -eq 0)) { return }
    
    $currentPipeIndex = $buffer.LastIndexOf("|",$cursorPosition)
    if ($currentPipeIndex -eq -1) { $currentPipeIndex = 0; }

    if ($cursorPosition -eq $currentPipeIndex) {
        $prevPipeIndex = $buffer.LastIndexOf("|",$currentPipeIndex - 1)
        if ($prevPipeIndex -eq -1) { $prevPipeIndex = 0; }
        [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($prevPipeIndex)
    }
    else {
        [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($currentPipeIndex)
    }
}

function psCursorNextPipeStart() {
    $buffer = ''
    $cursorPosition = 0
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$buffer, [ref]$cursorPosition)
    if ($buffer -eq '') { return }
    
    $currentPipeIndex = $buffer.IndexOf("|",$cursorPosition)
    if ($currentPipeIndex -eq -1) { $currentPipeIndex = 0; }

    if ($cursorPosition -eq $currentPipeIndex) {
        $nextPipeIndex = $buffer.IndexOf("|",$currentPipeIndex + 1)
        if ($nextPipeIndex -eq -1) { return; }
        [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($nextPipeIndex)
    }
    else {
        [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($currentPipeIndex)
    }
}