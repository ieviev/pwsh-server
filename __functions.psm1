## some strongly-typed convenience functions
function ls()
{
    [OutputType([System.IO.FileSystemInfo])]
    Param (
        [parameter(Mandatory=$false)]
        [System.String]
        $args
    )
    $items = Get-ChildItem $args 
    return $items
}

function lsr()
{
    [OutputType([System.IO.FileSystemInfo])]
    Param (
        [parameter(Mandatory=$false)]
        [System.String]
        $args
    )
    $items = Get-ChildItem -Recurse $args 
        | ForEach-Object{$_.FullName}
    return $items
}

Set-Alias -Name 'clip'  -Value Set-Clipboard
## ex. ps python | kill
Set-Alias -Name "ps"    -Value Get-Process
Set-Alias -Name "kill"  -Value Stop-Process
Set-Alias -Name 'map'  -Value %

function update-pwshserver {
    Set-Location ~/.config/powershell
    git reset --hard
    git pull
}