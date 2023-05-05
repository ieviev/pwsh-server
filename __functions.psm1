## some convenience functions with type info
function ls()
{
    [OutputType([System.IO.FileSystemInfo])]
    Param (
        [parameter(Mandatory=$false)]
        [System.String]
        $args
    )
    $items = Get-ChildItem $args # | Sort-Object -Property Name 
    return $items
}

# ls files
function lsf()
{
    [OutputType([System.IO.FileSystemInfo])]
    Param (
        [parameter(Mandatory=$false)]
        [System.String]
        $args
    )
    $items = Get-ChildItem $args -File
    return $items
}


# ls contents by pattern
function lsc()
{
    [OutputType([System.IO.FileSystemInfo])]
    Param (
        [parameter(Mandatory=$true, Position=0)]
        [System.String]
        $pattern,
        [parameter(Mandatory=$false)]
        [System.String]
        $filter,
        [parameter(Mandatory=$false)]
        [bool]
        $noRecurse,
        [parameter(Mandatory=$false)]
        [int]
        $ctx
    )
    
    if ($noRecurse) {
        $items = 
        Get-ChildItem -Path $filter -File
        | Select-String -Pattern $pattern -Context $ctx
    }
    else {
        $items = 
        Get-ChildItem -Path $filter -File -Recurse
        | Select-String -Pattern $pattern -Context $ctx
    }
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
Set-Alias -Name "ps"    -Value Get-Process
Set-Alias -Name "kill"  -Value Stop-Process

function update-pwshserver {
    Set-Location ~/.config/powershell
    git reset --hard
    git pull
}

## copy-to-verbose
function cpv()
{   
    Param (
        [parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [System.String]
        $source,
        [parameter(Mandatory=$true, ValueFromPipeline=$false, Position=1)]
        [System.String]
        $dest
    )
    Copy-Item -Path $source -Destination $dest -Verbose
    return $items
}

## send sigterm to process
function term()
{   
    Param (
        [parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [System.Diagnostics.Process]
        $process
    )
    /bin/kill -15 $process.Id
    return $items
}


## locate

function l()
{
    [OutputType([System.String])]
    Param (
        [parameter(Mandatory=$true)]
        [System.String]
        $args
    )
    $items = locate $args 
    return $items
}


## concat with arg
function concat
{
    [OutputType([System.String])]
    Param (
        [parameter(Mandatory=$false, ValueFromPipeline=$false, Position=0)]
        [System.String]
        $sep,
        [parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [psobject]
        $input
    )
    $output = $input | Join-String -Separator "$sep"
    return $output
}


## source python env convenience function
function source
{
    [OutputType([System.String])]
    Param (
        [parameter(Mandatory=$false, ValueFromPipeline=$false, Position=0)]
        [System.String]
        $envname
    )
    if ("$envname" -ne "" ) {
        ./"$envname"/bin/Activate.ps1
    }
    else {
        ./env/bin/Activate.ps1
    }
    $output = $input | Join-String -Separator "$sep"
    return $output
}



