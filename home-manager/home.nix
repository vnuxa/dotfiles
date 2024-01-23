# this is essentially a function, nixos reads the first expression (aka the function)
# since nixos doesnt care how many spaces/whitespaces you have this is all technically 1 line
# what rebuild does is passes the arguments needed and then runs the function
# instead of depending expressions on lines nixos depends on ; to determine expressions 
# the ? symbol can be used to explainn default values (like { a ? 100, b, }: a + b; will make it so that a is 100 by default)
# you can add a triple dot to ignore additional set(aka table in lua) attributes(aka values) UNLESS you add a @ symbol and the name at the end
# for example { a ? 100, b, ... }@args: a+b; will make it so that all extra attributes will be in that specified symbol, without having to write them all down
# the inherit bassicaly brings values from the current scope.

{ config, pkgs, ags, nixneovim, ... }: # function arguments

# the actual function and its return expression 
{ 
  #? import all varius setups / configs
  imports  = [
    ./setups/configuration_variables.nix
    ./setups/vnuxa-options.nix # all of the configuration options for my main desktop
    ./setups/gaming.nix
    ./setups/spicetify.nix
    ./setups/hyprland/hyprland.nix
    ./setups/hyprland/hyprland_scripts.nix
    ./setups/themes.nix
    ./setups/sh.nix
    ./setups/theme_configurations.nix

    ags.homeManagerModules.default # importing ags
    nixneovim.nixosModules.default
    ./setups/development/neovim.nix
  ];

  # custom setups configurations
  # theme.wallpaper = "messy-tech-wallpaper.gif";
  
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "vnuxa";
  home.homeDirectory = "/home/vnuxa";

  home.stateVersion = "23.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  nixpkgs.config.allowUnfreePredicate = _: true;

  #TODO: switch to snowball lib for overlay addition so you can configure any file easily

  home.packages = [
    # pkgs.hello
    pkgs.r2modman
    # Web & media
    # pkgs.firefox
    pkgs.kate
    pkgs.webcord-vencord
    pkgs.armcord
    pkgs.vlc
    pkgs.mpv # going to be my main video playing thing
    pkgs.imv

    pkgs.libsForQt5.dolphin
    pkgs.gparted

    # editing
    pkgs.vscodium
      # for development
      pkgs.git

    # browser
    # pkgs.floorp

    # pkgs.vscode
    pkgs.pinta # for editing images
    # pkgs.libreoffice#? use libreoffice instead of the qt version for kde!
    # pkgs.libreoffice-qt # it crashes, use google drive or ms office on web instead.
    
    # setting application
    pkgs.gnome3.gnome-tweaks

    # download applications
    pkgs.gnome.gnome-software
    pkgs.gnome.nautilus
    # pkgs.networkmanager
    # pkgs.networkmanagerapplet

    # general packages
    # pkgs.nvtop
    pkgs.mission-center # task manager application
    pkgs.htop
    pkgs.neofetch

    # text editing
    pkgs.gnome-text-editor

    # audio effects
    pkgs.easyeffects

    #terminal
    pkgs.kitty

    # for managing my laptop fans and stuff
    # pkgs.lenovo-legion 

    #etc
    pkgs.gcc
    pkgs.libstdcxx5
    pkgs.unzip
    pkgs.libclang
    # pkgs.lua-language-server
    pkgs.lua
    pkgs.python3

    pkgs.icon-library

    # for logitech mouse
    pkgs.libratbag
    pkgs.piper
    # pkgs.rustup #NOTE: youd have ot install manually
    # pkgs.rust-analyzer
  ];
  nixpkgs.overlays = [
    (self: super: {
      mpv = super.mpv.override {
        scripts = [
          self.mpvScripts.mpris
          self.mpvScripts.thumbfast
          self.mpvScripts.uosc
        ];
      };
    })
    nixneovim.overlays.default
  ];

  # program settings 
  programs = { 
    ags = {
      enable = true;
      extraPackages = [ pkgs.libsoup_3 ];
      configDir = (./. + ("/setups/hyprland/dots/" + config.theme.hyprland.dot-name + "/ags"));
      # configDir = (./. + "/setups/hyprland/dots/snowy/ags");
    };
    # neovim = {
      # defaultEditor = true;
    # };
    # nixneovim = { #TODO: make this in to a seperate folder/module instead!
    #   enable = true;
    #   # extraConfigVim = ''
    #   #   ${/home/vnuxa/.config/old_nvim/init.lua}
    #   # '';
    # };
    # mission-center.enable = true;
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {

  };

  home.sessionVariables = {
    PATH="$HOME/.local/share/nvim/mason/bin/:$PATH";
    EDITOR = "neovim";
    # EDITOR = "emacs";
  };
  
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

#* to apply home manager changes, run this command
#* home-manager-switch  
