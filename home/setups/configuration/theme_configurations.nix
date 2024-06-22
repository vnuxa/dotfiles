{ pkgs, config, inputs, ... }:
{
    config.xdg.configFile."swappy/config".text = ''
        [Default]
        early_exit=true
        text_font=Torus
        show_panel=true
        paint_mode=text
    '';


    config = {
        home.file."wallpaper_script.sh".source =
            let
                script = pkgs.writeShellScriptBin "wallpaper_script.sh" ''
                    ${pkgs.swww}/bin/swww img ~/Pictures/wallpapers/${config.theme.wallpaper}
                '';
            in
            "${script}/bin/wallpaper_script.sh";
    };
}
