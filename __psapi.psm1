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

