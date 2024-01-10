{ config, pkgs, nixneovim, lib, osConfig, ...}: 
{
    programs.nixneovim = { #TODO: make this in to a seperate folder/module instead!
      enable = true;
      globals.mapleader = " ";
      globals.maplocalleader = " ";

      plugins = import ./nvim_configs/plugins_main.nix ;
      options = import ./nvim_configs/options_main.nix;
      mappings = import ./nvim_configs/keymaps.nix;
      extraPlugins = with pkgs.vimExtraPlugins; [ 
        veil-nvim 
        which-key-nvim
        workspaces-nvim
        NeoTerm-lua
        stcursorword
        url-open
        nvim-toggler
        code-runner-nvim
        smart-pairs
        nui-nvim
        neo-tree-nvim
        palette-nvim
        nvim-navic
        barbecue-nvim
        #TODO: add telescope extensions (fzf-native and file-browser)
        bg-nvim #once it updates use and configure this
        telescope-file-browser-nvim
      ];

      extraLuaPreConfig = ''
        do -- add vscode lua snippets (support a lot of languages)
          require('luasnip.loaders.from_vscode').lazy_load()
        end
      '';
      extraLuaPostConfig = import ./nvim_configs/extra_config.nix { config = config; }; 
      
  };
}
