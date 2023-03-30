## use generic regex parsed completion from --help
using namespace System.Management.Automation
using namespace System.Linq

function parseCompletions($command, $arguments) {
    [System.String[]] $output = &"$command" $arguments
    
    $output
    | Select-String '^  (?=-)(-\p{L}+)?(, )?(--[\p{L}-]+=?)\w*\s*(.*)' 
    | Select-Object -ExpandProperty Matches
    | ForEach-Object {
        if ($_.Success) {
            $m = $_;
            try {
                ## 2 dashes
                if ($_.Groups[3].Value -ne "") {
                    $completion = $_.Groups[3].Value
                    $listItem = $_.Groups[3].Value
                    $tooltip = $_.Groups[4].Value
                    [System.Management.Automation.CompletionResult]::new($completion, $listItem, 'ParameterValue', "[$tooltip]")
                }
                ## 1 dash
                else {
                    $completion = $_.Groups[1].Value
                    $listItem = $_.Groups[1].Value
                    $tooltip = $_.Groups[4].Value
                    [System.Management.Automation.CompletionResult]::new($completion, $listItem, 'ParameterValue', "[$tooltip]")
                }
            }
            catch {
                Write-Warning $m
            }
            
        }
    }
    }

Register-ArgumentCompleter `
    -Native `
    -CommandName @( 
    "sinfo", "sbatch", "srun", "salloc"
    ) `
    -ScriptBlock {
    param($wordToComplete, [Language.CommandAst] $commandAst, $cursorPosition)
    $commandstring = $commandAst.Extent.Text
    parseCompletions "$commandstring" "--help"
}
