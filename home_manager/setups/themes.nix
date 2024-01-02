{ config, pkgs, lib, ... }:

{
  # home.pointerCursor = {
  #   package = pkgs.numix-cursor-theme;
  #   name = "Numix-Cursor-Light";
  #   size = 20;
  #   gtk.enable = true;
  #   x11.enable = true;
  # };

  gtk = {
    enable = true;
    font.name = "Torus Regular 11";

    theme = {
      # name = "rose-pine-gtk";
      # package = pkgs.rose-pine-gtk-theme;
      name = "Tokyonight-Dark-BL-LB";
      package = pkgs.tokyo-night-gtk; #? for gtk themes you have to import manually since nixos doesnt work weirdly
    };

    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme=1;
      # gtk-application-prefer-light-theme=1;
    };
    
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme=1;
      # gtk-application-prefer-light-theme=1;
    };
  };

}
