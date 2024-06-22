{ config, pkgs, lib, ... }:
{
    # TODO: fix/implement hyprcursor
    home.pointerCursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Original-Classic";
        size = 8;
        gtk.enable = true;
        x11.enable = true;
    };

    gtk = {
        enable = true;
        font.name = "Torus Regular 11";

        gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

        iconTheme = {
            name = "Papirus";
            package = pkgs.papirus-icon-theme;
        };

        theme = {
            name = "phocus";
            package = (pkgs.callPackage ./phocus_theme/phocus-derivation.nix {});
        };

        gtk3.extraConfig = {
            gtk-xft-antialias = 1;
            gtk-xft-hinting = 1;
            gtk-xft-hintstyle = "hintslight";
            gtk-xft-rgba = "rgb";
            gtk-application-prefer-dark-theme = 1;
        };

        gtk2.extraConfig = ''
            gtk-xft-antialias=1
            gtk-xft-hinting=1
            gtk-xft-hintstyle="hintslight"
            gtk-xft-rgba="rgb"
        '';

        gtk4.extraConfig = { gtk-application-prefer-dark-theme = 1; };
    };
}
