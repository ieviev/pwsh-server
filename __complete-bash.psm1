## use bash tab completion for commands
Register-ArgumentCompleter `
    -Native `
    -CommandName @( 
        "git","docker","rclone", "systemctl", 
        "hcitool", "flatpak", "scp", "ssh",
        "journalctl", "pacmd", "pactl", "gh"
    ) `
    -ScriptBlock {
    param($commandName, [System.Management.Automation.Language.CommandAst] $commandAst, $cursorPosition)
    $bashcomplete = $commandAst.Extent.Text
    if ($cursorPosition -gt $commandAst.Extent.Text.Length) {
        $bashcomplete += " "
    }
    bash $PSScriptRoot/get_bashcompletions.sh $bashcomplete
    | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}
