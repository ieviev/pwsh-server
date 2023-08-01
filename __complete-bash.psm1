## use bash tab completion for commands
Register-ArgumentCompleter `
    -Native `
    -CommandName @( 
        "apt",
        "dd", 
        "docker",
        "du", 
        "find", 
        "flatpak", 
        "gh",
        "git",
        "gpg",
        "hcitool", 
        "ip", 
        "journalctl", 
        "ldd"
        "lzma"
        "nc",
        "pacmd", 
        "pactl", 
        "rclone", 
        "scp", 
        "ssh",
        "systemctl", 
        "tar"
    ) `
    -ScriptBlock {
    param($commandName, [System.Management.Automation.Language.CommandAst] $commandAst, $cursorPosition)
    $bashcomplete = $commandAst.Extent.Text
    if ($cursorPosition -gt $commandAst.Extent.Text.Length) {
        $bashcomplete += " "
    }
    $defaultResults = 
        bash $PSScriptRoot/get_bashcompletions.sh $bashcomplete
        | ForEach-Object {
            [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
        }
    switch ("$commandAst") {
        "tar" {
            $defaultResults += [System.Management.Automation.CompletionResult]::new("-xvzf", "-xvzf", 'ParameterValue', "-xvzf")
            $defaultResults += [System.Management.Automation.CompletionResult]::new("-cvzf", "-cvzf", 'ParameterValue', "-cvzf")
            $defaultResults;
        }
        default { $defaultResults; }
    }
}
 