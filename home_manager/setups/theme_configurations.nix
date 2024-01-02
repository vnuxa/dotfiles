{ pkgs, config, lib, inputs, ... }:

{
  
  # home-manager.users.vnuxa = {
    config.xdg.configFile."swappy/config".text =  ''
      [Default]
      early_exit=true
      text_font=Torus
      show_panel=true
      paint_mode=text
    '';
    

  # };
  options = {
    theme = {
      wallpaper = lib.mkOption {
        default = "snow.jpg";
        type = lib.types.str;
        description = ''
          Wallpaper name and extension
        '';
      };
    };
  };

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
