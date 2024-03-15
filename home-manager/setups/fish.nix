{ config, pkgs, lib, osConfig, ...}:
{
    home.packages = with pkgs; [
        zoxide # makes cd so much better
        fastfetch
    ];
    programs = {
        zoxide = {
            enable = true;
            enableFishIntegration = true;
        };
        
        fish = {
            enable = true;
            interactiveShellInit = ''
                set fish_greeting # removes the default fish greeter 
            
                # test
            '';
            shellInit = ''
                starship init fish | source
                zoxide init fish | source
            '';
            shellAliases = {
                cd = "z"; # change directory (smartly)
                cds = "zi"; # change directory selection
            };
        };
    };
}
