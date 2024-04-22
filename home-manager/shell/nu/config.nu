
$env.config = {
    shell_integration = true
}

alias cd = z
alias cds = zi

# cat whenever you open terminal
def banner [] {
    let cat = [
        "  ╱|、"
        "(˚ˎ 。7"
        " |、˜〵"
        "じしˍ,)ノ"
    ]
    $cat | each {|line| print $line}
}

banner
