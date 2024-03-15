{ pkgs, config, lib, inputs, ... }:
{
    # this will make it so that the current dotfile will use pywal's generated colorscheme
    config.home.file."color_gen.sh".source =
        let
            script = pkgs.writeShellScriptBin "color_gen.sh" ''
                ${pkgs.pywal}/bin/wal -c
                ${pkgs.pywal}/bin/wal -i ~/Pictures/wallpapers/${config.theme.wallpaper} -n -t -s -e -q 
                cp ~/.cache/wal/colors-waybar.css ~/.config/home-manager/setups/hyprland/dots/${config.theme.hyprland.dot-name}/ags/pywal-colors.css
                cp ~/.cache/wal/colors.json ~/.config/home-manager/setups/hyprland/dots/${config.theme.hyprland.dot-name}/wal/colors.json
                
            '';
        in
            "${script}/bin/color_gen.sh";
}
