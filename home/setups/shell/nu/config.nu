
$env.config = {
    shell_integration: true
    use_kitty_protocol: true
}

# alias cd = z
alias cds = zi


# nh helper
# it shortens some nh commands
def 'nhh' [
] {
    print "no sub-command specified, try looking running `nhh --help`"
}

# rebuilds home-manager
def 'nhh home' [] {
    nh home switch ~/.config/dotfiles/home/
}

# updates the home-manager packages
def 'nhh home update' [] {
    nh home switch ~/.config/dotfiles/home/ --update
}

# rebuilds system
def 'nhh os' [] {
    nh os switch ~/.config/dotfiles/system/main/ 
}

# updates system packages
def 'nhh os update' [] {
    nh os switch ~/.config/dotfiles/system/main/ --update
}

# cleans the system files
def 'nhh clean' [] {
    nh clean all --keep 5
}

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
