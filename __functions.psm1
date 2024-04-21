## some convenience functions with type info
function ls()
{
    [OutputType([System.IO.FileSystemInfo])]
    Param (
        [parameter(Mandatory=$false)]
        [System.String]
        $args,
        [parameter(Mandatory=$false)]
        [switch]
        $l,
        [parameter(Mandatory=$false)]
        [switch]
        $la,
        [parameter(Mandatory=$false)]
        [switch]
        $h
    )
    if ($h) {
        Get-ChildItem -help
    }
    elseif ($la) {
        if ($args.Length -eq 0) {
            /usr/bin/ls -la    
        }
        else {
            /usr/bin/ls -la "$args"
        }
    }
    elseif ($l) {
        if ($args.Length -eq 0) {
            /usr/bin/ls -l
        }
        else {
            /usr/bin/ls -l "$args"
        }
    }
    else {
        if ($args.Length -eq 0) {
            Get-ChildItem  # | Sort-Object -Property Name 
        }
        else {
            Get-ChildItem -Path "$args" # | Sort-Object -Property Name 
        }
        
    }
    
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
        [psobject]
        $source,
        [parameter(Mandatory=$true, ValueFromPipeline=$false, Position=1)]
        [System.String]
        $dest
    )
    $source | Copy-Item -Destination $dest -Verbose
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

## merge files to one ex. ls *.txt | merge combined.txt 
function merge
{
    Param (
        [parameter(Mandatory=$false, ValueFromPipeline=$false, Position=0)]
        [System.String]
        $outputFile,
        [parameter(Mandatory=$true, ValueFromPipeline=$true, Position=1)]
        [psobject]
        $inputFiles
    )
    $input | get-content | set-content $outputFile
    return $output
}


## source python env by name ex. 'source venv'
function source
{
    [OutputType([System.String])]
    Param (
        [parameter(Mandatory=$false, ValueFromPipeline=$false, Position=0)]
        [System.String]
        $envname
    )
    if ("$envname" -ne "" ) {
        &"./$envname/bin/Activate.ps1"
    }
    else {
        ./env/bin/Activate.ps1
    }
    $output = $input | Join-String -Separator "$sep"
    return $output
}


# TODO:
# function replaceInFile
# {
#     [OutputType([System.String])]
#     Param (
#         [parameter(Mandatory=$false, ValueFromPipeline=$false, Position=0)]
#         [System.String]
#         $pattern,
#         [parameter(Mandatory=$false, ValueFromPipeline=$false, Position=1)]
#         [System.String]
#         $replacement,
#         [parameter(Mandatory=$true, ValueFromPipeline=$true)]
#         [psobject]
#         $inputFilePath
#     )
#     $output = $input | Join-String -Separator "$sep"
#     return $output
# }

## count of lines in file
function lines
{
    [OutputType([System.Int32])]
    Param (
        [parameter(Mandatory=$false, ValueFromPipeline=$true, Position=0)]
        [psobject]
        $filePath
    )
    return (get-content $filePath).Length
}

function sum {
    BEGIN { $x = 0 }
    PROCESS { $x += $_ }
    END { $x }
}

function count {
    BEGIN { $x = 0 }
    PROCESS { $x += 1 }
    END { $x }
}

function average {
    BEGIN { $max = 0; $curr = 0 }
    PROCESS { $max += $_; $curr += 1 }
    END { $max / $curr }
}

# behave like a grep command
# but work on objects, used
# to be still be allowed to use grep
filter match( $reg ) {
    if ($_.tostring() -match $reg)
    { $_ }
}

# behave like a grep -v command
# but work on objects
filter exclude( $reg ) {
    if (-not ($_.tostring() -match $reg))
    { $_ }
}

# behave like match but use only -like
filter like( $glob ) {
    if ($_.toString() -like $glob)
    { $_ }
}

filter unlike( $glob ) {
    if (-not ($_.tostring() -like $glob))
    { $_ }
}
