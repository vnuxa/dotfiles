{ pkgs, ... }:
{
    # import all the files relating to configuration
    imports = [
        ./options.nix
        ./theme_configurations.nix
        ./themes.nix
    ];

    home.packages = with pkgs; [
        # gnome settings application
        gnome3.gnome-tweaks
        # download flatpak stuff
        gnome.gnome-software

        # icons
        icon-library
    ];
}
