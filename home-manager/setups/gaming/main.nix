{ config, lib, pkgs, nix-gaming, ... }:

{
  home.packages = [
    # Launchers
    pkgs.steam 
    pkgs.gamemode
    #pkgs.steam-run #? steam runtime which uses nix packages istead of steam ones
    # pkgs.lutris #? ill use heroic 
    # pkgs.grapejuice
    pkgs.heroic
    # Wine
    # nix-gaming.packages.${pkgs.system}.wine-ge
    # pkgs.bottles
    pkgs.winetricks
    # For running roblox
    # pkgs.vinegar
    # for minecraft
    pkgs.prismlauncher
    pkgs.openjdk8-bootstrap

    pkgs.mindustry-wayland
    # pkgs.logmein-hamachi# for connecting stuff remotly (mostly mindustry)
    # pkgs.haguichi #FIXME: hamachi service dont work, make a script that enables hamachi
    # because hamachi script needs to run (/etc/init.d/logmein-hamachi)
  ];

}
