{ config, lib, pkgs, nix-gaming, ... }:

{
  home.packages = [
    # Launchers
    pkgs.steam 
    #pkgs.steam-run #? steam runtime which uses nix packages istead of steam ones
    # pkgs.lutris #? ill use heroic 
    # pkgs.grapejuice
    pkgs.heroic
    # Wine
    nix-gaming.packages.${pkgs.system}.wine-ge
    # pkgs.bottles
    pkgs.winetricks
  ];

}