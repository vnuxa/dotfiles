{ lib, ... }:
let
    inherit (lib) mkOption;
in {
    options = {
        nix-neovim.current-theme = mkOption {
            type = lib.types.enum [ "darky-purple" ];
            default = "darky-purple";
            description = "Sets the string as the neovim theme";
        };

        theme = {
            wallpaper = mkOption {
                type = lib.types.str;
                default = "night.jpg";
                description = "Sets the default wallpaper to specified one in ~/Pictures/wallpapers/";
            };

            hyprland = {
                dot-name = mkOption {
                    type = lib.types.enum [ "snowy" "aesthetic" ];
                    default = "aesthetic";
                    description = "Which hyprland and ags configuration to use";
                };
            };
        };
    };
}
