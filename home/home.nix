{ lib, config, pkgs, inputs, ... }:
{
    imports = [
        # import various setup configurations
        ./setups/imports.nix
    ];
    # to customize wallppaer from where its like this
    # theme.wallpaper = "messy-tech-wallpaper.gif";

    home.username = "vnuxa";
    home.homeDirectory = "/home/vnuxa";
    home.stateVersion = "23.05";

    nixpkgs.config.allowUnfreePredicate = _: true;

    programs.home-manager.enable = true;
}
