{ config, pkgs, lib, ... }:

{
 programs = {
    kitty = {
      enable = true;
      settings = {
        font_family = "JetBrains Mono Regular Nerd Font Complete";
        font_size = 12;
      };
    };
  };
}
