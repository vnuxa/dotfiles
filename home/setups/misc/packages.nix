{
  lib,
  inputs,
  pkgs,
  ...
}: {
  # bunch of other packages that dont fit anywhere
  home.packages = with pkgs; [
    # file manager
    gnome.nautilus
    # file explorer
    cinnamon.nemo
    # system resource viewer
    htop
    btop
    # text editing
    gnome-text-editor

    gparted

    mono
    gcc
    libstdcxx5
    unzip
    libclang

    # for logitech mouse
    libratbag
    piper
    # document editing
    libreoffice
  ];
}
